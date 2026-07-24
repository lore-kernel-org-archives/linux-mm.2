Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5445C531D0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 03:35:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66BC86B0092; Thu, 23 Jul 2026 23:35:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 643286B0095; Thu, 23 Jul 2026 23:35:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BD856B0096; Thu, 23 Jul 2026 23:35:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 150A86B0092
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 23:35:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 71A0580279
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:35:39 +0000 (UTC)
X-FDA: 85022255598.11.0B4F0BB
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 56653140009
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:35:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NcfuxWe4;
	spf=pass (imf23.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784864136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+M31gX24/lXdo/71mKqeb9yMjPYP0lhEdBSZm1x7d2Y=;
	b=yEnjL1H74KQjTumK5V3Vm0G4rZmvUMaBUFCy9kTMmWGGAxBuRkCTjKKdc17YeEoZuZjpTA
	IsZOyzT2wSeaZczgsShAmvT6qKPYuaKQ1eV2WuawCwZeEZDydZkD9UwXLos/sBFWFy17Bh
	D4g2X0RXIUkR0bOciahFsLo1X92jA6s=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NcfuxWe4;
	spf=pass (imf23.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784864136;
	b=4V06rIDHuR0P4zTbH64lrPiU2J00vBSs/KXP7hrkAyxhLQVQ6VCoJwiS/MfbyR/8nKspTs
	LzYc089AKk8JVsml9A1nbX7JFJ4xjFFG2bTecvXecu2YxDtNfXk5LoXhQ/O+2uQiZgzNGS
	DmaNFsC9GmmRIJWe72Ype9wwN+yAQGM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784864134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+M31gX24/lXdo/71mKqeb9yMjPYP0lhEdBSZm1x7d2Y=;
	b=NcfuxWe4XPrL1LzeZK7hW22o+N+f+G6Cq3qeEfgUkFKaEuTe3NZ5Xr6fO1GpkaYDtoa8zQ
	a4NKJj8Fnh6l/3etN8RKyhIIogoozkOhfeCvCDtqq1t5hnJD5r3IJyxxkNz3yF48supnuR
	dQ9ZgGjoHq4oaP0nXly8NovyKr0IYbY=
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
Subject: [PATCH -v4 1/4] mm/vmscan: fix anon-only reclaim evicting file pages when swappiness=max
Date: Fri, 24 Jul 2026 11:34:32 +0800
Message-Id: <20260724033435.2573323-2-ridong.chen@linux.dev>
In-Reply-To: <20260724033435.2573323-1-ridong.chen@linux.dev>
References: <20260724033435.2573323-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 56653140009
X-Stat-Signature: 8aknry13yz3gy8imu3nezeugcshuy1cp
X-HE-Tag: 1784864136-248763
X-HE-Meta: U2FsdGVkX1+9qwNsP5WyJ7MKQ5uxhKjAL3Z/q0jNmQwy+fO3IMwy+KtIW2DhWCOur492Ywa1HGw1hOUOadoKNLdqNo+lJqPa7yDoiDvPh1rCwZDkkjuITgRiZTt01s95YxKbz1xSSzbHb8Fatf1jF4Qo9NGKe6Fs74SIbIioRWv0MscZ5czYY9GCzz3g3El90h0yLTwx+3NW8hhofvint9pDXc/p4HoHo3OS2DmqxpnIQsSdrGcx8XxwPvGsHRpHhbwtRMuUVQSo0f0EbHeidrtuh28Omhd/MxJ+j7sIQfk3ceUnJUWILHrVAd09Trpqt5ddGXc9BaUVd4Zff2FQF0217a25rJf19AMnHTNarT+7w9PgGAP+43ZmNQ2PhHrXfKuXjJb1rLHCxyFPdpn6d/PGwsr8j6yuIegfsP9btaFeMFUx+DNHzldbJgZFUdntiZ81G1Xuj2rbP5ZIoYEoSRvbY4PDVD3coAEbk6E9DDr5XMB9wBonyVaEu1GtO/vPAOZ5Whnmb2VBMXAuqcxhml+XuvmDYSBNVWN/P0DQiE34HJAVKkfRYk2ObDPNa421QlIrBzHwhrs+UMPDNT5WBycsbGCcVODXmXbRjzbRhIMjbzuon4o0m+w2D/Dj1WVEWpES9TWPbeJZ9EtnLdPYV88eGuGQCMeZpBubp5Ht29CqicCtKu+cXnJvNffBMiqhI9aojh3gqBEz98NEEDry5wV9kGUhIVInGB2NqmEBQ5VRZVQuFL6XTCmmMLREO9Jvqg12nfhU7g+3uaQjvl1hf1FyGyBfGL7RWzyBV/BXmbELL4w4SV2dW95mJUPYDXVW5k5JAKvHs/4wKODFdQQqbjFI0z5pS3nzGCLnMC1GagUIv+IfyFsu9TMDmsEys03P/v2FxGeM+gUkd+NxZpxtBwhaDRa1GEYs61e+LD8XAfP1WzDliSvwFR2Q3PzodKNt9C16XR+NLzYJLluVv76
 UDZ+bgPg
 qF9N+7W5BVNtgMRieN8O5He5tg8XABIMvolnykyYYfiGid8ICVc/0GZ5ZJj/dPQfHYoJcbipn7kKB6B1+hurgF/+NWYRLUwIBZhBARsSvIYsD6Wc7vFIn2qhCyMYhrbFBltGUoeDAXctxGblhJjjttdsLzM5S2cXQ33QHYbwfC4K9UabewSU62/dTrVQV7D/pqjpNj23Ixi690nFSlhplQA6To+MLToaUgLXL8vleWw6dl8bFZGjHpshJ82l3qnvSaO6L63d8sLCmTgqbq8S3XCvnGXRoQbXDbb+iOtuhytZWUcqzlLH3C9c3cw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

As Qi mentioned [1], when swappiness=max (SWAPPINESS_ANON_ONLY) is set,
the reclaim logic is expected to reclaim anonymous pages exclusively.
However, due to the current ordering of checks in get_scan_count(),
file pages may still be evicted if can_reclaim_anon_pages() returns
false, which contradicts the semantics of SWAPPINESS_ANON_ONLY.

Reproducer in a cgroup holding 64M of file cache, with no swap configured:

  Before (file cache is wrongly evicted):
    # cat memory.stat
    anon 196608
    file 67178496
    pgscan_proactive 0
    # echo "64M swappiness=max" > memory.reclaim
    # cat memory.stat
    anon 208896
    file 4096                 <- page cache evicted
    pgsteal_proactive 16400
    pgscan_proactive 16400

  After (file cache is left intact):
    # cat memory.stat
    anon 200704
    file 67178496
    pgscan_proactive 0
    # echo "64M swappiness=max" > memory.reclaim
    -bash: echo: write error: Resource temporarily unavailable
    # cat memory.stat
    anon 208896
    file 67178496             <- page cache untouched
    pgsteal_proactive 0
    pgscan_proactive 0

Fix this by bailing out early when SWAPPINESS_ANON_ONLY is set and no
anonymous pages are reclaimable, before falling back to file reclaim.

[1] https://lore.kernel.org/cgroups/7ddf3eee-5fe2-45f7-8614-c8936a039e04@linux.dev/

Fixes: 68a1436bde00 ("mm: add swappiness=max arg to memory.reclaim for only anon reclaim")
Suggested-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/vmscan.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35c3bb15ae96..2c689682b952 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2501,6 +2501,23 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 	enum scan_balance scan_balance;
 	enum lru_list lru;
 
+	/*
+	 * Proactive reclaim initiated by userspace for anonymous memory only.
+	 * SWAPPINESS_ANON_ONLY is set only on the proactive reclaim path, so
+	 * warn if it shows up elsewhere. When anon cannot be reclaimed (e.g.
+	 * no swap), bail out instead of falling back to evicting file pages,
+	 * which would violate the anon-only semantics.
+	 */
+	if (swappiness == SWAPPINESS_ANON_ONLY) {
+		WARN_ON_ONCE(!sc->proactive);
+		if (!can_reclaim_anon_pages(memcg, pgdat->node_id, sc)) {
+			memset(nr, 0, sizeof(*nr) * NR_LRU_LISTS);
+			return;
+		}
+		scan_balance = SCAN_ANON;
+		goto out;
+	}
+
 	/* If we have no swap space, do not bother scanning anon folios. */
 	if (!sc->may_swap || !can_reclaim_anon_pages(memcg, pgdat->node_id, sc)) {
 		scan_balance = SCAN_FILE;
@@ -2519,13 +2536,6 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 		goto out;
 	}
 
-	/* Proactive reclaim initiated by userspace for anonymous memory only */
-	if (swappiness == SWAPPINESS_ANON_ONLY) {
-		WARN_ON_ONCE(!sc->proactive);
-		scan_balance = SCAN_ANON;
-		goto out;
-	}
-
 	/*
 	 * Do not apply any pressure balancing cleverness when the
 	 * system is close to OOM, scan both anon and file equally
-- 
2.34.1


