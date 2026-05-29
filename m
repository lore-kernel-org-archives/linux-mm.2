Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 467C6CD5BD2
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 07:16:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A198B6B008A; Fri, 29 May 2026 03:16:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CA4F6B008C; Fri, 29 May 2026 03:16:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86AAE6B0092; Fri, 29 May 2026 03:16:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6C9576B008A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:16:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 136D8411CC
	for <linux-mm@kvack.org>; Fri, 29 May 2026 07:16:56 +0000 (UTC)
X-FDA: 84819600432.15.FAF040F
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6E6EE1C0010
	for <linux-mm@kvack.org>; Fri, 29 May 2026 07:16:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780039014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=261R4LAVZSOrNFw4VzI10zn3nylKXDz2Zc/oKgROB2Y=;
	b=rBHU4932mz5FYvPDfjFPNomfxEeo2qXLAnFJm58Ek1xWoQ8g1VJ82yVDrsqoLgGCFHphuG
	xYd3DS98uG0OyIezaxLgwhoiGrGQqvkhOhQrOmJeH0CGUCuHkX1NBFKXO5cvIX58EyLtxt
	y6PueWQ2gEaO3eP9fV3Wucp1NJJ3YsU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780039014; a=rsa-sha256;
	cv=none;
	b=7dkJcMGk5cOBU5UyhknFD8E3mhq8PG4veckSigCN+LOfbAS7yvpvGI5OOPwmLTsHxFMxui
	lDpzRKpbA0m3jpXQ2slayYzcNXKtPl55eHDAR0ftEgwdN+CcCiNdq+FzXPMvYyp1KKhAZ3
	fokxf9iutFAE7aXZQp8JeSbpjq7Zee4=
X-UUID: 5b4d164c5b2e11f1aa26b74ffac11d73-20260529
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
X-CID-O-INFO: VERSION:1.3.12,REQID:a49ada69-324a-441b-8965-40845cddc6a6,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:a49ada69-324a-441b-8965-40845cddc6a6,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:cdae462376a42f737d0b63fa83c056b3,BulkI
	D:260529151648UOJ642O5,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:ni
	l,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,
	BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5b4d164c5b2e11f1aa26b74ffac11d73-20260529
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2049664791; Fri, 29 May 2026 15:16:48 +0800
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
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH v4 3/4] selftests/mm: use pkey_assert on clone_raw failure in pkey test
Date: Fri, 29 May 2026 15:16:32 +0800
Message-Id: <20260529071633.2807814-4-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260529071633.2807814-1-lihongfu@kylinos.cn>
References: <20260529071633.2807814-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mas33dfd1qrkbq8qba6z1zxrgrm1uadc
X-Rspamd-Queue-Id: 6E6EE1C0010
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780039013-967677
X-HE-Meta: U2FsdGVkX18Qyy4VTH0RxYiM84Y2yZSisDOt6/72S5DMa/y6nvvXVBfXO/3EDgdG/fcc78SmrSFXwc8CUahwwKHCGNKFpkxI6Dr6tW4D7JiXvoa1N3cK/s8oTdy1TzscQv1iQoW7jJkXFurbd4elS5ZmKeD4IGwFYlnahWJ3DSHXWy7HYopEa7ErUlDRELTJl4vfzegwTpqH6HBjGlz8pSCHrNQ7nhTkr5lABnSD22rW7KsNmZOOxl+Z3PwAzEOt2Z+oEab459wNclvfGweHAo21tnMllei5A1A3jS9b+FVM4IKemq4X1215LLlLneSYObwm8ClFtWjSkzk+is0zBrW+t0rCJacNh78S95iBHlEmucXdOjD8wob2F9P8XaA8Cqtf3shtFMDIDsMkQCNIaLVluSbCnm6T660G/4HPI8Cz+HjYTkmqAN4GIFEb/XPragx836HZuGCbTZEU6KY+ivzaMFU1+WGBcgQQ8gE2jjrjV6PovK0d0NUIZ34ypeEOA1cCZ/E3BWGhaOWmcatyvJ/fipLnR+j8s+VFJDb8XXH/za/hIxz66Ow2A/yPmTXVv/OsOGOA7cgKlwZwpXgvfx6BnGEEuzh0ZUQCiOLdjFUSvTjXwKklBQyfl6hWeQDWRMBPaG5oeht0nmiyolNC7HN7yHQ6pNLJC2sXfytRupV0wOla5Lq8Ob0Cr8tBo1GIGUFzf2Q9+BBIOtGKkCFg+CwUkZ43NRlT/Fo3qa6YwWr3+LEwNmj+WZXC1e8lw2srNhL0iGQILUOEao5MVDuoE5+Y17JEMJlJxlWUkm7XJV4tJ6TiyGOKEGHY3Wo8O7oXNhkZZBhesnBlpZ3ZzAM62kuGuxcopHNa6yWJYPWmJeoNALwgE/di3tq7UXaNT5SFyiBpI2uLbjhrLwM6WLCYul/cG2RUHyW6oufgICX/TX/aKMMoBiAUeLhUlFGUkjD9R14+hdUMEekUP3QNIyg
 ODrmCwCN
 gS9NHcSK1O4TI/BIFpGfHv4bfr3bta4MXbnf0Ce6YyRMofWD/jUmlmjQlqw==
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
---
 tools/testing/selftests/mm/pkey_sighandler_tests.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
index 80b5b3dad86f..231dfb079075 100644
--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
+++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -333,7 +333,7 @@ static void test_sigsegv_handler_with_different_pkey_for_stack(void)
 
 	if (child_pid < 0) {
 		errno = -child_pid;
-		perror("clone");
+		pkey_assert(0);
 	} else if (child_pid == 0) {
 		thread_segv_maperr_ptr(&sigstack);
 		syscall_raw(SYS_exit, 0, 0, 0, 0, 0, 0);
@@ -500,7 +500,7 @@ static void test_pkru_sigreturn(void)
 
 	if (child_pid < 0) {
 		errno = -child_pid;
-		perror("clone");
+		pkey_assert(0);
 	} else if (child_pid == 0) {
 		thread_sigusr2_self(&sigstack);
 		syscall_raw(SYS_exit, 0, 0, 0, 0, 0, 0);
-- 
2.50.1


