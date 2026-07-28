Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6E6AC54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 12:12:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F198B6B00A4; Tue, 28 Jul 2026 08:11:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC9CF6B00A5; Tue, 28 Jul 2026 08:11:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE15B6B00A6; Tue, 28 Jul 2026 08:11:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9BF246B00A4
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:11:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E6364A032F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:11:52 +0000 (UTC)
X-FDA: 85038071664.10.61EBA2F
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	by imf02.hostedemail.com (Postfix) with ESMTP id 412F480013
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:11:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=M5L+wxRK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 3hZxoagkKCLoyfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3hZxoagkKCLoyfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785240711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V9fXM6lRs795AVXt0xgZm237lDVZT/43F4+i2ayf4wM=;
	b=E562lR1v8GysDr2Ll4JGhtlJgaKd4RCwrBC5YxJNF5c/KTG7gugWoSw28fw0cMqWgTSiMK
	iUIsAaGH+It1yKUZ1Hpreoh+hyQGpydefiuxq05hYvel0G7SAL6hfUxVJpeEjD9Y8sbSev
	fCR41dB9WD9POLsXEyb1r+dGH324wEI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=M5L+wxRK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 3hZxoagkKCLoyfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3hZxoagkKCLoyfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785240711;
	b=oMJTRIH2Ciab/6V669TI+iwrKQ1ykADht75s9CkJSZ54Abx/0Aq2rbt6VNcptcIFTpUDCC
	llSW1ro9GP6y7UEP+3qgyhCzm0MeogE/TAznWvu9PVZbWuxRbikORTZ9tbDLLY/FYW+638
	fezVo+ptKFwBeDSUCbYiBKj5pBml0JE=
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c1670dd0f5dso347658466b.2
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785240710; x=1785845510; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V9fXM6lRs795AVXt0xgZm237lDVZT/43F4+i2ayf4wM=;
        b=M5L+wxRKZ1v5Y7waCN2hhJPX/TVVhhJWhbfHanb15UFfGPoFmRVxQBmUto+AmlfZci
         RX/S6iU+oCrXKt6fy3+71zS8pbaBVHO4PPiXrdGWUf0VPll6pd8zX0bPeVYjnQ9skcF4
         HM5YtT6174hlozWIwowe46k1ln7/bgcLYwgl5FG5A4uutSDaYBeEN/kN2v7kPIqcwEKJ
         bQJVU15IAhHjmUh0YFTEBsWb6/sai756qUk7i2XXhN3dOi8/EZ+6Pb2hv9mtRkiSsNsq
         AsUk56jPPg62y89j7FaTQBD4qmVqvNLZ5+l6nXBvXwPI+J/KChf//xl2ApJqdTwPfj6K
         R2Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785240710; x=1785845510;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V9fXM6lRs795AVXt0xgZm237lDVZT/43F4+i2ayf4wM=;
        b=ZuavT4hQUyVuc8OqQWnjD+m6gpCKCd5lxHKR1ecjlgNLk/ZXCKvnwERmhsc4Pe29e1
         yKpSa/h0EtzzZ0O4eGjQ6KeqzzZa/NqLPNMFqlGdfr+lMmmiwIdnWzkVs4bfJKH8bEZ7
         EbfeNImvEHgwo26eHv6B5SsYhf1+ZZ6quQMJrI3/PEWhsRa2zYwk/QQpsGRCso5cPsC8
         9hp4TS1Ozw+uDiak52v2bYmjqfpDfrN5RW0vqj/u1jgZOaGAxd83oLnZUVYh82jD/rkE
         st5uemIbw6Rpnkm1Ki6b+GaREsqA8XqiUU3ezahiUkS50sgI4obLTIY/2u261LywjMLg
         wkjQ==
X-Forwarded-Encrypted: i=1; AHgh+RpGHEoZzrnNhaJXm0IBZ3CjRQcMoRNl/IyKHLu6DJfShHTqEv4G50fY/FSbCTfdkgjAj/53o7zaWQ==@kvack.org
X-Gm-Message-State: AOJu0YxKFpzWolOq/gumJgQ9OMm7hY9frqel3x7PBDRCsyKUIGq6C6VZ
	h2+0VTRWpliowEtCUGmPKTa8I6OhPYB0q4YwkMtaJDg1SEq8qwxGsQD9EZCW3cnXMoLHvb3UPyH
	xR+v5aNA0FEN7s5Wv8g==
X-Received: from ejdr26.prod.google.com ([2002:a17:906:38da:b0:c12:9b2c:ffb1])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:c1e:b0:c19:45e3:2f57 with SMTP id a640c23a62f3a-c1f71d2cc6bmr102851666b.9.1785240709110;
 Tue, 28 Jul 2026 05:11:49 -0700 (PDT)
Date: Tue, 28 Jul 2026 12:11:34 +0000
In-Reply-To: <20260728121138.1103610-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260728121138.1103610-8-tarunsahu@google.com>
Subject: [PATCH v4 07/11] KVM: guest_memfd: Add support for freezing mappings
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 412F480013
X-Rspam-User: 
X-Stat-Signature: gzm5w9iurm47o65ic6dce6d39qnabdof
X-HE-Tag: 1785240711-772926
X-HE-Meta: U2FsdGVkX1+KwP2lGNI1KAZ/0KyNykwyubOP6ZTyQEWz8lzPxDd4usSGvNSm4bQRKEDr3B0eYaRDrBompQwhKNvWJcfAiuTNfRFU5pVHSkWGnzFJ5pu3zHGXGmASvtwfBCkvDvmx8FnsU7aJ3NkgM1v5yWw98/qVTZ8BwwSdOL8pqvTYXU4NTlnmiATVIUNWuEFJAMxDfu/2SieYNPCUn2z5FbJuUO32NdjVgSvAM+5O9FsNQgXyhQbR88wBaxxi8HszQdwh8qi8Hp1GiXQLBZf64xZQs9PVBYl/4wL5uCAhEYI2h0bi7K8NvjTFE7fFs/r5jKBseQnXoJpvEyDhpTGQS3Z9btFv2Pb8+wv0FwoP0yUkxbUE+1A8umPHoRABPGYA0C7q80f9N6idFnCzm3/xgVyr80RL3P6fyjvVJSvWd7te8k8oCSL1mjB5bN7CAE4nutPs3mTBzvfi5Tq9oYLh5XCb3DQUcOZrpRevrXBw5uqlJLaN7f8oXVt0faqZAqXP8YQhNFLis45kQWVdTGMMoLlQbDaBH4vuEKVCX9pIg2LE2iw7Bw0D9nqzTUp8GlBZ+E1xbQUpQcChqCNYBqpze6dpCOVCcTtTO0Wn7B/6UiVSmJQq4bmZKviOzPU0tZAaur534GdReC66w1IZVhV4BDMDNQDB+PAG6EuBiPs4g5m0U5I3E6j7b6DdpKRbMC514///KXhIkjk7L9djYR/Ozei4xkOvdrEAprlPaRCnjKVhX4Hx+K0zcDt9qrwDldNQGq0M/ynAg32G3qzvF/Iwa7NUE4ueB/OyTU/qwhRJaQp5/aw1RRbrad8S5hY53HEjCxDejUb6WNq9dExMDZy72d67leK+8meex4EGBjuDXUwekkBsog8+sBX3bl0pJwMhlZMOLV9q70z3jRFyWk5lhX/DPgUSz6YpipJLQFyA+sSDNtSp+PMoNc/xHK5JwM7rYVpSOUXzeB4sAcH
 3zt+ROqL
 6YggTxmul2vh8Kr+ggvrK+E+5e6KvkbPKLIAGsuocovJZ6PRj2sm+dE60Pmz8VETLOIh/cVzUmDmUS0/fpk9E5IDSTT+2O8ac/xxVj/VkmKa+ivBewG3CBysjmqtkYspp+Uj+BQBOwf30l6wZ2b4Uk7vFTExBcucJ1kH4rU7dSLVpoWHRahGkFkX0wQkJHlH6SNLZxjM9otApp8jUnLqrvWKWb4yIckoKSxwrIx/Q4DCrgzhfydN1ZO17U4CauYuMocBy25nGXuLHMZNQbWIwGT8AXxcSVO7sPWrVL7yaZUncR+wViup4826sTf4bh5HbBdcFFDJzsTvSD/fe8mVsddpdC/LaVkdOsh8bGE9PODkGdRZhow79ebikDsDRfz5uJ1RDrFzO/nn9T3Iaell5UhasnVaav7D5SJ2FeD+Pi5/cOBXTOhT0ixtvCmGFVsDwTHy9HKtthzbf/2GlB6Y7j36ZSno16FsZ1n47wDO9m4oSkUZil7sIlvd5CZyEADhYOWI/tDDT4JiM31kqmz45lPb4fVrg2oMCkO7INcAHqr18FIb2P61xAWl3h+OeOPiwI/+OCEQFMDGorPBZt/inC8ZP3EpWDPtWdRwJsuTrFieNKl6zkkulfLdoDr0iSqecXtmSA97SauNWInTgMEmrYiWgIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce kvm_gmem_freeze() to freeze a guest_memfd inode's mapping,
which prevents fallocate() operations and new page fault allocations
during preservation.

Use a global SRCU (`kvm_gmem_freeze_srcu`) to synchronize freeze state
checkers without incurring per-fault locking overhead or risking per-CPU
memory exhaustion (as per-CPU structure not counted in cgroup) from
per-inode SRCU structures by faulty/compromised VMM.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 virt/kvm/guest_memfd.c | 117 +++++++++++++++++++++++++++++++++++++----
 virt/kvm/guest_memfd.h |   5 ++
 2 files changed, 111 insertions(+), 11 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index dd84bba8974b..d522cc34f476 100644
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
@@ -1003,12 +1033,21 @@ int kvm_gmem_init(struct module *module)
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
@@ -1016,5 +1055,61 @@ void kvm_gmem_exit(void)
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
2.55.0.229.g6434b31f56-goog


