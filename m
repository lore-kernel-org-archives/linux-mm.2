Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A9ADE67A9E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:22:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 750F56B0088; Tue,  3 Mar 2026 05:22:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 727EE6B00A4; Tue,  3 Mar 2026 05:22:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6545B6B00A8; Tue,  3 Mar 2026 05:22:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 500126B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:22:42 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 086DB1603F6
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:22:42 +0000 (UTC)
X-FDA: 84504362964.13.A1B983B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id E7F0C160008
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:22:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772533360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bghv2hKLJQVMtDz+TminPlcTEJZOwuY2AhMtfkmk6yA=;
	b=EukBaGJdXMFF2tyUvLHzLdzh7b75x6vVWwbMsWVgnnZUNqFTHpAxI0x7xlKHuhNIE6G3QK
	mN6fpV18//XQhoswg166UsFZzANaUKMNxJv8Zt5Ra52fS+Dn/ue1yHnx+iEVhTGMQ8rHrl
	JlhohHAybPGS+pz4lnpSrGelOisIyGQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772533360; a=rsa-sha256;
	cv=none;
	b=IGcP/+Q3Sdy/AjEqz7X7aLXvloqSebbz2yXEY/G0Q+ZtgFtvE9y9sBMU5dZ1hkMvc1DdCh
	6OPzIW8IMY28/Rp2Dc0iPsyPeykAzbrZX7Rxliv65YLRXULioeWjcLjne7qFqtl+Z3SPSq
	lCHNIYbYo0TQ9URfQV77Kr/XwvohxwM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7A503497;
	Tue,  3 Mar 2026 02:22:32 -0800 (PST)
Received: from [10.164.19.52] (unknown [10.164.19.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5266D3F7BD;
	Tue,  3 Mar 2026 02:22:34 -0800 (PST)
Message-ID: <cc712fbc-93e9-4951-8e46-21f1af8a037d@arm.com>
Date: Tue, 3 Mar 2026 15:52:31 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/rmap: fix incorrect pte restoration for lazyfree
 folios
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@kernel.org, riel@surriel.com,
 Liam.Howlett@oracle.com, vbabka@kernel.org, harry.yoo@oracle.com,
 jannh@google.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable <stable@kernel.org>
References: <20260303061528.2429162-1-dev.jain@arm.com>
 <01a12197-73fb-4e4e-8d8c-85de5cd2c9f5@lucifer.local>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <01a12197-73fb-4e4e-8d8c-85de5cd2c9f5@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E7F0C160008
X-Stat-Signature: e7ro9szibykz4izmo1hr9wsndk3nrii9
X-Rspam-User: 
X-HE-Tag: 1772533359-944223
X-HE-Meta: U2FsdGVkX18BimwRRV8iOioCJs2gujHWDN+Xfu1kfDdPgvNg0e/4Y26C9EMuDuMUNoxBg5Xj1lEYOmcV2Akj1XxWDbtgn5NzUyrqAroNMW2F8yGbjpvrWK9iXfmbi8PglYPawOkQv2Dq/M8O5/hBGVsGfSF9hbZetrFDOgXhSzS021G3EZBNnlY5pJKSgsXlOS1YR2r9Dzz5/O8yxqexhtAriLjG9oLmEEMptpLKUBCxWTxiDl6XsT8JBvTbyeyLKufOWFHd/TIQdCc+60pY92rE3f8eTaAG6BZGAd3y07kdykUi2tfmdzQsf1ak+4FfLNcQKFRt3tSDFbF9WmJ6XNs1G7hHdE11dhP3mMBL/jJlpR25GzTDU8BI05tPAvJ3yzCbccBboYuefDVIR6r5MjlLH7ZQFoFfmPZsFosaZ6+Dbgip4Zpgk7HA/xib2TUNw1wvXTNCqlNAWteZHCqxIWLBTBOwIMQsA6nfjDPknHLiZwxyExhzYc6iGTmsdh1xhXtKMLl6NQTFi8SIIuapAmHrHe8cB3yHMHcQViNmmPL5zfJfpz+rqbn6EqvMEVcuyPXhxADv9P5puf5RJV1qCrQgEfh6mRSH6Ty76D8Ud1j7lG64qk7IL0WSODv9wO+gFeRM+BOPrsBoElqNADzktsqWOzmaObAp73+P0Vom2qo9+HGyQg4wB3YHfbJ5iugj5NxZF9DELRzjleGPgPh+i6ER0gkR06div1NigSHVXLI2tXgK1oIK/J7bWDkGIMAN0EodUCDiqJ31SpqcQrIN+IuD9flg6bPXjxz1iHrevlsYZz3QluEPbVhdkD/wwPHm/0KYu4CXb6+zlFImIovSAqd9b4x+zgupGMFw3euPK/dI2KQ49pERdpWvR6SLvoiSEacyFTMq9S5BGGXpcjzwmnDtpqrdpz1ZAdDF64B9rLAcZi4rCTbvcuQ15vDyrpiK6OMGmxHTb1AzzjuNT5+
 eYn9TDpD
 NyV3Dek3ViQagBmnwg05ZMpotiRQ/g/QeTpMHB/OYPqn/CZ9NLA9nGMwnD0PqVIHv3tfVfQbGC0BnUfjFQ0rYW0wIQQ9uf7XWHiMCbI+c/2dUIFPJDMEouytBUxiYdA/VrrNPXqz5ERJXUYxbOiCyKhQopGbooaZ/X+3NB+dfGHu9EzU+p8YDEUAcWrsIpHFG6PBYL1xSx19h62km3RLr3PGBySYFo/YE9RsA9+iwJryZGE3s8FZZ/ldbXMfv9N0Emvi8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 03/03/26 3:24 pm, Lorenzo Stoakes wrote:
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
> 
> Presumably:
> 
> 			BUG_ON(atomic_inc_return(&ptc->anon_map_count) > 1 && rw);
> 
> It'd be useful to be explicit about this in the commit msg.
> 
> It's also probably worth saying explicitly that this is about a
> non-AnonExclusive mapping being mapping read/write as a result of this.
> 
> I'm not sure the stack trace is really that useful beyond that, as by the time
> somebody comes to read this later it's probably going to be fairly inaccurate :)
> 
> Maybe worth just spelling out e.g. try_to_unmap_one() -> ... rest of code path ...
> 
> I mean the stack already misses stuff due to inlining so that'd be more useful,
> otherwise I'd drop it.

Good point, thanks! Lemme reply to the patch.

> 
> 
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
>>     const char *path = "/sys/devices/system/node/node0/reclaim";
>>     const char *value = "409600000000";
>>     int fd = open(path, O_WRONLY);
>>     if (fd == -1) {
>>         perror("open");
>>         exit(EXIT_FAILURE);
>>     }
>>
>>     if (write(fd, value, sizeof("409600000000") - 1) == -1) {
>>         perror("write");
>>         close(fd);
>>         exit(EXIT_FAILURE);
>>     }
>>
>>     printf("Successfully wrote %s to %s\n", value, path);
>>     close(fd);
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
> 
> Thanks, having the repro code here is really useful!
> 
>>
>> Fixes: 354dffd29575 ("mm: support batched unmap for lazyfree large folios during reclamation")
>> Cc: stable <stable@kernel.org>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
> 
> This looks correct to me, so other than nits around commit msg above:
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> 
>> ---
>> Patch applies on mm-unstable (9af4957ef127).
>>
>> v2->v3:
>>  - Don't special case for anon folios
>>
>> v1->v2:
>>  - Just respect the writable bit instead of hacking in a pte_wrprotect() in
>>    failure path
>>  - Also handle soft-dirty bit
>>
>>  mm/rmap.c | 9 ++++++++-
>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index bff8f222004e4..5a3e408e3f179 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -1955,7 +1955,14 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>>  	if (userfaultfd_wp(vma))
>>  		return 1;
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
>>  }
>>
>>  /*
>> --
>> 2.34.1
>>


