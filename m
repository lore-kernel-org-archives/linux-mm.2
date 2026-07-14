Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6489C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 12:28:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90D806B00AD; Tue, 14 Jul 2026 08:28:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 897BD6B00AE; Tue, 14 Jul 2026 08:28:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761976B00AF; Tue, 14 Jul 2026 08:28:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 403326B00AD
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:28:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE049A03E8
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:28:23 +0000 (UTC)
X-FDA: 84987310086.14.1F49916
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1AEDA1C0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:28:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A1JGbJ7n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784032102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+oslaUM27lhUj79GayiLUHIp4AZwhj+Xm81InQr+S28=;
	b=SWVO//gKDvhi0AQ+FTdSyJmSqB9XNDigC0Mlw2I1eNhC+hC/fvyGMJFmlI47b6ayQeORRC
	DoXRcZrOxU2L6U5w0oHrUa4aWMd+dNpst7QdIs4lZGMqj+OxBMMg1lEZ/BWHUcVcib+em1
	2u0hQcbl8UoHHBZaFWjPW9dqcc+0s8k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A1JGbJ7n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784032102;
	b=Bc5TMi59LGDz8G0egTpvFUni4tBc5HbRTk1k3hyjp4+3dQhq6HoJlYCP2YFcokgzHcsTSD
	YHayq8TXoQIeFGbzwHlmJc71jZJHbPEyxzpKAol5IgKG+Dm6eNvQ7FCSuxf6hX4Wx5g+f2
	R6SrLmTPyDlkyqAXilcd3CNWM8fNoKA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AF020601DE;
	Tue, 14 Jul 2026 12:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCFE91F00A3A;
	Tue, 14 Jul 2026 12:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784032101;
	bh=+oslaUM27lhUj79GayiLUHIp4AZwhj+Xm81InQr+S28=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=A1JGbJ7n6lr8x/40sEJ5ktfvHwkiKUIbbHDtqsJr3p+3V/b1m6XvWO/HJ4ptNxB7g
	 rG7G3Ei7YrR3ecoJHXXsFHQo2lvdGyyMPareLJAhSpZw5LPhcFJ+GqAL4SUqvAXsi9
	 AFw50u6XqzQhSkExiIm+ymDv1wKis34+RGr4mhJ6Ggs00Wz+tPbL6PoY4pQml8CpmB
	 jIytPsG3BII/c3A/uGXiqLjR1wJk54rWoVr9q08eU8PI+ye9rO7wCfymQYGpeo1Dpz
	 OegVMdOYU+bYvAxhOCNlqH+nME9C+6Dju27rTDHPPR9kdTgZHKavG6HKeBXSsMT9pY
	 NogEbuF3Q7H8Q==
Date: Tue, 14 Jul 2026 15:28:18 +0300
From: Leon Romanovsky <leon@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2 0/5] RDMA, IB: replace __get_free_pages() with
 kmalloc()
Message-ID: <20260714122818.GE19233@unreal>
References: <20260713-b4-rdma-v2-0-65d2a1a5180c@kernel.org>
 <20260714122456.GD19233@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260714122456.GD19233@unreal>
X-Rspamd-Queue-Id: 1AEDA1C0005
X-Stat-Signature: udms3df37sod1z6tgknmi8riptcr5i9n
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784032101-302896
X-HE-Meta: U2FsdGVkX19uV8wHoLam3x1jGzKTozi0jYaV6WY+apVDBvkIHWhHs+qTdwqgr2B4TdGFOo30ho9O+rBSz0+oll9fwSSB4B2zApMhfBaghKhDf84lGhj5UJufI+NaD9s3hYxY7sQi4D5mwjCDhuO68MdNtLLNKehjYUUGSdjL73ouhJ9o8g9gcF3URuwwo1ZCfWaSlm2i+7F+GLz07202ZebGYgB8pn5kvR3Fx9XxpP0DZk7/ocYFPkpXaG2AQHsWPKVyV8KwaYjIH901OkrLYLQ+rvHnPFQZVLKMMk7XoxcU0d76RHrNzcerzBHoepwL2u9WkGJh3TzikP3xtmHBYMj+qC581ts1ElOaA0xhizEHAirZaNKpBi7f2XzLjrhKXFCjYZoyRL0re3XHaN583kUo7ijkb86ttbqpyV5K9TbmDT1HE1lwL+sY24PYZkQgjxI1R5kT8chjdp7evMc/qEA8hzMkY9QrcY2UsvPbdK+n7MsWUt6IpxdjEiJWzBjRUnayeNNbjovJ5/GxFBsKC0L7jQ0uX8T58VuGqsG2oGpLpJeVxucq6dKUPgkUCbuUWr2UzgVXzvyw0b4i+yUPY8xQVmu1Jci+ooVWYBTYcFERpHI8q/65+nVKs/afZKJW9HycVJ0A9GYI4bHgqQmvDZY/b8v3BF7hEH4zDS8S6b+uSYvSBU52FdtP4jpLV3GaomYmFAl6jsdhFwgYTaBu9nzPHdLC9UEzt3nYjhP1sEI+Gb7qCJ705OB7n/RjbxnirKe0zpZNmVPQQzH8ymEkQCF+g0n4i+p9Qjnv9A5JnAnyXSFkUeTqsZ0WVvSZQJsxXj6HatdyAZff9KUlq8kPL1r/XKoDz/z2OKHcAOJmFuMFCDad8yT79BJq6hWqA+GumJ4vDuifKLJ5L0Fcpv3j4Lbr0hLUhofGKKA4D8PCrlZrY8Lex0Oc3jfGiGIvu33I/xVeUlfFQf5hMnOqjzi
 iiePmspO
 Vgnz5rl7D948G4Usnwsx5sRvK1VA55yOsbF6WhuvA6p7qUmOsKC1EdGNJzlxEzExz1WgaiDuC5FhPIsTIR3a7Vk/oqYm66WVb59GAX3VGrOiuwoMN19FoHY31ZnsFHNzIUcEykAO4SFdOeq5QlPCKKXNfbKX0001ZOTfgGn2DLTztdY63kyYy3FIGRpX5hNC8yxVpvNRV05AjvBWQDwNvwtwu7JwaCLaIh8FvkNAo5jgJ0JCGgpMz3/eE6bWiKCZwmImoua0HMwa8GaGG68psIgZM4kbKy0aL8OKeSK6WaNhrQt2lQT+y5LRU02c6ald+yHUtDSSCDE+gJDlnDgyQ3vqFbJ8h2zuK4wX84K5FxhNCPo0fSbG0nuUDKufq/PJrH4zFHfF4DK3emeVQvYLZ0l4XPDnUU3Zzragc7rqEM7C5vDzH3D/6gvi0g6h4SROR1/psTdq2NMIyGQI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 03:24:56PM +0300, Leon Romanovsky wrote:
> On Mon, Jul 13, 2026 at 10:17:21AM +0300, Mike Rapoport (Microsoft) wrote:
> > This is a (small) part of larger work of replacing page allocator calls
> > with kmalloc.
> > 
> > My initial intention a few month ago was to remove ugly casts [1], but then
> > willy pointed out that Linus objected to something like this [2] and it
> > looks like more than a decade old technical debt.
> > 
> > Largely, anything that doesn't need struct page (or a memdesc in the
> > future) should just use kmalloc() or kvmalloc() to allocate memory.
> > kmalloc() guarantees alignment, physical contiguity and working
> > virt_to_phys() and beside nicer API that returns void * on alloc and
> > doesn't require to know the allocation size on free, kmalloc() provides
> > better debugging capabilities than page allocator.
> > 
> > Another thing is that touching these allocation sites gives the reviewers
> > opportunity to see if a PAGE_SIZE buffer is actually needed or maybe
> > another size is appropriate.
> > 
> > For larger allocations that don't need physically contiguous memory
> > kvmalloc() can be a better option that __get_free_pages() because under
> > memory pressure it's is easier to allocate several order-0 pages than a
> > physically contiguous chunk with the same number of pages.
> > 
> > And last, but not least, removing needless calls to page allocator should
> > help with memdesc (aka project folio) conversion. There will be way less
> > places to audit to see if the user was actually using struct page.
> > 
> > Also in git:
> > https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/rdma
> 
> Will you also change get_zeroed_page() in RDMA, or should I
> prepare a patch?

➜  kernel git:(wip/leon-for-next) git grep get_zeroed_page drivers/infiniband/
drivers/infiniband/hw/bnxt_re/ib_verbs.c:                       srq->uctx_srq_page = (void *)get_zeroed_page(GFP_KERNEL);
drivers/infiniband/hw/bnxt_re/ib_verbs.c:               cq->uctx_cq_page = (void *)get_zeroed_page(GFP_KERNEL);
drivers/infiniband/hw/bnxt_re/ib_verbs.c:       uctx->shpg = (void *)get_zeroed_page(GFP_KERNEL);
drivers/infiniband/hw/mlx4/mr.c:        mr->pages = (__be64 *)get_zeroed_page(GFP_KERNEL);
drivers/infiniband/hw/qedr/verbs.c:     q->db_rec_data = (void *)get_zeroed_page(GFP_USER);

Thanks

> 
> Thanks
> 
> > 
> > [1] https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/
> > [2] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/ 
> > 
> > ---
> > v2 changes:
> > * add comment to keep markers for sites that need "fast and as large as
> >   possible" allocation helper
> > 
> > v1: https://patch.msgid.link/20260630-b4-rdma-v1-0-ab42bcf0de92@kernel.org
> > 
> > ---
> > Mike Rapoport (Microsoft) (5):
> >       RDMA/umem: ib_umem_get(): use kmalloc() to allocate page array
> >       RDMA/mlx5: replace __get_free_page() with kmalloc()
> >       IB/mthca: mthca_reg_user_mr(): use kmalloc() to allocate addresses array
> >       IB/mthca: allocate mthca_array memory with kzalloc()
> >       IB/rdmavt: use kzalloc() to allocate QPN-map pages
> > 
> >  drivers/infiniband/core/umem.c                | 5 +++--
> >  drivers/infiniband/hw/mlx5/odp.c              | 6 ++++--
> >  drivers/infiniband/hw/mthca/mthca_allocator.c | 6 +++---
> >  drivers/infiniband/hw/mthca/mthca_provider.c  | 5 +++--
> >  drivers/infiniband/sw/rdmavt/qp.c             | 8 ++++----
> >  5 files changed, 17 insertions(+), 13 deletions(-)
> > ---
> > base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
> > change-id: 20260610-b4-rdma-44625922fe16
> > 
> > --
> > Sincerely yours,
> > Mike.
> > 
> 

