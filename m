Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61684C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 15:06:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDC4A8E0009; Tue, 22 Jul 2025 11:06:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB52A8E0001; Tue, 22 Jul 2025 11:06:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCA068E0009; Tue, 22 Jul 2025 11:06:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CCB138E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:06:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7424180466
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:06:27 +0000 (UTC)
X-FDA: 83692226814.05.77956D0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id CC2441A0011
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:06:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753196785; a=rsa-sha256;
	cv=none;
	b=TTm5MgWyOfkXKE2upo3Gh1yFVI1dGTzn2EEgIpR1RfXAlNkAjabvFERny2y8SgSECf4yNj
	NjmQiW+E0xpRb+/rpBK5fTdmq0EGGwjZwdVUj9vqk6Ce2qBqDwZ6Ls4tBOxqTazp6YblBH
	oe/yBGwz3gZKbgW3Qsua0hlOowB2VLQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753196785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qs+2y5ReI9MbQ7rGHD3BaZlm4pD8uefP4Job39ynrYQ=;
	b=sHgkV0EoW9Rjf4VHClxc1UiQoK4UWznk7BepkvfsBhPnN6fDtrfDe0QegmjwNqZUwOjDfH
	1H2C3QKKnOuHeOoVtsL7Z51Vp3wWFrffDm8CrUa3wRptAqJ+6xzIpx/QJ5pHm8bR4n1+Ep
	h5e8gsw/Fo34B5V7s2cPzWAARPXxkQ0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 73E59152B;
	Tue, 22 Jul 2025 08:06:19 -0700 (PDT)
Received: from localhost.localdomain (unknown [10.163.92.223])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EFB1F3F6A8;
	Tue, 22 Jul 2025 08:06:20 -0700 (PDT)
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@redhat.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	baohua@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH v3 2/3] khugepaged: Optimize __collapse_huge_page_copy_succeeded() by PTE batching
Date: Tue, 22 Jul 2025 20:35:58 +0530
Message-Id: <20250722150559.96465-3-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250722150559.96465-1-dev.jain@arm.com>
References: <20250722150559.96465-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CC2441A0011
X-Stat-Signature: u5fcbjpr9j4d4d7hcfcf44qnazbt19uj
X-Rspam-User: 
X-HE-Tag: 1753196785-253649
X-HE-Meta: U2FsdGVkX1/2qiM0rhkmmMORa2X03YvTu1CHQwsdaB0zF4AY3757izS13/ePxF5KBkeQi7rXjd12utyR6HxlDA07supE1TwVbVz0fBc65jrcFhaVDFMaqbbPetBynQ+bD33QlXIw1u/3NBlUkHTRoApn6ZMBeg/n4Zngx+K9ZZ2BEWBe3B8kTRP4DXVOZwy3VpD2V6+A4+gXy1XBpIBVu73sf0rfzwBfkIPsF+i+WXbrrVqQd4lRworz0qTsRXfB/NLq5HcTb0BtJ1qVJ2Xc+bk22iy21Jw3K8I0Q9zTK0aJY0iC0VnuzTIoe6M1gR3A/VyGugUsH+sYYsHqrgWVsQVw1E8eYtnaYBDpoWq2yl2Cqql4rRjGuJqjAqUHRJfQwsWn3sNfr0k52ZMXne+fLskN9mc4lQhkbqSspLMU+l9RVt4Fz5FouQFMNM9FxdX2nxLWehxqIgZpNDqCSaWz4n81wDyatjJETuZ75eKQuP+9xl+BRIZO4gzD/hkqh1LIsFxCRpVF77uxh6s5gQjGD/qDpiZdhz0GNMWyiSH3Nhb8LqsOdukWb3FW5XYb6JZaxAityQDsuw9PIDdVZ6xSjazE1zzOuPL/7d7MhWt3kVJAbcEXhZqIN0zLy0hnO2rLAEr7jffHJzG/PSaGfQDadJiiscd3dN0cd362uDrxccgLWC+DPbvbpubUQBoZXzCGGru7j+KZJP6VNB8UK7WMdfJ3pW5qptZdxCXq6eRUqxKCefEO9T6eDZJnZF/JIW5dhmEGZVcWnXQq2KWygZ7jgSmoi96gUjvCz8dZQYn789kmSC3bxi2DX8pCeOY/I0u4svJnttWDg6y7xGixf1USfkiKvJ1prR3rXQo0UUPL9FHF+wUMGie/S6wnXnNgePIi9FIbM6rQqVA3ngcXjZ2WFgO2ROf9KDcVqs9ZhWUK3LSMwjN1jOcPCERhaiDlIqQByXfundWsj9m9DoDNfl1
 WSytWRg7
 92j/ALxe1+OuNdJwByxblVGl6jTinCyB9n2dr1JEWYtEcMOXA95iSkdCPNaZGOl0dDPTyEVBzTnaDgk8dQj/JPNEKhnqUHAo8TJbugWexMZp3wvCiymuW3rOJpeSoE4IX9fHYXt8t5c9iQrNkGGkA8cRyGPfYcQbuB1FoQVWDfTvigKGk6lV8P+bU5NPN7WCcMrTQ4jdmfZjpN50van4q+eN8EsAkKPCIhbg73LHzeYBlRzE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use PTE batching to optimize __collapse_huge_page_copy_succeeded().

On arm64, suppose khugepaged is scanning a pte-mapped 2MB THP for collapse.
Then, calling ptep_clear() for every pte will cause a TLB flush for every
contpte block. Instead, clear_ptes() does a contpte_try_unfold_partial()
which will flush the TLB only for the (if any) starting and ending contpte
block, if they partially overlap with the range khugepaged is looking at.

For all arches, there should be a benefit due to batching atomic operations
on mapcounts due to folio_remove_rmap_ptes() and saving some calls.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/khugepaged.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index a55fb1dcd224..63517ef7eafb 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -700,12 +700,15 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
 						spinlock_t *ptl,
 						struct list_head *compound_pagelist)
 {
+	unsigned long end = address + HPAGE_PMD_SIZE;
 	struct folio *src, *tmp;
-	pte_t *_pte;
 	pte_t pteval;
+	pte_t *_pte;
+	int nr_ptes;
 
-	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
-	     _pte++, address += PAGE_SIZE) {
+	for (_pte = pte; _pte < pte + HPAGE_PMD_NR; _pte += nr_ptes,
+	     address += nr_ptes * PAGE_SIZE) {
+		nr_ptes = 1;
 		pteval = ptep_get(_pte);
 		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
 			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
@@ -722,18 +725,26 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
 			struct page *src_page = pte_page(pteval);
 
 			src = page_folio(src_page);
-			if (!folio_test_large(src))
+
+			if (folio_test_large(src)) {
+				int max_nr_ptes = (end - address) >> PAGE_SHIFT;
+
+				nr_ptes = folio_pte_batch(src, _pte, pteval, max_nr_ptes);
+			} else {
 				release_pte_folio(src);
+			}
+
 			/*
 			 * ptl mostly unnecessary, but preempt has to
 			 * be disabled to update the per-cpu stats
 			 * inside folio_remove_rmap_pte().
 			 */
 			spin_lock(ptl);
-			ptep_clear(vma->vm_mm, address, _pte);
-			folio_remove_rmap_pte(src, src_page, vma);
+			clear_ptes(vma->vm_mm, address, _pte, nr_ptes);
+			folio_remove_rmap_ptes(src, src_page, nr_ptes, vma);
 			spin_unlock(ptl);
-			free_folio_and_swap_cache(src);
+			free_swap_cache(src);
+			folio_put_refs(src, nr_ptes);
 		}
 	}
 
-- 
2.30.2


