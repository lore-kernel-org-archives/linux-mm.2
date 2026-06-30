Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7165EC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:34:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57A736B00D3; Tue, 30 Jun 2026 03:34:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52A876B00D5; Tue, 30 Jun 2026 03:34:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4679D6B00D6; Tue, 30 Jun 2026 03:34:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1905E6B00D3
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:34:35 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7ED9B1403D4
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:34:34 +0000 (UTC)
X-FDA: 84935766468.25.36ACBE7
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf04.hostedemail.com (Postfix) with ESMTP id B3ADD40002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:34:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782804872;
	b=a+2WLRUMjRqZa0TcRIaeS+rvfCiuOvL3OsTmz0txgOWVuc7sxGva9YBjMh1bLhFgTlx/L1
	6gNv7oNX1lBS8sIDF1bb8BOWPz4b8TXq8ijx9ydJ/Myma7dLqSYWF2HFjgYkcSv+LTIat2
	wZtFKymIihJ8WPHkR4y3C6qdNfx6QKk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782804872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DzbZzD9oCLKf5GbzegnkWwqpf7SuSbgzkcn3V+LZI0M=;
	b=Hbr1uTWHZ7wDoJsfq4d1lRVs2PsF3uHRMxPRgzxzmMiT4Cc4dSjVGk6Pc+EZ6Ij4uLGh8R
	NpU9io4xLx7URZJC4Ve8e4aDZEWrs7uPNtECoxw8magaiR20AUd+PLKWYnIBMfqSU5fkIc
	/Hl2+x2IkrjjxAJT2h8J43Qkm/P/tX0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn;
	dmarc=none
X-UUID: 1d893aac745611f1aa26b74ffac11d73-20260630
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
X-CID-O-INFO: VERSION:1.3.12,REQID:e3af7532-c9e8-4ddf-bb7b-c6b11cdb0084,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:e3af7532-c9e8-4ddf-bb7b-c6b11cdb0084,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:cc8ed050b0d6754dad848f30718cd1f8,BulkI
	D:260629183431GR6QZU5V,BulkQuantity:1,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:41,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:
	0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1d893aac745611f1aa26b74ffac11d73-20260630
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 877101696; Tue, 30 Jun 2026 15:34:23 +0800
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
	keith.lucas@oracle.com,
	kevin.brodsky@arm.com,
	maddy@linux.ibm.com,
	usama.anjum@collabora.com,
	yury.khrustalev@arm.com,
	jhubbard@nvidia.com,
	joey.gouly@arm.com,
	zwisler@google.com,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH v8 5/5] selftests/mm: add missing pthread_create() return checks in pkey tests
Date: Tue, 30 Jun 2026 15:32:35 +0800
Message-Id: <20260630073235.3802271-6-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260630073235.3802271-1-lihongfu@kylinos.cn>
References: <20260630073235.3802271-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: z4fbwkoqierwxzeaqtw7s8s5que6jq39
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B3ADD40002
X-HE-Tag: 1782804871-167424
X-HE-Meta: U2FsdGVkX19cMQNVLjTabDlzZTpHTJNXmNVcFu2O+7H2E5ZIomqhDpBlwDvf185aFd0JogKhB1iDFTDY63hRwJgHBrr04kb2PqkKVe8UotW/MhJHnPlXg3RPDsVt/yW12OZhOZQcRtITl/b6Cc6Ob+yM9wtAS9vbq/05eWX/F4/YPGxvnHBZQyTEkAU5loPcmZBfAlqjnEP3EC6RQxlegk+3FlkfwmnBau+J9YsCP4wMdtuV0zuhhtDrRFljvIsqmIrV8dBqSdFcuqmQmfkGfayLDDVaOAk/7uHHX+NYrR52RZsbYX0kIPBslY+f5U6tBetrlmUUmI8l7hvNQnkFH4I3JUkVPz3aWJC/bgkaPFYDpens/8Ed9IhVbn/Gr1/PLSvb9B53MJrZDqiyOF9AuD8oKp38+5kGJerixVGXLhmOuj4bjJv0d8SIx/+h1dVVfznCGx/SIqLIh65cTxG/F/4B6cPOGeYUVmpCeqfKJrt+to0/SjNqBavbU93Rp7CC9NdWgmEg0wF/yXkT9NttZ9uzc7BK0ZCytowVejO08SA4rRf26bipjPndAFn2oi9EnrVHlq2edkjzkBu6bNTy9e7WYEoRzmjmi0TbqOeGXqTJi3RWUta6B62o8SnZtS2WbtRG8QeCG7JZnPeDFjQdKcFEgWbh8ho8TwolkQXS758Yqw1nrhAKI4zbUi5wrHJH/a6POsvKOt88iEaLfExQG6QcQR4Wc0VsFk1WOal+BfJajZaETgcWoFcJ5Lh57wUgzFJH7gt+S/jFrr5G2uisgwyr8NTe5igkpZLo2YOqyjTcbldoE8w9YrZJFkaC5Bw47PGCqFQX0+lGs/ZY3uGwmn/teUnSGx+DpXk5Q6IYtrRPJvyZN31gX1PdrZGOhHk5yzFxBO8SvNFf46rfbNMLhSSbbDwoNn3z2qoN4qbpoaWeBHLS7FcWPQdovzG7X/kuprxfWtTcDMgpGty5v0A
 ukWA4ch5
 ebnYB5518baS5Ghm8ouRXjx9uN+lHBI8EX7NJaqGydDBpYQXhTNutH/GT6g==
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


