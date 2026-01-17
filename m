Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97D83D4A5F5
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 03:49:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B18196B0005; Fri, 16 Jan 2026 22:49:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC6356B0088; Fri, 16 Jan 2026 22:49:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D2706B0089; Fri, 16 Jan 2026 22:49:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 89CB46B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 22:49:03 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 28D11B8059
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 03:49:03 +0000 (UTC)
X-FDA: 84340074966.07.00DE25B
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3B3E78000A
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 03:49:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=bLltLxd6;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768621741; a=rsa-sha256;
	cv=none;
	b=533GJkohHbRBVqmRFk5FbjAiw/Ww83mp6nEmPpdqt602Wr6lWjE2/oxnbwarz/XRW6HaVA
	cBQIZKL0004Y031prYehfTbs4JC79pN0c02d9nefMj8lXjkFCKL1ufOu0uMVdb8LkXnOqi
	I9ogFHeznoUb5HpIlP/IjOsa/DM1SXM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=bLltLxd6;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768621741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=riXo1BQ3I0fe8TDA3vfeoZscBYb4UD1VI8MzLsimtGw=;
	b=iCOKT8oD4XikyIjTTz2jdx0DW6d2kViWFUPivoU+gFVEbjoq+CkVMHvjpSheBcql8hdD22
	rhKGqzcRamFL6cR5Y/mbi3UPE2Ok+3E4dMKxHeVOON1vkEa2LTORbJ0Q2Xj57jHrKiJcRl
	G849mFBgtY+0QFF4baZ/qhorBdjbC+M=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-81f223c70d8so2285866b3a.1
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 19:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1768621740; x=1769226540; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=riXo1BQ3I0fe8TDA3vfeoZscBYb4UD1VI8MzLsimtGw=;
        b=bLltLxd65Mkmm7IC5eEmFe53/VvAzFlcIQvD78Tjb6BUIiQGAeb9nukdemkYXowXRk
         mALlbIY2mC9hl38MVQoUgatFkYRebY78qEwNa/5CYgoJbG3I50fAhS0BVX2ArI6/Y36Q
         5i/BL+sKRHvyav62VXvFS4ern473uXBcoWerw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768621740; x=1769226540;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=riXo1BQ3I0fe8TDA3vfeoZscBYb4UD1VI8MzLsimtGw=;
        b=bcqFD+oVYZyJWtiaPQNC1TJrgdx8+juz39KBdCdnOxP1sSb+OyWpC4afFifP0c1t6P
         0ReG2srM81el82iOZsHe8+J3Gg0JoaKAiy3Rbg68D4d1i0mUpSjALfqZYN3E0DECTQYO
         2qEuuMApmIVh+4aqduGBQDG+h/9BOKBFXD8Rqa2eDKGI19pSbgSoDYzhi+ytiznH9E4H
         GvqsJcbGnhoUYO9k7RlQhsuqa7unzisj1awEgHqNfMMhZKfAt/HXY4xp7pt2H8+zegq1
         XcU3mACu7cwWqfXdIcgS1C23rllNGf42WdP1fgmqs+xgUX9JfTSMdIthkGfOgzHFArsH
         NosA==
X-Forwarded-Encrypted: i=1; AJvYcCV9xKHuRTUtU+pEIliOHmdOZ8PxhMK0tcmd3I92jWiBkI1mCbkrmVSDlM1AKzKxn7SCsSItOZJrrA==@kvack.org
X-Gm-Message-State: AOJu0Yw1Gs/EUJ0cgk/hVIBreJdPGyttnLJP61Giet5nLeyVW096r4o7
	LiUINlVJEKF2qzskXvTryMrQ9DeBpiZI48jkMNJNhV1DWwVuwlnjmv+JsTXh3WtRBA==
X-Gm-Gg: AY/fxX7VK51M6SCfbNMTNJFtmNhv2vwXl9L+lBEuG3ZU3e0wA/NgDXLBZaSmy9qKz/X
	1UdQQ9lpx4e+ZXlqYCnDpsFPUiWZNvDfyHBs/pWeldDGEsUK/IgG1lLaRY6AgTZ7tQ7fxrlhpNl
	59HRI0HjAaazRAcGtvpNsFse5lAiAzXeHwrS18WMe+ttuGzKgPYceSCrb7IeKu9bTs8CmG3I2ay
	ErLTLJsL+MHDTixIWFN6pKy1Dav0PDFkv5vy02jRjZYpIPAsRT4BpWKXJ+rRfaDUBWwu+63I3O6
	+OijnafG7Yv0Xx7ip7uUnRu2E02Eim153d+RiAd8x6iwERO/VyJ3rwXhMHkVZvT8ZhHB9INP6Ur
	LU/YxAcnOcgsN2mMfxFEp5h1VO78K0kWAQoatjuGTzYhmk/LMW0Da9Jx2KyAQEhZ1pgzCdUCRVQ
	UXK3fplHlYYRnbvzKbEgkvQDzhPcOcQMQSUeErvGQNFryq7n3TN0tSBcsKV3I1fQ==
X-Received: by 2002:a05:6a00:2295:b0:81f:7e24:44e9 with SMTP id d2e1a72fcca58-81fa1887c82mr3854207b3a.70.1768621740007;
        Fri, 16 Jan 2026 19:49:00 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:fb0f:ccef:d815:5581])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81fa1277966sm3207152b3a.31.2026.01.16.19.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 19:48:59 -0800 (PST)
Date: Sat, 17 Jan 2026 12:48:53 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] zsmalloc: introduce SG-list based object read API
Message-ID: <gu5dej7cnw47xr7abuuksqocwt7k25tqad55t3jqwgl2pa4mlr@2kdf5fpy7cbj>
References: <20260113034645.2729998-1-senozhatsky@chromium.org>
 <wb2shm35vigisxnokcp3pw3yzu32kezo3ox2v3xu2u5lnxo45n@ktccxxzg2vsc>
 <nj73lvrjul6h7p7qx2t2pqt3zmcrn3zwdvb7ri7rgzfntjzv3t@nghi7tgq5zvn>
 <f24061e372edefd7b70490effd18b646c72ff9fa@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f24061e372edefd7b70490effd18b646c72ff9fa@linux.dev>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3B3E78000A
X-Stat-Signature: 358n75enpu37atw96dbrr1d1ipeoq4zh
X-Rspam-User: 
X-HE-Tag: 1768621741-433052
X-HE-Meta: U2FsdGVkX1/4C4T4GgcS2rvxeOZAkZxqWNmqVnw/SouVVB6aeer2Py4ZrexyAYk2+uR1ezfTy585GmuMBK9eegkXrfDm2txVTRvuEZurS+Lq3bE4G9aXJZ7tCQHJeL2QYsEskgqdugGOzgjSnR9ChvmJ/yyLxZUFyuLBVaSUlirXAmLnyZUEhQj+s8CKiP1s5+JqQSw4cWXFPyJIbUlHAjaemkBL1PIB5UlIukHV8zjx2c+nenKkgQsZtSTSN1dnVsKYWUyUZEcZgYZvPSE+Q1Wt9o1Owzs8u7wZoUECpqONQiC9q3wMb9e/bhjZ0OUqPJfR0yCJ1iD/mb1FPHtBYngDZGUbXyU/nCcEK6liGYGZ0xtJL43+0/JQrlqEEBbWjqS2Mzb4DToBdzXy0Y5yinZAmkaJY25rQYvInsH5gXFBuCXrVeiaoIbuLhj8WJUvEJQ3FePD2pQfXMlEc+Hov0wzIfa2bPsfHAZ+V5xQL1V9aScnye0d8eHPyMkXG85anr4+1b4UmQlXqhqSsWV22w42YS0ZMP4b8LsDCc4+a4uJvG1mAULFkoD7r7lIoLBR8aQknw1LOyf6N46PEIWPzwjZyKmJJhzIQU3EY3/wefmGQ5kxBZ/Jqtlo2kpyIfoj+QThnpykv2AQiUtbVp/cDL2lkJngGUgOvA/VQLsOruxLLQQKyNSWYCaF+OinfhLinSW+xtr31qStezR/J2ydrFfxS+frlXBXPZHry/i0/T6EMc7VSRzKcrzUUPL8b5NUVOyXXko8prTGXqk9qcz2KWdsbZrQ1t52zxX3lJz7XyMsjwjWIbREuTxp24oI1w/sSAWCJhatZIC5hXiV52ugIxSWJhIsZSlVa+F9CzLkMbrIA4+Fqh9wFjUwPp1SzAsaCioTFzBJYCNzq3h+luT27j8KBem2+GI0nvXv0RxL+paqItWQJY8GBjNMAsXfFguur0GMInNdtjdDrjfzs3z
 mN2OZbuF
 VCY3AWcV+ZD5rPx/DyrpMU5BpIRdJEeU9fIMIUpTzXZtY2Fekp5JgAYNyYk28s8L/RMco0+guUSLTUR6wWg4CZNxVnOKAIJNcbVJKjfbku6M1L5gnajMPTUas9czNMVE4rvRZA8hoeiSg//ezlcjlFt/ABM9WDRvj/NtpCR1+JHyRD9A1EFjZAzYCSNpktLvlpvFyTwC5Mfclic1znB7WbAKuvMahq20izZkKCYzu1V8p0uq6Bc+/9+pEbDtPsebRxUh9tfASr8b1O8cBq2JYb3fqqBPQWkUuNSJw0TiORobxD+yIXXt4GiJCjaVhDyXGXSkuexVHJnlQ0/RSYufzrzU7EHhSyZ9ZhQQff0Mu0WMYwMU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/17 03:23), Yosry Ahmed wrote:
> > > There is a lot of duplication between this and zs_obj_read_begin(). I
> > >  wanted to create a common helper for them both that returns the zpdesc
> > >  and offset, but we cannot do the same on the read end side as the unlock
> > >  needs to happen after kunmap() in zs_obj_read_end().
> > >  
> > >  Putting parts of this code in helpers makes it a bit obscure due to the
> > >  locking rules :/
> > >  
> > >  I wonder if we can drop zs_obj_read_*() and move the spanning logic into
> > >  zram. Looking at zram code, seems like read_from_zspool_raw() and
> > >  read_incompressible_page() just copy the return address, so I think they
> > >  can trivially move to using the SG list helpers and
> > >  memcpy_from_sglist().
> > >  
> > >  The only non-trivial caller is read_compressed_page(), because it passes
> > >  the compressed object to zcomp. So I think we only need to handle the
> > >  linearization there, something like this (completely untested):
> > > 
> > So I was thinking about leaving things as they currently are for this
> > dev cycle, because both zram and zsmalloc have enough of new code queued
> > up. If you don't mind let's remove memcpy() API and convert zram during
> > next cycle (after the upcoming merge window).
> 
> Sure. I think we can do all of it in a single series for the next cycle.
> Add SG interfaces, convert zswap and zram, and remove the old interfaces.

Technically zswap doesn't have to wait for zram, and you can convert
it now, but I don't have any objections to doing both in one series
for the next cycle, sounds good to me.

