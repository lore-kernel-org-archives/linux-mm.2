Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 000A9FDEE38
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 17:43:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 835F06B0092; Thu, 23 Apr 2026 13:43:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 808136B0095; Thu, 23 Apr 2026 13:43:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 547556B0093; Thu, 23 Apr 2026 13:43:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1FD256B008C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:43:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A18531203CA
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:43:34 +0000 (UTC)
X-FDA: 84690542748.01.EA902B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9A32280008
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:43:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HVU5G1Fj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776966212;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TFULY7N4pHSP2NM7WJdpVxC/pFtps+9a6ctWuxFtZWQ=;
	b=uYyI4bvThrNhn14e4O4K9GG0atEMmL3gjVaUVphs0ZOzS3i91+m1prALCuwPkKQI4UcErA
	JoXlmhubjTdSJFAc49tKzsSit6DjylYARYdWs/vOnqzUKSUmlFUYQSCO4Up6EPfjX8MIrL
	ceyXkyMlud2w7i0U9xRrybfY4vjV6Ok=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HVU5G1Fj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776966212; a=rsa-sha256;
	cv=none;
	b=AfucbYGu1PNdzvGP5VViFgepMlVjNzuWNR+RF2+AtquuGO4tfYKcSritewnZQPIKvVu7QJ
	p1jZVU9xM94pZmk8F4h+UdqxvfNi9KBtbsnrtbF2nFPrFqy5d0hTiGQgos7Jd9TIqRyjT4
	+odc2zGCytUu46/r+7pYj6Nu9DSmrEs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E94B460580;
	Thu, 23 Apr 2026 17:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62F3AC2BCB2;
	Thu, 23 Apr 2026 17:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776966211;
	bh=I+nZc6FENlgDXRaKA1s8ECHyHfSCusr8kA1PV9U5nyA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=HVU5G1FjHQ7WQQXHi28KRd2hjAm2fGMApO3R1907IY3Rvn5NXQpYS3Vtw87RLynM5
	 GvmXItPEvY7Bl74aVU3d1MxtqnqD7kWAwG2eSpaoejiJMT8/J5ADRNGZySOLg/PPyS
	 Y9dQGUp771B7Pe5aXISCWGIN1EfdxDXxyQcs9+0J0YjFnW8pR4j4c6oJYAikMPyeR2
	 5FV84d3kP6l0MbwD3nBwLRA4++0278lYdOS+P7+5M+A9Mdr9KmbqQjtUDER3OdDM6g
	 q2Vqkp5M0r7ayBoh0qV7t6lzBB/d82VYrzY6RNrCKvt7BV9ivY3nCduxn6Sw8Zbx39
	 M4YRMJxHrLyKw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 500FBFDEE31;
	Thu, 23 Apr 2026 17:43:31 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 24 Apr 2026 01:43:12 +0800
Subject: [PATCH v6 01/14] mm/mglru: consolidate common code for retrieving
 evictable size
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260424-mglru-reclaim-v6-1-a57622d770c3@tencent.com>
References: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
In-Reply-To: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
 Qi Zheng <qi.zheng@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776966208; l=3107;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=PvtqUSXOGCmiDyuBIhr9LBG6XYEzabfX8jVER+0UmH4=;
 b=30tb+xsrVdGTBZHX4gMVbjbmH8HzJBlBdXFBfVPne3n2lvFLEVbZ1JfdSDM0FQi/QgHP11t6r
 BKgv56O46jPA0HTAJFW47JI5PjHJ3dwJD10xxaRMGdPB2QEfs1gu+tb
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9A32280008
X-Stat-Signature: y9fudi3rj8aj15whhohrtr7n8coeneqm
X-Rspam-User: 
X-HE-Tag: 1776966212-733420
X-HE-Meta: U2FsdGVkX1+fSuXHmqQmh/MDxwZAoWrJKwm8/vnfQ9Crl0CUZIjlv2n8eUT7PTUUV8DnvAGPJ4uiVdp/F/fYE7QYSiVwTSRjBZdh1XA7JhKet9/vgu3JNZByJRyDGZmPaQ7xYse4kFdi5Q4hgQ/0fq7CDgl2uHkNcyleCPvxS2K6242Zkd/nVjWqWI+8FOBHtCFpyrvOf3hReY7G7Fy8otpjXAb0zw4v721jmOBPmRIi5dZByla3P76+oBEj7rQmEyfqUua1DdFtID/tfufSy/EPNy6i99OTJWZsInhtkBE9zTU14ZDQGFB4C8SYjjDIStlIX89UAIaL7J051vkelZqxokhYIlorBcU2H9++b6CLsrBSRQ7b1ci4nEeZW6BTaxqAOKmO6le5/vRnZZm+1RUiBRWeIuRoBmbpn/9euL3KXTgd6kgJHyX5TVDLX7eYfWGYW/xLd1Wurto8e3RGYBcw3f2l9q/NsrjI0YUobzpe5ISzoXyuGklDcH1tdDqDP4WG/vUClFgGRvtOqdi+EXkEFZ+Fk8dETm9lcFsANwum+oftysUu4vshlrDm5EPpRLyAcvUsK99l8CnprWizkAHNmN8wyz/+0tbFsp5PDQlWZ3wUJZvOhpMNjSnH72kKILgP+pdGjguAkqbOUP+t2x2pQkbnvI7iMFem+60IUhhbfVneSCTzauOTq+TAk8dpGgvcoaHbM4cFtNnWW8u04Qci/Fa28wkaV+2wEsRhW5XmKrjRjeTChupnGAjAiCb+7DysdWuVdaUnDOiG0tS7k1WnwFd8PfE3MoirzWRoGuh6lEKGVTdGYHhvfiCUotpd5I9t7hBlV9FyGyQN748rkEiPZbG95sByRDJ3ZVvk2gtvS1ZfF1IdSEFXtZBH2hcKG8IOoZz7LzmIwUbKuX4+TW3T/OIOk/9Fz0JU7D2VOdIiDlav4oWLh6lAzyPjSM6ZoWFqg56bbTcwW11VWXa
 VZm4rTk5
 OYhVDZR4oVvmuqu05/cxa9sqg95y11zU4NZbMqwZT8fg8ZOggTHc+WJyI0z7l/lHpkFy4ZvLNRJVfpa1sfi3F+cqHy70jeyT+z/MXqNLJKrumRzb6PdseW5R9y+c1UG8P5dG2C1BPerqXAn2Z3+dg+FnVz3ikpbhrFE8phoLD6zX82Yk7vs5H4hRvk61XA9sfwKFalyyf6ABQ+BXGbABdtn4KPOxq3Fi9U4i6oFarb4KEaXMdSPkLXcUXLsoGqXq4synfJKcqJA8V8TwFB6VX022c9D0cLUgaqw92HakTfRIVP0dK1BHdTRWwNZ4xYwk67ntFhcx0NZH3+LrwSY1y7Z1HLcFvErwZQzFDHbQhAV79OP0cN0quO823EC/QtfZsD+vUEzkEAx0uSq7p9gKHTTXXMcdbZplFkWlX6ezT3RmXBTu8zwxfWK9dxlWFBHAbUgC+dR1q/9zedm8g2ru9h3RiqhfHYuNLtstELTTGuvQNLbAzPJ3pRCha/ZhP/mg228d4hjL2ROTUbjivMCagy0OAaA==
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
index bd1b1aa12581..6fa828c7c19d 100644
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



