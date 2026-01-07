Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 036CCCD585A
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 11:33:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52A5F6B0095; Wed,  7 Jan 2026 06:33:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D4356B0096; Wed,  7 Jan 2026 06:33:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EB1D6B0098; Wed,  7 Jan 2026 06:33:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E8096B0095
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 06:33:15 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DC4D158267
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:33:14 +0000 (UTC)
X-FDA: 84304956708.23.2D6AE71
Received: from sg-1-102.ptr.blmpb.com (sg-1-102.ptr.blmpb.com [118.26.132.102])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5EB46120004
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:33:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="PmpX/nDy";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf29.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.102 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767785593; a=rsa-sha256;
	cv=none;
	b=pqbjHfSRoRRyjaijt1akErIh8KFAsqH20d/tlZs6oo5zz8AUk/jvDCIgR3rSECEaDNLQmd
	kTXf7m/9Tl1SSMhpk/unDwMcFDAqJf/4gLJXdOtBIP2arQ7tWCNCuFabnZ5ibxShVbHQJI
	wXXZ9Z33xqr6t7WOP6NSQLYZjFqLahM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="PmpX/nDy";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf29.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.102 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767785593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N8AGG1ZCnIMLj3cPqWeKg86cRrsdjc3RFAx/nQ6Si9A=;
	b=AmmP/ejK0UqyEkyYBHPA/ryuOjfLiShr7QbGCNwmcRRkY9hCszD6qvGoImA6y97QjRZZoZ
	nZW0NeF6C6mV+4ybPuwhtr2YLZkT5MK9Gm+YSlICqYXOKnvmlvzg82Jnh3hCh6/QQhedjU
	8oVi4VPHM8yYIWqMQ0DWQ7MsyiLLxp4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1767785585; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=N8AGG1ZCnIMLj3cPqWeKg86cRrsdjc3RFAx/nQ6Si9A=;
 b=PmpX/nDyt63mqnGxwjy7PsO2mBIGjTYevkQ1FCWBXEKGb9y6RkKuZCUfB17+ZF+ZypGrc5
 dWBw5IJbWKQ/gPBQfrIalNDWcd9K+Er2KhQjZcVHXAgf8EwNjf9sH0tujkyCYLrWFhJjI4
 GbyQWAOwwDeEmX4MjLiSESuWvOox2QXNRjcYNG3VzxpjPE7yjxrQUKxsme7ceH1YovTQNH
 Donjot/ayfX+Cx8PAG3tiGhAveuHE85Kensog6wJHA5KEH6io2M0bdej0AS0q7py3wc8B1
 FZNpT2ta4MBV/4KNNGCaWJb+26QckTObnNPV6rzIIol7pYmjG5xNffuKSnwZSA==
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Date: Wed,  7 Jan 2026 19:31:24 +0800
Mime-Version: 1.0
References: <20260107113130.37231-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<lizhe.67@bytedance.com>
Subject: [PATCH v2 2/8] mm/hugetlb: convert to prep_account_new_hugetlb_folio()
In-Reply-To: <20260107113130.37231-1-lizhe.67@bytedance.com>
Message-Id: <20260107113130.37231-3-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>, 
	<akpm@linux-foundation.org>, <fvdl@google.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+2695e446f+df6291+kvack.org+lizhe.67@bytedance.com>
X-Rspamd-Queue-Id: 5EB46120004
X-Stat-Signature: anpfqwc63ju71ojiihq6z6zsdobiku3c
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767785591-634399
X-HE-Meta: U2FsdGVkX1+siu8o0IxXZXWxneGidjXBq53mGXmQ0CdFmE6r53Q+alxZy82izhq4RvNhNUAepsMt4Q6bZiLE4ceHXeal25Onz7qY/QJt3cdE4qsqw5VGSHMMhxMDIhjNXFWL7CPh6jYHLMrd4GSqMU0l4NqjIas0X5PvwUTjkLssNYtsh84p7GMUs/Q8SCdymt/BvhYOI6KV4ZUNAGJx/lpMoz/p52MuWZ6kbPMMS2D6L3cblX1hMhYjmVbPD7vhRSG+Z1wgTZ9+MzV37hmFqTPNIANjvqY0dIqEhsKhIPXl9PsnviqaghD2ZuFkoFiKLibfvmq43ywJP2W+GQHOQOxYB4pPOrxvrFzftjtE0ScStlD3vw2ZQ/tWCNcL50XQNj+imQVi8JesGV6M9cfWoFuIPI8ybPZQB1CBfqSipAn3H/OdrZaa/ntcpqR56wXfl8Icpcqsfg46/QAufoJtByhAsKQrjeCeJT6UoBuc3udyYRS5RdhJyPgRNpfIFPW003AVmA1ynlrqVB2rDKZa3ZspL/1Ck5fTXFMqlqWTt4bL29sBJj5XhsRYwsMCOlbKO7FEqI8TeqotGWjhLImgBA+GxrW/JwKHoyZVhsNlWsG/Q2eJEBas+ntc2KouDZATvPcggzMx9FIwWLG/0ZGDTPc4qowhZYFwKSe3qLBXaY4u3REoVo2H7PSKqQcUyjWUy6YBMDgX8V9hpRd8uIMsTrfkJ80DpK3s4hlquYtwMcp3QAU22jKJtjG7XMh7FDRLAyrV1wKOljG4OYDlinvUZQiSOFDLeSjGCpKmAu4DDRc9kOaQkrqWUMaq6RMgl4OAVyxCt/pMQSr/+BzoS1GmMfDDZJU8ui0LwXdJcA9nkEl1KFvee3Pk8JgNgIJrOq005Ahp3aCxMy03RLIQR3X8HJsKl8CpuEP6i/lSO31DtFNJ7JEhhf8zBL/Yhx344LvcqQtQzg49hUuUgKvfHcp
 SsFegBUA
 RYTp/H1bhr5ghaybxg/PRXVN+lnrqu4yKO71x2gzBVJOdWH+xP0ufC3Q8kjp1nbTgZUEkTIvGuQzgFbYJDxfEkp9Ur/6+tS0D6w2dV6sqJrRD1gWGEln4mJ51C+Vwn/T1iXq0mR81ha9foxS3z/AE6+iLTw/xuPz+5yqPafenfHtUREdBtsXjEkPQfDkEh4b90kQHoUHDlWg0h8JN2DkE6b/YsGPXS2O15BHFkUhUrAoMUw2y84W86gViMNPErDUOdoXkoL2I3yrzH/odiCtwbMlEVsNqUdo8zuMqTGkqGe9hDm0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After a huge folio is instantiated, it is always initialized through
the successive calls to prep_new_hugetlb_folio() and
account_new_hugetlb_folio(). To eliminate the risk that future changes
update one routine but overlook the other, the two functions have been
consolidated into a single entry point prep_account_new_hugetlb_folio().

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/hugetlb.c | 29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 001fc0ed4c48..a7e582abe9f9 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1874,18 +1874,14 @@ void free_huge_folio(struct folio *folio)
 /*
  * Must be called with the hugetlb lock held
  */
-static void account_new_hugetlb_folio(struct hstate *h, struct folio *folio)
-{
-	lockdep_assert_held(&hugetlb_lock);
-	h->nr_huge_pages++;
-	h->nr_huge_pages_node[folio_nid(folio)]++;
-}
-
-static void prep_new_hugetlb_folio(struct folio *folio)
+static void prep_account_new_hugetlb_folio(struct hstate *h,
+					   struct folio *folio)
 {
 	lockdep_assert_held(&hugetlb_lock);
 	folio_clear_hugetlb_freed(folio);
 	prep_clear_zeroed(folio);
+	h->nr_huge_pages++;
+	h->nr_huge_pages_node[folio_nid(folio)]++;
 }
 
 void init_new_hugetlb_folio(struct folio *folio)
@@ -2012,8 +2008,7 @@ void prep_and_add_allocated_folios(struct hstate *h,
 	/* Add all new pool pages to free lists in one lock cycle */
 	spin_lock_irqsave(&hugetlb_lock, flags);
 	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
-		prep_new_hugetlb_folio(folio);
-		account_new_hugetlb_folio(h, folio);
+		prep_account_new_hugetlb_folio(h, folio);
 		enqueue_hugetlb_folio(h, folio);
 	}
 	spin_unlock_irqrestore(&hugetlb_lock, flags);
@@ -2220,13 +2215,12 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 		return NULL;
 
 	spin_lock_irq(&hugetlb_lock);
-	prep_new_hugetlb_folio(folio);
 	/*
 	 * nr_huge_pages needs to be adjusted within the same lock cycle
 	 * as surplus_pages, otherwise it might confuse
 	 * persistent_huge_pages() momentarily.
 	 */
-	account_new_hugetlb_folio(h, folio);
+	prep_account_new_hugetlb_folio(h, folio);
 
 	/*
 	 * We could have raced with the pool size change.
@@ -2264,8 +2258,7 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
 		return NULL;
 
 	spin_lock_irq(&hugetlb_lock);
-	prep_new_hugetlb_folio(folio);
-	account_new_hugetlb_folio(h, folio);
+	prep_account_new_hugetlb_folio(h, folio);
 	spin_unlock_irq(&hugetlb_lock);
 
 	/* fresh huge pages are frozen */
@@ -2831,18 +2824,17 @@ static int alloc_and_dissolve_hugetlb_folio(struct folio *old_folio,
 		/*
 		 * Ok, old_folio is still a genuine free hugepage. Remove it from
 		 * the freelist and decrease the counters. These will be
-		 * incremented again when calling account_new_hugetlb_folio()
+		 * incremented again when calling prep_account_new_hugetlb_folio()
 		 * and enqueue_hugetlb_folio() for new_folio. The counters will
 		 * remain stable since this happens under the lock.
 		 */
 		remove_hugetlb_folio(h, old_folio, false);
 
-		prep_new_hugetlb_folio(new_folio);
 		/*
 		 * Ref count on new_folio is already zero as it was dropped
 		 * earlier.  It can be directly added to the pool free list.
 		 */
-		account_new_hugetlb_folio(h, new_folio);
+		prep_account_new_hugetlb_folio(h, new_folio);
 		enqueue_hugetlb_folio(h, new_folio);
 
 		/*
@@ -3318,8 +3310,7 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
 		hugetlb_bootmem_init_migratetype(folio, h);
 		/* Subdivide locks to achieve better parallel performance */
 		spin_lock_irqsave(&hugetlb_lock, flags);
-		prep_new_hugetlb_folio(folio);
-		account_new_hugetlb_folio(h, folio);
+		prep_account_new_hugetlb_folio(h, folio);
 		enqueue_hugetlb_folio(h, folio);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 	}
-- 
2.20.1

