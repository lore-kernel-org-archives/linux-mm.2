Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE11BCDB466
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 18:55:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25B386B009F; Mon, 22 Jun 2026 14:49:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 232CB6B00A0; Mon, 22 Jun 2026 14:49:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16F946B00A1; Mon, 22 Jun 2026 14:49:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F45E6B009F
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:49:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E65921A0282
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:49:09 +0000 (UTC)
X-FDA: 84908436018.15.D1F8D7F
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1704E4000C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:49:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OoyOf5yw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3ooM5agkKCOccJadWbJQdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3ooM5agkKCOccJadWbJQdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782154148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rUJD/qDxfrMv3GVCezTN8Ddb/ezsPEksCOi1qF1OubI=;
	b=IlA2/1rdRwK77tHSEICJpZ80L+En97xO/JEB2/pInDiZA+3HYp1eElcFkYXVWsOG49VHYt
	9GK8QvXP3f9WBCnMD9oPbf4CdKhFeSzkFKcyh/mwetxHEqgUaFRFzLq0Fu8awSJl5FmV0O
	Ci0OpSp87LhRoSBcWQhPUvRwMMZQo30=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OoyOf5yw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3ooM5agkKCOccJadWbJQdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3ooM5agkKCOccJadWbJQdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782154148;
	b=rF+o1DlOcAeUZh1ZluPgk2MGgsxQzoyCIdzBM/3Y/6uAh7KHgGGLA2yUfe9whe6PhX9lr1
	NeGCmidszZdnpt7nZR4tRXyhnveqBY+/djP6SAJTXq8gpghYdYdmzTDBMDUv2GWknVu5YD
	sWawxVq+QVTPdEQvZyllO0dOCTrvhqw=
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-c08306ae1c3so379669066b.1
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782154147; x=1782758947; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rUJD/qDxfrMv3GVCezTN8Ddb/ezsPEksCOi1qF1OubI=;
        b=OoyOf5yw/fWJ65O96elpKyelKvtuvfH//O6x/hrIxojoPopFBcDu5Z3ZWWRx86arZm
         s6HBZ8vIeDidnwbe6VschwNnCXppKlVuoNgwm5M68DpWsjDbsKD2tzT8AJVrrBPbdgkV
         2y2wHRVihXY5l1k6vcPdIMHg7k5KFh8kIjoNWrUGQQzX7SItMzv/MMl9c6WgByBMjLW4
         Pj7mEvlhiJfazFUDLTUSS/S1P2SbQvdAzjqHQJInGVZCOTgImNqF+A+uTHiAUSyKB2e9
         TO31vrxZF8drwTDbyz959wWVkhSSy4sbHlv5j0I8s3jdzNOqoKqjcNzKIAyRAZu+yIeL
         okWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782154147; x=1782758947;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rUJD/qDxfrMv3GVCezTN8Ddb/ezsPEksCOi1qF1OubI=;
        b=j4JKaU+nMCAUDfyzNXn+bSRZQO4zMwiwI1IAlKuiobxPBlhiexWw510rSz+dTcbcgs
         ac3Ou9KQFjV9PwvFuZDhQgMFM6Hx/0XrVTqNPP+Id6gpAXmZJ7C0lnEQrO5MRfZjr2ys
         quWW5EKsY9iqTx9EpVt3lJWhpZkMY49fnjJC4mXkMn/zgCZsTnKWpWsZM0OklviB/jTr
         uSAdShmvQFOwIqDIfq/aBAikqjwTT/THySL9Nk6cKVqq8SeYO7KMnj/DjaFm5pYcxJ5O
         ow6lT1882X+0UVD3J/72IC9tSwo41igcc7+fVfN5thEHet2sQRNp6Ar/ou+Z5yiBNCQu
         ZzwA==
X-Forwarded-Encrypted: i=1; AFNElJ/jzB0EkiB2Xp6fhaaxNgniqL3AViq8zuQsdJ4sLlLdO5h+XJSdegwCwqOnsJLDPZRZZJKs+yrC8g==@kvack.org
X-Gm-Message-State: AOJu0YwQyyIWTY6jl8b/JvTM6BYAOhChKU8EoIOZV5dnq3H3yfdfIT9K
	Q0fK1ZIQBSqmhKiBL00eIC1yyb06zj1hW7wAlm9PlMefoT3Et8bX2a0B9a4NGtJu3sWBibkOJez
	m708t3T0CthfXImS87Q==
X-Received: from ejet16.prod.google.com ([2002:a17:906:1790:b0:c08:3cd3:d05f])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:7951:b0:bf1:1df7:3e50 with SMTP id a640c23a62f3a-c0c63dba03amr559821466b.3.1782154146145;
 Mon, 22 Jun 2026 11:49:06 -0700 (PDT)
Date: Mon, 22 Jun 2026 18:48:47 +0000
In-Reply-To: <20260622184851.2309827-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260622184851.2309827-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <20260622184851.2309827-6-tarunsahu@google.com>
Subject: [PATCH v3 5/9] kvm: guest_memfd: Add support for freezing and
 unfreezing mappings
From: Tarun Sahu <tarunsahu@google.com>
To: Jonathan Corbet <corbet@lwn.net>, Mike Rapoport <rppt@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexander Graf <graf@amazon.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Tarun Sahu <tarunsahu@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: wcdoezo3qdaycmsop7uhsry5dqwwqw93
X-Rspamd-Queue-Id: 1704E4000C
X-Rspamd-Server: rspam11
X-HE-Tag: 1782154147-524307
X-HE-Meta: U2FsdGVkX19Z/8sXGutM8k+mXaeT0W++w++Ak2MYU6oA4lcPnenQzcHlm8pMD4ku0AJ4rypdFfeqML6btL4+0PVtbi0soHyF/ADLQ/ReIB2Zdlo64I/zv3uAzCNdp8ovjxi+NSuZY1bPYYHKuXBN6R+DY02j1Ei/hybwCCSGXYzMfE6AKtmv4jgWaBNMP+Ry6QSw+i+owjaEhVbjdvgbm7Mhj6GnOFdYjCY5fQh/IBfYQJINvu9yfqgbc31oKdbbdhQQzbNLpwkUjazjzUfyRDZpdTRjGNAhQtdV/52hXPMSmm+EJsPcq2Sf4yDTUFVOENOcxEBtTi0PBbFxxHHAosFbXSiL9u2MZJPDmU54amHbf/xJjdicf5BMkxSViUR9WN59hoZqyeI+U1zrwonO2MaxcuRd08HSWzGj6tQzeKVafI3ZzNDzDFVKvkJ239t7uNdWJi1DWdQjqas8xLWPYm6MPCO4+hWlUmklLVO9WLhDChfuNN3hQVhfMBhi3zUcf1DcBqQuTiE18F5ldJrxCeRRJKAdhWUpYzl5d6RMixmfrIYgCNVkbIDFmvWKKTf1uiVHpfv68Q9AmwPxHUfVkgyqtdFb8nlB2wEDsmJ6L4V3PYSGMOw9yM6F5UDz5h4WPhG1MmnWct1JUhi7EiL2ZpcyvlFvrNUlNXGLBKg/Y/nGPtzWoZyE8w6t2FghP2zoe0V2qAGAa0qeXXY+fG31zPmy1PaTNsYKZkcmySPKFmyImyPLQ/ETI0a/g4tZZliQiGhSHMaIv6RTJm5Q5wntIuMOhmOtow9jX2bP02SGTvL0fJfkmRQn/Q0JwZWjLPubr+v0su93WOKCDp9C+Cp3Bix1oKO5F4WccBLOULAXQHRbzHw2n2WbwvesTt40RNjBKMJyeDoZQojNENL9pSGQmUBGeycy3EZrm52ufUHBh4Pdj2EPoJ3CErIK2cVKWqFK7BWLAp3rcL6ewRSPDpH
 epn+jE1v
 zFOtkanTORidWzOXSb7H1CyW7NncxdhyelP9Rm5TVgkY/j9fvDDJ119Q/vBwc/Oa8DJu5m5KAvbU4muOTY3fmULODrmqg+PcXDUgeq3NEojdlph3t56jpJ5GXcZl9HmDIf6ZdTL7gdhprrChVuEs/F6vWLdI7Qi2lUVJEz0y1aGUagq8Huah38ixOCOYAH9bnVpPuaYC1eggpXJWiTGO9aOHwhNDD3/6zNS4DRUCmLuWevtxCS+BxJkivrYfbriTbZ/GVhHrnnIXNb3V9gn/vJcF6rQttaqRqGL+ADfh4gV0iRDJEkzt+xXAwVkHWl+abeRbEAch2KAK4zD3KbXZvAP4iaih2jeiEExVBpAImd5vEPtkJQwVNGLSALH8/KIk+QpWIYW1QVwv8SaDD6eCoZe6vrqggRpjQUwdXP6H7wkqETDvdY2YKsHcO2mnvnFcJIEC0u8bubl2iPDEWyxTC+bSWYkPRWFa9zgMkjSHKtVQWfmxfk9Qn+iGaaDh5Bv1fUVyGOS5hcVSqs6ZkYOp7ZWLNyBOtgZX2O2Fjdr5dRIStEdryyG37L/UId2zBqSdpHz9vQOzILZ1Ix2kJf1JPA5Qx7aFI/0gBu1PkRZdjPzYpUVE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch introduces the freeze on gmem_inode which prevents
the fallocate call and any new page fault allocation. This will avoid
gmem file modification when it is being preserved

Used srcu lock to synchronise the freeze call, where write blocks
until all the reads are free. And reads are re-entrant.

Incase fault fails, It return -EPERM and VM_EXIT to userspace. userspace
must handle this properly as every new fault will fail.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 virt/kvm/guest_memfd.c | 117 +++++++++++++++++++++++++++++++++++++----
 virt/kvm/guest_memfd.h |   5 ++
 2 files changed, 111 insertions(+), 11 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index fe1adc9b..a4d9d34 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -7,11 +7,13 @@
 #include <linux/mempolicy.h>
 #include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
+#include <linux/srcu.h>
 #include "guest_memfd.h"
 
 #include "kvm_mm.h"
 
 static struct vfsmount *kvm_gmem_mnt;
+static struct srcu_struct kvm_gmem_freeze_srcu;
 
 
 #define kvm_gmem_for_each_file(f, inode) \
@@ -96,6 +98,7 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	/* TODO: Support huge pages. */
 	struct mempolicy *policy;
 	struct folio *folio;
+	int idx;
 
 	/*
 	 * Fast-path: See if folio is already present in mapping to avoid
@@ -105,12 +108,20 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	if (!IS_ERR(folio))
 		return folio;
 
+	idx = srcu_read_lock(&kvm_gmem_freeze_srcu);
+	if (kvm_gmem_is_frozen(inode)) {
+		srcu_read_unlock(&kvm_gmem_freeze_srcu, idx);
+		return ERR_PTR(-EPERM);
+	}
+
 	policy = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, index);
 	folio = __filemap_get_folio_mpol(inode->i_mapping, index,
 					 FGP_LOCK | FGP_CREAT,
 					 mapping_gfp_mask(inode->i_mapping), policy);
 	mpol_cond_put(policy);
 
+	srcu_read_unlock(&kvm_gmem_freeze_srcu, idx);
+
 	/*
 	 * External interfaces like kvm_gmem_get_pfn() support dealing
 	 * with hugepages to a degree, but internally, guest_memfd currently
@@ -273,16 +284,30 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
 static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
 			       loff_t len)
 {
+	struct inode *inode = file_inode(file);
 	int ret;
+	int idx;
 
-	if (!(mode & FALLOC_FL_KEEP_SIZE))
-		return -EOPNOTSUPP;
+	idx = srcu_read_lock(&kvm_gmem_freeze_srcu);
+	if (kvm_gmem_is_frozen(inode)) {
+		srcu_read_unlock(&kvm_gmem_freeze_srcu, idx);
+		return -EPERM;
+	}
 
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
-		return -EOPNOTSUPP;
+	if (!(mode & FALLOC_FL_KEEP_SIZE)) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
 
-	if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len))
-		return -EINVAL;
+	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE)) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len)) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	if (mode & FALLOC_FL_PUNCH_HOLE)
 		ret = kvm_gmem_punch_hole(file_inode(file), offset, len);
@@ -291,6 +316,9 @@ static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
 
 	if (!ret)
 		file_modified(file);
+
+out:
+	srcu_read_unlock(&kvm_gmem_freeze_srcu, idx);
 	return ret;
 }
 
@@ -948,7 +976,9 @@ static void kvm_gmem_destroy_inode(struct inode *inode)
 
 static void kvm_gmem_free_inode(struct inode *inode)
 {
-	kmem_cache_free(kvm_gmem_inode_cachep, GMEM_I(inode));
+	struct gmem_inode *gi = GMEM_I(inode);
+
+	kmem_cache_free(kvm_gmem_inode_cachep, gi);
 }
 
 static const struct super_operations kvm_gmem_super_operations = {
@@ -1005,12 +1035,21 @@ int kvm_gmem_init(struct module *module)
 	if (!kvm_gmem_inode_cachep)
 		return -ENOMEM;
 
+	ret = init_srcu_struct(&kvm_gmem_freeze_srcu);
+	if (ret)
+		goto err_cache;
+
 	ret = kvm_gmem_init_mount();
-	if (ret) {
-		kmem_cache_destroy(kvm_gmem_inode_cachep);
-		return ret;
-	}
+	if (ret)
+		goto err_srcu;
+
 	return 0;
+
+err_srcu:
+	cleanup_srcu_struct(&kvm_gmem_freeze_srcu);
+err_cache:
+	kmem_cache_destroy(kvm_gmem_inode_cachep);
+	return ret;
 }
 
 void kvm_gmem_exit(void)
@@ -1018,5 +1057,61 @@ void kvm_gmem_exit(void)
 	kern_unmount(kvm_gmem_mnt);
 	kvm_gmem_mnt = NULL;
 	rcu_barrier();
+	cleanup_srcu_struct(&kvm_gmem_freeze_srcu);
 	kmem_cache_destroy(kvm_gmem_inode_cachep);
 }
+
+/**
+ * kvm_gmem_freeze - Freeze or unfreeze a guest_memfd inode mapping.
+ * @inode: The guest_memfd inode.
+ * @freeze: True to freeze, false to unfreeze.
+ *
+ * This API is used strictly during the live update / preservation transition
+ * window to prevent host userspace and guest-side faults from making any
+ * mapping modifications (such as fallocate or page fault allocation)
+ * to the guest_memfd page cache.
+ *
+ * Synchronization Strategy (Sleepable RCU):
+ * To avoid high-contention VFS locks (like inode_lock or
+ * filemap_invalidate_lock) on the vCPU page fault hot paths, this subsystem
+ * implements a lightweight, system-wide Sleepable RCU (SRCU) mechanism
+ * (`kvm_gmem_freeze_srcu`):
+ *
+ * Global vs. Per-Inode SRCU
+ * ======================
+ * A single system-wide global static `srcu_struct` is used instead of a
+ * per-inode SRCU structure to completely prevent unprivileged users from
+ * exhausting the host's per-CPU memory allocator. Because
+ * `init_srcu_struct()` allocates per-CPU memory via `alloc_percpu()`, which
+ * is not accounted by memory cgroups (memcg),
+ * a per-inode SRCU structure would allow a tenant to bypass cgroup limits and
+ * trigger a system-wide Out-of-Memory (OOM) crash simply by spawning a large
+ * number of guest_memfd file descriptors (bounded only by RLIMIT_NOFILE).
+ *
+ * Flag Modification Note:
+ * Since `GUEST_MEMFD_F_MAPPING_FROZEN` is the ONLY flag in
+ * `GMEM_I(inode)->flags` that is mutated dynamically at runtime (all other
+ * flags are creation-time flags which remain strictly read-only), there is
+ * no possibility of concurrent bit-modification races. Therefore, a standard
+ * `WRITE_ONCE` is fully safe and does not require complex `cmpxchg`
+ * synchronization loops.
+ */
+void kvm_gmem_freeze(struct inode *inode, bool freeze)
+{
+	u64 flags = READ_ONCE(GMEM_I(inode)->flags);
+
+	if (freeze)
+		flags |= GUEST_MEMFD_F_MAPPING_FROZEN;
+	else
+		flags &= ~GUEST_MEMFD_F_MAPPING_FROZEN;
+
+	WRITE_ONCE(GMEM_I(inode)->flags, flags);
+
+	if (freeze)
+		synchronize_srcu(&kvm_gmem_freeze_srcu);
+}
+
+bool kvm_gmem_is_frozen(struct inode *inode)
+{
+	return READ_ONCE(GMEM_I(inode)->flags) & GUEST_MEMFD_F_MAPPING_FROZEN;
+}
diff --git a/virt/kvm/guest_memfd.h b/virt/kvm/guest_memfd.h
index c528b04..028c348 100644
--- a/virt/kvm/guest_memfd.h
+++ b/virt/kvm/guest_memfd.h
@@ -29,11 +29,16 @@ struct gmem_inode {
 	u64 flags;
 };
 
+/* Internal kernel-only flags (must not overlap with UAPI flags) */
+#define GUEST_MEMFD_F_MAPPING_FROZEN	(1ULL << 63)
+
 static inline struct gmem_inode *GMEM_I(struct inode *inode)
 {
 	return container_of(inode, struct gmem_inode, vfs_inode);
 }
 
 struct file *__kvm_gmem_create_file(struct kvm *kvm, loff_t size, u64 flags);
+void kvm_gmem_freeze(struct inode *inode, bool freeze);
+bool kvm_gmem_is_frozen(struct inode *inode);
 
 #endif /* __KVM_GUEST_MEMFD_H__ */
-- 
2.55.0.rc0.786.g65d90a0328-goog


