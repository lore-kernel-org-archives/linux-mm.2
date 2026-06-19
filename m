Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4D21CD98FA
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:32:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DA026B009F; Thu, 18 Jun 2026 20:31:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93D8C6B00A1; Thu, 18 Jun 2026 20:31:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8293A6B009E; Thu, 18 Jun 2026 20:31:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44BF56B009E
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:31:53 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A5BF1140146
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:52 +0000 (UTC)
X-FDA: 84894784464.09.F6C083D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id AB2CBC0004
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WLNmkqVm;
	spf=pass (imf28.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829110;
	b=t/nAYJA3yj2G4yl/Y1bYqmP1b1rMVVteOiMWKLVxGpaQNV/BwTOE6mOoTA7tDMtsNbMM/F
	8ucAsOXoQeypc4CxGjtMONY+jdQzpXlU/dISwnRscpuRaLMJwXQNKWRvsoFsHrASDmZBpX
	glCH0N/RKtADztzC03gKacz7iGD+YwQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WLNmkqVm;
	spf=pass (imf28.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829110;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9x81BijIpk8kYyp4mHlJjXGXZmSM0OisR88kD+4SIdc=;
	b=eWB38pX/sTQ0SfofmfGTjqvUFZRDizahktpwQ0ykNjeahfWEgQXoAjlROgvSTxaVi06L3A
	uPSRSoJLhvnX1N4amGnpsaPWbYtAAWLMTKQ0NkC0L8lq5qEWrJxjvHIgj9XpACuDAuNO3H
	X9h76L2+Mv1XVCgok597VJQYDP9g/uY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C089B445F6;
	Fri, 19 Jun 2026 00:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2E3A0C4DDE7;
	Fri, 19 Jun 2026 00:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829107;
	bh=CB7AfOjVFZWOFS59P0Uu5cqgMUWbrL47cDd7UKb3SYQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=WLNmkqVmie1VOR8aZ03V7tHR2WW6UlhAE0jz1jnWfhnMAP0I2iMIOdBZ+a9m2OqHl
	 NqDDfNBbtPzPTkiYH9wTi195riRWAbB+Z8lxB1O2SnnSXSWLNrN6z1pP4QihnmN+HI
	 YKzKUj4YpX5KPT/NWOLMkroUlRaClIRq+95vWEN8OBWv0MSrc8Wg6MBHQQGPupRbrn
	 VchNHVnpwzXZq9oaykCYaaZPG/MqU5HWhah2RmTRS/w0bYrPTtFgmP2OlCTjXydbMo
	 mK8l1PfoouSO/QX+Vvq1JQhzY6HdRGdmu8QdC8vlPdmD9J+iANtDGxhA03SREP0TG7
	 3gqOPYMPJC19w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FA48CD98FE;
	Fri, 19 Jun 2026 00:31:47 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:31:42 -0700
Subject: [PATCH v8 05/46] KVM: Make CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 selectable
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-5-9d2959357853@google.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=1858;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=xOoyBwi9Fnl8DxuOA6f4/8X9Su/Z5hzouF7RHonH6fY=;
 b=V+F5mfHWgPIoDzpZABnezOfAtJfijD6ASXKARAsXF7WpHdkwwRvE7O50VRv2i5WLaItJkqw1F
 lhXVRRjtDwXAl9Z1griCM60xbbYwOUvx/uXBC0nK6Jp5pf9anwnxeon
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: ue37uxf1rkdkoki5wcppxgin17cbtnd7
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AB2CBC0004
X-HE-Tag: 1781829110-247984
X-HE-Meta: U2FsdGVkX19S2ONg6PPAkAlogh+iXaLzx33q5QTdluVBaW1JQdiwEzruzn6/xKLQ2kN/vZH1guf6BjGAUsRY74AggF1JC5rVsbtI8Qe8UgUOALSukMGtd/Hu0PT/S4uY76F91F6OB7gZwzRmqf9jPwNbhv0eo6+0OllavZk/lPp9Ba3Kcni+H5MoPZWF6VaXTJ+m8y39JftNZMLpSKjIrHuWzSGUt0NgHQsRhEpRKKsOpLBTupNMJPYKuAbfhYPz+f2SGX+z94A1eFXHi2Ut0P06Pw38hW3+Oe9Gb421t1JIft2HEGHeHvze0Y7XJYHi1RPEjCVofsSpQpT857lse7Gm0yoAxiRa6am2edl/uXIyilOKzP4uoGNatN11AU7x7F4mj1b8cV2UTNfOQYu9B4Uy9q8jAVzrtX+RmK6MbqiAtXIodKgN0TtH2WpBO9uRwRR+8ddVXppR74igX32/wqM5cE5DOTVcC2aOHzzSCe0+NsgxOAtAFDTbq3zff4RBnUT/Ae/7lXkK7/RnV/qATmwJW3A0za/STKS2SMRNDbUBzUp9z+i09cDTzh/8om89FJzKG7w3IHZzYpgVaBKhXCVGjFPHxSprujNbQaNITVbkFDgErv18zlquLm9QNz7+JXtlxusjMmuHE2WyKVDYengraN7xNDVAtnATsC0nL7wy6ZA/evxQsU672/v7t+CJcHUVHMEO29EvWnTgO34z1wqydUhAD7jj0KCzC9GCyuK8D27iu5JoDU7ELn0xjd+LBhxgWPHpJMKaYGN3AQOEP/yiGjO7Kofd7xCKI2V5T6SrZLfrsdLhM4VLaKIAdnE/EZNiyXc2e6+SO/fDV4KJcqYBxHZnxyg/PrKPqjqc0sKFzxBpb0hVE71OitmO6zPoJc/xLSfTlEibfsLyBOT4wKM9W9jPvtFnJqWXDE8KBerld8Nu99ha+ouRMFBbGPf+/1fi65EWD4cw4jUJo1E
 5SpwEQJ+
 ZSuWNP1+jGLfhb8PfNXANHxJUWWuYTwpr4RfnfNHJo2D8m7fJvflDw2KcK7rOI8I6BJADOk5UidPLLNI474F8z7uY/oSQybQrrMdPV/+bS8GxP5giAOvg39Zf0c0Abu7heHA3fUATCpzQyDxFjnsn7KNH49yZo1I2hJ/8dmnyiHyB3BoS/aOEjG4in3Yb+mG+CICUHO4uMAEEDjpH+nnuSzw2XH+zueB3RDrES50mHgBPpO3gjfpYgZ0PaBDrW0uu2LNBYpGVjT/dHRDQ62dZ634P3aLk6pxJ3uKM8k29KGcHzUSFNWcKDbs63JLwtPt6FwmDiw+Kdx9R2E2VSlq5jwBMSEOSH9SEbxsZ46iAQL9ozbqb+FF06P8OpK38ATg85RgZPSurFp7dd6GkuC94Q+3jXDlPEbO8BWQ4flQfeyDBdAizo0MozfZjPmp8KcbYt4a5erfFoPkw/W6G0Go5oP1kMQ078JGqzqB3QJRq+dxwQP7OWUtQOyg7Aw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Make CONFIG_KVM_VM_MEMORY_ATTRIBUTES selectable, only for (CoCo) VM types
that might use vm_memory_attributes.

Also document CONFIG_KVM_VM_MEMORY_ATTRIBUTES to specifically be about the
private/shared attribute.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/Kconfig | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 24f96396cfa1c..c28393dc664eb 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -81,13 +81,16 @@ config KVM_WERROR
 	  If in doubt, say "N".
 
 config KVM_VM_MEMORY_ATTRIBUTES
-	bool
+	depends on KVM_SW_PROTECTED_VM || KVM_INTEL_TDX || KVM_AMD_SEV
+	bool "Enable per-VM PRIVATE vs. SHARED attributes (for CoCo VMs)"
+	help
+	  Enable support for tracking PRIVATE vs. SHARED memory using per-VM
+	  memory attributes.
 
 config KVM_SW_PROTECTED_VM
 	bool "Enable support for KVM software-protected VMs"
 	depends on EXPERT
 	depends on KVM_X86 && X86_64
-	select KVM_VM_MEMORY_ATTRIBUTES
 	help
 	  Enable support for KVM software-protected VMs.  Currently, software-
 	  protected VMs are purely a development and testing vehicle for
@@ -138,7 +141,6 @@ config KVM_INTEL_TDX
 	bool "Intel Trust Domain Extensions (TDX) support"
 	default y
 	depends on INTEL_TDX_HOST
-	select KVM_VM_MEMORY_ATTRIBUTES
 	select HAVE_KVM_ARCH_GMEM_POPULATE
 	help
 	  Provides support for launching Intel Trust Domain Extensions (TDX)
@@ -162,7 +164,6 @@ config KVM_AMD_SEV
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
 	select ARCH_HAS_CC_PLATFORM
-	select KVM_VM_MEMORY_ATTRIBUTES
 	select HAVE_KVM_ARCH_GMEM_PREPARE
 	select HAVE_KVM_ARCH_GMEM_INVALIDATE
 	select HAVE_KVM_ARCH_GMEM_POPULATE

-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog



