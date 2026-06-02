Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8086FCD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 07:01:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9FC56B03F8; Tue,  2 Jun 2026 03:01:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E50D76B03FA; Tue,  2 Jun 2026 03:01:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D15DF6B03FC; Tue,  2 Jun 2026 03:01:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BA3A66B03F8
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:01:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7891EA084C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:01:37 +0000 (UTC)
X-FDA: 84834077034.24.F408BD0
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf26.hostedemail.com (Postfix) with ESMTP id 86FDF140014
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:01:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780383695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DzbZzD9oCLKf5GbzegnkWwqpf7SuSbgzkcn3V+LZI0M=;
	b=t+4kIH0TOUfIIS+XB1F7suWL8UOK47plDDhn9nC+x+q1s60Ts/jmkoh3yKRt3JniSiy4Bz
	87smWONscPf6oB9NgG/hbLGN5STMt4y/7yNE/afLf4xrvByf71gGySJ0Kdnlf5PSreQ7wV
	rNVXg7wNoP3QohZu+pPhalXRgT0z3ao=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780383695;
	b=T/zUN0fRFRT10tFzf9uIQcjp6okwvZBWA1UTACcckaqmdARKJWlQTs8yvvnvq4Dq+zX/vR
	xt76EvalDGQXYpUzLQoGVmJdpGRTJp0+QcghrGP4+cvxzBTrvZeKeGW4+wKa88+DOBMh5t
	atUbD0ZAT3m8lOzofZ3YemTvadT+fQM=
X-UUID: e02bbc7c5e5011f1aa26b74ffac11d73-20260602
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:549077d5-bd28-41a8-9020-6dc2e5d020eb,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:549077d5-bd28-41a8-9020-6dc2e5d020eb,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:ad801bb9f6dbb48635de2fd65192f5b9,BulkI
	D:260602150130PCANUYKE,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:ni
	l,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,
	BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e02bbc7c5e5011f1aa26b74ffac11d73-20260602
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 776362238; Tue, 02 Jun 2026 15:01:27 +0800
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
Subject: [PATCH v6 5/5] selftests/mm: add missing pthread_create() return checks in pkey tests
Date: Tue,  2 Jun 2026 15:01:19 +0800
Message-Id: <20260602070119.1452308-6-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260602070119.1452308-1-lihongfu@kylinos.cn>
References: <20260602070119.1452308-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 86FDF140014
X-Stat-Signature: ywsbwm75fc6z43dhowno8qpzt4ic6w7x
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780383694-184938
X-HE-Meta: U2FsdGVkX18p7ZGXE/2YTW4XDO2470eL65ot6EGt5qLoLK2rI8iwNTaUJieECGVqmZ39SR/UsZ3e0SFH5jmY6uBBF4oUxI0qKyvFkq7M6Sc+DlzTF4TX9QK6yGFlBcqz1Ixw0nanSCEXbaaNSRtHYk2exBXF9HbJl1mDWODZHqduEZ/J+qw9Sy+b2cDZX7styCJrnx+1Vp3soZlY8RFQSGuMeoBhbwDBygjVXTX0VIwUBtwOHPo4LKIn1rarhit//xqjQ1lh0XJC3IQQH2RKxxHISRFvAy3u4v702VrIn5+EehKsvhxV1QladI8VRnynL24Sysu0fy5sxOWN0rsucPcT+tJz7KfUxbP/y9cBFgI4aLPJ4yEnpsLJvUHN1o0RdqLhvQMgqeKEyxfKZ2t5wP+ybSna9wA8jQsS9zyr6qf3YB9BoqCuHBYe8XmUqaOH1gyS4NX2jpwYge1801viplbCIUySgPuzxZVx31J390uTC7fKzGVdre+5UEWKEGJWr2vcAbQ6BpkoG2vf2nvdJyrX1YL5gB+1wKlzV+2w6SD2MyXEFEQEfKUtcnNGjFyACweZnAdWXSJc+SLgJyP3DWSXbJAkL4jVSOdxhsnjAz2KFwz+wpMtGXyjFXV9F6mLEYc2w5LVHPM/zBmy1SXkMnUZMo6/0oD+b+5AiGHO2P1lvSFoj/2RvIWw1SfsM76LO4dSZ/olTZdWyuIxaSXwBTMagnTcCE+IQv49JscTbcJ/wggcCEXBYHmu9qcjSGYIuQN8KpPnX9C0VTVZrRkz/RTRO3Vp/XWUsCEBX2mLI6ZD224YAy/jEdXYjw7wHV7iKP/FoSTD/ZIIZdjyoO1JJZ0rtqE5XpyTs987xgbTakaepirvuWNhTS591KIRSC3sigMhn7u1d4fLzzcLzJMcer5lDg/Sg++DZUKFA39dhwF6p8gM2TQx7lr4gk/k/00BJujhRqUeHLT+N5vdDYY
 GPuWdgIM
 rLHQXRBkjS3glZEH+KYac7xQIrHX1/U+/FRc4C2VqResZ6N5Se1IafFzKMw==
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


