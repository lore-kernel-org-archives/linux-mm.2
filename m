Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7340A606A323
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 19:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aaHL1atm
Received: by kanga.kvack.org (Postfix)
	id 872406B077E; Wed, 21 Oct 2026 15:58:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84A856B077F; Wed, 21 Oct 2026 15:58:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 786756B0780; Wed, 21 Oct 2026 15:58:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5907E6B077E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:58:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D1A401A0662
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:58:54 +0000 (UTC)
X-FDA: 85347696588.14.4F1BA77
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2B1B140002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:58:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aaHL1atm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792612733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jn7cYNwO2EebwQTtuyF9ZBF5UX2UIlTQdb3hKPwxsNE=;
	b=BbcxX8zFjGqQabY6ThbMaiaxa0BdvziHP3penFoCAKrGgHo86QVKtSvqMApGx4KKFD6GJY
	7coJdAiPK8lOs0tiNowT1uu0254P+bJ2Iz5kyk1l8KD7Xipip3Xz1LvOzITlp/cQHXdJGR
	qFL9ojao17OCioeieiYJSHouCvtTW3c=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aaHL1atm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792612733;
	b=HWCPN60I0oNG6FoQMRLJmwADgJMx0ZWPdtNnE7yuWhP7LH5XHcqzybp742w1FtIiXho1zk
	OYWOgyJbLMXO7XKfQTemLuJo6a02RZJiyKLxMKgtitIld0H/5k/Qx2mzc5m01cHZ4UxpcH
	RRWsCYwOXBrWPrXu/cPiD+B1ID1R0ts=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7227F4152A;
	Wed, 21 Oct 2026 19:58:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F92E1F000C1;
	Wed, 21 Oct 2026 19:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792612732;
	bh=Jn7cYNwO2EebwQTtuyF9ZBF5UX2UIlTQdb3hKPwxsNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aaHL1atmE35nyOxsUVNKx824WP2YE1bRZTN24CLskPsbTsMWv0Rz9Py4LeD8cjWqo
	 66nb6382hQ/iBEApI8d2qsL8uF29CgIVtpX0xaOtMR7TXdGzKLpPMJ+jX87imjE19m
	 J/Z+W87/yHp3kROLG6lX2G/JwT0CD7qukSJX0OVlcdVYGnnVIn+2+20drOKW1AsT9W
	 Q3x8NdIOw3DULa1TNc2wXHxMlFMDtA/xjO3vXoEZxRzr0rDf6aIL8Mc6DX6RMuCEUX
	 v/tqtQJNknxoXBjfuENl5NL7QiuXMUcgXGQQsZYQjXIPNnTtVoA8EzTIpR1AtSDLN5
	 D27bG18iA+sIA==
From: Jiri Olsa <jolsa@kernel.org>
To: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>
Cc: bpf@vger.kernel.org,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kselftest@vger.kernel.org,
	Shuah Khan <shuah@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>
Subject: [RFC bpf-next 4/9] bpf: Add kfuncs to allocate and seal user pages
Date: Wed, 21 Oct 2026 21:57:53 +0200
Message-ID: <20261021195759.119421-5-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261021195759.119421-1-jolsa@kernel.org>
References: <20261021195759.119421-1-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2B1B140002
X-Stat-Signature: giuwrr7wei6f48zp4edd8md5tkt3sig4
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792612732-910004
X-HE-Meta: U2FsdGVkX19ql1s7FIASjlRcrrYDdJ4W65yjlhym6QUhreeGvEvxN1Zr7rTTBHSIDuwkRzWWmP3F2D+vaKVuLhS4yqorteP2QVqhHUPOmTeSQkK1e8Du8M0HC18g3jsbfZOHCsl/9P4nQaNUNRAIYdPWCx1abAhsF5Bl5zY8FyLAhjBd1L/3OlRt3IdIypisYC5+GZo6D4KhsheSxaq02TwWcahG1+qlv7jfETgHby2FO5p9SjEs51a8nkxm8xaAgGrQHOlpLml87jPKXHBYCnHX4XmWUc9qA4Iesu8SqG1wWX08PNYWYsRkdXGiqU4O5mwQU7IpD2AunG+EEglhV2xn+TBb+8rF8CynCFMQVrv0ulQs9E/+MwMA4camS//7vD8YTrXZ/m2FUhR/ZcNhi+vz7f1ol0bIAHu5bIyeye5vXCc8Tv4QTDGiT9c/7WTI8GKelxqCkJyhzgivemh27inI4woi7Z5eQtvGpQbf6LxyJmrCD3NLoo0BcrD8R+NlBalF34lu/GA47NR2qk8DVkyQnD6BfP85zL+9gWzcvlD9LMG1AioVO+fKuXf4CY8u3NktwD928uS+X8A9t/FJPTh8twoi66ERTnLsmuMIuMzmfNOBvu67Av2VN4Gtn8I/4t7jRpVhkvJ2VTNM272usr087pBb7mQAszkLhs9i2Q3u2hjHT23dP2j3vTg2n23QMsS+U80Y3k3pQ6UHRa0YpSQ+d8FvQmNjuDldVgbCBpb9nz25mmNtsw+sDHDJWqlt6Q/CbdjyuKRMY9E5fkxFbOanMfsrGvO9g/E/EWPR/GSdp0FmltKyaONcBeSuhNDO8eLh5h73yxLp6NtpdvY1Z3zlFH9KwmTf6RA33YkD70RQUfgtLrlC5yrIqg1IGZjj0ukc+MSzZQJdI8qMLPAC0mdSr4n5nrCrgC7gB+/BwXN9mYRcQdxe+98ZX3rITtZsSaUr0jszC5a0GRQycBp
 WQb+L/9D
 IWMitkZVjvWYpMg5PwZDAJKzwJuNAg62efAUjEPmenms2pN66G/+cQBfRzL+56X3GuvqERNKDOfzyZ2A0GpJzjQnKFJWY0YenotqbephQ+yIXaAe4tZpg6K5DgyOz2N7do54lbnLg/asvGAWM080Taurrgo4HKD9j5jki97VAXh/Pp1xb81DqxpLYxsuKGf91ItVtKJBP9icqDmDIyCFAavzK6XqRmLz22+Fr/0ExoBTBUXblMzTle8qLM1o7vcqM60z4VGQoFzj/jEe/ZbcMFTHIElPPiYu7wmMHOqcSLIETtuZbEO/UBnzZm48qivQ7zvyPIwrKSyQ78Li58Z8YpjyCeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Adding sleepable BPF kfuncs for allocating anonymous pages
in the current process and changing an allocated page to
read/execute permissions. The mapping remains in userspace
until it is unmapped or the process exits.

It's allowed only for sleepable kprobe type, which technicaly
means only sleepable uprobe.

Assisted-by: Codex:GPT-6
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/helpers.c | 127 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 127 insertions(+)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 4d9e9423826a..246f4969a144 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -29,6 +29,10 @@
 #include <linux/task_work.h>
 #include <linux/irq_work.h>
 #include <linux/buildid.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/personality.h>
+#include <asm/cacheflush.h>
 #include <asm/tlb.h>
 
 #include "../../lib/kstrtox.h"
@@ -3739,6 +3743,127 @@ __bpf_kfunc int bpf_copy_from_user_mm(void *dst, u32 dst__sz,
 	return ret;
 }
 
+/* vm_private_data token for the unmergeable anonymous mapping below. */
+static char bpf_user_page_marker;
+
+/**
+ * bpf_user_page_alloc() - Allocate lazy anonymous pages in the current mm
+ * @nr_pages: Number of pages to allocate
+ *
+ * Creates a read/write anonymous mapping in the current task's address space.
+ * The mapping is kept non-executable even for tasks with READ_IMPLIES_EXEC,
+ * to avoid creating a writable executable mapping. The physical page is
+ * allocated on its first access. The mapping remains until userspace unmaps
+ * it or the process exits.
+ *
+ * Return: The userspace address on success, or a negative error code.
+ */
+__bpf_kfunc long bpf_user_page_alloc(unsigned long nr_pages)
+{
+	const unsigned long prot = PROT_READ | PROT_WRITE;
+	const unsigned long flags = MAP_PRIVATE | MAP_ANONYMOUS;
+	struct mm_struct *mm = current->mm;
+	unsigned long addr, populate, len;
+	struct vm_area_struct *vma;
+	int err;
+
+	if (unlikely(in_interrupt() || current->flags & (PF_KTHREAD | PF_EXITING)))
+		return -EPERM;
+	if (unlikely(!nmi_uaccess_okay()))
+		return -EPERM;
+	if (unlikely(!mm))
+		return -EFAULT;
+	if (unlikely(!nr_pages || nr_pages > (ULONG_MAX >> PAGE_SHIFT)))
+		return -EINVAL;
+
+	len = nr_pages << PAGE_SHIFT;
+	err = security_mmap_file(NULL, prot, flags);
+	if (err)
+		return err;
+
+	if (mmap_write_lock_killable(mm))
+		return -EINTR;
+
+	addr = do_mmap(NULL, 0, len, prot, flags,
+		       mk_vma_flags(VMA_DONTEXPAND_BIT, VMA_DONTCOPY_BIT, VMA_DONTDUMP_BIT),
+		       0, &populate, NULL);
+	if (!IS_ERR_VALUE(addr)) {
+		/* VM_DONTEXPAND prevents merging this mapping into another VMA. */
+		vma = find_vma(mm, addr);
+		vma_start_write(vma);
+		if (current->personality & READ_IMPLIES_EXEC) {
+			vm_flags_clear(vma, VM_EXEC);
+			vma_set_page_prot(vma);
+		}
+		vma->vm_private_data = &bpf_user_page_marker;
+	}
+
+	mmap_write_unlock(mm);
+
+	if (!IS_ERR_VALUE(addr) && populate)
+		mm_populate(addr, populate);
+	return addr;
+}
+
+/**
+ * bpf_user_page_exec() - Make a BPF-allocated user page read/execute
+ * @addr: Address of the page to change
+ *
+ * Changes a writable page created by bpf_user_page_alloc() to read/execute.
+ * The page cannot be made writable again after this call.
+ *
+ * Return: 0 on success, or a negative error code.
+ */
+__bpf_kfunc int bpf_user_page_exec(unsigned long addr)
+{
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma;
+	struct page *page;
+	int err = -EINVAL;
+
+	if (unlikely(in_interrupt() ||
+		     current->flags & (PF_KTHREAD | PF_EXITING)))
+		return -EPERM;
+	if (unlikely(!nmi_uaccess_okay()))
+		return -EPERM;
+	if (unlikely(!mm))
+		return -EFAULT;
+	if ((addr & ~PAGE_MASK) || addr > ULONG_MAX - PAGE_SIZE)
+		return -EINVAL;
+
+	if (mmap_write_lock_killable(mm))
+		return -EINTR;
+
+	vma = find_vma(mm, addr);
+	if (!vma || vma->vm_start > addr)
+		goto out;
+	/* Allow to change only vma allocated by bpf_user_page_alloc. */
+	if (vma->vm_private_data != &bpf_user_page_marker)
+		goto out;
+	if (!(vma->vm_flags & VM_WRITE) || !(vma->vm_flags & VM_MAYEXEC))
+		goto out;
+
+	vma_start_write(vma);
+
+	err = get_user_pages(addr, 1, FOLL_WRITE, &page);
+	if (err != 1) {
+		if (!err)
+			err = -EFAULT;
+		goto out;
+	}
+
+	flush_icache_user_page(vma, page, addr, PAGE_SIZE);
+	err = do_mprotect_pkey_locked(addr, PAGE_SIZE, PROT_READ | PROT_EXEC, -1);
+	if (!err) {
+		vma = find_vma(mm, addr);
+		vm_flags_clear(vma, VM_MAYWRITE);
+	}
+	put_page(page);
+out:
+	mmap_write_unlock(mm);
+	return err;
+}
+
 /**
  * bpf_probe_write_user_faultable() - Copy data to userspace with page faults
  * enabled
@@ -5171,6 +5296,8 @@ static const struct btf_kfunc_id_set generic_kfunc_set = {
 };
 
 BTF_KFUNCS_START(user_mem_btf_ids)
+BTF_ID_FLAGS(func, bpf_user_page_alloc, KF_SLEEPABLE | KF_PERFMON)
+BTF_ID_FLAGS(func, bpf_user_page_exec, KF_SLEEPABLE | KF_PERFMON)
 BTF_ID_FLAGS(func, bpf_probe_write_user_faultable, KF_SLEEPABLE | KF_PERFMON)
 BTF_KFUNCS_END(user_mem_btf_ids)
 
-- 
2.54.0


