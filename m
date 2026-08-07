Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6CDEC5AD05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:54:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4731C6B00D0; Fri,  7 Aug 2026 17:53:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43B446B00D1; Fri,  7 Aug 2026 17:53:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3123D6B00D2; Fri,  7 Aug 2026 17:53:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 015D46B00D0
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:52:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8AF291601ED
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:59 +0000 (UTC)
X-FDA: 85075824078.07.3797531
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9E4F81C000A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gt6Wl9w2;
	spf=pass (imf20.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139577;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rw+wRPCiwa/pg05XyB3hfvhvrgFuegq2xzR59ITFeG0=;
	b=4ZwAl5ZoeTQ+I4Uwpxm+xgtXcWhORtHWM/kyuhfVW0GQLZDURlbzxt3SxoTBHinOPZ6pEo
	NG9h8nLoTeMNuz+LG/PlONC2coPp5T1oL7rG/h740oelnTk2RBMlYTTMPGaPM4ebiol2/Z
	732nSoNUfdbdYxIy8wK+xpN7WLKOZVk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gt6Wl9w2;
	spf=pass (imf20.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139577;
	b=nV5urxcdTcBHJ8eQmL3R2GthuKrGW0WXgMSLQKr+uQEVbTG53XbB9m79F+dI2/0uXzsi7M
	SYGBaOCTSamC1zbg4AqV7mAwaFWBCHnn85pUQzIBAcoyLcR96Lm60QBBRAamaT4LMgJNQm
	oRoJQBOI5urAW4shPzP8Zc2UpTlcXCA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EFB194411A;
	Fri,  7 Aug 2026 21:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C643CC19425;
	Fri,  7 Aug 2026 21:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139569;
	bh=0BBukiFYZw1FttDXc9H2e2gVciDX2jiZZXVLVKwsPdk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=gt6Wl9w2IuXhqUGozOXk2jcbHR09hnfkr0y3OFMoXrkXeeZyfzbor7C117mv3Yomn
	 PVuK+LUlmmWW6UHavq7uvHVf3AGuOH04G1mRYkpIl7g3ksq5w6hk4dnrM9B2wNgho/
	 a55Fb99ZxLLKGj9kq/VbUzE5neikp+nIH2tFzZ7TOR7rR2Qwau99NzAxZpIALyxsFx
	 bbcQ7HcAvp1Oks23mKkZRDPmIs2wGj3bhzySbaEyLnqHVOyle2Hzc0Iyk7mGYOhecN
	 a2hv/DXSYprq4KqkexgptEVIDTWFQ+RpxqlHeWe1pbBVuvpPb4VCx0siLYjnhHRmXN
	 P1MfpmYIU2pNQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE06CC5ACD1;
	Fri,  7 Aug 2026 21:52:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:52:59 -0700
Subject: [PATCH v10 20/41] KVM: Let userspace disable per-VM mem
 attributes, enable per-gmem attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-20-2fc18ee6d3ba@google.com>
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
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Xiaoyao Li <xiaoyao.li@intel.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=4464;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=DoOtiRr7PnjV3LVVxFaOZZNnOLaNAPiMfDiZIxCzkgc=;
 b=Vfxzcm0J8wZo+2z2ujIp3YnjboO5emv008lB7aJpQWlGiySzlzdGEAqelqa/H8mdYT/D9qdiW
 VG45PMlv4p4CnBac1/f0encu/BwvslI9Yq/1DE6Rx8Lne4gYrOlqoq2
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9E4F81C000A
X-Stat-Signature: gm1jm1qweybbphiocgs9gxixk1z66nhe
X-HE-Tag: 1786139577-819178
X-HE-Meta: U2FsdGVkX185yIokbGxP5ACYeUjqO5lpBPJIYZQj/wPH6fGCut/BHq7xC/5BeTe2L9irLsIkaNeuNxX5JSyTXhfw5aAV7vYRvTy6NAiuBDzhIfv21RhZrly8zFQqw9oXD8kyEE0vlnE8lHPtgpFHxJ2svwz0asYg6pNGBpxAkdSMljnfX0KGe0KywB3X9wQ+H4T0i7e0ePTaWH+joLycImB0SKTltWB7T0UXfo0Fud+OxgAnAuJ0xhg9I7fxPCIqb2qvqz9i7DFAJAOkc0TgegDzChdAi7mIe4HS5gSodWYbgXgTRw2WV/t2IzsNaBy7E6iJRr3kxinfUdsA9LBW5Y91c/SSaxjK2wS33zcqBxnaAsfpGFisY77goJ7QJFn5A3q4Wr8NdgKC9Iww5fqB8N/yrJQGF/LHiJPPVlMLYb7ghV/0SZbdZvF4ZVH8QQ9USvzRRA+cgatny4fwe1vH7twH4xwpXJKfwO/204SIXBwM/xNUNkwB4lUCIQv76X+CGvYf+7PtIBdHVlReJ+CvrbRZF5QzmTuuMbWy3zgke9wCqFlsYkQEHMMnYj7QT9sEEzZDjChUC5ux/3dBHrKSp+8CetdggmQarXetQm6us6DJ1bAeuwRkkGaQoulGPh3FuX2BFG+AlPzKB7B0Sostb+N5q0bMjT8Cuoy1PhQcvIyKTQxKrQFNRWBnBvkFsk9OuUvkTgKVGWFeblus9MGH7JpMn4oAvBRPo2OOMyGubk5hIyVDDhLlf/3EDdrpujgkDrltl0QdB2KMaaUEqmztkTxwV+AjkazZfD+0X8ckmjL4rtQCY0K3W9yug67sMx2bnVksuyrqF27OD1il/+2yZlU6ddx4aGPjcYT+h6B+K+KsWLc4+oQgZiiwsSFlj7/lw4YuYyBEcKDamDVs5ptUoPy+MTqY/j1FC4G9vwHmaDAdAsdP/lMqJrmLfVwJOQAfqzr8TXWyjByyqjWli+j
 85LvGdYd
 iCH/CULLW8aW16p226KZWGhybQ8mVb7bD9wWr22vpaRPVknnz3855G3U3K3mFDkQBSkVjdN16m0hBzw7Uz6dQ4z3+gXMYCfgb7zgxlroa+n7VKQlOxhwA18XUi3Atx+BGZRjrhSPlv7tNZjYZNXQNlqBIx/yuKhwumrHwnBR+/KXJWEOepv81fUcyib9HJboxBnr2l9ZO+8WzYzz1ctpy+ypJQFxycDbZPkySICrtNRG+T/k9PJ4j88qksoCB7IWcf0v0HXmHptPc0uF7TTGnsQQdNs7jhC6gRMjdjw/+KS4nYBuTwbMjqAOmVzuMhSydHuTv5fj59vjPzjjTGzgfXiFmXvaqnQ83OPET9u3kThoUmpWXW1jR16O7MjNXWCSuJWw95MGz80tCA4IuvOwuexnNW3TJYJRIbgS73hTQUQ3g+swACgNBgNAlhiOVTJ0I85Pvce24bZad6q8T454ZqeDjBR7tiKlNSMFJqEbsA8OSxefXzGmvQ5kupUwPIbnYcqZTnUxVokt7vrUW5SKIOIrKdcMfE1n84Wgt
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
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/include/asm/kvm_host.h |  4 +++-
 arch/x86/kvm/Kconfig            | 14 ++++++++++----
 virt/kvm/kvm_main.c             |  5 ++++-
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 497da6aaf2942..bb2c1ade62cf9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1851,7 +1851,9 @@ enum kvm_intr_type {
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
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c8faf1cb82167..85dfc3f5af805 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -103,7 +103,10 @@ static bool __ro_after_init allow_unsafe_mappings;
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
2.55.0.654.g21b8a5bc05-goog



