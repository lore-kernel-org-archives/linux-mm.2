Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9AB3C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:18:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 855986B0111; Wed, 12 Aug 2026 08:18:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 740D66B0110; Wed, 12 Aug 2026 08:18:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51DF76B0113; Wed, 12 Aug 2026 08:18:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 27C486B0111
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:18:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9704612027A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:10 +0000 (UTC)
X-FDA: 85092519540.12.A4CB8B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id E947040004
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mOf3kSGC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786537089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JfAFNjFFahuQ/02Rkg04vR1FEvVXtWN3blDMb1aBDxU=;
	b=sEryqFPZL39Rsgt4dA8b6chnJuwP6s4XOom33rERm/ocHu2fcHp8AHnaDmMCyrav24qVCB
	QvISUHO67BJQ2mHMQB4A8jMKAEu8f8tSunI3D8gG3V6I57RIHh7tyCBCy/hHVSarfpkblX
	y0gv5K3U1XNSV7Z2nJegfFs/gRys/GI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mOf3kSGC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786537089;
	b=v/9+5H3P34aZmbXK2VxJEIOty1XO9KepQTPmeCUEsvACosKBhIEpDAk0f3YCsyrJ2A8SqD
	0yt9wRuQBZojXi7nV9Z1pG882TlIYQkSY7cKdgvOaVRuLOcLKidHOQb8SHGfQsNh/k4+BY
	1Oz0sXTz3FncmUdlx9p3NOapPzQ1H3Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1DD2A44F55;
	Wed, 12 Aug 2026 12:18:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3941F00A3F;
	Wed, 12 Aug 2026 12:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786537088;
	bh=JfAFNjFFahuQ/02Rkg04vR1FEvVXtWN3blDMb1aBDxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mOf3kSGCfSxxfdiJl7wZodylrQcmlpLnTU/EWOJ2bdq3O0M1rLSC+lwTxkhQFdree
	 FOgtXEMi1Ux59cCoHRWmf+Xv17LYSspapX612WkMbcTBYkcPhsdoiAr4YGEl98OPtI
	 hyH6RPUjS8oPpEJE3a0UGkNCjXSVNLn6/v0RgolnW8QozyqbEe3roMnuI4WcPMSXX8
	 dORxyvZXF3y0WlD5JEH59V6xfchTrVsDkOZ1mr4igXkHACBOAmSB9oqb77iS8qDM8j
	 sILeNtf+alBzo4UvQ+fpV6kfuqk/kJdb9laFKzmTPLyG2Eb+W6pP5dUSAOSg/6d4JB
	 IPuP33JgEA01w==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	Barry Song <baohua@kernel.org>
Subject: [RFC PATCH v4 01/16] mm/mglru: improve readability of isolate_folios()
Date: Wed, 12 Aug 2026 20:16:43 +0800
Message-Id: <20260812121658.69965-2-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260812121658.69965-1-baohua@kernel.org>
References: <20260812121658.69965-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: g7pgyxpq8ghpcimd9g14y7h4nnokfyb6
X-Rspamd-Queue-Id: E947040004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786537088-138956
X-HE-Meta: U2FsdGVkX18LGU1KGaEftNTPE7SfJbS0e0IRRxorP+e+nIoT1Imk0pfLt4QPEvIRkK8aRS+qyxmEWe7hY/QEQK4SbQfjcyBnLYkhSAbY4dt5mmDdtPJOth6lq+tuFnpQz8d96iQZWI/zHVdr+i6OirJva/8E8VVDqMO90AgqSvQVCJbXJ3abUIr+KVRh39rD/K4JciWauGUdYl/IfeqijCBKh0QWVLWgdUZmQvsCTy1dB/WSZgHWX9eGo0tMLmwbMQ4AMrvjUKioHuI7eJPDcJFecktP6JV03fST89NGnITOLvNPx7t4VctOa/KD1rjLXOEgED29IOvk1+JboYbydh4nIN6CVX5yuXTis88aUky0YPfCnOHD4W1fy6L/h94kZBiUdOdB+NiJ7c8DYOgnodxu5PgbrvOdI4yewzwI7x9tqkCt6BPv22cv8vDySZbO8zi3nql+i9PovsNYgiJnzftAMVKKGKGe2D0t+sE/QKWNUoOjyX3+YwVadilBcqeTYP1mJjUGG3Ncit7ZGXkSrPcF0aCKe18wLdPn2HiKI+UXFw7ua74H3aPaFTOOoMFRrdw8CYBcQa95HWcIyoG9nUvDxsnQs/OMbhk6KBR7Sc9p58AltFKxVDJvfuP/LqMSvFy7MI8BJADn5rQ7gxsbB8SAu4yfBIcP3P4hk34120sxQstqBK7H91Wn74oZHIIIwmksboWN9DE/JMrQcXb71G0EWO+hOtE2rI8EcifETWibLx9JckiIn4bqXvUfoYwz2MKJBd6+SyVPXHzZDj0gHZXkJI612BcTJhxjdU5lF53HjzXSVqC3F7uuxbzIEDnTVh5vzL3Q+udUxbjV5XOLbDG5sA7QbbuWjN7625kTnoTb4I29abtrEUj9lz8AVjj6BzaPd7W9RmKGwT16NjNNO4cjWitUnS2strITUDXoWPdyCPPo01+BESjp7cQQNmWLsN40iukEwVzbHF4Sa88
 BBeh3oqA
 e9ckL/cZ7EDz2DLOjV+AJRpMaX/hz24SW9eNWbbYbbwptGlmjhSSMTtYMTfkwMgbk2wXHDdHoElwGEULKH41ENusvzI3a3Ne/vIuyFSp7dA6lkQZpMMO6gfRGJ/w11/0k1jyzKbQa0kquKQt9ah3J239I2w8qAYMDIMKMTa5a/vVMdR6C37fjtT/hfivKp+qMOOptx3JZc59cTq3JNh2cVUTbLzU25zS/rcre3flpWuXPKwebzlxWXgz9k+xV27HlBd0DhsHa1vL6BiW9Ip+qKPklRjqdENHpSSUR7ulC+WR2p2CKn8D+gbGzE+IcKy706JM6Z69LjA+MMQPZ1Vy875ATeY/HcRJQYwaToRkUgVpHU47z7sOv5UlROFtAfUffpGcx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

The for_each_evictable_type() loop in isolate_folios()
is misleading: it does not actually iterate over each
evictable type. Instead, get_type_to_scan() selects the
type to scan, while the iterator `i` merely bounds the
number of attempts.

Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 46 ++++++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 17d2b793cbfc..ea058692b9a5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4839,35 +4839,41 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
 	return positive_ctrl_err(&sp, &pv);
 }
 
+static inline bool is_single_type_reclaim(int swappiness)
+{
+	return swappiness == MIN_SWAPPINESS ||
+	       swappiness == SWAPPINESS_ANON_ONLY;
+}
+
 static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			  struct scan_control *sc, int swappiness,
 			  struct list_head *list, int *isolated,
 			  int *isolate_type, int *isolate_scanned)
 {
-	int i;
-	int total_scanned = 0;
+	bool type_fallback_allowed = !is_single_type_reclaim(swappiness);
 	int type = get_type_to_scan(lruvec, swappiness);
+	int total_scanned = 0, scanned, tier;
 
-	for_each_evictable_type(i, swappiness) {
-		int scanned;
-		int tier = get_tier_idx(lruvec, type);
+retry:
+	tier = get_tier_idx(lruvec, type);
+	scanned = scan_folios(nr_to_scan, lruvec, sc,
+			      type, tier, list, isolated);
 
-		scanned = scan_folios(nr_to_scan, lruvec, sc,
-				      type, tier, list, isolated);
+	total_scanned += scanned;
+	if (*isolated) {
+		*isolate_type = type;
+		*isolate_scanned = scanned;
+		return total_scanned;
+	}
 
-		total_scanned += scanned;
-		if (*isolated) {
-			*isolate_type = type;
-			*isolate_scanned = scanned;
-			break;
-		}
-		/*
-		 * If scanned > 0 and isolated == 0, avoid falling back to the
-		 * other type, as this type remains sufficient. Falling back
-		 * too readily can disrupt the positive_ctrl_err() bias.
-		 */
-		if (!scanned)
-			type = !type;
+	/*
+	 * We are running out of the current reclaim type. Fall back to
+	 * the other type if allowed.
+	 */
+	if (!scanned && type_fallback_allowed) {
+		type = !type;
+		type_fallback_allowed = false;
+		goto retry;
 	}
 
 	return total_scanned;
-- 
2.34.1


