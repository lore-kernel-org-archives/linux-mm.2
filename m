Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8272C982CC
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 13:54:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 738636B0088; Sat, 19 Sep 2026 09:53:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E6FB6B008C; Sat, 19 Sep 2026 09:53:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EEDE6B0088; Sat, 19 Sep 2026 09:53:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1DCA66B008A
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 09:53:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 90A471C1EA8
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 13:53:56 +0000 (UTC)
X-FDA: 85230655272.08.51CE11D
Received: from mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6B8FB40003
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 13:53:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AAud+wk9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789826034;
	b=1bZm5Je5a2XpoR8Aft+IHaKGUE+zFYQnaAH8pfPhvlS3TVH8iIOos/cMQvJzw9AGHz12Qr
	1nlHJ8J77METWUAa55vK/kiyouqwxxMufKdE2LwD/zKe1j4cYclgjXfvFLnWMRV+e/DLsB
	tYsq4VK74CEwq4XUEaon+2nq22tok1I=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AAud+wk9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789826034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aTZR7gI7fMT/mc84gsz/ihiz1uP/MGqRfkSpP9VkRGM=;
	b=IkRX4XegFm6pI44EeL1sRKtJTlOCPaIPkUL69h1yIqvaOIkHYEjttAiVVFEygsS5F6u5OJ
	UWY1JJ8IUwmfAIbSE6GUrBY71zvXYN9MRWvc/TLMM7fpdgtDLhpL2puyS+aj6ZrI+CQPx6
	pBvZk/mXMmM5bGQ+VGcELUque6KXF68=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ulFUDD8oGZETsKoDZVeS8UP/2Tko9UtaPMINXvCETkE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789826032; v=1; x=1790430832;
 b=AAud+wk9BYaenQoL/FFK9pNb5yYL+wdD3itOwNh0fu+/foyQnSwPo90CtGCy/x3Yr6aW8L9Y
 MQ/8m4163aGeDpMrYA6hE1z6P+HrHaZL+OvfnLGgMLJFojq57JDaiAAs6mFfQF49ZHDO47Xptk2
 Ym47octg/p003kFy1g0wVyDk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f6f7a880625134d2;
	Sat, 19 Sep 2026 13:53:52 +0000
X-Mizu-Trace-ID: f6f7a880625134d2
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
Cc: Priyanshu Kumar <priyanshukumarpu@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH v2 1/3] mm: Remove unused exact_nid parameter from memmap_alloc()
Date: Sat, 19 Sep 2026 21:53:25 +0800
Message-ID: <20260919135327.74089-2-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260919135327.74089-1-kaitao.cheng@linux.dev>
References: <20260919135327.74089-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6B8FB40003
X-Stat-Signature: 7mmuet6kwz7qhetybpzy9ya4zeccaas1
X-HE-Tag: 1789826034-463591
X-HE-Meta: U2FsdGVkX18OPS173ng/FAdzg0w92roFbwhMpFzY9EapjxpMHoyrWNc2bPqquLuMI3xz00urQ2VkOy6kOnDRotAtxEuGurcrSCQGlCNMLDRD05Uxr47oPUhnAKyvJdjNWdOfS9cQ6aSswZN0AYQdfTI6JB2mBBPQzV/QoMfqojPpjGCQ5SPt6fHw/DgY8Lg0RcJaOT3MOnzSQ9bcrr8OAUx85s7zVbCx4g3RunoEPnso4T88+oUeTo7vf6pZqRznWycIwYBiYq8xIkfp041Fku/IKgRGlq9ivjDuHOQ/syX6M0FCOBEVGKjfQZvq0StHTH8pCG4Em3n5SAPYMRLa1ZDQ5sj2QzaH+Sbp/CLZkTdU3V5B/c/9xzbzfxJaEtVDYhkGIp+L+PaMBHjSIhX48XkEV/Vw3Lqw0rQ0Rxt8QToH8EmLRdHfioRxi/lfzQTU51PJAOVuRjJRfuJ04YCKtQbAhV1GVY5xDNZPlpXVI8VWUzmO5h4oF6o04yU3Wb1ffoSpZHwqGYCVS5VzSMc7RySifK1xtjFEgyhGCtAbNFY2ijwTeqlUl/4vhOG5Ln/Wh7GYHUsKet7/SvUzIiG6/xJeGvQThzLPggv/vqkhaPBRXsEChYV+yNS7UwMGzOPmrMbRaW70j2eGu439OomRZ/5LXrE94KZxHJmqlW6aDThdiKzJ3lFOxC1PNZfUMx+oNbLnCeNZB+Z+VlduiCxGQIf7oYXU1XP3QBXmfD6AIRHg8d00Dl/EWu2wnzhhvWB7O5K4w/ZtWCVN5sy15SWK7UiWKCDlYPC+C0jBik+cUxlHWeAKs3yhe+w8/48jYOPS2UUiCXACJnR08IIJXYe+efVhJg+T7SNjarrW6bzyVfr1DyjqNKpmEXbHWTyKI8pvLaJSH85Q66QWxUsPNmIfi1eUNbHVS3YxYiDcaKzIH/Murl3qBIjh7q6kThzV8ZNhwArJ4DP5c0Nd5pc7Eki
 5oi3QETL
 1Agi8cw5V1i3Cs3ZE5b9UbG2BGu6QHVSasDgR1IWbZA0i/EMgh1mWr0rWoVVIQtfLKSrMp36ZpjQQLwEz5V6zSR8tBxuv+UpaPezkDyvd08JmmHfwqy2XESyTZMJlb4FGDrUDxzJvDxU2Gi0T1xKGKNCfVf/LvFTubyiEL7wHN29yK0s3AM+4rrwKF2/wfboP6LRgKPhi4FNud2g6xvy2VZkhvYlri2II8k9RWVLINdc42+THM3Equ2B6hQ9T8CMok2UKQnp+hMlwPJtHdKjwtojkVg==
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
index 9ce6060de06d..af3c8a2cc91b 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1596,7 +1596,7 @@ static void __init free_area_init_core(struct pglist_data *pgdat)
 }
 
 void __init *memmap_alloc(phys_addr_t size, phys_addr_t align,
-			  phys_addr_t min_addr, int nid, bool exact_nid)
+			  phys_addr_t min_addr, int nid)
 {
 	void *ptr;
 
@@ -1604,14 +1604,8 @@ void __init *memmap_alloc(phys_addr_t size, phys_addr_t align,
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
@@ -1639,7 +1633,7 @@ static void __init alloc_node_mem_map(struct pglist_data *pgdat)
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
index 96506f594924..dbd1ebe93fe9 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -62,7 +62,7 @@ void __ref *vmemmap_alloc_block(unsigned long size, int node)
 		}
 		return NULL;
 	} else
-		return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), node, false);
+		return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), node);
 }
 
 static void * __meminit altmap_alloc_block_buf(unsigned long size,
diff --git a/mm/sparse.c b/mm/sparse.c
index b75921c622ed..36692b1dd733 100644
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


