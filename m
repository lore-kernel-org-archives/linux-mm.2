Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFB74CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 15:38:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F219E8E0002; Wed,  3 Sep 2025 11:38:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED2398E0001; Wed,  3 Sep 2025 11:38:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0EFA8E0002; Wed,  3 Sep 2025 11:38:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D1F538E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 11:38:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 66A8513B633
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 15:38:11 +0000 (UTC)
X-FDA: 83848345182.22.5F60702
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id B45EE2000D
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 15:38:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B0HiDuSB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756913889; a=rsa-sha256;
	cv=none;
	b=MoyIGIjio9Vcoc9q8GEVc64X95PwW3oSzG79uj1OmLntZPgQibIHw9yb5x6sSxhDAmXTtQ
	CySEGHPxJuUTgWDG8j0joN7JQFwmnAtiFzStwbQDeyzmdJCGK/bT68DhB7/Hkt0HBAMNNZ
	s7QdXCSlXGkh1akt7nzcX1+/+R26CFo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B0HiDuSB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756913889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G7m7HgAScPLaNuoY0WSUUhFXT4QObHzGrnYb0tG4G4M=;
	b=aa+iL30/pmbMnKOOMEu6R+863IDfwGSkPKv49FHstQL3G5F9VMbGu+n0dBgWnnXY7mdqiA
	p5AWeNZPbVnmHJteSZ+bEv0MDJ1DCTKbDeD0LFSsMU5Zj39/QHkU4wVX+SHi9M+Mq02jeN
	AfkdVt3n3941ICkKkwyLasd44kkIAqY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 18BF0600B0;
	Wed,  3 Sep 2025 15:38:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73FDC4CEE7;
	Wed,  3 Sep 2025 15:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756913888;
	bh=kPZ/HOC3SKupxm3BQU2AcDhJjHorr5M7H7D+uIJksLM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B0HiDuSBWD6RKvzMmsTgK0+L/QNoNUgURaef943FSpHKL181/qC/AAadQ1B+rFsgs
	 bwFMu4c8jwYCeyd+Fe+h2ZSm0HaPkWxMk850oIpz+Tn44thrU730jQE7Xup+QiRPXc
	 omi5lR254h3+m2tM/5haS2LtmkQi8QxwD+6XKlU81wmasOw6Gz7U6QCsG35fqnPCEA
	 FnH4Eqwg5SHGWjtKVULPk5EwlN0utT1jiOOKyQURj0czHTrIGS+iuhH+A4zeOB8tCl
	 rEwfZ1D3rZymmU/+l5QGmboLmcPDfdrmcafF6vaDmvA/bsnItmFaGjM7jVHmnRRObD
	 7J1vbX8rxRI9g==
Date: Wed, 3 Sep 2025 18:38:00 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>, Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>, Chris Li <chrisl@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kho: add support for preserving vmalloc allocations
Message-ID: <aLhg2Jli0KUe-CXC@kernel.org>
References: <20250903063018.3346652-1-rppt@kernel.org>
 <20250903063018.3346652-2-rppt@kernel.org>
 <20250903125620.GG470103@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903125620.GG470103@nvidia.com>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: B45EE2000D
X-Stat-Signature: o4ncicysmny17h1kh5tf7ifkkph9ghf8
X-HE-Tag: 1756913889-651123
X-HE-Meta: U2FsdGVkX1+40aevPizxJZJodyu8z9Kyo+lTBXbkgDphfMcSRW0lJSTwIwwrJzpjga92og77IAMI1MLHBhtFP0d9AQLVr9W5F6UDBnjIwaqMJvsassVVcYF0aFNLm2gRtSrHyZJEht+4EIa1qtfER+WJtO1tNSlT76gxyGBgzLWHZwbmw67yxjb3R2SxtNa+duXKF3u4TsYOcA8Rdfhe3Vx9YGAreCk+MIIv/MJWLiFOzJKNiRKB/g0jxRrhhOiGambD6N0W1UVzvWyw6Adf+YqOIgX8ESsEYWte/CkkKw5b8pA/G4q3zPAmKoa+GDS1U6mV4GrwGlA0SNnAayNbEk+sGw393vV2mAAaowT9Tgqk6mQxOPGntkdjeC/JiofhF48EDIPL5dHup3T45T3EcPDmHmIjwaMLT0PGnE9eSH0zq4ku9nF7MdH0faQP+/CPd0I2BlPzpdHcBb+lUkiE8F41KZ1snrXB+QHjyUHv0EBEfxE7TA9d4QdxEFQMeWihPa3rBdIWl73T4lq/XYdhYfxbLALkaHweK1irlzr+IZ16khnwgGW4znP5Hu81nJT7hnfeGYPcgOw0WtUWGTZpq7ZYltAacyU93P4mTOIdTwC2sgmKJkhigHz1rcKLmuZH0zyY87roFaV0q83dgAVbxxRcBnzC4V6HTYJUjjGz99AwOU1gSdk1Gqb+01lvgLyaiNZczzmij5AvscSwoNLJyYiRMTIwDCajwMlnVxCZ0vQ+b3W+vSW1MtUMOdlyz1H0CluydI2k0gqlxNX7D5rygkBqlMJ9ZPsW82ecETeBf9dDhQ3hKMryQy6u956NLVPNJRSjISLxYjboaZQ24cQWNruKHqYrZD2r4DPtRcOyZvpaNkE3+uGNmO/I47yiYURP77FfJIET5wY6y7izPdHQq0cySE7kg3JerbL25aMvhwF2GvX3WpF/mF4cHOW65dlRwgJZvrZCWeTeDE2pcbJ
 ecrNBfZh
 gJZk0upBlLa6vV6LfwB3CJC3B8HfBmpR1iroDcbcyxhqRomntg4lUPxnCNItcVMyl1pRpfbR7w/MeoYC7ve0ju1FPqkXSI3Nh1HDchnihUpPxGwxO2tPp12ymPIus4+/59cpWOOORokSwPSdnOl6l96cNyc0EPe54CT9sjDbZQP9245NIKM+QAFmRxWztcE6evcvsT5RpoctNjSfg9VJErYrIi1ndsZekXmSfBK85OsmfEktLh4SoAnLLH3pt1+qiOAWI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 09:56:20AM -0300, Jason Gunthorpe wrote:
> On Wed, Sep 03, 2025 at 09:30:17AM +0300, Mike Rapoport wrote:
> > +int kho_preserve_vmalloc(void *ptr, phys_addr_t *preservation)
> > +{
> > +	struct kho_vmalloc_chunk *chunk, *first_chunk;
> > +	struct vm_struct *vm = find_vm_area(ptr);
> > +	int err;
> > +
> > +	if (!vm)
> > +		return -EINVAL;
> > +
> > +	/* we don't support HUGE_VMAP yet */
> > +	if (get_vm_area_page_order(vm))
> > +		return -EOPNOTSUPP;
> 
> This is a compatability problem.. Should have some way to indicate
> that future kernels have an incompatible serialization so restore can
> fail..

We can add version or flags to kho_vmalloc_chunk, e.g. make it

struct kho_vmalloc_hdr {
	DECLARE_KHOSER_PTR(next, struct kho_vmalloc_chunk *);
	unsigned int total_pages;	/* only valid in the first chunk */
	unsigned short version;		/* only valid in the first chunk */
	unsigned short num_elms;
};

I'm thinking about actually adding support for HUGE_VMAP for the next
resping, but version/flags seems useful anyway.

> > +	chunk = new_vmalloc_chunk(NULL);
> > +	if (!chunk)
> > +		return -ENOMEM;
> > +	first_chunk = chunk;
> > +	first_chunk->hdr.total_pages = vm->nr_pages;
> > +
> > +	for (int i = 0; i < vm->nr_pages; i++) {
> > +		phys_addr_t phys = page_to_phys(vm->pages[i]);
> > +
> > +		err = kho_preserve_phys(phys, PAGE_SIZE);
> 
> Don't call kho_preserve_phy if you already have a page!

Ok, I'll add kho_preserve_page() ;-P.

Now seriously, by no means this is a folio, so it's either
kho_preserve_phys() or __kho_preserve_order(). I don't mind switching to
latter, but I really see no point doing it.

> We should be getting rid of kho_preserve_phys() :(

How do you suggest to preserve memblock?

> Jason

-- 
Sincerely yours,
Mike.

