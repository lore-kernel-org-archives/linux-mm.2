Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC349CD5BBF
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:18:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB98E6B00AF; Fri, 22 May 2026 20:18:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6B3D6B00B0; Fri, 22 May 2026 20:18:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0ADE6B00B1; Fri, 22 May 2026 20:18:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 912376B00AF
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 576E64077F
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:13 +0000 (UTC)
X-FDA: 84796772466.29.785519F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 596A414000C
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O9DSQuDb;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495491; a=rsa-sha256;
	cv=none;
	b=k7riEovBXuvCXFsqU3s+zxiWGVp+nIGbxjnOHSdVUkqWXLg7V0rqQKPv8r9GnOV1UDNv7+
	KZQBq8jb/Ab1FwqVLTjL4D5XdvjppiIqwkohdiNMerDDxJHS0EngbqLXQQ8Iv9Byhks3ez
	cM6CZVp6dxO9PDN7mNB7eo5mUvBcxJg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O9DSQuDb;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495491;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HYbQkUUWZOi29VZ7r0nHUPZK/fFuMhnmhXJuiBDi+7A=;
	b=swvPu8uyMzn2nvKl5PtEoc4rZgq+X+jqBE8rRq6yokkClIKNkTq3BPl0x7R71OnglY9zDt
	/PwuB4o9+vgEApyKFbTFFvldPbXXatqqlS5UliZfSVNSk1OAfgG/nU0zvRwlQJ69+tkGOw
	JWqOvxfrqLw2N2e5BsTehaTi5LEwp/w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B993446D8;
	Sat, 23 May 2026 00:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D5FD2C4DDF0;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495485;
	bh=C39lMwHCMaKdkBXuqytsqBdOXv7LJpVv+e8DmDVzfNk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=O9DSQuDbfhttL46Q+cH1paUvEAVNxR+YV+IOUegO8uk9y+sS/6t0520vOvH+LZn9r
	 DN+0WF/Mzsr60rOY85IBe8WWSP+ALUjaT7/n5iU7YyWxmVfQf/fJY/0+pG+r2TaUh0
	 yAO0HkPI+pOJu9N5BBmc+/m9xrPNQ2I8RXPrW6FIVGhVKrVbZwMRfvRRliU9BcDx6b
	 cug4eK665VW1AGmTb4GkwOjfI6hxz/E3wF/7QLZD6/BfH9W/EYJ0t5XFi76dQkyQv3
	 FK7gd9z4EadJfu0dPDm0qc6Hek6HgWjJWimfelq7gtZ5ZrThvl4gtvI1tzjpAyVLT0
	 ULNY41qM5dqhQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA096CD5BBA;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:18:00 -0700
Subject: [PATCH v7 18/42] KVM: Let userspace disable per-VM mem attributes,
 enable per-gmem attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-18-2f0fae496530@google.com>
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
In-Reply-To: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=2855;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=W0ThPVvBbw9pVumfhkjiMDvxR45g3Paz0SwoTcwuSAg=;
 b=0lISKKF2QsxRXk6UOczMC8Vk6uGfm+WY+5BLPPA4XeXcN1/XxESDm+WpcgQ64ZPx1vsaizgwh
 77f3L1FI0boAuRtK6+xAKJ/qh9RMCd59o1LvqPhQMUrFcQ84llDrmev
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 596A414000C
X-Rspamd-Server: rspam03
X-Stat-Signature: re79p3yddygm4q5grwmok7m8dqetyn3d
X-HE-Tag: 1779495491-800759
X-HE-Meta: U2FsdGVkX18JC/yTJeBKT5FgDHSmTrD17ku+0wc/J70uXYhyesEi7mf3vPuxHHNbNmHlQ8wDFocmvLEMaTsf4F8whG14stSeHTwnY6EIA1IvVnjT6f9Vynu+10UbA+f8zWOYSGV2mQCIZAdpRRSEnn69hUi9TX5dqjFVNn3jq2EQWFYgrzLgEbezsAxn17mhsJ/KliBHRJBF1X/3K+pDG8dD4f2YR4i3WPj3oHACHVKPHN6FRMCWjMEB+d2yYtban0GDsdTui9IzKEIkS8MGRpyODQjI3O+VNT3m0CEPda5Y7UgTHkguk9FGVKSt5m84OMHFtf+8brtC46A2NJ+ianCXqUNtxikuj2kIagwqKiUYPIIBeUwqFYRzXk3vgZyV8eROnLCywm+fsRl8jhtPfCJ/uGwx1+avNkNmFLEyhCyS7qTtVP4ez+L861983AzRJuhCfCHcu/yjm3x10K7LxEHYyvZWiCgno9IY4UI2rCIngKYTrDnivpQFDEtYYSQa+n+cUC5+yX3339Ysl3waa05lPh4+oWYnQAc/WereNjJTbx9rW4p0sQaEjmwyUsr5R6P1KZzdiFzvlzJi3LFcPxPfOxqvwoZO9S0onYrZ5vlaE4SZB2gH17voHYbhkaewoa6agakQFcSb4US1wCYCg58GS5gaxN3vdmWMTsSh5O/LtNCxNY2z6+k5DJWUYCohxUY11l21QSgDh1wDjLtcMjnx29k9ZSkAsBwUhTGrZaJ4giOKcDOeKjlaP+dHIseD2Std7tVCkDaALYo0uACYGOAWwL4fSlnmSCR4LUIf7pU8xyOT+trrtCUte9YpaiZ4RRHFqmimbgRKmaIGDgKLUbgn77KO7+RIqVdSHZxmbHELbysdvnNShIaiI1XVYNHDDpIi5/VMTGepFBtWELgtCdGzc8LzEJohJtRqmsKKkUFKn3KDoYJ94NpzsTpD2T8Xfky1RpvGHKtzZJIk826
 rwYXN6Ky
 nroQ5GnwmmeXl5PAFGC0NTA5fWTmymUvVFSx7NKzVe881FKieWAbP3+J9Shx4Rwe3P+3K/bmZsbee4TpXztm00qTT4Z8e+Y2FWBbZV5e8hn7EyLfenI+Orgw+IKjNudlU/bRE1Q3Y1PbBiWAR9hV5KKwdWPKBMAeKsF82ngR05rOTO2jpZqCi/1PUZjtP5xzaCzEBL7uxNRrMh91vaEmITct5mmLRLviowPVdwasorWRASBeRtTKS0Hbi0WsnwdybhtLsHThl0iCpiTVgPmFiPmqq2kQ350xIcFDSUFWeMxKYYBgLj89YgoEgg30kaLpUKmdELiydhjtdPyGAFwE1+Ram/mDXE1gpid3PJvSeeg8tJT4U4mzspZl811Jo0N8gDaB3iDjZnAr1AA+QNdG8r8wwfhI7T62jAyh3
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
2.54.0.794.g4f17f83d09-goog



