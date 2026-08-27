Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDF2AC61DBE
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 03:05:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A726C6B0088; Wed, 26 Aug 2026 23:05:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A22226B008A; Wed, 26 Aug 2026 23:05:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 937F36B008C; Wed, 26 Aug 2026 23:05:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 75E9F6B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 23:05:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F26A9402D1
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:05:44 +0000 (UTC)
X-FDA: 85145559408.17.79AFAEE
Received: from mta0.migadu.com (out-166.mta0.migadu.com [91.218.175.166])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8A1E4100002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:05:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="qV0/WMtn";
	spf=pass (imf14.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.166 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787799943;
	b=yqqZi5Mpc+KE9DcjO2QoeeGmM0eWTQsr0YS/+qq0q7EX0A4wAEVg+1MqG34rDap2EMyZ9+
	wzU+nwxwxmvIrcq2KPQyYw58AU2xblCqCwbVNQP0G05qNpvZFKo3pNrcaMwMKDxLyTwnOL
	g920zbsqpDQgdQpZv/QS2vacIKfOyWc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="qV0/WMtn";
	spf=pass (imf14.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.166 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787799943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ROMIK9xZAs9dm4hrTGInvQ2PHfsRSQUx3wPQZNEM3tw=;
	b=TxR3dJWZ6kLfyKqAW+VvyqwYn2pdShH97FXwpSVMYqIk13D6ihkio5Y3buqFtHN48/9TrA
	Clhn8iZIqM/aOFCyIG194K6/mHLkfLtR9p2b1p6VeC7JowO5qEtKmNwfZkQoGOmmdjaua6
	sjQ+w2IdVrLuLO86cHbInVnYCavgOg8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/kXkE6EgK7Xu/D9nmz3lVFVzvuwgd7TR0qfSXqA3DEM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787799938; v=1; x=1788404738;
 b=qV0/WMtnICRvc5EaONbUC6kNQX6pBCkoDLOwK+1vlDyWhmafPfMKMfkn8ggeZXkcWqPgkNcK
 Aga478H33DveslE8LnpfxoA6mxGaWAMxPeSUEMkLgdIi9Fvh2KboSg/bfRk+VoXb7YIJXJtiLsH
 t+vLGsRk9u6sNXQI3YHLHv5Q=
X-Envelope-To: linux-mm@kvack.org
Received: from mi-ThinkCentre-M760t.mioffice.cn (14.29.108.92)
	by smtp.migadu.com with ESMTPS id e84e612d5d5de145;
	Thu, 27 Aug 2026 03:05:35 +0000
X-Mizu-Trace-ID: e84e612d5d5de145
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH] memcg: sink mem_cgroup_uncharge_folios() into free_unref_folios()
Date: Thu, 27 Aug 2026 11:05:16 +0800
Message-Id: <20260827030516.462926-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ukpzmu87e1mj6x5sjm9pg8sye9rf81jm
X-Rspamd-Queue-Id: 8A1E4100002
X-Rspamd-Server: rspam06
X-HE-Tag: 1787799941-521236
X-HE-Meta: U2FsdGVkX1/b3gMzzxVwbAvIhU7oHuJ+UkPQBzIoyFC8dmyaHRQ2BT4aI4s6wQDajWE1JyGZD2cuyjd+8zKZNFsEVYnaqwE72I5bbLCz7Jk5wU445BnWcKALL5ob6GEs1NtugVyP7JHb+zXFlF4KG53ksIMw9Npud/Mq9YufiYAou3bNkleke3RukMOj/b80IjZXNpftS/gKCAxUlDU5tM7nK8K4YHLHWdKG5Mg/O/C78rxcGgUV8RMT2fRottZnBaaBcvZDe1TRd62Ygwq9JzLN6ZylHN6PGFnG38+YE2466sRfzLoFY1lrpLJhZuDZmdCzE3Hz0F1eDPPeHU2VJKsXLzHEpxhPnPBBfutv5QVcEpWQuTuRQ2NX+EDvNGbZpR3NAmbX14Xn0frmpboMRMUOCAVVRnljA5muYo0gnG+pYe/JL1WnwBWKaExuZgEPwOVnIlppnj2wP1Otevu9bEhUzLmW6P4cljrQR0s/ceHqQjM1PxJ9tMC6IcN7PtN5T9MyTrDlcwUAHbseXhbVpe10ADNDwEiggM8FzEMsMU/DYDc0p/PCeNIT+lDDk50lrwUMhGlPMOSWoKgLDRO8xOmR/qwDRu+xn6D6l9/Qn2wwRZEhY+ofPoxf4VMNbPu81TV9kaH0kDRBUouGFMtFfS091n9RO17+G/UmSFnGdrMwA7ylufO/ex3Chkcb6I0wx/BqT1kSj40ndKdUjQfvTJtRNdfiabkoG35/mVnyWcBICn1b6pAuhxpO88IQ9ld/q6QhAb49qqrhKgcpfrtqIXETKwSDU6ObwH5bAMwGjLX45b5M4P0LbfPYH+MePO1afCNKH0vmOCuBJBgt6Ya6cEEMLBVBo/NiV7d1MU9bPahahYal5S4TyS/+/6azNFBqV1NE377MNX9RkWdEViENxoZ8BcsSTsPob4Fx4kem6wBu01cm1VQjkhbkSwknp5IqZvmZZoHU2RARM+hIyyK
 T7stwHBc
 OxFC80a/nNt/p7CwSy8c61ogYwnLxVLP9/vUFXUojho0S8li55eB3gfH51Q0a5faTAPev2QrFKEVfBtM9qy7KOZ3HHNgIv1oZJJrxF9BbCB9l4gB5nxsVC7+Q5hojLod7Y4WFpSP2XDrBo1Tl+T2xeFEsAwfBpPKvn/kPFWlYjQE3cja8PUsawGZ0jTqWQUaFKsp/58CmQuZ8ZG0TnjrzPUXDeczqYGgai6zjof/Wy8mu1bAYKGmwXRjQ0W7SErMNpEOqg0HX6UGBylxjz/0MKP9OSckvDrjV3EQJPNy7BCejJ+k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

Every caller of free_unref_folios() invokes mem_cgroup_uncharge_folios()
on the same batch immediately beforehand.  This pattern is duplicated
across shrink_folio_list(), move_folios_to_lru(), folio_batch_move_lru()
and folios_put_refs().

Move the uncharge into free_unref_folios() itself so the batch is
uncharged in one place before the folios are freed.  This removes the
repeated boilerplate at every call site and makes it impossible to free
a batch without uncharging it first.  No functional change intended.

Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/folio.c      | 5 +----
 mm/page_alloc.c | 1 +
 mm/vmscan.c     | 7 +------
 3 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/mm/folio.c b/mm/folio.c
index c02dcea9c03c..2edbba47be1e 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -199,10 +199,8 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 		lruvec_unlock_irqrestore(lruvec, flags);
 
 	/* Cleanup filtered dead folios. */
-	if (is_lru_add) {
-		mem_cgroup_uncharge_folios(&free_fbatch);
+	if (is_lru_add)
 		free_unref_folios(&free_fbatch);
-	}
 
 	folios_put(fbatch);
 }
@@ -1030,7 +1028,6 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
 	}
 
 	folios->nr = j;
-	mem_cgroup_uncharge_folios(folios);
 	free_unref_folios(folios);
 }
 EXPORT_SYMBOL(folios_put_refs);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c48..fb1ecab0ee78 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3013,6 +3013,7 @@ void free_unref_folios(struct folio_batch *folios)
 	struct zone *locked_zone = NULL;
 	int i, j;
 
+	mem_cgroup_uncharge_folios(folios);
 	/* Prepare folios for freeing */
 	for (i = 0, j = 0; i < folios->nr; i++) {
 		struct folio *folio = folios->folios[i];
diff --git a/mm/vmscan.c b/mm/vmscan.c
index e572d2742c8c..113e2e49447b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1506,7 +1506,6 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 
 		folio_unqueue_deferred_split(folio);
 		if (folio_batch_add(&free_folios, folio) == 0) {
-			mem_cgroup_uncharge_folios(&free_folios);
 			try_to_unmap_flush();
 			free_unref_folios(&free_folios);
 		}
@@ -1575,7 +1574,6 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 
 	pgactivate = stat->nr_activate[0] + stat->nr_activate[1];
 
-	mem_cgroup_uncharge_folios(&free_folios);
 	try_to_unmap_flush();
 	free_unref_folios(&free_folios);
 
@@ -1902,7 +1900,6 @@ static unsigned int move_folios_to_lru(struct list_head *list)
 			folio_unqueue_deferred_split(folio);
 			if (folio_batch_add(&free_folios, folio) == 0) {
 				lruvec_unlock_irq(lruvec);
-				mem_cgroup_uncharge_folios(&free_folios);
 				free_unref_folios(&free_folios);
 				lruvec = NULL;
 			}
@@ -1920,10 +1917,8 @@ static unsigned int move_folios_to_lru(struct list_head *list)
 	if (lruvec)
 		lruvec_unlock_irq(lruvec);
 
-	if (free_folios.nr) {
-		mem_cgroup_uncharge_folios(&free_folios);
+	if (free_folios.nr)
 		free_unref_folios(&free_folios);
-	}
 
 	return nr_moved;
 }
-- 
2.34.1


