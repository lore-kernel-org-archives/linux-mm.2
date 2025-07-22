Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 384D8C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 14:32:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C02996B00B0; Tue, 22 Jul 2025 10:32:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDAB76B00B1; Tue, 22 Jul 2025 10:32:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B17A36B00B2; Tue, 22 Jul 2025 10:32:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A2D3C6B00B0
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:32:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3B4991603EF
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:32:27 +0000 (UTC)
X-FDA: 83692141134.29.0B0F39D
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5B5E91C000F
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:32:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UbI1Dbe+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3-KB_aAYKCIMzlhuqjnvvnsl.jvtspu14-ttr2hjr.vyn@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3-KB_aAYKCIMzlhuqjnvvnsl.jvtspu14-ttr2hjr.vyn@flex--seanjc.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753194745; a=rsa-sha256;
	cv=none;
	b=AyHOx3xQDU+uzHVIJVhp/KZ4/qDJE/2vN1/XwEX2AvPJ8LxgHQqKNfTN+2Q3z63QT9b8Ld
	jugpRMxuEwWMwTuvYUCK0PlLEURWKmtwYmNJO/deUZP8xCCUHJK+A8RC3TmDRWJHz+oxOW
	y6x85AEkc2T172dlqZlj34kNTQl8oFQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UbI1Dbe+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3-KB_aAYKCIMzlhuqjnvvnsl.jvtspu14-ttr2hjr.vyn@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3-KB_aAYKCIMzlhuqjnvvnsl.jvtspu14-ttr2hjr.vyn@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753194745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=se7GGG6+kEUdCY1BG7ucwwvP5WO24MC0HMwFM3DCv0c=;
	b=PfZu/ae7g963ICOe33HKpdrGNiyohAZk5zZ4/0dV9jJ7tpK6u7G4nNHNeLXkHMtrLviRUC
	0rjr21ZAi85YebOUKICrULJqq8ahmYkPGSThKGBm9UBIWbwfQAwQWgloKHG+4Q2q+dKA90
	5+a/pdob/yk6nJg08pXDm17FwI2w/PI=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3132c1942a1so7674547a91.2
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753194744; x=1753799544; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=se7GGG6+kEUdCY1BG7ucwwvP5WO24MC0HMwFM3DCv0c=;
        b=UbI1Dbe+swDa0rOTn8i4ZH3ZBxvNXjbUy8tRhJ3nl4j4UTSuM+moWkJqoSyJLcLOPr
         BrIJzOqgoFTTYZObTZNfI7w8MgxKoY1zpLpe4hNeIfCCHXS9C6dijFrGngPX5hM7ZlTM
         4QzQpuP99HcpyvyyBx1waXpUST2oZDPb9V2nCxloEAz1ETHbcDL9/K2Xw2WtP3MOQdDR
         pyzZX8D1mcqpiaJqSr3rgDXb4hAiXuWab5K0PkAtUl24tketjGcozzBNRxU62CSRQNx9
         b0wTTrjM+PCmkNpamG4AJBt8g3J1AgTN08ki3Vcp8xJ1Rra/msKaQ3JmYmibITF7E+cN
         WP7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753194744; x=1753799544;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=se7GGG6+kEUdCY1BG7ucwwvP5WO24MC0HMwFM3DCv0c=;
        b=pw7s5NzqrRZ8gS1IsEDBZ6JeXOSghM/YxCHdHR3NVJiOEsDnF/QLe00uyGIpNBlYX/
         bSTKLqRQ9dCVwyzHa5K0Xl6e9dfdOK9VSi79FFI+gr9OOcDJsgD1cXVldVY5Fu3AlG5s
         SVVE6jBGVjydiA684Ynb+CLXBTt4OozS0Z8bvuGEpVMBDp4/P6WmSU10yp5SkbSkiZkT
         BqbUD18FV43biYn6bmMW7gpH4qyuDVuee7LFKknd1KoNYLddKSQEw99tJI33wIpcD/K6
         Err5wrXc9s2g77yRe/OQhBr6MqUjOPvALbpN14Ko1hkGmTrpV7ygfqoLaX8eNoIrI0qz
         ythg==
X-Forwarded-Encrypted: i=1; AJvYcCWfxbuNCdOA+FtpvQtRzECuNVQ5jDAKU0jyPvc4E9HEsvU8ATaUFkqgMiqaYXRxMENNVMA1cJjPaQ==@kvack.org
X-Gm-Message-State: AOJu0Yw8LM5wUeHJBp7VV5HJXwuEyi5gP97y89mGYoQtL44SoEsSlfFa
	B7h+uJXnytZSNHpU5cgIty7fKh+aYWJ5yGBM7uH+Xfh7/SMoB50L35/XRdu+qv2vHQHpDNgVPe6
	XW4Dzrw==
X-Google-Smtp-Source: AGHT+IFIvlEtw+vvXuklNdKzQemd9/qAa+tLiT5GFxA8ZHdhEreiJmuSQiQSjn9cwR/4RhPfN9d6Db/7dsE=
X-Received: from pjbqd16.prod.google.com ([2002:a17:90b:3cd0:b0:31c:15e1:d04])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:134f:b0:312:639:a064
 with SMTP id 98e67ed59e1d1-31c9f43748bmr36022174a91.28.1753194744117; Tue, 22
 Jul 2025 07:32:24 -0700 (PDT)
Date: Tue, 22 Jul 2025 07:32:22 -0700
In-Reply-To: <CA+EHjTzNDrwzdpoEuiqvzk3-A7LAsdJ-6y-Gcj7h7+dUTh=6pw@mail.gmail.com>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-12-tabba@google.com>
 <8340ec70-1c44-47a7-8c48-89e175501e89@intel.com> <aH7KghhsjaiIL3En@google.com>
 <c35b8c34-2736-45fe-8a97-bfedbf72537e@intel.com> <CA+EHjTzNDrwzdpoEuiqvzk3-A7LAsdJ-6y-Gcj7h7+dUTh=6pw@mail.gmail.com>
Message-ID: <aH-g9o5hSMvVRxAP@google.com>
Subject: Re: [PATCH v15 11/21] KVM: x86/mmu: Allow NULL-able fault in kvm_max_private_mapping_level
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5B5E91C000F
X-Stat-Signature: ztaakob9ajjeswm5xzbofftdpknd8zam
X-HE-Tag: 1753194745-453892
X-HE-Meta: U2FsdGVkX18E5y/IU2KQVW84jNA35t6HaV4VdpWQex28hVY/NFn5W4JV354bk4YninXDru8qC+PBOnx5ryfvznmIsHhd+y1LupCdrmAl4QZdNJv19hz6sMuCR6lSiZ4Uf1w24RJR9SN1Hlh4dWU0cfrlk6IX6/mGrTkDc9Mqg1hqoRgQSEVIb76yun2LWB2vlMM+gQUishaaIzIP0Mu8QID9KaHzuRbKka7p/Wrgr2/bYf5YIta7/Cr7PoQQua83g/WnYgHdGbCAqL4D00d8Wb/O9cnxPzOnQANhj5VXDDrNvl7tgQ72vmRsRixdCSG74U59bcP3/En8sGkboBsbd8nSBMi9B8ywNV3s4Ml36WZ4Te+mFq34F/WlrO5YFxQpnTVdAocHFrslU+iPoOPhhnxISbM6UMn4tVSrBgqcfpo7a+yLWJyxXp0gnz/6I9ge5TK+OT6RetEQJNgx6aWL8/ZV4Bw5LqZkX5qSCtbtSUA8kggGnfZ8RYf9U3KcEeORA7PI+5OpnmJz0vevLavvQL6RYR3T4fRKhPYtHumynxVIyH8U9HLwfNPMAGNGW+ulPMe01Du46BRCePkq4OVK1Z/2s1c0aFaVMAXs9WSMdUjRxJR6YPpS9g/WTTx+JCmvfNvMm/ZH/qrQ4yES51n2qJuqVsOHQn1PF6s6xP+cL7mHhMnpT1EnddrCoc2FEEZS5uFZBiU+tagj09muWpylj9NAByJ9cRgqoY8Ke8dtaH32LskZD63EpeZih0KBeyHpCML0CAu1YGYUni1pl5IBS1kZO0hEHS1c2jY8G/ptvQ9QI07GOwPj6av8paFus7IMlv9dku+3ctXhMYXRBBa/4rOXgW1yjjm3XrDp1u6re0EKjAQz4NFd+2d1HLXjdCHCzTEBPxXDmraaf9j8qyUJBcFFiCgCe4LJURR8+MAte9E9FLLakDiAeVQV+ARHoBp5qI/ORAGD3W3T50BjoRW
 pAOPPG32
 j1Vd8Io5xmelAhN4Qwxe6Q8ZW0lrxoN5yZrGSLh6YzANR0lcBo/Dph4MiT+KbQc3gkXjprmzR95gTeIoU16EPr/6xH57SzAXFbGapF1PxpULx2+8p+8HXFOhp7kfvos74hycX/Pzwmad1A1+LKUMo5BIR9qYs0LEtIBZb3+rowbRf6LECrPqWoDSb+yE4LG9YFP3gRxzhNCFIOVfRu1l0q+0rcSO7yMKmP+QwkRA1SUj7GTVLM6AjaD4katuea5Jen4mgBstF39wLxeSFFUA1AKosgVLCQMeV+sBoUuGLV1xT+AhpE4bUtiHDczrI8crd7hwTJPGKeO4WczF69iIl6QIfYFvtrYmIUpNmtTK8A4tIiXLk+4xxdWOiXMqn5lgR9A2JUrLG47nUflE8uoJdjr87Zo8B9NrXpYrMh51JTe1moyRcKLX17ilyEgOnWfEhOv2+XsEUQO/AwhD7SGVnqIZcx22umy8l7Uf2RueTjWhFBArlK2ud+PJ2OplG5SeOKu2rjbkp0fHDpi1fIvxynUta3l0wSANZfTX2QrxgrIbY+fNBALcDYCn2aY7lvAT8Aha0lI5s0jQra8hr7oh/gX2xRLEFLJg8WU9Io3xgRDtxFfZvsGu2P1RWlm7NoQxesjSTo/BhM0/OipcLcVlRuZkFbbCmfPX18pMrGXUSq9kEtkjbJEzli6C8xvzWsUfg1EWjGiildGuaMBmAZ2i5mGgnBjSNeNk/f4p3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025, Fuad Tabba wrote:
> On Tue, 22 Jul 2025 at 06:36, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> > - In 0010-KVM-x86-mmu-Rename-.private_max_mapping_level-to-.gm.patch,
> > there is double gmem in the name of vmx/vt 's callback implementation:
> >
> >      vt_gmem_gmem_max_mapping_level
> >      tdx_gmem_gmem_max_mapping_level
> >      vt_op_tdx_only(gmem_gmem_max_mapping_level)
> 
> Sean's patches do that, then he fixes it in a later patch. I'll fix
> this at the source.

Dagnabbit.  I goofed a search+replace, caught it when re-reading things, and
fixed-up the wrong commit.  Sorry :-(

> > - In 0013-KVM-x86-mmu-Extend-guest_memfd-s-max-mapping-level-t.patch,
> >    kvm_x86_call(gmem_max_mapping_level)(...) returns 0 for !private case.
> >    It's not correct though it works without issue currently.
> >
> >    Because current gmem doesn't support hugepage so that the max_level
> >    gotten from gmem is always PG_LEVEL_4K and it returns early in
> >    kvm_gmem_max_mapping_level() on
> >
> >         if (max_level == PG_LEVEL_4K)
> >                 return max_level;
> >
> >    But just look at the following case:
> >
> >      return min(max_level,
> >         kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private));
> >
> >    For non-TDX case and non-SNP case, it will return 0, i.e.
> >    PG_LEVEL_NONE eventually.
> >
> >    so either 1) return PG_LEVEL_NUM/PG_LEVEL_1G for the cases where
> >    .gmem_max_mapping_level callback doesn't have specific restriction.
> >
> >    or 2)
> >
> >         tmp = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private);
> >         if (tmp)
> >                 return min(max_level, tmp);
> >
> >         return max-level;
> 
> Sean? What do you think?

#2, because KVM uses a "ret0" static call when TDX is disabled (and KVM should
do the same when SEV is disabled, but the SEV #ifdefs are still a bit messy).
Switching to any other value would require adding a VMX stubs for the !TDX case.

I think it makes sense to explicitly call that out as the "CoCo level", to help
unfamiliar readers understand why vendor code has any say in the max
mapping level.

And I would say we adjust max_level instead of having an early return, e.g. to
reduce the probability of future bugs due to adding code between the call to
.gmem_max_mapping_level() and the final return.

This as fixup? 

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index eead5dca6f72..a51013e0992a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3279,9 +3279,9 @@ static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fau
                                     const struct kvm_memory_slot *slot, gfn_t gfn,
                                     bool is_private)
 {
+       u8 max_level, coco_level;
        struct page *page;
        kvm_pfn_t pfn;
-       u8 max_level;
 
        /* For faults, use the gmem information that was resolved earlier. */
        if (fault) {
@@ -3305,8 +3305,16 @@ static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fau
        if (max_level == PG_LEVEL_4K)
                return max_level;
 
-       return min(max_level,
-                  kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private));
+       /*
+        * CoCo may influence the max mapping level, e.g. due to RMP or S-EPT
+        * restrictions.  A return of '0' means "no additional restrictions",
+        * to allow for using an optional "ret0" static call.
+        */
+       coco_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private);
+       if (coco_level)
+               max_level = min(max_level, coco_level);
+
+       return max_level;
 }
 
 int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,

