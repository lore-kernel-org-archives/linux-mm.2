Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78BCED46BED
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 01:03:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0D716B0088; Wed, 28 Jan 2026 20:03:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE51E6B0089; Wed, 28 Jan 2026 20:03:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0E636B008A; Wed, 28 Jan 2026 20:03:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9FFCD6B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 20:03:32 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5BD11160863
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 01:03:32 +0000 (UTC)
X-FDA: 84383203464.28.115BDFC
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9DEB040005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 01:03:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nEfkhfJL;
	spf=pass (imf07.hostedemail.com: domain of 34bF6aQYKCIIykgtpimuumrk.iusrot03-ssq1giq.uxm@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=34bF6aQYKCIIykgtpimuumrk.iusrot03-ssq1giq.uxm@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769648610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=19yGyDu7FA79ZAJBhihksbqQH2oSVrmD3QatKOHHT0Q=;
	b=d8l674spjlFvoEhSXIdPYCiLJckSx7oD+RQ3lw1SBOLAwFCHPLMJ7MquBBE/qgeKFc3+Vz
	7HVr5u41loND6z3t407ii4r5rHhTtEDEUhXt0s1ZH42UNtdRL5uhzQuaMjufwaEPRs8rkF
	AyTQ01Kr9l2vtQ7EO5cEWh3E+SRgwos=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nEfkhfJL;
	spf=pass (imf07.hostedemail.com: domain of 34bF6aQYKCIIykgtpimuumrk.iusrot03-ssq1giq.uxm@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=34bF6aQYKCIIykgtpimuumrk.iusrot03-ssq1giq.uxm@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769648610; a=rsa-sha256;
	cv=none;
	b=pBt5ebY7P/oiA9FYe7uoef+aBE/r9s0aTHSiMM1EDDGEvzMn4VRsgqx3W8pIH9JS0v3SRy
	wsAgqZDqnxf5dcv4lOjvMr/KA6yXIHODb54qPo3biMKDnPqu3IsHt5FvAvYPnhH1GUUKlw
	QY4nLtqzSsQZEh8wVL2LQCGSR0x9ZmY=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a0b7eb0a56so3224955ad.1
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 17:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769648609; x=1770253409; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=19yGyDu7FA79ZAJBhihksbqQH2oSVrmD3QatKOHHT0Q=;
        b=nEfkhfJLs1OJZgbd+8I7VbXZniaTcVmiOUP64INiKRY71FlrpzObKyKyYZ17FiB/vr
         vZsj6Aq1ri+y8Nt+V8BlNVpwnUfm1MyTcpM4okHuJsoR6AtZGk4IU4XE+6zJl39kNILU
         /pqpGVNc4Mta/+y426aR2ko8rZwUCR0evIfg9d/ISx1E8SoZ5VZNPCSUA2YQ9+/ENzdU
         2HNBVJTGG0Drpbnp1llm9dO1gvgIFw2koigL8FNTk0umv3sL+7aw+VBiMo/ai06/8FMi
         iE8Vx5NK5Ut1xlUE4flQ0KNtXs8t0hDZWviB2o4z4QZwE1PI5scMQVau/znryRpHVFFT
         jSaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769648609; x=1770253409;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=19yGyDu7FA79ZAJBhihksbqQH2oSVrmD3QatKOHHT0Q=;
        b=LtT0TbC5mQQINhLS/6jCBeCbZSTzu1t3q0SbaTQHsyj9Jet8qX1LbnUt8/+8Clmec4
         vsxdgwyUuTVASnbyfKZZJZzuSnGAip2OEu8iM91kJDSitr1dfZoDrqWIiGppZmQs6xSj
         e5GIyQdIM2XohVRiPHa+kZdwfaV6TO4m74Nwbo/oYnRa9KeUl1UUzlmosFhutHSu84Xe
         tUKryxGnUgZkbV8qgqurG21a0u7/q1hb0CD+2xe5imOlh2Esc9KR0Xa6gWK2HzMLt9RM
         R+oGejOlYGhzD/7l8XUupWWePDB5v919WjYBK7wJG48upRER4KmpBlxcVthk+zXaMWH4
         ZqgA==
X-Forwarded-Encrypted: i=1; AJvYcCXMjktw1YvXqHV0bYNrSjGgczhwU1WhpvZ4ONHjUn8faQ7fH4aOcZz1kfn0KfAO9a3NMwHEbTkv4Q==@kvack.org
X-Gm-Message-State: AOJu0YwAk5iqOJZydcBIAYjVd1dsEPpk8Pbh8urCY5YaASu95d8IoABJ
	xoABrDjLJbkgZLvqbL/FaeVjXeQ9P2NR19bczkWT7yty0s+njm2jN7KmnFnQFLNSyn+/mSsScDY
	b5p4q1g==
X-Received: from plbky6.prod.google.com ([2002:a17:902:f986:b0:2a0:84dc:a82f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d4cf:b0:2a7:dd37:6e20
 with SMTP id d9443c01a7336-2a870e34d04mr70308785ad.30.1769648609015; Wed, 28
 Jan 2026 17:03:29 -0800 (PST)
Date: Wed, 28 Jan 2026 17:03:27 -0800
In-Reply-To: <20260129003753.GZ1641016@ziepe.ca>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com> <071a3c6603809186e914fe5fed939edee4e11988.1760731772.git.ackerleytng@google.com>
 <07836b1d-d0d8-40f2-8f7b-7805beca31d0@amd.com> <CAEvNRgEuez=JbArRf2SApLAL0usv5-Q6q=nBPOFMHrHGaKAtMw@mail.gmail.com>
 <20260129003753.GZ1641016@ziepe.ca>
Message-ID: <aXqx3_eE0rNh6nP0@google.com>
Subject: Re: [RFC PATCH v1 05/37] KVM: guest_memfd: Wire up
 kvm_get_memory_attributes() to per-gmem attributes
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Ackerley Tng <ackerleytng@google.com>, Alexey Kardashevskiy <aik@amd.com>, cgroups@vger.kernel.org, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, x86@kernel.org, 
	akpm@linux-foundation.org, binbin.wu@linux.intel.com, bp@alien8.de, 
	brauner@kernel.org, chao.p.peng@intel.com, chenhuacai@kernel.org, 
	corbet@lwn.net, dave.hansen@intel.com, dave.hansen@linux.intel.com, 
	david@redhat.com, dmatlack@google.com, erdemaktas@google.com, 
	fan.du@intel.com, fvdl@google.com, haibo1.xu@intel.com, hannes@cmpxchg.org, 
	hch@infradead.org, hpa@zytor.com, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgowans@amazon.com, jhubbard@nvidia.com, jroedel@suse.de, 
	jthoughton@google.com, jun.miao@intel.com, kai.huang@intel.com, 
	keirf@google.com, kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, 
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Stat-Signature: 3k3qkrk3jb56xhcecg1zb7eehueekskk
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9DEB040005
X-HE-Tag: 1769648610-343438
X-HE-Meta: U2FsdGVkX19IpsAPpSZvNYgkWzblbA3Xua8c9wiNGiPUw4kjrqd0zNihqGTbZ+gPxGHJvQl5coQ9g54YUzbOvnyCVl83mvSMIlKq9W9Xr2txoLIwrs980o4XOlAjAcNVJuCWkigGgx+ZyU3GZebgRPCb1RosC/DcdoYWUByshlIrVqE0miCISjy6DpYyByMw3qI9TYudMdT9+9dpW0uUb8wj+yxSnoU9yUD/dJb0yep+9GZdpbQQ+heaf61X9TJ4OBSBpaJVijwF3gbswS7u/maoonfTrm2gV1EBKuluIkYDMHCvKxqMJp/eSKico7tu9lAWwVGFzJ2OwOIY3j9fmDhdENJvmcZ/LlgDheGk4vDa5Fkgp9gI4wonxpzeMcUZKnve7o6NzwufVcw7EANIgCudOK4BGoxwkOjzhLP0yZo7MsQnQNyFJCtyxtQxzDbxcrTVVwnigoOS1fLbT+tg00QPyVOLxm/DPOfZzM3LxdpSTadVtHcH1mw0ODmmFppWP1veuOSOxWkg+K4ksOJN7iLVnMulOAUa80YEkSymrvXcl/D+MR3hi6FSXqegn2l4k5gJ0f4CFCnhxFTMIiAWhQZlOH1e5hQpz+tF4W8CtVpsceFKZuUVd+4NQXILm/mK+43e3zt/faqDjTzU+KThDkYNxrAhhPwuIflxneK4tzgrEviVkoTrTRo9fxtMdtG64zL9V+kl0LWVyyLAyk4jxeBmv4NFyr/WF+D7gyq4Xxa77clySYWY1ozqie26GZrAXqYPZHg+QyYdjphhxlhNwQ15y5QoTgrm/N/frCLIy9tqPbnjsTaP5n62FXtjDOHwFA2elu8PcX85iT4aWWpCfph5qX+bt6mpETOT7+Lj7oXFs+6zcbiTf7UM9UcbWRW6PwdNg/8puBUKNYeRUn9HF1greIDJXWe1r1VXoaDHelc6VjBP0Wn6gA9iIgl7M89Dg41cxrFWdcshy51IHWL
 RNmwXwSb
 cRAvDPgbdQOUAfSCjUsHPFkg98sc59TbTTlWSUgWFqWJDka7mV7OqN5Ko8pZPb1+X7ExPHiS3I32qFHLsIyS8hFf3QPfc/v+BmXrUHzWX9FaAIDxK0yHi5dpcYZd0VYfF1FdZSLC7YRqVtElsBXwi8ASt2JBXktog+JXi6fiHRVNToFMrvT+p11fY+bfw66Fkp42lMExi5r9Xpqc8/sQOC4GMuH+H7rNKqF8w1MWvkVkseLxqt3V4Gfohuh4IIPDqmUlob8BQrODbLYUcTTM5CtR88W4n33O/++0DmiP0yhSYPoqM6kacgngTKJvAhJx1T+a2gyhY3SUglh4CIRx4WZxBEEKh1XPQOkTgwyMxxOv1JTHst4KN9qMvmyJeh/BnJawrvgnh8+zd+gxCuqeC7Rx8sdo0oblQ3BB5IUqZItsLXTDUUmdd5usZyWvrAbbaZitncnyFaejztpdvFCCkwT1PxqQnPPtCJVOCx/cMVsKW92uzTPx+mdI+mIrXp3xL+7rc75rp4GmBdk2jAU0OP6iN8ptkOG4Q5RJlFAVcBMLAphJ0VSJOOaWXoagxg05HhlgYw89ROpbwmM/kNBpHgUSEjtPul4kj1zLsLvTWknHfH0Hg72OoOHpQ5Sy2lh64RTAz6vMY99+dFXwby8nti4U9jtbCH+sMDwM2qdyjuLf9fXesS/d0t6UmATU1+N2VkwwYZT7ixCwTRO/c52nppxjDJvXMlrDRkkrF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026, Jason Gunthorpe wrote:
> On Wed, Jan 28, 2026 at 01:47:50PM -0800, Ackerley Tng wrote:
> > Alexey Kardashevskiy <aik@amd.com> writes:
> > 
> > >
> > > [...snip...]
> > >
> > >
> > 
> > Thanks for bringing this up!
> > 
> > > I am trying to make it work with TEE-IO where fd of VFIO MMIO is a dmabuf
> > > fd while the rest (guest RAM) is gmemfd. The above suggests that if there
> > > is gmemfd - then the memory attributes are handled by gmemfd which is...
> > > expected?
> > >
> > 
> > I think this is not expected.
> > 
> > IIUC MMIO guest physical addresses don't have an associated memslot, but
> > if you managed to get to that line in kvm_gmem_get_memory_attributes(),
> > then there is an associated memslot (slot != NULL)?
> 
> I think they should have a memslot, shouldn't they? I imagine creating
> a memslot from a FD and the FD can be memfd, guestmemfd, dmabuf, etc,
> etc ?

Yeah, there are two flavors of MMIO for KVM guests.  Emulated MMIO, which is
what Ackerley is thinking of, and "host" MMIO (for lack of a better term), which
is what I assume "fd of VFIO MMIO" is referring to.

Emulated MMIO does NOT have memslots[*].  There are some wrinkles and technical
exceptions, e.g. read-only memslots for emulating option ROMs, but by and large,
lack of a memslot means Emulated MMIO.

Host MMIO isn't something KVM really cares about, in the sense that, for the most
part, it's "just another memslot".  KVM x86 does need to identify host MMIO for
vendor specific reasons, e.g. to ensure UC memory stays UC when using EPT (MTRRs
are ignored), to create shared mappings when SME is enabled, and to mitigate the
lovely MMIO Stale Data vulnerability.

But those Host MMIO edge cases are almost entirely contained to make_spte() (see
the kvm_is_mmio_pfn() calls).  And so the vast, vast majority of "MMIO" code in
KVM is dealing with Emulated MMIO, and when most people talk about MMIO in KVM,
they're also talking about Emulated MMIO.

> > Either way, guest_memfd shouldn't store attributes for guest physical
> > addresses that don't belong to some guest_memfd memslot.
> > 
> > I think we need a broader discussion for this on where to store memory
> > attributes for MMIO addresses.
> > 
> > I think we should at least have line of sight to storing memory
> > attributes for MMIO addresses, in case we want to design something else,
> > since we're putting vm_memory_attributes on a deprecation path with this
> > series.
> 
> I don't know where you want to store them in KVM long term, but they
> need to come from the dmabuf itself (probably via a struct
> p2pdma_provider) and currently it is OK to assume all DMABUFs are
> uncachable MMIO that is safe for the VM to convert into "write
> combining" (eg Normal-NC on ARM)

+1.  For guest_memfd, we initially defined per-VM memory attributes to track
private vs. shared.  But as Ackerley noted, we are in the process of deprecating
that support, e.g. by making it incompatible with various guest_memfd features,
in favor of having each guest_memfd instance track the state of a given page.

The original guest_memfd design was that it would _only_ hold private pages, and
so tracking private vs. shared in guest_memfd didn't make any sense.  As we've
pivoted to in-place conversion, tracking private vs. shared in the guest_memfd
has basically become mandatory.  We could maaaaaybe make it work with per-VM
attributes, but it would be insanely complex.

For a dmabuf fd, the story is the same as guest_memfd.  Unless private vs. shared
is all or nothing, and can never change, then the only entity that can track that
info is the owner of the dmabuf.  And even if the private vs. shared attributes
are constant, tracking it external to KVM makes sense, because then the provider
can simply hardcode %true/%false.

As for _how_ to do that, no matter where the attributes are stored, we're going
to have to teach KVM to play nice with a non-guest_memfd provider of private
memory.

