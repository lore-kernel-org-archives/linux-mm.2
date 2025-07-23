Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83EAFC83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 09:19:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EBA86B0099; Wed, 23 Jul 2025 05:19:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19C816B009A; Wed, 23 Jul 2025 05:19:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08C286B009C; Wed, 23 Jul 2025 05:19:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E69906B0099
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 05:19:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9D9D8B9E55
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:19:04 +0000 (UTC)
X-FDA: 83694980208.17.2CAB44D
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf28.hostedemail.com (Postfix) with ESMTP id D44CEC0007
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:19:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hQ90xZfu;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of tabba@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=tabba@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753262342; a=rsa-sha256;
	cv=none;
	b=dlIVLEc3CHlMPWL9xGtV8fJn41uUCdx92kldhh67nYjTP0nkHZ9R3VQqf1xAh4CSTz14FE
	bFw9/idYe4UCB9ze6sdv1kf3SyK/0N8TPlyjxfPdT8vqZpaEfLKGFv5E6k3gzgZKPtinib
	QFDWf29ipDOPTPo1blRCkrOCZZ6pI2Q=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hQ90xZfu;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of tabba@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=tabba@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753262342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fFB2lKlzZGrzhbM4PzD3lroism4M1bEmsmifGbcd/Mo=;
	b=ot8zFzjyyaDImYJR8X0W5c7D6KW5xI+Yu9u9APkUOtKTa33beYpkNn3qjBlopZz7ONqHiR
	lhUQrA4okRrJBcokBnmCIYTd7qu9IHpXHKWLiOpd+w0SFAj/kPP2EjHhVA3aGi/hOgrpX6
	MUvdLStvGXDNYZs3Ehhwh+AkFnoe7Ss=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso348561cf.0
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 02:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753262342; x=1753867142; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fFB2lKlzZGrzhbM4PzD3lroism4M1bEmsmifGbcd/Mo=;
        b=hQ90xZfu9cwV7+zH6YWQFjwx7ISPAtVx3paK243EcJfYBh4Vin8cN38njE85vaongX
         kVXax0JMOH+ZiTFLZXPlZIWWx4soY2VsjEGJTH+UCl5JL+z8dn+zwmbegC0+zhXD46oW
         tNj9P0mFXJJB+vJyFHG0oE0mPHKygxm7FXV9vfNNgPM+zgQYjg5clDJJY8UOU0TEj5fb
         Gsrk8fDsVDWSnw1BEnwUuRncgKn9kUmqbZk84syClq6Xc1b4bM+tU5s2j+FkreiH3GFJ
         JX+Cavnl2BGjeoIkA/B30sQTVPKz+0gTBPEe/Mg1oyNv9EYTw5pmk+jV+IVbs2h5PgWC
         6BUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753262342; x=1753867142;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fFB2lKlzZGrzhbM4PzD3lroism4M1bEmsmifGbcd/Mo=;
        b=DceXKalVKEMYEl0vD0kQjhfO3fpzZrtHsXF2RxU2eDrEgeb4CVYG+qlW0EriDzvW1R
         sdnD7itLwwadqDg92JFUyEnayu3Ir2jyBVifUlfFOEBJiT4dU/Drznh1FLAojIvjVL6R
         UMgbPfhBtMEgjOGA/yNP3vr5mgUAnI/SGShBQBbNExY9PEPoeYC/0KRU297Q8gLTiBqe
         KNUAXR3jt3uZbZDoViYmsnqV7Lk8Vjq5Z2M1AoeGPKsPQgJlsDwOR6Rv19L8705ChIo7
         0up/ZB6DJZZrni+rYmrYlZVgiLxKaVDwb2wmNdpENN2OdCPED/53mwXy3iyiix2G9AN/
         qmGQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6A/RHm7DlWwlA/Gfg/1UWp2JZR6kBwnz/2zO2cp+WVGRYaNETmNDWr3Mdtir+yyHnDe/dsWd14A==@kvack.org
X-Gm-Message-State: AOJu0YyNZ3JUupr3uCguRmdchN4id7MJfTxm7Uwy4PEu0Ajc+KFKzV0o
	rUiwG0u8OJH3is1tkhOQaSgudLi07xBTXkM8xL9K+nvxNQsCuK1MXUK0r5OuS6A5Cqa1w3n+XeO
	OO09YCzZYu3cRp1dF7f2SGMTownb4KwxPXuNEMeya
X-Gm-Gg: ASbGncs0EF91/yMuI8I+XCMkiowDrPpUlmj45bXvPFkv6nOYpbsAdLreHlpg0+MHCfY
	3X6nWHlMAgVw7IZKCZ0jUZ0dMUL1EB50+OWRGcBPRj3SXb/yOmc64Q0MUPkHY6KerVUPonAyLqF
	8nAWMXf6hIHBvO9dzEXIsUAMV+CLsB14Ai4FGKbG1FYNvO2K++Yc3Mzw58Unn6BEOSy1Qd7BOEs
	gj9AphzpQLFBidG5c+BbuTmAltx/AznAbvl
X-Google-Smtp-Source: AGHT+IHdI2zc5g2uWgDeX7Xhmwb1mpmaFyW9th1coHtjrfDNoMegvkEq3o1bYX03LBqz87TbJvCehtEqjQU8oKdI5oI=
X-Received: by 2002:a05:622a:a6d1:b0:476:f1a6:d8e8 with SMTP id
 d75a77b69052e-4ae6f066f1dmr2244731cf.11.1753262341305; Wed, 23 Jul 2025
 02:19:01 -0700 (PDT)
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-19-tabba@google.com>
 <87ldoftifr.wl-maz@kernel.org>
In-Reply-To: <87ldoftifr.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 23 Jul 2025 10:18:24 +0100
X-Gm-Features: Ac12FXyK6HoWGYh74-rCEgCwyYrKUEnXSOccYJU3yg7243P0WML9CgqAKaoNvVc
Message-ID: <CA+EHjTyD6kXBGF0QitHtALSmX5rVDe7Sew99dwEEPXzjnPzfXQ@mail.gmail.com>
Subject: Re: [PATCH v15 18/21] KVM: arm64: Enable host mapping of shared
 guest_memfd memory
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
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
	will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk, 
	shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com, 
	jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, jthoughton@google.com, 
	peterx@redhat.com, pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 9c36ygcqjhwfkfk8ttk3ya9y9mriysy9
X-Rspam-User: 
X-Rspamd-Queue-Id: D44CEC0007
X-Rspamd-Server: rspam02
X-HE-Tag: 1753262342-338444
X-HE-Meta: U2FsdGVkX18HN4xIGKoMQ5aPZ2e7XN1pxclVwUpbmXUH89v+STg8npxL8vgq9VUX5ZXGK3uTO4/qAnronCWPmRFOv7iSvyNuYsWs0NDHOKskne0zPWDZOLlRGZ4yshuVG5KFW9mtOVkha1MCD+FP7JbblH54tvBsC/WOYUmK+5avzWTa7gJ1fuX8jVheukKSIEi7+/jwwmqEe2AVWRXU8znnEUHUBWtir0WMN2c+1ac2uwsAVeNlDPG9MxK7zjs11gmSNXqVd5dAhlHDAxO3F4oLXFguszdsqx3a9dNODU+MwLdzmyhvqHhzRpuCuo1y/fbmLtKUSnvkaTkQBvShG/mCN4NdFeEIGCWl6ZpK1R2cuQSEF/eDNu3JBP1HAYO9wWEIaK/uhcWoDwiT/XMLnpWcxuUcSl9GwyU6oMarNmSY2dIcE+vigDu3fb2dLymiCFNScvZS4MLLAjWJHDJArl3y70EgIljHYdoS6ubess2drHBBu4KP7FolbJSwWpA9b8zFcapYPLb18AjrHniRpfOxjRBHS0lQmqtqaboLIXCQ40rTsm8H1rD0vI4uAoOAK+L+8r51KGy7YwJaOp5xm+iNB+pWTN542bvS1VasAK3FzpsAMh68ecGNcZRcFbOvBUBzJf3PjRVirt0jj9VzJB+cNdMdC5X1gOn5EmrbpXJX9sgGWgIEJmv0dtXoDFPDLZGQALkgcaHTVe7kKiQm6KYiA1/NxVjErsuM0c3eZtXjxnkSr+zuuUcia9nZjXPgN3J2Gee/3vwQDjou3G7r3QtYwZbNVhaCB1enwMzFn6CH6LKL5CWQo6wnlGsJTB5SFCd7D3JiXaAuP0GChj89RNp/gkcSXhlXTdKEZaVvzTUhpbd4PH8DaJ31+Nt25suPqye5JbSEnoMymVtErMM77VfCkEUTnzfkh/FLsvuR50+14AeT6YdpTs+tIAHeQBhoXHX0CuXm+8Kv5U5unXw
 v18Pahyu
 yn3NuP2UXrJnYR1tqJc/RlcnLcCTzJ7dqq6tvN61paLOWyuT8FRIb9hmHQeSy4cWZCMmMzMdoeFQN1/XLRx4wFIh9NtKXG0KvnkZHHp4bCB8sKd2EVI8KCCNb/eTQHkT0GMjt8Xzrh+XmsuZLiPPdX1EaO8kCkOcF3UMVO8prNxSRbqCyGKNOBJzjLmQ+Htc2Q2wWzXEPwqatjdlrjIVziu0bLblMACCMleHLQsDMj7TUDNsfWSRJAH2BilZyC2Wj+xbKU8E3r0VqcKLXwkk49hBegxeuec0JUHDK/7TflJuiTqkm0Dj2uW+2JD8TBJfi8xcwVNyNWDW6PvhR+rcSHx5ydEsU17TOJzlc7TNw5SnnQPgeApCGNoMOeKBPCiwQJUo2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Marc,

On Wed, 23 Jul 2025 at 09:33, Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 17 Jul 2025 17:27:28 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Enable host userspace mmap support for guest_memfd-backed memory on
> > arm64. This change provides arm64 with the capability to map guest
> > memory at the host directly from guest_memfd:
> >
> > * Define kvm_arch_supports_gmem_mmap() for arm64: The
> >   kvm_arch_supports_gmem_mmap() macro is defined for arm64 to be true if
> >   CONFIG_KVM_GMEM_SUPPORTS_MMAP is enabled. For existing arm64 KVM VM
> >   types that support guest_memfd, this enables them to use guest_memfd
> >   with host userspace mappings. This provides a consistent behavior as
> >   there are currently no arm64 CoCo VMs that rely on guest_memfd solely
> >   for private, non-mappable memory. Future arm64 VM types can override
> >   or restrict this behavior via the kvm_arch_supports_gmem_mmap() hook
> >   if needed.
> >
> > * Select CONFIG_KVM_GMEM_SUPPORTS_MMAP in arm64 Kconfig.
> >
> > * Enforce KVM_MEMSLOT_GMEM_ONLY for guest_memfd on arm64: Checks are
> >   added to ensure that if guest_memfd is enabled on arm64,
> >   KVM_GMEM_SUPPORTS_MMAP must also be enabled. This means
> >   guest_memfd-backed memory slots on arm64 are currently only supported
> >   if they are intended for shared memory use cases (i.e.,
> >   kvm_memslot_is_gmem_only() is true). This design reflects the current
> >   arm64 KVM ecosystem where guest_memfd is primarily being introduced
> >   for VMs that support shared memory.
> >
> > Reviewed-by: James Houghton <jthoughton@google.com>
> > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > Acked-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 4 ++++
> >  arch/arm64/kvm/Kconfig            | 2 ++
> >  arch/arm64/kvm/mmu.c              | 7 +++++++
> >  3 files changed, 13 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 3e41a880b062..63f7827cfa1b 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -1674,5 +1674,9 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt);
> >  void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *res1);
> >  void check_feature_map(void);
> >
> > +#ifdef CONFIG_KVM_GMEM
> > +#define kvm_arch_supports_gmem(kvm) true
> > +#define kvm_arch_supports_gmem_mmap(kvm) IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP)
> > +#endif
>
> nit: these two lines should be trivially 'true', and the #ifdef-ery
> removed, since both KVM_GMEM and KVM_GMEM_SUPPORTS_MMAP are always
> selected, no ifs, no buts.

I'll fix these.

> >
> >  #endif /* __ARM64_KVM_HOST_H__ */
> > diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> > index 713248f240e0..323b46b7c82f 100644
> > --- a/arch/arm64/kvm/Kconfig
> > +++ b/arch/arm64/kvm/Kconfig
> > @@ -37,6 +37,8 @@ menuconfig KVM
> >       select HAVE_KVM_VCPU_RUN_PID_CHANGE
> >       select SCHED_INFO
> >       select GUEST_PERF_EVENTS if PERF_EVENTS
> > +     select KVM_GMEM
> > +     select KVM_GMEM_SUPPORTS_MMAP
> >       help
> >         Support hosting virtualized guest machines.
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 8c82df80a835..85559b8a0845 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -2276,6 +2276,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
> >       if ((new->base_gfn + new->npages) > (kvm_phys_size(&kvm->arch.mmu) >> PAGE_SHIFT))
> >               return -EFAULT;
> >
> > +     /*
> > +      * Only support guest_memfd backed memslots with mappable memory, since
> > +      * there aren't any CoCo VMs that support only private memory on arm64.
> > +      */
> > +     if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new))
> > +             return -EINVAL;
> > +
> >       hva = new->userspace_addr;
> >       reg_end = hva + (new->npages << PAGE_SHIFT);
> >
>
> Otherwise,
>
> Reviewed-by: Marc Zyngier <maz@kernel.org>

Thanks for the reviews!

Cheers,
/fuad

>         M.
>
> --
> Jazz isn't dead. It just smells funny.

