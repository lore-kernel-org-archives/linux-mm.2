Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C400C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 23:13:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A3756B0005; Mon, 13 Jul 2026 19:13:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 854FB6B0088; Mon, 13 Jul 2026 19:13:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7701D6B008A; Mon, 13 Jul 2026 19:13:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 460496B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 19:13:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 93C091401C7
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 23:13:46 +0000 (UTC)
X-FDA: 84985307652.03.9BC606A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 83D5B40009
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 23:13:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mjMeZom2;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783984425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W9YdPO3HvLe66KxCbO2DRSUYhRq6Dwyw8iqLclB4nIk=;
	b=UzGvEf+ScZUErgdOdxQvnZKYdjzEcpBTWEPngHvMzBWR2a/DRTfPemwYT5h4V2pbi7JbEU
	BsmCSGGzzohVzoxhLuPQ0+hwJQtwoc8MkojXVsR7zyrZl7EvNHiUlWObM6pJ6InfnqeKQE
	5jtthLjw7d2Zdgfitrsr0ZR5x0eVFYY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mjMeZom2;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783984425;
	b=1OnBps0wuj2PSd9mzak1X/RmsGAyC5pXRUNE8t4CwXZugzi4Tdm/csvdcTDeDWD9C7fBE/
	Swwd07IeRzumk1zFUU68vhl2zd33Pyuo/UEQnrQojYn6j1QNbRZylrJHVbM5yWl/UUvLDa
	YLtoyVsYbe/pSi386oPwFN+OwYzOxxU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE33943BE2;
	Mon, 13 Jul 2026 23:13:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1821F000E9;
	Mon, 13 Jul 2026 23:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783984422;
	bh=W9YdPO3HvLe66KxCbO2DRSUYhRq6Dwyw8iqLclB4nIk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=mjMeZom2YzBMQy3ABxE8GHcjGhlbUGC/7tDPgykX6NKNCQBeVVXAdy3Ra2Rofkbig
	 MH3s+iVevlnqMBa9adHSAhSCF5YgHmXwx1+ScHoS6nx/j1bXKLk8+L6QL2y+BhRu1Y
	 rSqhbb15zEhABqkUEyjhA3tSAriiP9pjkfQUbeRM=
Date: Mon, 13 Jul 2026 16:13:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry
 Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Hao Zhang
 <hao_zhang_kdev@163.com>, Hao Zhang <zhanghao1@kylinos.cn>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: thp: pin the inode across a file folio split
Message-Id: <20260713161341.eefb7ad32bca25ffc8f3390a@linux-foundation.org>
In-Reply-To: <20260713170915.239819-1-kirill@shutemov.name>
References: <20260713170915.239819-1-kirill@shutemov.name>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 83D5B40009
X-Stat-Signature: zowu7tjyqteoymuz5exdje9jfjaqfs7m
X-HE-Tag: 1783984424-48672
X-HE-Meta: U2FsdGVkX1/wuE5q95cze4+vfF/81kTjXnwxZ/f93ywNA5W+GVQPiS08L8V/YVpJ0GPq9ORuUBmTDuWtckzVdWnUrOTmElD4+tPByN8YMAuykUEBoQKL+Ef9Hj/Tp8x5/cd47TBEc8k4zwTE0edrbkJhnM8PlTVgiYdwU6uBwh7HDdAZrUpTxjsObkDmqmvNCoElkU6Y4nvQk57obU+tID85em4TX9s68ok6IQ8Ap+rxGWsySDT5Xc9c9Gkwk1P7XZ/dmfhhfWdDw7HWhyizzXMd+bhOBmYa17JT67kdavFcV6g+eCji7mdV8MQGGus5pNAVAAmfizM6hQ6PIdUHX6pb5ckPi8ZMK3WuTqJQZTzDp0YjNEOypXT9F+9h0TpnnKmO3rtzvNRUN4YHPu1eLcA/owoFqjSDEo/w6CnYFO2ONnSHfy4GRFxK+/5ArYDXk4bfY+hI3f4BHXFKQx0MlnJddXEKVkY2xbCmp+D+rPZY6JM9H5gxBXvv2PcBH4oz1lE87KPP1UwInw9ECeJpzsLMoEIEWbychtZUA3mGGniuGH6umk4EBEgAjg8X88JrxMi0DZlG7p8rBNLUx1TSTaJxBdYGJYL7xC+EgsXFuih0hnKa9JRQePxPj6mHyQ+c0cDFkRRERo/CvS92qU+GDAQcf/wwnMGttW/I/lv0Q2/KzZP2hv4vaAt1HnFvimmGXZ9hZso8WBFyTW/X4d7nVL41P/WIZyf+X0scZGZn5I/pHQ86PDRw9vq7sUxHqw7BX0Hb2ZMPb9W4wDv4DiN9JJXtLTCFa0CQ6l2Raw0wnKj8ynMhDzLikfjSVlNq+TL2Hfv6fB41qklPWSSo6ekms/LK9ngorRUPefju7eZNAntYmRVt7gpQkEkpOYz6KUdeO8+/5H9JHZgcIn09aYB+bv+wydhd3JIewDwvD4jFmGvfvyFN/rHV/7/lDg4gZ1D85Ud++tGXWJL1Ol+OVA2
 olK4ljlI
 dYXLlWFG+JismIJYR9K3xOXpZa6R/yemnkuMignWIKrodAslLc9r3hJUr6NhjJ+r9Z43aU2d4qe3hu+2/ptIPQUjwmVf7m90OapD8btkBf+/TN0xoPmjqrMhHjPXAF4OkRAMe2odttKFw0MZ6z321wRZ0NmYRzSPXIvr4yDTjbUyiMwmDdhA1EWfV2vl3aPFMazUju+5YH8KLYSW0YZM7642ED7AYp8pOLjC3lCve94JQJlPk8d0AZKpzY4BvdTZ9g5dEJuFHr34E78LAStHDzpEAg73IotWlgcSmOoDBFoYXNTOyUsjsdjjk/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 13 Jul 2026 18:09:15 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:

> From: "Kiryl Shutsemau (Meta)" <kirill@shutemov.name>
> 
> __folio_split() looks up mapping = folio->mapping for a file-backed
> folio and keeps dereferencing it after the split completes:
> shmem_uncharge(mapping->host) for folios dropped beyond EOF and
> i_mmap_unlock_read(mapping) on the way out.
> 
> Nothing holds an inode reference for that duration. The split relies on
> the folio the caller keeps locked (@lock_at) to pin the inode through
> the page cache: while it is locked and present,
> truncate_inode_pages_final() in evict() cannot make progress. But the
> split drops @lock_at from the page cache when it falls beyond EOF (the
> @end handling in __folio_freeze_and_split_unmapped()), while keeping it
> locked for the caller. That removes the last pin, and a concurrent final
> iput() can then evict and RCU-free the inode before __folio_split() is
> done touching mapping.
> 
> This is reachable from memory_failure(): poisoning a tail page of a
> shmem THP that straddles EOF makes try_to_split_thp_page() split at that
> page, so the dropped @lock_at is the folio returned locked. The result
> is a use-after-free, e.g.:
> 
>   BUG: KASAN: slab-use-after-free in __up_read+0x634/0x790
>    i_mmap_unlock_read include/linux/fs.h:537 [inline]
>    __folio_split+0x732/0x1640 mm/huge_memory.c:4100
>    try_to_split_thp_page+0xab/0x390 mm/memory-failure.c:1675
>    memory_failure+0x1394/0x26e0 mm/memory-failure.c:2470
> 
>   Freed by task 4601:
>    shmem_free_in_core_inode+0x54/0xb0 mm/shmem.c:5177
>    i_callback+0x4c/0xa0 fs/inode.c:326
>    destroy_inode+0x144/0x1e0 fs/inode.c:402
>    evict+0x57f/0xac0 fs/inode.c:870
> 
> Pin the inode with igrab() before the split and drop the reference with
> iput() after the last mapping dereference. igrab() returns NULL only if
> the inode is already being evicted (i_count 0 and I_FREEING set), which
> a split racing eviction can observe; there is nothing safe to split
> then, so return -EBUSY, which callers already handle.

Sashiko is worried about iput() while holding folio_lock():

	https://sashiko.dev/#/patchset/20260713170915.239819-1-kirill@shutemov.name



