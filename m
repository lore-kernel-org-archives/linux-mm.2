Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE395C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 10:34:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58D126B008A; Mon, 29 Jun 2026 06:34:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 563EA6B0092; Mon, 29 Jun 2026 06:34:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47A7C6B0093; Mon, 29 Jun 2026 06:34:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 162FE6B008A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:34:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 94C451A04DA
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:34:32 +0000 (UTC)
X-FDA: 84932591184.02.9D86565
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9935F180006
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:34:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782729270;
	b=dj/FRxP6BtYugwKnk0D1g3KsdMfper0hY2eq9L08piSpl8sKTGoWnmIkvuHLQYFZDq6BQj
	XhuS6GDi+T2a1YDbNeJJzr9xRCTgcn+KQSsRLC7o+VTBotOYy8CRZPFNkPXjjVSk3DqFpb
	eDlxJp7FGH4DOvBy1/UC2sJENOQnJQc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782729270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tg/HrCXTfMducdMWvKjXOqr+HfcD3Cfk4Jb11bsmKEY=;
	b=vjN6iLYFpJ021j5R6U017+LncTQvuQqjXngXtar0rAnuLxKbpLAbMQSt19vOGMx9s4Nd0x
	wYaR/GFxNm3BzccWtSH6vsKf5NvcAAiABFd/qLH+AIefmCnsuKUGTwGmLknVbHwMULNY/T
	KiQimzi0l1F+jZ9xRuCDlqKbNexb5bs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn;
	dmarc=none
X-UUID: 180cf5e273a611f1aa26b74ffac11d73-20260629
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:bbc41cf4-b6b0-413f-9f99-7b40037ac36b,IP:20,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:15
X-CID-INFO: VERSION:1.3.12,REQID:bbc41cf4-b6b0-413f-9f99-7b40037ac36b,IP:20,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:15
X-CID-META: VersionHash:e7bac3a,CLOUDID:3e27d9790de35dd5862d709f2b1aca60,BulkI
	D:260629183425GAVKERIR,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|136|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:n
	il,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0
	,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 180cf5e273a611f1aa26b74ffac11d73-20260629
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1093277424; Mon, 29 Jun 2026 18:34:23 +0800
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
Subject: [PATCH v7 3/5] selftests/mm: use pkey_assert on clone_raw failure in pkey test
Date: Mon, 29 Jun 2026 18:32:32 +0800
Message-Id: <20260629103234.3240178-4-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260629103234.3240178-1-lihongfu@kylinos.cn>
References: <20260629103234.3240178-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9935F180006
X-Stat-Signature: iuq6gf7ot9yuisn8u69jn6kr5hjzg3m5
X-HE-Tag: 1782729269-311565
X-HE-Meta: U2FsdGVkX19M1Pb89yhLTvjJC5gyVnmekZ1oX6Xxb95mteGYn3mfKzUoxsT4v0XFmjc7QWe2v6owVoD45gc/TVrUnbHvr5ZQBWX+b+7+6FqOzBk6K1PSxa1JDtPy/FQquG5Ts3FznB3e3hNuECFxlRRqjiqfMc06Swx3WhWBKlEij1iIfrCesnXOAOccxMPMmg82S6zzw3cffnnZutoTCegfBiVHdb1SCtCLC7tD7ps8jXbexjU1OQ90yEVBZLw9uonOZUHQw/jYX9ZOv3pDOpV/wnGxRE/3PW8d42EaHm/pCx2ZtywIIsli3SnOAtlaBmwZXz8daQTjozVSqSwhSQyVE/KNFTfDJhaQQvHNsgS5J78GgWtxuwr68HyhYB3bsAqEH6eiA9CWkDxAXil9fb9vr3pWfzNNezfeGAbYYJH0V6v7feWt6dwhy34ZVRv5hsyVoWuTto+KhwD0+j6fWzq15Hi640CAadUjw7RDUTRkzoxC/WXtZcjpwEB236vutjO/3bVWsaKNO86kcu4mgWzZv8GFIM+vueMuSYw6gPbn2FgC8AuPU6Cb3avSk55f/6erzN0/ebZZ8Ei+rZXbEsnn8iJu9AlZm7/yWXPmxr2hdEMj0+0PH2O1kLRs7ytv7x5Y4wYoBJ8fLS8OfDH71AqCxMZd++pYuB1vjhlE6hN0QOMEH5OQwdG5uqSpAABLIBgiP6trvKTeTBuy6g2zm5ZFLXlo3gR3b1UZdFf/ZAhzTbhBPQIsMrB8h7XvBldXc83mgYYjnL0EmKfOAzUrWT37nV6fCoOu0tRjebTduG82xtWVyMVs4DZBw2Y2W9Mq5pPVPX1DSRdKlMw4dIeVrUXqCbLQ96sPWNkmFDRHTYxJo3a+BVp2kIrQQrgBQdKmtrOgKydlYxbsHJrlACbTGmMMK4m9y+obMUcz9vO5TzmsFLFITzxwWnl5XxHe/wFFcKo21xhAbRRPAV5bvzQ
 sKn4Kr4q
 JKSn4Pfh5hjWKc0P29c56vFu/cPAw2ls+X2bX+I/iCKyazD2BCnplwAyZCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use pkey_assert(0) instead of perror("clone") when clone_raw() fails.
The old path only printed an error and continued; the test now exits
via pkey_assert() on failure so it does not hang or proceed with an
invalid child.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 tools/testing/selftests/mm/pkey_sighandler_tests.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
index 085e771227fb..882928f2912b 100644
--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
+++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -333,7 +333,7 @@ static void test_sigsegv_handler_with_different_pkey_for_stack(void)
 
 	if (ret < 0) {
 		errno = -ret;
-		perror("clone");
+		pkey_assert(0);
 	} else if (ret == 0) {
 		thread_segv_maperr_ptr(&sigstack);
 		syscall_raw(SYS_exit, 0, 0, 0, 0, 0, 0);
@@ -506,7 +506,7 @@ static void test_pkru_sigreturn(void)
 
 	if (ret < 0) {
 		errno = -ret;
-		perror("clone");
+		pkey_assert(0);
 	}  else if (ret == 0) {
 		thread_sigusr2_self(&sigstack);
 		syscall_raw(SYS_exit, 0, 0, 0, 0, 0, 0);
-- 
2.25.1


