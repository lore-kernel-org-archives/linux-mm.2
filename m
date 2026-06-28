Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FBBCC43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 10:11:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 130586B0005; Sun, 28 Jun 2026 06:11:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E1936B0088; Sun, 28 Jun 2026 06:11:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3F056B008A; Sun, 28 Jun 2026 06:11:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D18BA6B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 06:11:38 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3F0CD1A0371
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 10:11:38 +0000 (UTC)
X-FDA: 84928904676.29.2746B5F
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7A5A818000A
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 10:11:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gu4G3yKs;
	spf=pass (imf16.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782641496;
	b=a7I1rV0VrfgEZEfewsnF6UKA1uV3W+XksasRnDkgipSZwNMp0NuwWZRnmomLx33AVyvWrb
	snxhiz1wBoeQCwImow4z2o9onzV2LbBViTVaZNbAw8b99GT1Bl/xzYEajhmXhaV6LogcYv
	eobCCuNg0P5YmOmZLWTnCwUAKk8qYGc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782641496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/FXxFOl7E9feXzC4XdYQEI/BCMSekolzWSRC+gy20uU=;
	b=SbK2KlDArXL1iyYdXYdO49wRKrzP6NVZiDJVPwYRH7r0EOz/lnJD2Mj+/JezTiEx7mUXvV
	JxarZ9yaHY7AXzDNu4RQGjwh66ZImHDyurMLeMez1v5eH7woDMwjoe1AqjPE3OG4BDvheN
	XWmjrJT6OSQDOMp7qIRC2zY/XqlAWFc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gu4G3yKs;
	spf=pass (imf16.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782641494;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/FXxFOl7E9feXzC4XdYQEI/BCMSekolzWSRC+gy20uU=;
	b=Gu4G3yKs1r17iq2hxE0V5jXT5++Q//mG7LBNPjGv/CTGvDVFMn2quqRpaQjMAFG3bhY/4J
	GUlD12Yw4i9gUAc+mo8AXwjlVz1Vksd9gHEJ2ZGXGuQ/aCPwolM3H3pJWwT58ypVh/1DFu
	4cTYLLyAGQlAwsyjfMbvcgzlPkgpdLE=
From: Zenghui Yu <zenghui.yu@linux.dev>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	usama.anjum@arm.com,
	Zenghui Yu <zenghui.yu@linux.dev>
Subject: [PATCH] selftests/mm: pagemap_ioctl: use the correct page size for transact_test()
Date: Sun, 28 Jun 2026 18:11:18 +0800
Message-ID: <20260628101118.35861-1-zenghui.yu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7A5A818000A
X-Rspam-User: 
X-Stat-Signature: wjhn8kedxcsjdkapg3qacnr78e1uc3pa
X-HE-Tag: 1782641496-115368
X-HE-Meta: U2FsdGVkX19aPQgfe593eONsb0HlTxYViQ5U17kkt5dpH9gePBDqmFeOoL9auMZvkDQAyBlHoiWUTMQMe++R91zfEBfVko6quQarHmsS9iL4/kv3lBtmKnxMudKImQkgx7GWFyLLwF/YOsjUeUCYpme1kEZgYE6zV+jlvTYNh44o3Um6A/rVW3P3T5rhxMWU2GPCSWDsrOy1/8F+T8PY/oDXB1EaxLEp9bCkZImwACX9KErU2kWb6D54c7HZjr060ZTflaxO3SztMuerM+1fXrvuKn+CygQrSeX9B0lnYxkiyWGVVURBJ9MVsoD9fybo1f0eDb4wUH9RUSvKDl1TK9Lm/Us+51E+iqVJ8wx25sBw4Pk0aFthXd5rFsOaQyL8Cgh4+KGE6QJrhweuZC6lOmd8z7EU6zN72+kETtS2i7EVgqfpte+wfRJ7GObePyhNuJUbEtqGh7vL9PRfPweFj8RGqOJLHLGT+j9QqYVj0Lz0iX5PPNu8HCK6UxZegmw0dcZjDtsyo4NMI0Ddb42Q9dwNOxbg+qGf38/H5n+uv7Go4Jy0GTR2Y8e+jZMcZstPkgpsCk35MNbhOXKHgjLjBplx0su/7IW5i6KYvyaXmMRJaScJc9KPLvMrZu3jVJrhZ/t/UiK0BT9HWMUSwEcNs06CR528EAdf3v0X9vVT3rB9wxVDK2iTqdGN7pRnZLOiBYvHKPmcFRmIMAy1HiPaPs/uPj6r1oq5jvUQK4EuhXnVzEqDLYOmssOa/Us35ebMFxFetilyokgaS8hKPkY9lUQaDgdXNU57GNHNhgH9kG9Wz+wae4/T5XuqYS9AaKftvS/EAwuYUmUIqN2napeyCP/SLUkow8fTkb8Qj2nc7SNQsM9ynkzklSpLHiuhtb3ZmUZlwWAXcSNAWPSXvJ/KpGxedTXx8uSClj5m8tnFmNYJSIDY5/P+IIYhc5eUYa6yPp5Do5xm/hjnCYvIKUK
 De/P5jfe
 zSgWLFHHZ2WZJttn7TEQnTI74KuavJErlutbt7vYz7iXcp6lzvbCKIKDvk5Q6hRomFxA/OUq46Ah6N4tmNDxEmkgx5FmFaeyjJ9Z6wStoWmF1JMtgZ88NqT1C18IFiSKnRXobNCnqyiyghe8+bhIBHJArSHikRYfG8lqAii18QkfNMHFNx+VBVDoOBe/lcSSWpwK2QDOLMz4gR6YXguSOAtMjqdU2lg67XCCyRzTkDsSD4t7NYRl990XzoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are several places in transact_test() where we use the hardcoded
0x1000 (4k) as page size, which is not always correct for architectures
supporting multiple page sizes.

Switch to use the correct page size. Otherwise ./ksft_pagemap.sh on a
16k-page-size arm64 box fails with

 $ ./ksft_pagemap.sh
 [...]
 # ok 96 mprotect_tests Both pages written after remap and mprotect
 # ok 97 mprotect_tests Clear and make the pages written
 # Bail out! ioctl failed
 # # Planned tests != run tests (117 != 97)
 # # Totals: pass:97 fail:0 xfail:0 xpass:0 skip:0 error:0
 # [FAIL]
 not ok 1 pagemap_ioctl # exit=1
 # SUMMARY: PASS=0 SKIP=0 FAIL=1
 1..1

Fixes: 46fd75d4a3c9 ("selftests: mm: add pagemap ioctl tests")
Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>
---
 tools/testing/selftests/mm/pagemap_ioctl.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index 762306177ad8..6f8971d5b3ce 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1368,7 +1368,7 @@ void *thread_proc(void *mem)
 			ksft_exit_fail_msg("pthread_barrier_wait\n");
 
 		for (i = 0; i < access_per_thread; ++i)
-			__atomic_add_fetch(m + i * (0x1000 / sizeof(*m)), 1, __ATOMIC_SEQ_CST);
+			__atomic_add_fetch(m + i * (page_size / sizeof(*m)), 1, __ATOMIC_SEQ_CST);
 
 		ret = pthread_barrier_wait(&end_barrier);
 		if (ret && ret != PTHREAD_BARRIER_SERIAL_THREAD)
@@ -1403,15 +1403,15 @@ static void transact_test(int page_size)
 	if (pthread_barrier_init(&end_barrier, NULL, nthreads + 1))
 		ksft_exit_fail_msg("pthread_barrier_init\n");
 
-	mem = mmap(NULL, 0x1000 * nthreads * pages_per_thread, PROT_READ | PROT_WRITE,
+	mem = mmap(NULL, page_size * nthreads * pages_per_thread, PROT_READ | PROT_WRITE,
 		   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
 	if (mem == MAP_FAILED)
 		ksft_exit_fail_msg("Error mmap %s.\n", strerror(errno));
 
-	wp_init(mem, 0x1000 * nthreads * pages_per_thread);
-	wp_addr_range(mem, 0x1000 * nthreads * pages_per_thread);
+	wp_init(mem, page_size * nthreads * pages_per_thread);
+	wp_addr_range(mem, page_size * nthreads * pages_per_thread);
 
-	memset(mem, 0, 0x1000 * nthreads * pages_per_thread);
+	memset(mem, 0, page_size * nthreads * pages_per_thread);
 
 	count = get_dirty_pages_reset(mem, nthreads * pages_per_thread, 1, page_size);
 	ksft_test_result(count > 0, "%s count %u\n", __func__, count);
@@ -1420,7 +1420,7 @@ static void transact_test(int page_size)
 
 	finish = 0;
 	for (i = 0; i < nthreads; ++i)
-		pthread_create(&th, NULL, thread_proc, mem + 0x1000 * i * pages_per_thread);
+		pthread_create(&th, NULL, thread_proc, mem + page_size * i * pages_per_thread);
 
 	extra_pages = 0;
 	for (i = 0; i < iter_count; ++i) {
-- 
2.53.0


