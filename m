Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 531AEEFD20F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 08:58:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89F026B00DC; Wed, 25 Feb 2026 03:58:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84C996B00DE; Wed, 25 Feb 2026 03:58:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7700F6B00DF; Wed, 25 Feb 2026 03:58:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 606C36B00DC
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:58:43 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 129241C332
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:58:43 +0000 (UTC)
X-FDA: 84482378526.26.6987FEC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4E63940007
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:58:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D1HwktCW;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772009921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xTY2XBZ0M88etrL4RrqM4EAFLVXRy7VP1mSXMJJNCZ8=;
	b=1R+EjOs7wqdWBVV+SEqwWp43gO/lHC+0TtvA8lyfY9qv1hwFLONYUFiiI6ElkBvnXgZcQC
	acrZhKoJuEtsXmUpCDb7Z1fScUbSd42BFGGgZTLBLa55heHZQGd2C0erRJUUrCqNBtQhQG
	mLTnIhfAaU63Sy+pcXHVxUEvuYfJttU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D1HwktCW;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772009921; a=rsa-sha256;
	cv=none;
	b=xuZE+ICbXdHBlEdrBpJiSK6Y/ZiqE1gWZ1JGg/LZLX/vYT4CKdh6r56JlzDlQeVPhTIntA
	0sSaZlyIPqwySaBET9RPaytBnoW6IoygYREDKWQBi+kTEMvMSOHzrQ3QlEczULFLrEsc+h
	KY/EduLcm9mPKJyMCZXwEdbPvmMG5hY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 577FD43DBC;
	Wed, 25 Feb 2026 08:58:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C4AC116D0;
	Wed, 25 Feb 2026 08:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772009920;
	bh=++lJa34FIQd0srk6H91XdQrYCvf1kKADzH8XRl7vWR4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D1HwktCWBfBnn+mWoG4xVpdg937txzThq5+AUBBINYW1g0lW/MV/s+4VwR7J4yHqG
	 A4ipDqQa/TBbV4j/DbbFZDZTpIwEqxWq1T0C5kN/SyiT8qmNjXFt4vIDwgtj+cg7gQ
	 h7qjztYt9jQmo5oRNpqm/nNJzH9Nldlizjw7NSZq0kwlkcpvcGkZsp4gsDzQsukMS9
	 8kl/P5Yd29AW583M1C7kJT+meOcy/shZy9SVmdMoOGxb13CiO4FqBJv2sOFjUTy+Ns
	 +c8ESgT0u+cQ3Al1BLMS4UxeLYcNwq7DxJbftIJBOqBx6ahnt3Kl+p+Ht/mz5yR7xA
	 uDKVrFXDj4seg==
Date: Wed, 25 Feb 2026 10:58:34 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: memfd_luo: always dirty all folios
Message-ID: <aZ65uvOrTDndpic6@kernel.org>
References: <20260223173931.2221759-1-pratyush@kernel.org>
 <20260223173931.2221759-3-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260223173931.2221759-3-pratyush@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 4E63940007
X-Rspamd-Server: rspam02
X-Stat-Signature: rqxauo93zhg6hxuh3mbfzhjkfrk8u4d8
X-HE-Tag: 1772009921-466018
X-HE-Meta: U2FsdGVkX1/UkFxQeuuadCehi+JQNNVFdyMphR437Wok6eHPJSk6x2Xp8JzSoHIT2533vZOaR/BcooxBZDMzDLCWghaVYsfQIuyCTO9jnjn2CPxHkPd0szg3SY83uVYMd7cyF6POkn+roiRKCE/4NrelLHHYeUSP3d0qmpBIhuz7ob9WdYn4rwlolIVB9J7bViP0whZKvN3pLpd+eywes9gxYX1JvF0g48S7Nfszh0JyGit7hbi3BhXyAvbjsmPrWARD4RfONgZxuPskLYnG51xWT9iIpcPyoFxUh9NLnmZyt2dIwCcoWhio8HM2L6ZzvgGhkX4quZU/5dfW6R7V5PcvHUGE/jQ1cVl3dTWLU/UrrTUhM98wegLLKSAv+7r8UFoOSQ65rvQM8h+QQSxhTows6QcHo94v/Ybhk46pS7BCJk4tpM0qUpRKpzBmeefU8zsjV1ME92juCHI/OBnvmyIeOteEYilPLKuSerD/UZ6mrWpZPVyrBBDjvhz5hw8VC6Ly4kV3vK6M+Sq4KmLE8w3ZoAXHZAfXj4IWpjqL0nNYFlEBnYIFCqqHQ4I7RArQ2dNvGCEtshvZYiuPdDOqM6SYPAhWu4mL7BoYri47lfXIE7L+sjboj443lLNMQPMWDPu6VOZSQ1HoWxftqKsQ+wVLQfa2YFyF+IOaYCiu/OuMTNbIqqK5zIRuDXpWeuz4IEOglNQq0Y7BkMGLaHLcTLI3wO5AQ4AwLlnmymbxSz1ZTo/Lvbwc9OtTUbnRovUgxCv7YefXbW6TmH/1WdMbYE2Rqni5D0+wvPQcJerlej0HtGTz4K9xsdPh7RM5vTxJ3VclTCESKLfqb1BVlKB9zQX1S1i1Ip2M1QOgKqJtRjWdkJ/lVBtP4C8o7UTdDSrn/CROKYUzmaICYypu8cs2bLnbxt0dnR1fvuT6O6fnl+quYrWY+Jgfr4hxIMzfMyIgXI2GDSHkNIHQmrCEOFx
 KPTfZEfI
 i0pCPfsGxLHFOHs5zy7Ofv0cUMFNIyDuLxMJwUZDODqPexgOm+euJf1pe0Px5RbfDjfKX6seJ61pEDY6Il5CD8qBMyvGWHvejg/Szqb8pjrXdK3+DWLkdAKGz4v2CXqP5xwYIzP6qLqLFceCGyS5SEMzp2e73tZomhuGdYNsYrWvqWxIvV37k6eOI8unfh5/G5vef9T18cE5bzP8UGYLy9opGBKg3JX9Tgc/AX89GiiR5a1bRWSK3DcZ0Am5kFxNUqe21RUYYC7APaZ9GwMRMnq4ksoJQoBTwu9UG8Kb+2zmAjXW/TjL2hzgCyp2ylnHvGmVD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 06:39:29PM +0100, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> A dirty folio is one which has been written to. A clean folio is its
> opposite. Since a clean folio has no user data, it can be freed under
> memory pressure.
> 
> memfd preservation with LUO saves the flag at preserve(). This is
> problematic. The folio might get dirtied later. Saving it at freeze()
> also doesn't work, since the dirty bit from PTE is normally synced at
> unmap and there might still be mappings of the file at freeze().
> 
> To see why this is a problem, say a folio is clean at preserve, but gets
> dirtied later. The serialized state of the folio will mark it as clean.
> After retrieve, the next kernel will see the folio as clean and might
> try to reclaim it under memory pressure. This will result in losing user
> data.
> 
> Mark all folios of the file as dirty, and always set the
> MEMFD_LUO_FOLIO_DIRTY flag. This comes with the side effect of making
> all clean folios un-reclaimable. This is a cost that has to be paid for
> participants of live update. It is not expected to be a common use case
> to preserve a lot of clean folios anyway.
> 
> Since the value of pfolio->flags is a constant now, drop the flags
> variable and set it directly.
> 
> Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
> Cc: stable@vger.kernel.org
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/memfd_luo.c | 26 +++++++++++++++++++++-----
>  1 file changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index ccbf1337f650..9eac02d06b5a 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
> @@ -146,7 +146,6 @@ static int memfd_luo_preserve_folios(struct file *file,
>  	for (i = 0; i < nr_folios; i++) {
>  		struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
>  		struct folio *folio = folios[i];
> -		unsigned int flags = 0;
>  
>  		err = kho_preserve_folio(folio);
>  		if (err)
> @@ -154,8 +153,26 @@ static int memfd_luo_preserve_folios(struct file *file,
>  
>  		folio_lock(folio);
>  
> -		if (folio_test_dirty(folio))
> -			flags |= MEMFD_LUO_FOLIO_DIRTY;
> +		/*
> +		 * A dirty folio is one which has been written to. A clean folio
> +		 * is its opposite. Since a clean folio does not carry user
> +		 * data, it can be freed by page reclaim under memory pressure.
> +		 *
> +		 * Saving the dirty flag at prepare() time doesn't work since it
> +		 * can change later. Saving it at freeze() also won't work
> +		 * because the dirty bit is normally synced at unmap and there
> +		 * might still be a mapping of the file at freeze().
> +		 *
> +		 * To see why this is a problem, say a folio is clean at
> +		 * preserve, but gets dirtied later. The pfolio flags will mark
> +		 * it as clean. After retrieve, the next kernel might try to
> +		 * reclaim this folio under memory pressure, losing user data.
> +		 *
> +		 * Unconditionally mark it dirty to avoid this problem. This
> +		 * comes at the cost of making clean folios un-reclaimable after
> +		 * live update.
> +		 */

Can we make the comment here shorter to only contain the gist of the issue?

> +		folio_mark_dirty(folio);
>  
>  		/*
>  		 * If the folio is not uptodate, it was fallocated but never
> @@ -174,12 +191,11 @@ static int memfd_luo_preserve_folios(struct file *file,
>  			flush_dcache_folio(folio);
>  			folio_mark_uptodate(folio);
>  		}
> -		flags |= MEMFD_LUO_FOLIO_UPTODATE;
>  
>  		folio_unlock(folio);
>  
>  		pfolio->pfn = folio_pfn(folio);
> -		pfolio->flags = flags;
> +		pfolio->flags = MEMFD_LUO_FOLIO_DIRTY | MEMFD_LUO_FOLIO_UPTODATE;
>  		pfolio->index = folio->index;
>  	}
>  
> -- 
> 2.53.0.371.g1d285c8824-goog
> 

-- 
Sincerely yours,
Mike.

