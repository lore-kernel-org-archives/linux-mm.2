Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E145CCD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 07:01:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F20F6B03F1; Tue,  2 Jun 2026 03:01:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C8B86B03F4; Tue,  2 Jun 2026 03:01:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B7E46B03F6; Tue,  2 Jun 2026 03:01:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1B8476B03F1
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:01:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2E42C2A6A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:01:17 +0000 (UTC)
X-FDA: 84834076194.08.8560842
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf15.hostedemail.com (Postfix) with ESMTP id 91BCCA0013
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:01:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780383675;
	b=M6Uu/IIcqjyiuzUwkqi2I7Sl6FAvzwagn+WOvkpPfj00os2Lt9KK+pslRBEuaH/AmjN7z/
	d+7G36SY0xbAm16wyjtFtElxEZKrmYDxZAaxjmKkP6PB42rNmX881XgSuzkOpSDqUFe9AM
	/IfwA4qjOQdSHBU3jt/u98ANNnCZf40=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780383675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=QOW7BCSKRWihD0AKRJEcHHviTuNsTYtH4RDaagxdffI=;
	b=HBRUcN1rEuwPsJ1DiBnthNarljaJrCtxchETtAoGbOEoNpdeyBwjV9aBEfblV7ta2/dAJr
	8RZ5AbO9W6s27QJOP73VkPz5+5Ru9lDUYEl/TPxk39+UPRg+BnwqjOSQ/SsL/EhkAT/5Bu
	sgML2CYu3S2l3kXE5axspDXOVVBw6/8=
X-UUID: d315fed05e5011f1aa26b74ffac11d73-20260602
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_C_CI
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:9b1c382d-5a1c-4f86-921f-fc3431045e2f,IP:10,
	URL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-15
X-CID-INFO: VERSION:1.3.12,REQID:9b1c382d-5a1c-4f86-921f-fc3431045e2f,IP:10,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-15
X-CID-META: VersionHash:e7bac3a,CLOUDID:e74fea4a7d163456aec5f6898ad0b348,BulkI
	D:260602150106ZA49CJN9,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	136|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:99|1,File:nil,RT:n
	il,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0
	,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d315fed05e5011f1aa26b74ffac11d73-20260602
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 826920972; Tue, 02 Jun 2026 15:01:05 +0800
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
Subject: [PATCH v6 0/5] selftests/mm: refactor pkey helpers and fix mmap error handling
Date: Tue,  2 Jun 2026 15:01:14 +0800
Message-Id: <20260602070119.1452308-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 91BCCA0013
X-Stat-Signature: smjxp4sqxs1fr9otkzftowxr9k4namtp
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780383673-867121
X-HE-Meta: U2FsdGVkX182ETB0UUBtksYgoo9ntxkp65PMsXWjspZgbFte6eeceCKPyatqut0PGSp3LmSqoLRNYlXSiiCm4GFeTleJ0dl5D7x9k9voczOYJutE0XeruLcvqCRvIUksEvJLsykO3oR5vtw6yBPJvjn7b/KNOiPrMIzzdLftnNvly1kHEvbtDfyV5Ws6T1qBo7GfErV+2sZVe6oP/6OmYbLGrnnTlQr2gFBIiPUGZM0YR/lq0wcMvrW0Wb602TEjhA6pSngB3r3ATnXNzcdZgDbyMT1d/CTlIK9jlN3JdYTpJ+GqhBZgm9xtn4ztUzujNbu2oV9LLdm0MQ4JrXWsqke2hXrhC+dmrnavCnZHaXg+O9OIiiQbCK2U+3l4dQh66FUBDzngA8IapuEWU58SFb7IHByKFc2HnHqyZ3V/f2R99PCryRBPRzGoAwhmRvvpEo1OhtW//qJk5TPL6ue1mUKVSKoPq+7eY//gwfl03rPwixGEXPG0NrnUprEbNQts39+KoPjHCkAcb2Flykaxdrbe+Gbcg4T9OjtZPta/ji8u1hhtmYcPvA3qDXbdtkMUWjAj3FAWLXXOZV1eu4qkOMqL8CcMUUx1NBQEIoUbVw82N7hOE+jrotDIBPDy7h6GyR0KBYBEhz8em/yDC2dqwUtj3D+mZlqfXDUTseabDf7+4Juk0MaT2XgLmO9UbQFYaWJhXaRWrKwBeihap1Yfgz0OkJcHB+wChL35t0A2gnt7BWeAb7pv7P4SbeAAT9DLpO7VrULhvGqX1QLsmr1beKqH1L6Nfocdh+lHkDtDdzybArf6Qa4bioLSTwKfpOO4riPVv5AfDRC026kKfcpEOKzptm+nRL2km1DNJ5jWghZQJDOLwuaJ69tqeh/pMCF7SJ7CTXsnOH+aHvK52TSbPsv+SFoHzQhUjXnPH4Sv5eh0c70S9RDzp5OgoVviNZ9ybuiEGxYOCpBhfMTVoff
 80djPq/D
 TyfDMfzoLa9sNEhmx6UAzR1sPqQ==
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

Hongfu Li (5):
  selftests/mm: move pkey selftest helpers to pkey_util.c
  selftests/mm: unify pkey sighandler selftest assertions and tracing
  selftests/mm: use pkey_assert on clone_raw failure in pkey test
  selftests/mm: add missing mmap() return checks in pkey tests
  selftests/mm: add missing pthread_create() return checks in pkey tests

 tools/testing/selftests/mm/pkey-helpers.h     |  4 +-
 tools/testing/selftests/mm/pkey-powerpc.h     |  2 +-
 .../selftests/mm/pkey_sighandler_tests.c      | 81 ++++++++--------
 tools/testing/selftests/mm/pkey_util.c        | 86 +++++++++++++++++
 tools/testing/selftests/mm/protection_keys.c  | 95 ++-----------------
 5 files changed, 141 insertions(+), 127 deletions(-)

---
v6:
- Add missing pthread_create() return checks (new patch 5/5).
- In patch 2/5, call tracing_off() at the start of test_pkru_sigreturn
  before the SIGSEGV handler is reset to SIG_DFL, to avoid leaving ftrace
  enabled on crash.
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
2.25.1


