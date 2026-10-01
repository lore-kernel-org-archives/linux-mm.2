Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E81ACA5FCE
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 21:18:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 967506B0096; Thu,  1 Oct 2026 17:18:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 918916B0098; Thu,  1 Oct 2026 17:18:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 807106B0099; Thu,  1 Oct 2026 17:18:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4FF5B6B0096
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 17:18:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A434CC0576
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 21:18:22 +0000 (UTC)
X-FDA: 85275320844.16.700D8C7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 82040C0002
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 21:18:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DIP8yhKw;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790889500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jtl34yFsL3Z5TJZKa24tGDZd7N586pFCSCiYYiQ7rbc=;
	b=fAN35oJjlm0JfC2ZMgdyhxpfe+ebI+6GmrRHwu5zmRHXvoq6N4a/r7K0MdO1cmcIHIlj68
	zluc2R62c5PfavJpffLbsCDOJpNJtKxJ8RtLmCuCUAxXS/dgdKtdTGIG25tleZhbFmSXTM
	nOXSlVjlvOpeA10FsVmZXid1XDMFFqU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DIP8yhKw;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790889500;
	b=rPE/4oxLp+9FL0U3h0kgyzTZOOPp43OacfHgBNedKCDAnePO7zqqKhGQL8OEH0cihkTRTA
	Cw2Cf7oiC+blq3sJR75CAt60rT7+Vd4sr84uc3OOhCf+vbTu8lC+7KbE0wMLpzC2vpG1Ud
	E9fkS5FfzI6E5Lgc0IsSIPhkPEjoGY8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3081E175D;
	Thu,  1 Oct 2026 14:18:16 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9C1763F86F;
	Thu,  1 Oct 2026 14:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790889499; bh=qoSGrwNQRKGNb/DAYUjsOgnGJWv8gpOg0lOua4ceY5Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=DIP8yhKwwptsra6oSVnxGZpBOypKKHGXsnlcotdwJ75CoHaWHgQ+7PKoFvxaTHKgr
	 AgVCMesE4WBcStB/VOzkUpiWPFtM6Kf31M0OFH55qdUKfhdGwMrrVhGTa3fmncztPj
	 MFQdj4b9Jx/lY0BLCa4q6bJM9nI50EVBL1rzMp0U=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Thu, 01 Oct 2026 22:17:54 +0100
Subject: [PATCH v9 4/4] kselftest: mm: remove check_huge_shmem()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261001-fix_split-v9-4-0f4ba8bbdbdf@arm.com>
References: <20261001-fix_split-v9-0-0f4ba8bbdbdf@arm.com>
In-Reply-To: <20261001-fix_split-v9-0-0f4ba8bbdbdf@arm.com>
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
 linux-kernel@vger.kernel.org, Sarthak Sharma <sarthak.sharma@arm.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7460; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=qoSGrwNQRKGNb/DAYUjsOgnGJWv8gpOg0lOua4ceY5Q=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqvs4KEEnqiON+I3Gd3mz6SPdJmpeKMqoQZSCSr
 VpJh7nj9qGJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCar7OCgAKCRBt1cPRWsUx
 M0DRDADOZW52MN1wbgEqIJKQc0Q+UqYUnv1ItUiJbFIbrHUS9z/Jnl0g4Caa1agRolvBsut/+Ik
 i5Bi82AcUuUaP4632u8/HU2vqkfhNwDLfMSdcoN17SkngFlv1QRZoaOrGadXEsVgSve0zH+p0su
 nrxWlkJOgl2oHKN481Nk24L2YKE7l2mkKkFUcxFG3P0KOG52DJRpitaVN90n9X4Q0qkQc+mljZm
 QACLrFEdSqdxmoPSEXZqJS6zY/9Zeex9BU/xcyKFUEPP/5k2v/NQs5KpJn1ggYwJAA1eQcYzdGq
 /Ad0h5By83rNRWuY/v5zCsvojGdgWL40ralvP1/vPZsBY5YicON3GjH5aqsHMYXnDS0BG5StcgR
 i+nG7waFmYWgBdJDGJJFFVPGxxOYKkDlFB4+z+0qmJI1JHGNhCf94LrnAtmJ6vhXwc1ldu5KeU0
 i3VrI6afLDZvEbLRXIOhpbuMSOxWGQXQhhV0OOcGcv9uCjqRPTMUYa2j3r+BbtqB6tZM4=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Stat-Signature: 165p5xxe8go5rmo86gfkj53swqwmugyd
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 82040C0002
X-HE-Tag: 1790889500-608770
X-HE-Meta: U2FsdGVkX1/3jhujpCUAFamcB0Cyen40dng4WLiuGn0zqa8/InYXlaBkyD39z14MPzN/LXCqAnFBzzRp8qDR3ylLJaLxGgsc1y3qVE/guWy7HQ7VrQgHAEAtC9w0XucsJ5OG3jN0jp6GckHpwQ/B58tS85hSsiF9Ou5siADh6FGm4nSMgZ7LHow7Xf2j6o8RuvzRWsWPEU/bbvSxB+6Yl7dyZd3UkdTT7YkEr6gD3CgnOaZPmuwHrxnk5P4/QJJsBpbVbK/NV8n7CGxIFAbFrm6gwuPVxcYb4czR5LYo84UnWa2nHJ2Sc8nb/m0DbLU/caGX2OmbSs2N9RMb3oXKHa0AaISUTJdxXbqSeixvrgLKRCVoWrq7A0iO/BqOhBGGLQnqUIpeRIG0/esAW0RfEJcdJUdC3QI0+dt1Q6pSaSQSX3FJaAreXgsEbwi/I0L7aCwkLRcC8k6jGa7qgk7BhgasZrD5mbdwV1TT7L6v/EzrospwBbPqye4SVlCKUCUPTzDyntTMRUa6OdSQMsdV5RKcORtpUVa66ezfrYK09Hu9vYdk8jZl9K8QF7rGU4QVM2xxMq4DSlXsrt8uCzkKLo6ye9tyQT5ZHdqo9hMyARZg4XUFonybxJ8Xg4y2yWCgULIh8D+Opl0aOnRTMTyWNbNt6d1MWzaxzQGQ+dmVE/PrLZI3hG59Nj+6BLmJppEtSIopLSdK4AC98kec0tyqPJ29s1sGQbjbY3cZHUMhRZ9ZaGVDoakfruJ4kRCaGEoordzlO3p8hZbcKATidJxyj56cndgO85c7ZN/qfcC8LrW7AHfxYOfmCJwogWrwZSV76KOQ8jaR9Cd1tIrXQVwO9Clk2G+XRAsUTQBTqQ7vK3fKLlPDmpx+rfU4++49OsafLoRhbLFl4uj8oaSQXGLCTGV8pi7wbAXxFGS1UK5NtXZrkLHc8W8QgTfxcTW4uhflr0oEM3eOUPwNX97/xYH
 bWrDdeb3
 f8C3Ac9MSlfGjkGjYytKBryvdcmPMTWUtiJp3MLjZrfLIuUBmcVhKj6/bY3OX4E4j0hQmAIA1OJ+H8avSl/rdFlnsROFx5tosPfHt42WcmeDQ9gc4aYivlAriv44NyjfOtu7TWbn3K+Mw8pbtlPFiglkoE3sAVAPDC0kuoVzc2ZKOXqKYYeeQaei3B5LJfaEvLuKj1K5hcWNy6PF5Zef43XuD/Ra6lw+gApmb6frzlmlrzyVUbuzc7ncuVYXX4TAUNESeN6tjRJTPtMTMOVdWUPjUWyf6fWRzf0oI/AmTm7tAcg8PjTlf5+rAsBlunHH7TzrSGSYRQyEnZqSCZi7ErEGwrYMIc5U+aRImYsq8/DX2PRlH/sCmD8MUDnPbYPmMKMbYWpWKkXQjq+Y=
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
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
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
index b0cb02bf1a73..61bd69d604d2 100644
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
index 65c06e17c326..515031b8283d 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -486,11 +486,6 @@ bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 	return __check_type(addr, len, scan_mapping_size, CHECK_TYPE_FILE);
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


