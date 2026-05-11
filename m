Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D78ECD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 15:09:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46EFB6B00F7; Mon, 11 May 2026 11:09:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4468E6B00F8; Mon, 11 May 2026 11:09:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 336476B00F9; Mon, 11 May 2026 11:09:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2126A6B00F7
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:09:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A907814017C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:09:44 +0000 (UTC)
X-FDA: 84755473488.16.0512C78
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8404BA0007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:09:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N9eWfuaA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778512182; a=rsa-sha256;
	cv=none;
	b=YCCO0dceisO2k+NAeyVxikS03ikCma6v6sSB2Uw0U5ESik3z8BTt+OlwrIAik97Oi0QsQn
	TnQq/OmXJoTTMt3ZLcY4v/Lz9/1JQ1b912GrAwkuJul0TTLp75Wb/fUfyNaUmz5qkl/H73
	XdKZqYyepCzLRANL2OYjjNc4AthmhyU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N9eWfuaA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778512182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AizvbhkaHZmbiszzPT3Ur4sT9Sy5a6af0Jfvs/KZVvM=;
	b=qfdlLHp5PhzrUtZSwJ0NYbRIu/SXZNUaVys09bJ244iM7mYk9BG9FfY/bEgyPsnWFY3KTE
	cADx2N+kjFWutGceED9h3F/jZxtPT+0YpLpxDrst2BOoJbNPxtuUSX27pBGWpeCuUzXcFd
	P2yp6XbM5/Krh8D+2dFUUOjcFD68iEw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778512181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AizvbhkaHZmbiszzPT3Ur4sT9Sy5a6af0Jfvs/KZVvM=;
	b=N9eWfuaArunIzZ9S3noElNdrZY3YyjxVXpxIAZwRsTxoWTiS6pggMJVvwyn8RochlsuXRN
	pvokN6LAk+r0c0TBzA47kkISVZs4r2p0rt1wPTditaKWv7HarSkT3LuH9WlVIQDyrLRWmJ
	EnbcXkHC3pqtONvGhkLbYWEuEWrp1K8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-139-fWBdHH4yM1W1Nu7cFoyaqw-1; Mon, 11 May 2026 11:09:39 -0400
X-MC-Unique: fWBdHH4yM1W1Nu7cFoyaqw-1
X-Mimecast-MFC-AGG-ID: fWBdHH4yM1W1Nu7cFoyaqw_1778512178
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-486fa07f2bbso27083235e9.2
        for <linux-mm@kvack.org>; Mon, 11 May 2026 08:09:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778512178; x=1779116978;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AizvbhkaHZmbiszzPT3Ur4sT9Sy5a6af0Jfvs/KZVvM=;
        b=kOQmVUR6/iDW2cVeDwveP2rMsqt/bQRfVSOwLYBDPjO7oYBkC4bQJFYwxN1erFtoQv
         y52urtQnmTRCIwCo1nE9Jrv+MDgV72rCctx9WufPIn8bIdxIyH+EhLTIuNcxvbW9bjZT
         PXXm4TZ8RgeBtjdSMmfSjQ0AgPSKmaane7+EKQLpRhEZJfFGBUchrZz9I8ahnbjaGsDe
         DWx8SfbHgmaBAyfiEfYZB6YRRB041fcCTey4txWBehYKWs6NoZ0xtVdcQHhIsp8Fqi4q
         cbDy9SMXEP8ejacWZJI/Hww1iYPwpj3bqLcs2jJH3X5pbW0Y2CY+kM7IZETMuwMacoL7
         tDzQ==
X-Forwarded-Encrypted: i=1; AFNElJ84StlB81MEQ9pnxIfFwRD1+tJIvFYVXIxRI95xi9WZUtSIR+U25XHXx7zP5D9vPZbE4DnU+3Mj/A==@kvack.org
X-Gm-Message-State: AOJu0Yzox5Mxsu3dLnuYT0K+Y/eeHWh0Hk/Uv7wjv9LpFFREM3r6CqWJ
	hRrlwV+ONT+//zKx1Lng0W3iUCqLrV5Vz/7MnwWDybarSkVtQNTL3ukr043p06mIhoDhQ0oEP+A
	07SGkHc50TSEJuyfzOiK5YnNoF2XVtTxCgNl7IFi06N6kJeKJlzfz
X-Gm-Gg: Acq92OFOERuu/ub4kCFDE6QgBg3vP+6WjcmaMagVUtbAmQzylEVLQQmgwnphNaJ9yUf
	p75qilqhmH7DXqWSXN/s4VJXmkcklBRmQV+yDSF6DOErwUvdsYItCh20vX5VmnIIdKxnE+N4tFK
	JTXZ0pfxQatesmPEoSuIIllsYzMXXfIdqV19LAPf+ZIfkbybeB11HCwvzt+MHT/iMaF8ENXN58P
	zRl2plwg0ljBmzXyRliw5ohMrdDi+9wykCO1xghu0yvhkIBoqSafZX1mMXi92Nxe0md2cg9ft4W
	WvVXXoFy3HDHC5+9p1O6ludGnW0mjnGJVDTfTMFdBAC6yYyoaTwjTL4ctYAWzBHy+TgBz7xGtCA
	Go2R2xny/3TKfyDBCCL1S+tMPMKZE+14nZ49baiRT
X-Received: by 2002:a05:600c:34c8:b0:486:fd5c:2b35 with SMTP id 5b1f17b1804b1-48e51f2f85emr427543985e9.13.1778512177755;
        Mon, 11 May 2026 08:09:37 -0700 (PDT)
X-Received: by 2002:a05:600c:34c8:b0:486:fd5c:2b35 with SMTP id 5b1f17b1804b1-48e51f2f85emr427543085e9.13.1778512177160;
        Mon, 11 May 2026 08:09:37 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e702e0bf2sm334546605e9.4.2026.05.11.08.09.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 08:09:36 -0700 (PDT)
Date: Mon, 11 May 2026 11:09:31 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>
Subject: Re: [PATCH resend v6 01/30] mm: move vma_alloc_folio_noprof to
 page_alloc.c
Message-ID: <20260511110719-mutt-send-email-mst@kernel.org>
References: <cover.1778489843.git.mst@redhat.com>
 <a26c5850219e349f8a666282aa8003a82a4819b8.1778489843.git.mst@redhat.com>
 <agHsFsEIU8b9RiJr@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <agHsFsEIU8b9RiJr@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8jHTaMJiapoNsAhI5PRA7a0RC1bd71-JWt9HDJ8Jv_k_1778512178
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: m1kxho9uhpzbbzt3ec5dy1oposwwhwxw
X-Rspam-User: 
X-Rspamd-Queue-Id: 8404BA0007
X-Rspamd-Server: rspam07
X-HE-Tag: 1778512182-662463
X-HE-Meta: U2FsdGVkX19iD26HWoqlMXyINcePeTk6FaMEFywVthmdvGlhwZDXIQ3AvVtBwc5OCY56rJP/EL78+BINseDvKFyhuZVzuVfEINB4bjk/k8XiHio2WQhugW2MIFkzKK00gOEhveBeolw4SFev4SYsE6VeINmkwO4SfhEqt+LtsAuQ5ujBXUXSE2U/5icLNLPd4Nbk6wpd3GW7T8E81SKuxDW2CjTgoxll6xMWphRD52Npp+Wz96UqlbmpuBxgWin7m8jPvJN3MwBuFfGeOM866mEyWiGGp1+HimF1hN6nHpS7Hr8BeqYEBOGhUB16imcMmx/Xi8K3U5piyhd5cAo4LQ2odTr9hY73Bm49zIJ3Z7o45FyS+f28yXOUcS8mRXjXf80JkHr/kL8OfFTPU6n+9HpCJ9vHPD6IwD+wdK9Pr9kXEB/GraajNJeYtD1jKv9YV7Km2e6n5eTUSr8vYARmqn92glEDmAs3V+6fB28kruLe3saMtOigbq3JNq3CjfuR/sd/l4LWDrm+YWCFMX4Io6DGm9S4XcWNguBUNhihqE5R9/pdxxEftti9X+aSbwqPTClxguxH4izArFWK7Ye+zVDjp1u+dariXpGGw6lDCGvXxLxT0RQb1Kox7pnNwXeBL5NZguXveH71tqrEVUdxqq1a1ooFvG3zbJb/bdjJuZgdHL0aEmmhUCTXdAUhBx32WIvtvw3+SQXHqVX+HpBmtkYdGzFfJeVvY7aPMfTvOmKdqoZT7yLvN2pcNgvNbV+VAKxXneFfMpmyIc92GAbQJgLBBRJ3avxeQE30TXi42jA7FLLbmYyTqsN4AavuweLQ5e5JIdxA41THVoPeUNvCadkC4A88f3EpRjPHoJgkP7xOJK9MqrI7h+EL6sh7rHVkpw0N5JAH1ww66bLjTyYkJEtUEqWGGEk6xnxvlIrPzpXFbW9JoB1ICpQqsjpGIBoTuJ98HTvF1ESTG3DImWZ
 IZW+uRgM
 Yai589AF2V7de7FYUA+wSR0mEnoeHtNqPPcunkK0eJsCwyCffGgNYyOXopS65x9pJLNmayF8csHrDdJIWCZMYNYRBCsB9lZKY3KaGLVy23LZfmKd5uXO9ZGIwq5wmdltRz6xcdwiCkAMr+BSURwVbcT+JtTUBF11y/G5VC9SkaYCy2bqSKN2WcSsyJYh9k879q3lwMlwBTmlimNeBjXI7TKI8PDyEo3EdZ+nHDIChk93ktU1vmsUfQsP8FZnZTEm1+EaW3C8vyKZluOMKSMP44t1/SEdnXA3BI5+dzBIrR3P2GcY4VHbi+U0XNIzo+ug2n2OukWNCqe7PrC9/hpfcjrHcMYH9j9UmuyF2T7h2jrXEsBCaYta6vP+3ISik1RAHS73HB6JHv9X0zP0Z9T/d05lvWFCdSU1jp347
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 10:47:50AM -0400, Gregory Price wrote:
> On Mon, May 11, 2026 at 05:01:44AM -0400, Michael S. Tsirkin wrote:
> > +#ifdef CONFIG_NUMA
> > +/**
> > + * vma_alloc_folio - Allocate a folio for a VMA.
> > + * @gfp: GFP flags.
> > + * @order: Order of the folio.
> > + * @vma: Pointer to VMA.
> > + * @addr: Virtual address of the allocation.  Must be inside @vma.
> > + *
> > + * Allocate a folio for a specific address in @vma, using the appropriate
> > + * NUMA policy.  The caller must hold the mmap_lock of the mm_struct of the
> > + * VMA to prevent it from going away.  Should be used for all allocations
> > + * for folios that will be mapped into user space, excepting hugetlbfs, and
> > + * excepting where direct use of folio_alloc_mpol() is more appropriate.
> > + *
> > + * Return: The folio on success or NULL if allocation fails.
> > + */
> > +struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
> > +		struct vm_area_struct *vma, unsigned long addr)
> > +{
> > +	struct mempolicy *pol;
> > +	pgoff_t ilx;
> > +	struct folio *folio;
> > +
> > +	if (vma->vm_flags & VM_DROPPABLE)
> > +		gfp |= __GFP_NOWARN;
> > +
> > +	pol = get_vma_policy(vma, addr, order, &ilx);
> > +	folio = folio_alloc_mpol_noprof(gfp, order, pol, ilx, numa_node_id());
> > +	mpol_cond_put(pol);
> > +	return folio;
> > +}
> > +#else
> > +struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
> > +		struct vm_area_struct *vma, unsigned long addr)
> > +{
> > +	if (vma->vm_flags & VM_DROPPABLE)
> > +		gfp |= __GFP_NOWARN;
> > +
> > +	return folio_alloc_noprof(gfp, order);
> > +}
> > +#endif
> 
> Can this ifdef not reasonably be done in a header?

It can't :(
In patch 3 this will need to call __alloc_frozen_pages_noprof, and
that's in internal.h


> I know the old path relied on basically mempolicy.c being in/out of
> scope based on CONFIG_NUMA, but we should make an attempt at keeping
> page_alloc.c clean on this if possible.
> 
> ~Gregory


