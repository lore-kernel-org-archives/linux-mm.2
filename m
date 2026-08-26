Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91CC1C61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:19:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09E346B00B4; Wed, 26 Aug 2026 05:18:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0016E6B00B5; Wed, 26 Aug 2026 05:18:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE29D6B00B6; Wed, 26 Aug 2026 05:18:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF5966B00B4
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:18:50 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 21C784031A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:50 +0000 (UTC)
X-FDA: 85142870820.10.52D9103
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5B955140009
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NAu8Z5R2;
	spf=pass (imf23.hostedemail.com: domain of 3dq-OagsKCGsJLTNaUNhcWPPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--ackerleytng.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3dq-OagsKCGsJLTNaUNhcWPPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P2MYy9xCCsRh/a0/MTuFJqGfvDDDTtCK5nvSZnRDqWg=;
	b=piPo+VeBaUXNpHTc7iOiLVG9LLuBgqw6+qUEOCRrYPrZsePZ97fCayL9xqqZ5jSACGnxdM
	AJEjvP+5RUtDH3zi1rr8q4zppOSvBGkYp220TNBfQW/K5lJVR+freIW4o1CuKG/NQtfECj
	Ep4HAn5AFjdEDOYBnV1MiRlmSAPinB8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735928;
	b=wKtuXcyPU4d+HXe0kmiKJ6CcniCIxDPJ/oWh8vWq/hwqfTNPqXh3ZgvjX9PqBAnJ2voPkX
	qBCjZo1ZUuJg0GHjfOwQ/9NXYNcVfcRIF7TdsbJpl443dLg1keOA5ZcB4i/4kChYUCBjcM
	CGydXiLFkiiJ4ktS9DwUzATVM6bSg4k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NAu8Z5R2;
	spf=pass (imf23.hostedemail.com: domain of 3dq-OagsKCGsJLTNaUNhcWPPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--ackerleytng.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3dq-OagsKCGsJLTNaUNhcWPPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d6fb956002so11299785ad.1
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735927; x=1788340727; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P2MYy9xCCsRh/a0/MTuFJqGfvDDDTtCK5nvSZnRDqWg=;
        b=NAu8Z5R26/Bk3YFgnvEjpWmtaBFRRqREyEN/ry5BDBwqZZGbsRMMBjmdBx+EramfZO
         Bvgpmv4M1LoFn7ffnKZy/Jl0ti9Po/Xx7Eck/hLB+myo4MMGtsZKHCNdFOG0cce5zGOe
         FA4bFZ72UcPg0zPWXCEmjr0bafn8hQBb5D5VDPzytbflCqLwMZ/KmWXFVyENN6f9TCfD
         5bBF1WJYphYZM4LYWBedmOVx0ktKGcP9CEQKilO+S4DKZOj/bUu9L5jemlan48+a4nuB
         bnEejGD6di++QsXqlqmUybflpd8oiX4DNX30oM1/Y4cTayEwl9c6pY383AfDMoJWgRxS
         yJ0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735927; x=1788340727;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P2MYy9xCCsRh/a0/MTuFJqGfvDDDTtCK5nvSZnRDqWg=;
        b=RNwUhTWQPh9TcSGNf1iKLhmTa25lDQT4hR/AYtux78o3bjA+y/4D0iSP+K20c1cLwQ
         1lZzhe+lajfbhPZUqj63IDelol0/KhTpaJpzYk8IEOf2NJov3559/sSHMmQhQap2N6MZ
         oDA53wU//nNLxKvrTH0uY2wCVOjN4ItAbpA12rSt0v+T92RPKgVe3QFPzxvAYarItnmQ
         vjA3VaY7dviS2pqalUkdQVsXu9R2ArXeDDx489JNRr2kN/Jr7PW0w5Hka80qXl+jPIfj
         ly7tijLkapFTR3f0mINUGneerSTeTDb3Y8rbKVD1Xaa7JOZO2GZ2R80TyP7LIIYa2EMn
         Hrqw==
X-Forwarded-Encrypted: i=1; AHgh+RrurpMiBiMrXjq54R1PwiZyWdqhYULfffCYLDjfvTt++R25DiXySVcTWI23acPiPqFJW3ZlRtgIJQ==@kvack.org
X-Gm-Message-State: AFuF++lgaKslLnNwDVYmEjqgrL7KyupIaW1ymvI+8I7BBuAquGEreBk4
	c5tqpmvvuHi5RQIAtSQqr7n/wnNeMAQWczyRGwPpu0L7qp1s6c3a7y8u+nlOvmbfQJV3eUw/FaJ
	7GPxcxlNmy77D7ReRXOhAL0zJOw==
X-Received: from plio3.prod.google.com ([2002:a17:903:46c3:b0:2d6:3009:ccc2])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2283:b0:2d6:7409:7145 with SMTP id d9443c01a7336-2d707a2edd0mr90965095ad.1.1787735926573;
 Wed, 26 Aug 2026 02:18:46 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:21 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=7437;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=erBMg+vYNKFmnIk1EALqLuAs5vQ8G8lIJWnAQEPGhMk=; b=rvsxDqasKEC9y24pJL6GBixd0VO6ms1BpDtgqU2vfiPjwfeBV4W2WWC2J5Xrl4izaS+xS4TWP
 bS2O2g3q2UYCaaj4SuKQQVw+wKicDiRXtr4U+uVmHBd3z9x3HPMjVOo
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-23-0a15d8a799aa@google.com>
Subject: [PATCH v11 23/46] KVM: Let userspace disable per-VM mem attributes,
 enable per-gmem attributes
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Fuad Tabba <fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: um46697ippt3srmd7xkc79cdh16x8ukf
X-Rspamd-Queue-Id: 5B955140009
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787735928-259321
X-HE-Meta: U2FsdGVkX18QEwsnKFEFEVoEap0z+Icbx58cg7NAwDZN3V6ZC3mCeiZN9GinbgEB9OCw/uXktOdoVKqMkA2ro246S32nms4e3myWz5ozdApRDdfte79Qu0eNmEWfueYtVNVNY9kz0bn1xNVy2G5CqiM+gMYZ8W/do64IsFx5BUV8UNtF/6MteIRjWi/feVPTCcIcj4sU0BuMfDdkCzsD/f14EVdRP8z8NyDl/EiL6TnoejSUZpvFh6V9UAHA0MfkGYYRTK3XVOEa1XMkVb+a+csMARHFVDrvBCl6NHH5tnFThBzRzXyRLKDjNxDij6WE5fkP3QGRrXHrHxZn6f+EhAfJ06joghOMGh7vB9jje9LjcGPQMxq0X7lCsc/HnwJbbo+XDs5Sdgu7WxvsWB+/YTyBEtlzigixIVQX8QkDPsBloTUlrHr1GZ9cKVme//3DsxtlRlvIj47jYE0J4HNqvD2bpX1PM3RBH5WZuH8ejlR1xUJZONSeyJiPz3HcpDsFVNpw6FJ6452AaoaB7YlC/b8KhH75HuSAARAJ2kj5iLwopt96hhv5goDfZYjR0hyTq7F79IrSz+/dFs17qai8uKVVegN0ib42Mn1T2StdPmS3qiqnjpioidkHkGhK4lrn847PAs3kXEdOPG88zV9pfllSLEtuYlK4ZIUvguGIfizueOosL6OjblNo3k3vVI/kq1AmZWKyRdtbD10U691g0l4cjpegJNvzWEI/8FIg4fJb8U1T/vUmLv1GFVUzcWzz1hgzosuOjkzHq9tA74wuh84YcqSyjDVh0xqoOpWVlw3VEDn1fgHvDeiPSJ2fC37yK4R+t2LhVbtfKU4hazfTncONPpeSeQuiVviXgWkuDhcdWhpkDWhRVU18hw0LxuZppbBTfg4GCdkw08o+MFbncQIHdwYB6EERlfxA7T5RcXtf+hBfUSxcy6y7/hJ/YSKj/s0kswKQIHOCTXa4B7n
 xDgb2Azg
 A48SO4AwDenB5dGZuEeiuf5HDUcKRIX0+7jOl0jE9vVCz8q/jREBjrz27XzIF195WmPaLU3p4jzZn6jsw3MeVr8LTGCE71yZdRAwXA4HYqB1wL17zNrK9WPuZCfYG8b59eGhsHjoVKQEALrBi8I590D4A8xe44phxdv/gnPNUAR9gCQdoc7rk6PeMPd05ecW2aAqi6Eypn0br8SUZbCxWILpm4c5gCbxeLDX75kt1PSwJywkbExvl4q2tuQBVL7SPolzZ/b1U53jd8M6txYw4l0SMKrgJJX3JUaf1yxNXvGSng9S7EW9shW4MJISz0Podm1qvGQKgsrVaHxByqHH0uhfLGf9xgF+8BTwYnTmzkgdTGTzPIoPM+9eINMu6ZQ24QGjYdTgulyolpW8eK6AunLnOlPGOK7AQYFR43alIYd46XF2B4luaJzjFocXWT7Tv55Gg7Ceyf3lrzzxrQFEuqkMdEMIlIMKcc+dOhOIldqHLKYMOg8Q2YVow0lRy5fDdBnBpXFd2scykQNr8/c9RfyMkkrW4J2UV1TbEiWWOCDqvIUdjyP54V0RAe01uWanSb2KimsP1xwEBqGePSFh2G7ZMnUlU5F4PrTIe/mSBtCUnuEybtGk/nAcMtHxhyGA8luB6QTUJgFkmaEoebSU7Mw8l7VYa+lM49m6+
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
 Documentation/virt/kvm/api.rst                  |  7 +++++--
 arch/x86/include/asm/kvm_host.h                 |  4 +++-
 arch/x86/kvm/Kconfig                            | 14 ++++++++++----
 virt/kvm/kvm_main.c                             |  5 ++++-
 5 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 1069806616b94..0ac44e1bccd28 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3114,6 +3114,31 @@ Kernel parameters
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
diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index f88d65b78c504..d976f8ec2e2dc 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6383,9 +6383,12 @@ on-demand.
 
 When mapping a gfn into the guest, KVM selects shared vs. private, i.e consumes
 userspace_addr vs. guest_memfd, based on the gfn's KVM_MEMORY_ATTRIBUTE_PRIVATE
-state.  At VM creation time, all memory is shared, i.e. the PRIVATE attribute
-is '0' for all gfns.  Userspace can control whether memory is shared/private by
+state.  If in-place conversion is disabled, i.e. PRIVATE is tracked per-VM,
+then at VM creation time, all memory is shared, i.e. the PRIVATE attribute is
+'0' for all gfns.  Userspace can control whether memory is shared/private by
 toggling KVM_MEMORY_ATTRIBUTE_PRIVATE via KVM_SET_MEMORY_ATTRIBUTES as needed.
+If in-place conversion is enabled, then the starting PRIVATE vs. SHARED state
+of a gfn is determined by the relevant guest_memfd instance.
 
 S390:
 ^^^^^
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
2.55.0.887.g758fc8c411-goog


