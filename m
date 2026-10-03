Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B19FCA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:22:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA4606B00AF; Fri,  2 Oct 2026 20:21:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D55BA6B00B0; Fri,  2 Oct 2026 20:21:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B596B6B00B1; Fri,  2 Oct 2026 20:21:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 884706B00AF
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:21:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1FA248085D
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:51 +0000 (UTC)
X-FDA: 85279412022.09.06CC4C4
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6B2EFC0002
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="f+Bzp/3v";
	spf=pass (imf10.hostedemail.com: domain of 3m0rAagoKCI41Bz6CyzB65y66y3w.u64305CF-442Dsu2.69y@flex--jthoughton.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3m0rAagoKCI41Bz6CyzB65y66y3w.u64305CF-442Dsu2.69y@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790986909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=el7RdsuPQmPVCa/coAHdRCW5aUIql/HQngm8YsWnGFg=;
	b=e25hOzfuuc53bElvRVdngUMNlo+unSFBXUQB1U90XFen8hzAylhfMP+vr+r/xen/OnuQy3
	ecdBTo2Mubpsf2et1hAHi63wgTTLBuwU622flGXjL01n+q7TcyVpSX52Od+c8jDzo86kEP
	TZFUmP8rmj8hZNSvLDTqDXXfko72kUA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="f+Bzp/3v";
	spf=pass (imf10.hostedemail.com: domain of 3m0rAagoKCI41Bz6CyzB65y66y3w.u64305CF-442Dsu2.69y@flex--jthoughton.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3m0rAagoKCI41Bz6CyzB65y66y3w.u64305CF-442Dsu2.69y@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790986909;
	b=cy5Dj7xJu6YvuRhOKKWP5hwtgfjtRDuTmzRV4nVR52F7PUN9Bby6a50RElCixemHeXlN01
	NrQysdq0Lfa0mrgeQJDvIv28SxbS8Aq8Zy9ppSsBfP/qgyPVfWPWTF6RVoIgHFIufVsrDo
	HwByuqXmrWxvXUq/vsJBQHC8fklS7hk=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2dfb24dfedfso10035ad.2
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 17:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790986908; x=1791591708; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=el7RdsuPQmPVCa/coAHdRCW5aUIql/HQngm8YsWnGFg=;
        b=f+Bzp/3vxvF5Dge0CNX5VTOE6QmCB/89EQF+wC6SMiU7j+UvYu8wO6sBa5LOcSjozs
         9J7CBz9kd6IFIJLZ+ePle1OkrTYUBLwv5DdQZkSom1PkZMmKeI4J+27zwNg0d49elr19
         /xe5bS9J3vnrL9Bvkt6F2LD5oqXXHpBK2RdzsB73mx37HTYJrTlo3v4xL+wQ/N5r9gk2
         +M6oObh9N/+dPZXK3Qhg8LZbm9zkBQuaaDLoJvNTD/EmkL0yeY0f8z9Rg4dTgioBexo4
         lryjAu4XeCGEJ/ue+3cEFZ+AWvXAg0fR7hAt0Amuu8u2ZEQMTujYRasr9a1NlSQ3A5uu
         g0qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986908; x=1791591708;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=el7RdsuPQmPVCa/coAHdRCW5aUIql/HQngm8YsWnGFg=;
        b=QKEWr7OHqrWggx7NIfchcM0wE1u75gmtLm+oftsubXbU86QELWSQ8DvmTy2U/poVmt
         sL9tfIPvuu93pjY/ByNZQWdp6vT8nUspnIXRHoEy4gJyjdOLUS0ldgeQVGPSnbZR3a7V
         HtK0I3z/s0cHU2uC+JS0UqZr0ejOKn+mQWFr39a5wAC3b73D6n2S88s1gfYWJDyATUSe
         MpQR05BjbiktOWKB5/013Q+3r7C3d0aAVH1xgFkRkOr48e04Cu1yE/TWNfdnajty7FJS
         dAqVmGI2f7hxVErL2iEhyigcJmDcB5m1dRzxt2VjOAzLqCs/Sdkxsi860K567eDG1des
         unMg==
X-Forwarded-Encrypted: i=1; AKwUvByymSN4iPGEKTU/mntI1llhb+rrSvErPdAOLpVydQF7JtuK7ski2EAPmJk/3HxiEvLNUIGCt+Gelg==@kvack.org
X-Gm-Message-State: AFq9FYKnfloJS5zWEw3PNP43xP0K0Qnfh2wJrzhwZbSmJsa5Lw8S+vsv
	od1lTwLX+6rts4J8vrdU1wZvDx83pykh/VFgawQAr+Nurdx9SALQeURbwt605xyx2q7QTuu/OGc
	8dqZZXLjggtIljDe5xygwdg==
X-Received: from plhb14.prod.google.com ([2002:a17:903:228e:b0:2dd:bff7:1e38])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:191:b0:2dd:c053:d741 with SMTP id d9443c01a7336-2e49b684cffmr41681905ad.40.1790986907988;
 Fri, 02 Oct 2026 17:21:47 -0700 (PDT)
Date: Sat,  3 Oct 2026 00:21:18 +0000
In-Reply-To: <20261003002123.505555-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20261003002123.505555-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003002123.505555-16-jthoughton@google.com>
Subject: [PATCH v2 15/20] selftests/mm: Add HugeTLB vmemmap optimization
 stress test
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 46teewcbtmcoy5he5c3mu44sqw7fstgb
X-Rspamd-Queue-Id: 6B2EFC0002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790986909-634252
X-HE-Meta: U2FsdGVkX1/exBRHoGyQivj/t4bGm161kWNYJ3m+S7/wR+ET+ZqSuYG2fCO7XPfivR+lhbTjMTPyriWjbfxZWyf4kkbfZ4kiv3sHi7/YyM1T25QYd2cpae2/hlpsoysdZv1WJZjEEoqsK4fLvIFQzYbWZs+BjUJ44QmirhZRc9/OWW77nW+SNHGg2OCZFQNiCsprFLGiGZBpnlcUtCo3yoVrPn4FgVeNwYq2qB4AoeCmgRiu/2BIXaRfrtuE0qX2rTWuv48YdkDzwlgOLIr85uAQsl15lPdaET9oIl14GGH8/ZHT74KPI/eM4/omzF2+sfhzeN1HbGLmAfQi1esDGqIn1egkVA5edb09Hn0jNYhTKX1l5ZYVKt/MuY9H8zu5hZATzFeFbPjhEUJzJ/pAVggXsX27CaccI9mIgJlZVZi9OFkJYQUV1x88xa+iUA0S2K3ePU44GrBn+XBYVqHFc7J5YWybSNPRbdvR8CFqeB3v1SJCnAY7Kurduhm+nOZvd4kTQqAdgDZ1aj95r6Bl1A4NMwrj4LF2rc5YkXsnIGdtbQxXw/+QYxRNXORF3OjqBH+CboYBCqeBZ2LlBVs4EeeZ8g1tA5RmbJfPlu5vAlQyuQe7wSYiAza7NiAIVBj3c5nHyqcqWGujonPbZZt8llPw/MF8/V34C/0RCQrLgXsjrIdRtMJXy5+JRqLzEkuE7idUgDX5k5/NZCsnIybFao89e/VX2+U/ws/bl426T70oLmlCcjXYHO6xUztsjUIUhqoLW9+kUD0j2EXwpyZhgBfjQXUEB56lNtyWKxyyNTri2AxMy81KUFa6dCB6qaOyExiiKPQ9wnUD3rCkfgjELHeOrFpEa/ZtXlVNwKAcBUZVqGLQSxbQypbaHeNLeMMwJdXXAhzJmq5Mr7ldTDJo88MQv6B8zVQZM4bG9Jsh4ieGstonf55gFHhCbcCOS5MPbu/kb9Vo2szkNCrzp83
 Lo6H5bPp
 r8YdkaF1phhoarq7v5GVXV5jYYC80yXWTYX/leGZKhQ3y1YNPpm2YIFPDcTl0fWqCcdREQ5LVNHfoTp3P1HaGhpA5b1v17DpqrdtYV1ek7o6jjYAkJie1eaSNtYuxSNKjP2GFTANhzv5mTnZdJ+glwI6/JhYzj4iatpFGf5aqg6+tZRZmR4LeVG0yxKspsBY7Yvd6foL6T4ENbUODILDZxuz7VBphzNz9GYa/EMzsWWDKiSwIbI8BJX5VAN/4VbDfsUu4EL1cfE57gupOzhGMIlrEcRMJDw0ShtGjzCgyihT/qUdjP69C/6gzV3To/106ZCx+G4EmvoaUBVaxOYw2rcOJgNN4IuR2hsw045GsGG9l2BWHTZECwCJt2iUHpUrB42Xo9a/hA731YplK8E76CTbk9e2P157hFEK+YOQZNewaLDghyTX812QjzPgV4jjPEI8Khao8qmsLUqga8yjcwtankhnEIJLabT6f7TKeSiRncSVuqrT5XETId5BbUnk5Wdo13N4C0ynaz11xLBrrAAYDgnozA48/KgnhVf+IfCVpsXQCYAiu5RqBJK3iDbffbohKavzGD999iQyMxTwQq6hMkBfmo3keP0d8cnDO6PvKCHE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a script that stresses HugeTLB vmemmap optimization (HVO), in
particular on architectures that update the vmemmap in place while it
may be concurrently accessed:

  - Check that optimizing N folios frees exactly N * (vmemmap pages per
    folio - 1) vmemmap pages (per nr_memmap_pages and
    nr_memmap_boot_pages), and that restoring them gives them back.
  - Repeatedly optimize and restore folios by resizing the hugepage pool,
    while concurrently reading struct pages through /proc/kpageflags and
    /proc/kpagecount, compacting memory, and optionally reading
    page_owner and offlining/onlining memory blocks.
  - Do the same with fail_hugetlb_vmemmap_pte fault injection enabled,
    if available, to exercise the rollback and partially-optimized folio
    paths.

After each phase, the pool must shrink back to its original size and the
memmap accounting must return to its baseline. Finally, the kernel log
must not contain warnings or oopses.

Assisted-by: LLM
Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/mm/Makefile           |   2 +
 .../selftests/mm/hugetlb_vmemmap_stress.sh    | 347 ++++++++++++++++++
 .../selftests/mm/ksft_hugetlb_vmemmap.sh      |   4 +
 tools/testing/selftests/mm/run_vmtests.sh     |   4 +
 4 files changed, 357 insertions(+)
 create mode 100755 tools/testing/selftests/mm/hugetlb_vmemmap_stress.sh
 create mode 100755 tools/testing/selftests/mm/ksft_hugetlb_vmemmap.sh

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index beacc0f87304..51d8fba80c03 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -149,6 +149,7 @@ TEST_PROGS += ksft_cow.sh
 TEST_PROGS += ksft_gup_test.sh
 TEST_PROGS += ksft_hmm.sh
 TEST_PROGS += ksft_hugetlb.sh
+TEST_PROGS += ksft_hugetlb_vmemmap.sh
 TEST_PROGS += ksft_hugevm.sh
 TEST_PROGS += ksft_kmemleak_confirm.sh
 TEST_PROGS += ksft_kmemleak_dedup.sh
@@ -180,6 +181,7 @@ TEST_FILES += test_hmm.sh
 TEST_FILES += va_high_addr_switch.sh
 TEST_FILES += charge_reserved_hugetlb.sh
 TEST_FILES += hugetlb_reparenting_test.sh
+TEST_FILES += hugetlb_vmemmap_stress.sh
 TEST_FILES += test_page_frag.sh
 TEST_FILES += run_vmtests.sh
 
diff --git a/tools/testing/selftests/mm/hugetlb_vmemmap_stress.sh b/tools/testing/selftests/mm/hugetlb_vmemmap_stress.sh
new file mode 100755
index 000000000000..94357a4a45c2
--- /dev/null
+++ b/tools/testing/selftests/mm/hugetlb_vmemmap_stress.sh
@@ -0,0 +1,347 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Stress test for HugeTLB vmemmap optimization (HVO).
+#
+# Phases:
+#   1. accounting: allocate N hugepages, check that nr_memmap_pages +
+#      nr_memmap_boot_pages drops by exactly N * (vmemmap pages per folio - 1),
+#      then free them and check it returns to the baseline.
+#   2. stress: churn the pool (optimize/restore) while concurrently reading
+#      struct pages (/proc/kpageflags, /proc/kpagecount), compacting memory,
+#      and optionally reading page_owner and offlining/onlining memory.
+#   3. pte-inject: like 2, with fail_hugetlb_vmemmap_pte enabled; this hits
+#      both the optimize rollback and the restore (partial HVO) paths.
+#
+# After each phase the pool is drained back to its original size, memmap
+# accounting must be back at the phase's baseline, and the kernel log must
+# not contain warnings/oopses.
+#
+# The fault-injection phases require CONFIG_FAIL_HUGETLB_VMEMMAP and
+# CONFIG_FAULT_INJECTION_DEBUG_FS, and are skipped otherwise.
+
+set -u
+
+KSFT_PASS=0
+KSFT_FAIL=1
+KSFT_SKIP=4
+
+size_kb=
+nr=16
+duration=60
+prob=20
+readers=4
+struct_page_size=64
+do_page_owner=0
+do_hotplug=0
+
+usage() {
+	cat <<EOF
+Usage: $0 [options]
+  -s KB     hugepage size in kB (default: default hugepage size)
+  -n N      number of hugepages to churn (default: $nr)
+  -t SEC    duration of each stress phase (default: $duration)
+  -p PCT    fault-injection probability in percent (default: $prob)
+  -j N      number of struct page reader processes (default: $readers)
+  -S BYTES  sizeof(struct page) (default: $struct_page_size)
+  -o        also read /sys/kernel/debug/page_owner during stress
+  -m        also offline/online memory blocks during stress (dissolves
+            free hugepages, exercising the restore path)
+
+For exact accounting checks, run on a hugepage size whose pool is
+initially empty (e.g. no boot-time reservations of that size).
+EOF
+	exit $KSFT_SKIP
+}
+
+while getopts "s:n:t:p:j:S:omh" opt; do
+	case $opt in
+	s) size_kb=$OPTARG ;;
+	n) nr=$OPTARG ;;
+	t) duration=$OPTARG ;;
+	p) prob=$OPTARG ;;
+	j) readers=$OPTARG ;;
+	S) struct_page_size=$OPTARG ;;
+	o) do_page_owner=1 ;;
+	m) do_hotplug=1 ;;
+	*) usage ;;
+	esac
+done
+
+log() { echo "# $*"; }
+skip() { echo "SKIP: $*"; exit $KSFT_SKIP; }
+
+failures=0
+fail() { echo "FAIL: $*"; failures=$((failures + 1)); }
+pass() { echo "PASS: $*"; }
+
+[ "$(id -u)" -eq 0 ] || skip "must be run as root"
+
+[ -r /proc/sys/vm/hugetlb_optimize_vmemmap ] ||
+	skip "HVO not supported (no vm.hugetlb_optimize_vmemmap)"
+[ "$(cat /proc/sys/vm/hugetlb_optimize_vmemmap)" = 1 ] ||
+	skip "HVO disabled (vm.hugetlb_optimize_vmemmap=0)"
+grep -q '^nr_memmap_pages ' /proc/vmstat ||
+	skip "no nr_memmap_pages in /proc/vmstat"
+
+[ -n "$size_kb" ] || size_kb=$(awk '/^Hugepagesize:/ {print $2}' /proc/meminfo)
+hp_dir=/sys/kernel/mm/hugepages/hugepages-${size_kb}kB
+[ -d "$hp_dir" ] || skip "no ${size_kb}kB hugepages"
+
+page_size=$(getconf PAGESIZE)
+vmemmap_pages=$(( size_kb * 1024 / page_size * struct_page_size / page_size ))
+freed_per_folio=$(( vmemmap_pages - 1 ))
+[ "$freed_per_folio" -gt 0 ] ||
+	skip "${size_kb}kB hugepages are not HVO-optimizable"
+
+dbgfs=/sys/kernel/debug
+mountpoint -q $dbgfs || mount -t debugfs none $dbgfs 2>/dev/null
+
+orig_nr=$(cat "$hp_dir/nr_hugepages")
+target_nr=$(( orig_nr + nr ))
+marker="hvo-stress-$$-$(date +%s)"
+tmpdir=$(mktemp -d)
+pids=()
+
+log "hugepage size ${size_kb}kB, page size $page_size"
+log "struct page size $struct_page_size"
+log "vmemmap pages/folio: $vmemmap_pages ($freed_per_folio freed by HVO)"
+log "pool: $orig_nr initially, churning between $orig_nr and $target_nr"
+[ "$orig_nr" -eq 0 ] ||
+	log "WARNING: pool not initially empty, accounting may be inexact"
+
+memmap_total() {
+	awk '/^nr_memmap_(boot_)?pages / {s += $2} END {print s + 0}' \
+		/proc/vmstat
+}
+
+set_nr() {
+	echo "$1" > "$hp_dir/nr_hugepages" 2>/dev/null
+	cat "$hp_dir/nr_hugepages"
+}
+
+# Shrink the pool back to orig_nr. Restore may transiently fail (e.g. with
+# fault injection active), so retry for a while.
+drain() {
+	local i cur surplus
+
+	for i in $(seq 20); do
+		# Pages whose vmemmap could not be restored are kept as free
+		# surplus pages, which shrinking nr_hugepages does not free.
+		# Writing the current size converts them back to persistent
+		# pages first.
+		set_nr "$(cat "$hp_dir/nr_hugepages")" > /dev/null
+		cur=$(set_nr "$orig_nr")
+		[ "$cur" -eq "$orig_nr" ] && return 0
+		sleep 1
+	done
+	surplus=$(cat "$hp_dir/surplus_hugepages")
+	fail "pool stuck at $cur hugepages ($surplus surplus)," \
+		"expected $orig_nr"
+	return 1
+}
+
+fa_dir() { echo "$dbgfs/$1"; }
+
+fa_enable() {
+	local d
+	d=$(fa_dir "$1")
+	echo 0 > "$d/verbose"
+	echo N > "$d/task-filter"
+	echo 1 > "$d/interval"
+	echo 1000000 > "$d/times"
+	echo "$prob" > "$d/probability"
+}
+
+# Disable and print the number of injected failures.
+fa_disable() {
+	local d left
+	d=$(fa_dir "$1")
+	echo 0 > "$d/probability"
+	left=$(cat "$d/times")
+	echo 0 > "$d/times"
+	echo $(( 1000000 - left ))
+}
+
+check_dmesg() {
+	local bad pat
+
+	pat='WARNING:|BUG[: ]|Oops|Unable to handle kernel'
+	pat+='|Internal error|KASAN:|UBSAN:'
+	pat+='|list_(add|del) corruption|page dumped because'
+	bad=$(dmesg | sed -n "/$marker/,\$p" | grep -E "$pat")
+	if [ -n "$bad" ]; then
+		fail "kernel log reports problems:"
+		echo "$bad" | head -20 | sed 's/^/#   /'
+	fi
+}
+
+## Workers
+
+churn() {
+	while :; do
+		set_nr "$target_nr" > /dev/null
+		set_nr "$orig_nr" > /dev/null
+	done
+}
+
+kpage_reader() {
+	while :; do
+		dd if=/proc/kpageflags of=/dev/null bs=4M status=none
+		dd if=/proc/kpagecount of=/dev/null bs=4M status=none
+	done
+}
+
+compactor() {
+	while :; do
+		echo 1 > /proc/sys/vm/compact_memory
+		sleep 1
+	done
+}
+
+page_owner_reader() {
+	while :; do
+		cat $dbgfs/page_owner > /dev/null
+	done
+}
+
+hotplugger() {
+	local blk state removable
+
+	while :; do
+		for blk in /sys/devices/system/memory/memory*; do
+			state=$(cat "$blk/state" 2>/dev/null)
+			removable=$(cat "$blk/removable" 2>/dev/null || echo 1)
+			[ "$state" = online ] || continue
+			[ "$removable" = 1 ] || continue
+			echo "$blk" >> "$tmpdir/hotplug"
+			# A signal aborts a pending offline_pages().
+			timeout 10 sh -c "echo offline > $blk/state" 2>/dev/null
+			echo online > "$blk/state" 2>/dev/null
+			sleep 1
+		done
+	done
+}
+
+start_workers() {
+	local i
+
+	churn & pids+=($!)
+	for i in $(seq "$readers"); do
+		kpage_reader & pids+=($!)
+	done
+	compactor & pids+=($!)
+	if [ "$do_page_owner" -eq 1 ]; then
+		if [ -r $dbgfs/page_owner ]; then
+			page_owner_reader & pids+=($!)
+		else
+			log "page_owner not available, not reading it"
+		fi
+	fi
+	[ "$do_hotplug" -eq 1 ] && { hotplugger & pids+=($!); }
+}
+
+stop_workers() {
+	[ "${#pids[@]}" -gt 0 ] || return 0
+	kill "${pids[@]}" 2>/dev/null
+	wait "${pids[@]}" 2>/dev/null
+	pids=()
+}
+
+cleanup() {
+	local blk t
+
+	stop_workers
+	for t in fail_hugetlb_vmemmap_pte; do
+		[ -d "$(fa_dir $t)" ] && fa_disable $t > /dev/null
+	done
+	if [ -f "$tmpdir/hotplug" ]; then
+		sort -u "$tmpdir/hotplug" | while read -r blk; do
+			[ "$(cat "$blk/state")" = online ] ||
+				echo online > "$blk/state" 2>/dev/null
+		done
+	fi
+	set_nr "$orig_nr" > /dev/null
+	rm -rf "$tmpdir"
+}
+trap cleanup EXIT
+trap 'exit $KSFT_FAIL' INT TERM
+
+# Run a stress phase. $1: name, $2: fault attr to enable ("" for none).
+stress_phase() {
+	local name=$1 fa=$2 base after injected
+
+	if [ -n "$fa" ] && [ ! -d "$(fa_dir "$fa")" ]; then
+		echo "SKIP: $name (no $(fa_dir "$fa"))"
+		return
+	fi
+
+	log "phase $name: ${duration}s"
+	base=$(memmap_total)
+	[ -n "$fa" ] && fa_enable "$fa"
+	start_workers
+	sleep "$duration"
+	stop_workers
+	if [ -n "$fa" ]; then
+		injected=$(fa_disable "$fa")
+		log "$name: injected $injected failures"
+		[ "$injected" -gt 0 ] ||
+			log "WARNING: $name: no failures injected"
+	fi
+
+	drain || return
+	after=$(memmap_total)
+	if [ "$after" -ne "$base" ]; then
+		fail "$name: memmap pages $after after drain, expected $base"
+	else
+		pass "$name"
+	fi
+}
+
+accounting_phase() {
+	local base got added after expect
+
+	log "phase accounting"
+	base=$(memmap_total)
+	got=$(set_nr "$target_nr")
+	added=$(( got - orig_nr ))
+	if [ "$added" -le 0 ]; then
+		fail "accounting: could not allocate any ${size_kb}kB hugepages"
+		return
+	fi
+	[ "$added" -eq "$nr" ] || log "accounting: only allocated $added of $nr"
+
+	after=$(memmap_total)
+	expect=$(( base - added * freed_per_folio ))
+	if [ "$after" -ne "$expect" ]; then
+		fail "accounting: memmap pages $after after optimizing" \
+			"$added folios, expected $expect (baseline $base)"
+	else
+		pass "accounting: optimize freed $(( base - after ))" \
+			"vmemmap pages"
+	fi
+
+	drain || return
+	after=$(memmap_total)
+	if [ "$after" -ne "$base" ]; then
+		fail "accounting: memmap pages $after after restore," \
+			"expected $base"
+	else
+		pass "accounting: restore"
+	fi
+}
+
+echo "$marker" > /dev/kmsg
+
+accounting_phase
+stress_phase stress ""
+stress_phase pte-inject fail_hugetlb_vmemmap_pte
+
+check_dmesg
+
+if [ "$failures" -ne 0 ]; then
+	echo "FAILED: $failures check(s)"
+	exit $KSFT_FAIL
+fi
+echo "OK"
+exit $KSFT_PASS
diff --git a/tools/testing/selftests/mm/ksft_hugetlb_vmemmap.sh b/tools/testing/selftests/mm/ksft_hugetlb_vmemmap.sh
new file mode 100755
index 000000000000..905b75b2cfb4
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_hugetlb_vmemmap.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t hugetlb_vmemmap
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index a1b45a3dedae..8dcdee7be501 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -77,6 +77,8 @@ separated by spaces:
 	test transparent huge pages
 - hugetlb
 	test hugetlbfs huge pages
+- hugetlb_vmemmap
+	test the hugetlb vmemmap optimization
 - migration
 	invoke move_pages(2) to exercise the migration entry code
 	paths in the kernel
@@ -312,6 +314,8 @@ echo "$enable_soft_offline" > /proc/sys/vm/enable_soft_offline
 CATEGORY="hugetlb" run_test ./hugetlb-read-hwpoison
 fi
 
+CATEGORY="hugetlb_vmemmap" run_test ./hugetlb_vmemmap_stress.sh
+
 if [ $VADDR64 -ne 0 ]; then
 	# va high address boundary switch test
 	CATEGORY="hugevm" run_test bash ./va_high_addr_switch.sh
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


