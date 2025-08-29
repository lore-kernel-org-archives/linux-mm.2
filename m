Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2B5CCA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 17:30:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3303B6B0025; Fri, 29 Aug 2025 13:30:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2927C6B0026; Fri, 29 Aug 2025 13:30:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A8C46B0027; Fri, 29 Aug 2025 13:30:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F101B6B0025
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 13:30:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A6DD6BBA3E
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 17:30:33 +0000 (UTC)
X-FDA: 83830484346.01.13E15CF
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 227F2A000E
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 17:30:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qYyAg5de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756488632; a=rsa-sha256;
	cv=none;
	b=SeU/Wwmckzdxz8ADzXUO+9LxE91Aqx16JAwPxkwQ3N68jWkrqexpoq7SwzK03eT5y41l51
	a+aVFp6/k/yp1JIC/sz+yYNuganReS+StqUBnMvpVgqmE3G7MdgNnfUDKdlgJIKtkyQprf
	mzNr1/Hnmeyy1OF0310sLRQ1G/ch1DU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qYyAg5de;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756488632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qRkhnXR46w9IB/uRPg8A23DL04j/96Cy6QF7PlEr3pw=;
	b=wLTeHoZvVfI3MgNx/DEvx7JvucEL8eom4pQirikX5nPQaTEKMTZwEXOl2dmgXt5C7ZgtPV
	r318QY2kIrF39wtrjYOCh4XFLUrVtt8fgzdj7T4o/4SCXuw3mAy3gOUSBSlOF8ybfvdCSN
	ilnBPxlGlMyM7irbHcC1jVr1L8dgOSc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=qRkhnXR46w9IB/uRPg8A23DL04j/96Cy6QF7PlEr3pw=; b=qYyAg5deWmpzF+PNd639193cAR
	N1Gxzz6pU0cuBAULgKvSvXk2FFH9dbXHqo+u9ezedL6QzgtkK8ypM6icE5WO1Dw5UNAweihdRk4UV
	gzv+eJ+QKVUIk3ez9BhMSDIflIIy58q7bfUHII0q2mpjKgwytGKYQp4bE68tuusLRYsUDFLb7hiUt
	sT5jA+8DL3CRyveY70Lmm+0fK0VrtlhP4Y+YiagngHx3XJpIX9/HHgSwBMgR73CBdAeGW2TtLrZAT
	lnvw6XGpfZeV5GQKCKkAk7RqSdbBss11bUlAcAkXKtYN2rweo5ylrxaDCldweD+NRY6fA5eSUkYWm
	TxER7iJQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1us1K6-0000000EFvp-2BUM;
	Fri, 29 Aug 2025 15:47:30 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH 00/22] Prepare slab for memdescs
Date: Fri, 29 Aug 2025 16:47:04 +0100
Message-ID: <20250829154728.3397606-1-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 227F2A000E
X-Stat-Signature: 1wzzwq168junerw3d9hktobt8g1qqqwd
X-Rspam-User: 
X-HE-Tag: 1756488631-591694
X-HE-Meta: U2FsdGVkX1/VqEul0uUgECZx0pG6a+8AqTAHBXDcR5ALjmINHQVwNgX4ueJclMA/tALCiugk1eNSbPKIxQ82d/9D51R6+n7j2dJkneZiIOE9AuYhsBGt39hV4C7AFlB0NSLWJrGU8tZBdIQO889vtAwwop3rtpltKhy4sebZQqUnKtnKdDFnWIXug05JCBOfqZCj6Srwew2ka+0zTiJTnv9w4g2jQaCgSXQT2PVldCvWo8Gc8ZlWMr2ysuzCs7UCFZQd5LGvO5PMc7muLQVJk9x0WXokJrVkZneqw0kUrkGLodmEbkU5DWiZQTal5+Ktzmmzj7KS2vc76O3tnFkQiJCDfCbz9yJEqP43Kr5B1gxb/h8WZAw5hJd9i3OZr90nGYdDm3YOhsupUVEgRcWEe1FMsF8vwVStRLBakthyBW5JNCRaeFYLU5PEIAE6/qLN0vRIds0pUiY76mFmnLRrzo0J+sjbqZDVsEzJRufIvjjjffAi1C9JdHMZJio2zcHxI3fjcPpPSOvUXyriXCHEFXpkHmEl3dvjLysbyvbvFtWrLzB9nNksGKWljEvO8Q542gb/mkpofBmvCprDRrMSJHWKTRpjkGomcU3ygzaQnZUH3x19Yh4cNPfUEcUkUJNBLi/yRus0lCiiBAv4rOUoWUlP4lVoJItbfJW5r/I+8299NXStiGy+y0IIFz8rlOmftkeMAC+GAoPqp1NMTSQhqfoNeLZdC0R1oYeqAoKhsTAaI6m+abg5bOGiLV75Y9u9QMLb4Y/RqgNpOLdeWn2Ymk3s9LvIi4IJNGE4EeZVFp0Ftdj/3vr8ihSkL5X+aXRw/T9sffk5gHXutKskBy+/6oBjyIHRECzvV1DUIghXP4Fqxh8+q/GXNXo2ZNVGjZYq8LloNcZojAcFeMyviJTbmgo/CtbxcEfo7Em9RKlu8VGjFUMtcJGaqtUsICriMu48uPvUtRmzO2JGmL0v7eN
 NsB/rbno
 AKDuk0dxs23h3wSsQJSkdrY8ABCQfM3+vnQinoeu0v1+wLA+xYUfmyfURunClo4MRyTnNOtT0LhsfTHEs8McfxLCDzQBiB5L6bcAF+GVZxb0k1MWrg6SBV4woLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When we separate struct folio, struct page and struct slab from each
other, converting to folios then to slabs will be nonsense.  It made
sense under the 'folio is just a head page' interpretation, but with
full separation, page_folio() will return NULL for a page which belongs
to a slab.

This patch series removes almost all mentions of folio from slab.
There are a few folio_test_slab() invocations left around the tree that
I haven't decided how to handle yet.  We're not yet quite at the point
of separately allocating struct slab, but that's what I'll be working
on next.

Based on next-20250829.  It has dependencies on both the memdesc_flags_t
conversion and the sheaves work.  Both should be trivial to resolve,
but it may be a little awkward to shepherd into Linus' tree.

Matthew Wilcox (Oracle) (22):
  slab: Remove unnecessary test from alloc_debug_processing()
  slab: Remove unnecessary test from alloc_single_from_partial()
  slab: Remove dead code in check_slab()
  slab: Remove dead code in free_consistency_checks()
  mm: Constify compound_order() and page_size()
  slab: Reimplement page_slab()
  slab: Remove folio references from __ksize()
  slab: Remove folio references in memcg_slab_post_charge()
  slab: Remove folio references in slab alloc/free
  slab: Remove folio references from ___kmalloc_large_node()
  slab: Remove folio references from free_large_kmalloc()
  slab: Remove folio references from kvfree_rcu_cb()
  slab: Remove folio references from kvfree()
  slab: Remove folio references from __do_krealloc()
  slab: Remove folio references from build_detached_freelist()
  slab: Remove dead code from free_large_kmalloc()
  slab: Remove folio references from kfree_rcu_sheaf()
  usercopy: Remove folio references from check_heap_object()
  memcg: Convert mem_cgroup_from_obj_folio() to
    mem_cgroup_from_obj_slab()
  kasan: Remove references to folio in __kasan_mempool_poison_object()
  slab: Remove references to folios from virt_to_slab()
  mm: Remove redundant test in validate_page_before_insert()

 include/linux/mm.h         |   6 +-
 include/linux/page-flags.h |  16 +---
 mm/kasan/common.c          |  12 +--
 mm/kfence/core.c           |  12 ++-
 mm/memcontrol.c            |  36 +++-----
 mm/memory.c                |   3 +-
 mm/slab.h                  |  58 ++++++-------
 mm/slab_common.c           |  30 ++++---
 mm/slub.c                  | 163 +++++++++++++++++--------------------
 mm/usercopy.c              |  21 +++--
 10 files changed, 164 insertions(+), 193 deletions(-)

-- 
2.47.2


