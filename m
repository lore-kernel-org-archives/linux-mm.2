Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14D88CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:53:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 633F56B0088; Mon, 11 May 2026 04:53:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E5866B008A; Mon, 11 May 2026 04:53:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D3DF6B008C; Mon, 11 May 2026 04:53:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D5FB6B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:53:00 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C6D62C22AF
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:52:59 +0000 (UTC)
X-FDA: 84754524078.15.5DF86AB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id A6AEC40009
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:52:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fHAPbnwC;
	spf=pass (imf01.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778489577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hsz4Yb9WaP0J2d/ovLyM+GlU9a8IJXiQXaVWXPUNWME=;
	b=am5KqG7Pwl/xEQehP+ww9kY789YLv9Lqmo0cxEYT2c9P6zZFI1jpOrPRFupfSS0I2cSTdO
	FBmBTLjvCK0iRDXZmx7++HFpbqCtZ93e+QYHPMvd8GrPQomi1BGRaGULQzBAAa+N1GPUYT
	yoL5MHUE+CnqRsH9H7sy4L5iPh9UH1Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fHAPbnwC;
	spf=pass (imf01.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778489577; a=rsa-sha256;
	cv=none;
	b=iHrH1ToNXPFp619VxyN6YE9G/s1TpKL/p2d90gzwgS65NtKn/6ISEQm3QmQivgsqKykK0g
	OX72MH7m113zvzftZW7LrsLLZit8GwSGwIyN2IOFLW2WrqGXBMk5x6nkOuYAsQXZsYeKTe
	h4qqK3Nl61CUs5UfyGnO4Dx3CkCIbLM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778489576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hsz4Yb9WaP0J2d/ovLyM+GlU9a8IJXiQXaVWXPUNWME=;
	b=fHAPbnwCMPRTKsGdf+XYZeBIytAjY1s8MUvposM1W57+9ZEewXB+myE0tzSEhbz1ZQ7jp6
	JEhp2Bkj64MR0q8/Zyk/O9jaMs/NspXzMY2A0Rl4BuCGJ+tKxOFCaoqZHgpCP7SlMLy99O
	a0w31472dHRILNzAwufkfFFtSjT8tGI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-Y6RBavTBM4-Nwu3iw4eiQw-1; Mon, 11 May 2026 04:52:54 -0400
X-MC-Unique: Y6RBavTBM4-Nwu3iw4eiQw-1
X-Mimecast-MFC-AGG-ID: Y6RBavTBM4-Nwu3iw4eiQw_1778489573
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4411a69f565so3586413f8f.2
        for <linux-mm@kvack.org>; Mon, 11 May 2026 01:52:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778489573; x=1779094373;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hsz4Yb9WaP0J2d/ovLyM+GlU9a8IJXiQXaVWXPUNWME=;
        b=KgVqp5IJHiLfEo59BQNb1AyHMRhiYY7SXTa1HkZ00nCsmuHmdVR6S+wIGG/4af57GH
         VuwumHtGXVC16hi3dGb/otr7ZcJhEJPCSxurSrYs6Pqiq1RCNlMCxvmfbzTync+ix7rD
         St2ELvnKT7dD5uqPfpYewf//ZXF+VXDsmQTXkVtOzgiAIY+F5LPvjFF1XujGfZI7HNQ+
         gFUsNOxQbGzp07H5hHVo1K66BWr27QA5J4/bOsNhJo1uhr7w4EbovQg23rrbY5zSIFfr
         bEk5FNREmYsxSu8+0QH4o9AxXgyeFp/nTiirK0r4pxUtEEg3LpsgfmwgXU3Fm4kd2KFT
         e/jA==
X-Forwarded-Encrypted: i=1; AFNElJ+CdSEoxuiKHONDhqUoJ3cUYZ0bEP5GrlGNQLrxPFQuVqAEPPBMwNNGlYTFHrIHr0fHZsjos6mlqQ==@kvack.org
X-Gm-Message-State: AOJu0Yy3GOIkdPbtzM1I4/KG4J1sqqffchBJjxhH6OK6uptu00viwmxW
	+tZT/M+UgtaABNDxv4rMkNhxXAlkxpNuwQCf37lCWNcWMZ8oj5gY47lV1AfxFv3q8D3JYI8tdID
	jn//OJaBp1upoaajP+Cpcsk4vjxQpeGHCz6Ln42ynSmo6GcFURhjz
X-Gm-Gg: Acq92OGUoe9WuT6g8I0wBkpgJczgFkLg3ZZydDqg4BU3rn+1YZCNgYXblP95WpcVUoj
	cJ/u05rCXf2STWzPZbkR83TqZ4UJI1uwAgdmIqQwUvVNcZ0KURmWBAes8jhCLA3vuow3ntaWB4U
	TeledyrRZwg1lz/Ybf8g5o3r1FkSfrQjzM7lEbVtrsVA1dV8GS8IQ5GZ/JXxpCh7Kab7G3Ege2z
	1VLX2eA1s07ccW24sW5GOyvaAb3vylsx1Wcz4y673vi5w3ZhysneQNcwcpuXsKkJ4h4dCRxv3QM
	Yad+/Uo0/8CBYaiAboCO6Zlqa7NohSv9aTR9MU5NByMdGoPmNulkK3nY/eILnqHay9ZeaQdAQ46
	9IPtvGNEZpDYQpfloRYwou1Vse/2JVhLXaCd+LERXYLubdO5OXcY=
X-Received: by 2002:a05:600c:1da8:b0:48e:635a:18d7 with SMTP id 5b1f17b1804b1-48e635a1ba0mr253136905e9.0.1778489573156;
        Mon, 11 May 2026 01:52:53 -0700 (PDT)
X-Received: by 2002:a05:600c:1da8:b0:48e:635a:18d7 with SMTP id 5b1f17b1804b1-48e635a1ba0mr253136485e9.0.1778489572590;
        Mon, 11 May 2026 01:52:52 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e6daf496bsm82372475e9.4.2026.05.11.01.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 01:52:52 -0700 (PDT)
Date: Mon, 11 May 2026 04:52:47 -0400
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
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>
Subject: [PATCH v6 01/30] mm: move vma_alloc_folio_noprof to page_alloc.c
Message-ID: <a26c5850219e349f8a666282aa8003a82a4819b8.1778488966.git.mst@redhat.com>
References: <cover.1778488966.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778488966.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: npU24KPCPBdTWRiUxtlTr5CU1VXKd9uzujIOEPhDdZQ_1778489573
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A6AEC40009
X-Rspam-User: 
X-Stat-Signature: qwxw83xufo4fj4ees4b19hqtipktzqxf
X-HE-Tag: 1778489576-563451
X-HE-Meta: U2FsdGVkX1/tNSrVEREGEWB4Gf5MTh6dhMxGpn2i00XMeZLy2JqTICNpM05PerZMljdPqkaAlpxcCCMgX6Ww37hn1FtgLSxpYJQVMhfCSsvDYFcdDuGqqLigr28M/QdLx4BTRvnbUjHmM1wDSK4/2eAtpxLmPh9qCcQdEhogVA+gxml3xHje0ZE7FY2ROx/ukfxJO9ckmbLe140J+zQdTixw7xLgnryp2kDPd7Mj2qXxFPUGjfT5uBDilSs1JTKL8muXgmP0ruDVyDr4NYrkf687a4SCodQd+ktgYiszfEPEg14k+JtqGroRQ5q6cjZzgeUdQi3l+mAMDOBRbkLLGDFXq5+PFBbTp14T+liEwrnDXoMyI3YwlmbjNIHCf4oHbuqnfPP4U83RmYhAKcqy9ViDaE7P/CgxgS/uN2qDk+t/B1/0dShaBCCmFk2oYg75Vrb3nTEWaRFSfqk7EwnYJIEEzoZK7JYNGM4MfFbWrHnJSP4MpCemUVhHkUBWtBrtp9ZLJr/4OjIgL7NFs9FFSwE0b5r7RLeGoNPW5FMBAx4pccQ1CZ8ofM5mWAU/JJvo42yNiSTdkABs/BpCBUm89O7KdtgfzH9y6vzRhGGGK/OoQIR4h93v5F0t6pCUKOQx76fKWO6YU65dJsKoiPLv1PGzHLAbPryLMyEOznE3spe7ERSTe42JcKujbpNU6itnxfiDpBIbR9g6d8Tr7wVxQFp1e3RXL6mWnensaGsXuP5QpA1w/FEMiE0/yyeuMHvaitetl8VSSkSmK3U7y4mS2F8S2vU/HP5lco6CTTo5YYrein82Mh/2m3p1tqIXUh5fbjeN9AYE1iPnZ7Ut4wslfHKjymCU9fw2He9Ij1bibI7LILisrZNFzEADkKDCAtzU3ZICp4MbIhaZBDfGAuRxSfdvplb40MjG8i7VXWApKyged5ZoE7v3kpFfejcEbZJyjkQs4cg+KgeVPkIOUrF
 WjR51Sj2
 16s41JVmJrISI/SSx1nukEzymOUwq181/qqA7C0/B+7FJ59M/5TXiG2DtptRAii2KC7THGRSRTTKVng0ML+GVmvdLWYqWIyok0ZXBQRbhMffZtWGK4rdkw9av9SkrbF+OsTfqaf3PavewjuVTqonrnug9tx4+F6n8hddLikIoOEFjRowjJehlJnrP0nSLiiBdpsQghIAIfbGk9bEWdcSMBZCKDERZJAT8RJJE0rIuCpytYyL2fkbryTVBtNAMz+pw5sKvikTCI4ZYwKmUuafmCErA0gIdYclL/B+cKQOspyzaFZp0QbmcfqI87ySLdGJYjU9ULOJJ4PAbhTucI2SGU8xWem0+VbMlttfK865UCTAXefDdFgHyzDhmbxojv5T5L7yBux29P4DlBii+46HHWpeo9bBP7RWOcypYBn2hf+hRALRMQpWfYprCDE94fwYQxIpV
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
index 4e4421b22b59..6832cc68120f 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2515,38 +2515,6 @@ struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
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
index 227d58dc3de6..fc7327ebdf6c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5273,6 +5273,49 @@ struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_
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


