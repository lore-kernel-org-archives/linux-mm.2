Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1D12C61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:19:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 000BB6B00A7; Wed, 26 Aug 2026 05:18:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA5B16B00A9; Wed, 26 Aug 2026 05:18:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBC016B00AA; Wed, 26 Aug 2026 05:18:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A93576B00A7
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:18:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3C0FE1A02FE
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:33 +0000 (UTC)
X-FDA: 85142870106.29.BA53EED
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5FFF6C0008
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TN11INhX;
	spf=pass (imf10.hostedemail.com: domain of 3Za-OagsKCFo24C6JD6QLF88GG8D6.4GEDAFMP-EECN24C.GJ8@flex--ackerleytng.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3Za-OagsKCFo24C6JD6QLF88GG8D6.4GEDAFMP-EECN24C.GJ8@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a4+muP0BZHkr0B+oWf57LAj+XypxVv4tq4m9lXewalE=;
	b=p6yd3549pyoHaoXPkG2KW8gmRDd3P8AXvnUCnjmeNyE3i4xE21vP7n6z9+U94b6kvZx34t
	7iKTUfhkRyIi90whSPWMRI7T8fjDDnbQSpJJfF8GYbNeQNIMqfIL1K92UodVwQfVd/jBWB
	nHC9AdfbOGq4kPe0cVazq3MdsMk+Nu4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735911;
	b=LrdlX61JqImyvOwbHeyStRcsef8m3TWsEuJu7/GYDdd/pkdexw1DucLdZ5sPQZinHoeRWI
	kf4p6NsXBcRLNr26nK7UqcScip7fWqDDQoJN9pydR6+sbFny+MSSN6lBP2gvRbrHqvE4JF
	XGQqK+dyWgJeX9WCLfn/RAOAomZojvo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TN11INhX;
	spf=pass (imf10.hostedemail.com: domain of 3Za-OagsKCFo24C6JD6QLF88GG8D6.4GEDAFMP-EECN24C.GJ8@flex--ackerleytng.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3Za-OagsKCFo24C6JD6QLF88GG8D6.4GEDAFMP-EECN24C.GJ8@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8485d853b08so933284b3a.1
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735910; x=1788340710; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a4+muP0BZHkr0B+oWf57LAj+XypxVv4tq4m9lXewalE=;
        b=TN11INhXsUiwjmXd9lWvJkYY3d1n+wCaKqOM5dW4/tXSRhr77BBcMm1rM3p+EcchBH
         lO3r+i6D0ifMHrvy1MdSf6wOkLXc4ERGePwo5OSCS/RTqfbkc870Wd8AJgZpMnc9wK0p
         hLKm0UeDdpljNLF5FDX/udmWRJubZ1Ykw1RZUaa7od/j44b+yIyYneNTYSM4I1+IiLGu
         2ozwknLwfSNbLEh80/oaoENrsr2hMuG/+eu2mv5zwElDqaqsryaM7c9oYEdjg7GyBfPE
         AifRwBPHXwFLfVYNbTJrRwtamTTdexn+U7puWVH2me6ypz4o5qhUtb1huIlsn+HF8NMM
         vb6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735910; x=1788340710;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a4+muP0BZHkr0B+oWf57LAj+XypxVv4tq4m9lXewalE=;
        b=H0/ueanJVYaNBPXyCfXqfRqG1ItW9LWcYzdLVWCWYBDxZu+T+um050tvOOaEjTYJR+
         pGfoOzdU9rYXjlFSgjxPjPti4gS8wngV/BIkTq3t16UICuDW7aUIgFlM6C62UO/lqPjD
         WB9uj1SdUMtyipXTFZg90YnY6xRznoaPbwDejBCiwBgTLkq+X2p09cOotyZm+pINMF1P
         9H8JO6erAmlF5UzI5tLa1fCPL2YB/G0qTI3x+nzfm7juMm18tYQQrsXmbWDnWyajk5fe
         tySL1rtgnpidYrV9bV0vQeCdXIS2zehaE70w1ebSr71rhH5cM535mw6f8+0EvH66tA0u
         WStg==
X-Forwarded-Encrypted: i=1; AHgh+RoFX71r8YE1QsG68kNR3qMnp75FpJ2Z5A2njne4eZKBbzEC1pEOQGflhP13LO/RebXWeAXf9m5UeA==@kvack.org
X-Gm-Message-State: AFuF++kJsw1eT4nutMhs8SgiztIWJm1adcLnDUL1eM5G9chcJDprsD55
	s0QpvKEO9LnZRXtcGQuRnAYAibca7W7lvVXDEHdnVa9TQIcIcFd63A7KilxHzXjWGH2MkH+LHm1
	YI3UpnLDkBn/dD0U5+x1Dlu5dcw==
X-Received: from pgbgc2.prod.google.com ([2002:a05:6a02:4b82:b0:cc1:ca15:6da4])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1745:b0:84e:9257:d0c2 with SMTP id d2e1a72fcca58-85373eb0bf6mr9385662b3a.9.1787735909685;
 Wed, 26 Aug 2026 02:18:29 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:11 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=12667;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=QFc0EsF1ikqFVpn4U++lX3MemTAkXRo62SHSovLKp3g=; b=QAwGSW7iVdzKMCC/LY2QbaPlNjxCxXErz3s8gdWawWGzB3sB+ann5kUz12vx8IDfDoJkGBfHK
 fCVq/fxqlNLDccyXSxOUHEgWwCxWEnO98UY9zJ3tHhe3vWb/VPUbnAb
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-13-0a15d8a799aa@google.com>
Subject: [PATCH v11 13/46] KVM: guest_memfd: Add base support for KVM_SET_MEMORY_ATTRIBUTES2
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Fuad Tabba <fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5FFF6C0008
X-Stat-Signature: h76fs6bexjj1ir6k5jkgozdqwysbop48
X-HE-Tag: 1787735911-469712
X-HE-Meta: U2FsdGVkX18WU66Z8v61nKJYcnA/D7Cm33JPloE80vx3ILyIuMQ1d2XZFXuSQFpmVkd2fyNgit6XPfVMZg/gcNANouONZ2TRLPVdaS0EIHPx4QQXWwu58Mf9OdUPMZH1M9qJq0LEaBLmD7zTI7NJY5sZxodBTwhHSjgSdQRomuUVakD3fW+AUfqO45tssSiTkQ6SE5NpfkKoQ0ghTo6TL6CAPbEJuYvwks2ZCQkZfY4eNa/AowoxwkJ972ENbTyYpZSIOwBmWut640qYAGxiyAahuxipEFhURpF5Uq3cAHIbd5o/B8Bn87FP2wVxiT0kOoV9b5gYoH1k8jaWNHMQbtqh2qgpwyQs446lmgbSKKVqmkUwtf769PbhO5J1Fszbftu0iPhu61Eg1C2kp+0s7aHQkjgChYoiQj+h6AvCtpQ4CjJ2f7d2ily9/sawXfXYDUW+0kAuXCULFwaFr896Hh+Sme9UtcdjtdgALSF72jvwN4j1/ibLKz9N1bsbJ1vaa8L3GV/MyZshBZSCEZt98Mi31/ix2mBwa6+5UoKokyfh/dz2t2Fpj8uhfLlpWXJ23KX25JoUDWT/49306QEQywB4PZ1pbYRQPI76fU2fkdV0ZhnS4xWe2Tij6ZRku3gzM+IuBFI1Zn9/B/6mLnJTrfoe4ZPWxHEcl98HuMhr66gWLEX12Ni+mUK5fc6MNqMVxqi/IGzzk8o42ycrTmK1fYtuUvFQmndHJP5Ac5NeTaA/JGCirm5k0NXHsE0gsLxPP+JI+wzE82UF7ChpoctTjjlywNFfVcCk4qB+6f2Y69MLO034dd1TjBVkQBdaKGctrrLO9eVkT+SiBVtC4K6c3Y3LSIrTiCmgogZX+4fMuzkvAJq8R11F1JA6+kafPXpdQxy3oexgZbGMx11Fa81nqyBx4nnpUVnb7OQ68dMcOpPA0vABQ7nJ2/eT0M9V9YTiTE+eeei7NO8LSfiB434
 uHrV/y0N
 PXUIOJM+hbl1BZbsV87oUvLsLwVSOuue00MKnCGtU4/Zdve5Xd8GVrYbPLAhQ7DFvuxBZcFiz0D7F70yvsh1fireVTo8L0RW6h7RrTrwKXSEpzi+yZN+nPXt64nAQG3TvIuq6XLUDoUxO77sGZWLRdgckLXe8Pac3j9AGVxuUnnb1Ct6r81YksKFJ2jGbj4PS2Y6SW9pt8R/bHVtWyerCGsCURy5Hswfk08RChul61V3G/d/jBwyGsUV3/2h0jIl0XIeKkUbgD2uYQqUHdOBaHtDsEAknAb5wP8+Z428qR3i69emRk9cPvEi324OK/69pI0jv7XEZDiiwtl7HFNm95OYd88v7AK+eH6+p1jqw+dzgnYMjbEzWS8aHZwYPGcyhlDcyqyToFtyrajVUFOwDMLNcK5eBuf79mGqwb3jRWdNkBuWBc70qfmfKrhq6K5D+dI3LXWukKLRUeJ6tSWiJ5wTRv7yiW23avuKbDClpEEt4ZABHKWQApt1U7lKZQcumSXlHVW/XRlcbH9fSdLRcY4BX8EvFx8Aiqb3f0wZ66HXjDLPeTgsuAb1a8cdYJvPAKofYglSQcUiIRN1YfgQAEv1ApivoJQsaBYGv31HxlyB6kn2xR0JDP+k/EqEjn9VGnOhqOzAECMlNYOZRy3CrLYPoihUoC7suFCFpz1R+PTgNyHYKK1GciGTGcuO6QxOyT96OueXjkvBUizeQwM/3+JnRgrxs6WwzY3uS4R28vtaLNxmtKTs4oM23tGUzXyhk+BTRoDgZKTjtSXk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
index 4eb7e75a7473f..7aad097ffd392 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -117,7 +117,7 @@ description:
       x86 includes both i386 and x86_64.
 
   Type:
-      system, vm, or vcpu.
+      system, vm, vcpu or guest_memfd.
 
   Parameters:
       what parameters are accepted by the ioctl.
@@ -6393,6 +6393,8 @@ S390:
 Returns -EINVAL if the VM has the KVM_VM_S390_UCONTROL flag set.
 Returns -EINVAL if called on a protected VM.
 
+.. _KVM_SET_MEMORY_ATTRIBUTES:
+
 4.141 KVM_SET_MEMORY_ATTRIBUTES
 -------------------------------
 
@@ -6586,6 +6588,65 @@ KVM_S390_KEYOP_SSKE
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
index 9fc8dfdfd65ff..ccbf7c475ec29 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -998,6 +998,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_S390_VSIE_ESAMODE 248
 #define KVM_CAP_S390_HPAGE_2G 249
 #define KVM_CAP_ARM_PMU_V3_STRICT 250
+#define KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES 251
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1650,6 +1651,20 @@ struct kvm_memory_attributes {
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
index ab29e7f555787..2987611587b18 100644
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
2.55.0.887.g758fc8c411-goog


