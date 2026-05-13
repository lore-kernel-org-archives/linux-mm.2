Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 573F9CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:09:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEA226B00C3; Wed, 13 May 2026 09:09:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC1536B00C5; Wed, 13 May 2026 09:09:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD7476B00C6; Wed, 13 May 2026 09:09:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9BBB16B00C3
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:09:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 505B1C26A4
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:09:49 +0000 (UTC)
X-FDA: 84762428898.04.7CD9B43
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4884CA0017
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:09:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=iOv2u9sD;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3cDXE+87tm7ASxvvK0pHPqOmmyuztiqWVG9E1ozeyTc=;
	b=gcz1ggu+UK74SVUsLUzy1GaepYkvbt7rL4J6K7YpCntcIqP+Cl+hMlIM4vMckdjrTSAgfF
	Gq0F9M6wTNnGhkjK7iDrxnRULjUTrNnSFj19giMjXn3kIewGOxS6y7N8Bufvqw3YRa3BcS
	65blcrOIp0cCBDV8tWvphQW3yOesDoU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677787; a=rsa-sha256;
	cv=none;
	b=SDmPL65wFtyUXgR/d4bmBizsGUJEs/oI62DMwiQruE++pFRpQO0JSTHs7o6/t3fnh4aVzq
	c8fucmd0m9CP9Ci0o+GtPulX+FqqlgoCgalDnHgsBA0PWgXMinv3s0I3jY/3PUyGouX8SO
	A1dF/XpykD4c/uE0AQ/dL+K7i9I64l0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=iOv2u9sD;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-366087480d8so6041518a91.3
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677786; x=1779282586; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3cDXE+87tm7ASxvvK0pHPqOmmyuztiqWVG9E1ozeyTc=;
        b=iOv2u9sDIUpVmg5Id7dPDwWehg54CNSctYn3iMK4DZTe0aN05RWYkCNDrwu2MkSIGd
         sSYZu9a+N8A/T3X3xSTRmDxm5tc64b741GfTR2UuneT9VnyvspxLLQRndqiVxMs0ntCN
         Mg3w8iOwuXf0s30nAu8LHcrIUfU4N0xfSy/PRWx/p1vBWeaxmNN8NvGfRv/l4asuEdM5
         9+vLjIu43Tf7GvdMmfYiaFOe2zIV82G3I/0Xm99PN2WAnRb7Pbt/PEzRoWPa6xekFxNo
         e+TOUnHQhSlwNIqe9DaEs5BgZlqll4O7GQLqCOyQfqT5DOMRKo6e50AlpK3Ed2t/P0NM
         wF3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677786; x=1779282586;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3cDXE+87tm7ASxvvK0pHPqOmmyuztiqWVG9E1ozeyTc=;
        b=dq78b3R/8Yd02MbVz8v7guL1DblUpMfsUvVMzl9CB3aoaOT0EymIpXeUBvDyFqnMdK
         yVhpvJhG4L3GPAbLFMFsryd4yc2LeI/o4de+VXyWH5v4CHdJtAFvNDawhCsSrdUZCSIE
         inzVXEio7c8eJjv9Y9Y6LtPNEmm9tkqknuTUWkiTHdV2RN76vgosLxki4lAVcpgEx3Na
         nWsk7o6UfU1tjVqNrwC3++nMIECj7iGnC+4QoRo0jsM6/K0l4v+eh0WI327wAN3860DN
         Jbi4LoGjdQH5s5VjCpr3uyKDhEzVkb4GXlXcmeLJ8pruk5xpbBjJ1cZHtvr41GetvuS/
         nzsw==
X-Forwarded-Encrypted: i=1; AFNElJ/J58q64FQe0Q8j/ZM+qPBm6BbuSEJo8aBDJpYOvZM1kP5A7m++bM76fGZLRaLF8r1z1UFp7ya9Zw==@kvack.org
X-Gm-Message-State: AOJu0YxKe+qRzchNbASePLLE8x1kHCoJEU8aUCRxn0PldypwneA/QogH
	vVnFl5/qxIdp0f4QkaodOIv6D3lMc2t1VdLR6fJd/qMYd7DPrb7lxJpD7V1xiGuG4uc=
X-Gm-Gg: Acq92OH6Van2LIjmuV1JaNA9IwqOUU+Qkt42ev1W0cKhlasb7v6jssBR3L0FgyhEto3
	idoEvcefbQGillK1d2/t1lRenz371FVLBsIao4iJYTQeDBmyy26eBycQ40wLhwtHBZX7ANBUHrr
	qHP2zbVng/dkTcz0Zy/M113Zlzq+tMuPkt2+qt/kALPWo4KS8Y3ub988dhwLYxLN96DmepckRp+
	Yxk0DZP997l2AZc93R6izM/ina2sXSu1ldMRrWsvb51GWq2u2bO7HEGyxrzI0LNmPx98gMKyS/x
	8bH867yHDSaVAeY3okE9zTqCav5HQjyPOpIXUyqlU8Q5lUEHpIjy4irTatcoqwCMuHyhbvGjCwl
	28UyET14K9tSQ5+yo53+kkIMUOdN7LxlPqUhCbbs6S88oYwTQZLWJzm5jYEqGj8VeJuc7ZBtlK+
	xl1t+3873ExbD/FDGKMEZkBDZ7UfUR5tynCCg+FbVJiok0r0Ozwz43I26BBoU=
X-Received: by 2002:a17:90b:580d:b0:368:9021:3195 with SMTP id 98e67ed59e1d1-368f3ab5cccmr3651001a91.9.1778677785949;
        Wed, 13 May 2026 06:09:45 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.09.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:09:45 -0700 (PDT)
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
Subject: [PATCH v2 24/69] mm/mm_init: Skip initializing shared vmemmap tail pages
Date: Wed, 13 May 2026 21:04:52 +0800
Message-ID: <20260513130542.35604-25-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4884CA0017
X-Rspamd-Server: rspam04
X-Stat-Signature: uo6b193rhwt3nj47gzm9gyu1xchgqctd
X-HE-Tag: 1778677787-938178
X-HE-Meta: U2FsdGVkX1/rLA8WudjIUBStZmuZDCHlko9owvkcdQO1Yz6WMJ+rDwmWMiJcEe69qhBn2ItJvpUCx0I6dDBIMpkVikvn8hapooBoE09Xqqk6LZzvrmnk1L03Qeq8FiDWDqngQD+yqNfDKk4Cj5VzA4wx3At0bGL0IJgr+sbGVqJ51exptdiZ6Q1QxAxJqY/oMQfUAYXoKgLi1WPAjinVFFrugaAbWOiHya4I6zs3QBGj0eDw0sukF2mKyt9HJXSylnR0WJyc5fg9jetK7Yvw1P/CcVVoctxxPRPsByb3tQJFFcMWCXXUnnnM9E5r0bn6DN+iro+zqJ7T/I6OLaYNWTxLnflcChVRO1ujG38Z8mqk+mZHDzTdJeq6KLgNAX3W9zWmboWgcSjWEe0QNlnueDTQO5h9CbThmp10bvGN6lSHOKIB36gIYlJoy4ASvTJ/asJIqopCcNYCFKDvthTgp+2o5FyMv+lWlAbyPCvlzogEQxLH01QKhb0zvN+Pp+R9yqoCsfYoEdbj2chM79QQOTS4u/R1+iifHAaXXKZDcBrDN0o2YV1t70UwNVNQBS28oXY3+xf9Jn1612IR8hZNEtbN/ES1s0bH8AUBUFtijVDAbbV5L4g4K1A8OJvrglojKZoOOS8L8uwBSlGXtui+1mZGfWPr907nNFToPsJmz3m2k1+whkxVYzsb4FcIYVN1ODfZo1Zmrn2/T9W/hNHIIUm0q9JAbNfizoYxN2OjaV5JunsS7tYn0appgYdHQ5Gvo57Oq+GzDAjJBpeFUep2utxAFb+LYk8ODlFcnLYri0ckkK4zlcWPr43+xKU/ghdxF9kGgS9hvyLqJrws9w6WZmeW3b78gjHttmZAxvCy7nrHAvpc2TVCMwXY+uFk4HWLnWEfXn+dEmOWPZs6GCPKdAAvOz9fLGBcopOFvpWJhvoaXTV5vAkkIwNaqAJdl7Pb4Fzefk7upNNYik1/DgP
 bf9untXZ
 WGRokRgj63ofUPbEnQaQTwo8zLao+4AL9wRD09ER+wEwD/coqqu3l8EMnwgtM3QDa+E+A6bMJw5YHXFf+lYAB4jANL+rNZM0mRxaDAhLMsZvMTx+mISB7ErrqTKoVsHG/dVLE6+ydTWihVq2PCP99mZlHgtPbSlA1iHB7k7D55q4tNS4mXNqT0IX8AbiHrC85hmdCCz4VybnLi0P9E444C+SbZ3nh5mSG5hAYnpK4JjrRDuo30FevEEF765iW+KLa4UaicCEn0TvYZ8BkYvfh3CIACdlm56n4CVm2D+HcSn6e9zRxRckZzT4sDFeGF1oFRXRT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memmap_init_range() initializes every struct page in the target range.
For compound pages with vmemmap optimization, the tail struct pages are
backed by a shared vmemmap page.

Initializing those tail struct pages would overwrite the shared
vmemmap page contents, so users such as HugeTLB have to open-code
follow-up handling to restore the metadata afterwards.

Use the section's compound page order to detect struct pages that fall
into the shared tail vmemmap range and skip their initialization in
memmap_init_range().  Still initialize the pageblock migratetypes for
the skipped range so the surrounding setup remains intact.

This is a preparatory change for consolidating handling across users of
vmemmap optimization, and it also avoids redundant initialization of
shared tail vmemmap pages during early boot.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mmzone.h |  9 +++++++++
 mm/internal.h          | 16 ++++++++++++++++
 mm/mm_init.c           | 19 +++++++++++++------
 3 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 6f112e6f42bb..5fc968bac1f7 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2264,6 +2264,11 @@ static inline unsigned int section_order(const struct mem_section *section)
 }
 #endif
 
+static inline unsigned int pfn_to_section_order(unsigned long pfn)
+{
+	return section_order(__pfn_to_section(pfn));
+}
+
 void sparse_init_early_section(int nid, struct page *map, unsigned long pnum,
 			       unsigned long flags);
 
@@ -2404,6 +2409,10 @@ static inline unsigned long next_present_section_nr(unsigned long section_nr)
 #else
 #define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
 #define pfn_in_present_section pfn_valid
+static inline unsigned int pfn_to_section_order(unsigned long pfn)
+{
+	return 0;
+}
 #endif /* CONFIG_SPARSEMEM */
 
 /*
diff --git a/mm/internal.h b/mm/internal.h
index 4a5053368078..1f1c07eb70e2 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1004,10 +1004,26 @@ static inline void sparse_init(void) {}
  */
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 void sparse_init_subsection_map(void);
+
+static inline bool vmemmap_page_optimizable(const struct page *page)
+{
+	unsigned long pfn = page_to_pfn(page);
+	unsigned long nr_pages = 1UL << pfn_to_section_order(pfn);
+
+	if (!is_power_of_2(sizeof(struct page)))
+		return false;
+
+	return (pfn & (nr_pages - 1)) >= OPTIMIZED_FOLIO_VMEMMAP_NR_STRUCT_PAGES;
+}
 #else
 static inline void sparse_init_subsection_map(void)
 {
 }
+
+static inline bool vmemmap_page_optimizable(const struct page *page)
+{
+	return false;
+}
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
diff --git a/mm/mm_init.c b/mm/mm_init.c
index c64e5d63c4ae..3aaee1cf7bf0 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -674,19 +674,17 @@ static inline void fixup_hashdist(void)
 static inline void fixup_hashdist(void) {}
 #endif /* CONFIG_NUMA */
 
-#if defined(CONFIG_ZONE_DEVICE) || defined(CONFIG_DEFERRED_STRUCT_PAGE_INIT)
 static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
-		unsigned long nr_pages, int migratetype, bool atomic)
+		unsigned long nr_pages, int migratetype, bool isolate, bool atomic)
 {
 	const unsigned long end = pfn + nr_pages;
 
 	for (pfn = pageblock_align(pfn); pfn < end; pfn += pageblock_nr_pages) {
-		init_pageblock_migratetype(pfn_to_page(pfn), migratetype, false);
+		init_pageblock_migratetype(pfn_to_page(pfn), migratetype, isolate);
 		if (!atomic && IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
 	}
 }
-#endif
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 /*
@@ -916,6 +914,15 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
 		}
 
 		page = pfn_to_page(pfn);
+		if (vmemmap_page_optimizable(page)) {
+			unsigned long start = pfn;
+
+			pfn = min(ALIGN(start, 1UL << pfn_to_section_order(pfn)), end_pfn);
+			pageblock_migratetype_init_range(start, pfn - start, migratetype,
+							 isolate_pageblock, false);
+			continue;
+		}
+
 		__init_single_page(page, pfn, zone, nid);
 		if (context == MEMINIT_HOTPLUG) {
 #ifdef CONFIG_ZONE_DEVICE
@@ -1142,7 +1149,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 				     compound_nr_pages(pfn, altmap, pgmap));
 	}
 
-	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE, false);
+	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE, false, false);
 
 	pr_debug("%s initialised %lu pages in %ums\n", __func__,
 		nr_pages, jiffies_to_msecs(jiffies - start));
@@ -1982,7 +1989,7 @@ static void __init deferred_free_pages(unsigned long pfn,
 	if (!nr_pages)
 		return;
 
-	pageblock_migratetype_init_range(pfn, nr_pages, mt, true);
+	pageblock_migratetype_init_range(pfn, nr_pages, mt, false, true);
 
 	page = pfn_to_page(pfn);
 
-- 
2.54.0


