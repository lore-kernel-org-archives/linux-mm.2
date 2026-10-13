Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38B42CC6B08
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 09:46:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F6796B0095; Tue, 13 Oct 2026 05:46:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A62F6B0096; Tue, 13 Oct 2026 05:46:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BBFC6B0098; Tue, 13 Oct 2026 05:46:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F1AF16B0095
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 05:46:25 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 90989A03FE
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:46:25 +0000 (UTC)
X-FDA: 85317122730.23.BA8B74E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 94CC1C0002
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:46:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ugdsmx2q;
	spf=pass (imf22.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791884783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OLnq1M6AckAFySB7HzikbvpHrsVmG9d1P20GUM3BrFo=;
	b=A+tIrNmoJUZoAM5KMt1c3Z50li58zOoqkaQYDDNBegC7fw9gF5W0SqxOLcj6iag7sAgfuf
	AfEoEu1XVs5/5CxZznrgeX+kday3jxsiVZrHP6ZFobRNNO/ViFA+i5KKddYNQI2xouatub
	XpqZcGp8+19INIv1csdKtQfRs9agTmY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791884783;
	b=Hg38Utc65LvfR9QttTl6nhY/mm5KqE8vW1+rG5qv1Hi22ppDYUAClFdAsCTidiDNw0hsrB
	WvRGdQAj7M0wN+5iGfOI+6FVYuydmGd+SWyfNX0Uuj6oTRfvNdRrjz8OYdx/C3mfNoaUWR
	kUIry3Ye5tQUeGYs4CxLpftBY7FS4Tc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ugdsmx2q;
	spf=pass (imf22.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B138169E;
	Tue, 13 Oct 2026 02:46:19 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1B5583F7B4;
	Tue, 13 Oct 2026 02:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791884782; bh=zbamoNJ0ms9ZXl07nI6edvQZrBl9osLOl0HsQG9WpAA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ugdsmx2qq0KbxmWJWwQ3HYH5jBimPvE2cNxru13CTEi8831lwvziKJMtvta2GB5z2
	 o2c2xmmTZXB0FgV2zV5Vc/Cq0Bsmw/TVTqqYLmlyXzyqrTU4A2+5IXvvYEmKYqTwRb
	 DCN8isQkNy8RklrpBEuHKAWVZfmRYbkG9UTrXR7M=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Tue, 13 Oct 2026 10:46:04 +0100
Subject: [PATCH v6 1/3] kselftest: mm: rename read_pmd_pagesize() to
 pmd_psize()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-fix_hpage_macro-v6-1-2c52d0484de3@arm.com>
References: <20261013-fix_hpage_macro-v6-0-2c52d0484de3@arm.com>
In-Reply-To: <20261013-fix_hpage_macro-v6-0-2c52d0484de3@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=16797; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=zbamoNJ0ms9ZXl07nI6edvQZrBl9osLOl0HsQG9WpAA=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqzf3leTZ1SWxufkCog8DoTFIUCYxNYUtcYOK3d
 B9U1qWaPoiJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCas395QAKCRBt1cPRWsUx
 M0mXC/9RZgw+7qto/fomA49eyVb3uV9fg974FTypwTE6b0QZyEkegtjQES6nn+XbWKNV9eUGJrN
 VMd6M/E7cN/k7TXm0RWsU1kcFOXXED5IqQKOOHJJjKcdjGTCeS7qrsyktYqhGV0+ybnO0Q+3e3U
 B5JdEeznltfzgFMasEGxFdgs/tDq5+ElYO99kvdDvC8kqAiFDUutER9NrhRqSrAKG81rVamMB5N
 LgTeHWllFRjebh+KU604MaXJhhVMQC8I+ZCi8hkK0l3IuEEGG4AhpOuhtDs0NalYkmYsAWjSjYZ
 xEBLzNjO0gkSu82ig7J5X/yMblKaq9ldDcZCah/D2EtuBBL1flQqLDDB6xvoKl3xbNe3DnFshe2
 SCm4AyaPEkdiNjO5exIoONuSioDxy+7/s2UGFXR3YtpqclZ4s/pAX2oSn36h5LkO6Mmkkz+kaMX
 RQZm2bnpZu051WwoQaWyPg2YvMdW6rBk1spyrK5otKIOTtGgdhG8hqKax7upfJWcWlprg=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Queue-Id: 94CC1C0002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: x14kii8b8d6fauqhbxyre17qemirbfit
X-HE-Tag: 1791884783-15066
X-HE-Meta: U2FsdGVkX192xft5JmWf4I38TsPEctwuYWGNeIoEZdtMafI2OBkLCYksn+Y7Qy9hIA7jHPM9TCpQcB7puXIKlEZBvjmoqYfNB2cDporwMhvLQ7VRLut7gR6xEo7IU79DrFfEVHx9nupvnXjVJ0aGMYej6Oj578Wr+/vccEnr8wo7FHlFd+5CDheIvFtcwmNOpqgmuSQ7QDGsUhGshIadmfNAiUXXea02oRxZhtcmeoi9wdUGrjjzLzu25ryASrkILlnHmrhlQO7TUM+1vFXQDFfqrrnJZvTquZpMZ8c6cuby6wHgVEcNNfoizioW47XuY8Jw8reMfl/eUTkHpOulz06ZvdG4GfhMJ1PTvr3cNyoIX6F7IsseJS8NH6CEkOwhiyf2rHMlUxW12kEEKODY5HOUV7gyF0O9jxelk8O1v5d2sT/P6oYhlLfB0S7omRp9LhpfPakIF1QgCSAz8/zlJxZYeuqgVj8Hs+88+47xRtyByHKX+aNF2HRLHM8xg5aYJfeFTXmee7jFIhZ1yOVuluz208xaZep3eRKckauEJjUh8POwAHDs/hzExgs+N4HtZmwDCFNdu7VDQKKk8Gvbfg27snGgXZxBD9BHS2CIq0620kEaEm6wgbdWosS1Vect7YieKTNX5C66nVWJsGz9zty4ndJSSMaKnJ8M9s59+1FcAF3YydBXfrfRjd8B86EVocgMoDoEtX4fBI0j9XZFb5wBAS4eR5NyW2XusuLBW0X95RY1aN94R++vDhLe5qN5WiZqSAQVUi2FkOCwogRKG4FmCnLrKQPCmNo5Y7kPRjaDvCCuBvligUcRAyMLYBEVfyhC2IpBSLBrNQC7uyoAu67M1/AmSGnVjI75LA4hbeAdaCc3rCIbMkjnF0M3kzDyStGQEYf2VDoebbpq57hn0vDin/0jmV1cseOCc3aieMqLHep0QCZemLhzAO79QrYpEEI9O6jxOrAhPyucTiC
 Rua66b+L
 1aZj0HVORQXFlERHH8sMsxkuA7Szv0fGu31HVi/S/dWCxQjqsiDvdhKg/EKcGn2U+coNRVEo/EwBdBTRWJuGTO9E1R/ujSAvE0C9EzbNgtVr4cIzORFwooXFL3HU91d+vlt2O7y0vPPxqrSL4r1Tz9/VwmdogyCOqPNxToIO52qNgUGRqoY/ww4O6HCX7z90lc8BcYC7WZfOemkNI70SCZebjxZbsHjNNw7ZJSXsnIAX9KuhtB5w0cljDDSfzLkHJqKwuGYtuvxN7jZWzcOimSWDp8RSGGgxSIB0v7qLIG3tZs0sxKM1sVIgiWg60m4VnxArxYndPTfnbfBB76kbNp6HnQakdYQ5r63rW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For consistency with psize(), rename read_pmd_pagesize() to
pmd_psize(). There is no functional change.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/cow.c                   |  2 +-
 tools/testing/selftests/mm/folio_split_race_test.c |  2 +-
 tools/testing/selftests/mm/hmm-tests.c             | 22 +++++++++++-----------
 tools/testing/selftests/mm/khugepaged.c            |  2 +-
 tools/testing/selftests/mm/khugepaged_race.c       |  2 +-
 tools/testing/selftests/mm/khugepaged_sync_check.c |  2 +-
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
 tools/testing/selftests/mm/vm_util.c               |  4 ++--
 tools/testing/selftests/mm/vm_util.h               |  2 +-
 18 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index 3264a828575bd..c8c26b26ff629 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -1888,7 +1888,7 @@ int main(int argc, char **argv)
 	thp_save_settings();
 
 	pagesize = getpagesize();
-	pmdsize = read_pmd_pagesize();
+	pmdsize = pmd_psize();
 	if (pmdsize) {
 		/* Only if THP is supported. */
 		thp_read_settings(&default_settings);
diff --git a/tools/testing/selftests/mm/folio_split_race_test.c b/tools/testing/selftests/mm/folio_split_race_test.c
index 1a9840b73e618..4aa173bffa89a 100644
--- a/tools/testing/selftests/mm/folio_split_race_test.c
+++ b/tools/testing/selftests/mm/folio_split_race_test.c
@@ -234,7 +234,7 @@ int main(void)
 	ksft_print_header();
 
 	page_size = getpagesize();
-	pmd_pagesize = read_pmd_pagesize();
+	pmd_pagesize = pmd_psize();
 
 	if (!thp_available() || !pmd_pagesize)
 		ksft_exit_skip("Transparent Hugepages not available\n");
diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index e5f273ca84c10..02bec1ee54e14 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -568,7 +568,7 @@ TEST_F(hmm, anon_write_child)
 
 	for (migrate = 0; migrate < 2; ++migrate) {
 		for (use_thp = 0; use_thp < 2; ++use_thp) {
-			npages = ALIGN(use_thp ? read_pmd_pagesize() : HMM_BUFFER_SIZE,
+			npages = ALIGN(use_thp ? pmd_psize() : HMM_BUFFER_SIZE,
 				       self->page_size) >> self->page_shift;
 			ASSERT_NE(npages, 0);
 			size = npages << self->page_shift;
@@ -729,7 +729,7 @@ TEST_F(hmm, anon_write_huge)
 	int *ptr;
 	int ret;
 
-	size = 2 * read_pmd_pagesize();
+	size = 2 * pmd_psize();
 
 	buffer = hmm_buffer_alloc(size, size,
 				  PROT_READ | PROT_WRITE,
@@ -1940,7 +1940,7 @@ TEST_F(hmm, migrate_anon_huge_empty)
 	int *ptr;
 	int ret;
 
-	size = read_pmd_pagesize();
+	size = pmd_psize();
 
 	buffer = hmm_buffer_alloc(2 * size, size,
 				  PROT_READ,
@@ -1983,7 +1983,7 @@ TEST_F(hmm, migrate_anon_huge_zero)
 	int ret;
 	int val;
 
-	size = read_pmd_pagesize();
+	size = pmd_psize();
 
 	buffer = hmm_buffer_alloc(2 * size, size,
 				  PROT_READ,
@@ -2037,7 +2037,7 @@ TEST_F(hmm, migrate_anon_huge_free)
 	int *ptr;
 	int ret;
 
-	size = read_pmd_pagesize();
+	size = pmd_psize();
 
 	buffer = hmm_buffer_alloc(2 * size, size,
 				  PROT_READ | PROT_WRITE,
@@ -2090,7 +2090,7 @@ TEST_F(hmm, migrate_anon_huge_fault)
 	int *ptr;
 	int ret;
 
-	size = read_pmd_pagesize();
+	size = pmd_psize();
 
 	buffer = hmm_buffer_alloc(2 * size, size,
 				  PROT_READ | PROT_WRITE,
@@ -2160,7 +2160,7 @@ TEST_F(hmm, migrate_partial_unmap_fault)
 {
 	struct hmm_buffer *buffer;
 	unsigned long npages;
-	unsigned long size = read_pmd_pagesize();
+	unsigned long size = pmd_psize();
 	unsigned long unmap_size;
 	unsigned long offsets[3];
 	unsigned long i;
@@ -2225,7 +2225,7 @@ TEST_F(hmm, migrate_remap_fault)
 {
 	struct hmm_buffer *buffer;
 	unsigned long npages;
-	unsigned long size = read_pmd_pagesize();
+	unsigned long size = pmd_psize();
 	unsigned long offsets[3];
 	unsigned long i;
 	void *old_ptr, *new_ptr = NULL;
@@ -2322,7 +2322,7 @@ TEST_F(hmm, migrate_anon_huge_err)
 	int *ptr;
 	int ret;
 
-	size = read_pmd_pagesize();
+	size = pmd_psize();
 
 	buffer = hmm_buffer_alloc(2 * size, 2 * size,
 				  PROT_READ | PROT_WRITE,
@@ -2412,7 +2412,7 @@ TEST_F(hmm, migrate_anon_huge_zero_err)
 	int *ptr;
 	int ret;
 
-	size = read_pmd_pagesize();
+	size = pmd_psize();
 
 	buffer = hmm_buffer_alloc(2 * size, 2 * size,
 				  PROT_READ,
@@ -2608,7 +2608,7 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
 TEST_F_TIMEOUT(hmm, benchmark_thp_migration, 120)
 {
 	struct benchmark_results thp_results, regular_results;
-	size_t thp_size = read_pmd_pagesize();
+	size_t thp_size = pmd_psize();
 	int iterations = 5;
 
 	if (!thp_size)
diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 1bc7acc66a469..195adb1875e5e 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1684,7 +1684,7 @@ int main(int argc, char **argv)
 		ksft_exit_skip("Transparent Hugepages not available\n");
 
 	page_size = getpagesize();
-	hpage_pmd_size = read_pmd_pagesize();
+	hpage_pmd_size = pmd_psize();
 	if (!hpage_pmd_size)
 		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
 	hpage_pmd_nr = hpage_pmd_size / page_size;
diff --git a/tools/testing/selftests/mm/khugepaged_race.c b/tools/testing/selftests/mm/khugepaged_race.c
index abb0678522cd9..6cd68cda07624 100644
--- a/tools/testing/selftests/mm/khugepaged_race.c
+++ b/tools/testing/selftests/mm/khugepaged_race.c
@@ -371,7 +371,7 @@ int main(int argc, char **argv)
 		ksft_exit_skip("Transparent Hugepages not available\n");
 
 	page_size = getpagesize();
-	hpage_pmd_size = read_pmd_pagesize();
+	hpage_pmd_size = pmd_psize();
 	if (!hpage_pmd_size)
 		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
 
diff --git a/tools/testing/selftests/mm/khugepaged_sync_check.c b/tools/testing/selftests/mm/khugepaged_sync_check.c
index 28a9b1ff5d447..f31b0987d90c3 100644
--- a/tools/testing/selftests/mm/khugepaged_sync_check.c
+++ b/tools/testing/selftests/mm/khugepaged_sync_check.c
@@ -140,7 +140,7 @@ int main(void)
 		ksft_exit_skip("Order %d is not a supported anon THP order\n",
 			       TARGET_ORDER);
 
-	hpage_pmd_size = read_pmd_pagesize();
+	hpage_pmd_size = pmd_psize();
 	if (!hpage_pmd_size)
 		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
 	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
index d1d0989ed2cad..f268751736740 100644
--- a/tools/testing/selftests/mm/migration.c
+++ b/tools/testing/selftests/mm/migration.c
@@ -228,7 +228,7 @@ TEST_F_TIMEOUT(migration, private_anon_thp, 2*RUNTIME)
 	if (!thp_is_enabled())
 		SKIP(return, "Transparent Hugepages not available");
 
-	pmdsize = read_pmd_pagesize();
+	pmdsize = pmd_psize();
 	if (!pmdsize)
 		SKIP(return, "Reading PMD pagesize failed");
 
@@ -262,7 +262,7 @@ TEST_F_TIMEOUT(migration, shared_anon_thp, 2*RUNTIME)
 	if (!thp_is_enabled())
 		SKIP(return, "Transparent Hugepages not available");
 
-	pmdsize = read_pmd_pagesize();
+	pmdsize = pmd_psize();
 	if (!pmdsize)
 		SKIP(return, "Reading PMD pagesize failed");
 
diff --git a/tools/testing/selftests/mm/mkdirty.c b/tools/testing/selftests/mm/mkdirty.c
index 68dd447a54542..49ef643a6e639 100644
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
index 03898b4f6cdab..e9718716feabc 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1653,7 +1653,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
 	ksft_print_header();
 
 	page_size = getpagesize();
-	hpage_size = read_pmd_pagesize();
+	hpage_size = pmd_psize();
 
 	if (init_uffd())
 		ksft_exit_skip("Failed to initialize userfaultfd\n");
diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
index f9ec1408a6e30..5b7fc68a4072c 100644
--- a/tools/testing/selftests/mm/prctl_thp_disable.c
+++ b/tools/testing/selftests/mm/prctl_thp_disable.c
@@ -132,7 +132,7 @@ FIXTURE_SETUP(prctl_thp_disable_completely)
 	if (!thp_available())
 		SKIP(return, "Transparent Hugepages not available\n");
 
-	self->pmdsize = read_pmd_pagesize();
+	self->pmdsize = pmd_psize();
 	if (!self->pmdsize)
 		SKIP(return, "Unable to read PMD size\n");
 
@@ -240,7 +240,7 @@ FIXTURE_SETUP(prctl_thp_disable_except_madvise)
 	if (!thp_available())
 		SKIP(return, "Transparent Hugepages not available\n");
 
-	self->pmdsize = read_pmd_pagesize();
+	self->pmdsize = pmd_psize();
 	if (!self->pmdsize)
 		SKIP(return, "Unable to read PMD size\n");
 
diff --git a/tools/testing/selftests/mm/process_madv.c b/tools/testing/selftests/mm/process_madv.c
index 3fffd5f7e6fb4..7e32bad8ab2a9 100644
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
index 7f649b6733553..e6fe4259b6f4d 100644
--- a/tools/testing/selftests/mm/soft-dirty.c
+++ b/tools/testing/selftests/mm/soft-dirty.c
@@ -87,7 +87,7 @@ static void test_hugepage(int pagemap_fd, int pagesize)
 		return;
 	}
 
-	size_t hpage_len = read_pmd_pagesize();
+	size_t hpage_len = pmd_psize();
 	if (!hpage_len)
 		ksft_exit_fail_msg("Reading PMD pagesize failed");
 
diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 36a6719ff09a8..33a2473327bb7 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -615,7 +615,7 @@ int main(int argc, char **argv)
 
 	pagesize = getpagesize();
 	pageshift = ffs(pagesize) - 1;
-	pmd_pagesize = read_pmd_pagesize();
+	pmd_pagesize = pmd_psize();
 	if (!pmd_pagesize)
 		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
 
diff --git a/tools/testing/selftests/mm/uffd-common.c b/tools/testing/selftests/mm/uffd-common.c
index a76851aced4d0..d5882fc392f0b 100644
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
 
 	if (!check_huge_file(gopts->area_dst_alias, len, expect_nr_hpages,
-			     read_pmd_pagesize()))
+			     pmd_psize()))
 		err("Did not find expected %d number of hugepages",
 		    expect_nr_hpages);
 }
diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index 2a97ba1d6feb1..298609544445e 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -588,7 +588,7 @@ static void uffd_minor_test_common(uffd_global_test_opts_t *gopts, bool test_col
 		uffd_test_ops->check_pmd_mapping(gopts,
 						 gopts->area_dst,
 						 gopts->nr_pages * gopts->page_size /
-						 read_pmd_pagesize());
+						 pmd_psize());
 		/*
 		 * This won't cause uffd-fault - it purely just makes sure there
 		 * was no corruption.
@@ -1914,7 +1914,7 @@ static void uffd_move_handle_fault(uffd_global_test_opts_t *gopts, struct uffd_m
 static void uffd_move_pmd_handle_fault(uffd_global_test_opts_t *gopts, struct uffd_msg *msg,
 				       struct uffd_args *args)
 {
-	uffd_move_handle_fault_common(gopts, msg, args, read_pmd_pagesize());
+	uffd_move_handle_fault_common(gopts, msg, args, pmd_psize());
 }
 
 static void
@@ -2030,7 +2030,7 @@ static void uffd_move_pmd_test(uffd_global_test_opts_t *gopts, uffd_test_args_t
 {
 	if (madvise(gopts->area_dst, gopts->nr_pages * gopts->page_size, MADV_HUGEPAGE))
 		err("madvise(MADV_HUGEPAGE) failure");
-	uffd_move_test_common(gopts, targs, read_pmd_pagesize(),
+	uffd_move_test_common(gopts, targs, pmd_psize(),
 			      uffd_move_pmd_handle_fault);
 }
 
@@ -2038,7 +2038,7 @@ static void uffd_move_pmd_split_test(uffd_global_test_opts_t *gopts, uffd_test_a
 {
 	if (madvise(gopts->area_dst, gopts->nr_pages * gopts->page_size, MADV_NOHUGEPAGE))
 		err("madvise(MADV_NOHUGEPAGE) failure");
-	uffd_move_test_common(gopts, targs, read_pmd_pagesize(),
+	uffd_move_test_common(gopts, targs, pmd_psize(),
 			      uffd_move_pmd_handle_fault);
 }
 
diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c b/tools/testing/selftests/mm/uffd-wp-mremap.c
index c48eaab8e75cf..15cff68c59a22 100644
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
index 515031b8283da..5f2fb5b819c4a 100644
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
@@ -437,7 +437,7 @@ static bool __check_huge(void *addr, size_t len, int nr_hpages,
 	char *start = addr;
 	char *end = start + len;
 
-	pmd_pagesize = read_pmd_pagesize();
+	pmd_pagesize = pmd_psize();
 	if (!pmd_pagesize)
 		ksft_exit_fail_msg("reading PMD pagesize failed\n");
 
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index b5d59729d4327..29d34980df36a 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -92,7 +92,7 @@ bool pagemap_is_populated(int fd, char *start);
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


