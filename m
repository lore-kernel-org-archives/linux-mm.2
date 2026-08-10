Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67259C5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 12:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44C236B008C; Mon, 10 Aug 2026 08:57:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 424B26B0096; Mon, 10 Aug 2026 08:57:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 360C06B0098; Mon, 10 Aug 2026 08:57:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 135216B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:57:41 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A0AD2160143
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:57:40 +0000 (UTC)
X-FDA: 85085361480.22.3C4459B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 036BE40009
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:57:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ig+b+sZN;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786366659;
	b=rejfmRBnzu4OOJM0rbid04iNkF+Yn3a3ho834DOfkR8PCoRBgsvoIJumGwgHndAAoixuBs
	RPhkd99XuTO9Zpod39MzPz2D/VmCeikLDPoTFhQ2E8JRxKFHqosgN7I3og1lJ4SafHhkMr
	QAgWPUCdlU8TcTR8lHwg6egoOZkC638=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ig+b+sZN;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786366659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7nEsiIljsOnwiqNJPeR59SBXjP5U5Vnellr86acHMk4=;
	b=h9NLKvjKVUBtEjuraeyVeUrgsQiZfNlosVujT2/pKeMU+C5pXaMaV1v71dcRddwDBaGDup
	gv5si06hyzE1gdKOaaYyUNenqN+srcmjEX1qoMjbPrg1ZZ/5xj88sOXWSonIrBsTWbwI8Z
	5avZzZpQqHGlk4KkwuWA/VT2Z5yN/2c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D7FD601E0;
	Mon, 10 Aug 2026 12:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88DA81F000E9;
	Mon, 10 Aug 2026 12:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786366658;
	bh=7nEsiIljsOnwiqNJPeR59SBXjP5U5Vnellr86acHMk4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ig+b+sZNILkr56gDnGvd+gfzEq6oaBqW/nqeXP0rI+XM2u9rVQo7Re2/XnKIG1RRt
	 bpNfKRUeKJVMbZI2LafUyPKGKcdKLr6fHh9Bz/lQ7RAWGA844b3W/Mph4YPul+X4Nv
	 a8lah/j8namaCU9T1N9E603HnIV8JRv9+IQDtlPIB432whEGIUNTctnq+jnWra9A3M
	 51RjdDJHBlw0Iml5CWCfa6zKHX+8jtQAXZbQK2l2u+4OC1vMVWC7h4pYXEKUf+p3Vz
	 mCCWBu4H+k3PFJhOetXyZ/ffuB+jBMyiDmFyJkXsoHB8XDIH+o9SA3uzcX4HCXbtmW
	 qEHMuD04vZ9ww==
Date: Mon, 10 Aug 2026 13:57:18 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] mm/page_io: rename bio_associate_blkg_from_page()
Message-ID: <annKe7qXw_A-BbHl@lucifer>
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
 <20260806-b4-page_io-folios-v1-4-0899bac3b826@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806-b4-page_io-folios-v1-4-0899bac3b826@columbia.edu>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 036BE40009
X-Stat-Signature: xhed6qe887hyzx91ixf7x7fjoj6epx8z
X-Rspam-User: 
X-HE-Tag: 1786366658-881800
X-HE-Meta: U2FsdGVkX1926BUk8K/tJCXLB0g5gLGDVgKvWHm+YM9xpNlStt/BWWMdqcrbbu5FRIyrOJY6DtnQams7KjpcssePgMQGvFWtf03pm57VdnEmEKcKcjVOU02ijXIJivG6aozAPvGBPx5LDnmTVefI2jKhLE4ayAdbh+ID5ql14xIvFgYoCMrQbSSoreEzVMYbMOaBto5ndu9b3dIJSQhN9tJnEb/E5M/byVtHCt5aOabaYHp+LYCgxxACPormvFu4JKSzZ5RxIvwJ/Q2Tu7DWfvLsOwlrkCceFjFzWlBeKAuqZwfY1eB+mDbT0+A6BIkmRh1JI64pBvkD5Tspr8fIzcuFnZSqF0hqUiNok0Ma3Pc8GeCWDasQneo01AFBa18r/uNzj7bp4/sH7VIlLWxaoaLOmAti1L4vJNrB1vw5va/ny+ScMr3otQtgxZA+vPY9cVUr/2rWzwsCw1x/nCcOhivUZ9+7RAyTa2iW4RG8zZXfnra1E4M86bGzGkvfFfTvCpv7OLaeGAr2lVp8pOoPgv7/uCxCJWbk8n3aLZQ5dq7tR7KuEu1Mg7IcoCYU8kBecinmEmjxhZIYvXOzmmFjjWvvt3OgfQ32I1Incx8HSflCHX0ZccUpFnt0SrBDuipOk8q7wEYi2TZJ9w5fX4YhcsMxd8PGY5f5M/vNhIadpKA6U6zdB9Zqeous2pO4TT4SaSRbqv/QZzf505sl3h0nsw6Io+8DFOtcKBQnzeB9BXYy/AfgIwKIANnJY2whrdLwOLB84UnADcUr00brDzP4DRmg8RsJ2YOa4pMhn2UJrIU7lGw8GFIsuPC5ODlVWpRzAFGpsZ4Au9b1Oouko2K9+LS5SS8NRxKhjXM/jj2cUHVkWGyDgcoD2pXBcoa2d4ysMk6j83gfvBX7NaFpQO6l+5QGPob9lGxBTl9RFiIjp5WewzwUC2NPwkjfDkfNQ+C+s0cSiUjVT3wRPYhR8/q
 dd02IBi7
 /5wVtgA5hIo4NAm/0PzsIx4/ofHMfIVN9Yuw6223KQx0PLEh9bQkGcKq5xT3gG1ONeK0L23nkk1uq53KXAfOaNX3jU70e9UkVfe4O+F7Vud29dIl+MvbafQmpsG0WCICdIIHdUn6EngFkmQz9AGZKxqRy43bgWftisAT9oK/B9nV94HkR1eSkbEQaAatzDxZ5Yv0GebcczR0vRMdbibFL0MQNdSsOk92pXRy6BjzPgCNXgHcM6h6s4xdv05mC+zHZvV65aLugFo1X2W3kZM87i7ph0+S9M20d+MZ+mlGtyIdKk8VOFBYz99J3GgZYvuoF2Viy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 06:55:36PM -0400, Tal Zussman wrote:
> This function takes a folio. Rename it to
> bio_associate_blkg_from_folio() accordingly. While at it, convert the
> macro in the !CONFIG_MEMCG || !CONFIG_BLK_CGROUP case to a function.
>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Nice in general, thanks!

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/page_io.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/mm/page_io.c b/mm/page_io.c
> index c6d0949b3f1e..8573f7b8967a 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -276,7 +276,7 @@ static bool folio_blkg_can_merge(struct folio *folio, struct folio *prev_folio)
>  	return can_merge;
>  }
>
> -static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
> +static void bio_associate_blkg_from_folio(struct bio *bio, struct folio *folio)
>  {
>  	struct cgroup_subsys_state *css;
>
> @@ -297,7 +297,9 @@ static bool folio_blkg_can_merge(struct folio *folio, struct folio *prev_folio)
>  {
>  	return true;
>  }
> -#define bio_associate_blkg_from_page(bio, folio)		do { } while (0)
> +static void bio_associate_blkg_from_folio(struct bio *bio, struct folio *folio)
> +{
> +}
>  #endif /* CONFIG_MEMCG && CONFIG_BLK_CGROUP */
>
>  struct swap_iocb {
> @@ -595,7 +597,7 @@ static void swap_bdev_submit_write(struct swap_io_ctx *ctx)
>  			REQ_OP_WRITE | REQ_SWAP);
>  	bio->bi_iter.bi_size = sio->len;
>  	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
> -	bio_associate_blkg_from_page(bio, bio_first_folio_all(bio));
> +	bio_associate_blkg_from_folio(bio, bio_first_folio_all(bio));
>
>  	if (ctx->sis->flags & SWP_SYNCHRONOUS_IO) {
>  		submit_bio_wait(bio);
>
> --
> 2.39.5
>

--
Cheers, Lorenzo

