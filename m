Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F038CCA490
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 00:48:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15C356B0088; Fri, 16 Oct 2026 20:48:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E5AE6B008A; Fri, 16 Oct 2026 20:48:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEED86B008C; Fri, 16 Oct 2026 20:48:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF7A66B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 20:48:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 44C0FA74BB
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 00:48:14 +0000 (UTC)
X-FDA: 85330281708.12.F304016
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9C5261C0003
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 00:48:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IyI5lHpH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792198092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9LzMb59cyBGnEfMp22f67zI9ONykL0xzCkuzFl5P5Qs=;
	b=icxuuAMh0ZmyBWM8jdCOTbPkMRXHUdpW39iyh/5e8smTTSRNBiJkS/Y7Mzf15g481xQPs8
	dkpuEmHoB4plWGC5gGAE6ZOhNNUlJnD/azSTsolE7was4jmPgpzpaZw0ZMRZT2TtBsDClc
	Iocet/4mnkgHsyAiQnCnNk0kowiljx8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792198092;
	b=CFvOeALFbptpDE46XHgwG1bUsc0IWHLgWMbBX1Ulzb5QXOCcW+p59tfhLiqtIh7O/KIi+7
	1nFQHurr5SaIKncmYn0xhxx8HoDgcC9qGLp5dzRYDMXlaa1c4NQANDMOqtUt2tR0BIjQf+
	p923ejMH9YfYyuWiYeedIoLs8AeO1LU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IyI5lHpH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-8446af403b5so200113a34.2
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 17:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792198091; x=1792802891; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9LzMb59cyBGnEfMp22f67zI9ONykL0xzCkuzFl5P5Qs=;
        b=IyI5lHpHNhvZAc6onjRjwCyXIZTpsude54y7Np8lmcRofXegeCzI0k0cAgCplzfxlk
         kB3IND6Id16V3zzRy+DJhr4MECDWrHUmO9NcX2+d9DZY5jWgxDodvW9jyIMe26QAkNbk
         1oJb9wQzsyYPW8X8sZYKdp091kE+RLcU4Reapkt4v5B+598S148wqMZYZIijRNM33v48
         +EN2jvc4CH/evT0t13M6BTLxYUZvdhOYWfq+21ukZBFI5E5AGqmOuHLdn28FcmytS1lD
         1WfqfRMVxPyUxaPaGwyed8p6t2+vXBf2V5wxackQDcA+lgrLYoKGMymP0fzicb+3819W
         4n8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792198091; x=1792802891;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9LzMb59cyBGnEfMp22f67zI9ONykL0xzCkuzFl5P5Qs=;
        b=uBAfFegMhnuT08gQv40w9awokjzIMO7rPAPvn99sLD5BmQtVX6zfLpbBiDh+9cU7aF
         wAVnyBAEHm4SHSZOdL5/sIL8WrGuTh1xaHteHAXubcr/5qXGb9tuV798KKYjz+E93QWP
         3DOfStDIskcYUhQXg1fA13BV4LHWc6BjatTkBrejNGGWp+BKGzPsF59+FutR6XCAoNyA
         RWrwAnigPmXw0E9Erx1n3vAbRZeYWRTSSf8muQX3lqPP3xQrwdY/iuZqHADsCGaEYa+o
         IBxplnJCoFgGY8sA3gyFPsO9bDq9I9MRRSILnTaG8Zqe/syf3yNpWhNSMD4ykyKj06dV
         mHiQ==
X-Gm-Message-State: AFq9FYJOWPEM0mQ4IGeKhY8RY0FVEZQgXgNwLrA3/IgWNUdQX90HKOXr
	BI8XGuzDlhZm1H5/VIGhxlKzfc8EfnFelOKBhbkEBKtJzYWo6wK4wTy+
X-Gm-Gg: AYBFou3uUNgt101eF9T5Yi2Zki4ur8kmg+60MG4aYbVdZkYPtIyeFMe/cSnJYBPOK0c
	mmuMwlT3BOJSj6MRaUk17TtsIKaBUq8wlVLbiSLS5nz21Nx5zj2/1wlgesv6X50Lup6ffmGfwzZ
	tjQDS1hS8cdjm9k/UUCi7PxBI65zc4JQNLC2fAAeh0tuEajgkgpOjl+ITKfXxtCdy4fKlsk9Rua
	Y3ZdrEQ9jkq5MqFARAis+pfcFktNbOrETaL8noQ57xQNZixgFutpzmYljzvzHZISnCdbokmmd1u
	N+f/Nu8Shju+thrA+QSNJDqquwxefDNYsi6HD77N57Hb+M84TnxOK/F4MGevQf418NuHf3h7Ie+
	D/rz7uPLZomha6Sd6hs4oXXkcV/jaR2syuAWueDfkdg3d9/ITeKcXWRgmkpIirQvIsQd+YhYAkU
	SgUjsHdbgkxm0XtHpQqa9+dEYtSg8sNnzYorirHHfulp34BjAq/vPe1Zcr7aDmBOFHN19qteoLX
	0lNx6pMl6QYhGUpKSwWWZhr35CGDckNrCJXGEV/ZdyAWBNrH8c=
X-Received: by 2002:a05:6830:4acb:b0:7f4:d1aa:2f32 with SMTP id 46e09a7af769-84500595526mr1670876a34.11.1792198091605;
        Fri, 16 Oct 2026 17:48:11 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:4a::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-842a0f31614sm3090730a34.3.2026.10.16.17.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 17:48:10 -0700 (PDT)
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
Subject: [PATCH v2] mm: unqueue deferred split folios outside the lruvec lock
Date: Fri, 16 Oct 2026 17:45:55 -0700
Message-ID: <20261017004555.2890038-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9C5261C0003
X-Stat-Signature: mijjmk4ctpqb6x1c37arfnrjsrikzh9p
X-Rspam-User: 
X-HE-Tag: 1792198092-678215
X-HE-Meta: U2FsdGVkX1/nO20j2FswSDIB2F9tRyid+NLQzml2qY7m2PKJqJAaBifdn6pcsNXYjQrb1m56XQRuWOjJ+mwGpKI4y8xmBcMJbO1amfiC7wZya+SFilzhtBZbYZtQt0ed03K+2DhZUSwqBIjdeOAGTDs/YO7ehJLR8XPkrKrnZZfRzS2LWvacKj4yagqFt2Dqky6b8a7RmHKEJFjv09LOWEpYbDcBa6oUOVwaB46uSRFE91iOAWVH6ujnhyQhboMDQFoRboGNbs1pvBi+FJV//9cIUuMWr2fSxv29FzM8hc3OJzFC9w4kdgwbttHucFoZBzbLCGlM9nHG2Py3nX7Ue6UxaKR2B1llpED8VZML/rD6YMGOPJkYRllDTKSMHRxD3dZNaaxcE4XpnhuiXCFYcNbsQIPDBhIL0QAAaLbEvBx36/gZwwpCjrLxWkHj3b5vB3Hm0429nbyaXHsCOGgq/xwyXYtDNXYKPtzJ0Qb+18+lXm7UvTATrjW6CxagBYQ000/D6M9hlIRLij/K932nghc+uS3g3R4FKwOhI4vd240scbM/mXZEwehDjdiGVuUp9ZsaqZ5aUyqBMf8d2BTqh911X/uPmR4z/wayXQE6N3lGHCXWJ0I0ukqtAYEI2x1owh5i/W8VXacYqwdCngm3tISeF1ecdjrftaNnaAi0N+dwFxdoRriQM1x8133r8h/kQ0fmZU4CHf1qGEBEDS96CSw1ws98ca2wNAmnIVh4SVZt45dk/qnaTQIdne+wmqrkv0mGQuwCo7knR1wMSxKEfuCIphwLj8Y3a+n4Ei/g2kDXpj2VAL1cvHF/YlEyxhaJP8gO0KFSng1vrEVQFPjwPBdKHRKTwIqCahzH3tOasFXwKdVJBWhLXXp/Qmfiozma1qMDBntjIJbAu63xAWDM7oFEr4x65ZAeDrXPRBbWW/fAcNNIT8E+pQA+rw8KnmrGRbCAQlyIOJaB2VUu6z/
 VXUNbFHT
 X3OKYOlZzJNZXQzuTvhhvG8t6vrZQk3zbgypdbq9TgE+kFB7vFEVfH8k2rYoa+7jad8kJ/gZuN5qRMhCLk0crmw2YRm5u/k9aNnBrRDwwMdAWxa6b4lOsCXuaw3poLxIR3WK7h7fYPrSeLxJ2bhT1BJ2AKjlnIIwQwy1lJb9Ts0lT8arV3dvCi/38dep8Y406VminBWy1O+FzJMeTetgy2XNoEK3Odhh5CoWSOh5L5oNzaZd9ji+PMsmmqSf2OSgF5QBzwSpX95cPmMER+9IulaohhHx9VYBf6FINh0z3412+gfgw6Lxpx8bJ5EhZ+R3EVZr22EC1qDeePApWQKVCdeH+SIHiO8pzOyBTXIQVmru9tDNDlvyxDT5dgsLrh+QS7cg29J2w7kRRb4SXqhp1HPAEs5NDziHknFzBRMxAQlU1ZMlrSNtwgiBIJJWh2aDd2a25Bxp1DVh2XKs=
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
This patch came out of a discussion about splitting underused mTHP folios [1],
where queueing small mTHP folios on the deferred split list was found to
regress Barry's fault microbenchmark. The cost turned out to be the unqueue
running under the lruvec lock rather than contention on the deferred split
queue itself. Testing this patch on top of the series in [1] with the same
microbenchmark, queueing every 16k folio went from a 15% runtime cost to
noise, with lruvec lock wait dropping from 491 seconds to 38 seconds (most of
that contention then moves to the deferred split list_lru lock, but runtime
still drops back to the unqueued baseline).

[1] https://lore.kernel.org/linux-mm/CAJnrk1a2PpUGTsCgS7jct2KET4K2zAL+_h+te8G1MaU9bXs99w@mail.gmail.com/

v1 -> v2:
- Reword comment in folio_batch_move_lru() (David)
v1 link: https://lore.kernel.org/linux-mm/20261013221307.850803-1-joannelkoong@gmail.com/

 mm/folio.c    | 24 +++++++++++++++++++-----
 mm/internal.h |  1 +
 mm/vmscan.c   |  3 ++-
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/mm/folio.c b/mm/folio.c
index 35e242b48870..45c814f3857b 100644
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
+		 * Unqueue any large folios from the deferred split queue to
+		 * avoid a dangling list entry once the folios are freed.
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
index d497c35ee783..33ae388feb33 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -761,6 +761,7 @@ static inline bool folio_unqueue_deferred_split(struct folio *folio)
 
 	return __folio_unqueue_deferred_split(folio);
 }
+void folio_batch_unqueue_deferred_split(struct folio_batch *fbatch);
 
 static inline struct folio *page_rmappable_folio(struct page *page)
 {
diff --git a/mm/vmscan.c b/mm/vmscan.c
index daa7e37c2236..9c71a50309e8 100644
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


