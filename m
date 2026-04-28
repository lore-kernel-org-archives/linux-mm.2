Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAC5EFF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 10:29:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D3726B0088; Tue, 28 Apr 2026 06:29:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 084916B008A; Tue, 28 Apr 2026 06:29:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDC926B008C; Tue, 28 Apr 2026 06:29:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DBBF36B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:29:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7A4DAC1F1B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:29:47 +0000 (UTC)
X-FDA: 84707593614.24.23CF731
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id B7F7880006
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:29:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Q/4eEsoK";
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777372185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ik31q/aD+ds5j3SKW58VX/93WQ2n/YRy1lFr/0XID94=;
	b=NeEFscEEUCi34AxT0Y041baWe+snu+jeKTVaX5Y2i6LLxuyXLYP/uEr0ziPwSiSbwe1AdL
	PtblJzmvf2pHBnNTAotN0M/HdeCkVXTrMOuVG7IrLJOhM0L5BXNMmSibu+YfzMHp4LmAy2
	a0RNludtOpGDf1ztyCivFxXfPlbefGA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Q/4eEsoK";
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777372185; a=rsa-sha256;
	cv=none;
	b=Wxhl3uh6oCe2Dn5J15Y07l+BtMAAPp3UyXNnYpsgXCCPHMawBm1QVQW+5veZ+MCWXGLJca
	gLPGdF56/9wJwLN/tKlD7UUv8CtPY/nI/kXSivRK6+qgfnah0WK0yN5lklXVuSNeECGVuB
	gc3o9XG/uPgrhnGnFrQs4CsiWIAO/44=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A885F40906;
	Tue, 28 Apr 2026 10:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3964DC2BCAF;
	Tue, 28 Apr 2026 10:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372184;
	bh=n4th+Ylo0hBgsOJ/cL1S7lsKVsZLR54r3ciaXa12im8=;
	h=From:Date:Subject:To:Cc:From;
	b=Q/4eEsoKG6omncorah8V1VjT6hqoohB5dMzP/5sGFLhWUnaG1k6Yy3ddLF2yUwjMz
	 6ADLkPCbx3hZTxkWz5XtPF5hpvVBBbx5flX5p4X/LDrITONAU2leVyak/6tMi14253
	 Px+oHhjmXIi6ttYVKMGjCWvQS17a/QwX+Jhm/Ha5vJNXh0dU1RpsEvHaROa8g5SERs
	 WYhFhb9EFwOzAhEFlv3aSY3nv38dXkm9s/el9EnCpV0XTJZEggYc5+80rV6eT6zcq9
	 0lTpBfRvE5SMEb5yZ4v/4SgRrZ/s+gTcVWk0EP/5N2KH3+eQrImicg1CKEWvSRY6kZ
	 6UGcwtxYZWshQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 28 Apr 2026 12:29:36 +0200
Subject: [PATCH] x86/mm: fix freeing of PMD-sized vmemmap pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-vmemmap-v1-1-b2aa1e6db2c0@kernel.org>
X-B4-Tracking: v=1; b=H4sIAA+M8GkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDEyML3bLc1NzcxALdxCSTJEsTy8REcyNzJaDqgqLUtMwKsEnRsbW1AIg
 J1eVZAAAA
To: Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Lu Baolu <baolu.lu@linux.intel.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Lu Baolu <baolu.lu@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 stable@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B7F7880006
X-Stat-Signature: 93su1o9dmcnm3a1y8h3syifgcnstp5ap
X-HE-Tag: 1777372185-864884
X-HE-Meta: U2FsdGVkX1+QZUX5AIixPXlf8VEG7R5KqEbLXZ+qY4NQfBwdsmaZKT28s6mDjETDWegm7h+dyLYTHcynWsmyMXc/A2r6/q7PHfdVNwz8mc2UyeA7R0KrbpOoT48vHdKodXiHsnAfPrfjMwkvjmCoP6uUW7FrJ57Q5C6pNPUXNZke+2VpUZaUONQPSiW+oebe9q8QeCLX5Jw7ekf+c0Kaysu8Mlg6yoDTOcyZqsb2PZ5KU8oik4Na/l/TExwFWEYk6VC+LsvODUTY0oK7qbLF2zD4u716Tx4NAW5R3acdKPbzxOOEdQY9CM4eLTUV2liICVwjwNnvKKG5umYYz659SEySOrb061DEAsPurLtIfky1PW6Cfz8WoWs6mPD/xsYFv6IsQ77JUIROw+0FKuPg59nraq1uqbjCm2baaDmBeD/WWK1kkNE//aK9/IKX8x53sT3mAkQQ86xO4QBUQvbcSan7MaX6ozeyK2HLQMQnt9M2Zcy+gzVLtSXyxJJ9iU5TN4w+6Y/zIWoKRLOzuXwShm1z5h3GwkjQXcOPi4pAihi6qUq1cVisTfB0LvTNqrBoXk/hOI3DL1Weql9AqI6fprnOEb5UBXw1sBwNWLjyGJTIWL8RgrxcUqTyr581euj0Gt8hMczgwqw2+CPxfOV1c2nNOo4/MBJEFqpr0z+fcX/VDdVkS1R2/bE6bifjfbftrJwzmMvPODFtyVhV4+5cakxSCeiQ7uYzOm/a+dxSeLK+KSn+mGVi+AZIVgR8CiXXgzoGaM6h24K4j9ehnivYQstbQxNskpoNbuOm1xmJLnd32Pq5QbPHolb2kdB4obDRyVRoLZPQNamFIQiccUQG5huprUaAdYcSPQK/nnZhDMPF+fXYePC0NRIq2L8RGy5Nm4VY1KnjW19v3asGi+M7UtS4VjN3canrX/X4lCeXdk9P+3W4UDxCDh2lC1jdDE1woizZ+j0XwtFVixzjQ2a
 R5iuqGvA
 74fGevjUZt231ltbqh44rTIv2vA7n6/5D7KC+FB0UHJSOnWT3CKL6smCEp9LO0Z6IhnZ93jObddKB7lWVKtFR8RGy37Hy57enaEhuGovUpG28/cPUMXEFlzGUKgLiS5Fh15tTOvPtsa/m0aUkjNCcG8/a4368r9/hrVr0S0rOTQXaddAqakqLwr6HWnC+Pv4KNbGZup+8wsj29L9PZepP8CQ4jMwF6nezHR77quMNVZT4UUL6EmXDtzSRiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In commit bf9e4e30f353 ("x86/mm: use pagetable_free()"), we switched
from freeing non-boot page tables through __free_pages() to
pagetable_free().

However, the function is also called to free vmemmap pages.

Given that vmemmap pages are not page tables, already the page_ptdesc(page)
is wrong. But worse, pagetable_free() calls

	__free_pages(page, compound_order(page));

As vmemmap pages are not compound pages (see vmemmap_alloc_block()) --
except for HVO, which doesn't apply here -- we will only free the first
page when freeing a PMD-sized vmemmap page, leaking the other ones.

Fix it by properly decoupling pagetable and vmemmap freeing.
free_pagetable() no longer has to mess with SECTION_INFO, as only the
vmemmap is marked like that in register_page_bootmem_memmap().

While at it, just wire up the altmap parameter for remove_pte_table().
Also, the indentation in remove_pmd_table() is messed up, let's fix that
while touching it.

Note that we'll try to get rid of that bootmem info handling soon. For
now, we'll handle it similar to free_pagetable(), just avoiding the
ifdef.

Fixes: bf9e4e30f353 ("x86/mm: use pagetable_free()")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
Reproduced and tested with a simple VM with a virtio-mem device,
repeatedly adding and removing memory.

Found by code inspection while working on bootmem_info removal.
---
 arch/x86/mm/init_64.c | 43 +++++++++++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 16 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index df2261fa4f98..8d03e44a7fb9 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1014,7 +1014,7 @@ static void __meminit free_pagetable(struct page *page, int order)
 #ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
 		enum bootmem_type type = bootmem_type(page);
 
-		if (type == SECTION_INFO || type == MIX_SECTION_INFO) {
+		if (type == MIX_SECTION_INFO) {
 			while (nr_pages--)
 				put_page_bootmem(page++);
 		} else {
@@ -1028,13 +1028,24 @@ static void __meminit free_pagetable(struct page *page, int order)
 	}
 }
 
-static void __meminit free_hugepage_table(struct page *page,
+static void __meminit free_vmemmap_pages(struct page *page, unsigned int order,
 		struct vmem_altmap *altmap)
 {
-	if (altmap)
-		vmem_altmap_free(altmap, PMD_SIZE / PAGE_SIZE);
-	else
-		free_pagetable(page, get_order(PMD_SIZE));
+	if (altmap) {
+		vmem_altmap_free(altmap, 1u << order);
+	} else if (PageReserved(page)) {
+		unsigned long nr_pages = 1 << order;
+
+		if (IS_ENABLED(CONFIG_HAVE_BOOTMEM_INFO_NODE) &&
+		    bootmem_type(page) == SECTION_INFO) {
+			while (nr_pages--)
+				put_page_bootmem(page++);
+		} else {
+			free_reserved_pages(page, nr_pages);
+		}
+	} else {
+		__free_pages(page, order);
+	}
 }
 
 static void __meminit free_pte_table(pte_t *pte_start, pmd_t *pmd)
@@ -1093,7 +1104,7 @@ static void __meminit free_pud_table(pud_t *pud_start, p4d_t *p4d)
 
 static void __meminit
 remove_pte_table(pte_t *pte_start, unsigned long addr, unsigned long end,
-		 bool direct)
+		 bool direct, struct vmem_altmap *altmap)
 {
 	unsigned long next, pages = 0;
 	pte_t *pte;
@@ -1118,7 +1129,7 @@ remove_pte_table(pte_t *pte_start, unsigned long addr, unsigned long end,
 			return;
 
 		if (!direct)
-			free_pagetable(pte_page(*pte), 0);
+			free_vmemmap_pages(pte_page(*pte), 0, altmap);
 
 		spin_lock(&init_mm.page_table_lock);
 		pte_clear(&init_mm, addr, pte);
@@ -1153,25 +1164,25 @@ remove_pmd_table(pmd_t *pmd_start, unsigned long addr, unsigned long end,
 			if (IS_ALIGNED(addr, PMD_SIZE) &&
 			    IS_ALIGNED(next, PMD_SIZE)) {
 				if (!direct)
-					free_hugepage_table(pmd_page(*pmd),
-							    altmap);
+					free_vmemmap_pages(pmd_page(*pmd),
+							   PMD_ORDER, altmap);
 
 				spin_lock(&init_mm.page_table_lock);
 				pmd_clear(pmd);
 				spin_unlock(&init_mm.page_table_lock);
 				pages++;
 			} else if (vmemmap_pmd_is_unused(addr, next)) {
-					free_hugepage_table(pmd_page(*pmd),
-							    altmap);
-					spin_lock(&init_mm.page_table_lock);
-					pmd_clear(pmd);
-					spin_unlock(&init_mm.page_table_lock);
+				free_vmemmap_pages(pmd_page(*pmd), PMD_ORDER,
+						   altmap);
+				spin_lock(&init_mm.page_table_lock);
+				pmd_clear(pmd);
+				spin_unlock(&init_mm.page_table_lock);
 			}
 			continue;
 		}
 
 		pte_base = (pte_t *)pmd_page_vaddr(*pmd);
-		remove_pte_table(pte_base, addr, next, direct);
+		remove_pte_table(pte_base, addr, next, direct, altmap);
 		free_pte_table(pte_base, pmd);
 	}
 

---

base-commit: a2ddbfd1af0f54ea84bf17f0400088815d012e8d

change-id: 20260428-vmemmap-ab4b949aa727

--

Cheers,

David


