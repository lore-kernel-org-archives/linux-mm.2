Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CF60C54F51
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 20:45:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 000EA6B00AF; Tue, 28 Jul 2026 16:44:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECA696B00B1; Tue, 28 Jul 2026 16:44:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E07C76B00B2; Tue, 28 Jul 2026 16:44:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BCED46B00AF
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:44:46 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4769B12041F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:44:46 +0000 (UTC)
X-FDA: 85039364172.29.8E9340E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id C6F6B40011
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:44:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dl+rfaiT;
	spf=pass (imf11.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785271484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zkJgvL5cRVJ0qHx2GRGP0XkrlNl3kn6ET+UT28ycGEc=;
	b=gMJ3CGTxQVsSrNbNJe4uJQL71N3LTqTQjav/cLMD6uB8YNP5jroftU3jDeT1sSjUSvYF9m
	kdFBb/BvEOZ5ErBuGCkCF2EDXwav8Ib3KCu20RJh/Isdf/+zjkyH2Yt3rU81slU9I04cwI
	FzafFDCpu1w29/eZYPoTcBPItQysHWw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dl+rfaiT;
	spf=pass (imf11.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785271484;
	b=e+b5kgC4TzTNYItgL/fWGE1iphPxLNMpqSFP0G6j9+/P0l5xP9EMIOxVcUNn+WYDyeok8K
	yP6SBWFescNj2jdo1qtNhMFIjYE9MUqyLX/fwrpxPo49EntgJeOf1iLB9HQju0Yg1wwLqg
	MMygooWoemOvo3s+b6QQ/FCr4WELT1U=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=zkJgvL5cRVJ0qHx2GRGP0XkrlNl3kn6ET+UT28ycGEc=; b=dl+rfaiTgRa+Fw10iqJ8SlPBV+
	+uS7QuxIDOODOnfQ0k8dNQBXp2V0V+nPHJrm3sYnB0vlXWTS/zedOsTV4QYxZuPC9qltb6QjYKTB0
	B2NIAhwnAMR0zD0EaKuLXGQBYJHDdPCR3evYB14ypswAqlDJoxX6rOgxkPE5cBT03K575TfUk/wqQ
	zuvzsSgUyiNTzkL1XWs2fCV0mBhV+rSc21/FMJdxiI7p+fdskwzSkq/iyulIgEd+xruRPqdqXEjg6
	GquWz1FAG5dwzXPzUXoL0xUL9bCNQQOqEJJ4MvgzKVVrphRkQ9RwClNLcNEbROvxDKxfIZz3lLEj7
	lV/PFBRg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wooeo-0000000EFWN-2cqU;
	Tue, 28 Jul 2026 20:44:10 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: [PATCH v7 00/13] Use generic_file_read_iter() in hugetlbfs
Date: Tue, 28 Jul 2026 21:43:52 +0100
Message-ID: <20260728204409.3396238-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C6F6B40011
X-Stat-Signature: rwyif6r4fpxosk9pxhd5eeehgycet7yf
X-HE-Tag: 1785271484-932109
X-HE-Meta: U2FsdGVkX1/KENheEYZAGzVCteTllC00qUMH5jIMAQsAG+UiChUP6KElLR4PW8VmCQgAEYsaS8mTn4E6d5dTOVTlAmRF69pwgtQSfYO+Qf5Wc0Unuy71mV4VMhj9RY7hRg467+Vx631B4Zh24pjsmYUuCIDAVcIJ3lzDO2IZdmNEJQykTpyqiokaQs30YEg4CHy7Xuq3vaz9cKABTKoGNfvI25vlxXYE/XbqqqlqbivCVEUIYZXLiIhhNYMRl0WzdXbguxvJXV8WKjOcv73U+nIfvK83P79mRYJwC7stCCP4N6L84HEKtpWCWnkdT+idbmyRxG3pjAcYTcQ3uQ0HpRHLqWnrbma8kzt7IIDKkpWy30d7intZ08aJfehjZw6U/FXF1IkH3CLlZ9DMvf9rQYOWsQJUpXKqfx58y6PV6Er5Ar8v58+ZLfq4ILZtf08D38l8wBP3QVHOMmNP2MbfqXk1AACBfNayJoQmfHouvxXG2QvQqWZr+eKpBCOODPZf2iA6KHqDBj1eeoR5yEcXQSG79r5Lt+RGGAtN6/ndI2cEIb1pCrbVZIrgkICS9nWWopCIpvILCDI1A5f0Ypij50ETYots84zhVXmwgOZwNHR+F1JKyDCOHr3rm74wYRA9VhX0aDOo8zXZmodpKyxbDx6MQATyL52li6Su6J95atnZ+LHBV43qhRN51JhYeeyJkA7jnlAcClCbYzcWeGKwy27EnQQ4QJ9iEmHMgrVaq+svaBkuSzI0U6I3xfW/lAVAhjnH9kk48elmnd66Ph4bVYgLjybBbYE+SNPCKEYADH0Jf+NFOre53c418RAHhluGchtxn8Lj6opyK14u3OQhEAyh/NhX5wT/6rGEgryM0XYU4LblGhSh863nsjTORPc424xlrprzq+rsaAErrKzVY5EiSUKpihQGWdT6J41rqC/cYbb6QRDccySZsOby3O2CjmDBLqqwY7rhsLZBAG2
 tWAF4o2u
 U8TuaNi0wdHn330llzxucSExONgAi3P9QjEA28AUVL+nFyqJ/bT8c+aUJAVoFuD5gSEaVVGrD3ek14dQKlze9DD7CFfLKmNqHeTQyhtyOJ2Hq9qmvFIcihrchFp3qHIsq86FnS40WzAa43/3XTqg+nMFMi75wzC8/1bG/nLv/1POX6ysfi7flzFD60yDlQn9NRb8G/NldjFF6ODxEvHGXzo8ncUQ5WSe3wc6OEQxbC5oRIP7T3mU55UZ241hHvpr2uULVrAFKsjPJOeIvv2pgqjOdTTe/+95j1QMoGsLfqz5vDzIgiZGZ4e4fZtJZQnfi/cGnr8ETOp4vxW1b6RNaw/mbKygdFIT4pgKqhQHzjw412maId5pEVXiuNiTxBZFZ2P55Voy+TQGbMsJIcwUjr7zkqBZzwu1L+odrZBa8rN5E/HQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This set of patches are separated out from Jane's earlier series.
https://lore.kernel.org/linux-mm/20260617172534.1740152-1-jane.chu@oracle.com/

We need three things to use filemap_read_iter() instead of a hugetlbfs
specific read_iter: hwpoison handling, treating gaps in the pagecache as
holes, and having hugetlb set the folio size in the mapping.  hwopison
handling turned out to need a lot of prep work; the other two things
are fairly straightforward.

Sashiko complains that the implementation of AS_AUTHORITATIVE is
incomplete, but hugetlbfs doesn't use any of that functionality.
We'll add it when we need it, either when hugetlbfs uses it, or when we
convert shmem to use filemap.

v6 here:
https://lore.kernel.org/linux-mm/20260727181310.2671972-1-willy@infradead.org/

Changes from v6:
 - Add folio_clear_hugetlb() helper in hugetlb.c to make sure we move
   the hwpoison flag to individual pages before clearing the hugetlb
   page type.
 - Add missing spin_unlock in an unpoison_memory() error path.
 - Add some R-b tags

Jane Chu (2):
  filemap: Add hwpoison handling to filemap_read()
  hugetlb: replace hugetlbfs_read_iter() with generic_file_read_iter()

Matthew Wilcox (Oracle) (11):
  memory-failure: Fix hardware poison check in unpoison_memory() again
  mm: Rename folio_contain_hwpoison_page() to folio_has_hwpoison_page()
  hugetlb: Mark some function arguments as const
  guest_memfd: Use folio_has_hwpoisoned_page()
  hugetlb: Move poison to pages before clearing hugetlb page type
  hugetlb: Use the has_hwpoisoned flag
  mm: Remove locking mf_mutex in is_raw_hwpoison_page_in_hugepage()
  mm: Check individual hugetlb pages for poison
  filemap: Remove checks in mapping_set_folio_order_range()
  hugetlb: Set mapping folio order
  filemap: Add support for authoritative mappings

 fs/Kconfig                 |   2 +-
 fs/hugetlbfs/inode.c       | 123 +++--------------------
 include/linux/hugetlb.h    |  24 ++---
 include/linux/mm_types.h   |   4 +-
 include/linux/page-flags.h |  63 ++++++++++--
 include/linux/pagemap.h    |  45 +++++----
 mm/Kconfig                 |   6 +-
 mm/filemap.c               |  51 +++++++++-
 mm/huge_memory.c           |   2 +-
 mm/hugetlb.c               |  41 ++++----
 mm/memory-failure.c        | 197 +++++++++++++++++++++++++------------
 mm/memory_hotplug.c        |   2 +-
 mm/rmap.c                  |  43 +++++---
 mm/shmem.c                 |   2 +-
 mm/vmscan.c                |   2 +-
 virt/kvm/guest_memfd.c     |   2 +-
 16 files changed, 346 insertions(+), 263 deletions(-)

-- 
2.47.3


