Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCB83CD37AA
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:23:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C8206B00A1; Thu,  7 May 2026 16:22:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54F176B00A3; Thu,  7 May 2026 16:22:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 356AB6B00A5; Thu,  7 May 2026 16:22:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 156916B00A1
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:22:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D5EADC1FBC
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:57 +0000 (UTC)
X-FDA: 84741747594.17.AE6AD0D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id B2DE120009
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ncJtvi47;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185375;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ldzPqhGx9skLSn0H3NY51CmhzH8vNVZbiDRsZgRBbFs=;
	b=Ef9sbAFpP6+5Oy937JnSwBaW4sOa8bwsUgndWAqKZlT0jhubW0kD1TQxfZbGZ+ygPvmNHl
	PaaBn+6JtlaMwCpUTiazpjnywO2Ap2fdc5d7PG5xE0SP9HoaTB0U1zuXJ26EhCpEcFwDxh
	5ZFZh8GcUBir46u8y75kMcvB+1BIaCs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185375; a=rsa-sha256;
	cv=none;
	b=66oBUbDlYBOchgmLhnM2WTKiMeVi59k0Z2MweicRIHUgIenhmPF33+EcAZWtwBmetUGKQy
	0Rmbk2nmpZkP9qdDv3MzGx8izYgbdAKzmfGgsJI3RSDdje38CMnussMb62jif1Yli6uXL4
	uNv4zFZy8K5ZWERTH5LpsVZ60fCacPc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ncJtvi47;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7040944570;
	Thu,  7 May 2026 20:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4A68EC2BCC7;
	Thu,  7 May 2026 20:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185370;
	bh=WMAhS3wXkhHmkDiRnpU/vxMQPMaydHMNejcj2R+BXZs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ncJtvi47TYZZjgeCqgkV34nxKYM6NPFvaXsvqUf9FhZZxKc0NSMIin2TGB6rVCiAV
	 qWN9fc6/SztuOXbm2+slxAvjEQ1uaPGEb2rQ54qYIPm5wcBdTR55Nw631o9qeTtg7w
	 Krd7FDAy3Brea2lkThhS3X5Kt+3hG6PL8MbLdZW6BEJjJbrbSVXQsI/4lcPfU+GmC/
	 nVf3rjT90T5TWaKS9fxiLL4At4MPQQXC1uS2yR5lhKqkpG3pm/0hriKFtamBvHHurZ
	 /1nkuMoI/pCT24H/ifq4laH8a4N7p81O6gpty9ls2EAoGaNXfrzBMlV/CD4bBIG0Mo
	 FXJSDNXAPTptw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38023CD3447;
	Thu,  7 May 2026 20:22:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:33 -0700
Subject: [PATCH v6 14/43] KVM: guest_memfd: Advertise
 KVM_SET_MEMORY_ATTRIBUTES2 ioctl
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-14-91ab5a8b19a4@google.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, liam@infradead.org, 
 Paolo Bonzini <pbonzini@redhat.com>, 
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=6282;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=r0osqznWnANqSj6YHNaPT6Sp9fBpQoN+45Ykqukgtxs=;
 b=ebEz6PELAHbJ09w01mLxQgkD3H4OjHNlnnAq6kKZRiD0fzIBhTvixUxvlkDll0IN8DQ2bGbtR
 D8iPrKm4l5XAFyoUmWywjpzOOmrdtYTgcDZDiadUHGNo76MU41UOyl4
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B2DE120009
X-Stat-Signature: qbowwhf633agc9r8bgn1jktneq9as6cf
X-Rspam-User: 
X-HE-Tag: 1778185375-719745
X-HE-Meta: U2FsdGVkX1+RZpoHmUiP1chcohwhnlKcmXR9Pj1SqXczKsmXqw+Lr/7tf9ZSBfPITQo/UcLqDP1tqmZEXab2z2bJ3xDe8Liem6j50/VE5vFd7FiJGUUeC8BOYhU5o0fZZ3ZdSakONtqAwxlP7oiSFQPl8fPg5LjX2iK8S5K27uqR2LErZrmeAenzY5Qr2b3LWvYPor+DWeMSF+0tO+1WVs2KYdckn5OcA1PowkEyYQEzp4+kVZJ0PTwAfM/cVX8YPgB0RdVN0WePYdv2CLAeW/y8X/+vVM6ND5mL4aH625uej5mtrQ3E3hocpToIO03qtzsbCv1Y3q6Odrnz/nmdrZWMw0rmy8ZrtF5vGtNcz4eqYFw844OZCNIYlnEPpI2nSGbO/TCyv2VUd1NCh/qv5Sb9pVtp7ZlgowOdxHd6zvUmKUA/aBSl1koSfwKoiZF8aKGMv6dJf9GNLhh/LJFOymEbPs/RJK+rHQbfjgEbE+yHVkH7SbeYXGXjx+wpbELN8scoF8YBPKT9RYt3rm7z4tuxFo8xE5T4oc2W5uda4A/CNVW0tfLwn1oUlg0gNm0H1m5r+VVDSfi3dsTJST043mshTdBGXjTCHmXqKxekS6Q6tpX2+S4qyIDcAQASJHDzxuZ24xvUefNneO3Mn/fxOZ+V7Z4jG6Kkdec8bgdRxkt6r1m57cF+EVaGh59QItK8DHacwaIn5EIsEnNegEAZrr8bGNcbxk00lMKmt6gUdcJrmX3Um1dLJ+gGesxM+tlPygy/e6C1bpZ+01lWEI2g9CpNVMe3oCNBEIBMfKqJW9lnjupNpTNtLDF/WghZ62v9kf0GZOa0XtCpQLI7yM6ejiC9nnfMNcgWbN+4VQM+Ww3OZw+XR587LXJ/y9nFfpkyuwkFIBlR5o2ZHEhb9sxfrxdppMT+aRectt2SMCbk/qom6pKVUFD46iGGzAcG2CDK7g6pEv5wbjagyqtCoG9
 zg/Eg0Z8
 nHgkqYR52f3Q9uOSYnBtSifF4+ZD+nfLIFNOLpmfSdy4sLF+YipKQ9eEOcFvnczugIN/0Wcxs9CjoH7rk8NPDfFBYUpmu/bTGo3YCjkth2e8135JoCIHhaKGIpLZAzwsjDfsfs+w8+g69SyecWbTXiocpBpvdoegB+8fNCVW1CLE74hkdoQEfWSW3HNxGpEhmKkKT0n24wrkLKHM8jW+MmHOpJlUaHpORkbAR0Ugfc3o7DY5c93mP8tz1UXTtrwsk5dwaUJKc/O2TpiqnLGsWtFDbGd7+MdqEBm3vI55ieasRWUZrZVzpjKzTI8ZlP2mApV4A6vssmAAu22Gg0j4jP2g2UoeVvcs3tm4+OngGn7OVL2DM3+8ZaZt0RPlJhqQabqplrzgRa/t+gHAYbYEOTU7JRLnHQ/jkZAlJt/X92fxn72eJkwQJh3NzXFAmt5HkgOUBr4eQQ0Ab2HLs1QB2G0HB9/TDXP0TqpC0SIjGanbt3mU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Introduce KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES to advertise the
availability of the KVM_SET_MEMORY_ATTRIBUTES2 ioctl.

KVM_SET_MEMORY_ATTRIBUTES2 is a guest_memfd-scoped version of the existing
KVM_SET_MEMORY_ATTRIBUTES VM ioctl. It allows userspace to manage memory
attributes, such as KVM_MEMORY_ATTRIBUTE_PRIVATE, directly on a guest_memfd
file descriptor.

This new version uses struct kvm_memory_attributes2, which adds an
error_offset field to the output. This allows KVM to return the specific
offset that triggered an error, which is especially useful for handling
EAGAIN results caused by transient page reference counts during attribute
conversions.

Update the KVM API documentation to define the new ioctl and its behavior,
and add the necessary UAPI definitions and capability checks.

Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 Documentation/virt/kvm/api.rst | 78 +++++++++++++++++++++++++++++++++++++++++-
 include/uapi/linux/kvm.h       |  2 ++
 virt/kvm/kvm_main.c            |  5 +++
 3 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 52bbbb553ce10..55c2701d9ed49 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -117,7 +117,7 @@ description:
       x86 includes both i386 and x86_64.
 
   Type:
-      system, vm, or vcpu.
+      system, vm, vcpu or guest_memfd.
 
   Parameters:
       what parameters are accepted by the ioctl.
@@ -6361,6 +6361,8 @@ S390:
 Returns -EINVAL if the VM has the KVM_VM_S390_UCONTROL flag set.
 Returns -EINVAL if called on a protected VM.
 
+.. _KVM_SET_MEMORY_ATTRIBUTES:
+
 4.141 KVM_SET_MEMORY_ATTRIBUTES
 -------------------------------
 
@@ -6553,6 +6555,80 @@ KVM_S390_KEYOP_SSKE
   Sets the storage key for the guest address ``guest_addr`` to the key
   specified in ``key``, returning the previous value in ``key``.
 
+4.145 KVM_SET_MEMORY_ATTRIBUTES2
+---------------------------------
+
+:Capability: KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES
+:Architectures: all
+:Type: guest_memfd ioctl
+:Parameters: struct kvm_memory_attributes2 (in/out)
+:Returns: 0 on success, <0 on error
+
+Errors:
+
+  ========== ===============================================================
+  EINVAL     The specified `offset` or `size` were invalid (e.g. not
+             page aligned, causes an overflow, or size is zero).
+  EFAULT     The parameter address was invalid.
+  EAGAIN     Some page within requested range had unexpected refcounts. The
+             offset of the page will be returned in `error_offset`.
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
+	/* in */
+	union {
+		__u64 address;
+		__u64 offset;
+	};
+	__u64 size;
+	__u64 attributes;
+	__u64 flags;
+	/* out */
+	__u64 error_offset;
+	__u64 reserved[11];
+  };
+
+  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
+
+Set attributes for a range of offsets within a guest_memfd to
+KVM_MEMORY_ATTRIBUTE_PRIVATE to limit the specified guest_memfd backed
+memory range for guest_use. Even if KVM_CAP_GUEST_MEMFD_MMAP is
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
+If this ioctl returns -EAGAIN, the offset of the page with unexpected
+refcounts will be returned in `error_offset`. This can occur if there
+are transient refcounts on the pages, taken by other parts of the
+kernel.
+
+Userspace is expected to figure out how to remove all known refcounts
+on the shared pages, such as refcounts taken by get_user_pages(), and
+try the ioctl again. A possible source of these long term refcounts is
+if the guest_memfd memory was pinned in IOMMU page tables.
+
+See also: :ref: `KVM_SET_MEMORY_ATTRIBUTES`.
+
 .. _kvm_run:
 
 5. The kvm_run structure
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 0b55258573d3d..f437fd0f1350c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -996,6 +996,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_S390_USER_OPEREXEC 246
 #define KVM_CAP_S390_KEYOP 247
 #define KVM_CAP_S390_VSIE_ESAMODE 248
+#define KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES 249
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1648,6 +1649,7 @@ struct kvm_memory_attributes {
 	__u64 flags;
 };
 
+/* Available with KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES */
 #define KVM_SET_MEMORY_ATTRIBUTES2              _IOWR(KVMIO,  0xd2, struct kvm_memory_attributes2)
 
 struct kvm_memory_attributes2 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4d7bf52b7b717..cec02d68d7039 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4972,6 +4972,11 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 		return 1;
 	case KVM_CAP_GUEST_MEMFD_FLAGS:
 		return kvm_gmem_get_supported_flags(kvm);
+	case KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES:
+		if (vm_memory_attributes)
+			return 0;
+
+		return kvm_supported_mem_attributes(kvm);
 #endif
 	default:
 		break;

-- 
2.54.0.563.g4f69b47b94-goog



