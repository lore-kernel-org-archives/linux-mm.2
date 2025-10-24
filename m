Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1017FCCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 20:44:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81FDC8E0105; Fri, 24 Oct 2025 16:44:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CEEE8E0106; Fri, 24 Oct 2025 16:44:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 677C78E00C9; Fri, 24 Oct 2025 16:44:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5039D8E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:44:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1182149951
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:45 +0000 (UTC)
X-FDA: 84034186530.13.B11AE57
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id 88A1A120006
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Zyom7mYq
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761338683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=F0QGJWzE8czqDF7leatBIQ78T+0rARxw9jfCN5IKM3o=;
	b=s2DvH2bzBCe3s82qwdy5M4Y4OBDaD5tPMdY5TT40T9zf4E42N4J6UwFd7abeoep3dd0BtC
	OUg5Wkgl87dj7MNO6qo0nT5vamH5UBnmScFP/UI295aB6gPcSTE47RE+DzNBKHp80KrIvv
	gSUnpGcJ5l1NrsjUhp+1XJx0i5K+cdE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761338683; a=rsa-sha256;
	cv=none;
	b=ja97e/JOx60s4C8TjGbO+nVQJx3qHtZufrnIkJKEeTsTPcLZI6zCGPhDLYF1HXucwaEN94
	aAnPqCG8ZZ5Iy/jeOL44KbFaI1NX8gPc4XpTcpFoPrxxsn4SQvIeAl3WyPugo58kTZMEIm
	WIVltHfalv57L5XziL54A8VNasRn9hk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Zyom7mYq;
	spf=none (imf29.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=F0QGJWzE8czqDF7leatBIQ78T+0rARxw9jfCN5IKM3o=; b=Zyom7mYqF0iuYWZkcoIqrpWNF2
	VNb2C2FyzDuemib0i0Y5CZMsd+0FvQNZYPIGt5MhYG/c36uSCWqBzqDZU5id6R/Ql4nVuGA0cVu47
	9ckt2FcdfCtYFEDSti8/YTdbIlu8Nq8fRow0IAqCFcotdBQOXBIDNvGAUfBhvy2WOy6d54G7VjAbv
	0tdhLTdsb/FqwoGcTzR4eRnmlk1s2GvHuQnWJM4//JR+Zv4Wqp9AjwZtO9SxbANV1Hp3WUmp7FeyE
	iojMoOmrqRibNnlmE6rwHsd1Kbi8W+BdnBqm2rbaU7ayxUcTWmZU9lJ8shQ7DTnc5yWGBLitMjieN
	yJ91QD8A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCOeN-0000000AKQL-0sfp;
	Fri, 24 Oct 2025 20:44:39 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v3 00/17] Prepare slab for memdescs
Date: Fri, 24 Oct 2025 21:44:15 +0100
Message-ID: <20251024204434.2461319-1-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: 5idk66jmff19hiw6w16i49rn5tmo65rt
X-Rspam-User: 
X-Rspamd-Queue-Id: 88A1A120006
X-HE-Tag: 1761338683-787350
X-HE-Meta: U2FsdGVkX186s2/x4c7QWNOwrI1KvGZJd3JN8Qg7lvvqrKWcfwuqHTfQjR/f2dd6p+6SbbSwpIvkmaReqtatHaiTlB4k41qVO1np2hOHhu/13UGHAYwY196TtpUYTgu75Boj2xbJp+UvGZJG2RFhU/gZ5pwgxE87S847WVB1n/cJ35i3KQyt/cYENO1OSjus8WpxVdGNpzg6K3iQeAm+uqjbPW56Z1CU9FqzEOBGtnV4bMpNHHeRxjnL4r5fLPwT9xKA0Ix+8IIAY3sjRp1WIBB5A/2SGibvbTeoO6ir5y7fA5cP3YRxOse6HLOockvdo/JBqvZMQ7U22NKVKIxNa8DGtSkdOve21WSwecAhFSbc4mG1VQlo7YeieTim94eR/KoapV3ILM2qLwN0XKFG0vJtWH5mWhP/wiV+e1p4CRiDR25y0pPd6RYDzYIMsUNQPAfPjz1JgNjyZjdkSHQNSFu8zp+gYhPEsoz+sgRWp+VgZuTpKg/d8pRPSd++kdituPof33Ij4YlwZfBZZCPQRcI9+Z6mlZB0X7pT1IXUBEhtehe+wx8cqLRJ0LQ7mQkrnmRlky5OGoz8oe2p747zg8xkAtLlaKFEjgOhYJSu+yNpncZr+VB21YPSZI2w3lYykIuqBEbcHYGYm1N58oAqGHeCRDJqto1W6AHuqbc8vxeJrOZ6L7yj+Uh20bMpAmUWB2j9+AWpXYhmn6YN8TBHCrsuIGguk5xQqrI54W2QulLQ3PZ01XjEAZnB04IgnaMl5ZjIfgSAak4U+vR6ZQBaDDsO2EbEPkgzVT/B1X87Zed2MFzNt6e3tW6JvZHTg99WQGuz3bDN8HS2CjeBKSoxVZ/kZTQX+sS75e4rYaLofcDxjEEXZO5gAAZSEAF2kbKUayu8hb2elyfSJuJNYdTEzapI4NLYLDsvy4t9Oz2ZNZIENlIiQeY0lLUenchYyRu1sD9J0la/2b1tNJcD/9i
 FwGElLUX
 5KPWsSa3FYG+cCc/lPi209DMTzwN5jCR4/G8BwjHR6Kbkqy8eIffZo81MI9ZAxuzvH/fGjgO/WqR1C1cFeNXVqG5C2KGyhLWF4DXH5utaKWcpshqL3Pbl4e+ykQ==
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

v3:
 - Rebased on next-20251022
 - Picked up review tags (thanks!)

Matthew Wilcox (Oracle) (17):
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
  slab: Remove folio references from kfree_nolock()
  usercopy: Remove folio references from check_heap_object()
  memcg: Convert mem_cgroup_from_obj_folio() to
    mem_cgroup_from_obj_slab()
  kasan: Remove references to folio in __kasan_mempool_poison_object()
  slab: Remove references to folios from virt_to_slab()

 include/linux/page-flags.h |  16 +----
 mm/kasan/common.c          |  12 ++--
 mm/kfence/core.c           |  12 ++--
 mm/memcontrol.c            |  36 ++++------
 mm/slab.h                  |  58 ++++++++--------
 mm/slab_common.c           |  29 ++++----
 mm/slub.c                  | 138 ++++++++++++++++++-------------------
 mm/usercopy.c              |  21 +++---
 8 files changed, 148 insertions(+), 174 deletions(-)

-- 
2.47.2


