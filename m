Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 281FFCFD2F6
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 02:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57D0F6B000D; Thu, 27 Nov 2025 21:46:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52BF46B000E; Thu, 27 Nov 2025 21:46:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4683E6B0010; Thu, 27 Nov 2025 21:46:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 373656B000D
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 21:46:16 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C8D74B835D
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 02:46:15 +0000 (UTC)
X-FDA: 84158476710.29.14C2060
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1269614000A
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 02:46:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="hzr/CRvt";
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764297974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=74wrel5HDJJNYTyOOQpdyeev3rHJnQP6jyPpPcoKvVs=;
	b=l4xL5LyE8jrbA80/afqKaINES+u5pZzsIkyIOcBTln8uZ4CvZzmVhx+Fl4KkwB176XsYrz
	5rVK/MkACg+V/OBk3j4DQt0oadI17ZWd/dcloZ7hGOBafitkZUe6w1hgFXTOKlpqgNYCU4
	IdHXWMWdY+jwF2R/TT02qQvmvWjRC5I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764297974; a=rsa-sha256;
	cv=none;
	b=vcmgQ39m28w/o6aEorIzcFUqHI97afXAQS4xLYVzJZjV/ksXLqUnBt4JqCdEQlSZAQuIhL
	F5jvbbpQx+KFMY72HQEk7wl3irpdOrya6uJ9+uLyW6ZVB3I8QKAzeslB4+C9Qhqwt75ygH
	Js7MUu912j6B40FfAwBE8n94XdsijEA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="hzr/CRvt";
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-645a13e2b17so2219251a12.2
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 18:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764297972; x=1764902772; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=74wrel5HDJJNYTyOOQpdyeev3rHJnQP6jyPpPcoKvVs=;
        b=hzr/CRvtczE7qpYDj3+JyKr17ftLKtwAYngEVpq4Cw11bfRz7rFQ52bW7mO66DKcqw
         oqoqSRlNKT6dTfEHEGw8be/9AsI2bAy8YOwr0vduBqP48A+s+z/OPsaIedVAx9qPhnmB
         GtnPYG4c7Os6OJ4JaRpr9J8h/BgzSXdClvvr4NOwOuLhF1pDnR8C2hEQqv116pk4jTrU
         kXBCOEYfG82aRVoA7NmHNBYYSAYJcceRcieAGbiks8SnvYhAzE4kwqjYHuqu9iMJfS3C
         xWMPTCH5bwWmvfz5W3wER0OUMHw7mE727x3N6YtJFCrSyoC/gWjIDabZ0hvXLHsvxcjJ
         B1og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764297972; x=1764902772;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=74wrel5HDJJNYTyOOQpdyeev3rHJnQP6jyPpPcoKvVs=;
        b=EZwDk7bWLr8lGs2pmXj0o4jbBkzVHgeaamxtzTJp8z89ctsI8Kiq5ep6MoybvzYmqO
         +o3EuFkzmVyuvwLjbACVzbD16/9cwHSCShwkTjhAlawZEy9r+hmaQzkXJiZebM3m6paW
         gmpato8+XZrxIPbyXUJfbHkn4ouixMRsAZaMaFI4SbTuej1O7mkdy2qa6b+f833Bp6l/
         dRzjJV5gXZUnP4RVUnzORLLUBtigWD/M0hLTlds4vbbbrnoGK9Ez7iV7w9z4dBm0vVGC
         wPqTpPlFFPRpbwyW6rxuR4CH/bA8L7CcJ43ydWSut6qbv8lsgBH44UTOKybfzA4J/in/
         uPxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWA7zlEO8Npv5MzcY7PXI94sEAEfIddBMTUfCk+Mrg6s9ASmPLpbugavPoyWZ87MPCEeVGS9pVFg==@kvack.org
X-Gm-Message-State: AOJu0Yxg/t97/8ocoXB0gsRvvl1w4ppKvo0g2ycJl1M9DtEEMoFalYlX
	7ettNXTgOuT47IyQhV8MROokbZfvuU9C1gSq0rvCxQnY8NhLaKQRUm9NZTiYGaCEf94LVho0u0i
	cUIfg4eTVknr6NzpKnWpY/plU83dsSCw=
X-Gm-Gg: ASbGncvtsYZ96wzsMImLSqVSPJaSG8he5vZ+nGT782WpqtYro8oeMwXie+ORESbsfs+
	X4vNMu6060p10U0r/c7sTJakmfipdgl7DQme6ICC1U8JSmIItziKXVCFKXOa/Svi1rJPcHZGA2r
	QfjOTe2PUpFzOekOnSXD8I/u+TSPcM/6hnjRRvnLovhNTEJ0ABCwJ0u/JBqkNcXohV1QprHi/I7
	mMewVNbTrBnU/Uj2tpGKUzblKBfa2sIBxnyEjoNYG5hvhHT3KS13tdZAlKXaIUFMHFtIi1e8LB6
	F2qiA+spL0jftf8HYn6cBnmn+Frj4E9CQlklcw==
X-Google-Smtp-Source: AGHT+IFYSGWxrSPzULuS6rOmkhGtTQEDBKzX7JbEXZGuf7Ce8nO2dKgUj5EB6aQ91STbKKlkc9wK4fDyNcup93hZOJM=
X-Received: by 2002:a05:6402:524c:b0:640:edb3:90b5 with SMTP id
 4fb4d7f45d1cf-645eb2241a7mr11501762a12.7.1764297972256; Thu, 27 Nov 2025
 18:46:12 -0800 (PST)
MIME-Version: 1.0
References: <20251127100303.783198-1-youngjun.park@lge.com> <20251127100303.783198-3-youngjun.park@lge.com>
In-Reply-To: <20251127100303.783198-3-youngjun.park@lge.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 28 Nov 2025 10:45:35 +0800
X-Gm-Features: AWmQ_bkf_EVeHK8-36m-EcvORbKOGrseyh-kQO9H1z-dOPTeMjfF-tRoavRbA9k
Message-ID: <CAMgjq7D+K69Yvb2RW6bh+hq8RBuvNRd=7HAFXxqkeB5NSSnB=Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm/swapfile: use plist_for_each_entry in __folio_throttle_swaprate
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: g163qt1pdhoajcz5zr8ck8p7grrnj1d3
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1269614000A
X-HE-Tag: 1764297973-876067
X-HE-Meta: U2FsdGVkX192Bmcfb5N/ljrlBMeoCLIvm6RMy0jualLhAjmYdgMs0pWJOQo516epf2rVOgv4ui0MR2OpJ7UgeoB+Ol1n0Ry8Og9QwHTlisRTse/OJcXBJhWxH9/EpubBpp+7k7A8UI1tCgMbk3OELACWOVZ5hxJkb9AG0mMhPy/iktuw2p/2z7bdkKKIBVXXnvLJjpEzQWd1slptCoc9lHgB7ADLuqEy8udzVnMFXZ2NHnSg1WuCiIKEEld4Ev/sRFGoF6Apcb9oBwocu1dI3SwCAM+0ycJlIGYZ+Yn9++sLrIRkaqpv+6tTnhilZyyGwtgeGJMjiZeAYBuOdRhOjOw97m+lcNwbKUxeqBuKi1OUzpBdRNBjV8fUzV0Ws9xz18Gx5E6LIIg++Zs+0X4QWW+wbdZj2gQ8MMjN5ebjNHcnTlKwUTs1KYNhZtcbEYCmNCRqSESat5cRphWatGVCKnfmft35FIRIH6KWMQXjB694bkl1we2PJNzoVXoySw1OcJM93mp/Vq6Vi/hubVERv74/zDoAmuF+BMRoUpDNR8laE96axoNQzUSJRZ2WKKPQoeGhmo5BkoCQXhV3Fv+pxf7pKhsjLtOOu/cvd940MvrWMcg/DAlOnhm52AprT82i/zqn7S0elZA4AxWrRkFAsZTvX93kRk2sAZ2GdSR286a6h+WUqEKClQvS+Xgl/hBImVtsdU8WekLzcvg3Ue2HNUTktXpvgYnSxzDgRkF+tPBYDgXx9h7qPZ0clvH68ugLEuy70RsHXBN9B7eqKoNOEyDeLGCrof/EULSwBfIgSWwavi+d2xFYQbxX2lJ3rIiYhgWaZv4NgksulVOJDPtvw09Gi60Lag4iMF+7deLhWK5J4pMwc9YnLLXiH0oMpSEtGO/XhDkQUH2iTEeIB+yYquWYLUBcCadB9wBlYZ7O/M8z7dcnaOaR/8I/GZBecFON+bhBeAf+nJIdFLtQegP
 Hby2/vV4
 UVfi1/zyk3h4iG4bA6L2abFMpcHTzTutqlI+50N5JJi945/vZCehPwXFpeUB7VFXoyP5u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 6:06=E2=80=AFPM Youngjun Park <youngjun.park@lge.co=
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

Thanks!

Acked-by: Kairui Song <kasong@tencent.com>

