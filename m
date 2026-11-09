Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 718B2606EEA8
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=nPMc6AfL
Received: by kanga.kvack.org (Postfix)
	id 820AD6B05BF; Mon,  9 Nov 2026 07:35:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F8D76B05C5; Mon,  9 Nov 2026 07:35:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E7EC6B05DD; Mon,  9 Nov 2026 07:35:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BC3B6B05BF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:35:06 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D00781C3FED
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:35:05 +0000 (UTC)
X-FDA: 85415525370.03.A80D25A
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf29.hostedemail.com (Postfix) with ESMTP id EFDAC120006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:35:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=nPMc6AfL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of smostafa@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=smostafa@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794227704;
	b=xv6FULWjlN3y3Pm6zDLx1WbxkHmLfgsA+4oauhyqOAn3t5lBtVkJ0Hp5d0E8vrEzc9dPI1
	o2pBlrzzRjsKDchTD3d+6wtcqJLtxdK19TUjnFwMS9FcZaFMsVc38kqOX0CgbY+Yu11wJ3
	ELEvCskLoadVMz7fe3Hj8w7r526xOTY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794227704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WvzMdwDlo09mKx56WkMYCYECEOAz6fHhPR97cKN4r+Y=;
	b=2LIAntbgDElbrhdhye9iZEVaAsqz+SaZSrZG6/FKCnCBD3/qLToD8DDRfIHgDCLTLqJ8b0
	Kszk/AAX8NbfUHeYeOly2n1395YjfgWgx1REcweRI7VsCffVquvz45QvBG5r1RxlNQDy3Y
	jpUL/JOBLA1z6cqnBR3vXrCQpdNDC48=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=nPMc6AfL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of smostafa@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=smostafa@google.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a018493d57so27255e9.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 04:35:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794227702; x=1794832502; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WvzMdwDlo09mKx56WkMYCYECEOAz6fHhPR97cKN4r+Y=;
        b=nPMc6AfLERAqT7tU3Bzpo46faawUOh9BT/2nV+4UA4Plz8yUlIMgO1Z8rDTLgmQ4j3
         i//PGUaFHdDWQiszJ5aQY2/MuOCpqpuovfjRWNyjLYvC8Joc9XUXzeKpiwalG4Tipk+d
         yg+pnijhL0h1hDc1p5hOQCP3vYbJ+tsFw7gZcrz03Q7b4NY0b4XjugmyJ+wdyNl74zMs
         zHfMI06C2j4FKmAZb6yGOKtED0UZbdKe4pgec097yM1YxRq+XfOo/SIAIhSjolPc7sCL
         NeUx3T1aYA/AmQxdkzbb27hxTOZwQjI3HYK28HCyK9tQWYFEAkl5EmceWH7sRBPvPaF4
         RuqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794227702; x=1794832502;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=WvzMdwDlo09mKx56WkMYCYECEOAz6fHhPR97cKN4r+Y=;
        b=koFRvjRWYWWP4ZKcEhN8xqL0zRgP0s6DjocHapdW9YpXhEHd4C2sBbaLIA/3xvOKBt
         +y7FpJ8OBnUX3evZDhzE2U3VUQ56oBuWRIiVjrNQDGl1CDc/Gr4zguXvGdlZson4Rlch
         9ZcRVIQYlkLJEq6RTENcEGM0Ff/40NjoH+FHWikEix3AwA2SkBz5zGkWmJMWrhdEZD4P
         xo/n1q+FlAhNty9jz59/lLOcbTVHSv1/CtVqa7GMlXq3FzGYKhzcen0uEcW0v1ZJ7Suf
         zRI3X1WwzaOfxbmJNQZRVYfOIPaYQ53yi8EJhODxs6lIFct/8RccaTHk+iM8L8mGnkW1
         AFhA==
X-Forwarded-Encrypted: i=1; AL+hErH8A9Xqx4KRXrZHSDhi9PpsSH4w5czacMI6z3a50++J8KQy1IGY92f08XGQAXUwgdlAfxWN72MXDw==@kvack.org
X-Gm-Message-State: APuU4Z/L85vMIxGbEk6/ohH4G1rIYn9mkY2LQJMYlhwNs1vgqq/BSBIX
	KP/uo/KZrXEmTGPemzn4Sva9ExR46RJwcGdqncT5D7yTIX/tmGCuSD+y2D1MzTUF0w==
X-Gm-Gg: AYBFou0c1o/mKHRW1JP4fKB3ogDig6GFB4kAcnOPyTebv9Jd1FQ0tRsqtkN0txqsl9a
	WJ//pDkpTJWhyMTeG59+imbPnZTs1+ypyTlwp0Zk817avz1XOMHy4VA8hkjZkXy4Ue8DLaXgjTu
	IRWiKxP25fxs+0s8/T95rA5wOFs3ckhqEzocvFWTcL/L1PIBnXC+20ktImStA2G1Z/TFTzJKIhB
	iZCCf645U7YCKwHkEjiI1ognNLUIGPONt9a8q1TRVvxvVp8YZx2juWWmx5MUalyOCmnOFVK+hk5
	yElxIPJzVMBV2bEDeXMjDajZc4se6zeVjMM8HsZvcFbvVi/EOlxAa8z0/lTkpq2WC8P90GA31wS
	wGvrd1sjY9Z+SW4bv7i7KzkE7b1NceQ7XCknZRI+LnD2NGga69fyap3OhRXJRZOsC8XEPb4/S6/
	SJXEfvDaG3S9lP9X4sl1KmRJ2lRd1yDlsNkH97ef7peae4Nv3k3sWvrG4THtxPSFI1bgDf+QnzJ
	k72smxrmXPaOjP0Di2JNy1WPo3fXRAG631w+QnyO+U1gGAwTsRAFaE0/c0NVbJFq+IGWvh+mnFW
	+MKwnB8h9SP2ctURBCJ6Sotofy3mWP5o+rc/Uf+2RyBKmEdg3VpVSMFLVhmfYU05XfF8ug==
X-Received: by 2002:a05:600c:528f:b0:4b6:5035:d54a with SMTP id 5b1f17b1804b1-4b8aec15d44mr2319705e9.1.1794227701554;
        Mon, 09 Nov 2026 04:35:01 -0800 (PST)
Received: from google.com (160.193.189.35.bc.googleusercontent.com. [35.189.193.160])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49597186ec5sm10010991f8f.33.2026.11.09.04.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 04:34:59 -0800 (PST)
Date: Mon, 9 Nov 2026 12:34:54 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Pranjal Shrivastava <praan@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Daniel Mentz <danielmentz@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Logan Odell <loganodell@google.com>, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] iommupt: Introduce IO page table shrinker
Message-ID: <avG97sxE2NFZFtvE@google.com>
References: <20261001230219.818128-1-praan@google.com>
 <20261002150844.GC3481470@ziepe.ca>
 <asMuigioXmHZmjO2@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <asMuigioXmHZmjO2@google.com>
X-Rspamd-Queue-Id: EFDAC120006
X-Rspamd-Server: rspam12
X-Stat-Signature: 3jqjzcbq3nni5f5en8t7jtiot6wyospb
X-Rspam-User:
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794227703-566283
X-HE-Meta: U2FsdGVkX19o6m6jGqQznF65ReEG/xNNCrNye3gkDevDGnJPkZ2u7EA5Ccxn5BfGXZG24NCyGj+sk2P47HyiiAR8qBo2WZ1/W1cbaVGwOGNSNLwdNFaNO5ZUVLHxlfh2aUbWVn2TpYm9WVZZQhPAQZ7vR39aX8I5hi6sg/TDDRi5iTEGeKSqvR5YHsveEclsOFZVFXj/F+y5Q94ZtLb67X64YGlnX+CRriBheuyEVLjUIKMV2tB4CwxBnDvHQXYLUbFSiqp/5fqV/B6kW+B8WTbetPzr2HB8dvfaUz98YqxrUMwvloGVkJq+zqbUBRVnLUROPytAII/bbx+REMRcBysmBtWG7nUiDC4p5hWgNH687Vhqev/NTfGQq1gxWIFL2G6GBTImnFGccM+j0yeLCYGZZBo0X0n8rR20sten2ucEqjR+ErzbA0hKGTM+jpYWfC2cGJhN9xUdG4JjTDhdppoZZOb8ROsAuDk1pn2RWBjiilb4m9t0S60m4OuL6qHWk/av/kH7yzoLEnUusGW9FJ1jzR1qDQ4gLU6rKtGBvwR8lFS7Q4EJNg/Jy+q5noKikOjOXNBBJ9dad2YCkOvOWtD8LDnmTGYGjsHb2nCInbzqQzdRhxHtl63Z7xC4qihPlbkfwhYGCJqL/N8Gf7l0RkLOI1dODrNvbh7e5/pHfkwzGl8VLxzQ/LMOdvcLSxOtvO0HxZg4OPGIOHzHJ+3uFLyp9D+sXCighvElTPhkT3y+KsjIsfkYQ0wF3xhZUu4atWt9lm9yAOtvnEe64YAc7g2jWY1aWQMKzNM+KyUcF0r+sBSVXq0ZOLN2Ofs/22OJlfd3UaH18m7NHvnUVOxpaDy6pLj7yvZp3ijArW7sxnzsJ5sMyVYzIHQhsDrCsHyqNoIFbntsIB6nqQ6+VsopulBWcPI9x+FwUnB2DRtaMepydwnV+xliVCIvlbUsKthhfx6Ed3K/sbY9v8qk6dS
 mnZ76Zua
 moVwhAdhYqO74ucEJKhKTXxXhk6CDWNGH4HOPESfTGRVbNIbkCKyJEnDEcDnzUhCtUJTNvlna9K0cnVnKgbyOar/ULb27H26rbJFpZprucBj9UbJtSVaTC4xpVt1pNHL0hvqJdtCPl7R4PPDvvAL2P0ihMC3DmdJ9icTlTr6CsVpLD1BrZ5ycw+HHsITy7zzNnyspjQsrwnETC/hZsykZYHoMrFwInppcWtDNjMZF0uipoTXH5VyTyt4KFuCjz+dcieydUoRibDk1crI/r189jt/xbFcjXVdB8dVi2FpcOSdjxKeLlMKZVrxvCfaw6Fs2U+Hnd7gjO1NuADSi34QPOi0GyP8afVELQkKmF86FZ2hTIw9tSDBwYCg/XQwvp8h9bq9eQCaIGR38fBKH6phPklsqEzOzEwQCGVOn61j8zgXiC61sK8XWzI3wEfjXNEta0JvKNNxGIOZbNeMjYXLt4bOxOrBjiiQdrdZXiQdIVOd/gWpyp6EACgj+Qg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 05, 2026 at 04:58:50AM +0000, Pranjal Shrivastava wrote:
> On Fri, Oct 02, 2026 at 12:08:44PM -0300, Jason Gunthorpe wrote:
> > On Thu, Oct 01, 2026 at 11:02:14PM +0000, Pranjal Shrivastava wrote:
> > > Introduce a lockless, deferred reclamation framework for IOMMU page tables
> > > built on the generic_pt library. As VMMs and userspace drivers map and
> > > unmap large, sparse IOVA regions through VFIO and iommufd, page table
> > > directories are often left allocated but completely empty. generic_pt
> > > frees a table when a single unmap covers it entirely, but tables that
> > > empty through a series of partial unmaps stay allocated until the domain
> > > is destroyed. Under memory pressure, this *stranded* memory cannot be
> > > reclaimed and has resulted in OOMs.
> > > 
> > > This series refcounts leaf directories natively in struct ioptdesc and
> > > registers a domain-aware MM shrinker that prunes empty directories under
> > > system memory pressure.
> > 
> > We had talked about doing it this way
> > 
> > But I had proposed a different, and possibly simpler, solution that
> > addresses *just* the iommufd use case.
> > 
> > After unmapping something have iommufd compute the gap in IOVA that
> > contains what was unmapped and then issue a 'clean(gap)' operation to
> > generic_pt.
> > 
> > This is the same operation as unmap, except we know now that the gap
> > has no PTEs so all it does is clean up the table pointers.
> > 
> > This requires no special refcounting or anything difficult beyond
> > some locking in iommufd to hold the gap stable while we clean it.
> > 
> > Would it work for you? It seems substantially simpler, but I never
> > tried to implement it.
> > 
> 
> I was tempted to use the interval trees too, but I started thinking
> about:
> 
> a) Locking: For the gap to stay stable while we clean it, we'd need to
> add some kind of serialization either through iova_rwsem or a dedicated
> gap_lock to prevent a concurrent map to allocate IOVA from that gap. 
> Thus, every unmap pays for clean under the lock. I haven't perf-ed it 
> yet, but I'm not sure whether users/Guests using virtio-iommu, where any 
> guest DMA unmap becomes an unmap on the host, would regress.
> 
> b) Other users of IOMMU API (unmanaged domain) like the type 1 (which
> was the one hurting our systems) and other in-tree drivers that use an
> unmanaged domain and call iommu_map()/iommu_unmap() with their own IOVA
> allocator. One of the goals was to avoid enabling the user-space or
> in-kernel IOVA allocation (ab)users to cause OOMs via IOPT allocation.
> 
> > An alternative version is closer to what you have here, somehow
> > connect iommufd to the shrinker and have it lock and walk the gaps
> > cleaning them on shrink requests?
> > 
> 
> I like this one better than cleaning on every unmap, since it keeps
> the cost off the map/unmap path and only does work under memory
> pressure. Although, it doesn't help type1 or the in-tree iommu_map()
> users.
> 
> Would you consider those users worth covering, or would you rather
> they track their own holes and call clean() themselves? Happy to dig
> into this at the LPC session too.

I believe there is a value in supporting other users beyond IOMMUFD/VFIO
(eg. DMA domains) or even outside of iommupt, I haven't investigated this,
but it's worth looking into either integrating the "iommupt clean(gap)"
idea in the IOVA allocator or more generally rely on refcounting +
shrinker (or other method).
That’s probably a lot of investigation, so I am happy to help if needed in
looking into any approach.

Thanks,
Mostafa

> 
> Thanks,
> Praan

