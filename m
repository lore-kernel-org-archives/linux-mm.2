Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2569DC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 15:31:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87AE68E0001; Tue, 22 Jul 2025 11:31:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8526E6B00AC; Tue, 22 Jul 2025 11:31:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 768B88E0001; Tue, 22 Jul 2025 11:31:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 640AF6B0093
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:31:27 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 10E1F58EA0
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:31:27 +0000 (UTC)
X-FDA: 83692289814.17.A1807FE
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf24.hostedemail.com (Postfix) with ESMTP id 454BA180012
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:31:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NwNWQOTU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of tabba@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=tabba@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753198285; a=rsa-sha256;
	cv=none;
	b=KLmaRXq6fPdAmsQct2KTRT7xudvRkaAdGlYQshrGBuI7C2Md5JxtMXoh616MfmFPGr9Iwq
	kAG00XU8wxcdMp3FiBDlU3y6jKFP/lR7ypfVYaYfAHTQbSDLXclcRa4P1D8MXXdwf7d7/d
	wN0zeNONs/zolLBTogU8oQ+obal0V2s=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NwNWQOTU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of tabba@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=tabba@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753198285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D+k0L961GoqoDjJUTKbSYxRUyR6qX1eP68MhWHVJFbg=;
	b=rHTmOqbwTw4/ZqaClgeJNadFbi2Tsir2VuNUyR8OJY5abrZ3PiwiiXtzCaylf5zh2NriEg
	eFd/fJE/znrQyhutnfN6Q94tlnp+yVFVnOuBKtrsN5eRmodUEzrPEVVmBBJXqSYKv75Yav
	ZFZ9EVRrzkApX/6gYQHOH+o2YQxhSj4=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ab86a29c98so409981cf.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753198284; x=1753803084; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=D+k0L961GoqoDjJUTKbSYxRUyR6qX1eP68MhWHVJFbg=;
        b=NwNWQOTUoAkbP6DYDS8+0ULM5izG3IpgNmzxayI6PEwbnVUXnuaogYdc0ATMG8NwDT
         NzlOxFKLsSWu/4m1OiTpDil4jO+pxSybaDBnpWs7wjKsXleX7VQD0hDARaCoXsh5gIRB
         auSxjSz8Cr8LicTZIjMVRCGyvo98s0GWHjV3/e0gu/yIUROBTgljHE20K1SLqqH49lXL
         5GZ3HSzbiz8TcfNpVUdRPweDgqrZvoWkkEox+JPmUHAN5xlNNcD4TIpv1nWe+GKcHP/U
         vCpWzuvTgxZ8UiFl8i2qUzKp0Xs8lQVaOwzJWBAYtVx+PAHo6nUKui+dLkk9371iNCPA
         pQbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753198284; x=1753803084;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D+k0L961GoqoDjJUTKbSYxRUyR6qX1eP68MhWHVJFbg=;
        b=pJV9O+ZZhqWvHzV8OcE6r/LPDoopVSV4wusGIImt+qXpWQXkH849j0YQMjC8eP8W6f
         PFrMzjYx/AzBkhL8+1BaMcmjf0UNKqzBvJpbJT87taySucf8uOOIpfjS0ZXcIM/YHI37
         4Mbn3tQDGvzz3nZbf+lTAapwjwqBEAWnrwsOCh9CGgad5bp7JQxEL3wyjKy9rSMhTv1m
         +dGXxf0XRDZ1ZPn29em8gr6jvwV8J3dAwOYhUIJaDRjjB0Om78m7i4leFOIHAdgDk34o
         KjJImUrj3Qly+f4tAg7kpjLx5+B+Oezig6/Ab6HTXv7ynP9cfM+hEEC1+Xo2vDLdWIsP
         sutA==
X-Forwarded-Encrypted: i=1; AJvYcCVv/2RF5EUK2NdNwmhbickKAU36U+lRP9ZPEr2GP2ICXVADnyXTmvxH6wO+eL3FXf4wxomkwZn7kg==@kvack.org
X-Gm-Message-State: AOJu0YzWJyTdiDpWlrr1Uao2VTy3QhUV4A921MO+WMxNkXt76I8YfYpS
	ccG88kSRPaBOj+XUVZNYAqBCEWgu0uzk1FW2gLGlxrIsIb8RjfXRx6EYsRyzoIc/0/Eyu4ufev7
	ByroZSYhocfiZOLkvZ150hghXRkHAFa9ZylPmbdv9
X-Gm-Gg: ASbGncvRioaimVeOFgaRrzNKyplpcceF0QUVuh9X7a8hHT+onD5raC4+n8ovgQnsIbC
	R0BiHdQRPAoVM48/n2eDPLhLjXSYHqRdoK78y6nfnYj/fRfZZwzgExQgAb6tl0qj8VjQYSWZ60F
	7uX9+c+bZsZXlJDfTufIP4hDYgADNqwNJT84OtJIYnSlP4qwOENoIJMIs4vfoi0/HmGElLROlHH
	Z1GsJU=
X-Google-Smtp-Source: AGHT+IGkN/bZLl3GymkOZZTe3VZFknRwnP1HGd5madljrUzwenWrcpSI2BrfChprDgkNjwylakOH9SaFNgyNyjBG86g=
X-Received: by 2002:a05:622a:cf:b0:4a9:a4ef:35d3 with SMTP id
 d75a77b69052e-4ae5f18c0e2mr4176791cf.7.1753198283442; Tue, 22 Jul 2025
 08:31:23 -0700 (PDT)
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-12-tabba@google.com>
 <8340ec70-1c44-47a7-8c48-89e175501e89@intel.com> <aH7KghhsjaiIL3En@google.com>
 <c35b8c34-2736-45fe-8a97-bfedbf72537e@intel.com> <CA+EHjTzNDrwzdpoEuiqvzk3-A7LAsdJ-6y-Gcj7h7+dUTh=6pw@mail.gmail.com>
 <aH-g9o5hSMvVRxAP@google.com>
In-Reply-To: <aH-g9o5hSMvVRxAP@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 22 Jul 2025 16:30:46 +0100
X-Gm-Features: Ac12FXxXDPUsj4cKnzMPyZJq3Wv-mApIfbczPw3W9lV495mX4LQQasFKEUdMPqo
Message-ID: <CA+EHjTxn0s-HeNcXE7cMxx-xCypE5BtNP5=dvZhyV5u61Pt12Q@mail.gmail.com>
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
X-Rspamd-Queue-Id: 454BA180012
X-Stat-Signature: n4tqaf9u7j15gg75kz4zg9msahkbsk1j
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753198285-262632
X-HE-Meta: U2FsdGVkX1+2KK86/3fgrRsK4pk1WD+M8r5aRaoVNOiGudxRRAKWXoMWEG72u/ZhgIVSybSVSqFhl88WpsJIaq2DH8ijHCFnkvSaAtvGnNCyDq/IJVXjvnx2zU0FQXh2NAtiht+fao1C9D6NTamKOmeJK34BY97x8lnIty7HRzGO+q65P/KeOpKSgY9NpJCjzCxByRI86UsAz2OJs2Dw4afezepkfHxMnda+fzsTj6n4vXRROgIBcLRWJXBhsgIXqQIndK0Raeyj9rGAmn7hMSmsEKM0xVK8UTX5W0MdoRw1k8UrMJZDY23LgaBXV/cXiz+Xg3hLVBtuLX8ajfe19TmGz/ZgOtsvRxbT39HPwL5/nYhW8Z92VIRD7Q76xBqTOPefeFLQKZH/vQKE8XXmDS8iiGtL5V7FZL5sroHTY2pR2++NzB0nDtwwxq9fnb9ZQwBagw/GV62OJf9ZS87bwtTVWSzSvKxCrDSyYObRUeakc6ClzctZwV2FkGBhBHbXMmjS1sl91jYYpiM4MmkG6EfNuT40zzu0k421iv7XRyGM5z3hwyrqaH5Mu/vxMGtr13hhw6ijiRxGoGF1W/6b+Ut1J/SfTSSddqtIqnUtL219L0oI+TKf4FzL00bJLPzCws3I9jNhMKYpXjv00EShHG7UnrYtW06ABwp6pvB+BWUpQ413OW6NFa/svwvZDBrBwtYnEXJnn2CGy5Q7JQEV0OJVhRT/oDx8bgfIyFeFaEJnvrLcO2cTVA1AFlyIx5a6iNQd163fC5V8tv2MAkGm8XKX8eFMPca7Xa+mFMeKcAlCKVQd0+NYnvDmJnZDdNoO0OHRQMFvtcpZAGG4U8Ukqf/cBk8AR3E3hPg7c34ntwWwBzj86NCPoMqcHua8tFu4ou9BRJIScPV+lhrTqrTggXQ3UXLSshAmKCMtCkhss5HYuv6amRx3VmeIlC1sql1MlBsgM15UT8pT73A0le6
 WdAWngV5
 QGRDfkPjmLsvMD/Oy9ZCAZiJLmeTuoW91qVBCt5E+i/tahOKgOlHEK5bf9yY+9fNYqdLBBm4ehCZmd+3wW/CL4aYEIRpaMDuFee0QRq4etVe1AdhJd7Ydd7iFshW2YjgDTZclK8JGM2AWwkOXDE4bweQdUss4syPI5QbzL/r9sfIRtkTOI5pkTF3ZqZGssSpM5CIXsNCES5hgIh71DWifG4lQWMuJxSWfU6RwIPzbGUUwwW1wo0J3a8ZU1Ols5FAuPgHyY5H+QqQocfLQp/jAJ21rlUUfhkPzIJ2idczY9P2tTSCZc/PBVaMdR/Yx978lyNArkVp8Cgxwes78u0pXDy7uBaCZavojvk2ilF/19qXY1Hs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 22 Jul 2025 at 15:32, Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Jul 22, 2025, Fuad Tabba wrote:
> > On Tue, 22 Jul 2025 at 06:36, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> > > - In 0010-KVM-x86-mmu-Rename-.private_max_mapping_level-to-.gm.patch,
> > > there is double gmem in the name of vmx/vt 's callback implementation:
> > >
> > >      vt_gmem_gmem_max_mapping_level
> > >      tdx_gmem_gmem_max_mapping_level
> > >      vt_op_tdx_only(gmem_gmem_max_mapping_level)
> >
> > Sean's patches do that, then he fixes it in a later patch. I'll fix
> > this at the source.
>
> Dagnabbit.  I goofed a search+replace, caught it when re-reading things, and
> fixed-up the wrong commit.  Sorry :-(
>
> > > - In 0013-KVM-x86-mmu-Extend-guest_memfd-s-max-mapping-level-t.patch,
> > >    kvm_x86_call(gmem_max_mapping_level)(...) returns 0 for !private case.
> > >    It's not correct though it works without issue currently.
> > >
> > >    Because current gmem doesn't support hugepage so that the max_level
> > >    gotten from gmem is always PG_LEVEL_4K and it returns early in
> > >    kvm_gmem_max_mapping_level() on
> > >
> > >         if (max_level == PG_LEVEL_4K)
> > >                 return max_level;
> > >
> > >    But just look at the following case:
> > >
> > >      return min(max_level,
> > >         kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private));
> > >
> > >    For non-TDX case and non-SNP case, it will return 0, i.e.
> > >    PG_LEVEL_NONE eventually.
> > >
> > >    so either 1) return PG_LEVEL_NUM/PG_LEVEL_1G for the cases where
> > >    .gmem_max_mapping_level callback doesn't have specific restriction.
> > >
> > >    or 2)
> > >
> > >         tmp = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private);
> > >         if (tmp)
> > >                 return min(max_level, tmp);
> > >
> > >         return max-level;
> >
> > Sean? What do you think?
>
> #2, because KVM uses a "ret0" static call when TDX is disabled (and KVM should
> do the same when SEV is disabled, but the SEV #ifdefs are still a bit messy).
> Switching to any other value would require adding a VMX stubs for the !TDX case.
>
> I think it makes sense to explicitly call that out as the "CoCo level", to help
> unfamiliar readers understand why vendor code has any say in the max
> mapping level.
>
> And I would say we adjust max_level instead of having an early return, e.g. to
> reduce the probability of future bugs due to adding code between the call to
> .gmem_max_mapping_level() and the final return.
>
> This as fixup?

Applied it to my tree. Builds and runs fine. Thanks!
/fuad

> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index eead5dca6f72..a51013e0992a 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3279,9 +3279,9 @@ static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fau
>                                      const struct kvm_memory_slot *slot, gfn_t gfn,
>                                      bool is_private)
>  {
> +       u8 max_level, coco_level;
>         struct page *page;
>         kvm_pfn_t pfn;
> -       u8 max_level;
>
>         /* For faults, use the gmem information that was resolved earlier. */
>         if (fault) {
> @@ -3305,8 +3305,16 @@ static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fau
>         if (max_level == PG_LEVEL_4K)
>                 return max_level;
>
> -       return min(max_level,
> -                  kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private));
> +       /*
> +        * CoCo may influence the max mapping level, e.g. due to RMP or S-EPT
> +        * restrictions.  A return of '0' means "no additional restrictions",
> +        * to allow for using an optional "ret0" static call.
> +        */
> +       coco_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private);
> +       if (coco_level)
> +               max_level = min(max_level, coco_level);
> +
> +       return max_level;
>  }
>
>  int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,

