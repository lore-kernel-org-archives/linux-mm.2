Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46A38C44507
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 07:18:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35A516B0093; Fri, 17 Jul 2026 03:18:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 331CC6B0099; Fri, 17 Jul 2026 03:18:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24A616B009B; Fri, 17 Jul 2026 03:18:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECB756B0093
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 03:18:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 780C014025A
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 07:18:17 +0000 (UTC)
X-FDA: 84997415034.17.23AE4B1
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9820340005
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 07:18:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hs5V90i3;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784272695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EV9wvpxnRD7h/+owu8sIBU8oD93XUa4E7VJkGLtvTnY=;
	b=7rQg8WC6n2J5BoaTb5e9sfdxCbMaGPjjOa+jraB+/Eyt0yVtVG6M3KdkYAsqy90K10Ntsd
	+0UwfWq9eoHzwFprjUHH8zZEiM8APr9kLwhukxGgDaBw2v2mYoBeuLrppJTmGZiM342dP0
	eObhuQUyhWXTVpcbX7nLzIaXU1733L0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784272695;
	b=2C5uRzCw0DIb9dNKtYzxh1vzpDxEdRoqADdpjsVH18VWfgqOIJzlJXhDzbwbveEbRimXb5
	Rvg9QWKlh1/2cmCVFsw1qU/CqsNEoXc3bq2T9e5cL5Y6kxpWGrOH45/JCcBx0d4vV6dLa0
	2Rumw/hvDU8P8y0qVPbK9+ZyjDFWeMM=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hs5V90i3;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c1600d040e4so214070966b.1
        for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:18:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784272694; cv=none;
        d=google.com; s=arc-20260327;
        b=kw2/aLTeR2MfKWOeLbsBgh6+fkHDSYDtJSzFSV4kLb/nRgnarQE/RiUlwgFTTCZObx
         k5SsEcCBLSv5/qcU6sBqBMMZwkK3ZyorfN62ELmft+ErQMf9JZ/G01RiNVXoEmZ8Nbd+
         M0ATmKKvuFHiRxAXbHMHQ/8zSha+pI76PJI7WoGZ+YVC8HpGuqGgqcrgdhVpAQv1EpXj
         jqN3yVNB0JLnBevs+UOqLCW7GjO0Wrk5p94ajJEXbms1g9Hz1spMEWRZmwoZxI176PBl
         f4bdxh/bKT28hUsKHJdxIaDAVhxipcPV19c8A91t72joISAnVSM43VbLsRzMCvY6knpR
         H66g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EV9wvpxnRD7h/+owu8sIBU8oD93XUa4E7VJkGLtvTnY=;
        fh=cbl1ETeVj3bwOorME8MtvWUqGl7XZ+Jb/+B+TRyDz9g=;
        b=RHfqhNkl9a4FG6/Ez9RuEvIm1nfnUECSvveG1w7aU2se3Qj5/ebCO5zp+StXA69v3v
         djI4RKrN7Fxg6WWfuVkyD+pEZwJZ49nAlgay3xYSPsGwY9EzemwUMAmBa4Hs3F9lEtPe
         o/rspHYJWaRNO8CU0ivJcy7y57fl4hKGEZ9FEOVhzKH0wDtBknDjX6LulHyIDTwCZXFT
         qHfQkPcqITgYpCQION+0E1DYMtAia9lljqd+wYz9c/c2h/cNvtSxXCYPhew3XfkJgDRt
         q4Wb1tZ7VsKUOYvddgxdUNFY88vlapZ/uYv8Wq6OkvpONFKan+rc+pGfE427tcB16ln5
         0xhQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784272694; x=1784877494; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EV9wvpxnRD7h/+owu8sIBU8oD93XUa4E7VJkGLtvTnY=;
        b=hs5V90i3f5urIWXAC3V58P8L1eM792FhC4ThC3lYJlXy3D+NSS4dDH69euaRm0DAAX
         9C5n0lRy9Wn63jkZIxk0k7zE5gObYCuXg/hFXIzFqZSDKEFTeMA0uhtBD6UpQflu3BKd
         Wu4qCUhCoWH9UKJV9k+suAXj+iyuZTrFFsc49e7/fDYhMqpP42+V2ZoCSMIo4DFJbkBI
         jaNF2TbgpMYr3aNlJ7EW/13PH2aoujzAKkEYjsVu7us8rR4mnzbW1SVsGBzbTH5kpa2g
         rRKgWOZ99tAWJFMTUyQRxMLmY6WG03jeO7GJ2xEK9cVABATuimpDIVL4G/pvL8fSvPx3
         t0Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784272694; x=1784877494;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EV9wvpxnRD7h/+owu8sIBU8oD93XUa4E7VJkGLtvTnY=;
        b=jkXBi2w5d4g+HQv288KVccryERFOTAZOAv962Q3J/SQ4O7XEmRlNx/4NrzSL+cMupG
         Y/p8va11qB/SwgOoIYaOlZwHs29+OjhMBrGkUREquKryUfL12+IUiYj10RTO1pNnIhzU
         qOVrm67jLfTNVRQVga1eAk+jhyy4Y1k+lSMSko9zWGAqegx6KUBSHEIHHYxEHC/OnrKl
         9wyERM2A4UMZNmX+rtmJjQSlzC+CnnYd9837WoBnMxf4ipaU9iUPhCs5u5ro6xmfr8og
         2awV1/l4++xgEa/lgIlzfe7yZGMzMv91gPK7KZxbJoBCsIjbpPBwP4BcWqTnz69zRvJT
         1+Ww==
X-Forwarded-Encrypted: i=1; AHgh+Rq2YE8Sd1vwBohiGqhb1Lv7LdvwnHPri+JFelxHi8+TUOH07e7/Epa7jl810jdIaqbxEGeD/0C/eg==@kvack.org
X-Gm-Message-State: AOJu0Yy3RstIkQx8tnbFh1gRy0p98t7Cvm1kcdaD6od1xKmZdKmfcqRs
	mrDF+4rRyj1rY3prLSCNGreY079sEqhsiJSQ1oQYbXtbMdHFtTXPpKERIIs3afaLJsg0CS6Gu7P
	HcF9IzK55gbjeKeFPJcEoq2O2+JZxAC0=
X-Gm-Gg: AfdE7cmip9LnKzXJGSOqcZFpnpb5iPPcuhat86J9pOjyxOnrKL9SJTK5EHYHbmeBxhj
	US9lr3xXNdiRrZDs6dwonBivE9uYajQSVujfyrjK7/a6GBd9YnvDbMRqkb2RQeBEdBCa8c2C7ph
	kiehSfdDpQU6d9KsthdfgbdWO4DbPvAauQhWxBjE2q9FT+B71CFX8Shgu/EiK06Ynfv3Jj2po/T
	ipCW2yfRHzTwzihe/pWn6GSMO/hcDLKJJnNwbjRQC1CKQJDXQkDCg3sdU6Cw8RzZ/0NpUork+Rm
	eUAdzFhw0kPYp6K71uE=
X-Received: by 2002:a17:907:940d:b0:c16:8eb:d8ac with SMTP id
 a640c23a62f3a-c16b413789cmr55168266b.23.1784272693889; Fri, 17 Jul 2026
 00:18:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260717071104.73467-1-hongfu.li@linux.dev>
In-Reply-To: <20260717071104.73467-1-hongfu.li@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 17 Jul 2026 15:17:36 +0800
X-Gm-Features: AUfX_mx1cuXwwuix22B5t3SZ2Uf9WfNjGXN32YWvJMar3Nm3PzTQVW6aW0QKQh0
Message-ID: <CAMgjq7BWtwU5AyxymoO9nwvZqpLo8FMicud8qNTbs0-6NgmeHg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/swap: Fix swap_cluster_lock() !CONFIG_SWAP stub
 signature mismatch
To: Hongfu Li <hongfu.li@linux.dev>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hongfu Li <lihongfu@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9820340005
X-Stat-Signature: yxt36bkw1ex7uzbyq99sgarxy64wbnb9
X-HE-Tag: 1784272695-90504
X-HE-Meta: U2FsdGVkX1/o1rwNawIy7fcl9d8put8rP0Gl4wvHUYXdekVlNv3Gp8PUgI/gvVTIrMu7WIZL7fcoW+gaU8yLwv72X4dpRHa36QWUmGTbaPjSDJP0FmrWkbruZGN6Tcma3SZD4j7iEizR2BQU60ruFbSlRDLWmTCRIoCVdobyQQ3Z7G1vXfuzW5mecIsjM0WJCOCW11dbTNvS53hBnLB/v/SIo39i5nwNavMnUKMPWZrOu38GSYeY+LT0hpAZ+qLQHgKBGd5TPYSE9hyWNWfL/MJIBawKzcB7nLQ+LSsAo7in17nTmrnGsKxZGnL1CIzvVX/6MKWOlSENlA94IHTHUA5k8oZlN2jgCFNq8SfJAptnrFKDbNWjbCPkL9oSh0dp9InP1r3jl2JdKppHHct2QgMgDUCKVJAh3LDJOYfOqQ6HVfrzdsGusedV+iTgdNJuJYKxagvAx2FqDiP1tUZPXJkuJscuCkWLl2K9vHvjdKq2HjAXYmb4YZm3JwNKgPJYfTA0ogZhUW7xxvDwJDHaJHOgfLZX2E0lK+usJwo6Rk59dl6uSCpaGnice7upE35JpWGkRBtyvGBIb9errnPkMxCdBl6sDlunat8lsNeUqCFArdFbNSfoFUrZrnJ358riBtuV8ScdK3CMtidixyNEQ3aql0/LhcJl9cGk2R3veBSbKJY9MTLTnAiyd9GFkTA/WtrGCnnZ0Bq33CspB7tErjJvRYHDnQ34Ys7BhPzQw5DS5vHxvuUD8lU4Or8dE336Z7tKCfwt8QsvAxdFFWl6UHuWmQqb2ZHaRtOaQpgCuqLKxXfna2aeJk/099sOI9DFPV67plEATl8aHmBohl16hP6XkBuWuwmeFDj+TicunkxfFOkBRmDaI53MyxX1Q6rSegqbJcoNCz0EBDVlK2ZI51lcMe8yd4AQdTfSe4t8SpQkx+dqJhNvg6gch/mWx+MrfgGQsVPdN9tCqAnDFE5
 IINaHI2U
 Uer07G9MZZiEf2JvXf1Hs8XF+uays+WEiozlysaouJZfYPvgn+3Sm6DjrH8SWhxArIs/rtbLFoQk8H+gCEMunXQYusyE8i4TBGDpqZcgnI/OjOesYvn8YRfLmIN1bsosh7OniQTWvzC/9DQxHdMYj1rKVzZ8UgmqDj7gsdxmxGNnYalY/Pk17e4jEPWnUY+LGnhZaK48Qe90l9YCyIo/x12L6RMfCdw/6vvTWwcr6cgjMJ2/jy2M6EqRy9iZgr+rvb3O3r1mtoMo9ThbmQb1Q7bX/C3LcbOnh+sCmftE5NOZdskGCv7/oCfGCH2kLhpJXFyO12/5PYbUeWbmSO0LrO2LjZqV/NyihbMY2+NI7b7BfjiqKonJ1mfJQUsxSw+pJnG0qC0Ja08I7gfl6z8llDEVJAcLzKWjnA8smeXbenyO4ATOwHz7FpyEELtEHsp9YIEr2cCVoWrA0qPIgWrPHbWX4s0XxMA1yMzpjT57YcP6k3auxwelN9PeYNa0CawU4DH6JpbT+IGAgbQIvN4hUiz3CR3+TiI9WvLM961Y5wqb55Cs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 3:13=E2=80=AFPM Hongfu Li <hongfu.li@linux.dev> wro=
te:
>
> From: Hongfu Li <lihongfu@kylinos.cn>
>
> The !CONFIG_SWAP stub for swap_cluster_lock() has mismatched prototype:
> it has an extra unused irq argument and uses pgoff_t instead of unsigned
> long for offset. All callers are under CONFIG_SWAP so the extra parameter
> is dead.
>
> Delete the unused stub function entirely.
>
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> ---
> v2:
> - Drop the stub entirely instead of fixing its signature. All callers are=
 under
>   CONFIG_SWAP, so the stub is dead code. (Suggested by Kairui Song)
> - Add Reviewed-by tag
> - Update commit message
> ---
>  mm/swap.h | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/mm/swap.h b/mm/swap.h
> index 77d2d14eda42..d7834888e0d2 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -336,12 +336,6 @@ static inline unsigned int folio_swap_flags(struct f=
olio *folio)
>
>  #else /* CONFIG_SWAP */
>  struct swap_iocb;
> -static inline struct swap_cluster_info *swap_cluster_lock(
> -       struct swap_info_struct *si, pgoff_t offset, bool irq)
> -{
> -       return NULL;
> -}
> -
>  static inline struct swap_cluster_info *swap_cluster_get_and_lock(
>                 struct folio *folio)
>  {
> --
> 2.54.0
>

Acked-by: Kairui Song <kasong@tencent.com>

