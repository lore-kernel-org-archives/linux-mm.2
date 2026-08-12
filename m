Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B69C2C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 08:04:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 867676B0099; Wed, 12 Aug 2026 04:04:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83F136B00A0; Wed, 12 Aug 2026 04:04:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 754F66B00A1; Wed, 12 Aug 2026 04:04:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 57B046B0099
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 04:04:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D7AA5402B6
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:04:30 +0000 (UTC)
X-FDA: 85091880300.04.FBBB743
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf04.hostedemail.com (Postfix) with ESMTP id D6E8140007
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:04:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786521869;
	b=PEjM6KlgLWaLQG21J5USIsWJ1DMDYMIOAmEuym9ZPmKP0GGAxTk2rnc7C9wA5HFb//GsNT
	NBhuxlM8AOS1RGKpnl0ifZoRkWw6YwVG1FH9WcK2Lm0h5mH3K95yGhAHy0tMrpF6/80+OH
	gmC44NgnvBnx2iNQpwoKpviNkMm5Sb4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786521869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=cGRLNUt2bYOnCyZ65XMdyAYi+KPTia9edxQ6pxE3i0M=;
	b=apcF8yTkh764lfbuM0q2ce0JsKGq7mjp+sdm2ztUgQabYWyzCX77ZRi6m3uWoGMQUysszr
	ynzIMwx0ITe+tDQYsjrfCWMNy8KAYxi36u0GFWVWU7tsjfKaZM/6261uKZRzJ1hfT1jbpZ
	wCIzZnrqSc4kt/eiY6OIjKLa3VLOQRg=
X-UUID: 68f77ce8962411f1aa26b74ffac11d73-20260812
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	DN_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD_SPF, CIE_UNKNOWN, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:f8013df7-8181-4d5a-abc7-f90ee12db2c3,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:f8013df7-8181-4d5a-abc7-f90ee12db2c3,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:4b6a447a58e6655fefb8d758e03192b5,BulkI
	D:260812160419IL2I20GL,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	136|865|898,TC:nil,Content:0|15|50,EDM:-3|-100,IP:-2,URL:0,File:nil,RT:nil
	,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,B
	RR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 68f77ce8962411f1aa26b74ffac11d73-20260812
X-User: husong@kylinos.cn
Received: from ctao-book.. [(111.162.215.50)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 14987193; Wed, 12 Aug 2026 16:04:14 +0800
From: Song Hu <husong@kylinos.cn>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH 0/2] Docs: THP documentation fixes
Date: Wed, 12 Aug 2026 16:03:11 +0800
Message-ID: <20260812080313.330413-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D6E8140007
X-Rspam-User: 
X-Stat-Signature: ocaetfuazqk4s3fgrpg9crmrf8ctns55
X-Rspamd-Server: rspam06
X-HE-Tag: 1786521867-583198
X-HE-Meta: U2FsdGVkX19yUq2ebvNQOHIoJ31N4VVb2CW2sZC1sy91Q4NED3/R2fgqo31PZGAQ7BOieJmB5GN6MrL91qtkwjl8j8tFHGu8jFnoaD+luPmr07Pi2jAqCbHJ2tZRaJ5eVOMNm7WRgBTfO6/yLlJw0XwpdIxdmJ5kBliuF2QmmL26K6Kb50VoJjVd8bkAH0+uYwo1EfGlMFdDsXGAEjhJOE62HtNGnkFnbPo2Ozqp80EqpJWvMWJGKuf2LFXxYG8emDTXlixUTaXCeNQAQhny8V0dR8oGGxO8VlAQAo7/o7TmNsX6jOqhWsSCmfVCbWGEK9c5PhJ46EMZCQteteWaq3h97bvzkcqsXzJqRb4mL28JAs4CtGduWjoS7IDCTKsAV2gpmV3EYMZrjc8fq3pgGynwfxiKSUXxyhUdLojDY2dN8lT0QeQFpj3/3bN28av7qUErJuC2TjQI+IA3dzrkFITv43EA4lHTy0sonxAy/nmH3mWiGc8TwwSdPwK+H/lSqiYtp+qcl9+Ak80NKrdw4w72ikYhM/8RWFPAg9fQ3zEUqo6ZWfSKzxby0tKJGvUF3e4oJj8Zbwo4k4X0kqr8o0n4iqLXsIn/6Lk6k5Rn7JlLm2Eg4qnjdmFZIQjkuNy1s4f/PmKVRkm9h/TewjXZyZgXqJtMszrLL16lPcBT5wsRcK+u/CsfO4uvVa9v6YCyt4mMAYMLyb/QQ+pFwTwuAUuuNSNEVcEQn0OH/SpI0k+Gp+O0DxuG80rmkaYyk13mzaW4enxej14G8GGCd9sFjAGZ15D52WHS1T3uhguPv6bxR+Ggi/NfawpSJe1DQVoQaO8QvixTi8W5G7xLMLNMNQ/sOstBomcXn2tSHUUU1cBe33PBlpFuQGdkVgzq9WKiziJjzhNr/p8Kr+ossE10DlCCSuBV4V8+rywUIGzMdJ7TVWmSqD+UgLRbjDjF1zKkkynABY/LDrSxP0KBjxu
 4To4iy6g
 8l+Xt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Two fixes for the transparent hugepage documentation:

 1. the shrink_underused sysfs knob (added in commit 81d3ff3c6f76) is
    missing from the ABI document;
 2. the transparent_hugepage_shmem= and transparent_hugepage_tmpfs= boot
    parameters are documented with wrong policy counts (six, not seven
    and four).

Song Hu (2):
  Docs/ABI: document transparent_hugepage/shrink_underused
  Docs/mm: fix THP policy counts in transhuge

 .../ABI/testing/sysfs-kernel-mm-transparent-hugepage   | 10 ++++++++++
 Documentation/admin-guide/mm/transhuge.rst             |  6 +++---
 2 files changed, 13 insertions(+), 3 deletions(-)

-- 
2.43.0


