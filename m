Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41C65C5AD2B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:54:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB0046B00BC; Fri,  7 Aug 2026 17:52:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C88C26B00C0; Fri,  7 Aug 2026 17:52:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B00526B00C3; Fri,  7 Aug 2026 17:52:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 70F2A6B00BC
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:52:56 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 03132A013B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:55 +0000 (UTC)
X-FDA: 85075823952.04.F3BB189
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 049C140005
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DEhB1hHQ;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139574;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hnzrvijJy9ttkDWyjcX+MnkzR6JjJ1aAe5BbyQsdVQw=;
	b=aTDjCwqKff5WZPImUcugDTE17IEFmEQPl9QEp+BweSvCCLkhNt0xnDn/hvtp5YR8Iv8u0v
	ythYcSUWaIxL6VOeUOby71ELRyFLOg88vqjitaZdRZglP3LgVyECKJMU6ed6NB8sJuwyvV
	y6HjHgruMFngxbMRSxBpXzSJ8kDdiWk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139574;
	b=5p6IYZtH3IIizeXqE9ybeMmYNsg/9v397E904Q16+1P3AOfsQl8LQVQQln5CdJ82BCHPeJ
	XYmrJ3fa9fAmDHMOxlvXWaKoa7x1r865JV6XB6jmW5u2S7E+vqqdO9H06hUg1PkrQ7boLk
	uUaLQ2GKiMUwu3IUOXrfj9qgBCan/Kc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DEhB1hHQ;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 38E674510E;
	Fri,  7 Aug 2026 21:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A7B94C4AF12;
	Fri,  7 Aug 2026 21:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139568;
	bh=jzGs6Dre0kjE1/gGJb1Q4TCVGuOJVo75IUH/LEp7RY8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=DEhB1hHQgGgXMJBbJaj+EKP5Lc91x+1ViYSfzhYZvIH58KwR6IoPBqbZxEQcoXxIs
	 btmLDuz7Og+DPlJP4Kqv6eS+RDteu7C/g9DaH9S4MNbtmpwnpwccwCUZuvg8MIRFLd
	 CgomlhbjwGa7pNeuGnOQhNHkQekQXmiqmGBEwbTcZBIW9s1Pss4B4/oH2IYo2dNFfO
	 w2Yv09jUafSZRko0OvxR5gkp/ipG34O86uqS9/qf30wg88lY2RiPPzqYg4XZtVVfio
	 i0g8qNvfSp3yFm/EsC/xvuk+FwSUDSPbn+i9g5vOkmKdfI1Hd8nb0x7KiGQ7QsAamw
	 rHt/nJ7lnLv8A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88F9EC5ACD7;
	Fri,  7 Aug 2026 21:52:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:52:49 -0700
Subject: [PATCH v10 10/41] KVM: guest_memfd: Add base support for
 KVM_SET_MEMORY_ATTRIBUTES2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-10-2fc18ee6d3ba@google.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, tabba@google.com, willy@infradead.org, 
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=12652;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Q0yQ+Ord5cK/y9TgTQWUapDCQ6db4odwiyYjviFgtpc=;
 b=VF33lw8ZJsgtzeNB2vq52/94+TbzhHJZAkZNRBSV/+seKIfCMJnAZu5GANgWzmGfQKCJv6Emq
 6rsddCiLpcvCaVn6ULNx4pOdcyjb+Fx5QaIe1JSMsNjCGQgQKNSykJ6
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 049C140005
X-Rspam-User: 
X-Stat-Signature: t6gu7dzgt8ziyhba4yjxqzcu68zgcwnw
X-HE-Tag: 1786139573-564381
X-HE-Meta: U2FsdGVkX19upamg8AnePP5frXDk3y4RWuJokXbIGLmbDHSQBF2WRgAnaCDv/Gbx/BnBvEr7NQk8EOR3tHI+5li7nFtHea9t3F0VwcvXn0pge/WFvpwUeaD4KJlw1Th3TmDuvjzkVtdXSd5vyocqCXxaGEPTmoyEBTsPFBY6XtnzoqwVH6Ur7oX9iJxHrL890JiBDWNoegjsyusTGCI+UhIxkR3mA5ATbkkXs8RqhL86lt6mTqACSeog3dYpAsVUx1Nay2K9pRiir3ZBJxBu1Lf2CrmB6V1Cjo6Vzp4oXHIeUtKyRjGA2v52/GQA7mWbOiKbF0JniCS4YFkrx3ICe4f59STaJF8C3jwasjTX+3hQyxmBbRuxg41MMab6fXmWi24jAyVdBEE9Zb47ywOAXhCQfLSh+IadFuYcl4MPCAzPaYZe4YhQ7XTgIRuJjlwbu15nwgF5DCYLDCAtndj2jUzSTpXE/hZX/ArdlEZJkRPzIrY1XQXAmGVy1zaJVMIC1Rh0cssmSpCn0KRGRSVJWwb3BhA5EbYT9/ztl8ltlPXU8NXbiqR/ZIX42i+TEHafks7HXdU5H+68Ggd3+8UaWmKztgjKf7Apt4aYAb29+O8QvSqWlMMEM1YHcvZM1Ia+NG59hjvg/hxA4U5yXw7nnTrl416lGr0cBM4Wjc9YuSRAp1Df5q5q6WphM2W6tgipKOxiYAbP3SMgX9EYvsjDNxPGDqnYRx63FxUm8jmfE5BPehV4XwOAEkiPwc02z645ct6qV53rEhhfO6lEiqQHZm9J+haniCJr87iW+1qFR/kBEPWr97k7LPNVO66L6bYMre7p3/Gp1unZVRk6Ql9go4KqJT2dn/MickE51CYQfhTlnse+wCz0HlR1DX3NSr8uK9LMIJ12gXjz9ewCCBtjSGkokjGSOmGeJO5+7m12nWi86WEDMoKK0Xjo0aDcw5nbd5HlYVOfwGdPc34TosY
 ovaF0XM2
 qm7Qa7SAwJjPHFHSmaqAcRH9sKQFJj9FRh2uH+w4kZAU0ZjsXI3SDeI3PVjO0C7QsO7jD/fSZ0lwIvCC/tPGx3rOtJObzSlwHNLHs1ZAhHy2meXkBBD29gCnmS15waz2714asjJcVIdEgf5x0T89N0foZ2KZSx+axKUIrxvsY7aNqHrjBeYSM13uft9ip0vUYDFgeJdv5+l8sSRB1L5psyDMSmSPbUJQr+kgihS14b7nbblgnV2H4FVfs2PQfaawfoPibP7DtfcXEpvFmxk4BCCYgGmldKnT6+f7tDXMhMep8WPhHs0CkyV3luAtqscz8ESiRYENQdyYP00dXYfq/5irIm8y+Xbmo1wbMmn9etbb9laYzk1GpxYvNCSlBGX0W8pk+eEv6Mc3O5nyYdcWfyy4CtPhK1TKbLUJsPM6nJ4OVeEggsPS6r+9+8+FavFUbV1ZRUNPxI/F0c3d1ZHppc3M7JDZL+781Oe9RVxuzrZhBF0QRd2olxCbIoBTI8w7MV7rgGNwlLn0ZiTqUk8yGHbPHIfO4suIe8qqxNzsI2uhf8edY7VO6ZAF6RSq6LM88k+ZxfO4oUV0030q4SqeH9uPVlfRzZyp76LUgZnRoMrirRpJFoVobuX+BJSGbPB3IhmHdUAObRZakYmQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Add a new ioctl (and matching struct), KVM_SET_MEMORY_ATTRIBUTES2, using
the same base ioctl number (0xd2), but with R/W semantics for the kernel
instead of just read semantics.  "Officially" documenting that KVM writes
to the payload will allow KVM to support partial/incremental conversions,
instead of all-or-nothing updates (which requires complex unwinding), by
recording the failing offset if an error occurs.

Opportunistically add a new struct as well, even though KVM could squeeze
the error offset into "struct kvm_memory_attributes", as there's no cost to
doing so in practice.  Pad the struct with a pile of extra space to try and
avoid ending up with "struct kvm_memory_attributes3" in the future.  Use
the same layout for the fields that common to version 1 of the struct,
e.g. to ease upgrading userspace, and to provide flexibility if KVM ever
adds support for KVM_SET_MEMORY_ATTRIBUTES2 at VM scope.

Introduce KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES to advertise the
availability of the KVM_SET_MEMORY_ATTRIBUTES2 ioctl.

Update the KVM API documentation to define the new ioctl and its behavior,
and add the necessary UAPI definitions and capability checks.

The process of setting memory attributes has a clear point of no return
because, for CoCo VMs, zapping stage 2 page tables is a destructive
operation. Unlike regular VMs, where re-faulting pages into the stage 2
page tables merely incurs a performance penalty, CoCo guests must
(re-):accept pages after every fault. To preserve CoCo security guarantees,
guests will not accept pages they did not explicitly request faults
for. Consequently, during memory conversions, any operation that could
cause the process to abort must be completed before the stage 2 page tables
are zapped.

Zap only the ranges that are not already in the requested state to avoid
inadvertently destroying (CoCo) data. ARM CCA guests will try to mark the
entire DRAM as private at boot. If there are no shared pages at all, the
to-private conversion can be skipped, but the existence of a single shared
page would require the conversion process to proceed, and if it proceeds,
zapping both shared and private pages would destroy data and break the
guest.

Co-developed-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Suggested-by: Michael Roth <michael.roth@amd.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Suggested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 Documentation/virt/kvm/api.rst |  63 +++++++++++++++++++++-
 include/uapi/linux/kvm.h       |  15 ++++++
 virt/kvm/guest_memfd.c         | 119 +++++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c            |  23 +++++---
 4 files changed, 212 insertions(+), 8 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 62afc031897ce..1a3f664dbb197 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -117,7 +117,7 @@ description:
       x86 includes both i386 and x86_64.
 
   Type:
-      system, vm, or vcpu.
+      system, vm, vcpu or guest_memfd.
 
   Parameters:
       what parameters are accepted by the ioctl.
@@ -6382,6 +6382,8 @@ S390:
 Returns -EINVAL if the VM has the KVM_VM_S390_UCONTROL flag set.
 Returns -EINVAL if called on a protected VM.
 
+.. _KVM_SET_MEMORY_ATTRIBUTES:
+
 4.141 KVM_SET_MEMORY_ATTRIBUTES
 -------------------------------
 
@@ -6575,6 +6577,65 @@ KVM_S390_KEYOP_SSKE
   Sets the storage key for the guest address ``guest_addr`` to the key
   specified in ``key``, returning the previous value in ``key``.
 
+4.145 KVM_SET_MEMORY_ATTRIBUTES2
+---------------------------------
+
+:Capability: KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES
+:Architectures: all
+:Type: guest_memfd ioctl
+:Parameters: struct kvm_memory_attributes2 (in)
+:Returns: 0 on success, <0 on error
+
+Errors:
+
+  ========== ===============================================================
+  EINVAL     The specified `offset` or `size` was invalid (e.g. not
+             page aligned, causes an overflow, or size is zero).
+  EFAULT     The parameter address was invalid.
+  ENOMEM     Ran out of memory trying to track private/shared state
+  ========== ===============================================================
+
+KVM_SET_MEMORY_ATTRIBUTES2 is an extension to
+KVM_SET_MEMORY_ATTRIBUTES that supports returning (writing) values to
+userspace.  The original (pre-extension) fields are shared with
+KVM_SET_MEMORY_ATTRIBUTES identically.
+
+Attribute values are shared with KVM_SET_MEMORY_ATTRIBUTES.
+
+::
+
+  struct kvm_memory_attributes2 {
+	union {
+		__u64 address;
+		__u64 offset;
+	};
+	__u64 size;
+	__u64 attributes;
+	__u64 flags;
+	__u64 reserved[12];
+  };
+
+  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
+
+Set attributes for a range of offsets within a guest_memfd to
+KVM_MEMORY_ATTRIBUTE_PRIVATE to limit the specified guest_memfd backed
+memory range for guest use. Even if KVM_CAP_GUEST_MEMFD_MMAP is
+supported, after a successful call to set
+KVM_MEMORY_ATTRIBUTE_PRIVATE, the requested range will not be mappable
+into host userspace and will only be mappable by the guest.
+
+To allow the range to be mappable into host userspace again, call
+KVM_SET_MEMORY_ATTRIBUTES2 on the guest_memfd again with
+KVM_MEMORY_ATTRIBUTE_PRIVATE unset.
+
+KVM does not directly manipulate the memory contents of pages during
+attribute updates. However, the process of setting these attributes,
+which includes operations such as unmapping pages from the host or
+stage-2 page tables, may result in side effects on memory contents
+that vary across different trusted firmware implementations.
+
+See also: :ref: `KVM_SET_MEMORY_ATTRIBUTES`.
+
 .. _kvm_run:
 
 5. The kvm_run structure
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 419011097fa8e..80985e28e3b21 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -997,6 +997,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_S390_KEYOP 247
 #define KVM_CAP_S390_VSIE_ESAMODE 248
 #define KVM_CAP_S390_HPAGE_2G 249
+#define KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES 250
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1649,6 +1650,20 @@ struct kvm_memory_attributes {
 	__u64 flags;
 };
 
+/* Available with KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES */
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
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index b1537226e5adf..3783e63476569 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -492,11 +492,130 @@ bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_is_private);
 
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
+	mas_set(mas, end);
+	entry = mas_find(mas, end);
+	if (entry && xa_to_value(entry) == attributes)
+		last = mas->last;
+
+	if (start > 0) {
+		mas_set(mas, start - 1);
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
+	bool to_private = attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE;
+	struct address_space *mapping = inode->i_mapping;
+	struct gmem_inode *gi = GMEM_I(inode);
+	enum kvm_gfn_range_filter filter;
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
+	filter = to_private ? KVM_FILTER_SHARED : KVM_FILTER_PRIVATE;
+	kvm_gmem_invalidate_start(inode, start, end, filter);
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
+	if (!kvm_arch_has_private_mem(f->kvm))
+		return -EINVAL;
+	if (attrs.attributes & ~KVM_MEMORY_ATTRIBUTE_PRIVATE)
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
+		if (!gmem_in_place_conversion)
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
index 0a5a1bee8de0f..c4c09593ef8b9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2423,18 +2423,22 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 }
 #endif /* CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
 
+#ifdef kvm_arch_has_private_mem
+static u64 kvm_supports_private_mem(struct kvm *kvm)
+{
+	return !kvm || kvm_arch_has_private_mem(kvm);
+}
+#else
+#define kvm_supports_private_mem(kvm) false
+#endif
+
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 static u64 kvm_supported_vm_mem_attributes(struct kvm *kvm)
 {
-#ifdef kvm_arch_has_private_mem
-	if (gmem_in_place_conversion)
+	if (gmem_in_place_conversion || !kvm_supports_private_mem(kvm))
 		return 0;
 
-	if (!kvm || kvm_arch_has_private_mem(kvm))
-		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
-#endif
-
-	return 0;
+	return KVM_MEMORY_ATTRIBUTE_PRIVATE;
 }
 
 /*
@@ -4976,6 +4980,11 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 		return 1;
 	case KVM_CAP_GUEST_MEMFD_FLAGS:
 		return kvm_gmem_get_supported_flags(kvm);
+	case KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES:
+		if (!gmem_in_place_conversion || !kvm_supports_private_mem(kvm))
+			return 0;
+
+		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
 #endif
 	default:
 		break;

-- 
2.55.0.654.g21b8a5bc05-goog



