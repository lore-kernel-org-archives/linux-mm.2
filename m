Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE17CC982DC
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 11:23:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A29CC6B0092; Fri, 18 Sep 2026 07:23:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A018D6B0093; Fri, 18 Sep 2026 07:23:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 917A66B0095; Fri, 18 Sep 2026 07:23:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 641486B0092
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:23:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CC3601A05FA
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:23:07 +0000 (UTC)
X-FDA: 85226646414.02.F4114C2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0B17640003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:23:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=k4+XqSHz;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789730586;
	b=XzvAOBnm82V1k0CtB2L+LyUuAZ5UST5W45CIz99PKjf0yWiG4jgLu/3U0oVld/yL5T8HeE
	zYIECd0xqs47g9DvWvai3ZpeMJ1Q/WpjVg6P0f8MBTl79jYvt+dOqHUd6lhHIfM/X0xjm/
	QCszuhQuxBesHt0UC2l/iIsoW/DgVYM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=k4+XqSHz;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789730586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RH1v03XNu1lXFLMq7ymULCO7K4PuAVZ/VQYaScXmoUo=;
	b=kkFi25pqmAAfQJ71euBfyBkZ2n8t0ZNPe6KF2kvr3jB6chP8SEvceWo+cpRO2tS2j0/fpL
	VTK7AJSGHDE6rALvqp4vSniWq+SfOmREaJThLVVFifUmpgEx/JCKTBPd8bRetU4iAb5jvP
	D8BzOY0catvSZx2cP/7V1IwHBEgpvC8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A5D6E1596;
	Fri, 18 Sep 2026 04:23:01 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9821D3F882;
	Fri, 18 Sep 2026 04:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789730585; bh=BrhrKyOWleozRhznVBk+PWrdPljvYcLD8claL1Fr3ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k4+XqSHzbgJWhsefqWDrZVafOC10FIw4xqWAhBwUJUY6+mrbimjmbF0QYYoTbX91k
	 nZ5wkz0VxdpvHUgZEB4Rs1zBGI36e3Xt3ug5zT31NuI2VUAUhlooX+Ocy7UCaI/0ZR
	 xMJnHPwvJ22jRKvMa/Zv4uF6ussASXyxmciCBr7M=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@suse.com>,
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
Subject: [PATCH v11 2/6] tools/lib/mm: add shared file helpers
Date: Fri, 18 Sep 2026 16:52:30 +0530
Message-ID: <20260918112234.195857-3-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260918112234.195857-1-sarthak.sharma@arm.com>
References: <20260918112234.195857-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0B17640003
X-Stat-Signature: e37wejjhurxrrhgc493cxbws1thtmi4e
X-HE-Tag: 1789730585-716381
X-HE-Meta: U2FsdGVkX18Eq1Gv9UVOrSy4YqdwoYyOQ4P3mjzFeaOf7mnKuX2bwx9rf+Dvl6CVqKrSYYSHROaONb7+iGoqbLpxMqP4Vo2FfV/wXMeHPLTwi2+mbEqzYZV84dkflvhD99Ie0fSbCka47dkrjk/ELWQM2rFkBl71QBoo+N4w/p8mJvGknkFGj5V37kXpSIHhkQfGqtkCb3kwDNxZ5ds62kXP4ilEoZ4LA9FRZIiBUFz27612ffAjLdyiiuwvNKRfy+pZDn8b1NkVdYTRAz4qbiUQK+DFvYY19uGPSuYLygPJSRiCeI5VAvh1+c0rjTa+I+l5UIVroPBkhaJLMpVMlLr8X5OxuesHJVntzqgRI4tJd/VUN6R+OOCxdRmpuIfmjpj5+0Rxs4pELj61j+hn+/FmmbeXYeUNsfWjR8TzCXij7q8NBxoB2R+9oHdIcmv+pSQj1BIvBJq3wRXBCyxpZDNya8Z6kmpmzcMRBYBebgFYB2dj31B+mXb0tzzla1TQanEQDOsFrBFCjfsVvf05WFgll17NfJ0dnZVO23wx59nA2OCSpsVoe6BtJKBMbjJ3uVHcbQzCfRRpRxsHFtJsyJW6B43cuN5zEScsPv0uV56mXYcKvWNCk107n6u9fs4PzgXwwfciYrfGfiaJ5xfKjhpUCKE1QuXU/FrVR5acxqbTsliH1ZylrhIOtILmKnzSkBbphFLjM6A65oIihe38en7TLxh38vAIxja/DgJfIM9fMFKgw3es+0N6Zv69W/0vbJ53aNsL8lyfLP8JU3pMw0/iQhVFQlePr4gal+flHOE9SkYY3aMQHB78Q3c+ozUNetUU1QM+2T46MQKYVD7UjVFxhWMjit+e3KE435+UFOhtvSKFnZ7lgMhfHObXzC1ZkbLKbJ8G1BkfiXBjdq6PHcLmA+lx96ekEjnktD0K61E3xemndesJf3M3uapikyEYVkI8V4+Jf2vwLK8QqWs
 iWv5y6EG
 nMY54Wy3TR8L9byMOVyJ//+fzesS9+TAPUNNs00d2VRhqqoO6HdT+6m1J63LVLVHPgID/WDFe/Hf7sESYD5Anz5VcYlQJGZNlPe1IYWiCX9iQerWofV3aMuV2EryPOqZ3QZ/CsBS1JIa6xVWFz8Br8CJ5A/BNJO6M9507b4Rl7jF1jRCdPHvmcb418XI8ynSeqooDdHTN/ywkgp53HNKUizdcN1vqObZqf6bEyLXSeMcPzvifRg+Nz1B6iMgJGw6fkQ+6VauFN2BI62U=
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
index e4412c3d8d45..34f30d072499 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17295,6 +17295,7 @@ F:	mm/memory-tiers.c
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
index d3e9bd67904a..c36a9a7089bb 100644
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
 
@@ -184,8 +185,8 @@ TEST_FILES += write_hugetlb_memory.sh
 
 include ../lib.mk
 
-$(TEST_GEN_PROGS): vm_util.c hugepage_settings.c
-$(TEST_GEN_FILES): vm_util.c hugepage_settings.c
+$(TEST_GEN_PROGS): vm_util.c hugepage_settings.c $(top_srcdir)/tools/lib/mm/file_utils.c
+$(TEST_GEN_FILES): vm_util.c hugepage_settings.c $(top_srcdir)/tools/lib/mm/file_utils.c
 
 $(OUTPUT)/uffd-stress: uffd-common.c
 $(OUTPUT)/uffd-unit-tests: uffd-common.c
@@ -214,7 +215,7 @@ $(BINARIES_32): CFLAGS += -m32 -mxsave
 $(BINARIES_32): LDLIBS += -lrt -ldl -lm
 $(BINARIES_32): $(OUTPUT)/%_32: %.c
 	$(call msg,CC,,$@)
-	$(Q)$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
+	$(Q)$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $^ $(LDLIBS) -o $@
 $(foreach t,$(VMTARGETS),$(eval $(call gen-target-rule-32,$(t))))
 endif
 
@@ -223,7 +224,7 @@ $(BINARIES_64): CFLAGS += -m64 -mxsave
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


