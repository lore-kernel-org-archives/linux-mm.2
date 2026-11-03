Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2AD6606A32C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nOH2eOWE
Received: by kanga.kvack.org (Postfix)
	id 1BAB86B05C3; Tue,  3 Nov 2026 03:00:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 192B06B05C4; Tue,  3 Nov 2026 03:00:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05AD16B05C5; Tue,  3 Nov 2026 03:00:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DA9586B05C3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:00:44 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6F357C0330
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:00:44 +0000 (UTC)
X-FDA: 85393061208.15.B7120BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id CE23D80004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:00:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nOH2eOWE;
	spf=pass (imf30.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793692842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DYVUfZuQMkuBt7AZL5iA2lw2horQigkF228UMKVfekA=;
	b=oMOm0sV4rOUxgeD3RQbht5EyPN/jbOzKM7BMBjFRk++rqx4TNhRYIw4Ov7YB9+HhD/6ePg
	5egtq8IiCLmjQRqc3FMy4qSOmUfetceEBosaWQQje0HCjiEDo8Q/LnOfttWVjtfYMtn8uY
	dy384z/9IAUBATInjm6x/xzpwwCzuWg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nOH2eOWE;
	spf=pass (imf30.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793692842;
	b=UZLF3Rz65xLDFPB0zon6bVLKCakmP8tM1zTj/qWEcgUWBdXrPYwCeJpjPFmoBmygqiG8iF
	zGdhNRtDLyfjHcCeXfPtzbbh7UOwmS5U0Agd/m2M23ZhUM97/U2Dv+MmK4an0R+/MkxkQx
	7rKKonWE2T7EO5CI43ORNPyx7u8xI/w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 67D01605F0;
	Tue,  3 Nov 2026 08:00:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4481F00919;
	Tue,  3 Nov 2026 08:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793692842;
	bh=DYVUfZuQMkuBt7AZL5iA2lw2horQigkF228UMKVfekA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nOH2eOWEJb31W/047O+kYr+GGqBZ1qW3294IN4JqJS4cWBvOV6ZZnx5+gp+RC3oS3
	 VMYqLYfAVVwo64imXmWkg9CLqMLuBDzioehxD05Y0zQ/IGFGWGivGwESQIVwE3DNws
	 4TiXdolzQW07x0rRnIVyCYrJqHh/yiM4mR2AMdirs5Jl4CumUBOzJMvlWT6zYZVWoH
	 YWbfAB23gUng9lGd3p6dNVGqaUkOq1vB0HdlU9rXimkgqmBPivvKngEzqACyT7QTS7
	 ATwE1f//kNKIgEoxvtLpgt4GqYhMo2bnH3K82OCtRrS18PQda/KplaHelr/Z6ty7BK
	 1RhYv3LiTgUyA==
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
Subject: [PATCHv2 bpf-next 8/8] selftests/bpf: Test user memory kfunc errors
Date: Tue,  3 Nov 2026 08:59:15 +0100
Message-ID: <20261103075916.100050-9-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103075916.100050-1-jolsa@kernel.org>
References: <20261103075916.100050-1-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qf638fozoueamcokds61fg5tatiuz7s6
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: CE23D80004
X-HE-Tag: 1793692842-920503
X-HE-Meta: U2FsdGVkX1+5XRJno+fVZqVhU2ykeVZoD94+wUkTT3uUyV3iKQ+B8MY9GQs5+e7j/uJ5CN9q3UDvk4uaNaey7XGufKUkb1vaplmS6cla968s40pZjQtPyowBFNxbj4Y/w5BxfMH1OxJu6ZtQS0P9O40Uk0ND+ec9p2H39/pjkZB3aSQuM8G/WBPPgmKA9EjC78T8xoJfVLiydkf+IgwNN6kdxfeA2bstcYlLPaacozqe7OllOkRZMCgsYQScnIPTVACKv3okl5xjNarFWlic0xt2l64/ktysGWQYTCkniGGGMVnW9aUGVJ5RuDXbuANlghgTuSE2KqPzcoJpVhmv9Rncclajj38eI5/cBmz9hOYNgBIZVc149eDPYr5Xb0G1cMxJQ+BSiGoYCigMuYwv1flgP9mQ9bDxMofB/WzpFOjnFuqNvpaoPCW+o18cPyv5rve19PR/hU6MOTiWSljipyzlojDlq5NUcN6ytyWzajAZGzhSiRAfcZTq5Fek4tlw0PzVAi6UVEFEG6DamTAamLkJiLxoSOOTVvV40heXc8ebi5Qg+lFijXIxT1QdFQKn9n+i+1AvslPjb5KSZURjKSjrJmBZWeYnEV2h7CwhPK8aRGLlanLShpIFRK+EouwIuAdcFk11TJ0auoj5sa6EiPQ8Kv7gkjT+Fl3B6h56CHduXSqYVyLmTLJZixMYQiMCGR86R9ZIasmdk7dQfFYU5PyIeh9KgoO1vuI5IdWnte+rzX4F7b9BF6K4x+3IgGA6RXx0mjcVDdtxy/ICuIGi3NhPLfGPjUMqvnWXIbeu94WXNNT4N21T8a1jiiIFoZu1lwT5XrTGj1EthlSaXXSH9MqsqKhXs9aN8KOG0JIl/iPeHGF4GX+nw4JB+kOnFzP9R8rORiTl7slKbSWapLovHkonVkDXCS1+sMX+viaR+3g9/bADYRudJIeCPc7mnbKbeexKBgGxbG775xkwb8u
 pRjUq+1U
 xczLy7dAFjgXooCV516ud24cZ7z1gSAofwsKNYMBiiJIjH+mnfDI2dfOyf3qo+S4038nhn/AOheQMn1a+qrOCUBnEVzJx5ppDy02Y08pbhPVrZQCuoitgjCIYcsmDWEkFOBYhE9F6+19vP1b/3Pnxlqr+CPjCf5hEjSzbGnykkEtIZc2lQhldX610U4iQZsF6nZ0NTZpP4dt/UBNHU+MVanW67UjYeA/hzZIQ4jB53IkEQGlvqnh3nGdBAJXcM839te4v0YUHHQonFpVmjJzJzEyPATELt8Bpt/JOlM7Tp+bT0V+mTmpeZHadgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Test invalid copy arguments, zero-length mapping operations, partial copy
faults, and copying to read-only mappings. Verify that a failed unmap
leaves the mapping intact, and that non-sleepable programs and programs
without CAP_SYS_ADMIN cannot call bpf_user_anon_mmap.

Assisted-by: Codex:GPT-6
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../selftests/bpf/prog_tests/user_mem.c       | 57 +++++++++++++++++++
 tools/testing/selftests/bpf/progs/user_mem.c  | 29 ++++++++++
 2 files changed, 86 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/user_mem.c b/tools/testing/selftests/bpf/prog_tests/user_mem.c
index c87620e39abb..120900bc1869 100644
--- a/tools/testing/selftests/bpf/prog_tests/user_mem.c
+++ b/tools/testing/selftests/bpf/prog_tests/user_mem.c
@@ -263,10 +263,59 @@ static void test_partial_copy_fault(struct user_mem *skel)
 		munmap((void *)addr, second_page_unmapped ? page_size : page_size * 2);
 }
 
+static void test_zero_length_mapping(struct user_mem *skel)
+{
+	skel->bss->map_len = 0;
+	skel->bss->map_prot = PROT_READ | PROT_WRITE;
+	skel->bss->action = USER_MEM_MMAP;
+	user_mem_trigger();
+
+	ASSERT_EQ(skel->bss->user_addr, (unsigned long)-EINVAL, "zero_length_mapping");
+}
+
+static void test_failed_unmap(struct user_mem *skel)
+{
+	long page_size = sysconf(_SC_PAGESIZE);
+	unsigned long addr = ~0UL;
+
+	if (!user_mem_mmap(skel, page_size, PROT_READ | PROT_WRITE, &addr))
+		return;
+
+	skel->bss->user_addr = addr;
+	skel->bss->map_len = 0;
+	skel->bss->action = USER_MEM_UNMAP;
+	user_mem_trigger();
+
+	if (ASSERT_EQ(skel->bss->ret, -EINVAL, "zero_length_unmap"))
+		check_user_mem_vma((void *)addr, page_size, "rw-p");
+
+	munmap((void *)addr, page_size);
+}
+
+static void test_invalid_copy(struct user_mem *skel)
+{
+	ASSERT_EQ(user_mem_copy(skel, 1, sizeof(data), 0), -EFAULT, "bad_copy");
+	ASSERT_EQ(user_mem_copy(skel, 1, sizeof(data), 1), -EINVAL, "bad_copy_flags");
+	ASSERT_EQ(user_mem_copy(skel, 1, 0, 0), 0, "zero_length_copy");
+	ASSERT_EQ(user_mem_copy(skel, 1, 0, 1), -EINVAL, "zero_length_copy_bad_flags");
+}
+
+static void test_invalid_prot(struct user_mem *skel)
+{
+	skel->bss->map_len = sysconf(_SC_PAGESIZE);
+	skel->bss->map_prot = 0x80000000;
+	skel->bss->action = USER_MEM_MMAP;
+	user_mem_trigger();
+
+	ASSERT_EQ(skel->bss->user_addr, -EINVAL, "invalid_prot");
+}
+
 void test_user_mem(void)
 {
 	struct user_mem *skel;
 
+	RUN_TESTS(user_mem);
+
 	skel = user_mem__open_and_load();
 	if (!ASSERT_OK_PTR(skel, "open_and_load"))
 		return;
@@ -287,6 +336,14 @@ void test_user_mem(void)
 		test_copy_to_readonly_mapping(skel);
 	if (test__start_subtest("partial_copy_fault"))
 		test_partial_copy_fault(skel);
+	if (test__start_subtest("failed_unmap"))
+		test_failed_unmap(skel);
+	if (test__start_subtest("invalid_copy"))
+		test_invalid_copy(skel);
+	if (test__start_subtest("invalid_prot"))
+		test_invalid_prot(skel);
+	if (test__start_subtest("zero_length_mapping"))
+		test_zero_length_mapping(skel);
 
 out:
 	user_mem__destroy(skel);
diff --git a/tools/testing/selftests/bpf/progs/user_mem.c b/tools/testing/selftests/bpf/progs/user_mem.c
index a5dd347a02b4..5a0e6a6dcccf 100644
--- a/tools/testing/selftests/bpf/progs/user_mem.c
+++ b/tools/testing/selftests/bpf/progs/user_mem.c
@@ -80,3 +80,32 @@ int user_mem_test(struct pt_regs *ctx)
 
 	return 0;
 }
+
+SEC("?uprobe//proc/self/exe:user_mem_trigger")
+__failure
+__msg("program must be sleepable to call sleepable kfunc bpf_user_anon_mmap")
+__msg("cannot be used in non-sleepable program")
+int user_mem_nonsleepable(struct pt_regs *ctx)
+{
+	bpf_user_anon_mmap(4096, 1);
+	return 0;
+}
+
+SEC("?kprobe")
+__failure
+__msg("program must be sleepable to call sleepable kfunc bpf_user_anon_mmap")
+__msg("cannot be used in non-sleepable program")
+int user_mem_kprobe(struct pt_regs *ctx)
+{
+	bpf_user_anon_mmap(4096, 1);
+	return 0;
+}
+
+SEC("?uprobe.s//proc/self/exe:user_mem_trigger")
+__failure_unpriv __caps_unpriv(CAP_BPF | CAP_PERFMON)
+__msg_unpriv("calling kernel function bpf_user_anon_mmap is not allowed")
+int user_mem_no_sysadmin(struct pt_regs *ctx)
+{
+	bpf_user_anon_mmap(4096, 1);
+	return 0;
+}
-- 
2.43.0


