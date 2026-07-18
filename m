Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B6D2C4451B
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 09:54:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36D1F6B0095; Sat, 18 Jul 2026 05:54:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 344206B0098; Sat, 18 Jul 2026 05:54:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 281096B00A0; Sat, 18 Jul 2026 05:54:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F15356B0095
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 05:54:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5F164C035D
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 09:54:29 +0000 (UTC)
X-FDA: 85001437458.28.9DD592E
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf31.hostedemail.com (Postfix) with ESMTP id AF2A320002
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 09:54:27 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SWJHGvIJ;
	spf=pass (imf31.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784368467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jfS0xqNab+cGTBtcs71EybfPlueNPDuy0c1ubwCt214=;
	b=S5PC5kjtj6R5aHiMd1Y5C0tb4K92pqGHlong/wN5pb0Y7aylzNpRb087yQhKHnUYKfUSwL
	Gdlnt4jjWr9TidG1TQ1EmTcsyQbwhfWoS2eToFuSCIBd5vd0eeo7AL5J4h/NHd5CKmyIpM
	IPNH4IlcmIsSXIOA5OTWc0gLdBCEQOw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SWJHGvIJ;
	spf=pass (imf31.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784368467;
	b=8UY12upJAeSPFisXsF0ziNmmmp3AbA5ryI+AR1kUB1nFeric8QlMf8lqbWAkWbrvkGiCB+
	Yc4nYzW1w69br7qiEqLTVubVcT+mC066syFpu+FV/cacsLc1ktkm/QiE4wqsmyHTc0oc1H
	NWwJsyrY3bbck+wI84weH7c7pUN7TTw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784368466;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jfS0xqNab+cGTBtcs71EybfPlueNPDuy0c1ubwCt214=;
	b=SWJHGvIJ9H9I0bqGkmj23ibjJvqGqlNWOEBHhA4KnGBBPZvA3QtZ8Nz1wb1lGiPDUJkbfH
	36CyERNXQ6ER0t4rfRLfvQXJNonVLbbMSICCymcfge+4PV2bJOjAh1c/UYcvxOrKo4GXkA
	uF/gu3WcHWS+QWfbjXJmFmK9+ZMHyjI=
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
Subject: [PATCH v2 3/4] mm: vmscan: drop unused gfp_mask parameter from __node_reclaim()
Date: Sat, 18 Jul 2026 17:52:50 +0800
Message-ID: <20260718095251.82937-4-ridong.chen@linux.dev>
In-Reply-To: <20260718095251.82937-1-ridong.chen@linux.dev>
References: <20260718095251.82937-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AF2A320002
X-Stat-Signature: 6d693o885rknccn9h49wsrmwbu3jfqcs
X-HE-Tag: 1784368467-840561
X-HE-Meta: U2FsdGVkX18GYJv4V1KqnEADq2r0JzXth4ab0cIVZuGuMSeVR0tT5le1jfSoW806mzSMEbLA93jr0gqSjIanU6/q8Y0+MU3OU5DRI2Aly/LZ3tuedc1PdHk4meW4Haogsp/q9W8SDRWoseTL8Fl4LHwM8r7UJO6OOYaZuDECWoeTG1mOJqSd5FkPkAknIDK35BSbIauhkt64LUB4j6MZpXUE2+lHrJ6HD8kePTHgGYyGN0C+GqGF9J/PUS9yuIDkgDl4nmeJn8/DLc8QDMEr2Q2KkbWG14LSmcpoyoaGVmPB7pCyjPtd0i4nVSFyvhNPa/2syBZ5HMLL9OAuRlmWKyrdV58UhnOEprcBFRLl67ZHua0gZGrFE5rtHeqoPIbw6I3DrmkSh2uQTRjavKKNjW316IJ1/qmFDPjKLr8blMt/cNQN4EyXcBjq5xUiXDxkmruVxnf0nTTeasqQudYn4sfeQwYwB1l/0wUhPDOn4OBmuzvS5T12Lp+yvnAHSSmjw4OMJx9x2AfzFmnKkUvhF4iWxw3zjXxb1Lb+ZmBHej9nVWDIjzqnPvKCgPhhiJLWc1d+fTKG/6GGH6mjmtCH6y9oSCmb7OdrsAjnqeVa7VhWO800dkneWP2Qg8iSJBJGblEx+A4/+xfJX3UQlHVS8fwssHEyZ5fIWzqEqW1Dh/IFJvTqlMniwy3ULQaHe5J7edbvdN1LfY9Tp4rhTQnLnx3067vmdvWkvFyCmEz8fMJbh779u0ScCe/DapC+6btsnOMN/qcf8D/mqqxtpi8O/CP8GV+Fvz6l2fb5hS7LzYmFzOOutjUsvshIk+E0sDheC5kg6xV46YiPWWD20Ignltos0vHE3JS6E1ARoxBIfIijdrNL68wr4jEO5ku8NjVBI5ame+/LrSON/kmDa6kd8u4kXV4Fh6yt8zQtTbdrch9eqShxjXBCkgtd9T1Fe4X1YjOPiys75PNPZGwH7rD
 yrc7Z5/k
 drlgXBHfH97+dyhUHcRj1BO/m8L8O58/9kq4F9qa9ACFwPr/mlcfAoeBqpR7em65NPXeD9qomVFf//y4Ks/Dr6EZTphEVYbaiLGLu9+1qMPcXxWydm2KCvIiMlQDTiXUrtq6yS9thKkiIQEkjWC4+V/zmbDl7JLLnS8kQQPMl2xPtL1Hm4yQ3zp85xjLaY7vx7eFxzBFLQNX2X4U/4SnNfwFXh3YmwhN+5fLAHuRU7MTfhfrup+mGKwTx1SyjpoXEoEpTfhL3f/4LwKDLoMEKXuCg0F95v1CdRlU5vdfesuYAuoj85FZOVv61W7mLdeww3vMTvXTQtbE0uPE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

Commit 57972c78e678 ("mm/vmscan: make __node_reclaim() more generic")
moved the scan_control construction out to the callers and passed the
struct in by pointer.  After that change every use of the gfp mask inside
__node_reclaim() goes through sc->gfp_mask, leaving the gfp_mask parameter
unused. Just remove the dead parameter and update the callers accordingly.
No functional change.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/vmscan.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index cfe4556c96d7..e1ef6350a300 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7742,7 +7742,7 @@ static unsigned long node_pagecache_reclaimable(struct pglist_data *pgdat)
 /*
  * Try to free up some pages from this node through reclaim.
  */
-static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
+static unsigned long __node_reclaim(struct pglist_data *pgdat,
 				    unsigned long nr_pages,
 				    struct scan_control *sc)
 {
@@ -7834,7 +7834,7 @@ int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
 	if (test_and_set_bit_lock(PGDAT_RECLAIM_LOCKED, &pgdat->flags))
 		return NODE_RECLAIM_NOSCAN;
 
-	ret = __node_reclaim(pgdat, gfp_mask, nr_pages, &sc) >= nr_pages;
+	ret = __node_reclaim(pgdat, nr_pages, &sc) >= nr_pages;
 	clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
 
 	if (ret)
@@ -7847,7 +7847,7 @@ int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
 
 #else
 
-static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
+static unsigned long __node_reclaim(struct pglist_data *pgdat,
 				    unsigned long nr_pages,
 				    struct scan_control *sc)
 {
@@ -7949,8 +7949,7 @@ int user_proactive_reclaim(char *buf,
 						  &pgdat->flags))
 				return -EBUSY;
 
-			reclaimed = __node_reclaim(pgdat, gfp_mask,
-						   batch_size, &sc);
+			reclaimed = __node_reclaim(pgdat, batch_size, &sc);
 			clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
 		}
 
-- 
2.43.0


