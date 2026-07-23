Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D24EC4452B
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 03:25:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 736166B00C6; Wed, 22 Jul 2026 23:25:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70E126B00C7; Wed, 22 Jul 2026 23:25:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 600C36B00C8; Wed, 22 Jul 2026 23:25:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 33AAD6B00C6
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:25:13 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A752F140361
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:25:12 +0000 (UTC)
X-FDA: 85018600464.19.BCA6B50
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0D15F40006
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:25:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dWO4NxvV;
	spf=pass (imf11.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784777111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z8OTpiatQBHFhVb1kcbCtXbO04T0mIjzVEpsj33f5I8=;
	b=C/S8TgJImI47JOm9EN1WabJEap8NyebYBAaUrrodoW/+tz3rS+zUtVkfslRVTXhIeN3Tr4
	lXBlAj4nOD600qcErQK1oJj/WQUSXpNezGuAnC/ptyr86kKh0VAH9VUAd+Klnd9HAZVlAm
	1V2dW2zAUnL0hmK6QjSc+sVS8hiNnlw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dWO4NxvV;
	spf=pass (imf11.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784777111;
	b=g4MaOWGb953bTIiGUqyhYten/8BPAwROkDSF7+6/2O7nxjUrZNAFCAXhaEdLdoF/Hc2/X0
	K+ILFngsnhYHgazkflSrxijShNEqAKOR+gT0ETdLBaskDXMB5tJcJee7FSq4jWIChBJcjS
	45ly4zYB766/QudgZkbjNn+A+GWr1wg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784777108;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z8OTpiatQBHFhVb1kcbCtXbO04T0mIjzVEpsj33f5I8=;
	b=dWO4NxvVnnjKGuqo3qzfxKzhUKo3sdjpaWPlrGNi6aOGIcZXw0WenQYF3Vs1M4OTZnArqC
	9lcjRkm8zXCLDuvZf21/B6QEXLG3RPuuStjDBl8rvOEnAtYypC/wemgFHFpjWvOOdV8Q2Q
	nNrovUKOq8dYSrn4gT/RZduAGdwZCZo=
From: Ridong <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>,
	stable@vger.kernel.org
Subject: [PATCH -v4 2/2] mm: vmscan: fix node reclaim ignoring swappiness parameter
Date: Thu, 23 Jul 2026 11:24:34 +0800
Message-Id: <20260723032434.2016749-3-ridong.chen@linux.dev>
In-Reply-To: <20260723032434.2016749-1-ridong.chen@linux.dev>
References: <20260723032434.2016749-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0D15F40006
X-Stat-Signature: pai9r9nyh7qoko3x8qpanuy558yss7h7
X-HE-Tag: 1784777110-933444
X-HE-Meta: U2FsdGVkX1/gLi4ASY1Txqmt/Wpk2QIBtI4jozkOghSHCcrqFN6vSo4y25Hw4kqkvncHpxa6KDkYQydcd0+bzv2EL9L7W4XRHUojDQNerwkojbyhbV14apsszRH4xHL9jvxYIiV22VpU5yuJN5hXJj/0IcgUW1P3SIX5kdxF8pTt7WrE9DPZOXmdTCnTAv9nWuTTzzU9bSNsz+nLsrFzqfgk66w7kSdp3varrPHkVyxaSxYZ/R7ewe589ZycNttYfjQdHJtCOifkoyB5esnbWalr4f1tT4YvqBlB4grmAqpeGP8z3uYSewjchtHfhvPCiDL9BAhZvOw3VuF3w7zp2OFDFbOeo0NAoAi4EFqIdP2qM77PzXCrx0W5XaYEQPB5aBHCdRWxJ2XreNwvSu3XYd6JDF86Hdmuphop72a54T0ldkKDVa+c3+aGd8y+OYbenNa/5CiuDkRqypXC04hDvFMKgNQ99H71WF3Ydqul7MwJc96K//tJJVlkFV/v+6guonVX6qFNMTrAgLTGnCXDJQNCnv2lSW+bNd0PNEtemdOGDgTVrl0KPLNbhMLD+HkQr5OUlcj4NrxSNBWLzEzwCZwv1du8ZcRluaVSeNDaqhgzUgPJvD7njfLQ14515RlM6k/UHiX7RLw/pIjBcZODLTQid0I4QNnC7LmWnhN2z7ahGSeVVqlVCs9FSKhvcgbCv8Lm9SLpDTqmGEwCgdtz/e+7X5ZhjdhSaWlmWU6ej0asFwuZZSQCZaAF7ECP0SUafAcp6PcGn/AUOPepCn8tjOt56uI8xzLLoZl1h3PyTFmuE6VvYbGI0sUJty/btY26eeyFdto5YHLXfvj+SOy2Gf4UxtdEKByb8IweDh5qQEy3I2Dwa305tQ+vGPIaW9FwWawx1azTGlmi2bBAonDzPVbJawpxzwgR6aRw4EIT/yMmgS2hW5JBO5qXNjOI2b7EotQ6SD9Gvv6H/Z6+cdT
 jf3s//CO
 Sre/GF3YueCDA0iVrmgvs2K8YzyY14Xum8BSWZsbk0WGPprItnfCwVChpyPIZZZqb/jlpz9/1AEJYuhLa5CyRnKM1QXD7I45uIlc8jI0jGJ9PUmIc+9xGpSqtLc+ssyHlw39RlbqU0Ou+uCUF5yINbtG969cfnFWkfva5p8lTdqvoMioSxUPf48MjhPwsrpF8LBI6dC0azVo7StCGf+6cY4nW0M9KftwL8bR/KR32jrejP0oefAd0C1hD7F9RUrAjswG4uk0SSP+anOiI6BpNyS7Xn/RosMFH6UBRH8Nd8EBsuAtTv5HKiJ36OQ==
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

Cc: stable@vger.kernel.org # 6.17+
Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface")
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Tested-by: Song Hu <husong@kylinos.cn>
Reviewed-by: Song Hu <husong@kylinos.cn>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/vmscan.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 06e103f9781e..155167b3614b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -199,6 +199,13 @@ struct scan_control {
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
@@ -239,13 +246,6 @@ static bool writeback_throttling_sane(struct scan_control *sc)
 #endif
 	return false;
 }
-
-static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
-{
-	if (sc->proactive && sc->proactive_swappiness)
-		return *sc->proactive_swappiness;
-	return mem_cgroup_swappiness(memcg);
-}
 #else
 static bool cgroup_reclaim(struct scan_control *sc)
 {
@@ -261,11 +261,6 @@ static bool writeback_throttling_sane(struct scan_control *sc)
 {
 	return true;
 }
-
-static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
-{
-	return READ_ONCE(vm_swappiness);
-}
 #endif
 
 static void set_task_reclaim_state(struct task_struct *task,
-- 
2.34.1


