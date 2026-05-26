Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFFE1CD5BCF
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 06:38:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E9806B00A2; Tue, 26 May 2026 02:38:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C0626B00A4; Tue, 26 May 2026 02:38:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D6666B00A5; Tue, 26 May 2026 02:38:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3AF4D6B00A2
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:38:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0353E1402C8
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:38:29 +0000 (UTC)
X-FDA: 84808617138.13.ADCA9C6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 49C5BC0002
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:38:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ibIf8yAH;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779777507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hG17J3Z1GKKE2GXcRKGDG7u9bX/Dmjr+iYEhAFf+WMY=;
	b=Cn+76iSkKi8+JokjZjlv8E3xFA2g4fHQn3oMSHG/9ZyMbOkF42lDJh7DF7+d4YH/0I9oZw
	1H8cnumnVipvpHFpfLNViGfeo3YmV6GHiOO+haIx5dvAIDo5xt41xV62Nd6V9+wCBvt7we
	ejsNyBXGF5BtV2gaYoSDF8AoFLWLhQQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779777507; a=rsa-sha256;
	cv=none;
	b=sTNweh1hdqgy/doawJlZTKuOpnSzXdDPESrXwqUDbkzaTFyx2t/5S08e/FDTCQkaPdAyYq
	PU+BvhPAwlkWX8u7n0FT7Y0q6xbWi9wcy25X9VnmPiNNidm+6OA4XAJ+REhAj6G/Q/LnK6
	qV9aW7rqtuqYNVcDfFAKSgbilwTyCao=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ibIf8yAH;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 78ADD22FC;
	Mon, 25 May 2026 23:38:21 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D98683F7D8;
	Mon, 25 May 2026 23:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779777506; bh=Gvx/Kb5XuiTOgCvken+/31zz+LIsv8TKngc1TMiafk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ibIf8yAHfrhdjxWvrAS5TzBxXi6L6v1hS0RK2Etic5vYyGqEkiVuUD/KzF4GbrNLC
	 2sehhKkGT3UcwwKb7EOE/371CgMTnoB99WjWg/4ShdQt06ikxp96YxwMCgP8cVFUrI
	 nkWjNoaWLjEG9Q7z19lZruZXLRl0n48r+4p8qLhY=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hughd@google.com,
	liam@infradead.org
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v4 09/12] mm/rmap: Add batched version of folio_try_share_anon_rmap_pte
Date: Tue, 26 May 2026 12:06:32 +0530
Message-Id: <20260526063635.61721-10-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260526063635.61721-1-dev.jain@arm.com>
References: <20260526063635.61721-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: hg8zp4d9hetfwazypxyazn6try65tdz3
X-Rspamd-Queue-Id: 49C5BC0002
X-Rspam-User: 
X-HE-Tag: 1779777507-719457
X-HE-Meta: U2FsdGVkX19d+4dfK+Pw6b+rhkTsDq3swe9Zf8D2lER5WRBAjVIQkS8TEKemXN+ngywjUcNu03JkXvwNo9ZOiuGc4ZOkBjgEHzJEA5PUegYjhV+IHwIiEE0H6iIl3gbNvJq3N9Gzzr4ddFXma23QjLp0Jyu2/cymi8UTy5ggqN4E+GxfLr/rB/piib7cOoT7QLp01HienOIba8ZpBsIobHqreBZwYbXfT/p2P1mmSlrVpmsX4T0ChDx4c75SZ1rqIrpoNBv4FMIgrzcH6VDTxxC6Ng9++VDDEi7SrsXRLUmzLPLIbOqfTSzd93+iuyXd1/4DZrcl732GQpMiB4jH6YOVtmV7VVD8caeUN0HE5iT/h1ab/0jIGlSZogfejkL3VV+37G064uFg+UjqTEbBWlLBhueZeH7H2t5tjqC5zzyIjhvuITvyQ6fNLrAwWrdxkv1D2bEbau4vQxxx0Scw+ltnAWlNCylIRe1OUpYDW60tiH9A2Jzqp1CdvVUqi5Js9r69c4bBegoViCwwvcvQJJ+1hO1CH38KUOG+bs+zQ76A7GCJb85o6acUZSOlzuflGYhZMsI953KtzrkLVBEzSpYfpkfK9ln+2fBtbVqp4WCDDJDiy2IwSK0hvzmmMz0FQKUoJ7OXiChgVxvNCsMBPxxDll6LPOIkbvhML/1IOfRCJEwHPBWjWKkjzhTgDIzEWdWId1fKv3K76prx0/5HqfvK85oCfuvd2BRNVJ0RjPyaPy1zBMO9Pj/qKdd/h3cL6pN/yjvnT40VXNNOpZKJ5Hxz4or2Uw7swK+uR5BnY6e/zQ535VNypiPldcJ8ShrFoaZavMw2gi0AOMYn3mXIgoAq6ddpkTwY+4+CdS0yeF92KSVB6yPZ0KJbq0/wXudaDkeExMfkIdpAQQdYUILn4lJa5S342497E8Tyl+dJA6wXAxSAfJpcP2lqd96643zCYOzu6ItsYzgN+iceqsh
 SvOk9YEu
 baEPT0nWAaU45j744PwMcFRraYYd1lOjGcT282tcaSzeQ3tzjfl4ETxDbUcd3xJne7GIbFhvLBwWhSK0sTDM4LFhpYaMxTehv7BwfwSYYiz37VaIJWIiG9XIpANgZSaaLAzYG+ugEECpfQ8bE23/17TMOYMHKo2AkGxdyLOSMvNYTyLgSbYvBkkTyVAN52wtW3J73a0l4R9BH63cpPgZB+IOb1WI+EeoTNh2zE5T2AmxQ3lDOVADEfZ0occ2fkMGUCPKkWQMV987zUm/FP2G2j9bAQXsExvRcDRlf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To enable batched unmapping of anonymous folios, we need to handle the
sharing of exclusive pages. Hence, a batched version of
folio_try_share_anon_rmap_pte is required.

Currently, the sole purpose of nr_pages in __folio_try_share_anon_rmap is
to do some rmap sanity checks. Now, clear the PageAnonExclusive bit on a
batch of nr_pages. Refactor the function such that the clearing of the bit
can be done at one place without duplication.

Note that __folio_try_share_anon_rmap can receive nr_pages == HPAGE_PMD_NR
from the PMD path, but currently we only clear the bit on the head page.
Retain this behaviour by setting nr_pages = 1 in case the caller is
folio_try_share_anon_rmap_pmd.

While at it, convert nr_pages to unsigned long to future-proof from
overflow in case P4D-huge mappings etc get supported down the road.
I haven't made such a change in each function receiving nr_pages in
try_to_unmap_one - perhaps this can be done incrementally.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 include/linux/rmap.h | 52 +++++++++++++++++++++++++++++---------------
 1 file changed, 35 insertions(+), 17 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 8dc0871e5f001..64929490a7cfc 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -706,17 +706,18 @@ static inline int folio_try_dup_anon_rmap_pmd(struct folio *folio,
 }
 
 static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
-		struct page *page, int nr_pages, enum pgtable_level level)
+		struct page *page, unsigned long nr_pages, enum pgtable_level level)
 {
+	/* device private folios cannot get pinned via GUP. */
+	const bool pinnable = likely(!folio_is_device_private(folio));
+
 	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
 	VM_WARN_ON_FOLIO(!PageAnonExclusive(page), folio);
 	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
 
-	/* device private folios cannot get pinned via GUP. */
-	if (unlikely(folio_is_device_private(folio))) {
-		ClearPageAnonExclusive(page);
-		return 0;
-	}
+	/* We only clear anon-exclusive from head page of PMD folio */
+	if (level == PGTABLE_LEVEL_PMD)
+		nr_pages = 1;
 
 	/*
 	 * We have to make sure that when we clear PageAnonExclusive, that
@@ -760,29 +761,38 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
 	 * so we use explicit ones here.
 	 */
 
-	/* Paired with the memory barrier in try_grab_folio(). */
-	if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
-		smp_mb();
+	if (pinnable) {
+		/* Paired with the memory barrier in try_grab_folio(). */
+		if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
+			smp_mb();
 
-	if (unlikely(folio_maybe_dma_pinned(folio)))
-		return -EBUSY;
-	ClearPageAnonExclusive(page);
+		if (unlikely(folio_maybe_dma_pinned(folio)))
+			return -EBUSY;
+	}
+
+	for (;;) {
+		ClearPageAnonExclusive(page);
+		if (--nr_pages == 0)
+			break;
+		page++;
+	}
 
 	/*
 	 * This is conceptually a smp_wmb() paired with the smp_rmb() in
 	 * gup_must_unshare().
 	 */
-	if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
+	if (pinnable && IS_ENABLED(CONFIG_HAVE_GUP_FAST))
 		smp_mb__after_atomic();
 	return 0;
 }
 
 /**
- * folio_try_share_anon_rmap_pte - try marking an exclusive anonymous page
- *				   mapped by a PTE possibly shared to prepare
+ * folio_try_share_anon_rmap_ptes - try marking exclusive anonymous pages
+ *				   mapped by PTEs possibly shared to prepare
  *				   for KSM or temporary unmapping
  * @folio:	The folio to share a mapping of
- * @page:	The mapped exclusive page
+ * @page:	The first mapped exclusive page of the batch in the folio
+ * @nr_pages:	The number of pages to share in the folio (batch size)
  *
  * The caller needs to hold the page table lock and has to have the page table
  * entries cleared/invalidated.
@@ -797,11 +807,19 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
  *
  * Returns 0 if marking the mapped page possibly shared succeeded. Returns
  * -EBUSY otherwise.
+ *
+ * The caller needs to hold the page table lock.
  */
+static inline int folio_try_share_anon_rmap_ptes(struct folio *folio,
+		struct page *page, unsigned long nr_pages)
+{
+	return __folio_try_share_anon_rmap(folio, page, nr_pages, PGTABLE_LEVEL_PTE);
+}
+
 static inline int folio_try_share_anon_rmap_pte(struct folio *folio,
 		struct page *page)
 {
-	return __folio_try_share_anon_rmap(folio, page, 1, PGTABLE_LEVEL_PTE);
+	return folio_try_share_anon_rmap_ptes(folio, page, 1);
 }
 
 /**
-- 
2.34.1


