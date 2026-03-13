Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0833106FD7D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 05:54:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B40FC6B0005; Fri, 13 Mar 2026 01:54:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC4D46B0088; Fri, 13 Mar 2026 01:54:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C6B16B0089; Fri, 13 Mar 2026 01:54:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8ED676B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 01:54:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3BDB5160813
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 05:54:40 +0000 (UTC)
X-FDA: 84539975520.17.C504B92
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 78C931C000D
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 05:54:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YPqiFVgC;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773381278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oczUtkjqR/GKMWS4UhWTZ6MNDRiOWQJyorrZCEgN1Dg=;
	b=wXyzVSNgyJF/IcXpe2PCzEXIVZjOW+53uBEaH9jFEingU4mPbmJEJmyRgzuRP3Kzlu2dP2
	ZP5pjUAdYJEekHTUZ/BMyL1hY2fa5q9B3K/rlI0baWNCsRM0zxCjVVNUslZ1Wsx4nAwlHK
	FkoX737NsCILf9WrpRyvXMet8G7md4o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773381278; a=rsa-sha256;
	cv=none;
	b=VFPnUQdWPER1XzRZkA6MCe0GitCqFazWqxD4lkL6it+ECcCG9xIle440QzoSm0Ij5PzHZU
	v3VcFwNWPB5tKMf0A93WwRoIy/ofhvoU4aBQqDrCju7Te4v66aMjDukt/Khu9PiC6K5zmu
	Ikt3TznaG5ok3OKjEhgRunKGqbOs+lI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YPqiFVgC;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773381273; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=oczUtkjqR/GKMWS4UhWTZ6MNDRiOWQJyorrZCEgN1Dg=;
	b=YPqiFVgC2yNS5n5t/Fc6HwEFCa4ocq7Jl3c1B+9wZk4YDVwtA1Q39U5gwV3vJ+R2lXDMrIWjgvXG6FPuhgnFY/uHjpbUPNEBZ9ohK7P/YLF3Z0ytOEHMTO+PK1tR68bw8aWNeYi+lwWTRveTQGq4BDiDCS9Q+cqJ9fJ6mYagpbE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R841e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X-rAXAR_1773381271;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X-rAXAR_1773381271 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 13 Mar 2026 13:54:32 +0800
Message-ID: <726ee101-6978-49f6-8f2b-edc7f8d99074@linux.alibaba.com>
Date: Fri, 13 Mar 2026 13:54:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: filemap: fix nr_pages calculation overflow in
 filemap_map_pages()
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org,
 willy@infradead.org
Cc: david@kernel.org, lorenzo.stoakes@oracle.com, kas@kernel.org,
 p.raghav@samsung.com, mcgrof@kernel.org, dhowells@redhat.com,
 djwong@kernel.org, hare@suse.de, da.gomez@samsung.com, dchinner@redhat.com,
 brauner@kernel.org, xiangzao@linux.alibaba.com,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <066dd2e947ccc1c304b54e847fbe628dccea1d7c.1773370126.git.baolin.wang@linux.alibaba.com>
 <0890a207-354e-4da1-80c2-67754354a6a6@arm.com>
 <c7e8ac1c-0486-4e41-a62c-0917054b2fa1@arm.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <c7e8ac1c-0486-4e41-a62c-0917054b2fa1@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 78C931C000D
X-Stat-Signature: 1kki1958kr49krpaa3nmb3gw9ajxcdhx
X-Rspam-User: 
X-HE-Tag: 1773381276-319453
X-HE-Meta: U2FsdGVkX1/C8n3p2+enJVp2x/VQwl595IoBWAIB/s7n0TYtKkpfi0HVrDcEo82AwoLVILUugfNe8JxZ7kEgufslInxKmR8JOdZtIQsKWrk8zgxN5Xnd/AD1pDWl2UTyBYTiakHJaJlaizaSysfwEwLd+P7gbh4Uq3y/FieO0HXt7ZomZYMC9hWIu2ofbFuSgXEIboHgdbYseLkHh4ginGye7zsdoIUa2Qcx3Fx3st2V/6Lqt1nM8aKdAmSs1Pss6HT8FYJ7yAhPr9g6eoio6khkfW/aDIM369zxCYGes7B1jS+gW7ePYRuHBmxahXa5581ccvk/P7R0HycMu1t3Mi12eZsYcC4NJtuAXn+xt635d7CiIAchTBgVO8QYVYcKbTNSXwkGm3DJP3OPY/USipWbvue8ohtWDn8KE7wkTsWVmJcbEepXRaqx6ydHPlnFoAG0m4Jcqm+Lt9n2dz94Jm5WickwQUvWjfRNF4gAmTnN57TfIXIecFsFlg1lMV9mLW/XXW4n9AgxJ0HYkoxnGW/dzhPuiKusuNZAZaqkF1V2Vz7mJqkU7Drad5BWNIzZUcibI7EYnTkx8PClnZqJsXnqHXT7i8NMVBS/QkW25E3PeGaIQcffw5NuxoBMtZOqY6Aq1KG7cAQlYNMXxNrOY+l0Hs42ZopxuOE1Po7k0uyDfHq4gO0mHardQZFACj/d2hUUbbYI2fbDJjWiVPumFsby3Nzv9x4zTu9KEQJ4NJztGpBiqbFfT7n4lEiq6qL+2sM/Wzi7VHqioe8//cOlmlW4s/6D4P2S+THjP3JdYNvn9Bqjb7XYZttQI7R/ES07EjmgIqqa4zrorAMO1BiuV4xqE8DTcJMlJodv6plIDZDrGRddQYRVzl2zqLBCry/7N1yFG0mxG3FHfys0fiTTttqDErH7yuOEoTAPNPSKkp/gp3sFigjIqbBOge6/1bbl6zMWGZfFOdXjYfw7aQr
 X3+pnlpx
 eSQ5iThqq3kBI90i3IGoXwGmz14X847sVgf/wLSKO6V9B2vBkncuHSyzUz7caC2N7AIW4OoGx14pE2IqWemR/svmBZ99rUIwuAl1amK5satgEhlD59KyTGdSsCOIrT7cyGNmB/fDhOhI3ppMGmGJv4dI4t6OmrOCqhLLiR8wXyvwUQeY+HNTkgYCjNVcgeWNuqqW6aDmLGFQ7WpjBtcnnPDqZv0xoKsqHnIvNFSj7QFOamiTG2cHB9M83gXGBHmfDNe69THSOgcTV3N6ICanDiF/BomT7JkImw9cV4HjRkxUbyzGgUiWNjgKYyLbzIMJK6ehtK0uCq88UizwgII0ss7os/wJT6C6Sm018M6Dz82i3KfOst2Ylb8PvOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/13/26 1:14 PM, Dev Jain wrote:
> 
> 
> On 13/03/26 10:41 am, Dev Jain wrote:
>>
>>
>> On 13/03/26 9:15 am, Baolin Wang wrote:
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
>>> Fixes: 743a2753a02e ("filemap: cap PTE range to be created to allowed zero fill in folio_map_range()")
>>> Reported-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
>>> Tested-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> ---
>>>   mm/filemap.c | 6 +++---
>>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/mm/filemap.c b/mm/filemap.c
>>> index bc6775084744..923d28e59642 100644
>>> --- a/mm/filemap.c
>>> +++ b/mm/filemap.c
>>> @@ -3879,14 +3879,14 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
>>>   	unsigned int nr_pages = 0, folio_type;
>>>   	unsigned short mmap_miss = 0, mmap_miss_saved;
>>>   
>>> +	file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
>>> +	end_pgoff = min(end_pgoff, file_end);
>>> +
>>>   	rcu_read_lock();
>>>   	folio = next_uptodate_folio(&xas, mapping, end_pgoff);
>>>   	if (!folio)
>>>   		goto out;
>>>   
>>> -	file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
>>> -	end_pgoff = min(end_pgoff, file_end);
>>> -
>>>   	/*
>>>   	 * Do not allow to map with PMD across i_size to preserve
>>>   	 * SIGBUS semantics.
>>
>> I am wondering whether something similar can happen in the do-while loop
>> below this code. We can retrieve a folio from next_uptodate_folio, and
>> then a massive truncate happens and we end up mapping a large folio
>> into the pagetables beyong i_size, violating SIGBUS semantics. (truncation
>> may back-off seeing the locked folio/increased refcount in filemap_map_pages)
> 
> Read the bracket text as - (truncation may fail to unmap this folio seeing
> it locked or with elevated refcount, therefore the illegal mapping stays
> permanent)

IMHO, the truncate_pagecache() will call unmap_mapping_range() twice, 
and the folio lock and refcount will not block unmap_mapping_range() to 
unmap the folio's mapping (only hold ptl lock).

So the truncate_pagecache() can still truncate large folios beyond i_size.

