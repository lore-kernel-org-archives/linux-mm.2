Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87020CD98EE
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 08:58:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FCAA6B0093; Wed, 17 Jun 2026 04:58:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D3A96B0095; Wed, 17 Jun 2026 04:58:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EB786B0096; Wed, 17 Jun 2026 04:58:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 34B026B0093
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 04:58:05 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AC00E1401F0
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:58:04 +0000 (UTC)
X-FDA: 84888802488.15.B70F47F
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf28.hostedemail.com (Postfix) with ESMTP id 10602C0006
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:58:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bfigpFQs;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781686683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=z+0oawbYAvCbDfWFytofWS7kpNw2bfjZSR+3b+oyM0U=;
	b=MFQkOoOdxErq9HQZPAS4vR2lDsJOy9blmk8sta3fQO+V8bBULeobhG7D46wlf8oz96PufO
	9+a1NxJ1OS4p/vNppQskPU2nck+Hj5ms3Zj+8hmbhi/4ObouC4kcNO4EW2Q3RpaIOVkcRC
	l10VbMNYI0QNNGsyrqO3aC2o54FGPD0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781686683;
	b=P1BY1tPjzt+W60bEDJkZEyxi6BX1VbqRL9p72KPH+x+b6Qc+EbxTP55I2jE0UCF1YogynX
	95mhKKD0Fd8oncNu1vlJjhueQ5+2tkAB9B3dePCDtF14L9EGiVItAKyXAMRHfEwwpR9kuk
	hovx6LUoL5Mc4z2f42KEdn1841H7lBo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bfigpFQs;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781686681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=z+0oawbYAvCbDfWFytofWS7kpNw2bfjZSR+3b+oyM0U=;
	b=bfigpFQs9ZnUA/co/pq01dfms67+/z/n4KaDrR9aRUYNVt7dKK/khuGJihn5qG6Eue6TU0
	mt5Yit1VbnEyZ4hA+KOqOgs+TvRAp6qNpcUfjm7PC2kwyV+brJky8g+C9dF8kyG2RewbuZ
	dYbU1vX6jzmjOnmBsPMQNxaiT38w7cw=
From: Qi Zheng <qi.zheng@linux.dev>
To: akpm@linux-foundation.org,
	david@fromorbit.com,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm: shrinker: fix shrinker_info teardown race with expansion
Date: Wed, 17 Jun 2026 16:56:58 +0800
Message-ID: <20260617085658.27096-1-qi.zheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 10602C0006
X-Stat-Signature: 7f9nr11ux6u9dwe84adw4x8pj1uhi5pm
X-HE-Tag: 1781686682-542320
X-HE-Meta: U2FsdGVkX19cktU15SwhO9ChpOziZ0PJ+wCrAY//nhOWLeKjXDn8IRXRseLgGZfdxS0xIesJmDq3/ag6e6p/ksPQ5AK+haEgayVmPYy7EObP4bf9uEikxYco19zfmt3goJVogQ1a6xjZI1kycp8z1Yb/BvZTnVl1gg6B6wL1RqzWjA2Nfko/cWLdBDBe78VwAgaKv9Oebner8nr+3uNIgQeAeGIcBANOxEAxovkgXepfC3BDREHB75Yrnft4d8cy/g5FKTyCA3QtdeS/AQ6nSmePhRL8p2OhEMV8u5Vvpv/NxgNpfAQZrnpLTxOuob7ajLH4Re8Np7XGqhck9ywoLCGk6+3kKHeZCaMdc6pWwQEsJssRc7i++9iFCtlbhtKRNFBYkAz3H0mTwlfC3KMyUMb3xB7z3UBSlhTAzgFJhqQWU9LAhw0mYUW6j0LpeFxCndjpmxC0rcnGp52JXhuVaDop0xnv9qxolhJZ0iIoEQvNCQnUNo1zoALUD+8QnCNWebZVBr2/G7zgPPmsB5ClB694yQCr0yhvqLZQumKDpBB/rq1ZF1w30g73g+DaQePxZhXhgaSaWdiXIoiFLSzBbWLV4nlB6c0w+NJq1CSylra5fJb4xZV2ovA0/+2xr7Stc8Cwhj29NXx1/6g1wJNTQcsqSyDQv7GNdaJC8twd5wVwJz6Wqs9cWHRG3EnQsbZOooV+EMzOLH82JqaqwuqKbocMMEoDI1CT47C1+SjOqsTCZgfQSKHN+hi2P8sNQaen9ZrX1gwEkprcDKSeI5FuuTYsmdJm8f7XknGoTgiEYx5aCVHrD1yzWRasUXvLydh/b1mCPqMKQHaN9wZCmU4VAFVb7uLztltZY4XXnq8EVAHchNRUNwTCsJ5ETdZKY9F4wu6FB1z4JCCwoI8I708kZbZsU+JDDeTdUjCwDgsjAiylngpPHSNXO1WK+5WA7QqorUrN3ibAFp/9tzNGhun
 vOaxpVma
 qg+Pla3hb4pem1AFO4+WDOTHqZdmUIc1z1iRi85f3azzmaxNdw3VLnk5InOzO/P8o1vGsBmC5XM1cSKHPJjbrfBPs5ihlmt0MljjGpjonqw+3M2ismChBQe+YVCg6zvQGXwdTGX+jKHGAUffYej70a8ly3TphaztjdOSOTTD3AztSUbSbL6NkT0soR8C8ES7tb17CA8Ey2WmXLG2CZIu35+TZNFR1JehQFmTkn68s+E4ePMzifPdju4OBTRSkpXJDmLtb1MTSaVVX8esU2ZhyflmryYx5+MLRY0nn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

The expand_shrinker_info() iterates all visible memcgs under
shrinker_mutex, including memcgs that have not finished ->css_online()
yet.

Once pn->shrinker_info has been published, teardown must stay serialized
with expand_shrinker_info() until that memcg is either fully online or
no longer visible to iteration. Today alloc_shrinker_info() breaks that
rule by dropping shrinker_mutex before freeing a partially initialized
shrinker_info array, which may cause the following race:

CPU0                   CPU1
====                   ====

css_create
--> list_add_tail_rcu(&css->sibling, &parent_css->children);
    online_css
    --> mem_cgroup_css_online
        --> alloc_shrinker_info
            --> alloc node0 info
                rcu_assign_pointer(C->node0->shrinker_info, old0)
                alloc node1 info -> FAIL -> goto err
                mutex_unlock(shrinker_mutex)

                       shrinker_alloc()
                       --> shrinker_memcg_alloc
                           --> mutex_lock(shrinker_mutex)
                               expand_shrinker_info
                               --> mem_cgroup_iter see the memcg
                                   expand_one_shrinker_info
                                   --> old0 = C->node0->shrinker_info
                                       memcpy(new->unit, old0->unit, ...);

                free_shrinker_info
                --> kvfree(old0);

                                       /* double free !! */
                                       kvfree_rcu(old0, rcu);

The same problem exists later in mem_cgroup_css_online(). If
alloc_shrinker_info() succeeds but a subsequent objcg allocation fails,
the free_objcg -> free_shrinker_info() unwind path tears down the already
published pn->shrinker_info arrays without shrinker_mutex. The
expand_one_shrinker_info() can race with that teardown in the same way,
leading to use-after-free or double-free of the old shrinker_info.

Fix this by serializing shrinker_info teardown with shrinker_mutex, and by
keeping alloc_shrinker_info() error cleanup inside the locked section.

Fixes: 307bececcd12 ("mm: shrinker: add a secondary array for shrinker_info::{map, nr_deferred}")
Cc: stable@vger.kernel.org
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/shrinker.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/shrinker.c b/mm/shrinker.c
index 7082d01c8c9d..a70aab124a0e 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -59,12 +59,14 @@ static inline int shrinker_unit_alloc(struct shrinker_info *new,
 	return 0;
 }
 
-void free_shrinker_info(struct mem_cgroup *memcg)
+static void __free_shrinker_info(struct mem_cgroup *memcg)
 {
 	struct mem_cgroup_per_node *pn;
 	struct shrinker_info *info;
 	int nid;
 
+	lockdep_assert_held(&shrinker_mutex);
+
 	for_each_node(nid) {
 		pn = memcg->nodeinfo[nid];
 		info = rcu_dereference_protected(pn->shrinker_info, true);
@@ -74,6 +76,13 @@ void free_shrinker_info(struct mem_cgroup *memcg)
 	}
 }
 
+void free_shrinker_info(struct mem_cgroup *memcg)
+{
+	mutex_lock(&shrinker_mutex);
+	__free_shrinker_info(memcg);
+	mutex_unlock(&shrinker_mutex);
+}
+
 int alloc_shrinker_info(struct mem_cgroup *memcg)
 {
 	int nid, ret = 0;
@@ -98,8 +107,8 @@ int alloc_shrinker_info(struct mem_cgroup *memcg)
 	return ret;
 
 err:
+	__free_shrinker_info(memcg);
 	mutex_unlock(&shrinker_mutex);
-	free_shrinker_info(memcg);
 	return -ENOMEM;
 }
 
-- 
2.54.0


