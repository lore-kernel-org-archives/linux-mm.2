Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEF10C79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 14:54:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FF146B00A0; Fri,  4 Sep 2026 10:54:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 188FA6B00A1; Fri,  4 Sep 2026 10:54:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 002ED6B00A2; Fri,  4 Sep 2026 10:54:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C72A76B00A0
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:54:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5CB8D1A0169
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:54:35 +0000 (UTC)
X-FDA: 85176376110.24.D7BFC1A
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7FC6120003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:54:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Py68GHiK;
	spf=pass (imf03.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788533673;
	b=ToZlyRun40H/Ry+d8vg193i/zKJrkV9LaDBqkOV6ItzS00Yuxj2kJCxm4vs1i63P/RSG2O
	VIZOuLa3telJ0TEGIYT1fV4ZJdwf8pp0u1N0EOGC4DzhvAXhEkWBvavl80CrhMuZnERrc9
	3KQ6xtIjgdX+nz5XgbERlrZk0AEaUG4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Py68GHiK;
	spf=pass (imf03.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788533673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3pwlsy70YW3qwfiCOdC58N7kJRNRBNA8nQQHxlaBoNo=;
	b=DpyQUGLgsF9te7E3LDmQOhTYg7IwIEV5D1iegucz1oWQOrKAHuc2Yiw2uthiN0AJjwpZXv
	sdABwuu9Nx3mH6x4TR2EyhQ04zgitSqWb40Y9TwxcAOa7Kq29pSuBj6onrW7DEaMrGrAD2
	fosDYtbCo3oefzyF4G5+XegVek2b1PA=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-47f96c5b722so744737f8f.0
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 07:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788533672; x=1789138472; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3pwlsy70YW3qwfiCOdC58N7kJRNRBNA8nQQHxlaBoNo=;
        b=Py68GHiKByXHuuUmQ2lJZNwuJrIUvG2RUjMBzQcnaoFJxNzcUenIl7r5VluMa9duZt
         +GAvwzM7C/99w/UzK7NkW19/KJP07pU1hW69Ul7oSeNYNAY2+5SntxSXk4EftTH+LdYU
         fvHsBGmugEl8MU7+4rksgD45aHCadXip1T2tq5gjs4TsrgNRanAgp4PNReSo+vtauckk
         PE8xolCkU7Lx7tnI1zp+hSetiEL5Ai4GS9s6u1zIwIpSLRAPZ040qndrt6T3e5jLNKhv
         G+pXwVPwm0nZTOxwkKWEt8A3XriRERq6A3tFM4aIbAtbCx2NA3vz2vLvcD38IAWbX7uT
         6xCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788533672; x=1789138472;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3pwlsy70YW3qwfiCOdC58N7kJRNRBNA8nQQHxlaBoNo=;
        b=Ez5xc3sqkP8eZnvUZFPk3TC2gyilVcq2czAJ5NUtoiSXauHcfoy8xOLyI7iXEyQYPn
         XEdfsLqJ7+SHwnF5FFIVyVZ3hkX+03HWy36SAW4gcqniGzfpSEshBmrDco/ybNY0bA9C
         pnLVEpRev17AU081GHFL/rr2nPTSDIQlKdVZWcNVAzu8o/1+bNL6plOL+Zw3Aq8b9S95
         0u/dyTUDGjyC6pivEtNCYEP9lUKiUlHdV/EBEL6fqZlcjP2M98mNxlLqcZ4Rlu/AzENB
         ao/CsgEK5AVVSVtcYPry5pqhvzIEiMi7XMVrzJA9Dvn4+9hY6kUcuZTWLx9OjGD8ZnhX
         fOHw==
X-Forwarded-Encrypted: i=1; AKwUvBzB6rjSu3j6oIYWAOkfJB6rzHoOpN4z5CvfbK91ZAGZVE2znalz/YtzxAUUMnLMRigCcV/aQPUrdA==@kvack.org
X-Gm-Message-State: AFuF++kv2TD+ca4eButCQJXcQQzu2lYOvJ0ZGA2kAmOmmW++soB+jpHr
	StzdxjwAnL6/7u9Hry5TBVABle1Xzt8QoPqqTDzCWdky1tqtu42fBzdX
X-Gm-Gg: AYBFou148J2uMls1HoloDQCdXUF7pYzK3d/rkDRI68uNlY3yVPpx4KDvw/lCNuNhNoT
	bynsFiUpFQBRJIucgbQ6e9lehzPXHublmNbOkgrCPVNx+CXhZpkprRVsAsqbVysOWICaUHU2HZ2
	/wqYfD+qU/ZszunGAAuo6agM+t/FzfkuU5JyorBoBtg7fb6i2HTu42WxEHojsA3fTOwODq/4aU8
	e3uIsEdVl+soAEJC8BgH35IO8NufW8wehTTitNhADgl30hsEYM5DTxDa0/KxJlQLYdqkdpW8QoN
	u/asU8V04Bi89nM9qZE433KdZhNyeTJ+8+P7zEu+eH6p7m18J8wumJEPVvG0g+8APdbUeHAT+Eb
	NkBxPm6I4wCMkyrIpCw9ZGycAWFvVly0rBdGoPS9Xm6qJez2r6unb71AxWWdXJs+Iif4uQR37Xm
	bseIbVJ5b1a+XhHCFDpB+A9lfpy/RzUVj/jq5o4FEP7GymBzf+zO9Gtopxf+2kFkoStTqxWMYp/
	g==
X-Received: by 2002:a05:6000:4710:b0:485:8a47:5b83 with SMTP id ffacd0b85a97d-4858a475c60mr4635617f8f.32.1788533672009;
        Fri, 04 Sep 2026 07:54:32 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485885cb03asm6802799f8f.37.2026.09.04.07.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 07:54:31 -0700 (PDT)
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
	sun.jian.kdev@gmail.com,
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next v4 5/7] selftests/bpf: Cover trusted-or-null BTF pointer reads
Date: Fri,  4 Sep 2026 17:53:38 +0300
Message-ID: <20260904145340.40212-6-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904145340.40212-1-tasos.papagiannnis@gmail.com>
References: <20260904145340.40212-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7FC6120003
X-Stat-Signature: r14i7s1tog8ku16kxzmo1mf8bakiyq5m
X-HE-Tag: 1788533673-595590
X-HE-Meta: U2FsdGVkX19u+o/kHAVrVeekC57aUOgDDaSZG9mP/fe+6TSaRIAnI7sY8XB8se32myxLSxp5tF0ftZ1eJ56J++m25o1OAAQ5T4VSgOqYFr8q0EUvjC5f4YdHZdBPr+m03n9UVfUvrMW6vYKWHX+wDjPJ+lc3D8o+iH9VWSzu5V5UwBqq2S8UAOC180JpKeZfVCYHFSWtxApieW4RtrQjl4m6c8gVWgOM3naZrvZv6jPzzQAuwQ1p9GfvMbuHR2Yn+I1mN/InhPKWU1mNp7f3HUvM3xyUd6SPIRIJ11nPZACJE3DhXVQbxlD1/RCnHMQ/hGCBUqY/B/r000d50jWZg/pJnEPC4j48zK1uCRQHlypIvOze1QCkZvzv+x91qZU4eZOqsqSRxkbHLUG4doAO9BODSR4sPW/jfGKcuhFSJwB7NRU81Fp1VEOIN6iryFd2p+cpZouGClPp1Khu4MYu+ib8h2MEwXQ6WM41npt2nFzUYPjXKhFuX3A/NZHWqUp62c5LEhdufPWDE1ZJo08MyHJ0nNW0RT//AAMzj0ngtLS0fQEz17TswOiPcRNH94LMAXN0d5ObBnCw21WizK1mSdmvCaqlMm4fnSKK7zlqIonUIf188dSd76YLhBHn97boeja6LIqmJbRbl7kPdhIJ7kX7RK9EkrwAFqrclBvNdXbBpJBmDP/8OGSHEm3kfPXTra6UsSoJvu1CW8pmzdTKy63HlTykXUVEk/m6OX6cLoNFIXdppE3oKX0Vgw7wnDgWC6qWzDaROsTfK9C72tYE1/4ofr9vRU8al8xKZAw+zfpWD9xR4ZsIorIZVhk7HtlG1g4Eg3xZjCvF4LvBrOZKgbtWUzDvYnFiq+2AIjW7TPFZVABtxy3hWFJ9fcrYYaqYUyL74y6hOzWm+AlBmXcCKV9VEAsCqHc+idNLRxJX8WocOKyqahI3/whqVnxMiaOCQEzlGd8kwGAM9f2qH9i
 Og2+faAS
 sB2VEow8czEcVnwuC+W5KzNuTAoHEJ6oUrZH8wlWcTEN/DlANXyBaHUKE96IR3c0brS6cdLJlwgMdN2t4agikROylWweqMSkhqwEac5Gan/YIkvcZ8xoOyXng4UKpb+gVmjAr0FNu1nxdxTkpJInZ/AxaFbq2z+qLo3X1JpRPXRtmWaEVnQRSrd89e0h40ZHcCFoPfBaZA+C/Rk1ytPQcOM22cSSRZEK8/zoFlELfx9kWBIVlbxg/LKNs/HYwOzhfMkubgakMp87fvCI4rq+laulJZkU4nEXEShMuwqFXiQfx22n0LWElLFKrVia8Ivdid59v+cTeEtI/bNVxji5NGWp0pZ9KO6kILrSc2W4Eg2ugnPg5NyTnI1BXnXmdko1UIfzuSgic/dWnF+HWINX0xX3QarqCD9rLF+JXA8psNK+xkhh2zlC3CXC4z81X0wgyHfAZ0VnJkAnwW/bzB4omJxvB2teB3c1MZLl2ufoM7ucb4ff71wxLZIox0A==
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
 .../selftests/bpf/progs/raw_tp_null_fail.c    | 75 ++++++++++++++++++-
 .../bpf/progs/test_tp_btf_nullable.c          | 45 ++++++++++-
 .../bpf/progs/test_tp_btf_nullable_runtime.c  | 35 +++++++++
 .../selftests/bpf/progs/verifier_lsm.c        | 18 ++++-
 .../selftests/bpf/progs/verifier_vfs_accept.c | 14 ++++
 .../selftests/bpf/progs/verifier_vfs_reject.c | 14 ----
 .../selftests/bpf/test_kmods/bpf_testmod.c    |  1 +
 .../sched_ext/maybe_null_fail_dsp.bpf.c       |  5 +-
 11 files changed, 219 insertions(+), 35 deletions(-)
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
index 0d58114a4955..1ce81bcf1626 100644
--- a/tools/testing/selftests/bpf/progs/raw_tp_null_fail.c
+++ b/tools/testing/selftests/bpf/progs/raw_tp_null_fail.c
@@ -2,23 +2,90 @@
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
index 2380b6cbdead..2da9c2464c25 100644
--- a/tools/testing/selftests/bpf/test_kmods/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/test_kmods/bpf_testmod.c
@@ -651,6 +651,7 @@ bpf_testmod_test_read(struct file *file, struct kobject *kobj,
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


