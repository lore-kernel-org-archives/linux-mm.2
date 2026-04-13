Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0221FE93808
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 00:34:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 168156B0092; Sun, 12 Apr 2026 20:34:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 140416B0093; Sun, 12 Apr 2026 20:34:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 055786B0095; Sun, 12 Apr 2026 20:34:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E32CD6B0092
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 20:34:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6AC1B160BD2
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 00:34:25 +0000 (UTC)
X-FDA: 84651661290.07.EA75761
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5D7E0140005
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 00:34:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TZh16wRO;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776040462; a=rsa-sha256;
	cv=pass;
	b=8p3Py1X8gBKDL8UtIgx4wRkMVSbTQ2FZwCo63GUAz0iDUXFnBVAPoTiGTrZSzwVkZjZRHy
	eFb20eO2J+rCSPcTpTfOgy4QKIKyqG8v74zMpcMR5iUpYVp3yGsF4JLt+DJNcL4t41j1d7
	86I/HrWPDG/qRCqc7EANLbS4z4qfOTg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776040462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w73mMxBZoOS47MFRjL5gSm7nLgmB1fHxOr3vCQdTPqY=;
	b=a8Pf33raCHjol/Nhq7fnbb9hNIIZZ4JKlkzl6TPUfFlwH0tvr7o5/Hlt5mjogS+BtPK4+i
	ZD4cTsHwTMJhqfPVTofm39EjsCET6ZDlfPGyi4YhXgPMISWk+K8CiOlLNFm06HUc0Ipv0O
	6Nx81fLFQKZn3EPK6oBMn0JlUJEnn8A=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TZh16wRO;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-488a14c31eeso30409385e9.0
        for <linux-mm@kvack.org>; Sun, 12 Apr 2026 17:34:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776040461; cv=none;
        d=google.com; s=arc-20240605;
        b=GJo7A+P51FlGhYc7XmunKZ40/dSf6WIZjrxzCjzhzLCdyyv3SrC9VIklfFM5C4HE1i
         OyswLPkgJBztypsD5X4TZiKcLsoUczqZAeyE3L5QSwlBjGSfW+OOhGIpQMNWB39NmmZi
         L3d85qW/tv3DqHCUDV3axl9/xNOLdt+muVl1O4mB2mRUyY66O5mD4L4xk0X5ueepC1RM
         YESPqHQKx9+5jfuC3OLBN6AyDWhkZ5mPwMRsG/OuoKMSs5PxyW8G1ZpvIpzLzK3hiFJM
         jsu/XTol9wA+eKq2BwVjaUU/wIr0hWZ6drXV8pN1F+BDLWID4qMxRIzQ6eXt9+Hf+dOy
         XkZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=w73mMxBZoOS47MFRjL5gSm7nLgmB1fHxOr3vCQdTPqY=;
        fh=tYxJeBKEY4oYCmk80/KmXEreHYBPPI5kMh4NSTHmH6U=;
        b=aZ1NUFJ/c8xvWIjOxBTYePLecki4wic5XRO0uxgyDhQEoeIyCV5tVOrzByd2oMi0EI
         /uF2cfs+r96vsgWVNKMGEolihejp4Tpkwj1Ycvm5dgoo1oLlon9yr+6xWw30tcfqbz2I
         7nnISex7GjcZpXKypr8rGs843ruigwWThjL7c7FIbUVGK7u/pdljwdKXuNyUHBc6PAw+
         KsIvc+aEAxlDiezQDaDH4bfAAQ8UGameK2n5FEp1Vz2jpyBmURAVcH1aeyHt2Y/7jYD3
         hWTSc+waqqE2/IReMTFVgmnfw8mysGCaPwPXAFaofFG8CrODkIWsfJd+kDeWLrXDrj8T
         Exeg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776040461; x=1776645261; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w73mMxBZoOS47MFRjL5gSm7nLgmB1fHxOr3vCQdTPqY=;
        b=TZh16wRO/fEvVFF3ZAd3waiHbRUxBTC6WNvG1Y6ruIR392e9WobSzGyRDeFaVZlyU+
         1dapLJ922w2SFJ+bbfQAOiDBooKYVQNJgh+ukqEcEHJQA0Orxmm3xZiuoBR8SlCK9/Ki
         tD2Q+ffR4NuxhucbjrMu2LNjvt2PKHD2ot3pxSJY5btH5GBCjSuAD7B+8bkJ3D0bDtMg
         SHpWassW23H+K01h9KYeQLdjM0968t/hxKK/b9WId+ZPQx/C0+H8heB3ubmVO7nYEsMa
         czq/IeYBcJwYsaK/qTGEH3x3dAuaNpSsHV2xs3sdaKTmrzFWEp5AVvvp1Ouk/9NkujdW
         3/zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776040461; x=1776645261;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=w73mMxBZoOS47MFRjL5gSm7nLgmB1fHxOr3vCQdTPqY=;
        b=eMYHd4D3rkINUUO4a9FQxFYaNxdBsP8gG1pCk/QjKASw4R6GktWZvQWwrPtAFfTtOP
         sqpgp7oIc16X6MhRROZYPP8bGoLqZkIS2RnyaTa7B6CSbcXxOUIKHDuKBUdAPVXZRWGF
         p9Sx2DqJvahJ/TpUMyZAnaWXNTIaYYQ4JpFw9ihVcUSu3GpZZYULGIQzc+xtQqyDl06C
         0KxmdHnr+mewXqMMukCKt1tsKDpXIjaYqHA7sWAPfm8eFgJYtREn6kTIXp4gKaJ3IUDA
         cE/o4cgjcl8TEL0OjAQs3deBVTti3/hYNdSB7kt/rg/+WbLzG5RtDILoRBjzt4D3gjTF
         Gt2w==
X-Forwarded-Encrypted: i=1; AFNElJ9ZKXEYhSqfHnDFjYTL/pEDozx1gaQfpQFt3zmp9Yd1j+XuKyn/J632W7OZHrM+rvuyRK+Yl/oJHA==@kvack.org
X-Gm-Message-State: AOJu0YzCB3B+WcRn3ZAR33bG/hlaU/zaeLkdoeyCAn/HlbOfTP6OFIZR
	RScSLBouZfMMG6cIzPybnVOnL0o13D0RBlHFBQ8HorQ1HOIHxtZoOlxl9qsLqruZUBk8CAKNKv4
	1DEjxbmAubKr7AT+A5j61g7oQWJvFvFo=
X-Gm-Gg: AeBDieuZTwJJ2jIbjG5UnhGoAEluBOvqTLZojic6rUkNzCXfuB8FVpTNVEpvd2Mcv5l
	SH6M59nNKmTQNnnfIuRG0H2uoL1560e+wLPmRkV0COxxm4n2/Cd9pfmNcuKSeqXV/WU60qjvinF
	DnE/tc70GNkFwrR6lkteJTPkDiap4O25v3/D83lPoQQ/KIeayOvO2+kE52dHTqTbmpMX13W8ZFi
	lL5uloQsZ0jU3fGWNh6fnsGWRKC13+D5Z83vQi0BcY80vA24J1Jziw8SYKz7nwPxviJt8s0aWXr
	3m0HAaPVuCVZY4KBaqaCt93ngf1HhkWtnwbJRA==
X-Received: by 2002:a05:6000:2f88:b0:43d:71f4:7ed5 with SMTP id
 ffacd0b85a97d-43d71f480a8mr5794512f8f.17.1776040460749; Sun, 12 Apr 2026
 17:34:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260331183351.29844-1-kanchanapsridhar2026@gmail.com> <20260331183351.29844-2-kanchanapsridhar2026@gmail.com>
In-Reply-To: <20260331183351.29844-2-kanchanapsridhar2026@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Sun, 12 Apr 2026 17:34:08 -0700
X-Gm-Features: AQROBzCRUIIs08shfq_tEcQ8OG1TLPqoW-hySCgOyRxDeyQFdgyi7AjdW4TYaxA
Message-ID: <CAKEwX=PZC9_k0QewD1abEyTQRn9Kn7pM8VAR5bgreEN5jVmvyA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] mm: zswap: Remove redundant checks in zswap_cpu_comp_dead().
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5D7E0140005
X-Stat-Signature: swy5o37k6s3xwr145psbxf68zeyzkaxs
X-HE-Tag: 1776040462-911308
X-HE-Meta: U2FsdGVkX18SUBipb2TFIVMXK2c9lm0OxZEbmIB242VFnjZRHQJpYk40ZR/acQZVj2/T0WxNWm1ka6j62wti3xIEAu0Z3oqvLOvtR4afXZ9tjlk6DCPVWlzHoTSYnp4HbdFektQYch0aqxJ/CcLdfGrE1Cc9WV4eC8EPrPhjM8PkYWhztrYLyb7dvfNSUiM09iLnCsD36Qt98oSD1L64PiSnYJH3GGPuduMmkuOLjriav/9SQF4E2GY4KLc7+xmWtxFA8e/vipu/F3uTvXic0TxD6u8idsjBq6yR7vlG96pQJL5XUDHhofxNMUnQDo0Oe4OaWTr8WlgWNcXNe5ld1Qb+U8aIX42AhDEe2yu2CZ5xpt6LUiQDeuOqTr5VeKmAvPYVebVm6QDVjwq4avOHoCDAzYDZKr0HLAd60cmcLqdEaJWkJ1lHJt/3fyaEYYLULptKclfF9sVgUnAvE3o2gzjyfQ/Ki+r3innaoClhh61Pr7WzshSkQo7oE1RzQHZv5TZ7V555Ia0hcWw2YYnUlmcvaX7ijgdKBEl26OEacPDiY0rA2i0f93GzBeSrHYdv6opjaWgrO1ADvma4zqbwb7ODd74rpl3D1rm4CSbIOPI+lwWbX1DL2WvoE+a1qMLP1C3DBGIvtSKqu7IOJFZVosJeO8Qvx/bQ/nOQ7dcVjg0bSW0x2OX/3m2IeawnXzpEupgtC3chU+Rv6RS81jsJkNb7htzlcK+zxzGoMe8kfIR+NSuN+uRCIlHdug3XutSeKD81R6C+eeWp+nYnRtyuAH1jNJv4iC+GtvyiVYF/KlpxJPHThv2r46YD1rFsLpkxQz3XnYZKsMxKjC5qCLAj/cDl8VfcwjDTBXXGdy2IzOBBOEu2GKiwd8A6M2lr+I/KYW2DQ5EM9l1or3kgtJtDc7v8Ol6opzWIEIswX7ucXNxDegybSw5EfoC86w4/UP+e5iDA6Y4gaQ4Gw3PRigY
 eQdmh0Rc
 ovln4k9A3xK4J+BUL6RhAbc8w0xYqPEk+C27KCxK9SwPHen9t6CBHXPFjboMVwff/eBKCSRtZytPwUCQEd3NHy6PwavNrcTeTGt5xy7NZI69/1ZbrjCTFJ9FKh2jdif6EqkzmHMvjVrhPvpDDLIAzofoBiA9XeL8AV/S6fb/OsO9Jp1UqHJAftsx0avrML3jd9c4Ysk0J3rsu+wWk2ECEyhPixW//Rq6wd2Yud2ob+gQUo51ie0s9zajJPlAgUwJHILjgGWgql5I7lwoRKCCAVwwkkZwo9NVF9cysELf0DglGiyBu0PkvDTtQWnL5Pfg5RWy9kF2DFsajNVnW6T03uLlpLLA3Az4/l6Fj2TSjtW4FEh2zmkbJ2msRhelRkgNmkCVGMEiihFJFC4Zi2YDeQMGjBEtwHIGJGUSKtFxrczM3zkru0Fw2WxPc4GdaG1CMBVP9MTz+Ejaw4JpUIi/3+HE2dBbhP6raZ1C68sfp+uSlynAQGExZyKISasERPUMJYrAaFgpgnNQLSm7MXoKBnToDEzMHpWzXhgtmgEtYKJg19bwbVXGbXpbCEgfeDum4sXecOxF34+yZhbo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 11:34=E2=80=AFAM Kanchana P. Sridhar
<kanchanapsridhar2026@gmail.com> wrote:
>
> There are presently redundant checks on the per-CPU acomp_ctx and it's
> "req" member in zswap_cpu_comp_dead(): redundant because they are
> inconsistent with zswap_pool_create() handling of failure in allocating
> the acomp_ctx, and with the expected NULL return value from the
> acomp_request_alloc() API when it fails to allocate an acomp_req.
>
> Fix these by converting to them to be NULL checks.
>
> Add comments in zswap_cpu_comp_prepare() clarifying the expected return
> values of the crypto_alloc_acomp_node() and acomp_request_alloc() API.
>
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
> Acked-by: Yosry Ahmed <yosry@kernel.org>
> ---

Acked-by: Nhat Pham <nphamcs@gmail.com>

