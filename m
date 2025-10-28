Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B0A4CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 14:05:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF44880164; Tue, 28 Oct 2025 10:05:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B18648013F; Tue, 28 Oct 2025 10:05:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A07DF80164; Tue, 28 Oct 2025 10:05:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 824D08013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:05:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 17D9E888D6
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:05:02 +0000 (UTC)
X-FDA: 84047694444.07.230928E
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3E9EDC000D
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:05:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xBN0+Xgv;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761660300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u1RiVu6Vt2llYHxIz14p3hNB1v2Bo6KqNLmF3dplOT8=;
	b=r/zf5fQaqRVXMpwTn9VNidRXL2JkcnxGRS8tXzpS8drpEmvz5ZwD9Umju6BCUaDM3Dhvxz
	AFMFIjL4RW52SBEoa2s/FjjqBA9saZhakHaGU/4v+yoQZ6qty8xZvsfCQWGlUGcDWJS0NM
	xaehZMMqmRUTOXu4nIrgtxsDBuXgBHM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761660300; a=rsa-sha256;
	cv=none;
	b=3Jn2yfrlPdwJWWKI3KEjlRM8xO4TsE5Kh/MC/fbdc8xOcmZL6i9947quQFuuZiqIS76TEd
	EGLNt9g2bjAvQqAzXj6gj970f1+s8BOmQKyFeUrUrFTkKlZWUSxBoDvP9PgbZYfOwjEAGY
	r2390VWo2BbdTAZZT8FAtp71//YRwKM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xBN0+Xgv;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761660298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u1RiVu6Vt2llYHxIz14p3hNB1v2Bo6KqNLmF3dplOT8=;
	b=xBN0+XgvMzEZ0CVS0wiMq+TSAfwuuche1Bos4yWYPX1Tui4h8RXSxjPTErRLvGhdCYqgHW
	DM2gjYat2LC4eZVWnOU0yZ14JQwberQ4wxKRvzyduIgakeP7D7tFGbwE/FVTMn/ZQp7TeB
	2CuDjqJ1RidrsBxK6dAHAxAMERleDos=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v1 24/26] mm: memcontrol: refactor memcg_reparent_objcgs()
Date: Tue, 28 Oct 2025 21:58:37 +0800
Message-ID: <21f6b42ec2441372bdfb540d2e7e0fef770c0f6c.1761658311.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1761658310.git.zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Stat-Signature: gyaae4aebnrdd61w4igjzf33hadtmjix
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E9EDC000D
X-HE-Tag: 1761660300-832074
X-HE-Meta: U2FsdGVkX18HhSsefh0TzIFO5JK+DrbR8WZ//kAQqwT8XwdOMkC4fdEgI0Um42Ly90c28BfngydyNed/Ex/le/FchbtzgYxOoEUXVVrFGmyIrQcqwWcY7OV7iCXvZ/F5iuRGsajwOgwdthE2leAxdBvIHfHV1Y7Cpru4Ucq7AdriCv7ES2VcWSa8rLDw5oXw8+oxu1WmxR4s8pQiZRGEaLNsi34WTk5XE3dd7tmW82m78gT1qPsETJGDhsZzEYVVbHE85A/w3pOHAr30zweGvVnBRYz1jaPrCUyOtaXOHCYDHt17P8HONWh4vnOrThE5BZLtkWMzyjfC2Br+1zrUtJwVmgq0/fsk6M9KmCRl4dMRdApZKbWq1fU6acvDYbOL2qzGYgTM2OpzHVsWVUJR9mY0KnV72Kz0h10krLNRlWwl1bjIIsVx3RA++8rTaaEOBOYjwlYycDNqYD7WULZpsPmcIYmWUrQ9nXoXXToLHkvnsT7vrohqKgRMI7OKNS2FEqYKcpTT8EhFsIemmHT7cC/OFJhi8CjEiLvnSCtpvCOQ+R4Jx66N2TNdYV1ISyxtVN4lZjqjWN1Xnuv1hcJis1LcCaPRuaTiMRFg2v53Q/xDNOurBUbpF9u7nZlkcHV9DtV+TeTNMJ1h7+cW3ECpnYYMhm9hRJtuEnzMmL5kaBakDWfGV/XHg782PfGMW2T+eIKsEukbsEzG9NUwtVwtcEKguHVoTa//NVWxXfeLJMqj1a97IzErUxGm59e3/1LSt6kfnUv04N7DQBDqyxg8MLAUbpG3gtv9X8EpqyCm/ZFp8v+2m7b2NVW9C6X/T3y6K4gteszYC2mTZlYyl/QeCUGO1sN6phxyZ84B9EwTjZA9OHPOM3FwAHg0tSS9caS/ilmwMufTUW5JJkwBfBTp0ooNgMpbR7Wes8OlDxe7i/l4BG5n9sUrb9h3uSDTH/PgSae8IljPUWHp05BRejS
 xv2N6HEW
 ylCn14bIKrp5pi6s/JkGNFH/rM+axqG2brSdrWmFlX+tGtAe8yzp2Kj1vE9mS5DcfCoq6PO0i5rhkCsRZmR49PENudth/v4rsi9uXd/izylaUzAmfKCz7Ie/ubVmazt3DFdlXzz2jXstGKWVrVNH2X6uelva0rwv8tZN4XWHSyNkKVPk2VFDZ9t0woHL6HVtJUdyXdQjU6OhlCxxbQ2IMRpT1bskIKOlwkUlC4baPHJFD3TZUsRZ/FwDFkFDPl0NrRZusaL3Q1q/XhB4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Refactor the memcg_reparent_objcgs() to facilitate subsequent reparenting
LRU folios here.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/memcontrol.c | 37 +++++++++++++++++++++++++++----------
 mm/vmscan.c     |  1 -
 2 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7969dd93d858a..ee98c9e8fdcea 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -206,24 +206,41 @@ static struct obj_cgroup *obj_cgroup_alloc(void)
 	return objcg;
 }
 
-static void memcg_reparent_objcgs(struct mem_cgroup *memcg)
+static void __memcg_reparent_objcgs(struct mem_cgroup *src,
+				    struct mem_cgroup *dst)
 {
 	struct obj_cgroup *objcg, *iter;
-	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
-
-	objcg = rcu_replace_pointer(memcg->objcg, NULL, true);
-
-	spin_lock_irq(&objcg_lock);
 
+	objcg = rcu_replace_pointer(src->objcg, NULL, true);
 	/* 1) Ready to reparent active objcg. */
-	list_add(&objcg->list, &memcg->objcg_list);
+	list_add(&objcg->list, &src->objcg_list);
 	/* 2) Reparent active objcg and already reparented objcgs to parent. */
-	list_for_each_entry(iter, &memcg->objcg_list, list)
-		WRITE_ONCE(iter->memcg, parent);
+	list_for_each_entry(iter, &src->objcg_list, list)
+		WRITE_ONCE(iter->memcg, dst);
 	/* 3) Move already reparented objcgs to the parent's list */
-	list_splice(&memcg->objcg_list, &parent->objcg_list);
+	list_splice(&src->objcg_list, &dst->objcg_list);
+}
+
+static void reparent_locks(struct mem_cgroup *src, struct mem_cgroup *dst)
+{
+	spin_lock_irq(&objcg_lock);
+}
 
+static void reparent_unlocks(struct mem_cgroup *src, struct mem_cgroup *dst)
+{
 	spin_unlock_irq(&objcg_lock);
+}
+
+static void memcg_reparent_objcgs(struct mem_cgroup *src)
+{
+	struct obj_cgroup *objcg = rcu_dereference_protected(src->objcg, true);
+	struct mem_cgroup *dst = parent_mem_cgroup(src);
+
+	reparent_locks(src, dst);
+
+	__memcg_reparent_objcgs(src, dst);
+
+	reparent_unlocks(src, dst);
 
 	percpu_ref_kill(&objcg->refcnt);
 }
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3ee7fb96b8aeb..82c4cc6edbca5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2649,7 +2649,6 @@ static bool can_age_anon_pages(struct lruvec *lruvec,
 			  lruvec_memcg(lruvec));
 }
 
-
 #ifdef CONFIG_MEMCG
 static void lruvec_reparent_lru(struct lruvec *src, struct lruvec *dst,
 				enum lru_list lru)
-- 
2.20.1


