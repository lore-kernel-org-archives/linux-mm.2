Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C047C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:31:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42E3D6B00DA; Mon,  6 Jul 2026 04:31:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 405E66B00EB; Mon,  6 Jul 2026 04:31:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31E596B00EE; Mon,  6 Jul 2026 04:31:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 05B526B00DA
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:31:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 86E4C1688D1
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:31:22 +0000 (UTC)
X-FDA: 84957682404.12.1A1B706
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf02.hostedemail.com (Postfix) with ESMTP id AEAAF80005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:31:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of yanlonglong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=yanlonglong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783326680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=RlF8PuvlixEYAUvWvNtxJhyK4uLFNVch+LcgXOfW7R0=;
	b=ukGebznGIefRVKu6n+v4k6c+bxOm1PfBDR7gvHCnU7octh9oXwpUWx1D7w8DzAYcG+PkVE
	R+ZN5cLaEIJ7OzKQHYVsWn8YlAKRa8BTe0UGMWs/YfE3smm7yYQGXGkzFQcMDvhg2rEcuf
	jkmE8PZ8uoVXQUVsqhb2uaaxjEd1WME=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of yanlonglong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=yanlonglong@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783326680;
	b=AevtXfriRE667fcQELg1TJzELqSwhdr5kY/Ins1ftpImxUqF5uwxS0u/xoNW8xtdHIBAjy
	48r4P+qFO+W2mUo4qXTixZA0A/3I772ryYes2+CyqRufUE0+Qvq+fRg9hLRwzDkXPxhd15
	mp15RDoehwcEtWorfmXEjNHGi8Ajp1M=
X-UUID: 0caa8b3c791511f1aa26b74ffac11d73-20260706
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:5ca52b17-8bc6-47c5-b669-36283b6b6736,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:0f7640c3917bacfe8958206c6d9378c2,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0caa8b3c791511f1aa26b74ffac11d73-20260706
X-User: yanlonglong@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <yanlonglong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 739898778; Mon, 06 Jul 2026 16:31:13 +0800
From: longlong yan <yanlonglong@kylinos.cn>
To: akpm@linux-foundation.org,
	rppt@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	longlong yan <yanlonglong@kylinos.cn>
Subject: [PATCH] selftests/mm/mseal_test: Fix mmap return value check in test_seal_zero_address
Date: Mon,  6 Jul 2026 16:30:48 +0800
Message-ID: <20260706083049.187-1-yanlonglong@kylinos.cn>
X-Mailer: git-send-email 2.47.1.windows.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AEAAF80005
X-Stat-Signature: wu5a7u81thnrqp3jbpq83qixetzs77oj
X-HE-Tag: 1783326678-902729
X-HE-Meta: U2FsdGVkX1/WC2YA6Sn5jQmHrsLgwtyfqqTvCpIL6A8bnxU3/Os5zrkkpF+D5Sd0Tjdq5OWhwvI/M+jUhadWXzpk4axsYyMgEE0QnIdQBmgZvWo3lFMajMHHN4em2TVLnCmITsQ0m9Z24huIFgta+1XaJow63Ea9MBAzw3dwzJYSn0Bj7i5ht9bq8QDcl6WZ/y0K40Ai7720V5Pckf3EyHf3zvNhxVKJTR4+xIPQLWpC5kVMoCf5JfKQRGvdg3J1k2kFFF4nIqYpcIQ9yvTJcxerW0oYFwEk8GP7kb4S1GccZnRvR3wNdqZhfYL5DOR0MJNSLa98R9h3kWEJYY1ped9XCx60mYByz1ueEe0rCpxNpH7/n9SescocDIl0LjBTxFQi4pxCOElGQz2T8GQp+GbmStzbGFXU+eS+agyRYprY9E1PLA7pwY8a7l8Z5NRB2wBdEGaTnJAL73sHkCd3nrWxLvfhwcSwGJcR8rAbmqoOMf6NPPm4O87LIwUu9Cc7Ko36la6jgGIeLOsG2apj1nvg5PwOmzXHxbuLHzDJ+bULeXmXW19nCxVufYfreXvtraOrvPeYYq1Ve0MZZXCv79gqoq+ffd6pmRuNXraDvHys5egcKiy5o12OUnOXztWlBpPhGp/Ki2fgG2gxmKXCCgEu58iNXZ5Z8gOoOKHLR1RYhAyQozyQylMbz29BVInnXzkPVFb/DqyoXNEdCDRxTXPtGH5qV94iTxGoOgGM2Q9SleFiXCNKiQ67frGyTDVwRnTdKaI9dZvCZ18q74RfsKGCvOzpbRbQH8jhZ0AQn4mRPNgRHPSMXV4yb8zhFClgKiQ9AjUQJ2JZQVt0EgWOibIoUmcY8AFskbHhpKSkw/HpVfKUhrXrUpwx1T6/5ypILFQ+mtV8yGG4RPr33lFsRzUsNvkmGPVwj+nHY8G5Mp2cgf9kDm5Ww/++Ay4lq7fzH9MOjALdladqRlzzbDB
 McCXqgVs
 N/bq7fMqHUkrBtIbg3Jky19d5BS2Vs1QQoY33ILlR7lN5/Is=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

test_seal_zero_address() uses mmap() with MAP_FIXED to map at address 0,
but only checks if the return value equals 0. If mmap() fails, it returns
MAP_FAILED ((void *)-1), not 0. The existing check FAIL_TEST_IF_FALSE(ptr == 0)
would pass when ptr == -1 (since -1 != 0 is true), causing the test to
continue with an invalid pointer.

Add a check for MAP_FAILED before verifying ptr == 0, consistent with all
other mmap() checks in this file which use FAIL_TEST_IF_FALSE(ptr != (void *)-1).

Fixes: 4926c7a52de7 ("selftest mm/mseal memory sealing")
Signed-off-by: longlong yan <yanlonglong@kylinos.cn>
---
 tools/testing/selftests/mm/mseal_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/mseal_test.c b/tools/testing/selftests/mm/mseal_test.c
index faad4833366a..a6ecc81c6aa0 100644
--- a/tools/testing/selftests/mm/mseal_test.c
+++ b/tools/testing/selftests/mm/mseal_test.c
@@ -482,7 +482,7 @@ static void test_seal_zero_address(void)
 	/* use mmap to change protection. */
 	ptr = mmap(0, size, PROT_NONE,
 		   MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
-	FAIL_TEST_IF_FALSE(ptr == 0);
+	FAIL_TEST_IF_FALSE(ptr == (void *)-1);
 
 	size = get_vma_size(ptr, &prot);
 	FAIL_TEST_IF_FALSE(size == 4 * page_size);
-- 
2.43.0


