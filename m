Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADD82C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:24:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3A046B00A0; Mon, 31 Aug 2026 05:23:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C12B86B00A1; Mon, 31 Aug 2026 05:23:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B003E6B00A2; Mon, 31 Aug 2026 05:23:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B4466B00A0
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:23:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 97286403F3
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:23:56 +0000 (UTC)
X-FDA: 85161027672.15.6BEB121
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf12.hostedemail.com (Postfix) with ESMTP id C940A40003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:23:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lzQpsM5X;
	spf=pass (imf12.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788168234;
	b=DHhXAYdz8P7EnLWSCefTtzqVXv4SrPc5Pqztl6Uzcr7Qb6ungtoOghLbrji5JtNnGg9rLA
	akwQlFhAqi+Qwwd0NoMBiWE+pUcNo+QnndOYVbTh+A5SwK72fxutuTc+4ETX7Ys8f4dXaC
	OBkH08z5cVPivmSRmwrz1wHh7LU9lI4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lzQpsM5X;
	spf=pass (imf12.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788168234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7aRnsGsof0e8gkLWKg4mNpSLZl74e3wgbbLhSoxhavQ=;
	b=ei0sCUmR+iPeMr/i2PTNb0r/XYMkyXx50Ai/aGEinGE2KQU3JWK25zwW8jOgaRhT4Ndw+L
	fWhPCIbRIJ1X6WSSu7l4yen1wIbd67C6+JxDPsUO3a9ysABOyEDEH7ivzalftGW/oz/dyz
	gWHuZpWqUFRl6dVU8MHjUZk4+hRDO3o=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4953e04ef16so31852725e9.2
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 02:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788168233; x=1788773033; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7aRnsGsof0e8gkLWKg4mNpSLZl74e3wgbbLhSoxhavQ=;
        b=lzQpsM5XUsvgaqpQVAxsVVX6T1S5HHX0X2QH1z/kMKQzznui4nC7wdzevL5DXItf6+
         iYW70YA9sEGcG/8kBFhCYrWM5QRnjH46uFZHPlceRS8Zj2wCODA7yt8TYRIyDZOc1lPo
         kkxV0bEIBMUduUF1UlIxIaiBCZmPtNIyh2iK2Ycl/lHE3V7f6/sOav4XVY+5CEIngO9Y
         t7WqIKPY0n8LdtR9RO4Nsaq/2BM7WY97bfdjE+Bp8Kx+dK871w5LO/ythNaCvIdf1VvQ
         0jV5lp8tQezfVuPQ6gB/hC0zaxFebDq5gosfn5LXwl4jf++Fuo5HIcOdWyWTQZOcn4MQ
         DFcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788168233; x=1788773033;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7aRnsGsof0e8gkLWKg4mNpSLZl74e3wgbbLhSoxhavQ=;
        b=lRAILkW/FJnuNmOqYbwG+cLpkruG0PXabD4CA/Y2bt1JSZF3gUyRWH4BZNZx+wFmYI
         /X96dYphPBnMgI39HpRbMookrzMTy1eOmMYEm5nDtOTfW5H5v/5LaT5SUskfgPBK3W8q
         Dn41Uudjvf+TJJFQawo64yj67I5pC0+rOG5/nIbz7hor+WQ+yOw2+LXLlmaa2lHqT3Ho
         5Ab1YYZpqPwIUvHLs4u7Wr+JWw7/F0d3Uj5v6fUcupmJkBriBTl27kI8Nz+eCdqt2sVj
         8qVUsEYTQfCGo8x0z/m3KKTBX7RC8NFvM7xOXDQD74gdOdh6HN2mZ+QVOYWMOYThxkhb
         WIvg==
X-Forwarded-Encrypted: i=1; AHgh+RoQChQRH9v31yETZlKDce2Fu7Ae1VlYfK7mzSYHJRGlcoIsJJoh6z80TTj9VxgmHRBwXJHsvfg0jQ==@kvack.org
X-Gm-Message-State: AFuF++nsxMKmpW6si7e4CXlnPrLZqelaWBsmXXuKVQQcvcdZZqaeEX5H
	VLHdYVzHo9IHQkrAdUBP25lUFpX1GCXQ7w40qD1FyvjiBiDhu+U4kv85
X-Gm-Gg: AR+sD10PeRkrKAmb6wW7FK1h1l8MupdgovWcoR1mcQSfoYeJlSvSMXaLYGtXNR2KgKS
	634Jx4ewJfv1qZhno6Yh1VVrm0nn3nEoT920rgZNBLhWXa244wZq//dEyPPPrRQBX73pO2y9yhg
	EDDtPUKFXkGO/Qb58bhieaueeDn1tza3YqyC7NgJ2hvIEIkokhxAESTeFpqJnCCOG0bVZ+YNXUr
	3ktbcu+A1GUPj2uY3Qn2P+Yqz0POpg5aH4qbbobGqavVtjnUDUJ27nilDYnC06G1/qPFNTyEosh
	O6CbSSJUiNCkVavjxJ7g2iYm27lvvetVg+tblT9xeC/753sgDycMhfsgmNzazbixdURKVlVKHFE
	bT2yOTTgZYPrG6zgYRpVcj10YrpbRnMa953rAUUUo566jymf5SnqcSVmIbQER8xTVaABM69rZCF
	d5riSPxxKNRMItgWgRSRCKHMqNkPPPs6/MT1tuuZoBjwIDVbKc5bVsRQPNHY8213BHGY8b8BCEj
	g==
X-Received: by 2002:a05:600c:1d1d:b0:49b:d45:703e with SMTP id 5b1f17b1804b1-49b91c2dfecmr369076705e9.8.1788168233348;
        Mon, 31 Aug 2026 02:23:53 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b9500c80asm318248155e9.9.2026.08.31.02.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 02:23:52 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	kpsingh@kernel.org,
	matt@bobrowski.net,
	song@kernel.org,
	utilityemal77@gmail.com,
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next v3 5/7] selftests/bpf: Cover trusted-or-null BTF pointer reads
Date: Mon, 31 Aug 2026 12:23:03 +0300
Message-ID: <20260831092305.42062-6-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831092305.42062-1-tasos.papagiannnis@gmail.com>
References: <20260831092305.42062-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C940A40003
X-Stat-Signature: awtrd9opph6f7biikoumgzuppbot44dy
X-HE-Tag: 1788168234-994810
X-HE-Meta: U2FsdGVkX19oIVdP8C1lwRY0mILPvOrrTeeySfK1cUGisFCb4ZLmNLcoBDHLLBDJ7BMekkrxTrBUbaGjOKYwnP9+tmR7OEhf4P5JvzunV4gZT6Qoe3ZnEClUBl00O2w13fmMW4bnMppiOX6c9tFDvAjlKdKHPWpbX9FU9SbiBhVJS5QlxEQqdPJoGlD9pBUbCHz4rlXHiTxGiAxtoL53KMhXMzFZjCYF075D/Npt7AP0Zc/XDE+G67+4wfne7pK/p7TRy3kFfzs1P8yly93EeWNuwNjpLTYQL76hFkbl8mKPSgWkhgEE9UX149IDK00Y92zFok1gKRbXeFz5QCDq62/jZwqvMpM0ZvGE9K4PYCr+J9pp61IsrcxjnzMkQ+rbO4tehsKAtn3Lg5gLHJz5uLLrQUYJqX9AzxUPL+yZzG4HeG+HC+xZBWGJip9TBfaTyI46rKczgAK1TjHsVpEsl/eoaBcCXyZbFRI6YPgeWN/rXztT24K8CWwRE4H/wi0bFEzyhzbm60w2XTUXW67Gvm1F9ezyQgPcwvRMFOrq8v3xEOJU5rEw00z8exSYUO2sOY6XHQ2S8QRPzeYhaKz2A6M8ZeKkrLPWWZO7TdeUEge+XhehvEJ9J70dzbYq8Q6KTTiFAOrRovHZKXcmn16+L+8+8xKXOhB1PI76XJ1zvFnlupTppfBpy8O4oAI15SOQVIlm9e6Rh4rMwN/Zi3CCdcJXf5wUuMHPtpFPrptwvvvTLjyE7P4xvN/PeYMHstViqxg1DFkI4qNEJJvE0PPqidyGuhO5teBzip2qydMkkz7RNiQpnRfMJzsbYSecU0wanbfaHaijdADNwi2FwXI8J5IMokgj0JtsmJo/P9DRE6BW32muBTAlnqjXljtd0jgriTRBWgp0SkCo8Amsz7duxCBh0+zcr8EDIsmRLRkMK8mwkpdoRIVf54D+3cVB5usy7GgxH1OsdvZ4vXAjBFT
 KJAJy/Ov
 1jARi9ArMrmqM7iPhogaj2YG9IPN+PbpJohhBaynYtPKdYPcgtP4QEqs6mZtLO9oPkD2jxR8AHC1iIJtKFCPFMw4TiLRWGdTwtUFXUBbqgyuYoOVLbv873UveYcPI3U6otd1N9LI6e85MrcJ/RFAa06MIq7Yep34EqEWo3nn2Y283xk46mO2zkiX9icpBMyQmnnVVkt+f8bdDSeN3U4Jf3fhtlyANJvXojKOgBQSv5/DyztebQDA4LQl/1d6jL5gkqmXNzDDMwnwtUZoJCeIT0n9tN/s/Fg1zS3Zp8XpoYO0BQryCbhYB98OY80eWpzJQ8YHIcCe9Ym6R6biirc1JK8ZtJeDKgcBr0o13FqgL+MnLj5hWwcjtfrc8Si2Byn45/OejPNlu42mSirHaeUSSLuFqD+bqZLFViUjAwJClHPlfuDrX9Z/6pXruGo4fiS+wOxg4uxr6Kat0UcoYFCGn9WPuOkbWwfkBACYz+24V69Ik4R3X6toUYYaXDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update verifier tests that expected an unchecked trusted-or-null BTF
pointer dereference to fail. Cover scalar reads and chained reads through
BTF and memory pointers. Add a runtime test which verifies that non-NULL
reads return the field value and NULL reads return zero.

Verify that pointer arithmetic, stores, atomic RMW operations, and
BPF_LOAD_ACQ accesses remain prohibited. Assert that a BTF pointer
derived from an unchecked trusted-or-null load is PTR_UNTRUSTED. Verify
that attempting to NULL-check the derived pointer remains rejected and
that it cannot be passed to a kfunc requiring an RCU pointer. Keep the
existing NULL-check tests to verify that an explicit check of the original
pointer recovers normal trusted pointer behavior.

Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
---
 .../selftests/bpf/prog_tests/bpf_iter.c       |  6 +-
 .../prog_tests/test_struct_ops_maybe_null.c   | 12 ++--
 .../bpf/prog_tests/tp_btf_nullable.c          | 28 +++++++++
 .../selftests/bpf/progs/raw_tp_null_fail.c    | 63 ++++++++++++++++++-
 .../bpf/progs/test_tp_btf_nullable.c          | 17 ++++-
 .../bpf/progs/test_tp_btf_nullable_runtime.c  | 35 +++++++++++
 .../selftests/bpf/progs/verifier_lsm.c        | 19 ++++--
 .../selftests/bpf/progs/verifier_vfs_accept.c | 13 ++++
 .../selftests/bpf/progs/verifier_vfs_reject.c | 14 -----
 .../selftests/bpf/test_kmods/bpf_testmod.c    |  1 +
 .../testing/selftests/sched_ext/maybe_null.c  |  6 +-
 11 files changed, 181 insertions(+), 33 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_tp_btf_nullable_runtime.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
index c69080ca14f5..99a16a1add70 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -39,10 +39,10 @@ static void test_btf_id_or_null(void)
 	struct bpf_iter_test_kern3 *skel;
 
 	skel = bpf_iter_test_kern3__open_and_load();
-	if (!ASSERT_ERR_PTR(skel, "bpf_iter_test_kern3__open_and_load")) {
-		bpf_iter_test_kern3__destroy(skel);
+	if (!ASSERT_OK_PTR(skel, "bpf_iter_test_kern3__open_and_load"))
 		return;
-	}
+
+	bpf_iter_test_kern3__destroy(skel);
 }
 
 static void do_dummy_read_opts(struct bpf_program *prog, struct bpf_iter_attach_opts *opts)
diff --git a/tools/testing/selftests/bpf/prog_tests/test_struct_ops_maybe_null.c b/tools/testing/selftests/bpf/prog_tests/test_struct_ops_maybe_null.c
index 01dc2613c8a5..03670ddc89bd 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_struct_ops_maybe_null.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_struct_ops_maybe_null.c
@@ -19,15 +19,15 @@ static void maybe_null(void)
 	struct_ops_maybe_null__destroy(skel);
 }
 
-/* Test that the verifier rejects a program that access a nullable pointer
- * without a check beforehand.
+/* Test that the verifier accepts a fault-protected read through a nullable
+ * trusted pointer without an explicit NULL check.
  */
-static void maybe_null_fail(void)
+static void maybe_null_no_check(void)
 {
 	struct struct_ops_maybe_null_fail *skel;
 
 	skel = struct_ops_maybe_null_fail__open_and_load();
-	if (ASSERT_ERR_PTR(skel, "struct_ops_module_fail__open_and_load"))
+	if (!ASSERT_OK_PTR(skel, "struct_ops_maybe_null_fail__open_and_load"))
 		return;
 
 	struct_ops_maybe_null_fail__destroy(skel);
@@ -41,6 +41,6 @@ void test_struct_ops_maybe_null(void)
 	 */
 	if (test__start_subtest("maybe_null"))
 		maybe_null();
-	if (test__start_subtest("maybe_null_fail"))
-		maybe_null_fail();
+	if (test__start_subtest("maybe_null_no_check"))
+		maybe_null_no_check();
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/tp_btf_nullable.c b/tools/testing/selftests/bpf/prog_tests/tp_btf_nullable.c
index accc42e01f8a..825fe7a92d74 100644
--- a/tools/testing/selftests/bpf/prog_tests/tp_btf_nullable.c
+++ b/tools/testing/selftests/bpf/prog_tests/tp_btf_nullable.c
@@ -2,6 +2,31 @@
 
 #include <test_progs.h>
 #include "test_tp_btf_nullable.skel.h"
+#include "test_tp_btf_nullable_runtime.skel.h"
+
+static void test_nullable_runtime(void)
+{
+	struct test_tp_btf_nullable_runtime *skel;
+
+	skel = test_tp_btf_nullable_runtime__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		return;
+
+	skel->bss->monitored_tid = sys_gettid();
+
+	if (!ASSERT_OK(test_tp_btf_nullable_runtime__attach(skel), "attach"))
+		goto out;
+
+	if (!ASSERT_OK(trigger_module_test_read(2), "trigger"))
+		goto out;
+
+	ASSERT_EQ(skel->bss->calls, 2, "calls");
+	ASSERT_EQ(skel->bss->nonnull_len, 2, "nonnull_len");
+	ASSERT_EQ(skel->bss->null_len, 0, "null_len");
+
+out:
+	test_tp_btf_nullable_runtime__destroy(skel);
+}
 
 void test_tp_btf_nullable(void)
 {
@@ -11,4 +36,7 @@ void test_tp_btf_nullable(void)
 	}
 
 	RUN_TESTS(test_tp_btf_nullable);
+
+	if (test__start_subtest("runtime"))
+		test_nullable_runtime();
 }
diff --git a/tools/testing/selftests/bpf/progs/raw_tp_null_fail.c b/tools/testing/selftests/bpf/progs/raw_tp_null_fail.c
index 0d58114a4955..45df28c0a25e 100644
--- a/tools/testing/selftests/bpf/progs/raw_tp_null_fail.c
+++ b/tools/testing/selftests/bpf/progs/raw_tp_null_fail.c
@@ -2,14 +2,18 @@
 /* Copyright (c) 2024 Meta Platforms, Inc. and affiliates. */
 
 #include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 #include "bpf_misc.h"
 
 char _license[] SEC("license") = "GPL";
 
+extern struct task_struct *bpf_task_acquire(struct task_struct *p) __ksym;
+extern void bpf_task_release(struct task_struct *p) __ksym;
+
 /* Ensure module parameter has PTR_MAYBE_NULL */
 SEC("tp_btf/bpf_testmod_test_raw_tp_null_tp")
-__failure __msg("R1 invalid mem access 'trusted_ptr_or_null_'")
+__success
 int test_raw_tp_null_bpf_testmod_test_raw_tp_null_arg_1(void *ctx) {
     asm volatile("r1 = *(u64 *)(r1 +0); r1 = *(u64 *)(r1 +0);" ::: __clobber_all);
     return 0;
@@ -17,8 +21,63 @@ int test_raw_tp_null_bpf_testmod_test_raw_tp_null_arg_1(void *ctx) {
 
 /* Check NULL marking */
 SEC("tp_btf/sched_pi_setprio")
-__failure __msg("R1 invalid mem access 'trusted_ptr_or_null_'")
+__success
 int test_raw_tp_null_sched_pi_setprio_arg_2(void *ctx) {
     asm volatile("r1 = *(u64 *)(r1 +8); r1 = *(u64 *)(r1 +0);" ::: __clobber_all);
     return 0;
 }
+
+SEC("tp_btf/sched_pi_setprio")
+__failure __log_level(2)
+__msg("R1=untrusted_ptr_task_struct")
+__msg("R1 must be a rcu pointer")
+int BPF_PROG(trusted_or_null_walk_is_untrusted, struct task_struct *task,
+	     struct task_struct *pi_task)
+{
+	struct task_struct *parent, *acquired;
+
+	parent = pi_task->real_parent;
+	acquired = bpf_task_acquire(parent);
+	if (acquired)
+		bpf_task_release(acquired);
+	return 0;
+}
+
+SEC("tp_btf/sched_pi_setprio")
+__failure __msg("R1 must be a rcu pointer")
+int BPF_PROG(derived_ptr_null_check_does_not_restore_trust,
+	     struct task_struct *task, struct task_struct *pi_task)
+{
+	struct task_struct *parent, *acquired;
+
+	parent = pi_task->real_parent;
+	if (!parent)
+		return 0;
+
+	acquired = bpf_task_acquire(parent);
+	if (acquired)
+		bpf_task_release(acquired);
+
+	return 0;
+}
+
+/*
+ * In contrast, checking the original trusted-or-NULL pointer removes
+ * PTR_MAYBE_NULL while retaining PTR_TRUSTED.
+ */
+SEC("tp_btf/sched_pi_setprio")
+__success
+int BPF_PROG(original_ptr_null_check_retains_trust,
+	     struct task_struct *task, struct task_struct *pi_task)
+{
+	struct task_struct *acquired;
+
+	if (!pi_task)
+		return 0;
+
+	acquired = bpf_task_acquire(pi_task);
+	if (acquired)
+		bpf_task_release(acquired);
+
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/test_tp_btf_nullable.c b/tools/testing/selftests/bpf/progs/test_tp_btf_nullable.c
index cf0547a613ff..a86b526d27f9 100644
--- a/tools/testing/selftests/bpf/progs/test_tp_btf_nullable.c
+++ b/tools/testing/selftests/bpf/progs/test_tp_btf_nullable.c
@@ -7,7 +7,7 @@
 #include "bpf_misc.h"
 
 SEC("tp_btf/bpf_testmod_test_nullable_bare_tp")
-__failure __msg("R1 invalid mem access 'trusted_ptr_or_null_'")
+__success
 int BPF_PROG(handle_tp_btf_nullable_bare1, struct bpf_testmod_test_read_ctx *nullable_ctx)
 {
 	return nullable_ctx->len;
@@ -21,4 +21,19 @@ int BPF_PROG(handle_tp_btf_nullable_bare2, struct bpf_testmod_test_read_ctx *nul
 	return 0;
 }
 
+SEC("tp_btf/bpf_testmod_test_nullable_bare_tp")
+__success
+int BPF_PROG(handle_tp_btf_nullable_mem, struct bpf_testmod_test_read_ctx *nullable_ctx)
+{
+	return nullable_ctx->buf[0];
+}
+
+SEC("tp_btf/bpf_testmod_test_nullable_bare_tp")
+__failure __msg("pointer arithmetic on trusted_ptr_or_null_ prohibited")
+int BPF_PROG(handle_tp_btf_nullable_arith, struct bpf_testmod_test_read_ctx *nullable_ctx)
+{
+	asm volatile("%[ctx] += 1" : [ctx] "+r"(nullable_ctx));
+	return nullable_ctx->len;
+}
+
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_tp_btf_nullable_runtime.c b/tools/testing/selftests/bpf/progs/test_tp_btf_nullable_runtime.c
new file mode 100644
index 000000000000..5c9c7f94040d
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_tp_btf_nullable_runtime.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include "../test_kmods/bpf_testmod.h"
+
+char _license[] SEC("license") = "GPL";
+
+int monitored_tid;
+int calls;
+__u64 nonnull_len;
+__u64 null_len;
+
+SEC("tp_btf/bpf_testmod_test_nullable_bare_tp")
+int BPF_PROG(handle_nullable_runtime,
+	     struct bpf_testmod_test_read_ctx *nullable_ctx)
+{
+	__u32 tid = bpf_get_current_pid_tgid();
+	__u64 len;
+	int call;
+
+	if (tid != monitored_tid)
+		return 0;
+
+	len = nullable_ctx->len;
+	call = calls++;
+
+	if (call == 0)
+		nonnull_len = len;
+	else if (call == 1)
+		null_len = len;
+
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/verifier_lsm.c b/tools/testing/selftests/bpf/progs/verifier_lsm.c
index c724bf389f5c..c912215579c9 100644
--- a/tools/testing/selftests/bpf/progs/verifier_lsm.c
+++ b/tools/testing/selftests/bpf/progs/verifier_lsm.c
@@ -162,13 +162,13 @@ __naked int disabled_hook_test3(void *ctx)
 
 SEC("lsm/mmap_file")
 __description("not null checking nullable pointer in bpf_lsm_mmap_file")
-__failure __msg("R1 invalid mem access 'trusted_ptr_or_null_'")
+__success
 int BPF_PROG(no_null_check, struct file *file)
 {
-	struct inode *inode;
+	ino_t ino;
 
-	inode = file->f_inode;
-	__sink(inode);
+	ino = file->f_inode->i_ino;
+	__sink(ino);
 
 	return 0;
 }
@@ -188,6 +188,17 @@ int BPF_PROG(null_check, struct file *file)
 	return 0;
 }
 
+SEC("lsm.s/bprm_check_security")
+__description("store through trusted-or-null bprm->mm is rejected")
+__failure
+__msg("R{{[0-9]+}} invalid mem access 'trusted_ptr_or_null_'")
+int BPF_PROG(store_through_trusted_or_null_bprm_mm,
+	     struct linux_binprm *bprm)
+{
+	bprm->mm->task_size = 0;
+	return 0;
+}
+
 SEC("lsm_cgroup/file_open")
 __description("sleepable lsm_cgroup program is rejected")
 __failure __msg("Program of this type cannot be sleepable")
diff --git a/tools/testing/selftests/bpf/progs/verifier_vfs_accept.c b/tools/testing/selftests/bpf/progs/verifier_vfs_accept.c
index 55398c04290a..2827a1650727 100644
--- a/tools/testing/selftests/bpf/progs/verifier_vfs_accept.c
+++ b/tools/testing/selftests/bpf/progs/verifier_vfs_accept.c
@@ -100,4 +100,17 @@ int BPF_PROG(inode_rename, struct inode *old_dir, struct dentry *old_dentry,
 	return 0;
 }
 
+SEC("lsm.s/inode_rename")
+__success
+int BPF_PROG(inode_rename_no_null_check, struct inode *old_dir,
+	     struct dentry *old_dentry, struct inode *new_dir,
+	     struct dentry *new_dentry, unsigned int flags)
+{
+	ino_t ino = new_dentry->d_inode->i_ino;
+
+	if (ino == 0)
+		return -EACCES;
+	return 0;
+}
+
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/verifier_vfs_reject.c b/tools/testing/selftests/bpf/progs/verifier_vfs_reject.c
index 8f0c45421f89..2a0813258183 100644
--- a/tools/testing/selftests/bpf/progs/verifier_vfs_reject.c
+++ b/tools/testing/selftests/bpf/progs/verifier_vfs_reject.c
@@ -159,18 +159,4 @@ int BPF_PROG(path_d_path_kfunc_non_lsm, struct path *path, struct file *f)
 	return 0;
 }
 
-SEC("lsm.s/inode_rename")
-__failure __msg("invalid mem access 'trusted_ptr_or_null_'")
-int BPF_PROG(inode_rename, struct inode *old_dir, struct dentry *old_dentry,
-	     struct inode *new_dir, struct dentry *new_dentry,
-	     unsigned int flags)
-{
-	struct inode *inode = new_dentry->d_inode;
-	ino_t ino;
-
-	ino = inode->i_ino;
-	if (ino == 0)
-		return -EACCES;
-	return 0;
-}
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_kmods/bpf_testmod.c b/tools/testing/selftests/bpf/test_kmods/bpf_testmod.c
index 2380b6cbdead..2da9c2464c25 100644
--- a/tools/testing/selftests/bpf/test_kmods/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/test_kmods/bpf_testmod.c
@@ -651,6 +651,7 @@ bpf_testmod_test_read(struct file *file, struct kobject *kobj,
 	if (bpf_testmod_loop_test(101) > 100)
 		trace_bpf_testmod_test_read(current, &ctx);
 
+	trace_bpf_testmod_test_nullable_bare_tp(&ctx);
 	trace_bpf_testmod_test_nullable_bare_tp(NULL);
 
 	/* Magic number to enable writable tp */
diff --git a/tools/testing/selftests/sched_ext/maybe_null.c b/tools/testing/selftests/sched_ext/maybe_null.c
index aacf0c58ca4f..8fec296c31bd 100644
--- a/tools/testing/selftests/sched_ext/maybe_null.c
+++ b/tools/testing/selftests/sched_ext/maybe_null.c
@@ -25,11 +25,11 @@ static enum scx_test_status run(void *ctx)
 	maybe_null__destroy(skel);
 
 	fail_dsp = maybe_null_fail_dsp__open_and_load();
-	if (fail_dsp) {
-		maybe_null_fail_dsp__destroy(fail_dsp);
-		SCX_ERR("Should failed to open and load maybe_null_fail_dsp skel");
+	if (!fail_dsp) {
+		SCX_ERR("Failed to open and load maybe_null_fail_dsp skel");
 		return SCX_TEST_FAIL;
 	}
+	maybe_null_fail_dsp__destroy(fail_dsp);
 
 	fail_yld = maybe_null_fail_yld__open_and_load();
 	if (fail_yld) {
-- 
2.55.0


