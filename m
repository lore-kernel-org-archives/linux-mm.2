Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3FF8CD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 14:07:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67CB86B00E6; Wed, 27 May 2026 10:07:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 654266B00E8; Wed, 27 May 2026 10:07:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 591826B00E9; Wed, 27 May 2026 10:07:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49E1F6B00E6
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:07:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 158541405C0
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:07:08 +0000 (UTC)
X-FDA: 84813376536.04.E4F61D2
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1D63040013
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:07:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=GHjxepgV;
	spf=pass (imf12.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779890826; a=rsa-sha256;
	cv=none;
	b=V4BY2ZbQDRYzg40PWnY5d+m+hr20NcVZ8lTqjnsEseieU9LSPh0DCdMcizTrBIyFiC/5F1
	iVqzlD1DNp20nP+/XA/GndVzS1yPLlSz/kWcvgE7sCGJpD4Ippw8n50Fy1wmzZfaeSYBlI
	VBklQZI2OTj98YVGgdF1qZk8805iLOE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=GHjxepgV;
	spf=pass (imf12.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779890826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Qlr84M3AeZWVAoevmGDLh4IZ1AZxtRMBdJ6NJSNbEM=;
	b=QFP4zkGA7fLK2alJQxbyYyF6HYR7Bc7fce/MrLRphvA0LSrIFamlpfBzQ3l34VNceOB6TQ
	pz1FvzKiBr3IgSyZi4EhqZFrmadZ5i96s+cObHJ1yxcvT33gHKvuw0RBxuFLXIbsdpySQM
	rpU762n8unrt/LK3pJsyHgxlynytiHU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=0Qlr84M3AeZWVAoevmGDLh4IZ1AZxtRMBdJ6NJSNbEM=; b=GHjxepgVgGnp6Wf+o29m2Ra++S
	HFNuFpXEwMWMHjCwolxdH0TgvMvXleWGAmx5CPU5vDtEjhmwWU9K01Ot55hcZZ+Q8GVMYh5JJoYlU
	7+tcNX0fW04IhfaPS18QsbYuu+iwgFrPeQxpV1tTu49ywF8ssNv9hDQ69nuhj6ZPf1XsEpbiuvsb9
	klvs+2Rpwk0Wb7r8qU0XF6/1mFP8iZyan4JFw+s7/s1bkzd6itDmX+bbtbk+eHBKSVqH5H+baS3AC
	nAZZrn9qt6TF6bKNOE4huToK+9laoek5rYNPBaT++oIYKWEppfJl+weFUCdsSiOsMFWvhFDALjEVF
	rmZFus2Q==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wSEuR-003DUA-1w;
	Wed, 27 May 2026 14:07:00 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 27 May 2026 07:06:19 -0700
Subject: [PATCH v8 6/6] selftests/mm: add hwpoison-panic destructive test
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260527-ecc_panic-v8-6-9ea0cfa16bb0@debian.org>
References: <20260527-ecc_panic-v8-0-9ea0cfa16bb0@debian.org>
In-Reply-To: <20260527-ecc_panic-v8-0-9ea0cfa16bb0@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, linux-trace-kernel@vger.kernel.org, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=10551; i=leitao@debian.org;
 h=from:subject:message-id; bh=SDfzb/1Kmc5Trou98JEPROybLRDzX5OpaKP4EzW9bos=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqFvpb7o3XvcRbKPyXz7XX5qBYI9bJQToApahEY
 327G7A4xtOJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCahb6WwAKCRA1o5Of/Hh3
 bRBLD/4h24VZsHSQb9dnBv2gc5/3ym90bQI7rQpxuprsupXISYHUL9HYiIqBe28ACS97PYPO91+
 nCIj1wqExeImfriJIlsiGUhcrLTBcFwvwmbMctZ19cBlwVv97HPsYnqzUyQfy5K0T5wzNQaRSjG
 sopEnb9S3U3ZWCTj+YCZ+P8Zca7fy0KDL+4edk19jBTjVweXcXG4pnZIQXeT/Y22sC6C/1tiDcM
 m7bUpFsrsG0GgHeRSQhyvD88B/QCEYcZ9f12FRVS877nxMcY9J11i2BC/YjrCCAE26Pe2ei+KNZ
 uKONOsCzPURI5ubYxB9cs1027cLbuj0b5wFWPLKQHh3XlR1LO+okzSu/nU8yZQRl5CkKAaETkDb
 mtvj8tzqQYIPORHn3YXtrbrcZj+FCyWe3A7/EovZ8Qh0dtuqKiaNCJSXeDYpZnpHUCezHgHAIuO
 be+D8v7rDeMJ3efLJWxgsIfYQdkbvUsRXl2c4so0acS+hkUPe+oZPj/gwAvkoRadtesOFRImiqz
 SIZp7Li/3WAybQkjarOu9L6W/2MaIpyzNc5VX/yuB9SbkZHDsdAc5H1wCAwDpmnGizvmYABx/Z5
 TVLgb0XTikNOOLSTD8bucvWJKb+8JWRmYmSm7AYun+x6CUn78004D8oxOqwwkQhtSLU08TgIu3j
 HH4G+3Q8TZ4RnuA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1D63040013
X-Stat-Signature: j5t81heg4tpnhirsad8kwqept3t9jwjd
X-HE-Tag: 1779890825-703994
X-HE-Meta: U2FsdGVkX19TbnuFytMkwfxxcSAG25kbN+fZC7pnEGq1us77I5ZZr9M0lkcgUnaFVjz/SROLz97yCVfDp0TrYz+/IEZheZvL1IoKdfP2gyxFq9cZHrQAs/2BF76ajhsOXZqHbP0Y/4evx7J78vMSloNuSdHQ15aBeVBUtEjrIt4ZXnDmC2fdVm/3KBW6yv03DsICyzsCo2j8PmoS74C5utkHSpHfixNlcqJDwvgV3E1PDE8P6QaCwnxBZ6byrVasdvJQVG9wYAtXUgpCo4NsOOI960/sOtM/+0ZKPMARYaAohOZaPQPh9VlurrIjdRWtQ3nEe/9nfmZatWirQJ/FVlRcVBI/lR4VLZ8iRWBNGmjREPyPY+5mtuxJb3wzjDRinMLnBJyWEMk3xk5eoT3bcsCouzKBw8yuFnvl+GDxE3SDqB2VtYU9xMqVKSCvsqy1YTNDn4kMD/wOyZXwoPu1lUuIPxctDh+rHm5qYgwYqgjpHdVVXbGAqAibR7Hxufr78R5wXlp02F9ai8wB4fhIxHJ0L+zkIAgX28fk8z9RxF1Lu3OWrnYVnwD8XoqsdNkWU3mha3ZF1Hhr/1XxPmjfTH5VOaBa0hrRHrYN7JtVqlPkvjDA+lPYow60ZioPD4wdG3Dh0yvbN1KqItpvwmhQuWMK9jLYksuKtuanbymGBu3UmTkDYvO1j/J3tJjT9sJ3nP87ryWbp8/ptkctCdTWWz03O3lkfXHUPYGzjsZjNDEVAceYDbJ0rNUZwgFLJGnBTUpgqIMjLrmXpWzCtgeBXY1jXYaVrmOnNjdE2NPUldGoHhm/a9H5bkqU8zGKTzXBajtGSXte0aFBJWhfKYOmUcD3IkSqJQgGG3Th9FrkL6BMjRYMHSPXGYwVVJZs2ykO3oiQeLuTpq+yUts+8CejSTREeRHjYF8YZtCxlxKXQFo0RZEHCBfAsHDGsQpHwrAbVCUxuH7CpGg4TkicWXN
 fpWyl4be
 RHWmM33RXBg9rPJLqSUzLz1smd5nq7TaeECpQydDdrTk97iF8dJrxK/96ykncp4E39Sw+KxlwTcCtvEDH2Ka76zlmDD7zE3MbM/A7Lfj3yIpIObyon8RM7IZw/hdJlgqOsZIXBDDmqP7iZ4irvfLVinuRx2IThzf+QF+m4D9ZbWrWWvFcUpOG3UGGA9wEd3Q6vxBfHK0EsC3tJaaC70JOdb++VVszvwS9VNfzLYhb/8CjgoZL7IuqzQeHUJo3c1J7wBQe6/npt+i62enWB2e3qXMRwUdixiJJpnKzM5skLKmJPMvFrRqKBuaa0XBoVvfyhyZnn98epU3Y/Ldd9Xwg6KgEcen7gQ6cbp+wfocwdf/MVZ2z77qjb58GA5Uqfd1lvmbz
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
 tools/testing/selftests/mm/Makefile          |   1 +
 tools/testing/selftests/mm/hwpoison-panic.sh | 193 +++++++++++++++++++++++++++
 2 files changed, 194 insertions(+)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index e6df968f0971..170e376c97b4 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -181,6 +181,7 @@ TEST_FILES += charge_reserved_hugetlb.sh
 TEST_FILES += hugetlb_reparenting_test.sh
 TEST_FILES += test_page_frag.sh
 TEST_FILES += run_vmtests.sh
+TEST_FILES += hwpoison-panic.sh
 
 # required by charge_reserved_hugetlb.sh
 TEST_FILES += write_hugetlb_memory.sh
diff --git a/tools/testing/selftests/mm/hwpoison-panic.sh b/tools/testing/selftests/mm/hwpoison-panic.sh
new file mode 100755
index 000000000000..43fc379f8761
--- /dev/null
+++ b/tools/testing/selftests/mm/hwpoison-panic.sh
@@ -0,0 +1,193 @@
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
+	/: Kernel rodata[[:space:]]*$/ {
+		sub(/^[[:space:]]+/, "")
+		n = split($0, a, /[- ]/)
+		start = strtonum("0x" a[1])
+		end   = strtonum("0x" a[2])
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
+	# bitwise operators (mawk lacks them) or 64-bit FP precision.
+	function bit_set(hex, b,    di, bi, c, v) {
+		di = int(b / 4)
+		bi = b - di * 4
+		c = substr(hex, length(hex) - di, 1)
+		v = strtonum("0x" c)
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
2.54.0


