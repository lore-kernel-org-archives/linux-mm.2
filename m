Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B5E0606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 21:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LMlAPzA/
Received: by kanga.kvack.org (Postfix)
	id 97FDC6B05BA; Thu, 29 Oct 2026 17:26:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 956FA6B05BB; Thu, 29 Oct 2026 17:26:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 894E86B05BC; Thu, 29 Oct 2026 17:26:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 68D496B05BA
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:26:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B2C5140563
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:26:39 +0000 (UTC)
X-FDA: 85376948118.26.5C66AF2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 171C41C000A
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:26:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LMlAPzA/";
	spf=pass (imf18.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793309198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5blMgoBP0rICIuH/UYufNrjnwQHz9NNj7WSk+4g5PdA=;
	b=vSepnGuZahL/2o3F6qsDhQ6x7dvMemqMa+hGzKJZg12Ccgd8WZfNJOJ9HI5oDSSksqnWPj
	f0+Tl+uLqr/FgllYknHAZPuy9nFGRAs1hLJQ6Pv65rpLRZAINsj9M/sl/906Q1856sLtrC
	CtS41h/fysKWHYL8VTmMGjmlSd/ixhA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793309198;
	b=tJmIqsD9C2Xlxz8zzsHpqpba2lvsXpwSGPleAzifiyt9dnrfHTAu1UcXiVOZ08IG5+4Y29
	+Xl9l01zIIHTf0uEf8uRypHMawIQNcyX2o1IiG7TwGUsb2VvL8dHoKBJdqjp3CPen5luz9
	kHT6YT6MvCO3RCC1zgiIgiCQsaCnWxA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LMlAPzA/";
	spf=pass (imf18.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 996DF600C8;
	Thu, 29 Oct 2026 21:26:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BAE01F01816;
	Thu, 29 Oct 2026 21:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793309197;
	bh=5blMgoBP0rICIuH/UYufNrjnwQHz9NNj7WSk+4g5PdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LMlAPzA/v5n9cD2RIi/AaDnxrFqTzT2B1cWbHqCSg2ea4FAkuUNaXOyDBj5fmdJOT
	 2/GupRcRcgyRf0Avznr31ciy3JyLx1es/iu5FDR4G7xVw7UPga5yMsun/qt/eQV9TQ
	 cHLriz2cvO+582oJSWS6vkWmV/Ca5NrguJqwFlbfYV0cyNH+JRFEJTB4ZBSAxhChJi
	 nLbZZ7RSXLz1tLxd9XO0fcBuqlkZmsPJakK2jr3K3DFeSrpuyQMNuzKX6PHQ/Ddvcm
	 1947+Bp2SuvpGbNpM3nIY95G/0vpu3jETDi+UA4oVE/y/EQMF9FWCAGzO78EBhGAdG
	 madVkYDQuCN4w==
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
Subject: [PATCH bpf-next 4/8] selftests/bpf: Test __srcptr kfunc arguments
Date: Thu, 29 Oct 2026 22:25:47 +0100
Message-ID: <20261029212551.56964-5-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261029212551.56964-1-jolsa@kernel.org>
References: <20261029212551.56964-1-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 171C41C000A
X-Stat-Signature: f8u1er4w4cduafajy1oznxof7mzinaea
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793309197-4612
X-HE-Meta: U2FsdGVkX18KBpQaPcAbnusj7O6dBBCCV4m6FWKUlS4trPq7qhqsvZolpJHSN1RKecKXPK6cstvEVlR9uLrpenRNlsjEhLEg1mRwrAzkaoeVQ6PzblGAX7ApVRVWlrIW5/sUlz9i5PLAqxRCaGxpJcjw85JJnqOyMr7zp2dscUOW1ZipIpb9POMy+l577VlZw9OT3USQP7tHMGT/nYAoChPCx4XoZF8hkNor6uUAoRvqAu/ouUUDhrqkOv5voiBpoHy4iRtHaLUb8ZUyAQNB8Nh95M0jDSyZbk6H7dJ6HbY0wO8tKhaLAmQdY24uDWyPydeUW2MRLtUW+zJBmo6NFKvcRPgNOAQnhFYEYg59iCEfaan7TqOIV1c4dVAEEWLhPSOlyj7YZEzIKQ1O+QoFT56sfMjkTvPpw9mrMYd+tvw8PREZZQntaeA+ejvC8ch7iN8b42G03WWbdzDsPPywqUnzajPe8yekCpgcTOzVZYx9tZRhN0l4R3qRd3Icqq+SVXW8JpJjZLGyyeJs1ao75UWpowBnu0vwc49GOQu/C+jTWUpOKhT1x1mXlSxtai3L6xF5lGa32RYsxvu9TYA1bcvtptCVuH76i0nnv9MW/F5jNIC8JXDMLJu63G5OpCSIzUoFyhOwXyuw5enkOZqnvCG8023Tl+rxJDVoW3Gif5pYkKEDWzTTYyUhtkzoLWA99ktrazAl/x367JlqAVcYKB97GicAaoUiCQhHnrXoTGpPKxqBgSlNREOOvc5/95FlGyA4YYgfHQm+pmGEkCQtI2QLHkbvqJh1whZ7VaAtCkVGNiXc1cuouCCvethMn9Q9gbnqc/bSW3XyTYtQO5ScpfGOb2Jo0ahgPo6aUI4CrhXyq2u4EZL4e7eVnqrmotdAS6m2MPUiJWTT9pbEagKDJCH83oE0fu3N7/0qtag9geJmvy4caJ+B9BTz7JwIe/mjYJPBeEYDz5w/znb/rg5
 WoyXPAe5
 SYy1trmVjMeGB91NJqgOmMeV//2HIAuOBvnozy4iE8uyzcQShrhrF8+NBzB8SebwFyRS1fK5DH8QPOAbEAXB7V2eZV7asyW0jrVVoYmeeSVScwzpwPcPuZNhJtCzKfpDJP+MpHhAFSpLDyFSsa0jFxvWS2ht2Y+2c0RGkgAqsIchN3Q7Fk99kADZB2zDfCRLQU1KJQtyy33USvvlPAfeh9XhnaU/LN5pEH0bK2IYlfkmbIJhkVnqTwe77HkQ+kHEinX6VK3gVBWPRl9vuIdbKUFi+7q5JcJPiJBT+HRSdI/hvVuyj2vHQDvhLqydU8QmXckt7KgBq3kOhbM91Igs4XeFAy556SlUS6Hin
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Verify that __srcptr kfunc arguments accept read-only global data,
writable stack data, and a pointer to a read-only struct of scalars.

Also verify that read-only data is rejected when passed to a kfunc
argument that requires writable memory.

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
index 0063e60d6f2f..9b832c5961f5 100644
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
+	TC_TEST(kfunc_call_test_srcptr, 0),
 	SYSCALL_TEST(kfunc_syscall_test, 0),
 	SYSCALL_NULL_CTX_TEST(kfunc_syscall_test_null, 0),
 	TC_TEST(kfunc_call_test_static_unused_arg, 0),
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_fail.c b/tools/testing/selftests/bpf/progs/kfunc_call_fail.c
index 7e93f7fb1329..1ab85faaf8db 100644
--- a/tools/testing/selftests/bpf/progs/kfunc_call_fail.c
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_fail.c
@@ -4,6 +4,8 @@
 #include <bpf/bpf_helpers.h>
 #include "../test_kmods/bpf_testmod_kfunc.h"
 
+static const char mem_len_rodata[] = "read-only data";
+
 static struct bpf_spin_lock kfunc_call_lock SEC(".data.A");
 
 SEC("?tc")
@@ -47,6 +49,14 @@ int kfunc_syscall_test_null_fail(struct syscall_test_args *args)
 	return 0;
 }
 
+SEC("?tc")
+int kfunc_call_test_mem_len_fail_readonly(struct __sk_buff *skb)
+{
+	bpf_kfunc_call_test_mem_len_pass1((void *)mem_len_rodata,
+					  sizeof(mem_len_rodata));
+	return 0;
+}
+
 SEC("?tc")
 int kfunc_call_test_get_mem_fail_rdonly(struct __sk_buff *skb)
 {
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test.c b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
index 8e6560c31e78..fc862fce3f2f 100644
--- a/tools/testing/selftests/bpf/progs/kfunc_call_test.c
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
@@ -5,6 +5,9 @@
 #include "bpf_misc.h"
 #include "../test_kmods/bpf_testmod_kfunc.h"
 
+static const char srcptr_rodata[] = "read-only source";
+static const struct prog_test_pass1 srcptr_struct_rodata = { .x0 = 1 };
+
 static struct bpf_spin_lock kfunc_call_lock SEC(".data.A");
 
 SEC("tc")
@@ -208,6 +211,17 @@ int kfunc_call_test_pass(struct __sk_buff *skb)
 	return 0;
 }
 
+SEC("tc")
+int kfunc_call_test_srcptr(struct __sk_buff *skb)
+{
+	char stack_data[] = "read-write source";
+
+	bpf_kfunc_call_test_srcptr(srcptr_rodata, sizeof(srcptr_rodata));
+	bpf_kfunc_call_test_srcptr(stack_data, sizeof(stack_data));
+	bpf_kfunc_call_test_srcptr_struct(&srcptr_struct_rodata);
+	return 0;
+}
+
 struct syscall_test_args {
 	__u8 data[16];
 	size_t size;
diff --git a/tools/testing/selftests/bpf/test_kmods/bpf_testmod.c b/tools/testing/selftests/bpf/test_kmods/bpf_testmod.c
index 6380f52f4dd2..87967c7236a7 100644
--- a/tools/testing/selftests/bpf/test_kmods/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/test_kmods/bpf_testmod.c
@@ -1024,6 +1024,8 @@ BTF_ID_FLAGS(func, bpf_kfunc_arena_args5_test)
 BTF_ID_FLAGS(func, bpf_kfunc_arena_stack_arg_test)
 BTF_ID_FLAGS(func, bpf_kfunc_arena_mixed_test)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test_mem_len_pass1)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test_srcptr)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test_srcptr_struct)
 BTF_ID_FLAGS(func, bpf_kfunc_dynptr_test)
 BTF_ID_FLAGS(func, bpf_kfunc_nested_acquire_nonzero_offset_test, KF_ACQUIRE)
 BTF_ID_FLAGS(func, bpf_kfunc_nested_acquire_zero_offset_test, KF_ACQUIRE)
@@ -1527,6 +1529,14 @@ __bpf_kfunc void bpf_kfunc_call_test_mem_len_pass1(void *mem, int mem__sz)
 {
 }
 
+__bpf_kfunc void bpf_kfunc_call_test_srcptr(const void *src__srcptr, int src__sz)
+{
+}
+
+__bpf_kfunc void bpf_kfunc_call_test_srcptr_struct(const struct prog_test_pass1 *p__srcptr)
+{
+}
+
 __bpf_kfunc void bpf_kfunc_call_test_mem_len_fail1(void *mem, int len)
 {
 }
diff --git a/tools/testing/selftests/bpf/test_kmods/bpf_testmod_kfunc.h b/tools/testing/selftests/bpf/test_kmods/bpf_testmod_kfunc.h
index 3b810f1e438f..6de080682618 100644
--- a/tools/testing/selftests/bpf/test_kmods/bpf_testmod_kfunc.h
+++ b/tools/testing/selftests/bpf/test_kmods/bpf_testmod_kfunc.h
@@ -198,6 +198,8 @@ void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p) __ksym;
 void bpf_kfunc_call_test_ref(struct prog_test_ref_kfunc *p) __ksym;
 
 void bpf_kfunc_call_test_mem_len_pass1(void *mem, int len) __ksym;
+void bpf_kfunc_call_test_srcptr(const void *src__srcptr, int src__sz) __ksym;
+void bpf_kfunc_call_test_srcptr_struct(const struct prog_test_pass1 *p__srcptr) __ksym;
 __u64 bpf_kfunc_arena_arg_test(__u64 *val__arena) __ksym;
 __u64 bpf_kfunc_arena_cap_test(__u64 *val__arena) __ksym;
 __u64 bpf_kfunc_arena_cap_nullable_test(__u64 *val__arena__nullable) __ksym;
-- 
2.54.0


