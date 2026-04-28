Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59680FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:43:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C14586B0092; Tue, 28 Apr 2026 16:43:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEAB76B0093; Tue, 28 Apr 2026 16:43:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B00366B0095; Tue, 28 Apr 2026 16:43:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D72D6B0092
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:43:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3C23C8B8CA
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:43:07 +0000 (UTC)
X-FDA: 84709139214.14.F656FFF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7D31EA0003
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:43:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XumDcMVz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777408985; a=rsa-sha256;
	cv=none;
	b=mHJ/S4Ii7bHk/85090zAByLOEhja1PsQeN5FkWnpP2ISNq1aSiBfX4ZK9nmArOamH43U8J
	NAT9TAnKCAnrB/DqBGWsgxaeO75Q0g+YxtY2BVpjFIL3FwKWbHfX6IOmW8Ba7sZ9G5Kijk
	PHnUcHX0LH5ekOIhUmWZhue+GhAYbOg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XumDcMVz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777408985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0NcWRhg4rjaKPFQxBxxInrggXExh/g7FiUuwUnc80ek=;
	b=zefU87fLPDiRKq372ueBepFwUr3Sjww+DVOCJ+U5ytx18e8LhUk4tQVxxach63auy7ljc5
	p38rST/ioF45wEtRnz1DnuCWDZ/hBjLfDTdip+e8gIH4d5WHDIo2WWXml7jd4j5btOfKnT
	JN7GBXov9yG98+csuSdgKYX9Z2DSdrk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 79128408B7;
	Tue, 28 Apr 2026 20:43:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE4FC2BCB7;
	Tue, 28 Apr 2026 20:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777408984;
	bh=gbVKoM4MIVVO1d1uh4/TMxtNfLZkzsd0Lj1SU7TW/GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XumDcMVzgxhC8x7yeu67yd4mcOlveUMWkL8TW3aonrdHfKYvP5i+qhJ3qZnVImkEV
	 cxnQbpV4KkqEeMYqbl6Ly5shuemW5JZDUVV1koqcVRwDkJbAf6H4acEWIB/PMZzpU/
	 R/ecz53cklHv4Mv+h3YleugbD5HpHfUzEUIso5OwSmbqc7AVjJ4OczGI34cNVXAHgF
	 FSW2ELRf075BvHbxGOc5KFpsY/gJjBEvQ8KDP6oCCcUBVKgNuDd//1V1zzYu/ovdym
	 d3Lr19hVyOyyX2N/cbWFDJMqldhuerEO901JC5oeA4EYTffEZE3j5gT1Jm9KNQFHoZ
	 OjbP0lgDZpaHQ==
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
Subject: [PATCH v3 02/54] selftests/mm: migration: don't assume hupe page is TWOMEG
Date: Tue, 28 Apr 2026 23:41:48 +0300
Message-ID: <20260428204240.1924129-3-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k8n3neiyxuq1hkpe6sgn6nsnprcgrg81
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D31EA0003
X-Rspamd-Server: rspam07
X-HE-Tag: 1777408985-21151
X-HE-Meta: U2FsdGVkX1+GgAuNV7bx7p2iS2QsIJBbS1lfsKuDfPtR0rXOWX4mGo/MIsa4ZQTgV3i+JT+C0GuWkDZv6V63z8AbwSPYRk+HJLMDu3ae7ulwobyKm+xmD31Q8iQIKX6VNF0A46j30VxsWMu7aodky7BziFA3+yFkgf7aHjS1+xPOHgGCZxnpHZsywHE6WENJy6d41PKdmdFMXN9O+ZjgxzAzL8uEqVaGSFyGjCvBCvbjtJlGGRoqXkVEXHloAfXj43HvZpTjQmg79XcvSP/NqxQfCcM1wNkVkZ4nxlGTdW+bES2C0An03h3acJZRF2TjeAGKP0qvfHdgL0pKVuJz6YCp/29kg+s1RLRZg0fDrajmlMpjfFby5arnjH/OyJtzMAyKtRp31+xR4uCeM7debsXv7DRqnmy0/gDKbrC86Zbn0jffVcGrL9WlCPuaghVUbCL824knKqaL2OQXCJrqCUVOneOqC8YJsAne4XFv0Ha1RqJrQj3Y8aWuMaivdvy6764qHij1ONA2sUmJrTQyL1KzpRPSKR9N5RyUkhWSQvrHbB+OvP3zpze19ikhXhcu1iFrasB7mNjhsaRVzOYcwdf3aUBmRH5anIYlb9XWIwMl3iMUAMn2EpuGkN7QqtfWQTWvPxyzSb4qdEacQNL96Byq85RuK9dPjIkGCETAnY8iwcreSU4Osn+7FGDJjnpYmlQkIi8l6dOIoSAcgSswbGzGPzFq47hGhRNk0A8BKdN/+9ZRRf08nCufA0Vuv79eJ6hO5nG3jumiJ/wFgFLMcjwGPXAm8cBcLVtv54CdWsm0Sx+zu0GgDnCtc/fQEIWmYPXANGYa8HFmywUMl7Ht63cYKtdKh2PPH/FhK0jxX/WtIaJVPNgryLv3211tAOQwmkj05zue2sxbCSyBgmlJ/B+VuUT3sn9Q2dzKuOcQ2jq8N/yVSSZzf2b/K+ojSiiwRh0nlF7IcQjxalDlF9V
 oIhq081j
 0yn/CdfgGYZ+nQhDy1z+l0bJLbA5vaz4CV/ywq6mq1srY8tiU+CWI7WejcAVKNfkuxeUvHDw6+5YKegrRxj8IXnIaUrfW28nb6sJ4TcjDEDI58B+yx42ZrLeHICzFh7ExMrwtEnH/eKScG3LlPIWz1hSHRf8GOd2Vp1SfDDOLiRuDUhGdqTzpqkkYEzdqEr40ap61KOMMJqeRNoUQrWX3mpjkYKW0dpwditKAR7f7m4c91k2pHOO3oRZwyGbQKfEFyJwt
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

Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/migration.c | 44 +++++++++++++++++++-------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
index 60e78bbfc0e3..7e547d945e1a 100644
--- a/tools/testing/selftests/mm/migration.c
+++ b/tools/testing/selftests/mm/migration.c
@@ -184,22 +184,27 @@ TEST_F_TIMEOUT(migration, shared_anon, 2*RUNTIME)
  */
 TEST_F_TIMEOUT(migration, private_anon_thp, 2*RUNTIME)
 {
+	uint64_t pmdsize;
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


