Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E82F5CD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:22:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A8636B0096; Fri, 29 May 2026 11:22:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5805E6B00B1; Fri, 29 May 2026 11:22:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46FCE6B00C3; Fri, 29 May 2026 11:22:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 378E46B00B1
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:22:43 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9F78A1401E9
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:22:42 +0000 (UTC)
X-FDA: 84820824564.21.0629646
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 50B16A0017
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:22:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Jws0aobV;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1d6/7ocvnM9x5v92z8cdenZMlPT5Fb+FBGOKjHhSxWM=;
	b=D39e4IWGEj4V+jh3HkTszT5Z3joTlk2m0VXEamFCit8SuMnxNT9/rrzYn8yVpodknExgFr
	1tyDeRjI8Ykq6nLJFzj/Y8WCIiX/On3cGd811OzJqhsEpKrAOGnduhhywnPHCl9DkjCLEd
	Lk0n1/iqbl7IYjoD5R+TxQo0FvENJZM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Jws0aobV;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068160; a=rsa-sha256;
	cv=none;
	b=sN9Pf6mO62AOQuJ7Ql6jK387uS8wt7pX3S59D1e4zbwQswlyMhevkxT0efua9YBASq1OcY
	wtCNs/vXW9Usy6hmRE9Bi8FsUxnZGU1GGqKcMraOBl+DBGZcKmX3s6LWLiFoqjZJqk1c0Z
	0D24rwwwqlFtTNwfxXPOCn9fadNLT2Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1d6/7ocvnM9x5v92z8cdenZMlPT5Fb+FBGOKjHhSxWM=;
	b=Jws0aobVl5Gr18HaaCv6iSHyG5zv/AZqwaURnPCyOBzzpXGGBPM8zfu5WLkwCzlZNbgMhj
	bCaRFfV2euO2mqTeiPZNZgf0eJl3G/KkwA0K6oQAd3BunDlPyJt5Fj4VpMebgL1qOSIK9L
	jcOkT19VK1R5uwE8b7Gab12Xs3FprA4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-z3v-f_FMNkWfI5y5ZoVLPQ-1; Fri, 29 May 2026 11:22:38 -0400
X-MC-Unique: z3v-f_FMNkWfI5y5ZoVLPQ-1
X-Mimecast-MFC-AGG-ID: z3v-f_FMNkWfI5y5ZoVLPQ_1780068157
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-45ef66cc579so93437f8f.3
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:22:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068157; x=1780672957;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1d6/7ocvnM9x5v92z8cdenZMlPT5Fb+FBGOKjHhSxWM=;
        b=kQgxXVK5T76Yp6bng0z8b25vdVb/oSuDkp8oV9Dk9i6T3sZM8Ni6Y+zimA0Bu27wJ1
         DOuIyb0O+j4AyJyEIqfF4HRtU9e8jeedgXXuzIp5JIpwOkBqcT98Vo1/0uPx+xbXCjqK
         +tnQdtwW+zQg7h3I8uPSKwRw6upahBu5IkEFd3zzvENkxNDR56RJmPXC4dyXEZRJOXfG
         E4V1UAmTaexRCqgLASM7L5A6bqoVz6lI1bsKkY09YytYtuUO8JS7K4bn4t1115SA2hZO
         eLyOfuX5wT/GPWTnjc7yyUyGtKZw/0ue0sndl9rc3Elc5zUPfAmIBXnxqxcMzr9CqbOy
         51XQ==
X-Forwarded-Encrypted: i=1; AFNElJ80ultznTMMA9SC7iboaNzGjGHAeQvz7YIx2+/yt+qRbG+Z2DzyEZoIVNQAWzZgE0oWMrGlKaIXiQ==@kvack.org
X-Gm-Message-State: AOJu0YzosZLgX+pzjXko57D2cdodm3jM4LwbY9UZCci7AWpv9EfJuWXG
	+2fsHy6Ogtw/5qtBwd7A1Y3tuxfV8tTYBKO15/giARuxhWDgpOzwUjLnHNTVynqEkAdvk6PCzEo
	g1ttvfkS7u1K5dwhQZICvlxjjTJL6wjSv/otCeD7JOYxYcvd1F4qf
X-Gm-Gg: Acq92OEbl2JLJUh2IGK0VHB4/7y8d3ifsWj4mppAMyfYjIL1RPxyQlYsU4fGPsz5HXm
	CCDWIMXwpd0hbUL0iPSYhO39D/VLqStshwDEP0UBxy0+0WT6jozXNNpqZCauNvC0Evi6+nJUsHu
	Q69jBKI1lHgjo7+nWcrurFWGQW9oYY3qqnB5PLF4CddpO/m8ZA2UOEAzNo+KHizMQxGa9H76O9h
	Eenp8/cxa+7R7WyBP85CfB0e/d3qn0bcBFrtrYHWOZVV0oqvETF0zYjygNu/3J/FWL4He1Bwir8
	C5uWPcFzyak4bR2XfoHcsODRdAnCMRd+tTsWjb8FwWRbNvejOZOIo0l6clK1GIoWdrAgC3I9wIX
	+ET2/FthI4EGi4VimcdWotw0z/hRD2hjmQZRN7ZIcW6/Rl14Z4CBtCg==
X-Received: by 2002:a05:600d:8444:20b0:490:44eb:c1d9 with SMTP id 5b1f17b1804b1-490a2947c86mr1027375e9.28.1780068157061;
        Fri, 29 May 2026 08:22:37 -0700 (PDT)
X-Received: by 2002:a05:600d:8444:20b0:490:44eb:c1d9 with SMTP id 5b1f17b1804b1-490a2947c86mr1026475e9.28.1780068156493;
        Fri, 29 May 2026 08:22:36 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909c0e8c1bsm22645615e9.3.2026.05.29.08.22.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:22:35 -0700 (PDT)
Date: Fri, 29 May 2026 11:22:31 -0400
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
Subject: [PATCH v9 06/37] mm: move vma_alloc_folio_noprof to page_alloc.c
Message-ID: <926990355eadc624f8ef12b30b50f8aaf67118f0.1780067977.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kpaVwgif3vxf_BAuP3zGszVnrHf_UYNVbK9PFh50-7U_1780068157
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Stat-Signature: ijuwyfwh6cz418i1jwmuyqwdtz6a6om6
X-Rspam-User: 
X-Rspamd-Queue-Id: 50B16A0017
X-HE-Tag: 1780068160-693159
X-HE-Meta: U2FsdGVkX186VCh5p3cBk274s2XEn39DZya1c4vEchBea8PJpg+G3SY3zFgkBSZuqAJSYyCEX6UyHw7e1D6JFAPYer5ijg4qGYlgaBVXIC0H2DTy1T+5bUiLmQkS7jCDOS1+LFKWGzUz+ZXrtn79o68AakOLaFrZVebZwUqyO5akwhcpHFzGkxxVBQikoTr3T8xICqTdZPJgV48lCrShUecwJNiKQN8UeZAUKf1b8IEAfPJsttffv1pN5CBNAqw3GnB9RvvrCm7XmwfmfPUg8fZ/XoXmY33Da0sxgJRcr6JmQXnhLaz2DVMZGSOkH06g1+yguX9762PQgXDBohu8RmlHR/4RvUAJQ7tYU0fVkLdXn4GC1MGHCHxxh3lYf66QBKqIm68JcFFsUa/FTHUKd8ADj5q5hhMpAKFMWoMBnjqbZLx5U05KYeF9uznBB9KEjJ8ixj4Oi0C+1hHEZ18swgC53+tlTXbw+TVDpSseG3itmxPqNG7Z0Li/kDywnX7eNFBeP//ZM+yBVkLvHQ1o5o8pBiPsdqgvtivLmuZjfEDCG99hb5hNiyaNUeCGg7teLS/j/sTZhZXgSP1x9Q2YTlVslwffWA4vtUokQQbZoaQbDFOl98zSQDm5KHzECDeKgR2waIW27Z8RnXQT0lIvb3x9xPNunb/1HmNfIH4ZUru5domSTB8QvmYLyrg/uWDrXLIRXY3B3+IaG+w2OYKO+lCo56FqVcryuJtoscGDa4C01xAV8qLLXo7t85mbeLwGtQlBTXFbZ8hy4Bogtqh+KGHAdYn3rRWynZhHZnxObQLQDvT8UuTxmljoUSiIq0Sfeeja9jrwFn6wXsl5RpvFgQY9jmo3407ACj0F5L04aK2MrXYKFcWQqNVUy5Q4Nqokmcfttq/5DWXG/mdCta21QYXiqh1MSrY2CtY0QbJMVzGtOoEZ1ospOhT3rmlyLryJ8SNCazWMqb5AQRRpgLH
 P/T9IwVc
 AR+Uf9CBOq4C0jwOfoOVZn84Cd/uwRX7xZuZy/aERb0YPBHZn/oxxeti5Us5Aoi/f3bcY/VWvhvcMLZ4mRy+pkk0QLI3NOTvxdItzYAgTfkznQnNFJLpDqJ+pgAmibhzvcoPnUDKjpB5FpRBzOpw822C9GuBTFqd/UkE8bCFPKT4DayX0t7hpSGye5Mu5cJ0ABvtjf6kVJ3/7x9NKsUuGfqaKVNL006A/hpVlhF7XH4YMEe9WY6P1zy1sSxMLDtwKqW08NmzH0MhtOuBWcHi2tcjg4wx7NEVVBi+G2Iqy6/eYiR1k15cYWm+E9dHTQbb+BgQCkZXRAZCllI/gJASnbfmui3+6Urg/k+cSD45bW2GAgpZQbTqNY608dJhHQ1cQHnjPHOvjBUW6bJ4LsgjQ5hEDi4pjykebl4wGSPzGr1bQZJig6HzlxksnpID+2O1BJP3EH9yGofy0ljdgjwMbEKcgd1DWYdfUaoPjYJFMwYeVRDI9dAuBWyLCZQ1W7c2kX6+6b7wHvWcvDvc16ADpxKfF2KPPtfcsX+LnRruEb5cbUnjEI+aFEBDuhg==
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
index d139b074a599..a1707ad498a8 100644
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


