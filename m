Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C7D8606B9DE
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 00:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=As+XK0sd
Received: by kanga.kvack.org (Postfix)
	id 0F4336B05C3; Tue, 10 Nov 2026 19:24:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A5BA6B05C4; Tue, 10 Nov 2026 19:24:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAF596B05C5; Tue, 10 Nov 2026 19:24:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB7B86B05C3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:24:29 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4C9B8A6CA1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:29 +0000 (UTC)
X-FDA: 85420941858.02.8B0262E
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8253EC0003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=As+XK0sd;
	spf=pass (imf28.hostedemail.com: domain of 3urXzaggKCFMy7vE6vx519916z.x97638FI-775Gvx5.9C1@flex--dmatlack.bounces.google.com designates 209.85.210.70 as permitted sender) smtp.mailfrom=3urXzaggKCFMy7vE6vx519916z.x97638FI-775Gvx5.9C1@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794356667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yJQji94fKkWT964doWVlcpJSmDv3OcxOjFHBNrwGpwU=;
	b=P/Ti5gJun8SYrbJZ4C8tPew7H8eLGSdzb73laVX9tZBSw418wXvtl49DvQilY5CLzoXBmo
	9SxdD9i5/SnGosw3Taoh1AnF0FxJ48h5Z7ZELvYfsxT8TxjYH1oKITvHHOlO4caoIhXXyA
	TWnwxDwpjUn7cziYZN6fuY6akiY18UI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794356667;
	b=UEFgKwhYgtDalczmLG4WkJRdDHS+3mZr4rrNksCKKJd+JpGt3ZDw1fPj59vH7P7vtO8VUu
	iLpwUA53Ta+kBfdFJLaKkK7ocSNr7wXAuorL23x1Tbh1Ir99hOdD7KmBr9kT/Mj2rilCHF
	iY+jgcFTfjPWNaemqh6KfnT0c9Wj+Ic=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=As+XK0sd;
	spf=pass (imf28.hostedemail.com: domain of 3urXzaggKCFMy7vE6vx519916z.x97638FI-775Gvx5.9C1@flex--dmatlack.bounces.google.com designates 209.85.210.70 as permitted sender) smtp.mailfrom=3urXzaggKCFMy7vE6vx519916z.x97638FI-775Gvx5.9C1@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-83c2311eb1dso3874087a34.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794356666; x=1794961466; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yJQji94fKkWT964doWVlcpJSmDv3OcxOjFHBNrwGpwU=;
        b=As+XK0sd8jaFnUU0xhTOl2J3GJhkLXd5GPbWUg+7TlsGRCuUKjeUt1kTHY2MapLMwv
         HyBUfSAC2CcLkFgeg5bQjiGZCZlKifrw0pVD7qwBL5XjtEto885Z5Dodz0eozbXviiJH
         ofe/xFsa50Ofp4PkC2V0njGV/QhYXb+rNPKb+481hRJB1OplDoAaJ5Wd9jSLWPlB/0tl
         +vQd5Y993O+rTMkYjVSot76+wIM0SY9IXxPFGUdwjWeczrEIyxKuys3rx4bqzllFcXr3
         Gk8qov+rjB9emByM3VapeWOAPebVm19EgCUrshMsaYeUXcglYFLL0RJHUBcwDWAy2o7z
         B5RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794356666; x=1794961466;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yJQji94fKkWT964doWVlcpJSmDv3OcxOjFHBNrwGpwU=;
        b=T/1Ysx4V9NDuERv31p98r1U7KH+CsqHWbWf6xer2YQPrY78O1Z5lhWsNB4AhukayIR
         MdphMdqRFL25Z9lNOSoVeNsm2VUvx5dllA0JIu3KHfRTc51pls0bB2hfbVTYhd5fPfxh
         iOHn5/w0xrrOc4IV1ta+NS+apCr+h6Bdk0jZRajyIjeOJshgZ8PpLT5gbccMIwXRfV/T
         P/g1Tk+rDQRv71ToJ4zzA89RIiX9hYx4bHy48bLJkUXImbRJYgyEgezunFZa2A5sPG+n
         VOEKsaA2n+N3APInPI9zx35hkZTafynwg5wqbcDPSbjjH05G1MyePJvfcq4QU+1NgvuZ
         SfxA==
X-Forwarded-Encrypted: i=1; AL+hErHdc31XtSSsHSoFq5dWOipsebxps4+ide48TO31Yz5VnGuD20m+FBttLpyoWAkCAByGnwQRDOVxPQ==@kvack.org
X-Gm-Message-State: APuU4Z/YJ9RoDKIWCbD5vdZsjwsxmcElEy0w+qUz7+2UFWFQ0JSXdP3B
	omOjufkDVPBvb/CM12myGlg4tq3GMVPYBrAL+g1SArDushtMq3y+42QOnZFlcHUVRNWRRJBtedt
	6LWycczLPmffDuQ==
X-Received: from iojj9.prod.google.com ([2002:a05:6602:8209:b0:9c4:9bb6:bde4])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:c177:b0:523:dee6:7ae0 with SMTP id 5614622812f47-56b985282b3mr613512b6e.58.1794356666306;
 Tue, 10 Nov 2026 16:24:26 -0800 (PST)
Date: Wed, 11 Nov 2026 00:23:53 +0000
In-Reply-To: <20261111002358.1842967-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261111002358.1842967-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261111002358.1842967-16-dmatlack@google.com>
Subject: [PATCH v4 15/19] selftests/liveupdate: Add a test for retrieving
 tmpfs files
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org
Cc: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 1mz3yuph3e3pmczbb57u55nekbdmjptp
X-Rspamd-Queue-Id: 8253EC0003
X-Rspam-User: 
X-HE-Tag: 1794356667-313642
X-HE-Meta: U2FsdGVkX18FqD8vAOgf+k1GKA0qoPxVix9fGP+aMLWU1b50KmDJRmjEI8A3wgUa19a0+RMGyjdoQnD+i4sWBLo2IzGK5UiHsLCpzfNTjJXwyp0dcuCUnyf80CxzZiw8aoEn+EeCvGNYn5PqyDhxY9XHLqnYNiAKL7MgteFD0oTyXso/0UsikdLq7dBn1PUDSQJk7VT9KTcMh3Y8kGh6Z8HiUCOjVe0khz9I05gmNQ7eJZMCd331hu3McId9q/q9Q/GyLwtQOxl7aCvCapo14oPRmsb+Z8uY+CJB5fayb9FgvsRsuALPOXqBW0dEAW7iTKptpEJICrXQahX+r8p3z7YNfzE9W1ufI84gQakIDGzQp5TAQeWN7OK1RYv5bZM3TrR7RIXg2tbSJ12YmgsREZ0UW9VZ9VEJc1JnVUGOqAB5O2RYg4i1qPETKRr/sjPLU4wjJnrHzHzvkEiM2qRxne/3srC/XhOyOSNJ7BJYgO9jfr5gcZTuw0nDcAR2LnOagUsF1KfwcOYYhYKgKNWRl2ZZE/0LQQcm4T3mcz9HrfcuNPskR/vhY2DGcI6piCeOGf7yelyr+cicvwOO8P4N3VtOePDNkMzXRfkkoC/xbFVHWjs8e0Jwu1LQR4V/QU8eIe5Is1c4JXBZtTVEvW7fSZAoXIY+PykkN8bRmchcU4j8B9R3Tzj9RSll/jiiBb+nXVqFHHboPEbv+Z4yHHxBtZoxv3vjtjPMKZjz9O+eHmk+/jDmFJ8o2gPRiUxCAxSRMiBdz7HV0Te9VtWuaCFrkvf8bWiOTlmfvWSUA9EAXl3dcE2S8xT4MX13A8PDet5SNyinx+VwwQ+2QE9JF+BBonKtUGgknWBeKiQXoj/1FG5LajPagkAMFIUR2yQbzSaevuw6HPnBfexHljkEFQekMGatD4TEBzv5nLpqBxSMDFoRSMPBxXEqI1Vg5CVLY+EjR46QioZq3TVn25uFKJZ
 C+QiYUSC
 Se0SHr8QWTS96Woj9uH6iu2fv98JCF16qVRBmaFJjaDBKqS5EHhDPLT4Dy6KOIUjI9chKuC6lBggKRN2xuzl/cKiFvPbhGrrVmXaMoZrluQAWtuVe937tLPK3+HUW73dzVgEWCcoU029oje+SI3J2Acug2N916xEA+OqCA6zms0G3jMPICkfTb+YqSptci2pIPTUquU6C7NCYiBoBqWmYPMc/sJWIOs63ZCdI19abY2ubJCjtvL/S8F3x1cXgS6SiGcNcBQVscpCtMeC+SAAZU95E/Pqz31YYnneymhDC4O/WqOLQL1j8pZGNVxquptFza+Jqi7ZAzhXOc1heC5TnK17JBFnd+7z/Omh1s2n8zAFIUp03XATSQF9B3x9VN0zrS0vzBEK+yR75dKYM6iFJBfLGiQB0L6O6VKn3P3yEDCa18mcSE4tR3gtbo3W15V2K4dXAX+4iUHoxg8CO2ADg/W+TgN+qrO0Pjl8Gw/IOiC7Vq016o2A9xlOr+OMdMrELrCeUrWez7uZcenC09ChGSQ15ijvSm9SOdPAOlTf0vU3FLaGOzDtt3QklPrLymHdEe1gOT3Uyh+Bz+MHoueLRmfp806spHt3ir659
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add luo_tmpfs, a kexec test for preserving tmpfs files and retrieving
them into a file on a tmpfs mount with struct
liveupdate_shmem_retrieve_arg.

Stage 1 preserves the source files of each test case. Stage 2 runs each
test case in its own directory, with its own tmpfs mounts, so that block
usage can be checked exactly with statfs() and st_blocks. Following
commits add more test cases.

The first test cases check the contents, size and holes of the retrieved
file, for linked source files and for files created with O_TMPFILE,
retrieved into files created with O_TMPFILE or with a path. They also
check that only the contents and size of the target change: It keeps its
owner, mode, flags and file position, and the retrieve returns the fd of
the target instead of a new one. Also check that the test doesn't
trigger kernel warnings.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/liveupdate/Makefile   |   1 +
 .../testing/selftests/liveupdate/luo_tmpfs.c  | 728 ++++++++++++++++++
 .../selftests/liveupdate/run-vmtests.sh       |   1 +
 3 files changed, 730 insertions(+)
 create mode 100644 tools/testing/selftests/liveupdate/luo_tmpfs.c

diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/testing/selftests/liveupdate/Makefile
index 634211c66652..e217008db3a7 100644
--- a/tools/testing/selftests/liveupdate/Makefile
+++ b/tools/testing/selftests/liveupdate/Makefile
@@ -6,6 +6,7 @@ TEST_GEN_PROGS_EXTENDED += luo_kexec_simple
 TEST_GEN_PROGS_EXTENDED += luo_multi_session
 TEST_GEN_PROGS_EXTENDED += luo_stress_sessions
 TEST_GEN_PROGS_EXTENDED += luo_stress_files
+TEST_GEN_PROGS_EXTENDED += luo_tmpfs
 
 TEST_FILES += do_kexec.sh
 
diff --git a/tools/testing/selftests/liveupdate/luo_tmpfs.c b/tools/testing/selftests/liveupdate/luo_tmpfs.c
new file mode 100644
index 000000000000..4e6e035e8433
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/luo_tmpfs.c
@@ -0,0 +1,728 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * Copyright (c) 2026, Google LLC.
+ * David Matlack <dmatlack@google.com>
+ *
+ * Test the preservation of tmpfs files across a kexec, and retrieving them into
+ * a file on a tmpfs mount with struct liveupdate_shmem_retrieve_arg.
+ *
+ * Each test case preserves its source files in stage 1 and checks how they can
+ * be retrieved in stage 2. The cases use separate tokens, so that a failed case
+ * doesn't affect the others. In stage 2, each case mounts the tmpfs instances
+ * it needs, so that their block usage can be checked exactly.
+ */
+
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
+
+/*
+ * Include this before sys/mman.h, which only defines the MFD_* flags that
+ * aren't defined yet.
+ */
+#include <linux/memfd.h>
+
+#include <errno.h>
+#include <fcntl.h>
+#include <stdbool.h>
+#include <stddef.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <sys/syscall.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include <linux/falloc.h>
+#include <linux/fs.h>
+
+#ifdef NOLIBC
+#include <asm/statfs.h>
+#else
+#include <sys/statfs.h>
+#endif
+
+#include <libliveupdate.h>
+
+#ifndef MNT_DETACH
+#define MNT_DETACH		2
+#endif
+#ifndef O_TMPFILE
+#define O_TMPFILE		(020000000 | O_DIRECTORY)
+#endif
+
+#define STATE_SESSION_NAME	"tmpfs_state"
+#define STATE_TOKEN		999
+#define SESSION_NAME		"tmpfs"
+
+/*
+ * Everything happens on a tmpfs mounted at TEST_DIR. In stage 1, the source
+ * files are created on the tmpfs mounted at TEST_DIR/src. In stage 2, each
+ * case runs in the directory TEST_DIR/<name of the case>.
+ */
+#define TEST_DIR		"/luo_tmpfs"
+
+#define SMALL_SIZE		8192
+#define SPARSE_PAGES		8
+#define TEST_UMASK		022
+
+/* TAINT_BAD_PAGE, TAINT_DIE and TAINT_WARN. */
+#define BAD_TAINT		((1L << 5) | (1L << 7) | (1L << 9))
+
+/*
+ * Checks for the test cases. On failure, they print the failed check and
+ * return KSFT_FAIL from the calling function.
+ */
+#define CHECK(cond) do {						\
+	if (!(cond)) {							\
+		ksft_print_msg("%s:%d: Check failed: %s (errno %d)\n",	\
+			       __func__, __LINE__, #cond, errno);	\
+		return KSFT_FAIL;					\
+	}								\
+} while (0)
+
+#define CHECK_EQ(expr, expected) do {					\
+	long long __val = (expr), __exp = (expected);			\
+									\
+	if (__val != __exp) {						\
+		ksft_print_msg("%s:%d: %s is %lld, expected %lld\n",	\
+			       __func__, __LINE__, #expr, __val, __exp); \
+		return KSFT_FAIL;					\
+	}								\
+} while (0)
+
+/* Call a function that returns a KSFT_* code, and return if it fails. */
+#define TRY(expr) do {							\
+	int __ret = (expr);						\
+									\
+	if (__ret != KSFT_PASS) {					\
+		ksft_print_msg("%s:%d: %s failed\n",			\
+			       __func__, __LINE__, #expr);		\
+		return __ret;						\
+	}								\
+} while (0)
+
+struct test_case {
+	const char *name;
+	/* Size and file position of the source file. */
+	size_t size;
+	off_t pos;
+	/* Stage 1: Preserve the source files. Defaults to preserve_file(). */
+	int (*preserve)(struct test_case *tc);
+	/* Stage 2: Retrieve the files and check them. */
+	int (*verify)(struct test_case *tc);
+	/* The tokens of the case are token to token + 0xff. */
+	__u64 token;
+};
+
+static unsigned long page_size;
+static int session_fd;
+
+/* nolibc doesn't have these, so use syscall() where needed. */
+static int do_fcntl(int fd, int cmd, long arg)
+{
+	return syscall(__NR_fcntl, fd, cmd, arg);
+}
+
+static int do_mount(const char *source, const char *target, const char *type,
+		    unsigned long flags, const char *data)
+{
+	return syscall(__NR_mount, source, target, type, flags, data);
+}
+
+static int do_statfs(const char *path, struct statfs *buf)
+{
+#ifdef NOLIBC
+	return syscall(__NR_statfs, path, buf);
+#else
+	return statfs(path, buf);
+#endif
+}
+
+static unsigned long nr_pages(size_t size)
+{
+	return (size + page_size - 1) / page_size;
+}
+
+static long long file_size(int fd)
+{
+	struct stat st;
+
+	if (fstat(fd, &st))
+		return -1;
+
+	return st.st_size;
+}
+
+/* Return the number of pages charged to the file. */
+static long file_pages(int fd)
+{
+	struct stat st;
+
+	if (fstat(fd, &st))
+		return -1;
+
+	return st.st_blocks * 512 / page_size;
+}
+
+/* Return the number of pages used on the tmpfs mounted at @path. */
+static long mnt_used(const char *path)
+{
+	struct statfs buf;
+
+	if (do_statfs(path, &buf))
+		return -1;
+
+	return buf.f_blocks - buf.f_bfree;
+}
+
+/* Mount a tmpfs with room for @pages pages at @dir. */
+static int mount_tmpfs(const char *dir, unsigned long pages, const char *opts)
+{
+	char data[64];
+
+	if (mkdir(dir, 0755) && errno != EEXIST)
+		return -errno;
+
+	snprintf(data, sizeof(data), "size=%lu%s%s", pages * page_size,
+		 opts ? "," : "", opts ? opts : "");
+	if (do_mount("tmpfs", dir, "tmpfs", 0, data))
+		return -errno;
+
+	return 0;
+}
+
+/* Read a number from the file at @path. Return -1 on failure. */
+static long read_long(const char *path)
+{
+	char buf[32] = {};
+	ssize_t len;
+	int fd;
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		return -1;
+
+	len = read(fd, buf, sizeof(buf) - 1);
+	close(fd);
+	if (len <= 0)
+		return -1;
+
+	return strtol(buf, NULL, 10);
+}
+
+/* Retrieve with the argument @arg. Return the retrieved fd or -errno. */
+static int retrieve_arg(__u64 token, struct liveupdate_shmem_retrieve_arg *arg)
+{
+	return luo_session_retrieve_fd_arg(session_fd, token,
+					   (__u64)(uintptr_t)arg);
+}
+
+/*
+ * Retrieve the file preserved with @token into the file @target. Return @target
+ * or -errno.
+ */
+static int retrieve_into(__u64 token, int target)
+{
+	struct liveupdate_shmem_retrieve_arg arg = {
+		.size = sizeof(arg),
+		.fd = target,
+	};
+
+	return retrieve_arg(token, &arg);
+}
+
+/* Create an empty, unlinked file on the tmpfs mount of the directory @dir. */
+static int new_target(const char *dir)
+{
+	return open(dir, O_TMPFILE | O_RDWR, 0644);
+}
+
+/*
+ * Retrieve the file preserved with @token into a new file created with
+ * new_target(@dir). Return the fd of the new file or -errno.
+ */
+static int retrieve_new(__u64 token, const char *dir)
+{
+	int target, ret;
+
+	target = new_target(dir);
+	if (target < 0)
+		return -errno;
+
+	ret = retrieve_into(token, target);
+	if (ret < 0)
+		close(target);
+	return ret;
+}
+
+/* Link the unlinked file @fd at @path. */
+static int link_fd(int fd, const char *path)
+{
+	char fd_path[64];
+
+	snprintf(fd_path, sizeof(fd_path), "/proc/self/fd/%d", fd);
+	return syscall(__NR_linkat, AT_FDCWD, fd_path, AT_FDCWD, path,
+		       AT_SYMLINK_FOLLOW);
+}
+
+/* The contents of the files depend on their token. */
+static unsigned char pattern(__u64 token, size_t offset)
+{
+	unsigned int word;
+
+	word = (offset / 4 + 1) * 2654435761u ^ token * 2246822519u;
+	return word >> (offset % 4 * 8);
+}
+
+static int write_pattern(int fd, size_t offset, size_t len, __u64 token)
+{
+	static unsigned char buf[65536];
+	size_t i, n;
+
+	if (lseek(fd, offset, SEEK_SET) != (off_t)offset)
+		return -1;
+
+	for (; len; offset += n, len -= n) {
+		n = len < sizeof(buf) ? len : sizeof(buf);
+		for (i = 0; i < n; i++)
+			buf[i] = pattern(token, offset + i);
+		if (write(fd, buf, n) != (ssize_t)n)
+			return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * Check that [start, end) of @p has the contents of the file preserved with
+ * @token, or zeroes if @token is 0.
+ */
+static int check_range(const unsigned char *p, size_t start, size_t end,
+		       __u64 token)
+{
+	unsigned char expected;
+	size_t i;
+
+	for (i = start; i < end; i++) {
+		expected = token ? pattern(token, i) : 0;
+		if (p[i] != expected) {
+			ksft_print_msg("Byte %zu is %#x, expected %#x\n",
+				       i, p[i], expected);
+			return KSFT_FAIL;
+		}
+	}
+
+	return KSFT_PASS;
+}
+
+/* Check that the file has the first @size bytes of the pattern for @token. */
+static int check_contents(int fd, size_t size, __u64 token)
+{
+	size_t len = nr_pages(size) * page_size;
+	unsigned char *p;
+	int ret;
+
+	if (!size)
+		return KSFT_PASS;
+
+	p = mmap(NULL, len, PROT_READ, MAP_SHARED, fd, 0);
+	CHECK(p != MAP_FAILED);
+
+	ret = check_range(p, 0, size, token);
+	/* The rest of the last page must be zero. */
+	if (ret == KSFT_PASS)
+		ret = check_range(p, size, len, 0);
+
+	munmap(p, len);
+	return ret;
+}
+
+/* Check that @fd has the size and contents of the source of @tc. */
+static int check_restored(struct test_case *tc, int fd)
+{
+	CHECK_EQ(file_size(fd), tc->size);
+	CHECK_EQ(file_pages(fd), nr_pages(tc->size));
+	return check_contents(fd, tc->size, tc->token);
+}
+
+/* Create a file with the first @size bytes of the pattern for @token. */
+static int create_source(const char *path, size_t size, __u64 token)
+{
+	int fd;
+
+	fd = open(path, O_CREAT | O_EXCL | O_RDWR, 0644);
+	if (fd < 0)
+		return -1;
+
+	if (write_pattern(fd, 0, size, token)) {
+		close(fd);
+		return -1;
+	}
+
+	return fd;
+}
+
+static int preserve_fd(int fd, off_t pos, __u64 token)
+{
+	CHECK_EQ(lseek(fd, pos, SEEK_SET), pos);
+	CHECK_EQ(luo_session_preserve_fd(session_fd, fd, token), 0);
+	return KSFT_PASS;
+}
+
+static int preserve_source(const char *path, size_t size, off_t pos,
+			   __u64 token)
+{
+	int fd, ret;
+
+	fd = create_source(path, size, token);
+	CHECK(fd >= 0);
+	ret = preserve_fd(fd, pos, token);
+	close(fd);
+
+	return ret;
+}
+
+/* The default for test_case.preserve(). */
+static int preserve_file(struct test_case *tc)
+{
+	char path[128];
+
+	snprintf(path, sizeof(path), "src/%s", tc->name);
+	return preserve_source(path, tc->size, tc->pos, tc->token);
+}
+
+/* Retrieve the file of @tc into a new file on a new mount at dst. */
+static int restore_verify(struct test_case *tc)
+{
+	int fd;
+
+	CHECK_EQ(mount_tmpfs("dst", 16, NULL), 0);
+	fd = retrieve_new(tc->token, "dst");
+	CHECK(fd >= 0);
+	TRY(check_restored(tc, fd));
+
+	close(fd);
+	return KSFT_PASS;
+}
+
+static int basic_verify(struct test_case *tc)
+{
+	struct stat target_st, st, path_st;
+	int target, fd, path_fd;
+
+	CHECK_EQ(mount_tmpfs("dst", 16, NULL), 0);
+	target = open("dst", O_TMPFILE | O_RDWR, 0640);
+	CHECK(target >= 0);
+	CHECK(!fstat(target, &target_st));
+	CHECK_EQ(lseek(target, 77, SEEK_SET), 77);
+
+	/* The retrieve returns the fd of the target instead of a new one. */
+	fd = retrieve_into(tc->token, target);
+	CHECK_EQ(fd, target);
+	TRY(check_restored(tc, fd));
+	CHECK_EQ(mnt_used("dst"), nr_pages(tc->size));
+
+	/*
+	 * Only the contents and size are restored. Everything else is like
+	 * userspace created the file, including its position.
+	 */
+	CHECK(!fstat(fd, &st));
+	CHECK_EQ(st.st_ino, target_st.st_ino);
+	CHECK_EQ(st.st_mode & 07777, 0640);
+	CHECK(S_ISREG(st.st_mode));
+	CHECK_EQ(st.st_nlink, 0);
+	CHECK_EQ(st.st_uid, 0);
+	CHECK_EQ(st.st_gid, 0);
+	CHECK_EQ(do_fcntl(fd, F_GETFL, 0) & (O_ACCMODE | O_TMPFILE),
+		 O_RDWR | O_TMPFILE);
+	CHECK_EQ(lseek(fd, 0, SEEK_CUR), 77);
+
+	/* Like all tmpfs files, the file only has F_SEAL_SEAL. */
+	CHECK_EQ(do_fcntl(fd, F_GET_SEALS, 0), F_SEAL_SEAL);
+
+	/* The file can be linked into place, and opened by its path. */
+	CHECK_EQ(link_fd(fd, "dst/f"), 0);
+	CHECK(!stat("dst/f", &path_st));
+	CHECK_EQ(path_st.st_ino, st.st_ino);
+	CHECK_EQ(path_st.st_nlink, 1);
+	path_fd = open("dst/f", O_RDONLY);
+	CHECK(path_fd >= 0);
+	TRY(check_contents(path_fd, tc->size, tc->token));
+	CHECK_EQ(mnt_used("dst"), nr_pages(tc->size));
+
+	close(path_fd);
+	close(fd);
+	return KSFT_PASS;
+}
+
+static int empty_verify(struct test_case *tc)
+{
+	int fd;
+
+	CHECK_EQ(mount_tmpfs("dst", 1, NULL), 0);
+	fd = retrieve_new(tc->token, "dst");
+	CHECK(fd >= 0);
+	TRY(check_restored(tc, fd));
+	CHECK_EQ(mnt_used("dst"), 0);
+
+	close(fd);
+	return KSFT_PASS;
+}
+
+static int sparse_preserve(struct test_case *tc)
+{
+	size_t size = SPARSE_PAGES * page_size;
+	int fd;
+
+	/* Only the first and the last page have data. */
+	fd = open("src/sparse", O_CREAT | O_EXCL | O_RDWR, 0644);
+	CHECK(fd >= 0);
+	CHECK_EQ(ftruncate(fd, size), 0);
+	CHECK_EQ(write_pattern(fd, 0, page_size, tc->token), 0);
+	CHECK_EQ(write_pattern(fd, size - page_size, page_size, tc->token), 0);
+	CHECK_EQ(file_pages(fd), 2);
+
+	CHECK_EQ(lseek(fd, 0, SEEK_SET), 0);
+	CHECK_EQ(luo_session_preserve_fd(session_fd, fd, tc->token), 0);
+
+	/* Preserving the file fills the holes. */
+	CHECK_EQ(file_pages(fd), SPARSE_PAGES);
+
+	close(fd);
+	return KSFT_PASS;
+}
+
+static int sparse_verify(struct test_case *tc)
+{
+	size_t size = SPARSE_PAGES * page_size;
+	unsigned char *p;
+	bool data;
+	int fd, i;
+
+	CHECK_EQ(mount_tmpfs("dst", SPARSE_PAGES, NULL), 0);
+	fd = retrieve_new(tc->token, "dst");
+	CHECK(fd >= 0);
+	CHECK_EQ(file_size(fd), size);
+	CHECK_EQ(file_pages(fd), SPARSE_PAGES);
+	CHECK_EQ(mnt_used("dst"), SPARSE_PAGES);
+
+	/* The holes read as zeroes. */
+	p = mmap(NULL, size, PROT_READ, MAP_SHARED, fd, 0);
+	CHECK(p != MAP_FAILED);
+	for (i = 0; i < SPARSE_PAGES; i++) {
+		data = i == 0 || i == SPARSE_PAGES - 1;
+		TRY(check_range(p, i * page_size, (i + 1) * page_size,
+				data ? tc->token : 0));
+	}
+
+	munmap(p, size);
+	close(fd);
+	return KSFT_PASS;
+}
+
+static int tmpfile_source_preserve(struct test_case *tc)
+{
+	int fd, ret;
+
+	/* An unlinked tmpfs file is still a tmpfs file. */
+	fd = open("src", O_TMPFILE | O_RDWR, 0644);
+	CHECK(fd >= 0);
+	CHECK_EQ(write_pattern(fd, 0, tc->size, tc->token), 0);
+	ret = preserve_fd(fd, tc->pos, tc->token);
+	close(fd);
+
+	return ret;
+}
+
+static int linked_target_verify(struct test_case *tc)
+{
+	int target, path_fd;
+
+	/* The target can also be created with a path. */
+	CHECK_EQ(mount_tmpfs("dst", 16, NULL), 0);
+	target = open("dst/f", O_CREAT | O_EXCL | O_RDWR, 0644);
+	CHECK(target >= 0);
+	CHECK_EQ(retrieve_into(tc->token, target), target);
+	TRY(check_restored(tc, target));
+
+	path_fd = open("dst/f", O_RDONLY);
+	CHECK(path_fd >= 0);
+	TRY(check_contents(path_fd, tc->size, tc->token));
+
+	close(path_fd);
+	close(target);
+	return KSFT_PASS;
+}
+
+static struct test_case test_cases[] = {
+	/* The restored file. */
+	{
+		.name = "basic",
+		.size = 10000,
+		.pos = 1234,
+		.verify = basic_verify,
+	},
+	{
+		.name = "empty",
+		.verify = empty_verify,
+	},
+	{
+		.name = "sparse",
+		.preserve = sparse_preserve,
+		.verify = sparse_verify,
+	},
+	{
+		.name = "tmpfile_source",
+		.size = SMALL_SIZE,
+		.preserve = tmpfile_source_preserve,
+		.verify = restore_verify,
+	},
+	{
+		.name = "linked_target",
+		.size = SMALL_SIZE,
+		.verify = linked_target_verify,
+	},
+};
+
+static long read_taint(void)
+{
+	return read_long("/proc/sys/kernel/tainted");
+}
+
+static int check_taint(long old_taint)
+{
+	long taint = read_taint();
+
+	if (old_taint < 0 || taint < 0) {
+		ksft_print_msg("Failed to read the taint flags\n");
+		return KSFT_SKIP;
+	}
+
+	if (old_taint & BAD_TAINT) {
+		ksft_print_msg("The kernel was already tainted\n");
+		return KSFT_SKIP;
+	}
+
+	CHECK_EQ(taint & BAD_TAINT, 0);
+	return KSFT_PASS;
+}
+
+static void setup(int luo_fd)
+{
+	unsigned int i;
+
+	page_size = getpagesize();
+	umask(TEST_UMASK);
+
+	for (i = 0; i < ARRAY_SIZE(test_cases); i++)
+		test_cases[i].token = (i + 1) * 0x100;
+
+	if (mount_tmpfs(TEST_DIR, 16, "mode=0755"))
+		fail_exit("Failed to mount %s", TEST_DIR);
+}
+
+static void enter_case_dir(struct test_case *tc)
+{
+	char dir[128];
+
+	snprintf(dir, sizeof(dir), TEST_DIR "/%s", tc->name);
+	if ((mkdir(dir, 0755) && errno != EEXIST) || chdir(dir))
+		fail_exit("Failed to create %s", dir);
+}
+
+static void run_stage_1(int luo_fd)
+{
+	long taint = read_taint();
+	struct test_case *tc;
+	unsigned int i;
+	int ret;
+
+	ksft_print_msg("[STAGE 1] Creating state file for next stage (2)...\n");
+	create_state_file(luo_fd, STATE_SESSION_NAME, STATE_TOKEN, 2);
+
+	setup(luo_fd);
+	if (chdir(TEST_DIR) || mount_tmpfs("src", 4096, "huge=never"))
+		fail_exit("Failed to mount the source tmpfs");
+
+	session_fd = luo_create_session(luo_fd, SESSION_NAME);
+	if (session_fd < 0)
+		fail_exit("luo_create_session for '%s'", SESSION_NAME);
+
+	ksft_print_msg("[STAGE 1] Preserving the source files...\n");
+	for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
+		tc = &test_cases[i];
+		ret = tc->preserve ? tc->preserve(tc) : preserve_file(tc);
+		if (ret == KSFT_SKIP)
+			ksft_print_msg("[STAGE 1] %s: Skipped\n", tc->name);
+		else if (ret != KSFT_PASS)
+			ksft_exit_fail_msg("%s: Failed to preserve\n",
+					   tc->name);
+	}
+
+	if (check_taint(taint) == KSFT_FAIL)
+		ksft_exit_fail_msg("The kernel was tainted in stage 1\n");
+
+	close(luo_fd);
+	daemonize_and_wait();
+}
+
+static void run_stage_2(int luo_fd, int state_session_fd)
+{
+	long taint = read_taint();
+	unsigned int i, nr_tests;
+	struct test_case *tc;
+	int stage;
+
+	ksft_print_msg("[STAGE 2] Starting post-kexec verification...\n");
+	restore_and_read_stage(state_session_fd, STATE_TOKEN, &stage);
+	if (stage != 2)
+		fail_exit("Expected stage 2, but state file contains %d",
+			  stage);
+
+	setup(luo_fd);
+	session_fd = luo_retrieve_session(luo_fd, SESSION_NAME);
+	if (session_fd < 0)
+		fail_exit("luo_retrieve_session for '%s'", SESSION_NAME);
+
+	nr_tests = ARRAY_SIZE(test_cases) + 1;
+
+	ksft_print_header();
+	ksft_set_plan(nr_tests);
+
+	for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
+		tc = &test_cases[i];
+		enter_case_dir(tc);
+		ksft_test_result_report(tc->verify(tc), "%s\n", tc->name);
+	}
+
+	if (luo_session_finish(session_fd))
+		fail_exit("luo_session_finish for '%s'", SESSION_NAME);
+	close(session_fd);
+
+	if (chdir("/") || syscall(__NR_umount2, TEST_DIR, MNT_DETACH) ||
+	    rmdir(TEST_DIR))
+		fail_exit("Failed to clean up %s", TEST_DIR);
+
+	ksft_test_result_report(check_taint(taint), "no_kernel_warnings\n");
+
+	if (luo_session_finish(state_session_fd))
+		fail_exit("luo_session_finish for state session");
+	close(state_session_fd);
+
+	if (!ksft_get_fail_cnt())
+		ksft_print_msg("--- TMPFS TEST PASSED ---\n");
+
+	ksft_finished();
+}
+
+int main(int argc, char *argv[])
+{
+	return luo_test(argc, argv, STATE_SESSION_NAME,
+			run_stage_1, run_stage_2);
+}
diff --git a/tools/testing/selftests/liveupdate/run-vmtests.sh b/tools/testing/selftests/liveupdate/run-vmtests.sh
index 6f592aec0f85..9bf79e6c8791 100755
--- a/tools/testing/selftests/liveupdate/run-vmtests.sh
+++ b/tools/testing/selftests/liveupdate/run-vmtests.sh
@@ -20,6 +20,7 @@ TEST_NAMES=(
 	"luo_multi_session"
 	"luo_stress_files"
 	"luo_stress_sessions"
+	"luo_tmpfs"
 )
 
 function usage() {
-- 
2.56.0.542.g3ef89b7020-goog


