Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E848CF318C
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 10:52:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B38986B008C; Wed, 19 Nov 2025 05:52:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE7AE6B00A9; Wed, 19 Nov 2025 05:52:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B0446B00AA; Wed, 19 Nov 2025 05:52:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 856BD6B008C
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 05:52:53 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B6478C03D0
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:52:50 +0000 (UTC)
X-FDA: 84127043700.30.AE04D8E
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8700E40002
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:52:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763549568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=thFNe4a1dSSWuPPIRTGEH+jMwtRkDnCfabWt2HYJy/o=;
	b=1mOycM49EOpayUGYo1VGMjtxjphWuxavbw2gYl0BXenIoA58NdM9SVNQylM/EnWhfHG/dA
	6jtVE7cQ1/GAjkKFAAz2JRj0UuSG2MnonnDaDCfmqmBbuI4KIIoUFqbziVrAJvgnq+wasL
	y08vttU5yKXX38lv1DLOBTWfb5X49WM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763549568; a=rsa-sha256;
	cv=none;
	b=CDcv+kEl1B+d3rznJX6XSGlHjZJeWUWjosy3N/5+KS+j9ZYskERhIB/FWPptqpC9TyoXT6
	LqcK5yWPLgFlLj0I3NXsIvJapU+/pOJv07Qju3goq/MEXnuZ6n+8EZv+ZgiyKhxFtxsiNh
	YDgjh9qBUSjsa8N3mcLCqjM0F8/vNXA=
X-UUID: daf01190c53511f0a38c85956e01ac42-20251119
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:2fef2393-71be-482c-a7c0-c52d41eee6e1,IP:10,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:5
X-CID-INFO: VERSION:1.3.6,REQID:2fef2393-71be-482c-a7c0-c52d41eee6e1,IP:10,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:5
X-CID-META: VersionHash:a9d874c,CLOUDID:9b5fcba47a3de54798378eb4b8f014d0,BulkI
	D:251119185236YEZMKME3,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|850,
	TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: daf01190c53511f0a38c85956e01ac42-20251119
X-User: zhangguopeng@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <zhangguopeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 634930976; Wed, 19 Nov 2025 18:52:34 +0800
From: Guopeng Zhang <zhangguopeng@kylinos.cn>
To: tj@kernel.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	mkoutny@suse.com,
	muchun.song@linux.dev
Cc: shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH] selftests: cgroup: make test_memcg_sock robust against delayed sock stats
Date: Wed, 19 Nov 2025 18:52:16 +0800
Message-Id: <20251119105216.1675608-1-zhangguopeng@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8700E40002
X-Stat-Signature: gqe7ur6cq1q8dse5c16pqbd3n844o19f
X-Rspam-User: 
X-HE-Tag: 1763549567-507190
X-HE-Meta: U2FsdGVkX1/2WaWU7b8E4jc0UqNtHiAoBrpoSryunB4s0YwIYF0vqsTis6C7JDByzBiEEoNii2RtsoNTleAmFzBWe6vi5LpZ13/8rEZlDVh7+eZoyy0sTodJqNCLCRRD2VLsVOSgPLZ9YE16dKsDD2H5kqN6hMyzDZZIrZIDKUWlyJUQVZpYiPKDCZisZ6r/+N8DH9cIsnHXo/NCNRF6XT22fLVHwQQfJ6XhTzyW0Oz9TAjR6fxVh/vjpYjqstW+n3vpHSuW3cxf9Uf9bgCGLbSmlZ/GDpEN5Sa+Q5gqHkq8GgvIxF7NrOjYrHnc4mnEgrdPC5yh75X1VFtQVvDyUmPRxkhYLAiCMslz+5SgyP9RGRi7ojU6UkZMofA5XinwfU4bmlZ1/yBUly1diNwSgP1xAKTutm0YakNuG5E0nbcf11IumirX7m4OnffxpifsiEqyrq9OR03Dj25zh3kYMnasWqpW2PNuN0IliAumsLUHeR9WEn41nNIJpWy/H1p1BRvFLyt6t5avtKeHejuiGktail2W0YqYJsk7pNX8VZeca2Z5MfiJTuRxG5QMfvUOvnYQYo4g+AE6xfOzISFTAPeKmRULO4PiBwo/9aMx4k6fZXjR1/VaWpKtwh4vQhjP5/Oy4TwMemaYgX7/E3Vhnf0cIGnzh1pKm55Z+tX+R2A4Z8jPqmzY/ck+Oh8cAxIb+IbAXtHdKxF1pneT/piaaWiOn+6lbb5hZk571RhZ8y9gveGxPGNwRdoKDSxtqG4TojujWK3gh04aBT9J27AAnUnt5xGRSKhoxnpoxudR5xxoL349UmJCp+WWE2vjmcBZ0Og+XOWgpBJyIq5FhOtgKMarLh5G2wDUSiXgfQv/83RD5iKuYjJFzmRW2+0Ab0aXxquAF0NM5zGQCHz7Df8vjxVCWMPb9Ukm4BrcgzNaGxQWCKRcc4dOYo2wzYjyB2h4pOyvWO2NJGP71WIxglK
 gW2KtC+h
 iZP46Y05SAF0i00cxxD+q3KJeqVCcFwqS7W4w59SK1zHOpnPbPFeHikH/RQ==
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

Make the test more robust by polling memory.stat for the "sock " counter
and allowing it some time to drop to zero instead of checking it only
once. If the counter does not become zero within the timeout, the test
still fails as before.

On my test system, running test_memcontrol 50 times produced:

  - Before this patch:  6/50 runs passed.
  - After this patch:  50/50 runs passed.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 .../selftests/cgroup/test_memcontrol.c        | 24 ++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 4e1647568c5b..86d9981cddd8 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -1384,6 +1384,8 @@ static int test_memcg_sock(const char *root)
 	int bind_retries = 5, ret = KSFT_FAIL, pid, err;
 	unsigned short port;
 	char *memcg;
+	long sock_post = -1;
+	int i, retries = 30;
 
 	memcg = cg_name(root, "memcg_test");
 	if (!memcg)
@@ -1432,7 +1434,27 @@ static int test_memcg_sock(const char *root)
 	if (cg_read_long(memcg, "memory.current") < 0)
 		goto cleanup;
 
-	if (cg_read_key_long(memcg, "memory.stat", "sock "))
+	/*
+	 * memory.stat is updated asynchronously via the memcg rstat
+	 * flushing worker, so the "sock " counter may stay non-zero
+	 * for a short period of time after the TCP connection is
+	 * closed and all socket memory has been uncharged.
+	 *
+	 * Poll memory.stat for up to 3 seconds and require that the
+	 * "sock " counter eventually drops to zero.
+	 */
+	for (i = 0; i < retries; i++) {
+		sock_post = cg_read_key_long(memcg, "memory.stat", "sock ");
+		if (sock_post < 0)
+			goto cleanup;
+
+		if (!sock_post)
+			break;
+
+		usleep(100 * 1000); /* 100ms */
+	}
+
+	if (sock_post)
 		goto cleanup;
 
 	ret = KSFT_PASS;
-- 
2.25.1


