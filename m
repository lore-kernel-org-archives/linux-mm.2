Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6304C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:17:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 266876B00D4; Mon,  6 Jul 2026 04:17:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F1016B00D5; Mon,  6 Jul 2026 04:17:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B7E06B00D8; Mon,  6 Jul 2026 04:17:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C59386B00D4
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:17:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 551B31C7BA0
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:17:21 +0000 (UTC)
X-FDA: 84957647082.15.0886FF2
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6F7252000A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:17:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783325839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kdcLA45BkU2NpOqyTedJL1liMx1BIgC2J5kM2elUfu4=;
	b=DJtg4smdw4y+coRblGgcwVGoa1QHvax2JIjHFW7GqKZbfYgnIDigjj/1iZUpWjDo9TyYo9
	bKbwB9/NpP+Sq/rarpHdmt0O0zZYLB363IrvZEz1iv66+cdjYjWlu8cG5dj5XNbXkiB2HJ
	EcTOu5ihlvU2lgs8AKKZvTVnzfggwMs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783325839;
	b=aJz8Xr1NMuQIvvUarJk1wlrsFw4psTiNXTEfM2yDdHD3tMbbGpMoYQDSdvH/1nM2xADbII
	SqNGoenHz3Z9WBJrHdr43XKIblSIY3ErBDogTp2oaPjf7/8LwDDbERR0zNtqDi99C7/21Q
	EcuWKA5N7ng31Ua26sqoJoNwFVC+UBI=
X-UUID: 1828e424791311f1aa26b74ffac11d73-20260706
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
X-CID-O-INFO: VERSION:1.3.12,REQID:0ae2b462-829a-40da-b9a3-77c2fe3aad86,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:0ae2b462-829a-40da-b9a3-77c2fe3aad86,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:e50f5e6f561ceeb78c78eac4ab826e38,BulkI
	D:260702142446XLDVC4C6,BulkQuantity:1,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:41,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:
	0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1828e424791311f1aa26b74ffac11d73-20260706
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 858262029; Mon, 06 Jul 2026 16:17:14 +0800
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
Cc: jhubbard@nvidia.com,
	joey.gouly@arm.com,
	keith.lucas@oracle.com,
	kevin.brodsky@arm.com,
	usama.anjum@collabora.com,
	yury.khrustalev@arm.com,
	zwisler@google.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH v10 5/6] selftests/mm: add missing pthread_create() return checks in pkey tests
Date: Mon,  6 Jul 2026 16:15:59 +0800
Message-Id: <20260706081600.3570203-6-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260706081600.3570203-1-lihongfu@kylinos.cn>
References: <20260706081600.3570203-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6F7252000A
X-Stat-Signature: y5kzruidakaz7ofd6z1jtn7qf7x5msft
X-Rspam-User: 
X-HE-Tag: 1783325838-276789
X-HE-Meta: U2FsdGVkX18aATfgWXpbTE3ESeANJbGhrsMEzSisbnYVwoKvYsSTDJvuq84mmALtWE/6GrQntcM3TwXM7jKGUWvIADlp6p0O0JxxuWgrMCUmVpZh2lVC9XVPhuUu3CyP8/eauRZITsocVxxJiOF2OQjgmpsZP98RwTIyhQf1E8bV18y45fXHCpeJDPMH6gVoEbvixtH3XUMNQQa7O2dEIbYF0vBQWkJ3E3pM2qbXLDGn1HLkitgm7sPxzpCIkgPkJ318uqr9MTr2Y4wjuCY/HZkO3KBRjT3GCudFHdiqWvGIbGKQf6ScQwtmflcCTCgp7PsCFWqbbFPh70vbsCUCNhg+dygXvc9m/7bi4Lgzn0q30t/OrNZ0LVm9rfQE4xH+85J1Ehw53xVBihD4XVs8iqfHO5dJkR4lNoVqIEIYkzJugO7c0SNhEBS0Lk2Md5ei8nc2FzBnoWbxDf6BUr2/w+iEomvbNXIn9pqHgJMo6/amahIOs73TZVDtSeatQ4V3B6BgougxgLJPZUV6vFhTcVE6fWtQWeJ+S7cPqguFkHmkXTbU/FK68mfed6KUH29PBrQu1wqZuuLopHC3S5ScSvgv5rlD5njb0uWN7tPDcK2qwQCHlRlIUOcgs9AQ+dzjQbpN0+r1B5AJFXzlX0t7FvZEmXQaKa6SOmrrresn7PR16Rhx2ezR4FBD8LUF2iqbFh6hd1wuH7zdfzajG8H9ufjQWuHTLCMQ98HjL9VaEyQp+l9/C+Tm3WxXVItwSHQuE6gpFbQsiyky61Eh0GDXTztvAuKvWWYUeVJVYfP4xWfStFj19WLIXdYGOgi+H4R+jRXOvP+SW0uKQg1WZ4cftVuDe+jcUJA72kepdc/Ix9EyV+kY/8OTERM48O1mMW7ebU/MvZewP3VxMUH8RbC5oZseyE4pRtmMXcLqtcKpN5zbsox2atLfduWLjkt2MCh5O6pBFkUmHXgiYC0WHtQ
 6npLuUmL
 iPIfZDml/MQYje3KeJYVj122q2xeVJoYuMt4d21wTiSzlXsvg9qT6bTyB8l5pQDZGiCRrDDOTyOeJxsrvlCQguj7KRswKyFC5VSL/p4QtPAlY4t3RAWypdA89Wuk7xod79xAoRFG+oRxLscq/gDMcD+i1ajTmh3JH49J9KrZdwtu/fxn7ULFLFtLuUjQGFI3w1gJH6HwIG+zsXss=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add missing pthread_create() return checks in pkey sighandler tests
to avoid hanging in pthread_cond_wait() when thread creation fails.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Tested-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 tools/testing/selftests/mm/pkey_sighandler_tests.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
index 8f98e6d9349f..cbc24d6cf770 100644
--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
+++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -220,7 +220,11 @@ static void test_sigsegv_handler_with_pkey0_disabled(void)
 	pthread_attr_init(&attr);
 	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
 
-	pthread_create(&thr, &attr, thread_segv_with_pkey0_disabled, NULL);
+	ret = pthread_create(&thr, &attr, thread_segv_with_pkey0_disabled, NULL);
+	if (ret) {
+		errno = ret;
+		pkey_assert(0);
+	}
 
 	pthread_mutex_lock(&mutex);
 	while (siginfo.si_signo == 0)
@@ -259,7 +263,11 @@ static void test_sigsegv_handler_cannot_access_stack(void)
 	pthread_attr_init(&attr);
 	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
 
-	pthread_create(&thr, &attr, thread_segv_pkuerr_stack, NULL);
+	ret = pthread_create(&thr, &attr, thread_segv_pkuerr_stack, NULL);
+	if (ret) {
+		errno = ret;
+		pkey_assert(0);
+	}
 
 	pthread_mutex_lock(&mutex);
 	while (siginfo.si_signo == 0)
-- 
2.25.1


