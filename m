Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72E99CA5FFF
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 19:30:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D77BB6B0088; Wed,  7 Oct 2026 15:30:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D28A36B008C; Wed,  7 Oct 2026 15:30:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C172D6B0092; Wed,  7 Oct 2026 15:30:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D1B36B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 15:30:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0DD1A14035B
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 19:30:08 +0000 (UTC)
X-FDA: 85296820896.22.4599B1E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 378FA180002
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 19:30:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wmskaTRd;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791401406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gMjFG2jl3cMsOvaaD3xYkPC2eEcuGBPEbXHjWmRtuoA=;
	b=mv8zePNWkyqiBziqzwLmSpt0uQkIka0/3MU5mTuezxxPI3MEdD1vzeTLaNiwUxJUNr13CR
	tNZmY3+O89mBmCPCzNwzCpvkAIdZ850k0yN+V10+k/HooX0EA+MtW4m5llNbKJVK9zAf77
	1PoS0up7nRINnRlurcU6qg7PQ4HAzS0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791401406;
	b=mzxeRCIwL5R6dLb8EVIW8Xc5NC9tnjUbtr3yHQV/3EDgmt/HMhw+6r7UjMfb0H+4DQURzv
	UZ40gYTvHfHHLRcc/NFEEiXiXymUv4lVfWfJItl3LmPM80TYZ5LYPUU6UTtDGlCh9hEoAq
	F2v6GovcuVsf2g/mmQQNy7RFQgLsO7E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wmskaTRd;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 47B4D43867;
	Wed,  7 Oct 2026 19:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C2B1F000FF;
	Wed,  7 Oct 2026 19:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791401405;
	bh=gMjFG2jl3cMsOvaaD3xYkPC2eEcuGBPEbXHjWmRtuoA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=wmskaTRdJgSvuYK7ViHwmKD/bcf8NOIq7Znwf5h7QNNp4e+ZHMdjWaES/A1P4Ws+Y
	 l2W5W+NiUhFwagXehqI5ALX+/MUWg8iFLagHqNqY7Jps86rXwaFsjx9h3ssavvxOOi
	 fF/yp3GXaQCPt5PCwF9JZvLAfVtq2fWRCIYea1Ww=
Date: Wed, 7 Oct 2026 12:30:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hajime Tazaki <thehajime@gmail.com>
Cc: linux-mm@kvack.org, liam@infradead.org, rbm@suse.com,
 luto@amacapital.net, brendan.jackman@linux.dev, david@kernel.org,
 liuhangbin@gmail.com, corbet@lwn.net, kees@kernel.org, ljs@kernel.org,
 broonie@kernel.org, mhocko@suse.com, rppt@kernel.org, shuah@kernel.org,
 surenb@google.com, vbabka@kernel.org, wad@chromium.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-um@lists.infradead.org, geert@linux-m68k.org, daniel@thingy.jp
Subject: Re: [PATCH v5 0/2] support kselftest on nommu platform
Message-Id: <20261007123002.bc06c9a2c94ee67c72107b54@linux-foundation.org>
In-Reply-To: <20261006085642.3852152-1-thehajime@gmail.com>
References: <20261006085642.3852152-1-thehajime@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 378FA180002
X-Rspam-User: 
X-Stat-Signature: jsu3zxpetsnyopehicr5ans3djjt51xk
X-HE-Tag: 1791401406-653397
X-HE-Meta: U2FsdGVkX19wu+sJ1ydPMbmJ/NQtvQfjfrz6pzGfTTSsMHm2ekkJpde2p/hMwPALdjBEiXpFVQDFRImS+b+hJBWM19y1zDTGLVI7TWfehbqT5RYPAiqBJZr/7NwJrVxpq+65t/8qCKx5qYIpLo+ARqCfmw08odZE2hNMsbLnie+eFe0jddZQVxvD6KgM0nWc6pFrGgle1mERgzItv0hcoqAjVcXI4xLb+7NPOJs5hP9lZKsDfibSzJ5y/YILYtWbWfwq+/JaAHfNXOpcR5fbWmbCLxQL2qz/z1+yhg1lIkNAsJ4yD9Occ29womv5/2darReGRhJel0e4STN1xI0HuDflkD9sUPy055OylhZ639XBtaoEtJYIjczFvTE+xyNN5YLH3LcxmQRx9oOxK5cjOuJ5bl8TmeJyIrQ9ah2Spzhg2DAQz9S/YIqmztKzt7l8r2vncGOqqdxG8ltHSSDzH2sTMKaC9/+p5DbfSCZA2U2fNQsx06S7AVttCbMui10AxbXE6BM96EEYePvBXnnS9HKlUinSVFtxRmqK7Ol5thU8Jw3+T3X/mEsbJlkdwce3EapCQpwJ1jfiHz/NZ5J/bXczru2EwlGrnUIOKa+aFtTnA+SmHxgpAHM+OeocdZGp2S07Lj7LyTl0o2nxGBwKOCsfCVucAsXDmfQx0pM877DfrX9/GxzQPPdMtxKgB4L6CBtzKOVBtMOGE2+7LeKuGo4dMegitkdWjG8QHkVmvK5g2diqnQiWOE9v3//AH0tWoYyffcCzeRDnve9IFB+tCA6/qhUaSMU+v15HPL+oNm6W1hRYdkUQsX+BU6ZxJhU2dfk47R2FZc478pvFGN4BOSC/7/PRzLiO32pAyPktj6upBveNdn1f2KFzIZDpKz7ZUi3aoK3/3G/SxgSMCJAaokOsGeLG3RIHDTKHFlYEqCW8Hl7g4wY5mdw3qDO5HFntH00tFVn8JDR8wntxySD
 iBcpQEnj
 W+Da9jSP26PFUCtcOAOpJQs9S/rldvuZNHnexz63DkN+8tM9lf6a3k5FJEagUxDu0MnseRnhCRV5r/tyaZs9TglMesbA0X0roHrdVpqRMqTlNEUwzJXIXqlwPC2yms8nZH5BDtId066wrCjbYYlQWhdDHB8sKBD+AiB9SYTLaVm1Fy5a4B+jGJfD89nyG/q49yPkLrDP77dFgdfdu5DkLuu8jRZ7hHqTZEbwi39HlxyZywuZ2Gv72AVxk6hFCWQCzQ3L8osTlunZ80pJaVLUAeXKlbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  6 Oct 2026 17:56:40 +0900 Hajime Tazaki <thehajime@gmail.com> wrote:

> This patchset adds an ability to execute kselftest on nommu platforms.
> 
> Currently there are several issues if we wish to run kselftests on nommu
> targets:
> 
> - it cannot compile/build test binaries because the current files mainly
>   assume to build with glibc,
> - some of the tests are not able to run on nommu targets as there are no
>   fork(2) syscall.
> 
> The first issue can be avoided if we can build static PIE binaries (if
> targets support it), but in our case (build on ubuntu/glibc and run on
> alpine/musl-libc), it fails to invoke due to lack of the GNU ifunc
> mechanism.  Thus, we need to cross-compile with musl toolchain, which
> needs to be solved the first issue.
> 
> The second issue is the lack of fork(2) syscall on those platforms.
> Especially the test harness helper (kselftest_harness.h) uses the
> syscall, which cannot be simply with vfork(2).  `timeout` command used
> in `runner.sh` never works for nommu platform as it uses fork(2).
> 
> nommu component in the mm subsystem has several known issues and having
> test cases should help this situation, thus this patchset is very first
> step toward enriching test environment which has not been well tested
> for a while.  The test cases is implemented based on the document
> (Documentation/admin-guide/mm/nommu-mmap.rst).
> 
> Initial shape for this patches is implemented as an opt-in TARGET, not
> built/invoked automatically if users don't specify this nommu target.

Thanks, I've updated mm.git's mm-unstable branch with this version.

Then I moved the series down into the tail of the mm-unstable branch,
in preparation for excluding it from the 7.3-rcX queue.

It's changing a lot and it isn't converging quickly and review hasn't
happened and everyone's traveling so I'll likely hold this series over
for 7.4-rcX.

Hang in there - it's great that you're caring for nommu!

> --

That should be --- (in the patches too).

<grabs the v4->v5 logging from the individual patches>

> v4 => v5
> - remove build-time selection and detect NOMMU at runtime
> - remove #ifdef NOMMU and use a global variable detected from /proc/meminfo

Here's how v5 altered mm.git:



 Documentation/dev-tools/kselftest.rst             |   18 +-
 tools/testing/selftests/kselftest/runner.sh       |    9 -
 tools/testing/selftests/nommu/Makefile            |    1 
 tools/testing/selftests/nommu/local.mk            |    7 
 tools/testing/selftests/nommu/nommu.h             |   33 ++++
 tools/testing/selftests/nommu/nommu_mmap_test.c   |   91 ++++++------
 tools/testing/selftests/nommu/nommu_mremap_test.c |   72 ++++-----
 7 files changed, 129 insertions(+), 102 deletions(-)

--- a/Documentation/dev-tools/kselftest.rst~b
+++ a/Documentation/dev-tools/kselftest.rst
@@ -233,16 +233,20 @@ section::
 Build and test on nommu target
 ==============================
 
-If you (cross-)build kselftests for nommu targets, or run tests on nommu targets, use
-``NOMMU=1`` as a make variable/environment setting to tell build system to do the additional
-checks.  These nommu targets may differ in several ways, such as not supporting fork(2) or
-using musl or another libc.  Set this variable to apply the necessary build and test adjustments.
+The nommu selftests detect NOMMU at runtime by checking for the ``MmapCopy``
+entry in ``/proc/meminfo``. Ensure procfs is mounted at ``/proc`` before
+building and running the tests.
 
 ::
 
-  $ make ARCH=um NOMMU=1 O=build kselftest-all TARGETS=nommu  # <= build-only
-  $ make ARCH=um NOMMU=1 O=build kselftest-install TARGETS=nommu
-  $ NOMMU=1 ./build/kselftest/kselftest_install/run_kselftest.sh -p -c nommu
+  $ make ARCH=um O=build kselftest-all TARGETS=nommu  # <= build-only
+  $ make ARCH=um O=build kselftest-install TARGETS=nommu
+  $ ./build/kselftest/kselftest_install/run_kselftest.sh -p -c nommu
+
+The C tests report a skip if ``/proc/meminfo`` is unavailable. On a NOMMU
+system, the runner needs that file to avoid wrapping the tests in ``timeout``
+before they can report a skip. Mounting procfs is therefore a prerequisite
+for running this target through the kselftest runner.
 
 Contributing new tests
 ======================
--- a/tools/testing/selftests/kselftest/runner.sh~b
+++ a/tools/testing/selftests/kselftest/runner.sh
@@ -36,14 +36,19 @@ tap_prefix()
 	fi
 }
 
+is_nommu()
+{
+	grep -q '^MmapCopy:' /proc/meminfo 2>/dev/null
+}
+
 tap_timeout()
 {
 	# nommu doesn't support timeout command (missing fork(2))
-	if [ "$NOMMU" = "1" ] ; then
+	if is_nommu; then
 		echo "timeout isn't supported for NOMMU"
 		$1
 	# Make sure tests will time out if utility is available.
-	elif [ -x /usr/bin/timeout ] ; then
+	elif [ -x /usr/bin/timeout ]; then
 		/usr/bin/timeout --foreground "$kselftest_timeout" \
 			/usr/bin/timeout "$kselftest_timeout" $1
 	else
diff --git a/tools/testing/selftests/nommu/local.mk a/tools/testing/selftests/nommu/local.mk
deleted file mode 100644
--- a/tools/testing/selftests/nommu/local.mk
+++ /dev/null
@@ -1,7 +0,0 @@
-# detect if users request NOMMU build or not
-# User can set NOMMU to 1 to build/test for NOMMU platforms
-NOMMU ?= 0
-ifeq ($(NOMMU),1)
-CFLAGS += -DNOMMU
-export NOMMU
-endif
--- a/tools/testing/selftests/nommu/Makefile~b
+++ a/tools/testing/selftests/nommu/Makefile
@@ -5,4 +5,3 @@ TEST_GEN_PROGS += nommu_mmap_test
 TEST_GEN_PROGS += nommu_mremap_test
 
 include ../lib.mk
-include local.mk
diff --git a/tools/testing/selftests/nommu/nommu.h a/tools/testing/selftests/nommu/nommu.h
new file mode 100644
--- /dev/null
+++ a/tools/testing/selftests/nommu/nommu.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef NOMMU_H
+#define NOMMU_H
+
+#include <stdio.h>
+#include <string.h>
+
+/* Returns 1 for NOMMU, 0 for MMU, and -1 if /proc/meminfo is unavailable. */
+static inline int ksft_is_nommu(void)
+{
+	FILE *fp;
+	char line[256];
+	int nommu = 0;
+
+	fp = fopen("/proc/meminfo", "r");
+	if (!fp)
+		return -1;
+
+	while (fgets(line, sizeof(line), fp)) {
+		if (strncmp(line, "MmapCopy:", sizeof("MmapCopy:") - 1) == 0) {
+			nommu = 1;
+			break;
+		}
+	}
+
+	if (ferror(fp))
+		nommu = -1;
+	fclose(fp);
+
+	return nommu;
+}
+
+#endif
--- a/tools/testing/selftests/nommu/nommu_mmap_test.c~b
+++ a/tools/testing/selftests/nommu/nommu_mmap_test.c
@@ -9,6 +9,7 @@
 #include <string.h>
 #include <limits.h>
 #include "kselftest.h"
+#include "nommu.h"
 
 #include <sys/vfs.h>
 #ifndef RAMFS_MAGIC
@@ -16,6 +17,7 @@
 #endif
 
 static size_t ps;
+static int nommu;
 
 struct test_case_t {
 	const char *name;
@@ -31,6 +33,9 @@ static int get_shm_expected_error(const
 {
 	struct statfs fs;
 
+	if (!nommu)
+		return 0;
+
 	if (statfs(path, &fs) == 0) {
 		if (fs.f_type == RAMFS_MAGIC)
 			return 0; /* ramfs succeed with contiguous memory */
@@ -74,11 +79,7 @@ static struct test_case_t test_cases[] =
 		.mmap_prot = PROT_READ | PROT_WRITE,
 		.mmap_flags = MAP_SHARED,
 		.exp_err = 0,
-#ifdef NOMMU
 		.resolve_exp_err = get_shm_expected_error,
-#else
-		.resolve_exp_err = NULL,
-#endif
 	},
 	{
 		.name = "non-anonymous shared file mapping (r--)",
@@ -87,18 +88,14 @@ static struct test_case_t test_cases[] =
 		.mmap_prot = PROT_READ,
 		.mmap_flags = MAP_SHARED,
 		.exp_err = 0,
-#ifdef NOMMU
 		.resolve_exp_err = get_shm_expected_error,
-#else
-		.resolve_exp_err = 0,
-#endif
 	},
 };
 
 static int run_mapping_matrix_test(struct test_case_t *tcase)
 {
 	int fd;
-	void *ptr;
+	void *ptr = MAP_FAILED;
 	char path_buf[PATH_MAX];
 	const char *path = tcase->pathname;
 	int rc = KSFT_PASS;
@@ -120,10 +117,8 @@ static int run_mapping_matrix_test(struc
 		}
 		if (ftruncate(fd, ps) != 0) {
 			ksft_print_msg("ftruncate failed for: %s\n", tcase->pathname);
-			ksft_test_result_fail("%s\n", tcase->name);
-			close(fd);
-			unlink(path_buf);
-			return KSFT_FAIL;
+			rc = KSFT_FAIL;
+			goto cleanup;
 		}
 		path = path_buf;
 	} else {
@@ -146,41 +141,42 @@ static int run_mapping_matrix_test(struc
 		if (ptr != MAP_FAILED) {
 			ksft_print_msg("mmap unexpectedly succeeded (exp error %d)\n",
 					      expected_error);
-			ksft_test_result_fail("%s\n", tcase->name);
-			munmap(ptr, ps);
 			rc = KSFT_FAIL;
 			goto cleanup;
 		}
 		if (errno != expected_error) {
 			ksft_print_msg("mmap failed with %d (%s), but expected %d\n",
 				errno, strerror(errno), expected_error);
-			ksft_test_result_fail("%s\n", tcase->name);
 			rc = KSFT_FAIL;
 			goto cleanup;
 		}
 		ksft_print_msg("Correctly rejected with expected error %s(%d)\n",
 			strerror(expected_error), expected_error);
-		ksft_test_result_pass("%s\n", tcase->name);
 		rc = KSFT_PASS;
 		goto cleanup;
 	}
 
 	if (ptr == MAP_FAILED) {
 		ksft_print_msg("mmap failed unexpectedly: %s\n", strerror(errno));
-		ksft_test_result_fail("%s\n", tcase->name);
 		rc = KSFT_FAIL;
 		goto cleanup;
 	}
 
-	ksft_test_result_pass("%s\n", tcase->name);
-	munmap(ptr, ps);
-
 cleanup:
+	if (ptr != MAP_FAILED && munmap(ptr, ps)) {
+		ksft_print_msg("munmap failed: %s\n", strerror(errno));
+		rc = KSFT_FAIL;
+	}
 	if (fd >= 0) {
 		close(fd);
-		if (tcase->pathname && strstr(tcase->pathname, "XXXXXX"))
-			unlink(path_buf);
+		if (tcase->pathname && strstr(tcase->pathname, "XXXXXX") &&
+		    unlink(path_buf)) {
+			ksft_print_msg("unlink failed for %s: %s\n",
+				       path_buf, strerror(errno));
+			rc = KSFT_FAIL;
+		}
 	}
+	ksft_test_result_report(rc, "%s\n", tcase->name);
 	return rc;
 }
 
@@ -210,48 +206,55 @@ static int test_map_fixed(void)
 	ptr = mmap(fixed_addr, ps, PROT_READ | PROT_WRITE,
 		MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0);
 
-#ifdef NOMMU
-	if (ptr == MAP_FAILED && (errno == ENODEV || errno == EINVAL)) {
-		ksft_print_msg("MAP_FIXED correctly rejected under nommu\n");
-		ksft_test_result_pass("MAP_FIXED behavior\n");
-		return KSFT_PASS;
-	}
-	if (ptr != MAP_FAILED) {
-		ksft_print_msg("MAP_FIXED unexpectedly allowed under nommu\n");
+	if (nommu) {
+		if (ptr == MAP_FAILED && (errno == ENODEV || errno == EINVAL)) {
+			ksft_print_msg("MAP_FIXED correctly rejected under nommu\n");
+			ksft_test_result_pass("MAP_FIXED behavior\n");
+			return KSFT_PASS;
+		}
+		if (ptr != MAP_FAILED) {
+			ksft_print_msg("MAP_FIXED unexpectedly allowed under nommu\n");
+			ksft_test_result_fail("MAP_FIXED behavior\n");
+			if (munmap(ptr, ps))
+				ksft_print_msg("munmap failed: %s\n", strerror(errno));
+			return KSFT_FAIL;
+		}
+		ksft_print_msg("MAP_FIXED failed under NOMMU: %s\n",
+				      strerror(errno));
 		ksft_test_result_fail("MAP_FIXED behavior\n");
-		munmap(ptr, ps);
 		return KSFT_FAIL;
 	}
-	ksft_print_msg("MAP_FIXED failed under NOMMU: %s\n",
-			      strerror(errno));
-	ksft_test_result_fail("MAP_FIXED behavior\n");
-	return KSFT_FAIL;
-#else
 	if (ptr != MAP_FAILED) {
 		ksft_print_msg("MAP_FIXED successfully allocated under MMU\n");
+		if (munmap(ptr, ps)) {
+			ksft_print_msg("munmap failed: %s\n", strerror(errno));
+			ksft_test_result_fail("MAP_FIXED behavior\n");
+			return KSFT_FAIL;
+		}
 		ksft_test_result_pass("MAP_FIXED behavior\n");
-		munmap(ptr, ps);
 		return KSFT_PASS;
 	}
 	ksft_print_msg("MAP_FIXED failed allocation under MMU\n");
 	ksft_test_result_fail("MAP_FIXED behavior\n");
 	return KSFT_FAIL;
-#endif
 }
 
 int main(int argc, char **argv)
 {
 	int i;
 
+	nommu = ksft_is_nommu();
+	if (nommu < 0)
+		ksft_exit_skip("Cannot read /proc/meminfo; mount procfs at /proc\n");
+
 	ps = sysconf(_SC_PAGESIZE);
 	ksft_print_header();
 	ksft_set_plan(ARRAY_SIZE(test_cases) + 1);
 
-#ifdef NOMMU
-	ksft_print_msg("Running strict MMAP test criteria under nommu architecture\n");
-#else
-	ksft_print_msg("Running MMAP test criteria under MMU architecture\n");
-#endif
+	if (nommu)
+		ksft_print_msg("Running strict MMAP test criteria under nommu architecture\n");
+	else
+		ksft_print_msg("Running MMAP test criteria under MMU architecture\n");
 
 	test_map_fixed();
 	for (i = 0; i < (int)ARRAY_SIZE(test_cases); i++)
--- a/tools/testing/selftests/nommu/nommu_mremap_test.c~b
+++ a/tools/testing/selftests/nommu/nommu_mremap_test.c
@@ -9,6 +9,7 @@
 #include <string.h>
 #include <limits.h>
 #include "kselftest.h"
+#include "nommu.h"
 
 #include <sys/vfs.h>
 #ifndef RAMFS_MAGIC
@@ -16,6 +17,7 @@
 #endif
 
 static size_t ps;
+static int nommu;
 
 static long get_fs_type(const char *path)
 {
@@ -45,8 +47,7 @@ static void munmap_shrink_test(void)
 		if (ret != 0) {
 			ksft_print_msg("memory %p isn't unmapped at %p\n",
 				addr, (char *)addr + ps * i);
-			ksft_test_result_fail("munmap shrink\n");
-			return;
+			goto error;
 		}
 
 		if (i == 0) {
@@ -67,8 +68,10 @@ static void munmap_shrink_test(void)
 	ksft_test_result_pass("munmap shrink\n");
 	return;
 error:
-	for (int j = 0; j < 4; j++)
-		munmap((char *)addr + j * ps, ps);
+	for (int j = 0; j < 4; j++) {
+		if (munmap((char *)addr + j * ps, ps))
+			ksft_print_msg("cleanup munmap failed: %s\n", strerror(errno));
+	}
 	ksft_print_msg("clean up failures\n");
 	ksft_test_result_fail("munmap shrink\n");
 }
@@ -132,7 +135,7 @@ static void mremap_shrink_test(void)
 
 static int get_shared_writable_file_expected_error(const char *path)
 {
-	if (get_fs_type(path) == RAMFS_MAGIC)
+	if (nommu && get_fs_type(path) == RAMFS_MAGIC)
 		return EPERM; /* ramfs failed */
 
 	return 0;
@@ -145,6 +148,7 @@ struct mremap_case_t {
 	int mmap_prot;
 	int mmap_flags;
 	int exp_err;
+	int nommu_exp_err;
 	int (*resolve_exp_err)(const char *path);
 	unsigned int old_pages;
 	unsigned int new_pages;
@@ -167,11 +171,7 @@ static struct mremap_case_t mremap_cases
 		.mmap_prot = PROT_READ,
 		.mmap_flags = MAP_SHARED,
 		.exp_err = 0,
-#ifdef NOMMU
 		.resolve_exp_err = get_shared_writable_file_expected_error,
-#else
-		.resolve_exp_err = 0,
-#endif
 	},
 	{
 		.name = "private file unchanged length (r-)",
@@ -179,11 +179,8 @@ static struct mremap_case_t mremap_cases
 		.open_flags = O_CREAT | O_RDWR | O_EXCL,
 		.mmap_prot = PROT_READ,
 		.mmap_flags = MAP_PRIVATE,
-#ifdef NOMMU
-		.exp_err = EPERM,
-#else
 		.exp_err = 0,
-#endif
+		.nommu_exp_err = EPERM,
 		.resolve_exp_err = 0,
 		.old_pages = 4,
 		.new_pages = 4,
@@ -205,11 +202,8 @@ static struct mremap_case_t mremap_cases
 		.open_flags = O_CREAT | O_RDWR | O_EXCL,
 		.mmap_prot = PROT_READ,
 		.mmap_flags = MAP_PRIVATE,
-#ifdef NOMMU
-		.exp_err = EPERM,
-#else
 		.exp_err = 0,
-#endif
+		.nommu_exp_err = EPERM,
 		.resolve_exp_err = 0,
 		.old_pages = 4,
 		.new_pages = 8,
@@ -220,11 +214,8 @@ static struct mremap_case_t mremap_cases
 		.open_flags = O_CREAT | O_RDWR | O_EXCL,
 		.mmap_prot = PROT_READ | PROT_WRITE,
 		.mmap_flags = MAP_PRIVATE,
-#ifdef NOMMU
-		.exp_err = ENOMEM,
-#else
 		.exp_err = 0,
-#endif
+		.nommu_exp_err = ENOMEM,
 		.resolve_exp_err = 0,
 		.old_pages = 4,
 		.new_pages = 8,
@@ -257,22 +248,17 @@ static int run_mremap_test(struct mremap
 		}
 		if (ftruncate(fd, ps * file_pages) != 0) {
 			ksft_print_msg("Failed to setup file backing\n");
-			ksft_test_result_fail("%s\n", tcase->name);
-			close(fd);
-			unlink(pb);
-			return KSFT_FAIL;
+			rc = KSFT_FAIL;
+			goto out;
 		}
 
-#ifdef NOMMU
-		if ((tcase->mmap_flags & MAP_SHARED) && get_fs_type(pb) != RAMFS_MAGIC) {
+		if (nommu && (tcase->mmap_flags & MAP_SHARED) &&
+		    get_fs_type(pb) != RAMFS_MAGIC) {
 			ksft_print_msg("Skip the test under non-ramfs filesystem (%s)\n",
 				pb);
-			ksft_test_result_skip("%s\n", tcase->name);
-			close(fd);
-			unlink(pb);
-			return KSFT_SKIP;
+			rc = KSFT_SKIP;
+			goto out;
 		}
-#endif
 		path = pb;
 	} else if (tcase->pathname) {
 		fd = open(tcase->pathname, tcase->open_flags, 0600);
@@ -282,16 +268,13 @@ static int run_mremap_test(struct mremap
 			return KSFT_SKIP;
 		}
 
-#ifdef NOMMU
-		if ((tcase->mmap_flags & MAP_SHARED) &&
+		if (nommu && (tcase->mmap_flags & MAP_SHARED) &&
 		    get_fs_type(tcase->pathname) != RAMFS_MAGIC) {
 			ksft_print_msg("Skip the test under non-ramfs filesystem (%s)\n",
 					      tcase->pathname);
-			ksft_test_result_skip("%s\n", tcase->name);
-			close(fd);
-			return KSFT_SKIP;
+			rc = KSFT_SKIP;
+			goto out;
 		}
-#endif
 	}
 
 	addr = mmap(NULL, ps * old_pages, tcase->mmap_prot,
@@ -302,7 +285,7 @@ static int run_mremap_test(struct mremap
 		goto out;
 	}
 
-	expected_error = tcase->exp_err;
+	expected_error = nommu ? tcase->nommu_exp_err : tcase->exp_err;
 	if (tcase->resolve_exp_err && fd >= 0)
 		expected_error = tcase->resolve_exp_err(path);
 
@@ -340,8 +323,11 @@ static int run_mremap_test(struct mremap
 out:
 	if (fd >= 0) {
 		close(fd);
-		if (tcase->pathname && strstr(tcase->pathname, "XXXXXX"))
-			unlink(pb);
+		if (tcase->pathname && strstr(tcase->pathname, "XXXXXX") &&
+		    unlink(pb)) {
+			ksft_print_msg("unlink failed for %s: %s\n", pb, strerror(errno));
+			rc = KSFT_FAIL;
+		}
 	}
 
 	ksft_test_result_report(rc, "%s\n", tcase->name);
@@ -352,6 +338,10 @@ int main(int argc, char **argv)
 {
 	int i;
 
+	nommu = ksft_is_nommu();
+	if (nommu < 0)
+		ksft_exit_skip("Cannot read /proc/meminfo; mount procfs at /proc\n");
+
 	ps = sysconf(_SC_PAGESIZE);
 	ksft_print_header();
 	ksft_set_plan(ARRAY_SIZE(mremap_cases) + 2);
_


