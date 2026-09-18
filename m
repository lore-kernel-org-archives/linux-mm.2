Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B004C982DC
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 09:19:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF3776B00A9; Fri, 18 Sep 2026 05:19:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2E336B00A3; Fri, 18 Sep 2026 05:19:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 943806B00AB; Fri, 18 Sep 2026 05:19:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 612136B00A7
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:19:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8941BA5EA9
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:19:02 +0000 (UTC)
X-FDA: 85226333724.11.5A60766
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9E9E716000D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:19:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ncx3N3vN;
	spf=pass (imf08.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789723140;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9cyxDR07u+pzLnjqMcC6DV/BE1u4rxxTDhk0dtmfmRk=;
	b=cAyLKXPP6rJhveLQ3h/ndIvJB+byU7Ob4gCeorU2ReOKO325KAzRkX8oeswWAKy5tKqEOH
	ub+E3RInJN0UpAwmHc5UrZGvlYC0PvMC0qu4roMRdvZAjofX5FjgR0SZMCv0rd+j26bH87
	o41+hI/AOqVidz0LgOQMlp7oyhHxvbg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ncx3N3vN;
	spf=pass (imf08.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789723140;
	b=2DH0OqHTY0Igu545B96V6sZJR3gzPRy6QGdGdXA+VD/yfyxbIqoqPOkuqFFDLvgan78iDa
	vjTb8L2n35/JrykSB5R0+guG6pJIrHsYUZjXmBdRHfjqXLj5Y+Imjo9LCrr4jFOAuQxQ37
	aM44xhozmsdWQDD2iAZYAG32ncbKZgk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3AB6760A5E;
	Fri, 18 Sep 2026 09:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D2451C2BCB9;
	Fri, 18 Sep 2026 09:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789723139;
	bh=XdjX33riuk2EpI/N/nnFyKprsD5MLEVM/f265lMaRc8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Ncx3N3vNlh7x1qtuI6JhHocww4d8MLEvCk4yTLWdSnIg/ViYRXOaVBMGYFKQzzY+7
	 FNaRRj03BvtrKpJ6nnATiyfVoLkSuDVj3BJUvW2yD/OWABVONRrb0Nc4U9/jS7wYdh
	 hRDexf/20tDW8EzV8uv7vo9vBydS6IIciIz4h0DP/bNvpSRuPsI1MT2Scnavw/LRPn
	 eaJO0Q2LkWUMLVtMnJXdjTqIsGDVYmpgkPoLRToHYUsy2SGlFuEo2ySCi013NV4kNv
	 855DiG2Yd35ZKCQ1RsLdVwYEfXmMT8v9THQkpK+bNa+reb6QPJJ3eTmLYTk2Sx27RC
	 3u02cCh3Sy7vA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B36D6C982D7;
	Fri, 18 Sep 2026 09:18:59 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Fri, 18 Sep 2026 17:18:40 +0800
Subject: [PATCH 1/4] memcg: keep swap charging under RCU protection
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260918-bingfangguo-memcgid-rework-v1-1-5bbf3220d88f@tencent.com>
References: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
In-Reply-To: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Bingfang Guo <bfguo@icloud.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Bingfang Guo <bingfangguo@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789723137; l=2119;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=aNz5CIHBA0S+5g/N6vd9VKb1cpBJlA1cYu/omCgqzbc=;
 b=85Mfwmjg8Hw0ij0tgq5WRMyNU987rySAkUozMzMbKjZ4EMuLJjIpx4j/3IQ2O6QO3UEKF4Ac2
 Bd4qZmnpAuUD0TVgkE277fCPMZ0RJDGGHP/A5uHi2CEtksfylrjwdne
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9E9E716000D
X-Stat-Signature: ha5yqwgy1uzpb6coaf57xkiigxbe4146
X-Rspam-User: 
X-HE-Tag: 1789723140-762949
X-HE-Meta: U2FsdGVkX1/WfqjOVKmUsKka80CsWeqIAVAUgsFVIL3MSe6+W8w6QW9bkNpvgvnQA9MEOtYrPJChCWaVnZQ0cPj7UTHXVAMWLsTuBzHP6I3Oyj3ZOfr8r2/RDJfGTQ6J/95CJOlcrv7EuBNBIpahYyD3KXMpy+F8HHjc5irVrBCRy9WE2K/VV+PPUQVRSgOJbffT+ntwzuJg41mSuJe5Nv1seM1tPE5NfX87clz5C8SjKpVHBU8fnjEDwjvCk4FrDkchcrPCq7vq7vY19ZCAQyDF0ihAAnBllq6bZcZV4baLvkFPt+Efo+VrJ1f6zTvOxa2Y/cS9jG5m0KTw1IzlvqmziOS6yUBBkvOQzVur6EMH3DsWz/BYSpDfKM47oOk0L7UedLZ8JQhnxeGqYdKjLEmLifAmFG1SSdhv+cFzMvbLsnui5qbYk5aJfue7P/EXHVq+jtlucThtbaKSLFxaa+GU7phDAHvkDy8XLxBPIKHt8xJsKkRzV9kQ1+Z0b5/EkanFp6aR+0VBxUOe4PRfj98OSBawi0+0MthbdBMxKdl5f/RT+Lnxb7HbTlpNXhnsvIN/cSK+yCyjVvpmfcATC9/xzTFG1LrgCSiJSJ9oMPEQcdKrX+IX2nR5biFcBzxi5UUy7KZeVjMpnivYgge8cH3Vpl/YV3qkIrrD4XD3dWjQKFnlVC53dhjMprvvGvDpz9cqlDXSy3WvAnUCSKmI6HPXtpIAfcO/qBzie61Iq1fJmqK0Uj0C+jDO7jr84dKfOrWOci5z+SaQTb3SenMi0IE1uVEVw8Ifyv3pKrE+5/OmDNtFFx+pm/hBahlAIVI8lIQFv27JNlXyjEDKq8IrFKWw9P6ew7FamJ7l5hqKZ5Gm4xS7aZ9GbJUHq2PyujPkAi1969rD04uhdCWCUIrfxcF61p2suP6cRpYSQUaWaL3RoJSd0zW9phOVmFQEro7WsvXId9iySNv4Qx1mLHf
 oc+SbZad
 ZL5nYaUvSKEVBtyrLzXYOfBlQ1oGUdgUejlgiz5nw9PWEZG6dRvhGXnuo4tGHPtx5DTDtEa0Rc5SKpFxklrCgccTzeXdfZ1rwHOA0IZmv8n/ldhF9UiNi51CWVu/UoS0LjlxFYDEDoHPyGvCOjHoycF1Xu4+kAMGi1csFXSUQpWIgzPT2byJ2AsTYjli6Le5Rd/vcB6OIkni0QHPgxjwBSivI7BsqufJSlxOT06L3FAEyawpgEn8qiMhJCcWOVZ+ascHcpAUbMqcOTvP/K1XxB8GhQL7sWWp7OjazeNB6Xu7PqU3YIjIxzrKJrdgrb4CNKU0H6LdiD4hltMaWHYJeKDDLQZ6uGyQMr1ytEZGSDiuhU4s4xHbEIQyvKXoZ/wE+jZ5fRbkF3bPUFRoNy/dMSmmpcXSSU6+6NfJ9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bingfang Guo <bingfangguo@tencent.com>

This is a preparatory work for unbinding memcgid from memcg. No
functional change.

The swap charging path currently drops its RCU read lock after acquiring
a private ID reference. This is safe because the ID reference pins the
memcg's CSS.

Moving private ID references to objcgs will remove that lifetime
guarantee. Keep the RCU read lock held while accessing the memcg for
counter charging, statistics and failure handling. (This matches what
__memcg1_swapout() already does.).

Save the private ID before dropping the RCU read lock, and use the saved
value when recording the swap entry. The swap cluster locking remains
outside the RCU read-side critical section.

Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
 mm/memcontrol.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 791e536efaebe..72522ec827c9a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5954,6 +5954,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 	struct page_counter *counter;
 	struct mem_cgroup *memcg;
 	struct obj_cgroup *objcg;
+	unsigned short private_id;
 
 	if (do_memsw_account())
 		return 0;
@@ -5973,20 +5974,21 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 
 	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
 	/* memcg is pined by memcg ID. */
-	rcu_read_unlock();
+	private_id = mem_cgroup_private_id(memcg);
 
 	if (!mem_cgroup_is_root(memcg) &&
 	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
 		mem_cgroup_private_id_put(memcg, nr_pages);
+		rcu_read_unlock();
 		return -ENOMEM;
 	}
 	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
+	rcu_read_unlock();
 
 	ci = swap_cluster_get_and_lock(folio);
-	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages,
-			  mem_cgroup_private_id(memcg));
+	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages, private_id);
 	swap_cluster_unlock(ci);
 
 	return 0;

-- 
2.43.7



