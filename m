Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AA4BF46C45
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:19:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E03486B00BF; Mon,  6 Apr 2026 10:19:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDB456B00C1; Mon,  6 Apr 2026 10:19:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF0DC6B00C2; Mon,  6 Apr 2026 10:19:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BDA9A6B00BF
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:19:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8866EB91BF
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:19:56 +0000 (UTC)
X-FDA: 84628339992.18.BE62C91
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id CDF50A0017
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:19:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vOitDIDW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485194; a=rsa-sha256;
	cv=none;
	b=c69LpcqeTLAdB7IKBqzj0HU9JWzM3q8bAQE/8DzmySS3F5CKAN5k24IEehv8R5R6hmt81K
	f2p2z9VDyXNGT3JB3frFg0q5qM0UGSuswTxXgL7PxsGKJE4RGjZNx81sDUdHtbAeM+ORfX
	m/5WY6mXgKxH1TOy1wVTOBIEzs1mwgk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vOitDIDW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FtP9VFTzz5ey3F8oLxsBCb1BK0JVhKYfknuJcvjZN4s=;
	b=JOEQ7ookhwD0OUAwU+oJoqr3tFudy6fmF1749ev0h2wQGaFxMWaXLWuEJHiQn8SGYWhnwK
	TudLhkHQ6KGZwlSjW9nFeO5Q7MEc1RWZQW/a1oahrzhZI/nV4wGageX6k5wX0LAqqdQC9v
	hyrXSKij/JH5YNuFd4iTT5JeEpcGLFY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C4A06012A;
	Mon,  6 Apr 2026 14:19:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63EFC4CEF7;
	Mon,  6 Apr 2026 14:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485193;
	bh=hJ9AhljZrrZSza0NM3Jn6Z9Xd9XeJO3vKv3986M1eo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vOitDIDWHs+Nz382UWHgmjODY49eO8TYnugKFK+RkbJ3njrWRB3E1bWMrFxUhb81K
	 55wKmoxj0dvB+3hrkzJWdWZuaLGE74g5Tqtn4wtWVewPipCIH8mqhbhPtV8OdsKEkf
	 1z2CD/dSbxGw+2ZEY6CjV8ddmk1YAynPxlIp463G0wjasLNKuwlRZ/mwdaLPCIC9BF
	 2U/S5E3jTFVrswbPyr5LyR0j882qwW2H0MUGiXw4Sv6Hgf6KMXRwzkmXr0KzoLB+uL
	 LswVGDU+HVs6gtVhxDnjpgJYJMWWdKisulHz0p9eSgrpu6ydW4cnXBpRJXrI4Rvss5
	 V3yz2dVkqQ8Bw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
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
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 22/53] selftests/mm: move HugeTLB helpers to hugepage_settings
Date: Mon,  6 Apr 2026 17:17:04 +0300
Message-ID: <20260406141735.2179309-23-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8swrpszwh8ni6jiphejs9ayhrhbi4tio
X-Rspamd-Queue-Id: CDF50A0017
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775485194-731623
X-HE-Meta: U2FsdGVkX1+boIKYww0M3p46HRPYMu/Di0exOpHPO7h65L7SskU38bVJm7zX4G6VqG0yh6CvcddernVbx0DepFEMMFI6onRY5IOh37g/xcrouK0KBpOT/D2Qc3M3eE/kAKdGNdoNJ7irgyWL8gDPHLt9njcx5Tjv42JeY344qkxMU1H4Isfh2oKh2npBjelngjm0ptYVEIX0h24u66G1dwmd1wpgJdruOUn78Cgc6mc9gEAUbVkeGTGPx4xi1hJNOc0WsDnjKKVH6GA1G54G5pODKWTHKbDpzKwf6k3tTvFCTkBIrz9bVL0KyJZN6beRDUIj5UEUOV2KfCqJwPrxR+jmiB8FmeOoGihewkgEO/+iKnyRE9w4/GXiqqBbXRWo6jrSQTzJyO96yDaj4HGAwlt2EbW/YI5ZGjwZqFu+gPIIQrblNQApBrB45b8wRkG9+3U12T1H9/M5ynewTvsfCR2mUw/TkpNsH3c2Tz9HQMpPckTjw08xkn1UO8C7KlRcgFM1blEz0fWJYt9p/fkcv5Rdv8fbkAwjdO5DhOdqc8cgVC+aTz1nBACFHuj+3nowBYBmkaAXKekoqexbXFk1IK9vO2z7EPX3Y1IlaHeFbI1JC7lhThE7+ugAaux0FZglvqyGCfS3E9eh3d7kufUSVgzmjyB9rK9dmvIe8e0xqx9itVLTFG+O9OEJN/QGOOVIXuYVPirmtXZd5Js3aJdbOaRhQ8BwgrLUlrPRB+MeiYsGedfT+dDNMUTRQ24Fl435thc9p9alLRhJEyjDdKcBzsZTwLUA06W1hGn/SbhOTHC1ZmHurwDuFjNepuX8AOQz/p/nttkBj/o/QiSeDKRPEoSi1YkilLfs2422bXkNzZdfqbQ4asTzCB2xbIJU44WhfAdQMBlMSfyo0aaaAt9/HKK28pLImgXxCbLZyQE92sw0vq4c4FbfMP7tXMtJouCg8s0feoXTf4rHd7SnPUF
 TCwDQD0H
 +pzgJ7l82N+J5i5ATs+Z/iy8dmF7rUTutK7JKnxJ3T2L7WfqEUefJNrJi8Igga0DjzgIlDk8ZMSFKoHj2CbrHw6DXUAtIsQnTVhC82BsQ2A0lrgyzMlK8LtxF13+kRQoOtSIpCEj0nPXYQgaiAQjMYUWsLCm+xwZgxAusdrft8rI18pQ8aVZGPwJ0iLIxt5HlWw4pjQ4RkZBoFzuI7u9AVrI3TzvfiN9yqsprvG4CFw6lAf2SCbB/Ka0YhbxNP0bqNJlK+fpuE07TMYFf/2mhprDAHDjvB0MjQMAE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Move library functions that abstract HugeTLB /proc and /sysfs access
from vm_util to hugepage_settings.

This will help creating common helpers that save and restore HugeTLB and
THP settings.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/gup_longterm.c     |  1 +
 tools/testing/selftests/mm/hmm-tests.c        |  2 +-
 .../testing/selftests/mm/hugepage_settings.c  | 68 +++++++++++++++++++
 .../testing/selftests/mm/hugepage_settings.h  |  8 +++
 tools/testing/selftests/mm/hugetlb-madvise.c  |  1 +
 tools/testing/selftests/mm/hugetlb-mmap.c     |  1 +
 tools/testing/selftests/mm/hugetlb-vmemmap.c  |  1 +
 tools/testing/selftests/mm/hugetlb_dio.c      |  1 +
 .../selftests/mm/hugetlb_fault_after_madv.c   |  1 +
 .../selftests/mm/hugetlb_madv_vs_map.c        |  1 +
 tools/testing/selftests/mm/thuge-gen.c        |  1 +
 tools/testing/selftests/mm/uffd-common.h      |  1 +
 .../selftests/mm/va_high_addr_switch.c        |  1 +
 tools/testing/selftests/mm/vm_util.c          | 66 ------------------
 tools/testing/selftests/mm/vm_util.h          |  3 -
 15 files changed, 87 insertions(+), 70 deletions(-)

diff --git a/tools/testing/selftests/mm/gup_longterm.c b/tools/testing/selftests/mm/gup_longterm.c
index f61150d28eb2..ab4eaf4feb7c 100644
--- a/tools/testing/selftests/mm/gup_longterm.c
+++ b/tools/testing/selftests/mm/gup_longterm.c
@@ -29,6 +29,7 @@
 #include "../../../../mm/gup_test.h"
 #include "kselftest.h"
 #include "vm_util.h"
+#include "hugepage_settings.h"
 
 static size_t pagesize;
 static int nr_hugetlbsizes;
diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index 788689497e92..409b11cad4bc 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -11,6 +11,7 @@
  */
 
 #include "kselftest_harness.h"
+#include "hugepage_settings.h"
 
 #include <errno.h>
 #include <fcntl.h>
@@ -27,7 +28,6 @@
 #include <sys/ioctl.h>
 #include <sys/time.h>
 
-
 /*
  * This is a private UAPI to the kernel test module so it isn't exported
  * in the usual include/uapi/... directory.
diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
index 87ecb309b430..ebaa621c45c6 100644
--- a/tools/testing/selftests/mm/hugepage_settings.c
+++ b/tools/testing/selftests/mm/hugepage_settings.c
@@ -1,7 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <dirent.h>
 #include <fcntl.h>
 #include <limits.h>
 #include <signal.h>
+#include <stddef.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -396,3 +398,69 @@ bool thp_is_enabled(void)
 	/* THP is considered enabled if it's either "always" or "madvise" */
 	return mode == 1 || mode == 3;
 }
+
+int detect_hugetlb_page_sizes(size_t sizes[], int max)
+{
+	DIR *dir = opendir("/sys/kernel/mm/hugepages/");
+	int count = 0;
+
+	if (!dir)
+		return 0;
+
+	while (count < max) {
+		struct dirent *entry = readdir(dir);
+		size_t kb;
+
+		if (!entry)
+			break;
+		if (entry->d_type != DT_DIR)
+			continue;
+		if (sscanf(entry->d_name, "hugepages-%zukB", &kb) != 1)
+			continue;
+		sizes[count++] = kb * 1024;
+		ksft_print_msg("[INFO] detected hugetlb page size: %zu KiB\n",
+			       kb);
+	}
+	closedir(dir);
+	return count;
+}
+
+unsigned long default_huge_page_size(void)
+{
+	unsigned long hps = 0;
+	char *line = NULL;
+	size_t linelen = 0;
+	FILE *f = fopen("/proc/meminfo", "r");
+
+	if (!f)
+		return 0;
+	while (getline(&line, &linelen, f) > 0) {
+		if (sscanf(line, "Hugepagesize:       %lu kB", &hps) == 1) {
+			hps <<= 10;
+			break;
+		}
+	}
+
+	free(line);
+	fclose(f);
+	return hps;
+}
+
+unsigned long get_free_hugepages(void)
+{
+	unsigned long fhp = 0;
+	char *line = NULL;
+	size_t linelen = 0;
+	FILE *f = fopen("/proc/meminfo", "r");
+
+	if (!f)
+		return fhp;
+	while (getline(&line, &linelen, f) > 0) {
+		if (sscanf(line, "HugePages_Free:      %lu", &fhp) == 1)
+			break;
+	}
+
+	free(line);
+	fclose(f);
+	return fhp;
+}
diff --git a/tools/testing/selftests/mm/hugepage_settings.h b/tools/testing/selftests/mm/hugepage_settings.h
index 7748a9009191..320b97e768e8 100644
--- a/tools/testing/selftests/mm/hugepage_settings.h
+++ b/tools/testing/selftests/mm/hugepage_settings.h
@@ -6,6 +6,8 @@
 #include <stddef.h>
 #include <stdint.h>
 
+/* Transparent Huge Pages (THP) */
+
 enum thp_enabled {
 	THP_NEVER,
 	THP_ALWAYS,
@@ -86,4 +88,10 @@ unsigned long thp_shmem_supported_orders(void);
 bool thp_available(void);
 bool thp_is_enabled(void);
 
+/* HugeTLB */
+
+int detect_hugetlb_page_sizes(size_t sizes[], int max);
+unsigned long default_huge_page_size(void);
+unsigned long get_free_hugepages(void);
+
 #endif /* __THP_SETTINGS_H__ */
diff --git a/tools/testing/selftests/mm/hugetlb-madvise.c b/tools/testing/selftests/mm/hugetlb-madvise.c
index 4c6c346a3af5..316384d919db 100644
--- a/tools/testing/selftests/mm/hugetlb-madvise.c
+++ b/tools/testing/selftests/mm/hugetlb-madvise.c
@@ -20,6 +20,7 @@
 #include <fcntl.h>
 #include "vm_util.h"
 #include "kselftest.h"
+#include "hugepage_settings.h"
 
 #define MIN_FREE_PAGES	20
 #define NR_HUGE_PAGES	10	/* common number of pages to map/allocate */
diff --git a/tools/testing/selftests/mm/hugetlb-mmap.c b/tools/testing/selftests/mm/hugetlb-mmap.c
index 71a444d8b1cb..5be68fbc36dc 100644
--- a/tools/testing/selftests/mm/hugetlb-mmap.c
+++ b/tools/testing/selftests/mm/hugetlb-mmap.c
@@ -17,6 +17,7 @@
 #include <fcntl.h>
 #include "vm_util.h"
 #include "kselftest.h"
+#include "hugepage_settings.h"
 
 #define LENGTH (256UL*1024*1024)
 #define PROTECTION (PROT_READ | PROT_WRITE)
diff --git a/tools/testing/selftests/mm/hugetlb-vmemmap.c b/tools/testing/selftests/mm/hugetlb-vmemmap.c
index 485a6978b40f..af5786bebfd1 100644
--- a/tools/testing/selftests/mm/hugetlb-vmemmap.c
+++ b/tools/testing/selftests/mm/hugetlb-vmemmap.c
@@ -11,6 +11,7 @@
 #include <sys/mman.h>
 #include <fcntl.h>
 #include "vm_util.h"
+#include "hugepage_settings.h"
 
 #define PAGE_COMPOUND_HEAD	(1UL << 15)
 #define PAGE_COMPOUND_TAIL	(1UL << 16)
diff --git a/tools/testing/selftests/mm/hugetlb_dio.c b/tools/testing/selftests/mm/hugetlb_dio.c
index 31a054fa8134..81e3f7bc8e76 100644
--- a/tools/testing/selftests/mm/hugetlb_dio.c
+++ b/tools/testing/selftests/mm/hugetlb_dio.c
@@ -20,6 +20,7 @@
 #include <sys/syscall.h>
 #include "vm_util.h"
 #include "kselftest.h"
+#include "hugepage_settings.h"
 
 #ifndef STATX_DIOALIGN
 #define STATX_DIOALIGN		0x00002000U
diff --git a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c b/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
index b4b257775b74..abc3904c5268 100644
--- a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
+++ b/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
@@ -10,6 +10,7 @@
 
 #include "vm_util.h"
 #include "kselftest.h"
+#include "hugepage_settings.h"
 
 #define INLOOP_ITER 100
 
diff --git a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
index c7105c6d319b..ac60b4f18784 100644
--- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
+++ b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
@@ -25,6 +25,7 @@
 #include <unistd.h>
 
 #include "vm_util.h"
+#include "hugepage_settings.h"
 
 #define INLOOP_ITER 100
 
diff --git a/tools/testing/selftests/mm/thuge-gen.c b/tools/testing/selftests/mm/thuge-gen.c
index 77813d34dcc2..1007bc8aa57c 100644
--- a/tools/testing/selftests/mm/thuge-gen.c
+++ b/tools/testing/selftests/mm/thuge-gen.c
@@ -28,6 +28,7 @@
 #include <string.h>
 #include "vm_util.h"
 #include "kselftest.h"
+#include "hugepage_settings.h"
 
 #if !defined(MAP_HUGETLB)
 #define MAP_HUGETLB	0x40000
diff --git a/tools/testing/selftests/mm/uffd-common.h b/tools/testing/selftests/mm/uffd-common.h
index 844a85ab31eb..6c5aca9cb63e 100644
--- a/tools/testing/selftests/mm/uffd-common.h
+++ b/tools/testing/selftests/mm/uffd-common.h
@@ -37,6 +37,7 @@
 
 #include "kselftest.h"
 #include "vm_util.h"
+#include "hugepage_settings.h"
 
 #define UFFD_FLAGS	(O_CLOEXEC | O_NONBLOCK | UFFD_USER_MODE_ONLY)
 
diff --git a/tools/testing/selftests/mm/va_high_addr_switch.c b/tools/testing/selftests/mm/va_high_addr_switch.c
index 5741fd057640..d42ad50eb2d3 100644
--- a/tools/testing/selftests/mm/va_high_addr_switch.c
+++ b/tools/testing/selftests/mm/va_high_addr_switch.c
@@ -11,6 +11,7 @@
 
 #include "vm_util.h"
 #include "kselftest.h"
+#include "hugepage_settings.h"
 
 /*
  * The hint addr value is used to allocate addresses
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index db94564f4431..e62e2a473123 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -291,53 +291,6 @@ int64_t allocate_transhuge(void *ptr, int pagemap_fd)
 	return -1;
 }
 
-unsigned long default_huge_page_size(void)
-{
-	unsigned long hps = 0;
-	char *line = NULL;
-	size_t linelen = 0;
-	FILE *f = fopen("/proc/meminfo", "r");
-
-	if (!f)
-		return 0;
-	while (getline(&line, &linelen, f) > 0) {
-		if (sscanf(line, "Hugepagesize:       %lu kB", &hps) == 1) {
-			hps <<= 10;
-			break;
-		}
-	}
-
-	free(line);
-	fclose(f);
-	return hps;
-}
-
-int detect_hugetlb_page_sizes(size_t sizes[], int max)
-{
-	DIR *dir = opendir("/sys/kernel/mm/hugepages/");
-	int count = 0;
-
-	if (!dir)
-		return 0;
-
-	while (count < max) {
-		struct dirent *entry = readdir(dir);
-		size_t kb;
-
-		if (!entry)
-			break;
-		if (entry->d_type != DT_DIR)
-			continue;
-		if (sscanf(entry->d_name, "hugepages-%zukB", &kb) != 1)
-			continue;
-		sizes[count++] = kb * 1024;
-		ksft_print_msg("[INFO] detected hugetlb page size: %zu KiB\n",
-			       kb);
-	}
-	closedir(dir);
-	return count;
-}
-
 int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags)
 {
 	size_t count;
@@ -396,25 +349,6 @@ int uffd_unregister(int uffd, void *addr, uint64_t len)
 	return ret;
 }
 
-unsigned long get_free_hugepages(void)
-{
-	unsigned long fhp = 0;
-	char *line = NULL;
-	size_t linelen = 0;
-	FILE *f = fopen("/proc/meminfo", "r");
-
-	if (!f)
-		return fhp;
-	while (getline(&line, &linelen, f) > 0) {
-		if (sscanf(line, "HugePages_Free:      %lu", &fhp) == 1)
-			break;
-	}
-
-	free(line);
-	fclose(f);
-	return fhp;
-}
-
 static bool check_vmflag(void *addr, const char *flag)
 {
 	char buffer[MAX_LINE_LENGTH];
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 1a07305ceff4..195bf2e26792 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -94,8 +94,6 @@ bool check_huge_anon(void *addr, int nr_hpages, uint64_t hpage_size);
 bool check_huge_file(void *addr, int nr_hpages, uint64_t hpage_size);
 bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size);
 int64_t allocate_transhuge(void *ptr, int pagemap_fd);
-unsigned long default_huge_page_size(void);
-int detect_hugetlb_page_sizes(size_t sizes[], int max);
 int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags);
 
 int uffd_register(int uffd, void *addr, uint64_t len,
@@ -103,7 +101,6 @@ int uffd_register(int uffd, void *addr, uint64_t len,
 int uffd_unregister(int uffd, void *addr, uint64_t len);
 int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
 			      bool miss, bool wp, bool minor, uint64_t *ioctls);
-unsigned long get_free_hugepages(void);
 bool check_vmflag_io(void *addr);
 bool check_vmflag_pfnmap(void *addr);
 bool check_vmflag_guard(void *addr);
-- 
2.53.0


