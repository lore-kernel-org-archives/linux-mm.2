Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8DE8FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:44:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FDD36B00A8; Tue, 28 Apr 2026 16:44:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D46C6B00AA; Tue, 28 Apr 2026 16:44:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EB096B00AB; Tue, 28 Apr 2026 16:44:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1DD8A6B00A8
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:44:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DCD5E160171
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:44:05 +0000 (UTC)
X-FDA: 84709141650.22.69B72E9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4D26A180008
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:44:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b6vyVtym;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LsPrUBFZ3Lx4MDukGgAx/vgGuD4Bk6ITwDbLTiwKowE=;
	b=FKGFsOJfRLTd/L4fHeGlYakla1rAnX8L21itBbEihiEioUQSz6VmN9JO7HS0/L1P26+nak
	V23E9tZz7vecBbfvIsKDYD8McTJr2HVP0fYZiKUjM+3f+paVbXSOaCR+4qQW5OKv+RIVjF
	tcvi8t2utbGnULGwy4nsd8kdVzai5Bo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409044; a=rsa-sha256;
	cv=none;
	b=DonGyMqX6zWYzIRA+tYFb4g0iPaWCjtn/FqThjwhMnyS9/1+9UA+oU2mml85yGV0VPc6E0
	2tBUH2f8k7cLVSehELxxGuwYzve28/SeCYl1KTLK6HSWcCsD+0Gd97NrExK80Hh2cy6XV8
	5DLYqg5iQZBk8Oc0ACEp4u6qVf7FUPY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b6vyVtym;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D3B3661146;
	Tue, 28 Apr 2026 20:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0D1C2BCAF;
	Tue, 28 Apr 2026 20:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409043;
	bh=KqI8ngJ0bHSCR5ybdrrYCtTpsduBNLFEpTEruulHsAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6vyVtymTCj2d+q+Y2oUMB5e0dcR3J7rMQC3vYUuCcn2acCgMHRIvL++NeY/DO6tX
	 hqiegfojn5LEJcbJHvv+23wV1dpKRN7gD+UsQmxdy+hld4QS9UQaVZS/FXfG+e06a/
	 EsjLLe/vmaVM0LToBpQulWul0TZnK7Oh62hg7rbLCmqNaNnFoC0bwTUn/g0jldDPnk
	 TEzlvRBf5Hi8g92hYG7hgVpEcloUGmdj/BwToL/c0+R5JxJjmOP6vlnhcCFeeZfFWC
	 RaZlliozrcbOIEr+AnDahfOmMayXa4IATgC54fdL8tfZUUd5ZC1KJwjRwIcjoWs+V8
	 HapvnruYCpaAA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 11/54] selftests/mm: hugetlb_madv_vs_map: use kselftest framework
Date: Tue, 28 Apr 2026 23:41:57 +0300
Message-ID: <20260428204240.1924129-12-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4D26A180008
X-Stat-Signature: cwk1j6jb8dqojo49dho6wns57q7nnthk
X-Rspam-User: 
X-HE-Tag: 1777409044-165822
X-HE-Meta: U2FsdGVkX1+rmurPkE7sXxWfcOK8XEGv93pgCGYhAG/QxGH2ZgBJi4uLGyUg4uIAWx4FvbB8rTQl5FDT5akQy4qFbRhgyB9OXDwztCsGPLQuayCWYS7/7C0F9/yvkro8w+u0U/BCe8djucdG6v3OmIPmsvwlNBAsXJH+LzMAxzKvpYmZZW8wEu3ti50YvrgnfmODA0VqpPbCkMNfuqdFq8WgDAaavqBlIJkA0EzRYaQ3THPWr+/Jz6rpoDhhOaXNVEcxZMNbXUts0ZkNI6qq77PWSi1PgcibcTmn7vxPQjNX6KowlR6/2C9S3cOnSniwxEdQS0THfwIb+GDSC7c0epsP+16wG2o37sB0Lye68exwXkjns55vHRWnpV+fRNi0/XxZONMj+I08F01xznxJjVYhAx+16/E0CYs9bR4WxY1rRWL+eY9laG1fAzhLcMpD2Z9M8Ng+hzdpasxz6+s+lfq3wnZEqkfqoQ9ofemOy4davQd+ofOSjFuH2qb5OiMdwnlwuDjU5r3RhpFZkNio2XX2nnxtizISfV1PZ53wu7OGZojYwFg6ejidYAZR5NaHDzW5wnNEHAOm5/97lHey3ir4bDqeNXmpZv0qJR2iIUj8dteD2PuYuqaJoZp6xdB8aNoyOfF6FzTLDZNVDDi5PgYD/E2ZmZ/hUYHEsPc1aDz42epOqapkvh/hVIXRLGTBJqUG0KDS/jFxsbjLdgEfriFz+H5z8P2dMQJYmmUtYbOOy+2xVbzVLC/Hjyclzq0fbfY1UiKsiaYVzB2rHaZDcSETJebdZUaYdB2e/WvdiS6gGwvy++fdIlP7SUCv+hb7ZN4xy74i8LsYuqd0FRl8rbfilSnKPrdB4Io2VeO69MJHBtXb4/j0Er6gxHtosqlRLgDkRYhlSxc1eNe2wuLzWEY2fd+83GQ30jDTE38oxGQUAM4u7N2VZYYmOMel6amZdEWr0E6mxKhzLtdGXBR
 1+gACzWa
 YtJOHOz9eM0i0ijGAYyJcEqsCeDHlCZKrx+jli3xEn3synStec7YOWDKktMaunuVv6eptJ0x5zqUe4RslK97jYNhYozh6/IwzTaiS8wgsUC0ehVTD0sKKnqwhlYT1++QUf21jE2SW+oKqyqqeCmrg47bWfbR9ZXEpgvE16P2JqcjLwbOlzV/igLd7aUYXk+E3svvQEo6BlwQWBbSYCLxD7JvqfIVRWspyVuY6ki/f6e0AWbBt3/H5ClsMcjxhMkXglq6jK0U7xxOpxofw1z7kKxy5J1BihQZoE13jx1p5Y9L+yPbuQqBUX3bceA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Convert hugetlb_madv_vs_map test to use kselftest framework for
reporting and tracking successful and failing runs.

Reviewed-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 .../testing/selftests/mm/hugetlb_madv_vs_map.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
index efd774b41389..c7105c6d319b 100644
--- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
+++ b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
@@ -25,7 +25,6 @@
 #include <unistd.h>
 
 #include "vm_util.h"
-#include "kselftest.h"
 
 #define INLOOP_ITER 100
 
@@ -86,12 +85,14 @@ int main(void)
 	 */
 	int max = 10;
 
+	ksft_print_header();
+	ksft_set_plan(1);
+
 	free_hugepages = get_free_hugepages();
 
-	if (free_hugepages != 1) {
+	if (free_hugepages != 1)
 		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
 			       free_hugepages);
-	}
 
 	mmap_size = default_huge_page_size();
 
@@ -100,10 +101,8 @@ int main(void)
 				MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB,
 				-1, 0);
 
-		if ((unsigned long)huge_ptr == -1) {
-			ksft_test_result_fail("Failed to allocate huge page\n");
-			return KSFT_FAIL;
-		}
+		if ((unsigned long)huge_ptr == -1)
+			ksft_exit_fail_msg("Failed to allocate huge page\n");
 
 		pthread_create(&thread1, NULL, madv, NULL);
 		pthread_create(&thread2, NULL, touch, NULL);
@@ -115,12 +114,13 @@ int main(void)
 
 		if (ret) {
 			ksft_test_result_fail("Unexpected huge page allocation\n");
-			return KSFT_FAIL;
+			ksft_finished();
 		}
 
 		/* Unmap and restart */
 		munmap(huge_ptr, mmap_size);
 	}
 
-	return KSFT_PASS;
+	ksft_test_result_pass("No unexpected huge page allocations\n");
+	ksft_finished();
 }
-- 
2.53.0


