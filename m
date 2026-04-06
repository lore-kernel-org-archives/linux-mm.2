Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F66BF46C45
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:18:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B68AB6B0093; Mon,  6 Apr 2026 10:18:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3FCE6B0095; Mon,  6 Apr 2026 10:18:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7D006B0096; Mon,  6 Apr 2026 10:18:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 990DA6B0093
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:18:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 68EAA1B7FB7
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:18:06 +0000 (UTC)
X-FDA: 84628335372.22.E9A5C73
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9EB8720003
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:18:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R5TQWUnp;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xHO0zDv2NXIV7yF62QUaPdX+GkZ+AzrvV0Qr4epyNeo=;
	b=NSFAAdpjqdYhasjoB0IuOVGDnJzcadYnQbxiHEXAPj8ZltdETJivp6iOTNm1w08yDmiqTA
	ganoQwv4YiW2aqohoMUY0bntnKeBKpjzfPsvXV+/Jjcpr1O28z602lpegFavk0NrVLB6j2
	sv00/VGv9sxpNzq6T2cDOWLksbOa2Q8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485084; a=rsa-sha256;
	cv=none;
	b=AeNmoYdrreYI1gpMSgX/L3Gjr1Ykcu2iRzMMf/UIQD2JosZdoX+0M+vKrNSnU1xSh8UaTr
	M9wMuFc280FwVzXZwd2AWJLakj3gWxal28SsIC/8JK55KQcGusCsjMxSoOCZDZipLjpJtD
	n1m0ve5nDjK36oJMUR2vClyObRczvxA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R5TQWUnp;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BF17042E28;
	Mon,  6 Apr 2026 14:18:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BB5C2BC9E;
	Mon,  6 Apr 2026 14:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485083;
	bh=ZunzhmESrw/FYLfIvxz1F/zRnAmBbpTHiht0efTR3bI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R5TQWUnpGRw5gFKB++Upg4UCfhIJL9e/HjKz3+SmlmDR4drQCTNCOgzMoOd23EWpJ
	 MwMaYYq9o0e2XZ0hBs+P4pAzOacOZsRANW4AAIncObmA+ChFRnDzZTDqNSwJnU3SNo
	 kYeLhr+8qZ7mp7+w7CKNFRK27NRx/phR5sTRmgDF0zzTKHzSNYc/lcKOTdGmXBGdHU
	 KitznWBZu1UD545br+AHcFi+m+UINl1R9KvdYx2B/Sg8yifW9Ye+pzyYYowHdl2lKa
	 MpZ5MFboKhVw8Su1j5AnoX45eXQq46zt5FC8XOu7+du4oCsOUFqwzlbjGL+7vnIyvQ
	 BeBIkOf4tdkNQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
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
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 03/53] selftests/mm: migration: don't assume hupe page is TWOMEG
Date: Mon,  6 Apr 2026 17:16:45 +0300
Message-ID: <20260406141735.2179309-4-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: xx3g3jcgy8reh9hd46a9ko478oxye4bj
X-Rspamd-Queue-Id: 9EB8720003
X-Rspam-User: 
X-HE-Tag: 1775485084-497768
X-HE-Meta: U2FsdGVkX1/7UQL01biHC3FIu9vYvrBPY+2ymoJpgDUldslV+aryLeisQsmLciwvkHzygqkl0Jw+bId1muWNQG9OqEWzrtEC6fn6w0sZxv0WXXUtvpK+VOvfnMsTUpAyWNLES4dWzYxh6YlE6XjzTdbBdysXCStOowmrK5vh1s0l9VJjpmqVDGacHiWywjNwx2ofl+riU4b1dhHTxhMU0rUimFLsyw7+hKNrqjFtthx+wDrsmZBm9r2N0GGtIIuu47PzIze1b3yM9klXZZCG9XiOaEZoKHVbwImz2GhsTI9bw4EXHdDoj8EBTIjTEPX+8QjKsoEEKmf3bfmOwwr5jfWPeyKu/3bsTPhJbIjMMcZEJXcBQp5UJNTENRKWgDGm7M7HEbs7moWOloPR4SbInfX7E7BtAzNR6G3rbITg16ntxN0uEs21VIehfbvPCaxwOpOQwk/pFuk/k57T9pNnPhyfdBKOtZzYSRK8hb2A5TKSofq8u290PhYtcQhieFUqhoSYdHAv4LdIegN+yyOwuVxAqrmiZbVG3yi/fNYoIFoFsXw+NO2CPOgL2hmiuD+tXjw+yawI4zUS6nrByQfc9wQQgydctJ9Z+eU/crHagUe/snYqPKU2PXqTRP0jORddyYswLuM3QJV73SIoD7eL4XY3Alllk1qNug8vF376CGk0fizHKC+c8Nhvfju/IgYAkWghOZlwhJSPVdmACk5+zuA7s762IVZw0tP57+iqi7WvQMYkVjRMGzS2wLz0VPxEIU0sGymfKuzXuhJ0GWRviHciNv1S1N9uTZpQpMZ3GuOF22htAQ0bvOQjzYZv73H1pwPF9l1MJQPmoLtI9n4eeApZh+6ldjbdBUYNAlAMb5NyemGpQGDVeZn17KCL+bU9l/rB1VIE3EtphnkRGeos5+/1chNtO7A6pi2zdQ0KS0cBrB8KDRsQcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

migration tests presume that both THP and HugeTLB huge pages are 2MB.

Add dynamic detection of huge page size with read_pmd_pagesize() for THP
and with default_huge_page_size() for HugeTLB.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/migration.c | 44 +++++++++++++++++++-------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
index 60e78bbfc0e3..e3c2f831e15a 100644
--- a/tools/testing/selftests/mm/migration.c
+++ b/tools/testing/selftests/mm/migration.c
@@ -184,22 +184,27 @@ TEST_F_TIMEOUT(migration, shared_anon, 2*RUNTIME)
  */
 TEST_F_TIMEOUT(migration, private_anon_thp, 2*RUNTIME)
 {
+	unsigned long pmdsize;
 	uint64_t *ptr;
 	int i;
 
 	if (!thp_is_enabled())
 		SKIP(return, "Transparent Hugepages not available");
 
+	pmdsize = read_pmd_pagesize();
+	if (!pmdsize)
+		SKIP(return, "Reading PMD pagesize failed");
+
 	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
 		SKIP(return, "Not enough threads or NUMA nodes available");
 
-	ptr = mmap(NULL, 2*TWOMEG, PROT_READ | PROT_WRITE,
+	ptr = mmap(NULL, 2 * pmdsize, PROT_READ | PROT_WRITE,
 		MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
 
-	ptr = (uint64_t *) ALIGN((uintptr_t) ptr, TWOMEG);
-	ASSERT_EQ(madvise(ptr, TWOMEG, MADV_HUGEPAGE), 0);
-	memset(ptr, 0xde, TWOMEG);
+	ptr = (uint64_t *) ALIGN((uintptr_t) ptr, pmdsize);
+	ASSERT_EQ(madvise(ptr, pmdsize, MADV_HUGEPAGE), 0);
+	memset(ptr, 0xde, pmdsize);
 	for (i = 0; i < self->nthreads - 1; i++)
 		if (pthread_create(&self->threads[i], NULL, access_mem, ptr))
 			perror("Couldn't create thread");
@@ -215,6 +220,7 @@ TEST_F_TIMEOUT(migration, private_anon_thp, 2*RUNTIME)
 
 TEST_F_TIMEOUT(migration, shared_anon_thp, 2*RUNTIME)
 {
+	unsigned long pmdsize;
 	pid_t pid;
 	uint64_t *ptr;
 	int i;
@@ -222,17 +228,21 @@ TEST_F_TIMEOUT(migration, shared_anon_thp, 2*RUNTIME)
 	if (!thp_is_enabled())
 		SKIP(return, "Transparent Hugepages not available");
 
+	pmdsize = read_pmd_pagesize();
+	if (!pmdsize)
+		SKIP(return, "Reading PMD pagesize failed");
+
 	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
 		SKIP(return, "Not enough threads or NUMA nodes available");
 
-	ptr = mmap(NULL, 2 * TWOMEG, PROT_READ | PROT_WRITE,
+	ptr = mmap(NULL, 2 * pmdsize, PROT_READ | PROT_WRITE,
 		MAP_SHARED | MAP_ANONYMOUS, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
 
-	ptr = (uint64_t *) ALIGN((uintptr_t) ptr, TWOMEG);
-	ASSERT_EQ(madvise(ptr, TWOMEG, MADV_HUGEPAGE), 0);
+	ptr = (uint64_t *) ALIGN((uintptr_t) ptr, pmdsize);
+	ASSERT_EQ(madvise(ptr, pmdsize, MADV_HUGEPAGE), 0);
 
-	memset(ptr, 0xde, TWOMEG);
+	memset(ptr, 0xde, pmdsize);
 	for (i = 0; i < self->nthreads - 1; i++) {
 		pid = fork();
 		if (!pid) {
@@ -256,17 +266,22 @@ TEST_F_TIMEOUT(migration, shared_anon_thp, 2*RUNTIME)
  */
 TEST_F_TIMEOUT(migration, private_anon_htlb, 2*RUNTIME)
 {
+	unsigned long hugepage_size;
 	uint64_t *ptr;
 	int i;
 
 	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
 		SKIP(return, "Not enough threads or NUMA nodes available");
 
-	ptr = mmap(NULL, TWOMEG, PROT_READ | PROT_WRITE,
+	hugepage_size = default_huge_page_size();
+	if (!hugepage_size)
+		SKIP(return, "Reading HugeTLB pagesize failed\n");
+
+	ptr = mmap(NULL, hugepage_size, PROT_READ | PROT_WRITE,
 		MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
 
-	memset(ptr, 0xde, TWOMEG);
+	memset(ptr, 0xde, hugepage_size);
 	for (i = 0; i < self->nthreads - 1; i++)
 		if (pthread_create(&self->threads[i], NULL, access_mem, ptr))
 			perror("Couldn't create thread");
@@ -281,6 +296,7 @@ TEST_F_TIMEOUT(migration, private_anon_htlb, 2*RUNTIME)
  */
 TEST_F_TIMEOUT(migration, shared_anon_htlb, 2*RUNTIME)
 {
+	unsigned long hugepage_size;
 	pid_t pid;
 	uint64_t *ptr;
 	int i;
@@ -288,11 +304,15 @@ TEST_F_TIMEOUT(migration, shared_anon_htlb, 2*RUNTIME)
 	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
 		SKIP(return, "Not enough threads or NUMA nodes available");
 
-	ptr = mmap(NULL, TWOMEG, PROT_READ | PROT_WRITE,
+	hugepage_size = default_huge_page_size();
+	if (!hugepage_size)
+		SKIP(return, "Reading HugeTLB pagesize failed\n");
+
+	ptr = mmap(NULL, hugepage_size, PROT_READ | PROT_WRITE,
 		MAP_SHARED | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
 
-	memset(ptr, 0xde, TWOMEG);
+	memset(ptr, 0xde, hugepage_size);
 	for (i = 0; i < self->nthreads - 1; i++) {
 		pid = fork();
 		if (!pid) {
-- 
2.53.0


