Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94EEAC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 08:44:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 290AC6B008C; Tue, 22 Jul 2025 04:44:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 247566B0092; Tue, 22 Jul 2025 04:44:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 108186B0093; Tue, 22 Jul 2025 04:44:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E89306B008C
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 04:44:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6AA8980311
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:44:36 +0000 (UTC)
X-FDA: 83691264552.30.53F095F
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf19.hostedemail.com (Postfix) with ESMTP id A23851A0006
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:44:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=obzFlHzi;
	spf=pass (imf19.hostedemail.com: domain of tabba@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753173874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dPBkvCcfAeL2dNZt7wG4lYGcQyDWbM6vpCIRnJhXb7E=;
	b=GZEUpTGgINezm/LdBxJIwBuibI/8pWbwlHyA/cWdq773RyDR5BZCtv/y2eHEFZv4R6uZWP
	GKPKgk/ov+MDkD5f7SxmLo2hujBwSQ0yesvckB3mNzqJ5FYQ6WFRlJaqEhkG380d5DASlr
	0EH2DEgnQsNHHzsnctruy7MzFhN/Tpw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753173874; a=rsa-sha256;
	cv=none;
	b=RLAeyDiclvQatDPLncLIC7DQknV6S3oDe+acUEDR0CyPjr0jeBRC3iLI5ASdBDchmL0P1j
	VmkOUQQnoX0op0jjgKnQzR883H4UJHBXUV6EfBmBgmBiKWJVA0au0TKx3GV+e6MkGYmaAO
	ggrQxF1809zE7UmXh6tEzSWJPY8c9Ec=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=obzFlHzi;
	spf=pass (imf19.hostedemail.com: domain of tabba@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ab3855fca3so185691cf.1
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753173874; x=1753778674; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dPBkvCcfAeL2dNZt7wG4lYGcQyDWbM6vpCIRnJhXb7E=;
        b=obzFlHzi4qkrg1I1twesIP6QwdEkPAhV0Gvcc+IAnn2a0adBV5OBc1oqRdRI6Gfud0
         DBCi4GqmRA9UQ60r9YUuGAMbOH8JniUfEzHa+NwkKIxqfqSQYqKiXcxxBmMAxj/Rd5kM
         fsZNNvaY8qurZyaW0ziI+VwkBFwYmt1XrSThfqyzgNhYSzd7X3YVyts+lJuAx+dhC7aZ
         n/E9wQabJ8iQhGscKACpgX1XjEQhYaR8CFINQlpm0CUjD2Om5hn3oB9Mi7fbLoyWYDgg
         Dvibs40tRHhPzSR2fn/+rvUFtOnVq+b6vhyLUpPF+xafJ8QwzB0gjLYrvn3LJAawpmS4
         7Wmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753173874; x=1753778674;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dPBkvCcfAeL2dNZt7wG4lYGcQyDWbM6vpCIRnJhXb7E=;
        b=qeAREhFYOUuhyzOerNhzdMkyeOpoXeDldYktM38DcTvjWfYZKA7nSmwtiELhLSmIrm
         ZpTjL3m3SLvPHvXKfi12vObp/EO32VphK9I2RhucognM/denZgXfpnEBW303HvTR+/Ze
         jnTkbfvHcHunAr3H12jeUTNVmbZKAfqiOcrLR2GQqZ3AJAG/dxYDSASW5TS+4mXc8hV1
         32pEADACgyr880ZJWUebvzpLnKG1OXxPbYZ5XWC9WQrP4S+EBpVKan612xYy7yz+KRN5
         ec/25cfA16GSZLoHxNmk2ZC0QgOSJ58ARarDiBHEHBl5zhv/ZYFJSehKcH65K32bz9Vy
         jOSw==
X-Forwarded-Encrypted: i=1; AJvYcCV3qB0ICMKIIw07XR3k1Gx0DnKVJAtJHvFLrwM/JwwEAk02VN2FG6kJD6yKl/wgsecyNPwAydgQLw==@kvack.org
X-Gm-Message-State: AOJu0YxZaqfpnoqGpGBmoZxYam0LTr32qEKkKggmaC0sBYYPibPo73z9
	n1iFS3oqb74+JTo0BaQxUa4U0jDNaQTeLOdW/G885PCO5upbLLSIJyWzX/tnFpB2s0Z4VALgbu2
	5FkQaHijaZ1BLaM26RCGGygU3rRmZaW+XsDXq0ssI
X-Gm-Gg: ASbGncuraEOIbXuSXEEWW6AbRrF98xQ04CeNyu3SLyBTKrsEfR1PO0qYNh57f1AxwLu
	coHzQ6bwzHuDRIVRjKztoI4D5m8SUP1SOxKjO15geO+sc1Mj4yAWgtBVRWBFnTMZ0cq7PqYBhGm
	Y7J5loIwIF8DfNYO4GL/DYSnCDCMJLga+4tUrDRNeWv3Vignw+Wwu7YDl07b2XzH3B1sSZMeJHc
	6wgy0k1lxAeALGTK4Ruk8R024JJiSxzYOvX
X-Google-Smtp-Source: AGHT+IHY1bLajV8cSDSr07UxvUVPof2BdmEX/z7/v1iwlDELsaBXQa7JYlT3T+HwWsQDpoA/9fVIqN/RA0gQKf3OZbM=
X-Received: by 2002:a05:622a:a916:b0:4aa:cba2:2e67 with SMTP id
 d75a77b69052e-4ae5f1c81b8mr2062111cf.21.1753173873334; Tue, 22 Jul 2025
 01:44:33 -0700 (PDT)
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-14-tabba@google.com>
 <aH5vNqPrUFgtZCqU@google.com> <27ac6ed0-f58a-4926-a069-8d9d7d61a41c@intel.com>
In-Reply-To: <27ac6ed0-f58a-4926-a069-8d9d7d61a41c@intel.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 22 Jul 2025 09:43:56 +0100
X-Gm-Features: Ac12FXwo4G2roOXpkeQ9Jh58vNuaACeOHbQjO2y_a9aub1RVWWMkoayleVat1V8
Message-ID: <CA+EHjTzUr4K8SsvwANTkg7yd5mFZLbY1aSUB85zvd7wooizf_A@mail.gmail.com>
Subject: Re: [PATCH v15 13/21] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
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
X-Rspamd-Queue-Id: A23851A0006
X-Stat-Signature: 9spfii6x77bztps8aj34msdwqqw3ujwo
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753173874-190829
X-HE-Meta: U2FsdGVkX19EpMHy5GL3laq7p3bGSNLzrZNfD7ZaM/fex3H+SuSSc6f7CVWrCFkF+r5KlCUOZxt3noYZc3mnNdwGRcAWRpZlZpt9EvRK44ul+6dWWv2oK49i92CJmHcGlDDl/QOjQtaM9+xquA3LBHGdRb3+zNyhCJHqh8hiMyAhoJim3/QkA+kLYLUXojlHP3WqitqclNz9L/IqoT3xbR16oZ7dYaM4pdTqXFIbUkPhvGp61SOwXKvWLRkL6ixmxjUyZPxxYDPad6MlbYwBLqSUhjc9yawdhhQZTVu935WJdJIgaxVofT2MzslIE6F4iu5Up0800tvE2CpKwSR3Lz+8dgSsnAr71VFf+KjikPSFgHeEN1dYwY0DguVwavIp2RA8lRdkRNpqR6B3lQgsnIDqI1Y8kF+PQorO/NUDtup3DuyoB/Kvtkj+FYTCsKTP8thNwZe7rAvOAoYZ6escEh6UwhR+4wJTVWb59y/r6MADPjfjsNA6+frzzTI4h1Onezd9gnl9RneYYq0gUdmDjSAKG4webigIqkZUAIFCeD7NH14En1tb30qmzmAvR5hs6/OSD4l00NehlHWkc71WaJ5t1neqCrlBt4B0oNPUD8Ve7TG5n+dY3s9/UQ1qLOAibYaYU2p4SFYqPsOWeYCRB0INLdITTtYUMtYEPuKJ5rvAhxrhH4rCFF830+VQ/bbdiQeL07FuEZp1ollybKodn62BkBeDSB6NKKsxXn0lqUgg+A2d0Zuzof5PxINYMWtgUCunKLMFMnsMun36ZdhWvWSLrfLRkDTP/3ZKf1qlVuJpwVgq6CaSmwFkvouDBh3JyD9Rv/jioLbrHcHGsERGrYUl2nRGeSvaVZ+kp8JjQonMi5x1U0vefD6m/uzz6Gw65oiOluGvVhkPcPb04ogasGHUtNsIR+S4Zq00nRvjKFQ6PXrhWIixEHHeltaVP9z+AGgNucYmzzCRAR6ms7q
 jM/g2x1B
 PSK95DxWPxfWBO6KlUyQhxSc6W22rCSSfhbTzhURqJZbfYVk0KsS1E9ttjEuNoMS9ckm2qrgcUPesgprnmhR9DLTN0u08rys+B8nJVgJbJVqhu98Qn1OFRiIYo/SmBK6Ol9PUR2sfUkoVjohQ+iueJqbkw9y4uLDSmUqQeKF4ILAVVTwa8PLVeAOlTsWWsJroDV2cRHftuC3QT8GNR5lJLgJt4DkxQ5s+ARjqvyheFhXpsxxKkOeytm67vQFOlbCmXgzSsWiMuA+rSBzQeZzzp+mqnlF51kZlaDDwAGkb3nYw8IVwv7cEtszcxhavZ7vwsjWamAm9EZddNBD3BvIm0lLX879wG5p9pF/zZR91+KUKTP/NtWIQnN97ys4xzAuqDQfYkvnypLnq0zgdpJpyVBD+WA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 22 Jul 2025 at 06:41, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>
> On 7/22/2025 12:47 AM, Sean Christopherson wrote:
> > On Thu, Jul 17, 2025, Fuad Tabba wrote:
> >> From: Ackerley Tng <ackerleytng@google.com>
> >>
> >> Update the KVM MMU fault handler to service guest page faults
> >> for memory slots backed by guest_memfd with mmap support. For such
> >> slots, the MMU must always fault in pages directly from guest_memfd,
> >> bypassing the host's userspace_addr.
> >>
> >> This ensures that guest_memfd-backed memory is always handled through
> >> the guest_memfd specific faulting path, regardless of whether it's for
> >> private or non-private (shared) use cases.
> >>
> >> Additionally, rename kvm_mmu_faultin_pfn_private() to
> >> kvm_mmu_faultin_pfn_gmem(), as this function is now used to fault in
> >> pages from guest_memfd for both private and non-private memory,
> >> accommodating the new use cases.
> >>
> >> Co-developed-by: David Hildenbrand <david@redhat.com>
> >> Signed-off-by: David Hildenbrand <david@redhat.com>
> >> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> >> Co-developed-by: Fuad Tabba <tabba@google.com>
> >> Signed-off-by: Fuad Tabba <tabba@google.com>
> >> ---
> >>   arch/x86/kvm/mmu/mmu.c | 13 +++++++++----
> >>   1 file changed, 9 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> >> index 94be15cde6da..ad5f337b496c 100644
> >> --- a/arch/x86/kvm/mmu/mmu.c
> >> +++ b/arch/x86/kvm/mmu/mmu.c
> >> @@ -4511,8 +4511,8 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
> >>                               r == RET_PF_RETRY, fault->map_writable);
> >>   }
> >>
> >> -static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
> >> -                                   struct kvm_page_fault *fault)
> >> +static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
> >> +                                struct kvm_page_fault *fault)
> >>   {
> >>      int max_order, r;
> >>
> >> @@ -4536,13 +4536,18 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
> >>      return RET_PF_CONTINUE;
> >>   }
> >>
> >> +static bool fault_from_gmem(struct kvm_page_fault *fault)
> >
> > Drop the helper.  It has exactly one caller, and it makes the code *harder* to
> > read, e.g. raises the question of what "from gmem" even means.  If a separate
> > series follows and needs/justifies this helper, then it can/should be added then.
>
> there is another place requires the same check introduced by your
> "KVM: x86/mmu: Extend guest_memfd's max mapping level to shared
> mappings" provided in [*]
>
> [*] https://lore.kernel.org/kvm/aH7KghhsjaiIL3En@google.com/

I guess this is meant for the patch [*], which as far as I could tell,
isn't in the latest (-rc7) yet.

Thanks,
/fuad

> ---
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 1ff7582d5fae..2d1894ed1623 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
>
> @@ -3335,8 +3336,9 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
> struct kvm_page_fault *fault,
>          if (max_level == PG_LEVEL_4K)
>                  return PG_LEVEL_4K;
>
> -       if (is_private)
> -               host_level = kvm_max_private_mapping_level(kvm, fault,
> slot, gfn);
> +       if (is_private || kvm_memslot_is_gmem_only(slot))
> +               host_level = kvm_gmem_max_mapping_level(kvm, fault,
> slot, gfn,
> +                                                       is_private);
>          else
>                  host_level = host_pfn_mapping_level(kvm, gfn, slot);
>          return min(host_level, max_level);
>
> >> +{
> >> +    return fault->is_private || kvm_memslot_is_gmem_only(fault->slot);
> >> +}
> >> +
> >>   static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
> >>                               struct kvm_page_fault *fault)
> >>   {
> >>      unsigned int foll = fault->write ? FOLL_WRITE : 0;
> >>
> >> -    if (fault->is_private)
> >> -            return kvm_mmu_faultin_pfn_private(vcpu, fault);
> >> +    if (fault_from_gmem(fault))
> >> +            return kvm_mmu_faultin_pfn_gmem(vcpu, fault);
> >>
> >>      foll |= FOLL_NOWAIT;
> >>      fault->pfn = __kvm_faultin_pfn(fault->slot, fault->gfn, foll,
> >> --
> >> 2.50.0.727.gbf7dc18ff4-goog
> >>
>
>

