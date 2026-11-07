Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1D28606CF73
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fTyZITIi
Received: by kanga.kvack.org (Postfix)
	id 7F68E6B05B5; Fri,  6 Nov 2026 19:37:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73DE76B05B8; Fri,  6 Nov 2026 19:37:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58EB86B05B6; Fri,  6 Nov 2026 19:37:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 24D106B05B5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:00 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C2261C0128
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:36:58 +0000 (UTC)
X-FDA: 85406458116.11.C546D32
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id A3C67140005
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:36:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fTyZITIi;
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011816;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sZigoAtGPKMx/RkfBXvtfCDz/QOnmzXhx35nSq/IIrg=;
	b=M6itFEDhuNmBfnas52Kd2zhpJKBBL4ZtwhUQjzSH24oqSaveAjwGa2MxlQE4rjyE5Jjer2
	7KELv+2rXxvxUEF7cyplup8RlV43Sb5I1h4EceJ5T/dRnR6OsvGfjwdJOOVrsH5flrkzzA
	9Fj5AIKFBL2Z7GKyWE7qmNGoPN2YKfo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011816;
	b=mVG9TCVdZezrTQvfGmsjQ4yo9rUi8gSPb6XXMptQ5sc8S9pG7HLVAYHj+SgH7GDtC19u3a
	G/6FuGYbKshvLG1IsjN/kTBAWd5M59B8772/MglMLmu20PoOsijxLsm9vSqlbYLGC2/wyt
	WDYcmX09Y3n4jkBNd/v2INU95OX6kD8=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fTyZITIi;
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E7D4743E8F;
	Sat,  7 Nov 2026 00:36:55 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011815;
	b=0a7pa5F7AdDjaW03s4rjzkx8X3Q5iH5r3ACv9GTK14kvRHu+SjFFF0/QW+nmm3X5C0Iz
	 839mkTu0g8hympIRh/xxn/9PCZD78UjOzHSz1Nxpw+3bcCGF3OpPFZugadiGnGGH6MwRh
	 3hkZbuiKvfko+8lDYpJqeyqWyLxUA4xPsyWtMg2Kuf6kSNiqpR6n/WvF5dYJZ48S7ctjn
	 jLSrX0hE1wGNlLndpTSxUao77eQYTdUknbZ1te4fCkDe9ph217AH2WKa35KEuqhh1VEx+
	 V6mmJ/iFZsiXu82EUQQvwrZ0Z7pYHO+h4OeLAqAo2Fr3Xdx/RoXT5zuzEakaFjltNxA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011815;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=sZigoAtGPKMx/RkfBXvtfCDz/QOnmzXhx35nSq/IIrg=;
	b=pZLfw8U8gpAbUCXNmtNH8jWckY5XBdfC0YwSbbAA1T2JNqRuXfxmJhjk/6PcpLfAq/Gd
	 fjCCSpo13AQTGiaeGa3d9ykr9yV2ytUkZM8ygfd4eIHEuzzFFr9gxwJVOTAuHrgSK3aYK
	 DtH8+MzJZI3w4PPV9V95etVkkqlkGXrcYet/gGV43vCalw0UV7DZSW8tt3z1xjQksF/sh
	 md4G2LtIiWxqEPQJG/I9TJiIIUR9ccVkg/2Q/RAz+a0OLgq2JVAN9B69VNUnIQHClKBLl
	 sTvzzKwcrMTLsCLosiok95ZUTiUakkQ4OJLLt/u3RC/YbGJXaOlyBqSJppXlXP3fbBw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 90BD31F008A5;
	Sat,  7 Nov 2026 00:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011815;
	bh=sZigoAtGPKMx/RkfBXvtfCDz/QOnmzXhx35nSq/IIrg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=fTyZITIiVQp1gAnCw3luoDDhDLZoOQiv14d46ouqqSKNO44WP4ngPiDGLdFQ6m2hb
	 fwQz7jexbHbs21fsdAsWTCCxLN5AVS2BintcdgrEnE+mUtSG60S4CdXzgfjMPyFTzH
	 6D0zj7ygIYSoWmDRSzpIEX+41BkIW07Il9NGj5xPQ1SryD0zmihyyyFNIbTZgdF5ki
	 kVMpxT42IOTSEXqhK+SXT0n7fg4eVNGhhEE9BHveDmaDy2wy5waChNIdRwkkz/iD6n
	 S3kDGxZVQgUoPJdkprY2ztNXAQfAlT4fIb04ZmT1UIgFw5tf6EOj1tVtyN3190hg9c
	 ofmEoONgpI5NA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 260BE47929;
	Sat,  7 Nov 2026 00:36:53 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:36:39 -0800
Subject: [PATCH RFC v3 05/88] KVM: guest_memfd: Support using resource
 provider
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-5-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
In-Reply-To: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
To: Alexey Kardashevskiy <aik@amd.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Christian Brauner <brauner@kernel.org>, 
 David Hildenbrand <david@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jianxiong Gao <jxgao@google.com>, 
 John Starks <John.Starks@microsoft.com>, 
 Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Vishal Annapurve <vannapurve@google.com>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=7993;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=+trcMG1AkUVLV5DTgtPr8oTB3iyi5IEbhg5RcJXjFzo=;
 b=CjjglONW/K86yi9bpPILRg7xwdCCcNCuzvlDIXTENgJflyOKaSJ7CATnoA9BUXoQbKXlTMhrd
 jTV8aEEZYpACo2HVgiFWfXPxelh0W8DZFIOJIuXxpl7Lk9zXDVst8cA
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 86gtchgzbnz5tyeahcgczt4n6a491ewx
X-Rspamd-Queue-Id: A3C67140005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794011816-301833
X-HE-Meta: U2FsdGVkX19G9mB4NffB15qDg1IcG8yqd0fU6jySbuq28DNi/YAN0nM/3kpG8KbjsjBb3mBemUbRTFxXIw4IOubYKQl/t7hXKn0G7ccy/ONGJY+MHFaM/KZ0O2yKfasg4ef16e6phOCYBJcjuMhPCuD3ozZsNLUlk4L7EjZ0yozpQpptYLQnRzCOY9DYSUuhau32rdeLaQI0ekfwWrXALmS/FVSfeeIWomCBeljcyiz5xNqZy2Fr4pfUmfx3k5NtM3SpYGa6GW80r708+1gG7khGcZ0qR+fjcKGd+SDjOnFvVp9itkihtbDJeKRGsHxiVsHrMds7m4HOFWMmzLYZ1hVAFdBQ9uhmOjSknk3GWTm8ZwZSjmKAOc4etbzHee1gkLZCDGKDQIokmlG5+GbfF7GzYLrPdHfHM1JecGh9HJE6muf1YsTVa5WaH6UlMOUqv6PYqKbvGe0m+RaTG+1W+J4M/R2K0SfzIGe1nlxeQcZKTWVE3zjSe5Fx5KVwJTpz+O8thWHN/VP4m8JFuSedDzRapxZGAwB4vrnBUKk1W4mXn8U41K81I5MPnFxQ8Op0Y8u045iB3eUr2lFISuswnJ6edShzOzi5y4ZDSbFUA155S00u0l/PiMRNp8PuDJA59zsuLmkHDJE9Q6qBlMM9j6320vyG1HVWLUckOdR1SSOOzw+KOmz45fe4xSnlvWJb3kxEUp3o+sPzmwirLEOMftZ8zyyQFWqE1YyfbHkxsjxEASyGQslDKIu1azkfKAAuJBtwKnKraPOnsgCrQdYJIs3kYidYYbJP2pTVCfPH/kcRVD5NsG3hfJ2ZVLJOkb60b7gKVDRnfp7Iu3DqZMs6rE+NkNMZk+kjz+R4yKAOsRuJHMyBrmgSK6pYy5xEt9MqrwA54gNgCWmlqi9j7nK/T2K6gK0joS0A7exRwePImtXpeILn1mAqBwYkis8hIJlqs/MRqLvur5GFfP/ZBFu
 v5V0G07L
 TpAS6k8X/+2BSu+SCmVI/EvOXY03zjwoN6DTg/Htd6wKqZ8Zwubbhm0XTil8euy8rxOdM3V0XiLjN2Br1Ng/0RwQCas6PyeHzE5/yvhpmUuIWqlq4JJipMvY4208vmaiDz4k4vXEx11iUI8m2/ukp6glfoR5jzDQTyVVH+thg1Crnc2Pb4t2cog81EPFkDb49le3jiNr1xVZfzA91EnWVANLKqWWGRPVas1aan03gv49PxMDJzcgSC8P4vFY2KDdqWz2SKJOZ2e4smUl3tz3eZibc+SmqjnSZDj2o6zi5ZYo2S/y37VynJ+QoH6844bn3w9oW23+yGkA4TDgQBlOf0b62ajQgfjHLt+pwE7tgJ3pa81GavejKGqLa4N8Jb4tdxHOWxSt1GhmxbWpRuhUT1X1JT89c0B0G/XB3OKhviiOSf0oNzdZiW10zJcejd0ZC9XhAzsQwTM90lEAmsPuoegqAls/YTxpDqHbK6rPeoX5IWML3bwSZOJk9Me77KGXO6sDmWD9BIID429lc8GIKbItLVZwIZiYEVkby8MPematNjYJlOh6uZ4sXdLi2PR7juIm3wPXQytwg2otITozPVlFfXSnFHJO1prolWPTZcPTEIL0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

A refcount on the resource_fd is taken only to keep the reference stable
for guest_memfd to figure out the existence of a provider. The provider is
responsible for pinning anything required to keep the provider's ops and
the actual provided resource alive.

.release() is called when this guest_memfd inode is destroyed to allow the
provider to clean up.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 Documentation/virt/kvm/api.rst | 28 +++++++++++++++++----------
 include/linux/kvm_host.h       |  2 +-
 include/uapi/linux/kvm.h       |  5 ++++-
 virt/kvm/guest_memfd.c         | 44 ++++++++++++++++++++++++++++++++++--------
 4 files changed, 59 insertions(+), 20 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e95c9cda085d9..9f5313d405d9c 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6486,7 +6486,9 @@ and cannot be resized  (guest_memfd files do however support PUNCH_HOLE).
   struct kvm_create_guest_memfd {
 	__u64 size;
 	__u64 flags;
-	__u64 reserved[6];
+	__s32 resource_fd;
+	__u32 pad;
+	__u64 reserved[5];
   };
 
 Conceptually, the inode backing a guest_memfd file represents physical memory,
@@ -6508,15 +6510,21 @@ a single guest_memfd file, but the bound ranges must not overlap).
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
index e7fc94e2910a8..d820afac49252 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2618,7 +2618,7 @@ bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm);
 
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
index ee823f2ef0368..84877beed6701 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -85,15 +85,26 @@ static const struct guest_memfd_provider_operations gmem_native_provider_ops = {
 static int kvm_gmem_attach_resource(struct inode *inode, int resource_fd)
 {
 	const struct guest_memfd_provider_operations *ops = NULL;
+	void *provider = ERR_PTR(-EOPNOTSUPP);
 	struct file *resource_file = NULL;
-	void *provider;
 
-	if (resource_fd == GMEM_RESOURCE_FD_NATIVE)
+	if (resource_fd == GMEM_RESOURCE_FD_NATIVE) {
 		ops = &gmem_native_provider_ops;
-	else
-		return -EOPNOTSUPP;
+	} else {
+		resource_file = fget_raw(resource_fd);
+		if (!resource_file)
+			return -EBADF;
+
+		if (resource_file->f_op)
+			ops = resource_file->f_op->gmem_provider_ops;
+	}
+
+	if (ops && ops->attach && ops->alloc_folio)
+		provider = ops->attach(inode, resource_file);
+
+	if (resource_file)
+		fput(resource_file);
 
-	provider = ops->attach(inode, resource_file);
 	if (IS_ERR(provider))
 		return PTR_ERR(provider);
 
@@ -120,6 +131,12 @@ static void gmem_provider_invalidate_folio(struct gmem_inode *gi,
 		gi->provider_ops->invalidate_folio(gi->provider, folio);
 }
 
+static void gmem_provider_release(struct gmem_inode *gi)
+{
+	if (gi->provider_ops && gi->provider_ops->release)
+		gi->provider_ops->release(gi->provider);
+}
+
 #define kvm_gmem_for_each_file(f, inode) \
 	list_for_each_entry(f, &GMEM_I(inode)->gmem_file_list, entry)
 
@@ -1033,7 +1050,7 @@ static int kvm_gmem_init_inode(struct inode *inode, loff_t size, u64 flags)
 	return r;
 }
 
-static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
+static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags, int resource_fd)
 {
 	static const char *name = "[kvm-gmem]";
 	struct gmem_file *f;
@@ -1088,7 +1105,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	 */
 	smp_wmb();
 
-	err = kvm_gmem_attach_resource(inode, GMEM_RESOURCE_FD_NATIVE);
+	err = kvm_gmem_attach_resource(inode, resource_fd);
 	if (err) {
 		fput(file);
 		put_unused_fd(fd);
@@ -1111,6 +1128,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 
 int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 {
+	int resource_fd = GMEM_RESOURCE_FD_NATIVE;
 	loff_t size = args->size;
 	u64 flags = args->flags;
 
@@ -1120,7 +1138,15 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 	if (size <= 0 || !PAGE_ALIGNED(size))
 		return -EINVAL;
 
-	return __kvm_gmem_create(kvm, size, flags);
+	if (flags & GUEST_MEMFD_FLAG_USE_RESOURCE) {
+		if (args->resource_fd < 0)
+			return -EBADF;
+		resource_fd = args->resource_fd;
+	} else if (args->resource_fd) {
+		return -EINVAL;
+	}
+
+	return __kvm_gmem_create(kvm, size, flags, resource_fd);
 }
 
 int kvm_gmem_prepare_memory_region(struct kvm *kvm, struct kvm_memory_slot *slot,
@@ -1464,6 +1490,8 @@ static void kvm_gmem_destroy_inode(struct inode *inode)
 {
 	struct gmem_inode *gi = GMEM_I(inode);
 
+	gmem_provider_release(gi);
+
 	mpol_free_shared_policy(&gi->policy);
 
 	/*

-- 
2.56.0.455.g6c5a503b38-goog



