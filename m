Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B0B6C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:40:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 147386B00CD; Mon, 20 Jul 2026 10:40:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11E6A6B00CF; Mon, 20 Jul 2026 10:40:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F295C6B00D0; Mon, 20 Jul 2026 10:40:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C54666B00CD
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:40:14 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 597851201A3
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:40:14 +0000 (UTC)
X-FDA: 85009415148.11.14D7E4E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id A4DD2140009
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:40:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eUOQE5tt;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784558412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BHrvjp5Lc9CpGwr/Vetfc2dLYK33dJtbQdjvdpaRp9A=;
	b=DHLhwrmVtV27VpfQWTCrW7k5xZplOyE5XEht+yWMx3pRiD8RuMkXFmp0jow0kLTY6alr4J
	7AcNHuoL0EyL2XT3wLWzrAh4bmi+txZsne6N8DVN1E6VocO1XWZ1DtGgAHoRAUelcBnQ/r
	4YrbEli4eZ4ByAzUQb0CJy7Owplb634=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eUOQE5tt;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784558412;
	b=TzLxECNopzng99d1HinR1Ko90lh7KwQDJ8zeFPai8+dS034HIjgvOl+lCByIbhivpAH1y3
	1GtZrSVj39hgH7BUr484N/YvNUsV02TTbuVphBdBhW5QA6f2X+VXrxEh6hTfqEMCHthoEi
	i/MpiTaeXcRArkWQmY9v+LhARU2ZomE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4003660A7C;
	Mon, 20 Jul 2026 14:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327701F00AC4;
	Mon, 20 Jul 2026 14:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784558412;
	bh=BHrvjp5Lc9CpGwr/Vetfc2dLYK33dJtbQdjvdpaRp9A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eUOQE5ttQ5K03GANJHDG0/gYzgnZBdAC/5kwVYJIWYARTVPjDt6T9UHoHGEGXXnZg
	 DcTmRsq0oeMcLWqWiOoWaq7pPwWFOMq99yCn4BnOgCZQWdxYSAbvNgsimNlY237g8H
	 PnlTl7Kj1NzINjw10Vhlt/GnzzkTlgIhxMnkVua5HKDEBVlqNDgyOhbVS35cczPGQ7
	 lAU6S9nnJhOti5tICPs5QUljcaw3ncuKIP0xAM+kVSWfyzXPMf5tTBjevL6x7jkEnh
	 fQwLv51nJPytWD6tFQXcGnniKJJMUxXluP9eUXvfgQqJ1w9bsuMmOW5S0Tyfaij3NF
	 8EpnVvuKacXaA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 20 Jul 2026 15:38:34 +0100
Subject: [PATCH v2 08/15] mm: introduce and use linear_folio_page_index()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-scalable-cow-virt-pgoff-v2-8-2d549757a76f@kernel.org>
References: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
In-Reply-To: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
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
 h=from:subject:message-id; bh=q7rFBK1JcdRaa6+vbmoVHB13KGgbUIBraCmA/Lc5wG0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLijN4UrS0+2FbwaKn78nWRBoE3Oy9F6sm88+87wfuiV
 L965wHLjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEzkrwvD/5zbn3m+ZFq4HlTS
 Ufh7KPnW93MHmawsyxO+Fj6ebbZV0IaRoaNL5lrbBeUl3yM2FOVts5lZYi1TWKK4Rfn6zb3c3Hv
 uswMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A4DD2140009
X-Stat-Signature: idpcdgpcg5bpw69jwqwhxxobxja7njag
X-HE-Tag: 1784558412-995818
X-HE-Meta: U2FsdGVkX188HunVJmcJRW539+hYVuedxtUDkKfsA6EuNXZMde8y4kEgSW3E2KSUwKzQgXd3aPJMEtSpKNFlgCYUTLt20ITJCnHuSe8zX+NerNwh5Kq7SrJVBiFe6YCgLVyf3OB1463f8+kxfiI0J7808+dbPRPjLzTbeXU6ZQpMTc0VA6jd3bL7V6q/L2+x962qifxC2g3meR6YqSUayESxgYts8db5fbtAIajB4cl19N+egKXl1U/Ec6mZqThvrTqp+vQUdyHvFNJTWvbaXZLw3bGidnUoE24X47Bu3LFfIkUQQO5jzyzBqJUi50fwxY4fn+W6rhp0MlgcHl3UiLuIm4HFVW9df2sxwqQ/SsJhBqTXxPszrZBq6lf/kk6RKovvgS6x5SthvKUP4o7CQGMKfm2hsND2ukju4FuM4AcZ3V45Ygzg+KEJQGpWuVWIblNw5y8EszTUQFOJ/VuWmrWfl24W6yLvcgczCuoS8g/GkRt63RFJFd50N+E+6fnb7bQEIsFH9HgCAH69ICFM+ZZjl9sWm66+uQwnZrQ7DR43HQAzibdGhXVTU5yvk2xVjIoOmnUgrrDC0GLi7C6XbUc7iEq3tO5aJO0ZW6p2CPXkQoS7hsbJkaFHC9btbt4707eobhkTObLCayaIkOTLMJTtxI6GC6VTFZxjM0WidQIpBxoT3J0FIyCRvpfeJDOtAtFOFNlxgExcZJoDvuuozPuXai+edxYTeUi/KtPHB0g8JVlUuX6xmOLH2ixbCJMw/j5/1QXNu1sRcbhuBIZMfmiWjoR60RVH4dpwtNpyU2bEdS3ENmiUYCXbsMi4/359ivFf6rt6eMZcbof67WUifirFPC2ssEy76h1c1n5fhi60AKgxpC0RoG2IyzO5M2XAguIKMVsXR2eKOvo+q7cI/MZR8U8I98bl81Z2dauEYPNQrp4moUxXD6DWV2Bl3MjWfZEYhIIQSU2aYqcRxGv
 PgD8MjHy
 JnJ5I29/ETxZpY2Zla8FPH4cBKK9KomrmePNYfDTNxQgM2XpnthbumygiP+WlUqVuO8EcOrZQj3cAgJsEA8fkoBkT2SxYo/P/wjzt0Uz/X2x2DLa/Ws9e+2aAswl6qOuUn1Zx/0/cIdcitq4P9YV7uy1qe6z55IrLinu0C2nyRfNeHEplOKM0+H+jcH9yppufHuTfS9loQHF+X94/TP3dGspvajj318XAHVEUcFxMs8IuA2im4Fi5WiGyX1SDCOOkWrGRY2fu4S1+NC807D2X2W1uwxFYPGWCmPMPNRdCsVPa+SkNaDDb09WQH2ZlbBNDO918OawS7m1C53kA6IjBl10RI1Lktt96Y7PeLpylwTuSID2OxefSFcfIHw==
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
index c9c65ba60ab3..c635c3237f52 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1143,6 +1143,24 @@ static inline pgoff_t linear_virt_page_index(const struct vm_area_struct *vma,
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


