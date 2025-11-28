Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DAD8CFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 15:03:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 519376B0010; Fri, 28 Nov 2025 10:03:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C9306B0022; Fri, 28 Nov 2025 10:03:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B86C6B0023; Fri, 28 Nov 2025 10:03:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 29FC36B0010
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 10:03:02 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DCB73140680
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 15:03:01 +0000 (UTC)
X-FDA: 84160333362.21.5B47235
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 847E240020
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 15:02:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AdEOLtRF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764342179; a=rsa-sha256;
	cv=none;
	b=gCYsd9qK/Yhp2v0Q2mxraPwexKwiMbDJVs0Gt1zqdtR8quoVawbC0qxryKyvzFuImDafWy
	ZQVCIJBlhkyfXSTwbxFOeQVgeNGdPRbPh73dqOPT9Om9Udqt9NMBwjKmcM/u6kdWyPsQ2v
	e2G3l3jliT5J9OnoNdgoNv/nzk+tFZQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AdEOLtRF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764342179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+s8rEgZrFlGGz0+FhSxQyk5Lk4wD6mKu/D3vYhC5A38=;
	b=HywRbMH6fyNpbB3+M85rTNd76BZBo1hLG4prOTAKUFdEVdpkiXfOQPSVSFIGpmk9g4aC6J
	b79EOwmsC8UI8Lyae4gmd3hGBlbBu65gl6+UcVCnjMi6SXFcpkT+9VtarjPavbTBnR8k58
	LZ3G0anCeFhiYWvafOMtwj7VA8e/iBA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 95FBE60136
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 15:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DF0C16AAE
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 15:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764342172;
	bh=GGNlbLQI4n5NWRzFgxbfw4qd2Y5htJABGaHsEqaxPFg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=AdEOLtRFfl4W0QsUDOJIWGM1yJDwS0PgorU8NTONSXn68/k5Z/qm2VaoIxpjX74Lq
	 x6cyIccEPrPX93rhLW2Sz+oU5dU70MnpvTjMV+23Iou44cTooXCs9TI55Sa2HHfPET
	 9m4D2mlp6db35ysYKvDE03SkyOVAZh+RHQGt/AlSjVJExWnGX7KBJicfEiaxlBab9L
	 RiZ0oiRSwoF3mkUzDXlxGrCSElg+FrYf6GrS+h8Sk/F98lA+OwC11slZ7p2zwC38MD
	 bJcePqc8U2MwRaBRDBvUkH8NPEVbI/l41aedFmWPfgYwOJ1mKu3/Uwkvra/Kl6lpuD
	 mME9H0MAHzvzQ==
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-789314f0920so16671267b3.1
        for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:02:52 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWk4B5bu0srkLdPNeiTAstnBaEJys7dTzMQh8oeDbQGDwgVhUUIae+A8aB4iWKn4RH4PCPQDUUiXw==@kvack.org
X-Gm-Message-State: AOJu0Yy6yCfbAhEFv6/M0dmLwZPKnwmN5bBU90DnA/TDQ94t3YFnnBGS
	nCkXrhQB0pj7GJmfDjaVCRjteULNuUf5Ko+FrPemRP8TGUpMxsXM46dIHwa7yq+kmMhCQeOjJ99
	VuB4e5tS1CMeQlgiI4LUUnitWZE2MyihqnZlRsGTgkQ==
X-Google-Smtp-Source: AGHT+IHy1HOrcYZT1XZ45nptlNLZZ9v02zgTE9/KvlzTx37wPy+3/uGCwU7BY4qCXP/Hiu3ubw5GFia5FNjjTRfmX0g=
X-Received: by 2002:a53:d24d:0:b0:63f:ab4c:9603 with SMTP id
 956f58d0204a3-64329399fccmr7897142d50.45.1764342171543; Fri, 28 Nov 2025
 07:02:51 -0800 (PST)
MIME-Version: 1.0
References: <20251127100303.783198-1-youngjun.park@lge.com> <20251127100303.783198-3-youngjun.park@lge.com>
In-Reply-To: <20251127100303.783198-3-youngjun.park@lge.com>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 28 Nov 2025 19:02:40 +0400
X-Gmail-Original-Message-ID: <CACePvbXC-FWKcvE=8GdKoiX7-yeKD1smnF7UbqQRrtdt6D=Z2A@mail.gmail.com>
X-Gm-Features: AWmQ_bmK3y6MkJWVbNdMhQQ2NSWu6LstgAQvhY5sdCG5YO1iId9GHSXA4j0Ovgs
Message-ID: <CACePvbXC-FWKcvE=8GdKoiX7-yeKD1smnF7UbqQRrtdt6D=Z2A@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm/swapfile: use plist_for_each_entry in __folio_throttle_swaprate
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, kasong@tencent.com, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 847E240020
X-Stat-Signature: b3i74wb576g915yrkrmhip78kgc1utba
X-Rspam-User: 
X-HE-Tag: 1764342173-685610
X-HE-Meta: U2FsdGVkX18kDweXTJYCbkK+L/pd7jnCg7wKp1MX6ywKnWkxwO5Nn1rCxfKkfNiu28crlEg3T3Kj0EVyh3Be4NNaDcB/NllXxacV+4zZbqbroURhWoUwVMQFY0RNssmt/eSfnE9nY2LcN/J0rLFTvXEVFI1NUVmp9RLDlPJ9TsBjZzgpShyhhg9cuchZ8YcxqTOg7qnVQzP8sk1GNKemV/24c7Ps7dKxp0c0fUxQxg5CvVDuTFx1EUfjNDsTRaLhA1eNhX3YuP/zvX6zHN6LRT4I2uDFETIgI/ZFcec/s46fXBy7aawF8ClkoKHolxM61E8bXMtPtqgE7rjXnOfNkO/rys71uEZJDOYJizxq+OX6UD+piGgIaUKPukpjmIKXfHAKmS2ypJ5+riAbQt60INvzSJUFhmQy3z3jqeYf8vJb42COv3b5JwXsYBBXAhx7XCpZTZqgh3XwcCtxBXcjytDZp4gaxtJu6IKnEjre5rrcrPIgmlvUs+wHoiBVduXb9F7ufguuWlBPMPQlYAhfA40f4gK2UB+v4x8huvuvLou9MLNEsadlPUSuUbFEM1QiuHkDwD5ZH0O5yYbiugm7Un000fndsJneBmwVf2KVn9yw+WY32DT7GFZkUSJVvYI5VlDnu5+tLKGHjyQbjiSYbIg4aes49Urr+lwurvR6lv+fhI1bC+rqF5tbSUByRyoNwrJGlaKQ4TNWPFKp4Hvv3kuHuuMsgaPZ3oamyoof7n8StdkBytq978j/KuZHAi3XzTMpxyGyFU6btFFd5QR/frTgwsbCcPpVbUtiS4+GR/GEROojgiCFs5JaUZ611n4VCp9eQCqjf5KjpiLvfSWQMMDY0+s6+M4fkHriZFjGNBvgjoOyPTUb+Pp9X6KW/dPryqm5aRuj31KsJ4GavlCagyfs4QTj2nAv8krpLOQmiiPChipk7CbaiFydoUcjvd2J5esUhYYNJDmKSIqTs0a
 GLgc6Sd/
 Grf7aSN0uVByVioAJv5tkEGa6XA8/B5Y++8K54o+FgQ5+3ow2nj5Hp1kCcZ4Kxsz6nuI0KGJyOSE8V5kB2hspwjjBB2TOYktb0y7+fvXgezKt/hsGS8OL7QZ8AO9RUzK0Tgr32hpZ84JSoxYB1rLn5qEmuDGCrt/OFwsEan1+Ue+Gn8SZTs7Gof66wFQ7O+qIWE/WaxmWN6G8N3YMH82o7lnp0+mLjliPrlW3OIT/Mlec+yZ9Ke+AcbEJRuqn87wucTLusjzda6fUwpl+5l8sEJN27700daB9mpzFU8ckF+QRU5SNkZQuTjCDAUNyro/jvRksZAnVEFBM+zeY/O5TGNhGPyGYLWJ4Mge0taQ9eEL9NVaMZSu7sLWuiQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Youngjun,

Thanks for the patch!

Acked-by: Chris Li <chrisl@kernel.org>

Chris

On Thu, Nov 27, 2025 at 2:03=E2=80=AFPM Youngjun Park <youngjun.park@lge.co=
m> wrote:
>
> The loop breaks immediately after finding the first swap device and
> never modifies the list. Replace plist_for_each_entry_safe() with
> plist_for_each_entry() and remove the unused next variable.
>
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  mm/swapfile.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 8116f36e440b..46d2008e4b99 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -4023,7 +4023,7 @@ static bool __has_usable_swap(void)
>
>  void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
>  {
> -       struct swap_info_struct *si, *next;
> +       struct swap_info_struct *si;
>
>         if (!(gfp & __GFP_IO))
>                 return;
> @@ -4042,8 +4042,7 @@ void __folio_throttle_swaprate(struct folio *folio,=
 gfp_t gfp)
>                 return;
>
>         spin_lock(&swap_avail_lock);
> -       plist_for_each_entry_safe(si, next, &swap_avail_head,
> -                                 avail_list) {
> +       plist_for_each_entry(si, &swap_avail_head, avail_list) {
>                 if (si->bdev) {
>                         blkcg_schedule_throttle(si->bdev->bd_disk, true);
>                         break;
> --
> 2.34.1
>

