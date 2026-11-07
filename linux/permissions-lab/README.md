# Linux File Permissions Troubleshooting Lab

## 1. Problem

A deployment script could not execute because
the Linux file did not have execute permission.

Error:

Permission denied

## 2. Environment

- Operating system: Alpine Linux 3.21.8
- Shell: sh
- User: root
- File: linux/deploy-test.sh

## 3. Initial Investigation

Command:

ls -l linux/deploy-test.sh

Initial permissions:

-rw-r--r--

The file owner could read and write the file,
but did not have execute permission.

## 4. Diagnosis

Linux file permissions determine who can:

- Read a file (r)
- Write or modify a file (w)
- Execute a file (x)

The execute permission was missing.

## 5. Resolution

Command:

chmod u+x linux/deploy-test.sh

Explanation:

- chmod: change file permissions
- u: file owner
- +x: add execute permission

## 6. Verification

Command:

ls -l linux/deploy-test.sh

Expected permissions:

-rwxr--r--

Execution:

./linux/deploy-test.sh

Expected output:

Deployment check started

## 7. Failure Simulation

Removed execute permission:

chmod u-x linux/deploy-test.sh

Attempted execution again.

Result:

Permission denied

Restored execute permission and confirmed
that the script executed successfully.

## 8. Production Relevance

This problem can occur with:

- Linux server deployment scripts
- GitHub Actions pipelines
- Docker startup scripts
- Scheduled maintenance scripts
- Automated server administration

## 9. Security Lesson

Avoid using chmod 777 as a quick fix.

It grants read, write and execute permissions
to everyone, potentially allowing unauthorised
modification of deployment scripts.

Use the minimum permissions required.

## 10. Skills Practised

- Inspecting Linux file permissions
- Understanding read, write and execute
- Using chmod
- Diagnosing Permission denied errors
- Testing and verifying a permission fix