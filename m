Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F1B5606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HjciG1Gn
Received: by kanga.kvack.org (Postfix)
	id 64EFF6B05BC; Tue,  3 Nov 2026 03:00:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FE536B05BD; Tue,  3 Nov 2026 03:00:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53C0D6B05BE; Tue,  3 Nov 2026 03:00:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 367476B05BC
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:00:24 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CD0981C3310
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:00:23 +0000 (UTC)
X-FDA: 85393060326.03.B431E1E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 44F7014000E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:00:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HjciG1Gn;
	spf=pass (imf26.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793692822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CkoaYsVrQw4bggIbP2eSyejf/kkcERYdrl0Rt2n0tMU=;
	b=bp45azPzttsUyMh3UwhwCbltzl5jFu2GkJrIA2U8U4sSl2qAb4KZfbTX3TwH/qikE51Zq+
	689SdBFwWIMeTobNH5b8RyyIqGb01ENgbyCX1owdTd0qN2aQeoecOTLGI8JZLlanoDVITD
	xrJnczdrubGCYKtr0WGkpZlky80mgv0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793692822;
	b=YqxO3GMOUmBrBlLFBVQ9x9OuuRtik1eB1ZBQk8RIG4mC8ZvxZIXk1jViqvqO2Ub9+7ZH6/
	T8g2aUJc2X5C7aqkCS4nKMTp5YTyETLDAO8tgNQcgwJSyVbTE5fD+kBqiUTPSVQ5pmKUxj
	OplgPVJ9yxAj/B7X3pPVWGPeP7jYn7o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HjciG1Gn;
	spf=pass (imf26.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C2759600CB;
	Tue,  3 Nov 2026 08:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343241F000C1;
	Tue,  3 Nov 2026 08:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793692821;
	bh=CkoaYsVrQw4bggIbP2eSyejf/kkcERYdrl0Rt2n0tMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HjciG1GnPBgvtJsnz3fQx6Lp0vwCqQTGSz4vUd5+NSYgBO4ziXZy0oMlfMcQCPX0K
	 yWoRh9T0nDmwEZfR4iEiasjCwmWNCgR/IptMftPcdrH7j/SdAlB5g3ACZWTJOYg3i9
	 Kehgi1OFwRwWv+CwC6SvECHhuLYXqLGWFea+ai7yI97Qer6QGEnYObK7KJOXE5dkDR
	 d4m5wX6npylhaLzwTJzcoMWybbve0o+FS//2pQJ6WbTYL/XwHEZO/86YSlAzw8N4XN
	 97u1U9+sT/R0xlBJ+TTYWUnWMig/4vBL8CCL25IIqeTERCYq4MszaeTphC613P6T+g
	 9+EgjEXgFFeGQ==
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
Subject: [PATCHv2 bpf-next 6/8] selftests/bpf: Test user memory page exec
Date: Tue,  3 Nov 2026 08:59:13 +0100
Message-ID: <20261103075916.100050-7-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103075916.100050-1-jolsa@kernel.org>
References: <20261103075916.100050-1-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 44F7014000E
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: bpnzs5m6fb8zt9a3bc45jbkj4k9umep8
X-Rspam-User: 
X-HE-Tag: 1793692822-257556
X-HE-Meta: U2FsdGVkX1/xLM2swsDhsM+ZzKJZmJiv/kZZL23/LyZQJ2TH/RKUpb5eLyPDa1kzzoKgtC+yi6DM33V9nbLsskXPoVm86LWLf4T55p2c7Q5rxUgXWTakzR65Y17yVSrfi+Nf8UiyElRlDNCJtKF0aOfjP6TS9dO8zpc6tnFWlwZJiIM8Hx67IHe53YTr4mS0a7awqkDAGaVKBaF3swY0PajABCEoMpN97NmHYfRD9hmUGc6fWurb+xU+oEYw9zupttwSHPIE0akIOXUU83h0Tv5IF2glTmdyzqLpvu287FJtOfwJ2pt5+MaQ2soHqEPEBZa9uQtJy4h2k308BQL/M3QvTO2tGa88TzU9YTbXC0SC0D0Tths/nTObqm94R+zWG4BQ5S/ojguXfPTzPFNWz+1SxilNDBrQxinL92AdRE+2o9vKyDCQ2S4i9LcB0RKxy6dcSfcbuYnfapSP3akFGQ/cLHONds7K5iQjvFbhNvCxTjL2IqJhKeXtwnfsF1sqqqYFdlaI5pwsDPwQ9Eny0JXV/FwCQnRDWj5MHnzo8dTnWLXyD33FYQZw5Jz3ZZZFhXpLzEL0354sbYEjyJ2yfcDUU/Uy8zcLQU+4JiRElHMOag8LpU9XH1hRYb2Mtvg5ICgyUIDf/BJNF/3qJk2SVVgor9ZdXYLFiiJUqh9ndGPMjS3R2rZrzvM/ikFGZCYAUSaB4o35Dt7m4KtOKZxW/FJfSxE+9x/BSkgv0jQtJFsrwkRRheCgULMFRwWeCVMfclLMswAxZ5c0peHSkSwwDEis629pdEk4aZnnXWGSM+H4QksM5iNuxBgrv81B/Qj7xYCMbuvkDgn50Jq68tIP1oDVdfrCTGeiVN/emTN3+vHhQ85HkiJblc5S3z7CwcI93CQYwtghKQZdjs+0l5hNxV2y7mqiqDnumjoF2DjpZCSFFXeyXTPbXpO3QTq+yJTB9O5R+aLdXLFaHu8OkXG
 bBP+C88S
 zKEULTA4NlfkuwHEimO51Yv4F4OQEnLBXWRq4TDAur3emDwek2dY647h3f53JwWO88m0PenQkqnthHvC4oLLHPiqwxOEbpYqyym5dRB9edwldkyqyG7KEe59OOunyRNqGIDSJTaBv4SzmnfLVFioKCgQKvprlYztojocEzw6TLCFUlg16LeZmEDQWE9M2kbwxO8UH//4eKiWv/03HY2EHEzge/FRWJeAFaPKULPCS2gRaEcBatVir5Ud5AE05ZTU2K1Nb7XHV+2hux9xSzJ8HRbiLesACaLOENghoVOreatm3i1jfBiKEIBvnpz+aopWuXoITgL7FE8INeqc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Use bpf_copy_to_user from a uprobe to write architecture-specific
instructions into user memory, then execute them on x86-64 and arm64.

Test execution from a mapping created with read and execute permissions,
and from individual pages made executable with mprotect.

Assisted-by: Codex:GPT-6
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../selftests/bpf/prog_tests/user_mem.c       | 75 +++++++++++++++++++
 tools/testing/selftests/bpf/progs/user_mem.c  | 22 ++++++
 2 files changed, 97 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/user_mem.c b/tools/testing/selftests/bpf/prog_tests/user_mem.c
index f301a1843706..7fa827298d24 100644
--- a/tools/testing/selftests/bpf/prog_tests/user_mem.c
+++ b/tools/testing/selftests/bpf/prog_tests/user_mem.c
@@ -11,6 +11,7 @@
 enum {
 	USER_MEM_MMAP = 1,
 	USER_MEM_UNMAP,
+	USER_MEM_COPY_INSNS,
 };
 
 static noinline void user_mem_trigger(void)
@@ -92,6 +93,76 @@ static void test_mapping(struct user_mem *skel)
 		munmap((void *)addr, len);
 }
 
+static bool user_mem_copy_insns(struct user_mem *skel, unsigned long addr)
+{
+	skel->bss->user_addr = addr;
+	skel->bss->action = USER_MEM_COPY_INSNS;
+	user_mem_trigger();
+
+	return ASSERT_OK(skel->bss->ret, "user_write");
+}
+
+static void test_execute_user_page(struct user_mem *skel)
+{
+	long page_size = sysconf(_SC_PAGESIZE);
+	unsigned long addr = ~0UL;
+
+#if !defined(__x86_64__) && !defined(__aarch64__)
+	test__skip();
+	return;
+#endif
+
+	if (!user_mem_mmap(skel, page_size, PROT_READ | PROT_EXEC, &addr))
+		return;
+	if (!check_user_mem_vma((void *)addr, page_size, "r-xp"))
+		goto out;
+	if (!user_mem_copy_insns(skel, addr))
+		goto out;
+
+	/* Execute user page. */
+	ASSERT_EQ(((int (*)(void))addr)(), 42, "execute_user_page");
+
+out:
+	if (addr != ~0UL)
+		munmap((void *)addr, page_size);
+}
+
+static void test_partial_exec(struct user_mem *skel)
+{
+	long page_size = sysconf(_SC_PAGESIZE);
+	unsigned long addr = ~0UL;
+
+#if !defined(__x86_64__) && !defined(__aarch64__)
+	test__skip();
+	return;
+#endif
+
+	if (!user_mem_mmap(skel, page_size * 3, PROT_READ | PROT_WRITE, &addr))
+		return;
+
+	/* Copy instructions to middle page. */
+	if (!user_mem_copy_insns(skel, addr + page_size))
+		goto out;
+
+	/* Set +x to middle page. */
+	if (!ASSERT_OK(mprotect((void *)(addr + page_size), page_size,
+				PROT_READ | PROT_EXEC), "middle_page_mprotect"))
+		goto out;
+
+	if (!check_user_mem_vma((void *)addr, page_size, "rw-p") ||
+	    !check_user_mem_vma((void *)(addr + page_size), page_size, "r-xp") ||
+	    !check_user_mem_vma((void *)(addr + 2 * page_size), page_size, "rw-p"))
+		goto out;
+
+	/* Execute middle page. */
+	if (!ASSERT_EQ(((int (*)(void))(addr + page_size))(), 42, "execute_middle_page"))
+		goto out;
+
+out:
+	if (addr != ~0UL)
+		munmap((void *)addr, page_size * 3);
+}
+
 void test_user_mem(void)
 {
 	struct user_mem *skel;
@@ -106,6 +177,10 @@ void test_user_mem(void)
 
 	if (test__start_subtest("mapping"))
 		test_mapping(skel);
+	if (test__start_subtest("execute_user_page"))
+		test_execute_user_page(skel);
+	if (test__start_subtest("partial_exec"))
+		test_partial_exec(skel);
 
 out:
 	user_mem__destroy(skel);
diff --git a/tools/testing/selftests/bpf/progs/user_mem.c b/tools/testing/selftests/bpf/progs/user_mem.c
index e3b0689f5f2a..a62916ebc0b5 100644
--- a/tools/testing/selftests/bpf/progs/user_mem.c
+++ b/tools/testing/selftests/bpf/progs/user_mem.c
@@ -10,10 +10,13 @@ char _license[] SEC("license") = "GPL";
 
 extern unsigned long bpf_user_anon_mmap(unsigned long len, unsigned long prot) __ksym;
 extern int bpf_user_munmap(unsigned long addr, unsigned long len) __ksym;
+extern int bpf_copy_to_user(void *unsafe_ptr__ign, const void *src__srcptr,
+			    u32 src__sz, u64 flags) __ksym;
 
 enum {
 	USER_MEM_MMAP = 1,
 	USER_MEM_UNMAP,
+	USER_MEM_COPY_INSNS,
 };
 
 int monitored_pid;
@@ -24,6 +27,22 @@ unsigned long user_addr;
 unsigned long map_len;
 unsigned long map_prot;
 
+#if defined(__TARGET_ARCH_x86)
+static const unsigned char insns[] = {
+	0xf3, 0x0f, 0x1e, 0xfa, /* endbr64 */
+	0xb8, 42, 0, 0, 0, 0xc3, /* mov $42, %eax; ret */
+};
+#elif defined(__TARGET_ARCH_arm64)
+static const unsigned char insns[] = {
+	0x5f, 0x24, 0x03, 0xd5, /* bti c */
+	0x40, 0x05, 0x80, 0x52, /* mov w0, #42 */
+	0xc0, 0x03, 0x5f, 0xd6, /* ret */
+};
+#else
+/* The execute tests are skipped on other architectures. */
+static const unsigned char insns[] = { 0 };
+#endif
+
 SEC("uprobe.s//proc/self/exe:user_mem_trigger")
 int user_mem_test(struct pt_regs *ctx)
 {
@@ -37,6 +56,9 @@ int user_mem_test(struct pt_regs *ctx)
 	case USER_MEM_UNMAP:
 		ret = bpf_user_munmap(user_addr, map_len);
 		break;
+	case USER_MEM_COPY_INSNS:
+		ret = bpf_copy_to_user((void *)user_addr, insns, sizeof(insns), 0);
+		break;
 	}
 
 	return 0;
-- 
2.43.0


