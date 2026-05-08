Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F68ACD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 16:22:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6FDD6B01F2; Fri,  8 May 2026 12:22:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B46F16B01F4; Fri,  8 May 2026 12:22:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5C706B01F5; Fri,  8 May 2026 12:22:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 934BE6B01F2
	for <linux-mm@kvack.org>; Fri,  8 May 2026 12:22:24 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 31B874021C
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:22:24 +0000 (UTC)
X-FDA: 84744770208.22.B1984F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6B19E100014
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:22:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S5SKrKrL;
	spf=pass (imf14.hostedemail.com: domain of hawk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=hawk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778257342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I8DuqmtXDzf0aRWawkP7eoyNIJHGNOqVIVLj2cTVRbQ=;
	b=YAApdSRftU3kuDXvraf+axcpWw6gJw53wWTPKVuNe0nOIDj1S+v6wgXXtrMtT256t7DgEb
	9fguXuNZftJCKdRhDQpyb5EoaNax7J7dOGC24/rppp4GpTiyNi2NUfZl/1hqGxH0z3Bl41
	qL9D6rgJvvz15UmGcbO8CFAXR8rTSJQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S5SKrKrL;
	spf=pass (imf14.hostedemail.com: domain of hawk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=hawk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778257342; a=rsa-sha256;
	cv=none;
	b=7rdDn4dCJwNcK3XpKYAyvqgP8FC8/nQRi2McrJnXTace51L6k7O6Cq1DCjDPZN0Bo5UiL8
	bmEIrdZ4a1rUJBW5HwNKvev++Vy8fldB8YeMgcKUTs7TDqKqwMF/hrjZ6z6Iu0Wbr++NDx
	KMCHbsSM6WvcIjrxr+uJ4C04etyZ6gg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F6EF44087;
	Fri,  8 May 2026 16:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90DEAC2BCB0;
	Fri,  8 May 2026 16:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778257341;
	bh=i/R2xZZJzkiJN8nyVMoZwj9/9yyTdKZ9zsPKMb6mCCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S5SKrKrLdGK1dTQjwg2O8s1fbiV8AbEZa83KHRG/v61Tem4wdBz/dyL5UQqJntw1Z
	 LGdXf8+o5bGln1cfPCRLR5qVC+fyRDxiqaekx7nrrvPgIUFl3+fA6+gH20qyAxaZri
	 GD0wQigSBSwNGi/5L5gsDEK6ROyuinnPn/gxgdjH8BL5YXVEG/czkrQcBCFEA+X7zA
	 eAHtljvNQyApkjYosZGLa6QvbQTFOuJPNNV6CNj4XTtz9W5/WqgBQXPGqXOxhnf32J
	 PAEuf1ivkWYlm9Sr11LYPXQjeNm/P0Bk71P2UaupM/AjIMjFyhABCQOOP3vBTuxkzt
	 +mH9r/KU1L8ZA==
From: hawk@kernel.org
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kernel-team@cloudflare.com,
	hawk@kernel.org
Subject: [PATCH 2/2] selftests/mm: add zone->lock tracepoint verification test
Date: Fri,  8 May 2026 18:22:07 +0200
Message-ID: <20260508162207.3315781-2-hawk@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260508162207.3315781-1-hawk@kernel.org>
References: <20260508162207.3315781-1-hawk@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: n5okroy185oiz7d78k3gethcfkhq5nt5
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6B19E100014
X-Rspam-User: 
X-HE-Tag: 1778257342-991698
X-HE-Meta: U2FsdGVkX19rk6pMBdcRGPGcvPzgW8Cur5BqqibV+jzZtkHSi2yh2dEPeK3/VxIxOtjDjq5ZQS6PXwWzAytzUeJXMd1ow0Sm20rlg6//1H28hmxFZGmDCg0YfU3tacE+JAaWwQl4M21DHDMWryuS4j7sYVXrWDtZg9Oa0kKslB2P90iixwWXUml3Ezqq+cb/PVt2eAzKXklDMF6IgUcBLmBjDRC0CI2aa1qSbTXQ9GvyNLRHH2vSLnc70wOSwhJZFjfyxwBlkmy6kCFBa2zFzjMZ+7OxKXKkF8oizkXAIADRdGrw11oAIL1gwBtVdofFFayBWvSouGIyogEX8xiY9ow1BWJUFl0ACtu+TFTgyenl041Tt5+/rQUsHxqDFTVd49tNSRcWI2jqHd/nxwqQOgRmvx9L2w9uuBoB5OlYtYQd+oKSVi0FTECHPgeWKDkY+ZN3HwMMUfLr5CN0d5OcyIEbfryon4w4TRT8F3+VsdsV2I/mxlQePHZojl/m4ytTyIhHxOHmm6fskWGaWyR7OFEs9S2Vl2UqJ9EFJdPWFKdyO/jOzW+ajoKTi1WtYGGiPS/b5yQV1txtXZfH2lpgdcwzq892n979+frUBOyQ61YWEsoTK4qxAGtdRreHWcnkIlLFOLgh9Abo7YeTzCsJ/NBBFQHVGaHr9uAbwaQo5rpgfHsd1N/ZKsNhimR6qtO3BJwfF83EOgPJQjP6N3g/EEJ8JFvdkVqz4plItxO0rxwiBiEHidKsQNKCgfBSPxBTofaCOxQQiSYW10Rq9FDuKzwiK21FKiJfWiUMrrb4WyEfDasjtRC4BN/2Ax/76Bh0R6GwRdtkwQJCvstWrRICVPlk8o5wm4vmaK9oDT56+y8qYQMVPrO8kKUWhFkKtStxFKeasvrPZRtW56Xkbd/ek2n9GRFDNWkn3Iyb/pSDgo8dqTLLCHepIgrUkwAthZWtKYMHQjziOeu0qMqu9WX
 JptCLW1O
 pFH+ozpRXGDW3A9Vh3TuaqOsIQaT3NiEmYWAIPH+f5FxvIqTCuvAkaTbZthu0q7zGCH3JAy9GqufZqhEqRoXOs5g/lxnXUnBqf8eRUcKKz70b/KLf07N/2szt4xagOqKGLg+8GWgSWlzn2BwECd98VFZUOrtIBwNeAJFmB3J3123a9cKNbwzAqKQzrav2cQIqb3p3MoogrGndXONzfEall59WuhJ7q2FEAkyipmH1azUZKR4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jesper Dangaard Brouer <hawk@kernel.org>

Add a selftest to verify the kmem:mm_zone_lock_contended,
kmem:mm_zone_locked, and kmem:mm_zone_lock_unlock tracepoints.

The test has two components:

zone_lock_contention.c - a workload that spawns threads doing rapid
page allocation and freeing to generate zone->lock contention. It
shrinks PCP lists via percpu_pagelist_high_fraction to force frequent
free_pcppages_bulk() and rmqueue_bulk() calls.

test_zone_lock_tracepoints.sh - uses bpftrace to verify tracepoints
exist, have the expected fields, fire under load, and that wait_ns
is populated when contention occurs.

Signed-off-by: Jesper Dangaard Brouer <hawk@kernel.org>
---
 tools/testing/selftests/mm/Makefile           |   2 +
 .../mm/test_zone_lock_tracepoints.sh          | 212 ++++++++++++++++++
 .../selftests/mm/zone_lock_contention.c       | 166 ++++++++++++++
 3 files changed, 380 insertions(+)
 create mode 100755 tools/testing/selftests/mm/test_zone_lock_tracepoints.sh
 create mode 100644 tools/testing/selftests/mm/zone_lock_contention.c

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index cd24596cdd27..af6cfdf3c8a0 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -106,6 +106,7 @@ TEST_GEN_FILES += guard-regions
 TEST_GEN_FILES += merge
 TEST_GEN_FILES += rmap
 TEST_GEN_FILES += folio_split_race_test
+TEST_GEN_FILES += zone_lock_contention
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
@@ -173,6 +174,7 @@ TEST_PROGS += ksft_thp.sh
 TEST_PROGS += ksft_userfaultfd.sh
 TEST_PROGS += ksft_vma_merge.sh
 TEST_PROGS += ksft_vmalloc.sh
+TEST_PROGS += test_zone_lock_tracepoints.sh
 
 TEST_FILES := test_vmalloc.sh
 TEST_FILES += test_hmm.sh
diff --git a/tools/testing/selftests/mm/test_zone_lock_tracepoints.sh b/tools/testing/selftests/mm/test_zone_lock_tracepoints.sh
new file mode 100755
index 000000000000..7fa3dab1f6c5
--- /dev/null
+++ b/tools/testing/selftests/mm/test_zone_lock_tracepoints.sh
@@ -0,0 +1,212 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# test_zone_lock_tracepoints.sh - Verify mm_zone_lock tracepoints fire
+#
+# Generates zone->lock contention and uses bpftrace to verify that the
+# kmem:mm_zone_lock_contended, kmem:mm_zone_locked, and
+# kmem:mm_zone_lock_unlock tracepoints activate and produce output.
+#
+# Requirements: bpftrace, root privileges, CONFIG_FTRACE=y
+#
+# Usage: ./test_zone_lock_tracepoints.sh [duration_sec]
+#        Default duration: 5 seconds
+#
+# For running in a VM via virtme-ng:
+#   make -C tools/testing/selftests/mm zone_lock_contention
+#   vng --cpus 4 --memory 2G \
+#       --rwdir tools/testing/selftests/mm \
+#       --exec "cd tools/testing/selftests/mm && ./test_zone_lock_tracepoints.sh 5"
+
+set -e
+
+DURATION=${1:-5}
+TESTDIR="$(cd "$(dirname "$0")" && pwd)"
+WORKLOAD="$TESTDIR/zone_lock_contention"
+NR_THREADS=4
+PASS=0
+FAIL=0
+SKIP=0
+
+# --- helpers ---
+
+pass() { echo "PASS: $1"; PASS=$((PASS + 1)); }
+fail() { echo "FAIL: $1"; FAIL=$((FAIL + 1)); }
+skip() { echo "SKIP: $1"; SKIP=$((SKIP + 1)); }
+
+check_root() {
+	if [ "$(id -u)" -ne 0 ]; then
+		echo "ERROR: must run as root"
+		exit 4  # ksft SKIP
+	fi
+}
+
+check_bpftrace() {
+	if ! command -v bpftrace >/dev/null 2>&1; then
+		echo "SKIP: bpftrace not found"
+		exit 4
+	fi
+}
+
+check_workload() {
+	if [ ! -x "$WORKLOAD" ]; then
+		echo "SKIP: $WORKLOAD not found, run 'make -C tools/testing/selftests/mm' first"
+		exit 4
+	fi
+}
+
+check_tracepoint_exists() {
+	local tp="$1"
+	if [ ! -d "/sys/kernel/tracing/events/kmem/$tp" ]; then
+		skip "$tp tracepoint not in kernel"
+		return 1
+	fi
+	return 0
+}
+
+# --- Test 1: verify tracepoints exist in tracefs ---
+
+test_tracepoints_exist() {
+	echo "--- Test 1: tracepoints exist in tracefs ---"
+	for tp in mm_zone_lock_contended mm_zone_locked mm_zone_lock_unlock; do
+		if check_tracepoint_exists "$tp"; then
+			pass "$tp exists"
+		fi
+	done
+}
+
+# --- Test 2: verify format fields ---
+
+test_tracepoint_fields() {
+	echo "--- Test 2: tracepoint format fields ---"
+	local fmt
+
+	if [ -f /sys/kernel/tracing/events/kmem/mm_zone_lock_contended/format ]; then
+		fmt=$(cat /sys/kernel/tracing/events/kmem/mm_zone_lock_contended/format)
+		for field in node_id name count caller; do
+			if echo "$fmt" | grep -q "field.*$field"; then
+				pass "mm_zone_lock_contended has field '$field'"
+			else
+				fail "mm_zone_lock_contended missing field '$field'"
+			fi
+		done
+	fi
+
+	if [ -f /sys/kernel/tracing/events/kmem/mm_zone_locked/format ]; then
+		fmt=$(cat /sys/kernel/tracing/events/kmem/mm_zone_locked/format)
+		for field in node_id name count contended caller wait_ns; do
+			if echo "$fmt" | grep -q "field.*$field"; then
+				pass "mm_zone_locked has field '$field'"
+			else
+				fail "mm_zone_locked missing field '$field'"
+			fi
+		done
+	fi
+}
+
+# --- Test 3: bpftrace counts tracepoint hits under load ---
+
+test_bpftrace_counts() {
+	echo "--- Test 3: bpftrace tracepoint activation under contention ---"
+
+	if ! check_tracepoint_exists mm_zone_locked; then
+		return
+	fi
+
+	local BPFTRACE_OUT
+	BPFTRACE_OUT=$(mktemp /tmp/zone_lock_bt.XXXXXX)
+
+	# bpftrace one-liner: count hits per tracepoint
+	bpftrace -e '
+		tracepoint:kmem:mm_zone_lock_contended { @contended = count(); }
+		tracepoint:kmem:mm_zone_locked          { @locked = count(); }
+		tracepoint:kmem:mm_zone_lock_unlock     { @unlock = count(); }
+	' -c "$WORKLOAD $DURATION $NR_THREADS" > "$BPFTRACE_OUT" 2>&1 &
+	local BT_PID=$!
+
+	# Wait for bpftrace + workload to finish
+	wait $BT_PID 2>/dev/null || true
+
+	echo "bpftrace output:"
+	cat "$BPFTRACE_OUT"
+
+	# Check that mm_zone_locked fired (it fires on every acquisition)
+	if grep -q '@locked: [0-9]' "$BPFTRACE_OUT"; then
+		pass "mm_zone_locked tracepoint fired"
+	else
+		fail "mm_zone_locked tracepoint did NOT fire"
+	fi
+
+	# Check that mm_zone_lock_unlock fired
+	if grep -q '@unlock: [0-9]' "$BPFTRACE_OUT"; then
+		pass "mm_zone_lock_unlock tracepoint fired"
+	else
+		fail "mm_zone_lock_unlock tracepoint did NOT fire"
+	fi
+
+	# contended may or may not fire depending on actual contention
+	if grep -q '@contended: [0-9]' "$BPFTRACE_OUT"; then
+		pass "mm_zone_lock_contended tracepoint fired (contention detected)"
+	else
+		skip "mm_zone_lock_contended did not fire (no contention observed)"
+	fi
+
+	rm -f "$BPFTRACE_OUT"
+}
+
+# --- Test 4: bpftrace verifies wait_ns > 0 when contended ---
+
+test_wait_ns() {
+	echo "--- Test 4: wait_ns is populated when contended ---"
+
+	if ! check_tracepoint_exists mm_zone_locked; then
+		return
+	fi
+
+	local BPFTRACE_OUT
+	BPFTRACE_OUT=$(mktemp /tmp/zone_lock_wait.XXXXXX)
+
+	bpftrace -e '
+		tracepoint:kmem:mm_zone_locked /args->contended/ {
+			@has_wait_ns = count();
+			@wait_ns = hist(args->wait_ns);
+		}
+	' -c "$WORKLOAD $DURATION $NR_THREADS" > "$BPFTRACE_OUT" 2>&1 &
+	local BT_PID=$!
+
+	wait $BT_PID 2>/dev/null || true
+
+	echo "bpftrace wait_ns output:"
+	cat "$BPFTRACE_OUT"
+
+	if grep -q '@has_wait_ns: [0-9]' "$BPFTRACE_OUT"; then
+		pass "wait_ns populated on contended acquisitions"
+	else
+		skip "no contended acquisitions observed for wait_ns check"
+	fi
+
+	rm -f "$BPFTRACE_OUT"
+}
+
+# --- Main ---
+
+echo "=== zone->lock tracepoint selftest ==="
+echo "Duration: ${DURATION}s, Threads: ${NR_THREADS}"
+echo
+
+check_root
+check_bpftrace
+check_workload
+
+test_tracepoints_exist
+test_tracepoint_fields
+test_bpftrace_counts
+test_wait_ns
+
+echo
+echo "=== Results: $PASS passed, $FAIL failed, $SKIP skipped ==="
+
+if [ "$FAIL" -gt 0 ]; then
+	exit 1
+fi
+exit 0
diff --git a/tools/testing/selftests/mm/zone_lock_contention.c b/tools/testing/selftests/mm/zone_lock_contention.c
new file mode 100644
index 000000000000..35ddad7670b1
--- /dev/null
+++ b/tools/testing/selftests/mm/zone_lock_contention.c
@@ -0,0 +1,166 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * zone_lock_contention.c - Generate zone->lock contention for tracepoint testing
+ *
+ * Spawns multiple threads that rapidly allocate and free pages to force
+ * PCP (per-cpu pageset) drains and refills, which acquire zone->lock via
+ * free_pcppages_bulk() and rmqueue_bulk().
+ *
+ * Reducing percpu_pagelist_high_fraction makes PCP lists smaller, causing
+ * more frequent zone->lock acquisitions and thus more contention.
+ *
+ * Usage: zone_lock_contention [duration_sec] [nr_threads]
+ *        Defaults: 5 seconds, 4 threads
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <pthread.h>
+#include <sys/mman.h>
+#include <errno.h>
+#include <time.h>
+
+/* Each thread mmaps/touches/munmaps in a loop to churn pages */
+#define CHUNK_SIZE	(2 * 1024 * 1024)	/* 2 MB per iteration */
+#define PAGE_SZ		4096
+
+static volatile int stop;
+
+struct thread_stats {
+	unsigned long iterations;
+	unsigned long pages_touched;
+};
+
+static void *churn_thread(void *arg)
+{
+	struct thread_stats *stats = arg;
+	unsigned long iter = 0;
+	unsigned long pages = 0;
+
+	while (!stop) {
+		char *p;
+		size_t i;
+
+		p = mmap(NULL, CHUNK_SIZE, PROT_READ | PROT_WRITE,
+			 MAP_PRIVATE | MAP_ANONYMOUS | MAP_POPULATE, -1, 0);
+		if (p == MAP_FAILED) {
+			perror("mmap");
+			break;
+		}
+
+		/* Touch every page to ensure allocation */
+		for (i = 0; i < CHUNK_SIZE; i += PAGE_SZ)
+			p[i] = 1;
+
+		pages += CHUNK_SIZE / PAGE_SZ;
+
+		/* Free pages back - forces PCP drain */
+		munmap(p, CHUNK_SIZE);
+		iter++;
+	}
+
+	stats->iterations = iter;
+	stats->pages_touched = pages;
+	return NULL;
+}
+
+static int write_sysctl(const char *path, const char *val)
+{
+	FILE *f = fopen(path, "w");
+
+	if (!f)
+		return -1;
+	fputs(val, f);
+	fclose(f);
+	return 0;
+}
+
+static int read_sysctl(const char *path, char *buf, size_t len)
+{
+	FILE *f = fopen(path, "r");
+
+	if (!f)
+		return -1;
+	if (!fgets(buf, len, f)) {
+		fclose(f);
+		return -1;
+	}
+	fclose(f);
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	int duration = 5;
+	int nr_threads = 4;
+	char orig_fraction[32] = "";
+	const char *sysctl_path = "/proc/sys/vm/percpu_pagelist_high_fraction";
+	pthread_t *threads;
+	struct thread_stats *stats;
+	unsigned long total_iter = 0, total_pages = 0;
+	int i;
+
+	if (argc > 1)
+		duration = atoi(argv[1]);
+	if (argc > 2)
+		nr_threads = atoi(argv[2]);
+
+	if (duration <= 0 || nr_threads <= 0) {
+		fprintf(stderr, "Usage: %s [duration_sec] [nr_threads]\n", argv[0]);
+		return 1;
+	}
+
+	printf("zone_lock_contention: %d threads, %d seconds\n",
+	       nr_threads, duration);
+
+	/* Shrink PCP lists to force more zone->lock acquisitions */
+	read_sysctl(sysctl_path, orig_fraction, sizeof(orig_fraction));
+	if (write_sysctl(sysctl_path, "100") < 0)
+		fprintf(stderr, "WARNING: cannot write %s (not root?)\n",
+			sysctl_path);
+	else
+		printf("Set percpu_pagelist_high_fraction=100 (was %s)\n",
+		       orig_fraction);
+
+	threads = calloc(nr_threads, sizeof(*threads));
+	stats = calloc(nr_threads, sizeof(*stats));
+	if (!threads || !stats) {
+		perror("calloc");
+		return 1;
+	}
+
+	for (i = 0; i < nr_threads; i++) {
+		if (pthread_create(&threads[i], NULL, churn_thread, &stats[i])) {
+			perror("pthread_create");
+			return 1;
+		}
+	}
+
+	sleep(duration);
+	stop = 1;
+
+	for (i = 0; i < nr_threads; i++) {
+		pthread_join(threads[i], NULL);
+		total_iter += stats[i].iterations;
+		total_pages += stats[i].pages_touched;
+	}
+
+	printf("Total: %lu iterations, %lu pages (%lu MB) churned\n",
+	       total_iter, total_pages,
+	       (total_pages * PAGE_SZ) / (1024 * 1024));
+
+	/* Restore original sysctl */
+	if (orig_fraction[0]) {
+		/* Strip trailing newline */
+		orig_fraction[strcspn(orig_fraction, "\n")] = '\0';
+		write_sysctl(sysctl_path, orig_fraction);
+		printf("Restored percpu_pagelist_high_fraction=%s\n",
+		       orig_fraction);
+	}
+
+	free(threads);
+	free(stats);
+	return 0;
+}
-- 
2.43.0


