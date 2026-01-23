Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3088D778AE
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 18:36:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 215A76B0534; Fri, 23 Jan 2026 13:36:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ED9C6B0536; Fri, 23 Jan 2026 13:36:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 116E06B0537; Fri, 23 Jan 2026 13:36:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 010806B0534
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 13:36:15 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A5845B9D1E
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 18:36:15 +0000 (UTC)
X-FDA: 84364083510.05.5C02F7C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7C235C0004
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 18:36:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769193374; a=rsa-sha256;
	cv=none;
	b=BKQy9LBbTA1lOGKfSy2IA0hzkPxzIo2yBwhUqvxTUNgMLiyJ7O3FQggX/MYSU1Dbxnk7NV
	8oPKUneltVRVrA9QCM6SQ5GF6uP2UFz1jPWbKV8ckEC3YazdCTzuBerQkBABksyvFELrF+
	ovWsy9Yh5L185H9tgtpItRHzfCDtBlk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769193374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=arKGCctrdsfQGPyMUlAxQ2/8+tmzN8yfWV9Z3XZP5U0=;
	b=hmNVWjGG58BnAwdlxTN+NCRDtVTCXiWd8GitOg6kW+kP4tQPlSL1d3gkuY8wdSMVpKaOR/
	xjJRmH6eB00oyUaiu76xIzaV3R2GXIYF9ixmi+Iiiq1pH0R+HSY4DvOakYiRg2+m9/ofdU
	UJT17k/nvcb+qbIZmsYAD2Zu1LfET9Y=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CBA081476;
	Fri, 23 Jan 2026 10:36:05 -0800 (PST)
Received: from arm.com (arrakis.cambridge.arm.com [10.1.197.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 802393F694;
	Fri, 23 Jan 2026 10:36:10 -0800 (PST)
Date: Fri, 23 Jan 2026 18:36:07 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: akpm@linux-foundation.org, david@kernel.org, will@kernel.org,
	zengheng4@huawei.com, ryan.roberts@arm.com,
	anshuman.khandual@arm.com, wangkefeng.wang@huawei.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH] arm64: mm: explicitly use kernel pte for ioremap_prot()
Message-ID: <aXO_l_4OrC7Ja4rP@arm.com>
References: <20260123030238.835748-1-tujinjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123030238.835748-1-tujinjiang@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7C235C0004
X-Stat-Signature: dpr7rb1yen6d1m93c9rkkd8ieqip6xht
X-HE-Tag: 1769193373-345921
X-HE-Meta: U2FsdGVkX1+Lem8HiPwNP/vQa7MCfFAl7052ERjLDteqSkn6Tney7xRJJzzjEFg54HZFtRvffSjXj5+iWfEeB0uTlQS5w6ilmBbzYMZKtd5J/SIp66vyhWxj9RXpJP3KB/j7SR8LgXLoMCqC25QbU8R+X7Zrhe4/x++qFqzlwUisIBwkTnwPqpTykutszy/w49BIV8cvnaH32jTXtWLuz5brcJvP++8qjbhSR6FqMgBRvXJw4TedVzJDq+mno2Nq331AySlJruTBJGb/5ZsqzWMcykPTsu+mnD5+gXH7KHtdeq05gmvHBzzWckiVqffQt6psAP3WCCy3mVccXuke/3OFrtOO2RhZjYne2zyAzE0BMdK7vv5aq35BLWo4ZJTbFl9XpTyBDCC2edIaMZndX+NdlDs7wUc6TNSZfaPzOpMbSmDQICTCt3z2YAIsg9nNDJ+U47ULzpD2PEfdctDLdK63BFqY315O2BiGmD2G2ue3MniSxkxSj5/HF5CnSjdQa4MAJrWcXBRrW9HAI8lIeDB3QC/s4WIOjED9wbkoPBZRgtazs2V/8yD60Lp1jATWQYsnF9k0BuueNkVWPMYNFH+eCDLrlYBSd3IvGD5N0cdNr83En6Jot4VyF9p1eVQn+KNWAW1mS+q/vs1dJcniHVfuxRrzOq1N8lnvgxZ4uyP0oJ0pMhrMX7tn8wNhOD0gnvjQaioxHSwU3oAq+GuFgQP8k2j+kc+EjqyRXRAHylceIiBb2xcJtPoWtQ4sL0zgrhgCsSuf8tiav4Gx+Z0MxUo7b099CwQ8KhxY6tl5i+HPAWWJjzCXM7jiO+UhS3pLPs4AWpQQ4RPJMF/BMr05I4STopNdbMzjP8N3RdxR9rNbm+mwe+YxIjHBXZts95jyug1JrYWMBrNSN/HjXPEDAPvTTA2BnC3zIdcAmWgwkYvniR8dg5mv/Zv6PW9fIeXQtA9l5zjANxm9EW1bzbH
 L2sv1giW
 w1Ch/u9HaiN+nZNUYG3Y9adUznw5WU2Vapubtbw01EeFtR9BtNzYa8yu7Dzi2I32BVp2WBWNAU15xRxKP1whDlta0rZzGeg8CoAgRKs9Ba69hgdhSObjLkf92CrvB4hEtxlGt7OKhU4cGXmcHeZDlXbS93Gwqn7g+3dmaEEnTKtN3Sbdz/VycKgiIuUW2UVThBQk3lvceGHQQ0t6HdTLJBWVcIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 11:02:38AM +0800, Jinjiang Tu wrote:
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
> To fix it, similar to ioremap_prot() in x86, use _PAGE_KERNEL as template,
> and update PTE_WRITE and PTE_ATTRINDX according to the pgprot argument.
> 
> Fixes: 893dea9ccd08 ("arm64: Add HAVE_IOREMAP_PROT support")
> Signed-off-by: Zeng Heng <zengheng4@huawei.com>
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> ---
>  arch/arm64/mm/ioremap.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
> index 10e246f11271..78a63a14465f 100644
> --- a/arch/arm64/mm/ioremap.c
> +++ b/arch/arm64/mm/ioremap.c
> @@ -18,6 +18,7 @@ void __iomem *ioremap_prot(phys_addr_t phys_addr, size_t size,
>  			   pgprot_t pgprot)
>  {
>  	unsigned long last_addr = phys_addr + size - 1;
> +	unsigned long new_pgprot_val;
>  
>  	/* Don't allow outside PHYS_MASK */
>  	if (last_addr & ~PHYS_MASK)
> @@ -27,6 +28,11 @@ void __iomem *ioremap_prot(phys_addr_t phys_addr, size_t size,
>  	if (WARN_ON(pfn_is_map_memory(__phys_to_pfn(phys_addr))))
>  		return NULL;
>  
> +	new_pgprot_val = _PAGE_KERNEL & ~(PTE_WRITE | PTE_ATTRINDX_MASK);
> +	new_pgprot_val |= (pgprot_val(pgprot) & PTE_WRITE)
> +				| (pgprot_val(pgprot) & PTE_ATTRINDX_MASK);
> +	pgprot = __pgprot(new_pgprot_val);
> +
>  	/*
>  	 * If a hook is registered (e.g. for confidential computing
>  	 * purposes), call that now and barf if it fails.

generic_access_phys() is really weird - it takes the user PTE attributes
and passes them to the kernel ioremap_prot(), hoping for the best. My
immediate thought was to fix this in the core code. However, we also
need to preserve the original memory type from vma->vm_page_prot and I
don't think we have any generic macros to just preserve the attributes
but with kernel permissions (pte_mkkernel?).

-- 
Catalin

