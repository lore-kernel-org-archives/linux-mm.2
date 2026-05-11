Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0BCACD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:03:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 531D46B00EB; Mon, 11 May 2026 05:03:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 509B16B00EE; Mon, 11 May 2026 05:03:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F9476B00EF; Mon, 11 May 2026 05:03:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 275B76B00EB
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:03:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C8BCF1A0676
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:03:19 +0000 (UTC)
X-FDA: 84754550118.18.8269017
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7C1B618000F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:03:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O8Z9UsVL;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q0Jd/7EvCnA8N9ANiNsWM9FOCa/+r1oqSAVkRa3NTmw=;
	b=8GWHtJhM9ajZ2k11F3AqvyC0zCOwJB/tMT4KlY77A7VpCz1dHENA+epzkddFx3sQdiNtXf
	GREgbgu8Sk+LVzOnSbzUwSwkEqYLnaMuR3HbukrBW+QfFGvKMsQdXUCkN9e1FdOq2k3JOf
	g/G7Mogb3Am/LkfSi5+hdPtIxGabrv8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O8Z9UsVL;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490197; a=rsa-sha256;
	cv=none;
	b=V1hGssRrq848YNVKKGhWC/mrsxnv0Y0uHivELFr1c57I7rfjbXDPr5Jnaap6uf6GWXajYX
	chcEGG/teDVfqCC02AcUD/BBUVIVaNYXur+Q7ccWdqDAYYX8jRtMitx+UBcAOKpAdnNopB
	TCBqCDNzf6epdZjvQV+FJJJ54yseAy0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778490196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q0Jd/7EvCnA8N9ANiNsWM9FOCa/+r1oqSAVkRa3NTmw=;
	b=O8Z9UsVL9FiHBrcjrZPDG+zj+AaP7X5VPhb1hKGpGPR/OHbHI5zwpdcR2m200/HG0QcPt6
	w6jYOmRthIlwpcJohYBalhu2ha4U1RwvTiuJYueNEpTuCtYUq7nlL9kCetNnZRzg3WaDN2
	h5iV/5eQni2ukef/0/YDpOjn7GuB8r8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-357-kfL8PKcKNDqtfoc3N2Mzew-1; Mon, 11 May 2026 05:03:15 -0400
X-MC-Unique: kfL8PKcKNDqtfoc3N2Mzew-1
X-Mimecast-MFC-AGG-ID: kfL8PKcKNDqtfoc3N2Mzew_1778490194
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48e7572b739so8440125e9.3
        for <linux-mm@kvack.org>; Mon, 11 May 2026 02:03:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778490194; x=1779094994;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q0Jd/7EvCnA8N9ANiNsWM9FOCa/+r1oqSAVkRa3NTmw=;
        b=jv1YgX8WYYTxegfoH/ESY+FQPeipsuS3LCrc2aA0X3f1NcAH4DqwEirK4gn/MIh2nf
         JjwrY2mZGoXoOXBQLJ+bcIRB3VEcFSIg8x/L0gijFcFQLvY8BkLWW9wJXmoH0pO6je5t
         mCrPojplbW1dKnUxFIX0csdMk7sNb5MIPQFAfzLBqQktXH+Yjha1+VwTWEpoxGTG62Uv
         EOdA4CEhAu0dh2qZNRIKvDNhNKxPV4uz97ud+BPThBBHjOI0s2NE16GPGxesFVcRUc+Q
         emDTeoUQnPDtI9e3hEV8EIjhGX+S0BE1bM3Jx/IMVh866fiyqLHM5ei2AXdRqQJKNuRX
         D6nQ==
X-Forwarded-Encrypted: i=1; AFNElJ/AiyQ6ler+jyu4R/x45hk0lJoKGuQYj0Qk1vr0DYc8RuED5bAn7SIxrL8TbRY0Lvr+V7a1cF/C2w==@kvack.org
X-Gm-Message-State: AOJu0YyklHErKWDK/rLMOFO6T/c2X50RSeDLBw8uRVa51Huwm0KZrSqb
	75E654nIMxDE7zdyemzLuNp9aUa36Yn8UWwTMeiuQJakzYKCEkX/ETUN2kEWPcGNctGgWNFiSHs
	w0ls7qJ9QtLNArLxyx6+P5MIGrpu8j9sGTFPtSQpYhy/n+CmkSjKf
X-Gm-Gg: Acq92OEEmlrHfwvI8cv6u9l8XuQY4Oy+S//5Ut6vIrr0bxLz20m9bOzWlUlFoB7gB2v
	DwTV3oIIayarYoITUF5CMYaaibDoHPsbUga98CX7crwvQSYeueTJnDMAEcWNVyOYekXGHRnZbLx
	EZ/bX8cjxIa2W0fBJFnWTgdnV9XY/ulUgpKcyxHw1IsANlmHqWv1DBMDSw1uMnOTuKRLCFOwSLB
	VyrH0BYZnykhujsQYpe3iHx8hi3gu0mKeNh8kn0uFeN6bTukbMUmdKIedU50QIyRG+qCGzYiSS3
	XFS4AvRMv1eHyFF8Hkg1FPR4tT+T4lOt8QtyUIvJIWfl5HJYd1Ok/pdU2IFLKKMsZ0O+zP2A3UE
	dUS4cEbq6uTstD1r2BpWXUjKP0S2ABEpz0tSnj5Vo
X-Received: by 2002:a05:600c:4355:b0:48e:85b4:ac7b with SMTP id 5b1f17b1804b1-48e85b4ad2dmr11169985e9.18.1778490194049;
        Mon, 11 May 2026 02:03:14 -0700 (PDT)
X-Received: by 2002:a05:600c:4355:b0:48e:85b4:ac7b with SMTP id 5b1f17b1804b1-48e85b4ad2dmr11169355e9.18.1778490193392;
        Mon, 11 May 2026 02:03:13 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e6d8946a5sm98618955e9.0.2026.05.11.02.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 02:03:12 -0700 (PDT)
Date: Mon, 11 May 2026 05:03:08 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH resend v6 15/30] mm: memfd: skip zeroing for zeroed hugetlb
 pool pages
Message-ID: <a39ab8288aceb244bdb31141aa9cf67106c0e042.1778489843.git.mst@redhat.com>
References: <cover.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778489843.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pukDoT_kmi-q_hdrQsqAinRpUC-Np3nDL9IE3onqet8_1778490194
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: y6z88uop35ka6x5go8ngoeypiezytf3i
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7C1B618000F
X-Rspam-User: 
X-HE-Tag: 1778490197-529369
X-HE-Meta: U2FsdGVkX18im/edfdFEm/fsYMMIoefyFkJQZXr6PqnTco1DjATg9XoQHvMS6fqCUd2pSEhKjdnPGnh7X5sUPo/z+b/tY6cPzq4FZKSE3mJtppz0P3N1YcEExuLFZQEkjPu+ZfhlVLKyRnHtRpnFguDlUCsN2hWLU+pRHuO3cu/LXnp9ucVyNEK+NfAF9Zs4pKBuSb46Td1YFLeM3lpYu1W72JDSxlD+/1xFN1cWOO/EdFbbACSA+VJO6dLgy/9rMZU4N+hEmAwkML1hjvodGzN51sqLR6x0o+riQbVLEpSWJTeC00iqgHqfEtMHPhZztuptBw6q2G/G/nCm9/IzKjDBMcs2vuTFO+Z9L0WPXTefqd5T97YgOwwDHakbp0SDFngjJxKUzWQ3VCEGl5Aq9QWAhPtUflQz6f1ExZxWEy3OSXoM3nRmOuj8HhQLxjz1e1oKdeUPC+nhIO6VMNF9CpvYBHPhwcGsmYuEwYPunZpRdJt2OTTxbR0619QmSol9w5Y6wQ9cykpuUGwOsnM31qw1k75E1PVDMjjdY05gnb8UQlV68A0n45jhftF5mw77cV8fIFv/zMpTjqYy0nq3FqHIvBHxP0XmBZc6M4j2GGq2WZ2dQB3K8JUdwZpj1GXR9rH/s/qVLM9QH/GAZNkDnvYeR3ZVpNWQgz7og5aNKGhC0/xaAPWWdWc3OcCUSS3UcXxvotxuKktJe9zF6y9JHGWxTpR+yi3wjEJLJtliGWy0pmq6Tbqr22YS3Rkzp6Ljs362twUNr1vBdJsDlEpvVaSRBxmN5IWUnTfsHzroVIJQIQsn2bp6UB0Jw3LjM1qdv9uL4M935/JtWc2YfZOy5xdhB3mcbIhNT66zujuCkfEe62bf76mtdOlyNYnAlyxejRiJdpPkXdN8FyfErFxZw+vyYhj5TaMSRRlTA23h8FjoWxK2uVrrgEE274qnSb7nBfuDbrkd/w2OB7Ns7tj
 NRGmeTAw
 ECy1ILEiyskB0iSjO2l03JFWCL/JImr4CRHakCm3NfaZJCOIjEhrgxeG6oPwz2wlk54PBiICNRCgZcY3zLZq/BBWLuD592+qkV0Megfd4BbfZkzxUrWniznh7f4s7jKHzqa8RskzO2Nd2Vf1ft3kj13++uMBQUSp9tdeqEEK66WBG0yFq5TK8hJGVAp8KMywT2Evx0nDdFWfdM1nHc/ImV4ae2mYHtPiZoQ4eEQEe7yiZtPaA6P4z1iH3qjCzebM73T1XBtlVzo6oMUSzNnC61mLGKBTbgbJZdZ4ACK8Fjathvd/w34CrIGYpXCnqTM6MUi8g0i1vKcs3TGbzwsZCZSY7xlhtZSSPYg5KRZYhLzJWli5qudfnUm+jIfZGcKI1ns++IN/tYILkM7w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

gather_surplus_pages() pre-allocates hugetlb pages into the pool
during mmap.  Pass __GFP_ZERO so these pages are zeroed by the
buddy allocator, and HPG_zeroed is set by alloc_surplus_hugetlb_folio.

Add bool *zeroed output to alloc_hugetlb_folio_reserve() so
callers can check whether the pool page is known-zero.  memfd's
memfd_alloc_folio() uses this to skip the explicit folio_zero_user()
when the page is already zero.

This avoids redundant zeroing for memfd hugetlb pages that were
pre-allocated into the pool and never mapped to userspace.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/hugetlb.h |  6 ++++--
 mm/hugetlb.c            | 11 +++++++++--
 mm/memfd.c              | 14 ++++++++------
 3 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 950e1702fbd8..c4e66a371fce 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -714,7 +714,8 @@ struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 				nodemask_t *nmask, gfp_t gfp_mask,
 				bool allow_alloc_fallback);
 struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
-					  nodemask_t *nmask, gfp_t gfp_mask);
+					  nodemask_t *nmask, gfp_t gfp_mask,
+					  bool *zeroed);
 
 int hugetlb_add_to_page_cache(struct folio *folio, struct address_space *mapping,
 			pgoff_t idx);
@@ -1142,7 +1143,8 @@ static inline struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 static inline struct folio *
 alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
-			    nodemask_t *nmask, gfp_t gfp_mask)
+			    nodemask_t *nmask, gfp_t gfp_mask,
+			    bool *zeroed)
 {
 	return NULL;
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8710366d14b7..03ad5c1e0655 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2205,7 +2205,7 @@ struct folio *alloc_buddy_hugetlb_folio_with_mpol(struct hstate *h,
 }
 
 struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
-		nodemask_t *nmask, gfp_t gfp_mask)
+		nodemask_t *nmask, gfp_t gfp_mask, bool *zeroed)
 {
 	struct folio *folio;
 
@@ -2221,6 +2221,12 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 		h->resv_huge_pages--;
 
 	spin_unlock_irq(&hugetlb_lock);
+
+	if (zeroed && folio) {
+		*zeroed = folio_test_hugetlb_zeroed(folio);
+		folio_clear_hugetlb_zeroed(folio);
+	}
+
 	return folio;
 }
 
@@ -2305,7 +2311,8 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 		 * It is okay to use NUMA_NO_NODE because we use numa_mem_id()
 		 * down the road to pick the current node if that is the case.
 		 */
-		folio = alloc_surplus_hugetlb_folio(h, htlb_alloc_mask(h),
+		folio = alloc_surplus_hugetlb_folio(h,
+						    htlb_alloc_mask(h) | __GFP_ZERO,
 						    NUMA_NO_NODE, &alloc_nodemask,
 						    USER_ADDR_NONE);
 		if (!folio) {
diff --git a/mm/memfd.c b/mm/memfd.c
index fb425f4e315f..5518f7d2d91f 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -69,6 +69,7 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 #ifdef CONFIG_HUGETLB_PAGE
 	struct folio *folio;
 	gfp_t gfp_mask;
+	bool zeroed;
 
 	if (is_file_hugepages(memfd)) {
 		/*
@@ -93,17 +94,18 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 		folio = alloc_hugetlb_folio_reserve(h,
 						    numa_node_id(),
 						    NULL,
-						    gfp_mask);
+						    gfp_mask,
+						    &zeroed);
 		if (folio) {
 			u32 hash;
 
 			/*
-			 * Zero the folio to prevent information leaks to userspace.
-			 * Use folio_zero_user() which is optimized for huge/gigantic
-			 * pages. Pass 0 as addr_hint since this is not a faulting path
-			 *  and we don't have a user virtual address yet.
+			 * Zero the folio to prevent information leaks to
+			 * userspace.  Skip if the pool page is known-zero
+			 * (HPG_zeroed set during pool pre-allocation).
 			 */
-			folio_zero_user(folio, 0);
+			if (!zeroed)
+				folio_zero_user(folio, 0);
 
 			/*
 			 * Mark the folio uptodate before adding to page cache,
-- 
MST


