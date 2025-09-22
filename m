Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD206CAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 09:49:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3CD88E000D; Mon, 22 Sep 2025 05:49:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEDC98E0001; Mon, 22 Sep 2025 05:49:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C29D78E000D; Mon, 22 Sep 2025 05:49:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B298C8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 05:49:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4CF301605A3
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:49:28 +0000 (UTC)
X-FDA: 83916413616.09.9980E4F
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf08.hostedemail.com (Postfix) with ESMTP id 42EBA16000C
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:49:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of wuyifeng10@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wuyifeng10@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758534566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/DEmlys2IL8144Nk5e1AHB3aF+0Bgsu5dPkNz54Ua/U=;
	b=2uVT3OH4jb17EJXZ4pX4+GTq4GdiswR+n66YnET1BkeJFxORj2brx+slV6ejJ01JL/dIsR
	UM3ZVPHTxQUusQbSh94SzRMy0dYz6CCQ9YNGCVFXnGkWh9olFXMXB7WU6fWf1rgbxOWeNI
	a4e9KNvX5M352pT5uG/JYWCIl3oKbI0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758534566; a=rsa-sha256;
	cv=none;
	b=b7UgBs5MhQTo4TY41Ib44prvGYckUOo/aRVmqixQhM65lEyGFL822mDoLgOL9OI4hHfUh1
	S3oj+bfeTkJF7NxDbCPK+mIvIMifC1CH9PLjlC6o3pleQnFkFXAVSK+L5mT+rJPu3aMbYZ
	Yy9f8LQ6ZaA5sxxz3MeSNRPv1+UF5Es=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of wuyifeng10@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wuyifeng10@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cVdVy5wjWzQlPY;
	Mon, 22 Sep 2025 17:44:42 +0800 (CST)
Received: from kwepemr200005.china.huawei.com (unknown [7.202.195.182])
	by mail.maildlp.com (Postfix) with ESMTPS id 1417B180064;
	Mon, 22 Sep 2025 17:49:21 +0800 (CST)
Received: from [10.174.184.156] (10.174.184.156) by
 kwepemr200005.china.huawei.com (7.202.195.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 22 Sep 2025 17:49:20 +0800
Message-ID: <b045a2cf-4199-4fcc-be48-caa4f812f147@huawei.com>
Date: Mon, 22 Sep 2025 17:49:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] mm: MAP_POPULATE on writable anonymous mappings marks pte
 dirty is necessarily?
To: Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>
CC: <akpm@linux-foundation.org>, <linux-mm@kvack.org>
References: <17ad24e5-9ee0-4d94-be5f-3c28bd57460a@huawei.com>
 <oypwdcx6j726iffszfayd66xizaw5tfv2lnkk7bx7ibzn37x3m@ulkgb6x6geef>
 <adab9c31-c281-4bf7-93ae-89ed9f303d7b@redhat.com>
 <hgbxlsaxe3p6npj3tyrd6u64qel6monttjaadzcnzpcpgi7arp@ztzuvbq55vuz>
From: "wuyifeng (C)" <wuyifeng10@huawei.com>
In-Reply-To: <hgbxlsaxe3p6npj3tyrd6u64qel6monttjaadzcnzpcpgi7arp@ztzuvbq55vuz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.184.156]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr200005.china.huawei.com (7.202.195.182)
X-Stat-Signature: cgd1esfa9a6cmehc7793oa1ana1gxuot
X-Rspamd-Queue-Id: 42EBA16000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758534564-60947
X-HE-Meta: U2FsdGVkX19hcG6FTVOcnSZwmTOcrOQSmyAURhMHewqM7FybIaSRd3p2uR+g0P/PR3UYz2JhCMEp5uMUJRq7GL4KCNdOvVbxOMHFRaLA1k8jkDfVfYpjfPEzZGA/DkWEuxdNwSZ5tI97u+vMftZeaOXJdZe0Dys5ruq5znp4wT5ZJyxAIpB0X+vkQ+fMpJo1Qax5G4My4ZlXkJtLyL9ritPZzbd9mJIetcA6B3EDprcGu8biCP2Suv+d+0XKRh2NO0TJzuaWUL2myKDKI0u1vhnGFOCYt30uD/uDKFF2GfNKTVNGqF7cfw5GBwVKBRyCnWI6ljzB9Pb0l9wGsbOjYU0FoZh5/9O0zsig4SSst4Kr4CNcBZVpI7XStm+CRcph9vkQNgfezD/Pccs4MqTlxODlI1+1EagRTVuKsLgY+ykmbfOB+I30jA28lIZjcuTANJE1lDcMIIJuIsxEefINZFdx8FXwMzrPiLXC8EeNdF3tdl6i9TMrhFLi8jDIDoTmxs0v7f9pQK4ZP7D1M12EosLIbQLHpz+Ydtceue5/Re4lrKqpZJJp9xBfkcctzfvIkqktvtJUlnkIg33myQQPAEGpJWyEzyKjuLjuH1O0bv36aZnLzuPf4yTg6LWqPoSAr9JE1+4szvLa1y9rlxpu7Msbh3mGarlQwLROVNaPSeMGgKIN/10B+OVbeOi8a7VA7wWA4iddOHF601T9DCf19SwT8yucBsZg0Qb4Wz9F5RPrxSfFQpuZqgN2vdvrUgwjUW2dcsIqefitI3+oHo2pSZFkWgJf8YjxG+r1a3d25P7Qj42tAasX2PjhggHgpOAxMtdWkPyvPDALywP7k8SGoxtkzvDxVV5uI9lYrevAl0HBFYbPWXMSSpYPf+1Qenp0efa4FIaeMOFXJbW8TzEWs2V7ywF0G+a7yYpOC61pNra9AO1YRGJXEVXlgRHI12m9a4OsGbx8xmhkNQ7J59C
 ZYTLNnd1
 urjDQgrqZ9OIGF6X+Ip2DSuzLemwVL3aETR3abf+pmJwUnfZDY7BIOYizgmRIizct1RD60aiLypMf/RIqjosvmGfOEBUpDtmNwN2MqAudOFCx7TIUdYJSUkbQ8m5WhkH7dPxofrAZTHQKGCYyeAEIIeDI6q/x59oVEYjJPQRp8FSix6/1/Y2YiAlm35QZasSCQW/OJB4kFyf1EGwWZzCRH5Zoz4LebZ8H/T0AzelXr01fUk8+h9hI4yvouIRSw8EdrugER2aiEm7N+6dz68DwxUHnVRIJY5m8BFKnwDDGR3TUYvLovuHQ/YCqoMktfFqMBZo3eh+bTZXCuSw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I only noticed this behavior while reading the code and haven’t actually
encountered any performance issues caused by swap. I hadn’t initially considered
that marking pages dirty again would incur extra overhead (even with hardware support).

From this perspective, it’s clear that the current design provides a net benefit in the
vast majority of scenarios.

Thank you very much for your explanation!

在 2025/9/22 17:37, Pedro Falcato 写道:
> On Mon, Sep 22, 2025 at 11:07:43AM +0200, David Hildenbrand wrote:
>> On 22.09.25 10:45, Pedro Falcato wrote:
>>> On Mon, Sep 22, 2025 at 02:19:51PM +0800, wuyifeng (C) wrote:
>>>> Hi all, While reviewing the memory management code, I noticed a
>>>> potential inefficiency related to MAP_POPULATE used on writable
>>>> anonymous mappings.I verified the behavior on the mainline kernel
>>>> and wanted to share it for discussion.
>>>>
>>>> Test Environment:
>>>> Kernel version: 6.17.0-rc4-00083-gb9a10f876409
>>>> Architecture: aarch64
>>>>
>>>> Background:
>>>> For anonymous mappings with PROT_WRITE | PROT_READ, using MAP_POPULATE
>>>> is intended to pre-fault pages, so that subsequent accesses do not
>>>> trigger page faults. However,I observed that when MAP_POPULATE is used
>>>> on writable anonymous mappings, all pre-faulted pages are immediately
>>>> marked as dirty, even though the user program has not written to them.
>>>>
>>>> Minimal Reproduction:
>>>>
>>>> #define _GNU_SOURCE
>>>> #include <sys/mman.h>
>>>> #include <unistd.h>
>>>> #include <stdio.h>
>>>>
>>>> int main() {
>>>>      size_t len = 100*1024*1024; // 100MB
>>>>      void *p = mmap(NULL, len, PROT_READ | PROT_WRITE,
>>>>                     MAP_PRIVATE | MAP_ANONYMOUS | MAP_POPULATE, -1, 0);
>>>>      if (p == MAP_FAILED) {
>>>>          perror("mmap");
>>>>          return 1;
>>>>      }
>>>>      pause();
>>>>      return 0;
>>>> }
>>>>
>>>> Observed Output (/proc/<pid>/smaps):
>>>> ffff7a600000-ffff80a00000 rw-p 00000000 00:00 0
>>>> Size:             102400 kB
>>>> KernelPageSize:        4 kB
>>>> MMUPageSize:           4 kB
>>>> Rss:              102400 kB
>>>> Pss:              102400 kB
>>>> Pss_Dirty:        102400 kB
>>>> Shared_Clean:          0 kB
>>>> Shared_Dirty:          0 kB
>>>> Private_Clean:         0 kB
>>>> Private_Dirty:    102400 kB
>>>> Referenced:       102400 kB
>>>> Anonymous:        102400 kB
>>>> KSM:                   0 kB
>>>> LazyFree:              0 kB
>>>> AnonHugePages:    102400 kB
>>>> ShmemPmdMapped:        0 kB
>>>> FilePmdMapped:         0 kB
>>>> Shared_Hugetlb:        0 kB
>>>> Private_Hugetlb:       0 kB
>>>> Swap:                  0 kB
>>>> SwapPss:               0 kB
>>>> Locked:                0 kB
>>>> THPeligible:           1
>>>> VmFlags: rd wr mr mw me ac
>>>>
>>>> Code Path Analysis:
>>>> The behavior can be traced through the following kernel code path:
>>>> populate_vma_page_range() is invoked to pre-fault pages for the VMA.
>>>> Inside it:
>>>>
>>>> if ((vma->vm_flags & (VM_WRITE | VM_SHARED)) == VM_WRITE)
>>>>          gup_flags |= FOLL_WRITE;
>>>>
>>>> This sets FOLL_WRITE for writable anonymous VMAs.
>>>>
>>>> Later, in faultin_page():
>>>>
>>>> if (*flags & FOLL_WRITE)
>>>>          fault_flags |= FAULT_FLAG_WRITE;
>>>>
>>>> This effectively marks the page fault as a write.
>>>> Finally, in do_anonymous_page():
>>>>
>>>> if (vma->vm_flags & VM_WRITE)
>>>>          entry = pte_mkwrite(pte_mkdirty(entry), vma);
>>>>
>>>> Here, the PTE is updated to writable and immediately marked dirty.
>>>> As a result, all pre-faulted pages are marked dirty, even though the
>>>> user program has not performed any writes.
>>>> For large anonymous mappings, this can trigger unnecessary swap-out
>>>> writebacks, generating avoidable I/O.
>>>>
>>>> Discussion:
>>>> Would it be possible to optimize this behavior: for example, by
>>>> populate pte as writable, but deferring the dirty bit until the user
>>>> actually writes to the page?
>>>
>>> How would we know if the user wrote to the page, since we marked it writeable?
>>
>> On access, either HW sets the dirty bit if it supports it, or we get another
>> fault and set the dirty bit manually.
>>
>> What happens on architectures where the HW doesn't support setting the dirty
>> bit is that performing a pte_mkwrite() checks whether the pte is dirty. If
>> it's not dirty the HW write bit will not be set and instead the next
>> pte_mkdirty() will set the actual HW write bit.
>>
>> See pte_mkwrite() handling in arch/sparc/include/asm/pgtable_64.h or
>> arch/s390/include/asm/pgtable.h
>>
>> Of course, setting the dirty bit either way on later access comes with a
>> price.
> 
> Ah, yes, the details were a little fuzzy in my head, thanks.
> I'm trying to swap in (ha!) the details again. We still proactively mark anon
> folios dirty anyway for $reasons, so optimizing it might be difficult? Not sure
> if it is _worth_ optimizing for anyway.
> 

