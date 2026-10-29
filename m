Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52715606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 21:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MI+idkzt
Received: by kanga.kvack.org (Postfix)
	id 672DC6B05BC; Thu, 29 Oct 2026 17:26:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 649B36B05BD; Thu, 29 Oct 2026 17:26:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 560636B05BE; Thu, 29 Oct 2026 17:26:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 25FDC6B05BC
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:26:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A10F6A8091
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:26:49 +0000 (UTC)
X-FDA: 85376948538.18.485E61D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 12390160006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:26:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MI+idkzt;
	spf=pass (imf08.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793309208;
	b=U6xV7AOwg+l6qe2clrW4oYWvFY3qUo1TB/NbLyOC0Zvv4ZZxKzg2Iiv1N4ddb6UfcC4Vtv
	W1EQWmBTQXD25VKWafjfXtFGdvFd4jaGKsFvajruYbO/z1Rw+pV1HgCbdoON1wkgBadQrS
	+kn6oqKnt4f/0h0rBmm4KMO8FKPSLeo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MI+idkzt;
	spf=pass (imf08.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793309208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6GIXnWvCtigyBOTVDy1Tlr37tAPRJsMHaGhKWB8kSsg=;
	b=Hi6+PpipB03aPzDbQxkDzKGVbzn3Yjky0NNlMCBcuvHibGpijpLdMWWFfCJgJbfcQL5Co1
	ZM5dMMWt5+Vo4OnvxKtpuMh3VXFrFNEpg3T9wDCpmGdZ+q+A+dEZ7teHkyYDN0LABrtkyp
	gxcLhfUd/WN+Y+RAgjVMkSYIoo9e2UM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A0F57600DA;
	Thu, 29 Oct 2026 21:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC391F01816;
	Thu, 29 Oct 2026 21:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793309207;
	bh=6GIXnWvCtigyBOTVDy1Tlr37tAPRJsMHaGhKWB8kSsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MI+idkztAD8H4pfTpuuHr7kX8q3fLrNvou2lanQJsS5BAm2TIJmH1noglZiCDdZIb
	 X8IHfo/FOk9qbs3vLl6ZL2wqt0X6nniSUF24yBjItZPI21Sthn27Wb/aAraZSLXudj
	 DdiSv3FgiOvXj0k01dxw+1sPSa/Xg/hco2AhAnHK1TaFGUEKeDHJBH5GsSiWcgSzwA
	 yktgJxxkpokqWrzs8brRPniAKrXCpcBznKkcpATtHss6Tv++oT4AAsYWhpwEgPA0Ex
	 v+Of/IQGHZAYW9ejHFKaZ+auZfxoU+QJ4sebJlopnOsaV0FogWlLTHG1Ag7pBO4QDI
	 28BF1LnBf5GdQ==
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
Subject: [PATCH bpf-next 5/8] selftests/bpf: Test user memory mmap kfuncs
Date: Thu, 29 Oct 2026 22:25:48 +0100
Message-ID: <20261029212551.56964-6-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261029212551.56964-1-jolsa@kernel.org>
References: <20261029212551.56964-1-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ybc77nwjdjycon4czrfwztbqmox4xcj9
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 12390160006
X-Rspam-User: 
X-HE-Tag: 1793309207-575733
X-HE-Meta: U2FsdGVkX19BsvbEuWajwXloEzLTFhI2IKrxd/QKtXRq6X4HPDLSPfoCvGYmsgBUkrgJMaQRRGPjAFZXav5bL1B2/SGL6cvE2XnV6iBeZmYiInhw8XUHs9TYnSLNHMpKoqEAhzqG0Q1H+MmRjtVCu/XxyPH+DWHbfvw4lYLYpB2ygErSbnULVGVAvW/fBYjCaoQ/xj7U+QBT9XSTg4UWSsPAthf3LRXtXKTOMyDFf4DGWWCLK/v0jJavwnbJRLJmt1KjxmJl4rPNpitbOkBVtQvvAtybsdzpYvLGVmLcjbe5zYZoxyFLOHBlcfPKA6DRkjDmueRkgL+6Q9R7vtD/nKkpvQuOcDN7Wm776rQm7Y4KHRdiGL8V2FG+dvMFsUUvq15tl6oB6HdQ7/iZ/jY65svAW1olksKb0q11NO+2VFbO/zz8rRcTfZvMQIG0rxp3XqJlXGaKrttST3H1M7iEnSaWubBx4/MY1Q65qzS4FimdzsN0HrC0soTDnfQN2uZ6bfyWkJTovA3QPTbV3eonMRmAZvlVwjQI/FI3G+LwwF+jkZQu4b2zBLkYx7SSBrj9G9hWH4vQIVHc4zv0TZ887mNXSdPMaqbtKUIrqFnr74UppbxaFwQYwBSHg5AfwOx5Idj9P5UF3FAiDhwLSZwnEsMFCy5pVFa4xzdTl1g42hb1fOVTrzs5mTP8rj9gHqy3FCeRWA+Lf8sKgjfaBX07KKUS2XsvOW08bi8MBkhgpeOrmxKQwi6J8DqbiNH7g9rz5wH/sm+voIQKI6yQuHmkRpmT9frlkpcNZpj5MQKgn6Nj3yP+jh4ooa+gAiKdRmfj6v7KUGsEsNujWpAzZRDk+IVcwB44MG3sZcDE+7P95M/09iFWav7iLIzAJJm1niYDq5GUejPOPXE5QNDoGmxh5dW5y04CpDyVszNLo8t+Y9xEfHgaH1GrT0lOh2wVi/n3AUGHN740occ7bAqon+x
 EBmvIy0c
 1CP59IBDthoYMg9SleA+1xATFYutyc2zTfTj5vu2yWGaZeGASHGOaunG+DPOm3+Dl8Tw+YScNr6hmbmtgc7BrUc5rACaDRIHv1hudYsOuWkq0LhiCvj8wSpsCkXuZkFFuUUukdu4P7fFlEuuM8/sP71bLZ4MTXqtf+4cDchHp1zKbzLxIuTcQOxTuGZSZxd3cUxKDE4cnKBvgs8Tcpd/COPsFlPnwuCAeInIq1siPtG3dUCqZvvqpJ9JiSuHWXkATEn+b7fFwp0hnWULWOFEvk0mZ8KXSVCpDIxKzLjvSRnKWLNZOFmYtg2Gt7XbT/ISZsAPCHVeuc/izf16s2cx7uHfmNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add BPF selftests for bpf_user_mmap and bpf_user_munmap from a
sleepable uprobe. Check that created mappings have the requested
permissions and that unmapped addresses are no longer mapped.

Assisted-by: Codex:GPT-6
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 Documentation/bpf/kfuncs.rst                  |  17 +++
 .../selftests/bpf/prog_tests/user_mem.c       | 112 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/user_mem.c  |  43 +++++++
 3 files changed, 172 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/user_mem.c
 create mode 100644 tools/testing/selftests/bpf/progs/user_mem.c

diff --git a/Documentation/bpf/kfuncs.rst b/Documentation/bpf/kfuncs.rst
index d22b6bb3df2e..0c46c95d4918 100644
--- a/Documentation/bpf/kfuncs.rst
+++ b/Documentation/bpf/kfuncs.rst
@@ -989,3 +989,20 @@ the verifier. bpf_cgroup_ancestor() can be used as follows:
 BPF provides a set of kfuncs that can be used to query, allocate, mutate, and
 destroy struct cpumask * objects. Please refer to :ref:`cpumasks-header-label`
 for more details.
+
+4.4 User memory kfuncs
+----------------------
+
+The user memory kfuncs operate on the current process's address space.
+``bpf_copy_to_user()`` writes to this address space, including private mappings
+that are not writable. A partial copy is not rolled back if it faults.
+
+``bpf_user_mmap()`` and ``bpf_user_munmap()`` create and remove mappings by
+calling the kernel's mapping functions directly rather than issuing
+``mmap(2)`` or ``munmap(2)`` syscalls. As a result, seccomp filters do not
+mediate these mapping operations. A seccomp filter can still allow or deny the
+syscall that triggers a BPF program, but it cannot separately filter the
+mapping performed by these kfuncs.
+
+.. kernel-doc:: kernel/bpf/helpers.c
+   :identifiers: bpf_copy_to_user bpf_user_mmap bpf_user_munmap
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
index 000000000000..a6b4f922da49
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
+extern unsigned long bpf_user_mmap(unsigned long len, unsigned long prot) __ksym;
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
+		user_addr = bpf_user_mmap(map_len, map_prot);
+		break;
+	case USER_MEM_UNMAP:
+		ret = bpf_user_munmap(user_addr, map_len);
+		break;
+	}
+
+	return 0;
+}
-- 
2.54.0


