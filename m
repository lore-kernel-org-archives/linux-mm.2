Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B101EFF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 10:49:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14B7E6B0088; Wed, 29 Apr 2026 06:49:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 122EB6B008A; Wed, 29 Apr 2026 06:49:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0604D6B008C; Wed, 29 Apr 2026 06:49:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EAC536B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 06:49:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 93BACC02BF
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:49:33 +0000 (UTC)
X-FDA: 84711272226.08.FA2F272
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id EE3F710000A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:49:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rFmF27x7;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777459771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=N6DO1dmsgdl8b12EUoAxLURcpLBp3SEtzo9mqVGMBpI=;
	b=g9y6oDvqqLW4HNOoaYBoc8xGH/xf9z7XkU99TCxD68WUqLh/WMXxDI/dj5SZ9HU2b7T8F1
	N3pJzfoGAJBuL5TAjG/vNSbPfmIphdy5zaPmvThHRYMxQSMnaS0mOpmHAEV4Zpb+hp1T9C
	0bYfG7MEaJwKkXUC6nsAuZJF4otrItI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777459772; a=rsa-sha256;
	cv=none;
	b=T0kG36sf+Pf1mxMYXZEWTMrFwlRAvHs7BTPW/sXXneCNDEkdrWKTweG99HlRKen/BA/i1K
	zKID0SyAIE7bE+gh/n/sOVk18Kf5EcBpc8WFZnFAhmDKOc3X/pBatCpW2NIs3qgXE0hMWq
	lrfNc87N0EPy5NHHt9EwLcyTNXdsw1I=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rFmF27x7;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 559EA60018;
	Wed, 29 Apr 2026 10:49:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC90C19425;
	Wed, 29 Apr 2026 10:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777459771;
	bh=h8G3pe9wHkpOMl4+ZrKm3m0KxKNxszJCj/MtOcTz15k=;
	h=From:Date:Subject:To:Cc:From;
	b=rFmF27x7gDAney4JA5fUB+9J0z52q/EvgPWwvwRutTckYq/usYVkrX7JnD3qM46A0
	 DRdhZbTpJLOByaVxsiQ4lseeu54JB3LLecnHvugft3f1WeXvbq7eSuaefeCTQgo8Ik
	 HF/8chDDdXlZureCW1LNPvboxX3txMcAQDYY58pecYe0htuSzmUJi1zIHpjDFC0C0i
	 NbYqcoIVMXZn2w062GZEIP+WxsQ8XyYtdDhZyasFAL+2pwUsRRxV3j828eA4yk2Lk9
	 HaXvm++fI8piOcHev3CfYcm/qtwwLNkis5Vt2YxMk1rtO/m4+eAFZM9ahdDvvpPfdP
	 uJ+sufPMeOPtA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 29 Apr 2026 12:49:14 +0200
Subject: [PATCH v2] x86/mm: fix freeing of PMD-sized vmemmap pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260429-vmemmap-v2-1-8dfcacffd877@kernel.org>
X-B4-Tracking: v=1; b=H4sIACni8WkC/2XMQQ7CIBCF4as0sxYDE9JaV96j6WJox5Yo0IAhm
 oa7i926/F9evh0SR8sJrs0OkbNNNvgaeGpgWskvLOxcG1BiKzVeRHbsHG2CjDa97ok67KC+t8h
 3+z6kYay92vQK8XPAWf3WfyMroYRBIsXtbHCStwdHz89ziAuMpZQv+JYdCJ8AAAA=
To: Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Lu Baolu <baolu.lu@linux.intel.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Lu Baolu <baolu.lu@linux.intel.com>, Lance Yang <lance.yang@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 stable@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EE3F710000A
X-Stat-Signature: zcrkc48y4tey58q9qn5mxw3nims4o3tw
X-Rspam-User: 
X-HE-Tag: 1777459771-195465
X-HE-Meta: U2FsdGVkX19CjzxOdKSvU09kJdv8w/hdcHNJGNUCkq8Lgdnxi1kGHuHsN1WanSQqvk9z/t+Gsj8otVEA5+2EKe0mABqODBTEsPLYiZA4BSXspLVDQhOmTP/bAYMMlsWrCDsQvOMIc4iO+thDAa9e2OQzpEf7nAdFg1RFi6ne4F+QlUAvBeYeS54yU0Y5SypqPjtXDDzG8bUKJUdclCg1vFo0/jRhRcdhTDzyOCQHFZ5q0IRrKQZ6Z/JYxxkwwy7AEPm93SXcVLWOsfPb+D2+KFltQExEztK3x3qHECXSRFiBHJT1PMtvhKp9jHXuFF7tHuBiEA2WESBmlT5nARod2xc4FHZPtNwiIyD62XMD0E3pBEcs9dhqoxxd7IjVgfNEu0DFOcF3hFjmRlg5loyECVzoU1TLsebtbdCSt+gV8/DgdLRxYrjWfptY/mMF8Rsrm0ZfIGTwtdvy2ojbrUbjhJjUPc8KY4E98+Erwj9u8NxSOUFzjoBmNnSDhGBdqZ5dvTXZogU6bjrPOkQy3snc/qDtJopefccleii57S3xA/eTONV9MvuaAwtRvfa7AXAkygziFOWXZq/0FXfrz8rFH9HQ4wyLmsE8jXrK4Dh5PNza/yLVx4Yrlw9cOsyN3nRFKiOzyR+lnHq3VvM9piOunzmTX9JkheFkJ69bAXXn+roShSFi06TK84Pgzi0Uquvna9El+Y4yaG/9uxhEPA+T7ORV/DiEy+dFU4OwO4Srbk0rf+EditFWl5O+z71n9CXxT56ZOgZ6kN8tSr7OOq6NSqf9xfGF10eUsN4ouxO9z0mxfA7xg6qtyDPmMUx66SM+D329ll39rcJjvmXcwtzaT6MUhTMjjFTVTWcZcF2g7Be86orWAT2K9C1SOwncwLV2Oxha6pAi7dJnUMBCFqWrwRsMivu7Dl3xpldFDRNRwmLmRQQ6kd3Kob1mtO4W3/IhaN16kcGF6vuWFzCe8A6
 ytH96OjY
 YuRNY7of12SS2FgkSw/nhUKBSQfToZOQ3XC8Sb/C9/XVdgTXRCpY9+OhuaJV/KSG1DskBH1DuaUD8vN+UIO5CaUxYSNGG9VxZP14Xr5NdP1TIsurRkH+hOqrTkQBDpp3d149J6nAhne5pRarjdzIhKsE1zwmyE5njt30m9L45kIyqiazv7x4cWgTw+SdzBdWeTeJoJToSqKjF+jlMyi+PzdcZ/ZPnA6cvcx/MKgVMR1xk1ZTp/VJCQ0OYyA==
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

The indentation in remove_pmd_table() is messed up, let's fix that
while touching it.

Note that we'll try to get rid of that bootmem info handling soon. For
now, we'll handle it similar to free_pagetable(), just avoiding the
ifdef.

Tested-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Fixes: bf9e4e30f353 ("x86/mm: use pagetable_free()")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
Reproduced and tested with a simple VM with a virtio-mem device,
repeatedly adding and removing memory.

Found by code inspection while working on bootmem_info removal.
---
Changes in v2:
- Don't mess with the altmap with PTEs and add a comment why.
- Simplify "unsigned long nr_pages" handling.
- Link to v1: https://lore.kernel.org/r/20260428-vmemmap-v1-1-b2aa1e6db2c0@kernel.org
---
 arch/x86/mm/init_64.c | 40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index df2261fa4f98..7e20b22d658b 100644
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
+	unsigned long nr_pages = 1u << order;
+
+	if (altmap) {
+		vmem_altmap_free(altmap, nr_pages);
+	} else if (PageReserved(page)) {
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
@@ -1118,7 +1129,8 @@ remove_pte_table(pte_t *pte_start, unsigned long addr, unsigned long end,
 			return;
 
 		if (!direct)
-			free_pagetable(pte_page(*pte), 0);
+			/* We never populate base pages from the altmap. */
+			free_vmemmap_pages(pte_page(*pte), 0, NULL);
 
 		spin_lock(&init_mm.page_table_lock);
 		pte_clear(&init_mm, addr, pte);
@@ -1153,19 +1165,19 @@ remove_pmd_table(pmd_t *pmd_start, unsigned long addr, unsigned long end,
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

---

base-commit: a2ddbfd1af0f54ea84bf17f0400088815d012e8d

change-id: 20260428-vmemmap-ab4b949aa727

--

Cheers,

David


