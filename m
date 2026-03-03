Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0836AEB364A
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 01:00:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 900546B00E5; Mon,  2 Mar 2026 20:00:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 876716B00E8; Mon,  2 Mar 2026 20:00:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74D8B6B00EA; Mon,  2 Mar 2026 20:00:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 557166B00E5
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:00:47 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DD555160462
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 01:00:46 +0000 (UTC)
X-FDA: 84502946892.09.69C9E32
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3F2FC1A0014
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 01:00:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3OFbP1+N;
	spf=pass (imf19.hostedemail.com: domain of 3uzKmaQ4KCA4x25ro15wqvo5r6u22uzs.q20zw18B-00y9oqy.25u@flex--jordanrichards.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3uzKmaQ4KCA4x25ro15wqvo5r6u22uzs.q20zw18B-00y9oqy.25u@flex--jordanrichards.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772499645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mfeVH3tlpXkPPnmAI2AR7odlrVEab2813t68CJAClt4=;
	b=EzNkIpoUTrR4gueFldX46xsGAgrHClBhimH9vDM7N351WFWqiM1IJMgsgGbfbBB+Ph222+
	EKYw/2tgB7FZEiEQA0DFzEj/8DQVJ9UHqJGog+hNm+RWN+b+DUb9eMyn8NSKmkNi/1vHQg
	3boF3djsruqP+mbrGR4MB4b7/hbgfRc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3OFbP1+N;
	spf=pass (imf19.hostedemail.com: domain of 3uzKmaQ4KCA4x25ro15wqvo5r6u22uzs.q20zw18B-00y9oqy.25u@flex--jordanrichards.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3uzKmaQ4KCA4x25ro15wqvo5r6u22uzs.q20zw18B-00y9oqy.25u@flex--jordanrichards.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772499645; a=rsa-sha256;
	cv=none;
	b=Z6edDqnS4rNxjjlIZLI0xquNrjapCpzZ8iS5/Q91y813mUT9C7VsMON70mkRVH6ijSt+Jq
	XY6rxUYyc4w9rHmhmfZASVvW0Bd0/LRzVCMvsIcdPs42S4Vc62dz88lirqGGnZ+z+EjJ3y
	k4fYGcKudSJ652oMgbPjIFxt8OwqgQM=
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2be232ef3d3so2126347eec.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 17:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772499644; x=1773104444; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mfeVH3tlpXkPPnmAI2AR7odlrVEab2813t68CJAClt4=;
        b=3OFbP1+Nt8+af9MnkTzaRYEu4yQmMtGqlLL48ABw6eSx5/5ReKI+FgM/LFY0jqeBkt
         aslEJsOV7ScahEiHyBIVGo9c0BOJw3DoX2E0b1Nu9Sg2a7Kuhgno6nIGsOxmM7DxaDPX
         FKXG1aI3eVqw+tcKTvd2g2fCVYeeYjfp5jUmOtbzNSOaYddvp4LHCKKkdFRW1juRIbJ3
         tGiQrnE6PY3MsbK7VfXD5fUVX/UFG1NYkDFCQV/G9E9ZRRoBRyd5JWTxfXrFCCLqvFtl
         qlGfWs/e0nFe5pc2rVUNdbv6PKAyXQsoRHeHlncjlwMJVTbLPktS2DusC+jsU4xCQsl7
         /V7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772499644; x=1773104444;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mfeVH3tlpXkPPnmAI2AR7odlrVEab2813t68CJAClt4=;
        b=racqwN0PeJaFfdW4W2NDziFYMFueQ9SnDkQT6EvadhP6eHjQVuyJA1vMwIPt6P4JuY
         RCN7dPu2UVY6X9zImfUVnI9Ch8T0wPsuM7z6xuGZP8PI6SddNHcgFx43Gthf12fumEQR
         D0IZuyBboRh0ITezwZS15GtaTQubowRybySCrxAreqa9aYQI3pOS5Q8t5HQQnbVAyoPR
         ueblF7ZDd1Ka20/j8bGFfX8djftrqYVyJT8WFreqUT5YuiEahNlojFdA6kvlpQxllRvJ
         1lCXVeHEIlhPpAwtRl8gKXOv0pQPtpcaIzBy6JKBYG7/xTJ00wzDpTCNG/66m8mE2ZBv
         dxQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmHdRxx0TNNIQYNbxBiFvm9xTqHje0TY96TSb5ZkRpJwW8vCBJXidtVewQY+cpen8yq/x6gB5BLw==@kvack.org
X-Gm-Message-State: AOJu0YyL9fVFQLh10sM5qOEjylvqu3jVVKoKUzZJU6nn8fLnc2jFhvoz
	VYmBOYU7LrOj2BHiMfdQg/2OjGXu2/+6w75VzneAS40nANa25UBF2tC4hY4Z2VidKfhsS2WfAj6
	v7NQKOjTCci7IvlhdmQ/0PGD6iUFFiXRW9Lc2Ow==
X-Received: from dybsl12.prod.google.com ([2002:a05:7301:730c:b0:2bd:fcea:a76f])
 (user=jordanrichards job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:caa:b0:2be:140c:bc4a with SMTP id 5a478bee46e88-2be140cbf63mr2054909eec.3.1772499643785;
 Mon, 02 Mar 2026 17:00:43 -0800 (PST)
Date: Tue,  3 Mar 2026 01:00:39 +0000
In-Reply-To: <20260303010039.2969125-1-jordanrichards@google.com>
Mime-Version: 1.0
References: <20260303010039.2969125-1-jordanrichards@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260303010039.2969125-3-jordanrichards@google.com>
Subject: [PATCH v3 2/2] selftests/liveupdate: add end to end test
 infrastructure and scripts
From: Jordan Richards <jordanrichards@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Shuah Khan <shuah@kernel.org>, Willy Tarreau <w@1wt.eu>, 
	"=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?=" <linux@weissschuh.net>
Cc: Jason Miu <jasonmiu@google.com>, David Matlack <dmatlack@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jordan Richards <jordanrichards@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 3F2FC1A0014
X-Rspamd-Server: rspam07
X-Stat-Signature: csujpjodrk4qyosgz7mja8c8m857hg3f
X-Rspam-User: 
X-HE-Tag: 1772499645-671027
X-HE-Meta: U2FsdGVkX1+TGioWjHm7cTR2UXCUBrn6CqgXTYu7omWJBS7Ltem3vfq//ADRfEUQ40+yyNkYu8qbNIxX3PuWTQeoTYkA4wdQhEA/kIQWSuK2mlXMp48Clzk4ATjN8jx/oY8FGUy8A/k2Kl+pVpcsemHMtwu/7LqNfO2gBkireuoOxPVQSsWMg74FBJQFm2iK9XZwfg95/st49jDCzV9PzjcUzn3UiXwfZ3dyu9JsSMB7pUwu0EE68/SqrzzNt4Loj0F+Y6S5h/aEj/uWL/gUuWYblaAdElPI9P9P9fhbEssLSRcF/wuwXdLDbo5inqvfuOfkOvoUqt97ZiEtmn7njLVW6zcoyHSObcJRrjeVk6GWbrXs55NO7maVzGH4GQjYRlZcSBmBhMrlPVKXu0AXYg/vRjodU2Z/4LaqL+E5UHy7T96kaqsZg/pVc8sDztlYGVfjD734mDE4wEgMs8YU8pbdormfpjJAMGQhZVOesw8Y6NyJbq8frxML1QP/aRKDnsg3mq4srPMwI3NUON0+H38Q+rg/wdkEWjWjG0MisItptWeNGX+iext6KcNfgjrnAdJIQScaizxTPq8qbBI5NGnF0mXO43QMXj00xvvDK+zI3J5PP0RKedqLhrCOZhp8YQtU6TLa2gR2GvOkEqSYAjrY9BhWjNlm7E2n79mx7zU+YeyYusCCf0gFFUfPVmKla26RzKFeh7pbCyshMofh0v5BxdzbOW+L3VuzSRqjBDJ6a+JgNZ8kSfHbRH9CNlRfO0PtoBBSBygNTzR+Jo8nJRz0SayccEs48BG78Q4W2QeQ0mnGc7mBoiEzO4QKiqJvJ5EoIeWWMdxbTFV3UNihfFthEsHQZ1HlYSxieYmlEQHdmmD2CHEDOBF102TDfdHQAXJQ/K4wel2158ieZ2QikVfToZoA4sJJpgf9TdWNFSRjmmWd5BJ4+X7hDzhvF0BgGldmbVKtKM9iZ+v4wrv
 zL0SN+Hb
 fue0xraNrDuj4lBx+udw9OZedXDwL+fHidjmGwxoeWSstLeh0AzjDxiDVE+eC3wHYhavmoJ4nuYJ+7bkUjpiRWebTsyS3JoKAcBzfg7JShGDez6n6/gGtA8O5SRnYLX+buX0oSm7ew9j2+F6TzXmx8vdiJlfIn3OH7SoJcto1wo6JKQM4nZ7j3Y1OWyFHn49+RbMJ2snEqQj4lD3pDKBHXWT0TxlW2/vA+w8r/BldH3unegrsIemwNXt1OKsAOHT8guD+dgL0BK8LtR9RVUVdJ/DjinjqIKNbXHoG8GQXP5IbvDe+FyKzd1Bn+78xW55FKvCOpoRj+U5RtuU7MtJLpD3CK3vSjolKHs11ZMSdt5TrdO8S8PtU42PcCj5/9Y6Ug8JgEVyBJ54QtstG0E6X3VaZwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pasha Tatashin <pasha.tatashin@soleen.com>

Add the end to end testing infrastructure required to verify the
liveupdate feature. This includes a custom init process, a test
orchestration script, and a batch runner.

The framework consists of:

init.c:
A lightweight init process that manages the kexec lifecycle.
It mounts necessary filesystems, determines the current execution
stage (1 or 2) via the kernel command line, and handles the
kexec_file_load() sequence to transition between kernels.

luo_test.sh:
The primary KTAP-compliant test driver. It handles:
- Kernel configuration merging and building.
- Cross-compilation detection for x86_64 and arm64.
- Generation of the initrd containing the test binary and init.
- QEMU execution with automatic accelerator detection (KVM, HVF,
 or TCG).

run.sh:
A wrapper script to discover and execute all `luo_*.c`
tests across supported architectures, providing a summary of
pass/fail/skip results.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Co-developed-by: Jordan Richards <jordanrichards@google.com>
Signed-off-by: Jordan Richards <jordanrichards@google.com>
---
 tools/testing/selftests/liveupdate/.gitignore |   1 +
 tools/testing/selftests/liveupdate/config     |   1 +
 .../selftests/liveupdate/config.aarch64       |   2 +
 .../selftests/liveupdate/config.x86_64        |   2 +
 tools/testing/selftests/liveupdate/init.c     | 179 ++++++++++++
 .../testing/selftests/liveupdate/luo_test.sh  | 276 ++++++++++++++++++
 .../selftests/liveupdate/luo_test_utils.c     |  23 +-
 tools/testing/selftests/liveupdate/run.sh     |  63 ++++
 8 files changed, 534 insertions(+), 13 deletions(-)
 create mode 100644 tools/testing/selftests/liveupdate/config.aarch64
 create mode 100644 tools/testing/selftests/liveupdate/config.x86_64
 create mode 100644 tools/testing/selftests/liveupdate/init.c
 create mode 100755 tools/testing/selftests/liveupdate/luo_test.sh
 create mode 100755 tools/testing/selftests/liveupdate/run.sh

diff --git a/tools/testing/selftests/liveupdate/.gitignore b/tools/testing/selftests/liveupdate/.gitignore
index 661827083ab6..cb08ddb0dfee 100644
--- a/tools/testing/selftests/liveupdate/.gitignore
+++ b/tools/testing/selftests/liveupdate/.gitignore
@@ -6,4 +6,5 @@
 !*.sh
 !.gitignore
 !config
+!config.*
 !Makefile
diff --git a/tools/testing/selftests/liveupdate/config b/tools/testing/selftests/liveupdate/config
index 91d03f9a6a39..016d009dba13 100644
--- a/tools/testing/selftests/liveupdate/config
+++ b/tools/testing/selftests/liveupdate/config
@@ -1,4 +1,5 @@
 CONFIG_BLK_DEV_INITRD=y
+CONFIG_DEVTMPFS=y
 CONFIG_KEXEC_FILE=y
 CONFIG_KEXEC_HANDOVER=y
 CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=y
diff --git a/tools/testing/selftests/liveupdate/config.aarch64 b/tools/testing/selftests/liveupdate/config.aarch64
new file mode 100644
index 000000000000..445716403925
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/config.aarch64
@@ -0,0 +1,2 @@
+CONFIG_SERIAL_AMBA_PL011=y
+CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
diff --git a/tools/testing/selftests/liveupdate/config.x86_64 b/tools/testing/selftests/liveupdate/config.x86_64
new file mode 100644
index 000000000000..810d9c9d213e
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/config.x86_64
@@ -0,0 +1,2 @@
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
diff --git a/tools/testing/selftests/liveupdate/init.c b/tools/testing/selftests/liveupdate/init.c
new file mode 100644
index 000000000000..fb08bd58b9b9
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/init.c
@@ -0,0 +1,179 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+#include <fcntl.h>
+#include <linux/kexec.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mount.h>
+#include <sys/reboot.h>
+#include <sys/syscall.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#define COMMAND_LINE_SIZE 2048
+#define KERNEL_IMAGE "/kernel"
+#define INITRD_IMAGE "/initrd.img"
+#define TEST_BINARY "/test_binary"
+
+static int mount_filesystems(void)
+{
+	if (mount("devtmpfs", "/dev", "devtmpfs", 0, NULL) < 0) {
+		fprintf(stderr, "INIT: Warning: Failed to mount devtmpfs\n");
+		return -1;
+	}
+
+	if (mount("debugfs", "/debugfs", "debugfs", 0, NULL) < 0) {
+		fprintf(stderr, "INIT: Failed to mount debugfs\n");
+		return -1;
+	}
+
+	if (mount("proc", "/proc", "proc", 0, NULL) < 0) {
+		fprintf(stderr, "INIT: Failed to mount proc\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+static long kexec_file_load(int kernel_fd, int initrd_fd,
+			    unsigned long cmdline_len, const char *cmdline,
+			    unsigned long flags)
+{
+	return syscall(__NR_kexec_file_load, kernel_fd, initrd_fd, cmdline_len,
+		       cmdline, flags);
+}
+
+static int kexec_load(void)
+{
+	char cmdline[COMMAND_LINE_SIZE];
+	int kernel_fd, initrd_fd, err;
+	ssize_t len;
+	int fd;
+
+	fd = open("/proc/cmdline", O_RDONLY);
+	if (fd < 0) {
+		fprintf(stderr, "INIT: Failed to read /proc/cmdline\n");
+
+		return -1;
+	}
+
+	len = read(fd, cmdline, sizeof(cmdline) - 1);
+	close(fd);
+	if (len < 0)
+		return -1;
+
+	cmdline[len] = 0;
+	if (len > 0 && cmdline[len - 1] == '\n')
+		cmdline[len - 1] = 0;
+
+	strncat(cmdline, " luo_stage=2", sizeof(cmdline) - strlen(cmdline) - 1);
+
+	kernel_fd = open(KERNEL_IMAGE, O_RDONLY);
+	if (kernel_fd < 0) {
+		fprintf(stderr, "INIT: Failed to open kernel image\n");
+		return -1;
+	}
+
+	initrd_fd = open(INITRD_IMAGE, O_RDONLY);
+	if (initrd_fd < 0) {
+		fprintf(stderr, "INIT: Failed to open initrd image\n");
+		close(kernel_fd);
+		return -1;
+	}
+
+	err = kexec_file_load(kernel_fd, initrd_fd, strlen(cmdline) + 1,
+			      cmdline, 0);
+
+	close(initrd_fd);
+	close(kernel_fd);
+
+	return err;
+}
+
+static int run_test(int stage)
+{
+	char stage_arg[32];
+	int status;
+	pid_t pid;
+
+	snprintf(stage_arg, sizeof(stage_arg), "%d", stage);
+
+	pid = fork();
+	if (pid < 0)
+		return -1;
+
+	if (!pid) {
+		char *const argv[] = {TEST_BINARY, "-s", stage_arg, NULL};
+
+		execve(TEST_BINARY, argv, NULL);
+		fprintf(stderr, "INIT: execve failed\n");
+		_exit(1);
+	}
+
+	waitpid(pid, &status, 0);
+
+	return (WIFEXITED(status) && WEXITSTATUS(status) == 0) ? 0 : -1;
+}
+
+static int get_current_stage(void)
+{
+	char cmdline[COMMAND_LINE_SIZE];
+	ssize_t len;
+	int fd;
+
+	fd = open("/proc/cmdline", O_RDONLY);
+	if (fd < 0)
+		return -1;
+
+	len = read(fd, cmdline, sizeof(cmdline) - 1);
+	close(fd);
+
+	if (len < 0)
+		return -1;
+
+	cmdline[len] = 0;
+
+	return strstr(cmdline, "luo_stage=2") ? 2 : 1;
+}
+
+int main(int argc, char *argv[])
+{
+	int current_stage;
+	int err;
+
+	if (mount_filesystems())
+		goto err_reboot;
+
+	current_stage = get_current_stage();
+	if (current_stage < 0) {
+		fprintf(stderr, "INIT: Failed to read cmdline");
+		goto err_reboot;
+	}
+
+	printf("INIT: Starting Stage %d\n", current_stage);
+
+	if (current_stage == 1 && kexec_load()) {
+		fprintf(stderr, "INIT: Failed to load kexec kernel\n");
+		goto err_reboot;
+	}
+
+	if (run_test(current_stage)) {
+		fprintf(stderr, "INIT: Test binary returned failure\n");
+		goto err_reboot;
+	}
+
+	printf("INIT: Stage %d completed successfully.\n", current_stage);
+	reboot(current_stage == 1 ? RB_KEXEC : RB_AUTOBOOT);
+
+	return 0;
+
+err_reboot:
+	reboot(RB_AUTOBOOT);
+
+	return -1;
+}
diff --git a/tools/testing/selftests/liveupdate/luo_test.sh b/tools/testing/selftests/liveupdate/luo_test.sh
new file mode 100755
index 000000000000..1520711b1d35
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/luo_test.sh
@@ -0,0 +1,276 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+set -ue
+
+CROSS_COMPILE="${CROSS_COMPILE:-""}"
+
+test_dir=$(realpath "$(dirname "$0")")
+kernel_dir=$(realpath "$test_dir/../../../..")
+
+workspace_dir=""
+headers_dir=""
+initrd=""
+KEEP_WORKSPACE=0
+
+source "$test_dir/../kselftest/ktap_helpers.sh"
+
+function get_arch_conf() {
+	local arch=$1
+	if [[ "$arch" == "arm64" ]]; then
+		QEMU_CMD="qemu-system-aarch64 -M virt -cpu max"
+		KERNEL_IMAGE="Image"
+		KERNEL_CMDLINE="console=ttyAMA0"
+	elif [[ "$arch" == "x86" ]]; then
+		QEMU_CMD="qemu-system-x86_64"
+		KERNEL_IMAGE="bzImage"
+		KERNEL_CMDLINE="console=ttyS0"
+	else
+		echo "Unsupported architecture: $arch"
+		exit 1
+	fi
+}
+
+function usage() {
+	cat <<EOF
+$0 [-d build_dir] [-j jobs] [-t target_arch] [-T test_name] [-w workspace_dir] [-k] [-h]
+Options:
+	-d)	path to the kernel build directory (default: .luo_test_build.<arch>)
+	-j)	number of jobs for compilation
+	-t)	run test for target_arch (aarch64, x86_64)
+	-T)	test name to run (default: luo_kexec_simple)
+	-w)	custom workspace directory (default: creates temp dir)
+	-k)	keep workspace directory after successful test
+	-h)	display this help
+EOF
+}
+
+function cleanup() {
+	local exit_code=$?
+
+	if [ -z "$workspace_dir" ]; then
+		ktap_finished
+		return
+	fi
+
+	if [ $exit_code -ne 0 ]; then
+		echo "# Test failed (exit code $exit_code)."
+		echo "# Workspace preserved at: $workspace_dir"
+	elif [ "$KEEP_WORKSPACE" -eq 1 ]; then
+		echo "# Workspace preserved (user request) at: $workspace_dir"
+	else
+		rm -fr "$workspace_dir"
+	fi
+	ktap_print_totals
+
+	exit $exit_code
+}
+trap cleanup EXIT
+
+function skip() {
+	local msg=${1:-""}
+	ktap_test_skip "$msg"
+	exit "$KSFT_SKIP"
+}
+
+function fail() {
+	local msg=${1:-""}
+	ktap_test_fail "$msg"
+	exit "$KSFT_FAIL"
+}
+
+function detect_cross_compile() {
+	local target=$1
+	local host=$(uname -m)
+
+	[[ "$host" == "arm64" ]] && host="aarch64"
+	[[ "$target" == "arm64" ]] && target="aarch64"
+
+	if [[ "$host" == "$target" ]]; then
+		CROSS_COMPILE=""
+		return
+	fi
+
+	if [[ -n "$CROSS_COMPILE" ]]; then
+		return
+	fi
+
+	local candidate=""
+	case "$target" in
+		aarch64) candidate="aarch64-linux-gnu-" ;;
+		x86_64)  candidate="x86_64-linux-gnu-" ;;
+		*)       skip "Auto-detection for target '$target' not supported. Please set CROSS_COMPILE manually." ;;
+	esac
+
+	if command -v "${candidate}gcc" &> /dev/null; then
+		CROSS_COMPILE="$candidate"
+	else
+		skip "Compiler '${candidate}gcc' not found. Please install it (e.g., 'apt install gcc-aarch64-linux-gnu') or set CROSS_COMPILE."
+	fi
+}
+
+function build_kernel() {
+	local build_dir=$1
+	local make_cmd=$2
+	local kimage=$3
+	local target_arch=$4
+
+	local kconfig="$build_dir/.config"
+	local common_conf="$test_dir/config"
+	local arch_conf="$test_dir/config.$target_arch"
+
+	echo "# Building kernel in: $build_dir"
+
+	"$kernel_dir/scripts/kconfig/merge_config.sh" \
+		-Q -m -O "$build_dir" "$common_conf" "$arch_conf" >> /dev/null
+	cat $kconfig
+
+	$make_cmd olddefconfig
+	$make_cmd "$kimage"
+	$make_cmd headers_install INSTALL_HDR_PATH="$headers_dir"
+}
+
+function mkinitrd() {
+	local build_dir=$1
+	local kernel_path=$2
+	local test_name=$3
+
+	# Compile the test binary and the init process
+	"$CROSS_COMPILE"gcc -static -O2 -nostdinc -nostdlib \
+		-I "$headers_dir/include" \
+		-I "$kernel_dir/tools/include/nolibc" \
+		-I "$test_dir" \
+		-o "$workspace_dir/test_binary" \
+		"$test_dir/$test_name.c" "$test_dir/luo_test_utils.c"
+
+	"$CROSS_COMPILE"gcc -s -static -Os -nostdinc -nostdlib		\
+			-fno-asynchronous-unwind-tables -fno-ident	\
+			-fno-stack-protector				\
+			-I "$headers_dir/include"			\
+			-I "$kernel_dir/tools/include/nolibc"		\
+			-o "$workspace_dir/init" "$test_dir/init.c"
+
+	cat > "$workspace_dir/cpio_list_inner" <<EOF
+dir /dev 0755 0 0
+dir /proc 0755 0 0
+dir /debugfs 0755 0 0
+nod /dev/console 0600 0 0 c 5 1
+file /init $workspace_dir/init 0755 0 0
+file /test_binary $workspace_dir/test_binary 0755 0 0
+EOF
+
+	# Generate inner_initrd.cpio
+	"$build_dir/usr/gen_init_cpio" "$workspace_dir/cpio_list_inner" > "$workspace_dir/inner_initrd.cpio"
+
+	cat > "$workspace_dir/cpio_list" <<EOF
+dir /dev 0755 0 0
+dir /proc 0755 0 0
+dir /debugfs 0755 0 0
+nod /dev/console 0600 0 0 c 5 1
+file /init $workspace_dir/init 0755 0 0
+file /kernel $kernel_path 0644 0 0
+file /test_binary $workspace_dir/test_binary 0755 0 0
+file /initrd.img $workspace_dir/inner_initrd.cpio 0644 0 0
+EOF
+
+	# Generate the final initrd
+	"$build_dir/usr/gen_init_cpio" "$workspace_dir/cpio_list" > "$initrd"
+	local size=$(du -h "$initrd" | cut -f1)
+}
+
+function run_qemu() {
+	local qemu_cmd=$1
+	local cmdline=$2
+	local kernel_path=$3
+	local serial="$workspace_dir/qemu.serial"
+
+	cmdline="$cmdline liveupdate=on panic=-1"
+
+	echo "# Serial Log: $serial"
+	timeout 30s $qemu_cmd -m 1G -smp 2 -no-reboot -nographic -nodefaults	\
+		  -accel tcg -accel hvf -accel kvm				\
+		  -serial file:"$serial"					\
+		  -append "$cmdline"						\
+		  -kernel "$kernel_path"					\
+		  -initrd "$initrd"
+
+	local ret=$?
+
+	if [ $ret -eq 124 ]; then
+		fail "QEMU timed out"
+	fi
+
+	grep "TEST PASSED" "$serial" &> /dev/null || fail "Liveupdate failed. Check $serial for details."
+}
+
+function target_to_arch() {
+	local target=$1
+	case $target in
+	     aarch64) echo "arm64" ;;
+	     x86_64) echo "x86" ;;
+	     *) skip "architecture $target is not supported"
+	esac
+}
+
+function main() {
+	local build_dir=""
+	local jobs=$(nproc)
+	local target="$(uname -m)"
+	local test_name="luo_kexec_simple"
+	local workspace_arg=""
+
+	set -o errtrace
+	trap fail ERR
+
+	while getopts 'hd:j:t:T:w:k' opt; do
+		case $opt in
+		d) build_dir="$OPTARG" ;;
+		j) jobs="$OPTARG" ;;
+		t) target="$OPTARG" ;;
+		T) test_name="$OPTARG" ;;
+		w) workspace_arg="$OPTARG" ;;
+		k) KEEP_WORKSPACE=1 ;;
+		h) usage; exit 0 ;;
+		*) echo "Unknown argument $opt"; usage; exit 1 ;;
+		esac
+	done
+
+	ktap_print_header
+	ktap_set_plan 1
+
+	if [ -n "$workspace_arg" ]; then
+		workspace_dir="$(realpath -m "$workspace_arg")"
+		mkdir -p "$workspace_dir"
+	else
+		workspace_dir=$(mktemp -d /tmp/luo-test.XXXXXXXX)
+	fi
+
+	echo "# Workspace created at: $workspace_dir"
+	headers_dir="$workspace_dir/usr"
+	initrd="$workspace_dir/initrd.cpio"
+
+	detect_cross_compile "$target"
+
+	local arch=$(target_to_arch "$target")
+
+	if [ -z "$build_dir" ]; then
+		build_dir="$kernel_dir/.luo_test_build.$arch"
+	fi
+
+	mkdir -p "$build_dir"
+	build_dir=$(realpath "$build_dir")
+	get_arch_conf "$arch"
+
+	local make_cmd="make -s ARCH=$arch CROSS_COMPILE=$CROSS_COMPILE -j$jobs"
+	local make_cmd_build="$make_cmd -C $kernel_dir O=$build_dir"
+
+	build_kernel "$build_dir" "$make_cmd_build" "$KERNEL_IMAGE" "$target"
+
+	local final_kernel="$build_dir/arch/$arch/boot/$KERNEL_IMAGE"
+	mkinitrd "$build_dir" "$final_kernel" "$test_name"
+
+	run_qemu "$QEMU_CMD" "$KERNEL_CMDLINE" "$final_kernel"
+	ktap_test_pass "$test_name succeeded"
+}
+
+main "$@"
diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.c b/tools/testing/selftests/liveupdate/luo_test_utils.c
index 3c8721c505df..084d76cd79d2 100644
--- a/tools/testing/selftests/liveupdate/luo_test_utils.c
+++ b/tools/testing/selftests/liveupdate/luo_test_utils.c
@@ -20,6 +20,7 @@
 #include <sys/stat.h>
 #include <errno.h>
 #include <stdarg.h>
+#include <linux/unistd.h>
 
 #include "luo_test_utils.h"
 
@@ -32,8 +33,8 @@ int luo_create_session(int luo_fd, const char *name)
 {
 	struct liveupdate_ioctl_create_session arg = { .size = sizeof(arg) };
 
-	snprintf((char *)arg.name, LIVEUPDATE_SESSION_NAME_LENGTH, "%.*s",
-		 LIVEUPDATE_SESSION_NAME_LENGTH - 1, name);
+	strncpy((char *)arg.name, name, LIVEUPDATE_SESSION_NAME_LENGTH);
+	arg.name[LIVEUPDATE_SESSION_NAME_LENGTH - 1] = '\0';
 
 	if (ioctl(luo_fd, LIVEUPDATE_IOCTL_CREATE_SESSION, &arg) < 0)
 		return -errno;
@@ -45,8 +46,8 @@ int luo_retrieve_session(int luo_fd, const char *name)
 {
 	struct liveupdate_ioctl_retrieve_session arg = { .size = sizeof(arg) };
 
-	snprintf((char *)arg.name, LIVEUPDATE_SESSION_NAME_LENGTH, "%.*s",
-		 LIVEUPDATE_SESSION_NAME_LENGTH - 1, name);
+	strncpy((char *)arg.name, name, LIVEUPDATE_SESSION_NAME_LENGTH);
+	arg.name[LIVEUPDATE_SESSION_NAME_LENGTH - 1] = '\0';
 
 	if (ioctl(luo_fd, LIVEUPDATE_IOCTL_RETRIEVE_SESSION, &arg) < 0)
 		return -errno;
@@ -57,7 +58,7 @@ int luo_retrieve_session(int luo_fd, const char *name)
 int create_and_preserve_memfd(int session_fd, int token, const char *data)
 {
 	struct liveupdate_session_preserve_fd arg = { .size = sizeof(arg) };
-	long page_size = sysconf(_SC_PAGE_SIZE);
+	long page_size = getpagesize();
 	void *map = MAP_FAILED;
 	int mfd = -1, ret = -1;
 
@@ -93,7 +94,7 @@ int restore_and_verify_memfd(int session_fd, int token,
 			     const char *expected_data)
 {
 	struct liveupdate_session_retrieve_fd arg = { .size = sizeof(arg) };
-	long page_size = sysconf(_SC_PAGE_SIZE);
+	long page_size = getpagesize();
 	void *map = MAP_FAILED;
 	int mfd = -1, ret = -1;
 
@@ -204,16 +205,11 @@ void daemonize_and_wait(void)
 
 static int parse_stage_args(int argc, char *argv[])
 {
-	static struct option long_options[] = {
-		{"stage", required_argument, 0, 's'},
-		{0, 0, 0, 0}
-	};
-	int option_index = 0;
 	int stage = 1;
 	int opt;
 
 	optind = 1;
-	while ((opt = getopt_long(argc, argv, "s:", long_options, &option_index)) != -1) {
+	while ((opt = getopt(argc, argv, "s:")) != -1) {
 		switch (opt) {
 		case 's':
 			stage = atoi(optarg);
@@ -224,6 +220,7 @@ static int parse_stage_args(int argc, char *argv[])
 			fail_exit("Unknown argument");
 		}
 	}
+
 	return stage;
 }
 
@@ -251,7 +248,7 @@ int luo_test(int argc, char *argv[],
 		fail_exit("Failed to check for state session");
 
 	if (target_stage != detected_stage) {
-		ksft_exit_fail_msg("Stage mismatch Requested --stage %d, but system is in stage %d.\n"
+		ksft_exit_fail_msg("Stage mismatch Requested stage %d, but system is in stage %d.\n"
 				   "(State session %s: %s)\n",
 				   target_stage, detected_stage, state_session_name,
 				   (detected_stage == 2) ? "EXISTS" : "MISSING");
diff --git a/tools/testing/selftests/liveupdate/run.sh b/tools/testing/selftests/liveupdate/run.sh
new file mode 100755
index 000000000000..5637668ef7b6
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/run.sh
@@ -0,0 +1,63 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+SCRIPT_DIR=$(dirname "$(realpath "$0")")
+OUTPUT_DIR="$SCRIPT_DIR/results_$(date +%Y%m%d_%H%M%S)"
+TEST_RUNNER="$SCRIPT_DIR/luo_test.sh"
+
+TARGETS=("x86_64" "aarch64")
+
+GREEN='\033[0;32m'
+RED='\033[0;31m'
+YELLOW='\033[1;33m'
+NC='\033[0m'
+
+PASSED=()
+FAILED=()
+SKIPPED=()
+
+mkdir -p "$OUTPUT_DIR"
+
+TEST_NAMES=(
+    "luo_kexec_simple"
+    "luo_multi_session"
+)
+
+for arch in "${TARGETS[@]}"; do
+    for test_name in "${TEST_NAMES[@]}"; do
+        log_file="$OUTPUT_DIR/${arch}_${test_name}.log"
+        echo -n "  -> $arch $test_name ... "
+
+        if "$TEST_RUNNER" -t "$arch" -T "$test_name" > "$log_file" 2>&1; then
+            echo -e "${GREEN}PASS${NC}"
+            PASSED+=("${arch}:${test_name}")
+        else
+            exit_code=$?
+            if [ $exit_code -eq 4 ]; then
+                echo -e "${YELLOW}SKIP${NC}"
+                SKIPPED+=("${arch}:${test_name}")
+            else
+                echo -e "${RED}FAIL${NC}"
+                FAILED+=("${arch}:${test_name}")
+            fi
+        fi
+    done
+    echo ""
+done
+
+echo "========================================="
+echo "             TEST SUMMARY                "
+echo "========================================="
+echo -e "PASSED: ${GREEN}${#PASSED[@]}${NC}"
+echo -e "FAILED: ${RED}${#FAILED[@]}${NC}"
+for fail in "${FAILED[@]}"; do
+    echo -e "  - $fail"
+done
+echo -e "SKIPPED: ${YELLOW}${#SKIPPED[@]}${NC}"
+echo "Logs: $OUTPUT_DIR"
+
+if [ ${#FAILED[@]} -eq 0 ]; then
+    exit 0
+else
+    exit 1
+fi
-- 
2.53.0.473.g4a7958ca14-goog


