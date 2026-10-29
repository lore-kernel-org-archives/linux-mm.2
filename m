Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 518C7606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 21:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EVelXOyj
Received: by kanga.kvack.org (Postfix)
	id 6C1A46B05C0; Thu, 29 Oct 2026 17:27:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6728A6B05C1; Thu, 29 Oct 2026 17:27:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5612D6B05C2; Thu, 29 Oct 2026 17:27:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F9AE6B05C0
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:27:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A8F421204C7
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:27:19 +0000 (UTC)
X-FDA: 85376949798.19.E854CBD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 04F6A14000C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:27:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EVelXOyj;
	spf=pass (imf23.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793309238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ojy+UhwC3CeZ0n5OWvhNQedtQf6s/LFGjHqzO8hqIs=;
	b=YXXu2cOIEFBo7hBMqeUogvsDTa8vqoCcgq/msVDQzjEvtYjAlcOPR99K/AIETfRUxgRiE9
	HLW9h7f/aIgy26ZuKEMOlaSJ9BVG1EjYPRYCR2TQ+YGFUP1J50t5brk9cpztGnesgGgPKV
	FFlW2sHJmELAV9YauvHIp5Wn+bL8odE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EVelXOyj;
	spf=pass (imf23.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793309238;
	b=d6HR0i4TY5YOiKnXH1J2EHPprjxxaRCNWPsTBjUKWGQioVZARc/EDQC6gS3kv2BGWMlyYR
	u5ZZrjcEGqj79vta3nlF/KsXfubvbr5YnN9tquWhQSi55JHxv0zvV3RYeru8TI1F85Balg
	rTnsE5b/YFiFNj0rhGttb/0zZc/e/Uw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 52D2643C74;
	Thu, 29 Oct 2026 21:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9DB1F01816;
	Thu, 29 Oct 2026 21:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793309237;
	bh=0ojy+UhwC3CeZ0n5OWvhNQedtQf6s/LFGjHqzO8hqIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EVelXOyjABrLv4ULU0RJ3o0XRfVChKl+o20IbGRwJiJwWfg5d3X8Eab6sbLaNktl1
	 9rUkQa5x+qrwknfzJSgz/j3GID5HWSloiERPoPxeDAhHhkX+djEkKRtx9xuK9twBvK
	 jLyQXeaOwTtCXK0W2lIl6jnJfqHC+R37Cnc6A3+zwpw/7BLUZ6HKLQ1fsbFMBE1DJ3
	 A2+TLqAs2clx8Djo1RvgjNbdDhG1lI7nUjPgO8lGVPKIdrHjGkhrR+Z3Q6GzptkU6x
	 nC4Y97Tp6gXkR/bqfwmTsDcnuJ6WgGWlb1vXdSgwuBP5aNTJIofrX/jt7k0WnSBotF
	 /kwOMPRd0vsTw==
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
Subject: [PATCH bpf-next 8/8] selftests/bpf: Test user memory kfunc errors
Date: Thu, 29 Oct 2026 22:25:51 +0100
Message-ID: <20261029212551.56964-9-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261029212551.56964-1-jolsa@kernel.org>
References: <20261029212551.56964-1-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 04F6A14000C
X-Stat-Signature: zbka5sou1gjss4okqjn46nzcce4scdfp
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793309237-578856
X-HE-Meta: U2FsdGVkX19juxcgmlACj3gZZ20LSEd3qeK8gV+fl4IQw24i8eGKN+kCL9IAsjlvxq9vL3nBiuHvLozuZ5q5sh4r4iGGeuDViommkN7qTVEWD6ONFNUgkWZmqUwkLHzRxhXSERqav8xQRrDkG1Keu/1kaSU6MPCpLI5sh8A9ygl06rBIQz7fJKOxGHuM6P0EcGZv+6v6WXTmAVgNh8GhM2zw9nRPgO2tKJGq4n2b6JpV3GV32rI+PVmdMthqosRUa+TscflPcnqBD7MqGnbw8GZ0yIjdCmKZkGD7rPx+2gGvDlp2VO28jrD/7fjabR95h9OQGbwD4/RNi2jTQOZwJR6M+SlhzeJskBROdhqHNiyFQ52Yu2+KJyEKnsRUS+Q7HWK4oIpRSnLDVTsaa+d1JVABO9Y+ecl7rP6i2BFNjkOnQOeDIfj/BAmjs1Hco73kK7fegdCEieLnPkFgDMpL8hX/wKxB8mfe8l8Ivz7rMwNMPTUir8dxCS96U3YyxEKU9mc0hE+Y9Q4/4AxQ4nW8lry8ILsjVTjnT+sKoyPUu+5LrjcsmbEgyaYykQin5JoHzwpKOCGM09jWSsc2NTxC3stCi/+sBhLhCW2IDMDjhnUIl0Bymd4IUqRijC2smh11sR2sySQimD3AMOpqQALRFsb9LHGvV64/BuuUI84CO2NaPl7u5eE9Afym62qWJnsZfNWIqrvp+QuZCFGL2WcCbvPnfYnkYyILiFsuM2B381aaC+pM7QsuKcqbDxUIL/L50rkhktq1Jw2suK0HQleOU7pKsJOS8eZ8bPHZTTP+fI9sV4glt1V92a6Zjo46igcxVUp/30gIWHxPQ5LObid5s5XNI5Vji8j5NTLIQAo9uKHaN60H6OGv14SLnqfBMVAk11aWyzcfQy0c9OPf7GlduCL7v71N0GOOEGmEyTfwu+z0iyHWetxsesYZhcE5aH+kJM28FCWhNwwiZj3HeUI
 CKb1Og1n
 ClgZNiWiLqDce0jk6SUnWPTFd3pzxvd+p9wsqESi2+7mAxAsC/d72/hBSQxKtiD9Kkf+IO9FUnpszLSwtmD8DxqfziyK7902eab7J85PobzqHEV3cQsP5mV47TbAYwQz60P0DtobTY+3IsHvXsNSKjobFT6UIG2ee5Gj/p7oHEprNxbgNk6hW6fNfi0AoXYgC/2ENuOrS8PKLc+cXx/v/Qq77D2lJ6AecvzdvKNOt9V+Hv7v7/yNz8PAo+So9cnZz3EJ0iU4hIvLdKI2i7UgA83Kc0QRWGBGF0HmPXTXWFsuBi1k4jKNNtvMxyQ==
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
without CAP_SYS_ADMIN cannot call bpf_user_mmap.

Assisted-by: Codex:GPT-6
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../selftests/bpf/prog_tests/user_mem.c       | 45 +++++++++++++++++++
 tools/testing/selftests/bpf/progs/user_mem.c  | 29 ++++++++++++
 2 files changed, 74 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/user_mem.c b/tools/testing/selftests/bpf/prog_tests/user_mem.c
index c87620e39abb..f3a35f8e005a 100644
--- a/tools/testing/selftests/bpf/prog_tests/user_mem.c
+++ b/tools/testing/selftests/bpf/prog_tests/user_mem.c
@@ -263,10 +263,49 @@ static void test_partial_copy_fault(struct user_mem *skel)
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
 void test_user_mem(void)
 {
 	struct user_mem *skel;
 
+	RUN_TESTS(user_mem);
+
 	skel = user_mem__open_and_load();
 	if (!ASSERT_OK_PTR(skel, "open_and_load"))
 		return;
@@ -287,6 +326,12 @@ void test_user_mem(void)
 		test_copy_to_readonly_mapping(skel);
 	if (test__start_subtest("partial_copy_fault"))
 		test_partial_copy_fault(skel);
+	if (test__start_subtest("failed_unmap"))
+		test_failed_unmap(skel);
+	if (test__start_subtest("invalid_copy"))
+		test_invalid_copy(skel);
+	if (test__start_subtest("zero_length_mapping"))
+		test_zero_length_mapping(skel);
 
 out:
 	user_mem__destroy(skel);
diff --git a/tools/testing/selftests/bpf/progs/user_mem.c b/tools/testing/selftests/bpf/progs/user_mem.c
index 6ebfdc54edad..1ff5be6e3e62 100644
--- a/tools/testing/selftests/bpf/progs/user_mem.c
+++ b/tools/testing/selftests/bpf/progs/user_mem.c
@@ -80,3 +80,32 @@ int user_mem_test(struct pt_regs *ctx)
 
 	return 0;
 }
+
+SEC("?uprobe//proc/self/exe:user_mem_trigger")
+__failure
+__msg("program must be sleepable to call sleepable kfunc bpf_user_mmap")
+__msg("cannot be used in non-sleepable program")
+int user_mem_nonsleepable(struct pt_regs *ctx)
+{
+	bpf_user_mmap(4096, 1);
+	return 0;
+}
+
+SEC("?kprobe")
+__failure
+__msg("program must be sleepable to call sleepable kfunc bpf_user_mmap")
+__msg("cannot be used in non-sleepable program")
+int user_mem_kprobe(struct pt_regs *ctx)
+{
+	bpf_user_mmap(4096, 1);
+	return 0;
+}
+
+SEC("?uprobe.s//proc/self/exe:user_mem_trigger")
+__failure_unpriv __caps_unpriv(CAP_BPF | CAP_PERFMON)
+__msg_unpriv("calling kernel function bpf_user_mmap is not allowed")
+int user_mem_no_sysadmin(struct pt_regs *ctx)
+{
+	bpf_user_mmap(4096, 1);
+	return 0;
+}
-- 
2.54.0


