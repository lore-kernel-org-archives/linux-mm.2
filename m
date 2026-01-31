Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68A16D49C9E
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 00:07:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABCEE6B0088; Fri, 30 Jan 2026 19:07:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6A5D6B0089; Fri, 30 Jan 2026 19:07:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A1446B008A; Fri, 30 Jan 2026 19:07:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 887886B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 19:07:21 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 130A2D4DD2
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 00:07:21 +0000 (UTC)
X-FDA: 84390319482.10.7319486
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8E8E08000B
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 00:07:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=bIJp8YLZ;
	spf=pass (imf02.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769818039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QCmFZYREgs/er9Djalkcfhh47qOu8UcVA/CPfSzXbQw=;
	b=UUrYf+z2wxfX9toz2BkPMkzbayEDr/vkfV80BXLJqyXXII9DSXgisxTVVIO6UcBuL4Hpv7
	YUQQ6rOIhN/QUkeUyxdCghX8//gGmv9KRNK51/+AsKaKMhB5jQ0ZeKH5vUhqwCg9MSH6+m
	p0ZckHMVZq4r3RA5kKeVGSlADsMd/gw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=bIJp8YLZ;
	spf=pass (imf02.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769818039; a=rsa-sha256;
	cv=none;
	b=l83I9O8X3J2VgGF3QwYIspXNGLT+UHFonshV9o4n9qgKGzWXPx5oN/ifxIPfyRpvEJUaIm
	10h/2s7/zg0Ob0o4EwLTuQYn6Rw6JPBKOy+mYP1L5yyqvlHCtp4kbbuA7G/jFJpoSLc/Lk
	jQjsec/XIvjr4V830diYAdX2ckxHPV0=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=QCmFZYREgs/er9Djalkcfhh47qOu8UcVA/CPfSzXbQw=;
	b=bIJp8YLZaFP5HzqyokZHyEtZAhkP4lag2fMCxYwFRFUhACVHq5DdG8mTpz0LqDYLFfEAm/Fm5
	9vEZ9REuTZNJH+JQIifqlCAUzbcr7Yw/Jb94qJMh2LHyWzbnjKRd0BB80C9zhv7LFgB6Qym72hD
	8HC013GNI3v28+48su7la5k=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4f2tQ651QczmV6v;
	Sat, 31 Jan 2026 08:03:42 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id DD5DE4048B;
	Sat, 31 Jan 2026 08:07:12 +0800 (CST)
Received: from [10.174.179.179] (10.174.179.179) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 31 Jan 2026 08:07:12 +0800
Message-ID: <3ef69bc0-cec8-44ce-a93d-ebab275320a6@huawei.com>
Date: Sat, 31 Jan 2026 08:07:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] arm64: mm: fix pass user prot to ioremap_prot in
 generic_access_phys
To: Catalin Marinas <catalin.marinas@arm.com>
CC: <akpm@linux-foundation.org>, <david@kernel.org>, <will@kernel.org>,
	<zengheng4@huawei.com>, <ryan.roberts@arm.com>, <anshuman.khandual@arm.com>,
	<wangkefeng.wang@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mm@kvack.org>
References: <20260130073807.99474-1-tujinjiang@huawei.com>
 <aXyhuq_DOd2pC_Fo@arm.com>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <aXyhuq_DOd2pC_Fo@arm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.179]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam12
X-Stat-Signature: e5zj39etjcejdaohoqthd87p3bb8m35x
X-Rspamd-Queue-Id: 8E8E08000B
X-Rspam-User: 
X-HE-Tag: 1769818037-21227
X-HE-Meta: U2FsdGVkX1+6+6vZBLqsTZzQHmBgYukVWUOvgA9exmh5XAfy7iXKwlJJ7WLcrBDUC0g0misfujgizW+w3738BmuaFAxbtQj70MbgqsN9ycA3rmi74DN7vO4a2Da1hsZ8BdJdGl2ZfEjSBflMvkErQh+1JqUZK6JUAqnxem8W8OGNhMtX2L0griZjJgihz98cukMxhTTLMpeMXjFKc8Xkg3y9A6pkHcCRJeS9t7Kn13I1p6FF6WUwLQvX4x13wH2xsMRDFd5sfmgtMqHgdxWwQwnA1W2ATplkGmF6BRcHaKcsEuj+VP2kkPSxrnNjvxwhTP07f7IzhC132hhPuhsrb3dXAdaYO57zZj0UV4eivUCsZVocMB8ll9wZvNj2r1tAq0ixsogQ9MaSXRzFMqc1u7V/aImA5WAXvFcQ2HPBkMdUaGiFSbAQvR+2ilh+m4k5fzeUBHjc6K37QMApWWdUIzQ86qyUnq8vgS53UzEn3jCzbEv2vq3uGM+ul9FCq4XllJ+6Ej/HDz141aFt89rMeG6FI2SwFksDw1zrCvFJL8BPZ5hK5GfUdSxRHMJ996fOS4p8co5ENyxTIA6einsVY9EszbFJyplhxMM+EzQVsjhR9dtKMABJ2shrp10vXKZidmfigLjlP33vrwudFAK4OzavFrnQa++9PxjSiAQr0Vegm6aDG1gqHbuONmXriZXaoA8r3aT/TOZ/KSkL+3tinQ7E6pQ7YYYHB3U7/d6wowqEq4tS+MmlqfZn0tfAKrF9n0k1owr2tmoEM7qLNRRMz33rrGDtw2t4e55DxBLw2A+sH5I1I+M1bpyhXwBYNfaWp4eAUQE4+/Mkq2WIdx7UyIJIHaFlw2l+mxwEBHM7Rd12YK+GG7ZixAaRWcoyOjcjBn0pGy8JeVpiOSEA65BTM77U/Q5sG6jzCyzxdj1b0ssQCpJrkAJO3DzWuzKGIX2Rf6enpTWnUQ810w7uGsO
 vIFYKybB
 kfpQKUfkm6wSGv54NeFapvDeIma4veMsNEDM5/rYxnYZn6FM9buI6wStO4UN9Dxf126C1jQOR1buFOmhi8qENWyEoA1GVPMEzE2sW2W0bbzBjHDK2AQfYeome/1Rhi50mt5LcZ+e4lZPd3utACQl6EK3cYJ9Uc7jgUDHRPpLXUOKZKDz6qLpM/4rhZ2e2SNKilGXAhiupu0P4xCs8cYx7Nuq0OI9a2lXlSP8fULn2BnYanKwJBk7WvzA3Y4LZl7ePX4lr+IVNiFOTPQQRQakJ+rC6I1r3DkHHcUgM1Ubwmq6e+deawUQvs1BUjzMBChOvT1HNd0LlwpXFGbCxfp1B4ARDmHc6MrqJKzq3QlLyZlXvrHOwxgSBIxnVSYPFOp+90m2mBxuflFbgS0GtPYRlu1RD/Wg3+AR+f2lZuanmKu9UhG2OnxDIbn5WKzaUf/6Yqlo2z0dwCor+Ocsh/1c8TY6Ilg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/1/30 20:19, Catalin Marinas 写道:
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
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
>
> That's not urgent for 6.19, it's just misuse of /dev/mem (aren't they
> all) but it's worth fixing.

This issue can be reproduced too with:

1) open and mmap a device that implements generic_access_phys as vm_operations_struct.acess callback.
2) acess the device by ptrace or /proc/$pid/mem.

But it's for debug only. So I agree this fix isn't urgent.

> Thanks.
>

