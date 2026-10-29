Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAD07606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 15:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KtNbvFH4
Received: by kanga.kvack.org (Postfix)
	id B68C86B05C5; Thu, 29 Oct 2026 11:39:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B19C66B05C8; Thu, 29 Oct 2026 11:39:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A083D6B05C9; Thu, 29 Oct 2026 11:39:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 608C36B05C5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:39:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BB2571A01F5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:39:12 +0000 (UTC)
X-FDA: 85376072544.27.4A1F135
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id D100FA0005
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:39:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KtNbvFH4;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793288350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+0yjXwf7zZ1/G1ToyAZvwzcg/8Wure4Qebgzn6jDw2o=;
	b=YYbzAYnpz51IrjjcDOGiUwcRyF16YWRNfttfd3GWq1cl37q3A7pifa49PCnvWPmbWaCWyy
	1dFLrKedausYWJYjlWCWAB56vFHJY6YdY2Cjhjl0X1OX2syII0RWRV5Oq7N2LRCjo4Rdw4
	AhoE/AkylZpKLXcnJrDGnqW7Zo5L20k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KtNbvFH4;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793288350;
	b=vProcTwR3IhQre8B3qUl5AVOtYkKl54uz/JdKb0kqGYubZ2jesIRUW2+JBbvUXjsJbLe3O
	5da2W1cFWTHcfo7r/ulNrbdXZv6sQVNYK9eQkeJRRy9YjPwDH8Z9oOcYd1H1FKbJdi7U0p
	yJrOl3hFspA5BX1IumTaEDLQwZkl+L0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C701600DA;
	Thu, 29 Oct 2026 15:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2BCC1F01824;
	Thu, 29 Oct 2026 15:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793288350;
	bh=+0yjXwf7zZ1/G1ToyAZvwzcg/8Wure4Qebgzn6jDw2o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KtNbvFH404X0mtuGoj7Vu5oAoA+/JglIBBuLwOsA38IKk/11U2UQxlO+VhuVDTvil
	 DwVIOuYSUE7qxQt2APGi69YO4D9H6gtXfM0vzIqiU4Mf2dXbPUJPpo5hjySjkuFCPc
	 /JuJy8ZSIFNcaS+Rs2K5yIGQ/9XytBXIb5MZ+JWgoxK/a4NGGquo8Fro5fEeGdBNuS
	 yn9dmocZDxQa93o9fgo4T2fcyY9s3j1iWVW/r+aifoWczxhfR3JSKM9qp/yUUIRKFs
	 ilLOQtctvujtimEXG9Y2hkfGqwOVgLfNOvrFuNYx+yUYb7xHy1tE+fpJbTmyTi0Uep
	 fAfrEPWbC8jGw==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.ams.internal (Postfix) with ESMTP id 8558C198003A;
	Thu, 29 Oct 2026 11:39:05 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 29 Oct 2026 11:39:07 -0400
X-ME-Sender: <xms:mWjjavqZF8ILa7GFmJFT86blR7k_DlTz9ED8h5mfEBaM3GSziIQipQ>
    <xme:mWjjaqHyR7KyUAAkhd_S_blWhizqPE63kya9v5qMVUQbFVLEGAh07sK1B4LdqGAaz
    WLKUsSfmJtwCm6ND2EriXZUffFBQBwkL2rlJUHuBrJJ9RRrtl4hagH3>
X-ME-Received: <xmr:mWjjaho4yavLEyDGhcv1z7Mg95mxcXyE4Quo-NP5luhgau8BXtLJ-Y3TWEI>
X-ME-Proxy-Cause: dmFkZTFNlLI1IxnysmwtxDbPBbt2dqnvQhYipohEcx8dPwIJIrBgAtFUMCeSCRLUn7u/FW
    UJHxDkt0ROnXfFadeQtiCMM/RXRAtrrQVUGl5N58b1fgZRYRaTyROC31lQTfeZ8KbXzn3o
    1iblUPv5lQsPi35OYZrwn0KFWjWElIqjIL9Q3FpGeATyjJJCw3m52D4TW5EsY55qwO5bwQ
    L4tJ3d6vs/G6neLrJOfICTE6JsI3AzVh2GvhCHK2ltNKIxcjHCQEoOcYmbZqhhQ3GkH72f
    H2adk7ABosF30oW/TTEpL65vQG5ZxGrmyE0nmd55Y2l6qH+ynwtzmGxyCXtI0WrAcjz3an
    Q4xGGzYI/IoTBk/VX9AsQAiiMVBH0c+EfrLUzzx/Abe3/LQ4nGf0hfBf94strHo2SHnGDv
    AlOBnZXY5b2Qu2gRP73I3htQpOZ1IxTQ1ycrS11vSBwv5A782pALFSZYBhGeMc8g1ZjJYc
    9Svn6Dgwjqs6YNAmffDusdRny6sr54vrgPHIWYQMEp8V8oHexi7SJCCaJTltC9F0v1LdLg
    EaTsM0e7JVAMdOyh+f+bkRx4yvtjD6InTFZvLkcgMVymvw6BwaPpheLKCEntVPvCbMop2J
    hPmtr+CHw4FXrXFxZrPj/8MyZLBO2+D9DxeCxvFuzbQQ9Zcsvl5khQqZbDLw
X-ME-Proxy: <xmx:mWjjag2WREewV6wSGyONMkVOEjaeWnca5tphcv-FngRdtmveuHhgzA>
    <xmx:mWjjaisKt4iSOJeJWqljwsoGFLdMnjx7vZlxan5So5qapDzh5jCqeA>
    <xmx:mWjjapH9fmjjz_dUmQsX_cShxLR_2BSYoF4NB_NvXOUlmeLOq_ZUsQ>
    <xmx:mWjjah0iUHxiDrcn1Cff4bYXPkduGpXLnqxdVbb_878uGhTIra3Leg>
    <xmx:mWjjajo7kks2AsRow9vTTyrBXgkIAA2JRqIYIl7zQ-Cl_CKIG0Q5mDQj>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 29 Oct 2026 11:39:04 -0400 (EDT)
Date: Thu, 29 Oct 2026 15:39:03 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/cma: accept memory of CMA areas reserved with
 memblock_reserve()
Message-ID: <auNoZgOgoFElHYUt@thinkstation>
References: <20261029-cma-multi-v1-0-2cbced8b5cb7@kernel.org>
 <auM6lKGAeUI26jCj@thinkstation>
 <auM-tYrdV4TJgJ6K@kernel.org>
 <auNE2XEGreHRKoPO@thinkstation>
 <auNgRT19droHmv3Y@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auNgRT19droHmv3Y@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D100FA0005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 4xpuey8ezkf47kbr5cfb84fc9oqsejoc
X-HE-Tag: 1793288350-731304
X-HE-Meta: U2FsdGVkX18dZb4+/sCwYpy7b4MlImJfPfRE4wG6aYdqjP5whBvmKOx3/EJm2PwoMhuYWkdVThBq3RiTmN/MkpxtCS1sjIq61HX9dck/G79chldWh4WQCfs7KvPzTpf1FiCcVLHfnq1zfmF1IdnX+eVdO9wQFiztySCbKvoHJu/SxqJOVwjuK1YEZcIHzfDrpCj3xj/eU2U0HRv0TVgrarppBHj5jLISgCe5QOwrSvlFevdrPCMv13U2keFPDAyuERq3P1yDwS3w9ffspCL1kdmaUCXnvq0ocU1GQ7KhmTKcEJxteAzEJdlHyrbu5kDaNhb82cvXI+592MIcf50B/Xr705vTFqQd8tKOGuh4U1vKOJsMzipc8xBChhl4w6xlP3zgvXY26/BF1yM6yZ0qcgkDqgulSmTHUKnd8W/aUX7TSIdpZ7PKuGno61mFrGo3suUJy6gW+DbJqOkZIxBWZisPt1jPCzH8/CgyOKr8JozvHZDbw8El1o32IYdClvcIB+giW0bSM/98qyu7szMBSW3scmdPBCSDFUOXXu0UU6jas/NaLB8hghk/6pn6IebtNwMqExjznAsmNSXEl9K8RRuLeltzXQhAS/Mh2FJCRp71/JBXaUKu22kZG8J0prxJdvINCs8WwCw8Jc0q+VR39UzQ5F9HBQv0A6anv/LoeJtf3wbDh1J1K4pRs6d7yT4kNHd94a2u1hgGmHw/GlwdXuDGnEo8oQktV7cPf4P+jABkAJrySBfthJLPmsIRLJqcAYGkrcggj9cq7qt5Y88DUavCYQG7J9pRbCzj7Du+dmK25zd5wl6mnw3li7PfepD00//gUULcRXe8AwotOM0DnHBuCUWy0F6CQOMeAVGbitwFCaGwwFhxsJGWeCKVGk8vKtXXOxqcb7dFVgxcpxdYrfPlrB0ewEzcnyXigENLFiCBqqyCb1czqu7NJMDfrGbmpvK6+YPRWpyEGzVlvY5
 0fAt8uvn
 ijhzR8tHSJ8YlXArNmMf/GdaMNWTr+wt2m6jme7UnXSM1FVupaBbGf803mLV6r1Gq89F6E9dVere0un+XIFJ98o7/GN9WxC9Jyk/Yq2D/H+P9uJrx/d2QuEsY2f8jzgXsurfy/kCClaRBqWF9LIDW1VtRG49FZ6A16M7ewy1au82sfYbBaPcqOK3H9LE0eYUONSpOl/AGuLL9c1WhEAC3vF4rsBoSX/TU1j0XSiX9O0TnK1MRqH40f39fJClyDiVDAbk8YEPON3pW9dJ+Ik6cwNCFStkyKHwV8l/mLAjzR08CrpP1u1Z8UAm5HPMBx2VzY/nQ7ThjIHTtBQtgsX2LZT6QSnIA2089Bp9I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 05:03:33PM +0200, Mike Rapoport wrote:
> On Thu, Oct 29, 2026 at 01:17:06PM +0000, Kiryl Shutsemau wrote:
> > On Thu, Oct 29, 2026 at 02:40:21PM +0200, Mike Rapoport wrote:
> > > On Thu, Oct 29, 2026 at 12:27:23PM +0000, Kiryl Shutsemau wrote:
> > > > On Thu, Oct 29, 2026 at 12:18:36PM +0200, Mike Rapoport (Microsoft) wrote:
> > > > > Pages of allocated CMA areas are released to the buddy allocator with
> > > > > __free_pages(), which does not check for unaccepted memory.
> > > > > 
> > > > > This usually works because memblock accepts the memory it allocates.
> > > > > 
> > > > > However, multi-range CMA areas, used by hugetlb_cma, and fixed CMA areas
> > > > > requested with cma=<size>@<base> are reserved with memblock_reserve() and
> > > > > their memory is never accepted.
> > > > 
> > > > It feels like memblock_reserve() abuse, no?
> > > > 
> > > > crashkernel=size@base already uses memblock_phys_alloc_range() for this.
> > > > Should the fixed and multi-range CMA paths go through the allocation API
> > > > as well.
> > > 
> > > Fixed path already has the range, why would it use allocation APIs?
> > 
> > Having the range doesn't make it a reservation. Both paths take free
> > memory for the kernel's use, which is an allocation, and an allocation
> > has to be accepted. memblock_reserve() is for memory that is already in
> > use: kernel image, initrd, firmware tables. Using it for allocations
> > leaves acceptance to every caller, and both CMA paths missed it.
> 
> memblock_reserve() predates any allocation APIs and it is used to say "I
> know this memory is free, I'm taking it". So memory acceptance should have
> take it into account.
> 
> > If memblock_phys_alloc_range() is the wrong tool, let's add a
> > memblock_*alloc*() helper that takes the exact range and does the reserve
> > plus memblock_prep_allocation(), the way memblock_alloc_hugetlb() finishes
> > its own search. There is no search, so the multi-range path doesn't get
> > slower, and accept_memory() stays inside memblock.
> 
> A new helper that does reserve and accept makes sense, but let's do it on
> top and also audit other callers of memblock_reserve().

Fair enough. Feel free to use for this patchset:

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

