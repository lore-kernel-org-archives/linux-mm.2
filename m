Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B8E6C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 18:23:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8543E6B00CE; Fri, 17 Jul 2026 14:23:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 829C66B00D0; Fri, 17 Jul 2026 14:23:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73FEA6B00D1; Fri, 17 Jul 2026 14:23:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3FDD36B00CE
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:23:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C1AF016020C
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:23:27 +0000 (UTC)
X-FDA: 84999091254.06.B5D1A57
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id F332A1C000A
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:23:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iZ50G7B9;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784312606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LAYYiM2rpTmaPPo2VlPYNoqH0gFENrcwglvYiZo/Bls=;
	b=2HTH1KvkEqYHvel8UlFEJsikDICoIv/3JYJEMRhvQsnIclvzBcY9wRZzFJL+llBsY/UwCC
	kiJ7tjf7qz4YZzrjYMKUJ5kXSCvxWwtE5JD0W8nsUeNHpPGYurhSD7H/KfLVUFjBOtXpd8
	EHReYRS98wyhcp2BP0K4ig8uLEChfJ4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iZ50G7B9;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784312606;
	b=gAV9KQ5B/n+f7r/3ITfMvrwOPnTD6wTBWtzdsi+oVxLnk5dnu37v5NEVx8dvd/VwkjUG9Z
	6m6xUyYdAugFWQZ+roI8E26Bmet6h9VSmxpcSWYly6XC+jdRmZ7GKyXgZEtH+0zw9OuBLP
	nN4ba5zZ//WINV2HshjhUoL5ITnn8+c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3BD054035E;
	Fri, 17 Jul 2026 18:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F6B1F00A3D;
	Fri, 17 Jul 2026 18:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784312605;
	bh=LAYYiM2rpTmaPPo2VlPYNoqH0gFENrcwglvYiZo/Bls=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iZ50G7B9X1eEJ+gjLEVKfTpi5LG2qZTmjqad3Qg4Kly7DE9FC9veVfrNbHX7mY8UC
	 3koAjIihABNFqIt/r2bxQ1SLL4TO1GVk1j9dn39GBDtf+quhPEqqWZ77guX1Ls2nsT
	 YozctpZgHRXUVZZHfCLBJi9p/6ZGu26Nmto8hBvm4AZhcRnNIwd5TAUU34CjzDuqn/
	 7W0HPy5aPvO7h6PCL3F8CK27lvT4Jgq6JB7PkiVHEF+jaK9xFpygzAsLbdo3xIV1Bf
	 dEbDUlcZxYXUdY5GdfQJhuqaYzEKWmrR2d2ZOwg+kcLFljrJ91dXHOC0flCwocph5j
	 3pY8V+ezEsFnQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 17 Jul 2026 19:19:46 +0100
Subject: [PATCH 08/15] mm: introduce and use linear_folio_page_index()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-b4-scalable-cow-virt-pgoff-v1-8-cf24910ef094@kernel.org>
References: <20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org>
In-Reply-To: <20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4022; i=ljs@kernel.org;
 h=from:subject:message-id; bh=6pAegtlPfBQ3G3CGe2dDWkuXSlF6+Udh4ZexgB7rXRw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKiivbNurLzn7vj8qY5HOe75/ZoLd3/KXmjaJgIx53Zt
 5XS/hxN6ShlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBE3ucx/LN8F3ziz3yR9Zu/
 Cv2pSqxmUuMPWvw8SOXG2ja2kMJNzPsY/sfZJlVsiDxTHHpo4e85L9z2u+wVlD3ztN6p95/s/gt
 XSpgB
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F332A1C000A
X-Stat-Signature: pb4tbmkhtdw7ymef7f33t8d6srbi7zua
X-HE-Tag: 1784312605-206403
X-HE-Meta: U2FsdGVkX1/PxwP0j5I032LxMIqwhfMmacJ1BZeDSelroMWarjWRwmlfb84ZT0AEkk329KFxKcqeMq6hq1yTGK/ZsOBTX++nG+hvRqtTRk8RfuQ/Oa90APdf9xeJz3Jon6eGaqLVhX9Ct2uc0rMdu4kCtWiLH/i8feUnVQUqdXsQwtBP/isPOTVShEuKuCoz1tsDlTvCioviO4NxIR1940M3SwY4V7N8+ryEEXlMmZ08BHzYo8ibZIV++qTuI0B/GqrbB8TP5atYEoJyK1MwwhjdFj12k/FRUaUNpBPJZlFTG1Talk5mo183fv1Vck77P1ZMfgBNqLRgui8j7heS/uY+cZE98zqOZ2188aAEse7z+ebpnxyBxAiohWJE0B0EvhYDv3077NaP2NmOWE4apwUlituU/AgVglf45shIJ1W4B3QyXg/vcod9eKD9P56oBp5+HtJamVi+jSVcIOmJTwpZqyqSvd7yZ2zxjGwG6yOT3QAxJgbGtEyN8FGWCRj8x9GkqR93TFaCGCftJ3pAUJPbFidfi2ILAmzRa877orY9yAQHjL/bhsH8l/vBnIjIc3Kkut/+AqQD/b+bIgpqavJ8nktdjw1kpc9S00+LqkPSGYqnGa7kukhnhbAuZ00uZ+93YCiIdk32OXEjah3CenhUA+fxhwVekhb2XkHQc+3jTtmt5Ck219bCCmt+1YWKQ6c7xccOylrupAtn0l4762eZ8a037g8GSjP42RhV9oza5U3SYAEeHg5f5xbMEYIu+jAm89eayjKma/Y00b3vk1ax2Er/yhR6bQaZ2w3fkHnpsjqh2Ne6v54Ls2R4XGtIAXN8z7Krsby+bIxn/ijW1R/ZYaC5387PohOLGKkce3SGBpldYeKS8gugFC4pigtkVC8bDmcNugvzfJ1fKS7kUTJ/9OZYg3QW1ko/RpoMS2LeH8/FqzP44qaJywTYQikJloniw20m39WIo3xtaFQ
 u713TjA6
 ixVDNBv9T6R3RUIKj+dTt9sRC0AciqkfOGXkjwr/5iVLya6YjJj4eJ2dfp+SQiCcEGloTT2HD0kJrCxBJeojab8Q23+y/ssE08GTaVMTE7SDgG1uT6nyqs9fpTddAOiNm10z2ykzDZTOvtI+pIHHlU83M918EqrksdY/dAqupC+VJVChwa4ifXmDIFb/u4a8j2Q+is1F1Kjh82c/O31U22Ntj018yMBqbgqsAR9Is6/X1d4DbNqUIYMQank1hOq1LZl2C9Lj/dbbsNGIKuXSFUojQK/GsYs2Tfjh7jN46ere0GwsONG5Z8Kt7jCtyQ8vwATrojSFt5kzDiCBdGVGa76UE+l9OQDrXzhjUhXr2MW+Yc3QFWh8CwMGtiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This function is, for now, a placeholder; it will be used in future to
determine whether to use the virtual page index or not, based on whether
the folio is anonymous or not.

Currently it simply wraps linear_page_index(), so this does not change
behaviour.

We update callers that will, once the change is introduced to track
anonymous folios by virtual page offset if MAP_PRIVATE file-backed, need to
determine which index to use based on folio type.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/pagemap.h | 18 ++++++++++++++++++
 mm/huge_memory.c        |  3 ++-
 mm/migrate.c            |  6 ++++--
 mm/userfaultfd.c        |  6 ++++--
 4 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 81da91e103b3..dab355eda0ef 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1142,6 +1142,24 @@ static inline pgoff_t linear_virt_page_index(const struct vm_area_struct *vma,
 	return pgoff;
 }
 
+/**
+ * linear_folio_page_index() - Determine the absolute page offset of
+ * @address within @vma from @folio.
+ * @folio: The folio whose linear page index is sought.
+ * @vma: The VMA in which @address resides.
+ * @address: The address whose absolute page offset is required.
+ *
+ * For compatibility, currently identical to linear_page_index().
+ *
+ * Returns: The absolute page offset of @address within @vma.
+ */
+static inline pgoff_t linear_folio_page_index(const struct folio *folio,
+					      const struct vm_area_struct *vma,
+					      const unsigned long address)
+{
+	return linear_page_index(vma, address);
+}
+
 struct wait_page_key {
 	struct folio *folio;
 	int bit_nr;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9b1f3b24f7e0..abc65d608c23 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2887,7 +2887,8 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 		}
 
 		folio_move_anon_rmap(src_folio, dst_vma);
-		src_folio->index = linear_page_index(dst_vma, dst_addr);
+		src_folio->index = linear_folio_page_index(src_folio, dst_vma,
+							   dst_addr);
 
 		_dst_pmd = folio_mk_pmd(src_folio, dst_vma->vm_page_prot);
 		/* Follow mremap() behavior and treat the entry dirty after the move */
diff --git a/mm/migrate.c b/mm/migrate.c
index 222c8c15f782..37fe7a9b3fac 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -363,8 +363,10 @@ static bool remove_migration_pte(struct folio *folio,
 		unsigned long idx = 0;
 
 		/* pgoff is invalid for ksm pages, but they are never large */
-		if (folio_test_large(folio) && !folio_test_hugetlb(folio))
-			idx = linear_page_index(vma, pvmw.address) - pvmw.pgoff;
+		if (folio_test_large(folio) && !folio_test_hugetlb(folio)) {
+			idx += linear_folio_page_index(folio, vma, pvmw.address);
+			idx -= pvmw.pgoff;
+		}
 		new = folio_page(folio, idx);
 
 #ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 8fd24c8b428e..258b03182a78 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1352,7 +1352,8 @@ static long move_present_ptes(struct mm_struct *mm,
 		}
 
 		folio_move_anon_rmap(src_folio, dst_vma);
-		src_folio->index = linear_page_index(dst_vma, dst_addr);
+		src_folio->index = linear_folio_page_index(src_folio, dst_vma,
+							   dst_addr);
 
 		orig_dst_pte = folio_mk_pte(src_folio, dst_vma->vm_page_prot);
 		/* Set soft dirty bit so userspace can notice the pte was moved */
@@ -1428,7 +1429,8 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
 	 */
 	if (src_folio) {
 		folio_move_anon_rmap(src_folio, dst_vma);
-		src_folio->index = linear_page_index(dst_vma, dst_addr);
+		src_folio->index = linear_folio_page_index(src_folio, dst_vma,
+							   dst_addr);
 	} else {
 		/*
 		 * Check if the swap entry is cached after acquiring the src_pte

-- 
2.55.0


