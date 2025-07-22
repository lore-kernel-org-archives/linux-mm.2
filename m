Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92EBCC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 10:36:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECCEA8E0002; Tue, 22 Jul 2025 06:36:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA4728E0001; Tue, 22 Jul 2025 06:36:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D92DC8E0002; Tue, 22 Jul 2025 06:36:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C1C678E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 06:36:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5A0AB1306F0
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:36:11 +0000 (UTC)
X-FDA: 83691545742.22.045B5D9
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7DFCA40008
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:36:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="KCFQaM/A";
	spf=pass (imf27.hostedemail.com: domain of tabba@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753180569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h2sNENsiUXWZHkoFKe8iTv45YtKCJ7msVi+m+Dnfo0w=;
	b=rC12n99EhhITo/XhpQhdaSlN+eI+wjFyKRNZHGKuri6Bf0o101VZFM4cNJJkaZ7cciPrhh
	hpyjNjtQGcjgVyjQFJJEs8fuYv5RDta5BF4nsvKKH3EGhAd7xmzTso+JZVPN3LUvnJ4fvq
	Pu0oT127xwcjU8orXw270hnfroROnLw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="KCFQaM/A";
	spf=pass (imf27.hostedemail.com: domain of tabba@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753180569; a=rsa-sha256;
	cv=none;
	b=J/LucDibvh7Z/euEfI/uC4uCSZo/kUX2SAgx9dU5T7QJj0D2iy8tIdACSbhBeVJ08YL0eF
	kWNAaHmrN+F6F9NWbBo+SW0TGA9QNNJkzs8x/YSc7Lz+NjdZ0hchBCj6xGYU64s/TVtNH5
	y+5CdieCp1Ef9LgNpeN9SA3KVRWVpUE=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ab86a29c98so297301cf.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 03:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753180568; x=1753785368; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=h2sNENsiUXWZHkoFKe8iTv45YtKCJ7msVi+m+Dnfo0w=;
        b=KCFQaM/AygYC0L7uCxhhquBE8Qv2Eq2WnOQm7CPSrrQFzuCXbvuFGGksCxEoDV6HL5
         2o09JWfMvvcvuipM94vNdUWmdwTOwFIoL8Chnf+uZs3QuedhtBJTmHfjN++lBudPBW1q
         L7HzZ+eGeXhH438Ng3FveVgj/AtOeFdlXeXTtvtd1VBqgwGV7hyipv5N1I+oVyJhzmwG
         uoDVGBpHYnmJvZ6bQZuBp7fU3/rUE3btffesxGUGEXpTfc9GvCJWIMbacrvFAvJSS2hf
         Z7Iuc0SUc0kIa63oJybeCrQkXxYcyDwBucefaJV3Y3G6/cgoTn0FKvMyg1beVCJRSww1
         0Ttw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753180568; x=1753785368;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h2sNENsiUXWZHkoFKe8iTv45YtKCJ7msVi+m+Dnfo0w=;
        b=vCNTQ1EWX3HKsDQ52LXmYy61awN+8gouRux/e1zSTjC9esHJEwKp16irKWEo7xOWbp
         ARN34gRDWYFFynLZYTP1HFwHS+KfC3NWdSO/27nHSc5o7epuk7ZmMYeTnBopqgEAN3Az
         YBx75FqVD4bTtKI7Ha92EJMgS9LggkXO3qmdr8ARYuxKLejrRPcQ/yXVCHJsqD6dVTab
         MgiVk1KJqzAefcL5jwjWxflvqUH3ta+JX7BTo8QIHbOHmKKzYDH34dj/wQKuHm9atYnW
         8tkkCdBkXivYQVJfju5oQO0YyzMsrz7OD/S4aXJnKWsYM+ntg0knZM0GRqDO4W5TbZ5v
         kiIA==
X-Forwarded-Encrypted: i=1; AJvYcCX90SGZC2l7ELcubEuJhX9VOR9mfcHgdMj/9fjHZDWFeLZOeZxt0uV12Xg/Q9zJEEkcD73byqMo+A==@kvack.org
X-Gm-Message-State: AOJu0YzIKUwI5zRXDIQa6S6PdPlrtYv1yc2UYUoDyWoBQucviZe5slmJ
	+33o2Zum9PJYIZP99VPqGlHKOihpjCfK+n5jjQfHOb0Avtz0SUK7peAOQyOX8I3yV0M6qxG8k0N
	nYhWjsmzX7l8LUOB0H3uxYezOiygjRo8j9jnM/AoU
X-Gm-Gg: ASbGncuZi8OBWJI7EdEVInJEx/8bx9vMljpyGMxa3m7QhELbIiNqzcnhs7CF4oUHxFy
	MNKX0RDgnAmdBAlM3K7aUymFglGxYB6IKwAwJV3dWJI88cK7FjHndetSKgrimgbpBU18JVlqN0L
	LUOcp4Ca1mfj113VWwRcx7oEuDdoLPY4a5E7a6491VroS7QP8eS+O/ha0yB4Veyfr6ypAe1+iva
	Y6Nl4OfjpoeCfF05Ry9YV0EH7naW6S+mcuR
X-Google-Smtp-Source: AGHT+IEvqsS58GzqZAYQQgB7BqYiKCpYg+Q8XL/j8/io4oCnmPzNh5X8oKUHq2YYykzKu368BpAYr2MBwji0MjUioSA=
X-Received: by 2002:a05:622a:1dc6:b0:48a:ba32:370 with SMTP id
 d75a77b69052e-4ae5cc6a1d5mr4457581cf.10.1753180567987; Tue, 22 Jul 2025
 03:36:07 -0700 (PDT)
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-12-tabba@google.com>
 <8340ec70-1c44-47a7-8c48-89e175501e89@intel.com> <aH7KghhsjaiIL3En@google.com>
In-Reply-To: <aH7KghhsjaiIL3En@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 22 Jul 2025 11:35:31 +0100
X-Gm-Features: Ac12FXxlfQG4ofD1slov5tvKwsHTWTtSvMayWg2TOJeHuE2UtcTH2RrcWmi_y7k
Message-ID: <CA+EHjTwAVSRU=3FHqV5xrvi5-RfhYDhpoAoYuaU7atSuOv_r_Q@mail.gmail.com>
Subject: Re: [PATCH v15 11/21] KVM: x86/mmu: Allow NULL-able fault in kvm_max_private_mapping_level
To: Sean Christopherson <seanjc@google.com>
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
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 7DFCA40008
X-Rspamd-Server: rspam06
X-Stat-Signature: 7dh9qhpjshr5w3gnfk3da63esrkj85wz
X-HE-Tag: 1753180569-551139
X-HE-Meta: U2FsdGVkX19FKUNXdlOEJgVhjBS96A9scxEBCUBTKkTnBZHCIQ+Od56kBjaVAeFWskESrTd7AjbHp1JGfG6hGpC7qu/EOoe3i9v99eKgfeVpAaq1iAakFLkDsS8LAIilAAUnrbc3vECMSI6BG4dxNVwe4RP2IoTPZOSRJefoGB5A2UACZijaYN/CMjnlXHZEixkdUMauxdnr84QnU5rj2SOEX/dXjrqu3yDAF0QLoiqhQDQvVh2XVDyXHg7F112uN+pJ8X1d8mQI80TmSmTpW9pR4mSBY9AvRYbX+ii6kZyOkVWql9DPzQRhQditNJ0MkLyVcivyMueLFdcEKvogAH44VtEUZGCShCurs+ZergunvCMYAlg2CjQbVdBgI7vJoSPcIxaTIS9+x5CaHVEqxQlw+ji0ozDH1USVRq0GkeoQNd2N161emXACvx0CWierKUvU1AuHkDlyeMznrRE/4EFHBuogO0HmJU4wVVMstfizkGgoQaFJZUoCFU9d+1MJwfctKxgg+8s3wNgZupOh50RivuOkGbmfYQe3ww2bztSrCjVAYjwoIKHeXhIitEE3Op4VoRbWUjEqO7qJh1XnTZielEVeoEv2b7rNkmLoG5pUBx3eHT8PpFGz4ygsXFDqUWze83BopnSzSHUOAVKaRnwKSUCJG/BNOL0U6+etTTKuXZzHqRlWj989QCTVtKinhCIeAjcjEbGTcicWHGKWgLvxR9n1hH3vTgPUgoTxoYAhOJ6WdmxpAji4TlybOURpcAKXxTLycxKeW4Mz231BOY39u/gf3JL7iRCbKAAjWISMq+cZJ94cLe3ZEcRFI8Q0re89q/7gCZNlWsGlL/vIdidaEP7MYAYlW0JEc6f8zTB5/kfaAIXIRCDHueCVJ5UJZ5T2dB5wEi598AF/8zpGUea98x+B3oPMYFmMbbbS/SR61u0D2extNBzZqt99peM1I3np6dTrgPKXiNqYZQ3
 4JL+k4MZ
 BdnrASmVkh1SR1+tk1OlpcLSz4MwQCHdVmN/LMEIAlJSQZYMrFr337n0rwdgN4wqJh3C3JQ76rV0sbgivlMXY/AaUmXnSaIDhi2/6rkLHLZlRfaGUh+r2CnqLn8nkzH6/6CPKkXq63ZW2xHriiouv8WT2JdCXj+KK+UMD9IcqYjelECo5tz9VkPPcesKOJZDtvItICqsfFQKtzgaq95QxMJMgCLdXDcxOf0/L0DVBoi8CG75g/ZBbQT6/jccvdDsNtUprk9HL6Brgqj+ybX4oxvaajphXPrBCZXerOoq2c7ERoFg1dx0u1+oxlxETe/gFBbjKOSXMemsh/Wdp9UUcwNZOPsC9+RgjwnizXIJG+qneuMg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 22 Jul 2025 at 00:17, Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Jul 18, 2025, Xiaoyao Li wrote:
> > On 7/18/2025 12:27 AM, Fuad Tabba wrote:
> > > From: Ackerley Tng <ackerleytng@google.com>
> > >
> > > Refactor kvm_max_private_mapping_level() to accept a NULL kvm_page_fault
> > > pointer and rename it to kvm_gmem_max_mapping_level().
> > >
> > > The max_mapping_level x86 operation (previously private_max_mapping_level)
> > > is designed to potentially be called without an active page fault, for
> > > instance, when kvm_mmu_max_mapping_level() is determining the maximum
> > > mapping level for a gfn proactively.
> > >
> > > Allow NULL fault pointer: Modify kvm_max_private_mapping_level() to
> > > safely handle a NULL fault argument. This aligns its interface with the
> > > kvm_x86_ops.max_mapping_level operation it wraps, which can also be
> > > called with NULL.
> >
> > are you sure of it?
> >
> > The patch 09 just added the check of fault->is_private for TDX and SEV.
>
> +1, this isn't quite right.  That's largely my fault (no pun intended) though, as
> I suggested the basic gist of the NULL @fault handling, and it's a mess.  More at
> the bottom.
>
> > > Rename function to kvm_gmem_max_mapping_level(): This reinforces that
> > > the function's scope is for guest_memfd-backed memory, which can be
> > > either private or non-private, removing any remaining "private"
> > > connotation from its name.
> > >
> > > Optimize max_level checks: Introduce a check in the caller to skip
> > > querying for max_mapping_level if the current max_level is already
> > > PG_LEVEL_4K, as no further reduction is possible.
> > >
> > > Acked-by: David Hildenbrand <david@redhat.com>
> > > Suggested-by: Sean Christoperson <seanjc@google.com>
> > > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > ---
> > >   arch/x86/kvm/mmu/mmu.c | 16 +++++++---------
> > >   1 file changed, 7 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index bb925994cbc5..6bd28fda0fd3 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -4467,17 +4467,13 @@ static inline u8 kvm_max_level_for_order(int order)
> > >     return PG_LEVEL_4K;
> > >   }
> > > -static u8 kvm_max_private_mapping_level(struct kvm *kvm,
> > > -                                   struct kvm_page_fault *fault,
> > > -                                   int gmem_order)
> > > +static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, int order,
> > > +                                struct kvm_page_fault *fault)
> > >   {
> > > -   u8 max_level = fault->max_level;
> > >     u8 req_max_level;
> > > +   u8 max_level;
> > > -   if (max_level == PG_LEVEL_4K)
> > > -           return PG_LEVEL_4K;
> > > -
> > > -   max_level = min(kvm_max_level_for_order(gmem_order), max_level);
> > > +   max_level = kvm_max_level_for_order(order);
> > >     if (max_level == PG_LEVEL_4K)
> > >             return PG_LEVEL_4K;
> > > @@ -4513,7 +4509,9 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
> > >     }
> > >     fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
> > > -   fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault, max_order);
> > > +   if (fault->max_level >= PG_LEVEL_4K)
> > > +           fault->max_level = kvm_gmem_max_mapping_level(vcpu->kvm,
> > > +                                                         max_order, fault);
> >
> > I cannot understand why this change is required. In what case will
> > fault->max_level < PG_LEVEL_4K?
>
> Yeah, I don't get this code either.  I also don't think KVM should call
> kvm_gmem_max_mapping_level() *here*.  That's mostly a problem with my suggested
> NULL @fault handling.  Dealing with kvm_gmem_max_mapping_level() here leads to
> weirdness, because kvm_gmem_max_mapping_level() also needs to be invoked for the
> !fault path, and then we end up with multiple call sites and the potential for a
> redundant call (gmem only, is private).
>
> Looking through surrounding patches, the ordering of things is also "off".
> "Generalize private_max_mapping_level x86 op to max_mapping_level" should just
> rename the helper; reacting to !is_private memory in TDX belongs in "Consult
> guest_memfd when computing max_mapping_level", because that's where KVM plays
> nice with non-private memory.
>
> But that patch is also doing too much, e.g. shuffling code around and short-circuting
> the non-fault case, which makes it confusing and hard to review.  Extending gmem
> hugepage support to shared memory should be "just" this:
>
> @@ -3335,8 +3336,9 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
>         if (max_level == PG_LEVEL_4K)
>                 return PG_LEVEL_4K;
>
> -       if (is_private)
> -               host_level = kvm_max_private_mapping_level(kvm, fault, slot, gfn);
> +       if (is_private || kvm_memslot_is_gmem_only(slot))
> +               host_level = kvm_gmem_max_mapping_level(kvm, fault, slot, gfn,
> +                                                       is_private);
>         else
>                 host_level = host_pfn_mapping_level(kvm, gfn, slot);
>         return min(host_level, max_level);
>
> plus the plumbing and the small TDX change.  All the renames and code shuffling
> should be done in prep patches.
>
> The attached patches are compile-tested only, but I think they get use where we
> want to be, and without my confusing suggestion to try and punt on private mappings
> in the hugepage recovery paths.  They should slot it at the right patch numbers
> (relative to v15).
>
> Holler if the patches don't work, I'm happy to help sort things out so that v16
> is ready to go.

These patches apply, build, and run. I'll incorporate them, test them
a bit more with allmodconf and friends, along with the other patch
that you suggested, and respin v16 soon.

Cheers,
/fuad

