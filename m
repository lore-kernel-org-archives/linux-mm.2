Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ABCECA9EC7
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 16:35:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E2776B0088; Sun, 11 Oct 2026 12:35:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 593656B008A; Sun, 11 Oct 2026 12:35:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A94E6B008C; Sun, 11 Oct 2026 12:35:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2764F6B0088
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 12:35:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 976D38090C
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 16:35:42 +0000 (UTC)
X-FDA: 85310896524.23.267EB1F
Received: from mta0.migadu.com (out-15.mta0.migadu.com [91.218.175.15])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0052E40006
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 16:35:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mwPPj2pF;
	spf=pass (imf04.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.15 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791736541;
	b=CgIb5Zbwt78W9Wek0J8xi7wd5wjkFYcnh5glymqmCk0r88Hu76zJGK/1D5L3HWmj+1t1u4
	Obg8SfvVhqaFJR1Iu8DLJPAA0LTQCYGswTPe0O866pOibV5XarHG1BKg67dAPpWTs9it0b
	CUHzuDkGOQKA767QISTJobE4Se6DFNU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mwPPj2pF;
	spf=pass (imf04.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.15 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791736541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=e3s6HqMMXfc/PLb1dBUHl8Rpr2sTUOQful4Cv5S3+hM=;
	b=8ASK2pkAIEeVCCDs1MRnlvAj4batup9KUwFmmnTbGmX81mnzeXmK5AQbzWYW5SCuDXzU8e
	h4c/OU70leUQ6uXMZI+Xi+9stmp2zidDSMLuZ/YE5ZWPp0vzhK/BUYhfKg22Fxc5zvs7WH
	JogdK7FSYz/jP35dwWoBJ0gcm63E+q8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+gn9/2Bwxj4iX6rrRLRwzG9R3E2EKBjO0B+oBS9nPDw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791736535; v=1; x=1792341335;
 b=mwPPj2pFB5DKGLBu3jh+gT4BrpnqWwJODEZmBfuRg+zp6ivXF8isgzDfskZK8Cs79ZOBeVPS
 1KPp8doKmBzelzO7kh+bWHA6W3o0xedcKMB/e/fP9Qw2KMZ+F8m0BqIu6CvI8/AKVjP+NfZnK1/
 8n9itD8Xl1rBbCyMR98t7ZPY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ae541d04c9977309;
	Sun, 11 Oct 2026 16:35:35 +0000
X-Mizu-Trace-ID: ae541d04c9977309
X-Migadu-Flow: FLOW_OUT
From: Zenghui Yu <zenghui.yu@linux.dev>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH] selftests/mm: fix uffd move-pmd test crash on 64K base page systems
Date: Mon, 12 Oct 2026 00:35:27 +0800
Message-ID: <20261011163527.95988-1-zenghui.yu@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0052E40006
X-Stat-Signature: 8atnrhebg89eymrs5oucsujhym5bs81n
X-HE-Tag: 1791736538-762167
X-HE-Meta: U2FsdGVkX19dtfcegeNit6jCYVIQrdwV8is5epnyFKnvJDuJzBBzUGX2dmwV/Ig1fPATVkFYqX1kG9IwbkHsQPDjAwTfSTMf6qsO6MWBSlfsadFso7w4MjsMs3gt2r8ye8OQs/wpNeM3cHodbvwNM4y6ubuIHdBbMauzCPzb9KueEGbL0KtyUKoc7c5+JjrKl3Mkhyz/csJMu8Oejwqmlpwxdkll9lf6NOPdHZe00JCFZ3nu447ZiUbXjzC+L03kGtCw5dCNIYHVjHCarWFYhOZdoGu3p74v8KeKvblru0JtO9WujAYYD70+vHh5iHk+VPRG8WLN8+8VPWfTl3IOOIkyX+hBTKp0MIIeiTSEUj7HPZ+P0eJgf62oUlweShld+dcewfvFATXr0bTdG7a1BG/0e7Q3tWwoo+Nq1d8vS5ctjIJWrFrkrwEtgTBJFe4tGg8Kg1os7ztmFT4tS8CWQ2mbThncBgUuIED9BlwJlCulDylm6F4gJQ58G8OGTC5gXeAmErdJe50r6ddinREcYtJ47UGBJjbi8ibm532kTw4KkRrJnxDBczKO5zfKYK7ZiKm2Q1SXoTs6BbHQSHd0kg/s+CzjqEQmGEOYgxu7MiOhL4Lpw0dXYpkOuyhu4fABWwyTejOy63L9ENXJO7EoSyb2sr2sooMO5i6BQ1b+OxDGK41kTxR7axgMUqqAEZxdArK6e03qDZEgcrTTDn3upmlQGHr0rgBO+c4foek8jFnMowDz9C9m508a85ao/96uFCfiq3qENHJKcTsWfpoABCPRIggxuq+i14Ek9EwXwy/MKTGocTlxMLJi9TeXKjt4w8KPGQM1nHKC0h+ZkGQZQeMd9YDRXEnXmAKXSagGdBi42ePYpQizshsaJgpBc1QP2to+EaLgKLx8oQ3wDpQQaLFtg4jZEN+CXzLtHmQ+Zuu3bcDR4f6+yrv8w0Zdn61gG/PcbL1TEzqRm8+dHYk
 ve3ZDt6O
 mtF+gX0W0M0gD44WvtRmpkyK21uacYN1ed50+dsDLEQ2HESTQXo/+qSVj/v1hfEHgucbAE/n2t4NfXSKYQA0ACALMU95/bqVQgY7wQLKqrefpn/ucBFcGfImtPCUUpg8DKri1qhTmCEiNunFr/neZM7KV/GqT7kVwuONULplMfUVjt8ADCgW3Rw9P0HOjYw3t9n91HK8C6DI5676dIJ/lGhuUMN20T1BeFnM6NJPYGYSRowg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

uffd_move_pmd_test()/uffd_move_test_common() splits the test area into
chunks of chunk_size and moves them one by one.  On arm64 with 64K base
pages the chunk_size (read_pmd_pagesize()) is 512MB, which is larger than
the whole 32MB (UFFD_TEST_MEM_SIZE) test area:

  step_count = nr_pages / (chunk_size / page_size) == 0

Because chunk_size > page_size, the test then aligns both areas up to
512MB, which points far outside of the 32MB mappings, and decrements
step_count, which underflows to ULONG_MAX.  The verification loop then
runs away and the first dereference of area_src faults with a SIGSEGV.

Skip the test when a single chunk cannot fit into the test area.

Fixes: a2bf6a9ca805 ("selftests/mm: add UFFDIO_MOVE ioctl test")
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 tools/testing/selftests/mm/uffd-unit-tests.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index ef9b3956bdcf..2a97ba1d6feb 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -1937,6 +1937,11 @@ uffd_move_test_common(uffd_global_test_opts_t *gopts,
 
 	args.gopts = gopts;
 
+	if (chunk_size > gopts->nr_pages * gopts->page_size) {
+		uffd_test_skip("chunk size does not fit in the test area");
+		return;
+	}
+
 	/* Prevent source pages from being mapped more than once */
 	if (madvise(gopts->area_src, gopts->nr_pages * gopts->page_size, MADV_DONTFORK))
 		err("madvise(MADV_DONTFORK) failure");
-- 
2.53.0


