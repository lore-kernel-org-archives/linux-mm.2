Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E7B0C44500
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:17:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60FC56B00CC; Mon,  6 Jul 2026 04:17:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 599596B00CD; Mon,  6 Jul 2026 04:17:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4895B6B00CE; Mon,  6 Jul 2026 04:17:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1A7F26B00CC
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:17:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 998D0C1834
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:17:05 +0000 (UTC)
X-FDA: 84957646410.13.A7A6D5F
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8921440007
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:17:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783325823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=EqdN0nfRX0ZtDirMKcDWYNz4PQakUYyNbq2l57Z9lB8=;
	b=lMcWjWeNOvgUlerFMv56MxmRgWnN5rDzdcnPb4LUQQKNbs2V4nYqz4tmCZ+IFfTCjMDL6L
	6LJDTz6YgI36WoiYX0g7mbU3d77/N+KmZ4M35fzdJy8rqN6KCLRUDmkNRh5yeSfOnEiJDU
	rxOOsQyNseShR3d4QY0GSgua2s9tXbY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783325823;
	b=PwUoDYeNyOrRraqFeltHkY8+/MdNEMOmcdnpxPyFceIPvnA7ApfBamHkcjK0HSU1RtmsX3
	2QCy2wnMpyjETyXkbJfthM5Qa7Y24D+rMpokguiG8zcmIal7bofK7KVdbh1MYTov9WdW4z
	/LEZ6rZ2LMGoRXTScq21mBFbqF03DMA=
X-UUID: 0cc495b0791311f1aa26b74ffac11d73-20260706
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_FG_IT, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:dbe34077-1383-4c34-9d53-cd4508c2c74e,IP:10,
	URL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-15
X-CID-INFO: VERSION:1.3.12,REQID:dbe34077-1383-4c34-9d53-cd4508c2c74e,IP:10,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-15
X-CID-META: VersionHash:e7bac3a,CLOUDID:c96d5a668d2e3432a5e6483a35694a94,BulkI
	D:2607061616569IP18YBF,BulkQuantity:0,Recheck:0,SF:10|38|66|78|102|127|136
	|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:99|1,File:nil,RT:nil,
	Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BR
	R:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0cc495b0791311f1aa26b74ffac11d73-20260706
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 975551959; Mon, 06 Jul 2026 16:16:55 +0800
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
Subject: [PATCH v10 0/6] selftests/mm: refactor pkey helpers and fix mmap error handling
Date: Mon,  6 Jul 2026 16:15:54 +0800
Message-Id: <20260706081600.3570203-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8921440007
X-Stat-Signature: erzu4jnk7s5ajwxb1xrhwhsf8iaepqtq
X-HE-Tag: 1783325822-15118
X-HE-Meta: U2FsdGVkX1/o+yDIYR0XsrrxPuLYGvgEuowJ013Ay4RxPhJKmgNV/ukT6abVCfssyNrBjf2oUoUXhYRBUk+W+l1Vu8PMrc8Po+pJ5DZjcB0Hiq7KFNSMoetG4hCsAWIi0jEo15xZYZwDF4kEjur4/UrKlCbRmgoL6Z02d5cXg+eL3kQ1kHAKtYPrzE1Vf82K8Z/VuY5xpMqzCTy253AeVBnKT/SGLRvQB8gr5UEE9Wi6fZIH8qCAJmuV+NcOjaOBgUx/p0bz38IopTIXd53oCqQL0QFgQOGW+mhtn8ZulaHbvhuAkfvnHjDQUjpOnDHfrB6XxXucm38k5YNXj9qrb6hN9XabuohBlmJMtlfd8zxr6pUe+j7d0IKsxw9gX74rgSOJ5b3yq/uuDujgZRWmXmneRoJRSCgo+CAvkcRPrtGL1PqbL84xnf2NNCRybi6KzBzyhsAouoeTsPvmqnovNYZkmyXVcILs74/osx6fljrzAL0Pne59Uoiu7eGqfLH1pVLTNOz7qteu8Fz20U/n/XF2oaSlz+/lTuVP9MghZfJT8N0RLz1Dib3bRkIRB79v0X5smt6ipxX5DV6AmiPU7Rsjki8xzNnOqnEgjqZbOvmPfBkH8UpO0TOlR/d4oMDIESykBMUe0hLDVDFFYjlFsysd9Bw7e2PZczq6CctNfYG9IPM0Buh5lUWlC56u/IfrCv3Dhax8pWd81B32Z0kIrYIXwEVSYC1ZyGqJMRInOtcwIR0Rum9Oj5O9i4sGJAV++eY1PykX3nJJh070F6LWkHMPTYRd8ey9++bWX4dTQi+OSNuZ5OLS0QKiAHgscgz3iqokvtMNZzHBO8nGKI7AIjalcmwiLrVS4MyThdp7PQ2FBYH3m/Ksi3H2WsU3W3E7jLznjIa/1kkyAtd6qOAekmeNOs5X0FJsxV7NsbdTXoQ/ulFpvVQKSF0Hy2r/yudr8IQ9/qjMHwaLdAwGpzx
 zZmqiPth
 NQdCdXBdXy1Gb4x1m3FJn37ONzQ==
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

Hongfu Li (6):
  selftests/mm: move pkey selftest helpers to pkey_util.c
  selftests/mm: unify pkey sighandler selftest assertions and tracing
  selftests/mm: use pkey_assert on clone_raw failure in pkey test
  selftests/mm: add missing mmap() return checks in pkey tests
  selftests/mm: add missing pthread_create() return checks in pkey tests
  selftests/mm: fix clone cleartid race in pkey sighandler tests

 tools/testing/selftests/mm/pkey-helpers.h     |   4 +-
 tools/testing/selftests/mm/pkey-powerpc.h     |   2 +-
 .../selftests/mm/pkey_sighandler_tests.c      | 115 ++++++++++--------
 tools/testing/selftests/mm/pkey_util.c        |  90 ++++++++++++++
 tools/testing/selftests/mm/protection_keys.c  |  99 ++-------------
 5 files changed, 165 insertions(+), 145 deletions(-)

---
v10:
- Add patch 6/6 to fix a pre-existing cleartid race: remove unused
  settid/cleartid clone flags and wait for the clone child to exit in
  the sigsegv test.
v9:
- In patch 1/5, define test_nr, iteration_nr and dprint_in_signal in
  pkey_util.c and remove them from protection_keys.c and
  pkey_sighandler_tests.c.
- In patch 1/5, cat_into_file() used the wrong argument in the open()
  failure message; print file instead of str. Update the commit message
  accordingly.
- In patch 2/5, align clone_raw() continuation lines to the opening parenthesis.
- In patch 5/5, set errno from pthread_create() return value before
  pkey_assert(0) on thread creation failure.
- Add Acked-by, Reviewed-by and Tested-by tags to each patch.
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


