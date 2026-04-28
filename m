Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD959FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:29:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6AA56B00D3; Tue, 28 Apr 2026 19:29:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7E526B00D5; Tue, 28 Apr 2026 19:29:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A483F6B00D6; Tue, 28 Apr 2026 19:29:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8E7D76B00D3
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:29:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 268AB161362
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:48 +0000 (UTC)
X-FDA: 84709549176.29.5CB41D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id BBCBD20018
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V4vK3oO7;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418745;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4wyiUOhqA3JIJFPKSjxwuC3AXUySm4OeSQjCvu/ijCU=;
	b=0uQ1f99NAwaSrQobw/jBaGBQ4kQf1PasPh6N6XEVGr8F/5/LYsHPzwOp66I6If0qxrdpGr
	xXV2uU17XJoqX81dMhjNhUsVCGdF4YwrYlrpLdCiNatZe4WSzW0V9Itv4GbCPaHzYFF148
	SoUDAY262r4HiMKaqop/c42kJWSWWbw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V4vK3oO7;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418745; a=rsa-sha256;
	cv=none;
	b=QIESX7MpijOEcmfbWMQUVCM23yUuda5B1Qv3WV+SReVcQIbaPMwslVF0liTrIPaT/Wot5K
	V4rvNFJuMOXSDo0JeqQv7zUZoXkHbgVXuzFHzcgKeDJryoHPJed0ihZM/QPjauyM7I4M/T
	EBdMGD+LPFY2T0D/ZtSsCORDXdC7cAs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8C45244BB4;
	Tue, 28 Apr 2026 23:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 66ED0C2BCC9;
	Tue, 28 Apr 2026 23:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418721;
	bh=77AfCyy0TZKZY8M+m/fRDXWBuiG8frWm/87F2tNKLKU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=V4vK3oO7RZ8jWuVqNxCJtfzBIxG/R2HLeirUs3CLmcnHv1X9IOMHxf4kDdf2GuXva
	 rxQpgkML9qbn4RnJ+4CshDhGBWO/GJYRX3GLkagI3BmRBFK301S5kP4u1a0U2gsxsc
	 lamT7spts5F9EofouwKNOuFiztv4vo6ZniOlUkiDx1lx8lMByB8aOzmDANxOvRW2l8
	 YVma+UnjjdFwjacCIpagTYwZdj4bNKpKX1fgXIV4MElAuLkCDTKkL0OChyr0CkvcK1
	 AXrYN9R3oWKBf+HnvjQCU4mq3TBLN09EvcIGWSXOhIyhAwAoiMoof2821G44rksz93
	 44WbRxAJd8K7Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CAA6FF887E;
	Tue, 28 Apr 2026 23:25:21 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:44 -0700
Subject: [PATCH RFC v5 49/53] KVM: selftests: Make TEST_EXPECT_SIGBUS
 thread-safe
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-49-d8608ccfca22@google.com>
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
In-Reply-To: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=5282;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=0FRAfF/jF5XXL7xhsrzKptfhFbdK2TYEtnUzquHFP9I=;
 b=qB3KieSgkAM8PqZhU/SxTptXaG604bVeELOKgLnMk0D44YFLH7hxE/g/9rLtr6RzQc1o9AIji
 Nnjk8PoXK40B4kU/M3q2Rau4Wd7tkPFGg+1iSJJ3/lZUn81V9Jpmdxb
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: BBCBD20018
X-Rspamd-Server: rspam06
X-Stat-Signature: 339hbgj91jekqamu75wzb3xpyy6ymj9c
X-HE-Tag: 1777418745-810692
X-HE-Meta: U2FsdGVkX19PzbsNcHROp2P3fCGAY2MPt+6rTCj+9rhF7L0tc/pC8sjRT7HtV5YPQLIK2CNLuKV7V8ZLjd8CQM4UGLBRe8XYTMkw5YzI/V4y675bXOUxW1gZzIf5pFwfO0065NiVADlqM/+gyZ4TI96r4Z2JNu5kucjK7r2RR1BZnaatbxWzqGZt/nmeEy0N5F71ohbaWsLhiAuO+kVgoXvPeEjtJIrp0f/eKj/2rCXCgLZNZ+E90ili39ivE0sAy0B6zNSLsN1qb5tLKAcMYc42oX1ho8VnAZxkQPzD43hgX9F/6jUI9kxlG4ZUA5qkrnnyEU+/fEj9nVN7jfHxRpvrVHvPcUMg0IGI0huIxbKf5Ph3TvClMQs74Ky+2JSd0zSZaljdy9eaXZVTbBgNWvhAFuBVIBvVPGAgIffSVth/qIRP0R2fQtyUjWq+0mEQtYOvWfxAHIoC9dRyMhdOznyxqjejPPU2HmV9rUUccToMH+RkZGaqNZAE1rMtd1LkPYiqGw/ULk7bqfglxA2NFlY/u7fu1TNYUISZayL2Iv9DPdBJRSitjkajeeJ2gLcBMNjR2ZdNGtXrBjQVmhx2KGAIjsA07bwGGnP4qKaiHPcAoWMX3bw/TWiCgLjt6oJAPQqpqXkYcQEuQw8C+HfFt//mEUL4nNzjuz/d2UhoH1qkQK40G2d1nA5C6X+/e4e2VO/YDYU1GWLxhPueBvu2ygwRD7kBzLDhwNNuMSEr63W8KeiOf48MNpxasEuDFdxOxNCmdGnA0fYU6sCkjFbGcfpGxR6MOWjrxq0Xu4wLreGZeL92AuJCjgnHJkv3CwCMwefSs/oKng2uYCp4mdQhVnOYehfOfTNPQYf+haRZtXed7xRFEHmbU+15HyNjL4I/ewEOtCgGLcyPecfVuZdVcA5gdNFsy5MERmHzJODrgvRIzR/kGSH1c5LKBZeReayMC0vA46f+nqAA5dKn9da
 mHexEoQb
 3vOWoZ44PnOTug3PVYUp133NFNNWA7masIKsV+cRLtRoGhJcFxuuxPWDNeRo9KisBDoxhUWmnzQTcy7qLU04gpgCFaNWhTOyK4bCuffJcI9As2S73hnsLXAk+snm5XkhanBALTn3wJR8Kn5k5Vxr+zC18FIL74bQF33saOiAKOasnrjtifbXHvQZ5/kljdEvDU+nx3nfRJx9gmD0o18ExeQNNj1G2ZOYduWuj5oFKCh8hm1CfemIMqfU8se17aFdHIpsnZKJvoohn8ggyQcQgPCItkbgOsXpPaIU+A2P7QMPTqWYGZ1z6eibv7Nh9kfxcg+CN+zS+vt3wE4/BdrIj9SWK4+l4YrylibcUqAlRUDmREhWHby0fXcldH1wfx3EWMCCWKX00fiNkFzx6ypa2c/5LfNd3VN2b2Qac3fKtlqXpV0LbyAtc0bagaCxBM/3SeYT6+w9BJ6lVkXyGLmTacDEdHg==
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
index c280c3233f502..6907b99fe564b 100644
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
+	struct sigaction sa = {};					\
+									\
+	TEST_ASSERT_EQ(sigaction(SIGBUS, NULL, &sa), 0);		\
+	TEST_ASSERT_EQ(sa.sa_handler, &catchall_signal_handler);	\
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
index 29b3f4e9fb4a7..216d6e037153c 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2269,13 +2269,20 @@ __weak void kvm_selftest_arch_init(void)
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
@@ -2287,12 +2294,13 @@ static void report_unexpected_signal(int signum)
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
2.54.0.545.g6539524ca2-goog



