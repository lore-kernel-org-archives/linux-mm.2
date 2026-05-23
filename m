Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33FEBCD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:18:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 596F26B00A1; Fri, 22 May 2026 20:18:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 453726B00A3; Fri, 22 May 2026 20:18:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 280286B00A5; Fri, 22 May 2026 20:18:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F25D96B00A3
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BED2092B7E
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:08 +0000 (UTC)
X-FDA: 84796772256.30.F6F76B2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id DF1CE140010
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hgMxc5Dj;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495486;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cnDLgeVOdxKFRH9qsV2OT8MI569vsL6eoHdoGZsj+vo=;
	b=gXlsGoYZ9VtRwskBU5Xk77AGjzLpSb9yqTeXavSu+ExwugJ9A/j5DGBPCBAHk0rtBREbCQ
	YCaIfc/XWqlxMJDd+/IgdmsGpoUdvVW8Wr4TkWVHKL5cHVIRnRofTA1J44twCVlC2WixMH
	zVV9vsmesV/aAFZ3pL6TDQmxVsWspjU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hgMxc5Dj;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495486; a=rsa-sha256;
	cv=none;
	b=CLH023SjS0nC2FTXSOkTEycSZzrXiQuQxTN46TKnkbPhfjdRIiqrMKuaM16dgp1joH3Mff
	1R6kusMMrElGVMOD3SMcxfjUIy8vA1fsr9M7uG1otaGseLWn8MC/efDhm4xH7bO+sucp+U
	aMIzjh5OlcfUoCApoAD37m/0wGK2t+A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D68F660236;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5BC1FC2BCF7;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495484;
	bh=Eugh+27Gmm7Pj6I4bRrCsdsm7uRifLMWoCpB9lckRHg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=hgMxc5DjLsaA287Tnen7qPygMqQgcbeZdIcyaoDGov6viwgO0zaNGSZWtHfgNPyXw
	 HrBTKsB0+h9/fAZCgbYL3hL3KVaKke46mcew02EqClwYBurW8mbPq9EQ8N5gj4pBY9
	 UdI2HsTLExXXIC4wsDhAcO+jyhzRHfwhlkW0RFUiGF6TFot5Jx4/zFiHfGJWB/Y0t8
	 O3EcNCEjWd4j/s8QgTAhGdrfMCsKfJp9P8NXuoGLw/5HTy3nX9XQggaw6Gh89+jeVS
	 jwg5GV70Mtuf3SoS7fb0oYMEma2/CKMlhXn6UcraHv0nOlsNa4BBb17Dv/n94/yl4B
	 CAcmCk2zJrENw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37824CD5BBC;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:17:55 -0700
Subject: [PATCH v7 13/42] KVM: guest_memfd: Advertise
 KVM_SET_MEMORY_ATTRIBUTES2 ioctl
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-13-2f0fae496530@google.com>
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
In-Reply-To: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=6326;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=pX8xK0EzfZhJlJautfGmNsvfI4Cboh4bVxCVp6l6+RQ=;
 b=aopXtw8oz0d3e09fJEuzdmxOmhA0whGymjpXKfSmtwHDjj9vcHm+RaZw2BRvWa80PIGMHMbl6
 SxK8f0CKl02CqB/4atV/5t3DfA4FrMA/cfVZDb/iPQ57ivI4MyeRV7C
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: x6i85ictiss36u9peg7ohtddcopk59rk
X-Rspamd-Queue-Id: DF1CE140010
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779495486-859384
X-HE-Meta: U2FsdGVkX1+IqhGF4gUZnguWcTY6/hhlkz2EdHZrMtQC/+RbL8DHfar918BDCQ4Ix0Eexs5XjLSAvk3nj4MmhoHdEX2EeecJRSbb82IUvdbf379s9nfU5szCNvhStSlsqQhqJ91plksZ29x6Qt7VlS9sIEv0AB+DeXD0KLmIru6bNALcBRlCwxkitYkmXtz8Uf9RjpDrsrQHFRj0aCWTLsBGO8CG/nG4GYRE/qKsvQb6G5LqdpvBQlF9GOQHu3+pV9DgiVLBfJKSeq/ofNYNLia2WTfDITynnW4Of85IWCniY4cFjhDXbfx97McU3DwunAcD9UDtuULV/IZSZ0VDb54gvqN6MGMv+/9PuyD4pzOGFKwh+Fu48I+QEjlB0EMaRCPrI3K4JM1CGcvnbqIG0jmL77GNWPLv2hxMZ8qiAUbax7xjdHXZ90Q3aikCsROdY4N4qlRiCnu3Nu+M6vAQ10HuHuP7l9OXC90hr5JWQIPZEzS6zy3M8h1+Pu8eYh2o7djMFhyA9/SrwUuxyPawzYda4yKPnoBUH1nCTMniD44QiOYGeeKOIpaQuw9VqOQVHA0UrT42A/a5hszKb2/K+YrHzFQg18N181ivNB+CEP2aQ7uJWNQ9L8zdQxEeSjvrPWVIBVMVcHj4tqMyZJdLIQEJzZdJah/nkRPIzYfyzXDM6mitVFf6+IFyIU0xYHNSJrmiSsRrTm1NWsJ+lAwNQ4RixH4JnFToNZs4agfEUsRQjjjFaEkTYsEOBeKmfFOhLA30Gxxy6KRc8XhoEIHNWnExc15ntBlBVE16dfFqhguUFjInGJQFhGhB1eajlOfnow1opgaGIJZ0RYIJMnXTTJL8i8rj5msgbyQkhAm1WjFIChS7yy1HDyExViSHQ1LIlmUQ3eXw5okIt30C6Yi11faV9+apwo7LHwOIeU9B0FDp2gE7Ya+WRNJbzzrUeY/I3D46CV2LsHnndPF211i
 kk6VleAd
 P8YyTk7VdCW5qchBNqdGyy5DlXHY8bTMO8W/ord5+IeUo77MCQBqI2/rNsDvgDEjer1Qbrpe2pi7otcPUS1gG7nam2LcU3S/+e8ut3I1nlkvpk6qjF6mE6uJr+sZiJB/uBbAJedHOR5kL254HkQ8ZOSIDrZMaOGoL3YVNlKeDpLCeRzsOdZX1Md32MBdw2brHEtCVv1vhvuRB6bCXzLK5SJe+HjqTBIL0/2SZjc90jbenN/6F6V8AWE0vOaewrO93pxhReV7CEZkJduZIP0CEz/5umizL9zNBeIyrqSBPIigpIQkv9NsmQ8cOqRUbX+RrGMUjrfiM8XJtMzw4yJExpuo4BU7xoCwOH+cnhoDsxjKpMcdw5CmKW/LKpbA4GlnXo2Gb8X7BVZURI/eSTGh2vwBYHQcLoONuvLqVKeBkkGCZ8ABA7JE5kEgfD43NOtYAnVEotJvriTA5fy4pK7A/2nIb0VNVsCBiVMP56aIpKA9wAXA=
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
Reviewed-by: Fuad Tabba <tabba@google.com>
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
2.54.0.794.g4f17f83d09-goog



