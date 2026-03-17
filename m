Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F00AFB5EA0
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 01:16:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2FE06B0005; Mon, 16 Mar 2026 21:16:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A081C6B0088; Mon, 16 Mar 2026 21:16:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 944BF6B0089; Mon, 16 Mar 2026 21:16:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7BA8C6B0005
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:16:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2EBFB1C546
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 01:16:30 +0000 (UTC)
X-FDA: 84553789740.23.E754048
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id 03F79A0011
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 01:16:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=DStCJ4x0;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773710187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zEFreDFoNLZcIvqChYf7kDks1gVkZBJntws5vYQjBJk=;
	b=HJL1zqlwwoWu+DyGWtqrIXJMUPd8D0dc/mSxLmYLkoLYJ76ScswHjYpmMzAv2Rs2vg7LnC
	LaZ7NWri+sQfMFZ2O2TTA0Atl+bDHaMKVHu5DK6KKnDFYdK80jUhBziBGchPzcrJK6q3N7
	sQzsw3StIOC/yfxaf4Og+qYPuLbME4I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773710187; a=rsa-sha256;
	cv=none;
	b=ZSX4CujOrqWMHFG6ksDysSyuK+sqcY1LmKNNRTluCvW+RN4wcAuYhzexAUTM5UZ9pDAUQq
	caGRIcILV5kz3neIabSbLvdVwnyU08W9gHnFHo24xXBAH0V7EWPbyiB5m0+nw6Dy2+NqRu
	slmRhmeakFmcIq6OwIe08uo4YICCCrQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=DStCJ4x0;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773710182; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=zEFreDFoNLZcIvqChYf7kDks1gVkZBJntws5vYQjBJk=;
	b=DStCJ4x0FDn52on32XijWHbZtTJlB7Om1kx0Fq7M8gWoYB7N8PSlo/4ImQPNzJgHC3x6Q8PeDc4LEW9XXRvCvh/biU34EQzSgB+yqnVu4PCxpf/8SA625FaMbx/IccaEkSYoeHsao7KCPTFcof0iWBfMBZY2h+6Vvzw2j0UUIxI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R251e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X.94iKz_1773710180;
Received: from 30.221.57.233(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.94iKz_1773710180 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 17 Mar 2026 09:16:21 +0800
Message-ID: <23953888-15d6-4cef-af8c-be15ed6d6e20@linux.alibaba.com>
Date: Tue, 17 Mar 2026 09:16:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: filemap: fix nr_pages calculation overflow in
 filemap_map_pages()
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 willy@infradead.org
Cc: lorenzo.stoakes@oracle.com, kas@kernel.org, p.raghav@samsung.com,
 mcgrof@kernel.org, dhowells@redhat.com, djwong@kernel.org, hare@suse.de,
 da.gomez@samsung.com, dchinner@redhat.com, brauner@kernel.org,
 xiangzao@linux.alibaba.com, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <066dd2e947ccc1c304b54e847fbe628dccea1d7c.1773370126.git.baolin.wang@linux.alibaba.com>
 <a5625929-736b-4ddc-a8e3-30e3aa54df12@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <a5625929-736b-4ddc-a8e3-30e3aa54df12@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: jhsb86yst8ojsjh69hz3j5rb64j7dnxw
X-Rspamd-Queue-Id: 03F79A0011
X-Rspamd-Server: rspam03
X-HE-Tag: 1773710185-43101
X-HE-Meta: U2FsdGVkX1+YVWNgr6ZtX67CfkEA30w1BozTQEfnxiJYODcClsjSxiqIFzgOESjPZG3GvpX3lueuxP0QVOGSoR1i2iwUP8YWnFKDP0LuO9eBSAvM7dmg7WF7VwIVZFIBn3W5p+ew+D3FzCaxH+dVctrE8TJFtjq1aJWLK+hURun22kSuWEh6Bk3WLz7sWpAoXKRVPrM4Z5a1IL9pX7ZE0on+t4jaKayGICLWbuVoWZ074Nh63oSDpJjj4fGaYxxu381Sz5CITVZ+U/4eHtmr/avu7ch8qpupVVyYkSvi1gvJJqEIAnBgctQV3dpVR3FabFxWoghWhtYAP7wu9gvanlono/kb1tBX6Tn6CuABn5RzJXqlndo8E0WFh6Hp7DRkZwvM5sqHBU5wnRXnt6FjlJpoSB/yoxy40ZB609tvE2FHBOCVP+0VCemgCZxbCh4Kki1EWzH0UwKETKKRx9pmXcrVqSd9DsW5n0ync8SYlWK73y4yMdxIASAPaFDcPNv1wd6lbLJixKhckz9y8EZ7ZTIfaLSed4CUCS97XRoTAkrYdMG+EHRJWeie7m6dCDLk/VIPWzbxSG+swn05Dvqyjn6cclYX/6ZjN42+ArwmirYZYpk0mfWNCGk1fbvCE3bu2DwzbEfpyxc1EVlcb3iQC/Vn+11y7qvnWgqdBHs1nW7kpMEwg8YpJnnYRBwfjkwoNNao5ofnVFwRVXTMLLvmFYtHzWKDk/nYQ38uKg62CpKTvU2XjatwYorIUwBRAcD9gGqaa/fYwTMWU9qEVFjfTuEpiQgYbEmlAnNl7dICR0OCYbZJ0G+RF3Cg5yYzELeijc5HWyJkOu9CtJ/xQ0DQBulmnXf/eD+G1DhPA0HYK2s4aiOKJvNBEaGsAVj+AQ67dBkSZQyJyESHBosLMO7UwBoM+r4w6hv/g9PiokO03FJS9SHW9PDdYDMEPcgA3uxP/9CNnFYsl9Tc15nWgXj
 h7C5iTja
 ysECkj4o0KFr0mbsCh1hZRDi8FqYcGj0M6CjA2yyp3+szL3to4HZUhXLpgFvWyd+akdBGKA78o8Ex7NKANNN7lDIdSjiU9Fh4mQ6j90zmzj3MRVAIjOMpRc8Bhk/6Ssrfv/jSK90NzmQ3hXcId9VGIrePezviAlEnk0MKnsM3nqr8qPLAnRIm7RZuSqukZ73q0OfQXqXWu+cAyAQFN4pKNDWVgFMpc2h9H+JWQxI49QUNkZwuWfRUzEI3TLsVxsEN2ffFmBHNXjumEl8ayP4wMPWPv/0O8WteKKJu33WIDaikMfI5bA1P8uct9jymNE91kmk0Z63hmLQJsKWoQmJ7Lg1LwnXqlzo9mE0kkuvbj2UPl7fr9/S9MNxRXo3R1mM31RnGwEDhuPNcLyOlrp4MFobpm/xpQPrGs43wOey5IFpOE6SRBnesxQLSo62GbbmEmYQCLNs1n4mBJnEucEFhKm5HCsn/SHQFB1Sp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/16/26 10:06 PM, David Hildenbrand (Arm) wrote:
> On 3/13/26 04:45, Baolin Wang wrote:
>> When running stress-ng on my Arm64 machine with v7.0-rc3 kernel, I encountered
>> some very strange crash issues showing up as "Bad page state":
>>
>> "
>> [  734.496287] BUG: Bad page state in process stress-ng-env  pfn:415735fb
>> [  734.496427] page: refcount:0 mapcount:1 mapping:0000000000000000 index:0x4cf316 pfn:0x415735fb
>> [  734.496434] flags: 0x57fffe000000800(owner_2|node=1|zone=2|lastcpupid=0x3ffff)
>> [  734.496439] raw: 057fffe000000800 0000000000000000 dead000000000122 0000000000000000
>> [  734.496440] raw: 00000000004cf316 0000000000000000 0000000000000000 0000000000000000
>> [  734.496442] page dumped because: nonzero mapcount
>> "
>>
>> After analyzing this page’s state, it is hard to understand why the mapcount
>> is not 0 while the refcount is 0, since this page is not where the issue first
>> occurred. By enabling the CONFIG_DEBUG_VM config, I can reproduce the crash as
>> well and captured the first warning where the issue appears:
>>
>> "
>> [  734.469226] page: refcount:33 mapcount:0 mapping:00000000bef2d187 index:0x81a0 pfn:0x415735c0
>> [  734.469304] head: order:5 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
>> [  734.469315] memcg:ffff000807a8ec00
>> [  734.469320] aops:ext4_da_aops ino:100b6f dentry name(?):"stress-ng-mmaptorture-9397-0-2736200540"
>> [  734.469335] flags: 0x57fffe400000069(locked|uptodate|lru|head|node=1|zone=2|lastcpupid=0x3ffff)
>> ......
>> [  734.469364] page dumped because: VM_WARN_ON_FOLIO((_Generic((page + nr_pages - 1),
>> const struct page *: (const struct folio *)_compound_head(page + nr_pages - 1), struct page *:
>> (struct folio *)_compound_head(page + nr_pages - 1))) != folio)
>> [  734.469390] ------------[ cut here ]------------
>> [  734.469393] WARNING: ./include/linux/rmap.h:351 at folio_add_file_rmap_ptes+0x3b8/0x468,
>> CPU#90: stress-ng-mlock/9430
>> [  734.469551]  folio_add_file_rmap_ptes+0x3b8/0x468 (P)
>> [  734.469555]  set_pte_range+0xd8/0x2f8
>> [  734.469566]  filemap_map_folio_range+0x190/0x400
>> [  734.469579]  filemap_map_pages+0x348/0x638
>> [  734.469583]  do_fault_around+0x140/0x198
>> ......
>> [  734.469640]  el0t_64_sync+0x184/0x188
>> "
>>
>> The code that triggers the warning is: "VM_WARN_ON_FOLIO(page_folio(page + nr_pages - 1) != folio, folio)",
>> which indicates that set_pte_range() tried to map beyond the large folio’s
>> size.
> 
> We had a bunch of similar reports throughout the last year from syzbot,
> but always without a reproducer.

I can reproduce it by running stress-ng for a few hours on my 128‑core 
machine, but I can’t reproduce it on smaller machines (e.g., 32‑core 
systems). It seems we need sufficient concurrency to trigger this race.

> In particular this here:
> 
> https://syzkaller.appspot.com/bug?extid=c0673e1f1f054fac28c2
> 
> via
> 
> https://lore.kernel.org/all/6758f0cc.050a0220.17f54a.0001.GAE@google.com/
> 
> Could that be the same root cause?

It appears so. Its warning stack calltrace matches what I reproduced.

>> By adding more debug information, I found that 'nr_pages' had overflowed in
>> filemap_map_pages(), causing set_pte_range() to establish mappings for a range
>> exceeding the folio size, potentially corrupting fields of pages that do not
>> belong to this folio (e.g., page->_mapcount).
> 
> Sounds quite bad.
> 
>>
>> After above analysis, I think the possible race is as follows:
>>
>> CPU 0                                                  CPU 1
>> filemap_map_pages()                                   ext4_setattr()
>>     //get and lock folio with old inode->i_size
>>     next_uptodate_folio()
>>
>>                                                            .......
>>                                                            //shrink the inode->i_size
>>                                                            i_size_write(inode, attr->ia_size);
>>
>>     //calculate the end_pgoff with the new inode->i_size
>>     file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
>>     end_pgoff = min(end_pgoff, file_end);
>>
>>     ......
>>     //nr_pages can be overflowed, cause xas.xa_index > end_pgoff
>>     end = folio_next_index(folio) - 1;
>>     nr_pages = min(end, end_pgoff) - xas.xa_index + 1;
>>
>>     ......
>>     //map large folio
>>     filemap_map_folio_range()
>>                                                            ......
>>                                                            //truncate folios
>>                                                            truncate_pagecache(inode, inode->i_size);
>>
>> To fix this issue, move the 'end_pgoff' calculation before next_uptodate_folio(),
>> so the retrieved folio stays consistent with the file end to avoid 'nr_pages'
>> calculation overflow. After this patch, the crash issue is gone.
>>
>> Fixes: 743a2753a02e ("filemap: cap PTE range to be created to allowed zero fill in folio_map_range()")
> 
> This certainly sounds like stable material :)

Yes, will cc stable.

>> Reported-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
>> Tested-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   mm/filemap.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/filemap.c b/mm/filemap.c
>> index bc6775084744..923d28e59642 100644
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -3879,14 +3879,14 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
>>   	unsigned int nr_pages = 0, folio_type;
>>   	unsigned short mmap_miss = 0, mmap_miss_saved;
>>   
>> +	file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
>> +	end_pgoff = min(end_pgoff, file_end);
>> +
>>   	rcu_read_lock();
>>   	folio = next_uptodate_folio(&xas, mapping, end_pgoff);
>>   	if (!folio)
>>   		goto out;
>>   
>> -	file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
>> -	end_pgoff = min(end_pgoff, file_end);
>> -
>>   	/*
>>   	 * Do not allow to map with PMD across i_size to preserve
>>   	 * SIGBUS semantics.
> 
> 
> LGTM. I do wonder if we want to add a comment above the file_end,
> stating that this really must happen before the next_uptodate_folio()
> to handle concurrent truncation.

Ack. How about adding the following comments?

"
Recalculate end_pgoff based on file_end before calling 
next_uptodate_folio() to avoid races with concurrent truncation.
"

