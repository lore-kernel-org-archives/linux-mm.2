Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84ED1E7DEF0
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 14:56:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E19806B00AE; Mon,  2 Feb 2026 09:56:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC7CF6B00B7; Mon,  2 Feb 2026 09:56:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA9206B00B9; Mon,  2 Feb 2026 09:56:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B67E56B00AE
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 09:56:06 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5F1431601BF
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 14:56:06 +0000 (UTC)
X-FDA: 84399816732.05.415DCA9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id A2AD0140004
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 14:56:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SJKoBUVB;
	spf=pass (imf26.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770044164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r9CT2H+uz3ERa2jBFKO6fCNSKr0uIo64StJcK6hJkgg=;
	b=LX/m4rTSZua1aEVmC/Zlgr5ua1He1M+acbYhKF5Q6cooSqhQYVGnjU9cEpGORa9QdM91QX
	uk3jXbz8HinRdC9VpaBOu3kbBv/cQlYLD4fJaEwWqoO3ECiNzEbtE2z95xH/e7P13ZaCbj
	RlPHlI2RKRBpZu3/z1AkHe6HANICHp8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SJKoBUVB;
	spf=pass (imf26.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770044164; a=rsa-sha256;
	cv=none;
	b=mbYo9pk9OrLrOMEH7jLzd8Zo63rYF4+lN8qiuoxUoqhDNG5b7rJf4Km0hE6h+Cpfi3N2nz
	cCZdfgnMfACHG9OLhrSlNASVMuw9/odo4ZUoZ3+w4DstFBmai5fOVeKlld1lrFhbsRw6Jh
	Dlk87JBR4RauAaWkNHcNGM3tcJddDXA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 521BF4358D;
	Mon,  2 Feb 2026 14:56:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30355C116C6;
	Mon,  2 Feb 2026 14:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770044163;
	bh=/EEdBOPFOkFatjqAoJx76sQaNiSIsTwcgFVOLGrY1HU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SJKoBUVBwIEdP0ez+/+iTLxXI9dg2/8/e4Bi+0zzGtm/ZM3a5rwzNfaDvlJHvIjZd
	 T7pS1A93ZyE5Wpc9Pwx3A0B+cgdd+iqB6TgZLF3pD2zxmmb0HxGqI6H2JDOPpcKB0C
	 CeeNhyKCh5wcM3TQQH3jOvc5mCS+GW12lXy9IP2F+L9uyue/G8URz1KY2CWoSEnZv3
	 pA9NE+O5KpZ7XI0nlBPVipwVgrYa02pp1G/hdlNs0VIB2B5TylOWqkak+yGMKfLlM3
	 JgTwJHxmBLDuS+7ooKAjibaPjdn5rpxa6pC1zIDFMUMgU5Jn8/R6UTKXG7hdVStaV1
	 Aag9mpgttmYyQ==
Date: Mon, 2 Feb 2026 14:55:58 +0000
From: Will Deacon <will@kernel.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com,
	zengheng4@huawei.com, ryan.roberts@arm.com,
	anshuman.khandual@arm.com, wangkefeng.wang@huawei.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v3] arm64: mm: fix pass user prot to ioremap_prot in
 generic_access_phys
Message-ID: <aYC6_lSm_eJeKIcn@willie-the-truck>
References: <20260130073807.99474-1-tujinjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260130073807.99474-1-tujinjiang@huawei.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: b5qjgjczh58exxunh8icyyaqfgbtrx5b
X-Rspam-User: 
X-Rspamd-Queue-Id: A2AD0140004
X-HE-Tag: 1770044164-197114
X-HE-Meta: U2FsdGVkX1+NTRBuwXSMd0nTRqJ5WA4N4JahkrC4+BkFzimixp2B83TDYYb1nRkiZJ8O04J5iZ/9/K7Z7tW/W2rxjBVM6mslrLXhdd77We1EvsRTmmOaFLdEuqB5Be2CjY83w4SXHFpFDfOuOnN7nV7LiOPaPKakbAszO6p7RF4TjgIqZuXKiImT97UsVpd87HnuO6JmQeWfIf9MY2K5XNaKjIhTUXB4BT0hGaagpZT4manfHd0ZUzydbEeuqwaTaRZgj2iPp3xp84NBNOUTYnx/y/M5eTNK5wvmnPGJfrRqmEZ9iAoZ5zeycWIwtJejdgon1cuAwErgksgl3w+QC5Po/jnNXxqq67DxrZ8k/yFmBzeFaJR8/5Pj3D1E85RD5AVVemqt/4I8Dr1Eumzr5aqOCx9agugNWj5NXHw1uldL2HBGZ0VAdxhFJmj2RH3fiY5BvdX/os+MUMuInzDz5rWppJ82QzjkscbQC0oM1No5VfYJoIrOxPsAceJyIvuePldzVFWbOqU0uKQjasX86lRPeE3FBk0YQ0XSmmf9PuKcsVH7erckiFDICHbZk7Br6jBxzDhLtz2CY1Vuk9BurSS56V60k1lll7YOy/q3I2wBwNDzluiR1hB3UT0jeQoTsRPYPow65kV7HYGWU0kzy57t6FwqTj2cFao10NfuCw6p5cT6EHIfqy1Z8OU3/lp8ilkQjc6FMUz1A1gHNI5a8iZuId50eMoXTNrjBZfEiI+g+DdlL1GNvC4PClWrsAXxMB/PIyvq1P7N53/vbHT9oEspgR+Fagbv4rWN/sMM6D0rYqMTqYlHshLLQG3+6t7LN7kSyDMC1dUwDvArTT/pLkBekybHDq3KhFMFS43dyjAjXSW8GJd21ll6XkPmb2YmY0wy+ZsRFshDDN19AK6D1joN5Pab0nlF/9G0HpllRO7jxaXUyVURvnV/ePi7W4Fm2M1idDBaoJaxsyWMwGK
 /y0/HSuY
 HvJCal8Bpl6gb2e3Lxv72HXtwFliZ0y3M0uSsUs5C3o5DEnK6Lwu+lRegZlwj2R/OoIXxhJqdnl/2MNR3uJgqDboVht+7OFXIqqzVQjU92CgRkf1L6q6QxKrYcku/92ySoaAFQztwh9dajoUahkllQG+UapayGe4CIq7c1k8UWNTw9ZzQyIN5UHCsd3D5PWdH9AcS1ppIPdoEH8zPrb7GvQiWrlzgMCoP2UZrrHOCrMpk0tPCVBzBKYmA3mxQJgKatAko71nltnlhBJsR3YydwqWmzhUFfxoOBAmkzKODAzHVb/efDj43w0wQwbaH142tALsP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 30, 2026 at 03:38:07PM +0800, Jinjiang Tu wrote:
> Here is a syzkaller error log:
>   [0000000020ffc000] pgd=080000010598d403, p4d=080000010598d403, pud=0800000125ddb403,
>                      pmd=080000007833c403, pte=01608000007fcfcf
>   Unable to handle kernel read from unreadable memory at virtual address ffff80008ea89000
>   KASAN: probably user-memory-access in range [0x0000000475448000-0x0000000475448007]
>   Mem abort info:
>     ESR = 0x000000009600000f
>     EC = 0x25: DABT (current EL), IL = 32 bits
>     SET = 0, FnV = 0
>     EA = 0, S1PTW = 0
>     FSC = 0x0f: level 3 permission fault
>   Data abort info:
>     ISV = 0, ISS = 0x0000000f, ISS2 = 0x00000000
>     CM = 0, WnR = 0, TnD = 0, TagAccess = 0
>     GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
>   swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000001244aa000
>   [ffff80008ea89000] pgd=100000013ffff403, p4d=100000013ffff403, pud=100000013fffe403,
> 		     pmd=100000010a453403, pte=01608000007fcfcf
>   Internal error: Oops: 000000009600000f [#1] SMP
>   Modules linked in: team
>   CPU: 1 PID: 10840 Comm: syz.9.83 Kdump: loaded Tainted: G
>   Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
>   pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>   pc : __memcpy_fromio+0x80/0xf8
>   lr : generic_access_phys+0x20c/0x2b8
>   sp : ffff8000a0507960
>   x29: ffff8000a0507960 x28: 1ffff000140a0f44 x27: ffff00003833cfe0
>   x26: 0000000000000000 x25: 0000000000001000 x24: 0010000000000001
>   x23: ffff80008ea89000 x22: ffff00004ea63000 x21: 0000000000001000
>   x20: ffff80008ea89000 x19: ffff00004ea62000 x18: 0000000000000000
>   x17: 0000000000000000 x16: 0000000000000000 x15: ffff8000806f1e3c
>   x14: ffff8000806f1d44 x13: 0000000041b58ab3 x12: ffff7000140a0f23
>   x11: 1ffff000140a0f22 x10: ffff7000140a0f22 x9 : ffff800080579d24
>   x8 : 0000000000000004 x7 : 0000000000000003 x6 : 0000000000000001
>   x5 : ffff8000a0507910 x4 : ffff7000140a0f22 x3 : dfff800000000000
>   x2 : 0000000000001000 x1 : ffff80008ea89000 x0 : ffff00004ea62000
>   Call trace:
>     __memcpy_fromio+0x80/0xf8
>     generic_access_phys+0x20c/0x2b8
>     __access_remote_vm+0x46c/0x5b8
>     access_remote_vm+0x18/0x30
>     environ_read+0x238/0x3e8
>     vfs_read+0xe4/0x2b0
>     ksys_read+0xcc/0x178
>     __arm64_sys_read+0x4c/0x68
>     invoke_syscall+0x68/0x1a0
>     el0_svc_common.constprop.0+0x11c/0x150
>     do_el0_svc+0x38/0x50
>     el0_svc+0x50/0x258
>     el0t_64_sync_handler+0xc0/0xc8
>     el0t_64_sync+0x1a4/0x1a8
>   Code: 91002339 aa1403f7 8b190276 d503201f (f94002f8)
> 
> The local syzkaller first maps I/O address from /dev/mem to userspace,
> overiding the stack vma with MAP_FIXED flag. As a result, when reading
> /proc/$pid/environ, generic_access_phys() is called to access the region,
> which triggers a PAN permission-check fault and causes a kernel access
> fault.
> 
> The root cause is that generic_access_phys() passes a user pte to
> ioremap_prot(), the user pte sets PTE_USER and PTE_NG bits.  Consequently,
> any subsequent kernel-mode access to the remapped address raises a fault.
> 
> To fix it, define arch_mk_kernel_prot() to convert user prot to kernel
> prot for arm64, and call arch_mk_kernel_prot() in generic_access_phys(),
> so that a user prot is passed to ioremap_prot().
> 
> Fixes: 893dea9ccd08 ("arm64: Add HAVE_IOREMAP_PROT support")
> Signed-off-by: Zeng Heng <zengheng4@huawei.com>
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> ---
> Changes in v3:
>  * arch_mk_kernel_prot() always grant read/write permissions.
> 
>  arch/arm64/include/asm/io.h |  8 ++++++++
>  mm/memory.c                 | 12 +++++++++++-
>  2 files changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
> index 83e03abbb2ca..fe3040d59119 100644
> --- a/arch/arm64/include/asm/io.h
> +++ b/arch/arm64/include/asm/io.h
> @@ -267,6 +267,14 @@ int arm64_ioremap_prot_hook_register(const ioremap_prot_hook_t hook);
>  
>  #define ioremap_prot ioremap_prot
>  
> +#define arch_mk_kernel_prot arch_mk_kernel_prot
> +static inline pgprot_t arch_mk_kernel_prot(pgprot_t user_prot)
> +{
> +	ptdesc_t mem_type = pgprot_val(user_prot) & PTE_ATTRINDX_MASK;
> +
> +	return __pgprot_modify(PAGE_KERNEL, PTE_ATTRINDX_MASK, mem_type);
> +}

Do we really need another arch helper here?

It looks to me like generic_access_phys() is the only caller of
ioremap_prot() outside of arch/, so why not just handle the user_prot in
there on arm64? You could rename the existing ioremap_prot() function in
arch/arm64/mm/ioremap.c to e.g. __ioremap_prot(), switch over the
callers in arch/arm64 and then add ioremap_prot() to wrap that with your
pgprot modification above.

Will

