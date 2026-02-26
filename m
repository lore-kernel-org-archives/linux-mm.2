Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DFEBFD45FC
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 00:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 936BA6B0088; Wed, 25 Feb 2026 19:21:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BAB06B0089; Wed, 25 Feb 2026 19:21:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C6A26B008A; Wed, 25 Feb 2026 19:21:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 64D816B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:21:41 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE1DB58AC2
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:21:40 +0000 (UTC)
X-FDA: 84484704360.02.358F9BB
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3055040003
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:21:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772065299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iimsRCLqPtyXWAfARmFf/E+WmPcoD6sEBT8y0MvLELs=;
	b=dSvGmkLan72Z4fgMUchZgi9lNaTSB288C+EzYowVrUw14moGGvcHG14DMLxv0kA2ScGafU
	jEB0d2xLzAeHMCGN2+n3H9yvJR8zBGO6CPkIIFrmdkaFQmk9inaJztLFSvyHQrIwxiOrNk
	qW2cmTqoN2FDob6++/ABsvK64WBJX+s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772065299; a=rsa-sha256;
	cv=none;
	b=OpoXc1p3s+Ug8xg2jrm403xHsaresv7bUw+LQek32xbxuTyn9TOgvi6FOgJddUArOSY+C5
	PFu0m2U8DgWsZWJuXZKC9fg4nYWrTgGpaY4IkAfU2GPbuAxsRY8GKkGkir1ZDtMVjHXupJ
	AuUHufVgehUSUf3R6dspa8mx6CL7Nnk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
X-AuditID: a67dfc5b-c45ff70000001609-5a-699f920d0ae2
Date: Thu, 26 Feb 2026 09:21:27 +0900
From: Byungchul Park <byungchul@sk.com>
To: Mina Almasry <almasrymina@google.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kernel_team@skhynix.com, harry.yoo@oracle.com,
	hawk@kernel.org, andrew+netdev@lunn.ch, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	ziy@nvidia.com, willy@infradead.org, toke@redhat.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org, asml.silence@gmail.com,
	axboe@kernel.dk, ncardwell@google.com, kuniyu@google.com,
	dsahern@kernel.org, sdf@fomichev.me, dw@davidwei.uk,
	ap420073@gmail.com, dtatulea@nvidia.com, shivajikant@google.com,
	io-uring@vger.kernel.org
Subject: Re: [RESEND PATCH net-next] netmem: remove the pp fields from net_iov
Message-ID: <20260226002127.GA71611@system.software.com>
References: <20260224061424.11219-1-byungchul@sk.com>
 <CAHS8izPjfrKFNtvkyODY7HXSsAuQuPhzy3+fMyYTFuWKQJZ0Fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHS8izPjfrKFNtvkyODY7HXSsAuQuPhzy3+fMyYTFuWKQJZ0Fg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRzGeXfOzs6Gw9NSe9WwXERoaBZ+eJFuBsEhQiz9EBrYykOOtmmb
	Lo0Cw7xmToXQTbNV3jYv2cwrpnnXTDPHzGrqkkyItLzmrcumSH57eJ6H5/f/8CcxQTrbhRTL
	ohm5TCQREjycN233xIuf/UjsY/wNUdlyLCqx1LPRSvkUC+XrawEqG1URKP/tXRxN1awCVNmY
	yEINjVMAfcutINBk1wQHjRd/xVFTch2GJlQ9BJpJHMDRYG0GGw206whUF2/hIGNjPoHGyv+y
	Ua9Gh6MU80scdWmd0FLfd4BM6kYWemwOQ0PtEzjKu5MB0NqytZ/XOcY56Ua/0H1g0cO5WTg9
	0vyaRTdoRjm01hBDV5d60sb+GNqgTyVow1w2h26on2fR9xNmCHp28iNO/2g2EfQbbQeHnje4
	BdqH8I6GMxKxkpEfOn6JF1Fd0gmi+txi10wmIh5kOqUBLgkpX1ij6WFv6RWVGU8DJIlT+6G6
	wt9mE9QBODKygtm0A+UBC5uzrHUeiVFJbPi+Z4mwBTupAFjV0L2xw6cQNFYVbuwIqFswp1q6
	ae+AveovuE1j1s31giHMVsEoV1jyh9y098CEmrwNFJc6BysX1cCmHal98FVtN8uGhVQRCRfS
	VZzNk51ha+kIngl2aLYhNNsQmv8IzTaEFuB6IBDLlFKRWOLrHREnE8d6X4mUGoD1R4pvr4fW
	g7nBoDZAkUBox7+wUiAWsEVKRZy0DUASEzrwzT+tFj9cFHeTkUeGyWMkjKINuJK4cBf/yNKN
	cAF1VRTNXGOYKEa+lbJIrks8cB9WEmSqhftUl8K72F8l8+vNdR0P7pC9a/mc4O64YEzzeOYU
	fDpGWejX4m8p5znDvathQ3Xc6wETXpz1pFSPxYP6VkWCTnNs9GGylLg32xQWUoudGF66HDTd
	UW0+e+p5T9EDaU5WauBa0PzuX/OG4E/noTaHDpUQ9k4KnzOxQlwRITrsickVon84w9RmHwMA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsXC5WfdrMs7aX6mQd9/VovVPyoslj/YwWrx
	c81zJos5q7YxWqy+289mMed8C4vF862/GC3W7Wplsti56zmjxasZa9ksnh57xG5xf9kzFos9
	7duZLR71n2CzeNd6jsXi8NyTrBYXtvWxWpw7vJLNYnvDA3aLy7vmsFncWwO05+SslSwWHXf2
	slgcWyBm8e30G0aLqzN3MVksvBNvcenwIxaL2Y19jBa/fwDVzz56j91B3mPLyptMHtdmTGTx
	uLHvFJPHzll32T0WbCr12LxCy+Py2VKPTas62Tw2fZrE7rFzx2cmj97md2weH5/eYvF4v+8q
	m8fiFx+YPM4sOMLu8XmTXIBAFJdNSmpOZllqkb5dAlfG5uVHGQtOy1X8vnqVrYFxglgXIyeH
	hICJxM/+OyxdjBwcLAKqEjPXOoKE2QTUJW7c+MkMYosIaEos2TeRtYuRi4NZoI1V4vqJb2wg
	CWEBP4kNO4+zgti8AhYSlzcsAZsjJFAjMX1zLkRYUOLkzCcsIDYz0Mw/8y4xg5QwC0hLLP/H
	ARGWl2jeOhtsFadAoMS6rzMZQWxRAWWJA9uOM01g5JuFZNIsJJNmIUyahWTSAkaWVYwimXll
	uYmZOaZ6xdkZlXmZFXrJ+bmbGIFJYVntn4k7GL9cdj/EKMDBqMTDG/FzXqYQa2JZcWXuIUYJ
	DmYlEd47H4BCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeb3CUxOEBNITS1KzU1MLUotgskwcnFIN
	jHKvJ99ZKOqarjrn96e3Hn0nzjb5FM9rXrx3ymM1F4Y/xp2/0i7sagsuuBgU2KVv1Lud6x1L
	BPfBV89ij/c9OaZQHPhpvXzKQaXzKkn2PZvnCv+dGcsrs3Rzm0lQt6a1RFLKhHVr2DxaG86V
	a13g5vqS42y39mf1npAnoev1eOuP3i8rmpZarcRSnJFoqMVcVJwIAB3HkTgGAwAA
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Stat-Signature: hw9g3e7e47rqj1aqdoim1izghh68g77a
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3055040003
X-HE-Tag: 1772065295-870244
X-HE-Meta: U2FsdGVkX18cH/+p1UYFRzB1dOyqnM2/b+TF2Tz4XffGj4K3CbsS4D5Hn1jxmXR6HYh2Xbc/EIXUiHYTBO2jyUTJzLxTyHTeHAW12fCs47LVFjYv7eeyVigmm0zO4TBtbTcST13teXLX/l7hjPYBMrYSN0FeIFGJqdegWhr9DleTSjjupR4bOnaBATTn3QDGoqJFH3gY1f9UnAqQLX33+OhGMMmUuKMHM5qIPWKUV3Z0AV3zhgi5P9lOs1iNu05CZmDC56FRh3hiihaLXjLtWfud63NKxB5//eSI8al31o8goYlyss15Bg/iPZ9jojUYONM6lgGZ9LA39NJfM0CSD3hf0aaApaRgpq4BM17hNZF7M7BaWA//qBgj6O/LlA2a3CpODD6CKkIczNNRwkEFbRpPUhQ9lXvmDbMOLb1lJqshdVbIcyb+ArjJDOmtlQpgNlmAwZs6ru4hCmWiFVxj/rDLOG84eC2duZ9nVbaMHtia5xp7zxSPOPSflpuvV7zPguaYDEeUWQiyynn2OAoJ348yRPL2w/q0m/t8SeE6XQSmnglbaHsmWz83Qh3KH5J0+4zbby4d2cH+wBmk3E79vn2uOScPJAe5dYtp5c/uIZTU+XgDdkN2adcJl3lYVlf9c9Z02bl+3ePJusmOCKjqYOW0VMmaOegQNvlQs4N94NPpZTzt7o1yePcm5VdnQ5uPLGX4vOt/rLJfs3gte6Ew80Ogao4wsP/AENGp/CSKSwqkCGvCFXWUDY9A3MCsctcqpOvfqbSuLV3zEST/L+HoZR1rudTkYYzDTp1laNLUXDCo/4KjVdp0J7Gdd0TvMLADklbQo0fPTIWKrAzGshKxwaIHutHamNtpLfKZfGcd8u1FRtSKxLFmj+MqHtWsyJ10p9xOohc1PcXtMZxkGhEZGP9u9rbO3uFcp7URhvXednLKkywT3cZJw5j385M3xfqKYbmvQiAp2y6iiW4a9Ju
 B123ubS4
 NwD0KmWuIWv0Wl/xV0UrcOKrl+syHam+DpY9lx93we/GTZC3qX/wqYb6/65ENUCyR0SBuE/skMvoT5zGtc0veM2Nn+qdDSUJsWPXF3Z/BlEjEmBWtl84Dmkj+grHmTl0k3cR3zxoxYmROfTfqZLbZ8Mu8+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 09:57:17AM -0800, Mina Almasry wrote:
> On Mon, Feb 23, 2026 at 10:14 PM Byungchul Park <byungchul@sk.com> wrote:
> >
> > Now that the pp fields in net_iov have no users, remove them from
> > net_iov and clean up.
> >
> > Signed-off-by: Byungchul Park <byungchul@sk.com>
> > ---
> > The original post was:
> >
> >   https://lore.kernel.org/all/20251121040047.71921-1-byungchul@sk.com/
> >
> > 1/3 was covered by Pavel's patch:
> >
> >   commit f0243d2b86b97 ("io_uring/zcrx: convert to use netmem_desc").
> >
> > 2/3 was taken by Jakub and merged:
> >
> >   commit df59bb5b9af3f ("netmem, devmem, tcp: access pp fields through
> >   @desc in net_iov")
> >
> > Now that io-uring and net core changes converge in one tree, I'm
> > resending the 3/3, which is what Jakub asked:
> >
> >   https://lore.kernel.org/all/20251124184729.7e365941@kernel.org/
> > ---
> >  include/net/netmem.h | 38 +-------------------------------------
> >  1 file changed, 1 insertion(+), 37 deletions(-)
> >
> > diff --git a/include/net/netmem.h b/include/net/netmem.h
> > index a96b3e5e5574..a6d65ced5231 100644
> > --- a/include/net/netmem.h
> > +++ b/include/net/netmem.h
> > @@ -93,23 +93,7 @@ enum net_iov_type {
> >   *             supported.
> >   */
> >  struct net_iov {
> > -       union {
> > -               struct netmem_desc desc;
> > -
> > -               /* XXX: The following part should be removed once all
> > -                * the references to them are converted so as to be
> > -                * accessed via netmem_desc e.g. niov->desc.pp instead
> > -                * of niov->pp.
> > -                */
> > -               struct {
> > -                       unsigned long _flags;
> > -                       unsigned long pp_magic;
> > -                       struct page_pool *pp;
> > -                       unsigned long _pp_mapping_pad;
> > -                       unsigned long dma_addr;
> > -                       atomic_long_t pp_ref_count;
> > -               };
> > -       };
> > +       struct netmem_desc desc;
> >         struct net_iov_area *owner;
> >         enum net_iov_type type;
> >  };
> > @@ -123,26 +107,6 @@ struct net_iov_area {
> >         unsigned long base_virtual;
> >  };
> >
> > -/* net_iov is union'ed with struct netmem_desc mirroring struct page, so
> > - * the page_pool can access these fields without worrying whether the
> > - * underlying fields are accessed via netmem_desc or directly via
> > - * net_iov, until all the references to them are converted so as to be
> > - * accessed via netmem_desc e.g. niov->desc.pp instead of niov->pp.
> > - *
> > - * The non-net stack fields of struct page are private to the mm stack
> > - * and must never be mirrored to net_iov.
> > - */
> > -#define NET_IOV_ASSERT_OFFSET(desc, iov)                    \
> > -       static_assert(offsetof(struct netmem_desc, desc) == \
> > -                     offsetof(struct net_iov, iov))
> > -NET_IOV_ASSERT_OFFSET(_flags, _flags);
> > -NET_IOV_ASSERT_OFFSET(pp_magic, pp_magic);
> > -NET_IOV_ASSERT_OFFSET(pp, pp);
> > -NET_IOV_ASSERT_OFFSET(_pp_mapping_pad, _pp_mapping_pad);
> > -NET_IOV_ASSERT_OFFSET(dma_addr, dma_addr);
> > -NET_IOV_ASSERT_OFFSET(pp_ref_count, pp_ref_count);
> > -#undef NET_IOV_ASSERT_OFFSET
> > -
> 
> Probably better to retain an assert that netmem_desc is the first
> field in struct net_iov, no?

What is the assert for?  Can you give an example that might lead wrong
without the assert?

	Byungchul

> There technically is no assert that netmem_desc is the first field of
> struct page, but it's generally well understood that the memory
> descriptor types should be the first field of struct page. It's not
> well understand that the netmem_desc type should be the first field in
> struct net_iov though.
> 
> --
> Thanks,
> Mina

