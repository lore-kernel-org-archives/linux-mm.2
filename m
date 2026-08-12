Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F8E4C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:22:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D80E66B020C; Wed, 12 Aug 2026 09:22:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D585F6B020D; Wed, 12 Aug 2026 09:22:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6DF56B020E; Wed, 12 Aug 2026 09:22:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A265D6B020C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:22:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2F8FA160311
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:22:12 +0000 (UTC)
X-FDA: 85092680904.05.090CCD4
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf28.hostedemail.com (Postfix) with ESMTP id 17C45C000C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:22:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786540930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=EYYOphICtYtHCVUupDmANEPQD5yAAhdvAcDi65ZZTRg=;
	b=iHefCkOnuXmX/zVc7PyiLcksAXHZWCq8pnzoc7TkNcRPWiW9MRCThokLImCvMAI7cN3rUG
	7wdZz4RWoX5xW2OIVaNzcSPECMwGuIOQsUCMUP9vkVazWLIhSuWP6n0jbU2vgvlmZ7jtBC
	utvXodvPV3uwDgiVKU1+3JqG6KqyWL0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786540930;
	b=ZkD9wiXTd3QNDwxLAlmRq9b2r51+XA6sXD8KEyJXM+Q7fdRy+TNMHy9CcATUdIBSlrp/gb
	dzGcuAat1WoE8RrHHWQtZANElYwD7fRn0hHdnNxyUClk5xsgTHn+SVDBCuqfhWWVcP1U23
	9thT6LWtxOmwIsTtixar5EWthhdyXjM=
X-UUID: cce0d8f4965011f1aa26b74ffac11d73-20260812
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR, DN_TRUSTED
	SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD_SPF
	CIE_UNKNOWN, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:eb037276-518a-4fcc-b759-db01d5c8f2df,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:eb037276-518a-4fcc-b759-db01d5c8f2df,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:5fdead9ffa7f0d485e2d6fac3d78819d,BulkI
	D:260812212203Q0F9UBRJ,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil
	,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:
	0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: cce0d8f4965011f1aa26b74ffac11d73-20260812
X-User: husong@kylinos.cn
Received: from ctao-book.. [(111.162.215.50)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1436825829; Wed, 12 Aug 2026 21:22:00 +0800
From: Song Hu <husong@kylinos.cn>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: shuah@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH] selftests/mm: emit KTAP output from ksft_kmemleak_dedup
Date: Wed, 12 Aug 2026 21:21:41 +0800
Message-ID: <20260812132142.582390-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 17C45C000C
X-Stat-Signature: i3amchd1uhuiewyy5wzozpghotntoady
X-Rspam-User: 
X-HE-Tag: 1786540928-3074
X-HE-Meta: U2FsdGVkX18l/yCmKAbZWmqvl29haU8y8D5xIY0IJJNZ9ctbZ6+7tJVHpTKPydhVX8n5WDCVOstSKQfgrfoyPugRW4qQgG9BpB1T5GHn9m4eTaLzib1/KpB7I6hrKeA6iKlZMxoqNIj8+hbhYQPAwcE5iGHsWx7bfadkPP0tDGwyTVkShVPfgjbjX3HxyJiTzTgfE6ZoN4Pci36bDRdYxr3YSEg0/EPwJZYuJf5uCl8jchK301rnTs+L06Eg50ISY5zz66VQT8QZFTWFSaCVgzBJG74nccF42bSfhCemc+4RMMucUZbJ2j1tmQHNx1B3Q9aDrpPWCK0edGqdaY7lxF+lbzYpkqbDWRpvumkQ/eVLyPT/URNXUsn4WJ8AjCMwUlGDWuVTkWaWwOw6urXBx4hOTe7dgbc2ntcmLMrwUxZzAXOwCKsyj7T21wcJ+s2eHHcUp+2e5xCMBYyIbv3jJMVbgmXNMBw71Copx6iYWo3ngLH76IlG/we6KxTHQL505ZKu0yqduYGR3zTuJgVpJ+WnO+M50HWKg6Srec4W7UveGS5INeboyCLNX/orTnskeLXK+PzBkE50EJxm8zoO58f3kxpJ/RhlGNWdkLnJLDaPq7VyOcDyjoVK6kLlNU6GqvwBkbD1W8ACy1358NqSf4ieaMiAunYOwb10tDUYxAq+OzwbnSRzGz7P5eru/cqhXKZvdtkhQO/5Ihd0njHHYKj57nBX29MWwczEFSIFOw8va2az8eTikNf5T1wZyEqDBA9dtzGFy8guHE3uXrNgKUa2cJWmFOn97c7MxF3NIeDtkP2ycxxqS1j5vMwuM/jz1u17d0X8WwnpH2oL6FW7mIeyvn2TRSE+uC5gn8roySblfqxx3Aqy1/TBzswZIHbh/KCKNrlcdBlmmfTlLwq3Inz3PgndU6oyA43yAmkshfuCAYRfYBa3ehP5DNfV67NnATh07Bf8EfZGwk0e2fy
 961u9SVO
 TNWTFtdke6ui4crUDlhkKAJO1ixVogWXwPMgnDfq2yvCfSQz+vX1Z2VNdiTsul8vCH/8vkHGVWDkfWCc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ksft_kmemleak_dedup.sh reports its result with raw "SKIP:"/"FAIL":"PASS:"
echoes and bare exit codes instead of KTAP, so parse_kselftest.py cannot
read it.  Convert it to the ktap_helpers.sh API, like its sibling
ksft_kmemleak_confirm.sh.

Signed-off-by: Song Hu <husong@kylinos.cn>
---
 .../selftests/mm/ksft_kmemleak_dedup.sh       | 20 ++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/mm/ksft_kmemleak_dedup.sh b/tools/testing/selftests/mm/ksft_kmemleak_dedup.sh
index d01950244490..2db7f006808f 100755
--- a/tools/testing/selftests/mm/ksft_kmemleak_dedup.sh
+++ b/tools/testing/selftests/mm/ksft_kmemleak_dedup.sh
@@ -19,24 +19,30 @@
 #
 # Author: Breno Leitao <leitao@debian.org>
 
-ksft_skip=4
+# KTAP output helpers (ktap_skip_all, ktap_exit_fail_msg, ktap_test_pass, ...).
+DIR="$(dirname "$(readlink -f "$0")")"
+# shellcheck source=../kselftest/ktap_helpers.sh
+source "${DIR}"/../kselftest/ktap_helpers.sh
+
 KMEMLEAK=/sys/kernel/debug/kmemleak
 VERBOSE_PARAM=/sys/module/kmemleak/parameters/verbose
 MODULE=kmemleak-test
 
+ktap_print_header
+
 skip() {
-	echo "SKIP: $*"
-	exit $ksft_skip
+	ktap_skip_all "$*"
+	exit "$KSFT_SKIP"
 }
 
 fail() {
-	echo "FAIL: $*"
-	exit 1
+	ktap_exit_fail_msg "$*"
 }
 
 pass() {
-	echo "PASS: $*"
-	exit 0
+	ktap_set_plan 1
+	ktap_test_pass "$*"
+	ktap_finished
 }
 
 [ "$(id -u)" -eq 0 ] || skip "must run as root"
-- 
2.43.0


