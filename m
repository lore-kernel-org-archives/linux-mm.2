Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6C1BCD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:34:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11A736B00F1; Mon, 11 May 2026 05:34:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CAE86B00F3; Mon, 11 May 2026 05:34:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFC366B00F4; Mon, 11 May 2026 05:34:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DBA186B00F1
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:34:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6441CA05EF
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:34:51 +0000 (UTC)
X-FDA: 84754629582.07.4B55F7A
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf13.hostedemail.com (Postfix) with ESMTP id 335832000C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:34:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778492089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=vZVU4twny2nT/tjuSGd/NlGE6BhDRo97YKGcSlpwcCc=;
	b=KYpap/PPeGrbKE8Wzi+b7vnObySHmV4tuwwvc+ezyX5RusJ1nvd4Q6w9/lUjIqW6FSWBA7
	Eud43rvDfkrcWRy46tVtO5rS0uPY/fiGuPhovAhmxyDNwMElHM+5khnH5+ZknU3TjlF7Rf
	KjgRlZOtfVUxMPl6Xk+BbcC7poAiNbo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778492089; a=rsa-sha256;
	cv=none;
	b=Ni2cFOfqgfQ7QSA7hb+UCi107z+7UElqjZ3iJoczEaoD9hNsd2S4+TO8UHeJsUaxCMXrve
	zD8v2Ws4iGjTdZ3eDGMebVAJKBzWL3Id8XKb7Cv7OrgFS+UabxBJE2OImOBZU1ej/0UJea
	F5dVueB82xdTyjfOMdiTjjYiVwx4+zk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
X-UUID: a1b290c84d1c11f1aa26b74ffac11d73-20260511
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:0fc4e0f0-23eb-4d29-8ac2-b74e43484955,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:15
X-CID-INFO: VERSION:1.3.12,REQID:0fc4e0f0-23eb-4d29-8ac2-b74e43484955,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:15
X-CID-META: VersionHash:e7bac3a,CLOUDID:cc85dbbe211b15cd94e675c15e8cd947,BulkI
	D:260511173440PI1CYFO6,BulkQuantity:0,Recheck:0,SF:19|38|66|72|78|102|127|
	850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil
	,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:
	0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a1b290c84d1c11f1aa26b74ffac11d73-20260511
X-User: husong@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 120949529; Mon, 11 May 2026 17:34:39 +0800
From: Hu Song <husong@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org
Cc: ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	Song Hu <husong@kylinos.cn>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/mm: handle fork() failure in migration tests
Date: Mon, 11 May 2026 17:34:32 +0800
Message-Id: <20260511093433.2372985-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 335832000C
X-Stat-Signature: zb9b9s1bkafmh7qbsc7d9ou6hi86u3u5
X-Rspam-User: 
X-HE-Tag: 1778492087-207686
X-HE-Meta: U2FsdGVkX1+67gIHYz6Dv3e8hy5D4uplg/dFK/VJWuJgB7N3bqgRlte8aKTlzcQ58XogyI1ucIpnDiPUpZnqEYGXwT5tCWqtRaudRdwT4+O7HWup8P0cqwdyr2vpTrcUqYUWisie5xPonda5KC2flFjwUyxNimU0+cqx4WWeHoTVSOKMDjTCvhntpHbmNsDci6/wTAiFuZXLhsMDD1vshMvqw9n8mCe28ZqVmOVqvPb0PPrQ1Awk7ZrR0P/nOFlMKu+OKAHk9iMkbuqqPlJ6uG5Q1WwbFvYhsKIrPgKNIRMxYlQGNz8k71ZmBxw5RPXYuCQVjrVvrBEGCjHRH+m0fr7O07CuMuNgYxp71sVi7JBR2ysILMKG/s4oW8GXrvhKK0mvTfMs4QyBYMULA9bNizQnwvnfHJDf22UVqMnm032CReZOCviMmO8t6tyMxO9m7OQ0QI2HvgjmjVU9d2YfcVlNeFY6Tp6/R+CxvwU4RV9bTDW2ufbu0lXdB/g4MmzI+tc0zAmhetHXy2waHseGW20iTfHsLN9a2NO3/Vo6fZ1sWk0wU3ZfmkBv0GAH5HOj57iBUtv7DynMLmOVnv834LlP3ZIyO+ljJzavDqTjCwfzk+otrMHkVx4wh9Wmqretk8mSkSniyuq+oRw6K5uB9kpxVhwPiYxFeD1onridgqSUhLj1+GE6NtWzGy9wJ9sAM87uEhRqa61QLZ9gWc/m9rvFGA/S5323S+qXrMrtSVQPgb1B0VFwkkqj3w6U0jIVZhlPWF7Gx/DdeJ3bmCyli7flRR3Pb3qJa8wWy1xPfcHLO6EDXWCFT73S5a7ksC+GDoJL/5Ct77PFuwqQ83idUMsvbo372nN9NzRFMT2kezfsPTmyiTwOvrzp1O2Gm+M+gIvrnFvZ+LUl+eEzDo3BJcytWDCHJvELNyvQ3iR25Mhz0P8AkaZ2H/FKYi3PRXBgB27++drEME7rnZA84rf
 AQnaT/79
 CcVTZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Song Hu <husong@kylinos.cn>

When fork() fails and returns -1, the code falls into the else branch
and stores -1 into self->pids[i]. Later, kill(-1, SIGTERM) is called
which sends SIGTERM to every process the user has permission to signal,
potentially killing the entire user session.

Add an explicit check for fork() returning -1 (pid < 0). On failure,
clean up any already-forked children before failing the test via
ASSERT_GE(pid, 0). This fix is applied to all three fork() call sites
in shared_anon, shared_anon_thp, and shared_anon_htlb tests.

Signed-off-by: Hu Song <husong@kylinos.cn>
---
 tools/testing/selftests/mm/migration.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
index 60e78bbfc0e3..f433e4f195ad 100644
--- a/tools/testing/selftests/mm/migration.c
+++ b/tools/testing/selftests/mm/migration.c
@@ -163,6 +163,11 @@ TEST_F_TIMEOUT(migration, shared_anon, 2*RUNTIME)
 	memset(ptr, 0xde, TWOMEG);
 	for (i = 0; i < self->nthreads - 1; i++) {
 		pid = fork();
+		if (pid < 0) {
+			while (--i >= 0)
+				kill(self->pids[i], SIGTERM);
+			ASSERT_GE(pid, 0);
+		}
 		if (!pid) {
 			prctl(PR_SET_PDEATHSIG, SIGHUP);
 			/* Parent may have died before prctl so check now. */
@@ -235,6 +240,11 @@ TEST_F_TIMEOUT(migration, shared_anon_thp, 2*RUNTIME)
 	memset(ptr, 0xde, TWOMEG);
 	for (i = 0; i < self->nthreads - 1; i++) {
 		pid = fork();
+		if (pid < 0) {
+			while (--i >= 0)
+				kill(self->pids[i], SIGTERM);
+			ASSERT_GE(pid, 0);
+		}
 		if (!pid) {
 			prctl(PR_SET_PDEATHSIG, SIGHUP);
 			/* Parent may have died before prctl so check now. */
@@ -295,6 +305,11 @@ TEST_F_TIMEOUT(migration, shared_anon_htlb, 2*RUNTIME)
 	memset(ptr, 0xde, TWOMEG);
 	for (i = 0; i < self->nthreads - 1; i++) {
 		pid = fork();
+		if (pid < 0) {
+			while (--i >= 0)
+				kill(self->pids[i], SIGTERM);
+			ASSERT_GE(pid, 0);
+		}
 		if (!pid) {
 			prctl(PR_SET_PDEATHSIG, SIGHUP);
 			/* Parent may have died before prctl so check now. */
-- 
2.25.1


