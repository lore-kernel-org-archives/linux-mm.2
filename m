Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BAA5FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:46:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 783BA6B00CC; Tue, 28 Apr 2026 16:46:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 734116B00CD; Tue, 28 Apr 2026 16:46:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 622DE6B00CE; Tue, 28 Apr 2026 16:46:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 52CA16B00CC
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:46:18 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 23B81A0358
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:46:18 +0000 (UTC)
X-FDA: 84709147236.21.641596B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7565820014
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:46:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kTFsYnxL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T3CydojST8YyCcBkw0GPuSQcYMWLZte5wcCWbjyBKns=;
	b=xOPrd6EP+iiN6bp+k7dFkfgPuHy4eu5uJHgfe+ZE+aB/aIoTzrJ5vtfLzCz7xiIOpMLudS
	kceWWahc/8nRg35Y3IKrXpVj7SEBcEmRSbqWCdTolURGKkHz71kvYk6MDnKMpDsdPeWx9b
	kxhsGSpt2g5FDelkDKpwGYaDuJVcxyo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409176; a=rsa-sha256;
	cv=none;
	b=F2G5iJGqjOQVRbde1aJNyow+hHdJkuJClLrkf9LOErkohgOuDpiS1T/XnHk9RcBU2jGyp3
	p3St3mioyeQ5ws43YcJi17cH+SNA9+pTPlZiZKcLNxR8NQXaC8oOhdgn1uJJX/fGgOfKcC
	2217b/RIkSzcQxkTwmIitkxvwdwITow=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kTFsYnxL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9882D402EA;
	Tue, 28 Apr 2026 20:46:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0CDC2BCAF;
	Tue, 28 Apr 2026 20:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409175;
	bh=1/ugYRnvvCSRn7Fw/zm14SmACzlAtT74uoyJWfVmAG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kTFsYnxLJOXZ0Q/eEhcLcg5Mlx0/S5fL9oy9PD+uUlFmgofUhqxp7PdVxkOQVCNEQ
	 eMKvRBpPLeJ8BcHjU5lD2EBjvd0VHGsRxbwsZEjZ5Fd6Q3krz8cVblBXTqUVwJ3jQa
	 atxv47h0dBWxJnx2wSGBFc/voKhGGWWaqc1T/NjwKkSh+GqOOqXHrQVqIo9JDmVYf4
	 nsr73MeVOdZyI0K7DYbKAr+KDLczHmrQhprpBvvxqCTssdFm04wNGXq4MnTC5iws1+
	 29t71PuA6Af6KROAp9kammZcyZv4Q8xTEQJ7fIlU/+IDBDG6uIkfJLGgkXuM0itW1U
	 JOMuUU8YENv6A==
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
Subject: [PATCH v3 31/54] selftests/mm: cow: add setup of HugeTLB pages
Date: Tue, 28 Apr 2026 23:42:17 +0300
Message-ID: <20260428204240.1924129-32-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7565820014
X-Stat-Signature: 6gayfjntbiang5cd54t6i1mzkymcomi5
X-Rspam-User: 
X-HE-Tag: 1777409176-976600
X-HE-Meta: U2FsdGVkX1/7ZISGOILXTET/+jzKZETblh0vN9SNERCnnZW9PzJ2pR/6NLyRdHN3o3hYZvozsf+SzJhrDsxiagKrXlrMmDm7uXtDygII0RvPi3vAdrKqfFr7zGqPULD29DBKgFy0GydSQ4AhCM0K/2eEGIdiSHYBPQOxWscuLfEfLdOlryWpIrtSLbvhA2U2dG1ALcFxKz3Svq/tnV4pkXaC3UpWrZlCb8GFmCXuNHITKuTov6uwUHKTg1Wl96Dqnil+x2HGoxR2XQyKwU4VOuD7+iik7A4+eH67Xb9SA7ibm5dJvQNJ4khnmzwU0QO+4d/VZtdjwq/W/LOn2r1Mj7XeDjf7IR6eUxDYdTDeEd6Ne3SkuJUGaFvZGN8om6vqXZTNAqskoWNfyni73Ap2cXK1IdmRpC/dedjyvuwBjsv/4oZt64ghgjvjpF5gkHVrOM32m1CdluPUNuH6p3TBYtscjRhTZJhRS16DUPr+hmfSsqw5hx9Xas+PIPRlqX9r03siqpV5bKRI3SW79i+FJ7suMfcBvckpJTjHQ0T1fIqkcMOnR5qZ5fwLznCl0MPAnupXn4F9n6ogGrNEWESXep7O399sdN6CmmqCIC0OBnZMBP8Nzs2Vk/8yGyo0m2Q7zMorgRuu7kgjhCmnCvHXq2ho6mVetwpsthyWOyR4O0At5XI5saXk2TsFs1nHnrGbi9nxo8UYPVsr4P+qNsHq7xLwx260q1FobltzSaTKwFLKQb2sVYI8l0/H4SzvVzED1cYjBxqLw7AAjNHAmLqR4air0+f9mK6EQq+D10a4HhcEOE2QkL/dk/DTxsIHtsDk/GJb9fqA7sB1ngDER9i7InuEfRMAaOaxkNy9w7bTOf4p0FmKGw1o/U7hHrUj7bxntiLTqyVKftF7xZmlvRl1agL7D8LGIQc5GZCFiX822YAByyML9vD5AzD9st8IxHqn44Uvy1puClXajvnO4Sm
 mYn8QfMa
 siq19rHF8gN65GtIxHP+yLrupAcqyzeHRsEeRC0tAWxaWL1K446Q2h+2NQ5DddTod915y7wM5EDJdkH8kpGS3Y0QMiKW5OCfgIDF2X0/xLRnxm7rFusC+HTmPSwiaoF+ATzez+CGRDU+zlyo6LD9MRus4GxfnBoGzu6DN79QXM6ZlSE11LU4yM/JOr1ZTkehqPsuZTqeSmUt8if+AAQwN97j5W9xXtC0R1jt4mjQaMA5MuLE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

cow tests skips HugeTLB tests if there are no free huge pages prepared
by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/cow.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index 4321f4208fe3..1df513bf362d 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -1881,21 +1881,21 @@ int main(int argc, char **argv)
 
 	ksft_print_header();
 
+	hugepage_save_settings(true, true);
+
 	pagesize = getpagesize();
 	pmdsize = read_pmd_pagesize();
 	if (pmdsize) {
 		/* Only if THP is supported. */
 		thp_read_settings(&default_settings);
 		default_settings.hugepages[sz2ord(pmdsize, pagesize)].enabled = THP_INHERIT;
-		thp_save_settings();
 		thp_push_settings(&default_settings);
 
 		ksft_print_msg("[INFO] detected PMD size: %zu KiB\n",
 			       pmdsize / 1024);
 		nr_thpsizes = detect_thp_sizes(thpsizes, ARRAY_SIZE(thpsizes));
 	}
-	nr_hugetlbsizes = detect_hugetlb_page_sizes(hugetlbsizes,
-						    ARRAY_SIZE(hugetlbsizes));
+	nr_hugetlbsizes = hugetlb_setup(2, hugetlbsizes, ARRAY_SIZE(hugetlbsizes));
 	has_huge_zeropage = detect_huge_zeropage();
 
 	ksft_set_plan(ARRAY_SIZE(anon_test_cases) * tests_per_anon_test_case() +
-- 
2.53.0


