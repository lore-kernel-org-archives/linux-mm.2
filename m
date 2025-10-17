Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41749CCD1A4
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0904F8E0047; Fri, 17 Oct 2025 16:12:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F36998E0006; Fri, 17 Oct 2025 16:12:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAF308E0047; Fri, 17 Oct 2025 16:12:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BFB878E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:12:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 863095841E
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:53 +0000 (UTC)
X-FDA: 84008704626.30.08278D8
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf22.hostedemail.com (Postfix) with ESMTP id C0EF1C0012
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4xR7jUif;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3QqPyaAsKCKEBDLFSMFZUOHHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3QqPyaAsKCKEBDLFSMFZUOHHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760731971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IHQmo+/9l+Hla8mfwD4OvgjtC6QhXzaCqLReRxzUxFc=;
	b=4EZt77kHJLv6HkKE6h8nnwEZ1MIeLma32TtsMQmZrW3BW675UCwT2C99nmQ6nxjWl5aBW6
	AXRtHTzADedarklZTn+iQVeJC6eHI4QfFM++LVlx4MqGeOnyoTrqIw9tM3AuFOFy/pVWzJ
	Td6Xvm1fZUWc+yyEgRqpcYMWfhaCJGk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760731971; a=rsa-sha256;
	cv=none;
	b=URsbEMjIgE0j7Nb+xzhV1O1FQwPlzx0G6nZuAmCm93kMT4vHcs0WFImxsIxydy57FMyrJl
	BVbapwOJgKPXyivQHB+HnGP9WrdvQyCoGVViAwYnrP6/a9zcwYLsU30ADPHPkCoxDWlUhp
	X1sL4RfLNqLOA8nCoIt0V/2zxURcUqI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4xR7jUif;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3QqPyaAsKCKEBDLFSMFZUOHHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3QqPyaAsKCKEBDLFSMFZUOHHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-290c9724deeso17223525ad.2
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731971; x=1761336771; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IHQmo+/9l+Hla8mfwD4OvgjtC6QhXzaCqLReRxzUxFc=;
        b=4xR7jUifX8R/F4RSAFyFvMZBIEq7JOJ4MvtsUNiedjSAUCVjSO9iIJM/XOQH2n6P8l
         WuKOoDN2lmY7x5ov4hwZjI46iJRTI0wKHQKnaDJC4xACd9byFtnbgphC0h4zj5xxrQJl
         VqU0VhfiA0oBvll5LKKuTqexX1vNgEVGTjNnaLI+Gi0xlRa7UxzoE7hSyEOgMhVKE1WD
         w4kuqkBoTdBXNfa1dCFLVPNOjWYpR8VvWUsMPzGqIsmRLEHvsQFEib9j6PKTG3Dq6Je5
         7C3I8sZZrq4s7w8Bk1TzzJ8mfNdu2L6wJ5S88SVtUx7GtiJpJvef+fG3dccmd5m+Gg+x
         +JUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731971; x=1761336771;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IHQmo+/9l+Hla8mfwD4OvgjtC6QhXzaCqLReRxzUxFc=;
        b=ZZJ8V4zK3m6YDJH1I0RPk+qObM9/R6uU2h0idzBbhAT+0CZLAjQDJCYd4amHkaJ4ZT
         BqqorRLb2K7y9TvUxWTPKWc5OXaBmFFaB1YZSOUapPMAopMBtz6kCIec2qarr0rUNGDh
         6cvN5hhh9zQv5A5pQIOsoMH5bYBBv3kJSoLzpB1U4JPNSQJ0gda7reUQbUtYeQaUec7H
         +ZhQ920F4GeCMtusIFkpOoJFngNG9PWSAeUO3tH2/Ko3cPa/ZFD4eXSgTFtqLrelGhld
         RQA5YAbGan/e95EO3rXG2+4Tawkj68rFATIH2QxgE7VLPl/pJ3dgNOqoY44buQUBaVKY
         nVtA==
X-Forwarded-Encrypted: i=1; AJvYcCV7bPYC+M/4UaDA5oa7lbW0LUXf0eHebVwFy2efWiGT0Px0MNV1uISiwq82UElNIl2eVSChjQRPRA==@kvack.org
X-Gm-Message-State: AOJu0Yxr/WIhqOvUWzsywnvbxdh5u8qom7SBGoSwIpKqaE6TnO5SXl0O
	5Ud8RX1Ue/XxGAKcW+qwqDIn8TUkkstMS5GTWgZKfSPjvOT03P2kmY4XOWomAnWwm8ChY2WFpQ7
	xLhNS4vGM2h/yp/nP4j1AENUhGQ==
X-Google-Smtp-Source: AGHT+IHjLngq9Gz+3lpTwbSTAGILDclyy0S+0yhINh6dVc1pppWh9CmWhkL9jK5CpkjfqLGl2H3Ae/sqhUuPXSzBOA==
X-Received: from pjbbk24.prod.google.com ([2002:a17:90b:818:b0:33b:a0ae:940])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d4c4:b0:27c:3a0f:f066 with SMTP id d9443c01a7336-290c9cbc16fmr54129445ad.22.1760731970364;
 Fri, 17 Oct 2025 13:12:50 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:11:54 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <78c64979b35f7c1b5edc662bd8dda64b58904e15.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 13/37] KVM: Let userspace disable per-VM mem
 attributes, enable per-gmem attributes
From: Ackerley Tng <ackerleytng@google.com>
To: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: ackerleytng@google.com, akpm@linux-foundation.org, 
	binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@intel.com, dave.hansen@linux.intel.com, david@redhat.com, 
	dmatlack@google.com, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	haibo1.xu@intel.com, hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com, 
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com, 
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Stat-Signature: odwy95tdxc6988jjhd7u5esjcq1mhjkf
X-Rspam-User: 
X-Rspamd-Queue-Id: C0EF1C0012
X-HE-Tag: 1760731971-620241
X-HE-Meta: U2FsdGVkX1/IJHnesQU+xWQIfAUKlUEASATXxK4R3rSKQOPDpEjTieR9EgAbWbBsFW6OnjNOZuWloS4kh/XyvssgdeTqqLM6cH0rbrLG0VlQf49KUfYzZ+4LGDXuB5fdIkQ/0eQGdVTib3MuPbdChdGk7rQ7lR9M/2W2NZ3iOcXCcpIsXmPnTx/w5X5IsbkopM7ZwcXyuxHgoLq/ctA56JrXpJmnZKbw1snlGjcF16kWGU325XSRQlEqdP9O9Owfrt+uW2VPFKrLFt+8dJK7HyQLsAPGoLCpicVeA/Aof24Q9fMdNgR2KTDvX98tzz615VWFkFLMezABeUmwxyFTked39Yqb+H9RmdptBJgUDK3Ritf1/FfpYfJQ6jBj2fjRuDZYyqm1EGC0UhNl+JxJcW/OcvljtUS+4Ye+dtUxv8wmroPOOWor1hcAFMhzHwKK2N0D8waSjUh3X0xZvi9kIwDO15NGkZqjyclDOU1E9eUAd6yL8Fe/qOcqjeZgS0Ulshim/oXHZ6NYgLH6qKd4j5K1TkFZKRXm2dQ10kit5u1nRqPcogbwnm+v5Bd06FGOSozzEBMrGnhFxiJQVUk0DOqBmccBz29103mrJIy+iZEdNphvEr47+poRILXdBn9hZspj80gAvvSr7XwD8v7atkrzm7oNdIpHWFrVkpFrISaghuRdxIKFrBlpZ3mxPRHOnIAtEtV57LiHzRgYWY4emsuHa16q6iyDayfw1jSI3IhB+2NQx6OBvS4wZopJ6/nkiCrnMVr4AJoIfxRAlX+OaMAtecmC7TG6oxn1ZwhWGuDioWFx4Mv5qGgdyqIZ2n0yJD+nuZFLl0LTJ05P2JNou6RrGwUeAaWpHyHD1CV7YRK3YoophDV82FFWoesKnA0IiKflLWGwqX7qxQRHqXrLit6o/DhD3gbuF4jIlul0GKmEc8tkptVrbcK2kmEnWcKlT4aw2N6cigxhpB7eM6P
 4JrBYl+s
 WC63/NNuHzhSJs9Cqly6m0P/Nwbuk5jbKieUGvYNnITZDnRHi6pfhkbtR0aPtvskfALOA8w190s/DckR8siWn+3MClJrpcPWgz7TYDMRLdePlRCMfkqXyzQ4cgbXX/ROC1K6NERki9BzUDUpV1Kj+jPx9PkNbfL6DhklWR5zGrRBsIDvWytR90fSF9q/GupxLZCRa/v2iMNFYBzenZ8lXpNXEo01LzJIbKCQE9N99qiTJMpeRfP0g0Oj/1My1YD/vkdAo35vW3KWWNjd+7pCpWGGn3fOqKH9jEHjs9uV1E+hUhVaANUDf5PeC9jiusXMCipObl+015MftUSfYVVavZzOh0nuSHm4n4uPDxZUGU6scM9JFLN4HsnM3U4C0kqStMJyWipv/BRpiX2HIfmInBdUftB+5PS9E7zH7txt0MbUcd7OHqbaJ01qWfWtx2SlhiM1c4Jzka+4T+/Mh4r4sbN8asQdkAJz3JkJ40dhnSoR4rT2G3Ka3yhuj4A3pJ5Gjvm9YkvsPrdW9azL5H/TRVKuYUXt4/xaRc/7gRxpAsHNwY2N7lliO6+tC2C6MO05bCYKA5FCNWHS66oL6Nu8fdnJyhHGhDv/uGBDDBB+64YmwEbsERWw71eb11EeNQcrhTnn4slAvd8DU2faI2Z8EygAdJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
[Drop compile-time check for CONFIG_KVM_VM_MEMORY_ATTRIBUTES in
kvm_gmem_range_is_private() since vm_memory_attributes, if defined false
with a macro, should elide generation of the if block anyway]
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/Kconfig | 13 +++++++++----
 virt/kvm/kvm_main.c  |  1 +
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 49c7709e3d895..5cd5046c542ba 100644
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
@@ -138,7 +145,6 @@ config KVM_INTEL_TDX
 	bool "Intel Trust Domain Extensions (TDX) support"
 	default y
 	depends on INTEL_TDX_HOST
-	select KVM_VM_MEMORY_ATTRIBUTES
 	select HAVE_KVM_ARCH_GMEM_POPULATE
 	help
 	  Provides support for launching Intel Trust Domain Extensions (TDX)
@@ -162,7 +168,6 @@ config KVM_AMD_SEV
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
 	select ARCH_HAS_CC_PLATFORM
-	select KVM_VM_MEMORY_ATTRIBUTES
 	select HAVE_KVM_ARCH_GMEM_PREPARE
 	select HAVE_KVM_ARCH_GMEM_INVALIDATE
 	select HAVE_KVM_ARCH_GMEM_POPULATE
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3506a2f2be041..7680c868fd6e1 100644
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
2.51.0.858.gf9c4a03a3a-goog


