Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 970CACD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 14:25:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07E2E6B00F7; Wed, 27 May 2026 10:25:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02EF86B00F9; Wed, 27 May 2026 10:25:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E602B6B00FA; Wed, 27 May 2026 10:25:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D08BA6B00F7
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:25:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F4E41C1D46
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:25:14 +0000 (UTC)
X-FDA: 84813422148.05.88E0B0C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6DA0140010
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:25:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mz0g71Zg;
	spf=pass (imf27.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779891912; a=rsa-sha256;
	cv=none;
	b=YeP4loJ2mMMdL38bo7vBoreQtwMK0rOiAvLZWO2Qk94kUGJ2TvDj1sCIXEsTQOmkHMNiCd
	v82icTWuq85S7VETclzjwm8pPsSmIyxRYIVAUrzu/Nk+qOog7ltYhVfeyxDf9laNQa+Hlz
	fZXyZzEObzHpJE99TQG8bV42mrhktxU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mz0g71Zg;
	spf=pass (imf27.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779891912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vOuF1fvXCpMfLqXOc0icDHilh/dflKZs41MzdF9c7qo=;
	b=XMBL8wnZJsq8YbN1XPX4k4PH7xWmBmBuReWtyc447yaaWPwmua7GBernIHQpUEgt2/JM2F
	gzNxi1WkYSwQM3z7xEZQ4rcQIpxDzOfYH0lULJZDcNYIJlzTFyl+KBgOoFx4gs6UWPwqKC
	11Y8rJgJrYhWGs3WH09gjEya1teBnQQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 468F827B5;
	Wed, 27 May 2026 07:25:06 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.82])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D47653F905;
	Wed, 27 May 2026 07:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779891911; bh=HbanYL7EP3DG/8UNgIVFx2Gl5bPxfKd9NFC21trX438=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mz0g71ZgF2HVY6JVKWa0LeiCiqk2vNWfsaOWj+wQIBZCW7szyaL6CllcczkiPQE5M
	 YcGauLzycdIB6EIOG7Gl+J6VjwHx/ThHHDtRgaqOmR6Mihn2TYQsQ9M6lc03bEDhIb
	 P3uhnW1uBwFAsy3MZhrdvn2ZBAiX5+J4KdjILt9A=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Mark Brown <broonie@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v4 2/5] tools/lib/mm: add shared file helpers
Date: Wed, 27 May 2026 19:54:29 +0530
Message-ID: <20260527142432.230127-3-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260527142432.230127-1-sarthak.sharma@arm.com>
References: <20260527142432.230127-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6DA0140010
X-Stat-Signature: 3ck6ggs8r13td1qfj9imoz9rcmfsffe1
X-HE-Tag: 1779891912-734312
X-HE-Meta: U2FsdGVkX1+6c447G9hTayvRk7GWMedRQFeXqD0enyDqKn1chAWnQHB4din3MqfDpW+4fJGyoGhEb+TQaQ6FSQzcO+FSvT+7KUeJ+HRzfbcYE8+5z4M2lrS+LP2X0xIsnuhnfcUfLnVU9306SXmnxTRulhXVIBzHUbafGjPwiIJ399mHnOGWUjzAi9MeJ0Sh7XHtzQJvg7adrhtsfl/rXtr2z03EHTq9pzxNPEHIYb+kxInL6FFE14s4BTJilowERm2udqcIq1V2GZu7mixOIxQzGnhuFLcoo0jBomkXjYaMJOLwvu5l5adMoTZZwUY5G4B5BkF0fFHkMw0yu1aA08cuyDenLiybaW0xLqo4N3zwaW8H0jyVjQwRASj2V/ZdJ/sG4qo1pkcPKkIwUcbTQXJL27X1xxuVOGv7VyMVwdk2IR2b6Iqnft0zuPSrYkIguigrm3c1MbbSTwp6txXQGCEbOibmW4Ijvd1qy/RckcjqielkxZj9/y36/VnZxAr4tQ+NFR5PW37Vl4PdkIgTkZPCdl0oZmy23hzxRsklytT4rR8XGI8p+d/Pd0fxvch85u0Azh7VzwYSy0xokM8PaQKfeHtbk1g3wVRldlR2v4YKpWuEbzNPq4qRJGE7kdmyY5M3wnB3pkRQ3guG0XApJI5QthBZrHvMqDnbNLmO1I+fUD4WdXux08XymHJ+DM5+/fT2mp9koV679A8G8NNS0Ly7ILKz25Ajoj8LDIo344STwW0DrlhohteGalLfHfmsC00x255+7apihqySfmk+HYUgZcCYJvKqMAJ6l6P5G9GzBE0/jmEa3Qx3lQdOTFvhNFE/HCkBS7nMhvn1FawTE0KcHDrJrYCKYqdGtVh5h5RVG4OWoVrkEeN00HMiacaRI+SjqNAJZW37GJy3sUt9hDRYOOlSjNe3WNJTcl+A3ArfbqCkEvoXdbERIHLzacuRBECM+ROPcigrGkeyCET
 7qLD8jyR
 Z1W17Tj5J/vzbO3t0W2vfC1SrWTQotZIPp3tRBHNQpWX1V5Tct06UyFXEMojb21inCg2MNyvT3ue0bziKAUA3/VYDDLN5F6BAraTd/+OjL9Zj5TrPYwvkpAcXIOnmr49Ve+WBxFNLOwAlSSisM4bcpUGg6p2RYeVYufYazIq91CyM7ijALSV9zL1TjURGOYoDwxETEW53QVrwcwOakUDIaxF9dIMeaZBAJnnaK4Gvih142To5D/EQTDxV6A==
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
location so they can be reused outside selftests as well.

Keep the helpers exposed to mm selftests through vm_util.h by including
the new shared header there, and link the new helper into the
selftests/mm build.

Add tools/lib/mm/ to the MEMORY MANAGEMENT - MISC entry in MAINTAINERS.

Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 MAINTAINERS                          |  1 +
 tools/lib/mm/file_utils.c            | 82 ++++++++++++++++++++++++++++
 tools/lib/mm/file_utils.h            | 12 ++++
 tools/testing/selftests/mm/Makefile  |  6 +-
 tools/testing/selftests/mm/vm_util.c | 73 -------------------------
 tools/testing/selftests/mm/vm_util.h |  6 +-
 6 files changed, 99 insertions(+), 81 deletions(-)
 create mode 100644 tools/lib/mm/file_utils.c
 create mode 100644 tools/lib/mm/file_utils.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 6a123fd3cfd5..5d2f72bbd128 100644
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
index 000000000000..00610013e80e
--- /dev/null
+++ b/tools/lib/mm/file_utils.c
@@ -0,0 +1,82 @@
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
+	if (buflen < 2)
+		return -EINVAL;
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)
+		return -errno;
+
+	numread = read(fd, buf, buflen - 1);
+	if (numread < 1) {
+		int err = numread ? -errno : -ENODATA;
+
+		close(fd);
+		return err;
+	}
+
+	buf[numread] = '\0';
+	close(fd);
+
+	return (int)numread;
+}
+
+int write_file(const char *path, const char *buf, size_t buflen)
+{
+	int fd, saved_errno;
+	ssize_t numwritten;
+
+	if (buflen < 2)
+		return -EINVAL;
+
+	fd = open(path, O_WRONLY);
+	if (fd == -1)
+		return -errno;
+
+	numwritten = write(fd, buf, buflen - 1);
+	saved_errno = errno;
+	close(fd);
+	if (numwritten < 0)
+		return -saved_errno;
+	if (numwritten != (ssize_t)(buflen - 1))
+		return -EIO;
+
+	return 0;
+}
+
+int read_num(const char *path, unsigned long *num)
+{
+	char buf[21];
+	int ret;
+
+	if (!num)
+		return -EINVAL;
+
+	ret = read_file(path, buf, sizeof(buf));
+	if (ret < 0)
+		return ret;
+
+	*num = strtoul(buf, NULL, 10);
+	return 0;
+}
+
+int write_num(const char *path, unsigned long num)
+{
+	char buf[21];
+
+	snprintf(buf, sizeof(buf), "%lu", num);
+	return write_file(path, buf, strlen(buf) + 1);
+}
diff --git a/tools/lib/mm/file_utils.h b/tools/lib/mm/file_utils.h
new file mode 100644
index 000000000000..38576790a342
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
+int write_file(const char *path, const char *buf, size_t buflen);
+int read_num(const char *path, unsigned long *num);
+int write_num(const char *path, unsigned long num);
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
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 290e5c29123e..b3ee00d71aa3 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -698,79 +698,6 @@ int unpoison_memory(unsigned long pfn)
 	return ret > 0 ? 0 : -errno;
 }
 
-int read_file(const char *path, char *buf, size_t buflen)
-{
-	int fd;
-	ssize_t numread;
-
-	if (buflen < 2)
-		return -EINVAL;
-
-	fd = open(path, O_RDONLY);
-	if (fd == -1)
-		return -errno;
-
-	numread = read(fd, buf, buflen - 1);
-	if (numread < 1) {
-		int err = numread ? -errno : -ENODATA;
-
-		close(fd);
-		return err;
-	}
-
-	buf[numread] = '\0';
-	close(fd);
-
-	return (int)numread;
-}
-
-int write_file(const char *path, const char *buf, size_t buflen)
-{
-	int fd, saved_errno;
-	ssize_t numwritten;
-
-	if (buflen < 2)
-		return -EINVAL;
-
-	fd = open(path, O_WRONLY);
-	if (fd == -1)
-		return -errno;
-
-	numwritten = write(fd, buf, buflen - 1);
-	saved_errno = errno;
-	close(fd);
-	if (numwritten < 0)
-		return -saved_errno;
-	if (numwritten != buflen - 1)
-		return -EIO;
-
-	return 0;
-}
-
-int read_num(const char *path, unsigned long *num)
-{
-	char buf[21];
-	int ret;
-
-	if (!num)
-		return -EINVAL;
-
-	ret = read_file(path, buf, sizeof(buf));
-	if (ret < 0)
-		return ret;
-
-	*num = strtoul(buf, NULL, 10);
-	return 0;
-}
-
-int write_num(const char *path, unsigned long num)
-{
-	char buf[21];
-
-	sprintf(buf, "%lu", num);
-	return write_file(path, buf, strlen(buf) + 1);
-}
-
 static unsigned long shmall, shmmax;
 
 void __shm_limits_restore(void)
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 28c3d7c1faed..d45135283732 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -8,6 +8,7 @@
 #include <unistd.h> /* _SC_PAGESIZE */
 #include "kselftest.h"
 #include <linux/fs.h>
+#include <mm/file_utils.h>
 
 #define BIT_ULL(nr)                   (1ULL << (nr))
 #define PM_SOFT_DIRTY                 BIT_ULL(55)
@@ -164,11 +165,6 @@ int unpoison_memory(unsigned long pfn);
 #define PAGEMAP_PRESENT(ent)	(((ent) & (1ull << 63)) != 0)
 #define PAGEMAP_PFN(ent)	((ent) & ((1ull << 55) - 1))
 
-int read_file(const char *path, char *buf, size_t buflen);
-int write_file(const char *path, const char *buf, size_t buflen);
-int read_num(const char *path, unsigned long *num);
-int write_num(const char *path, unsigned long num);
-
 void shm_limits_prepare(unsigned long length);
 void __shm_limits_restore(void);
 
-- 
2.39.5


