Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6C9EC87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 22:26:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 325BA6B007B; Fri, 25 Jul 2025 18:26:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3049F6B0089; Fri, 25 Jul 2025 18:26:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 213916B008A; Fri, 25 Jul 2025 18:26:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 165686B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:26:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EF5AB13422A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 22:26:02 +0000 (UTC)
X-FDA: 83704220964.04.85504F4
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2FC3116000C
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 22:26:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pjbhmd2g;
	spf=pass (imf08.hostedemail.com: domain of 3dwSEaAsKCNo68GANHAUPJCCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3dwSEaAsKCNo68GANHAUPJCCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753482361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Lq9QQ8w3hMdR19q3/dpKc/mSw+VikFUTc+/jJzJxpA=;
	b=YPt338dM7qc7eIC9uK8Qkq5qs+u0cZgf4BxnzMQeXcMMsvSfwkuh8Yft5WG5K7/dXJTSJx
	Iqklgw5Kp+5d5T/+FaXzBmkde6bmnf+OUlxGAJfgIN3pwtoTA3thh1+wyruaFzFZpeihc1
	ydaY/M5lsYlUAjd7TWBFB5SWmRPYkiw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pjbhmd2g;
	spf=pass (imf08.hostedemail.com: domain of 3dwSEaAsKCNo68GANHAUPJCCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3dwSEaAsKCNo68GANHAUPJCCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753482361; a=rsa-sha256;
	cv=none;
	b=dSVDX5o46A78uhGnELQy8Qi31nmEx/n/tR711ayPTZNJw0Iw0H1izKTzIosXXEN3XGJs8P
	rCGMGWTEUoadYX4edmPyOjSbF9A4aoWwjinbTF/H9pHXwO3DWWekblaL8jrcWFJSsR+M2u
	W6sfWcc6Nx0JiklvhZCGXrZIhZh0qgQ=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7640573c32aso523114b3a.3
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753482360; x=1754087160; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0Lq9QQ8w3hMdR19q3/dpKc/mSw+VikFUTc+/jJzJxpA=;
        b=pjbhmd2g5x/XFjf5C4fccSIufJj8aZPsK9zdiMVXUU6Iu3f9aIKfajGI31j31V6zfF
         uButpTpSaHRELyz0juJMziiKRc4VZjKodzO4qkugBAS1YdwmMni9C0ySsQmr+zAuxp6b
         euF+pctP5oZkuMCCAqeI4aux8BVzhz4DayxrulUp3C3xhDjgIAMv4SgVfvINBa10Fnw8
         2Qz5HH8mFMjSQmYWMj/359oXC1rREQXvNKjsHeY7kdJigktIEHrG1Y2rmD/8EyCUYlyz
         LI4CR+TiggrAyY+HD+BlEdd8dtA4cSXESclzT9K4W1iNeB1gpvoo0jdR4wFBc35kXgoi
         SEmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753482360; x=1754087160;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Lq9QQ8w3hMdR19q3/dpKc/mSw+VikFUTc+/jJzJxpA=;
        b=WZgnLc/MS5GxQx2kSY0DJXxeMXpo2d2jUe7aRo3y/9/LGkHR7tn3AQAV8KOCRrn5BR
         4Kf+kApEc4N+UGD0KgY4iHsh84fzj92DDRgNehGI4N8ngc+WliR/uUobaEfET9rA+mMU
         baIKf+6vB1bl1RSyPrSHjGHNv49YHe46f7Uv+YdrutwvXo9MUAiz17gCdT9yz/1FHgMk
         VbI1Ob6aDAvy7Pe81KgCnSlVIq2I28kOi4qNBKupdeWU/neLKo4KG1D7794PJ/LdqQeo
         kyLsjQATlMtHlv8yCfq9zqFMfG+tBL5SKBeHcBDAk4AjK4737w25Ltaz2iBvxBLHPY2g
         yYmA==
X-Forwarded-Encrypted: i=1; AJvYcCX5bPmqn9wdUya5oq+y1kIi8KnfbB3IzSdvf/1p1zbcWbhkFUX4Nyy7agSeUIPkPnIq/CiSYYX6mw==@kvack.org
X-Gm-Message-State: AOJu0YygqwSueGf4vjq3i0VMyYqtfHFYczGJfezCfhEZRFffo3Ed/0Ux
	sIS+O4lMdb5y6Ek/yQfds4CgQorkgFg+ZuZQM7hnMoBxmgG74Hmn4uVtkeii5C5Oh9oZDTAbtjV
	CN44l50jwBghAF7b2wjZg8EnR6Q==
X-Google-Smtp-Source: AGHT+IEZxdfrdgDIlR5zUkMlJz/kBxt4HyXLAe0BLt5xpkZQemjoRXVB0UGSeGU8+zfIGfEMo0h1ofcgL6D2PyWz8A==
X-Received: from pfmm16.prod.google.com ([2002:a05:6a00:2490:b0:746:3185:144e])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:84d:b0:74e:ac5b:17ff with SMTP id d2e1a72fcca58-763343da33dmr4952699b3a.13.1753482359896;
 Fri, 25 Jul 2025 15:25:59 -0700 (PDT)
Date: Fri, 25 Jul 2025 15:25:58 -0700
In-Reply-To: <aIP-qSnH1jjuykmP@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-16-tabba@google.com>
 <diqza54tdv3p.fsf@ackerleytng-ctop.c.googlers.com> <aIOMPpTWKWoM_O5J@google.com>
 <diqzy0sccjfz.fsf@ackerleytng-ctop.c.googlers.com> <aIO7PRBzpFqk8D13@google.com>
 <diqzseikcbef.fsf@ackerleytng-ctop.c.googlers.com> <aIPgjOLq8erW06gK@google.com>
 <diqzpldoc5yq.fsf@ackerleytng-ctop.c.googlers.com> <aIP-qSnH1jjuykmP@google.com>
Message-ID: <diqzms8rdi15.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v16 15/22] KVM: x86/mmu: Extend guest_memfd's max mapping
 level to shared mappings
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 2FC3116000C
X-Rspamd-Server: rspam06
X-Stat-Signature: q91ot67fwedb14c1syoj1bkek8cytfu8
X-HE-Tag: 1753482360-805345
X-HE-Meta: U2FsdGVkX18no3lvLrEAd7m6BXZcJEEHoUDl+Ptbeh0KfGtxg1t6g0fVdMcOflQWe+IFa8hzX0GE2634wQFp4DlF+X1Dq5he0JlPTsPeSEsl4uKn9Fr7qr0eCsxIEcDDAx+TU8oKGYIFJMK3LjMWBuolt62obQ6GWwZBcObiWI/JhERCSymmiGoG2HOhZOwm3WstKN0higk/6QDCECV+CTTxAl0Ii8a0bgGtc9HvauTbQ4l0fMwRNpGepGR6h+x6mt6ebRFYT9Jybn6GAMCFDC2PHJZ4gZpDAQ87sHhNbjsQYwMuiK1dss9IPeuECgS0fBk05rU/mTBMqEXOJFjPLkPh0Y5jqX5UACjJzpD4dpwRWULEy3Z8a17/fZnG8c+E6wzISobTGCxPjTCm90d62OK0QE4HkMiG7luV1WJU4yEKkE9dmNbDJ01BFlTnc7QOxZjAlH1uKKcq1alpEW3bB8mvNip9FhK2O6nqmUeWm9gZgwCRkoqb4w59kifQ6FxTs/+knDwpAXr5ADKIL2WuofBAwud31iuiuhhctSXmQWCyf31ysvCw75JuzPjgqqO7R76XCPKDeS7FPSznCd9l1AgcfARtw2R3nkSX3e4MkFncfGFB0NTiqEAhNoMShztG3YgYkrPDCj3TSWfs2mQTurBPHuhgaqKqfybTugptg5BhcMiq7Df8v1TaGDggVmfrThQgaVrEpbUCbMcohke9arcg8LPhWdm+yYa9mV6kmixl7+VpLrjyiVS9eNWN81/FpT1OpHksy8mir8vph3qvWiW1QlykQMnQ5GAxUh9jlxD5ADJvNEw6VLBVlXg27TwotgLRgx/vTKIRRWzuTOXBKsQkgqc53PhGsqkLD47BWpySgUEX0SkSivLONSLlWypaFF/iT9Ub7NtN5m7x1/SCtiGGCnoCymfuSwxhXAWR4I1KTD7lmIU9Gmt3oQKVjpYOhddzQF/osIzgn1RL1Q7
 L5rhwKE0
 orR5aKh9prFj/Xk94jyudXKCZqNx7iZRpYySIxE3z2qH9E9UWuvtlRptenZ2LtWdsaECgYRwa3VMUuDyJsflrh+nx11Nj131LqZiga3Sel8MyFspXUqm/bIKYmJnBsa8ijJSUEs4pCpyVh8FFtsV6U8am/Rv0r8F7NS0lzU+XI4CZu7xEPMynT2TtodcglrZP+xdyIZSK5kYj9Wx+rxSq1nvNSiCjJzZkPNN6SuS3+DLrFTQPkWfRLnzoBGmCAj6Kz6kN+g+iHmzI+3TRvNhcB8RYoqbTiL5qMkztRXMp9WpBz9+tdHzVjHpbUuxMrDMqynPmmA7d6g95LW/ZoTA2y0okBLI2yvUSlaSD+O6xco7GnDpSbf7csBLALepYV7wmQQeCe5XpU8xRVr7x02JNQGLOZQMdWMCYjrzA8ni80FxBuqIwo0AJt/keeTEi76h6bli+LXOTwke7g/IDshpTOYYCqnaO0GNzJTsDIFKuK9uGqvZtFQshC2ET0r2xAkFZd/N2PkffKOH9RlGuxL8t1dITMuJNY3X74Jq6PWgr7bhw0ImMANMqUS4+ibAVhJGsaZ46VVAyvqUr5muNpKr9rhRIKi1JytDSV2eMLOGWovgvG2jPmzF0Ood06OwjebflBapeotj5Wl2QQTuq/Lt/P8BGxScneiO2GYt5sWeSdkrv8QRxslv1yxniBw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Fri, Jul 25, 2025, Ackerley Tng wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> 
>> > On Fri, Jul 25, 2025, Ackerley Tng wrote:
>> >> Sean Christopherson <seanjc@google.com> writes:
>> >> > Invoking host_pfn_mapping_level() isn't just undesirable, it's flat out wrong, as
>> >> > KVM will not verify slot->userspace_addr actually points at the (same) guest_memfd
>> >> > instance.
>> >> >
>> >> 
>> >> This is true too, that invoking host_pfn_mapping_level() could return
>> >> totally wrong information if slot->userspace_addr points somewhere else
>> >> completely.
>> >> 
>> >> What if slot->userspace_addr is set up to match the fd+offset in the
>> >> same guest_memfd, and kvm_gmem_max_mapping_level() returns 2M but it's
>> >> actually mapped into the host at 4K?
>> >> 
>> >> A little out of my depth here, but would mappings being recovered to the
>> >> 2M level be a problem?
>> >
>> > No, because again, by design, the host userspace mapping has _zero_ influence on
>> > the guest mapping.
>> 
>> Not trying to solve any problem but mostly trying to understand mapping
>> levels better.
>> 
>> Before guest_memfd, why does kvm_mmu_max_mapping_level() need to do
>> host_pfn_mapping_level()?
>> 
>> Was it about THP folios?
>
> And HugeTLB, and Device DAX, and probably at least one other type of backing at
> this point.
>
> Without guest_memfd, guest mappings are a strict subset of the host userspace
> mappings for the associated address space (i.e. process) (ignoring that the guest
> and host mappings are separate page tables).
>
> When mapping memory into the guest, KVM manages a Secondary MMU (in mmu_notifier
> parlance), where the Primary MMU is managed by mm/, and is for all intents and
> purposes synonymous with the address space of the userspace VMM.
>
> To get a pfn to insert into the Secondary MMU's PTEs (SPTE, which was originally
> "shadow PTEs", but has been retrofitted to "secondary PTEs" so that it's not an
> outright lie when using stage-2 page tables), the pfn *must* be faulted into and
> mapped in the Primary MMU.  I.e. under no circumstance can a SPTE point at memory
> that isn't mapped into the Primary MMU.
>
> Side note, except for VM_EXEC, protections for Secondary MMU mappings must also
> be a strict subset of the Primary MMU's mappings.  E.g. KVM can't create a
> WRITABLE SPTE if the userspace VMA is read-only.  EXEC protections are exempt,
> so that guest memory doesn't have to be mapped executable in the VMM, which would
> basically make the VMM a CVE factory :-)
>
> All of that holds true for hugepages as well, because that rule is just a special
> case of the general rule that all memory must be first mapped into the Primary
> MMU.  Rather than query the backing store's allowed page size, KVM x86 simply
> looks at the Primary MMU's userspace page tables.  Originally, KVM _did_ query
> the VMA directly for HugeTLB, but when things like DAX came along, we realized
> that poking into backing stores directly was going to be a maintenance nightmare.
>
> So instead, KVM was reworked to peek at the userspace page tables for everything,
> and knock wood, that approach has Just Worked for all backing stores.
>
> Which actually highlights the brilliance of having KVM be a Secondary MMU that's
> fully subordinate to the Primary MMU.  Modulo some terrible logic with respect to
> VM_PFNMAP and "struct page" that has now been fixed, literally anything that can
> be mapped into the VMM can be mapped into a KVM guest, without KVM needing to
> know *anything* about the underlying memory.
>
> Jumping back to guest_memfd, the main principle of guest_memfd is that it allows
> _KVM_ to be the Primary MMU (mm/ is now becoming another "primary" MMU, but I
> would call KVM 1a and mm/ 1b).  Instead of the VMM's address space and page
> tables being the source of truth, guest_memfd is the source of truth.  And that's
> why I'm so adamant that host_pfn_mapping_level() is completely out of scope for
> guest_memfd; that API _only_ makes sense when KVM is operating as a Seconary MMU.

Thanks! Appreciate the detailed response :)

It fits together for me now.

