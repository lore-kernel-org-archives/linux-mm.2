Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66C31EC1421
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 12:26:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 637156B01AA; Tue,  3 Mar 2026 07:26:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60F716B01AB; Tue,  3 Mar 2026 07:26:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 545296B01AE; Tue,  3 Mar 2026 07:26:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 403A26B01AA
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 07:26:10 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9F9E91B6CE6
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 12:26:09 +0000 (UTC)
X-FDA: 84504674058.16.8F426B7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6826C4000B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 12:26:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772540768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YaEWwZnbhxVK9K8efE6p16KuFyk0pj5Evpos7Pybhas=;
	b=iGuyWwZ/3EyB4aZxOCfAEbDGnmwXTINOKQ5LJXZd1cS8G+FZQJw/j+XzDQP5knUUOwzmJ8
	lSzWukyw8NRlyF77FEVjOl2LKpcWibD2u1lcrJewcWsWylNasEjh8sq4HTdYUNltCUVVF2
	3L+hDKLL9O5ydCmrNyyTOxqdZ/eFUOA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772540768; a=rsa-sha256;
	cv=none;
	b=NtfppDOUpqQBrvq9VjqkJLdAvL6zDvEIjA7iAzI6JONjz/7d4o4K9sOGoJwxLkT3x5QwsA
	U6sTPHM/4PuZpMyDZGmfwSFySx/rKUiAwkNkAk4n6GSQkXiSpQeqedLRx0Lu68Pv7fGhaE
	POkgiIzVTFPqbsgLVvAaok4LGYaSzXs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F1875497;
	Tue,  3 Mar 2026 04:25:59 -0800 (PST)
Received: from [10.163.137.84] (unknown [10.163.137.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9C4E73F7BD;
	Tue,  3 Mar 2026 04:26:01 -0800 (PST)
Message-ID: <257aa379-64cf-47af-b48d-8817f7bca257@arm.com>
Date: Tue, 3 Mar 2026 17:55:58 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/rmap: fix incorrect pte restoration for lazyfree
 folios
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 riel@surriel.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
 harry.yoo@oracle.com, jannh@google.com, baohua@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable <stable@kernel.org>
References: <20260303061528.2429162-1-dev.jain@arm.com>
 <20260303121727.ss3d3gbzituygb6p@master>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260303121727.ss3d3gbzituygb6p@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6826C4000B
X-Stat-Signature: n593jhwirzuqj46tuwa8byto6unmtexy
X-HE-Tag: 1772540767-777975
X-HE-Meta: U2FsdGVkX1/6HKGAiSByzHUs92NTInXqplp/CMZO7HC7LuEDW+3wmMMvIpj6k/45AnMKVqtj1+b3rhAMo2BV3DaWShIiXZMOQi+UOHqj94JJTvBMtOrY6pBVrD/MzsYC3lH5JMYn/lPW+ZtMm3v9nfInUbiB/ZOpMNppSJUTwM76W2bzTlyCMuH5EUSeFC0WmycXFFuq3IRSuhTYUZIV4uBjvm7k5ByBzIsW1NRFjZiqVfFiyNZLKyxrPJLcqYkL9OpopG25JbVQJA1SKRohzjEAoHuiJZCL3CQt8s0oETAFWY8l7UBNZznN8Jz/f1fdKvTlEhI/3YSYsVncqMGMvYohGXquXV8F0aqftFUHlpsS0GTGIZNU/YEjd//87EOzSmDd3o1awSPENcch/g2lIgdPkMRNiwk3HIuY3xniNqX+Ca4dgBv7hWSkyI1hBVVwSw+EVVV73ZZV59/uzMNxeUGS8FSgH+BUoEWMxRXzWeoJfoP3RMOxKrnMWjW3ll52AntVv90SV8aRdOIOURGeYXZGZO1Bf0+1qPonliQoZVnqVHUkO8gzuR0GckrVovDaV6F/K5Zi4xod2wmA2s4ikwwCYQeQY2W8KRkfxNKJFfRHmdtzXwhk9AqCOEVxusrrfSkvGYeRMboMFGz3Ud6jsr7MIJfqXntL4lIMVlesYK9Tu4bIFemPwl3dXySdZ1qbDnHG1AZnb7Zoo6F+dDF78lVJ09dIestd3R+lUfWyk6Wn4r6bGHqgU7Lt+cGqgILo6vMgHUDA8TwcFKjkkIAW+Ay+MgKlFhGhy252ZXALEA13QeSlSqMiuqG7pY+JABGUDBNo/fXdEk5yvAif9zskmmcTJTB4RRipBF8w9GRzDxRscabkBw51o0m7NxDnDvkYqUejLQkRqtRypZPp3380uaU4yPwKFFhRE4n3QuBPpgnpmXdAwng+NkXlv8JKVwpKOURV1wpLEI2WhklJ3Pk
 Fw45OXIi
 45jg1cTZc/DthZ7TtEyhdiCYe337aKQ6/LwyaOu9oUB/jyUbRq7DZpANX2Or+GVwM30blDdCN8gHkx2XhJzUS4qAILsQUvkbE4zy2nA2xu0h2l8S3yVARIHBc6CZW7trmduXDP9cECW8QYTd9I5zDO9Y2nxvilCbyyd25eJf4gxdGp8ODichbvOj2jhxs3RgXBaJa4sqRmsQVbBNah/Gc4LbWoNf2PW1t08HSlp8z1tBENLmltVPWp9HWvFl9pVn6vvom9XdgQHqoYkhS5f3DsKKVnPquSOsfa+5/sOS1vP/lg3Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 03/03/26 5:47 pm, Wei Yang wrote:
> On Tue, Mar 03, 2026 at 11:45:28AM +0530, Dev Jain wrote:
>> We batch unmap anonymous lazyfree folios by folio_unmap_pte_batch.
>> If the batch has a mix of writable and non-writable bits, we may end up
>> setting the entire batch writable. Fix this by respecting writable bit
>> during batching.
>> Although on a successful unmap of a lazyfree folio, the soft-dirty bit is
>> lost, preserve it on pte restoration by respecting the bit during batching,
>> to make the fix consistent w.r.t both writable bit and soft-dirty bit.
>>
>> I was able to write the below reproducer and crash the kernel.
>> Explanation of reproducer (set 64K mTHP to always):
>>
>> Fault in a 64K large folio. Split the VMA at mid-point with MADV_DONTFORK.
>> fork() - parent points to the folio with 8 writable ptes and 8 non-writable
>> ptes. Merge the VMAs with MADV_DOFORK so that folio_unmap_pte_batch() can
>> determine all the 16 ptes as a batch. Do MADV_FREE on the range to mark
>> the folio as lazyfree. Write to the memory to dirty the pte, eventually
>> rmap will dirty the folio. Then trigger reclaim, we will hit the pte
>> restoration path, and the kernel will crash with the following trace:
>>
>> [   21.134473] kernel BUG at mm/page_table_check.c:118!
>> [   21.134497] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
>> [   21.135917] Modules linked in:
>> [   21.136085] CPU: 1 UID: 0 PID: 1735 Comm: dup-lazyfree Not tainted 7.0.0-rc1-00116-g018018a17770 #1028 PREEMPT
>> [   21.136858] Hardware name: linux,dummy-virt (DT)
>> [   21.137019] pstate: 21400005 (nzCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
>> [   21.137308] pc : page_table_check_set+0x28c/0x2a8
>> [   21.137607] lr : page_table_check_set+0x134/0x2a8
>> [   21.137885] sp : ffff80008a3b3340
>> [   21.138124] x29: ffff80008a3b3340 x28: fffffdffc3d14400 x27: ffffd1a55e03d000
>> [   21.138623] x26: 0040000000000040 x25: ffffd1a55f7dd000 x24: 0000000000000001
>> [   21.139045] x23: 0000000000000001 x22: 0000000000000001 x21: ffffd1a55f217f30
>> [   21.139629] x20: 0000000000134521 x19: 0000000000134519 x18: 005c43e000040000
>> [   21.140027] x17: 0001400000000000 x16: 0001700000000000 x15: 000000000000ffff
>> [   21.140578] x14: 000000000000000c x13: 005c006000000000 x12: 0000000000000020
>> [   21.140828] x11: 0000000000000000 x10: 005c000000000000 x9 : ffffd1a55c079ee0
>> [   21.141077] x8 : 0000000000000001 x7 : 005c03e000040000 x6 : 000000004000ffff
>> [   21.141490] x5 : ffff00017fffce00 x4 : 0000000000000001 x3 : 0000000000000002
>> [   21.141741] x2 : 0000000000134510 x1 : 0000000000000000 x0 : ffff0000c08228c0
>> [   21.141991] Call trace:
>> [   21.142093]  page_table_check_set+0x28c/0x2a8 (P)
>> [   21.142265]  __page_table_check_ptes_set+0x144/0x1e8
>> [   21.142441]  __set_ptes_anysz.constprop.0+0x160/0x1a8
>> [   21.142766]  contpte_set_ptes+0xe8/0x140
>> [   21.142907]  try_to_unmap_one+0x10c4/0x10d0
>> [   21.143177]  rmap_walk_anon+0x100/0x250
>> [   21.143315]  try_to_unmap+0xa0/0xc8
>> [   21.143441]  shrink_folio_list+0x59c/0x18a8
>> [   21.143759]  shrink_lruvec+0x664/0xbf0
>> [   21.144043]  shrink_node+0x218/0x878
>> [   21.144285]  __node_reclaim.constprop.0+0x98/0x338
>> [   21.144763]  user_proactive_reclaim+0x2a4/0x340
>> [   21.145056]  reclaim_store+0x3c/0x60
>> [   21.145216]  dev_attr_store+0x20/0x40
>> [   21.145585]  sysfs_kf_write+0x84/0xa8
>> [   21.145835]  kernfs_fop_write_iter+0x130/0x1c8
>> [   21.145994]  vfs_write+0x2b8/0x368
>> [   21.146119]  ksys_write+0x70/0x110
>> [   21.146240]  __arm64_sys_write+0x24/0x38
>> [   21.146380]  invoke_syscall+0x50/0x120
>> [   21.146513]  el0_svc_common.constprop.0+0x48/0xf8
>> [   21.146679]  do_el0_svc+0x28/0x40
>> [   21.146798]  el0_svc+0x34/0x110
>> [   21.146926]  el0t_64_sync_handler+0xa0/0xe8
>> [   21.147074]  el0t_64_sync+0x198/0x1a0
>> [   21.147225] Code: f9400441 b4fff241 17ffff94 d4210000 (d4210000)
>> [   21.147440] ---[ end trace 0000000000000000 ]---
>>
>>
>> #define _GNU_SOURCE
>> #include <stdio.h>
>> #include <unistd.h>
>> #include <stdlib.h>
>> #include <sys/mman.h>
>> #include <string.h>
>> #include <sys/wait.h>
>> #include <sched.h>
>> #include <fcntl.h>
>>
>> void write_to_reclaim() {
>>    const char *path = "/sys/devices/system/node/node0/reclaim";
>>    const char *value = "409600000000";
>>    int fd = open(path, O_WRONLY);
>>    if (fd == -1) {
>>        perror("open");
>>        exit(EXIT_FAILURE);
>>    }
>>
>>    if (write(fd, value, sizeof("409600000000") - 1) == -1) {
>>        perror("write");
>>        close(fd);
>>        exit(EXIT_FAILURE);
>>    }
>>
>>    printf("Successfully wrote %s to %s\n", value, path);
>>    close(fd);
>> }
>>
>> int main()
>> {
>> 	char *ptr = mmap((void *)(1UL << 30), 1UL << 16, PROT_READ | PROT_WRITE,
>> 			 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>> 	if ((unsigned long)ptr != (1UL << 30)) {
>> 		perror("mmap");
>> 		return 1;
>> 	}
>> 	
>> 	/* a 64K folio gets faulted in */
>> 	memset(ptr, 0, 1UL << 16);
>>
>> 	/* 32K half will not be shared into child */
>> 	if (madvise(ptr, 1UL << 15, MADV_DONTFORK)) {
>> 		perror("madvise madv dontfork");
>> 		return 1;
>> 	}
>>
>> 	pid_t pid = fork();
>>
>> 	if (pid < 0) {
>> 		perror("fork");
>> 		return 1;
>> 	} else if (pid == 0) {
>> 		sleep(15);
>> 	} else {
>> 		/* merge VMAs. now first half of the 16 ptes are writable, the other half not. */
>> 		if (madvise(ptr, 1UL << 15, MADV_DOFORK)) {
>> 			perror("madvise madv fork");
>> 			return 1;
>> 		}
>> 		if (madvise(ptr, (1UL << 16), MADV_FREE)) {
>> 			perror("madvise madv free");
>> 			return 1;
>> 		}
>>
>> 		/* dirty the large folio */
>> 		(*ptr) += 10;
>>
>> 		write_to_reclaim();
>> 		// sleep(10);
>> 		waitpid(pid, NULL, 0);
>>
>> 	}
>> }
>>
>> Fixes: 354dffd29575 ("mm: support batched unmap for lazyfree large folios during reclamation")
>> Cc: stable <stable@kernel.org>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>> Patch applies on mm-unstable (9af4957ef127).
>>
>> v2->v3:
>> - Don't special case for anon folios
>>
>> v1->v2:
>> - Just respect the writable bit instead of hacking in a pte_wrprotect() in
>>   failure path
>> - Also handle soft-dirty bit
>>
>> mm/rmap.c | 9 ++++++++-
>> 1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index bff8f222004e4..5a3e408e3f179 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -1955,7 +1955,14 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>> 	if (userfaultfd_wp(vma))
>> 		return 1;
>>
>> -	return folio_pte_batch(folio, pvmw->pte, pte, max_nr);
>> +	/*
>> +	 * If unmap fails, we need to restore the ptes. To avoid accidentally
>> +	 * upgrading write permissions for ptes that were not originally
>> +	 * writable, and to avoid losing the soft-dirty bit, use the
>> +	 * appropriate FPB flags.
>> +	 */
>> +	return folio_pte_batch_flags(folio, vma, pvmw->pte, &pte, max_nr,
>> +				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
>> }
>>
> 
> Hi, Dev
> 
> When reading the code, I got one confusion. Current call flow is like below:
> 
>     try_to_unmap_one();
>         nr_pages = folio_unmap_pte_batch(folio, &pvmw, flags, pteval);
> 	..
> 	pteval = get_and_clear_ptes(mm, address, pvmw.pte, nr_pages);
> 	..
> 	set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
> 
> We get pteval by folio_unmap_pte_batch() but it is set again by

folio_unmap_pte_batch() gives the batch size, not pteval. pteval is
given by get_and_clear_ptes() after accumulating a/d bits.

> get_and_clear_ptes(), which maybe a different value. Then we use this pteval
> to restore ptes.
> 
> So even we fix folio_unmap_pte_batch(), how this impact on the final restored
> value?

By respecting writable bit, we ensure that the ptes in the batch do not
have a mix of writable and non writable ptes.

So, if pteval returned by get_and_clear_ptes() is writable, then it is
guaranteed via folio_unmap_pte_batch() that the all pte values of
these nr_pages consecutive ptes, are writable. And vice versa.

> 
> Hope I don't miss something.
> 
>> /*
>> -- 
>> 2.34.1
>>
> 


