Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F6BECA5FC1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 08:53:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF48D6B0088; Wed, 30 Sep 2026 04:53:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA5CB6B008A; Wed, 30 Sep 2026 04:53:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBBC06B008C; Wed, 30 Sep 2026 04:53:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 857A56B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 04:53:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E032E1A0642
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:53:45 +0000 (UTC)
X-FDA: 85269815610.09.C272DF2
Received: from mta1.migadu.com (out-48.mta1.migadu.com [95.215.58.48])
	by imf05.hostedemail.com (Postfix) with ESMTP id 18FA010000A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:53:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=chNeUyIU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.48 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790758424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ASh1LR56EfBikA9krZgbBpC09kFpBHQaRZVce4w2D60=;
	b=iMb7El0d1MwPUtdZy7yieaSSwtsJTXVyhiv5fR6FxK6jcIQFC9t/hGiwE+TUuIJb8/zKG5
	mtrbcE5V+/+Sx7B1n3MIXOQOETKDQraWnRYpb2CqWCNqwxJ1rw7vm/L46e7ObjYL8Qo3u6
	EhETXeUj0PMK/KUFVXExkhhEqdp9ZSo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=chNeUyIU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.48 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790758424;
	b=t2RVjtzjDufk8uBXWoBf4bHZiHKnCdo7FfjEVh9k59GazB1lM41YOxC+zyV7kDtFzGJCaB
	oweqDZdcqHZgEqEfo8X5E8Ny41mMxvNz4zxMgq/KHEGqB/QcgNIIKmtQicLWebSusO8at7
	xNHojgyGOA7aWKwNfFd0aQguIeaggRc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=x3C9eFMj4s4C+4L8a6ck2RX+0F5Vx+DLli30NnboIh4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790758418; v=1; x=1791363218;
 b=chNeUyIUcRJiEYe/HzjokB4VaM4k1Frk2WTry5hanTEkS2tnrOXiHZfITnCCETi2CMJOaiMO
 a9onNnLbzGsVFzfoiyTFg60d1ZrM5Cu4ff3Nybfa2HFrZRe8xX0droNFettjFw8mGlH/4wzy2hu
 qR9xeDShk5xtbFQHMl2IcyM0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d8889dd78a97ab2f;
	Wed, 30 Sep 2026 08:53:38 +0000
X-Mizu-Trace-ID: d8889dd78a97ab2f
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: songmuchun@bytedance.com
Cc: maddy@linux.ibm.com,
	rppt@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	ritesh.list@gmail.com,
	sshegde@linux.ibm.com,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	muchun.song@linux.dev,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v3 2/6] mm/sparse-vmemmap: support device DAX in common vmemmap path
Date: Wed, 30 Sep 2026 16:53:29 +0800
Message-ID: <20260930085329.17337-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260929053231.66085-3-songmuchun@bytedance.com>
References: <20260929053231.66085-3-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 18FA010000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: rkqmip5fz3dnqemstircgwmjuq4jb8gz
X-HE-Tag: 1790758421-192348
X-HE-Meta: U2FsdGVkX18paTpqcK0NhzgRr29WJN770N6EdBG9nAV8RNQBksp82mQCHMNqG7EPTqmWByO5JNh9LVad6byazHpAP8syK2u5cQPmeRcoN+nP5j5CkeW2YJpCmZVkKbIZkp1bICuLD218m00geNsVFypvCbQVj6qdcY9JufsGEt0G5DUIX3taCnMum4EEeSyx8XwNa0SaRTgzLkVTFEP1Qo5U75eXlXkZHOujieyB5u4HIoVQzDY/LahAbYHgmgabd5/Zy/QfNIQ6qB/RiK+GkqO945/QMcpvCBIRtajZbL8d9pnVO+UliUw/YhfXs17IZ+tkOZvC1u1MW7iZ5rcGwyBg5t0HWul09gOZ7oLVv6Gktphi/cgbxVT9Hxtt+PwM5ok76q5w7a0LRtd6/5PVSCsFpUjI9CmFOGHi5mQEwBdLg+cdG8aD7gUNds72RK/BU7ac+46DB+3hGABOW3dWgTU8fFFwYooJ3BEwT8zn6Rufd0kUi5HmRtljr7iHzBMnROlCwHz56YGn6DsgBvwDozxX4DXRhu9Aa42jxzsvbpGjySUjZ1xnJUssC2ukNLwI5jfALvfgQzw2AweyhQ+NWluCUJOQOd95bzgNIyekQu55tDmjfA8UJQwudUggeVBNdYoUJnfoD5Jn7Em+hfBSY7MWkci0hdaxS3dNBHlpr9k1n6YuuZBkynzc5pfkdBNbQT33x1MFOx5UuaSKFUOQrCKxqm2ixp223fBiV3PWcByv4NeCRfVvhxduemoNoBev2L/TiomKb8zl9kGgJ1gboQZwEXoBebXp9REax18O3JBVsYWLwCYSWbKQfutACRWFOKUDDpjVEIPkJ5rH+mvJlbL7fojI0dcAfWrodPkbKZOM1X5nMNcAzpbY5pKDfaa5NpFIc2wpfToPhkPd8jqc5LMDwlY2UIWA9RW1IULSbDHUy2xhoczgdQJtgV+ij15w/y9rvGUZipGphP48Lr2
 zK1NGA9t
 G5OrB8kSPr0bBmyQPIw+KWPJhxXV7DPgN7KCsa7+J4+0+PLwwphGBVbxvjeBm/JEwEdvR/eVX4Srdkep3mBIjtIokQwFHj45W1qyLLHvaUuGe3xMjc5WgbxFkBDJAbMbf2RObsvrzV1yfWWZaxNMTegDamAy+9TraF4zzbu9EXZI18C++iNYpn5hKJquu+87tBjmN8ibooyQns8JSpYgi2/ASwF2wt4dCcYCrxr7uNKp1P7UCY0DhJsqx+hvq4Y8UkdimfxJsQb3h7UruuuTF1uCC844KUlxJWqCIxQpIb9JPPUD48dpkOjKs9YQe+1Kcy4XJMz7JunWscoo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Sep 29, 2026 at 01:32:27PM +0800, Muchun Song wrote:
>The common vmemmap population path cannot yet handle optimized Device DAX
>mappings on its own. It uses pfn_to_zone() to find the shared tail page,
>but Device DAX populates its vmemmap at runtime before the ZONE_DEVICE span
>is initialized.
>
>Teach the common path to use device_zone() for runtime optimized vmemmap
>population while retaining pfn_to_zone() for early boot. This allows the
>same path to support both early boot mappings and Device DAX.
>
>The backing PFN supplied by the Device DAX-specific population path is no
>longer used, allowing the redundant lookup and population code to be
>removed later.
>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>Acked-by: Qi Zheng <qi.zheng@linux.dev>
>---
>v3:
>- Collect Acked-by from Qi Zheng
>
>v2:
>- Expand comments around slab initialization to explain zone lookup and
>  page refcounting (suggested by Qi Zheng)
>---
> mm/sparse-vmemmap.c | 64 +++++++++++++++++++++++++--------------------
> 1 file changed, 35 insertions(+), 29 deletions(-)
>
>diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>index 8219abc6c3e5..ee4c113ca938 100644
>--- a/mm/sparse-vmemmap.c
>+++ b/mm/sparse-vmemmap.c
>@@ -237,18 +237,43 @@ static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
> 	struct page *page;
> 	const unsigned int order = pfn_to_section_compound_order(pfn);
> 
>-	/*
>-	 * Device DAX still relies on vmemmap_populate_compound_pages() for
>-	 * head/first-tail allocation and tail-page reuse.
>-	 */
> 	if (!vmemmap_optimizable_pfn(pfn))
> 		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
> 
>-	zone = pfn_to_zone(pfn, node);
>+	/*
>+	 * Before slab is available, vmemmap optimization is used for early
>+	 * system RAM, whose zone can be determined from the PFN.
>+	 *
>+	 * Once slab is available, only ZONE_DEVICE memory reaches this
>+	 * optimized population path. Its zone span has not been initialized
>+	 * while its vmemmap is being populated, so pfn_to_zone() cannot be
>+	 * used. Obtain ZONE_DEVICE directly from the node instead.
>+	 */
>+	zone = slab_is_available() ? device_zone(node) : pfn_to_zone(pfn, node);
> 	page = vmemmap_shared_tail_page(order, zone);
> 	if (!page)
> 		return NULL;
> 
>+	/*
>+	 * During early vmemmap population, the shared tail vmemmap backing
>+	 * page is allocated from memblock before its struct page can safely
>+	 * participate in page refcounting. Therefore, no reference can be
>+	 * held for each shared PTE mapping, and the mappings must be unshared
>+	 * before the vmemmap is depopulated.
>+	 *
>+	 * Once slab is available, the shared backing page is allocated from
>+	 * the buddy allocator and can be refcounted. Hold one reference for
>+	 * each shared PTE mapping. The architecture vmemmap teardown drops
>+	 * the reference through __free_pages() when removing the mapping,
>+	 * preventing the backing page from being freed while it is shared.
>+	 *
>+	 * The backing page may be shared by enough PTE mappings to exhaust
>+	 * the positive range of its reference count. Stop populating the
>+	 * vmemmap if another reference cannot be acquired.
>+	 */
>+	if (slab_is_available() && !try_get_page(page))
>+		return NULL;

BTW, shouldn't __add_pages() undo the earlier sections on a population
failure? Say the first section is added successfully, but populating the
next one fails, e.g. due to an allocation failure:

void *memremap_pages(struct dev_pagemap *pgmap, int nid)
{
...
	const int nr_range = pgmap->nr_range;
	int error, i;
...
	pgmap->nr_range = 0;
	error = 0;
	for (i = 0; i < nr_range; i++) {
		error = pagemap_range(pgmap, &params, i, nid);
		if (error)
			break;
		pgmap->nr_range++;
	}

	if (i < nr_range) {
		memunmap_pages(pgmap);
		pgmap->nr_range = nr_range;
		return ERR_PTR(error);
	}
...
}

We still need to undo the sections already added in the failed range,
though ... memunmap_pages() won't touch those, since it only removes
completed ranges.

If the range starts at a section boundary, we'd hit -EEXIST in
fill_subsection_map() on retry while those subsection bits are still set.

The old DAX path had this issue too. Could we roll back [start_pfn, pfn)
in __add_pages() as a separate fix? Something like this:

---8<---
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 796af1028ee2..16a0a2c885bc 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -380,6 +380,7 @@ EXPORT_SYMBOL_GPL(pfn_to_online_page);
 int __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
 		struct mhp_params *params)
 {
+	const unsigned long start_pfn = pfn;
 	const unsigned long end_pfn = pfn + nr_pages;
 	unsigned long cur_nr_pages;
 	int err;
@@ -417,6 +418,10 @@ int __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
 			break;
 		cond_resched();
 	}
+
+	/* Roll back the sections added before the failure. */
+	if (err && pfn != start_pfn)
+		__remove_pages(start_pfn, pfn - start_pfn, altmap, params->pgmap);
 	vmemmap_populate_print_last();
 	return err;
 }
--

Hope I haven't missed anything :)

Cheers, Lance

>+
> 	return page_address(page);
> }
> 
>@@ -260,31 +285,12 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
> 
> 	if (pte_none(ptep_get(pte))) {
> 		pte_t entry;
>+		void *p = vmemmap_alloc_pte(pfn, node, altmap);
> 
>-		if (ptpfn == (unsigned long)-1) {
>-			void *p = vmemmap_alloc_pte(pfn, node, altmap);
>-
>-			if (!p)
>-				return NULL;
>-			ptpfn = PHYS_PFN(__pa(p));
>-		} else {
>-			/*
>-			 * When a PTE/PMD entry is freed from the init_mm
>-			 * there's a free_pages() call to this page allocated
>-			 * above. Thus this try_get_page() is paired with the
>-			 * put_page_testzero() on the freeing path.
>-			 * This can only called by certain ZONE_DEVICE path,
>-			 * and through vmemmap_populate_compound_pages() when
>-			 * slab is available.
>-			 *
>-			 * Use try_get_page() to prevent the shared page refcount
>-			 * from overflowing.
>-			 */
>-			if (slab_is_available() &&
>-			    !try_get_page(pfn_to_page(ptpfn)))
>-				return NULL;
>-		}
>-		entry = pfn_pte(ptpfn, PAGE_KERNEL);
>+		if (!p)
>+			return NULL;
>+
>+		entry = pfn_pte(PHYS_PFN(__pa(p)), PAGE_KERNEL);
> 		set_pte_at(&init_mm, addr, pte, entry);
> 	} else if (WARN_ON_ONCE(vmemmap_optimizable_pfn(pfn)))
> 		return NULL;
>-- 
>2.54.0
>
>

