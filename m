Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3FCDC9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 19:11:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10D106B0096; Thu, 24 Sep 2026 15:11:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BED56B0098; Thu, 24 Sep 2026 15:11:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E52896B0099; Thu, 24 Sep 2026 15:11:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B62246B0096
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:11:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 27AEA40454
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 19:11:47 +0000 (UTC)
X-FDA: 85249600254.07.2991D96
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2FC5F140006
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 19:11:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=eV3bZfMr;
	spf=pass (imf09.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790277105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vXy3giDmFd1mpjVovzH1Ji8JFcbrRLf3noPlGrGzrHI=;
	b=QRDIq5YxqKHYHsEGNBNgOcg8ADpu2yR5CYMDmyZTQTxuyaXkjJWutU1775pIWvfyngj1Cd
	4ZFOJ6VFKHHuL5zXh382CljNHsU+P6f9/Pt1VrhZalpXJlP8IOG59BgLreFG/9ImsUAbDf
	GvnWxZsKYabIrkIWf4kQuy8zqkLS598=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=eV3bZfMr;
	spf=pass (imf09.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790277105;
	b=cEQFUeoiNAzF+v7qDXrhARTHFrn55H+7ZK7PehcMV3jSbEwvnd7KDfaFJOHWmEmCynSvhb
	R8RHWXzJTvrl8sHmuHGSqyej16+gUl2UrFQIylFQbJWswPXFMAI5FjdSER7t4UgqZ9lpuD
	nh4EpFqI2JFpW34LazD7w0TBdg6TjFA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C74511EA6;
	Thu, 24 Sep 2026 12:11:40 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EF9D63F86F;
	Thu, 24 Sep 2026 12:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790277104; bh=g3AhOUqfUFRDC8KW+TFZcN4eqAIWIuTzDwCjFRxwO7U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=eV3bZfMr8N5DtL4R4+zm/kgood6J/egHPdyIW7Mu7W7490GvTmwQv2ogFYif42fEv
	 g7ZKemF5kKNsDqEQk4Q3xazuZ7XAcQ9Q5qtx9jMs8q1x/hQFureb93zsNsJT1DXg2q
	 /Tq4/EZ3ptEdIYexJngZK57m3sSx0/kiWP6kp4dI=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Thu, 24 Sep 2026 20:11:19 +0100
Subject: [PATCH v8 4/4] kselftest: mm: remove check_huge_shmem()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260924-fix_split-v8-4-cba7359d882a@arm.com>
References: <20260924-fix_split-v8-0-cba7359d882a@arm.com>
In-Reply-To: <20260924-fix_split-v8-0-cba7359d882a@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7410; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=g3AhOUqfUFRDC8KW+TFZcN4eqAIWIuTzDwCjFRxwO7U=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqtXXdRG/ZRP34qhtVmLPDZhRSrGb+H+F+e/i8n
 jEdR9g5IeCJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarV13QAKCRBt1cPRWsUx
 MwOYC/9vRpci1QI5FsM/WJwnN7ZWxWHc/mjdn1hZusyRlx03RGyrjLFLeQjEgzE6ZSFczbjGdOv
 gWW2P604/+MdOh1Xb6PQPZCH1O2xzql7JaE9EBlU9qRzVKCARbmyMZGZ3GaHGOF6uN7RSpNPbks
 UrxAlTSG7TuVscxbxS0c0y21c+b18Qx4p519OC60Uwh4uHQEFU4hTOODNLjBtC3XqtlK4oXHP5Q
 rTdZPM/M04KQAmbdgro6/UNnQ5I5+DspzRPdimw1yAAww72TSoZ2ZsEpqh5stJzmE+7xRZm5kaH
 Iwa7vqvF8QtftBKKsTtsqg5Ugq6dhbbmDTDqFlTSmRhH3rtcEGS2D/dtQmht8d4I0bwY07+DGY8
 EjMeJqidjTnkl5u2sJ0qVewmNAZfTQNXB8LCaYau1oLIUa7lVaYIklF9cYsw0/idXBoGa5QIoE4
 aCq8N5CTzeAthmIPJ53RO/qg/q6FoZB+ljdQf0M/XkiY17b9sA4C64kaoCs7QTcVOEdVw=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2FC5F140006
X-Stat-Signature: 5e8yn5uspj3cdbpgswprogq8sf7c4i8h
X-Rspam-User: 
X-HE-Tag: 1790277105-609884
X-HE-Meta: U2FsdGVkX1/M1ClAqlTylhHMvKBXI0bJNwfx5QA/2uxd6HqUjDDMS3soY4SGScFyi8RY9GzWV7QdItHkpzPF1rHgFZRLqLoJ/j/0MDNAvxigDXS7TbeGzWmwaFWBDiY0xBMFSlJ4o5qjdx1ZKsyMBxOVopZCGWfn/HclXt7KxPgVTn5BuHGc+o0PuQ/c5lFfUdJgowQm/4UwWd4V7cznX9KeSTeXo+8Nq3PHyKIdvGa5+6KG3jgAfAMz5i6GFfHsek1eZPnpXiE+3jfKL6bPEUfRczhe7Qp5xhr4Oq9PoNzTxDch6ruggagctZgyg5OGTl8FPPnkSBT1ekiQeTgzlI7ARLmjROZzp17gfLBgR2Br31RwK7GUbBVJQuY/tn5YH6zAgeUGI7OoDnhtBObEh1Ovwc//92oUBu3XmW6mQr4SWQM7wqzmZxDOtKZKAdyLcH5mj0jlrEEOp8W1QJ4ilmyrHpyNmndSMZWKHz4cLoET6auSRMgeAvofaoZ2r5b/GcZkd4zirgIf6oXT6ISJb+I2MuAY5ut+2F/yLMeeP2cldWTEuCBOCWQ6qKlel19ZrvKGmrPsHVHU5blE6oeLuHiuTCDVLl+M6smVGxqI1fKEqWhTB79ZsgNTmqbOGBEbXodbFIISTdC5zQnJZNP4yjrfo1LpjUVnoYII3QV80a9fyfEtLTfrdh+DFtxp3cShp18AMy4Fhb/cB+Gazha4gfp47LU0ByCrjkegTts4DH1KX3lb39EwUJYtBIkPFVil3k02/uot2cPVYfW76NXp4u9+xGPA8FjbQcnEFVrIdZmeb3OqNRzWv17HFaZiMw/cWR7t0s+shYtXX1pQuC7RIzxwhW59xKV1dYtBpjVeLi7GyQdUoo+vMNmNRsiAHTuxeMOyG1LvfocEbMAoMTn2WfWyfCEnSDgomD0AFdqMCqnawZaGGYJZJvWju+rhbbA4TDanxBmeEsUNsS05Clo
 Spt3R0bw
 OTol8wT6GA9WZqRqcvcOTTqMp6ZkINPeIvsOzZLOGlOaWAxoYRBpPuuU4vpGBK3TzXqM4Tf4Oldh/fyEeFz3f/Gd7F7XjszVGs7KsIm0NyzTHQxUQC1SXlkFTsrI+C0Ah1ZM4uHdZNrPRjmsS62/68zW6PFuMB98tCtNYjN0TTUg5Sj5o1Q+3RCgBxpm2nTXQPGBVnmIcwwhxLRZ3D7CYjgNvNSjE9FeWIeSeuBBgcUtrvkaJUysEWbKJan/nHFyV4Vtl6O+wKe5qOITcgE9bgd0a6NQ6QluHKbVdwFsmUOepZEKx26lx0wrCuzaEPUZaEzGziOH1Gv81OI3vwAF6oCYr/olcq8uloVS4TcBuLyBJsWFCJLf8/WT9TG9HeloE4KWlZit8jnXOAPo=
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

Therefore, remove check_huge_shmem() and use check_huge_file() instead
and cleanup khugepaged's check_huge operation in mem_ops.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/folio_split_race_test.c |  2 +-
 tools/testing/selftests/mm/khugepaged.c            | 38 ++++------------------
 tools/testing/selftests/mm/uffd-common.c           |  4 +--
 tools/testing/selftests/mm/vm_util.c               |  5 ---
 tools/testing/selftests/mm/vm_util.h               |  1 -
 5 files changed, 9 insertions(+), 41 deletions(-)

diff --git a/tools/testing/selftests/mm/folio_split_race_test.c b/tools/testing/selftests/mm/folio_split_race_test.c
index e4660bf89b62..1a9840b73e61 100644
--- a/tools/testing/selftests/mm/folio_split_race_test.c
+++ b/tools/testing/selftests/mm/folio_split_race_test.c
@@ -181,7 +181,7 @@ static uint64_t run_iteration(void)
 	for (i = 0; i < TOTAL_PAGES; i++)
 		fill_page(mmap_base, i);
 
-	if (!check_huge_shmem(mmap_base, FILE_SIZE, NR_PMD_PAGE, pmd_pagesize))
+	if (!check_huge_file(mmap_base, FILE_SIZE, NR_PMD_PAGE, pmd_pagesize))
 		ksft_exit_fail_msg("No shmem THP is allocated\n");
 
 	if (pthread_barrier_init(&ctl.barrier, NULL, NUM_READER_THREADS + 1) != 0)
diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index bdc0c7c117d9..73d6ab404430 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -57,7 +57,7 @@ struct mem_ops {
 	void *(*setup_area)(int nr_hpages);
 	void (*cleanup_area)(void *p, unsigned long size);
 	void (*fault)(void *p, unsigned long start, unsigned long end);
-	bool (*check_huge)(void *addr, size_t len, int nr_hpages, unsigned long hpage_size);
+	bool (*check_huge)(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
 	const char *name;
 };
 
@@ -343,12 +343,6 @@ static void anon_fault(void *p, unsigned long start, unsigned long end)
 	fill_memory(p, start, end);
 }
 
-static bool anon_check_huge(void *addr, size_t len, int nr_hpages,
-		unsigned long hpage_size)
-{
-	return check_huge_anon(addr, len, nr_hpages, hpage_size);
-}
-
 static void *file_setup_area_common(int nr_hpages, enum file_setup_ops setup)
 {
 	const int open_opt = setup == FILE_SETUP_READ_ONLY_FS ? O_RDONLY : O_RDWR;
@@ -444,20 +438,6 @@ static void file_fault_write(void *p, unsigned long start, unsigned long end)
 		ksft_exit_fail_perror("madvise(MADV_POPULATE_WRITE)");
 }
 
-static bool file_check_huge(void *addr, size_t len, int nr_hpages,
-		unsigned long hpage_size)
-{
-	switch (finfo.type) {
-	case VMA_FILE:
-		return check_huge_file(addr, len, nr_hpages, hpage_size);
-	case VMA_SHMEM:
-		return check_huge_shmem(addr, len, nr_hpages, hpage_size);
-	default:
-		ksft_exit_fail_msg("Unknown VMA type\n");
-		return false;
-	}
-}
-
 static void *shmem_setup_area(int nr_hpages)
 {
 	void *p;
@@ -481,17 +461,11 @@ static void shmem_cleanup_area(void *p, unsigned long size)
 	close(finfo.fd);
 }
 
-static bool shmem_check_huge(void *addr, size_t len, int nr_hpages,
-		unsigned long hpage_size)
-{
-	return check_huge_shmem(addr, len, nr_hpages, hpage_size);
-}
-
 static struct mem_ops __anon_ops = {
 	.setup_area = &anon_setup_area,
 	.cleanup_area = &anon_cleanup_area,
 	.fault = &anon_fault,
-	.check_huge = &anon_check_huge,
+	.check_huge = &check_huge_anon,
 	.name = "anon",
 };
 
@@ -499,7 +473,7 @@ static struct mem_ops __read_only_file_ops = {
 	.setup_area = &file_setup_read_only_area,
 	.cleanup_area = &file_cleanup_area,
 	.fault = &file_fault_read,
-	.check_huge = &file_check_huge,
+	.check_huge = &check_huge_file,
 	.name = "file",
 };
 
@@ -507,7 +481,7 @@ static struct mem_ops __read_write_file_read_ops = {
 	.setup_area = &file_setup_read_write_fs_read_area,
 	.cleanup_area = &file_cleanup_area,
 	.fault = &file_fault_read_and_flush,
-	.check_huge = &file_check_huge,
+	.check_huge = &check_huge_file,
 	.name = "file",
 };
 
@@ -515,7 +489,7 @@ static struct mem_ops __read_write_file_write_ops = {
 	.setup_area = &file_setup_read_write_fs_write_area,
 	.cleanup_area = &file_cleanup_area,
 	.fault = &file_fault_write,
-	.check_huge = &file_check_huge,
+	.check_huge = &check_huge_file,
 	.name = "file",
 };
 
@@ -523,7 +497,7 @@ static struct mem_ops __shmem_ops = {
 	.setup_area = &shmem_setup_area,
 	.cleanup_area = &shmem_cleanup_area,
 	.fault = &anon_fault,
-	.check_huge = &shmem_check_huge,
+	.check_huge = &check_huge_file,
 	.name = "shmem",
 };
 
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
index 7d23038af1df..65bc4761d1c9 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -470,11 +470,6 @@ bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 	return __check_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_FILE);
 }
 
-bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
-{
-	return check_huge_file(addr, len, nr_hpages, hpage_size);
-}
-
 int64_t allocate_transhuge(void *ptr, int pagemap_fd)
 {
 	uint64_t ent[2];
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 072a6c756c51..b5d59729d432 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -96,7 +96,6 @@ uint64_t read_pmd_pagesize(void);
 unsigned long rss_anon(void);
 bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
 bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
-bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
 int64_t allocate_transhuge(void *ptr, int pagemap_fd);
 int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags);
 int gather_folio_orders(char *vaddr_start, size_t len,

-- 
2.43.0


