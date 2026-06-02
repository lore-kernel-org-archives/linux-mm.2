Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40B2BCD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 07:01:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A802F6B03F6; Tue,  2 Jun 2026 03:01:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0A456B03F7; Tue,  2 Jun 2026 03:01:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F9E46B03F8; Tue,  2 Jun 2026 03:01:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7FB556B03F6
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:01:32 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 512D21A0804
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:01:32 +0000 (UTC)
X-FDA: 84834076824.01.CCA9A3C
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf26.hostedemail.com (Postfix) with ESMTP id 51FE414000A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:01:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780383690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tg/HrCXTfMducdMWvKjXOqr+HfcD3Cfk4Jb11bsmKEY=;
	b=3Ff9wiCXfAiorXB7Tj0g+x5raAc/x9qBg/aqNqTFU94/EkhkADu6GNk4Ofp/pwCaCpPheQ
	94ofd9NdOrEXNDBntYX4pOmBqLAiGXAxfkWMNvj4OIy8vnnF1ldUWR4nRS0gH3Ux7wpRfh
	jTtzVq8gtd72wBpyvnynro4dHjWjdog=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780383690;
	b=kiJ+N8LpUIIS8BkbnuCMw+VWZV8IQ54zr9/oVP5YGkBAOiw3qQq+Op4k1Pry2rD7ow6xXG
	V6LQebd3p5MpX8ZXyaKRwQpgNnvFjR9APeQvsQt42tZubeKLAGLBBPC6a14k+nqVBndd9H
	KtHAi8xHvGtZrgQfDuYZWQLLD047Jr4=
X-UUID: dd1643185e5011f1aa26b74ffac11d73-20260602
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:2ecbba3a-7ab7-4152-bc62-d9f6de53d407,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:2ecbba3a-7ab7-4152-bc62-d9f6de53d407,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:c4300c857a7c370f3b1234fe22f7ea71,BulkI
	D:260602150124O4N0VTTT,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|136|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,R
	T:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DK
	P:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: dd1643185e5011f1aa26b74ffac11d73-20260602
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 148449013; Tue, 02 Jun 2026 15:01:22 +0800
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
Subject: [PATCH v6 3/5] selftests/mm: use pkey_assert on clone_raw failure in pkey test
Date: Tue,  2 Jun 2026 15:01:17 +0800
Message-Id: <20260602070119.1452308-4-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260602070119.1452308-1-lihongfu@kylinos.cn>
References: <20260602070119.1452308-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 51FE414000A
X-Stat-Signature: moayr3i4rzmxgr43kjzwemnt5nqueuo9
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780383688-647423
X-HE-Meta: U2FsdGVkX19VXGoxcdAfkbvdC9OmIS+TJC+MLZl1mD1pBWWQadHEoCfC+wzHgx3j5qfK4A+8snlMVX79GJaK6JVjUPkEaHw+YvIv/sMmABFtSbEe/Dngv2dsJo4j+WJyJ/NNzcb7FL19mK2Wig9tyJeHGXeXtu1ybETWM75vkgHHCB/9h9aBK2Iihnyn2nIm435CboqHUvPjE6IUq5s3WNyErcFk21GuYP8xAVq5oyNS5psJuh9wqJGxUSbXSbz4AIQytWoP5YRowXE4DCcEz2JKdT0YsmCmGDhg9u2CwAjGR0kmB4bRWKdUGVDg60UpjeeYA6eCM9JNWw4plrqOMJE3/p5/bMgXT4K3j5kWKDpvROfn/Rho/CVJl/frD2o3vQojxvpNAcDLkRDYltuK+ko/1ox2U5deb7Kmbfz1yAFBcj6SgRqJ4jwTDMqPLxuBWlgJkjD6DQLHxG0FIMvsEqeXOra2koebrfZafFdg6KOqRI3kBgu1JHFVtMY1BBZdE717ebskVNlh1M7Ht4qmju7XvQFB0hI/SFIIOf5oc+urp+yo7EJ5nUvcKmyHofr5agj8Vmtu9608pciMfLEvTLIHmTPRsddPO7Y1FU7dU6CeA0Pp7t1PQ/TFpK6xZZsVlQdIXcR+38PnlXaBsYRwDxRALChYldUxQejEL6EtxwPdw9R0ZnglklkqzQ1+Rpd2A73NRoXFUp/ftSAu+O5NwS5n55ru0Drw9BcP2XQow8Lz2N/G6AHbP2S/twVFpi2FZIot3mUpP81RlOslvYl5Rdiyi4GeoBjIhNda1Fd7GcZCj2VowSMyIhMVjPq+OGIiq9gQ/qo/OA7GfZ3EVkpYxo2j86bsIii3M99xpaBUnYDzKZ6UzYX+wfTI0VrRPvkl8LRnrQxmoRbX76ErlJwIHOMQVTJROfKMi3Z/jiwgUDbOjnmRr7aqWgKdPTjWDNBvqxChOyMVEmS9OGB53ku
 d4gis8if
 wwMdJz+hQrtDPZG90RQmRjrWXQ9svhIN/F0DaJ3R83tgf0SLVKZ9CDhSB1A==
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


