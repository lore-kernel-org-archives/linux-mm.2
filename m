Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E84A4C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 02:06:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03A1D6B0096; Tue, 22 Sep 2026 22:06:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0104C6B0098; Tue, 22 Sep 2026 22:06:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8F2F6B0099; Tue, 22 Sep 2026 22:06:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C5BB26B0096
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:06:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B38DD80680
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:06:12 +0000 (UTC)
X-FDA: 85243386984.28.C11ACDC
Received: from mta0.migadu.com (out-21.mta0.migadu.com [91.218.175.21])
	by imf30.hostedemail.com (Postfix) with ESMTP id 79FE880002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:06:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RWrtAuV1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.21 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790129170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eFeu4TDNa4S0TWXyTvN2ITgZChUzpofKYVsEvagPk2c=;
	b=oDZTkVoHeOdXZwcAEdNJBSi50vzG+Rgy3A9MIUuWDXo5LMpEA3qezU52t+1GW927Cf3ag5
	ZXWNi6qj1sVUJ8Y1iSHUw8tdWEl2uRRCFCkmcvbhG1IuniocF0KjxkFSaQx73YtGTGG6N3
	O8pKbJa1L6yw5JilAITwCogrZSken1Y=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RWrtAuV1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.21 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790129170;
	b=1wNBbdyDIj6xhSe150aWMsIb6m8bjzohLqVb/tOdYxih2iJIxHpPvBJB4t8CWrd4GoEBXL
	6+uVJ9kANEw+c6DqsjFZDBOr3uzFiJnrOZIYhe+EnvZHazCixZFbTNQFlMAQeTHmGgXhcO
	yGNDhVOmEHfvmwH4+6byVPyf/U6SUDA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0ISTjzArDvrHCvzOuzvqWLDvbJceHC6JZIVo8RNRwPU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790129169; v=1; x=1790733969;
 b=RWrtAuV1Yq/ALp5TKkxvoyTdBdAUXQKZ7gZieqVa98LZP1Er1GfeXlwRyrYasXm4o6gp3RTc
 vqrwlIcyTxHjw+9m6gk9WT+kIf0ZYDqKDIV0Pdbz/pYwap1+VA1FWJZdRweK0PQrF/p/svHp+0q
 PRv5qUmO91Ks1lUoAAQuO6EI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id cf62ea15ecec1017;
	Wed, 23 Sep 2026 02:06:09 +0000
X-Mizu-Trace-ID: cf62ea15ecec1017
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
Date: Wed, 23 Sep 2026 10:05:16 +0800
Subject: [PATCH v2 2/2] mm/memcg: migrate per-node hugetlb lruvec stat
 together with hugetlb folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-for-hugetlb_state3-v2-2-e8a36245bfab@kylinos.cn>
References: <20260923-for-hugetlb_state3-v2-0-e8a36245bfab@kylinos.cn>
In-Reply-To: <20260923-for-hugetlb_state3-v2-0-e8a36245bfab@kylinos.cn>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@suse.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Nhat Pham <nphamcs@gmail.com>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: hongfu.li@linux.dev, Chris Down <chris@chrisdown.name>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Hongfu Li <lihongfu@kylinos.cn>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790129144; l=4285;
 i=lihongfu@kylinos.cn; s=20260915; h=from:subject:message-id;
 bh=XnpfUOE9XDiYB80tcgMo2fYCgw4drhX0D7pb8CGUdW8=;
 b=3j/63EyE0toWk7b1TPsklFCt/sTcSFe0N88Cd87hN9fQfmC8YUb/PLi2xqQKzcvACybh2WHJ7
 nawKxPtGfCeCKpIYgzJOc1by+YN3IJQOY/015YPf/IycUp7DinKYc3o
X-Developer-Key: i=lihongfu@kylinos.cn; a=ed25519;
 pk=rUpDSpB3neoNZRlGG6dHlFb3RepiJakcev+ucyqaZzw=
X-Stat-Signature: chzf34h7ejxtogrxcfgu5igieksx6qfo
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 79FE880002
X-HE-Tag: 1790129170-129400
X-HE-Meta: U2FsdGVkX1/e1rTe7AMlhhP7B3wR/8q7C3npI00DwjvuvjlhvIVqYSQ2adz2vTbHZqK6vAqMFSKVm1ZZCWFRjh/VXPC6+9gFr8kgWdJohsPH+97l3E/H8nefjhlaV5xXxpKz4JTs5TFnmnrooSBLgVmbRnbw8mBgwkL9azLgliG5sDki4tW1TGuSg5jdb24sCdHoMzdnK80nftdc1UpRN9zR1NPkcSqPm/vg85IGejluS367mTjv4rXaCXrPgeHeIxUYkBQjxWiPiBQLFSeRQ+lrVr3hGVPOQLdHJxvY79pS7qhu+ymkPeONOD2t7Nc7Mnw2n9EHaOx1XC5NPsQ1+gOelegi9nh4D8zuNbviSojQjo0O9gpsQ7tL5+y/2lt9hqPb/oDl6ZhHszonNQffpQKOEa97eX+Cfjpq8o+0Y9RDeJnwJq53JNThzv/df+BYl+FnE2kOFQjy8k7pOhrCPJLYooeE3D/wqja6YRB4BEaJFrztlk26E/0KHTGVFw32t+4iz2rqtIZMmMZ7xv1hFM/E5ZFGCfMlEnMP855TXzCPN0iU6GLCtUikeJcrqY2jghyw+frBmrKiKbUn/QzYPkVPkxgft/uqHoyyRYWJMRpzYjoCDC5W1ZLtTADPi+B/7rVrxP/eSs0q4Xr1LZSwrQtanuBSxGs0YVlebYEdvwhB7FDx9EEyq+ZWUhMxpj2b0sW9bLbH6ERWu5NA2VZZO+DGT6lRlDEjg3DmuGjzvIdRLFeLQPjyG2YdSeE+IUi4hTI7BG6CHdFe1eaKXPi9QpQ8u6a3b8Da789GlmEIVVz669QNNAchD58FviPsxUyEj3ZhueNveSaQOcOdkz9Ptm/z7WZuLlweubV1MNDCh+DR4f8liFfwDhy6P3Km83bWhLB1ohb8iF7GjNB7dsYnmXlWj0G+GZE1qRU5mAZdLGnmWV86c31Kc4fGg13Pl1fBQQHVm6SBXTKJMBGYuZt
 SwOceshj
 90pJSFZKhWQMtFJyLsXlIVtzNCs+k6ScDGLYh2ZhheXK6Nkr/ttyD2JZDWeaTD9e3JLDn4jqNDs3fEEscNIYIZUaAy5+JB1O6Dnx6HJJ50sT5RWKvrYlBgDCfhT0R0YPjBcepTIt7Zropn1AN/PjCXFTmv3uGhE17EA28E3SekyYDYCmc51jhDtxvO+FWKzS2bikuArZHbwjgwRXsJhRP7Y+G9FdPTUQErz1hT/8aRqDzM+X9hBzHVdhI98uWzq+bPc60w1dDhzh0lcSt4U9X2NeZRUm8a1KjyRvCOqkk+oVJl/g0PaFGTPHzhM6XabZxhqsx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

memory.numa_stat exposes per-node hugetlb counters from per-node lruvec
stats. These stats are accounted against folio_nid(): incremented on
the folio's node when handed to a user, decremented when the folio is
returned to the pool.

During hugetlb folio migration, mem_cgroup_migrate() moves the charge
to the new folio and drops the memcg data of the old one, so the free
of the old folio right after the migration skips the memcg per-node
lruvec decrement. The hugetlb count stays attributed to the old node
for the rest of the life of the charge, while the target folio gets no
increment on the new node; its later free decrements a counter that
was never incremented.

Migrate the per-node lruvec accounting alongside migration. Global
memcg totals remain balanced because they track resource consumption,
not node placement.

Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
Cc: stable@vger.kernel.org
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
---
 include/linux/memcontrol.h |  8 ++++++++
 mm/hugetlb.c               | 25 +++++++++++++++++++++++++
 mm/memcontrol.c            |  5 ++---
 3 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index a8358f297b65..74110a324f9e 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -984,6 +984,9 @@ unsigned long lruvec_page_state_monotonic(const struct lruvec *lruvec,
 unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
 				      enum node_stat_item idx);
 
+void mod_memcg_lruvec_state(struct lruvec *lruvec,
+			    enum node_stat_item idx, int val);
+
 void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
 void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg);
 
@@ -1452,6 +1455,11 @@ static inline unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
 	return node_page_state(lruvec_pgdat(lruvec), idx);
 }
 
+static inline void mod_memcg_lruvec_state(struct lruvec *lruvec,
+					  enum node_stat_item idx, int val)
+{
+}
+
 static inline void mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 {
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 519c30b338a8..76d019594b39 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -23,6 +23,7 @@
 #include <linux/mmdebug.h>
 #include <linux/sched/signal.h>
 #include <linux/rmap.h>
+#include <linux/rcupdate.h>
 #include <linux/string_choices.h>
 #include <linux/string_helpers.h>
 #include <linux/swap.h>
@@ -7378,12 +7379,36 @@ void folio_putback_hugetlb(struct folio *folio)
 	folio_put(folio);
 }
 
+static void move_hugetlb_lruvec_stat(struct folio *old_folio,
+				     struct folio *new_folio)
+{
+	struct mem_cgroup *memcg;
+	long nr_pages = folio_nr_pages(old_folio);
+	int old_nid = folio_nid(old_folio);
+	int new_nid = folio_nid(new_folio);
+
+	if (old_nid == new_nid)
+		return;
+
+	guard(rcu)();
+
+	memcg = folio_memcg(new_folio);
+	if (!memcg)
+		return;
+
+	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(old_nid)),
+			       NR_HUGETLB, -nr_pages);
+	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(new_nid)),
+			       NR_HUGETLB, nr_pages);
+}
+
 void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio,
 			enum migrate_reason reason)
 {
 	struct hstate *h = folio_hstate(old_folio);
 
 	hugetlb_cgroup_migrate(old_folio, new_folio);
+	move_hugetlb_lruvec_stat(old_folio, new_folio);
 	folio_set_owner_migrate_reason(new_folio, reason);
 
 	/*
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 88824f783571..a5335da5d425 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1015,9 +1015,8 @@ static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
 	put_cpu();
 }
 
-static void mod_memcg_lruvec_state(struct lruvec *lruvec,
-				     enum node_stat_item idx,
-				     int val)
+void mod_memcg_lruvec_state(struct lruvec *lruvec,
+			    enum node_stat_item idx, int val)
 {
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	struct mem_cgroup_per_node *pn;

-- 
2.54.0


