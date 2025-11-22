Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE2F9CFD312
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 22:24:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B6DC6B00A8; Sat, 22 Nov 2025 17:24:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 318FA6B00A9; Sat, 22 Nov 2025 17:24:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16AC86B00AA; Sat, 22 Nov 2025 17:24:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EAE506B00A8
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 17:24:37 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B8767160181
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:37 +0000 (UTC)
X-FDA: 84139673394.04.D76A3AF
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id BEF7E1C0005
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QwWAvaFl;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763850275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F5tajeHzp9hDN07gnwZlVCQmxSUhZpHiffHO9VM3nds=;
	b=MDf4m3mjUoA4WQvmKvNye0Pm+cCiLXTQJ6N/nDiYDARdXhqsr/xj/W0HNuyZOy74t+Ix6r
	YZwr8FLEx9gpTty+Mt8DE33en3xNceHaP35gzWMtfGsTj2bgetUH49NKXx7m+D00EGYBnh
	HOMYRYxhYMc7A+yELxr+LaKruzkaydE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763850275; a=rsa-sha256;
	cv=none;
	b=c/GcYdwBLnLKhxh2v7s/7rIn6C9DFQzKehGbHyBM2ly9wqEHAnw6xCiGCxGn0viZwy/ySA
	U5hnPhmjVxMfdisyTySynvbqLsIQbP2aWKlh0L+82BMVUnPmC2V2u9wD+OOjStUChQNvFh
	WJ/wVH+ZeROXVpbFg6aVVl2b3RkddEs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QwWAvaFl;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-78a712cfbc0so30081407b3.1
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 14:24:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763850275; x=1764455075; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F5tajeHzp9hDN07gnwZlVCQmxSUhZpHiffHO9VM3nds=;
        b=QwWAvaFl6qrlnAcgkfCzL2L71zONRKqAoMcI24jGVqU3KpXn/SU+vWVYyvpdM6/bXr
         il3lYbyJsnGmB0VNhIF3jECLM9LsQd6495fkE3Iv2S4yv4ET2nafZ4SE0bJwcfwVlZl4
         czAd324eF9eVVot6QSpY30LTBmF4+XuYVs3s1yR/vCGTHD/7wHD5hH7kFAhLmf11bSY4
         J6r//KmQoe+2UhfzGiVSm5WidMxx794gzUM+6jpe2SbTHFxqY0+xNStxD5yghMrjqapa
         ZxvwggFluLJ+IFkWvYOeURjJmv04XDXWX/hlvDLn3+oP7IRyBRThhdsN0Dv6hBmkmbDS
         coSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763850275; x=1764455075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=F5tajeHzp9hDN07gnwZlVCQmxSUhZpHiffHO9VM3nds=;
        b=X31v2j+MOBL2uiMwYyjvueE+TCV5a9eGoIrBH5yl9WGJi0p5jgS0b6u0gr6me174lT
         qZNu25GQ+3dNjGFLeP4/OzqaKEG7XJeuB3ci+2E1vW7McsM+ZZx/kXkZfMz1Q33eGsR7
         moON4CPcKdp36l1saaPTtLktq+SkzvtyiaIRfcfc4mNjYp3g+Ck8LJQVj/La5h8SCPN8
         afrqwh4NQOu7ujCEwkM2YKzQhNZ5373oCHd4Kg26uG8l3xHgNuuAMKfJJJx6oA1TmmUI
         Md9ztuizvTWCl3GsmBgIqB12AYIaEKb7VELQmHVQEeJE9bIhqdPSYyp4407eSxh8sRTC
         tZbQ==
X-Forwarded-Encrypted: i=1; AJvYcCWodWMzFKslCdARZhnwRFBcL3o02u0UCcIQbpORuaj9vMqU2Imlq7q0B1xz1R8GQgf/0xpWbOQang==@kvack.org
X-Gm-Message-State: AOJu0Yz6VtVsarV386T/ssLvfxVuklimStalIEt0D79QeRvSCWQpC959
	T73xc23Nu+xJ3eWfr0CtDnieP6M5dfnOxxu8jPF3WGBfZZiLHRTzmVv6PAhXu9G+anM=
X-Gm-Gg: ASbGnctvUwyuXxEGzfrtmPGDIwOKZY0BFrIlrITUg3eO3aqLQ6sUVy4C5VpKBa6fz3g
	0xVSAXwJjU/p8BZiq/fW4I9dtMyH9ArQ2LxhqR2416hoeXY2CIcYfGk4SG6UeOlesZxDYPkwTrb
	tJszYvrobiJB2c2CjBlbR+uLxlflQcVI9/sU7qoPKXLOB0cZ0rwYZ57MILmjMt8zUdjsOz0Etg2
	ichpqkQhtmi11AflkW+p3Cjty2QyOxkxjIaMTS+p44S6X9OnzA+iMOdfU7xtwFLNbDJ6PN1OAPk
	8+dqdZocMHZF/uI2pYwQh0lpUR24U4LuywYiSMMwe9zTd9XpGgB7pYcMVJPnJ/3DYCcbNAXm3u7
	AQ6J1jJvcowxRdO4omPOqa7YSd8CEyggSiM44uhQhB3nGqQ/TeCxMH5rOEVJN26oFg6Hz3tpl9B
	ulBDQUlrMSyQ7yUvRFxsAZdLieY+LhQrMyyWryqrDphIuK4RbYoiicYyfQEoit6enHW7/HUveF0
	5TuHYg=
X-Google-Smtp-Source: AGHT+IFD6osaS2sP17uSKoOpkdrgAaGoOW4xxaV4WzN7kWyXMlqtMJ1zAdZWqXZh/Duto084HHI0jg==
X-Received: by 2002:a05:690c:968a:b0:786:896d:8858 with SMTP id 00721157ae682-78a8b54d4a4mr55406797b3.47.1763850274503;
        Sat, 22 Nov 2025 14:24:34 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a79779a4esm28858937b3.0.2025.11.22.14.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 14:24:33 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org
Subject: [PATCH v7 19/22] selftests/liveupdate: add test infrastructure and scripts
Date: Sat, 22 Nov 2025 17:23:46 -0500
Message-ID: <20251122222351.1059049-20-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
In-Reply-To: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3im4owadonwq7oejsgxc5exowzu8n5sk
X-Rspam-User: 
X-Rspamd-Queue-Id: BEF7E1C0005
X-Rspamd-Server: rspam10
X-HE-Tag: 1763850275-850534
X-HE-Meta: U2FsdGVkX196YOMp1u6ngi0cqByuoArU00FJ3xToZN5ROhdzsLJGXnkw5LIIhYbBec6pOXVZerxnOv1BMp0zLw+xd5STwre6vLhOs+raOx/vckrMXvBmaWyNuytoJ2IBeDtk6XzvzCclCucspNOp0hUZprjzl6UfDvuFPD2EHVPBcV5p0J/PPsAlE31mTqXHaEVAL4uE+23C4/i7876w5V9pZ+BnNL0dC5eMg8Nyh27OD8dOnlHdVgc+ouywXQ1ao7TMc/yRho8wAdHYvCxtIgl3j0jBS16IpCu3P8cmOwQxyfT3YloLpEW+pt/IbKHLFSwp87hNxdr1o/53vwNMLSHVnfX202l8lBYdZJKQ6ZUuMBQHobTnEE0KtGa2ChIFnZd6rXRdC/85o7snwENb6Ag84aHk70yZJwpp++OyoU3wAPEFkznywKbcIF+7a+hNSwRssR1y9QqFmsZZoOPUZz/8qLOno04/BVPJdGXmeFvj5Ub4G6hiNHMn2s4/2HSaNlqCslA+5sgJBLn10eTPq3u6Mf9IYsuDeaAdeVApPEN6ism4f31/zfBTj5qU+nlHdj/KhELUVmLKM9kLspXaNwivzogy5lJvVk/9pLBYjR9cacq+AEo1gMB9XldGc1CJDMxcB5T0/cx2Iis1DkVtXzsq1QaPGDmKT8QXK5eJqd6UhVrxJX2gLUIohcjMRkFbET0SDcSFivAtmT3+Z5R10Q7kFKKgd9ufEDJY3KsxuZ4ICdN3S3emKNYfJPpasbnOWEdc3VzpP5RUwHVeRHhLhglKeZJJNja8A3iFzsMwG6/oQLNs+DQPPQoy7wb1TQGODtgtZdKTGeJv9oJmT13CW8ngx1lQ40ybgC21O7VTaWjxObhKVX2vQI2Kur4gG0qbripPjhssJiV5KMsBaxhtSSt9+uNP9Mmb/6+wxgmZ6nncKoBY5T6iq0J1ZbMG5bUSfkzZ8kD0LrDVQukdeMR
 jYyC5EC+
 KgCiHolylaXZVjlXXhGqCWKbCjkbd3642OrlZAmvGy5Kv5f7VGkgJ6RMzvAYyMz4A1ZN6v7HOqAywlBFLNswINMtvGMi4PfcyQ93xC83Yl8/cavF5eXUYz5QRJXCDva+JJRso80OTAhXeHyLPfu1gNq6iA9TzGJDZbxxrpihoDsUD4mNmTJtOEEgQZRZ6CCHMYS2O0tH89j/lVTusC/VWoFN1/kNuHxZoYmhzfC6U8PQRHpzYYON70dHSxgSb9cA3nsdjyWpleB7OlQuls8DtHZIlAUdVKzKgS/cyG1+7lm0HdmVdFjVWalLlVhv9MzwXZcYbgvUhP9GNk4PWd3FDE+v/4eg3VOv7amz/btjWm5GOzw5bc6Qo9L21xrZbJBCSbQym42/kQrawXtN2StxjpD2XhQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the testing infrastructure required to verify the liveupdate
feature. This includes a custom init process, a test orchestration
script, and a batch runner.

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
---
 tools/testing/selftests/liveupdate/init.c     | 174 ++++++++++
 .../testing/selftests/liveupdate/luo_test.sh  | 296 ++++++++++++++++++
 tools/testing/selftests/liveupdate/run.sh     |  68 ++++
 3 files changed, 538 insertions(+)
 create mode 100644 tools/testing/selftests/liveupdate/init.c
 create mode 100755 tools/testing/selftests/liveupdate/luo_test.sh
 create mode 100755 tools/testing/selftests/liveupdate/run.sh

diff --git a/tools/testing/selftests/liveupdate/init.c b/tools/testing/selftests/liveupdate/init.c
new file mode 100644
index 000000000000..ed11e04d0796
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/init.c
@@ -0,0 +1,174 @@
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
+	return err ? : 0;
+}
+
+static int run_test(int stage)
+{
+	char stage_arg[32];
+	int status;
+	pid_t pid;
+
+	snprintf(stage_arg, sizeof(stage_arg), "--stage=%d", stage);
+
+	pid = fork();
+	if (pid < 0)
+		return -1;
+
+	if (!pid) {
+		static const char *const argv[] = {TEST_BINARY, stage_arg, NULL};
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
+static int is_stage_2(void)
+{
+	char cmdline[COMMAND_LINE_SIZE];
+	ssize_t len;
+	int fd;
+
+	fd = open("/proc/cmdline", O_RDONLY);
+	if (fd < 0)
+		return 0;
+
+	len = read(fd, cmdline, sizeof(cmdline) - 1);
+	close(fd);
+
+	if (len < 0)
+		return 0;
+
+	cmdline[len] = 0;
+
+	return !!strstr(cmdline, "luo_stage=2");
+}
+
+int main(int argc, char *argv[])
+{
+	int current_stage;
+
+	if (mount_filesystems())
+		goto err_reboot;
+
+	current_stage = is_stage_2() ? 2 : 1;
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
index 000000000000..7d155956e2ff
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/luo_test.sh
@@ -0,0 +1,296 @@
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
+	ktap_finished
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
+	if [ -n "$CROSS_COMPILE" ]; then
+		return
+	fi
+
+	[[ "$host" == "arm64" ]] && host="aarch64"
+	[[ "$target" == "arm64" ]] && target="aarch64"
+
+	if [[ "$host" == "$target" ]]; then
+		CROSS_COMPILE=""
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
+	$make_cmd defconfig
+
+	local fragments=""
+	if [[ -f "$common_conf" ]]; then
+		fragments="$fragments $common_conf"
+	fi
+
+	if [[ -f "$arch_conf" ]]; then
+		fragments="$fragments $arch_conf"
+	fi
+
+	if [[ -n "$fragments" ]]; then
+		"$kernel_dir/scripts/kconfig/merge_config.sh" \
+			-Q -m -O "$build_dir" "$kconfig" $fragments >> /dev/null
+	fi
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
+	# 1. Compile the test binary and the init process
+	"$CROSS_COMPILE"gcc -static -O2 \
+		-I "$headers_dir/include" \
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
+	local accel="-accel tcg"
+	local host_machine=$(uname -m)
+
+	[[ "$host_machine" == "arm64" ]] && host_machine="aarch64"
+	[[ "$host_machine" == "x86_64" ]] && host_machine="x86_64"
+
+	if [[ "$qemu_cmd" == *"$host_machine"* ]]; then
+		if [ -w /dev/kvm ]; then
+			accel="-accel kvm"
+		fi
+	fi
+
+	cmdline="$cmdline liveupdate=on panic=-1"
+
+	echo "# Serial Log: $serial"
+	timeout 30s $qemu_cmd -m 1G -smp 2 -no-reboot -nographic -nodefaults	\
+		  $accel							\
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
+	trap skip ERR
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
diff --git a/tools/testing/selftests/liveupdate/run.sh b/tools/testing/selftests/liveupdate/run.sh
new file mode 100755
index 000000000000..3f6b29a26648
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/run.sh
@@ -0,0 +1,68 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+OUTPUT_DIR="results_$(date +%Y%m%d_%H%M%S)"
+SCRIPT_DIR=$(dirname "$(realpath "$0")")
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
+TEST_NAMES=()
+while IFS= read -r file; do
+    TEST_NAMES+=("$(basename "$file" .c)")
+done < <(find "$SCRIPT_DIR" -maxdepth 1 -name "luo_*.c" ! -name "luo_test_utils.c")
+
+if [ ${#TEST_NAMES[@]} -eq 0 ]; then
+    echo "No tests found in $SCRIPT_DIR"
+    exit 1
+fi
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
2.52.0.rc2.455.g230fcf2819-goog


