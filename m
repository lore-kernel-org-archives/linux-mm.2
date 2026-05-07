Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21AA4CD37AC
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:23:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 266B96B00A4; Thu,  7 May 2026 16:23:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 132E26B00AA; Thu,  7 May 2026 16:23:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0487B6B00A7; Thu,  7 May 2026 16:22:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D959D6B00A6
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:22:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A553A16063B
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:59 +0000 (UTC)
X-FDA: 84741747678.28.F4267FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id A71C110000A
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U7IE5VMC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185377; a=rsa-sha256;
	cv=none;
	b=33RuGPbIqgyYNYUsUUa9R/iNhTifm0ZhlcqzXIabKYQga8ZhBp6Q/MEzZpeiC+b1j02Sec
	NUqyNTt7/cgU598EldejYsa5zbPHOsLiAlQQffh5k1MNi/gURZAJMuC0PaoGpUGL2XNuR4
	Qib2amuUAtbw0abtmdKlsbfV6R4LSjE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U7IE5VMC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185377;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vhoGviy+UVTc6DGzSNcPYdCQMg7q3HUnA246QAl8+cg=;
	b=7hVCTavBJzFC2Y01RlaKBaTa9vXQvYu5/IvtjqSjAU65veZ/U80mNhAPsokGO7ICo/jOv5
	g0f97gtdHNcCn+i7hwXHwxY+fnsA7WAb6Lnnl4uXyioKtGt1utSRIXL3kOWLsx5Wi5aprj
	qdolLGpBTWGad+yfvJ4Oel678IcnSyc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1823344586;
	Thu,  7 May 2026 20:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DB122C2BCB8;
	Thu,  7 May 2026 20:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185371;
	bh=3Ey26oHjBIStPVcofdxUBpg3KGMQjwyU1xBvE1HXR/Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=U7IE5VMC2ljDDI4HbHXf4Kw6B1Fy8v4s/sLTufVnohETFAav41GH1jpeiNqNq7ybn
	 unx4WTy1JjRF8TnUSld8sBIh/11hHa8eF5P8CkzvtEtL2UqbEfRF4VanGQTUI+0CD8
	 f7228jZ+GMz0Nx84zrFcgPSj5Q8G2MY8Z9MH5YhrMtETj+efv6VIJT6ySSIcS0L9gD
	 Y+sHjYVHMSX9yJNszI6CSf7fOM8ZCLryJqtCUTO8dE9wHtc6QQSr/6GVu6FngJ7ub1
	 ZpXyLiJvE2YJlj6ANwKosP4nB2SJrhGBQR+YToMhFBCFNigYua6gBLz6gsyNod2lqb
	 ptljHbFqJ3ekQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC027CD3446;
	Thu,  7 May 2026 20:22:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:38 -0700
Subject: [PATCH v6 19/43] KVM: Let userspace disable per-VM mem attributes,
 enable per-gmem attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-19-91ab5a8b19a4@google.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=2855;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=C+ZXwAuQ/e98Rs7Di9G1EWrlq6zteRCZz2vi1AClkpI=;
 b=dp6jCn9ExgjqByTG7kaxpBbRNBGPX7nuFMLB6FJJWILEhdvQnCRngdmKGdljRH2+yoCeSw4BK
 Y/wktRb6O2yBOVvPb6wUEdVPY4MaXo1fd0+4WQ5Hw96ejsK19n6u44i
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: owyc39jn91gqaot3r14rm8pbpdrofqof
X-Rspam-User: 
X-Rspamd-Queue-Id: A71C110000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1778185377-737801
X-HE-Meta: U2FsdGVkX1+/vVaBuIfTzz1u5RRaxTajPSgW4pKzLFOijMTmPr3m1+aI4xLOX5ZhrlPfNs++23FU8rQ/YrhCXTKNjcxUOrHsUNGADfb9x7sWUbxR1BVukq79fkKmHPkyLATlTgpJiWiEiZjdP52KsDNbWYgjKVCwxq8bVGHt9fTQDKhk2j0Vivufo9WfNNMFv1Xn7GDdBrzcNdMyuTXelycFAWKd5feXj8IEkKHv7mJHy2YqMRhjfB3EfaAA0jLIOtT4Oteg+ZkkpKfx4/TL2lxxBjNaDxwhp5lQ9oMBX9b9rLC1pgIPnsm1U1SKG9nkTmHUw0XmO2QmSKPZzJZpw3C6DcUiKHI/5zhTbszQUj46g6R2T5ZICTgZE7jGly7TXtePu0eWqvjNbOLR/4ewX7HkEmTf7L7RLxsCY5iJsccJtQiOrO/aMKUG7l1n5QwEpdiRAcY8CWqRUIoSK7t/lxsz9bL0L4yU2/biBWA/xzBIqdI3dBhpujUf3l7vs4Mrg4uVwGbupbJxVFQVq25UzPfwTBBxDH6Kku3rCNR+R7Poz+z2oISXgEO9jmhk3/1LmEYjiPsz/577EB2LDeuRxEsOtPG/Ua2bgUlcyFEGYAsyQ3XWTjR2WBjBHY4yw43LdjY5/XER2ytJW3FEQCXdaQRYy/efxH7xdoqsO+ED4S0Fy9zDZA2bRalvITGF9r3z1zDDVBjto1E4c3phk/ElNPLfqOJo1T+j6v6bpWPOJqJGxtlkDxGGwSoISpf89Mx7Elg2+9ct8KhyVOTjm4/80VfOb8WWuETnm3xiBGnTYvITYNnS01WDPatPcJEKg6w38iBfleGTVWW0/dOn9zrZ5HsnCCtvr5NrDGUrNM/giFJR0Kz3XMu+k8lTNI4VhRnzLl/I+z+2Bfnh+Dnz9hPTtotnF/RIrRzMgE5ud2dOQLGBJA09JhYZkvbNKX7+z4PyA1+shQqxsvC3B+xrv84
 7PjbtkHX
 zPjE82vjPRN2HLp6RioBtvXtIp1UY/K2kUhdrFbBQ2Xq8JLWDVSa5VsML/EJnLd+LKxIPd2H+kry4U/yLSYF4NtFDveVPStCehaQOWR1TgzBsY4YSnOR8hiVvmx42mdTIZZkCqyg4A42qOzuRXsd13Y/1pdgwX9N/fjkOE946poLXN0gtdg0ls/JtsT1Zm1goW1xq6JJecvBpnzH0dhW9PFMjlUIYQYbWXPYOgxB8o4/FDg5OaP/uIxfzdhhHOzgdL39W29yRjQBraRnnzcNf+ako3QyW6RK/4pnuJ/fVXr7rSQ9ZhdLYh/jWd4HEOiPTqqgcaEo/jl6Ue3i4FCzpExdGQ7+rWHbrIwlC0u+zLoyCElqomSHWArHNj8iWdKOPxCpIkWX12USDkejXZ5+3SfKB1q+DlrLcygCk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Make vm_memory_attributes a module parameter so that userspace can disable
the use of memory attributes on the VM level.

To avoid inconsistencies in the way memory attributes are tracked in KVM
and guest_memfd, the vm_memory_attributes module_param is made
read-only (0444).

Make CONFIG_KVM_VM_MEMORY_ATTRIBUTES selectable, only for (CoCo) VM types
that might use vm_memory_attributes.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/Kconfig | 13 +++++++++----
 virt/kvm/kvm_main.c  |  1 +
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index b6d65ee664d0f..8b97d341bd33f 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -82,13 +82,20 @@ config KVM_WERROR
 
 config KVM_VM_MEMORY_ATTRIBUTES
 	select KVM_MEMORY_ATTRIBUTES
-	bool
+	depends on KVM_SW_PROTECTED_VM || KVM_INTEL_TDX || KVM_AMD_SEV
+	bool "Enable per-VM memory attributes (for CoCo VMs)"
+	help
+	  Enable support for per-VM memory attributes, which are deprecated in
+	  favor of tracking memory attributes in guest_memfd.  Select this if
+	  you need to run CoCo VMs using a VMM that doesn't support guest_memfd
+	  memory attributes.
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
@@ -139,7 +146,6 @@ config KVM_INTEL_TDX
 	bool "Intel Trust Domain Extensions (TDX) support"
 	default y
 	depends on INTEL_TDX_HOST
-	select KVM_VM_MEMORY_ATTRIBUTES
 	select HAVE_KVM_ARCH_GMEM_POPULATE
 	help
 	  Provides support for launching Intel Trust Domain Extensions (TDX)
@@ -163,7 +169,6 @@ config KVM_AMD_SEV
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
 	select ARCH_HAS_CC_PLATFORM
-	select KVM_VM_MEMORY_ATTRIBUTES
 	select HAVE_KVM_ARCH_GMEM_PREPARE
 	select HAVE_KVM_ARCH_GMEM_INVALIDATE
 	select HAVE_KVM_ARCH_GMEM_POPULATE
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cec02d68d7039..ba195bb239aaa 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -104,6 +104,7 @@ module_param(allow_unsafe_mappings, bool, 0444);
 #ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 bool vm_memory_attributes = true;
+module_param(vm_memory_attributes, bool, 0444);
 #endif
 DEFINE_STATIC_CALL_RET0(__kvm_get_memory_attributes, kvm_get_memory_attributes_t);
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_KEY(__kvm_get_memory_attributes));

-- 
2.54.0.563.g4f69b47b94-goog



