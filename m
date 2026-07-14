Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 752C8C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 12:25:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 620466B00AA; Tue, 14 Jul 2026 08:25:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F75C6B00AB; Tue, 14 Jul 2026 08:25:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 535636B00AC; Tue, 14 Jul 2026 08:25:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2174E6B00AA
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:25:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 99A27C0335
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:25:01 +0000 (UTC)
X-FDA: 84987301602.10.356AF4C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1484480009
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:24:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uk8LCrfd;
	spf=pass (imf02.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784031900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ncHjbQ9ufoT6SdeAfwRC2oHP5TMeYh9A0isrkQOo65c=;
	b=g5NFFTktCFQE0H3JtLcdSgaPuwJ75gjL7eYjTuQWSz78qZsgD0xiXS5xmwqu86DLa+YPQJ
	BgEboM+Ob50EBc9NqV+DwehYu3wWAeiJEboTNG8nbhP8efMItI346tVZaY5g/+meTBLkJT
	QxKMsVgYmt4mKoSFNaHwP+xJiUISDeE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uk8LCrfd;
	spf=pass (imf02.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784031900;
	b=mgaGmt4nzs6tCubRZ55gH9pbAzZ/oVWUwhcQFk+kX0adQzJA9RHMPJfknxovrPq8n+9KKo
	f8jSOw9dXgNxLowBRyEXXxqvIdYN06yl4FVA6yGreJbKtUw2bw5b4tKr+lGN2xNOmZqvCD
	MSHxticFWViXnFIqIYh3cLKnLZvvmUE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 959E760120;
	Tue, 14 Jul 2026 12:24:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB38A1F00A3A;
	Tue, 14 Jul 2026 12:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784031899;
	bh=ncHjbQ9ufoT6SdeAfwRC2oHP5TMeYh9A0isrkQOo65c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Uk8LCrfdl+bpQBeTpDRh0oc+8+a48aSIelbqzRi4zcYvWLX8sL8PxBp5hbaMZ0N9Y
	 nVwiwe5noR2fo5n8OoliuzsH7AN/eZRgcnZMxx4vJk4UrEIUqUa6k2idnbK9QgHqXj
	 MvcdH/lQE7Be/UpQwxNPD6F6RDv4kQpNEWdShdefAKU7jb+xKA44rV4fWKT8iKCIpd
	 oYq5git6zMaT/Ydsw25+f41mpCLw8kebEFGA22uBE3LXWKxb4zzlWHCYg2aA4NMASc
	 6KhnkAFxAiN3+HQ57h5wBLKt+VIJv0+/x3+ocfej2PJIAOaCgDGi2/izTJw36B81t0
	 qYENoTSEHp4mg==
Date: Tue, 14 Jul 2026 15:24:56 +0300
From: Leon Romanovsky <leon@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2 0/5] RDMA, IB: replace __get_free_pages() with
 kmalloc()
Message-ID: <20260714122456.GD19233@unreal>
References: <20260713-b4-rdma-v2-0-65d2a1a5180c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713-b4-rdma-v2-0-65d2a1a5180c@kernel.org>
X-Stat-Signature: dt7dkzno4tkf5b9emq9wen8ekcq8869j
X-Rspamd-Queue-Id: 1484480009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784031899-611803
X-HE-Meta: U2FsdGVkX1+1b5g+KwzB0RHX8ipjJLQgoi00FackawmZPqB3mEk5WQJMrleJgkRGXCQy9DwpgSpe2lSDFHmzZ6J9oe60Cdi1PtpSrEQT55SdJH3GPPjFoI4inKAbXduSpufmBBdEclp2B7KxLY7tAK1rJytVHu9nWP9YI3tVvPm174egTXFO4gXXToGXlws98PIi01PmeRsgR7qm7ZmXZCbeNfYitfskM2DW0NH9G/Qn2PTcFHJFkgQ5OoH0qCsRSKvZyFL4cnG4wtWP0BXfTtWVba/9FryNtMWMMqljf54PbJgOwlPnkyY26xt45rPehzpioqgHmv8V60e97hUaa15T7JNqzTLATPEcHNN0Ga8kafiHqKWswo+XBplhcAzC9HjMEEsLtQkFsuU1Aa0hXILpCXlA695F9mfbrDz3kEVNB1CVpVkz9cRwirOMg9E2fcs2LN1mqJjQe/8ZbBDuEWFsny5MQokGgXdFluuGuZ4cfrmTF22PIUZW6nJjAbw2634al2fnbtJVGhuLJwkafciCDfnMNtycweEYk9VdJAsxBSnZjmJ4bkhm2IL5lipTPuikjx98afnzCJ4+eCT6gw45tLpN96SY54hBLGJZhNvc+VzKoWkY6w0e3QHFeFU7BWshdX9uJgTxivLk1SllMw0sT8TS4Jt9fQypZJ050rUUD45HSeDnNJy7ce6AxSXYJdjW6behBjoewKXhdFKoSFF1K888errkkYkw6hCxivZ2Hr3s7dG32auk8qwoR9ix7rbhM+EOQ1DrsNK09cRkSSqY+gRFNLYr+zEDwfsZ0jyJPqXDZHuJAWeq8H+4zD/9EljUaWafLxIcuFHbP8p6YDndhUvxwtrQRbhqvW9TnEYkKbE7k63GkNhVEWWkiwI65sxHHBgAZqdijNLa0x6KgirklEh/oax3AIwLnxTEgY+ZS/kHNPIO8A7c2lhL4tYyyvX0NNfFnKzMlDR0MlJ
 CbU7u6MR
 z9HUyKHU/1h/5asryTR+xFdIeBpDZ6W1LXXncTUNuWO2BXzGcFcIhWHLa4D3ikV9Ju6ypSj0x+1aVHFUz3GLx/YJYCLX1O3H4WsrjIB3xGs/fteZ2TfvnbhJ1DPscrKwp/7Dh63SwyZ4oZn1pl4uuB1NK/SLYj8JyTaNLfT60Ypgug13d+Mak4BMjQ9Ez63DVrQYUWAjkMdvOopqpfjqw8X542NOqs9nc4CafO5hUjWscoo/Gpb/hIdVzGMVzAlwS4ZncZ5lllrO8S/I+GCOJtNid7GLHG25cuEkj95yt4nX2rLzxO1FUqeGI8lJHUYpyBcOSjPXINo/znLJ3lPksezvfsAegdJIqX5N9G6LOG2W6FAngzN/gkELPgUy3c5HBcB6fabryE2RV6J5uu5M/ncMhS+amHoF7jiwGAiAoCV/O83s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 10:17:21AM +0300, Mike Rapoport (Microsoft) wrote:
> This is a (small) part of larger work of replacing page allocator calls
> with kmalloc.
> 
> My initial intention a few month ago was to remove ugly casts [1], but then
> willy pointed out that Linus objected to something like this [2] and it
> looks like more than a decade old technical debt.
> 
> Largely, anything that doesn't need struct page (or a memdesc in the
> future) should just use kmalloc() or kvmalloc() to allocate memory.
> kmalloc() guarantees alignment, physical contiguity and working
> virt_to_phys() and beside nicer API that returns void * on alloc and
> doesn't require to know the allocation size on free, kmalloc() provides
> better debugging capabilities than page allocator.
> 
> Another thing is that touching these allocation sites gives the reviewers
> opportunity to see if a PAGE_SIZE buffer is actually needed or maybe
> another size is appropriate.
> 
> For larger allocations that don't need physically contiguous memory
> kvmalloc() can be a better option that __get_free_pages() because under
> memory pressure it's is easier to allocate several order-0 pages than a
> physically contiguous chunk with the same number of pages.
> 
> And last, but not least, removing needless calls to page allocator should
> help with memdesc (aka project folio) conversion. There will be way less
> places to audit to see if the user was actually using struct page.
> 
> Also in git:
> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/rdma

Will you also change get_zeroed_page() in RDMA, or should I
prepare a patch?

Thanks

> 
> [1] https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/
> [2] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/ 
> 
> ---
> v2 changes:
> * add comment to keep markers for sites that need "fast and as large as
>   possible" allocation helper
> 
> v1: https://patch.msgid.link/20260630-b4-rdma-v1-0-ab42bcf0de92@kernel.org
> 
> ---
> Mike Rapoport (Microsoft) (5):
>       RDMA/umem: ib_umem_get(): use kmalloc() to allocate page array
>       RDMA/mlx5: replace __get_free_page() with kmalloc()
>       IB/mthca: mthca_reg_user_mr(): use kmalloc() to allocate addresses array
>       IB/mthca: allocate mthca_array memory with kzalloc()
>       IB/rdmavt: use kzalloc() to allocate QPN-map pages
> 
>  drivers/infiniband/core/umem.c                | 5 +++--
>  drivers/infiniband/hw/mlx5/odp.c              | 6 ++++--
>  drivers/infiniband/hw/mthca/mthca_allocator.c | 6 +++---
>  drivers/infiniband/hw/mthca/mthca_provider.c  | 5 +++--
>  drivers/infiniband/sw/rdmavt/qp.c             | 8 ++++----
>  5 files changed, 17 insertions(+), 13 deletions(-)
> ---
> base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
> change-id: 20260610-b4-rdma-44625922fe16
> 
> --
> Sincerely yours,
> Mike.
> 

