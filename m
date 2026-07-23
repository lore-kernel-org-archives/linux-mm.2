Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F1BFC44524
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 07:09:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D3086B00A7; Thu, 23 Jul 2026 03:09:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AB686B00AA; Thu, 23 Jul 2026 03:09:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E7506B00AB; Thu, 23 Jul 2026 03:09:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA8786B00A7
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:09:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4CCAF14014C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:09:44 +0000 (UTC)
X-FDA: 85019166288.19.C27E530
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id A269B160004
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:09:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=faExG73Y;
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784790582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A/0eNGrxEa7E9jYLRTcnhd5V1x8yt7KnWGEHj6qTa7Q=;
	b=UU1T8IgNDEoSDEv0xMJxsPys8RVz5aVFeMrLAT+drVO9NYSH6pl7O267Pc9pBcFkei+n5x
	9sL4EU6II5vf3sky+7McqAjcr/snp7t2GUVvb9vz/HXgw4mCxyAkFXRbNUzZqSw/5ErEgk
	xYFYVm+2Sx5jWvjXG/BtkSJt2iimrJc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784790582;
	b=UGEEIe/cDa3PdD77+FnjXLS5Teei/ICjQA0F2kD9ZvCkL29cU0BDlgnlmonm9TRZpEvhFT
	eQhst7JOI5NAm5aKDJTk3PTX/szYHzgimv3r80JMdx5zpVv71IOljh9D/8s7p5fCIuSs9r
	+J93v92qTfxyYevDn6AQ2LzcP1u32Tw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=faExG73Y;
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A5D7516F2;
	Thu, 23 Jul 2026 00:09:37 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EB4D73F66F;
	Thu, 23 Jul 2026 00:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784790581; bh=GPC6aXjfbGgwNIGzWSYNqilrbH/gKJiFAOYSDNK3d5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=faExG73YH+Z5uC04o5uAaWAF9OGH+wZEoSymBYjpEfVW4yeFEQdhzSLmRiUwUpGlI
	 P4k+ff2DidbZDWpNGn7+Cq7CFSIIhb2kFlqIx7tLjFhSWk5308fQUzKtKiSn8kjLjI
	 d2pBvtey2UHCXNV4BmIt3zhS6dwFSvKojxuClZeE=
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
Subject: [PATCH 3/8] mm/rmap: mm/rmap: Add batched version of folio_try_share_anon_rmap_pte
Date: Thu, 23 Jul 2026 07:08:59 +0000
Message-ID: <20260723070905.3422276-4-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260723070905.3422276-1-dev.jain@arm.com>
References: <20260723070905.3422276-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A269B160004
X-Stat-Signature: tbnux9u7foehoocwofmd8yfn9617rcgw
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784790582-408954
X-HE-Meta: U2FsdGVkX1+jgiDclLZvPjciJGLsP4moo2kFAmDDH6R2LXc1HRpLsv+upv2Obhi4ikaPWySHRNpmG+v0hhlMbDOTHjkraqfPoiioRS9egm6k5JVBtSZj97xbup8JcyNOBAPoQ92PS1WlZw1jVqwbohLX3fud+xjPiUAYvp3jSX2OgOjGdAhdk+6cRTqr8+2LZNOPUWARQAF9epDutgzy1smBeqHFawjdY0JVuyGzJ+PADROXysutdvBtyxFs4ZmkSnZ0lSSobZlbUJtvOZD5P6ueEbg5ZmQCv7HWlFpSgNrEaXHtTTbAw8igqFyCq++XqgOxZ0ORo9LV/TWyQ/xrmjMqZiBXDTp64CmCIThtC+ELxYNy7GDHkP9BC/fCaSb24Drkr8Smk4JkY6kgNcO/Ky2JYcom5XG7qrgJYTL4SPn0UcDqCBHMgQpg0Xpf6qqcsq1JPFsqvewkQmzSlBL+BnsZFfXazkld+PG5mFubUSnrAwv1OO+xn22pRg1uSY0I09axm6R+UUXQCKrDh35tIOtm99wSmaH+ZzHLKiBUapu/riy36nKJB3zJ/6lbLpn0+H7cpd3b6u6zFS0chL679GKD2lk4WnYbLe1gCUSDBDr4zMvCpbdx6Mrrr2qxE5Izve13Rtgct7blKNvtlWGv8aNgrh797QXZwimHFy2mSAzNKbEKZTGnIIBtjPXpbr3ec1smHF56Q++wpvwYWmum0rjXK3gTzw34BGCHkVOsaCt6T0bn8juIBvfZrXZ30L3vaH3kR72W2CmW+AT0F3l3d+ou4hu5stvKIneAawtJ1tiLLGQF6ZADerqqGnq+WU9eUCiN0kLrU7YOiLVUOOmVFl6tMFg0+TcwAtAPC0mYzCtrlClWsARw19lq231qu1gPzVz14pvqS1lTk7E5FPpPhuwxovnC4BTYNmk4JWi/Q0GtqJ8b6EkVp3NeagpL6gG1Lw6I88QBmOvXRLTt3uy
 lTTGrrrI
 +hn684+IWsPZNN7LwGAL17vbbBM5Vnyx8yCmodPXBLGNYY+M+HhHCX0VngklMfNkccy7yVkjVQdRyFC7QyMK5uXGHa9Llw9r/CqjPdP9f1GAM3VvDrzQc5AZGjN3BRV7MUvOPfzWMOVqy1CfTSu5ovixI16zq9Desl2mc3X4eaS2JoI3xKQJGrMD4SmftE++fxjUNgJiEWmCuB+IzsU3m6wVePtFlh4rDZtnzHC2Grb921H0ydW4JCPtyHkxICQWWV91T1QMOwfbVGDjd4ZDPnUpe6+hdnaVoyT5umJoHVZGVFPo=
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
 include/linux/rmap.h | 51 +++++++++++++++++++++++++++++---------------
 1 file changed, 34 insertions(+), 17 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index a174758f77775..4c66c83d2228e 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -706,17 +706,18 @@ static inline int folio_try_dup_anon_rmap_pmd(struct folio *folio,
 }
 
 static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
-		struct page *page, int nr_pages, enum pgtable_level level)
+		struct page *page, unsigned long nr_pages, enum pgtable_level level)
 {
+	/* device private folios cannot get pinned via GUP. */
+	const bool pinnable = !folio_is_device_private(folio);
+
 	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
 	VM_WARN_ON_FOLIO(!PageAnonExclusive(page), folio);
 	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
 
-	/* device private folios cannot get pinned via GUP. */
-	if (unlikely(folio_is_device_private(folio))) {
-		ClearPageAnonExclusive(page);
-		return 0;
-	}
+	/* We only clear anon-exclusive from head page of PMD folio. */
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
+	if (likely(pinnable)) {
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
+	if (likely(pinnable) && IS_ENABLED(CONFIG_HAVE_GUP_FAST))
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
@@ -798,10 +808,17 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
  * Returns 0 if marking the mapped page possibly shared succeeded. Returns
  * -EBUSY otherwise.
  */
+static inline int folio_try_share_anon_rmap_ptes(struct folio *folio,
+		struct page *page, unsigned long nr_pages)
+{
+	return __folio_try_share_anon_rmap(folio, page, nr_pages,
+					   PGTABLE_LEVEL_PTE);
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
2.43.0


