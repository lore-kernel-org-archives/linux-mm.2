Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D946ACD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 09:45:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E6AA6B0096; Wed,  6 May 2026 05:45:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BECB6B0098; Wed,  6 May 2026 05:45:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ACD76B0099; Wed,  6 May 2026 05:45:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 29B726B0096
	for <linux-mm@kvack.org>; Wed,  6 May 2026 05:45:48 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CA2A81C0472
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:45:47 +0000 (UTC)
X-FDA: 84736513134.02.CEC379E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id E1BFE160009
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:45:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="r+/L8vrE";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778060746; a=rsa-sha256;
	cv=none;
	b=nPvNgjVze9ImHR8x5SBpqxl+jNjeZKS6GTxwUDl+wiNrPpkHx023FDy0Qs4Pw1EDsdg0gr
	KLUkDqWqiLSd0t/EkdOLE1jNWUVJERb1a9yEwbBbKSImYhGad1a7CX2biiKEcw8NVUn5Du
	8b75yR0+wwfagL12BDseaNOjrDrRKYY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="r+/L8vrE";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778060746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JAgupUWMfoUkWyRZp2rVkXSB+4GDQ02/tvEGvl5k5sg=;
	b=UjOi14WF5lCvAbmpvXHC3n/WkCAirnhNSM1G/6sUb78iHiar5kI4Fi2CGgbVdGjPg2oayw
	ldKCpgx4mej/Vdq+N3HVTfZjWFZfge44sbSLE2UVeBQtztipBSvX53lnrSRVcP4OOMq9Ur
	7ZEHoyhA0KuamKAxIZ7IFICj4bPqAf4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B9C2F3329;
	Wed,  6 May 2026 02:45:39 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 355D83F7B4;
	Wed,  6 May 2026 02:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778060745; bh=TgsTpV/bcO+FmT0UvEQFj412qUVt308dB660+E17P00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r+/L8vrEHn/1F/vwRcuyKDKQJlFYHpU5Ip69XeTy0cvNbAnTAqrtpkZ2P+ec7eyBB
	 xEqRYAvJVfA16M+ubFN1mjpDCZx9ZgzeqGCly8j7kSMrTZP1YYI+VSOP4x7p/yytHg
	 SO+z6IyGoi+kz3BGbv40e3RF9xVNOuceSTi0oB1w=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v3 3/9] mm/rmap: refactor some code around lazyfree folio unmapping
Date: Wed,  6 May 2026 15:14:58 +0530
Message-Id: <20260506094504.2588857-4-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260506094504.2588857-1-dev.jain@arm.com>
References: <20260506094504.2588857-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oxf6cgqtj59pejfdrtepdbbnnw5yg1yr
X-Rspam-User: 
X-Rspamd-Queue-Id: E1BFE160009
X-Rspamd-Server: rspam07
X-HE-Tag: 1778060745-264644
X-HE-Meta: U2FsdGVkX18sJl4YevjVQ0DuwXXFU8/4d1+buOau7l6JgNkJ4Jrywb7NAZnVFfEE/NRysOSp29k2braiRNVUFc9+D7Ah2/OcIXywqZyyurc4L5/P7OYNJpsGF2fbmFwaPhRkSLYs/LuTJiNOnfvYFCiVD4YFvW7zkhEU1RKUcnTJJZYIRgNvwV5/qVMWXpd4cc7/1d2raGol+qON9VTPMrWDSZ6CnObec5yyOg4x7JRGSTGDuJLIglHMUOC4AOD/35fBPsu11ZeBroZsbq2VSRz6nlK8tk0j0PWT+qU+iIuCeeZUbRbZ0zRkj65IWhoZVK5/i3+1dpxVA/YWLnC5Sp/aJ/isBw90XkQtCGlwYHEsZCJS/63iWFTXdtsZ4kSWBCmMKppyG6jMmhLkXo+mq48DfzYlWKodCqoYrTLeHpU1HwQdHNcELbddRGIV2XEqSkbSXQwgPFErMZxH1gQDWHM5krHywzcz+WEoI9wrDiu6akdA4oMENp4qH0/WWK5emuU5eRX3qmmTDsX7IfixUxmvKHT+j/2yQbSBXGQWwaBCdW5C72aIQwR5RDG7DDym1nkMo1wiSlPRBhxcfmFC4LyM1S+7VD2BwQt7hk1n6ZcugEupq6uOB8NJa1j8G8zWTxwkojIFZ2Bn2sYtKe50aMAZA9c8wCInRkqwLknpVqCEBHQHHupaSNdhhQ3jgEGfKyNCAoS7h7blDjrUUfEZLchBSPCYoXwCKzM0sNlh0wcbShkkJYJgj7QCjm7Z5xqo/CL9hcazjtqXes4WlKOZoChxk3zhgMQ37zNdA+vh12ATeXuz88JvXw2bsiN/vQjIwIrSFahKf/tOOT11AO9h/2lvVFJXpiaVZK9BYuLWNiyw+ucG0nv2tKOo0iYn6/AiqyZr4LGwBYFQQrXQjAr7iV7x4By73B1IY1g9URfGZmDYJMK4ZRanixhCyFbnlsN+ZjsBqgoeQn7gL+2toFB
 eyKrcTQe
 cRBqPdHW8ZqndQQySZVqSnd/cruG9eo2/tegm6peDyDSnsQJ6Wb56zaM6OfhqBVp8c9X0nsz/JLeC3hwEStxhr0f4WaPQL0zNMpkQMTrW2TnH8IBZg/4utLr94mGZNrCNNbW5v2vStU7KOwyNsHcHpT5caw1LMGNxk86FRPKaR4TxNqDoB+SWiJ+wbPtIiLBTMIaL9TRoyPd8gSv4OKhNFiszm44FOQKvrXjK5VXd5jGrI8zVgPBUc6xs2A2shg1KI3neYOTmfpsRaswhXSXkYDAFvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For lazyfree folio unmapping, after clearing the ptes we must abort the
operation if the folio got dirtied or it has unexpected references.

Refactor this logic into a function which will return whether we need
to abort or not.

If we abort, we restore the ptes and bail out of try_to_unmap_one.
Otherwise adjust the rss stats of the mm and jump to a label.

Also rename that label from "discard" to "finish_unmap"; the former
is appropriate in the lazyfree context, but the code following the label
is executed for other successful unmap code paths too, so 'discard' does
not sound correct for them.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 95 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 55 insertions(+), 40 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index a98acdea0530a..bd4e3639e26ed 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1978,6 +1978,56 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
 }
 
+static inline bool can_unmap_lazyfree_folio_range(struct vm_area_struct *vma,
+		struct folio *folio, unsigned long address, pte_t *ptep,
+		pte_t pteval, unsigned long nr_pages)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	int ref_count, map_count;
+
+	/*
+	 * Synchronize with gup_pte_range():
+	 * - clear PTE; barrier; read refcount
+	 * - inc refcount; barrier; read PTE
+	 */
+	smp_mb();
+
+	ref_count = folio_ref_count(folio);
+	map_count = folio_mapcount(folio);
+
+	/*
+	 * Order reads for page refcount and dirty flag
+	 * (see comments in __remove_mapping()).
+	 */
+	smp_rmb();
+
+	if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
+		/*
+		 * redirtied either using the page table or a previously
+		 * obtained GUP reference.
+		 */
+		set_ptes(mm, address, ptep, pteval, nr_pages);
+		folio_set_swapbacked(folio);
+		return false;
+	}
+
+	if (ref_count != 1 + map_count) {
+		/*
+		 * Additional reference. Could be a GUP reference or any
+		 * speculative reference. GUP users must mark the folio
+		 * dirty if there was a modification. This folio cannot be
+		 * reclaimed right now either way, so act just like nothing
+		 * happened.
+		 * We'll come back here later and detect if the folio was
+		 * dirtied when the additional reference is gone.
+		 */
+		set_ptes(mm, address, ptep, pteval, nr_pages);
+		return false;
+	}
+
+	return true;
+}
+
 /* Returns false if unmap needs to be aborted */
 static inline bool unmap_hugetlb_folio(struct vm_area_struct *vma,
 		struct folio *folio, struct page_vma_mapped_walk *pvmw,
@@ -2259,47 +2309,12 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 
 			/* MADV_FREE page check */
 			if (!folio_test_swapbacked(folio)) {
-				int ref_count, map_count;
-
-				/*
-				 * Synchronize with gup_pte_range():
-				 * - clear PTE; barrier; read refcount
-				 * - inc refcount; barrier; read PTE
-				 */
-				smp_mb();
-
-				ref_count = folio_ref_count(folio);
-				map_count = folio_mapcount(folio);
-
-				/*
-				 * Order reads for page refcount and dirty flag
-				 * (see comments in __remove_mapping()).
-				 */
-				smp_rmb();
-
-				if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
-					/*
-					 * redirtied either using the page table or a previously
-					 * obtained GUP reference.
-					 */
-					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
-					folio_set_swapbacked(folio);
+				if (!can_unmap_lazyfree_folio_range(vma, folio, address,
+				    pvmw.pte, pteval, nr_pages))
 					goto walk_abort;
-				} else if (ref_count != 1 + map_count) {
-					/*
-					 * Additional reference. Could be a GUP reference or any
-					 * speculative reference. GUP users must mark the folio
-					 * dirty if there was a modification. This folio cannot be
-					 * reclaimed right now either way, so act just like nothing
-					 * happened.
-					 * We'll come back here later and detect if the folio was
-					 * dirtied when the additional reference is gone.
-					 */
-					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
-					goto walk_abort;
-				}
+
 				add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
-				goto discard;
+				goto finish_unmap;
 			}
 
 			if (folio_dup_swap(folio, subpage) < 0) {
@@ -2362,7 +2377,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
 		}
-discard:
+finish_unmap:
 		if (unlikely(folio_test_hugetlb(folio))) {
 			hugetlb_remove_rmap(folio);
 		} else {
-- 
2.34.1


