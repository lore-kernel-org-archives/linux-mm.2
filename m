Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3387F60A5BFC
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OukkQprC
Received: by kanga.kvack.org (Postfix)
	id 5697F6B05B7; Wed, 11 Nov 2026 17:00:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 519D16B05B8; Wed, 11 Nov 2026 17:00:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 457626B05B9; Wed, 11 Nov 2026 17:00:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0961F6B05B7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:00:18 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7837440435
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:00:18 +0000 (UTC)
X-FDA: 85424207316.04.A36935D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id A17E412000B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:00:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OukkQprC;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794434416;
	b=bEFk/p3e1d6PNt8U/s9pt2gaVAQjx+Loo1RtAH0Vd1PwfnmeaGaEgtzvzjzMnQTorwKnTW
	NVLVlDQwaqZ4DuarSowKr5WtDErXgnWFxKC8gtM/yRLFJn6Q0tbKGi1bYlJ+jYGyv8WF7W
	WQ1kdiyalNdchBwHC5JFMbDvmn1A8EE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OukkQprC;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794434416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Klp5K9ghajAt5QsaOTYOAUgTbWlX0z+ZRRZWnWqsMaw=;
	b=Mj56Xi35btGehRFs0fHjAfDOhtrejrFeAvDhl1UDDRQ1evMA4PzqQZzrbRzI2l47B4BpIS
	HF3yKVwcrg9M+NrEIPXkq2yWLu6v8FUqnmzYQNOy7jB/FjT1WVGkbHLCVZ+xIU6+Y18WYN
	KDhnmiKucCvQDv/qwJ2yyoQ/zamSj2A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2ACC163B04;
	Wed, 11 Nov 2026 22:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560B71F00A0C;
	Wed, 11 Nov 2026 22:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794434414;
	bh=Klp5K9ghajAt5QsaOTYOAUgTbWlX0z+ZRRZWnWqsMaw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OukkQprCZ8BTWe49RBUt3YgTJeQJMbZKVPQeEVjdZrT9CznBowYaEM56Y0XnPfSMH
	 ZMaS5pWq/tFHO7omypC1u7bOSQLrTYaz/WEFZLpLKdJ/v4Pwitnay1MgiS50XFz5od
	 ba5BtleXPHSIMh0nEMl0Fcp77XW/rZ6VsChAK/xB11cv1YDG2Lcjyo6H7zDuIwvPIf
	 Nhs7trqyi2rNwc1Sqjr4Ycr80XG7L/0NBr2dyeGO18KSR7lMyVk0IMq6Qk+3cedyAT
	 x6bEm3XlcZBnHhWI/Tt+TzOAAdD7V94aPECfgkHCGZuzOt8nDNQEUZpdD+tWbzYPu/
	 vFakotApI+kmQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 11 Nov 2026 22:59:59 +0100
Subject: [PATCH 1/3] mm/userfaultfd: fix PTE table overruns in UFFDIO_MOVE
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-pte_table_clamped_end-v1-1-2dbe339c487a@kernel.org>
References: <20261111-pte_table_clamped_end-v1-0-2dbe339c487a@kernel.org>
In-Reply-To: <20261111-pte_table_clamped_end-v1-0-2dbe339c487a@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Peter Xu <peterx@redhat.com>, Lokesh Gidra <lokeshgidra@google.com>, 
 Barry Song <baohua@kernel.org>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org, 
 Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3966; i=david@kernel.org;
 h=from:subject:message-id; bh=RpUx0NpY9p/6F0IgQ+tlhR7lPz8pKjk2jjthdIXwa2k=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLK+PE15t2VBklWqZvTEmQ+EdnNohZnO6C+/b7rbatP3N
 xYXc45f7ChlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAiFy8x/I++yXfxRKBCgr59
 Ulqubce2U1USkyIPSK06ZWm4ktts001GhhdiYrznr1mv26KnHbhBZR7HSuaDbeGaTw2N8zrsji9
 0ZgMA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: i571cwzuqmuopiw6ttad7xfttdr8tot9
X-Rspamd-Queue-Id: A17E412000B
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794434415-486352
X-HE-Meta: U2FsdGVkX1+kNSz7mmmy7YvUgP2jN+dhLIQ8zdPbySw61U3ioPAX9tFGgSCboAOGtbsc+YRBbNORX6ZMdP+sbMqwAIB4jdMhxPwmwMw59qTBJ3REQkhM6PfYZma6Qww77rvAc3iYoDStoqSEbMKaKvjsQOWPEmxKfVsazTqq2L1ojfiJH0B5wmQ3HI1Y1VlE2p21CDFWn/fqgWIz7RWRBA3JNFIdg7JozgLOltLnEkTsE01h+YvtJXRaHZNEXNJU4QJyzlwGnqAVqauKNRCApusnkBQSLSS7h30ZKJ+MRcPPN69HEHEDLVbxK2ck5kwHLz2VCB6VjOAcIpkuTb+JBROat7sh0DsRox7KHoeR6Ff1REtuxI0vlfer6Z595FegzC26ogeXyWzKcdZu/iZP0QVPx6rtpwtYuAc0TJi3bzp2WeIvQ9EvVJb/R6XkSn7SOs0Lf/W+HAt23xNSxlx1hGF0zo2jSHFxAXD3cZ3Av1IULFmu0RudkYwjoxBqM8sgLrjzO5snhXTO6odRXvRD306Yuzf0bWCJMmHlzPSV/9pAxi0o+TTh3y2iqzYYh2WczuqcRnjcDi3/1qSHmks9an0U+mSZ7EPlhyZ/TSgr+IDScZ4SzL5ENgkAIGrKNCjG5BehNgPsmqYrP1PQ/HUIKobbj4XgSoqGVaJ15E0Gf2hXdKU/hrUhQl8Lxu1mbVhZMhGfKwPjgtDmzDraw8ourk1PsPXAJUSY5TDsAlZfX6UtqA4u02LN+HaeuR7HTALb7REpcYO+O/1ZWhaFB1l0be3RRS0Y6c74R48fZJvNNpQ68dSRs7kY8PoIfGfrGs065rzMF7Tfr0Y15Xog8Vw1KQrc7Lpo/oD3GHk9dqfvBZbv3F1pN3cWLQYtOUzL+Ay45aYdLGg68qw07HIneF0hJWFklXiEqIahzOzWVlfT0kiV77qt8z1Sr0zQb/2hYrwsPkN7nX3ok0TX5HrcjYO
 0WUpEPg6
 EwIX5PI9aUaPFB5ZB9EMFprWaxSyOgJ4DpXNhIHcKq82S1JSczPrt+On9Y5pQEFvnizgT4CaY8eLZrN2AJzv+F1+1BzloX9cmBybcBflOW1md61Xt5Qf8xEUnTheTC1fG7G510d/Tqp0qvOaK90lsxTGZDPLGz1Y09IRdl0q63C4G8gZP/pVYvW1lqrgKJCxHbp6OJ8aJs2pN8Rjh9osfbwrbZ/Zyg03xhBimhM28z0bJBArjdSA6+9PFMLJP8jNkRv8rPkEpFNJAPKrtGGgxAIPQmL7rZGg7c499
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With a folded PMD, pmd_addr_end() simply returns the supplied end.
move_present_ptes() can therefore walk past the source or destination
PTE table during UFFDIO_MOVE.

pmd_addr_end() is only intended for page table traversal, in patterns
like "next = pmd_addr_end(addr, end);". With folded PMDs, a higher level
has already clamped the range to the PTE table.

Folded PMDs are uncommon, but can occur even on arm64, for example
with 64K pages and a 42-bit virtual address space.

Extract the calculation from folio_pte_range() into
pte_table_clamped_end() and use it to clamp both ranges. This preserves
the wraparound handling from commit f681d4580d5c ("mm: fix address
wraparound when scanning large folio PTEs").

Fixes: 50944692052b ("userfaultfd: opportunistic TLB-flush batching for present pages in MOVE")
Cc: stable@vger.kernel.org
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/pgtable.h | 24 ++++++++++++++++++++++++
 mm/memory.c             |  7 +------
 mm/userfaultfd.c        |  4 ++--
 3 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 780fe849ff8b7..66d369870a740 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -12,6 +12,7 @@
 #ifdef CONFIG_MMU
 
 #include <linux/mm_types.h>
+#include <linux/minmax.h>
 #include <linux/bug.h>
 #include <linux/errno.h>
 #include <asm-generic/pgtable_uffd.h>
@@ -1518,6 +1519,29 @@ static inline void arch_swap_restore(swp_entry_t entry, struct folio *folio)
 })
 #endif
 
+/**
+ * pte_table_clamped_end() - Limit a range to a single PTE table.
+ * @addr: Start address.
+ * @end: Exclusive end address.
+ *
+ * Only use pmd_addr_end() when traversing page tables, in a pattern like::
+ *
+ *     next = pmd_addr_end(addr, end);
+ *
+ * Higher levels already bound the range when PMDs are folded. Use this
+ * helper elsewhere to clamp the range regardless of PMD folding.
+ *
+ * Return: The exclusive end of the PTE table containing @addr, capped at @end.
+ */
+static inline unsigned long pte_table_clamped_end(unsigned long addr,
+		unsigned long end)
+{
+	const unsigned long pmd_end = (addr & PMD_MASK) + PMD_SIZE;
+
+	/* Compare inclusive ends to avoid wraparounds. */
+	return min(pmd_end - 1, end - 1) + 1;
+}
+
 /*
  * When walking page tables, we usually want to skip any p?d_none entries;
  * and any p?d_bad entries - reporting the error before resetting to none.
diff --git a/mm/memory.c b/mm/memory.c
index ec3d9d99ccee2..ee792a2c0ccea 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4959,13 +4959,8 @@ static void folio_pte_range(const struct folio *folio,
 {
 	/* Stay within the page table and VMA boundaries. */
 	const unsigned long pmd_start = addr & PMD_MASK;
-	const unsigned long pmd_end = pmd_start + PMD_SIZE;
 	const unsigned long lower = max(pmd_start, vma->vm_start);
-	/*
-	 * We cannot use pmd_addr_end(), as it does not clamp reliably. To
-	 * avoid wraparounds, compute using the inclusive end.
-	 */
-	const unsigned long upper = min(pmd_end - 1, vma->vm_end - 1) + 1;
+	const unsigned long upper = pte_table_clamped_end(addr, vma->vm_end);
 	const unsigned long offset = idx << PAGE_SHIFT;
 
 	/*
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 169f681f9849b..57650e6f040d1 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1266,8 +1266,8 @@ static long move_present_ptes(struct mm_struct *mm,
 	unsigned long src_start = src_addr;
 	unsigned long src_end;
 
-	len = pmd_addr_end(dst_addr, dst_addr + len) - dst_addr;
-	src_end = pmd_addr_end(src_addr, src_addr + len);
+	len = pte_table_clamped_end(dst_addr, dst_addr + len) - dst_addr;
+	src_end = pte_table_clamped_end(src_addr, src_addr + len);
 	flush_cache_range(src_vma, src_addr, src_end);
 	double_pt_lock(dst_ptl, src_ptl);
 

-- 
2.43.0


