Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04AF3C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 04:48:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F82F6B0092; Fri, 10 Jul 2026 00:48:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A8716B0093; Fri, 10 Jul 2026 00:48:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E5F96B0095; Fri, 10 Jul 2026 00:48:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0862E6B0092
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:48:11 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 87B49169344
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 04:48:11 +0000 (UTC)
X-FDA: 84971635182.01.4B2D087
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf23.hostedemail.com (Postfix) with ESMTP id 66D34140002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 04:48:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783658888;
	b=ZCQ7eDcNKOiIo3+8rfrAuT2Wvc8xSdSAZ3LG2kZsjFBNKt5RUnC338GMjnVHvQ8jdpxdX3
	nn8s8usyK9DHdNaqWBvWbBRDLBEaxp/W43jNucMZEsKkyhKGm4rLpxR8XvWwdcE0vhySVG
	Yr6t8U5RmgCDj9H9iwCcvFP3KyzQ3yU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783658888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=woSUXmvu9bYrsGwYu7eIPkY7hk8dWhGso89bbDMTAlc=;
	b=iyZNJLQjRJG4hvnHvZGLD6af6JKL161EgwFhf/YuOk1jjcgV8RjO632CPUBp1wlrFKVORk
	oqErs25hIFB3twverJwLRitSG1a03Xe7wSnHt8pwxAz8p3q7OqoayGki+H/kR00n9yFrWM
	fR3ZMlvATE1XQksISLoOb7GHKEyST0w=
X-UUID: 878d25e67c1a11f1aa26b74ffac11d73-20260710
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED
	SN_UNTRUSTED, SN_UNFAMILIAR, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:498a809a-93a4-4bb2-8e59-01ad85f3bfc0,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:20
X-CID-INFO: VERSION:1.3.12,REQID:498a809a-93a4-4bb2-8e59-01ad85f3bfc0,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:20
X-CID-META: VersionHash:e7bac3a,CLOUDID:4fba04f2ce21b72797cd9e9a741924e0,BulkI
	D:260710124803IHUJF5Y2,BulkQuantity:0,Recheck:0,SF:17|19|66|78|81|82|102|1
	27|136|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 878d25e67c1a11f1aa26b74ffac11d73-20260710
X-User: husong@kylinos.cn
Received: from ctao-book.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1826423182; Fri, 10 Jul 2026 12:48:01 +0800
From: Song Hu <husong@kylinos.cn>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH 3/4] Docs/ABI/damon: document update_tuned_intervals state command
Date: Fri, 10 Jul 2026 12:47:36 +0800
Message-ID: <20260710044737.561102-4-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260710044737.561102-1-husong@kylinos.cn>
References: <20260710044737.561102-1-husong@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 66D34140002
X-Rspam-User: 
X-Stat-Signature: oqhjw1raezq9g73h4xotkg6ctcqhzc1t
X-Rspamd-Server: rspam03
X-HE-Tag: 1783658886-42513
X-HE-Meta: U2FsdGVkX1/dqXfcJ4Z2+NTFf71DssWITNxi9eO+T33bpFj1RHTjuf253YgLaWgYCEyQ2a2r4ZJEqIxuDUtHXOdHBvAYDpvBuABKmgnyrhx9GwuQ4O4BRvtn/mymh/Je3WyVLhSeNhDx2UBykg8RyeVLU9WNpxiuD903LT5vovL6Rz/+sZoCAOxTOgIb9/0ipcqmKv2KMG0ADY5ysEApN3MTIdMAhkggSgEH19Unnm2TfZBnmOet+brzHdDaf81qqhheMYhGUcLOmMa7rH5E8NllnPQRNyzL1Bc+ijwdzq4vsnYgVjRWMCckTXDuRNJZ6/8LYAp1/BgOoWLSWl2mlTBXfXQSJtfRLsLu9F2e3YdVUbig8ubm+WklG3p5X2soOOG4GTUtDc/c6FtO/TpG9HZoNBK988552C9YMvYXUzPIEi093T9KE7hleGN8WraD87P4Z6yfE3YyslNBZJqT05rhbRmlHWNbdBHdKjTSaN/ReBHwx3qlGCMc0fe0gu3BJRWMh+pweWeqUTaySW/zHOuc8DTaQkXHSa+CAqZzXGOTM2ylUOTxkjqd9wLAW8tiogHOnYudSZF1Cjjt9YwS+4PbcnrOLaB5D/b4X6NOQgOoWWcdqzkhA1vWgk044M3CKrNQktfJPeCrUPycIsU06Bnj/AUO81qG6+esvMm0HbjL02m9500mR+yLr/K7jey3cReYTbmUkLqdP1eUkbqZ9q//pJr2O7+zU+xfYQo4dVYTRh9DGHBEYaknHnEBrJQmQcAZK8IbwrBUYi8SYBp7pgyX3oqz8byG0NxOTyd8Vwyg/uK4y+3+xXJHuYCpEEFnRXTnhPFsS3nS8ShEqKdTD3oewo17H+Y+ztATUQwFHThTuAYQBSUg2KPLYNVvLySZhojqzumgKeXx9EtgIyEl6oR8jjkcKpEdkRZYlAPFTclokeasvFKXqwllDUyJ5FH/7Ww+hUxdmlB9Or+i2R1
 lkHnzqrZ
 monD33VR5PxF//m87l3xaNlca2aUTZe6+TrdjR4l/4HXK0SI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The 'update_tuned_intervals' command of the 'state' file, added in
commit 1077605396b4 ("mm/damon/sysfs: implement a command to update
auto-tuned monitoring intervals"), is described in usage.rst but
missing from the canonical ABI document.  Add it.

Signed-off-by: Song Hu <husong@kylinos.cn>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 03aecc07a5bd..7e8192527191 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -36,7 +36,10 @@ Description:	Writing 'on' or 'off' to this file makes the kdamond starts or
 		kdamond.  Writing 'clear_schemes_tried_regions' to the file
 		removes contents of the 'tried_regions' directory.  Writing
 		'update_schemes_effective_quotas' to the file updates
-		'.../quotas/effective_bytes' files of this kdamond.
+		'.../quotas/effective_bytes' files of this kdamond.  Writing
+		'update_tuned_intervals' to the file updates 'sample_us' and
+		'aggr_us' files under 'monitoring_attrs/intervals' with the
+		auto-tuned sampling and aggregation intervals.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/pid
 Date:		Mar 2022
-- 
2.43.0


