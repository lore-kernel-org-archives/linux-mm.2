Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7928DD35687
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 07:13:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5453D6B0088; Wed, 28 Jan 2026 02:13:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F2F06B0089; Wed, 28 Jan 2026 02:13:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CADC6B008A; Wed, 28 Jan 2026 02:13:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2971D6B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 02:13:08 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 61241C1D96
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 07:13:07 +0000 (UTC)
X-FDA: 84380506014.30.92E7179
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf01.hostedemail.com (Postfix) with ESMTP id 100F840006
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 07:13:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=GNnmKJXM;
	spf=pass (imf01.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769584385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lDrDHaxzPUqDOGHtSAjw8UIOY7PPSYbUnoNgzHvr5I0=;
	b=DOU4pk43tW8XGwHdvmoZ4FNkBoMMN+1j9+toa1ux69qbMeNVt0JOdwEVj6vA+P/CDMsc0g
	HQ2lBgvGj0gbgyuMxtnci/O9XMTP52KDvfY0PESSo3BRD6aOWnKtlFQ2ODKAAb+m974avg
	MPSGNRxWGiOe81cxkJ2ItXMOq/ZNGxI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=GNnmKJXM;
	spf=pass (imf01.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769584385; a=rsa-sha256;
	cv=none;
	b=4/6HuKxyY91Cd7VcE3WVvbWDHhvU8v4HpVRGwxv+jCqapEWt8pofLS8v0owha3+4nAodpA
	1qUQzJViHslxEwGF4rHZN8m2+/E8JQ5DtOn1n6zax3WfEUX7Sxh3NmwQUKH0TGWUYNZLKG
	aVcLE/PwLHhcEyYJFhwAQ5uZOgBYCL4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=lDrDHaxzPUqDOGHtSAjw8UIOY7PPSYbUnoNgzHvr5I0=;
	b=GNnmKJXMOHfYxhNgVBD7aQXjjtZO1CwYmiFKicdhYA6iwUIQjplxkGPLDZ4VvWG0Au+0kgJ/6
	3bLirJmYGft9AUlO4U5m2sXFWL3IYjb1AgWi1zrTFAJ+M5YnT1v5GjvmtbE3GozIddRJ9kXs2Vk
	cBVcPYqEiLnA567zo+XIgzo=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4f1D0H4cJyz12LDP;
	Wed, 28 Jan 2026 15:09:03 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id E85124056C;
	Wed, 28 Jan 2026 15:12:57 +0800 (CST)
Received: from [10.174.179.179] (10.174.179.179) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 28 Jan 2026 15:12:57 +0800
Message-ID: <c78b76c5-8709-44d0-85c3-feccd41b2ddd@huawei.com>
Date: Wed, 28 Jan 2026 15:12:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] arm64: mm: fix pass user prot to ioremap_prot in
 generic_access_phys
To: <akpm@linux-foundation.org>, <david@kernel.org>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <zengheng4@huawei.com>,
	<ryan.roberts@arm.com>, <anshuman.khandual@arm.com>,
	<wangkefeng.wang@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mm@kvack.org>
References: <20260127090129.412084-1-tujinjiang@huawei.com>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <20260127090129.412084-1-tujinjiang@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.179]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 100F840006
X-Stat-Signature: 1dw9aksaty5agf1mx3i6wb9pznbzmskz
X-Rspam-User: 
X-HE-Tag: 1769584383-41772
X-HE-Meta: U2FsdGVkX18roOjvZY9UT7TV1nEFJlyRCB4UBVSm/bPk/0bv5hpBoCO3NQKpC1XG0E3t4PeyoEkqz5S0iPFgGsUjrGdScvz4A6KWg35VMa5OaGG3mSZSy/4ymeLeNE74O3/2n3oXOQjpuEyhFYhss1Y+wcTZYQ/BVP1hZU5Yx5YXOivm/SibonX2QsUx+VqRcu81zP0dfUrbbg1XkFjgbmgiWKjDkl5AKRrs9+vgY6d27G8K/e/pT8olmbm9guCvH0TrqfdTtXCCw4ARZQqVvEcWop5zg7owHe8My2V6D4Ru+BW+4CLKHcke8SURWUQKO28hspmeZ53kvzQNx4sFBngpCqO7PM16TLGfGWEgOtQ5dR38ToK/d5cz9wKRJCHaeL9tYkiivsyLoaWubYRhwxI5sV2haSLIjDx6fHCxZWh4rN1TOmpATWL5u1022UQ15e2XxOr40c8xq3x6A4KD3B4zm9po4qSxrRfOylcFn10z+rlEOc3Vx3KiYK0rQC4nw6Yf6/UWY/3dkDl7PSN1lrMZNcXuaP1rNvaJFoWZUCtWV1uzhpZ5KN8Fl9+2uMvvZ4zbJf576TQ54vxbQwpdpyFG9WPvtSnkBsh/bpub+7MD1mjHaxDnCdiyIQ5E4GriJydi4rHG79U+nGK0fThNONxQ8R9uy7XrDQpV1BfO63CxQWSfPiqqt0vq9wDTejpkwCKbLayhNxZz/ew2BHfvSZQKTNF1umlSYRLx1T9/CrpCW23n/Mq/fsNpPTSwZ8QKKFNk87O4Lb5aB9X9sfoLNqSFgJrYyOQarV9f52D3sWjmvJdGOc/PcJt5pTulhmapCBBqBtsIWwAbZQX5C3sqNGIgwZ+emTBxGOc8pJoQVBpXIr6GeTjDT3977HQdJ3bVAcb46Ke5D4N2r0t8bhiav3WK1I+oAlF5BBoK3EsCGffszv+7XxBJ1TmihV+FJOAcHXw1XjCT/XG9ydslHqq
 ggpbfgaC
 W0Wd2Sw8aHwF3hE1nJtqX42osQpf2GcH8DtUHafC184JPcax94b7HoESXaKFtNH2900rssMs6K+w+TZvcEYAYGCLD6P3aah4qLdBQROV2CkPvmguyelYIPmBNTbCO0PZcZyJJgjPQBT5yW+pW0aF9yIvdyuAGvk5aAAmOrMlz9tT8cNuHVSwj8qTgWnOUw6O61MJW4tDLlGWOFgxK9OBlH5L+cytKv6m0ahp0dlBNYyyyLPrFXrcS2FSTp0FOoUCrZLIiluFNOnW9M6DHILnHSFR6YQgpziwwpd/qj7CzAGG3CgF/dNaDOUs4l24MQpx75+ryD+1IyC+jThA5G9quJCzOaaUkk8JqhFZRPpf4IJ0otU8BhP6BYXVN/vG9Fr9345hREMVUMXHRZ85ibiuS9qs/yPJz02lo3L5/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/1/27 17:01, Jinjiang Tu 写道:
> Here is a syzkaller error log:
>    [0000000020ffc000] pgd=080000010598d403, p4d=080000010598d403, pud=0800000125ddb403,
>                       pmd=080000007833c403, pte=01608000007fcfcf
>    Unable to handle kernel read from unreadable memory at virtual address ffff80008ea89000
>    KASAN: probably user-memory-access in range [0x0000000475448000-0x0000000475448007]
>    Mem abort info:
>      ESR = 0x000000009600000f
>      EC = 0x25: DABT (current EL), IL = 32 bits
>      SET = 0, FnV = 0
>      EA = 0, S1PTW = 0
>      FSC = 0x0f: level 3 permission fault
>    Data abort info:
>      ISV = 0, ISS = 0x0000000f, ISS2 = 0x00000000
>      CM = 0, WnR = 0, TnD = 0, TagAccess = 0
>      GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
>    swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000001244aa000
>    [ffff80008ea89000] pgd=100000013ffff403, p4d=100000013ffff403, pud=100000013fffe403,
> 		     pmd=100000010a453403, pte=01608000007fcfcf
>    Internal error: Oops: 000000009600000f [#1] SMP
>    Modules linked in: team
>    CPU: 1 PID: 10840 Comm: syz.9.83 Kdump: loaded Tainted: G
>    Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
>    pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>    pc : __memcpy_fromio+0x80/0xf8
>    lr : generic_access_phys+0x20c/0x2b8
>    sp : ffff8000a0507960
>    x29: ffff8000a0507960 x28: 1ffff000140a0f44 x27: ffff00003833cfe0
>    x26: 0000000000000000 x25: 0000000000001000 x24: 0010000000000001
>    x23: ffff80008ea89000 x22: ffff00004ea63000 x21: 0000000000001000
>    x20: ffff80008ea89000 x19: ffff00004ea62000 x18: 0000000000000000
>    x17: 0000000000000000 x16: 0000000000000000 x15: ffff8000806f1e3c
>    x14: ffff8000806f1d44 x13: 0000000041b58ab3 x12: ffff7000140a0f23
>    x11: 1ffff000140a0f22 x10: ffff7000140a0f22 x9 : ffff800080579d24
>    x8 : 0000000000000004 x7 : 0000000000000003 x6 : 0000000000000001
>    x5 : ffff8000a0507910 x4 : ffff7000140a0f22 x3 : dfff800000000000
>    x2 : 0000000000001000 x1 : ffff80008ea89000 x0 : ffff00004ea62000
>    Call trace:
>      __memcpy_fromio+0x80/0xf8
>      generic_access_phys+0x20c/0x2b8
>      __access_remote_vm+0x46c/0x5b8
>      access_remote_vm+0x18/0x30
>      environ_read+0x238/0x3e8
>      vfs_read+0xe4/0x2b0
>      ksys_read+0xcc/0x178
>      __arm64_sys_read+0x4c/0x68
>      invoke_syscall+0x68/0x1a0
>      el0_svc_common.constprop.0+0x11c/0x150
>      do_el0_svc+0x38/0x50
>      el0_svc+0x50/0x258
>      el0t_64_sync_handler+0xc0/0xc8
>      el0t_64_sync+0x1a4/0x1a8
>    Code: 91002339 aa1403f7 8b190276 d503201f (f94002f8)
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
> Change since v1:
>   * fix in ther caller generic_access_phys(), suggested by Catalin Marinas.
>
>   arch/arm64/include/asm/io.h | 11 +++++++++++
>   mm/memory.c                 | 12 +++++++++++-
>   2 files changed, 22 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
> index 83e03abbb2ca..fe8607eafab6 100644
> --- a/arch/arm64/include/asm/io.h
> +++ b/arch/arm64/include/asm/io.h
> @@ -267,6 +267,17 @@ int arm64_ioremap_prot_hook_register(const ioremap_prot_hook_t hook);
>   
>   #define ioremap_prot ioremap_prot
>   
> +#define arch_mk_kernel_prot arch_mk_kernel_prot
> +static inline pgprot_t arch_mk_kernel_prot(pgprot_t user_prot)
> +{
> +	unsigned long kernel_prot_val;
> +
> +	kernel_prot_val = _PAGE_KERNEL & ~(PTE_WRITE | PTE_ATTRINDX_MASK);
> +	kernel_prot_val |= pgprot_val(user_prot) & (PTE_WRITE | PTE_ATTRINDX_MASK);
> +
> +	return __pgprot(kernel_prot_val);
> +}

I found I misunderstand the READ/WRITE permisson here.
If the pte is writeale, the PTE_WRITE is 1, and PTE_RDONLY means dirty or not (With DBM).
If the pte is read-only, the PTE_WRITE is 0, and PTE_RDONLY is 1.

Since generic_access_phys() have checked if the user can write with:

		if ((write & FOLL_WRITE) && !pte_write(pte))
		return -EINVAL;

So, maybe we could always grant writable permission, just as x86's ioremap() does?

Thanks.

> +
>   #define _PAGE_IOREMAP PROT_DEVICE_nGnRE
>   
>   #define ioremap_wc(addr, size)	\
> diff --git a/mm/memory.c b/mm/memory.c
> index da360a6eb8a4..68fcfc3bbad8 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -6836,6 +6836,14 @@ void follow_pfnmap_end(struct follow_pfnmap_args *args)
>   EXPORT_SYMBOL_GPL(follow_pfnmap_end);
>   
>   #ifdef CONFIG_HAVE_IOREMAP_PROT
> +#ifndef arch_mk_kernel_prot
> +#define arch_mk_kernel_prot arch_mk_kernel_prot
> +static inline pgprot_t arch_mk_kernel_prot(pgprot_t user_prot)
> +{
> +	return user_prot;
> +}
> +#endif
> +
>   /**
>    * generic_access_phys - generic implementation for iomem mmap access
>    * @vma: the vma to access
> @@ -6853,6 +6861,7 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
>   {
>   	resource_size_t phys_addr;
>   	pgprot_t prot = __pgprot(0);
> +	pgprot_t kernel_prot;
>   	void __iomem *maddr;
>   	int offset = offset_in_page(addr);
>   	int ret = -EINVAL;
> @@ -6870,7 +6879,8 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
>   	if ((write & FOLL_WRITE) && !writable)
>   		return -EINVAL;
>   
> -	maddr = ioremap_prot(phys_addr, PAGE_ALIGN(len + offset), prot);
> +	kernel_prot = arch_mk_kernel_prot(prot);
> +	maddr = ioremap_prot(phys_addr, PAGE_ALIGN(len + offset), kernel_prot);
>   	if (!maddr)
>   		return -ENOMEM;
>   

