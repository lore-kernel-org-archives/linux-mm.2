Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59D50C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 09:12:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 112106B0092; Sat, 11 Jul 2026 05:12:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E9CC6B0093; Sat, 11 Jul 2026 05:12:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F41A76B0095; Sat, 11 Jul 2026 05:12:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D33096B0092
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 05:12:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6A8721C8EF1
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 09:12:40 +0000 (UTC)
X-FDA: 84975930480.03.8B0F130
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf29.hostedemail.com (Postfix) with ESMTP id BF632120005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 09:12:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VrP+biTW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783761158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=txHSRzd4Tyll9+u/6ycOBWsZl1BLLa4J8x2YbM2XGjY=;
	b=KSLTYwlgcku24G5J4sMBs75qpWCFDWuzcAzyoWA3NjGGCDpXwUD4Lmh1hX0yXXVBxSzamy
	YMKYGkH4NwYx9ik50HBKhvnvra1paVrXRl0Tixw00q503SbpLECpOMFBxtGc25WbN/QdbL
	NKg3JHzkCKSUiZqqa2hKkPQsGNuTWK0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VrP+biTW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783761158;
	b=3vME74fpi/ryI804/mXovkD2UPL9XEZHQ7cop90EHvXHn2YAsjeNTm67tC2kJxdc9ihJvx
	GttmRS7pCrh3+vN3CO2uViDYJ4+td2HmjLaomT6OEc4q2ds72sChxHcXKBa7/xA/CpiGvk
	B2il6Qgusx/rqLSUtgJqbpHm3oF50dM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783761157;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=txHSRzd4Tyll9+u/6ycOBWsZl1BLLa4J8x2YbM2XGjY=;
	b=VrP+biTWejQyufZrrsBWkZdS4Y44CAMVPA1t1uvFTYzGQyvivpH+acxA0fsBkOrv3yFNbW
	FwCVtuUgwOZrbyWhMHC7vjl3alqLcXGVBegb3WalKIIMUstbUpLhCpFJBQSYSRIJevONsD
	J8QqLiojiVVSfyKBPJ68zkmaZzViM9Q=
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	David Hildenbrand <david@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>
Cc: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ridong.chen@linux.dev,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH 2/2] mm: vmscan: fix node reclaim ignoring swappiness parameter
Date: Sat, 11 Jul 2026 17:11:57 +0800
Message-ID: <20260711091157.306070-3-ridong.chen@linux.dev>
In-Reply-To: <20260711091157.306070-1-ridong.chen@linux.dev>
References: <20260711091157.306070-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: BF632120005
X-Stat-Signature: x5wbeqezitozdue1cecojobmd4ipfo8p
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783761158-167569
X-HE-Meta: U2FsdGVkX1/8zYBTr6tHeA3r67cw5KM6j928mGfHuxe7y6yRqim7+PjEf+k9+QWsEQAaKdi5SSsZ9yrM1LPi31huJ7G1zYus1CMdTk2TeqlW4HTaAEwucpybo/iw0yCZAf7UsNHck9DD2n9oo05IXm4TEWCo/K1QJ7X/3s8NEclBS1xYP1joS4YU6EYXKfrh5jSrPH2wjT0Roylag87Unmys7MQNS97WRpIsVSnPcNT7+IfH4S7qYdoalPgkzfIPTci+e7bqCGdUaoeJ+0myHosOGV837ZJ+ayQXkYuADF+vriaXAsRv/eU8s+oLBsEpHUpnKblgpXH/E1M48PfIuPSJ05XXce4MFTJtGtmaSjP3cEb9IbfCci4I685nXC80zaaV2QstVR5z6sl5l9B7DpCE1wgRSFWuyAa8teBeU4h8Sgm63vRmXcuRVmu94FZjHzTdK3mNN0Gp/qcIadHzBUilXvkU025c8pRaCdY8nN6iJrBn8GdYnNRWyiGPrc2o5t7RNsJ+rNuvfHhWpEVgydj29qwH94MYjQoz6b1ogwJphcCIMrjnIVrTKiYDhhB1B1naqLTzVfN4yVY4rHM+rGhZ76sWnKf8hx5kmv6oYVWbPnN2zTGlWV2bfpIjz1D6L4XmtAyjRMMQjqPaA1GUHpo5A+uFyaVv3m4lmMRdzr04yTG2uECSukN0TwhHr0hI2ZNUJLYrtE2pUWJOudReD2WzIUXVeYe+vFL3P6Md6W1bsVF8T4/zG+s4uBL3DjVlsKjFom9jG0XXl1m3kFWgzw6Jeq+2+jM5G/BSG+tGQF8w6wvNLCkfYVt1RlAlgqiNK0OnK7XtLMu55t/yFZ+yJh2qtbJQ1fiOcc6sCB0EhwLdSxnFy0Mp5NyDPs9OVGmOFEm/4QrThYwQBXoV6Ldsb8L1Ii4Xa7dddOqINtF7auEKzwiSSugS1uQ8frT6c44/DKpgCUqeGkf86FLUO7U
 DgiJwtmG
 kOOsUAKuLgvfNfKLzVDMaV3zrxtZjgDEQTt89Aksz6owI1KSAn3Rm8/gp6pAxwWhDoV5/txqxO3QM3BYaKV0bdWptTO9ld6q/0q0/WXXY4e3hvwf3p3yqHrqSL3f993bYLYgRi919DhNF91tgpWLWpymsz1117eANvhdSGc/y2LPa4eVjCTe+tHVw9R2TqgP/KUTJIuYRnrwcgkBsR5UMdLfMeLvvGOkyC1lJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

sc_swappiness() had two separate definitions depending on
CONFIG_MEMCG. The !CONFIG_MEMCG variant simply returned
vm_swappiness, ignoring the proactive_swappiness value passed
through scan_control. This caused the swappiness parameter
written to /sys/devices/system/node/nodeX/reclaim to have no
effect when CONFIG_MEMCG is disabled.

Fix this by consolidating sc_swappiness() into a single definition
that checks sc->proactive_swappiness first, then falls back to
mem_cgroup_swappiness() which already handles both CONFIG_MEMCG
and !CONFIG_MEMCG.

Before fix (swappiness=max ignored, mostly file pages reclaimed):

    # cat /proc/sys/vm/swappiness
    60
    # cat /proc/vmstat | grep pgsteal
    pgsteal_kswapd 0
    pgsteal_direct 0
    pgsteal_khugepaged 0
    pgsteal_proactive 1840
    pgsteal_anon 25
    pgsteal_file 1815
    # echo "64M swappiness=max" > /sys/devices/system/node/node0/reclaim
    # cat /proc/vmstat | grep pgsteal
    pgsteal_kswapd 0
    pgsteal_direct 0
    pgsteal_khugepaged 0
    pgsteal_proactive 18013
    pgsteal_anon 337
    pgsteal_file 17676

After fix (swappiness=max honored, anon pages reclaimed as expected):

    # cat /proc/vmstat | grep pgsteal
    pgsteal_kswapd 0
    pgsteal_direct 0
    pgsteal_khugepaged 0
    pgsteal_proactive 0
    pgsteal_anon 0
    pgsteal_file 0
    # echo "64M swappiness=max" > /sys/devices/system/node/node0/reclaim
    # cat /proc/vmstat | grep pgsteal
    pgsteal_kswapd 0
    pgsteal_direct 0
    pgsteal_khugepaged 0
    pgsteal_proactive 16283
    pgsteal_anon 16283
    pgsteal_file 0

Fixes: 68cd9050d871 ("mm: add swappiness= arg to memory.reclaim")
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/vmscan.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35c3bb15ae96..5271bd023c1d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -198,6 +198,13 @@ struct scan_control {
  */
 int vm_swappiness = 60;
 
+static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
+{
+	if (sc->proactive && sc->proactive_swappiness)
+		return *sc->proactive_swappiness;
+	return mem_cgroup_swappiness(memcg);
+}
+
 #ifdef CONFIG_MEMCG
 
 /* Returns true for reclaim through cgroup limits or cgroup interfaces. */
@@ -239,12 +246,6 @@ static bool writeback_throttling_sane(struct scan_control *sc)
 	return false;
 }
 
-static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
-{
-	if (sc->proactive && sc->proactive_swappiness)
-		return *sc->proactive_swappiness;
-	return mem_cgroup_swappiness(memcg);
-}
 #else
 static bool cgroup_reclaim(struct scan_control *sc)
 {
@@ -261,10 +262,6 @@ static bool writeback_throttling_sane(struct scan_control *sc)
 	return true;
 }
 
-static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
-{
-	return READ_ONCE(vm_swappiness);
-}
 #endif
 
 static void set_task_reclaim_state(struct task_struct *task,
-- 
2.43.0


