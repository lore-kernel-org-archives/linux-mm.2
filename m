Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67C00C61DF0
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 04:21:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 548536B008C; Mon, 31 Aug 2026 00:21:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F8BA6B0092; Mon, 31 Aug 2026 00:21:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 399D66B0095; Mon, 31 Aug 2026 00:21:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0241A6B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:21:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6AF97A3EDD
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:21:38 +0000 (UTC)
X-FDA: 85160265876.30.7E08A60
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id A9ED7C0003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:21:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Qh7vy8C3;
	spf=pass (imf10.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788150096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KDaF64mHP7eCsUPlo6P7+yp7k6Fe/wjPS3Q0GG2TAtE=;
	b=5GosD2ra3RwUFNX2McNhw+d+FsJX3FOwQ6z58ONkd6iHz1QjUg7AA72/jtyYsdaldTXWGM
	u2Hsjrmm6DQPdSXYSZN7tsuJldn3lEUV9DwKUvH57bCCcxmsVUpcuLGu7LQIxfPmMj0gz2
	Kw81SXOO6xB5hkIEH49C3pvcQ5WNW8k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788150096;
	b=rpLOXT9FFCU4OByn1lALYDZr9WwcDJDjPjpmE3+eO0+Ihn8oCRMJPrHxOSwkw9wzG+39Hl
	7F7uWGvpX2KJBe3yjMPW6OdoykPE08QRkLH1H9mgFC5TTcT0hj57r6pNhc56zO/w/T8T+v
	YjCV+OOWwFx/Uf28cTFUQf77M30L/hU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Qh7vy8C3;
	spf=pass (imf10.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA27A14BF;
	Sun, 30 Aug 2026 21:21:31 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 18A843F8C6;
	Sun, 30 Aug 2026 21:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788150095; bh=HG/2zHNekvM4W2SFbVUYchpVvXSs5GPACzfDQKtYius=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qh7vy8C3vM5bJSJ/Z5bD3KDh7YPXT0AIPXjd9cR6Kd0hcmXHCsqfRLGryjXuW2u0m
	 oM1lKZ4sXG17pouOKcbMBojfSPgfwblymshLfklWqjhAH6pUyXYcIjmk/MmoNbRtWg
	 5xg4SqBJSpKbXE0R6HckQ3OqPZNUc71DxuA8BuM4=
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
	Shuah Khan <skhan@linuxfoundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
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
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v8 2/6] tools/lib/mm: add shared file helpers
Date: Mon, 31 Aug 2026 09:50:57 +0530
Message-ID: <20260831042101.18085-3-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260831042101.18085-1-sarthak.sharma@arm.com>
References: <20260831042101.18085-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A9ED7C0003
X-Stat-Signature: ugswbso8au4fxgyhkgw5hawzkdwwz5dg
X-HE-Tag: 1788150096-285986
X-HE-Meta: U2FsdGVkX19kGhTRb3KDqgjAuRezAUc5nkp5rE/kzdKwlvjC8kKS01Q1uqnfCf38X+2AfrNYe+tB7kv2NszNkHeqOPZ+H6ekqoFd2aXrvqK3Hwqmx495nMUnDxdPdCvUotVfdLtFtcmDcreQezg2WkrXgqSJ4nncCSdk8TmKNQnvNG+7etX1PEDgI0Z5S0SKxkVFD418TpDrNZ/Fr//LJbwrZBjYr8ycEsuMG3Ad8wKOddvJBpY4GzcRYLk/wtaxs//snb8zQuljfiTfZS6/F439Fo68Abi6+zyd3vNk/Xe50nwW84j7prxpldoqOfiut2ini4Ht8DkNdjfL3ydCN/GCNqLjqT0k3e9tIehF0WhNZZADW5bL7JrcIJ3ksZPlrxvI/6FnjlotlUp3qfmUbJ9HLkSXW3flx7kTkZOCuwwTmnw+jPbJgvPPhhkbkuQnvG07vVmI6ST1GM+RoD8adxvOE8zg0rSe0uxMMhl7vtT+6bSSiOl26NPAWumOA6pI8RDiJCWSpeT9DPDy3kCgf8KV+AWq02ILXE95wjTAYD40a1NeVTHNm62s5/pYC0u5wAAfjWjBhvF4b9kH4WXPC51Ebl3C0g799hhwLqM0FToBLHUnRoKRPHQWDeDmHhDIGcQCccPO7DdB6Q0/HuV28jHFqXjzhf9fEuc/px26Df9RHm45/XwPZEeXmLIsiV2FEmE9yOXHMMnRaDL3HBInwVrv7xWuRoaq7pcmWx/u9opPXPIh77LxjMgcOxUB655azNcnz/lrK2YeRA8ru18045LSnRDgp0pp4MXLg4VHATV+2TT5LW5jLWvz0T0KxQgauntnkAWpoLPV6ohAx4cntaQlww8T0++Jt5812OciMwTFv1GXbAtQZAtqgMgNnVrIXWy0obMTtRCDm87bG+wsV7cuQG3xb7905pw/sZq2bx9Y2lEiaUFjmkazbONS6dde3WLkqgaJnNbFEqM5jac
 1/Re6IGL
 NAPqy4qXf7s5fK8WnLflBxTVoaGMbasupAcAAwWSEnUfUZ7rR5i8gK7mEhROBaMw31NUzTb2x9OiHJVltZwcEU0d6Dg2xJgVqa/CFczSp0Z+R9Ty0TyS8Kl/7dXI6KN/ZNpLbAHAKY8GUGYqEiBKbew1r5fdt7nf42HRVdS05eaoxiqFwlQ4hiQI1xSGYy7NzWbr/UoFvT14/78M56WplIEiRD7l2o99hs3qcnRt3vOjAMOXFE5BtJHAvURKd8W8iT94csWwQlnBwlxA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move read_file(), write_file(), read_num(), write_num() and
write_num_ignore_einval() out of tools/testing/selftests/mm/vm_util.c
into a new shared helper under tools/lib/mm/.

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

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 MAINTAINERS                          |   1 +
 tools/lib/mm/file_utils.c            | 106 +++++++++++++++++++++++++++
 tools/lib/mm/file_utils.h            |  13 ++++
 tools/testing/selftests/mm/Makefile  |  11 +--
 tools/testing/selftests/mm/vm_util.c |  97 ------------------------
 tools/testing/selftests/mm/vm_util.h |   7 +-
 6 files changed, 127 insertions(+), 108 deletions(-)
 create mode 100644 tools/lib/mm/file_utils.c
 create mode 100644 tools/lib/mm/file_utils.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 29236523cefb..6c7ddcd1848a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17135,6 +17135,7 @@ F:	mm/memory-tiers.c
 F:	mm/page_idle.c
 F:	mm/pgalloc-track.h
 F:	mm/process_vm_access.c
+F:	tools/lib/mm/
 F:	tools/testing/selftests/mm/
 
 MEMORY MANAGEMENT - NUMA MEMBLOCKS AND NUMA EMULATION
diff --git a/tools/lib/mm/file_utils.c b/tools/lib/mm/file_utils.c
new file mode 100644
index 000000000000..9b2237e9823e
--- /dev/null
+++ b/tools/lib/mm/file_utils.c
@@ -0,0 +1,106 @@
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
+	return 0;
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
+	if (ret)
+		return ret;
+
+	/* Reject signs and leading whitespace that are accepted by strtoul() */
+	if (buf[0] < '0' || buf[0] > '9')
+		return -EINVAL;
+
+	errno = 0;
+	val = strtoul(buf, &end, 10);
+	if (errno)
+		return -errno;
+
+	/* Only allow a newline after the number */
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
+
+int write_num_ignore_einval(const char *path, unsigned long num)
+{
+	int ret;
+
+	ret = write_num(path, num);
+	return ret == -EINVAL ? 0 : ret;
+}
diff --git a/tools/lib/mm/file_utils.h b/tools/lib/mm/file_utils.h
new file mode 100644
index 000000000000..50daa82c2b2b
--- /dev/null
+++ b/tools/lib/mm/file_utils.h
@@ -0,0 +1,13 @@
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
+int write_num_ignore_einval(const char *path, unsigned long num);
+
+#endif
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 2d5366196e30..61d974d2cbae 100644
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
index c1b8d60e519d..4751db798c3a 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -889,103 +889,6 @@ int unpoison_memory(unsigned long pfn)
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
-	return 0;
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
-	if (ret)
-		return ret;
-
-	/* Reject signs and leading whitespace that are accepted by strtoul() */
-	if (buf[0] < '0' || buf[0] > '9')
-		return -EINVAL;
-
-	errno = 0;
-	val = strtoul(buf, &end, 10);
-	if (errno)
-		return -errno;
-
-	/* Only allow a newline after the number */
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
-int write_num_ignore_einval(const char *path, unsigned long num)
-{
-	int ret;
-
-	ret = write_num(path, num);
-	return ret == -EINVAL ? 0 : ret;
-}
-
 static unsigned long shmall, shmmax;
 
 void __shm_limits_restore(void)
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 62f6f5b42649..fe0475f2bdf2 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -8,6 +8,7 @@
 #include <unistd.h> /* _SC_PAGESIZE */
 #include "kselftest.h"
 #include <linux/fs.h>
+#include <mm/file_utils.h>
 
 #define BIT_ULL(nr)                   (1ULL << (nr))
 #define PM_SOFT_DIRTY                 BIT_ULL(55)
@@ -166,12 +167,6 @@ int unpoison_memory(unsigned long pfn);
 #define PAGEMAP_PRESENT(ent)	(((ent) & (1ull << 63)) != 0)
 #define PAGEMAP_PFN(ent)	((ent) & ((1ull << 55) - 1))
 
-int write_file(const char *path, const char *buf, size_t buflen);
-int read_file(const char *path, char *buf, size_t buflen);
-int read_num(const char *path, unsigned long *num);
-int write_num(const char *path, unsigned long num);
-int write_num_ignore_einval(const char *path, unsigned long num);
-
 void shm_limits_prepare(unsigned long length);
 void __shm_limits_restore(void);
 
-- 
2.53.0


