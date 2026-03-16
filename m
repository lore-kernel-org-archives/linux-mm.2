Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62234F506D2
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 14:06:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE4E66B02A4; Mon, 16 Mar 2026 10:06:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB0D96B02A6; Mon, 16 Mar 2026 10:06:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB2F46B02A7; Mon, 16 Mar 2026 10:06:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A402D6B02A4
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:06:36 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8F8A657D50
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:06:35 +0000 (UTC)
X-FDA: 84552101550.11.56DEDF2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id A6D8C40010
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:06:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oDjPz+SZ;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773669993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/OajGqp2SlAb9lsMU6syqpjyd9d51ru6PjZJfX1/yZ4=;
	b=b/hLI+dA4uNnHDv76X6WQBlxbgfOoBbYKxDIqXmNwNfevwRNL3ahVhddW4htmm4EYwm9g+
	uSU8/OcSmne+cJGdOjvJ+gckV/iX9SpqdlcFE3jnRYm06zg/ojfdZumhVPVu11vr2CWgXI
	TqPlO6XsYfsYqZne4GhjoLro2iML9mE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773669993; a=rsa-sha256;
	cv=none;
	b=TGzodcxHniiij033YkyBG/09KbsHYr9FLzDxUXbeFormUAKTgl3l80/q6hak7J9YE8aRUI
	1iBDQZiDr/YMn2jRMKHg4l7/oEpBPSbeC3NLmitT3L/ApCjUzmoT4ch+GD/pPIEX96ULCf
	zWBK74h6y01L60N19pnJvglCx2ItGzw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oDjPz+SZ;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B86A741992;
	Mon, 16 Mar 2026 14:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74DBC19421;
	Mon, 16 Mar 2026 14:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773669992;
	bh=afd4vFerHZuZDwwYgkareto4P7ZyDLUT2vOOmWWvhME=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oDjPz+SZbJH+CX/UgG+Y8rgCIz/PyCjUzfp6dusJq1X2Hnk5ei6U1Z4Ij3fHTYi4m
	 CjgiCnA+XPR0hp3sGEa5UWoADfs9n2BBjTwu8g6RgHp5hTQO8BoFPhZdXIjHsw0LNr
	 xtRsyYPrij1pBCmo9KUbT3C8HqYNKmCijkk23B4MiwrUp/e7DiFEFYTWWzOujMJ5XB
	 FusXnuDNop4d3wqSVDJiu+YY6zhmPFFRKVUggmW0Dtxqdr2jYrmFpjytJWXfhkck/q
	 Gluaa0k6qwbpjG2xDygJR54Zob1cHwuAlgL3j1YHSXWybzPSHV3Ezi2VPIW8O9Hz9n
	 KADxaiZTyooYw==
Message-ID: <a5625929-736b-4ddc-a8e3-30e3aa54df12@kernel.org>
Date: Mon, 16 Mar 2026 15:06:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: filemap: fix nr_pages calculation overflow in
 filemap_map_pages()
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 willy@infradead.org
Cc: lorenzo.stoakes@oracle.com, kas@kernel.org, p.raghav@samsung.com,
 mcgrof@kernel.org, dhowells@redhat.com, djwong@kernel.org, hare@suse.de,
 da.gomez@samsung.com, dchinner@redhat.com, brauner@kernel.org,
 xiangzao@linux.alibaba.com, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <066dd2e947ccc1c304b54e847fbe628dccea1d7c.1773370126.git.baolin.wang@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <066dd2e947ccc1c304b54e847fbe628dccea1d7c.1773370126.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3hy37rmspsqq9bxxfrh4npyq4rs5yxf9
X-Rspam-User: 
X-Rspamd-Queue-Id: A6D8C40010
X-Rspamd-Server: rspam12
X-HE-Tag: 1773669993-159438
X-HE-Meta: U2FsdGVkX1+JrUHiCP29bAvX7ugKa/IRsaZWJ8fkORwRcmgqVh2ffxoCYWMLz2ujVR/X46gO8x72lIUdnRhCsbI2N1udetnYP+f1X8POjhuoG8/DvIdLYkiiMjN7zNEMj9h3hoC7bEpcohh0AXdkz55PGk6qXMZ4CorIsehTVsx1G865Bebu8v+EZuSrZpvoYnyGgqsD8ixwcc1FwBG+ACDJCfYEMBD9kg7PINaO59ua4l1BkKxeqM14vwxOtk6GEvxAXKUnmmpXJ8CF8jbEKxUc6VfitDLbMnew+PF85E4uMmNfTG2fzafIOv0oxfAcL1ifDQDbt+Jc2VniQbpn3FiZpWdMdqcAh6AFdWTeJBjMoAJKMfmmct4qmtkoGFRBCRiNqlXdgBOfcRCP9gAh8OHpu7y/k4miUqSBt18zN8Np6mFDvfBw1gWw4qBIVlUIepG09RXqIydK7IZ7UhcnzvX+poaQvVI6ypqx4C+qa32W+mNNcyCoQE6DDzBAIEjXZKwsnnSx2k4035s779T1TtBwUoSiyvw0uCI6qAUTADhD8OVyZO2v7zB7bUr5lO/+meTcXtcZURRM9w6SzzR81aXyiYAm03Hcsbo3H57aAPVP6Qi8506igNSTvLpfuEWYyOpnchxBhnb5TsOikNEgWhphZAXpeObfSfiqKGudPj5CL4kmjyaB554YSmWYwmDZBYzSRUAyOiVSZ6ppP/a+0PqHaPtKsds2NikhJLilHNu8zjz+l+6MdD+5kbRgg3NSCcbGPpvMiGSTej3NBR6lR2OXRSyFJOPYsXTfUNMLf8IvDh2d2uASd6yP814aXoI2pFs2upLqu/UkR4YSoj7ESlwHr3/PuNueoUp5H4d2MgJg7GVhns0dmFADeavPiBUYJ1iPYbCiIPalHj0/HANVdQiAdN5bAM5+iI/v09jyB6N5moka95eKRg+vs9V9az6wkWg0owNxok96CIra6tk
 42uNeXaK
 Anq050vFlEAFqLA11ICHhznw5N1WjgWOLIi0DDfsZthD+AybjYcOgfIEku7DbllXw6PEfJZ6UVL+2Dwf3Ae9/dA4URP1/bD2GgJZB6vcH1fRe06v75wDpCwUwKzxRUZF4TX+5D4ztXaK4GvngTyUgjf3y88XoEPCjorLT4VVtLlL5dlxY/QLUczDu0jDcFHmC/aulcdlkI3AQ4TL5SiWmlAwA3R4wLZClQuUk747UldTtSQiUhir3OvqTH4BRzHMySFL5eyD4dSIybAWXCCd9SEzQc+TZzlMAmPrlTz6jjtG16TsSNEd0q296llNI0trbhDOvK77vjAiNdv4DljiXmT57ZOBQTvEQBWvxRPVyYD3UQiVrS0jW3QcJJpNfLIeO+HYgVEkdR3TfdGsuFsxhFLikourIQXOpZG9srNtNbhXDV3k41efJOUvxDRibU6x0K76xfI6aFAeYKho=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/13/26 04:45, Baolin Wang wrote:
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

We had a bunch of similar reports throughout the last year from syzbot,
but always without a reproducer.

In particular this here:

https://syzkaller.appspot.com/bug?extid=c0673e1f1f054fac28c2

via

https://lore.kernel.org/all/6758f0cc.050a0220.17f54a.0001.GAE@google.com/

Could that be the same root cause?

> 
> By adding more debug information, I found that 'nr_pages' had overflowed in
> filemap_map_pages(), causing set_pte_range() to establish mappings for a range
> exceeding the folio size, potentially corrupting fields of pages that do not
> belong to this folio (e.g., page->_mapcount).

Sounds quite bad.

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

This certainly sounds like stable material :)

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


LGTM. I do wonder if we want to add a comment above the file_end,
stating that this really must happen before the next_uptodate_folio()
to handle concurrent truncation.

-- 
Cheers,

David

