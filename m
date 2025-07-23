Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 352F1C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:47:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB7F98E0005; Wed, 23 Jul 2025 06:47:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B69DD8E0001; Wed, 23 Jul 2025 06:47:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7F618E0005; Wed, 23 Jul 2025 06:47:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9892F8E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:47:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 164891DAF5A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:20 +0000 (UTC)
X-FDA: 83695202640.30.F86B84E
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id 706041A000A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wOcvwd5e;
	spf=pass (imf19.hostedemail.com: domain of 3tL2AaAUKCH0ubccbhpphmf.dpnmjovy-nnlwbdl.psh@flex--tabba.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3tL2AaAUKCH0ubccbhpphmf.dpnmjovy-nnlwbdl.psh@flex--tabba.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753267638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=irM8qZtZs2OxjIAk0ctgU1D+7CU3BEq0B4YUNMOwj2s=;
	b=qREsw1lC/3VfUaWjrsAjBLiE8Jfe48zgIqJBZgHnQmeE0dnzmZthKr/5f3JK4+z+/DCUxr
	67sAwPrG5kcgwIrC9fRex7xFoSN3jpaf+sZzYQducgq/OVkN2Jw7XmOR87eMm8VG4jNqQq
	Lo41mJbtyNtzbg0mmP2WaX6o+OaUNC0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753267638; a=rsa-sha256;
	cv=none;
	b=qHii29rm6XtY6OtCGbN+LWyOna1iUXnE/a3wzk/JvnriwWOVw/bj+VxI7XkbA6pQpO2gLH
	gNfpHVkCgxbXPSFAOnD922McRivVP3RCqv8ZGiHDE7b5ZrAZi5eRk0tdtqgUuou/Lu33lA
	MW6u9zEV55ODHDoyswzU8UF7yT/sF5E=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wOcvwd5e;
	spf=pass (imf19.hostedemail.com: domain of 3tL2AaAUKCH0ubccbhpphmf.dpnmjovy-nnlwbdl.psh@flex--tabba.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3tL2AaAUKCH0ubccbhpphmf.dpnmjovy-nnlwbdl.psh@flex--tabba.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3b604541741so4774084f8f.3
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267637; x=1753872437; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=irM8qZtZs2OxjIAk0ctgU1D+7CU3BEq0B4YUNMOwj2s=;
        b=wOcvwd5ey8DIxxbhcEO+tblk3FHjSKSJkCTU1Y7zveC2bUZhSswPZ3q1S6cl7jC4m5
         3CmYKJRjIUKJGmYiCullQ10KXOh36DsI8IhGFXB0X/SNg09zkvkZZlLYA0sVHyHxmz6Y
         K9XfqaE0WIH73u7FE0GbvWdipThn7dsX0yoA2HNo0ON3vdZU6qEADtwg6d3qTpklRF70
         HNR+vCFlyqx4x4TjlI3k/Qe48x0I+xnBB+KNVL4UBjehv+WEaEGk7x2+QTx/sxAs5dkd
         gaqs4THZ5Yk/izJ0Bw01RE62iJj+cLJV0555w3+yy6VExS1qhHBWLkXqXjNL9DRu3GNZ
         IMdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267637; x=1753872437;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=irM8qZtZs2OxjIAk0ctgU1D+7CU3BEq0B4YUNMOwj2s=;
        b=q0qran134zHXoRGp/8hG5IOihfvay1OR9Qz44Z9e0EQFoYMZ4mfAOxjmgSV+zvlgQF
         M6yBlXt+fHAMyXO5oDLOZcqF2ROBQweGuI+5POLjVCAmmfKQ0zayOJdT3lCcVQHAgkEq
         pFwexcQSTXBWf1fmOzgGb2oZ3cKdui8n6+FAItAzgKpdnqBcrX3cjpuyc7cQkQiYUK2v
         JIu0Q/+jBtnVopL5F/cEA1xFUOJzO5HWXkbQyODun336g5Apui3JVQoH+RrlP7Wg5bbW
         zxPHMH1bVx79X4QjnBWigwvt2RcH6sfrwqohx2q/2hQEbOc+1MIsAs2iJiZMmAlJA5qo
         7PpA==
X-Forwarded-Encrypted: i=1; AJvYcCXuH9q//0XVeY40PT3EAYs+TZtAnrzheofI24RCLxO5dCF/r0UCuk5aYXSZSpmIfThooSrbKuDPyw==@kvack.org
X-Gm-Message-State: AOJu0YwCWy4iVEDjKsOr/2Z2dU+DR22sUeIC5C/FVmELujlZMIklcM49
	hFpM/wUj/Qryl+F4Ctq5AcgB9gcjJ3ao8vN0ibDPDZFcve37XaxWg0LycTMgnKQqDkYWq740Zxi
	C1w==
X-Google-Smtp-Source: AGHT+IG5Z3A6R2I6Yt40IaTyInl4VZ3bw90RL9tNJeKgjFFghyeEaG3W+L0zG4oREWZmzmC9PH6Pnqlt3w==
X-Received: from wmbjg14.prod.google.com ([2002:a05:600c:a00e:b0:456:365f:428b])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2312:b0:3b4:5a9d:8323
 with SMTP id ffacd0b85a97d-3b768ee082emr1858112f8f.7.1753267636987; Wed, 23
 Jul 2025 03:47:16 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:46:54 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-3-tabba@google.com>
Subject: [PATCH v16 02/22] KVM: x86: Have all vendor neutral sub-configs
 depend on KVM_X86, not just KVM
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 706041A000A
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: aifsgdwjg8jdch6h8o87d4cqxxmca46y
X-HE-Tag: 1753267638-986937
X-HE-Meta: U2FsdGVkX1+BYzH1LzQGbFhwS//eJa2NLLJpCiEc4Kgf20IbFYLEXxaYg9d9WH5koyCTErntN+mpfARYbl36jSJyk2WiWp0sVKFQSauAQeBS3bGXN5DA+mamVBNU47B7lxrSBnlc9yW+rIFaAEtBjcZGYLseqiODP/iYZBE4JMGalL+t+OX/gH3wu6pigUbbcSPx7TC7oJSfCWPXbynX3IwPLSXejZrN8fFI6pgp63jw71rJF+qbO8NBBpVNCeOCkOp+XXqmI1ZpryKKEs6fvv5cQkoFW1flPkdrUGznnKMlhPulR5BJJmMyI7rqmLJVWPI1qq8PepbbeZzcMmdi9EH/jbYjyXjSGBM85ouoEzey1U1NIsrRr0e6m/pKRJw4EWaZH/4Anl+WcjmAKBpsRlhTZKkloR4bhy8xj/ja++K6WqslDkbrn0xzcI0fU4TWItpT/DzfKdtJjI0ZOWcM7M7f7ycs7yBT05YLd+hfoSiP4DCSOauSoZ6yZgqFOPu9lvuAZhWA8/UvHHH5SMyRogC6S3s7LiDB/Pz8idCk4N7PKws919G98yLF7uZ5qXrJAEIH0P1ejR7WSvWKHJGuMtV1A43cHUkdrt6wv/NpH/0Bap6h7Z0d5nJhCItELW8IAEjgQ9mgAPnbLlpJH1OKN4d3ew3/YIOni+dCm3qWuIv4vJgS5pKcb0Kpa2kATIVvfs9uB0BF0gYkzIdegPWo/TfmljeEA/H+/bx3wt/tj9xj48/UyL06AjinY90agllmc1jSEZkDffFl3FOkL90b3AWTxl5YxI5iCNWt1pzUOy3TSYtKT8X13xn/7Of1fwD18XuRjEMD6cNWrtACtkaBWYRvboF3uAxJRYYBqvtxmKJZbqsrcVdfJGKGYgWUa9OuRykYb8i4j73HdU3tFiSHLB65PDydR7ZFqSQ2pwhq5gV9nulqC9Bsdv89KdJ/kDJrULLIB7mQb5yyD7875oI
 67yQaFdo
 iyaVzI2s9KL8gMb5MN5rMmScQWoWcXpET5c9K3rNGVLazeuWBogqJIVLqgVJGpUDuNqV8w63RlAQL+0yKg0trn2UrOmdLz1taa3/w9vYoWsjY8Cbu3GM6Fs4UZ0eMMLewlLSl9TQqkblKAKGYl4VsQ6EB0W9pTduMBo/Gmatg9FEZwfvpVwSR6wOK1ocFUpx2QZIQzryxUt9FS6tNPpPUDsS+DYSKrsHdNkMeYz+unlI+dtVCkqmMy1t1q+e9luyW1NJDsirHiCsEfVmlIukJHHba3jBZQ76t68VXgeaEuFEtp2EkQzfEBE0gy7FOi7gboLpHKb3lPKr1Ex+RRz9Xt6rwIkO37eyWS2J+SSq5MtBHE6I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Make all vendor neutral KVM x86 configs depend on KVM_X86, not just KVM,
i.e. gate them on at least one vendor module being enabled and thus on
kvm.ko actually being built.  Depending on just KVM allows the user to
select the configs even though they won't actually take effect, and more
importantly, makes it all too easy to create unmet dependencies.  E.g.
KVM_GENERIC_PRIVATE_MEM can't be selected by KVM_SW_PROTECTED_VM, because
the KVM_GENERIC_MMU_NOTIFIER dependency is select by KVM_X86.

Hiding all sub-configs when neither KVM_AMD nor KVM_INTEL is selected also
helps communicate to the user that nothing "interesting" is going on, e.g.

  --- Virtualization
  <M>   Kernel-based Virtual Machine (KVM) support
  < >   KVM for Intel (and compatible) processors support
  < >   KVM for AMD processors support

Fixes: ea4290d77bda ("KVM: x86: leave kvm.ko out of the build if no vendor module is requested")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/Kconfig | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 2c86673155c9..9895fc3cd901 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -74,7 +74,7 @@ config KVM_WERROR
 	# FRAME_WARN, i.e. KVM_WERROR=y with KASAN=y requires special tuning.
 	# Building KVM with -Werror and KASAN is still doable via enabling
 	# the kernel-wide WERROR=y.
-	depends on KVM && ((EXPERT && !KASAN) || WERROR)
+	depends on KVM_X86 && ((EXPERT && !KASAN) || WERROR)
 	help
 	  Add -Werror to the build flags for KVM.
 
@@ -83,7 +83,7 @@ config KVM_WERROR
 config KVM_SW_PROTECTED_VM
 	bool "Enable support for KVM software-protected VMs"
 	depends on EXPERT
-	depends on KVM && X86_64
+	depends on KVM_X86 && X86_64
 	help
 	  Enable support for KVM software-protected VMs.  Currently, software-
 	  protected VMs are purely a development and testing vehicle for
@@ -169,7 +169,7 @@ config KVM_AMD_SEV
 config KVM_IOAPIC
 	bool "I/O APIC, PIC, and PIT emulation"
 	default y
-	depends on KVM
+	depends on KVM_X86
 	help
 	  Provides support for KVM to emulate an I/O APIC, PIC, and PIT, i.e.
 	  for full in-kernel APIC emulation.
@@ -179,7 +179,7 @@ config KVM_IOAPIC
 config KVM_SMM
 	bool "System Management Mode emulation"
 	default y
-	depends on KVM
+	depends on KVM_X86
 	help
 	  Provides support for KVM to emulate System Management Mode (SMM)
 	  in virtual machines.  This can be used by the virtual machine
@@ -189,7 +189,7 @@ config KVM_SMM
 
 config KVM_HYPERV
 	bool "Support for Microsoft Hyper-V emulation"
-	depends on KVM
+	depends on KVM_X86
 	default y
 	help
 	  Provides KVM support for emulating Microsoft Hyper-V.  This allows KVM
@@ -203,7 +203,7 @@ config KVM_HYPERV
 
 config KVM_XEN
 	bool "Support for Xen hypercall interface"
-	depends on KVM
+	depends on KVM_X86
 	help
 	  Provides KVM support for the hosting Xen HVM guests and
 	  passing Xen hypercalls to userspace.
@@ -213,7 +213,7 @@ config KVM_XEN
 config KVM_PROVE_MMU
 	bool "Prove KVM MMU correctness"
 	depends on DEBUG_KERNEL
-	depends on KVM
+	depends on KVM_X86
 	depends on EXPERT
 	help
 	  Enables runtime assertions in KVM's MMU that are too costly to enable
@@ -228,7 +228,7 @@ config KVM_EXTERNAL_WRITE_TRACKING
 
 config KVM_MAX_NR_VCPUS
 	int "Maximum number of vCPUs per KVM guest"
-	depends on KVM
+	depends on KVM_X86
 	range 1024 4096
 	default 4096 if MAXSMP
 	default 1024
-- 
2.50.1.470.g6ba607880d-goog


