Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69317C98310
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 07:58:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BF886B00A0; Thu, 24 Sep 2026 03:58:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 396B76B00A2; Thu, 24 Sep 2026 03:58:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25EFF6B00A4; Thu, 24 Sep 2026 03:58:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01E046B00A0
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:58:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 863D4140275
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:58:10 +0000 (UTC)
X-FDA: 85247902740.14.6C28BB0
Received: from mail-pz2-f39.google.com (mail-pz2-f39.google.com [74.125.228.39])
	by imf24.hostedemail.com (Postfix) with ESMTP id 45EAE180007
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:58:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=On4xXV7y;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.39 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790236688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VgA5dgb5izhCu2j+FaX7Ht7UUGMfz5OynkoaMbINRFs=;
	b=hcO5kBOWe8Z78Jt8E6vBSbtyXvS6KFz1lNcCRpnkb0t54hGMs487WfxdqSeWndcrGX/P94
	83s80I8HXkXEciO/5d+63Z+DlejJWefrH0x6nMkPLqxrT6lBr1kxrpyZGv4gGVs2fWcCAw
	PEMpTcvHO/Fum3+xx7B/cYh9kabxFBc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790236688;
	b=HEvr7OAe56MJeAuQvTzlISHGL02D3Q35hNkSGm8cbl5COme9MnorWmfHiLmPHjnCunFMNd
	G+6EZzFASlXAC0yWmpNL5fqXRl59bxbejn4g9c9fuOX5Ob9b2MGMi5J9BvTVkaHq/ZEr3+
	XoLPmq9zRiyYVzjvyH7AETboT/CiKkg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=On4xXV7y;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.39 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pz2-f39.google.com with SMTP id 41be03b00d2f7-cc515bef69dso854801a12.2
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 00:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790236687; x=1790841487; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VgA5dgb5izhCu2j+FaX7Ht7UUGMfz5OynkoaMbINRFs=;
        b=On4xXV7yKZQce3Es3nJyDZP8KNQmBzyMkKevOJbx01HT9BczbWEyMH39yepV03v6k9
         IOWm+ZW8wtm66HdTwe0d76X+BpyIjUQp7Jk3AD3RlX4xCzJY9X9LZ8ZjB2/gDLhMthoh
         JyOhKbZy7qLTvzePEcgGLMFYbTYjn247ahulJOz3O8C7BY0gifFhToan4ZXDkahAJbZu
         B574o4+mPn8BHk9+TSTe2Hze4XlbUNsPbGVqHIoGU46VdDSrac78RUHO/zDheDt6EZrD
         Jx0iBFVMETzgFi4hJwKROQ/ndcQEbfUGOAja32GI23UXnEykVVvfP1yv8xhS7cVCK1nX
         RNjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790236687; x=1790841487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VgA5dgb5izhCu2j+FaX7Ht7UUGMfz5OynkoaMbINRFs=;
        b=zcCKmNgmA8mGMMi75TulW20qXDLRTtqHAOKvMthhc26HFA+xWmF1yDF3Xy1/avA8SJ
         xiJnINcBkua+nh37FrpO4yrBnK+uoYGdNYAjmNPMXX6clka7h2pqMMj6/MCRutzryaUe
         2SBacXJ/AXN0hss5aBt4V7NLrbNPWVNJ2eN72iq+0xRgvdD78LdyiIQNBzlwPvT4+/kp
         RyHc+/RGRyiM8qk+cJiBWGH2IBSJXJv+97JSS3vSyD1Yme8FC8QHfIJHgIm8LTfsjflc
         EMPmWaoOe/tO7ozJmDOYtQyOLIP/LA8LxAaKq8aQx6dJBBkBIaF2uON0Kw3mxXAf8P7q
         q5CA==
X-Forwarded-Encrypted: i=1; AKwUvBzyxOKLgY7W8DwYc/rfOyjVRxCm2yPNEsBbT0f7bfXx8qWR5A6+rs1b17+6Mbh7LxQJv3aOXesIYQ==@kvack.org
X-Gm-Message-State: AFuF++l0akxdFUU3XIte9OxGKWbKeE8y+rY6ekwQ2MP8VLCb0mUVrfBW
	CvkGnQ8KLkny5o3nfX+LBINxrg2LOEI1Nsr5zMlVJzr+E8Yg2uWG/BK4EnRmdIhcHsU=
X-Gm-Gg: AYBFou1nIjjdhkmELdP5BocYaKEHVn7km7M38IB/BWwvShkBpweREKxNu/zmjTRORle
	g2lmdKw6zBZikedaqqV1yd4r+vthVEGT30y3TbNL5B+F+p7/zuPn4qmpX9s4V0Yakd3gbz0a3m9
	RB8nbKtV9K5q4i42tld/sEHTyISc6gijRtC7hEGgCXlAntXRsZ1nO0f/Hz7buHnPvUQo9d5MEna
	jfRVouCosJPazYbURa8QTMVwr2m3OtyvHG1FWU27a88GHsQDJsl9FIUa2YTBHmAoqAAklHALxl1
	EF5DCUUEZYh/AbY36VR1UlKwwteED7IFYNowIyvjLwtxLjcjwmUmKfIfrr0mLJvblQXtrXsX6O6
	8UekE943DBGamr1dK5mpwF575M4eUI7Q6vF6warmtJHlT1g1/h0un78CT9jqaQ/ZAefxPBa67yp
	mUYmokKyRTbdmtCzjcs6JEGGzdiLUA80vJYD74cUWJ/gToV1e7h6AQrVxosw9jT7hfhriv6oL6v
	rE4l4/6mM2ZQDvNh5kBWA2vlRSxSQ==
X-Received: by 2002:a17:90b:4d07:b0:39d:fcbe:fdcf with SMTP id 98e67ed59e1d1-3a0985700c8mr1539659a91.1.1790236686989;
        Thu, 24 Sep 2026 00:58:06 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0972eec92sm3575622a91.7.2026.09.24.00.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 00:58:06 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH v2 1/6] mm/sparse-vmemmap: drop VMEMMAP_POPULATE_DAX
Date: Thu, 24 Sep 2026 15:52:54 +0800
Message-ID: <20260924075259.2013039-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260924075259.2013039-1-songmuchun@bytedance.com>
References: <20260924075259.2013039-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 45EAE180007
X-Stat-Signature: i5ptpgd4yp1hkgf1dfgs74fa4eb5cf4d
X-HE-Tag: 1790236688-92324
X-HE-Meta: U2FsdGVkX19NDYbzFTHyST1sRPyc3AOUEb3A225s2Bw534EwLy+bsmTjFrUQbB6l2utdU/yOlBnByt9TyUS9w1Yj6sGV8PQ7ow9B1eMPgbc7q2WLjDKh88aEnNGQ+fybYYSPtTdmdw5R2w+OzyItcv9fiUC5c847sc6q6yoFWwI+e90qfDBSkI7eEIqs17DSwaW9WTojl35CGDfq276AlAYGvk2Ye7t1cIWndP7RNM+k74XFrU7RGO9PJru4MqIWveaAVGG8JMloYDcyjcdiFtD3dTKfYJNrhXFIGrsxWYAEVTTuCu1VxJOFF3tDmKNNI85aJRV51vt8mxMJK4CX5RRR1021Wf2VZNEZQPkNZyjC3+OJToJdj1jvLS1JBgkaHDTIoYgU8HbpzgM19ZaHXtyNmYk2Q1zMLbtwIKbYBSF5kXI4mteRA7oiVGVxOUq1iU8yt7IYy+ZnwRqQuqd8xjol5FBoJjjmLUAmlOGhGEFP+TTcQJYqDKY0+RGeN4hJxg9dL+xR95UTFaJIlQFtyS8MfCrmjBUvilth8KvCH2qepbFCMTjfUDz5XNd3IlvqiOOHCl83CczRIqjU25gK1BiiQT45HQS7hpTAC3+TKiJVwq6XanLi/fYfuPAIFZA3yGAzDHTw89Ciye1fyfmMRDsP3GmgvKlA3TcE2mMszFLuV+TaMcNm1VK8+SILFNpt3ttft05H5mKfAUxnlRODEAopJ5OS7KF0qTKgzkCBaPHiTh2AvtFA3F5UOY2fpwQ47izPdDgcSR6kWfubHhM9y2lmjjD7Erua7nK9yj3a9ZsMzTU/fqaSRRuFdSrTGD6lrYV10G9GwDUlcIaxW/5xTAyPya/TORdhh6DwOyGcijZSxGHz1mTXHwTx945brHFsjfRvuvLS8JFiarRInWtIdPh/tY0NyQ8UJo0BfTFJgIZhb0yUys4sDfUSIapKGBkkqwTzTqwzPAplEQCH5Is
 UzlB1tNN
 b5rQ9O1HplaQibiVTwRzIS7qrGEWkkvllJusfDo99nMa6Hkv+BSyY//+wl/mx6wo0avdzTmEMRGULjbDZcmGDavxRbl0vpzZC/f2OUht3Gkj/37599OqiE1WG6NVGsNRYhzF9eQDvrb09jrKtSW9i5CftdBCpmnc+pB+6rDAAyWrcjzGUZfNDAU3m1PemXYE6Ej4WhRlhKqqsVB7IapvbbW6frIyStPSpewbzGhGR0DQmmIc72/UbDtAUahxNxxPOVtFZ3VNqRQD/9uHWMdZJVSerAipCFn4GezUd8z0rbk2bTHzJ/bxAhJjS52N5pSP1JjVfKxAzvrwBQZCA2naUD4Hd1pMyoqPQV9wrnAvJwcJ64Hs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

VMEMMAP_POPULATE_DAX currently distinguishes DAX vmemmap population in
two places: it keeps allocations on the normal path and takes a reference
when a backing page is supplied for reuse.

After Device DAX switched to the common per-zone shared tail page, both
conditions can be determined locally. DAX supplies ptpfn for every shared
tail mapping and requests an allocation only for compound head mappings,
whose PFNs are not optimizable. Therefore, vmemmap_optimizable_pfn() alone
selects the correct allocation path.

When ptpfn is supplied, the caller is reusing an existing backing page.
Once the slab allocator is available, take a reference for each reused
mapping to balance the release performed by vmemmap_free(). Although the
buddy allocator is available before slab, no vmemmap population occurs in
that interval. Earlier mappings are backed by memblock/reserved memory and
do not need page reference accounting.

Remove VMEMMAP_POPULATE_DAX and the flags argument from the vmemmap
population helpers.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v2:
- Explain why the buddy-to-slab initialization gap is safe (suggested by
  Qi Zheng)
- Collect Acked-by from Qi Zheng
---
 mm/sparse-vmemmap.c | 36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 3267f9362c68..919c94a36346 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -32,12 +32,6 @@
 #include <asm/dma.h>
 #include <asm/tlbflush.h>
 
-/*
- * Flags for vmemmap_populate_range and friends.
- */
-/* Vmemmap population for ZONE_DEVICE compound pages */
-#define VMEMMAP_POPULATE_DAX		0x0001
-
 #include "internal.h"
 #include "mm_init.h"
 #include "sparse.h"
@@ -208,7 +202,7 @@ struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zon
 }
 
 static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
-		struct vmem_altmap *altmap, unsigned long flags)
+		struct vmem_altmap *altmap)
 {
 	struct zone *zone;
 	struct page *page;
@@ -218,7 +212,7 @@ static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
 	 * Device DAX still relies on vmemmap_populate_compound_pages() for
 	 * head/first-tail allocation and tail-page reuse.
 	 */
-	if (!vmemmap_optimizable_pfn(pfn) || flags & VMEMMAP_POPULATE_DAX)
+	if (!vmemmap_optimizable_pfn(pfn))
 		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
 
 	zone = pfn_to_zone(pfn, node);
@@ -230,8 +224,7 @@ static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
 }
 
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-				       struct vmem_altmap *altmap,
-				       unsigned long ptpfn, unsigned long flags)
+		struct vmem_altmap *altmap, unsigned long ptpfn)
 {
 	pte_t *pte = pte_offset_kernel(pmd, addr);
 	unsigned long pfn = page_to_pfn((struct page *)addr);
@@ -240,7 +233,7 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 		pte_t entry;
 
 		if (ptpfn == (unsigned long)-1) {
-			void *p = vmemmap_alloc_pte(pfn, node, altmap, flags);
+			void *p = vmemmap_alloc_pte(pfn, node, altmap);
 
 			if (!p)
 				return NULL;
@@ -255,7 +248,7 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 			 * and through vmemmap_populate_compound_pages() when
 			 * slab is available.
 			 */
-			if (flags & VMEMMAP_POPULATE_DAX)
+			if (slab_is_available())
 				get_page(pfn_to_page(ptpfn));
 		}
 		entry = pfn_pte(ptpfn, PAGE_KERNEL);
@@ -318,8 +311,7 @@ static pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 
 static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 					      struct vmem_altmap *altmap,
-					      unsigned long ptpfn,
-					      unsigned long flags)
+					      unsigned long ptpfn)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -339,7 +331,7 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 	pmd = vmemmap_pmd_populate(pud, addr, node);
 	if (!pmd)
 		return NULL;
-	pte = vmemmap_pte_populate(pmd, addr, node, altmap, ptpfn, flags);
+	pte = vmemmap_pte_populate(pmd, addr, node, altmap, ptpfn);
 	if (!pte)
 		return NULL;
 	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
@@ -350,15 +342,14 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
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
@@ -369,7 +360,7 @@ static int __meminit vmemmap_populate_range(unsigned long start,
 int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 					 int node, struct vmem_altmap *altmap)
 {
-	return vmemmap_populate_range(start, end, node, altmap, -1, 0);
+	return vmemmap_populate_range(start, end, node, altmap, -1);
 }
 
 /*
@@ -498,7 +489,6 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 	unsigned long size, addr;
 	pte_t *pte;
 	int rc;
-	unsigned long flags = VMEMMAP_POPULATE_DAX;
 	struct page *page;
 	unsigned int order = pfn_to_section_compound_order(start_pfn);
 
@@ -508,14 +498,14 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 
 	if (reuse_compound_section(start_pfn, pgmap))
 		return vmemmap_populate_range(start, end, node, NULL,
-					      page_to_pfn(page), flags);
+					      page_to_pfn(page));
 
 	size = min(end - start, (1UL << order) * sizeof(struct page));
 	for (addr = start; addr < end; addr += size) {
 		unsigned long next, last = addr + size;
 
 		/* Populate the head page vmemmap page */
-		pte = vmemmap_populate_address(addr, node, NULL, -1, flags);
+		pte = vmemmap_populate_address(addr, node, NULL, -1);
 		if (!pte)
 			return -ENOMEM;
 
@@ -525,7 +515,7 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 		 */
 		next = addr + PAGE_SIZE;
 		rc = vmemmap_populate_range(next, last, node, NULL,
-					    page_to_pfn(page), flags);
+					    page_to_pfn(page));
 		if (rc)
 			return -ENOMEM;
 	}
-- 
2.54.0


