Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEBB1C88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:58:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 688EB6B00D6; Thu, 10 Sep 2026 19:55:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6127B6B00D7; Thu, 10 Sep 2026 19:55:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DABF6B00D9; Thu, 10 Sep 2026 19:55:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E33E6B00D6
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 81DCC160612
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:57 +0000 (UTC)
X-FDA: 85199513154.25.2ECAFDB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6FDA340003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VJeHiaO6;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084555;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eQTVVxM9XVxTQCkiVQ3Ofj0jC6bSAjfVxJ5Ua/U7LZQ=;
	b=IvUQmpIigTnd83ry21ED3HHjOg+rAMNMyhjc8rXjhPzoJFQRBAsnqUxJCBQzZ+a8nmcCMj
	Fmu5GYvZSSacHDOYP88gC2bISBj3uMad08i6UL4SEsJs4jj5OTL2qinrJ/9ipygxcrUPIr
	LftzoCG2+MWk+Qm9zGLvU0ex9fc4lME=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084555;
	b=wJIxVknrxZFvrQ06lipDbpd8JY6MiLnMaKHIVBT4qRN6K8OzYcdg4B+DpH+qmqLv3s8g3m
	2udL8e+FrYW/2Mb0xGO2eVFkin0MXQX+wmyrOW1aSl4Lsx1KtU44hED2JR9d+GyRiLrsFa
	92hQn+GLUTwehmOnjExisEX1lwXaCuM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VJeHiaO6;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F24DE44820;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C9D39C2BCC7;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084540;
	bh=BXwrfirqmnSn98dMM/5nslyDbd1DGRMDj3O/ov8B2CA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=VJeHiaO6x0X3+fUI+TxEV+PAefAPVhmLMWXwt5QthIiNMM+VrNYwg1O7O5y0Pj+CU
	 hYY482yGS/4wpIUq4/Pq0UHoDjBA1QXOaXhGNmKHv2ZmInIbYOU+2BZ87N7JdedLDo
	 6EwZNK1kSm6TiHWbCLIoxJdqVhLQmGk89wmTSH85AUr0XB6oQbD1xaHnYBIK9SjOrx
	 q6g1N9Mq1GvorYgJ8uJ5yfsOg8UwcJkO4ANXdZfd9zpgnJxRjlphwnG5UVuGxZ2mHy
	 +IgAq061Kdg27iXOkNIAJdvu6hhN6K0Ws/4+EIh5vM9SAInevyGWH0TINrYUHkpsT9
	 /uSn7gRFWFngA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B316AC88E41;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:56:07 -0700
Subject: [PATCH v13 41/44] KVM: selftests: Make TEST_EXPECT_SIGBUS
 thread-safe
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-41-dd6fbf94f4e1@google.com>
References: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
In-Reply-To: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=5395;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=lL6XuWobxlZyT5n/HD9nSN/LyxB1opZ2ycahz8ojWB0=;
 b=0yBfdTkaFeVrMv+nS8bJqqt75egmcwMmDIfNvh0Qgr2DTvoOdBAUJf4VnVYM+D08ZekZvq0GJ
 aIuznjxCNhbCtRKO42oFAru9P27Sc+CwJLxUi+xwArLi3TeAigmEGF0
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6FDA340003
X-Stat-Signature: hm66nw6hgs1x6z4oesmkdp386gzabbad
X-Rspam-User: 
X-HE-Tag: 1789084555-208954
X-HE-Meta: U2FsdGVkX18tHpKbo9CYjLj3uLnVF8ie0DYbVIXEkoQJJt1WjHr70nboYy+jqggfiRW00bF4l5vWxSsflrJUKx8Vag197uE5wLNwbqnPrvyUoafbxISk0RF5IGa6HbrOyyvYam6pN92co5Iv79zQiHOosc15Um6EveaKuRBo0/44eesCgDlqrcBRPk7wDkHSJBW+d40CaztHcqc9+JrTMHbusvkoojweGU+znNcSrsBXiA7LFV+csdMSMrEmi8dWBFVKyblGMG1swTTpjw7NDPkAOCiVuiwCN46IJHEAgTt/tiD8ydLxjDCjQtFhGK0KeIRuMjL6qzycxJfpeOb+f/hYxaXJaaMQqErWScPEhwedT3mg90U/Fa6A//bUcqF+A5qSOrhHk3T576UaeVAR1rsod7KyX91KO55YJ3fdTV3/O/2lwCrLaT/rTFR8jjB5mzFgq+/s19ok8100oa9pWN+bHh+Ru2ftCdPi1vzHlFPnBh3WcYQErKG99q85D2jTMCD/58dTyMrAT9q/wWlAe48VpdPHkSlPEk9k/blz+GctzyiSapYZq9u2+QJwYq+XDMPEHUtML8aqcY5sfH0Ns06yIIliguc2hRgV9GzetUWM/I96sc7ugW9lSvZzeY06kfaMdBfSGgueyJNgIuF2vx8dtsxv27KFQDHrK6oPGTGrB9xuIajZgKl177JzgUG/oELtumSBwxF63jKyVbk/iEHGkuqFayDkg1IMSUTkim9575vhFNvE1OZMQVCeQsBXS5IHBbI/A3sgRwdjc2WZbh+mYsIjqN6/16Ar+DO8evQJi5vwOu9IgFeAKmCaYg1zqUiY9JDlAdKciApIP2b+xXNSIH5eGPHDIg9QUCJY4PZ1QcuaQqQCjVjxhB/E7TxTptDxyFX/PyL6OZ3Y4ZsbBDtEz+nCHOnJpYJq7tzpDzllIKjpnoV6NWzdSa4i5SM2y/BI74zegnMGpfskVcY
 WD2KpQUb
 4GCbeGiRRPR3O9A6LV0+mugqyM8PgnkLehPl4SLnnJwvj+A/D52S7pETfa+CpXlARR1iryHYzFq9Je2MbAIWBQLs104C+Za/nO4s1o5rnusGWadKGLmZEaZah4KV9h8yhajmkUuxAPX+ZQvyh4VDnKpMW2qFfffRBRO5IcV3mLzfpaoBYjN4ilvBGu3x4GIP/B2xf0RVG99NvOS3ToQ9oh8HyOnuo33P7m9Tj3wh+BaKQio49eVCRTpZlcFigBppChohW9CegJA1WVLdgv5ziStdvo5cRp7VFcmfmajQjVTEGe4nrEl028eDvmEgSlQIWl45n1lzPv4rx9HB5IYG0bnM0eodLHDd7AHz3GaqmI0WdWbYda9B2wauwEIbFwRoT3fw2FIT9vavtTvKigpERf/Em1wcJt5sLWUtr/zSpGcJkc/I+tEMcJ9tTwQ9jN9V9mZ0EbKOn5Iz2tVOw9pG9T7fP2p1J8IJzPCWTFNy8YrsNl9WCafwNMwcOF2Py/APKaU3pG0HaOi1q5hZWSudgtLXYng==
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
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
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
2.55.0.1007.g17ff1f9808-goog



