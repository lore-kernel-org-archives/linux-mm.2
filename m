Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 737FBCD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 14:58:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD0BE6B0099; Mon, 25 May 2026 10:58:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA8F36B009B; Mon, 25 May 2026 10:58:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E53E6B009D; Mon, 25 May 2026 10:58:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 86BEB6B0099
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:58:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4EA4940155
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:58:07 +0000 (UTC)
X-FDA: 84806247414.12.A83EC41
Received: from outbound.pv.icloud.com (pv-2002j-snip4-11.eps.apple.com [57.103.64.151])
	by imf05.hostedemail.com (Postfix) with ESMTP id 57A0B10000A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:58:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=b0syjqHK;
	spf=pass (imf05.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.64.151 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779721085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=glSRZB7qYzyzP+WE+xY0AvPw2Fx+WgnlquMKakDxzgY=;
	b=L8ABTlup4O5Nl9qG0FAMugXMcORhQendbXjc7EhymuDQpoY+Ymh9g/cMy9c28jgIkwnEeS
	5MjW8ZqmVK37DwA1N2Y4kl6ygjXqg1vJ46Yx35ntwod0uy6Z2t1FWC0no0Xx8y943jNBmG
	xyA3bqz2Lb+7BweL4r9GzBQ1w2CImx0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=b0syjqHK;
	spf=pass (imf05.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.64.151 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779721085; a=rsa-sha256;
	cv=none;
	b=ksQqCSR9eOPepR75H/+urkpmrozgs1I3kRccXsKehuzoARJM52tXcIhuEaE4TSQ4yg/s8M
	GOSduKh82JeCY9WPO6Wxfj3ef6gRiTQgUSQdmdFKrdSzSizAsPP7lgLbyIZOAn4Xo6Zg9i
	v3wl+axE2TV3MI8t8Vc6+oWx1gKeZMA=
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-11 (Postfix) with ESMTPS id 1F8711800108;
	Mon, 25 May 2026 14:57:59 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhMHV8FRQNBF0kFWBcOVk1DEUMdUhlfH1cTVhR3AlEcVg1XQ1QEX1BfHA4EVAddBV1WUAJaS0ATBEoDTV8OXh8EF0YZVQRHHl1WQxsZAlEcVg1XQ1QEX1BJDEFQbFoARxdIHV0ZWW9QXRwOBFQHXQVdVlACWktfGV1FD18HWQRADEoGQFUKRhNRVUcBVUZUHEwLW0BBXx9FFEAAWg9SVkZYGlBdBytbE1UXRgkZCF0dB1hHFEcODxlaFFwYUw==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1779721084; x=1782313084; bh=glSRZB7qYzyzP+WE+xY0AvPw2Fx+WgnlquMKakDxzgY=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=b0syjqHKe5m8sEa5mjo9gzrLwyj/1hYew5dL7+TxH4KJPOqfdQP68abcQUsl5RiE24Bxyp5UN2ERcCi+jYl2+Udp4VhRyXtC0TV99vaGs9uvdsKbXnS1nDVgDUbqlKGcnpv3qlpuMLQ4JOMCiWtyvIYSHb2c9ROPj//6yxzIwXrwmVnLhks/1pUasKA53vI+5I7s9iR1Tr7vR6AKxd806jL4omb/nxwhQWkyWJ+svm5S4ejhgtsHiy+Mv2Rh34c/h9P9dm93ojWd/xtHnYsuVOYnDZVfYZFFFMm2NTBpzLMSmL271CYeHTKr3oqnnOAgiBrSQuo01S70JimNHEcTog==
Received: from [21.6.122.162] (unknown [17.56.9.36])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-11 (Postfix) with ESMTPSA id B38E61800106;
	Mon, 25 May 2026 14:57:54 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Date: Mon, 25 May 2026 22:57:21 +0800
Subject: [PATCH v4 5/5] mm/vmscan: flush TLB for every 31 folios evictions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260525-batch-tlb-flush-v4-5-83789d6abc00@icloud.com>
References: <20260525-batch-tlb-flush-v4-0-83789d6abc00@icloud.com>
In-Reply-To: <20260525-batch-tlb-flush-v4-0-83789d6abc00@icloud.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Qi Zheng <qi.zheng@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Zhang Peng <bruzzhang@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779721049; l=4660;
 i=zippermonkey@icloud.com; s=20260309; h=from:subject:message-id;
 bh=FWLnZtBsgkDD4unwqq+UsbASxXu9ry+CTqe6VRI1hwc=;
 b=V81iD8yRixX0JkLjM5uHOGjjzBjRYWt0MW58Oo6j+EDjPE3Zh2mkGCpfaDeUWSucJScR09KDm
 CI20VgSvN1KCySr1FBIKv48L4vo7Y4Url2xwZBuk39zJVGiFBr5t1SG
X-Developer-Key: i=zippermonkey@icloud.com; a=ed25519;
 pk=tPCLpFnBfIyHsp0k7eaUTUREEa36bQNW/69X+NS8wBU=
X-Authority-Info-Out: v=2.4 cv=eb8wvrEH c=1 sm=1 tr=0 ts=6a146379
 cx=c_apl:c_pps:t_out a=azHRBMxVc17uSn+fyuI/eg==:117
 a=azHRBMxVc17uSn+fyuI/eg==:17 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=f5ToH5UDdWaC3ggAQ9UA:9 a=QEXdDO2ut3YA:10
 a=J82S1U87d15UFHHUFZS8:22 a=R6HnoDE5lksTgPyyjrIf:22
X-Proofpoint-GUID: V00D_MVgD7_hmVZGgeYId9jhY3GqtA3o
X-Proofpoint-ORIG-GUID: V00D_MVgD7_hmVZGgeYId9jhY3GqtA3o
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI1MDE1MyBTYWx0ZWRfX035GMCzTCufn
 9g8hdCd4ce9bLyLERu1Rvso25NfOoharizfqG9dhThUN6CHfal6DhYOANtU0CkbJ50egaTfxxrt
 aHJkDI/kAfHkqdT3y42NxaVzPIYnM7OfP2RjYZ/nEkKgSHeO6Z40TsdTD6Czfelso5YK4zz3XTg
 rbCHH96ciGktIHV8CMVK0IKUbTjZ9sIMJQgZ2LfzLop9ixQdG5etTMuzjdMNqYzafK1v90PHWiV
 +Dck+hnIcCGAoHDr6eu0DmndK2K49mWNMJz9Cb6GoL2UYiWf8nsBWA21JnRQejAjW2oB1KfGbbe
 K25Tj+1mYNruPDiex+aBcT8dmljbzSXyXyXdBIUeax0S6E8oO0HFU+uXaPslUU=
X-Stat-Signature: c9d4dwbz4w8k6z3n3ibnzk4w3kjhaggq
X-Rspamd-Queue-Id: 57A0B10000A
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779721085-191907
X-HE-Meta: U2FsdGVkX1/MJFo3gp4phYEaBCNWpa1tKtvVwKcC2zwnbR7/U0FZK+LbJR9xfk4cTJH2WwW4qOo9YR0RySpBV+toXK5o7xeN4+FimyquGsPaM1X1IS67Ahou2MJzOQCildGdfW8e6/rBI97tXsv4vheGfRCJk6S2m8459yeNqkHZMEcDTMbiweQBoLfrtYFUxoNt25LBCD92VtO3/ymbN2y01R19YVkrDJWH5KxMwaOQWW9y1BFHipTXCb4GVJlsxOyjYKKjFDpjwTns/kfxZ5Qr1k1l0YkrsKCp7/dV2VY15QCbnU12ScgAhYpIzR369mVcXz40v6tmOGqcuLY4MtTA8Td3AkD2TGvjClTuPiZkbDgCW+CjUAu99ZQwP/yli8/nxAY+VWb/f5B5KqhrGE3vIvRyPtKRarM/2fQA1UVYlt/4VDKyAbh9NT08kyjAXEUhckIe5Bccxe7oIVPpZmvdT4zOf3/PoLvDcR4TBBCqjFBLS9erQ6cjyuTBBrQ4Hv+YvQFvRkTHynYfkm72HfKmm4oyt+faaB6rTZHvFmFzY40QzQzQz9fnjxKN1gfEl62PoDVlYsQCwx8PtkZGrG8qCOTHQQeZu1iW12JCWdnbuFwYrE98hIvDHQfdhRfZYm5KoR0jL8T02yvrmDkp9MLDj2+0sirVtnxC3z4vLn6pWBur0W1nxWnsaGnO5tZCwSKS1DZCjIp54ygkKSxQDbZd4DYMA7OawVOBWTRu/LHww0HI25XUj9njC5HxbtF1tkVkwpMND+yPXhVQjRcQwNBrmDEXCfcmarAmdYUxiaHiatDwKvBLMH57Is5sLet5alhWjcuCtApWyDlCFyWpjTQIgSmTgB7oREEL34yzk5qeWgLRFi6RslTnIVAon4UqtLdXK0HEbqSTtjIQuN1QU+yUHrAj+UeHultzJpzGjCIcWG/RKkLMssWZBNQiaZ0D9VGBgrm+GNSlSGs3Mo1
 30M9EMQC
 LP97vwFpBR2gOllRVo+L+pTVW3noepXkQq9z1HEI14pfbxzr/lp3mVfjJC//oc1MZTAG+OhiIjy7rUd66xdh94MvXH/f+AykivdaX5TGxrdp88KzFhsCwjLENN8iB+dHokU8LezSb3+tfNaXQzMx7AexuKFD7x3a18oeaa2UpdNy3QkCKDvp/MO7gZ6smG4vcavx8KrMbzu+oMicYimtBgb5CPP6M4fqmL+kqLSMY9DD/tW9fZR75mctOzG8vwIUFNYIA38NyECV+FRvAffINaDfyPsZwrQoYgiE9EGMgkI45CgGNEEIVsFPTKHH/g+Q1uiUUlP3fe7Mak9cvXP7Sm/sdF4CjOZVAx6AAr4Q2a1LFUSYweOCVUww6MDhTYk7Ghss0jqFblIrVfUIjj0LyRYko2B8zafZAqdfo3tkn0e0MELOQhaAuvr4wuypRUJ8n/HeF9ZfooAoxZWR64mOwnJnAVSdMPbEjlZ8SRJJzcTEHMAM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently we flush TLB for every dirty folio, which is a bottleneck for
systems with many cores as this causes heavy IPI usage.

So instead, batch the folios, and flush once for every 31 folios (one
folio_batch). These folios will be held in a folio_batch releasing their
lock, then when folio_batch is full, do following steps:

- For each folio: lock - check still evictable (writeback, mapped,
  dma_pinned)
  - If no longer evictable, put back to LRU
- Flush TLB once for the batch
- Pageout the folios

Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
---
 mm/vmscan.c | 79 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 71 insertions(+), 8 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index abf3a2878456..c0d22afe67a5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1221,6 +1221,57 @@ static bool pageout_one(struct folio *folio,
 	return false;
 }
 
+static void pageout_batch(struct folio_batch *fbatch,
+			  struct list_head *ret_folios,
+			  struct folio_batch *free_folios,
+			  struct scan_control *sc, struct reclaim_stat *stat,
+			  struct swap_iocb **plug, struct list_head *folio_list,
+			  unsigned int *nr_reclaimed)
+{
+	int i, count = folio_batch_count(fbatch);
+	struct folio *folio;
+
+	/*
+	 * Reuse fbatch in-place: reinit only clears the count, the
+	 * underlying folios array is still accessible via saved count.
+	 * Filter and re-add valid folios back into the same batch.
+	 */
+	folio_batch_reinit(fbatch);
+	for (i = 0; i < count; ++i) {
+		folio = fbatch->folios[i];
+		if (!folio_trylock(folio)) {
+			list_add(&folio->lru, ret_folios);
+			continue;
+		}
+
+		VM_WARN_ON_FOLIO(folio_test_lru(folio), folio);
+
+		if (folio_test_writeback(folio) || folio_mapped(folio) ||
+		    folio_maybe_dma_pinned(folio)) {
+			folio_unlock(folio);
+			list_add(&folio->lru, ret_folios);
+			continue;
+		}
+
+		folio_batch_add(fbatch, folio);
+	}
+
+	i = 0;
+	count = folio_batch_count(fbatch);
+	if (!count)
+		return;
+	/* One TLB flush for the batch */
+	try_to_unmap_flush_dirty();
+	for (i = 0; i < count; ++i) {
+		folio = fbatch->folios[i];
+		if (!pageout_one(folio, free_folios, sc, stat, plug,
+				 folio_list, nr_reclaimed))
+			list_add(&folio->lru, ret_folios);
+	}
+	/* Clear the batch for the caller's next use */
+	folio_batch_reinit(fbatch);
+}
+
 static bool folio_try_unmap(struct folio *folio, struct reclaim_stat *stat,
 			    unsigned int nr_pages)
 {
@@ -1265,6 +1316,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		struct mem_cgroup *memcg)
 {
 	struct folio_batch free_folios;
+	struct folio_batch flush_folios;
 	LIST_HEAD(ret_folios);
 	LIST_HEAD(demote_folios);
 	unsigned int nr_reclaimed = 0, nr_demoted = 0;
@@ -1273,6 +1325,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 	struct swap_iocb *plug = NULL;
 
 	folio_batch_init(&free_folios);
+	folio_batch_init(&flush_folios);
 	memset(stat, 0, sizeof(*stat));
 	cond_resched();
 	do_demote_pass = can_demote(pgdat->node_id, sc, memcg);
@@ -1568,15 +1621,19 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			if (!sc->may_writepage)
 				goto keep_locked;
 			/*
-			 * Folio is dirty. Flush the TLB if a writable entry
-			 * potentially exists to avoid CPU writes after I/O
-			 * starts and then write it out here.
+			 * Unlock while batching: holding the lock until the
+			 * batch fills would stall swap faults that find this
+			 * folio via swap cache lookup. pageout_batch() will
+			 * relock each folio and recheck its state before
+			 * writing it out.
 			 */
-			try_to_unmap_flush_dirty();
-			if (!pageout_one(folio, &free_folios, sc, stat, &plug,
-					 folio_list, &nr_reclaimed))
-				goto keep;
-			continue;
+			folio_unlock(folio);
+			if (!folio_batch_add(&flush_folios, folio))
+				pageout_batch(&flush_folios,
+					      &ret_folios, &free_folios,
+					      sc, stat, &plug,
+					      folio_list, &nr_reclaimed);
+			goto next;
 		}
 
 		if (!folio_free(folio, &free_folios, sc, stat, &nr_reclaimed))
@@ -1601,6 +1658,12 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		list_add(&folio->lru, &ret_folios);
 		VM_BUG_ON_FOLIO(folio_test_lru(folio) ||
 				folio_test_unevictable(folio), folio);
+next:
+		continue;
+	}
+	if (folio_batch_count(&flush_folios)) {
+		pageout_batch(&flush_folios, &ret_folios, &free_folios, sc,
+			      stat, &plug, folio_list, &nr_reclaimed);
 	}
 	/* 'folio_list' is always empty here */
 

-- 
2.43.7


