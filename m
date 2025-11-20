Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C19BDCF64AD
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 03:16:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F1D56B002D; Wed, 19 Nov 2025 22:16:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A22C6B0031; Wed, 19 Nov 2025 22:16:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E0796B0032; Wed, 19 Nov 2025 22:16:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0AF496B002D
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 22:16:48 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5335B13B977
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 03:16:44 +0000 (UTC)
X-FDA: 84129523128.17.20880AC
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf15.hostedemail.com (Postfix) with ESMTP id 12599A0012
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 03:16:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763608602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=uE32kCs2vkBNsDvszmnJG5jL7h+dgLJi+0it2MFcu9o=;
	b=AwyCbtZ9L343nCz3LDcTamsd/rQyV6rJPXVSA2IhRHWp+AyvjYwYNwskSxPvTETZSqJx1J
	9WfaRWRYShI1mNVks0jLbQaX7850EUn00qMDjhPFngPbrcM4ThDZYQkKwNk+XrRtfLq/y9
	tCHPKJuBqHRjXi9j8URhI9uq+6ppbmo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763608602; a=rsa-sha256;
	cv=none;
	b=Mm4VHh7iMoHcqCUB0ldmrIUkdLHDic3dU+pTisLl6Tm/bZ4hATm/++yDHZpmcuhbBOQz7h
	vfkDKIBOkaiZBsQIEXT749Ot/pUX4CwnBqmVcURln8VosporHiwmoEmHsQeHltjsNdmh24
	PldrZ8RbXlDIQUwZFsaIK0C1mGlFwt0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn;
	dmarc=none
X-UUID: 4f6fe4eec5bf11f0a38c85956e01ac42-20251120
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
X-CID-O-INFO: VERSION:1.3.6,REQID:420976eb-eeff-4612-8a25-67b1f45aabaa,IP:10,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:0
X-CID-INFO: VERSION:1.3.6,REQID:420976eb-eeff-4612-8a25-67b1f45aabaa,IP:10,URL
	:0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:6bb73d3f7a3683f7f756e61b52d1a4b8,BulkI
	D:251120111633NPXGC7H2,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|850,
	TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 4f6fe4eec5bf11f0a38c85956e01ac42-20251120
X-User: zhangguopeng@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <zhangguopeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 768923844; Thu, 20 Nov 2025 11:16:31 +0800
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
Subject: [PATCH v2] selftests: cgroup: make test_memcg_sock robust against delayed sock stats
Date: Thu, 20 Nov 2025 11:16:19 +0800
Message-Id: <20251120031619.1828911-1-zhangguopeng@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 12599A0012
X-Stat-Signature: e8rw7o8qe1nqiqm9wf4rkth9ii3d97jm
X-HE-Tag: 1763608600-821579
X-HE-Meta: U2FsdGVkX1/2+HGYGKVOHnL+kr/Y1tyB5uE24mcBiahDvPsCQwkp09x4RbnWcZOsowV52Ubvk43LPCTvNg+YYRtrAMYqYzyTgflEvybTC5fccIs4V2FOmteYyzHhit1/SS1x1d5kgc++1TvziEuG6jW75ndddPAUyi9aVroQcb5e9DePabmgoE6CT148qBViGjBFGJoA1SgiC8XJY2wwFYW41qyODUOIIw+jwQwGL1m0uV6mldReH4tYbaQ3Z/62aa5YEQrubGgMt4Mw5yl0ffJj8HemMinRT+IPFyv+zafHUmvna5N5/M5BnHKW2+TeuYLx1W1f6C8ihRX7nOOSc3Dle9AnyOybXDP+CMO+kzG0Bz24qfm96caxCl4/2N2MXD5gh7gDOJoeU82vVbm4PoO1zU1u40jDwiJVc4CUXtuDqVWaS9BKlnkJWt0qWGl8WUl39CIc4Cjvbfw7kL8yD5dyOmIvkuDa2Uht5KS4KVTawnSC6Vd0E/fqyl2ZJPhGkFYeJK7LBxGT2NRKwzVnksOa7CPND/GbEwxDwiTfT1lKo93ZNwf+lzEfa/rQWtHafz9GvmtJMy8m+H8s9s69aQRnCxMZKHIdI74umhPL4u9WYY5r5Ecph7nNcDOBPziQmVBRk2VSGzXHLIsZT5Rpih2DofU243IN0LOrzvr/zozw38CEkOKgNmgIxcjfYCbQY/9EvxB5QBvwWgmaBE1qur8/BHcT5+rYnXLAE0K004ARKaUmqblJdLEINgv2UirXgVsRBHFfpYwocNGSqssmQoIbdyydVyu5HkYNcQvEGG5IhGW+9ON/0rqzrwbFwSlOnA5U+9xWTxnv/8E9Yq+KQLnY1gLpv/cTHCmvVMnbk/UoPw/djL9dTZsrPG1ti2Q3R1bkdaz7FEc+isDrT7iXQSvtI3Pe40RZL821hp43bW7fNU3lpJf4JiGq3e+x9NtH7jWYijx/c0/4EjVze8S
 Sc05B8tr
 tY1vkwjrmeIYv6IovZvjOiw+FIAcVZGOBUWSG6cPXNT4oiKihbp8ZispWsQ==
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
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
v2:
 - Mention the periodic rstat flush interval (FLUSH_TIME = 2*HZ) in
   the comment and clarify the rationale for the 3s timeout.
 - Replace the hard-coded retry count and wait interval with macros
   to avoid magic numbers and make the 3s timeout calculation explicit.
---
 .../selftests/cgroup/test_memcontrol.c        | 30 ++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 4e1647568c5b..7bea656658a2 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -24,6 +24,9 @@
 static bool has_localevents;
 static bool has_recursiveprot;
 
+#define MEMCG_SOCKSTAT_WAIT_RETRIES        30              /* 3s total */
+#define MEMCG_SOCKSTAT_WAIT_INTERVAL_US    (100 * 1000)    /* 100 ms */
+
 int get_temp_fd(void)
 {
 	return open(".", O_TMPFILE | O_RDWR | O_EXCL);
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


