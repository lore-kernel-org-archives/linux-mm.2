Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20BCFC5CFC1
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 00:44:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78E336B0391; Sat, 15 Aug 2026 20:44:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 717A16B0392; Sat, 15 Aug 2026 20:44:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B86E6B0393; Sat, 15 Aug 2026 20:44:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 13C7C6B0391
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 20:44:10 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 832081C15B9
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 00:44:09 +0000 (UTC)
X-FDA: 85105285818.30.CE6AC5D
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf08.hostedemail.com (Postfix) with ESMTP id 94745160002
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 00:44:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EUlRoZtO;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786841047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z6iaB4PCz9gZx05Kn+SlYN40/DtxMK6Wv5kNuPofiZY=;
	b=ZOUlgXa1vwi1ykLfQAnGqT2BVcpjrddYz3i2geepxR9553J/oHZ/uZ0AezPvyoY7xh6uAO
	jk9vs1YJSspFXcIrsly0uJjSFKme4Pa9BIV1FQOy0uAsHJuGj2gGyuI81x12/Pbq31CbIs
	WVUi2Toj+X9HNIc2hOQdXR73w9hCXns=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EUlRoZtO;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786841047;
	b=TRV2LYed5FCR4FTm7YYBoCTzPjQVXUgOkR88qJ1zzMfnAifRSzKlDnAvTQxNPy71G6GsEc
	wodKauSOdYu5awsUzpxCAFs65qF6aah61aCahM/xZpRvtbgnynfxTyRs6b1yO8F0jHde8m
	ujI55LIw/5r4LWeaKX2jPNvI6CjxG9M=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-496bb7cdf51so28891235e9.2
        for <linux-mm@kvack.org>; Sat, 15 Aug 2026 17:44:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786841046; cv=none;
        d=google.com; s=arc-20260327;
        b=PB2n2D0gOoGwaewIvkG3O81JedXDw8CcTsJ03w1sE3IQgNQqz6TmE8F6vk2K/nIokz
         XfrK1thKWde2YJdKp3Bsv38D4KBqBdW7SHgPogFORNoH+fE5qeFSIIPbofhyDIA4JxZa
         LBtHY2+nLj1v343rpFKYAbCGGjVKDNjancG++xFm5gfM7pXa2otegVjfF+Ilx8+pfZSf
         wkaIUa7jx4N/ddQAdK7G6hrYdgie34lfdkwneRP40ypgQOn747261SJH6fMQZbYGV/j9
         2sCid+e1VL3fbLmIf/ZrxfsjpKBZxQO5Nk/q40XA9IPzhFpUmrZJsjYje4CESQUiuaTQ
         EWqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Z6iaB4PCz9gZx05Kn+SlYN40/DtxMK6Wv5kNuPofiZY=;
        fh=wpZS587JHnXy7EzZSQ5FdFOMO34X5jehmEuknP6zzsg=;
        b=mo+OGQDjkpilff545IPrxS4BnttudZlXwkmLFZyWFVDcyC3hKWAyAQo3QvoHZOv5jq
         Wig+PWgnZ513wV0TpxAjnVygq7azJQtEc9MAT0py3DgVaGZrX8ccASt34YGm0lOqkz3W
         Ps4PGgAwjGtlYosG/lACsjMXJg+JdgfvN8tk+2SbnSnAsWB3jBNQavxMZfteFeBfKtqm
         vnnT1ZXET5zOtGFapPUHrad44BhYCovmh4YR7n+BywlxpFmfS9Ruy2WikistusPQYr34
         ydu6BEIN/bxAfCGBGNPbAKa9gtcBACaTTRm0hd6vdIgOmSurv80dE8j5fWpyelsAFhOs
         ONzQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786841046; x=1787445846; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Z6iaB4PCz9gZx05Kn+SlYN40/DtxMK6Wv5kNuPofiZY=;
        b=EUlRoZtOdG5i0hjDrcVtTlqSToXLOJKOgmwKy6xy2LjBkZ/M3+SOX668cc2emM+Lqv
         KrGRAaonb2Cig7/IMvHJfr6tSJbmMfiWKR+zNqvPwkUlWPppci1xT2KFwVjBul4b6Ft9
         //8eaS2YGsMOdtdfIB+L4fysarB2mdzyv3RzbkYmsWUIL1tYGm8VuStzXc0g/Jjj8myw
         CnIzQPOPuZENgZGhoUFTWmwEEOX+oFiE0yiDJ61ZV9Z9bYh/S8FaQreD/G1wLOr1NuRx
         GxpsxLOk4tSJLrgDO0L9L8aW6nNhRUIt1v772YG1gjD/r0jsJ8zcz0fo/ll2q4N2oVXx
         2t8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786841046; x=1787445846;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z6iaB4PCz9gZx05Kn+SlYN40/DtxMK6Wv5kNuPofiZY=;
        b=oiCd1tQQSekkqUmEYZqfkkIG2fpRnNI2Dneo3BqyULOgxNz+ip14IOBt0eNCGVxRrf
         Rhr/xDkulDZ17pv/mnizqw3KfUleDrFiZl/T25XAfeDNAywsG8j8T7Z753Owuv0lfwaW
         oFHSN+6gFbaSADaVL2SXcbaNWdj8O/RtfMhJe038VDBnDmuHymIonzHYb2HoPueorFDV
         yH+dMY3maVQDSMUymK6MXxY/NWjdi3bN28mfdJqdX5u2AnT9QDKFe8sbewWlRgCveQGM
         gk/MmLxhm1fRjSaEJB0xoYISum033MpDGqRbuhAcngvQJRJP0eWHfFcG9yBrIHBqEz2R
         heoQ==
X-Forwarded-Encrypted: i=1; AHgh+Rry7EI+GG+83I8iGKkGHrTbbQ9GWZP667H2mcDNa3bFiriyMtG2L6M4kBk6Lh796dnZb/i488VIGg==@kvack.org
X-Gm-Message-State: AOJu0YwCNzYnP2MoLbuYxbYabF+gc67hJHBhcCHysVYtvGguIzJRSu3p
	O5f5L7Dr7C2yXhfVtnr9YPkd95pT8I/He1VEOoG/sPcQKakzjQ4GqVKjNJmyWIeLxC2RIg2g246
	VgId4vwp2hZhNZB7Ilr/pSgahAT4TrKo=
X-Gm-Gg: AR+sD10p5yGNmGTJpcDXHxODAHvuYR5ltKqpZnC/bnugTtpzVjHe+nCIcvk8znVqDJi
	gAZp+ckjQl0HyYSvOT3OHsr0Pao9uFDC611jqZ8edismFmR2ylJVgOfHl/XCpL2x30mL7Tzt35d
	hLrecWSmHSEWuNfjoXUFl5ObvSELoaAaEUHVWZKEslmdIssSEhc+sk8TZiDv8RI+vEMmM/5t/GV
	TomnK3AuOT6IHy+L3H2KDJDhvQ2Wcm4rD3Xh9+83REW1p7bkRYFmwK2XSPhMN0KBBipBBvplNQi
	6WGHQr+FNBueUYOeXOPTY3j+ic65U0gZD6FfkNPJAza8DXRaoXtmcaflCJ0DNTImwzw0c7rxiik
	E2UjAwubdjg==
X-Received: by 2002:a5d:5f8b:0:b0:481:4761:45dc with SMTP id
 ffacd0b85a97d-48160715e78mr24767349f8f.13.1786841045770; Sat, 15 Aug 2026
 17:44:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260806184254.3790858-1-nphamcs@gmail.com> <20260806184254.3790858-3-nphamcs@gmail.com>
 <an85AJ8auvXQ3+nk@yjaykim-PowerEdge-T330>
In-Reply-To: <an85AJ8auvXQ3+nk@yjaykim-PowerEdge-T330>
From: Nhat Pham <nphamcs@gmail.com>
Date: Sat, 15 Aug 2026 17:43:54 -0700
X-Gm-Features: AcwNN1U63Z-1-cQDWvCFzi6HzhQd1KBrn1HsOOVGYJ0ezMThDvyr09qu6TnkhIk
Message-ID: <CAKEwX=Mrdk+6WF0s6gz-5N8rNPzz3gEgUF9SeTB4O78zXQcEKg@mail.gmail.com>
Subject: Re: [PATCH v3 02/11] mm, swap: support zswap and zeroswap as vswap backends
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, yosry@kernel.org, david@kernel.org, 
	muchun.song@linux.dev, shikemeng@huaweicloud.com, baoquan.he@linux.dev, 
	baohua@kernel.org, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: n6odeidbnmuyksy6iexzm3j7u11368ee
X-Rspamd-Queue-Id: 94745160002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786841047-179986
X-HE-Meta: U2FsdGVkX183rqN7X/tzo9KM6gebpZajRn3XNfU2dFejSjKcpRiammI8dFbMr5NXEkRAipv9hX8yAL7pD1JmBkOwyRwtGr4mEPKyxs95XkH4YR3tpBLGt/unRBWMpHaCfa8f98Bl586GBx+JtLw6uMSHWcDukNvQ9Sy7p0kk/6WkgUt4OMFbeCSectRiCwJXniT0XYTGDKeB06STE/gs8RGu+neo+i8i5rKHZzK7XWYLai8y8WpyfMoagvzry62KawEA5yU0LGIlZwh0EVt+w89mIJisWeaWqKym3jH2rAjryANsd0N4dM+YbbkLn5dUmBz97nV/nNacxumUVVMBjNPZEGaYxF7S3XYXn33ijaFuaw52QCCtXmRJO77tFV9hjGURS36biT1XMBDT/O6zn+QOZBM5CwbAYGQ/+yYCptY97bViGPgZwHzyhTSzZY5H/CeN5lGdiAkXhJJ3I5dk4gb8ImmAUArwsuSUZm7cNcddBoNbQBFUk0mG+gdPHSBq+SuIX+EBWk2Sa3LFwBD60RPW29BGDOsxPa6rLUOoJr/7Emk1anIt95ozQk+tqmBZDhwPlqyyQOwT7Z1GAIoWGEyh8zwU6cTcYOiadtqvqIQ/tDRDBXFg+w81+HF1LEMB3ok9+nduR3m3OBDac5DS5IRbbFuieWXkK+wniNmgGo23gaeSXZjgtuk2ND0QQnSTb2f8YEAueqFGVEeFELmfa9zLIMAszK2orxRqIKadwgaHLmPBGCRoOAlfMXclqw7/pgff94Wt2EyIf5MYXz5jW5ublHUkKvakNT02LXPsUU2XU+aAR5I+QF5NRJMik/aP7a2w2Hod1DR0IsI+3pXCHv2pDh3Ex/CnZqTg+y+OvX9CJ9yuiR7AuVxACCAsBAYRm14dmuD+m0uE+bWs/3KrMfCvYhZWmnaIZ8j3ZQMOWGTdnODnKRdrllEl/O2Z8kQzUF7+Em24sajEwtnuJf2
 0auVG1t2
 b79fl6c0eOn2Jg6hePyM59UqGPKmavaB8E2rnUSiQkMjQiNyxA+5dvdBgfKXZlYnUSTqm+TaE8z25wWIKeOxxxsDo15cjzIX5fMycYQij4TcL5a/ZytHIlNLOCn3YdIUZpW17lNrdCFSwJ8AJdMyqf4rrpU3WamsCoTXlxam97zfyAwJG8DCKS+jVtG0ZzVgHR6CTLwHlS6s8zgMWTUtyI98jJDc9xJYPtkshWny4FDp/aSKmdqLcpb2Bfe77RMMkeAowCJAEce2syaR9/0mCwKy/aIW8siK0lrlj0A9ztv//TBD6aRHo9vmLgA+9Vmb+4oeSGKAMzqeMISFDpj/JZY0bMpvGKeVujjT83FxED1oZ2PppvgOk93ElFc6pou1Ots0LuDdUZAiZH2SIm3+TBEgVK5NPSxFS8ZnZOTd7NaMbGPU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 8:49=E2=80=AFAM Youngjun Park <youngjun.park@lge.co=
m> wrote:
>
> On Thu, Aug 06, 2026 at 11:42:45AM -0700, Nhat Pham wrote:
>
>
> > @@ -537,7 +562,12 @@ swap_cluster_populate(struct swap_info_struct *si,
> >        * Only cluster isolation from the allocator does table allocatio=
n.
> >        * Swap allocator uses percpu clusters and holds the local lock.
> >        */
> > -     lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
> > +#ifdef CONFIG_VSWAP
> > +     if (swap_is_vswap(si))
> > +             lockdep_assert_held(&this_cpu_ptr(&percpu_vswap_cluster)-=
>lock);
> > +#endif
> > +     if (!swap_is_vswap(si))
> Hello Nhat
>
> Does vswap actually come in at populate time?
> For free clusters (dynamic ci),
> isn't the cluster freed immediately rather than going through this path?
>
> If it is right, then just validation seems good enough. (assure vswap doe=
s not come in)

Acked. You're right I think. This got me staring at the code along
this direction, and I discovered another code path where I provisioned
for vswap's sake unnecessarily (cluster_reclaim_range()) - will fix
this in the next version.

Thanks for the review, Youngjun!

>
> Thanks
> Youngjun
>

