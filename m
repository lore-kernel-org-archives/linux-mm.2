Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAEA3C5CFC1
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 08:43:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE85D6B07AD; Sat, 15 Aug 2026 04:43:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBFC66B07AE; Sat, 15 Aug 2026 04:43:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD4F06B07AF; Sat, 15 Aug 2026 04:43:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 99A0F6B07AD
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 04:43:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1DAA8140321
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 08:43:01 +0000 (UTC)
X-FDA: 85102863762.16.EB5A37A
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8ED8220002
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 08:42:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786783379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=7rd8Gv8m8zoEm7+WtMzHNJ2NHhNTnGDpTCw98P9B33o=;
	b=nwrPkA22EZr0VDkBkGEvZJb2g5NUnbVZAq4JfJgfmyw7AGi3CEYWC/iEDi0H8pUnyStfzb
	OSUe8ABsbglQEZT7FwGlLUKd2nCj/ksgTNSedkECn7X6XZpeTpkYnBlDtW+aha2N3jemph
	765J2EvEhm+aRUpxvm2t5jQHzeehUwI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786783379;
	b=OPwQoBOQ4e4/vBM9dCKroQqDQQmhOHyamVS1YdHsRHnuiVZZ4Gc2oh6bI5KruJ8Q8WlUhK
	eKv0feH+cCHRPlSqJ5lmSOy0bVvvGlNTdDpHdGUH/JORBfkHJO5/jqykLHG+3FowVJ3+hL
	8J/efMgu2MjbHC3pVjqETi2mPKKOb6U=
X-UUID: 48f52586988511f19a56ed5b684f684d-20260815
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_LOWREP, SRC_LOWREP
	DN_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:04fcedad-7f20-4ed9-8ac9-20bac91f470a,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:04fcedad-7f20-4ed9-8ac9-20bac91f470a,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:9018be5d7f14e2b336be6e5a91adc8ff,BulkI
	D:260815164248ESVFLCWA,BulkQuantity:0,SF:17|19|38|66|78|102|127|865|898,TC
	:nil,Content:0|15|50,EDM:-3,IP:-2,URL:99|1,File:nil,RT:nil,Bulk:nil,QS:nil
	,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_ULS,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 48f52586988511f19a56ed5b684f684d-20260815
X-User: husong@kylinos.cn
Received: from ctao-book.. [(111.162.215.50)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1608222130; Sat, 15 Aug 2026 16:42:44 +0800
From: Song Hu <husong@kylinos.cn>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	usama.anjum@arm.com,
	leitao@debian.org
Cc: linux-mm@kvack.org,
	shuah@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	peterx@redhat.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH v2] selftests/mm: emit KTAP output from ksft_kmemleak_dedup
Date: Sat, 15 Aug 2026 16:42:31 +0800
Message-ID: <20260815084231.3630742-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xdnihky9cz87d96n6otxaap9ezkkgeyg
X-Rspamd-Queue-Id: 8ED8220002
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786783376-198593
X-HE-Meta: U2FsdGVkX1/0hDTjlT9w9poaQJPaRkBuj8lVp4SKDm0B9NkmvYDmmcqWItEPwKRJF0D9UiiqbWI2euursjzGZ2Iud1uXrmMaUDjSKwQOXYcptD1Uvq1VvxWpXEjUYG6ibwci5WGvuga9MDykrq5sgpOsXjNyK1DmOxpNp0jYwdowgdlFZRJ+v5V/pzNlR0K3/ED0EM6ur27j6/JpffTpLE3kXGSNXQEUshwckPYMPatQhCvbZ+Ods07YEIIAyCgoRneyP/6mIoGQUf42fL0dzLROyM/9+DxLBwVog85U0PNhrKzXZV7bVRqpfSZ4mfi9HFkEHVTYvlwaF6+bOCGQwpt6THYdNqmmWPeUXhSJQ70lkbJC86FEtZq+inU+n3sqwBdQBPmEHr+U8Jx8xepbDW9bXXFmoWxcsJLZXKz1Oaq8BP4yfHXl6CbSmSrzhJ4mVJJSSNnKxXntqofMwtSdr/X4QD2Z3Q0zTiLf+NyxvN0jQLxUJm3JaogQ8gnFu926/q/ND8GILjaXeOuvkrqs+sFG7Cg30aUNzvi/imky+VWYXbuVphJI4q9+VTmHElxmwSd+tSFHkzr+a2gq3db4pA0RyM6VTNYgGYWOFqhbdLch9+ZpNyP0fgvr+vsbh8Q9mCO+/xd4WYzyojaNgkQsqtvAAH0PDwdUAH5CsL2Kn6YKPJLaIsnEvh9iStJvQxkMzl4jiljOtrytwQjf1KvBNhWBJXaZcWBV3EYc7/vRaPxINchu4zLY49iSOc+p3aErC6F+s5ZRUGLirTtaGlKgvArsPeScujtpI6c0D3uvKa7gNc8T7nVWNqUaJS9P3HIt59gglpNGlaOgguXoLHe3UPwHIZSVEc/HkkDd5wzj5NJYmesgKxFetu7zVPijEzkL+GvOYHma3f135zqSGAjDocSjqJh6E8FJELe4synmu/6OgcusnplTsR9ONsWoBPHqcjkdHKE1BQ1mCJVyqFY
 qM4mh0Tt
 NAuy9PdjtUa6vhwRP5lsd4EDsJId/3RbiWmUxc69uESa/6sKRtCxRjS9kfDuewMaaLtQH5JrNGu6UVhG0NhWoA7J4C1MqloGbOTkP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ksft_kmemleak_dedup.sh reports its result with raw "SKIP:"/"FAIL:"/"PASS:"
echoes and bare exit codes instead of KTAP, so parse_kselftest.py cannot
read it.  Convert it to the ktap_helpers.sh API, like its sibling
ksft_kmemleak_confirm.sh.

skip() and fail() emit ktap_test_skip()/ktap_test_fail() instead of
ktap_skip_all()/ktap_exit_fail_msg(), and a single ktap_set_plan() at the
top covers every path; ktap_finished() then prints the totals line and
provides the exit code for skip/fail/pass alike.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Song Hu <husong@kylinos.cn>
---

Changes in v2, per review feedback from Usama Anjum:
- use ktap_test_skip() instead of ktap_skip_all(), and ktap_test_fail()
  instead of ktap_exit_fail_msg()
- move ktap_set_plan() to the very start so it covers all paths
- call ktap_finished() on the skip and fail paths as well

v1: https://lore.kernel.org/all/20260812132142.582390-1-husong@kylinos.cn/
 .../selftests/mm/ksft_kmemleak_dedup.sh       | 21 ++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/mm/ksft_kmemleak_dedup.sh b/tools/testing/selftests/mm/ksft_kmemleak_dedup.sh
index d01950244490..fda6a9340e0e 100755
--- a/tools/testing/selftests/mm/ksft_kmemleak_dedup.sh
+++ b/tools/testing/selftests/mm/ksft_kmemleak_dedup.sh
@@ -19,24 +19,31 @@
 #
 # Author: Breno Leitao <leitao@debian.org>
 
-ksft_skip=4
+# KTAP output helpers (ktap_test_pass, ktap_test_skip, ktap_test_fail, ...).
+DIR="$(dirname "$(readlink -f "$0")")"
+# shellcheck source=../kselftest/ktap_helpers.sh
+source "${DIR}"/../kselftest/ktap_helpers.sh
+
 KMEMLEAK=/sys/kernel/debug/kmemleak
 VERBOSE_PARAM=/sys/module/kmemleak/parameters/verbose
 MODULE=kmemleak-test
 
+ktap_print_header
+ktap_set_plan 1
+
 skip() {
-	echo "SKIP: $*"
-	exit $ksft_skip
+	ktap_test_skip "$*"
+	ktap_finished
 }
 
 fail() {
-	echo "FAIL: $*"
-	exit 1
+	ktap_test_fail "$*"
+	ktap_finished
 }
 
 pass() {
-	echo "PASS: $*"
-	exit 0
+	ktap_test_pass "$*"
+	ktap_finished
 }
 
 [ "$(id -u)" -eq 0 ] || skip "must run as root"
-- 
2.43.0


