Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F3ED606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 10:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PvrlS2RW
Received: by kanga.kvack.org (Postfix)
	id 829746B05B7; Thu,  5 Nov 2026 05:24:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DB966B05B8; Thu,  5 Nov 2026 05:24:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A3796B05B9; Thu,  5 Nov 2026 05:24:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 477126B05B7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:24:31 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C5DB1C06DA
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:24:30 +0000 (UTC)
X-FDA: 85400681100.26.3AA6BF9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 32A75140002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:24:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PvrlS2RW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793874269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aWC1fpeZM+QP/64/LlbIQvYUrFOSEHGeQ7yKHlmi7Q4=;
	b=f5/owFNivHAmio603pSBxSZivhVoIFxL5aeR+xQ687RdzCDlTSnfTYy0cCu0YTkRaF2BB0
	7TyqbDiiV1zb3cMmcPhim3Eyvb4KIGNanGZC5p8dixaKX72SK6umXuLUWvwhWg6vBEXRN4
	q9E7sDefxdjSPrJIho3YMiRMkD4o+80=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PvrlS2RW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793874269;
	b=Pn1mASCcJNCN99ciOPN80eSPZWszwFWIeycX7Z887tSt5m3UqVtRvd7ftGWVQlOi9IA5Gc
	tJHhCzZ5wobsMPQXNUtPRhRFVkXlcI1s8jQrS/Hu9bFH+EVL2/gOnBGWXVciTKRT4l9woA
	cKxp0D5cu0OD1x0Ngey+KKQeclpulOI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 89CD542DD0;
	Thu,  5 Nov 2026 10:24:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB141F000C1;
	Thu,  5 Nov 2026 10:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793874268;
	bh=aWC1fpeZM+QP/64/LlbIQvYUrFOSEHGeQ7yKHlmi7Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PvrlS2RWgoBlYHhRbQrzIuQyJVAFuCu+bZv9Cfk800sCPW8P+l4+/Yz0JFzGfU5pQ
	 zMveaNA84cLq42MOcPiqkms5RcfFvLWJqrIGNO23P1AVPilD2XIKjbQtH3xZcvGZQY
	 0WY8UNzV0GwPzVzV3RzOnbeiwTiWxFaziOCIJlJebLwtR4E3ROWmxxCe9h7Jsor361
	 Rc48aftWaHsPmDYJVkBzl3JlDaAtXaf9Pbdve3awJTwgW2tSBiT05/w1uJ8k3GgZUf
	 E5xVdoe4XqOzLs48iqhlw36NdIniUtjH4NzJtZNfoN1Ukhkt59TKQLZInXlvOu8Ji9
	 nTkFjnQK88bGg==
From: Jiri Olsa <jolsa@kernel.org>
To: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Federico Di Pierro <nierro92@gmail.com>
Subject: [PATCHv3 bpf-next 4/8] selftests/bpf: Test const kfunc memory arguments
Date: Thu,  5 Nov 2026 11:23:38 +0100
Message-ID: <20261105102343.311331-5-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261105102343.311331-1-jolsa@kernel.org>
References: <20261105102343.311331-1-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 32A75140002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: fn6we6scjrcbopnoq4a3z37i746jbn6y
X-HE-Tag: 1793874269-473026
X-HE-Meta: U2FsdGVkX1+gF29Baagin7o1i3zvsLfecgmJLKS0Ch19AfLioYnAGjLs6WyRmMiFJfnJuzMR0bB+vi16uL7RxOntcC6WQL5VWURXEXFRL+zorZP8qmKeSqk74neclXA3eq5m0S7+azl6o8dupsbdv58FJPur0dkhVD/GV3fqQV2QeBsL7IT1+WeRC/giCTD8cZR3Pabdb/p/o8mmHsa7ZYtNMxwaGefIFgnHUccrjPYHOwfw/L8QVR5X4nXUOYoIFBI285Bcj5PNldsFMly9+8WKGYgmRY/X3ky9I7u8Z8cDAXLj/k/r74a+dd8G9f5uOrBoLXJwfhCU2mjaQSROhopYnR5F33fvq0n/5ODiQLM2lwQeUPOVkwU2CXJbjDj0xVePZrc7X4U5A75Moxkler10d36+PIm1OjXuN5m9E4pGV+bZAIfpRjQ7iUy849SA+J3Hn99JKqXTk3yflx7smeYORhyfwYqVOYWBwb9PaIoo70WG8j1rBZ0i5cYmQkamCFmjna0kPQXV6lhAadDQW1eVKZBlzpNxDQpdcl4r7Q3G7d69lUcS/gc7isQTs6mY+/LeqxFMCahuPJM7hMCf6o+8z+ppSJPeaqkg95yM2Xy74Vs6SxMxJZBqozsuTl7BWl6loxJTquA2rAEalu4/QFglHRLXTObUAbfRCaD6/ksPAlHtW07tpxMyFEULVObLPJaPqmaBKi86zRLZ2++E2NMh8lpVilrUi1bixVRADoHb6w/hVgw0sA42pFkkX5RTprFZjMrxXLy0KEq6ln49Rp+joS/8U1iAyIqJYDw6/AlDSDK0nhuCMo4O1djy9iu8ZbJZvlP03BJlGS0KF5CqFJY3109DrgmPQDOVuEJRiie4oc9ugt16X7ADLKFAoCT5fIcbURjo6blurrn6sznQy42OiGK4OPkW7GRwCcDRCbftevJibHbgOCO++3vB9C/IwRxaFheOCyYa4jjewlN
 dkG+jl6b
 Q8DmLArUQNLrOAYu2KDbrICr/qsmmE1pAPGdcYlWgDVGm5nnwZRTTxzm74YpPFCFxmZbFkUV56lUZbXT5AKs2LiGdbU0mlWfclQ+8bN+wjvGIMICkkdqicxSi2Kt8RYh9MOX7YqCCakgrX1qQd2zQ1/exnpVWBz+whB+sHFrZj6+Ywm0stxJk6Gp29kvrFucT/9bcT2oaI2yikRtZSnXjvwE5HDxSlQ7s3PvaEpRGhKA9fSv2anO29fMgWQD3nlY8GRiMHYhiBW66qvzDSeEOc0pnItdrr09YFmR1rPyqOHJ0iUagnwQxHgIHVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Verify that const kfunc arguments accept read-only global data,
writable stack data, and const scalar structs. Check that read-only
data is rejected when passed to a writable memory argument.

Assisted-by: Codex:GPT-6
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../testing/selftests/bpf/prog_tests/kfunc_call.c  |  2 ++
 .../testing/selftests/bpf/progs/kfunc_call_fail.c  | 10 ++++++++++
 .../testing/selftests/bpf/progs/kfunc_call_test.c  | 14 ++++++++++++++
 .../testing/selftests/bpf/test_kmods/bpf_testmod.c | 10 ++++++++++
 .../selftests/bpf/test_kmods/bpf_testmod_kfunc.h   |  2 ++
 5 files changed, 38 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
index 0063e60d6f2f..f2152591982b 100644
--- a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
+++ b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
@@ -63,6 +63,7 @@ static struct kfunc_test_params kfunc_tests[] = {
 	 */
 	SYSCALL_NULL_CTX_FAIL(kfunc_syscall_test_fail, -EINVAL, "processed 4 insns"),
 	SYSCALL_NULL_CTX_FAIL(kfunc_syscall_test_null_fail, -EINVAL, "processed 4 insns"),
+	TC_FAIL(kfunc_call_test_mem_len_fail_readonly, 0, "write into map forbidden"),
 	TC_FAIL(kfunc_call_test_get_mem_fail_rdonly, 0, "R0 cannot write into rdonly_mem"),
 	TC_FAIL(kfunc_call_test_get_mem_fail_use_after_free, 0, "invalid mem access 'scalar'"),
 	TC_FAIL(kfunc_call_test_get_mem_fail_oob, 0, "min value is outside of the allowed memory range"),
@@ -82,6 +83,7 @@ static struct kfunc_test_params kfunc_tests[] = {
 	TC_TEST(kfunc_call_test5_asm, 0),
 	TC_TEST(kfunc_call_test_ref_btf_id, 0),
 	TC_TEST(kfunc_call_test_get_mem, 42),
+	TC_TEST(kfunc_call_test_const_mem, 0),
 	SYSCALL_TEST(kfunc_syscall_test, 0),
 	SYSCALL_NULL_CTX_TEST(kfunc_syscall_test_null, 0),
 	TC_TEST(kfunc_call_test_static_unused_arg, 0),
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_fail.c b/tools/testing/selftests/bpf/progs/kfunc_call_fail.c
index 7e93f7fb1329..bef956d3f89e 100644
--- a/tools/testing/selftests/bpf/progs/kfunc_call_fail.c
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_fail.c
@@ -4,6 +4,8 @@
 #include <bpf/bpf_helpers.h>
 #include "../test_kmods/bpf_testmod_kfunc.h"
 
+static const char kfunc_mem_rodata[] = "read-only data";
+
 static struct bpf_spin_lock kfunc_call_lock SEC(".data.A");
 
 SEC("?tc")
@@ -47,6 +49,14 @@ int kfunc_syscall_test_null_fail(struct syscall_test_args *args)
 	return 0;
 }
 
+SEC("?tc")
+int kfunc_call_test_mem_len_fail_readonly(struct __sk_buff *skb)
+{
+	bpf_kfunc_call_test_mem_len_pass1((void *)kfunc_mem_rodata,
+					  sizeof(kfunc_mem_rodata));
+	return 0;
+}
+
 SEC("?tc")
 int kfunc_call_test_get_mem_fail_rdonly(struct __sk_buff *skb)
 {
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test.c b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
index 8e6560c31e78..4f4a6713aa6e 100644
--- a/tools/testing/selftests/bpf/progs/kfunc_call_test.c
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
@@ -5,6 +5,9 @@
 #include "bpf_misc.h"
 #include "../test_kmods/bpf_testmod_kfunc.h"
 
+static const char kfunc_const_data[] = "read-only source";
+static const struct prog_test_pass1 kfunc_const_struct = { .x0 = 1 };
+
 static struct bpf_spin_lock kfunc_call_lock SEC(".data.A");
 
 SEC("tc")
@@ -208,6 +211,17 @@ int kfunc_call_test_pass(struct __sk_buff *skb)
 	return 0;
 }
 
+SEC("tc")
+int kfunc_call_test_const_mem(struct __sk_buff *skb)
+{
+	char stack_data[] = "read-write";
+
+	bpf_kfunc_call_test_const_mem(kfunc_const_data, sizeof(kfunc_const_data));
+	bpf_kfunc_call_test_const_mem(stack_data, sizeof(stack_data));
+	bpf_kfunc_call_test_const_struct(&kfunc_const_struct);
+	return 0;
+}
+
 struct syscall_test_args {
 	__u8 data[16];
 	size_t size;
diff --git a/tools/testing/selftests/bpf/test_kmods/bpf_testmod.c b/tools/testing/selftests/bpf/test_kmods/bpf_testmod.c
index 76fbe64755ef..41ff36f0ca77 100644
--- a/tools/testing/selftests/bpf/test_kmods/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/test_kmods/bpf_testmod.c
@@ -1049,6 +1049,8 @@ BTF_ID_FLAGS(func, bpf_kfunc_arena_args5_test)
 BTF_ID_FLAGS(func, bpf_kfunc_arena_stack_arg_test)
 BTF_ID_FLAGS(func, bpf_kfunc_arena_mixed_test)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test_mem_len_pass1)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test_const_mem)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test_const_struct)
 BTF_ID_FLAGS(func, bpf_kfunc_dynptr_test)
 BTF_ID_FLAGS(func, bpf_kfunc_nested_acquire_nonzero_offset_test, KF_ACQUIRE)
 BTF_ID_FLAGS(func, bpf_kfunc_nested_acquire_zero_offset_test, KF_ACQUIRE)
@@ -1552,6 +1554,14 @@ __bpf_kfunc void bpf_kfunc_call_test_mem_len_pass1(void *mem, int mem__sz)
 {
 }
 
+__bpf_kfunc void bpf_kfunc_call_test_const_mem(const void *mem, int mem__sz)
+{
+}
+
+__bpf_kfunc void bpf_kfunc_call_test_const_struct(const struct prog_test_pass1 *p)
+{
+}
+
 __bpf_kfunc void bpf_kfunc_call_test_mem_len_fail1(void *mem, int len)
 {
 }
diff --git a/tools/testing/selftests/bpf/test_kmods/bpf_testmod_kfunc.h b/tools/testing/selftests/bpf/test_kmods/bpf_testmod_kfunc.h
index e9902e651d72..0a7df1798603 100644
--- a/tools/testing/selftests/bpf/test_kmods/bpf_testmod_kfunc.h
+++ b/tools/testing/selftests/bpf/test_kmods/bpf_testmod_kfunc.h
@@ -203,6 +203,8 @@ void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p) __ksym;
 void bpf_kfunc_call_test_ref(struct prog_test_ref_kfunc *p) __ksym;
 
 void bpf_kfunc_call_test_mem_len_pass1(void *mem, int len) __ksym;
+void bpf_kfunc_call_test_const_mem(const void *mem, int mem__sz) __ksym;
+void bpf_kfunc_call_test_const_struct(const struct prog_test_pass1 *p) __ksym;
 __u64 bpf_kfunc_arena_arg_test(__u64 *val__arena) __ksym;
 __u64 bpf_kfunc_arena_cap_test(__u64 *val__arena) __ksym;
 __u64 bpf_kfunc_arena_cap_nullable_test(__u64 *val__arena__nullable) __ksym;
-- 
2.43.0


