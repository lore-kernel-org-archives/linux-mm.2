Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00EACCFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 12:39:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FE4E6B0027; Mon, 24 Nov 2025 07:39:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D5CA6B0028; Mon, 24 Nov 2025 07:39:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 512C56B0029; Mon, 24 Nov 2025 07:39:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 411366B0027
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 07:39:50 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E66A2B8939
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:39:49 +0000 (UTC)
X-FDA: 84145457298.24.FBE718B
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2A9021A0006
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:39:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763987987; a=rsa-sha256;
	cv=none;
	b=2zngtUexksMPDMJtcXrboX/G7oVkzdCV0Icu4j8MNoeBpKMv4Y0CC9vhCsw8nO8rZlwUtI
	q+LD9pmlj08/cF8r1l3FKyB42R8urxFsbVI0bFgBzLcps6iHcmREPXcUNvGoEFoB8ty43A
	pf47SZiO1/Nh6YnYijtgSYUxJb36nNo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763987987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8Czk7orC4t7/VyILSTfRS0NONG1Ypc+gSn/qUl7XW4Y=;
	b=30hpppVkzeq4sjYo50o+8xe0D/wOqGSy1FCY6nZqSt6fDqPUfWeI7EA+8s4dUaWvwjl08J
	rPNV7NDDNCpxqKzAL6f9i3SegBqtT+Kba7LbPhsBxl67FNhV1HS5PU3b6tTUj20bAN3uk9
	mu9HkYxCQ+dABfJcyM5BwprSlcYivDg=
X-UUID: a22e5726c93211f0a38c85956e01ac42-20251124
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
X-CID-O-INFO: VERSION:1.3.6,REQID:8a726766-85cb-4f95-9f7e-fcf7e6175ba3,IP:10,U
	RL:0,TC:0,Content:-5,EDM:-25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACT
	ION:release,TS:-25
X-CID-INFO: VERSION:1.3.6,REQID:8a726766-85cb-4f95-9f7e-fcf7e6175ba3,IP:10,URL
	:0,TC:0,Content:-5,EDM:-25,RT:0,SF:-5,FILE:0,BULK:0,RULE:EDM_GN8D19FE,ACTI
	ON:release,TS:-25
X-CID-META: VersionHash:a9d874c,CLOUDID:c50dc76dcebaab2835619ff5f98a584e,BulkI
	D:25112420393938DELX12,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|850|898,TC:nil,Content:0|15|50,EDM:2,IP:-2,URL:0,File:nil,RT:nil,Bul
	k:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0
	,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_AEC,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a22e5726c93211f0a38c85956e01ac42-20251124
X-User: zhangguopeng@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <zhangguopeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1045363731; Mon, 24 Nov 2025 20:39:35 +0800
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
Subject: [PATCH v4 2/3] selftests: cgroup: make test_memcg_sock robust against delayed sock stats
Date: Mon, 24 Nov 2025 20:38:15 +0800
Message-Id: <20251124123816.486164-3-zhangguopeng@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251124123816.486164-1-zhangguopeng@kylinos.cn>
References: <20251124123816.486164-1-zhangguopeng@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2A9021A0006
X-Stat-Signature: ecr9jczj6h63c5t5mpk9mzu5cu34t19s
X-HE-Tag: 1763987986-918300
X-HE-Meta: U2FsdGVkX19bGMTf/r/e067QFEQnlWzt6S13SsYdsDPhSICJV9y57HiT7O4y3BPdHtoJ7/Qt/js3mi3oCJ7cnObwWkQOREzLS9e6r8cwQ2x7NGeIj4wlQARYNAT3k/9TzACEnxtuXuv1gQ5R0pMgXz/gq6KbXM3xn7Kf24MxcwX4+rBZAikrXRvGep/PFFyeRRH5tcuG08xAmWhyWu/mGxCdpo0d1gR9SWYGZuNztJ5S5W36QAfEHgGLOvNtfTUbAgNf/u5Lng/RNk4bZ2PToyrogs8lXMcIj8r/3TixUOtdIUIDcgcY8ZaLGPup+5ZRY3HWlEi2WEFeyVgvBy/mX+JSh3OBQR27ZsFaJK4wHgtSIO4cPJo7DDOUyx62UgjvLKJsQfug8tBQMXUrGmSkxcrI9VbMra3fDXveWWCwxmL3vJACB7Y3Ba+TNfAHd+vciueRWcxjUcn+/mzH8uC/4u7PpX0ZMZzrlYmnZbCquEDoV4ubeqV25xZaXWieSWNWCUuFHtbjheAViekMcWB5jbpHQm10HYnvEA+jsX5b47I5joBofiRAvTEOB91v1wQnUECl8QLzQppx8ql3vW2ITddpkCqvoj8CQweExEQv62SWK35YRcNQRHeTd1eQKvHIW9lUcXYzCgvMs562BGh2r371Lxofqc1Wd/bnoKXFXnYcaRZzsLKhj8Ye3XHpeOH7Aw4/ia3t+WMogrl25mxhMQnvvK8BNj9CHWyE5ryiJBrRIx03xfsgI3QtWLkaniRuAKhSCJJ52XC7cCrhP+5MNskGQ4j1kQm7euI++BLpPHcVm9szBztwQNNoxOS07lxgXLbxT29Ydp/c7DHM/dYfjasGUZIyj8hhxC9zzvct4p9Rif5bb9B5Qel2lJQ6yXfPGtIomkNEgPVG8hJUUpkKJ3JwsD6fKCCsLU8JS3uSVZr+iKGABUZqgY9UWjo4LsLw/GclulCKT/MKXYlpHjY
 o2EvUV15
 bkHtWIqwSwyZCxaKXn3HG+zaREOrzoIkInSI63JeGOEeeA16XdpjLeSFTCQ==
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
---
 .../selftests/cgroup/test_memcontrol.c        | 20 ++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 4e1647568c5b..dda12e5c6457 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -21,6 +21,8 @@
 #include "kselftest.h"
 #include "cgroup_util.h"
 
+#define MEMCG_SOCKSTAT_WAIT_RETRIES        30              /* 3s total */
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


