Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75AEA606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 10:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KjbRlMzY
Received: by kanga.kvack.org (Postfix)
	id 914ED6B05BB; Thu,  5 Nov 2026 05:25:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EC1D6B05BC; Thu,  5 Nov 2026 05:25:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DB406B05BD; Thu,  5 Nov 2026 05:25:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 521376B05BB
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:25:00 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E3D3880954
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:24:59 +0000 (UTC)
X-FDA: 85400682318.20.E5AA469
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5A9411C0004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:24:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KjbRlMzY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793874298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=23ng1jtXqbPnFi3StrOSufGDp6iqJUyj1xh//wWDQPo=;
	b=KZKXgChMogy6FDjOISrs9DFW8izOxfPcR+klJmzE7dV+krw/WGCqdV/8ElL2NtNcElWhzb
	p6o5e4RORSvFmObkp/SZGvIbRBNKGTVCWjRV3HoXM4zzUlH84nqM5vSShisGM1xGtrfdYs
	IrrcQpkpaef990sQtuA0KE7OXXW0nSM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793874298;
	b=D09jjbISztfTeK2qIj8L0BzPsdkljv84Se1qXxsVkRwQiP/kTDn8q88oNNxM1G2OZEzrxp
	sNz0lGmZliAnH+CXO9wzKHHpqnLfOSN7MkjM0Na/Xazm20tmMWBiznDd+874wXJfx7pFcB
	uamE+NtcP+5EdAmpsHU571f/cklQmic=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KjbRlMzY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DB413601DE;
	Thu,  5 Nov 2026 10:24:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047B21F000C1;
	Thu,  5 Nov 2026 10:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793874297;
	bh=23ng1jtXqbPnFi3StrOSufGDp6iqJUyj1xh//wWDQPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KjbRlMzYFvcHjALOFoeiCTDzuUdWwc9I7rztJZwQGTI9YKTrxzwgirkVazUlE1pZf
	 1gMM/KUkWEUHyOL/oTDopv8zCeBXbpZNgj2AwYUV6SoSzwLk3xvT+wWkHrZ58pom3S
	 e/XuXig5TCA+WHbK0Zv8ylo+q5y6QzGLxaqZj//35/R5nboVBn+TJQv19Cno6DDa6W
	 HTxYSgWmuTVJ7svsot+J2dkvDnHklUdtbSRBHnnvLi6ljuNk5nKdev0kLGLjk5FCnz
	 aQ8nRyl/ejaTF82A9pvzFFkvj5d7NmhTlO2uJl7bxjLf2g6uJ5Q6cAWXN/TCF0JTYC
	 uQp0kK+rjBygQ==
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
Subject: [PATCHv3 bpf-next 7/8] selftests/bpf: Test bpf_copy_to_user kfunc
Date: Thu,  5 Nov 2026 11:23:41 +0100
Message-ID: <20261105102343.311331-8-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261105102343.311331-1-jolsa@kernel.org>
References: <20261105102343.311331-1-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: o9ugc6s8ffqdmzd1yg3dbmpizy5nr6m1
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5A9411C0004
X-HE-Tag: 1793874298-952717
X-HE-Meta: U2FsdGVkX1+HASjrvgTUOs0HzioxyvoBFRsrsd3e8nEJnwallmKmt5/KVVVuhaEQl34OJiOR92d/JWRzolurD+XbdV2eSO8r/zD0HTo2QNqzGoBXx6litjT4UYwSc/ZDpWzhaYeczd89y8SQXqWvijRzV6YpWqK21LpsU/CkKH+8r/qspLROpOoE7fZJDfvZ2S3jxTlJPWfCoWfT8WCyPlkP6QPt+/+VbMuHPG9H7zNY+AgOpZDOlJiYFs/w+TY8cSlhcFZmH6wqOx9PJIkFaRpRNEi6WowWoNBb+bhs7591pcT2G2UgBvGjkVJcrptqxq5IRiiQMKWE+VZSc73kjO7G+Eq7OIwDZlm/NInolaNgB7TFAE26hKvTO2WFVjuMRDEDXb9RbdnVl4zF+LakeO7yj4jUGxLMkxkEr1dc3vkxGeK45y0gpp2Z/xm+jO9CDYnJtEkoiwEb+p6rmkjBOWCg9YfTnMGQHT9n4agJOKVCw+am+ugdEH3i84grF8q0vsLMsSS7zi2VLMzp+GHBeSSUxfhRu1CGvgy8D5eFfzbM2gDTcNuxEGoT7QD5fZNTBShVATfY/FLExN117H9XtEG2+4Swabebmi3mKBDnSDwW2jsxFHqPWPXV8s6ba6QOZVWcAS5/hVoiiw6gYXvvhruIf7US+pMeVxAsdguZR4ntWTjNJmyufuJtghGX4ENBGckURa3eGKwWa2z/F2R3CaX/+44uYR+3X4y2QpI+Pp1Fbu5aRQgGwp2kRCOnUXVeBp2XT+7dw0aPI4x9+ADskylL/+7WiEEUnPth/cxsqlhEqQX14GCCwVDR2EObNAbhFceD2vxWTRtihyWbalYeT6ihdFjZ9iFOVJKszcMoqbh96KR+qiP/UlxIV2WvioFuKuYGyGPmF5zeSM5FsYM/ZZYT+SQkOU2UKTysh3loorl7jdaym26JFIYV0ryyUZvACRq9KfLA10KmsuPTeNX
 S68sUodu
 nrkuxaeWRJDpKFLN0EF40/80x+fweZtyPLrTD63HpRBibEPMuO+1AA+u6MzrKS/XJSgygpUjXXDAi/rCTEeSmh40KaNi2fS5H7+gxpmbIeDggQpzHIJ2UX1+0LUC3rd6crGPB7e6f9G+aPbXiwSDi9rxLgyd8R7vrxar8gaebK3oWlWdvgvHAdbL49ZCaz+rP/Sdp5gvvVm7wQRAlZP19Hgz1D6tm7vCfMUusRvxd7FthFDXYPIP+HXHKcjZaDtjwlCzWBenCPOtwYqk/gbyO8WdiEMGekS/l1XRMsgcdHLtpBSxCmYIlyHOOI+R0MsZrHqc/saaEKx+73j+3sYfk52nkStGtqyAiJTPrIEHZU1fu4H0F9+7cP+4CvX1z6hgMN51/
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
index e1748ffb1edf..f13aff73c9bf 100644
--- a/tools/testing/selftests/bpf/prog_tests/user_mem.c
+++ b/tools/testing/selftests/bpf/prog_tests/user_mem.c
@@ -11,8 +11,11 @@ enum {
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
@@ -101,6 +104,18 @@ static bool user_mem_copy_insns(struct user_mem *skel, unsigned long addr)
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
@@ -162,6 +177,91 @@ static void test_partial_exec(struct user_mem *skel)
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
@@ -180,6 +280,12 @@ void test_user_mem(void)
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
index 3bbd5d2f02d6..e12a19fc8784 100644
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
2.43.0


