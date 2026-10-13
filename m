Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEB40CC6B0F
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 22:16:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B2D26B008C; Tue, 13 Oct 2026 18:16:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83C746B0092; Tue, 13 Oct 2026 18:16:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 706D56B0095; Tue, 13 Oct 2026 18:16:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2D9856B008C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 18:16:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8CFFC1A0295
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 22:16:25 +0000 (UTC)
X-FDA: 85319012730.15.C778777
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id CDC101C0004
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 22:16:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FvQutYNs;
	spf=pass (imf20.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791929783;
	b=M13o2DxJxnySt7Jh5YEzp2w6k+Dun82bi0fKhMzjbx1fZ/SiAzxbij7xROI33Zm+xaJruR
	xMN3QfIqghOCfMRC9bXtlX9PhYVbcXEVt6b58RQ2G9KRi2QVqD0Lym4cfWx80RsfvZlpiH
	HsksddOeNsR5zk4OB4n4sIDXcflQmI0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FvQutYNs;
	spf=pass (imf20.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791929783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=o97kVTy3EqqqEFC/OlUKtIoJa3oUrpqSp2F7+qoZqxc=;
	b=rSmqjUiBJeU18wdAHYNHKHuLxwvtLuauhQzynrW4LGKgZcI0fP/JZmxgvG6FhmzZWD+Zfu
	IPk39+DqDH0HTDW/1WCW80CJoyAUG67gaBItAVZLultsyFcb2houkWP7q719G2OZTZ7iSu
	zpyroQnYhMeA5T9YhkZnLDm+QtU86no=
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-8198a3a54d7so5630022a34.1
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791929783; x=1792534583; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=o97kVTy3EqqqEFC/OlUKtIoJa3oUrpqSp2F7+qoZqxc=;
        b=FvQutYNs0+sQsA9Xo7GvOeCV18lsQUIAOLrR+sN9Zg95EZzVX+LmaYxsBVRlRqjeuS
         8o8ngpPuFmCWeQ5Bss45nFDtw7lvQD5JtgRrr7Gf3q9t90aQ5AZJ0TsjlMNnlXCrC80K
         P58YLnv388QVNWHEz8FxLZ+BqDJxIRGxRxWV8Tr4kUM9AxDeYg2bqzZaRF698ZEMPwXT
         0OaJFLR1Y7MgXOfaqmxaZlcwwJb74bWyOhpG3zqcQcU97jJzy2bvyrRQIwfZlq9gYM1E
         QU3lsOwklQL7QWofijlUeYoDnz2S4uAuNL5f4klu6yUXw/MBqtN2elNh/nYAgXJJ8ZG5
         ZmPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791929783; x=1792534583;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o97kVTy3EqqqEFC/OlUKtIoJa3oUrpqSp2F7+qoZqxc=;
        b=eojqFkp4nuBsrbg0Xd8Uj2Asc2jPd0x0T4hIhhYL3Qhq1QlhLw6iG3zi2R1RemXa6l
         KTZHYeMB2gPRRvlpWf8p1cnGCf/ah89fjv/CdCJNXV9SzANl4fWUdu9agkMbsEdheC8a
         22RBC0u8NpKcIb9y4RqXgAGCdH2IvxOO1L6tlr/2LNHXWCHQGsO0JFV8xKb6+FIGGzuY
         3W4Ojt+iltzneVMUfaSM7eAreSyNKzWUUYZ9rYOP9u7LxMPy3c3XOU6mbEbGCEdHkQTn
         WScQt60sYkry+/ly1SIoJ+8rCrmERVERGsaOJlbi1kYf1Vuhfns/mwCneblxOPi7aBlL
         rpXA==
X-Gm-Message-State: AFq9FYK9h7nuGSILUGUx54fV+0cFSnUm9HiDeIv+FU9UCXCr0P2Tk7rS
	xMWQT8xTQ+0RQbbpttib2ormx1qa/rYenejYpFEpq1JHK6pKz+4D9Hpp
X-Gm-Gg: AYBFou2x/VMuM29leyO82fhc/q93edQxezjWAmB0bB0Fa7p7AubaPhhkMFHtZrRiAHW
	5R50K2hB4wJemtLD9M4j81fJ8uwgSuL/1Q5cVtknRLNxUtCUtQC2oxSgO/jl9bhypfd/UPueVDg
	YzLMubgsyjeOMR+QP7eDms9iHZtGgIKWqGgc0SrKQcjL5wZFfIzUp/K6QH6n1v9VNHuWZnMi/k8
	URcQmnUoaAJ/Hx8Fq7eMXM5Wjp/SRFHCujlXBxuRZWfcwk9HM07QFkHEZwTWw9R1wKifnCOHGFB
	uAuRXAM5vD/mDIy4BAmrzAN9isK4u8pWnFzvLY4kC5nAmn86vS2YKUnvh1PKEmRDpIERmWCme8O
	Lbzhvonxic0iFBrC9NgNu2oLadh8BD8mk65S7iQE2v8b3NYx/v1727dhc0fTsIKg2kGdaPBvhHK
	piioYsf5rX6cQQV6SKaSkbjKYzY8tYVHVWGtnxRgn4VFSlEGKDxdamXYW1rJi5ArC1qRoEUkq2a
	Cn6R8PUv9Nq5dwpTniotqYYhCcV5v+WYpRWmFHuZquQGuCz+ws=
X-Received: by 2002:a05:6830:3366:b0:81e:375d:3963 with SMTP id 46e09a7af769-83028c5912cmr8564561a34.18.1791929782683;
        Tue, 13 Oct 2026 15:16:22 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:71::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-83038f82468sm13759270a34.11.2026.10.13.15.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 15:16:21 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Barry Song <baohua@kernel.org>,
	Usama Arif <usama.arif@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	Hugh Dickins <hughd@google.com>
Subject: [PATCH v1] mm: unqueue deferred split folios outside the lruvec lock
Date: Tue, 13 Oct 2026 15:13:07 -0700
Message-ID: <20261013221307.850803-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tinjr56g37br9wcmq3bzs7be8fipk1m4
X-Rspamd-Queue-Id: CDC101C0004
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791929783-902197
X-HE-Meta: U2FsdGVkX19OxgM0LMtfECZzXRK+eXMSeuWi/mEaiBZegEEmr5TRfud5G6Laxjcwb99av1nuSgovgiemkchKdFWgVYh0fK0SOdyQyTzUuGfxju29b5zL9pywutAy+J9mN7pNUw4QpEz3ZY70Hp8WdQU2qFsyjzeIi/A2rpIaaN9QWnnpQgaBxxoHkG202HDkWaqTPJy9l6LkeLhPr0HxY6TPXUm6fx7U0NLvYjpHFH62zuFIDvFLnfdhSfe8Eza0sYORBAvLTRl32EE8HTIHqNenxWlSmr/CXsQGj9m3pRNn4Vcnl1IewL6sGJn0vim/kLCM5nhGxjiTGBwqDwhmCmAyB5llRKQn/YtKKcb0y56kQD6Q3C2lsbWTo/NjkJT7OP5Bo8D2huym2dIAzG1I3meaZxB7ZxQBloJHwuu2+gUq4Fbt84IJmXIBDwgOmyLMomBHVoqWuknKz7vbfexnC7s0aW+EGQRWcOPBMYCj7WcNUuCz0D7yBlob9eynFsvxz5N0qSpDVm6BFkdLrLrZyRjxE/+nBICAAco37Cn3KWG9xKsA5Boc7qJDedcSAxrr16JHs3b9MPkTJ1T53Z64SyvP4PWQJDDIhkuXAjHDfJkV5PlwGB+dv+uL7uWcWLK2Rv5vJaJCqDc+TYpyCDwCWVRnoawHWuVewV3HgrVNwG1CkZyBGmKFdw7m1oKvCVdMy3uNS9ZO+ytSZ8zxKTGIBb7Cvpk3W8U232it+gpnX0yjLG1gafeL9DVmBsLu9ClBgymQvOGQAoBoq4wxnjqZE1hJr6xCBTxQ0Ap+RvGWKtFe/385QmXxE6Q/IEhLnek1zIToe3sLCQWHVixtwbxYEUHWbUxd4Ilwh8oRWVkR6XhMZdDUthQsTUkuj0ftZJnOaNlHt41q40bZtwcz3r0Vm8mu1l0Fx1ycrQczU5cioRuoQQC35A47gd3zUVNGO/2vCU1iUIecLeHXXyrW9L4
 EDw7n/tA
 1LfFS02z7QFtYaIRrWfJLHpw1T1gQaSlajUD42vxVK7v9+GC+YIvhrElU67Mi8U9q7aJuDZ//h4AuHUEBn/DQSQ5XvxpMHO+HkilBcUDcI+sscRNhWSxZF8m1pX4PCaCwc4b5F/LkNPf5RPLIcW1y50EpXROlIhv4l2wqMp6nin3Fpi9BbAB/gwhuUP9IZIHYTkDZvs7CYNEFwLvNrvs5qS9AY+eUbqc3Wb322i/CE/MlgGtGWlNkq8x6WE1JrSTBcrG/Qp/FbbOx9nA6j92H5CUc9nWlbSxQyCAXeN1ho+y7HC1u1+nm5TezPa3mnIjm0/UuhaBX4r+1WMtFje348svJh33mMN/B9HZUKS4V/Mkt1lZ5kKUL2IZDRYsABJiJXsTHarChyxdpBTlvznZgWE14Gz6Ty5Vyb+PJ+mjNTTe8rHafPvIlO3jSJ3tbE2fpw6/CsblPH0B4bOvKi8ON3zgnYk8+yBPsha23VAFJLNQ20Ba87WITT6hOMLJXusnrHnGK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

move_folios_to_lru(), folio_batch_move_lru() and folios_put_refs() call
folio_unqueue_deferred_split() on folios where the refcount has dropped
to zero. In these paths, folio_unqueue_deferred_split() is called with
the lruvec lock often held (move_folios_to_lru() always holds it and
folio_batch_move_lru()/folios_put_refs() usually hold it for every folio
in the batch except the first). However, it's not needed to hold the
lruvec lock.

The lruvec lock protects folio->lru and the reclaim LRU lists whereas
the deferred split queue lives on folio->_deferred_list in
deferred_split_lru. The deferred_split_lru is a list_lru with its own
per-memcg per-node lock.

There are already other existing callers that call
folio_unqueue_deferred_split() without holding the lruvec lock (eg
__folio_put(), shrink_folio_list(), __folio_migrate_mapping(), ...).

Add folio_batch_unqueue_deferred_split() and use it in
move_folios_to_lru(), folio_batch_move_lru(), and folios_put_refs() to
unqueue each batch of zero-refcount folios from the deferred split list
after the lruvec lock is released and before
mem_cgroup_uncharge_folios(). This helps shorten the lruvec lock's
critical sections, which run with IRQs disabled and are highly
contended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/folio.c    | 24 +++++++++++++++++++-----
 mm/internal.h |  1 +
 mm/vmscan.c   |  3 ++-
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/mm/folio.c b/mm/folio.c
index 35e242b48870..85144078e635 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -109,6 +109,19 @@ EXPORT_SYMBOL(__folio_put);
 
 typedef void (*move_fn_t)(struct lruvec *lruvec, struct folio *folio);
 
+/*
+ * Unqueue a batch of folios from the deferred split queue. This must be
+ * called after the folios' refcounts have dropped to zero and before they
+ * are uncharged (see comment above __folio_unqueue_deferred_split() for why).
+ */
+void folio_batch_unqueue_deferred_split(struct folio_batch *fbatch)
+{
+	unsigned int i;
+
+	for (i = 0; i < folio_batch_count(fbatch); i++)
+		folio_unqueue_deferred_split(fbatch->folios[i]);
+}
+
 static void lru_add(struct lruvec *lruvec, struct folio *folio)
 {
 	int was_unevictable = folio_test_clear_unevictable(folio);
@@ -177,14 +190,10 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 		 *
 		 * We're bypassing normal cleanup. Clear flags that are not
 		 * applicable to dead folios.
-		 *
-		 * Since the folio may be part of a huge page, unqueue from
-		 * deferred split list to avoid a dangling list entry.
 		 */
 		if (is_lru_add && folio_ref_freeze(folio, 1)) {
 			__folio_clear_active(folio);
 			__folio_clear_unevictable(folio);
-			folio_unqueue_deferred_split(folio);
 			fbatch->folios[i] = NULL;
 			folio_batch_add(&free_fbatch, folio);
 			continue;
@@ -201,6 +210,11 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 
 	/* Cleanup filtered dead folios. */
 	if (is_lru_add) {
+		/*
+		 * Since the folios may be part of a huge page, unqueue them
+		 * from the deferred split list to avoid a dangling list entry.
+		 */
+		folio_batch_unqueue_deferred_split(&free_fbatch);
 		mem_cgroup_uncharge_folios(&free_fbatch);
 		free_unref_folios(&free_fbatch);
 	}
@@ -1020,7 +1034,6 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
 			free_huge_folio(folio);
 			continue;
 		}
-		folio_unqueue_deferred_split(folio);
 		__page_cache_release(folio, &lruvec, &flags);
 
 		if (j != i)
@@ -1035,6 +1048,7 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
 	}
 
 	folios->nr = j;
+	folio_batch_unqueue_deferred_split(folios);
 	mem_cgroup_uncharge_folios(folios);
 	free_unref_folios(folios);
 }
diff --git a/mm/internal.h b/mm/internal.h
index 0ca863f2639a..ac72577a6e3e 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -760,6 +760,7 @@ static inline bool folio_unqueue_deferred_split(struct folio *folio)
 
 	return __folio_unqueue_deferred_split(folio);
 }
+void folio_batch_unqueue_deferred_split(struct folio_batch *fbatch);
 
 static inline struct folio *page_rmappable_folio(struct page *page)
 {
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 29b31446fc11..94859a830fb0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2007,9 +2007,9 @@ static unsigned int move_folios_to_lru(struct list_head *list, bool do_rotate)
 		if (unlikely(folio_put_testzero(folio))) {
 			__folio_clear_lru_flags(folio);
 
-			folio_unqueue_deferred_split(folio);
 			if (folio_batch_add(&free_folios, folio) == 0) {
 				lruvec_unlock_irq(lruvec);
+				folio_batch_unqueue_deferred_split(&free_folios);
 				mem_cgroup_uncharge_folios(&free_folios);
 				free_unref_folios(&free_folios);
 				lruvec = NULL;
@@ -2041,6 +2041,7 @@ static unsigned int move_folios_to_lru(struct list_head *list, bool do_rotate)
 		lruvec_unlock_irq(lruvec);
 
 	if (free_folios.nr) {
+		folio_batch_unqueue_deferred_split(&free_folios);
 		mem_cgroup_uncharge_folios(&free_folios);
 		free_unref_folios(&free_folios);
 	}
-- 
2.52.0


