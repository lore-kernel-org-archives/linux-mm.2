Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B4CFFF6E7E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 20:49:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C3A36B0088; Tue, 17 Mar 2026 16:49:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79B386B008A; Tue, 17 Mar 2026 16:49:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68AE46B008C; Tue, 17 Mar 2026 16:49:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 569CF6B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:49:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0285216025E
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 20:49:46 +0000 (UTC)
X-FDA: 84556746414.10.326AF96
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4651518000B
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 20:49:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bqxwsTyh;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773780585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ddyOUP0htmsRXm9OallAlRsiQ9Hj0BtkfFu+xXX+Ek=;
	b=x2XyGL2G20Y0UBe9GdRQXH45LyjViakRfXcfH/32rQdaDo5ZEIjEr4wjI5pIjshpILW1Xe
	vPfJM0w9d4epUjlA2UYY5yahk/klLP9tbcUAiydLxnjs34Xf5txbmXe1nFVvPr8puzXkGH
	IZW1CywjxYg1mDdkxXyzfP7xxs8bRcM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bqxwsTyh;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773780585; a=rsa-sha256;
	cv=none;
	b=jPU6NdDF+6yreIo2qQzhfJsHS14Q2j4l5uVkS4a7yN05e/BZmYbtGleqnAObhGIZnxd/oN
	Mk0Xzv6JfCag701wgBoqKUknENdhbtHkI+sKBqWX1++1TYZCRwNxjDIVl9264BhrdIUe7q
	v6zJxsHVG0RePndIYZSn9hlVuTSDY0M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A89B76091C;
	Tue, 17 Mar 2026 20:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6423BC4CEF7;
	Tue, 17 Mar 2026 20:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773780584;
	bh=dib+t883jjXBJ597zrrU43ouSELyxkYdR0rm1sYYh2g=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=bqxwsTyh2/WRTSkMtCg+asur/mX9EB67RTFniApswkXFVqM1YMWzO3B69vQoz6X7U
	 qjsArsAkHI5kAoN3MXpgws9EoNaVIGOjR1YEmkJ0BIhqd5HTojwInULoKILQT0/gBp
	 OcFdEn+A3oSWWWnL66Cyc3CEUvGvavlibj9GAPBE5nItnoJX6o+c/wij2XAW9XiVcY
	 6torzdTAWqR3XmCXqye9YPWPWbx0kgpSvRxcBpu0oFsZBH4bU+NhhmcpNeqAHYQpZW
	 YepEXaenR8/b17VR93u33Bvf5qVS5kbiXxiL0cJcubE1DJ6JXIlru7X7GZlYP5ZsTZ
	 EQgNWvzwGx/bQ==
Message-ID: <82019011-023c-4bce-a524-6eab119f0a4a@kernel.org>
Date: Tue, 17 Mar 2026 21:49:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: filemap: fix nr_pages calculation overflow in
 filemap_map_pages()
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 willy@infradead.org
Cc: lorenzo.stoakes@oracle.com, kas@kernel.org, p.raghav@samsung.com,
 mcgrof@kernel.org, dhowells@redhat.com, djwong@kernel.org, hare@suse.de,
 da.gomez@samsung.com, dchinner@redhat.com, brauner@kernel.org,
 xiangzao@linux.alibaba.com, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <1cf1ac59018fc647a87b0dad605d4056a71c14e4.1773739704.git.baolin.wang@linux.alibaba.com>
 <9d968181-95a9-477e-9aa0-763117e4d1a0@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <9d968181-95a9-477e-9aa0-763117e4d1a0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4651518000B
X-Stat-Signature: mmzw1m59ewutuyzuek8579ranxgaqba9
X-Rspam-User: 
X-HE-Tag: 1773780585-353361
X-HE-Meta: U2FsdGVkX19hoUpAkMFYbJynBP+YKPW/SmjGzPbhFJlIEsfW1O+1VtNxINQAii6dM1Xl1LKXT31SYqQedwSxhU9NfayaBA6107gaepkrtZpdqiVWdI7Nq07ux5pYK+/F0Ro4PVVV286pv+H6IyQI39CxUALhCJLdypYoQRTp7VthkBZRTR0szjwq9hPlUua7P4Q/vAtunsqYfHLpzBZ4N8FS/3bJCzFIMt68xi4GprGvLxz5xEdKu9lylPnblFgDmEZveS2Xb5augem/E3hR4WZcbH9Qwz8qpoSIzVrtX4eWo39yK0dta7RrlOwh2/YpTchb3a8TpMWe/lcxbTVaJjesyRBO0+aOBcVmXTR3XOxQ38KCXnc4Iizvd910zDL3Inalom4XO8QR/XUWY6mjYJzPwPoXTc7186OdAs5qIMDzK9gloZ5tlUBsIpQJG5I52bjHGnGaiUxBkuVLQs+c2j+MvAW/SezOOdq1nH95uB3vLLMfad/pcKfYoEigTfWABtWGkMa1TP6FTwZnEmnRY6ACJb5oqv0MxTaRW7g5fL+jbJVFdcOwVltynnj9ijmA+nHBwnOOF1CWBico0T6Bps1xlcIsCrCkcq9oxDxzyX53McK5qMPGgwKL4bkFXqjkidgnQMW/GZ+kfnhzlCErhJO8Qbeu82zY3t8Eu6/1nh0udXR+31esrgAEdeOJDppUkg/DUkGUpeYiawTpGAhwV04gmkeFmIUj9cp8BK58SI1PBrs79Vy1jU7H4TFCJTsdhBa6T7OTS7oYxnJ+haSyqbDeYSyr8Us7sdpkdTdWpZ+TZrUaYJ1Zn+Zq+bUDogPjRh2AuWbMltxJlTLmKdmjFs17jSBHi9Xz5YUjSaq9miIZZsGzs8wfI/P00bkSZHTRk/rVT3czkKMpAYmEWUHaFTvUpEJuFvo3gOwyI5YyvsjCEAq5soKkAqdF8cvnGP1Sba9yOSJpeeMHEL++KIL
 7CHVGmyZ
 op595BJicSfNnjP2N7ckHSVHu9GpaDMYQRoQNEjAZvvLtScIUEk5Bc0xzZemjtRn+CeYqk5xB9ByxS9HhOG4O21/TO6o1r21oBe8TLmHK5r8Z6lIWzkdDXZYgr9e/hqT6mlyb+ePPcMQF0ARbDumzR16j7EsqoMVlHOajtgLuTUJ+Dd9VyIv+D1KbeBJm9nzyH0uy1wsR56WRnjgMqdCDa2hxsPoZCI+DY85Ep12kvi2nhcTXNlAuEftSrS7cXCZao8Di4OZbd9Fie/EiHBQ6Sac2uMGlRd846u0NIO2juI3Y/dQqNcd/AwtYJbzJr4DnvB0O/egvkfDwpwCBcOEkHFUA6rb0h3E9JwpiDuvZXqjGYp2oKbrgXsjq7MxhaJNaCDmEQbWm2Zg0cTWRFxO/pEKkKFKLHCiXk7IVBtIcyaPq1+V6vcDLJ1Hp/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/17/26 10:37, David Hildenbrand (Arm) wrote:
> On 3/17/26 10:29, Baolin Wang wrote:
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
> 
> Thanks!
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 

I just skimmed over the AI review:

https://sashiko.dev/#/patchset/1cf1ac59018fc647a87b0dad605d4056a71c14e4.1773739704.git.baolin.wang%40linux.alibaba.com

And I'm not sure if it has a point, in particular whether
i_size_read(mapping->host) could return 0 and underflow file_end.

I'd assume, in that case (truncation succeeded), also the
next_uptodate_folio() would fail.

But it's tricky :)

-- 
Cheers,

David

