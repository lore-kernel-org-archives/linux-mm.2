Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27308D3EE92
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 17:02:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B684B6B02C2; Thu, 22 Jan 2026 12:02:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF2846B02C4; Thu, 22 Jan 2026 12:02:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C2ED6B02C5; Thu, 22 Jan 2026 12:02:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 75EB36B02C2
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:02:45 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3E2E158F97
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:02:45 +0000 (UTC)
X-FDA: 84360219090.12.7E9257F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6B40840021
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:02:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769101363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sII895/ck0omx1kbUdhr1tyS4lQnzCkohcDow1BLj/A=;
	b=KUpH6OpCHeCyXhlK6OGm888BdwJXR3xpA0wfqw2pIiXicUq0pyIxpQ7HbgArDOwVYaHhgt
	vk/yQg8fCYWDjS2Mz5rirETxElol7DHB7ezOm0cZj+9RcLm431q5jY5w1YcXiUKTlE87WW
	eM7miANWVlnBJEOHbGhVByKAbqrYPx8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769101363; a=rsa-sha256;
	cv=none;
	b=ig4nI3UX+Dl81+SMsjJMVousXoNm+wNogm2OvmrcbfhT8PtHDASVrzUr0Ip9gNPCcj54AL
	824fOQ9tXTUNeBQLvY1Y3fTMK7LFe6k3HJXFX3LHz6QNqdoGyfhOQ2Z8prwveP9ZV0N4ul
	CM1unUlj/GaulhaRx4dP5Bo0f3HuS14=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7A867165C;
	Thu, 22 Jan 2026 09:02:36 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B4A1D3F632;
	Thu, 22 Jan 2026 09:02:41 -0800 (PST)
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
	Shuah Khan <shuah@kernel.org>
Subject: [PATCH v3 5/9] selftests/mm: check that FORCE_READ() succeeded
Date: Thu, 22 Jan 2026 17:02:20 +0000
Message-ID: <20260122170224.4056513-6-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260122170224.4056513-1-kevin.brodsky@arm.com>
References: <20260122170224.4056513-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6B40840021
X-Stat-Signature: kkbfifqtbexh6yh3oaja7merm34fdsr7
X-Rspam-User: 
X-HE-Tag: 1769101363-757066
X-HE-Meta: U2FsdGVkX1+natTNOhHZ8T4QiM/EseVcWO9uXCBiWF3GlAKh1uhqECwu5a72IN3sIK8oe9liTBG5SEbHT4pn8YCl2lYctYL27TUEQ8j1IiJWirf7B54vLRljSJD5fcWyfUWxOAiIsgHPszqPC63+6ZRzKHrdfovzBkC3uBl3JYzZBBrc9d3duhD1xjutXAAnMqH3X/ednZWTzrRIGac2y+LNwOlNOg8/XOgVGBf73qleb/78tZKx2Y9lVu2tX3RCQNPF4wtyjrXZl5iJq+jDy8+Usbx1xX7MkWBxEWRWvDZAcXDoUBpS6YZQHs/Ee32vpqGASPyTvPy1SKxCp4OLYy76ylkrB88mbitqZLXfKfNoePviHu2L0S3djmf6gCu9ybwo9yPvzs7QlSQcYwrqYHWolz7mypI5srEvcUOQiSJMvloXyW9OBkpPIkg4jC/y/LGrKIEUgDt2k1uq+L4GN1CvADa9uTeFDrJifujYDxfdxDdhgMQAjzkMxcznQWazYIsn60YbqFfjxAVXJ7y9tjdOLOmndDAhLomaKN5e11n/LpmIxao5DasneuFCG8x/6sBpCToe1UYleQQcZTluM4i5oaG5Oxoo7V7SMEpn74lffKHItN4E7r4O1m/PxI2MgiiiUV3JiLHKkNe3DvpScQw2uBO3n/nMFDs+GK/INveLuDzW6wLKwYwXxotHhWqwdRbW+hcZV0RZpd7HIZU0KaVDlB7mO+w3UTmXRZn5tDSF1tyiVSd2/1BDNxwb0X4cNb+crH/FOZTlNUPKXNh2viW2nTF4SY0rYSyVThyRHM7TSH9W/MBd4n4TMksy9vxq3wa9u4VEzuyZ5pJKTVaYFjnFWgSz4//rf2BQKgvGoflsXhXhWeGwrXcDKBjjRADrS2OLBDvNMO/SRHhWKzva1d9nKQ9Ow8hpXRh2XNdnFJ1S+dCFi0u9QFL7P/lMn0uAccOohGlNt5scuUHLYp0
 P9mrw65L
 wuAure4g/+XV0zvi1JYfStvZ1+Ae+mEpaRfLWSiiXm97PJmRRKzRZWc56B9jDj8xN0IXAzvYInsSd7XQ0vTgQZ3gYwaYidngdWBuAH+eKBLtAYLkKHURXnM+Zm1HvrPvWX/+AX1zzzAEC1jtsihuLDTZcrzv7YWn2rsZcrcEHPsZc9EyjcRlyfFzmKu4ruK2AvU3tzi3OYiNT4zi4IkUJhGFg33bLMej4PK0O
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Many cow tests rely on FORCE_READ() to populate pages. Introduce a
helper to make sure that the pages are actually populated, and fail
otherwise.

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 tools/testing/selftests/mm/cow.c | 43 ++++++++++++++++++++++++--------
 1 file changed, 33 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index 83b3563be26b..d9c69c04b67d 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -75,6 +75,18 @@ static bool range_is_swapped(void *addr, size_t size)
 	return true;
 }
 
+static bool populate_page_checked(char *addr)
+{
+	bool ret;
+
+	FORCE_READ(*addr);
+	ret = pagemap_is_populated(pagemap_fd, addr);
+	if (!ret)
+		ksft_print_msg("Failed to populate page\n");
+
+	return ret;
+}
+
 struct comm_pipes {
 	int child_ready[2];
 	int parent_ready[2];
@@ -1549,8 +1561,10 @@ static void run_with_zeropage(non_anon_test_fn fn, const char *desc)
 	}
 
 	/* Read from the page to populate the shared zeropage. */
-	FORCE_READ(*mem);
-	FORCE_READ(*smem);
+	if (!populate_page_checked(mem) || !populate_page_checked(smem)) {
+		log_test_result(KSFT_FAIL);
+		goto munmap;
+	}
 
 	fn(mem, smem, pagesize);
 munmap:
@@ -1612,8 +1626,11 @@ static void run_with_huge_zeropage(non_anon_test_fn fn, const char *desc)
 	 * the first sub-page and test if we get another sub-page populated
 	 * automatically.
 	 */
-	FORCE_READ(*mem);
-	FORCE_READ(*smem);
+	if (!populate_page_checked(mem) || !populate_page_checked(smem)) {
+		log_test_result(KSFT_FAIL);
+		goto munmap;
+	}
+
 	if (!pagemap_is_populated(pagemap_fd, mem + pagesize) ||
 	    !pagemap_is_populated(pagemap_fd, smem + pagesize)) {
 		ksft_test_result_skip("Did not get THPs populated\n");
@@ -1663,8 +1680,10 @@ static void run_with_memfd(non_anon_test_fn fn, const char *desc)
 	}
 
 	/* Fault the page in. */
-	FORCE_READ(*mem);
-	FORCE_READ(*smem);
+	if (!populate_page_checked(mem) || !populate_page_checked(smem)) {
+		log_test_result(KSFT_FAIL);
+		goto munmap;
+	}
 
 	fn(mem, smem, pagesize);
 munmap:
@@ -1719,8 +1738,10 @@ static void run_with_tmpfile(non_anon_test_fn fn, const char *desc)
 	}
 
 	/* Fault the page in. */
-	FORCE_READ(*mem);
-	FORCE_READ(*smem);
+	if (!populate_page_checked(mem) || !populate_page_checked(smem)) {
+		log_test_result(KSFT_FAIL);
+		goto munmap;
+	}
 
 	fn(mem, smem, pagesize);
 munmap:
@@ -1773,8 +1794,10 @@ static void run_with_memfd_hugetlb(non_anon_test_fn fn, const char *desc,
 	}
 
 	/* Fault the page in. */
-	FORCE_READ(*mem);
-	FORCE_READ(*smem);
+	if (!populate_page_checked(mem) || !populate_page_checked(smem)) {
+		log_test_result(KSFT_FAIL);
+		goto munmap;
+	}
 
 	fn(mem, smem, hugetlbsize);
 munmap:
-- 
2.51.2


