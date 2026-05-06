Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E08BCD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 12:58:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A00486B0093; Wed,  6 May 2026 08:58:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D9CE6B0095; Wed,  6 May 2026 08:58:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 852966B0096; Wed,  6 May 2026 08:58:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6299A6B0093
	for <linux-mm@kvack.org>; Wed,  6 May 2026 08:58:51 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 072281C0130
	for <linux-mm@kvack.org>; Wed,  6 May 2026 12:58:51 +0000 (UTC)
X-FDA: 84736999662.22.FCCB7C4
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf04.hostedemail.com (Postfix) with ESMTP id CABF540007
	for <linux-mm@kvack.org>; Wed,  6 May 2026 12:58:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=jraVxtYN;
	spf=pass (imf04.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778072329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2hsVRlQ0/XX4Lvi0I/xpVpRnUAFS0o/pLAACrLv+p0o=;
	b=ybp8Rzc1mhl9S35hexuNjF0AqcBt6fvMgIMDw9mBhD2ygdC2WWu4nKVcr5pqs6I5etx7qb
	UBSLEGF+lEWERAnUWLMvMFyRtLPW6S79/+kMyQ0jintDN6W/YoP8XBWES7U9FZKFkNoxiQ
	6SxnBJk3X2KzcDy5/3nuIEWRftWGqIw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=jraVxtYN;
	spf=pass (imf04.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778072329; a=rsa-sha256;
	cv=none;
	b=bbLDd7ux4kiarEQm2i1lCDII+/V9ZCVJz+GI3eNZBqKQNrJju8HrLqYnhTsnnWawAFWaO+
	Khw5QWF0UZGGrhZ7b2fKQsbk1Tcfpb1f6SHBXVAgxQfLKhZCTCj+/pS4zAtT/yRxypPFjD
	g++jtfCbrqBqbn3gqrpFut++uH6s+Pc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=2hsVRlQ0/XX4Lvi0I/xpVpRnUAFS0o/pLAACrLv+p0o=; b=jraVxtYN1uxjFGa7BOQO0ljKe3
	P2D5GD57RerSjRBpXmC0xoHyF0G6mm7q3OA/5McgtVadBlKrbkgsQK8QQNx7C8Y4iWeVzrrXM97QH
	0V0iGe+tv3QOcBVJuJeoEQ5rR8B3/ihiQpJepwzjpISZa7ZTNF6/zad8/fhc3X2jwW3nU+FS42wEx
	P4oEHhYkteY7p//mLjtFKhITI4xfahDoTlMi2pw8DhDe+zuowE0046d/h/DBX0yNW+PKbN3fSgSl6
	EXXvFKDvQI36DU/Wv6jc+6coG+73yBzxV4Y3YxKLpmWuqlLgdWQWmQB6w92EAafmZ8qB8tB4/A2ET
	2P7zhS/g==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wKbpv-003bXE-0D;
	Wed, 06 May 2026 12:58:47 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 06 May 2026 05:58:25 -0700
Subject: [PATCH v3 2/2] selftests/mm: add kmemleak verbose dedup test
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260506-kmemleak_dedup-v3-2-2d36aafc34da@debian.org>
References: <20260506-kmemleak_dedup-v3-0-2d36aafc34da@debian.org>
In-Reply-To: <20260506-kmemleak_dedup-v3-0-2d36aafc34da@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=11971; i=leitao@debian.org;
 h=from:subject:message-id; bh=HNC66DdFx4sxkSUiDErSM+03OizehuxGGcWPFdtoziU=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBp+zr4xjlpSgfZccRUtxvPoN9gmYDCYd9w3aw+e
 haQcdA4/OuJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCafs6+AAKCRA1o5Of/Hh3
 bRu5EACbe2n8sEFVlNV7iME6df0isHCDSn9g0/XMeEPxc3C9rVN3X/KCR3WTqXg5HDIgVlM8zMn
 KNQ9TbwE+VRtuGTNUhxikalOHsFzl6QhU3SYP7ZnEkhCDcCvS/LiFvqp+2dqMZ6nBHJcGguHWsF
 UTn+fLGDoCex4pFRXJKjBP9N8eARUMp2/dvV01IOMD4wBi+u/sIobZnAYA0BgNvOm1e4Kls5j0n
 o1uFDeSSnCtBpFRP7kd08z+pbcU4gwJGWmhJyzxDmCIrQa4HWzU3wdzwiVOgSolo9f3Nw8vjEFu
 kaaONZAN+HLAw0xF1f00n2/NRM/gEANQ6+eirWbOROio9dULbAilMBC7qRaIbEicd4raN0g351u
 olihrQNNagsWFNHMd9zZFoN8m+WRbf4N3ZH59FfB2xFGKNlFrsesdmK9iYyuaZMRe/pNbfOKopK
 Ae5ub2JKgxHjcdMK68zd+wjaYWm4aNS3tYwDIjn4PRXLnjbLsmXdLfeYSTwQSUSUva+vOC2reDU
 7+MkdTa9IKXYhQ3157AYtWzbAphAlDaZMxwODAKi23uWa+q02Ec3izpIFI9LHy+kluEAYLKbmcL
 xKzmZoOfps5bLawFRahPyf+p7Ch14CYFB0Hm4OOnaAjbdQxU+1eOpvmTGIZBohCw+eCrd0s6f6+
 GQY8qP7qKPnSHkA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CABF540007
X-Stat-Signature: 95fzn3krhbwbzsdidctruz8u7wksb46q
X-HE-Tag: 1778072328-944235
X-HE-Meta: U2FsdGVkX1+JgTKYvpQgslAAzmzpJNxWDzeWZ9chBobSn7JjQzcgmRnlQ75toES9srmEezQ1EdlVAYtlmRtzGgkQSYrJEIUvrx38tKHZUBFwwZ+5iHIJcpiajMOwhPiQ+9RM3gLM66BALXhakb5MwsEZNShENVUDEFW/TY1XshXif5tChWkhn/JjSK4QglEIoqhRaD5W1IIcPkCu1DneyZHRMYsNgvSiM8Qo899HMnNRtX7HB7n0VmW9ZucwuF7aUuWFUsYM9QF1oTmLduuElZVSXl3NyEQFGAnMz4lCvFILFTwyZF1E2PvwtqiPswet064uCEOq8XB/fVAiheAj491h9z+lAFMpZeczdpQn+894XZjOo2+Yz7hGVka1RMzTthk8Lo/wzHXvMsDyRGbFUc/8/yDORijjLiiEzv7WcCY9TCUq+JCjOkjxK85h464QXvE62fwGZ1KlkCsPqC5PtmZbqq9jR0LLxsjS08vKUrJgHwgCTiUSfWLvznP6Q72Ng0iIUs+THL+7PUYQPlxzzPimO8PZ+t0LSVxNx1i3cE63lG+BbNFH4I3GK1Bnav+L89VqWOKYkdHKgcrKPnbBjKruSJqCmOtK4EDdOWT8EKLH+u4d/bDSbu5LM/dPWHeGmoPD7QcnMED3CGOdUyP+JK+XvytNK1uLOTcfIezkskrr1fPlqV+EDUWvE6N2XykBSYDSzNahlY4lg6bct3bgVpqh+acUyvik8i5A+tRzoOdZ/oW4IojSfTnYJVLcUJnSZ0CnWxrvwnuhKNS9qAJal7oW2An/diAsGsjOaxB8e+8qoIaCozgRyXj6LJ9FwZdSP1QuwfObWgZjjp+drqb2+Z9TZCx5nUXMOqcdDAc+AnV7CpBCvfJMI3JqsSikDYMBVqNgsVcKer1D4i0p14bQbLyTFmF+zqYaUj9fGCdioyeUDMbsqCrT73IUBoyL7YU2M6F+dq6Z9xUPFkOZPR9
 H0i8ZRCq
 PEFvPhNfbcr35M8TV/1dYCiWBTNHH+GSeuZF0ervy+dsk4z44tg4HTqFI9jiMpfPxJlHAJNNdu7JJpw1jYe36pD7tjQJAGnPnBXhF5JARcuWRSa6wQh3W+VsbNAJUmLRsPl19uKkIg9tb1M9b2XLEJOhojGPEyvQJ8IpmwatdU58rPsuY+qx7Bnyc405BpHOmRiD2jOvF2vwwTknYxEfrAVVpJYYDuUF2SfARNCEf6tuZdSUqZeV/UCodpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a regression test for the per-scan verbose dedup added in the
preceding commit. The test loads samples/kmemleak's helper module
(CONFIG_SAMPLE_KMEMLEAK=m) to generate orphan allocations, several of
which share an allocation backtrace, runs four kmemleak scans with
verbose printing enabled, then walks dmesg looking for two
"unreferenced object" reports within a single scan that share an
identical backtrace - which would mean dedup failed to collapse them.

The test is intentionally permissive on detection but strict on
regressions:

 - PASS when no duplicates are observed, regardless of whether the
   dedup summary line ("... and N more object(s) with the same
   backtrace") was actually emitted. Per-CPU chunk reuse, slab
   freelist pointers, kernel stack residue and CONFIG_DEBUG_KMEMLEAK_
   AUTO_SCAN can all keep most of the orphans "still referenced" or
   reported across many separate scans, so the dedup path may have
   nothing to fold within one scan. That is not a regression.

 - PASS reports whether dedup actually fired, so a passing run on a
   well-behaved environment is still informative.

 - FAIL when two same-backtrace reports land in a single scan (clear
   dedup regression).

 - FAIL when kmemleak's own per-scan tally counts leaks but the
   verbose path emits zero "unreferenced object" lines - that catches
   a regression in the verbose printer itself, which would otherwise
   pass the duplicate check trivially.

 - SKIP when kmemleak is absent, disabled at runtime, or the helper
   module is not built.

The dmesg parser anchors stack-frame matching to the indentation
kmemleak uses for them (4+ spaces under "kmemleak: ") so unrelated
kmemleak warnings landing between reports do not get lumped into the
backtrace key and mask a duplicate.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 tools/testing/selftests/mm/Makefile               |   1 +
 tools/testing/selftests/mm/ksft_kmemleak_dedup.sh | 222 ++++++++++++++++++++++
 2 files changed, 223 insertions(+)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 18779045b7f69..41053fdaad88d 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -151,6 +151,7 @@ TEST_PROGS += ksft_gup_test.sh
 TEST_PROGS += ksft_hmm.sh
 TEST_PROGS += ksft_hugetlb.sh
 TEST_PROGS += ksft_hugevm.sh
+TEST_PROGS += ksft_kmemleak_dedup.sh
 TEST_PROGS += ksft_ksm.sh
 TEST_PROGS += ksft_ksm_numa.sh
 TEST_PROGS += ksft_madv_guard.sh
diff --git a/tools/testing/selftests/mm/ksft_kmemleak_dedup.sh b/tools/testing/selftests/mm/ksft_kmemleak_dedup.sh
new file mode 100755
index 0000000000000..d019502444901
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_kmemleak_dedup.sh
@@ -0,0 +1,222 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Regression test for kmemleak's per-scan verbose dedup.
+#
+# Loads samples/kmemleak's helper module to generate orphan allocations
+# (some of which share an allocation backtrace), runs a few kmemleak
+# scans with verbose printing enabled, and verifies that no two
+# "unreferenced object" reports within a single scan share the same
+# backtrace - which would mean dedup failed to collapse them.
+#
+# This test is intentionally permissive: the kmemleak-test module's
+# leaks frequently get reported across many separate scans (per-CPU
+# chunk reuse, slab freelist pointers, kernel stack residue), so dedup
+# may never have anything to fold within one scan. That is not a
+# regression. The test only fails when it actually catches dedup not
+# happening on input that should have triggered it - i.e. two reports
+# with identical backtraces in the same scan.
+#
+# Author: Breno Leitao <leitao@debian.org>
+
+ksft_skip=4
+KMEMLEAK=/sys/kernel/debug/kmemleak
+VERBOSE_PARAM=/sys/module/kmemleak/parameters/verbose
+MODULE=kmemleak-test
+
+skip() {
+	echo "SKIP: $*"
+	exit $ksft_skip
+}
+
+fail() {
+	echo "FAIL: $*"
+	exit 1
+}
+
+pass() {
+	echo "PASS: $*"
+	exit 0
+}
+
+[ "$(id -u)" -eq 0 ] || skip "must run as root"
+[ -r "$KMEMLEAK" ] || skip "no kmemleak debugfs (CONFIG_DEBUG_KMEMLEAK)"
+[ -w "$VERBOSE_PARAM" ] || skip "kmemleak verbose param missing"
+modinfo "$MODULE" >/dev/null 2>&1 ||
+	skip "$MODULE not built (CONFIG_SAMPLE_KMEMLEAK)"
+
+# The verdict depends entirely on dmesg contents, so a silently-empty
+# dmesg (dmesg_restrict=1 with CAP_SYSLOG dropped, restricted container,
+# etc.) would let the script report PASS without parsing anything. Probe
+# both read and clear up front and skip cleanly if either is denied.
+dmesg >/dev/null 2>&1 ||
+	skip "cannot read dmesg (need CAP_SYSLOG or dmesg_restrict=0)"
+dmesg -C >/dev/null 2>&1 ||
+	skip "cannot clear dmesg (need CAP_SYSLOG or dmesg_restrict=0)"
+
+# kmemleak can be present but disabled at runtime (boot arg kmemleak=off,
+# or it self-disabled after an internal error). In that state writes other
+# than "clear" return EPERM, so probe once and skip if so.
+if ! echo scan > "$KMEMLEAK" 2>/dev/null; then
+	skip "kmemleak is disabled (check dmesg or kmemleak= boot arg)"
+fi
+
+prev_verbose=$(cat "$VERBOSE_PARAM")
+# shellcheck disable=SC2317  # invoked indirectly via trap
+cleanup() {
+	echo "$prev_verbose" > "$VERBOSE_PARAM" 2>/dev/null
+	rmmod "$MODULE" 2>/dev/null
+	# Drain the leak set we generated. Subsequent selftests (e.g.
+	# tools/testing/selftests/net/netfilter/nft_interface_stress.sh)
+	# fail on any non-empty kmemleak report, so leaving the helper
+	# module's intentional leaks behind would poison the rest of a
+	# kselftest run.
+	#
+	# Caveat: kmemleak_clear() only greys objects that have already
+	# been reported (OBJECT_REPORTED && unreferenced_object()). Helper
+	# allocations that stayed "still referenced" throughout the test
+	# (stale pointers in per-CPU chunks, slab freelists, kernel stacks)
+	# were never reported and are therefore not greyed by this clear -
+	# they remain tracked and a later scan can still surface them. Such
+	# leftovers are inherent to the kmemleak-test sample module and are
+	# not specific to this test; consumers that fail on any kmemleak
+	# output (rather than on the test-specific backtraces) need to be
+	# robust to that, or this test should be excluded from the run.
+	echo clear > "$KMEMLEAK" 2>/dev/null
+}
+trap cleanup EXIT
+
+echo 1 > "$VERBOSE_PARAM"
+
+# Drain the existing leak set so the next scan only reports our objects.
+echo clear > "$KMEMLEAK"
+
+# Re-clear dmesg now (the up-front probe also cleared it, but anything
+# logged between then and here - module unload chatter, the probe scan,
+# the verbose-param write - would otherwise pollute the parse window).
+dmesg -C >/dev/null
+
+# If the module was left loaded by a previous aborted run, modprobe would
+# be a no-op and the init function would not run, so no new leaks would be
+# generated. Force a clean state first.
+rmmod "$MODULE" 2>/dev/null
+modprobe "$MODULE" || skip "failed to load $MODULE"
+# Removing the module orphans the list elements without freeing them.
+rmmod "$MODULE"    || skip "failed to unload $MODULE"
+
+# Run a handful of scans so kmemleak has the chance to age and report
+# the orphans. We do not require any particular number to be reported:
+# the regression check below operates on whatever lands in dmesg.
+#
+# Note: with CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN=y the kernel's own scan
+# thread can report and mark these orphans (OBJECT_REPORTED) before our
+# manual scans run, after which our scans will see nothing. The
+# lower-bound check below catches the case where that happens and the
+# manual scans also produce nothing.
+SCAN_COUNT=4
+SCAN_SLEEP=6
+for _ in $(seq 1 "$SCAN_COUNT"); do
+	echo scan > "$KMEMLEAK"
+	sleep "$SCAN_SLEEP"
+done
+
+# Strip the leading "[   nnn.nnnnnn] " dmesg timestamp prefix. Without
+# this, two identical stack frames printed from two reports in the same
+# scan would produce different per-frame strings (different timestamps)
+# and the duplicate-backtrace check below would not match them, silently
+# passing a real dedup regression. Doing the strip here makes the rest
+# of the parser timestamp-agnostic regardless of what dmesg defaults to.
+log=$(dmesg | sed 's/^\[[^]]*\] //')
+
+# After running the workload (modprobe + scans), dmesg should contain at
+# least the helper module's pr_info lines and our manual-scan output. An
+# empty capture here means dmesg succeeded earlier but is now denying us
+# the buffer (race with dmesg_restrict toggling, etc.); refuse to give a
+# verdict on no evidence.
+[ -n "$log" ] || skip "dmesg returned empty after running workload"
+
+# Lower bound: if kmemleak's own per-scan tally counted leaks but the
+# verbose path emitted no "unreferenced object" line, the verbose printer
+# itself is regressed - fail rather than silently passing on no input.
+new_leaks=$(echo "$log" |
+	sed -n 's/.*kmemleak: \([0-9]\+\) new suspected.*/\1/p' |
+	awk '{s+=$1} END{print s+0}')
+printed=$(echo "$log" | grep -c 'kmemleak: unreferenced object')
+if [ "$new_leaks" -gt 0 ] && [ "$printed" -eq 0 ]; then
+	fail "verbose path broken: $new_leaks leaks counted, 0 printed in $SCAN_COUNT scans"
+fi
+
+# Walk the log: split into per-scan chunks at "N new suspected memory
+# leaks" boundaries; within each chunk, capture each "unreferenced
+# object" report's backtrace and check that no backtrace is reported
+# more than once. A duplicate within a single scan means dedup failed
+# to collapse two leaks that share an allocation site.
+violations=$(echo "$log" | awk '
+	function flush_block() {
+		if (in_block) {
+			# Skip empty backtraces: leaks with trace_handle == 0
+			# (early-boot allocations or stack_depot_save() failures
+			# under memory pressure) are intentionally not deduped,
+			# so multiple such reports in one scan are expected and
+			# must not be flagged as a regression.
+			if (bt != "")
+				seen[bt]++
+			in_block = 0
+			collecting = 0
+			bt = ""
+		}
+	}
+	function check_and_reset(   b) {
+		for (b in seen)
+			if (seen[b] > 1)
+				printf("backtrace seen %d times in one scan:\n%s\n",
+				       seen[b], b)
+		delete seen
+	}
+	# Scan boundary: the per-scan summary line.
+	/kmemleak: [0-9]+ new suspected memory leaks/ {
+		flush_block()
+		check_and_reset()
+		next
+	}
+	# Start of a new "unreferenced object" report.
+	/kmemleak: unreferenced object/ {
+		flush_block()
+		in_block = 1
+		next
+	}
+	# Inside a report, the "backtrace (crc ...):" line switches us to
+	# backtrace-collecting mode.
+	in_block && /kmemleak:[[:space:]]+backtrace \(crc/ {
+		collecting = 1
+		next
+	}
+	# Once collecting, capture only deeply-indented "kmemleak: " lines
+	# (stack frames have 4+ spaces of indentation under "kmemleak: ";
+	# headers and the "... and N more" tail line have less). This stops
+	# unrelated kmemleak warns landing between reports from being lumped
+	# into the backtrace key, which would mask a genuine duplicate.
+	in_block && collecting && /kmemleak:[[:space:]]{4,}/ {
+		bt = bt $0 "\n"
+		next
+	}
+	END {
+		flush_block()
+		check_and_reset()
+	}
+')
+
+if [ -n "$violations" ]; then
+	echo "$violations"
+	fail "kmemleak dedup regression: same backtrace reported more than once in a single scan"
+fi
+
+# Count the dedup summary lines so the report distinguishes "dedup
+# actually fired" from "no same-backtrace leaks turned up to dedup".
+dedup_lines=$(echo "$log" | grep -c 'more object(s) with the same backtrace')
+
+if [ "$dedup_lines" -gt 0 ]; then
+	pass "no dedup violations across $SCAN_COUNT scans; dedup fired ($dedup_lines summary line(s) observed)"
+else
+	pass "no dedup violations across $SCAN_COUNT scans; dedup had nothing to collapse"
+fi

-- 
2.52.0


