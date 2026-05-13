Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DB70CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:09:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B74596B00BB; Wed, 13 May 2026 09:09:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4C1C6B00BD; Wed, 13 May 2026 09:09:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A624B6B00BE; Wed, 13 May 2026 09:09:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 949FA6B00BB
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:09:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4FB72120760
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:09:27 +0000 (UTC)
X-FDA: 84762427974.13.00E3C22
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id 03B114000E
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:09:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=SD+bxdCy;
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jxlTDmfL7zgwYuPQPoNgGF9X7KRsj/YO5X5OnwZ25t4=;
	b=SYQmerx5QV9HOWDK2wKEeSHf3JGT0dkjqNc7kxrR8P3e8BEyYOm5yJ1Sir7G85vC2xFjag
	0LX6+dazZys2jptMX+bTsubeTNTwAuXT34N+ThRf2oQ+6Gr1E0ujzYdl0tfcvyCqZ9suyt
	dA+LHzzFj+F6FVBB26ZLCb2X+1kBRY4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677765; a=rsa-sha256;
	cv=none;
	b=OjKvtPX6cj8/BI87n+BXWmKQCA2nsLwTn/sEsD/YvM7ghrsRvAyq6ENqtjD2VPVPTjeN4k
	/K/WdidBxdi9tcqIhORYrErQNLzrkpQHQImd0o1fXGg0kWVta6PWe0FvpyV1gIdNW9EaO6
	LMW14pJz2+Y9K5B0r+WzXPftulW8HrU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=SD+bxdCy;
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ba17c8cfacso68312285ad.2
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677764; x=1779282564; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jxlTDmfL7zgwYuPQPoNgGF9X7KRsj/YO5X5OnwZ25t4=;
        b=SD+bxdCyyZbAuUTfifIa1cNJ1xSuNdakndxSbtxj6fIECyoldxPWr9PhsfrWo3Ic1x
         GZ8sqqLInhaeTS8ejTH/pG/ec0sGlxTTLVrh+tE54vrztXl/0+TQJbk+UN1djJunukLi
         UohGkXfcqX2giF3Z4jjZSd4a5M0G3tlxxN5bzWJACaT/hB+ngiokCvKkUy+1zBr1/P9m
         SZLTxDjIGHi/1rgu9m8JoHSNnNAo/kRBA8u+zxKPe7IhPwLiauqYPeQbYZYQtMCxkex3
         uYPBEzIjnCAebOHWPO8AzQazCNA3D+nJm1t2pQA9WsM623nGPG7mUmAxjpZrzRG6cPYo
         Xh4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677764; x=1779282564;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jxlTDmfL7zgwYuPQPoNgGF9X7KRsj/YO5X5OnwZ25t4=;
        b=M6xzskzVKog5bbvmq0LaLe6H50ZULo5X9ZtO0bE9tnH1KlKr7Ypd7s6dgUUYZp0ql9
         nqlNi8Qrz7dWEWxLKcDnA7gP2xK033+pwOwm70WzVnY1KBI2eQyLuIIZsucRXfwrDZ9U
         xH9UxubFIBemhxmRi9OHKzIh236RHvrDPobZ63DWZE5SNpPWEEoIqte53IJSHla3QPlQ
         XyffQaa7/ZMag3fp+nlD88wXTEfIWfGM6jO3jcnXHqMsFOchTsosfQ5rKLOZq+yG/iWY
         A8CwpF0x71Mn4SEBGghEHHNxfcXmURyOUnDBFgbSOKkX98gX1u7EC0rhWjwVSRU0W9eG
         7JHg==
X-Forwarded-Encrypted: i=1; AFNElJ+vjbSYzrGghsgd04mzzLwisGwoP6au5tqrjsTzWmwMErC6aTXZUsd70RlEIFkgDw945hTT81uDIA==@kvack.org
X-Gm-Message-State: AOJu0YzxKuE7eBXvhMgfHI9WPJveXBpdRHRQocfbd9IkoTi9mDe6mw25
	MTNCxnYTN2E/zOKafz5IB097W1WKzyf3atwz/xTFD/dsQEW34lXHK4NIXzLOnE8sTQ0=
X-Gm-Gg: Acq92OHolEII7BpAI9h/+LgibvZEO7HV78HMHcjaEvwvB+MNTZgWV2KjVE7/KnoeFF3
	4PLxAMn+LVf7s253uajkgIy5gRtV7Bds7JwvI10ZowMUCckjCgjN9mHyqajMBv4xoSmAITwCGtX
	+5K+pigdxSkuuDP+EzcYESKt5okj30AtXVdrno1uZzhnf+DpOEnr4wDZ+ahivZBgdKznQVxO0i4
	nWZUeHfy7XPgeoiUrvCNhxfgHqJCFsRSs0VVkX60IZU++WOtCoQ0tWqvJAFWY23Utjc7Rx62ryj
	icTqVKWveBAcHGG/8YB9KH52581rY+f1S2p8bIq01BiBwFGLClBMQx0LdPRZy5DzfeTkye/4244
	BDjLF9Stiu54gEYE+fMdAU/pDIU7SQb3VV1s27KbIsJJzeKXohICLR3V2v4EIGAj/yQEEGozUJA
	nijOyB4YCHeL/Z2Z8kmyPKEEDntuca1AlPkf2/gUVNIg7VvAe07lqVtVW1uME=
X-Received: by 2002:a17:903:120a:b0:2b9:fb0b:b727 with SMTP id d9443c01a7336-2bd27714d46mr39301505ad.39.1778677763716;
        Wed, 13 May 2026 06:09:23 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.09.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:09:22 -0700 (PDT)
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
Subject: [PATCH v2 20/69] mm/sparse-vmemmap: Drop VMEMMAP_POPULATE_PAGEREF
Date: Wed, 13 May 2026 21:04:48 +0800
Message-ID: <20260513130542.35604-21-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 03B114000E
X-Stat-Signature: q4z8zgc1hs4wzeaqakoc6eo1x15mfmn5
X-Rspam-User: 
X-HE-Tag: 1778677764-100237
X-HE-Meta: U2FsdGVkX1+cG3HQrYenRyBhwfF8QVKe21r0GKpaLrkTiiiZsqtCdlC/eaCwX7Mp95FmaD9wSs/73O+6VLjyu6iEYvNqz3/fWQ5MxLC5OcCInCKJjz3ipZKaBHXxeMt5fZpPSBriRYKUY7AJJ8+SKYYKH5DzP4Lo645Zmr1eU+DUGCAeUZSwaanpZP2NCVKidqhjqcx97njzN4ZuTQNXa+JOtNpdnS0N0PzKC8OfdOBlhMgUSr5I8sgbsf67q+5Ww3dlc8xD2y8xZwcIQU5LkaZcZHukdF8Pnv4JYpV/EnEuAtFg8R0BNX5f9+jkNlpooGOeBDuWzRnrq2BU3j0GjAlXGF0/tfir8e3tjDM8xG6DVaUH8Bz3EyyGZob4WYbtTM8DqYozVqYxpzGzajH0MfyoyKYORBr8xtbvq5XCGG4sGivXgcU18qPg68QjwPnhpgl795h1x8rrbXHDz9eQD9fkmtFReMiX16hc7Q1hHmVfqZ5cA9V524qNo/nrtL6BOTZmeZxIPLaU9LBuhXfoF9kD8OqW57E+/jUy3wCHjqAOzMBsxUjt4Vrreu4nxSkQSIdBOTclR5D3va2W5IIbkUz6fdV0lADi6rdrXsxYB06yMg0Ypcstn9Q2n6TZ3+/2mjzlkc3vOtylQ7FuE8Cy46lzwtciRTsFqwRdLQldHQYMnCEtIS/P78MfLpboJ7KI6VP8Z0taJzMOsPvClkMJ2U75UK5ENl75MidYFy6yVw+ngHe0vk5GkQZ0l6cOxUNR22V6n0oVDWoDFjZusMsgXAVntxArE8IVUvw171DZu/Km1/qffOXDdR4o54IVjv+anGBH/QMI497apQztPGXA3t8AYgYKNvAFP/GyIwcKdewhVBVdieL4Nbwk35kbXgM81uhETJmeKm9d3imgdX8osU7+u2HojqUpmA/Z8UB9oxmP3JewWuLdjQYmCA2xf9tP3reXD6xgEVPeM96gIaw
 SyHcr/zf
 o3jJYMC3LkTOSHqP2YW9XEzU4LfJpCjNp5Xkf6zMY8XFkdki+u6Zrg89T6cfacD9M04w8PqIX/ZFRAxsklnoamA1pQrRtt8u/xHe9IvVWHHxxYOBqByTJIZlHqC1RBMSB1ilmvrQjlQjeW+M9yS30XjCDaTMYToo5bNRUPXRbcZypSrQummE0YL5VC8MWoxPvQUmxvs5LMVQzH9UCTcxmk4bVVKCSTNXGokH1OUlzKJyBbSIrLwx4wF0zi+a2TvQuDTo11RYP12RHNdccW+9wKhA0eZfSFyGTQxH6S54LTyfI9h30zqZwUaVzDZP01AJjwmIzYDje9Ry8bByP8nWHp/G0sc9Z8B2czYJzK9Nb0RAXc90=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

VMEMMAP_POPULATE_PAGEREF is only needed once the slab allocator is
available, so it does not need to be passed through the vmemmap
population call chain.

Drop the flag and test slab_is_available() directly in
vmemmap_pte_populate() instead.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse-vmemmap.c | 40 ++++++++++++++--------------------------
 1 file changed, 14 insertions(+), 26 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 17d45dac4324..d7e9fb47f7ee 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -33,13 +33,6 @@
 #include <asm/tlbflush.h>
 
 #include "hugetlb_vmemmap.h"
-
-/*
- * Flags for vmemmap_populate_range and friends.
- */
-/* Get a ref on the head page struct page, for ZONE_DEVICE compound pages */
-#define VMEMMAP_POPULATE_PAGEREF	0x0001
-
 #include "internal.h"
 
 /*
@@ -147,8 +140,8 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
 }
 
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-				       struct vmem_altmap *altmap,
-				       unsigned long ptpfn, unsigned long flags)
+					      struct vmem_altmap *altmap,
+					      unsigned long ptpfn)
 {
 	pte_t *pte = pte_offset_kernel(pmd, addr);
 	if (pte_none(ptep_get(pte))) {
@@ -170,7 +163,7 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 			 * and through vmemmap_populate_compound_pages() when
 			 * slab is available.
 			 */
-			if (flags & VMEMMAP_POPULATE_PAGEREF)
+			if (slab_is_available())
 				get_page(pfn_to_page(ptpfn));
 		}
 		entry = pfn_pte(ptpfn, PAGE_KERNEL);
@@ -243,8 +236,7 @@ static pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 
 static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 					      struct vmem_altmap *altmap,
-					      unsigned long ptpfn,
-					      unsigned long flags)
+					      unsigned long ptpfn)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -264,7 +256,7 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 	pmd = vmemmap_pmd_populate(pud, addr, node);
 	if (!pmd)
 		return NULL;
-	pte = vmemmap_pte_populate(pmd, addr, node, altmap, ptpfn, flags);
+	pte = vmemmap_pte_populate(pmd, addr, node, altmap, ptpfn);
 	if (!pte)
 		return NULL;
 	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
@@ -275,15 +267,14 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 static int __meminit vmemmap_populate_range(unsigned long start,
 					    unsigned long end, int node,
 					    struct vmem_altmap *altmap,
-					    unsigned long ptpfn,
-					    unsigned long flags)
+					    unsigned long ptpfn)
 {
 	unsigned long addr = start;
 	pte_t *pte;
 
 	for (; addr < end; addr += PAGE_SIZE) {
 		pte = vmemmap_populate_address(addr, node, altmap,
-					       ptpfn, flags);
+					       ptpfn);
 		if (!pte)
 			return -ENOMEM;
 	}
@@ -294,7 +285,7 @@ static int __meminit vmemmap_populate_range(unsigned long start,
 int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 					 int node, struct vmem_altmap *altmap)
 {
-	return vmemmap_populate_range(start, end, node, altmap, -1, 0);
+	return vmemmap_populate_range(start, end, node, altmap, -1);
 }
 
 /*
@@ -370,7 +361,7 @@ int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
 		return -ENOMEM;
 
 	for (maddr = addr; maddr < addr + headsize; maddr += PAGE_SIZE) {
-		pte = vmemmap_populate_address(maddr, node, NULL, -1, 0);
+		pte = vmemmap_populate_address(maddr, node, NULL, -1);
 		if (!pte)
 			return -ENOMEM;
 	}
@@ -378,8 +369,7 @@ int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
 	/*
 	 * Reuse the last page struct page mapped above for the rest.
 	 */
-	return vmemmap_populate_range(maddr, end, node, NULL,
-				      page_to_pfn(tail), 0);
+	return vmemmap_populate_range(maddr, end, node, NULL, page_to_pfn(tail));
 }
 #endif
 
@@ -503,8 +493,7 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 		 * with just tail struct pages.
 		 */
 		return vmemmap_populate_range(start, end, node, NULL,
-					      pte_pfn(ptep_get(pte)),
-					      VMEMMAP_POPULATE_PAGEREF);
+					      pte_pfn(ptep_get(pte)));
 	}
 
 	size = min(end - start, pgmap_vmemmap_nr(pgmap) * sizeof(struct page));
@@ -512,13 +501,13 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 		unsigned long next, last = addr + size;
 
 		/* Populate the head page vmemmap page */
-		pte = vmemmap_populate_address(addr, node, NULL, -1, 0);
+		pte = vmemmap_populate_address(addr, node, NULL, -1);
 		if (!pte)
 			return -ENOMEM;
 
 		/* Populate the tail pages vmemmap page */
 		next = addr + PAGE_SIZE;
-		pte = vmemmap_populate_address(next, node, NULL, -1, 0);
+		pte = vmemmap_populate_address(next, node, NULL, -1);
 		if (!pte)
 			return -ENOMEM;
 
@@ -528,8 +517,7 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 		 */
 		next += PAGE_SIZE;
 		rc = vmemmap_populate_range(next, last, node, NULL,
-					    pte_pfn(ptep_get(pte)),
-					    VMEMMAP_POPULATE_PAGEREF);
+					    pte_pfn(ptep_get(pte)));
 		if (rc)
 			return -ENOMEM;
 	}
-- 
2.54.0


