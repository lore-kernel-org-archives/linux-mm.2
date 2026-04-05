Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFF37F3D5E0
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:58:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A2F76B00EF; Sun,  5 Apr 2026 08:58:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 252F06B00F1; Sun,  5 Apr 2026 08:58:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11B0E6B00F2; Sun,  5 Apr 2026 08:58:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EBC356B00EF
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:58:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C781D1A0336
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:58:53 +0000 (UTC)
X-FDA: 84624506946.14.57F3F10
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf28.hostedemail.com (Postfix) with ESMTP id B9336C000C
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:58:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=AB9Sny2D;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393931; a=rsa-sha256;
	cv=none;
	b=UO9tGVxAMeUjl1YuZH0VibV4eDy07cRt1nQ5Vs1Ul2a2XJ6ZUTd45kfdeQIPuBeeSqSI9E
	k+I05wxaGCQ0hRHLhWLIwluPLZ4RHE88rCylMG8dMwfXxxPdVAfQSxkFuQnZTCkw2Xpi7B
	3Fc/CDKUlMuEPXyhDk8P9nZz5garG+M=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=AB9Sny2D;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ydW451GMW82JpMBYkjDYyQiyHYoh54ssuDXhIqDFdlI=;
	b=hxaucmWuHsaYD614/ZNNWvYp+NE/NtuKxRlPwNK4PKJEkQV0MnIPCCbj7smJTUCuALUaVK
	IueoGsWwDzcwm7JIYbJOQmMDfMCqZGftZ9tKATEzwuiuPUTRu4Xb+BLdqO7ogz1CAV4U8d
	PDCaBFF2xCH99prPLOfdyiF/KlUl+ck=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-35c2fe0d90fso1788567a91.1
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393931; x=1775998731; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ydW451GMW82JpMBYkjDYyQiyHYoh54ssuDXhIqDFdlI=;
        b=AB9Sny2DhzgOGHGOBqka49bV+TM3xiRLGSwEb1HgAbdVr6IeIzwBgsE/1aIzAGR2iS
         PT9BwpEqhiR083M/JsFmGDRPad4DRkFMnZssXBL4pJtb0tkqj1RMA5u5BZwZofRK6HZs
         AHSHfgm7H6/sGSyw/ent5S4W+0/Dqg8jx8ANbCCs/NQQcZnu46KLBTxJ7yaysb68UpFL
         tTwTZy/f/pYOWBm0NFLWnEgXiP1j83rjCYoFW4gYS5LQ5tn8HGFj3lXwdsexJrjs4CiE
         FVUowyd5GT/Ib4bU8ULh/PHxOMos2uQvM15QrzvG0IaTQdNiO5PnA4KZb7qRbtpXEZLl
         vpfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393931; x=1775998731;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ydW451GMW82JpMBYkjDYyQiyHYoh54ssuDXhIqDFdlI=;
        b=tNv9kHitsYI0ITUUIZm2LdJd9D/SwwqSMT2CcTBr+5xWDqzkOYvzwtUYkmeALxJvAx
         qXwQ+eUgeq7zFEMQ3tZZbti0dRpIuRK73ulkX1TqnrOc2hHWpgBZ2HDMa8I1ckwQZetW
         X7x6mdjT2L74SfmWUDVPrOcxugOqpsqPvE7S/PIXuhRIZK6KrvpZpHthZepG5ce8Kw50
         QQBg7nKzm2854z+I4La9MN6LW3V238IA5n/8sLHT44hizN1QgeYOFuqLK7BbCJ8iOuPl
         EOMCGtLrNc+E0+HfKZ0QMba3luiKHPKlF5hSzFUq8EXEiVpwCZ0tgVIld1E/B4M9vYl5
         0Gqg==
X-Forwarded-Encrypted: i=1; AJvYcCWOPma20CdYcnC98XsngngMt/E6/Loa4+x59igJm/uSlmnRQbOXm3faP1/pE0xyC7CVCsRsSWGVEw==@kvack.org
X-Gm-Message-State: AOJu0YxmqbPnr6yW8hCyNpJNtd8nyEHgiwMKMyHJXZoTUX49TemD+eUt
	a5DcQ298yFY+MKX0jEXTSvVVRb+L6GkHq9fXeYiktO+gnKCcZue+j+78VRCj3Tw89s4=
X-Gm-Gg: AeBDiesH+OuFcQeWkt0e/0jWV/fpwnk3bMM3d2q5JR7PlIAggkbXa/NL7TykkagwXfX
	e6f63bOPSTSpf5YAuYo4k3ceazPSxkQSVCinRv42HI9UvvlGK8KQTmt6DaWMJcxTlfHOpob7ino
	phxQFNSbr+ikUfv67R4ESAkmcEZtj6q1VLZ2gUzT10kojodOSTAbGFjDMuP3FYs1OBVoXbH1CaL
	xjzhB6bcxCHllr3oiQWNHlKRsQE1HikRY2lknhacDd8d/kITpSAzr2urHIp7/9dH2ETtx8wYOXf
	/4i7i2Dn6Tb7y6x4UcEHyZd7zvpw/TtCe67NgWBDJV1fdG+GJjx6ZVJT5QOaNIa5hQQfUmCrvzf
	D3hJPCFlg5QenurWJ9rkiq2tjsCTuURcOspWGcgQJlyP1oih/z8oWIvmmTLU1plfLWgTluXQiy5
	2GSnH6rQ3sl3pTnMUB058FrA5oVAikAyGhrXP+h6TuQh4=
X-Received: by 2002:a17:90b:2688:b0:354:a332:1a61 with SMTP id 98e67ed59e1d1-35de678f2b0mr8914364a91.5.1775393930429;
        Sun, 05 Apr 2026 05:58:50 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.58.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:58:50 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 48/49] Documentation/mm: restructure vmemmap_dedup.rst to reflect generalized HVO
Date: Sun,  5 Apr 2026 20:52:39 +0800
Message-Id: <20260405125240.2558577-49-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hkcitemtw1oz7duxcaiqg7zajiujbzm1
X-Rspamd-Queue-Id: B9336C000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775393931-784292
X-HE-Meta: U2FsdGVkX18LXkLHu0DlvPQdut0F25MPwIMmr8rrnh4xVF4mM7qmWSxA5D3JMho9RSBId1t8UBFcz9n0VnEaLbHdq1cvFick7b1QWtMWJCBT7pVM01KQlIjxaSttHZQEa5/cg5uwocTs/5OPfztFXTMAN4sSSKV2xtzC3wmyNUi7+CCgD/T0tx0dhXDsGpTjOwyS7ceql0wd2zjaBXXJ2CCgR7Doosy6kqe0L27Ey8s4lJzkZro09BjzlG3GBArPXReMqmqBnZ7d71bnpMmus5G/CkY3fQ0eO4VG47A4i24iawjWlDw2PJOxRiigYPc9zBO+GvesdCs4sqFIKWJNyL4hEtGRFDvwi+ngwTsLLNpGUbSZu+e92NJc6wtIRV8wxaocPZ8UF57WUBOG/pqMBAdXSxWbhm30D3WHLRcVU8OUiY1JWAENBVg8+sl/Qcr5DD0d/Gox6mw005S8LXrv1/3i6imyFyI9OL22FC9hz13Dd+O8RHLNbf+Q+yTkY2HndinO6GMmYWJvrzaBYFpZb1gOosGIqx1HdTwJS1/qgs5To5rRjHr3rxkf3ujfFf8t9VODU9KeWpBIm00Lp+tjkIz+dGuove9IoUoXwZB4Fsdjoe2XRw6BpmJnyGQQHevnGMaIUdERBu8ien+nIeeX+CJ9dnBPXpw+BaTuP5kWEBa0OMtmoIg4g+kbpmlDMblSOnqHZCIVYgSOHrUfltNef/X/G/8rt68xNGIJn5SR10MfzN0YQXgBfZJm4No0oWbbcUTZMVpJ3AleLhrhfPPw47GxtV96b/ug9j46zDiaQEMshuJdZefmCzNST3jjyQYaTVxF92+DesJYLxsr22R9mERiGYdbnoURcDvZraNgcjVN52f1Y9fUEc1q8fmvSdB1MmOC+DUypgQ6v7Ej0R8Muj/C/2Z/w56fLVIR+fQ4IESXFSEfGqafXP8tYXdeM6f+AgGB63DqIvsPlprUums
 XLufTLyb
 zHqNumNEK9Z14+sdjLFyw+m1KrXDW/PCWzgbCermMcJglbYW/ShnwdyQo03tk+vNT28Z9hiCN2al5Lt6K1EAktGWlRoQDGYGHUo2OtOZuwmuZF97KRThhLSbNrV7WuS8026uEsxtza6ld3b8dA5im6lO+oRp24a8BhK87PsERHWRnQB4Ugnft5pP4GWghNE7Wi+ty3O+dj+aP32vFsKQaWk6UcjaO1EL/qsT9auM3yHlsa2dEFa0Ia0cBXNr6ysz2p1CzyfTQhWG1SlgwrAlV5UIWzExaXQPk2r69QkhriUAxRN2MYiWdUufR1dCfYHaZoRcS033TyhJDpDnzBpqlpbB2J2o56QhV7Y7un7tYkQjphBE4qWI673wMikOlwpOjSaRU+oFBwILDPAly+T29HnXpdBHx6cQEDFxy548ewwmsfZY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The documentation Documentation/mm/vmemmap_dedup.rst is slightly
outdated and poorly structured. The current document primarily focuses
on HugeTLB pages as the main context, which fails to clearly communicate
the general principles of Hugepage Vmemmap Optimization (HVO).

To make it more logical and readable, refine the document. Specifically,
introduce the general HVO concepts, principles, and calculations that
are agnostic to specific subsystems. Remove the outdated and
subsystem-specific contexts (like explicit HugeTLB and Device DAX sections)
to better reflect the universal applicability of HVO to any large compound
page.

This reorganization makes the documentation much easier to read and
understand, and aligns with the recent renaming and generalization of
the HVO mechanism.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 Documentation/mm/vmemmap_dedup.rst | 218 ++++++-----------------------
 1 file changed, 42 insertions(+), 176 deletions(-)

diff --git a/Documentation/mm/vmemmap_dedup.rst b/Documentation/mm/vmemmap_dedup.rst
index 44e80bd2e398..a21d84fcbe24 100644
--- a/Documentation/mm/vmemmap_dedup.rst
+++ b/Documentation/mm/vmemmap_dedup.rst
@@ -1,107 +1,33 @@
-
 .. SPDX-License-Identifier: GPL-2.0
 
-=========================================
-A vmemmap diet for HugeTLB and Device DAX
-=========================================
-
-HugeTLB
-=======
-
-This section is to explain how Hugepage Vmemmap Optimization (HVO) for HugeTLB works.
+===================================================
+Fundamentals of Hugepage Vmemmap Optimization (HVO)
+===================================================
 
-The ``struct page`` structures are used to describe a physical page frame. By
-default, there is a one-to-one mapping from a page frame to its corresponding
+The ``struct page`` structures are used to describe a physical base page frame.
+By default, there is a one-to-one mapping from a page frame to its corresponding
 ``struct page``.
 
-HugeTLB pages consist of multiple base page size pages and is supported by many
-architectures. See Documentation/admin-guide/mm/hugetlbpage.rst for more
-details. On the x86-64 architecture, HugeTLB pages of size 2MB and 1GB are
-currently supported. Since the base page size on x86 is 4KB, a 2MB HugeTLB page
-consists of 512 base pages and a 1GB HugeTLB page consists of 262144 base pages.
-For each base page, there is a corresponding ``struct page``.
-
-Within the HugeTLB subsystem, only the first 4 ``struct page`` are used to
-contain unique information about a HugeTLB page. ``__NR_USED_SUBPAGE`` provides
-this upper limit. The only 'useful' information in the remaining ``struct page``
-is the compound_info field, and this field is the same for all tail pages.
-
-By removing redundant ``struct page`` for HugeTLB pages, memory can be returned
-to the buddy allocator for other uses.
-
-Different architectures support different HugeTLB pages. For example, the
-following table is the HugeTLB page size supported by x86 and arm64
-architectures. Because arm64 supports 4k, 16k, and 64k base pages and
-supports contiguous entries, so it supports many kinds of sizes of HugeTLB
-page.
-
-+--------------+-----------+-----------------------------------------------+
-| Architecture | Page Size |                HugeTLB Page Size              |
-+--------------+-----------+-----------+-----------+-----------+-----------+
-|    x86-64    |    4KB    |    2MB    |    1GB    |           |           |
-+--------------+-----------+-----------+-----------+-----------+-----------+
-|              |    4KB    |   64KB    |    2MB    |    32MB   |    1GB    |
-|              +-----------+-----------+-----------+-----------+-----------+
-|    arm64     |   16KB    |    2MB    |   32MB    |     1GB   |           |
-|              +-----------+-----------+-----------+-----------+-----------+
-|              |   64KB    |    2MB    |  512MB    |    16GB   |           |
-+--------------+-----------+-----------+-----------+-----------+-----------+
-
-When the system boot up, every HugeTLB page has more than one ``struct page``
-structs which size is (unit: pages)::
-
-   struct_size = HugeTLB_Size / PAGE_SIZE * sizeof(struct page) / PAGE_SIZE
-
-Where HugeTLB_Size is the size of the HugeTLB page. We know that the size
-of the HugeTLB page is always n times PAGE_SIZE. So we can get the following
-relationship::
-
-   HugeTLB_Size = n * PAGE_SIZE
-
-Then::
+When huge pages (large compound page) are used, they consist of multiple base
+page size pages. For each base page, there is a corresponding ``struct page``.
+However, only a few ``struct page``
+structures are actually used to contain unique information about the huge page.
+The only 'useful' information in the remaining tail ``struct page`` structures
+is the ``->compound_info`` field to get the head page structure, and this field
+is the same for all tail pages.
 
-   struct_size = n * PAGE_SIZE / PAGE_SIZE * sizeof(struct page) / PAGE_SIZE
-               = n * sizeof(struct page) / PAGE_SIZE
+We can remove redundant ``struct page`` structures for huge pages to save memory.
+This optimization is referred to as Hugepage Vmemmap Optimization (HVO).
 
-We can use huge mapping at the pud/pmd level for the HugeTLB page.
+The optimization is only applied when the size of the ``struct page`` is a
+power-of-2. In this case, all tail pages of the same order are identical. See
+``compound_head()``. This allows us to remap the tail pages of the vmemmap to a
+shared page.
 
-For the HugeTLB page of the pmd level mapping, then::
+Let’s take a system with a 2 MB huge page and a base page size of 4 KB as an
+example for illustration. Here is how things look before optimization::
 
-   struct_size = n * sizeof(struct page) / PAGE_SIZE
-               = PAGE_SIZE / sizeof(pte_t) * sizeof(struct page) / PAGE_SIZE
-               = sizeof(struct page) / sizeof(pte_t)
-               = 64 / 8
-               = 8 (pages)
-
-Where n is how many pte entries which one page can contains. So the value of
-n is (PAGE_SIZE / sizeof(pte_t)).
-
-This optimization only supports 64-bit system, so the value of sizeof(pte_t)
-is 8. And this optimization also applicable only when the size of ``struct page``
-is a power of two. In most cases, the size of ``struct page`` is 64 bytes (e.g.
-x86-64 and arm64). So if we use pmd level mapping for a HugeTLB page, the
-size of ``struct page`` structs of it is 8 page frames which size depends on the
-size of the base page.
-
-For the HugeTLB page of the pud level mapping, then::
-
-   struct_size = PAGE_SIZE / sizeof(pmd_t) * struct_size(pmd)
-               = PAGE_SIZE / 8 * 8 (pages)
-               = PAGE_SIZE (pages)
-
-Where the struct_size(pmd) is the size of the ``struct page`` structs of a
-HugeTLB page of the pmd level mapping.
-
-E.g.: A 2MB HugeTLB page on x86_64 consists in 8 page frames while 1GB
-HugeTLB page consists in 4096.
-
-Next, we take the pmd level mapping of the HugeTLB page as an example to
-show the internal implementation of this optimization. There are 8 pages
-``struct page`` structs associated with a HugeTLB page which is pmd mapped.
-
-Here is how things look before optimization::
-
-    HugeTLB                  struct pages(8 pages)         page frame(8 pages)
+  2MB Hugepage                  struct pages (8 pages)        page frame (8 pages)
  +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
  |           |                     |     0     | -------------> |     0     |
  |           |                     +-----------+                +-----------+
@@ -112,9 +38,9 @@ Here is how things look before optimization::
  |           |                     |     3     | -------------> |     3     |
  |           |                     +-----------+                +-----------+
  |           |                     |     4     | -------------> |     4     |
- |    PMD    |                     +-----------+                +-----------+
- |   level   |                     |     5     | -------------> |     5     |
- |  mapping  |                     +-----------+                +-----------+
+ |           |                     +-----------+                +-----------+
+ |           |                     |     5     | -------------> |     5     |
+ |           |                     +-----------+                +-----------+
  |           |                     |     6     | -------------> |     6     |
  |           |                     +-----------+                +-----------+
  |           |                     |     7     | -------------> |     7     |
@@ -124,34 +50,27 @@ Here is how things look before optimization::
  |           |
  +-----------+
 
-The first page of ``struct page`` (page 0) associated with the HugeTLB page
-contains the 4 ``struct page`` necessary to describe the HugeTLB. The remaining
-pages of ``struct page`` (page 1 to page 7) are tail pages.
-
-The optimization is only applied when the size of the struct page is a power
-of 2. In this case, all tail pages of the same order are identical. See
-compound_head(). This allows us to remap the tail pages of the vmemmap to a
-shared, read-only page. The head page is also remapped to a new page. This
-allows the original vmemmap pages to be freed.
+We remap the tail pages (page 1 to page 7) of the vmemmap to a shared, read-only
+page (per-zone).
 
 Here is how things look after remapping::
 
-    HugeTLB                  struct pages(8 pages)                 page frame (new)
+  2MB Hugepage                  struct pages(8 pages)           page frame (1 page)
  +-----------+ ---virt_to_page---> +-----------+   mapping to   +----------------+
  |           |                     |     0     | -------------> |       0        |
  |           |                     +-----------+                +----------------+
  |           |                     |     1     | ------┐
  |           |                     +-----------+       |
- |           |                     |     2     | ------┼        +----------------------------+
+ |           |                     |     2     | ------┼
+ |           |                     +-----------+       |
+ |           |                     |     3     | ------┼        +----------------------------+
  |           |                     +-----------+       |        | A single, per-zone page    |
- |           |                     |     3     | ------┼------> | frame shared among all     |
+ |           |                     |     4     | ------┼------> | frame shared among all     |
  |           |                     +-----------+       |        | hugepages of the same size |
- |           |                     |     4     | ------┼        +----------------------------+
+ |           |                     |     5     | ------┼        +----------------------------+
+ |           |                     +-----------+       |
+ |           |                     |     6     | ------┼
  |           |                     +-----------+       |
- |           |                     |     5     | ------┼
- |    PMD    |                     +-----------+       |
- |   level   |                     |     6     | ------┼
- |  mapping  |                     +-----------+       |
  |           |                     |     7     | ------┘
  |           |                     +-----------+
  |           |
@@ -159,65 +78,12 @@ Here is how things look after remapping::
  |           |
  +-----------+
 
-When a HugeTLB is freed to the buddy system, we should allocate 7 pages for
-vmemmap pages and restore the previous mapping relationship.
-
-For the HugeTLB page of the pud level mapping. It is similar to the former.
-We also can use this approach to free (PAGE_SIZE - 1) vmemmap pages.
-
-Apart from the HugeTLB page of the pmd/pud level mapping, some architectures
-(e.g. aarch64) provides a contiguous bit in the translation table entries
-that hints to the MMU to indicate that it is one of a contiguous set of
-entries that can be cached in a single TLB entry.
-
-The contiguous bit is used to increase the mapping size at the pmd and pte
-(last) level. So this type of HugeTLB page can be optimized only when its
-size of the ``struct page`` structs is greater than **1** page.
-
-Device DAX
-==========
-
-The device-dax interface uses the same tail deduplication technique explained
-in the previous chapter, except when used with the vmemmap in
-the device (altmap).
-
-The following page sizes are supported in DAX: PAGE_SIZE (4K on x86_64),
-PMD_SIZE (2M on x86_64) and PUD_SIZE (1G on x86_64).
-For powerpc equivalent details see Documentation/arch/powerpc/vmemmap_dedup.rst
-
-The differences with HugeTLB are relatively minor.
-
-It only use 3 ``struct page`` for storing all information as opposed
-to 4 on HugeTLB pages.
-
-There's no remapping of vmemmap given that device-dax memory is not part of
-System RAM ranges initialized at boot. Thus the tail page deduplication
-happens at a later stage when we populate the sections. HugeTLB reuses the
-the head vmemmap page representing, whereas device-dax reuses the tail
-vmemmap page. This results in only half of the savings compared to HugeTLB.
-
-Deduplicated tail pages are not mapped read-only.
+Therefore, for any hugepage, if the total size of its corresponding ``struct pages``
+is greater than or equal to the size of two base pages, then HVO technology can
+be applied to this hugepage to save memory. For example, in this case, the
+smallest hugepage that can apply HVO is 512 KB (its order corresponds to
+``OPTIMIZABLE_FOLIO_MIN_ORDER``). Therefore, any hugepage with an order greater
+than or equal to ``OPTIMIZABLE_FOLIO_MIN_ORDER`` can apply HVO technology.
 
-Here's how things look like on device-dax after the sections are populated::
-
- +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
- |           |                     |     0     | -------------> |     0     |
- |           |                     +-----------+                +-----------+
- |           |                     |     1     | -------------> |     1     |
- |           |                     +-----------+                +-----------+
- |           |                     |     2     | ----------------^ ^ ^ ^ ^ ^
- |           |                     +-----------+                   | | | | |
- |           |                     |     3     | ------------------+ | | | |
- |           |                     +-----------+                     | | | |
- |           |                     |     4     | --------------------+ | | |
- |    PMD    |                     +-----------+                       | | |
- |   level   |                     |     5     | ----------------------+ | |
- |  mapping  |                     +-----------+                         | |
- |           |                     |     6     | ------------------------+ |
- |           |                     +-----------+                           |
- |           |                     |     7     | --------------------------+
- |           |                     +-----------+
- |           |
- |           |
- |           |
- +-----------+
+Meanwhile, each HVOed hugepage still has ``OPTIMIZED_FOLIO_VMEMMAP_PAGE_STRUCTS``
+available ``struct page`` structures.
-- 
2.20.1


