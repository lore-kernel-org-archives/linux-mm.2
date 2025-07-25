Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 745B2C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 19:52:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2CF46B007B; Fri, 25 Jul 2025 15:52:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B04C76B0089; Fri, 25 Jul 2025 15:52:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A41926B008A; Fri, 25 Jul 2025 15:52:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9597E6B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:52:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0EBEB5BB37
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 19:52:49 +0000 (UTC)
X-FDA: 83703834858.15.26B5406
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4B303C000A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 19:52:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Khv1Ob8D;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3jeCDaAYKCKgaMIVRKOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--seanjc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3jeCDaAYKCKgaMIVRKOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753473167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QGGwHKzNdqzja55fvEizh1HPckulPqbm51MIc4WTZ8o=;
	b=ySr+8wX7y6N3qazddZVn+i3f8UUw72MJ+1igxAMWhq8FVcwi8hZsE9/MxVNpoMWZ85zuCz
	AYjBd6tDpf7hVHT2CINdcQEA8KkEMkijZtEIZZFRV8U15k0oGy6BvWqkGhycKj7KuT5cYy
	ZOVO58PNnCLPSuVtL9z62ScRZIU/ynw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753473167; a=rsa-sha256;
	cv=none;
	b=Zd9xWxyGb7CBZj26E2XnOHmjokALZEnKrj/R/SDAnauFlTajRnoFANw2t6NtNauLcgqzjd
	VfEnLw9qMZvn74Rp8t6CRMFEwum4P6g9gI+PanjViw0YJNIjD2J/JY54wY+cy8dhSlonqr
	x/y+/qs1NtN0JfI42sMRZ77/B3l7aV8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Khv1Ob8D;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3jeCDaAYKCKgaMIVRKOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--seanjc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3jeCDaAYKCKgaMIVRKOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-235e1d70d67so24186235ad.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 12:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753473166; x=1754077966; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QGGwHKzNdqzja55fvEizh1HPckulPqbm51MIc4WTZ8o=;
        b=Khv1Ob8DORu7SONVtl4Nb0QgyPb1qS6xhKiSG+3WgFL2vE2hAkTz7fBp4nJ+bznFRr
         rzz7JNzcPdbMq/OUylMpGIRn5CW4G3tfeC3X9xLQGOidIYsceYTi9Iw1ZboYMLebO0/O
         n3NgUbRxLznJdvvzL6InJXHD6wf51+iVLqGM4+uZMIPiQSB68fzUSQ8GScpIL6CxP0gD
         IBYN4vn0KM38mTEe8cdM/Wa5rSfqvg6qeJj2LRTwMbnSJi+OI55k/VXWa44l3lq42mzd
         qHAOS97Z+v5ffU/7z3uLrDMWlGjYUSei1LBNHQHX5/eRmpDepZM79twreJfIraVjb20p
         Ssyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753473166; x=1754077966;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QGGwHKzNdqzja55fvEizh1HPckulPqbm51MIc4WTZ8o=;
        b=Qr9sZYdsGC5LmzcmmUxXRFrqTH5hnuRxpqM839uIbFHAEp2d6zP7pKUSwX3VS+j1Sy
         C6tjpPBfAz83jVyEKciGOc64lmSUz+NSOzgQ67v7Ed4EBhDNHeII3JoRDOm1FMd+PPAH
         A3JHYSTzGlpodpkI3odkLEptvtfbhXrDU7U7J8Zi2NC/VGi0eiUAAqI8LeTtGA+RyEqD
         cqMOUuLPa9lNh5mH+MqfpaIVrEDpFVvhGU+nGyGCvW3AXruNkdqjQMYoQNTNKFV8z27Q
         m4Qalf5pCWoLUi7e0recV/4VI6JfxLh7bmIq7w2XXYSLCxVlvkV0rDaXrqZQ8E1kL4Wt
         2yYw==
X-Forwarded-Encrypted: i=1; AJvYcCWi6dtcraUZNBLACtrUwO6h6NJzZ5j3tDKKHXpYh8eirLM3R+xcaqjzJf8alvc7VwR+tz6Fz6gBiw==@kvack.org
X-Gm-Message-State: AOJu0Yw71SyNbblhaEz/qvQcTRFA8VibWuj4BODL9JohSHPlZ7di9hHJ
	E3keGHiGVcq9geUF08t0V/+VB/0YnaBn3afOTANndIcS44xgRGaVy0jYHbedhihg1h3rwdhOryX
	B5rJdsg==
X-Google-Smtp-Source: AGHT+IGKfp2ZEdZFD4nXV8opXXNSrJNr2MwInumKeRrkZ/nbSrnkah7OjJY3KrZp8KeOnG/KWd4mQPv9Jxk=
X-Received: from pjbqd15.prod.google.com ([2002:a17:90b:3ccf:b0:314:d44:4108])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d414:b0:23f:b4c4:710c
 with SMTP id d9443c01a7336-23fb4c4730amr32702405ad.38.1753473165998; Fri, 25
 Jul 2025 12:52:45 -0700 (PDT)
Date: Fri, 25 Jul 2025 12:52:44 -0700
In-Reply-To: <diqzseikcbef.fsf@ackerleytng-ctop.c.googlers.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-16-tabba@google.com>
 <diqza54tdv3p.fsf@ackerleytng-ctop.c.googlers.com> <aIOMPpTWKWoM_O5J@google.com>
 <diqzy0sccjfz.fsf@ackerleytng-ctop.c.googlers.com> <aIO7PRBzpFqk8D13@google.com>
 <diqzseikcbef.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <aIPgjOLq8erW06gK@google.com>
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
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 4B303C000A
X-Stat-Signature: s4oy4xitkn99sycun5uhik1jkkufmwou
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753473167-676809
X-HE-Meta: U2FsdGVkX19N8rYdfHMK0sY/FRvzte8nnUUzAkzj6v5RjaVbjc4/igCG6Z50adqi5Lk1MiJv2ZoE4D0F9+0+Ug3k2tiLGDqG1HLC0P1+nfcJKcNZ59OYGJDzyiQo89tTcMhoKNHT0PxGCaYZ6cWWXma/CS94RHGgzCHWBBYkd9i00HjMLxFwVFt/etgMzjmPFhDO61oeg7qLI3kXzq9rxz8CIRZdnrW/E0xLYgB3SqEB0RG0H8ErYISZTh8oY6kL5qjhj15D0mtxdgCW/EmcaLvkzkBfH3AqXfTDCIrKsedzXcEUJ7/dSSZyfYA+yYdmHv6xwr6ivwh/MtAeNyXEhO0gZZOZCb5d1upkYHq+PouKk/HqzuXv4wnXVaIKBO8L2VGxrgFTYA2HdHsIj1uG9sDPn6znXCzvKA5PChnaRvhQEjQncHywTgEtUlHSzeVYunFSU9dZ06RbCG/xove1BKEJbHum5MAStsof12SGMJN0TGGSaqAwA+bneXra9onvdJApLR57CI7uXrgT83noAHDMKlkgO28/ag4uuqgnYFl4CJA0bs4XGvaAO3g/0xiaO8yB6h2RIIcEE7qniPMuLd2eGWvDoP/sSJE/yBtiMilt5+EkWipr5ikg/8sj4Px6jeHR207IyzG2xCFKYJAOpPEeHUJ5PWT4iEVWpWUDSXLal/MbWtmKfJKuDPXTlUTzRlt9eGHdoWsQQxrOZgSHkuUk/3I9qb/ZKmHm6QSgg5o+LetnbDzCAKGVBO1eAZ7t7PRBpdmBL93mcmrQrpCrKf6qapBV7BrXvERvtpsUlO0ikcyYfhDHgCOmEKs6YQ2aUskpm58H9xyE/Rc8jN+kQF8HYXub4Xbx0RC4JvnnC77hPOLFhjYxAqkiXqcqnWM8N1bbjGm7vMQBiyzoQXNKK24Gt9Hl6SZ9Ds1yHinjfKyPJ86yi8+OF5GRBcdONKpT4WqoN0jUNU8UaPUmi8P
 uZ1KbHqs
 CkeaUTjZvL/tyxCjRZ6wqdJ9SEdN+EkFf+v7zRm2dWKRP5komb4jr5A0DjRxcEIyQ0MQy8iOyxSxHQf+dYFPyLnUPi2pKmuQ6N27k8KoeIpIliEnToNWzpp080X2i7lJ1QM839uWhT79gx7/U/WLTOzn0x8Ryp981/EOJIHhYMkRmhliW8kwpw0l5K1Zg7qJCTNIf3UOTTrxHozZxxrb+OPDlX9mUJYo4yNr1+rXBwZaidCoZMCCIbH40A0FEsdVUjsLBb2MoXYehCoZ3YIvmk+99WVlFK8NB7sNL7//18UyvP1Y7sFim2+4Kl0/eAKAhO0cqCz3G3wtG0CV6KRj8bT3HBCFkzXPDoIDmbMU23kUnDyPzpxqLL4BgxhDk0o28Crg3DmVoVbrVSy95bVAVENJMTxa4x4w6eWmwhlOMHguRGGbO3EIPwOK1rQcGRWE1Bsq4KJSweJTciw08/Nyuc4av+oQLMkwdthHb3uh6RLpueoiAS894llq6iIfC5oEGSw5o0yYfc70rnEAjWg3ZCQBi0YB+ATqh48Sm6WbAMvuDztcNREJK0osImRNlcotYVPM2xg69eCgIfz51hJ2ROGW8MLQ/+qL2Q2Kv9fdH96F4uQjWZ+ut3XpixAY+K2Ezg2vHVgGXxMYeXydKiLNHin3qBZHMkRn7/wdJxAo/NbAkhFqhsBqFRCjEXy9uUc9oQ2Ig
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > Invoking host_pfn_mapping_level() isn't just undesirable, it's flat out wrong, as
> > KVM will not verify slot->userspace_addr actually points at the (same) guest_memfd
> > instance.
> >
> 
> This is true too, that invoking host_pfn_mapping_level() could return
> totally wrong information if slot->userspace_addr points somewhere else
> completely.
> 
> What if slot->userspace_addr is set up to match the fd+offset in the
> same guest_memfd, and kvm_gmem_max_mapping_level() returns 2M but it's
> actually mapped into the host at 4K?
> 
> A little out of my depth here, but would mappings being recovered to the
> 2M level be a problem?

No, because again, by design, the host userspace mapping has _zero_ influence on
the guest mapping.

> For enforcement of shared/private-ness of memory, recovering the
> mappings to the 2M level is okay since if some part had been private,
> guest_memfd wouldn't have returned 2M.
> 
> As for alignment, if guest_memfd could return 2M to
> kvm_gmem_max_mapping_level(), then userspace_addr would have been 2M
> aligned, which would correctly permit mapping recovery to 2M, so that
> sounds like it works too.
> 
> Maybe the right solution here is that since slot->userspace_addr need
> not point at the same guest_memfd+offset configured in the memslot, when
> guest_memfd responds to kvm_gmem_max_mapping_level(), it should check if
> the requested GFN is mapped in host userspace, and if so, return the
> smaller of the two mapping levels.

NAK.

I don't understand what problem you're trying to solve, at all.  Setting aside
guest_memfd for the moment, GFN=>HVA mappings are 100% userspace controlled, via
memslots.  If userspace is accessing guest memory, it is userspace's responsibility
to ensure it's accessing the _right_ guest memory.

That doesn't change in any way for guest_memfd.  It is still userspace's
responsibility to ensure any accesses to guest memory through an HVA access the
correct GFN.

But for guest_memfd guest mappings, the HVA is irrelevant, period.  The only reason
we aren't going to kill off slot->userspace_addr entirely is so that _KVM_ accesses
to guest memory Just Work, without any meaningful changes to (a well-behaved)
userspace.

For CoCo VMs (including pKVM), guest_memfd needs to ensure it doesn't create a
hugepage that contains mixed memory, e.g. must not create a 2MiB userspace mapping
if the 2MiB range contains private memory.  But that is simply a sub-case of the
generate requirement that untrusted entities don't have access to private memory,
and that KVM doesn't induce memory corruption due to mapping memory as both shared
and private. 

