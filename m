Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C55F7C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 14:42:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A77DC6B0088; Thu, 27 Aug 2026 10:42:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A29B86B008C; Thu, 27 Aug 2026 10:42:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9182C6B0092; Thu, 27 Aug 2026 10:42:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6432B6B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:42:40 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DBA38120481
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:42:39 +0000 (UTC)
X-FDA: 85147315638.09.CD54164
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0105640004
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:42:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=llRskueB;
	spf=pass (imf04.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787841758;
	b=sKLNWOzLggzcNK3jUmDfC6EPszvYvIf3/Foo37J4cbRDwJXzmQyX8bJWAlgu0h2spHBzqD
	7wgyIQQRMaXbxTu/dPRSqcrO8y6cjdAZqwvTMeVMd84XlXNH+cTuk7jmHzNXkIwWlCNGro
	uJ7uZhge5Oqe2tEDhmd9STPeNyrNWEg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787841758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=usxIBO2ppdlF4tWCVU/0GtmVzzVFGZI5fVprQgFp1tg=;
	b=ha9WRG3Skz6rbllJM/92MqN9YVyWxJTn5bJnwGOp7b64j/tlcEmCjcOfz383pa0ZMu9Jjn
	XIqLzP+OP9a7Yc1TvZkZdUSQcAFdxOKSpmpfpK9BKjd6nsYv0Z1MStJrcbk1kpqfDWh7UE
	kT40IM8KTQBr1sn9Lct+ZQKmWX/rIf8=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=llRskueB;
	spf=pass (imf04.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6a5f1d0af69so2807809a12.0
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:42:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787841756; cv=none;
        d=google.com; s=arc-20260327;
        b=JUveHER6+ybYS1K6EaEcDpWJPpghVCcokaEvePpDxMwS6S0KXJtapDpBZv4T6HeTU0
         VJyujNTw1Nir6jKSWnU98lJHwDEYJM9VbaoBmk/wFqeGcEeL3RBtMfr6uATF9CEYM5h3
         Sn0v+itxvVBQMNZ421/3maCTW+QiqYJMTiJBaLtKyBGjBVGygDm4twrgVgwfp8xdYICq
         k1Bh24EpHb/p8ZODP7IQdGLGgzlIKbch+A/xZDBY7VBPYIecSvka6JIsukc1YXx3yH9R
         Jf6tWIMSugTQ/mHtbL0z5AdMmnBe2Ek0b5ZL9EK+W5hw7/cYQAzJq6QVIalSXi7sf79M
         lc8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=usxIBO2ppdlF4tWCVU/0GtmVzzVFGZI5fVprQgFp1tg=;
        fh=mK5AbYodsO7X+ZLuvKNtnsY3xxS2aDyvewjtdfxb8hk=;
        b=PhpULiN+JuHsX7VObRAV6jS9Vhb6bjo1VnDqcv+edcqryTOHGZfqw1g3kMCzMMMrTg
         LL4jvPSuWUDFFUPeOQlboKYBjx1PnhxTFJABLe3kNkF++kRNz7JznYnf9gK8HQYLAtoB
         W2WC0ygNxGRSsFG6txf1Zc4NhgRqoPPPI+oW6CgPp18/fAaJ8j1pdX5AzGDPfFaAn+k+
         e6Gl2H7OkZXyANkAYmhJk06LrrdCCvFq7XmlrUS4rhcTaU50SijyzixrMsu+9rBL3R6a
         KNaOS+9iJJ/x/JoUmlt6Rr8efawyBCj/RGatPn+sg4uZDnBuJAiNmnFaBpUzagvAbGY8
         Xlmg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787841756; x=1788446556; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=usxIBO2ppdlF4tWCVU/0GtmVzzVFGZI5fVprQgFp1tg=;
        b=llRskueBk0GnN+zR6/CUQ4LjIQgGyTvt3AizPXPMk0Lgf9fhBMfsJd0s76fo3O2llE
         zKBp98pxpp+QC7YnPB+99gMWwZ03Fwy3cUMXyO50tk6cQII/ZSx8+5TNurLLMMMHpq6Z
         O6nbyuvBCwuMHaDgBpwsiFH9zn8NLmydpPnf4teMXllcyBQ2kZw0aireMSwLLbzACztz
         dzYjs7g1/YuAvQPT2jeWP7n6CZbRjfhg9Wk6svdO00GJqI4UwWKq3zwvUDRZEzqvW1q+
         eGC8r20Y7JKK8yKwod8mQfTUbzaTHvPbWZwllj9/ar5KlgxyhbHDGvXLoErSpvVTOdD+
         ON0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787841756; x=1788446556;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=usxIBO2ppdlF4tWCVU/0GtmVzzVFGZI5fVprQgFp1tg=;
        b=D6QrDyjv5UF5yDq/bDVAfp2Qt1z/YT9iM1cbvcybI6Cmp+kLb8VO93A4O9vbKY4Rxq
         t9M/qFDjTirLYV1pLpIxq6eUU0s5cXEIGMtCpVcUOLYz2/eZvThG7w/26EQxRAXFRKbs
         lVcp5BnhX+v0MUtQzaR2MSvqweqzxRbWwEZi0GwCwY6fSw0xjsZPcC/AwPI6VlYAVpPo
         z5Qv5V7WBR/HIINmupTZy9dq5OLCpmZJuZTfZcOTcCQR/STPyXFU3mczlHJ6LoEOg7+p
         9ViM28wI7wHwxdd0rLLwD/CMcaGnj5QTn8sit1AwprbMyF6k33T96mKxjUfYMK4SXrHd
         oakw==
X-Forwarded-Encrypted: i=1; AHgh+RrvdIcs6nsZhsrCYrZdM0ovdQMZmYYdxW518ULKLq9ab/LR8/wUKB+oHq2G7cYLHCqxDLR7Xqus+Q==@kvack.org
X-Gm-Message-State: AFuF++mp8dyeVG+5HrzcMIfm86c7WL8e0R4V0bkzvm6Fi5sxdaLx60Ko
	vzqqOr1rshirX2Hoj5D/BX2bCxbG0idKv8elDWfdSMPGdZV35IOvV0eC3UPmPbX8VbW4EISOk+D
	Rho5YumHEVuWB0pDWYmbn6zWPEOmFrJA=
X-Gm-Gg: AR+sD120qVNN4P9kpyQFGPkpRRyhmmRHbF0ZB1cR0vHrMXjFWBftj2ALVaqwJeH1ij6
	Ecj2fBg8/RXVgn9v4eDggXUda5p5UBu9wXcwt38014oQxHJwUZh01mKEag0iwQXeq7OO8CpNq8T
	IF9dz+E4VAb1IXbGnjKzrwSvbh/hwjDGd7SQRk7hdDHfwD+AH21yhqcrNc01eLgO94zu0Ois/VM
	qGahpdkKAOydz3lm6+vD/UGBrMdTZwH4RvmK1AMYLmjYBYu9RK5sgXps28Gc9kmGqjMnYAjoTzl
	aGOriijK5ZQE4Zq7b56wTjEDeQthX5IaxLL0c3hc3kc8QRxsiO+Y
X-Received: by 2002:a05:6402:24d2:b0:6a5:f4e6:ec14 with SMTP id
 4fb4d7f45d1cf-6a5f4e6edf0mr5279400a12.4.1787841756195; Thu, 27 Aug 2026
 07:42:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260823154840.3793140-1-ekffu200098@gmail.com> <20260824115822.6e41bd0cacd471a8074623f8@linux-foundation.org>
In-Reply-To: <20260824115822.6e41bd0cacd471a8074623f8@linux-foundation.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Thu, 27 Aug 2026 23:42:22 +0900
X-Gm-Features: AcwNN1UJMsgOXEXywP5CyjNZEXUmLR90mxnQHb2bYnSkYAmQYL1JBmR4CsqaN7I
Message-ID: <CABFDxMFJeNUBacbms6MhcM5ihG3GABVwfGcFmvDrg4vTF7+yjg@mail.gmail.com>
Subject: Re: [PATCH v2] memblock: remove conditional return with no effect
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0105640004
X-Stat-Signature: xbur4wyu4mxptq3dnpz76iaucsn6eh1o
X-HE-Tag: 1787841757-227185
X-HE-Meta: U2FsdGVkX1/1YjLo0irk33AIFW2ovECjMHSfTuLryLZWd9GxUhfcoM1IsN/iKyZ1FtAanHe2hAtOeYvPEtxKxo3LPEazFCTvJbG+UPHeOZdkADJdQcmCEtSJq2v+NpQTZzmiLVJMKVL2DgiEdCfjIjtQ0UJCp79GjLRmfd/oxzhiWVggcenfWxXsMM+yp1cM7HP9fGoXZuUS4h9IcScR96eiTKNyEo1M4bjAbZrvcRdjtZa2X867YLK+uF9jl4sVF6z55hHEKGgA5tIosnRI5A2xmuqRJ+zn1Ov35bok3w+gX4MCpJjZUrrgRVWeKB/nYplr1cS/wgUkWZS8FRpz/L+xkvx2OIZ+qq2Ja3ZB9ega0Hy3piABpIxWsm86gdgonzRYdD8/4bxIZgW0y7QT5BuiXclU0pFLSbnbNVb3NS569mk2D0BHO0hqvzRe1OaDc50pNxK/OQqT/yKitoAV3RwlfXtRkSdtfyJI2m/4ypPZ7SZ93+gqTKHv5Jcq/YCRrmVSQ4tw1XK0td6pzPTxgTYMmW9rmo4jdXsriezd7NqMxNX7ifnUGJWCTTkqPS9Gzn/IEjhcj12LlfYLzImY68by4v74PASVb8WOTyPQWaQ4Z3zLw49vo3eMoblnBwwcTQtHBYPhzQtw73hgGCecY4cwjWdrMquH7WnJh/mpnsoKxN5ascQkX6wVC3jZd4LgzMwIqj4dC6zPM2v2VsnnZQ7pk+VdbivBgrqU4ZqjHnPoGM+6JTziizYzQoS70e/8NdMkCQZjXrKe5m1aB1EPxl9k6HRwiAuN2qpDk2qJTis42uS7ojlNQxO/1UYSYZNOXVVtVKToxoFiDmHlGixqFdMAWWy93Tw7lJS0yr5HA7pmxqVTMxGL7x2BSZV+Trd65tcfMUiDzJ4EO3z5BeoxCeHHgAH0hei50aoWCakvJFchzDDy9LdjgqzF/9eevTAmc7aCztPrg8gq/79+lT8
 SAaaGOE2
 H687XIZgk62nW4sQDznEjFmIRzncORoZRc6ocu38LP322qhpczC42Knt4Nf88NswNtjekBlN8lG5M0wSS6Zbjg7oc7HzJpHr5AlYYAulmSWej3vDDLnqCBhU+QgJoqffyHBb6dLnqWnopMvBZ0Tdof8H8aqv66GVc41jKNtRwI74cDosFjByGSEg7AJj1x4ZFM4C8ZiklLJbKxlW12fcxNccGaRZDH0oPaShYR1m4P6a7Bv6ZJ9a8he7GNrTDdwKI6j2hxjkdPP5up8tvfhROcsnpsFPkWmVCFWa+P4oVFAVOHPvkaOH05/WGLHoJtFasK7OkqeqpzgjnaY6pBTjKCeimUdlXOopKMw0qUV5Do4R8Oop2lKy9+qyICxweZAaFCHsstOfhlCb3BSvQ/hxHZG5X0lfrhAANv9iMpR0ZpFJ0UyD1tnioTSm00yxaHVBPoLLEK8PK2HlZVUp/vAPEGDFvP0hPc2h01AIa8dSZu+gdeY4OIPndBTJ9CLHiCRsqxJBSrIhyNXnj1O4IpWCP04zHVKGx/aaqByvB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 3:58=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Mon, 24 Aug 2026 00:48:38 +0900 Sang-Heon Jeon <ekffu200098@gmail.com>=
 wrote:
>
> > Both branches of the check return the same value, so the check has
> > no effect. Remove it and return the value directly.
> >
> > This is the result of running the Coccinelle script from
> > scripts/coccinelle/misc/cond_return_no_effect.cocci.
> >
> > ...
> >
> > --- a/mm/memblock.c
> > +++ b/mm/memblock.c
> > @@ -2613,15 +2613,10 @@ static int __init prepare_kho_fdt(void)
> >
> >  static int __init reserve_mem_init(void)
> >  {
> > -     int err;
> > -
> >       if (!kho_is_enabled() || !reserved_mem_count)
> >               return 0;
> >
> > -     err =3D prepare_kho_fdt();
> > -     if (err)
> > -             return err;
> > -     return err;
> > +     return prepare_kho_fdt();
> >  }
> >  late_initcall(reserve_mem_init);
>
> Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
>
> Your patch led Sashiko to suggest the addition of a round_up() in
> nearby code:
>
>         https://sashiko.dev/#/patchset/20260823154840.3793140-1-ekffu2000=
98@gmail.com

Thanks for the notice, Andrew, and thanks for the review, Mike.

It seems like a valid concern. I'll send a fix patch and check reviews
carefully.

Best regards,
Sang-Heon Jeon

