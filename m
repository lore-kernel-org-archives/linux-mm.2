Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8F10606A329
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LhgrJq3L
Received: by kanga.kvack.org (Postfix)
	id DA1746B05B8; Tue,  3 Nov 2026 03:00:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D786D6B05B9; Tue,  3 Nov 2026 03:00:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8EAF6B05BA; Tue,  3 Nov 2026 03:00:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C21F6B05B8
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:00:04 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9E8D780334
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:00:03 +0000 (UTC)
X-FDA: 85393059486.14.F82A5E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id C7BAF10000E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:00:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LhgrJq3L;
	spf=pass (imf05.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793692801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aWC1fpeZM+QP/64/LlbIQvYUrFOSEHGeQ7yKHlmi7Q4=;
	b=CQpcoV6kjEj12v6wB4RGmdO7zjtZloLioxt58+jpPAsBVuGScE66yvjHbzqyIMjszBVnkx
	kjMMOxyk/KVuncoQoXjUlxlKBEE6CQdVXKTcbkSI7PwQ9r7GdiX/YywUq4tZeSy0muWFz2
	hp/KJ7/oZzCPHWXLZaJzPKkOZwNWw7I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793692801;
	b=Vh4QrFfjr8DD8f6nDdarmEgAvwGuOXV/hFFU6cQl3kXSAIEL0ABRenC/WvIQatkn+JOWu6
	N2a1NVUec+2p9/3tYSqR1knhZq9E3rZgXYqG+/4Rnirnx1/QkWC9WkY2yNOzNXKfLx7V9H
	5NrURIhEm5pgybqm0rIMWTowZL9p2GA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LhgrJq3L;
	spf=pass (imf05.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1653740BE7;
	Tue,  3 Nov 2026 08:00:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0491A1F000C1;
	Tue,  3 Nov 2026 07:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793692801;
	bh=aWC1fpeZM+QP/64/LlbIQvYUrFOSEHGeQ7yKHlmi7Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LhgrJq3Lq6X3P/irxArdBkEOP1l46e/U5W/V+lvXpkBKvL3zyLBFe9p3tB2NSEKSl
	 yazFsLx/fur+/hQM3kHlHfDA9v8sHNvR6cRJmc77AWV7Upvkb78uyJtqsbxZIf5gzw
	 0lu4axk7HAPsWxqX5ucfkxNgl1tpdPiM2szhA5/FBywItXnmPdNLEWSZ9ay2Ko6SE2
	 dMb2gAUbUHQOoUeyVT+VulTtEhRLd9ci5miucT72lkrzDYi9q3k27NLixNNkyJrTLp
	 MonutnN2PQMA0rOAZvWU8htC/2WaKOv8lbKNEnJKKEzXNtDfpqy4hfUYbo8w1E19kd
	 sZvzrTX6iY7HQ==
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
Subject: [PATCHv2 bpf-next 4/8] selftests/bpf: Test const kfunc memory arguments
Date: Tue,  3 Nov 2026 08:59:11 +0100
Message-ID: <20261103075916.100050-5-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103075916.100050-1-jolsa@kernel.org>
References: <20261103075916.100050-1-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C7BAF10000E
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: oc3khw94pjbhesnqiobh9nar33uy4gc6
X-Rspam-User: 
X-HE-Tag: 1793692801-848972
X-HE-Meta: U2FsdGVkX18Fr4RaLHpwtGsXVzA7qxsvUjFNfFlXQe2mRjobWaEOHhIDs6XojviDOHX4m372bY592rXCd2nVrAHlpo77INqSM7p87b8sMJanysdQMjus/jkRAcKleRz67Ov1zfSVsmUqUTPsdBmJxp79uW0hINv65TJJk5G4+oYeDjrtHaBjsPXZ230iG+zKdiLyyohTEJ19EMmAQeO2rZ+aq9+vM+8jgc3k4ythI0EikAdekmstb6+5YGHP54U7mxrI8Qu/AoMysVvw8gycZ27prc2sLwqcF+59lq5HGyBtprp2ZNxUhqhG8jy4/zNggco9fxeipL4z+DdVg0zaKxivWw6q41YI/9KpaukdGnePS045ekra7KTyHGCKsMVvtxh+5mRfe07xK/DQuuEtPaSbfbUiunr2qKNeO9VYPKcAY5YlgkbyjN1lC+Lut+ipP0Sz9SaaVvN/yDgrA6gLIQk3XFuiEYZUE7dP1i0aAGv6bHvXJpb5PXtIrcRFrk/dr2wcToX3ndVVqilpTKS4ES8ddaKtSQTGYlkl2ghLKx1Wspb7QFMayJJNDIndRD0DKXqVbTy6d+Y+yTrz1vxnbpXenTU01bTkWuTwX/a8hLmcypfDy2hBJzwSM+b+S+ZMhfY7YtRFwv5jRYnXKDxCCbXPeL3v4LMB4dDnw0wKCXT1P/ukktXMTu3AVc6thAhR5WKzDxAeGUAxdCEnvQHM8ghY97DjzM+B/0xOsZUE7VuzOpohbRZgnjBSDusVPVoD191yF3pft7uEz3PlPxKUUK0Gw4GtwDWGH508J6Ugn7e0u9XyJJ1oQSpCipMcWaNlb6xA0bCCNEjtpjyRxMwv72Nbpy42USzNEe9q2HRZD8jsFMtrhmwrOjfwLrGzbwyTo4iqrtyuKpUgscfKjJ6iD7g4q0Fjjmf3t/AxyajR8bsIODUwkb55gr8iNAVMEPkI2wrzqmYinvrMD53cbn9
 KxI4Cbvr
 SYWS8hzLVD2oKbA12XuaKN6eaXyW8N7dz+2az1Kd4waM4hffL/WcZ+njiUtLu1+ZbwockF5bAMLW4jq4MN2ZeMFwUqVNGni5dRt+m5nwJNTfw+1iDcOk4HWdqGQK3OS/UAlKjwPnQOLBXTDqUYxfubfAW3JO0+QlUJ7LeTSpunjbSC8DFDWWxKN9bH9dLE+Q7ao10cJ5XKqbHDpZHQ+0XdQggZLsg4ee6IZZGyUfisUSikuqP9B0MiHaxI0DtAYVWhyElncqXA1HQRKNoBKwySwJcL9akalxCopLHHMMq8J+AGpyP6Q3hzaPumg==
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


