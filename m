Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72AC9C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 12:37:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87C0C6B0096; Fri,  4 Sep 2026 08:37:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82CDB6B0098; Fri,  4 Sep 2026 08:37:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7422B6B0099; Fri,  4 Sep 2026 08:37:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C2476B0096
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:37:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D7CC1160424
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:37:03 +0000 (UTC)
X-FDA: 85176029526.06.138A9C3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 30F31180006
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:37:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sD5Q5eh7;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788525422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xpQA+TjcPbVjpvW+qVg58Q/Hh7QuAsmhSwGa6/Xl8l8=;
	b=8NBlGxekFfASWl2Md35kO25jFoKeiIYw0b9egZli6bNxaKIE6jkkqZTQJSmN0xipd91C8C
	Gma34zH2X32IWhQun59l8ci327WoJNC/mKfEnOSiTOxojd4QnWZNw3pG5W944jh6NOUYot
	OcOiuICKeUONOdr5vIUhPnX3Ref5lAs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sD5Q5eh7;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788525422;
	b=VxicThua1S8fL72wFwKBZecKv+deXMhmyrH2/OIVnU1bDvpiH7FZMKXGn1EU5xBD9yF1Kk
	nxDjcD7T9COJFVJnSUrFrGMFjmcclGiMjkpL95L9EBC3PTf7v9IR54w+y6oCuZLXr5q9UK
	1x3sMaAdNCzriTqBPcOq50BCU+kbXkc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B6AA3153B;
	Fri,  4 Sep 2026 05:36:57 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D876A3F673;
	Fri,  4 Sep 2026 05:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788525421; bh=J/N+KtSdqjwVbqYpE7NjyJwvCimafVPuGHeLZEI0IWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sD5Q5eh7/IJax2a8DKl7GeA/7+Y/UA548cPsUZx0CGAxG/ZTSzUSMFFxrLrVDsgzT
	 KCQ6cw7/uryMIcTRaAcJy8sj9+LoTQ00B/NhDF1+RiuiB3pwuEULhRoe/fNnpImn1S
	 l4dtsxyJe43sb7KiEvbqTs0tDUmByFNm2C2VxI1o=
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
Subject: [PATCH v9 2/6] tools/lib/mm: add shared file helpers
Date: Fri,  4 Sep 2026 18:06:27 +0530
Message-ID: <20260904123631.198697-3-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260904123631.198697-1-sarthak.sharma@arm.com>
References: <20260904123631.198697-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ggf1yoh9hwxikx8r8gu6gwkf6cmxyres
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 30F31180006
X-Rspam-User: 
X-HE-Tag: 1788525422-868084
X-HE-Meta: U2FsdGVkX1++b48M/h/VV2IZEQEjykBIIAB0EP30Wh79WjL9c+OPfvWaWWJ/4rsI8/y6JqqG+Kcpt16EdhYs0kQkEQ26Y31v7EjRsOrCoLegc5qSrR0uHJIsEtscW8DlSl3UJiuncskNMaQVssU56v5jVYktKMHVmNq0LgZR4R7OhT/P7JXLUWR4NQmOx07rZeVetBzpHehNpiGHiPLqzCcm5dNAtSJeIXcP8Nve/ZuQHsQSMCC6KB/7TyOJ2NWMDGKLnjhh/zdEyW0QBrbFAjH1KTsZDpQ007Fh7n0NRt7T9UyVob5rrFPbG4OuoyGQQj3T4xxrjUj+8fWxEauqtDCHMy6/7O1DRSmMMWx+LWzhxUA3JDvF4b3FJAKgX3oJ8eK+L+WMEJ9NXd4lo3vNBPJv9r+HZtUUWD31mtKkcZDKe/3nBMllj5gVMxOlBRAVdEpAla72RZTy41hRegSsjKsacPcUa+KDQaWrRFg+THJL7qgdHnjF5b0GY6Lz9tby75n7uI0upZVCsmyBWunNjzn5ajU9TzGHIZM15qfTM2Po274PNVZu1EprRgzgTve9930kHL1BKCFst5YSOcsxWxBG4HzR1H470pV1nB80w/lBzUcSx8dClxLQIPyZgnGUuTDnSwwOK+mA/Xl8tbo16nNSGbZgxFh3f58IrqHr1A6w7gANlmNn71BxSstCTstk2KdbNVBd5uMVoJD/DHpUefb/7dzMj81n6AhOtD4xT8xlO8FpXXzZU0UnAOUVt6kks7VT6BBJPGpo/do0nY1HEsXeqnDNO4ru9R8RdzWHET68OtKxvHPuGg/w0rge+OzHPUVkP4qHvakLASdawkYroFDZ23DF70t0roF5gtqYFTcQEKYQ3xSxlI6XD0f+L2BJPo1t/fTt83uRSwtbi8OaYCJDO4l9Ml5cbAoKOtNsjp/3lCFt7IL82oI6uv+kJkLvuBeudGvsM1GEPPsgDDC
 ewKU7V61
 Y9c/qcZgD7+Ly7gTdvftA4v0YBQidHy3oYLjnjHFdhEtk7QmXhvJbMkmA6l8zfGVQF5ML/x8EBtumH2RqpbUV69I89/AzgO0eWeOAbKXdhkzVRG7Z3hnjRmx70SmUtiGQdBmm1tG7WfraV6Y3LZXFTiVISyIZWgyc6vUWL0/KKES6PbK3l2ucgSdvSBfodmHCe6mWPDR95xSGm2R9O51WLOOsq7vubLEeNFFoqYmvC9irtM7ZC/1MmA9MP0UaDMl/1zFblrL+/suX/+A=
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
index a9245d827ddb..285c6083ca79 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17294,6 +17294,7 @@ F:	mm/memory-tiers.c
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


