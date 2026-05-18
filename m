Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DED4CD4F52
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 09:37:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 896F66B0099; Mon, 18 May 2026 05:36:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86E646B009B; Mon, 18 May 2026 05:36:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7377F6B009D; Mon, 18 May 2026 05:36:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6224A6B0099
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:36:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0A843120818
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:36:52 +0000 (UTC)
X-FDA: 84780036264.01.AEC4A82
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3A2F1100005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:36:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nTQQeFAF;
	spf=pass (imf05.hostedemail.com: domain of 3sN0KagkKCO0iPgjchPWjVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3sN0KagkKCO0iPgjchPWjVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779097010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yB4XsnS5O2tJ5kB+OIL7J7kvYCLgSP2Q9yHfNFYen64=;
	b=6YB4BeEmYQkweWM6HTJFVOCIEkw2FR2ZlNXQ3I/ZxBsc+ro/tzSEy2tPPWtsSWA3TbVWGg
	UCpldHKqHqYbWaeyWmkQtEFr43w0paMpThghnhxN3reBDzPyUy+ucbT/vcpdPefkN6jkS5
	UBBnAtAGiF0vFxHmEGtanbJ7ybf92+Y=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nTQQeFAF;
	spf=pass (imf05.hostedemail.com: domain of 3sN0KagkKCO0iPgjchPWjVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3sN0KagkKCO0iPgjchPWjVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779097010; a=rsa-sha256;
	cv=none;
	b=pDJDlBYvLkwbUjkzbjZXW+fE31lngFVyUVasyMoQbUY5/rI2TtjHBw7APPueww8GovjS61
	M8YLU7Hca+rlNAJxCUmmA0X0SZHVJG8juFVKDAtknwka6qDZU/0T/ZVl2ep/f1z1MOgBQI
	/+fbSmztR113PBOZrSQq/s3ptOeioow=
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-bd5284d1e7cso298969566b.1
        for <linux-mm@kvack.org>; Mon, 18 May 2026 02:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779097009; x=1779701809; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yB4XsnS5O2tJ5kB+OIL7J7kvYCLgSP2Q9yHfNFYen64=;
        b=nTQQeFAFEZwDqNKq1lS3hxRItn0j1Ay9H8iRju/SGbyb4KEYxpzCu/48zUtjM820vf
         MTU5eyMnBNQr6/3/up/pH4xJtkNXUOcEDBou6YaQ9BRXzq68agrM48wwacot9/gsmNRD
         meY+y2FBHwWM0SBCD2sdd/tABYz7AruOBAqeI/iPN4+ZGPMHeFJ2ZFNjKfwEQ5EnKGfN
         JVy8ZSKpQiiJ4PzbPXb9wwDO6cT6pYbuHVkY45X+jHPs+NzQSYxZg2YMlANhlct9AOy3
         lpvYTybXECZjgISgFxcyhbs/u4t2sTJIiEVR8x2SGvHFRnxnpnV642XWdwwL1/VkHll2
         yNPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779097009; x=1779701809;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yB4XsnS5O2tJ5kB+OIL7J7kvYCLgSP2Q9yHfNFYen64=;
        b=nKF5wKaP2jmQiQLm2ugZycfTH1tylxk8hy17xAOhBYlLLTU+WXZpuwHH5XHavMYTXI
         BaHOOUZ2CPELA/iUvZAk/taiGGX3/PvFUDZMdtFAA3i4ScqYXcztkigug3Hm2Zqbisyc
         qzfrxOpw1F5OrinVpHpXbMLvHN/cALY3mXDnN7SvKZprImuVncmbeV7gys87UjrVC4U5
         kxCrjagfXY+AydTWOj3BoHvBOipaAfB4Wt1WC7bWeBKroV0cMpoJfSA01tV8K3U+BwBa
         tVhQkemxRaiR/u0WrLE1g78fVkadeugayQgWq/ThWZE4glLAPij+4ooHzP26XrYoKBU3
         MxOg==
X-Forwarded-Encrypted: i=1; AFNElJ+Qq3SsGSIyIMJ2mwNBlN7UJQ/mjqr3Y4Q7BqailwNZfp9aNOfYvmcJyIVTZyLmsRj9tdleUfnQJw==@kvack.org
X-Gm-Message-State: AOJu0YwBqwEN9f5R83fPXzeUtj8a+abHESEXJ8asKiKTCAR95M09ZbEB
	ktXa7qLWoW+UfZYhVOmwHn+uWo/aQ/L3UBrrbth53UcrNFlvpJbtN2negXX4j/J43TOtS/demGw
	z1m8hA8Kbc5HUwNKZ4A==
X-Received: from edj17.prod.google.com ([2002:a05:6402:3251:b0:66f:cd9f:9fd7])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:6d1d:b0:bb9:36dd:cd3d with SMTP id a640c23a62f3a-bd51776c98bmr687818166b.4.1779097008430;
 Mon, 18 May 2026 02:36:48 -0700 (PDT)
Date: Mon, 18 May 2026 09:36:36 +0000
In-Reply-To: <cover.1779080766.git.tarunsahu@google.com>
Mime-Version: 1.0
References: <cover.1779080766.git.tarunsahu@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <823a5f2af1d794c61560d0bad96863c4c851f29b.1779080766.git.tarunsahu@google.com>
Subject: [RFC PATCH v1 6/9] kvm: guest_memfd: Add support for freezing and
 unfreezing mappings
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
X-Stat-Signature: xst3q9kih4ghefretkjyejagpsm94ghs
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3A2F1100005
X-Rspam-User: 
X-HE-Tag: 1779097010-838862
X-HE-Meta: U2FsdGVkX19+JSdLXVA5cu/KIlg1jHdhpnJhOite7r8C0BpQwvrVLlWO0T94zJY99UCSBaifHIH2mmLbd0j5lm25nsD6JvN8MJ2OgrOSszce+UPO8OZixRloaN7IAX0LewBJ/llyzrS64lWfVNp+UEdtUJwMAEBDZnmqANSnbUhpqPXO7AjJnpfuVVHq5oZ6wCnDMAdUAsZOiI+byKcLdnxb3G7wvFMfIR9a71tVASIevQYtvGiGsDGWrjXgFn/iJ76uOp2hK9Xx4AhslXY/R32/jBCxuOGAkXU91otcZTYwnuno+XWimGo6kzGHlmkQq2Vijoa8i4RpWf111WYTCHJO/Y7Qz920wyY2pZtE2nwZ6HO6gerJjIGObjSX6O/94NwsrymkqF/h/1OWw1QGV8DKxNcTbfIuplX19msDtdX7WV75X1TqxYYJvq6vZpZz67yTfxkolUAlakhKvTGq/U1DrwC0GPaKlDosnuJW0rcRdWTbebAjD0ohZb2Dr5M5I2eeUpXETLwksWGtMdgIl7hQV8iQ1R9G1ab6PPxTSluOnwzyKXKAFQqNlBygyhOgIuxIe0aeBhTVXWnefy2wN86YE8QrCZPPNCslS0FHC8HHwtk8kPPPby7fSifV1w/LtTFKlLmA6cQidU3AZ5z1VyM09J12ge2PNkFA5scWXlOzq6xFsbv8xZtJtrJDi/OEi7A12TyZ66ut5xIvlj5Xf8NwhFyHTJRXp8wgZdG1wahaPlYdCevZZvK8fC+h6WcFn2Jv6VEA5Yv4YlweRknqMNza6B2qK7H8fNk2QKUp3g5dLK5TyChEMaBXOOxTHM9mZKdH5kjArmGH9FT1xQzxADZpvziPKaV793b2pyIJA2Ntz8hn7ScHjFK1zy8v7DQzei3m7u1vT8yXORu+Sjhtb7i0mh7thTsmvly2oONhC3PgCMbs25H0yC40lZRw3+biPrMQzKJcEe/7YA+Efsd
 K4uAa9ug
 9Qi9JGDqdF5gXWamQaKv26skfiBtnN6bXv0fiAjTsGFQc8U+IV63RIE5HrKICJVeW/ZHva8b6CIx93X3a9Ezn/XFfJfUd5q7bMgetaP9D6MpMjRFCK0RtKdRN7UZWJbZgb+XQg4Ghi+GNhFkekcx+VuC1GeTyvOzDXngt/VlDR79uHqDGZ4bkoD9+8xK8Lzau2aULGR/NxOzwHGuF9HV8QInwWTITCyGvqvGN6XZPJaEu+4GRHRz1h9NNO8LBx38AhQuKGoBYC10KrmQ7dX8EtamXL959Uo8aMY6vs6GttDskivHIGVO2FAXZTgTy5GT2L9wju1aaONcJ2jHcGivF/Qm7+fob1zAdwOBKqMymKl+tpW37/sjxwpdycxLWFvg/091XTk2VUoCG+bBdr6zaoT2GZwDoWGeN0GuQsqf3COJ/LWFs7VB5FHWSTjpJIHH88rSK42gD88XBsfdIHiliPQgmxgyG35YgXD5Dyg03NK5/kIHbCFVfqm94bEz+m8QSczAMPfyf1dJv2ngrHsdGp2AzepMiw2pNO3CR59mZZF48GUJ5zFHszZlFLh//Wwt3jU22dYDMR5L/Rjj7LzsYfB8EnfEutjl3Zf+MIYdtPGfuc8o/iOesOxW2wA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch introduces the freeze on gmem_inode which prevents
the fallocate call. This will avoid gmem file modification when it is
being preserved

Used srcu lock to synchronise the freeze call, where write blocks
until all the reads are free. And reads are re-entrant.

This can be extended to freeze the fault path as well. But currently
the fault failure due to sudden freeze might be fatal to the running
guest.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 virt/kvm/guest_memfd.c | 112 +++++++++++++++++++++++++++++++++++++----
 virt/kvm/guest_memfd.h |   5 ++
 2 files changed, 106 insertions(+), 11 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 6740ae2bf948..91e42f717286 100644
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
@@ -273,16 +276,30 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
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
@@ -291,6 +308,9 @@ static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
 
 	if (!ret)
 		file_modified(file);
+
+out:
+	srcu_read_unlock(&kvm_gmem_freeze_srcu, idx);
 	return ret;
 }
 
@@ -944,7 +964,9 @@ static void kvm_gmem_destroy_inode(struct inode *inode)
 
 static void kvm_gmem_free_inode(struct inode *inode)
 {
-	kmem_cache_free(kvm_gmem_inode_cachep, GMEM_I(inode));
+	struct gmem_inode *gi = GMEM_I(inode);
+
+	kmem_cache_free(kvm_gmem_inode_cachep, gi);
 }
 
 static const struct super_operations kvm_gmem_super_operations = {
@@ -1001,12 +1023,21 @@ int kvm_gmem_init(struct module *module)
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
@@ -1014,5 +1045,64 @@ void kvm_gmem_exit(void)
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
+ * NOTE: Currently It is only checked at fallocate path. Page fault path NOT
+ * touched.
+ *
+ * Synchronization Strategy (Sleepable RCU):
+ * To avoid high-contention VFS locks (like inode_lock or filemap_invalidate_lock)
+ * on the vCPU page fault hot paths, this subsystem implements a lightweight,
+ * system-wide Sleepable RCU (SRCU) mechanism (`kvm_gmem_freeze_srcu`):
+ *
+ * Though currently, the freeze is checked only in fallocate, but it might be needed
+ * to the fault path as well in future to completely freeze the inode.
+ *
+ * Global vs. Per-Inode SRCU:
+ * A single system-wide global static `srcu_struct` is used instead of a per-inode
+ * SRCU structure to completely prevent unprivileged users from exhausting the
+ * host's per-CPU memory allocator. Because `init_srcu_struct()` allocates per-CPU
+ * memory via `alloc_percpu()`, which is not accounted by memory cgroups (memcg),
+ * a per-inode SRCU structure would allow a tenant to bypass cgroup limits and
+ * trigger a system-wide Out-of-Memory (OOM) crash simply by spawning a large
+ * number of guest_memfd file descriptors (bounded only by RLIMIT_NOFILE).
+ *
+ * Flag Modification Note:
+ * Since `GUEST_MEMFD_F_MAPPING_FROZEN` is the ONLY flag in `GMEM_I(inode)->flags`
+ * that is mutated dynamically at runtime (all other flags are creation-time flags
+ * which remain strictly read-only), there is no possibility of concurrent bit-
+ * modification races. Therefore, a standard `WRITE_ONCE` is fully safe and
+ * does not require complex `cmpxchg` synchronization loops.
+ *
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
2.54.0.563.g4f69b47b94-goog


