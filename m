Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E84FAC83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 09:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80D0A6B0095; Wed, 23 Jul 2025 05:23:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E4E06B0096; Wed, 23 Jul 2025 05:23:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FB786B0098; Wed, 23 Jul 2025 05:23:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5AE966B0095
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 05:23:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C51871DAB02
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:22:58 +0000 (UTC)
X-FDA: 83694990036.16.5CC625E
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf06.hostedemail.com (Postfix) with ESMTP id F411518000F
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:22:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ijB3hff4;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of tabba@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=tabba@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753262577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q1l9DC9s6bqSZlXl3hk+96usOVx+LGIZFtzxNIqVYEY=;
	b=Xlxld2n19c2DGcPN/R+/w/F5nijRRYZ8BbWFByjzhuQenWKvIs/JFkTrzN7FabKu6fo56Y
	RUKS1Kyp2RTQ/8wiw0X3b4RaTG4jh8KLIjYJn5vV6lqqzjCyrNrxsQpDT6Da3IUwzaROzC
	qWUzkGPBY+/pR9TAC1Ijybsw5DdRfHM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753262577; a=rsa-sha256;
	cv=none;
	b=RQ5Jya+hWZU9f4pmRnPuQi9w5TBeFbktDrLt+unbY1F24FE080pSeIh7pU6zASfoQ0ReyA
	0ojaLI2G9faWLTV2sf4YRSmMsOu0n+vMKKLg3YvNMUguhJP++3U/cqeXueK9zW697lkUXF
	lPAmJxQD5dp0WkiUvHuGvUgvar31oPE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ijB3hff4;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of tabba@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=tabba@google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso349441cf.0
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 02:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753262576; x=1753867376; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q1l9DC9s6bqSZlXl3hk+96usOVx+LGIZFtzxNIqVYEY=;
        b=ijB3hff4PFAAqghKVPUy176oBV2fhOqyesHP/YI5gQUbAwajyIvkruxsOWMiNig6/o
         7nYDUn1ga37QJ5frF/162R7HvjOZFx4do3ohbl1Um9DTF39Z0qaTh0Jh3OIrvCYFdutb
         eqkPTeU9P1h/0EVyzsv5v+VbqIx8QNvdUyWVVvCG7w9lzvtfBuScQL8YOffIVBpZ8DyC
         VD6XEntw5LBptKNeXYCa0IVWO7nawCOQSGQEfPYMUpydtT9erIhoFDaOcujZah/gbl00
         JKZNLx5icki9rFW4JKe2vKFNvvr3WaOjuDgTG8OkLIgwJL5UpzTAr3P+s3EbtKx+sbAm
         KphA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753262576; x=1753867376;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q1l9DC9s6bqSZlXl3hk+96usOVx+LGIZFtzxNIqVYEY=;
        b=wPLbf0DatcmPIXvYjiATB0cJE32KYUdkLXtMflrGwFife0UJKOi+ho0iEQj32x+F2Y
         jOIjFh4F/UnqEU5PU/tJVC/U2WEpT7LoVD16cXoipfbvJqSqxU00Csetn34o5oJII+Gr
         XV4qBnij2HLsWLOIPPzT7qsbgmz9LVpVlQYiGtNRtmhUvU5YfkvD9UfoduWonuyduVkQ
         lKBcouQTXGY1aOGUAhS2qBHC4hJ4GDBtgtErsn60OFy5aTM8waVkwYIUg7VHdXMqTxqZ
         CcIN22hBKBddwBhXs6Otw6TIXfVlQNZq4XGBPVSSr2aJsG7fXJSpU2o1spwSwv6/z2+i
         Bzjg==
X-Forwarded-Encrypted: i=1; AJvYcCUPZtssxEY3SW5gDzQ5pRmoWZycxtwWvVXs1zsQngJJDskqVc4nH4bTRoXIYbe/fhkK8pVgk3+zxA==@kvack.org
X-Gm-Message-State: AOJu0YwfsEz68Y9Grxf6M99DbD1kMrAm8AbDtom2eYi+jkS0kS9/Ga30
	jVO0ZYN6Zp+eOg/mH8rrsnSjnA4Fhbso7s8ss1EQPsxJRFKAKISYbwzdPWyr54Dz8wIQtR9NRuB
	lmwhsj2JLOEjGXY56O9V68p5ecPGQCqYLA6hZ98WK
X-Gm-Gg: ASbGncvRyKg8DzhhIDafaV6h/X33NfqMUop9eKv+kRcVZ/TuWfb+L9h/K7zLr41Pzxv
	EnLEth0Yw4ZqKn4b8ks/sX3EFreq0891uZzBhkZfJWsY0uhk1LlhueqJ7PVm3depqxMec5g0mnb
	5/Yt/VOriH6o5uYNaViOIJDKg3rAgNrL4SvWaOPkQFRYGFwNfk6oupXiLlyiJJcCpLEPoDZJdGt
	woKljEv2mZo5d7OtdgTdvWSJMXQ6moLT0Kx
X-Google-Smtp-Source: AGHT+IHpGSWUb20Op9Qp28Uz72zppWmO/fpdDBu9sBC5ToKI3zBiTnA4LkrTZ+17aXYm0O7UQ4tqXYX6jHbEEiExdf0=
X-Received: by 2002:a05:622a:551a:b0:4a8:eb0:c528 with SMTP id
 d75a77b69052e-4ae6f066032mr2643391cf.15.1753262575605; Wed, 23 Jul 2025
 02:22:55 -0700 (PDT)
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-3-tabba@google.com>
 <aH5uY74Uev9hEWbM@google.com> <CA+EHjTxcgCLzwK5k+rTf2v_ufgsX0AcEzhy0EQL-pvmsg9QQeg@mail.gmail.com>
 <aH552woocYo1ueiU@google.com> <CA+EHjTwPnFLZ1OxKkV5gqk_kU_UU_KdupAGDoLbRyK__0J+YeQ@mail.gmail.com>
 <aH-1JeJH2cEvyEei@google.com> <CA+EHjTw46a+NCcgGXQ1HA+a3MSZD9Q97V8W-Xj5+pYuTh4Z2_w@mail.gmail.com>
 <aIAh3xkU52Z100xK@google.com>
In-Reply-To: <aIAh3xkU52Z100xK@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 23 Jul 2025 10:22:19 +0100
X-Gm-Features: Ac12FXy0a_zhWCTWrmc8iH91Uu03l4tlmUMT8pdCRl-WsFj9mim4tPfVNS6-H9U
Message-ID: <CA+EHjTy_82ADyf05-ySq-+901bT+W30EXm7t4ppvVAd5Eds40Q@mail.gmail.com>
Subject: Re: [PATCH v15 02/21] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
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
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: F411518000F
X-Stat-Signature: jbb1ioegmjnzbcmm6zs85efonrn5wncr
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753262576-478034
X-HE-Meta: U2FsdGVkX1/DzP5AVwspUdMIuJQnl2RLz0tbfAir9D0OS/VOlozwewmfkNzSqtkAqNvlgRQ2QDQneElDf8pMa2nD260EYOGvSN5459CHQ0k0WGuFdNSs2/3He93t4FphowwA1TwOTANUOgAD/FwsoZFFuR+TPYnShX6gbxW80V21/gg+ec/QrulWmjUm61Py9WByidcARv20uoXci0Y2mSgtVYqmAt/JiHWKqS+7qYaURAUnsyEwDJUmQkqgtDnw5PgL37uf2S93QVrt7MWf0JK8Qg89uCh9LI7V5upg8aM1//Rthno4SOv7D3dpmnn6uM3mde4NrfXP/dWf+ALNKqmLprTfK3oc0FipRZUMdrMfpWL0UFL5/tLNXCAzWppDTH3fiwuKW+YQCg9tftF2za7u/niAby//4/B6jRPLbE+/KvDvrDBqo7IZyBFZ87kVLEiW9TcibNrmZH/awOadwb1SCwKSfGeS3EzSC9ZrupwUucCQH5bN8EzEAqnUqK921UzCtLrOF5vWaLj6+FtV1BhicAws9jPvQ7e07XQtqDi7No2YN0rAAkY8fUV/CTwUsOq1nklORy+3TC8tahyAQn9/vBa1qnk0oewhebfoNbrM1WpGcCUylFW1YxtwkG+MuMmYNxJkfJKWXfa3vUkVxv2oo60yBFjUAU3cPUKEb/e+zMyHPb1p+poYWUycsVZmF6SC5zrsKjKjEw+r0SUeHiHQt5Ugz3d1XxiA/Q/5GlBj6Yz5H/HH83zjw7yL+mJyPnA/JSOevWGypk+CA/878SsGc1PcgI1tkDXZIxb2AWwHt2vObNazeaZ/CynzM7oA7Q6x9risevXVguhOYpYRgXL/gv8fqPswdeL3J8MR3oXnRMzBIoyow0UmwEtUim1EGExFbChnbhDYyt1crsdLKVkLbw9hn/Ud1yqZ8u+iEu8wsvVmQzKifAgyWFLuH+tQ1cNPXnK5OXFa/bGDjpJ
 qjc6Cien
 PQRkM25GCWC3fycE7VQTDJIZ2/EkQ9y0ZeGaEpswiAUokhwUIOGb8jD0kiZDyMyn2BNyZPCpFTlbLMO6L7aw0NFESG1Wg+5UOTmec/P6MEFo1uBDVm1Nae4xuXMQckneP9gABEjmvbu/O86j2rlG6z4Q0bNCtX1l0t/LNSJSdnTFytoefcTM0h5YXY47HPmGf1T1PjrEi+G8UQ5/fDFLgCMf0juRCCNMe9+TfRQvy2Q6D0GLeFh58NqryvrI2GRDN25wuzR78AbzntcqjvFHSW9wcK61jD86ppl5CVvJA3WLkjI/EApifxx4Ki71xtqEjqLwGFTKnp90WRZ9oQ4F+pbQkAnagj5MiAs5EFLnw3YDgcHYmSKYCgkVqoQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 23 Jul 2025 at 00:42, Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Jul 22, 2025, Fuad Tabba wrote:
> > On Tue, 22 Jul 2025 at 16:58, Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Tue, Jul 22, 2025, Fuad Tabba wrote:
> > > > On Mon, 21 Jul 2025 at 18:33, Sean Christopherson <seanjc@google.com> wrote:
> > > > >
> > > > > On Mon, Jul 21, 2025, Fuad Tabba wrote:
> > > > > > > The below diff applies on top.  I'm guessing there may be some intermediate
> > > > > > > ugliness (I haven't mapped out exactly where/how to squash this throughout the
> > > > > > > series, and there is feedback relevant to future patches), but IMO this is a much
> > > > > > > cleaner resting state (see the diff stats).
> > > > > >
> > > > > > So just so that I am clear, applying the diff below to the appropriate
> > > > > > patches would address all the concerns that you have mentioned in this
> > > > > > email?
> > > > >
> > > > > Yes?  It should, I just don't want to pinky swear in case I botched something.
> > > >
> > > > Other than this patch not applying, nah, I think it's all good ;P. I
> > > > guess base-commit: 9eba3a9ac9cd5922da7f6e966c01190f909ed640 is
> > > > somewhere in a local tree of yours. There are quite a few conflicts
> > > > and I don't think it would build even if based on the right tree,
> > > > e.g.,  KVM_CAP_GUEST_MEMFD_MMAP is a rename of KVM_CAP_GMEM_MMAP,
> > > > rather an addition of an undeclared identifier.
> > > >
> > > > That said, I think I understand what you mean, and I can apply the
> > > > spirit of this patch.
> > > >
> > > > Stay tuned for v16.
> > >
> > > Want to point me at your branch?  I can run it through my battery of tests, and
> > > maybe save you/us from having to spin a v17.
> >
> > That would be great. Here it is:
> >
> > https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/guestmem-basic-6.16-v16
> >
> > No known issues from my end. But can you have a look at the patch:
> >
> > KVM: guest_memfd: Consolidate Kconfig and guest_memfd enable checks
> >
> > In that I collected the changes to the config/enable checks that
> > didn't seem to fit well in any of the other patches.
>
> Regarding config stuff, patch 02, KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
> CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE, is missing a KVM_GMEM => KVM_GUEST_MEMFD rename.
>
> While playing with this, I also discovered why this code lives in the KVM_X86 config:
>
>   select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM
>
> Commit ea4290d77bda ("KVM: x86: leave kvm.ko out of the build if no vendor module
> is requested") didn't have all the vendor netural configs depend on KVM_X86, and
> so it's possible to end up with unmet dependencies.  E.g. KVM_SW_PROTECTED_VM can
> be selected with KVM_X86=n, and thus with KVM_GUEST_MEMFD=n.
>
> We could punt on that mess until after this series, but that'd be a even more
> churn, and I'm not sure I could stomach giving acks for the continued addition
> of ugly kconfig dependencies. :-)
>
> Lastly, regarding "Consolidate Kconfig and guest_memfd enable checks", that needs
> to land before f6a5f3a22bbe ("KVM: guest_memfd: Allow host to map guest_memfd pages"),
> otherwise KVM will present a weird state where guest_memfd can be used for default
> VMs, but if and only KVM_GUEST_MEMFD happens to be selected by something else.
> That also provides a better shortlog: "KVM: x86: Enable KVM_GUEST_MEMFD for all
> 64-bit builds".  The config cleanups and consolidations are a nice side effect,
> but what that patch is really doing is enabling KVM_GUEST_MEMFD more broadly.
>
> Actually, all of the arch patches need to come before f6a5f3a22bbe ("KVM: guest_memfd:
> Allow host to map guest_memfd pages"), otherwise intermediate builds will have
> half-baked support for guest_memfd mmap().  Or rather, KVM shouldn't let userspace
> enable GUEST_MEMFD_FLAG_MMAP until all the plumbing is in place.  I suspect that
> trying to shuffle the full patches around will create cyclical dependency hell.
> It's easy enough to hold off on adding GUEST_MEMFD_FLAG_MMAP until KVM is fully
> ready, so I think it makes sense to just add GUEST_MEMFD_FLAG_MMAP along with the
> capability.
>
> Rather than trying to pass partial patches around, I pushed a branch to:
>
>   https://github.com/sean-jc/linux.git x86/gmem_mmap
>
> Outside of the x86 config crud, and deferring GUEST_MEMFD_FLAG_MMAP until KVM is
> fully prepped, there _shouldn't_ be any changes relatively to what you have.
>
> Note, it's based on:
>
>   https://github.com/kvm-x86/linux.git next
>
> as there are x86 kconfig dependencies/conflicts with changes that are destined
> for 6.17 (and I don't think landing this in 6.17 is realistic, i.e. this series
> will effectively follow kvm-x86/next no matter what).
>
> I haven't done a ton of runtime testing yet, but it passes all of my build tests
> (I have far too many configs), so I'm reasonably confident all the kconfig stuff
> isn't horribly broken.
>
> Oh, and I also squashed this into the very last patch.  The curly braces, line
> wrap, and hardcoded boolean are all superfluous.

Thank you for this. These patches look good to me.

I've tested them on x86 and arm64, and everything runs fine. I'll have
a closer look at them, and probably send v16 later today.

I know that it's probably too late for 6.17, but it would be great if
we could queue this for 6.18.

Cheers,
/fuad


> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index 4cdccabc160c..a0c5db8fd72d 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -249,8 +249,7 @@ static bool check_vm_type(unsigned long vm_type)
>         return kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(vm_type);
>  }
>
> -static void test_with_type(unsigned long vm_type, uint64_t guest_memfd_flags,
> -                          bool expect_mmap_allowed)
> +static void test_with_type(unsigned long vm_type, uint64_t guest_memfd_flags)
>  {
>         struct kvm_vm *vm;
>         size_t total_size;
> @@ -272,7 +271,7 @@ static void test_with_type(unsigned long vm_type, uint64_t guest_memfd_flags,
>
>         test_file_read_write(fd);
>
> -       if (expect_mmap_allowed) {
> +       if (guest_memfd_flags & GUEST_MEMFD_FLAG_MMAP) {
>                 test_mmap_supported(fd, page_size, total_size);
>                 test_fault_overflow(fd, page_size, total_size);
>
> @@ -343,13 +342,11 @@ int main(int argc, char *argv[])
>
>         test_gmem_flag_validity();
>
> -       test_with_type(VM_TYPE_DEFAULT, 0, false);
> -       if (kvm_has_cap(KVM_CAP_GUEST_MEMFD_MMAP)) {
> -               test_with_type(VM_TYPE_DEFAULT, GUEST_MEMFD_FLAG_MMAP,
> -                              true);
> -       }
> +       test_with_type(VM_TYPE_DEFAULT, 0);
> +       if (kvm_has_cap(KVM_CAP_GUEST_MEMFD_MMAP))
> +               test_with_type(VM_TYPE_DEFAULT, GUEST_MEMFD_FLAG_MMAP);
>
>  #ifdef __x86_64__
> -       test_with_type(KVM_X86_SW_PROTECTED_VM, 0, false);
> +       test_with_type(KVM_X86_SW_PROTECTED_VM, 0);
>  #endif
>  }

