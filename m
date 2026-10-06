Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 360F5CA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 09:26:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 586F06B00B1; Tue,  6 Oct 2026 05:26:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 537B16B00B2; Tue,  6 Oct 2026 05:26:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44DBF6B00B3; Tue,  6 Oct 2026 05:26:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 23DD36B00B1
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 05:26:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AFE5F40562
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:26:06 +0000 (UTC)
X-FDA: 85291669932.17.3B32F11
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 167A11C0009
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:26:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fjkgQrNw;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791278765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i4Zw/u8s1lETHe0VqgIFXTxzwfLsMW96GsLAvBA+mY8=;
	b=PY99om/aNl2I00Jl9ao/P/KubTWC74++tfaXbhCaK50w7XSPMiLblbR2o+ZmwZChi/af25
	xmCTtHjlHSpAcC4WdhMjtBvMtMi85f7qo0GMif6NT+KHyfj9QqeaEHLq5TrM8oD9tuBBoT
	l+Ja5i4Fp9E5vU+a7NIXYuIo8YEvspQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fjkgQrNw;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791278765;
	b=JrAWSHvaEWB/jjgWqVGTJsJPIayfFJzeO5lg6GSXJylO2O6JlD96RglhOPjvhfzLQOLE87
	w/lsLAi4U7hvaJXTXhg5ahX7+WvicBoPSFse8EuDV2dAlWA1FZtEamrnd8lFa2ODlO+fSD
	klGCg2h+FTIwLrrSY8f/RYpnDjiq7M0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A56E31477;
	Tue,  6 Oct 2026 02:26:00 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C15DB3F763;
	Tue,  6 Oct 2026 02:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791278764; bh=L3KeWBIKxswCxpqs+QVPQarsghruNw30o7dAd05nFTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fjkgQrNwj1eknTzQEWsmDBDT+2gebpqa+BHqFKmaH/4NzaGxH/0ih+lcvXiZWgh6U
	 3r9wLLOva9s/Pse/N+a1Axhc4yAmkzuK6BuMLrQ1cJqBXItJ1uU5NDYIve9BzyUGpY
	 OZiOG1l7QA6WeuB8YKAb8LGBChv7gU8Q307DZvqQ=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: ljs@kernel.org,
	liam@infradead.org,
	vbabka@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	jhubbard@nvidia.com,
	kaleshsingh@google.com,
	anshuman.khandual@arm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v2 08/12] selftests/mm: mremap_test: handle cleanup after mmap failures
Date: Tue,  6 Oct 2026 14:55:07 +0530
Message-ID: <20261006092511.145776-9-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261006092511.145776-1-sarthak.sharma@arm.com>
References: <20261006092511.145776-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 167A11C0009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: zttwpwihhnujd79y4fqz1dpj9jbdrymd
X-HE-Tag: 1791278764-718381
X-HE-Meta: U2FsdGVkX1/6JKVrnB+pJFJwIks77apW3a4zDxatX1oIqpZ3XUF/iyfYqnfFa23xXdv3gRtNUaNzakQCqbQSW/U45UUZ8L1n9HLuhCIrWYEGb0cxSn/z3M4f6ZtYBsltgxSX7mYMwSZGYUcjc8y3KtAiVA986PM4P2KZaoxiCVerS0OEvWzS1Hkhg2ixoWJxlV4baKtSK1clFcy1n8DmRmPuq8sm4qMJwA+hDdkRTA/mG53ngOfKCUASAB4jwTQalcELiSpRkjci3RrRxCRI4TMVWW1dR6qfmkPRtmNiBGj0FON23o5oTAYgTADWkkVm64fftGQHOlj0T66k6C73mqxaIa/zCTDa/96bSVdgM9E8kFp//47JnyKLfH2/xsmNPodzapo8mBLJC3ez4eQmbU/9UJXoWAiCuIPVZl64fQNaW4DzJA8yDvpSeLFUbEnA4P3qrm3Z0eYSRDEp8VlyBKC5AN1CzkEy72iJshMKfJVSd3Huw6g4t3DjnLpLY1O0EU9fdGOeWsjWMXwvSXy5r5BUwP/IviDxA53Uotxq8bHkSiuLB6AnfiDGsxeDBOctq0oKnklA5IA/jnn8ZLanVZdGiOkrdxIablxlCKUfcdk3firW3AMt2BIKjD2wdNkG3vz+QXqbGJJqlht7roZhWt62sjheIVObRMDjyDLcOwxsIcC9pzQEI8WQRonTxhghuVEoY0WTklZI6Ir27CKYKX1B/6S9p6RN3mls9mLe4RILwkCwlv/SCuElfp2XOMVQQ6Me/XUng54g7oozVfjv4Tl/zbveIrFqnkNv+6cLNL4M09Pwchisu2r3kuMaDulAWeSZbWbpaZbBXl2Zw3iweI1GJliDScAXv8m6xwln2g1q3Ah+jrCVnaQIy9UiQ/p3Derqp+ay4vKtMatMMQVapIPpqzXITA/u56VbN2cx/MXyNxd8YzAEw7RpQUgdI86/FrFLh5e0+gGUdo3YqhR
 pvJw+qfM
 CJ89/ul/2gWjXUzlV7H1FdI8hIxZwW9KBrFp9jat52FQmMYoR46do4aDnZsxpW7gMW89xP2oWM01id/QVk4U9IJ4JShmJmTEp+HEWn2x6n3hauH1hWY4wzssqdMfNBX3WC7GcvgCO/HdjGmEPO1PXuAWvXd6X16r0eZyHvJX9XBe4epzbs+jZ8GPsepwEaVRj+ZU6Gql+pc9Ji9E4VQ4riJLHG3HJRnTkcl8ppOZDEIxfTDd0vDgNzPM524NP5lBnKOYWqnsekTyxZUeHBAqMC1WaVgrZN7Yp4vXr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In several tests, when target mapping fails, we directly
jump to the result handling, without unmapping the
previously created source mapping. This leaks the
source mapping. Unmap the source mapping when target
mapping fails.

Also bypass munmap() when source mapping fails in
mremap_move_within_range().

Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/mremap_test.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 833efa85e5c6..37bba5049ecc 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -340,7 +340,7 @@ static void mremap_move_within_range(unsigned int pattern_seed, char *rand_addr)
 	if (new_ptr == MAP_FAILED) {
 		ksft_perror("mremap");
 		success = 0;
-		goto out;
+		goto out_unmap;
 	}
 
 	/* Verify byte pattern after remapping */
@@ -357,9 +357,9 @@ static void mremap_move_within_range(unsigned int pattern_seed, char *rand_addr)
 		}
 	}
 
-out:
+out_unmap:
 	munmap(ptr, size);
-
+out:
 	ksft_test_result(success, "%s\n", test_name);
 }
 
@@ -415,7 +415,7 @@ static void mremap_move_multiple_vmas(unsigned int pattern_seed,
 	if (tgt_ptr == MAP_FAILED) {
 		ksft_perror("mmap");
 		success = false;
-		goto out;
+		goto out_unmap_src;
 	}
 	if (munmap(tgt_ptr, 2 * size)) {
 		ksft_perror("munmap");
@@ -501,6 +501,7 @@ static void mremap_move_multiple_vmas(unsigned int pattern_seed,
 
 out_unmap:
 	munmap(tgt_ptr, 2 * size);
+out_unmap_src:
 	munmap(ptr, size);
 out:
 	ksft_test_result(success, "%s%s\n", test_name, dont_unmap ? " [dontunmap]" : "");
@@ -529,7 +530,7 @@ static void mremap_shrink_multiple_vmas(unsigned long page_size,
 	if (tgt_ptr == MAP_FAILED) {
 		ksft_perror("mmap");
 		success = false;
-		goto out;
+		goto out_unmap_src;
 	}
 	if (munmap(tgt_ptr, size)) {
 		ksft_perror("munmap");
@@ -573,6 +574,7 @@ static void mremap_shrink_multiple_vmas(unsigned long page_size,
 
 out_unmap:
 	munmap(tgt_ptr, size);
+out_unmap_src:
 	munmap(ptr, size);
 out:
 	ksft_test_result(success, "%s%s\n", test_name, inplace ? " [inplace]" : "");
@@ -605,7 +607,7 @@ static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
 	if (tgt_ptr == MAP_FAILED) {
 		ksft_perror("mmap");
 		success = false;
-		goto out;
+		goto out_unmap_src;
 	}
 	if (munmap(tgt_ptr, size)) {
 		ksft_perror("munmap");
@@ -690,6 +692,7 @@ static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
 
 out_unmap:
 	munmap(tgt_ptr, size);
+out_unmap_src:
 	munmap(ptr, size);
 out:
 	ksft_test_result(success, "%s%s\n", test_name, dont_unmap ? " [dontunmap]" : "");
@@ -738,7 +741,7 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 	if (tgt_ptr == MAP_FAILED) {
 		ksft_perror("mmap");
 		success = false;
-		goto out_close_uffd;
+		goto out_unmap_src;
 	}
 	if (munmap(tgt_ptr, size)) {
 		ksft_perror("munmap");
@@ -910,6 +913,7 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 
 out_unmap:
 	munmap(tgt_ptr, size);
+out_unmap_src:
 	munmap(ptr, size);
 out_close_uffd:
 	close(uffd);
-- 
2.53.0


