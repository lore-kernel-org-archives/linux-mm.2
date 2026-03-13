Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7857F106FD7F
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 05:11:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D563D6B0088; Fri, 13 Mar 2026 01:11:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D049B6B0089; Fri, 13 Mar 2026 01:11:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0F926B008A; Fri, 13 Mar 2026 01:11:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ACD236B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 01:11:56 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 587B81607EA
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 05:11:56 +0000 (UTC)
X-FDA: 84539867832.13.7F57FCA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2D9061C0004
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 05:11:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773378714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lHyRHpc+ZSfbkpL9G6wSzMHvFbKkJFMbdQHZtKhA6ss=;
	b=qv8eFC4rtDNYY8W0IW1/Plhyoq8ICuo4aX7Ph5eI/DgovjgZvJAE9iiTYtIZhheNK9AZi+
	bIMfyVzkGuKJGyrrgdDN4GPXH5WW+z03/4Oo6k7FYcijViH8D7jLuJ1fghF4FRqNb9DMU/
	SZn7t+gTpsX56f+Ak9S0ocu0ZFOG1W0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773378714; a=rsa-sha256;
	cv=none;
	b=NEbKVMlBJncwQdwlMN7TovDNTqt8YGivh6P4qXIX75tAKHIIehvLcOrCmLxIXUBeIzkWNE
	iTIBAs9BOJDuu6lWYIl3kTBjIl+jEW82Xdh8ug+eChjmmoU/9xMMslnylvafFFWDPx141E
	hYm1FTAxO2EIa5Dig4Got61D+5NnbII=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EAE36165C;
	Thu, 12 Mar 2026 22:11:46 -0700 (PDT)
Received: from [10.164.19.59] (unknown [10.164.19.59])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9B3853F694;
	Thu, 12 Mar 2026 22:11:48 -0700 (PDT)
Message-ID: <0890a207-354e-4da1-80c2-67754354a6a6@arm.com>
Date: Fri, 13 Mar 2026 10:41:45 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: filemap: fix nr_pages calculation overflow in
 filemap_map_pages()
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 willy@infradead.org
Cc: david@kernel.org, lorenzo.stoakes@oracle.com, kas@kernel.org,
 p.raghav@samsung.com, mcgrof@kernel.org, dhowells@redhat.com,
 djwong@kernel.org, hare@suse.de, da.gomez@samsung.com, dchinner@redhat.com,
 brauner@kernel.org, xiangzao@linux.alibaba.com,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <066dd2e947ccc1c304b54e847fbe628dccea1d7c.1773370126.git.baolin.wang@linux.alibaba.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <066dd2e947ccc1c304b54e847fbe628dccea1d7c.1773370126.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2D9061C0004
X-Stat-Signature: 3yo1i1mqthcpujz9degbn4ioobiejuc5
X-Rspam-User: 
X-HE-Tag: 1773378714-659126
X-HE-Meta: U2FsdGVkX1/AMxPl7k5rLy7bQc7T/7ee+6I/tMnfymqxYCRteFgl9fsG+fjMmXUXg2EpfLUd5IRGQS7OE5zZ4HWx50nIXRQ3S2EzZpw87wZVyM3jXCUcgtRCXK/zdn4uDDTpezfpUHwyJiqb+Cxxq/h7JKgTD/Dmbp5HKmswv+YbmtxfM9HzJ1Jm7s5SUZLuFWS5I3TJiHBfoUGetn6bS2vcKPBglRVQVs+myGNQa7ug2SklOXtpAAVZ0jFZ7DSOOYV7j5wjUeg/lB0VHdSo8hOlPsrOtcw898En4NTvQ/ZTQDqg3GsTsDYVqu7SOjVs0JsszGsv95rdHeYG9jA/BG/2a9+KCrI14EeKmOs9X/kUi1CZYdBEEY7bmzZYD7InHdCQv2L+8ewrf4Hv5eZfJKCVPuc8zU8B9itchEvUJTu9W1ra8FU5j9hXU9mO3XIhI/mHIhG5fPkUcg8XR3KaJkyiSTiiOC1MH0ZIpHj21B3JVaycvL691pBFFbgVAgf12cEItDYYKzmLNlLsDRhrIwlEidS0aD0/5PTQ7+MKlBpWZiAEtSP5f6GVVenINrxonuol6258+Lp2R5vwyLBwRHzrZdLqna7RBz5YfJvheYqrjX1j2fRMI9TDVvWoHrOpru47A0lrOuGvZBeZFOxyCt6PDVJnv/EkCe27DZPwkhmVpx3V2TqVKXS3UM+wRuzcwQDBHsDEL6izcSbzZOw3dHXZytjaom2KY0V2h40IjgwCrkKF0ZADa+LdYmmrD4Zxzxap9bOKI5oUIp9z/hc0xkyrVem/xlIxwvpUfZhpUREo/WtchtYruYJw4Y2mzaq6JI0hNe4CeMjGQROWK2O1QwnbXiZR9vQNrm+08dKgD/C0zkjY7gM+/vPxs28osM1li60rrqAWBt8QtYLI4wJDxyruZdbRNnroVeC7UU8RNOyXDmyBmdZyy96dGTZ3/+oa1XEi1n18DXCzPr1DOc+
 xip4629y
 75pfIPYJAn4Mh2tSraaMkK0bOkW5oIML/oo0tDY3uI4ylLsZJ6p690ilH/KnBdtWcU5FTqFRqZ0UJlT7TL0u5cXewhQtlbwU4yZFfcpuoEF3a49WW0FLG2g1CJE57cUO5X+0l01H7r456N3p/ldoqAvYx7hK0eb8xkz/T6a63IuG40i9+/kBrqcE8R3eqsvuaCBBMlrL10VN9XBJuOk5uXtwVgxYKcmF/eMckGuILJUU0GsM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13/03/26 9:15 am, Baolin Wang wrote:
> When running stress-ng on my Arm64 machine with v7.0-rc3 kernel, I encountered
> some very strange crash issues showing up as "Bad page state":
> 
> "
> [  734.496287] BUG: Bad page state in process stress-ng-env  pfn:415735fb
> [  734.496427] page: refcount:0 mapcount:1 mapping:0000000000000000 index:0x4cf316 pfn:0x415735fb
> [  734.496434] flags: 0x57fffe000000800(owner_2|node=1|zone=2|lastcpupid=0x3ffff)
> [  734.496439] raw: 057fffe000000800 0000000000000000 dead000000000122 0000000000000000
> [  734.496440] raw: 00000000004cf316 0000000000000000 0000000000000000 0000000000000000
> [  734.496442] page dumped because: nonzero mapcount
> "
> 
> After analyzing this page’s state, it is hard to understand why the mapcount
> is not 0 while the refcount is 0, since this page is not where the issue first
> occurred. By enabling the CONFIG_DEBUG_VM config, I can reproduce the crash as
> well and captured the first warning where the issue appears:
> 
> "
> [  734.469226] page: refcount:33 mapcount:0 mapping:00000000bef2d187 index:0x81a0 pfn:0x415735c0
> [  734.469304] head: order:5 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> [  734.469315] memcg:ffff000807a8ec00
> [  734.469320] aops:ext4_da_aops ino:100b6f dentry name(?):"stress-ng-mmaptorture-9397-0-2736200540"
> [  734.469335] flags: 0x57fffe400000069(locked|uptodate|lru|head|node=1|zone=2|lastcpupid=0x3ffff)
> ......
> [  734.469364] page dumped because: VM_WARN_ON_FOLIO((_Generic((page + nr_pages - 1),
> const struct page *: (const struct folio *)_compound_head(page + nr_pages - 1), struct page *:
> (struct folio *)_compound_head(page + nr_pages - 1))) != folio)
> [  734.469390] ------------[ cut here ]------------
> [  734.469393] WARNING: ./include/linux/rmap.h:351 at folio_add_file_rmap_ptes+0x3b8/0x468,
> CPU#90: stress-ng-mlock/9430
> [  734.469551]  folio_add_file_rmap_ptes+0x3b8/0x468 (P)
> [  734.469555]  set_pte_range+0xd8/0x2f8
> [  734.469566]  filemap_map_folio_range+0x190/0x400
> [  734.469579]  filemap_map_pages+0x348/0x638
> [  734.469583]  do_fault_around+0x140/0x198
> ......
> [  734.469640]  el0t_64_sync+0x184/0x188
> "
> 
> The code that triggers the warning is: "VM_WARN_ON_FOLIO(page_folio(page + nr_pages - 1) != folio, folio)",
> which indicates that set_pte_range() tried to map beyond the large folio’s
> size.
> 
> By adding more debug information, I found that 'nr_pages' had overflowed in
> filemap_map_pages(), causing set_pte_range() to establish mappings for a range
> exceeding the folio size, potentially corrupting fields of pages that do not
> belong to this folio (e.g., page->_mapcount).
> 
> After above analysis, I think the possible race is as follows:
> 
> CPU 0                                                  CPU 1
> filemap_map_pages()                                   ext4_setattr()
>    //get and lock folio with old inode->i_size
>    next_uptodate_folio()
> 
>                                                           .......
>                                                           //shrink the inode->i_size
>                                                           i_size_write(inode, attr->ia_size);
> 
>    //calculate the end_pgoff with the new inode->i_size
>    file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
>    end_pgoff = min(end_pgoff, file_end);
> 
>    ......
>    //nr_pages can be overflowed, cause xas.xa_index > end_pgoff
>    end = folio_next_index(folio) - 1;
>    nr_pages = min(end, end_pgoff) - xas.xa_index + 1;
> 
>    ......
>    //map large folio
>    filemap_map_folio_range()
>                                                           ......
>                                                           //truncate folios
>                                                           truncate_pagecache(inode, inode->i_size);
> 
> To fix this issue, move the 'end_pgoff' calculation before next_uptodate_folio(),
> so the retrieved folio stays consistent with the file end to avoid 'nr_pages'
> calculation overflow. After this patch, the crash issue is gone.
> 
> Fixes: 743a2753a02e ("filemap: cap PTE range to be created to allowed zero fill in folio_map_range()")
> Reported-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
> Tested-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  mm/filemap.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index bc6775084744..923d28e59642 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3879,14 +3879,14 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
>  	unsigned int nr_pages = 0, folio_type;
>  	unsigned short mmap_miss = 0, mmap_miss_saved;
>  
> +	file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
> +	end_pgoff = min(end_pgoff, file_end);
> +
>  	rcu_read_lock();
>  	folio = next_uptodate_folio(&xas, mapping, end_pgoff);
>  	if (!folio)
>  		goto out;
>  
> -	file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
> -	end_pgoff = min(end_pgoff, file_end);
> -
>  	/*
>  	 * Do not allow to map with PMD across i_size to preserve
>  	 * SIGBUS semantics.

I am wondering whether something similar can happen in the do-while loop
below this code. We can retrieve a folio from next_uptodate_folio, and
then a massive truncate happens and we end up mapping a large folio
into the pagetables beyong i_size, violating SIGBUS semantics. (truncation
may back-off seeing the locked folio/increased refcount in filemap_map_pages)




