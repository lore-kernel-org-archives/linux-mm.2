Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27E00CCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 14:03:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3701680059; Mon, 27 Oct 2025 10:03:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 320CB8000A; Mon, 27 Oct 2025 10:03:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2367780059; Mon, 27 Oct 2025 10:03:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ED7B78000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 10:03:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BF31713862E
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 14:03:06 +0000 (UTC)
X-FDA: 84044060772.28.53AAFA3
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf08.hostedemail.com (Postfix) with ESMTP id 28A9F16000B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 14:03:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=HNX4wW2n;
	spf=pass (imf08.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761573784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0wHX/jcFSsUS6b4WnCUTKJ0MhfSl8GdycqH5o0g1oq8=;
	b=lZ96k3dZqcYIiJD08sCk2lxPQopbzqM90UpywvRyCLQqW3fMYY81apmmgP6oYMLXdu66MO
	dF5gTgTO0QHBf2BFIrzgp0LnYl3h6mDeeStjrHlRKkijgflbIXMmwFdTa1C6lI1NIjui4X
	63r0AJ+hIJDkThwHYwPYv0VnafBpwUA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761573784; a=rsa-sha256;
	cv=none;
	b=PuCqit4U5/kH51NSChgNZyo/JFBWDlRbsVyLogL1S84+bFBwqkQ46GBL8FjRfGaAMkZRB8
	nOB8dnjSmt780wlRzSx+szua1B9NN737HBewqlhqoI1gNsYTSBNOmMC4W+WMIfe0SOMvp0
	k1xCfn8EdfMMSS7fdUvM7DFe0+WTqVU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=HNX4wW2n;
	spf=pass (imf08.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=0wHX/jcFSsUS6b4WnCUTKJ0MhfSl8GdycqH5o0g1oq8=;
	b=HNX4wW2nCkvKdY3yB8QgsKRNFSRNFWV24QPTSH0Vs1EnYBwDkezmFOzbIk9O/vBEpONuwlV2Z
	HD1XCXxxJMTvvKTZ/YnqU2s/bs9rxHETVqavCtSzjEpxpGPxb3yrPjjuzwTeF5hO+MWbAcEtWlb
	M0xM0VA7YvydlVV9ABhhvkk=
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cwFZB44BPzKm4k;
	Mon, 27 Oct 2025 22:02:26 +0800 (CST)
Received: from dggpemf500012.china.huawei.com (unknown [7.185.36.8])
	by mail.maildlp.com (Postfix) with ESMTPS id 3954F1800B2;
	Mon, 27 Oct 2025 22:02:54 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf500012.china.huawei.com
 (7.185.36.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 27 Oct
 2025 22:02:53 +0800
From: Zhang Qilong <zhangqilong3@huawei.com>
To: <akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<jannh@google.com>, <pfalcato@suse.de>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
Subject: [RFC PATCH 1/3] mm: Introduce can_pte_batch_count() for PTEs batch optimization.
Date: Mon, 27 Oct 2025 22:03:13 +0800
Message-ID: <20251027140315.907864-2-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251027140315.907864-1-zhangqilong3@huawei.com>
References: <20251027140315.907864-1-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf500012.china.huawei.com (7.185.36.8)
X-Rspamd-Server: rspam05
X-Stat-Signature: x47f5f7q9o8t9dxu95ikwpciex11hhct
X-Rspam-User: 
X-Rspamd-Queue-Id: 28A9F16000B
X-HE-Tag: 1761573783-351045
X-HE-Meta: U2FsdGVkX1+Z9zKCN8C2bFnYjnQJcRdy0j6ljUQ62E5GRFmw4ayJj0F72xJdShW8PC6Snp0DUnuXTXZdMGQSVigXLlq4v+ZO8FzBor6gGVsyiPjjOfcbdcbGzHISAwMTXpgoYqzvaIMXmFaUrUeLUId4TcRlUaGmOk5rjjRvNhF0OlHj18Nz+aOqqHLZgrbNgiersEuKjsyBBPpt/H3CPW4VeEYZGQaccSWdbQdAvos2V/srp0Fdh5gGwQx9AkIEYmVbTlaJETfFbcVx4eqfzhljA5vwK2JzaVOgBYddoMM2Vdlo6X8tNHEgxVKI8dP+GUzdQzwMBN+v9ENMNy6EglG6YtBaSOiCb6oeQGCdidRsE+/05kCGJ0gZmqgxVr/dUhdUfYsMGHxwrEAiHLR0zzGY2HlPOSMRXqWWsxDR356mh4HeSO44r5NC8Nf3ZGducK662ewFKsp286V+lY8iynWUevENyMGWw98pSEdzbqVVIwMh8RkjUUeRueAvos1opgVKLxtLaPsepWr8x9gOJPw/o1ZjMRUt13QSGNDN4JlgRJFYM5KDhNvm2v7m0IMNwqKON7utna9GImdFylUfzovvxHt/f7rvfrdCHmK4nZOs4kbh7VeNwJFMeujg/uPJ/L0n+9d+Hw7rMc8ZTkiyQUf3g0xT92aGjZMDB6MKVAf+FtkeIEL7Ps5jZJ397Eawy72aY/y/8w7TOVwDjuiVXigAWj2msr5SQlIUjou7aaTz0KcmKekOZhcNukBHtA30WU+JJkStNVJFwsgkKXIlQezXbXbLIPFBXE7zV/RJ99mhGezl7FcZ1oJXNw98Qeo5DXPCTtYtLc3knNmrvl9iy7CTvbDEGB8+Zyv+W+UN0WHG0JHf4LNE0pwCMVyhR0FgBC9ZP0QYXslwlXuQ18Ji1yltIcuj3Q5nHL9+EEm61YM6br8jMjzqINzCB6w7Ilzvge+NGLZSBGxnyCGvqUt
 pspm5JnI
 2oMflU6dBc0n9NzukUX+mnT7dlNb9YQSXTXxD+MqzahIwgIHRIB4FpH+cwQJ8sigfNAvOz4gyFAqlndZnybvXprSi5fwXKCjyLPVY6gznFU+p989gfzFUIyPS7yX5qizodmVQN/QK+EvLi4NXkN9KJgt9uiF6mVAWO1rvYe109p8hq6E/ERuh7ye/J0/l9b0Z/P3zaoGQRK/nnT92/M9WdrE5jay9rZB1SMvjE6qSRS/eAIa96AKL/fZjEDpoeLypoyRP9kb9CC7R7quR8t7QY07Li/Om36o9Bs9e9/PBA97KJ/m0tZAOij9PO2cS03d/cRY8CK/zhQbR+sM+A4xvIVO8+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, the PTEs batch requires folio access, with the maximum
quantity limited to the PFNs contained within the folio. However,
in certain case (such as mremap_folio_pte_batch and mincore_pte_range),
accessing the folio is unnecessary and expensive.

For scenarios that do not require folio access, this patch introduces
can_pte_batch_count(). With contiguous physical addresses and identical
PTE attribut bits, we can now process more page table entries at once,
in batch, not just limited to entries mapped within a single folio. On
the other hand, it avoid the folio access.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
 mm/internal.h | 76 +++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 58 insertions(+), 18 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 1561fc2ff5b8..92034ca9092d 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -233,61 +233,62 @@ static inline pte_t __pte_batch_clear_ignored(pte_t pte, fpb_t flags)
 		pte = pte_wrprotect(pte);
 	return pte_mkold(pte);
 }
 
 /**
- * folio_pte_batch_flags - detect a PTE batch for a large folio
- * @folio: The large folio to detect a PTE batch for.
+ * can_pte_batch_count - detect a PTE batch in range [ptep, to ptep + max_nr)
  * @vma: The VMA. Only relevant with FPB_MERGE_WRITE, otherwise can be NULL.
  * @ptep: Page table pointer for the first entry.
  * @ptentp: Pointer to a COPY of the first page table entry whose flags this
  *	    function updates based on @flags if appropriate.
  * @max_nr: The maximum number of table entries to consider.
  * @flags: Flags to modify the PTE batch semantics.
  *
- * Detect a PTE batch: consecutive (present) PTEs that map consecutive
- * pages of the same large folio in a single VMA and a single page table.
+ * This interface is designed for this case that do not require folio access.
+ * If folio consideration is needed, please call folio_pte_batch_flags instead.
+ *
+ * Detect a PTE batch: consecutive (present) PTEs that map consecutive pages
+ * in a single VMA and a single page table.
  *
  * All PTEs inside a PTE batch have the same PTE bits set, excluding the PFN,
  * the accessed bit, writable bit, dirty bit (unless FPB_RESPECT_DIRTY is set)
  * and soft-dirty bit (unless FPB_RESPECT_SOFT_DIRTY is set).
  *
- * @ptep must map any page of the folio. max_nr must be at least one and
+ * @ptep point to the first entry in range, max_nr must be at least one and
  * must be limited by the caller so scanning cannot exceed a single VMA and
  * a single page table.
  *
  * Depending on the FPB_MERGE_* flags, the pte stored at @ptentp will
  * be updated: it's crucial that a pointer to a COPY of the first
  * page table entry, obtained through ptep_get(), is provided as @ptentp.
  *
- * This function will be inlined to optimize based on the input parameters;
- * consider using folio_pte_batch() instead if applicable.
+ * The following folio_pte_batch_flags() deal with PTEs that mapped in a
+ * single folio. However can_pte_batch_count has the capability to handle
+ * PTEs that mapped in consecutive folios. If flags is not set, it will ignore
+ * the accessed, writable and dirty bits. Once the flags is set, the respect
+ * bit(s) will be compared in pte_same(), if the advanced pte_batch_hint()
+ * respect pte bit is different, pte_same() will return false and break. This
+ * ensures the correctness of handling multiple folio PTEs.
+ *
+ * This function will be inlined to optimize based on the input parameters.
  *
  * Return: the number of table entries in the batch.
  */
-static inline unsigned int folio_pte_batch_flags(struct folio *folio,
-		struct vm_area_struct *vma, pte_t *ptep, pte_t *ptentp,
-		unsigned int max_nr, fpb_t flags)
+static inline unsigned int can_pte_batch_count(struct vm_area_struct *vma,
+		pte_t *ptep, pte_t *ptentp, unsigned int max_nr, fpb_t flags)
 {
 	bool any_writable = false, any_young = false, any_dirty = false;
 	pte_t expected_pte, pte = *ptentp;
 	unsigned int nr, cur_nr;
 
-	VM_WARN_ON_FOLIO(!pte_present(pte), folio);
-	VM_WARN_ON_FOLIO(!folio_test_large(folio) || max_nr < 1, folio);
-	VM_WARN_ON_FOLIO(page_folio(pfn_to_page(pte_pfn(pte))) != folio, folio);
+	VM_WARN_ON(!pte_present(pte));
 	/*
 	 * Ensure this is a pointer to a copy not a pointer into a page table.
 	 * If this is a stack value, it won't be a valid virtual address, but
 	 * that's fine because it also cannot be pointing into the page table.
 	 */
 	VM_WARN_ON(virt_addr_valid(ptentp) && PageTable(virt_to_page(ptentp)));
-
-	/* Limit max_nr to the actual remaining PFNs in the folio we could batch. */
-	max_nr = min_t(unsigned long, max_nr,
-		       folio_pfn(folio) + folio_nr_pages(folio) - pte_pfn(pte));
-
 	nr = pte_batch_hint(ptep, pte);
 	expected_pte = __pte_batch_clear_ignored(pte_advance_pfn(pte, nr), flags);
 	ptep = ptep + nr;
 
 	while (nr < max_nr) {
@@ -317,10 +318,49 @@ static inline unsigned int folio_pte_batch_flags(struct folio *folio,
 		*ptentp = pte_mkdirty(*ptentp);
 
 	return min(nr, max_nr);
 }
 
+/**
+ * folio_pte_batch_flags - detect a PTE batch for a large folio
+ * @folio: The large folio to detect a PTE batch for.
+ * @vma: The VMA. Only relevant with FPB_MERGE_WRITE, otherwise can be NULL.
+ * @ptep: Page table pointer for the first entry.
+ * @ptentp: Pointer to a COPY of the first page table entry whose flags this
+ *         function updates based on @flags if appropriate.
+ * @max_nr: The maximum number of table entries to consider.
+ * @flags: Flags to modify the PTE batch semantics.
+ *
+ * Detect a PTE batch: consecutive (present) PTEs that map consecutive
+ * pages of the same large folio and have the same PTE bits set excluding the
+ * PFN, the accessed bit, writable bit, dirty bit. (unless FPB_RESPECT_DIRTY
+ * is set) and soft-dirty bit (unless FPB_RESPECT_SOFT_DIRTY is set).
+ *
+ * @ptep must map any page of the folio.
+ *
+ * This function will be inlined to optimize based on the input parameters;
+ * consider using folio_pte_batch() instead if applicable.
+ *
+ * Return: the number of table entries in the batch.
+ */
+static inline unsigned int folio_pte_batch_flags(struct folio *folio,
+		struct vm_area_struct *vma, pte_t *ptep, pte_t *ptentp,
+		unsigned int max_nr, fpb_t flags)
+{
+	pte_t pte = *ptentp;
+
+	VM_WARN_ON_FOLIO(!pte_present(pte), folio);
+	VM_WARN_ON_FOLIO(!folio_test_large(folio) || max_nr < 1, folio);
+	VM_WARN_ON_FOLIO(page_folio(pfn_to_page(pte_pfn(pte))) != folio, folio);
+
+	/* Limit max_nr to the actual remaining PFNs in the folio we could batch. */
+	max_nr = min_t(unsigned long, max_nr,
+		       folio_pfn(folio) + folio_nr_pages(folio) - pte_pfn(pte));
+
+	return can_pte_batch_count(vma, ptep, ptentp, max_nr, flags);
+}
+
 unsigned int folio_pte_batch(struct folio *folio, pte_t *ptep, pte_t pte,
 		unsigned int max_nr);
 
 /**
  * pte_move_swp_offset - Move the swap entry offset field of a swap pte
-- 
2.43.0


