Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02C46CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 23:20:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F5748E000B; Mon, 10 Nov 2025 18:20:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CCD18E0003; Mon, 10 Nov 2025 18:20:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E32E8E000B; Mon, 10 Nov 2025 18:20:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D8178E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 18:20:36 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CDA311602D8
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 23:20:35 +0000 (UTC)
X-FDA: 84096268830.23.BCC98DF
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2A72640007
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 23:20:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BgAStWnG;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762816834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9otsU5sTTsv5iDT1hLkwZC6VR8+kvlYsVUkWcUV3yUw=;
	b=EIfEGib5CdrnI77YKjTFTT2qIZ1EuGQjM16NEdtqPRXiF7uHl3oWDOY2YCCKiTkZikVI43
	W0F4Ntc6U17mLQ3rxQY3VtRDVtz7Sn61bdVhF0BbJEIGQJ4tRZunAaMg4Fo2GxjeBxfeqo
	K2og0F0V8tDF8NnPA0iE3FM0pCfJlH4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762816834; a=rsa-sha256;
	cv=none;
	b=5uqwQDBjygLb6B6nVR24DRj4Lyuu8hQ09CIv3siAAqzUpJNd7i9cYRrXdr9LFGwYeyO+E2
	UAcJOfY0XILOdnrejob7tLDsI4Qc+ER+rjiUh3i1kKR+ZLAAjoUW/Pl4ctLl6/2C66dgHZ
	lDUMMFj7EbhF5NyZklOSN74OkxuXYv8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BgAStWnG;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762816831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9otsU5sTTsv5iDT1hLkwZC6VR8+kvlYsVUkWcUV3yUw=;
	b=BgAStWnGWu+R++HQPUGOOHPlqRzdxWNJ0t59sVFAJf0Bbvv09PqCZGD04X5NPEYjczxOVu
	jskKx8vaHfikcuEhDCvFDPEaIM+ICUbyL8lklWpFjP8EoEknW3w+mRhSTi2/WREjj1BfDY
	LLQmumQ5TKsmYPQqq7ZVuNy/GmrDuvk=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: [PATCH 1/4] memcg: use mod_node_page_state to update stats
Date: Mon, 10 Nov 2025 15:20:05 -0800
Message-ID: <20251110232008.1352063-2-shakeel.butt@linux.dev>
In-Reply-To: <20251110232008.1352063-1-shakeel.butt@linux.dev>
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2A72640007
X-Stat-Signature: xwryu9wu8jsw1zdtc4eusaf3kma1dqc6
X-Rspam-User: 
X-HE-Tag: 1762816833-39782
X-HE-Meta: U2FsdGVkX1/BAzu0wEziQKAZ0YoGGRco4X0TC9yE1/27KCs7Qh7ldVVskzuJrQ1LXLQU5MID0wPZ8EdkdwugJX3ZWRXLU/BOEWVy/xxbQ83Pn8WDwCDTols3wYbTlKybzKgjza4AxYeaUKHAZQbFoGcCDI+OzowZjerhPbdC6pjwTE67uVkP9jV1EWcZRUeLENfha/QQE8ydSGyQiUQpSxlEFZyYIsGSK1xN77GrIyx9dLiXIgzR17RP+lEBOYvZoSxuRP+xr40H3TSUR2tZnhzUvy+FweKiKeDiTCtty6lcuxuZmbZqQMObZREiKV5gJtswmmbzOCu1WuyI9d8Gyzt9JDTMf//cSNyBNrqY0HPzEwwpidbI76ptQacidLMFPoxr7QnDtD9dl6iCTGFdwSkJP6zphqZOOggYX4dJyorjmGfs19TVCdhLGDRvtN+3Rku8MjguN/1wygR8GZOHIIgPw+VfWmGxuLYflURWOGrth+op9KFWIH5v8Ik/5K7k7hBUDGP92HAC0Xec2F7vZXhmHUAbRBRVLbsUV3V+PnLNdvkEXKyBPyu4p+LYJh/r8R18jwe50v54D5Fa9QqUpg96FqUs2qGI+ZmSCkxDKKCTpkHh4y1bpFXJUzKbCr1Jaz5oxKvKGQ4TrbPWTp3BZsZJlwxhrDHVFR8+cbrREaWzTCVcTrIxYHUuDR59z1ky4P8ZLHbpmZ6HUyC/CtMlEtqq2sOZkBNqYqN3kIVA1CJp2Nciq+bJbq9ra3245jeQ2Q2oeYwsK4qnJQFfBLgHB2tStjsAX8cMC+dr/eYtqFG6D38qUpj8YpuV5Cc/hlRrYsCKQBXtZGKw99fzEmaF54VgZS+w5OjUVftXQpvquHHb9zx7+tOKWP6MWCa8dp/hl5nnyELroLkRv22Wo+xmxL1CB1qOZpN5D0nsHD/RtLDsDAycGV/KfOEQov9YVaQ+pVTTujYcmFbADiTGJT7
 VdGY2QAA
 YR9YJ1l/bhtRyEAQW0dbesKA55wkS3UUA07qFUgrNS4quqf/RQPGIbXOsB/UGW/HKtjT10FdV44BBjNDR3loHP7/y1w7DSUmaic6N2je62x432uOJD4s0coVbFsSAiEFTYV6iJ8TtA4fZK6ntpy/xjHq+oCga+DtG+SmxrbUF30/2UNffdFpAZPlZPbbquv7e84Jjv3HFp6YMfP0C+JZJI6fEsvLnvJ6ye4XYKnhXYirTnhuHeH2l6POlyUjBNKxYcIzo3wkVGuSlXkrzXOwybiZVww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memcg stats are safe against irq (and nmi) context and thus does not
require disabling irqs. However some code paths for memcg stats also
update the node level stats and use irq unsafe interface and thus
require the users to disable irqs. However node level stats, on
architectures with HAVE_CMPXCHG_LOCAL (all major ones), has interface
which does not require irq disabling. Let's move memcg stats code to
start using that interface for node level stats.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 2 +-
 include/linux/vmstat.h     | 4 ++--
 mm/memcontrol.c            | 6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 8c0f15e5978f..f82fac2fd988 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1408,7 +1408,7 @@ static inline void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx,
 {
 	struct page *page = virt_to_head_page(p);
 
-	__mod_node_page_state(page_pgdat(page), idx, val);
+	mod_node_page_state(page_pgdat(page), idx, val);
 }
 
 static inline void mod_lruvec_kmem_state(void *p, enum node_stat_item idx,
diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index c287998908bf..11a37aaa4dd9 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -557,7 +557,7 @@ static inline void mod_lruvec_page_state(struct page *page,
 static inline void __mod_lruvec_state(struct lruvec *lruvec,
 				      enum node_stat_item idx, int val)
 {
-	__mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
+	mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
 }
 
 static inline void mod_lruvec_state(struct lruvec *lruvec,
@@ -569,7 +569,7 @@ static inline void mod_lruvec_state(struct lruvec *lruvec,
 static inline void __lruvec_stat_mod_folio(struct folio *folio,
 					 enum node_stat_item idx, int val)
 {
-	__mod_node_page_state(folio_pgdat(folio), idx, val);
+	mod_node_page_state(folio_pgdat(folio), idx, val);
 }
 
 static inline void lruvec_stat_mod_folio(struct folio *folio,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 025da46d9959..f4b8a6414ed3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -770,7 +770,7 @@ void __mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			int val)
 {
 	/* Update node */
-	__mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
+	mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
 
 	/* Update memcg and lruvec */
 	if (!mem_cgroup_disabled())
@@ -789,7 +789,7 @@ void __lruvec_stat_mod_folio(struct folio *folio, enum node_stat_item idx,
 	/* Untracked pages have no memcg, no lruvec. Update only the node */
 	if (!memcg) {
 		rcu_read_unlock();
-		__mod_node_page_state(pgdat, idx, val);
+		mod_node_page_state(pgdat, idx, val);
 		return;
 	}
 
@@ -815,7 +815,7 @@ void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
 	 * vmstats to keep it correct for the root memcg.
 	 */
 	if (!memcg) {
-		__mod_node_page_state(pgdat, idx, val);
+		mod_node_page_state(pgdat, idx, val);
 	} else {
 		lruvec = mem_cgroup_lruvec(memcg, pgdat);
 		__mod_lruvec_state(lruvec, idx, val);
-- 
2.47.3


