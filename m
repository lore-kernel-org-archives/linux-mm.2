Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2204CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:21:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 236F66B00F9; Wed, 13 May 2026 09:21:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E80D6B00FA; Wed, 13 May 2026 09:21:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FE656B00FB; Wed, 13 May 2026 09:21:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F145D6B00F9
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:21:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A5D3D140111
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:21:38 +0000 (UTC)
X-FDA: 84762458676.07.A203825
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf23.hostedemail.com (Postfix) with ESMTP id CE92F140002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:21:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=AY+nmUAd;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778678496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wk2DSdjqKxbCAHCUFPSIsYyI95cGv7pmmX0gweVd3ds=;
	b=SVq+aMXJBagmpiD/ehElEJr/hoo3ZBqC1Z32Pvs7NQzRvpvJDc0wXg6WsEG84UVllbBsj0
	6wPG01F0ZdQM2bhELoWnYkE9rHOT5r5p9l+NjHZ3BbrriACU+mCnysjObNoNrV1u27QAFP
	dG65X4qtH69efqWsHKM5WIwBn79c/Y0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778678496; a=rsa-sha256;
	cv=none;
	b=mdcNINM9uM22y/Bu5jdj4RF1s2DeeWISM9bvMD+xQ7kicMRNGwwaXCWS+lu7kXr2fGRh0Z
	F8lTF1yl9LmRIM6Io3WU9duTazVnc3Bm4nxR+qNXrmZTM0SGlBRSuoVLSYlNcmo1MC/YhO
	7xTo3kXTNDdofIeovsQsUbOI+yqDZb0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=AY+nmUAd;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3660ab73adbso4490491a91.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778678496; x=1779283296; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wk2DSdjqKxbCAHCUFPSIsYyI95cGv7pmmX0gweVd3ds=;
        b=AY+nmUAd8G3Ms5dp5BIPCeFemPRtMBZFD7rgZlI90r3uQuTaYlKkCESRe87XACOnC1
         ZVT2Hpc1Ar+d4duxymLiaQXk9LgfZF3aarZz9pEQ6zzrdmJs/FRwpogb7bQ6P/3DQE/H
         aBYLPUW4k/VB/vgcSkhreqsUhD3JWn8JXAMUUey21pwQNH/th2/ugdCGorGWaJgX/Pbn
         Ye+ziufOz0s4W/ETr3dAk0AIInQzC4zTmBAqGUe9/gLHsXIF5K6mdC93ttSaQdZiL2/X
         Sqn6mlwIkBj5ljVZ3QXh5ESogeoierTs+YXxQeSEgZB86XTD6BqQjSHOrBByvE29tfpU
         giaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778678496; x=1779283296;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Wk2DSdjqKxbCAHCUFPSIsYyI95cGv7pmmX0gweVd3ds=;
        b=WE/x2wT1xIo2/fSAshBVaZtxqvhJJMNBMlDWIMkUQH82yzLViyZVXcg1WowBzNezXC
         DvF0Ql9baMouLy3QbxOMopcm4wiY0QDjt+x8nXQIrFARPXB0Y0FcB/SeoXuxdU0KzA0X
         jilHoWiEh5n/e73DRg8juQH6EqMvjgAz/jUROwc28QfRHWOSTGidTW6nyxYr/A0AvX1N
         51o6dMGPtGLYE+bXDlRJYCqrCKP6XRqGRW7ATfU6PFLM6cbUpujDPZJSK3p4lwkZORcD
         OnJaMo+Ny/DUofcD0hO1K6bYBrrO+IT+sSA+OzngIPM/yfb0xX4y/r+u3oHwYoAXEDaa
         lcbg==
X-Forwarded-Encrypted: i=1; AFNElJ+HvMHV929UyAIpHPa6P3R5UhBgoQKc3QBWJ0+aTEjb78tyadobQo4zI5fZsISl5hT+5WO+M74kSA==@kvack.org
X-Gm-Message-State: AOJu0YwZITmbs/uQFV1TgWfDrtuEt9InUw8HxzYfCVdwyFmBHlsyajk2
	MSMZhzO7YOqJmyaY25y9Hz6/EfDhlWcGfEyNl1iD+LqVhD/gNOlnWcAfQG7PaAeCP6o=
X-Gm-Gg: Acq92OFaQiGfsvg4zhsiqSmDSWqKFkLwaPIiTyz5x+miFI0OLm0NlMH3VjKA8YC7lZR
	iiQJo5jBaTgo7lbzFBZZ8AqJLn+ZFttf5wYoKah34P+RNjZphPmCXnM5f1Zfvk2xWBHn9UY5Blg
	+PIxqHruOFX5AeGPDU8QN0bgo7kfHO1JAzl9uWX09ejNd3XjCgHZl+JwUMPY+eeuCPSOYkbB/oE
	mJYnYsrcTgflvLJu5eP0F1cj2l50csU2gYoFZIV1l4+bOQdzPaHNZMESJbeVmxjqBorxABEuuQc
	wRBQ21tUIGMIWwWyhcYTWa2hkdpTQ+hEhph/sRTc9/SETWO7PxhIH4VNJt6vtVe+MI49jQCIxeh
	vKOgxeHSEsvDRHDQIS41fG/NyGWkl7GGuttFYFhIxdv3CT0KP0Cf1T3Z8a88o24fTakD6+Ppyw5
	nKntOyfbZQM7QQpBAdyDviNLldBr1SMrivTDuvI6d2iYHKDyIZrUsFfOeyMKur
X-Received: by 2002:a17:90b:2550:b0:368:fd8b:7da9 with SMTP id 98e67ed59e1d1-368fd8b8195mr2143454a91.0.1778678495451;
        Wed, 13 May 2026 06:21:35 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-368edf7cbc2sm3098406a91.14.2026.05.13.06.21.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:21:34 -0700 (PDT)
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
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 53/69] mm/sparse-vmemmap: Drop vmemmap_can_optimize()
Date: Wed, 13 May 2026 21:20:18 +0800
Message-ID: <20260513132044.41690-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513132044.41690-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513132044.41690-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CE92F140002
X-Stat-Signature: ccr8bcepdgzzjtcsic4en7wqkprjmw1p
X-Rspam-User: 
X-HE-Tag: 1778678496-278177
X-HE-Meta: U2FsdGVkX1889XBg705AOyYlTWOZ+JQIuR9TBHfPY596mfoPmqqadEUVL0UquXS99w8SgWuCyCNaAHp77MTHKz4+hwpoWzQ/PSODBtcSTE74AvTJJs3zSoY5xb+KtWWjweEJ6WJZtDZfJRitcv5qVRV+le2+Ad9ac/mX36MCRs3PCLMMc3Ilw3yYjuGEShm/s7v2xUg6JfAEbagtiVjpPAOVEBTtTLJqX2fQPQSW9+cmFlifh3hxOtbHWrGsBf4/o/9WpzoZG9l61R6JfjT+CHJPi0U70qdehXKbvxhIPCJmHooy91wY+JZeaucXv029ZxLrpdfVjX6tgp6e5aoMZ0fQH8SlpRvBK9bt/9tO6wAQHa13DlbOYzWM/FkQaXf2+Ytbv5W/TNyY/ocopka+uvNXexoKV+vFZmvwyaKEGH40XqJz1ozpk/YWaTJhyXDFYxAF3bAsSrOOS1bQrfGeFbSDfUQNGD4Dc/on7IntxQbouqY7s8a/P49oZW5twk+vlLXw+Gu+wnj4uFo84o0KxZqgWVD48kiIo6njzFqRrYWrr/Opbyf088BaExdL5QVnuUvIneDdxbHH3cGGpSYnLCNI0/gSmIFGmH6RTZo4bDWR3A8L+ZNDww4ptY3z1WLB5BTlrHX/qITBnc4fJEOzweZDj3PewO9GZqUYC4Mps5RupiLrmrwKjEElnXaKwZavjkWXeLpL1nrxhArLtxAkVq5EVFRYJof/eP8mRmImjL8J7umEIlpzDSUFZi0og/xHE014P9huOc9mjDcG599oUC1uFDYGft5h3KLl8jAkeBYCC/6uztUaE4iVn0DpB9LmZ91QxmwW5LmYRfaLyhNYCSgJRdLpkGU7ATSbe1AgGbu9czn6lJV6FjyhPxpTBBtM3cnDY6YrIFqzPr4XETKDN1m6P4YP05rSXofueVl+j8Fyj2TAU1402eMLLi+aN25GASV75Tb0IKDiaZjg3/U
 THD30Hrt
 5W33EtTX9asXJniX83f99xOx+JdOs9EuEtqM0qf78yFquE14r9QEDIv756CdCApR1KR8HQP4fEaSKElXIMVHRw/OUv71EzQvHAULLfnBbpWWRD5PkrFNeG+HV9fbEB2h2BLZt67IVQioll/4fkMbrLt3qhTjAwmn0QSSwO6l5NlXGQmR55J4Z3xCApMlxiGrXzZPedwn8HunhtOsV0/zJ5plRwm2J7jHz5QHv4Kz1v4A89Pm/q+G5prx1fbHBrv/jo7aw9R/NPcbf/9l4+2v7hIHv8jA3tXFKIZTy4h3Xngar9D/NXKUqHkJGawegmpuiqQeMrWIueSczOqArgWwpD4XbRbDdCgMjtZha4RQ9CKAazR8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmemmap_can_optimize() no longer needs to gate section activation.

section_activate() can use pgmap->vmemmap_shift directly to record the
requested section order and leave support checks to the vmemmap
population path. That keeps the policy local to the code that actually
instantiates the mapping, instead of requiring callers to pre-filter
unsupported cases.

In particular, altmap-backed memmap allocation cannot support HVO, so
__populate_section_memmap() clears any inherited optimized section
order for full-section adds and rejects subsection re-adds. Unsupported
optimized mappings are therefore rejected where the vmemmap backing is
set up, and callers no longer have to care about that restriction.

With that handling in place, vmemmap_can_optimize() becomes redundant
and can be removed.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mm.h  | 34 ----------------------------------
 mm/sparse-vmemmap.c | 14 +++++++++++++-
 2 files changed, 13 insertions(+), 35 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5e38c9a16a0a..5f45de90972d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4896,40 +4896,6 @@ static inline void vmem_altmap_free(struct vmem_altmap *altmap,
 }
 #endif
 
-#define VMEMMAP_RESERVE_NR	OPTIMIZED_FOLIO_VMEMMAP_PAGES
-#ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
-static inline bool __vmemmap_can_optimize(struct vmem_altmap *altmap,
-					  struct dev_pagemap *pgmap)
-{
-	unsigned long nr_pages;
-	unsigned long nr_vmemmap_pages;
-
-	if (!pgmap || !is_power_of_2(sizeof(struct page)))
-		return false;
-
-	nr_pages = pgmap_vmemmap_nr(pgmap);
-	nr_vmemmap_pages = ((nr_pages * sizeof(struct page)) >> PAGE_SHIFT);
-	/*
-	 * For vmemmap optimization with DAX we need minimum 2 vmemmap
-	 * pages. See layout diagram in Documentation/mm/vmemmap_dedup.rst
-	 */
-	return !altmap && (nr_vmemmap_pages > VMEMMAP_RESERVE_NR);
-}
-/*
- * If we don't have an architecture override, use the generic rule
- */
-#ifndef vmemmap_can_optimize
-#define vmemmap_can_optimize __vmemmap_can_optimize
-#endif
-
-#else
-static inline bool vmemmap_can_optimize(struct vmem_altmap *altmap,
-					   struct dev_pagemap *pgmap)
-{
-	return false;
-}
-#endif
-
 enum mf_flags {
 	MF_COUNT_INCREASED = 1 << 0,
 	MF_ACTION_REQUIRED = 1 << 1,
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 793fd4ce1393..549be01d90f8 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -384,11 +384,23 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
 {
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
+	struct mem_section *ms = __pfn_to_section(pfn);
 
 	if (WARN_ON_ONCE(!IS_ALIGNED(pfn, PAGES_PER_SUBSECTION) ||
 		!IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
 		return NULL;
 
+	/* HVO is not supported now when memmap pages are backed by an altmap. */
+	if (altmap && section_vmemmap_optimizable(ms)) {
+		/*
+		 * A subsection re-add can inherit order left by a partial
+		 * remove after full add.
+		 */
+		if (nr_pages < PAGES_PER_SECTION)
+			return NULL;
+		section_set_order(ms, 0);
+	}
+
 	return vmemmap_populate(start, end, nid, altmap) ? NULL : (void *)start;
 }
 
@@ -613,7 +625,7 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 	unsigned int order;
 	int rc;
 
-	order = vmemmap_can_optimize(altmap, pgmap) ? pgmap->vmemmap_shift : 0;
+	order = pgmap ? pgmap->vmemmap_shift : 0;
 	/* All sub-sections within a section must share the same order. */
 	if (nr_pages < PAGES_PER_SECTION && section_order(ms) && section_order(ms) != order)
 		return ERR_PTR(-ENOTSUPP);
-- 
2.54.0


