Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EADE0C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:36:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A97C6B00AA; Tue, 28 Jul 2026 20:35:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00C826B00AB; Tue, 28 Jul 2026 20:35:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E62446B00AC; Tue, 28 Jul 2026 20:35:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BB4366B00A7
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 47ED5C051A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:16 +0000 (UTC)
X-FDA: 85039945032.18.B6E96A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4906A40005
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PRfq0ivv;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285314;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6GxuRLbNxUSHl0VOamaPCWlQtt0n1TXP+EmSF1K0hYs=;
	b=tOSSv1e9iBYRprQVK2G9b+kIwzWn/6OFmfQFe7G5Y9VXbssVzZ+Ac8EjpDI9hB/op5yqEM
	mK4pajSv8n8RzhZY6m1pjRQzxqT8DeRF332jC0q+O3E5AmiAHQevyUCIEA36pHWvjxNPgq
	90ZNRoGIu67p69PbGxv8SFGWMkVEt+I=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PRfq0ivv;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285314;
	b=0zHFHtjkhn5QrpefdQ8k78eX5fKMExnwyhoeU/TpVgNbmA5toFcu3tUcoQ4UYILyeLdKVY
	7/TVPIr8A+ll2uXSKUG9w6OAsuc/jXhDtQUYptDN2NFrO58MWUlJ8lcmoquysciXdsxfOd
	HYK79GyijJjyXMwFkHRAeOrybGYPIto=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F1EE451B8;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A1AD3C4AF62;
	Wed, 29 Jul 2026 00:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285308;
	bh=kQ4EoX0ON9jHg3kbnyIen9NL0bXRhiNTJ5ixMhqvHwo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=PRfq0ivvT8eU4rGXYcbw/Yfpb6yuAQfRG5jqIhyHgB4jk2etY8jw4XXINpogwd1Aw
	 quPKPcL4Xzh2YVro5fVP6NH8lJj/JE8s9IDscxoy8tVFqhCmcIUKZBz3RFdO/GC4U5
	 zKTbfvEGZvNGx+6XCChJte1mvdEdOTo53/+leyJdMmH89/YAZY9gbLveThvOOEOyv/
	 Bw78UUWNBZh7qJIvrUOCgxFvI+ohcOH3UT/DK+/SLxPInrSfjaU8pr+elm0xErxKXm
	 1EqIkELNVjtHoipIkc3HlbufBYu5Vh2sfKh/nOqgVHjX/e2KUlHwuNLhZciy8ovXIq
	 CqdZQWw6/uavQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8483EC54F51;
	Wed, 29 Jul 2026 00:35:08 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:09 -0700
Subject: [PATCH v9 10/41] KVM: guest_memfd: Add base support for
 KVM_SET_MEMORY_ATTRIBUTES2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-10-35f9aec2aed2@google.com>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
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
 Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=12547;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=5AHLZsTJDgVeAhrdat+eCh6xqYAVzHd/MVwr/kfHjt8=;
 b=maGOqqxaybkV9D7h6Vrk7X5BnzAB5/3TAmenpQxbPY7kU1coX/aPGCL00xIDUmTW596Rewi++
 p+JS2LxNM06BCKcfdeoM4teqMvlTLiaIkah3DczR+zqaSDdRtUiOz2r
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4906A40005
X-Stat-Signature: uruixrqkshjk4eos4rrqhdy7pmdhyxd7
X-HE-Tag: 1785285314-881350
X-HE-Meta: U2FsdGVkX1+CsfMODwJJ3Ywqt2xkC3Rtihw9y/Z58zDguWLzm+nZKMxXekDGQzhh4imLfmRWzJW6hxzP037Sf1KyuBMdfGBPB255P9VWFPGIwVNaB0GwvoWJxDFuIztCHT4Dd1UgTtJAm04xqiNgKIWFvG2r88M+ozuVt9x1SyHEVWkXMTAJ+57plnCdNEWnc5NXFxuMYkoMxB4R9ubnQpZL8X+TBzDYyVNOcsuNns4uXKAbd9E30KWjNifQiwhSIAtzm6DlfFXRbvIztFdd7FxCvjtjd/tN83/3DaUqVlJJN0a9Xe/3wU9fS8v/ulunOKL93u5hu99WJOqxjsahTklwKeV/CqKVfcXG2UnWnAH87YorMNchqi043M/IW0P5aH8+ewPMQF/H0hRu0QQUcuKrDxv6DhAMizzFqbJmhWu6jFDztvHRxqNzgalNvAAS1Y+ba4ddR1xu0Shn2wQwOSFlmE0aggsF6Hy9i4vEfggjHDt2zW7k7his0SStjRlbH8dNu95JKp90/y6gZDe3GHVDk3ge60RS0UxwQu5AGqC6HwHdDJFUD7L/1nkWP1ifuZszMv4xLgeBEeOecKNtfYCCbbSMF/6L0lZOwyNPcjKePEGW0hcj/ZmQauJTIzga9s4jlvAhtplN5ltswy+C74JZcHhttcYrpDop5SWGpO7Loe+9WhEtZdcoEkqrb0DiTe0bTXBkD9mak8jekPg5IHVwNVPsrcm3y1PXQ/99bjW1PxjSKibdwbNm+r1SOBCfctXvtjSraVNGz++zwI8syWwQsBXmwDweR3NiUgckxOu59Qq/Q6UfBQQj5sApF12CJ/Z7laWFtsgSSW5ZiQrvP9h2qB7XadXqnlOWcq0jOa8g1SDLBDRN3N49fRldjy/zKvkpeYcQK56Ziyb7fRMumX8OcfZGgU1Rf+CRLIQupB8SmcS12HrRVhcYLbBKBhHICgrsfL9+MOp8nRPVzMD
 8tOYhKZw
 8sZ4JPPEX2gk8M7kksoMbjevaLczSXCtWhgtMz2Zct7Sfk4L7DjhMvC/5p+wVfyOGkb1gfegyMKblt4Fo4s1akgI3okZyuI13sMjFTvmJFHvcmLyvzPCJPYAruO71BBTmpTCBRlF/qsnf0w7hGRJB2pF1/8DMrhis5u+PYGwKjpeBuEhkAy9E1Gu65SQtEsUdpsV+8Mfbuij/DM4aSm4et6cpIevv40AZ/dOWs/bs2cQznjWH/qQxb8IyCM8k/eTR4b10C3Y5Ir1F4vU86P5lSXyx4acJ1KUvI/ZKQ33YTjXYdNJAilCWgu+2g5DTBxsDdi5lNDn0CrfGr26JZAG1XBj8bzdCiibe8AhVF3Uzj6ukCxxgKEMssAqNpC/dcg+sAd2A9XDoEXE8tfQut63A0CQOxKR+79BoVXRu/KcJyV5WFoT4xrLdEa8WleRJTDQ2eP4PlkvMDKBoZY2SlVGnBjLUi8JucCRZ0PI1pckk/n5Yn91Aj7L4u50RnLGZFRtHh2tbmwAaWD3n9aQ0QfZHaZNkgvMZ2MLHUnV3vGaZpoAUHXeJPhRiUnWJtxCR6HdADtikAqYroTamSB/XYTmR/4Vnkg==
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
Signed-off-by: Ackerley Tng <ackerleytng@google.com>

tmpo
---
 Documentation/virt/kvm/api.rst |  63 +++++++++++++++++++++-
 include/uapi/linux/kvm.h       |  15 ++++++
 virt/kvm/guest_memfd.c         | 119 +++++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c            |  23 +++++---
 4 files changed, 212 insertions(+), 8 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a5f9ee92f43e8..de8ab3db8796a 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -117,7 +117,7 @@ description:
       x86 includes both i386 and x86_64.
 
   Type:
-      system, vm, or vcpu.
+      system, vm, vcpu or guest_memfd.
 
   Parameters:
       what parameters are accepted by the ioctl.
@@ -6373,6 +6373,8 @@ S390:
 Returns -EINVAL if the VM has the KVM_VM_S390_UCONTROL flag set.
 Returns -EINVAL if called on a protected VM.
 
+.. _KVM_SET_MEMORY_ATTRIBUTES:
+
 4.141 KVM_SET_MEMORY_ATTRIBUTES
 -------------------------------
 
@@ -6566,6 +6568,65 @@ KVM_S390_KEYOP_SSKE
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
index 6cbd96e2a99d3..c9b5151f010e9 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -497,11 +497,130 @@ bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn)
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
index 0dfc91b9478ce..f0f802eaca16b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2422,18 +2422,22 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
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
@@ -4968,6 +4972,11 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
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
2.55.0.508.g3f0d502094-goog



