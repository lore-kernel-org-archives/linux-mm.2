Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DE08FB5E97
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 01:05:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C3A16B0005; Mon, 16 Mar 2026 21:05:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 674876B0088; Mon, 16 Mar 2026 21:05:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58A786B0089; Mon, 16 Mar 2026 21:05:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B0356B0005
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:05:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BC153C1CB4
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 01:05:01 +0000 (UTC)
X-FDA: 84553760802.10.D937F43
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9B34FC000B
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 01:04:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=S4u0coRT;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773709499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IjQSFS0itEQzM5rr+GWV/Figi9xDYU/T6PhEBKJz3LI=;
	b=ENa7QY5BB2Vg7F6ZPTeAgnXvxqXFCO8jykHJGApLmCe4FjzFzYJh8LaEFUf/+QjIrRuFqC
	X38C/OvBFHKawiTvZp91Gqpefmuj8toZEhfSi0XUVALm7spwzmxuE9IpcyR+MPL5Mmz5cc
	HHSEz/1WsX3tM/R6OQqUyA5JAjwSqB0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=S4u0coRT;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773709499; a=rsa-sha256;
	cv=none;
	b=B10boBRWPpPYKk6h4XDh4A9VNvD+6n6tjYdMxpf2GDbolGsJKbE8dYlwg8g89H/WqoD9Zm
	mcAHEWZLIeRt+hJU/FwNutwYL51XB1GTzcEjGbZfEl4s/TkuOZIP8XXoAqqiBA7vT6HnLS
	hTI/150bmK0ynk2ubg3/RFwHkpOIL24=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773709495; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=IjQSFS0itEQzM5rr+GWV/Figi9xDYU/T6PhEBKJz3LI=;
	b=S4u0coRTa7rYbBj+ExX37wMKJe5XpXrcS2A5vi0edayMw1OxU40mP6puk7IOsUU8UHRQxcwridSqoCSD1m9gNqlFNzyqFkxkTgpF6A93kizv2L0fYhc9QLD8VZOQid0bvjNodOKE/z8fwamay2wOjpKq6aApyjgCXy5NxG1xhKw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X.9.3Ty_1773709492;
Received: from 30.221.57.233(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.9.3Ty_1773709492 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 17 Mar 2026 09:04:53 +0800
Message-ID: <cca9a1e9-eff8-4d37-87d4-46e8e736e893@linux.alibaba.com>
Date: Tue, 17 Mar 2026 09:04:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: filemap: fix nr_pages calculation overflow in
 filemap_map_pages()
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org,
 willy@infradead.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 p.raghav@samsung.com, mcgrof@kernel.org, dhowells@redhat.com,
 djwong@kernel.org, hare@suse.de, da.gomez@samsung.com, dchinner@redhat.com,
 brauner@kernel.org, xiangzao@linux.alibaba.com,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <066dd2e947ccc1c304b54e847fbe628dccea1d7c.1773370126.git.baolin.wang@linux.alibaba.com>
 <0890a207-354e-4da1-80c2-67754354a6a6@arm.com>
 <c7e8ac1c-0486-4e41-a62c-0917054b2fa1@arm.com>
 <726ee101-6978-49f6-8f2b-edc7f8d99074@linux.alibaba.com>
 <abfwUro4rJw7u5d5@thinkstation>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <abfwUro4rJw7u5d5@thinkstation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B34FC000B
X-Rspamd-Server: rspam08
X-Stat-Signature: zesejoqhafa57gq1ob3ox1geat7njdmk
X-HE-Tag: 1773709498-297554
X-HE-Meta: U2FsdGVkX1/2gtxYcOFjTvCPabWoQAD8PC6IHUGhFH1mRZ7SB6nvCP4t9JE+21pQ5nCnDw/TxD3j7Bqr/Wj5nYndBQ2GNq+s6sxmxCyIWd4XYtE967dJTcQFHCzslPkM2r6CW1+bjJYx889h5FJocCQ/cMnIagbV1IZNR/K6gzJ/aQFYO/8JsvT7UCL/6/bqD43EiYMDKjVlKydf7o0s/1UCDtHvYsMLFbUbHc7V9pqKuYIGaCa7gCT/wSjEkrKTOUCBrB8HDmcyAr4zysNJOSRkuadL1lCM9HDkvcNPJOgcniQub2qCH/LyDU0wKSGjl3APpxNynH2UsBL3Cv0vhkALi7F/1E3J8PC5ozb7q1Q39KOrAHaY0IXWi+UYVDLZ5ubxVsIJI/y/5PDPZci6WAW7g1Xh7GPLlWUURV+KdQONR+cOKT5yx2iMA90AgZxqHfmUieNx6S0Acp0iOoevqHVXyiZ2jiALmFXUB9K9u9GrY+VAMGFnDQTdWzgMeYhLjfHwmGQui29Sq7qAmJ8Ajv0BFecl9cIA6iK+NowRdjjrXaQ+0or5FMVhwNaXNzKZ8cOhCxlfRTBMD2Af3DVwUy+4jTiN+PY2IO/ZQizHCyZlt6sYI+3SDI4qkU19UNkCsSGHBrQHN3GxrepwFfWbNso5I31/Zhg9cx6voa7+7F3mj3xCuGvl9QSkAlaCIeandwtgoq417i1gvUbc02prpFyEB9qfuGIZrZ9aD0m7xmavpdAn/vlI0bbLgdGFCvdDoZBvkqn6y4DlpJrLbeekCCitxO9ZIDbpII/aV7+OiFQQnTYlbbDzMiHnRRDUC/GTIKBtzhCwuhPJLWZENi6Y/W7clAmfsMLtgm/UZw9g71y9GJBjSd8kvhHoWpGrAv5/zOxk0i/Q9Gwzeo17qnf3PiQHqmN1ujyaeS5oqjKeMG8xGEqYaFjv1aRlrTEfBWAKofLvnYeLquH/VCBQiGS
 Yu14pXUH
 /MHkw69YtrYnzl+DOlpCZEn20GJd+SdKY14M2+lDJVn2g7YJgmEMy5mIPZ/Q6ZDym92Zg0/nYgINNb6Iq5ia8TinAzRJMvupYNLWMj+2ksHJ8um3T1OAohnfvppEUyJALoQlM0J4hF4b6iNo2fnvivI+ZWq6beUqfwGW29ITrczla2fxCfh/08+xhN3/USRFhyKifJU0sbm8/PqKolm80VJia1094/MyCRDCBWVkFjOBH/x86KewFqG3edSq5J5teiVU4fkerIXHPWLdRsAVfZZgyznxpuX97CBqHuAhVUEWwMuPfDJxX1XCqqtggkR1eTlt9etF3y1E2gwXnb7UWtOh7DJevACdy4QyptN2rovKwLFAuzKkOSGZtPLkDlYOxtRFK8Gmlah9Zv5A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/16/26 8:00 PM, Kiryl Shutsemau wrote:
> On Fri, Mar 13, 2026 at 01:54:31PM +0800, Baolin Wang wrote:
>>
>>
>> On 3/13/26 1:14 PM, Dev Jain wrote:
>>>
>>>
>>> On 13/03/26 10:41 am, Dev Jain wrote:
>>>>
>>>>
>>>> On 13/03/26 9:15 am, Baolin Wang wrote:
>>>>> When running stress-ng on my Arm64 machine with v7.0-rc3 kernel, I encountered
>>>>> some very strange crash issues showing up as "Bad page state":
>>>>>
>>>>> "
>>>>> [  734.496287] BUG: Bad page state in process stress-ng-env  pfn:415735fb
>>>>> [  734.496427] page: refcount:0 mapcount:1 mapping:0000000000000000 index:0x4cf316 pfn:0x415735fb
>>>>> [  734.496434] flags: 0x57fffe000000800(owner_2|node=1|zone=2|lastcpupid=0x3ffff)
>>>>> [  734.496439] raw: 057fffe000000800 0000000000000000 dead000000000122 0000000000000000
>>>>> [  734.496440] raw: 00000000004cf316 0000000000000000 0000000000000000 0000000000000000
>>>>> [  734.496442] page dumped because: nonzero mapcount
>>>>> "
>>>>>
>>>>> After analyzing this page’s state, it is hard to understand why the mapcount
>>>>> is not 0 while the refcount is 0, since this page is not where the issue first
>>>>> occurred. By enabling the CONFIG_DEBUG_VM config, I can reproduce the crash as
>>>>> well and captured the first warning where the issue appears:
>>>>>
>>>>> "
>>>>> [  734.469226] page: refcount:33 mapcount:0 mapping:00000000bef2d187 index:0x81a0 pfn:0x415735c0
>>>>> [  734.469304] head: order:5 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
>>>>> [  734.469315] memcg:ffff000807a8ec00
>>>>> [  734.469320] aops:ext4_da_aops ino:100b6f dentry name(?):"stress-ng-mmaptorture-9397-0-2736200540"
>>>>> [  734.469335] flags: 0x57fffe400000069(locked|uptodate|lru|head|node=1|zone=2|lastcpupid=0x3ffff)
>>>>> ......
>>>>> [  734.469364] page dumped because: VM_WARN_ON_FOLIO((_Generic((page + nr_pages - 1),
>>>>> const struct page *: (const struct folio *)_compound_head(page + nr_pages - 1), struct page *:
>>>>> (struct folio *)_compound_head(page + nr_pages - 1))) != folio)
>>>>> [  734.469390] ------------[ cut here ]------------
>>>>> [  734.469393] WARNING: ./include/linux/rmap.h:351 at folio_add_file_rmap_ptes+0x3b8/0x468,
>>>>> CPU#90: stress-ng-mlock/9430
>>>>> [  734.469551]  folio_add_file_rmap_ptes+0x3b8/0x468 (P)
>>>>> [  734.469555]  set_pte_range+0xd8/0x2f8
>>>>> [  734.469566]  filemap_map_folio_range+0x190/0x400
>>>>> [  734.469579]  filemap_map_pages+0x348/0x638
>>>>> [  734.469583]  do_fault_around+0x140/0x198
>>>>> ......
>>>>> [  734.469640]  el0t_64_sync+0x184/0x188
>>>>> "
>>>>>
>>>>> The code that triggers the warning is: "VM_WARN_ON_FOLIO(page_folio(page + nr_pages - 1) != folio, folio)",
>>>>> which indicates that set_pte_range() tried to map beyond the large folio’s
>>>>> size.
>>>>>
>>>>> By adding more debug information, I found that 'nr_pages' had overflowed in
>>>>> filemap_map_pages(), causing set_pte_range() to establish mappings for a range
>>>>> exceeding the folio size, potentially corrupting fields of pages that do not
>>>>> belong to this folio (e.g., page->_mapcount).
>>>>>
>>>>> After above analysis, I think the possible race is as follows:
>>>>>
>>>>> CPU 0                                                  CPU 1
>>>>> filemap_map_pages()                                   ext4_setattr()
>>>>>      //get and lock folio with old inode->i_size
>>>>>      next_uptodate_folio()
>>>>>
>>>>>                                                             .......
>>>>>                                                             //shrink the inode->i_size
>>>>>                                                             i_size_write(inode, attr->ia_size);
>>>>>
>>>>>      //calculate the end_pgoff with the new inode->i_size
>>>>>      file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
>>>>>      end_pgoff = min(end_pgoff, file_end);
>>>>>
>>>>>      ......
>>>>>      //nr_pages can be overflowed, cause xas.xa_index > end_pgoff
>>>>>      end = folio_next_index(folio) - 1;
>>>>>      nr_pages = min(end, end_pgoff) - xas.xa_index + 1;
>>>>>
>>>>>      ......
>>>>>      //map large folio
>>>>>      filemap_map_folio_range()
>>>>>                                                             ......
>>>>>                                                             //truncate folios
>>>>>                                                             truncate_pagecache(inode, inode->i_size);
>>>>>
>>>>> To fix this issue, move the 'end_pgoff' calculation before next_uptodate_folio(),
>>>>> so the retrieved folio stays consistent with the file end to avoid 'nr_pages'
>>>>> calculation overflow. After this patch, the crash issue is gone.
>>>>>
>>>>> Fixes: 743a2753a02e ("filemap: cap PTE range to be created to allowed zero fill in folio_map_range()")
>>>>> Reported-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
>>>>> Tested-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
>>>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>> ---
>>>>>    mm/filemap.c | 6 +++---
>>>>>    1 file changed, 3 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/mm/filemap.c b/mm/filemap.c
>>>>> index bc6775084744..923d28e59642 100644
>>>>> --- a/mm/filemap.c
>>>>> +++ b/mm/filemap.c
>>>>> @@ -3879,14 +3879,14 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
>>>>>    	unsigned int nr_pages = 0, folio_type;
>>>>>    	unsigned short mmap_miss = 0, mmap_miss_saved;
>>>>> +	file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
>>>>> +	end_pgoff = min(end_pgoff, file_end);
>>>>> +
>>>>>    	rcu_read_lock();
>>>>>    	folio = next_uptodate_folio(&xas, mapping, end_pgoff);
>>>>>    	if (!folio)
>>>>>    		goto out;
>>>>> -	file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
>>>>> -	end_pgoff = min(end_pgoff, file_end);
>>>>> -
>>>>>    	/*
>>>>>    	 * Do not allow to map with PMD across i_size to preserve
>>>>>    	 * SIGBUS semantics.
>>>>
>>>> I am wondering whether something similar can happen in the do-while loop
>>>> below this code. We can retrieve a folio from next_uptodate_folio, and
>>>> then a massive truncate happens and we end up mapping a large folio
>>>> into the pagetables beyong i_size, violating SIGBUS semantics. (truncation
>>>> may back-off seeing the locked folio/increased refcount in filemap_map_pages)
>>>
>>> Read the bracket text as - (truncation may fail to unmap this folio seeing
>>> it locked or with elevated refcount, therefore the illegal mapping stays
>>> permanent)
>>
>> IMHO, the truncate_pagecache() will call unmap_mapping_range() twice, and
>> the folio lock and refcount will not block unmap_mapping_range() to unmap
>> the folio's mapping (only hold ptl lock).
>>
>> So the truncate_pagecache() can still truncate large folios beyond i_size.
> 
> Yeah, we serialize here on the folio lock. It should be safe.
> 
> The fix looks sane to me:
> 
> Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Thanks for reviewing.

