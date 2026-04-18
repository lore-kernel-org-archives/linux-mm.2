Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6ED4F99C7C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34B8D6B01FE; Sat, 18 Apr 2026 06:56:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FC216B0200; Sat, 18 Apr 2026 06:56:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EB386B0201; Sat, 18 Apr 2026 06:56:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 040356B01FE
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:56:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9CCB013B0AD
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:56:09 +0000 (UTC)
X-FDA: 84671372058.08.E014D85
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id DB9EE40004
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:56:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gVvEBaaI;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509768; a=rsa-sha256;
	cv=none;
	b=2jGWjiGZjahFze8a6f9Fv1h6+QQ8EiBkhrL7hnxPjBU0gTq17HXFI+ZE7brddTLxEV9IJ9
	j+WMjedZqDTNMFTDoOYFdqv3DEnaFi+5o5IKESRz7KlCRuYfoA6LCmr/hmPEMKwUPaQswF
	It/56deBnlYuIuQ3S4iSV8Sbdzc5TLY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gVvEBaaI;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4pwooeLXbQRTt9+xDcxN9kd/z4UPHbgQVM6ICnNXghs=;
	b=MCcSaqHVXwUSfGZ10oJZPhqMlpuKLeRN2NJKJgjKEDKXpsd/Nno5+QlfCaAlDpzW84n8SS
	b9I4rvsZfVBEMZVysXXqoskNWb5sw4VuXeFBcKa9tu2/EHaVNwkOQhNq6duNZzK/05/FqE
	R6qnDaCUBBEARlVm5aLHbIYX8k+gjbs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C59D43AED;
	Sat, 18 Apr 2026 10:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B93C19424;
	Sat, 18 Apr 2026 10:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509766;
	bh=9WpiEMe0fIrSO87Y13ouVGDmAVGndwSJJptTqT0lDc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gVvEBaaI1hTKlI8TbOmjRSuoncRcm2VDyyEXeu7XMZux/XqTUFTWPanT0Ivb4eCjY
	 h/H/rekrCtcvW4+HcxJ292rL3yrOeGdO3y05jUXr65Zsub0BiAxAGsHjLjat6TKgIH
	 ZLFz4QVQbQw+FZhMSRfsNebX+nLchZ351xVJutTn7Nc20Q0mEgO4wCnrZbG541pCrV
	 ZK9VPHs3O7IaTGZdou2K3m//40DM9wszNjzahs6Kk98I+RbM0lV7mn0/H2CjmeIVUK
	 wP8mCM1x1ZHbkmUMOVip2DzudhsUvAU3VPtZ7fYNu1xYSqvCNA/R0xntQ+MbBJ4q0N
	 x4itC3hGWx3Cg==
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
Subject: [PATCH v2 03/53] selftests/mm: migration: don't assume hupe page is TWOMEG
Date: Sat, 18 Apr 2026 13:54:48 +0300
Message-ID: <20260418105539.1261536-4-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DB9EE40004
X-Stat-Signature: 1sc63gqyfxz3s3r8in55scj6919g93cw
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776509767-670937
X-HE-Meta: U2FsdGVkX1/AZc+mWPPJbY5joj8uR9D4+4E8L1oHCr+JVjfL9Nq0WDkGpMr1LQuLE7Q8/KPnjF4eoy2uFyYa2LfCIANjKNjSEUN5A2nHqjhzUTvRZ+nZiBXPpNsFD9HyD8bgfLi/jTDfu2rDj/ufCrdN0yYT/3SDFCw+LDeSBYK+awCvAR43e2LC470iAGibyX9rUXv61KgTUKJ4yJXaakvcYfVCuoUdYRtqzw1mYjoZof4MxvSDoGnOLJte3bc97+mgNvu9C5Wre7M0nu8heqqg4WjtCjINOUZCF88atkMZ/JcEZwvDrtyKuLJajiCxTj1LTmu7MOgE1lIlomnoaAdovUu4WDC5d7dnQRlScnM39yeqQY2oc1/sr2lSgmc8R3JXrapYT3KfTG3raHTbnen00DHNu7zFqimrm/jeh7/1TGD5oh9cta9nuSSRRw/u8SlkajiNIJIqt4Bcp/z48yVLxK7KMXldZvrcIuaBB/rhGYMSDqt2h21EDc74LADo5xh2K13KflaBzp9jNCXO/DQ+qkggIN08VuGZ+ZMN3y+/4yq0oaquAQkU8XZrCbeyxaZc9DzyhOjfaF0rbRVk2taGC2wZw1/meH2y3KWgIcmqn2TlxmuLQShCzm42WAGdWmG5lqIUlNnoIOFTuZHLEHsxtxKUsiljPzpXFErm1EWoa0TMiIlEn0fuES0L/QktqMmRDR6Xzwu/D+3bIv5YSHRFEgpM/LbE9Hv94uxfpdhvqXersm1tBc5+F50y7s3ztw+EHKALeEoV0q2LybuqnwveIcrPmWIP68g3mGm/hmjN+U7WbEG/okEukO/Tk/0XojNycssA0yTGFKRpvYtC3AV1mrSEyHsSKfEXOKtkfxiHMyiT8eTSTch4UCumI6GWVP9/MUgisFiDv52FtDBSZ7zjMtua1mfbLPqGLBMFFb3G7wCG2OQ/hJQCzLitcG88ef90VtYfsYQGpxwaRbK
 spuiORa1
 8wKNP/K/jFRgWAYiPHt/8JRdMQnRTrIyQpZkM1bMMk3njRxcHjRl5s+Qp6KM/FC/PzBXN1MsJzBTMm2UxQXo5DM8EvXx3x4njO5iNW4WTyZythushTIxFT08wyMlTnaOSgpCG90qnfEP8kfOSD9/EjyJ5/lElIlNgO9WZpvF3KsCrvOpRUyKxnf1CdFc+PMaYnBxvVFLg6Ix0e3YeJgC4aH2182CbWpwb59PbLN853Ug1e3Ujnksm4IQIukcK0doHdNJU
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
Reviewed by: Donet Tom <donettom@linux.ibm.com>
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


