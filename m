Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83D1CCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:21:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB2A26B0099; Wed, 20 May 2026 18:21:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8B2F6B009B; Wed, 20 May 2026 18:21:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA0DA6B009D; Wed, 20 May 2026 18:21:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C38606B0099
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:21:03 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 892021201DA
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:21:03 +0000 (UTC)
X-FDA: 84789219606.27.4044338
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4C14A180004
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:21:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Sw6MH+6g;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ri6YQ3HlLjUAH8mONUkbxIg9Wl46GlG+rJaCqygm0zg=;
	b=ZZ9qYBWg/UlYYA5G0Gdv3MXJso+QEOYp6huVuSRb2xjVPosgfnZEWluxyoy+38m6wf7pPo
	cr3pbUYOqfOZEewmiUul51w757zFbQIW5DfOtp76GEq9owwOzE24d9lRHKM3nJoayRvpWP
	Q3D5VmZuVFRsqtOs998ffpXKpMjuGKM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Sw6MH+6g;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315661; a=rsa-sha256;
	cv=none;
	b=R/XeMYr++djCkV0nGyPAafyfpFuzRZWcwUSBzJizeOQtMFNhJ/0bSeGozs4JP2hTdtPRm2
	X2L71Ecp64fUsI4C9xMZoZ8t1GUGchgv9AV69TLmJMaSYpHlnFcwCaKhlpuFa3RjWWWi6C
	9v3KVYlrPqQbPSUezKvvG/bsGaHZXc8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315660;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ri6YQ3HlLjUAH8mONUkbxIg9Wl46GlG+rJaCqygm0zg=;
	b=Sw6MH+6gAReXKx/fohgQ7Pku/zlk3KMXc7eTq4sc8B8A/h79uC/fzFDZLx2dlbH5AHu8UP
	RgA8/TK6H8lJLjsIaoc1V+s25Z3Y6tUlLu5oRw/0Ito8I9P4I0W/FHIniEXhPSbXRS0dzD
	g3Ckaw9onwCc1Ld25Hg4FYEPbNwFEW8=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-363-b-8KYIRbNySq6XaVAHEiVQ-1; Wed, 20 May 2026 18:20:59 -0400
X-MC-Unique: b-8KYIRbNySq6XaVAHEiVQ-1
X-Mimecast-MFC-AGG-ID: b-8KYIRbNySq6XaVAHEiVQ_1779315658
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-39391b06ef8so32265921fa.2
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:20:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315658; x=1779920458;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ri6YQ3HlLjUAH8mONUkbxIg9Wl46GlG+rJaCqygm0zg=;
        b=QLmkwGMoFEXxiKxH2xwiSJvQ7/hOSmN6cOqV5+kcf0VNQPgdYAhupWfI9F0cbrwHFp
         gQckA5osmdX+Oz4A0RlXDpfhyG5fbSrGrha6UyJZlTjZk//If32Y3XniY0rZCiSttk8q
         V488DQO0HfZpbu56XTUzHbIsNjGqtd0m6JxmL9E4z9g2bxDINi+9VA+A4mfcVYcczrYT
         LrLhoqpnlHjYFQ6R3sINKCxwVdtNQ3ZNzwYT61NoqrtZP9A7XqDFTsto7lS08hKInIsT
         AnQ7q0/i7LbPK0o0+3323kUdJWOnIenP+Duwn34bIhnfOUAUuNjocCZGzZzOp3yYrL06
         pxDg==
X-Forwarded-Encrypted: i=1; AFNElJ9Dd+6yh3RRrl2EFBx+kpJ08qqR4M4d1s68PRYHrwckFePssYNg+XAuqJj7hmZoqLy/zK7EanSG8g==@kvack.org
X-Gm-Message-State: AOJu0YxiPSkKcla5D6JPCeMMxUI2gGvw/gMtBMq0b0Ycx4nQGkGAF1RQ
	6SUvgbipRY6ymKQQZjQN9RUpnkxJKXgOE9B/px4TtW7IPMjIYjDqHb3oZS96uclbwYNw9YelW3t
	gwcxjAkXQ8kQID3LOrGZ/OZ76qFt5TnF/sG2hntymBJziidncnN0L
X-Gm-Gg: Acq92OG1rK5yqjnE3k4J2Jn4Do1dRBMQknjOTuJQg6xd3fUuDOAc7c1BUhubI4IG8aZ
	0m/2oercX01OCHMv0ZPZdF4lOasBNNq+vLFnAS44diOzqDNEsOa97xh14UanQhBEgWyfPvgA32X
	1Q6izmd2TMVuXIqAHRB8OZx0nDw7BpYVfhGdrPOrp++6sTDmONzR9Qjuj0/kF8QQJsnyBt6nnBg
	iJ5fZOvHFcyDO6KR3jIRySPODut8cRu6wn+y1YCL/dycDmMMhYSnUXQYPwf+nFx79ocptdXVLBh
	4H5epE2IngtcHu7tKrAbiOTMpK0Gg1ENHndGs6xUDFoshKlWuVOgk+6d+afAOpIhmvCdqh3QgKY
	8lArbfePxLkgk7d5TewBjN8LV9TlGrBJhZKnwy3a66Mk=
X-Received: by 2002:a05:651c:1512:b0:38a:45d6:c246 with SMTP id 38308e7fff4ca-395ca1dfb3emr1246701fa.8.1779315657827;
        Wed, 20 May 2026 15:20:57 -0700 (PDT)
X-Received: by 2002:a05:651c:1512:b0:38a:45d6:c246 with SMTP id 38308e7fff4ca-395ca1dfb3emr1246201fa.8.1779315657241;
        Wed, 20 May 2026 15:20:57 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-39588791302sm31998751fa.32.2026.05.20.15.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:20:55 -0700 (PDT)
Date: Wed, 20 May 2026 18:20:48 -0400
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
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: [PATCH v8 06/37] mm: move vma_alloc_folio_noprof to page_alloc.c
Message-ID: <caf74b4efdaff24d77e6c9aaee6b431f53ad8335.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aMUULY95CO_pBKzX3IVWbnceIvi7QSykrQv61xTJqiw_1779315658
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4C14A180004
X-Stat-Signature: w4kpeou5dy5r8pos8srmfptf919sq7to
X-HE-Tag: 1779315661-576008
X-HE-Meta: U2FsdGVkX18idZrqTM08MKpiPgRVZBXRzrxW6CL5tvXjiNdEwno2KitJ7xRjoSiyO2B+hrBDxzasRGXLTUzzDYMjH6qVpvnPl4POENJ2IIDUGcKqANuFgxq3OYQHk/PNLNxlih1i3Dsg+smGMWYuw54TpGkYQKWWyw0AL4nKrPjGDQTNVPUCewPd+O2X2HCIzROdFPPHI1aVgApkpbQ81yKk28ZOD2AvxXEz2BXUGjMCfFNYa4oblHtiV/s/EE3fWbZUSBGQjwMzfUUd4aZFO8OfeyzBdrZscwuwB+f7E2q76E8jrzq5PsCXMdL+/O8YouJvXUNtjYdO3nSV/n9OkxHUXFtRCmRdPZa3jorV6hREcMfDTxL8TH0VpL122CZyfHB67gz35VPfE4zP00JFwShccXKAcuujO088r8R1xPfXwnANJKg4gcme1zqYosyU0YDTxEgs6pE17Te8XYDmx5Cmig2Syj4SQC5JfpIrXGJ+fF3dEsfyXuH5Ft8CVqS6vxsbL59uGHBkeVPiFyeD+Xmkw7OdnFY9x687Om1qsWpi2YDbp7xmRj2YDh8qbXqV65unMm06ftUkzwoXo9ko7QZ8FIn/luiutUIFLW99B3/A+GMX3lh9pKgHHpdZqMVM9dH7VYc+QpICF3VaM2kfKDgfFhfHJx0zOna70Is0EcZxeVuEY96cNKYUBHw7dKLU2CuVcLIyxNJU6fQC+kz9hoXURvZqFgHjbBEZ/Ni6N3wzC0q8i28bO7RJ4Tf8Tte+dBPPv9b/XLr/nyBwjGpcWjsb4jJ8QAvOewQx6BvvKu9m/L6XHvJEU1lO9fZWMTnJ98rE9d5tlODKZS7zR2JC+yRetqWbp3cJmaew3SwRF48AU9vZPNJpDCD77WHvjSDhuT16yy0aWbcJCrf4OfG3DCXNmvA0fH5D7oxgGLXkb6tuqtlR+trLHQYNoeUbfuyKLdaxeRaAjoyoCEAydCL
 gJUcfzm/
 UQ26wHZ2oKweeWsNP1+Ji1fSpqPdmqYlf1KCbM5R9ViLwA+WMT3x+nxBFkm/L5RmZZmlv4CedAZ3qqYB/Zi3nnNh0DIapRk56FB8rM2skI4dBjJ9uFrSR3VZv7w+FLyHsOyN8iCSbeFzh6bXTMemHpVZmBepKyUYRw3vOd4MzT+H4Y7sALRQ87aa5BA9C/QlEEt47ocNE9OJzl7FnXPbFz1k65NxViLvuidV41aN3LEEvUr85CC3XhOtPbyscilrcaGdqksc4UL3EPeZxdL/BLbjHoPw+bIM4BEn+1ydEZfDRMGhlbGWBTQcnfUknAhUoriQ+wgVE+zTNklOjKq+cPET36eTYeLkI/Kd5m7G7+eWySGBQqQZKicskkRcC5iaPlN40DjAfW5AR+5Dax5+UzUxvmSQRg3BQASr06MwYpMGjHMy8t3wuaymPySyOAnu4oXhX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move vma_alloc_folio_noprof() from an inline in gfp.h (for !NUMA)
and mempolicy.c (for NUMA) to page_alloc.c.

This prepares for a subsequent patch that will thread user_addr
through the allocator: having vma_alloc_folio_noprof in page_alloc.c
means user_addr can be passed to the internal allocation path
without changing public API signatures or duplicating plumbing
in both gfp.h and mempolicy.c.

The !NUMA path gains the VM_DROPPABLE -> __GFP_NOWARN check
that the NUMA path already had.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 include/linux/gfp.h |  9 ++-------
 mm/mempolicy.c      | 32 --------------------------------
 mm/page_alloc.c     | 43 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+), 39 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 51ef13ed756e..7ccbda35b9ad 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -318,13 +318,13 @@ static inline struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask,
 
 #define  alloc_pages_node(...)			alloc_hooks(alloc_pages_node_noprof(__VA_ARGS__))
 
+struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
+		struct vm_area_struct *vma, unsigned long addr);
 #ifdef CONFIG_NUMA
 struct page *alloc_pages_noprof(gfp_t gfp, unsigned int order);
 struct folio *folio_alloc_noprof(gfp_t gfp, unsigned int order);
 struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
 		struct mempolicy *mpol, pgoff_t ilx, int nid);
-struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order, struct vm_area_struct *vma,
-		unsigned long addr);
 #else
 static inline struct page *alloc_pages_noprof(gfp_t gfp_mask, unsigned int order)
 {
@@ -339,11 +339,6 @@ static inline struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int orde
 {
 	return folio_alloc_noprof(gfp, order);
 }
-static inline struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
-		struct vm_area_struct *vma, unsigned long addr)
-{
-	return folio_alloc_noprof(gfp, order);
-}
 #endif
 
 #define alloc_pages(...)			alloc_hooks(alloc_pages_noprof(__VA_ARGS__))
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index b2c21ed1fd84..39e556e3d263 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2516,38 +2516,6 @@ struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
 	return page_rmappable_folio(page);
 }
 
-/**
- * vma_alloc_folio - Allocate a folio for a VMA.
- * @gfp: GFP flags.
- * @order: Order of the folio.
- * @vma: Pointer to VMA.
- * @addr: Virtual address of the allocation.  Must be inside @vma.
- *
- * Allocate a folio for a specific address in @vma, using the appropriate
- * NUMA policy.  The caller must hold the mmap_lock of the mm_struct of the
- * VMA to prevent it from going away.  Should be used for all allocations
- * for folios that will be mapped into user space, excepting hugetlbfs, and
- * excepting where direct use of folio_alloc_mpol() is more appropriate.
- *
- * Return: The folio on success or NULL if allocation fails.
- */
-struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order, struct vm_area_struct *vma,
-		unsigned long addr)
-{
-	struct mempolicy *pol;
-	pgoff_t ilx;
-	struct folio *folio;
-
-	if (vma->vm_flags & VM_DROPPABLE)
-		gfp |= __GFP_NOWARN;
-
-	pol = get_vma_policy(vma, addr, order, &ilx);
-	folio = folio_alloc_mpol_noprof(gfp, order, pol, ilx, numa_node_id());
-	mpol_cond_put(pol);
-	return folio;
-}
-EXPORT_SYMBOL(vma_alloc_folio_noprof);
-
 struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned order)
 {
 	struct mempolicy *pol = &default_policy;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1192c4e47da4..0c4f4c678233 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5288,6 +5288,49 @@ struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_
 }
 EXPORT_SYMBOL(__folio_alloc_noprof);
 
+#ifdef CONFIG_NUMA
+/**
+ * vma_alloc_folio - Allocate a folio for a VMA.
+ * @gfp: GFP flags.
+ * @order: Order of the folio.
+ * @vma: Pointer to VMA.
+ * @addr: Virtual address of the allocation.  Must be inside @vma.
+ *
+ * Allocate a folio for a specific address in @vma, using the appropriate
+ * NUMA policy.  The caller must hold the mmap_lock of the mm_struct of the
+ * VMA to prevent it from going away.  Should be used for all allocations
+ * for folios that will be mapped into user space, excepting hugetlbfs, and
+ * excepting where direct use of folio_alloc_mpol() is more appropriate.
+ *
+ * Return: The folio on success or NULL if allocation fails.
+ */
+struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
+		struct vm_area_struct *vma, unsigned long addr)
+{
+	struct mempolicy *pol;
+	pgoff_t ilx;
+	struct folio *folio;
+
+	if (vma->vm_flags & VM_DROPPABLE)
+		gfp |= __GFP_NOWARN;
+
+	pol = get_vma_policy(vma, addr, order, &ilx);
+	folio = folio_alloc_mpol_noprof(gfp, order, pol, ilx, numa_node_id());
+	mpol_cond_put(pol);
+	return folio;
+}
+#else
+struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
+		struct vm_area_struct *vma, unsigned long addr)
+{
+	if (vma->vm_flags & VM_DROPPABLE)
+		gfp |= __GFP_NOWARN;
+
+	return folio_alloc_noprof(gfp, order);
+}
+#endif
+EXPORT_SYMBOL(vma_alloc_folio_noprof);
+
 /*
  * Common helper functions. Never use with __GFP_HIGHMEM because the returned
  * address cannot represent highmem pages. Use alloc_pages and then kmap if
-- 
MST


