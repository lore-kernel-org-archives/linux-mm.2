Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB60AC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 14:25:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E76066B00A7; Fri, 10 Jul 2026 10:25:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E53676B00A9; Fri, 10 Jul 2026 10:25:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D65076B00AA; Fri, 10 Jul 2026 10:25:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B539F6B00A7
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:25:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4F25640495
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:25:42 +0000 (UTC)
X-FDA: 84973090524.18.4A612D9
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id B480E8000A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:25:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HrOLXIlJ;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783693540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1VlKCpo+tnRr2SOFJ9r1et+U9+XWbDNAx+XfTXQ4ZpM=;
	b=iXxjImjxyj7fH+cxR0U868NxgI9M30YA8dMgHaF9mk9acmJsrAPoXyg0oXQYWTe5Djsphq
	jNHgyloHZoAQggUwcgjMRAAmzEq9Vln6J3sxVZfCeYhegll25+SszXMqynHyoMeUx0ookk
	xeaw7FI1gMCv7yFJC7/F2b6uDc5/Lmk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HrOLXIlJ;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783693540;
	b=inmE0mxVADBJnwtL7XAIg6zQCy9comq97nptSk5xRDMf7FbGfZiMQrEgj05wWxkZ7KHP6d
	k9E4FEywS8SI7dqDQ6EbZPM858YdEmkESY3UG5aLjw9avzsJy1kNmRqRJ4gOuDf6EBqrG5
	HSnl32kr3iFdztQ9ZPpaMJhQNOo84sA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783693535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1VlKCpo+tnRr2SOFJ9r1et+U9+XWbDNAx+XfTXQ4ZpM=;
	b=HrOLXIlJK5byvxMRl92Xt9Qe8BH9aa97sbTEINkk6Tl1g3pRas93d3bcKawXhxT4wPQSH2
	pUVy4GlMnPr0RDwlU+9UJT9dIuS7ZGqUPO7aQcEEzvGXQBanYYA0jXc9PaBax+GsITsfCw
	JKZWwia7gUFzCW5BmNzi7XeiOzZU9LU=
From: Usama Arif <usama.arif@linux.dev>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2 00/10] Use generic_file_read_iter() in hugetlbfs
Date: Fri, 10 Jul 2026 07:25:16 -0700
Message-ID: <20260710142517.1022940-1-usama.arif@linux.dev>
In-Reply-To: <20260709184740.1286561-1-willy@infradead.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B480E8000A
X-Stat-Signature: k9rtwaf8zqero4683yh8dhr945obrkzf
X-HE-Tag: 1783693538-188196
X-HE-Meta: U2FsdGVkX19sZRk1ya9hFJd7WabWegEy52uSbSqFXoeZek6+QVzIk2L7KyIVUPksujEyBgmy7wi3T3607Zs4HVlQ6aCscZRSSBPQabu8WscqgEBDDEqOuSiwFWjWhfEZMG7YPHo8xIcRdYkEmljrseeR+ETNxl6TfiRRv9zPFt/KlpWF9s+m6Ky4fCHQ6x55hCgPwvMsZ7MMOY7XFdXL+xEPcK86CdZv6YmKs/CHiUYm4MdO44eaTsmO7XKaInkZgYppyIIqJz7i0zTEz3V0Ltym+eDL1ovqqQvRGHMAc8w7RPuWlf+vDLvC/9cwHShLgbH3faMqSW4ztY43UZYPQEY3ktDUvmm8eY0vohG7NtykpZgfhH7srzwGDXoP24xorewLJIXlzy5mzasfxTvAg5xOkT+cxGpnfTp6VM+E3XR52BIKLxRz9u11COb1i3mrIvDZSWjTIPkdwS6HFmBZqsS5iJ54B3YJv3xTtUhGRbt+t/mF66xMiMK7wt4a7lCZnHFSwu32MymSAEkXaFyKBe3in3+gmaz8AaBc0q65r+m4u4iqC7rMBSLmPzHmYZ9E6iLNIVpII9M/IfYJZa+3R8pGC1ccM5VcJSJPZGjHIdbL33LQaJ+rhq0RZPTu8m6ZzjdMPpNIC4HrKdm7v5iFNsV5JodcIoptPiEYzUJnq17/KKox7iqqM+HJ/QXAnRI/xT+j7aKbVet7xeuPMCY1caGJOjdDNtYfI1LZ04xQ/chvXRHaUL0EfBp1/1txaIyyTs0qitxls4D6f3IXCOWpjBrGUNWvnXO2vQrRYpA5JF6Y4dxe1Ta2ase/NobKC6ovqmzmPWOEYHJwyqiWDmiCtCLsv6n4YvRZxBg5bzkAVbyGJ0hpGgTKb8gmu8zb2eP4+to8IyZRPmb7SmNgmtUmww7wCjA3p+IHhXeIRg4j4dZQ9gAMMJgMPWu4SGNYQfYD58CcRltv3vQlPdxAu9W
 nVcltei8
 ArxBMbqMINj9xkdg4HFYWe5GhQVq+Y/UtyQG2crGi4OCm/EzkC3bSqLUqK9IBbADTt64+wXSPoACwtP3RsRvFpn4pMIcGWeJlP7BcRK8gNzR6c5n86dFsoUAKD5HxuuCKLdWuzuiHDX/LYiID4b43bk9jeR3+XeCMz0JjE9GFvA2HUhJsq5snhhv4LdIcjwOpvcTaIlKBKbx5P5yFI0Ia0laYSa4TcX9U16Du+/nxIoW/maWOGag1UWx4u086Ps3bjC/owph+CF5KjGrLnen6K7tFZpFGR6wYB8U2LMGpQDlIu65AkDh297HQcRSLOqrSeb6e3OVr4BA2PajymePj794bniFF55LVPqYRNTtjP0FIbtKhvH8HDkigXwJRx5mw5hO0Ic9/DA4gXKz/Qjf19TlihofYlih62dhBYcTLIbu2tuk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  9 Jul 2026 19:47:28 +0100 "Matthew Wilcox (Oracle)" <willy@infradead.org> wrote:

> This set of patches are separated out from Jane's earlier series.
> https://lore.kernel.org/linux-mm/20260617172534.1740152-1-jane.chu@oracle.com/
> 
> There's enough potentially controversial things in here that I think
> it's worth considering them by themselves.  First, handling hwpoison
> in filemap_read().  I want this for shmem as well as for hugetlbfs (a
> later patchset, maybe).  Second, handling misses in the pagecache as
> holes rather than opportunities to populate the pagecache.
> 
> v1 here: https://lore.kernel.org/linux-mm/20260707181713.208282-1-willy@infradead.org/
> Sashiko had a lot of valuable feedback on that, and that's all addressed
> here except for the things that I don't think are relevant.
> 
> Jane Chu (2):
>   filemap: Add hwpoison handling to filemap_read()
>   hugetlb: replace hugetlbfs_read_iter() with generic_file_read_iter()
> 
> Matthew Wilcox (Oracle) (8):
>   mm: Rename folio_contain_hwpoison_page() to folio_has_hwpoison_page()
>   hugetlb: Mark some function arguments as const
>   filemap: Remove checks in mapping_set_folio_order_range()
>   hugetlb: Set mapping folio order
>   memory-failure: Remove raw_hwp_list_head()
>   memory-failure: Prevent UAF in raw_hwp_page list
>   mm: Handle hugetlb correctly in is_page_hwpoison()
>   filemap: Add support for authoritative mappings
> 
>  fs/hugetlbfs/inode.c       | 122 ++++---------------------------------

I really like the deletions here in hugetlbfs :)

>  include/linux/hugetlb.h    |  24 +++-----
>  include/linux/mm_types.h   |   4 +-
>  include/linux/page-flags.h |  28 ++++++---
>  include/linux/pagemap.h    |  32 +++++-----
>  mm/filemap.c               |  46 +++++++++++++-
>  mm/huge_memory.c           |   2 +-
>  mm/hugetlb.c               |   2 +-
>  mm/memory-failure.c        |  39 ++++++------
>  mm/memory_hotplug.c        |   2 +-
>  mm/shmem.c                 |   2 +-
>  mm/vmscan.c                |   2 +-
>  12 files changed, 128 insertions(+), 177 deletions(-)
> 
> -- 
> 2.47.3
> 
> 

