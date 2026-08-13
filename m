Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B186C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 18:13:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65FB76B0589; Thu, 13 Aug 2026 14:13:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6103B6B058B; Thu, 13 Aug 2026 14:13:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FE2E6B058C; Thu, 13 Aug 2026 14:13:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1F69D6B0589
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:13:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AA178A01EF
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 18:13:36 +0000 (UTC)
X-FDA: 85097044032.17.A08B5C1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id CD1C220002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 18:13:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ey3qCklV;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786644815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=veGjseMvbDrdSNTAF7+o2sauWUS+F/zsKVPpU9rtyJU=;
	b=Lc1RJtxxfG1C0O2+KAjrYuy6Zn/lqV8IOSEV98mYKuGnqXCXSJfgw3rDvHKQ2mAPaWE1rr
	bR3gySJEQ52O6Jugcfb7pG22XeYrVdPOHKQ4BJQx1c8cfIjhO4GD556Ls5t6WBcff7hSSZ
	nEsk0ZPhKycZQoO8jm+mFTUnI422fqs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ey3qCklV;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786644815;
	b=XYh+m1IePBwflY8sS/8KclnXXPeZqjmU+Pkuwkroyck0GYAM+7Hji8Gxll4JWcFezCjSru
	mJ7jyRv57LuhRSg97ZO++e6PqG+pr7LW7OryRvGBwnDwoyOaGjkazwjO7xDi3Hu8RrKK/S
	EOxXVev3t9cNun+5rL4qqLPknTxbYEk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7A5BF1AC1;
	Thu, 13 Aug 2026 11:13:29 -0700 (PDT)
Received: from a081061.arm.com (unknown [10.163.171.218])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9EE383F66F;
	Thu, 13 Aug 2026 11:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786644813; bh=eBhttsFXYAe1gMijKIpdl6plkvZ9i+H8oz6ap9OjL6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ey3qCklVM9InMsdHhYR9huQaX+87gYReT2qfDlB7FKkZijBfcU+g4sJ/14hY9YZb8
	 O8+0FJCAhNW+J79jWkqokz1dzIE50+yGbze/nCLG7hiQIQph5fvcU0q7vy663ssmgl
	 Nk/QXRySORJtupCEpO3xLSQ+LIGnt8pmuuvCOlJA=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
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
Subject: [PATCH v7 2/6] tools/lib/mm: add shared file helpers
Date: Thu, 13 Aug 2026 23:42:26 +0530
Message-ID: <20260813181230.483746-3-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813181230.483746-1-sarthak.sharma@arm.com>
References: <20260813181230.483746-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CD1C220002
X-Rspamd-Server: rspam07
X-Stat-Signature: n4ckkwkdg9jxi3zzxh345g7913es7kkm
X-HE-Tag: 1786644814-398050
X-HE-Meta: U2FsdGVkX18PCKtgaJ86b44wrRcLxBvhvqAPOaiCdOaba5/Y09ZxF3BquF+eo3jevBGDPGTlLRb70ht++pblNOxvBaDb1CwL5ZWozgoNvqgzeB6NnbCbwVDPZIX6hIb80u68z4kDoffarxDvS/D/oyNfwpfdrkUiNorQjW/wvr3Rpczw+2U9H3uAoWRzNEs3IFq845LMTh1zg5LSbHq/vl9FbjDk1aVvcKLtcbqvksvtz/mXiidjOBP3nco8eyXBPz/DuzLDZud8LiIf2rQ0ZdK1m5d4i6i+PfIlhU1oSuBIo/rw10HACmomkhWCYxFc7ddbeQsW8e/ztSjcC/bLlsAClvJX+CZnf+HgLwbgCMVhQwUD4plYJ/V5Z+0+J2tp8J5t+QBUe4zMUYh6P9zVmV+VoTGKW2uwakisKpv08kRz7R9ZFS4Mab6zutzVW2XywGtUTQWZoPN4gmO5B7mxQnb3vD9UDbAoWmhXdehG4mJiabmL1jcib9eiqcq0vulZi6S8+G+ABv+YT2WlLsHoMWWiwsYHUj0R4f62zg/fIJyXPcxwkHYNHF9MRxhmXH3N7cKiRTzCAdLdq4KE+zACe7+yTYRCUwOhpQE7phCG+signb6foby6TAe7LJ5hMOElpF53cafNAGQ5qZMjN04fF2Fcg07JVPO3q6Gbw5Lv3B1axj8zmTht2FiG5u5i8tSDAC9lwC9twPbeljxyeyl0kjF5dl31bW1fMrSPimdwMSdkQLSc8DEsCDmKx+4IIBkV2VfQSfhV1hnT3z/cgeJzbzBNDAM+B7ybuq22+MVwFbxZ4fVR0lGP/MXJP5aUK5Yd79uJ3MnrCjQ/D+aga9ghNhw4vcVSCQnvE8VP99fNEwStgRRA6H4x0oE5im4W+cXLyLDzGGmRT4KsYbwmEd6Ka/RBNtQ2DBj0buAyThUoPA9og6z1MEH8YoFetTOW+21NDi9QUvATMzPrQvQ+2/6
 cn1JhgGj
 VLzvfX13zAli9n90Eb8iK3QNVw5EKDLyAOs796m4s0Zhac+b6c3gv37hUiqmTzezNDUNrVvj/FKKb1noH4E5kQ0bleBAqM9e9lvgdKIKA+LJUIXNFsHVBP1VKq9PtQmgvTZ6JaXlDUNvgmiuOW/ZswkQ86SshBLgOC5NOhKPPyJ7dtfY5PmiUF0udc4aZQF2a3uYzpNITDS6AUl1KznBuULhXjC5UzeVmmSSWGk5gogWN6pqsM2EIUyj7MQ==
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

Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 MAINTAINERS                          |   1 +
 tools/lib/mm/file_utils.c            | 104 +++++++++++++++++++++++++++
 tools/lib/mm/file_utils.h            |  13 ++++
 tools/testing/selftests/mm/Makefile  |  11 +--
 tools/testing/selftests/mm/vm_util.c |  95 ------------------------
 tools/testing/selftests/mm/vm_util.h |   7 +-
 6 files changed, 125 insertions(+), 106 deletions(-)
 create mode 100644 tools/lib/mm/file_utils.c
 create mode 100644 tools/lib/mm/file_utils.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 0f513b42bc18..952e04fcc046 100644
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
index 000000000000..99a153efa8fb
--- /dev/null
+++ b/tools/lib/mm/file_utils.c
@@ -0,0 +1,104 @@
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
+	if (buf[0] < '0' || buf[0] > '9')
+		return -EINVAL;
+
+	errno = 0;
+	val = strtoul(buf, &end, 10);
+	if (errno)
+		return -errno;
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
index 6424d798a1d9..4751db798c3a 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -889,101 +889,6 @@ int unpoison_memory(unsigned long pfn)
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
-	if (buf[0] < '0' || buf[0] > '9')
-		return -EINVAL;
-
-	errno = 0;
-	val = strtoul(buf, &end, 10);
-	if (errno)
-		return -errno;
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
2.39.5


