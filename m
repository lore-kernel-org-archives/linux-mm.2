Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B875FF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:32:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 038496B00E9; Tue, 28 Apr 2026 19:32:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2BE36B00EC; Tue, 28 Apr 2026 19:32:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E686A6B00ED; Tue, 28 Apr 2026 19:32:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D91946B00E9
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:32:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B02DD1B98ED
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:30 +0000 (UTC)
X-FDA: 84709548420.27.BA2DF78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9E42E14000D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W8pncTb4;
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418728;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=75x+8S8qZQoCmwPts2AAX4ANA0QRA1MNkI7cGgDmZHU=;
	b=wlqKwzPVkk5HZHd5LR3OcR+mOh7aFBiPBvl6W59rXemskNQPM+bVr8+31/DJy/CyWuwgfd
	Y0/k9mKB0tfkw2yrLG3sOR2cgpqRtiPbUQKULN99ZAL/MZXRUlabskg8tUhmeoDgy9vJTv
	KDRgigCiWmoLz8SCGVOMe6wbEszxNgg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W8pncTb4;
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418728; a=rsa-sha256;
	cv=none;
	b=IOcojcSPl37vDKHBDDe0PR3lcnvRAnT3rm2uI2E8ioSGb9J8NHglY9Vorm63euk1SLxoQX
	oA+qR0bjHOMw/EkXX/D6g91ZfGUFIsADEqTLgIFZSespj0kwIy/g5pCrMrGRCEsIcaMap3
	kgmQULTwaTYtp3EFloZm7AvxCg3ZqRk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1DCCC44A1B;
	Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B965CC2BD01;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418719;
	bh=rNUDxIq4jocmrgka0xACOy4J+7FhQChrkTScBEODUyM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=W8pncTb4nLGXOQIg/AbT8tPfnXyr4fV2xlWx5bkiBt4wzW/EjiMc+LvDmmTHajzLQ
	 QGzqtcaheA3pvhTQ4bta0mkA3Z9+XXs5DbUD4PlfYSZjQpvLwAVIxSr6N252jQKBdG
	 1yITawUkm+Gqb3OgA+x96dabaqqsccP4+Ha4h8TBzTespC66nWFnmEvPOmN8k5tB6o
	 K5bzx3TAnuWKydpPd25cIWQ/XeTeBK6z0x29RJqj98WbxZYNihK7eYAfLg7m1jcin3
	 wg6OLRT2mI3TyUjRotxwUQn98uyXLM44DBpZYMFZE8S7EI7roN0tK0ww5TZlU2VK6Q
	 RSwQfn+5aKOeg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7BBCFF887B;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:14 -0700
Subject: [PATCH RFC v5 19/53] KVM: Let userspace disable per-VM mem
 attributes, enable per-gmem attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-19-d8608ccfca22@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=2855;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=KMLYlEABtckw6VyhRdQRr8/Kzmu2l2xzD5HnouJ7iBc=;
 b=Jdi0ySmNlBkaIZQdwgtEYnczV89YWoO2Ir7hJXSA4n679Me76AJw98eYvvPwl09ungXW2s/Zt
 eaJYqHbxH9XBwPJMgCmoAOHf5xnz8ExWUkcQJXoNn8SqghToUKggEeC
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9E42E14000D
X-Stat-Signature: nx5pb7qzt16sauyesx9i9to4pgeymqa8
X-HE-Tag: 1777418728-575285
X-HE-Meta: U2FsdGVkX18laQzpb38Oh6HNiShoRXDwKdMMg+rFtxk+xVxQ72PMvWkQh2LO21tXvMicuiMGcV08ji4puE7xr01YNrELmn6NeZmSiyJ8yD10CZaLBmlEgfxoc/E90yEvCtdqsPBlJ0ka+JJu0rG0X0mfRkirnnBHjX7u10/870Z1Q6AM/+IjBLzfy0HYefSb5si0gLeYl7Qjlybm4/leq9i/hn5Z692OY2uQo1n/SCvrZoPjMG2VfGuARBAQpUz9/C7iHxtsypwv0Svc9b6s+7R7YMGiAKU6P94xgEg+J0U6ya0HF3STfCJgMlOUgdutaGdDSVYu+3J77L8Gnm2+tgo0eodW1uLok9/RdMLSHJaULHm383uXB4LNh/cC/GD6wOQDAMkIn8tcMzNEaG8iz/rcoug09FlmFkGaKFMZgQky7G43oGhhHYztWf0G3/j3g3ntChC49SUD4o3F8HoGR/8te7Mpe1BoGQrz8GoohXF6rh1fytJWNd1bOICWw3LqwukxSgCBNDSfGZ6shZgq89s2NSaEtSdsFtl9GdJANmZM4VB+yL8zxke/aA2+FtqShKfnvoL7ARlNev8ZqGwZkai9ruPqvtlSuDTnLdTN/BOihbT4NgZjvypOY91xlTrdfPKyjspsxvECQL0LR6eLG+V5EFup04NqcDSlHbkQtudHGLVnnOAMfE9jQWhEyYVNKALgx5LenZlDXgRaKjn9cphte9RYrwl2sPiR8Z6MPWRkeo0DcvO6tVn83CANnBwn4Xg2m7ALdWnZmpk2TwHo9AIPEBY+lKbN8JEvCPaTf7qWfFqB0bFREHsgymAg/vZYUCm4sZB30Vz0FYriFTa7g59NF7cgTk6VPBcyMQxmM1HPwQ8HuiHIbTNpJYlZ2/5EIAMbkqEk2vpa76IVMXs7nQrm3PpVLcTg7BPgpRYAVSWpQXo/Px2EkFYEBRaPpOw8WbDCX6/4LyYLTAdefu3
 t9sHlGho
 fSWs0hibmFTiMMH27nZZvIuOnF5KP51unDbCv6Nc/fTeCpbS/xibJrqJfrST5s5e4A8WR+RmJBklCCCtdWW/m6quoBOc90IlI8N4gIJel4Qls5E14tGXII9aL6l0dzAdgLW3kcZOfVxQv27TuEAms9wLJkPAcb4MmKQvGR5OfZl02+DA4sr7p5bHQO4wwtIRaX2CWs2B7ZC9tqcPors+nouYbe4kAmyrKXik2Q92e5nx0tcAUR8eu60QY0q0h1UueFPf4/Jmn8eu0dznBGamkVZzsNyHLyt7eXcTEHFyerzPEWofoRs85Zog5vVnNwCdGoLjVp44b6ebxcutoYIm3vixpT9vcga0TBcY2c57j1MRizH0F0dgbesfEr+pGO4Zt8Vr2MGjFXcrm1cxxLljofRqaveOXLsQan51m
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
2.54.0.545.g6539524ca2-goog



