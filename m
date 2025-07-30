Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A01C83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 17:45:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F8C66B0093; Wed, 30 Jul 2025 13:45:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D16E6B0096; Wed, 30 Jul 2025 13:45:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60E146B0098; Wed, 30 Jul 2025 13:45:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 559326B0093
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 13:45:13 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA74A80741
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 17:45:12 +0000 (UTC)
X-FDA: 83721657264.05.99CAE67
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf12.hostedemail.com (Postfix) with ESMTP id 54FFB4000D
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 17:45:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JEP1lFUj;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753897511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hcnmGYLBaauTvnHPq2KiUHAVZoxDqvGssf3c58Pytc8=;
	b=nKHZWvwTP9AjTRWXDM7XXI2Dww6krHr+L16cZ4dFRD6fAHXlHC/uBKkakwIUvK7aEjf/P5
	Axr0W9+AgltOSJuZENoMUeZE31h0pGr+l0Flv8JjyD33fvLa1RYboUTjQDxnkI+XYCfeYE
	qLDcurE8vDUsAH5EonfNxMWmM5c5P5E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753897511; a=rsa-sha256;
	cv=none;
	b=GArBvxHpEm1tPfnXtJ5Unm6GDWUZBkpCx3bVPHL3ejzzEek/R/LvCoAxRg7cK8wMJDSHI8
	Y7CsfmO063+X6mnkewR3+HkGeM9y59AXoBNNjUDtCLjrFAKtJ3J44iergv6sqyhzNzEN8j
	IIPEXMgam9AhT3tEf4ifOkf87qG3IvE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JEP1lFUj;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 8F4B8A55410;
	Wed, 30 Jul 2025 17:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10487C4CEE3;
	Wed, 30 Jul 2025 17:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753897510;
	bh=hs1BG8aT9FKJxFJ3orJrSyaFQ690x26pRpZbi29Wndk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JEP1lFUjEuHDMz5py9iUrVsEfEUE3+316GPzop2YCr8II6veIhr+2UKp3+HveEOt4
	 McQndkN1Kv7EJVlTixbMJXxm4E51Dh9egxNyDeAdyYYY9BJocgN4F4s/wnO7virAn2
	 gunidqgh+rTFBKl9cIDmX9H3a0j02bihNJ7LCDm47V4nZz/RyJ3Q4hDCmaV9SPQrJc
	 X8wgSv62S+FnIk/OMBvPACfPGDalOkBwzkS0iyU/WX67vHEqZAWzE1Ynm9105LLd4i
	 V1dhUvlBjvaKkaqpNpGtHIqoBjmI8Sedasm4GzRWBj1B8SX55DpwRpYgEgQ8xvkxSU
	 cqwtdcytBispw==
From: SeongJae Park <sj@kernel.org>
To: Yueyang Pan <pyyjason@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/damon: Move has filter to ops-common
Date: Wed, 30 Jul 2025 10:45:06 -0700
Message-Id: <20250730174506.60001-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <06734aa15198e542f9defbc1d29fc0731671c3d8.1753895066.git.pyyjason@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 54FFB4000D
X-Stat-Signature: 8ym4zbmsco7comdgsc7zchfmhjian8rq
X-Rspam-User: 
X-HE-Tag: 1753897511-681673
X-HE-Meta: U2FsdGVkX1/CtdS/ApBwI4nQNuYhXpkAi0WAW8Xgc0QkYLmfrLkUVFqNsJLSRr8RumjN3+iXs4Q+d1ASQJy8C0oN6XAFc2Hi5OpA1xSLszXYwegmgHopAA2+b5DlPZ1zB4f4kHyLnV3zzoK/EmNINenTxcPKL0i374PAwhDgXYMgnxyx2p9iyJf0AaXl2n6wQNj3gBgF4nYDDjZ0HqKxW06yYxSB/72GSmvKmKzroZZH1rbxw4CyhXZ5TXpSsLUqigdRVtCzI+aWIS0Mvu71GlG6c0lQfuJylu43MW2wQTndbUCJC28AjBOTOzZq6SNU4Uc9NsxBeQpwXBw3xMexhwO31GURMFoEO7OrtKa2wR3RXRZqFlVr1NCXci3TOyXvqS8TX/dzM8vD5NCO/lGJkQnArYV9TVv9JbndV5BxeIapP6e43Ee10IIRuTZqOmdgaTQnLED8pT1xTEs9uvjefjNGkBzk1StIi/ZHSnmV5k/MIl6YzeWQJLFkrT+JX5tJtsLwABmJxttRA8RStqRIHaGS4lJ0Z9DLKx5S9J1dOD5DuFBfVt+S3DqI/gNj6iDs6iLHSN3LX4Rem3kXsUloGGIi8woZWGYWJgTo01CDY1xtYDJn5HPRtg6j0JuLaDCbbh39dPwfi6xPVd0V+rLwjA9pTvIzYdIZ4r+hTggUgMJpu8XFz+Ik5claKeQsQoTjbVI3VPVq5G3o0Px6gg1rnZsKwPqor0i0NddJVUlQRD/oDcSYri7b9uBHLTA3blMgdOXRaHkPqrNR6593F8R3VQtuqBCYDA4qBrDn/GwY9rbSVCEBpZ/qyvYbY33oO2Sp1h7wXvXAIfykO2V3khyftAE7LmIBnSy60mpzBnRTOy3Qd52zjzNh++SnyHgik5iM6IIX37D9jUfhXsJK96LyorthLB0ctxErUWhtq9TmmjdcTqQrOmOuLJ1+llpK6enqdBt5JYlzxkeyxFaILOa
 8+m72GsM
 Px5/PHZit9NNr1K83FeK7PcXaacLhENUFVE7dzlZ0RQAVye50QR2647xZ9phMpJa3kay07u2J4G/P+hQAxuKaKO6zj7Rzs2RoOJx38vVn4e8tZEWxoqZ/sbgjx7iKpsQWDzWoGdoT1YOimVSljDZfAaTI3Px6KkKMNgG0yMm+3tN9XK1FL2YxGQGxSW5HoUw9PYxwgRyNmYXTeHh+tKAWi1KC1toHiRIl0cFVRwhT8jX3oc4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 30 Jul 2025 10:19:55 -0700 Yueyang Pan <pyyjason@gmail.com> wrote:

> This patch moves damon_pa_scheme_has_filter to ops-common. renaming
> to damon_scheme_has_filter.
> Doing so allows us to reuse its logic in the vaddr version
> of DAMOS_STAT
> 
> Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
> ---
>  mm/damon/ops-common.c |  9 +++++++++
>  mm/damon/ops-common.h |  2 ++
>  mm/damon/paddr.c      | 11 +----------
>  3 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
> index 99321ff5cb92..3ebfa356ca46 100644
> --- a/mm/damon/ops-common.c
> +++ b/mm/damon/ops-common.c
> @@ -412,3 +412,12 @@ unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid)
>  
>  	return nr_migrated;
>  }
> +
> +bool damon_scheme_has_filter(struct damos *s)
> +{
> +	struct damos_filter *f;
> +
> +	damos_for_each_ops_filter(f, s)
> +		return true;
> +	return false;
> +}

I should have tell this earlier, sorry.  I now think it would be good to have
ops-common.c own prefix, since this namee makes me expect the function is on
DAMON core layer.  Also, I use normal 'grep' and ctags at the best, and maybe
I'm not the only one that that lazy at learning new tools.

Following the weird and none-public naming convention we have on DAMON,
damos_ops_ for DAMOS-related functions and damon_ops_ for monitoring-related
functions would be the prefix for ops-common.c.

So, what about renaming this to damos_ops_has_filter() if we have a chance to
revision this once again?

> diff --git a/mm/damon/ops-common.h b/mm/damon/ops-common.h
> index 61ad54aaf256..8d5c5c7631ac 100644
> --- a/mm/damon/ops-common.h
> +++ b/mm/damon/ops-common.h
> @@ -21,3 +21,5 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
>  
>  bool damos_folio_filter_match(struct damos_filter *filter, struct folio *folio);
>  unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid);
> +
> +bool damon_scheme_has_filter(struct damos *s);
> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> index 53a55c5114fb..daeceed981a0 100644
> --- a/mm/damon/paddr.c
> +++ b/mm/damon/paddr.c
> @@ -262,22 +262,13 @@ static unsigned long damon_pa_migrate(struct damon_region *r, struct damos *s,
>  	return applied * PAGE_SIZE;
>  }
>  
> -static bool damon_pa_scheme_has_filter(struct damos *s)
> -{
> -	struct damos_filter *f;
> -
> -	damos_for_each_ops_filter(f, s)
> -		return true;
> -	return false;
> -}
> -
>  static unsigned long damon_pa_stat(struct damon_region *r, struct damos *s,
>  		unsigned long *sz_filter_passed)
>  {
>  	unsigned long addr;
>  	struct folio *folio;
>  
> -	if (!damon_pa_scheme_has_filter(s))
> +	if (!damon_scheme_has_filter(s))
>  		return 0;
>  
>  	addr = r->ar.start;
> -- 
> 2.47.3

Otherwise, all looks good to me.


Thanks,
SJ

