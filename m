Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DC6BCD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:29:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CACF46B00B6; Mon, 11 May 2026 12:29:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C843F6B00B8; Mon, 11 May 2026 12:29:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC12E6B00BC; Mon, 11 May 2026 12:29:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ACBED6B00B6
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:29:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 644751C041F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:29:05 +0000 (UTC)
X-FDA: 84755673450.29.7246936
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id CE6BB40004
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:29:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q1KGPbpW;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778516943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ll2OgrcNHSQvAyStAWUvvTNz99heUgMP0/+EQq3QS6c=;
	b=EywS9uWinsKxmbQIx3qd2pLG4Zz5mSsoO+mZhsMdO+/ncWG6Kfqu9BswyQel4+WdPcbRdK
	d3a80A9horb9drO8LcdasjExx4yGRDkm9fJ/kBLbNerl/kyZZDsg4WK9T8/KzyJNwlkhK8
	uuGV+C9Z6sW+CFdyUrDjs8qylMXzJME=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q1KGPbpW;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778516943; a=rsa-sha256;
	cv=none;
	b=xue2lU8uWSmSMSTQ9bKg6fxdYtgSvf2kZAuyDA/nUP5ysPV/FT/Kf2QdRnemgm6CQRTovt
	38r7JGtA8pyuX0j0+XAvs7aert+ePhpTtxSkEKjUr03uoAPZx2Bs0XUpGEGs37vVHLF3U/
	7I7ISkkUuvr5P6NsgOaDcZYjPa+YPYk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4651C60123;
	Mon, 11 May 2026 16:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0271C2BCC9;
	Mon, 11 May 2026 16:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778516943;
	bh=UE8G0ohpiQboN1dwA2glOHi5hY0F9YOdn4xqPowVqME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q1KGPbpWyalkzlLAICbfoZs5EGkLrExPqjuwaQN3G76p/q7dnhX9IPntEi3tS+z91
	 3QRleqG4S7WCIE/feXGpwHyMWEBOfvF3/xfffEV24B1MSIBBISohAh9DdvGYKy7KQ5
	 nHDMdREX82/f90i3bZNbRXvNsJG+lpitJdP5S8JFVD3+JlBraB1teGSFs6VGHCv7Tn
	 kp3yfBTMdUY9FF9nvFD/OeMcgJRW4VIGiaYFMdWpdoSK3lMhytJSfBtIubZ5rk+jkC
	 JblzX2jipY9/rSnLApK9YZuY+sjYkYqB5G6LItDBeoecUo9C0tGZvxzNxzepKhQ23A
	 AO22jIbeH/JZg==
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
Subject: [PATCH v4 02/55] selftests/mm: migration: don't assume huge page is TWOMEG
Date: Mon, 11 May 2026 19:27:46 +0300
Message-ID: <20260511162840.375890-3-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CE6BB40004
X-Stat-Signature: zpkfzf1rmx81u8n1ps7xzo8b1pigff9w
X-HE-Tag: 1778516943-173122
X-HE-Meta: U2FsdGVkX19Ngpg6ZrEkfnpUkbAVZxdSKOCjJRGn/8PDUa3GQF4C8jfKKc8OInYIZYz5Gmj1wBUwQnX1vGbMUp7hjDoeVchF0SAY+ALwITgtbUNxX1WML19tMcwCy3Qxbq1dDB7+UCMDPY6R/UYJWLycy0kgntlIDdLXcpJHTT8u/9g9TX70DHGzvupRg2OeZygsITdNIYS2neyiSMebt3j7dP2Nqxg4M2gws+QyvJjMJ6VpWfZCZ7vDnF8wyQnsNThnm4e6gak3RkgoBBu5/9dyUy+z3vPLhdob9AV/UYKgPuqU2YF1nXn2GW5iHsqLYKYcLS3w3B/NirTCMkKCd0avpyP5WTqtsH0boiXKFN2xdqslNy+eVYpanN3drUckSKJttgqxN8jV5QDpe38ANIxddlaqmvaHZ26CqozNFGFA2L9K5LDxIM6bbSL4m3a6MUiOSzvaTT49p0hpdbOHAieQfxgy8EVwjO6jrO1ddt0JNhERfgulbzgAl3oMMrwNyBolQeDD13bQP4z4a7w/zociXIUnttH3PYircnf/wWF1McX5lcrEB/UQMF3C7+xK4m/uL6d5Qim4ybTwkB90s0M8/QHY61vmOnVrVV/fGj8QhOUmAQRHwieyQppC6W473ROQWYMaTvwN9UxM5l+5uLHk2JgdRx3PhpSL1EU6L6YpvKwM6/h3xgCwszlLsfh/zAvgFsWpRPf1HvYcYPw4mSz4dQMdwnJGmpz66khN9F+I1aWrs4KZnXYIAOvlUuefKoJo5z6syopC3KyiT5aFG+vnaZjrqWrd9uG9KnxFFYhslqwe/Kf/SgY3GLyZjOY54LoXmXa6SlbGu1BA3QphF4uq4CfI8L85NyJO5l1fqdQn0VejbJdms0L4UIGfZpBnA9wsEih+Frowg+ClxYGm+ZnztlL1kwT5MdLfDUT2qAJrIJS04KRY8MZ5A2E9wWG/gPY0DnhB7HGsJ5sEBUU
 Ke96sFuC
 Gy0COtQD6fM/dHEwNElFm4AMk68m/6L2MnsLtOPN/eQpRzHJoNa8i7uoP+5999lTeyuEHwaUkNGYx3Pl9IR4TZdlo+5Y6/BKHN+Qowz77ZFHQ43INEaKzpmTGD0BwAP7vCbpTXvIuMVIcuX9DK9Byyw5uyjWYwKKGWUJlZH4OdFMqIOHblHwBq2hUSINBCAhYrG1FHzpZ7KSJ7FLmeXKlZHMNaaNi3wj6w4eL0eW7A6sS89mZwne6knO6Sz4ZnspROjS6TCeQVNgroYTrMRk0Bsk/lA==
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
Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/migration.c | 44 +++++++++++++++++++-------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
index 60e78bbfc0e3..0f5a4ddac529 100644
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
+	uint64_t pmdsize;
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
+		SKIP(return, "Reading HugeTLB pagesize failed");
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
+		SKIP(return, "Reading HugeTLB pagesize failed");
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


