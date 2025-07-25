Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 988F7C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 19:34:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 406936B0092; Fri, 25 Jul 2025 15:34:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DDF46B0093; Fri, 25 Jul 2025 15:34:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31BB26B0095; Fri, 25 Jul 2025 15:34:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F4C26B0092
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:34:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C0AEA5B855
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 19:34:36 +0000 (UTC)
X-FDA: 83703788952.08.13B5B35
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf13.hostedemail.com (Postfix) with ESMTP id 154E920008
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 19:34:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="uJi/Te3y";
	spf=pass (imf13.hostedemail.com: domain of 3SdyDaAsKCFw46E8LF8SNHAAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3SdyDaAsKCFw46E8LF8SNHAAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753472075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FNIIO64ZvPt1HNs+swyYLqJ+PxWQ4jTBObewY8wp0+4=;
	b=Lcn2DMaYui2A/G0D9117i461k99Xxu3V6X+vjvNJBWq2Eo8ZhG5UjXDwzzkQV3crXyNA2Y
	smhZYw/p4KdfeDEKMXWyeVjC64Xthb3y6ORrtqYG+DVueX1YRASGVC6i8rOOmsL95zMZz9
	m/aEWAVo8vu7Ga3jjCfvbsskrHd970Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753472075; a=rsa-sha256;
	cv=none;
	b=7SDWLdtEa8+4+IUvyANDH/OEsbuuhxtj87s7U8V5UIq2rzaPi9+RKdVsyM4Wq0Ip0IF/NZ
	sgz2r4EK3wAIFvJLNGhMN5d5aMYVTQuZ3D32+pFg6HCMe29ke5BwkCP/p8evMWqeVqClWN
	D+9vdRgrfoikHCdP7bSEByJRYdF38ZU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="uJi/Te3y";
	spf=pass (imf13.hostedemail.com: domain of 3SdyDaAsKCFw46E8LF8SNHAAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3SdyDaAsKCFw46E8LF8SNHAAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-234b133b428so19255765ad.3
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 12:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753472074; x=1754076874; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FNIIO64ZvPt1HNs+swyYLqJ+PxWQ4jTBObewY8wp0+4=;
        b=uJi/Te3ygsKrdaL/H/5BoIxjHURXPV/LMgL3mTaTCw52reNLiZ58dRrj78Sgf9tF5o
         FLPZZElLAY4/Y3y7lNKR86/cNSs83bO6gvzgGplkNKNOiYrIHzv69Zhny+52fozKWFAE
         ZN1cqzOT/cZkmmEsI1gCQw11pTdzfeZx981sewXnJ8pT+2RzAfdH5p6FPTdhX603eiUJ
         7b/VDTqNnNxbRtV0TVS30/4rn/RsYW888OX+D1iXn8Tqgm4vdImr/enhwfuN9tIc+WwF
         71VjsV6ZzOcVTh0CyuKJMchObBeKTL4USv/pWst7ek3sxB2SvXE23hoZW5w8Ssdk9zKN
         l6XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753472074; x=1754076874;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FNIIO64ZvPt1HNs+swyYLqJ+PxWQ4jTBObewY8wp0+4=;
        b=MKJffRfZwo7Nj3EyY5bs7SUi3HlMZuLwPglp/fuI6kqRI+aYGIElKvnBQxWfxCtRyz
         FSvIFe/j5v+OFhDM88/BBDbtQKvJurOXEGDA05garOwiQFm/j2iLW15J1XF/BTyA9eAO
         xAzToBOpdkiksROvH5Ew63mAs6PBrJHgo+69F9utPtxEZeEI9Pjti8BWQj5jAwkgt7vz
         0tR32hKwl/DCO+kYJMlSDOuuJm27yxNkdFL7jE72QWZ73Q7hnFMybIa3CIxmyAw/X/0h
         tZ0cTCGq6mmttR8Ezz/40erzccvXfeCgW5Fj+WseE29Ylmuh54etLfsAbMTAprqPi2tG
         XWjg==
X-Forwarded-Encrypted: i=1; AJvYcCVgjR3gEupNshShDNPMGlEvUdbiAuTYDAtm+AJbIUiaj00qSnxOkHLvZzF3TgDgyhHIuMQgEBTv0Q==@kvack.org
X-Gm-Message-State: AOJu0YwDh7WLS5FeOecADJqeyihOwmVNds8sz1o2atOQPAI99KE4RqE7
	FyXyuBK7AI22h/y0fYorG5W5CIKFkevhQmAOFv7JdyXdWO8L+cyUJ94XRaXqdNoXnmTNwA2tra6
	wT+in++6qYEyrBmc6qYb+jkFbcQ==
X-Google-Smtp-Source: AGHT+IGnEr3d6PZ3nIW41bH2DK3NPEY+F29AhLyvRFiA1YTCx5wX/C0Qtpn2kKuofqLWGxfCAZp6KUT5h5T5fvXdlg==
X-Received: from pjzz6.prod.google.com ([2002:a17:90b:58e6:b0:313:274d:3007])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:37ce:b0:2ee:d371:3227 with SMTP id 98e67ed59e1d1-31e77af4429mr5242184a91.17.1753472073748;
 Fri, 25 Jul 2025 12:34:33 -0700 (PDT)
Date: Fri, 25 Jul 2025 12:34:32 -0700
In-Reply-To: <aIO7PRBzpFqk8D13@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-16-tabba@google.com>
 <diqza54tdv3p.fsf@ackerleytng-ctop.c.googlers.com> <aIOMPpTWKWoM_O5J@google.com>
 <diqzy0sccjfz.fsf@ackerleytng-ctop.c.googlers.com> <aIO7PRBzpFqk8D13@google.com>
Message-ID: <diqzseikcbef.fsf@ackerleytng-ctop.c.googlers.com>
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 154E920008
X-Stat-Signature: cgguurjb7wetnhc6egmx6qoo1rwwu1dn
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753472074-614260
X-HE-Meta: U2FsdGVkX1/kjUjJA/nn9JK37Wu4XGzDCXtIUQK+NGRR5/gj0Tt06+Ar+K9+iq44rUlcjvt+XhXUbtAs45jZj0+kt49IXA3l+talEqP2R21L26dPqMTCg35bOQLtsTHO0A959o0UhRl1f+aYgxlk6JEIpxoEj8UvBiw5lIVKbNI8HD7NegF31567NDqR2PD2/AKdoOM0HCJlUzq+V5DCn1GUyQdDNKfMWBk5S6d/Vaynl0YGjX9YfH3OVUUNm4KTQu6UrbIHCF4NEJpBpxLH8pSCXZadP7M9k7fyWbVPTbbnGXhRoqfhOUcJp6cjEy48fY9BPAMh2g4Pg2VRhUZ60+4WK3Np+JSk0SwtDTOqpl78FoIED+Vikglr6qKGZZvTY6Ueb5g9rrUUvalhkieD0z5jryG4ZqRZwNosrdLUOEOvfLIoHSuzdqBQ34Hfa4cLWePcyxbZBQPMByO7MNMk90uZ3Hwb/rhZ1oBI+KqrJk2u4XnZ2HcIrH3gXTOlGmmEv6AjB/1uz6HevJZgvVz2O2nhAyfp5SXG17ChXs6DpxTiqATKHkpENVDER8OYPIoty6EVDodSFUG9ltEsjvXrh4e2hrUAe4+WNrn7FB8Mj4YteqmH9p4C7Mesv6+kYq/a70QOqDnHlKlQ2aUlw6z5Ee+tHB2UaFP4f0Wb/7LSQ4XzDMrrGfrGK3dmwj067ijScMLOypjf43iumnNQN/R/MDq/L4N2VZFl3reCjx4K84MdJmxYecHp6QwG4XMS6qRJsPdb8SHwyooO0o+0apWbIhnRIcuKsrZpnqmiJgiwsccokalyR5SNA4LwZ4L0dmlUz4t+Ta+z1NQi5gbLJ8Iso18AIi7HZrtUqJ6uwnsDd7xE02r2RF3Mu6C5jz+kIN6kY1Tbf+jAg1Y7gEixczyIV7g1QsY8cUaj/956c4YyojFz6OEhHJaH3CghJkPDoWU2m+gjPmtaMQyvXutS25I
 N1WSt57a
 FUa4SXMx41ZyY6yUPH0WZu90qrKJWWQgfJlNDNxZz4fsCBjfSibaJLdNTZHSia/0CH8XErgstLIG9YBbqFLtowO2CaNRnxViZajbaACnL4AJyyo5/d4wBIjEZL4rRQjNAUwWmFPrMct4lYGehstyHCVhaIektBYnYD70BryFfEMXgc8JQPsOEtGzu5FfCpHpzsDuiobXSTptYtoF6EjUx1iG/SY0mQM1vfi98pTB0uPo+Q7kH2jvgmRw9AdNLMCm/GU+MNibTAZz3O7+INzbmqEuMYtpgeSx950dAGLJaY+QlSs5yZGtwkoMVW4y7DTmIrzUIFwHO9UeBJEnLWkBZ9byQGM9GFjr94K/Mha3bJ9A8//IArTfbuKJiYsf738pU4Tngyxco1kX1aRq0RIQp51xetw==
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
>>=20
>> > On Thu, Jul 24, 2025, Ackerley Tng wrote:
>> >> Fuad Tabba <tabba@google.com> writes:
>> >> >  int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fau=
lt *fault,
>> >> > @@ -3362,8 +3371,9 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm=
, struct kvm_page_fault *fault,
>> >> >  	if (max_level =3D=3D PG_LEVEL_4K)
>> >> >  		return PG_LEVEL_4K;
>> >> > =20
>> >> > -	if (is_private)
>> >> > -		host_level =3D kvm_max_private_mapping_level(kvm, fault, slot, g=
fn);
>> >> > +	if (is_private || kvm_memslot_is_gmem_only(slot))
>> >> > +		host_level =3D kvm_gmem_max_mapping_level(kvm, fault, slot, gfn,
>> >> > +							is_private);
>> >> >  	else
>> >> >  		host_level =3D host_pfn_mapping_level(kvm, gfn, slot);
>> >>=20
>> >> No change required now, would like to point out that in this change
>> >> there's a bit of an assumption if kvm_memslot_is_gmem_only(), even fo=
r
>> >> shared pages, guest_memfd will be the only source of truth.
>> >
>> > It's not an assumption, it's a hard requirement.
>> >
>> >> This holds now because shared pages are always split to 4K, but if
>> >> shared pages become larger, might mapping in the host actually turn o=
ut
>> >> to be smaller?
>> >
>> > Yes, the host userspace mappens could be smaller, and supporting that =
scenario is
>> > very explicitly one of the design goals of guest_memfd.  From commit a=
7800aa80ea4
>> > ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing m=
emory"):
>> >
>> >  : A guest-first memory subsystem allows for optimizations and enhance=
ments
>> >  : that are kludgy or outright infeasible to implement/support in a ge=
neric
>> >  : memory subsystem.  With guest_memfd, guest protections and mapping =
sizes
>> >  : are fully decoupled from host userspace mappings.   E.g. KVM curren=
tly
>> >  : doesn't support mapping memory as writable in the guest without it =
also
>> >  : being writable in host userspace, as KVM's ABI uses VMA protections=
 to
>> >  : define the allow guest protection.  Userspace can fudge this by
>> >  : establishing two mappings, a writable mapping for the guest and rea=
dable
>> >  : one for itself, but that=E2=80=99s suboptimal on multiple fronts.
>> >  :=20
>> >  : Similarly, KVM currently requires the guest mapping size to be a st=
rict
>> >  : subset of the host userspace mapping size, e.g. KVM doesn=E2=80=99t=
 support
>> >  : creating a 1GiB guest mapping unless userspace also has a 1GiB gues=
t
>> >  : mapping.  Decoupling the mappings sizes would allow userspace to pr=
ecisely
>> >  : map only what is needed without impacting guest performance, e.g. t=
o
>> >  : harden against unintentional accesses to guest memory.
>>=20
>> Let me try to understand this better. If/when guest_memfd supports
>> larger folios for shared pages, and guest_memfd returns a 2M folio from
>> kvm_gmem_fault_shared(), can the mapping in host userspace turn out
>> to be 4K?
>
> It can be 2M, 4K, or none.
>
>> If that happens, should kvm_gmem_max_mapping_level() return 4K for a
>> memslot with kvm_memslot_is_gmem_only() =3D=3D true?
>
> No.
>
>> The above code would skip host_pfn_mapping_level() and return just what
>> guest_memfd reports, which is 2M.
>
> Yes.
>
>> Or do you mean that guest_memfd will be the source of truth in that it
>> must also know/control, in the above scenario, that the host mapping is
>> also 2M?
>
> No.  The userspace mapping, _if_ there is one, is completely irrelevant. =
 The
> entire point of guest_memfd is eliminate the requirement that memory be m=
apped
> into host userspace in order for that memory to be mapped into the guest.
>

If it's not mapped into the host at all, host_pfn_mapping_level() would
default to 4K and I think that's a safe default.

> Invoking host_pfn_mapping_level() isn't just undesirable, it's flat out w=
rong, as
> KVM will not verify slot->userspace_addr actually points at the (same) gu=
est_memfd
> instance.
>

This is true too, that invoking host_pfn_mapping_level() could return
totally wrong information if slot->userspace_addr points somewhere else
completely.

What if slot->userspace_addr is set up to match the fd+offset in the
same guest_memfd, and kvm_gmem_max_mapping_level() returns 2M but it's
actually mapped into the host at 4K?

A little out of my depth here, but would mappings being recovered to the
2M level be a problem?

For enforcement of shared/private-ness of memory, recovering the
mappings to the 2M level is okay since if some part had been private,
guest_memfd wouldn't have returned 2M.

As for alignment, if guest_memfd could return 2M to
kvm_gmem_max_mapping_level(), then userspace_addr would have been 2M
aligned, which would correctly permit mapping recovery to 2M, so that
sounds like it works too.

Maybe the right solution here is that since slot->userspace_addr need
not point at the same guest_memfd+offset configured in the memslot, when
guest_memfd responds to kvm_gmem_max_mapping_level(), it should check if
the requested GFN is mapped in host userspace, and if so, return the
smaller of the two mapping levels.

> To demonstrate, this must pass (and does once "KVM: x86/mmu: Handle guest=
 page
> faults for guest_memfd with shared memory" is added back).
>

Makes sense :)

[snip]

