Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C693C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 07:02:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BE7A8E00E8; Tue, 12 Aug 2025 03:02:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 720B48E00E4; Tue, 12 Aug 2025 03:02:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 573C78E00E8; Tue, 12 Aug 2025 03:02:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 40E588E00E4
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 03:02:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8D36416018C
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 07:02:55 +0000 (UTC)
X-FDA: 83767213110.06.E43BC0B
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2123040005
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 07:02:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754982173; a=rsa-sha256;
	cv=none;
	b=ZFZIrfOj0cStxhE64bCzailaRRhPetHcbbaO68wMxvR8tF/OYqw5V7EgleUOnoyOoVMCeP
	LNvdM13cK1qtaUrhd/CgeZRycDft/s6VlrS+/exQbKQv5qIqdu2zBFtQiEhZEHFogr92T9
	kEFTBj34L6pwCOK0VxPTuN7BKu4GOh0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754982173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=sgJMg3xbnSSW34x51lujM/SbSiQMQ8RCfYmVL7eHuZw=;
	b=OXZ98QLH9vV/UrMNcen8N85P+lnkB8jJxXS0eNFuuVguGG72RX/ZACPHro1/0bRC9/ar/A
	1Z2wj1CdO0Axl6dXQfnS9LUnCb7WVWpIVqiZu1Cyhu/mJJnr2vgHRNQ6jik99g/+V6iauI
	uTMHKJoFxD+XMa7t/A74YIc9vr42bFo=
X-UUID: 487ef602774a11f0b29709d653e92f7d-20250812
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_SJ_LANG
	HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN
	HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME, IP_TRUSTED
	SRC_TRUSTED, DN_TRUSTED, SA_UNTRUSTED, SA_LOWREP, SA_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_T1
	AMN_GOOD, AMN_C_TI, AMN_C_BU, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:689d0434-3aae-4dee-8b29-5e7c5f653dfb,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:30
X-CID-INFO: VERSION:1.1.45,REQID:689d0434-3aae-4dee-8b29-5e7c5f653dfb,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:30
X-CID-META: VersionHash:6493067,CLOUDID:1b11dcd03c34d8f7846d53ee1d225875,BulkI
	D:250812150244YJCELPZJ,BulkQuantity:0,Recheck:0,SF:19|24|44|66|72|78|102,T
	C:nil,Content:0|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:n
	il,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-UUID: 487ef602774a11f0b29709d653e92f7d-20250812
X-User: liuqiqi@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <liuqiqi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 921748466; Tue, 12 Aug 2025 15:02:17 +0800
From: liuqiqi@kylinos.cn
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	liuqiqi <liuqiqi@kylinos.cn>
Subject: [PATCH] mm:fix duplicate accounting of free pages in should_reclaim_retry()
Date: Tue, 12 Aug 2025 15:02:10 +0800
Message-Id: <20250812070210.1624218-1-liuqiqi@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: spzn4obihi935mqd1kkmosnohr5aed4g
X-Rspam-User: 
X-Rspamd-Queue-Id: 2123040005
X-Rspamd-Server: rspam02
X-HE-Tag: 1754982171-40108
X-HE-Meta: U2FsdGVkX19vWqPI1Ypu0HpeXKCCGdBdWG/Wr9nzxUqPkAV5j18tDo919PzccfLrYFbwpUGXQ6geiOaO5jVqsj643/rhdF3xb5GOoDBYeSI/5jnW/QIjuFp77w+o035otxJwTDhdZjAKquTKay68dLUJNsBefjFixuujLabjvs9MRa+GOJE7GaPcFTpEWkiIg6BYtocXs84T1f30WV0tccwuZytuT+mPgZLgHyBLJ8U7dkpIbg3xoqppnsmoiNX6T39NwOILGIGU7xwe+vzBGcRL8O4VAmxl9GL8/Bp5Ca6sIn5zeFh8XTXklVhrJStjvYKjFWP9GUyFbYGCCuOXEikL5UWdvP5pMFSPmfnKTdchfRvLMAUj4LVKVbZg3R368Rm7JsnwxcVr8pHsuC2HjmVaEXt9OqI1nU0pma+qCNY3SiKuUIMZRZnS3uf5AqQN3PQn4keLi20RBk0OOsc30g5NhKP2iP8kvTNXt7+3whh5yPuEFSOz5g0Iqfy10B7UyD8mC+n7eGrvvJE9vrpoBCvM59t2/wsBiPQHtvb4BBLXY1MwuoSsJy5Th5Bzm6oGQIVdJk5GDF6QjNi5RCihviFlYzPgGPPQ6HbMgxVREabvhbfLboEspn//2StUOaoacdtV4wuXCjeLQ1nOHxovKGr7W8eghju27K7oROfszXgDAEYJ3AFIh+QaJ1heCdByglJgfeElBG5X+8CmCb+bJBk8rFRFemZ235KZW3cglECO2XFlTRNoPCj+c1afjXWM6PedRZJl+f99Fs1vI16Z0BdNN64UfpuQIpWDwXLUhcrkx7NBaC+71fUzAumboweI3NV92mW2RU2xWp2hdsiOlC+2wxWUEmgMPHYOXPkx57T1TNVY721e5+8W12zFKNcMtGpsUCaD2UZzlRTRYbWnb9ET2YlFc6MzMNrZ2qsz/cf7aLnR5Av9gVsw0NrZXOsndaoM4OK8yxH3uuV8cww
 wKguuaL5
 9PiTVjKEXeRAIpXZ6RAcDnm3oabLH3ZIKCcCfB4ElZe0O8WI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: liuqiqi <liuqiqi@kylinos.cn>

In the zone_reclaimable_pages() function, if the page counts for
NR_ZONE_INACTIVE_FILE, NR_ZONE_ACTIVE_FILE, NR_ZONE_INACTIVE_ANON,
and NR_ZONE_ACTIVE_ANON are all zero,
the function returns the number of free pages as the result.

In this case, when should_reclaim_retry() calculates reclaimable pages,
it will inadvertently double-count the free pages in its accounting.

static inline bool
should_reclaim_retry(gfp_t gfp_mask, unsigned order,
                     struct alloc_context *ac, int alloc_flags,
                     bool did_some_progress, int *no_progress_loops)
{
        ...
                available = reclaimable = zone_reclaimable_pages(zone);
                available += zone_page_state_snapshot(zone, NR_FREE_PAGES);

Signed-off-by: liuqiqi <liuqiqi@kylinos.cn>
---
 mm/vmscan.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 34410d24dc15..a9aaefdba7a2 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -393,14 +393,7 @@ unsigned long zone_reclaimable_pages(struct zone *zone)
 	if (can_reclaim_anon_pages(NULL, zone_to_nid(zone), NULL))
 		nr += zone_page_state_snapshot(zone, NR_ZONE_INACTIVE_ANON) +
 			zone_page_state_snapshot(zone, NR_ZONE_ACTIVE_ANON);
-	/*
-	 * If there are no reclaimable file-backed or anonymous pages,
-	 * ensure zones with sufficient free pages are not skipped.
-	 * This prevents zones like DMA32 from being ignored in reclaim
-	 * scenarios where they can still help alleviate memory pressure.
-	 */
-	if (nr == 0)
-		nr = zone_page_state_snapshot(zone, NR_FREE_PAGES);
+
 	return nr;
 }
 
@@ -6417,7 +6410,7 @@ static bool allow_direct_reclaim(pg_data_t *pgdat)
 		return true;
 
 	for_each_managed_zone_pgdat(zone, pgdat, i, ZONE_NORMAL) {
-		if (!zone_reclaimable_pages(zone))
+		if (!zone_reclaimable_pages(zone) && zone_page_state_snapshot(zone, NR_FREE_PAGES))
 			continue;
 
 		pfmemalloc_reserve += min_wmark_pages(zone);
-- 
2.25.1


