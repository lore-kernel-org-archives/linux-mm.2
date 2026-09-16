Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A802C982C1
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 06:44:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 165256B009D; Wed, 16 Sep 2026 02:44:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EEFF6B00A0; Wed, 16 Sep 2026 02:44:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFD226B009D; Wed, 16 Sep 2026 02:44:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B4F836B009D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:44:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4594F14063F
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:44:15 +0000 (UTC)
X-FDA: 85218686070.16.3DB53C3
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf29.hostedemail.com (Postfix) with ESMTP id 815EA120008
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:44:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=R02MLnfa;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789541053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jrSUwqa7xtL2ZBs1WlB04Z11tmz781BnHoaaNOznkvI=;
	b=FG/sh9gN+ivwlgmgvapOlCl7DeIYWgf5O9dw61a7tStKJS/V0E1XvhtOBCRikGFLrDpIlW
	BUz3uSY01kA08tA+YhIta7YTuV8hOIAhbrF0OMYWSk3PaKgA7qbRVVe61zbIzc4iwFXgwO
	jsAv8mZ/bG8OhJg1qRyUUb/YsoP4H20=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789541053;
	b=nM6DCoIL4c102wY7VPOxa3QMEEWOrEOINoARHgW8Cza5/ie27Io34qqQNYqRTHlzMRhsN+
	Wlel51dlp05zrn7aTuybKh4PQysTMB/e8+nESy5CoM4vQAww7SO45kjemQ9HWHipMNV2Pe
	SFSJa6pgloBeNxfEKvMFWCiGtDkwWZ4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=R02MLnfa;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2db1ca069c8so5240715ad.3
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789541052; x=1790145852; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jrSUwqa7xtL2ZBs1WlB04Z11tmz781BnHoaaNOznkvI=;
        b=R02MLnfakMz+s6CQiAGP0a5hS6aBDLV2YEbyjR5yuCVjqkQ+jUMidhFn+iLofy1l2d
         zhnSkm1Us4crMIEWriBjf1fggVV+EMNnP0K9taGfPpy2u0j1XR4ARMsJ0MAP8tgokPrc
         ii6sfgt8G/4dNdoU9KT8RbXZwDAr2MwR4ci6FqUg7Csco/2q7yJUyMdl1ffhRp1YwdJZ
         6F9o71DlGP/8KqxBjwOw0X2ncKG6Yjlvw8MbUWDcL3gYEwiWzDpMkMX+WxLpE35CRLHS
         N4ZVH8ZtnGX2Gk1+0VA6+olh60fYzuRpquk+4jI7OQfi9EocVHSs2cQpWjsKpHvLkRPa
         gJeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789541052; x=1790145852;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jrSUwqa7xtL2ZBs1WlB04Z11tmz781BnHoaaNOznkvI=;
        b=cZahiZYLKePKbAq84QoD5ybbAe0sAuCOoIxmK2lBgj0TL4HJ2nIh8e6l8lCmwL8HiE
         lGUeiXvB94iTtTa41xGE5JFO58xoXgQvHR7AJuRWHtXyUMUC9ycIzJXb+/YCuwwfEXtb
         ThPvpVT9VxXEQfZ7v22P6ViqVTa62ad4rGOiVxVAw/msThLNnwcDNj30pGWwd4ClMvs1
         HMrLtcyjGrFBCS2hfsneUCvVa2C5VmqpiQwVSnaxsluOdX2iJ2elZlUZU/EredGvqP4D
         y+rtkoZegSwfJucEKDAENAa+kiGmuukf6oFmIdw09wA/YuJlGUxONYQ0NH2QsLNaHNxN
         k0vQ==
X-Gm-Message-State: AFuF++mU8BW52r05bIbLR6k0HhKuk9AKL3XeuJ0EfPQ0Z8eKaFeBe9aj
	QcqK0b5573bl+pKXBBLNaGlF8jcRY69KRvf7Iaw6JVf++/WMS7muhjs11TTQBOfv58E=
X-Gm-Gg: AYBFou1afLNz30y6Dt6ArLy1Ealu7g823diMQw5KbG6kvj/QuH3M/4mUVg/uyOIpedB
	BNKJI/v6XoJcHgDEqK/OgQFku/LsN6HBZfFCH3Nsy5ZmvtZUTtXehCo3Jz1aqLIU7mQYZ3GTDi4
	LWACdAW2KJiCUW9Zg+hLfaZg+dYK0Ky80tVImfSYUVGG5VSuIjS32u7La+sGLTcT4xthd1avP8T
	DpOIhsn+1Suzus6AcXiew0Dxyvh8PFt3TwiBX/u/4bbK64k4sASKNPb5dWs+YYQUAZOdiaWfXGg
	bXsOOXGvfs3/Bq6on5npFYVGaHjXdv7q+n1ViN71eCOiqln16zydQzZdJyAjoUnDyxD6r0dj6xZ
	w3tki4m7ZkILtTusRmlSoNSrk5PantkadjZxcJwC149rJfRrglKVXaCwGP6acu+V/9es4ZY9mGH
	MG69FwtNVkjFaMLfLfie/vjUeeS4G+q4funb9V0EIc7JF1/FOWeXdhXPiTGMbCJnht3Y2p3TBCZ
	a+h21Zh4PM9a9fRa5c=
X-Received: by 2002:a17:903:1251:b0:2d8:d4d0:792c with SMTP id d9443c01a7336-2dd8e752f13mr29866745ad.16.1789541050075;
        Tue, 15 Sep 2026 23:44:10 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89f0592asm6074755ad.62.2026.09.15.23.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 23:44:09 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 04/11] mm/sparse-vmemmap: prepare DAX vmemmap population for compound page orders
Date: Wed, 16 Sep 2026 14:43:34 +0800
Message-ID: <20260916064341.1825793-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260916064341.1825793-1-songmuchun@bytedance.com>
References: <20260916064341.1825793-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 3pmydt8y8u5zon3hbj67rzhwszzqd9uw
X-Rspamd-Queue-Id: 815EA120008
X-HE-Tag: 1789541053-510177
X-HE-Meta: U2FsdGVkX1++FGlsDoZlzSHpM6573ASM6W/ke5Cvh9KiEwjByQvF0AlyUXb8u+fLCHrkokdQblU/kXK1K6RN47BDruSufZxyG1QEG7RXl5E1giLqT/VFdms+45UHbxBz3U0t2VHRJiDHTsV2IrzUwAZn+tsXTEc7R6G/2Tsvd/BLLvvp8EEE3qnFGkbTWfejpuDN/lDVX1zhO0cMDh9aZJ8BqEuL7ES5SXDNUL/0jwHjFa5DZnvkIBzAxhlRh5GGD+nP52pS5UcqsOg+eHLvwkUu8Md1XOSjw8rPFUaxVwom4bDWwzQ/c3NLaXY+ivvzdc9T27ygRBnFNyhkiAcJ4EpQSchofoG/eCVL3VIUo063EMdvMP9cbwS5pd32KqRGaoDT80ZpDTXjuGWxiYgPRgUEPCJlskOMeMzd9GYuwgq2nMjirY0hs7JdXyfNpMGZVvROMIDdKMNljeH5/OU3S+hiAYTZjDH16JKO/0Cx3pRezfmqtBdalVMaKoEWpQh4EUhxrHHnc+dBfjDvHSneVyg5KJ+czKXKYEN0W34BIMfQ+3/oTCYx8F5bRHqB2NVgKi788jTBtLRF7QhpP0wHOofbg/O8DJdzB6HaLpWaY5/CwzatuAYw09sY2r3Rs4iZ3NtalyGlTcvmozGGU1XZrCM5VbFupDs1WqXNPUGrsozUFTgksJccZlWAXhYiXVKWd5syU5oKsSAI2x1QF/VEbWc6+sbQz9TwfM1xEdugkSPrH8i+AmPh8hlrwUCA9+abpxippn8GvJssWKlMeluYPlztGMZH9ro1abH0a2YGfNr5QDxHHHlgLGnXNp4UkG8xFWVBSc/OrckJtclLvHZnQNIJRmdNlOHyvkoorCrYtxPKpArZhqkhYGxbUgiW2ZqT7DCkSLcJjwRB2/sjxtx6l8clbj1NoApf0LgDtDeR6qLBLau0v7TfIj7jGMfjIMb3/MobZ6L7bhARKc9Knss
 Y6gP2aU2
 aJTW0QsCKtTQYYD/CPDzvXnVSAGjn89f37h/pH+u4+LGGeXxciMh0cQ62dNuz8o4REb6sNEjqO9fNEKjgavSmdluxdXzM1bHjA+pG5YOuD+Ur7mxng40EhDdA2v+zuksry4GRNZdmvsImey5/BMes55gzXcILXvR6Fy+XnypIyktfKpC+5iPK2Cz8/nDhGeoPZiW15asosD7Oqdp9NNZj0UCJjwayBpMv70QOO7OkqYlC/pxTLcy63BP+Nho0dBoU5rb/DE16lmNAELuR1ByVQ7uE5qpCJ9E73TpsIuJFg1Lf5EZJAQsIk/nOww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Device DAX still uses vmemmap_populate_compound_pages() to populate its
compound-page vmemmap mappings. That helper allocates the head and first
tail vmemmap pages explicitly, then reuses the first tail page for the
remaining tail page mappings.

Device DAX is being moved to the section-based vmemmap optimization
infrastructure, but it cannot switch to the generic section-based
population path yet. Once a later patch records the DAX compound page
order in section metadata, DAX head and first-tail PFNs can look
optimizable to the generic helpers as well.

Add a DAX-specific population flag for this transition. It keeps DAX
head/first-tail allocations on the normal vmemmap allocation path, while
preserving the existing page reference for reused DAX tail mappings.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v3:
- Update the subject and commit message to use compound page order
  terminology

v2:
- Collect Acked-by from Qi Zheng
---
 mm/sparse-vmemmap.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 861e09b2b096..aa89c16f7fc7 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -35,8 +35,8 @@
 /*
  * Flags for vmemmap_populate_range and friends.
  */
-/* Get a ref on the head page struct page, for ZONE_DEVICE compound pages */
-#define VMEMMAP_POPULATE_PAGEREF	0x0001
+/* Vmemmap population for ZONE_DEVICE compound pages */
+#define VMEMMAP_POPULATE_DAX		0x0001
 
 #include "internal.h"
 #include "mm_init.h"
@@ -208,13 +208,17 @@ struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zon
 }
 
 static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
-					 struct vmem_altmap *altmap)
+		struct vmem_altmap *altmap, unsigned long flags)
 {
 	struct zone *zone;
 	struct page *page;
 	const unsigned int order = pfn_to_section_compound_order(pfn);
 
-	if (!vmemmap_optimizable_pfn(pfn))
+	/*
+	 * Device DAX still relies on vmemmap_populate_compound_pages() for
+	 * head/first-tail allocation and tail-page reuse.
+	 */
+	if (!vmemmap_optimizable_pfn(pfn) || flags & VMEMMAP_POPULATE_DAX)
 		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
 
 	zone = pfn_to_zone(pfn, node);
@@ -236,7 +240,7 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 		pte_t entry;
 
 		if (ptpfn == (unsigned long)-1) {
-			void *p = vmemmap_alloc_pte(pfn, node, altmap);
+			void *p = vmemmap_alloc_pte(pfn, node, altmap, flags);
 
 			if (!p)
 				return NULL;
@@ -251,7 +255,7 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 			 * and through vmemmap_populate_compound_pages() when
 			 * slab is available.
 			 */
-			if (flags & VMEMMAP_POPULATE_PAGEREF)
+			if (flags & VMEMMAP_POPULATE_DAX)
 				get_page(pfn_to_page(ptpfn));
 		}
 		entry = pfn_pte(ptpfn, PAGE_KERNEL);
@@ -511,6 +515,7 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 	unsigned long size, addr;
 	pte_t *pte;
 	int rc;
+	unsigned long flags = VMEMMAP_POPULATE_DAX;
 
 	if (reuse_compound_section(start_pfn, pgmap)) {
 		pte = compound_section_tail_page(start);
@@ -522,8 +527,7 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 		 * with just tail struct pages.
 		 */
 		return vmemmap_populate_range(start, end, node, NULL,
-					      pte_pfn(ptep_get(pte)),
-					      VMEMMAP_POPULATE_PAGEREF);
+					      pte_pfn(ptep_get(pte)), flags);
 	}
 
 	size = min(end - start, pgmap_vmemmap_nr(pgmap) * sizeof(struct page));
@@ -531,13 +535,13 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 		unsigned long next, last = addr + size;
 
 		/* Populate the head page vmemmap page */
-		pte = vmemmap_populate_address(addr, node, NULL, -1, 0);
+		pte = vmemmap_populate_address(addr, node, NULL, -1, flags);
 		if (!pte)
 			return -ENOMEM;
 
 		/* Populate the tail pages vmemmap page */
 		next = addr + PAGE_SIZE;
-		pte = vmemmap_populate_address(next, node, NULL, -1, 0);
+		pte = vmemmap_populate_address(next, node, NULL, -1, flags);
 		if (!pte)
 			return -ENOMEM;
 
@@ -547,8 +551,7 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 		 */
 		next += PAGE_SIZE;
 		rc = vmemmap_populate_range(next, last, node, NULL,
-					    pte_pfn(ptep_get(pte)),
-					    VMEMMAP_POPULATE_PAGEREF);
+					    pte_pfn(ptep_get(pte)), flags);
 		if (rc)
 			return -ENOMEM;
 	}
-- 
2.54.0


