Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D825DC531D0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 03:35:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 709086B009D; Thu, 23 Jul 2026 23:35:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66B596B009E; Thu, 23 Jul 2026 23:35:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 532D06B009F; Thu, 23 Jul 2026 23:35:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 216EE6B009D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 23:35:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8E69F8025C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:35:53 +0000 (UTC)
X-FDA: 85022256186.05.EDE0F84
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf08.hostedemail.com (Postfix) with ESMTP id E5C26160003
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:35:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jyqMbY46;
	spf=pass (imf08.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784864152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wFagSG8TREooj6tYIMeEutZPkcYhfVQ2j8s11yIMCIQ=;
	b=Z5IGS7yoQenmnT2zN0/vngEl8BZPQxQqTxqxo9eCM94LedkGmJUqq61LM6p8oOlsq9z66x
	wHY7ScWVnQk0KlngaMyCZIKcbsgePGZmiCvyS3+sDf+ZAvsWqCa+P7y92Tmlhegfpui4O/
	aA9O+3Usz+nWqP2nc3kLc7QjmVUrxjA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784864152;
	b=gRI1OT4fLOGAeTgyse3wUlF8op/SxfsiAw4mOYVK6xSSeJFofEVkvED2QcQwX8nU7MyGFR
	+2a44PMqtHypKtvPyGfEblEp09KKIFvwqZSflWyVwwRAdT/+AysrzCIfgX/OPiFewaGkf0
	e+jP0yEPxyMcwaN+NId4JifQ6gucqRM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jyqMbY46;
	spf=pass (imf08.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784864150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wFagSG8TREooj6tYIMeEutZPkcYhfVQ2j8s11yIMCIQ=;
	b=jyqMbY46ZgBvbtEvffNJ4dEjLG/RPxA91n2xVv36mzlY7p61he0c5OSMd5cN9euu56nkew
	JO1uJXCytApkKRiXFDjr9W0AocFZli369SOG1urI8zrHcVzwxtJjJGJZKoXjBR97PevsX8
	qLmyfgjn9e9ynFD8Vjzhc3YPCDo52+w=
From: Ridong <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Zhongkun He <hezhongkun.hzk@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH -v4 4/4] mm/mglru: fix anon-only reclaim evicting file pages when swappiness=max
Date: Fri, 24 Jul 2026 11:34:35 +0800
Message-Id: <20260724033435.2573323-5-ridong.chen@linux.dev>
In-Reply-To: <20260724033435.2573323-1-ridong.chen@linux.dev>
References: <20260724033435.2573323-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: m8mobd7xnhgwiip5e6q9693iebawfj9q
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E5C26160003
X-HE-Tag: 1784864151-824680
X-HE-Meta: U2FsdGVkX1+gLovK6HFwHn5XO+0y3KlbClErDchZV4zsp+F02xm6IHJ/6vt0r1qYh5gjmg87U9dj9ttB1oFjaddA5BKNXjdciAHFeRdDPorcbgXaZxoj8gY1jHCJAoi5cmOQG401tdR1bOv8INXxtXbOtU0IFEgrZs4AgvaoxfnyPaqHfpMt47epdOeLBG7OUZ1epG8OYU6N3BH8cm5nNo+wWWuv9nQoPiQeziWEieihUsbCs3kb3QcEI/hynB5HMVUX3M44/Z96gGxMnZxwiKpGHV37acxXok8Mifnh2ekrKJGWLu7y+p38vIKRfV0d09EliYBUHqNhCKi3LIbPGZV4sxE8k/TGPnRgftsVJ9QrmfcV87GTeXCijrMBsp8oEOF9t6nNLEtwOImyyKvxkbtt4t4id3GHnFDsvE3PLTJgGNTjEteM9r13C3D6nTqrMaP83Xsfi2MAmv8bSKG+RjVcJXPmzB9L5kJ+MG72MrbQSTD/8pl1SSqDSPhIhOC6oVEU/9VDy5HXIku1jiJFCTEjRoeqzaE/M3a0ASTjNWmSJaxUJiQOeWaiR7zVpokq7qdo4nsyXdYVxmoZfGZHtSB1QCdVOu5vMRw3Ux1JaM1vDYubPLqH2qMSwJ6XIKYVOt5TY5aSUCX4IJFSSdLsmv1t/N8XRzHk9fsdfwnAa0i3Xxw1WKyb+9530nSUoFe0m0Y5aVx3fPs3JVTq9BNTH8bF4i3iWHcmIDlRUTlc6K9CUvyFBt9e0CmyRcU61R2QAqWpU7K0Bb7u7bV2o7KaCfdnXuSDYh2IIUPBYfsJebIqLFtx6cGQsAx0ly0ITDJYhwfrhMZnljIjwWoHry3Win6xkIfjSIBj4Mor+fCYt0uDau5rA+GB+T3GOT18Ao3LDFHvgIv3CAssmfpSLyh98Lh0r7U/yS/ROlXDzzhSNipUNRUsfVXYTZ8++Au/F5U8HSZ72R/99Eap87VzQ1J
 c+FzFE8I
 QfdCgtLp1uswCMdQs7kTzoVvd6wSMR9fiZUl1xXpWDmgeogrgVC1thG/E4gYgr9tOPVpmh/C85Z5BLaKUHZPA4FW0jWQ7cG5DZZ7B64v6mVSb5Z8XoCRdqWoWUJ7YZ8pPuLXlJlrlqyXjQCSXumV+I/mWVWlP9Ls3sy9GSI9W21Kv+Q19ZlLOhzvryeB8rd9Akl9WtjX2EgMkbgefDeiEoVQERGH4KgQq+E4pa5sCLZsFoamTU87LTI4N5NMrBTaHwt/XJq6Z6ETqdeFpPuuXpKKvQ1PeHhITIxYT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

The previous patch fixed this issue for the traditional LRU. The same
problem exists in MGLRU [1]: when swappiness=max (SWAPPINESS_ANON_ONLY)
is set, reclaim is expected to evict anonymous pages exclusively, but
file pages can still be reclaimed when anonymous pages cannot be
reclaimed (e.g. no swap and no demotion target).

Fix it the same way as the traditional LRU: keep returning
SWAPPINESS_ANON_ONLY in get_swappiness(), and return 0 from
get_nr_to_scan() when SWAPPINESS_ANON_ONLY is set but anon pages cannot
be reclaimed. Since get_nr_to_scan() decides how much MGLRU scans,
returning 0 skips the scan entirely and avoids the useless scan work
when there is nothing eligible to reclaim.

The test result:
Before fix:

  # cat /sys/kernel/mm/lru_gen/enabled
  0x0007
  # cat memory.stat
  anon 204800
  file 67108864
  ...
  pgsteal_proactive 0
  pgscan_proactive 0

  # echo "64M swappiness=max" > memory.reclaim
  # cat memory.stat
  anon 208896
  file 0
  ...
  pgsteal_proactive 16384
  pgscan_proactive 16384

After fix:

  # cat memory.stat
  anon 188416
  file 67215360
  kernel 1970176
  ...
  pgsteal_proactive 0
  pgscan_proactive 0

  # echo "64M swappiness=max" > memory.reclaim
  -bash: echo: write error: Resource temporarily unavailable
  # cat memory.stat
  anon 204800
  file 67215360
  ...
  pgsteal_proactive 0
  pgscan_proactive 0

[1] https://sashiko.dev/#/patchset/20260717113300.214717-1-ridong.chen@linux.dev

Fixes: 68a1436bde00 ("mm: add swappiness=max arg to memory.reclaim for only anon reclaim")
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/vmscan.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 859655fcf60d..254827544461 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2708,6 +2708,10 @@ static int get_swappiness(struct lruvec *lruvec, struct scan_control *sc)
 {
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+	int swappiness = sc_swappiness(sc, memcg);
+
+	if (swappiness == SWAPPINESS_ANON_ONLY)
+		return swappiness;
 
 	if (!sc->may_swap)
 		return 0;
@@ -2716,7 +2720,7 @@ static int get_swappiness(struct lruvec *lruvec, struct scan_control *sc)
 	    mem_cgroup_get_nr_swap_pages(memcg) < MIN_LRU_BATCH)
 		return 0;
 
-	return sc_swappiness(sc, memcg);
+	return swappiness;
 }
 
 static int get_nr_gens(struct lruvec *lruvec, int type)
@@ -4921,6 +4925,20 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
 			   struct mem_cgroup *memcg, int swappiness)
 {
 	unsigned long nr_to_scan, evictable;
+	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+
+	/*
+	 * Proactive reclaim initiated by userspace for anonymous memory only.
+	 * SWAPPINESS_ANON_ONLY is set only on the proactive reclaim path, so
+	 * warn if it shows up elsewhere. When anon cannot be reclaimed (e.g.
+	 * no swap), return 0 to skip the scan entirely, avoiding useless scan
+	 * work when there is nothing eligible to reclaim.
+	 */
+	if (swappiness == SWAPPINESS_ANON_ONLY) {
+		WARN_ON_ONCE(!sc->proactive);
+		if (!can_reclaim_anon_pages(memcg, pgdat->node_id, sc))
+			return 0;
+	}
 
 	evictable = lruvec_evictable_size(lruvec, swappiness);
 
-- 
2.34.1


