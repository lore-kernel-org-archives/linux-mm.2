Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC21CC531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 07:09:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 815396B00AA; Thu, 23 Jul 2026 03:09:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EC826B00AB; Thu, 23 Jul 2026 03:09:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 729BA6B00AD; Thu, 23 Jul 2026 03:09:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4317E6B00AA
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:09:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AF04240119
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:09:51 +0000 (UTC)
X-FDA: 85019166582.21.AC20D50
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 018B110000B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:09:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sAhah4yA;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784790590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NEW6TCfzCKpuhrigL0iMVuRf3rDXBcfMhBz1pCOsnNM=;
	b=FwhVo9LLXDPyYCSs2DX8GjJPnAuzwNNBLiD5s9oUwgXtXNR5bQkUYTnbuoGB4rjHN5XcXs
	VDoU4VzgNc+AzCy6hIwjFAfADxdDAYDlRw7bXiyplxC+YyoJlgfJZrEKWqroL3+1OglBH6
	2oh7buFUl1hdRiqdQcqgXlfr9sXyuGs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784790590;
	b=PIeLSnTa5dePleHBRrxF72kelArRCY6hfZ06RXdC7xUdfnd2A2Fs0JkFFnZw2+P/+AvVy9
	U9BDiLgHpYU6UY8UsA007rrUXkvuMkxCfliAOCuaP6bnTbT2A2x3YEiIvdQvLcEhux1HXA
	b/ZnA0jVsT9fFfWemqYfCwnwbyDEky0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sAhah4yA;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1FE6C176B;
	Thu, 23 Jul 2026 00:09:45 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6055D3F66F;
	Thu, 23 Jul 2026 00:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784790589; bh=8z/IjN6A8ouMBXAvCBuKGoi4RW1OBOi0aq0dGUH3uLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sAhah4yAeGvs882Pyx2OtXKfBtyWfijIeC2XeoNNnu2KzC28X7QCnrMdJZSI1TXN+
	 5/UhHIcdkSFdIzqJJMaDPv28kAVLfgcR7DrFYOe75E4kGwlMMXT7pDfMMOqYh065Bp
	 L7DshNrVQm+EfglmkE28btTHS5aWw6jcgkpsbv18=
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
Subject: [PATCH 4/8] mm/internal: rename swap offset helpers to softleaf offset
Date: Thu, 23 Jul 2026 07:09:00 +0000
Message-ID: <20260723070905.3422276-5-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260723070905.3422276-1-dev.jain@arm.com>
References: <20260723070905.3422276-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 018B110000B
X-Stat-Signature: 45m5d8pgsw5f1ys85b5x46gyzk8ro91o
X-Rspam-User: 
X-HE-Tag: 1784790589-772329
X-HE-Meta: U2FsdGVkX19fy1iZ0MHIOJXwGajrgWaFeQsJQx9RrtkPmka5FsTYYjN+4F28EXfeX3N7x5pUIeDWs04ivv5E10jhn4GOAf6UGZukiEkJXPyZzVuo3lpJX7MojSAxQcdbS6Wa/BjcGyDYaJbHD3To8yme5X4tr4v2xD5Ozl+n+po3BPqx1P13zKZEef85nGpJppIT0szsWqWUTZkzRd8fxGbE8Ml9uvC239duNopVYszhLGqZT3/Fa6YFHEHnnQDyaqgo0oN3gcGg1N4Cium0reW1ZB/nzvUtj2dV+vq7E3pweNhZLKvmMPDH5K/5go/hyk/gkjtZK2c0ZvFL+BRWWmYM946EERag4XBzfgQmHNq5fkVnHekt6bE+nUpdcdGV8XZEOKcE2MrsYXPSPpUnwmLqL7tBDEptju5utDBhUiQ79UUq+1c+e17azac1MC7ZaM4vt4Ye7GBghb5H9bTg4IgXARDhPYBs76d8N2d7jveQclDapjLNM9g2ZeNGmXg7HflfZ4EIgyqxmVdT56mdXBkf0FBXJJPsclOn7dFhI/1X4wIZIdpoNcRj2XbMbVjxNlM4pO5U7uGQNgQJXqIb1ryU6JWGSAbgxCX9X9APFBa8tM67qjQK3VfM8E1LtjYuLdfJ+Lvgl4up+XCfcAGPnhJtRv9pkHd+yvqaUrVTDT2yb3Gq0ryDwJq2eDUAMmUz8GKXEe+niNk0F+Rb9RpfMQTJlg/rqiSJTV3QHlypDlIvHsS5PNkxyRcG9b0kiEs4wFfVFE36NDMWjt9/g+Wsh7Rs7sfob5nIIho9+rtW+TFDPvAePL9VcqHA0VbQ90lG7xqTQs2BMdR6r9pyD++F6XBZW8+6YkmnUldHa7J7ciiB5R6PpeKF4uPPINaolpCKsBPFxzbtBi50nRpFVk5067UPFkLtWNUY0dvOFR4YKdiNCMzRrwHDJ1KoIWbPmc6Mf3yZ5QCWFqnFamZqc0g
 rcjWR+Bu
 P+sV6GPiMS9EO+bVk+8ZfpNcesfQ3gziXm6jkd7spR2JrmS0o8tpzMqeY18g/zdkR/z+SU9+No0zyAO7hphN7F2Z7ys286m96CwJydZ5VqeCU0QVSe3RpMRfCmZ6A+XJPYUqSfmDY5+lQ6LWDgggTIFDyKfbNkMfGuGh8jgegKUKDOnrIJz0XX5Rw3DviYiow1DLxlE1xph/HWaxPQCJiIY+i2Y5UWMVIR8eo1gSbDDOp0YsedfNjLbufAw==
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
index 51ee4c1310908..ce52188a8a65d 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -475,16 +475,16 @@ unsigned int folio_pte_batch(struct folio *folio, pte_t *ptep, pte_t pte,
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
@@ -502,15 +502,16 @@ static inline pte_t pte_move_swp_offset(pte_t pte, long delta)
 
 
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
@@ -530,7 +531,7 @@ static inline pte_t pte_next_swp_offset(pte_t pte)
  */
 static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
 {
-	pte_t expected_pte = pte_next_swp_offset(pte);
+	pte_t expected_pte = pte_next_softleaf_offset(pte);
 	const pte_t *end_ptep = start_ptep + max_nr;
 	pte_t *ptep = start_ptep + 1;
 
@@ -542,7 +543,7 @@ static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
 
 		if (!pte_same(pte, expected_pte))
 			break;
-		expected_pte = pte_next_swp_offset(expected_pte);
+		expected_pte = pte_next_softleaf_offset(expected_pte);
 		ptep++;
 	}
 
diff --git a/mm/memory.c b/mm/memory.c
index d88df15018268..7a8442fda0b51 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4753,7 +4753,7 @@ static bool can_swapin_thp(struct vm_fault *vmf, pte_t *ptep, int nr_pages)
 	idx = (vmf->address - addr) / PAGE_SIZE;
 	pte = ptep_get(ptep);
 
-	if (!pte_same(pte, pte_move_swp_offset(vmf->orig_pte, -idx)))
+	if (!pte_same(pte, pte_move_softleaf_offset(vmf->orig_pte, -idx)))
 		return false;
 	/*
 	 * swap_read_folio() can't handle the case a large folio is hybridly
@@ -5062,7 +5062,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 
 		folio_ptep = vmf->pte - idx;
 		folio_pte = ptep_get(folio_ptep);
-		if (!pte_same(folio_pte, pte_move_swp_offset(vmf->orig_pte, -idx)) ||
+		if (!pte_same(folio_pte, pte_move_softleaf_offset(vmf->orig_pte, -idx)) ||
 		    swap_pte_batch(folio_ptep, nr, folio_pte) != nr)
 			goto check_folio;
 
-- 
2.43.0


