Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51E8CC87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 16:03:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAD7D6B0098; Thu, 31 Jul 2025 12:03:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5E0D6B0099; Thu, 31 Jul 2025 12:03:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4CF76B009A; Thu, 31 Jul 2025 12:03:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C56936B0098
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:03:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9B2355AC4D
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:03:11 +0000 (UTC)
X-FDA: 83725028982.06.AC3482F
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf15.hostedemail.com (Postfix) with ESMTP id AA7C1A0003
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:03:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=ico7FzEo;
	spf=pass (imf15.hostedemail.com: domain of usama.anjum@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753977789; a=rsa-sha256;
	cv=pass;
	b=TWhM4NJSztJB7JW71MaUYf8eQOGcD1uOiSIt69rJWNVh2FvHW6/hE0fQ4AKXnBhTp/Sk68
	m9U9pBfBuCkKZrV0oAIJYWhnZIc8kw0AQVh3Uk6mfSC79+0P8v3ZtGQIlKbm/PmHSTGDnV
	3pQAUqMUqNDlIWrI45eYwJ23YzPwWlE=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=ico7FzEo;
	spf=pass (imf15.hostedemail.com: domain of usama.anjum@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753977789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EMrVRz1c7lWgAJev1ywCCQZY315K/Pj6btdYQU662ps=;
	b=BHQaqg27DicaZrpv9dtMtwlWmu2EWYPGywjINLH0VCraZsHTyrWXdCsq+MX2zFJjVirUPm
	xe81rKD1GSxLaqmr/0hkhUSfEmyv3iNMJSA31UxBq1w3lhaaL2Qhdwofgz3W/KmLp7aJto
	cRbUq27wJC1n9bq28JL3nQN5+UILmkk=
ARC-Seal: i=1; a=rsa-sha256; t=1753977774; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Ld0isy669SiUPlxBjYL00zV68jo3jmBbmKOi9wWCjDCArTT+yBfeiRQ3Rc3fPYDVDAOf/MclMBROVGpHOXmiugTAp6AiQ+3x7cRxjbKvioWxXczqQMAfX5W2dVNRxp/SOpgmKmhuXBj1iwRvRCEWjinPavrFuC2nyniy9o0JGkI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1753977774; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=EMrVRz1c7lWgAJev1ywCCQZY315K/Pj6btdYQU662ps=; 
	b=iAqhu+P9PjbMky9GooYr9CSLU4qeb/h/KH2U3UG3PGvge6cGJXVG79KrGCdcQqpDKk7K2FiuMlZ+Q8pfPe37inlrkPtsy4KOcDpKa+AwKKifGr3WZLtLLoaOUv+A3aPgGog64rw+nx6mEn+GDRElYpa9l76KdyCaimt3P3bOYd4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass header.from=<usama.anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1753977774;
	s=zohomail; d=collabora.com; i=usama.anjum@collabora.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=EMrVRz1c7lWgAJev1ywCCQZY315K/Pj6btdYQU662ps=;
	b=ico7FzEouaeu+Zh7BNO0zMc2PILb9ftQ7nECHu7NbMpX1jmKCFyl0WVfFJF1VsVA
	wCsuXfExvYMvyeb6l2A451QfYmlzNYRV/TPLZRfcJR6CQFPrQPTI8slyKRr8eaooP2v
	MhGJmHP26R3GX7Q7OJvIHl6WsiS/qH4u0MmknFYQ=
Received: by mx.zohomail.com with SMTPS id 175397777225950.334810900997695;
	Thu, 31 Jul 2025 09:02:52 -0700 (PDT)
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
To: Andrew Morton <akpm@linux-foundation.org>,
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
	Shuah Khan <shuah@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>,
	kernel@collabora.com
Subject: [PATCH v2 4/8] selftests/mm: Add -Wunused family of flags
Date: Thu, 31 Jul 2025 21:01:28 +0500
Message-Id: <20250731160132.1795351-5-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250731160132.1795351-1-usama.anjum@collabora.com>
References: <20250731160132.1795351-1-usama.anjum@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AA7C1A0003
X-Stat-Signature: kni1dkxkbas6jmwsz5yyujtonc9jfpz9
X-HE-Tag: 1753977789-589281
X-HE-Meta: U2FsdGVkX18vu51nmAJRwBLAHfuWsfK8U46Ki56UvoEUgtNqB/FLv+jk6YMwthXyGaKsEzwWLFCE2ScdGv1X+KdTIwd/HklWJLSK5mOoyX8l8KSEOotH4oGmoe6mCqn3ErxggReQGyqnX2P4yK3n0srBoZuLa6g21Rv6BmXzm3h6zObzErlUKE5pxcwlKeF1iTXkcrYEdUNJXlAoXzhPmizSwwiGFkUQxq3Zpvg5oTutecJU9MnBcAGS8YxW3F1EDnTe0ScTGb3PQQ+TfRKXRsNRhgIOgTwYlTRujVBr+9hKtilrFtNxSwLXs94r19uanGh1535lZcvRGaBSrAdcgwhvJJCMdG32wJPY4ywnNO3eor6/rfr+Jtgy2apT3fxs+I77gqCOhzZpjprREB/NTr48b9El8grlwghyg5K1blNMTinPdT8ZTiQUNeWGfyyrTeYIPo649uwJYBg9P5rAXHVt/7DWeGFVM1CD4LJ2Plc8vBdI8pkW7+t9kl7u2UXgyK/wK3KBgGPk2PonpVFu35LmFb+7FIyOeFFuXUm0QpB2h3sgnh8IZ0mTvzprzsWduSv7hjwrRwJa8AnAgphqxZYTGsnUVIQg+OlFDGqla/+gR5B0RT1Ii+mNUKVOSxuWn9f3M3rY1aK5ZiKpoPHtOGNFkj3/4YqLn7xfpEsX4DibE5jxba5qe2EVtsb2LKvP21BSAGqjaq+YH4hVyXyQMiquiULHX85b4ONFAgLBNWREDrun8PBygTvVj1CUTgLPwygtmodNLagoByUrLLt9CMxRDcSQ6KCrfGHHvfQwAY1paxYeXcgqG8/DmQ/1RRfaaEyUOG4hYI4x4FUOi7pIYD+dxaUTazt2kedV/oAuJ30mqgxTl9e4mIrvdvYDDC7GK9PvXNWXsdMSkCiy10bX9QVntCHgqR5554sCny7eiX5LPLEMUWASrr1yej+TH4Ex7+Qj7M6BCL2JMj8Znsd
 1wf9c7Tw
 9Ya7BVOMdcM0VLykICC18ksF4k3KrG7KOXMrza3ji9vYlkKsTuseQ2IuxEmEiZvwZiFlviFDbVSZNHZGxuBo3euSa/PM2WiF63Tgp2VCTGi6qx5qvJBOhfyZr9h0y4SCSbmBtCIa2XwhSdNPCKaA0ltMpn/EgXZQ/p8C/Px0vDlYlrSompzRO0e4lQakYNXEvQVwt+9y4FhzWpP9AdF6ogycGGUw3IP0ukqrf52KHCXlw+n6h80kXSNqTuGyDkWckkJu/1sT7u6oqeuXArwEhEfHcrnWYv2BQVzYcilD4IKX9eGavHbqHGRrgzSqZvO/fymSoD3gwft0r72YjkXWo6wuBw9RH958wjm3+ZEqbOYIFov/Bb5AMLUdfHC5ypW9pefyH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add -Wunused family of flags and fix all the warnings coming because of
argc and argv. Remove them if they aren't being used entirely. Use
__unused compiler attribute with argc where argv is being used.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
 tools/testing/selftests/mm/Makefile                | 2 +-
 tools/testing/selftests/mm/compaction_test.c       | 2 +-
 tools/testing/selftests/mm/cow.c                   | 2 +-
 tools/testing/selftests/mm/droppable.c             | 2 +-
 tools/testing/selftests/mm/gup_longterm.c          | 2 +-
 tools/testing/selftests/mm/hugepage-vmemmap.c      | 2 +-
 tools/testing/selftests/mm/hugetlb-madvise.c       | 2 +-
 tools/testing/selftests/mm/hugetlb-soft-offline.c  | 2 +-
 tools/testing/selftests/mm/madv_populate.c         | 2 +-
 tools/testing/selftests/mm/map_populate.c          | 2 +-
 tools/testing/selftests/mm/memfd_secret.c          | 2 +-
 tools/testing/selftests/mm/mlock-random-test.c     | 2 +-
 tools/testing/selftests/mm/mlock2-tests.c          | 2 +-
 tools/testing/selftests/mm/on-fault-limit.c        | 2 +-
 tools/testing/selftests/mm/pkey_sighandler_tests.c | 2 +-
 tools/testing/selftests/mm/soft-dirty.c            | 2 +-
 tools/testing/selftests/mm/uffd-wp-mremap.c        | 2 +-
 tools/testing/selftests/mm/virtual_address_range.c | 2 +-
 18 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 23d4bf6215465..d75f1effcb791 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -20,7 +20,6 @@ endif
 # thus tricking Make (and you!) into believing that All Is Well, in subsequent
 # make invocations:
 .DELETE_ON_ERROR:
-
 # Avoid accidental wrong builds, due to built-in rules working just a little
 # bit too well--but not quite as well as required for our situation here.
 #
@@ -35,6 +34,7 @@ MAKEFLAGS += --no-builtin-rules
 
 CFLAGS = -Wall -O2 -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
 CFLAGS += -Wunreachable-code
+CFLAGS += -Wunused  -Wunused-parameter -Wunused-function -Wunused-label -Wunused-variable -Wunused-value
 LDLIBS = -lrt -lpthread -lm
 
 # Some distributions (such as Ubuntu) configure GCC so that _FORTIFY_SOURCE is
diff --git a/tools/testing/selftests/mm/compaction_test.c b/tools/testing/selftests/mm/compaction_test.c
index 9bc4591c7b169..4fa03679e9b07 100644
--- a/tools/testing/selftests/mm/compaction_test.c
+++ b/tools/testing/selftests/mm/compaction_test.c
@@ -203,7 +203,7 @@ int set_zero_hugepages(unsigned long *initial_nr_hugepages)
 	return ret;
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	struct rlimit lim;
 	struct map_list *list = NULL, *entry;
diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index d30625c18259b..eb1ccf067b633 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -1857,7 +1857,7 @@ static int tests_per_non_anon_test_case(void)
 	return tests;
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	struct thp_settings default_settings;
 
diff --git a/tools/testing/selftests/mm/droppable.c b/tools/testing/selftests/mm/droppable.c
index f3d9ecf96890a..90ea6377810c5 100644
--- a/tools/testing/selftests/mm/droppable.c
+++ b/tools/testing/selftests/mm/droppable.c
@@ -15,7 +15,7 @@
 
 #include "../kselftest.h"
 
-int main(int argc, char *argv[])
+int main(void)
 {
 	size_t alloc_size = 134217728;
 	size_t page_size = getpagesize();
diff --git a/tools/testing/selftests/mm/gup_longterm.c b/tools/testing/selftests/mm/gup_longterm.c
index 268dadb8ce438..7fe4f94400cb6 100644
--- a/tools/testing/selftests/mm/gup_longterm.c
+++ b/tools/testing/selftests/mm/gup_longterm.c
@@ -504,7 +504,7 @@ static int tests_per_test_case(void)
 	return 3 + nr_hugetlbsizes;
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	int i;
 
diff --git a/tools/testing/selftests/mm/hugepage-vmemmap.c b/tools/testing/selftests/mm/hugepage-vmemmap.c
index df366a4d1b92d..23e97e552057d 100644
--- a/tools/testing/selftests/mm/hugepage-vmemmap.c
+++ b/tools/testing/selftests/mm/hugepage-vmemmap.c
@@ -87,7 +87,7 @@ static int check_page_flags(unsigned long pfn)
 	return 0;
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	void *addr;
 	unsigned long pfn;
diff --git a/tools/testing/selftests/mm/hugetlb-madvise.c b/tools/testing/selftests/mm/hugetlb-madvise.c
index 1afe14b9dc0c3..27c8e46ae9b7d 100644
--- a/tools/testing/selftests/mm/hugetlb-madvise.c
+++ b/tools/testing/selftests/mm/hugetlb-madvise.c
@@ -55,7 +55,7 @@ void read_fault_pages(void *addr, unsigned long nr_pages)
 	}
 }
 
-int main(int argc, char **argv)
+int main(int __unused argc, char **argv)
 {
 	unsigned long free_hugepages;
 	void *addr, *addr2;
diff --git a/tools/testing/selftests/mm/hugetlb-soft-offline.c b/tools/testing/selftests/mm/hugetlb-soft-offline.c
index f086f0e04756f..cb087303f5ed3 100644
--- a/tools/testing/selftests/mm/hugetlb-soft-offline.c
+++ b/tools/testing/selftests/mm/hugetlb-soft-offline.c
@@ -216,7 +216,7 @@ static void test_soft_offline_common(int enable_soft_offline)
 			 enable_soft_offline);
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	ksft_print_header();
 	ksft_set_plan(2);
diff --git a/tools/testing/selftests/mm/madv_populate.c b/tools/testing/selftests/mm/madv_populate.c
index b6fabd5c27ed6..178e0ae0cd4a1 100644
--- a/tools/testing/selftests/mm/madv_populate.c
+++ b/tools/testing/selftests/mm/madv_populate.c
@@ -281,7 +281,7 @@ static int system_has_softdirty(void)
 #endif
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	int nr_tests = 16;
 	int err;
diff --git a/tools/testing/selftests/mm/map_populate.c b/tools/testing/selftests/mm/map_populate.c
index 9df2636c829bf..2b240499f15c9 100644
--- a/tools/testing/selftests/mm/map_populate.c
+++ b/tools/testing/selftests/mm/map_populate.c
@@ -76,7 +76,7 @@ static int child_f(int sock, unsigned long *smap, int fd)
 	return ksft_cnt.ksft_pass;
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	int sock[2], child, ret;
 	FILE *ftmp;
diff --git a/tools/testing/selftests/mm/memfd_secret.c b/tools/testing/selftests/mm/memfd_secret.c
index 9a0597310a765..836383f63b630 100644
--- a/tools/testing/selftests/mm/memfd_secret.c
+++ b/tools/testing/selftests/mm/memfd_secret.c
@@ -299,7 +299,7 @@ static void prepare(void)
 
 #define NUM_TESTS 6
 
-int main(int argc, char *argv[])
+int main(void)
 {
 	int fd;
 
diff --git a/tools/testing/selftests/mm/mlock-random-test.c b/tools/testing/selftests/mm/mlock-random-test.c
index b8d7e966f44c6..4ff7a4cfc7331 100644
--- a/tools/testing/selftests/mm/mlock-random-test.c
+++ b/tools/testing/selftests/mm/mlock-random-test.c
@@ -236,7 +236,7 @@ static void test_mlock_outof_limit(char *p, int alloc_size)
 	ksft_test_result_pass("%s\n", __func__);
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	char *p = NULL;
 
diff --git a/tools/testing/selftests/mm/mlock2-tests.c b/tools/testing/selftests/mm/mlock2-tests.c
index 3e90ff37e336a..ce5fd5ce1f51f 100644
--- a/tools/testing/selftests/mm/mlock2-tests.c
+++ b/tools/testing/selftests/mm/mlock2-tests.c
@@ -425,7 +425,7 @@ static void test_mlockall(void)
 	munlockall();
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	int ret, size = 3 * getpagesize();
 	void *map;
diff --git a/tools/testing/selftests/mm/on-fault-limit.c b/tools/testing/selftests/mm/on-fault-limit.c
index 431c1277d83a1..ade160966c926 100644
--- a/tools/testing/selftests/mm/on-fault-limit.c
+++ b/tools/testing/selftests/mm/on-fault-limit.c
@@ -28,7 +28,7 @@ static void test_limit(void)
 	munlockall();
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	ksft_print_header();
 	ksft_set_plan(1);
diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
index 302fef54049c8..eb4ef8532c0bf 100644
--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
+++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -528,7 +528,7 @@ static void (*pkey_tests[])(void) = {
 	test_pkru_sigreturn
 };
 
-int main(int argc, char *argv[])
+int main(void)
 {
 	int i;
 
diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
index 8a3f2b4b21869..e62be4136f69e 100644
--- a/tools/testing/selftests/mm/soft-dirty.c
+++ b/tools/testing/selftests/mm/soft-dirty.c
@@ -194,7 +194,7 @@ static void test_mprotect_file(int pagemap_fd, int pagesize)
 	test_mprotect(pagemap_fd, pagesize, false);
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	int pagemap_fd;
 	int pagesize;
diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c b/tools/testing/selftests/mm/uffd-wp-mremap.c
index c2ba7d46c7b45..13ceb56289701 100644
--- a/tools/testing/selftests/mm/uffd-wp-mremap.c
+++ b/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -334,7 +334,7 @@ static const struct testcase testcases[] = {
 	},
 };
 
-int main(int argc, char **argv)
+int main(void)
 {
 	struct thp_settings settings;
 	int i, j, plan = 0;
diff --git a/tools/testing/selftests/mm/virtual_address_range.c b/tools/testing/selftests/mm/virtual_address_range.c
index 169dbd692bf5f..3c21d136962cb 100644
--- a/tools/testing/selftests/mm/virtual_address_range.c
+++ b/tools/testing/selftests/mm/virtual_address_range.c
@@ -189,7 +189,7 @@ static int validate_complete_va_space(void)
 	return 0;
 }
 
-int main(int argc, char *argv[])
+int main(void)
 {
 	char *ptr[NR_CHUNKS_LOW];
 	char **hptr;
-- 
2.39.5


