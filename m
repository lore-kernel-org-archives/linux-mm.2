Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58835CD98C7
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 17:33:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 101536B0005; Sun, 14 Jun 2026 13:33:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08A506B008A; Sun, 14 Jun 2026 13:33:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E93D26B008C; Sun, 14 Jun 2026 13:33:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D3A2C6B0005
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 13:33:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 41253165EA8
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 17:33:20 +0000 (UTC)
X-FDA: 84879214560.25.C28C477
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id 411DAC0002
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 17:33:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sl2PLKbt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781458398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CgDMGJiLxv/wqdnxmsIJXskRPn4fvdvYBRvDM3yawdI=;
	b=xlnnZ8ZOmir3iZlP9u//r9lLN4YpBCbaD9Kh+1m5/iYzHh0nk/jG5KCuNO3w741rrFFLrw
	AqPdinnsF875A4/I2FvP4/piM/OYIYVoSerIhOicUBTfR5wupz/EME1kRiuah6rsSB7oH5
	G99gH2T4vRwGG1iw3EpQR3U7GfSLB8w=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sl2PLKbt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781458398;
	b=JkGjEUea9n2rqKCKwjgwgKNsD9WrT4qxCC4vilkMAGjEpmSyyY3mN19on71oHMHi6v0WzL
	O93mR9ozHDySiz95Pb+tM1MvUuBGaAe4JqQO0IhDPXbAkM4PGFSSYEXRMGzcW6SOAQ3hFR
	gYZ94CWx/rspeRGvOBNHCHMR2bDsEtA=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-bebde89cfd3so294275266b.2
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 10:33:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781458396; cv=none;
        d=google.com; s=arc-20240605;
        b=MZGaa/mqEudtk867dmAC74Uo5je8N8AwMqAlNWIkgkL5ABabL1tEbUNG1aKd1+g5Cp
         LhGEwg13uLusX6MyJ1ytutTIEyqLwOUmwQqAtUpQsIWgZTeYAC0BgHCnk7DY+SpH8FUf
         lPx8JAOmOaOiFKLopC6l0v6yVBmggp9znfyVEQuJ9NZy6P8oqn3iCsu/4GjQcAWb2ZEb
         qp56yapCvhslCciyMiwow82aSqoL4on8FCtBg7YAv6bGLO+dIy9e6F3ckaVULIsgzKLF
         5OlKBHNtPh5rBrNkBp6+o31f3n9vUnd6c5mH5gGfpl2oqXz0802X2ge55GZ8dzqhodnT
         sj6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CgDMGJiLxv/wqdnxmsIJXskRPn4fvdvYBRvDM3yawdI=;
        fh=HE92M6X2NmBnfU2REiM/9c8Xm75yE3n5r71U9xhoeV0=;
        b=e1y/bq+NAempCWnsaUndcP8P1fsu3AdsqOOwrZwpkn8+pVjgYKcuQD7rXSGr+f8OSz
         wrBSLxkKGHDCOA9r3O83x8Ye6FsXpw+9+vYBFuzZIhCQTIH33sKfJjVVCta+lJihbuoT
         HY/Md66H27LiOPJPmPeCKtXIJgmViz1iYIJ0mtHK6yTt4HFmBC6+P4cnTP0pt8a359Es
         o3e1pxgclpWK1XaX5MD9oEPpJ0mpV1kvBOU+FlSow2RuVNSa/mstTooGtR0I8qTg+pfS
         dCWVTRZTf8hJu5M9ajfuhQ+RL8HUn7zgzGpqQ10y/8i1Pt02X78iEQ7rISsMKGJcv/51
         XH7A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781458396; x=1782063196; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CgDMGJiLxv/wqdnxmsIJXskRPn4fvdvYBRvDM3yawdI=;
        b=sl2PLKbt6sd6zONzxzGFJuwtOnpOS5R8NY5nMijeQsXDCqcEwasJQPdgo2TLzuMHPe
         aLgs9PgcuR/WLf/I1CJ5Xsr9ALxaFtUCmgDttuCWkq+2ANookexAEti288AGmuuWspTx
         ERvENf1jyHHirkvJ7XU+WF2unCRoJ4D6R+sbsJdL1CKpD5mY6v2GiN/SaS/PcSIFZ0KS
         B8OQrICwzho3qqSr1sdoicKhbKx6biQIrwVMtwZtJruCIyptD4ywjlFb5Gv8C/qoXuiM
         clpx3oP/G/Wlof8H+/HNT3xLKtyOz3BMTtYgl5wzogMkepRYyo9EnExFgqdMLr1FxUt+
         QYXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781458396; x=1782063196;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CgDMGJiLxv/wqdnxmsIJXskRPn4fvdvYBRvDM3yawdI=;
        b=U3uIGgRZBgFf2up268x4YD9yNWncLFBaC6q0jjCcEDUPjQrGbTXRflvFAalou42hll
         sSbYZ3kfAX8nGi2cUh4pHAVk7X0FyXcZJ+SkBFoxiMeWfKnZ8dTskx9uCNQIy2xSPVTW
         HcdJLgoa84M+WKV0jWGQ82AxGPH+PUIINNarZ8MKuZq6jgIepcfOF84E1hsS6GfQ3PgY
         rmjnMpZgiMdBLtWTTE8aBJJ9ggnEFun5GQdF3Lx0jckUxhc99ZDaQmFUlJ32DC+esQek
         KaN/M88rWYMajXiKhhlg7zKTi8pDutaRbbyXKQc0YdzUOUNYH0XIcjyKHhPIbL6nw/qq
         fa5A==
X-Forwarded-Encrypted: i=1; AFNElJ+DkYAkk/cLzAbWrSuoXK5zbbJQfCsZKkBf9S/zACkxDRpCk5rRIt59bS3TGNBqYQRlIpg92CnlKA==@kvack.org
X-Gm-Message-State: AOJu0YyQffkFs6vVd3zbJpu6WaWYNQe2uLoVeafnGsff1dE6YemiZqed
	v9zLKWekQ2XVfRI3RRjxIuDs+fIzklxrEvQorb6Bl+eD3PE2lbg1vz6/ghVmrM6NU0V6r+kiFD3
	zyRzq7jekn+rjE7SlSM6z9J4UWHBnUYQ=
X-Gm-Gg: Acq92OHfz2ZQudOuME6/gBSfnH/MkImhNjNJVBVwgPFmM8tpr+6+SQ4hj402LXSxttq
	z8yaIiks3ttVALkNGkgwllcZsvL/ek1glyUKLqY79243JB0h820XX/kCrYC5F8TalvqAS/FBa8T
	AyXDs3TrsNAlTcs52wSVQ5taDoETyYTFMf2b4MGa1D/rm38h4ZsSLz72Onn6J5+yL2syOoky8m7
	dGCZ5uv5e3e4ferRd5JBlHszanF3XKGLjwh/vtOZUTTtBWD1s1IWbpsFG5u6qXvlF3I43oszoH8
	iYeVkWdypkP67C88tpgCAK4Kxfhnh/KF5SWxANds
X-Received: by 2002:a17:907:97c8:b0:be2:cd33:2142 with SMTP id
 a640c23a62f3a-bfe28600d04mr525947966b.15.1781458396194; Sun, 14 Jun 2026
 10:33:16 -0700 (PDT)
MIME-Version: 1.0
References: <680441bf-c878-4a00-8787-63ad8b201bc9@linux.dev>
 <20260613042232.93691-1-lance.yang@linux.dev> <526fdbc0-1944-4328-9ff6-7922d021828d@linux.dev>
In-Reply-To: <526fdbc0-1944-4328-9ff6-7922d021828d@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 15 Jun 2026 01:32:38 +0800
X-Gm-Features: AVVi8CdrP9EcM4FCIPur31zjV81nkQN-14APK-sEXoNqzXjz8UX9rHlKXJypZJY
Message-ID: <CAMgjq7BrFGHb7+-dpEQ_V9wqEbwBiYyKx2iU61uLMPWk3qKsxA@mail.gmail.com>
Subject: Re: [v2 00/16] mm: PMD-level swap entries for anonymous THPs
To: Usama Arif <usama.arif@linux.dev>
Cc: Lance Yang <lance.yang@linux.dev>, david@kernel.org, ying.huang@linux.alibaba.com, 
	baoquan.he@linux.dev, willy@infradead.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, riel@surriel.com, ljs@kernel.org, shakeel.butt@linux.dev, 
	alex@ghiti.fr, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com, 
	baolin.wang@linux.alibaba.com, npache@redhat.com, linux-mm@kvack.org, 
	akpm@linux-foundation.org, liam@infradead.org, ryan.roberts@arm.com, 
	chrisl@kernel.org, vbabka@kernel.org, linux-kernel@vger.kernel.org, 
	nphamcs@gmail.com, shikemeng@huaweicloud.com, kernel-team@meta.com, 
	ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ybgoyfeftki8orq1osqhcbhttu3b8bdf
X-Rspamd-Queue-Id: 411DAC0002
X-HE-Tag: 1781458398-301706
X-HE-Meta: U2FsdGVkX18WkB47GvicDK7ZlWuAdJN2DdWVJEpEvDRRnEeUehCR2BotD/gmY9n+R5RcFdkMksxsQgWJBAnK7AVC0MSxnS6tMHtj/4J0L2kkROSNDHNZlVjPwrAS+IyqRGtI0ysEnDDcTKPWCddf5oe5VG6Y17yGrgkqF/6zSN2knxslWtec8zWF+fwLiESsBZEPtAJGHU0GkhJoz6h10T8xBwH3Xj06kgZWhkaIDYzBDh48I/aHBh4dDWQlEfjdIkBbsg4QUOc3PgKsPT+AMN3isPmSAi2FpkMgyHhz095+BXsKK0bdOT+RDW5/VWxdnZK4XEycF9xNNXFKN7W++MGH/MxiCQnjUV2+6CHcAABPIKezCWmFsQw1vAiDT/Yt+sEtmK4Ie3tufTucDDp318696qocoY79VfDGrBNUPJVk2ljkHMYvjZE85O1HtO7YooAfk5st/cN3/eYdDTVQJCiVKOT9k6q01rkCia/fufpE5f7JsyeMkUWVbEYDKKyLilN2lUvfoJXO+QADvewnPjJEwXcYrBlkA9KpsCetAj+qBaprM404cae2+yNFyD5neSLB/V75wsQX7xrVy/ecHn4qZOTrN9AiZIm4unm8h+QZfAlfmIcdGyfUa1wDXfBcxlLPS1fKLws8vfQQV8ZKlJn3eajl3CJKW6XtrHDsmIDTcawY2Aoi7DxyBEiGnivL7vj/W+oVE6HE0yA0ybST827Tc44rU+iLrjQ/RYwB7VzFGqZezm69+B9jLkAkV3/bzz96bnFQMnc+yeJbqVDLF/kmDOjTOGsj52/tzthOD+1k0dcnKwNUBfjJFNiW1Rg/hNhvyadz9cCiKUJ3FTXGajh6gLhf0U0YG1+oRfuzGFymc8KoTIvlE1m23lardPNQwKu8VV6RLTk0920E0LwGpmjS1pbkuYs2QSGJWRMY9+Lf92X1i6xtABPtrTHTAib3pnTPkrQoaQml4l7bqdg
 XptxoP8l
 /duNyRU50+3YH8BKU3cDmRJ/72dDQQAtfiQBip/TLxC1Pwda5L+t6PEIdQqsPzB5u5/ACfMu/tc6EVySXyHRX8P+zzZMaga0BBhiyUF0jrgH4oaicz/jB7aO79ZKtLfwrpGqdDYedi1Jiq7CqthHpFKHQcnOvWRYsBJhhBambwfjOMZN5ZE6pvvlWyZfXjFZEtz7DMYManu6LATuDo8vRzDcMh5t4W1eHAeuG0ZIlFPh4v1qSuuwM5hvUpx7AnAjdPF/WB+GY6UK3tuK8lEok6o5CHetesd0jxD9PvXS68+Hdm5Cf9uDhbfgnX/CZx09t2QZp5PLkAqbLIE7TRH9iL7TvHxNxV7HjEEZ3+HbS+E9yRayFAm9M6HGHgIRYV9Bx/CqR96HbKKN8KsQY8PmM2cPT2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jun 14, 2026 at 3:19=E2=80=AFAM Usama Arif <usama.arif@linux.dev> w=
rote:
>
>
>
> On 13/06/2026 05:22, Lance Yang wrote:
> >
> >
> > After skimming through the whole series, probably PMD swap entries need
> > one bigger rethink ...
> >
> > Emm ... same tricky bit keeps showing up ...
> >
> > One PMD swap entry is easy to handle while the swapcache still has one
> > PMD-sized folio behind it. Once taht folio got split and reclaimed, the
> > 512 swap slots need per-page handling :)
> >
> > Maybe worth first pinning down the rule here.
> >
> > Is a PMD swap entry supposed to mean "there is, or soon will be, one PM=
D-
> > sized folio behnid it", or is just a compact page-table encoding for
> > 512 swap slot?
> >
> > Without that rule being very clear, every caller has to guess how much
> > it can assume, and it is easy to miss one ...
> >
> > So I stopped staring at the details for now, because the same issue kee=
ps
> > popping up wearing a slightly different hat :)
> >
> > Anyway, no clever answer from me here, not a swap expect :( Just pointi=
ng
> > out the pattern I keep runing into.
> >
>
> Thanks for the amazing reviews!
>
> For the next revision I=E2=80=99m going to treat a PMD swap entry as just=
 a compact
> page-table encoding for 512 ordinary swap slots. It does not mean that th=
e
> swapcache still has, or will soon have, one PMD-sized folio behind it.
>
> With that rule, whole-PMD handling is only valid when either:
>
> 1. the swapcache still has one PMD-sized folio for the range, or
> 2. the whole PMD swap range has no cached folios, so the caller can try a
>    PMD-sized swapin and still fall back if that is not possible.
>
> If any slot in the range has per-page cache state, the PMD entry has to b=
e
> split and the existing PTE paths need to handle the individual slots.
>
> I an reworking the next revision around that. I added a shared helper to
> classify the swapcache behind a PMD swap entry as empty, PMD-sized, or
> split, then used it in the places where this assumption mattered:
> mincore, UFFDIO_MOVE, swapoff, MADV_WILLNEED, and the PMD swap fault path=
.
> UFFDIO_MOVE now checks the whole 512-slot range before moving a PMD swap
> entry without a cached folio, and falls back to PTE handling if per-page
> cached folios exist.

Looks interesting, sorry I haven't go though the whole series in
detail yet, one question from me is how much different is it compared
to the current THP handling? We are already dealing with THP fallback
where sub-pages (of any order) could exist in the swap cache range
covered by an incoming (swapin) (m)THP, the only thing different here
is we need to do split, right? Meanwhile shmem already has similar
split logic (split of large shmem mapping xarray entry), maybe they
are somehow similiar so some routine can be shared or reused?

