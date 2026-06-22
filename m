Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB638CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 18:50:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A09F6B0093; Mon, 22 Jun 2026 14:49:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 678416B0095; Mon, 22 Jun 2026 14:49:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B4C86B0096; Mon, 22 Jun 2026 14:49:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD7646B0093
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:49:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 34A9B8CAE4
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:49:06 +0000 (UTC)
X-FDA: 84908435892.02.5FE0C2D
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6018D1C0006
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:49:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gUyGdnJO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3noM5agkKCOMYFWZSXFMZLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3noM5agkKCOMYFWZSXFMZLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782154144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YDKxILlnDw+5iaEcF38F4xHpKQ3yBx+LqMsoNxfSVAA=;
	b=ENoIDSiqFWrOIAi5D81NE1Iub8e/qjz5XOjHaf0IGIN+tNvo34uyNd2WM8ELyV5hgUn+fm
	wn0/reuNYtG/8DqySJxj1VAa8STFHpP++OeFoorg+K9Iy3ZJwTmdYuAs5nBJc5UmDDeTaP
	MA1Miewm/v1SbsF51yH/Xi7390EQYT0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782154144;
	b=Pf4KPq0iRcO/ta26nhGn614elfJCncSmQRbj/p9bodWNFEHMWBnpibolzhZFpwXZkNwnS1
	L8T8Q8qwktUv/2P0OrxPOZ3z6tDL97a0jHS/DSXXZni+1ciWNErJLFfUUEqHLDmv/vuas+
	vKRnk6FAqCq4JEhgvWatPUZvwylj7VQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gUyGdnJO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3noM5agkKCOMYFWZSXFMZLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3noM5agkKCOMYFWZSXFMZLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--tarunsahu.bounces.google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-c0db30ce19aso158392866b.3
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782154143; x=1782758943; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YDKxILlnDw+5iaEcF38F4xHpKQ3yBx+LqMsoNxfSVAA=;
        b=gUyGdnJOQuxaQ/EhHMR+zYa/P5wnk66SbVpmms/Gbu2qrBi5g6qu8h03Bpaa3YlFgM
         PgvdVjjLm5rKlhCv2pT3zOeixydUNtJeoZJ6B+fmNJD+M4LBZcGdGnG1PqWI6WdZSXOa
         zB9HLSC2jADC2919nPybaHl0rcNr7xvsZBykkCs2qPp5I0G/vcD4HwJRkqV5fvm+HpTz
         yaiWoKxwF3LbA9DgjDvsiob9BMMn9EGU7P3kMVJPWYqrSma9HTcAqdrzhpXwOThIp37w
         i6d0/niF0H5rvLkXfbDHvZ+nvgVt/fWSXOTA+4/3ZhQJK8lWpBxRjaTz9z8jfJUzmeio
         enNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782154143; x=1782758943;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YDKxILlnDw+5iaEcF38F4xHpKQ3yBx+LqMsoNxfSVAA=;
        b=c1LanLIa2mjyKAenBZVNh/hK6bZh+ZywEmVYHgrnc7jCnL4xo0ah3Qriz+OfVr24aq
         Kek7/Xz8wb7m+siieHOXfJrvMQgFI2xI+ffOnnWwpP9wA2vCKnFTE/hOBBX+nJ63Arli
         1jHvSOMnRYXcwJrdkgcL93sCggQ3fQaw34lLMOF0IwSmuA7HFxGsMsZh88FiYFCd80cV
         ewLJJAkaz7hKw46b5qO0univHQEJoGTDsLo6FKQW/U1NExhhRQPfu69rB1DNoMBR/s/u
         7JOiM9pkpu35wgAKzmbov9QRzRspiB1wSBfbayGwCTgRVNqXE7THaEBk7DjT8b4T9IxF
         SE7A==
X-Forwarded-Encrypted: i=1; AFNElJ8jWTatA/BdDe+v/S6zWK4Gds4MLXpk6lVbY59aXFAzbbM1UY6ZjTnUvGRusb4EhHhW48yR5Ej4qg==@kvack.org
X-Gm-Message-State: AOJu0YyPo4odpw2dhNra8I0jQ/f+9C+nAWQln4bLJ2B5oj/Q8uax2Dhg
	e5TlScZfXvtnEmOZbVNf/CY+0buU98Sr7y8CDTKiIzBOx01t93JSrL+CoxIRDjjgn3CGfCUser+
	V4wUoRazO/xJNvL15Fg==
X-Received: from ejbbw14.prod.google.com ([2002:a17:906:c1ce:b0:c04:8986:1578])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:3583:b0:c10:1030:fffb with SMTP id a640c23a62f3a-c1010310402mr69033166b.12.1782154142415;
 Mon, 22 Jun 2026 11:49:02 -0700 (PDT)
Date: Mon, 22 Jun 2026 18:48:44 +0000
In-Reply-To: <20260622184851.2309827-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260622184851.2309827-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <20260622184851.2309827-3-tarunsahu@google.com>
Subject: [PATCH v3 2/9] kvm: Prepare core VM structs and helpers for LUO support
From: Tarun Sahu <tarunsahu@google.com>
To: Jonathan Corbet <corbet@lwn.net>, Mike Rapoport <rppt@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexander Graf <graf@amazon.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Tarun Sahu <tarunsahu@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Stat-Signature: 3dysb3pztrydw6f7meuf1mkeoqut4d8u
X-Rspamd-Queue-Id: 6018D1C0006
X-Rspam-User: 
X-HE-Tag: 1782154144-700268
X-HE-Meta: U2FsdGVkX1+q+JfNJvscOOjy+baY3Qs5J8sDbW4fWvCZQEmNIMQye8s0gWWC/llfna//MEhK9wICMeGRnbmE4QWs0lfqYPbJ5yLzSYLI0Fprm4LoM29qHs6GkAICiqD9aptjQ+ElvWsnylSymUOq+jj6R2ptqdcKT/Vy3Apucc0cnlOZClQGwS3hEtntJ5Fv5WaELmydGcMRveak6YXPquEP5DyMC3wRIztf52PO3MI7s7TGWbTe3o4x62U1KIrYG9KHoTNJ69q8deC+b492zusSLPIvG5Uo+jIfF1ht5O0MSnVpvwGDPPfuggf4toQB9blDMur2cLXkMeKT0nMmreVYtVqLSWNElapTI7mCbseACB5ANH4YI4+X9FEy/oeGrkfngSBV9NYEPVCkhXgrRHyAC16reFc0QrlzR4YczlMx+Sgo7fZuwzu3r8Kiy+oCkHnR7qQ7bAyDxpot8Wb8l2wNmr4gtB1/wk1lR7BWV0PjBy/0p9or8LJUQQlzg32Mio7n4TAItl7juKwcR47V2OHU57hfgbVYLaDNuBfa9G78hXUdnou89AO5LnNaaz9ec9xg27TXdnh7HzvvD64/ydi6JapGRG09lQzvhznWUjDK2Fpe9jHhg/GvBTSDEqrPnRkHWZCwtyOsEjY2jwj76wVHSkndVY8wYYMarXBO1iVS+YW1KFG6/vZjtqWZ6BYLbZKeYYlli9rXBZxEVPtNbATycoK3sAySn51sq8O48gzGZ74qLG99ZzDe6wymCEos9cqMzqTnDntEYZ242szM8cg0qqNowSyv80/J0MtOcDxaMrXJafiSYn1HKAeIbbYYn7o5P9IrT4xe94I5ST2ilFMdBby5BvfxRpBDejNXji3HO1Dx2wXYlDS8GIJWzOVaPVBi4HQyWoVwQckSMu/qS6ZvaWMzs37oRwG9JiYLV0P07oZ+j8cfIPKWR75e1j26LGi7v8ufICCErD20JDR
 LTm+x4+1
 GfDYGOXRlNmRUy//vB2Gmqd5/FqvtZ3dTG41+qvzBOeC3vQcrxHwiJR+b8TA5tYBf7HttNot5To8XKWMyR4sgwonF8cjnBbU4tbBjsb5jBXMaBXdXKF4ifjkJR5t7R0Y52y6g4IXF85Dr4RNuoi+au1OKe25paMerrZMhqrHDOtH13qPGpG13OSW23YwYvGKwZKktvKVWTxucgLgg2MrRC6T3l8c3oES57N6WiAmPG+X3rUCdk8hwjB6fRYjC9rwenELeoChX3bkZ3ilWwqImw+skCgn5Xl1DpDHGto1phS3XXuGFDO+u+49s5wFOmzX9ZMt3zFYOFEQUqEdfBtOUDAgtaVML4SKVO3qClnf5xTYVYdRiifm1Mnd8rplzMnixTdzJwQTUx+cS2K/47rDQ+/QdWruiRcT4GYUrlhPj8lmoVgN1HBurEwbXjhi2lWNVvHY67RSD7mrFOPU88kaW5YeS7NWl1Kzc1OvVavyZek+mqYm8TCvt4KyjvHIZIJTrk5F2owG0uvZmKbV9BHEQCFeMmbhmdXHZ56frW0t6mgeNcPflOLwzuQ6EoNoI4LOAe4VK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce core infrastructure to support VM preservation with LUO.

First two changes are just refactoring, no functional change, third
change introduces a new member in struct kvm.
- Move ITOA_MAX_LEN to kvm_mm.h for reuse by upcoming kvm_luo code.
- Add a public kvm_create_vm_file() helper wrapping kvm_create_vm()
  and anon_inode_getfile() to provide a unified VM file creation API.
- Track a weak reference to the backing file in struct kvm under
  CONFIG_LIVEUPDATE_GUEST_MEMFD to enable reverse file resolution
  without circular lifetime dependencies.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kvm_host.h | 14 +++++++
 virt/kvm/kvm_main.c      | 79 +++++++++++++++++++++++++++++-----------
 virt/kvm/kvm_mm.h        |  3 ++
 3 files changed, 75 insertions(+), 21 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ab8cfae..cbb5eb9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -874,6 +874,18 @@ struct kvm {
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 	/* Protected by slots_lock (for writes) and RCU (for reads) */
 	struct xarray mem_attr_array;
+#endif
+#ifdef CONFIG_LIVEUPDATE_GUEST_MEMFD
+	/*
+	 * Weak reference to the VFS file backing this KVM instance. Stored
+	 * without incrementing the file refcount to prevent a circular lifetime
+	 * dependency (since file->private_data already pins this struct kvm).
+	 * Used exclusively to resolve the file pointer back from struct kvm.
+	 *
+	 * Written/cleared via rcu_assign_pointer() and read locklessly under
+	 * RCU (e.g. via get_file_active() to prevent ABA races).
+	 */
+	struct file *vm_file;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
 };
@@ -1074,7 +1086,9 @@ void kvm_get_kvm(struct kvm *kvm);
 bool kvm_get_kvm_safe(struct kvm *kvm);
 void kvm_put_kvm(struct kvm *kvm);
 bool file_is_kvm(struct file *file);
+struct file *kvm_create_vm_file(unsigned long type, const char *fdname);
 void kvm_put_kvm_no_destroy(struct kvm *kvm);
+void kvm_uevent_notify_vm_create(struct kvm *kvm);
 
 static inline struct kvm_memslots *__kvm_memslots(struct kvm *kvm, int as_id)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e44c20c..14c3254 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -67,9 +67,6 @@
 #include <linux/kvm_dirty_ring.h>
 
 
-/* Worst case buffer size needed for holding an integer. */
-#define ITOA_MAX_LEN 12
-
 MODULE_AUTHOR("Qumranet");
 MODULE_DESCRIPTION("Kernel-based Virtual Machine (KVM) Hypervisor");
 MODULE_LICENSE("GPL");
@@ -1349,6 +1346,19 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
 {
 	struct kvm *kvm = filp->private_data;
 
+#ifdef CONFIG_LIVEUPDATE_GUEST_MEMFD
+	/*
+	 * Clear the weak reference of the vm file.
+	 * In case vm file is closed by userspace, but kvm still has
+	 * other users like vCPUs, clearing this pointer ensures
+	 * that we don't have a dangling pointer to a closed file.
+	 *
+	 * Cleared via rcu_assign_pointer() to ensure proper memory visibility
+	 * for concurrent lockless readers under RCU.
+	 */
+	rcu_assign_pointer(kvm->vm_file, NULL);
+#endif
+
 	kvm_irqfd_release(kvm);
 
 	kvm_put_kvm(kvm);
@@ -5477,11 +5487,47 @@ bool file_is_kvm(struct file *file)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(file_is_kvm);
 
+struct file *kvm_create_vm_file(unsigned long type, const char *fdname)
+{
+	struct kvm *kvm = kvm_create_vm(type, fdname);
+	struct file *file;
+
+	if (IS_ERR(kvm))
+		return ERR_CAST(kvm);
+
+	file = anon_inode_getfile("kvm-vm", &kvm_vm_fops, kvm, O_RDWR);
+	if (IS_ERR(file)) {
+		kvm_put_kvm(kvm);
+		return file;
+	}
+
+#ifdef CONFIG_LIVEUPDATE_GUEST_MEMFD
+	/*
+	 * Weak reference to the file (without get_file()) to prevent a circular
+	 * dependency. Safe because the file's release path clears this pointer
+	 * and drops its reference to the VM.
+	 *
+	 * Written via rcu_assign_pointer() because the pointer can be read
+	 * locklessly under RCU (e.g., in kvm_gmem_luo_preserve() via
+	 * get_file_active() to prevent lockless ABA races).
+	 */
+	rcu_assign_pointer(kvm->vm_file, file);
+#endif
+
+	/*
+	 * Don't call kvm_put_kvm anymore at this point; file->f_op is
+	 * already set, with ->release() being kvm_vm_release().  In error
+	 * cases it will be called by the final fput(file) and will take
+	 * care of doing kvm_put_kvm(kvm).
+	 */
+
+	return file;
+}
+
 static int kvm_dev_ioctl_create_vm(unsigned long type)
 {
 	char fdname[ITOA_MAX_LEN + 1];
 	int r, fd;
-	struct kvm *kvm;
 	struct file *file;
 
 	fd = get_unused_fd_flags(O_CLOEXEC);
@@ -5490,31 +5536,17 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
 
 	snprintf(fdname, sizeof(fdname), "%d", fd);
 
-	kvm = kvm_create_vm(type, fdname);
-	if (IS_ERR(kvm)) {
-		r = PTR_ERR(kvm);
-		goto put_fd;
-	}
-
-	file = anon_inode_getfile("kvm-vm", &kvm_vm_fops, kvm, O_RDWR);
+	file = kvm_create_vm_file(type, fdname);
 	if (IS_ERR(file)) {
 		r = PTR_ERR(file);
-		goto put_kvm;
+		goto put_fd;
 	}
 
-	/*
-	 * Don't call kvm_put_kvm anymore at this point; file->f_op is
-	 * already set, with ->release() being kvm_vm_release().  In error
-	 * cases it will be called by the final fput(file) and will take
-	 * care of doing kvm_put_kvm(kvm).
-	 */
-	kvm_uevent_notify_change(KVM_EVENT_CREATE_VM, kvm);
+	kvm_uevent_notify_change(KVM_EVENT_CREATE_VM, file->private_data);
 
 	fd_install(fd, file);
 	return fd;
 
-put_kvm:
-	kvm_put_kvm(kvm);
 put_fd:
 	put_unused_fd(fd);
 	return r;
@@ -6342,6 +6374,11 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm)
 	kfree(env);
 }
 
+void kvm_uevent_notify_vm_create(struct kvm *kvm)
+{
+	kvm_uevent_notify_change(KVM_EVENT_CREATE_VM, kvm);
+}
+
 static void kvm_init_debug(void)
 {
 	const struct file_operations *fops;
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 7510ca9..6241617 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -6,6 +6,9 @@
 #include <linux/kvm.h>
 #include <linux/kvm_types.h>
 
+/* Worst case buffer size needed for holding an integer as a string. */
+#define ITOA_MAX_LEN 12
+
 /*
  * Architectures can choose whether to use an rwlock or spinlock
  * for the mmu_lock.  These macros, for use in common code
-- 
2.55.0.rc0.786.g65d90a0328-goog


