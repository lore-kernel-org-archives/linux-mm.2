Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A15E1C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 12:47:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF2156B0121; Tue, 30 Jun 2026 08:47:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC92D6B0123; Tue, 30 Jun 2026 08:47:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE0056B0124; Tue, 30 Jun 2026 08:47:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC78A6B0121
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:47:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3B3C51A02A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:47:10 +0000 (UTC)
X-FDA: 84936554220.05.76A56F0
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3583D80017
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:47:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="WdR/1pAE";
	spf=pass (imf02.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782823628;
	b=myq26xutt8AGlQV8bZZabYHzI9kMNC73tVdGRv6ZoBfj84Kx10ynyP4kh+jNpKfNhVpzeW
	7wjK7SR2UmkCTPOI79O/cpir6UrxYRRODrb8PbkHz325SgTWw4wHC8tjV8GbzUK7OoHceT
	UOFit8iFfSLPDvuOPk9KrLjfWGdO6yo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782823628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PcmIXFIqufc4bTO1b76BL7YZU2wOX//eQFq2svpht7k=;
	b=oTXGrSUcFX4QJ8rwK3yVbpUn9j5xVS8B1lARvCHN388F16awW94puTBV8/EAO72fCGU4Qw
	n2n0RoBD4d9z5kReajmLJhDhb3Y0lD931RlRdvh5WgzMMJsvZvJtA7MZULMbMtjNmTlUIh
	L2HfAVkCleaveyo082osdNrmpFui2gk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="WdR/1pAE";
	spf=pass (imf02.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=PcmIXFIqufc4bTO1b76BL7YZU2wOX//eQFq2svpht7k=; b=WdR/1pAEJ27eeWqLfaPQslY2ua
	ypaNnSKKCMj15sR3OfL0ttkSd9S2K46BQi7cDAkg2jd8LNI4rSxEaIe/rZzWfKJe/bvfn/OG7mby8
	ffbDEDKj+9JhDOsGyqRCXHvYtFOWHpDW/0Cu6pgRK46TGnczMPnqJQkQBlqcey5MIgoL+qKRCp+LF
	f+egXOZlOeE3wZkggHmsLuBwEGEeA91ad60UFXV7VSjJMZslpshoprZsaaage53k2Digb2E5bb9I4
	uBT/HBUaxODrg0DBJ+HZtzsg+nznIh0Ui7R8/KHY3MttOea4+1O81p21NOkRBQy/XKgn4p9JvHQxT
	RDCcaHfg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1weXri-0074cY-24;
	Tue, 30 Jun 2026 12:47:03 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 30 Jun 2026 05:46:09 -0700
Subject: [PATCH v10 6/6] selftests/mm: add hwpoison-panic destructive test
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-ecc_panic-v10-6-c6ed5b62eea2@debian.org>
References: <20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org>
In-Reply-To: <20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=13525; i=leitao@debian.org;
 h=from:subject:message-id; bh=LhHpIL13VlXl5A9ex5WeFsEyWTDNrnYxT7YP0ThqPOQ=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqQ7qdKmH0N8viZGd8VfikZ05M5mhwWJhvdB7Rs
 JlB8uivUnaJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCakO6nQAKCRA1o5Of/Hh3
 bcc6D/wPumnvTrF4dSBiX3u9LJYysGNgfGiXQJt3rEGR5DJ9lyt5tOvOZbkpiYr69aEA7Son3vo
 DO5ONSFTMKqybAfbbwOKSSHErSEHH8ta9VYMy9aiZ/eX/ZUBJl5zccy2yzfaFKQNQeWWM69ep9h
 RcWLjOftnolEK+1NAir178bouyOTXUcXK+d53ILO7iEPnF7ifHP0lXx48AdErUOrHP6SFYOD/vn
 RzEFXLP0PZmpSghNGiirfOylCFWQsDX8J/g/adff6GxKxbvRuEly2zjrKF42EcrTedW7VoqMVir
 ecwyRHNL03Y403P7q6og9pbK4SiGBkcaqA4AjQvNDAjLfz/sQ+7yp3z4iWF2SvpgpueGd9LLg58
 dgRyAsQ4QZEH6W/RveLOEEc3HY7isXrWvD2hZkez9lGqiDrMdbJ3RL6XcBONyJpqrYQVa1g5e4z
 fC6RKLdWXp/7w0EmBZjHjq/hLq11eaFN/UrCab5R/mKPwcL1c+sByBescGXKtA2OURC+SU2AWUa
 vdzq2l+dTVBWn+F7YGhH6Lb3BTlapN6BA/lPwIIJ+wfc2MCamCda9ceydRNYB/s0n1HUXCAZYXX
 ZkFPCvh/WdXySkM0IUXOa4sgglVVPMX8MBNEx4BQAje7i4woZSTDHPX8qj4AR8zB9H/kECfiSOb
 uMN5+jvQ+u8Noaw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3583D80017
X-Rspam-User: 
X-Stat-Signature: 8a3s9bcj7s6myrea5k7ws8a7cz9i48ss
X-HE-Tag: 1782823628-374218
X-HE-Meta: U2FsdGVkX1/xeU4pqwZC2DIC2UShVeK4qN/hJGkkhbuHwK7Ndc54SOuxBzVyp7lqdBdeSIM1sJqup1aqXwSKrDVbCtdjCyYvHSdmbmUmJIXksrJzObamT0CrFAjUKYkmr94jJsIyWzYj6OjtMn53SolmyQQGQC6lz9zsUUFyWhjzTmxhe7b6cOtI/lKwxPJ4uY3cHObP8wy/q41M7Q+DSmeslcLdDUEIYTBLx5+obRkq8FgSdAoidYDp+l9uOivmLO5vja3FKXp1oJdOeclNyUEuV6mJn4NXGgVsmsXLQWg0SmD6zAZcHeCq38OknMXxcSa86bnVEsyKys2n8S1d6XuG3sFdbZjuKeN1afOpmOeAT+g29rJxPTdSV+zXEfMbRIulmQ9xd/ssK3f16nfFSA5WxWUUWoUPgiln2loulW6E9r6wMuKwqXV53eu729af/qyvUqR5Te17nNMdEhQCiEUJbfxI4RrI3HOC9mAKcd3F2GRoxlvd3d0jsBTDnQynO/Ucy1EWHnFo4AH8emCd1lI3nlSvGViV7wnHugPtLq6e3OsGFYxhxtwaU6NGPfw7FWMmriBZILX3sUDDAKOE5Sr0ISALho8e6I9ai/gVBIb61oAc1c6eA32OO7hoRYaoyREN9FK6jPbfwH+OwcD+L/DKvJbeI6ll8CbrYzfAREHNdRAjpDJsbCd8m7y06zFCaD+wn3Sfm/S+J3hz1R+ITFG9pS4ecXM7Kgh2s4iMWAkSiTiH/YYtGMkURRzG7Qjo/geU4Cu/mrwBHDMp35Lg0hjMaaAEhsUKRcLluVX/nxH6/OemYB6p0M9ZJGlKWckO60z9oOK+Ryp7y77ku7kgEIhre38A2Qn/G7cGDK0K0ZtVYt6YTMtKnNbz/xp7pII4L10dDZzFOj7z5XZqY8OPG+fh+nMR9Mapg3Ugsi0Xq9YVukKQ6I0goxDqWCOrs25cudu5TlsJVGStB6IY/Uk
 7fvKTD9s
 vZ4dQ7u4dlbB0mlOyK7mDN7+7+jXDg0Owf4pgb946LDQ5AQU/sUgNGfa+3y3zEGHlpeZVenzskcw+OStlSImeSQq3u8yJMthER/LoTQP4EaE/hEzQx5Q5FrjXVsHOsV5zpwYNwsEtC+gIwchYUiupLjLoxxNxLty+1GWgljHzorKbwrRDdlf0npxz3UUO48NLRx+TCtEwaihlOcLz8mDFEJFrOPTyaZZR+wCLFlrOHgMLsmk6XXMpBZQoKS6aQMOHUBVGZ5InrL6gWtKepetx1fMpdFBfuyzv7wfrjShM+b26GmmfirsuheRlzr6hPd869LzQvxPz0HF3HYau5vC1lV2mMDqxdeykWeW5jQhGMleMXhw=
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
 tools/testing/selftests/mm/hwpoison-panic.sh | 255 +++++++++++++++++++++++++++
 2 files changed, 259 insertions(+)

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
index 0000000000000..d953d13673324
--- /dev/null
+++ b/tools/testing/selftests/mm/hwpoison-panic.sh
@@ -0,0 +1,255 @@
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
+# KTAP output helpers (ktap_print_msg, ktap_skip_all, ktap_exit_fail_msg, ...).
+DIR="$(dirname "$(readlink -f "$0")")"
+# shellcheck source=../kselftest/ktap_helpers.sh
+source "${DIR}"/../kselftest/ktap_helpers.sh
+
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
+if [ "$(id -u)" -ne 0 ]; then
+	ktap_skip_all "must run as root"
+	exit "$KSFT_SKIP"
+fi
+
+if [ ! -w "$sysctl_path" ]; then
+	ktap_skip_all "$sysctl_path not present (kernel without the sysctl?)"
+	exit "$KSFT_SKIP"
+fi
+
+if [ ! -w "$inject_path" ]; then
+	ktap_skip_all "$inject_path not present (no MEMORY_HOTPLUG?)"
+	exit "$KSFT_SKIP"
+fi
+
+if [ "${RUN_DESTRUCTIVE:-0}" != "1" ]; then
+	ktap_skip_all "destructive test; re-run with RUN_DESTRUCTIVE=1 inside a disposable VM"
+	exit "$KSFT_SKIP"
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
+	ktap_exit_fail_msg "unknown kind '$kind' (expected: rodata|slab|pgtable)"
+	;;
+esac
+
+if [ -z "$phys_addr" ]; then
+	ktap_skip_all "$missing_msg"
+	exit "$KSFT_SKIP"
+fi
+
+ktap_print_msg "enabling $sysctl_path"
+prior=$(cat "$sysctl_path")
+echo 1 > "$sysctl_path" || ktap_exit_fail_msg "failed to enable sysctl"
+
+pfn=$((phys_addr / pagesize))
+ktap_print_msg "injecting hwpoison at phys 0x$(printf '%x' "$phys_addr") (pfn 0x$(printf '%x' "$pfn"), kind=$kind)"
+ktap_print_msg "expecting kernel panic: 'Memory failure: <pfn>: unrecoverable page'"
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
+0)	ktap_exit_fail_msg "$verdict (page still $kind)" ;;
+1)	ktap_skip_all "target PFN no longer $kind; raced before inject, inconclusive"
+	exit "$KSFT_SKIP" ;;
+*)	ktap_exit_fail_msg "$verdict (could not reconfirm page type via $kpageflags_path)" ;;
+esac

-- 
2.53.0-Meta


