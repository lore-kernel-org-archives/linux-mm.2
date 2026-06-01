Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AA79CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 06:20:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94B776B027C; Mon,  1 Jun 2026 02:20:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 922336B027D; Mon,  1 Jun 2026 02:20:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85F6F6B027E; Mon,  1 Jun 2026 02:20:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 785206B027C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 02:20:31 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 581C8140567
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:20:30 +0000 (UTC)
X-FDA: 84830344620.19.54E480A
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2C3061A000D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:20:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780294828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=Cc8PayjFYXrES4VvrLBjQbjTBioUYTqUhibROs1czcQ=;
	b=U+3VvSaoRKHpnwI2/woCrdKPrYMRGz8V3k6OyS79R/Mx12bbrXQmszfzOBUBSMR9H94xph
	rYkqyHd9vwnkDWzp0bjtI3mcrT6G+NlSghV1d4VOEhIopDPIUS5ZxcR6Vm4lljRjO1Tb2J
	nONsoWQagSSh8FJ2+5ocJwH+pWmVY/M=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780294828; a=rsa-sha256;
	cv=none;
	b=WVgv5tfwJOw17cHtZju4BcToWi+12J/1C7o69cf9n5vtoO8Lztbf1O7M/f+cTNbODLUktr
	yN8p3XtK5ruB30TC+GMeF42NcK9gUHVFxLwGrTKII+ML395eRRHqe2F6K2zWU89L9PKnxN
	93qdK4b5k99Vhr7MMs49+S+DUnNGSXw=
X-UUID: f5ce4aa65d8111f1aa26b74ffac11d73-20260601
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_T1, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:c09750be-4d5d-47d0-ab43-158f09b2c832,IP:10,
	URL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-15
X-CID-INFO: VERSION:1.3.12,REQID:c09750be-4d5d-47d0-ab43-158f09b2c832,IP:10,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-15
X-CID-META: VersionHash:e7bac3a,CLOUDID:b95280df6f48efbbcc9c4b1867cf65a9,BulkI
	D:260601142020HHSVIJTN,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:99|1,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f5ce4aa65d8111f1aa26b74ffac11d73-20260601
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1611578840; Mon, 01 Jun 2026 14:20:18 +0800
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
Subject: [PATCH v5 0/4] selftests/mm: refactor pkey helpers and fix mmap error handling
Date: Mon,  1 Jun 2026 14:19:49 +0800
Message-Id: <20260601061953.696844-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2C3061A000D
X-Stat-Signature: x7tb5hnm1kqh3rzyt4y4e5wdtaw37a14
X-HE-Tag: 1780294826-508513
X-HE-Meta: U2FsdGVkX19nBb+AS3g8GlV08Vcr3Oqi+ysQLiyzur9mCJk98HQxIxdPzGCekfo3g/CuWmpbf2yi5OKbjXMxdmfwPEY6+ZhqT4ejQuby415sofFVaXVAOdV6p9kVz7Ha/LfuVenpRK7pbOPNz6FXhOaj93jCkfRb1l6hQOIueaCfD40UUK8UiMvjpooUQzba28jXo6tWqvpjo5HeiwcFDjQBV22EmhT7llp+MGYRv/6gD8FDb8koxAYGdbnyZlUaIjXxXZjwSbarc0YcOxm/mdk+7BadJg5oe/rIlKylVfd8IfHYSP9iKCISYSElmx54Bu/BT61bBAwjSOp18QyJ/mX8JFNIstzQEiOLwOG6wQ4NTMnoUtNHh4BxLapnvnTHqB1+nk2+kNKsc/s2X5eub53F5Iq+4pYp9GUCaKvFQx3n64a7OjcX+JzCYqEu3DQ3La71F5OOOaXR1XAGcLtEHEvzo6DLgC4/+dYa8y+kS7D5jKqVs2KE7WsghEjNh1vnHYIynAMaJN8lixvBGc/1Uo5l+2VtAzDcB2c0U9QetYhO0N8x4trLcVlMiImhRuKtD+o0LGNNZH+y4IZNjDaK1XXDtf4sVxajB5NI8S6N6QOkaGMeU4X1Z/p6Y+bNj3BzHahxZU++bN9s5Yq+eX2d0y2BaGNPK62DMRaLaCqkR2k/47L/cb4LLVnC2L9K0d3bfU96V91rrZX6Ak6bG6EC7T+9GM6WkgSEmNgHyHZK2bud9m7pfqWzW3esTCnOeCMyK3w104cDai23gSe0DbMhGldI3sL8SgXJaDSnpjmiGB1pSTi9pJmcx19jTOIjPFOJJwuLDoIgXmIENzp+28V38PCdq47tHOYxCqA8Ki1pI2mW8LkXbjgRoPoEXAGzizb/R2vSnTmpRywQHY9G+qWVAc6NWn+hwXRJAUsaWhKOq8b7NA92N1IXVMYT++9innIeR01HwpZLWVaWEi+4l5A
 tY5kJP+8
 DqxCymjec+O1r1Y1aDTWYPNfk7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The main changes in this series are to refactor shared tracing and assertion
helpers into a common file, unify both pkey selftests on pkey_assert() and 
per-test tracing for consistent diagnostics, and add missing mmap() return 
checks with MAP_FAILED used throughout for readability and consistency.

Hongfu Li (4):
  selftests/mm: move pkey selftest helpers to pkey_util.c
  selftests/mm: unify pkey sighandler selftest assertions and tracing
  selftests/mm: use pkey_assert on clone_raw failure in pkey test
  selftests/mm: add missing mmap() return checks in pkey tests

 tools/testing/selftests/mm/pkey-helpers.h     |  4 +-
 tools/testing/selftests/mm/pkey-powerpc.h     |  2 +-
 .../selftests/mm/pkey_sighandler_tests.c      | 69 +++++++-------
 tools/testing/selftests/mm/pkey_util.c        | 86 +++++++++++++++++
 tools/testing/selftests/mm/protection_keys.c  | 95 ++-----------------
 5 files changed, 131 insertions(+), 125 deletions(-)

---
v5:
- Use ret instead of child_pid to hold the return value of clone_raw().
- Make tracing_on(), tracing_off() non-static.
  Remove cat_into_file() declaration from pkey-helpers.h.
v4:
- Base changes on top of the latest mm-unstable branch.
- Split the first patch into three:
  patch 1: move pkey selftest helpers to shared code;
  patch 2: unify sighandler selftest assertions and per-test tracing;
  patch 3: use pkey_assert() on clone_raw() failure.
- Use ksft_exit_fail_perror() in main() for mmap() failure.
v3:
- Use pkey_assert() for remaining sigaction() and clone_raw() error
  checks for consistency.
v2:
- Update commit message
- Move shared tracing and assertion helpers to a common file,
  replace assert() with pkey_assert() in sighandler tests
- Drop assert() from main() in protection_keys.c and add a proper error
  message instead.
- Link to v1: https://lore.kernel.org/all/20260518082120.3890552-1-lihongfu@kylinos.cn/
-- 
2.50.1


