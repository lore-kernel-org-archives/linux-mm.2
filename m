Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27654FF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:28:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 933A26B008C; Tue, 28 Apr 2026 19:28:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90BCA6B0092; Tue, 28 Apr 2026 19:28:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 820CC6B0093; Tue, 28 Apr 2026 19:28:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 72D156B008C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:28:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8C59E1A07C5
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:24 +0000 (UTC)
X-FDA: 84709548210.14.CB6498D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7532D20003
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jwHJMNGe;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418722;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Onn2sqgM6vArj7MEnNFLd4foIeWiREVRPOEbI1FtRg=;
	b=HfQgasEjdspBoDgLLMWPNsaGIfpjtNr1+gZmBNg2NxguyYNHJ6URVgGbefBwJb4lvawRKG
	5O4lOSCYABtBSrRPL1MYu2fFh/b8EQgt2+uMTG3KYleJNA63JDdDcXTAfEIb43CHVrVpAR
	w+w3hXUi07BlAgRqnphDwKXVYI1O8Kw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jwHJMNGe;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418722; a=rsa-sha256;
	cv=none;
	b=gYYhrYtMywENviz6eO5QvlXm3kvfpCRPpDFTwDfzmCYJZR+Zxk8AudDRkp2PbXIXg7rmLM
	Q37CEJXrvxgYfh3WMfn9dfggedyPKtAKJwXa1wEm352Vc9Q80nP0b2DbwoetNPJNdk9+5j
	Zcz42RtPDpmEoXfkCWIbyiLC0TkQmSk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 38F0544837;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB741C4AF52;
	Tue, 28 Apr 2026 23:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418718;
	bh=cnjGzw9NY1OyzWvnH+SRSy7P0B55lk23vOepqJJFsVY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=jwHJMNGeoiPCdDkdojNZzbaHJwu7NAoMOXNsHYMmkDyI1f8RIquPa+x/2Ymn3LnFv
	 bHxvB7Aj/iFw3sagvvdNKCxycM+YuETLVfG66ERN9+UfSZeavwV/BIvbvBc975SvQe
	 tTAPS2mK1PlFV01rovcyIe1qrU4sfA5fDwTRlbjVXS4hNiG89V3Bp99Em7TWFbCIXQ
	 GzHmofkodfYsMoiJ85UPtE9EPglGSv7XrudRbDnKS+Z2+xPhx3OLTTS8KZ4Mf/sLsk
	 EsWSvcIMN476hD9PJlktXS8mZEhQRzcI4Gob9usIQgBz4nQ9p6/WqVK9oSPWGzSY4J
	 TXmLApN/+d3bQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3AB3FF8875;
	Tue, 28 Apr 2026 23:25:17 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:05 -0700
Subject: [PATCH RFC v5 10/53] KVM: guest_memfd: Add basic support for
 KVM_SET_MEMORY_ATTRIBUTES2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-10-d8608ccfca22@google.com>
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
In-Reply-To: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=7268;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=spJ+/mHdea9KTBTdOi0gNUqMga+eC4IE/RiHVBAOX1g=;
 b=gsMa4tvF0Nu80a0CXmAst2uq0LQatxfGP0x04q1lWe7t1PnwEX7WF1VJJtclzwbMuXKcPPsi1
 p+aKnfQ2cH5D8UaXg+l3l01U2jA5BoDejQ9onrVaAutSp9ImpZBvxsJ
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 7532D20003
X-Rspamd-Server: rspam06
X-Stat-Signature: odp7f7fkrackbtqjrxexqt5xoqh1w63g
X-HE-Tag: 1777418722-423600
X-HE-Meta: U2FsdGVkX19uAJ3B35lj/lU3MlDUoqYU3Zsd159+JNmtkxVTIwIoeQItVRRmTvmSEIk7EY/BIxdU90wP4WIYzr2J0tnolfVADMFeW3mzYFLtlvp7bwBuE0F7C0dvxDaDV4OiNwf+V7bTjBMBoXnINxdV08qzn+cZVMN8ts4px+DBMpEfvvUKQrnqug4U4ChLPywf0FxUVyMrsFLyW6kFVQ2EAAhZtnzeez8dOQrdJUKo0kyHdampCBm1RIy5mw+zYe+XazbqJZV6Mq19vyTbrUBgZD2j8UWHKwLz1UMmJQTYO8lTEKZkCYaEHsxJABKtihh9OSiGoyTunIYcxxg8sHvvEy7wP0iezXlBYi1VAYQbncUm7axLgXr1Qo0dqByhQixXZ7VLrqRDlSWuEGJhL3MefnxpaEaWQLtZdcEMPhPMBAVWa4yApq7Me1c9T7mDR4mUJngZkFhZ67fFHo0uh358yQmeQ7pffqNVLlqfV6JxETWEtX1j31L6xTtU3VaVY3hHtMFGApGMwxiLFiwFz5nrrJUksL6CMwCARe+whi5IWDS6Jl65f1s77n1cfcqPjuIkiJ3POvyITfsjwQ5+/zzw+udHhTRqx6Jr/rMlObmCo43x/0g63PGq8bIVny/JKbR2pIK2i2Z8FKA0zEKa1RK9mHLlEbrRFWvfrHp5Rwo4ysewY6ctY78oukdbXazgxEVO5cZydCmMgjMHMJE1N/vu608pc/5izQi2LMwYGSRRw8WXXNf5A84m6DwJ6lYjmMYLh3O2kRuTlfhz3D9HmB1E+JpGVmLBBMZZDxajEw8WxZgAKT05yrWj2SKzQtF+MaKDH+eH1N1PopMiorgNlbT5d6OkySbU08pmBzWp+qjq9DHJM+8WXC/zwrTwec0RBBHJa1WJP4+b+tNBIJwrxjuxpQt2gcmDgKtH0hSCTndV73ANZCNkTq0iVha95FkesD1PoHoz3Q+dTlRYss3
 TPBaNYJt
 og7qTdmymdeWePdxaKwxhxwRCuJB6u4FoTBYS6wTsmmYzhSB0ERtQdGSV90pvZQRE0B1b3qL0CdmM5Z4ZtzgWxoU+IVlNlDSCHb4PpRHBbqS7ESmWn3QXPyZwYYsSeAQAKBpnSBIrHBBaHvF0H4STHK6OGXlqTCxt/hvarHjcxm4qgW2p4RB6UbJzHVmD8x3ccIPS1+uvpCCXj67xb/J4RWyNnHlGjiAq3XKjCbFwiOXTCPXHm6zTDcv/j3dzpxqqPGULNOjeZoZbSXyc69OzHbawyNB9my+zXIAtdH4Mt4mJSph8ni99fUsDm6MKWUg8aP+bdQcxZfl5LkgxzDaA5BQA6fPAxAJ5CkGGHpOJjB23+7jGOFjf+QmMM8LEoT0tQ0TnwVCsuqDFUbPNFaPGH1Y4BPC7unHiDlKDKuOnURWBepKsCoWdJ2gi8wQLGxBwl5PkC1hjk9GVwgZOdU78RIQqNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Introduce basic support for KVM_SET_MEMORY_ATTRIBUTES2 in guest_memfd,
which just updates attributes tracked by guest_memfd.

Validate input fields in general. Guard usage of KVM_SET_MEMORY_ATTRIBUTES2
by making sure requested attributes are supported for this instance of kvm.

A new KVM_SET_MEMORY_ATTRIBUTES2 is defined to support writes (unlike
KVM_SET_MEMORY_ATTRIBUTES) in addition to reads so it can provide error
details to userspace. This will be used in a later patch.

The two ioctls use their corresponding structs with no overlap, but
backward compatibility is baked in for future support of
KVM_SET_MEMORY_ATTRIBUTES2 and struct kvm_memory_attributes2 in the VM
ioctl.

The process of setting memory attributes is set up such that the later half
will not fail due to allocation. Any necessary checks are performed before
the point of no return.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
Co-developed-by: Sean Christoperson <seanjc@google.com>
Signed-off-by: Sean Christoperson <seanjc@google.com>
---
 include/uapi/linux/kvm.h |  13 ++++++
 virt/kvm/Kconfig         |   1 +
 virt/kvm/guest_memfd.c   | 114 +++++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      |  12 +++++
 4 files changed, 140 insertions(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6c8afa2047bf3..e6bbf68a83813 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1648,6 +1648,19 @@ struct kvm_memory_attributes {
 	__u64 flags;
 };
 
+#define KVM_SET_MEMORY_ATTRIBUTES2              _IOWR(KVMIO,  0xd2, struct kvm_memory_attributes2)
+
+struct kvm_memory_attributes2 {
+	union {
+		__u64 address;
+		__u64 offset;
+	};
+	__u64 size;
+	__u64 attributes;
+	__u64 flags;
+	__u64 reserved[12];
+};
+
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
 
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 3fea89c45cfb4..e371e079e2c50 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -109,6 +109,7 @@ config KVM_VM_MEMORY_ATTRIBUTES
 
 config KVM_GUEST_MEMFD
        select XARRAY_MULTI
+       select KVM_MEMORY_ATTRIBUTES
        bool
 
 config HAVE_KVM_ARCH_GMEM_PREPARE
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 506219e2359eb..9a26eca717047 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -552,11 +552,125 @@ unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_memory_attributes);
 
+/*
+ * Preallocate memory for attributes to be stored on a maple tree, pointed to
+ * by mas.  Adjacent ranges with attributes identical to the new attributes
+ * will be merged.  Also sets mas's bounds up for storing attributes.
+ *
+ * This maintains the invariant that ranges with the same attributes will
+ * always be merged.
+ */
+static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attributes,
+				    pgoff_t start, size_t nr_pages)
+{
+	pgoff_t end = start + nr_pages;
+	pgoff_t last = end - 1;
+	void *entry;
+
+	/* Try extending range. entry is NULL on overflow/wrap-around. */
+	mas_set_range(mas, end, end);
+	entry = mas_find(mas, end);
+	if (entry && xa_to_value(entry) == attributes)
+		last = mas->last;
+
+	if (start > 0) {
+		mas_set_range(mas, start - 1, start - 1);
+		entry = mas_find(mas, start - 1);
+		if (entry && xa_to_value(entry) == attributes)
+			start = mas->index;
+	}
+
+	mas_set_range(mas, start, last);
+	return mas_preallocate(mas, xa_mk_value(attributes), GFP_KERNEL);
+}
+
+static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
+				     size_t nr_pages, uint64_t attrs)
+{
+	struct address_space *mapping = inode->i_mapping;
+	struct gmem_inode *gi = GMEM_I(inode);
+	pgoff_t end = start + nr_pages;
+	struct maple_tree *mt;
+	struct ma_state mas;
+	int r;
+
+	mt = &gi->attributes;
+
+	filemap_invalidate_lock(mapping);
+
+	mas_init(&mas, mt, start);
+	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
+	if (r)
+		goto out;
+
+	/*
+	 * From this point on guest_memfd has performed necessary
+	 * checks and can proceed to do guest-breaking changes.
+	 */
+
+	kvm_gmem_invalidate_begin(inode, start, end);
+	mas_store_prealloc(&mas, xa_mk_value(attrs));
+	kvm_gmem_invalidate_end(inode, start, end);
+out:
+	filemap_invalidate_unlock(mapping);
+	return r;
+}
+
+static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
+{
+	struct gmem_file *f = file->private_data;
+	struct inode *inode = file_inode(file);
+	struct kvm_memory_attributes2 attrs;
+	size_t nr_pages;
+	pgoff_t index;
+	int i;
+
+	if (copy_from_user(&attrs, argp, sizeof(attrs)))
+		return -EFAULT;
+
+	if (attrs.flags)
+		return -EINVAL;
+	for (i = 0; i < ARRAY_SIZE(attrs.reserved); i++) {
+		if (attrs.reserved[i])
+			return -EINVAL;
+	}
+	if (attrs.attributes & ~kvm_supported_mem_attributes(f->kvm))
+		return -EINVAL;
+	if (attrs.size == 0 || attrs.offset + attrs.size < attrs.offset)
+		return -EINVAL;
+	if (!PAGE_ALIGNED(attrs.offset) || !PAGE_ALIGNED(attrs.size))
+		return -EINVAL;
+
+	if (attrs.offset >= i_size_read(inode) ||
+	    attrs.offset + attrs.size > i_size_read(inode))
+		return -EINVAL;
+
+	nr_pages = attrs.size >> PAGE_SHIFT;
+	index = attrs.offset >> PAGE_SHIFT;
+	return __kvm_gmem_set_attributes(inode, index, nr_pages,
+					 attrs.attributes);
+}
+
+static long kvm_gmem_ioctl(struct file *file, unsigned int ioctl,
+			   unsigned long arg)
+{
+	switch (ioctl) {
+	case KVM_SET_MEMORY_ATTRIBUTES2:
+		if (vm_memory_attributes)
+			return -ENOTTY;
+
+		return kvm_gmem_set_attributes(file, (void __user *)arg);
+	default:
+		return -ENOTTY;
+	}
+}
+
 static struct file_operations kvm_gmem_fops = {
 	.mmap		= kvm_gmem_mmap,
 	.open		= generic_file_open,
 	.release	= kvm_gmem_release,
 	.fallocate	= kvm_gmem_fallocate,
+	.unlocked_ioctl	= kvm_gmem_ioctl,
 };
 
 static int kvm_gmem_migrate_folio(struct address_space *mapping,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ff20e63143642..4d7bf52b7b717 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -110,6 +110,18 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_KEY(__kvm_get_memory_attributes));
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_TRAMP(__kvm_get_memory_attributes));
 #endif
 
+#define MEMORY_ATTRIBUTES_MATCH(one, two)				\
+	static_assert(offsetof(struct kvm_memory_attributes, one) ==	\
+		      offsetof(struct kvm_memory_attributes2, two));	\
+	static_assert(sizeof_field(struct kvm_memory_attributes, one) ==\
+		      sizeof_field(struct kvm_memory_attributes2, two))
+
+/* Ensure the common parts of the two structs are identical. */
+MEMORY_ATTRIBUTES_MATCH(address, address);
+MEMORY_ATTRIBUTES_MATCH(size, size);
+MEMORY_ATTRIBUTES_MATCH(attributes, attributes);
+MEMORY_ATTRIBUTES_MATCH(flags, flags);
+
 /*
  * Ordering of locks:
  *

-- 
2.54.0.545.g6539524ca2-goog



