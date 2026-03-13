Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3441D106FD7F
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 05:15:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53D986B0005; Fri, 13 Mar 2026 01:15:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51F4A6B0089; Fri, 13 Mar 2026 01:15:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44B516B008A; Fri, 13 Mar 2026 01:15:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 322A06B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 01:15:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BD01D1CA82
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 05:15:00 +0000 (UTC)
X-FDA: 84539875560.12.04FBD10
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 00464120004
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 05:14:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773378899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L9OP7lKE5gxaYrmEDXUKFA8H88EoMb0/F6aUZ5qTcYg=;
	b=vs9y/u9T6+4qLamTgGLDEwrYjtYVVmcJVipHsgUVlMkt0U0FPYwZg0AfxYvO42AN2LS7Se
	6gZa86bBbQNmpq30lMW2t777s6hgQSqzGyOWmkOsKx6yKjkdFdPksNZMEcgH+UzUp5ubp6
	ZNs6dH4q31U49l+9MYe4LWsxpxmZGC0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773378899; a=rsa-sha256;
	cv=none;
	b=6FueDER0Y35C/bNciIE2P1FkZhajbuXT06ocFUB/bZ/pwZaUoIdNPxXAevkGnAQWuDzjdi
	/8NrLuq3bXuLuK9nDNF+bjNVz87s/3Xz7l6SAVPyoWA3o4mCPeJPRxTHTZyHer5qgPYbWX
	Fb5aSxZ2Sfe9h1gWceUlTPecR3wogQE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB378176A;
	Thu, 12 Mar 2026 22:14:51 -0700 (PDT)
Received: from [10.164.19.59] (unknown [10.164.19.59])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8F40A3F694;
	Thu, 12 Mar 2026 22:14:53 -0700 (PDT)
Message-ID: <c7e8ac1c-0486-4e41-a62c-0917054b2fa1@arm.com>
Date: Fri, 13 Mar 2026 10:44:50 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: filemap: fix nr_pages calculation overflow in
 filemap_map_pages()
From: Dev Jain <dev.jain@arm.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 willy@infradead.org
Cc: david@kernel.org, lorenzo.stoakes@oracle.com, kas@kernel.org,
 p.raghav@samsung.com, mcgrof@kernel.org, dhowells@redhat.com,
 djwong@kernel.org, hare@suse.de, da.gomez@samsung.com, dchinner@redhat.com,
 brauner@kernel.org, xiangzao@linux.alibaba.com,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <066dd2e947ccc1c304b54e847fbe628dccea1d7c.1773370126.git.baolin.wang@linux.alibaba.com>
 <0890a207-354e-4da1-80c2-67754354a6a6@arm.com>
Content-Language: en-US
In-Reply-To: <0890a207-354e-4da1-80c2-67754354a6a6@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 00464120004
X-Stat-Signature: c1mjc5uqrhuaihejs37ef83gd76d53sz
X-HE-Tag: 1773378898-875479
X-HE-Meta: U2FsdGVkX1+1UMgCP3Msgj8EpLQ0amFCIefV1ntORzhBlL1XAgDjcE1aOjGLd5w0ilZDPsxyit8TSpwO3RT+oE9ObKkKF7EUuzrgrYJQrjac1DZFFy/z0JVHEelV7ry9qfnhgkstDigF7pLfsBcf+HGPqC9RURAirX64QfXEw5MoFZR2EEwqp23909y15wZ0qRV7Jwiu19JMdKyBksxDiBQPBcp5qUkeBS2x4z+amP16hoD/hTph05eTco3iZbQNQQqbixM0dfGz6up2QadDaC9DMRp2Ob3sGFiEkuvKbhwVjbIJaoBXYApgmLHXzKAa217mepQGY/Qno0gMmsci76uqcZ3avHq/WNDfY5JWMaQierIPcrYHqs8ITBFZmP33JdsQp1qwrmisVVKvejZW27O6iUbRKHXM1i/PJ/gVNR7yUybt42KA1Tw12N0gnzK4AX/BudcdU/zKfb/DIQz4oVw+4EUX5foEm1avY2UqspQt72aOqBQ0BwBbVM1SbECiBVPlWymKsLvXWdb678SX+F9uWH7j5C44zSbCDSv+4zZ9KQuBQl0uLGsojFAvcCh5cNksGE2pFcP+lYllSuzi6vqpwLa4tYwjt9briR4YB0fSI9SqaPTNkck1Fo9XGXqtNGRotUXssyxrT2nENGcM9r9XD4qrTyfVaiu3rLGMy5sxec+3gG4yu1nUwIcU78sU6RpTiwxCO/RS3W3TLxZ91Qc9mZx5jXkVNgB6g/vTfEqODXZuIen9eS+xcZSN8nKNUKcqE0lhopz4/pXxPQK79I3Wlky4LL4Swj2ioATdqnnFA69xUDyggbUbYylmIjlm1CEoRYrP4vHXqm8MwHCsyuzO6+QSm0oFcWIPE/ID2Uf9jSlLfmC+mDpZo9qkfJ/HqY46xEbQDM5IMRi83khBDc6q1w252ziSK6ejV6EptqyYCHg8wm/YZui1sco2nAJDZ3o+tOI9vkz3z3c7BZX
 0GbhRK5n
 37kTI777g829zwzUDP53l8koXp1m6t3qGmUGvy5blxO9YBiqm7MVq887m1cLM2nMitnNKNtN6hOZS58X9XsAPdqfbJ1ILIb9Q6aciJxFzE2COJCfpa4mtgvqkHi+SO1TVzudxPJI2+pLUyaSGrFF/fn2wB3K08TcFiL4Hlq2FhiPtplsqPAYVSvgSuH9Afsxc5kGhDRvGVn0e2p5UPBMeKLvW9/0BcQt5lVQ9QkLzC7guCg4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13/03/26 10:41 am, Dev Jain wrote:
> 
> 
> On 13/03/26 9:15 am, Baolin Wang wrote:
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
>>
>> By adding more debug information, I found that 'nr_pages' had overflowed in
>> filemap_map_pages(), causing set_pte_range() to establish mappings for a range
>> exceeding the folio size, potentially corrupting fields of pages that do not
>> belong to this folio (e.g., page->_mapcount).
>>
>> After above analysis, I think the possible race is as follows:
>>
>> CPU 0                                                  CPU 1
>> filemap_map_pages()                                   ext4_setattr()
>>    //get and lock folio with old inode->i_size
>>    next_uptodate_folio()
>>
>>                                                           .......
>>                                                           //shrink the inode->i_size
>>                                                           i_size_write(inode, attr->ia_size);
>>
>>    //calculate the end_pgoff with the new inode->i_size
>>    file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
>>    end_pgoff = min(end_pgoff, file_end);
>>
>>    ......
>>    //nr_pages can be overflowed, cause xas.xa_index > end_pgoff
>>    end = folio_next_index(folio) - 1;
>>    nr_pages = min(end, end_pgoff) - xas.xa_index + 1;
>>
>>    ......
>>    //map large folio
>>    filemap_map_folio_range()
>>                                                           ......
>>                                                           //truncate folios
>>                                                           truncate_pagecache(inode, inode->i_size);
>>
>> To fix this issue, move the 'end_pgoff' calculation before next_uptodate_folio(),
>> so the retrieved folio stays consistent with the file end to avoid 'nr_pages'
>> calculation overflow. After this patch, the crash issue is gone.
>>
>> Fixes: 743a2753a02e ("filemap: cap PTE range to be created to allowed zero fill in folio_map_range()")
>> Reported-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
>> Tested-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>  mm/filemap.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/filemap.c b/mm/filemap.c
>> index bc6775084744..923d28e59642 100644
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -3879,14 +3879,14 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
>>  	unsigned int nr_pages = 0, folio_type;
>>  	unsigned short mmap_miss = 0, mmap_miss_saved;
>>  
>> +	file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
>> +	end_pgoff = min(end_pgoff, file_end);
>> +
>>  	rcu_read_lock();
>>  	folio = next_uptodate_folio(&xas, mapping, end_pgoff);
>>  	if (!folio)
>>  		goto out;
>>  
>> -	file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
>> -	end_pgoff = min(end_pgoff, file_end);
>> -
>>  	/*
>>  	 * Do not allow to map with PMD across i_size to preserve
>>  	 * SIGBUS semantics.
> 
> I am wondering whether something similar can happen in the do-while loop
> below this code. We can retrieve a folio from next_uptodate_folio, and
> then a massive truncate happens and we end up mapping a large folio
> into the pagetables beyong i_size, violating SIGBUS semantics. (truncation
> may back-off seeing the locked folio/increased refcount in filemap_map_pages)

Read the bracket text as - (truncation may fail to unmap this folio seeing
it locked or with elevated refcount, therefore the illegal mapping stays
permanent)

> 
> 
> 
> 


