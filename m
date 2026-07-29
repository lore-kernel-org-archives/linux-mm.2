Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C90BDC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:36:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27C4C6B00A5; Tue, 28 Jul 2026 20:35:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 254476B00A7; Tue, 28 Jul 2026 20:35:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16B326B00AA; Tue, 28 Jul 2026 20:35:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D3DFF6B00A5
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6D9A01403BD
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:15 +0000 (UTC)
X-FDA: 85039944990.29.ACAEC61
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8C0CB4000A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rI+2UPNt;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285313;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kn5IubLz5QWSP5Op3v8E7vtXIUL0APSGITp5nzZL/9s=;
	b=Rdg9+l78XAoTkNVecSI5TiORfZmmaw9CnbPKrwI1oNpDzlShZZXiV17713rSkt7wnBfUsS
	FlaoKbyVKy5OJGFpvL0BajwAMiNYnyxak8Qp7aeT71PJV4Bub+1vy1LWb/N19n9rLu3evA
	G+h9iXGzKfK3qmTtDoMjxqU9YJUyNjE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rI+2UPNt;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285313;
	b=oE66DgiouzCdEVpNzF8Lz3/H6VH5Qs6UTHlTBZM3T3Bf5xZhf6SjxUDVHaz7HOmFCw7a45
	ONXt2tGwebiscuTBVUfhM4CLA06ATa1Rg6G92A8JLI09YOmToeKe3iVnHMxOUZ9JjaawIf
	2PEyB+VfMEBxyHxCklhxK8aYlXY2IWM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6CD3660DF9;
	Wed, 29 Jul 2026 00:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D6AEC4AF48;
	Wed, 29 Jul 2026 00:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285311;
	bh=CKrM+Wcm8lEWhCfDXJfOmgnUsmX0Lst7f7ovGq31Zk8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rI+2UPNt3LW0nNA8yZt4qkus5HPofnLtJ+HMlxqoCKdnGp4NJws/86Myhu6711CqX
	 7qhExmkr4PwTtI19vJasjN0s62DH/1ADzYjq/XgDpHmIOtn+ZJVTYFIesyvZ23+reH
	 q4AZISATCQS5c6xST+UELbWzvd/6fC7F7cGHbUYfoCLeQVVE0x2INtynczGB8AXIqX
	 Ba0WF2+8gY10e9ADUatVdr9i+cscZDQ0FeErYszae32yMqh6uIPVSKE2fxsRqj8rmo
	 1VkcG7kCIeiJzrzm/GiVE5hQ0ySxEeBggCzOyZQMQYl6TElpDSc8tBrHBoUoWc2+uL
	 6T0qz+kKqQv4A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 079F2C54F52;
	Wed, 29 Jul 2026 00:35:11 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:38 -0700
Subject: [PATCH v9 39/41] KVM: selftests: Make TEST_EXPECT_SIGBUS
 thread-safe
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-39-35f9aec2aed2@google.com>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
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
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=5401;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=VaYMc1TVcKA81tDmCa/7EVGlZnQxqJzfqmSuNBz8KJY=;
 b=AXb+20EzOMuJESc9zmB4AV2ue8MSVdFchkc9xewn+F+5uozzqzhZheBrYc5aBGGSTPmKf+HK1
 YlWL6a6K7VRAGOS3XWwcneWP5AH/VEC/LixD03tDJSOeNX9Hhyfx0Vs
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Queue-Id: 8C0CB4000A
X-Rspam-User: 
X-Stat-Signature: r41ccpshr9rb3fdw5uo7jfd667cgzdke
X-Rspamd-Server: rspam04
X-HE-Tag: 1785285313-704153
X-HE-Meta: U2FsdGVkX185hR/kaHmXCAjHweNE+n/tcFw17e3bNe5DWKl704k3HqqrW0YfUrBW90CS5XmHtsLkDrgOHD+R4XPZBxRswa/BLeHxZ1yJzX0gSfGzidvyz6fZZgDEitaw6zDJdIQMHN+nRxgCuSCXUFbLBn1WCPlpvyDXRleDVebUaQNfAjow/UTAfvzLaNOXE3DIJDutEXP631tDwu9lx7Fb+O04kWBtIfRxSVvb1OY46b7bIwp4d0yuOd4hdrL2CD8s84nr4q50Za3uk0GM2M3ep2C7kgIh7qDkWqlC6Deu2YEoBEIU9HBA219XynHwT7bTMfInm4WMLJes84X8Qc9447H0e0t+DFAIAbyM5FLS07QTJdnYoVkMJp4Xs+sUIaDjF3tfmLzuTy//m1K9XNPYQ1gM4v83ew0an0Eq3Tm1CCP6cR5oeMJ5KndbTRgpEhM5Bxa9mtc1QOz3er6ae7vt/A/xNVmRYxJrAESuIERnfQQOG44MAMUOI+ezuYqTrV3HtAqCH4wbvuio88CsKOhSRmB404xXnkSHjLnuMs7JufOEMA7m/HbuyQSSvpbmoQKZfase2Hd4z4Q2FmFXRxnFCtDJMKcnqsexTU9ZQ9/QQ3p8pPsdZYjCQC6f34sNAm6jhhORfhNoF01/xSBUx+q/MqaCK9usQUAAwl5fCqQB5XLNn9TdggRtFziKi3xEMQNjFqGxz8y10RV8cklXIVJ9LEO3kALY1mx/nTmZ014Ic8PI2HitLftnPMyrlohF1iSko0jq0gA8rddyobU21HzGFHev+wq+X/+ZQ+6QodgRGd3ylkDprl7R6KRLg2XX3SaBaKyyquaky57RKMUv2JhCWqRa5Sfcm00oXFIxmJ56/D6ML9rHBmehf1adHL78Wv6hFyVrvhQJghuV/MUMs75vviQc81mSoqqTQbWlTDh352XXU2nkNnhi2hE4vlStmuQHMNc/yFz1jdM9x88
 QLXQQqvI
 pAS+erXRJ8c05bk8j81rlKXWNkplA2We9+nDdgDVAXIyIMaZnAvAXJT6RoNMoVzCS15k/91v5bKzZedi8E7ki92lg43JmKtJ66KPKaCskfNZb4rjogJYzIr+D6JoeZDbldwFtrcstPzBdKG6HEl8uTnngv35E3zqlgFCPOjwBSmg/rAzesmHArTtcjFd4RtuXDANR06gKvgjOE+Eriu4S9skrUcyUhR2YWqNXwvr45q6p3Jupv4BtPUBoRSKq9M4nuCvkvnF46toaz3l5AJ1BWRc2MSGIaSKSZUA8JKDqXyfDwluAvO4o9+2MIhQ7U6uK4k9+0oWonV4WL1FBA1N9TDKahUlGK4WXWyqE6fYFAx78HQWG8mncOVHSSY1MU0lnr7R1TDpz0Z9T1an5bOicaF11etYlUOXiKJGQP6xJ6s2/v5SOuxf1X64Mx0qW7hLsfXl7y7mtnAV1Vp9TUiw0v5jIGu4tyj2Uz9WonUH/94a+jCufTpXZPqv6beKZPwqsoNHcjac3D1je65Z7ZdXpoDnGrnhX08AHHSa1OnaeA6o2Awki99D9N4NNJg==
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
index c6492a29ee901..825fad48ab452 100644
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
index 083717a11ff2d..ff70b4225f82e 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2318,13 +2318,20 @@ __weak void kvm_selftest_arch_init(void)
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
@@ -2336,12 +2343,13 @@ static void report_unexpected_signal(int signum)
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
index 6b00ab11f3c02..36e08d815758f 100644
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
2.55.0.508.g3f0d502094-goog



