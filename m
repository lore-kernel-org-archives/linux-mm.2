Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A561D606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 21:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iZBugpeW
Received: by kanga.kvack.org (Postfix)
	id AB9776B05BF; Thu, 29 Oct 2026 17:27:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A68F26B05C0; Thu, 29 Oct 2026 17:27:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9809E6B05C1; Thu, 29 Oct 2026 17:27:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C5C56B05BF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:27:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D88161604B9
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:27:09 +0000 (UTC)
X-FDA: 85376949378.26.0E1CAFB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 32A5340004
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:27:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iZBugpeW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793309228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QuOm2gaeXSxPFm6qdQwQt01b6Rw0w+XhOXMs3dmB3XY=;
	b=uYKsmqJZhsFzrL+TEXV1viTIVPZVO6zJYTBd/hmXxI6UEwhe8I0IMK+2G7Of4fl0q/VA6K
	wIo+qe8FVDeZyAVzz1BTK1p8RvJ8Y0+Vp389p15pM9rdFa0nluLLoveJ5wDx0LvgA6R2w0
	HbGfYN/L7xnJDaFQXk5FW/t+zW1t8to=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iZBugpeW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793309228;
	b=vN1T1e096QKRPp8kkV3/fO9HDHjtubBPQVi9TocIIczIfYxle4UQYa7ld1kLbgY7oUhKOr
	Eu6QkkpMgYQOxO12HvI4dESIjAfF7mRO7goEdh+9+DBZEVQRiEQGO7y6xtmGCv/IL7oYdA
	FHsOKc34Wx3Mmdt0IWf7ohicANf5tPA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 85A62415F7;
	Thu, 29 Oct 2026 21:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA6E1F01816;
	Thu, 29 Oct 2026 21:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793309227;
	bh=QuOm2gaeXSxPFm6qdQwQt01b6Rw0w+XhOXMs3dmB3XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iZBugpeWHZBpl3K2H5FfQFyfR7ntEyxjCFA1kK9LPwmn4G5bzK+4DC+yiFQ0k+A7U
	 Fdi7kcXKaE3PMxeTqP3OuQNGjVQCRlkCZdMyn1KdwQzm1DYOsEqUgysdVghIMkzJgX
	 V540OL3D8fAqoQtdoDKhc5wICR6Jz6CKlhUmtt3SKdJmXFJxvC0qH8LBRQBLd7c0Yf
	 pTurnBSWRhT6PpSMTNOs7p272p5H+yj3rmIGpz5CJdDKSWT0twSCZVpjoA6LTm9MnM
	 GvadEMH+/YEHnYObRILTmkZwqr7ierJJospjmIxN+Izz56l5bWiog85uUZUfWxVdU3
	 7mTphYnGVSdzw==
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
Subject: [PATCH bpf-next 7/8] selftests/bpf: Test bpf_copy_to_user kfunc
Date: Thu, 29 Oct 2026 22:25:50 +0100
Message-ID: <20261029212551.56964-8-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261029212551.56964-1-jolsa@kernel.org>
References: <20261029212551.56964-1-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 32A5340004
X-Stat-Signature: b611ah4pc1dsjbn9guohyczmac8qz7yx
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793309228-641544
X-HE-Meta: U2FsdGVkX18Pg0lMXcRi+nL5Q6ZB2l9EY/ovYstKxE9r+tUN0Upv+FOR830fgNNHwKnNiz7Rvk+7DLmS0379U9ynwyZuxL1b9jJa65935HRHi2VPXmh2j36RG6MNnPBOK++xMmiB5jLa7NuEcU8I/NS2eJnwLwgZuNOj99RBpoDHs4fVWs5rUdKN7Bx/GH/8zK7SzLeWpXVcTbkUcddn10LuegA0iH5LwCeWU+AkydI9o07BnpMivh0nuHERlbLlqykC/OZRY5J+ADUJs+0u9R05sK1h6pZplEZRBStBHMg+hRLTYQWJCeGKs6s+3yCN0XKmLheJ/9/gcTrglXUtoAU34W2cwYGLqvPAKZSl9cFYP4/OSPokz/YZzHJ5vM9VoSARCh+BNYRjgH0rHPyMg7SRBz0PwB2H9zGaCI/+m4HU3ODvxSvufCBo1sAW7BspOA514fkPAIgJr4nEIm/toUOVt9aR+mMhvNS+OTyAXCa47H3elUH3xQ8OXPS6B5TxqUtyavLiOBkR9SjBi4FWGqmDW7WkEuvUo6u3MbIW479gU5T4704LLsrgKWStGa4gbZ3G1RuUxDOagJyE6Au4lmoUgzhfNMZrQvhrQdXi062hb9++1UpAuWCsNJaUmsXVK45j3MXl0Bg5eHPumAe6MVRT0mcY2DvqxxUWzl2Hi8rSclzuSLX58nnFr6FRHqHkg/4odNMaPZQGjejv0izamVf+8WHy7eg8gRuyJcuB2uyFO7bisU66jvuoTOpuAaitYwpws5tq5wvdkUTi/IL7AEbPX7CUj7V6sRWs87wu9g2/1C5rwDMOIi21iPvhrWjznBMEfXtsqNWs6q4sWEv4OjhcNxGvxzu7kFMpUuWJnqCHIN+Eg0PDd4eQ+4/xc6lNbfK0sEmfl1Yuci8SG65NPERyUhxhJfp+MO4IsY1TSFJa1NwjBf81uS83CdmLtKBg9DyFAvNACmoRTB/UBTb
 4Jf+A1WR
 V/v4NNrRRLfkM2lSvJg4lkUIlGYLRSXrDPk7Ylb2zr+h0gDgL7oZ+za71BrvhAcSM78Y2ZGtv6jjNYz/XV2awcWkDptDnMj1UmazqXHSteFi/CjeWRlS+dw7Ac+SDZsYHPGCfNIycqQqg4ffohjvFDjbKU8szCjWwHlS5z3MvysZYMQbB4WUa5T43bGlM2voc7zhcMUv7F+ten2e0r46cA0iq+hTbN3WIh07IKXJZWt5jdvYn3ujxhuTjYGBhraJUK0etqVwimZiEid308SHCtqtQP1CTFavxgrqFXytKX2cEbAagKfetfJ36ksbCaizPKaaNhxEc76duWhYhcoJAKBkpkBRuf0vJ+2Y42OCOavcqbxp8uWaMexPrHsF/UNUvvqQ3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Test that bpf_copy_to_user can fault in a paged-out page and write to a
read-only mapping. Also verify that a partial copy crossing into an unmapped
page returns -EFAULT while leaving the copied byte in place.

Assisted-by: Codex:GPT-6
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../selftests/bpf/prog_tests/user_mem.c       | 106 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/user_mem.c  |  17 +++
 2 files changed, 123 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/user_mem.c b/tools/testing/selftests/bpf/prog_tests/user_mem.c
index 7fa827298d24..c87620e39abb 100644
--- a/tools/testing/selftests/bpf/prog_tests/user_mem.c
+++ b/tools/testing/selftests/bpf/prog_tests/user_mem.c
@@ -12,8 +12,11 @@ enum {
 	USER_MEM_MMAP = 1,
 	USER_MEM_UNMAP,
 	USER_MEM_COPY_INSNS,
+	USER_MEM_COPY,
 };
 
+static const char data[] = "fault-enabled BPF write";
+
 static noinline void user_mem_trigger(void)
 {
 	asm volatile ("" ::: "memory");
@@ -102,6 +105,18 @@ static bool user_mem_copy_insns(struct user_mem *skel, unsigned long addr)
 	return ASSERT_OK(skel->bss->ret, "user_write");
 }
 
+static int user_mem_copy(struct user_mem *skel, unsigned long addr,
+			u32 size, u64 flags)
+{
+	skel->bss->user_addr = addr;
+	skel->bss->copy_size = size;
+	skel->bss->copy_flags = flags;
+	skel->bss->action = USER_MEM_COPY;
+	user_mem_trigger();
+
+	return skel->bss->ret;
+}
+
 static void test_execute_user_page(struct user_mem *skel)
 {
 	long page_size = sysconf(_SC_PAGESIZE);
@@ -163,6 +178,91 @@ static void test_partial_exec(struct user_mem *skel)
 		munmap((void *)addr, page_size * 3);
 }
 
+static void test_faultable_write(struct user_mem *skel)
+{
+	long page_size = sysconf(_SC_PAGESIZE);
+	unsigned long addr = ~0UL;
+	unsigned char vec;
+	int i;
+
+	if (!user_mem_mmap(skel, page_size, PROT_READ | PROT_WRITE, &addr))
+		return;
+
+	/* Make sure there is a private resident page to page out. */
+	memset((void *)addr, 0, page_size);
+
+	/* Retry pageout until mincore confirms that the page is no longer resident. */
+	for (i = 0; i < 500; i++) {
+		if (madvise((void *)addr, page_size, MADV_PAGEOUT)) {
+			test__skip();
+			goto out;
+		}
+		if (!ASSERT_OK(mincore((void *)addr, page_size, &vec), "mincore"))
+			goto out;
+		if (!(vec & 1))
+			break;
+		usleep(100);
+	}
+	if (i == 500) {
+		test__skip();
+		goto out;
+	}
+
+	/* ..and do the copy to it. */
+	if (!ASSERT_OK(user_mem_copy(skel, addr, sizeof(data), 0), "user_write_data"))
+		goto out;
+
+	ASSERT_EQ(memcmp((void *)addr, data, sizeof(data)), 0, "written_data");
+
+out:
+	if (addr != ~0UL)
+		munmap((void *)addr, page_size);
+}
+
+static void test_copy_to_readonly_mapping(struct user_mem *skel)
+{
+	long page_size = sysconf(_SC_PAGESIZE);
+	unsigned long addr = ~0UL;
+
+	if (!user_mem_mmap(skel, page_size, PROT_READ, &addr))
+		return;
+
+	/* Assert we can copy to read-only mapping. */
+	if (!ASSERT_OK(user_mem_copy(skel, addr, sizeof(data), 0), "readonly_copy"))
+		goto out;
+
+	ASSERT_EQ(memcmp((void *)addr, data, sizeof(data)), 0, "readonly_copy_data");
+
+out:
+	if (addr != ~0UL)
+		munmap((void *)addr, page_size);
+}
+
+static void test_partial_copy_fault(struct user_mem *skel)
+{
+	long page_size = sysconf(_SC_PAGESIZE);
+	bool second_page_unmapped = false;
+	unsigned long addr = ~0UL;
+
+	if (!user_mem_mmap(skel, page_size * 2, PROT_READ | PROT_WRITE, &addr))
+		return;
+
+	if (!user_mem_munmap(skel, addr + page_size, page_size))
+		goto out;
+
+	second_page_unmapped = true;
+
+	ASSERT_EQ(user_mem_copy(skel, addr + page_size - 1, sizeof(data), 0),
+		  -EFAULT, "partial_copy");
+
+	/* The byte before the fault stays written. */
+	ASSERT_EQ(((char *)addr)[page_size - 1], 'f', "partial_copy_data");
+
+out:
+	if (addr != ~0UL)
+		munmap((void *)addr, second_page_unmapped ? page_size : page_size * 2);
+}
+
 void test_user_mem(void)
 {
 	struct user_mem *skel;
@@ -181,6 +281,12 @@ void test_user_mem(void)
 		test_execute_user_page(skel);
 	if (test__start_subtest("partial_exec"))
 		test_partial_exec(skel);
+	if (test__start_subtest("faultable_write"))
+		test_faultable_write(skel);
+	if (test__start_subtest("copy_to_readonly_mapping"))
+		test_copy_to_readonly_mapping(skel);
+	if (test__start_subtest("partial_copy_fault"))
+		test_partial_copy_fault(skel);
 
 out:
 	user_mem__destroy(skel);
diff --git a/tools/testing/selftests/bpf/progs/user_mem.c b/tools/testing/selftests/bpf/progs/user_mem.c
index b477132e3883..6ebfdc54edad 100644
--- a/tools/testing/selftests/bpf/progs/user_mem.c
+++ b/tools/testing/selftests/bpf/progs/user_mem.c
@@ -17,6 +17,7 @@ enum {
 	USER_MEM_MMAP = 1,
 	USER_MEM_UNMAP,
 	USER_MEM_COPY_INSNS,
+	USER_MEM_COPY,
 };
 
 int monitored_pid;
@@ -27,6 +28,9 @@ unsigned long user_addr;
 unsigned long map_len;
 unsigned long map_prot;
 
+u64 copy_flags;
+u32 copy_size;
+
 #if defined(__TARGET_ARCH_x86)
 static const unsigned char insns[] = {
 	0xf3, 0x0f, 0x1e, 0xfa, /* endbr64 */
@@ -43,9 +47,13 @@ static const unsigned char insns[] = {
 static const unsigned char insns[] = { 0 };
 #endif
 
+static const char data[] = "fault-enabled BPF write";
+
 SEC("uprobe.s//proc/self/exe:user_mem_trigger")
 int user_mem_test(struct pt_regs *ctx)
 {
+	u32 size;
+
 	if ((bpf_get_current_pid_tgid() >> 32) != monitored_pid)
 		return 0;
 
@@ -59,6 +67,15 @@ int user_mem_test(struct pt_regs *ctx)
 	case USER_MEM_COPY_INSNS:
 		ret = bpf_copy_to_user((void *)user_addr, insns, sizeof(insns), 0);
 		break;
+	case USER_MEM_COPY:
+		/* Bound the kfunc length using a local copy of copy_size. */
+		size = copy_size;
+		if (size > sizeof(data)) {
+			ret = -22; /* -EINVAL */
+			break;
+		}
+		ret = bpf_copy_to_user((void *)user_addr, data, size, copy_flags);
+		break;
 	}
 
 	return 0;
-- 
2.54.0


