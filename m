Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B815BC87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 13:53:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35D776B0088; Fri, 25 Jul 2025 09:53:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30DC16B0089; Fri, 25 Jul 2025 09:53:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 223426B008A; Fri, 25 Jul 2025 09:53:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 122636B0088
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 09:53:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B5545BB534
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 13:53:07 +0000 (UTC)
X-FDA: 83702928414.20.4B83A51
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id E5A4C1A0007
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 13:53:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wWfQsISQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3QIyDaAYKCLEjVReaTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3QIyDaAYKCLEjVReaTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753451586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2IFcEZdb1xoyZWA8WbMS+NhaC+YIouhMl5iAhysDSTg=;
	b=5k457YNrsCs4PZvqx9fmEdj77kYCEfuqDvNeN0r898dIILjHRXl37zmB9VJMnZ3ZlPx3R0
	Idj48AzX9O5j9ks6EYGc6hDuSOC5+U5UpG1TxiLzSCdn2D5vr9xnV9CgxrNDlD/zT8IwPB
	IiOg00xSedZfqAXBmwvnFIgOQ6yV/54=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753451586; a=rsa-sha256;
	cv=none;
	b=EBJFpic1TJNYJ1Wcvnhmoihl0v/V8Shs9Fn976cSajXpqrGkCJbAh+J43lTgTg0MX7bQoI
	++5u61qbGqeMq2o0vuGKpn11b1jVymFD1/8nTMUQ4psWiGMOGJJm3htG9NRJvT7Xh9gars
	4SemWdyb2QNmLJtYJx30+Yg/6vRLX1c=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wWfQsISQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3QIyDaAYKCLEjVReaTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3QIyDaAYKCLEjVReaTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31220ecc586so2158744a91.2
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 06:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753451585; x=1754056385; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2IFcEZdb1xoyZWA8WbMS+NhaC+YIouhMl5iAhysDSTg=;
        b=wWfQsISQhV7ZE9pLfyvEFQ9keHtej1oRAFvOcEocRtRYNG1g88/XWoIPkJghqovmJN
         Wgloh1wdKwC+Zm7tKQa64WhB2QSWvMy1n/8B52ijWgz0EBjkaaf2xKRJmHkXpMSxV1Xs
         G117cegQO18g94PMFn7JVhlqFgR+SFVagxlDlePusf1PcSbt4GFiVlkLVSM4UfkNuhfR
         nEcSeHX2ku4/0wN/ibUb8rB4XuqWHbPl0Rea7k2+Ru19H7M1+2/PssSk0ZyDgOW3YwVr
         tZNj2XbF6SdcOwoYkbXMjVAEhqJ6pY818LHcGIACVse0aziBm3X/GMRI/f+5pPvcO6hX
         oX2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753451585; x=1754056385;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2IFcEZdb1xoyZWA8WbMS+NhaC+YIouhMl5iAhysDSTg=;
        b=TO1sKnKfnCFxl8iGnfg11mziV4Hq2UtfCAiM8qXhY+NSmfQGMDTJ1Khz6o0eYxXHgZ
         lG0E9QyRMXYpTCHt4qJKLHutqrmoPhhttZK6ttlq5HJxo0nUC4AZMUB/ra693B40TEPj
         pDAcg69VALpnWzVTjvVtHT8DIEnH27gdyiAjboCbsB1LBLK13UXvJwtHSrROuTe4Eiwc
         dan2rYvAgNWj8YxxZO3bDvgWUeKURCqYnKBSAKiEOuVK2oS/lTUT2AdlQC2vxf9ZJFzJ
         hc2ejlnG+JJKLCDvtUuHJDNON3RD0zmxmknM5L9txW6DBf33oVQTAi47Un+b8PBvHDdz
         hPug==
X-Forwarded-Encrypted: i=1; AJvYcCUeNlhB/UssgNSGlWeBqH66pCKBWdbIqnkCpzmvzEnHvb/30PxFYhsrihbS382McZheG9aPGimWgw==@kvack.org
X-Gm-Message-State: AOJu0YxCvkR2oUHBHgdqqim8RFvF+gTQ7TJqM8E/eLsT1tznse4Zn5BW
	hbziBpwqQnfEnLgW7kEypZlOBNOWCM0WFbZ1HFiUDPog2acHClZJbvzJqw2mOAFzg589hvSbTZn
	AU8z7sA==
X-Google-Smtp-Source: AGHT+IFjGdSbLTJQeXBeF3KPsF2x5fp/wtnoZ2iNYJbBIB/HYs8Zqa8zIKSNCWliwPnicno1k0gnFATv6p4=
X-Received: from pjbsp12.prod.google.com ([2002:a17:90b:52cc:b0:312:1af5:98c9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5804:b0:311:f99e:7f4e
 with SMTP id 98e67ed59e1d1-31e779fa061mr2853030a91.16.1753451584187; Fri, 25
 Jul 2025 06:53:04 -0700 (PDT)
Date: Fri, 25 Jul 2025 06:53:02 -0700
In-Reply-To: <diqza54tdv3p.fsf@ackerleytng-ctop.c.googlers.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-16-tabba@google.com>
 <diqza54tdv3p.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <aIOMPpTWKWoM_O5J@google.com>
Subject: Re: [PATCH v16 15/22] KVM: x86/mmu: Extend guest_memfd's max mapping
 level to shared mappings
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
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
X-Rspamd-Queue-Id: E5A4C1A0007
X-Stat-Signature: i7nieqbp9uzdfkjje99cpuktm414kpin
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753451585-635912
X-HE-Meta: U2FsdGVkX1939kBAfYl9U9NNSB/GbB5N0XXCgK2B8unsGi1D0uq98DMSQBjQ8k+EGakAGopvo7TkXGkbd5xNC1LTy3fZIXZFyLR80uvTEw8BUFpS6fUROcffeE0SarPJH66eDaw2IG0T8sIkYtvQryygzmeWdTOgoXlBFTt3jF2GeFCy7ZKldCis8Yj3Wg3mC5Uu5iVr0xftrmGY6UrP5cYWm6fAa8DpKelSz+gvNOe5jq9LhKykZhZBJNIuhtf0xoBkZqMvT4wEIWlgAa21gA8bO/lTKJ8K7TQPKadCQqnKntZuSWCzys1DHBvMnfQkcNGMsqRTeyC2GxIAs0CpqP/XJQ/SJLm4cyD+FoO+yXCXIcqU0CTb5ezvKw0flH6sD6NoLSMOpzp1xM+2ePq3Ux+JOtLUQHnpHzY3+pEljJdrToRQSBtiiezSkaSe7hxE9fvTCebw4YP4J/hH8poUhs9NaRhGhRcWAlPg9BDltnYdqSHc3ZdYxwCjFINh6odbxhUnnaC4Sc5B28j5hq+Ts26TJk1ZIAj7+f8RFC2M1XMAKXAQruec/iz+fwLE9/ARHgW0GFltkZ/t7qieAzdWNb7uAr3ASlMUcG5Ylo7uF4L/5hFvqjRZeQOaZXAtyFwTgN1VJ/rlnbqxZ4xLC9VQE7iWa8q5HY/snfOeidv5DR8c/TrjUMgikO3QYlizyITrkx7r0PiVeHejiC96g0l0tiYXPoNVxwJAvoiTtAgHb2woqAJyNkG20KDGADaBkI5cCFKOqVBvgL87N0IT1tnKP4ySS+TonJtC4IzLSFLL5ePUys3eXCe6i1oq39zJd9pO+MSp6ZpCQ4HYvUGqXiO4OJGcWe7nMtEafnZBJKWSE5CW+Twxapk1kYty3V38fHPXrBV8ApLHVPGmK+zNDQWOHKb9HpXQD/oWxrdiGGUEH1iPMYDt6h+PJjlWAbexXIoMVk+a5EWYpGV6zokawnI
 jd7D23/F
 lVVAkEiwhz6YvHRrCM0lW/UoAnyYphzShRoliTdFJOcPc9gySxm76G8GlE7AxnvKMUQhYvIvLorcwWzaVJ4J5VwQNuVVfsmDKIyEQWmtJy9ZB5epc7JeILffYZ9hyZ/K6BEatiZDsWLMe9n+qUbtVrI22Tzpd0s7O818TAXAvFhDeczAD8mAbsfg0voLvWaLHFWNPiK3c4SNQSgCwFaRkkxNrtirk0nnqBpYPTXCGMWU8Dk1ru4ahmOFKAFk2GvTP8WDW+lz5OZyqb8DWwi8cpZI4FbafQcSZnGeLJiDQS6b5JQMf+TRPbN/syOQxK31nEiYJykJKuBr56tw3rax2F3QJaAeyJ1REkcELxeYRxobh8bar42by+BAhAf/dz4OekaM5OOHVSOfnJCcys15Cf1H+6wxqI05ot0SFAy8IMpO329OyCXTskqwrESycpGVC3B8Py2sDiXXPkKImEo497bpIZy+hASJJ6yarU6UM9k4WcXqzxA6esldxyjjhojDYa/ngbPMVS5ZFShW/ai6U9OTNLJXyGuszOsJWZKQ+scMENzIcv7bHHeJ+MjnlFrgXIcSyvUlWCva9Cz+1vDtTVtk6GqagElu0hF8tjwXmtZzySqmFsvbUYUpBWlKRIgphNtpDUlHOh8vnisTu2FjgxVIoc5csIfhcv853H7HeplHTsw77f1bpKFNG9iRoL6YPQpz1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025, Ackerley Tng wrote:
> Fuad Tabba <tabba@google.com> writes:
> >  int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *=
fault,
> > @@ -3362,8 +3371,9 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm, st=
ruct kvm_page_fault *fault,
> >  	if (max_level =3D=3D PG_LEVEL_4K)
> >  		return PG_LEVEL_4K;
> > =20
> > -	if (is_private)
> > -		host_level =3D kvm_max_private_mapping_level(kvm, fault, slot, gfn);
> > +	if (is_private || kvm_memslot_is_gmem_only(slot))
> > +		host_level =3D kvm_gmem_max_mapping_level(kvm, fault, slot, gfn,
> > +							is_private);
> >  	else
> >  		host_level =3D host_pfn_mapping_level(kvm, gfn, slot);
>=20
> No change required now, would like to point out that in this change
> there's a bit of an assumption if kvm_memslot_is_gmem_only(), even for
> shared pages, guest_memfd will be the only source of truth.

It's not an assumption, it's a hard requirement.

> This holds now because shared pages are always split to 4K, but if
> shared pages become larger, might mapping in the host actually turn out
> to be smaller?

Yes, the host userspace mappens could be smaller, and supporting that scena=
rio is
very explicitly one of the design goals of guest_memfd.  From commit a7800a=
a80ea4
("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memory=
"):

 : A guest-first memory subsystem allows for optimizations and enhancements
 : that are kludgy or outright infeasible to implement/support in a generic
 : memory subsystem.  With guest_memfd, guest protections and mapping sizes
 : are fully decoupled from host userspace mappings.   E.g. KVM currently
 : doesn't support mapping memory as writable in the guest without it also
 : being writable in host userspace, as KVM's ABI uses VMA protections to
 : define the allow guest protection.  Userspace can fudge this by
 : establishing two mappings, a writable mapping for the guest and readable
 : one for itself, but that=E2=80=99s suboptimal on multiple fronts.
 :=20
 : Similarly, KVM currently requires the guest mapping size to be a strict
 : subset of the host userspace mapping size, e.g. KVM doesn=E2=80=99t supp=
ort
 : creating a 1GiB guest mapping unless userspace also has a 1GiB guest
 : mapping.  Decoupling the mappings sizes would allow userspace to precise=
ly
 : map only what is needed without impacting guest performance, e.g. to
 : harden against unintentional accesses to guest memory.

