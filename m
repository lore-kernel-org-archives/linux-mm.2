Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0E72CFD317
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 12:39:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CDE86B0024; Mon, 24 Nov 2025 07:39:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A7076B0028; Mon, 24 Nov 2025 07:39:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F24E56B0029; Mon, 24 Nov 2025 07:39:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF8166B0024
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 07:39:57 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 823618890C
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:39:57 +0000 (UTC)
X-FDA: 84145457634.04.958863A
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf30.hostedemail.com (Postfix) with ESMTP id A6B8680012
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:39:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763987995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+PWXrKWh6m8+5pP00x1VFBx0kY/8o6ggNQUjHX5islg=;
	b=i28Bg+mQYpJNdwYCQFCJcmDxveGsD3K0eJUAs3GPIMJnTq8RDykbDD5/BMGEILKTKVtNLj
	camK1geXa9p+f/lIZBkYnWaoZEf3qElLuTHbdT27W0OynKf8mUuiU+WLgKZGhxFGfAOZLI
	b5ww2aGRC/0IsYesMQ2Um/XZEgUqMb4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763987995; a=rsa-sha256;
	cv=none;
	b=hAjVQXdd2QGNJgRi0PgRUqBFGAoRQv4GUJJ2VfH9ALMPsiOTOdkUm47KuVfyqsdYLD0WF9
	DQCTSIIgMqdBEMHvt5GsNVGVzFigC1a7NsVq4DC/QRkx2phjDXbgT1aabI64BPwkKNE9O4
	6so67x8SqAL3MA6xaHIaahWfbm5gfQM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn;
	dmarc=none
X-UUID: a821297ec93211f0a38c85956e01ac42-20251124
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:180b0333-6da6-477e-b0ee-baf49c0e91e9,IP:10,U
	RL:0,TC:0,Content:0,EDM:-20,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-15
X-CID-INFO: VERSION:1.3.6,REQID:180b0333-6da6-477e-b0ee-baf49c0e91e9,IP:10,URL
	:0,TC:0,Content:0,EDM:-20,RT:0,SF:-5,FILE:0,BULK:0,RULE:EDM_GE969F26,ACTIO
	N:release,TS:-15
X-CID-META: VersionHash:a9d874c,CLOUDID:f01b25cd1b7c132f57144eb32d385955,BulkI
	D:251124203948IQSFPUOC,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|850|898,TC:nil,Content:0|15|50,EDM:1,IP:-2,URL:0,File:nil,RT:nil,Bul
	k:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0
	,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_AEC,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a821297ec93211f0a38c85956e01ac42-20251124
X-User: zhangguopeng@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <zhangguopeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 391219460; Mon, 24 Nov 2025 20:39:45 +0800
From: Guopeng Zhang <zhangguopeng@kylinos.cn>
To: tj@kernel.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	mkoutny@suse.com,
	muchun.song@linux.dev
Cc: lance.yang@linux.dev,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH v4 3/3] selftests: cgroup: Replace sleep with cg_read_key_long_poll() for waiting on nr_dying_descendants
Date: Mon, 24 Nov 2025 20:38:16 +0800
Message-Id: <20251124123816.486164-4-zhangguopeng@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251124123816.486164-1-zhangguopeng@kylinos.cn>
References: <20251124123816.486164-1-zhangguopeng@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A6B8680012
X-Stat-Signature: bmnmsb1ywsczg8xrnie8ss3y4tnijc1t
X-Rspam-User: 
X-HE-Tag: 1763987993-745614
X-HE-Meta: U2FsdGVkX19muCn2Z0of3noBKVUJrr0F/v8gVIGZYUYe07Oi5j1VmetbE0DvDsTasKNYem9dzucDoSIlNtbFQu2LEmvxXstemA2siRDk4QqpfgXcgfrsLISCJVLM2dOR5kSWzJZFeGXm21abKqOn9nduNy9kDB8jOfRyOT9zlRfr7tUvlhiQ/mDnjsgICU6eSMEQTHqn/mOMdXooKm83LMJOGUv840w1u1XQKQVXUI5fweexGki//KSqI11OKgoimmxf5fHWi9k1Hi89iX3CVC8p2gG2S26b1XzjfS6VE7ycj3zfCcmdbQu1FttZzbbQ3b5PHSeiQU6JCBEj0lm1ewkSCNBxaLtTdMNUrInJZvO4CRSanUKpcUdct2PTbixt9nXOfxzJi2Gwzm69nvwZUMyeWrhG5pfMsjMLmuMrCfctbgCM8ujd63GGz4OfAm1DtG5KxKXhipR0mVgQXBro1eJ5GEwbApJiEA+Pcb1G8shM6hsSA8LhS4eATfqGWDXoVmByc8PPfzRjD54ckMf6Bz9v7Squ7t+SW23qX1wIQqxTMKWMB1Gh6O73Xei8MveZr3PhUuNAmW1CfUHmw3UlCOV/H5PRWusPsD7n3xBXcG91wyF20k3CHvvPZBa+qIe3sShYa5FhcjLOHtSD3Z74Aox6oeNSJpqba7BbgrRVvK+kNbMEGVBryyKpNnMUIK2mRNxK9Q6NNelb/r4JHB80VRhSp/O/09+TV7Aw7JP3tWuP1t+IyolL/eX8qUErN11K1bGkvABrlLKZZ7ShbiJaZlys2I64vuUEhohjpOFHxnYoasYixfKk72w2coB5gajrWnVkIkC2G6LWvOaKMEgl/+2p+XDr9UAX8th8NkZTydGvHTDy/4VE79/t9TAICxotlfBLF11V2ESQwV0FuYO3kO1tezZ1UUzsVm9gI7XOARnkEovRVBvvljTFeXupTqK7npTrpRftETAbjNhVKZI
 d2y6PfxE
 0lHBI7gdnCr3J0A14MIphaQfCuzY4uBZh67fV01xhGxfnEJBHmlpxG0VqNQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replaced the manual sleep and retry logic in test_kmem_dead_cgroups() with the new
helper `cg_read_key_long_poll()`.  This change improves the robustness of the test by
polling the "nr_dying_descendants" counter in `cgroup.stat` until it reaches 0 or the timeout is exceeded.

Additionally, increased the retry timeout to 8 seconds (from 5 seconds) based on testing results:
  - With 5-second timeout: 4/20 runs passed.
  - With 8-second timeout: 20/20 runs passed.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 tools/testing/selftests/cgroup/test_kmem.c | 31 +++++++++-------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_kmem.c b/tools/testing/selftests/cgroup/test_kmem.c
index ca38525484e3..299d8e332e42 100644
--- a/tools/testing/selftests/cgroup/test_kmem.c
+++ b/tools/testing/selftests/cgroup/test_kmem.c
@@ -26,6 +26,7 @@
  */
 #define MAX_VMSTAT_ERROR (4096 * 64 * get_nprocs())
 
+#define KMEM_DEAD_WAIT_RETRIES        80              /* 8s total */
 
 static int alloc_dcache(const char *cgroup, void *arg)
 {
@@ -306,9 +307,7 @@ static int test_kmem_dead_cgroups(const char *root)
 {
 	int ret = KSFT_FAIL;
 	char *parent;
-	long dead;
-	int i;
-	int max_time = 20;
+	long dead = -1;
 
 	parent = cg_name(root, "kmem_dead_cgroups_test");
 	if (!parent)
@@ -323,21 +322,17 @@ static int test_kmem_dead_cgroups(const char *root)
 	if (cg_run_in_subcgroups(parent, alloc_dcache, (void *)100, 30))
 		goto cleanup;
 
-	for (i = 0; i < max_time; i++) {
-		dead = cg_read_key_long(parent, "cgroup.stat",
-					"nr_dying_descendants ");
-		if (dead == 0) {
-			ret = KSFT_PASS;
-			break;
-		}
-		/*
-		 * Reclaiming cgroups might take some time,
-		 * let's wait a bit and repeat.
-		 */
-		sleep(1);
-		if (i > 5)
-			printf("Waiting time longer than 5s; wait: %ds (dead: %ld)\n", i, dead);
-	}
+	/*
+	 * Reclaiming cgroups may take some time,
+	 * so let's wait a bit and retry.
+	 */
+	dead = cg_read_key_long_poll(parent, "cgroup.stat",
+					"nr_dying_descendants ", 0, KMEM_DEAD_WAIT_RETRIES,
+					DEFAULT_WAIT_INTERVAL_US);
+	if (dead)
+		goto cleanup;
+
+	ret = KSFT_PASS;
 
 cleanup:
 	cg_destroy(parent);
-- 
2.25.1


