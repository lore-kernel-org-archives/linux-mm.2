Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFD86606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 10:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iWZlZVUj
Received: by kanga.kvack.org (Postfix)
	id 19BF46B05BC; Thu,  5 Nov 2026 05:25:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14C196B05BD; Thu,  5 Nov 2026 05:25:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03C376B05BE; Thu,  5 Nov 2026 05:25:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D20AF6B05BC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:25:09 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6F8B4140637
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:25:09 +0000 (UTC)
X-FDA: 85400682738.16.54C793E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id DF11F2000A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:25:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iWZlZVUj;
	spf=pass (imf03.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793874307;
	b=i4VxSHd9cy/ESqoc5HBdAEzKT36qnoZYmVc/yxtlBem9mqL9RaxmeNqzGKqlGlFFNBDYj2
	i4GVpwdHrGLvDNijeEJX5vUvg68qDvmJT6obXpT+zlP6wJ3lGlEU6hyJq8t26CjuY9lRNG
	AxDblbx6tGSv4INafxW5SupRoIHl4jg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iWZlZVUj;
	spf=pass (imf03.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793874307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NgYSfYwyN7oBQyMujaH2GQXta4jctPstkZ2Nv//4TlA=;
	b=zqq5IRKQIFOI7NMXneLoqQ/Stu0f6amZKjxENj373xPV1EubmbsChdKzSXVKgZtlAanlAp
	CdKRrtbOLeMOH4aEh4ytyF+5hzpxwgY5oExdgbOEQfqKXSMu/5i7AbEWqgbMfHMSxptK26
	BqXvCLiQyTMVZuUBEdDEQUUaxwLqcJw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7FB0060601;
	Thu,  5 Nov 2026 10:25:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9875F1F000C1;
	Thu,  5 Nov 2026 10:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793874307;
	bh=NgYSfYwyN7oBQyMujaH2GQXta4jctPstkZ2Nv//4TlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iWZlZVUjlbdXUn4O6ZApFvutDcMLk+Vw2a3rL1UINfwi2FKVJoJ87RATxgyOdDrog
	 RUT7eiRJ+B/IY2nJ85oBk6IJV3mniphp1QKwI+gl2v31dz6A9yQ06V2xiR/1SAw3vi
	 x/vOnsqXkcrZiyonohHvsNKLKx+1tk2FX9zOhlxejMVWWZoq7C2A79KFYthp6dz4ky
	 DL1qUY2md7wkCELRJMAmIrcdYISh9DYwd2WJCKPMbLk77g8IZN/FzcTQTjJ9L+x2Xv
	 HLnxu1+NCuyBy0D7B+6OmghHPTWm/IdBcWXxgufJkRocdMJpaafhKLjb3Uc1npFlhj
	 hpyHRc46QCICw==
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
Subject: [PATCHv3 bpf-next 8/8] selftests/bpf: Test user memory kfunc errors
Date: Thu,  5 Nov 2026 11:23:42 +0100
Message-ID: <20261105102343.311331-9-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261105102343.311331-1-jolsa@kernel.org>
References: <20261105102343.311331-1-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qon65xdhz7ujd7w9x4oyda9d5aazqs8g
X-Rspamd-Queue-Id: DF11F2000A
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793874307-651484
X-HE-Meta: U2FsdGVkX1+PzgeXkMdfNDVaiNftmuW7CLj+zbD2OGxdSohM6h3b3p3m8+4T1lqRBcMc1Y5bOeJLxMeqgu/t53MENQDqh4E75pTO7Cu+qVilJpcHtQVJZd+WCe9EAozuavQfi6w60nbMYvLrG29suLtZUQpb94Dq1VAbHs4NCSU6CDSuQHHom9HEg69LAINXNZDXSEvuVABqBayRDmCVCBvc4ulVN0JbTp4AAQZdmkTykmsYxbB4s37qxIsbugtso4Q6w7a6KNLjxjnsskBCh8Tbl45AIAyiBL19AijL30rnVKmUQPZNsoVSjc7n5bahRp6IZVkHiUpXd1Iz8m8FfL6MFvYtH2jcAQM2QpD1rV+ZeagLrKw6+IsImobqb5OMbSheL/l2pmAdtntRBSw7lWaCjd5+sn3TsU/agmYoWiRKzgV5rAJv75QBgaAoG0A+2npfy62krBOuAQgmlYHPk2dElqw4cOCvKTj6ZJ9O743ZjZss6f5/ViQyrTlCSjZWcg98kositBl/mkntCblMaTBsGeIwMyaUqxc4PNIV1Md8v3WqADTlrvthk2ktn5E+fbzPVG/eqYxA8chAgPgfdUFeyI87Gbpb4s1nQuzShizPK99wELuN6+2WBNogz+ioyIfYjQ/wXx/9kpnYWwGocgjvlB9XGdwcuUUs+w8FpEFHrjxsk5mEPO+tbX7UmkXyuOlMX3luBwmGMOl3VaAm1rieDNX+TOTvrsMdHWSYWnWWWQ2hzRYc6HXU4ErS6b1pGgT4zffZ1DGBkczh0tstlK+VxpJR626UDNwZYbcaRrbHdRRNN+k5ojJfbxYXh3PC2X0rsXOTPusyN+pQXYi4RX/ccgicf83hgFRI7Wa9gfhvCENi4Tjr5OcYckbWxj3K2u/sZDgRuhMXSZY6oU7crqfTC3UMpI/1iIroMGc5azoK4sc+q/wxHSSu2Rp+3qT73Pt3uFZQlpcvRyvULqa
 vTbRqrYz
 6cW5FDvPQrQVxV0gw/YjNO1yGgKvUaDlyOxM2tch5sklFqyTJAAQUVd3P8V8OXzhW7KzDIyTIpLzp1JX8tTHPHtYDwJW4ujVGHHr2dROrXiXvBd55mHNs+u+dUetvrKTEd/gVyMeYzRl5bQLCglgSi7893BHD6NDxicYJzTmCHls30laY8dNn7l5JqNOwaoP6rhUYbbPLfBT5LemfaJzuLrvyGIbe30TIcpA5gEKh4LuDIFTx/Krd7OT2bvdV0MianafPqh/xyx5KqxED+dxEnReTYT2S9OOzdGdShYOmSg/mwCWM+r+ucoojfA==
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
 tools/testing/selftests/bpf/progs/user_mem.c  | 19 +++++++
 2 files changed, 76 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/user_mem.c b/tools/testing/selftests/bpf/prog_tests/user_mem.c
index f13aff73c9bf..f1b88bba71c9 100644
--- a/tools/testing/selftests/bpf/prog_tests/user_mem.c
+++ b/tools/testing/selftests/bpf/prog_tests/user_mem.c
@@ -262,10 +262,59 @@ static void test_partial_copy_fault(struct user_mem *skel)
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
@@ -286,6 +335,14 @@ void test_user_mem(void)
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
index e12a19fc8784..6d397fe1b3a9 100644
--- a/tools/testing/selftests/bpf/progs/user_mem.c
+++ b/tools/testing/selftests/bpf/progs/user_mem.c
@@ -80,3 +80,22 @@ int user_mem_test(struct pt_regs *ctx)
 
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


