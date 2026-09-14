Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE33EC88E67
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 05:52:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CE186B0088; Mon, 14 Sep 2026 01:52:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5586A6B008C; Mon, 14 Sep 2026 01:52:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4001F6B0092; Mon, 14 Sep 2026 01:52:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E0916B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 01:52:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0B678A66E1
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 05:52:01 +0000 (UTC)
X-FDA: 85211296842.14.3FE335C
Received: from mta0.migadu.com (out-203.mta0.migadu.com [91.218.175.203])
	by imf30.hostedemail.com (Postfix) with ESMTP id E6EFB80006
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 05:51:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ThJ80XWe;
	spf=pass (imf30.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.203 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789365119;
	b=l4rRI+Ev11tQn8u6rhK2EUC5VeDhqZGG7akG/SVu/8FgKS6aRvFSR061+QaupiB1617D4x
	j/OGi4dZxTUQJ2qwP4YsCWrIpgpFX+ELb1sOQ9SFWZPOCxNTEFzc7VuNMQeIS5CUqZZ0v0
	mxoeZvxqL1fs3weJ7DPuDb8QTs3JGy0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ThJ80XWe;
	spf=pass (imf30.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.203 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789365119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=v66ivqIMDFuWgKAwoa3oZQN+R4OXnr1+q7NmuIhSlWc=;
	b=AI9kP9ZlgLauphS+Gf4RtXzh9jirMMz/PRUEFAhMIzJmHe6LGawpGbl5MU1EUsjqAQgslP
	Qm0/Ma/thVYQHhtqxXrymcxqKnVvhmi2gg2TbbOVY0Ge6vdNuWQJHK3vJuM2Vk2mRB/wD5
	Du3Y3cZk+C6LBchdkrEHmbfeCKTNiqc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/NS2cYHCYHJ/0eGJGe+eF9LIr8ddlAWg9kGdRp8KM6E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789365115; v=1; x=1789969915;
 b=ThJ80XWekG9Zh5BforIeafL1Fyd9/AlF/+ake25FUNDgMA5zj0L2xP4cUis0GI7sDaEhYiZA
 liJJX3z+5W3JrbrnQLGbdpkp044dzu1hgy0zLsx7OyYnq+jWcdSrWJH8ozVYQcmfe5aFs4EPrUd
 06M+f2HpseelDCPtVkU8wmmU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ca6bac79af6cc17a;
	Mon, 14 Sep 2026 05:51:45 +0000
X-Mizu-Trace-ID: ca6bac79af6cc17a
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH] mm: Remove unused exact_nid parameter from memmap_alloc()
Date: Mon, 14 Sep 2026 13:51:30 +0800
Message-ID: <20260914055130.44543-1-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E6EFB80006
X-Stat-Signature: jb8x5ai8ynmuokm5jpxj1s4obizdqacb
X-HE-Tag: 1789365118-426306
X-HE-Meta: U2FsdGVkX1/1JTjkGwd62Ry00pKZIpeZMflRminnfsfgVNKmw8oCJx0D+ELeZ7sUpcIsd22eK2vURxADqJb+r3qp0e8N+sz6uR5PEp1WSkxs4Dc4dpDshLk9gyNqyPrnw5NU6h+E8bMWemBGzzAHBuX/VntUdVtLcnCkrDKJWRz5gTuWCMg/wz0xNKgr9OJvS+SB+wdZvY8QMVRpuAWBBKofYUdy47MnAIYtPW2XPoWlMmgugEYf+N2jMpL3gUhB+/pZ2SJUTFkO9j5TU02IrDSQ1/oQshYiZOgdMUzAw089diD6mwtQizuwfv2SV/BDY3Bvqgl+zAGHW4c1S6rmnfezZB5EpawU2sVbCOlSB0veOR1GQ52cu4YJs2kd7JQST484OX1PC6n2ThoGSKQqctnHkC5xXltAUI7yUvh0UJ/Juob+CMorjqJd33nMGEoooFsl6UmYQztPM01/mj9AxisGcydCVrwEeZnE9MTRYe7Dy1Pg3Z2FUt3rbjIOGebeQly2gRT2FtGOSHpSqZwUUG5wRZqr/LJ32EXeJdfIeqZZkSaO7TVkCV1AnK8qnQoWDxvXKxnpSWXXrF4vSfsIIUglAfB7ATEuO51KgOhjTmp6prKTB6RulNvmhg5p4a0UErM9449IcbdUP8R0GZ6Wabu0TCDT9vM/EsEoZ5imaIsE932Tmj3VRMXtYtKy4biFOPR9g1ReT7nrfp/qQfX7TYJ+XMfeQUu5nn+SUYotyhjbji+Rlxan/2aISvuqXWBYPtr7fUIlA+y9OPr2vntwA5lJkMF6zSN8wlDFtZlEiq9+HRRqOp+LGNWnp7ZNYIjqbn0nSSRgQyau3/uktyQoaPObIQscdR3zIMZmXnJaWICBkqswbNnZrN3Oh+GtfBKwtbh0NXYI6vOqWH/xggN6BKcHekdf708AtVGG2DkaO4lJH1jYOLBV+T0AThKf039g21H4VOZUHk54/mGDqc/
 6VUdn5ek
 aPxhodo+H42khlLYITjsFJdcdEYOKTpmHACzWIys6YdPskDQz40nUoRLMYwHry1awzg1AiUAPV63NoDexaLhYjY3xX6SGMIwcsaemqvOn1WtNYWt8xQztXSJqP1bI3t/zBKVUGF+mzHxQ8rgSWzyo5NErXGKHXzyBGpcZYZCP2lTgxzZcxqQdnSWkbx4Z0lPAD4B03idHUj3vdRyqyZFnMkoANee8Kp+GPJdPVx0Az7dK4Oyv20xuPWobwA+DZ2MeuV0528SuFWDIV2LduKXad7QNXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kaitao Cheng <chengkaitao@kylinos.cn>

Commit ffe55393137c ("mm/sparse: remove sparse buffer pre-allocation
mechanism") removed sparse_buffer_init(), which was the only caller of
memmap_alloc() that passed true for exact_nid.

All remaining callers pass false, leaving the exact-node allocation
branch unreachable. Remove the exact_nid parameter and unconditionally
use memblock_alloc_try_nid_raw().

This has no functional impact.

Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/mm_init.c        | 14 ++++----------
 mm/mm_init.h        |  4 ++--
 mm/sparse-vmemmap.c |  2 +-
 mm/sparse.c         |  2 +-
 4 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index beeeed4688c1..6af5cabf3e75 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1601,7 +1601,7 @@ static void __init free_area_init_core(struct pglist_data *pgdat)
 }
 
 void __init *memmap_alloc(phys_addr_t size, phys_addr_t align,
-			  phys_addr_t min_addr, int nid, bool exact_nid)
+			  phys_addr_t min_addr, int nid)
 {
 	void *ptr;
 
@@ -1609,14 +1609,8 @@ void __init *memmap_alloc(phys_addr_t size, phys_addr_t align,
 	 * Kmemleak will explicitly scan mem_map by traversing all valid
 	 * `struct *page`,so memblock does not need to be added to the scan list.
 	 */
-	if (exact_nid)
-		ptr = memblock_alloc_exact_nid_raw(size, align, min_addr,
-						   MEMBLOCK_ALLOC_NOLEAKTRACE,
-						   nid);
-	else
-		ptr = memblock_alloc_try_nid_raw(size, align, min_addr,
-						 MEMBLOCK_ALLOC_NOLEAKTRACE,
-						 nid);
+	ptr = memblock_alloc_try_nid_raw(size, align, min_addr,
+					 MEMBLOCK_ALLOC_NOLEAKTRACE, nid);
 
 	if (ptr && size > 0)
 		page_init_poison(ptr, size);
@@ -1644,7 +1638,7 @@ static void __init alloc_node_mem_map(struct pglist_data *pgdat)
 	end = ALIGN(pgdat_end_pfn(pgdat), MAX_ORDER_NR_PAGES);
 	size =  (end - start) * sizeof(struct page);
 	map = memmap_alloc(size, SMP_CACHE_BYTES, MEMBLOCK_LOW_LIMIT,
-			   pgdat->node_id, false);
+			   pgdat->node_id);
 	if (!map)
 		panic("Failed to allocate %ld bytes for node %d memory map\n",
 		      size, pgdat->node_id);
diff --git a/mm/mm_init.h b/mm/mm_init.h
index c9fc35e7e9f1..a8ed5c20851b 100644
--- a/mm/mm_init.h
+++ b/mm/mm_init.h
@@ -31,8 +31,8 @@ static inline void clear_zone_contiguous(struct zone *zone)
 
 void memblock_free_pages(unsigned long pfn, unsigned int order);
 
-void *memmap_alloc(phys_addr_t size, phys_addr_t align, phys_addr_t min_addr,
-		int nid, bool exact_nid);
+void *memmap_alloc(phys_addr_t size, phys_addr_t align,
+		   phys_addr_t min_addr, int nid);
 
 void memmap_init_range(unsigned long size, int nid, unsigned long zone,
 		unsigned long start_pfn, unsigned long zone_end_pfn,
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index f22d815d7af0..c2fa5fbf0972 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -53,7 +53,7 @@ static void * __ref __earlyonly_bootmem_alloc(int node,
 				unsigned long align,
 				unsigned long goal)
 {
-	return memmap_alloc(size, align, goal, node, false);
+	return memmap_alloc(size, align, goal, node);
 }
 
 void * __meminit vmemmap_alloc_block(unsigned long size, int node)
diff --git a/mm/sparse.c b/mm/sparse.c
index cc28bb41fdb1..f032c98b92d9 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -215,7 +215,7 @@ struct page __init *__populate_section_memmap(unsigned long pfn,
 {
 	const unsigned long size = PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION);
 
-	return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), nid, false);
+	return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), nid);
 }
 #endif /* !CONFIG_SPARSEMEM_VMEMMAP */
 
-- 
2.54.0 (Apple Git-157)


