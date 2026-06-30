Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9FE4C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:34:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8F666B00C8; Tue, 30 Jun 2026 03:34:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D40BC6B00CA; Tue, 30 Jun 2026 03:34:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2F5F6B00CC; Tue, 30 Jun 2026 03:34:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A20AB6B00C8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:34:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1B9C7A040D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:34:13 +0000 (UTC)
X-FDA: 84935765586.06.1697C4F
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf31.hostedemail.com (Postfix) with ESMTP id D349020003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:34:09 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	spf=pass (imf31.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782804851;
	b=kiRaNRdeE7NZFLqHreU3HZHE3d5lBVxmxdTpGtP2NG4JJuexA9zl5MfRF+7g784bSePh2h
	0UzchieI5hjV7v7lBWYhzNKPafYblWfS6J6gvQbrWy4+t9QdO5p6VNAV52DIFp1mqLObcK
	zYn5ZLozpJeVhomrAzCOtOPWw6VB8vc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782804851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=VP6G4dX+KNtMTY22tRVZ3Wp37rZDJw9LeBXmGUcIvw8=;
	b=srlIw+GCtIQK4DqkRAZHJhaFDeVm7MlBAIe+Z4nW4kFbyn4zE4oIg+LYZ0C/fB0raiSkg/
	P42+y9rIfIoniCcNSL+UNpRebZKT0DxMMqgqlFfskBzXQES0WBzM17eFtorwZ8L2r34rL0
	+4Lh5zGTdbxEZoY0qWWTM6YGA+IaU0U=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
X-UUID: 1237ed92745611f1aa26b74ffac11d73-20260630
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
X-CID-O-INFO: VERSION:1.3.12,REQID:7cc4df48-54d6-40eb-a1ef-372245fde000,IP:10,
	URL:0,TC:0,Content:-25,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,AC
	TION:release,TS:-35
X-CID-INFO: VERSION:1.3.12,REQID:7cc4df48-54d6-40eb-a1ef-372245fde000,IP:10,UR
	L:0,TC:0,Content:-25,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:NOTI_GNA5D1EA,AC
	TION:release,TS:-35
X-CID-META: VersionHash:e7bac3a,CLOUDID:579fe322386de05c17de66cccb557374,BulkI
	D:2606301534044XVORWWH,BulkQuantity:0,Recheck:0,SF:10|38|66|78|102|127|136
	|850|865|898,TC:nil,Content:0|15|50,EDM:-19|2,IP:-2,URL:99|1,File:nil,RT:n
	il,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0
	,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1237ed92745611f1aa26b74ffac11d73-20260630
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 677204135; Tue, 30 Jun 2026 15:34:04 +0800
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
	keith.lucas@oracle.com,
	kevin.brodsky@arm.com,
	maddy@linux.ibm.com,
	usama.anjum@collabora.com,
	yury.khrustalev@arm.com,
	jhubbard@nvidia.com,
	joey.gouly@arm.com,
	zwisler@google.com,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH v8 0/5] selftests/mm: refactor pkey helpers and fix mmap error handling
Date: Tue, 30 Jun 2026 15:32:30 +0800
Message-Id: <20260630073235.3802271-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D349020003
X-Rspam-User: 
X-Stat-Signature: tya5mxuodhhoc1s53k796prkkpu4gigf
X-HE-Tag: 1782804849-48755
X-HE-Meta: U2FsdGVkX187nu+hcPEKkBzngWGQOyIE9g9ZmXpl8sjhvEoqc1DutGp7wGL1r+GLMLtQj+TwUFbyijjR7mxY11d6YO0JSPqWvy8+cWZQQ1vWRT/9lRPHA0GYgarvLglE78d4nNHTVjf96B/cWh/CkFtO3C1ldOhzzSnxlk7byZGcfWsI4RzmeNZr7B2INeiKZN2Ay8rN0D5hvtnWaWKKsRFvZn1BmMJd5WyP62CZ0ViY+ldR22TXgMrGHBVb3A0LbmJti3vLMdY9R2uUrJR6q2J6l9UbjztdUj/u5hVP8rHn6eKM5pbNIbmBZghaFEQ8Eg+J6zQyd9VtC24tjetXuCIhjjq3qgfVgBTWoHb56VGKgdRn+sXAC2IRwCaolW9Csnmg1kACxG5G5oCbcOK0Lx71APEpuBuk877cTw2T14aAFkPWD+N+9NdzRYQf0VxchHKpGlY1fADuSPTSkz7jT6MfUGRI9O3PKckO+0uQTzvN+DdzviAMh9v+tNeAQy5n0TdzVBseaKWwWvAAoriniJA4p+6HGomdAtgnqj4bk51+zehOKmauAdaTOF/a65UoqTu8jVy+qSXXCXOKLXaFDlSmtnw3/h54JHTi2aqzHHX2UMe3xf0hOQuXqH81pDIIWr7zEdhh1T5HVfajm+aTQ0XL8abC63Jfst+Y3puC/KB0owHhugEezRijnylfizCm/cLS88Dlxyq5hj1MBgiskJ4+36Hueht38u1QAj4RcWp7ZGtlQ8fSdD67/iB/6zQPOahaJaiOkSISIRChEG4wy8VKtdFF+l3ndUfTFm64RXmdd4e3pBfbKZQy7gEZQjmoxWILCM5XcNlDvgnFiRlS+YLFolBOsqJvENUZycrzL55dMi8iiC4rQwP79M9DZkZVFK7OJWT8U1Jgq8yE3QAGkxkuz3mBNFLgFBuNaf8aQKs8SP41mx6t5261VdxJ7z6tKL7jANAI1KzONgd7lb6
 6GxSH5YU
 bm528auEs/SIMzA7uS09PjKqOnw==
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
v8:
- No code changes (relative to v7).
- Updated Cc list: added developers identified via `git blame` and
  `git log` on tools/testing/selftests/mm/pkey*
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


