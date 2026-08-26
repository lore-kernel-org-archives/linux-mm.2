Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EE70C61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:21:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72E0F6B00CB; Wed, 26 Aug 2026 05:19:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DE9B6B00CC; Wed, 26 Aug 2026 05:19:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5583A6B00CD; Wed, 26 Aug 2026 05:19:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 29F7F6B00CB
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:19:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A8F6FC02ED
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:22 +0000 (UTC)
X-FDA: 85142872164.30.E710218
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf18.hostedemail.com (Postfix) with ESMTP id D95BE1C0002
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZBwivhKF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3l6-OagsKCIwqs0u71uE93ww44w1u.s421y3AD-220Bqs0.47w@flex--ackerleytng.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3l6-OagsKCIwqs0u71uE93ww44w1u.s421y3AD-220Bqs0.47w@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y+F0RPt2BIQhoyPunxbW8b7PnDA004/ENVxwXm2SdeA=;
	b=JG2S985MfwoaK1nU05K1SH6cpiWZGfbnohHnRRWtdTtQlFhxuWmAaUR2BWCDzPSP+Poo+X
	6/PA3k/8+HYUf2IOvUFnYACD+OeqXMtcIVqday1tEr///Nz/DpA+gCLQOg5JvywW6NJoXb
	SX6yOVhizEUHUh8kA0VZu9KNk0F/S7A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZBwivhKF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3l6-OagsKCIwqs0u71uE93ww44w1u.s421y3AD-220Bqs0.47w@flex--ackerleytng.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3l6-OagsKCIwqs0u71uE93ww44w1u.s421y3AD-220Bqs0.47w@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735960;
	b=CGZUE3P4TPAzmMSprXMblfVkNKD/nKetRLB4NxcUSTjRvIUEI3tXArMawKeYWLNfHpOsSV
	IsSVbVwNFIB/BPAJA+YZqstXH4mBmSIDM7/A/+ve0o+ysSZ+D8I6nK9YzjoIIvRHP1AH4Z
	oqaWvQg7TDX59PmiN75wX3GgSGYJyZ4=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e54b6556aso1254770a91.2
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735960; x=1788340760; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y+F0RPt2BIQhoyPunxbW8b7PnDA004/ENVxwXm2SdeA=;
        b=ZBwivhKFYs0RIAha3UmY7yqAy165cVhPp1aFb1wyNz5r+4JHab7b0IfakAwaAygndT
         bjYxWHLfp+ZLL1cWlXfGatWvWJVHObIs2Mc5OQqmRgf7XmzRkqNNRUCtBSmZdBzUfueM
         tBVePxJ5VxEQhfaZ5UBtfzLy80qfrlEJAa56+usR4RrKahtFBJ3pgc8XAO515yEVrowU
         Gg7ScZm6WStLVtZRXNUvhWesY8vy2g9G+q1zjpRfP14qq665TLkKo3g3Duu3Jo60nG2C
         aq88unaPrWnFQrOlLIMhTaIKh8XDz7koHpiICUMi7AATY4br8xO9CZbXoX9+Cce9UKk7
         Sp1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735960; x=1788340760;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y+F0RPt2BIQhoyPunxbW8b7PnDA004/ENVxwXm2SdeA=;
        b=DnRwURF2xJrBu7tPZvGrETjxZx2WR1FAKtnOIv+S6VtGc+MX/hkPvpDz0TAU90ZTyH
         6nGS2dl0RAmbrxwhld1Lsxy6lv09r5c/tHS3XoPv4wP6s2ky+akzg0GZ7POBzd+4Q9OU
         2+iBp80mw6yPTlNlMnRfEoVNKK1Erf8dFyivSu+r80b+9n4tWRaj8sHWaqSi/v1rEMem
         oZnZH5CqbXY+kXzpONkefi5jSQ07+snfzMt+TANFQ1ykWd6h8rFZPQdAJrXbwBqvcw0U
         b8NAgeiZ3zrB/o70CCU/Ngj1bkapt0D1tzSY725Q/9v7CE0Fs3LrOPHDXWcZcMbQE/ju
         GOIw==
X-Forwarded-Encrypted: i=1; AHgh+Rr4MJ5gIC12is+Ik8FkAexPXLX6mWYv6hd3j3IYo1gWPpovm8HQ0WGY3nwnS0It0AzvZ4kgDDCmgA==@kvack.org
X-Gm-Message-State: AFuF++m7o6c7z7m257P3mOd6IM4sPQnklI39BxJ6kxQv/un7NILcKBY3
	WXuceAw9Fj5Mhlfzj0WXQJZMa+ZcYA62YvBWtTjgOLLsX5jYmG5ADGPRlU+DqMk3nmM6Y/E+qoX
	HAwEI6Fb/nLb5hbHVAXfozBj9jQ==
X-Received: from plbmo14.prod.google.com ([2002:a17:903:a8e:b0:2d7:ffd:f2e1])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2341:b0:2c7:ebfb:618f with SMTP id d9443c01a7336-2d707c1020emr84178295ad.14.1787735959205;
 Wed, 26 Aug 2026 02:19:19 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:40 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=5392;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=zBxULgvDHXazZ5SMZOlYLubW+VhR2VpJTUrx3o4CGAE=; b=+mJZCtE3M/fpif61DFhZWRV1ZVlRrS/x8em+v7Rtj8f6DsVsyejLGAIvq4yHWa8TuuNUlbwVB
 Awqh72Q64bmCf7zIodrA5VJ3FcKFjlgLjcwCp6uM5anzbVnjZMTBAOM
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-42-0a15d8a799aa@google.com>
Subject: [PATCH v11 42/46] KVM: selftests: Make TEST_EXPECT_SIGBUS thread-safe
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Fuad Tabba <fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: 1uu56mrhmic95d4xmtpjw1bojmxzopkb
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D95BE1C0002
X-Rspam-User: 
X-HE-Tag: 1787735960-270927
X-HE-Meta: U2FsdGVkX1/VIwIh+1eWYHXcGtcrZS9JdsPdFCWziigvleAq5YqP2qbvKpXhEC8Y/QDUDqTKLy2xIevYEh3oFBXN4L/YSXEwhZhaVDTS+DLj0izIjfjskjfaCR12gV33xGRqMW1PhTyUrf4bZOks2+xIryFg+U2ypGQxJLYYZjf+z6slXTxs4UoNk9WezDMbtO5+KDsmfW50CdPcz4EBR7pY46LOJXd8knOKOvQDKXWsmEngDXdWjkP6o9hHTn5LdikPXdJDsk3ht4cToBOzLBth1vKsxfN+L3aRvV7bWmRYgN73DIKKNTIsO5dqnMiOUJzD0FcLCyPy24L6S/ZpVX3xETbVt+008DN0QbDfhcpggFxq+dFEVT0n/lF8TMa+9pxVT4dlnIn5Ssi4vaf4HnBXLx9M9Wj2pnrL868mJp2J3j196PkEEGBPDJ811RdNYTezuoovaPdM8JhDGnx2+dlAXbMubzQFTZ1N9/8buMiwVgpi4dmA9e+cS1ryg8y3fYJDrwiYm1SauskzmEmzQYxFu1bwQHimcYpxXNy1gzUOJFzqtyyPwBxABHTbihaQ7wFJpwNRvaciNJ8FXBQyKNYo0IGxUBqWdtk3KFfXDzI8kKmohPZMCTr/LjaRYzzu8BVHOPr89ORLB26S7HUQcgJn9DtXkoC1TqFZ45tYO4l83k/1snX71pPQPhxDagKXjTZYM4A51qSG99RDN4iZVvIZNKRpKhiro/Hw3V3hvJ7ncksts13tAnLIHakWf7vb5lB1vT/aVNTXD4fMHHq5vAGemXwcik1/9INqhs2056CpEs+qh7sBSraZzQDkzTqu0sKpGfzjiSJ5ET8SgKvE2TqoZNGucIBEWEuQqJ5rCV2wSjjmPAqNpyoCmjxqDnPZZpU2RlvoybSIw0Ab8SRuLqg+AeP7NHSQICd+EKNuE5DH/BtHmntA6F+FAE0hKGUO+tmMg9aWDXe/IfBYrum
 iEaZPtPh
 U4Gq46D123ovcfnht10igdbTkzKcIDNE6wP2f+joUYwgu1fiPTkWmBlCXC/eRqfowb/Wd2GlNzFt5qoG8rCuAS9pYlGu3jw+wbn5iRWuBrJ24n2s7rlUvCzliPfNYdC6Hqhlc/AK2gj1oqRjISnyLzFKScjYAHOaWXfWs94VAw4IEP0QcTjYCOieM5P4uHeqHS+UKDrasw7Csvt5d1lXkzO4A0iCN3sZ2I3Vh63MaI66wQsZNf3r6OAy61lIEI7l1pxUEa1bXH32xYBmc3oJpiZHWqzX/yrYwNfCnqtyIJkAgeedThBHo9zDaf/lb5S0sh7Y5Re6aJy0Spfn4RZTD5Pbj52On5LQx2X/Izg2q03nxJijp9p976ntWJcCItA0ZVuLeWQGhxcm1F32KtM0YGz9RI4qW29hrNG6ZEJJOp2hgem0nHSw0i5RSor943/LZasYdF+jNxJnEeuBJaDE6ASxvdzapEmjIaodrbACpwwj3LTWe2nk5vZKad0ojtM7l8I5jCJtIDzsXL8SfNScBJs2UJnDsO6k0IK/TUzKcEAu2R6tWCak3mWVzhfaXec96/lbAwUJUAOVMxmM3EIRscI7bFOisOhlWAIaYY+NuB/PtSlpoHq1lR5CPRvgXcy5Jk0tFGuRkmR1NoNlCtMUiDvezvPfA/lz5iqF+5glFeB2ogDe/OcDbc7O2sw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
 tools/testing/selftests/kvm/include/test_util.h | 30 +++++++++++++------------
 tools/testing/selftests/kvm/lib/kvm_util.c      | 18 ++++++++++-----
 tools/testing/selftests/kvm/lib/test_util.c     |  7 ------
 3 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index d5825211f2727..75e98ec14107f 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -83,21 +83,23 @@ do {									\
 	__builtin_unreachable(); \
 } while (0)
 
-extern sigjmp_buf expect_sigbus_jmpbuf;
-void expect_sigbus_handler(int signum);
+extern __thread sigjmp_buf expect_sigbus_jmpbuf;
+extern __thread volatile sig_atomic_t expecting_sigbus;
+void catchall_signal_handler(int signum);
 
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
2.55.0.887.g758fc8c411-goog


