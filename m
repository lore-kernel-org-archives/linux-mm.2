Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59210606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 05:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=NYIWBwOi
Received: by kanga.kvack.org (Postfix)
	id 7B7B46B05BC; Mon, 23 Nov 2026 00:36:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 747FE6B05BD; Mon, 23 Nov 2026 00:36:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 630056B05BE; Mon, 23 Nov 2026 00:36:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 449306B05BC
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:36:36 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB239A0824
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:36:35 +0000 (UTC)
X-FDA: 85465273950.12.E80B205
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2510480006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:36:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NYIWBwOi;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795412194;
	b=aVtFyubBxKxbi+e1XXZ8ue5dIysitbvfv/D4pNWDUzJqK/0+8jKJIiDG6cbvwQ4HW6IN7X
	c0AXq5hTLkZKvcvHmUVYWUbBj/U9qI0D+YcwD8kbDUcbQAcHM42hfaionBWO5pCfRU3ShG
	xrY0rXvm+ign1IzkHseETPX4jmCCnkM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795412194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KyYn1Hp5orcyjZVaPnJt+Dc1oo6+jLQecl36zvJIVPw=;
	b=Q1FPUviMa6ehMEdZk0bO9LquibDDrItkLXjAEkaMReRNd1zPnL5iWo/asUilkg6mCXVSJk
	F0LciKHzKCa1SxbyOBLxgcK81vuIX10KpxrEmLQ5S0kNGSkVJwnN4/k/ZeXTeHN19/mcz2
	xybXTAXKS/rv8LD/BjWC46rGXWvLtwg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NYIWBwOi;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6B6D81476;
	Sun, 22 Nov 2026 21:36:30 -0800 (PST)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9F5853F632;
	Sun, 22 Nov 2026 21:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795412193; bh=2sAHxMwZVt+mQEH8p6EH6hPst3GJLAjTOyTIcDEZw2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NYIWBwOitbfue9oBoEtThy6cFwGYgJZKJkw3FH7Hv2AXrAJEwKKMviQfELhJ0S94/
	 2YomsiEDY1CgF8wK/H1HKhaQrr1Iv9xo8C1pioPi3+povplGBlAcHhdQcsXpGWO1VW
	 1w91iskGIiU+Pu775GtmG4fCP7XckJsdC49pIftQ=
From: Dev Jain <dev.jain@arm.com>
To: david@kernel.org,
	ljs@kernel.org,
	akpm@linux-foundation.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
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
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v5 5/8] mm/internal: rename swap offset helpers to softleaf offset
Date: Mon, 23 Nov 2026 05:35:39 +0000
Message-ID: <20261123053543.295467-6-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261123053543.295467-1-dev.jain@arm.com>
References: <20261123053543.295467-1-dev.jain@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 894wgpijjpzxu48cej5teeqypw9no1rz
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2510480006
X-HE-Tag: 1795412193-490463
X-HE-Meta: U2FsdGVkX1/dWistJjd9NV0x7+n9WdGSsCxFVxoaa19NK8jWI4e/glb6vL2WM/KpWNdL/9Y5eZ/z8IBrR1NdhoRM5GidxEwk4OxRKfwflJs4F9+o93sEeXS2luRqb90azU7gXJtFJrk6ix0Ja0Bnc8PcUxrP9AHABSKxOq42S8f3CJqKpr6df2hDbU/Rca86wo4Yq9c15TZZ3woUxTpj2xmm7GqqJYi5PT+nNnjRx2Ks72c1oeUDjfhRf+ieKRA/rW/r7PoCd4z2sOsWOBFMZVdMSMCxN1jCp9dhW4y/VZqV8lABlbuUDUIIar0Ya1AAsKFdCA9HUL5kdNlJN0WaePSjHQj1gqlFCaK7pPZWLL5qFt2wcK6Gs6SrMKzO+uwDi/hr57FDh5KsRfQEO/EL+y14xBnvGKLHg8JfZD2I/lUYLmYbDfPgnkGAvrl0NxcXo0eeADuT+P/ETOSNDCZHK6f0FvmlbxHzACm3ONWp/N+Guh1oCKIYWF8j+MQZePqYPkpv3oQwwZTag6h1Pt7cX1x5Xlmxj3k+F2PwJ4LuKPl6Bbo2khBEZE6sqIHzF6tzYZ9OJMv7l/1TFFxWU1zNRQNbk0VVK8L8Gx2yjwVkaHSqsFXdmBG0cf1DHPdIevB6zMWuT0PDsRskayhuIcUDbFmPBnkhNegnXNFHmBLScOWsu45NkQ/NqxYhTJxTefMA4YIZUT/pD/PxphADE0WPwagIjP74aItgv0BF84hSfhBYYXZrLnovsT/kfwrlObo6B7HQFDABBxLejgUBtu1bcD6QEfcuSlFasj+rLBaGdjp+7ynaqNBNpR1SrI7i1+qoQkJ5h50dNkj5TMzfL/0OO322dfJGq+OxQ7gPoznOtUAZ7WKRF/WkrSojx71mGqC5DTPqo8Fb4k+CDHnYTMSC57haP7wUfzg8OPcESDNeFlQMgxGCNgT1kKcTJiG9LX1VnZb8jNfPFGW0/qW9RFX
 XUtaDTf6
 zxMsj9pmTYTWsdIaIOMIXOcb/rG2Mz56q7jr8vgETENIxXuNTrRgQkLh6LiMfv2tjxQ4Z+c8ok0dEnyTHZzYJI9GbDcDgjlxAW2uvb61E00h6CokEzhSuM/MD0/UDplxKluuFWev4rzZTnzsJOalPtZRwFu0GtYIQsvPNrp8dffrbwninoD80DfW8e0s7UJ7vcVjgzb92UrNZOiOdDcPFh8GG3frn0Qh3NCJkDjRs8NioTYZz2zmc8jGpt2dBneEnFzoinq2qzw5KCCD9Bq5BVLySVe77qZi+7uU/a/heaLo7oGAmLkf0VpV8GCdPaeaYttPNCTHL02cBWqmFSdUF1OfEVG6GpCiyZ6hkOdhyDgmBVZ7mgY6ZoNaSug/+JvlReqeHy0HTR/w/9FQvrkuiE8YY24uUfqiKEeeu
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
index 530c022117ab..ae0c37ee3406 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -480,16 +480,16 @@ unsigned int folio_pte_batch(struct folio *folio, pte_t *ptep, pte_t pte,
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
@@ -497,7 +497,7 @@ static inline pte_t pte_move_swp_offset(pte_t pte, long delta)
 
 	if (pte_swp_soft_dirty(pte))
 		new = pte_swp_mksoft_dirty(new);
-	if (pte_swp_exclusive(pte))
+	if (softleaf_is_swap(entry) && pte_swp_exclusive(pte))
 		new = pte_swp_mkexclusive(new);
 	if (pte_swp_uffd(pte))
 		new = pte_swp_mkuffd(new);
@@ -507,15 +507,16 @@ static inline pte_t pte_move_swp_offset(pte_t pte, long delta)
 
 
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
@@ -535,7 +536,7 @@ static inline pte_t pte_next_swp_offset(pte_t pte)
  */
 static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
 {
-	pte_t expected_pte = pte_next_swp_offset(pte);
+	pte_t expected_pte = pte_next_softleaf_offset(pte);
 	const pte_t *end_ptep = start_ptep + max_nr;
 	pte_t *ptep = start_ptep + 1;
 
@@ -547,7 +548,7 @@ static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
 
 		if (!pte_same(pte, expected_pte))
 			break;
-		expected_pte = pte_next_swp_offset(expected_pte);
+		expected_pte = pte_next_softleaf_offset(expected_pte);
 		ptep++;
 	}
 
diff --git a/mm/memory.c b/mm/memory.c
index ed6dfdb63994..a9a729d55fa7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4854,7 +4854,7 @@ static bool can_swapin_thp(struct vm_fault *vmf, pte_t *ptep, int nr_pages)
 	idx = (vmf->address - addr) / PAGE_SIZE;
 	pte = ptep_get(ptep);
 
-	if (!pte_same(pte, pte_move_swp_offset(vmf->orig_pte, -idx)))
+	if (!pte_same(pte, pte_move_softleaf_offset(vmf->orig_pte, -idx)))
 		return false;
 	/*
 	 * swap_read_folio() can't handle the case a large folio is hybridly
@@ -5191,7 +5191,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 
 		folio_ptep = vmf->pte - idx;
 		folio_pte = ptep_get(folio_ptep);
-		if (!pte_same(folio_pte, pte_move_swp_offset(vmf->orig_pte, -idx)) ||
+		if (!pte_same(folio_pte, pte_move_softleaf_offset(vmf->orig_pte, -idx)) ||
 		    swap_pte_batch(folio_ptep, nr, folio_pte) != nr)
 			goto check_folio;
 
-- 
2.43.0


