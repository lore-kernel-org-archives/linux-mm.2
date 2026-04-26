Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3068FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 21:47:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6692E6B0092; Sun, 26 Apr 2026 17:47:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 640496B0096; Sun, 26 Apr 2026 17:47:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 556286B0099; Sun, 26 Apr 2026 17:47:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 439436B0092
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:47:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DF82640634
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:47:42 +0000 (UTC)
X-FDA: 84702044364.09.8879342
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id A4D9E180003
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:47:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WOldrAbn;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777240060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yXr1u1aEvptlqN9vuxArrnVOz3uXJxzDs4ChyPf8Auw=;
	b=5xdceSV5RcwS1rNxup4QaIpuYpxnYnPOUO+1DvtjsCULCVtyCJgTxWjWfMs11Z0eYS5YSO
	FK6v9jXFzLXGQtViw/oVjP1EKkunzquqTsVAaGRmbhVGac/7+emxjZ79d96VIBVGne1YtE
	faWp0q46LsgzqaPC0NFrSV5Y64wjkf8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777240060; a=rsa-sha256;
	cv=none;
	b=B/d5Wumv60FerL0wkstBh9BcJe5lmNfmKBH1/h0hGM/M4Yd2k89UQGax5G7vgXNsQd3Vx5
	aLRV8PdplWQl3oJLLtbhYt/ssIgAvyv8m2J4iWVbN7C74ipyzEEdNWPxf8wvApGgSYmRXo
	DmrE57XM+PiaeQlo1DLiD2nrDx08JTg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WOldrAbn;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777240060;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yXr1u1aEvptlqN9vuxArrnVOz3uXJxzDs4ChyPf8Auw=;
	b=WOldrAbnwLzIL7Ws20I1M9cmLGMN9iF+wq5Gh6q01w22fGL4EKcV7BbilRxeuNJtGi8/CF
	S4YutbWURoklD7LCi4XyMhvvxg0dltvPei3lK1vFRqwT/g1GxccxsW+uEmkJha/sNYcl9n
	Dnod8E3AHCaD1o3JC4YjX7mp8x6LGhg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-259-oC-8RBeYNBOBKgS-e0SAjg-1; Sun, 26 Apr 2026 17:47:38 -0400
X-MC-Unique: oC-8RBeYNBOBKgS-e0SAjg-1
X-Mimecast-MFC-AGG-ID: oC-8RBeYNBOBKgS-e0SAjg_1777240057
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43d780757eeso6032661f8f.1
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:47:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777240057; x=1777844857;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yXr1u1aEvptlqN9vuxArrnVOz3uXJxzDs4ChyPf8Auw=;
        b=I2gdeEei/uTKR1AQ1pqWd0Rix7XBeSMUxvq0kkFm82EfkNTG2jLqABGteUpIWAuydb
         PI1PGg9auxo0htXw1/QqYG+/siFatFXMeipzzAEnz6xM2wCPSzISrZYM0yPXJcgVRDe/
         OjBSMRgw4iSCPdLjQBAO4il1jSfWttYyN5ru+HbdG5wqxRKWlFt1uw8YaM9+/4FErumO
         zvYlEhgo8w7KLc5Kn1mWaiD9U36GDcrPj+d5DkuhLev0C0SuJN9e+T/jvRl0oGGe/w46
         pTroQMHAvtuYx5mjvbAgOuzVCq1oqqOxzn3rvPld5zooBWtLo8NWh/EtK9Gz8imPfnVD
         oKOA==
X-Forwarded-Encrypted: i=1; AFNElJ9tYoQpNOg8I9AXy1w/WxDwzwe9/k5wTMtYgSsAtXk5JF+9auHEEpgUT4PQvh5wKzbATYdvJiBzsw==@kvack.org
X-Gm-Message-State: AOJu0Yw57O4MAhmP5qBjfQGXiJIE0OOPlWqtabrL8yo/Bv7TpuQjDzpU
	Cpk9HrvHjJ8wcp2LBDwsJZFAmI+OsK1XQ1TqFUs0W7GtDIhQ9zJ+kGF5jgIa15RR9+WJtF1DYc5
	9HD2TmAWI1xsuJKNNTxRBVNfr/qBPepuahcg7/wp8cWoKj1OHzx+vQJA2HP0p
X-Gm-Gg: AeBDies9wQhTb89xCFuoNxocnz4PlNa6iGT/lGk5rfcOdbmlzxq8rdZjvYx6R0ZZF0q
	1NwIZRzeZkj24wOzvCfM+hYWZqUvE9ENIPoTltX9VBX5748j9ooCYBGpCBsbL8K4wxr/6xUrXt2
	vgNhVP4Du0GbR7VQVX0gFpGDUP9KapdY9+F1DMmzn2gNUDVwh2JwvUccKjJlafDkNkOY6ctBzx8
	8VipPj56lD/aMOdSZac97v6ELzH1CcwGbEhK1G643gPqAGpUcfZVJtl3IJ4x5Ls4HVmkIRZMWdq
	giKdPC/Vi2eBG2VXqPJv3UKxhjCeW8kHav+vVGR88IzWu3jKo1yeoUPn4BbiUMqta6UMiQHs54M
	5yUZbZcwb+nAYNTpp6yZdCpi+bNQdb+xoupzw593O5VJZ7IPr2CeBsvGj
X-Received: by 2002:a05:6000:4709:b0:441:2397:f40f with SMTP id ffacd0b85a97d-4412397f431mr33246992f8f.4.1777240057116;
        Sun, 26 Apr 2026 14:47:37 -0700 (PDT)
X-Received: by 2002:a05:6000:4709:b0:441:2397:f40f with SMTP id ffacd0b85a97d-4412397f431mr33246952f8f.4.1777240056601;
        Sun, 26 Apr 2026 14:47:36 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-47-179.inter.net.il. [80.230.47.179])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e4daf2sm73823721f8f.33.2026.04.26.14.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 14:47:36 -0700 (PDT)
Date: Sun, 26 Apr 2026 17:47:33 -0400
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
	virtualization@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>
Subject: [PATCH RFC v4 01/22] mm: move vma_alloc_folio to page_alloc.c
Message-ID: <a51fc0bcb09e50dcc467d0d336f324922742a0b0.1777223007.git.mst@redhat.com>
References: <cover.1777223007.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1777223007.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: J6nLahCvFa1DUohh8lf3JCdDOyd4EUobpsu4JebxDi4_1777240057
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A4D9E180003
X-Stat-Signature: fw437ijct5m5epq1ak9uqq9goo5mtmyi
X-Rspam-User: 
X-HE-Tag: 1777240060-512316
X-HE-Meta: U2FsdGVkX19hZH2b6T3Bbnei5jCClnCFbPsjMim+D78CbhkH+iCdkWvDkTJRqK/AvYyOyy19dDAdNXa2oFB4/2IA7uTBkBMztuh3MwEohGRwEhlSDWbJ2Th9f+0ciMpwpsbs5hDGFt2Hi4mJ8G3nynIuRZK5XWUgdmBpgmYBDy1gQ4Wmjun+E5/5gwKxMc2cNZcdbPnKd9sokIK8PIoNpH77p7mr/JOwt2vpW6EZd8Ocgoa1msEuB5kL4mh+0wJsOz5jM/PBzNkcHRjKiil9Zg2/PIct40JvCEwNBncoB6vKPgeKgDs2xMMxYDYhzZiQQl2nrqM3Nt9pMN2XEWd/tE5g61jG6JN8i5vE6DVSI/EY4slrzB60gBVktRYCYTSPOdhB+q9kTgdPRb0hf5aRpnXFjAdOt4hEpOZ1H6qdVTHc8tvdwn3k8aRv8YL1UvwKMXGmy7Wg7iIhrt4Fa3CVVe8QKjtBeKjGrgCz1Aa5EHX+YX4k4/UtOr55UWhO6qTZFerEtbHV9ThZjUIQy+JMuS8nDqVPX/3/FaMKLHAuiipX88End6cyf/C9nx+yJOWXAdl8krsoOyo6nAmRxXVybNTSAOiY9S3krarec6b6KfMiT02nEiiakoyl4hsTe6iVWEM7mAhmgn48Z3T1HeQbnNGRiSam8O3ga7QRc0A/lSaaW/+TEY0bX17aJR2Uf0U8UGyzVD798SQd2MW+aC9WWEd+8vQxuaKrZiuEaF+Hnif4Cdn/tVzc/wSJ4ZMWSswwSiQN91c93H/Jx5hvvjfONMp6L8oK/Q4k8Q1aLXo4fIgy5YkPUaAEiuoZ2BDd0LzC0Ua+S72gfDQixXrVQ77zXHddmLTOTeBFYBrXd/tpGD4Ztfg/n+PjLSLTkJxgByqq63UG+X9mLvd3fOhRO1eTY4dIRwtmpHkQxHiNmtF++xlpeygYC8G8MMROtF8C5JNkL5DEJ44LoFssJZb+aV0
 cR0HtWTW
 sk77iz3Y9DydUvT6pV2TTvR+CLghNO9tE3IR4RxrdnVDhWaX2n9ztF9bpEenFXJrP8a2Y6tHie56Gj9IlAuU+QXMKHdUHP+eoP59aOtXKUP+Dt2hJFoLTfK4dNNy6t1bku5Z/LVSCWn3S8igdzrUUeV3nGtlEvHno35SxyFRQHqM4IXGscVAVCSPIM41MP8qkXk60ECUT3aJMMfF/8kIX48nO3d/6PH/Q4mnfp0kSyvJOTIVaH0pymJjXBFSR9AG7EczDJf+fBFht8StEQhqLTOJK4NzhFYWGIcRCmIATgr9mqlWqCUfiapDDEU/RVptfei0TmdOpofYXf/QgakSabjQbLhwBTYDU3WJ6nGyaad8/jY8qhBjNoVDmgAw8GNv6u8XjdGyKqW1ceJyi+iDP4ovV4uYhPexHTWRAxtzfRNsd9TydefzFytUGA7espGtBmtWC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move vma_alloc_folio_noprof() from an inline in gfp.h (for !NUMA)
and mempolicy.c (for NUMA) to page_alloc.c.  The declaration is
moved outside the #ifdef CONFIG_NUMA block so both configs use
the same real function.

On NUMA, it calls the mempolicy allocation path as before.
On !NUMA, it calls folio_alloc_noprof() directly.

This prepares for a subsequent patch that will thread user_addr
through the allocator: having vma_alloc_folio in page_alloc.c
means user_addr can be passed to the internal allocation path
without changing public API signatures or duplicating plumbing
in both gfp.h and mempolicy.c.

No functional change.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/gfp.h |  9 ++-------
 mm/mempolicy.c      | 17 -----------------
 mm/page_alloc.c     | 28 ++++++++++++++++++++++++++++
 3 files changed, 30 insertions(+), 24 deletions(-)

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
index 0e5175f1c767..f0f85c89da82 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2524,23 +2524,6 @@ struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
  *
  * Return: The folio on success or NULL if allocation fails.
  */
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
index 2d4b6f1a554e..0e6ec7310087 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5297,6 +5297,34 @@ struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_
 }
 EXPORT_SYMBOL(__folio_alloc_noprof);
 
+#ifdef CONFIG_NUMA
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


