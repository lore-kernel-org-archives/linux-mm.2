Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA2DECAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 09:22:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A65A8E000C; Tue, 30 Sep 2025 05:22:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37F428E0002; Tue, 30 Sep 2025 05:22:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0237B8E000C; Tue, 30 Sep 2025 05:22:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DCE7E8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:22:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7CAF211A9CF
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 09:22:13 +0000 (UTC)
X-FDA: 83945375346.17.DD75EAE
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf15.hostedemail.com (Postfix) with ESMTP id 067DCA000B
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 09:22:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759224131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a9azlZKSi0tNyM/ClSPY9rn3tcKKqR8f1zLkNmcpz0Q=;
	b=nvP7U4DPBYrlHiHPKTYlaa9+80PSX4rTjPkg3PZ0X/3JH4nRsotEg5ql5TXRY+rNgrrHi6
	iRhE4DU53nZqra9r8pOjD9und/rP4Ccr6r29RSGqfEJVs9y4oT21zxFrEnG2xzltsBUmII
	x0gvQYcSeao2h249MLVqrLeIa0E83+Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759224131; a=rsa-sha256;
	cv=none;
	b=YGKf2CO3a1G8dudjbzk3gz3RuTFiPTvGAUti2hi8ZNJI15yF/spYi5JmNUVBcD3Ci10gTm
	K22xCAhYeTV1Z+gVb/U1BPSG57RUBnBneQ/NOUAY8Lm8hiNmEH/cFzmnfZzsFdDZneZecb
	IPUhFj7PmcE9xSdPPkLYdwO82gtOMvI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn;
	dmarc=none
X-UUID: ec5771ae9dde11f08b9f7d2eb6caa7cf-20250930
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:59d1ce55-b7b6-483e-b503-62d061f3287b,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:30
X-CID-INFO: VERSION:1.1.45,REQID:59d1ce55-b7b6-483e-b503-62d061f3287b,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:30
X-CID-META: VersionHash:6493067,CLOUDID:c6ed15d43f0769bedf10a25675148f30,BulkI
	D:250930172204C4MEKGXS,BulkQuantity:0,Recheck:0,SF:19|24|38|44|66|72|78|81
	|82|102|850,TC:nil,Content:0|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil
	,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:
	0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-UUID: ec5771ae9dde11f08b9f7d2eb6caa7cf-20250930
X-User: husong@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 912808686; Tue, 30 Sep 2025 17:22:02 +0800
From: Hu Song <husong@kylinos.cn>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>
Cc: Song Hu <husong@kylinos.cn>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mm/page_owner: simplify zone iteration logic in init_early_allocated_pages()
Date: Tue, 30 Sep 2025 17:21:52 +0800
Message-Id: <20250930092153.843109-2-husong@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250930092153.843109-1-husong@kylinos.cn>
References: <20250930092153.843109-1-husong@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 067DCA000B
X-Stat-Signature: norzbiptiyjycuthedh9ztde7wxtj8bt
X-Rspam-User: 
X-HE-Tag: 1759224130-13363
X-HE-Meta: U2FsdGVkX191wqvrAPDy53JGxoHVS4HE22KgLvU4ZrdVYk8eUzzu5zKZCl1clVm8gOEGPxDWtXhLtPmUs/rhNl07p6KXF0+NRHbfKRDZH5/MuZ8BTq1StH7bZXLIjEUMSN3ohm6HNrE3s++4AAbMkYnWN7BAwyKca2dyWms03Cc/f8/2sGjnycNgnVut+/Z3I+oeHqLaej1RLr3VG17FAHcaraTA4KvuzDGbmkrr3hXV3r2akANgff6SJNfoOLmbJkHX7reIB0lW20k4wIjqKQC8Oz8FDq5j7Lol4sO9d9Gow96ygYF1E+/oFGCIWiv40X4TmZkBLDl6s0A4Uk2jw1r4klrvdQBsFOdS2qEKTdAIy4K1J6OK4uxYjWxTErJNSti0lKu8ix5gv1pF8c+ltFbGC/woiyak2LjRbwgKadJFr9HQU17Psz4dK4Yziu6H++NVMRjSC4ZAewx9TR3Appz0Hlh0p88S3YJrdm5Cp4axP77+KN2cqwMvfN27nIgh+856I86gdAacc4lkaNGbAdH+4X0TBFp/Bvrtkpp3BYeP4DL+MCU4S+igFjypAotMSfqsOhKfu5DndhwojqtZYkhVxUxwCJcuIwdUs1gJT4THJsljNF6bSxnrVIOUabglzFYjZ1K1fhgtC6aATQ7PoQcCWr7jYCy22H6/OawHnHXycmOHnR86Z1emr88ZFH79O0GcMInoupt2ibW0HGfAH/ftnCdcbpgERLxX9b5P30TbExbJh9sXLyKSLzKdz3003BkdRQYAw0KhYbrq/ANF9PLwfyawNNN8Sqhl8GLk1TjLKAWrt/+csw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Song Hu <husong@kylinos.cn>

The current implementation uses nested loops: first iterating over all
online nodes, then over zones within each node. This can be simplified
by using the for_each_populated_zone() macro which directly iterates
through all populated zones.

This change:
1. Removes the intermediate init_zones_in_node() function
2. Simplifies init_early_allocated_pages() to use direct zone iteration
3. Updates init_pages_in_zone() to take only zone parameter and access
   node_id via zone->zone_pgdat

The functionality remains identical, but the code is cleaner and more
maintainable.

Signed-off-by: Song Hu <husong@kylinos.cn>
---
 mm/page_owner.c | 23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index bb88b72b6062..b170b27d87a1 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -757,7 +757,7 @@ static loff_t lseek_page_owner(struct file *file, loff_t offset, int orig)
 	return file->f_pos;
 }
 
-static void init_pages_in_zone(pg_data_t *pgdat, struct zone *zone)
+static void init_pages_in_zone(struct zone *zone)
 {
 	unsigned long pfn = zone->zone_start_pfn;
 	unsigned long end_pfn = zone_end_pfn(zone);
@@ -824,28 +824,15 @@ static void init_pages_in_zone(pg_data_t *pgdat, struct zone *zone)
 	}
 
 	pr_info("Node %d, zone %8s: page owner found early allocated %lu pages\n",
-		pgdat->node_id, zone->name, count);
-}
-
-static void init_zones_in_node(pg_data_t *pgdat)
-{
-	struct zone *zone;
-	struct zone *node_zones = pgdat->node_zones;
-
-	for (zone = node_zones; zone - node_zones < MAX_NR_ZONES; ++zone) {
-		if (!populated_zone(zone))
-			continue;
-
-		init_pages_in_zone(pgdat, zone);
-	}
+		zone->zone_pgdat->node_id, zone->name, count);
 }
 
 static void init_early_allocated_pages(void)
 {
-	pg_data_t *pgdat;
+	struct zone *zone;
 
-	for_each_online_pgdat(pgdat)
-		init_zones_in_node(pgdat);
+	for_each_populated_zone(zone)
+		init_pages_in_zone(zone);
 }
 
 static const struct file_operations page_owner_fops = {
-- 
2.25.1


