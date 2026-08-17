Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95DB4C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 13:19:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 990836B00D0; Mon, 17 Aug 2026 09:19:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91ABF6B00D1; Mon, 17 Aug 2026 09:19:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8098A6B00D2; Mon, 17 Aug 2026 09:19:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6016A6B00D0
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:19:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E35D880756
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:19:40 +0000 (UTC)
X-FDA: 85110818520.11.E611C0C
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf23.hostedemail.com (Postfix) with ESMTP id 15E0E140008
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:19:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786972778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=lHTg75OVmv8S+3b6lA75rqGzMc8CjvQdDfpRzfQA1OI=;
	b=Uzy0wEudJBw5O4Q9n9NHBc6L0+2hvdyxZKlMJ8C10b4DrjcplT2+HBpuITAPQHfPYD4FAV
	gmjcnrDw+RsS5Xca1r+iHtJlfk26jze2N9fOhQdTcVZO//6JVHkrkX5+971I8vUt2eHLkC
	wUknx+0ivqBt7CPUEBKYlhv60a6LevY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786972778;
	b=yoMCy1JF2bDgMQzheKviPkMlrozihNe3XV4cg8YroOEnEzFV2CZitVhCkoFTkeVHcGHQV3
	2r9E4FL1TkEiuO7YOdK5uakWoCbVAQWHZ/KW5m/KHjrRT+ovrFsIv06uE6Zvvj+nM6vMNt
	FGerpNfShqVYT4+T0oCwQEuowDtDzwU=
X-UUID: 45bee9009a3e11f19a56ed5b684f684d-20260817
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:2f434dd9-bfdd-4195-86b0-60afbde8c5b7,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.19,REQID:2f434dd9-bfdd-4195-86b0-60afbde8c5b7,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:7db8b62,CLOUDID:7de0c4b8a1718a804dc096b537f914e3,BulkI
	D:260817211930ROFSYON4,BulkQuantity:0,SF:17|19|66|78|102|127|865|898,TC:ni
	l,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:ni
	l,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 45bee9009a3e11f19a56ed5b684f684d-20260817
X-User: husong@kylinos.cn
Received: from ctao-book.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1285450484; Mon, 17 Aug 2026 21:19:27 +0800
From: Song Hu <husong@kylinos.cn>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	yosry@kernel.org,
	chengming.zhou@linux.dev,
	shakeel.butt@linux.dev,
	yunzhao@cloudflare.com,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH] mm: memcg: use ratelimited stats flush in obj_cgroup_may_zswap()
Date: Mon, 17 Aug 2026 21:18:43 +0800
Message-ID: <20260817131843.45121-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 15E0E140008
X-Stat-Signature: isf8mdmeg6895r7qy8179xqbjbmkkjd9
X-Rspam-User: 
X-HE-Tag: 1786972777-693819
X-HE-Meta: U2FsdGVkX1/tejRxOvwO9vBOv+zholXUlGjeE3lQ8DZj87KjoospCgmXE7LW2lNVK3MTsf8r07HDo5kbHjndjTaOVjdi4FL4OHZnhpk8D9L04WfQNd5EPw+0YCMlrTH+iXqx5W6iBMWMcUeAZtXGLM1bM+mJYCt0rTnbpEZkgOphjrmB+qEw0+v+a6kuXotcdKMZDS0Gm4jxmpiuEm7SkC9136vl0soLKnqduAVRESsipVxHy+NjSVkToySSUzVG4Jqb8vVFFJh6CvFob3FQqG165o+C/6x/vylzDq58JlKWn2Ogs9uz6AwSHT57AusUjYtSD4S7ibVlDA/NWMvP6X8/UeWCxFCkUq0b8qFdLJCu2U4+dKwaB6KdEDw4PsLqJ5SIdN/HtR47MH/R68nebL1G8yQCBYQ/YlZyEc1Zw5aglacN3ekQNtz8bbJhF0kJtdDPwzfMzx5TP0UuGoMgf/NfPwnFyTKesAhevxw+3YP73GNLPWGDT21fJvItCONY5LF56na4PAytbd+VAzbSRdsmWC/jJs8SLevE68wnZsgqaepY5II3Ja9LcyqFeN0Cf5yNeGHnxfG3RB7FIyunZI89o2cfb5lq/SZPseat0r5m6bB3zevGaUeEqAGSOP0ZD/XaqOvhrFaujm4oacmCWOTmzw0X7n6Awwi00NAoxFuLuerTwzMnLWHd005LQwvVavEmZE8RraNrTf8VAqvCukofbP282VRfQlxH4xwcm4GfHhwHp3HQIrBotns7mPRNNoHDXD7bNppIUCFHdnijkX6/ibSE7Lw/4yqa5+id8gvYX8na/6U5NehCHjbKm8dHayzjIYOLvRpb3iT7lEO1FAYjMwobIGKRdF1zy49Xdh2M+nAORBpJHPXc3jGiiYkoaJ3vVSgXXlhVLyB8eu08CPh9f3ZyF/earzKerHFpziAlPGOYkynMkZSp6UCf3lX67CQ06EgvrJvZTARsFyG
 sYfWyXSN
 fjTplGUiZOBN58nZJoAlhZlmSIdEG6AeTTVh5VQrTe/FgEVQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

obj_cgroup_may_zswap() runs on every folio swapped out through
zswap.  For each ancestor with a non-max zswap.max, it flushes the
cgroup rstat hierarchy synchronously with force=true, which skips
the ratelimit inside __mem_cgroup_flush_stats().  In a swap storm
with zswap.max configured, a container takes the global rstat lock
on every swapped-out folio.

zswap_shrinker_count() had the same pattern and switched to
mem_cgroup_flush_stats_ratelimited() in commit ea80da363a1f
("mm/zswap: use ratelimited stats flush in zswap_shrinker_count()"),
where the same flush on the shrinker side showed up at 2.88% of
kernel cycles under osq_lock on a 96-core machine.

Measured on a KVM guest with a swap storm under a cgroup with
zswap.max set: obj_cgroup_may_zswap() was entered 198,977 times
before the patch and 198,968 times after, while
__mem_cgroup_flush_stats() was entered 281,017 times before and
80,445 times after.  The removed 200,572 flushes match the store
attempt count almost exactly; the remainder comes from other stats
readers in the swap path.

The stats can now be up to one flusher cycle stale, so zswap.max
admission can overshoot for one cycle in a storm; the overshoot is
corrected as soon as the next flush lands and later stores see it,
the same tradeoff the shrinker side made.

Fixes: f4840ccfca25 ("zswap: memcg accounting")
Signed-off-by: Song Hu <husong@kylinos.cn>
---
 mm/memcontrol.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 17da1f43b7d3..7a8f689055c6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6000,8 +6000,7 @@ bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 			break;
 		}
 
-		/* Force flush to get accurate stats for charging */
-		__mem_cgroup_flush_stats(memcg, true);
+		mem_cgroup_flush_stats_ratelimited(memcg);
 		pages = memcg_page_state(memcg, MEMCG_ZSWAP_B) / PAGE_SIZE;
 		if (pages < max)
 			continue;
-- 
2.43.0


