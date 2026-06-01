Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6C0ACD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 16:15:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C832F6B0450; Mon,  1 Jun 2026 12:15:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5AD36B0451; Mon,  1 Jun 2026 12:15:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B98546B0452; Mon,  1 Jun 2026 12:15:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A89476B0450
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:15:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 47070140702
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:15:47 +0000 (UTC)
X-FDA: 84831844734.28.39B0635
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf05.hostedemail.com (Postfix) with ESMTP id B28C210000D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:15:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UHPu02Cw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780330545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rQzi2gONxiIcDHLm2VrGnw9O4REpeifQom+6RrcJBmg=;
	b=zXHsswCoYyPBjGL3Yz0Woo1tHvx/JLNTG+5WKPjiu5S2+h2LOcI/o133MyBa7oBMsuGTKI
	IDesFboiza2KTnTKmBfyHw4HtBrmmM4mSsznhtWOaREy3RjeNKfXI5bygfbxvZqEBhNdqO
	WPt3hqkDf7BLOzqpwIjKipHQAAZyuFk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UHPu02Cw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780330545;
	b=UnpjGJLp9kNMueFAINQpGW10XE3BRc8pB8t3P/A0SH2LgFQOYwDbvtWK7NtGwOqTmnzpIU
	FXmqffksjNbPK5zjl2UsLKW0Byy+NBFNkSdXLKtxPkHFF7z83FWgw30fNqvVLAbUWtZUyp
	k+j2Mva/19WEF9Lg+MPQLMhLQH8QrFY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780330543;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rQzi2gONxiIcDHLm2VrGnw9O4REpeifQom+6RrcJBmg=;
	b=UHPu02CwuMbgjZG0+HMELc4RBe5U3EZ7RKAqtpyPIJnXvVryWYBOOtyJ7bZCGkqOgMiXHC
	xufUOXPsuX9osPAjao2KYXDh3t8t9BASS6p/vuIulI5fCZ3OLzGDdWQj/ym+QC2kyUbw8Q
	LtEq5I5DMjlJPvNettYkKG+F0+CQDlk=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chris Mason <clm@fb.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] mm/list_lru: drain before clearing xarray entry on reparent
Date: Mon,  1 Jun 2026 09:15:01 -0700
Message-ID: <20260601161501.1444829-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B28C210000D
X-Stat-Signature: iecofu48krptobpdehz8yhduj1196wqp
X-Rspam-User: 
X-HE-Tag: 1780330545-247376
X-HE-Meta: U2FsdGVkX1/SY5VfsENh+G1LyBk8DJ8rQbDJZ2XhGjwLsoXILtUl60u3HmD099Z2mTmvjUUOML7J91MSC2GK0Zp9uOwb1eWzT3CheoR9+PWyeMn4qQRVeA8Rq2wIZcUBDPVVA6D7nQpzFmA8kqKIPNPo8eTOqs25r7i/vOyT6Hw0ZYO1LJ5KMiLMF1hQzZa1osFDAOH1KInWAK1fbzYlOv14amBxfPP56dTDLTSIJmPhF3L619ozXKWuIsJDiD17SE28W01Omoy3pOlmQvzE4QQ9nzNdehPOeGZgfRxec48wPlh5ibsB5kZK3WFd4t/E/FWzHuBfICu/SVD2Yb8y6h0wqQoAsdh4gkP2WN/jBRyCD/ykKiApfL2Ncywioc+M/VZE6fVEyJ6FOqvlcfv19OJq5HjlyRqrndbX+xMcM6qiJNrfNUko8OAV4DEoXxdH7ifpg8l7spvevXdThRyNFXGCki4ZxG5Ngp/vz8LL+Z416Oxsg0+M89Mn/kQdRjkO8vhprMA9IGrrdMPCAYhqZOSnoJAck1/1cI8aWnRQnqPmvhjao6qZDIiH8YTOrr5XRM51OZl0zikYpUyz3rN45a3kMuEWHag/dJ4wk7MRJSFypQTSSY8EvimNDw7rZfitQZ1Y/4jzwBSXypWXDmqZ+mt8zAVnLUWQ31wOPXFkcO/Z5gwJLQoIG++VVZXTqFDOHkrNdEX9UTD8sF/wFVM4wOv+rRf0NpQBGi9zKZ9k9JhaulOaKbxi97aSF30H5M8IMb5GucwB+UYfUujslYzdCFbaNpbOczWrFmt4YbpUxfGqz9Xqm2kmcJe8jgvIbes5+V7Umwtwm4QyQv7YI6/i5pYqF0y9a00MhB+4elxRUE39Wx5vjn9uJn8f2AomAte5iIyhiSwlLBJ4RfqwE1wpG81Lk2Bk6J0YgpUOwyoFkkcRFbWqRXprt3L5+b96VGC0QmqZic2qJY2MUWeMqD6
 yEqzRNTz
 kF6a5kRlfIf47wH0NwEEy6Z/JziZdJKhUI2YdjjO9WFN5V52q43rZXaBkonu5SzDZUvvmxqM5neEvRv5wRKk1uaoqmab5lVvjeIPljmeGY7w1qR1mwcdYaB3QB7asTQC9Jq2Mtj0gFA59jjSeiYsy94dhI3hVV4xdMGW/WDRu1mFIXDa+mv3Q2NM2saMv8bPvsaWnY9bimXlWKZwoC2rVcskbcvK5UqMeps1bxQVsNYOawLwTfUYf/hBqYQtWKIHpdjHbipRGDol1y4BtBUpnGgZTs9EgAnaBfDq+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memcg_reparent_list_lrus() clears the dying memcg's xarray entry with
xas_store(&xas, NULL) before reparenting its per-node lists into the
parent. This opens a window where a concurrent list_lru_del() arriving
for the dying memcg sees xa_load() == NULL, walks to the parent in
lock_list_lru_of_memcg(), takes the parent's per-node lock, and calls
list_del_init() on an item still physically linked on the dying
memcg's list.

If another in-flight thread holds the dying memcg's per-node lock at
the same moment (another list_lru_del, or a list_lru_walk_one running
an isolate callback), both threads modify ->next/->prev pointers on the
same physical list under different locks. Adjacent items can corrupt
each other's links.

Fix it by reversing the order: reparent each per-node list and mark the
child's list lru dead and then clear the xarray entry. Any concurrent
list_lru op that finds the still-set xarray entry either takes the dying
memcg's per-node lock (synchronizing with the drain) or sees LONG_MIN
and walks to the parent, where the items now live.

Fixes: fb56fdf8b9a2 ("mm/list_lru: split the lock to per-cgroup scope")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: Chris Mason <clm@fb.com>
Cc: stable@vger.kernel.org
---
Changes since v1:
- Use xa_erase_irq() instead of xa_erase() (Sashiko & Claude).
- Added comment on CSS_DYING check in memcg_list_lru_alloc avoiding a new mlru
  allocation.

 mm/list_lru.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index dd29bcf8eb5f..d454bce9a78e 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -473,26 +473,29 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
 	mutex_lock(&list_lrus_mutex);
 	list_for_each_entry(lru, &memcg_list_lrus, list) {
 		struct list_lru_memcg *mlru;
-		XA_STATE(xas, &lru->xa, memcg->kmemcg_id);
 
 		/*
-		 * Lock the Xarray to ensure no on going list_lru_memcg
-		 * allocation and further allocation will see css_is_dying().
+		 * css_is_dying() check in memcg_list_lru_alloc() avoids
+		 * allocating a new mlru since CSS_DYING is already set for this
+		 * memcg a rcu grace period ago.
 		 */
-		xas_lock_irq(&xas);
-		mlru = xas_store(&xas, NULL);
-		xas_unlock_irq(&xas);
+		mlru = xa_load(&lru->xa, memcg->kmemcg_id);
 		if (!mlru)
 			continue;
 
 		/*
-		 * With Xarray value set to NULL, holding the lru lock below
-		 * prevents list_lru_{add,del,isolate} from touching the lru,
-		 * safe to reparent.
+		 * Reparent each per-node list and mark the child dead
+		 * (LONG_MIN) before clearing xarray entry otherwise a
+		 * concurrent list_lru_del() may corrupt the list if it arrives
+		 * after xarray clear but before reparenting as
+		 * lock_list_lru_of_memcg will acquire parent's lock while the
+		 * item is still on child's list.
 		 */
 		for_each_node(i)
 			memcg_reparent_list_lru_one(lru, i, &mlru->node[i], parent);
 
+		xa_erase_irq(&lru->xa, memcg->kmemcg_id);
+
 		/*
 		 * Here all list_lrus corresponding to the cgroup are guaranteed
 		 * to remain empty, we can safely free this lru, any further
-- 
2.53.0-Meta


