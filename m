Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C0CAD6101F
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 14:36:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A58616B0088; Thu, 29 Jan 2026 09:36:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A06566B0089; Thu, 29 Jan 2026 09:36:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B0806B008A; Thu, 29 Jan 2026 09:36:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 77C456B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 09:36:23 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1AA0A140171
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:36:23 +0000 (UTC)
X-FDA: 84385251846.12.B3633E9
Received: from mail-lf1-f67.google.com (mail-lf1-f67.google.com [209.85.167.67])
	by imf18.hostedemail.com (Postfix) with ESMTP id 29DEE1C0019
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:36:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="aPdJ/x79";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of qperret@google.com designates 209.85.167.67 as permitted sender) smtp.mailfrom=qperret@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769697381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GCBf85o7m+LpjtZO2vby61ve+5QD+ZPBxgo311Kvx5c=;
	b=riBfs3Tx8DDIprJNSMWdCcozzPbUtvmlQtlujYDG9kaFwPRXGZHXglp1sYn3yK+B3w0StV
	rSrKU0Bjxm8NVcoasXOyccOggkspHD+zuQDvQKigtk+oCSWRGr2B/Ae7Z/wi2mln0zl8+e
	0R9dFSaJibK03E6Bqhbq32SCBlGt3Qw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769697381; a=rsa-sha256;
	cv=none;
	b=Sbtcx8UcjvqyJ03P/zGHLPTZSK2B7al7vdyIFnanPZrykzrYcY22MEKyVpyoKsSkH40jZn
	cJM+kxHpcopF5n2e/+TzslMn8KTNMh3M9Sbp4siJBnGp3uhgeXr3pQ2KnZV1hHS4HKfjA4
	8e0VvSeEqNTIH9Iv1jaeH+p+NWA65XM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="aPdJ/x79";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of qperret@google.com designates 209.85.167.67 as permitted sender) smtp.mailfrom=qperret@google.com
Received: by mail-lf1-f67.google.com with SMTP id 2adb3069b0e04-59de8860b94so1232720e87.0
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 06:36:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769697379; x=1770302179; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GCBf85o7m+LpjtZO2vby61ve+5QD+ZPBxgo311Kvx5c=;
        b=aPdJ/x79CFMPQ6eJaHaRNnps27XBS9HUrnX+FdYfjfXioMlfsqGRj4KlXZELmmOk3w
         sd8XIK0kuXK94bxZxSMpXcKGu0OYXEOox5Wzq+xIpNjpmdGrk/7BFPCtnK+Y84do+Zqm
         A1DNgTILdyeWi3YVSCPAAvzX3vOKT6sr+rybZsNrRp1eXjtD0DYEMBgAQ1cMyJoo6SUV
         vzZQpqbV7ZuuPGeXLiktWV2YyzBB87nKD0vqSCL9+zf6JlszSX4wdkT/hdMugElwd5ef
         /NCLTg3kEa4MSJxJxNIBuy2evqoLqH0QyiiDdXKS9OMITPYqtj7WjX7TaqNj94Z4xwZW
         WJUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769697379; x=1770302179;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GCBf85o7m+LpjtZO2vby61ve+5QD+ZPBxgo311Kvx5c=;
        b=vrsozz2Sd7MW+4WVz22LQoSWPCzk4LLFHqqknRumgB3qdV72xgbTAIpY346qrtjF69
         XJUon/laAM9N+OpfaApQg4VmS9oZLw+kSrnCpmUzEWgdmvWCAO5JHDpq8tpjtSjN0gKd
         MTHR+pMO+zNa2zpb+maZH7v/OyklcTuN4Uxlt/GSCTWbJgFQRU96qLhNZtozSBBpJvuB
         /vkbac7mzdILN1JFzIegTmOOvwFtM0rL99kN53+dpg1nq8uxLydoFiQFkSawYRn8JcEK
         jWJl7c4Z3bkaw1h7d3ZRY0ieCMNMSkBf8r6rxRkk+om7VFJ4cLcnyQtA89kz28KDo7LG
         PLhg==
X-Forwarded-Encrypted: i=1; AJvYcCUR71NFNhXs0dGXaajqJIa/DnhNJjSf/R5hOswtDxB6Xz2+Q48p97iJJKAaLldRxvhted7Is0uKIA==@kvack.org
X-Gm-Message-State: AOJu0YwbnQ461O+66m3Iw7ml5zYzz+I/XUdNGr2JQOkQn6cFgJFqptDt
	XNAIRFb3c5nWNRJ0uynaBKKR2Q6D+erkEQmqKZvPbAZXhSJnobNHQCmS/K1UODUr2w==
X-Gm-Gg: AZuq6aI3X4ZmR7SdJlHCHhXQDM+ua3161Dyo6FHKPioPhPu8PsHkKDIG9y++1jvQeLn
	cnKcYrvj8ea7rteOB2X853n4PPcflt+KrgaVA7y2d+zpuHp3X47Xya8tY433aga5ewCXUGycI84
	PRgl861TELiZxn/hejqGr9ZHkajan8gVO9M9TQz0cfod1WSHO5TqFsFeSdZ6H2MChW5LwZ/bKeB
	k0g77xRt/xZ2VnySqeJOjQjuszn9zU4vwwt04uIgMVkp13d4vPRcHudJowviOvmCcywei0dU86g
	MumMAqPobEw8hozxyxI0DCxboOgtKYgoHIXWuynijiaiIHU768nlvdKeHgOyB3VKewFZkxDNzDO
	cz9rSs86VduFb8SwtlYKYqUgkLqtn4myDZmFSlt7gwBdB1/ffYuRUv/48WVWft/ElrTpp5l/+V4
	+r0D20ua8kye46tSZkVsecpaifxd45ltqLz+WjkByaTbWhnw==
X-Received: by 2002:a05:6512:10c1:b0:59d:f4b8:c3ac with SMTP id 2adb3069b0e04-59e0401702cmr4088944e87.18.1769697378667;
        Thu, 29 Jan 2026 06:36:18 -0800 (PST)
Received: from google.com (133.23.88.34.bc.googleusercontent.com. [34.88.23.133])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59e074bbe0bsm1156180e87.83.2026.01.29.06.36.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 06:36:17 -0800 (PST)
Date: Thu, 29 Jan 2026 14:36:14 +0000
From: Quentin Perret <qperret@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Alexey Kardashevskiy <aik@amd.com>, cgroups@vger.kernel.org, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org, akpm@linux-foundation.org, 
	binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, chao.p.peng@intel.com, 
	chenhuacai@kernel.org, corbet@lwn.net, dave.hansen@intel.com, 
	dave.hansen@linux.intel.com, david@redhat.com, dmatlack@google.com, erdemaktas@google.com, 
	fan.du@intel.com, fvdl@google.com, haibo1.xu@intel.com, hannes@cmpxchg.org, 
	hch@infradead.org, hpa@zytor.com, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, jarkko@kernel.org, 
	jgowans@amazon.com, jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, kent.overstreet@linux.dev, 
	liam.merwick@oracle.com, maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, muchun.song@linux.dev, 
	nikunj@amd.com, nsaenz@amazon.es, oliver.upton@linux.dev, palmer@dabbelt.com, 
	pankaj.gupta@amd.com, paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, richard.weiyang@gmail.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, rostedt@goodmis.org, roypat@amazon.co.uk, 
	rppt@kernel.org, shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, tglx@linutronix.de, 
	thomas.lendacky@amd.com, vannapurve@google.com, vbabka@suse.cz, viro@zeniv.linux.org.uk, 
	vkuznets@redhat.com, wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, 
	wyihan@google.com, xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Subject: Re: [RFC PATCH v1 05/37] KVM: guest_memfd: Wire up
 kvm_get_memory_attributes() to per-gmem attributes
Message-ID: <od4dx6snqsl2qiocgf3jxm4dndxhrlvsfr22eveuno6nskgfdj@mxsywvku2jk5>
References: <cover.1760731772.git.ackerleytng@google.com>
 <071a3c6603809186e914fe5fed939edee4e11988.1760731772.git.ackerleytng@google.com>
 <07836b1d-d0d8-40f2-8f7b-7805beca31d0@amd.com>
 <CAEvNRgEuez=JbArRf2SApLAL0usv5-Q6q=nBPOFMHrHGaKAtMw@mail.gmail.com>
 <20260129003753.GZ1641016@ziepe.ca>
 <aXqx3_eE0rNh6nP0@google.com>
 <20260129011618.GA2307128@ziepe.ca>
 <i22yykvttpc2e4expluuzucczqnetdnpee2wx2fzqwg7cnt45x@ovx7e7hok5iz>
 <20260129134245.GD2307128@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129134245.GD2307128@ziepe.ca>
X-Rspamd-Queue-Id: 29DEE1C0019
X-Stat-Signature: 9d4pz6td459uyrf6jhj8as7cifgzudj5
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769697380-593845
X-HE-Meta: U2FsdGVkX1/Mz+zwR+VypBYwPy0nHm041jQf5LQKyfNpMYgI7HTVduwZvp8IsewFQ++QxlvDNfS3UDnFenBfgtEydFtM1wKsmJBrEduuN9qdSMswUGrieIqMj3FTEgzlC9w8m+5HspNWSSzNQBfr7zJYTJnXaRsInj+5M83Qqn1BoRV+6uMFVJFiEkFMzrGbgj/aUtO696wRIeL0bY5u3/nAZ4o9Ndz2WZUISAGeldXx8GEH4lJdlcdKoogPPLTId3dEyfl9lv8oICYX/qxi5sdH7GkWf9aXM+cspON4BCD4+cV6W1ZQ9pwrJ+AoqZ82dWEzwBt+bnt+CUwjPHv2nHekWkpCitnRtOSNFWlbD4+v6iSht6Ncow4K6feb9nAyj7OIrYnyGlUQLKU14radEhqpFN8k9HQ6Z4qZyo/C8o1gz2WaVtJcrFD/UP3m4tPyIMH6wPc0JkKwRkxIdIOI8B7YbSJMVQe7Q5F0eZDQNIa9gjsv4729tmqCuUcspiT4zCzFlOySUUhNJIp8rpQ3juEgYCRX272PKorXnIpi02y4VwcIxmckUZYQ+BqOXE4U8GWG35rcEHREhEepvmOhPibjG0waiVHbgb+yvXquJzUPozdrRFebOnAF8pVuYzXFu+1Q+QjOVoPo9uxlI3YJFE40PDCFidJLSBgAmXxaWEwF6w6KZCS9OJpzPdXM9CfwSmWNv8N6Di9e9VmoowqU44khLwOnm9wY9jbcbZUB8elinrQLSYsZyC+FmRjCFvorv1sU28chqxAPx/tRDKqqcYWJVZuIKHuRRgDr3h6AVB6V0PUWWtu6MvTnX6SEnIDqQO2vo9Z6eAG+27uAVbqkoHkdE27/PVXCxSFWh42/wlUcChOY1iTL7ysyZbAOGBKzRSkeyK9dIMRJdqWiWepzCpbTol0F9GDmwtOKF59o6FafMMSTyzTX0Pxbieo4iQ4J1sbb1APbPQ7P5cvpnPN
 Dh17Tagu
 X3O8626q2IMM7Pmbybd0N9KB3oE1HcFNMCufa0j50mkPT4kIaatBMcOLiovyeSts5HAGTYHU1IfJxQyxlzWFReNb8ISb2xxWnSrNZ5sx+1BXwmOkuXyUr+vP3vh4iNtDVd2629NlbSKFbKQzrZPWkhD5FttLRNlh2bNQsf/GRGwZPl2Nyz1KALtYsfZbibY6ZvuMCIF+VOu0cZQFcNmE7KYXJmefDXltI48ZSjxM8QyjBI2oPt5US2cQAeRxBvOaGqhaIWZya1+qgFeZaOaU5DF9sHAw4NCcD2CWfxUb/5rq7y5rVM+a+8KIPnAvGQQXgp17Nz7uYQ0i55tiaDTY7LkbiNswlvs5e8DLoFUMZRLJMsJOlEOOq7EvxXMxovSWAEzZ4Ckx43D29zMbvcP9Gi84fcYhvODVoUCDrAzUo14s+h45TJ0ev+IvPsqwmaLCS+ZcowGPCIIUMREl+/2wbR2/yuDkRdpDnAunlbi2dZt9zS8mtcSUpC8mVG+x41FCyG+H5D72TrHhmpqyyAD8UlRHTrrmORmwqkW9p
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thursday 29 Jan 2026 at 09:42:45 (-0400), Jason Gunthorpe wrote:
> On Thu, Jan 29, 2026 at 11:10:12AM +0000, Quentin Perret wrote:
> 
> > A not-fully-thought-through-and-possibly-ridiculous idea that crossed
> > my mind some time ago was to make KVM itself a proper dmabuf
> > importer. 
> 
> AFAIK this is already the plan. Since Intel cannot tolerate having the
> private MMIO mapped into a VMA *at all* there is no other choice.
> 
> Since Intel has to build it it I figured everyone would want to use it
> because it is probably going to be much faster than reading VMAs.

Ack.

> Especially in the modern world of MMIO BARs in the 512GB range.
> 
> > You'd essentially see a guest as a 'device' (probably with an
> > actual struct dev representing it), and the stage-2 MMU in front of it
> > as its IOMMU. That could potentially allow KVM to implement dma_map_ops
> > for that guest 'device' by mapping/unmapping pages into its stage-2 and
> > such. 
> 
> The plan isn't something so wild..

I'll take that as a compliment ;-)

Not dying on that hill, but it didn't feel _that_ horrible after
thinking about it for a little while. From the host's PoV, a guest is
just another thing that can address memory, which has its own address
space and a page-table that we control in front. If you squint hard
enough it doesn't look _that_ different from a device from that angle.
Oh well.

> https://github.com/jgunthorpe/linux/commits/dmabuf_map_type/
> 
> The "Physical Address List" mapping type will let KVM just get a
> normal phys_addr_t list and do its normal stuff with it. No need for
> hacky DMA API things.

Thanks, I'll read up.

> Probably what will be hard for KVM is that it gets the entire 512GB in
> one shot and will have to chop it up to install the whole thing into
> the PTE sizes available in the S2. I don't think it even has logic
> like that right now??

The closest thing I can think of is the KVM_PRE_FAULT_MEMORY stuff in
the KVM API that forces it to fault in an arbitrarily range of guest
IPA space. There should at least be bits of infrastructure that can be
re-used for that I guess.

> > It gets really funny when a CoCo guest decides to share back a subset of
> > that dmabuf with the host, and I'm still wrapping my head around how
> > we'd make that work, but at this point I'm ready to be told how all the
> > above already doesn't work and that I should go back to the peanut
> > gallery :-)
> 
> Oh, I don't actually know how that ends up working but I suppose it
> could be meaningfully done :\

For mobile/pKVM we'll want to use dmabufs for more than just passing
MMIO to guests FWIW, it'll likely be used for memory in certain cases
too. There are examples in the KVM Forum talk I linked in the previous
email, but being able to feed guests with dmabuf-backed memory regions
is very helpful. That's useful to e.g. get physically contiguous memory
allocated from a CMA-backed dmabuf heap on systems that don't tolerate
scattered private memory well for example (either for functional or
performance reasons). I certainly wish we could ignore this type of
hardware, but we don't have that luxury sadly.

In cases like that, we certainly expect that the guest will be sharing
back parts of memory it's been given (at least a swiotlb bounce buffer
so it can do virtio etc), and that may very well be in the middle of a
dmabuf-backed memslot. In fact the guest has no clue what is backing
it's memory region, so we can't really expect it _not_ to do that :/

