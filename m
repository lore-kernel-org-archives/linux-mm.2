Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB84DCC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 11:08:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D83D6B0088; Fri, 16 Oct 2026 07:08:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 987DC6B008A; Fri, 16 Oct 2026 07:08:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82E236B008C; Fri, 16 Oct 2026 07:08:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5EF3C6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:08:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D9A988035F
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 11:08:48 +0000 (UTC)
X-FDA: 85328216736.24.B4F0A33
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 233D9A0003
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 11:08:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CXp9Bvkx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792148927;
	b=aeTnq7wfIiWyiM6BHHfM/7OdZL3rheZQDEmGsjfIw9JB5htrRjy0ILEwrKxANElPGa3lbE
	AAHi7LriPXfQRwooASJO2KdaOLNrRmJeC/JUGJTSMsxZUOkWzQL8gxHlSJmf+TQHe9lxbK
	ncPqcRA/x8CAGizDF6H0wsxIoseCig4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CXp9Bvkx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792148927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aYzwZzPUAR9vzLqrTt0PYsxt+sI0CPAGuOXSlgLa8qk=;
	b=zl4LH077zqoc3PY5PaurfUAUd4QEIkWUOSKajBg4Re2CYYn3UzoyuW0iGm0FfUi9NrFgqW
	5IEYxovXEz9XhEY4f+8ZtxLey2tCCQJUiPdmsrumYcCPukUQws56V0AQaCJHEWwkEEoL2i
	5I5RwxZiksD0CmOoyZgWites3REWmJQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8289941E47;
	Fri, 16 Oct 2026 11:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9358E1F000C4;
	Fri, 16 Oct 2026 11:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792148925;
	bh=aYzwZzPUAR9vzLqrTt0PYsxt+sI0CPAGuOXSlgLa8qk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=CXp9BvkxyXrMX2C1xpAnRsd9f/pQ/VB2ySjX5mzI47VWE74jGEh2QGs5RMRW8ufsB
	 lBYRb6QY/1FDHDnrHPkD1+re/UKlECaa/FqyP0y8dfJD1jeBsj8Wdtpcg7aV8HhpQI
	 8yLnFPv6GB2p1ql0WBPafv55dqdNXmKZ/ngMn0Q2fF6vXYjX41ZXjGkY/UlzMqyUNY
	 wYT84VOjAUTxr6ozRlT0BiYETLZFQqA3leg/ATg5wnm+/gGymfb3AQL66C2mXYMVpn
	 Qp9xVPQ2yQTuo2OMxS/HSCZRMOvf0Rw9QkQG6W3v1/poTBFMbcOBR6lcymWB2HGieC
	 CPJa/0wdN42jA==
Message-ID: <1299ad92163f2eb8fecc06165b3b52f7904f09e9.camel@kernel.org>
Subject: Re: [PATCH v4 07/10] mm: add folio_mark_dropbehind() to mark a
 folio dropbehind and account it
From: Jeff Layton <jlayton@kernel.org>
To: Mike Snitzer <snitzer@kernel.org>, Chuck Lever <cel@kernel.org>
Cc: linux-nfs@vger.kernel.org, NeilBrown <neil@brown.name>, Olga
 Kornievskaia	 <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom
 Talpey <tom@talpey.com>,  Christoph Hellwig	 <hch@lst.de>, Jens Axboe
 <axboe@kernel.dk>, Matthew Wilcox <willy@infradead.org>, 	linux-mm@kvack.org
Date: Fri, 16 Oct 2026 07:08:41 -0400
In-Reply-To: <20261015233309.42999-8-snitzer@kernel.org>
References: <20261015233309.42999-1-snitzer@kernel.org>
	 <20261015233309.42999-8-snitzer@kernel.org>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
MIME-Version: 1.0
X-Stat-Signature: y7qizmf76s7rm8h8g5xfwrnz98zgf5jb
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 233D9A0003
X-HE-Tag: 1792148926-581599
X-HE-Meta: U2FsdGVkX183IbCAl7KeJ0OHe7b0xdfkhpNdx4w7ItxGOEDL7agr5PgybLQqu9HtxGTa/nuF5qzksE7OkpH6vJwo1f1FP/tmTysAXcLsImZlKYD2K9BG28+brj+3mQXF596VK5u7RTvYZiXLBhay1wRwsvjTDRgW3G9y7PWLSpdav3onb9WMlyFZsw40XJGHQYpxj1W24pErjU/b4wa93xE0xXk7WXsLX1RAvgk4p4TfhDx9Ro6raLQv760GNlIZvaT/5L99VTpzFn4L5wowVu5dYXP1nKN5Ndn4VlOjHxJNRizdo0+tkemzS3a4VaRC4hIL73Jxtb3Sbrj83QEd2z3beYEHm5n3EpRIxfN592XlxEjwnHGXaX3tcL09HYV5OxWLP3/3qJ+S8wDMVX29voKw3EzajURE44UHeTUHMBozcH913yYxWpPYz3mXVH0fTXfti0WQMX0QU3zMOy1jIsc74muEaZufTBkK7tE11pFvc2Uu4Z/ktkn3FmJo7Gf6dg+EcjKlLVI2QMQor81WKt/xfi1bWke6zscKiveF9+8SNcKv4Cdt+wQMWQfEYMbdwG6dH5rgLGqlLuVbdXa0QqDYFOV0vpdfzN0Fi6e/+2HcrixWRdFrCCuk1yFzrYDtpoP3sG9q9z4oiOXcYiSIGQKK3+39c7aR8rnd6ScQZQLBzRW5hcdtw/jRGmKoEEedQJn6mt1kafPVjXfc3TmxyL6GHs4aGfh6z7DMLPj0PXq2Z6DlfOfL8HdgfKFLgp4I1Rlks3XiJXxu7Dv1LiRUrcabpMNqcUZzzXNOKviNpUq4jHFGzdt9+fCXqURa5H8/yy7+apMiO4eMUuXHZIsyjMQvFqp7NQpUeAiq0BfkEBOe5fqdX+meatr7kPuEo0oBCGPTMVrMJH3jAX5lLab0KBXTIE0gTLjIZLYW2W4iP0dx+5UVO2cPtvgVw+BEimvLT/PV2CmMpLQwApoLXAo
 wImrnDAA
 YVyak8pz6/ml/naO8jJsMSuML7dvyBCn3UOxq3QBVebsd/9LhpdLsMuACMMnGbCL3HjsyQy9/ksPwdzd7MR80Wk+YNELVb0wir3Lb3DpQQpuZn8uYjagiiWCq6qC/WeUM/Tc9nNCJEscn1jnZ6mHwklem4QNd1Oo80x0Hwo0Jw0hGMVeA1pFv4ph87bu6dzW3iUgGq4TDiOvC7EKNxLDz0MvBr/LhP6BEF/y/Ui6motj0zV0RRXQ6j6yz2prq+lruHsDiTI685kXDN7xath9gBwNlriiREYuaVdUr8/O3LfGnkntfqkAIOeKARSn1mWYY1zECUbzbEAJhEhAVlP3D2O4kwgpnt8WkG/foTKBEvMZo1ryV36visS+b9UKTvdWFijkC6pGOeN9mS71TIGDcdSuFN272cH2bZgsgrKEUjGS66wWnjkPNO1e4bP3FhidF2xTzShndckrBMxdpmvTMMXyYuFV4ps9sVQgwCP62fHgotOg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-10-15 at 19:33 -0400, Mike Snitzer wrote:
> A folio allocated by an RWF_DONTCACHE write is marked dropbehind before
> it is dirtied, so folio_account_dirtied() adds it to WB_DONTCACHE_DIRTY
> and folio_clear_dirty_for_io() or folio_account_cleaned() subtracts it
> when it is cleaned.  Nothing marks a folio that already exists.  A
> caller that sets PG_dropbehind on a folio that is already dirty
> unbalances the counter: the clean subtracts what was never added, and
> once the counter goes negative, wb_stat_sum() reads it as zero and the
> DONTCACHE writeback kick stops writing anything back for every writer
> on that bdi_writeback.
>=20
> Add folio_mark_dropbehind(), the inverse of the clear in
> __filemap_get_folio_mpol(): with the folio locked, mark it and, if it is
> dirty, add it to WB_DONTCACHE_DIRTY.  The folio lock orders this
> against dirtying and against folio_clear_dirty_for_io().  A concurrent
> lookup without FGP_DONTCACHE that clears the flag again subtracts what
> this added.
>=20
> The name follows folio_set_dirty() and folio_mark_dirty(): the first
> only sets PG_dirty, the second also accounts the dirty folio.
> folio_set_dropbehind() likewise only sets PG_dropbehind, and
> folio_mark_dropbehind() also accounts it in WB_DONTCACHE_DIRTY.
>=20
> A later commit uses it in NFSD to drop a page shared by two misaligned
> WRITEs once both have written it.
>=20
> Cc: Jeff Layton <jlayton@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: linux-mm@kvack.org
> Assisted-by: LLM
> Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> ---
>  include/linux/pagemap.h |  1 +
>  mm/filemap.c            | 31 +++++++++++++++++++++++++++++++
>  2 files changed, 32 insertions(+)
>=20
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 0adfa6605653d..3012bd95812a1 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -1310,6 +1310,7 @@ void end_page_writeback(struct page *page);
>  void folio_end_writeback(struct folio *folio);
>  void folio_end_writeback_no_dropbehind(struct folio *folio);
>  void folio_end_dropbehind(struct folio *folio);
> +void folio_mark_dropbehind(struct folio *folio);
>  void folio_wait_stable(struct folio *folio);
>  void __folio_mark_dirty(struct folio *folio, struct address_space *, int=
 warn);
>  void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb=
);
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 00fd89cf6f550..ed7e4dbea653f 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1644,6 +1644,37 @@ void folio_end_dropbehind(struct folio *folio)
>  }
>  EXPORT_SYMBOL_GPL(folio_end_dropbehind);
> =20
> +/**
> + * folio_mark_dropbehind - mark an existing folio dropbehind
> + * @folio: the folio, locked by the caller
> + *
> + * Mark @folio so that the writeback that cleans it drops it.  A folio t=
hat
> + * is already dirty is added to WB_DONTCACHE_DIRTY, as folio_account_dir=
tied()
> + * would have added it had it been marked when dirtied, so that the clea=
n
> + * that subtracts it leaves the counter balanced.
> + */
> +void folio_mark_dropbehind(struct folio *folio)
> +{
> +	struct address_space *mapping =3D folio->mapping;
> +
> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> +
> +	if (folio_test_dropbehind(folio))
> +		return;
> +	folio_set_dropbehind(folio);
> +	if (mapping && folio_test_dirty(folio) &&
> +	    mapping_can_writeback(mapping)) {
> +		struct inode *inode =3D mapping->host;
> +		struct bdi_writeback *wb;
> +		struct wb_lock_cookie cookie =3D {};
> +
> +		wb =3D unlocked_inode_to_wb_begin(inode, &cookie);
> +		wb_stat_mod(wb, WB_DONTCACHE_DIRTY, folio_nr_pages(folio));
> +		unlocked_inode_to_wb_end(inode, &cookie);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(folio_mark_dropbehind);
> +
>  /**
>   * folio_end_writeback_no_dropbehind - End writeback against a folio.
>   * @folio: The folio.

This patch and #8 need to be split out and merged via the mm tree.
They're related but the rest of the series doesn't specifically depend
on them, and I doubt Chuck wants to carry them.

--=20
Jeff Layton <jlayton@kernel.org>

