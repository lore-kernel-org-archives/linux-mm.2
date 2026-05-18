Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 514C3CD4F56
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 09:36:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 143D06B0095; Mon, 18 May 2026 05:36:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11C436B0096; Mon, 18 May 2026 05:36:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFE376B0098; Mon, 18 May 2026 05:36:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E11656B0095
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:36:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AA7AF1C07E5
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:36:48 +0000 (UTC)
X-FDA: 84780036096.29.E60ECC9
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf23.hostedemail.com (Postfix) with ESMTP id BF1F114000E
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:36:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bMQq566q;
	spf=pass (imf23.hostedemail.com: domain of 3rd0KagkKCOofMdgZeMTgSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3rd0KagkKCOofMdgZeMTgSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779097006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gu2thktJGs003PTp9eiJKgCeu3f066a/QrblnMWAnz8=;
	b=Hjv783NAg1Bjy4BXi/ylQ4bfu4v1vWdqBHpNjhFuivAOPuOw6Wu5AEvEfjBZYdK+H3VQHD
	MvwiOVlU3i7MPArcm/T9UEDDyI/m/lmw6KXbwO7u0kqNeSuzzzvaesdjZQuerkixr2zrM7
	kT67RYGAz5qHSU2CM1/aBHeb+4OQk3A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779097006; a=rsa-sha256;
	cv=none;
	b=ya95mJj/xE9UQpvmsuMJ26C33xKVRQa6MiKugBP03wB4B3O6afEvP3ox8ArErBWtinkp0O
	AoTO6zoPYbboSZg+hUD2J+nJCHQInD7a598vmF5vKM1hHUQSlYRBqKJUltpTJVLR3DhWXy
	M7sCva2JBsUz/VjzLFmDlR/PoTvlfU8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bMQq566q;
	spf=pass (imf23.hostedemail.com: domain of 3rd0KagkKCOofMdgZeMTgSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3rd0KagkKCOofMdgZeMTgSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-bd30f02f3c7so198717466b.0
        for <linux-mm@kvack.org>; Mon, 18 May 2026 02:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779097005; x=1779701805; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gu2thktJGs003PTp9eiJKgCeu3f066a/QrblnMWAnz8=;
        b=bMQq566qEYbHOqzH16A1d+jLanpKS7t7grHY/s5uQasbj+jm+gwxV2o3CHPIFrnhs7
         JNKME06g2qEO5wb+Gp3+K9ptJAa5MqlcJQhzcCU3ea+d9XDuy1I/eD+B4GVUpLO5QJef
         mzueLdx/YVZbs1aJxRk6OmBC+cjqlU13ObI1BxWlK/iLLWv6fycSvPoTHH+2V9tzAIbV
         FePtZ57beTJw9Y8FARrZdywyfQMejr3tAQ/zJP4KGprHkVLXcPDwtH2R6KotCUPWvOGX
         hsV0YYK74hruXKr4Bh4G4p374TW1Md2PNJ6zXfD0TUcnzH0i7NIiZ3C6SmPpdpazwVnR
         5LCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779097005; x=1779701805;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gu2thktJGs003PTp9eiJKgCeu3f066a/QrblnMWAnz8=;
        b=CX+K85qD8MQowpbspZsOMekYXqKFnRZWLXruiQ/ZmLpQCwjIuxkCmo7LSW5x2b+Caq
         QQQ5xiyA4IPJar2F+5CefRTufThQ3k6lqYFJeUDsyzMwrYOhJjmkK6652FncRcnuue+t
         rgs69cCOX/zqRLa/YB+JtB9Lo4EJjHSCZd4VyTWZwoPx6kE0DjOylDdO60piysCVGMK7
         fMlkQcVvTFbW5ZF1Z895YiZeUuWuC3xQEKECSl/kETOH3okknkBUoQrjx0J74VXNXPjG
         nVpLj3GCLmW4HEXXVopR61AZZA6Ud0teWEtvPG1f/zR7/wU36bE88eAn0f/3Tx2Fx5xp
         2JsQ==
X-Forwarded-Encrypted: i=1; AFNElJ9HzoTOzoMkczhiwlonBOgEQ+Wgv58g6Fq1Lmnqxc3Z0bTI6ZcoVqnFUwaGLEpcTFb2jVvBpv86IQ==@kvack.org
X-Gm-Message-State: AOJu0Ywh/fJJEyY8k/Z3S75o5duGLcUjpl7FyFoaC9/AT9/NSnfgnUNi
	sthGZ4JBfGLBpfqCeA245TdBI1COImOkNu3HRlCtrsz0Z/3WYnVkMuIHhOHCuAl+MSNTucXgrox
	QqCK91brZq14uPIFakQ==
X-Received: from edbck27.prod.google.com ([2002:a05:6402:1c1b:b0:672:bd1d:a465])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:8e0e:b0:bae:d29c:4e28 with SMTP id a640c23a62f3a-bd51785f36amr758368766b.12.1779097005099;
 Mon, 18 May 2026 02:36:45 -0700 (PDT)
Date: Mon, 18 May 2026 09:36:33 +0000
In-Reply-To: <cover.1779080766.git.tarunsahu@google.com>
Mime-Version: 1.0
References: <cover.1779080766.git.tarunsahu@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <24e13c0679157302f0d8385c341169b0ddd4ea40.1779080766.git.tarunsahu@google.com>
Subject: [RFC PATCH v1 3/9] kvm: Prepare core VM structs and helpers for LUO support
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BF1F114000E
X-Stat-Signature: cau57uh8wgdtusb999xa74haccw9cm9d
X-Rspam-User: 
X-HE-Tag: 1779097006-844929
X-HE-Meta: U2FsdGVkX1/kMFT3OpnM+PHErOMlqDHsLhID5gO2S7Mx9iKg4vDPyNI5HzOesYTT4X4StnLJGw5DOKprWHWRs/yWf1zZaK7Le3if5uou7GSEyiSxt88jR/jTqgDQnBZOzrM4wgTrL0nGwj94RFJ69NAcrwv6LD1oxM30PeLf+uLXPG9/M4qC09waKM7GG+Cu504l1PYKH+wb3ub9G+Qfo/tNznZwSJx3CHSmbN1ZsT4UGfW48JtOE0cdUgNlStpe7nYyVh04rCrL0HIXvlJjBbRfsiizmk7amWU56ElFBJ3HxibqyQuOIvniOdpvh6Ha4AHLj25TE7JE2Akmk4f8O1qho9F3i0QUTH0uYJdxUC4CPrlrIF9ExooelWaEwuIWPqwE5UMpmIfnsbpESdbUbJuHRgmAOyXnl7esuwUh0+v5x+PxA5mrO9c4+QTxiJ0z7Kw6WGYJtApmhNBz+d+X1X71W3q+ZCqJV45Xi9qC9B0IjWEZLK3gVLrmnPj20eIamD8UhPtMvka0ZoQt8ViARs8JH9rVNVYMM3g2vmYLZYxX1ZAg7KUnjNhBrstLEgByQJoFch29W7v/UpHALFOv13K/jCz/L7WO1wKjsasibTEM/VKYrshmAxfP9OlDa3RsRsJMKgY44RYxaMVvqlIOXpVtsVXj+HNHgFbN91xUypZRtbfUJxt6aaTrinerJChn0ChimvpWTvemlr2pasiXHCjrhHldrrpO9g2jPjNYVm5lD1brhRjCtHiOwu0JTuJURvq1XpfBDhOvcNcA3+YSRmkCVt/5mHS1ajFInUdbYmPvRiCO1gIhaO5CP3siqhwrEqVCfTFLqUx6l1+tHPwN3ihoLpbjPiXp8mEjqP3/DXrgEokUOV5hlCM8fKu7i4OAjEqit6bEf5ZlWOlRaJjf7ua8eg2U86gYUbZnzT19JHS8NeApXdo4E/8L4FBAvI1Ge8/mLFfF090us8oETNA
 5LJG43vP
 SM/GXriLxhOiOdpTo74v299SqxUmfkdjh6QpbWk4ENf4wgeHqRf1m9uCWD5J3+F26zhaMqW2h6dXq9rta5PggryNLWcpgf+Ao9p+GFLFJ2J24TdfL3vvpN/G1Cdf8huApkzEN3eJ4Sw5xO+r1u44/pWJzPbWe/kWhCxaMZK8vBe6mLdyHAhaR0p5p33/6yYwVfwGGAVYWIA6TTzLCgfuD26cFE2Sxi8uc3qcmgl3jhaaqbXRI/tgLFPav9vX27WgzWXpuqrQc7cHEvdJehN3eiebQKb9nK7DeoPb98Kebo+CHXXSE81fNIVdQ6cNBPIEOFwod+on+SL3eiisnCe6TbAwylwM9N4rtgRNRYaWW8xp3FtdSLglbtfH8amBDaXPiaOpe8nnVlRjRz3SDpiMBGxeYoIiNwuUxUd4c9N2MiTgdIcGGEVSCu++SVmoEXyLKM6lB69MV7zL+0xOlZ3YC/c941ZFPRCx2hkaUlEfFrvPihuL7YH8n7Ts+1P/zFqnNS5hOTK7KfT/SB/ecYsG/MLkOk2NZih6x1bUUdl3sGRjs1xaiKST8O03g+8R5BUYxW6xx
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
index 4c14aee1fb06..9111a28637af 100644
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
index 89489996fbc1..65f0c5fb353e 100644
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
@@ -5476,11 +5486,47 @@ bool file_is_kvm(struct file *file)
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
@@ -5489,31 +5535,17 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
 
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
@@ -6341,6 +6373,11 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm)
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
index 9fcc5d5b7f8d..7aa1d65c3d46 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -3,6 +3,9 @@
 #ifndef __KVM_MM_H__
 #define __KVM_MM_H__ 1
 
+/* Worst case buffer size needed for holding an integer as a string. */
+#define ITOA_MAX_LEN 12
+
 /*
  * Architectures can choose whether to use an rwlock or spinlock
  * for the mmu_lock.  These macros, for use in common code
-- 
2.54.0.563.g4f69b47b94-goog


