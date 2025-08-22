Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F174BCA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 09:59:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C92868E009E; Fri, 22 Aug 2025 05:59:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2F298E009D; Fri, 22 Aug 2025 05:59:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F60D8E009E; Fri, 22 Aug 2025 05:59:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88E408E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:59:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 369A0BAF24
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:59:05 +0000 (UTC)
X-FDA: 83803945050.28.444E63B
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5973D1C0007
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:59:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=KD8n7R3b;
	spf=pass (imf18.hostedemail.com: domain of ulf.hansson@linaro.org designates 209.85.128.173 as permitted sender) smtp.mailfrom=ulf.hansson@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755856743; a=rsa-sha256;
	cv=none;
	b=WAPoQKp3Uz9QAui94Z7N60C4HWFMo0lNg1eHwMUdAxwUHCzbYfGNYqlXzEaaNS4PnXY8lb
	HQ3bI5g5rLqYAcna/F303aVBPYAGpS6SqRZGX2oOZRHJKvfiXzXXI6crNKJH4sxLOaFPTK
	UnlsSTODXcGW77YPYzfkO0sjoelZKVI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=KD8n7R3b;
	spf=pass (imf18.hostedemail.com: domain of ulf.hansson@linaro.org designates 209.85.128.173 as permitted sender) smtp.mailfrom=ulf.hansson@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755856743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MupVyM5V8S7xfEuqt+V4G4FxecFOk8NDMM0guvbljvg=;
	b=yevZEyhQOOXTbz4uEddUEKAts5aczYR91T62EOygk5RbmW8ThMmlZad7jl22j7D0HLZiOD
	n3Vob5hWP6dDefamF9hwvmCu74boiS6NLKvdgyXwwiSI5MseJnvqlZIaHcbdtTTDyhPb8s
	8HmcybkPoiYEAXzwx8xxcgGP35ysaEY=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-71d603b60cbso16840967b3.1
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 02:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755856742; x=1756461542; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MupVyM5V8S7xfEuqt+V4G4FxecFOk8NDMM0guvbljvg=;
        b=KD8n7R3bSIbaXoZ2eYdJXRW2l06At2D5M3RYWF3wFM7/yB0n0o9NxLqx4QAkcPQQwJ
         Yc6pvco16nr6Mm0hXWeKPH9mCGU4Lkheti0kP3NFeriNVsJJ4yDi/YHTwfTansZ1JGyb
         K+tjMmoD/5pCIIuR0HD74dxjyAdhQfu2nNkxq8qxLAE0YjdkXwnZFJD40PW+1ieUEbac
         u74Y+smz0gZRH+JIHh5h/cOotR2FG/N4DHYtJdJGkskiaQV8Ln9x9O1y9WNPTRC+goVp
         86oghCJuQ+GNrWSMuim5e7PfNTdo+MccLIFzEbYAvgHASgzg7kdrM8Wy2UBr2tQWJoXu
         x/Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755856742; x=1756461542;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MupVyM5V8S7xfEuqt+V4G4FxecFOk8NDMM0guvbljvg=;
        b=q0FaMaVnlK760lSXGzRp5NWfnNdQ6IBzeTXZKwuAAasc2EYO3BeqHwC+eoRa6zKip2
         FkOSJOZzigW9ocqKnhvyuUtc5KJL5eQEG1+jUobqOu12ipPhX4w/wtoFCTTWjl2ZcCZv
         fHXPt7OAKR4XImZvf8D/rUJM17Fsw7UEmE9A9lLGdxmnOtDp9MipcBGvxUSDRtn96s+G
         dYIQQVPwzzh0g8sKHSoE26SGwNT6NPD4y/Cq9jpV76qVFRAImW5noEswfYj1cGGCDBaS
         ZOirxaJTLuNcgssXNj6hBfVEOIlWAq4pgm81uVjK+PRDSSSTPNS9Q+KRyBoVOV8nf0q8
         okaA==
X-Forwarded-Encrypted: i=1; AJvYcCXd6KDvM1waIhcNINlAfYd9kA1n9XLM5FGC/AjjAQEkw/SHhNShfkZKowPBrqricEUD9ZDY1/gl6Q==@kvack.org
X-Gm-Message-State: AOJu0Yx9Udet/RTDNdixcD7i5jLFoa1feMeNscfAWWM1kHahEPsvB9cL
	8xadeCMwRii8FLcYhYN2Imof5QzU/jzOUBcFD5UpreW/TGtZ8mh0sl8QcOWkcBAEkUCg/U6Nm5J
	TME8eqloojY+fMjQyLhFNTUaEg8y0nWiqMDaC/AtdTA==
X-Gm-Gg: ASbGncs4X7LuUe0HZs1aWLPFMKTp9RvIAWRpdQ2ezSyTtu0PQ9wZpsWP4ZLo9R5tpET
	gw/1Pd20Tb/W5lnL0TPRMw5QEnQpPahuZRYgpNBH+hAP2MiE0O3KbLGMgWcaZW8BGhw2iwjJGQM
	rlIKpyjzFCpcpSJseC6dPycMC8YRnRWGgegXh6qN9uX2QRcaqSjpopg5RCWvxxRPkXQ9AGf2MmI
	aVsfFww
X-Google-Smtp-Source: AGHT+IGW1UTX6fQaw19toVL97OISC/Ry0Xp6bS03YAWQ8SWHpLi2Fv4YjzcA1kwnxqqHARhMhn919UITNadOtX73TGY=
X-Received: by 2002:a05:690c:7006:b0:71a:1bbf:bc04 with SMTP id
 00721157ae682-71fdc30ae9fmr27985117b3.19.1755856742203; Fri, 22 Aug 2025
 02:59:02 -0700 (PDT)
MIME-Version: 1.0
References: <20250821200701.1329277-1-david@redhat.com> <20250821200701.1329277-28-david@redhat.com>
In-Reply-To: <20250821200701.1329277-28-david@redhat.com>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Fri, 22 Aug 2025 11:58:26 +0200
X-Gm-Features: Ac12FXy5YAgos3FlxeTAUjV_qUtOvnPUJMl5UU6P6i8dKRZPvTVLextRAtA1LQY
Message-ID: <CAPDyKFrMR2bfnra1hWiLwqTqt7AFgALHzYCn+35PqU_wq+GhBA@mail.gmail.com>
Subject: Re: [PATCH RFC 27/35] memstick: drop nth_page() usage within SG entry
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5973D1C0007
X-Stat-Signature: ec74559gjsbengrzas3mmbgq65ng51ib
X-Rspam-User: 
X-HE-Tag: 1755856743-254588
X-HE-Meta: U2FsdGVkX1941UnNhqkn43fSidDQ0d8StNNiB8BdFUWkwsvEYxknwtTMy5csMpUaiQ+2a1JPS4nYbAHdbOQ1cjJUtpv94yhxMwgAuAcAdOABtvjKihCi8GBkSLI3BkhGTkrayG73Qog3BNZKH1QUVnRrTQAnZE7uFFd1QSgHKrDVIxXQJtQOZ8GveMijypL+vtUBQ45U4scb66+S9UuLZzKH0kQqOhVuqLXh0f8jrPIIj/EtqhaMzn0kbtJ/XzhH53kTeeuXx80/IjECq/ja6SUGyq0T52EScBj2yKfl6UF9YZyKEqUHMbcHSaV1JWmZUBuFEL8Ui+7jUzbvEoXsiD5oWU6GCJexUrsfLcu9d2I0p3X3zudDH71/WbWaI+hpq2kM89PfbL04BchKHyfGcHVjurwEY/6W0LlPhl4gzbI6rCRvPccaKVZ67eyOlmdBjMUq+PKtncd3TlxXe81Djsj2Vr9dCGbJ0MsmittZd5CqehnDbMUa0Ply7hNzWNAdMVuJ1QDy4etXZ5VvTJocqnW5QjOZLOka+muZ7Z5ff39BPuHjsbBcxGXbnUpgnxiRNHj20AltI2pscKkyFSJBqnSevVrROfNPeeGaZQALJ9tMyVHXmgOtvlECaE7lulHG0SoFoyxlBc/ngNLIUk5WPkOop/hrbFXlQ2DJ8bgZPi/3WwAYpQW+AifG5H9kXamMDjS0ZcpNzdTYGSm5B6nIB8EpRVeHOZiFRl8dUSvDTFirXWUsn6AerLh9XvwAoTMF6OJZ8FeUTlwOkWAFMziNl+GbDipkqeE5TNNqhW/oLweCmNNdbcYJxBdTXGC/DRBH/O+aZFDOvq7oSQ24ZmWdi5CO/Coyki6p0gdyWneMbo0cl9ehHN39Doft1CNqNlQzfBJeUObSj1b6TOeVTtXtIajTklr6GlmPdPx7UwsY198fqFlKZrPkJG5ke9sULoE+UljIXnJFJbRUE2BNa99
 JgM9aKF8
 1y7pCtbUg/iVFPfnsdXQdtg3dSBQjnDXJtONVVOBMjBqTtx8tgmormsK6ZqC69PbI4N6/cEBRlbxqwOMbye34RU2GGRAcGeVovzIrLNFaJ5vBh+EdpOxIPfaTRCO4mP2DAxu45excWfQZTKDrGEhXExEyjBfprn8gc0bk54N2t49dzexWYokZKFEWAqigL2w0Hrx+9i/o61SHu7OjejKHmMgN3WTK4lyM31KRZxJRY6x6oiIz2Y6+obyzzIBvORUPclURDGJsNtwSD67rLh5C4QFOZjuTeti0Aw9qdsXtjvFUM3CvylaRRcSLVJ9Jxi+hrGbVqwpOOxe9xTeHmpKLEv0XMTMdhVPGgUJ33IpmkgJSl3U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

- trimmed cc-list

On Thu, 21 Aug 2025 at 22:08, David Hildenbrand <david@redhat.com> wrote:
>
> It's no longer required to use nth_page() when iterating pages within a
> single SG entry, so let's drop the nth_page() usage.
>
> Cc: Maxim Levitsky <maximlevitsky@gmail.com>
> Cc: Alex Dubov <oakad@yahoo.com>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Uffe



> ---
>  drivers/memstick/host/jmb38x_ms.c | 3 +--
>  drivers/memstick/host/tifm_ms.c   | 3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
> index cddddb3a5a27f..c5e71d39ffd51 100644
> --- a/drivers/memstick/host/jmb38x_ms.c
> +++ b/drivers/memstick/host/jmb38x_ms.c
> @@ -317,8 +317,7 @@ static int jmb38x_ms_transfer_data(struct jmb38x_ms_host *host)
>                 unsigned int p_off;
>
>                 if (host->req->long_data) {
> -                       pg = nth_page(sg_page(&host->req->sg),
> -                                     off >> PAGE_SHIFT);
> +                       pg = sg_page(&host->req->sg) + off / PAGE_SIZE;
>                         p_off = offset_in_page(off);
>                         p_cnt = PAGE_SIZE - p_off;
>                         p_cnt = min(p_cnt, length);
> diff --git a/drivers/memstick/host/tifm_ms.c b/drivers/memstick/host/tifm_ms.c
> index db7f3a088fb09..0d64184ca10a9 100644
> --- a/drivers/memstick/host/tifm_ms.c
> +++ b/drivers/memstick/host/tifm_ms.c
> @@ -201,8 +201,7 @@ static unsigned int tifm_ms_transfer_data(struct tifm_ms *host)
>                 unsigned int p_off;
>
>                 if (host->req->long_data) {
> -                       pg = nth_page(sg_page(&host->req->sg),
> -                                     off >> PAGE_SHIFT);
> +                       pg = sg_page(&host->req->sg) + off / PAGE_SIZE;
>                         p_off = offset_in_page(off);
>                         p_cnt = PAGE_SIZE - p_off;
>                         p_cnt = min(p_cnt, length);
> --
> 2.50.1
>

