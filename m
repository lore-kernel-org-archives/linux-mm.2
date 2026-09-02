Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F4073C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 19:47:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10B816B00E0; Wed,  2 Sep 2026 15:47:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E2B16B00E2; Wed,  2 Sep 2026 15:47:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F14246B00E3; Wed,  2 Sep 2026 15:47:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72ECC6B00E0
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:47:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D530580350
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:47:07 +0000 (UTC)
X-FDA: 85169855694.12.70A9ED0
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2264D1A000C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:47:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WVVTil9g;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788378426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CBcqkxQZqwfVczJ4Zyf97FMnYegDKAQ3ju3Ot5Bn64M=;
	b=iJ59g4VM5z57jQxiSRG7epeTpkNMGXGjwVQfRGWoUKU2r06N1uWTgGgblbK38/CDvTyxzZ
	l5cngbLZM6MYZTOucxmlV1TdCrkUrlAxJ4nGE40sUsm0QQEAcl0moIzuEXOMGRijZ0XblE
	3UxM9woPEqUVrbShAmUwlQ8j7BosLns=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788378426;
	b=p2AdQOrraE5qSAsYT8Ar9sZ6teU+HGpgKauf76+2nxfHvgxxDVISjKxSFqPf7n0dmuazYI
	MNUzKJpn3wo83pShvo11M1tgNcuoxbyY+/CzKV3pIjUcbMD8z93dLzS0sEVsNM4yDcUJER
	vfHlfzg0n7JOTTApVOxgDtGADoxyZR0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WVVTil9g;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-939094306b0so135038585a.3
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 12:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788378425; x=1788983225; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CBcqkxQZqwfVczJ4Zyf97FMnYegDKAQ3ju3Ot5Bn64M=;
        b=WVVTil9gL6p3cV5Uhhdi2EkfxBHcP0rxepNmP5ycZm8icgHDmttRzCDtEqypww8M1U
         IZO4udNYdfydSM+Urj5d5E/XpkFOpLhThJvikW5Dk6zCh+boEOMURfSb566YILcaRmwe
         iAyS9RGUei/0HKG8N7NMv3xDz8++vpwxt9pwUrr1Aa0o2UV5kDSP8BV3R0B/P381X48u
         GDwcgnCo31mBDbQPAq4LYNoC+ovlrtqgisaZ805iADxJi7wA4dekciJYUkwc95lmA9ff
         CP2mNVGsjmLe51pPeKIMX+3VTGV4kNI/GK9eBbB/5lKofddv2SfMSRoJFFiRm6bnksKX
         YDcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788378425; x=1788983225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CBcqkxQZqwfVczJ4Zyf97FMnYegDKAQ3ju3Ot5Bn64M=;
        b=I5qM+y9+S5BPkLDfXCIcUqM0gRORmhdY31v0t1GWgNJa4JUErtIhbMI4rOmvAJf++9
         RDzvCFxHxJKzSuBLEHh7zuBpn6eo98/GxwkJGZj58FPBoIeLkCmLPfH/IG70jVITpwDv
         ooUexioEZEWmcDY6GrXVldmWEKTRzzKkdAmhL3ksnYU2lMpKHKK4SgOqW/zx/8FmM8ta
         4ZSdD2xh8U++BtIolssUq+kjxn38x+qROoq0Z6UG+RVUWvxYqOgm4IVFBv0jyKXXbdl3
         obMGNJ51++dW6e9MPDitsd1YbBO+Qza9CQN5TmjITMPo/Mph5pw392BdDB9dbCBO3vS7
         0yBA==
X-Gm-Message-State: AFuF++lRkQZNu+dL+P2OaZmRx3FxREkT7V5iAisod2J2IC5s+yBNyfAr
	5REj3rzUHZQ9NKtPazcnQaN50IjUVcLKKmR/2iUNSFpQLrVuISmZ2t0KClTVqA7q+OTxWR7JHp6
	xPpXMnAc=
X-Gm-Gg: AYBFou0N2YEu+8KPpYVwDWaqEsRcuLLGMORzNXVQRp4mfNGlpuwoHlEfr7/Y+g9kmX5
	JS0OL8IQTbvqCdudqybuiw5ndrhgHD4jChmOzJiq0tdPoMnsAGPn9aVuqCdIX9fcwxlteiRz9hw
	yK97NtCKprBe2oOF6I/hBvtGbJz8UKES3EVCSegQBslCfZKMc6b+qnbSmE1Z3LamwiNksLo+wDh
	76FjL4SSccU5kfpdUQlfY/mmNCzMTAU170zV9++CWloRLwAbbzfNxyt06XTfcWEV4N3mt8EVRd8
	6RxefDHX6p3GuWh+PCOb2dRcPJHjzptae7J5RZZSlKBeqEM1zjjVrKBIvq6C15XoQESC4ZyodM5
	iY9pf2CV5de1GVq4UX6tFeJpmpeaH3h8sy9k2UtaWM9n5qXaSr+f/2ccD4h/I/xZYKo2wypu2rJ
	M+ogExBtj/10xEoMXEUit2/7xSa9FoxWY9NZT21yRX/Cdyr1TtoC3gS893TuTH6TbEttB3GDpaJ
	AXxJ1N13a9xFn+p7uZrdMjUXYYRGcgMrhUEHC2wiwC3mV+JdHrWKw7szAhN
X-Received: by 2002:a05:620a:bd4:b0:939:3a8c:28f4 with SMTP id af79cd13be357-93960de25e9mr874489085a.10.1788378425144;
        Wed, 02 Sep 2026 12:47:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9395f18801asm299300585a.16.2026.09.02.12.47.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:47:04 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	shuah@kernel.org,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 3/5] KVM: guest_memfd: bind backing memory to a NUMA node at creation
Date: Wed,  2 Sep 2026 15:46:55 -0400
Message-ID: <20260902194657.79075-4-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260902194657.79075-1-gourry@gourry.net>
References: <20260902194657.79075-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k3zfmdxqpqiewrmd914ucptapyrr4jqz
X-Rspamd-Queue-Id: 2264D1A000C
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788378425-914731
X-HE-Meta: U2FsdGVkX18Zc2vSgPuUQo6E9FBMW1H4C0Uo3KNxpNN3YLJxXTOsJVx6Rh6tEVwS3oNWquVCQynsOytxxJtxeWG3HYHgBwjVwV973DRTSDRbKvmxZ4gFqgC3PpQhAUw4t3wt/+0SyER2n6X/f7IgLnJ98mJ2ru3kFcj+umPQsPWb6gBYj4m79lwftd6mAACI2QVVYb2sR09da20MZja7bRN1OaBRXbTw1/0svL62a2IfW4nolPIeH6tZmlRJB6ZunvkMEb5ktA9GKpgfxveAddVQHn/dU2QtpNb+0Z9EBnnLUNykCQdpczqQupy4lyqCYDld15eOvkTM4O/7gVMrEAnn6OvP0DsGB67wR7v86u1Q4/XVYJimySnHyw06gaUKSQHGSSKkD+Iil3jHaSvVvf24mVByLM7J6NvV58qkWufVvKszK6XLcwEvfm+yB/cGe5BJBDcWaTFMR4+uroqAq3Q5kDraxqDUuqGDIcG3/YSc9NheZYu9MhaDx5nslk2rYdzFRjLwiVrqnT74DiCG4Ik7ZRSgtOWKoKIU5NW935QeVM80QIMd0pUtc84i7nTh9pmMgrc1sh5ZHC+tkNHCfsc+VzHtLckk6bR5kkvSyxb3MtNif6BcRm3rid+BhWuGZF1ioLyrEb+Twsd8KIMfI0BT9MEdpA5zXHCDoFH5VHYL2cASYSv89Y3skJbPXzk8wVJzuNJ+mn1Y8MKVSsXp8R1yhWfZT+hgsL1Xf/6XOhBKBgxrTTgI08Fc9MZagu64r7MGNWhxp2oeM/QJ7Dhm5IwnY+QQXzEelkwtcnr6d1Anxx4cjvjsm2vzBcjn3Ip7a/AWkWcG7ekg40kzg/snEJu0eNEKgcBX6Qta15/WbimbAmZp7FAU0PzYJUWIlJ4FVScTyYQHlj21O4o/WNpFshNdXAOvu1B+oxGUjB8oTSX6FLZ/pFcLqW7LDqVN9XmpIwhN5DmhAW5bA0ZrM7x
 cXmJ/rlJ
 N4Ky4Bwpocs5fh+lSenRq8h7V3QwSD7sYi+v5v/+A0wJ+CzN1wHDYSuSTizv7Y5qMTXATuBGJjlCQu2N8kAW+gC6KbEfeqmleGilycFMUDxx1GRgYW36PTfZoAi24g6DaSI1a5hbmKIXoSwAuMYGnONa+7L0ddToxpQxjae8fi2WgdQlzcZmcU3vyD/WN+XWRQ1aO9GTYab58D5CUhrnZXAeU2B92hxqna7JcB1ZOcCWHpUlB0Jqgh4YKKsPxG2Wr2gDw2Yv+WUNq18U3knGB2AgV2tp255rCS1qcr/uCKOacqtFxKcXzD0kpiDpj4+R4/L5391c+e0rWuYxTHmvPqww7mSB/7w0gWBNYch6wR9BDB5EO9LU99Wp5jgfZR6RwIuHhU/HFacH7dhGq5OC22YNPmFr1YITB450E+7aulFTBPbjZBktqH9ekRjxQiGBKr4za
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

guest_memfd presently allocates its page-cache folios through a
per-inode shared mempolicy (kvm_gmem_get_folio()).

Today that policy can only be set after the fact, via mbind() on
a host mmap of the fd. This requires the fd to be mmap-able and
cannot reach folios that are only ever guest-faulted (no host VMA).

Neither holds for a non-mappable (confidential) guest_memfd.

Add GUEST_MEMFD_FLAG_BIND_NODE.

When set, KVM builds an MPOL_BIND policy for the requested node and
installs it over the whole inode's shared policy, so every folio
is allocated on the requested node with no userspace mbind().

The flag is advertised through KVM_CAP_GUEST_MEMFD_FLAGS only when
CONFIG_NUMA is enabled.

Two user-visible behaviors worth noting:

- mempolicy_create() constrains the request against the calling task's
  cpuset. Requesting a node outside the cpuset mems_allowed results
  in the ioctl failing with -EINVAL. Binding is essentially subject
  to the same cpuset constraint as mbind().

  This behavior is correct - a task cannot grant a guest_memfd access
  to a node it cannot access itself.

- The policy hangs off the inode, and nothing rebinds an inode's
  shared policy on a later cpuset change.

    mpol_rebind_task() walks tsk->mempolicy
    mpol_rebind_mm() walks vma->vm_policy

  Neither walker reaches a struct shared_policy.

  The binding is therefore fixed for the life of the fd. That matches
  shmem, whose inode policy behaves the same way, and is the intent
  here: the node is a property of the guest's backing memory, not of
  whoever happens to hold the fd.

Suggested-by: Dave Jiang <dave.jiang@intel.com>
Co-developed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Gregory Price <gourry@gourry.net>
Assisted-by: Claude:claude-opus-4-8
---
 include/linux/kvm_host.h |  3 +++
 include/uapi/linux/kvm.h |  5 ++++-
 virt/kvm/guest_memfd.c   | 44 ++++++++++++++++++++++++++++++++++++++--
 3 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 03bfc92864b6e..738e276633c1e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -739,6 +739,9 @@ static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
 	if (!kvm || kvm_arch_supports_gmem_init_shared(kvm))
 		flags |= GUEST_MEMFD_FLAG_INIT_SHARED;
 
+	if (IS_ENABLED(CONFIG_NUMA))
+		flags |= GUEST_MEMFD_FLAG_BIND_NODE;
+
 	return flags;
 }
 #endif
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index ac2d77d149635..8d3ae7e2ead8e 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1658,11 +1658,14 @@ struct kvm_memory_attributes {
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
 #define GUEST_MEMFD_FLAG_MMAP		(1ULL << 0)
 #define GUEST_MEMFD_FLAG_INIT_SHARED	(1ULL << 1)
+#define GUEST_MEMFD_FLAG_BIND_NODE	(1ULL << 2)
 
 struct kvm_create_guest_memfd {
 	__u64 size;
 	__u64 flags;
-	__u64 reserved[6];
+	__u32 node;
+	__u32 pad;
+	__u64 reserved[5];
 };
 
 #define KVM_PRE_FAULT_MEMORY	_IOWR(KVMIO, 0xd5, struct kvm_pre_fault_memory)
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 625e62e1a0318..dc9f071dd969b 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -423,6 +423,31 @@ static struct mempolicy *kvm_gmem_get_policy(struct vm_area_struct *vma,
 	 */
 	return mpol_shared_policy_lookup(&GMEM_I(inode)->policy, pgoff);
 }
+
+static int kvm_gmem_bind_node(struct inode *inode, int node)
+{
+	struct mempolicy *pol;
+	nodemask_t nodes;
+	int err;
+
+	if ((unsigned int)node >= MAX_NUMNODES)
+		return -EINVAL;
+
+	init_nodemask_of_node(&nodes, node);
+	pol = mempolicy_create(MPOL_BIND, 0, &nodes);
+	if (IS_ERR(pol))
+		return PTR_ERR(pol);
+
+	err = mpol_set_shared_policy_range(&GMEM_I(inode)->policy, 0,
+					  MAX_LFS_FILESIZE >> PAGE_SHIFT, pol);
+	mpol_put(pol);
+	return err;
+}
+#else
+static int kvm_gmem_bind_node(struct inode *inode, int node)
+{
+	return -EINVAL;
+}
 #endif /* CONFIG_NUMA */
 
 static const struct vm_operations_struct kvm_gmem_vm_ops = {
@@ -520,7 +545,7 @@ bool __weak kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
 	return true;
 }
 
-static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
+static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags, int node)
 {
 	static const char *name = "[kvm-gmem]";
 	struct gmem_file *f;
@@ -561,6 +586,12 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 
 	GMEM_I(inode)->flags = flags;
 
+	if (flags & GUEST_MEMFD_FLAG_BIND_NODE) {
+		err = kvm_gmem_bind_node(inode, node);
+		if (err)
+			goto err_inode;
+	}
+
 	file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR, &kvm_gmem_fops);
 	if (IS_ERR(file)) {
 		err = PTR_ERR(file);
@@ -593,6 +624,7 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 {
 	loff_t size = args->size;
 	u64 flags = args->flags;
+	int node = NUMA_NO_NODE;
 
 	if (flags & ~kvm_gmem_get_supported_flags(kvm))
 		return -EINVAL;
@@ -600,7 +632,15 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 	if (size <= 0 || !PAGE_ALIGNED(size))
 		return -EINVAL;
 
-	return __kvm_gmem_create(kvm, size, flags);
+	if (flags & GUEST_MEMFD_FLAG_BIND_NODE) {
+		if (args->pad || args->node >= MAX_NUMNODES)
+			return -EINVAL;
+		node = args->node;
+	} else if (args->node || args->pad) {
+		return -EINVAL;
+	}
+
+	return __kvm_gmem_create(kvm, size, flags, node);
 }
 
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
-- 
2.53.0-Meta


