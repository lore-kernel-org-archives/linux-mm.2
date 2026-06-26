Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9693AC43327
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 15:34:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD7566B00DA; Fri, 26 Jun 2026 11:34:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4E286B00DC; Fri, 26 Jun 2026 11:34:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC73A6B00DD; Fri, 26 Jun 2026 11:34:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D08B6B00DA
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:34:17 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C9AB58E17A
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:34:16 +0000 (UTC)
X-FDA: 84922460112.28.83EDFEA
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf06.hostedemail.com (Postfix) with ESMTP id E3EEC180002
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:34:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=rYA+eULg;
	spf=pass (imf06.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782488055;
	b=W84mDR08tS9FCoW3MbxrSHF+JhNADXq1Uu0sccAfdvJOZJK/U9MMIhtD2dzu9rg/EQPlE0
	JEco3rFRBNdJYW5Z5xLAtgYEmmBkNVnsTe1IuagIkliAf2hdjx/BjiBsKJYP/O3DzMU+ds
	IooxAMik2Jkj5K2O0tYmWUbK6ve7HgE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782488055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9AjDzRCh4/mXl8o45A7Z6nWHf+5IUCFbmpedUIoL4Bk=;
	b=DYzGl1CXVgm/BRWhlK5eyo+F3RlbjKEYNi5cS/l25IyNZmk53eYSghTY5715u2XI2LVzCA
	DkqCGyQ8sD/FsX0GXDDntL/sQ85vlAlX2gK6PLHShkHDgB31ZFcOp0w3MnenBDMgx4qURF
	0Wc9cqFFw3+TiRkhR/JWf/5ox3PXX0Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=rYA+eULg;
	spf=pass (imf06.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=9AjDzRCh4/mXl8o45A7Z6nWHf+5IUCFbmpedUIoL4Bk=; b=rYA+eULg7NxAyWHoa8XMxUyNeh
	JhW5EB4xeGog/tt4Bw5MXkrs/m4WJosyxC8nOrxI2tWvhh9HrVCJ82dwaee5864mnZBPO7BcxU8zB
	Cv9z9HIEsmCxjJS/TCFWNpDSxJ0D/kyJWpHovuwCnaW1DnbuY+/Je9MWA3F5JPhPBgNyZksCkq1iR
	gguzGe/wVxSzglzeyp0ROfqfcnOzHfEa/f1r8KyM192JkWseNrInMzyJeBo37DTwYCpG6o3hg4/KV
	d7GyXPMzMGSd6XWUahpB8jOdI7qbzJsTtct3Kq17tplkpl8BzpvPkisfSNiZ5tBF91COTIXYuCUjq
	ExXKmgRw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wd8ZA-0044F4-2a;
	Fri, 26 Jun 2026 15:34:05 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 26 Jun 2026 08:33:20 -0700
Subject: [PATCH v10 6/6] selftests/mm: add hwpoison-panic destructive test
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260626-ecc_panic-v10-6-6dacb8ad024d@debian.org>
References: <20260626-ecc_panic-v10-0-6dacb8ad024d@debian.org>
In-Reply-To: <20260626-ecc_panic-v10-0-6dacb8ad024d@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, lance.yang@linux.dev, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, linux-trace-kernel@vger.kernel.org, 
 kernel-team@meta.com
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=13312; i=leitao@debian.org;
 h=from:subject:message-id; bh=ZsWCPb06ETk+H+SBSJ7KF4w8jwz3rpL52F//301DWbo=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqPpvF6gFxxuCMs+B1+Kx6jC8kx8NSryaGY/Ld5
 0W8EZX0DWqJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaj6bxQAKCRA1o5Of/Hh3
 bXWLD/9Il3EphF2AdgJnTAOVUhNF616IGLqxTVnqa63j0Dr2XORloZGq7moVq8LzAAuHLlMfW1a
 bYOzphWYmv6aehAbeRisAF54OMLLn6YpOrDeMYLcY8setISmjVRU1CqIDJCK5Q9kB5SKqAxkLfo
 o94GWxUaN3o/opuOLYWJ+MyV7wIASlIG+93F4+zMN40QO7sfd299E1eJS4m4qKiZXdzr//NiCoD
 pkbLPB3PbY+kovpPJTNJIW13J0RzYJRotHBhz176hQ7pDhdiQ1F9jhFkbcf8doZ/PWWJxtve5Vp
 r/E3yEYbj9i/NligoHruPq2REMycy16enAUzybnRwhzclPJkfQP6Ll6PyfQiMrbQaNOeNABZEUL
 ASHGRaQFMwRB+X5vY4wgMhvXtZcqZGTPg0nP3PWpalr2k/qO644kmi2RLe7zYdPeUMEjucrKDp1
 5Es3Wk1KYmHzxsovnNkDo4hdBp2Zbr9BVC7HJrdPbUjmhyuaJ/FFCjMAIK7/Hm00AvRvIvKBaT4
 Rkk6SOizESoS86NgHQ+Vswg7zwBK2OV+HHAy3zndf0/SvBAF4XEyWWFyLfY3FgRHFc12nidtSIf
 8I9PNLxOm1+i8pOhR4CbrxYDBq/IxwCWuAgL9sNPvldqOnD5BYPv/HAWByo9wyKuSJWk7s8BNS5
 BIZn5Bx6vJG10qQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E3EEC180002
X-Rspam-User: 
X-Stat-Signature: 8b6kzzcjdaq9ugin6to6m3o7fwx5nshd
X-HE-Tag: 1782488054-727821
X-HE-Meta: U2FsdGVkX19DTCvaZyuiSe7hOIQ2BjpY5jZYAVZtZIv1HkqQuGHEgD0HfluRsi4Ndtq9NDg7NKl6R0dRjxskNMGT0/CnHHqWzI4VMYOICnk/11fcgVjyZDbncmxtyx4ngmuKN7ZIPhZnJDLUrNzQiCq9k36MH57xZAWivP0RBqYHeIjyOb0GTQ/5wYUJWg4HBI5vtw4TmsvnCWjesvQhW2jES2/alIcLi2s96KlmxRO38jiabf0O3hig6WDArGAWQ81A3Qm8sECToGw7n1FkKuUC4VMBVj8Z6EkINcFBbr3XA/mQoWmXQQecVpsrJV2F0u4erQx6/UwdaxzZvqhk/7hPO1Dj4neGMocRKJTVlSi40waqL/JHbF8M7YX/r+dMXHX0uIpQDTul8bsd4t7Ynd/RsqnmPBrB8TcMUCbTvEmA06EMfjXwOsCIRWNlyo0jvjrhx+TLoSVuR69uQwMpCsIzee+v1spwyjfBilo23CIvz/ScP+v0+QcBUMfuUMGckpprlWahi/xv0xyTwU8VVUOZBKolrpoKc11Ie/6b7xldOqQleIlpSRPhE+bf48Z0O1usH2Z66Hf158I79nib0NR6zPPKMx3KFLBjDnTq7M6d+xsWVEyi05+raKKYXR4UfFY1aqYeD+Z6VVsPx3GLyhYHMu+DtkPicQWzGOA14HkYhcLJnUiV4mHl+S+jPohxhQyb0DIbwZQ+ohwEhr6zFqp7kL/GrbeFSqXdU8uJDSMOga+hZyGWT0TTS1vPhJNiJSyQwNR5rxSp5jtz1EEQPqgLNHVvLR7T+h93p7yc8in1g6Su6dM3G4Cb109inekIsErqmgwXLW+KXNI3iPUZggzi4e9uKoupqthv/Em1PXSzTt1EtvTWXdEe4tljwQG75aoPADrSoz/GXUKEHxdzqo5VqIeEIuGsapHdHIzVC1okp2XR2dQdMJZF8rz58g7xEch5Uyr1gJLLUixl4iy
 dhF6Q5xh
 sjbmSymXa44cFv1fEmta3OzWMfzs4/MOyWFm15FCNhEpPmmUHQmqavR4+pSLiR0MYgiqtLJ271NSpDuS3x3HsK/Wy4yrT+Wbb5/FQeKlqWZdBqMH/fc1MtbOzSsp1JDdo1nSWLB8FOi9Ef1uFmN9v4CaCuny9mhKkR7Mv7RkiZG6nX69R6tEgOKtCQMS/mtc5rA7wjfvijJpRAzAQM0jqf25gbzsl5TYC4RFHxcXZx4H7RCVd+ZKropNhwqGzRxj1yxPqI3srextCt+8M7hr7Ags62lyL96dIREgVo/XDZOV/+0wnhMrPzo8GH2mBlLHTALaevHNXdvFaCYCzKkU/GKwLXeCKyAMqv0srJi1B2UPfI5A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a destructive selftest that verifies
vm.panic_on_unrecoverable_memory_failure actually panics when a
hwpoison error hits a kernel-owned page.

Three "kinds" of kernel-owned page can be targeted, selectable via
the script's first positional argument (default: rodata):

  rodata  - a PG_reserved page in the kernel rodata range, sourced
            from the "Kernel rodata" sub-resource of "System RAM" in
            /proc/iomem.  That entry is reported on every major
            architecture and guarantees the chosen PFN is backed by
            struct page (an online System RAM range, not a firmware
            hole), is PG_reserved, and is read-only -- so even if
            the panic fails to fire for some reason, the resulting
            PG_hwpoison marker on rodata does not corrupt writable
            kernel state.

  slab    - a slab page found by walking /proc/kpageflags for the
            first PFN with KPF_SLAB set (and KPF_HWPOISON / KPF_NOPAGE
            / KPF_COMPOUND_TAIL clear).  Exercises the get_any_page()
            path on a non PG_reserved kernel-owned page and so
            catches regressions where get_any_page() collapses
            kernel-owned pages into a transient -EIO instead of
            -ENOTRECOVERABLE.

  pgtable - same as slab, but the PFN is selected via KPF_PGTABLE.

PageLargeKmalloc, the fourth page type matched by
is_kernel_owned_page(), is intentionally not covered: it is a
PAGE_TYPE_OPS flag with no /proc/kpageflags bit, so selecting such
a PFN from userspace is not feasible.  The slab and pgtable
variants already exercise the same get_any_page() positive-check
branch.

The script enables the sysctl and writes the selected physical
address to /sys/devices/system/memory/hard_offline_page.  A
successful run crashes the kernel with

  Memory failure: <pfn>: unrecoverable page

A return from the inject means no panic fired.  Before reporting, the
script restores the sysctl and best-effort unpoisons the target PFN
through the hwpoison debugfs interface (hard_offline_page() injects
with MF_SW_SIMULATED, so the page stays unpoisonable), then re-reads
/proc/kpageflags: a PFN that is still the kernel-owned type it selected
is a genuine failure, while one that raced to a different type before
the inject is skipped as inconclusive.  Test outcome is therefore
observed externally (serial console, kdump) rather than from the
script's own exit code.

The script is intentionally NOT wired into run_vmtests.sh: every
successful run panics the kernel, which is incompatible with the
sequential "run each category in the same VM" model that
run_vmtests.sh assumes.  It is also not registered as a TEST_PROGS /
ksft_* wrapper so a default kselftest run does not opt itself into
a panic.  The script is meant to be executed manually inside a
disposable VM (e.g. virtme-ng), one variant per VM boot, and
requires RUN_DESTRUCTIVE=1 in the environment as a safety net.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 tools/testing/selftests/mm/Makefile          |   4 +
 tools/testing/selftests/mm/hwpoison-panic.sh | 249 +++++++++++++++++++++++++++
 2 files changed, 253 insertions(+)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index e6df968f0971c..ed321ae709dac 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -174,6 +174,10 @@ TEST_PROGS += ksft_userfaultfd.sh
 TEST_PROGS += ksft_vma_merge.sh
 TEST_PROGS += ksft_vmalloc.sh
 
+# Destructive: every successful run panics the kernel.  Installed and
+# kept executable, but not run from a default kselftest invocation.
+TEST_PROGS_EXTENDED += hwpoison-panic.sh
+
 TEST_FILES := test_vmalloc.sh
 TEST_FILES += test_hmm.sh
 TEST_FILES += va_high_addr_switch.sh
diff --git a/tools/testing/selftests/mm/hwpoison-panic.sh b/tools/testing/selftests/mm/hwpoison-panic.sh
new file mode 100755
index 0000000000000..aafc06e895d01
--- /dev/null
+++ b/tools/testing/selftests/mm/hwpoison-panic.sh
@@ -0,0 +1,249 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Verify vm.panic_on_unrecoverable_memory_failure by injecting a hwpoison
+# error on a kernel-owned page and confirming the kernel panics.
+#
+# Three "kinds" of kernel-owned page can be targeted, selectable via the
+# first positional argument (default: rodata):
+#
+#   rodata  - a PG_reserved page in the kernel rodata range
+#             (sourced from /proc/iomem "Kernel rodata").  Exercises
+#             memory_failure() -> get_any_page() on a PageReserved page.
+#
+#   slab    - a slab page found via /proc/kpageflags (KPF_SLAB).
+#             Exercises memory_failure() -> get_any_page() on a non
+#             PG_reserved kernel-owned page.  This path is what catches
+#             regressions where get_any_page() collapses kernel-owned
+#             pages into a transient -EIO instead of -ENOTRECOVERABLE.
+#
+#   pgtable - a page-table page found via /proc/kpageflags (KPF_PGTABLE).
+#             Same path as slab, different page type.
+#
+# This test is DESTRUCTIVE: a successful run crashes the kernel.  It is
+# meant to be executed inside a disposable VM (e.g. virtme-ng) with a
+# serial console captured by the harness.  It is skipped unless the
+# caller opts in via RUN_DESTRUCTIVE=1.
+#
+# Test passes externally: the kernel must panic with
+#   "Memory failure: <pfn>: unrecoverable page"
+# A return from the inject means no panic fired: that is a failure,
+# unless the target PFN raced to a different page type before injection,
+# in which case the run is inconclusive and is skipped.
+#
+# Author: Breno Leitao <leitao@debian.org>
+
+set -u
+
+ksft_skip=4
+sysctl_path=/proc/sys/vm/panic_on_unrecoverable_memory_failure
+inject_path=/sys/devices/system/memory/hard_offline_page
+kpageflags_path=/proc/kpageflags
+unpoison_path=/sys/kernel/debug/hwpoison/unpoison-pfn
+
+# /proc/kpageflags bit positions (see include/uapi/linux/kernel-page-flags.h)
+KPF_SLAB=7
+KPF_COMPOUND_TAIL=16
+KPF_HWPOISON=19
+KPF_NOPAGE=20
+KPF_PGTABLE=26
+KPF_RESERVED=32
+
+pagesize=$(getconf PAGE_SIZE)
+
+kind=${1:-rodata}
+
+ksft_print() { echo "# $*"; }
+ksft_exit_skip() { ksft_print "$*"; exit "$ksft_skip"; }
+ksft_exit_fail() { echo "not ok 1 $*"; exit 1; }
+
+if [ "$(id -u)" -ne 0 ]; then
+	ksft_exit_skip "must run as root"
+fi
+
+if [ ! -w "$sysctl_path" ]; then
+	ksft_exit_skip "$sysctl_path not present (kernel without the sysctl?)"
+fi
+
+if [ ! -w "$inject_path" ]; then
+	ksft_exit_skip "$inject_path not present (no MEMORY_HOTPLUG?)"
+fi
+
+if [ "${RUN_DESTRUCTIVE:-0}" != "1" ]; then
+	ksft_exit_skip "destructive test; re-run with RUN_DESTRUCTIVE=1 inside a disposable VM"
+fi
+
+# Pick a PFN inside the kernel image rodata region of /proc/iomem.
+# This is preferred over a top-level "Reserved" entry because top-level
+# Reserved ranges are often firmware holes that have no backing struct
+# page; pfn_to_online_page() returns NULL on those and memory_failure()
+# bails out with -ENXIO before reaching the panic path.
+#
+# "Kernel rodata" is reported as a sub-resource of "System RAM" on every
+# major architecture, which guarantees:
+#   - the PFN is backed by struct page (within an online memory range);
+#   - PG_reserved is set on the page (kernel image area);
+#   - the memory is read-only, so setting PG_hwpoison on it does not
+#     corrupt writable kernel state if the panic somehow does not fire.
+#
+# /proc/iomem entries look like (indented for sub-resources):
+#     "  02500000-02ffffff : Kernel rodata"
+pick_rodata_phys_addr() {
+	awk -v pagesize="$(getconf PAGE_SIZE)" '
+	# Convert a hex string to a number without relying on the gawk-only
+	# strtonum().  mawk lacks it and would otherwise spuriously skip
+	# this test on distros that ship mawk as /usr/bin/awk.
+	function hex2num(s,   n, i, c, v) {
+		n = 0
+		for (i = 1; i <= length(s); i++) {
+			c = tolower(substr(s, i, 1))
+			v = index("0123456789abcdef", c) - 1
+			if (v < 0)
+				return -1
+			n = n * 16 + v
+		}
+		return n
+	}
+	/: Kernel rodata[[:space:]]*$/ {
+		sub(/^[[:space:]]+/, "")
+		n = split($0, a, /[- ]/)
+		start = hex2num(a[1])
+		end   = hex2num(a[2])
+		if (end <= start)
+			next
+		# Page-align upward and emit the first byte of that page.
+		pfn = int((start + pagesize - 1) / pagesize)
+		printf "0x%x\n", pfn * pagesize
+		exit 0
+	}
+	' /proc/iomem
+}
+
+# Walk /proc/kpageflags and return the phys addr of the first PFN that
+# has bit $1 set, with KPF_HWPOISON, KPF_NOPAGE and KPF_COMPOUND_TAIL
+# all clear (so we attack a real, non-tail, not-already-poisoned page).
+#
+# We skip the first 16 MiB of PFNs to step past low-memory special
+# ranges (BIOS/EFI/ACPI/etc.) that often are PG_reserved and would not
+# exhibit the slab/pgtable type we are looking for.
+pick_kpageflags_phys_addr() {
+	local want_bit=$1
+	local pagesize skip_pfn
+
+	[ -r "$kpageflags_path" ] || return
+
+	pagesize=$(getconf PAGE_SIZE)
+	skip_pfn=$(((16 * 1024 * 1024) / pagesize))
+
+	od -An -tx8 -v -w8 -j "$((skip_pfn * 8))" "$kpageflags_path" 2>/dev/null | \
+	awk -v want_bit="$want_bit" \
+	    -v hwp_bit="$KPF_HWPOISON" \
+	    -v nopage_bit="$KPF_NOPAGE" \
+	    -v tail_bit="$KPF_COMPOUND_TAIL" \
+	    -v base_pfn="$skip_pfn" \
+	    -v pagesize="$pagesize" '
+	# Test whether bit "b" is set in the 16-hex-digit value "hex".
+	# Done with substring + per-digit lookup so we never rely on awk
+	# bitwise operators (mawk lacks them), 64-bit FP precision or the
+	# gawk-only strtonum().
+	function bit_set(hex, b,    di, bi, c, v) {
+		di = int(b / 4)
+		bi = b - di * 4
+		c = substr(hex, length(hex) - di, 1)
+		v = index("0123456789abcdef", tolower(c)) - 1
+		if (bi == 0) return (v % 2) == 1
+		if (bi == 1) return int(v / 2) % 2 == 1
+		if (bi == 2) return int(v / 4) % 2 == 1
+		return int(v / 8) % 2 == 1
+	}
+	{
+		gsub(/^[[:space:]]+/, "")
+		h = $1
+		if (bit_set(h, want_bit) &&
+		    !bit_set(h, hwp_bit) &&
+		    !bit_set(h, nopage_bit) &&
+		    !bit_set(h, tail_bit)) {
+			pfn = base_pfn + NR - 1
+			printf "0x%x\n", pfn * pagesize
+			exit 0
+		}
+	}
+	'
+}
+
+# Return 0 if /proc/kpageflags bit $2 is set for PFN $1, 1 if it is
+# clear, or 2 if the word cannot be read.  Used to re-confirm the target
+# page type after a non-panicking inject.
+kpageflags_bit_set() {
+	local word
+
+	word=$(od -An -tx8 -v -j "$(($1 * 8))" -N 8 "$kpageflags_path" 2>/dev/null | tr -d '[:space:]')
+	[ -n "$word" ] || return 2
+	(( (16#$word >> $2) & 1 ))
+}
+
+# Best-effort: drop the PG_hwpoison marker set by the inject so a failed
+# run does not leave a poisoned page behind.  hard_offline_page() injects
+# with MF_SW_SIMULATED, so the page stays unpoisonable through the
+# hwpoison debugfs interface (needs CONFIG_HWPOISON_INJECT + debugfs).
+try_unpoison() {
+	[ -w "$unpoison_path" ] || return 0
+	echo "$1" > "$unpoison_path" 2>/dev/null || true
+}
+
+case "$kind" in
+rodata)
+	phys_addr=$(pick_rodata_phys_addr)
+	recheck_bit=$KPF_RESERVED
+	missing_msg='no "Kernel rodata" entry in /proc/iomem'
+	;;
+slab)
+	phys_addr=$(pick_kpageflags_phys_addr "$KPF_SLAB")
+	recheck_bit=$KPF_SLAB
+	missing_msg="no usable slab PFN found in $kpageflags_path"
+	;;
+pgtable)
+	phys_addr=$(pick_kpageflags_phys_addr "$KPF_PGTABLE")
+	recheck_bit=$KPF_PGTABLE
+	missing_msg="no usable page-table PFN found in $kpageflags_path"
+	;;
+*)
+	ksft_exit_fail "unknown kind '$kind' (expected: rodata|slab|pgtable)"
+	;;
+esac
+
+if [ -z "$phys_addr" ]; then
+	ksft_exit_skip "$missing_msg"
+fi
+
+ksft_print "enabling $sysctl_path"
+prior=$(cat "$sysctl_path")
+echo 1 > "$sysctl_path" || ksft_exit_fail "failed to enable sysctl"
+
+pfn=$((phys_addr / pagesize))
+ksft_print "injecting hwpoison at phys 0x$(printf '%x' "$phys_addr") (pfn 0x$(printf '%x' "$pfn"), kind=$kind)"
+ksft_print "expecting kernel panic: 'Memory failure: <pfn>: unrecoverable page'"
+
+# A successful run never returns from the inject -- it panics the kernel.
+# Reaching the code below therefore means no panic fired.  Note whether
+# the write itself succeeded, then put the machine back: restore the
+# sysctl and best-effort unpoison the page we just marked.
+if echo "$phys_addr" > "$inject_path"; then
+	verdict="inject returned without panic; sysctl ineffective"
+else
+	verdict="inject failed before reaching the panic path"
+fi
+
+echo "$prior" > "$sysctl_path"
+try_unpoison "$pfn"
+
+# The page type can change between selection and injection (e.g. a slab
+# or page-table page is freed and reused).  Only treat a missing panic as
+# a failure if the target PFN is still the kernel-owned type we aimed at;
+# if it raced to another type the run is inconclusive, so skip instead.
+kpageflags_bit_set "$pfn" "$recheck_bit"
+case $? in
+0)	ksft_exit_fail "$verdict (page still $kind)" ;;
+1)	ksft_exit_skip "target PFN no longer $kind; raced before inject, inconclusive" ;;
+*)	ksft_exit_fail "$verdict (could not reconfirm page type via $kpageflags_path)" ;;
+esac

-- 
2.53.0-Meta


