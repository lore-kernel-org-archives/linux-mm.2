Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDC25CD4F26
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:10:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 352B48E001D; Wed, 12 Nov 2025 19:10:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D9EC8E0012; Wed, 12 Nov 2025 19:10:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0442D8E001D; Wed, 12 Nov 2025 19:10:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF0F78E0012
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:10:05 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F71BC072D
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:10:05 +0000 (UTC)
X-FDA: 84103651170.12.C77243E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1FF9820005
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:10:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=fZKYKDBU;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762992604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TQkxOBT3rE51V7O04ILFPRh82G9xUL+FAtsbfj8+LZM=;
	b=ZfmXxU5y+V9iOznQlC+jhobK4X0MXRgZzGcqH7e6rJ/esFjeWll/TNMWUU/4zveS6uAcqe
	e78eRZtORw9vatplkIL3+PG1UmGWzwXjHzeH9e9G/eCmf5LB+o51nx9GbCZrtzeopkeSyB
	+LxCVWMUngR4VoyuY56H6i6Oz1lHJdE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=fZKYKDBU;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762992604; a=rsa-sha256;
	cv=none;
	b=jKnIP5n1yJyTcOxBr++7nvaXyvs6+qv1LUg9NT44TtwXasksrj1kt8g3h/IfywvOYVNvmG
	FjJ2trgSRiM/YzZyqUg7QoKS2MNB/U3SzIKIhZtBee3ymw1GRSb1tsoMGjeq4SkM3xNkvS
	79fyj1piiBNNk12YMmF1dToPRNDxV4g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=TQkxOBT3rE51V7O04ILFPRh82G9xUL+FAtsbfj8+LZM=; b=fZKYKDBUjcX4B29lCJHiP67T4P
	6z65sqP7Lva6X6QG6MtGAslJxgUzAvVUtzHLWWrmunOQAQuc5+z57w3C+4uCUtqeah1p/AxU4IPju
	oHcGyWWBZy0Y1G6yoess1haFokhLP/r1SdJcxTn8aI5xkrJ7eabioc7VYSRTszCjFhHOOo5g6XrMQ
	PW28ayiguV7/eOLhWy1P/SopBmP1aNpC8CXBE21cWQaK4EWn1558EkR1htDy2dJ7bLcRdH2XU1Vin
	zD8799lNf2Vjj10kFk7nPhsaHYS3BgYmJqhwZVCDmVhSESghTJhOxamesY6cJlIWV7CrCheaK+KJT
	7gapcrPA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJKu6-00000006fOM-0lIk;
	Thu, 13 Nov 2025 00:09:34 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v4 00/16] Prepare slab for memdescs
Date: Thu, 13 Nov 2025 00:09:14 +0000
Message-ID: <20251113000932.1589073-1-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1FF9820005
X-Stat-Signature: c73mrcuwddc7hbbqkcqgzd5tskyoxgj4
X-Rspam-User: 
X-HE-Tag: 1762992603-379442
X-HE-Meta: U2FsdGVkX1++2VNXcr1NCC+vNUDM/dYiVI2OnIOR1olewXS4iXaW4UOFU6y97X7rtVrNDRx7ML80Jj3Tt+X9qxIjzjJ5ipn8/tz65msIQj+oRfEYqJgOM4f1X2Q6XzikVHPeCg06v12fz1lGUq29pmpOSH8yp13tzSUNTjn9q5Qnn+jv/27pToBdgYoaqA6XDmr6nWBe6hRzYIr6xGPA7UfUZZUgJNM5m7WZfs7gNFS8+9SkxMGx4/Cdexm0egVBjlgf42gk/pM14kp2Vd5ukkRjS8wNZCANTP379m8+cNFFHpVRhKOyHeg0Ft48H+vsLjvxbhTBbtUAQJLl6DV7ZsFZF5+M1P6ORsa68kEw8OSAniunfnRgg15YZFdfsTq5Eb89vs3Xm9PVp9cAG7Lv/2aKB+DF4LW4ci6gUogAy8CwBj8wjLhtCegnJFql5dNwD3GibQC/jdrwkkHDtJ+2brIjyvOk8Ehwf/qh+FDZX78R+4nhN7/vF8oynij5rc1EU7BuATpgK9mMlguyuWqD8zHBh1G3HjhGGpYY/V7DQbXdH/3Bm+xNbwJGziXqYQpRSo75lxbL9lk3DsDJad8hxdA6pYPS/uci4kn8E1p1McAzgAXfgpMgYUwXKbCezwF5ouX2Gdh6F/L7mvoR9+7kjwl4aDMoTtIsNyUC9x2ipwJq3CkbPyO2mhWRSV1FwoyYBIVYE6SXc82q6AxxHZlv6GgidBSZDzTOvdpjhWhkaodWSUIwhsLyFZlinRcBW0yuk/+N2Mj2xy/zqR59LMDXHKffWbN6DQRp9nbJkPF2p2TKyDNTfwDTzbcM5hYyT365GrctC6/r0gRoGbS7jkygRAbengW0xWADU/vusf50Vu7uyxLfaHyzCB2BARExkxmPeVTORXam4lxVaDlvBd69ZOvWCleXqgIv93LeMz6ed7Uzd337mxLpSBR4/kPCWgvDmnadKVtBzLWzHTjnDH+
 TNjDiFOD
 wmxfuSYvIL2GoZSRvua+DJ0MTWZkCQDfLepmm/1twhZa9TUPCWs2MRyLrXJ+lDQPP484Q2j/dAeg8QsM+3jhKZS5dcYWfpGnU1AIowda+hFMYDxNglliZ3UgimfShIkNn4BPPh+os7tSCVFNdpBQ5ShvCIFZjUp4ZLGVUThyV5o6/+wNug2AacLNW8x3WmnTgLdxT
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

v4:
 - Rebased on next-20251110 + a couple of fixes
 - Fixed compilation warnings when CONFIG_MEMCG not set
 - Picked up R-b tags from Harry (thanks!)
 - Restored the order of slab vs large_kmalloc tests (Vlastimil)
 - Removed setting of LargeKmalloc on tail pages (Vlastimil)
 - Restored handling of non-slab, non-kmalloc checks in
   check_heap_object() (me)

Matthew Wilcox (Oracle) (16):
  slab: Reimplement page_slab()
  slab: Remove folio references from __ksize()
  slab: Remove folio references in memcg_slab_post_charge()
  slab: Remove folio references in slab alloc/free
  slab: Remove folio references from ___kmalloc_large_node()
  slab: Remove folio references from free_large_kmalloc()
  slab: Remove folio references from kvfree_rcu_cb()
  slab: Remove folio references from kfree()
  slab: Remove folio references from __do_krealloc()
  slab: Remove folio references from build_detached_freelist()
  slab: Remove folio references from kfree_rcu_sheaf()
  slab: Remove folio references from kfree_nolock()
  usercopy: Remove folio references from check_heap_object()
  memcg: Convert mem_cgroup_from_obj_folio() to
    mem_cgroup_from_obj_slab()
  kasan: Remove references to folio in __kasan_mempool_poison_object()
  slab: Remove references to folios from virt_to_slab()

 include/linux/page-flags.h |  16 +----
 mm/kasan/common.c          |  12 ++--
 mm/kfence/core.c           |  14 ++--
 mm/memcontrol.c            |  36 ++++------
 mm/slab.h                  |  58 ++++++++--------
 mm/slab_common.c           |  29 ++++----
 mm/slub.c                  | 137 +++++++++++++++++++------------------
 mm/usercopy.c              |  24 ++++---
 8 files changed, 153 insertions(+), 173 deletions(-)

-- 
2.47.2


