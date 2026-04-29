Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B71B3FF886F
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 02:12:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71CAE6B00B1; Tue, 28 Apr 2026 22:12:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CD166B00B2; Tue, 28 Apr 2026 22:12:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 595A96B00B4; Tue, 28 Apr 2026 22:12:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 472E16B00B1
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 22:12:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BEC6FC1EF0
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 02:12:47 +0000 (UTC)
X-FDA: 84709969974.10.0FE0B3B
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id DF6161C0009
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 02:12:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ryoyxHFg;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777428766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gb86gbMzt9jqdkC6Pg+jFx+1pGimSrMPX47wwwBWIUI=;
	b=kam5//s19rw1gZPxF2dzXTdM2B6yrHzmyYzuKSZ5MWRmxzh4vkmkZ/SxSp2h0/DE4Yhh1B
	X5Ev4Hs0m2uFPaFNSyo+Ye6vk+mp2/kb7RWWm8fItUiLINZKJbooBIDqKRjVA7nEgLU7k5
	QA/cKP8fppBRf2pyVwCTK6z1Cy8HwGQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ryoyxHFg;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777428766; a=rsa-sha256;
	cv=none;
	b=KuZcPkwmByC6yfz1axx/v/Heu232sXsQyhDDh1aCl7BECtCK8IqDCYyzs8U83NxCoXx6I9
	+gfQaCd0RvZ3taItVx9Clb+5x5wrwDesB5xTRLRLXx0/mk6VERxE17jl/4YhBWUT5Iif1r
	oHdySx2p2H+Oxk8JPL34EakMz5ocgWU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777428760;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gb86gbMzt9jqdkC6Pg+jFx+1pGimSrMPX47wwwBWIUI=;
	b=ryoyxHFgF4ft/HwNv0YIZ5eyaC7WbzQMelfouaMIeTKSI1JNdp6OnjnOFqR6RymBSgWF5Z
	S49OphuCAdTDZWfvdYQuGVglYjzhMoqdkwHtppsyWKp8NJI2wEBRUAHI6pz0vAxA3kRUJU
	HfvI616NHH7lDY/x1SHogkiF8bs6BZg=
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
Date: Wed, 29 Apr 2026 10:12:24 +0800
Message-Id: <20260429021224.39916-1-lance.yang@linux.dev>
In-Reply-To: <20260428-vmemmap-v1-1-b2aa1e6db2c0@kernel.org>
References: <20260428-vmemmap-v1-1-b2aa1e6db2c0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: cbmjrahd7at7xcf3qgjrsdkjt5drhfh7
X-Rspamd-Queue-Id: DF6161C0009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777428765-172394
X-HE-Meta: U2FsdGVkX1+c+K9h+d1qDkBqh0cEEkssdk/FAvSwjm9Di6i4hiK5XCqjCnUPRB91A7icq5HRgPuZbHaP0g/F8fqBDj2ExP5vNb3hA+mS3hRhjBkWr7DdkmDkvrmWxH3gB1MbOk/wrjrOeg5dHMuE0J7edbcevb+2oCysidRkgLIxkK6r518ED9K4Mf6NHlkyIsKRogNCO84LADy51u5zTLk+oYW3HIeRQcdsBB+OybxOD/Quwwdz/Cpinsc0xUYURhCQWEd4MgVmxSNYc0e1H2q24K1i03A5wsiU+hF1/o+m3uYS618//QhFXLLqutII1Acc6eC5vOVItjdgslNaXp9nmv9ewSnLsUz/FoHRpukg4l/6fx9HVZ3En0osvsnnuWEGICscKtQupkzSTuf3q6MgNylfJLbQlKaWEswsKZ3vcUdrf+atelkN6LNams+SObfdgEpFoBKz3jAB1xQQE4yziLazE4mAJUBWEQG/UN/qiiJFMr7WgdJCFENubCCGwX1F63uK8GlSvr2xmeorCMgmzJQKpgCPMoC8onW7vvlQx0Gbe4s4wyYgmdY0JW/oECg/3g95RCXAe6BEVnITMEGLyIAJSwfNVFC80br48MffHS5VBL6AO2D2uCMAwMX3T6eHnJ9wOJxk143Pg2iL3zgb4ezoyj33zn4pISscc6KErI1gLK0ZTkAuF9zWoe2EbOw9AlN3usYB5S2xh5xOmONRXOsai6zkvA0sCKxFCSoKtHvwCdNuXxRnOO4sS1KlkEMnj5Q5ab6mpFvUcYWeYgA2icMBYNmJDu0Pe9gaWzRnC1ZQ+1JwZmxRBaBK4rk6ANtZma+0sZBcMwDtpFhxE/spSCPpjCHavkR7Wf2AfBSlDic/f7WcA4NYOr6m6PNEpI+txTzQlTWYA65CZcVZQmkJfwjoYTvV310itq3gp4db3YNUldynRKfp6x5C+Izf5mSIKkoIf2e/Hm1iF9e
 aisdggwG
 lwx2gXUyuLKmQzbaLEQHZ0OGBMB65NXXfpOXbPdxDoKCGVGatK3Lx4WuRMnGQrlG7WA3leK55n6gB6FbDrbFNOGnLKj/TJIiLG4HcHJOeWjMjKUhrY0v5Qztm3TJAG2trOpsyxFEiMjB+dolq6SIzKLFMoh+ClNESjCyO90iTGN67rTx3RaFiSlZcdmJOfU9TTMb85mw4Il51jky8repL183XHMpPQbVweOJEjAQasbJSbuE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Apr 28, 2026 at 12:29:36PM +0200, David Hildenbrand (Arm) wrote:
>In commit bf9e4e30f353 ("x86/mm: use pagetable_free()"), we switched
>from freeing non-boot page tables through __free_pages() to
>pagetable_free().
>
>However, the function is also called to free vmemmap pages.
>
>Given that vmemmap pages are not page tables, already the page_ptdesc(page)
>is wrong. But worse, pagetable_free() calls
>
>	__free_pages(page, compound_order(page));
>
>As vmemmap pages are not compound pages (see vmemmap_alloc_block()) --
>except for HVO, which doesn't apply here -- we will only free the first
>page when freeing a PMD-sized vmemmap page, leaking the other ones.
>
>Fix it by properly decoupling pagetable and vmemmap freeing.
>free_pagetable() no longer has to mess with SECTION_INFO, as only the
>vmemmap is marked like that in register_page_bootmem_memmap().
>
>While at it, just wire up the altmap parameter for remove_pte_table().
>Also, the indentation in remove_pmd_table() is messed up, let's fix that
>while touching it.

One thing I'm not sure about is passing altmap down into
remove_pte_table().

Do we actually know that a non-NULL altmap means that the vmemmap
backing page came from that altmap?

On x86 we still have in vmemmap_populate():

	if (end - start < PAGES_PER_SECTION * sizeof(struct page))
		err = vmemmap_populate_basepages(start, end, node, NULL);

So for smaller-than-section vmemmap ranges, even if the caller has an
altmap, the backing pages are allocated from normal memory. But with
this fix the PTE removal path would now call vmem_altmap_free() just
because altmap is non-NULL, and would not free the actual backing page,
IIUC :)

Maybe free_vmemmap_pages() should first check that the backing page is
really inside the altmap range before using vmem_altmap_free()?

Hopefully I didn't miss anything :)

Thanks,
Lance

>Note that we'll try to get rid of that bootmem info handling soon. For
>now, we'll handle it similar to free_pagetable(), just avoiding the
>ifdef.
>
>Fixes: bf9e4e30f353 ("x86/mm: use pagetable_free()")
>Cc: stable@vger.kernel.org
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---
>Reproduced and tested with a simple VM with a virtio-mem device,
>repeatedly adding and removing memory.
>
>Found by code inspection while working on bootmem_info removal.
>---
> arch/x86/mm/init_64.c | 43 +++++++++++++++++++++++++++----------------
> 1 file changed, 27 insertions(+), 16 deletions(-)
>
>diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
>index df2261fa4f98..8d03e44a7fb9 100644
>--- a/arch/x86/mm/init_64.c
>+++ b/arch/x86/mm/init_64.c
>@@ -1014,7 +1014,7 @@ static void __meminit free_pagetable(struct page *page, int order)
> #ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
> 		enum bootmem_type type = bootmem_type(page);
> 
>-		if (type == SECTION_INFO || type == MIX_SECTION_INFO) {
>+		if (type == MIX_SECTION_INFO) {
> 			while (nr_pages--)
> 				put_page_bootmem(page++);
> 		} else {
>@@ -1028,13 +1028,24 @@ static void __meminit free_pagetable(struct page *page, int order)
> 	}
> }
> 
>-static void __meminit free_hugepage_table(struct page *page,
>+static void __meminit free_vmemmap_pages(struct page *page, unsigned int order,
> 		struct vmem_altmap *altmap)
> {
>-	if (altmap)
>-		vmem_altmap_free(altmap, PMD_SIZE / PAGE_SIZE);
>-	else
>-		free_pagetable(page, get_order(PMD_SIZE));
>+	if (altmap) {
>+		vmem_altmap_free(altmap, 1u << order);
>+	} else if (PageReserved(page)) {
>+		unsigned long nr_pages = 1 << order;
>+
>+		if (IS_ENABLED(CONFIG_HAVE_BOOTMEM_INFO_NODE) &&
>+		    bootmem_type(page) == SECTION_INFO) {
>+			while (nr_pages--)
>+				put_page_bootmem(page++);
>+		} else {
>+			free_reserved_pages(page, nr_pages);
>+		}
>+	} else {
>+		__free_pages(page, order);
>+	}
> }
> 
> static void __meminit free_pte_table(pte_t *pte_start, pmd_t *pmd)
>@@ -1093,7 +1104,7 @@ static void __meminit free_pud_table(pud_t *pud_start, p4d_t *p4d)
> 
> static void __meminit
> remove_pte_table(pte_t *pte_start, unsigned long addr, unsigned long end,
>-		 bool direct)
>+		 bool direct, struct vmem_altmap *altmap)
> {
> 	unsigned long next, pages = 0;
> 	pte_t *pte;
>@@ -1118,7 +1129,7 @@ remove_pte_table(pte_t *pte_start, unsigned long addr, unsigned long end,
> 			return;
> 
> 		if (!direct)
>-			free_pagetable(pte_page(*pte), 0);
>+			free_vmemmap_pages(pte_page(*pte), 0, altmap);
> 
> 		spin_lock(&init_mm.page_table_lock);
> 		pte_clear(&init_mm, addr, pte);
>@@ -1153,25 +1164,25 @@ remove_pmd_table(pmd_t *pmd_start, unsigned long addr, unsigned long end,
> 			if (IS_ALIGNED(addr, PMD_SIZE) &&
> 			    IS_ALIGNED(next, PMD_SIZE)) {
> 				if (!direct)
>-					free_hugepage_table(pmd_page(*pmd),
>-							    altmap);
>+					free_vmemmap_pages(pmd_page(*pmd),
>+							   PMD_ORDER, altmap);
> 
> 				spin_lock(&init_mm.page_table_lock);
> 				pmd_clear(pmd);
> 				spin_unlock(&init_mm.page_table_lock);
> 				pages++;
> 			} else if (vmemmap_pmd_is_unused(addr, next)) {
>-					free_hugepage_table(pmd_page(*pmd),
>-							    altmap);
>-					spin_lock(&init_mm.page_table_lock);
>-					pmd_clear(pmd);
>-					spin_unlock(&init_mm.page_table_lock);
>+				free_vmemmap_pages(pmd_page(*pmd), PMD_ORDER,
>+						   altmap);
>+				spin_lock(&init_mm.page_table_lock);
>+				pmd_clear(pmd);
>+				spin_unlock(&init_mm.page_table_lock);
> 			}
> 			continue;
> 		}
> 
> 		pte_base = (pte_t *)pmd_page_vaddr(*pmd);
>-		remove_pte_table(pte_base, addr, next, direct);
>+		remove_pte_table(pte_base, addr, next, direct, altmap);
> 		free_pte_table(pte_base, pmd);
> 	}
> 
>
>---
>
>base-commit: a2ddbfd1af0f54ea84bf17f0400088815d012e8d
>
>change-id: 20260428-vmemmap-ab4b949aa727
>
>--
>
>Cheers,
>
>David
>
>

