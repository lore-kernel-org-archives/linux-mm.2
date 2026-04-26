Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E58D6FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 21:48:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CCC06B00AE; Sun, 26 Apr 2026 17:48:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57DD56B00B0; Sun, 26 Apr 2026 17:48:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 493F06B00B1; Sun, 26 Apr 2026 17:48:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3600E6B00AE
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:48:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D797AC231C
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:48:14 +0000 (UTC)
X-FDA: 84702045708.29.38814A8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id A14A780003
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:48:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KHuSpHsP;
	spf=pass (imf02.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777240092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MQ6M8fMmd15EsU5jHzG0CofBcVEbXAB28EkZbWFSSyk=;
	b=R0Npa1WjATfZWFON4XKIPOH8sDoxeDL7VBAAA+VtwvHB1T1//p9aC5/jQGPqAjgEa2Yf+2
	cIvvF65v6yCtVnIP+y/fxVL0p3caGCRg4cqbeeoqJ5EnKTWuGReSG+G4mlGZMoIXKuyPYB
	xYFOYCuNyNTkgku6tR01nYX0E5KCccM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KHuSpHsP;
	spf=pass (imf02.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777240092; a=rsa-sha256;
	cv=none;
	b=36hFOc6FPI8iqe32V/f110FmVzWIduvPrVZQCLLq6RppFz/tyCIC5rXhVP32ReqcLOGBzd
	om88+MJC+Yklski2e7U+YsFHk/FoZQ/B6D9frxRn7Re0vLRUF19PciaCYgM6/nMUGu36QC
	W9rDM67W+c43Dz7WdmkF3xMDzfh2TTI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777240092;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MQ6M8fMmd15EsU5jHzG0CofBcVEbXAB28EkZbWFSSyk=;
	b=KHuSpHsPoYA6DfHg3tVHcdvuH7TlR17TuA2VosOtbJ6uyCtNhDbKtEmrke4DDL7nXCMdzn
	9zS6HWp8Y5Rp/3rfGGz66AocEH28eyOVVZh5RpwJxiW7NYnQMKdGTttFbPEAJ9JFiMQEGA
	OHQox3asDBxGkaD4PSlMQdZN0PZJBtc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-303-ebHvVGFbPEiYZj02W4F1iQ-1; Sun, 26 Apr 2026 17:48:10 -0400
X-MC-Unique: ebHvVGFbPEiYZj02W4F1iQ-1
X-Mimecast-MFC-AGG-ID: ebHvVGFbPEiYZj02W4F1iQ_1777240090
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43d1fec59c9so6059603f8f.0
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:48:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777240089; x=1777844889;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MQ6M8fMmd15EsU5jHzG0CofBcVEbXAB28EkZbWFSSyk=;
        b=WHOCEsYQLeP8Rv2Rx7bdp8687Zn9DzzJzcxfFWcITgnZxuOfxTRxAaz5cBzCv9/Kmp
         A480eCvMUthEMfVjjyESAgPnSOi02xJV6AESDnxYWGd+qMVYPjauRkGLOfoD0h5W8mrP
         TsQONbb35C3csk/0mKVhrIeNb4xZu6U82uRDbUFaQHL6TXgRakyXUAUr5bXyc7UKztrq
         MZNKBt20S3g4nvuPyK59V6ufIoSn6rcCeOGFSno+0aGEcVrsgcCi3x+keb2QClJDRr7t
         kV5ZdMB5Bw1PzN2ph45iKvFEeeL7Xhn6HdGOKqALeBx9QQnxBbfy2C7iZIfOWv5ZwKej
         KbwA==
X-Forwarded-Encrypted: i=1; AFNElJ88EakNmH04jdBD5Q0JKfzuO3UY9GVcgHTUMfza7wBgUw3u/cjw78J7RPIhZVI6kEIin/njn+ECrQ==@kvack.org
X-Gm-Message-State: AOJu0Yx0R1iqsrk3kJTvL3CRFZhUDnrVePD0cCQ3/ZDHT5B+3lYqVyc3
	AsrVRM3xA5PS1WTZor/cQCZj7/M/eseT0FeVVMT1G6ZA03n03vYdoz3NvheSI6WcQz7SLdjmT09
	+gHE8YyBMzJAUk3meEd61WXcHPP2HFebUDOeZx46hlNnJpOKcuNcB
X-Gm-Gg: AeBDieu+xNG7K2HcL1e02jVOAKCexoPz6Ks0rXMwiEXaDfavB5OKrD7jwrhVm56UbXb
	OEBHVjs56M4I5bUqG8GGT3yAQTP0mo8ZNFso+z+jBUJhCIlG6BI9kmzI158oZ+mC17g3n2kCTkt
	Bw0fAJYSSkW1HzNFttUK2jXIn4rAI1xzvo3J36ZIclhK80/kH5A0ex+U90TW7fh7kj8euVBAtOZ
	8h2N/4P9NRGqQyv0aVQjbJILufKA/wfMx5idGfQoKJ07EkgZO63VrjdSPhqKPf7nq2DqNuvVxBx
	99xLMMIuTMpOYedFjfr7rmvxsdE6YviZ1xv8BHtXRbIzyC2mjlvUZ7wpPaf1bVjjzQpT3AOmq2j
	kFfhW7g3Hybs6q+Bo6O6zUfandletoeKau2JW4AweUj36tLWpmF9xoDL1
X-Received: by 2002:a5d:5848:0:b0:439:bee4:8a93 with SMTP id ffacd0b85a97d-43fe4073758mr63737391f8f.12.1777240089524;
        Sun, 26 Apr 2026 14:48:09 -0700 (PDT)
X-Received: by 2002:a5d:5848:0:b0:439:bee4:8a93 with SMTP id ffacd0b85a97d-43fe4073758mr63737360f8f.12.1777240089089;
        Sun, 26 Apr 2026 14:48:09 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-47-179.inter.net.il. [80.230.47.179])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cc0f31sm76655583f8f.12.2026.04.26.14.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 14:48:08 -0700 (PDT)
Date: Sun, 26 Apr 2026 17:48:06 -0400
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
Subject: [PATCH RFC v4 11/22] mm: memfd: skip zeroing for zeroed hugetlb pool
 pages
Message-ID: <abaa072a630ce322bd4c3c0ab2147051136c617a.1777223007.git.mst@redhat.com>
References: <cover.1777223007.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1777223007.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gN0L3aSsCIzPdAXHllJ__LyhoGBJitOmQz4J0YcXNF8_1777240090
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A14A780003
X-Stat-Signature: 75rusza8ue7pin6ho1nnjgh7sjoo5zhe
X-HE-Tag: 1777240092-97535
X-HE-Meta: U2FsdGVkX1+jdSdLJbURp+AL0U7y8hK/pFmbqPEz1Dmp7kxVrRibFghE7uhdfx7/4sFmIqeVqbOkWMbIBFYMxDeE62wzVc3l3edCqTPpBeYboXFFxycKArF/fya76TCCT1Sbzgc83nO++S33tdAw0/I321m8Z/5e03ltx9bBMOG6kJJ2wZIGezYnsWdpC5XIJozA9/o59rAremtNkj2bJISXZ6EIWuIfONUpybf8F8NMRoJcETZTOsLHZ/BeDKKWAdcmjK2UOjOnmE0Or5T8tHGLZ65DITHZ5II5JbjK9kZMmxaldSD1d4kXBiCmZ6hNjhTlTMxbeDsfudtVKEaCMJxJEZ9xuvo7OeE1HDh0GwaJDzZ6kJ0ylB99+zr3b8nnvp57xLcDznKzFAogu4ooKuqo3wuy9Fcnbtqhd03Z45kh4f3wJHruBpoBMSAF0m3OMPiBZgs1kUtQQQ4vgWcmRVn7zNoo7A7peHErPu02gxaPemEg6YoDhYKDty4y6kJwPagLLJ4BPLHPVTZu/ulPyLqb5UXEs5RDkTtyUln81Mo1r9iSbXzeL3Kc/ioZksjLMtSWy+0MBVEDzsmz0oyMAKw29WZSr0Y3VayVAR37mgSMyKj/jodGCDYoTZZMdwXEpeWLvux+msvvk/tlgPGBoVKU9ckEjZHym7nts8aI9Py4S9wkBPFmqQZpWOAOA+i6A1D2+jnuBqfnuj9IjSZZBW3HV+8hdXT2V9pdTewkwZYl1KNG/cyJ1iNpiZ7yNKBWxHhL9XJgFZF7LiZ/S0TLA71bfOMud/+WhpWcZyVbTo0scOldWC+XvvSg274usnDI2sYUaDAwMeht5cTr/f06EjoJ1N2LOU+cNSxLgjexMKYld1PUTPtKb/HT4JbxU9LapFWG0ZqbX6sYkp0J+V/Rh28Y57Du8MVlm5naoUhCS+2Bomq2H78II/X661K61iuE6BhLH95RQXud4vvwvRQ
 OZKS8p8y
 UbZkRTIxdcWv2lp6xiTQn+fYjb7gVgPWzDJ3JD8vV5ZKXBZzulcDHAPAP8wEA6QSX+jUDYftDrbjg8cNfFevqC5YoMzUbfTgfdr1bio72lIDBPoNGxhwQgMGB6aVUujFpzop6gYaKY7sUFN2BfUxDgn5z534hi4mylravymVeFULK25mNumlttOH5eseexUEpqOSBT8b4jd7OPPGxoi7MPHb6m73fhDPLKaY8bBnHz4R+WD8sH/I3xiu/rq0hKhpUQbR3IggesaMFYRqX68nFsIllGcF04z9FM09M6NcUWupzMmc7rr2p9ZIvjB/Dz8vQF6X/s4I+0M0KUD2yTyxPY/MfUIGMqrzQLIelOWyNHvmk/D+LXWRF/6DLbA==
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


