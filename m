Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5995CC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 02:57:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EA546B0092; Sun, 12 Jul 2026 22:57:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46D3B6B0093; Sun, 12 Jul 2026 22:57:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BF326B0096; Sun, 12 Jul 2026 22:57:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D450C6B0092
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 22:56:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 13B78A09D9
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 02:56:59 +0000 (UTC)
X-FDA: 84982241358.29.0773F2B
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf18.hostedemail.com (Postfix) with ESMTP id BD6511C0003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 02:56:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783911417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Xfn4G0tVK/QUuE40rcQyJ+WAOYe8Jmd50eFHRuRo+4=;
	b=0v+gsUXM8fL5ZzKmC8s54JIC8YRLZbP9dg0J1MeCxXUX8xpJbq33vagaSCvjEP5NT2iGdc
	l8CluLMIMkCruYWZvFDic0W8vM+T4Mwu8NCOx39YuNyA1gR1ksIJq34gVTjuv2vwlfXPZ6
	pIMYd4cq5+BTj/qDxz9QDE7r3/fKvrU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783911417;
	b=16YAGJxb/9bje/ceNa9lNFW+Hm2knNVRhEfWHNUf3AmY9LSwBpdQv7eS+l0OV5OtNZmOjN
	5SMYyT+TQW0f0qdPdfVRAjpFwqfJv+8XWmseipp2EIzmw60XDnX8Qb6FCUbeTd/eo8Fhb6
	MaCYq3CxzSUe1/jKSidHN4DfRMarLE4=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 13 Jul 2026 11:56:54 +0900
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
Subject: [PATCH v10 5/6] selftests/mm: add a swap tier configuration test
Date: Mon, 13 Jul 2026 11:56:43 +0900
Message-Id: <20260713025644.170839-6-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260713025644.170839-1-youngjun.park@lge.com>
References: <20260713025644.170839-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BD6511C0003
X-Stat-Signature: 3ku4fcjjuiz4g4m3faswttttdbtiyzfu
X-HE-Tag: 1783911416-912078
X-HE-Meta: U2FsdGVkX1/xr1EyFpg6mUZrgE8Mvq/biv5GxZp7/A+4LjSmYkkqSeO9WRXRW+wMCLL7mLqZbVWlYh7dRizcMl1abkgDGeCGy04iK5DTBOX4dgaKk1JkH7ziOTzacPhj9Ee/WktNiUUM6WKEFnxCpJTGmjGKzd1F3XmEZnJLOllxn837ufF4ZO1sRSNAEX7Nz+EUart6WtftK4HHC7zdUn2rqHpwPlQxxO2DwqdwJNPgK9d556sbqWjrfj8ZSNqOkcjKqvCCsjIO8JtrspRHgMI0JccQJ+rySiDq24dj1rJtxh1ROvms2Vy729heqKtdboxl4gjHelm6Afq4UM8jYcV+tRJSSkq9Sh9vc1aRRmiBFHho4CMSfbIiRnCptNNqCP4blW7I4Lh91IfFNru997WZkBr5Dop+6OCczpk6nqt/16x4Ecl3etBuyX9rEfwuKbrOYmDdsfAt/luN+8NLakbplM44SO1Zr5awBEMCWDmRR/lYlqT0RhxczMnVVIVsoIkc88ReXMubg8gCgPAuDx5ntDQHfnNuUPC943JhXYynEUqH0EW9za0UfImLYqr0xHLUr4uqeinlIxTY4b3MKcC4pDlUNpVohlCOfocMdHgSkkGssWXLVvmZw7pVT7gfcS3tVEokwsrTGEm8m1EeMvc9rDepQVWCbinObhfjVf1y14dP12rbTuKaA5kMrxu3NYTqRm/7C2JoeMZJAvJ3rqdmfuPbTQG3JdXkdtAbEjP9kcDmTImB1D6hXK/eAZLcJ7SW1vSVw3d7r+R7A0L82MLarRTufnroOnXqn+sIuSGgPGBtk7LaJmlAWIGUMvipwUP1+SfPtcwFAY4nuRkvHZzw3MRIYbApcPkCLYEHK5KZ95oKr+ruYXYDXFOHQOQB2qu5g+f51ZCATxz0hU9EarEjwhnkI7BjgIg6Pe+QAcsHwO0jjLA8VZ9na72Q+xrZtyb6kSuD3MnImbQauCl
 0ZgHwAHs
 kruDRAiZwTqjGrc/nM1EMt2x+n4T5R1WUqsDWDHFrbZGWmNrXdrB9lpacnnqnfkdjKJud7bXgmSOsCugzL4+/WibdI1aZbCpDIo1kRxLMZvORMOUrpksI9Hh4wYX2eww9BFv4yPXt7aQEsoICNmxcjwvSWz672NR/nFFK/VQkoVORap+9yuDgXz41YYh4U27ntAUI9n1wmYhRQCgue+PYCDy2eVfqB1QDsc4ueKfLabFU0Xw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This commit adds a test program for the global swap tier interface at
/sys/kernel/mm/swap/tiers. It checks the add, split and remove
operations and the documented error and batch atomicity rules. It also
checks that a tier with an active swap device cannot be removed until
the device is swapped off. That device is a zram device, and the check
is skipped when zram is not available.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 tools/testing/selftests/mm/.gitignore     |   1 +
 tools/testing/selftests/mm/Makefile       |   1 +
 tools/testing/selftests/mm/config         |   2 +
 tools/testing/selftests/mm/run_vmtests.sh |   5 +
 tools/testing/selftests/mm/swap_tier.c    | 337 ++++++++++++++++++++++
 5 files changed, 346 insertions(+)
 create mode 100644 tools/testing/selftests/mm/swap_tier.c

diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
index 227476d8ff1f..94ee61a9914d 100644
--- a/tools/testing/selftests/mm/.gitignore
+++ b/tools/testing/selftests/mm/.gitignore
@@ -44,6 +44,7 @@ hmm-tests
 memfd_secret
 soft-dirty
 split_huge_page_test
+swap_tier
 ksm_tests
 local_config.h
 local_config.mk
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index ee8def9b4c31..4e47191e06ff 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -104,6 +104,7 @@ TEST_GEN_FILES += guard-regions
 TEST_GEN_FILES += merge
 TEST_GEN_FILES += rmap
 TEST_GEN_FILES += folio_split_race_test
+TEST_GEN_FILES += swap_tier
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
diff --git a/tools/testing/selftests/mm/config b/tools/testing/selftests/mm/config
index 06f78bd232e2..de3752e1bbd2 100644
--- a/tools/testing/selftests/mm/config
+++ b/tools/testing/selftests/mm/config
@@ -14,3 +14,5 @@ CONFIG_UPROBES=y
 CONFIG_MEMORY_FAILURE=y
 CONFIG_HWPOISON_INJECT=m
 CONFIG_PROC_MEM_ALWAYS_FORCE=y
+CONFIG_SWAP=y
+CONFIG_ZRAM=y
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index a60b9f9f16e7..06d53fad82ba 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -71,6 +71,8 @@ separated by spaces:
 	tests for VM_PFNMAP handling
 - process_madv
 	test for process_madv
+- swap_tier
+	test the /sys/kernel/mm/swap/tiers configuration interface
 - cow
 	test copy-on-write semantics
 - thp
@@ -352,6 +354,9 @@ CATEGORY="process_madv" run_test ./process_madv
 
 CATEGORY="vma_merge" run_test ./merge
 
+# swap tier configuration interface (/sys/kernel/mm/swap/tiers)
+CATEGORY="swap_tier" run_test ./swap_tier
+
 if [ -x ./memfd_secret ]
 then
 if [ -f /proc/sys/kernel/yama/ptrace_scope ]; then
diff --git a/tools/testing/selftests/mm/swap_tier.c b/tools/testing/selftests/mm/swap_tier.c
new file mode 100644
index 000000000000..bc77b59a7270
--- /dev/null
+++ b/tools/testing/selftests/mm/swap_tier.c
@@ -0,0 +1,337 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/swap.h>
+#include <unistd.h>
+
+#include "kselftest.h"
+
+#define TIERS_PATH "/sys/kernel/mm/swap/tiers"
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
+static int tier_range(const char *name, int *start, int *end)
+{
+	char buf[4096], *line, *save;
+	int fd;
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
+		char tname[64];
+		int idx, s, e;
+
+		if (sscanf(line, "%63s %d %d %d", tname, &idx, &s, &e) != 4)
+			continue;
+		if (!strcmp(tname, name)) {
+			*start = s;
+			*end = e;
+			return 0;
+		}
+	}
+	return -1;
+}
+
+static bool tier_exists(const char *name)
+{
+	int s, e;
+
+	return tier_range(name, &s, &e) == 0;
+}
+
+static bool range_is(const char *name, int start, int end)
+{
+	int s, e;
+
+	if (tier_range(name, &s, &e))
+		return false;
+	return s == start && e == end;
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
+		char tname[64];
+		int idx, s, e;
+
+		if (sscanf(line, "%63s %d %d %d", tname, &idx, &s, &e) == 4)
+			count++;
+	}
+	return count;
+}
+
+static int test_coverage(void)
+{
+	if (tiers_write("+orphan:100") != -EINVAL)
+		return KSFT_FAIL;
+	if (tier_exists("orphan"))
+		return KSFT_FAIL;
+	return KSFT_PASS;
+}
+
+static int test_add(void)
+{
+	if (tiers_write("+lo:-1 +hi:50"))
+		return KSFT_FAIL;
+	if (!range_is("hi", 50, SHRT_MAX) || !range_is("lo", -1, 49))
+		return KSFT_FAIL;
+	return KSFT_PASS;
+}
+
+static int test_split(void)
+{
+	if (tiers_write("+mid:100"))
+		return KSFT_FAIL;
+	if (!range_is("mid", 100, SHRT_MAX) ||
+	    !range_is("hi", 50, 99) ||
+	    !range_is("lo", -1, 49))
+		return KSFT_FAIL;
+	return KSFT_PASS;
+}
+
+static int test_remove(void)
+{
+	/* Remove the top tier: 'hi' re-expands upward to SHRT_MAX. */
+	if (tiers_write("-mid"))
+		return KSFT_FAIL;
+	if (tier_exists("mid") || !range_is("hi", 50, SHRT_MAX))
+		return KSFT_FAIL;
+
+	/* Remove the lowest tier: 'hi' shifts its start down to -1. */
+	if (tiers_write("-lo"))
+		return KSFT_FAIL;
+	if (tier_exists("lo") || !range_is("hi", -1, SHRT_MAX))
+		return KSFT_FAIL;
+
+	return KSFT_PASS;
+}
+
+static int test_errors(void)
+{
+	if (tiers_write("+hi:100") != -EEXIST)		/* duplicate name */
+		return KSFT_FAIL;
+	if (tiers_write("+bad.name:100") != -EINVAL)	/* illegal name */
+		return KSFT_FAIL;
+	if (tiers_write("+dup:-1") != -EBUSY)		/* priority in use */
+		return KSFT_FAIL;
+	if (tiers_write("+low:-2") != -EINVAL)		/* prio < DEF_SWAP_PRIO */
+		return KSFT_FAIL;
+	return KSFT_PASS;
+}
+
+/*
+ * A write carrying several operations is atomic: if any operation fails, the
+ * whole batch is rolled back.
+ */
+static int test_atomic(void)
+{
+	if (tiers_write("+a:50 +a:60") != -EEXIST)
+		return KSFT_FAIL;
+	if (tier_exists("a") || !range_is("hi", -1, SHRT_MAX))
+		return KSFT_FAIL;
+	return KSFT_PASS;
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
+	write(fd, val, strlen(val)); /* ignore error. best-effort cleanup */
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
+static int wait_for_dev(const char *dev)
+{
+	int i;
+
+	for (i = 0; i < 50; i++) {
+		if (access(dev, F_OK) == 0)
+			return 0;
+
+		usleep(100000);
+	}
+
+	return -1;
+}
+
+static int test_device_pins_tier(void)
+{
+	char dev[32];
+	int zidx, ret = KSFT_FAIL;
+
+	if (tiers_write("+top:50"))
+		return KSFT_FAIL;
+
+	zidx = zram_add(64 << 20);
+	if (zidx < 0) {
+		ret = KSFT_SKIP;
+		goto out_tier;
+	}
+	snprintf(dev, sizeof(dev), "/dev/zram%d", zidx);
+
+	if (wait_for_dev(dev)) {
+		ret = KSFT_SKIP;
+		goto out_zram;
+	}
+
+	if (swap_setup(dev, 50)) {
+		ret = KSFT_SKIP;
+		goto out_zram;
+	}
+
+	if (tiers_write("-top") == -EBUSY) {		/* blocked while active */
+		swapoff(dev);
+		if (!tiers_write("-top"))		/* removable after swapoff */
+			ret = KSFT_PASS;
+	} else {
+		swapoff(dev);
+	}
+out_zram:
+	zram_remove(zidx);
+out_tier:
+	tiers_write("-top");
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
+	ksft_print_header();
+	ksft_set_plan(7);
+
+	if (geteuid() != 0)
+		ksft_exit_skip("test requires root\n");
+	if (access(TIERS_PATH, F_OK))
+		ksft_exit_skip("%s not present (CONFIG_SWAP/tiers)\n", TIERS_PATH);
+	if (tier_count() != 0)
+		ksft_exit_skip("swap tiers already configured; run on a clean system\n");
+
+	ksft_test_result(test_coverage() == KSFT_PASS, "coverage rule\n");
+	ksft_test_result(test_add() == KSFT_PASS, "add tiers\n");
+	ksft_test_result(test_split() == KSFT_PASS, "split tier\n");
+	ksft_test_result(test_remove() == KSFT_PASS, "remove and merge\n");
+	ksft_test_result(test_errors() == KSFT_PASS, "invalid operations\n");
+	ksft_test_result(test_atomic() == KSFT_PASS, "batch atomicity\n");
+
+	ksft_test_result_code(test_device_pins_tier(), "device pins its tier", NULL);
+
+	tiers_clear();
+
+	ksft_finished();
+}
-- 
2.34.1


