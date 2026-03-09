Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2C9CEF370C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 08:18:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48CBE6B0089; Mon,  9 Mar 2026 04:18:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 479DB6B008A; Mon,  9 Mar 2026 04:18:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A4C96B008C; Mon,  9 Mar 2026 04:18:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 28B086B0089
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 04:18:01 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E1CC61607D9
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:18:00 +0000 (UTC)
X-FDA: 84525821520.26.0CAD13B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id D6D39100005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:17:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fEFsOthZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of devnull+zippermonkey.icloud.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+zippermonkey.icloud.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773044279;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JcuT3VzEsFu9frAFSsd1UiMtGqA3cLyzc8t5FNxubjQ=;
	b=0hW/zfHQnhf6Q2MuUUMf9P+zhMn4GxZ1uiPs8EGF6irETiakHbOYhFwiQG+B4sU8qEzR2d
	0RCWyRtvS9oHqP1QddKy/HHfGT6Wqg55dTiLeUH6TfRGMeavnkJBXdiIMdZOroonDisHxy
	w+CVpKjedCRExNwSJDt6XatFcI4SOtU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773044279; a=rsa-sha256;
	cv=none;
	b=PBYPPNkGd3JD7C6uVys8JFu3QKP/acDMzBJ2KCEn1S298FM9DckX2s9yUXZ0Zc+dSj4tjv
	S+HkT5H+AZDpWGy4Maa6ueIxwlvzFviLZz92qa2ILKzf9AGiw8EvUejaB8bvnXzQ8o0L1b
	Nq6eFRgXtR+isANgbnvYEQ/n/aMM1VU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fEFsOthZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of devnull+zippermonkey.icloud.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+zippermonkey.icloud.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F0CE643AD2;
	Mon,  9 Mar 2026 08:17:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AF73EC2BCB0;
	Mon,  9 Mar 2026 08:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773044277;
	bh=e/JIvBv1sq81twuWbFDup0095/v1157Z2wL8P2ZuYk4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=fEFsOthZygR0BWYTfCXCH2TGc208NbRZ5QSmSyVWpEhuYy6oGDg3sU9yNzMhwsDSX
	 cb2NRnRxLHEiFLhXVPTKoS3dHlHkPx4tQPO4RCiVZaLvFZNgOX/pkE6op8T9fdSjYM
	 eqJqpbS/keXc5Sa2RwbJbW3B7EUNl1KoOTvMIgBYZIAozKHrHlZVJDsTmK+VullhF6
	 hrYpXiDBEfLXcTB50QN5SMBm9rBJSWqNZCmUqW/0WA8nVU+c5Ik2DyefYLK8DuZGG1
	 LjPDjjIJAgkZkpoXCjK2myXOvBJSCF6/RX+uzzsqlf1shz4wQSYsQrDZLFk9weJzUc
	 NHO1/cIZfKNPw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5F57EF3714;
	Mon,  9 Mar 2026 08:17:57 +0000 (UTC)
From: Zhang Peng via B4 Relay <devnull+zippermonkey.icloud.com@kernel.org>
Date: Mon, 09 Mar 2026 16:17:42 +0800
Subject: [PATCH 2/2] mm, vmscan: flush TLB for every 31 folios evictions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260309-batch-tlb-flush-v1-2-eb8fed7d1a9e@icloud.com>
References: <20260309-batch-tlb-flush-v1-0-eb8fed7d1a9e@icloud.com>
In-Reply-To: <20260309-batch-tlb-flush-v1-0-eb8fed7d1a9e@icloud.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Zhang Peng <bruzzhang@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773044270; l=4427;
 i=zippermonkey@icloud.com; s=20260309; h=from:subject:message-id;
 bh=VtbVoUdutucQYTv61lHy5DXkSCu6zJZpJudQ30ChVHA=;
 b=hb84Un+QVXegPOTad/271FdH2TnK0FCOWCwyQrjIcYqmfgBJ2uz0HVL0r8lRGfBXbWq4q5Q3B
 MJJHWQGILuwAzFjHJquHifaJ+c6i/rVn/faJo05uEQWnci0nAx0TqPg
X-Developer-Key: i=zippermonkey@icloud.com; a=ed25519;
 pk=tPCLpFnBfIyHsp0k7eaUTUREEa36bQNW/69X+NS8wBU=
X-Endpoint-Received: by B4 Relay for zippermonkey@icloud.com/20260309 with
 auth_id=671
X-Original-From: Zhang Peng <zippermonkey@icloud.com>
Reply-To: zippermonkey@icloud.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D6D39100005
X-Stat-Signature: p1bcqda13ysqwpjtmt8ggi31t663rgwq
X-Rspam-User: 
X-HE-Tag: 1773044278-966393
X-HE-Meta: U2FsdGVkX19DWnpmHV85HWJt+7S/3NsdShFj4q4MGQjcPevsxp9lfGiEwtG0RbKi5ik8j4pMglIKanN0ZI6HrRAZoZupwzu32UXg5vL7yjSw7lG0lP2o4Abn0X58tlzrh9FVoai7gShPF6hg58YmcZp1n6wHB44LHE2v5y+Nw1C5x+b1v0FQ/tAn8QsIcL2dESEFV3hI5zxVyw5Y+EnXZ2ATtCOsPVUMkvaony/28rwdU6wvi7pKy5FGRjemM9ZxyVv7AD/Vou8aZv9eANaVXYbSafApYH+rOlMg+YCQC/Uvg/EOw7eYjOOg+07fs+aRosl/d0K3sq21CaYaAHdK4PF8lNLoBNQjOBQlSz84Iy4NyYRkYwDDQ7fjyG6xuUA/UEkmeXWgZeDY7mls0ueO3KmRFGB4B8l0mZ3YLv7WqOFXPK3fM8nOKN0f1n1Epd9fU+W2uDGVPOKGb4wvqAMxkn4Pktbm2guVS9fB/zkvggk8RCSdrp0StC6eMXUy/2ZlJsKaLrHizcAJz/UuyKIqTs620doZk6J9EpL864/CT1gZjNzlKa+9kJ1YRpbdGjwc0c+2ZR3EPADB2D9RSayTlEHlTHuJeEmeCPYCYWz4WY6Clgxgc9tOO3u3mUDpRt94etH0mBd3wSi3yxGl++g6jjDR3jCkulKsxkrCkP+DWYWr8SXS4g26nMuZPpOiZfMHAvYUk46l8p+U0lBCmh3uaySOIuLVNVdXv24blOSt1oQ3tir6Y6s4wKvHrlstMNcz7m9IoCr3A1p2Kn0ONNbuHKIGu3d2bee5XKkqxEYpJe3MDaMxAr1LRghygwz9XfWxd48Mvph5zS9A/mquz0WA9oqTYaUTEOcRUNVUJFuk2xeroG4APrtE+g/jgDe+aNSrZ1w8TJZB/fhq4Zo8ao792fbeTZd8X60CzMJ0ZNr/kz/PpriJBoIm7g2Q7ywwZQ5Zk4P9bs8nZCISutdbit5
 0QmqhpwL
 2xP6rUbxgWyoa1b+x9+NkCzr9YIvSUA6Zdfn7ja0OaU8tkMzLedmgJjgJXtex+3dushPPvJuR8pUcH3sLs4xXePX0/vEti5zCInMbzPIfWEoeuUdcbEPiSwR0d6Kf2omZZo818uBIr/7yzcCpU0brpQn9NUnZHMo5DjfIvWqUEh51LKBxkh/lJNpNYauXmevWg7wx0Nhk4qGFrUTwTgkB4LU5fNl989/5cDsr33gDwj5H993dDgbX16vzAhUIpLXylrXSzH6O76H5ezh2YT0mozEA6Rvp2G5+HC5AIYXcFEGmOWEKfaGV6ma+eybNmFWGB243V2vAYPXQ0DnIt+okfY0ONj0mwA7WlciO+HMKy8MyKRh68pBDIA769px/Wc90F864QHZuquxC3c4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: bruzzhang <bruzzhang@tencent.com>

Currently we flush TLB for every dirty folio, which is a bottleneck for
systems with many cores as this causes heavy IPI usage.

So instead, batch the folios, and flush once for every 31 folios (one
folio_batch). These folios will be held in a folio_batch releasing their
lock, then when folio_batch is full, do following steps:

- For each folio: lock - check still evictable - unlock
  - If no longer evictable, return the folio to the caller.
- Flush TLB once for the batch
- Pageout the folios (refcount freeze happens in the pageout path)

Note we can't hold a frozen folio in folio_batch for long as it will
cause filemap/swapcache lookup to livelock. Fortunately pageout usually
won't take too long; sync IO is fast, and non-sync IO will be issued
with the folio marked writeback.

Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: bruzzhang <bruzzhang@tencent.com>
---
 mm/vmscan.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 61 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a336f7fc7dae..69cdd3252ff8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1240,6 +1240,48 @@ static void pageout_one(struct folio *folio, struct list_head *ret_folios,
 	VM_BUG_ON_FOLIO(folio_test_lru(folio) ||
 			folio_test_unevictable(folio), folio);
 }
+
+static void pageout_batch(struct folio_batch *fbatch,
+			  struct list_head *ret_folios,
+			  struct folio_batch *free_folios,
+			  struct scan_control *sc, struct reclaim_stat *stat,
+			  struct swap_iocb **plug, struct list_head *folio_list)
+{
+	int i = 0, count = folio_batch_count(fbatch);
+	struct folio *folio;
+
+	folio_batch_reinit(fbatch);
+	do {
+		folio = fbatch->folios[i];
+		if (!folio_trylock(folio)) {
+			list_add(&folio->lru, ret_folios);
+			continue;
+		}
+
+		if (folio_test_writeback(folio) || folio_test_lru(folio) ||
+		    folio_mapped(folio))
+			goto next;
+		folio_batch_add(fbatch, folio);
+		continue;
+next:
+		folio_unlock(folio);
+		list_add(&folio->lru, ret_folios);
+	} while (++i != count);
+
+	i = 0;
+	count = folio_batch_count(fbatch);
+	if (!count)
+		return;
+	/* One TLB flush for the batch */
+	try_to_unmap_flush_dirty();
+	do {
+		folio = fbatch->folios[i];
+		pageout_one(folio, ret_folios, free_folios, sc, stat, plug,
+			    folio_list);
+	} while (++i != count);
+	folio_batch_reinit(fbatch);
+}
+
 /*
  * Reclaimed folios are counted in stat->nr_reclaimed.
  */
@@ -1249,6 +1291,8 @@ static void shrink_folio_list(struct list_head *folio_list,
 		struct mem_cgroup *memcg)
 {
 	struct folio_batch free_folios;
+	struct folio_batch flush_folios;
+
 	LIST_HEAD(ret_folios);
 	LIST_HEAD(demote_folios);
 	unsigned int nr_demoted = 0;
@@ -1257,6 +1301,8 @@ static void shrink_folio_list(struct list_head *folio_list,
 	struct swap_iocb *plug = NULL;
 
 	folio_batch_init(&free_folios);
+	folio_batch_init(&flush_folios);
+
 	memset(stat, 0, sizeof(*stat));
 	cond_resched();
 	do_demote_pass = can_demote(pgdat->node_id, sc, memcg);
@@ -1578,15 +1624,19 @@ static void shrink_folio_list(struct list_head *folio_list,
 				goto keep_locked;
 			if (!sc->may_writepage)
 				goto keep_locked;
-
 			/*
-			 * Folio is dirty. Flush the TLB if a writable entry
-			 * potentially exists to avoid CPU writes after I/O
-			 * starts and then write it out here.
+			 * For anon, we should only see swap cache (anon) and
+			 * the list pinning the page. For file page, the filemap
+			 * and the list pins it. Combined with the page_ref_freeze
+			 * in pageout_batch ensure nothing else touches the page
+			 * during lock unlocked.
 			 */
-			try_to_unmap_flush_dirty();
-			pageout_one(folio, &ret_folios, &free_folios, sc, stat,
-				&plug, folio_list);
+			folio_unlock(folio);
+			if (!folio_batch_add(&flush_folios, folio))
+				pageout_batch(&flush_folios,
+							&ret_folios, &free_folios,
+							sc, stat, &plug,
+							folio_list);
 			goto next;
 		}
 
@@ -1614,6 +1664,10 @@ static void shrink_folio_list(struct list_head *folio_list,
 next:
 		continue;
 	}
+	if (folio_batch_count(&flush_folios)) {
+		pageout_batch(&flush_folios, &ret_folios, &free_folios, sc,
+			      stat, &plug, folio_list);
+	}
 	/* 'folio_list' is always empty here */
 
 	/* Migrate folios selected for demotion */

-- 
2.43.7



