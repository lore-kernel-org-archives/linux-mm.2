Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F32D1CD8C81
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 17:08:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F3E56B009E; Fri,  5 Jun 2026 13:08:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77DE16B009F; Fri,  5 Jun 2026 13:08:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D1DB6B00A0; Fri,  5 Jun 2026 13:08:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 341D36B009E
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:08:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 02A4DA01E8
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:08:50 +0000 (UTC)
X-FDA: 84846493662.05.279A26E
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf06.hostedemail.com (Postfix) with ESMTP id 127FA180012
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:08:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fKfxsIHX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3nwIjagkKCIg5m36z4mt6s00sxq.o0yxuz69-yyw7mow.03s@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3nwIjagkKCIg5m36z4mt6s00sxq.o0yxuz69-yyw7mow.03s@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780679329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1s9Gl9n+JDRxm+uLKvGaoj9Iw7+lf3bKjXDLeITLpkQ=;
	b=IaMYjdbGOHj+KDY9oGvu8y5g1vcfgIAVNzHnknNNd5bae0sPOz6h3IaE/vz4gYXILNQz+G
	eHKhf3De+A3tr4KSTnWckFYhovuGhSfA8LeTPVFjwldlILlCYTk5uCHRXJnTrja9MoxB2S
	JXoUwaooiZNJ0DLct73LggfQdun0NTo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fKfxsIHX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3nwIjagkKCIg5m36z4mt6s00sxq.o0yxuz69-yyw7mow.03s@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3nwIjagkKCIg5m36z4mt6s00sxq.o0yxuz69-yyw7mow.03s@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780679329;
	b=YxJtC38UK5GaDwfM96xXVu4aFhL78YERDXPANhbqnQzNkREgVPZ4/ZAalUe2qewr6h4Io7
	5dmRiExNLIYItc8IobzfsnGWZgRHip3ilpJCZhJEWh+k1TVDFIzM44CJRvKqeS2XLQ1EDO
	g3G4qnQ74A3XkPN/3XnP1JtoiYTeVk8=
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-bec3fcb280eso25988666b.0
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 10:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780679327; x=1781284127; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1s9Gl9n+JDRxm+uLKvGaoj9Iw7+lf3bKjXDLeITLpkQ=;
        b=fKfxsIHXJOrqGQHBN/djcGKdRBPYeMjvXP1Qb2oUaTlMsPLe35fdVtCaSQ1E2lXYKl
         aGRwhF55tK/dp5kEifXPFdsPesvvm6sJgR3rTmVaux6L0MmJwh/BDB6a2b47lstdvPWw
         8TyY0aDTTQpgvh/rqdp8NyzCGN9n080G6WORdQatortE7o2Z3UOrQG7NsUkSsS7fFW5T
         eUUNgg7Iq66LZ5g3NhHe5tNiYOQUXNrXLFHisha3JxFztsV3yUWfut0q8mfKTxUjpSzm
         V0k+8o8IY54EqPA0JThgZil4KFir+y6P6jsEBlkxs65fm/eFHpeC8NBLfEs0oaM3KHuA
         up7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780679327; x=1781284127;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1s9Gl9n+JDRxm+uLKvGaoj9Iw7+lf3bKjXDLeITLpkQ=;
        b=RWHhod8C7OoErfyL7bx3ouZItD/wDRVREh1A+KPLZHTLxHPcuA9bMLQCHGHfFb1itN
         HSv4lwKyM3+Ay0vZACAWSdzsUUCAcj9CCnkR8pQQfymY9kco4oheFwvtZQByt+AAwJr6
         skcKwVaw7iLd5sWZKlMFeFUawtmLLrK7rYXHqD9arHYkn/h2g+jP07UODZiXqlB20XiQ
         lRBJTAtss4WFlExpDuangscm6xbG1Hilqz5ieUNmBiiNyCDCGAjy9fYrxVl2YKZFQaoj
         hTd4qOV2BSNu0prcaCfYyCMKejID8KahKEmRqRSsa859heJAoNzXV/Wkv/ciFlSbG3W/
         rq0A==
X-Forwarded-Encrypted: i=1; AFNElJ9fGtap2mMFWQwmSDIfXjYcyshrFBuB3El9f6NK4Ayscb+16DEor7aMYN8owsAInav6XsW+m6ePxw==@kvack.org
X-Gm-Message-State: AOJu0YzkEsi0NbN/dSX1Mc32ALXLOVF4RUULzh5x7AKzwcEhRbF0Qt/R
	3wZWs62LrIMjjfHNVGMv88we9c4gaDYg1pgVFraAyeoFoOjwBzc6qrJMdEV1U19XJoL54kbYgPj
	Pe9cFnzrrPl4o55TrwQ==
X-Received: from edty21.prod.google.com ([2002:aa7:ccd5:0:b0:691:5097:3e07])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:f59b:b0:bed:6e53:bb1a with SMTP id a640c23a62f3a-bf3749d1646mr252719466b.48.1780679327271;
 Fri, 05 Jun 2026 10:08:47 -0700 (PDT)
Date: Fri,  5 Jun 2026 17:08:30 +0000
In-Reply-To: <cover.1780676742.git.tarunsahu@google.com>
Mime-Version: 1.0
References: <cover.1780676742.git.tarunsahu@google.com>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
Message-ID: <769d0adac847d638fceb3fce093755a74e686582.1780676742.git.tarunsahu@google.com>
Subject: [RFC PATCH v2 05/10] kvm: guest_memfd: Move internal definitions and
 helper to new header
From: Tarun Sahu <tarunsahu@google.com>
To: Jonathan Corbet <corbet@lwn.net>, vannapurve@google.com, 
	Tarun Sahu <tarunsahu@google.com>, fvdl@google.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Shuah Khan <skhan@linuxfoundation.org>, sagis@google.com, 
	aneesh.kumar@kernel.org, skhawaja@google.com, vipinsh@google.com, 
	ackerleytng@google.com, Pratyush Yadav <pratyush@kernel.org>, david@redhat.com, 
	dmatlack@google.com, mark.rutland@arm.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	seanjc@google.com, axelrasmussen@google.com
Cc: linux-kselftest@vger.kernel.org, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kvm@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 127FA180012
X-Stat-Signature: soudx5xpy1dhwy8ctpzax911r7rn5ti9
X-HE-Tag: 1780679328-101654
X-HE-Meta: U2FsdGVkX1/Rhpk2fYPUC/TNgUXuARU32DUJa0UqEFJ9I0pNWjZvISTpeqTp3vddIlOPRII7MDQqOOOPCW5pbTBcKXebpfHwlTlXRo/U46AW99L4BWpvwo6ly0areZiGw0ZyuWvHd8jr9zm4kLUGoxfNtSvCONOt3X6bp/gjfk6LL951+1DFhfNa7iF9v2igrHSBOGusfI1fIcxw+ReH4Cm6AinVZkUbnyvy5BmDCMOBv4HADcHrwjRpB+Clr/1us9LpTwYGLNMUQdn1Lf9JvU28Taq54OUQ1nefwSA41LimqAlQ2JM+Dtvu3njDzqlkcXaOEUCWvG1wZ94qXGeopM/qUZc3BcCccsyMTKtj15yQLAySkgZzG2JkCOzeSQeBOwixxIKCLHWVoebr1ycwv+03/q0PFGvDqZfg9afgyD57sQ8ZO0XcDbhvmMDJSPRqlA5swmxuk51dQdlDEeYHjWvll/cP7bE7obYAA3e4OGrJdKqhwB4PDHsTFrG2tRH28XmKNLB41paWlQx9EWL/TdJYFt6VfCwSRIRBDgnzvl6bec5HRpUYL/dzJ/FQsdvJUYyKzTw34huRChtqyBys1SDKhjNIy91c2lzOeKle8mJgfCMOsFQVO1bPq8HJ1T3HdH7rvfiOGOAA29NNhfu9AMZD4DlfmxopcDpVtpTsOOxn1HZnVD2gplB5MG2pPn+V3ujn4ayVOOUET9FDSL9p/224kv/IlHlgeIP3Gl1X7pz7xORK57epL+63fluKSDUANjlzX//1hrDvX/wdmB/DGe01O4D13MUCAM/3Stk4BfD2F38J++Xdcjbz7yM/ujVRpo1LVjBpHVcqpVAPHh73vbIFWyYEMUldgCRTwDKMWdHCr+omx5vub99+eKE0JgPjDjQyUZXz/DTWQWoAo9aHf+3v83CloQA++43qJMxfnIuA/tf2zsiAFSF8wndVLar6iznB13C2r4irASG7+Sy
 fuO0mWL5
 /3fhc8PgUTmkHZiupSQVlBB6R2AIWOocGaNZIYAf/BRww1lpY1MDBeqh7dMP6jVL52HHgUFHQl5T/y6dAPqUax4b4rv4DsDzu0MDeNW+8R/Q89oW3BegIJ697h9b/bs4fsTgSq89ayr5mh+ktCBxSbqnYQHqAthruZivq6CJ1DAo2aldRL3QkBuxDyjRCo9cB8yg8dG4icLsQUdMnyv1wpNwebb1MXQVg8XBmCJ+7FeQbEgg2sVlG5iJKvpAxLe3l6mversRz0dMVrPYv1oU3QPDT3yTZPJI/TFRkQG27PIBQvS3UdxlJcnmQx3LbLPiUKpcvst0thNUyIIm7uirb+EXICDzLpf2+0LTacMAbF0IlvlyXa0TF1kyA0uc/Hmzvrr9nDy2g5NUirRHRh76BHijz+yjXeVSh1LRa+KAXm0J2/YcV/x+O4MjbbJ6kvdaf28t0+4Sic3YGp5Gq60l1LVyBD8pSdUb6t8Pxgnsww0rdLaMxPE1Zfh9ZveXY1lCGb3qWAF3+ur0bA3i9yxunwMiCTDwA4CPaPznafbq0Kke7kYFJvlDuFAJ0+xbhS5wVVY1pQq2IcFrTdavo4qYpW3vO3O+qXnZK6NmhvaFEaLbbmB9Vezntg3+FVwYSdD36LIuO3uKWNJe2YWSzMfqIyGqrJyYE05HcejaRJvFB4HmgE9Hr8brseq3UucJcJHROmux3E7jyFF4BtzE=
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
2.54.0.1032.g2f8565e1d1-goog


