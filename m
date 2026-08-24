Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1BAAC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:01:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB6E36B00A1; Mon, 24 Aug 2026 10:01:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8D366B00A2; Mon, 24 Aug 2026 10:01:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97C5E6B00A5; Mon, 24 Aug 2026 10:01:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6CB856B00A1
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:01:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F278014014C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:01:30 +0000 (UTC)
X-FDA: 85136325540.01.1EEF64D
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 91F9740026
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:01:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=r+LHO8M2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of hughd@google.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787580088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F3uJrLcgO0TGgb78nKF0vmj4EM5IUhGHLplUqQEbOiM=;
	b=FEdY9JpL9T5lo+LOo4DDZXykXPwaBoCgd33MEceBAUw8OQEDw1KwR9qF1GX88gbSi51Rnd
	j/XS2ZgHLwtCf/dJjOhtfsXoSj2Lson+0k6PYfEPooPiUMuby7VqtEaS7QIKJLCrhe6F27
	aPDOQAOYVCROR+TxPBj6s5VwMvQBhpk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=r+LHO8M2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of hughd@google.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787580088;
	b=ZB4E0IRBjXBr/dAHIEQQ6ZoCblgUj5y0gvRzMqXipIfwP6L4DdR8wej/jw+YpHE7VSTU9g
	ibFFtvuEXws22HygwF1eO7Z1SbPC6k9dqgKiLqsHT0XvP7uGDnebrYWsOfPNERSTYerHIP
	ZqV2XETMtrVv6DVCYZyh3eG24KemwBQ=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-836cde02992so42187217b3.2
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787580088; x=1788184888; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F3uJrLcgO0TGgb78nKF0vmj4EM5IUhGHLplUqQEbOiM=;
        b=r+LHO8M2wkDWvfVtDbwcdm5U7cLIMNyiUPgsPkysh5D6Rv1coDv71jNeyW+pbtIa3S
         Sexk7+htT7ETnRoBC1VON3okZ/Z+tHM6Wi34qeFVQFRUVTuCdzL+4zP6ZdvwdUraIEew
         Z7aX+bGudT0XdZo1jWApdg0JB4uvJCf3cxEg8wJWJ09cFdakKet9hVgx7w/OAkyWqICd
         w3Yf7KnaE4TIG/jVWz+Ht47MNrQa2BlprzJdpdy2PS93Cu6gN0VdwurTy0e9JUHZQV9X
         MXCKYYiXXvMc6ACzz0yBXDsgjtQtR7LNPKmOZ0qCkPj90VQEysAUzwPERrrOz0sP3Xyp
         BqeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787580088; x=1788184888;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F3uJrLcgO0TGgb78nKF0vmj4EM5IUhGHLplUqQEbOiM=;
        b=GCg7hBXdCK/B5pStZc0kFn2evlvv2iAH3od3X32ZAqZccnzGiqR6AZGhrsutKd0PWv
         COny3n9klrzxp1lNQfC6Bp7jRyyLXK2O1c6n85GXrlqMyHgxwBAcoxutixE9eiOX2d8y
         7B50k4Hty2Hy/i6nrxN/WMi5udB/VRsVaoAN1fPSnqLaSHTbweNWlMQ6IIdFn59rUOtM
         /WjItwguCYA8JOorc5TqsEYEuMdf09POgI2ZjOxt52S8dHPH5LxyqSBtrJ91ZY7JYfoT
         BM4Ql92gQ5w5y3NZn5LKJu/axPjSLM+jGJt8IQuo4E/w2PnQqxczUrczxZ5H4wW87yTY
         Dqqg==
X-Forwarded-Encrypted: i=1; AHgh+Rp1UuSRGTGOZfSjys7vcqQSLL+3loxbnETxExNk2pujzQIo8s6l60mD9iS0SMAVujDJpuhYJCEOZw==@kvack.org
X-Gm-Message-State: AFuF++kNYSDvgLMyiwGgGOt2VMJ+FZVpITROGpvzhsTEvLLqdcJbF4zl
	1WStT5JmGcQkXBlvCbUQrwNhelzU6+P6MRpaq/LaD0iFCprq5Esa/izZWseiPm/5vw==
X-Gm-Gg: AR+sD12MFYnIpCIK/DKHprTkbwEBbdmBMEjiK2w5lz25a61H8IGjS184Um8JroiLoeC
	QQg+z/RZzkvjN1rpGroHGHgJBMGssPJlSBJ8RAhD8UW9slLYPrXptZWN2RBMTBIkkBOk0pANJnP
	Po4XucWF28Vr0SvKOB5HCrovpFKJtGUl76Ykk6mHGS3YdaMuWAQWG07PfOIhUNI3GJhFhJoX0yP
	i8YgJj61oGml/RRs2/AjcjTk8DlD5zfMNpFOyZvHiuT/qAJfXLaaVBsBXgvXNpQAajbP9U65iHY
	qUvcI0Dm8Q8JTUT94ZT/DUzzV4VVXPkAov2h7t5BHO/wxw3fWgmbYnmRAgSu37lxsp5gik3ASVq
	Rsk9j0phO3n584hssXbbz/np00rrXrIhBzAmB6D9eR8Meu/xA4KkMTEWR6kFkwTJQehpQLfrkkQ
	SbOjtXJskYYEXlWpYlcbIHJAwhINd84EthHC4rrk0eqaHwi7T8tiwdPy9I5mjEXEdhLzrX5X+LO
	6CEGq5tqQbU7bXfN4FN/fpKn/DPsdxun5905aznziODr6AI
X-Received: by 2002:a05:690c:568a:20b0:844:9f61:92d9 with SMTP id 00721157ae682-849f67acaa8mr75062557b3.17.1787580086310;
        Mon, 24 Aug 2026 07:01:26 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-85426caa5e9sm1557737b3.34.2026.08.24.07.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:01:25 -0700 (PDT)
Date: Mon, 24 Aug 2026 07:01:20 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 04/25] mm/fbatch: lru bit set, no extra ref, while folio on
 per-cpu fbatch
In-Reply-To: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
Message-ID: <e0887417-85a7-453e-e733-561dc11db08f@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 91F9740026
X-Stat-Signature: 4j6wcp1jnaitye91h3hmcc8og31x778p
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787580088-44846
X-HE-Meta: U2FsdGVkX1+8tro5mBdAOiKL+NRhG78Gsc12k/tKsJI6mTpxtieun4FNuAcM46x/rYdtTRyqQv2FPbxj0l1MXTk8ncVZ+ffe7VP3lbF6A3DKHx79vctUouvzeKz0l5CMQpXmjhJ5bOhfIs6YFDFj51/uj7Sa5DNBWCbqnehtXSXV1CySRVxoFb5RWTP4pJiXiR6chJe8N6oKsI9Dz+wyUU9+uleSD2icGdC4CmTe1u4fHrqjwaStBiJ7hUuAgThBw7TVJtQQuxA7f8X0Gdn7aHN1CoAKtqT/voJ4367GYwDt7I0edslyQu9g2sgfA22uQsFD2qBKU9u7om3DpM4XYMbo4ud444/8jv2BVuv226jwJIeUQvOYel/8VYtUn2YvgMuJ0gxiMEsTMPO56D95XSIpLIQRSqVnCposKyceAvy08TMVjN0mA6CjIBQS1uat6jVwfmbS19WWqGtgg+pJ8AC1H8Y7rPZYer1e7Qg+5GjHtbnYwwxmf4sgBwRNrHWXshKhG/Shdi2IMaZIn1bcyK3VWJn3S0zoa3qy4NnrbQ07jke0SVAe0zuAcqjIIUsLTDrdSztetaKV+jn5t7vOn9scPoUBV50++2nb6hj9q2Hf9ebo3g9CDZ0r+FDRdeMF1FHYTHYSr1uxaYfSw8pwCuczFllMlldJiVtZzYaNd3YwrA8RhzbtIJ03TUHAXh8fKeOuK1mWg3BSfX7yjVJ4K7iuLZs2wVDWUp+HYwr8BfylHv52tO1zRRy2pr8P9RCxqakcOxLyTqirG0nFZwev9TSeStn2nU3aelAtt3Dbrw1/Yk5N+Vvjcld7Sb9hTxnDSX8iT7xeHcT8Qnm7r1Ie2uW3RhfdQcMrtXoi6mVouWLSORrd/fszGKHgL5/nZ9BrqgECwSNR5GAdaWYYUJ96EDHkWeyy1pyMa1WVb11WVIXLHVGc9ldwQnF3DsVdhdpRboXJW3s2dQ4xELWNUEm
 SDdPxRnz
 w3NwANKuRLX0+KsVwsurgxcyjxab3DswvTxoQGj6/hF1Qd7IoFSKxu9UseYspBdLUc4N1y1JylJbei6U35Xa2EaKy39DPvoHVuJTtwbsXhoQsO5RbRC+HMhCvX8yjaldBIk9O9gbFnNDhoUSs6erXUvXum3bPY+XJkvgA9W5yxcnpogLdogXsP0Q9e6SuJakLwAcQdlJLnS+66VavDMT5bVpwa7zVGJm2dxc6qvDSx0a3yCGXRmCFjNsRfnMTVjv64PVdwoRVHu1ZKzyqx7b0uh+6Fz8EZg4QDo7es4iHnN4T40iTNE9TAwWnyagsbT1QloRA2kiaozxttbafooiWOps69sf0raKLuQxZPEQoBqDV3jTi0+2uG6x8M9C690R2kxNHadJhH38O95s7UNNYkisARaZzdaqDKR0sckYXu9i3v/8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Treat folios on a per-cpu fbatch as if they were already on the lruvec:
with PG_lru set, without holding an extra reference. This will enable
the removal of most lru_add_drain() and lru_add_drain_all() calls soon.

Recognize such a folio by 0x02 set in the folio->lru.next pointer by
folio_add_lru(). Then lruvec_del_folio() (aided by "lru_add_del_folio")
can pretend to unlink it, and folio_batch_move_lru()'s lru_add case can
check whether one of the others has already moved it to lruvec.

Let folio->lru.next point to the lru_add fbatch entry, but this is now
just for debugging: it seemed to be important for folio_batch_move_lru()
to distinguish fresh from stale entries, but then it turned out that it
has to processs them identically.

Activate, deactivates and move_tail, holding no reference on the folio,
might come to act on a stale folio when the fbatch is drained: but it's
acquired by try_get and test_clear_lru, so safe even when suboptimal.

Reclaim is not an exact science, and there have been no complaints of
missed actions since 5.11 commit fc574c23558c ("mm/swap.c: serialize
memcg changes in pagevec_lru_move_fn") introduced the TestClearPageLRU
protocol: so don't expect complaints of a few surprisingly taken actions.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 include/linux/mm_inline.h |  19 ++++++
 include/linux/mm_types.h  |   4 +-
 mm/folio.c                | 119 +++++++++++++-------------------------
 mm/huge_memory.c          |   6 +-
 4 files changed, 66 insertions(+), 82 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 621c8653d8f7..1ecaf2ef9f2b 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -343,6 +343,23 @@ static inline void folio_migrate_refs(struct folio *new, const struct folio *old
 }
 #endif /* CONFIG_LRU_GEN */
 
+enum {
+	LRU_NEXT_NEVER_TAIL = 0,	/* Used by a tail's compound_head */
+	LRU_NEXT_BATCHED = 1,		/* Not used by any aligned pointer */
+	NR_LRU_NEXT_FLAGS
+};
+
+static __always_inline
+bool lru_add_del_folio(struct folio *folio)
+{
+	/* BUG_ON(folio_test_lru(folio)); */
+	if (!(folio->lru_next & BIT(LRU_NEXT_BATCHED)))
+		return false;
+	folio->lru.next = LIST_POISON1;
+	/* BUG_ON(folio->lru_next & BIT(LRU_NEXT_BATCHED)); */
+	return true;
+}
+
 static __always_inline
 void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
 {
@@ -384,6 +401,8 @@ void lruvec_del_folio(struct lruvec *lruvec, struct folio *folio)
 
 	if (lru_gen_del_folio(lruvec, folio, false))
 		return;
+	if (lru_add_del_folio(folio))
+		return;
 
 	if (lru != LRU_UNEVICTABLE)
 		list_del(&folio->lru);
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 939b5ea8c9e0..2b1a1f983a91 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -410,10 +410,8 @@ struct folio {
 			union {
 				struct list_head lru;
 	/* private: avoid cluttering the output */
-				/* For the Unevictable "LRU list" slot */
 				struct {
-					/* Avoid compound_info */
-					void *__filler;
+					unsigned long lru_next;
 	/* public: */
 					unsigned int mlock_count;
 	/* private: */
diff --git a/mm/folio.c b/mm/folio.c
index a7010ae3edff..88e3ebd7e652 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -151,57 +151,34 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 	int i;
 	struct lruvec *lruvec = NULL;
 	unsigned long flags = 0;
-	struct folio_batch free_fbatch;
-	bool is_lru_add = (move_fn == lru_add);
-
-	/*
-	 * If we're adding to the LRU, preemptively filter dead folios. Use
-	 * this dedicated folio batch for temp storage and deferred cleanup.
-	 */
-	if (is_lru_add)
-		folio_batch_init(&free_fbatch);
 
 	for (i = 0; i < folio_batch_count(fbatch); i++) {
 		struct folio *folio = fbatch->folios[i];
 
-		/* block memcg migration while the folio moves between lru */
-		if (!is_lru_add && !folio_test_clear_lru(folio))
-			continue;
-
-		/*
-		 * Filter dead folios by moving them from the add batch to the temp
-		 * batch for freeing after this loop.
-		 *
-		 * We're bypassing normal cleanup. Clear flags that are not
-		 * applicable to dead folios.
-		 *
-		 * Since the folio may be part of a huge page, unqueue from
-		 * deferred split list to avoid a dangling list entry.
-		 */
-		if (is_lru_add && folio_ref_freeze(folio, 1)) {
-			__folio_clear_active(folio);
-			__folio_clear_unevictable(folio);
-			folio_unqueue_deferred_split(folio);
+		if (!folio_try_get(folio)) {
 			fbatch->folios[i] = NULL;
-			folio_batch_add(&free_fbatch, folio);
 			continue;
 		}
 
+		if (!folio_test_clear_lru(folio))
+			continue;
+
+		/* Do not add to LRU if it has already been added */
+		if (move_fn == lru_add && !lru_add_del_folio(folio))
+			goto restore_lru;
+
 		folio_lruvec_relock_irqsave(folio, &lruvec, &flags);
 		move_fn(lruvec, folio);
 
+		/* Do add to LRU if not already there (move_fn skipped) */
+		if (lru_add_del_folio(folio))
+			lruvec_add_folio(lruvec, folio);
+restore_lru:
 		folio_set_lru(folio);
 	}
 
 	if (lruvec)
 		lruvec_unlock_irqrestore(lruvec, flags);
-
-	/* Cleanup filtered dead folios. */
-	if (is_lru_add) {
-		mem_cgroup_uncharge_folios(&free_fbatch);
-		free_unref_folios(&free_fbatch);
-	}
-
 	folios_put(fbatch);
 }
 
@@ -210,8 +187,6 @@ static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
 {
 	unsigned long flags;
 
-	folio_get(folio);
-
 	if (disable_irq)
 		local_lock_irqsave(&cpu_fbatches.lock_irq, flags);
 	else
@@ -339,7 +314,6 @@ static void lru_activate(struct lruvec *lruvec, struct folio *folio)
 	if (folio_test_active(folio) || folio_test_unevictable(folio))
 		return;
 
-
 	lruvec_del_folio(lruvec, folio);
 	folio_set_active(folio);
 	lruvec_add_folio(lruvec, folio);
@@ -355,37 +329,12 @@ void folio_activate(struct folio *folio)
 	    !folio_test_lru(folio))
 		return;
 
-	folio_batch_add_and_move(folio, lru_activate);
-}
-
-static void __lru_cache_activate_folio(struct folio *folio)
-{
-	struct folio_batch *fbatch;
-	int i;
-
-	local_lock(&cpu_fbatches.lock);
-	fbatch = this_cpu_ptr(&cpu_fbatches.lru_add);
-
 	/*
-	 * Search backwards on the optimistic assumption that the folio being
-	 * activated has just been added to this batch. Note that only
-	 * the local batch is examined as a !LRU folio could be in the
-	 * process of being released, reclaimed, migrated or on a remote
-	 * batch that is currently being drained. Furthermore, marking
-	 * a remote batch's folio active potentially hits a race where
-	 * a folio is marked active just after it is added to the inactive
-	 * list causing accounting errors and BUG_ON checks to trigger.
+	 * XXX: It is curiously difficult to recreate safely the old
+	 * __lru_cache_activate_folio() optimization (folio_set_active()
+	 * directly if it's on the local lru_add fbatch): revisit later.
 	 */
-	for (i = folio_batch_count(fbatch) - 1; i >= 0; i--) {
-		struct folio *batch_folio = fbatch->folios[i];
-
-		if (batch_folio == folio) {
-			folio_set_active(folio);
-			break;
-		}
-	}
-
-	local_unlock(&cpu_fbatches.lock);
+	folio_batch_add_and_move(folio, lru_activate);
 }
 
 #ifdef CONFIG_LRU_GEN
@@ -476,16 +425,7 @@ void folio_mark_accessed(struct folio *folio)
 		 * unevictable page accessed has no effect.
 		 */
 	} else if (!folio_test_active(folio)) {
-		/*
-		 * If the folio is on the LRU, queue it for activation via
-		 * cpu_fbatches.lru_activate. Otherwise, assume the folio is in a
-		 * folio_batch, mark it active and it'll be moved to the active
-		 * LRU on the next drain.
-		 */
-		if (folio_test_lru(folio))
-			folio_activate(folio);
-		else
-			__lru_cache_activate_folio(folio);
+		folio_activate(folio);
 		folio_clear_referenced(folio);
 		workingset_activation(folio);
 	}
@@ -505,6 +445,10 @@ EXPORT_SYMBOL(folio_mark_accessed);
  */
 void folio_add_lru(struct folio *folio)
 {
+	struct folio_batch *fbatch;
+	unsigned long lru_next;
+	bool full;
+
 	VM_BUG_ON_FOLIO(folio_test_active(folio) &&
 			folio_test_unevictable(folio), folio);
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
@@ -524,7 +468,26 @@ void folio_add_lru(struct folio *folio)
 			folio_mark_accessed(folio);
 	}
 
-	folio_batch_add_and_move(folio, lru_add);
+	local_lock(&cpu_fbatches.lock);
+	fbatch = this_cpu_ptr(&cpu_fbatches.lru_add);
+
+	/* Storing this address is only for debugging */
+	lru_next = (unsigned long)&fbatch->folios[fbatch->nr];
+	/* This mask will do nothing on 64-bit */
+	lru_next &= ~(BIT(NR_LRU_NEXT_FLAGS) - 1);
+	lru_next |= BIT(LRU_NEXT_BATCHED);
+	folio->lru_next = lru_next;
+
+	full = !folio_batch_add(fbatch, folio);
+
+	/* Ensure folio->lru_next visible to folio_test_clear_lru() callers */
+	smp_mb__before_atomic();
+	folio_set_lru(folio);
+
+	if (full || !folio_may_be_lru_cached(folio) || lru_cache_disabled())
+		folio_batch_move_lru(fbatch, lru_add);
+
+	local_unlock(&cpu_fbatches.lock);
 }
 EXPORT_SYMBOL(folio_add_lru);
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 644d6905b49c..98b1d0ea50f0 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3993,8 +3993,12 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 		}
 
 		/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
-		if (do_lru)
+		if (do_lru) {
 			lruvec = folio_lruvec_lock(folio);
+			/* Move from fbatch to lruvec before lru_add_split_folio()s */
+			if (lru_add_del_folio(folio))
+				lruvec_add_folio(lruvec, folio);
+		}
 
 		ret = __split_unmapped_folio(folio, new_order, split_at, xas,
 					     mapping, split_type);
-- 
2.51.0


