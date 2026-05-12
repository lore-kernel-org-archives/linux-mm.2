Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41654CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:05:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 201AF6B009B; Tue, 12 May 2026 17:05:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B2CD6B009D; Tue, 12 May 2026 17:05:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07B206B009E; Tue, 12 May 2026 17:05:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DD9936B009B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:05:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A1A8A1C0499
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:05:42 +0000 (UTC)
X-FDA: 84759999324.15.390BF65
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 610C8C0009
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:05:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iutyET05;
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778619940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uXm+f+MkYB5oL4CzdS91ST7c4wCcchxSd9UlyIAHNL0=;
	b=gg55QQ/dDP0ImtJL4kT+usu04VE5N6aISj1gr5LJ5aW+tzxKCwbKlWpHPgthDZgTCJABRZ
	LZ1p72MXnLiyt5CSb16ri/caZeGccQNeBO4Fxw9YsA7Sm4RrtvODfz45zdwCuLC9osKzFc
	L6P/7vRxRHT8nnMjQ0K8oNEwssohxNY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iutyET05;
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778619940; a=rsa-sha256;
	cv=none;
	b=Wpu/aWyVigDIWIeU+jtLQ4PqW23bdtyT7naJLHVoV/0UJ8iuCvOZzIPMictGwg5ggVA95w
	1cp1NX9Nfm0THXmw8eug3PuDBD/lkbHhVDE33Wta6CToUID/qjJZXUYW1l1jdOg7fP1m5j
	JxWLyGUhmQx8aJRb0vPIJK/7H1iVgJ4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778619939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uXm+f+MkYB5oL4CzdS91ST7c4wCcchxSd9UlyIAHNL0=;
	b=iutyET05D3a2zgKfoNyzSsBbR+GKdiCBvOci2CkQtfEK8P83PMoANgtaKJfUtqLxvUV19a
	1sE58vpbv2WrSeKWW9J0nmUdcWqxzhPKaMSi57TPeGYuAo51JCQjPPT3FMjOsTUGGLjlht
	jkppYS21ycZhVuRNyNum0czBwOIIq7I=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-184-5BY_o0YuNbyGmnbu0CoIQw-1; Tue, 12 May 2026 17:05:38 -0400
X-MC-Unique: 5BY_o0YuNbyGmnbu0CoIQw-1
X-Mimecast-MFC-AGG-ID: 5BY_o0YuNbyGmnbu0CoIQw_1778619937
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4411a1f9601so4549178f8f.0
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:05:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778619937; x=1779224737;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uXm+f+MkYB5oL4CzdS91ST7c4wCcchxSd9UlyIAHNL0=;
        b=B5amS45YVU5AEIbX5NFomadLtolTr3Jvjp9QTP5xo1Udqt/Kvby7cU9AgZUwFTvDkc
         5SKSFAVbymJOfU/rh836kUFrk5t6jeT/dyy8OEC3O1aCiTgEtBFRg58n7rzqBHAl4oWv
         7E26J5cc5JcU7dnGtSsVh3hs1Ga6z67CYT+svuTANAlLvEAVjmbQa97wg+v9PEc5qm/Y
         Fy5FoP8+T0uOapHHwyXa1xz/t3uk7Cf42x+9bHwb02yGJIKjcSPdr+yxzYOsBiFWNchS
         JnK1HOXs5mKDSGkFrFDQelcGwRKMrQEOGAGYW4gvApvtsxE5ST2hiuqTDrtWkDQWk7aP
         5IdQ==
X-Forwarded-Encrypted: i=1; AFNElJ8LY1zT/G36pbYp/mNxXYKQf52lMrxSZoo809aj+vo04Mvb04MzRME/JbCeGCRDwtnPwAV8gfBGJg==@kvack.org
X-Gm-Message-State: AOJu0Yz6tFFatWhYMsi4aeg2JUEg4S/PCZAinbjGHqNdh3JxUGTKojVo
	3BM1L+NNJDfdX0mygzV7niFcCLw8dnUdw7+Gjlb79x19kQzGNt3md6TvkHtfIKZgRtTv+jt4nxL
	wSr6vH5XXv+gnoDqpsqdqA4NPFToY47oSJvgN97AdWpm6nhk5Oe5M
X-Gm-Gg: Acq92OGTTaNV6eSFmig0oFDS9U6gRFcNYeKDEPXvZDttC68AYqgpCdDmOoOYJKhJe4h
	GzXJTE4RiRc+lCqF0S2fA93MpTmck3ru5NIZQtq3iYYGrkq/SZUoGr1copiECvAp0uiOcSreAIQ
	uaXnZon6FN4aRBF4xORkP9SasPjfKj9MGDpZFesnTdkh3+h1UOw6ww18CZ2SRmBIoDyeZlluM9h
	nWYzgqkcYHDmYNJaV1wtGWWGfmq35oY0KjkNlzroWPybfD/Wt0a7yidbVZgHvnPsQWveKsfwUd6
	T6N1MwNHYjABmA1XjRu2S7VZANS/zWS8ir08u6BCpFxO31UU/d+XiItwc+jrtQlV36MpS4wgS91
	c10UJS/u4l9/4MwaWe5+xBQHZ+FFtc6GVEADAT9vb
X-Received: by 2002:a05:6000:26cf:b0:45a:ff7d:9800 with SMTP id ffacd0b85a97d-45c584a868bmr548663f8f.15.1778619937203;
        Tue, 12 May 2026 14:05:37 -0700 (PDT)
X-Received: by 2002:a05:6000:26cf:b0:45a:ff7d:9800 with SMTP id ffacd0b85a97d-45c584a868bmr548593f8f.15.1778619936563;
        Tue, 12 May 2026 14:05:36 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4548ec6aea4sm40612389f8f.10.2026.05.12.14.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:05:36 -0700 (PDT)
Date: Tue, 12 May 2026 17:05:31 -0400
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
Subject: [PATCH v7 05/31] mm: move vma_alloc_folio_noprof to page_alloc.c
Message-ID: <17711d281fa0cb9751da2c856e693e9da6d1efa9.1778616612.git.mst@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Acskjfi9qDjn9PthuQT36XT6-nwD8yYiNTkzRCRLlpo_1778619937
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 197twd8budtps3oepcf1mdxhkmpepmnt
X-Rspamd-Queue-Id: 610C8C0009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778619940-429976
X-HE-Meta: U2FsdGVkX1+/cgUbb3SbS1ijcfrZ3aU+yrLZSmHWDXPD0QNJWfYmEgT67mxjtD/CLfUgIe5V/PA7Yz7oNnXncuS7jLI+Vqnkc5tsnhAUsmVOcPSZc8kzl/UJrey0SdFhdSrhcd8a3PuR2ICCc6nFhkMmmlvrLrY5lt2k3NAjZUfuOVePL01mC0y3DnFESSbsGAq4aRujpL14EBgCU86rufvQ95at+E5ZjUMx7rfotje6Pe38hruaD4Pe927+wxKTYD8tNupOFaFMF/n9qPa658nESykhy1NQ8PLTnryE9uaIOyTi7BQJmAYDSC9c8jOgXTNkkVq5u+odQNPx6iZ49acqiuN0T+7JIvSvbL0mGDLWrh3gkuQknXM03wl9xURBWr66PzkWN2OJYAo9QoI+lVfpqF+U50UwUj3LvNz0LO0THIIqXKHwyowxk08eAC0Yn0VGBqgWUHNuZYf1Hci0OzTsMiV0HUXh1nBejW76Xusl9a7qo4c1601WTAY48+TVDGg6x6ViYxZHUX/kYLrGfx/zu1XuavZWwGv5pLv5EP8EkW53ZHpOMihSoAN4jRonOxQ6i27hHN6bhUkpAOrvJW1WuQ9KoM7lGeUTj3YuBbDeOfuuRklONALhPZWh71Rb9/KqBbvSUPHmIKrsbhd2ZihKLsgmfSXUCdDXt3jqmbMLlzKdUSy3NwPzCfLbBlhTPuUdck9tIjsJsizhzbVGfmeHw03/iOBE/nHsaoyyI1XilFns5sSYlRjN3uj+PAzzYk2DcaRB0hifX+I3foqeeFOdB0RpdukTyA2o8Rhj1UO3HyuyvA9ZaPFgr/8rALgdpp/d8DT0uc1K3gV9ZQ4npO/4ugbTCq+aUqp/p8h8I+ig9exqRW+vTt0CCEy6dLYvTgvEtYIidZ0v1AQ98IZrLb21OIZxyOFBbSbirF4zuFf6K8j30Qatq1B6kKmk0yOGsd0Ihkyhupbym1VhcWV
 YH9Y9/9a
 waCfjE2RFZ++ru9wZvkfBquVIowCeK1s/RaIqsaRpJF7it7dG3hQQ2R7EMUbGLrE4kqo+EcrdHbY6m6K7pNcbFpH+ru58+wNGP74MaqGYF5CWsY8Ehirn/VmeUsRBBZcPgp74vHCfBbPGKtvn9KM3ADE5xK5R/CaerTZR1aAKzZXad11HeaPYCUoaFttntzjPh0xLl5x1tWQ0ZD91S0fKf/aiReylRcz3lYqQXbWOT8fGFHU1zifsW6rVnnhPQn2/72imTM9VimaFQI1Zh0chiVf9Fg6AW//rh4Et42S0dy6WeicS6SSXmbJ485AjoSkg9yranOFszIy2z4HuKPibaOYMVoqFxU4wmSMQdINdK1kHwv2T5a+LJsVjpuja/Q5fiY3KBqh2O2o+cglDLFxK6p6AF42pj3Z11dDLFvhYVG6tWKkZPAuGJ0v+L2T+BtHboymU
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
index e40fd39acbd0..4c5610b45de5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5285,6 +5285,49 @@ struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_
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


