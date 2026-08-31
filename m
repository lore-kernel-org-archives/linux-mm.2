Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A9B6C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 07:54:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F75B6B0096; Mon, 31 Aug 2026 03:54:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CF946B0098; Mon, 31 Aug 2026 03:54:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E6956B0099; Mon, 31 Aug 2026 03:54:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 376576B0096
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 03:54:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9CE06401CC
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:54:49 +0000 (UTC)
X-FDA: 85160803098.16.6CCDCB9
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id A9AE91C0008
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:54:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=IpPz5h+p;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788162887;
	b=QHQ/0iCun6BZbAPjwsYWQ/qePB4W1r42SFep4PWwwfXii9rsk6DJdwT80FFTgzQdJ0n4Sm
	L57XyyaFYL5R7PDPoJFya32yGdoQ40dvO1CsTS0Mfv1XT7zplibRKpxWJfVx1pKflSWryM
	qI4RvAY2iK7xnlEZIxyJN4jzXgSWzxA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=IpPz5h+p;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788162887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YVp9a6es5dGYiwq82JtXpVvKTCPlSq+5R8j2MYX8xm8=;
	b=3A4i8A3qYmaNIn/U0sm5+WdEEg8r7uRhkFxTqiLG6ClOoic00IDM1dEwUAbejLYfZW2VDW
	ZIjsOpufvQD2yjFhjXssBqyh3QbhCX6O3sRS9WrhPpKMemqjG3I/rIQi8zJoNobjP32aIu
	W94amdpnHLpoTEhwI8VXSLJt68WXqSo=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-84f38f3b36eso2689134b3a.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788162886; x=1788767686; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YVp9a6es5dGYiwq82JtXpVvKTCPlSq+5R8j2MYX8xm8=;
        b=IpPz5h+pCxa/z8itRRjdKroEln13tfFRdNwEBuMCVeyu6JDu2ConUwDcdvSWNeES8T
         KhkRQEccyTanOHb0v6sM5lzO6PTjxL9XPqQfjLpmO4+Z4i3OfmVj/oMZ8iKgwbeb8maK
         NSA1enUdE38ya/JJonysqMSz1Xc61GezeScmMCtscWzOxj4cEQ2OYSxP+MAMFR98ZzC9
         Kx6ERUK6hePMSi/y/9XCacz9yEOkutk3uSFlL6hH944laE+AOnREkVYQ9VmOJmSEDnG6
         ZKJ0Q1MIOfce2G899lu7Cv08zhMxwEtnZqU0km/56LX5Sm4S93AcJ4d3N0IlxgG7gp7Q
         DoFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788162886; x=1788767686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YVp9a6es5dGYiwq82JtXpVvKTCPlSq+5R8j2MYX8xm8=;
        b=QNTDEczK0GmBJR7UfFHQ/O9++9IpjTvgQe01iemJR6DwRyBGaaVxlBqfrXf3BwFOVv
         qC6S0wnFAijX9hrN0H6cySYPXJZ2kShoMay4u+ELSWYV8ss1nzyq8bjXM3xUuwf/JGsD
         RxF+UxL/VR6Gq4HQ4gjip3Q5NKh+/AfPPkOAOURMnwka7mTF9+DXk5+sWdbSJd8N2c6L
         iibKdvIGr8/wwE3E450VzcjDmrCyMqOWiMy+4S5vKY9aROa3b2SkuNlujJIzuFkGtrM/
         VvpQNKXU9jUHQmo2T2f/cNrjL29kPdjzhdFLQFZQA/t2LqsbYTTGQsehdh6trt7A2xEG
         Rn9A==
X-Gm-Message-State: AFuF++lsVp3bTTs2RfNvX56MDFLwRNwGTrLs0MrB+m2CyE0uq0g1ehAH
	+MJFQQnUaqadCi/kxgs5TChUceJt4mrlJ3+eu0zlgnMk1noGku/TnOnxEOHreWrBw/w=
X-Gm-Gg: AR+sD12OOM/m/XrbIMQrx29g9zjBuwil21Wu6rrn2nNtDeojG23t2hiwJy5f3jDDoVB
	RE0ikP7+2utKwftoB6JBH83Kf2K1OIfI6GUI05Cy9FHlxGJd6nIAHCbRnyL1FCIj4gMxPfB84e+
	eX7UmBvh44nHR+kE1oM2CTQE7xa7s8DIhyXVsmvmm9+1tf38Wn+MBPs+n6t/VNNbOfchKniaqWU
	JhqOviELXz2CWJ5FvwXqYwH1XignGr7WsJIAdwrT2rZFS55r6IJ4FXVxVMTxCD7yqf61UMCdkTk
	JHQibrD2lOeREmPA0QvYIgYJQADgMvdwmU56IuJeX3hNYyejfu+Z5z5XM+sLt378Utv0+nouxSe
	RFz36Ycqnl1n/pIxlOwMnVHvnp6nMw8GQKdLZB6NdIV8Nsu9NJWyi98Da2L2DQuQFKhctsyZ/7U
	aYcM8o7Ap+EePoHFzZ0dUjo4FHnrhodXs2vYdc+Dg/4sV0wDzbAzBFt/L2C9VfLw3RnKo+ynKGI
	hwBboFtamaccAHEFBMybfVu
X-Received: by 2002:a05:6a00:1706:b0:851:c1d2:c48d with SMTP id d2e1a72fcca58-8562a1f8fd6mr37313481b3a.8.1788162886422;
        Mon, 31 Aug 2026 00:54:46 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.9])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc1f330f88csm3590256a12.10.2026.08.31.00.54.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 31 Aug 2026 00:54:46 -0700 (PDT)
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
Subject: [PATCH 04/11] mm/sparse-vmemmap: prepare DAX vmemmap population for section orders
Date: Mon, 31 Aug 2026 15:53:35 +0800
Message-ID: <20260831075342.57563-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260831075342.57563-1-songmuchun@bytedance.com>
References: <20260831075342.57563-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ke56o3i7t6qzxaufqmo1tq8cuurjgzfj
X-Rspamd-Queue-Id: A9AE91C0008
X-Rspamd-Server: rspam06
X-HE-Tag: 1788162887-286044
X-HE-Meta: U2FsdGVkX18j1xqYpf8DKrwX5ESMkIGGxrokPwejeI75B9KTt9vterzizCm30h/mqMPbTzZd7pQVXIIQMVa78/ilLKJUCtdcmlYX1/NQpPStmEh0/w2OEO+clLxq2UZ4Iiil95lkvrSeWYJHzJ+8f0buOOn4p5Jop9E3L1hnNk8qN0SZroukwhEwXdPU4Wfa4jequMAkOxQyepYmP94Y5vU7evxd3QwDPFLaScIj2gA1CHzHfZVaet3ePlE4E0hsKMMiW3m/bsPW3xrtfL95VV48OFs1X1vdSk3ABQxd90mC+Pc+M3RbMoza4e9vafaa9+n2GTH35tQxKKNwhLxWRQVTpAq+iYtUJ1WOHMAOGpSDAJEeGXZFF8LUsxRdr4VXZsQGGiW/TTa/4foOpTmx5WeaDoSLjVR05/Diw7PC9GnQJe5BDrnZAw88MGBv3tyr4ov42WGFquyBITGa04ICXavB5Q5YCrN5no72jNbGPSxZ4hPVN5lIbFGzLTj9nqpp1JRogishFFkUNoO7ouIMqj5R7RQvyEMwL28KV5NhYugcpuQ/VQcHsHy3MfZdefUrz0leSWXSktrTkgDFCTRuqdNLtcDEpJwxCACQ+zx6VVzd/8RSLinCoOVpqGliAhhRJpyraMzKp7H6/2fL9fV8dBoRu7Jx61kZqL2n4hmNeI0USmW0lFsTkyuspG8vaa3mtOqw/b44IbidCZtx6biNw0uPnB/QUwG96MF3XauGiJTF34rL68Ps69P7TAn8Y4M+bCSHZQvLr037T1sSLt3CFD5v7ob3t/vRaK+lUuOvPCMjMzetXKOvlHUpwlUwiDoC17vpmklDfAL67GO4TNH/0XEsQA4FuNmxTgpDCUYZaa6gqxC4QsqnkuEADHA8HY145GuhB+BvUJI89bTf66VpqdnWYz+KPNVRfqwJCYPp0NTilYe7NPW30JlUxkjDhy6HjBjbNg3F/7Zi2e/POK0
 yo6H8DJb
 6x9l292BJCYxUdo1/fmFjECv1AlhSoaXdHa0kcZJV6Fi1K3GN9DDQTwIvOx+juY3STB2EWPYA+EOpcu3I6F0NoP8CLeyz5OHbhxqwSegzbw4JTkffv4N3kr1Uq8FvcErO8qVvTqqPoR95SgWRVnG4EdvYnCPNqqqrBbha0Hw/MVfE0RCVv/aHH/A147/GYdGd3A461Su+Gzs60iQvwZ6a2r+Oj4m+H8CPizSlnZSpK66NGxK3mJAKUlLcZkrrUVvBrJ9N1wl4bCbwBcJlNsn+0FkTfwLCGH6m0dbb1ecgu+Y7oavvVYfyJti6XA==
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
population path yet. Once a later patch records the DAX compound-page
geometry in the section order, DAX head and first-tail PFNs can look
optimizable to the generic helpers as well.

Add a DAX-specific population flag for this transition. It keeps DAX
head/first-tail allocations on the normal vmemmap allocation path, while
preserving the existing page reference for reused DAX tail mappings.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse-vmemmap.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index e453ce4675a0..54ae8c284324 100644
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
 	const unsigned int order = pfn_to_section_order(pfn);
 
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


