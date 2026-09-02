Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E051C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 12:09:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D3626B0095; Wed,  2 Sep 2026 08:09:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AB236B00E0; Wed,  2 Sep 2026 08:09:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E82F6B00E3; Wed,  2 Sep 2026 08:09:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 26EDB6B0095
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:09:53 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B51AD40145
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:09:52 +0000 (UTC)
X-FDA: 85168703424.22.486BE87
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id D7F67C0003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:09:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=aW7k6H1g;
	spf=pass (imf10.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788350991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PlODWBPBhdXxkJWAoRvhfGHptGeOYa5gQ3LTfB2Y+8k=;
	b=2n7EcnLdrBC7hJOXLeeWTH12HWxMtfwe0eRwVeHIfvCMwat2P90mh9+kS2Z/6kVdAjqy3V
	4cq79bJtD1DwH8uHvH0tO5QfzhEbrZgAo49RlN7pPHrGFSo3AdBdxCngDU4Jz3/35ioX4K
	gtKAvGv5UdRQSIsE7ynwowUh+Vnfjzk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=aW7k6H1g;
	spf=pass (imf10.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788350991;
	b=IT2TxuqGUW6YYjTKXgX2D6EooZwV4Mo1zvwnwyhZ2hIz+NNHqZkMXcMCWI1AwSVCTYDhsJ
	0maSaZyqAV6O21N4YQiGaHuyav8AfqyoOFhdy0FRgyWxonTJRj7pkFlnU4zAx3lsqNxA0/
	umg3Ye+2QvZm1AkgHQqiEfsGgAJ2WOY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5793C1682;
	Wed,  2 Sep 2026 05:09:46 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 187013F882;
	Wed,  2 Sep 2026 05:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788350990; bh=pUsAF+NKDxZAuOCu2xwNuQnOqeW4ovfuiE8VNrQZxHY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=aW7k6H1gR9hzfnUh1tz9Of7F89UvN9scnUZbNsi2t6A5hay2+g9HovUPxDmZqj+7J
	 YX2XUCiwDEnyufUi/0QdRQZuYlN/dypKriQjNvpLsrL3kq6knvnJLnHJD1gqA7A8Vu
	 IBUvhRE24MLrCs6NV1/IlnuQMc64aI4d1hbkIuT0=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 02 Sep 2026 13:09:35 +0100
Subject: [PATCH v4 1/3] kselftest: mm: prevent random failure of huge page
 split for khugepaged
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-fix_split-v4-1-85f03905f7b1@arm.com>
References: <20260902-fix_split-v4-0-85f03905f7b1@arm.com>
In-Reply-To: <20260902-fix_split-v4-0-85f03905f7b1@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2707; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=pUsAF+NKDxZAuOCu2xwNuQnOqeW4ovfuiE8VNrQZxHY=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqmBIG+FE6+7XlWbhEWVG74JauIQOW9hAlYcR6g
 GGYuvk9XL+JAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCapgSBgAKCRBt1cPRWsUx
 MxCKDACXbSM/L+bTkLJMqPzk1LV+saJ5txv8ckKPghKNpOFx2JvGS6r1L2WaA0/GmfGD+iqAwUj
 u5J8xpzcj9qOi/NzHmXiLM/i7s7a+PkuZq+rZgzbcUX14z/enXwloDzXKywlCpyW0UvJPgPBdjQ
 QYCArgJ/F3luAO+g3ciMlAqrphnxFGWIptVVTVLvo3JgtBkC4+XAILexAxXHrI5J6T8dCyUx7A0
 bHOIKjfeze7prPgPaZs6kSQVef988xUoRm2ZE5yQcX6pct8wRSS1hbGpGzF8clYJkd0Zxt4piIH
 VKspVT1bxsZ/liTHAQYHx3Cs9zaE3y1OuKvgwYyJeYHTy24q115MISG+E0STomQCUpac4+00rqK
 0i7iY8Pmte+GsNZutcp0ZpxFsCqiwUh1lja0MDxXXrvtoVArlMfTx0JfjH+cBFbNBKVzJR1Vzw6
 NeRTEK6JBTg6r8QjtqXGBSgvHSQMlxiwo/ekhoX7KDKQlmkm/d4JHERrhVrUARjgvQWu8=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: fe1r9etnsxyf9gxnr9k347rh48ndxaka
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D7F67C0003
X-Rspam-User: 
X-HE-Tag: 1788350990-962379
X-HE-Meta: U2FsdGVkX19x7qvXkWO50Mw7UZ6Ze2E2w+VQHLaPKwyjPzt92JkEjW+Ahgh6hzH9poV0jFoKiZYGce1Tr/HQCg28cjaIKz68PwiSaKgSqMRb2vpt8jCN0Ckad6Dj1TcnJMIACxABZ5jUDALm5e2cOiEnEXm0KJb43lw0LBCXCFB5KtuNF/LfhIU9yI0HOHRex0n3HXoHUE0Y/QFOQyWcBCtKVb/af1ySbd62BgAYPtROA/iYf7Yw9pdT2I5/5w2rjeeL2tF4Xt7KJvljUjKml4wAcuFe6W6wzZAvJP8sLztq+WeBum6/wtgN+dFZi47n7urj3Yg4w49mxFSGlGl6aiC2CTdlsdciV36sjqcM9a2xF568XsYWsinlYvxizLuVfXseK0sXxlloBwD9nsRiIFRjf3zyFm7U1Vsgnq28KbnGkqs7/pVxm+yKxa4pkXqkCdioQ8aYke6BRy4wO2Z6XstrwzPGV3so6KzkiXU6Bd57v2xPYfiw4nTpDE1wfFft+BT+JHB3EW78lP4xngFd7pOK0KjpchWj2ozrHsEFZBhI428hch8Apdqi1OiwOgAgdfoGBWH+RNoLvurVNa1AQ8J9/cmdSVYDQGFBxiWiPF1zJX9qLyFiGXRvZW7BKxx2SPKhvusODkyCtPyH/NMd2sZhS6BMBRag5EG8/VX947o333zrZ4IJ6cNbQYvuxrJCulYpUcNDi5riU7Y8NcZOZ4EwedpJCxKEquEf17bw+RUnFn2BZqvabHcuclBIBXcyyz3/6DB3yHbH+8X3xTT88eUNvClAT6YTMaFlVKkaLrvvaeWmuzYpWSyRqDJ5/U05SKzAl/P+8qO7wdp4zFNHdUwhCq35W5JFqzU1mcLUiRBR/GCVtPJCLhrOZa2yxHrpn4w/aZwlEEdBVa1iUZ/rjCgCSZUF1CvD+lwtFsKJOny6SQi+5r2/YTRYm8aJTBEuVWYrWueonxJyrPzGwvL
 bSEIpeMU
 PIXBn8trdTQNauuSvdhFtIxUwJDMlhdgLeybAotKQLxilluin1z9dlPhBPmnqtmQUpTfIAqetgr1fderDHNbEFB45GfLYKSA1ZclMXXj9HXj7k4fJliAAtjpL4gv8n62PBJav443UXqyWI/UzFCDtq5ktrBt4RZfLhoyhWLH6cndrs5TZ0ukPULP5InLHEL0fWZvJTM/CkBoC+twun2D/06BUdaPnu4F2xchozjhnw0HWHPmyOxZbGNJLNjac+vjhDxMflAb4xrbl57rLIInYlLoeVw==
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

Suggested-by: Kevin Brodsky <kevin.brodsky@arm.com>
Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/split_huge_page_test.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 86a603692826..4bbad892bc57 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -168,6 +168,14 @@ static char *allocate_zero_filled_hugepage(size_t len)
 	return result;
 }
 
+static void madv_nohuge(void *addr, size_t len)
+{
+	if (!madvise(addr, len, MADV_NOHUGEPAGE))
+		return;
+
+	ksft_exit_fail_msg("MADV_NOHUGEPAGE failed, err=%d\n", errno);
+}
+
 static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hpages, size_t len)
 {
 	unsigned long rss_anon_before, rss_anon_after;
@@ -180,6 +188,9 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
 	if (!rss_anon_before)
 		ksft_exit_fail_msg("No RssAnon is allocated before split\n");
 
+	/* Prevent khugepaged from collapsing the pages. */
+	madv_nohuge(one_page, len);
+
 	/* split all THPs */
 	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
 		      (uint64_t)one_page + len, 0);
@@ -227,6 +238,9 @@ static void split_pmd_thp_to_order(int order)
 	if (!check_huge_anon(one_page, 4 * pmd_pagesize, 4, pmd_pagesize))
 		ksft_exit_fail_msg("No THP is allocated\n");
 
+	/* Prevent khugepaged from collapsing the pages. */
+	madv_nohuge(one_page, len);
+
 	/* split all THPs */
 	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
 		(uint64_t)one_page + len, order);
@@ -275,6 +289,9 @@ static void split_pte_mapped_thp(void)
 		goto out;
 	}
 
+	/* Prevent khugepaged from collapsing the pages. */
+	madv_nohuge(thp_area, thp_area_size);
+
 	/*
 	 * To challenge spitting code, we will mremap a single page of each
 	 * THP (page[i] of thp[i]) in the thp_area into page_area. This will
@@ -542,6 +559,8 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
 		ksft_test_result_skip("Pagecache folio split skipped\n");
 		return -2;
 	}
+	/* Prevent khugepaged from collapsing the pages. */
+	madv_nohuge(*addr, fd_size);
 	return 0;
 err_out_close:
 	close(*fd);

-- 
2.43.0


