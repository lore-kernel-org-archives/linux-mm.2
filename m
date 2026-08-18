Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48F37C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 22:59:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3190B6B0098; Tue, 18 Aug 2026 18:59:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C9E46B0099; Tue, 18 Aug 2026 18:59:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DF986B009B; Tue, 18 Aug 2026 18:59:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F01446B0098
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:59:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 058891C1197
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 22:59:37 +0000 (UTC)
X-FDA: 85115908794.19.745F080
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7FB1320009
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 22:59:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uf7uLp0G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787093975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4aVhpGd68r1Svhk9UlnG+UFWV77hKbotB3T4QNwx1S8=;
	b=dt6eX6OR+qdOdfVOPCRWk0lTrXq2wp0R23wZEqhaoRwSbLwsDqyLJsYH5HBdWJ/riyVj36
	bGrt5UsShnagU/XmnuJ2DGPMHUleuvBfsN//IeXhuUvbQG80O3wm3BjWy8cUWfliNU5aeg
	GQuK5uLy2xFHV9t+4XDykkGkGeMtIG4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uf7uLp0G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787093975;
	b=6bqdT/EkDl4iBJbbdl7YSWvvuVtufq44zqNOwgvtdDPGT5rQl3BJLtR+iGmzWcIGWT8MpG
	CCcIlnblkUF1BNzD19ejD8cVDCb5RV0ccMpM3TrZLj5BRJnWky/vcMpFKVat81zAhvYYDP
	P/2FYn8JbcZDkVkouXh7AzF6r8PBct8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 22FD760A73;
	Tue, 18 Aug 2026 22:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D821F000E9;
	Tue, 18 Aug 2026 22:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787093974;
	bh=4aVhpGd68r1Svhk9UlnG+UFWV77hKbotB3T4QNwx1S8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uf7uLp0GpZigC8Y5cRL6A8Gz8Jk/Vkjh8NM6RbMLIxU0PqW6ohlKIhZaD4ha3efb0
	 9S482ouY+T64y3pjTDdmXHkPSfspoY6PZrcU3GTpmEo1yA5Em9kwBhBgkAshDJl837
	 d8DZ+6ksTmIIkXvJlFXFA2cBfAiSLxziS0Owt2EFMGMhc/jszU9saDwWUWq4O+/AAz
	 t6Sz87oictEI4wwBuolMSpL952R4tUXl9roESqZ5F56hRbE1fhHJwXzl2U0b1qbxK/
	 XR7r4/OliS3mh2ixRQfwFSH+m+rDb+i4CyrwXzdhKyKbEsx1b9jq7GcJaivvozpxkG
	 cvrVpE5CZVfWg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: baolin.wang@linux.alibaba.com,
	david@kernel.org,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@suse.com,
	npache@redhat.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	surenb@google.com,
	vbabka@kernel.org,
	ziy@nvidia.com,
	hughd@google.com,
	ackerleytng@google.com,
	usama.arif@linux.dev,
	joannelkoong@gmail.com,
	hannes@cmpxchg.org,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v3 4/4] mm: batch lru_cache draining in deferred_split_scan
Date: Wed, 19 Aug 2026 06:59:04 +0800
Message-Id: <20260818225904.55236-5-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260818225904.55236-1-baohua@kernel.org>
References: <20260818225904.55236-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ne5phsnc6y9c35jhsgha9bucyy4gfnn9
X-Rspamd-Queue-Id: 7FB1320009
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787093975-67941
X-HE-Meta: U2FsdGVkX18Qw6vm8oKivwbKdRAobnliLHRdJKrk8ksxQnEO3FzFfXHEFujN4KNk582/GLAzQ3vlMZ9O68ujhiwKsvfxeJzlUZvWbbTx24QPhWrC1JjRsOTd4n6ZZ6FLASVev4/HYy4VcNdp+LKaetX9i0yWdiFg5C3o3fA/QOYAYU6w+OfQ5ocEdlz9d2Q9iJgIqjfjfVzOySwsjiarVON0Fidr69Y+K8XYsLf+LI0gjJ16a3X5MEU5nCSJ52IOg0FTR5cHlMlfkrPO2fsGP8LT3h1uolJLY1+3Hul9pRR1hS+GReGHY656HbcuVNxJHsCRo+MikqIiKyrpWhjX2bhGHf6YwUZCd2EkjAOlcF5nQ+nRNiogp8Efjzkrcc69g2HF6FyZKOa5Uy9vlNzN05o6MjtxV3JxWNe63xvOABwzlvW3cSkBjcnU2f3dKwArtE75cnOjmv9j80NFlv5aOOnugJiATPXhq4g+BS4KBmALhjUhdZ7G8T0I6Aq1VTguaJcQi3yrprdpA3mDyeMKb4CdQGY+sijRbHqbUwwQ03eX2VVdAVMrSNyX6qhC2VtRH4DhjceIV1e/mSiXr71l8x0TMWAh7ZQkwPS1/rA4eyYQw7iVQlZtSMZIthQDo9W57C8zV0racRETwJ4XsrEvkqasp8wSKS6zFNRfWmCY0hZh1m4Bgv/L76dnxM3+r/CX2x1zLNaCuA4+nncCXX66PJ0CKdjPx4aPeB5GOWFbqI7x10sRyLcbPLaqkUXRUtny1FUCemOzGQjzGF6sGdl2ai+gUriKWPHFF+CrsHvq4k7tsh08XLktvKKW244bh4mg47hVjVGmiwJ+Xu/FkpLD5f+G/l1kQTcWk0G9ih+FzNeW1K3F0weDFM6IukEQevQU3xIaLpyW8Fu9/xmQe2zKXCWhDT7ANb9Jd2PSwoCe6fmvkKybnhWSitrYpgy9Uova3NdMy7drUWxRBzBDWzI
 x2JbKTiL
 WFDmXmImqD8F+siCs8RX5vLgU49bojDsoqwYHtPbBiQ0Pu50ufKIj9RvwvOI987s2+J2VFsujtR4wEIFA/NBXrXC8v0Pr9T9mQCis6yoRCfYbJGiP0OMGBqJdY7i5yL523dUUozprjnVyNNWsTj136byVlny5h/9lp/B9lGcwKoU5w2QWyGoOckkOn+pFGziRK0FZJ7NDT29RB35cpdAUGL3ha3rOYcJtGZXI8B7yNpcxvL+SDxcYHTz58zS5ozlIOvgy7ffAjDsrNhaOGRrTFyorYglcGa6vkxhu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

deferred_split_scan() splits a batch of folios, so we only need to
drain the lru_cache once for the entire batch.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/huge_memory.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 263ef9b6949d..e797f6d1837e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4085,6 +4085,8 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
  * @lock_at: a page within @folio to be left locked to caller
  * @list: after-split folios will be put on it if non NULL
  * @split_type: perform uniform split or not (non-uniform split)
+ * @lru_cache_drained: whether lru_cache has been drained locally
+ *  or on all CPUs for a batch of folios
  *
  * It calls __split_unmapped_folio() to perform uniform and non-uniform split.
  * It is in charge of checking whether the split is supported or not and
@@ -4100,7 +4102,8 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
  */
 static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct page *lock_at,
-		struct list_head *list, enum split_type split_type)
+		struct list_head *list, enum split_type split_type,
+		enum lru_cache_drained *lru_cache_drained)
 {
 	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
@@ -4203,7 +4206,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	}
 	if (folio_ref_count(folio) == folio_expected_ref_count(folio) + 1 +
 	    folio_may_be_lru_cached(folio))
-		lru_cache_drain_for_folio(folio, 1, NULL);
+		lru_cache_drain_for_folio(folio, 1, lru_cache_drained);
 
 	/*
 	 * Racy check if we can split the page, before unmap_folio() will
@@ -4395,7 +4398,7 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
 	struct folio *folio = page_folio(page);
 
 	return __folio_split(folio, new_order, &folio->page, page, list,
-			     SPLIT_TYPE_UNIFORM);
+			     SPLIT_TYPE_UNIFORM, NULL);
 }
 
 /**
@@ -4426,7 +4429,7 @@ int folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct list_head *list)
 {
 	return __folio_split(folio, new_order, split_at, &folio->page, list,
-			     SPLIT_TYPE_NON_UNIFORM);
+			     SPLIT_TYPE_NON_UNIFORM, NULL);
 }
 
 /**
@@ -4622,6 +4625,7 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 	struct folio *folio, *next;
 	int split = 0;
 	unsigned long isolated;
+	enum lru_cache_drained drained = LRU_CACHE_NOT_DRAINED;
 
 	isolated = list_lru_shrink_walk_irq(&deferred_split_lru, sc,
 					    deferred_split_isolate, &dispose);
@@ -4646,7 +4650,8 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 		}
 		if (!folio_trylock(folio))
 			goto requeue;
-		if (!split_folio(folio)) {
+		if (!__folio_split(folio, 0, &folio->page, &folio->page, NULL,
+		    SPLIT_TYPE_UNIFORM, &drained)) {
 			did_split = true;
 			if (underused)
 				count_vm_event(THP_UNDERUSED_SPLIT_PAGE);
-- 
2.34.1


