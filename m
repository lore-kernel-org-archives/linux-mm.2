Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B16A7FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:46:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27AB76B00D5; Tue, 28 Apr 2026 16:46:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22AE36B00D7; Tue, 28 Apr 2026 16:46:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 141B76B00D8; Tue, 28 Apr 2026 16:46:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 010786B00D5
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:46:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ABEDF1601B3
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:46:37 +0000 (UTC)
X-FDA: 84709148034.04.88D1480
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2483040017
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:46:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=owzqcCHY;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lVtTqkI6dusp5pFUZZlnQFFDFO3DE9DYmkBuKDuGyfc=;
	b=T6gOEP4IglLRvJPgO3PY6uRETqAXTtQy3tE25//DUYrVitCM2aupp/Gm40cgbd03K07qSA
	DmJjqs3m+2Mf5fq1q8gNBAN5C2KKdV5bv6ZqTQEcnihHSmfM+tKAgtfn8HY6nsHHwNSb/V
	vbqx+dzj+Igq0k6avykOm7fpQWGjVOw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=owzqcCHY;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409196; a=rsa-sha256;
	cv=none;
	b=0oE6Y2hVrIqZ4jAEOAYtZyv+3RnA20in9HoiyzcBdvx9NZTgkJ9TXId2+/5szVol1LmMQp
	rI6N90qrMrCXt3ugmuZmOeeFSG1TkbGgExoBT8vGUXFiIlBD5MsBrdPXTfiuF58r2ZvVLE
	jPakuWGqTsMPOTwOyOA/+rYHOUbh0D8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 83BE86132E;
	Tue, 28 Apr 2026 20:46:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297C3C2BCAF;
	Tue, 28 Apr 2026 20:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409195;
	bh=zjc7IuQI4jBq+AK4lBqRC09uA93LQf31iSBny8sfuNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=owzqcCHY0PRBQDKGi7LC8tRxQtjr2qQ9qGzwOzRxNfOTuDYtpbwCie9vo8OZ6wnwo
	 dqvpW1pyCm5QPqbXg1hg68xpgLQmVswwcvssPeH0YCO2dFc9LB4QZ7pketHltkljD2
	 0qwnxWvwGQnph1nLmPTp4/5a8L1PwHpwA0BLnEjz8/qI/ao2cRDgR/GdMbICRSTCw9
	 qrkd2LAp3hoWmrEpgoVVYYMsZEVH1whuJ53b3IdRSzz3DQUJGPsEqRqchSS/w6AtaB
	 h7YnHPJzDNajPyqerzOK1pFNTSJnlOAfu0uDwRlo7Mq36d8Hqv9SAsjq7ZVPEE2YNW
	 MjJEI8+77K1EA==
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
Subject: [PATCH v3 34/54] selftests/mm: hmm-tests: add setup of HugeTLB pages
Date: Tue, 28 Apr 2026 23:42:20 +0300
Message-ID: <20260428204240.1924129-35-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sj1q449ba3gofa6ruya4y7oanmwh6qeb
X-Rspamd-Queue-Id: 2483040017
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777409195-473334
X-HE-Meta: U2FsdGVkX1/ya4F9yiCg5GlKhOcz4xI7wg8g4ZaPfBV8h4gokVl5ha+OWOsChmiMsfNARcyQGD0/cDEppLLCXgUpSbpgkC5uHlcpe5apVlyv0NBZfAiHfuSXqvrmObj+6duJF4NS2WQYhfhmkCaHw6SKSxnz4AjKsEMyX2GtLM8Ew/gGX9CynKHDJVZG8lHw/vtEwVK0Ib+XofGIyLHrxDdfmKzuOYZ+bs6vyc87yWypZYUmrNo976CUqZA3qvT9nNrKSJ1mh2saksscc+unlGYZURAJpefKwP9HnBYR/0pXcmqpjL52uPgp+ZyI38z5Ws9oAB3G47vF3DR4JSeoPUuTUTMN2IbnAjx17R7R2kpN/wHUDcS7mBk+yzzAghhdEC66XRJEJY3VeamSl9Z8fhr/shEs0IeJOGUn3pZEgS/q/6gH4wCNgWE6php8zBI2ULnnlJTkUXwkwmQyGetz4EI9DrYznSe2CDmWUIv5yYosMbctoB5pccuNzxpwNzvo0LAe7Qcb08TjWDrLxl1AfH9yP/9X+G22QBlhM2O5vf3XGLkcQojd4GoAgBv7MnU1rWcvYrjPfYoR1RxvLqrsZMiybM52TPnNgvd8xz4vNozBOQGOj7s2thieV4EQyPQo5rBZX61mHAZH7abST4RW2zwJ6U7uGCJsXjnE25atfiWgDwKtwVTkgPyc/7BAShYQZ7fCvh3hdj7r2ZXMRBGWcGvG2T1pqhJo+mWQwOY89tqej/C9krramRT6LytH2L8X7rW3eV3ZY1dLKn4WQaszQkb7Isx8zB43kzia+UKX2FZnqhIlj2DJJjOE14OtdupsM/BFtxvcDXcaMGELAhHXdhDWr8dYOQDPIy7Xu+rH5FbDMyNF6e4rH66ILp3qYuIN5+ceCXBeL8unvdH6kdyfWYuK3L564W4TVN4yuG+TZOAfWKUBCO9iRMWAZTFleJjsOprBh2Idwei5lgv1NJt
 hr4G2n0r
 kkzB5x65fuaNo3LjojVmRdDZaUJuRnjKYkCu+mVqSsFLVF0v1AEr6SYjcqa0xhvW7Mr8pvB6+/CwHw8G07mZgeco9utWV8H298UU8WHQmFI4tA1DJm6VCpt7+HaZf4LORZC1ANgKwEZxiR/jKHwOYCfABmzEKBgaZd6yfLgeHvXfQ0Rbbf4aGr7YZ8ifeCNzxppc6N40duU4vNqvhL2aGGIG5P0MZoilcLZgc0JrDX6Qs3TI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hmm-tests skips HugeTLB tests if there are no free huge pages prepared by a
wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Since kselftest_harness runs fixture setup and the tests in child
processes, use HUGETLB_SETUP_DEFAULT_PAGES() that defines a constructor
that runs in the main process and add verification that there are enough
free huge pages to the tests that use them.

Replace exit() calls with _exit() to avoid restoring HugeTLB settings in
the middle of test and use SIGLILL to kill a child process in
hmm_cow_in_device test to avoid interference with signal handlers in
hugepage_restore_settings().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hmm-tests.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index 409b11cad4bc..70c7ae989c01 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -69,6 +69,9 @@ enum {
 #ifndef FOLL_LONGTERM
 #define FOLL_LONGTERM   0x100 /* mapping lifetime is indefinite */
 #endif
+
+HUGETLB_SETUP_DEFAULT_PAGES(1)
+
 FIXTURE(hmm)
 {
 	int		fd;
@@ -632,7 +635,7 @@ TEST_F(hmm, anon_write_child)
 			}
 
 			close(child_fd);
-			exit(0);
+			_exit(0);
 		}
 	}
 }
@@ -712,7 +715,7 @@ TEST_F(hmm, anon_write_child_shared)
 		ASSERT_EQ(ptr[i], -i);
 
 	close(child_fd);
-	exit(0);
+	_exit(0);
 }
 
 /*
@@ -784,8 +787,9 @@ TEST_F(hmm, anon_write_hugetlbfs)
 	int *ptr;
 	int ret;
 
-	if (!default_hsize)
-		SKIP(return, "Huge page size could not be determined");
+	if (!hugetlb_free_default_pages())
+		SKIP(return, "Not enough huge pages");
+	default_hsize = default_huge_page_size();
 
 	size = ALIGN(TWOMEG, default_hsize);
 	npages = size >> self->page_shift;
@@ -1564,9 +1568,9 @@ TEST_F(hmm, compound)
 	unsigned long i;
 
 	/* Skip test if we can't allocate a hugetlbfs page. */
-
-	if (!default_hsize)
-		SKIP(return, "Huge page size could not be determined");
+	if (!hugetlb_free_default_pages())
+		SKIP(return, "Not enough huge pages");
+	default_hsize = default_huge_page_size();
 
 	size = ALIGN(TWOMEG, default_hsize);
 	npages = size >> self->page_shift;
@@ -2025,10 +2029,10 @@ TEST_F(hmm, hmm_cow_in_device)
 		ptr[i] = i;
 
 	/* Terminate child and wait */
-	EXPECT_EQ(0, kill(pid, SIGTERM));
+	EXPECT_EQ(0, kill(pid, SIGKILL));
 	EXPECT_EQ(pid, waitpid(pid, &status, 0));
 	EXPECT_NE(0, WIFSIGNALED(status));
-	EXPECT_EQ(SIGTERM, WTERMSIG(status));
+	EXPECT_EQ(SIGKILL, WTERMSIG(status));
 
 	/* Take snapshot to CPU pagetables */
 	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_SNAPSHOT, buffer, npages);
-- 
2.53.0


