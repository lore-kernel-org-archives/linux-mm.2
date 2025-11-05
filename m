Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FA5ECCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 06:51:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B78C98E0006; Wed,  5 Nov 2025 01:51:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B29808E0002; Wed,  5 Nov 2025 01:51:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A184C8E0006; Wed,  5 Nov 2025 01:51:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8C9968E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 01:51:04 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 337D716010F
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 06:51:04 +0000 (UTC)
X-FDA: 84075631248.28.6EEAC08
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 70C4C40006
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 06:51:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EQkaQbZg;
	spf=pass (imf01.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762325462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3c2CAXSaZCeHoh+VfGvk9ewTxbkE2QwEYuMm+zHY1Nk=;
	b=6M9zf7tK1H2+vk1DCuL84jyEsDut/tT9jwtM4/4lND2WUQomYMc3qEiuPIjMB42UKu1SR3
	1VxTEWYW/lmP3KDLNHoHBMtcNwzR3G6GvluE7PBN/cIHrNZxnj4yu/ZaNGw1uFQ+hmO1TF
	S3cpClApdrROHETkN3QgofpvIdWYJ+4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762325462; a=rsa-sha256;
	cv=none;
	b=rQ8S5J8hh7+1pjZYbF4WJWtgWJBgjeI943s+Nl7fDRTYAumIkb7NdW0Q/Y95hrFo6rfhwB
	c799w3gev17/7p2wkczMmOut2A0+ntJ/gqYvGIEvZCAn1H8il++fUBqpMitiX/K4157swt
	FyZSnZrydt/Q29piusezNNRcx6TIfLw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EQkaQbZg;
	spf=pass (imf01.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CF3E960215
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 06:51:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81051C116B1
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 06:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762325461;
	bh=f/LxFeHuSS2nW2wGlboJ13W2VDUCjMxIOo++YQqpejg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=EQkaQbZg+LeHXuUT+Xo8xeWNpAE+W1R+32PRFElHK5LrfdjJsDz7wjD52gPhbZX2U
	 /uofZIPaM6RrTScOJcMYfVMJI9BGq7nVoETZrUoq8p97qGhaYAUKvCiEZfq2hRVkCv
	 +Oe2tQNpHSn0xnIZn9JYK0/i3IE/2pWqz9IXZ3AadXbu4cgyzW6UjWW5wfUTG8xDbD
	 h/6V0UP58LXz1d+AQgSD23N8BJ2yjUGv1UjYr99UGquQ6AltFT2LG2ygtDWhiGH88B
	 om1s/a2Sqq32n3Qosmjb8f+QWLQtjdXsfLj13fPG/wpc5siJECoG4nRa68xwPoovMQ
	 6CljFbwKgh/8Q==
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-781421f5bf5so65345297b3.3
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 22:51:01 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUkA9+FKRPQrJ3kfOUHRUvmlucD4jhgOX3IsuvtPLmIe2bFi2h180fbeTUk+bvxeWVPbg+EbDyqiQ==@kvack.org
X-Gm-Message-State: AOJu0YxEFhsGXYVLa1YM30xPEwc/Ntb8SHBWsKUkF+7Q2fi8Ksm/SmaO
	VbpodV53sibQk44oe+olegu5pgCRdp5Zt8FsXcJfSjFulBn2GrhAJba3NKqPRQR6NwrKeN/v9H+
	4bvJTUZqcqt1KCmRqISsk1Y4n0MVMpVG9m2vPQsM3ug==
X-Google-Smtp-Source: AGHT+IH6llmrw0Vfe5Cf/hHp8zqBRi+mvFcNZm7+X+d6xYYRUbcfnABrFleGOIgULkt22tiuyiwotksWJopkcdzyAp4=
X-Received: by 2002:a05:690c:6902:b0:786:3d72:8b83 with SMTP id
 00721157ae682-786a41099e7mr37099397b3.13.1762325460770; Tue, 04 Nov 2025
 22:51:00 -0800 (PST)
MIME-Version: 1.0
References: <20251031065011.40863-1-youngjun.park@lge.com> <20251031065011.40863-6-youngjun.park@lge.com>
In-Reply-To: <20251031065011.40863-6-youngjun.park@lge.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 4 Nov 2025 22:50:49 -0800
X-Gmail-Original-Message-ID: <CACePvbWAr5RUUf9Ezviwkav6k+G_e2Xw-viHyV28P9x53iVTYw@mail.gmail.com>
X-Gm-Features: AWmQ_bmhNUCkgOsFDKqGkk9ncsGGYQ5gEQ-D4eLZ_M9cHuLtnlJAiHgAFqkd_go
Message-ID: <CACePvbWAr5RUUf9Ezviwkav6k+G_e2Xw-viHyV28P9x53iVTYw@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] mm: swap: remove scan_swap_map_slots() references
 from comments
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 70C4C40006
X-Stat-Signature: 7pj81zadtf3m17yeat9yfqbyhodbay3n
X-HE-Tag: 1762325462-994681
X-HE-Meta: U2FsdGVkX1+4wrbJLJiNA2QsBhdJTesTdjrbdaZiVZ0VvkaWOu4bgNFJgYQzLNEIvUXDGGvVjRd7VYHOWMWnfqgroK/U5DoyvXsM7jx26MRZRRYg3hnxMgUdrYXShQy5VKA674FSLrcAf0oMgIQENPdxF8Tz4u0J3BBtd97F8QLnfIAHMMPeO7eOsTJWhm1iRjmxX7x5pKN9d9Lgrc1ty8X+KOaW2wGCWX7GUGiJJQ1/zPhodq85JqceLJoMJ0FZJyMDkHpjXaAODPFccTPDpVhRxn8daHCMw4FGhS7OP8MVqkyxcXhnwR54NdOJmCYAsywLq8nn/q48acwJw+Ch+iTel/lOeDEeyTiDkaSscTAYf0ZNgAWZZwHOWYUBpxxW3gKgmaQCCNcI9jqGnitIJxbXSZTr2r4CiywAkA23Pqh/i+D8YzzFwAsHaNRSlQWN2tRUp+kVi2FTXn5FB3G+vctLx3w5mI9OwsPkkjjKPyLvjutOdALl0fHHA2yv4p+9uxxlV3kyQ2kVbyutBBJNSbjfuxTnMKacnWq2/9yj69UxPLPTdnOmNphB/HPQUoU61G2zNi1JYJg9TqsJ1QIbWXNzUIkR5fMuvYw4Ozf5CHF4PZY2jvI4jc2W4qUmU+VhiGmSUTLNLCIOljubSu+5PJMFj1eqEvBrjaH628wnAXBFdnjdGW6uQ6ijy9XxarUsxE49q4m3fNDAE4agR7U+TAr0QuaNrC8bxkpTiC3x2h8pDdMZGbbGbzUQmrUZN/qV5Xt2I6uszZCcv+1/4iWt68y6cFml2hrGTtvHYuuuQ+r2JIwIU6UVh+iDUSRQbsDpsBJn6ubWemg0CsHgVjaDTaMJ+hLN4fA1/NKBbj2cJgUyIZh7qkTT3FEnltUMBsGSczz6L7MTpnjj9wr4SLJqXNVDNkExk7/X7in33AVwzboH84/r0sL7jmm2A4XuC1R3o+Qa66owettVdxhlLiA
 GyZXWzMu
 Cl22i6JYnAkOxMSQFy7d3GRZs8Lv+73l47H90
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

On Thu, Oct 30, 2025 at 11:54=E2=80=AFPM Youngjun Park <youngjun.park@lge.c=
om> wrote:
>
> The scan_swap_map_slots() helper has been removed, but several comments
> still referred to it in swap allocation and reclaim paths. This patch
> cleans up those outdated references and reflows the affected comment
> blocks to match kernel coding style.
>
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 4f8a1843262e..543f303f101d 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -236,11 +236,10 @@ static int __try_to_reclaim_swap(struct swap_info_s=
truct *si,
>         ret =3D -nr_pages;
>
>         /*
> -        * When this function is called from scan_swap_map_slots() and it=
's
> -        * called by vmscan.c at reclaiming folios. So we hold a folio lo=
ck
> -        * here. We have to use trylock for avoiding deadlock. This is a =
special
> -        * case and you should use folio_free_swap() with explicit folio_=
lock()
> -        * in usual operations.
> +        * We hold a folio lock here. We have to use trylock for
> +        * avoiding deadlock. This is a special case and you should
> +        * use folio_free_swap() with explicit folio_lock() in usual
> +        * operations.
>          */
>         if (!folio_trylock(folio))
>                 goto out;
> @@ -1365,14 +1364,13 @@ static void swap_alloc_slow(swp_entry_t *entry,
>                 spin_lock(&swap_avail_lock);
>                 /*
>                  * if we got here, it's likely that si was almost full be=
fore,
> -                * and since scan_swap_map_slots() can drop the si->lock,
>                  * multiple callers probably all tried to get a page from=
 the
>                  * same si and it filled up before we could get one; or, =
the si
> -                * filled up between us dropping swap_avail_lock and taki=
ng
> -                * si->lock. Since we dropped the swap_avail_lock, the
> -                * swap_avail_head list may have been modified; so if nex=
t is
> -                * still in the swap_avail_head list then try it, otherwi=
se
> -                * start over if we have not gotten any slots.
> +                * filled up between us dropping swap_avail_lock.
> +                * Since we dropped the swap_avail_lock, the swap_avail_l=
ist
> +                * may have been modified; so if next is still in the
> +                * swap_avail_head list then try it, otherwise start over=
 if we
> +                * have not gotten any slots.
>                  */
>                 if (plist_node_empty(&si->avail_list))
>                         goto start_over;
> --
> 2.34.1
>

