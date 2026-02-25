Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F15ACEFD20D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 08:53:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07E896B0093; Wed, 25 Feb 2026 03:53:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04EF66B00D1; Wed, 25 Feb 2026 03:53:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC7EA6B00D2; Wed, 25 Feb 2026 03:53:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DA6366B0093
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:53:39 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7027714048F
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:53:39 +0000 (UTC)
X-FDA: 84482365758.29.0E82BA8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id AFDF380007
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:53:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=icycVHHB;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772009617; a=rsa-sha256;
	cv=none;
	b=6G+0v7Sm2ogOLlwJ4A1/TSyrw9UydbGltostKDymE8BsamdwhEYDBSLz9KH6NTcbkzkJ6M
	FHXIvNz4Pu39PZvUvcuFoQl6z4Truui55iJppr3H7vn4pXtG3EIfn4E6+m73k0Tv3fkqFV
	EF9tkHYm3HRn/930jy0suR9bUrzhnqQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=icycVHHB;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772009617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UmPmEa7SSNc9Hc+xx6yeOemVQhqbPXhye0ICAtg1V8Q=;
	b=P9F9qyI40ntwyQyDA6Wtuy/XT5yUb7OnvDKCtquQ5f+Zpzh9MTEKZmXIryyqNUj2KAAhpR
	Wu0WE1rPWTfZPLjhkqhcu4bSgbt4aYnYdCt/aZO1lBF0Mepp6eMl2Wh02JcN9KHacR9n/b
	nfN03JiD7Zy4dQoJyaLUXdKAY4iTV/s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A8E864430F;
	Wed, 25 Feb 2026 08:53:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C336C116D0;
	Wed, 25 Feb 2026 08:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772009616;
	bh=5e/H/4vB41n/5YYIxm5Oxq/j6NJu0Yg2mNzLELZkuFE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=icycVHHB8aMnMr/HwvRS/5ti/Jab+BYAMwEV3W4YW/JwDDKygA/4G1zIpiU/zdqh/
	 pQ7Xip/pq3u+x7rjAl7i/S3E/3ZSNOQKXGEV9NgfuaJ+D3HUkIihdWhgIyDg6bN5ht
	 HqhSg6WlJAKjdsWe6lAA2U4WsEtHWp5zVemkHEmvAmYp67O1/KSzNXEaYR/Ec3US2P
	 uGPM0KVkVxvWDxFrlBZtdJlycNbIja8f+956maAm76K18ObYnocpCuqHuP+HbV/uDo
	 lipm7jFRE11l4MMwin9dc0+BRQHtDiWZZg7QZrTArizGs2dwxP3l9HeJL8FJMGVlRN
	 EhE6W74fQEhBg==
Date: Wed, 25 Feb 2026 10:53:30 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: memfd_luo: always make all folios uptodate
Message-ID: <aZ64ikDtz8tF_rFU@kernel.org>
References: <20260223173931.2221759-1-pratyush@kernel.org>
 <20260223173931.2221759-2-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260223173931.2221759-2-pratyush@kernel.org>
X-Rspamd-Queue-Id: AFDF380007
X-Stat-Signature: 7wsxh37189xa1zfhq13hb994xnd3spt6
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772009617-366971
X-HE-Meta: U2FsdGVkX18lTq6tUpzPTqG6x9t6A/IDoC68ZMeUj0GMfevuXk3Ye5CWZiej6zRF5K3ODR38yjtcv9BICz7EblVB7ntnDPMxzwMryDCV4LBqZWIXTGxEL5S9A14JBARmXhcRCv6BF0FfBQu5YkycDFXxbUk17CO5YMSiTePlB0iRpIcindMbEZsylt+JqCnCNDRavcnT10bY8ndW3JjFQH1vbKbfnGw+hghRA2JGA6L5/+qgGI26BdiqGwiHSQeKrSTqvOe+phGjdI+5LMXQJpNe1twoL/KUR7jwSCKTGJc8SgMVaQXepjS8Hj2dlpNhb8y0Ock7TvU3E/PRs2mYLR/7OmeCPXTJdu2hQ0ZuGk6WDZaB+Dbf7INlhaPA6dKggc/OVvt1AqoZhdKHNUzf4iu2I7KC0UmDlIw4pk4wKJdvdVd9D/C+V+IY8Bx/BMk30rMES6sa9JemuwJUtl/eIBkvNG5ZeQkZydDXAWTnz6DjMmTXhrLG+CZVp4rNQaTSwgqDOPdDAi2j6BDE7cWuocwOBKLKITlTNclr6GLDfvmATxRRTZuGXaFPTBJ1ehDLuXGBuV2eWZDY55pYp78Uoji4rH+Sjkn3AS+qI/N4K3BJZe8qLRhTjvRzmPATIjqkes5gWlTuspxnZnwOs06Juc5jPPa34kfME2es+T/W+nu81o9YqmzclbZkGI5kPWRNivp9PQmUMxLXuTc4zKZpQ5NKxzdroFW/iTXZ1yW208QzZe7S9JB7rPJ9iaX/umbJEHZBUCe8UGv7WJFrtjtOLJI/yuq8Trm6Y/5cIqgiNbtunxHNXIDC3OX8pbarP87TkzJUgWZowbFTZi02YhIN/JABM2sYlDdSSObFuctIuO4EX1kz/sji6TocsVSlnHxXek6vFH7bkXOi+dwx6hWIbnRY5mvSY3jHOqEidGwNN7dGbwQ/vQGQj8PZdS5MG3PxbUEUuWVniOgIClJnJeM
 zLqKcIxT
 dfWZa8mHphb2pc/VZM9XKYLK/Q3cGjogN76FKEMVJ5FXp//Yj5bgNTCnG9ty08nsTixllF6Pwd5F0DmLPNi04u5tCFLs0nMI8+MXR4Ct4Cyih1vbLO1wWZqanATMG8pLqvRQMF6QzsHtPCO0q3nOhrTHgEZoZJTHMWdzpubEuRf/lUDnztqNs+6I/mHT2imEaKr/Yto7bLciKbyZGOP0QQaqsDLFN3K77U12dLJsusfwj3V4Zz9BzSmGjHOSeF8thQNdt7NWFiQxtcfzdgX1mGuKIvPCbZl5fqe0IjEabeJYV2dcfJ+m6AJq1ZKY8qUO8OUUr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 06:39:28PM +0100, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> When a folio is added to a shmem file via fallocate, it is not zeroed on
> allocation. This is done as a performance optimization since it is
> possible the folio will never end up being used at all. When the folio
> is used, shmem checks for the uptodate flag, and if absent, zeroes the
> folio (and sets the flag) before returning to user.
> 
> With LUO, the flags of each folio are saved at preserve time. It is
> possible to have a memfd with some folios fallocated but not uptodate.
> For those, the uptodate flag doesn't get saved. The folios might later
> end up being used and become uptodate. They would get passed to the next
> kernel via KHO correctly since they did get preserved. But they won't
> have the MEMFD_LUO_FOLIO_UPTODATE flag.
> 
> This means that when the memfd is retrieved, the folios will be added to
> the shmem file without the uptodate flag. They will be zeroed before
> first use, losing the data in those folios.
> 
> Since we take a big performance hit in allocating, zeroing, and pinning
> all folios at prepare time anyway, take some more and zero all
> non-uptodate ones too.
> 
> Later when there is a stronger need to make prepare faster, this can be
> optimized.
> 
> To avoid racing with another uptodate operation, take the folio lock.
> 
> Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
> Cc: stable@vger.kernel.org
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/memfd_luo.c | 25 +++++++++++++++++++++++--
>  1 file changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index a34fccc23b6a..ccbf1337f650 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
> @@ -152,10 +152,31 @@ static int memfd_luo_preserve_folios(struct file *file,
>  		if (err)
>  			goto err_unpreserve;
>  
> +		folio_lock(folio);
> +
>  		if (folio_test_dirty(folio))
>  			flags |= MEMFD_LUO_FOLIO_DIRTY;
> -		if (folio_test_uptodate(folio))
> -			flags |= MEMFD_LUO_FOLIO_UPTODATE;
> +
> +		/*
> +		 * If the folio is not uptodate, it was fallocated but never
> +		 * used. Saving this flag at prepare() doesn't work since it
> +		 * might change later when someone uses the folio.
> +		 *
> +		 * Since we have taken the performance penalty of allocating,
> +		 * zeroing, and pinning all the folios in the holes, take a bit
> +		 * more and zero all non-uptodate folios too.
> +		 *
> +		 * NOTE: For someone looking to improve preserve performance,
> +		 * this is a good place to look.

I'd add a larger comment above memfd_luo_preserve_folios() that says that
it allocates, pins etc and fold the last two paragraphs of this comment
there.

> +		 */
> +		if (!folio_test_uptodate(folio)) {
> +			folio_zero_range(folio, 0, folio_size(folio));
> +			flush_dcache_folio(folio);
> +			folio_mark_uptodate(folio);
> +		}
> +		flags |= MEMFD_LUO_FOLIO_UPTODATE;
> +
> +		folio_unlock(folio);
>  
>  		pfolio->pfn = folio_pfn(folio);
>  		pfolio->flags = flags;
> -- 
> 2.53.0.371.g1d285c8824-goog
> 

-- 
Sincerely yours,
Mike.

