Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC21DEA3F04
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 05:47:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F07866B0005; Tue, 10 Feb 2026 00:47:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB4FB6B0088; Tue, 10 Feb 2026 00:47:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC0D66B0089; Tue, 10 Feb 2026 00:47:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CCAA26B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 00:47:13 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C2D71A03A6
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 05:47:13 +0000 (UTC)
X-FDA: 84427463946.01.2101FCE
Received: from SHSQR01.spreadtrum.com (unknown [222.66.158.135])
	by imf03.hostedemail.com (Postfix) with ESMTP id D66E820007
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 05:47:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=gfO9m+pc;
	spf=pass (imf03.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770702430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=WXTUlQnumUaygJxbhSnJT0+rlcSCmcEIeUJIsJDTIrY=;
	b=30VTp8RcOE6DJ/v4t/vGflirOlrmsVIK46I+p614OjDktBBna6O+smJLq2tHQ9Y4dhhiOD
	PgG4ZOqMC3ig20b1+xnkVlNH5G80aXAc+ShEfIpfIDs4f9p29U+nIbawiE6SwjDUzO9QGc
	++A/NDiT4GhYv4lfnBR/Lz/LMY7JrEE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=gfO9m+pc;
	spf=pass (imf03.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770702430; a=rsa-sha256;
	cv=none;
	b=czgjAk+LC4pdPTc1CMPXC4+z5y7coPMVG0K4tT3oIlOcxVHC/ReOTuI2Vyhn4Wy1wJNeAI
	LqVrXblWPRIrYjedruN014bxYk+NPCMWlDRcBVWV7vq0Cp9utvD78rY84OufKE6J6F0Lb2
	+UYfOk/EkHZOkvMIqW+scoG9+axIqvY=
Received: from dlp.unisoc.com ([10.29.3.86])
	by SHSQR01.spreadtrum.com with ESMTP id 61A5hPoq016481;
	Tue, 10 Feb 2026 13:43:25 +0800 (+08)
	(envelope-from zhaoyang.huang@unisoc.com)
Received: from SHDLP.spreadtrum.com (BJMBX01.spreadtrum.com [10.0.64.7])
	by dlp.unisoc.com (SkyGuard) with ESMTPS id 4f99T74nrwz2N3Tj4;
	Tue, 10 Feb 2026 13:43:07 +0800 (CST)
Received: from bj03382pcu03.spreadtrum.com (10.0.73.40) by
 BJMBX01.spreadtrum.com (10.0.64.7) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Tue, 10 Feb 2026 13:43:21 +0800
From: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
To: Andrew Morton <akpm@linux-foundation.org>, Yu Zhao <yuzhao@google.com>,
        Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>,
        Shakeel
 Butt <shakeel.butt@linux.dev>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Johannes Weiner <hannes@cmpxchg.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        Zhaoyang Huang <huangzhaoyang@gmail.com>, <steve.kang@unisoc.com>
Subject: [RESEND PATCH] mm: bail out from partial cgroup_reclaim inside shrink_lruvec
Date: Tue, 10 Feb 2026 13:43:12 +0800
Message-ID: <20260210054312.303129-1-zhaoyang.huang@unisoc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.0.73.40]
X-ClientProxiedBy: SHCAS01.spreadtrum.com (10.0.1.201) To
 BJMBX01.spreadtrum.com (10.0.64.7)
X-MAIL:SHSQR01.spreadtrum.com 61A5hPoq016481
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unisoc.com;
	s=default; t=1770702222;
	bh=WXTUlQnumUaygJxbhSnJT0+rlcSCmcEIeUJIsJDTIrY=;
	h=From:To:Subject:Date;
	b=gfO9m+pcK41g/rbteCxRu298IfMnjgD2qoWYvn76QpjoQr0DWWjiQxTRJzVVYJNhG
	 rg4oVKnOM5kfubvvEsgMc9NVhOCU3U2biDEf84+wR0s/98ccA3YK+ONx2b1kCng58K
	 UzkR+Q5cr+ZI3gHPiyyC03Ss1fBNEJ//k7Q9YemcV/rK++cv9V2ul8zfdK6reOC6wb
	 5GlUrIjPFqK1KhCQRXYOrWiryDVe+fXf+1IX5p3bTgptzvKzylo1PfhSWdU9nAC2gL
	 wYb4CFu/PhVU17ooRWLLJydKp+JnkQFW5V02tBaLstYmcleWGLANj2nPTWz3lPtS/P
	 C8Lcjx/09znvQ==
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D66E820007
X-Stat-Signature: u4kt7qqitq7tktuhz1ycphxw9adazby7
X-Rspam-User: 
X-HE-Tag: 1770702427-536268
X-HE-Meta: U2FsdGVkX183M17d7DXWwHnewdVZVdETH7341KFRRMAoFngPPXIsWqmJIVG2MSahawR5QOZoKlbO7LVC6ga+wvZYfStU6P7FhtweEUKwzemC//ZIrJq5F/99vLWfnrN1fxAvuroZUiWKfJvq8N/sNryjyWejeTiEHe7tcZPtbRpnKxis4Hn2yz4oBsioYEKMSbax7Lrf/ADhz8rR2gwNdmD4nP45D6MTW4B5s8i1LmmlHYtscRolqBVvxrCQcBy7SnJu1zWJBS0f11jJ3fbCaBNDbR6R+TT7ShZ6yNafaGP5l2THAOaz5SeLatB/ZCX/XdDjPCNdK5gyM9gtzrxA0jl3dxV9YHBYIkw4+ZsSriSg04krdu0XEcHkI88vuKcdxc4VcTiE67cSs+HXf7irbEIlwJCZYZNHnrZifv3ZhbpIKXRvUc96Kgh6xZctx+MtTkA7mwcUqtd2MU4ExAwCnbOiY90Z4WAvJJ/t/ytVjoEDCgIkit5Q2xCectg0d1Q5zRcbPCzlLmyggG6wKsUegO7dTlnv9x67umvq+vuyRzxTa4eeQjf+2lDJp+PVOLrwu0FTstjN48a0lW0TRI1mRemmsL4pABCuvD6BkJ/Ss4ApzBRLCMKScIKpZM2YguiLRSTtqpWwbSzjxSLcGy4MVSw805s9PpnWizbbDuyyOd2iOmLKluxRaDnORXXR6SPl+TEEi4Eby70xXYIfFWDLb5ri6FZ6jviYZuXS3OddJfn8ndZcM5vY9SxK4TDX8CHXG19v8r7Bma0d+gsHbDrwuQdWYhO4xpQ/KLKbFN5xEFXXRKyUpYl7aq7jMiBc59cjD2CpPnBs+MwYpHpmdSURn017vJMpO0p+0p5ex1o0ocWbYJwREdK6NQKUoKXxlJLo54DjcNvYmX2GZ5WCtP2HWISUTAiFAtQS55Asvyxo8AmlmQuRdltOrWVDObZV8eCyPRW5pBPm7voDQ6Zq9QW
 imE1LzHw
 mB/MMhfbPYagFFruOFcsZRkI+72XF4Hc0fSHzXlzUj9DhRq4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

Nowadays, ANDROID system replaces madivse with memory.reclaim to implement
user space memory management which desires to reclaim a certain amount of
memcg's memory. However, oversized reclaiming and high latency are observed
as there is no limitation over nr_reclaimed inside try_to_shrink_lruvec
when MGLRU enabled. Besides, this could also affect all none root_reclaim
such as reclaim_high etc.
The commit 'b82b530740b9' ("mm: vmscan: restore incremental cgroup
iteration") introduces sc->memcg_full_walk to limit the walk range of
mem_cgroup_iter. This commit would like to make single memcg's scanning
more precised by judging if nr_reclaimed reached when sc->memcg_full_walk
not set.

Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
---
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 670fe9fae5ba..03bda1094621 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4832,8 +4832,8 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 	int i;
 	enum zone_watermarks mark;
 
-	/* don't abort memcg reclaim to ensure fairness */
-	if (!root_reclaim(sc))
+	/* don't abort full walk memcg reclaim to ensure fairness */
+	if (!root_reclaim(sc) && sc->memcg_full_walk)
 		return false;
 
 	if (sc->nr_reclaimed >= max(sc->nr_to_reclaim, compact_gap(sc->order)))
-- 
2.25.1


