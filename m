Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EDA9FEDA09
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 01:17:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86F076B00C7; Tue, 17 Mar 2026 21:17:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 846926B00C9; Tue, 17 Mar 2026 21:17:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 783F86B00CA; Tue, 17 Mar 2026 21:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6725A6B00C7
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 21:17:15 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E3E0D160407
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 01:17:14 +0000 (UTC)
X-FDA: 84557420388.10.8F04CEA
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 12221C000A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 01:17:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=PVMAhDDj;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773796633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n76Vl/YByYovXpfiSJaIiV6BYs7tkM/M9VUvPvWWK24=;
	b=di+yFkGGdrOUhCdP2sDB5Y9JoAkePi4FbvZd93EJlF0nLG/eMQopBeY53Uz9Saq8Kdx3Pg
	AjxSNDdoLgi31MdzA06uh3gCNffm3xL9BtDc0WVl6j9o10mdnFNVe9kPpaIDK5kiaz6zes
	rrgG7TUAcyAER04LrNKQjmvQ3bvuEr0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=PVMAhDDj;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773796633; a=rsa-sha256;
	cv=none;
	b=onL5QYEVkmNaB7ElFrrekWrj9Y1vbm+bh0Y+JciCbflDcAdZqtLdSp+aCq2B4rict+w2Ry
	5hzV38JGGmZefJ1b/JRTwMg8AOi3wq7ITZgaiDPLciPuwSutyrYfrsjgYE04DoCCrvLEtT
	LY76wfwJuTGPLdL+/2/agYy/cJMkYVs=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773796627; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=n76Vl/YByYovXpfiSJaIiV6BYs7tkM/M9VUvPvWWK24=;
	b=PVMAhDDjNikU09WU3DMxOqfmhScJfYvYnVz5n4Fnsu5z6iLDjUCfC59P1d1qXZwzmQ4pzdied1/R7/51PV0uONTV9hEhLPRA1QQosr1vLSJ67ODLeH1SqWXMnHj1TcZDkQJDAYHYx8TtcHANOB1K6Lk7mwwt/UNINSfRDVAD8do=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R401e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X.CWN2v_1773796625;
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.CWN2v_1773796625 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 18 Mar 2026 09:17:06 +0800
Message-ID: <dd67c771-8530-40d7-93c3-cd6f405c32dd@linux.alibaba.com>
Date: Wed, 18 Mar 2026 09:17:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: filemap: fix nr_pages calculation overflow in
 filemap_map_pages()
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 willy@infradead.org
Cc: lorenzo.stoakes@oracle.com, kas@kernel.org, p.raghav@samsung.com,
 mcgrof@kernel.org, dhowells@redhat.com, djwong@kernel.org, hare@suse.de,
 da.gomez@samsung.com, dchinner@redhat.com, brauner@kernel.org,
 xiangzao@linux.alibaba.com, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <1cf1ac59018fc647a87b0dad605d4056a71c14e4.1773739704.git.baolin.wang@linux.alibaba.com>
 <9d968181-95a9-477e-9aa0-763117e4d1a0@kernel.org>
 <82019011-023c-4bce-a524-6eab119f0a4a@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <82019011-023c-4bce-a524-6eab119f0a4a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 12221C000A
X-Rspamd-Server: rspam08
X-Stat-Signature: rg4zwn7gij4yq3q8ha1kz9mw5grzckps
X-HE-Tag: 1773796631-278752
X-HE-Meta: U2FsdGVkX1+m6Hlyj0UmALK817bPyWXpKAt+p81wwkA7VbSYJ96a4t6vVODyuOmbBxTPTO7pL9VS89+V7e1mP1bRnJ0VOiA1As+9OgbTO/w6fherhrpu9d86r4FWxlZ421QqZM0XHsgiY636aThIPN0i9zY6AXOKFg4Z+afZYxeFNPebPWqPcntGTPC7nfcS8zL95hmC1XwVkA2Q0R/4tvEa3qtM6dcBC/NR4abG/XU5uVijrb4ciBCnMxZGdNU9/vHSjwd565O3oEnNVADkFqrvNMe2FKkB48/dXDOFrz+wcr5pxSPy880bEUk3oyIP1J1zpf71cQxrrYkN60qvHSsnQN5IGLn3Y85w9aP5mFXX0mry9ML2nyBmZViHK3ogv8jAXGC1n8VGUR11EueVwFIWUh5WUfGlDMr5hrGBhB1Q2CszLmh+DUsPMg2mTb/8ll0Z60zNQwHgWDQSN5C56fBueHYNPmLNvxB42Kl3KwFGIRXVmuWBH2soURjL5dWEQDvuHqxqAEQ748ag/AkyqMn6ix3tWryGpqyewRW7RuuIZVU2CxCVj203zRUMgIlaSlVgZ85v5a8o0kxjOZetNnvISqdL58j45u/uZW7T8TKq7zaB6iZzkHSYRx731vg5YeRf3Bk7LYkQJfApvXDElX5oMNIclLeafL8/Bg/a/AwMyvTXE8eSHpps/8QHGbd2fMEC96izhMfj3D27+p4IgcZ46ElBAqWPMqODpntwlv/p4aw6gJeDjNY5ExqJs8eUyc4Yj4CMCwve6P/Uh7OGFvTbFRect0CzCv8j+DIDB7BLW8SsfzZH3ZA2dFrsukKrlpgcm6Humk7RDVVeUUxCvhqm7aMfFcJIqMAvwTJ1QKI0rYcFx/tViep9waZ+q5EqLwEvFlyYuadAQdE0ZvXhRduHZQK3SOh7VGUAnyn+7eiq5IbOASZV0hCp+MuXtVe8eIEorIkAuZc8+nkIjZ8
 5UJodrFd
 Zr009b7SSB3zKJpllwJkZCD7QhXdXse5i4vWyyF70RgguZdd4XGUJgRUsEPoBlggBpOxJpS/zgFyYL/NqpuK1Pt/WQsrkC+q8L/wYwTXLKtxL1+wzkI+DvufkpQcoGeuNNIAR4/aeFVCtljpTGMyibo+B+xt+No5nY8paCKAGpjrQnVBTTZ5aIboChPy/YA+Nh6Zn+cb3lrDVVsxLi7gU96Z3niwHugsy6uy4C+ARtH1vcswJAu3D2d9YXZtbP8i632NMqwrLtyn1UwPl+Uew91XEDNn+ESj697V8fN1UcNVdVOVXZZgvpvJiAFFmEVa1nWIREx7rHSbZ5e2hD22Qq5iEwjHTXm/DKAlqJxJLOma/mhVOHQ1ytCW87G466TlrmzWkNyA24Ok5AbrKVVMo1PU5KH8pSdVUD0tR7NFIrwhHLAku2rVwntF3i3c6Kc0emCn2upqNs5DE9+4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/18/26 4:49 AM, David Hildenbrand (Arm) wrote:
> On 3/17/26 10:37, David Hildenbrand (Arm) wrote:
>> On 3/17/26 10:29, Baolin Wang wrote:
>>> When running stress-ng on my Arm64 machine with v7.0-rc3 kernel, I encountered
>>> some very strange crash issues showing up as "Bad page state":
>>>
>>> "
>>> [  734.496287] BUG: Bad page state in process stress-ng-env  pfn:415735fb
>>> [  734.496427] page: refcount:0 mapcount:1 mapping:0000000000000000 index:0x4cf316 pfn:0x415735fb
>>> [  734.496434] flags: 0x57fffe000000800(owner_2|node=1|zone=2|lastcpupid=0x3ffff)
>>> [  734.496439] raw: 057fffe000000800 0000000000000000 dead000000000122 0000000000000000
>>> [  734.496440] raw: 00000000004cf316 0000000000000000 0000000000000000 0000000000000000
>>> [  734.496442] page dumped because: nonzero mapcount
>>> "
>>>
>>> After analyzing this page’s state, it is hard to understand why the mapcount
>>> is not 0 while the refcount is 0, since this page is not where the issue first
>>> occurred. By enabling the CONFIG_DEBUG_VM config, I can reproduce the crash as
>>> well and captured the first warning where the issue appears:
>>>
>>> "
>>> [  734.469226] page: refcount:33 mapcount:0 mapping:00000000bef2d187 index:0x81a0 pfn:0x415735c0
>>> [  734.469304] head: order:5 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
>>> [  734.469315] memcg:ffff000807a8ec00
>>> [  734.469320] aops:ext4_da_aops ino:100b6f dentry name(?):"stress-ng-mmaptorture-9397-0-2736200540"
>>> [  734.469335] flags: 0x57fffe400000069(locked|uptodate|lru|head|node=1|zone=2|lastcpupid=0x3ffff)
>>> ......
>>> [  734.469364] page dumped because: VM_WARN_ON_FOLIO((_Generic((page + nr_pages - 1),
>>> const struct page *: (const struct folio *)_compound_head(page + nr_pages - 1), struct page *:
>>> (struct folio *)_compound_head(page + nr_pages - 1))) != folio)
>>> [  734.469390] ------------[ cut here ]------------
>>> [  734.469393] WARNING: ./include/linux/rmap.h:351 at folio_add_file_rmap_ptes+0x3b8/0x468,
>>> CPU#90: stress-ng-mlock/9430
>>> [  734.469551]  folio_add_file_rmap_ptes+0x3b8/0x468 (P)
>>> [  734.469555]  set_pte_range+0xd8/0x2f8
>>> [  734.469566]  filemap_map_folio_range+0x190/0x400
>>> [  734.469579]  filemap_map_pages+0x348/0x638
>>> [  734.469583]  do_fault_around+0x140/0x198
>>> ......
>>> [  734.469640]  el0t_64_sync+0x184/0x188
>>> "
>>>
>>> The code that triggers the warning is: "VM_WARN_ON_FOLIO(page_folio(page + nr_pages - 1) != folio, folio)",
>>> which indicates that set_pte_range() tried to map beyond the large folio’s
>>> size.
>>>
>>> By adding more debug information, I found that 'nr_pages' had overflowed in
>>> filemap_map_pages(), causing set_pte_range() to establish mappings for a range
>>> exceeding the folio size, potentially corrupting fields of pages that do not
>>> belong to this folio (e.g., page->_mapcount).
>>>
>>> After above analysis, I think the possible race is as follows:
>>>
>>> CPU 0                                                  CPU 1
>>> filemap_map_pages()                                   ext4_setattr()
>>>     //get and lock folio with old inode->i_size
>>>     next_uptodate_folio()
>>>
>>>                                                            .......
>>>                                                            //shrink the inode->i_size
>>>                                                            i_size_write(inode, attr->ia_size);
>>>
>>>     //calculate the end_pgoff with the new inode->i_size
>>>     file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
>>>     end_pgoff = min(end_pgoff, file_end);
>>>
>>>     ......
>>>     //nr_pages can be overflowed, cause xas.xa_index > end_pgoff
>>>     end = folio_next_index(folio) - 1;
>>>     nr_pages = min(end, end_pgoff) - xas.xa_index + 1;
>>>
>>>     ......
>>>     //map large folio
>>>     filemap_map_folio_range()
>>>                                                            ......
>>>                                                            //truncate folios
>>>                                                            truncate_pagecache(inode, inode->i_size);
>>>
>>> To fix this issue, move the 'end_pgoff' calculation before next_uptodate_folio(),
>>> so the retrieved folio stays consistent with the file end to avoid 'nr_pages'
>>> calculation overflow. After this patch, the crash issue is gone.
>>>
>>
>> Thanks!
>>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks for reviewing.

> I just skimmed over the AI review:
> 
> https://sashiko.dev/#/patchset/1cf1ac59018fc647a87b0dad605d4056a71c14e4.1773739704.git.baolin.wang%40linux.alibaba.com

Thanks. Zi Yan also sent me the AI-generated comments, and I don’t think 
this is an issue.

> And I'm not sure if it has a point, in particular whether
> i_size_read(mapping->host) could return 0 and underflow file_end.
> 
> I'd assume, in that case (truncation succeeded), also the
> next_uptodate_folio() would fail.

Yes. If truncation has succeeded, next_uptodate_folio() cannot find a 
folio. If called before truncation, next_uptodate_folio() also checks 
i_size_read(mapping->host) and returns NULL:

max_idx = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE);
if (xas->xa_index >= max_idx)
	goto unlock;

So I don't think this will cause a real issue if 
i_size_read(mapping->host) returns 0.

