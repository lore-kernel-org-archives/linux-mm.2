Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF76FC43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:17:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2B7E6B00CF; Mon,  6 Jul 2026 04:17:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBAD16B00D2; Mon,  6 Jul 2026 04:17:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A54C06B00D2; Mon,  6 Jul 2026 04:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 796356B00CE
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:17:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E9A9514030A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:17:14 +0000 (UTC)
X-FDA: 84957646788.03.D585798
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf03.hostedemail.com (Postfix) with ESMTP id EDD2C20007
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:17:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783325832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HSFze+mx1cLJMjJK2BqFuf8pcGfv95TLvQ4nboxrxNM=;
	b=HCPz3xmzmzy5rJBiYiib08fJ8F4oCEOOXjVtlwgS9E5xlw4csSXHYzpgiHnSS8tieoOBEo
	ot4a36sljKcpZCS3zT9ejXz9T0IvBLJT3BmRR5m8ZrxwstxdoPEs0UU/cIPG3kNpL0i19Q
	q9gVb6lt9cYqUNjIO+wwJ5gUDuBSHJc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783325832;
	b=CW/+wWmseXYoTL9cHtszkAtK0Gl0SGg0RXQwNHmfSGr9aDdBBVuokPobcUA/BQWBampGAL
	YyphgYyC4yI6QzCUs1SWO0OyzLNzQFfxbJ6bQrSO9Zomm4d7HJ7XdE6wnx6ohxfnNa29gG
	MPCIFP3zxt4lb9hsSzFYftVbNYsTBEQ=
X-UUID: 13ec4c8e791311f1aa26b74ffac11d73-20260706
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
X-CID-O-INFO: VERSION:1.3.12,REQID:78748e26-725a-41fe-9de9-edb58e991902,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:78748e26-725a-41fe-9de9-edb58e991902,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:0ef45d872de13baad6c0355bb7f05940,BulkI
	D:260702142437QFZCHOMQ,BulkQuantity:1,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|136|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:n
	il,Bulk:41,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,
	BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 13ec4c8e791311f1aa26b74ffac11d73-20260706
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2025791223; Mon, 06 Jul 2026 16:17:07 +0800
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
Cc: jhubbard@nvidia.com,
	joey.gouly@arm.com,
	keith.lucas@oracle.com,
	kevin.brodsky@arm.com,
	usama.anjum@collabora.com,
	yury.khrustalev@arm.com,
	zwisler@google.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH v10 3/6] selftests/mm: use pkey_assert on clone_raw failure in pkey test
Date: Mon,  6 Jul 2026 16:15:57 +0800
Message-Id: <20260706081600.3570203-4-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260706081600.3570203-1-lihongfu@kylinos.cn>
References: <20260706081600.3570203-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EDD2C20007
X-Stat-Signature: 64ac43z9ghwarebt191nioi1bar5a895
X-Rspam-User: 
X-HE-Tag: 1783325831-604838
X-HE-Meta: U2FsdGVkX19TsOMG17G9q1Ty/shIOzrThMm8IaLy930x+QhYkmTsxIffU5+IVwlEJ28vOObe5AncAi5fKphYQcoFYSg9j5NnJhM2FoPxycSjYSPpUG99aGxbRC60BPX2X6di6y+EdfnX7K8ZxD9Hik4F4J1CZlKdVjIHcMYlFkFaGOsm0reP3KrGuW2ZSLYAN37aSr73Ng390dnDbTVL9hhJzxHjeatxlCq3lDYlVJUejn7cNKQhXllpS0iAw3fJJ7gJVFvf18PPC4sI747VrkDIiinDKJ3SRFau6qCnndNAFz+5UbI+f4XQXGw4NbJul+1mkUJX4THvHxlodIPywdG3TRAhTnyOTyOKR7lBWpyU5fX3VXSjxNZUxzH6gSLaMYMlqgaJ7hrJKTmSZaMth6MryGpAE4AbOWjR34INjrskbVH5T8hl8HK3oR+7mNb8/LPyXtf/PeIDmuASC/Gj9DWGgpSDQtXBb0uZhE6NFhQBM4ToIeN0HvzopFpQFSi6ad8ebTobcdFN6+p7dcZMejCN14KbDefzMONWXIQh6Z3TzEvMP/glVUKY/GqZvimeNHmXT6Q7Bw2QG2ASRP7q7OfuRMSOZqUpUUVJqQZNlk8QQL2BjiygBK/p0wjylKanoycRUHio8mjD1lEpYrRm03Xro/VONkdpPcFXvR/F5o765Ig897MONfcbh+YisDJI0XHEy3dUuxc9HCDBRIIPz0ydtvXQ9s6dzYUE/KCgok1kwnlgjL2OjFcHjsdbgyNIKXrXeeztctjHcNd2IlyrVhVJp46FW4V48TXpcaeT6fLuVO9HXBYV+WKPNAlcVdw4vfMqV83BiFaHsFf2ZYThksz+abQf7wgaK1rguRX3BQIHTX8EOyUq1nzETO3XPNxQW7G7XDExGYrff1ryYSkJyFqkzVnu6vuE0IS5V8+nJ6haje2Mc26aolpk/oge56++uQQ3IgvFdMGA1L1knGT
 Ill3D7Jd
 hZlrEi/RMSmyKj9Ivnek6e3pWYCpBoPORmzjXJHCrarGPYDEDsAN6SGbZ43t+4F7HA0Gm2a/cEbipzD6n6iOeckv9NiQy5OuZPwkj9j7aBYO4jJ2Pc/RYniI3WvpJkgdIXavdS9F0hY38s7tzoqJ2idvLWl/dC3XzLjLxMQ3YkB4S38jnsNLbMlBgsCiSh0Ed8IIA
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
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Tested-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 tools/testing/selftests/mm/pkey_sighandler_tests.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
index 8b3400379423..188513e94fc5 100644
--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
+++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -329,7 +329,7 @@ static void test_sigsegv_handler_with_different_pkey_for_stack(void)
 
 	if (ret < 0) {
 		errno = -ret;
-		perror("clone");
+		pkey_assert(0);
 	} else if (ret == 0) {
 		thread_segv_maperr_ptr(&sigstack);
 		syscall_raw(SYS_exit, 0, 0, 0, 0, 0, 0);
@@ -502,7 +502,7 @@ static void test_pkru_sigreturn(void)
 
 	if (ret < 0) {
 		errno = -ret;
-		perror("clone");
+		pkey_assert(0);
 	}  else if (ret == 0) {
 		thread_sigusr2_self(&sigstack);
 		syscall_raw(SYS_exit, 0, 0, 0, 0, 0, 0);
-- 
2.25.1


