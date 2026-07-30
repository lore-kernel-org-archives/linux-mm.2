Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CBD5C55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 14:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96F1B6B00A4; Thu, 30 Jul 2026 10:08:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 945E16B00A6; Thu, 30 Jul 2026 10:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 836096B00A7; Thu, 30 Jul 2026 10:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5E1A56B00A4
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:08:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EF67316017C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:08:57 +0000 (UTC)
X-FDA: 85045624314.15.3C8C8CF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3121140014
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:08:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fdpK5EYP;
	spf=pass (imf27.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785420536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jdh/VL9qm8gWytB+mX4Eq2Uh/aglnx5UkODoi4DoEfw=;
	b=6DmIdUGRZz4ZvpkUFKqbJxpUm5H7xl4xY6NWWGj8umKbvGCJDNL7HM0wDP7nIK+8YJ7spv
	ynAjZrumWy2WtBsIQwn+VP6R7cBB9E9Nbz0LnurSAF6kpCOZwlwPcGS+gU6XBdOzRdTS8J
	OoiGxnE4FChsfPI7ao6TM7a9Iw9k1ro=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fdpK5EYP;
	spf=pass (imf27.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785420536;
	b=40MKKYufPGGhyrXqHJBVSPzuD6akHr6Ln5g88CXAodFYLsV85yw8CffPbSXYV18JOTubSM
	A1EXFOUEuzXbCtj0e1js19z3VfMxoeDszLfIeuoUT9ABooZEpguWowopRlcUBfWajt7zn4
	MtQdrL+qRcovYfTyzbz5HKq2/J0Ya2E=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 01DE51688;
	Thu, 30 Jul 2026 07:08:51 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id ACA913F86F;
	Thu, 30 Jul 2026 07:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785420535; bh=aMfwEgt9jVCNYMMPKFJHK8KNc3Ks2/o6rHu4bCfbJDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fdpK5EYPIZekmgoIEs66/HdJ//ATmgMi2ViTiQ5OGiUTkS83DpaH5GaY4ygHzQotm
	 KVlVFs3jBho1DVyhWCo00ycNqKO7o38KELsCcQcJe4LmgtlfG3Xs3X/FBwhGfhV1ZD
	 N9CoLZChsdeHC3vcW9S6D7tprcNk8EttahRZE46o=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v6 2/6] tools/lib/mm: add shared file helpers
Date: Thu, 30 Jul 2026 19:38:21 +0530
Message-ID: <20260730140825.238130-3-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260730140825.238130-1-sarthak.sharma@arm.com>
References: <20260730140825.238130-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3121140014
X-Stat-Signature: f6gdxecm1mktuh7cte9qky99pszfrjk8
X-HE-Tag: 1785420536-443952
X-HE-Meta: U2FsdGVkX1+Urv/xwNrtJBD1dVByqYTSf2KEdiB2AK23UHFBinqVAJUryVeNHA1DP9CWjjAHFC2QzawdEbojFfapUu46cNRXl02SoCrghbD5PxJs1H34faRftda09mzRlE3eioJ2SKsaUJ0k3o/3R/5/twi0dckOHjO6wqw5YlttPo5Kk3cxaNDtlTPYtUeIv7YPqXa+sMzLobRuJ+mmm0MEpfEsHwpuGkJSvegtmNbY/f9IkTw7UtLCihBIE8JYSflwRfCrZMDP9TcFaEhpLEwVft5R6vAIZ74sHO6wYpqAK3XR54dB9hoGCa3szC4pdj6U/CqCD130BoCG1pzKHxExCzD94r0I8ryhhzrGWsYNmx8j/JV5VMgCbMmHWhk5lsanOgXjsQk1mQFA3PauUvRbJggkkvb0YalJEvhmS8fhJ2t7MnBWnPluYGybSoOSeosKVgmFIC4T9exU4MTzKYO7Dd50tpnzYQZuF7O9xh4xF5vEoxNbchbSIok4zxBDeMzNDmiETIC+IFZL2Otmsp7OYXGGJ7SJO87+KRYk4wFFXqn05E3oVW5o9sRsx8+GoqA8HTMou6CBiunw2UamB5iXYNn/J/QxJVIMhQfU9eijVmBLFwfZbS1evwI+uAhreczQ7xJ0pO7hwiwJVklKU7FHuCTgpgKSWEfFRZkxhKLjsCMN1yo2nkK2dYDf4kSBJ120AUOemek+bAO+SmyBe5UkoMemNb8MumFrVXNaMpqZELBseFamNlZnljnA8+KWs7aD9h3DfuwxES/u4/Rf+QhnMqBfbOc5xA8PdmjLXl4zdE9ArlnudLju4hzfJoAtgjiM41SiArVzrF3h/zxjr9wGPwUkT4N/SOff39H2SHpVUbI7w4597cAOge/RQU+sjjQKU+GTsiswCttsRLNrkT8lLiUefjHkjvpjztbDjf/gispX73FwfY1RLLoqUe9buvpCXA0DOmd40Do3tIc
 //B25Ub+
 xFa0+chYSEOt0xxDZBdB2zjwKTocBjya1cm8wnf0B3orTgZmlc9qK0dnehYZHgDPnP5VJtZTS4SriIIo81gddvtOIsHPUhTkxO7Dmp1i1teKhg7UegIlyoSqEdkK2L1y04DdsA7hKUqtZBZN9tGS6vIOK++NDWrSIn/9ENMiZVerImd3mb+SQHC4IeAabNfIyjzmSk8bRSev/nKaZmRE14T7o5SsizDHbxffCZRPLaNIwTpFZrfC2DH2O6w==
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

Update the explicit x86 protection_keys 32-bit and 64-bit build rules
to preserve prerequisite paths, now that file_utils.c is built from
tools/lib/mm.

Add tools/lib/mm/ to the MEMORY MANAGEMENT - MISC entry in MAINTAINERS.

Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 MAINTAINERS                          |  1 +
 tools/lib/mm/file_utils.c            | 96 ++++++++++++++++++++++++++++
 tools/lib/mm/file_utils.h            | 12 ++++
 tools/testing/selftests/mm/Makefile  | 11 ++--
 tools/testing/selftests/mm/vm_util.c | 87 -------------------------
 tools/testing/selftests/mm/vm_util.h |  6 +-
 6 files changed, 116 insertions(+), 97 deletions(-)
 create mode 100644 tools/lib/mm/file_utils.c
 create mode 100644 tools/lib/mm/file_utils.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 716acfc3d7c1..040a8e6664f4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17131,6 +17131,7 @@ F:	mm/memory-tiers.c
 F:	mm/page_idle.c
 F:	mm/pgalloc-track.h
 F:	mm/process_vm_access.c
+F:	tools/lib/mm/
 F:	tools/testing/selftests/mm/
 
 MEMORY MANAGEMENT - NUMA MEMBLOCKS AND NUMA EMULATION
diff --git a/tools/lib/mm/file_utils.c b/tools/lib/mm/file_utils.c
new file mode 100644
index 000000000000..3e023052a668
--- /dev/null
+++ b/tools/lib/mm/file_utils.c
@@ -0,0 +1,96 @@
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
+	int fd, err;
+	ssize_t numread;
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)
+		return -errno;
+
+	numread = read(fd, buf, buflen - 1);
+	if (numread < 1) {
+		err = numread ? errno : ENODATA;
+		close(fd);
+		return -err;
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
+
+	if (numwritten < 0)
+		return -saved_errno;
+
+	if (numwritten != (ssize_t)(buflen - 1))
+		return -EIO;
+
+	return 0;
+}
+
+int read_num(const char *path, unsigned long *num)
+{
+	unsigned long val;
+	int ret;
+	char buf[21];
+	char *end;
+
+	if (!num)
+		return -EINVAL;
+
+	ret = read_file(path, buf, sizeof(buf));
+	if (ret < 0)
+		return ret;
+
+	errno = 0;
+	val = strtoul(buf, &end, 10);
+	if (errno)
+		return -errno;
+
+	if (end == buf || buf[0] == '-')
+		return -EINVAL;
+
+	if (*end == '\n')
+		end++;
+
+	if (*end != '\0')
+		return -EINVAL;
+
+	*num = val;
+	return 0;
+}
+
+int write_num(const char *path, unsigned long num)
+{
+	char buf[21];
+
+	sprintf(buf, "%lu", num);
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
index e6df968f0971..70d6a9ccf9c9 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -37,7 +37,8 @@ endif
 # LDLIBS.
 MAKEFLAGS += --no-builtin-rules
 
-CFLAGS = -Wall -O2 -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
+CFLAGS = -Wall -O2 -I $(top_srcdir) -I $(top_srcdir)/tools/lib
+CFLAGS += $(EXTRA_CFLAGS) $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
 CFLAGS += -Wunreachable-code
 LDLIBS = -lrt -lpthread -lm
 
@@ -187,8 +188,8 @@ TEST_FILES += write_hugetlb_memory.sh
 
 include ../lib.mk
 
-$(TEST_GEN_PROGS): vm_util.c hugepage_settings.c
-$(TEST_GEN_FILES): vm_util.c hugepage_settings.c
+$(TEST_GEN_PROGS): vm_util.c hugepage_settings.c $(top_srcdir)/tools/lib/mm/file_utils.c
+$(TEST_GEN_FILES): vm_util.c hugepage_settings.c $(top_srcdir)/tools/lib/mm/file_utils.c
 
 $(OUTPUT)/uffd-stress: uffd-common.c
 $(OUTPUT)/uffd-unit-tests: uffd-common.c
@@ -217,7 +218,7 @@ $(BINARIES_32): CFLAGS += -m32 -mxsave
 $(BINARIES_32): LDLIBS += -lrt -ldl -lm
 $(BINARIES_32): $(OUTPUT)/%_32: %.c
 	$(call msg,CC,,$@)
-	$(Q)$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
+	$(Q)$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $^ $(LDLIBS) -o $@
 $(foreach t,$(VMTARGETS),$(eval $(call gen-target-rule-32,$(t))))
 endif
 
@@ -226,7 +227,7 @@ $(BINARIES_64): CFLAGS += -m64 -mxsave
 $(BINARIES_64): LDLIBS += -lrt -ldl
 $(BINARIES_64): $(OUTPUT)/%_64: %.c
 	$(call msg,CC,,$@)
-	$(Q)$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
+	$(Q)$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $^ $(LDLIBS) -o $@
 $(foreach t,$(VMTARGETS),$(eval $(call gen-target-rule-64,$(t))))
 endif
 
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index e3ec077cda67..36515b098ad0 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -698,93 +698,6 @@ int unpoison_memory(unsigned long pfn)
 	return ret > 0 ? 0 : -errno;
 }
 
-int read_file(const char *path, char *buf, size_t buflen)
-{
-	int fd, err;
-	ssize_t numread;
-
-	fd = open(path, O_RDONLY);
-	if (fd == -1)
-		return -errno;
-
-	numread = read(fd, buf, buflen - 1);
-	if (numread < 1) {
-		err = numread ? errno : ENODATA;
-		close(fd);
-		return -err;
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
-
-	if (numwritten < 0)
-		return -saved_errno;
-
-	if (numwritten != (ssize_t)(buflen - 1))
-		return -EIO;
-
-	return 0;
-}
-
-int read_num(const char *path, unsigned long *num)
-{
-	unsigned long val;
-	int ret;
-	char buf[21];
-	char *end;
-
-	if (!num)
-		return -EINVAL;
-
-	ret = read_file(path, buf, sizeof(buf));
-	if (ret < 0)
-		return ret;
-
-	errno = 0;
-	val = strtoul(buf, &end, 10);
-	if (errno)
-		return -errno;
-
-	if (end == buf || buf[0] == '-')
-		return -EINVAL;
-
-	if (*end == '\n')
-		end++;
-
-	if (*end != '\0')
-		return -EINVAL;
-
-	*num = val;
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


