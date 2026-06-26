Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F5A5CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 07:07:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C01386B0093; Fri, 26 Jun 2026 03:07:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B89B46B0099; Fri, 26 Jun 2026 03:07:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A57936B0093; Fri, 26 Jun 2026 03:07:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 722556B0093
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 03:07:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C91011203A3
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 07:07:57 +0000 (UTC)
X-FDA: 84921184194.09.7C79EC5
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf03.hostedemail.com (Postfix) with ESMTP id A79E92000E
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 07:07:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=T74Qi6xA;
	spf=pass (imf03.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782457675;
	b=dwO2h01ap9NWNKyxh6GBDCiq+bxC+9Je6T/h6zt2NLMTlMLLcs/usyolc5GWdbKxU5cTwL
	e+qG5J4Y170eiGu7ZbseB70n+gG+Zh0q1dhIYI6YB92VWJXKp0hcxT2IIynr7+Id6gDBie
	28YmRTb/hRhXlib04vxzolwLi/5KTj0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782457675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D2/QFfIJp4/32GGiKH+24p2DarJlOeahIHOo3GA0odQ=;
	b=HWbFLtrgCzR7xJmzGLsVx0YjWrHN3dx+26IaUc9r9YsbI/GuJZvT8HR83rQxeiFL1PpEbD
	qD5X7kDMIkJZQZ9EXSgCp8HbwKP6tuGbdKoX5y633o1UsZdwsmeDKbA+xmbV+66zIP/D0R
	JV6LPJ0Ly9WN7wDeWO15MhasFlfiMsY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=T74Qi6xA;
	spf=pass (imf03.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=D2/QFfIJp4/32GGiKH+24p2DarJlOeahIHOo3GA0odQ=;
	b=T74Qi6xAmaQTqEJzHgjrX4aNuSD26S9wDsgNEw5ahnoYNGkT2YKYqMYgM6CAVuF9WkbRSW92s
	kUuiGw4l02oiiVvX0w9xI96/exF4CEzpn9HHhoJ4nbWdYuM8LRlbz9tFwYPnF3loud/jN8Fk/49
	E2QY+iDAq1i+4nlfCSUOtrA=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4gmmjQ62PBz1prmc;
	Fri, 26 Jun 2026 14:58:34 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 5625C40571;
	Fri, 26 Jun 2026 15:07:43 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 26 Jun 2026 15:07:43 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 26 Jun 2026 15:07:41 +0800
Subject: Re: [PATCH v9 6/6] selftests/mm: add hwpoison-panic destructive test
To: Breno Leitao <leitao@debian.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <kernel-team@meta.com>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
	<skhan@linuxfoundation.org>, "Liam R. Howlett" <liam@infradead.org>,
	<lance.yang@linux.dev>, Steven Rostedt <rostedt@goodmis.org>, "Masami
 Hiramatsu" <mhiramat@kernel.org>, Mathieu Desnoyers
	<mathieu.desnoyers@efficios.com>
References: <20260609-ecc_panic-v9-0-432a74002e74@debian.org>
 <20260609-ecc_panic-v9-6-432a74002e74@debian.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <40150c86-68a4-aa1e-185e-f24f78595650@huawei.com>
Date: Fri, 26 Jun 2026 15:07:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260609-ecc_panic-v9-6-432a74002e74@debian.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Stat-Signature: b3bfqx8hgxjzqig3h3t9nwz9f7aasq9u
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A79E92000E
X-HE-Tag: 1782457673-391292
X-HE-Meta: U2FsdGVkX1+YPpf0ttOtpkEjZ9Xur+wmskJDqjm78VnIs7KlVG/TzPt84vrx2pw76PJTmzy7Iscxcmaioh37Pv393vX0DPv40TaFAV7nvvLrvl83ttfBlH8gW0I6HkG8e3fHimCzRfzgw8V1QBzq/vNjOCZsI1W+MyNmoswP0DPUqQYtkQhmtV/ksV3rDlTztv1KSSn8ixdOrlgzTMHD4JqbiTnddo7ZjLnkSBq0yam68VHZoYX97VDVKjKXlLVxTMVBNM0nkfYDvNLHX9fQTegt6wsDsDKjbaZvMTEThjEPvIH4gmlAHShTo/7+Kau35gqJktkKZ18Aylno0m/4XLddSw9uv/7a0Rl77jX+RZJ0VDvU+kBz1t8YQiNKbDIKYJfP18QjxZd4sxo/3qkCr9j11iLuktstyjf2R7wIT6nB5cc8Tg7ZYwoowSHIzwGjk2JOQ9TzuqK8SZZATZADzfWK7V29irZebjdkiX3KJxL5+73mNgWzbLZIZdhFFFIc3ex45u+NV5B2QNvlY/H2M7e4e3n+TYD61YOAC0KZgyLfycju552tIXAFNUn2N2c4Is8zR1FXRw+R0EN57pia1/Cy8WutVYhKTxSrPbr1AVYDWkRtt1osYWtDgaJdkR42OY44WmrxYBlES8VvYWKikP7cChwlGUswx9RvTmLlyjBYtwB7UfcgYriBgbx4ATSht+TgybpP+gj3Fqwda0QnMwuIWHnbtSDWCVJHKNPOyoVzJjkGyifKdMPbRfwtrQsjh8XBkxkS2kMKrL32B3ewoxm5YQ1JCR10Z31TOLQn43XuwgsDkIxJMDwQB5ZY2UPYQEAblM8Satx+/YU3hjQEMoTOb3BYQ5P4i0yvJ8lTmXsFN7CgKhw1k+VPisgwlPnwp0ri1wElO12JrsSXckGSvlsgME+ko54P4oYY/KZirISetjqpB3OWYZVHJAUmaiBvuinjOczR9TJ0bV5wp9U
 OG2N4cTk
 Rrn+qbjQipmY2pGmv6BkBT45fGdrTyL5X9JG1SQyAMcYZaQyzgPl2A+h7xgN1KRIdWqpq8MulExYEfsJdUeMHFs6Ju60JE09S8tBGBHDRTZJyfewvs24ly+4Sg0Z1hYXlCfQHsewi/0B5bCfg4lJqTS4OT6vy9jYpFQ4P0DWuLTJwQPC1Z5cIDOhvKsj7c+C9oMHSbp3hbVyeYrV+6fGwSH1mng4Ws6NJo8uDUsYIKLNJROjHHcxNLJO3dixiVUeIsfm+zAqBxsAEPXfR8CTJHwC4/RRieCtF0oBNraXFs2kgOrclYLtFH72lvLk/BkhNvtJuxQauJ/Z836aCQYFuQSRtW90qkpMjPF3G5nimueiIrFQANRqjzjI4M4UDT8na8EtnWAMPQJdhKf+dIYx+ASDmOTBhsjTTW3DTpYJ86xhp6FGXoQAOSAbi+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/6/9 18:57, Breno Leitao wrote:
> Add a destructive selftest that verifies
> vm.panic_on_unrecoverable_memory_failure actually panics when a
> hwpoison error hits a kernel-owned page.
> 
> Three "kinds" of kernel-owned page can be targeted, selectable via
> the script's first positional argument (default: rodata):
> 
>   rodata  - a PG_reserved page in the kernel rodata range, sourced
>             from the "Kernel rodata" sub-resource of "System RAM" in
>             /proc/iomem.  That entry is reported on every major
>             architecture and guarantees the chosen PFN is backed by
>             struct page (an online System RAM range, not a firmware
>             hole), is PG_reserved, and is read-only -- so even if
>             the panic fails to fire for some reason, the resulting
>             PG_hwpoison marker on rodata does not corrupt writable
>             kernel state.
> 
>   slab    - a slab page found by walking /proc/kpageflags for the
>             first PFN with KPF_SLAB set (and KPF_HWPOISON / KPF_NOPAGE
>             / KPF_COMPOUND_TAIL clear).  Exercises the get_any_page()
>             path on a non PG_reserved kernel-owned page and so
>             catches regressions where get_any_page() collapses
>             kernel-owned pages into a transient -EIO instead of
>             -ENOTRECOVERABLE.
> 
>   pgtable - same as slab, but the PFN is selected via KPF_PGTABLE.
> 
> PageLargeKmalloc, the fourth page type matched by
> HWPoisonKernelOwned(), is intentionally not covered: it is a
> PAGE_TYPE_OPS flag with no /proc/kpageflags bit, so selecting such
> a PFN from userspace is not feasible.  The slab and pgtable
> variants already exercise the same get_any_page() positive-check
> branch.
> 
> The script enables the sysctl and writes the selected physical
> address to /sys/devices/system/memory/hard_offline_page.  A
> successful run crashes the kernel with
> 
>   Memory failure: <pfn>: unrecoverable page
> 
> A return from the inject means the panic did not fire and the test
> fails.  Test outcome is therefore observed externally (serial
> console, kdump) rather than from the script's own exit code.
> 
> The script is intentionally NOT wired into run_vmtests.sh: every
> successful run panics the kernel, which is incompatible with the
> sequential "run each category in the same VM" model that
> run_vmtests.sh assumes.  It is also not registered as a TEST_PROGS /
> ksft_* wrapper so a default kselftest run does not opt itself into
> a panic.  The script is meant to be executed manually inside a
> disposable VM (e.g. virtme-ng), one variant per VM boot, and
> requires RUN_DESTRUCTIVE=1 in the environment as a safety net.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Looks good to me with two comments below.

> ---
>  tools/testing/selftests/mm/Makefile          |   4 +
>  tools/testing/selftests/mm/hwpoison-panic.sh | 208 +++++++++++++++++++++++++++
>  2 files changed, 212 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
> index e6df968f0971..ed321ae709da 100644
> --- a/tools/testing/selftests/mm/Makefile
> +++ b/tools/testing/selftests/mm/Makefile
> @@ -174,6 +174,10 @@ TEST_PROGS += ksft_userfaultfd.sh
>  TEST_PROGS += ksft_vma_merge.sh
>  TEST_PROGS += ksft_vmalloc.sh
>  
> +# Destructive: every successful run panics the kernel.  Installed and
> +# kept executable, but not run from a default kselftest invocation.
> +TEST_PROGS_EXTENDED += hwpoison-panic.sh
> +
>  TEST_FILES := test_vmalloc.sh
>  TEST_FILES += test_hmm.sh
>  TEST_FILES += va_high_addr_switch.sh
> diff --git a/tools/testing/selftests/mm/hwpoison-panic.sh b/tools/testing/selftests/mm/hwpoison-panic.sh
> new file mode 100755
> index 000000000000..fe58e7638a8b
> --- /dev/null
> +++ b/tools/testing/selftests/mm/hwpoison-panic.sh
> @@ -0,0 +1,208 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Verify vm.panic_on_unrecoverable_memory_failure by injecting a hwpoison
> +# error on a kernel-owned page and confirming the kernel panics.
> +#
> +# Three "kinds" of kernel-owned page can be targeted, selectable via the
> +# first positional argument (default: rodata):
> +#
> +#   rodata  - a PG_reserved page in the kernel rodata range
> +#             (sourced from /proc/iomem "Kernel rodata").  Exercises
> +#             memory_failure() -> get_any_page() on a PageReserved page.
> +#
> +#   slab    - a slab page found via /proc/kpageflags (KPF_SLAB).
> +#             Exercises memory_failure() -> get_any_page() on a non
> +#             PG_reserved kernel-owned page.  This path is what catches
> +#             regressions where get_any_page() collapses kernel-owned
> +#             pages into a transient -EIO instead of -ENOTRECOVERABLE.
> +#
> +#   pgtable - a page-table page found via /proc/kpageflags (KPF_PGTABLE).
> +#             Same path as slab, different page type.
> +#
> +# This test is DESTRUCTIVE: a successful run crashes the kernel.  It is
> +# meant to be executed inside a disposable VM (e.g. virtme-ng) with a
> +# serial console captured by the harness.  It is skipped unless the
> +# caller opts in via RUN_DESTRUCTIVE=1.
> +#
> +# Test passes externally: the kernel must panic with
> +#   "Memory failure: <pfn>: unrecoverable page"
> +# A return from the inject means the panic did not fire and the test
> +# fails.
> +#
> +# Author: Breno Leitao <leitao@debian.org>
> +
> +set -u
> +
> +ksft_skip=4
> +sysctl_path=/proc/sys/vm/panic_on_unrecoverable_memory_failure
> +inject_path=/sys/devices/system/memory/hard_offline_page
> +kpageflags_path=/proc/kpageflags
> +
> +# /proc/kpageflags bit positions (see include/uapi/linux/kernel-page-flags.h)
> +KPF_SLAB=7
> +KPF_COMPOUND_TAIL=16
> +KPF_HWPOISON=19
> +KPF_NOPAGE=20
> +KPF_PGTABLE=26
> +
> +kind=${1:-rodata}
> +
> +ksft_print() { echo "# $*"; }
> +ksft_exit_skip() { ksft_print "$*"; exit "$ksft_skip"; }
> +ksft_exit_fail() { echo "not ok 1 $*"; exit 1; }
> +
> +if [ "$(id -u)" -ne 0 ]; then
> +	ksft_exit_skip "must run as root"
> +fi
> +
> +if [ ! -w "$sysctl_path" ]; then
> +	ksft_exit_skip "$sysctl_path not present (kernel without the sysctl?)"
> +fi
> +
> +if [ ! -w "$inject_path" ]; then
> +	ksft_exit_skip "$inject_path not present (no MEMORY_HOTPLUG?)"
> +fi
> +
> +if [ "${RUN_DESTRUCTIVE:-0}" != "1" ]; then
> +	ksft_exit_skip "destructive test; re-run with RUN_DESTRUCTIVE=1 inside a disposable VM"
> +fi
> +
> +# Pick a PFN inside the kernel image rodata region of /proc/iomem.
> +# This is preferred over a top-level "Reserved" entry because top-level
> +# Reserved ranges are often firmware holes that have no backing struct
> +# page; pfn_to_online_page() returns NULL on those and memory_failure()
> +# bails out with -ENXIO before reaching the panic path.
> +#
> +# "Kernel rodata" is reported as a sub-resource of "System RAM" on every
> +# major architecture, which guarantees:
> +#   - the PFN is backed by struct page (within an online memory range);
> +#   - PG_reserved is set on the page (kernel image area);
> +#   - the memory is read-only, so setting PG_hwpoison on it does not
> +#     corrupt writable kernel state if the panic somehow does not fire.
> +#
> +# /proc/iomem entries look like (indented for sub-resources):
> +#     "  02500000-02ffffff : Kernel rodata"
> +pick_rodata_phys_addr() {
> +	awk -v pagesize="$(getconf PAGE_SIZE)" '
> +	# Convert a hex string to a number without relying on the gawk-only
> +	# strtonum().  mawk lacks it and would otherwise spuriously skip
> +	# this test on distros that ship mawk as /usr/bin/awk.
> +	function hex2num(s,   n, i, c, v) {
> +		n = 0
> +		for (i = 1; i <= length(s); i++) {
> +			c = tolower(substr(s, i, 1))
> +			v = index("0123456789abcdef", c) - 1
> +			if (v < 0)
> +				return -1
> +			n = n * 16 + v
> +		}
> +		return n
> +	}
> +	/: Kernel rodata[[:space:]]*$/ {
> +		sub(/^[[:space:]]+/, "")
> +		n = split($0, a, /[- ]/)
> +		start = hex2num(a[1])
> +		end   = hex2num(a[2])
> +		if (end <= start)
> +			next
> +		# Page-align upward and emit the first byte of that page.
> +		pfn = int((start + pagesize - 1) / pagesize)
> +		printf "0x%x\n", pfn * pagesize
> +		exit 0
> +	}
> +	' /proc/iomem
> +}
> +
> +# Walk /proc/kpageflags and return the phys addr of the first PFN that
> +# has bit $1 set, with KPF_HWPOISON, KPF_NOPAGE and KPF_COMPOUND_TAIL
> +# all clear (so we attack a real, non-tail, not-already-poisoned page).
> +#
> +# We skip the first 16 MiB of PFNs to step past low-memory special
> +# ranges (BIOS/EFI/ACPI/etc.) that often are PG_reserved and would not
> +# exhibit the slab/pgtable type we are looking for.
> +pick_kpageflags_phys_addr() {
> +	local want_bit=$1
> +	local pagesize skip_pfn
> +
> +	[ -r "$kpageflags_path" ] || return
> +
> +	pagesize=$(getconf PAGE_SIZE)
> +	skip_pfn=$(((16 * 1024 * 1024) / pagesize))
> +
> +	od -An -tx8 -v -w8 -j "$((skip_pfn * 8))" "$kpageflags_path" 2>/dev/null | \
> +	awk -v want_bit="$want_bit" \
> +	    -v hwp_bit="$KPF_HWPOISON" \
> +	    -v nopage_bit="$KPF_NOPAGE" \
> +	    -v tail_bit="$KPF_COMPOUND_TAIL" \
> +	    -v base_pfn="$skip_pfn" \
> +	    -v pagesize="$pagesize" '
> +	# Test whether bit "b" is set in the 16-hex-digit value "hex".
> +	# Done with substring + per-digit lookup so we never rely on awk
> +	# bitwise operators (mawk lacks them), 64-bit FP precision or the
> +	# gawk-only strtonum().
> +	function bit_set(hex, b,    di, bi, c, v) {
> +		di = int(b / 4)
> +		bi = b - di * 4
> +		c = substr(hex, length(hex) - di, 1)
> +		v = index("0123456789abcdef", tolower(c)) - 1
> +		if (bi == 0) return (v % 2) == 1
> +		if (bi == 1) return int(v / 2) % 2 == 1
> +		if (bi == 2) return int(v / 4) % 2 == 1
> +		return int(v / 8) % 2 == 1
> +	}
> +	{
> +		gsub(/^[[:space:]]+/, "")
> +		h = $1
> +		if (bit_set(h, want_bit) &&
> +		    !bit_set(h, hwp_bit) &&
> +		    !bit_set(h, nopage_bit) &&
> +		    !bit_set(h, tail_bit)) {
> +			pfn = base_pfn + NR - 1
> +			printf "0x%x\n", pfn * pagesize
> +			exit 0
> +		}
> +	}
> +	'
> +}
> +
> +case "$kind" in
> +rodata)
> +	phys_addr=$(pick_rodata_phys_addr)
> +	missing_msg='no "Kernel rodata" entry in /proc/iomem'
> +	;;
> +slab)
> +	phys_addr=$(pick_kpageflags_phys_addr "$KPF_SLAB")
> +	missing_msg="no usable slab PFN found in $kpageflags_path"
> +	;;
> +pgtable)
> +	phys_addr=$(pick_kpageflags_phys_addr "$KPF_PGTABLE")
> +	missing_msg="no usable page-table PFN found in $kpageflags_path"
> +	;;
> +*)
> +	ksft_exit_fail "unknown kind '$kind' (expected: rodata|slab|pgtable)"
> +	;;
> +esac
> +
> +if [ -z "$phys_addr" ]; then
> +	ksft_exit_skip "$missing_msg"
> +fi
> +
> +ksft_print "enabling $sysctl_path"
> +prior=$(cat "$sysctl_path")
> +echo 1 > "$sysctl_path" || ksft_exit_fail "failed to enable sysctl"
> +
> +ksft_print "injecting hwpoison at phys 0x$(printf '%x' "$phys_addr") (kind=$kind)"
> +ksft_print "expecting kernel panic: 'Memory failure: <pfn>: unrecoverable page'"
> +
> +# If this returns, the kernel did not panic → test failed.  Restore the
> +# sysctl before reporting so the system is left as we found it.
> +if echo "$phys_addr" > "$inject_path"; then
> +	echo "$prior" > "$sysctl_path"
> +	ksft_exit_fail "inject returned without panic; sysctl ineffective"

In case of failure, should we recheck the page type? There is a window between
we get the phys_addr and inject the hwpoison.

> +fi
> +
> +# Write failed (e.g. -EINVAL on offlining a non-online region): also a
> +# failure for this test, since we expected the panic path.
> +echo "$prior" > "$sysctl_path"
> +ksft_exit_fail "inject failed before reaching the panic path"

Should we unpoison the pfn in case of failure?

Thanks.
.



