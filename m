Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28A9ACD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:29:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DC286B00B8; Mon, 11 May 2026 12:29:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B3106B00BD; Mon, 11 May 2026 12:29:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F0FD6B00BF; Mon, 11 May 2026 12:29:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7087C6B00B8
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:29:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 32DD914020D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:29:12 +0000 (UTC)
X-FDA: 84755673744.28.E316ED1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6F2F780008
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:29:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hoB9YXmZ;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778516950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KuiNQ6ojTH8oq0jtTd6gbNhpYt6SdbJ2dusmb/ubVeI=;
	b=kPgGvEjbz7EmwEtVHEgxZ/MfErZMO0i5o9ElucU5D5jLkZtWjJ4kHxs9VImYFYn0WVwJoh
	t1EQdnfRRg5l6EHgNqwKWgNo3+Fu6WxLkXcUUPKQ2XET7OiT8PP6TI/JIzzzeJUiJNBJ7/
	WPpx2p8GkpQ6AtiyVCng2RxiYc+JTgg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hoB9YXmZ;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778516950; a=rsa-sha256;
	cv=none;
	b=xqLlFUc5zOH4DLcnmGlb3vkx9NcqCL2NPo7lBBmaCDcMNuDB9BN+Vl3WdDh7FqA0RjElY7
	QzwS2LNwmV6uU9KaIy/+n3FJa3NthtAmlqMsNflufaR152JgDSPSFBnA5gggiaIq5xIvLN
	ozZrZNe0jdZWLdSWsM1YX9J+11wQ9Vg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 978FA40387;
	Mon, 11 May 2026 16:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F4FC2BCB0;
	Mon, 11 May 2026 16:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778516949;
	bh=d0vdvBKIbvc9uaMc8J9ShA2tg7UuWg8VeCoFP2+IYMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hoB9YXmZKpEaxzBEG7bMkYHvMHspR1WwsuhvtKAbu0e+sOqXcL71iO6ZG9vLUS7x/
	 /+UHRc3e+uJ8PpAr6NUHu1NswSy01BsQdQ8dNUXqjui9Xju7LquyzZwgqFDDYT1ZFz
	 HUrJg1ZeXwngUtSr8/CpNyesMcf/aexhnEVIfZmKWzCRAhLIFn6gslaIDu3//mhyzx
	 NWHrML2MXPF6YeK43c9d183XxhpNat+Ok50tvfMJA2MobHumf5fFM9Xptsob0sePln
	 sEfUd6h9iSDSaOMB7bPTUwVQphYG1A4Xj3aAjXrATcZpFxBnLeYJ9z/7Pl8UutIME5
	 ymxBHOhc5zKnA==
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
Subject: [PATCH v4 03/55] selftests/mm: migration: make nthreads represent number of working threads
Date: Mon, 11 May 2026 19:27:47 +0300
Message-ID: <20260511162840.375890-4-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6F2F780008
X-Stat-Signature: kjrwwk9qzei7m3pqt3og3ja6r1aj35tn
X-HE-Tag: 1778516950-187937
X-HE-Meta: U2FsdGVkX1/MDvMyOgyl8W9k5ASFeXLuvciSQ8rdfj9AoTCLzad1X6T59oPXRsnoCPHi6N9qiyAAmu8a9GOrIkOXUYEQjFwoqxP1tgmTmelyUKmFMtPxn+ojZFwtF2VAWAIjb5Rg+TqrDujRZsJGbKal6n4P3zLg5klyQZMRVE30TK5dXYYp27sqr4x3JKAbSc2hzpFY79arIa5Vu5XPUWOFv7CUG1VSPu82FXVSx/7xbc/vhgEBQ9gX4nGDMGAAe1709ENo3kPX9cdfPSdygsNn04YEsHsvQnpxFzdjn2Tk3ZBO439oOa9OkUks9yVv1QYy5QJDE2I3ZWGGKliCRNAR5mglNCHp/TdAJsUK1zby1hjlLIrN88kV4mmtBUETUU2aSgtGzd8HVHMep9sWRIKvBnO8jc9rNfiIaj358siQi7kOOO2hUWIfSTx9wIOTNyOP2xq7o1AZEJth9eSUQa0uAwlnjW1gAZ7U6WQw4z/yYp0Oe8qXR5UM0ALcNvdQbpCbt/Kl3f7JDadardLAZOL3bs6RGU2QRKev3HVNb2Spp8x11cGMYMuv8C2kD5ectViPYEcCu4UuaKGdiErQNzNXWOF9NfdTphu5RMsTVDNezhFV2sFXAGCfOia6Gvoj69nk1KzvzdBJ+bNaBeJvRmOIz/Aize1VtyL5OsBQ7ALCNfXTkopt8gjZxNMewzIjGuBa5/8SfqkGheT/aX4FV4ieaAiQo+dogsLECFLSx+4QPHn/A0U+ogHpYGhUahX1Yt73lWLSLRSNJPW8hwZa0hK15pnfjbCnLxDWppSF8HVPKT/d0D5oW5lDysegy11QXRvu3fXy+pJpxpGXBRAH3vBfkq7orRarWpmeCxlEr5AQ5yQDAAp96rIGbDh8/3cVQgPc7fzqjCwLLi1rwydosXCEiECZgGY3A1rHBxEGuVPUWdsNJGanMVCgWQClHxqZEcwsshjM3YLQBVFOzfR
 6tF9bzXU
 x4iUORQzm/kUDxOXYBLi6spE3wu9PJtAEwkWnz5v/d+PHUPVIgYWm+NYPEabOIyHwNNlW1qLi6w0nwHLgXFu+kUN0mjH6gC5Vb5EikcO/ViVr7UGsaD6uUO2gw/yfIb8PHl6UQpZ9kOIssuUj6zWdif2WEuD8jP6btyQwicmibW/zhu71v1y3SlM4+y/Gyggk8qva0BbVDRH8JqVLMgkUhUO6x0dSJo/ZwIe1+64p2XLvryz8t1qcbksz1BXyjwFMwLC7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Fixture setup sets self->nthreads to number of available CPUs minus 1
and then each test creates 'self->nthreads - 1' threads or processes, so
essentially nthreads counts the worker tasks and the main task.

Make nthreads represent the number of spawned tasks to simplify
thread/process creation and teardown.

While on it, make the fixture setup skip the tests if there are not
enough CPUs or NUMA nodes instead of checking this in each test.

Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/migration.c | 47 +++++++++-----------------
 1 file changed, 16 insertions(+), 31 deletions(-)

diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
index 0f5a4ddac529..16ffd3c55ee0 100644
--- a/tools/testing/selftests/mm/migration.c
+++ b/tools/testing/selftests/mm/migration.c
@@ -38,7 +38,7 @@ FIXTURE_SETUP(migration)
 
 	if (numa_available() < 0)
 		SKIP(return, "NUMA not available");
-	self->nthreads = numa_num_task_cpus() - 1;
+	self->nthreads = numa_num_task_cpus() - 2;
 	self->n1 = -1;
 	self->n2 = -1;
 
@@ -52,6 +52,9 @@ FIXTURE_SETUP(migration)
 			}
 		}
 
+	if (self->nthreads < 1 || self->n1 < 0 || self->n2 < 0)
+		SKIP(return, "Not enough threads or NUMA nodes available");
+
 	self->threads = malloc(self->nthreads * sizeof(*self->threads));
 	ASSERT_NE(self->threads, NULL);
 	self->pids = malloc(self->nthreads * sizeof(*self->pids));
@@ -127,20 +130,17 @@ TEST_F_TIMEOUT(migration, private_anon, 2*RUNTIME)
 	uint64_t *ptr;
 	int i;
 
-	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
-		SKIP(return, "Not enough threads or NUMA nodes available");
-
 	ptr = mmap(NULL, TWOMEG, PROT_READ | PROT_WRITE,
 		MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
 
 	memset(ptr, 0xde, TWOMEG);
-	for (i = 0; i < self->nthreads - 1; i++)
+	for (i = 0; i < self->nthreads; i++)
 		if (pthread_create(&self->threads[i], NULL, access_mem, ptr))
 			perror("Couldn't create thread");
 
 	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
-	for (i = 0; i < self->nthreads - 1; i++)
+	for (i = 0; i < self->nthreads; i++)
 		ASSERT_EQ(pthread_cancel(self->threads[i]), 0);
 }
 
@@ -153,15 +153,12 @@ TEST_F_TIMEOUT(migration, shared_anon, 2*RUNTIME)
 	uint64_t *ptr;
 	int i;
 
-	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
-		SKIP(return, "Not enough threads or NUMA nodes available");
-
 	ptr = mmap(NULL, TWOMEG, PROT_READ | PROT_WRITE,
 		MAP_SHARED | MAP_ANONYMOUS, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
 
 	memset(ptr, 0xde, TWOMEG);
-	for (i = 0; i < self->nthreads - 1; i++) {
+	for (i = 0; i < self->nthreads; i++) {
 		pid = fork();
 		if (!pid) {
 			prctl(PR_SET_PDEATHSIG, SIGHUP);
@@ -175,7 +172,7 @@ TEST_F_TIMEOUT(migration, shared_anon, 2*RUNTIME)
 	}
 
 	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
-	for (i = 0; i < self->nthreads - 1; i++)
+	for (i = 0; i < self->nthreads; i++)
 		ASSERT_EQ(kill(self->pids[i], SIGTERM), 0);
 }
 
@@ -195,9 +192,6 @@ TEST_F_TIMEOUT(migration, private_anon_thp, 2*RUNTIME)
 	if (!pmdsize)
 		SKIP(return, "Reading PMD pagesize failed");
 
-	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
-		SKIP(return, "Not enough threads or NUMA nodes available");
-
 	ptr = mmap(NULL, 2 * pmdsize, PROT_READ | PROT_WRITE,
 		MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
@@ -205,12 +199,12 @@ TEST_F_TIMEOUT(migration, private_anon_thp, 2*RUNTIME)
 	ptr = (uint64_t *) ALIGN((uintptr_t) ptr, pmdsize);
 	ASSERT_EQ(madvise(ptr, pmdsize, MADV_HUGEPAGE), 0);
 	memset(ptr, 0xde, pmdsize);
-	for (i = 0; i < self->nthreads - 1; i++)
+	for (i = 0; i < self->nthreads; i++)
 		if (pthread_create(&self->threads[i], NULL, access_mem, ptr))
 			perror("Couldn't create thread");
 
 	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
-	for (i = 0; i < self->nthreads - 1; i++)
+	for (i = 0; i < self->nthreads; i++)
 		ASSERT_EQ(pthread_cancel(self->threads[i]), 0);
 }
 
@@ -232,9 +226,6 @@ TEST_F_TIMEOUT(migration, shared_anon_thp, 2*RUNTIME)
 	if (!pmdsize)
 		SKIP(return, "Reading PMD pagesize failed");
 
-	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
-		SKIP(return, "Not enough threads or NUMA nodes available");
-
 	ptr = mmap(NULL, 2 * pmdsize, PROT_READ | PROT_WRITE,
 		MAP_SHARED | MAP_ANONYMOUS, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
@@ -243,7 +234,7 @@ TEST_F_TIMEOUT(migration, shared_anon_thp, 2*RUNTIME)
 	ASSERT_EQ(madvise(ptr, pmdsize, MADV_HUGEPAGE), 0);
 
 	memset(ptr, 0xde, pmdsize);
-	for (i = 0; i < self->nthreads - 1; i++) {
+	for (i = 0; i < self->nthreads; i++) {
 		pid = fork();
 		if (!pid) {
 			prctl(PR_SET_PDEATHSIG, SIGHUP);
@@ -257,7 +248,7 @@ TEST_F_TIMEOUT(migration, shared_anon_thp, 2*RUNTIME)
 	}
 
 	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
-	for (i = 0; i < self->nthreads - 1; i++)
+	for (i = 0; i < self->nthreads; i++)
 		ASSERT_EQ(kill(self->pids[i], SIGTERM), 0);
 }
 
@@ -270,9 +261,6 @@ TEST_F_TIMEOUT(migration, private_anon_htlb, 2*RUNTIME)
 	uint64_t *ptr;
 	int i;
 
-	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
-		SKIP(return, "Not enough threads or NUMA nodes available");
-
 	hugepage_size = default_huge_page_size();
 	if (!hugepage_size)
 		SKIP(return, "Reading HugeTLB pagesize failed");
@@ -282,12 +270,12 @@ TEST_F_TIMEOUT(migration, private_anon_htlb, 2*RUNTIME)
 	ASSERT_NE(ptr, MAP_FAILED);
 
 	memset(ptr, 0xde, hugepage_size);
-	for (i = 0; i < self->nthreads - 1; i++)
+	for (i = 0; i < self->nthreads; i++)
 		if (pthread_create(&self->threads[i], NULL, access_mem, ptr))
 			perror("Couldn't create thread");
 
 	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
-	for (i = 0; i < self->nthreads - 1; i++)
+	for (i = 0; i < self->nthreads; i++)
 		ASSERT_EQ(pthread_cancel(self->threads[i]), 0);
 }
 
@@ -301,9 +289,6 @@ TEST_F_TIMEOUT(migration, shared_anon_htlb, 2*RUNTIME)
 	uint64_t *ptr;
 	int i;
 
-	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
-		SKIP(return, "Not enough threads or NUMA nodes available");
-
 	hugepage_size = default_huge_page_size();
 	if (!hugepage_size)
 		SKIP(return, "Reading HugeTLB pagesize failed");
@@ -313,7 +298,7 @@ TEST_F_TIMEOUT(migration, shared_anon_htlb, 2*RUNTIME)
 	ASSERT_NE(ptr, MAP_FAILED);
 
 	memset(ptr, 0xde, hugepage_size);
-	for (i = 0; i < self->nthreads - 1; i++) {
+	for (i = 0; i < self->nthreads; i++) {
 		pid = fork();
 		if (!pid) {
 			prctl(PR_SET_PDEATHSIG, SIGHUP);
@@ -327,7 +312,7 @@ TEST_F_TIMEOUT(migration, shared_anon_htlb, 2*RUNTIME)
 	}
 
 	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
-	for (i = 0; i < self->nthreads - 1; i++)
+	for (i = 0; i < self->nthreads; i++)
 		ASSERT_EQ(kill(self->pids[i], SIGTERM), 0);
 }
 
-- 
2.53.0


