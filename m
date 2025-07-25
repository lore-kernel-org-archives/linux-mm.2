Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8357AC87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 22:01:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D31D56B007B; Fri, 25 Jul 2025 18:01:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE2146B0089; Fri, 25 Jul 2025 18:01:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF84A6B008A; Fri, 25 Jul 2025 18:01:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B01056B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:01:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6128D160954
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 22:01:18 +0000 (UTC)
X-FDA: 83704158636.16.98E9854
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf24.hostedemail.com (Postfix) with ESMTP id 74CE7180011
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 22:01:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mbjInftA;
	spf=pass (imf24.hostedemail.com: domain of 3q_6DaAYKCAQwierngksskpi.gsqpmry1-qqozego.svk@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3q_6DaAYKCAQwierngksskpi.gsqpmry1-qqozego.svk@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753480876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+zp+aFgZ7sosVHgE1JVBc/YF4k2nO+/CVzJ2Y2OlSXk=;
	b=Nr/l0zoxQxSWvDS6luAmFywg/SzmlW07zIz/rUndBi4Alh8nKi+eX39cxCzI4BZJ7aPYpu
	tU/5tP9wPNkwbNFrsfzwvXMR6iVnUk7uBqGQCdjSnuJ8FNZSturGmZhqPX+66fH4s2MXLA
	ZQwTMBthq67coSdBGxw1ODmeeSKpFw0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753480876; a=rsa-sha256;
	cv=none;
	b=UlXx0TpASObWcyrW3hwiXfRqC4nqi65AXjkIL1zHKoKBpltRh4eXP4W2YWukVs/JIR9RvY
	86fQRwjZ4oxZhMLJOi308sETQ73bftPo+QvgM8q//543I160Tmv3Lhse49WpIFtqZC2mCI
	GEIDZGN4O56rtU0ms/xuB/cwwg1a2HE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mbjInftA;
	spf=pass (imf24.hostedemail.com: domain of 3q_6DaAYKCAQwierngksskpi.gsqpmry1-qqozego.svk@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3q_6DaAYKCAQwierngksskpi.gsqpmry1-qqozego.svk@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-313ff01d2a6so2692603a91.3
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753480875; x=1754085675; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+zp+aFgZ7sosVHgE1JVBc/YF4k2nO+/CVzJ2Y2OlSXk=;
        b=mbjInftAwf6bz+bdYfs+fgQXEf1z3q6np41lKIeyHMiuD5gk5PEwUyDMIl8EMeBZtT
         uBQChSLT2hQc5XOOiWue4DI2jvWb7LUtVHVKE6wlRZJdLK0PTkVrP/2jPBjogtZkzYMs
         Zd5+001W3Q/DtRWl+/T3zoyQAwulD+Q5K4VBtRjyYwS0JXDHndh9mX1l7RtHm89jlVt5
         r9vux6O/yUQCaPVDqeCI9nhfVVgzo6B86sG8nOAjTsnhfVS1TjU7cIVxXAEL5fUkt6pC
         K5KW5RgnxHW3GES7KI4MGytLDTsn6jDBqo1u8W7kw5sbTmCYjalAAF18YPNjkxrVU3zX
         1NEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753480875; x=1754085675;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+zp+aFgZ7sosVHgE1JVBc/YF4k2nO+/CVzJ2Y2OlSXk=;
        b=ZvHZFc1PKdurWaN3N34oBKQZlEKaf/VJjdlxcwf8oQckSeZMo+vVqxCa/7LQHpCo+L
         aukrSGH/TVN5Mo2smSgS987kivbGeg/NWaeZVI6rDvr6WpWVccBAggbiCSRx3US1Q7P+
         MR6x6kL3i2fTBy7KIEhfFpRUJxLmhEsbvobSii69f08RJyd3hGhVPlGFUlVcLia1J+5r
         mp6hjLBkKnTM++/Oy4huV33Cbl1XSnqn1t7508AXl2XO+VsB+kUGG9UNDyLNJZIpXTym
         jRg+ZItDcKFXS/UfW/ZmbW69a/tMn7VqcnuNsp5VQTgEsDg83HlPWnIrW4/LhcDEryPJ
         Baxw==
X-Forwarded-Encrypted: i=1; AJvYcCXA90YC5ODftPkziCQV2ZwkwWbBIni9k8MoQn5ldCj6PRGNXOKM7zvpsW0HMTx4gT2vI9J7wppzjw==@kvack.org
X-Gm-Message-State: AOJu0YwtD7Crn/s0Eetb1ti2YBW8oCIb62kM6gYyuJlL/VqjiJA3brSS
	PjnA+whryWN5GgYslygwJcoBNs6sBaU1tLd1S23lGaUyEAtpVo/HltlXjHC/jy9/+zJFrOjCD/e
	zhXw5eQ==
X-Google-Smtp-Source: AGHT+IFPjkF2xrZ/Gp6FwQl6jvIg14serRXFzYz5L/ExU8zpV9XgePnP6vcF1X9qmhlTmOaX+wV3Tt+ZntY=
X-Received: from pjvf3.prod.google.com ([2002:a17:90a:da83:b0:312:ea08:fa64])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e7c7:b0:31c:15d9:8aa
 with SMTP id 98e67ed59e1d1-31e77a45647mr3874947a91.34.1753480875031; Fri, 25
 Jul 2025 15:01:15 -0700 (PDT)
Date: Fri, 25 Jul 2025 15:01:13 -0700
In-Reply-To: <diqzpldoc5yq.fsf@ackerleytng-ctop.c.googlers.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-16-tabba@google.com>
 <diqza54tdv3p.fsf@ackerleytng-ctop.c.googlers.com> <aIOMPpTWKWoM_O5J@google.com>
 <diqzy0sccjfz.fsf@ackerleytng-ctop.c.googlers.com> <aIO7PRBzpFqk8D13@google.com>
 <diqzseikcbef.fsf@ackerleytng-ctop.c.googlers.com> <aIPgjOLq8erW06gK@google.com>
 <diqzpldoc5yq.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <aIP-qSnH1jjuykmP@google.com>
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
X-Rspamd-Queue-Id: 74CE7180011
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: u3qqdkmgr98iy6ihwjo7to9pnex46k4y
X-HE-Tag: 1753480876-38268
X-HE-Meta: U2FsdGVkX1+SU3kcsRIghM8h7g8MUMD7kSgjmwoBfVOD8BEiQOQ/9KhmXGUe9ReuxOe/G8GQS0vhuPUQzK2EVMtaLYiEg76Io/qOBrtHpHcuSR3m7oKIo8uBqyhA7vO6sP1FQhdgtYA8bnqD81fMKozcis0t/e5YFuJKeTwIdJAClBYU5dXzZY7Bon/IRo+G4p0OWW9COpYeQCreNg5VkPIcs8Eg1xGl4hPv5YdJ6IjKoweISI8BWU4ACQa575AVsysGAiF2+4XGw9/LJX8mu73jqvx7IkBVf5vTvArkfNNoLiB1lM3Tme2SFtcthvwZB0JPasMhwemtuUwEOGofRKLOSXzShyfqWaIhaOGlKUZ0+7hlG7MvsNrvO6sXMAyAv+r/l0fqL3Ffc2J70IkPT11PQllMxCYSrDqvGgKWP3dLwf3W61usFaM7ql8da3iFmcg5VE6qxU4V9bxY7EtPcKtITxLx+FPTDJwsDbrItdpuDzvaR3G0NrB7tNTKRP+9a6CD+MmV5kgfSuaLzbXzK4Mb9f8f2HerYUbag/+VD0KtlHWBF5naORtH8XwRpV1wa7q2ODrTKo4GZjWrK5kubMaFx1nd5cWszjDsWzEo5jCBhTb/WMFa13orZx+TZEde/nbqlM97Zp6whF9cfGXr0LyRzOsaId07zOXgZNzrxgBH0l1FbvaNBEpifRCBk1tRMQanvmEo5vgjquCtDbua0h7cs4UjRrND5Wjs/YWBThfWKzxRuYKcRRXTNb6kOZ6sjIcCLelQrAA26iohn5UKSQ3islAy+gw6xiBybLv2kyFLWJfONuxwjuMOcDHAZempOqMgBp3Wu/mN1ehnOO8DvKvU+dsRQiN9rwJx9P3+IC5zr39+Ulqf0he8Yozd/vo+9ZkkOCoCTzvgkAgx/A1T4UKCFGuYTNMkMiPGlC9QRUN+eDs/rqvqlgQxkH3un0wt5gI7pygTKYtsNQ3wCG5
 mStO/xur
 0XldEzIIeZ++k5tiHeLIolrdUF/vDFHdr0IYV/zHDg3OyVRDFOPMNo/HGUlxvop8J9XqcP795D8zACFyp0jW03ii3pWz24rIIhgrDgXnAEFzS6BZjCvZyz+KrkQeY/SETezyHIQEq+1Mqm6fexofCwwusDBGWQ0F1kKNugckrHxLWvX3hcLrfRluKznU10n2igkI19yBgZyMru/K9l81ChPxo9rYbq0uJuoiL2tgQETYZLXq1ITpR9CL4F7L504gwUpLM1GaimLev3RKn3bVeez8DA+9UcqXUBn7HrhiP/9hUo5iWbsRlrWadaBkw4bLZ85mI+1MI88CDK3UYvsqLllhCnwPfc5jgDhHwWDYv2WnCHt8ie1ggqZpUWj8TxqbeAiWTm3kv9rnJChr5UVxcl1cEDlJa2/Ii6xTpXw09H9sBUq9K0VPCHeqC59f8LSTzqtNKOreyDAx8+Co0q7xpyhqbU0+PKefyOT2b7NzSkXlp3Jn4p/JlI5x/X2fxivIHuw5vXcghADtHZfBpFkE39XRl9N3yvOAseitCQ44gbKeATJ2SbZKo/gwJXAOtAN9i55/ZR4FYudeWR6A1kyIVSjIExNc/UfPGKmAFuEA1xnsvhIsEC9aZlCzoC0/7P4VJ5eN4ZHyjNxMsDEMYcgIDBsQdX6KpPmSncWRYLtsDCu18s9ylqFTbEfLtmnxk8BCuibSR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Fri, Jul 25, 2025, Ackerley Tng wrote:
> >> Sean Christopherson <seanjc@google.com> writes:
> >> > Invoking host_pfn_mapping_level() isn't just undesirable, it's flat out wrong, as
> >> > KVM will not verify slot->userspace_addr actually points at the (same) guest_memfd
> >> > instance.
> >> >
> >> 
> >> This is true too, that invoking host_pfn_mapping_level() could return
> >> totally wrong information if slot->userspace_addr points somewhere else
> >> completely.
> >> 
> >> What if slot->userspace_addr is set up to match the fd+offset in the
> >> same guest_memfd, and kvm_gmem_max_mapping_level() returns 2M but it's
> >> actually mapped into the host at 4K?
> >> 
> >> A little out of my depth here, but would mappings being recovered to the
> >> 2M level be a problem?
> >
> > No, because again, by design, the host userspace mapping has _zero_ influence on
> > the guest mapping.
> 
> Not trying to solve any problem but mostly trying to understand mapping
> levels better.
> 
> Before guest_memfd, why does kvm_mmu_max_mapping_level() need to do
> host_pfn_mapping_level()?
> 
> Was it about THP folios?

And HugeTLB, and Device DAX, and probably at least one other type of backing at
this point.

Without guest_memfd, guest mappings are a strict subset of the host userspace
mappings for the associated address space (i.e. process) (ignoring that the guest
and host mappings are separate page tables).

When mapping memory into the guest, KVM manages a Secondary MMU (in mmu_notifier
parlance), where the Primary MMU is managed by mm/, and is for all intents and
purposes synonymous with the address space of the userspace VMM.

To get a pfn to insert into the Secondary MMU's PTEs (SPTE, which was originally
"shadow PTEs", but has been retrofitted to "secondary PTEs" so that it's not an
outright lie when using stage-2 page tables), the pfn *must* be faulted into and
mapped in the Primary MMU.  I.e. under no circumstance can a SPTE point at memory
that isn't mapped into the Primary MMU.

Side note, except for VM_EXEC, protections for Secondary MMU mappings must also
be a strict subset of the Primary MMU's mappings.  E.g. KVM can't create a
WRITABLE SPTE if the userspace VMA is read-only.  EXEC protections are exempt,
so that guest memory doesn't have to be mapped executable in the VMM, which would
basically make the VMM a CVE factory :-)

All of that holds true for hugepages as well, because that rule is just a special
case of the general rule that all memory must be first mapped into the Primary
MMU.  Rather than query the backing store's allowed page size, KVM x86 simply
looks at the Primary MMU's userspace page tables.  Originally, KVM _did_ query
the VMA directly for HugeTLB, but when things like DAX came along, we realized
that poking into backing stores directly was going to be a maintenance nightmare.

So instead, KVM was reworked to peek at the userspace page tables for everything,
and knock wood, that approach has Just Worked for all backing stores.

Which actually highlights the brilliance of having KVM be a Secondary MMU that's
fully subordinate to the Primary MMU.  Modulo some terrible logic with respect to
VM_PFNMAP and "struct page" that has now been fixed, literally anything that can
be mapped into the VMM can be mapped into a KVM guest, without KVM needing to
know *anything* about the underlying memory.

Jumping back to guest_memfd, the main principle of guest_memfd is that it allows
_KVM_ to be the Primary MMU (mm/ is now becoming another "primary" MMU, but I
would call KVM 1a and mm/ 1b).  Instead of the VMM's address space and page
tables being the source of truth, guest_memfd is the source of truth.  And that's
why I'm so adamant that host_pfn_mapping_level() is completely out of scope for
guest_memfd; that API _only_ makes sense when KVM is operating as a Seconary MMU.

