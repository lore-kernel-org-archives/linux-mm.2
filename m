Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5898BC531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 16:01:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6EA16B009D; Sat, 25 Jul 2026 12:00:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA9A56B00A1; Sat, 25 Jul 2026 12:00:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4A3F6B009E; Sat, 25 Jul 2026 12:00:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 884C06B008C
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 12:00:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 33D311A02CD
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:00:52 +0000 (UTC)
X-FDA: 85027762344.19.EBE987D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id AEACE1C0010
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:00:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=IiU4gVgB;
	spf=pass (imf21.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784995250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=r0YooHR0oUdoStXTpiZOrGMf2KhFuxnhMN59+dhjZGM=;
	b=lamFPs0i8wpGHsNKuU+IBsklK1G79qAmvWh+2RmsT8ZqrPlPVCjgcNw8i2xxxJ4Y3Gj0fD
	86cchvgpLTJ9dSq1PK+SieaCSL03B5yKow4uoBJBTdmx7vVb+4nH1RhvheBdlELOYius0E
	76LKMVPw1/ZltY2KfpduY10pAZfhn8w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784995250;
	b=TEDk5/1GI+NdgGI2eJYTa3Q4GSpze2om0TppONtxPqQrZBi9b9QKAhZcFkK3Lldfd5u3b/
	Tokht/GtuFhxPJ9svzzcWsSQ9bqJxyHUy3KBRRAOK+RI97zz1CZNgBwVaaH9DwKLx0kLqu
	kF0ARpRFuMsTkWlp6F5AqBB3hRreySI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=IiU4gVgB;
	spf=pass (imf21.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=r0YooHR0oUdoStXTpiZOrGMf2KhFuxnhMN59+dhjZGM=; b=IiU4gVgBH/eoIMXPP1PKoA/BUZ
	qxNvdTWqGVlJrIKHWZsO3UVrxsGGiKqTR3Wjn4m/YJwgLCuziBYc9fweBJ47p3TZC5GT1qM+dYGL9
	sqBM3ErDnaPlLXEwKc0lQroA9vkzvTTPFSv3tP33s6oCUBiWQCMZ3m33c9VzG1rqW7yBIxmhSM23H
	DjkfeQSSMbAavDkDnrlSIWxibJP1fZvareh8eF+DAp15cF2YCuSCq1yQ8tQ7l+R+s/IsPpMiB1LDe
	HNXn/J2NoZW2qGh6xO3ycWy2sl/jdv8tOPeQrHDWzB8fZYrEBti58LbiZJwhK2pos7FJdNrvWAj2T
	XZAAssKg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnenr-00000006X7O-17aY;
	Sat, 25 Jul 2026 16:00:43 +0000
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
Subject: [PATCH v5 00/12] Use generic_file_read_iter() in hugetlbfs
Date: Sat, 25 Jul 2026 17:00:28 +0100
Message-ID: <20260725160042.1557264-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AEACE1C0010
X-Stat-Signature: 83spgu6ghwwr391qhqb7hixaearzuia3
X-HE-Tag: 1784995249-620718
X-HE-Meta: U2FsdGVkX18ZprsPhoFdD+PTmFotrLThkREwyZiW1GpQZ+xxACc2NiFWmNZr+D+RiqlC5yYNdgeettNE0LHoGuG0pCRZkpcjK6i+hY9XJyXu7m3tgyZ4xZ2+gijLwSVRk0gMeEmGXcYfPT3StdzMzbFg3REv2nSSFUD285WN1RP1YC5QIXLjMFJUW3JulM1IVTp5Ki0br4wVH/r/PF9qCwruXbbOSNdZwbF3/1z+2SsDZTiFZ1nkrsAPgAEvMbmINlr0HbsuPs0oO4rYTjtKwkDahJlqqxmIIR3k4vTdrVqscOF0i4wHSArGQyVlRWJk3IQf4ORA3UD2Ra/82zFhnS4YmMKeX++8IYP8GMN07JftPuTbZFSTJwlhyfkTQ93q0eEcla5BdKi5D22GdtZB6LDya0d5238ZLOPi39c0+/skXmQl6OVEnCg2uAMuDfoGeNzGQU0KAXQbOzBJLIBiKbprbwskiqcOG6uPOuRALtCwE55u6AtgL4g9xnbPPn07b5Nlo14IAeqtN0gBXLbKTbk4VLJfdbR89nF29AMryUi3znRUTpm4madl+yguqeA+C9ZtbFLmHi0uY0IR0OK3aOzNA+vvDpw7VYUy/bent8x/IYd0NyMIkDVuDuWOp66kdxRewuPjYmOlYzUlptA0rWxy30j1xlD+E+PXWZAplJT7T9RGwM4Vq/EJ5SQpcm6OKxfn36Dj4EsLa0J9+Ko4LreOgBpUiJIZPZZkWpN6kZAlndB8AWpN8ZCc9rgH1e6HiLmdhpJcH8MvN2kRoSfLGxt87/PGZxEFVIag4i9JnQJfFF5iwwrCbzRfKRWuFs8qTKvZqiYB/riUX5dR3yjUSbvZvt4BzSaTrAhZbFwlqcQGdl/xmVLECjHJV/iIo4bjv+DJk+kewYrFaAEM50eFSb0QwE88cH4aG9HlWel2YreqIiUPepXOzUSJjnYDABddP1ROWUeteJUUeeZevCp
 0Wu8Un4R
 eC2/UIp+wvXnlX37sgP3RFo42RmpFsTODShoZBj5lj2Qpr/ROxi6BK04++zCjNkvwMql4CQ4w3GA5ae7ststy/kLkpgyzKdZwbQk9ix3kkNNLyGkdDZFK274mnmWH0nINaFnMy/aESuLifKkK01Eeq+fQSj7fk6iFzSfCl+++20a/8JQ8ApYLZsrKI62Jc9D5svfjIJr1DS+Cj5FvwgroG71igBwtZ98+wS1RkdFefkn68A37eS6p4IdcVxQK91/FQoqhhjscsffsXX2FLYygLmB6FlZ4ffMO66YexQzs5mMvEqa1pwgzsbHyb48fLdy6iDaczQD1C7AECnPltndQj0vxvJg16U+JNdX9HGRu0bbP6p2S/V8wfNnsuqnjrXysporFp4sxzD+z+p9LfN2VRxnt7kwzgNdgX+KEFKcU90xJQuo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This set of patches are separated out from Jane's earlier series.
https://lore.kernel.org/linux-mm/20260617172534.1740152-1-jane.chu@oracle.com/

v4 here:
https://lore.kernel.org/all/20260723143034.175661-1-willy@infradead.org/

Changes from v4:
 - Drop patch "Test the page is hwpoison before taking the mutex".
   It's not necessary for this series, and Sashiko points out a bad
   possibility.
 - Fix try_to_unmap() checking of HWPoison for hugetlb folios
 - Protect the folio->hugetlb_hwpoison list with its own spinlock
 - Fold the "Remove raw_hwp_list_head" patch into the "Remove locking
   mf_mutex in is_raw_hwpoison_page_in_hugepage" patch
 - Make folio_test_huge_poison() always false if CONFIG_MEMORY_FAILURE not set
 - Fix CONFIG_FILEMAP_LARGE_FOLIO -> CONFIG_LARGE_FOLIO conversion
 - Fix hugetlb_clear_poison() to clear has_hwpoisoned last
 - Add tags from Ackerley & Sean for guest_memfd patch

Jane Chu (2):
  filemap: Add hwpoison handling to filemap_read()
  hugetlb: replace hugetlbfs_read_iter() with generic_file_read_iter()

Matthew Wilcox (Oracle) (10):
  memory-failure: Fix hardware poison check in unpoison_memory() again
  mm: Rename folio_contain_hwpoison_page() to folio_has_hwpoison_page()
  hugetlb: Mark some function arguments as const
  guest_memfd: Use folio_has_hwpoisoned_page()
  hugetlb: Use the has_hwpoisoned flag
  mm: Remove locking mf_mutex in is_raw_hwpoison_page_in_hugepage()
  mm: Check individual hugetlb pages for poison
  filemap: Remove checks in mapping_set_folio_order_range()
  hugetlb: Set mapping folio order
  filemap: Add support for authoritative mappings

 fs/Kconfig                 |   2 +-
 fs/hugetlbfs/inode.c       | 123 +++---------------------
 include/linux/hugetlb.h    |  24 ++---
 include/linux/mm_types.h   |   4 +-
 include/linux/page-flags.h |  63 +++++++++++--
 include/linux/pagemap.h    |  45 +++++----
 mm/Kconfig                 |   6 +-
 mm/filemap.c               |  51 +++++++++-
 mm/huge_memory.c           |   2 +-
 mm/hugetlb.c               |  16 ++--
 mm/memory-failure.c        | 186 ++++++++++++++++++++++++-------------
 mm/memory_hotplug.c        |   2 +-
 mm/rmap.c                  |  43 +++++----
 mm/shmem.c                 |   2 +-
 mm/vmscan.c                |   2 +-
 virt/kvm/guest_memfd.c     |   2 +-
 16 files changed, 321 insertions(+), 252 deletions(-)

-- 
2.47.3


