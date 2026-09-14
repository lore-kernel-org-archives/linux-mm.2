Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4969AC88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 07:31:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CD136B00A0; Mon, 14 Sep 2026 03:31:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57FF36B00A1; Mon, 14 Sep 2026 03:31:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 493BA6B00A2; Mon, 14 Sep 2026 03:31:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 224826B00A0
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:31:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7CBF9121196
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:31:10 +0000 (UTC)
X-FDA: 85211546700.06.466C63B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8B5C814000E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:31:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OPHlJX+M;
	spf=pass (imf26.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789371068;
	b=OtsYxU5Tf8znHscCvF+g0wbLzwNYjI/TzcMDuY5v006NcKcHtI0APYX9xMoRjPxit3bXRm
	V57PC3sSxxBVWUtGD4x0WzPSzMbTjWLPCEegNVTek1UFJAc5R5eWlRL+aWyO80UouWprGY
	NYUzowk0SIIu6HO1jem9+gXWEBTdGkc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OPHlJX+M;
	spf=pass (imf26.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789371068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mO+sCXvny2uaBSeQIr/OsvCwUgW8wtX4Ij2cQr326tw=;
	b=ZruoqRRE16OIo64Jz8Hjpj7Tx/NSo46aA4gLMU5FW0+9IOdkO97Fz7mW3Jkyc20aU/evBj
	PxbgcMCocx7QJf0MO55mmNYDmdy+bw7wKxUuUXQdrgJNKeVuk7v7EJ1kaB5fw9WAOmjtyA
	taCKdFDbSsBQjUwDxCbE8ega69qvmIs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3F5251570;
	Mon, 14 Sep 2026 00:31:04 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6E39B3F59E;
	Mon, 14 Sep 2026 00:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789371067; bh=utuQ5Qw9PHZyHCVvUbwACf+tdMWlTIbrwdI3rerxdQA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=OPHlJX+Mm3VJajJB1BXzm3KaXutP5muvUHjdzs6Mpk9Xf9yoNzGoPYet2V9rDbwqM
	 iQXRrV84FxW7EjXoH6VwZUnJXlJUoaYsdf0ivpXm/LaQbmMuwXKyNpj+fL45CnUNSM
	 Qb7GlLz40/tOQ3qkha4sWMrRleFv+fCwRU2M0/hI=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 14 Sep 2026 08:30:46 +0100
Subject: [PATCH v3 1/3] kselftest: mm: rename read_pmd_pagesize() to
 pmd_psize()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-fix_hpage_macro-v3-1-c9a305a01d39@arm.com>
References: <20260914-fix_hpage_macro-v3-0-c9a305a01d39@arm.com>
In-Reply-To: <20260914-fix_hpage_macro-v3-0-c9a305a01d39@arm.com>
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Peter Xu <peterx@redhat.com>, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 Sarthak Sharma <sarthak.sharma@arm.com>, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=15952; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=utuQ5Qw9PHZyHCVvUbwACf+tdMWlTIbrwdI3rerxdQA=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqp6KzPEr1wVDDj2wVTFEpz1goBrf0Yh2206PGQ
 m/Abq57twaJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCaqeiswAKCRBt1cPRWsUx
 Mz38C/9dFZF/5oqpApRVeyneKUy8Mi000DqWf/jJinZozi7rVr1tjQn4HzDLV6PYfSNDw0mlgnI
 C3/DrQcfSkFWdaGyOuPpTGbfawqMUQQYfmCPVf2Rt/Hrn5lSbhVjiUdmzdnuSXGbwPEap087QzE
 sqJVm8MHiVWxGjJWfo+2ZfmkKwUdkxYkTlrx+FFFu5TmLJZk/e/yyGPZlGImNyxymu8/cr3Gvwp
 I4ajSsAsA0G0pKTWbgBjuItuQgVJxWGd1T8f5VGKr2gTVTCZVoazOr54S6gk5Aw9wGL0G+bL9Ge
 9i5w4lJ+Kz83PZv1tlQfKe/oLS9M0zB+bavoTEkqLHVP2g8WjH0Bp1mS3Us8/qvquOlIQQyyDBh
 M7UaDtUUgVJtyB2jaRfJykGKSWieGUIarROyB0dsKzVgLj+5UmNcT4kmP2jq7NvgjtJVjW0SSoB
 46fOBVhY73qmM1TqXZ9jFrfq+FVhLP+gcoxJzdDSSogBt1c4NJTgy22rRhAxuh5iGQxFg=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8B5C814000E
X-Stat-Signature: 3itiy61wrnkr3sd6azih45nryapncppi
X-HE-Tag: 1789371068-923537
X-HE-Meta: U2FsdGVkX19ykUjQoG1J9lEC1BJYD9dSbCog9hWBHfrdqV0lqBb6ql7/EUkb0ycw/BO9oV4KgW71NH2zFNV4Kva/d//EhN4lBD3n2cXgZ07P3raKeBwZgCeBQknC1Ikhi+NW1JclXW45qcOR87nBVSQOPaDyNMpsGwrQRg/ZYtpgM7qyzcQhas+WF8pFZkFZyefeT6tI7pJAxb55eOGxyRAY3vuloRJDe+2bYOBdnE8Sc/WscVpmsKFeod0mD/nsjTUN9PpOJ11nb2lpoiJloDHmi1A744jog5+UvR0qdYzrdiDoWayA8g8BOjbnh45TO990Kkzxbg49rQ+SEi9ibVAwlbVen7jEI5ADje+f8fZxploqDUDCA1Efd4Bjuy8OlKjKqpQxc81+SNIJGaQmy+I9+sdXzZpeaHwqVQIUnmXAe5Navvm9nOnoWlQNWlxmXewGrtiPCZ+92BFgxa9HMjgBERcEWNLO+gyO8Qa6zMxCmYSEVXPdkqsFlID2cUTC+jQkTI5fsUNi6hf9MEuDx+ymINGEunhT0tbILpZhdJZERW9zlXVbnGiF0aCXNaeNaP180rIUg3C/KG1z7c/TUL01nc9/v+LQHJfRbnKSIDqKeq4S6zgcBLWX7V14deFYYYOE05Yb3Ae7jjtj7X2b7bErF+9qwdAmAmIt1Btw9+El1lRdrYMhjvJZtfdsSCgZUH5R3y/oNJIfmKyIXeD8t86JjCvnFBR/DfvO9KbehpdVNu5NZK6x5HgEcE8eumcVAm3m2h+K4G7SqvmuSESM1cQ2KoKuL2p9TUxzc5XU6T6nwv0NIC/q5TaV1msJ6whyfgkfqvwMhX4c+EVtjtJ9Jt4Kxcs/ckT4iCzTYaUYN+leMXo4uH8eXhkjM7Ln5CBsDS6nCeKxAOOXIlEpOZ1GKxd6zO8tAt8/79Ve2nBgyWsaXN8LqDrOMBNIyp5JwTFm3+CXpwYLJSz9a4Q9xlR
 w4vtP1va
 /WihCBs6XF5ShX1HghYnaG0Z8OJuQK0t2C4JmID0xkdR29sxhOZdn4/RLiW/BpCUBSYGQlD9vFPM3zLBRi4MGnQcdFTn78vwncwPTSxOJmQDTVOR62/wSB4G1Wo9JgVuwEpbxDls0y4fQmIGlcJs9tbJSBwgPdR2EIp2wgcA/gFXYigfLO238TP/Ndn8M+hy173Wg2p3SF/QG81ZnXRNVhc9xUZA0BhCdWeJz8FtUY9NTiguZJinDZs5yoX5xvouaSU8WdIdwbBDwexv/ChJZ4mIiWwf5T7pq5fkGlmkyE9MFKKwlAyQ6LjlBPnKX1YdwVp9MTNCuCr4gJs4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For consistency with psize(), rename read_pmd_pagesize() to
pmd_psize(). There is no functional change.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/cow.c                   |  2 +-
 tools/testing/selftests/mm/folio_split_race_test.c |  2 +-
 tools/testing/selftests/mm/hmm-tests.c             | 22 +++++++++++-----------
 tools/testing/selftests/mm/khugepaged.c            |  2 +-
 tools/testing/selftests/mm/migration.c             |  4 ++--
 tools/testing/selftests/mm/mkdirty.c               |  2 +-
 tools/testing/selftests/mm/pagemap_ioctl.c         |  2 +-
 tools/testing/selftests/mm/prctl_thp_disable.c     |  4 ++--
 tools/testing/selftests/mm/process_madv.c          |  2 +-
 tools/testing/selftests/mm/soft-dirty.c            |  2 +-
 tools/testing/selftests/mm/split_huge_page_test.c  |  2 +-
 tools/testing/selftests/mm/uffd-common.c           |  6 +++---
 tools/testing/selftests/mm/uffd-unit-tests.c       |  8 ++++----
 tools/testing/selftests/mm/uffd-wp-mremap.c        |  2 +-
 tools/testing/selftests/mm/vm_util.c               |  8 ++++----
 tools/testing/selftests/mm/vm_util.h               |  2 +-
 16 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index 8aa5249d9bef..e42edeccfd7a 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -1889,7 +1889,7 @@ int main(int argc, char **argv)
 	thp_save_settings();
 
 	pagesize = getpagesize();
-	pmdsize = read_pmd_pagesize();
+	pmdsize = pmd_psize();
 	if (pmdsize) {
 		/* Only if THP is supported. */
 		thp_read_settings(&default_settings);
diff --git a/tools/testing/selftests/mm/folio_split_race_test.c b/tools/testing/selftests/mm/folio_split_race_test.c
index 1960635a953e..a956e5c74c65 100644
--- a/tools/testing/selftests/mm/folio_split_race_test.c
+++ b/tools/testing/selftests/mm/folio_split_race_test.c
@@ -235,7 +235,7 @@ int main(void)
 	ksft_print_header();
 
 	page_size = getpagesize();
-	pmd_pagesize = read_pmd_pagesize();
+	pmd_pagesize = pmd_psize();
 
 	if (!thp_available() || !pmd_pagesize)
 		ksft_exit_skip("Transparent Hugepages not available\n");
diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index e2642eca0d02..ad14372b75d9 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -569,7 +569,7 @@ TEST_F(hmm, anon_write_child)
 
 	for (migrate = 0; migrate < 2; ++migrate) {
 		for (use_thp = 0; use_thp < 2; ++use_thp) {
-			npages = ALIGN(use_thp ? read_pmd_pagesize() : HMM_BUFFER_SIZE,
+			npages = ALIGN(use_thp ? pmd_psize() : HMM_BUFFER_SIZE,
 				       self->page_size) >> self->page_shift;
 			ASSERT_NE(npages, 0);
 			size = npages << self->page_shift;
@@ -730,7 +730,7 @@ TEST_F(hmm, anon_write_huge)
 	int *ptr;
 	int ret;
 
-	size = 2 * read_pmd_pagesize();
+	size = 2 * pmd_psize();
 
 	buffer = hmm_buffer_alloc(size, size,
 				  PROT_READ | PROT_WRITE,
@@ -1941,7 +1941,7 @@ TEST_F(hmm, migrate_anon_huge_empty)
 	int *ptr;
 	int ret;
 
-	size = read_pmd_pagesize();
+	size = pmd_psize();
 
 	buffer = hmm_buffer_alloc(2 * size, size,
 				  PROT_READ,
@@ -1984,7 +1984,7 @@ TEST_F(hmm, migrate_anon_huge_zero)
 	int ret;
 	int val;
 
-	size = read_pmd_pagesize();
+	size = pmd_psize();
 
 	buffer = hmm_buffer_alloc(2 * size, size,
 				  PROT_READ,
@@ -2038,7 +2038,7 @@ TEST_F(hmm, migrate_anon_huge_free)
 	int *ptr;
 	int ret;
 
-	size = read_pmd_pagesize();
+	size = pmd_psize();
 
 	buffer = hmm_buffer_alloc(2 * size, size,
 				  PROT_READ | PROT_WRITE,
@@ -2091,7 +2091,7 @@ TEST_F(hmm, migrate_anon_huge_fault)
 	int *ptr;
 	int ret;
 
-	size = read_pmd_pagesize();
+	size = pmd_psize();
 
 	buffer = hmm_buffer_alloc(2 * size, size,
 				  PROT_READ | PROT_WRITE,
@@ -2161,7 +2161,7 @@ TEST_F(hmm, migrate_partial_unmap_fault)
 {
 	struct hmm_buffer *buffer;
 	unsigned long npages;
-	unsigned long size = read_pmd_pagesize();
+	unsigned long size = pmd_psize();
 	unsigned long unmap_size;
 	unsigned long offsets[3];
 	unsigned long i;
@@ -2226,7 +2226,7 @@ TEST_F(hmm, migrate_remap_fault)
 {
 	struct hmm_buffer *buffer;
 	unsigned long npages;
-	unsigned long size = read_pmd_pagesize();
+	unsigned long size = pmd_psize();
 	unsigned long offsets[3];
 	unsigned long i;
 	void *old_ptr, *new_ptr = NULL;
@@ -2323,7 +2323,7 @@ TEST_F(hmm, migrate_anon_huge_err)
 	int *ptr;
 	int ret;
 
-	size = read_pmd_pagesize();
+	size = pmd_psize();
 
 	buffer = hmm_buffer_alloc(2 * size, 2 * size,
 				  PROT_READ | PROT_WRITE,
@@ -2413,7 +2413,7 @@ TEST_F(hmm, migrate_anon_huge_zero_err)
 	int *ptr;
 	int ret;
 
-	size = read_pmd_pagesize();
+	size = pmd_psize();
 
 	buffer = hmm_buffer_alloc(2 * size, 2 * size,
 				  PROT_READ,
@@ -2609,7 +2609,7 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
 TEST_F_TIMEOUT(hmm, benchmark_thp_migration, 120)
 {
 	struct benchmark_results thp_results, regular_results;
-	size_t thp_size = read_pmd_pagesize();
+	size_t thp_size = pmd_psize();
 	int iterations = 5;
 
 	if (!thp_size)
diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index f82673f5f6b4..76c1fbcc5260 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1330,7 +1330,7 @@ int main(int argc, char **argv)
 		ksft_exit_skip("Transparent Hugepages not available\n");
 
 	page_size = getpagesize();
-	hpage_pmd_size = read_pmd_pagesize();
+	hpage_pmd_size = pmd_psize();
 	if (!hpage_pmd_size)
 		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
 	hpage_pmd_nr = hpage_pmd_size / page_size;
diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
index f19d53c69576..4280d2c87b22 100644
--- a/tools/testing/selftests/mm/migration.c
+++ b/tools/testing/selftests/mm/migration.c
@@ -229,7 +229,7 @@ TEST_F_TIMEOUT(migration, private_anon_thp, 2*RUNTIME)
 	if (!thp_is_enabled())
 		SKIP(return, "Transparent Hugepages not available");
 
-	pmdsize = read_pmd_pagesize();
+	pmdsize = pmd_psize();
 	if (!pmdsize)
 		SKIP(return, "Reading PMD pagesize failed");
 
@@ -263,7 +263,7 @@ TEST_F_TIMEOUT(migration, shared_anon_thp, 2*RUNTIME)
 	if (!thp_is_enabled())
 		SKIP(return, "Transparent Hugepages not available");
 
-	pmdsize = read_pmd_pagesize();
+	pmdsize = pmd_psize();
 	if (!pmdsize)
 		SKIP(return, "Reading PMD pagesize failed");
 
diff --git a/tools/testing/selftests/mm/mkdirty.c b/tools/testing/selftests/mm/mkdirty.c
index 68dd447a5454..49ef643a6e63 100644
--- a/tools/testing/selftests/mm/mkdirty.c
+++ b/tools/testing/selftests/mm/mkdirty.c
@@ -330,7 +330,7 @@ int main(void)
 	int err, tests = 2;
 
 	pagesize = getpagesize();
-	thpsize = read_pmd_pagesize();
+	thpsize = pmd_psize();
 	if (thpsize) {
 		ksft_print_msg("[INFO] detected THP size: %zu KiB\n",
 			       thpsize / 1024);
diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index d9a4fb782ecf..d0e34dd5850b 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1654,7 +1654,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
 	ksft_print_header();
 
 	page_size = getpagesize();
-	hpage_size = read_pmd_pagesize();
+	hpage_size = pmd_psize();
 
 	if (init_uffd())
 		ksft_exit_skip("Failed to initialize userfaultfd\n");
diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
index 82c6e96ea6eb..d0290c4567bd 100644
--- a/tools/testing/selftests/mm/prctl_thp_disable.c
+++ b/tools/testing/selftests/mm/prctl_thp_disable.c
@@ -133,7 +133,7 @@ FIXTURE_SETUP(prctl_thp_disable_completely)
 	if (!thp_available())
 		SKIP(return, "Transparent Hugepages not available\n");
 
-	self->pmdsize = read_pmd_pagesize();
+	self->pmdsize = pmd_psize();
 	if (!self->pmdsize)
 		SKIP(return, "Unable to read PMD size\n");
 
@@ -241,7 +241,7 @@ FIXTURE_SETUP(prctl_thp_disable_except_madvise)
 	if (!thp_available())
 		SKIP(return, "Transparent Hugepages not available\n");
 
-	self->pmdsize = read_pmd_pagesize();
+	self->pmdsize = pmd_psize();
 	if (!self->pmdsize)
 		SKIP(return, "Unable to read PMD size\n");
 
diff --git a/tools/testing/selftests/mm/process_madv.c b/tools/testing/selftests/mm/process_madv.c
index 3fffd5f7e6fb..7e32bad8ab2a 100644
--- a/tools/testing/selftests/mm/process_madv.c
+++ b/tools/testing/selftests/mm/process_madv.c
@@ -141,7 +141,7 @@ TEST_F(process_madvise, remote_collapse)
 		void *map_addr;
 	} info;
 
-	huge_page_size = read_pmd_pagesize();
+	huge_page_size = pmd_psize();
 	if (huge_page_size <= 0)
 		SKIP(return, "Could not determine a valid huge page size.\n");
 
diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
index 5f278913c4d7..670fcad083b5 100644
--- a/tools/testing/selftests/mm/soft-dirty.c
+++ b/tools/testing/selftests/mm/soft-dirty.c
@@ -88,7 +88,7 @@ static void test_hugepage(int pagemap_fd, int pagesize)
 		return;
 	}
 
-	size_t hpage_len = read_pmd_pagesize();
+	size_t hpage_len = pmd_psize();
 	if (!hpage_len)
 		ksft_exit_fail_msg("Reading PMD pagesize failed");
 
diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index c01d227d7fd6..295a6769d670 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -658,7 +658,7 @@ int main(int argc, char **argv)
 
 	pagesize = getpagesize();
 	pageshift = ffs(pagesize) - 1;
-	pmd_pagesize = read_pmd_pagesize();
+	pmd_pagesize = pmd_psize();
 	if (!pmd_pagesize)
 		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
 
diff --git a/tools/testing/selftests/mm/uffd-common.c b/tools/testing/selftests/mm/uffd-common.c
index 1fb967ef4985..0b8bbb55c335 100644
--- a/tools/testing/selftests/mm/uffd-common.c
+++ b/tools/testing/selftests/mm/uffd-common.c
@@ -137,7 +137,7 @@ static void shmem_release_pages(uffd_global_test_opts_t *gopts, char *rel_area)
 static int shmem_allocate_area(uffd_global_test_opts_t *gopts, void **alloc_area, bool is_src)
 {
 	void *area_alias = NULL;
-	size_t bytes = gopts->nr_pages * gopts->page_size, hpage_size = read_pmd_pagesize();
+	size_t bytes = gopts->nr_pages * gopts->page_size, hpage_size = pmd_psize();
 	unsigned long offset = is_src ? 0 : bytes;
 	char *p = NULL, *p_alias = NULL;
 	int mem_fd = uffd_mem_fd_create(bytes * 2, false);
@@ -194,10 +194,10 @@ static void shmem_alias_mapping(uffd_global_test_opts_t *gopts, __u64 *start,
 
 static void shmem_check_pmd_mapping(uffd_global_test_opts_t *gopts, void *p, int expect_nr_hpages)
 {
-	size_t len = expect_nr_hpages * read_pmd_pagesize();
+	size_t len = expect_nr_hpages * pmd_psize();
 
 	if (!check_huge_shmem(gopts->area_dst_alias, len, expect_nr_hpages,
-			      read_pmd_pagesize()))
+			      pmd_psize()))
 		err("Did not find expected %d number of hugepages",
 		    expect_nr_hpages);
 }
diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index 6f2360f9b75d..dcb1755c35fb 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -646,7 +646,7 @@ static void uffd_minor_test_common(uffd_global_test_opts_t *gopts, bool test_col
 		uffd_test_ops->check_pmd_mapping(gopts,
 						 gopts->area_dst,
 						 gopts->nr_pages * gopts->page_size /
-						 read_pmd_pagesize());
+						 pmd_psize());
 		/*
 		 * This won't cause uffd-fault - it purely just makes sure there
 		 * was no corruption.
@@ -1975,7 +1975,7 @@ static void uffd_move_handle_fault(uffd_global_test_opts_t *gopts, struct uffd_m
 static void uffd_move_pmd_handle_fault(uffd_global_test_opts_t *gopts, struct uffd_msg *msg,
 				       struct uffd_args *args)
 {
-	uffd_move_handle_fault_common(gopts, msg, args, read_pmd_pagesize());
+	uffd_move_handle_fault_common(gopts, msg, args, pmd_psize());
 }
 
 static void
@@ -2086,7 +2086,7 @@ static void uffd_move_pmd_test(uffd_global_test_opts_t *gopts, uffd_test_args_t
 {
 	if (madvise(gopts->area_dst, gopts->nr_pages * gopts->page_size, MADV_HUGEPAGE))
 		err("madvise(MADV_HUGEPAGE) failure");
-	uffd_move_test_common(gopts, targs, read_pmd_pagesize(),
+	uffd_move_test_common(gopts, targs, pmd_psize(),
 			      uffd_move_pmd_handle_fault);
 }
 
@@ -2094,7 +2094,7 @@ static void uffd_move_pmd_split_test(uffd_global_test_opts_t *gopts, uffd_test_a
 {
 	if (madvise(gopts->area_dst, gopts->nr_pages * gopts->page_size, MADV_NOHUGEPAGE))
 		err("madvise(MADV_NOHUGEPAGE) failure");
-	uffd_move_test_common(gopts, targs, read_pmd_pagesize(),
+	uffd_move_test_common(gopts, targs, pmd_psize(),
 			      uffd_move_pmd_handle_fault);
 }
 
diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c b/tools/testing/selftests/mm/uffd-wp-mremap.c
index 572c2516e874..f46edd3ee6d8 100644
--- a/tools/testing/selftests/mm/uffd-wp-mremap.c
+++ b/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -38,7 +38,7 @@ static int detect_thp_sizes(size_t sizes[], int max)
 	int i;
 
 	/* thp not supported at all. */
-	if (!read_pmd_pagesize())
+	if (!pmd_psize())
 		return 0;
 
 	orders = thp_supported_orders();
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 4821a3563036..e712a980851c 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -155,7 +155,7 @@ bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len)
 	return false;
 }
 
-uint64_t read_pmd_pagesize(void)
+uint64_t pmd_psize(void)
 {
 	int fd;
 	char buf[20];
@@ -412,7 +412,7 @@ static bool check_large_folios(void *addr, size_t len, int nr_hpages,
 
 bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
-	uint64_t pmd_pagesize = read_pmd_pagesize();
+	uint64_t pmd_pagesize = pmd_psize();
 
 	if (!pmd_pagesize)
 		ksft_exit_fail_msg("reading PMD pagesize failed\n");
@@ -425,7 +425,7 @@ bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 
 bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
-	uint64_t pmd_pagesize = read_pmd_pagesize();
+	uint64_t pmd_pagesize = pmd_psize();
 
 	if (!pmd_pagesize)
 		ksft_exit_fail_msg("reading PMD pagesize failed\n");
@@ -438,7 +438,7 @@ bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 
 bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
-	uint64_t pmd_pagesize = read_pmd_pagesize();
+	uint64_t pmd_pagesize = pmd_psize();
 
 	if (!pmd_pagesize)
 		ksft_exit_fail_msg("reading PMD pagesize failed\n");
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 9a49af88702e..a40e40c820ef 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -88,7 +88,7 @@ bool pagemap_is_populated(int fd, char *start);
 unsigned long pagemap_get_pfn(int fd, char *start);
 void clear_softdirty(void);
 bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len);
-uint64_t read_pmd_pagesize(void);
+uint64_t pmd_psize(void);
 unsigned long rss_anon(void);
 bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
 bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);

-- 
2.43.0


