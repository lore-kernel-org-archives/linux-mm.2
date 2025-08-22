Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A147CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 09:59:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 341118E009F; Fri, 22 Aug 2025 05:59:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F1DB8E009D; Fri, 22 Aug 2025 05:59:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 192458E009F; Fri, 22 Aug 2025 05:59:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F240F8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:59:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C4E6D138F3F
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:59:09 +0000 (UTC)
X-FDA: 83803945218.29.6158E8A
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id 062FB40006
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:59:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=ypeA9D69;
	spf=pass (imf04.hostedemail.com: domain of ulf.hansson@linaro.org designates 209.85.128.180 as permitted sender) smtp.mailfrom=ulf.hansson@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755856748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4jzcaBapb+6lT57he/oxZQhjVy95ULktosVCVAZaO2s=;
	b=tg6mkOc+he6RaJvHBCyWo2LuwlmWaPiQpPYaMlwsNKMBN8ONcR7usI2KKp6VU8Q1qP368z
	tuJhgE4fPZG1WpZXoJuJwIeHHJeVM2lvz+JrxWlBSmtAXLgvnhU8GN0umNAAONwrPg4aRn
	YPnwf1HnkZz6KAAuzdyYYIkwyUz3L/M=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=ypeA9D69;
	spf=pass (imf04.hostedemail.com: domain of ulf.hansson@linaro.org designates 209.85.128.180 as permitted sender) smtp.mailfrom=ulf.hansson@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755856748; a=rsa-sha256;
	cv=none;
	b=BxrYKoUlTQ3lsb6Vy2NmMxEVjzV0BAhOoV9zXme7V8KqNh/oh4Y1eN41o70M0ERdZvnYFB
	WM00l9rufFCrbesFxG2+i+2dPKhgkkCRtLWw1qi5CSZjX7aIybsQVtNNEkb0Kwm6hpZeko
	htoyuUoGwpewt7Dr8wSBBCLtHKYqBJ8=
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-71d605a70bdso13272527b3.3
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 02:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755856747; x=1756461547; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4jzcaBapb+6lT57he/oxZQhjVy95ULktosVCVAZaO2s=;
        b=ypeA9D69HanWgCpfmEd3XOl50K/G7dmlAiGOAjelnXZo77cSBNXqYJbBMVnXatvbZE
         v1XSOtMrh84AFqX29a+ywYGMW7N78I56zds5CNj7LH7FXI1aBFxkmLcqFqNQv4A4Ap1a
         24h1kAsRnU1oPsjo0HBwfjEah/+PpZuESiPdLoFXILzWUYTX3eqpzYj8+v0oAR5LRK1I
         Z7wgxSkecjYSp33sXHDPpASkdGtewOy+zXYyA1OCXaSiDv9pwwN/ETK3bIdakWoLaml3
         AmA7Du5MgqjYrxl6LFC39K5tiSA3BwUupPlp44WbY3BWiW08xF3+Jnu00Eo1EOTd5V5+
         dukw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755856747; x=1756461547;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4jzcaBapb+6lT57he/oxZQhjVy95ULktosVCVAZaO2s=;
        b=VEBVcC+1tFwjJ6lNBQfc3kda0KcNce2oDyXpXARK7wd+2/Wzzs6422hZM/gtNWnz06
         vypjMlRfe+3RzuePUeKDY2TDtpDUT0LnNrqORYmdYGiYcjreGLKTV6r6c8LHFEYOfqrf
         Gn1y3CMFQeIRSlrxK3usNRE0a8VeAxUGBq1fH7/k5Bj+fRieztLNlMpNzIwYw6pouSfl
         4qpyWZ4dSeoakfQk9nChfKePGJMCWOCy/Gutq6Q4s5J40yytEOP6TrfPVKR0ZVjp4fXm
         4jy4Ce3L6cN356mPWZlpLmi2F/yZloH0vVmbWeDdcHVdEgnvmWUCdoKUJA0xJuT8JZyI
         bGqg==
X-Forwarded-Encrypted: i=1; AJvYcCWKM9DoeBV1ELssOlYu0OLZqvvZIFbhUHSbLD4oDSIguGi/4iCfTya4URdKZatllxFNLBS4wzSIIQ==@kvack.org
X-Gm-Message-State: AOJu0Yw9yI0ftN5wXR+qv+rWotxJQTJtlISB82cTjFsRBq5VO6eoKEqw
	JQzBE7F+xvP1f6kLHoLkakWvf9JU3PywRreFsvkafGt3KruAYj4bLhiep67g4quwNowG7HGh9pY
	B7mE6Vu7ZuIPW1evxDPWFEJrJL4mkzgMImwUK7L7WRXuSRcGA817B
X-Gm-Gg: ASbGncsZXn+TVWt5Mtf2mmfU+lxt3wXalCmPThvjp2snJDimCdi9yUzUh+FuBdy8tZ/
	p/6geR4o3hZjnVgfoJ1rJSk4S9CKpSvU+y3g4pFGCLlKY28YEu3FkYbd6y6XRZXldyeXS3fchp+
	jEUChiUCqLh21IfwyXSHNgB5H2uANbtzttYvlzXPWFJuEDKu21L8wslr3zyL5hNsJCnxdpPlYsh
	4NaJJV+
X-Google-Smtp-Source: AGHT+IGB9RjTkkD7B2b1TNcFgf/SbdNxy4Un5NVzcbV0bGgOMYvHf6W1mefgrwFYH3AHHfmz4nw0AMYxpykQ3SJwTgw=
X-Received: by 2002:a05:690c:9c05:b0:71b:66e5:9b54 with SMTP id
 00721157ae682-71fdc3d087fmr22061587b3.28.1755856747069; Fri, 22 Aug 2025
 02:59:07 -0700 (PDT)
MIME-Version: 1.0
References: <20250821200701.1329277-1-david@redhat.com> <20250821200701.1329277-29-david@redhat.com>
In-Reply-To: <20250821200701.1329277-29-david@redhat.com>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Fri, 22 Aug 2025 11:58:31 +0200
X-Gm-Features: Ac12FXxyJ-t2LbDQilDuu2ZIZImx4clXac153FHlc5EW2k5KLO2D2OEzTjtN-RU
Message-ID: <CAPDyKFrvsyB-1Gs5jW92o2RAs6i0dF6sPxGr7us5QZymFcdQdQ@mail.gmail.com>
Subject: Re: [PATCH RFC 28/35] mmc: drop nth_page() usage within SG entry
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jesper Nilsson <jesper.nilsson@axis.com>, 
	Lars Persson <lars.persson@axis.com>, linux-mmc@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 062FB40006
X-Stat-Signature: c713389ji1qtof5fj54y3ir3q7uadwka
X-Rspam-User: 
X-HE-Tag: 1755856747-618986
X-HE-Meta: U2FsdGVkX1/7v3CUVJPvcSUdlyDzX/46lgX+3nsVdkuanF4mMI4jDAxgmgTGTcWarZqYr6EDQMwTohPr+FNA/7a0/4LdZSvkmK0SsyfmZeg6TLyebzNHkgpcbE6uSyQCPut1Vtp1bfpHRhqHrlwVQXd0Y+6NS76QcJ9nVneZAmkKvHv9pUWDCa+fkrX2lH6waQfzu9Ay3aTWTTMJyvgPQuwSP5B/rMrSk3ftEnzxIQOnfcHbVI0z3jInTiSqnALrHxsEDPJ6yBumV9sakZrJYFryrzynTH8bjbv9dCiHA+UGVKHZIVcuINs2tQ0ezli7StvlUN3kxUAC/DLOs/yW6sLQIWFA8CmK9+DJBRfP7pqDDJspl93RXp9Z5r2MXYH082DCK7Jnx2ePXGIJ5iz4hwKbzerm5i37bsZvho40DMi1/aLBc99fbEbXBmICSUKnedD4niuoCI1ZTsZ0FLOJ4PYFLjvygNmzjiPxnWlRWUPJbK0JwBNz3fwSCiLcsnPaZ3mEA7v1UXVJlR+z0ppjEggEW+x7RZ1+4hKoCvZLnSZLrRqc1+Tw8YYNl2C4n/8sAGY6jw6Ix6NiRgMLr65ZSCIOvbnUVHF1KfuNMdUGNiK5RhhQTFq+P8oex8V3k38ADqwRu+mp9fmp5p/Xho3ba/4+2WOsJXMOSYvli6lVOgEQPHTXR9eEmo5AKKLvtHjaUdS7/lw2iw8GfZf7ZU8XB9SjQrdRHuKSDZmSjuLu9JPLQW28ECF9fFKiN4Rlt04GuSrwaQa4RzBjF9M6uBFbMFfplphLQp8L5UFjLE7LMVHb6UB1qI7fSkk2PJgzU6+Y5XvqICHECbMoZ5A2gO3F7OQhTqYjOrKfoHXqE0+iF5ebdeAAGqZjn4mf8GRW89NedUBiIkQ7JKClsvm6OTRHxelGqo8ilTo1ZYKbFqFrXOC4PyNgy9HTrmlgnD4ZBRnlIupvD/kt7mFudUOrCIF
 H/r6hIq8
 0wSF1TGBOylkgSLdhMTxODFuXqTpajyo8Dt2fk7VO/COChegeYIzu4GbEXNQiCtzHyUq5iMygBbpjZFacKdLYsrCNbDCils48nd9L2oTzUevf3WhpvnaeJY5m91+ZQFofJTz1zddGHoLIVCoUAbxWQbr7uEvOLXokjdjlQZiXeBXONaPy8BgQ65vyGbcWrhj/DHVf/MnzwaRrbidELMLmZGIkoaL4GvKgdsESwn78Vy64R7eq36ckSYQDhi09gp1BPXQHz/ESqIUrcW3bXvmsp8DOBiaWwYs5R2ftdzn0gj2hQvgEZFI/9R6UfosjGcnLnsITEejcMUEWeDIGMkW3WyL+K21DIhfpuiI8+nZyNyYEQcfktOAljNV5Z13uG/x/SOdH5lJpeIWuPVo=
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
> Cc: Alex Dubov <oakad@yahoo.com>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: Jesper Nilsson <jesper.nilsson@axis.com>
> Cc: Lars Persson <lars.persson@axis.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Uffe


> ---
>  drivers/mmc/host/tifm_sd.c    | 4 ++--
>  drivers/mmc/host/usdhi6rol0.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/mmc/host/tifm_sd.c b/drivers/mmc/host/tifm_sd.c
> index ac636efd911d3..f1ede2b39b505 100644
> --- a/drivers/mmc/host/tifm_sd.c
> +++ b/drivers/mmc/host/tifm_sd.c
> @@ -191,7 +191,7 @@ static void tifm_sd_transfer_data(struct tifm_sd *host)
>                 }
>                 off = sg[host->sg_pos].offset + host->block_pos;
>
> -               pg = nth_page(sg_page(&sg[host->sg_pos]), off >> PAGE_SHIFT);
> +               pg = sg_page(&sg[host->sg_pos]) + off / PAGE_SIZE;
>                 p_off = offset_in_page(off);
>                 p_cnt = PAGE_SIZE - p_off;
>                 p_cnt = min(p_cnt, cnt);
> @@ -240,7 +240,7 @@ static void tifm_sd_bounce_block(struct tifm_sd *host, struct mmc_data *r_data)
>                 }
>                 off = sg[host->sg_pos].offset + host->block_pos;
>
> -               pg = nth_page(sg_page(&sg[host->sg_pos]), off >> PAGE_SHIFT);
> +               pg = sg_page(&sg[host->sg_pos]) + off / PAGE_SIZE;
>                 p_off = offset_in_page(off);
>                 p_cnt = PAGE_SIZE - p_off;
>                 p_cnt = min(p_cnt, cnt);
> diff --git a/drivers/mmc/host/usdhi6rol0.c b/drivers/mmc/host/usdhi6rol0.c
> index 85b49c07918b3..3bccf800339ba 100644
> --- a/drivers/mmc/host/usdhi6rol0.c
> +++ b/drivers/mmc/host/usdhi6rol0.c
> @@ -323,7 +323,7 @@ static void usdhi6_blk_bounce(struct usdhi6_host *host,
>
>         host->head_pg.page      = host->pg.page;
>         host->head_pg.mapped    = host->pg.mapped;
> -       host->pg.page           = nth_page(host->pg.page, 1);
> +       host->pg.page           = host->pg.page + 1;
>         host->pg.mapped         = kmap(host->pg.page);
>
>         host->blk_page = host->bounce_buf;
> @@ -503,7 +503,7 @@ static void usdhi6_sg_advance(struct usdhi6_host *host)
>         /* We cannot get here after crossing a page border */
>
>         /* Next page in the same SG */
> -       host->pg.page = nth_page(sg_page(host->sg), host->page_idx);
> +       host->pg.page = sg_page(host->sg) + host->page_idx;
>         host->pg.mapped = kmap(host->pg.page);
>         host->blk_page = host->pg.mapped;
>
> --
> 2.50.1
>

