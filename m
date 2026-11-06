Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82CF1606A333
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 12:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MCsFJVVW
Received: by kanga.kvack.org (Postfix)
	id 6E1576B05BE; Fri,  6 Nov 2026 07:36:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 691056B05C0; Fri,  6 Nov 2026 07:36:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5329E6B05BF; Fri,  6 Nov 2026 07:36:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1BE396B05BD
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:36:46 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7E0E3140D0B
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:36:45 +0000 (UTC)
X-FDA: 85404643170.29.1F79790
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id A477C80006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:36:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MCsFJVVW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793968603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k0OJ5cOJhFxwKRWgLGHa4buWJAMOSgYsz1k8mWUWB34=;
	b=2eqISlfXc8kfGLKmwhx2RTJSD6fyNzm2QHaIno9ad7n0LSXqZx1MLU6p5c//fLyWTySDQ/
	ubFxxo4+zXE8Xj0XANSnZpgK51WTrHQlZFL+5Zp8cH6suJ75D9NJ/twtfHwqCrKrGdIeQ5
	mQO4SlefPywJSEZI7qqz2UUdjlXaDyo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793968603;
	b=yTp3dWvneV+rtyaMDfX+uMJifHYjDQddXLh4iDon92aKe2C5HvRR7Kz0V4w5iKoKJ0hnJs
	v8sDZTjsZR53ORr8pn94BjvLJMtEyo/T5uoKaIhTtsP0s0iiBXR5Anxa2ThvQsjhTIeK4u
	b2rzHRxPeAM6RY4Qi1zQay7KhfwiEIA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MCsFJVVW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 49E5C605DC;
	Fri,  6 Nov 2026 12:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B3C1F0089F;
	Fri,  6 Nov 2026 12:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793968603;
	bh=k0OJ5cOJhFxwKRWgLGHa4buWJAMOSgYsz1k8mWUWB34=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MCsFJVVWl57i+t+M5XQAOw82JpUNPrrmCyAT97GYiSLGMNTof7En4bso9aSYFK+nh
	 grMauLv1Llt4mhQLU+mYgS7FDOeyfyqKe2tHIwdmWI6ZwDx84zQW0D00ocTfXo6FWB
	 YcVwgKMJslFIG+zqbAhZi+/4+Gi0ZVWi6/HhVd1eeAW1ab3nRFhdNuEuFp/zEFx120
	 BWxRwxRCJ2SuNg0+HnjM8Zs7syWTtl7v1Ue6dUC3kdHpPa5qcUt3fO+P99J7oUga/r
	 6xUABepAxWBkKK0kkJ9Qp2/XVhg4DGv8DgWebHd7TUBSJpMYjFOeYrwt1ojTK1aG/I
	 KQkI5XCQ2AS1Q==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 06 Nov 2026 13:36:13 +0100
Subject: [PATCH v2 2/2] mm: don't allocate a page table under RCU in
 do_set_pmd()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261106-khugepaged_set_pmd-v2-2-d2457b5e377a@kernel.org>
References: <20261106-khugepaged_set_pmd-v2-0-d2457b5e377a@kernel.org>
In-Reply-To: <20261106-khugepaged_set_pmd-v2-0-d2457b5e377a@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Hugh Dickins <hughd@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4428; i=david@kernel.org;
 h=from:subject:message-id; bh=lLTIq2694J3MjH85WnniQQmIlLYoYXSiDFLoKNVlvso=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLenjznuf6+6JY5LZVhOr8lgr60aDZldUyt+HJ3t45fc
 NMb75uFHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEzEeBEjw42v63Tqn6+y7s6b
 HvHtprqP7btNIe4XUmx+ac1QVvGXX8vI8C7cw0j5PbNm4OIEj9JJofPjthTO+Zm78iNrWbrSvMd
 3OAE=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: 6t4dkojmi5gskmkz6yqa94n9hx19t975
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A477C80006
X-HE-Tag: 1793968603-227614
X-HE-Meta: U2FsdGVkX1+AnrdxJfkuB8jfKFvbP020Mi7dXAJM6uMH7Y2wvYetLAB+XxCN0hzQot9n+pUe60F3WxvonKePHHdsGXohvHRklfOX65OYULybtO+HkinQzC9VFMK2d6UHu+ILbQ2GCdOivfujYkYRFyaIcdvnTJlFeTWOZOdWp8HcKDW0UgftkISlqZgW1A1vfkeQfQTaCvzyXqFxx/7QdhA7isC+3DnnhA1GTHXz5a9hnzwyiw8GH8N29mqnmuAws2UPdf2vRMW0hGoyKbAZ69r9ykWV/Y1s0dVpCYaD32tuyRtsY6bXYHnpo1G3H2GzG+ILgr452KehACG4V6QdGfG0r43KTVzLrdXdvoTlfG1fW+oMqDoF2p8Rm2Tbt5opvZVfYLgjrp/kyGRNwmVOvV+gOPmGO09lxhmsrDuZgtoxn4Bh8g1GQ21qGEbLCtm65W1OTWVM9EnfLcBE5BDC7qdf9q8RGiOgG6ofzbJF/jQxovbFJusCUozbqqPZUIBq6hDcUyiifDBOXL9AMQucUpoHWM7owvu761kmoSwG/WpFyHJ6YX+tgra82cq0B0KkdnnTk/qpJQiQvYvryoFTzv7yY/ieht9w7QJfEzk/EVLtSo5I5q3KKFIXScrDjBYtZ9BZI6z97hVqwE9Ia+NW+FC+0XJLXTP8L+lHJTsNBq1ewMV7QnUdagx8dowPKE8EtuHl3nFoXceWg2XalmLDhIuQBjmwHo30SFddZXbUIQ6GPBeaXb96MCzfrFS317xez2KnpLxF7OlHRKl9/EtI7IIPnjMIwEoBq1AnbTCpRFO8ZzryOIay+lJ6RA3hvuGJD2OKkpI0Qj+F9Px2R4NCG/U7B1h4/9rE+WPAzozNk73lrnGQVLs/VA+tSRlYMJtUQkuZcv6qVwUbKH8H+4tJnKJeDLaVAgQw5M89w3n2mVvZaXoQtysK448Bs9CTqrK1xcfoYXEbzahuksgMe0r
 ejJnYykk
 tOaJIVldU4Pta7wXX+e3uU8Mx9Q7cdDcJzTPv/fKChh/SwzFMNjSeX7fUAHluuwMKCN4APs3mgboh6yViTsOzIuCeKTyk5oWA60N0YhFvGURiQhK5CwTzIsL+edZNjN0V3RX2En94aeqB7cJl8GP06Xfidww3pAa86X5zCw8hqAc3R2207kESC+R32obo3yVPIUClXtXVasy15JMF+mNLC4rj8dgd0hJR2oW7FN4/oAh2tcWnocS4IYzdol3ZBMQKl/DYxfWLqT+RXFlIs7boLZiKNQZAlTwnj3N6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

do_fault_around() skips PTE table preallocation when the PMD already points
to a PTE table. A concurrent collapse can then retract that table and
clear the PMD before filemap_map_pages() locks the new PMD-sized folio.

filemap_map_pmd() can then call do_set_pmd() with an empty PMD and no
preallocated table. On PowerPC hash MMU, do_set_pmd() then tries
allocating a PTE table to deposit. But filemap_map_pmd() calls
do_set_pmd() under RCU, so allocating from that context is not good.

This race became possible when retract_page_tables() stopped taking the
mmap and VMA locks. Previously, those locks excluded retraction while
the fault was in progress.

Add a may_alloc argument to do_set_pmd() and pass false from
filemap_map_pmd(), so we can fail with VM_FAULT_FALLBACK instead of
trying to allocate.

This issue should be fairly hard to hit in practice.

Fixes: 1d65b771bc08 ("mm/khugepaged: retract_page_tables() without mmap or vma lock")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mm.h |  3 ++-
 mm/filemap.c       |  2 +-
 mm/khugepaged.c    |  2 +-
 mm/memory.c        | 10 +++++++---
 4 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a2dd76cc5bbfe..bd144fec5f5da 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2156,7 +2156,8 @@ static inline pte_t maybe_mkwrite(pte_t pte, struct vm_area_struct *vma)
 	return pte;
 }
 
-vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page);
+vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page,
+		bool may_alloc);
 void set_pte_range(struct vm_fault *vmf, struct folio *folio,
 		struct page *page, unsigned int nr, unsigned long addr);
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 86297841f9955..9871b4f32a916 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3745,7 +3745,7 @@ static bool filemap_map_pmd(struct vm_fault *vmf, struct folio *folio,
 
 	if (pmd_none(*vmf->pmd) && folio_test_pmd_mappable(folio)) {
 		struct page *page = folio_file_page(folio, start);
-		vm_fault_t ret = do_set_pmd(vmf, folio, page);
+		vm_fault_t ret = do_set_pmd(vmf, folio, page, /* may_alloc= */ false);
 		if (!ret) {
 			/* The page is mapped successfully, reference consumed. */
 			folio_unlock(folio);
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 8d9f05a39afb3..5836e08abc984 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1826,7 +1826,7 @@ static enum scan_result set_huge_pmd(struct vm_area_struct *vma, unsigned long a
 	}
 
 	vmf.pmd = pmdp;
-	if (do_set_pmd(&vmf, folio, page))
+	if (do_set_pmd(&vmf, folio, page, /* may_alloc= */ true))
 		return SCAN_FAIL;
 
 	folio_get(folio);
diff --git a/mm/memory.c b/mm/memory.c
index 421064aef3cf0..6eeed43b05a19 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5682,7 +5682,8 @@ static void deposit_prealloc_pte(struct vm_fault *vmf)
 	vmf->prealloc_pte = NULL;
 }
 
-vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page)
+vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page,
+		bool may_alloc)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
@@ -5723,6 +5724,8 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	 * related to pte entry. Use the preallocated table for that.
 	 */
 	if (arch_needs_pgtable_deposit() && !vmf->prealloc_pte) {
+		if (!may_alloc)
+			return VM_FAULT_FALLBACK;
 		vmf->prealloc_pte = pte_alloc_one(vma->vm_mm);
 		if (!vmf->prealloc_pte)
 			return VM_FAULT_OOM;
@@ -5764,7 +5767,8 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	return ret;
 }
 #else
-vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page)
+vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page,
+		bool may_alloc)
 {
 	return VM_FAULT_FALLBACK;
 }
@@ -5888,7 +5892,7 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 
 	if (pmd_none(*vmf->pmd)) {
 		if (!needs_fallback && folio_test_pmd_mappable(folio)) {
-			ret = do_set_pmd(vmf, folio, page);
+			ret = do_set_pmd(vmf, folio, page, /* may_alloc= */ true);
 			if (ret != VM_FAULT_FALLBACK)
 				return ret;
 		}

-- 
2.43.0


