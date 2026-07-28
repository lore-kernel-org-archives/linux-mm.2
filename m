Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D156CC54F52
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 12:11:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D446B6B009D; Tue, 28 Jul 2026 08:11:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1C586B009E; Tue, 28 Jul 2026 08:11:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C327D6B009F; Tue, 28 Jul 2026 08:11:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 842B46B009D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:11:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DCFCBC02D9
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:11:46 +0000 (UTC)
X-FDA: 85038071412.01.EEB2134
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2C441C0007
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:11:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y4aT9W9L;
	spf=pass (imf28.hostedemail.com: domain of 3f5xoagkKCLQnUlohmUboaiiafY.Wigfchor-ggepUWe.ila@flex--tarunsahu.bounces.google.com designates 209.85.208.70 as permitted sender) smtp.mailfrom=3f5xoagkKCLQnUlohmUboaiiafY.Wigfchor-ggepUWe.ila@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785240705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gzckiEC4GSPBVnzwnF4qvKlP6HAv3vDKnOlfEZZeHDM=;
	b=U54+b5ozTZkCFxnM9e6uR77YvWQOkpioOehRPa9UtD9qJuehl2VqH9b+x4dozIvm7vvbyz
	3ajavNgHvD7mg1jMK+62YeHWwZkmnMGhm067otLX6IJhrvlPjzV33rZVjEeexsG4VWDsRs
	19vElyuSswgfw4eVce4mEgYcYrjLCTM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785240705;
	b=3PRwz4TtxGLFDSfHj0kBp1fWrx83AeuhmRWfA9aj7eT8MmXX7fhuN9776Pvey3iKSyQ4yh
	253jdYtTfFTmgCMX2TCvxN3Zb+ODlpJZrvuqZjMaoLh0Q93QCAEJcoZZV8tsgnKzqGt8X8
	jnlxel7d7/6b7o9PN7smH2WGc0qwcE4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y4aT9W9L;
	spf=pass (imf28.hostedemail.com: domain of 3f5xoagkKCLQnUlohmUboaiiafY.Wigfchor-ggepUWe.ila@flex--tarunsahu.bounces.google.com designates 209.85.208.70 as permitted sender) smtp.mailfrom=3f5xoagkKCLQnUlohmUboaiiafY.Wigfchor-ggepUWe.ila@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6984787eeddso3346306a12.1
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785240704; x=1785845504; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gzckiEC4GSPBVnzwnF4qvKlP6HAv3vDKnOlfEZZeHDM=;
        b=Y4aT9W9LBpjb0M5WVtiA+UaNDVC0woI5jCOafYFd2vaXOxxTwk7cl00iy6mfcq/6E9
         TyaHfSYK4AbBPC8hyG5Dxb3JbRoYYa12a4HCv8DQJ2WLqOiitmMQRLPoOlT6ynGRtJBV
         WxtJdS/FEWwslSKKIfe4E6h4gk+14bF57ax4lGeR54wKDfwULUp16PFJl8vlh/PRLNhl
         w1Sx8tKTx0ijm/b0dW+lQPjEkI7vMaHK2O9F+ZU/miARoP5iC627M87jYQfILaC1gZZ8
         FBCUYPU+nTDX1bJ8dy3PLsVWdW1rrBL48C9AR9srHvWGbMcdN86wtGbRaNR9gEgzNLaB
         md8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785240704; x=1785845504;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gzckiEC4GSPBVnzwnF4qvKlP6HAv3vDKnOlfEZZeHDM=;
        b=qqykzWMQ1xTuXwWN2OPHbDAAm9KFKCU89QtUz8mwmp9N3j+wYhSzfPYycQ0FPsJ0J4
         LJ9jQTXyyLwY7fvPYWkCbc06zwObuPGqCE7abPwNur0PJVZJtEVM64PRj2XICJkU7sYy
         Qknewh5QD/lL4SzmIMDU8VpR+ubRHtvgxZBIFyQeMIZRBsnFrPxb8GlOlc+QprnnB3/I
         LbvJ0w+W2W4F+KyHREPmLtEmI9fvRKhNrXO8U7s0w1pyLpySGxcFDHSvxczBnqwpM1p8
         VJbMMuPRI3uQ87d1E7LPeuhJjVH6aWCQchhYe7+PU9s5ynWyc12psnvlgVlb3PGNzQ8s
         /D7g==
X-Forwarded-Encrypted: i=1; AHgh+Ro8M0LFvGWE8/TfGfEn/20uf0Jmadh/r3cc3PgjhfpvrxTIZ5nyTS38gfTBlXoag6VRCNbawymalA==@kvack.org
X-Gm-Message-State: AOJu0YxDRbvIEt1IWe1HezoQRFDwhN9ixDWXf26nWX8/Di/pA7WQ+FVa
	VLgpQTHqChWvC6+D9MN0iQq6ilsn4KpWdyUv3/D2JOfS+5+elOyoJoNJhcDgbJJJG6wpvqikYix
	l/MsHG8WoUuuSVQxdDg==
X-Received: from edwv27.prod.google.com ([2002:aa7:cd5b:0:b0:69a:306f:a69])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:194e:b0:691:7054:8c6b with SMTP id 4fb4d7f45d1cf-6a034a9e9demr1065056a12.19.1785240703362;
 Tue, 28 Jul 2026 05:11:43 -0700 (PDT)
Date: Tue, 28 Jul 2026 12:11:29 +0000
In-Reply-To: <20260728121138.1103610-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260728121138.1103610-3-tarunsahu@google.com>
Subject: [PATCH v4 02/11] KVM: Introduce kvm_create_vm_file() helper
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2C441C0007
X-Stat-Signature: pfno86if469cuf6mw39wai6edti4abjb
X-HE-Tag: 1785240704-721355
X-HE-Meta: U2FsdGVkX1+xkYJ0r2iKluoRAEdnBFMwwje7EV4u161W+HcRiUXyQD/oIiHJlBZfO7svVzRrxthFgtYLNvG+iCsrnha3jGMqRKS6TRM1FqyTHCvjO8fexy7g6VbRjvbtKVbp95p/8bDvMjqBkF3/eUQPiKGME6Q9p5WtUxhXBhW58RWAQMH0Ifp74eHnWP6+ooHFxSZZYOz2wXU7ocxt3buTIARvN6NcRQObBTFZ8j4TTSXN+wh2nnNMOxI6hIVdOfjWEBIUCOEk8Dz1MaTAnWJZmK/MwpC38zYP9EhF4VYRZo6CqlYYDBU+HNxZ+tYZ5Dl3JDhOPk0kviG8YFXnbxaRDxsklxmNVMZ/1NIHLljiMd9YqyoJWnFzRP8mf9GswRAq3BWUYyvfnFTmEYvq2acBUHLb9GkpeyCxTJOKFhdWTRVijWT9FD6rtGXMI3wxguDQIQQ6mxy7TprMV77zY5kSDI2+FxVvPquZCYtSVK2QOdoSgdjue7b87+XPhtZ0DhCFLdPzYU4f6G0f5buhGb6/xOx6pGA50iN9Q4+IAt30erQ0OldxE+DuVQR1hdek4/VcOayHZzLOVEFc/G2KDOjRTEtm3b2y0Q8gvbNWc5rTCUv9U+Lv3FEw6sLvfE6nohnDoE6RpA9E07WyKQdFONN3M7hWgMrQK1OiJckNQpuMfFJCgzcyjKIukRu1H7qX+6ULgY/TUyYAV/bAZsvKFf+pNge+yLMZNgJbQ7PVTU+DnURlYB+z148dS7q6qR0qLFUXlE9i/NappPvxET1MRF5WdLu+e1hM6NRSEzPCoeOyELnvTOtsI6TNe3lhQdIAwtS7K7UBpvDc5rtPajXJK3CsvXHggUdwHSpW2TPHMIq0tqcQjgzOrIliyMgnEbh9QL3SPx8rYKLAdT+C8Z5QBRScHZgKz7pKPYHuifTjzZAp4/XjozKVJyomQXZLfOoGi4VNsx3F00njKwt5rEq
 0KXAcXkQ
 MHVkSJunrWoPRhgjTaryKCVGT9I3vKNZFca9dRPFwOCqOdAzrOUD/jmswqK86StCZqtV9nd0Y5/jnzXzfXkk//EfwmdUlUYJrS7ROYuKf0GXc4iKYL0XWsbr4a2T489+nI/mC1MtLOaa3ci/duJj2cXXxP8KTcACzsI/CwgUvyzGbgKCjfnIYQ96+sUaOK+huVXg8zWEzc8Ig4d/dhd9nEtUhv7D0AjxNBBtcv79AE06PDldw+T9y/NFGOT16hYTo2eXbomVOA3YMEUO2OkNcywVo8JpWvHn4qNd9FDDxjB/E8H6ABVL8WrOwh6LKUjYFPtYTIJbjcm2uNHXy1yVqF9fYCS7vKjMRZFiMqJ5SoN8PdA1Kzue5Fdut29err3FS4d8yfHuqbRbG2cL5aIf/zzJVi7mjev66P7rTbuVWpaZxYCs3Z/GnSVpH3a7HGD66nsSk2PUjN18jWBTO2EPZhyJ64feqrqILTwfWHjSBqETHkGxxePVzcVowHnu87dV0csuCQ4ULKm11V4khQQVSyT/B72EnWeSha4gE1o2OjkfMOcuPF1mGYEP4lGu/Yn4dOHc56SDtmszGDPsAXgiVIAhuzz2xVRjyM4cOWlWs48NPGYAvCb5GcXryf6RM5ZBpJFkAvYEmQWOK9r8xTUp6I+g7vnUyHt7nYkKQQaaGTwI0NK6YLaPwSY/3Tg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

- Move ITOA_MAX_LEN to kvm_mm.h for reuse by upcoming kvm_luo code.
- Introduce kvm_create_vm_file() to wrap kvm_create_vm() and
  anon_inode_getfile(), providing a unified VM file creation API.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 48 ++++++++++++++++++++++------------------
 virt/kvm/kvm_mm.h        |  3 +++
 3 files changed, 31 insertions(+), 21 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ab8cfaec82d3..79b084887cdb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1074,6 +1074,7 @@ void kvm_get_kvm(struct kvm *kvm);
 bool kvm_get_kvm_safe(struct kvm *kvm);
 void kvm_put_kvm(struct kvm *kvm);
 bool file_is_kvm(struct file *file);
+struct file *kvm_create_vm_file(unsigned long type, const char *fdname);
 void kvm_put_kvm_no_destroy(struct kvm *kvm);
 
 static inline struct kvm_memslots *__kvm_memslots(struct kvm *kvm, int as_id)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e44c20c04961..3339b8fcd59f 100644
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
@@ -5477,11 +5474,34 @@ bool file_is_kvm(struct file *file)
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
@@ -5490,31 +5510,17 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
 
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
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 7510ca915dd1..624161793fec 100644
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
2.55.0.229.g6434b31f56-goog


