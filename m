Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC0E3F99C73
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 11:00:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 637D16B0292; Sat, 18 Apr 2026 07:00:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60F516B0294; Sat, 18 Apr 2026 07:00:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 525AF6B0295; Sat, 18 Apr 2026 07:00:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 408F86B0292
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 07:00:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0A9EF58EFD
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:00:41 +0000 (UTC)
X-FDA: 84671383482.01.E0407F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4ADD9140012
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:00:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MROAtTWD;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776510039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IfwxdIULrvPYbCaT0rC7nJp3cgiUYWThgSOqSi8ytkA=;
	b=6bZ1ZsWY5ygbXeJB8fe9St8C9jaspM1xYko1bs7xDOXvXqcoadn9oD0qmGv62+l3NcUapc
	96auG5kKi7+9OC8LoKuA6k3Hkfcf5ZwYkldSS3sRJUxKfk4BA8w5qm0vQyIu1T0EHUI9ne
	Z+QCd7CsffdqvlYSm36xA7sIY4+S4nY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776510039; a=rsa-sha256;
	cv=none;
	b=wiAlJJrxJI3EwwBiLXltcnbEb4/CDawt06vfQ/dX2EBworMy42dN9qfuX7p8ndSi/KfzJT
	rhpw8WPlnq5CGmgMymeNoodINHQ94/qUJ8yiQfY3/I6Hc4W0itkjtJrEp9EfedogT5gA+Z
	uPGR0mKM6Ic4cc4nGZy4FHKmSJ8LKVo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MROAtTWD;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 74F6F417D1;
	Sat, 18 Apr 2026 11:00:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA89C19424;
	Sat, 18 Apr 2026 11:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776510038;
	bh=n2KgdfeDkv6qGICkBg3Vwdx+MRmhbjeNlFxUjnQTB8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MROAtTWDIn1OZ96pLvy5zn9VfxI6UIfevlt/DDeu7Tpiq1FnWv1gUhNMEO3WpqxOW
	 +Vumc1VsrrwZ+wfVewh1G10utmvathISpPHN/6QsKDVpJnxoxc5OSRjgefcMXa9JXX
	 MsTXQ94e4Pkblg/piVHQtpl9m5P41Za8ddya1n/BaX9fanDqP4iDndRW93o5hImTmA
	 cSC8Exfg3F1szGf+XvWKtwduZg3h4QVhdhX503+aUPPZi+8tQbDCdJZit+bItSiKZq
	 rU2Qli/D+Mnt1X4taIogLGpLz0ifacUiSgwiJFozfz+LT6cpoXR6vkRVgTS6PO/jZ2
	 ZZlUAwnb3A/fQ==
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
Subject: [PATCH v2 47/53] selftests/mm: uffd-stress: use hugetlb_save and alloc huge pages
Date: Sat, 18 Apr 2026 13:55:32 +0300
Message-ID: <20260418105539.1261536-48-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8g5dnxykhrampaatr11qayom5byxuica
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4ADD9140012
X-Rspam-User: 
X-HE-Tag: 1776510039-87616
X-HE-Meta: U2FsdGVkX1/GxOcE22j9Etm6S0q79n0WdII7hAnbd3JRx0lrvWEUTw6osjFg1xvniXUL9DSMUZpeJGbsVdRYvOxNQmkXptmpJnW5IgOTKxHmTbArs4hrbe3OD/tehTQDojgB4MPOZOMIeNpuRbtB1UwLpEHwz3ZMFJIzAj7t6qxoH5C+/q286bQV6JihnZxUuGK/5sSe0Y9cm9TzoILi1AYpzGFyBMp0rAWJPvsTdqOn2Uw1Kf6brbLris68+LWzCUH9sp8Z3dt+Su8zleUA7RFAkjSE9gW6tH62JqlaY3tGxhwCfVNhdp2+MzZQLbpoI/qY8uenzFh/pNch+TsjM0/5gE3T0c2BFcxkSaa6iG13Y3SXs90AwD4nSJXetPly8oLxIng+ycVVzY2jRe7eWYSdHwLR3m3gPp+hgb1SpKhU35YTCIKZKuEMHDvWPW8eRr/W8YX7wBWDn5Vd58x2Tel+8YM9EkASGbTwuJxCGxkPPwpLRV6tL1hGHfKNqMteixrOHpwQ+h1R3F/RW3Y4bGenH8he71VFMGulPgBz+sSo2m2iR3HyGCYGb6SaCZQ3bq1EfEL6lwH/Neo57cbYIrjBov3fE2Ucd4osD5j+VE4bf/zPumxcWjmvI259ZIzIG/0GPOFc+RHMv2/CIyyNUXfMkSHagwqBlzzt3yj84jfy953ovskVU0ysSelUn9g7+sHsvWkRg6rGoFSTr5prsst22Ex9CRK8YM2OTpMueLGNMND5M7faCBJkPo4Jd8nxuhhIJ9lk69vNe7Be+2pHdOe/IcKB36tC8pMGXKf7n7pue6EBd39ce4xrvgcTAqtVICL3kgoCXHQb+XkB+0N8CpE5XlmJI303fbBhl6Rty9h0Vt17pPEVRsTZSI2XY9LRMkskdSB5g3+G/MiOmDfgleUs41dDqpuoY+dIPB7rx7fhrNACHLEQ5QWqhe7SuY2SRyl4SuhhfCYJtzY7vEY
 q0MF0IFm
 Pj8xMnciMQ+Eo6Xht4S4BSkwdwdZw+ZibYcgRMXLmElPTdkEq3IEi9baabpjC1FYjoOJLL3I6XQQ6WUsSA5p/RnnmpsXqiSihxfAS9CQVVRHx/6gLSuShn261CR4GA53vHBJzWALImDxBliatMbf82dtLj0C0w8nfNl33AR0mQxdPSgk7JTWkoAG9WIGSEzH53S3Fawz5WLOdCI3x4tZiIOjJLZS/LZ0gBcsZ4mTgCsL8bnVwW+p7sNernobUE1uepzU+8jt70jL4rI/6xQtWhL0AUnJ7xhV2/B1y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

uffd-stress skips HugeTLB tests if there are no free huge pages prepared
by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/uffd-stress.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-stress.c b/tools/testing/selftests/mm/uffd-stress.c
index 7e37cf3d27f6..9693d042f16f 100644
--- a/tools/testing/selftests/mm/uffd-stress.c
+++ b/tools/testing/selftests/mm/uffd-stress.c
@@ -479,9 +479,12 @@ int main(int argc, char **argv)
 	 * Ensure nr_parallel - 1 hugepages on top of that to account
 	 * for racy extra reservation of hugepages.
 	 */
-	if (gopts->test_type == TEST_HUGETLB &&
-	   hugetlb_free_default_pages() < 2 * (bytes / gopts->page_size) + gopts->nr_parallel - 1)
-		ksft_exit_skip("Skipping userfaultfd... not enough hugepages\n");
+	if (gopts->test_type == TEST_HUGETLB) {
+		unsigned long nr = 2 * (bytes / gopts->page_size) + gopts->nr_parallel - 1;
+
+		if (!hugetlb_setup_default(nr))
+			ksft_exit_skip("Skipping userfaultfd... not enough hugepages\n");
+	}
 
 	gopts->nr_pages_per_cpu = bytes / gopts->page_size / gopts->nr_parallel;
 	if (!gopts->nr_pages_per_cpu) {
-- 
2.53.0


