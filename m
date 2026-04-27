Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D539FF886C
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 18:07:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 722826B0096; Mon, 27 Apr 2026 14:07:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D5336B0098; Mon, 27 Apr 2026 14:07:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5049C6B0099; Mon, 27 Apr 2026 14:07:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 325826B0096
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:07:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EDCC740257
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:09 +0000 (UTC)
X-FDA: 84705117378.07.EFB620F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id C566018000D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HKaDsTsU;
	spf=pass (imf16.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777313228;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bvkEUmMDZdvRO85ErjhEVsj34z4/kxjVW7qjHg/YDuU=;
	b=66OPuF/ypDDrfJgt8/ANQLLuhrpSehYnnA1wCKkpCd7+naB61w7SVX9agVUhmnb6xkkGIN
	RpGm0A1HVXVNi966qN1s0w2DqbqRLvj8VgJZB+GXZkwaOFtuV4dqNfe1jXTYQgU0sWh1OL
	avW10/ryHn+aScMdpqUMN2U9ouSUt8E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HKaDsTsU;
	spf=pass (imf16.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777313228; a=rsa-sha256;
	cv=none;
	b=IB3/PNK4QZ3Imy52J9cBqM82vASmQ3LfIl6TWTrahYR7yK36GzOBFSh/EWSbWf2IqjzeZ4
	YpYLrjoFDthOELJOZSEHe4lmy8B6EObO08DnUiE9CysZ2JPk1XEXZdIQxrkdkCE00Uc2iz
	NPGOuLUbb8ru9Jcic5ymjFU0o2Q7JVI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CB804471F;
	Mon, 27 Apr 2026 18:07:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7EB96C2BCB4;
	Mon, 27 Apr 2026 18:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777313219;
	bh=d6Ta1iP5mPFPkgxiD9u25lIVE7V40hNv4qpb8cszj/E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=HKaDsTsUBY+o3SmG696k6yt9SglM1TGcIBuBtoGo5xVCIr9tMIWzG81Ev4aGECdab
	 pa4NU441zXdVQiwkoStsmNTuytCgXCCmmMTvNUp7Zimc9M6SxcJhnM5s/pO08hOEZe
	 MPOeHovesJGpuCNs9VzkgN5XFYlQrQm9DJY3NTjS/CmKh1KthXM68BioqyGbQ2dFp8
	 RIixHhnJtNvEu1HTmXWsoMU5+V0QdkuuvHB3LK2AFi7n7CJWNWp2EOxzAqHAK4iY0I
	 3MWeH92H4ssy/mdS/SP2ux4AwfQvSHd2ThAIrvscwno70i6TEubphZdwLeesBREb6l
	 kP8WPrK2ulF1A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E6BFF8868;
	Mon, 27 Apr 2026 18:06:59 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 28 Apr 2026 02:06:52 +0800
Subject: [PATCH v7 01/15] mm/mglru: consolidate common code for retrieving
 evictable size
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-mglru-reclaim-v7-1-02fabb92dc43@tencent.com>
References: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
In-Reply-To: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Kairui Song <kasong@tencent.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 David Stevens <stevensd@google.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Kalesh Singh <kaleshsingh@google.com>, 
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Qi Zheng <qi.zheng@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777313217; l=3107;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=Y3kkkb3C3sOmTNRwB81JWRKI8V4j68zDrNpkhlE+boo=;
 b=0CL/lEP4LfHtocAYd24RRpXvBtZg+qnGZk3sapZjnVvC/jbObXoa8fpMb8U4ycnX0017WnoJl
 8+JVaUBlFe4DX35z+D/F4kUuqs3ratkMEnO/emJ6E4lGATKi+qpT3GL
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C566018000D
X-Stat-Signature: 8mxkhyw1rm9985kku9scc1frbk31ztxf
X-HE-Tag: 1777313227-876667
X-HE-Meta: U2FsdGVkX192B2JCsqR9zOcDxHofCTp3aHUib9Gene+pfnEM4gr0WYS0biPvlz9CNmPVmYZZlzn+knJuEOwnycfkrhjiFc5qdWNEKgSfeEe+QtojIuQ6ZQelX71ojydpE+qjHkbaLn8Pg+ZO4YswHHuKbfnlpQ5bWpWP0jZOY3sM0OB/lHOIY/ISAPXrytnxqt4wwsSGkLTpyrDcLdXsbdqDVbGv0KxhfgKUz2iwAcK66cZYc9qNzipIkrTWRDFZ3wUFtNRTaIyWc7ZZMJuDoQYEQfP52lnkduAUqihqQUGMx35Rb1lMgXpFPGsrDa9C6o+gwg75P+KCSfCn0isJYcBPNoRvrSFGRS0JJ82d24nx0EA/uI9gjUkDxnjY5tFKqlxR6M2bfbbfu8fkxSSX5I3c4R8EqQChCf3T7I/BiqRK7/ALPPxATf6MmB4cFUH3/nRhGDzckiOH1/I8Swmhm66KLCzpLQXd811EddsSGMoztrJLQKUMHPnyi3s7ZmR6W5NNlXfkJcnZkefjVzc64PCtR+RlcJSZ7CnJBm2yWmrBxX0hvWXOMUPMa9eNTwIJwe0KQyvBs3GGU+Vttf07AYMoSUiOjjhgPfpMe/O8kpOxsacX0nh31AzDimtyIlRbaZD8F5uDz9i68TXEd04tPKDV6wR3pxn4IdhAxZzAj4RUdlV9j92WcH7dU3numBaIsWSrgvHve3XsZXfQaDL1Hjxj40sZfTzbF5hK+kVGubmv2/lKbVJ0CUT8nWRSvAHctiYoAHAnKvxcj/HY3S+4FX1J9kKoT5KWqMBkuXjjMwgdPY55KvAzNV3DPwpYnE334kXkwQ1JWX0nKQBOv4enhDcqt4IlI1v7peiUcq273AkVeVbpi53yUNV+JhQS3laosgBdJzpfoG8zZS1gFKKVFsBP4k7h2ifQugnzAVv7RcbMdq1gQ3t4Sdf5PupCbTEuR3UCa4jSROwi4/lWObn
 8T3HQEk7
 dZObOraCRqaYsLbywgYxEV35xTi1XNdsUz2G2Q/PLqWSBNFWrxAcxXZI2KMkO1WU+3WlK/6D8sWcBFeET0x0skihAJr4Svh/tOQ+mpH9K0tHLkCh4hkXYZKUsjPscqrDQOFvzSUisE4OCC6iNN75WLyFmInQvtai9YIF4n53CgSzmNDPIw1vnjtBwzf7F7RTS0JAg2Nnw+QGLLIdth81xr4F5opex45AVig162U7cgrQuiudEBXjZS3OuLsX6ZQkTIhFdJOntBKZYad3QtQtOq+k9r2EkhlWiQ8V4wODBN/Wh5HWCL3hyDINjqGcskYAKcB1QhpQo1ZIVuoWc+N9wv+nl1M3tOcqjqsxsumridV5Ej0A8UVVgn4Ps++sIoKeQIYK72UK9xtFggj79a0Lj0s4+YOwuccI5ri3GhU0L11SYqa92tSLoOT7S9p/2ekAtZC5qVl+qZgG1glsTU0JBvHZfgByDvycXlU9pVr5GqdEv4mrPshOUJiAI8mdFxl3Y0Mm6NSaKAOikMl2onukOdIfhaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Merge commonly used code for counting evictable folios in a lruvec.

No behavior change.

Acked-by: Yuanchu Xie <yuanchu@google.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 36 ++++++++++++++----------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index b2d89ed69d22..b80fbc4fc285 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4084,27 +4084,33 @@ static void set_initial_priority(struct pglist_data *pgdat, struct scan_control
 	sc->priority = clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
 }
 
-static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
+static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int swappiness)
 {
 	int gen, type, zone;
-	unsigned long total = 0;
-	int swappiness = get_swappiness(lruvec, sc);
+	unsigned long seq, total = 0;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
-	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
 	for_each_evictable_type(type, swappiness) {
-		unsigned long seq;
-
 		for (seq = min_seq[type]; seq <= max_seq; seq++) {
 			gen = lru_gen_from_seq(seq);
-
 			for (zone = 0; zone < MAX_NR_ZONES; zone++)
 				total += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
 		}
 	}
 
+	return total;
+}
+
+static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
+{
+	unsigned long total;
+	int swappiness = get_swappiness(lruvec, sc);
+	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+
+	total = lruvec_evictable_size(lruvec, swappiness);
+
 	/* whether the size is big enough to be helpful */
 	return mem_cgroup_online(memcg) ? (total >> sc->priority) : total;
 }
@@ -4909,9 +4915,6 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 			     int swappiness, unsigned long *nr_to_scan)
 {
-	int gen, type, zone;
-	unsigned long size = 0;
-	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	DEFINE_MIN_SEQ(lruvec);
 
 	*nr_to_scan = 0;
@@ -4919,18 +4922,7 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
 		return true;
 
-	for_each_evictable_type(type, swappiness) {
-		unsigned long seq;
-
-		for (seq = min_seq[type]; seq <= max_seq; seq++) {
-			gen = lru_gen_from_seq(seq);
-
-			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
-		}
-	}
-
-	*nr_to_scan = size;
+	*nr_to_scan = lruvec_evictable_size(lruvec, swappiness);
 	/* better to run aging even though eviction is still possible */
 	return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq;
 }

-- 
2.54.0



