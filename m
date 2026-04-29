Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 178F1FF885A
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 02:30:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64D706B00A8; Tue, 28 Apr 2026 22:30:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D6296B00A9; Tue, 28 Apr 2026 22:30:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49DC06B00AB; Tue, 28 Apr 2026 22:30:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 35A746B00A8
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 22:30:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BC00A1405FC
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 02:30:31 +0000 (UTC)
X-FDA: 84710014662.09.787DB59
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf10.hostedemail.com (Postfix) with ESMTP id 050AFC0002
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 02:30:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=REKOUE9E;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777429830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MWZbALr0HrmNzgjYbWhwVubSzNlQAWhMuIrGVyyObI4=;
	b=ZWje+7m2b/ot6riTS6qj4sB/dgjq8QCZZryZ10kSIN+qi2Q2YYAZSyZNi5FTSvptbFYYPt
	8nv7Cn5jCYYPVwD8E2fl8pRt8mvHC/bFTEoPk+vYeAncHtutsICG3Q9HYAT6S4u82cI2NK
	lSg032n4QJtZFRMIsaSAcbClGJohKIc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777429830; a=rsa-sha256;
	cv=none;
	b=UTwZOgRmKcZJFooPnq5z51iYhFrkk5Hwitvmji3jfwfUuMGJHyuVAgCADl1uOO1+eXmjzy
	t1SOXnJI+NeTMOcqjqT+b6V5cLlRPTSoG+kahxRZgobZdgCP7H0DoHNqS5RtVoz3EmhLEk
	hLiRkWhuyypX45RVb25LKcWy7/92P3Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=REKOUE9E;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777429828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MWZbALr0HrmNzgjYbWhwVubSzNlQAWhMuIrGVyyObI4=;
	b=REKOUE9Et33cUnFrVRGJb+pgigmxP0NXNeSwlsNnbMPEvV6Rmc+K3EFV3uRu40p1SlfyWr
	ZaTkwkajaXWhwKm3W+31KKI86oCsxH9QvCRd6u7mc1enKJJErIY2BWEn/gJZCRChIlcApj
	VOl/40KvzGVSnzeGMwaN+yCewfVCkxM=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	rppt@kernel.org,
	jgg@ziepe.ca,
	baolu.lu@linux.intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] x86/mm: fix freeing of PMD-sized vmemmap pages
Date: Wed, 29 Apr 2026 10:30:08 +0800
Message-Id: <20260429023008.61378-1-lance.yang@linux.dev>
In-Reply-To: <20260429021224.39916-1-lance.yang@linux.dev>
References: <20260429021224.39916-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 050AFC0002
X-Stat-Signature: yx9qfjcp98n1diyaabfumxzfgyadzzua
X-Rspam-User: 
X-HE-Tag: 1777429829-405281
X-HE-Meta: U2FsdGVkX1+hOflAA/6h0e9Wwdqolq2gnJb1SSxJMonfxhfLckfSHIINXuWoB8ne48n8d51tQrqV8z3fo78xr1qwyebE7y8zPlTTpt+gHwItJoKBuT0UrBrMoKuUHZBHAxakd1SdhD1FVl5/gfGr2i0jwZpDEWi7RyLYnFWk+eRRpIO9bIK20fJvLJWd45Bw0/9ykdgkVhoTKiJpCxEseZX7sK1kGdx8nob5XUtep3y981V2XcYEJlBGptRzaOf7RTZWbd9Eqe52oK7HfEne8nXHNpzDGIc8ohoJnOWz1yDu6F/+wzToWby+MCoueHXVwX3YfC8VzvqR10QUY39FLAVMPNpXeZEHKKt/hruaxQpbsh8fXH0EAATGXNQACq9/xxSJWSbSa2hpCQ7cUbgp9od4QfXi1Zr23gws/V4iPG5+Di9v1duxomcaNMg33QlGA6TeamcFU/ZL8mBKVdwpEknouiWoTVBrAoGdp7qxcnENGPMtK4jkLX0V0OkbcQXXNyM0HltaVVGFVL+gU8MKN/vRxIoEYFWOwU01HXl9pCZ7njb5fVprCvNAQxCaeZ6gI7d/WJ+a7Go1IuJ6zZ4R+Pfi/ROZ4afOT3IMnfffTfUYz0DYUh08opnxqaKWiAjdqwYefPOLh8DeQ4sStxqOvoCaTIxM136dH/6zwQpgeG9iSGZtYGReWcwkeI34t52NtS2ze6AogNf3OBW1ViBLzlvl5C/Lm98wDY4c3Lt/86CX39PvlzLPXCr3KAtVnj/vOVz5zqXTGhk8jDYRXIo/o+5JSNF6OTwJPcMhsIL5Au4DYsCdsEpGVySDcFUCw8DbaHvgf2Bg9xrN9eDD+sILokcRKrG7Mrz9DlmNqN/6hEn5eHQeaiEzEGpqfXd88EK/qUSgrYqHH3u22INmjk01WBNupn9fg2YMmDb0mlnPgm2/Nwx81tKaU7bBNPOKGBBuqJmS9S2ux7kOwhYNlrE
 TFmyblpm
 vY1+kUd7pIEQYOdmvFHGM7irVL2hviYAffYyQtopa6nQgbD0vDoLbQLJ196qX6cr50itKk9sDjiHCOwCBEZTqQMve6F1XOU11kSZm47vwCYtCidNxiE9AL3H/7uwOMrV1DL+GIRCerN4U6IF6PEI5+ZHcL+jR/IUNyBIQEBGG3KolJ+aAwyGYdPpoQdyeW8BvLdGjK2IzheUk5OK88LtZgU4v6kUZq4C5kc3hwoX5l2YF0do=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Apr 29, 2026 at 10:12:24AM +0800, Lance Yang wrote:
>
>On Tue, Apr 28, 2026 at 12:29:36PM +0200, David Hildenbrand (Arm) wrote:
>>In commit bf9e4e30f353 ("x86/mm: use pagetable_free()"), we switched
>>from freeing non-boot page tables through __free_pages() to
>>pagetable_free().
>>
>>However, the function is also called to free vmemmap pages.
>>
>>Given that vmemmap pages are not page tables, already the page_ptdesc(page)
>>is wrong. But worse, pagetable_free() calls
>>
>>	__free_pages(page, compound_order(page));
>>
>>As vmemmap pages are not compound pages (see vmemmap_alloc_block()) --
>>except for HVO, which doesn't apply here -- we will only free the first
>>page when freeing a PMD-sized vmemmap page, leaking the other ones.
>>
>>Fix it by properly decoupling pagetable and vmemmap freeing.
>>free_pagetable() no longer has to mess with SECTION_INFO, as only the
>>vmemmap is marked like that in register_page_bootmem_memmap().
>>
>>While at it, just wire up the altmap parameter for remove_pte_table().
>>Also, the indentation in remove_pmd_table() is messed up, let's fix that
>>while touching it.
>
>One thing I'm not sure about is passing altmap down into
>remove_pte_table().
>
>Do we actually know that a non-NULL altmap means that the vmemmap
>backing page came from that altmap?
>
>On x86 we still have in vmemmap_populate():
>
>	if (end - start < PAGES_PER_SECTION * sizeof(struct page))
>		err = vmemmap_populate_basepages(start, end, node, NULL);
>
>So for smaller-than-section vmemmap ranges, even if the caller has an
>altmap, the backing pages are allocated from normal memory. But with
>this fix the PTE removal path would now call vmem_altmap_free() just
>because altmap is non-NULL, and would not free the actual backing page,
>IIUC :)
>
>Maybe free_vmemmap_pages() should first check that the backing page is
>really inside the altmap range before using vmem_altmap_free()?
>
>Hopefully I didn't miss anything :)

I played a bit with the following on top of this fix (untested):

---8<---
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 8d03e44a7fb9..9a52f9424a07 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1028,14 +1028,33 @@ static void __meminit free_pagetable(struct page *page, int order)
 	}
 }

+static bool __meminit vmemmap_page_is_altmap(struct page *page,
+		unsigned long nr_pages, struct vmem_altmap *altmap)
+{
+	unsigned long pfn = page_to_pfn(page);
+	unsigned long start_pfn;
+	unsigned long end_pfn;
+
+	if (!altmap)
+		return false;
+
+	start_pfn = altmap->base_pfn + altmap->reserve;
+	end_pfn = altmap->base_pfn + vmem_altmap_offset(altmap);
+
+	if (pfn < start_pfn || pfn >= end_pfn)
+		return false;
+
+	return nr_pages <= end_pfn - pfn;
+}
+
 static void __meminit free_vmemmap_pages(struct page *page, unsigned int order,
 		struct vmem_altmap *altmap)
 {
-	if (altmap) {
-		vmem_altmap_free(altmap, 1u << order);
-	} else if (PageReserved(page)) {
-		unsigned long nr_pages = 1 << order;
+	unsigned long nr_pages = 1 << order;

+	if (vmemmap_page_is_altmap(page, nr_pages, altmap)) {
+		vmem_altmap_free(altmap, nr_pages);
+	} else if (PageReserved(page)) {
 		if (IS_ENABLED(CONFIG_HAVE_BOOTMEM_INFO_NODE) &&
 		    bootmem_type(page) == SECTION_INFO) {
 			while (nr_pages--)
--

Thanks,
Lance

>Thanks,
>Lance
>
>>Note that we'll try to get rid of that bootmem info handling soon. For
>>now, we'll handle it similar to free_pagetable(), just avoiding the
>>ifdef.
>>
>>Fixes: bf9e4e30f353 ("x86/mm: use pagetable_free()")
>>Cc: stable@vger.kernel.org
>>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>>---
>>Reproduced and tested with a simple VM with a virtio-mem device,
>>repeatedly adding and removing memory.
>>
>>Found by code inspection while working on bootmem_info removal.
>>---
>> arch/x86/mm/init_64.c | 43 +++++++++++++++++++++++++++----------------
>> 1 file changed, 27 insertions(+), 16 deletions(-)
>>
>>diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
>>index df2261fa4f98..8d03e44a7fb9 100644
>>--- a/arch/x86/mm/init_64.c
>>+++ b/arch/x86/mm/init_64.c
>>@@ -1014,7 +1014,7 @@ static void __meminit free_pagetable(struct page *page, int order)
>> #ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
>> 		enum bootmem_type type = bootmem_type(page);
>> 
>>-		if (type == SECTION_INFO || type == MIX_SECTION_INFO) {
>>+		if (type == MIX_SECTION_INFO) {
>> 			while (nr_pages--)
>> 				put_page_bootmem(page++);
>> 		} else {
>>@@ -1028,13 +1028,24 @@ static void __meminit free_pagetable(struct page *page, int order)
>> 	}
>> }
>> 
>>-static void __meminit free_hugepage_table(struct page *page,
>>+static void __meminit free_vmemmap_pages(struct page *page, unsigned int order,
>> 		struct vmem_altmap *altmap)
>> {
>>-	if (altmap)
>>-		vmem_altmap_free(altmap, PMD_SIZE / PAGE_SIZE);
>>-	else
>>-		free_pagetable(page, get_order(PMD_SIZE));
>>+	if (altmap) {
>>+		vmem_altmap_free(altmap, 1u << order);
>>+	} else if (PageReserved(page)) {
>>+		unsigned long nr_pages = 1 << order;
>>+
>>+		if (IS_ENABLED(CONFIG_HAVE_BOOTMEM_INFO_NODE) &&
>>+		    bootmem_type(page) == SECTION_INFO) {
>>+			while (nr_pages--)
>>+				put_page_bootmem(page++);
>>+		} else {
>>+			free_reserved_pages(page, nr_pages);
>>+		}
>>+	} else {
>>+		__free_pages(page, order);
>>+	}
>> }
>> 
>> static void __meminit free_pte_table(pte_t *pte_start, pmd_t *pmd)
>>@@ -1093,7 +1104,7 @@ static void __meminit free_pud_table(pud_t *pud_start, p4d_t *p4d)
>> 
>> static void __meminit
>> remove_pte_table(pte_t *pte_start, unsigned long addr, unsigned long end,
>>-		 bool direct)
>>+		 bool direct, struct vmem_altmap *altmap)
>> {
>> 	unsigned long next, pages = 0;
>> 	pte_t *pte;
>>@@ -1118,7 +1129,7 @@ remove_pte_table(pte_t *pte_start, unsigned long addr, unsigned long end,
>> 			return;
>> 
>> 		if (!direct)
>>-			free_pagetable(pte_page(*pte), 0);
>>+			free_vmemmap_pages(pte_page(*pte), 0, altmap);
>> 
>> 		spin_lock(&init_mm.page_table_lock);
>> 		pte_clear(&init_mm, addr, pte);
>>@@ -1153,25 +1164,25 @@ remove_pmd_table(pmd_t *pmd_start, unsigned long addr, unsigned long end,
>> 			if (IS_ALIGNED(addr, PMD_SIZE) &&
>> 			    IS_ALIGNED(next, PMD_SIZE)) {
>> 				if (!direct)
>>-					free_hugepage_table(pmd_page(*pmd),
>>-							    altmap);
>>+					free_vmemmap_pages(pmd_page(*pmd),
>>+							   PMD_ORDER, altmap);
>> 
>> 				spin_lock(&init_mm.page_table_lock);
>> 				pmd_clear(pmd);
>> 				spin_unlock(&init_mm.page_table_lock);
>> 				pages++;
>> 			} else if (vmemmap_pmd_is_unused(addr, next)) {
>>-					free_hugepage_table(pmd_page(*pmd),
>>-							    altmap);
>>-					spin_lock(&init_mm.page_table_lock);
>>-					pmd_clear(pmd);
>>-					spin_unlock(&init_mm.page_table_lock);
>>+				free_vmemmap_pages(pmd_page(*pmd), PMD_ORDER,
>>+						   altmap);
>>+				spin_lock(&init_mm.page_table_lock);
>>+				pmd_clear(pmd);
>>+				spin_unlock(&init_mm.page_table_lock);
>> 			}
>> 			continue;
>> 		}
>> 
>> 		pte_base = (pte_t *)pmd_page_vaddr(*pmd);
>>-		remove_pte_table(pte_base, addr, next, direct);
>>+		remove_pte_table(pte_base, addr, next, direct, altmap);
>> 		free_pte_table(pte_base, pmd);
>> 	}
>> 
>>
>>---
>>
>>base-commit: a2ddbfd1af0f54ea84bf17f0400088815d012e8d
>>
>>change-id: 20260428-vmemmap-ab4b949aa727
>>
>>--
>>
>>Cheers,
>>
>>David
>>
>>
>

