Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08681CD6E5E
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 06:20:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2C956B0282; Mon,  1 Jun 2026 02:20:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E06BE6B0285; Mon,  1 Jun 2026 02:20:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCC826B0286; Mon,  1 Jun 2026 02:20:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE4DC6B0282
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 02:20:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8690F1A0584
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:20:37 +0000 (UTC)
X-FDA: 84830344914.02.C5BB6C6
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5727F1A0004
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:20:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780294835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gvd4dvYCQ38vPo7raY/rxwBbvL7h1sbXgHIbIfAdpPk=;
	b=L/5VuxQSL4EYXdwHHpx7CGSsnk19cQFh2njkdAdRltAqcWnmcvhi6Ehv6F/vqc4rbNNpUg
	dlE1/FtBj9uYrb3xBnjojRuqryVGDE2MamhpMDU9P3fyuQCLvFlv09AZ/C+VNtf7ntRWHl
	9e11a4iWFc4p8znSjjOicffEYvKwV18=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780294835; a=rsa-sha256;
	cv=none;
	b=VnstZ6igKLs7e8yPdvFMj+260qxh0GdLupe2DRbVedg99h6zPIaXHlU3uN/9cpZOPkLsYL
	fowT+o9XhCcZhlScFcjpcasVn35X1fIH6mR+OWYVA8G0sxRKcamh81RyeF8jPp7jtq2Dss
	P9xW6JJJWtyEvuKTARm4QTZZ3xLBODQ=
X-UUID: f9ca4cd65d8111f1aa26b74ffac11d73-20260601
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:6770480a-6d99-4640-8b4b-d49af257fb5e,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:6770480a-6d99-4640-8b4b-d49af257fb5e,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:a843d2c3c1310ae75c79b190e4c9002c,BulkI
	D:260601142026HRCU1D1S,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:ni
	l,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,
	BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f9ca4cd65d8111f1aa26b74ffac11d73-20260601
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1430660042; Mon, 01 Jun 2026 14:20:24 +0800
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
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH v5 3/4] selftests/mm: use pkey_assert on clone_raw failure in pkey test
Date: Mon,  1 Jun 2026 14:19:52 +0800
Message-Id: <20260601061953.696844-4-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260601061953.696844-1-lihongfu@kylinos.cn>
References: <20260601061953.696844-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 9zu5wjk3un6cq894hw1qy97w31ppnbqm
X-Rspam-User: 
X-Rspamd-Queue-Id: 5727F1A0004
X-HE-Tag: 1780294833-33217
X-HE-Meta: U2FsdGVkX1/FVJNXlJuWbhf6PyWbiLDUwSjO+cNG+XYGVko/Fxs2o4YLh0DUUyUr4TjZmWDPsK9aoKR90qTDuoLvhN9TtYZtGwFe719Cm9MpmoUlutxxMMCVFkAap28p6AN2EV50e2Xj+hebEp6jOJPrGEjDhc44dgZF2uDosTEsXVPSiOlm3cfOIuKRGGXevUGBoXZUdra5+zzwLq9aqWydVQbScD134vSZvGgxIWwS4CSIu1Lah6ynsnzBykZwx6W5ti6uCjUuBhOSBMo8vW8RBomBe8dUOY5KqxYDZ9jDTYjqNxsvE6Rj1DgINPAQ0pRh+RpGkNa8WtunE9AlOpy1wOeMtmTt5+rUgGkPyAw1Zdemmf/hzfSuuWMmKKranBCZI+M0ugccFdBeiaUcCWkt387lDQmDSEQHn30vBRLOZpWpDWwyf6dYjfHvYE++FxcHcpeo7NbxxewEO2QiaoADZ4haf8mOmfs1OuyAE+n4ccgnFL8cpRr9HDa7PCiYWz110rRPb04z2A0/c0PgMZnWFELI7k2zcEXnux8tNyOzfv+D2qEV3rWbmVLFRGLO/TTvLC8ZK81v2UcKc1H9KC51XjWNaE9QmjY+cEbtuPW25GEx0qp27nYJQfXfFggUvHYLLLGTkZTA46bJ1aARaOcyhdF2hAq7bCsWFwMe9ovxo4QxJaBKKSW4M8Slylj6PX+xkROOuYfpHrq6Hgc6MmsklHpSwDLigxKWm+mbqFb++rhesgMN4IBUyMZUryBcxwA7Zvgx1nDeP9yTqJikAL4BvpTd5eoRrlWqgaaTxCph9tuC/c8vt8D9xyZ9UpiHDu5KgzOUMR7QefR55pJ6l0rWBDgwblyy1Ob5qQehE0c4F/hh9b5LgP0uc/b7nq3AJ86IDM+DtSjIxhEvV6muHLYEb1xghNbxoRf7EZGXrj3MNs/11RzgmAn0YRZ1PMYaQ2RX83iA4jTB14gMwgS
 x24ONNj2
 1LObTQX7a6M1V6b29HnqOuzPDQ82plQemhE/0JHKhGxY+t4M=
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
index 4438d8fb8ef8..9dfbe09cd87a 100644
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
@@ -500,7 +500,7 @@ static void test_pkru_sigreturn(void)
 
 	if (ret < 0) {
 		errno = -ret;
-		perror("clone");
+		pkey_assert(0);
 	}  else if (ret == 0) {
 		thread_sigusr2_self(&sigstack);
 		syscall_raw(SYS_exit, 0, 0, 0, 0, 0, 0);
-- 
2.50.1


