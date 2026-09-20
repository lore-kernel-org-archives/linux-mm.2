Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEBF6C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 19:39:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC7116B00BE; Sun, 20 Sep 2026 15:39:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9E4D6B00BF; Sun, 20 Sep 2026 15:39:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B65ED6B00C0; Sun, 20 Sep 2026 15:39:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 895C66B00BE
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:39:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1C9C11C28F0
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:39:07 +0000 (UTC)
X-FDA: 85235153934.13.A489939
Received: from mail-yx2-f42.google.com (mail-yx2-f42.google.com [74.125.224.170])
	by imf10.hostedemail.com (Postfix) with ESMTP id 50A09C0005
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:39:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eggN9val;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789933145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sEtY+1n4Sw7+L9nuvlWdwzAf6I2rCrn2rF9X6RG1+q8=;
	b=c8vGHLxt+EEMTpKLsc6ZtLGW/a/+ZV4Gggl7Vbs07gthsze+dh6WS7i8rTAay8lq+YJYuA
	OwhXWKA/Gbh9wM/rR+HiFJptj1rHyp4CFp8GdKw1s8K+q0jsIxK8lVRopNlhux5xCSKI7l
	0f5/kDJubLDwB3oXeQDGdkK0zFiFYpk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eggN9val;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789933145;
	b=EI9AuUiP3LPgvC5sotq9PaZ4c8pGRcPRlMWR0IIwD3GTPUzD+dS4lhakjp3YhHuFBuSUpp
	gCTijLsR3C2xf15zuYU1toqQNUDQjUJoNN126qAaVJkJvpl8VAml8f6oKBQp+Bcq3IKHpk
	8yd0XwwbdOtzqD3Pd693gVdf4ukj/Ws=
Received: by mail-yx2-f42.google.com with SMTP id 00721157ae682-89666eea29cso15142247b3.2
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933144; x=1790537944; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=sEtY+1n4Sw7+L9nuvlWdwzAf6I2rCrn2rF9X6RG1+q8=;
        b=eggN9valPEwhLGI7PHUs2CSq+eX//FVDY6Ue8KQMPsYVaynvZGCQIwmsBoxCwTKDl9
         a6WvDI8dMU7lbUR/AvGkdKhyjTLGMiyeeiI8qmAzZ5X4cky2K+UQ8MPzp2oQh0W71fyb
         OiWVX86UmxRY7pjgf6xPyk85F9qgC3psRT2vJA0yLX6F6FWf82X+0YtejQyF3G3C/kAH
         l4iOnfpd7cPe9l8QOMuumZqxznVNh2n7sPiinVbKApj2SJspIlPaE6TCxMsNOx2GielF
         2oNNbghNd8x4BVHhSbb0OabsIr8E2GYDjjxYiWEbLahQ9RJNR9BmTj461sSWHx4qjRvF
         WwJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933144; x=1790537944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=sEtY+1n4Sw7+L9nuvlWdwzAf6I2rCrn2rF9X6RG1+q8=;
        b=zMuDexZZYB9Pncm2Ma//cqmajsYjAIBOecG2bxQlVvzI5NEef7lr5VYTCWPPm7BEJU
         S3OFzNrG9Q0rfh4Xvu3i2foSUqvi6Q/TeYaAyL+CjnKXaBd2JZHKE9ceaVJu4hd1Kjs0
         z11X10Ipb9k7qB32G2jroyfgyTI84X9BdjGgf3yLXM55MbYhCc1D/WIVnNDnGnAqioB1
         +2yy+HXn7qPruLMWDF6psv4vFRAg5e06n+J1GB3pZ+xJGS9nzBkMATm38stda0Xjn7B7
         roOtbG3vjORSywwBXJhHMklZfVyG3M0MwO4ftjYzt9Y3q7Rkv43Zk/aXsqDbW1NWuYws
         J5dw==
X-Forwarded-Encrypted: i=1; AKwUvBy0RjUDkHX1FSe8s38Jlx276oOS83LjUe3ri03Ml4qXlhTcLFfsGAA9uCQ0XdCNVwqSJ3uy6W1aJA==@kvack.org
X-Gm-Message-State: AFuF++koI3JsmbYsoejlzKRcSFAMhjFnisfkUj0vrLj/nNUI3wAklKOx
	tKcgbmsYUDaAEAw2np8+xN+BECwcQYeudGl1+3G21pit7h/wtG6EepcxEhijKO7V5Cs=
X-Gm-Gg: AYBFou3yA0Ibxj2Cmw1cqv0fFUEg0mtEntGp+eDqmlSABhqNCUTyGZXMeOhx8IHeKYy
	YsoXzi6ZNlP310E85Rw9R1dBd/Y916+CTuzeGiZ4ckmFNtV23sdE+NrvAI/2l2v/gKpXHJkxMUt
	/roUPQb9kkChLpquOy+xtbXwH4sq65RQo5daO19xhI8oTkE2ODfSzttSZkfW5lRJchdLIvTgGyV
	0M5pv6nlaTf6GujVbeyrD0MWzUc82CUOdbgVAZAgUzZzqsFawyFRr4MHPcHfWXUO/btz8MV8RcH
	nQIIhXuME00jyQHV+nJ+zQ3jioevV6rOP7tGx58XIl0R1I1W+vVZf476F/hAby8gDvEhbabSqqY
	4HecZpken6/gwA/IY8lmISlvRNocWnyYUu9W3Xf44r2MxSmfjhRjFriQKASC5zcGdAAHMCRB1CT
	fJtg6yGwbbUNXTvARGc8Wp8nTSXKvUmhaelEfS90VV+87xFrgJFZ5EI4ruu2gPuf7iSUxDL8r9C
	+pbRWTlG/8Z3nGfr3dAtRniPzTGFPb+9HD5GXRq9maVs30ouxj0y5mNi2X2Xvjag0wCmQ2X7D2p
	1Jip/3eVp3mH1J1WohM=
X-Received: by 2002:a05:690c:498f:b0:81e:6c2e:f0f5 with SMTP id 00721157ae682-89734ac7b85mr23278327b3.28.1789933144397;
        Sun, 20 Sep 2026 12:39:04 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a48d99122sm18304727b3.48.2026.09.20.12.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:39:03 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 22/46] selftests: liveupdate: Add physical CPU preservation live update tests
Date: Sun, 20 Sep 2026 15:36:26 -0400
Message-ID: <20260920193650.3373435-23-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 50A09C0005
X-Stat-Signature: rhcqcydio4su6h95uctc1fg6t3hptx7f
X-Rspam-User: 
X-HE-Tag: 1789933145-185758
X-HE-Meta: U2FsdGVkX1+MXq69N2jUkp9RgZleJyc6DterxI2Gzt2ZMkOdJnaKI0Z+M6yfwqAyL9uhKa41lVPoyI81kWdGJw+FwcmwabYL5IOO7p4x6giDX7nEc3EdLM9CVGPWkHkVS751qYdbjLddNnPfuIQcw/e7LUmLXFbBLLDF9EEeS4S2CO3hNnq6YyVF90/9sl7wfS3x1TblW2m3h/JUsIbcJhbazsn+omqkGaVvtA02fefwtaBs1C2DmC2UsVIoAC9+XoAWyT1ih8yWh1OLCHPKW6onqtgqSt+ZMbyT6/mqUzvbzQhfByL+JUAlYFC9zkzCmtnXgp4ZtMEtyfpSPsRiyVg1H5DBqmIvr2qmIx37uMXgFWP5+lbA0Un+8uyogHrAxq6Z+SboqqpIu5EWNjQ/BGlm7Ys8oUEBmFKn8Z1UbzuZRCo6Hw+b1LrNIOmgCRhRoskUJrYfbdjuSNFQYn6ZMoc8B2w5/oObUU3ciUQXo8AQ54DUrOOCnGsRIi/OuAaRx85e+sX8539zLTMV4KAbumZVYm17Islu4hTLd7RD/GovktEEOM/3DTFOD3Yaua5YcENIG9GMvDF69jjUQKa/LcjOtwItzOz2IZkaw9MS36gFWA3BEGOK9UF3sdrCy74PR79onq7Y/NQ8wUnU3jAY09LeGr/jUPLPlPnYG98HGuexM+k8AXkWAIanlHnO2O1jpwvrHG++elFmi2E48ZvVM9EuyjdgiNJN5Fj8FWYlYCCNoaX4w7cPFfLK+RcFBTNbm6bCMx0PW1Pd9WNOPTIlLeFyR9ayWLEVwgz8NC6bJ+fGKMqRXBIXKNKt4WVL7w12T8arbiVsGXxAJfuJPuFc2cqu52l12v7ZjdDj3oy23d6tmi8rQp01RFUqtTcV7xtT/ngwVZemBmxGpkUj4L5y9i+d1RU35Py8EIo2xdQyBZxSjsbn/ZftYkbEZOCnK7xdTfSl52jJkz398RevGQ4
 Y2UmT8mu
 LhTwrLkZ/OLY/gwzn9wX1jHczOQRrCf3CN3VIUFAl8zeSD5QUKDpVmq806amjsgstvxxCQVsLx4c7XUGkz3/I9Rx/mQber3shWq1PCTsdKAhgExi3gb9WzlIMiUUKSrDmGROLFIqsbaJeMkbyISyo4H/SNejAOEVPoevWUSnWu691Txd0plZ77TJ/W3z+bsOg7GGYfQmrpP5jZBtILufvAa6TmL51JwMijQZP2i46E2aVfHqaxTiOGZ8kjG5IdkKPUfPlxRP++s6nmcJrEBY9Ooiglkeyn2xKlk8ILUcqzwFTfLH/drTL0BLMZ3YPtIopUZ1Atq/UAOKD14o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add integration tests performing kexec live updates with preserved
CPUs:
- Preserve physical cores across kexec reboot.
- Verify cores remain preserved and isolated in incoming kernel.
- Verify unpreserve and online restoration.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 tools/testing/selftests/liveupdate/Makefile   |   1 +
 tools/testing/selftests/liveupdate/init.c     |  27 +++-
 .../selftests/liveupdate/luo_cpu_preserve.c   | 145 ++++++++++++++++++
 .../selftests/liveupdate/run-vmtests.sh       |   1 +
 tools/testing/selftests/liveupdate/vmtest.sh  |   4 +-
 5 files changed, 175 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/liveupdate/luo_cpu_preserve.c

diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/testing/selftests/liveupdate/Makefile
index 634211c66652..0fa80f26a191 100644
--- a/tools/testing/selftests/liveupdate/Makefile
+++ b/tools/testing/selftests/liveupdate/Makefile
@@ -3,6 +3,7 @@
 TEST_GEN_PROGS += liveupdate
 
 TEST_GEN_PROGS_EXTENDED += luo_kexec_simple
+TEST_GEN_PROGS_EXTENDED += luo_cpu_preserve
 TEST_GEN_PROGS_EXTENDED += luo_multi_session
 TEST_GEN_PROGS_EXTENDED += luo_stress_sessions
 TEST_GEN_PROGS_EXTENDED += luo_stress_files
diff --git a/tools/testing/selftests/liveupdate/init.c b/tools/testing/selftests/liveupdate/init.c
index fb08bd58b9b9..a3850ff95c00 100644
--- a/tools/testing/selftests/liveupdate/init.c
+++ b/tools/testing/selftests/liveupdate/init.c
@@ -11,6 +11,7 @@
 #include <string.h>
 #include <sys/mount.h>
 #include <sys/reboot.h>
+#include <sys/stat.h>
 #include <sys/syscall.h>
 #include <sys/wait.h>
 #include <unistd.h>
@@ -27,11 +28,15 @@ static int mount_filesystems(void)
 		return -1;
 	}
 
-	if (mount("debugfs", "/debugfs", "debugfs", 0, NULL) < 0) {
-		fprintf(stderr, "INIT: Failed to mount debugfs\n");
+	if (mount("sysfs", "/sys", "sysfs", 0, NULL) < 0) {
+		fprintf(stderr, "INIT: Failed to mount sysfs\n");
 		return -1;
 	}
 
+	mkdir("/sys/kernel/debug", 0755);
+	mount("debugfs", "/sys/kernel/debug", "debugfs", 0, NULL);
+	mount("debugfs", "/debugfs", "debugfs", 0, NULL);
+
 	if (mount("proc", "/proc", "proc", 0, NULL) < 0) {
 		fprintf(stderr, "INIT: Failed to mount proc\n");
 		return -1;
@@ -116,7 +121,23 @@ static int run_test(int stage)
 	}
 
 	waitpid(pid, &status, 0);
+	if (WIFEXITED(status) && WEXITSTATUS(status) == 0)
+		return 0;
+
+	/* If test binary does not accept -s (e.g. kselftest harness), run without -s */
+	pid = fork();
+	if (pid < 0)
+		return -1;
+
+	if (!pid) {
+		char *const argv[] = {TEST_BINARY, NULL};
 
+		execve(TEST_BINARY, argv, NULL);
+		fprintf(stderr, "INIT: execve failed\n");
+		_exit(1);
+	}
+
+	waitpid(pid, &status, 0);
 	return (WIFEXITED(status) && WEXITSTATUS(status) == 0) ? 0 : -1;
 }
 
@@ -168,6 +189,8 @@ int main(int argc, char *argv[])
 	}
 
 	printf("INIT: Stage %d completed successfully.\n", current_stage);
+	if (current_stage == 2)
+		printf("\n--- TEST PASSED ---\n");
 	reboot(current_stage == 1 ? RB_KEXEC : RB_AUTOBOOT);
 
 	return 0;
diff --git a/tools/testing/selftests/liveupdate/luo_cpu_preserve.c b/tools/testing/selftests/liveupdate/luo_cpu_preserve.c
new file mode 100644
index 000000000000..85d17ccf3d90
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/luo_cpu_preserve.c
@@ -0,0 +1,145 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * A selftest to validate the lifecycle of preserved CPUs across Live Update
+ * and within a local session.
+ */
+
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <unistd.h>
+
+#include <libliveupdate.h>
+
+#define TEST_SESSION_NAME "cpu-preserve-session"
+#define STATE_SESSION_NAME "cpu_preserve_state"
+#define STATE_MEMFD_TOKEN 999
+#define TEST_CPU_TOKEN 0x100
+
+static int find_target_cpu(void)
+{
+	char path[128];
+	int cpu;
+
+	for (cpu = 1; cpu < 256; cpu++) {
+		snprintf(path, sizeof(path), "/sys/devices/system/cpu/cpu%d/preserve", cpu);
+		if (access(path, R_OK) == 0) {
+			snprintf(path, sizeof(path), "/sys/devices/system/cpu/cpu%d/online", cpu);
+			if (access(path, R_OK) == 0)
+				return cpu;
+		}
+	}
+	return -1;
+}
+
+static int read_cpu_online(int cpu)
+{
+	char path[128], buf[16];
+	int fd, val = -1;
+
+	snprintf(path, sizeof(path), "/sys/devices/system/cpu/cpu%d/online", cpu);
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		return -1;
+	if (read(fd, buf, sizeof(buf) - 1) > 0)
+		val = atoi(buf);
+	close(fd);
+	return val;
+}
+
+static int preserve_cpu_fd(int session_fd, int cpu, int token)
+{
+	struct liveupdate_session_preserve_fd pfd = {};
+	char path[128];
+	int cpu_fd, ret;
+
+	snprintf(path, sizeof(path), "/sys/devices/system/cpu/cpu%d/preserve", cpu);
+	cpu_fd = open(path, O_RDONLY);
+	if (cpu_fd < 0)
+		return -1;
+
+	pfd.size = sizeof(pfd);
+	pfd.fd = cpu_fd;
+	pfd.token = token;
+
+	ret = ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, &pfd);
+	close(cpu_fd);
+	return ret;
+}
+
+/* Stage 1: Executed before kexec */
+static void run_stage_1(int luo_fd)
+{
+	int target_cpu, session_fd;
+
+	target_cpu = find_target_cpu();
+	if (target_cpu < 0)
+		fail_exit("No hotpluggable CPU with preserve attribute found");
+
+	ksft_print_msg("[STAGE 1] Target CPU for preservation: %d\n", target_cpu);
+
+	create_state_file(luo_fd, STATE_SESSION_NAME, STATE_MEMFD_TOKEN, target_cpu);
+
+	session_fd = luo_create_session(luo_fd, TEST_SESSION_NAME);
+	if (session_fd < 0)
+		fail_exit("luo_create_session for '%s'", TEST_SESSION_NAME);
+
+	if (preserve_cpu_fd(session_fd, target_cpu, TEST_CPU_TOKEN) < 0)
+		fail_exit("preserve_cpu_fd for cpu %d", target_cpu);
+
+	if (read_cpu_online(target_cpu) != 0)
+		fail_exit("CPU %d was expected to be offline after preservation", target_cpu);
+
+	ksft_print_msg("[STAGE 1] CPU %d successfully preserved and offlined\n", target_cpu);
+
+	close(luo_fd);
+	daemonize_and_wait();
+}
+
+/* Stage 2: Executed after kexec */
+static void run_stage_2(int luo_fd, int state_session_fd)
+{
+	struct liveupdate_session_retrieve_fd rfd = {};
+	int target_cpu, session_fd;
+
+	restore_and_read_stage(state_session_fd, STATE_MEMFD_TOKEN, &target_cpu);
+	ksft_print_msg("[STAGE 2] Restored target CPU: %d\n", target_cpu);
+
+	session_fd = luo_retrieve_session(luo_fd, TEST_SESSION_NAME);
+	if (session_fd < 0)
+		fail_exit("luo_retrieve_session for '%s'", TEST_SESSION_NAME);
+
+	rfd.size = sizeof(rfd);
+	rfd.token = TEST_CPU_TOKEN;
+	if (ioctl(session_fd, LIVEUPDATE_SESSION_RETRIEVE_FD, &rfd) < 0)
+		fail_exit("LIVEUPDATE_SESSION_RETRIEVE_FD for cpu token %#x", TEST_CPU_TOKEN);
+
+	close(rfd.fd);
+
+	if (read_cpu_online(target_cpu) != 1)
+		fail_exit("CPU %d was expected to be online after retrieval", target_cpu);
+
+	ksft_print_msg("[STAGE 2] CPU %d successfully retrieved and online\n", target_cpu);
+
+	if (luo_session_finish(session_fd) < 0)
+		fail_exit("luo_session_finish for test session");
+	close(session_fd);
+
+	if (luo_session_finish(state_session_fd) < 0)
+		fail_exit("luo_session_finish for state session");
+	close(state_session_fd);
+
+	ksft_print_msg("\n--- CPU PRESERVATION KEXEC TEST PASSED ---\n");
+}
+
+int main(int argc, char *argv[])
+{
+	return luo_test(argc, argv, STATE_SESSION_NAME,
+			run_stage_1, run_stage_2);
+}
diff --git a/tools/testing/selftests/liveupdate/run-vmtests.sh b/tools/testing/selftests/liveupdate/run-vmtests.sh
index d656ce58c5a7..1b90d56ec4a2 100755
--- a/tools/testing/selftests/liveupdate/run-vmtests.sh
+++ b/tools/testing/selftests/liveupdate/run-vmtests.sh
@@ -20,6 +20,7 @@ TEST_NAMES=(
 	"luo_multi_session"
 	"luo_stress_files"
 	"luo_stress_sessions"
+	"luo_cpu_preserve"
 )
 
 function usage() {
diff --git a/tools/testing/selftests/liveupdate/vmtest.sh b/tools/testing/selftests/liveupdate/vmtest.sh
index 64fd2ab55b76..c934c76c00a0 100755
--- a/tools/testing/selftests/liveupdate/vmtest.sh
+++ b/tools/testing/selftests/liveupdate/vmtest.sh
@@ -145,6 +145,7 @@ function mkinitrd() {
 	cat > "$workspace_dir/cpio_list_inner" <<EOF
 dir /dev 0755 0 0
 dir /proc 0755 0 0
+dir /sys 0755 0 0
 dir /debugfs 0755 0 0
 nod /dev/console 0600 0 0 c 5 1
 file /init $workspace_dir/init 0755 0 0
@@ -157,6 +158,7 @@ EOF
 	cat > "$workspace_dir/cpio_list" <<EOF
 dir /dev 0755 0 0
 dir /proc 0755 0 0
+dir /sys 0755 0 0
 dir /debugfs 0755 0 0
 nod /dev/console 0600 0 0 c 5 1
 file /init $workspace_dir/init 0755 0 0
@@ -179,7 +181,7 @@ function run_qemu() {
 
 	echo "# Serial Log: $serial"
 	timeout 30s \
-	$qemu_cmd -m 1G -smp 2 -no-reboot -nographic -nodefaults \
+	$qemu_cmd -m 1G -smp 4 -no-reboot -nographic -nodefaults \
 		  -accel tcg -accel hvf -accel kvm \
 		  -serial file:"$serial" \
 		  -append "$cmdline" \
-- 
2.55.0.1082.g2b9226bbc0-goog


