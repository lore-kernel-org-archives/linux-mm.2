Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2582C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 04:48:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFD086B008C; Fri, 10 Jul 2026 00:48:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAADF6B0092; Fri, 10 Jul 2026 00:48:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4ED06B0093; Fri, 10 Jul 2026 00:48:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83BDA6B008C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:48:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 04E508D441
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 04:48:09 +0000 (UTC)
X-FDA: 84971635140.03.E54F959
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4FCAB1A0006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 04:48:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783658888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TXel3NTeJ0jhGUGKOTbm/r20VeXMU0mnylUJQdkgadM=;
	b=IG4dJ0ug1dFtov7oDdUjQ9CSGg2Nb2Sjsi3xsqr2z7il9bioHgTc7sr3mS3xpOSQ6bzg7W
	RjLs2EpPwCOygK47XRWepcefctB76sHZRPNgKLDzIplC4qVzwwG71rbf2XQ+70TVg9T0PW
	3M9Ecl6vzltm+wAIepQvVYMbGPcPWLg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783658888;
	b=a5NGodcOmX2tcMyf2gScjjHjVyS8dWSL3PkZ1lpXS91bTzvxNmk3WjLVuXatn0hCTv7U06
	syV19mzAk+SyHRZBK4QYt6nVSxfLdTjtmVlLOxUMy2LersikrykJ5kUAZRgyjfCCMwmW34
	eBDx0ij7iD1JNl7V9ftEGC5PBxEFMi8=
X-UUID: 869e10d27c1a11f1aa26b74ffac11d73-20260710
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
X-CID-O-INFO: VERSION:1.3.12,REQID:3aad97ba-e5c6-488a-8f6d-f1ccdcc9a806,IP:20,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:15
X-CID-INFO: VERSION:1.3.12,REQID:3aad97ba-e5c6-488a-8f6d-f1ccdcc9a806,IP:20,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:15
X-CID-META: VersionHash:e7bac3a,CLOUDID:8663a529982b81e3e9e756784a1617fc,BulkI
	D:2607101248003HIIJI1E,BulkQuantity:0,Recheck:0,SF:17|19|66|78|81|82|102|1
	27|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:
	nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,B
	RE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 869e10d27c1a11f1aa26b74ffac11d73-20260710
X-User: husong@kylinos.cn
Received: from ctao-book.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2065078812; Fri, 10 Jul 2026 12:47:59 +0800
From: Song Hu <husong@kylinos.cn>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH 2/4] Docs/ABI/damon: fix typos
Date: Fri, 10 Jul 2026 12:47:35 +0800
Message-ID: <20260710044737.561102-3-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260710044737.561102-1-husong@kylinos.cn>
References: <20260710044737.561102-1-husong@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4FCAB1A0006
X-Stat-Signature: xea3eumwbcj7ap3w4onucqqj4d6ftxqo
X-HE-Tag: 1783658885-214233
X-HE-Meta: U2FsdGVkX1+wnmPpwyau3AluSv5VWmNEqTdWWxExsnwZ8AlKGIODMtj3tmspbiX1sovHBTrSb+oubl3NBUhPRiZP0/evpyNtT+/m0Q8G6KMo1gNBz8nxpkzWqnq3c/s/gz91EkmRoXMnS7MURlewX8ddcqMPTjJ4bTG7U/NqQTVT3TAR0Mfs/A0mF3K5I0QESdlSf5OifOkcFC64eLGsDVhKhVjGhG0GNCxOZdV1OyffcgC4IBlENr9bZOH655NSQO/BEy+FbifH2QL/+iVJsJa0JB98BfnMynYiQExqrAzG56t4YeAVlxoM7JeWMOa+mOX+p1kKe+d+wE79lwMduJkJ0X7Y5wpHzwzW3bJUyHLP/6lLeo2UKFAEEiyzOYg1UdHYA52i2Mt2qJe3iUSerttdYE2ZBCnnKqyh9dlqqGgztgIkyycHKX78HqtvsFctddcX8+xdNFlMAgDoWnjn4vJLJvkTs5KWNGe6sjo5nofhtUrjN5+CqxSgcCK62nUf0HSx/T5eq+POe72gOeBI+W8R218ZMmyyD+DFp1uwDR+3XEJAxV5e0/36XaC/hXc1evwQ8Bk5o+E1o7aHuHE50BiGJDgvbm1uRXGrNDNzltD6CckckPz+oAJHkNE52XDsL6lPX34djk1lLsrfda3S6/3al6x0Ez2snPe1yKqeuxRle5qBY4yKOPY4HLiq/rUf6YtAXDtgYPkuPvhGMFrItrGCphc1n7v4EFdxi1pT9qLDb4vAFBM2Taalkyd44CWv4jNbk6i4vh3Q6mWhy/web/U6NZxeL1asEMDp5+2+sEcVfcp9h47VmRZ8lC5mbGGCjJmY3nUs0D4sSStv4d/WqnbDgZJSS3S/Zzv7lc2LNtJDvCDzzZr5Tatw7T6dMePQcg4mDCK2SahsAXlcMcQW7EfFM4MBKuzzLsamRjhBVUIJEQhwPS+WHs8IcVquJF991hYIecu2y+8/easaBbA
 GBqLeRVg
 DO+kEvgdD9WB8LRomv2o9XmfATUj07KPEEH+j8y6Qo/JMlZfVtrK5mC2jQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix two typos in the DAMON sysfs ABI document:

  - "WDate:" -> "Date:" on the nr_regions/min entry
  - "manimum" -> "minimum" in the nr_accesses/min description

Signed-off-by: Song Hu <husong@kylinos.cn>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 885409a26786..03aecc07a5bd 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -144,7 +144,7 @@ Description:	Writing a value to this file sets the maximum value of
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/nr_regions/min
 
-WDate:		Mar 2022
+Date:		Mar 2022
 Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a value to this file sets the minimum number of
 		monitoring regions of the DAMON context as the value.  Reading
@@ -281,7 +281,7 @@ Description:	Writing to and reading from this file sets and gets the maximum
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/access_pattern/nr_accesses/min
 Date:		Mar 2022
 Contact:	SJ Park <sj@kernel.org>
-Description:	Writing to and reading from this file sets and gets the manimum
+Description:	Writing to and reading from this file sets and gets the minimum
 		'nr_accesses' of the scheme's target regions.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/access_pattern/nr_accesses/max
-- 
2.43.0


