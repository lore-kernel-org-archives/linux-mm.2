Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 989C6C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:47:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E51D8E0010; Wed, 23 Jul 2025 06:47:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 996178E0001; Wed, 23 Jul 2025 06:47:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 835EB8E0010; Wed, 23 Jul 2025 06:47:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6FF5F8E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:47:32 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3A8DB140658
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:32 +0000 (UTC)
X-FDA: 83695203144.14.27773EB
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5BDFD140009
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cHpgWPG4;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3wL2AaAUKCIk6noont11tyr.p1zyv07A-zzx8npx.14t@flex--tabba.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3wL2AaAUKCIk6noont11tyr.p1zyv07A-zzx8npx.14t@flex--tabba.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753267650; a=rsa-sha256;
	cv=none;
	b=vpIHIKhEHx2YjuMQJiAr+s/Lg55lvdlK+zu8u9UEm2Bs1kmRhjQyH3XxnQzVjsbHePZ2KC
	yB18c7ECycHccs5i8o7roJVL+JKn02x++ke0D2seP2qDe3iJV5HLAaVB0ciCuDQ21cpET+
	PmaEd45GXfRheh2X2cy+s4ZM6T9OYIY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cHpgWPG4;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3wL2AaAUKCIk6noont11tyr.p1zyv07A-zzx8npx.14t@flex--tabba.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3wL2AaAUKCIk6noont11tyr.p1zyv07A-zzx8npx.14t@flex--tabba.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753267650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lQQDV4zydkRfplEEJZqHClNg8epmyuBAYmjUZ8gGwtc=;
	b=juhBkUK1jkWXjFBVDBjf3YLuIje1RqggXsDgHtcPyUss9Mj6OpKyTcx86ihsdX7E0RExoF
	hU9KW6BW+Ac1sJZLH4Bwq9eWtzxdYaGrKrdv5UsA8cFhueLEH95KFUnUr6JW/LSU1U6WHK
	DSHHw94g6Bb1Rgz2iXiPnJgC2KRZreU=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-ade6db50b9cso682980866b.1
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267649; x=1753872449; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lQQDV4zydkRfplEEJZqHClNg8epmyuBAYmjUZ8gGwtc=;
        b=cHpgWPG4CqOwJo/hFkJXr21uZsCV5ZkmAaJaAKpJiMbSAvuukHgImHrxCQcHgeo/z2
         F7bexyDV2pFBAFQStBWMiVbghsFgdIhjZeOCV3EITxjCBwHRAO7fjVIIlQlaRzW6MDfw
         GrcUmDWbSsynoHUPfVi4jnSpfcz3MN0uBIoWMh0/Px9EAFqeba44Xy8g+YINNqdaltB8
         6DixUu8w325BTfxoglvVAJs8E3TjyOsVDulfXJsoOfDmaomcZ6Jgmf31vJNzD1+QvMFD
         l/JIPzG1MpFP6DrmHx2k1IfASvWOus326LRtaZGl4yvxMDDj+/SWh4L8MdwAhXTnM1MX
         Tg9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267649; x=1753872449;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lQQDV4zydkRfplEEJZqHClNg8epmyuBAYmjUZ8gGwtc=;
        b=nNRVs7nIO6X/eN7KIPDd7GrAwmRCEK8nZ4HZmaZAAYjzuNHQT4U5c9/ac++zz8pPsz
         lgaASUzjBXQed7bypNkefgdm3aDNzeANMQCdDdj2TiwH39Nw3rgeNVHFJmzznVcFswTA
         RNmkTTfOwZOe8uKHEfMATK4SdK2/45i0zThdu1yAqCQ8mu6fa/WHvHa3zDJ7qJ9BCeZX
         89ERlHvrwT8LbY5zzLkmmji5udmqSktPWX1rjivjiunLVbQsZmSNTgsC51/U/NgUaDxb
         8oRxcJ6flwoS4Vz33te5kneUWeRVrkuzCPGTSgFaSKH0bdRz7QytlaknhOqjZTgrkwHR
         e/hA==
X-Forwarded-Encrypted: i=1; AJvYcCWip7/djJUQZJB3ZgJcbdpAvGm0YF/fRHK2UenqOyg43a+ltDtFRR4UECc+uYxS3K7O63nRrW/EBw==@kvack.org
X-Gm-Message-State: AOJu0Yzrxnyagjtdz8SgU5aXWK8IsGl/cD2Xoe4pnJlCZDH46oK4OigC
	jMq7qAWDjuSlHAQhUJKAGMNxHR/aXOypJCDZSL561Vcc0LcLG4a6QkBT53oi5ezjKtuWhXFFKVB
	i9A==
X-Google-Smtp-Source: AGHT+IHUARfg6/5ZFJQc2SIXy/3Rb3LhLodoPi1Lw4aDiFctD3VlOj53YvljiGL2HPFj4hs52zuLJqVWPg==
X-Received: from ejczi1.prod.google.com ([2002:a17:907:e981:b0:ae3:c5c3:8b1f])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:934e:b0:af1:1dfd:30f4
 with SMTP id a640c23a62f3a-af2f8d4b141mr169166366b.47.1753267648787; Wed, 23
 Jul 2025 03:47:28 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:47:05 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-14-tabba@google.com>
Subject: [PATCH v16 13/22] KVM: x86/mmu: Hoist guest_memfd max level/order
 helpers "up" in mmu.c
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
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5BDFD140009
X-Stat-Signature: c11hz81iqjjhi6ry4kg8brmf7ztsdty6
X-HE-Tag: 1753267650-958824
X-HE-Meta: U2FsdGVkX1+rU8oTSGS1eIjBaTNyeChVIM4ppvzZetui9iRzDgF+PEdovQZEmjJSEcZKNuybB3XY+AUpGGmRS1CB/7L2UpTll2yx9/1Rof5M4PcpX2ExSifjcgfq8QEvyLnXtdQGcPG50R7g3Eragh2nO1K2rRYm7XGdH3O7h7c4Sui1TdGmhuMOAN2yXzs0A3OnkjBAGvg4Hb9HDA5wLDcT/zHGj4/JdmGSWR+dP4YKn5PmWVMs8doh1RjVzroQxVJ/CzAuU75UEgdlpVGXM5ODCO55karHh2STo92Rq//hntRCptQC0EE2xxvxVFe3ai0ihAaEUMu2TJkOBoWcuCgRp65BM0hoAhri0pFKSGCDEqDOg8KyjWl8BzroNmCNcM1EyZ4ATTGGtcsHCkZIAGAuhP/104N5wq/gseAxR8ho/hTZeiywNkzIOCsfNuolLBh5Bovg4xCHFpd+XoU1UBsq37ouDQcMQNyAsURHIY2ZDEeaKKiz05pT0pVJOmJUADh7RH8pLsWPgn2ZXtx0HwslJbMEnQbb6CXNWzNCeXQW1M4I1+/8aSmufzzs8uQ+0tLiWbsiJweuzOjLQfi5Mce83O9HCyqTNqASW0rs64QhnXGJNDwYtes/QbMCYSZXjOFLnvNzTWLNpLrKNf+oRKnhIhEPWEs0vJbHaNFcf8oTtwwRB9Bkpos8YzdcmRg3D3WNmcW8qsRhI2qGQtteqRpdY4lyz4DPcahOohLgS9GQFrAZ7v1saGFk29A1iElj457T6tAZ8q3IOoXi2XobKIZgUqUvuoN3nQI+sPIF1uF8Cw/wnJ37C/CRVKFzzJB9Rti8aLify78kUDbKamhIMXigRD12wTiIpGmGkqSu/fhr7JaEA4uf0nxPoo4XNv4VeEnnbUg+bZqsBr9O2hQcqslg+XLVxVzRkP0Ikpr8jbo486Ejmh7h4JFhR1tEMawRBxw3e0c2TJEy8ttqK3M
 GLOBGec4
 nBQJ5bX54w8XLGRbtxm/FqV0P2ErVj/TNgvFPGxbTiANBHIcvZe1PTzHKvJTvadwXS5PaHBlBZGQuzhm3dxkIQVM3WHIWJ297GinZq3+xKFYP8B1uDT4I9XxkRVVyzFlfWICuGXHSP7IhHQeAW22Ud2XbYUK84x1SRSxb9XOshgOIkWEAyqm03sCHuRcWD+/fsJDzlhkzG0IO7LXEuBHEVRku4fSx23EG9p7KSPqqQ71UaS8qsk8ZC+i2x0iABZOzdlm2NC3l46wauUkxdK354DP3ZjhAZs4Kt2PhIDJUkUdejIL6kMNKOvMvEM4/8R6aApwlHzwBLRcrK5nMV2ORH2PVEBtj6+kWytmuOgUsQEI2BPM0AT60GYrOv7xqeDu613MBibGLrtxrTARIfxpfdcHKZdlsyqzzZktkeSQ1xOhoYEOdltU4yDpkiR1gPy9e8dmN+mS8L2d6VxP9jZEgjr1sp8G7uflX9+G8FBoCCn7DWYPyIlCJiLNlYGNXrNakTgGmZ2munSweVNZGunwI31LI+kK2Z+k3ow9CDd/b2uRGu0VGchcf9+ZKrwdxN+WByEBr7HGOclsvXmukK8dpKeif5TTaLlJQgUsG+jTNKgJAEcEPqGCNiAu+ZavtUunmnEIA+HY+YOzZb1M7BoVnTgzvBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Move kvm_max_level_for_order() and kvm_max_private_mapping_level() up in
mmu.c so that they can be used by __kvm_mmu_max_mapping_level().

Opportunistically drop the "inline" from kvm_max_level_for_order().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 72 +++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b735611e8fcd..20dd9f64156e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3285,6 +3285,42 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
 	return level;
 }
 
+static u8 kvm_max_level_for_order(int order)
+{
+	BUILD_BUG_ON(KVM_MAX_HUGEPAGE_LEVEL > PG_LEVEL_1G);
+
+	KVM_MMU_WARN_ON(order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G) &&
+			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M) &&
+			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_4K));
+
+	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G))
+		return PG_LEVEL_1G;
+
+	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
+		return PG_LEVEL_2M;
+
+	return PG_LEVEL_4K;
+}
+
+static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
+					u8 max_level, int gmem_order)
+{
+	u8 req_max_level;
+
+	if (max_level == PG_LEVEL_4K)
+		return PG_LEVEL_4K;
+
+	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
+	if (max_level == PG_LEVEL_4K)
+		return PG_LEVEL_4K;
+
+	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
+	if (req_max_level)
+		max_level = min(max_level, req_max_level);
+
+	return max_level;
+}
+
 static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
 				       const struct kvm_memory_slot *slot,
 				       gfn_t gfn, int max_level, bool is_private)
@@ -4503,42 +4539,6 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 		vcpu->stat.pf_fixed++;
 }
 
-static inline u8 kvm_max_level_for_order(int order)
-{
-	BUILD_BUG_ON(KVM_MAX_HUGEPAGE_LEVEL > PG_LEVEL_1G);
-
-	KVM_MMU_WARN_ON(order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G) &&
-			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M) &&
-			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_4K));
-
-	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G))
-		return PG_LEVEL_1G;
-
-	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
-		return PG_LEVEL_2M;
-
-	return PG_LEVEL_4K;
-}
-
-static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
-					u8 max_level, int gmem_order)
-{
-	u8 req_max_level;
-
-	if (max_level == PG_LEVEL_4K)
-		return PG_LEVEL_4K;
-
-	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
-	if (max_level == PG_LEVEL_4K)
-		return PG_LEVEL_4K;
-
-	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
-	if (req_max_level)
-		max_level = min(max_level, req_max_level);
-
-	return max_level;
-}
-
 static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
 				      struct kvm_page_fault *fault, int r)
 {
-- 
2.50.1.470.g6ba607880d-goog


