Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85792C83F25
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 11:08:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 216FA6B00A4; Tue, 22 Jul 2025 07:08:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C7FE6B00A5; Tue, 22 Jul 2025 07:08:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B6E96B00A7; Tue, 22 Jul 2025 07:08:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E95EA6B00A4
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:08:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B5733160354
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:08:46 +0000 (UTC)
X-FDA: 83691627852.12.5849ADD
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf23.hostedemail.com (Postfix) with ESMTP id C7991140011
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:08:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2WqSUhkp;
	spf=pass (imf23.hostedemail.com: domain of tabba@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753182524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q4OlHSsQD8Q3GzLrFxGBtNoCw1qRv1k2dQlrD5QI9ZA=;
	b=eXzoVSGA4J4Eefn74uDYzEGn5shdlG0TX2GHfa7tW1MKsqR7FDvO+fD/d07eumigM8Ay9O
	6+DVMmZEuq5VoiY9hZ5tX6XugefXa/ffeSiJkgyKgUny+TF5Fk9GKIuGD/qxUJKX+sHm69
	mENenvx5Qe06AE9P5IVnlLmaKDloaCM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2WqSUhkp;
	spf=pass (imf23.hostedemail.com: domain of tabba@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753182524; a=rsa-sha256;
	cv=none;
	b=I8m/fsQzPlwuNIq765lxFVQrVuL+dh+tpl5XcTSXULWR84kXCbiD2iXQrHQ5ruMLDEN4yr
	ClTA6+4XCpHTtUhHEjRDqvRBmtknqzA8oVp4q1ZE1k287HaQGNyiysxibMz4oqwIdfRECO
	KgmeKCdhjI2osr46+xBqGPaJQY6BkzM=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4aaf43cbbdcso147631cf.1
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 04:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753182524; x=1753787324; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q4OlHSsQD8Q3GzLrFxGBtNoCw1qRv1k2dQlrD5QI9ZA=;
        b=2WqSUhkpMP1N20MYnP7cL3V4rsQdXKfmvcdc0xzHnencsnxAiGiP8f/O93IQk5DPeR
         u5gxfdRsHZeWSGpejgvMMtEewhxfvERR5HfDt2jDelS8MHLpLuROcWP+aqpNPWgPUJLB
         jnPx4XBjG+19JnubZ1N1t15glFmQlkz8cizc9Alio9L3nmQLYo4FpwEEjvrIMhSV4rHg
         lRex2EVXpnp69cQ1vxGMvzUBgIFIC+utAbMo/pZb95vnhkgZJZBk45PFS9LhuKv5elqs
         G4rHwB8q6JivmpxOnkwQIIH+Y+JCqMTicfU5/jVZCRXbzy9ZkneriTKCa7Mr2Adzc9xD
         EyBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753182524; x=1753787324;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q4OlHSsQD8Q3GzLrFxGBtNoCw1qRv1k2dQlrD5QI9ZA=;
        b=K/7UADli5sWn77QqrCcAx0haydXvdv1LBgjynzTWGF2Gc99Nz3E7ytmOli9Ute5bR7
         mcOw3ynHnM8XUWgx7QIF0dTPYmr1VbNQa7H702TUza5iyi8hl0oa5d+Mz6qjPeTkgAeW
         9owrCl24mYfpM4KYV8J12FNTZ3NDXkolrcrb7bjJc/uViAgUz1w8pL1vVCGFeEY7qSCD
         BviwRMA7yL5Kjxv1By345p0pYQ9wbG5OuKN5X66FTnyYjz6GmH7I+rW2dQs1fX8KOPtX
         leTzVop8DfPRaC892BJVs1DSt+iwykcqHODHtoweRXblO8HSt3dVPQtiAydVc8UiZYlp
         MR0Q==
X-Forwarded-Encrypted: i=1; AJvYcCU7HE8iuEL+Sp4azfq4b2pVA0xfrAxNKg3yP7XvOZAkTYr/7GEokNTSWtzY6S9MZlyt+qNZEgErPw==@kvack.org
X-Gm-Message-State: AOJu0YwnLlaGKx0nCTWV/8ovs2OEwM5DIT32t1z8CaL/YIS7NfaakQPz
	0rT/1J6MoOBy02tBDN0+v2YihVPoneTZHJubboVuBEjbAylrFgDgFLClDxmjVwgFrFaAo6+ut/e
	IEUu0EBZwWXbaqmrZMfMkxuROHftx0WfSzj8b3CuZ
X-Gm-Gg: ASbGncsuX3Y9zwvajO/YK4e+ZehCInbE+TBdQhAl9d4U0qzPpxsN8q+EXjGKulIGu/B
	lJwCLQwSKC4YPLpTzlyNiycqY9i/MmS9OzxixPYPm3x/7SbHSCIsyyQ+xA35HnRFJtMRHqDttWe
	XTQpKv7VzxhrVTe3jUW0zTZPF7eNvId4ITr06Mmzg257hCuPTnQt+T/8u70Q9h4QA5Ky/H2wP5A
	QROLlA0oRYJ3yCpo3P/S2GmSIa5HyvkXTaL
X-Google-Smtp-Source: AGHT+IGUb3iz4a5qMCYNx1u6U7GTJFpP1c5NB9X/RTiomiZ52K/XsGtaFjte5gDNRBdO8xNk6Dmgs2XbsK+QW4EU7aI=
X-Received: by 2002:a05:622a:8359:b0:494:b4dd:befd with SMTP id
 d75a77b69052e-4ae5e2ca83dmr2714601cf.8.1753182523270; Tue, 22 Jul 2025
 04:08:43 -0700 (PDT)
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-12-tabba@google.com>
 <8340ec70-1c44-47a7-8c48-89e175501e89@intel.com> <aH7KghhsjaiIL3En@google.com>
 <c35b8c34-2736-45fe-8a97-bfedbf72537e@intel.com>
In-Reply-To: <c35b8c34-2736-45fe-8a97-bfedbf72537e@intel.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 22 Jul 2025 12:08:06 +0100
X-Gm-Features: Ac12FXz9tmJwpwAgcImOsShRgOCpw0ZxfeluqVRurIjOexvh31HNQ0n432YkfPI
Message-ID: <CA+EHjTzNDrwzdpoEuiqvzk3-A7LAsdJ-6y-Gcj7h7+dUTh=6pw@mail.gmail.com>
Subject: Re: [PATCH v15 11/21] KVM: x86/mmu: Allow NULL-able fault in kvm_max_private_mapping_level
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
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
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: jrorp465uk1j8y7t5kt9uu9dgngpj7gx
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C7991140011
X-Rspam-User: 
X-HE-Tag: 1753182524-913290
X-HE-Meta: U2FsdGVkX18IQ6xu0I+9RkWmUS7hPiDGenCkDiZvTwaRg4VUuQ7EWpa89sJF9W2X9nGtr4Rurk93AhiVMEiVlyb7eXqjBuq3o6nVIevsSWRqofPjsd763hQRVjgTBHfgNFYZAuShUUb2YWSS26lVbSwR6ud6XOl3tCsg++xs+Z2Jj2pQzMhSmtF/RtDhU5ytnqMJr4nMFS+hgeAX4rKgvt6nUbnGvz44I+ZJdcBiEb0/VqP6HydxmID44zxRHrhY1gezf8KvMymZwoFkn1RgUOo1MBQkIi4lyLl9Orw2uiN/JOJszSbp1YiqUyIA7QV1E/EZoubrX4+0CdiJjOlVHt4TgeaWmdWu9L6h+Rcl7WK1nTkAGiEenSRQu45+talDRwxI+nhrZqlNuGc2ZPkcLg3fZOa6+rTG6cMZCOaluB/I67aw4m9LqguJvE0mPh306RUPiEtnk+wCvHDcu0nmGQeR7czp37E71bDXw3BMm/Ufb4yYQidQkxf731WIHZ8+/tVURXDgrWwp/mDJaZnr7eotzJnUGFiDIYEClPthDWfuXf6RJLwwZS+YKpalbWG9MkQg85AgvvgbXahxFDp3EehgnUD8F1w3yIHx1fgnO2Y36R+OwpP0xUIPBoPDzTxl1c2Jolg2Kgxe+WEXSrouaq9JZ7G/WiNEVki3EpiN8uAVQCzi2j6GTo86wqDsevmtikmy14iDqVloQkTOrhh5KhDNfPAoh50cfTf4HS1pvo52NJuWT4ctREFg/p8xmVlZaxPuBXwh8emgh/j509cpQdfSCILbBSYEA7FK/RFr4slTPkmQXX1DSCT5ncJJ//PZzPVpQbqvBXEeTIVd+KiuAbetMl1Aelvnkk2wnmndoivl+WcrqfD07deT6WSDZZLhf9CYxi0R2Xy0WErg9LHNQKiHmYnC2TLDCS2OjscqYOmTmwnYavFV9ONIFjXaH9nCVWIBt9WCo+vYUpdjr9W
 BceTqwrG
 AKa3+6Lx+/VR5g10ulB7s78R0+tf+mzOARTOGBBAaamTdoD2QUmyr8/s1LmnyRIj3TBVZTiFkTIFYSwTaRX+EHIoTBtDMXguVBc3cwO4D5QFLspsbgRiwdcNIqh9NXWEtuIX1akWDQBMA81tkomkwycWf75nLy/FzZSHNU8VQrisFaiGsvx7MsXiNYa4sN72nRgjsjmEy1MdBh6Dmjsi1OXTM9Gw2JHZwEFE/NSr9gbnDWnKSsJTDwBEAuQdZgwekdLhbt/VSoIS2DlxSHHUzv355qZYmzuZyNR8YtPafvOJTUgbzUyn2IPoQBZ+GVSGFmrjxJI/kPRbAFrWa+7up54pl7JuovhqY9Uvzx/IozSw36AXStVva/jLkIgUFO8nbeO0f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 22 Jul 2025 at 06:36, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>
> On 7/22/2025 7:17 AM, Sean Christopherson wrote:
> > On Fri, Jul 18, 2025, Xiaoyao Li wrote:
> >> On 7/18/2025 12:27 AM, Fuad Tabba wrote:
> >>> From: Ackerley Tng <ackerleytng@google.com>
> >>>
> >>> Refactor kvm_max_private_mapping_level() to accept a NULL kvm_page_fault
> >>> pointer and rename it to kvm_gmem_max_mapping_level().
> >>>
> >>> The max_mapping_level x86 operation (previously private_max_mapping_level)
> >>> is designed to potentially be called without an active page fault, for
> >>> instance, when kvm_mmu_max_mapping_level() is determining the maximum
> >>> mapping level for a gfn proactively.
> >>>
> >>> Allow NULL fault pointer: Modify kvm_max_private_mapping_level() to
> >>> safely handle a NULL fault argument. This aligns its interface with the
> >>> kvm_x86_ops.max_mapping_level operation it wraps, which can also be
> >>> called with NULL.
> >>
> >> are you sure of it?
> >>
> >> The patch 09 just added the check of fault->is_private for TDX and SEV.
> >
> > +1, this isn't quite right.  That's largely my fault (no pun intended) though, as
> > I suggested the basic gist of the NULL @fault handling, and it's a mess.  More at
> > the bottom.
> >
> >>> Rename function to kvm_gmem_max_mapping_level(): This reinforces that
> >>> the function's scope is for guest_memfd-backed memory, which can be
> >>> either private or non-private, removing any remaining "private"
> >>> connotation from its name.
> >>>
> >>> Optimize max_level checks: Introduce a check in the caller to skip
> >>> querying for max_mapping_level if the current max_level is already
> >>> PG_LEVEL_4K, as no further reduction is possible.
> >>>
> >>> Acked-by: David Hildenbrand <david@redhat.com>
> >>> Suggested-by: Sean Christoperson <seanjc@google.com>
> >>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> >>> Signed-off-by: Fuad Tabba <tabba@google.com>
> >>> ---
> >>>    arch/x86/kvm/mmu/mmu.c | 16 +++++++---------
> >>>    1 file changed, 7 insertions(+), 9 deletions(-)
> >>>
> >>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> >>> index bb925994cbc5..6bd28fda0fd3 100644
> >>> --- a/arch/x86/kvm/mmu/mmu.c
> >>> +++ b/arch/x86/kvm/mmu/mmu.c
> >>> @@ -4467,17 +4467,13 @@ static inline u8 kvm_max_level_for_order(int order)
> >>>     return PG_LEVEL_4K;
> >>>    }
> >>> -static u8 kvm_max_private_mapping_level(struct kvm *kvm,
> >>> -                                   struct kvm_page_fault *fault,
> >>> -                                   int gmem_order)
> >>> +static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, int order,
> >>> +                                struct kvm_page_fault *fault)
> >>>    {
> >>> -   u8 max_level = fault->max_level;
> >>>     u8 req_max_level;
> >>> +   u8 max_level;
> >>> -   if (max_level == PG_LEVEL_4K)
> >>> -           return PG_LEVEL_4K;
> >>> -
> >>> -   max_level = min(kvm_max_level_for_order(gmem_order), max_level);
> >>> +   max_level = kvm_max_level_for_order(order);
> >>>     if (max_level == PG_LEVEL_4K)
> >>>             return PG_LEVEL_4K;
> >>> @@ -4513,7 +4509,9 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
> >>>     }
> >>>     fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
> >>> -   fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault, max_order);
> >>> +   if (fault->max_level >= PG_LEVEL_4K)
> >>> +           fault->max_level = kvm_gmem_max_mapping_level(vcpu->kvm,
> >>> +                                                         max_order, fault);
> >>
> >> I cannot understand why this change is required. In what case will
> >> fault->max_level < PG_LEVEL_4K?
> >
> > Yeah, I don't get this code either.  I also don't think KVM should call
> > kvm_gmem_max_mapping_level() *here*.  That's mostly a problem with my suggested
> > NULL @fault handling.  Dealing with kvm_gmem_max_mapping_level() here leads to
> > weirdness, because kvm_gmem_max_mapping_level() also needs to be invoked for the
> > !fault path, and then we end up with multiple call sites and the potential for a
> > redundant call (gmem only, is private).
> >
> > Looking through surrounding patches, the ordering of things is also "off".
> > "Generalize private_max_mapping_level x86 op to max_mapping_level" should just
> > rename the helper; reacting to !is_private memory in TDX belongs in "Consult
> > guest_memfd when computing max_mapping_level", because that's where KVM plays
> > nice with non-private memory.
> >
> > But that patch is also doing too much, e.g. shuffling code around and short-circuting
> > the non-fault case, which makes it confusing and hard to review.  Extending gmem
> > hugepage support to shared memory should be "just" this:
> >
> > @@ -3335,8 +3336,9 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
> >          if (max_level == PG_LEVEL_4K)
> >                  return PG_LEVEL_4K;
> >
> > -       if (is_private)
> > -               host_level = kvm_max_private_mapping_level(kvm, fault, slot, gfn);
> > +       if (is_private || kvm_memslot_is_gmem_only(slot))
> > +               host_level = kvm_gmem_max_mapping_level(kvm, fault, slot, gfn,
> > +                                                       is_private);
> >          else
> >                  host_level = host_pfn_mapping_level(kvm, gfn, slot);
> >          return min(host_level, max_level);
> >
> > plus the plumbing and the small TDX change.  All the renames and code shuffling
> > should be done in prep patches.
> >
> > The attached patches are compile-tested only, but I think they get use where we
> > want to be, and without my confusing suggestion to try and punt on private mappings
> > in the hugepage recovery paths.  They should slot it at the right patch numbers
> > (relative to v15).
> >
> > Holler if the patches don't work, I'm happy to help sort things out so that v16
> > is ready to go.
>
> I have some feedback though the attached patches function well.
>
> - In 0010-KVM-x86-mmu-Rename-.private_max_mapping_level-to-.gm.patch,
> there is double gmem in the name of vmx/vt 's callback implementation:
>
>      vt_gmem_gmem_max_mapping_level
>      tdx_gmem_gmem_max_mapping_level
>      vt_op_tdx_only(gmem_gmem_max_mapping_level)

Sean's patches do that, then he fixes it in a later patch. I'll fix
this at the source.

> - In 0013-KVM-x86-mmu-Extend-guest_memfd-s-max-mapping-level-t.patch,
>    kvm_x86_call(gmem_max_mapping_level)(...) returns 0 for !private case.
>    It's not correct though it works without issue currently.
>
>    Because current gmem doesn't support hugepage so that the max_level
>    gotten from gmem is always PG_LEVEL_4K and it returns early in
>    kvm_gmem_max_mapping_level() on
>
>         if (max_level == PG_LEVEL_4K)
>                 return max_level;
>
>    But just look at the following case:
>
>      return min(max_level,
>         kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private));
>
>    For non-TDX case and non-SNP case, it will return 0, i.e.
>    PG_LEVEL_NONE eventually.
>
>    so either 1) return PG_LEVEL_NUM/PG_LEVEL_1G for the cases where
>    .gmem_max_mapping_level callback doesn't have specific restriction.
>
>    or 2)
>
>         tmp = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private);
>         if (tmp)
>                 return min(max_level, tmp);
>
>         return max-level;

Sean? What do you think?

Thanks!
/fuad

