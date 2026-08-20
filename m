Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46CF3C5DF86
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 19:40:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E62A6B00AF; Thu, 20 Aug 2026 15:40:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 497656B00B0; Thu, 20 Aug 2026 15:40:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AE656B00B1; Thu, 20 Aug 2026 15:40:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 09F5A6B00AF
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 15:40:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8075EC01FE
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:40:42 +0000 (UTC)
X-FDA: 85122665124.01.E254283
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 610BE40005
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:40:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=k40VweNT;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787254840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YfnF4HN1jkljvwvZULCU46p9n6mhC8RNEM0a963DS14=;
	b=NqhysY2OXa4k2HovGnAo62EgFe+iLZGdgsB0rTKL3vA0bMEVwVd557KjW2BnrZrSrl8V8b
	OOdqRgs5Q+qdlMBO5i27MLTdYRCUJQj24xilek5/BcZLdm+P4nQ/7v+wNo8jkAyedyJXuF
	fGoprnO19SMQCW27/1kgjm8yqNSbZrM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=k40VweNT;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787254840;
	b=jCeck572Xy+mIlYSaggKLOENtWdjIKbEgjLPKDVwu0KwjkxS/MJPP4Nm9gheEr1Su6U42q
	354VibCY/2jCIV8g1txoSgHrdi3uujyjMo+Ymz7JRLwlKjL7V9llqJdLwfGL5LO03el3Jr
	g1GunupUUq1iMd67iP+eyB211hgZ4aI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 72F6C20E3;
	Thu, 20 Aug 2026 12:40:35 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BEA173F763;
	Thu, 20 Aug 2026 12:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787254839; bh=uMRo3I+EyfXXqmw4cBxiWSky9p9AXwXW6zcs9CuZKso=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=k40VweNT0NG3FjlkrTCZGQt7NG81uUFpQzD/ZEn+8bQX2IurfEzfA3aLh+Iqfdwit
	 rVQ9lHzZg6bvqXF4vOIyWVQZWRIxpvPQKODvSf4B1Reho5a1G29PxEJHcbpqVnHvS5
	 cdr2y0f7YCyAY7jeeN45W2j9kYu7pLQp1MIjfM8Y=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Thu, 20 Aug 2026 20:40:15 +0100
Subject: [PATCH 1/2] kselftest: mm: prevent random failure of huge page
 split for khugepaged
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-fix_split-v1-1-ab430c58c7cf@arm.com>
References: <20260820-fix_split-v1-0-ab430c58c7cf@arm.com>
In-Reply-To: <20260820-fix_split-v1-0-ab430c58c7cf@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2249; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=uMRo3I+EyfXXqmw4cBxiWSky9p9AXwXW6zcs9CuZKso=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqh1gwFNiZL1JKhbXTdharWu6xO72tiOOQScaBM
 kX8t0XWnIiJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCaodYMAAKCRBt1cPRWsUx
 MylyDACthWK3rDwGK6zCbh9WSTwdnNwTIofCM1WGv4e/TMI+PwoaYxSNF7LDRAUcCEZM9ttUPP+
 nIJsAIjVVKNx13eQ1onh344xtr79CSMN6FD3b3fPUu3RudaWG3WU8F3q5WoRhB/yLJHeqW2DNls
 LnZE++AfWw5quokjFbqLlsx1+LCKg65PDlWdmQPquYRfH5Y9YPTb0OR73/QJOw6zgixaI8Up+TB
 vSHJamhtvvkleUUf7o5HsuQW6jY3tA0HXXngEzkVr9s9tZPs8wnKc4yECfDeGu+VN+CaMXs+e3s
 HiO+gNocF5Ybyls2EcwEA9hCZDQ9jPFT9pFzP2JPwRABKGxA29zod2BsQ/6ZPaaWjWvrhB6jJoM
 97IqCIB4bvH3G1C8KiVhxJRjD47NBWpADf5671WNkQGdHV9CCWY9BvHebBMQyNpm3DTn6rJgpXI
 wecULLuSKPAnEapAkfzW4FjNF3LYeFhHl1AFudoanwgOWVHCUkXg6u3jAy7WmvT4us2n8=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Queue-Id: 610BE40005
X-Rspamd-Server: rspam07
X-Stat-Signature: pschoppwwwhyj6e7r9yxgfsmncf6e3af
X-HE-Tag: 1787254840-263761
X-HE-Meta: U2FsdGVkX1/TJGpWE12xb6GgK6iOYxxUCM3UrSmPB58N4UfbUogPxC2AQn/byMcxx/HFdKNAAe2/vsXg7NdvyH4WgkFVb3JgTMNso/P/irR9GmMb0V9e1zrFSjUCWrAwBK/fVbHY8c5wvNcF6spjGjQ2CyLu1kw2nnsPyN5y4jKATR6hCn/eO2mtJO9gvaodaDkWUloZK8fiy2qxc9d1+RUTuHnxKHxEHBTQnmj5WeBCfvmodZLVro8fJY76JByAmEB8hjTDqVnJT3uqBTpLMld7p22WYWT+4pACCCgL0TVWUqw2uqR5x6qoe1W2NyJ9isthhzTLt8WqaNv+hrZp6fEEyfqx3bTGoRM3zYRTN8UfWZ86l7jhwQkD4Cs7WUsXIwmHf/5fXZiz7Rn2DUOU0v5nharyLALmQGCxK69eY8yKoMyaTqBJYhULuz43H4cwMxOz0QH6cq/C4MkjPVqqwRNFufqm2lNnmI3FPV06yf0vrAF3PChov/f468GlHvgG0kI32XaaFUI6JAfMVHeNylPD9kkArA3HQVx72ChHrOuIpjV5RzwX4cuDOCRPQg/kQJ2aSxEA2LCM7NAd84fqVRR036DFd/BOJPzBoyfJ/ikV7QWruvqXX2H1y8aRHFN1/TYNA8d9LFkeX8D53w6qaOgn8HrDMXdOoY3Gm86HlQuIOBCT9GPcmGDPDDqVe91h2CadUw+OGwXLj5tMOij1jXnMn4Okch6Z2xeRwaM8In43vOyr78JY0UeTQdSAqrwFKnfEMBchmuFLWChMyXP3WVrBZznarkBNMPEz25l+hGynR8GGSzp/wOX7kx0fPS1i6NpiNfpF/MAFrv3iM0LgRqK9F+aOK/dbfVvhwViorGezFYhP5YdKemrpOtf1LnrO4gJZwxRZkvl8KDX/EUvhnC9fkQj6k+1m69wC233fJJge5HERYLAJObUjHlDshkN1NSZZJQQSYEHTBUIIe/n
 PNH+HsXh
 lc76096kEVIuiaa42hEdZYNbP3JpQRFJ3cJ88VlBD70lMVKCwduVO27F76OOatpK+RU8xYXvrllrNsP/PBhQJjXMGMVrI7AG5Y1iCINr9umeGWyT5eL0HkJNOacLHpoDbU0FODcnMvsmkXjv8qYS2Io32qx5sKnKmrwdn2N2QzamdIFC7zbHbUkUkqdlvlh47cNQBBvjrW3w/+6ka8mHdQnNXj0XjFq3DS3oGxcRP3xGWNypzsyz3PlKSdZCKxEROBL5d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There're some random failure for split_huge_page_test when khugepaged
collapses pages into pmd again which had split by the test.

Prevent the khugepaged's collapses for split page by setting the
mapped pmd-huge-page with MADV_NOHUGEPAGE before split.

Reported-by: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/split_huge_page_test.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 32b991472f744..99b45e5518199 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -303,6 +303,9 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
 	if (!rss_anon_before)
 		ksft_exit_fail_msg("No RssAnon is allocated before split\n");
 
+	/* Prevent khugepaged from collapsing the pages. */
+	madvise(one_page, len, MADV_NOHUGEPAGE);
+
 	/* split all THPs */
 	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
 		      (uint64_t)one_page + len, 0);
@@ -350,6 +353,9 @@ static void split_pmd_thp_to_order(int order)
 	if (!check_huge_anon(one_page, 4, pmd_pagesize))
 		ksft_exit_fail_msg("No THP is allocated\n");
 
+	/* Prevent khugepaged from collapsing the pages. */
+	madvise(one_page, len, MADV_NOHUGEPAGE);
+
 	/* split all THPs */
 	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
 		(uint64_t)one_page + len, order);
@@ -436,6 +442,9 @@ static void split_pte_mapped_thp(void)
 		goto out;
 	}
 
+	/* Prevent khugepaged from collapsing the pages. */
+	madvise(thp_area, thp_area_size, MADV_NOHUGEPAGE);
+
 	/* Split all THPs through the remapped pages. */
 	write_debugfs(PID_FMT, getpid(), (uint64_t)page_area,
 		      (uint64_t)page_area + page_area_size, 0);
@@ -665,6 +674,8 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
 		ksft_test_result_skip("Pagecache folio split skipped\n");
 		return -2;
 	}
+	/* Prevent khugepaged from collapsing the pages. */
+	madvise(*addr, fd_size, MADV_NOHUGEPAGE);
 	return 0;
 err_out_close:
 	close(*fd);

-- 
2.43.0


