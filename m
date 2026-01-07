Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DF35CF6BE2
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 02:20:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1AE46B0092; Tue,  6 Jan 2026 21:20:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBFED6B0093; Tue,  6 Jan 2026 21:20:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAA136B0095; Tue,  6 Jan 2026 21:20:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B9FBB6B0092
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:20:29 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4B6ED8E4B3
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:20:29 +0000 (UTC)
X-FDA: 84303563778.28.B676C38
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5AEC8160005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:20:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Mb16m1Iq;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767752427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kyamK7RkppmW+be/7RtUdUY+bM77EJqLKXxMYHIKow4=;
	b=C+cJA/BILdZcUWctUxwQT6hVQjORkRmUps4hcy/R2qM7dTWAkwCar5oL5hqkAlu0boPaXy
	o3EiNGE80V15QdoHJHHR612bdvEEFOcCm8BY3C0me4psmy/eSQCu3We+rs94d91U8uY3SU
	0LsqOhzbAe3s7VGB0Y3GlaqwKxHsnCU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Mb16m1Iq;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767752427; a=rsa-sha256;
	cv=none;
	b=egk8yYZ6l4y2HraTYozkmnxwOKZ4MkI5/DVRUsjNhEYne31Y6y5lyV6EhqKg9APVhEWhEv
	h/G5PM6HuDvftANHGzdmInqD9kfOFn3ctWSuQhGs3Ti8pCeOtdczwzuCdtFC9Obs+300ms
	699t3TLKryfwnPL723653S8GDDWW6lw=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7b7828bf7bcso1486536b3a.2
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 18:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1767752426; x=1768357226; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kyamK7RkppmW+be/7RtUdUY+bM77EJqLKXxMYHIKow4=;
        b=Mb16m1IqAbzLcbclwguH16YCp+yTom1DCAip1CWQ2gvJfwmLQLpGqH68uUF3gWtvDE
         ZERFlfMi/u+VWGHv8axohp0vFuZzCofHZEm3BF8rzxCVYm/fneWwbFVvb5MZ26dsyWFn
         bDuxS63m47yBZ29KWyi0MHcjqWaDCNupj+iMw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767752426; x=1768357226;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kyamK7RkppmW+be/7RtUdUY+bM77EJqLKXxMYHIKow4=;
        b=G9gbAUceU6oBfkZGiYtT4Cn158fNvoec6T4BU90pQHWJR/2//T0wtA7Yh17to8J8db
         hwqn++u2mBVYuDHhQGj1GIGOHkIUeIftUPBaTDl5Ls0ONc3/iwkZY6DrY89jZNJNcBTo
         SxxP/4AlNq6s823TADnmIcpia/j1k9zRiv1cCGWX7Qxa9PPeXOi2E4Nr8YrVMBpVfYz9
         7E8gZ2QRxT7VJqjvlEMkUlE9zpzy9B4/h+x6YCv9cVuAGl1ZCZVoiwp7v0jWrRKjueYl
         9qCqbE6Cp4Mt0gQPyQe+xlctrCxE++yPwRD+KTgabm9p+QPMvIeJBdS6ogDZewXddzqV
         maHA==
X-Forwarded-Encrypted: i=1; AJvYcCVq8Ssn+9+2d/8AhDnhJ+rWifkRAIb2OT+LDf+rAPPfP3pFCWOSoh4rTdW8tN2or3f3b8s2cbwt8Q==@kvack.org
X-Gm-Message-State: AOJu0YwuFKyhaWDswicQYd4uEFqPYEQmMi30ZOcZk+G8GPokx0m5O6Bt
	QP3lz6KkFZ0eXFOnAiyRwPDih/Hx3jl2ECqrW40fMr7aHajZJ0QSrJGoFrxA8BJr8w==
X-Gm-Gg: AY/fxX7uhzI800FpXmne/sZqtxIN9gBDkd+sZ08LC2tnQVhGyooyah6HC2u4OXLNA0b
	TGJSjZX/6cFwK7e/Aqe4XsmZxZC3jZYoiqzYHpt13WaLUHI41Di4H9J302pG9FhdIqnsZ/dr2/9
	2wTAERslWo3oCiIuaxJ1vs1Ww480c5j7rFe1iNnDQS8DjGpTMZlGngqD97NAcEIo7A2haD9q/of
	UYx34SFWVfxU+kQOOBjxT0VGQBkVb4EECu8ZtsryvN05BifZq+QO824+eOGiUfqoKlOWLuyF3QB
	OD2BQXzZ8NNPc77J0E2CQ4on2uKxPH1p7HfgqOBnCIY2fQ7mbueCQU88CYX3l4HVScKaKg3J8LV
	aWEbZSOfrU4lFdof+IaUn18zxSHHJmkE8qllEeUjzurICigRLy6wM8XF1CDUnw4VpglLv/7hJBX
	9nairqHN2B6eUCwunIEwLBBjv5PMViVHmKSwysY10PX2cEb3k6hPQ=
X-Google-Smtp-Source: AGHT+IG0LzjW/HWtgPrUYTug4UTW5kMasHeS7U/lh25a6v6kjNKp8Kcrd0CPyNrGwUicbn/nxFaxSA==
X-Received: by 2002:a05:6a00:f86:b0:7ff:a5d0:f8e4 with SMTP id d2e1a72fcca58-81b7f7e2053mr1030497b3a.33.1767752426069;
        Tue, 06 Jan 2026 18:20:26 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:9f6a:2617:8891:93ff])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-819bab0da0bsm3256759b3a.13.2026.01.06.18.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 18:20:25 -0800 (PST)
Date: Wed, 7 Jan 2026 11:20:20 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH] zsmalloc: use actual object size to detect spans
Message-ID: <tzppylvpaq7lk4re33h4niofgfwiziibp3jdoos2ofeepxx5yh@sh2doyzze25z>
References: <20260106042507.2579150-1-senozhatsky@chromium.org>
 <qh2p3k5c2ulb5g2zmckhrm4o2eoruatb5lnumkrwrvmsxwcn3s@nh5vx4kjn5in>
 <og2yztajena3ywyvus6xgc5vlrrecjaynyezygpsrt64kjkqlv@agceajv57eet>
 <vkhwvmazwys7dz7m67fil7xlhevdsc4xbvq3h6nknb7rqojjis@vx2c57ylvl44>
 <ofjlah554fgcc43e66djtysmnagd7gduqutueyauipovs35qb7@mw7keptebqau>
 <5smqbald5bollibqjsvqw2tfngdoiiucurikdgqtz6xjb7u7vz@7p6hskoixaak>
 <lupjar4x2wz25knuntywor5oyx3ksyhh7g7yv4apmztn47ayep@sncrwg4gjlut>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lupjar4x2wz25knuntywor5oyx3ksyhh7g7yv4apmztn47ayep@sncrwg4gjlut>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5AEC8160005
X-Stat-Signature: nhp3pkqgz9zxgddjkpm1wm9s9jbieqdg
X-HE-Tag: 1767752427-298095
X-HE-Meta: U2FsdGVkX1+xy3qNg5WB6Vr9IriC6rs8W18al5ccuIMec1iU6BS5auAQNbrHYl8/+yf6szxnGm4P8wtYGU143kUIm1A2AdbhvzwTvFVF20l+4NyNlWwapsrEIfcPG7Mpqm59asnYdVSfS02KEzl4lPpLENe74EmEM5P8M6RGuAe3Tgr73WmPrNvr6bpeRZMGjtvmBw7isUEjT39Q3FqdtCAq4EvbdQWaV9rmEVHHDPHcaO2KP9ybn8JJP1pLDjJ/93kNLWn3qhIkF/NENyW0iJ6c88erggAbxXmVdpfteBgMNyjFIc+GxnonyQL2xyeYAse3HjdhUAbGNGlqqE0XFMC/Go8yYRHDH4EawDaqDO04pA4WiT9T/rNj6dbFlgQHDx8wwS0sOp34RsqtQkrOaIZyJo/KVBdYjnPPUUnDRh8iuSa0VzrWWkrcUtup+ftix5eX/qj55CWJ1qaU1Oj2cT5i40EozI1fXugeJxiSPGE5CQkTwycyjCzw9Jv8I13H2dUjq4K4LEGsNSrxtAvVEYSqF3MnFUCDP46jSYHqXbIL7E8TSJCM4X7qGhjpeId4f4d0qZNjU51Z1w9v3V9VBosVGWri1PWEe+4SOdbj/bOsG1Ky6qK2bv0IkRWR59w4LmkUcJn6Eo5Y2BkISgsNBwpopoof0GFKR9hDCOPjNBbtU8ZMkoF7ccEkcaonqm57ILmP1B+teOS5bU0hyuhjJbq7tI9ZkOjNelRIo9X+oIuut/eVDLt/TT1HlEsI9ycJWY8KJpubjVeovcwINenIQ/TPJBVnLGaj6wsO383k66JAleAWY9qMzZ4yckZt9lp/BiSNTUgRMR67FdEqrID1bBnUzQjkV/qAgSQFFiC4y46rAbzPxEHcN9TDDWxSWevY2AKX2E1fYpapyEoEAdFtWOjgKjtQdp8jM2VwW7wpqsOktqebOAyt/aN6WFRPNk4p+IsrlwYOWall/Q7HT2c
 1cMbFjqf
 bSAgDpdGGcD9E5wrSXmrOdvK7pLOBsPTxZIeQ9/pktu4itisfgozuLZorytpOlEXmSvYj2DnglBVlGZZgGh6T4yZohWrQEcBbPskHsBpfVHZvreX4trDNQz+qqHIQixYQ9dIG6GsBXwqS/zRlyr5K/83XuQmXO659nfLeiYN1fwqM2/oQPf8bCY+HH4796oJCG4/d5JJQgznyz0pm06i8cNKdaV4l9h/g+o3+btTDUrm05ocVgTNjZYuyxFwBRUm1cT8y3iIQxzLDNcvPkp/r7Q6KlzboFB3GNwpUjfp35PHf9HWKCLkaELN+Wu5UykAw6z8H8vYSLSJIxUglmpY1/OJhe/JeWuW5l+JIvYFliIA6MQs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/07 02:10), Yosry Ahmed wrote:
> On Wed, Jan 07, 2026 at 11:06:09AM +0900, Sergey Senozhatsky wrote:
> > On (26/01/07 01:56), Yosry Ahmed wrote:
> > > > I recall us having exactly this idea when we first introduced
> > > > zs_obj_{read,write}_end() functions, and I do recall that it
> > > > did not work.  Somehow this panics in __memcpy+0xc/0x44.  Let
> > > > me dig into it again.
> > > 
> > > Maybe because at this point we are trying to memcpy() class->size, which
> > > already includes ZS_HANDLE_SIZE. So reading after increasing the offset
> > > reads ZS_HANDLE_SIZE after class->size.
> > 
> > Yeah, I guess that falsely hits the spanning path because of extra
> > sizeof(unsigned long).
> 
> Or the object could be spanning two pages indeed, but we're copying
> extra sizeof(unsigned long), that shouldn't crash tho.

It seems there is no second page, it's a pow-of-two size class.  So
we mis-detect spanning.

[   51.406310] zsmalloc: :: size class 48, orig offt 16336, page size 16384, memcpy sizes 40, 8
[   51.407571] Unable to handle kernel paging request at virtual address ffffc04000000000
[   51.420816] pc : __memcpy+0xc/0x44

Second memcpy() of sizeof(unsigned long) traps.

> I think the changes need to be shuffled around to avoid this, or just
> have a combined patch, which would be less pretty.

I think I prefer a shuffle.

There is another possible improvement point (UNTESTED): if the first
page holds only ZS_HANDLE bytes, then we can avoid memcpy() path and
instead just kmap the second page + offset.

