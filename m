Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD10FEB3641
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 01:00:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F2D66B00E3; Mon,  2 Mar 2026 20:00:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D5106B00E5; Mon,  2 Mar 2026 20:00:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F229A6B00E6; Mon,  2 Mar 2026 20:00:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D97D36B00E3
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:00:45 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7860A140457
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 01:00:45 +0000 (UTC)
X-FDA: 84502946850.03.9419475
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf29.hostedemail.com (Postfix) with ESMTP id A1267120019
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 01:00:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VBKoOsC7;
	spf=pass (imf29.hostedemail.com: domain of 3ujKmaQ4KCA0w14qn04vpun4q5t11tyr.p1zyv07A-zzx8npx.14t@flex--jordanrichards.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3ujKmaQ4KCA0w14qn04vpun4q5t11tyr.p1zyv07A-zzx8npx.14t@flex--jordanrichards.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772499643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6LBYWilsGadQ1Pufl4WrAtKAejCy/lhARa3nYcHQerM=;
	b=qe92kJhiStVYJ/GwL2PmLsWz6A7+dtONY0mkvJ2kjOLErHLBe/deaCUo9wRy5UUPWZBV9l
	uSfSv8yZSFsYmGfaeyBuEQ3E/GHxKWii4IEzAVhR08O/66bKXYCJRI7/F4hy4voLzL/Ne8
	uBMJE3iya3jU1O83qtalHJb0rQHF4g0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VBKoOsC7;
	spf=pass (imf29.hostedemail.com: domain of 3ujKmaQ4KCA0w14qn04vpun4q5t11tyr.p1zyv07A-zzx8npx.14t@flex--jordanrichards.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3ujKmaQ4KCA0w14qn04vpun4q5t11tyr.p1zyv07A-zzx8npx.14t@flex--jordanrichards.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772499643; a=rsa-sha256;
	cv=none;
	b=QZ3Ua+7jBWAfgNsZYOFKLcpdRGU/CM5UtC5nb61oSrylJO2XYckfVHm3mJFPMctsy6w0Kt
	8nBIkGBBkOjfvEQ/aWcf6eslGKV6yUmQjwr+fYu/cXUz7NggGRUy4tqHQ+f0kAYosqvULo
	9FkZEgRZzpLG/C8zj/LHhb72kRFG10Q=
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2bdd4ce8dc3so10021074eec.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 17:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772499642; x=1773104442; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6LBYWilsGadQ1Pufl4WrAtKAejCy/lhARa3nYcHQerM=;
        b=VBKoOsC78hDYgeLoqskl6arzGcV+kXYCMxb/xlZj4xAgVDV/6mISK1LlC5mEtyuebT
         eHmUYboFUkv1INSRQd0vMAkZ/LyDQR33gCGP+8/3MrDoRGoaB4ZNsWqJ3eajcEIyPYDB
         MBCeSQOQmD86CAQXKJ9qYaftmdzHr0/IG2ZVmAjs89PcAW3oSN+uh2NB6HZVx2bfd6JR
         +TAWkgpvGfF2HWTydpaFlrsJlO/w5csS+5poIjSy2gp3qtU8venWJdlwuITREqXFQ0cg
         nwjv/6lrS987poLB1YGdiKZgaVvHSAXJFJwTLXXo7bWrnB/zhgdLMlUiriXyOjfCIlNm
         +sdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772499642; x=1773104442;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6LBYWilsGadQ1Pufl4WrAtKAejCy/lhARa3nYcHQerM=;
        b=uOk3FHsrDnoAhFc6qZi2Fgps+oCktcb/YAO88p67Es03hRvXKkaOtyB3fHDjRBqq+y
         z1SmBCt79tjQWvLwNIoANyRJukLRwraTmthKBDaIslcxJNCkc87bF4LtAoXv0saQ1nZq
         eN4uYmtxl9B/zi5ID9OogFRv3qmTS5QkCRpECqNGpKhCZxBZM8Co2lS2GZcM/sHeoYRL
         t4vRDVY1ZCYh+DVkSFuMi7cawbZw5iSZvHO3bZByo0CecxUi4m8zeddMQuJIk1FSVylN
         1cm3NJY4F2JZvRKI8vFx1klwc95a9IrvBWQbvaUs+te/MsTAlwvgTGGGdNVzGVyJKI2U
         2GKQ==
X-Forwarded-Encrypted: i=1; AJvYcCU0CTtd2KrtdKi/H/X90w7fhZ/Yu4rRZ0bGvh1sBeCXhwZatAXaz3+CyFBqaTikfSqy8VT4m5irFw==@kvack.org
X-Gm-Message-State: AOJu0YxFMWkWHiT2jsg9njcXexDNpUkAPDCVfD68JDJSWxyhxYOh0T69
	IR9pawPXfLoqZCF678178HspUes3ODuCFiGKHu7MObREwJeECwVx3qltnG2MZ2r2Pla5MmJ8Ah1
	AD33+Yh+vnQ8jGtj07Quc9mvQte//+1tYw8SH1A==
X-Received: from dybir8.prod.google.com ([2002:a05:7300:c8c8:b0:2be:1796:e189])
 (user=jordanrichards job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:a198:b0:2be:694:5713 with SMTP id 5a478bee46e88-2be069458e8mr3073775eec.36.1772499642072;
 Mon, 02 Mar 2026 17:00:42 -0800 (PST)
Date: Tue,  3 Mar 2026 01:00:38 +0000
In-Reply-To: <20260303010039.2969125-1-jordanrichards@google.com>
Mime-Version: 1.0
References: <20260303010039.2969125-1-jordanrichards@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260303010039.2969125-2-jordanrichards@google.com>
Subject: [PATCH v3 1/2] tools/nolibc: add ftruncate()
From: Jordan Richards <jordanrichards@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Shuah Khan <shuah@kernel.org>, Willy Tarreau <w@1wt.eu>, 
	"=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?=" <linux@weissschuh.net>
Cc: Jason Miu <jasonmiu@google.com>, David Matlack <dmatlack@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jordan Richards <jordanrichards@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: A1267120019
X-Stat-Signature: uj376z7hcdd3wqajpfzsbrwazbqme11c
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772499643-602046
X-HE-Meta: U2FsdGVkX18IYo9FeilIc6vkTTEZp7JC3CfBStcVsIXfCuyQyoihda+3Jc8SbH3pgZKgevEPWSMYo83YaLEm/nsumnGUu+tHQc5c/aUPOaEVPkVxICNDFCbRu+0RJNv6h/DSZ3yyR95y7jUmyeVFuAG3AfH8ZDfBu80b4DPHrNBV2NkIxyqg6CU+pjXfAl2Dg5uAlaR0tdG3cltSrKF8DC048Zm4ufetBdKDkx5ZOANcoBTyumZor9TDtLmDihFID6PrjPACF2WlQWityMBmqxGjsERiUD+RWzxcrURjbcrmmRD6NYlV8rPe0KIw0NIrQPWhvZ7LO5y/zFl/65aoI4aCHnrAY01eK9sQUtpQSHWxKVVRiXYnFcfuHdJP5KL0cKpzaCpoNV6eVAOzw/8l8deX4n5H+NFv32ur6RxzR0HzOcHVf1GjTGieWWum1LEwmIm2HuWxCGUtxvnWO4JA5MUD36lgx3Dyf1uGICxz4/jp+ZPtvFQ5tuzX69ztvb9/P4l1d9HA+OKZrOv+xhpMWXqu8mKSwgDl0IjPDp1mEE0plCrT2r+BcZh3MgGak3DKEh6oTpum6iNFOaXA4J7TnQwdlAcJH+N6vKJ373mjRZg+xijLLFb3SSWxvgY69fg8L8iRe7N/z9bnioy6Ctw6eeOKMEs4lkqQwsP3dh/r+5LRX+mdpKCpsJHjf2zx4LFSeQMo9+MzD248lcWXjtuJH8bsdfQi3kcoIOHxgDPDGP6vKEY6l8Cbe4RgZichCHO21Bw5jWu7iWCMTVJz4AeHjcis2NNJ1A3GXVeo5XKoTZqav1QyOiO5jdCQO/Ieb7adhS3hYjCo9BPjQAaCGdjW0Rby3fVi5Bu4n+KKq83lgaSKXVEgpr3rajHWWaKjVqTD/NZ/kP/9pNPtXA5HiFf3weDnTpk5bU+9DXyoi6Xccmcc2Ls5uw75WcNxcs4VANZRKxYU6YaFo7lpyDSM/yl
 MjDGX5UZ
 VY6h9yo/R1QSv2t1kNhBcijAxU+n7dej+Dt/IoVcvIlUyw62jqoCAxcDHFvNuOsL6jZ53zt0vY2blyjvTIqh9k+xu586/XG8iSAV71i1U8127v7Q3ra7btWLKFB+H0DMS8TvL7SGI2Lzt+CM2XZ8o/GxmPUcXKPuOzaTrnT51RyXwg35nCeEISXFmYyvd6WNZjCbRYEifBUKzrGNURmWn9QqaoWt5EposfYc8wxpgDbN9ni/ZD7SzST+f7ANL+C+56+slYsmcvsEiV3C7YGDD3HM1zmYfurwXE4H9d+BRYpRkV9XOPh/o2RdCbKiFSYRiCy0LZQl5H7xDlkB3xFbZNmInosu/R8OtnhX6DsCPFchmYSiGq97XJ5lLZ7O8vvQ3bwORM8T3k8ZL0eBIxisv5lnlHf9oocXoQ6ORKs+t9aSPezypz5bp8N414qSdUpd8O25kEtgjfv5cbgvu2bhUu0fzQuFnZmlCfyaxvxKk/aWeIfO5xKf/VjgMmALT7IEOyk30YiMbPJH3sofQJxTQej4TOncRc+lDpxZ1VIaElMN7/9bIn6bGw5U+JPiw0VnU3U6vIscu5eWgAT4v1GNB5tKU3vQdbFim5HUpCeBx5G7N5XY5OtYO8J/1ej5RZmskG3MPoxX6uv7XEZkWkAoq151m36BdRVN7uxZ09GXLhjN7GI65OfQ6Dmde7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On architectures with 32-bit longs, call the compat syscall
__NR_ftruncate64. As off_t is 64-bit it must be split into 2 registers.
Unlike llseek() which passes the high and low parts in explicitly named
arguments, the order here is endian independent.

Some architectures (arm, mips, ppc) require this pair of registers to
be aligned to an even register, so add custom sys_ftruncate64 wrappers
for those.

A test case for ftruncate is added which validates negative length or
invalid fd return the appropriate error, and checks the length is
correct on success.

Signed-off-by: Jordan Richards <jordanrichards@google.com>
---
 tools/include/nolibc/arch-arm.h              | 11 +++++
 tools/include/nolibc/arch-mips.h             | 11 +++++
 tools/include/nolibc/arch-powerpc.h          | 11 +++++
 tools/include/nolibc/unistd.h                | 35 ++++++++++++++
 tools/testing/selftests/nolibc/nolibc-test.c | 51 ++++++++++++++++++++
 5 files changed, 119 insertions(+)

diff --git a/tools/include/nolibc/arch-arm.h b/tools/include/nolibc/arch-arm.h
index 251c42579028..ed65fb674e61 100644
--- a/tools/include/nolibc/arch-arm.h
+++ b/tools/include/nolibc/arch-arm.h
@@ -6,9 +6,11 @@
 
 #ifndef _NOLIBC_ARCH_ARM_H
 #define _NOLIBC_ARCH_ARM_H
+#include <linux/unistd.h>
 
 #include "compiler.h"
 #include "crt.h"
+#include "std.h"
 
 /* Syscalls for ARM in ARM or Thumb modes :
  *   - registers are 32-bit
@@ -196,4 +198,13 @@ void __attribute__((weak, noreturn)) __nolibc_entrypoint __no_stack_protector _s
 }
 #endif /* NOLIBC_NO_RUNTIME */
 
+#ifdef __NR_ftruncate64
+static __attribute__((unused))
+int sys_ftruncate64(int fd, uint32_t length0, uint32_t length1)
+{
+	return my_syscall4(__NR_ftruncate64, fd, 0, length0, length1);
+}
+#define sys_ftruncate64 sys_ftruncate64
+#endif
+
 #endif /* _NOLIBC_ARCH_ARM_H */
diff --git a/tools/include/nolibc/arch-mips.h b/tools/include/nolibc/arch-mips.h
index a72506ceec6b..26d044004ec6 100644
--- a/tools/include/nolibc/arch-mips.h
+++ b/tools/include/nolibc/arch-mips.h
@@ -6,9 +6,11 @@
 
 #ifndef _NOLIBC_ARCH_MIPS_H
 #define _NOLIBC_ARCH_MIPS_H
+#include <linux/unistd.h>
 
 #include "compiler.h"
 #include "crt.h"
+#include "std.h"
 
 #if !defined(_ABIO32) && !defined(_ABIN32) && !defined(_ABI64)
 #error Unsupported MIPS ABI
@@ -269,4 +271,13 @@ void __attribute__((weak, noreturn)) __nolibc_entrypoint __no_stack_protector __
 }
 #endif /* NOLIBC_NO_RUNTIME */
 
+#ifdef __NR_ftruncate64
+static __attribute__((unused))
+int sys_ftruncate64(int fd, uint32_t length0, uint32_t length1)
+{
+	return my_syscall4(__NR_ftruncate64, fd, 0, length0, length1);
+}
+#define sys_ftruncate64 sys_ftruncate64
+#endif
+
 #endif /* _NOLIBC_ARCH_MIPS_H */
diff --git a/tools/include/nolibc/arch-powerpc.h b/tools/include/nolibc/arch-powerpc.h
index e0c7e0b81f7c..71829cb027e8 100644
--- a/tools/include/nolibc/arch-powerpc.h
+++ b/tools/include/nolibc/arch-powerpc.h
@@ -6,9 +6,11 @@
 
 #ifndef _NOLIBC_ARCH_POWERPC_H
 #define _NOLIBC_ARCH_POWERPC_H
+#include <linux/unistd.h>
 
 #include "compiler.h"
 #include "crt.h"
+#include "std.h"
 
 /* Syscalls for PowerPC :
  *   - stack is 16-byte aligned
@@ -218,4 +220,13 @@ void __attribute__((weak, noreturn)) __nolibc_entrypoint __no_stack_protector _s
 }
 #endif /* NOLIBC_NO_RUNTIME */
 
+#ifdef __NR_ftruncate64
+static __attribute__((unused))
+int sys_ftruncate64(int fd, uint32_t length0, uint32_t length1)
+{
+	return my_syscall4(__NR_ftruncate64, fd, 0, length0, length1);
+}
+#define sys_ftruncate64 sys_ftruncate64
+#endif
+
 #endif /* _NOLIBC_ARCH_POWERPC_H */
diff --git a/tools/include/nolibc/unistd.h b/tools/include/nolibc/unistd.h
index bb5e80f3f05d..85ac253f9189 100644
--- a/tools/include/nolibc/unistd.h
+++ b/tools/include/nolibc/unistd.h
@@ -48,6 +48,41 @@ int access(const char *path, int amode)
 	return faccessat(AT_FDCWD, path, amode, 0);
 }
 
+#if !defined(sys_ftruncate64) && defined(__NR_ftruncate64)
+static __attribute__((unused))
+int sys_ftruncate64(int fd, uint32_t length0, uint32_t length1)
+{
+
+	return my_syscall3(__NR_ftruncate64, fd, length0, length1);
+}
+#define sys_ftruncate64 sys_ftruncate64
+#endif
+
+static __attribute__((unused))
+int sys_ftruncate(int fd, off_t length)
+{
+#ifdef sys_ftruncate64
+	union {
+		off_t length;
+		struct {
+			uint32_t length0;
+			uint32_t length1;
+		};
+	} arg;
+
+	arg.length = length;
+
+	return sys_ftruncate64(fd, arg.length0, arg.length1);
+#else
+	return my_syscall2(__NR_ftruncate, fd, length);
+#endif
+}
+
+static __attribute__((unused))
+int ftruncate(int fd, off_t length)
+{
+	return __sysret(sys_ftruncate(fd, length));
+}
 
 static __attribute__((unused))
 int msleep(unsigned int msecs)
diff --git a/tools/testing/selftests/nolibc/nolibc-test.c b/tools/testing/selftests/nolibc/nolibc-test.c
index 1b9d3b2e2491..6a84dfbb4b73 100644
--- a/tools/testing/selftests/nolibc/nolibc-test.c
+++ b/tools/testing/selftests/nolibc/nolibc-test.c
@@ -969,6 +969,56 @@ int test_fork(enum fork_type type)
 	}
 }
 
+int test_ftruncate(void)
+{
+	int ret;
+	int fd;
+	struct stat stat_buf;
+	const char *filename = "/tmp/ftruncate_test";
+
+	ret = ftruncate(-1, 0);
+	if (ret != -1 || errno != EBADF) {
+		errno = EINVAL;
+		return __LINE__;
+	}
+
+	fd = open(filename, O_RDWR | O_CREAT);
+	if (fd == -1)
+		return __LINE__;
+
+	ret = ftruncate(fd, -1);
+	if (ret != -1 || errno != EINVAL) {
+		if (ret == 0)
+			errno = EINVAL;
+		ret = __LINE__;
+		goto end;
+	}
+
+	ret = ftruncate(fd, 42);
+	if (ret != 0) {
+		ret = __LINE__;
+		goto end;
+	}
+
+	ret = fstat(fd, &stat_buf);
+	if (ret != 0) {
+		ret = __LINE__;
+		goto end;
+	}
+
+	if (stat_buf.st_size != 42) {
+		errno = EINVAL;
+		ret = stat_buf.st_size;
+		goto end;
+	}
+
+end:
+	close(fd);
+	unlink(filename);
+
+	return ret;
+}
+
 int test_stat_timestamps(void)
 {
 	struct stat st;
@@ -1406,6 +1456,7 @@ int run_syscall(int min, int max)
 		CASE_TEST(file_stream);       EXPECT_SYSZR(1, test_file_stream()); break;
 		CASE_TEST(file_stream_wsr);   EXPECT_SYSZR(1, test_file_stream_wsr()); break;
 		CASE_TEST(fork);              EXPECT_SYSZR(1, test_fork(FORK_STANDARD)); break;
+		CASE_TEST(ftruncate);         EXPECT_SYSZR(1, test_ftruncate()); break;
 		CASE_TEST(getdents64_root);   EXPECT_SYSNE(1, test_getdents64("/"), -1); break;
 		CASE_TEST(getdents64_null);   EXPECT_SYSER(1, test_getdents64("/dev/null"), -1, ENOTDIR); break;
 		CASE_TEST(directories);       EXPECT_SYSZR(proc, test_dirent()); break;
-- 
2.53.0.473.g4a7958ca14-goog


