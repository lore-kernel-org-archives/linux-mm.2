Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F98EC53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:36:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D0286B00AE; Tue, 28 Jul 2026 20:35:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9328D6B00B2; Tue, 28 Jul 2026 20:35:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 784A96B00B0; Tue, 28 Jul 2026 20:35:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55D3A6B00AF
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:19 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E55EC804DF
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:18 +0000 (UTC)
X-FDA: 85039945116.05.32DBD81
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id E22554000F
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JwkYE0x7;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285317;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s3A0R8+xlrqNE8V1drJRvgfglgvHuesw5Ol+ome0+ok=;
	b=56Fh7bO2yk5ucZ+HCpRTskXekuQrwytiQmdAM132iPTpMdyA6uBVG9m+mXWKDx6n/6Wgj3
	HPPzRdwSHnSyquhqYf98DnukEnVz/tKbYYItncPzQTm57JZVIBKxSN+FpCQkCf3nxz+3bZ
	5XAD+GCYuzovtMFgOLPKTZFOBguYqr0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JwkYE0x7;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285317;
	b=0a2YzUveOQ9EXTq/YyaP/aDNXg6javEjTWwMywAtHrmBpgBB3+V28kReOgFdH7hy3SE23k
	Jo9pK1rdAf/aZ2XfsiLQF3AKj4pJ4ABAaG0re50vFg4F5/LJ5yCBM9NOdFFm8I+TvivxHA
	DTZ8kfG+VsVfEuvvsbPzvvKQkV++LFM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DC2E94521A;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7075AC4AF17;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285309;
	bh=tNFfj7HKCSxJeInTC/zEHc2dsIkx8GsgzpMLBDYKTnY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=JwkYE0x721Red39uEGsDeFSP+NTa/SYsEMZOtrgi2thcF4xKLuv/H6kK4kWf4K+XI
	 /wdnDjTOKC6brBOXd2vjwCHaTolxk1DGhq+K1BfO74NHSLZGGI7vrXDK9Kg1LO2zC3
	 P+cuYfTMofKQ7K6FRp5d5tZXk/Nqb85BCP+aBqgRlXY/AWGJqo1wfelVuZfvRFarp0
	 f9Q9H3+L2hYreQo56sT+0dyvyn0BGq5Cr0EoAu3EQHtZjXxLiCdimkcg1UDiGRh+Fn
	 BOmxZvcOqEEUxmqoNZe/3rFA+1s6GuW1sTB92IEdIujeB0mVMidq7vGF7fRi5v1V3c
	 zIAuu/ON2U6Mg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52BA3C54F5B;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:19 -0700
Subject: [PATCH v9 20/41] KVM: Let userspace disable per-VM mem attributes,
 enable per-gmem attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-20-35f9aec2aed2@google.com>
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
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Xiaoyao Li <xiaoyao.li@intel.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=5114;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=i9uAfiNmy+fR2/nSbMWYj8h/tKs0KpjlMc4SWO+igBQ=;
 b=Jp9jaRTlyEWoYw/luEJpOI6Gtx9aHHf9dNjacIcg/ikbH1QCw4DSvjYzqrmuQGSUj7nzVnr0Y
 sQTjlW4b7lRDkXbwLlCdxu26SY2rdl7ZG7cP04jAUhrcOqZFR5PDl+k
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E22554000F
X-Stat-Signature: bgbd3p8umqhjmuqibrbnhpeahr56ufw1
X-HE-Tag: 1785285316-137570
X-HE-Meta: U2FsdGVkX1+T4eKd5rblyrohm7tz4VmztgHcz9pxjBcYpiZQ8Fvf48KguJRG/4YpLpaGiD4ipN4P5YKMgeCURD8+VQH1ro7Ppd4eqz0WDC5CvUQTsDCLxD9PofSS4LDIVI9+oiR/Tgb441SHDUB6ht/SBnf1Sp8NSeuAFAwaAIAVhI376sdNFUr0u4ig8XJtCIhN8wPC8xHztjLiiT7e/Nkj9nWGIxzST/dFii8synv9vl0P3nTMdDMSsdmBqfZ2GpUnEqZ2mKhDFlNTcuPxdCCJ1jJ638HVXr5a99fuFxyigsdjRH6WXqJ+BZLy0FyNEm+ZwgL5t6TgP1goSTZ71Mb8trEUhOukQUAEgYnEPEA0IHZmkQlEDXG7quyTtYuB8L3iHTVZFbDXiQHnRtmA1vNoUkCYDgf+ckBTDCOtQ0S9JGjI7rfYWS4YxtaTcQJWIovZdvJOOyxx51Xo7yYUdxi8ds5vK07e3DPMM3mX8PWRUGq4HlfLwtbuXclFZSXVz3ezCIMm9hLQmnAPJAzy5Y9ikAzT7pgsYdolZfkh7iS2q/rHPGi56QkxoB0EvsElR+y7vIPXeb7p6dEpayS3JKSjo/p9OzWC/nPqjQFpc84k10rYmM3L1JbD3dsf93ChLp0sJJetvutr/7Q52V1uwJ0SWr2yLJ/ndWiOXTUp/IXUstlSF2c7FWzHiS7GVdJDLhKWoxAhrbexGpjxvUfMeoHK8acRCAgeaga29j8Zt8ihJ4Ig5zgBv5yKZYK6gbh4Tkl5RSo1luH9bOTvg2FEOXYZeF0pWQkFTrVWWVwGpceEVxZEzORs9Kkz43VKTgxILB92sVhvA5uIg8/Cd3l6zjOkE6DXw1Z/w7PqkdhlbyYIBYGFNucrD9DOxoxoJHghlZn6lmY5ZTCKUqEJdQq0zvaMSVqk+xHc6A2zjckxfBPlyZU7SQDkzsjgMKFuD6GCHfDZp7Ha9QqEMXJxx9O
 3uyq/BjH
 jSouWYv34bspZ5Ap3t2U0jcBN+JZcADOSKZFKau/yRXKXf8lLfk8SCJi1jNc1DLmf+yRMnydiX+cLEMf7/bjGZ/wGiIAYmNixnGcZo3kH6+iTytEAF9E9C3yJtcSopkFgXV1oHJhN7B3AesPL7HsIWb1Xmv8dbIxQQVQrZn5IjouvmQqEKuYC3AVcQw/PGmCddPaZ/zxjyS5OmfmpXD3V1KjQ4TxQTWL3yz2fNYUTlqfBMgzuLNyap0NQjcEJqDwpii8YGU94a0iLYiYH9tmx7UAv7hUuXTdLjAECPN5JGN5z7R5qzvimgkV5W454VxQMuenfrbBcoBQd6oWD7ztl2nhUIhWJkItmtRt136HEz/Rt+l5CfCMOrXGrGw6UNuernV5pONmXZevTxG2g2fZEH58VjFQwTHt/eBu7yNkvxMhIqU/6JHO+FcZqDXQNWI+vvfv4oWcBxFo8KGLs/EYpXmzBb6kZmhwpgQhhk2gdAzgX66pUhuVJCKEjL7L0MuITDySa57jhvG5lZ08y8toOpg1c5BcO+4k8lKTh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Make gmem_in_place_conversion a module parameter so that userspace can
configure enable or disable the use of VM-level memory attributes. The
module parameter is only available if CONFIG_KVM_VM_MEMORY_ATTRIBUTES is
enabled.

To avoid inconsistencies in the way memory attributes are tracked in KVM
and guest_memfd, the vm_memory_attributes module_param is made
read-only (0444).

Since selecting CONFIG_KVM_VM_MEMORY_ATTRIBUTES disables in-place
conversion, actually make CONFIG_KVM_VM_MEMORY_ATTRIBUTES selectable. Make
the config only selectable for (CoCo) VM types that might use
vm_memory_attributes.

Since memory attributes are trackable in guest_memfd, the concept of having
private memory is no longer dependent on
CONFIG_KVM_VM_MEMORY_ATTRIBUTES. Define kvm_arch_has_private_mem() based on
platform config, so that having private memory is dependent on (CoCo) VM
type.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
[Define module_param only if CONFIG_KVM_VM_MEMORY_ATTRIBUTES is enabled]
Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/include/asm/kvm_host.h |  4 +++-
 arch/x86/kvm/Kconfig            | 14 ++++++++++----
 virt/kvm/guest_memfd.c          |  2 ++
 virt/kvm/kvm_main.c             |  5 ++++-
 4 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ceb2abf43b76f..766eb094eaae6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1849,7 +1849,9 @@ enum kvm_intr_type {
 	((vcpu) && (vcpu)->arch.handling_intr_from_guest && \
 	 (!!in_nmi() == ((vcpu)->arch.handling_intr_from_guest == KVM_HANDLING_NMI)))
 
-#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+#if defined(CONFIG_KVM_SW_PROTECTED_VM) ||	\
+    defined(CONFIG_KVM_INTEL_TDX) ||		\
+    defined(CONFIG_KVM_AMD_SEV)
 #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
 #endif
 
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index abb108886733a..2c3c22aeafa54 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -81,13 +81,21 @@ config KVM_WERROR
 	  If in doubt, say "N".
 
 config KVM_VM_MEMORY_ATTRIBUTES
-	bool
+	bool "Enable per-VM PRIVATE vs. SHARED attributes (for CoCo VMs)"
+	depends on KVM_SW_PROTECTED_VM || KVM_INTEL_TDX || KVM_AMD_SEV
+	help
+	  Enable support for tracking PRIVATE vs. SHARED memory using per-VM
+	  memory attributes.  Using per-VM attributes is deprecated in favor of
+	  tracking PRIVATE state in guest_memfd.  Select this if you need to run
+	  CoCo VMs using a VMM that doesn't support guest_memfd memory
+	  attributes.
+
+	  If unsure, say N.
 
 config KVM_SW_PROTECTED_VM
 	bool "Enable support for KVM software-protected VMs"
 	depends on EXPERT
 	depends on KVM_X86 && X86_64
-	select KVM_VM_MEMORY_ATTRIBUTES
 	help
 	  Enable support for KVM software-protected VMs.  Currently, software-
 	  protected VMs are purely a development and testing vehicle for
@@ -138,7 +146,6 @@ config KVM_INTEL_TDX
 	bool "Intel Trust Domain Extensions (TDX) support"
 	default y
 	depends on INTEL_TDX_HOST
-	select KVM_VM_MEMORY_ATTRIBUTES
 	select HAVE_KVM_ARCH_GMEM_POPULATE
 	help
 	  Provides support for launching Intel Trust Domain Extensions (TDX)
@@ -162,7 +169,6 @@ config KVM_AMD_SEV
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
 	select ARCH_HAS_CC_PLATFORM
-	select KVM_VM_MEMORY_ATTRIBUTES
 	select HAVE_KVM_ARCH_GMEM_CONVERT
 	select HAVE_KVM_ARCH_GMEM_RECLAIM
 	select HAVE_KVM_ARCH_GMEM_INVALIDATE
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index ea2752989f8bd..df67a6188aa99 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1137,10 +1137,12 @@ static bool kvm_range_is_private(struct file *file, pgoff_t index,
 {
 	struct inode *inode = file_inode(file);
 
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 	if (!gmem_in_place_conversion)
 		return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
 							  KVM_MEMORY_ATTRIBUTE_PRIVATE,
 							  KVM_MEMORY_ATTRIBUTE_PRIVATE);
+#endif
 
 	return kvm_gmem_range_has_attributes(inode, index, nr_pages,
 					     KVM_MEMORY_ATTRIBUTE_PRIVATE);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e961cc297ba2a..eb9f433278d2f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -102,7 +102,10 @@ static bool __ro_after_init allow_unsafe_mappings;
 module_param(allow_unsafe_mappings, bool, 0444);
 
 #ifdef kvm_arch_has_private_mem
-bool __ro_after_init gmem_in_place_conversion = false;
+bool __ro_after_init gmem_in_place_conversion = !IS_ENABLED(CONFIG_KVM_VM_MEMORY_ATTRIBUTES);
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+module_param(gmem_in_place_conversion, bool, 0444);
+#endif
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(gmem_in_place_conversion);
 #endif
 

-- 
2.55.0.508.g3f0d502094-goog



