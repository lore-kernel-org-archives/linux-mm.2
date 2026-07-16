Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F0ADC44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:03:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4473A6B011C; Thu, 16 Jul 2026 11:02:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41D336B011E; Thu, 16 Jul 2026 11:02:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 333796B011F; Thu, 16 Jul 2026 11:02:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA4036B011C
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:02:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D3FD1A0137
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:33:14 +0000 (UTC)
X-FDA: 84994579908.21.BB86DA3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id D7C83A000E
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:33:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NnjrMzY6;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784205192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fZIciaIvh3Ed9MSVOrmBY/FCqel8pMMjbwP7rG1cjtg=;
	b=KySs+aazbqqHFBU4WP5huBHwVOyn1tjK9xWVRO8sffcjQmPuYfvjo9vqBjSwo3Pkhcnosd
	qb72EpDVOSlZ4brggHwXHHNfxHFMWOIdHuGPX8pfX86Om9wPX66Fvc9MRRMoih9vF0dIZ6
	79Ccuth3PyYIFC/sPrAtRtQd2Fzsz+w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NnjrMzY6;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784205192;
	b=tNyPGA5oFLjOlyveG5w+Pij/u7QTz+91GM1mgCyrhP8C5Zkyi99MO+qMtw4eCsZEvC/UPB
	oZft7eMaqgbaSlxprbM37xWVvESysq73L2RLghyoSOh72jDPOeoehSPkTeR6apR5dIVlEl
	p4hYFrnHlMI4PFryA8CRBtjAHE1NY3E=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B98CA1691;
	Thu, 16 Jul 2026 05:33:05 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8FC6B3F7B4;
	Thu, 16 Jul 2026 05:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784205189; bh=DBJv/0ksG+vCGfmd3BGRAFUPsj0u9YdtLegB9ZTgoP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NnjrMzY6XcFv8CCluji1WTRp19GQ1fDhykXaujz++4nzPjc1kjBX18NxaFWP720a5
	 6918geC/hVmFMUouXfzZ/E4iqIBkCSyv1TRATPoImry7k7iqbDqfiALubj6mSIj7T8
	 /RMthXI2OqZo0YnW1AvZLUEpqVXtVkk/yZRnHqrU=
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
	Jonathan Corbet <corbet@lwn.net>,
	Mark Brown <broonie@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v5 2/5] tools/lib/mm: add shared file helpers
Date: Thu, 16 Jul 2026 18:02:23 +0530
Message-ID: <20260716123226.197736-3-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260716123226.197736-1-sarthak.sharma@arm.com>
References: <20260716123226.197736-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D7C83A000E
X-Stat-Signature: gjpp89istfghysrtrwpwuo3cxswcaaz1
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784205191-600139
X-HE-Meta: U2FsdGVkX1+Azb6XIXyumRDw7wqn8G1qsQ7ZwWzptgr1FhLNVtG/x0nu6kkKdEKQRAXcxt6nTIPwmXn0ENpuwBFyDU57CuJKjRE9aexIOL6er9jBYcFXuK9jVpoJHcBc8NUSvdlGTQup031EwpZDWMjnxPFslLY4fIJnu5AVIt1DPSh9rHmq1L3M0KzXwsxwLcUtEquAX7mFJIHHiNQ/nglA9iT8hK3c34mYb/k1T+Px1fDr9Yim4vuDAou5G3Sx/5+R/46gYGYtrAX+a8bjyxMZKroKWDZPNcZZImST69sMkAjcOqiQwrG3uys4fVqy3C/hlwieIyu0kIADnwWPUF6D3adyPoS0BIAphakmDWoQkHqfr2gULsqsbu2CD4cWpcSsJ8Mp5rjmgey6Kt2f+nBL6T13szSiirhVqdRIJPMqdeVeTAN+pIhw4BiuOKI9Vfn+L8bHGl2EcvvLK1NsWncUBuh6E0RzkKapH61FikZPI4bKLq7b0DvrjP2uM58h5OAxt3wAB6Ej5jOQRgG5GM6dsTgSEczhCLScJYzRlmFHadcyFNTGHr661KDn3VQoOifs1imMNt2y+lLjRNLRtnxeSMspYvergf/1Lhvybw7HChVnzFNNUH7pW+4okEQoNMXEIheB0ewXhZhSQMbturLapwIkSEGMyaLzYTixbaDmrG3pw64gNe9ANJhQK1ndvsbZFMh/1tT8QkYUYOxj388raoK6iQcuhHeDpuRg5/P8GGEaM6ATsJvX9iQ1ISZQ1Zbztfp4XDfBLyNh7KHH4dMoZfByiU0FG5khXmm52aN/Ksh7AvrQ2XBw+T9Oc1TohsM/dcCe0dNWOGdrGLt5jyfKo+u93ODJpnwsZtyPdjSxYsGD07RdzRh7IH4hkc5xpzHfQ2sWV1keZHGo4qDMxjN6CyxLQfdHGw1/bHWbEiyOPoDvEx3KqyIT9vUFJJVnaywVASnWzxdRJGl+tyT
 763U67nB
 4XcQubh7i5353YV2O4kMLbPeTnDWBdtqP3SFjj7T+EUDEMH8knj3XA78yb2Lbv0YJIpdtOkmxRg0qdO8IBg0tZXdcZu05JapSr0/RF2jbWjHCghJQ5NSGPjn1Xh4PjyWeZHKegSBe6kqSoNVG9iwtzmrVV064LSjshkqFuqjrIvzpfV5bI6qEXu6WjE5KKKbIMHXCLhwVrtv6NWq8NM53SkR0KsMrUIQ1GDyPBd28ZZMeIEtdbDv3Ye9zxQ==
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
 MAINTAINERS                          |   1 +
 tools/lib/mm/file_utils.c            | 119 +++++++++++++++++++++++++++
 tools/lib/mm/file_utils.h            |  12 +++
 tools/testing/selftests/mm/Makefile  |  11 +--
 tools/testing/selftests/mm/vm_util.c | 109 ------------------------
 tools/testing/selftests/mm/vm_util.h |   6 +-
 6 files changed, 139 insertions(+), 119 deletions(-)
 create mode 100644 tools/lib/mm/file_utils.c
 create mode 100644 tools/lib/mm/file_utils.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 806bd2d80d15..26b06d80ab45 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17128,6 +17128,7 @@ F:	mm/memory-tiers.c
 F:	mm/page_idle.c
 F:	mm/pgalloc-track.h
 F:	mm/process_vm_access.c
+F:	tools/lib/mm/
 F:	tools/testing/selftests/mm/
 
 MEMORY MANAGEMENT - NUMA MEMBLOCKS AND NUMA EMULATION
diff --git a/tools/lib/mm/file_utils.c b/tools/lib/mm/file_utils.c
new file mode 100644
index 000000000000..792f4b4db625
--- /dev/null
+++ b/tools/lib/mm/file_utils.c
@@ -0,0 +1,119 @@
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
+	if (fd == -1) {
+		int err = errno;
+
+		printf("# %s: %s (%d)\n", path, strerror(err), err);
+		return -err;
+	}
+
+	numread = read(fd, buf, buflen - 1);
+	if (numread < 1) {
+		int err = numread ? errno : ENODATA;
+
+		close(fd);
+		printf("# %s: %s (%d)\n", path, strerror(err), err);
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
+	if (buflen < 2) {
+		printf("# %s: %s (%d)\n", path, strerror(EINVAL), EINVAL);
+		return -EINVAL;
+	}
+
+	fd = open(path, O_WRONLY);
+	if (fd == -1) {
+		int err = errno;
+
+		printf("# %s: %s (%d)\n", path, strerror(err), err);
+		return -err;
+	}
+
+	numwritten = write(fd, buf, buflen - 1);
+	saved_errno = errno;
+	close(fd);
+	if (numwritten < 0) {
+		printf("# %s: %s (%d)\n", path, strerror(saved_errno),
+		       saved_errno);
+		return -saved_errno;
+	}
+	if (numwritten != (ssize_t)(buflen - 1)) {
+		printf("# %s write(%.*s) is truncated, expected %zu bytes, got %zd bytes\n",
+		       path, (int)(buflen - 1), buf, buflen - 1, numwritten);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+int read_num(const char *path, unsigned long *num)
+{
+	unsigned long val;
+	int err, ret;
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
+	if (errno) {
+		err = errno;
+		printf("# %s: %s (%d)\n", path, strerror(err), err);
+		return -err;
+	}
+
+	if (end == buf || buf[0] == '-') {
+		printf("# %s: invalid numeric value\n", path);
+		return -EINVAL;
+	}
+
+	if (*end == '\n')
+		end++;
+
+	if (*end != '\0') {
+		printf("# %s: invalid numeric value\n", path);
+		return -EINVAL;
+	}
+
+	*num = val;
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
index bfe0efbe517e..f276eee57680 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -698,115 +698,6 @@ int unpoison_memory(unsigned long pfn)
 	return ret > 0 ? 0 : -errno;
 }
 
-int read_file(const char *path, char *buf, size_t buflen)
-{
-	int fd;
-	ssize_t numread;
-
-	fd = open(path, O_RDONLY);
-	if (fd == -1) {
-		int err = errno;
-
-		printf("# %s: %s (%d)\n", path, strerror(err), err);
-		return -err;
-	}
-
-	numread = read(fd, buf, buflen - 1);
-	if (numread < 1) {
-		int err = numread ? errno : ENODATA;
-		close(fd);
-		printf("# %s: %s (%d)\n", path, strerror(err), err);
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
-	if (buflen < 2) {
-		printf("# %s: %s (%d)\n", path, strerror(EINVAL), EINVAL);
-		return -EINVAL;
-	}
-
-	fd = open(path, O_WRONLY);
-	if (fd == -1) {
-		int err = errno;
-
-		printf("# %s: %s (%d)\n", path, strerror(err), err);
-		return -err;
-	}
-
-	numwritten = write(fd, buf, buflen - 1);
-	saved_errno = errno;
-	close(fd);
-	if (numwritten < 0) {
-		printf("# %s: %s (%d)\n", path, strerror(saved_errno), saved_errno);
-		return -saved_errno;
-	}
-
-	if (numwritten != (ssize_t)(buflen - 1)) {
-		printf("# %s write(%.*s) is truncated, expected %zu bytes, got %zd bytes\n",
-		       path, (int)(buflen - 1), buf, buflen - 1, numwritten);
-		return -EIO;
-	}
-
-	return 0;
-}
-
-int read_num(const char *path, unsigned long *num)
-{
-	unsigned long val;
-	int err, ret;
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
-	if (errno) {
-		err = errno;
-		printf("# %s: %s (%d)\n", path, strerror(err), err);
-		return -err;
-	}
-
-	if (end == buf || buf[0] == '-') {
-		printf("# %s: invalid numeric value\n", path);
-		return -EINVAL;
-	}
-
-	if (*end == '\n')
-		end++;
-
-	if (*end != '\0') {
-		printf("# %s: invalid numeric value\n", path);
-		return -EINVAL;
-	}
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


