Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74966C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 12:12:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BD0A6B00A2; Tue, 28 Jul 2026 08:11:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 294856B00A3; Tue, 28 Jul 2026 08:11:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 135506B00A4; Tue, 28 Jul 2026 08:11:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C16FD6B00A2
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:11:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 30AD61A039B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:11:51 +0000 (UTC)
X-FDA: 85038071622.23.6323D1E
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	by imf22.hostedemail.com (Postfix) with ESMTP id 83A9AC0009
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:11:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ii7Oz+Ud;
	spf=pass (imf22.hostedemail.com: domain of 3g5xoagkKCLgrYpslqYfsemmejc.amkjglsv-kkitYai.mpe@flex--tarunsahu.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3g5xoagkKCLgrYpslqYfsemmejc.amkjglsv-kkitYai.mpe@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785240709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c9jjs1g4NvcQ3GQcie84Y49TXK0CTcsSbKyhpxDCGHo=;
	b=QAzVgynEZkQCyW7zsmHBmqV1a42n6SWEeiVCEcxybd05F+pX4K4XunqEzzVFsqenk/QAlv
	nNaddrO60qXQhyvwkBlxU2NErmhUN5E7f9m8FzPd8zqA4HEcsKcXUaicPGtzYVqOnMzZlc
	ecb1hHYP09k9Npf3pYMCF67FKDTHtKs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ii7Oz+Ud;
	spf=pass (imf22.hostedemail.com: domain of 3g5xoagkKCLgrYpslqYfsemmejc.amkjglsv-kkitYai.mpe@flex--tarunsahu.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3g5xoagkKCLgrYpslqYfsemmejc.amkjglsv-kkitYai.mpe@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785240709;
	b=F2iv2j5P6bM55u22Ddi+rTsEX82AkvXs9+eek6Wja0Iuz4hXZ/tN7iIFFZdJoKJwsnDGC8
	TMfDsCZJ+TgYxESgdUqOE6gxD4MhKV0khIbQjUHZq9AH/yY4R45qJyScKYSHzzm2J3uk1Q
	BWKKHv0r50KVl4W7JQMxrxuk1EPBhxE=
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c15cec1ccb6so410269966b.1
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785240708; x=1785845508; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c9jjs1g4NvcQ3GQcie84Y49TXK0CTcsSbKyhpxDCGHo=;
        b=ii7Oz+UdxCha9n8znaFqeRv2n6cOiz2kJajsRPG2RXvivMvS4OS6kVhDzLMSJAoVrj
         1dTWo7BWIpR9BYoQSd2VBuaFww6cW6CHfVniFjHpxZ98DpB324ptPnao0aRCavs8yCRv
         emvNxGjq3NdhmrU0r8LjxbhZKpTXhCMdl4v5NkVt6daQKCGQaF3raHjOk/lmOhv0HN6t
         4g/XC2+V94tPt/7Ua8e/55cn8VvPoJn22hCfQIWozdM2gKwa49LzPivbEXUoyNFzkZ7S
         w7rHOD5p2udKEeuMNF4kG4K6xA2g2C/LBlQgpbYXVYrrsoiwcvSPsEI8EE5Wne71uLP9
         5M+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785240708; x=1785845508;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c9jjs1g4NvcQ3GQcie84Y49TXK0CTcsSbKyhpxDCGHo=;
        b=eVlw3YkXpVXPDyNxp7XPdtLpaaOnDtqhWaqfE+AiWDWkONAF4c5jPL3nZ6ncB1Av7D
         EuUM4EhMwJIBi528GRsxzrRLNV19KKbOiZVJqlvSqsJIRQPZAliRzPeQHr+jJuw5tSUX
         3IJjijnA4at/yeQTBSQYtCYqEUnL3LCW+Q1j51AME3D+YNey6HiB6/k648G+TP5HOKSI
         1jiVm0Gz7eGJ1/sZV4U8dw60ESRb4q9J3GHi2CEyPqe5YNs6YrMcmC4ZbXLih+MyEhFy
         Mq91lpnKo2QRnslNHW93lJOa1u7pj0JlyFLCgzFPulB5KWu8P6p6jR/WVxyCmUnoOkEd
         BRuw==
X-Forwarded-Encrypted: i=1; AHgh+Rp3C2sUqxr6N+y+bPeia+9NidoY1TG6hpjY+NPNACJ2gc4i2iYMLDYfz7OTctrNPBOjQhQEGX5fsQ==@kvack.org
X-Gm-Message-State: AOJu0Yxh85lRD6Si1bR0DGI5h8ieEcX5fJz3f916ZdaW7LORsBE22qI6
	0WQSwyayYB6C0m9DOnvB98wHBTkd0UOLu3eWXkYFUiGRWBaqkfYWjGKwrhx9IAed5fmrGTvp1C5
	1DQZzCbwouLlET3ujnQ==
X-Received: from ejph19.prod.google.com ([2002:a17:906:7cd3:b0:c12:8c27:d430])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:7b82:b0:c15:d6c8:2816 with SMTP id a640c23a62f3a-c1f71e1ea91mr103051766b.27.1785240707658;
 Tue, 28 Jul 2026 05:11:47 -0700 (PDT)
Date: Tue, 28 Jul 2026 12:11:33 +0000
In-Reply-To: <20260728121138.1103610-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260728121138.1103610-7-tarunsahu@google.com>
Subject: [PATCH v4 06/11] KVM: guest_memfd: Move internal definitions to
 internal header
From: Tarun Sahu <tarunsahu@google.com>
To: ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, seanjc@google.com, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Tarun Sahu <tarunsahu@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: linux-kselftest@vger.kernel.org, andre.przywara@arm.com, 
	michael.roth@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	will@kernel.org, vannapurve@google.com, maz@kernel.org, fvdl@google.com, 
	kvm@vger.kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	alexandru.elisei@arm.com, skhawaja@google.com, aneesh.kumar@kernel.org, 
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, 
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 83A9AC0009
X-Rspamd-Server: rspam01
X-Stat-Signature: nwrxytrr9czmcj18o8seqrys4qdee8ij
X-HE-Tag: 1785240709-288120
X-HE-Meta: U2FsdGVkX19Wynj9Svbn+SwfXw8wmpjQ5KbJnMieNKB3nG9Tma1QukFlMQuHoDiBkneeC+TaKmifRj/SB9n5q71ePNoTeNybpWcltKB/oPBOQbkBJ/71dGbD+BxVlOlyG9bfj7qgUn6ZNMPiCTZRThgyz5wWEVwG39RRrGneaPjV/7PQq4IHtHnu8DAnubAA1TOt41jeaai6GlpK9flZB5cO5OdfqjCCl8mns74MPsclT1eu+0CkUOLzhqBqAKTmZ6TlIHsqvlh9K+rr95p326puLN6VUq6MsLehYtNzt4Af/ojaQCLryoXbSf83P88ae8YFAip/Z3oDfxUpHDxzwDFKhf4I0qseMMjbJwdRpXHiAS2+caymHaZA9tb1+keyfXX7WJtpw5A4L9X716eojCMwkpTa51wFJvru8kD3ghEBLF6vxTVhRoiiyDAyvXSCMcBw0egAsR4NDvkSYb5/QhNrMqPi565mvFbQHAXD0IbF2/ai4VgRokvu/iPz2PLi1vg5NXUvdD6/ALfpKrJCv4Hox7Siiiy8dbYjGchE7f6q9zSMl5CNxBj6Qu79yQL6V21rJjtgzDN1FpAUKVlg2dwlmaOC6IiQ/0iGIvPgQodrWN0Kpl/tjlk29Jq89fM2p+DMtG5d0mlhReuGcbLzb43ww2CB8OICUwpa4byKpx1aIja7EqwkDWj72yXXmSHCa8Cyr9ifDdDXe0uvjsfzW+k6QF+wQ+8jttL+NyXDEhjZxLlr60B5rnFXYDllNUg6Uh7/7iszun6WSc1cIPaH9Q2rn+esOc/RqEQgKJSdGz/OH1rhkFSiTy0LZp3ugEL+5CMvi0fgbV+QlZYQacoCFCYQEdrLFylnFZ/d4rrZbWzoYdVc+/mKKBZobhzvjA9UA0O7HPPkO8YsKTiZJCLNxmOKQr8zvG2VvX5rnbz6sXHuqdDOFcO1UIIjXJ3eZs07Phw7By61Ocy63+pW19q
 jwiSj60N
 JtpbhC+StgKDsn0UUjAZreyzgbTsJJ2CcnsEUeOO3eLDKvLdGk8OQ3GsV0AJrOuMhxdeSoGXe77123MQtldkldrFIBu/e9wk9gL/McwsP7JwfghVpaxGmZrcpu8R5DpRXdpbjQR3YE9DXhuG8jDHXCG4Wt92hAK+Ocqha1WCLEFnhUJ3zpDQt7XrBpUO9LZnWv+hJOoWPQOhBOXOpOKwIe52ExMXgyGevy/01M+E5E9ERtqiGpyvTcbhBw7BwC4kb0dMSFyxRRuQGsvyh98HfkUmNjpd8TGgobMHVBUzgHk+h4fA9w5Kwm9ISFVF09Pr3TuqC42xbZt8UHabMQRXg8UODz5ocDijLOTlNkRHuEQ13kZYUxP9Xal1jN5OyMDBEL7PbTQS/Bxy0HymRlNbNzFR11Pzl2lLApUdZDN/4rFmCPezZ575FT4hwHzIQI3IGYb4Kn1WoKuYskbytglYmyyILpsCyzf3/h6MvQIb82cIwvzfHRV1C+LUxmRbFo99IOiMs9ws7XNb7Ej5c+iA0NX6Qc4FwWQrW6FY4lNdtJY/qpfXAxMDEP5/UMiO3G3AQrcnyNLz49uwIAYvirjZBJuDK2kPeLCSUjnOT9eZpC8OeWOB56ZSvFE25AnIiQqSNYvhvazYp4pdixGcd/X0EBdrw5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract 'struct gmem_file', 'struct gmem_inode', and GMEM_I() from
virt/kvm/guest_memfd.c into a new internal header virt/kvm/guest_memfd.h.
Also split __kvm_gmem_create() to expose a non-static
__kvm_gmem_create_file() helper that returns a 'struct file *' instead of
an fd.

These internal definitions and helpers allow upcoming guest_memfd Live
Update Orchestrator (LUO) preservation code to access guest_memfd
internals and reconstruct guest_memfd file instances from preserved state
without installing them into a file descriptor table up front.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 virt/kvm/guest_memfd.c | 68 +++++++++++++++++-------------------------
 virt/kvm/guest_memfd.h | 39 ++++++++++++++++++++++++
 2 files changed, 67 insertions(+), 40 deletions(-)
 create mode 100644 virt/kvm/guest_memfd.h

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index db57c5766ab6..dd84bba8974b 100644
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
@@ -557,23 +531,17 @@ bool __weak kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
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
@@ -612,8 +580,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	xa_init(&f->bindings);
 	list_add(&f->entry, &GMEM_I(inode)->gmem_file_list);
 
-	fd_install(fd, file);
-	return fd;
+	return file;
 
 err_inode:
 	iput(inode);
@@ -621,7 +588,28 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
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
2.55.0.229.g6434b31f56-goog


