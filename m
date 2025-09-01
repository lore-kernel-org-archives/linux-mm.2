Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35824CA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 23:51:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BFB58E000E; Mon,  1 Sep 2025 19:51:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 596D78E0002; Mon,  1 Sep 2025 19:51:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D38B8E000E; Mon,  1 Sep 2025 19:51:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C17D8E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 19:51:13 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B39F7BC9BA
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 23:51:12 +0000 (UTC)
X-FDA: 83842329984.12.B4FF693
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id E5B564000A
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 23:51:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Vn3cgA5G;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756770670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nqIHNFoYLFHKJhJTPf2NISmNl0Wnj/vp/3ZJmR5d4Fg=;
	b=z8oYFEOCcf6VzqiTXpygyKqH1Fa/2KGhh/1XbTBeJSRH6wkYP+/iLhM3lzYI0ZlBYUfS0a
	iqeNjn0XF6ptCfx+2elb1P8kPljfTri9goCWLpc4gncW0Dvs7Ozyf4KXNwvzSAmBG4oKtg
	31uOkdrOWkMpsUXb92W9oFhTxX8VM4E=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Vn3cgA5G;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756770670; a=rsa-sha256;
	cv=none;
	b=R9WonuchG2cyhBowD3blVAPUKUAxeYaGHCX5m3dg6M0xA7We/2eUgrx+d/9ZAr9vDBCiss
	44BLsJvg0vuKU9qxJ1zfx8jh+a+AlJHHUZO92WjL0e4gNjRPbcZfuzPG92U2slBnCL5d8b
	d3wv15FuRLfYlMsFydi3wVAquSHyJgE=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8072bb631daso593085a.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 16:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756770670; x=1757375470; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nqIHNFoYLFHKJhJTPf2NISmNl0Wnj/vp/3ZJmR5d4Fg=;
        b=Vn3cgA5GZyi1rp/SCEhe7gBWkh712sVsfxMJ5oKBI7DPZQ0ToMVJwtchy0eLLbACOs
         mdbUyOT8vXTyzGH5nQHEICiLboU1c356F968FtYd1hw3bHC3yyIB8pBkAWjUjUsI+wpb
         LHkyPzkBQWe66IUrNN5lHfdd8TngAIFPRw6/WP0FXxwawrQh9uVCl4clYngbbnFHLnGp
         VAtT/xGgWJXQ5XZliohdCJ4m0NMrCAU/DSLiv55V5O1MkjLkwwoaBkJA0Kn0yV9FBkoL
         EAjuV1cRkbV5HDNJzwucZOVYZ+uZvQZlF1SjjERyTJYWVXeO6ASdxWgETd6zWezaAmd9
         kXnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756770670; x=1757375470;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nqIHNFoYLFHKJhJTPf2NISmNl0Wnj/vp/3ZJmR5d4Fg=;
        b=lTKrX2BoYPe5OS6vbUWPjzmsj1nRZmE4g1ZkOqcHsz0D8N9l9NDx6hnEtHl8B7x2HT
         G3irPGi/P71BwKi0rFWAzAF6iCi10tfdJ9wXC0jWmkoxRMv8zNRZrkwiQPe2kOgPfnnu
         tA7B49/ufhyM6S2dmvLq2I0th38F+gYaBb2Q6vHK7HxjQPzGpYmdTA87V+y6OVFeYwKh
         bOqmB1J6FJYIAoOAFGOippo0yleqdFNNtskGm3CLGEiUxPtkL6CGzfB6Nvtuw8Nat1xK
         ypZiTb+A46pNnQmII0eyr6Aldr+Jl3KcrlF15/sO95zoZPhjVxndm81MddbXBIsQesmm
         F3RA==
X-Gm-Message-State: AOJu0YzaDuVRokUcAX3vOyPDLi3eGANG+CsNnmKrjtS8phtE/fpO6qIh
	iMg5TzRUqi2xSvuhL8wwJHeK/YOJij/jxpypIFC6jYXc/fC3SzvikN4LslPLMI0wQAACNBYXXdj
	4iKp6iqRRSra1q3lsqjx84V7WGZlCS8o=
X-Gm-Gg: ASbGncsladO7KJwx6+Jn/r3mqdqCIZ9YD8lKIkCDAo3c94h5PYG8pSkOw+7581zJsO9
	j/hYmiXT0dU3/NHhwGkqOScAUs+GWke+aIpJqNkR1lOGx1xh8xSrlKlGFJ88zKNBunF9bIOtt/Y
	bdEzsE1e8+gIrBtZzx0xJTqs2AMjJBWn0no+x7s3sYbuGGNVb79RMaa9daNzzkYyhCHIrALsqpy
	cLJAnZ6Q9vpNELuGA==
X-Google-Smtp-Source: AGHT+IFEljUaTil2+CEYlRXkXKAo+TnC+CteD5ohkve5fALgKeduVJE5mcFQyP1+j0xsB7Wac6Acd0GFwDcqkZ7qAh0=
X-Received: by 2002:a05:620a:a80a:b0:801:a5f7:1645 with SMTP id
 af79cd13be357-801a5f71a68mr586445885a.85.1756770669823; Mon, 01 Sep 2025
 16:51:09 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-2-ryncsn@gmail.com>
In-Reply-To: <20250822192023.13477-2-ryncsn@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 2 Sep 2025 07:50:57 +0800
X-Gm-Features: Ac12FXxqtGbLYCOlRJLl0vKc6QhZHbL5Ut-TDLRHKuwjm64bxLdZG0Cg3nR9zxY
Message-ID: <CAGsJ_4xoN35Av2H70o+dwGzhKrAnm7gppEseG0MgAUPQt2TygQ@mail.gmail.com>
Subject: Re: [PATCH 1/9] mm, swap: use unified helper for swap cache look up
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E5B564000A
X-Stat-Signature: wixp85qjcfihqa834atisje9rfh4eo6m
X-Rspam-User: 
X-HE-Tag: 1756770670-315751
X-HE-Meta: U2FsdGVkX1/uiITtdfjuyNFgAhy2hN0SeIs5wqI65ibqi4IE+rlERR+jjDT8qTnLWYzbTtsRNB5P7Sg6kVvUwyAmQ4Q+LhSrAQKgTig+oRI+p9rv8kDqPSgsu7CplM4B9tjemROg2w0+4b/Hc8XBilr1E9EkQTC65zMOO1EyIXHCz0TAaMlM4pDqGwabZc4oswLngTtOgl3uABypujk5RcgowUCjU8IAUYRjpYyPq6s3gymCThD1uO+wBURU7SYw8S/2prXAHTTtKd07n4wGVfCpa0aEL0XRhkJuXBL3JDAUP8200aC3SDGbAEEWtgVGcl92zjJj6u3nPZGEXQDiDytgTrnJt4PTXDvba6BDkvY23WyA1B9OV0pVRyciriOc+4m9wK/7GyulNzRUS2YQUFErPd12S/2OFsE/rm5/lCfum/YeKddowHx8VZDHlNpEUv3credZ+Y5SJqB+dTEJmTCMZmJX2A4XUuPdR0vvrX03oC5NHYsnkCpH10ks0HRwm/mr7rFh6I18J8HnfkLv6+8STvGZOptaWT2xJcyBMdgBDlW0SGF8+kDeeURjcMkxwxNlHk4zrScxh25iBwXfROLsXaCwUO8p1wRtqqrM8By2/3pwNcS95V336++zarpyh6xyVQrP2CrAYBIXx7M+EPV1pVSigZwmzaxQ8bSBSGaLM9YcFp1XuVteqvgeBZQLOZLN4UyYSkTxOG6OlfyVqhazQrvASHj5dQo+xL5vKRh8UJ1+A9O1B1v92dWW09VMev819lqtQ7R95ZLCsJa1mfbYDmJ2ytAZlyGWqHATMh16GHTkkvMHFX7k8uHxaihQFaJ0oGN0t0+vCio4K1NypwvpvdMj/HgDXp+4pheTsGvAd7jJ+q+nw02xwBEN1cGvuGy5S7fp05CUsN1Frhj9KtNzrptT4PQV8u2V4sUymg0n2fdi7vKKsOlfb5H3jyNqauq1cLwi+R77KtoTNRH
 KWQG2HDo
 PtnLEKwvnlESzEXuyfY+OMZlTd6AA2GnaCbIdkWwTrefZWkcc0HYEU9b3AS/THh7ZLlxQ5C/XMaEeKBpJ5LqUOQkp3K/RLz8RS/OmIE3BSBhzIX8XPWmY75+4lDYBZ7oy4Lc8EFEV+AZf7egR6DfQ49HQ5QkS6oiumhX5P/9NS7eYvK53Fbcdg2ZPp0J+keVjfZwPyMjTtgr3/tIJ6fwqjHAkzpPdwkkYVy0HsqGaRbyQDDpOI2YNlmDPwG62/DXFrrJACcc6y+YVsJtfgETgQ/eUOgCTDpt0jxu1/7YaEdnTxqQ19jZuCWt3PGzF2l4nDxkWu5v/EaGGPjHdVfvBpB0yDcfOuwVi/ZBKaAw3hEAjiawmMzsikUVFJYCpGBLWEPLDd+Elt5ecH2vqrms88dfOUhS225Dsy0BEWadoswA1niA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 23, 2025 at 3:20=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> Always use swap_cache_get_folio for swap cache folio look up. The reason
> we are not using it in all places is that it also updates the readahead
> info, and some callsites want to avoid that.
>
> So decouple readahead update with swap cache lookup into a standalone
> helper, let the caller call the readahead update helper if that's
> needed. And convert all swap cache lookups to use swap_cache_get_folio.
>
> After this commit, there are only three special cases for accessing swap
> cache space now: huge memory splitting, migration and shmem replacing,
> because they need to lock the Xarray. Following commits will wrap their
> accesses to the swap cache too with special helpers.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Nice! This has cleaned up the confusing mix of using
swap_cache_get_folio with VMA, filemap_get_entry,
swap_cache_get_folio without VMA, and filemap_get_folio.

Reviewed-by: Barry Song <baohua@kernel.org>

Do we have any potential "dropbehind" cases for anonymous folios?
I guess not for now.

__filemap_get_folio()
{
        if (folio_test_dropbehind(folio) && !(fgp_flags & FGP_DONTCACHE))
                folio_clear_dropbehind(folio);
}

Can we mention something about it in the changelog?

Best regards
Barry

