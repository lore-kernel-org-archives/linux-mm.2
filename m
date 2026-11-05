Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F170B606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 10:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TiGCrbcz
Received: by kanga.kvack.org (Postfix)
	id E93916B05BA; Thu,  5 Nov 2026 05:24:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6A406B05BB; Thu,  5 Nov 2026 05:24:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5A8E6B05BC; Thu,  5 Nov 2026 05:24:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B0EC66B05BA
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:24:50 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4523B1608F5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:24:50 +0000 (UTC)
X-FDA: 85400681940.24.2C812A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9BC0D100005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:24:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TiGCrbcz;
	spf=pass (imf05.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793874288;
	b=rSQ3jgeq/0sZoF4zmgWuSZNbgnnWO1aeoN/ufZnU6GlZacasNISPM8mkSiGb7CNEyd+EWt
	eyTvBEN00nPjvfing7xACCu/rytw5wrXfzjwduVZjKIzhXKuzBl+oVI9ok6/UJ7NZHB5oe
	m5K1GgUVv7EijHp/h+jqvJ4baDB8eys=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TiGCrbcz;
	spf=pass (imf05.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793874288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zmdWsLeDOwil7ZrDTJNt3Mwh5fQ18CiuyFvC+u7BoL0=;
	b=291lV/bBPzFA8ZPPANdJhG6F3BxE03SlFzYndtzQG0JoJVTpi19O+1dPlde7cDm4Q0d+x9
	DZ8MtWDlQiGn7tOZ47vifFzdQmZSQULywiTfxNDe4d/LFv1IFkc2orU+LUaIKd83Yv2iN/
	IEOJ7P+KQxLSxI0SF43wTOD2OUJzgdE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 04F5341976;
	Thu,  5 Nov 2026 10:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46EFC1F000C1;
	Thu,  5 Nov 2026 10:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793874287;
	bh=zmdWsLeDOwil7ZrDTJNt3Mwh5fQ18CiuyFvC+u7BoL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TiGCrbczGsGJs34yk5Ncj74By2pa+sJUxXs/vcpT3y76BnbA63mfaeNnerAwBcTNJ
	 QJoJYdsWnAoyZ5ponPmjQ22qrep+ZyZeYT+06ZcUiHP6IoSqVi+z1ggL3AzYFXG/9v
	 A7FNsBm7DQLmgJ2Pb29Iq1fFgzYRfx3eAXiERZ60P0QV4YPJbtjWTTPKnSV3WiEVj6
	 LYzIEb3lOtxw0Y+xt6NSo6ZzaK0F2u+EnaDVyrAnj4RoaIZkhYXGUs6fnRhAeO4BV4
	 0rdLAVUpBqhUl2aHcOMAstmbc8ULGUDCE+gUjfOSOODK+rwKvia5jAZdv7B9S9/bGT
	 YJERp95yTRayw==
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
Subject: [PATCHv3 bpf-next 6/8] selftests/bpf: Test user memory page exec
Date: Thu,  5 Nov 2026 11:23:40 +0100
Message-ID: <20261105102343.311331-7-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261105102343.311331-1-jolsa@kernel.org>
References: <20261105102343.311331-1-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9BC0D100005
X-Stat-Signature: zrwc1c1im9dtti1i6i8m6nkzjsofcuis
X-Rspam-User: 
X-HE-Tag: 1793874288-871876
X-HE-Meta: U2FsdGVkX19xa6YSU23rQ9tIZoHuLyY2s1iLVwdnVmWIUF9nrHR4Lj1oRtCW1ADrv02RUFSq82+iUpTCuFGayGs2Iq9bv67jQyjJbWteq4VtgBk4VO2giatYcy+p9WxBo/0y+4AE+q72VpsURSpKOOI+jVGg1FpB4XfcDqO3buJSmg2QhyX3cp1y4lEcDGXM8k/Pa/EjELqVd0f4cEiFxe3zOFPZ8FzO+C99iMHHPLN2fWUgsmZxoPrtFleb7Q1A59U6LXDIazOvkYeTw4z1/OS42iz5+aO//VUCnnLHNoPQt2yYqLC44qhHhya6U01yDyXxtoAhUf5YGoGPLKYqNpKOHFxdXveyVUywyMUYC7GNnpbFfEfwvGoIte0fcVFWdwlWVqSINLQTNcP58QguvYpSnHXLfd07ENO5K3sz36O2Q4l6E9nxNO4O2XACkhYf8c/3K9gKnKyLjgZUToB/tzpZNWOzjGQmxa0DJsALD3CWLjnPrx74H1SXtiUzEEy7tnt2HzQUX2IO+VrtQ18kDAqHMKfa4aLEINO2/8S3Jf435fKm9tVqn6/TFXDtAG6LkkRkJPBq1+oAkPLjjQGzhj4+kdvL78mnNhlda4SJzeq2PhJUTj77hbQuRxZHAfGvRcyp/JheusQlI8VKcaOTTAu3Ecf3j8q0UXS5NMBdKfvDxWqEHjb0z307KkiGiV5/Zn+YYT5GA3206IQlEjhpD5TuOuW+UbzGM9R/1xl4uLu4Ac7qpI057UAhuawiHQ21HxqdIwFSv9ERB6zgqfVMsynH4vOfn0tnxO3r4bN5RDRTsosKRVNIKdXJ6BPtt8tVkFCqhAZS3ITsxtp1xPCQh+17ixvxGGZhgjUQH2XkLLqPxQrgiRTjjxHFnr8dsSpJAOC5MUK+jk6KP6yCLmLcjV6cienTtUszn12m8L7WHsg14uIhWmQognwllebAoHf2I8nPpTOIJ1GvfcO/22Y
 F8W1YiF2
 dzf31nfjS6RBR0KwQnMOqTcrPmDPKfHjsb/7jIV3iKh7bXJj5vjGYZlF1lAKDIx6K0eSbK/l2MPJGMiyjVVp/068cEN3000+pZAhEZYtpDr8GGLB8Jxy6hU20mLMsF+eBg20u1jzMF9iIAJXeP/ulSRLOgFNStmI5yRX5z7vP5kFUJgfmg/pzNchOW3y00qOIUBLOsx5MpAXuQluiSQwrcXi+IvtHtuA/DVc0t2qG/NEhez0JFzIzm/dr5gXDjwuAIQzzxJZGTq3BgzTs7A4SfZmONgq5Q3VxG70fDM69d/gnKRpre94JHKp5Q3HcbdpLxq/869qOb0JtGWE=
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
index eadf668f7056..e1748ffb1edf 100644
--- a/tools/testing/selftests/bpf/prog_tests/user_mem.c
+++ b/tools/testing/selftests/bpf/prog_tests/user_mem.c
@@ -10,6 +10,7 @@
 enum {
 	USER_MEM_MMAP = 1,
 	USER_MEM_UNMAP,
+	USER_MEM_COPY_INSNS,
 };
 
 static noinline void user_mem_trigger(void)
@@ -91,6 +92,76 @@ static void test_mapping(struct user_mem *skel)
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
@@ -105,6 +176,10 @@ void test_user_mem(void)
 
 	if (test__start_subtest("mapping"))
 		test_mapping(skel);
+	if (test__start_subtest("execute_user_page"))
+		test_execute_user_page(skel);
+	if (test__start_subtest("partial_exec"))
+		test_partial_exec(skel);
 
 out:
 	user_mem__destroy(skel);
diff --git a/tools/testing/selftests/bpf/progs/user_mem.c b/tools/testing/selftests/bpf/progs/user_mem.c
index e3b0689f5f2a..3bbd5d2f02d6 100644
--- a/tools/testing/selftests/bpf/progs/user_mem.c
+++ b/tools/testing/selftests/bpf/progs/user_mem.c
@@ -10,10 +10,13 @@ char _license[] SEC("license") = "GPL";
 
 extern unsigned long bpf_user_anon_mmap(unsigned long len, unsigned long prot) __ksym;
 extern int bpf_user_munmap(unsigned long addr, unsigned long len) __ksym;
+extern int bpf_copy_to_user(void *unsafe_ptr__ign, const void *src,
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


