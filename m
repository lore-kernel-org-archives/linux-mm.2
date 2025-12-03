Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 857BFD12D4C
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 11:57:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1BCE6B002F; Wed,  3 Dec 2025 06:57:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF37D6B008A; Wed,  3 Dec 2025 06:57:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D309E6B008C; Wed,  3 Dec 2025 06:57:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1DEF6B002F
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 06:57:46 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6AC40132E5B
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 11:57:46 +0000 (UTC)
X-FDA: 84178010532.09.AD61494
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8E85DC0002
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 11:57:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764763064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oCsWGyoBa8GUWTg5UVgpQ1dr2mbntMqNEjqap6COAQE=;
	b=SH5El7C3pvwZx8uoZEJDPmf2wRHGYz0AHrR9Kwms94wvyAw0qCQcn5S09tTCuvbCddO/Df
	ecBMu+XdELeI5GX5FB8EMmACk079agLBKuqfoOJa5ECCyy1aGBCz+i+Ff+86c0nIszO5/u
	LlfXuZ2O2WT8gE364EofXJ5HqCVlQTo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764763064; a=rsa-sha256;
	cv=none;
	b=0LQh+LQU/IoZG5F8OOXObLuJbwaVXYSJfZVN7AngwExfBbLa408Mj9oZzv/mM6nqV7sBdp
	nrx87TlNCN/oWdQ94JbrKleI9A4x5iyziOkdPAjMjlE0pDH53pImnXGWmTg0nQygXCQFQu
	4YxM7T10Cq5QtE39eFEdOsZmPHq23cU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn;
	dmarc=none
X-UUID: 3e8aed92d03f11f0a38c85956e01ac42-20251203
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
X-CID-O-INFO: VERSION:1.3.6,REQID:3afd6943-73bc-45e8-83fd-e7479fdc0fa9,IP:10,U
	RL:0,TC:0,Content:0,EDM:-20,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-15
X-CID-INFO: VERSION:1.3.6,REQID:3afd6943-73bc-45e8-83fd-e7479fdc0fa9,IP:10,URL
	:0,TC:0,Content:0,EDM:-20,RT:0,SF:-5,FILE:0,BULK:0,RULE:EDM_GE969F26,ACTIO
	N:release,TS:-15
X-CID-META: VersionHash:a9d874c,CLOUDID:62c5311b8a953f6b247a7649f052c076,BulkI
	D:251203195739X3CS36VH,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|850|898,TC:nil,Content:0|15|50,EDM:1,IP:-2,URL:0,File:nil,RT:nil,Bul
	k:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0
	,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_AEC,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3e8aed92d03f11f0a38c85956e01ac42-20251203
X-User: zhangguopeng@kylinos.cn
Received: from localhost.localdomain [(223.70.160.239)] by mailgw.kylinos.cn
	(envelope-from <zhangguopeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 656484029; Wed, 03 Dec 2025 19:57:29 +0800
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
Subject: [PATCH v5 3/3] selftests: cgroup: Replace sleep with cg_read_key_long_poll() for waiting on nr_dying_descendants
Date: Wed,  3 Dec 2025 19:56:31 +0800
Message-Id: <20251203115631.947908-4-zhangguopeng@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251203115631.947908-1-zhangguopeng@kylinos.cn>
References: <20251203115631.947908-1-zhangguopeng@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8E85DC0002
X-Stat-Signature: ytssce8665jfci45t59zi1sg7t9rzquj
X-Rspam-User: 
X-HE-Tag: 1764763063-75688
X-HE-Meta: U2FsdGVkX1/jYtffA12rN2jizq4wz6VHGgrwd+3zQKWFf7LlWFx5WXXKx3xKV7TGuXCx6+iJpi6GoZbJNDt1ZH56Fy1OqX8hNKKTSp3OW3j+XRsYGbJPhH+T1zAvdmBxWrIyA/SbmDy/+1UDhaGsA8lsEbDjR570hlciY6oQQuLvSMTiX6Zz0LCahn8s3wUwqiWygI+smI0w6FJSMWLVYBdBlqdetWlEGMfPDWcm4lzxqxgIivRPCNBKngqSb7p6UcCZwh9WrxF/i4nGz6g3q8hptChgpEtIAsZW0m/NfzOWuSPNC6orJeaaDQzwj/6+spyh7miWiVzKfpK9KRRQaaXfD6yN4YnSYxNTbf7l026JZk20ImUYuukv0VyskAXezb5E5htOaAveGqTZ0oqDzWs3NbC/TSdhDFTVR/e0J9OslolE/CoU8amw9Bx1/liFyncC2gkrQquf+ug310ArRQUnMFO+a54lhwFYEZL9W6K6xa6ay6qhVJvrBF13sUpgthRN7VoXkD3qz+s7APDfZZ7Px7e+ddmRskxjZdYzFqkZLG6+hY+OxVBVhes0fYCs1jpKqO854hyV0+KhLYqhJA7BPoXevsBx6xplobQeoYPIDcmDslQQ1PbNzgiHXWNQOEf1RdNKKg9DcN3n+qs1uVu861ETQqMS8VCD33buRZvvA6Yw/vEMqPUgUXfh5+ggaO/Zdq0kj8tROCfCK/ZhjK8JP6xzxpvXs2dITd7kp6vFE19m9eWkvOWUWE+6fHsjTJwPVoF9YInVfZR9es805mw4+6p+vJuVAC8qwcNWXIAquCYkvHkhAtmYR8iXaPiq77AWNfihFBwI2POFb/R3EjRLmJcd9kWSKKBf/0jixYkKabLwCvi9LB8GHY4t1n7DWxCz9apeBEcQey1/reMxye7e2UyulAPfDwOQ5gGw0qKsZxqKEniHozlrOpOvBebbD7ucrNAIR3uclHmpVj8
 iTI1NWYN
 pAh58c1tSdTgCtmwcVVuIqPuuGc6qDn7p2a0r8OvjFBlCAwrWi5KrszhYxA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the manual sleep-and-retry logic in test_kmem_dead_cgroups()
with the new helper `cg_read_key_long_poll()`. This change improves
the robustness of the test by polling the "nr_dying_descendants"
counter in `cgroup.stat` until it reaches 0 or the timeout is exceeded.

Additionally, increase the retry timeout to 8 seconds (from 5 seconds)
based on testing results:
  - With 5-second timeout: 4/20 runs passed.
  - With 8-second timeout: 20/20 runs passed.

The 8 second timeout is based on stress testing of test_kmem_dead_cgroups()
under load: 5 seconds was occasionally not enough for reclaim of dying
descendants to complete, whereas 8 seconds consistently covered the observed
latencies. This value is intended as a generous upper bound for the
asynchronous reclaim and is not tied to any specific kernel constant, so it
can be adjusted in the future if reclaim behavior changes.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 tools/testing/selftests/cgroup/test_kmem.c | 33 ++++++++++------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_kmem.c b/tools/testing/selftests/cgroup/test_kmem.c
index ca38525484e3..eeabd34bf083 100644
--- a/tools/testing/selftests/cgroup/test_kmem.c
+++ b/tools/testing/selftests/cgroup/test_kmem.c
@@ -26,6 +26,7 @@
  */
 #define MAX_VMSTAT_ERROR (4096 * 64 * get_nprocs())
 
+#define KMEM_DEAD_WAIT_RETRIES        80
 
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
@@ -323,21 +322,19 @@ static int test_kmem_dead_cgroups(const char *root)
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
+	 * Allow up to ~8s for reclaim of dying descendants to complete.
+	 * This is a generous upper bound derived from stress testing, not
+	 * from a specific kernel constant, and can be adjusted if reclaim
+	 * behavior changes in the future.
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


