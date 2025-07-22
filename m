Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06F45C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 18:17:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EC736B009B; Tue, 22 Jul 2025 14:17:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69D856B009C; Tue, 22 Jul 2025 14:17:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58C626B009D; Tue, 22 Jul 2025 14:17:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4652B6B009B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:17:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BEA721329E5
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 18:17:44 +0000 (UTC)
X-FDA: 83692708848.14.0BF1FC3
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf02.hostedemail.com (Postfix) with ESMTP id CA8C880004
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 18:17:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Zt/s5i//";
	spf=pass (imf02.hostedemail.com: domain of 3xdV_aAsKCLofhpjwqj3ysllttlqj.htrqnsz2-rrp0fhp.twl@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3xdV_aAsKCLofhpjwqj3ysllttlqj.htrqnsz2-rrp0fhp.twl@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753208263; a=rsa-sha256;
	cv=none;
	b=rNCNw2J6GSeOXMBM/oyZi8xHIo2bGs5Sx/YA2RjIs0xUkzCnSh66ONm04wBhkgFlNO42ke
	afAw3PBkQTh4XjMOq2V2OV5kurJJZvPQ0mxQ0guKjZoI7CMopW/hp6+Lki+YLWKPccz5my
	7cAbjTxGFgtSVw5u69H/UwICH4otUGk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Zt/s5i//";
	spf=pass (imf02.hostedemail.com: domain of 3xdV_aAsKCLofhpjwqj3ysllttlqj.htrqnsz2-rrp0fhp.twl@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3xdV_aAsKCLofhpjwqj3ysllttlqj.htrqnsz2-rrp0fhp.twl@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753208263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0uhWfOICElzP/Lw68mkivYLCjTmw/FAHTOP1H5PpS5c=;
	b=7FZ1QF3nZhMLzDPR80cSe57rMVH1Yn2ahNXRiyOPsEp51aXpIPle+qKsNUDLXRKXziXUZk
	1nrJNFuCy+nxDsxX1u2NEyLbDDLIhH1wQotHdaPVMGvPN5xSf4nrzliLla6rt9lHKz/DW6
	F1Ta8f/UWhghQljrUSKE3OvsQUqSVbk=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-74ea5d9982cso4192155b3a.2
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753208261; x=1753813061; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0uhWfOICElzP/Lw68mkivYLCjTmw/FAHTOP1H5PpS5c=;
        b=Zt/s5i//Q5ZWMFKltaSh5cfelTULwN+4fNXe45VUfFqPsza/g6gf+HnajTyFiB/+qP
         +4svZxKgdox5agVxM3cj5EJiNW91Ij9+aSQIrflEXkBP+kUTN0eME42tBEZr+C9De8sO
         7JZg9qukfWiW0lmoc6n89Qk5F61r1T6jbmbSIwVME33WrU/vNxCJYIeFb7dWCvPNSPV9
         47QAZLIUpfCvandgyIPfSBciqlRvV4jhsGw94VxKIaQyOTiJaSBSZEk0hSp+PXOCjgwA
         pDWfHnXNSDBln7jPft9hzL3ZP9zcqshrTF+5QmtE2uDUxWeiycncph3A0yIhaV+5gAYa
         CYGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753208261; x=1753813061;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0uhWfOICElzP/Lw68mkivYLCjTmw/FAHTOP1H5PpS5c=;
        b=j5ZAN7O1vJMSF9SpqsFfso81A6DKcYppxej3pK7tg6bP8pEcLRBimYAUMaxxVMwiHL
         Jm1mdAmrwZUpC0wx9xfgnTLow85xw22hkmb2wQHiQ/pxPwGsksZ9jVUCWUOHXJklJcK/
         z0X0D73AmsGDqrhNzxMuHaWBdraGYBWVSJTeLxWKOn22sHyRB/gyu1sDsxXg9NIJ/Ig3
         ohcSo10qEkHIwFcTyQWfMV49Z4zkSXq8d/17srwTzTec/2YObeARfyFAgcREHKtLXrop
         IhftLWT1kBp2jv855UY1DiGBfPECvwnZsd8JLuldYvjVPUJhS+5Rx3YTG+4bvrrLQeEF
         E11A==
X-Forwarded-Encrypted: i=1; AJvYcCVNYzaPGLxcs8bRMfGUrGHJCBVYfPwmcJRx9qpwJA1fC+m8CQshOPAnzKtih875XRxsohAYHyzAiQ==@kvack.org
X-Gm-Message-State: AOJu0Yx0YQJex7nB5B0N/sOp+AMjakJMJli5Zqr8/Of2Ny9xj7+xRP3r
	LWNBTGqrHgDrNzHkOxSQ4Beew59p9W0RWpv6pvWszdz2jwUP6HmWnAVcMFfBAVa8JR23r5y+1u7
	JR9hX2UKsBDbdVYv840GhhpXdrQ==
X-Google-Smtp-Source: AGHT+IEZPq9JAZBfv/HDTaiqlxwio+gpwy5VWQkFScjzBWu4+U5mfVT+UUJR8YyZ7zO116a8IO9RMjZ+2gQY1usLMg==
X-Received: from pfbcj22.prod.google.com ([2002:a05:6a00:2996:b0:747:a9de:9998])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:aa7:88c8:0:b0:736:3ea8:4805 with SMTP id d2e1a72fcca58-76034c56938mr377906b3a.7.1753208261268;
 Tue, 22 Jul 2025 11:17:41 -0700 (PDT)
Date: Tue, 22 Jul 2025 11:17:39 -0700
In-Reply-To: <aH4PRnuztKTqgEYo@yilunxu-OptiPlex-7050>
Mime-Version: 1.0
References: <CAGtprH_Evyc7tLhDB0t0fN+BUx5qeqWq8A2yZ5-ijbJ5UJ5f-g@mail.gmail.com>
 <9502503f-e0c2-489e-99b0-94146f9b6f85@amd.com> <20250624130811.GB72557@ziepe.ca>
 <CAGtprH_qh8sEY3s-JucW3n1Wvoq7jdVZDDokvG5HzPf0HV2=pg@mail.gmail.com>
 <aGTvTbPHuXbvj59t@yzhao56-desk.sh.intel.com> <diqz8qknhj3l.fsf@ackerleytng-ctop.c.googlers.com>
 <aHjDIxxbv0DnqI6S@yilunxu-OptiPlex-7050> <diqzqzyeg3j2.fsf@ackerleytng-ctop.c.googlers.com>
 <aHm2F95XwzdD7nod@yilunxu-OptiPlex-7050> <687a6483506f2_3c6f1d2945a@iweiny-mobl.notmuch>
 <aH4PRnuztKTqgEYo@yilunxu-OptiPlex-7050>
Message-ID: <diqzwm803xa4.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH v2 04/51] KVM: guest_memfd: Introduce
 KVM_GMEM_CONVERT_SHARED/PRIVATE ioctls
From: Ackerley Tng <ackerleytng@google.com>
To: Xu Yilun <yilun.xu@linux.intel.com>, Ira Weiny <ira.weiny@intel.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Alexey Kardashevskiy <aik@amd.com>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	linux-fsdevel@vger.kernel.org, ajones@ventanamicro.com, 
	akpm@linux-foundation.org, amoorthy@google.com, anthony.yznaga@oracle.com, 
	anup@brainfault.org, aou@eecs.berkeley.edu, bfoster@redhat.com, 
	binbin.wu@linux.intel.com, brauner@kernel.org, catalin.marinas@arm.com, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, dave.hansen@intel.com, 
	david@redhat.com, dmatlack@google.com, dwmw@amazon.co.uk, 
	erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, graf@amazon.com, 
	haibo1.xu@intel.com, hch@infradead.org, hughd@google.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgowans@amazon.com, jhubbard@nvidia.com, jroedel@suse.de, 
	jthoughton@google.com, jun.miao@intel.com, kai.huang@intel.com, 
	keirf@google.com, kent.overstreet@linux.dev, kirill.shutemov@intel.com, 
	liam.merwick@oracle.com, maciej.wieczor-retman@intel.com, 
	mail@maciej.szmigiero.name, maz@kernel.org, mic@digikod.net, 
	michael.roth@amd.com, mpe@ellerman.id.au, muchun.song@linux.dev, 
	nikunj@amd.com, nsaenz@amazon.es, oliver.upton@linux.dev, palmer@dabbelt.com, 
	pankaj.gupta@amd.com, paul.walmsley@sifive.com, pbonzini@redhat.com, 
	pdurrant@amazon.co.uk, peterx@redhat.com, pgonda@google.com, pvorel@suse.cz, 
	qperret@google.com, quic_cvanscha@quicinc.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_tsoni@quicinc.com, richard.weiyang@gmail.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roypat@amazon.co.uk, 
	rppt@kernel.org, seanjc@google.com, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, thomas.lendacky@amd.com, 
	usama.arif@bytedance.com, vbabka@suse.cz, viro@zeniv.linux.org.uk, 
	vkuznets@redhat.com, wei.w.wang@intel.com, will@kernel.org, 
	willy@infradead.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CA8C880004
X-Stat-Signature: xmhs6y5wmpcqpmekd64dax4u4s6r7bqr
X-HE-Tag: 1753208262-775221
X-HE-Meta: U2FsdGVkX18Et9Da0OTfWOOp9D3iVyvfTNw/3Nz8NQ72XAAdej3S4GrgqNq9FwLpeLcms87sbLj6GNXUlTEAgS/Q+edNfctsArZklPkc6NWYaEjuXxJmYXk37TWoeEmbSNF7EnWHHToNFLzHKCET0mvDsBh5Rlzgiy6q975YAsbgZ80g5Ops0NjVuvsvjKYcgykvWTxCByQ0CwvPNnQvBMljUejhI9qTYRGEf6YYJj3eRthkh/SfLvMLSnCdQTeS/vfsY/lcayZYndlOzXXe6KlqeT3QIfKw/KILt7Fpg6HttjlxltvpI7MnRUwP2tA3YBY+1BFPiTyzfYFaknURsS8JC/XKfWyspvUYeJHqJYntM+97JEh4SKFD0KWU0beKx9ZOMcY3e03CL6k0cEXBZ0/FRSRjEP8F78pUxvn/WDkdV/Mc806lQ7BQqfVeusobUcRG2+ltIX7KGhIgPQ39j9w0m4VmTvHm6qaXLqtTutfgi55kZMPNccqXFr5CxuArA/iQSgSodSN+X0l7JAPAlGl3NPJbsXz9lF1BdJ9zLOgsbbJ0mWd9jYnTe3H+VFXfuw1CxWHfR6X31TvLcO0m7v+CeFUO3bpj7Qk03nvE1IW289cwTMaQ020UPM1uHQLOc3EpFTE/ZChtq56CRzXkPUyoJ147HDk0uN5G8hzZExiM6bn78/YPZRzw0eGv3EP9aLCFl4mzbXspQZw3fBZJTOlXba16qqeiODWmBERHj7EPrrdAs6M81vuRYipHDwrqLkwex8GjKojYCWPAKbQ6VidvPoQvxruB59r1XRZ0AJ8Q5yD3a3P7v/NSP9uzXH3IXcVtYtgR3VrHmqzQ4VsDHARKIk2ovhevcJoVHl2zhbge/kzMaHmjkfW6jUlDsOGnwDazH++b+aI7SP4kpxfJz+ALO3BEIKs210PPz8yVB/jT9nJNEtQ1EQMSv7kDovbt7I6ovAxdyHVFzbOu+DX
 vG9LeEgr
 OpsbMwsrv/ujRSxAhNU6wpxy6iRAclWdjVT0oauzxh3iGVtIU8Lb981a/fNo3MbEpzFSR/nG8tGgYMwQHQyrM+HFZFdPs8mdjcVpiWHsBFwwyF15MeRiSEIltZ4giH/3J6tSYTcqX+Lie5ZbgOubi/mU4KVisVoVObJSi+oiV5Fl1UNIqvAsypwcy+mBPuDLPIDM0g4p2Ja0BdfZ4X+CL++uXfpkbVUjkTfHsu5XxFFrWDi2+l0Fz1eb9qair4JueKAbAgJas05jiot1NMcMbuO7WP51IEIN74gT5LLky8Ji5Gu5/7d2KpSjCeX2lWCENp6a3U1Ah4TxEcEebIsRsFZ6MNHxFB8YGvh2dGlkwYKjGt+CcPcyYiChNz5Zq7bh7EoCnH/HphXq4xWhb/zq3M7DhOuiV9xUhABcPPpczn5wFy68vswR1xTRFW/pppe5Wozm3McsNFFRWf2E3kFPdUYlIf3JylmLpxHgky/Zpc9dtdkLlHOp0DAyyMqBsiPPnQG2Ts6QbvD0eOECxiMubcaBVTSJbV9BeUUnkoeiPUzlsv3XuoBGcB3hPRsKy1gmoliSkwWIx4ehtCNMCFy6V6d/qXR/Ob5lit86ZG084Cdk/hZpAUm7ww0BzmZH8qfHKm+gUL8luZg2FCEm7hx2rSo1wFA8+We2EzXJObbgDPMt1+ov/YYtt/lBYooZciM4gGmHw5T3ReGcsb0mdLinPV1y/mBWmlfMbPQhChailIAgPhLtpB7hxZjBR2r/28fiVyb+6JgD8ORTOm+hu1OjCH1j750JXgtCZRYSO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Xu Yilun <yilun.xu@linux.intel.com> writes:

>> > > >> Yan, Yilun, would it work if, on conversion,
>> > > >> 
>> > > >> 1. guest_memfd notifies IOMMU that a conversion is about to happen for a
>> > > >>    PFN range
>> > > >
>> > > > It is the Guest fw call to release the pinning.
>> > > 
>> > > I see, thanks for explaining.
>> > > 
>> > > > By the time VMM get the
>> > > > conversion requirement, the page is already physically unpinned. So I
>> > > > agree with Jason the pinning doesn't have to reach to iommu from SW POV.
>> > > >
>> > > 
>> > > If by the time KVM gets the conversion request, the page is unpinned,
>> > > then we're all good, right?
>> > 
>> > Yes, unless guest doesn't unpin the page first by mistake.
>> 
>> Or maliciously?  :-(
>
> Yes.
>
>> 
>> My initial response to this was that this is a bug and we don't need to be
>> concerned with it.  However, can't this be a DOS from one TD to crash the
>> system if the host uses the private page for something else and the
>> machine #MC's?
>
> I think we are already doing something to prevent vcpus from executing
> then destroy VM, so no further TD accessing. But I assume there is
> concern a TD could just leak a lot of resources, and we are
> investigating if host can reclaim them.
>
> Thanks,
> Yilun

Sounds like a malicious guest could skip unpinning private memory, and
guest_memfd's unmap will fail, leading to a KVM_BUG_ON() as Yan/Rick
suggested here [1].

Actually it seems like a legacy guest would also lead to unmap failures
and the KVM_BUG_ON(), since when TDX connect is enabled, the pinning
mode is enforced, even for non-IO private pages?

I hope your team's investigations find a good way for the host to
reclaim memory, at least from dead TDs! Otherwise this would be an open
hole for guests to leak a host's memory.

Circling back to the original topic [2], it sounds like we're okay for
IOMMU to *not* take any refcounts on pages and can rely on guest_memfd
to keep the page around on behalf of the VM?

[1] https://lore.kernel.org/all/diqzcya13x2j.fsf@ackerleytng-ctop.c.googlers.com/
[2] https://lore.kernel.org/all/CAGtprH_qh8sEY3s-JucW3n1Wvoq7jdVZDDokvG5HzPf0HV2=pg@mail.gmail.com/

