Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CC42CD37AA
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:24:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F3C96B00BE; Thu,  7 May 2026 16:23:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3564C6B00BF; Thu,  7 May 2026 16:23:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21E976B00C0; Thu,  7 May 2026 16:23:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0FE456B00BE
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:23:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D1C0DA05FE
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:15 +0000 (UTC)
X-FDA: 84741748350.05.8F2CA2B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 030334000A
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gCezuHdv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185393;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PnhP620juhp7tGBBtDsidfOOb97VuIgzi4uNBUZZe68=;
	b=IWFtttvS6fHsivGqFDEv2hiF5X6Q0Y3HJOFQl6lSxjpY4mvjAX2OWJCm2Rz9Nwn3kzwnDG
	C9MyTR8R8rQIWsHQInLWpW+fdr/W89fQnBgO3NWhtHsRmafBQi5S4prQqWZnPBCarNsVrB
	oIC3UoyQjqpt2lBdxAyzFkDvsjKx5eU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185393; a=rsa-sha256;
	cv=none;
	b=7ZWcWLXOlXFNKR8UVmZmFRJKbL3BGtISImG0DBoP8pXbSJMNv5j5F7wfBaAU4dBQvWUctw
	ITzSoAbV8bBxt4ndB4HmhGygBCduJVBlA03wWgYff+EptkvjQx4bzKJ2w1oRNH5ll0Y8m/
	NZwr3gCunI+aygJyHCmWt6ExxkD44qs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gCezuHdv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 850C944720;
	Thu,  7 May 2026 20:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4B75DC2BCC7;
	Thu,  7 May 2026 20:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185373;
	bh=NIBGc2bWxpB5E2a6rM2inW7b6zxJ/bkA/1PVl1JIT74=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=gCezuHdvMcUBJ8EJdSgPMA8j6wpZOR1WQ0XjHhATuXQTZ2t9uOOKL9JXaJN2jvo/p
	 xz6yAipcAm2uBXX3gnkrYuXnmqwLmZEephCHbbtfDrohpZ6lLM6CDWsVO9nsTc3i+y
	 A8A5FqJ5gxWurJqwhzgoPbEQznrpvr6iG7fNl0kMgNJc5/aJ3eNFj4LMC0eANnUa1i
	 ZPZERTpHKwwJstHEHekcqxwx0q1+2z8f8dasUXVio160qS+yL9ZpE3YdWnK5tyiKrm
	 43SWn+J4kZfaGtfmTwNbXL55Osznr0gZbyD3FY2QP9qlrPiXwfgJon3YrNUNr25/Th
	 +0uLa7d0U6iag==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B6A1CD3447;
	Thu,  7 May 2026 20:22:53 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:59 -0700
Subject: [PATCH v6 40/43] KVM: selftests: Make TEST_EXPECT_SIGBUS
 thread-safe
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-40-91ab5a8b19a4@google.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=5288;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Im0p9X8+loVIJm9oLkLb2iSWnO6ORw1j3v5PCJ+D2eE=;
 b=La34PrJRlgXnCkwvrI4FguMCQaqbbygJwrhrLUaGO3qpe5VA33Bi5oqqX2WBHtWScpyuzW9lJ
 ZyivBK75HsdAPnByJSQai4kIR7/+qBnevLFgkMNo+6fD32hnp+LhOU1
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 030334000A
X-Rspamd-Server: rspam04
X-Stat-Signature: bmzoh99i8gado4dyzmzimbxmaj11inaj
X-HE-Tag: 1778185392-318068
X-HE-Meta: U2FsdGVkX1+EoA24r80DcfSzPx5opRpCO8s+XXh2TW/zH/hka82siD4TmPR/QkRR/dE3ReeoqB9G00MfaO33VXzmX5zovT8vYuFmFe/4uFb9fyKb8ZPaL1cVPubjuh0T9pIBf00ko0hjaCba6S+pRGvbHGuzqW8ICzoQ1qAqd56cTQSJNDGB6UvNXU8wEVcVhtWybGvuqAicmk3yfVK8Oziv3QiAZkJpnHmA/ZWpc9ScpQne33jZFycZWA+k/hFaKCSeTLDul+Ev7iAmFlBqDWAYAp051Z3qzqCfH1VJES6veOjiE43qNJqTUy64MAEJURD7z9k/mJlRuY6SCAmIc8N+HDI7oyaJ+yLT0WchziT4PjQefI6ZmQuUkL4I03uG59LkwWu/9Aac27fX6sSXhxsIkJDrEQpNjVOn5G+ixg3NUmK5Ua1SJShL6+1afIxcn9WWLCyfSg2oR7LBeDp6b8+CwoZWgFoMzWuhibNww5ZLpC6wdQ0SBBEyRO2+EQS7yfCQgL9iuDpSzHkJN/t1xxdArTBGEo7PAxuRsJIG5w0EqRjzYCG5VEf6u0c4/BjrpEL+n+A8d21LUwHXbH9WfcDdJ77qaSYuzP74peSaia2GZzS6xhTlxmTdYfsiAzob4oN5JvHwFLZ1AC8hi+OaOsBa1eIlR3rANXeD3l6gfHiDJ3EHYTV5V7QfAUSbdMskx4eIOgrbLeFDcqtLnK0TQbjgtvbb+30ZFzQzYYz3uFlJze/tnimEH95gLB9vdOZ2l+v2N0XfPs/d1AunwpUdKBJLl8efUPHCGwsIRHaeefJSJ55avJ+cY45zSTGtuiZ8BgmoJMVldz9Ev91WG0MZZ0iC8VLT+X7LyNkrm7QTYYgaTCIwFSiPGs+ywsJFr5rHqZq+BnkNBvErvXIorBFhXJsRtAeR/Ej6r57VHk2bS9V7301r+vfBORrtHXV4/N9jmKKUa4QanR5C0YvLNuq
 9Ivz9w1s
 Ed6JUgUCTisxbQsqu7lZuepmBGEY4N8Bm2a1e5JaZtqab1Mf1yiRFQpqXJncZxXl6EJhk2nQeBLrqb7wgFxw2VTyjGQUDUnLl3MwrHzSqJaP2TpsH+S5prnd+WKYRpcG5UHKbFYwTfBrROGk3arU9CAE72BXrDxBWzqAKqnXrzj9ZloxRGQ2VinMzuKE5+Phj4wD9PEX/ETdxfRRgghQ145VydFzXLEfPBABms4FDJlxoFxNjjR9D3/ZeVSVVrorazv3M74K4qfvzFBbB8ObQ4rq5VMjEQyxVkChtI5pOsFydfpzOEk88OKU00+jTFlgHyRb8A/G6bcMHuhiK6gI1Qfa6A3EDkLBazxT4i4B3iOrumLy2TLyirkNrXmUHibk7wWo7JDzohu2y6BQBEPhtHuAjuheHdUTD80M3ytowQDSqJTvp0iWLPEB1i7cmZb58d5xjWvC5eNuZ3DXyxLTiiyx1kQ==
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
index efad3e6b19f4b..d1befa3f4b305 100644
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
2.54.0.563.g4f69b47b94-goog



