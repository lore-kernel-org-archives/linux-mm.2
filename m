Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94B3AFF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:45:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CC1D6B00C0; Tue, 28 Apr 2026 16:45:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A3AF6B00C2; Tue, 28 Apr 2026 16:45:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFAE66B00C3; Tue, 28 Apr 2026 16:45:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DACC26B00C0
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:45:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 98337874CA
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:45:25 +0000 (UTC)
X-FDA: 84709145010.22.14856E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id D26CD10000A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:45:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PNXy3J1j;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yg+0jF/+ToZXg7xdDUopUZii2FuVPVSSFM8tiEmcuew=;
	b=1TI0c7Dzmg6niiypaIkw9gKPKjKBKxW49VxNBFnsJYgmZcF/03hcAUn5KB2mA2U0ne1XlA
	ogA2meGha/I+OCi5y3nsLJxGzVsuqwCBeeQY9IAf+MkLO5E2GeHf1/sToEV56fS1qYOes7
	y+McSjnjWflqRFsk1xn6TiDakVZs2ng=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PNXy3J1j;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409124; a=rsa-sha256;
	cv=none;
	b=UEjK6CRtj/66uCMowQll34QFglhVQ9v0OsT9mZdG+Vi3xo8de1A6ogxuTqybMYSIWB/44R
	ZHJox/JPrzcVW6adf/AQrQj+apNUO5q5uZkMIBYACaEn6I+uLdFHKHFwFrZ+v5OeaVTlHs
	XztkmMtKCyV4ZJoHVrlbAmVBz0B90FE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 09D50402EA;
	Tue, 28 Apr 2026 20:45:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE30C2BCB3;
	Tue, 28 Apr 2026 20:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409122;
	bh=1kInTRxPtmsL3CGo2Vf9dpLuXJPc/YEBelMYPMeVdwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PNXy3J1j+d5x6Tr7wNZh2ACxXgkDf46Bcw7UUJT6SCpITo85qrz9S9ttIvSCbAvbD
	 kuOgtUUAWDBi7o0LsVrfg3eaP6nXAqE4JF6O65EplRfEl+MDFxAQyLghHyqdN0MyLu
	 QAOJXinFry9vMe98kZkgsXADq+85e4y0g5vH8e9Ku8LsMLL/05Y01v8O8g7WUEBgCG
	 c+r/1czU/0fUw9zCxBc8cWqXx3Sp6AUg//bScWE+h0NviZeZJsk0KzuQyrXJ0PmyBb
	 z6y+PsM/GLci/zeuyEXglqqHN0H40korranmbrt+L6IaWADAIZZriap/pXVxKi7mHH
	 cTRE17LY6mcyw==
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
Subject: [PATCH v3 23/54] selftests/mm: move HugeTLB helpers to hugepage_settings
Date: Tue, 28 Apr 2026 23:42:09 +0300
Message-ID: <20260428204240.1924129-24-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D26CD10000A
X-Rspam-User: 
X-Stat-Signature: wj3mo3o4cirzy4ghipet9kgp8x5u7dis
X-HE-Tag: 1777409123-331311
X-HE-Meta: U2FsdGVkX19+06Qamw2d9QdUDC8pmbr6+xmSQO/Rc1La68CXS55ZyvGCmnp9G8EQviEkdFE/a7ZM8yaz/jsQw/R+WVtitzJjgR5RgqTfJnwsWhF7PV3FYU/G5kJMn5BmMIFo0MY23DJfhFeRRENXN5kekJ4aB+YEI8vuKoH1yrecPa+lgcGx/Lsku8AfaoDJtQFbNbRJyXI3xYKHuyLmg1yNETq59Ccmi6ICdk2RoDoiHvYG8LLQ9BIUj8r3IIhZcKucwNfyq1Pw0XEfVEAv3biglELiT3QTKSamYNleZtirjg0KCN7kNzkcTXtLB9IoaxeBJE9JQwTI2qLWByd/naIq3tZenlasyiZZoS6ssCL5GR9jEaod1eYRvLhCRginFqTIIFbHFgYsZq/QK5hCwdA3FEeLuHE+DIr7xc6/TQDsb8O8IQ1FD578ii1qWVWn0BINh6bt1HFLRjJWWHgPBlgYWd5DN7RhyzMMLbTjSz6hoQDYdqFjEVtie8jBbgpiTNCGMzn4uo164Ff3zMK0qVuX1+vok7xgg8bFdIrpkhig6RJLJQGO/1LlvENLpmmLsZnlAD6Cm3v/6AQRKqlF9A83esSf+7YGGhxbafPbqcJMVzZ9G+gi/5jKy5F9wO0vl3iiK11m3v57YW9eY/fRbmJkx7EpdKi7X14+WRsyp5NJW9wReWK8m3Ha5p/IgrXE4gvIcvYyw+tLgxyu1kHU9geaRMWsQ1gK6SkS+CQVRTie+u/gNFYx3cI7QVlQHEgnspoVCGRxigCAwXlyIrB1mfyLLqUZHbFxDHb8rEAzO27PYIkFU1dpAstJKM0trSDWFoBGoYLl9ZcmFt4gvqM95vOXEiThl6zmxyxoTqk8fVfIds/rH+qkLc+QWYujfc/pL704dEk43ujtt+uhbFjRcpm1tOX43xmHgAbRTnvAWUIMjx93xB3hSKV7p0N3ivCCquKq+LjxzaYrGCEIj05
 tpdeYiTn
 xsGa69iav+JjGr/1MMvFfy+/QyCqh/JCRwoDnj2wrR4UacKDiA0rQzqfbaCGdPH6JDJJcQwqgejVMkrz7Pe+Vghzk5j6TK9Rf0CMSUG0t10BOcsi3pkGxKMl0m6uv3AyWoYZI2FUsNs+G1ILG8AdXAuG+bIjPTSHykRLzW1XeNz83F4V4TbuRuTmXSAI8E9KDwbusjui4wpNbv0sncLbr5Dr1a7X/KUmBERmTqU6Yjtw2Ie2xyhuTJ6KRFuEb8CFqyW63gnPKng7j3kI3gtCDnstPMJV5tFrk5tT9
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
index 9f5ea8d6d656..031085cb7d17 100644
--- a/tools/testing/selftests/mm/hugetlb-mmap.c
+++ b/tools/testing/selftests/mm/hugetlb-mmap.c
@@ -18,6 +18,7 @@
 #include <linux/memfd.h>
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
index 5d38735ea60e..0b69bd4b901d 100644
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


