Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52EF1606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 10:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gyxk57mY
Received: by kanga.kvack.org (Postfix)
	id 73FA26B05B9; Thu,  5 Nov 2026 05:24:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 716F56B05BA; Thu,  5 Nov 2026 05:24:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62DC96B05BB; Thu,  5 Nov 2026 05:24:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 38D486B05B9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:24:42 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9429D1205F7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:24:40 +0000 (UTC)
X-FDA: 85400681520.09.561F3AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id E763D100006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:24:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gyxk57mY;
	spf=pass (imf14.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793874279;
	b=vGhgaY+ASnP7MakOx7uVaNepOsnGwp648RM4z8CSI14DRyJYdtNasUUYF64tLeZik91MtW
	GLymJjm8TPkc6AnAK/KTFbAq18Qa3wrTyd2rU6sYhX+MW+HhDoclIot0roxhVo7k3JB26r
	uoe5QYm1v7O8tQwNqeVEjDpqQfeRqlQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gyxk57mY;
	spf=pass (imf14.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793874279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KpviBqlgyeWJdrpOQQK4620AQohGgJ+OsCjzKJgQy1I=;
	b=nPIR17jmWEexRuqboXx/mHxq3nqA50njgloCuI2phXWSl24R5dXzqmZraCAdPl6uFQ3AXJ
	YeWZk8zKCm/Ti8HTLXn9S8EDoEoKC4g8UjOg/b3ZOoE6d1/GkihgNrAet7fRpxJ3rodykX
	eT5YArl1tEgY2I+fWvE6OBczSU1Zaq8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4730D43E72;
	Thu,  5 Nov 2026 10:24:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0351F00A17;
	Thu,  5 Nov 2026 10:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793874278;
	bh=KpviBqlgyeWJdrpOQQK4620AQohGgJ+OsCjzKJgQy1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gyxk57mYIyIEdkkVmCrAfTFRs3GjysEwHwcTZ6DL3NXxmhBoFxbpzpQIWFWp4zqLF
	 e6tBJ/sClz8ZlSQyJJifkWOQ2yV6uk4sennpvHqSdGYau1Jkf6GNqNYk1wBA+phZqG
	 dUXcR06sMhUzCMXmK2RZXk4auIX7Y+7ig0U3BWlAKVtv4MU5VaNs/rGrp8GXuFGd4B
	 WgmWPSCc0692HcWquEo3rDdy+VyL+K4YeiaTz297XpiOrCcjvo1xeHJ9HrxkO0mccA
	 MA1qFCIBYc2LtKGIV0uihIAy+dAQJIJWeozBFks49dRMdbcvq884GJfL8ksiDZCR8e
	 vI1qvLfo9BUew==
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
Subject: [PATCHv3 bpf-next 5/8] selftests/bpf: Test user memory mmap kfuncs
Date: Thu,  5 Nov 2026 11:23:39 +0100
Message-ID: <20261105102343.311331-6-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261105102343.311331-1-jolsa@kernel.org>
References: <20261105102343.311331-1-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: w55dprk1h1tsomsbsczzxufm9trzxmrd
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E763D100006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793874278-5396
X-HE-Meta: U2FsdGVkX1+1hEa5IufBjH2ZIXiPDnkHe1hxHqVnNDEuDnSZi6aZT6EFSZKwGujZu82E71uHR5LsLIWM/R0uiNghpWADfMRmbwqEx1PFSgPF8RTUFvz84nI2Wwf1aDM2u/a7IYNqJdtEkAFJrx2qfPqfPZXL4zonV+0TnmS/t9t+BchJUacIZRwLNhWbNHxL8oIbj3fAHcjvieJXkdLOT/oDs11BFsPjfwQdeHHrTGNyZloGNIpLJEhaydHsl3svHzn/i7a9IgckCz8pUq+s2D8UEdoQmOiDunbh/yvtxpAuctMXGhBdemGYwvImj55Z7gztNWRLmjZvHoTTGbs41GyWigccovq61fzJWKe8Z9bC5r2hkln06ZPGnxtXzpazMmdVm5RDBmnomoPkILZR1QENMPLSt4TZYWjY+yUSvAVLELuDrj4wCZi/epkPOgcUNLcUyUubFIvAUmE6VeIo9FhcrbGCOlLoF/LGqIygWBmQWU8W8N5+5eUxs84ToFNsiuEByjkutI/kxWALgtwglbkxKfaXa9j3SvkUT8Ja5wOVBcvp/xV11Rbi6BgHRXTGJCePD8ea+ygIjGGBgaEYkogOaxejZiswoZTIPTJFhYHApZMSH7jY0/A+lcNntW6BrXuX8aWYfQasY7sdp/EXMvlOjHGthY9mWoy2BVSQ7jCdj6NKyO2Gezz11WwkVa1qqcfA2bYItDV53Ay+pB2Qxrs6/hDS1iW2MjAne0c76bz9vEwO+Zk+0LbU0PCMwyWxaN67nApBSOdhnDJ4iK/NetMkj6PXGjjCud+1CQ9/TndhjfIVMivNaxFpoZK7coge1aNaUM0FMAm6GYFjLrmwjkSmhLyz+X5XdHz1r44T4jW9UcVoo2wx/REzU2DYcg74EajaKQFzOh8Jaht+I57RiVw+spMSlyvijZxQ3+Tk9DmsxXWP7Gi9AUTdu1vTEBuKEqvAl22DYeDPymteXmj
 ZdaPDAl6
 4WBlA1KvK5t7oErXe8lhzrBm7/jUMuXhe89f8CM283wxxHnCFkUKztyNI8akiBQ6xT7xj50RtJ5IDIK2CLnSlAhnJNGqx1QEZEhONaGCqOUMu8gyot0TbSC9OPbvLtrwB7kQwVljY6VvPMLtEgWHNX8Y3jPyr9hB5z9kHMRU12RoT+/ZWb8oCrNJfE645FDnQN4SlkTLJ0xbC1Ul9hUvVqn0Zhi0lQE6OuDoiyncfPx9/xdfK0gYwzujJxf9CYgTMFXBkDRvco7K/3oe0JFYgnqCLjcFR4s5aFOJcfXlXzY9g3TG817VzfGm0Et/zNLp8N6M1L08d27UkLXq14EmWlOv96g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add BPF selftests for bpf_user_anon_mmap and bpf_user_munmap from
a sleepable uprobe. Check that created mappings have the requested
permissions and that unmapped addresses are no longer mapped.

Assisted-by: Codex:GPT-6
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../selftests/bpf/prog_tests/user_mem.c       | 111 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/user_mem.c  |  43 +++++++
 2 files changed, 154 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/user_mem.c
 create mode 100644 tools/testing/selftests/bpf/progs/user_mem.c

diff --git a/tools/testing/selftests/bpf/prog_tests/user_mem.c b/tools/testing/selftests/bpf/prog_tests/user_mem.c
new file mode 100644
index 000000000000..eadf668f7056
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/user_mem.c
@@ -0,0 +1,111 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+#include <sys/mman.h>
+#include <unistd.h>
+
+#include "user_mem.skel.h"
+#include "trace_helpers.h"
+
+enum {
+	USER_MEM_MMAP = 1,
+	USER_MEM_UNMAP,
+};
+
+static noinline void user_mem_trigger(void)
+{
+	asm volatile ("" ::: "memory");
+}
+
+static bool check_user_mem_vma(void *addr, unsigned long size, const char *perms)
+{
+	size_t start, end;
+	char vma_perms[5];
+	int err;
+
+	err = get_procmap_info(addr, &start, &end, vma_perms);
+	if (!ASSERT_OK(err, "user_mem_vma"))
+		return false;
+
+	/* VMA can be merged, so ensure it covers at least the requested range. */
+	if (!ASSERT_GE(end - (size_t)addr, size, "vma_size"))
+		return false;
+
+	return ASSERT_STREQ(vma_perms, perms, "vma_perms");
+}
+
+static bool check_user_mem_unmapped(void *addr)
+{
+	size_t start, end;
+	int err;
+
+	err = get_procmap_info(addr, &start, &end, NULL);
+	return ASSERT_EQ(err, -ESRCH, "user_mem_unmapped");
+}
+
+static bool user_mem_mmap(struct user_mem *skel, unsigned long len,
+			   unsigned long prot, unsigned long *addr)
+{
+	skel->bss->map_len = len;
+	skel->bss->map_prot = prot;
+	skel->bss->action = USER_MEM_MMAP;
+	user_mem_trigger();
+
+	/* vm_mmap encodes errors in the top MAX_ERRNO unsigned-long values. */
+	if (!ASSERT_LT(skel->bss->user_addr, -4095UL, "user_addr"))
+		return false;
+
+	*addr = skel->bss->user_addr;
+	return true;
+}
+
+static bool user_mem_munmap(struct user_mem *skel, unsigned long addr,
+			   unsigned long len)
+{
+	skel->bss->user_addr = addr;
+	skel->bss->map_len = len;
+	skel->bss->action = USER_MEM_UNMAP;
+	user_mem_trigger();
+
+	return ASSERT_OK(skel->bss->ret, "user_munmap");
+}
+
+static void test_mapping(struct user_mem *skel)
+{
+	long page_size = sysconf(_SC_PAGESIZE);
+	const unsigned long len = page_size * 3;
+	unsigned long addr = ~0UL;
+
+	if (!user_mem_mmap(skel, len, PROT_READ | PROT_WRITE, &addr))
+		goto out;
+	if (!check_user_mem_vma((void *)addr, len, "rw-p"))
+		goto out;
+	if (!user_mem_munmap(skel, addr, len))
+		goto out;
+	if (!check_user_mem_unmapped((void *)addr))
+		goto out;
+	addr = ~0UL;
+
+out:
+	if (addr != ~0UL)
+		munmap((void *)addr, len);
+}
+
+void test_user_mem(void)
+{
+	struct user_mem *skel;
+
+	skel = user_mem__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		return;
+
+	skel->bss->monitored_pid = getpid();
+	if (!ASSERT_OK(user_mem__attach(skel), "attach"))
+		goto out;
+
+	if (test__start_subtest("mapping"))
+		test_mapping(skel);
+
+out:
+	user_mem__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/user_mem.c b/tools/testing/selftests/bpf/progs/user_mem.c
new file mode 100644
index 000000000000..e3b0689f5f2a
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/user_mem.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+#include "bpf_misc.h"
+
+char _license[] SEC("license") = "GPL";
+
+extern unsigned long bpf_user_anon_mmap(unsigned long len, unsigned long prot) __ksym;
+extern int bpf_user_munmap(unsigned long addr, unsigned long len) __ksym;
+
+enum {
+	USER_MEM_MMAP = 1,
+	USER_MEM_UNMAP,
+};
+
+int monitored_pid;
+int action;
+int ret;
+
+unsigned long user_addr;
+unsigned long map_len;
+unsigned long map_prot;
+
+SEC("uprobe.s//proc/self/exe:user_mem_trigger")
+int user_mem_test(struct pt_regs *ctx)
+{
+	if ((bpf_get_current_pid_tgid() >> 32) != monitored_pid)
+		return 0;
+
+	switch (action) {
+	case USER_MEM_MMAP:
+		user_addr = bpf_user_anon_mmap(map_len, map_prot);
+		break;
+	case USER_MEM_UNMAP:
+		ret = bpf_user_munmap(user_addr, map_len);
+		break;
+	}
+
+	return 0;
+}
-- 
2.43.0


