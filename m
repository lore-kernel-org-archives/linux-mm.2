Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12DBFCA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 13:11:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A8118E0012; Wed, 10 Sep 2025 09:11:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57FFA8E0003; Wed, 10 Sep 2025 09:11:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BCE18E0012; Wed, 10 Sep 2025 09:11:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3AC418E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:11:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D79571DF790
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:11:23 +0000 (UTC)
X-FDA: 83873376846.24.71284E4
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id 316B1180015
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:11:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cZBiuywm
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757509882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=eJrfR1Raz9WWRTZbfGqa8eW3ja/CxXitbRgFdaYxFgA=;
	b=1HDlNyymlWkBqIkP9zSRaH18UkqLdhW1jsn7706TMYdQh5CdWiqSCF7a56j1xTUjxHSmUM
	1/wS4vZ+kDMGZ1MyKwLxmU41NuYTeW4/2b+6a6+T+tcQ0Ks06FZSkpzCE6RkXmXfiMAGtl
	uBxBedhXXU1TQjhV/UeYCNPatL3GzIc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cZBiuywm;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757509882; a=rsa-sha256;
	cv=none;
	b=7XmOFB1pTqRGqnNqVnjMjuaAZknagVycGtKv9UJMnxn3xvFehvR5RgVciwhXy6+zhM1gZV
	vBrmbUFLmzC4w18s4oZ10QQoLTLv3wGOhBjWBA5mpyKp6Q2Gf+xIu228olMy8048ObbMqg
	ulDLlg7KyOs7lA31fexfDxy0evTs+Rg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=eJrfR1Raz9WWRTZbfGqa8eW3ja/CxXitbRgFdaYxFgA=; b=cZBiuywmOi7MXc94osS0Rjuuxt
	AwDOf21T2WiMoPavoohISggqFtes4UGmrxdOg+5bOEzBBXT8afCkKlwEs5wLmzFqNvwlTGo1o9sU5
	RJQ5DRgjAaIVEuACbJO8l3Juu/4PxUIS50qBIHWeIa+gMuJl5l5jcIuIGzGLAZdJLVEzSic98B1Ex
	UifBIo9weRvvhz8U6pV4YxrkL/xpBY6xIFSzKByA65LHgsFM94dP1WFvUloFhQ+p2kl5vDQkPMcrz
	TQRXFB3yPBa/6u76Q+NVfPoVdLDGdwcKLOfsANtU2uh8fBcNYnS+M8LUvdxSzf3ISyVuiqJjupnC1
	QychWgSQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwJPo-00000008MEL-2tAg;
	Wed, 10 Sep 2025 11:55:08 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v2 00/22] Prepare slab for memdescs
Date: Wed, 10 Sep 2025 12:54:42 +0100
Message-ID: <20250910115507.1991829-1-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 316B1180015
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: d15jmn6isxts93yrj9mdbhfibmp371ob
X-HE-Tag: 1757509881-10591
X-HE-Meta: U2FsdGVkX18GxgcjdXrsk+jVnS7cjtiCMytSoZRAwHNJfg+sw5D+KdtFVdnDetTVuntebZUN1DuH1uBVycvTYvQ8lLleJj2UVIK5ksLQueT6OXLebE4hB0kQe2/BcnWJvjO/WkBYQRfwp79hYZSKktVGOQOb/bELGaFAQ4orflOi9MCWmYTn5LnhXr0bmW9IcMVTFmPQG+VLezB3IIgwI0fAh1+qWonOXgtqOyYpxUM733A0rB2TTg6LRjOConjkgLFmhIY7/GWVOO1uSRv16SnU5i36ezQF+Z26Ow9BxfQsFcWzeVL2sM0Tv52wNnn//HoOW6BGnOMytypLe9sKhwVgAxQollRSIMbkw23pbhCgC2t5ZwCeB6WTuzWHU+JN0ugdvAPip0lirMh8PutdXLN97Vu6vCtWLRHaWt2fR8xmc/gMsQ1IiKEzM9fEcnjhXNrdYaVKvUP74VNOf6ddJEkoZt4tV3XV5dJX2dnZ4/AKQljSBowiflje4FuFNAItft3xnwqG6LzIB4BWLNScqRobWeJJex4SlHdIsFkuNkFulc64avGBNPzpLKd/HviEIP9qVLdqIqLbAumuY2lJ2zRg0jJMCn+cYTRsLzK1y2UVdreG4QoTrrGtqha4yV5wN15Q9k13oaeLF74OhntH3WIasNB47qult5eQXnZS7ke867Ng1tTVkFnjivqjulUh8QsN/Q1eaeT18U99eiiDwJMloT9u5VEeEDIUXKGiRh9Az5XqP/nsGwI8dEo91yuB5RhFt5S+I6Vj6I+TzX0Jwz+D3tXWFGgTmoJTP8r5NIk3TY4VbU6uf7ArVXd4AgLx86wr2K0RBS2rTsR6o1cT7q52sZKB3AmaSRLfW0/At6OiWKzrHkn7/Nec9+V2Bh488azLZRxGCp1IBzgvmE3MzltUmxecuBnxfxpuweTChjX50psRnG21Urtpp9qWxugRH6rty7X4NZECiPExpWv
 J3+7kJjO
 ctMXIYshNVZLUNaNSuOogObnU+60sb07LHLaCuZulKBVy7umg8J2TR8kFtiWCFs03Lre+InmPiDw8Mfmr/Y3hhAyGmdaxjKgOXKT7Xw7KN2OMoArbWGY5+E6SOg==
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

This has dependencies on both the memdesc_flags_t conversion and the
sheaves work (as well as textual conflicts with nth_page removal and
a few other patches).  At this point in the development cycle, I'm not
pushing for this to be included in the next merge window.

v2:
 - Rebased on next-20250909
 - Picked up review tags (thanks!)
 - Fixed the bug in ksize()

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
 mm/slab_common.c           |  29 ++++---
 mm/slub.c                  | 163 +++++++++++++++++--------------------
 mm/usercopy.c              |  21 +++--
 10 files changed, 160 insertions(+), 196 deletions(-)

-- 
2.47.2


