Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A50D5C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 10:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 517056B0093; Mon, 29 Jun 2026 06:34:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A0F96B0095; Mon, 29 Jun 2026 06:34:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B7316B0096; Mon, 29 Jun 2026 06:34:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F04E76B0093
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:34:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 788FB16803D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:34:41 +0000 (UTC)
X-FDA: 84932591562.05.9D7254A
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8B8E740007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:34:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782729279;
	b=oc7JeSp1YnTceNUMxErtIquFKnc89WuRmQ5STs1wveplglE5+91qxqvkv2/Th++8fnYOaD
	q+zvh29okCeZqCcn9D5uYZQd/UuGRFFDFwolJOOX1N8l/6kj3MiZUa6x+Nov9TV2dYjj7u
	UCXA0qNyBlYMYzOpcvZSttSg/um9qB4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782729279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DzbZzD9oCLKf5GbzegnkWwqpf7SuSbgzkcn3V+LZI0M=;
	b=f+dhnzaJeS5uGGxl58+WAcu0VJvyWvQtLIEdJDfiz3Qy2BvTBz77TNiJItqW6qn2uIMFxM
	x94eUdPHcuMktog8K77ku2vjmuy0y39P/Il/5TyXVllzyGtQatKqSrIELR6giJcYcS+fa6
	+d2HYKat9OeACuJigEn8M6iI6rYt7Yo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn;
	dmarc=none
X-UUID: 1ce9c00e73a611f1aa26b74ffac11d73-20260629
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:e0649962-9711-480c-92db-ab88d0353521,IP:20,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:15
X-CID-INFO: VERSION:1.3.12,REQID:e0649962-9711-480c-92db-ab88d0353521,IP:20,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:15
X-CID-META: VersionHash:e7bac3a,CLOUDID:ffc179acd9899360deca4543f391f70b,BulkI
	D:260629183431GR6QZU5V,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1ce9c00e73a611f1aa26b74ffac11d73-20260629
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 239359457; Mon, 29 Jun 2026 18:34:31 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH v7 5/5] selftests/mm: add missing pthread_create() return checks in pkey tests
Date: Mon, 29 Jun 2026 18:32:34 +0800
Message-Id: <20260629103234.3240178-6-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260629103234.3240178-1-lihongfu@kylinos.cn>
References: <20260629103234.3240178-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8B8E740007
X-Stat-Signature: 4cpt7nc9ksfcubn3s66wnt3oqxnachde
X-HE-Tag: 1782729278-102029
X-HE-Meta: U2FsdGVkX1/Jb5iKmUQYUaMZ9acNoM9C4o7pdQMFtXTjso1+5r+LucCt/93YWgdxKcwy++/3O0sb2bovWDNUZ64QJdy/LcPm/lh8aeG0YQxXEX3H0t62owTwoyR3x2ulCeLpSyWJvCOVaI9srO2lVB1OU+GDVlbWsPmwf2qOnO3mScAYfjstUKenRY8Qe0sPbU1YH3satW9owCzWWT5dkpC8B7BruvlBtB5JfLQ6SuNrkQ3TQ/VrntlneKqah/kWd2P0MeFZmbNP45m4acEslh8ODCYJKh7lXXIWiY+SF2c5WJjgMu06gicyTU/7SzpujXi6caJH67r67f1TkWUV/FmxT/gY98wYXY7Iw3qgK88YLrodbIU5zGLfpXgu6pTcTAOMO770SvqYSfqnSpHKferiQnyrpEgU+XeJOBoGz+qD/hFtAxtIdOuemauvYFYVUei4NMGR/ALi23I+359wux7Ejr2yF8e/SHZwCSL3UdNsJgWEKD9MOgCMOAD+07/hVQaZVwrDCehA0miKAVv5qxyZFLO9BJlwqTMxAKy3n7vsvNOJogCy77v5tuFx9l5j6jYWDFlEVU1ckjsQSvx3YXMMIuz+rahj5fAS7BUOJp2FaddQ6OMtKreQSY2nvAVJpk2V3PfSMeovN5TwYORLbl6j9XAA48z8b0jLm0wUR8FX+Ewn8iMLIBry1MD77YV/2Sy9n7ixsN48qmTdpZyEdcZn4SVQ0VL8W443bpI4MEsoM+BZvN35R0OdCggefhYhyw5SlvUMlSSiIFDf/x+iaNK4p6V1923FLE5vdHrRg1FVty8ENIWLtsXLFwIk0XH43ciVCjRRySfacR7WkwGXH03Upid5fAQbfPOZ5LfMp7qpcw28ETLSqD6lUOjx1+BrmKAsRiY1r4xqBjj9cnwV4ltSywKqj/x0jWCvV6Os+DchXys5MkXq1ge3xFTyioVB63xgQMH/Elh0zPZjpB3
 ZEOr2TH8
 +8tLZgBuQT12YXg558hxkvV04ydHd59ToWf/uw6aRmd0KFqwvRlMDMELMFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add missing pthread_create() return checks in pkey sighandler tests
to avoid hanging in pthread_cond_wait() when thread creation fails.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 tools/testing/selftests/mm/pkey_sighandler_tests.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
index d185d3da26cf..f30c9965a561 100644
--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
+++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -224,7 +224,8 @@ static void test_sigsegv_handler_with_pkey0_disabled(void)
 	pthread_attr_init(&attr);
 	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
 
-	pthread_create(&thr, &attr, thread_segv_with_pkey0_disabled, NULL);
+	ret = pthread_create(&thr, &attr, thread_segv_with_pkey0_disabled, NULL);
+	pkey_assert(ret == 0);
 
 	pthread_mutex_lock(&mutex);
 	while (siginfo.si_signo == 0)
@@ -263,7 +264,8 @@ static void test_sigsegv_handler_cannot_access_stack(void)
 	pthread_attr_init(&attr);
 	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
 
-	pthread_create(&thr, &attr, thread_segv_pkuerr_stack, NULL);
+	ret = pthread_create(&thr, &attr, thread_segv_pkuerr_stack, NULL);
+	pkey_assert(ret == 0);
 
 	pthread_mutex_lock(&mutex);
 	while (siginfo.si_signo == 0)
-- 
2.25.1


