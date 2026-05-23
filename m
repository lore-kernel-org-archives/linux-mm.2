Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22258CD5BBF
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:19:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B92E6B00BF; Fri, 22 May 2026 20:18:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 390956B00C0; Fri, 22 May 2026 20:18:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20AA06B00C1; Fri, 22 May 2026 20:18:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F48F6B00BF
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C2F6E140932
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:23 +0000 (UTC)
X-FDA: 84796772886.06.EFC6EC8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id BE05F1C000F
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hWWmskWv;
	spf=pass (imf20.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495501;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n/j4jxLkxbt9diFphmclt6O6zGb34kmu3UZWKDFhJe4=;
	b=obq5xoZ/+fSnaGRdpBpmE/VNJmU5jGaihWu40rPxomJW00b//lWeTZcqcTgdu8zBI9JAzV
	ZHnub6BWhXg2yTOC7bOOTZBuoVQZm49eNi515u7eNzQ3Vp4rwIgAqOaOatOkERg2/PNXby
	ggx8KSs9Vu5u1xttVHy6tfsWwn3Vkqg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hWWmskWv;
	spf=pass (imf20.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495501; a=rsa-sha256;
	cv=none;
	b=UnaVkTPI7xpoHBrsNL0qZ3TuXKiyfVSJOVo3NG9jPgcewgBTByquK34l6vUab1xiI2YvaU
	5JmJd5EcTwhEqkZuDPZppkEHvgGwxJQ9YVqquVk1/TFXbqeYaTdDgFkiwXNe838TDC0h/J
	pSZ/ulrRGuRWa9yv77uQe4c5FZb2yRA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 31ACB44E43;
	Sat, 23 May 2026 00:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C551DC2BCF5;
	Sat, 23 May 2026 00:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495486;
	bh=OrSHrO6FCi4MoaRpfocK1fL6LtiNdemV38aiZiH45fY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=hWWmskWvxDnu4i5LZj8TfYvxFq+kpsWOpWvzkV4NUrnP9XP0wAGfwt0/dhHjHYaY6
	 aHsNxA9pJu+vJV4xbsD9R08gN7oEVXdyVw2OM3bwan/mJWaU1entr0lmoDlrrgpba3
	 vXZGNNULFV33CVDzj+MrxMD0tAe6kGZk6TBQNbwMhghzIjMHCkmek00D/LLTj1WktC
	 wMAfgPgAQ35Hj0EjPFrDrwD2eG7hxGEoyyIQcuptD/8OrVt8LlEX0hA5PYFi5R0dSs
	 O6qQMguakgGeqy0yPCtl/JRnHU71YIVqUqKK+0MFwCJYIiSWtzhwJlEfsFnGvWQZDO
	 Bd/3qrmookuFA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6EC6CD5BC0;
	Sat, 23 May 2026 00:18:06 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:18:21 -0700
Subject: [PATCH v7 39/42] KVM: selftests: Make TEST_EXPECT_SIGBUS
 thread-safe
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-39-2f0fae496530@google.com>
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
In-Reply-To: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, liam@infradead.org, 
 Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495481; l=5288;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=fxyVQDCWd4OUIQk0jNIT+e/JB7ZBwP1cl4TN8h4ATeU=;
 b=CaDNWWMK4j5xnSzcNBdAZqu89IRY9gziL1tkDL1VAm5vWwGnW/59LKCIds8rF4V8tXnx5Ktt+
 3byFLPjVTIGAEGlFKAl83r2vs9vRiNVH8v/ygVId/W7HBdJmc0dSFCw
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Queue-Id: BE05F1C000F
X-Stat-Signature: x4fzntrg1zppyxuok9juieasba4i8ynq
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779495501-666919
X-HE-Meta: U2FsdGVkX1935iyQBHHjSbgccRja+GNE/YWi6YWZqRvAeY62xeXlMtR3UvjsPxquXaOws8LVnOV2mcFAr7Mxso0OH311k+XETFGXksIw+K8ZT5yi2zlzUEwEm55pn0k6Tt/cyPuX00SCJDpgGObgKrJ8rwkIaLCDV95/EiAomRyL0JAI5qyj0uLpjak/Lozf8nqV8PkLYVYXwOKsW90Kkb7oSQr9EPq9uySJz32+eXyKTJsFoZmVWA344XLRYtyxbP/z5ZK8abwBdkfjVTNaJxxYK6UQR+/C1AShLApqdThh5POdQY3pHmO4A0K6elS6RT1Bu6IMvzpnphgbCoOs9jvlL+PWTWydTd2gxzuPEnSUZZpnwtFUNnWuoyDkMRh8p15dcyflCjNG9RI8DttHcrIzPzpglA9EQusEp00Q78DaX1T5Tcvii+dA0SMl4qakIOl0GtIpodkqW0NoKKYK7D1btWQUyN6+9cfCTgC577Y2fgOqAo8cuW0Us1Z82MVYWYDs119c1SSf/p4JVDc6ZKrK9gVlAVH+ht5N8OsKrXgPBLuvrfl0wv+mQiANStexjS1FBnHqZayni3ehTHetygxp/FoL2ISCFwf+OunxIzZf1P0DzflniUmoxQuKidM10mW8Vyt6Cc2Jy8PIz0cs8CYytTPccZv+qUR1+ztp5tylN3ObWw+j+6G7BSQrgJ1Tfx9wAQJvA3aTvuewqob47R/HxTzzHp34GlyCe8Say/+BHD86QoCooFMfi34qWEjEkDST6Jefo7CVzeLvHOqPrKhnV4Lawl2PTf1XT3eoASrqpYP+KevIXgeD5PnXeHDPdO8rmlgMlPtnFhMGCqsrw/GhMYDcuX/tN8ss+cNoRygwJr/W6y3X3bGbSlJgVsszSsEXm8hEwd1c/UrRFDqDWFwEUucG3jziNZoP6iYQyAdA1VS5fPiHxmGoqcIt8vlpnGgB9UXMRtd9AiQmp/M
 NJPIgeVL
 WPGmikUfERPohp13ti5+tOhm4NLwHEb5tadot4eKeOlr3Ltx6ZAk5e3RiRxzatzcgvo7DO7/E2nxTsljovg7YrOa16VwJkuxvJPQkhwxGxCoY/Iyx3svVm6GNEFwiZdpuhM2AO6yVB17b/HhKvQk0Fho6HX19uIWuOXQaXSmRvRfzWMxakakgTFrpT+M+tkp21asTkVRv6ytF/+kI/0jc66nEqc6NF41wUwDV+z9gTR8YOQeEQu7Q/y3pfPsMVwzl7botFuT2Rigulgp72Yhemk2Unu0FbJjY+3D8+4pc4l7XOZ4m6yXXwkqGUv9eI7pwJcXvRDWaDmBE+TMgvuKKDbIbh3U+lGNHPXPsFzaaWF7mVekRj9Gl4sFQa+86IDJYfVPxm4EnTdX9bbqGhgQcrfpuTD4Ik943rELLI7DMizVlfyfzUol/oM13Ecy8AOMeT1G5gthIqJEdsbX5ogsu5C6z6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

The TEST_EXPECT_SIGBUS macro is not thread-safe as it uses a global
sigjmp_buf and installs a global SIGBUS signal handler. If multiple threads
execute the macro concurrently, they will race on installing the signal
handler and stomp on other threads' jump buffers, leading to incorrect test
behavior.

Make TEST_EXPECT_SIGBUS thread-safe with the following changes:

Share the KVM tests' global signal handler. sigaction() applies to all
threads; without sharing a global signal handler, one thread may have
removed the signal handler that another thread added, hence leading to
unexpected signals.

The alternative of layering signal handlers was considered, but calling
sigaction() within TEST_EXPECT_SIGBUS() necessarily creates a race. To
avoid adding new setup and teardown routines to do sigaction() and keep
usage of TEST_EXPECT_SIGBUS() simple, share the KVM tests' global signal
handler.

Opportunistically rename report_unexpected_signal to
catchall_signal_handler.

To continue to only expect SIGBUS within specific regions of code, use a
thread-specific variable, expecting_sigbus, to replace installing and
removing signal handlers.

Make the execution environment for the thread, sigjmp_buf, a
thread-specific variable.

As part of TEST_EXPECT_SIGBUS(), assert the prerequisite for this setup,
that the current signal handler is the catchall_signal_handler.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/test_util.h | 32 +++++++++++++------------
 tools/testing/selftests/kvm/lib/kvm_util.c      | 18 ++++++++++----
 tools/testing/selftests/kvm/lib/test_util.c     |  7 ------
 3 files changed, 30 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index c280c3233f502..c9ba4e010f0b8 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -82,21 +82,23 @@ do {									\
 	__builtin_unreachable(); \
 } while (0)
 
-extern sigjmp_buf expect_sigbus_jmpbuf;
-void expect_sigbus_handler(int signum);
-
-#define TEST_EXPECT_SIGBUS(action)						\
-do {										\
-	struct sigaction sa_old, sa_new = {					\
-		.sa_handler = expect_sigbus_handler,				\
-	};									\
-										\
-	sigaction(SIGBUS, &sa_new, &sa_old);					\
-	if (sigsetjmp(expect_sigbus_jmpbuf, 1) == 0) {				\
-		action;								\
-		TEST_FAIL("'%s' should have triggered SIGBUS", #action);	\
-	}									\
-	sigaction(SIGBUS, &sa_old, NULL);					\
+extern __thread sigjmp_buf expect_sigbus_jmpbuf;
+extern __thread volatile sig_atomic_t expecting_sigbus;
+extern void catchall_signal_handler(int signum);
+
+#define TEST_EXPECT_SIGBUS(action)					\
+do {									\
+	struct sigaction __sa = {};					\
+									\
+	TEST_ASSERT_EQ(sigaction(SIGBUS, NULL, &__sa), 0);		\
+	TEST_ASSERT_EQ(__sa.sa_handler, &catchall_signal_handler);	\
+									\
+	expecting_sigbus = true;					\
+	if (sigsetjmp(expect_sigbus_jmpbuf, 1) == 0) {			\
+		action;							\
+		TEST_FAIL("'%s' should have triggered SIGBUS", #action);\
+	}								\
+	expecting_sigbus = false;					\
 } while (0)
 
 size_t parse_size(const char *size);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 21c7e52a2bdac..a7725fff58b46 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2270,13 +2270,20 @@ __weak void kvm_selftest_arch_init(void)
 {
 }
 
-static void report_unexpected_signal(int signum)
+__thread sigjmp_buf expect_sigbus_jmpbuf;
+__thread volatile sig_atomic_t expecting_sigbus;
+
+void catchall_signal_handler(int signum)
 {
+	switch (signum) {
+	case SIGBUS: {
+		if (expecting_sigbus)
+			siglongjmp(expect_sigbus_jmpbuf, 1);
+
+		TEST_FAIL("Unexpected SIGBUS (%d)\n", signum);
+	}
 #define KVM_CASE_SIGNUM(sig)					\
 	case sig: TEST_FAIL("Unexpected " #sig " (%d)\n", signum)
-
-	switch (signum) {
-	KVM_CASE_SIGNUM(SIGBUS);
 	KVM_CASE_SIGNUM(SIGSEGV);
 	KVM_CASE_SIGNUM(SIGILL);
 	KVM_CASE_SIGNUM(SIGFPE);
@@ -2288,12 +2295,13 @@ static void report_unexpected_signal(int signum)
 void __attribute((constructor)) kvm_selftest_init(void)
 {
 	struct sigaction sig_sa = {
-		.sa_handler = report_unexpected_signal,
+		.sa_handler = catchall_signal_handler,
 	};
 
 	/* Tell stdout not to buffer its content. */
 	setbuf(stdout, NULL);
 
+	expecting_sigbus = false;
 	sigaction(SIGBUS, &sig_sa, NULL);
 	sigaction(SIGSEGV, &sig_sa, NULL);
 	sigaction(SIGILL, &sig_sa, NULL);
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index bab1bd2b775b6..30eb701e4becd 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -18,13 +18,6 @@
 
 #include "test_util.h"
 
-sigjmp_buf expect_sigbus_jmpbuf;
-
-void __attribute__((used)) expect_sigbus_handler(int signum)
-{
-	siglongjmp(expect_sigbus_jmpbuf, 1);
-}
-
 /*
  * Random number generator that is usable from guest code. This is the
  * Park-Miller LCG using standard constants.

-- 
2.54.0.794.g4f17f83d09-goog



