Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1312C88E4A
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:57:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 334CF6B00C4; Thu, 10 Sep 2026 19:55:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 305466B00C5; Thu, 10 Sep 2026 19:55:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BCBE6B00C7; Thu, 10 Sep 2026 19:55:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B50EA6B00C4
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3AC4D1C28BD
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:49 +0000 (UTC)
X-FDA: 85199512818.04.0714341
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 274B840002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lkPHukJT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084547;
	b=A+/A58U2y15qKaR16uZPsnaWqPKJx/iWIGLRKiqYHtdRH7sK+t6PrehTYAXpbI+Kv0oHDn
	PY7NCzkG2lHKNnQkDf3ZCmfN9EinbknwhStZmRBfPaXTgzAOfw81YLztmYP7YsRBXlkgX5
	QVx/qt74m8w8+megbOeMFlG3KdjoQqQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lkPHukJT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084547;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aW5iCQzFKREaNiwADjkwbKzEHXY41n0UC7vmv1dKbsc=;
	b=eNQ0VZqfbOWUkxcEaUsmOSsDF3vAk8ZT1O9CDKHvNXfvmd7TX6dI3HLpWaWilbtmH5N3Z3
	Fkc6yWkM5io/2xzDbBYc337Ul6DpFrupiQbyLiYMR2MmRmnH4bdmseYcMRqzD2D9Xz2ymw
	5+LzgSLQizw82o2bSCbY3J48k9y6eSQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2AABB447F5;
	Thu, 10 Sep 2026 23:55:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 01784C2BCF5;
	Thu, 10 Sep 2026 23:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084539;
	bh=6C2augXz8GBviFeBgLjwH0PLN0m7BtLjKuqfJSUI3Sg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=lkPHukJTePkrsSRwNhKmBl4cswbb3CW4KnifSAredV+Mn7VDFVYRMEkHd6GfTPYe+
	 cp1Ru3lsfzKrPwhV7tKERbL5YUdPpzrE7szxdKUlkBZyfHOADcpJE7xRxuOIK0cRMx
	 XSAWovDNi6eWZ54/FzicoKj4TKF5V+eZovgYJWUlpphc2jvoJsSC9BrnHn5aPc4OQ8
	 8VsUTIW6ExB87pfU7dqWDMFXuqPaSaPWlZtLvoTNGX35FQzQvNCdbWbj24+CTA5fve
	 vn90I5EOHZc6vNBp/D3JRlUlIfbA9k13ZbKlvbJ0GZOPPB9ikeIG5+5LV71dvQ3a/2
	 AeoDlulLdQ0CQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9650C88E49;
	Thu, 10 Sep 2026 23:55:38 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:55:48 -0700
Subject: [PATCH v13 22/44] KVM: Let userspace disable per-VM mem
 attributes, enable per-gmem attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-22-dd6fbf94f4e1@google.com>
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
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Xiaoyao Li <xiaoyao.li@intel.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=6402;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=70iSyqg/mTnfLo3ttGKfAuj6ZuDf0WvNDgZDQmBtTdY=;
 b=l0+VuLVeyBboOwY8llw8NkrAe9rbHoo2o6bold91sNzbU5b1vsR/hdAaVMYrZry5krqMlg8cB
 4ls/eREGlIgDSuswWQVkA2pydIkxiUgbhsRQzzmuv2GL/nGUCYv2Qpa
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 274B840002
X-Stat-Signature: 4gm14y7oc6pdwcwy6diwhsedescspw8j
X-HE-Tag: 1789084547-202891
X-HE-Meta: U2FsdGVkX18rXLax8NWnopOsL2t8rsDH+k/nRNqtjYxvFN5fsoiukcExygZKy//xH1Nr257OsrZ/Qzii8pITfY0Pj+8BmcHhulXXYHnEAI+yX6OgFdut52Q+Oeo+Y8arEBIw0A3pOxp0a3FOqI+OlIivsdXj6CcgbEPDj2qlrw+FpYV9p6CyBQ81rtu4PWjXDZsGFZdSrntFd6SgY3v5dRQRaIm5wEKU54g1HRmSabMSE+VMWC77YvJNxwSRoY4EQLpISRNQYRk6KsyOCLhHDabyA9XMmswijWV+CO+A+Ex/2kPuIEukwAFFc08zn/8/caa1XiAiwnrYwB7t3or7j4cXmvY8j0GE+AVpUZbcP6Vj3g9sOwjFC0uz3REt8Qgst3pibrvtOptL1B7ezlSu2zGAUpxWLdJaJivcHR28p8nvVedpcuF3JgkEUu6PnMHg6uZG/S36tZpJcmH3vDM/k9imtlc18Wnf2spMkp9kdFjpkGB4C3ohqnh5wGSmE5yNtEZ+VDPAUszM81qRmDCVsMjNctr6Q0QE5w0kksS/HTEHtVRODGZY3Q9bqbiEbBjzcuGdfnCL8FYZMdg42Th85tqEXTLoQNgOGZZJqJUS6B69+W0Oug0MTUBL1ZBBo4KA4XDR7Mhnp/77i7wu2+P0EffbsHX9N1NXmbD1ColtFZXZ+shLhd3IJ5DoEJ932o0A1nDUaWGlvXPQ/Ql4wIfgbtiK9W1vNA4+zaLNjBBS6zA29pSvIyYnsJzcEHsTb4lCloVvht/isnKXxmeq4jemm/Xp1gDsyyNWBwlrnF61bMfRWQEcZ3YZRmDzkT/3m3GAOAinHPbv8fF57wPIHug7xgv+x7WfMQYk+UGgkAOeRDlnRYxOX+/kZXngB3jsNFh/uZPi2MPpc0mNK7OiXdKrwwyTF4keBpVJIOrgk61sLOBKpKgWYFR39TpIspgeCAu5Q4aiW/lV1aufq9+OQLA
 CBxNNW7j
 G0NpU+PFxJYNK8IWzZclzRM4koaeH0iYYtP3UyH3rzDnMtoejw40vaa6yowMOe2V4+vvgjIdZIZIoCRkBJTxvyBr4WYQ8q7crAyOXTu1Fv46WfgflKDnciGdw628/22Qy8tIgthdwSxS01M9AdDcaz/4Dj2K3Y+NI7GksYFDwDT8JnCNVRI/6Q5oPvx3HlIUiXhfq4Ei2yIKf46HzJVyAUcDxt3wFCZKgMHObsFRzlAHlh0AbevZaPQVHdTj8oDKoDMh+/VyjJRtm5YF1Gml09UzmwqNqFhANI3GMTa/IU82ULksvvwuEYuiJ6cWAuwyMfRebEdQ1EI/J6WW3VwKvsdon0HqM9aH+0MR4lM9KSpMCA7qnV2wDbWzTi28ni0WeK+VFOmSVlljHDR+I0D5k1UJ91d5ULd6TPxqMuZqVdcl6YFOQHSHjwOCdbR91Ql5vUk7YIaMiBOM1LYKBDy5fQwekhb7JoXS2U3iP2GBef5EVlCQ=
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

[ Xiaoyao: Define module_param only if CONFIG_KVM_VM_MEMORY_ATTRIBUTES is enabled ]

Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt | 25 +++++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h                 |  4 +++-
 arch/x86/kvm/Kconfig                            | 14 ++++++++++----
 virt/kvm/kvm_main.c                             |  5 ++++-
 4 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 68647ff4bdd24..a6d7a8109aa79 100644
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
+			Default is N (off).
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
2.55.0.1007.g17ff1f9808-goog



