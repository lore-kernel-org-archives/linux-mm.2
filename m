Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57FD4606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 19:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=byOdch+K
Received: by kanga.kvack.org (Postfix)
	id 7ADFD6B0780; Wed, 21 Oct 2026 15:59:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75E406B0781; Wed, 21 Oct 2026 15:59:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69BD26B0782; Wed, 21 Oct 2026 15:59:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 466D36B0780
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:59:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D726D1205C5
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:59:04 +0000 (UTC)
X-FDA: 85347697008.07.2C375F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 414A5160005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:59:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=byOdch+K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792612743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2xbtEJ7CZhaLOgThbWGPoTOo9rCIMzg+aSiILL7GT3I=;
	b=61d439Klfh6iiioSdfu6fwaDkDFS21kHdUKGIfjgR/7/f6zX1HPIOebmF+dZeeOtEKkVj+
	4gpj9ce3MhFJIJbW7Cn7Q4FZm8ysDCauKYbt/5fZUSna8sW+NcaTx3WBej4tKm8KT/JSID
	79PGEbCKzqy3Rss43yXryQigTrBTllg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=byOdch+K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792612743;
	b=33uxvvWDiRf6J+syLGW2IaCkqrrTcycbtxIScPOPGeHI3rWr5/u+7prqUu162ln6DqwR5p
	LxFE6AwulpYLVCVneGeqBcwDDn71SA1tFVKwjpKPdV8mwcDdJHcF8OB1vIHivaf0H7K7Qd
	MxjYsPXldaOpKjuWMXtplatK3g8Z6mg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CA12660018;
	Wed, 21 Oct 2026 19:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4918E1F000C1;
	Wed, 21 Oct 2026 19:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792612742;
	bh=2xbtEJ7CZhaLOgThbWGPoTOo9rCIMzg+aSiILL7GT3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=byOdch+K6VCuXwjsPgOyFHhwtPhNGXX7T1/mAeqD8RDsWfsK/TLqignAdIMLi1Dwb
	 1J7a81cWkky9XfR+hKPSssRBJJ9bJceSRkqppuKusPW7tXNcGTxebIrWFfQErCXaCz
	 jNTXbxAksL1yFzpkEkn9zKTma+9SBkKeNaEzuVRNeFS/rpMytgAl1X/ujAqIpUMXfk
	 iLv+RUZU9KszPlcdNK5b4BIS/9wsALQYfMwxwtmBqt3wOwdcVqD3S02jm8dELnKfXm
	 pKifqrN9xELz/D0FjfOo8Jfh6qFRsPZw9FSDyd8aftazxzxeQhwVcrFg9YKG8FN66G
	 mn+adC+hNTRNA==
From: Jiri Olsa <jolsa@kernel.org>
To: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>
Cc: bpf@vger.kernel.org,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kselftest@vger.kernel.org,
	Shuah Khan <shuah@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>
Subject: [RFC bpf-next 5/9] selftests/bpf: Add __srcptr kfunc arguments test
Date: Wed, 21 Oct 2026 21:57:54 +0200
Message-ID: <20261021195759.119421-6-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261021195759.119421-1-jolsa@kernel.org>
References: <20261021195759.119421-1-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 414A5160005
X-Stat-Signature: xe71zborhr4ifrds96c711jxjrgz8x14
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792612743-651829
X-HE-Meta: U2FsdGVkX18wLzmJzqaTEcLnX2tLwWWmkOQv5WGXj5U4zQHHx1dFZ9VQsPN6P4S2+5RJbeSdAzqU6lS3n9bA8cczDkjxujzOS26clk5kLmdGVxty+zjbhO6JOYDJAiRhCowQqvRgUQYcVoBx9kn/bg7cEm3YfogZjNLatNJRkaQRxifcj/fWyhzCNnSA2bx8EN8slkms2ejaK+a0z72nSCcjlVBhA20XN0yP0AWainXVO1yZaC4sV0cCbli6V8KodfXV4oDVThL7Iq2EWyMzqOhIBt41RFzUIWhan9WUzRtW3Kp5H3WTAN13h3WqCPGNVHMZUaxAVH/zAj+mdVk170cMjLvv2KuWYxCAfKlCjREa+5I6A0lPVYcrMP/LU20yG98Ivl34DN/JlIpqcCxHollDqdTW8AOhnm05a2LUI8DSM2XwIGVnz5cF0CPZWI+zSnSi+Gc8MCMloCl6ZeJOGVeuQQWTZPNW/uwy+V5cBNTsyNj7bC3jXAufrh6WL85bGMRPdPFJlLu8nMTYdwS0zMRjgT2JsmwAaCLl/EBIEPvi31QPjcq06JJpfOkiR2GHCKu/MX1Hp4D6j2azr37BgrUrjMQMDvtYTWSqN3fK27PVvczhWimdKQH9GRoey+5UY5stXjwMG68xnVq8wjxb1Mx8qxIZhGjyQs5E587NOrQeemMYSHtpFttWl1YLuILP9044H5LcU5JYD3dm9o/vVltVshv1oRxYpw9+85DPbRwRZJAyd2sqQXFFD+tfRj4YhxLnsPR+QmRMqEQ3eUZGLk0TsELjJbpm9lRJ8JiB1ymMVVP4NB+oKwOGwJANQh7f70fESgxHv2/Ly04jMk9TBI/+3X58H1WEPehYIh9Bfcx5IYIFLO7h2PlDh3r4HnYEjdVn8yor2QJYNJtAb9xGB/QVhqCe71QJcSPRh2yuwUepKhQBen5rMHtQY0JNRYr5+Ym65eVXYcQ6mfQBtkw
 01T7xAS/
 FU4qX8z0ndLBA6D89rZKL/Px9tDUPoCGpzxd1THX1/N3uTTBFZIf+I1YWiI3GiDzjy4mmN76zeW2vu5c5EQxsWT2NeMtqaf6tS8zeryZtY50uvJsH5TlIpfCHoceMZhgLQTVQYT0rqKdRx6UZhVeuB+qQFXdWi7v/mtB6i20xe8OsrSogqGZ6srMpF554VikB/9oJj98fqAgCt8d0nWDPTptcZLKz+B+B850wPrU2dpTVcadxJhhzCRNd7OmnxDsVVR/JA9cVl2viiDCO0VF5aGs47KCXOX+hNngJDzINCK+l2nyR1BLb/WgidUhW5MUXBo9wI2TeUDEzfh31bEKa5LRTRiJ6GSwLdU46uhfmdctrtO0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add positive kfunc tests for read-only global and writable stack sources
annotated with __srcptr. Also verify that a read-only source is rejected
when passed to a writable mem_len argument.

Assisted-by: Codex:GPT-6
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/kfunc_call.c  |  2 ++
 tools/testing/selftests/bpf/progs/kfunc_call_fail.c  | 10 ++++++++++
 tools/testing/selftests/bpf/progs/kfunc_call_test.c  | 12 ++++++++++++
 tools/testing/selftests/bpf/test_kmods/bpf_testmod.c |  5 +++++
 .../selftests/bpf/test_kmods/bpf_testmod_kfunc.h     |  1 +
 5 files changed, 30 insertions(+)

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
index 8e6560c31e78..b944e2e186b6 100644
--- a/tools/testing/selftests/bpf/progs/kfunc_call_test.c
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
@@ -5,6 +5,8 @@
 #include "bpf_misc.h"
 #include "../test_kmods/bpf_testmod_kfunc.h"
 
+static const char srcptr_rodata[] = "read-only source";
+
 static struct bpf_spin_lock kfunc_call_lock SEC(".data.A");
 
 SEC("tc")
@@ -208,6 +210,16 @@ int kfunc_call_test_pass(struct __sk_buff *skb)
 	return 0;
 }
 
+SEC("tc")
+int kfunc_call_test_srcptr(struct __sk_buff *skb)
+{
+	char stack_data[] = "read-write source";
+
+	bpf_kfunc_call_test_srcptr(srcptr_rodata, sizeof(srcptr_rodata));
+	bpf_kfunc_call_test_srcptr(stack_data, sizeof(stack_data));
+	return 0;
+}
+
 struct syscall_test_args {
 	__u8 data[16];
 	size_t size;
diff --git a/tools/testing/selftests/bpf/test_kmods/bpf_testmod.c b/tools/testing/selftests/bpf/test_kmods/bpf_testmod.c
index 6380f52f4dd2..5d72f94a8912 100644
--- a/tools/testing/selftests/bpf/test_kmods/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/test_kmods/bpf_testmod.c
@@ -1024,6 +1024,7 @@ BTF_ID_FLAGS(func, bpf_kfunc_arena_args5_test)
 BTF_ID_FLAGS(func, bpf_kfunc_arena_stack_arg_test)
 BTF_ID_FLAGS(func, bpf_kfunc_arena_mixed_test)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test_mem_len_pass1)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test_srcptr)
 BTF_ID_FLAGS(func, bpf_kfunc_dynptr_test)
 BTF_ID_FLAGS(func, bpf_kfunc_nested_acquire_nonzero_offset_test, KF_ACQUIRE)
 BTF_ID_FLAGS(func, bpf_kfunc_nested_acquire_zero_offset_test, KF_ACQUIRE)
@@ -1527,6 +1528,10 @@ __bpf_kfunc void bpf_kfunc_call_test_mem_len_pass1(void *mem, int mem__sz)
 {
 }
 
+__bpf_kfunc void bpf_kfunc_call_test_srcptr(const void *src__srcptr, int src__sz)
+{
+}
+
 __bpf_kfunc void bpf_kfunc_call_test_mem_len_fail1(void *mem, int len)
 {
 }
diff --git a/tools/testing/selftests/bpf/test_kmods/bpf_testmod_kfunc.h b/tools/testing/selftests/bpf/test_kmods/bpf_testmod_kfunc.h
index 3b810f1e438f..919c4c450ef1 100644
--- a/tools/testing/selftests/bpf/test_kmods/bpf_testmod_kfunc.h
+++ b/tools/testing/selftests/bpf/test_kmods/bpf_testmod_kfunc.h
@@ -198,6 +198,7 @@ void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p) __ksym;
 void bpf_kfunc_call_test_ref(struct prog_test_ref_kfunc *p) __ksym;
 
 void bpf_kfunc_call_test_mem_len_pass1(void *mem, int len) __ksym;
+void bpf_kfunc_call_test_srcptr(const void *src__srcptr, int src__sz) __ksym;
 __u64 bpf_kfunc_arena_arg_test(__u64 *val__arena) __ksym;
 __u64 bpf_kfunc_arena_cap_test(__u64 *val__arena) __ksym;
 __u64 bpf_kfunc_arena_cap_nullable_test(__u64 *val__arena__nullable) __ksym;
-- 
2.54.0


