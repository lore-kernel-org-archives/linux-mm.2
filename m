Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90BFAD12D4D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 11:57:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB74C6B0088; Wed,  3 Dec 2025 06:57:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E68A36B0089; Wed,  3 Dec 2025 06:57:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D07E76B008A; Wed,  3 Dec 2025 06:57:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B5D756B0088
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 06:57:27 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 86C22C05F6
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 11:57:27 +0000 (UTC)
X-FDA: 84178009734.07.240B14F
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf15.hostedemail.com (Postfix) with ESMTP id B55DEA0008
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 11:57:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764763045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uHe/eclSIS79H3UijqUmU7apmvJSowh+9P7597mEMO8=;
	b=dvRf0UCbCzIa4WCOLEFqy52OLuup2GUH+3SbPJpW5bbLyWlFohQGZ2C16KlJ78/rpyp4Mw
	hEepLRdX0rdPQ/1Mbw+k93eNvOdZ+Z2qKV9Eb0CiJIRTrEJmBGJztZ6i+LUktGYSHiNYhm
	Dk6DJJgifAP6pD1nwWzH0eddJPPo4E0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764763045; a=rsa-sha256;
	cv=none;
	b=jFnsRfi2A5FV1AHBjx53H2Pqzi3+aImmsYH32UPmoa+LISdj5GwvF+n1/DfHXGtOpJMDEs
	mJW0BM42OMgw5TBSsJCgwHHAD6046xVbdYjZrUPJfA8HHLJxCdXVKnqUeDOITBs+t1lshf
	ryGj87ynRUQwrD4fHDaLTzV1GGn2bhU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn;
	dmarc=none
X-UUID: 3665849cd03f11f0a38c85956e01ac42-20251203
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
X-CID-O-INFO: VERSION:1.3.6,REQID:c995dedf-cabc-4d30-abc7-55e8c8c4e227,IP:10,U
	RL:0,TC:0,Content:-5,EDM:-25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACT
	ION:release,TS:-25
X-CID-INFO: VERSION:1.3.6,REQID:c995dedf-cabc-4d30-abc7-55e8c8c4e227,IP:10,URL
	:0,TC:0,Content:-5,EDM:-25,RT:0,SF:-5,FILE:0,BULK:0,RULE:EDM_GN8D19FE,ACTI
	ON:release,TS:-25
X-CID-META: VersionHash:a9d874c,CLOUDID:1b0a6ce63477a4ad80ab5a2913a00bf8,BulkI
	D:251203195718L07431EA,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|850|898,TC:nil,Content:0|15|50,EDM:2,IP:-2,URL:0,File:nil,RT:nil,Bul
	k:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0
	,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_AEC,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3665849cd03f11f0a38c85956e01ac42-20251203
X-User: zhangguopeng@kylinos.cn
Received: from localhost.localdomain [(223.70.160.239)] by mailgw.kylinos.cn
	(envelope-from <zhangguopeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 112629151; Wed, 03 Dec 2025 19:57:16 +0800
From: Guopeng Zhang <zhangguopeng@kylinos.cn>
To: tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	roman.gushchin@linux.dev,
	lance.yang@linux.dev,
	shakeel.butt@linux.dev
Cc: muchun.song@linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH v5 2/3] selftests: cgroup: make test_memcg_sock robust against delayed sock stats
Date: Wed,  3 Dec 2025 19:56:30 +0800
Message-Id: <20251203115631.947908-3-zhangguopeng@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251203115631.947908-1-zhangguopeng@kylinos.cn>
References: <20251203115631.947908-1-zhangguopeng@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B55DEA0008
X-Stat-Signature: jkpuwhb8htdhbsnnmahojkcjigtgkr4j
X-HE-Tag: 1764763044-728982
X-HE-Meta: U2FsdGVkX1/igcxh8gaM5q/15bfhrriO2Ib4S/KRw043DF2u6y066MSHAeZAjS5MrIWBg285W0So8LyCc8FF8EgXy493drytYk2jwTeF4gMFCYVJr7l+qwfvEozjDjkHaY8yEyrOSemCTzFQnf1UNTDYjSP+hZHvzwlpda1HrE5jts94ogmQRmxFlWPgQWzkJmpiJLYSJB2isEyVhIpWgvIm7ges5atF77dfSoZM/Ndl73aFtKoJXNxywzVaxbMGKKpbYJOL6Kz2ZRCeQSMRIy8ZU5SZMBZdd9qZyAFoABssr2g0PbAdOkscHrJN//0xYA9Y6O3HygkmqBGknlWXX2wtQY0vlF1+wpyySwUYRTXGrlVtKyWT0vKZrGWIcaY4j3niT3dYTCvgKyVjzwxyc8UL1NXcSAN8QFpHl34k85qylhPtQHyMSaHolQhdpxsrbqxscnEkm7NZgqzxUE+2+UenFfuB2ds3+KuQ50CfMFuXA4YVx3kY+ihMBScXiw53H1ERRhQkjRSjp57bn6bSy4yQuZhroksQ/IqaFPgEjMOenO2rmAT0cqQ1LG1NDOlO42DR68THIbVzoTbWG56UIMmPuAvL2GNIoqzE9hO2BG2u9cJmYsbuuv6LNBojxswRjrNky/VfgvOy8y9vV3jKzKCzNDBSd14VO/EGWustELinhlb9idkkOFTcpAS1Yps41CSDdXC1hYa+Q4jPHXtqGEUdPCife/4fr7ZSHwhRKpbZ1c+gkQLwXf++/DWhYE1fyLFuIRm4znp321mFTvOIa5199n9u40Hamk5OyPvmCBh09RZdfla/TfYdTT2hib6NO1g3wJzs0fVXB9hdr9dbttFCQsYoNKMb6B70roUeenalUgYSoquXzaLJbWctQ12u/y14dL9FU8AlvknRhXvZLUyM6ronvyOEsfeIrhcWRH5IIZkt5/C7xAy7gKBf3SaqdeKhGjZJ71iAsF7BDx9
 HKrrLvvK
 GQwynbzkBlsR11RxKfYJIwkpBptfwnw903irAEjN9BsA+vMdPpYD8j5sf7w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

test_memcg_sock() currently requires that memory.stat's "sock " counter
is exactly zero immediately after the TCP server exits. On a busy system
this assumption is too strict:

  - Socket memory may be freed with a small delay (e.g. RCU callbacks).
  - memcg statistics are updated asynchronously via the rstat flushing
    worker, so the "sock " value in memory.stat can stay non-zero for a
    short period of time even after all socket memory has been uncharged.

As a result, test_memcg_sock() can intermittently fail even though socket
memory accounting is working correctly.

Make the test more robust by polling memory.stat for the "sock "
counter and allowing it some time to drop to zero instead of checking
it only once. The timeout is set to 3 seconds to cover the periodic
rstat flush interval (FLUSH_TIME = 2*HZ by default) plus some
scheduling slack. If the counter does not become zero within the
timeout, the test still fails as before.

On my test system, running test_memcontrol 50 times produced:

  - Before this patch:  6/50 runs passed.
  - After this patch:  50/50 runs passed.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Suggested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 .../selftests/cgroup/test_memcontrol.c        | 20 ++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 4e1647568c5b..2fb096a2a9f9 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -21,6 +21,8 @@
 #include "kselftest.h"
 #include "cgroup_util.h"
 
+#define MEMCG_SOCKSTAT_WAIT_RETRIES        30
+
 static bool has_localevents;
 static bool has_recursiveprot;
 
@@ -1384,6 +1386,7 @@ static int test_memcg_sock(const char *root)
 	int bind_retries = 5, ret = KSFT_FAIL, pid, err;
 	unsigned short port;
 	char *memcg;
+	long sock_post = -1;
 
 	memcg = cg_name(root, "memcg_test");
 	if (!memcg)
@@ -1432,7 +1435,22 @@ static int test_memcg_sock(const char *root)
 	if (cg_read_long(memcg, "memory.current") < 0)
 		goto cleanup;
 
-	if (cg_read_key_long(memcg, "memory.stat", "sock "))
+	/*
+	 * memory.stat is updated asynchronously via the memcg rstat
+	 * flushing worker, which runs periodically (every 2 seconds,
+	 * see FLUSH_TIME). On a busy system, the "sock " counter may
+	 * stay non-zero for a short period of time after the TCP
+	 * connection is closed and all socket memory has been
+	 * uncharged.
+	 *
+	 * Poll memory.stat for up to 3 seconds (~FLUSH_TIME plus some
+	 * scheduling slack) and require that the "sock " counter
+	 * eventually drops to zero.
+	 */
+	sock_post = cg_read_key_long_poll(memcg, "memory.stat", "sock ", 0,
+					 MEMCG_SOCKSTAT_WAIT_RETRIES,
+					 DEFAULT_WAIT_INTERVAL_US);
+	if (sock_post)
 		goto cleanup;
 
 	ret = KSFT_PASS;
-- 
2.25.1


