Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32085606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 14:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=rnEl8JfE
Received: by kanga.kvack.org (Postfix)
	id 50A2A6B05BD; Sun, 15 Nov 2026 09:40:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E1606B05BE; Sun, 15 Nov 2026 09:40:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F7BD6B05BF; Sun, 15 Nov 2026 09:40:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 206786B05BD
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:40:04 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB8004077D
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:40:03 +0000 (UTC)
X-FDA: 85437613086.09.7D91BC0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0F573A0006
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:40:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rnEl8JfE;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794753602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oWLng5YzApIvQWEE6IJStWoW8rEEtuEQhrOsRVUqFVE=;
	b=q7Ew3FZO7iAlQfVwhNiKiztwOa41PuXrYoqOcxrhvYN9VKgQVy9RapOjTbwnJn8mpSQDtb
	oLBd8Q7lYBneZGNA/Vc0TTT4RrweFp/Ng5Cxq8H4zKBsBMAlnkxzSH0jr7HNjg1yj349ZP
	4XZ05lmi9a8SgF0Plus/LDP9ejbsrn4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794753602;
	b=jqxfQDWMZ2u1OB95/5q5epELB0Pb9ULeUg4ZBfxpZ5QdYusFfZSFU13QO22gfh5J3Jz3zr
	2rIzw+E7NpbrQOp3mk7Mpy0x17ZVCN4e0/64aPfQMmkFVVsRRuN9Qw3/kTZ9wHqTvpoxo2
	dynPEp8x44+IMf9zmOLuhL9+xVNM7wE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rnEl8JfE;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 45EDE1476;
	Sun, 15 Nov 2026 06:39:58 -0800 (PST)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 72A033F85F;
	Sun, 15 Nov 2026 06:39:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794753601; bh=pgtQLSdPvGe0ty0udFZuTeEbxrBNucpn5ieVBBoFiSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnEl8JfErrG5vE5i8mspU+V2enh0DZgOVjgz87hQqDpxiUxdICBOLhW9cYCN52Szc
	 WWmxfDeIYEj2WCkGqRGmQFC/9C0yV6yIcuJCQ+WA/Zu/9v9eqKxE728GpHnkkxsvzr
	 coRULWL7f+BcfjmU4Gl61CaY9lNj3XtIUIjkwbv0=
From: Dev Jain <dev.jain@arm.com>
To: david@kernel.org,
	ljs@kernel.org,
	akpm@linux-foundation.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	davem@davemloft.net,
	andreas@gaisler.com
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	anshuman.khandual@arm.com,
	geert@linux-m68k.org,
	sparclinux@vger.kernel.org,
	ryan.roberts@arm.com
Subject: [PATCH v4 5/9] mm/internal: rename swap offset helpers to softleaf offset
Date: Sun, 15 Nov 2026 14:39:00 +0000
Message-ID: <20261115143905.3045084-6-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261115143905.3045084-1-dev.jain@arm.com>
References: <20261115143905.3045084-1-dev.jain@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0F573A0006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 8udkctd6g8zqjbcfb5w7trqgyc47k5a9
X-Rspam-User: 
X-HE-Tag: 1794753601-225603
X-HE-Meta: U2FsdGVkX1+6OrMULE8VQX/ip8GMQ/C/8vZ4Vp7AOqyN2kExiXPUldcprRpUIVAHo0BRiBUW1M3Z3Xe/R20JJ9umAxoMQSnjfB5CpNBjKnFR6PWOsqrWo1KTFuLZSllGEswsAafVg2pl8IdFB+cfY1dHmNRraYiLcdvGCs7AW4xGOgWkbdhz+KgYZdMhcTFJBI7ZF8XIm/iUH2kZQGRXzD9HBgBBjIgPVR/xFW0zDiwxxofTlt/dh0LaGcZkEFKEXbxh58EmikL/9O2XiXGmrER+VB29g+SOj4xwAffV8tblfg3O84pVoDdVUnT6Hca5MdjBk7EzDZgGbfXQVIa/sdz+lx/i08wNW85N1ocdoal/2J9vPKgba3mALBnOLGigBv1tQZc2huZrIgzx7pQDmpkbpmk2Z8wX6G3gg0q7v4Xp5PTm5u5WzXJ0ygnDntQnUwC5wWm41eGTNLqyuBRAEVTBYN+QzFDC1rYY/AjPZCTxvnOgISVO886EKEVSmw7Yc7UTXape452zraA84Nu0Gm2fIKQrS3Pp0mX3SmLLp2LGhRzkKQnRqnZ+ArFEeIaU3Y43B4pd54fmArg0SxEs0xfM0jwgyrZzn1MdqOvQF06tBOhw+0QB2jmIhOXsnuSqkddBgc7gAcaWyx9x2WitC3gEnIX5YgDTygLMXS3R1pPHHZQUWQOkcPDq87tLo/fjC+ZXmezKp3v0NCJCmE3c069cDwPllRzFkYsvVBS8d6uyc987TIxtSRmaTYtdW0sTZUEKNLhts53pUwMab9mlqZRbEccL41M5g9A2fcgmd902O38xZaU4C+DHGqBEd8FxdukbJzPB4ZhpvI5bAI3WxRnL2dgdivAGFa7Odf8ZBspZkCYvEzR2ANdilbKbKMYhKsIEWPhuOkBnstE86Tkd/3UN+nOBwG73XSD3CWvYgFdnWZzouEkrcJV/Viu18Ms1XW4IOOt/K3ODBIQN6f4
 tvU1DIgC
 M/5VJlKEWQlvNtwOLFl6yIyduvfdlqT2Okdqmp98m1fHP851CGpctn2Tc8IUr0GPKTgSUe+nEN/hLKySq5w44QbkwTAKsUQ69hxD84AIxvVQlgd14WRhkE1+IPf5e08K7aZFOOYVGT3zCR4HhxUPVBvLjveg5R8x7JtnxcQMebb1NMc4lSdlsZEEU9YFFla63MkKuZ7rcVikvy97kyOwjsgzxXb3DjiHaX8E3XnZWpJkIBUo8UloUCiiWqFfrRfoXRZnCA5Qa1eEERxo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In preparation for adding a helper to set softleaf PTEs in one go,
generalize the helpers that advance a swap-entry offset so they operate
on softleaf entries.

Softleaf entries use the same type/offset layout as swap entries, so
advancing the offset works for swap softleaves and PFN-bearing
softleaves. Preserve soft-dirty and uffd bits across the move. The
swap-exclusive bit is meaningful only for swap softleaves, so guard that
preservation with softleaf_is_swap().

Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/internal.h | 31 ++++++++++++++++---------------
 mm/memory.c   |  4 ++--
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index cd3675c044e0a..eaada62a86590 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -473,16 +473,16 @@ unsigned int folio_pte_batch(struct folio *folio, pte_t *ptep, pte_t pte,
 		unsigned int max_nr);
 
 /**
- * pte_move_swp_offset - Move the swap entry offset field of a swap pte
- *	 forward or backward by delta
- * @pte: The initial pte state; must be a swap entry
+ * pte_move_softleaf_offset - Move the softleaf entry offset field of a
+ * softleaf pte forward or backward by delta
+ * @pte: The initial pte state; must be a softleaf entry
  * @delta: The direction and the offset we are moving; forward if delta
  *	 is positive; backward if delta is negative
  *
- * Moves the swap offset, while maintaining all other fields, including
- * swap type, and any swp pte bits. The resulting pte is returned.
+ * Moves the softleaf offset, while maintaining all other fields, including
+ * softleaf type, and any softleaf pte bits. The resulting pte is returned.
  */
-static inline pte_t pte_move_swp_offset(pte_t pte, long delta)
+static inline pte_t pte_move_softleaf_offset(pte_t pte, long delta)
 {
 	const softleaf_t entry = softleaf_from_pte(pte);
 	pte_t new = __swp_entry_to_pte(__swp_entry(swp_type(entry),
@@ -490,7 +490,7 @@ static inline pte_t pte_move_swp_offset(pte_t pte, long delta)
 
 	if (pte_swp_soft_dirty(pte))
 		new = pte_swp_mksoft_dirty(new);
-	if (pte_swp_exclusive(pte))
+	if (softleaf_is_swap(entry) && pte_swp_exclusive(pte))
 		new = pte_swp_mkexclusive(new);
 	if (pte_swp_uffd(pte))
 		new = pte_swp_mkuffd(new);
@@ -500,15 +500,16 @@ static inline pte_t pte_move_swp_offset(pte_t pte, long delta)
 
 
 /**
- * pte_next_swp_offset - Increment the swap entry offset field of a swap pte.
- * @pte: The initial pte state; must be a swap entry.
+ * pte_next_softleaf_offset - Increment the softleaf entry offset field of a
+ * non-present pte.
+ * @pte: The initial pte state; must be a softleaf entry.
  *
- * Increments the swap offset, while maintaining all other fields, including
- * swap type, and any swp pte bits. The resulting pte is returned.
+ * Increments the softleaf offset, while maintaining all other fields, including
+ * softleaf type, and any softleaf pte bits. The resulting pte is returned.
  */
-static inline pte_t pte_next_swp_offset(pte_t pte)
+static inline pte_t pte_next_softleaf_offset(pte_t pte)
 {
-	return pte_move_swp_offset(pte, 1);
+	return pte_move_softleaf_offset(pte, 1);
 }
 
 /**
@@ -528,7 +529,7 @@ static inline pte_t pte_next_swp_offset(pte_t pte)
  */
 static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
 {
-	pte_t expected_pte = pte_next_swp_offset(pte);
+	pte_t expected_pte = pte_next_softleaf_offset(pte);
 	const pte_t *end_ptep = start_ptep + max_nr;
 	pte_t *ptep = start_ptep + 1;
 
@@ -540,7 +541,7 @@ static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
 
 		if (!pte_same(pte, expected_pte))
 			break;
-		expected_pte = pte_next_swp_offset(expected_pte);
+		expected_pte = pte_next_softleaf_offset(expected_pte);
 		ptep++;
 	}
 
diff --git a/mm/memory.c b/mm/memory.c
index d8466be900d59..5645f42c7152d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4802,7 +4802,7 @@ static bool can_swapin_thp(struct vm_fault *vmf, pte_t *ptep, int nr_pages)
 	idx = (vmf->address - addr) / PAGE_SIZE;
 	pte = ptep_get(ptep);
 
-	if (!pte_same(pte, pte_move_swp_offset(vmf->orig_pte, -idx)))
+	if (!pte_same(pte, pte_move_softleaf_offset(vmf->orig_pte, -idx)))
 		return false;
 	/*
 	 * swap_read_folio() can't handle the case a large folio is hybridly
@@ -5154,7 +5154,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 
 		folio_ptep = vmf->pte - idx;
 		folio_pte = ptep_get(folio_ptep);
-		if (!pte_same(folio_pte, pte_move_swp_offset(vmf->orig_pte, -idx)) ||
+		if (!pte_same(folio_pte, pte_move_softleaf_offset(vmf->orig_pte, -idx)) ||
 		    swap_pte_batch(folio_ptep, nr, folio_pte) != nr)
 			goto check_folio;
 
-- 
2.43.0


