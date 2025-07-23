Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D4A7C83F34
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:47:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E29538E0003; Wed, 23 Jul 2025 06:47:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E02408E0001; Wed, 23 Jul 2025 06:47:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C53868E0003; Wed, 23 Jul 2025 06:47:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B150A8E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:47:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8846F5A1EC
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:19 +0000 (UTC)
X-FDA: 83695202598.08.A3BA962
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf07.hostedemail.com (Postfix) with ESMTP id A4FAC40005
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RrpITApR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3tL2AaAUKCH0ubccbhpphmf.dpnmjovy-nnlwbdl.psh@flex--tabba.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3tL2AaAUKCH0ubccbhpphmf.dpnmjovy-nnlwbdl.psh@flex--tabba.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753267637; a=rsa-sha256;
	cv=none;
	b=4NNSBEzmV2WtMaZbQM62xXz4a7rrBM/N9SdNkrZ+mHYJ4RYmoG4W87GVjhbq0wAUhrNlEv
	ZK27ccYkHwhbWO5aUcGgPNIUnlPumstduszaqm89pD4Etgeld2RGs70g0EyP0sAxzbGcPG
	2efKYcC836rxmCk/y3NhZ+M8zras8Vs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RrpITApR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3tL2AaAUKCH0ubccbhpphmf.dpnmjovy-nnlwbdl.psh@flex--tabba.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3tL2AaAUKCH0ubccbhpphmf.dpnmjovy-nnlwbdl.psh@flex--tabba.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753267637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ZSRmdf1Qs4xkVVhkcvJHkezUtgT+XJ93s4MNrjIOM4=;
	b=7psm19AXCMQSA7laFAK2ZciTY0QFhX1xUfNHfg+Ftl5dujSEqOEMWuZBUAVplS4hDuViXt
	UJ2vO2wphxGDc/fuK22s0KVBy6tzZnpUqOx2yOWLwImenpfHw3a+MEnS6LCMaES+tL/pQr
	axom6w5wvPdwsL9jH4WvYYuZFhb/k/Q=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a4f6ff23ccso4252303f8f.2
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267636; x=1753872436; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7ZSRmdf1Qs4xkVVhkcvJHkezUtgT+XJ93s4MNrjIOM4=;
        b=RrpITApR2QrvoKBPP4A1XLP/n/SGEXSMkEDApUb3XWrPX/RbgkrKYeuqbcUJ+RyG8/
         dIE6C6iAomR70Fir1ENu7oXZ4atFgZ0HVI5q2FFhuAbM5Kan2sPwlHsjMZPjOm3eJZGy
         3zg9Y03JkKsD7kDz9M8zIKiqREONEIv6ROlexKwaMUImV0Wl2+RNO0o0rdClESTggUyO
         +2sJQkOklfgHR7T1g9fYn0SfFYsNNeyDzc7DGnwlnzSQ9vxG2TrrVkrRwdoLLvQZfrAw
         ZoFZeC7H4beZPQqkK28jR2HjOeRHLHupPRcRZGgcrwN23QRhpXeukZgdumRjb4aICxgY
         89Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267636; x=1753872436;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7ZSRmdf1Qs4xkVVhkcvJHkezUtgT+XJ93s4MNrjIOM4=;
        b=ekI/5HAmhemDcvH6oY7/ixQIQvbFEGtH+TVKBYNigu8P6qTklzWhZMAiR/pVshlhku
         +XMgJHU5Gb7QHCUclvUBbAdSwWgMnYV66AgQxvRN4q4WBr6olxzil2qOFKlXvvoRN6A6
         5yUeFbkP6aN8ExS2ojlRzIc5yCqxp1BDBSxQ1ILM3WqIXFjh+Hk6ctBmtG6J2FM9adf0
         m3gFvo/WRmrDK+FFfY7o8xoeind4wwc7xH3TU5zO4bVlcLXpHlecYVzZznTIfTVJuIKC
         ym/gkHhIgN1dDfYLnlQsN4NeU6UCzDVOmokqkwy3WSKPz//XAUH9BPzD097OYB3YXir1
         /KYA==
X-Forwarded-Encrypted: i=1; AJvYcCVgHcRU3bfW4IW4/6KM355fkE8DrJ6cVX2gCcl7fDCHmgFO9XRW5QjsvvN0gCK59MB993KsbT1BAQ==@kvack.org
X-Gm-Message-State: AOJu0Yz36GJKevtMQa9M/N1+ZbBWzj2MLHo5mMtV24zr92I64mFmoaFL
	0+dj9MhYBGDj3whruwDdV95VjmQ4BceIzZuPcAslYfKbRSXo0ALrmnXVKZTGRNJf8QS/V1gl0rt
	/yQ==
X-Google-Smtp-Source: AGHT+IGKHq0YkjOM3jnj7O/rIJyldYODUZMG9G/AEIG2YoV4TQj6EowfEXg4QShiaMq6zzhKOVJJ0yiVZw==
X-Received: from wrms6.prod.google.com ([2002:adf:ea86:0:b0:3a4:f6b6:15b1])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2c06:b0:3a5:1222:ac64
 with SMTP id ffacd0b85a97d-3b768ef6c83mr2223885f8f.38.1753267636044; Wed, 23
 Jul 2025 03:47:16 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:46:53 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-2-tabba@google.com>
Subject: [PATCH v16 01/22] KVM: Rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GUEST_MEMFD
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
X-Rspamd-Queue-Id: A4FAC40005
X-Stat-Signature: 4b3gkczxqqjm5gnicu5y81j4z7i8cn3b
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753267637-394221
X-HE-Meta: U2FsdGVkX19oalB2Cp7K2sJvYoC5SxHsDT4xxmYFFiAeC+ProV3L8lG8yalTlClYOiGeTAo6tA53wot81Ef1Cw7+i2FE/QoqL83QGb5UReR1bPisdliJy915/1qS9ImkS/sl0ggv9Px0qltuCdhNRTuKpq1BYfZ+Sn456EFrGJ3ma8t4h46RK/io86zNg9qn+mP00aRZ+UZYWM+o9P065kbGCpLdDfoAgw7/4vf1kqrqDK2dn0cakx5N94nKzKYzR8L2eCuXzc+nLFZ4jDxOOUmc7lsfX4dWAGsUOE14t3QI8n8GSwMa5lyCQXoFjjR9b/c4H0mwem57vtgDD9BhLqw7kDj2PEESNruNO8mJ3K70tbGYqCDSANSdq3bMg4xVxSbcCR+kDSS7g/wKh5DYxpvfU+rIg5iYp5CJGo40rWS+xJ7DNFw5aLS79xrJYXEXo2KCKS/DlPbcx2D0aeG7bSpxr4QjJvz5wsqChCn9qVhDBr5HxF7zS/Cy3cf2OoLU6pTxtzkV6USkgvko2ee2glOPIhMI4AxxYnSigcbyQB003wPbvdsep9OPJ59JNGWOmz4jjyDFeUIT/vRGttRkkcthyMDsiZe1iSgdR/RAkRYj0g+r0kbJWvnto8C0XCSxemY4Z5hDhhc/fvBvMGlJZIwmexqOP3N4ztddI8ZOCazm6A/ziM2veK3YnWasHNz3PbUYqepFfncZh+5RtybQcwbszG+Hn5qIfQwqvrwgLmi8esQtPqy3jshhi/ZUd1bb02EkTMBhJZlb/7MwqlNG+VTYP/MrdHEt12e4dMp21O2CH0rwxar5ZRQt7FDM1DN8KY7yF7z8xkUkCedmmWs7BD1jUIy8mqHHchszQd0XvcLst0w/TgfaDbFSAqCP+Jd/GzY/IYihnmyIsU5N22B5L7rO6GSZlNjgyCnj/VA0BH4gWTiP6z3scWZCBzlL4Ai1Ivr2Dl6k8H5BMSqpUFT
 dTWRyzbj
 JsuHc3XkzWz6X0dlcr9zENCkgNw1O4b9PeLxLNrYAl9D4yA9OTlT2kNY/5xYYxwy8QR0SaFQ3ZNISfPf04NWRLMzsqz3wMN+avgDmtIJP+hGoBQ+2HHl0OkFGhFC2BAdn+GNmqp6Gz9w/0nZBLvzNfmM98cJWjzgRFPP1ymEMdN4GmoiXnFnLIvoqviTO1ltcnJLPmpOmWoJeZYtJAM5noxlE0zgPCt/xVVHtLWXZf6MPQdHp953WHGk7s7loYzfN/orJfcC4lW3aDQj3e7t9Fxw5UkHS8i8m2cLVFHlU3d6O0I/fgDwtfggGMXTmSRvk0z9ZgK11340o5o67dQOW2phpwC0Gbrw5xwa0f30GOUazRvafQlVpcGx7H71SYtC3yI4UIcLGu+trChtdEnGe1ie941ycRbeawI6/q5ZwrffPGI2J1ofZ5UGG36hL6XQHhJ45ZxppKgE5jY5zjWnSP9zpjvO8GHEwe4ErAEoOSx2LYFZpBb63j38qhuvyCvEgO16NayXGhlvUZ6qwmqt82Fus0mB/XKDH4pEDGTb91JX/2bSmpqZPVaCjna1t8AXRn6UZTJU627jjedK4BusQEv6DYPD4dHsdLA/D42m7IL1JYXpR7Sxa3stOEe1NyYzUOF2JVjnBacnuvhnxiOPZZmU/JohA007V2OoYrPUqsoY8jBY9F0/hNbicCtzWuf3bXXriCYO+j4I8oMNPeGzm7G9zFtByFE1xH8iZ+cLLReX1HKIH6oudUUo9HA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rename the Kconfig option CONFIG_KVM_PRIVATE_MEM to
CONFIG_KVM_GUEST_MEMFD. The original name implied that the feature only
supported "private" memory. However, CONFIG_KVM_PRIVATE_MEM enables
guest_memfd in general, which is not exclusively for private memory.
Subsequent patches in this series will add guest_memfd support for
non-CoCo VMs, whose memory is not private.

Renaming the Kconfig option to CONFIG_KVM_GUEST_MEMFD more accurately
reflects its broader scope as the main Kconfig option for all
guest_memfd-backed memory. This provides clearer semantics for the
option and avoids confusion as new features are introduced.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 include/linux/kvm_host.h        | 14 +++++++-------
 virt/kvm/Kconfig                |  8 ++++----
 virt/kvm/Makefile.kvm           |  2 +-
 virt/kvm/kvm_main.c             |  4 ++--
 virt/kvm/kvm_mm.h               |  4 ++--
 6 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f19a76d3ca0e..7b0f2b3e492d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2276,7 +2276,7 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 		       int tdp_max_root_level, int tdp_huge_page_level);
 
 
-#ifdef CONFIG_KVM_PRIVATE_MEM
+#ifdef CONFIG_KVM_GUEST_MEMFD
 #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
 #else
 #define kvm_arch_has_private_mem(kvm) false
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 15656b7fba6c..8cdc0b3cc1b1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -602,7 +602,7 @@ struct kvm_memory_slot {
 	short id;
 	u16 as_id;
 
-#ifdef CONFIG_KVM_PRIVATE_MEM
+#ifdef CONFIG_KVM_GUEST_MEMFD
 	struct {
 		/*
 		 * Writes protected by kvm->slots_lock.  Acquiring a
@@ -720,10 +720,10 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 #endif
 
 /*
- * Arch code must define kvm_arch_has_private_mem if support for private memory
- * is enabled.
+ * Arch code must define kvm_arch_has_private_mem if support for guest_memfd is
+ * enabled.
  */
-#if !defined(kvm_arch_has_private_mem) && !IS_ENABLED(CONFIG_KVM_PRIVATE_MEM)
+#if !defined(kvm_arch_has_private_mem) && !IS_ENABLED(CONFIG_KVM_GUEST_MEMFD)
 static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 {
 	return false;
@@ -2505,7 +2505,7 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
-	return IS_ENABLED(CONFIG_KVM_PRIVATE_MEM) &&
+	return IS_ENABLED(CONFIG_KVM_GUEST_MEMFD) &&
 	       kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
 }
 #else
@@ -2515,7 +2515,7 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 }
 #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
 
-#ifdef CONFIG_KVM_PRIVATE_MEM
+#ifdef CONFIG_KVM_GUEST_MEMFD
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
 		     int *max_order);
@@ -2528,7 +2528,7 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 	KVM_BUG_ON(1, kvm);
 	return -EIO;
 }
-#endif /* CONFIG_KVM_PRIVATE_MEM */
+#endif /* CONFIG_KVM_GUEST_MEMFD */
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
 int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order);
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 727b542074e7..e4b400feff94 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -112,19 +112,19 @@ config KVM_GENERIC_MEMORY_ATTRIBUTES
        depends on KVM_GENERIC_MMU_NOTIFIER
        bool
 
-config KVM_PRIVATE_MEM
+config KVM_GUEST_MEMFD
        select XARRAY_MULTI
        bool
 
 config KVM_GENERIC_PRIVATE_MEM
        select KVM_GENERIC_MEMORY_ATTRIBUTES
-       select KVM_PRIVATE_MEM
+       select KVM_GUEST_MEMFD
        bool
 
 config HAVE_KVM_ARCH_GMEM_PREPARE
        bool
-       depends on KVM_PRIVATE_MEM
+       depends on KVM_GUEST_MEMFD
 
 config HAVE_KVM_ARCH_GMEM_INVALIDATE
        bool
-       depends on KVM_PRIVATE_MEM
+       depends on KVM_GUEST_MEMFD
diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
index 724c89af78af..d047d4cf58c9 100644
--- a/virt/kvm/Makefile.kvm
+++ b/virt/kvm/Makefile.kvm
@@ -12,4 +12,4 @@ kvm-$(CONFIG_KVM_ASYNC_PF) += $(KVM)/async_pf.o
 kvm-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
 kvm-$(CONFIG_HAVE_KVM_DIRTY_RING) += $(KVM)/dirty_ring.o
 kvm-$(CONFIG_HAVE_KVM_PFNCACHE) += $(KVM)/pfncache.o
-kvm-$(CONFIG_KVM_PRIVATE_MEM) += $(KVM)/guest_memfd.o
+kvm-$(CONFIG_KVM_GUEST_MEMFD) += $(KVM)/guest_memfd.o
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6c07dd423458..25a94eed75fd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4915,7 +4915,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_MEMORY_ATTRIBUTES:
 		return kvm_supported_mem_attributes(kvm);
 #endif
-#ifdef CONFIG_KVM_PRIVATE_MEM
+#ifdef CONFIG_KVM_GUEST_MEMFD
 	case KVM_CAP_GUEST_MEMFD:
 		return !kvm || kvm_arch_has_private_mem(kvm);
 #endif
@@ -5352,7 +5352,7 @@ static long kvm_vm_ioctl(struct file *filp,
 	case KVM_GET_STATS_FD:
 		r = kvm_vm_ioctl_get_stats_fd(kvm);
 		break;
-#ifdef CONFIG_KVM_PRIVATE_MEM
+#ifdef CONFIG_KVM_GUEST_MEMFD
 	case KVM_CREATE_GUEST_MEMFD: {
 		struct kvm_create_guest_memfd guest_memfd;
 
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index acef3f5c582a..31defb08ccba 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -67,7 +67,7 @@ static inline void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
 }
 #endif /* HAVE_KVM_PFNCACHE */
 
-#ifdef CONFIG_KVM_PRIVATE_MEM
+#ifdef CONFIG_KVM_GUEST_MEMFD
 void kvm_gmem_init(struct module *module);
 int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args);
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
@@ -91,6 +91,6 @@ static inline void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 {
 	WARN_ON_ONCE(1);
 }
-#endif /* CONFIG_KVM_PRIVATE_MEM */
+#endif /* CONFIG_KVM_GUEST_MEMFD */
 
 #endif /* __KVM_MM_H__ */
-- 
2.50.1.470.g6ba607880d-goog


