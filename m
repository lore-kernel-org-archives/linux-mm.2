Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38200C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:27:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 472966B00B0; Sun, 30 Aug 2026 20:25:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B0E56B00B1; Sun, 30 Aug 2026 20:25:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C6886B00B2; Sun, 30 Aug 2026 20:25:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E29D36B00B0
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 73D7B1A03CA
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:34 +0000 (UTC)
X-FDA: 85159670988.23.99156C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5FD1D140011
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tc9DM2S5;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135932;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tL+apDV5OOCcUOReanV5SoYo0m20rKe7FfjrBV4mR2Y=;
	b=MAIhhTexcsSkw9/fFUrhP1q+O38C1q7FGOHpDLreOxThhcMLlzaNwL1I5RjfOTiepJ8ok5
	YW3wyTDQiZ07++/AcA3btc9PD2OR9f0lzQFgIryWoHBd8vX85KLzTwDnn/utZKABgGkNo6
	fDChUqBIm7U9ZVMy0lRRE145FjTL860=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135932;
	b=VtdoGW1z3VxeS0k/EdSEWwsC0IQiv8ItwGeWw9qlGbDxNYLPw7x08Pe8AvbfmwnrQ41uUG
	BVLmf1AjB9wori0Zg5XntnHbmfy7uqT4eUrQIZOucu99avH3dpzOmVKdn45ZUicBN4iFJ4
	SNsoVhI8gbfCM2PjF+s4wHbemzKNGP4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tc9DM2S5;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 20C1443D66;
	Mon, 31 Aug 2026 00:25:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E8B95C2BD01;
	Mon, 31 Aug 2026 00:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135922;
	bh=Jk3hQh/dQvi3kinnKRipbnhcqE0PyTzUVBPn1RaGePE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=tc9DM2S5D2KC1Yu+K7xad+A7iSIAElAS9BQnsvItf6AAny794pBXcQuvwNvYSB1Sg
	 9hwbIoUqjRWg89wsw/Oev72GS7fmJ9BaTWENcJgWa6Q2rK69UcugMOtqG89RT1G3zO
	 j5RROR/v06cgzuJwspQsPM2juEyMXHi8WZ4G0Fh1akLoESAM3U97FQg06JlosIKq9Z
	 /9yFPyljxkrE+f2W/twr4eR5ltGvKzoHV075DojZVCK+vJKQL63ayxU+Rf4freWJee
	 WcjK4R5CnGkJpY71o086Kbn9VIO6XaD0LJdFaDlsRq3ZCJ31JDEH9A8Xr9GzcpUsDd
	 knaPNOou/W5cA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0A18C61DFF;
	Mon, 31 Aug 2026 00:25:21 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:24 -0700
Subject: [PATCH v12 23/45] KVM: Let userspace disable per-VM mem
 attributes, enable per-gmem attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-23-85e5fd25252a@google.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
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
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Xiaoyao Li <xiaoyao.li@intel.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135915; l=6333;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=zFhIN/HOt0ps9ZR1u6TEtlp5GXYBYggvUaVGRCTHweg=;
 b=GIyUxXbjoDLs6v3p+T1cBBqGmOVY5Ujjy4VII5X1UjcqGtJdO7WY7ymJj083LB/jiDvOH8+gL
 2NSh9RmZfhQBYwzFlRqD71nNgRfgxC3FMO5IZobrmqCvvpxiPZKkmCj
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: tasqbnkx6fnwd85ekxpjcjacx6bhedaj
X-Rspamd-Queue-Id: 5FD1D140011
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788135932-343505
X-HE-Meta: U2FsdGVkX19W3kFeJMDiIySc5XYZkb754AAdqNOl4VKC2DUjS2OO3TC07d+Co2voYa6Kwqa2py48ipasgxQvg0t45PALH8y6Nmv5LYwkWzbL0kBGnpY/BtSFJAVqdFckrlkFSggxVYHOh62PS2pRqxKHQhaqJj6LTB7/H1r1xRrUA5SRB//wAqu3H5ULvVmAcPCIcyI3gipdF+PI0oMedy49uRysf76VWBnrstC4qhiHlZEQmMqjL2bA5f5fW1UoATKudUR8PBMbyngYuPdhNgKhsXkO6z9HRfubc8aB2rnAEQXZ4nMhiwD57ti+Auj1N4sKyMn4XfMy5Au05GFM2s8XNTY/wjYsQh0PipQl7vGyWIYEAT0hf7I2AJTm7M+zH4O+OtcMtfi1xAXDKDAYlqjK7rwfyuobneuDSWxE5EZuOH17kcCdezqEGp2K8Ee3XeGBVcslecAKJKzBVTZtf/YsWTrKsvVVuK8/v8vY9Mjat8t0yp+MWHKce1/HBn3J4wBwi4g6uWojwkZgFMsX5Q8jP1Cv5IRMkcj3TWpqDOtcBy/Q207YG3EUZNM79P7bxzvB7x/nUSjv9aVa2b5OPxG8V7odnHM4eMx07fD4+6zBljRRy36gLWikWQOsjYFAzXhxOQje7Ju6gepVka0+0Dp2vW2jL/UaMR6BthYZxcA90qOMAsh+iEb/egNw3Yp6H7feqEFyF5h+YdtzhRUeTGN+I6R3HTZOTTEygpnCix/C8POcK92RPKItlNCQ5EqrWlmmFYIprCTvIhnQzuSA7EoFXGOKJJD8Rpyasm6IYdIPlnbQ7A1WnzYg5g0I4ElzBEFV7Rb0i3uKOfrumoFLp+gZuJ/hipCOIwCJ6IOT4wb8e9REFLUNwvjVE5fBuYjJ4S0UFunziKPkR2rV/D4fsaAvG658p+24+ZuEuBE731HdzLsUYwzumbBwxYs3zmg9CyXvqFIJwOsTpj4gxWj
 7R+6l3mZ
 m3ZA4D4LKPGZ8lj6f3gF3VV9fwR4cgOUC1yQzyVUdApTToCCwj+tuKJzJlurj25Pqi6sKiodtHBdWf9zlfkAbQhpD6Mxn29Zbw6Usk7gmy69pZuNrMU2iDuUtx4nH8r/RtBK2qDgN0IDGUqQ25JBlsR1cBEil0Va5AZn9R1cLWWDFqcTvVe1KtLfw1/P38Cg8xVrhAW0y5PoCPskhJ8CBl05js5mpcOQwvmNIOONN45eN9BQtiU3c0FYCTZNfEhQWAME0R2xbJ09xki563FKwQF9A4UpFV8zIAdn5l9uaENqoKNxqrpZTK5AGCbED60PLB1uC98PxO5UsGMSwWawqGB7H8mkEbmlpqF3dhyKdt/8IvicfVfF3XhulrgnmAv+rlK0Iwj6ihW9CCcTrVT+AUF3laIFK7lY1I9dJNSlfNM+B4hhaXFCUdlwdxMm+Crym+eR0Idg59iaUxcFYp+WwOt/zB7wam19aj+KuWZlRySn8FqZNLYH0KhcwOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Allow the user to disable KVM_VM_MEMORY_ATTRIBUTES even when KVM supports
PRIVATE and SHARED attributes, and expose gmem_in_place_conversion as a
module parameter when per-VM attributes are supported.  I.e. let userspace
enable in-place PRIVATE<=>SHARED conversion of guest_memfd pages.

Provide both a Kconfig option and a (conditional) module param so that
deployments that use a custom kernel can fully disable per-VM tracking,
while not forcing distros to ship two separate kernels in order to provide
backwards compatibility for downstream users.

Don't allow running VMs with mixed tracking for a given instance of KVM,
i.e. disallow toggling the module param after KVM is loaded, as the extra
complexity needed to handle per-VM behavior far outweighs any potential
benefit.  E.g. neither TDX nor SNP supports live migration, so in effect
the requirement is that existing deployments that want to support both the
old and the new models would need to tell their VMM which flavor of
tracking to use.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
[Define module_param only if CONFIG_KVM_VM_MEMORY_ATTRIBUTES is enabled]
Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 25 +++++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h                 |  4 +++-
 arch/x86/kvm/Kconfig                            | 14 ++++++++++----
 virt/kvm/kvm_main.c                             |  5 ++++-
 4 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 68647ff4bdd24..b5719714458fb 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3156,6 +3156,31 @@ Kernel parameters
 	kvm.enable_vmware_backdoor=[KVM] Support VMware backdoor PV interface.
 				   Default is false (don't support).
 
+	kvm.gmem_in_place_conversion=
+			[KVM] Controls whether KVM enables in-place conversion
+			support for guest_memfd and tracks the private/shared
+			state of memory per guest_memfd instead of per VM.
+
+			If enabled, KVM enables the KVM_SET_MEMORY_ATTRIBUTES2
+			ioctl on guest_memfd file descriptors and disables the
+			legacy VM-scoped KVM_SET_MEMORY_ATTRIBUTES ioctl for
+			private memory state tracking. Only the
+			KVM_MEMORY_ATTRIBUTE_PRIVATE attribute moves to
+			per-guest_memfd tracking; other attributes remain
+			per-VM.
+
+			This parameter toggles KVM's in-place conversion
+			capability support. Whether a VMM uses separate backends
+			or out-of-place memory management is determined by
+			userspace VMM design.
+
+			Note, this parameter is only available when
+			CONFIG_KVM_VM_MEMORY_ATTRIBUTES=y. When
+			CONFIG_KVM_VM_MEMORY_ATTRIBUTES is not set, in-place
+			conversion is unconditionally enabled.
+
+			Default is Y (on).
+
 	kvm.nx_huge_pages=
 			[KVM] Controls the software workaround for the
 			X86_BUG_ITLB_MULTIHIT bug.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 83e26ce45fb79..e840418427a1d 100644
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
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
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
index 05c518c9b8078..929fd3e1a01e6 100644
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
2.55.0.897.gb25b4bd76c-goog



