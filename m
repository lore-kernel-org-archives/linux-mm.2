Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9994CD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 17:08:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13F4C6B0098; Fri,  5 Jun 2026 13:08:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CF5A6B009B; Fri,  5 Jun 2026 13:08:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5D536B009B; Fri,  5 Jun 2026 13:08:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D0DB96B0098
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:08:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 96DD5140227
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:08:48 +0000 (UTC)
X-FDA: 84846493536.16.1CCB802
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf20.hostedemail.com (Postfix) with ESMTP id B5F311C000A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:08:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cFMdumZM;
	spf=pass (imf20.hostedemail.com: domain of 3nQIjagkKCIY3k14x2kr4qyyqvo.mywvsx47-wwu5kmu.y1q@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3nQIjagkKCIY3k14x2kr4qyyqvo.mywvsx47-wwu5kmu.y1q@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780679326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q3ys0qD9usDIPXN1Rh1z7yLfiAE5vSm04coRPqmRTQw=;
	b=W9snybFRgJLB5vhaLcbYpZ9IlHoZw0EUkEOFt7HhXIpeesyLW7oqjsC2QX6QC7yVEgDaSD
	6Cm8APS3WSj6NHNrh0eKGYX1p8MNPZ8qlc92qFUPU2OAIBwlGDGyS8+m8agUX2KqZG3j8F
	UexjnMrau3d0prby7nI5tkAgcoVUcIE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780679326;
	b=G1PyjYdbaD3x09qdW5boUbgFGMDu3r50JMY9WDyvuSPkhDT/PiCaUjWawYIhhbDDvxdbk8
	B5RVx4wrSz/LPWjvSkuTpLvyMS9ydyTXqrxrZdd0SaqrXDya7DrLXwPesy2FvUz1QWa7he
	/88HuEwNK4fEzeibRPuCZHXhjFc2X0w=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cFMdumZM;
	spf=pass (imf20.hostedemail.com: domain of 3nQIjagkKCIY3k14x2kr4qyyqvo.mywvsx47-wwu5kmu.y1q@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3nQIjagkKCIY3k14x2kr4qyyqvo.mywvsx47-wwu5kmu.y1q@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-6913ff0f1f7so293421a12.0
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 10:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780679325; x=1781284125; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=q3ys0qD9usDIPXN1Rh1z7yLfiAE5vSm04coRPqmRTQw=;
        b=cFMdumZMnxiKKXrl0P12jRiHjKtY4hYNSQAzD+vHommOpCl1lStl+RmdSn5bw6pfYD
         EbdgUOJh3wzxQUHdYOLJQUr6tTbAPMby547rjUCQhsVjsgAJ5SleDADSfhPuwjnl1k0S
         uK8xpFmzLFQejpcVwZlLk/fPl5pz4HZ0sx3iVSYoWoKSOid6gSCIRcVLF/2OEGW6p3QI
         FwjyT8wokhgZkfaqHqYekEQZAR2ZaWYmahKjb1y4zpccNA292HahKOjcAkyPuEFuV9YR
         65M7NktJ67MPa0X9jFElM89A84UWGyBjSH+IS/8r6MPYRDzWV51+PX0iwLfo1YyKgGyr
         kdUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780679325; x=1781284125;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q3ys0qD9usDIPXN1Rh1z7yLfiAE5vSm04coRPqmRTQw=;
        b=N+BjtzJpaAnVwlQGmnhP5CJNKhH9OezWBrZPwQRqhTJaSxSkVSKXApbuE0I+t6vsuH
         Qj0VVKYhFoAwZjU7OwQHyAC9Z8CvPu1Cl8L9+NYBfzTV0HLuNqZhfvmJROqBs1Dv/RC2
         9RyBROCjyel3uuwY+8JZ7Z7ECGnQjSU8hpOiWaeHlcY5W7Tkxs/gNm16N2UnbYwS+7tM
         Y7L7w92yQWcAVDy6SC1y3mawTduZdygnO93OYq24/EDL3ODjOI2smcUJUjkzzsCZt8bo
         mrXLIyaZgHV7YXhiooH+ounfBIVHy5zEJVYjqKubr8Hu39sf8OXnlUAwGl5E8eCfvwzo
         711Q==
X-Forwarded-Encrypted: i=1; AFNElJ9LHVEoJtih7pC4acEngD0+EP29yJIfTxwyKRxazqtW/BeMnJcYxOVd1HcJdys2Bx2JLkS582+BkA==@kvack.org
X-Gm-Message-State: AOJu0YzDI1v4vl0TxpvsWMb2pQEx5RM8IZE6UCUOEhsBhb9BfnRakOUb
	LFrkBwS7oRZDnJjejB+85UYijxexiEUcMrNuAB3iqWRRKpo1/gSSPYtRFELdQsiGPtlNyFA2fs9
	l/NF1SJxRMGaPUkVVwg==
X-Received: from edsj20.prod.google.com ([2002:a50:ed14:0:b0:689:61c8:cf62])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:3492:b0:68d:7c10:a46e with SMTP id 4fb4d7f45d1cf-68fa5047543mr2499655a12.14.1780679325050;
 Fri, 05 Jun 2026 10:08:45 -0700 (PDT)
Date: Fri,  5 Jun 2026 17:08:28 +0000
In-Reply-To: <cover.1780676742.git.tarunsahu@google.com>
Mime-Version: 1.0
References: <cover.1780676742.git.tarunsahu@google.com>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
Message-ID: <20ae20f9d1a198b289444ebb4c824314cbba1bcf.1780676742.git.tarunsahu@google.com>
Subject: [RFC PATCH v2 03/10] kvm: Prepare core VM structs and helpers for LUO support
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
X-Rspamd-Queue-Id: B5F311C000A
X-Rspam-User: 
X-Stat-Signature: 5p7o7h54xpquw6r4omefewp16gearxwt
X-Rspamd-Server: rspam08
X-HE-Tag: 1780679326-244691
X-HE-Meta: U2FsdGVkX1+vTJ4kdiScakP4+i1b9DhoGD4T+ShQpuU5juoIzMj0UmBZ/FOHIM9yNTgC8Vwen1aOTs0WzocP0sPiJwIOQYjV50J1D9r5RWAjNUhSM2KxrqkJqkRipceuy4Dd9TWfpuC9Lq4eK3anm+tmp6gSbaueRgL+CsrxkSL4c8R0a4eDkRbSDEIG8U2fqK5jBTVIYrJlysaQ8x6rbtcVG2j5TLHAmx24v9thHE2avfmYv9OdcTpuU0PsrpTwg8rkIXJ/Sh3Vnlfhu/e8Qq6Gu+qgu1Bp43eyKveheu/cegL/8ERYN3mbVGucKuvNSnVmjGf6l+Tq+qPKddFTN8lVD4+VfTDSoBizEraCnc1YcMWwUOPuLjWs7cDYqEDAw/IaGkceMYyAnBxpZ54lzb9eSfutphWLrvnqFdSeeTokB/E25UDpO0Qt2kPeM4Hab9v69b3tv3mbbSOiR9aBQsoYnKO6/tQLFnKc7TiM3ZsFDo7YhMEBQeCJD/p8N1OiNxG6/hDH+DEpkNA2hGEGQRaNDjlMWys15tGDM4/WKpxejMl4QLon6LKDxO+32PeDfAGB9EfdEMRRaAzqsjrX4TV/kUddqCEb9ypBik9+mViJ0DS52//o91L6WFii1XIGoM26khJ181A6dfbU6Sg6iChHqqPU+ukpOg5aDp8+CcISRwB3ljlGyS76X2rr+iliTzHPHtmK2lR4J9Xo/LgjfeTqcn77qKdLGlVmedmHKatF5edN7FDI5jYLyAj6yj1RlUjTHb/3spaJHn6upbRXZb75wPAD7HfCMkY43NBaqbq41/mUOUr8tYe9a1nooxqCygCzLohbaKgIGkxasFVcDe6hoH2+pBevpAPMIzq0bNprSb5fHXKYHgONlZoN0Ds9hiTCbkC2B8DtYPdneGnvjLnCacXtI8X8uyu2l45jE7QmZcSjzSowbjICtHuE/Mdz7cIoez1NQqqgT4drc0W
 TvSv9rzw
 KZLbGutoMhIKDGn0AoQPXhenkDtTbq8k03azf9V/soQgellTpRR0UCuXmgCrQ6+fHnV5tK5mIm/Dt1SiV0jhiYdaJBo0OGIi0J455qdV/40n8tBlsRGFe7QOD9BHOJF9gUqNHrk+WaePQpp+kpzwr/6YWMzlbzcxls5DqHcIFZ4GJHuANO3X1MLKX7F8CXQXLK70RE1+y4mBf2kT77G7bcsGodVHcxaedvLwfb0d+h9JmrfTkafdg9j4PZN3Xe4xcDAKKUiKLLKGMznYDZeAbE/ljtlOOSpSrrcfaanGKWKIOk0G8IqNasWqCmFPWUiTeNXLdsFiyCrWuHSbGpJ3FJa2BaBzrro++36p/EhIEAKFvuBVu/y8mh85RjtpGXfp1fFr4Xaivgw7Q0TmX7fa6XPFzA6AmvwTSq/vcNZMw4WvKCjwfXzTxjyTDaYClvvuV7KuEl+QFRpNKJDsoZwgUYcLuQUQ8u/4o1nSAOhcPysdEqx68f0G4Iq6N1NxIPU3MbIAa1neZbAgbX65+ea2BrkEvaX4RLMdj8yJGIJojZCJ0XPJcJPOA65XK13cm7x7sxg/g
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
2.54.0.1032.g2f8565e1d1-goog


