Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDF99606A320
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 10:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=omwUzGSy
Received: by kanga.kvack.org (Postfix)
	id 127216B05B4; Wed, 28 Oct 2026 06:01:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B0566B05BB; Wed, 28 Oct 2026 06:01:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E92D46B05D8; Wed, 28 Oct 2026 06:01:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C7B786B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:01:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B86741A0BDD
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:01:50 +0000 (UTC)
X-FDA: 85371593580.04.E7C593D
Received: from mta1.migadu.com (out-246.mta1.migadu.com [95.215.58.246])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8801F100008
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:01:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=omwUzGSy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.246 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793181709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SN+4KpKU4pO0w+hnkVBnVZtVPIWPahdjf4GIcjr94dc=;
	b=LQQRTDUqfQ/Jzs2ytSDeD+hEiSHGYMIX+U/w9Q6KOisxmlrgZyB6uUeXADTLAmBbqTl2FV
	XnSd/NJP/hYmWDF8BvmKEc47oAY7bR/GOO5LYOULmTP7hSPtCH/d/7rzTF5L1ekU6sQqXi
	WZG05KZUzaY86g7iWs+9Wij+lVxDdD8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=omwUzGSy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.246 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793181709;
	b=M+r3EqkbQ8PWeAmOl6j2nYD4drQsJ2oX+v1CkL92FqYZkbwGiQHxdJEccbxtRIl8VkMn/Q
	CJRggrriIHtwzEHxEYc9isqKa3gCYtLwP8YpP7ubYikMMaVN8QxRMch712c5VWIQ86xzfQ
	ES0vrSltXVVUDwK8dfeDY8IZJ4b2djg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/dUQ3gxRWfPKKEHri1OjskVqUHdSvq6M0Wda3oynvuk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793181707; v=1; x=1793786507;
 b=omwUzGSy9w6/mFbekyH2CeZjT7h+OgL1CqRyiwElJhUiifK7sFD9Fy4p0XR/w8PVj/OQNs/8
 D2/uCPyIFpoEwsGGqQSpOqpk9vwh1XrEr8xLpGaTJn7tNlFiG/TPHs0iMGF9dJuyMPKD4+zOTuJ
 vHSHfcYcDcsNtcI4Ka7+Ui8U=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c473c188e45cfd80;
	Wed, 28 Oct 2026 10:01:47 +0000
X-Mizu-Trace-ID: c473c188e45cfd80
X-Migadu-Flow: FLOW_OUT
From: Zenghui Yu <zenghui.yu@linux.dev>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>,
	Kiryl Shutsemau <kirill@shutemov.name>
Subject: [PATCH] selftests/mm: skip collapse_compound_extreme() on THP allocation failure
Date: Wed, 28 Oct 2026 18:01:19 +0800
Message-ID: <20261028100119.11340-1-zenghui.yu@linux.dev>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8801F100008
X-Stat-Signature: z43o1jse7a3yh1wm18zuoiwop8bzqtrd
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793181708-610252
X-HE-Meta: U2FsdGVkX19qQy+Z9k0KPtIDEl5YsviwVyWszsfJRkpYRnON6cHfzudHztJkhSQbdwef0VEVwcXh7FBtvMjSmlqC7M//EPruQ0/wpz9bagJ1CD44nIBdJg1Rbz2wu1uJW6D2ct/k1TL5nWdUexIx5SK7iu+ct+EPtyoFHiil8V7JkkaFHf+VtnhWrAUCcNp9eVy9oSWXgmspgS5chEVtke68B/tVoh97x6CM7BeAMktwjVJvBmXY6yIMX78teDraydiVIGDO+M3TpaZmBl9C5W1vozaJqeZPnjPJi580uCzqvlDJJvR+bLrhw4sT4n4CSn5AG8MIxuf17/+a8wmvVTKCBF+WXnLq9g0nSkrioyBkenEhAAJ8SkxL3WWcExA12TbeEvi6nW7bYmS91e+vQNEzcPz88Wixo2lN9rOj6cLEGfGJ2NuRplAoR/bVzcjHPLB2WhGB8FcJCcNoJ6uN+O//RkqhOFn7Qg4aqJ5LaYQzFJDITGxBckzrScU6K1KXzTnFwXz5oc+1xlTWwKEcYP3jQQ1TCho7NTCeYZJYgT/KNL+C8RdwGfwi1U+bpvYggc80ZwVca69TAhMZRDz/duPLDntDfvWS9JvF8wWL+vf84PYkbyYBAhHFlgNwf+SDmY+s5p5KQvCszJl6MhsjQm8NPW5orM03iJavS1tuaM3TduEmDNfjVqT+cYjlh6789it1KhmPWACI/Veb1ucsDIEKwr5zvegSvsZmwbCDXPe2K20Alt9z+o6o/5jHYhHHXbeWVt/JnkEKOgyJg2Q+0rosw+Yvn2gt0bsYTNrpkCX3fqhNIkMsHjLNoDVI7eO2nSlft/YDw99TYNHavZw1+Oej2rN42KLGhWYJWQUHdQkjL/hd378InYNlLS3e0Q3wcdoFAtoKicPt+36sxxJ7v+ZcTu3hbALGcHEBlWE8UYOXHN8nsd5gjhmKhNiHvmlYJWXCbucMDnorAFLgUH8
 qHpUyxi7
 k0erR/uyXTXORfz2ENlekBMgwROU85AkSwz6qHNT0jBWOt+UxsiDiYgbvQrAIYQd4HpyyKolxqCaG9tos/AXqmpfTYH1dK6LPVqxJzBxsS9dhbwsJoLD4UYFVZnyiJRlURlgVGEKswwBxrhNiumP7DvB/mUUIk5EgjX2OQEm66AUntvAlcZO1ruZ48ZXo0H4nCi1SS6R+JDrZ1yFh0qnXsqTda+qiqAbPPU2pZV9rzW6ixeXJ44+OtRK2oBBHfcWxvbpmAtzYVFO66EVwggN/TODsNyod2vBavKy+KqdW6aIKwwM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

collapse_compound_extreme() needs hpage_pmd_nr PMD-order allocations in a
row, and it kills the whole test binary via ksft_exit_fail_msg() as soon as
one of them fails.

Gating the case by PMD size (commit b36bec6a01b1) -- the current workaround
for arm64 with 64K base pages, where a 512M PMD makes every construction
step an order-13 allocation -- is not enough: the case still dies below the
cutoff, e.g. on an arm64 VM with 16K base pages and 8G of RAM, where the
construction would need ~64G worth of PMD-order allocations.

Remove the PMD-size gating and treat a failure to allocate a huge page
during the construction as a skip: whether the allocator can hand out
that many PMD-order folios in a row depends on the memory available on
the machine, not on the kernel.

Suggested-by: Kiryl Shutsemau <kirill@shutemov.name>
Link: https://lore.kernel.org/all/atiQmWnz8zx2AKI7@thinkstation
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 tools/testing/selftests/mm/khugepaged.c | 26 +++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 1bc7acc66a46..e6151732b17c 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -953,23 +953,25 @@ static void collapse_compound_extreme(struct collapse_context *c, struct mem_ops
 	void *p;
 	int i;
 
-	/*
-	 * This needs hpage_pmd_nr PMD-order allocations in a row, which the
-	 * allocator will not supply if the PMD is very large.
-	 */
-	if (hpage_pmd_size > (32UL << 20)) {
-		ksft_test_result_skip("%s: PMD too large for fault-time THP construction\n",
-				      __func__);
-		return;
-	}
-
 	p = ops->setup_area(1);
 	ksft_print_msg("Construct PTE page table full of different PTE-mapped compound pages\n");
 	for (i = 0; i < hpage_pmd_nr; i++) {
 		madvise(BASE_ADDR, hpage_pmd_size, MADV_HUGEPAGE);
 		ops->fault(BASE_ADDR, 0, hpage_pmd_size);
-		if (!ops->check_huge(BASE_ADDR, hpage_pmd_size, 1, hpage_pmd_size))
-			ksft_exit_fail_msg("Failed to allocate huge page\n");
+		if (!ops->check_huge(BASE_ADDR, hpage_pmd_size, 1, hpage_pmd_size)) {
+			/*
+			 * Constructing the PTE table requires hpage_pmd_nr
+			 * PMD-order allocations in a row.  Whether the
+			 * allocator can supply them depends on the memory
+			 * available on the machine, not on the kernel: skip
+			 * instead of failing the test run.
+			 */
+			ops->cleanup_area(BASE_ADDR - i * page_size,
+					  i * page_size + hpage_pmd_size);
+			ksft_test_result_skip("%s: Failed to allocate huge page\n",
+					      __func__);
+			return;
+		}
 		madvise(BASE_ADDR, hpage_pmd_size, MADV_NOHUGEPAGE);
 
 		p = mremap(BASE_ADDR - i * page_size,
-- 
2.56.0


