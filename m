Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9816AC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 23:41:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1123E6B008A; Wed,  9 Sep 2026 19:41:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C3B56B008C; Wed,  9 Sep 2026 19:41:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED0396B0092; Wed,  9 Sep 2026 19:41:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B74376B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 19:41:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 95CECC037A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 23:41:49 +0000 (UTC)
X-FDA: 85195848738.23.7762653
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf30.hostedemail.com (Postfix) with ESMTP id DDA3E80006
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 23:41:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=nXRbXZKm;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=nXRbXZKm;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788997307;
	b=hzm1Q0PQpM/+jY9arTd62HtbPmdh34GrxKL4zI/ue3JgUSYAng3jhj+W/D57niR33h6BUo
	wndLMEp1Tme5SD9agMm9mGKO5VOvbFK9IF3wbPtGCglNC+uq6t7ghS5s82ESTAC3RY2I6a
	gSGmhGIgz/dzV/Ly748Gn0hEd1urouY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788997307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/7IOpadrhcRwpRxbqmeGZRwsgZAI2r5KwJqdOCsAZ4E=;
	b=VqxpV4nVAmf+4sb01e6owtTbM+bM5lEU+z9NRJRgvAw56A9+1ws/XU9fQELoDv6s0p4aR1
	ukFLGmS3RspOakf41zvU+Wz6D/INu7cgIarL99HYb2gyAXX+wbpXCARE8FxJ9GwpWhmVrV
	fC9+GMebSS2rqXPh+/skXKC4WzFAYVs=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-9399daa3c8eso366217485a.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 16:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788997307; x=1789602107; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/7IOpadrhcRwpRxbqmeGZRwsgZAI2r5KwJqdOCsAZ4E=;
        b=nXRbXZKm9Gq//WAPNGU6jz4IwWkDoVBrlomQ4hybnCzipnleSem74XM5sULeXnnzEu
         GNV5s8ClpUH/rttTGFz1F25szHSW4yYeHt7kaVoXT5oP4rtxaY59Li8L+psDlZcQpuK0
         s8+/dX9M8olYZiPtlYLWre++jnYKmdcndsUc76omTT0APV3dulXROgw4ybK33ww5wgcA
         EAW8PHnYBup4UH+Em44yXH7LAeqk3qtqbomMfJxIDmMH9wPq+Qzx8KdZgDqQeuhGla4B
         AIRBieRpT0pwdIxWqo9nEkjX/rmqTdBtc3k5PMeDjbGzbPd+/Fvs973Fs1wTo9bl3Ign
         OiQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788997307; x=1789602107;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/7IOpadrhcRwpRxbqmeGZRwsgZAI2r5KwJqdOCsAZ4E=;
        b=Nw1d2lzztukyGP4Jt0kwg/m46OIe8Wv33WP7+kXO/gXm/dI/UT+2M70mmfZpDDdLl5
         53EhgZaBrwyODFp9c3xKKml+4bfCjp3PXvG2eHDQ09a6xOX4P72goguGE9Up7r6rAGqT
         p4r4pXSrCJC0UVh5DLJI1PhJOj6Bzp1ss86i5phTusg25uNJRirhxfPiKJqxX3WxhFpw
         uATsVqF+A1RkCnLb4hpHRXfAAseD0v8x+F7spwLHDXCaUDEZfQZTee46lnB63tLfJwNn
         dgqjeo+2PenSwbNyQLqfSTPGWLDLlfzEMp1FxMZ6P5pylVvPB0M5plrFDpFzIQKy0WLq
         4uEw==
X-Gm-Message-State: AFuF++k4v34neWFabmwU1d3n4cdjXY8TJKazWsfnNWkmX5hOem6Gz07D
	HclPuqd7Vh/chE3P+ZufYnQ8z1SrmPajG1IR02KoWdJr3Lubzi9WnmJG9z4Kw5w7ff4=
X-Gm-Gg: AYBFou3LBYDBeth1Cy+ViIWSmmmiKkDZmj8SZBEaEGpRSNsYAlOer9hwLrC97hdEOUF
	azXWrHI/oBew23lHfk4yM21TCG3wwrFR4ptIKkIaCbNddI0N+POJhqqVg5lo969K6MWH96SWqks
	9AcZj+48a+sQfRVlbr37sn6oSTsjHnPDf5njduooVwfeV+lHuJU7c3RX3I5/dX+AnJJhZKOdvKR
	kn7mlhgQV5yY3ruDd/0S224I8ynVaM8uFviwxibFk7T++PdcOIGLTvGtxc5vaPUm3BDJX+HOQYH
	X+L2MMFFBtWZuAjTy+4dVZgtuZyZeRiuXq1TAXKSw87irxmK6dwXFnOf4fwPYTDpDc07ce9pn0T
	JTahJws0/8q97As5pEyHIo+LBFJT5IBr6ibBb87kd76xHD4QIonVp0WtLc0G7XKd2GJYqxLKXTc
	/4vqG1XWtkt6sFcgSfm2D5WhoHjP+eqF6OVYLhsXtVW5LF7TBqOr3OKjaaY5jaRIMP8atg3F2Wi
	D32WcA/ZBj8zTBFVJthhgvGZ7dZPcFHJh4eoPV/S0+NbDCVeJqxa7A=
X-Received: by 2002:a05:620a:2a14:b0:939:16f6:4d01 with SMTP id af79cd13be357-93980371409mr3949925085a.21.1788997306930;
        Wed, 09 Sep 2026 16:41:46 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939b0aa9a29sm795461085a.7.2026.09.09.16.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 16:41:45 -0700 (PDT)
Date: Wed, 9 Sep 2026 19:41:43 -0400
From: Gregory Price <gourry@gourry.net>
To: Ackerley Tng <ackerleytng@google.com>
Cc: linux-mm@kvack.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	pbonzini@redhat.com, seanjc@google.com, akpm@linux-foundation.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, shuah@kernel.org
Subject: Re: [PATCH 0/5] KVM: guest_memfd: bind backing memory to a NUMA node
Message-ID: <aqHtS6yKokjnhz2c@gourry-fedora-PF4VCD3F>
References: <20260902194657.79075-1-gourry@gourry.net>
 <CAEvNRgHWyBaBpZ4Bem1Eu86b-cuEA7NkyjxTJ4D3FnpGe1B2Yg@mail.gmail.com>
 <aqHkVKvons1tBs1O@gourry-fedora-PF4VCD3F>
 <CAEvNRgGAQj1afTRRO+DpVTaSCTZic3K_x6ZfwvBLUbfara5v=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEvNRgGAQj1afTRRO+DpVTaSCTZic3K_x6ZfwvBLUbfara5v=A@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: DDA3E80006
X-Stat-Signature: 4r4o5juj476h5kkqdzsbpdcfp1yzo8mu
X-Rspamd-Server: rspam01
X-HE-Tag: 1788997307-953976
X-HE-Meta: U2FsdGVkX1/G4M0LC0G3rcsh5CNDMVckTncbNPBH5+gBXSVTw1wiQUEJuDHEJEP2/mJnqqtTqAKqSlcXn/IitHwIMbDnzf0dwL9gFail1NoLlYC5E9vA3vb21Dc8Q02Gkbwqq354RY8sBMT18dVQS7MFDDUAzmZsGQfO21B4oVyhGFuCmH8c4SLeJu3/VZY9kEYErr6TIbGQ6r20HvKbZj5uucU5wAlVn3wTKnugtK4Dc2bm1FoUgIKdknGG4Vz5HxwTKygrsM0HDvZNxEYvZj0OsMyN75pip8Z1l0pndvMFGXsQEu7bMNdwkVN6l0U8EVpdj9v3QfPFqkhAphi5y7a6vjgoVepTRirGjSHDvc+8p7Bli/14mhGU0o7gxtmAI+CZYL5vKbB7t5WVtLmApgkU+f+1XtC1TkSuDdVD8JGjnhDT0+sOzH9cAedkSYfFeOBwOjejl19kUta/viBhkjK8Q7zUhrCHjMvaeIlIgnQd5VY3xVwVXnNquEmkDoDpBeY7TdC4IsiXvBL/RBsClRVtYT5Y8a19az4kW4ZzQZxtvKdCJWDJ0V987o0OpV3tEzdc2MTTiVxPvcwXwTM9UbGkhCnUEIoO9tC8KqCgWEIZl8YXIkH902REsXa+VlgJsL+D3zTHSxUs67CJp6ayMTH5Zx4R0j/eL3Ow2b1pHVgM5a7FHdOpBuAa/UCuvpOCNAmwytcijS+wBqy+TCcUhQDMVqQWC3PnZKle8P0yzzIWwIjZw1xO8suieaL94tJTZTrhrBBqCcxfz742xqGaNkQo/dogGPVchd9H2TNlpGQeBVrcrdlB5eg4eyQSJvim4oMrGkSc+29k1ssUqKrraAJOnYseIBPGoikD9upAXcbByfiIFnt0O8EP/dcri4tiT7MabGzsaC3t+7pqa8nvzBHC+IuBCUksHuYwJ0fkPLllJi5pN04e1eHAG5f/033lrNPf0TrINMZ2FQl30dF
 jh76ziFo
 cgbzcWmguvtFYn4HJ58NG3ICfNblC87yuSzHAf9nhcHHN1CrkKctsA4h8Clv2Mif5/yl8XXdpGomGb7MKNDonKfWkOVIcfpqZTNil0KoDAsLFKm+Dqw1tq9mYbQrv0z307yCYBa0MtAiBJGaAnelWQhq0tYqiVjAkb61WC58NtQlTwHpXgtyL7BhFuQz7ZE6PrCrK5SjanQUG8cy5C7I9gip9lOLIUvFL+W4VhchNHuAGHjLAeC/vY6+9ajjAXNyIz1bTzcq5BwuQQc01mFwSW3rkAZLWr9bcogILcFNP9zalaQlUySs+QIRrCS44S6W4bK8FQg5Yx7kg1aeaAekmsko2FGxY0lR1rkcKedtnH1gYfiIUk6Fv5WCognXlZBuwTW2n4bFzUd2vkzaALaxXrQvytMDjPYh987MoqDp4D5lzHULMkoaEngV9fQTG+IjGxPhAG1utsKuxsInGvKcFC6U7kchBqufEzl66YHtbWHH5xLaaGPdWZGTba8peqzBIoegQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 04:23:07PM -0700, Ackerley Tng wrote:
> Gregory Price <gourry@gourry.net> writes:
> 
> > in fact at that granularity, the desired node may not even have eligible
> > memory to host the task's memory.
> >
> 
> We have a similar problem where we wanted only guest memory to be
> charged a certain memcg. Currently guest_memfd memory is charge to
> mm->owner, which is the thread's parent, so doing the fallocate() in a
> thread wasn't good enough. The workaround was to have the fallocate()
> done in a separate process (fork) and have the child process's memcg be
> set to the desired memcg.
> 
> This workaround is kind of awkward, but could it technically work for
> NUMA allocations?
> 

That is a very clunky work-around, I'm not sure it's good to formalize
that kind of design as an expected user behavior.

Whatever the case, the issue of ineligible memory isn't resolved by
this.  A node may be 100% ZONE_MOVABLE, and later entirely unmapped -
literally no eligible memory for kernel allocations for the task itself.

> >
> > This was a consideration - although it has other limitations and larger
> > complexities associated with it.
> >
> > Where does the policy live for random fd's? (inode? address_space?)
> >
> 
> Off the top of my head the policy would be saved at gi->policy, where
> it's stored for mbind() now. fd+offset is just another way of
> referencing the offsets to set the policy.
>

It makes sense for anon use cases like this, but for some random file
where fbind() means "put unmapped page cache on node X" the story is
less clear.

> > How is a reclaimed inode's policy handled? (lost forever?)
> >
> > figured i'd start by reducing the scope to the narrowest and clearest
> > use-case, but I did expect to have the fbind() conversation.
> >
> > I'm open to it, but it seems like over-engineering.
> >
> > If you look at tmpfs / shmem, you'll see there is the option for a
> > default filesystem-wide mempolicy that can be plumbed, but i'm not sure
> > there's a real usecase for per-file mempolicies that isn't literally
> > guest_memfd.
> >
> 
> I see, can't think of other use-cases for per-file mempolicies either.
> 

The only thing i've considered is something like GPU wanting a file
faulted directly onto its node - but that's a mapped region, and that's
handled by existing semantics.

> >> May I know more about the use case behind this new feature?
> >>
> >
> > see above - confidential vm whose memory is quarantined to a particular
> > device, without placing that same burden on the host memory.
> >
> 
> Is lazy allocation a requirement for you? (as opposed to fallocate()-ing
> before the guest touches pages)
> 

Yes, because eventually some kind of overcommit will be desired. May as
well build it in from the start.

Looking forward to LPC :]

~Gregory

