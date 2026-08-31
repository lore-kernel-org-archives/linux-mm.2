Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87017C61DE4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:28:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEFD66B00C2; Sun, 30 Aug 2026 20:25:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA05F6B00C4; Sun, 30 Aug 2026 20:25:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97D4C6B00C5; Sun, 30 Aug 2026 20:25:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D13D6B00C4
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E497F1A03D1
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:47 +0000 (UTC)
X-FDA: 85159671534.15.1B643CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id DD21D20004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ik78keNE;
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135946;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pdTieaAhtSwa7AOZwpEXt/MwGpGmm+nhNvzPztgyM7U=;
	b=ldUX+B7Ls25GW0gODs9hO3pVBEEsMqPLvjq7O+w0q6hxt5Dvq5xvp5gxCFsz46Erew42t1
	nfJOMWvrL1cKPFtoGzkbIiuHvFXwQ9np6hqJvfnbuTkxn0w0oSEs7oqD4BMz86SrzO3ZUT
	hQfgz0kxlxXVQy39LOZPpSCBhjwPypc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135946;
	b=R2CO7GM+0IG+jzX/gn76wMTp8ebMiPNV3eHakpNXa7Oweuwk3dbFTdLGvdPTNHFnf3aJaH
	WV6kWnIwu51xdoCXx0HuV2M3/IRPrkguTSKvaGuaBo+S5jzagnzFfUYA68sYacEtc2euSx
	dj79OnJabu7uegXphUoi58dg3GkzxVI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ik78keNE;
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 58DDF44A09;
	Mon, 31 Aug 2026 00:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EA6E8C4DDED;
	Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135924;
	bh=fWo2Z0U3qWprNJYqj9czwlh+dvNvCpwaJIaom6CG1/8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Ik78keNEnmqSHqq/TYhu54FvsEboBX79IL4E9g54NCkfXby7T880vv9Dt8sX28jDp
	 5vvTTJsOjyhiBGE+K1ekAfgybTAJ8suCjOGiKijObGtT1sX4Q2QO8z/gvhLL6EJibc
	 9L0HqB8EA+BHmwJd2eoK0RMwgN2Gbv0EFt5FZYDEtdNKK02Ss6kY22w9AW4z1OfnoU
	 mtkY6nSvVFiql+7iXS/j5vmzoei/Bv96CSci145QpYn9EaM/uQXexyfCGju4ADXdiv
	 iRP3+70GHroXX7JEF7dxd1V9nYDfYmepDnGmF4osDusI+fdWAF6DuxkdhG47gWpmXX
	 W9bcEjtW3kQvw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D013BC624A5;
	Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:43 -0700
Subject: [PATCH v12 42/45] KVM: selftests: Make TEST_EXPECT_SIGBUS
 thread-safe
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-42-85e5fd25252a@google.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
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
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135916; l=5394;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=NFeQPx2A8iYZ1avesMkwS1pPuZuvzIa7AvT5Kppv2Bw=;
 b=vyn6pMBj4ik/HeRaYFWmV98z3MzA/IB0spOi+dmmSl9FUVZmmtZ3HtkBeVSFPeOZLT8jdN3SK
 ZOreYmwcuulCyIkkNEipvynQArx6xuFm4TSUU8DdP3VviWYcDyV0JEA
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: ac31uqnqfofjhx9hcd1icmtfuw3wsaqz
X-Rspamd-Queue-Id: DD21D20004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788135945-424276
X-HE-Meta: U2FsdGVkX19l9QchAOj6XGVUeevIc9I/TaEbRCO87/r1aOAulzBP62EeojA2TQrh0ASoZbhiSdCfUGjRnXh0gZtR6CfpIYBaATgY7T4P22dvr3DJwezv/IxP0HiIIiyJk3UFs9L9SCM0+Jpu1fQkIJvNjUXnvBcEGHMZ/49ZgEkA/HkE7P9YOLsZTyvI+0gxo/x1aAdBfYfw4sl7LqQAFW2ztUlvaW2pEfprv9sGvdyFEe4DfcBf5xCsZ+KxyMFhuSsQ6i+8KOCokrWu0YtStI388Mat2RyvN046sS7/s07Zqd2xQ6IMOiIbXLi49TgPec77KK/vqfIulECtc1y8xzbdhg3ON2pX9uPh4ofQrOqWGMjBWPW1PmDzA8FCFYErXTA2CF+kCizoaZ672xeY9ufW0qaLsXghl0GLtZVOLrVEAJ12XcI1lkvTC87MZc8IV4Q4cogcz5U5EkqkyDa8qyjFkuR6itR4Cesm7NyzpGIueS6JRPsTgiDSaQDqBtNd4upvVRMs+S7s2yb2PYh1V6FfI0Cg+ggNA8dS5PBxN542+GnxXoAuvmxW/caJbuhWzVupdeTk+7PXd9+9Ie+hodfb5CzBC/4Ia1iQryzyw2l336OG8tBXDcJgc8xShsv8b7EhC5NcekQ7bqIHws2rsyDL4fDORoUcW6Gw71t2NQ8loWKS4nm8RAxinST3Pns2IrA6cMiGjPK6EooZds3mrbwVMELV3ehYNvLjlwAKHnP1169RIu62/fo4h+a//cd4Hy9ImtGYPQ2sQV9R/IV3zlVU/4XbfdcqYKD73QPHj1sT1daznh2HfaMltApKfm6pBCis8D9z0vyV6FHBrymN0bXutMTB1Hnc4ON/5vBmLepi5m+SVeoMS+ZdsiMzrNtcJao+OXkZW/+3a/QkMDjZ1oIOClxJA1QFafb7qtzD4ofDPVzqv5CPpZVCyDvNwgSEbSFq7zbq6dfpc49e25E
 nvxcST0a
 BLPIABd9ZrgsXKmxZnaOzcxTiU+qZ1LrMzpjikbdzhnSs6OUO7jVJg9iG/TLJ4DmvXcw8B1uiX2o1+DM/Ujse+5COEROK4NMxv+5IrcaT1IfPQiJHrHzMonJ9oydYgtebIRLAxDX5ijTB1fE3yYmD488Z76DkTYgVJNt17zZ6uTOoMwjfgcsbxbM2dTrHa3V6QtWvyKmm7LC62eyiGhHPZahgDTygntS1wBJgEnXhYS0gu39y6/s5RRaDAhrIds7lPemlP/pqvHMOFL8Hu8bNtS49cpGA9JDykeQE0S/fFELojo6CTrlZaWV9xTcjBHluMWl5kC5D2C+bJDAt3waVGY1sik6uVw9O12kcIkqVUsL/dLVDQQTguRocG+85XRT6AHuDM/Syjtf4TkOzz08fYEMFEdxaJdvmtXavpYP8BJ2YnR4iCW06ENYtjdH+cyqGQW4dQWAzGxVwMnON1pm7u+T3FnkKIF7hqqEowlHXiAH7UpDLBspNheR9KM1NvLwwazFWopFzGWm26zVVeD0sWVY+Sw==
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

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/test_util.h | 32 +++++++++++++------------
 tools/testing/selftests/kvm/lib/kvm_util.c      | 18 ++++++++++----
 tools/testing/selftests/kvm/lib/test_util.c     |  7 ------
 3 files changed, 30 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index d5825211f2727..75e98ec14107f 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -83,21 +83,23 @@ do {									\
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
+void catchall_signal_handler(int signum);
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
index 1188d0a6c0a5f..cac5624e99774 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2316,13 +2316,20 @@ __weak void kvm_selftest_arch_init(void)
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
@@ -2334,12 +2341,13 @@ static void report_unexpected_signal(int signum)
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
index 4dff72f6bd346..89d6d1b572959 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -19,13 +19,6 @@
 #include "test_util.h"
 #include "kvm_syscalls.h"
 
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
2.55.0.897.gb25b4bd76c-goog



