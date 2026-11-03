Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94837606A329
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 07:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PPokuCDD
Received: by kanga.kvack.org (Postfix)
	id AE18E6B05B4; Tue,  3 Nov 2026 02:59:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB8976B05B5; Tue,  3 Nov 2026 02:59:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F5716B05B6; Tue,  3 Nov 2026 02:59:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7038F6B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:59:43 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DA210C02FA
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 07:59:42 +0000 (UTC)
X-FDA: 85393058604.07.EA3B7B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 41C32A0005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 07:59:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PPokuCDD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793692781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kTuGcIteEqEwnuaNPnc0lU8d/jwRg+rXZ9+e+l9L8iw=;
	b=wbldBvxYvaMx5WwUSuRNxXZ9gl7FLGTuBECTuMH8D/bnG1+YL1IXFb9Xr1PlgS1Rowih51
	FdxE/YAKlRSyWHCIasaBnN3GQUlqA71wMv82jf6j4WD7xThWpbGxQqqT59B2WbAsD3V0Ax
	SJs8uuUX0WWhBbPTFxqmZnVbRDc6s9E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PPokuCDD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793692781;
	b=hs5wqB378GOmLvLc4NK4fgUJDg+lCISJUbt1cM0cZtAwhTNE6pwcFhsysyNZizeRQDDu7A
	5V1mr8/Fr4eVYhhHydNKCzydYoGix4xVvAMlsM6fiWTakAJJ5wqsHRPk1F2d/JETX1WSpo
	7pMHL/EI71tzXC1FjES2G2p9WNA2LmU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9704D41A20;
	Tue,  3 Nov 2026 07:59:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23D71F00919;
	Tue,  3 Nov 2026 07:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793692780;
	bh=kTuGcIteEqEwnuaNPnc0lU8d/jwRg+rXZ9+e+l9L8iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PPokuCDDr/Cg8JtLuwb42+uzxIlRCApqcb9eaJw9Z3MLmv3giUww3E4Gjm9kD98YI
	 SQh59BB27xYDwoZWZ+a/+fjNNP+WxoIAD+Gecox2ToAsfBEUiHrh3oNjU+mwgoUrea
	 wcXZrCfbWueYrIGwJCheG4ZNMwBESvlaUXvMEsGh8GwqqP5NU5RFsOmtex43Fu0GW9
	 iNK0fvUGDWe4THub9wtY+oekTU40Di2Kx8J5iZJLVfPr6AP690/d9/PDMQJkS0kDKT
	 YiBbotYxuB3oYP7NrPfmQNPivZUTPxdfg5SoOGPngtq9AbDLSX53Kt//biXIUntcLP
	 oDNl1Y3v7bBfw==
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
Subject: [PATCHv2 bpf-next 2/8] bpf: Add user memory kfuncs
Date: Tue,  3 Nov 2026 08:59:09 +0100
Message-ID: <20261103075916.100050-3-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103075916.100050-1-jolsa@kernel.org>
References: <20261103075916.100050-1-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 41C32A0005
X-Stat-Signature: q9gkkotg6kgbfjmzo87hs63rn5b5s6mg
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793692781-100665
X-HE-Meta: U2FsdGVkX1/zUDcUew/4Tq5lF3sZwecoIgyAEr5JBWSq7p5wVGda+tH1aIopu/MzFDUaRePnArsF7KpWSjCfub3m+T0cNjtbun+xHgrxMCS2tBPxB6AOb3Hp+qjaeBsD9UKRkvnhUkryc6CJvjOxpCohnE1kzJxCU0GnPONXMKIfUVkoHOpzSdwiE5BkwlbAD+tuYhGQCSgXgm+VctjcjosfHGr5Ln6AH6Cpt1wVXHgdRyFqIPBq5rfISTV9P3xe9x46NH1moLyZpLuYRk9aE1eR8yV1D76XE+ptkyE0k/CKi9QQhsPwNwPHSLEsTfWLibn/Kd9n7qDgweXTV6ZtkKGjlMmU7D35JL9Sayj+R5G3mkxA74x20NiGN+jdixyWVqYhtcoLiqvPj0l+M6uVQU9EWVCZ6ck9CNyOTrLhvEaRrsT6QLjDHZrhGNPHUeV7gJclG5zXKjrqwMmf6vQLOgllwc1c85a7h+lgagCwJDuIO9vrJKscm9G0SfDG/YD3MEI1J5jitD58JasseAEPNCamuxnzkxX6jZ8CUih22JvNugR89I8m4qBxk428/JvTQjrgLH4QtCzkiVIEYJhyn5GGLcZv3QJMDBVGOTp9ZlvgoDQmwgjHd5ZtDh6PpBlIbaPI/gtmihfDCJT2F/Z4jkRHaccVcIbuCKDYMba/nMNAGP6rKx8Q87XxxPZUiFCnoGjfTimErvUeNFbmrzeg9hIXvgx8VtkZLfRjUCCdLMxnhNBDzm1IkGGq6zOPgqreh40cVontCIlPfYMFrRzQetV1U9eG4lFoHleGpU2qatxonfvznaHk+pO6CGAvYBcoAt3Pg2Lg3MUVIMyb9KkYltTn724VN96qDK4rwAzjpvLYDVgwNpXYUH/l8ZxOP5VUhbhSCmJEKSyvtODrpqwhPborltyTNC8pHx9FbuZxqQXaOWrc0DXdAJXaZDQWpNs0KkIgA1PqbH8PSvWcAGD
 PmnTcUwR
 MEiONVwAUf5z+GmU1mDRn/kqFHIyCc2LO1+tpzD/pLldgp+uwW8na3zZqf0ega+OUyNYEoSxN8t01XZ9N8WFzQjNziha2J/Ao5xDh2FK6nNUDFkNq1nLejSi0+ApFWKhuyA/+meonR+gqBWMdATAHtc/+XF1FgnpUwA4NiJi05RcyiCbN3SVRcMJt1LpcB/XrevTrslEvdBY5FBIkX8sVU9IB3VZgzL5vfVI1+NVCUDIrlMYvQyF6cxp8kX4vlYpUQcfuztdzPDkSHzUMd4FOy36Rt1Lt2oNwvkT1nNfYtddePWMPro+mNn6WKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add sleepable kfuncs to copy data into a task's address space and to map
or unmap private anonymous memory in the current process.

Require a usable user mm for mmap and munmap. Register the kfuncs for
KPROBE programs and gate them on CAP_SYS_ADMIN BPF token capability and
the BPF_WRITE_USER lockdown check.

Use FOLL_FORCE | FOLL_WRITE for task memory copies and return -EFAULT
when a copy is incomplete.

Rename the syscall info-copy helper to bpf_copy_to_user_buf to avoid
the name collision.

Assisted-by: Codex:GPT-6
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 Documentation/bpf/kfuncs.rst |  15 ++++
 kernel/bpf/helpers.c         | 132 +++++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c         |  10 +--
 3 files changed, 152 insertions(+), 5 deletions(-)

diff --git a/Documentation/bpf/kfuncs.rst b/Documentation/bpf/kfuncs.rst
index 73578a4c3b1f..8ca7aad8ea36 100644
--- a/Documentation/bpf/kfuncs.rst
+++ b/Documentation/bpf/kfuncs.rst
@@ -965,3 +965,18 @@ the verifier. bpf_cgroup_ancestor() can be used as follows:
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
+``bpf_user_anon_mmap()`` and ``bpf_user_munmap()`` create and remove mappings
+by calling the kernel's mapping functions directly rather than issuing
+``mmap(2)`` or ``munmap(2)`` syscalls. As a result, seccomp filters do not
+mediate these mapping operations.
+
+.. kernel-doc:: kernel/bpf/helpers.c
+   :identifiers: bpf_copy_to_user bpf_user_anon_mmap bpf_user_munmap
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 58e357302850..ae7dfa58ae95 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -29,6 +29,12 @@
 #include <linux/task_work.h>
 #include <linux/irq_work.h>
 #include <linux/buildid.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/limits.h>
+#ifdef CONFIG_IA32_EMULATION
+#include <asm/thread_info.h>
+#endif
 
 #include "../../lib/kstrtox.h"
 
@@ -3741,6 +3747,110 @@ __bpf_kfunc int bpf_copy_from_user_mm(void *dst, u32 dst__sz,
 	return ret;
 }
 
+/**
+ * bpf_copy_to_user() - Copy data to the current task's address space
+ * @unsafe_ptr__ign: Destination address in the current task's address space
+ * @src:     Source address, in kernel space
+ * @src__sz: Number of bytes to copy
+ * @flags:   Reserved for future use; must be zero
+ *
+ * Faults in the destination and writes the way ptrace(PTRACE_POKETEXT) does:
+ * a private mapping doesn't have to be writable. A partial copy is not undone,
+ * the bytes before the fault stay written.
+ *
+ * The caller must coordinate with other threads so they do not execute the
+ * destination range while it is being modified, and ensure execution begins
+ * only after the copy completes.
+ *
+ * Return: 0 on success, -EINVAL if @flags is non-zero, or -EFAULT if the copy
+ * fails or is partial.
+ */
+__bpf_kfunc int bpf_copy_to_user(void __user *unsafe_ptr__ign, const void *src,
+				 u32 src__sz, u64 flags)
+{
+	int ret;
+
+	if (unlikely(flags))
+		return -EINVAL;
+	if (unlikely(src__sz > S32_MAX))
+		return -EINVAL;
+	if (unlikely(!src__sz))
+		return 0;
+	ret = access_process_vm(current, (unsigned long)unsafe_ptr__ign, (void *)src,
+				src__sz, FOLL_FORCE | FOLL_WRITE);
+	return ret == src__sz ? 0 : -EFAULT;
+}
+
+/* bpf_wq and bpf_task_work callbacks can run without a usable mm. */
+static bool bpf_user_mm_ok(void)
+{
+	return current->mm && !(current->flags & (PF_KTHREAD | PF_EXITING));
+}
+
+#ifdef CONFIG_IA32_EMULATION
+static unsigned long bpf_user_vm_mmap(unsigned long len, unsigned long prot)
+{
+	struct thread_info *ti = current_thread_info();
+	bool compat = test_thread_flag(TIF_ADDR32);
+	unsigned long addr;
+
+	/*
+	 * We are not in a syscall, but x86 get_unmapped_area() paths
+	 * ignore TIF_ADDR32 and rely on in_32bit_syscall().
+	 */
+	if (compat)
+		ti->status |= TS_COMPAT;
+	addr = vm_mmap(NULL, 0, len, prot, MAP_PRIVATE | MAP_ANONYMOUS, 0);
+	if (compat)
+		ti->status &= ~TS_COMPAT;
+	return addr;
+}
+#else
+static unsigned long bpf_user_vm_mmap(unsigned long len, unsigned long prot)
+{
+	return vm_mmap(NULL, 0, len, prot, MAP_PRIVATE | MAP_ANONYMOUS, 0);
+}
+#endif
+
+/**
+ * bpf_user_anon_mmap() - Map private anonymous memory into the current process
+ * @len:  Length of the mapping
+ * @prot: PROT_* flags of mmap(2), including PROT_EXEC
+ *
+ * This maps memory by calling vm_mmap() directly. It does not invoke the
+ * mmap(2) syscall, so seccomp filters do not mediate this mapping.
+ *
+ * Return: The address of the mapping on success, -EPERM if the caller has no
+ * user mm, or an unsigned-long encoded negative error code, as returned by
+ * vm_mmap().
+ */
+__bpf_kfunc unsigned long bpf_user_anon_mmap(unsigned long len, unsigned long prot)
+{
+	if (!bpf_user_mm_ok())
+		return -EPERM;
+	if (!arch_validate_prot(prot, 0))
+		return -EINVAL;
+	return bpf_user_vm_mmap(len, prot);
+}
+
+/**
+ * bpf_user_munmap() - Unmap a range of addresses of the current process
+ * @addr: Start of the range
+ * @len:  Length of the range
+ *
+ * This unmaps memory by calling vm_munmap() directly. It does not invoke the
+ * munmap(2) syscall, so seccomp filters do not mediate this unmapping.
+ *
+ * Return: 0 on success, -EPERM if the caller has no user mm, or a negative
+ * error code.
+ */
+__bpf_kfunc int bpf_user_munmap(unsigned long addr, unsigned long len)
+{
+	if (!bpf_user_mm_ok())
+		return -EPERM;
+	return vm_munmap(untagged_addr(addr), len);
+}
+
 /**
  * bpf_copy_from_user_mm_str() - Copy a string from an address space
  * @dst:             Destination address, in kernel space. This buffer must be
@@ -5142,6 +5252,27 @@ static const struct btf_kfunc_id_set generic_kfunc_set = {
 	.set   = &generic_btf_ids,
 };
 
+BTF_KFUNCS_START(user_mem_btf_ids)
+BTF_ID_FLAGS(func, bpf_copy_to_user, KF_SLEEPABLE | KF_PERFMON)
+BTF_ID_FLAGS(func, bpf_user_anon_mmap, KF_SLEEPABLE | KF_PERFMON)
+BTF_ID_FLAGS(func, bpf_user_munmap, KF_SLEEPABLE | KF_PERFMON)
+BTF_KFUNCS_END(user_mem_btf_ids)
+
+static int user_mem_kfunc_filter(const struct bpf_prog *prog, u32 kfunc_id)
+{
+	if (!btf_id_set8_contains(&user_mem_btf_ids, kfunc_id))
+		return 0;
+	if (!bpf_token_capable(prog->aux->token, CAP_SYS_ADMIN))
+		return -EPERM;
+	return security_locked_down(LOCKDOWN_BPF_WRITE_USER);
+}
+
+static const struct btf_kfunc_id_set user_mem_kfunc_set = {
+	.owner  = THIS_MODULE,
+	.set    = &user_mem_btf_ids,
+	.filter = user_mem_kfunc_filter,
+};
+
 BTF_ID_LIST(generic_dtor_ids)
 BTF_ID(struct, task_struct)
 BTF_ID(func, bpf_task_release_dtor)
@@ -5269,6 +5400,7 @@ static int __init kfunc_init(void)
 	};
 
 	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING, &generic_kfunc_set);
+	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_KPROBE, &user_mem_kfunc_set);
 	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &generic_kfunc_set);
 	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &generic_kfunc_set);
 	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS, &generic_kfunc_set);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 02ed5368f056..9004f2673ccf 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3932,8 +3932,8 @@ static void bpf_raw_tp_link_show_fdinfo(const struct bpf_link *link,
 		   raw_tp_link->cookie);
 }
 
-static int bpf_copy_to_user(char __user *ubuf, const char *buf, u32 ulen,
-			    u32 len)
+static int bpf_copy_to_user_buf(char __user *ubuf, const char *buf, u32 ulen,
+			       u32 len)
 {
 	if (ulen >= len + 1) {
 		if (copy_to_user(ubuf, buf, len + 1))
@@ -3970,7 +3970,7 @@ static int bpf_raw_tp_link_fill_link_info(const struct bpf_link *link,
 	if (!ubuf)
 		return 0;
 
-	return bpf_copy_to_user(ubuf, tp_name, ulen, tp_len);
+	return bpf_copy_to_user_buf(ubuf, tp_name, ulen, tp_len);
 }
 
 static const struct bpf_link_ops bpf_raw_tp_link_lops = {
@@ -4031,7 +4031,7 @@ static int bpf_perf_link_fill_common(const struct perf_event *event,
 		goto out;
 
 	if (buf) {
-		err = bpf_copy_to_user(uname, buf, ulen, len);
+		err = bpf_copy_to_user_buf(uname, buf, ulen, len);
 	} else {
 		char zero = '\0';
 
@@ -5710,7 +5710,7 @@ static int bpf_task_fd_query_copy(const union bpf_attr *attr,
 			if (put_user(zero, ubuf))
 				return -EFAULT;
 		} else {
-			err = bpf_copy_to_user(ubuf, buf, input_len, len);
+			err = bpf_copy_to_user_buf(ubuf, buf, input_len, len);
 			if (err == -EFAULT)
 				return err;
 		}
-- 
2.43.0


