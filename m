Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7361360A2603
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 20:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=CTncYhve
Received: by kanga.kvack.org (Postfix)
	id 8CC8A6B0BEF; Fri, 23 Oct 2026 16:23:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87DA36B0BF0; Fri, 23 Oct 2026 16:23:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 720756B0BF1; Fri, 23 Oct 2026 16:23:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 370776B0BEF
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 16:23:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BC68DA0242
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 20:23:18 +0000 (UTC)
X-FDA: 85355015676.13.725CD58
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf31.hostedemail.com (Postfix) with ESMTP id 62C2C20005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 20:23:17 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CTncYhve;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of lrizzo@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=lrizzo@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792786996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eVhNp0GGNRD3+5V43/lt1UQnV2SdTxNQyX5GFb3QiFw=;
	b=KnsPmUMkINycE/qfOTRcvOhIVbe8tGKBQez6X78GZtkW+H9IqWB3sVa4Nwmx2v97x/Stud
	Uzcuvg7pOgEWJ3cCSaoV0S/GcyuPai9G0LjGHAy0KrmYI/aJst4NVyb8rd/LYg1EZV2WDq
	8YVhcNLoGIyk/nLasZTKvP4+I5h4prw=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CTncYhve;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of lrizzo@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=lrizzo@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792786996;
	b=Co/Lf1QA4V/6bbiwKjKxw4FcBHdwpmObLnO6H9EzA8+Fr//Sq1AWB0z/bEvz2bfbX69gli
	GTk7K1tc3OgrLo+CJF1QqYo5mOYFb9YEMyUicmfOCNPFoHqlle+nncLEEXFcoqauFNXNPO
	oebn215VjExHOrw3MbHNYLcWjjKcCiM=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2db33db4de9so14365ad.0
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:23:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792786996; cv=none;
        d=google.com; s=arc-20260327;
        b=oDDktDY9Xmw2acahZ95xxLvcr8LrUkcK2gPyRDBNlQUfACoi9invIh5lB6lm18n8hc
         Hci+rZFv0RKmMwsfG6Sml6IQ+AiILODio30GxpyandSy2tEuB9sHRxdpo+AfWTepAtgU
         El6yeOkvS69rmST7hxHzn2Z7BEHW2Baqf3iX4nopOGLHguaWA0X8dfSem2f1VWA3eZC7
         5PNUHhj75PPsoDu87GLHSGTPgHAREAsdwTv2dnHP6BMVt9mocJvsCJJFQg5uODPNCSjB
         zq8R6tYMzUxld5sQsT4XLSef1ylptIvWLVu4Dw23qdZWz5n+YFnW5GA+PDhJSzRiA5Bb
         STqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eVhNp0GGNRD3+5V43/lt1UQnV2SdTxNQyX5GFb3QiFw=;
        fh=YxfOI/qv8nGrKAqxPWe0EqY5IyhSM1c+d2o6eTLy9cY=;
        b=lzjSuqNtK5c6NKt0pkHVDvuZ/oRK8qhSbyUeD78EhizMzhBcbAf/+rNt3LL11C+SzL
         F93MB6H69pn/mXp/HxMozT9ztlmUBPNCwy+xdCElxKQ98yNJLE/3tOlmgNDNBNwheg4t
         PYm5/2YLWSVw9/7AZgpgkOE57/anNwYkriLOZHM6qHPn3NCdfDMu7V/oefjnxjMfe6Pv
         MdOhzoNfMREf2oTSFYQziJLFbrzUJw2Mud5YAJEukVBpnWsS0Q3fpiZC/8tYv30/Vfhr
         0cXo1iV/Zwfh8UWTpvGkY6FU3mJONAdAFE04PJTw14ChmAmExACYYQnN1gAnVs1PhVko
         6AXQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792786996; x=1793391796; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eVhNp0GGNRD3+5V43/lt1UQnV2SdTxNQyX5GFb3QiFw=;
        b=CTncYhveYgncfe72BuamuW90AHaLUGS4bNBBjJqAGcOKRXSb4XNDFkGDgefE6GWQEH
         1XpmP2Ia5TtTWz78TFDHzAHmpvsYdcduPmxmE6gGF3fxl5ua3eB7L/ZeTKHPbEBiOo+d
         HQGJ2UD+Hi5eR8NNvrZSh70yRIGM6pY0/a5hUNOnI0d1Hp0RUk8+3Mf9wEvMgjRViSVD
         lH00OBdo/INoLerBMKO23Bzz5Pda4oyVAomFGyAAd9mQNmq80S+IET4Dop/LC66kFnE1
         Nj1hzO/kuQd7lqhvE5Khadz9H7ZD7rAZPt1Gcf/hRmEKyHAhf5qI2y13PdT88itw+S2T
         rNfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792786996; x=1793391796;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eVhNp0GGNRD3+5V43/lt1UQnV2SdTxNQyX5GFb3QiFw=;
        b=mU1VHTb6swPnrUOk32/vMDHdGc1pq2byKJT07+ZpQYVC5HozsgjMZfhlAI2b7/3eXT
         FiR4gCL8+BRV38y2M6bJUoNLylDJWXF/abmoM3harB1WC3Sb8m3oTYyxzR9X4N2ZliRe
         rqaXfHk9tMoVCT3KFZsQ5I7JW8KW4E1B1sYGBb0PxuogxzSnE3rnu/xBh+svgB5zjX5C
         2IElLByaOMpDt9zMmhCS9o3OSyblJM+1RUHqfM73ZocRnLIsBQtdd0m00wKAnPs73jKg
         3x6GP+/aeQsFYeoo9YJv4jXzjLQM8cqfeMChV9PekvHRZYCek0UV5WZ+DBXUOkzyBVYV
         K3+g==
X-Forwarded-Encrypted: i=1; AKwUvBxRLpcSK995ukZmH2PZE6omw+/93/A1fCIBUknkCKUgkZF55SLGFrgem5ahKR/OQlzg2ffAIC6jEQ==@kvack.org
X-Gm-Message-State: AFq9FYJfWE1D8Q2vOFLz8Ir+eYpHLli/IjM1vjj7mjngCVFWgg07R1JI
	p2HAFgEKKwN8g4r2JF+fAut1ud1RLhwsEMrXo1fNuhO23azBLvW6hoU5tYMp4XKiMjQyH0K65TX
	ZsxWfloq3nDtsSXF2JGOuXNcjwRQEFiVd+POxgI2a
X-Gm-Gg: AYBFou1nz75KLVLXHPCoPtgua8J0pYv+r9HvIpdk7pUzZIT9BiyBISglUCkn6NATGuV
	4Nqq2uvGNRaeah0hWGu1DpWV8k8XS2MayxWjaRR+jwaIT4U08naS0KPFtmsN+EUgDIhH1Bkcb7+
	mcaMCofUEJtg1SseTJTWeqIWDq2l5pEZIrZFc/nnjxNQ048SSLJ2JfgviULWMp8IjutgBp5Q8Eh
	HQ509EtLLfMJ3YMZ/nYUKkZOxvx1HRQsaDtefe0fYZQcirhy8uNk9gQalK2ECHP1IOZMtil/5wb
	W3OJxO10BtZejlB1Sv/E+l6KkKWBaGjCVUC1vYwOP44tvoJ1LCFZFeTr0DM2F6wWul9zd+gfsQG
	LD25iw4v6Vot1q5aJmEsdF3iix20WBR8hoCKk4A==
X-Received: by 2002:a17:903:3c6f:b0:2e5:4604:c37a with SMTP id
 d9443c01a7336-2ea9c34d519mr322665ad.18.1792786995276; Fri, 23 Oct 2026
 13:23:15 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com> <0cc1cac1-a500-489b-9c1b-b49598b5550b@kernel.org>
 <CAMOZA0JaiKsRgDdjHkL_N+MshhcyLSv+cT9SzEbNsC_sumHvOw@mail.gmail.com>
 <b31efcd5-149c-4edf-81a2-1744d363c390@kernel.org> <CAMOZA0+6kAbwgNwGTsCT5AqpwcZKz4pziEGC9UpHkNCVoqrF-Q@mail.gmail.com>
 <20261022201229.GH3381610@ziepe.ca> <CAMOZA0KaanmevmvWS=M3gKfBeborzfCQTiF_xbSeYMWbozG7Mg@mail.gmail.com>
 <20261023140107.GC3977851@ziepe.ca> <CAMOZA0J+MOLv+s4PAvsAK1jbasnbQRyHffZw1VEKutH9Vr6ODw@mail.gmail.com>
 <20261023145023.GH3977851@ziepe.ca> <20261023102756.201315d7@kernel.org>
In-Reply-To: <20261023102756.201315d7@kernel.org>
From: Luigi Rizzo <lrizzo@google.com>
Date: Fri, 23 Oct 2026 22:22:38 +0200
X-Gm-Features: AclHuK8d6JZsEGtM0KlZDv9ie7EsPXi4sNCVttMkACFig7Laogxgi1nYEIBjAsw
Message-ID: <CAMOZA0KZi1EkJaAFKfwOm8jo1ydyGh=W1RE0iMfte-ZQkOx9AA@mail.gmail.com>
Subject: Re: [RFC: DMA_PMD 00/22] DMA_PMD: PMD_SIZE-backed IO buffer pools
To: Jakub Kicinski <kuba@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, "David Hildenbrand (Arm)" <david@kernel.org>, Luigi Rizzo <rizzo.unipi@gmail.com>, 
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, 
	Tony Nguyen <anthony.l.nguyen@intel.com>, Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
	Alexander Lobakin <aleksander.lobakin@intel.com>, Michael Chan <michael.chan@broadcom.com>, 
	Pavan Chebbi <pavan.chebbi@broadcom.com>, iommu@lists.linux.dev, netdev@vger.kernel.org, 
	linux-mm@kvack.org, driver-core@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 62C2C20005
X-Stat-Signature: np8rwng4prhxpwkk7ycp1rnx5nj6ae4h
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792786997-140579
X-HE-Meta: U2FsdGVkX18Jra2S4rPQpGfUN964qLuHMk8BEa3/AgHHGvnCp0ijzqQPt/PnVju18Xxe3ULXnbrl9szNW1io/HX68glq1+efUaJDrVaoH3hgx7V7gAwp/dEsN4O5nSgVCp2KcA0WFgMebCqeKy0kx8AlzvIiWBMVgzqaipvoUuY5s0llXc51ntGpTnJts0BdCKryFrmeg1/b1QIvNQQLLtCkQ5GopkQXEAQF6RjAsJc5loPzPlolUJmm+mtaU2wJoUYEtlmgKalmwmHFd0DtuSReZyxytH68u5xRZQ3C3hJg7Dcnt/af2Gl3FjCbqdfE+Jk8CfpJU2gSyldAPQxB3XS5LrIl6IFd021Z3rpS4NrOusKAoJq7P2BJp2QQkmGRVUIxkJH63qALkrGpzg9jbWYvqChW8bKOqJDpGPtjPECcGDiX5KJvDga4H9QwgQtEAYLGVaMV4Krg/Gs5dZPvHWeXHbE81Fjn3QSIrj4JZzY7PzAQbjaYr3r2w67X3pVpcThTb2ujlOl+VPPOE4ENqdSsqMkdjuhb5hGxy9/GvsvBeb2Gykxskb1VnlKbw9VslzkENIBem2Pk0aNp/uKS6nMIxt+rv1bGgBGRmvniYgkbsm6gj7yyTNPLP8+BjMJ2x0ImGpVTa8uEo2jzWFhbJxXwldzL4GUuQ/N3qTf9kTYtqnCsaxZo+Xkk98d1T0Ye9G/u6FzbIoAxSgyVWetvrHPVOEoj4pDMZzG7tv6sKR4Xza6mfPshJA5y5DMDsHgZVm9p8E5tY/2tKXn5+kHqQ7d1QPfWHSmcdFPv5DEueOeGtwXvvJ2qvXmMVivTpuuGd8HZSCZhpWz74/n9d5b1IOPRi8hhAstblSEIzUL0n4R5eqgdseyBmvi4nELH7v/PmmoFNRaq+ji0GUTNVzJyi9esFx7nSvuhAV6OFZBGgh9B6qg9YNMFQZbxu9CllEuhiMvQ2p+1WeIPmt/KQkF
 KZguEYBp
 DAykPbNxv/kzW/QGNrRtVagGHeKZwxks5THDHwGpYhkxLec6HoN8yRWShvY7wEN9AxxKe2lrflMoo6J1CoMpa98Yui/Mdh/zySPJT6YJwkQvpuwr56wRZAsaMvbOKn0RaS/tt9zyzszEQ/wptqUXyDfmAm5Lu+Eg15feQOPqMu4zH8SjROUGS0P3iC3tdWespWnqk+rGjfHQh8IMZXOBYSC6kVb5zoAG4sQSIc36P48BR7EwsGcqpZ3ACHq5/BA3y/C0VGp1MYBujFJ8jf6LyX82q9WJVL7hKnaqWxMbVoVtk/RA3JuYHKCHg9ii1TgrbPTbPUnhryKYDNW6mqU0+ChZD4mtxcVtX244BL1aWEhJqr6s/w7ryllDcuvXe8SudVfPI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 7:27=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Fri, 23 Oct 2026 11:50:23 -0300 Jason Gunthorpe wrote:
> > > Anyways, reading your next comments, are you suggesting that all
> > > these functionalities should be implemented as pagepool extensions?
> > > (2MB mappings and iommu backing, proper allocator of fragments out of=
 larger
> > > pages, device-less pagepools, multi-domain mappings, pagepool
> > > as memory provider for skb heads, pagepool as memory provider for des=
criptor
> > > rings ?)
> >
> > netdev shouldn't be touching iommu, it can get a 2M page and map it
> > using the normal DMA API. AFAIK there is not such a big reason to need
> > any of these layering violations. They just make it easier on page
> > pool..
>
> FWIW we're entirely happy on the netdev side to add this to page pool.
> In fact the initial RFC I posted for "page pool memory providers"
> was addressing this exact use case. I didn't push it forward due
> to low time and suspicion that IOMMU folks would prefer a more generic
> solution. Since then memory providers were pushed forward and merged
> for dmabuf, and we have netlink APIs to configure things. So adding
> large mappings should be SMOC.

Maybe technicalities, maybe not...

Getting a 2MB contiguous and aligned page is only the first step, and
the easy one.

Next we need to split it into 4K fragments that can be recycled
without waiting for the entire 512 of them to be returned.
This is not rocket science, but requires much more state
that what fits in the struct page, so that's another layer that needs
to be added to quickly access the state from the pfn.
Essentially my dma_pmd_meta (because I could not/did not want to/ use
fields in struct page to access ).
Doing it in pagepool could reuse some fields in
struct page to point to the metadata and simplify the implementation,
but maybe leave people unhappy because now something may
require an extra indirection.

Then there is a question of resource management: when 512 fragments
come out of a much larger page, deciding which one to recycle matters a lot=
.
Without a strategy, there is a significant risk of stranding a
lot of lightly used 2M pages that cannot be returned because some
fragments are in use.
Again no rocket science but that takes some compromises (sorting
based on usage ? periodically drain old pages ? etc) between
effectiveness, code complexity and runtime cost.

And then of course adapting to zero or many devices...

cheers
luigi

