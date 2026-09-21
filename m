Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A089C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:13:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BC166B00DD; Mon, 21 Sep 2026 05:13:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 792FD6B00DF; Mon, 21 Sep 2026 05:13:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D0ED6B00E1; Mon, 21 Sep 2026 05:13:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F8686B00DD
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:13:23 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4A5574059D
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:13:22 +0000 (UTC)
X-FDA: 85237205844.11.78A8B6B
Received: from mta0.migadu.com (out-115.mta0.migadu.com [91.218.175.115])
	by imf30.hostedemail.com (Postfix) with ESMTP id BB6CC80002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:13:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k9INECDi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.115 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789982000;
	b=bie5868Hezvlco9SolfJh7w7Iav9K+nnqqZ3KBs1dYGV6A/FOHp6fl2SO6x0teKSQKzU5/
	jRC334xjOIr06dcqMtD/oKtUZk8rl4DDWHaIIcnU6GDS5OiOowqxLop+O7wi0KMlCrFh6a
	3bK2zXIdcIYuX+B2QagZEaRMX6QFMRk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k9INECDi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.115 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789982000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MrrYoQHEj0YZFQiT9mt+lB5mIQQ6NHh4Snzq5DvF14I=;
	b=AmAlGVq3Sr0qvzPQyAGJT2UGc7AyyJcCDCHtvbEDUlgvKTmJQi5Nfh2jtQrAEDf1c2UARe
	VuUvYEjfSEVBNNE/RGUAitBHntuKG9/FcxaIklCeMFYVptgsi6Jz0DLQo8wKpT8W4/zbE4
	am3/8001KtoycHqihHgBNcgdsE0Yk5s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IDs/EyWNmqJ898UTthMq8jY9Q1siEUrx/p114gn5Wns=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789981998; v=1; x=1790586798;
 b=k9INECDiU2azQYNr44eOEUMVpgjRuGHtZgw3KW/S0rCYFh5svYkyAudRiOe0RlFhOo71ZKV3
 JxstsVrQiNl/pNTeqE7qH5XfSaNomzF2QxPN3CZndi23nQYTYLmNGOFDSOlaSdlIaHSujntjOla
 SVe6LkR/PhUwmmH/pmR6Wk4I=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c126fa98069b27b1;
	Mon, 21 Sep 2026 09:13:18 +0000
X-Mizu-Trace-ID: c126fa98069b27b1
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
Date: Mon, 21 Sep 2026 17:12:35 +0800
Subject: [PATCH 2/2] mm/memcg: migrate per-node hugetlb lruvec stat
 together with hugetlb folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-for-hugetlb_state-v1-2-8a6eec92661f@kylinos.cn>
References: <20260921-for-hugetlb_state-v1-0-8a6eec92661f@kylinos.cn>
In-Reply-To: <20260921-for-hugetlb_state-v1-0-8a6eec92661f@kylinos.cn>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@suse.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Chris Down <chris@chrisdown.name>, Johannes Weiner <hannes@cmpxchg.org>, 
 Michal Hocko <mhocko@kernel.org>
Cc: hongfu.li@linux.dev, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Hongfu Li <lihongfu@kylinos.cn>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789981974; l=2700;
 i=lihongfu@kylinos.cn; s=20260915; h=from:subject:message-id;
 bh=7maGt7gBIU3c+GPCYRQ3OHOtV+Op/E4Dxf2YD4KKGv0=;
 b=sYVTVa5VHI0QpIl9gKOtFeVmq6k72AX6PouymGlK4tZgfU/sDP/xUMQEYtPFsuetgF5HnkyHp
 Wol77pUzrqMA5+yMrquCywDFXnag9IZ0lTqCj5u9dbSqJzQakpxSiK4
X-Developer-Key: i=lihongfu@kylinos.cn; a=ed25519;
 pk=rUpDSpB3neoNZRlGG6dHlFb3RepiJakcev+ucyqaZzw=
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BB6CC80002
X-Stat-Signature: wchpu6jdji5afy4555b63kcyyoqe6br3
X-HE-Tag: 1789981999-611576
X-HE-Meta: U2FsdGVkX19ViC1OuAVJp3b5PNLHRCpCZ0Ezx2odYcpvN+ml+mB+bURE8kU9Bh/ka5j2CISpN6jNqeexX42gNHaXUAaunS69FsCEKJAjjRom+EBTYP0NMFmLRk5YZIeM7cAzIfJgCKcxSKc1M/2Im/e7HGHE018nS8rC6BCRhvJ9DIT6HIBkurXjdkNICSHIceIuW69RUCqvXluPHfdDj9WLECq14AdnGhdYECGUeTGj9AFdt3CrpmB6gCP4/qi5Y0D+ntmt3HWbOENximdqQObBg9/AqwMvxcpgzcxHpx3bVFSWN4lcqsMBWP4fo3EPD2YRy821mwoQlH8GAw8XC9dHnj+WQPth2MQS02HOjuqPOBR24G9hOeiuQFlvyhftXXWi98wNckJDy6sLvJm8TG6N7fHgc1bzYDYQP+CWPv0tn7GrsqEHXnJUj05fez1/eeJxZNOdr6nQblDJjqcHJ8N93+bbXWDeCW+0CWfNEELMyB6M2GfJtQcTYX3XdA/wHNXGzivxrlaNmeQVaGJxV9CLXtpXhqjgFLnj2MlshOWq58TENeNJnCiVs+KkLwiT3tqn+CXoa0XOoB/hOlXrlVYVo0K3aElArnlH7MmCXNZMVwrwDiSTCannXZGJj65AGQxrZyPvEb9UzuVUqslH74ZJkal4qPX5hpUip4ejI23WLCTmor5qz7D2jKScFbBBIl4c/PC6QjIsTdDfFWgT20FuAITGti9ItnWtYFMEX0g0pzcYQboJ+uyQyJgw/oj7ftXVOuPrlDDmY/A5YA9i/4wKvEcoP9LY5aAWH7yhyGitn8VsKs8IRVc4owiPG2/JEO7G9K9c586YOpLEgfFE+l5qZxaMoJZ5nmRyUyxNFCpZbUb8br+JpAgITe9AazIDyNhzuG096bcEQrS6wXZI5O1c67D7HPrJ8niZFEANrARsuON8vciQggR5H8ur+mptkyIafzww+RkAFlLu5uP
 DhEptVJx
 0kKFDtaIzGeiPN/VAK6/w9SIvEvvmA33BwjhAe4aKLY8I4TkZG29yAqudqPjzE+Brf2u47rCBHiMYygzRC3OEMKQ82qS4PkDRU0ZU9Yk22Kki0NlQ7TQ1hmj4bwZ7/fv+oT7ml0wIl2TcGTOJqliIkmHLjJH0YrdkDJxlPAslBr5kLmLvR3eG6AE5Tklt7bqAzIrFq5nZhZ7GVB8ubG1wPw0N+ljcuMnEcAzjQy50jjxoxiSmX30THm3CYrkSICXWsUoG44ozW0yocbveToGlMs1czFAtFXNG9jLIzETYslDNz1c=
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
---
 mm/memcontrol.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1460cba53588..9c96ebd5436f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5598,6 +5598,34 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
 	rcu_read_unlock();
 }
 
+#ifdef CONFIG_HUGETLB_PAGE
+static void move_hugetlb_lruvec_stat(struct obj_cgroup *objcg,
+				     struct folio *old, struct folio *new)
+{
+	long nr_pages = folio_nr_pages(old);
+	struct mem_cgroup *memcg;
+	int old_nid = folio_nid(old);
+	int new_nid = folio_nid(new);
+
+	if (old_nid == new_nid)
+		return;
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(old_nid)),
+			       NR_HUGETLB, -nr_pages);
+	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(new_nid)),
+			       NR_HUGETLB, nr_pages);
+	rcu_read_unlock();
+}
+#else /* CONFIG_HUGETLB_PAGE */
+static inline void move_hugetlb_lruvec_stat(struct obj_cgroup *objcg,
+					    struct folio *old,
+					    struct folio *new)
+{
+}
+#endif /* CONFIG_HUGETLB_PAGE */
+
 /**
  * mem_cgroup_migrate - Transfer the memcg data from the old to the new folio.
  * @old: Currently circulating folio.
@@ -5635,6 +5663,9 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new)
 
 	new_objcg = get_migration_objcg(old, new);
 
+	if (folio_test_hugetlb(old))
+		move_hugetlb_lruvec_stat(new_objcg, old, new);
+
 	/*
 	 * @old was charged through a non-root objcg, so its charge is in the
 	 * page counters. If the re-derivation walked up to the root objcg -

-- 
2.54.0


