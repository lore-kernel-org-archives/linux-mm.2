Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 191A7CA5FA7
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 05:33:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C5DA6B008A; Tue, 29 Sep 2026 01:33:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 276536B008C; Tue, 29 Sep 2026 01:33:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18C626B0092; Tue, 29 Sep 2026 01:33:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E82C26B008A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:33:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 718CE1C258F
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:33:20 +0000 (UTC)
X-FDA: 85265681760.24.20ED653
Received: from mail-pj2-f34.google.com (mail-pj2-f34.google.com [74.125.227.162])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4BC76C0006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:33:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="lhcUdKT/";
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.162 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790659998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=58VRsumoisic/ifQBSVplSYobqhWBYVn5fC/uIc+7J4=;
	b=Q513oQrEM3Y6yu6+AKnoCHFryGvhX0h6W7jSWyxhKN9Xr34dsW+cWlbsk13ZPbusAZOkte
	K+m8hcFtFjiI15K+AiTKK5ht+ph7Tl2oOsnWpjjZGuSzNGI1eYKl2x7mr5Pc1K9xedhn6L
	MFkvGzKK97qFD0NOeMbjzC0negxBrro=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="lhcUdKT/";
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.162 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790659998;
	b=Y45kSXV2H+xLVkE1OVZmBNHgDOV/AdROd75y2KW8X+y7JIQCz2uefJYQ3nxfebyiixJUhG
	fspLeoxKoulHJxx2XqX0uWI5p+68KTUw33I6WeAlsiMXHeV4EKwC1PqQWAuS61d3jg1mu5
	1+EFfDaJ6R0/rJuPeYI8ukJB/5nV6Lk=
Received: by mail-pj2-f34.google.com with SMTP id d9443c01a7336-2d747eb79f7so16985725ad.1
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790659996; x=1791264796; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=58VRsumoisic/ifQBSVplSYobqhWBYVn5fC/uIc+7J4=;
        b=lhcUdKT/uHSqWAZgZazQQsuRThjsg9o+X5QCk0CABLPM5ggDqIoAf0WI4cUQ/gKNo6
         P185ffp3suRdBRi4h/Raz/HLgvtSqWEAHi0jBkFWOdHU9KSUZb+xCKmMBQDp0j8SUf0c
         unvNcxVac+jTO51Et/GomeTmavAkndPxG61tEzr6v5jmjoM+n1qJrfKwHT+rgq32D+Gs
         XIFdrAJ562qIzWUtFt3GiWR6JRj8mvgaTvj8s4XVhVUYQl0qrFVMN5Di6O1MpnSlcfpu
         9mIb/0z/FSeT3i3VHMtTTwwBxHaSa2HTw8ZXXV7sJo9cEAdiao65H55ZmqDOIB965pdU
         Ue8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790659996; x=1791264796;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=58VRsumoisic/ifQBSVplSYobqhWBYVn5fC/uIc+7J4=;
        b=bevbvrgOCzuD/OZx4nKeTL4B2YFWWWNBOopsGdOD7VyD2oF5jUYOp5Vzjidby0W0xv
         dp0wLXWE0kt6GN2gLdACyv3w+PUWqtwQ5/uuXU4RJXKu60EZW+oegLydZPR2lXGmGWG3
         QBdqhXMVnRwJ9JbMqxGZtr/kI70xhNSGK1dcIH572fpaCi5uUmPUe8tTHxR9LcCzOYP7
         EdxYO/vb/0d96GEo4S/FQwcqZLJdq1jp3FVEH3XQJCnJ5h5+4uC22IfbZyY6o1dCuwm3
         y/K3pCWsZdZEfSRTC0OfsipD9sKDc0l4GiMhLuaVPtn/sbBueq469qSPqQAYxn2o5Y1I
         U6Xw==
X-Forwarded-Encrypted: i=1; AKwUvBwyerxqsFlZnnULpQUfVqazSSvvzYhu9WJ4DT5+tC13k2YCqXjL/kfI2GkKrKio1GYrXaz+uyHhVQ==@kvack.org
X-Gm-Message-State: AFq9FYLX/mCFKvT3cvfoFh848Mw0Al3wGbeBpSLvvQtg+f/YmzVZZKDb
	Rl9meSuSucbthRL0IQuTM1ZeWVgNavRiYPHeyK8QO3ypOj+g6XvePmgesAISUIk35lY=
X-Gm-Gg: AYBFou0jVlju3syKalJyqdMuO94j1pK2jHiVh4wPPrO96/QRXazThf60dkzYltrp84I
	neZP+O+3uCExaXzE46MhtoOprLgaD3/6CTmf8GRTe5D5tHtMuc84j50fKh8KNowAq3qHp7JcePK
	d5iKUXs9kUtjhhvaUMHF3nLPms+pLlFC3OVnH8cwIQS6HceXEwYA527Twr07GtxtcZPS2KFz2mB
	hvqwES+UZr+fXBZ/XnqoBob6Ae5WDHnDqcYdP5xUA/T1tyP4aaoA/x7k5SJWFx4bakuqSMEL1Ki
	zVu8gds/R8iGBQAFSOyXo+qZrwZxyq2mnl/lTlg1C+cyJbi/US4RwEd4AyvpvGVvWjiRFLyf7kr
	3+XJJVaOzWN2bq6dOlbTQ1w2uICh+t3W5w3yYHOEhgE99CWNthYCTrP2XsdoFm0YzThZamJNkej
	IwKw0I+h3qIEi7Xps3yw12RCZ/zhUy2s42ToFdLkeHOE3vC57A4T39rKn0z2H+6leu5U6RFKWTb
	/+U4Vo8IN12uBAkGEc=
X-Received: by 2002:a17:902:db06:b0:2e2:c84b:43e9 with SMTP id d9443c01a7336-2e2c84b48d6mr11044645ad.1.1790659995651;
        Mon, 28 Sep 2026 22:33:15 -0700 (PDT)
Received: from G6L4RL2QG9 ([139.177.225.254])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df9142bafesm49251765ad.51.2026.09.28.22.33.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 28 Sep 2026 22:33:15 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
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
Subject: [PATCH v3 1/6] mm/sparse-vmemmap: drop VMEMMAP_POPULATE_DAX
Date: Tue, 29 Sep 2026 13:32:26 +0800
Message-ID: <20260929053231.66085-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260929053231.66085-1-songmuchun@bytedance.com>
References: <20260929053231.66085-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y34h4tkjmxb5wthus7yhdkcsodrshejj
X-Rspamd-Queue-Id: 4BC76C0006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790659997-391865
X-HE-Meta: U2FsdGVkX18VLzvd98LOz8a3TUdqrEVw+pC7h9ceHS5lnRQ1GyCYXvxW/zzhvUAwapuwFC6swwKpLz3DEZstfWJubznI38lgJGfGmOE6HjLQvqXHyyur4o0yOjGhqXbiKqR8OiFMkNMmWYyS9xc7jfosipM5Uu+AjL6M6EX9dxfqvemBSjOB8MT7bX6MuU95sHc4/StCWE1SHYUKCJx6oe152x/JZ2my3V1h88KyXDlP6+CvU6QUVyqneGhAf8uLTy67c1B1oRd0AUQ/+094Nl7lc3WUWKFaa/W/n2pzLbdB3X9RkbXy2MUP93lt9uoVN7Rxa4rSG97gyP4XuloovoiCGep5r4h8vIVDOTGtm6iWuja3auz5l2xZBy1AgNwZvgr7d0KNdk+38Qk/Z00YEmvHc7qAvLNxhXDFMWTqMV1ttV43FVJs2jJPHdWb4ASYObAKkAk5XGXdkYxDYkvsFzV3necNFvZEq2LuY/GTcDk5MArqU12g3f6kWTVFgUfxMZdOPXQ7jIFcXrG/nvO/+zu9d3f1LLoUFn0n73wyg8o/60CFtLbdGDD6nUvBoFIHL1gJIMZK6ycjuvyK66r2UIAXVRW8MtxztbrNZbO93UuNiqT/t29hyTGb3U6l0/kE6zyeK9WUcKDRnBzO1fC1RPW4V8Cf5/Y2giVOGdDiOopaIky6ekbh59d382WwVFRBPuzniUUF8UcIFP4y9wtcVZP4rjGGTJEyCJoPp9+a+vnCydP5c131r/KERbCOanSNYpF0qh/tUeSf5+tWYRvP0zZI2QFa12UGgHByH36e/ogyGfEuY4fW8waFHXFsRbXcBtlWuvMENSUfQ8a15M/q0A/+Get1S59aRm/fL/6Gdi3aAr0yRQwYVqUV7WS6dJ7c6dhzybT3EONd099EUdj5CQRS4sXYgHnxcoOV3yLfJy1tbM8wsujWvazwZeatJBVcHlVn284G87L4MxuiMKb
 jhfrt+NB
 /F4qKPpPDIQ9HWMVOFSEElPi0RYwsN1k43Vl83FTc71d2z4BYSGvJhG3MNCiPDjIcPKe6yaj2nka490Fy9jPuWZIL0T+DY/gkbN5m2zTxtvunSPWvWPXDPAwQOp3KhuLZxLy+fKPGd7CIOpr/nvntV/5Ef8/endYxKtxzqtoUP0liHZZ6Gj9pU7BaCQYQutTpyzEIjOY0GkGV02Xsu29gy5ZtqjwhobZTAJnIX60Eo8x9YBIoWHp8fTvYYVeCVLgVJPNBc+zPwh1/xSwr4ziObhhayn+IaVNtUWsK6slBGo8Om0Ew0txFXao0Ujns9L5c8bWgdHlMC7kGu3l4mzb6kDivPxpoklDEIinSNRT0i7Xbi7DAFi9WOXRJ/GUAva/Qn0N8udbQLQ+3sHilmh3+WUFHNRNFnT3sM3isvNY/M7ZprlR/1G2+3GGerQ==
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
index 111efc802465..8219abc6c3e5 100644
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
@@ -237,7 +231,7 @@ struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zon
 #endif
 
 static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
-		struct vmem_altmap *altmap, unsigned long flags)
+		struct vmem_altmap *altmap)
 {
 	struct zone *zone;
 	struct page *page;
@@ -247,7 +241,7 @@ static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
 	 * Device DAX still relies on vmemmap_populate_compound_pages() for
 	 * head/first-tail allocation and tail-page reuse.
 	 */
-	if (!vmemmap_optimizable_pfn(pfn) || flags & VMEMMAP_POPULATE_DAX)
+	if (!vmemmap_optimizable_pfn(pfn))
 		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
 
 	zone = pfn_to_zone(pfn, node);
@@ -259,8 +253,7 @@ static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
 }
 
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-				       struct vmem_altmap *altmap,
-				       unsigned long ptpfn, unsigned long flags)
+		struct vmem_altmap *altmap, unsigned long ptpfn)
 {
 	pte_t *pte = pte_offset_kernel(pmd, addr);
 	unsigned long pfn = page_to_pfn((struct page *)addr);
@@ -269,7 +262,7 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 		pte_t entry;
 
 		if (ptpfn == (unsigned long)-1) {
-			void *p = vmemmap_alloc_pte(pfn, node, altmap, flags);
+			void *p = vmemmap_alloc_pte(pfn, node, altmap);
 
 			if (!p)
 				return NULL;
@@ -287,7 +280,7 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 			 * Use try_get_page() to prevent the shared page refcount
 			 * from overflowing.
 			 */
-			if ((flags & VMEMMAP_POPULATE_DAX) &&
+			if (slab_is_available() &&
 			    !try_get_page(pfn_to_page(ptpfn)))
 				return NULL;
 		}
@@ -351,8 +344,7 @@ static pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 
 static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 					      struct vmem_altmap *altmap,
-					      unsigned long ptpfn,
-					      unsigned long flags)
+					      unsigned long ptpfn)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -372,7 +364,7 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 	pmd = vmemmap_pmd_populate(pud, addr, node);
 	if (!pmd)
 		return NULL;
-	pte = vmemmap_pte_populate(pmd, addr, node, altmap, ptpfn, flags);
+	pte = vmemmap_pte_populate(pmd, addr, node, altmap, ptpfn);
 	if (!pte)
 		return NULL;
 	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
@@ -383,15 +375,14 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
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
@@ -402,7 +393,7 @@ static int __meminit vmemmap_populate_range(unsigned long start,
 int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 					 int node, struct vmem_altmap *altmap)
 {
-	return vmemmap_populate_range(start, end, node, altmap, -1, 0);
+	return vmemmap_populate_range(start, end, node, altmap, -1);
 }
 
 /*
@@ -531,7 +522,6 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 	unsigned long size, addr;
 	pte_t *pte;
 	int rc;
-	unsigned long flags = VMEMMAP_POPULATE_DAX;
 	struct page *page;
 	unsigned int order = pfn_to_section_compound_order(start_pfn);
 
@@ -541,14 +531,14 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 
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
 
@@ -558,7 +548,7 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
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


