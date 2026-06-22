Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 877EECD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 18:54:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABFFA6B009E; Mon, 22 Jun 2026 14:49:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A97386B009F; Mon, 22 Jun 2026 14:49:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D51C6B00A0; Mon, 22 Jun 2026 14:49:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 06EB76B009E
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:49:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DFDF316549E
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:49:08 +0000 (UTC)
X-FDA: 84908435976.27.ADD2611
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0F28640005
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:49:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RohXc72g;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3oYM5agkKCOYbIZcVaIPcOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3oYM5agkKCOYbIZcVaIPcOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782154147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vrCK2iLTFuPkCKKXsEtILhMjhO8cYkJcRVq4TpiCh/Y=;
	b=5x13pRSmQXFbGnn7GDZm7f8Qac6/y9BDtsVLw9N/q3s6y58LGB857huKqLfNAuMt3JEZ3M
	sDeynZ6QcMrQxXZIHAmmSyBBZuA2ECBejBMhKMEmMlRoBtw0XAZ7eG0LUMr+qs1uF4c3tT
	WLuQFo3IrNm2JIqXgRZ23vmrI3XWxCs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RohXc72g;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3oYM5agkKCOYbIZcVaIPcOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3oYM5agkKCOYbIZcVaIPcOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782154147;
	b=tdRZ5uxkaz11eTmK9+IZK72WZA3A5h7VuUjcQFPAV00ik9u9FMttFRu7Z55T3D0MPSLyWg
	zT+P9ZWv5bQqNAY9BT7gAlxHqeynIsudzIPXW0g885jyXJm8cIlnGEMxPa8wz5x25ohBbi
	vhXtIt5lLje00kSlm/46JGAF2z+V/Gw=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-6960fb32b73so4305981a12.3
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782154145; x=1782758945; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vrCK2iLTFuPkCKKXsEtILhMjhO8cYkJcRVq4TpiCh/Y=;
        b=RohXc72gqV/jRq7mASFABPisXK1EfhX3oiCpbt57YbJh1MDv1z88wDQiM/2qelBCDq
         Iqqco+XT6Eh5+Hhy2DKgooAeSHDnvni9JugUUEzR5uA2ITEV194crgPSmJHhqbrqVI+6
         EOYrnv5/aj3Q/95c9Abg8JhKOCWtTB2zLP3swjIF09wBbRoXJnY+iUBtCdjC2hlAQarw
         t70owRimg1vIPLOIMqKw54/CHeFRAUVPGUHa2QNR9dRQWA4H2HLVH+wLT7LWIvGLXtjg
         Hme/SGZCQZbsaVDvz7Gs/1k2i1NK9l+YQwZaiIxlFvR/XmkppqY81gZTVFVAD3Yz+Gyc
         UQGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782154145; x=1782758945;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vrCK2iLTFuPkCKKXsEtILhMjhO8cYkJcRVq4TpiCh/Y=;
        b=oEQK8F2FQoVO9d3vA2nKoDEEuoSJwBjYl7tRxxV7IsuTyCfY22GpKysJQigVOGXM9v
         H40TDCYJ+D64VxnK052WXITutNNjT4Fg1drOymLg4nBqP+/NEOApsqODjSgmRwom1KiS
         Gu7VeJG1AD0EJQVO9ThgXeAkWcu0/ffUD+i/SsJgNUaT5hw7CPB0BRSaKPwiUNJd9utd
         6F6VZT4bAhfDVQn4evrSg2cQ6ZgYLHxTbmlfqxGVq5aBClUf/M9lyzq6zyg7N7MxtPK9
         JIERP9034On7OpXXt0M4vzjDnfJ9ZQw+mYMgvfos43tWI0236JPzjOwDSaHVbZctWUt6
         M5gA==
X-Forwarded-Encrypted: i=1; AFNElJ9VaiYv6kwy7Sd9eCfc0YqlQfIGlvJrMN6Oy3VQ05VEzfBQ7h4ATgrzOoD9XAlchskEFnIHa4BWgg==@kvack.org
X-Gm-Message-State: AOJu0Yz5gCptl+MbIWErYoeUfqyTbuL7FOaC0n/wCX7Pys6jprXqLvId
	9yTJskTjzdrR93kIzhgLjPc0Oszy6Nx7H+FhrXRN4bCcaZxCQV6qQvTrP+XHQ7sK0vf8hCUfIlT
	lhVUPN/8+DNzeg6h8ng==
X-Received: from edsl17.prod.google.com ([2002:aa7:d951:0:b0:695:f6a4:adb4])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:35ca:b0:697:bd1d:116d with SMTP id 4fb4d7f45d1cf-697bd1d14acmr2221698a12.27.1782154145133;
 Mon, 22 Jun 2026 11:49:05 -0700 (PDT)
Date: Mon, 22 Jun 2026 18:48:46 +0000
In-Reply-To: <20260622184851.2309827-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260622184851.2309827-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <20260622184851.2309827-5-tarunsahu@google.com>
Subject: [PATCH v3 4/9] kvm: guest_memfd: Move internal definitions and helper
 to new header
From: Tarun Sahu <tarunsahu@google.com>
To: Jonathan Corbet <corbet@lwn.net>, Mike Rapoport <rppt@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexander Graf <graf@amazon.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Tarun Sahu <tarunsahu@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: xkejzrkr879hq4qrhtobhnyqa1brp1dq
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0F28640005
X-Rspam-User: 
X-HE-Tag: 1782154146-234698
X-HE-Meta: U2FsdGVkX1+OxFLUZ8lRwaVstsPLlWgCpWW/nyJPCLO6Zs1CQo67ZUPe9XNmHd+n7zJF4x6udnGk3Pfyg1cDcy4jeDAogJx+gRpLxDmUQx5jAyBknQ2nVBpOzZEWtVXxY8lRLHeCsSwLEE6cUA6hpo4ZVAmO8xDKSaBHUOXqCcXC06fesXwCGY3KOOaFCjLCx7EU6bwvzdpQJyucSIt6iNrzUKR454n0J16nYnYUHkLQDVTxPKzVqQemFye3PpaW61cTADXlj9nn6wxlpq9BO9ps3NuJtTchEGQHJbXTCBcR2b+JGUlnXpgACEbxC4QYKJDC3EO9yh9Is5LFdAJ9rAq4mLu3J+Yv80gA8ug60gJepXOjPAlRcCwg8P1vZ3Xc9MMS6hYX0+nnIMWBblbHzYiZj+wvRutApUNVUNZzdE8wAsLV9IcuWQbz9o0YpH6HBydRv9ZGOtTxDbYVHBxA4sHipsmj35KLz94lcML/kDy17o5bfcg71WDKJ+u2+Ivn5LMIokzWI6ofPDuf5ISED9SF+eGnRDQn6GsPjnaNmsPIBnC9y8i8UPx76mGgZFlnmg/ZJzocybnMpEqPPAXobUALJ3JsOwxM2s3mp5Qs6V+7007+91/vmQNEgtmn+IST0MiusqhMggPG20/V6071xyej5Igop/xQ2MSWG+6Kw/X6ypVXHPrlns+va29Y1WFeTvBHXA0nhp3dCtf7N2DVSCg+p9U+h95zJDkMh5/Gt5A4xncBFi6R89ilp6qMWVlXFlsF0F5ANct+hz925ebq2FnLu2Iko2bH0Qn4tAJdn+rHnr9FW1qJbANtw8R5Nd55GLImi04O6jycS4flq34Q+pmDpQcnZrFX3ZouWIJ4HHyJvMHpoRzNOvotPZRENzD+QgsXj15/xWxM4yaFsc2ulrRuUu9Kkw1O7Xtkr14509e25gt+kBdulGc1qw7sawp4MNtfXsCW9iaiB7fMroi
 Pkiuu7Hn
 yap3E49XQTtBt4l9DLeUeh+J9ocaNjXZV2lBE/lF5A77BnPiMeDw1JsK3/ZLHDdbQA65I5uFcxCFuXDZiCJWoejxD0sVp9rWXRIzrDFFCeahR+siGFjIFGY8TZHf8jJm+gh2VlIZRtmgio73ILHBGmFbdlusqODWHmWDtdHhZdN/pes0+WPb5RTFyJGmK6h+edFUG9bEF+VGthRwKzeR1MTpctlBjp4ICnuFBEsJTq4v44WqzstB4Ohl6IgqP8ysQEvn1kK7Q2BN1h6FalFlKsH6hCKAbaaAOS6ofjn0h8XnlROe8UWCTrtQjrrq76anm7VgirsPyvc+XcQMlWwRHz8uc/Pv4FBmBmJGtqKSgbOshq0KJWvTjFU9OKvAYRcVvua2/Be8vhDXS3iX7zUOZj9C2tIG+Yxkmma05bEmdkLfsqLLS2iT3HJUCphg3qkdHNP440Q5lEWA+LsP2fddXxn7Bdxx8fsl8tPZdfijN6T/2d7sxACGGp5htSUMubGSj+WbnBPSeI3Nyo3DWMl3xXxxuBhM/7PeFB3eUTFPWnZoCIZL8x0xCd2DWXSFsFBy6eKVyxkVmXqjJ9aD6mov9EvZQDKLsqqkQXBwDrpK1uic3iMw=
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
index 8669068..fe1adc9b 100644
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
index 0000000..c528b04
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
2.55.0.rc0.786.g65d90a0328-goog


