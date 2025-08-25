Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74ECDCA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 17:07:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE0168E0059; Mon, 25 Aug 2025 13:07:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B68AD8E0038; Mon, 25 Aug 2025 13:07:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A57C58E0059; Mon, 25 Aug 2025 13:07:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9037D8E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 13:07:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 48A1AC0445
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 17:07:08 +0000 (UTC)
X-FDA: 83815910136.20.D50D00A
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6C69980012
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 17:07:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XByEkLSO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of viswanathiyyappan@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=viswanathiyyappan@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756141626; a=rsa-sha256;
	cv=none;
	b=kudpGTmSCp7bbIjr+0ILDalR6KPWZWZOYhiZ6Aq1C4g1mTdyzIMa02seMIWxEXLatnPOH1
	KQLojdelsjXs5vE37UMn7aI51a0PTycow3KRd7yXHt+3X4oIXNnywfHIvmEsdBRlf6Dso6
	ZbEt5Cn2tHlUG7ClKOsvpEX10RatXNM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XByEkLSO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of viswanathiyyappan@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=viswanathiyyappan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756141626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=o5RmAfR4rYsxlFJUhIr+eW2wt0BUW3DWgzYQ+evh+1Q=;
	b=1DpOx1VqK1ZqPLjCu66cnKhJUK6Oh8v73kt/toOK6/6N573+jXj8bSWdLrCRuBnL38y/QL
	OQG3BEUPT55L1crIfCZ8sDUX72tpeEOtB/SzddIrQtExYCS5svkBTJw1f/nbm3pS86bXoq
	VnDshy+xHcxAg3rBoniekZcqgEIRLpg=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b47174beb13so3217311a12.2
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756141625; x=1756746425; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=o5RmAfR4rYsxlFJUhIr+eW2wt0BUW3DWgzYQ+evh+1Q=;
        b=XByEkLSONCORrAsbpSFStHLcYM3tarQiMj3tyBjItJKaXVnjqchloYc7z41/bXpKvz
         PthBffnE0gZBHefIrG/OpoSezVlrUoT8xuUzDjBmv59Yx0VAp3WLIGc/NuO5Wk+QQVQJ
         v5iDhG6DMe4EuYTXJ6i/V+QNJHE/oaTLnXyepG+cGCqdi8ITjht8OsFkOismrjTZAahC
         LmZCHQhKDAKAUgc5SCWfwcZ67t+AO0m5gqjJXPmfGCqibvaigxhRjKucNhjn5XOP5gol
         itCuj31TVvkPiFBrPboXHct+Ix8Uw3d6FYrYV/pjS/Sao1itFJZ50/+utn3TqFs3rzfF
         3l6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756141625; x=1756746425;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o5RmAfR4rYsxlFJUhIr+eW2wt0BUW3DWgzYQ+evh+1Q=;
        b=mqGklmHlLogJbdH7qDBx4WNZhbzSFgbP1zK3y9ZVmXi9+uloKOjyoFBszX5MjH2WKH
         p07vXzv+Cxp6beNqBnxwRc3yPXFAk/ZkxIve4EzEIPjsrogthYeAAaeSB9VXk/XjqIcC
         W9MkJE8WZ9d1giqcdhhJg0yCycSV0wtttYbTAMudshAOGaoRKT5Gi4vjXw9lUaeL3Tti
         iPbsOITKmoftkHUvjuIybRMRw3MQtRFcZYMy9WubAgVjnsWA6jk73QKGcG7OAf+3lBGM
         qLJfVx8KN3kQVCtI1YI7ap04cgPhE4+qkHvmhYBatoz6W5BCwfBI3LtwgsToDx259ndR
         tSbQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKkNguF3Tiu9lLAl13To+m2LUMjPPA20wPJB5WpcXOzsDXVld0kSxdWSqihpSg8ext1fP2O/astQ==@kvack.org
X-Gm-Message-State: AOJu0Yy6Atsmg1MsKCBFMUO/DlH0Oha9fwKbzyNZGZP3LBSuMsyHZBy3
	sUmcjqH2cRNs5sIudLfKFB0IK/k8TYEFCkon7scJiYXZqpEQD5hGIRyt
X-Gm-Gg: ASbGnctb8D7fAnE67kjIvmKxFvDuwVto7J0zH09UG2wyYJKgN0z3znaYZBndtHUX8Ff
	f1tscRHknXvr7gyh+uFSxhSNugmjEvBN671MkAUi4ciCbEPG1lky7djiF03QhDLPtIfXZL8fs2G
	6Sg1ERj7V8TbD2q6c9Yn6XsXP7UK3QDkfaSIehWdhp2SKFis9deBqENn/9EZDTa4nQKIMUO7H8d
	QeoNFFS0ibZV4fQmWZEKbsgIWzX1i/zrqiAOEzFunK3zqSCjU0FVe6MvZzpKeq/8NTPBPE7RMG4
	kt7QRS92dpg//6wtdbp4bRrG9SD96rUtGJlrb3X2UTudcEh14tZoeh9+Mrq4B+TIsNrKpr7G4sf
	kBPUkkRAi56MB9dey6ICYsgwlxFUHiz1kEgM=
X-Google-Smtp-Source: AGHT+IEkhsxEhLSZfQy3k7sFLEhX/tDwtC0J4MzkXu5Dz/C+lrHURinY952j7BmG/n6fx8oK3A6/fg==
X-Received: by 2002:a17:903:1a08:b0:246:a8ad:3f24 with SMTP id d9443c01a7336-246a8ad4130mr81739215ad.7.1756141624869;
        Mon, 25 Aug 2025 10:07:04 -0700 (PDT)
Received: from linux ([223.181.114.17])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3254b8ff608sm7486025a91.29.2025.08.25.10.06.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 10:07:04 -0700 (PDT)
From: I Viswanath <viswanathiyyappan@gmail.com>
To: shuah@kernel.org
Cc: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	skhan@linuxfoundation.org,
	linux-kernel-mentees@lists.linux.dev,
	I Viswanath <viswanathiyyappan@gmail.com>
Subject: [PATCH] selftests/mm: use calloc instead of malloc in pagemap_ioctl.c
Date: Mon, 25 Aug 2025 22:36:43 +0530
Message-ID: <20250825170643.63174-1-viswanathiyyappan@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C69980012
X-Stat-Signature: qotos4uuseuk3bohjf4taf3b54cm4wtp
X-HE-Tag: 1756141626-223902
X-HE-Meta: U2FsdGVkX1+NWxJozkIfwBko/9LRClvJXh0jDixV7hkgiUjqn/0BgiCTkAeJXlCA8pCOGCDEkd0eKAdALo0pVkvsMMYgvtN/Qg2JISp847crsWA11YOLnVHzFYhG/bjJFGYk+6ldU3PQ54YbetvOcTJv/WEGH9A0N81u/+FNTpV2s5CFRuD3o6sTvQwWdUq0yHnpMedYUeJxtrgH4GfNIR7V51xm4ATZDSsnEES6PNF6ea+OEiDjKb586kqkBwhcgdyiTcljPjP/IOkTkzhDb9BqJXG31+f2ZY5cv9vvhibDQzfg8TtJwGG5hvJPNPZhE7T9F9hDdjoARLsQNL0UxnhBGJIOKDBdCm8pMftLNIx/NtZFiHQX7hVq+A+huIHMJuvZfSSUEgDM3hJ/3UJwh+vVYI2qAmg/V7wsopr3xVXjOvTORfibcBU5Cbt/8uvCfRE++GWFk+BrNqCJJ3tJogt7CfpgYjh2RqysQziVqbon2sPXi4yercrizi0t6X7duXppvjkSxqJf3uXNygHS4CvD8wnW/sx9zM7x5wiw1voFKqfL6H5t0kEoXk9losULWkRcshLgAzbZqbQVSnJnEGczsa3bgSsiTX5thF6BmeO6oU0pXjxDMZuVOKLpebPKINPRyci0g+YzyiXkDJQBAIsHgeEzOKVFtBAiAPbT127aupRj7Xk8P2956rYl37RdnjFvFuSOMs0Rm7Jifne9B+hpCiEx0rOHP+WzdDCUFG9uYU78cqCblwUImI/FjFYDi5APYotNm/KPz0sOzvKui0aabKM56BO/r6BkS4Rcbj+aTDKUuBrUQCAAnCJ0N++UGgbmgJ4TKRN4JNAPDfSvzNjI8a16Sq4DrGwm958lMkZLq5i3dNtEeqbWuDIXwyGNMXLVrVFHpu/2TRhMkBMUXMc5VcjFS6jW92Zoow3ujMn81BiobmkYjEolsdCMUvH5H7yq6Kv2Yz0oW6ynr8/
 WyRSfGZs
 nI/zbi0EXw7fLP+Eq4cRZxg3RrMHDSEAllKnT4kX7sbTxLI449T3VCddnD/LO4bmT1j36E99v2tDvHxokIZPlSuIpdVNx9xVRBwQVvtXu5CdnCK1kcQdHUfK7JtTKV9WoYHuJX3fb+V7FB0VPW7cEBqJagMbrHDFGpUQz/1PJ+i5YjNfuDwi6BF7IsO8Cpgfwglb4rJNC2SnnYYKFxZf95JhUp54TpSFD7pDOwM1RI57X9WXGFOrCRqVf7H7rAlcLI9P3Qh43OXhztyh8tRhb5hsZQNb3bexcaoqeL5g+xHJex9vLy1bm2/gqwS4ApWsvNp+upUNLNuW7NoITRRUVtzpVzP8DUr3v+CSsHUXOCC6j+y6BZkbjTT1poP97LpNpx3ee9/jw2vl22ks+A7uAyLlKZJgkuZ6azSlrFQ11SgZnJ0oMGCPNg+Yz6rsnoZOmraAnD7fbDEApRGI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As per Documentation/process/deprecated.rst, dynamic size calculations
should not be performed in memory allocator arguments due to possible
overflows.

Replaced malloc with calloc to avoid open-ended arithmetic
and prevent possible overflows.

Signed-off-by: I Viswanath <viswanathiyyappan@gmail.com>
---
Even though the arguments are small enough an overflow cannot happen,
I think it's still better to follow kernel standard practices.

 tools/testing/selftests/mm/pagemap_ioctl.c | 24 +++++++++++-----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index 0d4209eef0c3..4e6b815e96b2 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -209,7 +209,7 @@ int userfaultfd_tests(void)
 	wp_addr_range(mem, mem_size);
 
 	vec_size = mem_size/page_size;
-	vec = malloc(sizeof(struct page_region) * vec_size);
+	vec = calloc(vec_size, sizeof(struct page_region));
 
 	written = pagemap_ioctl(mem, mem_size, vec, 1, PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
 				vec_size - 2, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN);
@@ -247,11 +247,11 @@ int sanity_tests_sd(void)
 	vec_size = num_pages/2;
 	mem_size = num_pages * page_size;
 
-	vec = malloc(sizeof(struct page_region) * vec_size);
+	vec = calloc(vec_size, sizeof(struct page_region));
 	if (!vec)
 		ksft_exit_fail_msg("error nomem\n");
 
-	vec2 = malloc(sizeof(struct page_region) * vec_size);
+	vec2 = calloc(vec_size, sizeof(struct page_region));
 	if (!vec2)
 		ksft_exit_fail_msg("error nomem\n");
 
@@ -436,7 +436,7 @@ int sanity_tests_sd(void)
 	mem_size = 1050 * page_size;
 	vec_size = mem_size/(page_size*2);
 
-	vec = malloc(sizeof(struct page_region) * vec_size);
+	vec = calloc(vec_size, sizeof(struct page_region));
 	if (!vec)
 		ksft_exit_fail_msg("error nomem\n");
 
@@ -491,7 +491,7 @@ int sanity_tests_sd(void)
 	mem_size = 10000 * page_size;
 	vec_size = 50;
 
-	vec = malloc(sizeof(struct page_region) * vec_size);
+	vec = calloc(vec_size, sizeof(struct page_region));
 	if (!vec)
 		ksft_exit_fail_msg("error nomem\n");
 
@@ -541,7 +541,7 @@ int sanity_tests_sd(void)
 	vec_size = 1000;
 	mem_size = vec_size * page_size;
 
-	vec = malloc(sizeof(struct page_region) * vec_size);
+	vec = calloc(vec_size, sizeof(struct page_region));
 	if (!vec)
 		ksft_exit_fail_msg("error nomem\n");
 
@@ -695,8 +695,8 @@ int base_tests(char *prefix, char *mem, unsigned long long mem_size, int skip)
 	}
 
 	vec_size = mem_size/page_size;
-	vec = malloc(sizeof(struct page_region) * vec_size);
-	vec2 = malloc(sizeof(struct page_region) * vec_size);
+	vec = calloc(vec_size, sizeof(struct page_region));
+	vec2 = calloc(vec_size, sizeof(struct page_region));
 
 	/* 1. all new pages must be not be written (dirty) */
 	written = pagemap_ioctl(mem, mem_size, vec, 1, PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
@@ -807,8 +807,8 @@ int hpage_unit_tests(void)
 	unsigned long long vec_size = map_size/page_size;
 	struct page_region *vec, *vec2;
 
-	vec = malloc(sizeof(struct page_region) * vec_size);
-	vec2 = malloc(sizeof(struct page_region) * vec_size);
+	vec = calloc(vec_size, sizeof(struct page_region));
+	vec2 = calloc(vec_size, sizeof(struct page_region));
 	if (!vec || !vec2)
 		ksft_exit_fail_msg("malloc failed\n");
 
@@ -997,7 +997,7 @@ int unmapped_region_tests(void)
 	void *start = (void *)0x10000000;
 	int written, len = 0x00040000;
 	long vec_size = len / page_size;
-	struct page_region *vec = malloc(sizeof(struct page_region) * vec_size);
+	struct page_region *vec = calloc(vec_size, sizeof(struct page_region));
 
 	/* 1. Get written pages */
 	written = pagemap_ioctl(start, len, vec, vec_size, 0, 0,
@@ -1062,7 +1062,7 @@ int sanity_tests(void)
 	mem_size = 10 * page_size;
 	vec_size = mem_size / page_size;
 
-	vec = malloc(sizeof(struct page_region) * vec_size);
+	vec = calloc(vec_size, sizeof(struct page_region));
 	mem = mmap(NULL, mem_size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANON, -1, 0);
 	if (mem == MAP_FAILED || vec == MAP_FAILED)
 		ksft_exit_fail_msg("error nomem\n");
-- 
2.50.1


