Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAF6FCD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:30:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FA796B00D2; Mon, 11 May 2026 12:30:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AB606B00D5; Mon, 11 May 2026 12:30:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E8B36B00D6; Mon, 11 May 2026 12:30:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1FD426B00D2
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:30:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B12B040217
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:30:04 +0000 (UTC)
X-FDA: 84755675928.09.4C4DF5B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 018142000F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:30:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QiNqujZO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C+61qOh4oEtHtVBeGJfZcSyjW2B5WXtXYlIC2vlpuBY=;
	b=ULzbUPmDgYn4OD21XaRfOHgARUEdFr+wl5uh17CeLg025cxiduGVM0kDoPWdFdbHaCz2OL
	VWgBX9rpPN/A6dxYWQZOeV+euB4CKtDgbw/3FN74wkdXuivTgKYw6dL7sFQ+qKjrJjtjj2
	kT6AEx2mvkWg5ld7A5s0tDtZb8U2Kx0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517003; a=rsa-sha256;
	cv=none;
	b=4kaLjFYKT8m5OPBrA7T05ppb84DIor13/te19yENkNI7ejmAas2NfjiCFeNX88aAAkr0+B
	iTXzdij/G9bAEaFUcoPE+x3m7eMDiAzo6z3Mx+eSvA7X5ijhjIDen/FKIROqG+6I6AjyVZ
	npJa6wJPPbgm51M3b4QsWLTWhRr7E2w=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QiNqujZO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D1DF405AC;
	Mon, 11 May 2026 16:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CFC3C2BCB0;
	Mon, 11 May 2026 16:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517002;
	bh=JQ7L3bAnl6OfnNGxdvwB4chBwQHdnR62+00+7kyj4+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QiNqujZO7YA4u8wUJwcZlme4YS+xtP9cryGs7K91V8H4GUnPu7FKMTzYd6xazP536
	 2wUaMPeL/0vIVgssWmFa3FAaN3cOfwawy2KTKuYPtN6Awkqkx8iaHoMY4/rt6MECkn
	 nwolV+/dFFyt7duubIrREIXjDaHhfZkxKJWVDQ4sgTbDXnJWW5XenAWiTjzcP8kZjW
	 M6qNo7AprTjX8xhO8kcvRQcmcfaDjoBp0NoF7wtxlifmnF/UHSvzBU6NnO2WzvWR+M
	 1WWLCgbok8oLJraqh5zJMA4zQ/gJFsEHqfzNiTFrf2+Vs3trdb2VGOy1QkRLvpuRwH
	 WU8bHnOj92Dmg==
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
	Li Wang <li.wang@linux.dev>,
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
Subject: [PATCH v4 11/55] selftests/mm: hugetlb_madv_vs_map: use kselftest framework
Date: Mon, 11 May 2026 19:27:55 +0300
Message-ID: <20260511162840.375890-12-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 018142000F
X-Stat-Signature: dhacysqd4k9c84zwsgspwi8zbfuxr4ei
X-Rspam-User: 
X-HE-Tag: 1778517002-459541
X-HE-Meta: U2FsdGVkX1/dSxhF+Ach0dkhREuZSAA6Fz2KEQ/PrHFk2xUDDX7fzAEYUho4oyXIzTnTC9meLZjGy+kYcjUi5ZMoCvKKJIykeFj5fwcdEUefREHnht+NkmC35cPu7sUtLhCAKsQlqtxLPeHBAwNbz6qQHo1HeI4+hoPAMsd9scvfabvQUkIMJHtuwzIO9g7nFm+Ih5pvQb/6F9d29zLujup5a+DU8uUwX8HnZzEo3RrbPG39911LN8AHym0+RDl4DrIzDeMqmLkyum3KDydzzzwPwoAqYF/xkuoCQAgeyzlm4uB16xtCbKFc0U0GTG1C6+SUCBJZJ09IhZyAWUSp4QptUmEXeHCJ2pwz2dOjd7PlikVYK/X9IQGId1styisXqlqPmRnmlYEkGCNdtvYLhFOEhwBhKL222Ij8oolRBHNZ37b3PhUtZp3BKGyFqjeMEYOfdg7quPMB5detNcqYZQvFpT4XSoT4yuXw2nQ/AW+6urrYuLoB0fDpdidP4R1cOacsHSQLu5Bpmr1R/fGZVh0L/c+odFaPt3N/wqNWdANnMOP/dpTAbJExPxFukiKkHv2Hwqel1vySRTp/piXcZOj4+5LatJEP/2UQSWSGSjy8+PVx+lf+8Zw8Ibwt6Pa/hs7IRimz4tThLnGc+iaYU3FZ2wklx98lhyVY0zUT4xL+Nolr5Pil6QafMMymq8XGsDnhhgZrjzR/UZo++QXyDNTJDkXCyukYcH/tRFa3e6R3UpLs8OX/txnPFmKEXDsXbmQXjQXBWJ8zxkjx84UexgDLjZ2bwdp3kTozbI44isYyHtua6TlwHvuQ0im0beYokCpI5h59YUU7mpKKKmyN6wnUHxWmaK/ITe0Vh6ZzpsLPgGraJEjxAALaLFzwSbs/HPetUMB6vbGl7mABJHJVwvpJ05UkUc+8eP6B/68NigBBXOxSh77gDmYOy4o+wX7Cf6aZQdaAVoFaaBKzxpi
 v31dIh+/
 6dpbv7Docw+jmogfmnYSk320pwNO7YawNgGlA2kiiw2Qqz4zoTf5Ngkw2xmoruOUostrHEmYH+4uj7ZPdJqDXAG+BhrCG6LYQ9sy8/B/FA8KPEvs3XR2Dq4eCcR0JumgoQMrklIg8wMxiS2Fj4wqBa1Vp2ZpHt9dO5L6p4TXtiPZ2dwxhm7hGXgQ7g3S3S5wU3Okssq488bPlWcSynm2u0vploKJhj4cajEeHvw1cHgXrbQKin1fEOQhp9aOzhkg1GUMId+K62kPVp43wFgJDx4N82iQ70jmrfORir9ZUiO+7HuR42GNJsaGxu3Cd08+xCERF6cCZ7KTTw3M=
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
Tested-by: Luiz Capitulino <luizcap@redhat.com>
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


