Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBA08FA0C26
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 04:45:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AF076B0092; Wed, 15 Apr 2026 00:45:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 960276B0093; Wed, 15 Apr 2026 00:45:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 875846B0095; Wed, 15 Apr 2026 00:45:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7648B6B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 00:45:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D9B9713A8E0
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 04:45:34 +0000 (UTC)
X-FDA: 84659551788.17.B568067
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id B7EB2140002
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 04:45:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=eokLRvAh;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776228333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=cNtuv37NTaPfVdG2Wyq1cY183ygGsxhutDabViwK+DQ=;
	b=V7JyweLnjaJBXcirnUnBiZM4FUz9Pp8b6/I0hwm/Xvfpr1zUHbIuROL/TDC1QRX9y0jJuj
	zUga5GV7dCuScs/glAGMvQ5hDdZxiWo9VPZvdI7xG/XV4jhPia8C3Jy8Pd4oKmINwPlZYK
	B7dbYXEOKwhhvkSV3CE0j3jRJX4r4HU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=eokLRvAh;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776228333; a=rsa-sha256;
	cv=none;
	b=fmjLW32yAt9ECIZaeI3xH2kkiOBlL2soJlADFPIs34FgSdJHfYg2iEuuZEM5BqMDuamwmo
	Bf46bFEwHChwzt58TBKWQoZGQyR8UDcZad89twLrym4Ks5e29vJu6GxD3JMgOBf9umTSDT
	JGqodvDoX82vYY2aW5QmC7sUOm7kuuE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A4367337D;
	Tue, 14 Apr 2026 21:45:25 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6C49F3F86F;
	Tue, 14 Apr 2026 21:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776228331; bh=TVMWKdtf33Q9VHYtStDLDAKGyqg5Xckzkj5HLoa3F8Y=;
	h=From:To:Cc:Subject:Date:From;
	b=eokLRvAhysbewSW5m115UvHQa/oTGWnuc2hWGGfJOzYWG52ay0ijHPROZOs+7SGan
	 hamk5wRE2pc8Xzo3uyO0dVXgLvGZrFm/fCgig5wtgQidr6r+syLzNqjnrADTRGFAIT
	 aagjGFwbMioNfJPt0FyqbUQdTNEv2EsBwWBPD9Os=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	shuah@kernel.org
Cc: ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	Dev Jain <dev.jain@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v2] selftests/mm: Simplify byte pattern checking in mremap_test
Date: Wed, 15 Apr 2026 10:15:09 +0530
Message-Id: <20260415044509.579428-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B7EB2140002
X-Stat-Signature: 5wwtguu9wp75s3s3uu7m5nbh8y5pig8s
X-Rspamd-Server: rspam06
X-HE-Tag: 1776228332-17440
X-HE-Meta: U2FsdGVkX19GoTS/ncmuCw9Rvow+9LymaQpW1qBT6R0I57sGEVorbI0UGSGifE/NYISEzV8HbOge8y73OugM9fJic3YlfsDjoRDA902fP5tGW3b6loEOIpc7S/XroxcxE3ZSSVjhgBe7pqul7KzDt6NpIO5r/vI0RWS04kDiCUcUOuyZc7KxBzMEkFNh8hGfV/40uv1Qmvfk8N+PATpdlmmN+gszbD6uwuWiXJZK1/b1uogeeF+XYh2WEmxHK4qCq4fSo4j0nEBSzQDUjGQKnTf6YhIE6T7aLw8/NvrUOsidGZnNKljgiele1sWYttJbXLxF6Uf+H9e817rapbTz16448oNb6W9IXdJM8fhHaVllwVMH6i+RWPtanxwx9z0/9Ftn/T83HAiyN2sIm55p7TnftOVoNFgKRxEFKAYzzvuLu92JajXnq5wQ0kBwUhpc76V+6QEHYOliZWJ8bff/r2rLBL04RiswQY8+fZ2sGLESutPmteyXCBH9U/V/uadRrerT2YSlzrcUVN4FauDnbu+o6uYqSxS4XJKtUSLwdDeXa6kJFvjfA0Inoxqx4BEcyh/hs2FVBXm4uHcG451piYEVQtEoHKFuSWovd9a43JEgwA6cPxouUi64my5sTyBtqj6EouA51gHTe3A2SdEbzw3yWWfnrVNIbIuX2ru+rxiysFOGPJUbCd4nKiPpSV5USrYQs2LDZ81wP0lchyOTW/dSWGYtzfw2ielIjssWlGRp+4TsBSeGkzrFUwg/DufC9ze7HKUrFnp1Q45MjMb+C59Ien0r3s9PIrp88RdZAmbPMUQ2IW3ZVnpbrEZS9L9bAyfr3DTz7eC9Sb8Zg9lmf3leSnjcXJdznyzLQ3Ts8DwmlSV41O2H6dWMMMOl3T/iFdRHKF0EViMx3ICPQtU8vWb/9k6m2jE61WpB3Xp4HHRxu9gYs+oUFtf/+Yk1N9L9GY4JSxYNNd/LcpzXmwH
 NusTo9oy
 GJrOal2pjIKYwfVxm9qP5ir7di9/ZEV4ueoA4yqznFiB69tD8MIRoyZAoqYEasM9tkH8VRF321Ery2PsKzepc+u2tjdEQejLoG7zSi5gm4gr5JM991OOpXWfY/WA6HIwfOSkQtCzDNBzA890QyYpqe3FLh4bp6zmlhMhrCIfRDmGmbMWWcZjg5VpQFSVk7cYeAhi+FikkgBy/1eMGdSE8b204HAbaKrcD2VxPXNQ5P0VEWK3KYjntskENnjbIrLB8QEqBfQNHxNeva3G3NCsvFGsktX/89edkeZkKh4SiZGu7quIu2Pc4Uk19yX4wiEddKHj6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The original version of mremap_test (7df666253f26: "kselftests: vm: add
mremap tests") validated remapped contents byte-by-byte and printed a
mismatch index in case the bytes streams didn't match. That was rather
inefficient, especially also if the test passed.

Later, commit 7033c6cc9620 ("selftests/mm: mremap_test: optimize
execution time from minutes to seconds using chunkwise memcmp") used
memcmp() on bigger chunks, to fallback to byte-wise scanning to detect
the problematic index only if it discovered a problem.

However, the implementation is overly complicated (e.g., get_sqrt() is
currently not optimal) and we don't really have to report the exact
index: whoever debugs the failing test can figure that out.

Let's simplify by just comparing both byte streams with memcmp() and not
detecting the exact failed index.

Reported-by: Sarthak Sharma <sarthak.sharma@arm.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
Applies on mm-unstable.

v1->v2:
 - Simplify patch description

v1:
 - https://lore.kernel.org/all/20260410143031.148173-1-dev.jain@arm.com/

 tools/testing/selftests/mm/mremap_test.c | 109 +++--------------------
 1 file changed, 10 insertions(+), 99 deletions(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 308576437228c..131d9d6db8679 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -76,27 +76,6 @@ enum {
 	.expect_failure = should_fail				\
 }
 
-/* compute square root using binary search */
-static unsigned long get_sqrt(unsigned long val)
-{
-	unsigned long low = 1;
-
-	/* assuming rand_size is less than 1TB */
-	unsigned long high = (1UL << 20);
-
-	while (low <= high) {
-		unsigned long mid = low + (high - low) / 2;
-		unsigned long temp = mid * mid;
-
-		if (temp == val)
-			return mid;
-		if (temp < val)
-			low = mid + 1;
-		high = mid - 1;
-	}
-	return low;
-}
-
 /*
  * Returns false if the requested remap region overlaps with an
  * existing mapping (e.g text, stack) else returns true.
@@ -995,11 +974,9 @@ static long long remap_region(struct config c, unsigned int threshold_mb,
 			      char *rand_addr)
 {
 	void *addr, *tmp_addr, *src_addr, *dest_addr, *dest_preamble_addr = NULL;
-	unsigned long long t, d;
 	struct timespec t_start = {0, 0}, t_end = {0, 0};
 	long long  start_ns, end_ns, align_mask, ret, offset;
 	unsigned long long threshold;
-	unsigned long num_chunks;
 
 	if (threshold_mb == VALIDATION_NO_THRESHOLD)
 		threshold = c.region_size;
@@ -1068,87 +1045,21 @@ static long long remap_region(struct config c, unsigned int threshold_mb,
 		goto clean_up_dest_preamble;
 	}
 
-	/*
-	 * Verify byte pattern after remapping. Employ an algorithm with a
-	 * square root time complexity in threshold: divide the range into
-	 * chunks, if memcmp() returns non-zero, only then perform an
-	 * iteration in that chunk to find the mismatch index.
-	 */
-	num_chunks = get_sqrt(threshold);
-	for (unsigned long i = 0; i < num_chunks; ++i) {
-		size_t chunk_size = threshold / num_chunks;
-		unsigned long shift = i * chunk_size;
-
-		if (!memcmp(dest_addr + shift, rand_addr + shift, chunk_size))
-			continue;
-
-		/* brute force iteration only over mismatch segment */
-		for (t = shift; t < shift + chunk_size; ++t) {
-			if (((char *) dest_addr)[t] != rand_addr[t]) {
-				ksft_print_msg("Data after remap doesn't match at offset %llu\n",
-						t);
-				ksft_print_msg("Expected: %#x\t Got: %#x\n", rand_addr[t] & 0xff,
-						((char *) dest_addr)[t] & 0xff);
-				ret = -1;
-				goto clean_up_dest;
-			}
-		}
-	}
-
-	/*
-	 * if threshold is not divisible by num_chunks, then check the
-	 * last chunk
-	 */
-	for (t = num_chunks * (threshold / num_chunks); t < threshold; ++t) {
-		if (((char *) dest_addr)[t] != rand_addr[t]) {
-			ksft_print_msg("Data after remap doesn't match at offset %llu\n",
-					t);
-			ksft_print_msg("Expected: %#x\t Got: %#x\n", rand_addr[t] & 0xff,
-					((char *) dest_addr)[t] & 0xff);
-			ret = -1;
-			goto clean_up_dest;
-		}
+	/* Verify byte pattern after remapping */
+	if (memcmp(dest_addr, rand_addr, threshold)) {
+		ksft_print_msg("Data after remap doesn't match\n");
+		ret = -1;
+		goto clean_up_dest;
 	}
 
 	/* Verify the dest preamble byte pattern after remapping */
-	if (!c.dest_preamble_size)
-		goto no_preamble;
-
-	num_chunks = get_sqrt(c.dest_preamble_size);
-
-	for (unsigned long i = 0; i < num_chunks; ++i) {
-		size_t chunk_size = c.dest_preamble_size / num_chunks;
-		unsigned long shift = i * chunk_size;
-
-		if (!memcmp(dest_preamble_addr + shift, rand_addr + shift,
-			    chunk_size))
-			continue;
-
-		/* brute force iteration only over mismatched segment */
-		for (d = shift; d < shift + chunk_size; ++d) {
-			if (((char *) dest_preamble_addr)[d] != rand_addr[d]) {
-				ksft_print_msg("Preamble data after remap doesn't match at offset %llu\n",
-						d);
-				ksft_print_msg("Expected: %#x\t Got: %#x\n", rand_addr[d] & 0xff,
-						((char *) dest_preamble_addr)[d] & 0xff);
-				ret = -1;
-				goto clean_up_dest;
-			}
-		}
-	}
-
-	for (d = num_chunks * (c.dest_preamble_size / num_chunks); d < c.dest_preamble_size; ++d) {
-		if (((char *) dest_preamble_addr)[d] != rand_addr[d]) {
-			ksft_print_msg("Preamble data after remap doesn't match at offset %llu\n",
-					d);
-			ksft_print_msg("Expected: %#x\t Got: %#x\n", rand_addr[d] & 0xff,
-					((char *) dest_preamble_addr)[d] & 0xff);
-			ret = -1;
-			goto clean_up_dest;
-		}
+	if (c.dest_preamble_size &&
+	    memcmp(dest_preamble_addr, rand_addr, c.dest_preamble_size)) {
+		ksft_print_msg("Preamble data after remap doesn't match\n");
+		ret = -1;
+		goto clean_up_dest;
 	}
 
-no_preamble:
 	start_ns = t_start.tv_sec * NS_PER_SEC + t_start.tv_nsec;
 	end_ns = t_end.tv_sec * NS_PER_SEC + t_end.tv_nsec;
 	ret = end_ns - start_ns;
-- 
2.34.1

