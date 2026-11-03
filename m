Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7172606A329
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VfXU4KFI
Received: by kanga.kvack.org (Postfix)
	id BCC076B05BA; Tue,  3 Nov 2026 03:00:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA3346B05BB; Tue,  3 Nov 2026 03:00:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6B6A6B05BC; Tue,  3 Nov 2026 03:00:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8084C6B05BA
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:00:15 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7EEA71A031A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:00:13 +0000 (UTC)
X-FDA: 85393059906.22.6655D26
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id D4519C000E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:00:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VfXU4KFI;
	spf=pass (imf10.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793692811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8if4QJZvxjPV619vIg7F/lLYGJyfqGFl5e4WbtOI0UU=;
	b=3ie47cBFPNcBmC74G1OYavZXAZgPFJlKp/WnpFYv6Q2fR5qSmpvfmCpPCd/SCkX4l2WBv2
	6iC2YfRCvzO53apGFoeecHJ20FmyqEnwIjkZTC5rCq09LzB5zBQA/zHGliTa41Zd9lzNu8
	Py1ttICHHccVzSInDgbgQwrmjWr1yk4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793692811;
	b=mx3LMrv4w8spA89tuRjKYoVcEXQlCZ6+WLkrOXkiUmhfO09NUCL+TSyKwKWQhngP2dYkqL
	CRnTBgOuOvkwpMKr7ZcKZ2mKf1mI8XaC5aGEoWWXLXl8vT0xfzuO/zx4y5OZK4F3iGSMcK
	rCsyfONQL+MbB4wRXMUbn9mImvEqaEo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VfXU4KFI;
	spf=pass (imf10.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 60C0560008;
	Tue,  3 Nov 2026 08:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE121F000C1;
	Tue,  3 Nov 2026 08:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793692811;
	bh=8if4QJZvxjPV619vIg7F/lLYGJyfqGFl5e4WbtOI0UU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VfXU4KFIl0lOichLHprGgkUwtJ+/9IZbOr81/K4P8W8ab/jzVMV1aWn+KRyP22PHj
	 GtXwy5zhidog3MszJdvWEwFyWtE2phsVqskQHKkYzJcw2NUXj1qdWODa77v6O5EN68
	 tfhwFiAsv3L4/16Ccs8w7f/wKcK75Tmm3TDxH89Ut/CQ/rLJ6DB/c0K8McfcVSzERv
	 f2d7r6d214bpoLHiBuxzkxn9t8gHyJ/AzZBo8NDeluJXR8ccqzo51ZS42xOHe/csjU
	 A0AjoqQATR/nPWNXz+CflrIsmHwjTPqPZ8U/6DZm9Zn873JfnfTRnUR/FyJUgSLamG
	 FnSKoZGSNH1Yg==
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
Subject: [PATCHv2 bpf-next 5/8] selftests/bpf: Test user memory mmap kfuncs
Date: Tue,  3 Nov 2026 08:59:12 +0100
Message-ID: <20261103075916.100050-6-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103075916.100050-1-jolsa@kernel.org>
References: <20261103075916.100050-1-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: pyrwxg3ptshmwb1escfzq9b4afoe7ppd
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D4519C000E
X-Rspam-User: 
X-HE-Tag: 1793692811-893223
X-HE-Meta: U2FsdGVkX1+xf6tx9NJAebktVcyk7cY5XIqWGuJHXF6hWjnY1ezozU5IqGx2O6i9398B5r71tXdSyoQ3Te4bcMXGaQRzDv2NxB7udl9599YXCjCU7UU/xa8V1WiXb3ZhqufBQ1YyjdI3+jSEDTu0U3aR7TvB0WqtuRbVDd/Y/+u7oqlnaE03j7FR+7IZ3NUkWovuwGVyV0FGyd/ucMZR+sF33uQmKkefYQ04eXpzkT2p4YaaHvnz8KdFdDSK2MffvUBVBX9TdZtaxaULmxQ7F/wL7krDQgdyhvhCPKuDH9jo0BMp8WNaLdk3+0AnV29WzXy3APgVSWAd4VCBo8EjFuoT8UBM8H3VbNzo3TO77KUpffUTbieZNsxsKhNrZ9Bsix0UDwyJEKSRuBCjvEEsqkMn+M0yCfpe6y0d6R7PN5w6vphzSfTEw7l//F/G2xppFwtkHQQgP+bz3FfeyZsVl2vIPBu4haOj6xUIR3ubMPwj15ZnVNljzfLsgkktFRZmBQYeCBGZjjH+VMtTmNSmbbyiGI80QI4LKaW2KbE1wyuLU2N+GjB9qeGBMs+41fmse4eaEbzOkK9KVtwqBTVwCuxiNSnuG3nb1bEn6Fh+YiF68I2FJNRtOMc7NVBvHwBknTrSqrlhtgbwsMH2A6A5y8/ZaSGmpdKE8zXJawCv2xY4tbs/tGkVH6rhsNiuw3bRGwi87XaQnL+bop8UmfLWXwh95hjBVIqVSjeRdE1xXf3oQ12oPL70sTmcbkHpakmb/u/ClA/XSOMRQpK4xLS0gG4pNgeNdJYhAbY6ZAsE3lUuq8TGDO9nrFMchozBPfMyZk43Msw5TYFJHqlICmQNLR9BMnZKIHNE+GFOWFYf5qpQNcd0z2ugOjYC4hub6wXmuq2MmGTj189TFF3D/+li3ysprrKoYDGJEF7ESghkA5bfaiZJW1pA99yGL2ikG0oX3kqWao7WobDuKPCKqoW
 Pocrmy/y
 Dp7/WVIienctb9ge5Rb8kISwZT4k0XMI61bv9dn6fIFSC2z8Z20FJYKfaO/ajH6fsQGcUALg6AzIl0zfOnVUEecMKMEt+eHsB+Yry1GWmCxUNhtQzgaTQysrshooCAg7bH5teB0vSuacUfxb0rXaho41vS7IDsU+GDRcsOYFWo3++jlzY6RDE7o4fDrUyhfPU9tfwW6qBZnpThpMmUYhVW+etb7JNwAixbINXaR+xRmlSOWRyH046OzBBWg7p/pYvAzRqMU58Rq7tUedzQEpagrcYf1MX/tmiJ68fXUJ0oLMXGMjCu/XzOd6A7xvpcX6jJqkgZgJiBhdfbbklvsMGBJl17A==
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
 .../selftests/bpf/prog_tests/user_mem.c       | 112 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/user_mem.c  |  43 +++++++
 2 files changed, 155 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/user_mem.c
 create mode 100644 tools/testing/selftests/bpf/progs/user_mem.c

diff --git a/tools/testing/selftests/bpf/prog_tests/user_mem.c b/tools/testing/selftests/bpf/prog_tests/user_mem.c
new file mode 100644
index 000000000000..f301a1843706
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/user_mem.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+#include <sys/mman.h>
+#include <sys/personality.h>
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
+	return !perms || ASSERT_STREQ(vma_perms, perms, "vma_perms");
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


