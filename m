Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 246B2CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 08:23:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 579498E007C; Fri, 22 Aug 2025 04:23:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 464F08E0056; Fri, 22 Aug 2025 04:23:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32D598E007C; Fri, 22 Aug 2025 04:23:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 098EB8E0056
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 04:23:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B904C118385
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:23:29 +0000 (UTC)
X-FDA: 83803704138.05.2E38F7F
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf09.hostedemail.com (Postfix) with ESMTP id EDDB1140008
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:23:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=aLiHlr7y;
	spf=pass (imf09.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755851008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nhat7QbyJ9VFS0Nednpi0uuvkleu4TkUjQY8eR3CM40=;
	b=MrrXVsIMYWuG9EQEj1H7Qx8W00g0m12pcUHm2ZCutmeahJfV0N7JpyF4UtAck3vp6Vn9/8
	b0Dnc+U6wqaKAi7M2ze0qp/rAPQCxblOojoaZtZhezTRvd0rkLu8p/+KIJGrIrZVWYm85R
	/0hPldCICHcokCY6rb05+/au/9RZmuQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=aLiHlr7y;
	spf=pass (imf09.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755851008; a=rsa-sha256;
	cv=none;
	b=rY5+OV26zMSM+RzrKP4Wmuedjq9d5wFjuTdMA7Da8YUqPBTqVXDvy+/g7RvGNfb/y06hU+
	QwKUv5mUKeZhPyyP9vG/uYgRKXBaRo7bebQ501LqGgJX/hJJBdCBVCR8VxbaJzzie5WxJD
	DB2CO7kUPLYwQmnv94lODxIjjYzUZ6A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1755851006;
	bh=a5UE+pImjGxYNd7vPvGSvbIoUcbPZrmvcLKnaYtTnQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aLiHlr7yOB77l4M5/FWrsuLfngueLhplsq9hVGF/cnoYI6RVbZr6MGPiKM031EtFp
	 IR2lBVECBod0Or/+3ocW2HVOHxfsYDHZx5F98NCx2x7F9KXv9rx6eTF9+evMhF3j1t
	 /sByzeXybMWJF7lNDNTeOvvRt8dFSF6Kfbxn7+eI/qurYaGTFJswm3Ny3GQ2RE6vjb
	 clYjanlmOtSfe5gJCBG8sx7QSZmrcDg0PrzEU1FHfrUtwHfQp97qzwsmBCdBUOGy55
	 dIP3dRCrfYObZG6HHwBXUrftPtmy3yZvc8vBUkVLvUsCC/AIcv60k8X3/cX+Iq0Z4y
	 GHluESMdGlBTQ==
Received: from mt.tail9873f4.ts.net (unknown [103.151.43.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: usama.anjum)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id C730717E05F0;
	Fri, 22 Aug 2025 10:23:20 +0200 (CEST)
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
To: Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	kevin.brodsky@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>,
	kernel@collabora.com
Subject: [PATCH v3 5/8] selftests/mm: Remove unused parameters
Date: Fri, 22 Aug 2025 13:21:02 +0500
Message-ID: <20250822082145.4145617-6-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250822082145.4145617-1-usama.anjum@collabora.com>
References: <20250822082145.4145617-1-usama.anjum@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 49w9uqd9gr4q5rkf4gunn37auieef5pz
X-Rspam-User: 
X-Rspamd-Queue-Id: EDDB1140008
X-Rspamd-Server: rspam01
X-HE-Tag: 1755851007-163238
X-HE-Meta: U2FsdGVkX1/8d4D5Cz0/fuitZPqOpTyxK5Ee82Mmkl16DYoIvtRAT3b7jKe2j7JIqtSve3S3S+l1cGiEapxM9Vs1F5AFbnxvZ+YM63pTJiMWJhxAKvcLFS3etviFR50JYrdWcoKKryGv8q1en6nJwdt+iwTfpjDWNqOcYD0yOy6Z8VeKvnL19y3oOsA8ah1hiCDcP50FLQvclOFNAnMYRebmg0mQYjVLldeJucWOSTOxeHOQ5zW7wWSMoefq+cf125iKGvgwWzuZJPoCiix/OvMwlYT0LJal5JZJ6Mlqoqln96QU2OMKlgoIIpee4OsmC2sEcyGXiS9gVG7jdJdwGH2ij4DcccyCxCb7WeK6X/VOT+CRjNhtiz/vGCV9mU+7L0SFfGRc2InerqR00fZYeUZQDmluE9o2Pf2ZGx3slt89QUCY4b/Yz2Ozd+Qd4nAeXs+sJK1cObTqDrFeGoC1vQoFVIdMc6gAcbrAd1Cj1lm9R/97xia9lGGE7gE3gbY+EudIrAWrOPhZ08hGB2VPJiCK/uOr2tDbHhqShflszv1P3Y+VZMGC4Xiznb86XAq6IFVHSyWCaNr/D38kvlvewC7fnkyr1Rz2KtU1+qpvPRxuPU/A3QppsCpVbVvEgwrnFQpQcq44EOebunKv1vC/cH6jzq42Jrf81YivO8w+j9A5kmw1Vt5b3TfGuUEI3XCyEmf79C10ov+P95c8UApaJa3tu15hYNswLZQh8Zk4aJ0XWKUvDSmDDVpEcCG88xW1DXtaGAoztP+TRwOgU3FXZRyj5hUiYHAgQQM7kR8tTvJhMb7LNhh3s/4u5p6hgWT+ylgowj2FvGjQnaOIxdI8IbsrTZADDowBj927Y68D9hktnwdh/rwyA8zRfb1wlHvl5Sgd1p7tjIhixt6vjEybZlJvkk9mMz4FcP3oAdiekQF7tTaPmBEZNRo/BeYg8LFLR3JBOUFqDjJ8G+bdRFn
 GnQ8K34a
 pHF1o4vC6Re16eco3QYTpCh6NAy6+Chszfb2eRl6CzgvZ0hBl/BJBgI+Vs1JFeximnmloyJrXjea4eX9d0y2qF+b5M3ri7wHfSSDtniNzYvYwBnnDqSDI/2AzmK0MIKW8vi7W6idj7+/ae4V8wknrJWvuSiHDpReuILH69lWFumQQS48mgYqLDYpPWrmSct3w8aALBorPIid/p9YqlzrlldXR2j3NXVzHRrHzvPpexiaUh4aiFxi8pUEVQ74CtMk8dDHur0AHRtN5UCVhDJWIB1QU6+/UAaDSOtAMZ16HaHlWgN4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cleanup code and remove the unused arguments

Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
 tools/testing/selftests/mm/ksm_tests.c       | 17 +++++++----------
 tools/testing/selftests/mm/soft-dirty.c      |  4 ++--
 tools/testing/selftests/mm/uffd-common.c     |  4 ++--
 tools/testing/selftests/mm/uffd-common.h     |  2 +-
 tools/testing/selftests/mm/uffd-stress.c     |  2 +-
 tools/testing/selftests/mm/uffd-unit-tests.c |  8 ++++----
 6 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/mm/ksm_tests.c b/tools/testing/selftests/mm/ksm_tests.c
index b77462b5c240b..f5dabb513ed7f 100644
--- a/tools/testing/selftests/mm/ksm_tests.c
+++ b/tools/testing/selftests/mm/ksm_tests.c
@@ -238,8 +238,7 @@ static int ksm_merge_pages(int merge_type, void *addr, size_t size,
 	return 0;
 }
 
-static int ksm_unmerge_pages(void *addr, size_t size,
-			     struct timespec start_time, int timeout)
+static int ksm_unmerge_pages(void *addr, size_t size)
 {
 	if (madvise(addr, size, MADV_UNMERGEABLE)) {
 		perror("madvise");
@@ -456,7 +455,7 @@ static int get_first_mem_node(void)
 	return get_next_mem_node(numa_max_node());
 }
 
-static int check_ksm_numa_merge(int merge_type, int mapping, int prot, int timeout,
+static int check_ksm_numa_merge(int merge_type, int timeout,
 				bool merge_across_nodes, size_t page_size)
 {
 	void *numa1_map_ptr, *numa2_map_ptr;
@@ -520,8 +519,7 @@ static int check_ksm_numa_merge(int merge_type, int mapping, int prot, int timeo
 	return KSFT_FAIL;
 }
 
-static int ksm_merge_hugepages_time(int merge_type, int mapping, int prot,
-				int timeout, size_t map_size)
+static int ksm_merge_hugepages_time(int merge_type, int timeout, size_t map_size)
 {
 	void *map_ptr, *map_ptr_orig;
 	struct timespec start_time, end_time;
@@ -656,7 +654,7 @@ static int ksm_unmerge_time(int merge_type, int mapping, int prot, int timeout,
 		perror("clock_gettime");
 		goto err_out;
 	}
-	if (ksm_unmerge_pages(map_ptr, map_size, start_time, timeout))
+	if (ksm_unmerge_pages(map_ptr, map_size))
 		goto err_out;
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &end_time)) {
 		perror("clock_gettime");
@@ -884,8 +882,8 @@ int main(int argc, char *argv[])
 						page_size);
 		break;
 	case CHECK_KSM_NUMA_MERGE:
-		ret = check_ksm_numa_merge(merge_type, MAP_PRIVATE | MAP_ANONYMOUS, prot,
-					ksm_scan_limit_sec, merge_across_nodes, page_size);
+		ret = check_ksm_numa_merge(merge_type, ksm_scan_limit_sec, merge_across_nodes,
+					   page_size);
 		break;
 	case KSM_MERGE_TIME:
 		if (size_MB == 0) {
@@ -900,8 +898,7 @@ int main(int argc, char *argv[])
 			printf("Option '-s' is required.\n");
 			return KSFT_FAIL;
 		}
-		ret = ksm_merge_hugepages_time(merge_type, MAP_PRIVATE | MAP_ANONYMOUS, prot,
-				ksm_scan_limit_sec, size_MB);
+		ret = ksm_merge_hugepages_time(merge_type, ksm_scan_limit_sec, size_MB);
 		break;
 	case KSM_UNMERGE_TIME:
 		if (size_MB == 0) {
diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
index e62be4136f69e..751fbc52857ea 100644
--- a/tools/testing/selftests/mm/soft-dirty.c
+++ b/tools/testing/selftests/mm/soft-dirty.c
@@ -76,7 +76,7 @@ static void test_vma_reuse(int pagemap_fd, int pagesize)
 	munmap(map2, pagesize);
 }
 
-static void test_hugepage(int pagemap_fd, int pagesize)
+static void test_hugepage(int pagemap_fd)
 {
 	char *map;
 	int i, ret;
@@ -210,7 +210,7 @@ int main(void)
 
 	test_simple(pagemap_fd, pagesize);
 	test_vma_reuse(pagemap_fd, pagesize);
-	test_hugepage(pagemap_fd, pagesize);
+	test_hugepage(pagemap_fd);
 	test_mprotect_anon(pagemap_fd, pagesize);
 	test_mprotect_file(pagemap_fd, pagesize);
 
diff --git a/tools/testing/selftests/mm/uffd-common.c b/tools/testing/selftests/mm/uffd-common.c
index a37088a23ffef..815c22114b57e 100644
--- a/tools/testing/selftests/mm/uffd-common.c
+++ b/tools/testing/selftests/mm/uffd-common.c
@@ -416,7 +416,7 @@ static void continue_range(int ufd, __u64 start, __u64 len, bool wp)
 		    ret, (int64_t) req.mapped);
 }
 
-int uffd_read_msg(int ufd, struct uffd_msg *msg)
+int uffd_read_msg(struct uffd_msg *msg)
 {
 	int ret = read(uffd, msg, sizeof(*msg));
 
@@ -537,7 +537,7 @@ void *uffd_poll_thread(void *arg)
 		}
 		if (!(pollfd[0].revents & POLLIN))
 			err("pollfd[0].revents %d", pollfd[0].revents);
-		if (uffd_read_msg(uffd, &msg))
+		if (uffd_read_msg(&msg))
 			continue;
 		switch (msg.event) {
 		default:
diff --git a/tools/testing/selftests/mm/uffd-common.h b/tools/testing/selftests/mm/uffd-common.h
index 7700cbfa39756..2e7066d69103d 100644
--- a/tools/testing/selftests/mm/uffd-common.h
+++ b/tools/testing/selftests/mm/uffd-common.h
@@ -117,7 +117,7 @@ void uffd_stats_report(struct uffd_args *args, int n_cpus);
 int uffd_test_ctx_init(uint64_t features, const char **errmsg);
 void uffd_test_ctx_clear(void);
 int userfaultfd_open(uint64_t *features);
-int uffd_read_msg(int ufd, struct uffd_msg *msg);
+int uffd_read_msg(struct uffd_msg *msg);
 void wp_range(int ufd, __u64 start, __u64 len, bool wp);
 void uffd_handle_page_fault(struct uffd_msg *msg, struct uffd_args *args);
 int __copy_page(int ufd, unsigned long offset, bool retry, bool wp);
diff --git a/tools/testing/selftests/mm/uffd-stress.c b/tools/testing/selftests/mm/uffd-stress.c
index c0f64df5085c4..24aac0ae96c6c 100644
--- a/tools/testing/selftests/mm/uffd-stress.c
+++ b/tools/testing/selftests/mm/uffd-stress.c
@@ -137,7 +137,7 @@ static void *uffd_read_thread(void *arg)
 	/* from here cancellation is ok */
 
 	for (;;) {
-		if (uffd_read_msg(uffd, &msg))
+		if (uffd_read_msg(&msg))
 			continue;
 		uffd_handle_page_fault(&msg, args);
 	}
diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index 50501b38e34e7..df7b82bbebaad 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -248,7 +248,7 @@ static void *fork_event_consumer(void *data)
 	ready_for_fork = true;
 
 	/* Read until a full msg received */
-	while (uffd_read_msg(args->parent_uffd, &msg));
+	while (uffd_read_msg(&msg));
 
 	if (msg.event != UFFD_EVENT_FORK)
 		err("wrong message: %u\n", msg.event);
@@ -1352,11 +1352,11 @@ static void *uffd_mmap_changing_thread(void *opaque)
 	return NULL;
 }
 
-static void uffd_consume_message(int fd)
+static void uffd_consume_message(void)
 {
 	struct uffd_msg msg = { 0 };
 
-	while (uffd_read_msg(fd, &msg));
+	while (uffd_read_msg(&msg));
 }
 
 static void uffd_mmap_changing_test(uffd_test_args_t *targs)
@@ -1407,7 +1407,7 @@ static void uffd_mmap_changing_test(uffd_test_args_t *targs)
 	 * All succeeded above!  Recycle everything.  Start by reading the
 	 * event so as to kick the thread roll again..
 	 */
-	uffd_consume_message(uffd);
+	uffd_consume_message();
 
 	ret = pthread_join(tid, NULL);
 	assert(ret == 0);
-- 
2.47.2


