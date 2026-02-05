Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D8BFE91286
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 07:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DB326B009B; Thu,  5 Feb 2026 02:23:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 889186B009D; Thu,  5 Feb 2026 02:23:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7880A6B009E; Thu,  5 Feb 2026 02:23:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 64E026B009B
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 02:23:48 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 19F1E8B90F
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:23:48 +0000 (UTC)
X-FDA: 84409563336.06.ECE1F09
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9E54920007
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:23:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=57l68jqM;
	spf=pass (imf13.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770276226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+4ZyWEJCZVnnCnU2G1d0LGtTbJEdxRfOeb0l2J6dqAA=;
	b=8RQeXvkUADYFHqcLVjLL9fIPNkjcBBf2n0IsKSkSEjISc8fWE00b1yui4VFifWkbVL/Xg5
	dOTongRMv+jVaFpyEYtgiYEj9mC6LzWtp9s/7pGTDYFy5pwsTTIm4ZAWlizf7M/XLJuoTi
	YFqbC87ABXAWduNfCxZX9G+NJlNWmG0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=57l68jqM;
	spf=pass (imf13.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770276226; a=rsa-sha256;
	cv=none;
	b=u/jFNkuRfM2DTgoqeedhclg6yUbaQ0JafmgbdIx1feI8yxMsQyOXZJzB+G6yHMjRbw2nTd
	QMz5KIhNEvuwXKwv0MoBLaQrHfg8SRuTOEHlHSC+vhFTINkxNEE6etvXnmnyUmkMiAsh2T
	V39eebJuK6QuAeD0DHeW0dfakh2pZzo=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=+4ZyWEJCZVnnCnU2G1d0LGtTbJEdxRfOeb0l2J6dqAA=;
	b=57l68jqMmDAAFARIF7QD9ePiAbWm/6gmF1DOe9Qv5/n2NosZVn7Thm9/YwxkWYvgAWZbkZhvD
	HvRRVKeHNcZfpPcTiRoxBQWGcd0tU1IM/dLGXWqHVGDVyJE/ZdMY99VmUuUcA9Xa97ylggW1/so
	0btLtUJEvfZocNVr+FQgDzk=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4f67rL3hBMzcZym;
	Thu,  5 Feb 2026 15:19:14 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id B39C14056B;
	Thu,  5 Feb 2026 15:23:38 +0800 (CST)
Received: from [10.174.179.179] (10.174.179.179) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 5 Feb 2026 15:23:28 +0800
Message-ID: <a4ee7faa-5b0d-4ffa-bc06-939d95ef7680@huawei.com>
Date: Thu, 5 Feb 2026 15:23:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] arm64: mm: fix pass user prot to ioremap_prot in
 generic_access_phys
To: Will Deacon <will@kernel.org>
CC: <akpm@linux-foundation.org>, <david@kernel.org>,
	<catalin.marinas@arm.com>, <zengheng4@huawei.com>, <ryan.roberts@arm.com>,
	<anshuman.khandual@arm.com>, <wangkefeng.wang@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>
References: <20260130073807.99474-1-tujinjiang@huawei.com>
 <aYC6_lSm_eJeKIcn@willie-the-truck>
 <73396cda-e12c-484f-ab84-b09e7aab8bb0@huawei.com>
 <aYG-dGzR6MuPSQBK@willie-the-truck>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <aYG-dGzR6MuPSQBK@willie-the-truck>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.179]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9E54920007
X-Stat-Signature: nc3c8usm9znjz4zy1tgyy5w56rrqi5xa
X-Rspam-User: 
X-HE-Tag: 1770276224-982433
X-HE-Meta: U2FsdGVkX1+T+Wxxo/7P/s7ADCqzwPgICinEVlS8SBeUabhc1w0qtKDxJZRP3isq9sb8OTKSIjR5VReFGifFdy+axlrSIJ6gkJyj6B/fLy+s34FNYVbGgBL9GqRVOVfucZ+vjRnGDnFcFiH2iTX20BbbeCky3ahMjHBsLEtvcXA1o1FactfD/yqoSTxpU5iwzdRU6S7mse3qBdla1O/uBWKbMgb1RWoBS/+0nHtQTOrONy+qXiSY/nIrzaQPQzvUEJFc78PYNsgqoKAFvCMiqlFhyCu2V+tSKQU6awuckYX72moXkX1gOeaKLXSMxaKUzLv3MNnssvTR3GKPuiUyNwN98Q+Ddlj6ZZL1R2x1x18zM/Nvmfly3Ew9GSI2ETyazkxjAEanJfRXh7tO2db5uvm13Rl1ubaqlGaqFgXkIo3UklWGSdZUbmoeltZC07fQJBis3LISaiA3tRpIQxlOQstmMX4CZIfuIYyfBEbc0MHq+Afu4sX84g5M/O+rbvLzssCf5I8kyAAL0peREwkLhYCxQmnjVd/EkV4RBYnQ/eV1fi7RgmcWnrd4b70BoAX0YZEHyNI3pvPtEPrZ8aEpLw970XmziYIHyvWvBfTD1ljSC2QtpVR2IKM42K3yD5Zq1YH0+G0HK0yI4LtSnIGIYevK4prsXYyNLO+CV2nexGQsA+43IW/CjPQoAptf7Ff/DTBaCLYcWOCINlid0R/0F1/otMMQIkY4zrd0pKoPm0m+amKM4oppStewHZuvlY4yj+q7sZrb0XLs5D5TTh9WD9LTIxBl5usZTD3cdJD8JCAsvwCNFFBAXJPL304/QKFk+K9DwxPWS4/AZFS+yv9ZjpmqG8zfaEA7oRo4nh9EzlhmIHkhzJyYBViYhW6VylG6QmOK/E5V9BeZff5S073BeT1lYTmUdrzPoNrHFaPqWb3USuT3DLSPlqpuBXCfVfUajMbJrjYNnM+NkKj4Hbn
 xX+/AF+O
 9k8/ixr8wTdSoIBTW3aHtlSBYH0DuYbDL1xAsbaWVTTKSQKk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/2/3 17:23, Will Deacon 写道:
> On Tue, Feb 03, 2026 at 11:38:15AM +0800, Jinjiang Tu wrote:
>> 在 2026/2/2 22:55, Will Deacon 写道:
>>> On Fri, Jan 30, 2026 at 03:38:07PM +0800, Jinjiang Tu wrote:
>>>> Here is a syzkaller error log:
>>>>     [0000000020ffc000] pgd=080000010598d403, p4d=080000010598d403, pud=0800000125ddb403,
>>>>                        pmd=080000007833c403, pte=01608000007fcfcf
>>>>     Unable to handle kernel read from unreadable memory at virtual address ffff80008ea89000
>>>>     KASAN: probably user-memory-access in range [0x0000000475448000-0x0000000475448007]
>>>>     Mem abort info:
>>>>       ESR = 0x000000009600000f
>>>>       EC = 0x25: DABT (current EL), IL = 32 bits
>>>>       SET = 0, FnV = 0
>>>>       EA = 0, S1PTW = 0
>>>>       FSC = 0x0f: level 3 permission fault
>>>>     Data abort info:
>>>>       ISV = 0, ISS = 0x0000000f, ISS2 = 0x00000000
>>>>       CM = 0, WnR = 0, TnD = 0, TagAccess = 0
>>>>       GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
>>>>     swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000001244aa000
>>>>     [ffff80008ea89000] pgd=100000013ffff403, p4d=100000013ffff403, pud=100000013fffe403,
>>>> 		     pmd=100000010a453403, pte=01608000007fcfcf
>>>>     Internal error: Oops: 000000009600000f [#1] SMP
>>>>     Modules linked in: team
>>>>     CPU: 1 PID: 10840 Comm: syz.9.83 Kdump: loaded Tainted: G
>>>>     Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
>>>>     pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>>>>     pc : __memcpy_fromio+0x80/0xf8
>>>>     lr : generic_access_phys+0x20c/0x2b8
>>>>     sp : ffff8000a0507960
>>>>     x29: ffff8000a0507960 x28: 1ffff000140a0f44 x27: ffff00003833cfe0
>>>>     x26: 0000000000000000 x25: 0000000000001000 x24: 0010000000000001
>>>>     x23: ffff80008ea89000 x22: ffff00004ea63000 x21: 0000000000001000
>>>>     x20: ffff80008ea89000 x19: ffff00004ea62000 x18: 0000000000000000
>>>>     x17: 0000000000000000 x16: 0000000000000000 x15: ffff8000806f1e3c
>>>>     x14: ffff8000806f1d44 x13: 0000000041b58ab3 x12: ffff7000140a0f23
>>>>     x11: 1ffff000140a0f22 x10: ffff7000140a0f22 x9 : ffff800080579d24
>>>>     x8 : 0000000000000004 x7 : 0000000000000003 x6 : 0000000000000001
>>>>     x5 : ffff8000a0507910 x4 : ffff7000140a0f22 x3 : dfff800000000000
>>>>     x2 : 0000000000001000 x1 : ffff80008ea89000 x0 : ffff00004ea62000
>>>>     Call trace:
>>>>       __memcpy_fromio+0x80/0xf8
>>>>       generic_access_phys+0x20c/0x2b8
>>>>       __access_remote_vm+0x46c/0x5b8
>>>>       access_remote_vm+0x18/0x30
>>>>       environ_read+0x238/0x3e8
>>>>       vfs_read+0xe4/0x2b0
>>>>       ksys_read+0xcc/0x178
>>>>       __arm64_sys_read+0x4c/0x68
>>>>       invoke_syscall+0x68/0x1a0
>>>>       el0_svc_common.constprop.0+0x11c/0x150
>>>>       do_el0_svc+0x38/0x50
>>>>       el0_svc+0x50/0x258
>>>>       el0t_64_sync_handler+0xc0/0xc8
>>>>       el0t_64_sync+0x1a4/0x1a8
>>>>     Code: 91002339 aa1403f7 8b190276 d503201f (f94002f8)
>>>>
>>>> The local syzkaller first maps I/O address from /dev/mem to userspace,
>>>> overiding the stack vma with MAP_FIXED flag. As a result, when reading
>>>> /proc/$pid/environ, generic_access_phys() is called to access the region,
>>>> which triggers a PAN permission-check fault and causes a kernel access
>>>> fault.
>>>>
>>>> The root cause is that generic_access_phys() passes a user pte to
>>>> ioremap_prot(), the user pte sets PTE_USER and PTE_NG bits.  Consequently,
>>>> any subsequent kernel-mode access to the remapped address raises a fault.
>>>>
>>>> To fix it, define arch_mk_kernel_prot() to convert user prot to kernel
>>>> prot for arm64, and call arch_mk_kernel_prot() in generic_access_phys(),
>>>> so that a user prot is passed to ioremap_prot().
>>>>
>>>> Fixes: 893dea9ccd08 ("arm64: Add HAVE_IOREMAP_PROT support")
>>>> Signed-off-by: Zeng Heng <zengheng4@huawei.com>
>>>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
>>>> ---
>>>> Changes in v3:
>>>>    * arch_mk_kernel_prot() always grant read/write permissions.
>>>>
>>>>    arch/arm64/include/asm/io.h |  8 ++++++++
>>>>    mm/memory.c                 | 12 +++++++++++-
>>>>    2 files changed, 19 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
>>>> index 83e03abbb2ca..fe3040d59119 100644
>>>> --- a/arch/arm64/include/asm/io.h
>>>> +++ b/arch/arm64/include/asm/io.h
>>>> @@ -267,6 +267,14 @@ int arm64_ioremap_prot_hook_register(const ioremap_prot_hook_t hook);
>>>>    #define ioremap_prot ioremap_prot
>>>> +#define arch_mk_kernel_prot arch_mk_kernel_prot
>>>> +static inline pgprot_t arch_mk_kernel_prot(pgprot_t user_prot)
>>>> +{
>>>> +	ptdesc_t mem_type = pgprot_val(user_prot) & PTE_ATTRINDX_MASK;
>>>> +
>>>> +	return __pgprot_modify(PAGE_KERNEL, PTE_ATTRINDX_MASK, mem_type);
>>>> +}
>>> Do we really need another arch helper here?
>> For arc, powerpc, ioremap_prot() simply copy the user pte prot to the kernel page table too.
>> So maybe we should fix for the two archs too, and we should define a arch helper here.
>> But I'm not familiar with them.
> My point is that we already have the helper: ioremap_prot(). Just fix
> that for arm64 and cc the other arch maintainers if you're not sure how
> to fix it for them. What we don't need to do is add an additional helper.
>
ioremap_prot() may be called outside of arch/arm64 in the future, and I think
most of the cases will not pass a user prot to ioremap_prot().

generic_access_phys() is a special case, so I want to limit the modification to
generic_access_phys() only.

Thanks.

> Will
>

