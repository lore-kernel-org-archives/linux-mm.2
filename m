Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26E57C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 05:44:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FB876B00B3; Tue,  1 Sep 2026 01:44:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D2736B00B5; Tue,  1 Sep 2026 01:44:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C24B6B00B6; Tue,  1 Sep 2026 01:44:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E45FF6B00B3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:44:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 666A7402E1
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:44:50 +0000 (UTC)
X-FDA: 85164104340.26.76FCE5F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id C56F1100004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:44:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OAoPFr7R;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788241488;
	b=W1VlZb38mIrNt2fLFvEGPlQbpJ7BvoJ0Lbrmc9wGiAdct4RDIORd9ArMbXGWXlT2b20C3F
	tU/owY6zSYk2kP/nbGOGIexYAocRWxHTtaxYpb9tX4N8GbeG6Tjl0HsBDDgAn6MWtBGiPB
	6HeRiJc+r15Us9dCd5diqBm/AlBqnvc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OAoPFr7R;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788241488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bKBtMpFYP71OoY2amCZiuS9HnvoqRWrYz9R1zYjBN28=;
	b=4EyLEMjT1u5CqdT8VVNVjxaK3iDHfewEznof9G982W40fJeSXQ233XX8qZ2bpTYwMk+oP0
	mkdvAe3XqfbtJizsOvYNFkDK/sWJeTajkROduHaUANpxMOGGGnsnHNGMElxvupgg31qCEz
	n71/fEsuGbZE4WXrqoIkk61V6kFpd3w=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0B91B1AED;
	Mon, 31 Aug 2026 22:44:44 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EBF573F85F;
	Mon, 31 Aug 2026 22:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788241487; bh=BVSsEb8Y4xZRhSjlcLhU6nuyLKvRJakBNGn8zZZjAdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OAoPFr7RxqkStsgeCzWgVlGw7svdApDqRN/OJtlKUF6uq62xSS8tpChKZ9r72yNBM
	 JNM+uw/lf8lkFIZnS/YHdWkWq5kkT8UNU57mRx0n10nqWOm8xAJ5fgQELW4tf4mPP1
	 j01pd9nAh0f1UPXHsUU3/HoTniu443zYt6IzEM0o=
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
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v2 5/8] mm/internal: rename swap offset helpers to softleaf offset
Date: Tue,  1 Sep 2026 05:43:52 +0000
Message-ID: <20260901054358.4049095-6-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260901054358.4049095-1-dev.jain@arm.com>
References: <20260901054358.4049095-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C56F1100004
X-Stat-Signature: y6jiowfkt896bo169pibckeowqbkcwwn
X-Rspam-User: 
X-HE-Tag: 1788241488-693095
X-HE-Meta: U2FsdGVkX1+9DMd73IOzgKZQD1z3h6FN8yuJKpI4sSgeMbOMYILybQMsRlEMFCEIjK6is/o+3zbvyB1IIVspIWfdfpgV9XMcQqEgEBzd/Ytn4SmaJgwoIWbCyBUn2JoOk58tWDfAvoUTK6lGtwcEv9lTlxWTjwvBLpxvLx3R4FNSjwuZ9Ddj+sNb/+zeS4PYy+/ELIP8RN/VcHiLhbwgrvHyRW8h7nkaiiGDpAeY/VlbYRmVeuoOOmao1ZRt5VcP15MoPiBzIFgoGpPNoMknbamFjJVweTVVrfczxjy+NKqJy+I/RNBdIbh5LPmKb1BBPQvtuowQiLHtsJfVR8oMq8MHDtq0D5O6z+WpVJELimeJxnlWVk6lCY/4Ntrao1xKa3UDGSbYJEYcm9oBqvBadf7F7c+4grgrLaYazJJUEk2RNuMgMR1/3hkOwJUX4afg8ab6GcwfmEdyaNn7XGq2AVY3f4sTfWLYTEgT8q6emSZhetU3U1I15Zqz4NTcRcxiCRO+hMfQeFo78TXL3ZJ/V6ewR44j1tPUAuN8Iu82kt2pruXhmWbQr6FBr3PUKufhFSHKUVypjA+oERpCwR+oIZCQAmck+vBLs7ZPphoo5EUuiWzR0evgKsA1cD151uZiR6+sYiMsXj3L46uVP0EMRVDZ0PXVNt3djEgF0zt34gJWP0nBKovZjkNhdZAv6BS7CBdcvVpjLHaVaFMnG4TrHkyM8JSse6D0B7tmipXOSrPsdQq1lIv3g54pRehhsSNoCKKDMvz4m8DHSeaYceIhP4oZYd5DRTqE/RuSsakmublrN3Tpm5qPouthOd2zm5KxDkdgCvkThCni4+k3h4pxB81bp39sr+eR3OcNGCWeFw4Fmw2lMlDb7xwB44KaIJ4wj26zuBeiaya7vm9UTTzg5/shsJVOEU8YvGVJGgcr71ZyWpd6sCmGEJB7Z7EEjx1OdhuyRaZ1BJstr7Znyup
 k6L/lCjF
 viLdJ8BPrTgKv4we7NAT0WLeUaAkCFSh8EbbKnOUNjsB3JbquWMvc857+4TIlEP1yC70Jdm468mK4EYlST4c7D/B8izrJSFUrJHx2fNgRJorauB/rf1pNCoY19KVVK6YTaUgSYgEd5QwwAAqaaXLxZZ2/jn/SFRsS3vtMkuzR+ISVSlGXo/2b+BCdU3D2l7NL6Sagp/xgCggBwnmrdqjrQTt53Bbwy8CwRCKDS965QNAUDKcvpZ+yXLfrqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for adding a helper to set softleaf ptes in one go,
generalize the swap entry helpers shifting the swap offset by delta,
for softleaves.

Note that the soft-dirty bit, exclusive bit and uffd bit preservation
will still work for non-swap softleaves, since a softleaf entry is
constructed out of a type and offset, and those bits are ahead of
the soft-dirty, exclusive and uffd bits.

For example, for a migration entry, pte_swp_exclusive() will return
false, as the exclusivity is encoded in the type itself
(SOFTLEAF_MIGRATION_READ_EXCLUSIVE).

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/internal.h | 29 +++++++++++++++--------------
 mm/memory.c   |  4 ++--
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 38b1165212c94..cfea888366d58 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -468,16 +468,16 @@ unsigned int folio_pte_batch(struct folio *folio, pte_t *ptep, pte_t pte,
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
@@ -495,15 +495,16 @@ static inline pte_t pte_move_swp_offset(pte_t pte, long delta)
 
 
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
@@ -523,7 +524,7 @@ static inline pte_t pte_next_swp_offset(pte_t pte)
  */
 static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
 {
-	pte_t expected_pte = pte_next_swp_offset(pte);
+	pte_t expected_pte = pte_next_softleaf_offset(pte);
 	const pte_t *end_ptep = start_ptep + max_nr;
 	pte_t *ptep = start_ptep + 1;
 
@@ -535,7 +536,7 @@ static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
 
 		if (!pte_same(pte, expected_pte))
 			break;
-		expected_pte = pte_next_swp_offset(expected_pte);
+		expected_pte = pte_next_softleaf_offset(expected_pte);
 		ptep++;
 	}
 
diff --git a/mm/memory.c b/mm/memory.c
index 6cfea4faf0588..7ce8413a8117d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4757,7 +4757,7 @@ static bool can_swapin_thp(struct vm_fault *vmf, pte_t *ptep, int nr_pages)
 	idx = (vmf->address - addr) / PAGE_SIZE;
 	pte = ptep_get(ptep);
 
-	if (!pte_same(pte, pte_move_swp_offset(vmf->orig_pte, -idx)))
+	if (!pte_same(pte, pte_move_softleaf_offset(vmf->orig_pte, -idx)))
 		return false;
 	/*
 	 * swap_read_folio() can't handle the case a large folio is hybridly
@@ -5066,7 +5066,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 
 		folio_ptep = vmf->pte - idx;
 		folio_pte = ptep_get(folio_ptep);
-		if (!pte_same(folio_pte, pte_move_swp_offset(vmf->orig_pte, -idx)) ||
+		if (!pte_same(folio_pte, pte_move_softleaf_offset(vmf->orig_pte, -idx)) ||
 		    swap_pte_batch(folio_ptep, nr, folio_pte) != nr)
 			goto check_folio;
 
-- 
2.43.0


