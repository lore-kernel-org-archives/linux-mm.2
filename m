Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 380B7FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:43:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3D0D6B0093; Tue, 28 Apr 2026 16:43:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A15496B0095; Tue, 28 Apr 2026 16:43:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92AE86B0096; Tue, 28 Apr 2026 16:43:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8025C6B0093
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:43:13 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 49368A0387
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:43:13 +0000 (UTC)
X-FDA: 84709139466.08.FDE509A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id B1E611C0010
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:43:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H+ZSn5Fk;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777408991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kpu8Vlu4fDp0bTBKsIKkDn68woq4osNXuVf/SpEs4c8=;
	b=30kbbqSJz30BBDkhJZZKjHhC7WSRnvSJyEVrKJtywEa4w4dq+CliyGsD8cxYoCNMBX+LSI
	KjphCxZEwMvZHfI9rVcU/yZZRXDM3CRMVKtOgCtv3luHPGQsjjpLZ9bEe4aa4FcZRo8Bzf
	OM0kD8OToIQE2WjTE0gv+biaTb6xWrE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H+ZSn5Fk;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777408991; a=rsa-sha256;
	cv=none;
	b=ndvmqHKPFOC5nawhhb+jN4oun6QZTmg0bXLNfsGbe8Z8OXpI1YGy70v5w9Z5n8IWSEWsxC
	yc+fUMbB3MF4r2yEYEzj3LnsmTnq6oZrWoBOPtLcFQEUIHb+jacARHvXtmmM4NVJoAeEOx
	s0dI1avxN7Q34Hvjf1X0uO96d+sNK2k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D23661145;
	Tue, 28 Apr 2026 20:43:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82F0C2BCAF;
	Tue, 28 Apr 2026 20:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777408990;
	bh=TjQ0p1EGbgPObHJ7eufAXRVft/JMHNsgzynJsyAX4Ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H+ZSn5FkeimOUjEC4shA19METCOWCCCNxrqgbHDLaq0t9XqFo0tP262UcFd0MpiW/
	 OOtplgxA8Bdd+HR+RPORL63i5P3FDdaSETgZvK9XilFcTfMRclX96S4l7d8cacLaGY
	 TA5BQiLwSdqc10NEYKALV245BMw1CwarhoM992en3RBph0krphz2q0bjDdyHIAZQk7
	 okMnvrClQMv+X+pjQ5i/SqyqpMrNO+pC3YSmfM1LyfvUMNYr2iYEkFIawQx2wD/HMa
	 SNMHLtdo2w4hc+kEI+xEBEUaku6xaWZ+fpdGzMuj0LvecAMANcl07Rx3zrrd94WBqE
	 MmNOcyenwZo5w==
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
Subject: [PATCH v3 03/54] selftests/mm: migration: make nthreads represent number of working threads
Date: Tue, 28 Apr 2026 23:41:49 +0300
Message-ID: <20260428204240.1924129-4-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B1E611C0010
X-Rspam-User: 
X-Stat-Signature: fyowokckc1crsbut4diqhpy1szfm9ch5
X-HE-Tag: 1777408991-116025
X-HE-Meta: U2FsdGVkX1+nKs7nj6AcHK/0nlnFVALU8xSMBdAi1tRSpHiQ5sX1gKJ6i+03XoeEPmCL0eCsTrCKh4EpE5591Ox5tCY/gH9yWzfdoNebE/jMMOwmvxcJeIqxqfHw1Vv2YQQhH7a1i9rwLq48iUTWbXSzXwvJ94XdSVz0NMtXMMWCqcL/5nP2KGpUZ+iozEXJTTTYole60/C9N++3mEqwt3BAuBkCABzL6jROsaZtWoqq87I79Grximwo6tIyrCnIzj1Z0hWiZ5juRDV9HdNoabKQRAM7OTcgDknVyI9vet4ZWwcTTnWAQZ2TeGW+NQWjmUHJ+x60JKHgdEgy99Lm9I3NRTLp2Xy/SgmO0rHoQUjkA5AO5iXvRLg0OeXdOnwXRYe7r5vSCBEVZchM6ScM+Tr+ny9IexaMibJvHUp2BXftXetK4zHQWbclWh3XqbTX4xU+LOaX1X423fJq7YLBRDS86pyNEJSQuM+C/vdQ22KnZYD/8QVj1isARnngpIeb+DCzBewz9ry45Qqd4By+71RZm6BKveVr7Be4RUCQZk2X83hQE+6x2GL01S3SYmAm8seDKeZ46xrgk0Eo6wE67/T2CxnfWJYLVTd8TbajinJlG7O9JRBpTFzOmP3SNwQw4bj5yA0uqWGtZRMxrg4dvaSAEVpvevICjo4vSYLFOO3SHohPux4ywRGDpsWM94eTlJoydcOU5lEcUrz3VgdQtWWR67baskc8S9dP7IhbVpGySLNlXpk/cAJ7y98P+rCDIIukEW1YicM/OR3ZP5I/j5Uxedtai9GZBQDt+5+1crFXXEPKWgnINvEFFaa+E4Ls5K3qJs72pN6jGeP2ZgeMFoa9UYRRPV2aOn1RD0R36b8lMOk2IK+VXe5lujgaRJw1yal8C+qqWCY0mP3j/DGN/V0q0AAjxVEw0xwbUpjRxKtrsbLilJGmEMyeDA1OYlfm9HPTK0QjS3+gf45WTUA
 ZLRodjMM
 ChiA79aJjSQrXwF1n6CeveYr8iM7Pqj8FYlFd1YCiJp5mNoWhUZyub8L6L+WrcyFT8MYhDvYLQfWPpiXM/JpFXnL++R8vcf7Dr4b4c3JOcsD6jxjW41qMgkAiXvo1nmP1TiKRcVhT93IWEEgIgLPQPjS3amLs+i1ngtjnlOHdJSeGbiDrSnjzf5wlzy+YTVhP3582+8ZLpAXxo2/egnT4argfVfEinF1QdnW0EHbHUP37NVQ=
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

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/migration.c | 47 +++++++++-----------------
 1 file changed, 16 insertions(+), 31 deletions(-)

diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
index 7e547d945e1a..3630f2fb0800 100644
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
 		SKIP(return, "Reading HugeTLB pagesize failed\n");
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
 		SKIP(return, "Reading HugeTLB pagesize failed\n");
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


