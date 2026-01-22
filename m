Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43FBBD3EE92
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 17:02:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 386446B02C0; Thu, 22 Jan 2026 12:02:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3653C6B02C2; Thu, 22 Jan 2026 12:02:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B36D6B02C3; Thu, 22 Jan 2026 12:02:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0B9016B02C0
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:02:44 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CD2E7C1CB4
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:02:43 +0000 (UTC)
X-FDA: 84360219006.03.59B8C06
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 418B3A0011
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:02:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769101362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dXYLXYGYPa0K5ldYA5/QuEGbKeXhItVHlUbTwO37WWU=;
	b=7o/8i33a3LWWNmjWV/gnKIbv9DHipZvM1hMjLp7EypISy/rTCJs3bwJ1a+VaJWIqQTladQ
	FhQa3GZElivzpHbXmE3wqrLhnxUbz0Ngqj7uGtO5gfATi6xI82LTyhP6n0Cxxw2uyqC+Lt
	p6VSkYc5VrOeyaykgP0OLbpM+H3z3oM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769101362; a=rsa-sha256;
	cv=none;
	b=xqY1zt22mh5jKae1Awq1MU9w4Qa4T++XH3xNL/AZhGh56K3ZcFjIQfq7/eszKpedkmZt5X
	BCd5ajyT6rkIRU4EstKkTOYBYtjyffQVbfJBJ/BAyGKsFfDyBn4P9usYW4sbObLvX6QyNB
	m2rScISdIsmF5Kk/ONr6POD1kcgOyGw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E294F15A1;
	Thu, 22 Jan 2026 09:02:34 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E6B833F632;
	Thu, 22 Jan 2026 09:02:39 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	SeongJae Park <sj@kernel.org>,
	wang lian <lianux.mm@gmail.com>
Subject: [PATCH v3 4/9] selftests/mm: fix usage of FORCE_READ() in cow tests
Date: Thu, 22 Jan 2026 17:02:19 +0000
Message-ID: <20260122170224.4056513-5-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260122170224.4056513-1-kevin.brodsky@arm.com>
References: <20260122170224.4056513-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 418B3A0011
X-Stat-Signature: 4qwhh6yno6ozbacm7dsi8xdechuub3ik
X-Rspam-User: 
X-HE-Tag: 1769101362-523074
X-HE-Meta: U2FsdGVkX1+ZV9YXEaSgEGaJRzvNhnT4aMslQStcb8xHU1vs0rQWg6TXJLSdbh4mBwpXcy3Dq7jcdg0QdF7QwdNoNIy/KGgqPPTIT86baSnovQsZTMy+iBhjrLpEZme+lolBew/3e1DaJfX7Z87ROl8ePtZcSSalH3BgFNL4OrqykEno3a0vaNoCAfye9tGu81T3WT6/dhPFGNWX6Ra76HJ3UP7lSzdF9dByrXEKltDE4iWrU6R5kjo4gtBf0NZRC0Yv1yOkqjNuNTGCo75gxBAtPehCbdZCVvfiJ8v94gpyoUfc/Uaif20ELwqBjvcMgSOUVdSMrWm6aQnuG7nCzld7eG2pnLmztmjGtjat9iVXB8vNGPNxyaQ0T0sf80IOrN/WkUNSMHLHJEnF/k34uNQ1tqNAd91nMOYmxy02aKUSP8VbCmM+aNUD73HAvP2MYEZRISZg1YhB6+P2hEmPvhXlvmNNSYEIi/Bp9EqLiB53U9+s76kH0BECKCbZE+5cMf2X2UOLSPF0rMg/xCyXMfr3iwTcJ8v/iGQZb4KqLcjI9w6q2iNIM0tRnwEDnZVj4604nWkI0y7v1RHjFpzrK1mU9dt0bXOUngO5YdbWsaS2mRx/5u6l3ZhqFoiYpukS0UdpibBHrDN4OMvXMDBwo+XaTIgSFbVT9bO0vHtS/QrO9ZhWZapGQeIHfeEH4UNViMUKK0dFDCi2Mn7ePbOLa+oicnIxNWNWPddE705e4M7b1eeWq7C5HspY+tikhBYBKVyrehUv7DAn6M6qxLClzaADt013eCqF95RjV37EDsUsC/Y2KrN1jY71fnbqDQMA/mhNPumiA2NCQu+BdxYA3cvQc7FKFCkOd4wlC29RsOJ8gmf7VVQEt0rA6mxW2rcopMx2+7dARp9ZLEbOeGP5DaDhIkAjDtgioo/dynGi+DLzy2AMt1S5xcS2Bi1f4F1UV6ycSgbFkn+MAwLeWsg
 u32RdWnK
 TQvUNM2I1LX4HvRLTWKOUtY1oTbsTt9NxJcuJRYwRMrqco5GqL4vztEz7XkcuPUa01q1dNlfwe8yUb2Xv79wUUasABIgNATVBut+5K7r8+r61M/Xc5DGpoTWcUTsVpvj1L81BXCKvmwaCcdzNVdPwDQGaaJpxSXRjczRJggZEb3VpgZKSG6XietRMSbeQdYNYXKwRcBNpd8a3nPArEzHaj9VblAyAKtA0sgV86o3fYdhpLDz9IGLBU6VgAWs41uZeJhryAe49tgnpAqm2iv0OZRbWQ9s/7HpTML9GtIdTQXkMGODIskrbR+EbdMXwwTGx6Eq/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 5bbc2b785e63 ("selftests/mm: fix FORCE_READ to read input
value correctly") modified FORCE_READ() to take a value instead of a
pointer. It also changed most of the call sites accordingly, but
missed many of them in cow.c. In those cases, we ended up with the
pointer itself being read, not the memory it points to.

No failure occurred as a result, so it looks like the tests work
just fine without faulting in. However, the huge_zeropage tests
explicitly check that pages are populated, so those became skipped.

Convert all the remaining FORCE_READ() to fault in the mapped page,
as was originally intended. This allows the huge_zeropage tests to
run again (3 tests in total).

Fixes: 5bbc2b785e63 ("selftests/mm: fix FORCE_READ to read input value correctly")
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: wang lian <lianux.mm@gmail.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 tools/testing/selftests/mm/cow.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index accfd198dbda..83b3563be26b 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -1612,8 +1612,8 @@ static void run_with_huge_zeropage(non_anon_test_fn fn, const char *desc)
 	 * the first sub-page and test if we get another sub-page populated
 	 * automatically.
 	 */
-	FORCE_READ(mem);
-	FORCE_READ(smem);
+	FORCE_READ(*mem);
+	FORCE_READ(*smem);
 	if (!pagemap_is_populated(pagemap_fd, mem + pagesize) ||
 	    !pagemap_is_populated(pagemap_fd, smem + pagesize)) {
 		ksft_test_result_skip("Did not get THPs populated\n");
@@ -1663,8 +1663,8 @@ static void run_with_memfd(non_anon_test_fn fn, const char *desc)
 	}
 
 	/* Fault the page in. */
-	FORCE_READ(mem);
-	FORCE_READ(smem);
+	FORCE_READ(*mem);
+	FORCE_READ(*smem);
 
 	fn(mem, smem, pagesize);
 munmap:
@@ -1719,8 +1719,8 @@ static void run_with_tmpfile(non_anon_test_fn fn, const char *desc)
 	}
 
 	/* Fault the page in. */
-	FORCE_READ(mem);
-	FORCE_READ(smem);
+	FORCE_READ(*mem);
+	FORCE_READ(*smem);
 
 	fn(mem, smem, pagesize);
 munmap:
@@ -1773,8 +1773,8 @@ static void run_with_memfd_hugetlb(non_anon_test_fn fn, const char *desc,
 	}
 
 	/* Fault the page in. */
-	FORCE_READ(mem);
-	FORCE_READ(smem);
+	FORCE_READ(*mem);
+	FORCE_READ(*smem);
 
 	fn(mem, smem, hugetlbsize);
 munmap:
-- 
2.51.2


