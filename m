Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66C39C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 07:30:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A9FE6B0099; Mon, 14 Sep 2026 03:30:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30D246B009B; Mon, 14 Sep 2026 03:30:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D6446B009D; Mon, 14 Sep 2026 03:30:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA2A96B0099
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:30:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 356331411CD
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:30:30 +0000 (UTC)
X-FDA: 85211545020.20.A301605
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5791840008
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:30:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NvcSnkpi;
	spf=pass (imf17.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789371028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LhAURySZ5WHhPZPaaV+18VRFRV9Xwpt897K1+X4Nx2w=;
	b=8byuoGbHjo0Akgb0mr/KnNX7tpnW+vIDGKmqB39yPkeeJg3Rhz/nYqU8/ESmIdValPzqiA
	B+iSiBZ8nM6QD1uzA/SGaDCpjCtBjrzS6RuzCqS4rsseiqFzS0JufHJWqeQ8vkB+AakWtO
	qX6PvbiDDaNijDHhf2wmP2Fb3gd5ulk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NvcSnkpi;
	spf=pass (imf17.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789371028;
	b=ng1XQ9ceHczmjcysH+pAm2VRsBuJ+d6NhGFDK+K8k+/QN9rOW2A8iDumaeBk2t+5j9v13i
	vLYPT+53UVVxfkW3WDwUtNlFPWh0YBnXbV3zjbiBoL0Bs0aLdODepwM27hUZif8DFm35Sk
	bcXhLFdP+AhIxhZ8UTGMbF1WDo1T7xQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A0BCA1570;
	Mon, 14 Sep 2026 00:30:23 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 588643F59E;
	Mon, 14 Sep 2026 00:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789371027; bh=wGlC3x6B+YeFTS+wPx/ip9iVJG9tdNzDpN4kixOrAIQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=NvcSnkpiOzF72v/07UYMdPehxnJeUKin6ttYal8MsITdvJjQ09dpHZcsf9B80kbT8
	 w52N6LhIelNn5QWYDiBFnEYYMNFWY4q5rgakE0bs/Eg7zaErXTs7APWrn2VQJPBbDZ
	 HEBnzKqQLY252EDYOjov593XLiM7ZFf46564FwA8=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 14 Sep 2026 08:30:12 +0100
Subject: [PATCH v6 3/3] kselftest: mm: remove check_huge_shmem()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260914-fix_split-v6-3-16ed7123800b@arm.com>
References: <20260914-fix_split-v6-0-16ed7123800b@arm.com>
In-Reply-To: <20260914-fix_split-v6-0-16ed7123800b@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5763; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=wGlC3x6B+YeFTS+wPx/ip9iVJG9tdNzDpN4kixOrAIQ=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqp6KFnDSPIySJuA1qhfL4+Y+ej5BNPPQFp/TfE
 moVKbr0hJWJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCaqeihQAKCRBt1cPRWsUx
 M3+eC/wN0LE1QiKBQiXu3bsjAMd7q2V3+BzmLi6SweD3okNMFuud5JNtkA3pT3d43XhuYEad3TD
 E4sHuD0y7GNWa7srSMT1U4pZv798dzi/wPiddVeNMUE5yLZWajm+z732ShV2FBmRiyIG+r6+2uV
 T/faG0bqjk5xkTM3Z20OrxZTv2bfBEsogdg01zzgHG1JxFsc8bdxaKzh0tPOcsGwwL3waAUd2Nd
 UCtyEBjZlZ1bCU9PFM3PJiveZjcKSOf++h+v5Xn3mOzflx6S9WE7nyXMN3SkZYf6WYUNFeWiknp
 UfAcrANMHe0/eUKh+dlHTb1ZjeAUHlvEA3DJxGYvP9JCE0oSUeuAntWyRSsb5a1HlCL/OhhH2aD
 sPU715QWjY0zY61kFV8KfsgOnXqBMiH3Tqv2t6wQ5U0WJFgBc3otCzLAqljY+QuuyS83XV6Rlyo
 1p+1DeSpge9l03m2p/ICge8rZPk4lL8yRaUKvBUsW0G94KU/6F+ejuNdK72mpNzsIOucQ=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5791840008
X-Stat-Signature: kyg81gtw4thyrgdnm75u1xnprotqgmrd
X-Rspam-User: 
X-HE-Tag: 1789371028-980028
X-HE-Meta: U2FsdGVkX1/HXSw9BjDR20kJ0Af3fuprytOwidvlle6so1x4n4sQ1ixYju1vhpr+dZe9HmjQBwJCVnvgvXqHa6NGbhqaUsAXPVe9V/5bqV8QvrI54Nob46zUdZ7y0uj3asNSsiOewPjA323WhKjraLLW5LlBlvCpEHZVWL4UH75hRM4yzPEAWlmfdA53W8HnkgFwstM/66BCVutu4bNMjsQgpiKUw50zKssLv3p23xbMVCIsYW6yG+fgHGkL9nfvRcW/OiVWh9ObIhUfh6diy2MBF3hX2804ZtqAk05Ij+UYbZ74GkLZRkBQoyQtuQUThctwYp3p1odnmbm/tY8yR0cpGm4iMdNrIHirAH5xAyozJ2MJMr0kL6bqAP+ESfTIcLMnn+jlC0WjUot0c3GtJw68OVQrQaumL1C92yrnI0nJC7io2CRV3EdmGurasWuXN9vGpBKfnjEAEYZp/sEprzfXNZrwMTS7ocjrjvVUjQiCPGH1QCWoaqZM5KB6rp/Mgy5uT78SJi+1/bR7QFb0HDuRlppE0M9UahT67h5B+N7LkVhlhto8zBe7i4GuJSsYS2MoJh80qTdT/vpNXtbywecYW0Apz6bEbsaEGIM9aT4cyx2LONczjyXrn/SWMSHUrdvM+zg25OBbtIE5Dp5CQr1vP1i0STmaQLZXZgUNduBsY5sFluVs3oLzNlM6bUQAjb1q0BAzIe0kznVVtcRmGqet2lL9lEUrCrDaQUkEaG38XXJxxE++xQFwd0YZtC5GkluKbBmYie123gZXSq01Cki6RzpdLPEG9rUXYc5gAPDILDe3fAsWZG3JPBZvnopac2NampUryaynUXKIiRRx1ykW0Ft7rABRsAepqL4ZlK6q22/1sig40bm5Y8Atb3eFPGDf/oS4U7shAD9IgQvfxhZqbNek3NhEwxGyr9Bnj65ZSM6fGvpxdD9WW/4sT5C3M3+PlVD3ZMibvd1U+VV
 xkmLstp4
 Z0DLCqzOIKwLDfYr2+RXhuIe/wVRb1Qzh3l4qQBd1T8hECGRcaA8Udwtwvn4orhAh4KWZZvPeIvPZnGLlJD2e67GxbkdrbG4FcHQSQPhPE4Puhc58uVizE58hmex78wofDW0fX4Gyz49z3apOaBOJJLPRsO2WKoCvw8wv1XyFnutnvY6o9RORAB6a7zaJKfPxY4hsgdBkpbHhRGmsacKJVWAXZLxVQcZeVhuTR+FS38UfY3DdIsBLyviZe/d+EyPWj6TWsy2Std/KXbiefeEy/0GBnaeoBHUpdXJMz6hkzrGWDP6FyfpUGgUpjEBIpifU6DFE0QMNQsF/W3r6OK4uPcHnUf2UT3hD0DHr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

check_huge_shmem() was required to distinguish shmem huge pages because
/proc/self/smaps reports them using a dedicated “ShmemPmdMapped” entry,
as opposed to “FilePmdMapped” for file-backed huge pages.

Now that /proc/self/smaps is no longer used to detect huge pages and
/proc/kpageflags is used instead, it is sufficient to distinguish
between file-backed and anonymous pages since the ShmemPmdMapped is also
kind of file-backed.

Therefore, remove check_huge_shmem() and use check_huge_file() instead.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/folio_split_race_test.c |  2 +-
 tools/testing/selftests/mm/khugepaged.c            |  5 ++---
 tools/testing/selftests/mm/uffd-common.c           |  4 ++--
 tools/testing/selftests/mm/vm_util.c               | 11 +----------
 tools/testing/selftests/mm/vm_util.h               |  2 --
 5 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/mm/folio_split_race_test.c b/tools/testing/selftests/mm/folio_split_race_test.c
index 1960635a953e..4c0d3b6a411b 100644
--- a/tools/testing/selftests/mm/folio_split_race_test.c
+++ b/tools/testing/selftests/mm/folio_split_race_test.c
@@ -182,7 +182,7 @@ static uint64_t run_iteration(void)
 	for (i = 0; i < TOTAL_PAGES; i++)
 		fill_page(mmap_base, i);
 
-	if (!check_huge_shmem(mmap_base, FILE_SIZE, NR_PMD_PAGE, pmd_pagesize))
+	if (!check_huge_file(mmap_base, FILE_SIZE, NR_PMD_PAGE, pmd_pagesize))
 		ksft_exit_fail_msg("No shmem THP is allocated\n");
 
 	if (pthread_barrier_init(&ctl.barrier, NULL, NUM_READER_THREADS + 1) != 0)
diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index f82673f5f6b4..6cd1effea465 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -416,9 +416,8 @@ static bool file_check_huge(void *addr, size_t len, int nr_hpages,
 {
 	switch (finfo.type) {
 	case VMA_FILE:
-		return check_huge_file(addr, len, nr_hpages, hpage_size);
 	case VMA_SHMEM:
-		return check_huge_shmem(addr, len, nr_hpages, hpage_size);
+		return check_huge_file(addr, len, nr_hpages, hpage_size);
 	default:
 		ksft_exit_fail_msg("Unknown VMA type\n");
 		return false;
@@ -451,7 +450,7 @@ static void shmem_cleanup_area(void *p, unsigned long size)
 static bool shmem_check_huge(void *addr, size_t len, int nr_hpages,
 		unsigned long hpage_size)
 {
-	return check_huge_shmem(addr, len, nr_hpages, hpage_size);
+	return check_huge_file(addr, len, nr_hpages, hpage_size);
 }
 
 static struct mem_ops __anon_ops = {
diff --git a/tools/testing/selftests/mm/uffd-common.c b/tools/testing/selftests/mm/uffd-common.c
index 1fb967ef4985..a76851aced4d 100644
--- a/tools/testing/selftests/mm/uffd-common.c
+++ b/tools/testing/selftests/mm/uffd-common.c
@@ -196,8 +196,8 @@ static void shmem_check_pmd_mapping(uffd_global_test_opts_t *gopts, void *p, int
 {
 	size_t len = expect_nr_hpages * read_pmd_pagesize();
 
-	if (!check_huge_shmem(gopts->area_dst_alias, len, expect_nr_hpages,
-			      read_pmd_pagesize()))
+	if (!check_huge_file(gopts->area_dst_alias, len, expect_nr_hpages,
+			     read_pmd_pagesize()))
 		err("Did not find expected %d number of hugepages",
 		    expect_nr_hpages);
 }
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 98f110098179..e31e88d5af76 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -384,22 +384,18 @@ static bool check_large_folios(int pagemap_fd, int kpageflags_fd,
 enum check_huge_type {
 	CHECK_HUGE_ANON,
 	CHECK_HUGE_FILE,
-	CHECK_HUGE_SHMEM,
 };
 
 static bool check_huge_type(uint64_t categories, uint64_t kpageflags,
 			    enum check_huge_type type)
 {
 	const bool file = categories & PAGE_IS_FILE;
-	const bool swapbacked = kpageflags & KPF_SWAPBACKED;
 
 	switch (type) {
 	case CHECK_HUGE_ANON:
 		return !file;
 	case CHECK_HUGE_FILE:
-		return file && !swapbacked;
-	case CHECK_HUGE_SHMEM:
-		return file && swapbacked;
+		return file;
 	}
 
 	return false;
@@ -479,11 +475,6 @@ bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 	return __check_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_FILE);
 }
 
-bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
-{
-	return __check_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_SHMEM);
-}
-
 int64_t allocate_transhuge(void *ptr, int pagemap_fd)
 {
 	uint64_t ent[2];
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index f19bd17817e5..fc9c93235f6f 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -18,7 +18,6 @@
 #define PM_SWAP                       BIT_ULL(62)
 #define PM_PRESENT                    BIT_ULL(63)
 
-#define KPF_SWAPBACKED                BIT_ULL(14)
 #define KPF_COMPOUND_HEAD             BIT_ULL(15)
 #define KPF_COMPOUND_TAIL             BIT_ULL(16)
 #define KPF_HWPOISON                  BIT_ULL(19)
@@ -93,7 +92,6 @@ uint64_t read_pmd_pagesize(void);
 unsigned long rss_anon(void);
 bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
 bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
-bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
 int64_t allocate_transhuge(void *ptr, int pagemap_fd);
 int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags);
 int gather_folio_orders(char *vaddr_start, size_t len,

-- 
2.43.0


