Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73352CD98FA
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:32:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93F016B00A7; Thu, 18 Jun 2026 20:31:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89F2F6B00AD; Thu, 18 Jun 2026 20:31:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 718936B00AC; Thu, 18 Jun 2026 20:31:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D66C6B00A7
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:31:56 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8D0141C4820
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:56 +0000 (UTC)
X-FDA: 84894784632.04.933069B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8E0E520003
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=muI8HkG6;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829114;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rmL2wa6uCT4iZvILg7hZ2hybHyUtiN9u821LWQv/1xE=;
	b=sA2OS112QbAQOyOL34JHUzD04Q7yDae2pacHW4831X/jq8FSdqEaZhjZPR6mLhafU9h63a
	u+4HwclOsLvspOPjouiEFqH/TQBd/KBGUA7OfbzqA+O1g9deoDIZnJ9krN7u3DDTj3wSi/
	R6lZ8pNyA6K14QTnuYMfiCTzZOZuZbw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829114;
	b=pdaKFgUju4XHTiDgjSW3DasXSkgF7NHJUP7Flf6KjFzAW/gQlqXdqIMbEtr3SsPscxqU5l
	aO8NA/Hcf1rUt+j9HeunQ7lnYaXI5XKEWOAjhcRQ4IJj92cejFOjP7dm4BaYZpSZNG6itp
	DN4rqr7nhLgvV+mpV1vXdmBI3iFS+Ps=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=muI8HkG6;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 953A343B90;
	Fri, 19 Jun 2026 00:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 679D8C2BCC6;
	Fri, 19 Jun 2026 00:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829108;
	bh=BOM7ZJ1JW0u0YzgbuiclAchPegZHrzqfCqHwM7mihcY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=muI8HkG6t6vg4sUZAq06dnNvTfuctNgxdRKNYSBq36PYqjO5RWZJP6JgGM8KGil56
	 7jFN2wUZKElBvcAwbHnvjb+mTO+/BY+JhAGvYdEYEO0LRIQlMrYKb+yeqwgR5HH1wF
	 lXxuRNZcPFhxxgcHI8CnMnhx7ozcawqzErnwTqduO/CmwpdWt9tTlxt3DqYbTbfjaN
	 ImFrgLnvrk0v0fEpzRqn+u7xbw9pVRk+vjWExdOENTqoNtAF+SI2w6miHJVJeWwst6
	 RIKGfPl/JCIFCH4coGXadb0TetCx5h1dtO3MI+td8Etn/4LFAjZH3jWT9XQv3IPPZq
	 HIRh7xbbJ2q4Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5871BCD98F0;
	Fri, 19 Jun 2026 00:31:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:31:54 -0700
Subject: [PATCH v8 17/46] KVM: guest_memfd: Advertise
 KVM_SET_MEMORY_ATTRIBUTES2 ioctl
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-17-9d2959357853@google.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=7105;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=YacQyfoh5LAvr8NDk1VotTSGTo3cFf0sr+4p58N5sUo=;
 b=aX82GKUmPJFL0Tgl0CUgVBp6Ne+8odMwEYUTsv5wWY6KzNyNnJsXUUXSFgbuDLuIsAG8njsSA
 JFLrRc3+LfMDDa7LdPDTvfYbWl6uE05nrQ6vjBPjLICSzT18R5a5XCV
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Queue-Id: 8E0E520003
X-Stat-Signature: w3emimn97idu8hzfiuahiy4u13uw9mbt
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781829114-122925
X-HE-Meta: U2FsdGVkX19yt9qK9aM10s9enAQkyvcIYtp7doH/OWFbtgfMqk+CDZf6Tm0y5pxzns1BDYlwx4CClgHKHmI9rrBUbgiauiaoQzwY44tyv6WGK3aJlmHl9aQtzxM7MUGNg2awflL+tYen4YUf7z8Fgnna6YLZlH+6WDNBCvTCsfNj+KAkHDQVvfAH/Dh0o+qBkW/oxoZU3yVP0aSyZdEjtALdcE+Mp5TD68ecybyaVRMkgA1+KOw6iMd+n/K4eMm4qptvFjC+/bXk3yWo8+XG2RWltvoKnuyHO1J+WLwRoEZcgPQxf/wveEXEEVII6tFjRNdOW8rSVB+orBHfODq4UUPH3oQcQXqW+sB7VTaszmJPp2VdAq1POc2Eq7el+UNEBOcjFECPlDyQ4TLCq0Aok34JFJBVCkmv1KEkc0g2Iq2L8i/rM/bLyQr+W8O+3xqru05WdCHxpCPJHeyqcUT6pvSj/zoDNFNh3ygIKvPfpczRsGCAIh3eLxToKWSEuj/BK3dA2UsjURnvF0TbGd88dGXFk0mrYsXSaudWpBcbitbZ2D9NhBu316BppFlm6Xudmh4d8i/ixaqWDJi1uvvRF0gf9qdUs8h9C2dIgX5q37G/DP/qyfzM3RTXp+Cp6OpUlGWeAPfcGAWJHKV0/sY3DDwnGUWyIKIgutgIzQ3DPda5VEKeHgKuQYFGPIwDSlUjj0ruYGcsKhK3x0JtNMasN1SaTfZg5cnrUMLl9GTGuwYnyudnYEDedG4/2KpaFORx1rShIW2Xi5f+zN8cuco68L4xIklm870R2q4KxDfMkVrdMkXfvfBRUomBKjnM1ykLmB94cJncuKQNIHaH0WFQKeqA6EqI/wWN2FKgD8fF/hJ2qid9KnBlwJ/5SDEIDKwP4LjqjHPYXJcETrySDD29WBcR5tzOLeral34u+eGKg93Vfr86PY/t8qr75VevEAYhVJdVLVhCDPnPSBsB/MK
 A7Q1VASi
 glRPk06svPert/Gy37lGZaZTmHA8gU65Fp2yAJpaShQxii2B9Twr8TNSBG6/NN8rkcjCGU3BXnEUFgN5PEDtAkG5KOaWMxaqe2yef0m3KHkZdzemEAGjjpxGXOIb7X4DH7gNc2wDFu4b2aSCT9URkNlOCvg8vru+/96yAG9SobN5eLCYLpGmhbcSN+8siHk2V5+nbktugJrHJVpAZivzZbRFBG5+wsEt310J/9fChVAbu0CfhPy8kELUzXiGQZWK9tgJUaJgR+X80rhTwzl8+TqytLFDuoo94fN7Us1DZNRCEV4FBE2SXeQQ0iuegplHAkXyE2io/lZywetZYG29pqYWlzJ+LYxlSzXRwebdefnA+5PziWpW9678k6BG4OoE6ApzsJJd7ZF7NILEtmYGxLnYzglHpZzjqSlZZ62wRhVvqKYbsMAJni64OhaLjg2FZhBQJsDtjMiIl3o+puYWyuAAM820MPfji77V3gfBaFIZYYLQTJHcOnEEECwA0AiyWDBhlCMIfJuzDBjIAf0ReL+yqhg==
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
 virt/kvm/kvm_main.c            | 23 +++++++++----
 3 files changed, 95 insertions(+), 8 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a833d90845b95..73878f34f6d2e 100644
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
 
@@ -6566,6 +6568,80 @@ KVM_S390_KEYOP_SSKE
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
index 876c0429f9d4e..129d6f6303251 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -997,6 +997,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_S390_KEYOP 247
 #define KVM_CAP_S390_VSIE_ESAMODE 248
 #define KVM_CAP_S390_HPAGE_2G 249
+#define KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES 250
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1649,6 +1650,7 @@ struct kvm_memory_attributes {
 	__u64 flags;
 };
 
+/* Available with KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES */
 #define KVM_SET_MEMORY_ATTRIBUTES2              _IOWR(KVMIO,  0xd2, struct kvm_memory_attributes2)
 
 struct kvm_memory_attributes2 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a08b518cdb175..044486f128c37 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2434,18 +2434,22 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
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
@@ -4969,6 +4973,11 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
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
2.55.0.rc0.738.g0c8ab3ebcc-goog



