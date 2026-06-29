Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A9F3C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 10:34:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6EA76B0088; Mon, 29 Jun 2026 06:34:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1E586B008A; Mon, 29 Jun 2026 06:34:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 870CC6B0092; Mon, 29 Jun 2026 06:34:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 619626B0088
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:34:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E6AC8140642
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:34:27 +0000 (UTC)
X-FDA: 84932590974.17.0BA56A2
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5FCB440004
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:34:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782729265;
	b=ZJ7hLlRIqx+BYf2jZaDah30PshWbMwwpxrvm3RFuyuMK/ihVuJ82tGYwt1B5swindbVVte
	Qpt+QuZJ3Y7l5eVCfD4XTwQ8JcD+RYbrxMLh28AewWlQdj3aTJglxGNDtEGAFlyzlZXzd1
	Z5U2Ps7S9n/Jyn16/lxEf0zMWehKbWQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782729265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=4mNneTWyWVwCvSvUOpO4NTDZMZcpzm3yGL9ZUFz6qNY=;
	b=6lgxNuKZZdPPaZVnpg/RurF03PriCz5FLxTCMJkdWncllJYYztZvlP4CWyuhs+UlKyms5X
	PMsjWAs38/x7KQUp+hXJNbEKWtiJP+e6zE8bEz9u37dBozTX2fh6XZVw0pqzHRY7rSjbhL
	vHWBePxO7R3Kx9E5R9oyhs4SWu4QPhs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
X-UUID: 129ad24673a611f1aa26b74ffac11d73-20260629
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:3821161f-7a15-48bd-a63e-466e4c460510,IP:20,
	URL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-5
X-CID-INFO: VERSION:1.3.12,REQID:3821161f-7a15-48bd-a63e-466e4c460510,IP:20,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:e7bac3a,CLOUDID:c635ce8eeb3c361042ee0c8f43e532ad,BulkI
	D:260629183416OY04I82N,BulkQuantity:0,Recheck:0,SF:10|38|66|78|102|127|136
	|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:99|1,File:nil,RT:nil,
	Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BR
	R:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 129ad24673a611f1aa26b74ffac11d73-20260629
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1344439313; Mon, 29 Jun 2026 18:34:13 +0800
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
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH v7 0/5] selftests/mm: refactor pkey helpers and fix mmap error handling
Date: Mon, 29 Jun 2026 18:32:29 +0800
Message-Id: <20260629103234.3240178-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5FCB440004
X-Stat-Signature: 5bjuxrrerof7dh4dy3osf5qmcnzk3kas
X-HE-Tag: 1782729264-390048
X-HE-Meta: U2FsdGVkX1+exDw8WaZ1XA78wkLL9cGwph9YmjH+E3U1Lje1zyagm+i/hL1wsgAeZVh6mvozCNLpOkr3Rwx+geQOmSL6oZAjgKX7pGc2jO/EBly4JaQuSv8lEhMhgN/pTFmOIPLSbVs84R3/mv0lmkMju0BnThYEnu9q9fTsFbZQ0bTRTTiHJfcAXoT+8ad+zOnt8v2NSevivXeRSRd+FqlAk3zaJlvKrzI3f8oEgx85rmvtv6XSRyNyQ80bMbbQTEwINItMOaELK+xQ+hOylLN13R+YlIxNmIEs4hN9R06hHJJ9zgmG2Ozu6cRk7mrSBaBvKvmmCBFL4HKIxWs+DhdFofRQolypBhV4zyZslFTtN9KAaD6r3CFNlMhs3VzOQWukVx3Gr8nqwldlricb5Emy9FT7SkL7nzqR+KNv644re365jO7C6WFCjoCNHAkxAJxhDMd8R5r6nQaApPqxKsGQIMZUg62TOVWMlHk+Md2aa56M69kIJm33lwOe975pv8t6t2e8M21AcMRf20EGUY95jSv7strZTu/wEP8eAn1fDlhjDchrT7Ir8zUSq4y3A/0004HrDk4hn1x8qZNYMgidjFBHiBJKn0ZAQsncnAVHAQGHc+1jFD3WfDGcpZPkXjjxwCLTMwvKLUAKQxLwtw6M0/H1Xedyj17/KO62rNjwkYH/I/c8fN4Ns4rNHpnhQcBx6C2pSulTnRQkhXMS29SKNcWgpAjNtW4Z4bZzvBWdreOWvMH/3//HH+htxxtUExYI52Xm8i3BzSuBQzTbig0IbGvCb8bv9qXz/vR1B0zGC2sW1lEbW2g1xKb88f0gtULbNRZEQ04eFLNcnU569xRRxoX9TUYuPxYTZLiLs67NfDAulNsFFRkTDm/9kjmgtnLGouM6JEiTGa5IAuLXFYC6XoHksKFhZP72KgmGzxa76KC1gPh6BLrMiwZVfieI30YOj5bjOOh6bQLq6CR
 lzx3Q0nf
 pY/HSx0dBC5Xzs+Bx1e301A0SSQ==
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
v7:
- As previously suggested, wait for v7.2-rc1 and rebased the whole series
  on top of it. No functional code changes.
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


