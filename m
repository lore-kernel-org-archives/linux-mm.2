Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 420F3C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 02:57:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFC386B0093; Sun, 12 Jul 2026 22:57:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0FF76B0096; Sun, 12 Jul 2026 22:57:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A39896B0098; Sun, 12 Jul 2026 22:57:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5888F6B0095
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 22:57:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C5B89169FE6
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 02:56:59 +0000 (UTC)
X-FDA: 84982241358.14.DF13DEE
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8381640005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 02:56:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf12.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783911418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h/lOv/PdYWCyWAE+gkFWPidKFhAhY540MVFQFLKX75U=;
	b=lLD8/YtiJBOrYwiNIjUgXRy7mUujGmSfESEyM/nkp+xkuGG+Stq9Wjc0VrJLlTTqoUWp+y
	Wx24b3WUsTcFLRiss12Oe1nfdjh1TlJei6jOIEgjE69v86euR7uLAOhOBXMnHnmWJXvOTS
	0dH7qmUF7WUtFDB20O9vYrQCxrNDnY0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf12.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783911418;
	b=k83FL86qWFtcbOhQcAaaUNVG31K0iuzq0+I4OKmz1FlyYoA4bPLjGN6LOmW/GLXIpvV2A+
	eD6r4NFbnJ0G18hnuelfVxsovsUENIGkqzYkt9NKHsvG5Mh8aLFgQ1E9X6vtjL/jfc8iA3
	E4xaVXoU9IRDKMOMvhVp3+pF544PTYA=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 13 Jul 2026 11:56:55 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	yosry@kernel.org,
	joshua.hahnjy@gmail.com,
	gunho.lee@lge.com,
	taejoon.song@lge.com,
	hyungjun.cho@lge.com,
	baver.bae@lge.com,
	her0gyugyu@gmail.com
Subject: [PATCH v10 6/6] selftests/cgroup: add a swap tier routing test
Date: Mon, 13 Jul 2026 11:56:44 +0900
Message-Id: <20260713025644.170839-7-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260713025644.170839-1-youngjun.park@lge.com>
References: <20260713025644.170839-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8381640005
X-Stat-Signature: 6zgy4fom6yagjd5neih1zezrf7puyirj
X-HE-Tag: 1783911417-487473
X-HE-Meta: U2FsdGVkX1+Bdmzt9EcnWU+PHPO+3r+eMhXNZ239BjDUZT4Rhxxo6qkX6HHXqSqSJpoOCpfIB0F4YHTEqd38imALYosUzvESOuXhu3faaNutPcgGYt4zr7OzH1dRfxEWHPl9rz96qYB2vgXqIZnoxSeVRS7UicYrpMw+1+FuZxY43PrI7HZWtbBl8hcE8JUeWWkLxCfsmBqfF9vNGqbw6KBLtK6yZy5wFaRUnqLP7JR3g53P8X00CBpE5pILz2Vc5Q7Fd3u6Rn6IiASpfHXc8GoU4PVY1aHWY3NAZY+Nz4/whNOVjgiHteUqa7JVc6Lc7EPJYeXOWTi7KxPYLNoc6/5t9BwpNXyUNLMpu0HvDk2nO8LEZGEv9gEeWWJ4vHWuQJGspFTAUSaSEhuRIrvKk6ymQkf5TM2fetQl/ptmkuJdd+O/bCwyWUT4OXXZqUp0WRiNzhEaGdquhERCY9/Q2FCUkgAdUHkcUdt9ayrCyy9FXxoKVCHLQUCVaGSgz/r0VooF+FnmHKm8gJkGLDl1r2bV1dqK7UQecM6Yhkj0ETBvk5UO+UdgnCuRFBkwC2VVBVJ8wUTN+YnFOPCd+B4htVNIWo4uWDYJ0+VfFJfDgnpLe5Z5+M2+wgQSu80V467tGR5HO5XGaa278VV9p9XBPj23GjT2IRHkOXRc2OASERH+mPzbU3BrVtKmR1tKyxRh7EwosiRkQDBEAk9lo+9oCF5HaRT1JVj/7voiMnPxCV1YFVmoe568EYoRkklcZP+5AG0vedNsAmtWBR0s/MBbDitLUPBN/dSPc0FVRAT7egYVWuAUFbdcBADvQ+6kNQuiRy5rY3hakxf2cQnDSfm87HfKA0JEylfh3yFDd/UNOQy27ePX0onNCRVvGvnLDjsUD4y7hMylAuRu8N4lbE0PjzXdxtsPsbd6mSNjkLry/ZTV8n8eap8AMfhXdQl6zCvTJrOLrng1qm6UunDzLtw
 mP3LfNht
 f7TaQt9+0Zag02efHflaXg99mFrmC9R2WYbgQidCH/Q2OT0MAa/1mwzbrQJI+c7hDabTCa8LIOZ/agxSUeB/BE4KwmtCnXovemxeST8V84CTgtBKjNjE1aku6ITQ9etfwF0zobAs59YGpUmw5iLuLyDK1c0Do8Zd1/qzJrPSfStOQ8kn/vJ4itvXKZBwnNaux+6kc7obtD8s9RnTl1m+gchylt1i8WJ6Ej4+V7aD3S/vVdEQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This commit adds a test program for the per-cgroup swap tier control
memory.swap.tiers.max. It checks the default mask, toggling a tier,
rejection of invalid input, and that recreating a tier resets the mask.
It also checks that a cgroup's pages swap only to an allowed tier,
including across the parent and child hierarchy. The routing check uses
two zram devices placed in different tiers.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 tools/testing/selftests/cgroup/.gitignore     |   1 +
 tools/testing/selftests/cgroup/Makefile       |   2 +
 tools/testing/selftests/cgroup/config         |   2 +
 .../selftests/cgroup/test_swap_tiers.c        | 509 ++++++++++++++++++
 4 files changed, 514 insertions(+)
 create mode 100644 tools/testing/selftests/cgroup/test_swap_tiers.c

diff --git a/tools/testing/selftests/cgroup/.gitignore b/tools/testing/selftests/cgroup/.gitignore
index 952e4448bf07..77b8e6c3e592 100644
--- a/tools/testing/selftests/cgroup/.gitignore
+++ b/tools/testing/selftests/cgroup/.gitignore
@@ -8,5 +8,6 @@ test_kill
 test_kmem
 test_memcontrol
 test_pids
+test_swap_tiers
 test_zswap
 wait_inotify
diff --git a/tools/testing/selftests/cgroup/Makefile b/tools/testing/selftests/cgroup/Makefile
index e01584c2189a..a98e3c414cd5 100644
--- a/tools/testing/selftests/cgroup/Makefile
+++ b/tools/testing/selftests/cgroup/Makefile
@@ -16,6 +16,7 @@ TEST_GEN_PROGS += test_kill
 TEST_GEN_PROGS += test_kmem
 TEST_GEN_PROGS += test_memcontrol
 TEST_GEN_PROGS += test_pids
+TEST_GEN_PROGS += test_swap_tiers
 TEST_GEN_PROGS += test_zswap
 
 LOCAL_HDRS += $(selfdir)/clone3/clone3_selftests.h $(selfdir)/pidfd/pidfd.h
@@ -32,4 +33,5 @@ $(OUTPUT)/test_kill: $(LIBCGROUP_O)
 $(OUTPUT)/test_kmem: $(LIBCGROUP_O)
 $(OUTPUT)/test_memcontrol: $(LIBCGROUP_O)
 $(OUTPUT)/test_pids: $(LIBCGROUP_O)
+$(OUTPUT)/test_swap_tiers: $(LIBCGROUP_O)
 $(OUTPUT)/test_zswap: $(LIBCGROUP_O)
diff --git a/tools/testing/selftests/cgroup/config b/tools/testing/selftests/cgroup/config
index 39f979690dd3..6086bb5bba97 100644
--- a/tools/testing/selftests/cgroup/config
+++ b/tools/testing/selftests/cgroup/config
@@ -4,3 +4,5 @@ CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_MEMCG=y
 CONFIG_PAGE_COUNTER=y
+CONFIG_SWAP=y
+CONFIG_ZRAM=y
diff --git a/tools/testing/selftests/cgroup/test_swap_tiers.c b/tools/testing/selftests/cgroup/test_swap_tiers.c
new file mode 100644
index 000000000000..9b4484409ed4
--- /dev/null
+++ b/tools/testing/selftests/cgroup/test_swap_tiers.c
@@ -0,0 +1,509 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <linux/limits.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/swap.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include "kselftest.h"
+#include "cgroup_util.h"
+
+#ifndef MADV_PAGEOUT
+#define MADV_PAGEOUT 21
+#endif
+
+#define TIERS_PATH "/sys/kernel/mm/swap/tiers"
+#define TIERS_MAX "memory.swap.tiers.max"
+
+static int tiers_write(const char *cmd)
+{
+	int fd, ret = 0;
+
+	fd = open(TIERS_PATH, O_WRONLY);
+	if (fd < 0)
+		return -errno;
+	if (write(fd, cmd, strlen(cmd)) < 0)
+		ret = -errno;
+	close(fd);
+	return ret;
+}
+
+static int tier_count(void)
+{
+	char buf[4096], *line, *save;
+	int fd, count = 0;
+	ssize_t n;
+
+	fd = open(TIERS_PATH, O_RDONLY);
+	if (fd < 0)
+		return -1;
+	n = read(fd, buf, sizeof(buf) - 1);
+	close(fd);
+	if (n < 0)
+		return -1;
+	buf[n] = '\0';
+
+	for (line = strtok_r(buf, "\n", &save); line;
+	     line = strtok_r(NULL, "\n", &save)) {
+		char name[64];
+		int idx, s, e;
+
+		if (sscanf(line, "%63s %d %d %d", name, &idx, &s, &e) == 4)
+			count++;
+	}
+	return count;
+}
+
+static long swap_used_kb(const char *dev)
+{
+	char line[256];
+	long used = -1;
+	FILE *f;
+
+	f = fopen("/proc/swaps", "r");
+	if (!f)
+		return -1;
+	while (fgets(line, sizeof(line), f)) {
+		char name[128], type[64];
+		long size, u, prio;
+
+		if (sscanf(line, "%127s %63s %ld %ld %ld",
+			   name, type, &size, &u, &prio) >= 4 &&
+		    !strcmp(name, dev)) {
+			used = u;
+			break;
+		}
+	}
+	fclose(f);
+	return used;
+}
+
+static int swap_active_count(void)
+{
+	char line[256];
+	int n = 0;
+	FILE *f;
+
+	f = fopen("/proc/swaps", "r");
+	if (!f)
+		return -1;
+	if (fgets(line, sizeof(line), f))
+		while (fgets(line, sizeof(line), f))
+			n++;
+	fclose(f);
+	return n;
+}
+
+static void zram_remove(int idx);
+static int zram_add(long size)
+{
+	char path[128], val[64];
+	ssize_t n;
+	int idx, fd;
+
+	fd = open("/sys/class/zram-control/hot_add", O_RDONLY);
+	if (fd < 0)
+		return -1;
+	n = read(fd, val, sizeof(val) - 1);
+	close(fd);
+	if (n <= 0)
+		return -1;
+	val[n] = '\0';
+	idx = atoi(val);
+
+	snprintf(path, sizeof(path), "/sys/block/zram%d/disksize", idx);
+	fd = open(path, O_WRONLY);
+	if (fd < 0) {
+		zram_remove(idx);
+		return -1;
+	}
+
+	snprintf(val, sizeof(val), "%ld", size);
+	n = write(fd, val, strlen(val));
+	close(fd);
+
+	if (n != strlen(val)) {
+		zram_remove(idx);
+		return -1;
+	}
+
+	return idx;
+}
+
+static void zram_remove(int idx)
+{
+	char val[16];
+	int fd;
+
+	fd = open("/sys/class/zram-control/hot_remove", O_WRONLY);
+	if (fd < 0)
+		return;
+	snprintf(val, sizeof(val), "%d", idx);
+	write(fd, val, strlen(val)); /* ignore: best-effort cleanup */
+	close(fd);
+}
+
+static int swap_setup(const char *dev, int prio)
+{
+	char cmd[128];
+
+	snprintf(cmd, sizeof(cmd), "mkswap %s >/dev/null 2>&1", dev);
+	if (system(cmd))
+		return -1;
+	return swapon(dev, SWAP_FLAG_PREFER | (prio & SWAP_FLAG_PRIO_MASK));
+}
+
+static int test_default(const char *root)
+{
+	char *cg = cg_name(root, "swaptier_default");
+	int ret = KSFT_FAIL;
+
+	if (!cg || cg_create(cg))
+		goto out;
+	if (!cg_read_strstr(cg, TIERS_MAX, "fast max") &&
+	    !cg_read_strstr(cg, TIERS_MAX, "slow max"))
+		ret = KSFT_PASS;
+out:
+	if (cg) {
+		cg_destroy(cg);
+		free(cg);
+	}
+	return ret;
+}
+
+static int test_toggle(const char *root)
+{
+	char *cg = cg_name(root, "swaptier_toggle");
+	int ret = KSFT_FAIL;
+
+	if (!cg || cg_create(cg))
+		goto out;
+	if (cg_write(cg, TIERS_MAX, "fast 0"))
+		goto out;
+	if (cg_read_strstr(cg, TIERS_MAX, "fast 0"))
+		goto out;
+	if (cg_write(cg, TIERS_MAX, "fast max"))
+		goto out;
+	if (cg_read_strstr(cg, TIERS_MAX, "fast max"))
+		goto out;
+	ret = KSFT_PASS;
+out:
+	if (cg) {
+		cg_destroy(cg);
+		free(cg);
+	}
+	return ret;
+}
+
+static int test_invalid(const char *root)
+{
+	char *cg = cg_name(root, "swaptier_invalid");
+	int ret = KSFT_FAIL;
+
+	if (!cg || cg_create(cg))
+		goto out;
+	if (!cg_write(cg, TIERS_MAX, "nosuchtier 0"))
+		goto out;
+	if (!cg_write(cg, TIERS_MAX, "fast bogus"))
+		goto out;
+	ret = KSFT_PASS;
+out:
+	if (cg) {
+		cg_destroy(cg);
+		free(cg);
+	}
+	return ret;
+}
+
+static int test_recreate(const char *root)
+{
+	char *cg = cg_name(root, "swaptier_recreate");
+	int ret = KSFT_FAIL;
+
+	if (!cg || cg_create(cg))
+		goto out;
+	if (cg_write(cg, TIERS_MAX, "fast 0"))
+		goto out;
+	if (cg_read_strstr(cg, TIERS_MAX, "fast 0"))
+		goto out;
+	if (tiers_write("-fast") || tiers_write("+fast:10"))
+		goto out;
+	if (cg_read_strstr(cg, TIERS_MAX, "fast max"))
+		goto out;
+	ret = KSFT_PASS;
+out:
+	if (cg) {
+		cg_destroy(cg);
+		free(cg);
+	}
+	return ret;
+}
+
+static int swapout_child(const char *cgroup, void *arg)
+{
+	size_t size = (size_t)arg;
+	char *mem;
+	size_t i;
+	int page_size;
+
+	mem = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (mem == MAP_FAILED)
+		return -1;
+
+	page_size = sysconf(_SC_PAGE_SIZE);
+	for (i = 0; i < size; i += page_size)
+		mem[i] = 'x';
+	if (madvise(mem, size, MADV_PAGEOUT))
+		return -1;
+	/* Hold the swap entries while the parent inspects /proc/swaps. */
+	pause();
+	return 0;
+}
+
+static int wait_for_dev(const char *dev, const char *dev2)
+{
+	int i;
+
+	for (i = 0; i < 50; i++) {
+		if (access(dev, F_OK) == 0 && access(dev2, F_OK) == 0)
+			return 0;
+
+		usleep(100000);
+	}
+
+	return -1;
+}
+
+static int run_routing_case(const char *cg)
+{
+	char fast_dev[32], slow_dev[32];
+	int zfast = -1, zslow = -1;
+	long used_fast, used_slow;
+	int ret = KSFT_SKIP;
+	pid_t pid = -1;
+	int i;
+
+	/* Only our devices must be present, so usage is unambiguous. */
+	if (swap_active_count() != 0)
+		return KSFT_SKIP;
+
+	zfast = zram_add(MB(128));
+	if (zfast < 0)
+		goto out;
+	snprintf(fast_dev, sizeof(fast_dev), "/dev/zram%d", zfast);
+
+	zslow = zram_add(MB(128));
+	if (zslow < 0)
+		goto out;
+	snprintf(slow_dev, sizeof(slow_dev), "/dev/zram%d", zslow);
+
+	if (wait_for_dev(fast_dev, slow_dev))
+		goto out;
+
+	/* prio 10 -> 'fast' tier [10, MAX]; prio 0 -> 'slow' tier [-1, 9]. */
+	if (swap_setup(fast_dev, 10) || swap_setup(slow_dev, 0))
+		goto out;
+
+	ret = KSFT_FAIL;
+
+	pid = cg_run_nowait(cg, swapout_child, (void *)MB(64));
+	if (pid < 0)
+		goto out;
+
+	for (i = 0; i < 300; i++) {		/* up to ~30s for pageout */
+		if (swap_used_kb(slow_dev) > 0)
+			break;
+		usleep(100000);
+	}
+
+	used_fast = swap_used_kb(fast_dev);
+	used_slow = swap_used_kb(slow_dev);
+	if (used_slow > 0 && used_fast == 0)
+		ret = KSFT_PASS;
+	else
+		ksft_print_msg("routing[%s]: fast=%ldKB slow=%ldKB (want fast=0, slow>0)\n",
+			       cg, used_fast, used_slow);
+out:
+	if (pid > 0) {
+		kill(pid, SIGKILL);
+		waitpid(pid, NULL, 0);
+	}
+	if (zfast >= 0) {
+		swapoff(fast_dev);
+		zram_remove(zfast);
+	}
+	if (zslow >= 0) {
+		swapoff(slow_dev);
+		zram_remove(zslow);
+	}
+	return ret;
+}
+
+static int test_routing(const char *root)
+{
+	char *cg = cg_name(root, "swaptier_routing");
+	int ret = KSFT_FAIL;
+
+	if (!cg || cg_create(cg))
+		goto out;
+	if (cg_write(cg, TIERS_MAX, "fast 0"))
+		goto out;
+	ret = run_routing_case(cg);
+out:
+	if (cg) {
+		cg_destroy(cg);
+		free(cg);
+	}
+	return ret;
+}
+
+static char *make_parent(const char *root, const char *name)
+{
+	char *cg = cg_name(root, name);
+
+	if (cg && !cg_create(cg) &&
+	    !cg_write(cg, "cgroup.subtree_control", "+memory"))
+		return cg;
+
+	if (cg) {
+		cg_destroy(cg);
+		free(cg);
+	}
+	return NULL;
+}
+
+static int test_routing_parent_wins(const char *root)
+{
+	char *parent = make_parent(root, "swaptier_pwins");
+	char *child = NULL;
+	int ret = KSFT_FAIL;
+
+	if (!parent)
+		goto out;
+	if (cg_write(parent, TIERS_MAX, "fast 0"))
+		goto out;
+
+	child = cg_name(parent, "child");
+	if (!child || cg_create(child))
+		goto out;
+	if (cg_write(child, TIERS_MAX, "fast max"))	/* child tries to re-enable */
+		goto out;
+
+	ret = run_routing_case(child);
+out:
+	if (child) {
+		cg_destroy(child);
+		free(child);
+	}
+	if (parent) {
+		cg_destroy(parent);
+		free(parent);
+	}
+	return ret;
+}
+
+static int test_routing_child_restricts(const char *root)
+{
+	char *parent = make_parent(root, "swaptier_crestr");
+	char *child = NULL;
+	int ret = KSFT_FAIL;
+
+	if (!parent)
+		goto out;
+
+	child = cg_name(parent, "child");
+	if (!child || cg_create(child))
+		goto out;
+	if (cg_write(child, TIERS_MAX, "fast 0"))
+		goto out;
+
+	ret = run_routing_case(child);
+out:
+	if (child) {
+		cg_destroy(child);
+		free(child);
+	}
+	if (parent) {
+		cg_destroy(parent);
+		free(parent);
+	}
+	return ret;
+}
+
+static void tiers_clear(void)
+{
+	char buf[4096], *line, *save;
+	int fd;
+	ssize_t n;
+
+	fd = open(TIERS_PATH, O_RDONLY);
+	if (fd < 0)
+		return;
+	n = read(fd, buf, sizeof(buf) - 1);
+	close(fd);
+	if (n < 0)
+		return;
+	buf[n] = '\0';
+
+	for (line = strtok_r(buf, "\n", &save); line;
+	     line = strtok_r(NULL, "\n", &save)) {
+		char name[64], cmd[80];
+		int idx, s, e;
+
+		if (sscanf(line, "%63s %d %d %d", name, &idx, &s, &e) != 4)
+			continue;
+		snprintf(cmd, sizeof(cmd), "-%s", name);
+		tiers_write(cmd);
+	}
+}
+
+int main(void)
+{
+	char root[PATH_MAX];
+
+	ksft_print_header();
+	ksft_set_plan(7);
+
+	if (geteuid() != 0)
+		ksft_exit_skip("test requires root\n");
+	if (cg_find_unified_root(root, sizeof(root), NULL))
+		ksft_exit_skip("cgroup v2 isn't mounted\n");
+	if (cg_read_strstr(root, "cgroup.controllers", "memory"))
+		ksft_exit_skip("memory controller isn't available\n");
+	if (cg_read_strstr(root, "cgroup.subtree_control", "memory"))
+		if (cg_write(root, "cgroup.subtree_control", "+memory"))
+			ksft_exit_skip("failed to enable memory controller\n");
+	if (access(TIERS_PATH, F_OK))
+		ksft_exit_skip("swap tiers interface not present\n");
+	if (tier_count() != 0)
+		ksft_exit_skip("swap tiers already configured; run on a clean system\n");
+
+	/* Two tiers: fast = [10, MAX], slow = [-1, 9]. */
+	if (tiers_write("+slow:-1 +fast:10"))
+		ksft_exit_skip("failed to configure swap tiers\n");
+
+	ksft_test_result(test_default(root) == KSFT_PASS, "default mask is max\n");
+	ksft_test_result(test_toggle(root) == KSFT_PASS, "enable/disable tier\n");
+	ksft_test_result(test_invalid(root) == KSFT_PASS, "invalid input rejected\n");
+	ksft_test_result(test_recreate(root) == KSFT_PASS,
+			 "recreated tier resets cgroup mask\n");
+
+	ksft_test_result_code(test_routing(root),
+			      "swapout honors tier mask", NULL);
+	ksft_test_result_code(test_routing_parent_wins(root),
+			      "child cannot re-enable a parent-disabled tier", NULL);
+	ksft_test_result_code(test_routing_child_restricts(root),
+			      "child can restrict tiers below its parent", NULL);
+
+	tiers_clear();
+
+	ksft_finished();
+}
-- 
2.34.1


