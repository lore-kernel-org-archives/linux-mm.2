Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4265AFF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:32:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC0C36B00EE; Tue, 28 Apr 2026 19:32:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A99696B00F0; Tue, 28 Apr 2026 19:32:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 912E36B00F2; Tue, 28 Apr 2026 19:32:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 808EC6B00EE
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:32:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5F477120812
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:27 +0000 (UTC)
X-FDA: 84709548294.20.70AACCE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 340AE20011
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="V0uomQ/J";
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418725;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0AX6T6Mp9zS3fuBkqsxrNSP4pUqkMtrdTihjuB/xtR4=;
	b=LY+MkMovTvT1GqYbQ2Ad7EfXyEWZ97mwdbSXMhKKVx1Xx98ET74SKDci9ZhplQXbXOfHYV
	xn7L08ajClMJCxDVQfiGPcYuNQeeBpAhwRZBncJY4sFu37SL9tWytZ/mFC3jk2nUj6lVGy
	SQWz+MY6OUGiaLu5Uhn8hLVFEmjNhxo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="V0uomQ/J";
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418725; a=rsa-sha256;
	cv=none;
	b=wk0JhKzhJUnvNEZ1GAE0nnyPGQRINp7RelyfC1BwMnj1oVcgcRD3GQnjx59Y8IvZV2u8k7
	yFoHB+StReBdsjVxNYc63L6rEvu7owbYXFiWGVEYIhbYzkSh1E/s71Bo09Swcm9qtYm8MN
	0khQntuRT4Rz9ZoC7/Mu4qH01ozsuOQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A43BC449AE;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C2D9C2BD01;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418718;
	bh=EtJm+CLHgfPNJ6px7UjasKC7l622h0ZRyjwTXKMOX3U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=V0uomQ/JhXw4yLeGGkngDAxO9P1PdPYD5S2rvZgBxDozaBwEU5jlsmcgi0oHuIiiB
	 G3cHpbjENBALSoK9vtkCfN+PHivZM0Q4SZnEqVTQw9Se9P0H2uA6rkVSAlhaEftBe+
	 IDyjZIDvLnzqh/da7Qd361zA1wWuIR2swCq+p63hShGpbmqqt4PCV6HH0nYQrYADPH
	 EORNEFG9OId32q0zryQGAyAPJlA+2q7guU3XaHfLLBf9uQro5vApXrJkbN6YF6w+Id
	 73ZiY/nO4jipWo64F06FhMBxznQkzDXM7ewv32PGWQSlOhQEQ33veOMMBsXCQuF4fr
	 1m7fks716ZrzA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39D50FF887C;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:09 -0700
Subject: [PATCH RFC v5 14/53] KVM: guest_memfd: Advertise
 KVM_SET_MEMORY_ATTRIBUTES2 ioctl
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-14-d8608ccfca22@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=5936;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=tu+JlRkYHR1IXTuUBVoULvQy7xjaIDUUYI8NTjhnxms=;
 b=mrTIaTLDrZxGt/EbqQxPyT5JpCnDYB9pIjvwlVNRpC1BZCmqzBP+bFEx8nXGN2ewa9bJYCDE6
 sNYXWkfdQ3/C3Lhmox9HSJZgUHo4eLbBzOaJeyyyVidANnKH7vvxFAF
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 340AE20011
X-Rspamd-Server: rspam06
X-Stat-Signature: dimhzm4zx8oqpy1rhgx3bfp39isoc1dc
X-HE-Tag: 1777418725-959574
X-HE-Meta: U2FsdGVkX1+umvM2lStO+0KfYv3Ql3iwWCwk+tsktQtAqypONWhIIRhOaXXqWeDtDnFpO8O4YvmaMJ/pV2u68WbUJwbGhGF4KsmZvc3E4RCyeUBEPensakqInJw7fwGmXUqaphTG0pNkEUfIccvUZGGpgKCxts4ch4KB3jsOo9kvRvWdZKi1nldoy9EAiUR0YqV091RyQ4qAp2sehVRVVqE5J45GPq8PlrLe8Eq0UCOR48Su3PG44SR/KCdW2uQMmn8QDsHCnrNLF9yXtLQXxKPVDvGOT+UCCk8OxaXSWyTcPzNsIYvYkdtig3V2W4C8DSr4YeY0B6I7suP2ylhgG/M0vqOc4ustmb5bL7D+cjgQVNleKgztwVYTNH5jcPkB/p/tn2EjHzbMzZ1UnbxpKtw360q2p+941m+SVtC2lz5Y2noUkytS4IT28MH+K7HB+bakkXGNZ4bytjz7wSdLJjQuqAcVrNasSFO1DlT9jhpee3Fmp8SDDnZ4n/oLuBKPJB0o1+Rqtu8csMzhQUJEobhRCrtx1YnWIlZePSsEljCgmODawZf1dFehcXB15cmpAJUhCh4FXTJUOZELeLy7oSw3W6VU0wCm7PAObBaBDtOctpdlzEN3ewnHAhQ3Avi/OMnAAuHGvmWRGNSe9uIWZzklMJYR1OEeFn1z198qHdH+5tqxpuTGEVS4x52GvQFPw4lwv9DP+S8pKZAeFiYpR7PRum/FCR1hO0QgSCDutCo3dItpr1DVqBo5FMeSasDepPTX3zzKiVyPbgE4o41yS5a5Ve36cfY9TovcdtIRBWutEjYoURzmlTSawzv5oZ/n9BAIUhk+d9Tpo7fg8NcUdPB17vA7gJk5ZT8/SbXKjc6P4NsnRpffGxCKlj4ANpOfGpHB8NLfjNWG6slcxtf9GCEsIOLjNnsQipIQZiXqrTLBAQsy8kCW7DQUZUQxmaTgDCVU8R2snXZapCj+HdM
 iziHdoz9
 pkXp1W+AImRFAdcF/7cbl74F/6h3TuyLqKINAR5jM1YQ4oBAZXgnMJ/ISMe2UKCknSk+YPIzEBcKVVkfJiHxDWkhcIiCVN3nIjQcguO0/OnUPlKxXO15E9Ugy2ddgxPKMbbW5R5BL9hAzpoKjUV5zlOjMwSmwlLYSt1cpIJYIiMSC6feenm6cWfP/fJ+hoEtxCBRtr5tdx/CFC6KtvUtH+SWmpFpD9uTbsCy7TaaEXdOJf2jT5X27mJJxP1DQA98M6irz79HqRP1MLMeAvhm1GNMSfEzWFfjL6IncGKsi3P4ozShPM0Hk1rQs4+W66hW4qVHY4VDS/AvCepV/BlRpIgG5gmrV8CkJn0BuMOPJYR3+qq8UUksVNhxL04chgZXMPrDEGKIJGWJEXI1NlvhwPwpCMXzblZFDgnZj+yK4n4qHB7OsM6bgFt/U1vIkDGKmQ+Pp/+sPIdrD+rvB0CvXu7qGYEAaTvnrYvCqecQNjswx/Ms=
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
 Documentation/virt/kvm/api.rst | 72 +++++++++++++++++++++++++++++++++++++++++-
 include/uapi/linux/kvm.h       |  2 ++
 virt/kvm/kvm_main.c            |  5 +++
 3 files changed, 78 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 52bbbb553ce10..6ce10c8ddb634 100644
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
 
@@ -6553,6 +6555,74 @@ KVM_S390_KEYOP_SSKE
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
2.54.0.545.g6539524ca2-goog



