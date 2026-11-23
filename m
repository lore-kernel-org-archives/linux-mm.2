Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5778F606A321
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 23:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=oLx0L6MV
Received: by kanga.kvack.org (Postfix)
	id AF3A66B05C2; Mon, 23 Nov 2026 18:39:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACC9B6B05C4; Mon, 23 Nov 2026 18:39:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91D696B05C5; Mon, 23 Nov 2026 18:39:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 35B9D6B05C2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:39:53 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7C549C0884
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:51 +0000 (UTC)
X-FDA: 85468003782.08.1372D53
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by imf30.hostedemail.com (Postfix) with ESMTP id ABFE680005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=oLx0L6MV;
	spf=pass (imf30.hostedemail.com: domain of 3xM4EawgKCNM2BzIAz195DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--dmatlack.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3xM4EawgKCNM2BzIAz195DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795477189;
	b=dW9Rd3nziC51gU9ZmES5Ve1f8ST92JAxXNFkVdtIqhRBcyf7ZmfBOStbQ0q5eeZ+RWUC3W
	2agUxMYmFe2pO1W0nc3tdAmnj7ncn3dwdA22yDXZ2MSJoZ+yikJsbr1UPgqO6qW4MguflL
	g+laIa5pESRRh8lE4d0XM2oWLVzLo1w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795477189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NyVfIb+LJhe2Hwk4Jg4J3zF1WuK8ovweEBxYohUre1U=;
	b=F3uhK6c2dFlLWYuTzky+DxfG5ZDH8iRSAFV+owGCh8D88I7QqkfbDtnHjVrS1Hpp2A6Rzz
	zxN20c3RlZ5pQlrSzAwLWym1DpNSh/M3ZbLNGuCMCiBdBC9ZINI/41BaS5y3ReI69xvGP+
	TBf2MQzFIS5MQGbA9huxrooKqyxZLdA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=oLx0L6MV;
	spf=pass (imf30.hostedemail.com: domain of 3xM4EawgKCNM2BzIAz195DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--dmatlack.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3xM4EawgKCNM2BzIAz195DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4b37620eb73so5284274b6e.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:39:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795477189; x=1796081989; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NyVfIb+LJhe2Hwk4Jg4J3zF1WuK8ovweEBxYohUre1U=;
        b=oLx0L6MVw/IBLRinnq7muCO/d5gQzphwNX3wotm6pPLEo0o0LdHZJMyUtA4YFI45yR
         hzPvJjrlijQ65tJq6jzT9avwxnXZb4J7UdikkCvmJ5OJNHJM/tIblICm8qzw+bMi4Uhw
         NL2XzpwvBXUP+G3PP3ujWao3aGc5glcX7l0fceXJrAqT6j3dafsg08Se9IlpSvzx2Jlt
         OIfuFPCZx2TAkSed656CkxQtrDFHC7UWPJoiaLhRsgLzn4CI3zl3qKgIGrIhONUFks/k
         zN/4Kab9WE03+P81l+L9pbghP0MbwLhzpcHBklPxTFkKPa9KouRm4P0KBXc211oSQ3GY
         zdfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795477189; x=1796081989;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NyVfIb+LJhe2Hwk4Jg4J3zF1WuK8ovweEBxYohUre1U=;
        b=zetijB4J3bQxkeLaIoJZ8rok9FcdYmIpTg/9zKskEVrbFvCTOMXguBB5V4W8qSYpnl
         PX/FokbPkJmzruSDwdhDDs7PM7We51DO77vocWZnR98UNmLlQPBXnsjXPsbWmh3Dzm6G
         QQXBPYu1w6xvMRTXfptmhGpXheTY1QrKFuoYDLRWhQG5m9TJWUSAW877ks3ssyR+0I+D
         aL16yXu32fGKVB6zF9eNjMTtUXOhlBTNnyyv4auu+csopJfiF0qlhovv/9GEcVgWviJB
         kZ4JcThwyjEsYXO98VkA3OfvzEItupZil7ptKZFotafZPFdlo8P+MIaGY99xN22YmKtX
         c1fw==
X-Forwarded-Encrypted: i=1; AL+hErHQqauFLFRQqWOBL35fOMmpp0Mnz6fCdVI57+8DYmqI47ovaXo1mk5vo8xH9QSwa3ndtUlaOwTMJg==@kvack.org
X-Gm-Message-State: APuU4Z8ix7cX7TxCnN38grsUYrxH4PeAPmrdZpGqFwpja+wkYrnS1wdS
	PVF69IGV7X6aF4MKFgRBUovGbz7uwNrsmFdqq90/9PkAJjLN0JRWyZ88ucW/U0IRqJQUDjgIu6b
	wZEnSUHjvrSVzkw==
X-Received: from ilef7-n2.prod.google.com ([2002:a05:6e02:6187:20b0:547:9c99:d6d5])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:16a4:b0:573:f2e:2c17 with SMTP id 5614622812f47-57a0ac34d7bmr11385858b6e.45.1795477188460;
 Mon, 23 Nov 2026 15:39:48 -0800 (PST)
Date: Mon, 23 Nov 2026 23:39:19 +0000
In-Reply-To: <20261123233924.3970932-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261123233924.3970932-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261123233924.3970932-15-dmatlack@google.com>
Subject: [PATCH v5 14/18] selftests/liveupdate: Add a test for retrieving
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
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ABFE680005
X-Stat-Signature: 7r5ymo37h79x4gn7e8gturm77baooozt
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795477189-115432
X-HE-Meta: U2FsdGVkX1/3T8pG64LdpH1wvNLuEX75vxLZeQMcSrAuz5U08FexqwmpH+52OtvVbHr78qIqT/QUpmNlsG9WrfZV53RXDfeJqmWMX0Z1fsYIlVsMPgXR/CCiPezDjOvoAx06LeawITwnY3id7NGbLYT7Zv+twkj/YHMZOf9uRyGQTJ4PqGNovz2ikvclXPyQy9hY92RblR3uAyulr2gVH8emgGO1K1AffVyxdrWZhqNHIg4W/xCnTPXffD6obRYczmihWtbkbweqWEEbdpqHObIYCo5s71eJvrwMptrCekIDc0/6/UbTkaKcRkzp4TA/tzFwHqLeT0VyITYSmkenbkjVDjyamWCvaWqdfDBefKTrGpRK1CiAdK1eU7hrpd56Mx/nAB0SoGrVId1gEhA2O0cblHao0V/HIIo+CnXQ8qVtAqSoxBbSOZF9v6B65oqIx03BQhQe096eWQwbTmReI16ZmaxnhcV0l2CHg8UXK0ruq9UrXwJorn1JpP8WO8b8ACawsI6INMlwSkYCP47UmKav5m11nB//CBysMorZ5mEPvYBVttKdHnc+PsG5HSR9LNqdMnyCs7GLUEI329zLQo1na/gZ62Xka+zEecm/EpDUXXZDu03dqAro391Xwh6U8gMImeau131kdbFydVRwBOtCzs99YhqmPJUU64e/zgxpAfR2mbcfhKCYcNAa7qVH+wEv53X1I86SM5F6WOH3yIoOuPlhLIjYe0Fb7mmHSv9w4Vd2DQDEl5j6lqWorcgCc071WJ3hyvSBTauO7MwTYmV11ac2VBakiOcSBKXuzC3FJShEYalZNHwsjM0kw2OQiVlqkAbvS1Q0ZtaSjkKfVS2sFyW9i9JJzwo1kYf1WQQH1JCN34vcCzQsu0lqUMiWIcO1u9ciEhN6mZjUercyXkNCgiwuJ++7veDpjREY80F9NMMnZLVt0uU8VuOB9ELv/NgaEHWbjku3iEG1Pzh
 rvfE61Cn
 W3iqIE1UhGVHnjg1rVP82h84wWyuWtwH/KtBXHj4KKX3QMOTxRSqPVrXWvN9xCJQokIJiZZtyz3d884ccoGN8s2V9/pYXhLaayrw19JHr7tVlPbFG6nyxiPTU30iKRkVkuNW2MM7ecl7n3icQKnSWuBBipdYvxhZZe19ClBHYw135BZaKpLWcjo2DPFiQrNgo6IfgIMqJUchLwhCAUPMxpz9apFj7+Rpa81b9U5IHjR4l2hlLV/lrA6knGzdi6++lMq2G16+YkgyV+WL5N1jd8lJ9CWyxouvte7faJblVHq4poHby9SakBnBjCqOQiEuDFBn8qfC8dta+R9uctwbTcdiZjXmmaLBgU0hYTE2Jl4n7NPaBhjk4LTFDo5H8TsnSy9NoppDuoN3ZhPQzExu9I15puSakgWU0/mToBnY6fPaNbjZKWRLW3lTiBHYnaKAcZOUuej5D6XImCdFIjB23DllGmPrD429ha1DDivENcDqi5TmKQOWadVA5VtbINFO8f3HlxN6C3JHkzphnhkdneW1VQgcERAzqWYTNr1HYBZJueKV4xkedxH4g1vVooSR1/XEO3w+Z1QJCN7dR6Vre0HzmY4C1cAyhWykFe6fGutKy0MtTHTxYb9Hkc/yzImDle4fa14WdxAppr/LhIasR6d6NOXnWFWadlsBtn1++E1bFCrgWTg2CC1l4xJiRCE/qOaXNp1ycFBkq3x3Zdt8s77G6LZJT+ExSsZCNyxdWrVDkIpgI7wyWDSSuNwjyhr+5h60dBJQ2H/wc1N/0ah8oygYhQ7tupL4sDFVJH1J3/Rs4fpevaZNm31ECUG7VKlgr4eHHdtS1nwiaPyVNY6Hzq5DAFg==
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
owner, mode, flags and file position, and the retrieve returns a new fd
for the same open file. Also check that the test doesn't trigger kernel
warnings.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/liveupdate/Makefile   |   1 +
 .../testing/selftests/liveupdate/luo_tmpfs.c  | 752 ++++++++++++++++++
 .../selftests/liveupdate/run-vmtests.sh       |   1 +
 3 files changed, 754 insertions(+)
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
index 000000000000..4a50b26d509e
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/luo_tmpfs.c
@@ -0,0 +1,752 @@
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
+#ifdef NOLIBC
+	return syscall(__NR_fcntl, fd, cmd, arg);
+#else
+	return fcntl(fd, cmd, arg);
+#endif
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
+/* Retrieve with the argument @arg. Return the new fd or -errno. */
+static int retrieve_arg(__u64 token, struct liveupdate_shmem_retrieve_arg *arg)
+{
+	return luo_session_retrieve_fd_arg(session_fd, token,
+					   (__u64)(uintptr_t)arg);
+}
+
+/*
+ * Retrieve the file preserved with @token into the file @target. Return @target
+ * or -errno. The retrieve returns a new fd for the same open file as @target,
+ * which the callers don't need, so close it.
+ */
+static int retrieve_into(__u64 token, int target)
+{
+	struct liveupdate_shmem_retrieve_arg arg = {
+		.size = sizeof(arg),
+		.fd = target,
+	};
+	int fd;
+
+	fd = retrieve_arg(token, &arg);
+	if (fd < 0)
+		return fd;
+
+	close(fd);
+	return target;
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
+	struct liveupdate_shmem_retrieve_arg arg = {
+		.size = sizeof(arg),
+	};
+	struct stat target_st, st, path_st;
+	int target, fd, path_fd;
+
+	CHECK_EQ(mount_tmpfs("dst", 16, NULL), 0);
+	target = open("dst", O_TMPFILE | O_RDWR, 0640);
+	CHECK(target >= 0);
+	CHECK(!fstat(target, &target_st));
+	CHECK_EQ(lseek(target, 77, SEEK_SET), 77);
+
+	arg.fd = target;
+	fd = retrieve_arg(tc->token, &arg);
+	CHECK(fd >= 0);
+	CHECK(fd != target);
+	TRY(check_restored(tc, fd));
+	CHECK_EQ(mnt_used("dst"), nr_pages(tc->size));
+
+	/*
+	 * Only the contents and size are restored. Everything else is like
+	 * userspace created the file.
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
+	CHECK_EQ(do_fcntl(fd, F_GETFD, 0), FD_CLOEXEC);
+
+	/* Like all tmpfs files, the file only has F_SEAL_SEAL. */
+	CHECK_EQ(do_fcntl(fd, F_GET_SEALS, 0), F_SEAL_SEAL);
+
+	/*
+	 * The new fd is for the same open file as the target, whose position
+	 * is not changed.
+	 */
+	CHECK_EQ(lseek(fd, 0, SEEK_CUR), 77);
+	CHECK_EQ(lseek(target, 5, SEEK_SET), 5);
+	CHECK_EQ(lseek(fd, 0, SEEK_CUR), 5);
+	close(target);
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
index c3d828cfd63b..1a9686c38fa8 100755
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
2.56.1.809.ga0b61035b5-goog


