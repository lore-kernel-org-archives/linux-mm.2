Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE31CCF64BC
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 06:04:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CFC46B0024; Thu, 20 Nov 2025 01:04:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37F736B002A; Thu, 20 Nov 2025 01:04:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BE2E6B002B; Thu, 20 Nov 2025 01:04:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D2C56B0024
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 01:04:30 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D23C589CD6
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 06:04:29 +0000 (UTC)
X-FDA: 84129945858.25.1804689
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf13.hostedemail.com (Postfix) with ESMTP id 11CE420005
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 06:04:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763618667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=pxi90e263vPFvaQZxQRWAoRShqkmvZyFnQZUumFkM+w=;
	b=xXTU9v4GANoGc+gwParijHn4pQwMHucuYojhuJU8y5NtAyBk7WndlErBI5nYkR7zL/OKWU
	3Pa1ESJgLjGsfwzkC4q+fKIkLZwUbFGESlbpUCBBwoyA1iMuSZEzhQ+KXm/jJ3krap6RxJ
	TdfypW1svy0ZKy6YkOQqhzxLDcvkYPo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763618668; a=rsa-sha256;
	cv=none;
	b=HsJHWZMNL1bQpeE2bVFEDFoLQYvp7MADaQuWmGo23mhYOB0OBglNO7XFlSw86m3RkviOT+
	7Z+zxtxex1c455DTH5f1sArkRJj753zulvM7ApPmBv57wRvMEAYGn8iMmhlsq6xToDtcL5
	O8ZTd+RkP2/LjFDdsEBa+wfT8cg7ZGs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn
X-UUID: c009bedec5d611f0a38c85956e01ac42-20251120
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
X-CID-O-INFO: VERSION:1.3.6,REQID:d3379ca8-9df7-4f91-8869-027173cb9c99,IP:10,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:0
X-CID-INFO: VERSION:1.3.6,REQID:d3379ca8-9df7-4f91-8869-027173cb9c99,IP:10,URL
	:0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:05355a0d6bcb5969b9999be7041cecf5,BulkI
	D:251120140421GDWNOKMT,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|850,
	TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c009bedec5d611f0a38c85956e01ac42-20251120
X-User: zhangguopeng@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <zhangguopeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2026961757; Thu, 20 Nov 2025 14:04:18 +0800
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
Subject: [PATCH v3] selftests: cgroup: make test_memcg_sock robust against delayed sock stats
Date: Thu, 20 Nov 2025 14:04:06 +0800
Message-Id: <20251120060406.2846257-1-zhangguopeng@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: g8a95a5g1ic7h7ickwc1xqkzfcwpu36f
X-Rspam-User: 
X-Rspamd-Queue-Id: 11CE420005
X-Rspamd-Server: rspam10
X-HE-Tag: 1763618665-362948
X-HE-Meta: U2FsdGVkX1/MdJDfgAC0TMQoqt30k8xudlPvidzBhqHHlo/rffmbTpgPCJdOk0qolTK4m6tJD0cwHYUDAqTPWXjKitDo0mqvjBefGPmPcvo0VEaTGkaMFJnd1x9FQpt9rUlM1bgkMs2evw6O37IkBQVog6es7KY8yJtfq68tKXU51LaslEbogPIrjbPTslu8l5Xmd55fifLE7yfx5cpqWmk4LrmzyNHk45lOkfTazhchjEIYYwj6ulDFAx1wJXI3EbW9ebDcRnhLZEgEqmw2DIgLUqgGHF4m00RTyTIQCzaS6OjlyBRXCluoyfbH/GsOeCJgcNOl1wIWn/JweNxdfhV/ucYrmh0Bh71Dig27M8AYbDCAzXm1Buc6Rg6GPdfimZ0D5eMAqqKkRkbdJshUeFeucJIuc52/4ClsXEemKlm8VVrojBYjlp9I7qQlZjGccogWLFQQ4NcdwRF8SVFfcffUCTnBgyez4PzlwFzToy0G2Y3zU/1hDDMBYDHMiNX/Aynhfo/6LGYu9y4tK53NTtZAGSb0n4+xFKQMm0ii+yy/ZBnQdrq7BkOnTqrc4fyDhuoaFa0OskWSCU0Y2ZYMLd6BQwL7cfT9JU2z8uUU6u6bflkBRJVwD3QiV4rh0mSA3uEsH48FdAn2hPRv+fUf4G/Od8HhOUifMRZ0izf0UQ+El0A5/RrEl1D7T9aJ4yEfcnp36ehMHFFR6Jf90xPvR+aNFvORIZTx8mlzlhVDIZmbMqfVQnDPwxXhbue83J8MNJus6PQEtLp0cgA5mK4tHCFZLjQpwchB1pWWo2wSPwzRwevv6Fg/D2ZslSMCF6iYGjUqYBxWtZ9HNnVkS8p/GmvHAV+CcnDmhEpooLO/J7qM2VkqK8Jr+nQJ7Wf58BEfz6l9a/VbMtGA6iTWUceQ4euZQiFpddJzt8F/djOil9XxpHSp8HJT1rigQY1n0TJuOKsP2e5ff25D9pMIm+k
 fnTcqhOi
 btgXT++1bzsjdNmsslDP6PHxzqqaQVZ8OwfgsJkJggYqZmBspSZTYb3oNtg==
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

Suggested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
v3:
 - Move MEMCG_SOCKSTAT_WAIT_* defines after the #include block as
   suggested.
v2:
 - Mention the periodic rstat flush interval (FLUSH_TIME = 2*HZ) in
   the comment and clarify the rationale for the 3s timeout.
 - Replace the hard-coded retry count and wait interval with macros
   to avoid magic numbers and make the 3s timeout calculation explicit.
---
 .../selftests/cgroup/test_memcontrol.c        | 30 ++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 4e1647568c5b..8ff7286fc80b 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -21,6 +21,9 @@
 #include "kselftest.h"
 #include "cgroup_util.h"
 
+#define MEMCG_SOCKSTAT_WAIT_RETRIES        30              /* 3s total */
+#define MEMCG_SOCKSTAT_WAIT_INTERVAL_US    (100 * 1000)    /* 100 ms */
+
 static bool has_localevents;
 static bool has_recursiveprot;
 
@@ -1384,6 +1387,8 @@ static int test_memcg_sock(const char *root)
 	int bind_retries = 5, ret = KSFT_FAIL, pid, err;
 	unsigned short port;
 	char *memcg;
+	long sock_post = -1;
+	int i;
 
 	memcg = cg_name(root, "memcg_test");
 	if (!memcg)
@@ -1432,7 +1437,30 @@ static int test_memcg_sock(const char *root)
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
+	for (i = 0; i < MEMCG_SOCKSTAT_WAIT_RETRIES; i++) {
+		sock_post = cg_read_key_long(memcg, "memory.stat", "sock ");
+		if (sock_post < 0)
+			goto cleanup;
+
+		if (!sock_post)
+			break;
+
+		usleep(MEMCG_SOCKSTAT_WAIT_INTERVAL_US);
+	}
+
+	if (sock_post)
 		goto cleanup;
 
 	ret = KSFT_PASS;
-- 
2.25.1


