Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEC90E83040
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 03:38:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D8806B0089; Mon,  2 Feb 2026 22:38:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2861D6B008A; Mon,  2 Feb 2026 22:38:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 188986B008C; Mon,  2 Feb 2026 22:38:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0AC876B0089
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 22:38:26 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B365F1B199B
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 03:38:25 +0000 (UTC)
X-FDA: 84401737770.16.2688F4F
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9130E160007
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 03:38:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=zf4P8Dyu;
	spf=pass (imf08.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770089903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JBdPoj2+HTmrKW4e6vdspgu4vRZAKT7n22gI789mTZM=;
	b=OfQFjeeVHLsbau7BFE5v7Yt4Pw92GlG9Nz5esYxRZjjdqrK4NVsAp6ne/a8/N8FuAO7XxZ
	wP5sO8eKpcB+pSbi9hSdNmcpKYekKnWkKwXBtvlYbL1rP7tInA7Yote3u5NjO1Lfyr7cb3
	Zn5VQCEkfN2ITZpBAMm/TvghDsy/f2M=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=zf4P8Dyu;
	spf=pass (imf08.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770089903; a=rsa-sha256;
	cv=none;
	b=ZSngTVFvlgm7i8klNDoCyIN1tAhBCqMnURXSpiytz93GDeNBG6GgprMVpVGxPfCl2V+5xe
	b43VidAE2Ibqng/CUfBvaxQzkrR0RIckKhZshdjocsWFSC+YDI315VzA37ScoHSeYy/Zt2
	rFTf3233XCDvgWEZfO6SlF0AiqVC8d8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=JBdPoj2+HTmrKW4e6vdspgu4vRZAKT7n22gI789mTZM=;
	b=zf4P8DyuSu3XxqPvZKd8/t4zieN4Y9CNKMCEczQn11hJG0D10slAo+QfOYMpOhNrS32Nd1oJw
	nD6d2STIlHW5BGDdvcvoS+QShyBVocXBvmDNXVXc1A/Ca21dZIT7OJG9rA7JhXW6B70GcteQ53g
	nG6jnpyvBgSQfxvvCwwRdXc=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4f4pxX3kNnzpSvN;
	Tue,  3 Feb 2026 11:34:08 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id EEB0F40363;
	Tue,  3 Feb 2026 11:38:16 +0800 (CST)
Received: from [10.174.179.179] (10.174.179.179) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 3 Feb 2026 11:38:16 +0800
Message-ID: <73396cda-e12c-484f-ab84-b09e7aab8bb0@huawei.com>
Date: Tue, 3 Feb 2026 11:38:15 +0800
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
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <aYC6_lSm_eJeKIcn@willie-the-truck>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.179]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9130E160007
X-Stat-Signature: ciisp5nyyjb1amc7fj6w6fs4wfdnukbn
X-Rspam-User: 
X-HE-Tag: 1770089902-634627
X-HE-Meta: U2FsdGVkX1/H50jCA4pyY1Ed/vYrFT3U79WKgQS/hwbSx2nD8k/LvyivBFoyEZZUDbNS94FK4wfuXVhSAQ4KYCfqgd/smYBUsKDknSPRiN1ulLs+m33ACRBcAwhYX7I1mQczirlGTAn6n5BqcHQtvDGWhtFNZ2pLGWGfkb5N8rJ/gZ0rcA80KvFNvok5zoENF51sjNwpSo1KHWL2JZAtUOo8L5kfQZSrDwzBB/DMSdecdEcD30AsPYXO1J7DGBKHkTFODa5pza+HPavq5TbuAsEsE+UiY85j2hXHYLqINOHMtInEgIJ/dYHKllY7C2JPPe3yyy94zCjEZDc4nhokjZQC+I/buW17PjmOnCmAibXfBsco/AzEPDLggJzlTUhui0sstint1EKlhSHocrpNvVedCcS4sdMQHoFc9zJ67i+HJmxnSyqLOLi62V9z5DglDMTimfsCHXGSWlUXvYjiKG4ml7EcHSermAPcSehYVRSmDgYZ6inK8OcrJyzKkk/hcXKlidTM4czFJLNsRpCAXoqbTEgrxk53JA6e4RTxDPYmHmZgIGr9HRQo2TKwoDaL0VcvuTU898ZzCWqkM7ZGBj2Q8UQSyru9IgBpP8eiP0lwOX48AtEAYz083Cp4mBuSNrsWpSm40NotSHCDWvXc1xflOT9env7ACUjWR8cACpqeNxuihac/LdUHxGI28qM10nwmZxl/yxHsFeFmU+2v3E+looouuy8WItEikbrjMp3KbHOUCQjtkNoJWsaFkgBsfQzeCTsg0j7GX5XlyUYN8Sycm+58TNl/inEPzdGjP6Ip30VFa87nEKrS4J7QQADlqe2jOYy8G+s2II6Pqq3CRwjJd/xtjw8l/uXGAcaWs8oYcMsU1mF38xklFPdqap3GyWnd+sGOOlaiVQ6CTgB+vnbZvJ9muJsOiOc4mZoiNYtFBb+0CCqplrqm5CKzh5Jg0KiF6iUEtWXE2pIOLvW
 2TQ1lVaL
 EnKglefrbqFM1RQW9OyitzCHI7M4Lt1zNPyz6DsybfUBOxHlKWD7HKmPe33/YyXRflcJAV2sx3yRfrCQKlAhdibjcUthXSEziN18152XfN8GGCJEBlvMD7ArGF95jl/zYqCXkxzMmGvnZaV5XPudSrZuNh2WexAu6bVVKIHuVEU0ejW0d8DAWpuVu6zfWIJ5mTyPSxd5HFE+UR3opAPBJQRlw/FZ+nEDbVkLQdfcGiVemFKEXpW2v5y0RZjHKdK3/ABWdlEXeq2ppG0QSvScWi/U/wKbyn1MSc+SwwdNYlc/julBwNA/iJ+gN7fdql2FVTMhrgetNuTyFEUill+lvzSrhqJuRn2eKemqbkFZULqR4wa0VFe5v4WV6HQbAjSO4L9JOpE2arkqezg9MrA4/uXRpPsld/+5vb5YA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/2/2 22:55, Will Deacon 写道:
> On Fri, Jan 30, 2026 at 03:38:07PM +0800, Jinjiang Tu wrote:
>> Here is a syzkaller error log:
>>    [0000000020ffc000] pgd=080000010598d403, p4d=080000010598d403, pud=0800000125ddb403,
>>                       pmd=080000007833c403, pte=01608000007fcfcf
>>    Unable to handle kernel read from unreadable memory at virtual address ffff80008ea89000
>>    KASAN: probably user-memory-access in range [0x0000000475448000-0x0000000475448007]
>>    Mem abort info:
>>      ESR = 0x000000009600000f
>>      EC = 0x25: DABT (current EL), IL = 32 bits
>>      SET = 0, FnV = 0
>>      EA = 0, S1PTW = 0
>>      FSC = 0x0f: level 3 permission fault
>>    Data abort info:
>>      ISV = 0, ISS = 0x0000000f, ISS2 = 0x00000000
>>      CM = 0, WnR = 0, TnD = 0, TagAccess = 0
>>      GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
>>    swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000001244aa000
>>    [ffff80008ea89000] pgd=100000013ffff403, p4d=100000013ffff403, pud=100000013fffe403,
>> 		     pmd=100000010a453403, pte=01608000007fcfcf
>>    Internal error: Oops: 000000009600000f [#1] SMP
>>    Modules linked in: team
>>    CPU: 1 PID: 10840 Comm: syz.9.83 Kdump: loaded Tainted: G
>>    Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
>>    pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>>    pc : __memcpy_fromio+0x80/0xf8
>>    lr : generic_access_phys+0x20c/0x2b8
>>    sp : ffff8000a0507960
>>    x29: ffff8000a0507960 x28: 1ffff000140a0f44 x27: ffff00003833cfe0
>>    x26: 0000000000000000 x25: 0000000000001000 x24: 0010000000000001
>>    x23: ffff80008ea89000 x22: ffff00004ea63000 x21: 0000000000001000
>>    x20: ffff80008ea89000 x19: ffff00004ea62000 x18: 0000000000000000
>>    x17: 0000000000000000 x16: 0000000000000000 x15: ffff8000806f1e3c
>>    x14: ffff8000806f1d44 x13: 0000000041b58ab3 x12: ffff7000140a0f23
>>    x11: 1ffff000140a0f22 x10: ffff7000140a0f22 x9 : ffff800080579d24
>>    x8 : 0000000000000004 x7 : 0000000000000003 x6 : 0000000000000001
>>    x5 : ffff8000a0507910 x4 : ffff7000140a0f22 x3 : dfff800000000000
>>    x2 : 0000000000001000 x1 : ffff80008ea89000 x0 : ffff00004ea62000
>>    Call trace:
>>      __memcpy_fromio+0x80/0xf8
>>      generic_access_phys+0x20c/0x2b8
>>      __access_remote_vm+0x46c/0x5b8
>>      access_remote_vm+0x18/0x30
>>      environ_read+0x238/0x3e8
>>      vfs_read+0xe4/0x2b0
>>      ksys_read+0xcc/0x178
>>      __arm64_sys_read+0x4c/0x68
>>      invoke_syscall+0x68/0x1a0
>>      el0_svc_common.constprop.0+0x11c/0x150
>>      do_el0_svc+0x38/0x50
>>      el0_svc+0x50/0x258
>>      el0t_64_sync_handler+0xc0/0xc8
>>      el0t_64_sync+0x1a4/0x1a8
>>    Code: 91002339 aa1403f7 8b190276 d503201f (f94002f8)
>>
>> The local syzkaller first maps I/O address from /dev/mem to userspace,
>> overiding the stack vma with MAP_FIXED flag. As a result, when reading
>> /proc/$pid/environ, generic_access_phys() is called to access the region,
>> which triggers a PAN permission-check fault and causes a kernel access
>> fault.
>>
>> The root cause is that generic_access_phys() passes a user pte to
>> ioremap_prot(), the user pte sets PTE_USER and PTE_NG bits.  Consequently,
>> any subsequent kernel-mode access to the remapped address raises a fault.
>>
>> To fix it, define arch_mk_kernel_prot() to convert user prot to kernel
>> prot for arm64, and call arch_mk_kernel_prot() in generic_access_phys(),
>> so that a user prot is passed to ioremap_prot().
>>
>> Fixes: 893dea9ccd08 ("arm64: Add HAVE_IOREMAP_PROT support")
>> Signed-off-by: Zeng Heng <zengheng4@huawei.com>
>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
>> ---
>> Changes in v3:
>>   * arch_mk_kernel_prot() always grant read/write permissions.
>>
>>   arch/arm64/include/asm/io.h |  8 ++++++++
>>   mm/memory.c                 | 12 +++++++++++-
>>   2 files changed, 19 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
>> index 83e03abbb2ca..fe3040d59119 100644
>> --- a/arch/arm64/include/asm/io.h
>> +++ b/arch/arm64/include/asm/io.h
>> @@ -267,6 +267,14 @@ int arm64_ioremap_prot_hook_register(const ioremap_prot_hook_t hook);
>>   
>>   #define ioremap_prot ioremap_prot
>>   
>> +#define arch_mk_kernel_prot arch_mk_kernel_prot
>> +static inline pgprot_t arch_mk_kernel_prot(pgprot_t user_prot)
>> +{
>> +	ptdesc_t mem_type = pgprot_val(user_prot) & PTE_ATTRINDX_MASK;
>> +
>> +	return __pgprot_modify(PAGE_KERNEL, PTE_ATTRINDX_MASK, mem_type);
>> +}
> Do we really need another arch helper here?

For arc, powerpc, ioremap_prot() simply copy the user pte prot to the kernel page table too.
So maybe we should fix for the two archs too, and we should define a arch helper here.
But I'm not familiar with them.

>
> It looks to me like generic_access_phys() is the only caller of
> ioremap_prot() outside of arch/, so why not just handle the user_prot in
> there on arm64? You could rename the existing ioremap_prot() function in
> arch/arm64/mm/ioremap.c to e.g. __ioremap_prot(), switch over the
> callers in arch/arm64 and then add ioremap_prot() to wrap that with your
> pgprot modification above.
>
> Will
>

