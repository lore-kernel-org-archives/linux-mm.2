Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7E08D358FE
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 11:10:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAE196B0088; Thu, 29 Jan 2026 06:10:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5C026B0089; Thu, 29 Jan 2026 06:10:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 967A46B008A; Thu, 29 Jan 2026 06:10:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 83E976B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 06:10:20 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2E5EA16011A
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 11:10:20 +0000 (UTC)
X-FDA: 84384732600.24.DD9A96D
Received: from mail-lf1-f67.google.com (mail-lf1-f67.google.com [209.85.167.67])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3B36EC000A
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 11:10:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cMHTzTOl;
	spf=pass (imf28.hostedemail.com: domain of qperret@google.com designates 209.85.167.67 as permitted sender) smtp.mailfrom=qperret@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769685018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=apF++zvcLgqSdwOs1FYPc9MkjitG47zUTTeeoONSIrw=;
	b=QBXWEeytI7frhhCHe+7C/+ZRWpy8DmmIQvK9CSb1wwdUdkR6I7ocxyNJ10SI71WCALSi3y
	RHaqqbrvdq6L5fNi1frKOLFwZQ+jwWkFo4CLynArSIJNnDqvXXpUIwtSd+8oLgFUEctSGH
	Fa6qe/agToV1FaKk65E3wgAD3GeMIFs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769685018; a=rsa-sha256;
	cv=none;
	b=pD51XtKQPWmSz2fuognevN76aeXi8SYqLio4N2LXnSQtDDZBU/vUfZU1TY/k0cxCnPNzC8
	6q/2cEJQK+WAF2s9xtDnrsutXplLXF05kmDHbFlZ9JXu/OE5qY1d2TBaDm1lWAHcnAAGTN
	FLzfeF8A6vZEH1Go0yjVhyt3Hoq1UL4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cMHTzTOl;
	spf=pass (imf28.hostedemail.com: domain of qperret@google.com designates 209.85.167.67 as permitted sender) smtp.mailfrom=qperret@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-lf1-f67.google.com with SMTP id 2adb3069b0e04-59dd7bfeb8aso1003977e87.0
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 03:10:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769685016; x=1770289816; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=apF++zvcLgqSdwOs1FYPc9MkjitG47zUTTeeoONSIrw=;
        b=cMHTzTOlmrwCEa8L7oMZOh8tna7rC0im+f4UwW9CGkFolyVtgPPDy/bAsIq9gEuxSG
         Twje6WglrbH6mtdV3bKBAAd0oJYezXd5qgoFT5WH6HItqd0kqHvXDBd74jH+dPInY1/Z
         /pG+XMLRa9Lzy9teSTmkJP2bMbQGtmWbiYHabNLrwmrUoamTbK4HYB6neI8ulZC9dfxu
         n+qNdryunYA92N97R7sOW6pJOq06EvqPqER1CaC/BEnoMWHwg2AOqMbV9b6U9MUkdTfN
         4MucFUhPMjN4dV13qme1cGoeC0Ho0CXw3guAShfYoHvtnjkjyOWHuJsWJAeetsuAnNhv
         9/pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769685016; x=1770289816;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=apF++zvcLgqSdwOs1FYPc9MkjitG47zUTTeeoONSIrw=;
        b=QI2RtSCpgY54nLN04Z98Z8CUIOxCcvynVVV/qXONvepW1U8rRpALyYmKiKNq4Z560p
         n8Gjs3q+iSAked6rT38VAYfRFDKOiKbZKdRcb8SZz1KAAduu8PJgQl+513gmOqKW79sK
         3QoAz0ge+kswzxZYSTRazTAapkUQ0YJEu+KML9CNrFAaTFFtsefQfCTlljU2w24j2gCZ
         b69XEQwP6jfBrmNojN+75makQwNmOnloFvNews926PSU4sePZRaEs78sF9a5C7eLhP7r
         g1tT8ZVHXQkdinfm/NNd4LNCwD6M8VtSSOhc0Y/I5tlR9I6C6wUbOM+q6seHqImZ4PZx
         qwYA==
X-Forwarded-Encrypted: i=1; AJvYcCWXoDXa6MytGX6GdsABTVjw6HMy0VRwnPuHp7jzvdK/QAAlpk+FLZ+Yga2pleoXaY6fvuc5Vn9Ceg==@kvack.org
X-Gm-Message-State: AOJu0YwDPk1F6IS66mQetfNKp5n9i0qqEpWtHjBk+i/aQpcv+mmq3lIZ
	6qqswNB2SszmCp3L0fnQsMePHCzH987GdCrm51w6LrnalGjKO0Bu6G2g3QECPluexg==
X-Gm-Gg: AZuq6aIDyuG47uKlV/mdcEZoXLYlXaMmcvoKa60LB7lK+pJNzVgbqcFuh10kzj54oSx
	34a7JVz4jAV7+JcUX356ERaoOm883lAPDFhE07C8UI/4XAGPxyxt0hbQlYcJuUUVu7b5zsDMdVX
	k5b/N9k2axlhtvCs13kPw7A3xp64gJwiD7cmIUe9LK2gXcOE+wn7kHyzr95zyEieBJDpqZH247s
	+69EstTLfaZZa/5DY9HXKAYRr1BAOJMISLXTXZL4iVUVIxs4vBAbm35IN8Oo8HuVWi0gcrx+vWE
	mitlHXgzowyptEFhxyqXuDpV9PktxdlNIQgljQEAuJdFkeX1BrcV74xJwdgmZHdU7DhfBYKp++E
	79QXTRntldD2lSzTlmaOMk+hOEZbnIKnHIUXSTRWbpE5D1MYj1Vi/mb7SRWACiyG1gNFsjjY1OB
	TX4QEH7JCL+j6v7e8RUHSG4aMWKarAKcpdOkR/U2km/Po8LQ==
X-Received: by 2002:a05:6512:3c86:b0:59e:133b:f76f with SMTP id 2adb3069b0e04-59e133bf83fmr81660e87.23.1769685015739;
        Thu, 29 Jan 2026 03:10:15 -0800 (PST)
Received: from google.com (133.23.88.34.bc.googleusercontent.com. [34.88.23.133])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59e074814a1sm1097806e87.15.2026.01.29.03.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 03:10:15 -0800 (PST)
Date: Thu, 29 Jan 2026 11:10:12 +0000
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
Message-ID: <i22yykvttpc2e4expluuzucczqnetdnpee2wx2fzqwg7cnt45x@ovx7e7hok5iz>
References: <cover.1760731772.git.ackerleytng@google.com>
 <071a3c6603809186e914fe5fed939edee4e11988.1760731772.git.ackerleytng@google.com>
 <07836b1d-d0d8-40f2-8f7b-7805beca31d0@amd.com>
 <CAEvNRgEuez=JbArRf2SApLAL0usv5-Q6q=nBPOFMHrHGaKAtMw@mail.gmail.com>
 <20260129003753.GZ1641016@ziepe.ca>
 <aXqx3_eE0rNh6nP0@google.com>
 <20260129011618.GA2307128@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129011618.GA2307128@ziepe.ca>
X-Rspamd-Queue-Id: 3B36EC000A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: qhesqa1au1gjn31ht5q3eszeiuqe9aqs
X-HE-Tag: 1769685017-555132
X-HE-Meta: U2FsdGVkX1+TY5wMENGlcUFATfC6+Q7KIspdd/CKmPOsu28Q3qlfy/fenueM0+rNtM5HBng+hwzhMriE00CypiHgJ9dyp95SKLgtytQriaG/KLbxmMC/Bqo6+Gf5l0AV8vRKc6p1MWewneCyxLQPTTLNyKWDDxGhIePkwoc64M8lN7wQPxNY2sv8Ujc6PxechJ0xm73JC+BW67HBC8uN4L/djFIGERiuzsKC3iZsE1iFzHhpFberFSFavOaGEKPwWNJEuOe+nliiMDsYfLeH3rXqJyR8O4rAn1JHsqbzuiVWUk1n3L0CDMQubcXxu4TJWx3NG1/OIQPC1jutsqpV8FGD3IbxjT9XV1RZrcI5AcQOu71a5V8KVOu62xxzb/7wxxlP0L9WqS/Y7y1lb0KFHpVm9w3ghT9kj4ypWsTnn79MrppJpxFtWwRwbAdBp26VSQrh8jGMkBuj45K4DKsOMOzszkyKup61FhOC5EtKRmQSW3uysaN2evIi1RSsJrubI6QyXwNO4e6QVA/+DHgM6S5jYCbg4ef+uIZAVbnaNuiiwEov1KJJSKk97ZuiTtwTtMBNI7o41xBsXe2mv7UW4VDC/HjbiTOTdqHnOHT+hICkBr2NxpdurgIYVTGcHNmR+ztfGNircF9zJoMjXCHM9YLdYCz5EIRVCx/cSJUcI6TsKS8u3mBsRsVIIUCQe7x7XYEi5PSHPRlS7zIHL37dd/rzobNj1cq5aU0vy/ntL6653UN8/2TRxzM1dbi9ZtFkE3bkMj/M6XTI+67OgqLudvWqimeAneZZUoQ4Ul5GPOUUY0t75vuPkF5BjgoF9HdoXc9tbI4QOxjyAL0o7UNoXhOH3kRmoqnQ7jAVHbXbIPhtFcxLQhpsY01e0hoWbeOIy0NkFnZM60Pi8rTRk6QtJtLpBFHJp/LlyYmhYCtLB377BpCQu/z9BQKDwhEeE8nngbbAno3xe8QCnaiJ6xe
 1bZaI4rz
 pS/ZMssaVW8oP3MJ0/FVIny++nZddKXyZ8pO7HnEapPgRGNa3tk1zfXpACkvNyYMK0fednE2lAhXwuX4LJ2+ZhbeojukWEjOFLyzSUiWJigrkaI3Rqzd5fTuGVHXvdS2PedyeaFAG6ONgcg59YrPlc8FQMV6RJz09ela4ddNXoJcBbxeR6LMnASWOUMXdfEEwG/cOUA8KtIQ/VaY1ATe8gXHqbnBWvdclw4xBJHrxqvHU6fEdDrAGJdyL2muq5Dmu35BF9GxlyIcNdpPQ+w9/OQcCT1atw+VLLIUn8k4T4CoPvADbFbOmJuPqW0d2snGE+voGRqjjKbbFd/kBQcWcduq5QTFzSQiSStY9PVAQjmPiPpzCBhxC5GZ7EE/eOEBjCGqbzCeB2FzHK7+UcXkC1Nynsbz0lIJei7iZP40lyaLNkJGoRnE+ez9yfwatNB/UNv9xug/pndm+Hk5xcUE/utqO3/YiPCdEcoRj7w556kZFG85PuyVwNDxenY5fnU/1xWHKjbSnZuoHjZTu35j6q5ZXLk0LQsCz44ZA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

On Wednesday 28 Jan 2026 at 21:16:18 (-0400), Jason Gunthorpe wrote:
> On Wed, Jan 28, 2026 at 05:03:27PM -0800, Sean Christopherson wrote:
> 
> > For a dmabuf fd, the story is the same as guest_memfd.  Unless private vs. shared
> > is all or nothing, and can never change, then the only entity that can track that
> > info is the owner of the dmabuf.  And even if the private vs. shared attributes
> > are constant, tracking it external to KVM makes sense, because then the provider
> > can simply hardcode %true/%false.
> 
> Oh my I had not given that bit any thought. My remarks were just about
> normal non-CC systems.
> 
> So MMIO starts out shared, and then converts to private when the guest
> triggers it. It is not all or nothing, there are permanent shared
> holes in the MMIO ranges too.
> 
> Beyond that I don't know what people are thinking.
> 
> Clearly VFIO has to revoke and disable the DMABUF once any of it
> becomes private. VFIO will somehow have to know when it changes modes
> from the TSM subsystem.
> 
> I guess we could have a special channel for KVM to learn the
> shared/private page by page from VFIO as some kind of "aware of CC"
> importer.

Slightly out of my depth, but I figured I should jump in this discussion
nonetheless; turns out dmabuf vs CoCo is a hot topic for pKVM[*], so
please bear with me :)

It occurred to me that lazily faulting a dmabuf page by page into a
guest isn't particularly useful, because the entire dmabuf is 'paged in'
by construction on the host side (regardless of whether that dmabuf is
backed by memory or MMIO). There is a weird edge case where a memslot
may not cover an entire dmabuf, but perhaps we could simply say 'don't
do that'. Faulting-in the entire dmabuf in one go on the first guest
access would be good for performance, but it doesn't really solve any of
the problems you've listed above.

A not-fully-thought-through-and-possibly-ridiculous idea that crossed
my mind some time ago was to make KVM itself a proper dmabuf
importer. You'd essentially see a guest as a 'device' (probably with an
actual struct dev representing it), and the stage-2 MMU in front of it
as its IOMMU. That could potentially allow KVM to implement dma_map_ops
for that guest 'device' by mapping/unmapping pages into its stage-2 and
such. And in order to get KVM to import a dmabuf, host userspace would
have to pass a dmabuf fd to SET_USER_MEMORY_REGION2, a which point KVM
could check properties about the dmabuf before proceeding with the
import. We could set different expectations about the properties we
want for CoCo vs non-CoCo guests at that level (and yes this could
include having KVM use a special channel with the exporter to check
that).

That has the nice benefit of having a clear KVM-level API to transition
an entire dmabuf fd to 'private' in one go in the CoCo case. And in the
non-CoCo case, we avoid the unnecessary lazy faulting of the dmabuf.

It gets really funny when a CoCo guest decides to share back a subset of
that dmabuf with the host, and I'm still wrapping my head around how
we'd make that work, but at this point I'm ready to be told how all the
above already doesn't work and that I should go back to the peanut
gallery :-)

Cheers,
Quentin

[*] https://www.youtube.com/watch?v=zaBxoyRepzA&list=PLW3ep1uCIRfxwmllXTOA2txfDWN6vUOHp&index=35

