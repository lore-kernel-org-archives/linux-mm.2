Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83037C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:53:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AF476B00AF; Mon,  7 Sep 2026 12:53:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 786886B00B0; Mon,  7 Sep 2026 12:53:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 628E46B00B1; Mon,  7 Sep 2026 12:53:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C92E76B00AF
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3DD811A019A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:53:11 +0000 (UTC)
X-FDA: 85187561382.13.B500425
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7161018000A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:53:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=K1xzs72N;
	spf=pass (imf24.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788799989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wiDantY2ppJjyfqauG6RKR7rX8GZTmilPQrscV/V7A4=;
	b=v4N3qSmczfQ+9gZ3z8QqtSskQcD8rb1pH9GuFG8Zta8OntST9VlOT5N8ohBvxcg/95xave
	D53ewogPDOEycsb7c984z9QMFPgRZk6M6gwqPQBd+WKHkB2g4adT8UypPuGjuwDMK7vYiB
	tJTrrdhCJ/+2R1lPjfO51uKcj7leg3s=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=K1xzs72N;
	spf=pass (imf24.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788799989;
	b=1/XGfMq+Tb0CglUEEvra1SUPNEKW518qsM94a+hotMHEkk3brlaH75S7k2LCw9uf34W2ah
	n+G8WoPxgyCc7HOJb6Q2rjq8aUQwtU0GJ0Mplejt98n1AXO6Mm0/0fvdFazCUv0LCAP7t6
	KuMXM1iH+/mor1/9VJ4/62NWCkc8bno=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49b392ccaacso56668825e9.2
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 09:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788799988; x=1789404788; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wiDantY2ppJjyfqauG6RKR7rX8GZTmilPQrscV/V7A4=;
        b=K1xzs72NM2ek7FoCA/k4Ba0CsnBIpfjlKfNJsOeKl3emcgwuxQQLSnE+sV0wGo4rT1
         W8FIgtoYJanDhqPQQ3Sd6eYDMuNKA8Jh7Y0+/A81jSjLcUubCaMNxs4zi92vUa9cPWZ3
         7T4uFXHlAcYscx1Dm1phLx4ac0kg0uOHxVmZRE2ROZnqrUNaDCrUgncNQh8i9DapVL5w
         cse2fMVGowVPSgZCPltcWsOH+YJ4ClS9SZ5iTk9PtnHIGwkSApit6PdfFwM+MxiGGgR3
         wMih7Bpplm3BJ81zRjmjJdbYpKUvO+7EGlgQGxxUywL2nAjcYx+y9nXlLYxXrHaXUgDB
         VmbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788799988; x=1789404788;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wiDantY2ppJjyfqauG6RKR7rX8GZTmilPQrscV/V7A4=;
        b=DCX7AQvcTPZxSH28duoe2GC6FO2g5g7RTmbn1g0xr6NI/bFg9PKlGQacgcT0Lt9sof
         VoGyr4vQmXmq7kKtTgLTHBIMXGOS7xysSR8KIrHEbL7X8GvF6jsCyxxE59j/6RADAezv
         KlclexHHdnF0axOxhKvXXMAEjiYQXUmVYK/t/LF5/1rP2m1cFdqXrCMIisLj+jftwlc+
         dzz0ON+Vu4laEXJ0Lv2WiKphUIa+SrkDGCJz4qVE+k9Ys/JajCxlv3i+UBqcKasEaI0j
         5UL5/CZtbRR71idhjDKMU8esjU6lHmlw8zkmJmcboR7SpfoKffHMw4DHblU1j9BYCeX4
         oIrA==
X-Forwarded-Encrypted: i=1; AKwUvBzQ7U2iEv0cchE8IsM1Pymnz9RPD//eAJA2rVDuymktMzLLxCT0siMNl4y+vqT9HrmW51/PvqF49w==@kvack.org
X-Gm-Message-State: AFuF++mgcd9UzCd1AVvzdmNeeGyIMa8hW7U8U6thLkBUk5kmKuZv6XhI
	TPSXO0E3cqhImalMlKCHbx4mxTdUwECTI0Bo13QygZR5jaklr1j/4HPB
X-Gm-Gg: AYBFou2CKiKMtJCaRh/tcBzcGJvL0P2K44CRzyw72InuFrsjVh1zcbqo/F+RJ3bLHlw
	m2XUVdkGruSW7Bzz0o28iUFbQF9ebnG9pdIS3dOdjhmh+WsYC48OMR2NMmL/toLE4mW+rh2S+Sn
	hUIvJQ4pBwGLzlhLB3S59fkr71WQp5wHGTnMOI8uz/JkrqFty6pTO2JLb0hB7HZR7qRkjX3uvKJ
	WAwc8U31cClQAzxu4RKD6+7AZG/hxJnnxoNHALHDe7hgwaN1d+xd9GNmm8V5UcvTQlW7V47uTuj
	ELYiw1o4Ojewy4IPu/Eq8jWbSoLFL12jd4NPODnM+QqY8eAMjB1ksOUsZPH1UzuZQZbc6dpXmO3
	aS62MM7wNeCFCxMuIoE4sDzbGWyzQTzfEiLAKfnHDJ9zTZdPNx4k5TeK9FBpT9xk5ZbQv4RGHz3
	wXGz+v+Hc3HUEn/rBZ6nt25+WbWHVHzzzRUtKjdijMX+WhI/6AE8O9rQexDnSCDUYqWfiTV7x1G
	w==
X-Received: by 2002:a05:600c:3e06:b0:49d:99:1d98 with SMTP id 5b1f17b1804b1-49d00991db1mr173226525e9.9.1788799987801;
        Mon, 07 Sep 2026 09:53:07 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d03543064sm233022415e9.13.2026.09.07.09.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 09:53:07 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: bpf@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	akpm@linux-foundation.org,
	andrii@kernel.org,
	ast@kernel.org,
	brauner@kernel.org,
	daniel@iogearbox.net,
	eddyz87@gmail.com,
	kpsingh@kernel.org,
	ljs@kernel.org,
	matt@bobrowski.net,
	memxor@gmail.com,
	song@kernel.org,
	sun.jian.kdev@gmail.com,
	tasos.papagiannnis@gmail.com,
	utilityemal77@gmail.com,
	viro@zeniv.linux.org.uk
Subject: [PATCH bpf-next v5 5/7] selftests/bpf: Cover trusted-or-null BTF pointer reads
Date: Mon,  7 Sep 2026 19:52:18 +0300
Message-ID: <20260907165220.52431-6-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260907165220.52431-1-tasos.papagiannnis@gmail.com>
References: <20260907165220.52431-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: djadsyos6akw8peiqmbqzunf1tntxc88
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7161018000A
X-Rspam-User: 
X-HE-Tag: 1788799989-461837
X-HE-Meta: U2FsdGVkX19mw+ukYqRnFp/p7223wraVSSzUrupkMeHsW0GE5uu1Iw3cfrxU0hvDaFp8ZiR6qqBh1G7PSYr4x+D90QawsWAjgMPbjli30d8smP8xtvt7hUuKRGHzz7p2iAE8PjpQ5jEWPWNVp2oQc1UAvRzfLTN2XM1ffSb6IrbdB9NoDVdCv5/aZfLZOKQnterApG+ryb9S2uMoXTXs2srCm/oz1UddNDx/RUdro6hI/QH5fpuu6MlAJTZECJ3rVjJ3SlfwWDUR67Yd/3HE+VGAbmlefj+dcuyWY58JYEldP5NtSWt3b2rDctCecIiXR3mPwumCW55d67PpfATPWhnhSyWX5JyraqHFQ9j42XgN/WZwtpSNIWDEZvIDfK3q6OA/oQ4AQ+ZuCBAfm+UvpuKNy5vyawVTkEo1B7fU9BTLYgHyCk8wvhMpkIqRwq8S9I2zG4VKcSouBAr64Ir6b0JhAemiMy+8bQX/0XjbmBzk+zswKNDOInxbv6bp3dGeENAVbxtoqQWJ1z/FVlj6rvQgPbaPQQw7Wf6N19MFAYAzXacx7MmXA9VaCXszjvS7LEVE992TNhZeLOuseVsKR++C1G6J6wMcQKaeRfz2YnDbCLZKGlAzUw3Ce88S9o/mn7YYVUpyR++9cqfU0UojJftMMIyC35Ni4sOcSg73LgnoIwyOtWx4K6Kv3DF5NR1JOCa0JCvr7NWj8vinSrQTgoCHyW5W2fwKCkQYy0UnqkReRyQXkXQb1eKvaDTaTHPrGKVoZVz/h5MMVFKzEEMInaZimQxunRkY4sRO3S10D+JXmqP5FEC+pjgc3uOWDz5Ci6R9hK7eJLcrfdKI0vev2bjNlvMpBzuEqGsK0aljxqQBw+KhqKXucH+GtK936cDPAGPfnrVPUZPeBR2QvLaltWH/qmF1s8/5M2UkG8S1fFM1vKhVZjy0eJ8p5vfyt02mOfQIC7i1blMWC+PLWiC
 WmCmVmQN
 SmDZbrAQ+NsVKwdSmB+Ej9AQiKfaOYIMI4DOTK6Eg3tCwTa+OaYnR6cbbbLzSU+3T4PaNzFLKkZHdc4VWF95zbzqyaN1/YIoHIyng+TFIVPkxh7+Ak0L6ouhgu4YKBK+NM8QrAnwIqKOumiyK8gnwoww2kQGu/vSk1HJBdej1s55jQHsBQkf7nNU7TrhZ2GfEMfRffS+NUWhJS3q+aV/SEw9X8Cvdu2qXph9f4LHT5G5bD2tPL44TM2Jib2nlyfFQT8TP3l+1zi+l5KymfSg57dDbng/0PU3JUNZGweulNGjh3YJCbDQz0gWnQw+FBt3J/90o3ErcvCJctLRv1Hj9nwEpcXapzbrjQuU7uYeNPbOkuAyofMEz4P1Pa6KBzc+FZjWR5YsTgV7JyOOnhRtnfJiwJk1uOXDun+gFxBTjlx8yaWB8iUmJ8SFCCI1+z6R2FU7kOSIhOaXjWO8bG+yptJSKRKYkGItaOIDpPpDK1VtN+pMbRERkaVkrHQ==
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
 .../prog_tests/test_struct_ops_maybe_null.c   | 13 ++--
 .../bpf/prog_tests/tp_btf_nullable.c          | 28 +++++++
 .../selftests/bpf/progs/raw_tp_null_fail.c    | 78 +++++++++++++++++--
 .../bpf/progs/test_tp_btf_nullable.c          | 45 ++++++++++-
 .../bpf/progs/test_tp_btf_nullable_runtime.c  | 35 +++++++++
 .../selftests/bpf/progs/verifier_lsm.c        | 18 ++++-
 .../selftests/bpf/progs/verifier_vfs_accept.c | 14 ++++
 .../selftests/bpf/progs/verifier_vfs_reject.c | 14 ----
 .../selftests/bpf/test_kmods/bpf_testmod.c    |  1 +
 .../sched_ext/maybe_null_fail_dsp.bpf.c       |  5 +-
 11 files changed, 221 insertions(+), 36 deletions(-)
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
index 01dc2613c8a5..45af6f00ad90 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_struct_ops_maybe_null.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_struct_ops_maybe_null.c
@@ -19,15 +19,16 @@ static void maybe_null(void)
 	struct_ops_maybe_null__destroy(skel);
 }
 
-/* Test that the verifier rejects a program that access a nullable pointer
- * without a check beforehand.
+/*
+ * Test that the verifier accepts a fault-protected read through a nullable
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
@@ -41,6 +42,6 @@ void test_struct_ops_maybe_null(void)
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
index 725d73c9ffe1..163124793d0a 100644
--- a/tools/testing/selftests/bpf/progs/raw_tp_null_fail.c
+++ b/tools/testing/selftests/bpf/progs/raw_tp_null_fail.c
@@ -2,22 +2,34 @@
 /* Copyright (c) 2024 Meta Platforms, Inc. and affiliates. */
 
 #include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 #include "bpf_misc.h"
 
 char _license[] SEC("license") = "GPL";
 
-/* Ensure module parameter has PTR_MAYBE_NULL */
+extern struct task_struct *bpf_task_acquire(struct task_struct *p) __ksym;
+extern void bpf_task_release(struct task_struct *p) __ksym;
+
+/*
+ * Ensure the module tracepoint argument is trusted-or-NULL while allowing
+ * a fault-protected read without an explicit NULL check.
+ */
 SEC("tp_btf/bpf_testmod_test_raw_tp_null_tp")
-__failure __msg("R1 invalid mem access 'trusted_ptr_or_null_'")
+__success __log_level(2)
+__msg("R1=trusted_ptr_or_null_sk_buff")
 int test_raw_tp_null_bpf_testmod_test_raw_tp_null_arg_1(void *ctx) {
     asm volatile("r1 = *(u64 *)(r1 +0); r1 = *(u64 *)(r1 +0);" ::: __clobber_all);
     return 0;
 }
 
-/* Check NULL marking */
+/*
+ * Ensure sched_pi_setprio's second argument is trusted-or-NULL while allowing
+ * a fault-protected read without an explicit NULL check.
+ */
 SEC("tp_btf/sched_pi_setprio")
-__failure __msg("R1 invalid mem access 'trusted_ptr_or_null_'")
+__success __log_level(2)
+__msg("R1=trusted_ptr_or_null_task_struct")
 int test_raw_tp_null_sched_pi_setprio_arg_2(void *ctx) {
     asm volatile("r1 = *(u64 *)(r1 +8); r1 = *(u64 *)(r1 +0);" ::: __clobber_all);
     return 0;
@@ -60,7 +72,8 @@ int test_tp_btf_signal_deliver_info_no_deref(void *ctx)
 }
 
 SEC("tp_btf/sched_process_wait")
-__failure __msg("R1 invalid mem access 'trusted_ptr_or_null_'")
+__success __log_level(2)
+__msg("R1=trusted_ptr_or_null_pid")
 int test_raw_tp_null_sched_process_wait_arg_1(void *ctx)
 {
 	asm volatile("r1 = *(u64 *)(r1 +0); r1 = *(u32 *)(r1 +0);" ::: __clobber_all);
@@ -75,3 +88,58 @@ int test_raw_tp_null_sched_process_wait_arg_1_checked(void *ctx)
 		     "r1 = *(u32 *)(r1 +0);" ::: __clobber_all);
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
index cf0547a613ff..b7914224ba19 100644
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
@@ -21,4 +21,47 @@ int BPF_PROG(handle_tp_btf_nullable_bare2, struct bpf_testmod_test_read_ctx *nul
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
+SEC("tp_btf/bpf_testmod_test_nullable_bare_tp")
+__failure __msg("invalid mem access 'trusted_ptr_or_null_'")
+int BPF_PROG(handle_tp_btf_nullable_atomic_rmw,
+	     struct bpf_testmod_test_read_ctx *nullable_ctx)
+{
+	asm volatile ("r1 = %[ctx];"
+		      "w2 = 1;"
+		      "lock *(u32 *)(r1 + %[len]) += w2;"
+		      :
+		      : [ctx] "r"(nullable_ctx),
+			__imm_const(len,
+				    offsetof(struct bpf_testmod_test_read_ctx,
+					     len))
+		      : "r1", "r2", "memory");
+	return 0;
+}
+
+#ifdef __BPF_FEATURE_LOAD_ACQ_STORE_REL
+SEC("tp_btf/bpf_testmod_test_nullable_bare_tp")
+__failure
+__msg("BPF_ATOMIC loads from R{{[0-9]+}} trusted_ptr_or_null_")
+int BPF_PROG(handle_tp_btf_nullable_load_acquire,
+	     struct bpf_testmod_test_read_ctx *nullable_ctx)
+{
+	return __atomic_load_n(&nullable_ctx->len, __ATOMIC_ACQUIRE);
+}
+#endif
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
index c724bf389f5c..fac133d90f5e 100644
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
@@ -188,6 +188,16 @@ int BPF_PROG(null_check, struct file *file)
 	return 0;
 }
 
+SEC("lsm/mmap_file")
+__description("store through trusted-or-null file is rejected")
+__failure
+__msg("R{{[0-9]+}} invalid mem access 'trusted_ptr_or_null_'")
+int BPF_PROG(store_through_trusted_or_null_file, struct file *file)
+{
+	file->f_flags = 0;
+	return 0;
+}
+
 SEC("lsm_cgroup/file_open")
 __description("sleepable lsm_cgroup program is rejected")
 __failure __msg("Program of this type cannot be sleepable")
diff --git a/tools/testing/selftests/bpf/progs/verifier_vfs_accept.c b/tools/testing/selftests/bpf/progs/verifier_vfs_accept.c
index 55398c04290a..17c1542cc7e1 100644
--- a/tools/testing/selftests/bpf/progs/verifier_vfs_accept.c
+++ b/tools/testing/selftests/bpf/progs/verifier_vfs_accept.c
@@ -100,4 +100,18 @@ int BPF_PROG(inode_rename, struct inode *old_dir, struct dentry *old_dentry,
 	return 0;
 }
 
+SEC("lsm.s/inode_rename")
+__success __log_level(2)
+__msg("R{{[0-9]+}}=trusted_ptr_or_null_inode")
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
index f798bbbb4d13..2ba6a83d243f 100644
--- a/tools/testing/selftests/bpf/test_kmods/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/test_kmods/bpf_testmod.c
@@ -702,6 +702,7 @@ bpf_testmod_test_read(struct file *file, struct kobject *kobj,
 	if (bpf_testmod_loop_test(101) > 100)
 		trace_bpf_testmod_test_read(current, &ctx);
 
+	trace_bpf_testmod_test_nullable_bare_tp(&ctx);
 	trace_bpf_testmod_test_nullable_bare_tp(NULL);
 
 	/* Magic number to enable writable tp */
diff --git a/tools/testing/selftests/sched_ext/maybe_null_fail_dsp.bpf.c b/tools/testing/selftests/sched_ext/maybe_null_fail_dsp.bpf.c
index ec724d7b33d1..ecaa36355cae 100644
--- a/tools/testing/selftests/sched_ext/maybe_null_fail_dsp.bpf.c
+++ b/tools/testing/selftests/sched_ext/maybe_null_fail_dsp.bpf.c
@@ -7,14 +7,13 @@
 
 char _license[] SEC("license") = "GPL";
 
-u64 vtime_test;
-
 void BPF_STRUCT_OPS(maybe_null_running, struct task_struct *p)
 {}
 
 void BPF_STRUCT_OPS(maybe_null_fail_dispatch, s32 cpu, struct task_struct *p)
 {
-	vtime_test = p->scx.dsq_vtime;
+	/* Pointer arithmetic on a trusted-or-NULL pointer must be rejected. */
+	asm volatile("%[p] += 0" : [p] "+r"(p));
 }
 
 SEC(".struct_ops.link")
-- 
2.55.0


