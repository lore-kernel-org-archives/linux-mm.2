Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFA61C4451C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 09:54:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D32296B00A0; Sat, 18 Jul 2026 05:54:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D08CF6B00A2; Sat, 18 Jul 2026 05:54:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1F8A6B00A3; Sat, 18 Jul 2026 05:54:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E8406B00A0
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 05:54:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 31F5E1A0379
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 09:54:37 +0000 (UTC)
X-FDA: 85001437794.05.2B6AA8C
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf01.hostedemail.com (Postfix) with ESMTP id 924B34000B
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 09:54:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M7Vle5EV;
	spf=pass (imf01.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784368475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lO66TrggiuQ7p/0nxBhsLlU4BVpMMd+j4O5LEqrNdrI=;
	b=f9UQFaTV7R9761OC28el8qRErnaTOx+K38gxeOCFD/GRXJ0r3azap5fNnRPnD00PH0s5sv
	fTC3+Canwg2QJyXGxB07B/cXkJOwnVhDIoI+4+eXzlcazZ/cupEOIRI8TihQbS1AehD7IV
	HOAZPvfGh10aUrBSzPfxjg78qQ/TcT8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M7Vle5EV;
	spf=pass (imf01.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784368475;
	b=cTX/DbrX0null48gMks3dqo2nSqpZHKERFLP+STqDtywGHHMW92+NQsHUrpEisI3csecQI
	g0QBVAVweARtjdmuWZ9TaTPlM8A/gQYq0G+Dx5Emb+k7wiUmign+KsTPGrAYkgjqb1yxOV
	CfghfwPml5cdIzFyP9ceshGaGj335D8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784368474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lO66TrggiuQ7p/0nxBhsLlU4BVpMMd+j4O5LEqrNdrI=;
	b=M7Vle5EV7fSyEDSoDc+ub+hZJ3XzmI8D08hPQ1s2AY4Zl02x7O6gHYGeqlsko18gRj5k9U
	IF4I4rqrl66FhbTOGVq5U8370Pr9XfmY3he+nMUypFBj2+o3+CBSqGulu8qQpPwkZtbEnk
	rdM+9yOjIv+BB9DYU2Xmz9HTphMUJgQ=
From: Ridong Chen <ridong.chen@linux.dev>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hezhongkun.hzk@bytedance.com,
	muchun.song@linux.dev,
	dave@stgolabs.net,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ridong.chen@linux.dev,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v2 4/4] mm/mglru: fix anon-only reclaim evicting file pages when swappiness=max
Date: Sat, 18 Jul 2026 17:52:51 +0800
Message-ID: <20260718095251.82937-5-ridong.chen@linux.dev>
In-Reply-To: <20260718095251.82937-1-ridong.chen@linux.dev>
References: <20260718095251.82937-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 924B34000B
X-Stat-Signature: gby4eqs5tw54howexgi43xraongu95pw
X-HE-Tag: 1784368475-721416
X-HE-Meta: U2FsdGVkX1++ss0ur6irKgDVItqFmjoy7wxMHlYV8uz5bLbIDzkHOMmODaoKCUYU8T+3bV/sgqJuHIr6JbDHtIrvyf+UquZstj6aSB1grD81c6USUlfuWswg5JCDP/Sz8j+jWKs3Wn2tjm7TcXhpYaKk8PAtq1iMMIuYWAFtqQvYN8Q0O6i4yi2FTGjtOtgHREJ0efo97zD6OJ7Q/JbKL+in/R0fblevW0yf8TWM6Tdx5MILouDngfgsjAF2l2XN18SsTiVIcRhPNDzDLcuThSF4hICO/3xGeHyDhZCXIfYilttNxKvq+6NmaFPlolyDkaBFtcqwyVSVEoIth+/HRZyCXUZnntHxQ1XE9LI3CtOigKDUQugKEN9JokU43IOR3C1mN0s9ingTPT7ISjIXi7qQXWsJ+TF1vmrvA6rIwtmb4vBQh4EHq2mxOupPMsluEZYRkI3M0ARB7u/8QQ4duJ5Lroifh8zo9u+wWGciQDzYr/VnOV3waP1a/8tjKwHPupgppOM7yHgZZFIKmE8+b9/AJDQ5BJcqn4k31jhICQxu1zK/U7m3Oc5iYclX66Ykhom2k8jbbc6q9e8emwbNkpokvOLWRZvwrZg/wrzjiVLzSjt4g003o6+GeTYC9lO4TPkelwJ4HKHE+KqHANnadyGtliJN3R0dDHaZNFNY/28ZFCDyksQbN3fO9HH5Kj3dOceypRT8WbBYB2q0GiZerndDrvO2Oqoa/zRRwS7DU7rkkGJlPj6jE7A7GhQ6NppuVPt0YdfXUjLvLuX23Ra9I1aTUVnxtaJ6nFQy7Y4Pclk9xcZqKcqZ/KUbcr8JAlNBKLtBory0KOWFbh134kZoJWtr0T5F+xa2Ve/ZijSXJ6H1wazOJFhl0vHh5vRJkATkUc44PhyeXMVFkTUE2Q6XGu28s5Zj2P88JFXFJlLcbzT3s/T8uhPMXyVJmZyPnmRRM7rusD0QNXHpZd5Q405
 VIe1xQqe
 Bou6548mjLpFbQl86Ucjr6tLV4DGOyUil9xERL24U1G71pz+6HbTwG8+kfnticZmeen3hGtF+mm0fHW07pk6SKcV3EfYyeOR3W6YzXjj8kYe40bkOWQTFHfaI51EW8UqCLDFiyH0zZEA+OhdrshfsPwP+QwCLP1ysvTm1sjwmdK7GLcQNeXhFH67i00okgcelPhB+Rva3D0k7L804Y1PXSWUrazUPEMM6sROGw02gw45zXHdZdPwZ3SaUz5l9AWy3nndcGa/18MbIcvvQENZyzeG9QJxmi8QPEkg8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

The previous patch fixes this issue for the traditional LRU, which also
exists in MGLRU [1]. Fix this by checking whether swappiness is
SWAPPINESS_ANON_ONLY in get_swappiness() first, and returning 0 from
get_nr_to_scan() when swappiness is SWAPPINESS_ANON_ONLY and anon pages
cannot be reclaimed, to avoid useless work.

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
 mm/vmscan.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index e1ef6350a300..240b04f0a21a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2702,6 +2702,10 @@ static int get_swappiness(struct lruvec *lruvec, struct scan_control *sc)
 {
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+	int swappiness = sc_swappiness(sc, memcg);
+
+	if (swappiness == SWAPPINESS_ANON_ONLY)
+		return swappiness;
 
 	if (!sc->may_swap)
 		return 0;
@@ -2710,7 +2714,7 @@ static int get_swappiness(struct lruvec *lruvec, struct scan_control *sc)
 	    mem_cgroup_get_nr_swap_pages(memcg) < MIN_LRU_BATCH)
 		return 0;
 
-	return sc_swappiness(sc, memcg);
+	return swappiness;
 }
 
 static int get_nr_gens(struct lruvec *lruvec, int type)
@@ -4915,6 +4919,14 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
 			   struct mem_cgroup *memcg, int swappiness)
 {
 	unsigned long nr_to_scan, evictable;
+	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+
+	/* Proactive reclaim: anon-only requested but anon is not reclaimable */
+	if (swappiness == SWAPPINESS_ANON_ONLY &&
+	    !can_reclaim_anon_pages(memcg, pgdat->node_id, sc)) {
+		WARN_ON_ONCE(!sc->proactive);
+		return 0;
+	}
 
 	evictable = lruvec_evictable_size(lruvec, swappiness);
 
-- 
2.43.0


