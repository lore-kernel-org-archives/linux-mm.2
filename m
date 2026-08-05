Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 568A8C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 21:06:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC7026B007B; Wed,  5 Aug 2026 17:06:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C779F6B0088; Wed,  5 Aug 2026 17:06:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8E886B008A; Wed,  5 Aug 2026 17:06:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 853916B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 17:06:06 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D1EE04059C
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:06:05 +0000 (UTC)
X-FDA: 85068448290.27.7F3A498
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id 425314000B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:06:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="IfEARI/z";
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785963964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mBAMuD0vGLB0sX/9Wbvb9nt9t7JYO00L3Qa101+B9rM=;
	b=3y4z+k39hQFzdinmteAlV/FKgG7djlthSla367LgNx4+G+nrY+/fxJWKeBs9fw5eyxRGBO
	FqjDxhDtvgxZZiet2FgCDMugs8a+m2KMnESaLvq9hdGiiN01ITRkisjh8llILDeYxuUFh8
	TAq1gYJSZHz56GcK7fzm74AixzQkcIU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="IfEARI/z";
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785963964;
	b=tOgLwJ3CMO4ImMYHP5l4MWvXKsrljD6TykxUY+d7yTzz9ARpYXYdy1YMH1HyUwhXOG2JD7
	JFQbWVDATAng2XdQEnTYAvDJAJ3wsUnZcvYkZo3RQbkHQPHDfUT8RXeTaK0AhQafC80OUD
	tN90asP5IkV8AGAgkL9Oi9fPdBj5NBU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=mBAMuD0vGLB0sX/9Wbvb9nt9t7JYO00L3Qa101+B9rM=; b=IfEARI/zxUvMlo88rH2Rh62LB0
	9pGDfqLmf565OLeyt/5BU+1etI4kKoPVoBZxEs78sIpNNZt1g/PAnA4qiuoYM8GE67TirUhahem2G
	UOmPWVBgby8oi9qpWR5T197QjHb/XrEUT/wa2S9KRAvfMtFW3CWU/Hs0tcQvIZj1AoUm6SAQe5QyZ
	NZQfyQwXUB+9qnIviULYkE3pNKytQmCBEJj7hziA9gGkrX12rTZ5NbnO/YhtH5oIKGZkogiBEzwPJ
	oH10aVn7XB3Ay2kVA6+X4oEhURApPRpUo42jUSYu6ZWeptJL73QtZnLifg0bj6KlBWtpzKR5twBST
	0HBCdl9Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrioJ-00000004h63-0SM8;
	Wed, 05 Aug 2026 21:05:59 +0000
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
Subject: [PATCH v9 00/15] Use generic_file_read_iter() in hugetlbfs
Date: Wed,  5 Aug 2026 22:05:40 +0100
Message-ID: <20260805210557.1118966-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 38nny75nut6j1k3kr5a3twzka691brhj
X-Rspamd-Queue-Id: 425314000B
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785963963-677523
X-HE-Meta: U2FsdGVkX1+urvx1mvYxWR4CSnx9YIxYi2/BP3IYK0Rb/96e8azhQv8FrdlSBBT1l7ziLbKCUenAFO0aUQ3W32ZNIDLT0uSy0f0D/fRnNnHhV7JVbJztVMX0GIbgUWiScB577OUowFoyrB/ZQtlAe0RwpXfRtVsv+pj15f5cHdf6gn/qv2JlO5O2Kf4aZj3SuijBiHPwRyEMwf5/FfA70DqGg7caHwOJmn2undrSgJQMuSeLzfEpOx1ln+WVIpGyAeTdWWf3k6qSeRDz+oGXDdb+PCWss6uPelr6vunYj4kBLH5wRoEtTQ9PFuehZHI7InZ9Y1yZihifQRe85rZmzmQRn1I0qE51Le9bpByJn/pXxAuPK6hDqU6F9vcb3Gq2PCiARVq4rPYHPmd94CXn4O0cF4nl2+JFx1qNNJyS+rNHEqc6r4cQCGW11avz4wBSVyRaUAgjSNQNTCokICGrP5ypVVoboqEXiNmvIGrAtLMO/ZkoKT8ZAeUhTQxvjYxV98ad7iDFmDMuOaMGl7pjkqVZOq+t48uJPZo9AlZwFIe5vAAVgwrUoRwoA6IJJlb1BYRHejIvsHKNWy6XgXX5ultWVPYcV/6o29WbmwBxHn1qCj9G3+Ld/Ku9Qk+v7RJUuKgpjxqvvAXfU968LZwW2e2jvi2pue/ER4cQeQj6kkKt5NQiCs2qv7RJwttn1N+4MY1brM6IjHNynyeI0M7bYI2/haYg2HTX8cmIPo+r2LvYslz21LxJHTAsFFWZoWi/NzlisEdIQ2YRsuR5L+AHCYtlROXw05weuMgym6KYAKj9ElWcUQsPDzv4cOaZZABkMTwSdtOsRU9jhW7R7RxuVPMPs1h7bRIwThGCcLBIU8kojDxqengEg6Ka/C7lmv1zoMRhStb2WTT/kDCxl2Wx5PGvg3gdTar7UugV2vewgqDUkWdankaKCYmFKrXhDgY3Lwhc6v/uG/v9aGzdbJ2
 CsIOPLtw
 CIwoqHVcJWdnER7QfLsRB03drxOhrD74x7xJyVvx2GSca9rcUAjhGYf0DmJsRIIsaC8uWnlt4FgYbrzz/kTdGrzltXWo4ngJlug+4yhLhvm/aLaEtK9a54cCI7aFW7UPzKS+UXQ0hoEubSVS2PVXx8uyoJfM5eRkKp8lRaVQ2cMtKv9QFvx3zbRkazJkTNCcNLRy4IU3MmPqahhQhKqHuymd9cnXnO2YNrr6Xn6h/+c3iKEpiD6Xvst6T/vJiLZ8mfRadNOq9O/ZOMLmoy/7cluo3OzN9umetWzLq/P3F+OZSm+fzAAcOWwisS5Qt27w7lkvdtlnToyQIJYRC5mv2kbRG3X/IyNuTj1zFCSRiVPeItHbhOXqjaOYeXFAyv1R8BAHOk4D4g0TKUM3Ik7Uhv8yzcQLnQdmGErVFOeYa+K3jZYE=
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

v8 here:
https://lore.kernel.org/linux-mm/20260731200802.574821-1-willy@infradead.org/

Changes from v7:
 - Fix the KPF_HWPOISON blooper
 - Expand HVO in a comment
 - Collect R-b tags from Gregory & Jane

Jane Chu (2):
  filemap: Add hwpoison handling to filemap_read()
  hugetlb: replace hugetlbfs_read_iter() with generic_file_read_iter()

Matthew Wilcox (Oracle) (13):
  memory-failure: Fix hardware poison check in unpoison_memory() again
  memory-failure: Prevent hugetlb freeing during unpoisoning
  mm: Rename folio_contain_hwpoison_page() to folio_has_hwpoison_page()
  hugetlb: Mark some function arguments as const
  guest_memfd: Use folio_has_hwpoisoned_page()
  kpageflags: Use is_page_hwpoison() to set KPF_HWPOISON
  hugetlb: Move poison to pages before clearing hugetlb page type
  hugetlb: Use the has_hwpoisoned flag
  mm: Remove locking mf_mutex in is_raw_hwpoison_page_in_hugepage()
  mm: Check individual hugetlb pages for poison
  filemap: Remove checks in mapping_set_folio_order_range()
  hugetlb: Set mapping folio order
  filemap: Add support for authoritative mappings

 fs/Kconfig                 |   2 +-
 fs/hugetlbfs/inode.c       | 123 +++--------------------
 fs/proc/page.c             |   8 +-
 include/linux/hugetlb.h    |  43 +++++---
 include/linux/mm_types.h   |   4 +-
 include/linux/page-flags.h |  64 ++++++++++--
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
 17 files changed, 368 insertions(+), 269 deletions(-)

-- 
2.47.3


