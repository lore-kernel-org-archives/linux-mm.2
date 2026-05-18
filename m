Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61A43CD4F55
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 09:36:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2EE56B0098; Mon, 18 May 2026 05:36:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A91B06B0099; Mon, 18 May 2026 05:36:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A8336B009B; Mon, 18 May 2026 05:36:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 844466B0098
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:36:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4C4911A07E2
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:36:51 +0000 (UTC)
X-FDA: 84780036222.30.AC12B27
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf30.hostedemail.com (Postfix) with ESMTP id 649F78000A
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:36:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fmrxXEKc;
	spf=pass (imf30.hostedemail.com: domain of 3r90KagkKCOwhOfibgOViUccUZS.QcaZWbil-aaYjOQY.cfU@flex--tarunsahu.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3r90KagkKCOwhOfibgOViUccUZS.QcaZWbil-aaYjOQY.cfU@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779097009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XKCrM2P1AyKOpet4Lptlcq4TPub3FnQxmPnAQcRZa6A=;
	b=X9QnHlbiTEAHSfzOnevkuZw2/F3iBbTDKTpOFFwLP2BfovDtMj1G7r4KlMXTWZtHZuvQDg
	8hQRGfqxAoCpc/kenhrFYhL8XLQOkyKtswQLpdmTXJdDS6CQHTigKvIFtWfzX2BIVewhP5
	ZQdBOqO7wep9xaku4WkdLWSJ+iWzV8Y=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fmrxXEKc;
	spf=pass (imf30.hostedemail.com: domain of 3r90KagkKCOwhOfibgOViUccUZS.QcaZWbil-aaYjOQY.cfU@flex--tarunsahu.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3r90KagkKCOwhOfibgOViUccUZS.QcaZWbil-aaYjOQY.cfU@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779097009; a=rsa-sha256;
	cv=none;
	b=LVnwAdatHLm3eE8IBA0UXs5ubyZkF2TTUET7CPxIPe/1SyNng3FFESWhal21t/KzH48G7U
	/fmTRdPbsHm4yYnCuch0Bx96FYFFkG0V3y/11HQWNSWafdRk+ruCsspbnH762Z68KLeXsf
	vgRctX2iDcO071Y9a3xKbHck94Yjq+I=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-449dcfe8005so1708445f8f.3
        for <linux-mm@kvack.org>; Mon, 18 May 2026 02:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779097008; x=1779701808; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XKCrM2P1AyKOpet4Lptlcq4TPub3FnQxmPnAQcRZa6A=;
        b=fmrxXEKcgXiH5nNk6RL4ielNwC/cFnmXakD0sTYLqa498e7kRn/9WUZxtxXEGh6NKR
         5YsJFIiYpw/v0uEbgiOzgkgAHbgH7EFd1dtH8R346OXnl8hPAzReyL7G+bjdX0XzFbp4
         Fs2wYJsZ74Yhe8TRpqQxA1eQiCtEFc9tyoiKqwyA18PVUcUB68Xut70seAj8yZJ9hZxj
         WFzhxYQTQpUPLx6SBGjSPPvUZrX+SHRxko3CasOA9MYyuhQN/sKv9x6YPpuY4Es0QOIj
         3XDJHDf7S4P+0IuSkYCWOQABe/4arCpNKFUfv86TeqAR3X2qXj9zdmF866FbhGDS3kT+
         euiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779097008; x=1779701808;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XKCrM2P1AyKOpet4Lptlcq4TPub3FnQxmPnAQcRZa6A=;
        b=SBwr/6kiH5zsp6YWVobzo82diEDYXCm6LYmJnHIndQstKkvF0mLNhukNeihfgomtAs
         ZTL9XsQLZvx74kiowyjY5p/FGwWNLlRWU1YwM3Qe+4xDupkoqFPFN99f30If3rOyv6sa
         crhKu4R0Kidg0NVgbwvbhijs4s1CcSjHYU65cNUFc10jQ5zjDoskjD5593BOK7X+SLVi
         cZF5tjDJXu6ojLqkysn7bVyZQWGTeQWy4jl7wg9GVfxByRZV4bhmAKtrn0Fys0qte+Mv
         fw/Pe6R+pAe1QDGllv7CJN3qUWecyt8UoKPDL+SbCh/YAVtRli/qBeaILdiBXMvpOHuo
         P0SA==
X-Forwarded-Encrypted: i=1; AFNElJ/jqXHBeUu1N1KTTCI3vB4KxxeD4Pand13zJhJDvFLzaSagXbaKly+8wNO65mAO6J4zlg2CNRPYHw==@kvack.org
X-Gm-Message-State: AOJu0Yw81IuLDim8vyE1pIDU9Dl+toU9lEAqqr7Jti1gIHoDgLqvrMVm
	Dj3aNYVqPTLJpyZfUZyjEC/7ynpyyCpl6m3hKSMWu/l7+O04WWK96matftYf9cj6bXYjL5wXbjK
	Ebbqr/SNycWct8QHXGA==
X-Received: from wrbdw3.prod.google.com ([2002:a05:6000:dc3:b0:43c:fe6b:f318])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e47:b0:48f:e1ac:c94f with SMTP id 5b1f17b1804b1-48fe60eb0ebmr237233615e9.10.1779097007184;
 Mon, 18 May 2026 02:36:47 -0700 (PDT)
Date: Mon, 18 May 2026 09:36:35 +0000
In-Reply-To: <cover.1779080766.git.tarunsahu@google.com>
Mime-Version: 1.0
References: <cover.1779080766.git.tarunsahu@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <7ffc1fb8962fd27428ac3e2f3d8950492597e03b.1779080766.git.tarunsahu@google.com>
Subject: [RFC PATCH v1 5/9] kvm: guest_memfd: Move internal definitions and
 helper to new header
From: Tarun Sahu <tarunsahu@google.com>
To: axelrasmussen@google.com, mark.rutland@arm.com, skhawaja@google.com, 
	Mike Rapoport <rppt@kernel.org>, sagis@google.com, Jason Gunthorpe <jgg@ziepe.ca>, 
	Shuah Khan <shuah@kernel.org>, ackerleytng@google.com, corbet@lwn.net, 
	dmatlack@google.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, vannapurve@google.com, 
	Pratyush Yadav <pratyush@kernel.org>, david@redhat.com, aneesh.kumar@kernel.org, 
	vipinsh@google.com, Alexander Graf <graf@amazon.com>, David Hildenbrand <david@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kexec@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	kvm@vger.kernel.org, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: akmkggndyr4mowija7anndumpabrueyi
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 649F78000A
X-Rspam-User: 
X-HE-Tag: 1779097009-972315
X-HE-Meta: U2FsdGVkX18Re8z+5dYXjLPx2z4nNOxJC0bxd1eOd1evvDuu1q9bfhA+p5e7E3ZYTIj2d2HBzEZB9qQQhzO+NN31Krrgqku6Sden5Xs/x2u6pvrTTGisMcTq8lw/M0ba6oht6OYVh35Yxbfj8cq4iV+mI0q6ohlMUmv8IViphZQWx3pJ177H8f94TQL2kB3ZtxZqTqRBoCcjCRT0ImwZLdL/UUqK1+5fF06Sspc3qoDiQwqinVADwr3GCbR3BHw0ExPZQ5cqO3WxDMqg2xNhuuUIjfBeaU0U+6BktdICe05+4YT2XLbk4ZHKA9MCf3hVZck3FSpwanvDp1O9EbxY9vNKRc9dN0b4zyOOHCgBXzTGgkwUyhlGEuVimgntZG6yoo69vXzFxVkhO+1L1dec7O5CboeLqhRcsqf1/YsGYTfqaRB9YNnWxKZfbl87teoYzcaJI8GPed90Dj7j/iogfXE8/fKWcwZ/YsrOGsDVVKNk3GOc5D/Ze1+R+BC53QyDzAGPLVhj9YDshImJenF5VmpEJLjYEq82QBOduAMRKqFAUAkn6WWQq8lYxN/2frDSEe4DQr9QfcjhIE/sowBE4xnaG1lMHlqfa+UrQqpd32BQNt2S1xIAEbzojFIIeByGRdoxw5aEH4Qjv+FsXbDsaN1nrng9XV9WQaMdM4Cd5hCdLP8fd6leD6uNw8VkhCaoSe7HaEFVHHtSdEThGmCJRlj1Q/AlkIalx6ZMaIXXNKwQZ4EocbBgg4ZxRGXMEHWuYpnzTn8cBz5unN3ftSyw3q5s9jVkpMk51y8Lf/B11gQCD1cJ5tQbNREF+bgh+S5WemayyZJZ02eDH9QilxLV43WfYTVYN3lRkAKmqt0fl1KSJLckN6tNc22ia4KrmUTrgj5e0AtUt1ii0fdZxOArolhb6SqWniXwHOlc0rJiO6cuhchIVv1ZZjAaKyBKSvmDm7v1bk9lDr61x+1bJpv
 mLKKkf/l
 E+lMkyC9+sRIBvc39rP1XBRYH5TqOO0PehWzIVOyuqUr6x1YQhgREWCd4TJ7/1Rh2one2tMDzFBqiuCdCS19K+wOkQLzpKcQqIaGFfvzjJf97eGuqlKzKU52k3tPMEvwRH8xLlszKP/bitugPhG4sPoLyMRGwoiSjRly1Wk+kWyl8pFP/r7ThcJL695DwfA8XSpuqsrBvls5iwrGTXrc9v0uvnp5UFaSlefwIpCfzuAXdKzLuQpEWhAsdw46ySrP0SIUdMKaTERh/9ilXGvUIkOq4UMPPZ7lyxSFJvlYPcd6pu/2Jb2GhdPxAistYYNJZReCIuYshBEaXkHfQ3cUqBom1DFDsWlmQf1gcQn2nRnkOeqFOaib7Oflek9qGtLWmA7g7ZfrvSNSjYlKPL8uH26UrIcdS/moUK5GR/e3h34qBi5Qhwc6EarVn2reFaWuc6aO8lAB9/f8+gFMR5VDN3GRPwwZ0pRGq0aIXM1e+bsDYVqM4mc2ePIXArSGDmP9cNPgpd37SBhCnmrdhT407bycsUbK4E748bt6YBuGWy+cASjrWJD0gkHIYp+CMn3X1gyAiAhtFMK3t2ofAMxB72thwmF2kcjNkQ99gOa/MNo5o4OQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To support guest_memfd memory preservation with LUO, guest_memfd luo
code needs to access guest_memfd internals and reconstruct guest_memfd
file instances from a preserved state.

Extract gmem_file, gmem_inode, and the GMEM_I() helper from guest_memfd.c
into a new internal header virt/kvm/guest_memfd.h.

Additionally, split __kvm_gmem_create() to expose a non-static
__kvm_gmem_create_file() helper. This helper returns a struct file
instead of a file descriptor, enabling file creation and initialization
without installing it into a file descriptor table.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 virt/kvm/guest_memfd.c | 68 +++++++++++++++++-------------------------
 virt/kvm/guest_memfd.h | 39 ++++++++++++++++++++++++
 2 files changed, 67 insertions(+), 40 deletions(-)
 create mode 100644 virt/kvm/guest_memfd.h

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 69c9d6d546b2..6740ae2bf948 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -7,38 +7,12 @@
 #include <linux/mempolicy.h>
 #include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
+#include "guest_memfd.h"
 
 #include "kvm_mm.h"
 
 static struct vfsmount *kvm_gmem_mnt;
 
-/*
- * A guest_memfd instance can be associated multiple VMs, each with its own
- * "view" of the underlying physical memory.
- *
- * The gmem's inode is effectively the raw underlying physical storage, and is
- * used to track properties of the physical memory, while each gmem file is
- * effectively a single VM's view of that storage, and is used to track assets
- * specific to its associated VM, e.g. memslots=>gmem bindings.
- */
-struct gmem_file {
-	struct kvm *kvm;
-	struct xarray bindings;
-	struct list_head entry;
-};
-
-struct gmem_inode {
-	struct shared_policy policy;
-	struct inode vfs_inode;
-	struct list_head gmem_file_list;
-
-	u64 flags;
-};
-
-static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
-{
-	return container_of(inode, struct gmem_inode, vfs_inode);
-}
 
 #define kvm_gmem_for_each_file(f, inode) \
 	list_for_each_entry(f, &GMEM_I(inode)->gmem_file_list, entry)
@@ -556,23 +530,17 @@ bool __weak kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
 	return true;
 }
 
-static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
+struct file *__kvm_gmem_create_file(struct kvm *kvm, loff_t size, u64 flags)
 {
 	static const char *name = "[kvm-gmem]";
 	struct gmem_file *f;
 	struct inode *inode;
 	struct file *file;
-	int fd, err;
-
-	fd = get_unused_fd_flags(0);
-	if (fd < 0)
-		return fd;
+	int err;
 
 	f = kzalloc_obj(*f);
-	if (!f) {
-		err = -ENOMEM;
-		goto err_fd;
-	}
+	if (!f)
+		return ERR_PTR(-ENOMEM);
 
 	/* __fput() will take care of fops_put(). */
 	if (!fops_get(&kvm_gmem_fops)) {
@@ -611,8 +579,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	xa_init(&f->bindings);
 	list_add(&f->entry, &GMEM_I(inode)->gmem_file_list);
 
-	fd_install(fd, file);
-	return fd;
+	return file;
 
 err_inode:
 	iput(inode);
@@ -620,7 +587,28 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	fops_put(&kvm_gmem_fops);
 err_gmem:
 	kfree(f);
-err_fd:
+	return ERR_PTR(err);
+}
+
+static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
+{
+	struct file *file;
+	int fd, err;
+
+	fd = get_unused_fd_flags(0);
+	if (fd < 0)
+		return fd;
+
+	file = __kvm_gmem_create_file(kvm, size, flags);
+	if (IS_ERR(file)) {
+		err = PTR_ERR(file);
+		goto err_put_fd;
+	}
+
+	fd_install(fd, file);
+	return fd;
+
+err_put_fd:
 	put_unused_fd(fd);
 	return err;
 }
diff --git a/virt/kvm/guest_memfd.h b/virt/kvm/guest_memfd.h
new file mode 100644
index 000000000000..c528b046dd69
--- /dev/null
+++ b/virt/kvm/guest_memfd.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __KVM_GUEST_MEMFD_H__
+#define __KVM_GUEST_MEMFD_H__ 1
+
+#include <linux/kvm_host.h>
+#include <linux/fs.h>
+#include <linux/mempolicy.h>
+
+/*
+ * A guest_memfd instance can be associated multiple VMs, each with its own
+ * "view" of the underlying physical memory.
+ *
+ * The gmem's inode is effectively the raw underlying physical storage, and is
+ * used to track properties of the physical memory, while each gmem file is
+ * effectively a single VM's view of that storage, and is used to track assets
+ * specific to its associated VM, e.g. memslots=>gmem bindings.
+ */
+struct gmem_file {
+	struct kvm *kvm;
+	struct xarray bindings;
+	struct list_head entry;
+};
+
+struct gmem_inode {
+	struct shared_policy policy;
+	struct inode vfs_inode;
+	struct list_head gmem_file_list;
+
+	u64 flags;
+};
+
+static inline struct gmem_inode *GMEM_I(struct inode *inode)
+{
+	return container_of(inode, struct gmem_inode, vfs_inode);
+}
+
+struct file *__kvm_gmem_create_file(struct kvm *kvm, loff_t size, u64 flags);
+
+#endif /* __KVM_GUEST_MEMFD_H__ */
-- 
2.54.0.563.g4f69b47b94-goog


