Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C7B6606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 17:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WW40lgCb
Received: by kanga.kvack.org (Postfix)
	id C432E6B05B9; Thu,  5 Nov 2026 12:39:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEBCF6B05BA; Thu,  5 Nov 2026 12:39:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B287C6B05BB; Thu,  5 Nov 2026 12:39:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90E976B05B9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:39:17 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1DC9E80BD8
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:39:17 +0000 (UTC)
X-FDA: 85401776754.20.41A8E70
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 31135C0005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:39:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WW40lgCb;
	spf=pass (imf22.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793900355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HzBYPoNXExK3g6LJrj9PEcHUalu23GcWsA6GOIUdA38=;
	b=hwHvVPqaM/K4f0Ip5IdnuerrJDTtANIDjm4oJ7OvKpqEyeRf5C/XZDe6W57nwwpsebDZP3
	GgdD2g+ybLKt40PU/bwWgz+K1CExYntFFPfLhZCU5sp7CTPP2GdXMQ6eO26lx/8bD0iYNQ
	nfDL3dzw0Kmsf6oxs0d5HI4QDmQvgB4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793900355;
	b=E+fdahs6khlAYCoSRDuGxIprRtViupaPrrUj4sPfHYEBZTcPgTQodgGjBGYVEx8KOVq7jI
	crzwSvkeHB6E/LEiMAdytOLWuUJEX0+P+y88JDj5WfmXO7Mu3sY0wA1rky/DyJhgF57YJk
	7yA/5QPtLscMVLetgucVTOTW2wC8hbM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WW40lgCb;
	spf=pass (imf22.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B302600E4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:39:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151A31F00919
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793900354;
	bh=HzBYPoNXExK3g6LJrj9PEcHUalu23GcWsA6GOIUdA38=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WW40lgCbdr4WdQXjZnAc3Vqzr0TSw4tIFA35AjPj4QZdtnx+t/jy00hzJRRzBZgGN
	 RXBPmTCYysFkIa85fy+rtwrP4pCnQRrt6uDlsqUbc0K6GGgFMRnbpi98NPD+b2t12/
	 J95xHJnX5mHx05raho+02GfZDPrA7JXYO8XGkPZ2BLLIz8gkwZGzF8euAcfp0S19KJ
	 vNq0acSNWWnda5VvkIerj4MrXChcoM5vHxYczFdYAJU9XviuIFqQZDjIUu38f3DRlO
	 ltyQL1rTDWtMs5fkkGpRUJiL6cVsYvoZh+XRnRO0ZpwKyiYbF8EFYg34cdvUlHimkX
	 hzn0WaMsCitSw==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c40f29667e6so340742666b.0
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 09:39:14 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzdze4vMov7sLWtAApF5gAE80OZS2sBD75WCSt7jJlhhBg4/OHRK2q4cv1D/YX5DXEvDyOOqiMJAg==@kvack.org
X-Gm-Message-State: APuU4Z9+Ok9GQbR0IRsN8H/yvzySUdObE4Dh1JW5ufNjX8SrgAhg1Oqu
	5lfTDxunQEF+FpU0cih9HsViBrJpEf5MGGypnNMd0uLZyW7niSluScZstY0UVQfufvEK7eLQGeZ
	CnuV6m6EZvm5S78O5nATQdMXblZVbn08=
X-Received: by 2002:a17:907:868d:b0:c4c:b4fe:ca01 with SMTP id
 a640c23a62f3a-c4d35574cb2mr11395466b.37.1793900353057; Thu, 05 Nov 2026
 09:39:13 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261105044752.1997895-1-senozhatsky@chromium.org>
 <auy9UfB30AlYabV8@google.com> <CAKEwX=Nao4jWtY04FXEjxiHUNUhJU2A6nCZLqhRRm-dPBZTmcw@mail.gmail.com>
In-Reply-To: <CAKEwX=Nao4jWtY04FXEjxiHUNUhJU2A6nCZLqhRRm-dPBZTmcw@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 5 Nov 2026 09:39:00 -0800
X-Gmail-Original-Message-ID: <CAO9r8zP_K0NF0gt71Emh+2dXmUh+C27uiu5TsyBcGUdLbCus1Q@mail.gmail.com>
X-Gm-Features: AclHuK_wc8Ng7_JQZLGDjWOKAsvWhdwYYyChi-Wc1-2WmNs0g0WKT4b-vjQSbM4
Message-ID: <CAO9r8zP_K0NF0gt71Emh+2dXmUh+C27uiu5TsyBcGUdLbCus1Q@mail.gmail.com>
Subject: Re: [PATCH 0/7] zsmalloc: redesign object alloc API
To: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Richard Chang <richardycc@google.com>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: hejiigd9kpkujhkgcb9nebupqr6rzwxt
X-Rspamd-Queue-Id: 31135C0005
X-Rspam-User: 
X-HE-Tag: 1793900355-149820
X-HE-Meta: U2FsdGVkX1+n8LT//XgY4OY/Mi3sOn3e+nNElIG4RpRjyFTPd1laD/PF4J/kFrngNfWWO6a9SD1GGxIhfINA/sSdk8dOnOSbsnZwWROkqmbi2YYeAGDfDn1ob+/0K4/J/aq3TKEW8irq5U1AFskobUpFAwSFTesXPpmhbZ0Wad/tpJGm+oHCyKnBdXKOWtNVC77OVtLPN3Noih3aWkqSrkt/w5ZwzUAfkDEfjLhj6n1xNHxvPJvOo/YqKri0w/cN3qFoVYGa1i+M0RRvCRKct06UoXcdMmFtmUV0k5+3GHKhcLur+WyWXzo0Sk5S8PwUu0JSfQOVluLEooI6cIevGqih1B02RDeK8e+AjBB1w1+Sf6xlFU/wSxtuLB3pI3MPH5G51ClkZP4h+FxzEcATga3zgs1D88S+M1UULDAC5GnkxYPwPqz+WKRTmuniJYH2AiL0eKHH89zP93Y9N4OqSwKG5ggMCqkFb9OGZR0JmwMBZAktpBYFuiEbxB09mVXtzQ8zCl/45oGaxtFeYXmbKcmYTVP+C6fWVAF7KFfRVB8pRlFqHcTAkygrLHcM8i6sFOPXpUZY+rwLmEQVdT+O5kGPstIuNo5zLusGK2R++42/zerYaDG1h44nVSWmCO+2IQjqeHaSXtg1uv9E0Jc73WbaAtoCi5ha+miOMlW5V1kXhJHUif+DwGJTA+WQMZcgMs/W9qNEmy05n3QCPV/vy2nwkbxSLzZCd4DSq+fJ7umwGtOaYi6s1ms2KCDM7a+F/k5holEokpDl+LuMNF3FOzbAVXOVrCWGq09Dq+UjKsGOT1NDbdoleidpSiQqg7EbJEMkCoIj1A2RimM4d8B6zYYw3J4Zj0PHV7UqK7sCdyX4J1wyFaINR+KGE/rnstcZwSXYLcwjpu6DC0NrDI6vnCUBNkn/hoSAxMSYAnME1+KR/0eSPtddwGGSJK4y0wYCMVUM1gJ+IWA2Q0m10Pi
 Xm/nU6Eb
 elb9aFXcSGEF3Rl/FCxt5JNYtuJHYbDHjrF+gKhac6S4gGjE3NnOejCjFozk9qVcnYPQXHB0OkWzYBtltPC5+p4emaTochoYJaQ5Ux+slovjKC96XKWQhIoZdwrJO6y4jPpLNAp3kvt+6D6DX4QJSSyS2Na0USTLBDbqcab6i5JzHtb8iIdqfmsQZDFHAjhD2/8EY8cLncjhWHvor0lj5qEoxDRO/r+BTmsVQlorBHcFQlRgjUzC+UzjNMxYH3wN0Nbhi4nMWRWclx+qn0ouOJ41peZcUOFinhpJD3QRAytfw7Lh2Uk6smK7oNEM+YgkFUZIaRyF+kCfzr7Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 9:37=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote:
>
> On Thu, Nov 5, 2026 at 10:31=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > On Thu, Nov 05, 2026 at 01:47:30PM +0900, Sergey Senozhatsky wrote:
> > > Both zram and zswap already have per-entry structures that store zsma=
lloc
> > > handles, so allocating a separate handle_cachep object per stored pag=
e is
> > > redundant.  This series embeds struct zs_handle directly into zram an=
d
> > > zswap entries and drops handle_cachep, saving 8 bytes and a slab
> > > alloc/free per stored object (2MB per 1GB of swapped out 4K pages).
> >
> > I always hated that extra layer of indirection, thanks for doing this!
>
> +1.
>
> The mental load saving excites me more than the memory saving :)

Oh I am 100% supporting this just for my own mental wellbeing, the
memory saving is the icing on the cake.

