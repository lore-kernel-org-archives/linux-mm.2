Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C23ACD8C84
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 17:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E0B66B00A0; Fri,  5 Jun 2026 13:08:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F29B6B00A1; Fri,  5 Jun 2026 13:08:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 693C16B00A2; Fri,  5 Jun 2026 13:08:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5044E6B00A0
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:08:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D78A940227
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:08:51 +0000 (UTC)
X-FDA: 84846493662.01.295028E
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id 138DA1C0018
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:08:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RDF2KNgL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3oAIjagkKCIk6n4705nu7t11tyr.p1zyv07A-zzx8npx.14t@flex--tarunsahu.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3oAIjagkKCIk6n4705nu7t11tyr.p1zyv07A-zzx8npx.14t@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780679330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PVr8ACkrUKM/95aQGMpWS2mbVNjU7wBFEcPhhv7u9U8=;
	b=tfRgqqibtc7eWiSejIJMSBG2gWxFpVnQe3j8beUl+Uewid3gp8V/+e6rmtXMzTx615wQ6B
	De/12ZxyByPzO6xFV9plpFAFH0TZQH4dfp3ZSnyKJSb3mj18xUt8fz2t3oChX5KD/FtYJZ
	1Bv4gD1znhIA4cAvse5nEXgqqpP8xrs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RDF2KNgL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3oAIjagkKCIk6n4705nu7t11tyr.p1zyv07A-zzx8npx.14t@flex--tarunsahu.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3oAIjagkKCIk6n4705nu7t11tyr.p1zyv07A-zzx8npx.14t@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780679330;
	b=qHYx1isDwJYygZf1fPEhUKqcNAaHmndxiBgzedqBZbj4EMDFO7IlqNwmrDXWZj6te3JUeR
	kCtBWJWDD87Rcm1Cj1b4fnoy4wAsy8PMjXcB5h4tDLXUoiVFt1vqAoDpYT9J7WJqlQ8GXM
	u6TPjVUBZASgFAUwPiyMuPICvRQxjHI=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-beba94353acso222691266b.3
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 10:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780679329; x=1781284129; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PVr8ACkrUKM/95aQGMpWS2mbVNjU7wBFEcPhhv7u9U8=;
        b=RDF2KNgL7TkXxkOMc1nrMrTF2SVoHxLel1yHNrRHVYS0EnirODC76uvpdsWiJ+rWmq
         gzy8E4WrN6yA9clkhlmDcU0K0jwpL2PMvL5VNDpuFKoEGtYZ/Yull5sNbn75hyik1hiF
         qSipTiOlgaIXmbbeezKDmX/V1JE6buRdXGKDhOPKf7SZs+Oqa/iOlYsXA3A9tX6bWXst
         cf6jTm+DFmErgpZJxWRVaFDZAn6+8oJ7IVJ3dBOb2/2fu9hYGqNq/EuV9e5meF6ohx7A
         aEcAyji6eL+QDvpm42UnPP1KF4SiaEYhP9biaEjuUpO4oJv82cGMWOhGdePSt0KFdcCT
         ecXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780679329; x=1781284129;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PVr8ACkrUKM/95aQGMpWS2mbVNjU7wBFEcPhhv7u9U8=;
        b=N0eaWagP2/mXguJp8b5IOzYMsMyHEBOpTVzC5N98KpbmnQQKA6hfdkxKSTUZAyja1s
         DK+ecrC3UlMIuCRrgvWCtnxddvOEd9QMEiZoi2snjlfdOoOsbClZRdP1DFnsmxx89GCx
         H9zEX25sPxXI5ocKDZi7K0IGG6M67FmdsSLBGx+VuWxY6UsgfvtwYvmSzLD1m8ulwDt+
         L4nKmdncfbSWbflU2MgiYX7yGdwOaM7Gljgg7nDhERC6+j0L/eYmxds8mCyyo/HwnK8k
         EzeHMnPcsvy4M4PylcSoNvwPiJgj20XBN817Rm51G7mV7YoZ7FZgx5G3Z27RtxhtNXtO
         jGgA==
X-Forwarded-Encrypted: i=1; AFNElJ8OFXk5G1uaqnm6BQfZ5uLoH0Ont3Q8IidOhyCYmMfOQwdNwimMOivpR00HWITLzFTdDEoAd+wb7A==@kvack.org
X-Gm-Message-State: AOJu0YzHVO+zRlZ+72DCYagusaFmu1GG9JlwvjihEnm8YTnp1MU7NU3G
	INgFRp8Kd8uyRZ35TBCbmhIQstfPn5h8pjBlikqmv5vgeZCj4d4jV22+TogcjlApHsewjij9TQp
	TW6UteSSuWVdBf9JfcQ==
X-Received: from ejcaf14.prod.google.com ([2002:a17:906:998e:b0:bec:8aca:9459])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:948e:b0:bf1:a59e:653f with SMTP id a640c23a62f3a-bf371e4379dmr240039766b.28.1780679328253;
 Fri, 05 Jun 2026 10:08:48 -0700 (PDT)
Date: Fri,  5 Jun 2026 17:08:31 +0000
In-Reply-To: <cover.1780676742.git.tarunsahu@google.com>
Mime-Version: 1.0
References: <cover.1780676742.git.tarunsahu@google.com>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
Message-ID: <48777f4749fa43d5648085dbb2037aa99c144a88.1780676742.git.tarunsahu@google.com>
Subject: [RFC PATCH v2 06/10] kvm: guest_memfd: Add support for freezing and
 unfreezing mappings
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
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: pbqrk4skmjssj37gc6dpykaimjkj8xoq
X-Rspamd-Queue-Id: 138DA1C0018
X-HE-Tag: 1780679329-92029
X-HE-Meta: U2FsdGVkX18jzkWP7xZOIC353jKj20KSir8i6ly4yIShon266igrnMO0nVkFt82sEX20o5FPfdnxBHjCEwLYWR6BbyKat74cQdpwKfQrXzwrtyzF9u9XFnTUiQs9G6OMZ4MtNpKPrvthGFPyRVeJW7lZSKWaKIBsjD6JvBxikK6bPW5IFw0AQEsbsEuZvnsQyZ9VQfub01i+yX6nGH5xYrtWbmb21M0VlrzB+w+lL+452JWUvs8VYJKf4QCIjscUrD9ICIowo92l14T3bVgL/xzxuh4Oh86sUfQoR77qDhgBMp6V47z8d4WUzWEfiHoNSN6iC06Kd/PKwyT8UlYVzMOVity7+1o+OtK5P4pRcuM2oWX2+SFeHgBSVKkEFOIzQxXy14rSWg3nQ0RhtQEQ9EUcBW2d0vP/w6ZgtI5YPm2zVaKKanaxZROvM1/SqX4HgT7f8pVFHheNYo/iB9C1sr27014Pu4fk7sGhI679ZG8VonZIabTxYb30GTVagI5acCZv7B9XduAb36l0YZS/6aHPyvvVcqhQQ8vqaffGg/KelwEaLxnc7+LFJe8Siu3+p1p44Bxx4v8JWVevScTTE1m0SVwYoE6h9mn+13j2lYalvaYy73We97oZQHAhRiv0mBmjOS2ZGWJq066glr1v7D0H9C2gRrN/XzRg0VDEflY+lnohBi8KQ0bt23oEAavg4Qnb/Cq70BrqZ4rYnkfie9vanl2jRKJrejWQ4DLe+WhHTxc7D83gGIxQirtU/fboSIYF6N+ogYQGzFiTy0M/ecHQVKfnzEB3ZIzcfULBDfrESxSdwkYW5/2TWL02WZVQl6kNIq49aE985h2PZfPohLP9XLZ02/r6wWOd41BMbbqkMeEDCHLDphQ0L5UkTuqJScNDu10MTeHP4PBkJao8RuSjy9qwxrFdhG8pinIZ5TM0O6D7t/ZV8jZJRJc6o4ti3Ozfcnh0yVulfWXJWTG
 rzgFBJjB
 GLzB/L34k/JF+Cv8aBLNKPj44IVJ9N6j2STD1TRReV68m9rXztVnab5geZp+9P+lh1VT2qVF1F8fEMkDTGAfHOk/LkSPBVpkeWVs5BWnmHt0TCp4z4wZ0ddW+tMrfNwweO7IFGbgGbu8YT8BcdkybV+Uk0mgg0/IVoL+3xYthnLBGcNJvdZZSzLT8R5W7AdDgWQx+yTjTTHKbJ3nLBY7PQP/zQ0r+gwkxee8WQXdY++V+S/p5l0DWWwNpr0MsbtzSQtnjuGXqmqSQLJZhuKXqz/Brcynsw1d8Bxanc9wy2K1CpmK8XcqNtTHty5KH6xVXHDeJZvhJxsyurdmBr7YwO1+TiiUdIjr8Pw/KGLvYjppoc1zF+To58f0YLMHfpuabCsLMNAB+HF6p2OBCIJDXw74s2cIoCO0BICwKOu3xGmifeafx/AYCTVcsUCG9v43fHfCSgwc09u0XJiE0TPeLEIOb0+s7pMFyo4ePzYt/LMj6muDFfEURA0wjJ0metKnb1kHqfUwAz7ZhzSKii2z1xMHTRfYSJJFEm6AwAcg9nsetpYgf9ka8QOonq0lNngNfweOF8/IiOn1fYAzlDG7ABIKmRQ4AqBSoH7+rdu1p/ZY7xr8=
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
index 6740ae2bf948..b94639cdf312 100644
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
 
@@ -944,7 +972,9 @@ static void kvm_gmem_destroy_inode(struct inode *inode)
 
 static void kvm_gmem_free_inode(struct inode *inode)
 {
-	kmem_cache_free(kvm_gmem_inode_cachep, GMEM_I(inode));
+	struct gmem_inode *gi = GMEM_I(inode);
+
+	kmem_cache_free(kvm_gmem_inode_cachep, gi);
 }
 
 static const struct super_operations kvm_gmem_super_operations = {
@@ -1001,12 +1031,21 @@ int kvm_gmem_init(struct module *module)
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
@@ -1014,5 +1053,61 @@ void kvm_gmem_exit(void)
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
index c528b046dd69..028c348a1023 100644
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
2.54.0.1032.g2f8565e1d1-goog


