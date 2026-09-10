Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40D2DC88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:56:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B5A26B00BD; Thu, 10 Sep 2026 19:55:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 418706B00C0; Thu, 10 Sep 2026 19:55:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CD456B00BB; Thu, 10 Sep 2026 19:55:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE0956B00BA
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D317A16058B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:45 +0000 (UTC)
X-FDA: 85199512650.20.CD76289
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id AEFD640003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hl62wMAQ;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084543;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8yI4srHT5RhqkHYwR1v8x3tYnPCsA3hxiAfDm57Mjeg=;
	b=1fOlAz+275AdFsHpOL5SaU6ev0nUADtwIpDjT8xfeDCj+Zcl94K3MwHHvc+p/Vz0uc8Cj7
	bxTqoDQDuSLCjISsMdLeWQtLu9xpA5GxPRx6gtbiYHjNSm7km9CwcBpZ7oC7fDm5rlQVoQ
	RaKTykJ/H5Fx0/WBaPMelM5Ih5uzg3o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084543;
	b=kx8f86A8yBJMgNwtFjQFfgTGbys6luWc5jMLsA43Nzqmyk9o/4HYV7d4GabUiJpzy4bIGU
	bdiZmJLOUajqhPlXuPMOobK9lf7frEA7H2nS/LVjps0+jFlKHJSLq2AjN0J60lDsQcew5O
	PwdPhGblpjfx2DV0NXMBLIH8lyiFmDI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hl62wMAQ;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E79A447B4;
	Thu, 10 Sep 2026 23:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0352CC2BD05;
	Thu, 10 Sep 2026 23:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084538;
	bh=RyO6sv6D0I3PgJK1+UaY5jE0MXECZvfsi9Rfr4GXRpc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=hl62wMAQPluw8jBVY08TbvWidyWQg7pexmsM49MUo2PVqBLQ0dBHB5DOxa0oY40ly
	 73dRmCzojkIONatL2JmI3NSgdKWYdHbnZrs1QxpRlb4qjUJojGbokxR8UN5WknlTp/
	 +7TGtwtr/he1xYXvGasB4vr7nhKPyZ8QSJYhmrtkdpxRpxmM6lSq6utItwri6HWept
	 P/LvozXrQmMc2qOC5W1wtYn/8TzQl3t6iBVAGzxXcT9HpySoSUsCWB5OBNzKLkXw8t
	 fsY5mCCqx/kZsCTtAtF/r8TlWSpr+HlYGRDKGY/nQHyZ7oT5ql/kqoPX9gVuLVgnWg
	 K4gBH4brZYnfg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E026DC79FBB;
	Thu, 10 Sep 2026 23:55:37 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:55:40 -0700
Subject: [PATCH v13 14/44] KVM: guest_memfd: Add base support for
 KVM_SET_MEMORY_ATTRIBUTES2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-14-dd6fbf94f4e1@google.com>
References: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
In-Reply-To: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
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
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=13687;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=6OjVVDZ8OpcBvDNAaOZRmXE6R/ns/FnEhAzrV9e5u4g=;
 b=i5nbGXFXE4MINiIkEg2+4KthMAA/YSv7XYEnVAqZQPWzqO4FQUA8dYwlQy2P+ddVLdaKRUCvW
 BDpZZhfvgPMA5rqSLYbTehjdyU1NCf4iOVv3EWZ/i3RTE0xlFN/HgfM
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AEFD640003
X-Stat-Signature: npfd8u9mprp3xjkyosnd6c4zkxkhztay
X-Rspam-User: 
X-HE-Tag: 1789084543-853046
X-HE-Meta: U2FsdGVkX182N15kSXsTVfnJVOMqT5h9+P1JMdxV0WROvi4cFOhff6wEnugC556E9ftpPlC/+Fe/Eqa2w3ZppN8Z/EpfbG3hqHZqrT7YtdpjDv7hJXqmXtKuN3+zt2rTviMqcY0gIymp5DZyFOTOlrw/+SQoKZkkXN1T37I4VkYC3KDXJTgtr/T8d9hdC0c1ZhTFGhW42UwxcnNv7qv3wmOYoBZUvYdlfmIQlGvJ/ZjEOqu0OD/cMJf/tPZkmlXFxWiGoHaRW0nitM0f3UFjcqYj/dUBjBKDGXehEzqIqYiA7usjgxS5FcHm2sI86GQPNBPqI2QvYB1FZoo1Ho8vCiyFry1zYfDaHHtrY7jkkXoYQvKNP1l+eG5SSmZy6uhynkm+63KshNWpew3oReuZS44/z7Zl3vbDOUFjM7RuxK8UMbjXoONNUO60TGA7MKcelB2pHwQsb2Cdh9jHnch7ZSy2gL60+AAMrLuJi/axQ1IUow9c7yzwgJENx4+BnIyaLoMMv+dCzOX7XUUsoY1kbeqpFHJo7E7lZWrFb+nm9s7z5LGR1iC59otfXRRlkY/q/Uy6Ea6N+o34R6btxJyw4vZreA4vE6gYrgZG6dd8/lW8TTkBPz41B6U6PjR1/Rt3PNui6z0lFU5zm23Rh+VReNycBhb26VfM8YOMrnjgw2lhOYjAcaprjw5HGrdh47na35k9XM0+yB6DFSP95+bd/bHalpra/pg39qclTdKjyD7eAcGnVYpEX9roSiZdE1X2B6fqeYZ1UgyHqD8/m5ETyroMj6cSCfBIlmYg9OOab9elPOQvsuANVUxV5w+B1vbi8IXNwBHyMaVohzsDB/8YevXO7Szyulaw38O0ET/T/pzxms2EP+itETYfL3tEs6penmg7f9jybNSieYly/2Q3hcLcg6RdZA/ihJKMJs5Bo9MXNRc8RBlE/6J25LDb/XR25nr8RJA6esCCD//tUp4
 UQ6Sk3yI
 6D8yzsKZ87GmOfw6m+FYIc5ejD2+7BNNuVOCUfxfoeQjcbuZdjSRUZuAwc/Vr5jUu77V5fenBkku7rtAdUHlQk0TfAtfm8JoL8gv+YwVNGqxY/CvDQF2qbhaDXGLo3ebBLJBCREjxWksFG81sELt+fMI0W6NgdffJLjlWoFV4FNCMBXWW064OO62VbettJ2IXhFpt1ZRTEuFHEvHd4k43d+ToRmu4IoM5UrVj515ebO1KbBadE3F6f9ZzTiJTpjFqpxZSCNPS4ba4FDELexJeJIsLR5oOd2TZsb0E+KCFpxXBofpy5p2znc6gJhWkbaG/tLVDk19JwqglxH8fi6zWb4JPpG0qQTpkH5DOByf2ucMzAzPzi9k1sXIyI0iIYIQHW71sFzVSasP1CCsoP+m8cWLz4ivv69Z2fOUYZlox3FFk2osHbNh825kO03CIkJyD1gkohr4mn2ayiFJQSIXzM/NHpdUaAwI6i1kwhv+TRi+nG2uIePraHqt6FLPfa0KrGqoBKYq2oML7I3Gi3BW8NvDl/IMagvHHCgvx3729I/frlnyUJk0yqZQvrpLoE7U082YTLhAmBAUxUtRurWRpXaluwIREZPYXvf7Z
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
the same layout for the fields common to version 1 of the struct, e.g. to
ease upgrading userspace, and to provide flexibility if KVM ever adds
support for KVM_SET_MEMORY_ATTRIBUTES2 at VM scope.

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

Suggested-by: Michael Roth <michael.roth@amd.com>
Suggested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Co-developed-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 Documentation/virt/kvm/api.rst |  71 +++++++++++++++++++++++-
 include/uapi/linux/kvm.h       |  15 ++++++
 virt/kvm/guest_memfd.c         | 119 +++++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c            |  23 +++++---
 4 files changed, 219 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 35d94c51cc56a..027156508d04b 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -117,7 +117,7 @@ description:
       x86 includes both i386 and x86_64.
 
   Type:
-      system, vm, or vcpu.
+      system, vm, vcpu or guest_memfd.
 
   Parameters:
       what parameters are accepted by the ioctl.
@@ -6385,7 +6385,9 @@ When mapping a gfn into the guest, guest faults are always serviced from
 guest_memfd regardless of whether memory is shared or private.  KVM determines
 shared vs. private based on the state in guest_memfd, which is the sole
 authority on private vs. shared memory.  See :ref:`KVM_CREATE_GUEST_MEMFD` to
-find out more about the creation-time shared/private status.
+find out more about the creation-time shared/private status.  Userspace can
+control whether memory is shared/private by toggling
+KVM_MEMORY_ATTRIBUTE_PRIVATE via :ref:`KVM_SET_MEMORY_ATTRIBUTES2` as needed.
 
 userspace_addr is expected to be the mmap()-ed address corresponding to the
 right offset within the guest_memfd. Any mismatch between userspace_addr and
@@ -6404,6 +6406,8 @@ S390:
 Returns -EINVAL if the VM has the KVM_VM_S390_UCONTROL flag set.
 Returns -EINVAL if called on a protected VM.
 
+.. _KVM_SET_MEMORY_ATTRIBUTES:
+
 4.141 KVM_SET_MEMORY_ATTRIBUTES
 -------------------------------
 
@@ -6440,6 +6444,8 @@ the state of a gfn/page as needed.
 
 The "flags" field is reserved for future extensions and must be '0'.
 
+See also: :ref:`KVM_SET_MEMORY_ATTRIBUTES2`.
+
 .. _KVM_CREATE_GUEST_MEMFD:
 
 4.142 KVM_CREATE_GUEST_MEMFD
@@ -6676,6 +6682,67 @@ significant bit):
    Userspace should use the defined constants from ``<linux/kvm.h>`` rather
    than hardcoding bit positions.
 
+.. _KVM_SET_MEMORY_ATTRIBUTES2:
+
+4.146 KVM_SET_MEMORY_ATTRIBUTES2
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
+See also: :ref:`KVM_SET_MEMORY_ATTRIBUTES`.
+
 .. _kvm_run:
 
 5. The kvm_run structure
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index ac2d77d149635..ac371a50041c9 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -999,6 +999,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_S390_HPAGE_2G 249
 #define KVM_CAP_PPC_COMPAT_CAPS 250
 #define KVM_CAP_ARM_PMU_V3_STRICT 251
+#define KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES 252
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1653,6 +1654,20 @@ struct kvm_memory_attributes {
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
index e19de803149c2..803c7cdbbe0f6 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -506,11 +506,130 @@ bool kvm_gmem_is_private_gfn(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_is_private_gfn);
 
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
index 46d2e123448c2..1ea8198821917 100644
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
2.55.0.1007.g17ff1f9808-goog



