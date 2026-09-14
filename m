Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B18F4C88E65
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 10:45:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9622D6B009D; Mon, 14 Sep 2026 06:45:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 938416B009E; Mon, 14 Sep 2026 06:45:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 829446B009F; Mon, 14 Sep 2026 06:45:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 53D496B009D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 06:45:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BD9BD1202A3
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:45:34 +0000 (UTC)
X-FDA: 85212036588.10.9B5218B
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf18.hostedemail.com (Postfix) with ESMTP id D303D1C0004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:45:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="rJE/gfP/";
	spf=pass (imf18.hostedemail.com: domain of matthias.goergens@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=matthias.goergens@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789382732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4PlFr1YMTYrZSbX9/Z8mAxWcnKUTDDEqGR2N9kN/Q2g=;
	b=KdLu0FOnnOAHGG2fqW/jPAxlIyHoeapQAEnAN4QkiaV8S4NolVBR7Um6Qvy7Theq2jA3EC
	zQCT2KT0gUAFJZSRoFEflLR3DMRHpDU36ksawx5Oo7zz0vOxd5dS7dk+jBd/LSpozpH9O5
	zkTuNCzylRysCOB22pWC0jK/cNaCP4U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789382732;
	b=F46KfJ43fWC3h1Wi0OJlbYEA/tsIBVHYTFmiR3m9VLnZlzxOONYUzH5xZaPa3ym2WQ2dGA
	GIRY0DU4xqIvRyy1LmNwMrGesBaOTJYZdrsHQcBZKAhsI2eqVOFDbgy0iSZzkrBZEKee+s
	SPjzLg35glJTXWtjSElzK6P6oLA3rd8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="rJE/gfP/";
	spf=pass (imf18.hostedemail.com: domain of matthias.goergens@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=matthias.goergens@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85469b2e1d5so1986407b3a.1
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789382732; x=1789987532; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4PlFr1YMTYrZSbX9/Z8mAxWcnKUTDDEqGR2N9kN/Q2g=;
        b=rJE/gfP/4aDtMJr4XLDBbyK+uTEAA5V8YYTHOpzbAxwsH/m1SG2qaP12ihCrR5br1Q
         HYU4aOTqxRGaqfp91dmIshEgjyYt3RwAsUuBw2IJpwsys7iQEjaFCiXhzGAWR4y8+ASw
         DjjauqHOD8A6CfjkQwzqx85vzDXj9Aip9nthAVUyomxknFNA7sE4rEfBTWiSpN2PEolp
         tc0d3f+yai/uhZzUU4OjlprExnjfy/Iefe5wzkse0cYEyDLFpq5WxG9uMp3mX4g530Ec
         Bv7yLFTjuAK0qhkXG1TGILEumE1g35WtqyY27KI5W+o9yR7FSg3sVDDupP31QVgc3+oG
         0oyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789382732; x=1789987532;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4PlFr1YMTYrZSbX9/Z8mAxWcnKUTDDEqGR2N9kN/Q2g=;
        b=r4UBdCwYQ6QkHNnOiY7qizEBzpx+anE3j86p7+oss7wER9uuzRR8mcll4/JQ2tSLTd
         JlHSCk5H/V+9cK6K8HaCpe+10hN9b7IFH8GnNadEvzd/J5ykh97PMJ/9kMJ30r/q53EF
         uyRmxA30LgGYU+jobL804lKSqL2Q3Cwl1SKPGfk1dWZiuz2zfwzUc5jjBkb4rJR+FG2a
         BiH9sa3kJBd7ACFxore/R2dx5dqSYWkCjPC+YI5iSc0Cpvgl2qCdC1JYsDoDTaUHwCp7
         b7cOHrvTKmfN/50wm5hwAZPd2+UBqcB16U3hQbasAgRHi6j75E0RUeNpRarY/3Iydw5o
         FCkg==
X-Forwarded-Encrypted: i=1; AKwUvBw+60D6+GSCmeHDVa6hicw4V6Pb9dzpTu+qXXgjt1xZ8hLq0+c6EDkpFn53ei+MH2vAVYHCmEGDJA==@kvack.org
X-Gm-Message-State: AFuF++l79VJ54MF3TqHmwy+/rTDZTdBle21rj+U5UBih+13XUYbW/G5q
	8rT0gOcGph0sjHBwAGJO/TVOBVFqxUs67utRbkUCCGAxkMO877ojk7lJ
X-Gm-Gg: AYBFou38wFafcqE1XgofcSKnn7kV1NA+EMjb25/qSo1xl4XcvL9KL5n/NLc2b7tu/Dd
	HhtD12AIYsbdZQn1RIvG2KTI+7lNvOBb/fuDXIwAUQFUgBMXV31Vs1/q0NMqjY50eJ1ur9+co1k
	p5U1kio3OqPnmIfK1uROrucuU/GW4YxEw/+hb3c9S7ztt6R9+oTPekLHnSYo+DEb/8dAe0gDhSa
	KubnDq5fmhXs3Gq7T8TCgojI1sOZus/K0MeXVnwoEfMJouKuA5+XoztGs+POAI/e0X8j7F5fOwn
	EmW/kVXm9fW1KNbuVTWDhM3ffR11QioXmFuje1qR2oknWR/CY81BlLIhO6snyrOZ5fRJzqUYPqq
	sM6yqLOoCH+zmuHHcm/lCoxoH9C9p267SuKf16K42OS+4mhB1Wk9O3T/lEGKK2sXwZtmjUlcdg+
	tCOpbpMBkE5jDoBiorFFWvEZmarx/Dwt/SShQtoJo9Y1uB2dUcwJxO6L43GqrwifAuf3ywvQUjz
	fd8Pt9fxes6ZwermH2IVSnTB2zfe7qztft/IeCSYHcmeIyyC+qpT8fKMt8Ea4KN6ChKMyC0q3EJ
	aujrbdY9ipmv8hkEfp9wprrArEKuJ26MzO3qJbtnj8muW2CW34QFMQoHovVQ8Mo=
X-Received: by 2002:a05:6a00:440d:b0:868:eabf:e07a with SMTP id d2e1a72fcca58-86f83b3e869mr5077903b3a.10.1789382731514;
        Mon, 14 Sep 2026 03:45:31 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.252.203.158])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b28fd0e0dsm4234386b3a.26.2026.09.14.03.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 03:45:31 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Shuah Khan <shuah@kernel.org>
Cc: Matthias Goergens <matthias.goergens@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH 2/3] selftests: zram: cover offload-only swap policy
Date: Mon, 14 Sep 2026 18:45:00 +0800
Message-ID: <20260914104501.3960616-3-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914104501.3960616-1-matthias.goergens@gmail.com>
References: <20260914104501.3960616-1-matthias.goergens@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: zecq38o1f4yn1zm8mnaiw9okha4zio4h
X-Rspamd-Queue-Id: D303D1C0004
X-HE-Tag: 1789382732-747496
X-HE-Meta: U2FsdGVkX19RVgqcbYapaepMw74R1RCGwUdD5q8TjDBJEWng7wN5l2V0mcn6LEIwX3U8Kn4N79TxOLJddBHG29yM6jDeEh2wxUyLHmwl2W3Svd8UIpTkea2lazYHrk+IwYkfaSC2okRxDymQq7BgijJtSLwuJp84lr2zxW09nkBnASecbLQI24nHXM0MDuQ9T6QM9lamFJo5wDgKMJZ8BsvweVrkqC5Qj5k/7VdMAkdKsPLLm4whHw42x/Unsd36ARHGDbjVYDpSSOq1Hk+G02d6m+23uPViaKcRyaWefUspWMoKfZlgQGbLkPGyKrZj7abuCH80xvwcDbOXxJoAnpEBynQAzMljcMFZtqu0iFYW0F9yZDHRFL5B48Aj7oYo02ZRakBoFPJoqTw6mFLGMgKdxLrp/MQAVgZYX2HFPdJ4ITx5ZnSqOLoOhJFWq10g023ZDjBOaoyohk5r+Y3KbsXrSNHILkASPJN+XZN4zVB0RGTtZBCtejZHuAMw0QtRZgF7IKtAlQhItcpABVHPQctApeketzUauUFtB1WEvqo4GEmdSS5g3teDdvIv5GhQE49S2rjvvC2qlOavY6PcKz5pHwtqlIdvjz7KDg/L4A0lxCMe3tm0ZrPLFnU1N/IdqLOwpuP8wnDNA79ozux8S/bjH993fvpDN1hrC1e2EryIciE3aLS8EtZcRI3dPDoC0unwctVs8r5IO3PS2gdWrHJgEcmKgQ/cfhTGoS74xZD0Nn+cAUHwzPEUSvHFoQMtNUlWBbAxunaYWaT2zuZjeMWkTD/pCxlvZhzs4cyvCq7bRhW65zbpxcAoaM0xSZoww2IvraqGaMKTtMmT4rjmSsMa/bkVO5XYwmAqjcem8Yp3taDRNPYRfYKW1brYW5Wglk4vMwltH6IOAj+uxthPPidH8XXJC433htWAKesAEViRu0dRbR2sJr6Cb3vCFzPqXH/ezFAsOyMgxHy42XZ
 vqcCSlxg
 Sa9A+ZDtxf6dEkjkNC7JZP5HSYUlprDeWFV3gYblYJ+LVtnYgbFrhOVY/OJZd++/KQjfrTYP1CKiCrSIdb0s2458BFFfG2zLvAAJ3WJIziUubdFJRKuSYhVrF+rGK5InPALs8VVTbZ8PO6UZTVjTErzCp18zWtpL6bcP+UmjiCYysetgdCz/ZaiVIIFac98tBP7iL23WkrZA8RmYIc38u5bAIw7HnhgDghbxgBjm0i42MJ4r27ix7ugTWUYPiRmV8SEnVDJUzNb/pM63GWZpUIVDiLny+hZQrYVb4PvJMYyM/ECjNXLQEBHvvsIYy0YZ8QPkh75OMtve8BqC4QjKjZNIw3YrdVbkxkH1jPAAsZgoJy/60jIHj38FbkUNurbgSe/Re1ssqDudXRkAJate+SrOPLB1cpHutID1l3n16rsBGeEA+dysZM4M4PWYT9PJ+SlgVj48q8croLPmk0dW7TDTnKu8QnYgKEwG1At+wnevu1T4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add zram tests for proactive offload, fallback to conventional swap under
ordinary pressure, zswap bypass, discard policy and data recovery after
swapoff. Pin reclaim transitions to one CPU to exercise cached-cluster
eligibility changes, and use conventional swap as a positive zswap control.
Check that discard-once takes precedence when both discard modes are set.

Check that offload-only capacity preserves file workingset activation
with a calibrated refault workload. Wait for memory.stat to reflect the
initial footprint before reclaim, and distinguish insufficient calibration
from helper failures.

Skip unsupported kernels and cgroup setups. Restore swap devices,
controller delegation and modified zswap/MGLRU settings on exit. These
tests require an exclusive environment because swap priorities and some
of the settings are global.

Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
---
 tools/testing/selftests/zram/.gitignore       |   2 +
 tools/testing/selftests/zram/Makefile         |   4 +-
 tools/testing/selftests/zram/config           |   6 +-
 tools/testing/selftests/zram/swap_offload.c   | 222 ++++++++++++++++++
 .../selftests/zram/workingset_offload.c       | 206 ++++++++++++++++
 tools/testing/selftests/zram/zram03.sh        | 166 +++++++++++++
 tools/testing/selftests/zram/zram04.sh        | 149 ++++++++++++
 tools/testing/selftests/zram/zram_lib.sh      |  28 +++
 8 files changed, 780 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/zram/swap_offload.c
 create mode 100644 tools/testing/selftests/zram/workingset_offload.c
 create mode 100755 tools/testing/selftests/zram/zram03.sh
 create mode 100755 tools/testing/selftests/zram/zram04.sh

diff --git a/tools/testing/selftests/zram/.gitignore b/tools/testing/selftests/zram/.gitignore
index 088cd9bad87a..74b0217c60f0 100644
--- a/tools/testing/selftests/zram/.gitignore
+++ b/tools/testing/selftests/zram/.gitignore
@@ -1,2 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 err.log
+swap_offload
+workingset_offload
diff --git a/tools/testing/selftests/zram/Makefile b/tools/testing/selftests/zram/Makefile
index 7f78eb1b59cb..781d10a20e56 100644
--- a/tools/testing/selftests/zram/Makefile
+++ b/tools/testing/selftests/zram/Makefile
@@ -1,9 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0
 all:
 
-TEST_PROGS := zram.sh
+TEST_GEN_FILES := swap_offload workingset_offload
+TEST_PROGS := zram.sh zram03.sh zram04.sh
 TEST_FILES := zram01.sh zram02.sh zram_lib.sh
 EXTRA_CLEAN := err.log
 
 include ../lib.mk
-
diff --git a/tools/testing/selftests/zram/config b/tools/testing/selftests/zram/config
index e0cc47e2c7e2..c59b8c3806a5 100644
--- a/tools/testing/selftests/zram/config
+++ b/tools/testing/selftests/zram/config
@@ -1,2 +1,6 @@
+CONFIG_CGROUPS=y
+CONFIG_MEMCG=y
+CONFIG_SWAP=y
 CONFIG_ZSMALLOC=y
-CONFIG_ZRAM=m
+CONFIG_ZRAM=y
+CONFIG_ZSWAP=y
diff --git a/tools/testing/selftests/zram/swap_offload.c b/tools/testing/selftests/zram/swap_offload.c
new file mode 100644
index 000000000000..b2b94cd6ee3a
--- /dev/null
+++ b/tools/testing/selftests/zram/swap_offload.c
@@ -0,0 +1,222 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+
+#include <errno.h>
+#include <fcntl.h>
+#include <sched.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/syscall.h>
+#include <unistd.h>
+
+#define SWAP_FLAG_PREFER	0x8000
+#define SWAP_FLAG_DISCARD	0x10000
+#define SWAP_FLAG_DISCARD_ONCE	0x20000
+#define SWAP_FLAG_DISCARD_PAGES	0x40000
+#define SWAP_FLAG_OFFLOAD_ONLY	0x80000
+
+static int activate(const char *path, int priority, int discard_flags)
+{
+	int flags = SWAP_FLAG_PREFER | SWAP_FLAG_OFFLOAD_ONLY |
+		priority | discard_flags;
+
+	if (syscall(SYS_swapon, path, flags)) {
+		perror("swapon");
+		return 1;
+	}
+
+	return 0;
+}
+
+static int reject_page_discard(const char *path, int priority)
+{
+	int flags = SWAP_FLAG_PREFER | SWAP_FLAG_OFFLOAD_ONLY |
+		SWAP_FLAG_DISCARD | SWAP_FLAG_DISCARD_PAGES | priority;
+	int ret;
+
+	errno = 0;
+	ret = syscall(SYS_swapon, path, flags);
+	if (ret == -1 && errno == EINVAL)
+		return 0;
+	if (!ret) {
+		syscall(SYS_swapoff, path);
+		fprintf(stderr, "offload-only page discard was accepted\n");
+	} else {
+		fprintf(stderr, "swapon returned unexpected error: %s\n",
+			strerror(errno));
+	}
+	return 1;
+}
+
+static int accept_discard_once_pages(const char *path, int priority)
+{
+	int flags = SWAP_FLAG_PREFER | SWAP_FLAG_OFFLOAD_ONLY |
+		SWAP_FLAG_DISCARD | SWAP_FLAG_DISCARD_ONCE |
+		SWAP_FLAG_DISCARD_PAGES | priority;
+
+	if (syscall(SYS_swapon, path, flags)) {
+		perror("swapon discard-once+discard-pages");
+		return 1;
+	}
+	if (syscall(SYS_swapoff, path)) {
+		perror("swapoff discard-once+discard-pages");
+		return 1;
+	}
+	return 0;
+}
+
+static int join_cgroup(const char *procs)
+{
+	char pid[32];
+	int fd, len;
+
+	fd = open(procs, O_WRONLY);
+	if (fd < 0) {
+		perror("open cgroup.procs");
+		return 1;
+	}
+
+	len = snprintf(pid, sizeof(pid), "%d\n", getpid());
+	if (write(fd, pid, len) != len) {
+		perror("write cgroup.procs");
+		close(fd);
+		return 1;
+	}
+	close(fd);
+	return 0;
+}
+
+static int pin_to_one_cpu(const char *pid_arg)
+{
+	cpu_set_t allowed, selected;
+	char *end;
+	long pid;
+	int cpu;
+
+	errno = 0;
+	pid = strtol(pid_arg, &end, 10);
+	if (errno || *end || pid <= 0) {
+		fprintf(stderr, "invalid pid: %s\n", pid_arg);
+		return 1;
+	}
+
+	if (sched_getaffinity(pid, sizeof(allowed), &allowed)) {
+		perror("sched_getaffinity");
+		return 1;
+	}
+	for (cpu = 0; cpu < CPU_SETSIZE; cpu++)
+		if (CPU_ISSET(cpu, &allowed))
+			break;
+	if (cpu == CPU_SETSIZE) {
+		fprintf(stderr, "pid %ld has no allowed CPU\n", pid);
+		return 1;
+	}
+
+	CPU_ZERO(&selected);
+	CPU_SET(cpu, &selected);
+	if (sched_setaffinity(pid, sizeof(selected), &selected)) {
+		perror("sched_setaffinity");
+		return 1;
+	}
+	return 0;
+}
+
+static int allocate(const char *size_arg, const char *procs,
+		    const char *ready, const char *verified)
+{
+	unsigned char *memory;
+	unsigned long size;
+	unsigned long page_size;
+	char *end;
+	sigset_t signals;
+	int signal;
+	int fd;
+
+	errno = 0;
+	size = strtoul(size_arg, &end, 0);
+	if (errno || *end || !size) {
+		fprintf(stderr, "invalid allocation size: %s\n", size_arg);
+		return 1;
+	}
+	if (join_cgroup(procs))
+		return 1;
+
+	memory = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (memory == MAP_FAILED) {
+		perror("mmap");
+		return 1;
+	}
+
+	page_size = getpagesize();
+	for (unsigned long i = 0; i < size; i += page_size)
+		memset(memory + i, i / page_size % 251 + 1,
+		       page_size < size - i ? page_size : size - i);
+	if (mprotect(memory, size, PROT_READ)) {
+		perror("mprotect");
+		return 1;
+	}
+
+	sigemptyset(&signals);
+	sigaddset(&signals, SIGUSR1);
+	if (sigprocmask(SIG_BLOCK, &signals, NULL)) {
+		perror("sigprocmask");
+		return 1;
+	}
+
+	fd = open(ready, O_WRONLY | O_CREAT | O_EXCL, 0600);
+	if (fd < 0) {
+		perror("create ready file");
+		return 1;
+	}
+	close(fd);
+
+	errno = sigwait(&signals, &signal);
+	if (errno) {
+		perror("sigwait");
+		return 1;
+	}
+	for (unsigned long i = 0; i < size; i++) {
+		unsigned char expected = i / page_size % 251 + 1;
+
+		if (memory[i] != expected) {
+			fprintf(stderr,
+				"data mismatch at %lu: got %u, expected %u\n",
+				i, memory[i], expected);
+			return 1;
+		}
+	}
+
+	fd = open(verified, O_WRONLY | O_CREAT | O_EXCL, 0600);
+	if (fd < 0) {
+		perror("create verified file");
+		return 1;
+	}
+	close(fd);
+
+	for (;;)
+		pause();
+}
+
+int main(int argc, char **argv)
+{
+	if (argc == 4 && !strcmp(argv[1], "activate"))
+		return activate(argv[2], atoi(argv[3]),
+				SWAP_FLAG_DISCARD | SWAP_FLAG_DISCARD_ONCE);
+	if (argc == 4 && !strcmp(argv[1], "reject-page-discard"))
+		return reject_page_discard(argv[2], atoi(argv[3]));
+	if (argc == 4 && !strcmp(argv[1], "accept-discard-once-pages"))
+		return accept_discard_once_pages(argv[2], atoi(argv[3]));
+	if (argc == 3 && !strcmp(argv[1], "pin"))
+		return pin_to_one_cpu(argv[2]);
+	if (argc == 6 && !strcmp(argv[1], "allocate"))
+		return allocate(argv[2], argv[3], argv[4], argv[5]);
+
+	fprintf(stderr,
+		"usage: %s activate DEVICE PRIORITY | reject-page-discard DEVICE PRIORITY | accept-discard-once-pages DEVICE PRIORITY | pin PID | allocate BYTES CGROUP.PROCS READY VERIFIED\n",
+		argv[0]);
+	return 1;
+}
diff --git a/tools/testing/selftests/zram/workingset_offload.c b/tools/testing/selftests/zram/workingset_offload.c
new file mode 100644
index 000000000000..6d41badb8d0b
--- /dev/null
+++ b/tools/testing/selftests/zram/workingset_offload.c
@@ -0,0 +1,206 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+
+#include <errno.h>
+#include <fcntl.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <unistd.h>
+
+#define ANON_SIZE (64UL << 20)
+#define TARGET_SIZE (16UL << 20)
+#define FILLER_SIZE (32UL << 20)
+
+static int join_cgroup(const char *path)
+{
+	char pid[32];
+	int fd, len;
+
+	fd = open(path, O_WRONLY);
+	if (fd < 0)
+		return -1;
+	len = snprintf(pid, sizeof(pid), "%d\n", getpid());
+	if (write(fd, pid, len) != len) {
+		close(fd);
+		return -1;
+	}
+	return close(fd);
+}
+
+static int create_file(const char *path, size_t size)
+{
+	unsigned char page[4096];
+	size_t offset;
+	int fd;
+
+	fd = open(path, O_CREAT | O_TRUNC | O_RDWR, 0600);
+	if (fd < 0)
+		return -1;
+	memset(page, 0xa5, sizeof(page));
+	for (offset = 0; offset < size; offset += sizeof(page)) {
+		if (pwrite(fd, page, sizeof(page), offset) != sizeof(page)) {
+			close(fd);
+			return -1;
+		}
+	}
+	if (fsync(fd) || posix_fadvise(fd, 0, size, POSIX_FADV_DONTNEED)) {
+		close(fd);
+		return -1;
+	}
+	return fd;
+}
+
+static int cache_file(int fd, size_t size)
+{
+	unsigned char byte;
+	size_t offset;
+
+	if (posix_fadvise(fd, 0, size, POSIX_FADV_RANDOM))
+		return -1;
+	for (offset = 0; offset < size; offset += getpagesize())
+		if (pread(fd, &byte, 1, offset) != 1)
+			return -1;
+	return 0;
+}
+
+static unsigned long memory_stat(const char *path, const char *key)
+{
+	unsigned long value;
+	char name[64];
+	FILE *file;
+
+	file = fopen(path, "r");
+	if (!file)
+		return 0;
+	while (fscanf(file, "%63s %lu", name, &value) == 2) {
+		if (!strcmp(name, key)) {
+			fclose(file);
+			return value;
+		}
+	}
+	fclose(file);
+	return 0;
+}
+
+static int touch_ready(const char *path)
+{
+	int fd = open(path, O_WRONLY | O_CREAT | O_EXCL, 0600);
+
+	if (fd < 0)
+		return -1;
+	return close(fd);
+}
+
+static bool calibration_sufficient(size_t pages, unsigned long selected,
+				   unsigned long refaulted,
+				   unsigned long anon)
+{
+	return selected >= pages / 2 && refaulted >= selected * 3 / 4 &&
+	       anon >= TARGET_SIZE;
+}
+
+int main(int argc, char **argv)
+{
+	unsigned long refault_before, refault_after;
+	unsigned long activate_before, activate_after;
+	unsigned long anon, selected = 0;
+	unsigned char *resident, *anon_memory;
+	unsigned char byte, checksum = 0;
+	char stat_path[4096];
+	sigset_t signals;
+	size_t pages, i;
+	void *mapping;
+	int target_fd, filler_fd, signal;
+
+	if (argc != 6) {
+		fprintf(stderr, "usage: %s CGROUP.PROCS TARGET FILLER READY GO\n",
+			argv[0]);
+		return 1;
+	}
+	if (join_cgroup(argv[1])) {
+		perror("join cgroup");
+		return 1;
+	}
+
+	anon_memory = mmap(NULL, ANON_SIZE, PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (anon_memory == MAP_FAILED) {
+		perror("mmap anonymous");
+		return 1;
+	}
+	for (i = 0; i < ANON_SIZE; i += getpagesize())
+		anon_memory[i] = i / getpagesize() % 251 + 1;
+
+	target_fd = create_file(argv[2], TARGET_SIZE);
+	filler_fd = create_file(argv[3], FILLER_SIZE);
+	if (target_fd < 0 || filler_fd < 0) {
+		perror("create files");
+		return 1;
+	}
+	if (cache_file(target_fd, TARGET_SIZE) ||
+	    cache_file(filler_fd, FILLER_SIZE)) {
+		perror("populate page cache");
+		return 1;
+	}
+
+	sigemptyset(&signals);
+	sigaddset(&signals, SIGUSR1);
+	if (sigprocmask(SIG_BLOCK, &signals, NULL) || touch_ready(argv[4])) {
+		perror("prepare signal");
+		return 1;
+	}
+	if (sigwait(&signals, &signal)) {
+		perror("sigwait");
+		return 1;
+	}
+
+	mapping = mmap(NULL, TARGET_SIZE, PROT_READ, MAP_SHARED, target_fd, 0);
+	if (mapping == MAP_FAILED) {
+		perror("mmap target");
+		return 1;
+	}
+	pages = TARGET_SIZE / getpagesize();
+	resident = calloc(pages, 1);
+	if (!resident || mincore(mapping, TARGET_SIZE, resident)) {
+		perror("mincore");
+		return 1;
+	}
+	munmap(mapping, TARGET_SIZE);
+
+	snprintf(stat_path, sizeof(stat_path), "%.*s/memory.stat",
+		 (int)(strlen(argv[1]) - strlen("/cgroup.procs")), argv[1]);
+	refault_before = memory_stat(stat_path, "workingset_refault_file");
+	activate_before = memory_stat(stat_path, "workingset_activate_file");
+	for (i = 0; i < pages; i++) {
+		if (resident[i] & 1)
+			continue;
+		if (pread(target_fd, &byte, 1, i * getpagesize()) != 1) {
+			perror("refault target");
+			return 1;
+		}
+		selected++;
+	}
+	refault_after = memory_stat(stat_path, "workingset_refault_file");
+	activate_after = memory_stat(stat_path, "workingset_activate_file");
+	anon = memory_stat(stat_path, "active_anon") +
+	       memory_stat(stat_path, "inactive_anon");
+
+	for (i = 0; i < ANON_SIZE; i += getpagesize())
+		checksum ^= anon_memory[i];
+	printf("selected=%lu refault=%lu activate=%lu anon=%lu checksum=%u\n",
+	       selected, refault_after - refault_before,
+	       activate_after - activate_before, anon, checksum);
+
+	free(resident);
+	close(filler_fd);
+	close(target_fd);
+	if (!calibration_sufficient(pages, selected,
+				    refault_after - refault_before, anon))
+		return 2;
+	return (activate_after - activate_before) * 100 < selected * 80;
+}
diff --git a/tools/testing/selftests/zram/zram03.sh b/tools/testing/selftests/zram/zram03.sh
new file mode 100755
index 000000000000..3ccc9a135f99
--- /dev/null
+++ b/tools/testing/selftests/zram/zram03.sh
@@ -0,0 +1,166 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# Test proactive-only swap allocation and pressure fallback.
+
+set -eu
+
+# shellcheck source=zram_lib.sh
+. ./zram_lib.sh
+
+TCID="zram03"
+cg="/sys/fs/cgroup/zram-offload-$$"
+cgroup_root="/sys/fs/cgroup"
+ready="/tmp/zram-offload-ready-$$"
+verified="/tmp/zram-offload-verified-$$"
+allocator_pid=""
+offload=""
+zswap_enabled=""
+zswap_writeback=""
+
+fail()
+{
+	echo "$TCID: [FAIL] $*" >&2
+	exit 1
+}
+
+skip()
+{
+	echo "$TCID: [SKIP] $*" >&2
+	exit "$ksft_skip"
+}
+
+cleanup()
+{
+	set +e
+	if [ -n "$allocator_pid" ]; then
+		kill "$allocator_pid"
+		wait "$allocator_pid"
+	fi
+	rm -f "$ready" "$verified"
+	rmdir "$cg"
+	cgroup_disable_memory_controller "$cgroup_root"
+	if [ -n "$offload" ] && [ "$dev_makeswap" -lt "$dev_end" ]; then
+		swapoff "$offload" >/dev/null 2>&1
+	fi
+	if [ "$dev_end" -ge "$dev_start" ]; then
+		zram_cleanup
+	fi
+	if [ -n "$zswap_enabled" ]; then
+		echo "$zswap_enabled" > /sys/module/zswap/parameters/enabled
+	fi
+}
+
+swap_used_kb()
+{
+	awk -v device="$1" '$1 == device { print $4 }' /proc/swaps
+}
+
+zram_orig_data_size()
+{
+	awk '{ print $1 }' "/sys/block/${1##*/}/mm_stat"
+}
+
+wait_file()
+{
+	for _ in $(seq 1 400); do
+		[ -e "$1" ] && return 0
+		sleep 0.05
+	done
+	return 1
+}
+
+check_prereqs
+# The feature marker also requires CONFIG_VM_EVENT_COUNTERS.
+grep -q '^swpout_offload_refused ' /proc/vmstat ||
+	skip "offload refusal counters are unavailable"
+[ -x ./swap_offload ] || skip "swap_offload helper is unavailable"
+[ -e /sys/fs/cgroup/cgroup.controllers ] || skip "cgroup v2 controllers are unavailable"
+grep -qw memory /sys/fs/cgroup/cgroup.controllers || skip "memory controller is unavailable"
+[ -e /sys/module/zswap/parameters/enabled ] || skip "zswap is unavailable"
+zswap_enabled=$(cat /sys/module/zswap/parameters/enabled)
+
+# Keep every reclaim transition on one CPU.  This makes the test exercise the
+# cached-cluster provenance mismatch rather than relying on scheduler placement.
+./swap_offload pin "$$" || skip "cannot pin test to one allowed CPU"
+
+# Swap priorities are global. Put both test areas ahead of any existing swap
+# so distro-managed zram or another high-priority area cannot absorb the test
+# allocations and make the routing assertions fail spuriously.
+max_prio=$(awk 'BEGIN { max = -1 } NR > 1 && $5 > max { max = $5 } END { print max }' /proc/swaps)
+[ "$max_prio" -le 32765 ] || skip "cannot outrank existing swap priority $max_prio"
+safe_prio=$((max_prio + 1))
+offload_prio=$((max_prio + 2))
+
+dev_num=2
+zram_sizes="67108864 67108864"
+trap cleanup EXIT
+trap 'exit 129' HUP
+trap 'exit 130' INT
+trap 'exit 143' TERM
+zram_load
+echo Y > /sys/module/zswap/parameters/enabled || skip "cannot enable zswap"
+zram_set_disksizes
+
+safe="/dev/zram${dev_start}"
+offload="/dev/zram$((dev_start + 1))"
+mkswap "$safe" >/dev/null
+mkswap "$offload" >/dev/null
+swapon -p "$safe_prio" "$safe"
+dev_makeswap=$dev_start
+./swap_offload reject-page-discard "$offload" "$offload_prio" ||
+	fail "offload-only page discard was accepted"
+./swap_offload accept-discard-once-pages "$offload" "$offload_prio" ||
+	fail "resolved offload-only discard-once was rejected"
+./swap_offload activate "$offload" "$offload_prio"
+dev_makeswap=$dev_end
+
+cgroup_enable_memory_controller "$cgroup_root" ||
+	skip "cannot enable the cgroup v2 memory controller"
+mkdir "$cg" || skip "cannot create test cgroup"
+[ -e "$cg/memory.max" ] || skip "cgroup v2 memory controller is unavailable"
+echo max > "$cg/memory.swap.max"
+echo 1 > "$cg/memory.zswap.writeback" ||
+	skip "cannot enable zswap writeback for test cgroup"
+read -r zswap_writeback < "$cg/memory.zswap.writeback"
+[ "$zswap_writeback" -eq 1 ] ||
+	skip "an ancestor disables zswap writeback"
+
+./swap_offload allocate 67108864 "$cg/cgroup.procs" "$ready" "$verified" &
+allocator_pid=$!
+wait_file "$ready" || fail "allocator did not become ready"
+
+echo "16M swappiness=max" > "$cg/memory.reclaim" ||
+	fail "proactive reclaim failed"
+offload_before=$(swap_used_kb "$offload")
+safe_before=$(swap_used_kb "$safe")
+offload_orig=$(zram_orig_data_size "$offload")
+[ "${offload_before:-0}" -gt 0 ] || fail "proactive reclaim missed offload area"
+[ "${safe_before:-0}" -eq 0 ] || fail "proactive reclaim used lower-priority safe area"
+[ "$((offload_orig + 1048576))" -ge "$((offload_before * 1024))" ] ||
+	fail "zswap deferred the offload-only backend write"
+
+echo 24M > "$cg/memory.max"
+sleep 1
+offload_pressure=$(swap_used_kb "$offload")
+safe_pressure=$(swap_used_kb "$safe")
+safe_orig=$(zram_orig_data_size "$safe")
+[ "${safe_pressure:-0}" -gt 0 ] || fail "pressure reclaim missed safe fallback"
+[ "$offload_pressure" -le "$offload_before" ] ||
+	fail "pressure reclaim allocated offload-only slots"
+[ "$safe_orig" -lt "$((safe_pressure * 1024))" ] ||
+	fail "zswap did not retain any unmarked safe-area pages"
+
+echo max > "$cg/memory.max"
+echo "4M swappiness=max" > "$cg/memory.reclaim" ||
+	fail "second proactive reclaim failed"
+offload_after=$(swap_used_kb "$offload")
+[ "$offload_after" -gt "$offload_pressure" ] ||
+	fail "proactive priority was not restored after pressure reclaim"
+
+swapoff "$offload" || fail "swapoff could not recover offloaded pages"
+kill -USR1 "$allocator_pid" || fail "cannot request data verification"
+wait_file "$verified" || fail "allocator did not verify recovered data"
+kill -0 "$allocator_pid" || fail "allocator died during swapoff"
+dev_makeswap=$dev_start
+
+echo "$TCID: [PASS]"
diff --git a/tools/testing/selftests/zram/zram04.sh b/tools/testing/selftests/zram/zram04.sh
new file mode 100755
index 000000000000..a8f52a82e774
--- /dev/null
+++ b/tools/testing/selftests/zram/zram04.sh
@@ -0,0 +1,149 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# Reproduce offload-only swap leaking into the workingset refault heuristic.
+
+set -eu
+
+# shellcheck source=zram_lib.sh
+. ./zram_lib.sh
+
+TCID="zram04"
+cg="/sys/fs/cgroup/zram-workingset-$$"
+cgroup_root="/sys/fs/cgroup"
+tmp="${TMPDIR:-/var/tmp}/zram-workingset-$$"
+ready="$tmp/ready"
+worker=""
+tmp_fs=""
+mglru=""
+zswap_enabled=""
+
+fail()
+{
+	echo "$TCID: [FAIL] $*" >&2
+	exit 1
+}
+
+skip()
+{
+	echo "$TCID: [SKIP] $*" >&2
+	exit "$ksft_skip"
+}
+
+cleanup()
+{
+	set +e
+	[ -n "$worker" ] && kill "$worker"
+	[ -n "$worker" ] && wait "$worker"
+	rm -rf "$tmp"
+	rmdir "$cg"
+	cgroup_disable_memory_controller "$cgroup_root"
+	[ "$dev_end" -ge "$dev_start" ] && zram_cleanup
+	[ -n "$mglru" ] && echo "$mglru" > /sys/kernel/mm/lru_gen/enabled
+	[ -n "$zswap_enabled" ] &&
+		echo "$zswap_enabled" > /sys/module/zswap/parameters/enabled
+}
+
+wait_helper_ready()
+{
+	for _ in $(seq 1 400); do
+		[ -e "$ready" ] && return 0
+		worker_state=$(awk '{ print $3 }' "/proc/$worker/stat" \
+			2>/dev/null || :)
+		if ! kill -0 "$worker" 2>/dev/null ||
+		   [ "$worker_state" = Z ]; then
+			if wait "$worker"; then
+				status=0
+			else
+				status=$?
+			fi
+			worker=""
+			[ "$status" -eq 2 ] &&
+				skip "workingset calibration was insufficient"
+			fail "workingset helper exited with status $status before readiness"
+		fi
+		sleep 0.05
+	done
+	fail "workingset helper timed out before readiness"
+}
+
+check_prereqs
+# The feature marker also requires CONFIG_VM_EVENT_COUNTERS.
+grep -q '^swpout_offload_refused ' /proc/vmstat ||
+	skip "offload refusal counters are unavailable"
+[ -x ./swap_offload ] || skip "swap_offload helper is unavailable"
+[ -x ./workingset_offload ] || skip "workingset helper is unavailable"
+[ -e /sys/fs/cgroup/cgroup.controllers ] || skip "cgroup v2 is unavailable"
+grep -qw memory /sys/fs/cgroup/cgroup.controllers ||
+	skip "cgroup v2 memory controller is unavailable"
+[ "$(awk 'END { print NR }' /proc/swaps)" -eq 1 ] ||
+	skip "test requires no pre-existing swap"
+tmp_fs=$(stat -f -c %T "${TMPDIR:-/var/tmp}") ||
+	skip "cannot identify the test filesystem"
+[ "$tmp_fs" != tmpfs ] ||
+	skip "test files require a disk-backed filesystem"
+
+[ -e /sys/kernel/mm/lru_gen/enabled ] &&
+	mglru=$(cat /sys/kernel/mm/lru_gen/enabled)
+[ -e /sys/module/zswap/parameters/enabled ] &&
+	zswap_enabled=$(cat /sys/module/zswap/parameters/enabled)
+trap cleanup EXIT
+trap 'exit 129' HUP
+trap 'exit 130' INT
+trap 'exit 143' TERM
+[ -n "$mglru" ] && echo 0 > /sys/kernel/mm/lru_gen/enabled
+[ -n "$zswap_enabled" ] && echo N > /sys/module/zswap/parameters/enabled
+
+dev_num=1
+zram_sizes="134217728"
+zram_load
+zram_set_disksizes
+offload="/dev/zram${dev_start}"
+mkswap "$offload" >/dev/null
+./swap_offload activate "$offload" 1
+dev_makeswap=$dev_end
+
+cgroup_enable_memory_controller "$cgroup_root" ||
+	skip "cannot enable the cgroup v2 memory controller"
+mkdir "$cg" || skip "cannot create test cgroup"
+[ -e "$cg/memory.max" ] || skip "cgroup v2 memory controller is unavailable"
+echo max > "$cg/memory.max"
+echo max > "$cg/memory.swap.max"
+mkdir "$tmp"
+
+./workingset_offload "$cg/cgroup.procs" "$tmp/target" "$tmp/filler" \
+	"$ready" unused &
+worker=$!
+wait_helper_ready
+
+# Shadow retention uses local LRU/slab statistics updated by memcg flushing.
+# Check that the 64 MiB anonymous and 48 MiB file setup is visible before
+# evicting file pages.
+stats_ready=0
+for _ in $(seq 1 50); do
+	if awk '
+		$1 == "active_anon" || $1 == "inactive_anon" { anon += $2 }
+		$1 == "file" { file = $2 }
+		END { exit !(anon >= 67108864 && file >= 50331648) }
+	' "$cg/memory.stat"; then
+		stats_ready=1
+		break
+	fi
+	sleep 0.1
+done
+[ "$stats_ready" -eq 1 ] ||
+	skip "initial working-set statistics did not become visible"
+
+echo "48M swappiness=0" > "$cg/memory.reclaim" ||
+	skip "file-only proactive reclaim failed"
+kill -USR1 "$worker"
+if wait "$worker"; then
+	worker=""
+	echo "$TCID: [PASS]"
+	exit 0
+else
+	status=$?
+fi
+worker=""
+[ "$status" -eq 2 ] && skip "workingset calibration was insufficient"
+echo "$TCID: [FAIL] refaulted file pages were not activated" >&2
+exit 1
diff --git a/tools/testing/selftests/zram/zram_lib.sh b/tools/testing/selftests/zram/zram_lib.sh
index 0d44d83888f9..f14966d3820d 100755
--- a/tools/testing/selftests/zram/zram_lib.sh
+++ b/tools/testing/selftests/zram/zram_lib.sh
@@ -17,6 +17,10 @@ kernel_version=`uname -r | cut -d'.' -f1,2`
 kernel_major=${kernel_version%.*}
 kernel_minor=${kernel_version#*.}
 
+# Whether this test enabled the memory controller on its cgroup parent.  Tests
+# must leave a delegation which was already present alone.
+cgroup_memory_controller_enabled=0
+
 trap INT
 
 check_prereqs()
@@ -30,6 +34,30 @@ check_prereqs()
 	fi
 }
 
+cgroup_enable_memory_controller()
+{
+	local cgroup_root=$1
+
+	if grep -qw memory "$cgroup_root/cgroup.subtree_control"; then
+		return 0
+	fi
+
+	if ! echo +memory > "$cgroup_root/cgroup.subtree_control"; then
+		return 1
+	fi
+
+	cgroup_memory_controller_enabled=1
+}
+
+cgroup_disable_memory_controller()
+{
+	local cgroup_root=$1
+
+	[ "$cgroup_memory_controller_enabled" -eq 1 ] || return 0
+	echo -memory > "$cgroup_root/cgroup.subtree_control" || return 1
+	cgroup_memory_controller_enabled=0
+}
+
 kernel_gte()
 {
 	major=${1%.*}
-- 
2.55.0


