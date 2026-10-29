Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 488E0606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 21:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B0bqQRVZ
Received: by kanga.kvack.org (Postfix)
	id 4016A6B05BD; Thu, 29 Oct 2026 17:27:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B21B6B05BE; Thu, 29 Oct 2026 17:27:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EEEA6B05BF; Thu, 29 Oct 2026 17:27:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EFE8F6B05BD
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:26:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 86F78C0539
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:26:59 +0000 (UTC)
X-FDA: 85376948958.03.7793553
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0156C160006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:26:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B0bqQRVZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793309218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Im/DUAFHfTcolk1PWOGWY3EMUCY+eKD3uAfuaPZ9s4s=;
	b=FhegrR+nU9sMGI/sFfpYrljqAfdZGxdMXuZoJN0rFquDC23RkHcZekn9BX4yKAn/p+YmqY
	gFkveo+c/XNVKKJkHOWtTWiY6R9AI92G9xclf28YWHvqeoR3cG5riC7pGsiw6o5mRe9UM6
	woIn7fmmpDo7uKa+09MQ372Mz0oXb0c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B0bqQRVZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793309218;
	b=cMgCDKdxOEkAZJx0+9LOckUQ5nPomgNezHU0beCKjms4mgVEDYEwEA351a7+FDFgluZsws
	VYnBiSv+HYMARLUsyAF6WlRIiQlKd1wLhQhJZr9WFKLjDSCRPtAiaKUUQWdPipZsLnP4NK
	EVAuSFOWyluhzF88sFm+mTO4XdSHzok=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 915476020F;
	Thu, 29 Oct 2026 21:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D50B1F01816;
	Thu, 29 Oct 2026 21:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793309217;
	bh=Im/DUAFHfTcolk1PWOGWY3EMUCY+eKD3uAfuaPZ9s4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B0bqQRVZ0IeP7QT7D/+M7E/W66kd49bgd0jEoGVkPlryPNJHhymV1MgIMBE/NaP8I
	 Irko53Oh5U7wwN5/pz41ArdLKYx7YfXgL7IvuEwrE7KllwyByUsW1xT/0h5peOhNF0
	 8DP8B55aD83hng51I9KQl0VUFmHnjXcs4Q824PY0v1JxUPZ/sjCri1REHF21jr3pZc
	 QXWej6n5GLaLGV5swOpBe+VJPvXzWHm1ykpIrjgnPuVoFIiccgO2Hl1+7aw+9ik1xy
	 FUYGtcLmPNDDmOamyUrhYnDVZcARWU+mcJ0DZ2rN5yb6Mem/VquIe7km2Xv4+f3EVC
	 /tKoXJcUM49OQ==
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
Subject: [PATCH bpf-next 6/8] selftests/bpf: Test user memory page exec
Date: Thu, 29 Oct 2026 22:25:49 +0100
Message-ID: <20261029212551.56964-7-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261029212551.56964-1-jolsa@kernel.org>
References: <20261029212551.56964-1-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0156C160006
X-Rspam-User: 
X-Stat-Signature: as68an1muxw87imwpbbrdxzghwm99txg
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793309217-947561
X-HE-Meta: U2FsdGVkX18ktADBOSPbnBrY9GSUX+QdoTadwE5R7hKIA8jZvfsPL4/z8MqqZ59RLkwuo7Auk6gIJuRVsGum5mygavp42VfcM1QGWp7+6+qMFeE0Z9b8TWjn8YdBPxKZkFgTeT8um6zCHxmmJ4YDA3AEeyWgVi5Ghf1nALSYTcho0A5SLkF7KhL45/SELsqVsNblm/T6j56M9ZzjpQq82uII4yBZb4OBCg8hQMpZTS2SotOKDegzvvWrfr7k3s60HK5aTB2QpPCkw9SWPws1tM0fdsSI8vzDZFK2FMjg2zszZTZdj6eIjpZbKk4LgbYTlYgsGPiJBOM6vYjGUso4n9ofDxoWa79zh6A5pm2ULcgJn3FFU2W56w7odg9WjsS7cowXnUXBFbhAuJR2auMd3oEVPAd943iAQkZ+JaLZ4k66Gj019krbzufGbBMtSGXqktjvobPny9oqyDZ+GwKdhkvrWRBiV2aMkDM3LNp1lKbpIIJEEfSNZCC3d1T+FVLKCTgHaPDiFa352SDYJV/2gq5V+QIxoV3OgZ+G8d3PYUCQDRXs7zpItTafGA3sgJ5IahIrCfkkNlxayxuILnVlEpcTv8DGK02que6vVoJZ7wxXI+jjSw0LLacvmvv9rzRf4h6ULy0BJyA2fVEWP+RMaaofwpzP6N/8uJ1j/8Bd+wCYSRbQD2XTZFGxwxp2qE3sfIiOW1qOV4kuVCj+l4PsFlVq6nosrkZuKsjs63z+eJ8SsxB6H2xPE6x9n+rI6mvCG+PRYTcNvuJfIU6XkigXyoVe1alH32lqYGmu1edgPMTmt3+iKDWx7NnNBRjAlZ7jTL65b+tqnBZhQpL+1ygIozVRAYkLi1VNJ+Nah8MSGNWxQ1YZmVAF4BYex4TZdlpprErcPPo9HQfUnNqf49vigtq0YHYp8rOsMus9Cfi6qV7Tr4AtuYptzkVPNclN1dytZmVNIDtepvG2V8qsTwq
 BRmBUuUS
 y1exsi9VMA+rnS9Ha7jw+dRXJOm5Ley1m33OFUDF8vHjafbTOlkPPe2a5h2b384w/a8lO/bc1+Wm8pepEZ/s84tRAWReLwdYg512dSJ1+1p31TUKkb0rnePSz6hvhlAEftoT4RA87yJ0OdSnWDILVG30GuY64F10E4unLu2GG3Evm+fmPFE6ZhXdE/O7cw8Mx8uXjLBhMmcKowtxp5UjNeDC5t10ktT0NZU71Ed9KleBEvpmri7+rXk52V6zW/I1STJ6p9mj7SfD/4mxrXMVtnEDKL5gaD2mkr6vS9Cbv3t26EalhXGCS/BttfjX7p+KE0Z5Vzd9ezhZU32k=
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
index a6b4f922da49..b477132e3883 100644
--- a/tools/testing/selftests/bpf/progs/user_mem.c
+++ b/tools/testing/selftests/bpf/progs/user_mem.c
@@ -10,10 +10,13 @@ char _license[] SEC("license") = "GPL";
 
 extern unsigned long bpf_user_mmap(unsigned long len, unsigned long prot) __ksym;
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
2.54.0


