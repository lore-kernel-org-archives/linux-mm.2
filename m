Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E387CD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 10:58:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A4FE6B0099; Tue,  9 Jun 2026 06:58:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 554D16B009B; Tue,  9 Jun 2026 06:58:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46B3A6B009D; Tue,  9 Jun 2026 06:58:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 36BBB6B0099
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:58:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D944B120523
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:57:59 +0000 (UTC)
X-FDA: 84860074278.01.FDEC124
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf19.hostedemail.com (Postfix) with ESMTP id 00D4C1A0007
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:57:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=LLyynDcB;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf19.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781002678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q7TvAD/W7qEPja1WO+XR8ryHtf6pLEekuUp0XItZmbE=;
	b=Nf7aPEB+5uwXshGxCbzahYIQngeHO5Yb8SkK0ZmSJBgHlIv5WJBd62/pXzuEfWJheiVyPm
	vV3Bg1a6EXQbu9yIPsLbuAx9L68rKlcsMkZ5Yzdp4ZebAoHnfmoQ36wCxJtqaNf9jAKyTk
	4tFBqqCqKmyTEsWRB9tzm7YRzAn0rdw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=LLyynDcB;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf19.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781002678;
	b=aJCA9HRKYcr+qYn0D03bH7d5QQCW2tyKuSG6As3ZWIIwJC/fCFFP62/cxT2t8yANhtwOcT
	LPlvauha6xqBilXrk5Pq4uDrt/M8csahJVf3vBF9QyrHiedlsLwETpJaZ5c5ZOkF++AkYu
	szMJtngeTPUMfavX3vrGhU+5Jh6GWa0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=Q7TvAD/W7qEPja1WO+XR8ryHtf6pLEekuUp0XItZmbE=; b=LLyynDcBn/kej7ZxnzjmwaPCHF
	6bWymESW5D00Zk9lIGIusRX8r56AntU7fW/D2lOsflbzPMRuUpCq47JGQmIzq1bpa89zkSsihk5D3
	ExxR7aGaHhWS+rKJKUEIaKxZAQIn6rbDdBxhrPdyOFpaO4ZtfnkubRVEzQs51XmIxKKwPUUfXFrnl
	c0tX1ITTP06d4/Mhw11CZcYVUmhOfMMGF8S/C3A2OTBkeZMRLnPGcIofpjFqhXwm6LAm7QRycAb3z
	9Y3+SQuB9sb/+uuobQIcJFjP455CfEPusrjfXEYRdl8gbm6oJd14+MNE4eA1Rq6dGie0eQrZFOjF8
	VeZvKYDg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wWu9P-008LuW-1E;
	Tue, 09 Jun 2026 10:57:43 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 09 Jun 2026 03:57:00 -0700
Subject: [PATCH v9 6/6] selftests/mm: add hwpoison-panic destructive test
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260609-ecc_panic-v9-6-432a74002e74@debian.org>
References: <20260609-ecc_panic-v9-0-432a74002e74@debian.org>
In-Reply-To: <20260609-ecc_panic-v9-0-432a74002e74@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=11158; i=leitao@debian.org;
 h=from:subject:message-id; bh=w+Nvwa+39pceerx+IWvAftelt8mEObSt1TNFaahZHeA=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqJ/F/4facG8uiJur6CzzOpPX/GRX+YLanDZXuW
 LFuS6LbEMeJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaifxfwAKCRA1o5Of/Hh3
 bWIWD/9l0sAxnjYROoYKH7YnQAWnduaSHh20QHhSnT9vFtaDgZJBwhxs4x7DWP40xO4SF1l3cRU
 /+6dHi93ehFWfxf+DS+gA/iTmtFod0YEnlFCHYOGAdtdJ4M+JeeWMuI+RthKeIoIaQdZYduecbs
 Pb88PrLGruNxboOJrgAwJ4EsndxXGt6b6/8O2093RhJFr0dc3oBecdfQWrbgDJaW6pM35fyNok7
 DhjeR0XYTEsv/SyyjNDeg0Z8FAJtl8gMfADHQVz2Oy8QkHk/k82rFIJj177l3YlAa6tgA7Xn03d
 7cgarOQJfjdM2uypBRd8bzt3XNw7ReQK8+koCXRVSvIwtfq92ZUQ3X6qPzhgU/4Dbeo7a84F1hP
 r40LIl2CSFRoAw/1EXuSD/2lHr3lQ8n/VUlpN5E8/qIUf6Vc6XKMXWlwZtG9Hmm8mrk2SRyKU24
 l36HHB6aYaJyMdFCyrEUDYGP418gKGWyFuJQRATHMXaN+eIK7ZsQ6jFgYQWBjAkAG9v1RNBdWyA
 9hPI4x6tF8rD2rRznss5zN/sbFYx83L3CwWJHupxLqQRPJdmeeehPrrO3qhGdxvGrEkvcrLdZ5D
 02h8X7f7r+2IJSKfhsO66PHw9aaXdaJS8ZHj4l6Dnctk7EXCRinO5MoICakLtmcgcLGTVGM7o9P
 LcMfvp3ak6LxMwQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 6opi5kt3p6m9kqrq5ykfewatpj4pddfb
X-Rspamd-Queue-Id: 00D4C1A0007
X-HE-Tag: 1781002677-707312
X-HE-Meta: U2FsdGVkX19/JKNSKDytPklDdbqkCDbbDFmfqE6VBxvDvcDBr+IFcDjL1XDfwsj/Jb14mt5mVr9Ss5u0KmYH0kN9Li4PVFkwT8Oz9uqCeR828l+Lr2a6YnlMYrG7NkRVTMEh2xZylKvuiUin8Fa+VnsglY5oP3bm1c72wofUKQHvryk/ijKgw9VoSlzSOuuOOnhrlzCQVgylxJa3Ov7F275ZAVtD5hBEIDcfDc+LBi+JZAt6e/CZLsB2kSfRuuR/0lOsqhvV//EN7qKeAQfq9eB1xI5YrhJTqCrezNXcYIzKd/l0DZXmx7EOdSx/GI4CvK+L8ifGcSN9ZbIVFl3imOlF2nsHx08TQt2yBwamgDIhEpLHUQog1FgrYdT1r9ej514oSL0dfct2kheGNBSLVqwRkS/moSLxAgXs0WfIkUfBOibvirE5Hv7nw3Phz0fA195zxEr/Yw2/GA1N4Y+tRO6VEic3SVSjj8e94sJ68oP5xhhhQO6/xTekbLvKnT2W4zq2MwT91DJEZ68vOqMOOVgcotI/7rT+j0VN6uB34mvG9jZwvFmoRt/2gBq0UfCxumLdGypRcyMjYZUGcdYcSHIGEpRkdbT0gD7isvFUcVN8+5xf3noShEwWVd1Lx1/ezocUjwrVvHvRUrL1BRSzktnD5WXCCLJs5Cdjfdi6lrfRJiFqNEAJ9iMM9BxgtgnCSvjIUAovoq99Ow2F1XhlSiQ49EUhD5MPW/MWvIkFOrQ6Ly3iQSjsxWuza4tjnJMayyELtBC1QqYIdhyu6ofpYI2LxZrBunLkyQ0nszO+pymgvSqmZQ3uV6VOCm2T8xlvLLeowQ0EKBflQxSWkKYPsi6zGjzmMQrwPe/PoBQbKbLRcVrEPwNxEV+xe6VFiSPKdKxzpjGmI3RhulNjwjzGDP1m1vdSZcjjwSZ2ON8n6KdBGs4EWJn6NpIjZCnnYx4nDZXujP8J+uGVV2Stf8/
 /Glxjh9C
 xiRXAbNpBA06Y32GnoYWhr90vPzSe8HY26GsaM8qAFvRDIPOag6dk9lq0DI2CahWrLdxAUOJfL3kAIV+vC965hE+uMn1Evx2bDXlcnqX9Mv4fVZ2yv/jri2nEL31ORQGiVamLUCjn4sgpBEL+sTCgBy2crEptpw6oc8JhlMbNKaBn6G66dpvCbuQ1HC9SHJ0kGKTHBedpnHZZpw7Any77UCByixNDNMgoHwjiDO4LLq8F1WU6ZJgGmsul4u93651LUKQb1x3oaj307BiXYpyqiB08ykY3CL9U1lPbJA7rt4jH+jqxDYuZh0k1ke8mJlm97OoCONnBXv2sXY6kn7PoUa6MfD75EFNwLTJfrhjQ7wYUMbbqtS1/WstLVaoyN4WedyvL
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
HWPoisonKernelOwned(), is intentionally not covered: it is a
PAGE_TYPE_OPS flag with no /proc/kpageflags bit, so selecting such
a PFN from userspace is not feasible.  The slab and pgtable
variants already exercise the same get_any_page() positive-check
branch.

The script enables the sysctl and writes the selected physical
address to /sys/devices/system/memory/hard_offline_page.  A
successful run crashes the kernel with

  Memory failure: <pfn>: unrecoverable page

A return from the inject means the panic did not fire and the test
fails.  Test outcome is therefore observed externally (serial
console, kdump) rather than from the script's own exit code.

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
 tools/testing/selftests/mm/hwpoison-panic.sh | 208 +++++++++++++++++++++++++++
 2 files changed, 212 insertions(+)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index e6df968f0971..ed321ae709da 100644
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
index 000000000000..fe58e7638a8b
--- /dev/null
+++ b/tools/testing/selftests/mm/hwpoison-panic.sh
@@ -0,0 +1,208 @@
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
+# A return from the inject means the panic did not fire and the test
+# fails.
+#
+# Author: Breno Leitao <leitao@debian.org>
+
+set -u
+
+ksft_skip=4
+sysctl_path=/proc/sys/vm/panic_on_unrecoverable_memory_failure
+inject_path=/sys/devices/system/memory/hard_offline_page
+kpageflags_path=/proc/kpageflags
+
+# /proc/kpageflags bit positions (see include/uapi/linux/kernel-page-flags.h)
+KPF_SLAB=7
+KPF_COMPOUND_TAIL=16
+KPF_HWPOISON=19
+KPF_NOPAGE=20
+KPF_PGTABLE=26
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
+case "$kind" in
+rodata)
+	phys_addr=$(pick_rodata_phys_addr)
+	missing_msg='no "Kernel rodata" entry in /proc/iomem'
+	;;
+slab)
+	phys_addr=$(pick_kpageflags_phys_addr "$KPF_SLAB")
+	missing_msg="no usable slab PFN found in $kpageflags_path"
+	;;
+pgtable)
+	phys_addr=$(pick_kpageflags_phys_addr "$KPF_PGTABLE")
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
+ksft_print "injecting hwpoison at phys 0x$(printf '%x' "$phys_addr") (kind=$kind)"
+ksft_print "expecting kernel panic: 'Memory failure: <pfn>: unrecoverable page'"
+
+# If this returns, the kernel did not panic → test failed.  Restore the
+# sysctl before reporting so the system is left as we found it.
+if echo "$phys_addr" > "$inject_path"; then
+	echo "$prior" > "$sysctl_path"
+	ksft_exit_fail "inject returned without panic; sysctl ineffective"
+fi
+
+# Write failed (e.g. -EINVAL on offlining a non-online region): also a
+# failure for this test, since we expected the panic path.
+echo "$prior" > "$sysctl_path"
+ksft_exit_fail "inject failed before reaching the panic path"

-- 
2.53.0-Meta


