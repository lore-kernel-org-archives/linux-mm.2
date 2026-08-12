Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AED21C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:19:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 546906B011C; Wed, 12 Aug 2026 08:18:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CFBD6B011E; Wed, 12 Aug 2026 08:18:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 370DE6B011F; Wed, 12 Aug 2026 08:18:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 161836B011C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:18:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ACB06A274D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:54 +0000 (UTC)
X-FDA: 85092521388.15.3F08B8E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1025A160009
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WoXwSgKa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786537133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1NLPR+0L7qhjEJJeaSxotIiJRVW8SFQExxb6Lq3NwJc=;
	b=zP5uCR+IwwYRYdxROFjga+oE3NfEag5qnZDSp9GHyXF998SaBVtZGWqnaIWD9uvTu4uQX7
	yholq57CWy/u9LxSm15p7JljEvfm4IgNqEKeSJH1ksnQeRmQ1by/Zp4jHVxa04r5I7WQTB
	PcbjhD7cKwMRF4n5EDzfG9xunGzseYQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WoXwSgKa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786537133;
	b=PL2Wos+sNDaJKg7XXAQ/kYsGu3Z5xTMHJB4ZxDKgk3Hyp+m/eJNTtTSVK/8h/H218CNxRS
	zVENNERppXmzAFsSpEm0NL4ry9jw8DMKXo1+iXuubUpaHhfHlD8A1iunwZhmSjfQoOsR3J
	gtG8Mk3hqKpnxe198HvsWCQa2EF/LKg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 60A454173F;
	Wed, 12 Aug 2026 12:18:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E58E1F00A3A;
	Wed, 12 Aug 2026 12:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786537132;
	bh=1NLPR+0L7qhjEJJeaSxotIiJRVW8SFQExxb6Lq3NwJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WoXwSgKa0CZv7qDgc1Ukq/vS07Gm7Y1XZ0lvRuWfv9ssh6JlfQt+0bAcsRK7khMp/
	 lpiVJn224v8r5LLmDuDF1H6BGMeTOoiq580CTgK8JOeMhG41g6/VBdYEdYixFNt69X
	 Zho0YLfwVt82Ud/8dbQKGFJkj1yTRmfLvNjenz2oAvRENz1/mSyoegkKDv/lP0effl
	 undfLVTkDZ4HX/EGIUwDlQRAzGDrdwKRnkFlc42GzS7PUq76FCmgUffzifhPgsGUo3
	 +oM8D+PbsmNuOXYCBfKaRiFTQdqeu81YA3aU+qGVPPAi344fSqOAxm2AttTeOghPew
	 wA8qvUI/dyf6Q==
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
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v4 12/16] mm/mglru: run aging if the preferred type has no reclaimable gens
Date: Wed, 12 Aug 2026 20:16:54 +0800
Message-Id: <20260812121658.69965-13-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260812121658.69965-1-baohua@kernel.org>
References: <20260812121658.69965-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: e6b6sfyipjpyrqo4gmw3ew1z8tquuwcs
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1025A160009
X-HE-Tag: 1786537132-98674
X-HE-Meta: U2FsdGVkX18+Q4lOaEX9H7EXpYEiTU9txtc7hurDCeM17uWdokv7/yiVAAqB2ugN0HWYu9CBJxKfAM3NekTP4TV1a3cUAJVb8l6nokiYVl49IzERePNLPDSLEgo7ct/5LtbDz1fboWbgQt5fEIzcIYh2FnjUzS08g7H2hEQijhfTSmh5kmeEJpttl95w1TSYfMFewB1vODTrmW24tDWLPOfN2Ix+t9XzkjR5rCHh+oUkpCKAeyjeaaA47t1om55WzMTWIQA1rdetlFW3EeW9pzJAQw2JAqrFIF+XZIzS7gZQzTjwuE7csOPTSEDxNDUu7UhI4G74ASFlVJO2Hacn4DVUbVqpG37rLzjSFAdzC9ilGo0FBDRI0ShG6BFr5EQIHQXXkWf52+/6r54bBX3YgOPfEP9rvyToTm6KiOgAxex3kKYWz0qigxNfg34RfHk/GRyk1NqSRXg6nnZfr2UJpJ5hWbi4hL09kkNEzeT9no8Wj5lqX3umNhtFoGzpOQTrLoV89MpQqXaTCwwji5WvFTL9C2WgCRCjXo9qvQEyYG+Lv/MAv8bYGduHd6lE89YtvSp+/wpxXHGKXaMNnGkNA8/rP85AL+12nSnz4t8ICWj7icmfiSYGmlieKPf4t5pGe9hgxlawDczwH5cqQ8O9tn65g+nN+EEG1D0zMFlJvCbnxDvtLjHyxrWbBn3yvkbbM4uy/Wdx4QlIUj+gu1G+T4LYuA3jrXVA/tw7cyue1hcs7hN1fF9iuPcNA7HRrNWQPknXlsHVlNtavzjGTuIumzCqLtYx/BIdbcEVU36N5Mx7Qmo5pJuZ5UZzXCUrt/CAcoSpIavGz/moFQLrSVhH1NM9IWLHSD+H6pyRWqCBzC1N/NRi2FH/KRN1SVfeA++VQJet2+zNila7diwizdZkkIavI6WayYrY0NNuyI9AVdPhOdqbF29mtubgFyOj7n5Wam6vR02Nc3HDYkFKTcn
 2M/hXWaf
 hqFhSf0Ad3Q9slvP5uFY1ZHDtXllfVkQ4ONTWRzzIfhcvHsD66Mwt8bbeF4PMbYYKHoAcT5k0HIg6saqfD68Vz6wo08tT8vRs4/3SEhqcV2S6LaZWq5k1WSOxfKabnQayY7MuqjW9/wehpI9IynhozpbiHU/BtzEJaQPyHMIGwyYCsYDx4AVibp3wzQP2NIJQk+AnQenthYOnhXMUHywPq6NzdqcEATQoLRktSGmkh6wykz9DLzRt3MgjxjN7lEW7RvBmxpsxOwy5oZHtt5J/BpeeTWWa/MfxIOWf78HeaVfAa+8S+3GOwH1k5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Respect the type selected by get_type_to_scan(). If there are no
reclaimable gens left for that type, run aging.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 48a068b50678..50f0bcf9576c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5095,12 +5095,17 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 			     struct scan_control *sc, int swappiness)
 {
+	int type = get_type_to_scan(lruvec, swappiness);
 	DEFINE_MIN_SEQ(lruvec);
 
 	/* have to run aging, since eviction is not possible anymore */
 	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
 		return true;
 
+	/* run aging if the preferred type is exhausted */
+	if (min_seq[type] + MIN_NR_GENS > max_seq)
+		return true;
+
 	/*
 	 * Try to avoid aging by doing gentle reclaim at the default
 	 * priority. Skip gentle reclaim for extreme swappiness.
-- 
2.34.1


