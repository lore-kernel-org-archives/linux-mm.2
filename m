Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DAFACAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 09:22:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C31BC8E0003; Tue, 30 Sep 2025 05:22:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE2088E0002; Tue, 30 Sep 2025 05:22:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B20158E0003; Tue, 30 Sep 2025 05:22:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9C9B58E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:22:12 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4FFA61A0645
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 09:22:12 +0000 (UTC)
X-FDA: 83945375304.24.79258EE
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3BFEB180006
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 09:22:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759224130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=xj8xivkLrU44W9J2jDv0VhheFDWYQLbHF8j8FNE+dvA=;
	b=W+HT9meLxkccU4J4Fvlzm9nPZhF7vBb697gLLP/ENKG043CTOk5l5wOxmViv5NoeoFl9pp
	s1qkjCsnOuNWpQxQjiRYCSnfA3so+/q8pwyrBtFSJZqriVohn5jy9hCmF0d4f0fIOMzeOw
	B358YVHTghDbMfU4HR/tlbbMOh6tsYk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759224130; a=rsa-sha256;
	cv=none;
	b=NSx01jlScgU6KLIbdM/OhfVeUqPpe8AjaUYSAkFqODUhozkR6rFkUb21djCThyYCIJLWJ3
	wQXjXm2HgYBfenAWAi9dFg+a0fiklygwIQpx/HR9sFK46b+q5Ve2LLpY3uOV/WChSID/+m
	/HCyB//7OZKV/a1KkBICdhE/rVWnbYY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn;
	dmarc=none
X-UUID: eafba74e9dde11f08b9f7d2eb6caa7cf-20250930
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_T1
	AMN_GOOD, AMN_C_TI, AMN_C_BU, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:64f52787-5ac7-4f5a-9186-d8c0339fe843,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:30
X-CID-INFO: VERSION:1.1.45,REQID:64f52787-5ac7-4f5a-9186-d8c0339fe843,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:30
X-CID-META: VersionHash:6493067,CLOUDID:cde200468e5833ba8e998c12b7f72ec2,BulkI
	D:2509301722017RW1K8LW,BulkQuantity:0,Recheck:0,SF:19|24|38|44|66|72|78|10
	2|850,TC:nil,Content:0|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:ni
	l,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:
	0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_FSI,TF_CID_SPAM_SNR,TF_CID_SPAM_FSD
X-UUID: eafba74e9dde11f08b9f7d2eb6caa7cf-20250930
X-User: husong@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 167271401; Tue, 30 Sep 2025 17:21:59 +0800
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
Subject: [PATCH 1/2] mm/page_owner: Rename proc-prefixed variables for clarity
Date: Tue, 30 Sep 2025 17:21:51 +0800
Message-Id: <20250930092153.843109-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3BFEB180006
X-Stat-Signature: 7anmwity5b5mxoawd3cfn8srw7nakefb
X-Rspam-User: 
X-HE-Tag: 1759224128-760298
X-HE-Meta: U2FsdGVkX19an7afAVqOg6t+fYbrbcv2cpBVLlheqFfHdf3dHzUmaVa9vclwL3Yh63+k4BJokpyys7VovbLPMsvTjiP+cl/D7wr5dNAcIzoWEeWzlHUUMmKig9AiOhOoXMUo0V91dNXPmHgPhRDuIJp6gz0PrOXxj8iOAggwDbSUQkqLGzV6ZpgLgIUL72L27JLyrlRaYlFvJmE08vd3s+vaXCuR0GgjnIiiFdBfE0hqHGi6Zy2Uq1xq3OjHDiLL/Kh0wQ1cp4hpV3KdDmApkdIg5M/2JDcHauQVv9dxAbrqOe33M8F1ZWF+fvBRkNaKBQWZonUzWMKULJ/g0T8wshHGYvML+AQE1QvfKXkotoZ/J7mTmvF10qmE8/j1mrEKp213vK9c1bjfpSIa+lPoZE+5EDSIzVEgOlOduMW5O5EwmS0ROfrIdPBX7lGO3m/Cajh47UkQmGgma+oNJaoOMEvFZU6GKm/HO1wWgMunVFLzg30doOdyjtNmoY9iKI1ixmIAU8+aVbEL7LY43Ctpt2pVI4//9Z4vGbNm+8m9lRtVrowZr2WhKZFLNZxgQqisdV1DOY+kzwcJGvcdyOw9f3LXhAnppOv1ZNlmKBALrBAO+1ouQS4gkkDk9Ez8yPu69kf7Ytdw5tIA0Ny1tD/Rjr6htSz090IhFMG4exiIua0UjppSGyHGIS4nLsH1Ov2+ZlZlMu3xiugEPjByoCWJFqZp0ouHCxVqptM2IaoRWuN81dKgXvAoZiaqZgKfdIwrTXEHxl3Ay08K7MGS3BqNf+TqU/FCBmRYYQmIQd/UJ8Xs5LhLz1yurQUdrTSg5IOI8ql5KRg41Oo0dQBvngv5O09Dy84nrdc26f1qAGzu9rhGfc5tLNSkCZHFFkYel9yeiXEt5ZESaZwk5fhT28yPhXdAEejuEbnB4NSy49J/4Onk00hZ2EpQ2xF0+OVB0ATk8nJUDQZdVv8FUsvQ2z7
 nmWwiRrO
 hVEFyz4U9VBGigrMkWrP3sn0TGqh0HApvyr79bVkiTggnU3Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Song Hu <husong@kylinos.cn>

The `proc_page_owner_operations` and related variables were renamed to
`page_owner_fops` to better reflect their association with `debugfs` rather
than `/proc`. This improves code clarity and aligns with kernel naming
conventions.

Signed-off-by: Song Hu <husong@kylinos.cn>
---
 mm/page_owner.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index c3ca21132c2c..bb88b72b6062 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -848,7 +848,7 @@ static void init_early_allocated_pages(void)
 		init_zones_in_node(pgdat);
 }
 
-static const struct file_operations proc_page_owner_operations = {
+static const struct file_operations page_owner_fops = {
 	.read		= read_page_owner,
 	.llseek		= lseek_page_owner,
 };
@@ -929,7 +929,7 @@ static int page_owner_stack_open(struct inode *inode, struct file *file)
 	return seq_open_private(file, &page_owner_stack_op, 0);
 }
 
-static const struct file_operations page_owner_stack_operations = {
+static const struct file_operations page_owner_stack_fops = {
 	.open		= page_owner_stack_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -948,7 +948,7 @@ static int page_owner_threshold_set(void *data, u64 val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(proc_page_owner_threshold, &page_owner_threshold_get,
+DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
 			&page_owner_threshold_set, "%llu");
 
 
@@ -961,13 +961,12 @@ static int __init pageowner_init(void)
 		return 0;
 	}
 
-	debugfs_create_file("page_owner", 0400, NULL, NULL,
-			    &proc_page_owner_operations);
+	debugfs_create_file("page_owner", 0400, NULL, NULL, &page_owner_fops);
 	dir = debugfs_create_dir("page_owner_stacks", NULL);
 	debugfs_create_file("show_stacks", 0400, dir, NULL,
-			    &page_owner_stack_operations);
+			     &page_owner_stack_fops);
 	debugfs_create_file("count_threshold", 0600, dir, NULL,
-			    &proc_page_owner_threshold);
+			    &page_owner_threshold_fops);
 
 	return 0;
 }
-- 
2.25.1


