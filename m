Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 396A7CD5BA4
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 11:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A69CC6B0092; Thu, 21 May 2026 07:20:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CC106B0093; Thu, 21 May 2026 07:20:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BB506B0096; Thu, 21 May 2026 07:20:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 77F406B0092
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:20:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 12D06A05EA
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:20:10 +0000 (UTC)
X-FDA: 84791182980.26.73407D8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 420F440002
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:20:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HRDBtL8A;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779362408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AmIHY9vT9qgoNTrW26Bw0HOE9XP8UuQffBw9XnRNIeU=;
	b=ONrqGe8lMqYcsWn8P4nE9rYafe9TZ2jNEQuJCFuo9qtsbDLvh8qxCW8FPiwpPm7zGhbh1b
	3STBokFhGZu338CcCrqtWFShpPIAb1/m0RUtlHrDID4LJkA4aN/CKPXKQdgFeNEA2xXWB1
	s4mgb+MfGMfPIMy4isQ60iHruD8r4kE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779362408; a=rsa-sha256;
	cv=none;
	b=eNBaMlLPUYrmDIw4ujLtNfgP7k7Zm7S9TC8gXTPTCnxsNRU6gQNEJ+8/e5EcC1PH/SMVZy
	SdsXmVsnLKDOky2RCjtGif9hCNZOZj/Mfd023WXuy7xf/EvRvTyqw1sAGwaJswawnIPMh1
	qWv51DAb9kdwsJ7mWJ3uddNdJ2hYsrQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HRDBtL8A;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EFA7D3D6A;
	Thu, 21 May 2026 04:20:01 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.82])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8FC963F7B4;
	Thu, 21 May 2026 04:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779362407; bh=R4TXY7ofugRmB5Qu307mZbDEqHIIyQvOO7RJJMPiTSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HRDBtL8AFefQ0JgqYJ/Pqsa0kuJKBfB/GI6JL028A8uGzgONZ8D9gyjy8me5M13du
	 hTT5YMoCw6IvJS5Z3vKv/F+kb4t1x/RvHWTjdxTPbbWsU6wkW40OPEW0fxkt9aYGuK
	 ozHWXnh0wgJnAi/97pc603Uu6tTr0mNgIzvNhmDs=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
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
	Lance Yang <lance.yang@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v3 1/4] tools/lib/mm: add shared file helpers
Date: Thu, 21 May 2026 16:47:58 +0530
Message-ID: <20260521111801.173019-2-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260521111801.173019-1-sarthak.sharma@arm.com>
References: <20260521111801.173019-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 420F440002
X-Rspamd-Server: rspam04
X-Stat-Signature: 7cg7ezgscsr9zqro5tpzpsirri4z8qjd
X-HE-Tag: 1779362408-451314
X-HE-Meta: U2FsdGVkX18C+oYnD2n+QcRpVyiDnI5bgKJAZp9L8If/XN2QmTBaBvcR0x47sul43Dw4AqA74mNTvVJrQVaBJjvfJ3MiptFCkd/fbweXnYbtCbwZRbT7JPPQqNjGIilNuQcURUyGTLqldrBL7P7HTQ/HhcqlvegNipV4b/8I2AJ3qU+MMab3SxPMM3UT+E9DJ2gVbVCI1qwl5LBYPj92mAG/5151DiP6wMHuhcR8OiS+dR+kgHydqiOrs0efBiUSCgM/AwEK9OiGUATpBWW0xw+6dyK8l2zlgCsilHN8w7nF0f61rCgM+G1/eK2DUpZaFcSxbRlqwCgoGS0vRL8aNkmC0B3dDMBJfDwk/kQBOrxwySB7k0BEil4AJXhPH1ABWU0LwsEXP4W4lj9eeaQ1a+8uL0MuftCjaX86c0MWJuFOe90cXBfPwNm+7yvM8dCGOv+4R+oJ2HZDS9basoB2oCgkapqSo1D35NPZWMFsQ8ucCGAc4bLQCMgRJBkS8IUp5z/kZnfT1Ka7yqLObH2OQfforhY5XrkeWaIEvTThWs+SAxH3MHad5HWnaszJfPImrygOkqvCB7pfVS3+OpMJaAYYp3WDpBZ+ZRtNAXHsHKl5sYc23FOrhqytxfJuFXSBm96lrwrPq3PfMBXgMTSTQbTihbFenexrmFTgxcHPVlcXbDory3/oVNpVauzBQMyKf/29sr4wf+jaKN+cz2LEu0adxDfRMEI58OKLhHKy+Cmrwp17iq06S33jJxPHbuBbOHH6PUITpWeZ5yLsIeWDwn+kQSGsN8o4+jJ4JmI+IyrdWNwoNLsKWUCzNI6/av22bZCFUmJ3+ajHFBE28AEe+Pnc1qImNKVkOPiCx9j2l3AOh0TMyAYcdybOa3kAgzy3FhZnNPub8eiPZ1umcCj0NrK1ec0GeNMllrV+w0pp+odunCXu1CMoqjbqTnsi9w8cMgvB0Rgz21FUNI6iOwf
 n/hRR6hp
 EsbwQdv1STa5kyv9lDR2ftL24fDL5XPBdSpIZjdTHXIDp4hJhmIesF4JjxvZvVien7oJep5K9q8qmd30SGU0XTT5QhxT95DuNhY+7cQE/EFFkf6sQv56Ind1vj9uNMDeP/kWEqAY7lBSVScM3CaNCCMhQ/XwPfzwI27UHpRfSzqSWgEWbwviH40kd+SdPdqE6GqdSqphTIUkzMmz0Y+zIDJX391LY7t2nDPSUpRUUN9o7VYlJRBv92BjIuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move read_file(), write_file(), read_num(), and write_num() out of
tools/testing/selftests/mm/vm_util.c into a new shared helper under
tools/lib/mm/.

These helpers are used by mm selftests today and will also be needed by
shared hugepage helpers in subsequent patches. Move them to a generic
location and drop the kselftest-specific dependency from their
implementation so they can be reused outside selftests as well.

Update the current mm selftest users to include the new header directly,
and link the new helper into the selftests/mm build.

Add tools/lib/mm/ to the MEMORY MANAGEMENT - MISC entry in MAINTAINERS.

Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 MAINTAINERS                                   |  1 +
 tools/lib/mm/file_utils.c                     | 83 +++++++++++++++++++
 tools/lib/mm/file_utils.h                     | 12 +++
 tools/testing/selftests/mm/Makefile           |  6 +-
 .../testing/selftests/mm/hugepage_settings.c  |  3 +-
 tools/testing/selftests/mm/khugepaged.c       |  1 +
 .../selftests/mm/split_huge_page_test.c       |  2 +
 tools/testing/selftests/mm/vm_util.c          | 65 +--------------
 tools/testing/selftests/mm/vm_util.h          |  5 --
 9 files changed, 106 insertions(+), 72 deletions(-)
 create mode 100644 tools/lib/mm/file_utils.c
 create mode 100644 tools/lib/mm/file_utils.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 46ed0f0e76d8..7887a3263373 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16936,6 +16936,7 @@ F:	mm/memory-tiers.c
 F:	mm/page_idle.c
 F:	mm/pgalloc-track.h
 F:	mm/process_vm_access.c
+F:	tools/lib/mm/
 F:	tools/testing/selftests/mm/
 
 MEMORY MANAGEMENT - NUMA MEMBLOCKS AND NUMA EMULATION
diff --git a/tools/lib/mm/file_utils.c b/tools/lib/mm/file_utils.c
new file mode 100644
index 000000000000..0f9322f2cf41
--- /dev/null
+++ b/tools/lib/mm/file_utils.c
@@ -0,0 +1,83 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+
+#include "file_utils.h"
+
+int read_file(const char *path, char *buf, size_t buflen)
+{
+	int fd;
+	ssize_t numread;
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)
+		return 0;
+
+	numread = read(fd, buf, buflen - 1);
+	if (numread < 1) {
+		close(fd);
+		return 0;
+	}
+
+	buf[numread] = '\0';
+	close(fd);
+
+	return (unsigned int)numread;
+}
+
+void write_file(const char *path, const char *buf, size_t buflen)
+{
+	int fd, saved_errno;
+	ssize_t numwritten;
+
+	if (buflen < 2) {
+		fprintf(stderr, "Incorrect buffer len: %zu\n", buflen);
+		exit(EXIT_FAILURE);
+	}
+
+	fd = open(path, O_WRONLY);
+	if (fd == -1) {
+		fprintf(stderr, "%s open failed: %s\n", path, strerror(errno));
+		exit(EXIT_FAILURE);
+	}
+
+	numwritten = write(fd, buf, buflen - 1);
+	saved_errno = errno;
+	close(fd);
+	errno = saved_errno;
+	if (numwritten < 0) {
+		fprintf(stderr, "%s write(%.*s) failed: %s\n",
+			path, (int)(buflen - 1), buf, strerror(errno));
+		exit(EXIT_FAILURE);
+	}
+	if (numwritten != (ssize_t)(buflen - 1)) {
+		fprintf(stderr,
+			"%s write(%.*s) is truncated, expected %zu bytes, got %zd bytes\n",
+			path, (int)(buflen - 1), buf, buflen - 1, numwritten);
+		exit(EXIT_FAILURE);
+	}
+}
+
+unsigned long read_num(const char *path)
+{
+	char buf[21];
+
+	if (read_file(path, buf, sizeof(buf)) < 0) {
+		perror("read_file()");
+		exit(EXIT_FAILURE);
+	}
+
+	return strtoul(buf, NULL, 10);
+}
+
+void write_num(const char *path, unsigned long num)
+{
+	char buf[21];
+
+	snprintf(buf, sizeof(buf), "%lu", num);
+	write_file(path, buf, strlen(buf) + 1);
+}
diff --git a/tools/lib/mm/file_utils.h b/tools/lib/mm/file_utils.h
new file mode 100644
index 000000000000..060a84725c9d
--- /dev/null
+++ b/tools/lib/mm/file_utils.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __MM_FILE_UTILS_H__
+#define __MM_FILE_UTILS_H__
+
+#include <stddef.h>
+
+int read_file(const char *path, char *buf, size_t buflen);
+void write_file(const char *path, const char *buf, size_t buflen);
+unsigned long read_num(const char *path);
+void write_num(const char *path, unsigned long num);
+
+#endif
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index e6df968f0971..b5fb4b6ab31b 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -37,7 +37,7 @@ endif
 # LDLIBS.
 MAKEFLAGS += --no-builtin-rules
 
-CFLAGS = -Wall -O2 -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
+CFLAGS = -Wall -O2 -I $(top_srcdir) -I $(top_srcdir)/tools/lib $(EXTRA_CFLAGS) $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
 CFLAGS += -Wunreachable-code
 LDLIBS = -lrt -lpthread -lm
 
@@ -187,8 +187,8 @@ TEST_FILES += write_hugetlb_memory.sh
 
 include ../lib.mk
 
-$(TEST_GEN_PROGS): vm_util.c hugepage_settings.c
-$(TEST_GEN_FILES): vm_util.c hugepage_settings.c
+$(TEST_GEN_PROGS): vm_util.c hugepage_settings.c $(top_srcdir)/tools/lib/mm/file_utils.c
+$(TEST_GEN_FILES): vm_util.c hugepage_settings.c $(top_srcdir)/tools/lib/mm/file_utils.c
 
 $(OUTPUT)/uffd-stress: uffd-common.c
 $(OUTPUT)/uffd-unit-tests: uffd-common.c
diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
index 2eab2110ac6a..5e947abb7425 100644
--- a/tools/testing/selftests/mm/hugepage_settings.c
+++ b/tools/testing/selftests/mm/hugepage_settings.c
@@ -8,8 +8,9 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
+#include <mm/file_utils.h>
 
-#include "vm_util.h"
+#include "kselftest.h"
 #include "hugepage_settings.h"
 
 #define THP_SYSFS "/sys/kernel/mm/transparent_hugepage/"
diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 10e8dedcb087..ae5945e2bfac 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -18,6 +18,7 @@
 #include <sys/stat.h>
 #include <sys/sysmacros.h>
 #include <sys/vfs.h>
+#include <mm/file_utils.h>
 
 #include "linux/magic.h"
 
diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 50c80ceb4988..4a2ccc055c8b 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -19,6 +19,8 @@
 #include <malloc.h>
 #include <stdbool.h>
 #include <time.h>
+#include <mm/file_utils.h>
+
 #include "vm_util.h"
 #include "kselftest.h"
 #include "hugepage_settings.h"
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 311fc5b4513e..631dc2baff97 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -8,6 +8,8 @@
 #include <linux/fs.h>
 #include <sys/syscall.h>
 #include <unistd.h>
+#include <mm/file_utils.h>
+
 #include "kselftest.h"
 #include "vm_util.h"
 
@@ -698,69 +700,6 @@ int unpoison_memory(unsigned long pfn)
 	return ret > 0 ? 0 : -errno;
 }
 
-int read_file(const char *path, char *buf, size_t buflen)
-{
-	int fd;
-	ssize_t numread;
-
-	fd = open(path, O_RDONLY);
-	if (fd == -1)
-		return 0;
-
-	numread = read(fd, buf, buflen - 1);
-	if (numread < 1) {
-		close(fd);
-		return 0;
-	}
-
-	buf[numread] = '\0';
-	close(fd);
-
-	return (unsigned int) numread;
-}
-
-void write_file(const char *path, const char *buf, size_t buflen)
-{
-	int fd, saved_errno;
-	ssize_t numwritten;
-
-	if (buflen < 2)
-		ksft_exit_fail_msg("Incorrect buffer len: %zu\n", buflen);
-
-	fd = open(path, O_WRONLY);
-	if (fd == -1)
-		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
-
-	numwritten = write(fd, buf, buflen - 1);
-	saved_errno = errno;
-	close(fd);
-	errno = saved_errno;
-	if (numwritten < 0)
-		ksft_exit_fail_msg("%s write(%.*s) failed: %s\n", path, (int)(buflen - 1),
-				buf, strerror(errno));
-	if (numwritten != buflen - 1)
-		ksft_exit_fail_msg("%s write(%.*s) is truncated, expected %zu bytes, got %zd bytes\n",
-				path, (int)(buflen - 1), buf, buflen - 1, numwritten);
-}
-
-unsigned long read_num(const char *path)
-{
-	char buf[21];
-
-	if (read_file(path, buf, sizeof(buf)) < 0)
-		ksft_exit_fail_perror("read_file()");
-
-	return strtoul(buf, NULL, 10);
-}
-
-void write_num(const char *path, unsigned long num)
-{
-	char buf[21];
-
-	sprintf(buf, "%lu", num);
-	write_file(path, buf, strlen(buf) + 1);
-}
-
 static unsigned long shmall, shmmax;
 
 void __shm_limits_restore(void)
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index ea8fc8fdf0eb..d0932cdd9a34 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -164,11 +164,6 @@ int unpoison_memory(unsigned long pfn);
 #define PAGEMAP_PRESENT(ent)	(((ent) & (1ull << 63)) != 0)
 #define PAGEMAP_PFN(ent)	((ent) & ((1ull << 55) - 1))
 
-void write_file(const char *path, const char *buf, size_t buflen);
-int read_file(const char *path, char *buf, size_t buflen);
-unsigned long read_num(const char *path);
-void write_num(const char *path, unsigned long num);
-
 void shm_limits_prepare(unsigned long length);
 void __shm_limits_restore(void);
 
-- 
2.39.5


