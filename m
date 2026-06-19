Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9BD7CD98F0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:34:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C70CB6B00C3; Thu, 18 Jun 2026 20:32:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C48F76B00C4; Thu, 18 Jun 2026 20:32:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5E716B00C5; Thu, 18 Jun 2026 20:32:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 816CF6B00C3
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:32:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F23838CD6A
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:11 +0000 (UTC)
X-FDA: 84894785262.25.51396C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id E82F514000D
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qGNH0WaJ;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829130;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rq6HWWpbVF0S75OlC0159iMIJImrJQqTvRCTOaE/JqA=;
	b=5as8lu7NleT7QDA1PTNy1O/E3lfAluTjaUIIU+mi1Q5rr1aTfDtDOEofg94mTAm9ZBO7qY
	NWVcQJR7576VpI4+VA/E4OBogZ/3VtegFJB+yIjrGzm3sAbCY5QH5HdOVwJfhhvuGXVhqO
	5if/xnaXt5/C3L2l4EUfmtLuujG3Zw0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829130;
	b=eGF3pEBi6Pw/hCiZ6u2fR9sFB3DtwfAqCqSb82QZ1Gj+oz3OwLRWu95oKc07Tvx36IvkCh
	b9i1u5KTymsU6nrBky1klMLMCcXbMyBWza7KMcKbR7yI7IlQdCMhiKPPw9dweVIz18cbJn
	3A7MxsIgIbyQRo5gDHotLO1yEkPjA/U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qGNH0WaJ;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 84BB544E63;
	Fri, 19 Jun 2026 00:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4EEDDC4AF10;
	Fri, 19 Jun 2026 00:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829111;
	bh=b1Ni6xDbK34v4XzXDkY2shHsyAkEp4gc6WbJxsLfN+8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=qGNH0WaJfuJcmnNNzB86UejOUOGSBNqN6IGtMbpvYgS/cZfEwnN/QFAVMD1tMdUiG
	 fVTRgxFS7BMzQzm0XUTDBVllAOR+y1y/2qbyRklYebPfbjJi8mImvsoIot+yRzTmgg
	 ByOd7p6AijOxaT29FsqQhc29Of8qoQOuJ/w+3/To46VrAj1JPIGvHhcbpXl5AlMWft
	 gzB0bdjdh9xzXIyrNCBg9DAr6aWJMC3wdbmMQVxcJLRl+gVyNBT9lIU5o6N31Cxvt6
	 RQWlUdwfphyjzyLEn9c8XnbqpjTns1vIZRViwOt2cocPl+8yZehda6rbQx/KO08/53
	 nGkw1z2m7uX5Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D8E0CD98F0;
	Fri, 19 Jun 2026 00:31:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:32:21 -0700
Subject: [PATCH v8 44/46] KVM: selftests: Make TEST_EXPECT_SIGBUS
 thread-safe
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-44-9d2959357853@google.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, tabba@google.com, willy@infradead.org, 
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=5292;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=8hIEwuKub1RWth19x3Jz3NYQ9FTukw39oMTaTVTL3Hg=;
 b=REOACWKTKQ2hKAQhrNOYQ1meYld1rlhCP0EahIqWCj+Ctm0ZPJuYriNH7PqZDgZLRdgCYmyln
 F57Oqx3wgr2BndDUPOVxwTSxCCNKwHIR+JduljXKK6/OjUkhAMVdRpj
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E82F514000D
X-Stat-Signature: cc1uzoxerh4zqtakb6phtcrws13pzk9u
X-HE-Tag: 1781829129-785945
X-HE-Meta: U2FsdGVkX1+8NKa/pDkDOEA0XGc72REU577+meDe4p+UkqOhRG7L7vBAGbILOYX6wuyF5kuCL2fNeNsAl45YS0jK0OS0iGE4O7/vxCPJu1OOmutQJtAKdIbS3YdHQqlJRJIdMYC7KZby8ulJY2bnwlFMoPi0T/XlcUTVwtCdunQH3HklVt8DUputw5cGsDrfpHWckHJWU5BUyUzy3mbrjLQbojxqvl4O0TEd7Q/C+ii2Ohr3DjiSZ7H50oe1fVs5lMxf32BvOyLa8GLTOJC2HKlwB3db4/Q+c4cJZNgJuBKWlByHgNxaNe/vOUtcZPrPzTUcimsGTqPobMNBfqFKRaFCF2/udwRveHAsVjOCbFM5HVID+UVn68mi79DKBmEU3t5W6JqzPcSKZuUps8LFm1h9yNJKWNbc2e2wZF96FZZBA/GlIb8vymuUgWzb7PTV079X1ZwrwMaBTa8VBXI1H4MyFWL6gZE2v8Oklha5DUW+xlpqq71kMw4rTNJINSOrqMfewECpfVtlekqpjCkdMHxj9JY2OaSvXQL8qFaZemcevwTG15ftkKAhY0Ek0IYByu70dOjokOKTmstLuCSpKjMOUZzTeW6szXuT6Spq7TQp04RBeFk7ul+D8OetrVoQl3u79wJVt7iimek34Iv5WskAF6/IOZG7YQvUW+ug3UqEAK2f2DMY/Dq8+zCXN8O7eTrHpyxUz65bqbAnWEHjqkk4e3C9ktDQvp2X0u1OqOJx9H+wFtcdPa8lNDIV0TXIlkUnVnaRVWAyjapocKRF+p5xyU2wh/4gCzW3aXDhdE4OLL4Le9c4+9zMU2pj3aX4tFZKQgTZJjK/40BTDP7iGKYaPj3KXpvUAtTwRwfEeqGpgK+zWJfMfexyBKmMgL+8nDg1Z+wXMgwqQ9yE+cyfZGycbFX/vy9q2lsiNzOVqa3kBlVlrw9U10ji1lBvU1Isjxyk8KPzNSrHO3kaXha
 ahvzWPtM
 mCSzHpIS6ojAdTd8SQCDB5tTTvzIV70PzrrAcExqDkMmyDDoACeQEGyIrjfY6b/1tMqEju2IndKSaELrj135NMwMPvogUFVAQjCgRjMX843lcdGgvT02MuHUDPD3fTFJhcamhMfugwNMsXjxYLduE1KxdavvNPFs6OoNfTSw/ouIM8/aHLfeNi538d3/FQyKnXHDlsvGkR2frl9SyeBDUY+x1mkOok/lc3yCeA96JN9sYBMRKnt0Dg3xu6ztL7dYSUdqtG3ZCbQXcaSG4yYz2gxtg16j7OrUd7vH56tF9+wKchvsOREZDRv3Us+dKZsHoKlj/RoeTmiDbk/UAK811glb90jRZzp1sux8LiW2cHxVoAgt41/dead01CBkjnUsjq/vVLCavRyPeZzIxE90M61uHOoDV87kWTDervgZreDNuO3exXVhjMCJKvKv3IzR/tTLdj1LjYHuc4PIouyBn4m9DO7/sxNX4OqUR1ZDwKllceacwduKsBD8gQA==
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
index 51287fac8138a..bd75162ec868d 100644
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
index 6b304e8a0e0d5..b4f104436875b 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2292,13 +2292,20 @@ __weak void kvm_selftest_arch_init(void)
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
@@ -2310,12 +2317,13 @@ static void report_unexpected_signal(int signum)
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
2.55.0.rc0.738.g0c8ab3ebcc-goog



