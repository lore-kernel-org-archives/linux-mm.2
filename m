Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B335EC98332
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 00:51:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A189D6B0095; Fri, 25 Sep 2026 20:50:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C9756B0099; Fri, 25 Sep 2026 20:50:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D1096B0095; Fri, 25 Sep 2026 20:50:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B14C6B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:50:55 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C1CC340772
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:54 +0000 (UTC)
X-FDA: 85254083628.01.B1F8710
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id C449140002
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JFzHIDak;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790383852;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tFWyPgsbM5Jlt/M71cG+OYm7THQkepq3yQlwfZ1D+ag=;
	b=SwVu85MJ8ppeG/oOlD5G0hctjgwSkVUjlaf3Tj2cj/yY/L8FdBquB2l/fGsTjRjZ8ibbr0
	c76k6wwFZf0/JUUayOVKDD5/RTaj73qpAC3WxZdWIIiRKlb+UXU0ICnf3G2Tm3pxhHZ8cn
	xWL81xnbwTm/jMR4Nabs694iEa7lVCU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JFzHIDak;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790383852;
	b=JsszRV2GsJoP7Y+KzYB9YHrtq5+hp7Nl2eufRXz68xf6d+as07RzmIzqSLSa3/qJTtCR1O
	46OoO80IobvUX80bBXdtKHmmeoSpvTCq1yxSAsAxoT1WpgWQ5ma4EEXCJasRQn1CtrN5DY
	a3hPSJ8Rppj8pEiF8yLpSPJfjyePFqg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B351C447A6;
	Sat, 26 Sep 2026 00:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8BB57C2BD05;
	Sat, 26 Sep 2026 00:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790383851;
	bh=ZIJNey+uRMkgAwwA7lz6PgZb1mBalxrc/8gR2Ft+C2A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=JFzHIDak6LTzyQ+k8fqDAYG4+3ufuk94anAmTjiWy1AFoirP1z6ewshxwUI5bOwVV
	 msu+dl4kRFNgHV1cpeZ0DuYkp5DPpH2TW2qQELQhOnyggkbckvXmdVttWw+ieFeCMA
	 ASXX5JSN7qNXKtq6O2YrAOf0SNYRYNx5XgOPoYwhrADKuXP9MeaixesqzCTfGn6Ywp
	 lvymsqrLRjWlOelY/6mViwmKf6RzzNNufXFYzAnHI6SIRkbMPnp9iikm6EUFbLwPiy
	 x5rXzB6WUaSHZPryTdNe9cN4oeRigxRd5MII1BHNZj4EHcTj3aKswAubqV9yKp/ARd
	 yQt3oPc1tYjlg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F40BC9832E;
	Sat, 26 Sep 2026 00:50:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 25 Sep 2026 17:50:51 -0700
Subject: [PATCH RFC 04/17] KVM: guest_memfd: Add helper to attach resource
 provider file
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-gmem-tmpfs-backend-v1-4-d36159822d18@google.com>
References: <20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com>
In-Reply-To: <20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com>
To: Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Sean Christopherson <seanjc@google.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand <david@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Shuah Khan <shuah@kernel.org>, 
 vannapurve@google.com, erdemaktas@google.com, jxgao@google.com, 
 rientjes@google.com, fvdl@google.com, jthoughton@google.com, 
 tarunsahu@google.com, pratyush@kernel.org, fuad.tabba@linux.dev, 
 Gregory Price <gourry@gourry.net>, David Woodhouse <dwmw2@infradead.org>, 
 yan.y.zhao@intel.com, michael.roth@amd.com, suzuki.poulose@arm.com, 
 Christian Brauner <brauner@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Nicolin Chen <nicolinc@nvidia.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
 aik@amd.com, aneesh.kumar@kernel.org, Vlastimil Babka <vbabka@kernel.org>
Cc: kernel-team@android.com, kernel-team@meta.com, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790383850; l=7514;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=HekctVykzW/gpcElf3QWD4CPl7j2R2CGexsk6/8EAL8=;
 b=C9QB3QMpSXA6hg+ZKaKQExz0FYV2YVYw+kZavkZZfoAqTXEXw8LWfOottPb0NZnGcGhxLA7JZ
 CdvdIeLlBa9CuQqBqL8lmFyHlmzj6awMwuwwbAwipKqC06ni6fq5uqG
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Queue-Id: C449140002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: zxumioaywkdpec57tnainzf91obitmme
X-HE-Tag: 1790383852-481769
X-HE-Meta: U2FsdGVkX18LpQCLq6p5UvDjrN3aCWh5ABOot8rdE31f6/FMrV+InYudYFnNp/EkmxJrIzUXxXWZdfFanD2YSc1FEk5GnEmQxxTG49WeeXFOk6iqAlr2TfqZvI6Ejl8sehdYL3QUsUPT4x1WIXRh23Ie/1727Qpml6moA8ea83zeqjkesW8XzDAG427vzWNcT+asOWI/A2XObmav8bKWKDpZeraqrjpUYcmtaARXT9bZmjYsWwzXSrhYeCbwI3Z69p7QnC4s6FTlE9qKcP0X9BgonLVzTq4yuCSWXyC9HpsbJ38p9EuR5FuSO3OLDgBfdnJcNHXFjWY5LtTmJdWUe0MPJV2mgk45HBG2twSm3+OyHoqpKC4/oDTfrVwvUhducGxdrMuMZ0oMxnRhlcM8NFnQtZTfIPrifAwfHjW0ZwqrLjV2HNeiTaOEPmdVgdeQ4RxuAcspEf1BuWuUxhSgJW4aD65nde0s4x5YwHsXhQ189huF6cRBNR6qE5wKaWqBZhMlsxDyIWBdfCnb1o7yp0U+wTAS7/RHQcvfaRwELrmAcoRPITOM/E/I7MAQxR3jrSdYX6LWRwi5o8vvaNeK91H90t1eakT/kDHN4KbM71rxuZZSb86dq3NNOqxJ7gAIdlF5SjublyAs4G5/M80VPUYznwi1X9Ezbh3ZE3fvaXl72tHc7S0Mv/w30nEweKEBvFGNgkWozd7JIBmMnctwYZ+8+Z0Mm4Ov1uTMtRF1Bz5Cd9zhlFvjVbt5GN9oJMLfI1sm5NzInu5516RGtYj5CANnJobwkrw+sJKfYxGy/yT3eP2C6Lb2ZDE+84q4ISjTxE4uRkyFaHQbVnOiGI5uxBwGe1eos1hEXq1LdybDxkcXr+JiFn8+RQa+izMLxM3WbP9fn6dehW1gplIFQiuKv3l0pSfyOjNTjz861ImNixfxvssO7pEspHBk58C3L8RkgpE2aIlncASN0B6uyum
 QQcd697X
 SfrlYYihnXJ7cy+o045Ol3sLHbnEEpFSPbCRSqaRMEZNW8XS+16MK+Wnu8vusCrdKbgEgplbfxSgj/gKp7hAkPOeU0jlRY6S3g4n+3MTtxJ7dlHjSBhcBnHbdUOh7KNKxLp+BdCxKGb30KacCfyriTHwgX9NV1fDsXv/sxsw7+0ksn0gQ91hzBSqr9elH61MRZjQIDlPQxHi7fhlhjxwOLt402I/zaqDbFMiySb5GTTJ1LSdiPf8WjwbpMkBwVdsrzZeOBhZ7qjgVFXbG+C90gTBX70hUyimkVxqTNoYvDRUfUNl36efjICRDTHjCZdvt1EDRH0y8MhSVxVajAdDEyc/k+DzP7PcLV7cuhY+Mp+0X1vVPbNDZnRsa5kGxMz6sk2vbXQDVOihQkCCt3AsWoBtbGqHT8w5Qn9YXUy5Jt/JkvrsW7oWl3C/M23LJcrRpdh88INKcgbaEbQsQGRWx8+V0lJqvFpzmxV603jh3CwEJBC8Fz+pSMy2VXhWKIs30I/53PLdf8eBNMWVStFVjRlyaY9EheSCP83dd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

A refcount on the resource_fd is taken only to keep the reference stable
for guest_memfd to figure out the existence of a provider. The provider is
responsible for pinning anything required to keep the provider's ops and
the actual provided resource alive.

.release() is called when this guest_memfd inode is destroyed to allow the
provider to clean up.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 Documentation/virt/kvm/api.rst | 28 ++++++++++++++---------
 include/linux/kvm_host.h       |  2 +-
 include/uapi/linux/kvm.h       |  5 ++++-
 virt/kvm/guest_memfd.c         | 51 ++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 72 insertions(+), 14 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 67f0f290797ab..b48df2827a2c3 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6470,7 +6470,9 @@ and cannot be resized  (guest_memfd files do however support PUNCH_HOLE).
   struct kvm_create_guest_memfd {
 	__u64 size;
 	__u64 flags;
-	__u64 reserved[6];
+	__s32 resource_fd;
+	__u32 pad;
+	__u64 reserved[5];
   };
 
 Conceptually, the inode backing a guest_memfd file represents physical memory,
@@ -6492,15 +6494,21 @@ a single guest_memfd file, but the bound ranges must not overlap).
 The capability KVM_CAP_GUEST_MEMFD_FLAGS enumerates the `flags` that can be
 specified via KVM_CREATE_GUEST_MEMFD.  Currently defined flags:
 
-  ============================ ================================================
-  GUEST_MEMFD_FLAG_MMAP        Enable using mmap() on the guest_memfd file
-                               descriptor.
-  GUEST_MEMFD_FLAG_INIT_SHARED Make all memory in the file shared during
-                               KVM_CREATE_GUEST_MEMFD (memory files created
-                               without INIT_SHARED will be marked private).
-                               Shared memory can be faulted into host userspace
-                               page tables. Private memory cannot.
-  ============================ ================================================
+  ============================= ================================================
+  GUEST_MEMFD_FLAG_MMAP         Enable using mmap() on the guest_memfd file
+                                descriptor.
+  GUEST_MEMFD_FLAG_INIT_SHARED  Make all memory in the file shared during
+                                KVM_CREATE_GUEST_MEMFD (memory files created
+                                without INIT_SHARED will be marked private).
+                                Shared memory can be faulted into host userspace
+                                page tables. Private memory cannot.
+  GUEST_MEMFD_FLAG_USE_RESOURCE Consume resource_fd as an external memory
+                                provider or resource pool. When not set,
+                                resource_fd must be '0'. When set, the provider
+                                must be a supported resource (e.g. tmpfs mount
+                                root directory). Currently, tmpfs resource pools
+                                require noswap and huge=never mount options.
+  ============================= ================================================
 
 When the KVM MMU performs a PFN lookup to service a guest fault, the fault will
 always be consumed from guest_memfd, regardless of whether it is a shared or a
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 485f18454eb45..f4241c05650e9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2588,7 +2588,7 @@ bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm);
 
 static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
 {
-	u64 flags = GUEST_MEMFD_FLAG_MMAP;
+	u64 flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_USE_RESOURCE;
 
 	if (!kvm || kvm_arch_supports_gmem_init_shared(kvm))
 		flags |= GUEST_MEMFD_FLAG_INIT_SHARED;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 8dff2fc1972e9..f4108bf7e3192 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1674,11 +1674,14 @@ struct kvm_memory_attributes2 {
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
 #define GUEST_MEMFD_FLAG_MMAP		(1ULL << 0)
 #define GUEST_MEMFD_FLAG_INIT_SHARED	(1ULL << 1)
+#define GUEST_MEMFD_FLAG_USE_RESOURCE	(1ULL << 2)
 
 struct kvm_create_guest_memfd {
 	__u64 size;
 	__u64 flags;
-	__u64 reserved[6];
+	__s32 resource_fd;
+	__u32 pad;
+	__u64 reserved[5];
 };
 
 #define KVM_PRE_FAULT_MEMORY	_IOWR(KVMIO, 0xd5, struct kvm_pre_fault_memory)
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 00f3bd0cf21e6..0e0d7e93f4148 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -71,6 +71,12 @@ static inline void gmem_provider_invalidate_folio(struct gmem_inode *gi,
 		gi->provider_ops->invalidate_folio(gi->provider, folio);
 }
 
+static inline void gmem_provider_release(struct gmem_inode *gi)
+{
+	if (gi->provider_ops && gi->provider_ops->release)
+		gi->provider_ops->release(gi->provider);
+}
+
 #define kvm_gmem_for_each_file(f, inode) \
 	list_for_each_entry(f, &GMEM_I(inode)->gmem_file_list, entry)
 
@@ -984,7 +990,37 @@ static int kvm_gmem_init_inode(struct inode *inode, loff_t size, u64 flags)
 	return r;
 }
 
-static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
+static int kvm_gmem_attach_resource(struct inode *inode, int resource_fd)
+{
+	struct file *resource_file;
+	struct inode *res_inode;
+	const struct guest_memfd_provider_operations *ops = NULL;
+	void *provider;
+
+	resource_file = fget_raw(resource_fd);
+	if (!resource_file)
+		return -EBADF;
+
+	res_inode = file_inode(resource_file);
+	ops = res_inode->i_sb->s_op->gmem_provider_ops;
+
+	if (!ops || !ops->attach || !ops->alloc_folio) {
+		fput(resource_file);
+		return -EOPNOTSUPP;
+	}
+
+	provider = ops->attach(resource_file);
+	fput(resource_file);
+	if (IS_ERR(provider))
+		return PTR_ERR(provider);
+
+	GMEM_I(inode)->provider = provider;
+	GMEM_I(inode)->provider_ops = ops;
+
+	return 0;
+}
+
+static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags, int resource_fd)
 {
 	static const char *name = "[kvm-gmem]";
 	struct gmem_file *f;
@@ -1018,6 +1054,12 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	if (err)
 		goto err_inode;
 
+	if (flags & GUEST_MEMFD_FLAG_USE_RESOURCE) {
+		err = kvm_gmem_attach_resource(inode, resource_fd);
+		if (err)
+			goto err_inode;
+	}
+
 	file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR, &kvm_gmem_fops);
 	if (IS_ERR(file)) {
 		err = PTR_ERR(file);
@@ -1057,7 +1099,10 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 	if (size <= 0 || !PAGE_ALIGNED(size))
 		return -EINVAL;
 
-	return __kvm_gmem_create(kvm, size, flags);
+	if (!(flags & GUEST_MEMFD_FLAG_USE_RESOURCE) && args->resource_fd)
+		return -EINVAL;
+
+	return __kvm_gmem_create(kvm, size, flags, args->resource_fd);
 }
 
 int kvm_gmem_prepare_memory_region(struct kvm *kvm, struct kvm_memory_slot *slot,
@@ -1401,6 +1446,8 @@ static void kvm_gmem_destroy_inode(struct inode *inode)
 {
 	struct gmem_inode *gi = GMEM_I(inode);
 
+	gmem_provider_release(gi);
+
 	mpol_free_shared_policy(&gi->policy);
 
 	/*

-- 
2.56.0.rc1.315.gc6ed9934b7-goog



