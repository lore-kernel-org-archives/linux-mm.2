Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A64F8606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 23:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=NomjYpu5
Received: by kanga.kvack.org (Postfix)
	id 4B6F86B0108; Mon, 19 Oct 2026 19:07:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41A356B0109; Mon, 19 Oct 2026 19:07:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 294D56B010A; Mon, 19 Oct 2026 19:07:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA20C6B0108
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 19:07:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 724F740870
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 23:07:13 +0000 (UTC)
X-FDA: 85340913546.13.F41A3AE
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	by imf09.hostedemail.com (Postfix) with ESMTP id BDB0F14000C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 23:07:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NomjYpu5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792451231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=X003jIwSoXQBeRutj7xwYcqrn9qDTaY/gDPTqo05RfU=;
	b=Uq+sImdMCwwlW0GbvwJ0ATst+Q4J9+/Ikrjg76qJL3NJ7c7xHmHt/NEGvn8MznnOkcAqUI
	foMe9IvJtFvJuvTEnmjIBvOjFkejvnHuhHzHBxVYI9bR3yqWUkZXoM3bcw0TtjKVk4z5qA
	3mKALCH5x5woen0+sDiE/wNs8KRDom0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NomjYpu5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792451231;
	b=PgJvg7HqAszS07uETtiFADTUrWqJJo3JBpHjhYGR9IXxnnBNxXdXKLQx1bf11ivCl+YT5d
	+6bPhLT7tJ8VFduc5qngFdPLIyw7hWCx6e0bwSgMtYjskEtPUZJRxy4SpPNOi7yCRr4gfQ
	YqoiWlaiZPEJgAD3fyCRQ2N/oFeGySY=
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-84751a20d87so1132493a34.3
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792451231; x=1793056031; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=X003jIwSoXQBeRutj7xwYcqrn9qDTaY/gDPTqo05RfU=;
        b=NomjYpu5uZj6hd4YyYmAC6lzcD5B1jf2UpXlyD1oYGtAhhezHTHnnnFZzKyRR+3aVF
         MTWH1NTvHlnecGTYApqtg+iAu5Ux8TdXbHzxbPcGZCoZotzMUa5Phf7DHnqLXPfSiyXQ
         d2vCfgFXvDpcMWa1D90h/pURZc1M9PNkUQAulAiDvQ+eblg+UouSYfOHuMgpswr5nRgY
         Uw+/wyW6BhGbeyPWf2kbH1OaFsx47U4WfLGsTvYW/OvoIqJDInQJb1nb+ZS+R3Jbd9u/
         uofIgxvWwtBFhCoLQ9n7j1WlrNyI/NwDLKmOOT/W16MUn/70D51IgQSrwXlI+ILtLkz7
         RJtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792451231; x=1793056031;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X003jIwSoXQBeRutj7xwYcqrn9qDTaY/gDPTqo05RfU=;
        b=pEf4j9qP8/yShiKCI/fXLzwqDUVzONJlFwY3UPG5xW0KEY2fr/YD+zF4aLfQBWkmn6
         Fhf6125CsiuQHmLI+YmjMiTd1w1IZtvXW2tY6NYqw1ScDjLlYhe77aQZBKzinT5c7npa
         mOGlewa/LnZYEuhYBDqRhr7QO9ruF7fNstkMnrVdzZefPcaF5C3rEVeNFPtZPmV3LbhR
         RjnJ2MhSdHAVJBCjul1Hw9PtQwfSir5KIIZOwEck7sKn0SryqMlCOrAUGuXpi2aVGFYJ
         x+a1QW7DXNQgUF92Q93P3Fr4rLGM2blkH6elwXb/awoUmSvP2lMtDYs5zMeMWHVHszN4
         1Vfg==
X-Gm-Message-State: AFq9FYLI1D2oT6QFMNpmTkqrYaDqK/EVz/ZDYhh/GEqjQbny8NcDcuze
	BvGlTtZc+7A2V8IRh1BHCHIB3rAV4tFuwT7ijsmNspcYCQKkBFApkSpm
X-Gm-Gg: AYBFou2bpVHKQt65djjNnUXw24VNMAQOfTd6NdkUSN0Nk+cbfYDH9CNylSw5HCBwPI4
	nEUTvkEjFRr9y4+jaxb7uR17RMsgrP/JuKK3uhsEmiUSuq8EvnZJiFxicWvasIu2d2uhriusXX4
	24T1bcV0tRzdvcCev2P4GoCfksLU1DxMK+zGaIeakr7PSpmhfNkhukHhI0LyeXuDTP8r69IrQ2t
	M6fpMbV9D6yBnJCgBAOnVD6naFLNja0WwGiaB+wJWoHC9dLstM0gCQEg+MNMW1dqOg1jmNpmW4j
	vCuXY6Bl7U+OxAgNNPPFfGG9pn4yxuGO08rwI1QFCum4ulMQK67/EfbnNfFXY/cAYS7Yd/ERH0B
	xq7ChHj8EF/dMrUZZ+xFGMZjdRx9IfxIS7m+0aNlaSEpCbvaJHQrhjQhCJmfDbPPVEEtc4nCTEt
	pTsfwQX6NvfoOQrXdo5+G/3tuhs+g9fVa9WYLXg+jMtc94eY7XhO/cVoGkF5HdzdpSYKS7dvn6M
	Frg+fSxJ8IVkzZxzfd/ukht5xLO4PcKQj7q0pxvtsE30wiMxDg=
X-Received: by 2002:a05:6830:4421:b0:81b:9724:8724 with SMTP id 46e09a7af769-844fe783338mr8650675a34.11.1792451230582;
        Mon, 19 Oct 2026 16:07:10 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:56::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-842a4a00f0asm9457269a34.5.2026.10.19.16.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 16:07:09 -0700 (PDT)
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
Subject: [PATCH v3] mm: unqueue deferred split folios outside the lruvec lock
Date: Mon, 19 Oct 2026 16:06:46 -0700
Message-ID: <20261019230646.3510790-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BDB0F14000C
X-Stat-Signature: iifcnbbancxmp3w9sausn6xz1tkewbkn
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792451231-839186
X-HE-Meta: U2FsdGVkX1/yKpmJS2d0NuB+wYC/DOXQsJ21Zeo1/w8RGJNam/Lb2eVb/rwiVZ2Hlv5VoauMqO6dfGGS+38xX6D/E7xGfCRtCxU47KOzU05mNHVYEtSKf65PQJJniQQQ14DclJ/Tmv0EyugMJbl2c0gLraFjNJQpCS+XrckxCC57Xx1eQbQuglbSe+YYmJm9OMIYuhxtCE88NTlAMZdKganRxExha/rjQSmYun51zUvUkdYupMzg1q/YwVAhC9f023q4yYw/qxH7tSrugdiOrauyCs7D5LqXUoK75fcIzlsT+CafbCRZKrirsEz5sld82V89AdOP12KwDM/2tPq2AZDsTIHUc6GMED3qdrIh3mP5VaBeOD5+LyCZhvSz+7PdhtDLda5qNWx+CyM3h5HE6mjIEGyQgy4NZofSljZlk956sWoB/1eIPG5now15J/H1GSkH0JPDRovUxNHHNw6lF0LM0OWI8MT5v8zQaz6zVjZd4NzyzZGdTCXNfsrc2k1E5w+9zSrR9jrB0V3oMkFmDd4wbWhxgLJZ3EsieSUznYb0nCQyokVdIO5nTPpJa1Vyt/iMAgJKN75WaHe06bW8AXS7dUB0+cc4s88WkVKNkeJ9ViEYTWeI5HfIUYEDC8QLzso/BH/LG/mQ/Dgm6MCipwxTZh0dmcMAiEIEcZ5C/VHT5fleszgUb4xGXxLIbAt1r2RY3YPPjBeWJHFnYaykvqE8uuYyxjcNLDZoxeC+YqwO7iBe/nK2t5w7cdNdGaaAyjN9mLOGB+rxFZxvVa9i5jaIcnGld7OIYyL7QBhvGLay8IPOrR7JJ6Vd2TLQi12M/5AZyDwfUNNcGfeuD5Nmb4ZCmyMN0UkqySwi1scScFgbbslkd4MIU3d+SnCgs3zBe+eDwZJhB1VXKPAabd22KiYbLk8iIoKQWrOFWRESjFrfpp4KEJVCeb4eo/puaKmloPfCz9YBsGWb7QiiHWs
 t2BMEmgN
 H0o4uDJIj5ZqgN0pmCUKXagZ/eVxV2TzzPBdZszBAV05Rt++naB9FU3Jt46NfH2DEMWa/FfVdsEhFimeXFhCucktDhlk1WGhliPt5iV2up77kkvYbhFjCqs7LkXyD8QOuWKLMqDyHPF4fVvPGZgU/D9zA4xGR8Nj63PZR24rqzDzzeWgKv+4OBMWKas9mY9duoxdKJPztp0CH08C5m72V4TbFt9lziKjO4yYHtjWwceCYo7QLdz+XWu7BU4JAHqDayoqds0m9MYb36rRA/tN8bX240CLu0n6LWy2mca8x77ga4yWxa4GKWbXfimdJpmJWG+fq8I+ngpaSpHOwIYSnDphAW9Qeq/CPvITHzgPgn07TF9ANJsBA06LbZlcKB7mXFLCVlJpVdClobqszjeQdyMQtgKl5+CG5B99m/OoNC8UGodW1dMHwTzbC/hio9eVmmqaBgA93MyujcbU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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

This came out of the discussion on v2 of the mTHP shrinker series [1],
where queueing small mTHP folios on the deferred split queue was found
to regress Barry's fault microbenchmark. With [1] applied and
khugepaged/max_ptes_none=0 so that every folio is queued, perf lock
contention showed that the extra cost came from waiting on the lruvec
lock in the free path.

Test setup: 2-socket Intel Skylake, 40 cores / 80 threads, memory bound
to node 0 so that all threads contend on one lruvec, with each of 80
threads faulting in and unmapping 16 MB of anonymous memory 200 times.
With only 16K mTHP enabled, this patch reduces the queueing cost from
15% runtime to noise, and lruvec lock wait time (summed across threads)
drops from 491 seconds to 38 seconds. Most of the remaining contention
moves to the deferred split list_lru lock, but runtime still drops back
to the unqueued baseline. This test uses a worst-case configuration ([1]
is expected to only queue folios of 2M and larger).

[1] https://lore.kernel.org/linux-mm/CAJnrk1a2PpUGTsCgS7jct2KET4K2zAL+_h+te8G1MaU9bXs99w@mail.gmail.com/

Reviewed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
v2 -> v3:
- Move benchmark results into the commit message (Lance, Barry)
v2 link: https://lore.kernel.org/linux-mm/20261017004555.2890038-1-joannelkoong@gmail.com/

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


