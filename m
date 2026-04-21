Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88A9CF94CB4
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 22:01:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 023BD6B009E; Tue, 21 Apr 2026 18:01:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF0156B009F; Tue, 21 Apr 2026 18:01:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDE196B00A0; Tue, 21 Apr 2026 18:01:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C6E9C6B009E
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:01:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8F9D8BEB68
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:01:48 +0000 (UTC)
X-FDA: 84683935896.16.64754DF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 465041C0008
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:01:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="KVI/5Wsf";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776808906; a=rsa-sha256;
	cv=none;
	b=NfpXoHzchHtcFetmRz8aIWAV/wlYvDdP2M/eDGSbir0R/3uFG94b0mhyTpuCpZODEBOCgy
	XrbbPgTeKsdhUhcupHXGU09iN1NgeH52eBKDnohB7jCmfTn9ysTUbKDP/koLORKuFtHHV/
	/xC0gjsR52p2fBj9ysQC8FPaRyH4uB0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="KVI/5Wsf";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776808906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MQ6M8fMmd15EsU5jHzG0CofBcVEbXAB28EkZbWFSSyk=;
	b=65kCBI9EKG4uF9EsSWwsu9XTZkyn2cCL61i8fiMzVqFdhocIwTsIgZ80VdhilIaULTNIVy
	e1ECI8l1WAMosPigTy1HvkJQpMVIS1HONGZe6pYQeTFG68eTOE4RG6+Y+35rfqEkeAcOCZ
	xOjrUgM+4Y9RNikzcVWTn99zNdAxTqY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776808905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MQ6M8fMmd15EsU5jHzG0CofBcVEbXAB28EkZbWFSSyk=;
	b=KVI/5WsfoMDWw4SBFyeqnHy3fPl9eDrGTbOxf5ebUi8X4R+G9pP5Oxr1AspDEz9+fZDdgQ
	iGDRXFONggdyk2uEztZGe5P+vRnWO7D4bwjIXPxIkH9lJVOwZLS9Ogb2X/6S5WJWzesfxr
	etXoEef5u5YQs3R/Be3huCM9nzSup08=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-403-4r3oq8lgN6mlFLQQbYmOJg-1; Tue, 21 Apr 2026 18:01:44 -0400
X-MC-Unique: 4r3oq8lgN6mlFLQQbYmOJg-1
X-Mimecast-MFC-AGG-ID: 4r3oq8lgN6mlFLQQbYmOJg_1776808903
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-488c2cc0cbaso31079875e9.3
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:01:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776808903; x=1777413703;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MQ6M8fMmd15EsU5jHzG0CofBcVEbXAB28EkZbWFSSyk=;
        b=EbnPzcEcg/E7aMzprwPcHkmorK2gmwuxOJYcLxQthgX3xtIc9ovicW58IxoWgybl/g
         dsCNOaCxjOFRKeKKkO+ON8dmRNSj7IUAwRn2PTk3D0mfK0zp1hQFW/HEKWz+0XaE0qnL
         Q/F9qojOZ1uudCaCH0GnxSm9QQ87SyHiTcp78N+N1lts6ejO8V15HdQW9Z0v5PEmJ28W
         BZ7oYEdwnf090vfiO9hZrTdWE8UmcudhdtWZTQ0L1cX2olYqX59n8HRnYSGLbIyzihRS
         Wdx23sKAPTrmc9GJT270X+bJ3l9hjDPZ/bDw361v6B9VURfYIYJ7hcf/TCeSErsQJpwm
         TKkQ==
X-Forwarded-Encrypted: i=1; AFNElJ9E5c5kDQGKWMaU7yJKyyAtMjeBPv5bJgINJoE4bNn+j5/qHwlWlRJP9SPbKaoET2gyKMqEHByrqA==@kvack.org
X-Gm-Message-State: AOJu0YyH2wA3mrJ4te4gzwHcNUQWGqxoN4fACOdqGEhF8sXYf5P+RQvJ
	ea8DXjG11R/lH3OG+4jECVlrTvQakBJDSFfxINHdva6GJbODhVgfgrT4nc7DKFDVEEfZv4ySSiX
	d2YWbp5Rk4xPFxojkzuWjI9QdchxVjr/zEFLnsfV4DpG8aXgLCmAt
X-Gm-Gg: AeBDievT83ABlyJdRBmD5IX3WaVyxjWR6Ry+Sj+9tC+6C/lJLDnlYVaQ2Nj43q7z81I
	22m1MUaR1AKViaM72oHZpym0sCfqTQjKsTGRoR7KyXFv89HxwsjHijxNaJz69uVVE6ASqmbiom6
	hlcel7v5pu13fISdmu19yJXLWSFFx7FrkTXrJDdaAnPMHiSHbEon6Mkc/gTsYxtnJRGIG8QmfK3
	B1F2QBo3Oc/YUwaSHOKknEzSBzFOzN6e0rNRPrUwYolRjyEaATJNZwofueY3zvoRJAeov1K3J5Q
	5YjWboO7Tv0oceclmi27tAq4wrMj1+0eYyORmResPv6uLASZHa1i7VziUadytIFeBus4hMoSQmF
	yia35gY/P0Xd6I1P5zDcxaf9Qbsb7ADdjZGkpa+P8GYme4R56tmrGDQ==
X-Received: by 2002:a05:600c:5294:b0:48a:563c:c8d6 with SMTP id 5b1f17b1804b1-48a563cd0eemr57313355e9.7.1776808903002;
        Tue, 21 Apr 2026 15:01:43 -0700 (PDT)
X-Received: by 2002:a05:600c:5294:b0:48a:563c:c8d6 with SMTP id 5b1f17b1804b1-48a563cd0eemr57312985e9.7.1776808902531;
        Tue, 21 Apr 2026 15:01:42 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb1365sm42637228f8f.7.2026.04.21.15.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 15:01:42 -0700 (PDT)
Date: Tue, 21 Apr 2026 18:01:39 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	virtualization@lists.linux.dev, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH RFC v3 09/19] mm: memfd: skip zeroing for zeroed hugetlb pool
 pages
Message-ID: <d5bc27ec04ea4d7a9322315fc44c15651e31c53e.1776808210.git.mst@redhat.com>
References: <cover.1776808209.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776808209.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KvkvhonLxCskFTnAtzcPRfa9f3QwGdVyrvoMUGSoOYY_1776808903
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 465041C0008
X-Rspamd-Server: rspam12
X-Stat-Signature: 6t1xspj6gm8uyk777cy84oebdsi99kye
X-Rspam-User: 
X-HE-Tag: 1776808906-38893
X-HE-Meta: U2FsdGVkX185LF1yra7/EY8I47E7ChBixsC//6zA0rGG9X/VKiTZty4CkkZZCjuxe9m17B/t17asey0psnReZj6SEhxSg/m2hzUtkwhn9EIY+WZU6vGxpc3To7O73xdsvt5Yhp4+iKV4bzYmsyXMavpHTCdtPqUah776kuTXnFK/IB+uPqrqSzts4yXSgJDbpb2zKMNrn3VIs9FRyDD2lTRP3WuTHu9Rc+n1e0A8H3OYmRHspKl7VVDL9YyaZyABI+tJQI3+YmMEDMI0x0vtFzGBy96eZ88p+TS7TkwCd2FQ+l9b8FCDd2F9oNtO33/1qa6pPCakpndJtbL3Q1obdYDzFN3nEdifxjnmwyPKJRf9akgsIFNerII2mIg3dLT0awbUUZP1zLDhVmWrw5kh2ChgZdvnjZ+jrkWo7qnu6mYSt8BnkcpZdPt9D9aZCEVQzfFjynSZBdjp7tiric4An3CvYsuXHO01C7zDdxJRLuo/Ngdgq/+TZgGNoTbP1HeqLjl7VpiH65ovSaONFFft35ZNW6n5a10jG1BOeFs4LV3YUH4jjwwTkeA2SxH51kfWDvRNV2BDddTwahPQt+lbXkLci5UpeJJkKrn+6cs1m5YYfVBpVWxMwnKWE660/qa2AhyqLWHDwkKboQL4h5qtvHEyasG6kBWEZY3vx/9mYNAG/b1VvUT+UWC60CGa9XNNsLHoyfO38FCgngOX+5Yb1qkcWSJWLnl0gTcV7IrvI5gB0FUT9RZcJ9iLnt1FyCHOKa0iwt0esO+ngzP1qY/jcWgkZ5TNfufCrTby+DLA2jo5bcT8Hrm2B1xef0PsvIa278wd4ImEYUVEkOj1AqDjh29KSj1wECZUXj4uLnBGXejSAiCtfad+F9IqlzcOhBxBHmFbmXlGdXHp9lMrW9XoB4Uh4xDoK0a+oGLPig57XE6q+tsSNay/EmSlXMBI772qhFJVQJrfUvDXXlPRXll
 VnRBSBIv
 MaX9HozUXkh8S1BQcXA9dkNHJW1W5JSE9ierCUe46BV7V4ZA5e+1jcK3CM/Nz71dR+qQ5lXHlI6QjLD7QEaTImsjDMJEJi2D6J++81jfpchOuVqKvANL7Oh1XbGfVow8GiP/PIekj/28jxiyjD/uNOUqyKIEDKEvjZ4/X7TCiBhrx02SS3jk/aXCGvLS3+Q0dSeS+s/DdMYqR7LVp4JHUw0k843fdGmNZ7W9fIHO/M7eo5a0Wob+e8cgmV0YaVocRo7Nf1eaKEHGYo3ebHWsNBAqFiOkiM/mnVTU+07uJyH6752UF3u689hGrnfwCiFtlgKf8KA8+Iv4fLKhJogGSOdIqzK73LhClFuyjMLXPjn9vGyKJNDhGxp7Wcw==
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
 mm/memfd.c              | 17 +++++++++++------
 3 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 094714c607f9..93bb06a33f57 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -713,7 +713,8 @@ struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 				nodemask_t *nmask, gfp_t gfp_mask,
 				bool allow_alloc_fallback);
 struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
-					  nodemask_t *nmask, gfp_t gfp_mask);
+					  nodemask_t *nmask, gfp_t gfp_mask,
+					  bool *zeroed);
 
 int hugetlb_add_to_page_cache(struct folio *folio, struct address_space *mapping,
 			pgoff_t idx);
@@ -1128,7 +1129,8 @@ static inline struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 static inline struct folio *
 alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
-			    nodemask_t *nmask, gfp_t gfp_mask)
+			    nodemask_t *nmask, gfp_t gfp_mask,
+			    bool *zeroed)
 {
 	return NULL;
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4f0ed01f5b13..f02583b9faab 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2241,7 +2241,7 @@ struct folio *alloc_buddy_hugetlb_folio_with_mpol(struct hstate *h,
 }
 
 struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
-		nodemask_t *nmask, gfp_t gfp_mask)
+		nodemask_t *nmask, gfp_t gfp_mask, bool *zeroed)
 {
 	struct folio *folio;
 
@@ -2257,6 +2257,12 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
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
 
@@ -2341,7 +2347,8 @@ static int gather_surplus_pages(struct hstate *h, long delta)
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
index 919c2a53eb96..b9b44ed54db5 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -90,20 +90,24 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 		if (nr_resv < 0)
 			return ERR_PTR(nr_resv);
 
+		{
+		bool zeroed;
+
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
@@ -139,6 +143,7 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 			hugetlb_unreserve_pages(inode, idx, idx + 1, 0);
 		return ERR_PTR(err);
 	}
+	}
 #endif
 	return shmem_read_folio(memfd->f_mapping, idx);
 }
-- 
MST


