Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FBDDCC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 22:54:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 419446B009B; Thu, 15 Oct 2026 18:54:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37C876B009D; Thu, 15 Oct 2026 18:54:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26CF06B009E; Thu, 15 Oct 2026 18:54:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EECA36B009B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:54:03 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 880121A0217
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:54:03 +0000 (UTC)
X-FDA: 85326365166.28.2C6D0E1
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7F38A16000C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:54:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rz1cslXn;
	spf=pass (imf08.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792104841;
	b=VoaqZBZvG3H+qVl77RKOCuO0xN3stzwrXS+0pY+5DLJQv+JnfdUJe0jCHWnGoaVJpCanOq
	13TNIzqa1qWYsZJSuMRX/ARlQ4qLsEAksdRuwwpYSlZ0AeccXk0hR0xyqLvlKNbLMj1anl
	WsDlWi9E+xbgFxayoXVbIqu9f+W2EL0=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rz1cslXn;
	spf=pass (imf08.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792104841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XzxLC094t785DsRLF3VJxAg0mtapcZEnZpiZaHEc51I=;
	b=2dCNqk1dlUbcuc4BUfTSVr5MRvbpW0gy0gKR1cNtjMiDP9fXZmuf/LP+Zw1UeWiSIc5mkX
	Uy6wicINhiJf7a1QIuY2x1IkHgifXYFkCyuQKiMw3/guPWoH5ZUzqPaT97ZEeRs4HTXPFg
	TdvZ/IDVoZJpw1ukHnCZFQXrTx33Aiw=
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5bccecba199so1800941e87.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:54:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792104840; cv=none;
        d=google.com; s=arc-20260327;
        b=Q7p5dLiRHYgseOyU/PHOoLUnUlMFgOTGtOGkJ0B8LPOsyT7eA1LCo6sS05gNQm9sEi
         SylpXaQIOUskkL0irLXREypO6I4g2kWnK2TYGRKW31omnjMX9/6F6PjYJ16+qFIYpWXf
         ACn3HLS+v00FR24mpgG8vK5STCCDtzAULxfteLFw0KJtAosZa81QTpluh3xO5RvY/pi2
         A63RB70lZhIzE6TqRl9Kszqd3uqQUnEJhzQnR4OsJUXqcIhChzsHVHdfDF38gKqpixtV
         iu7C4Qjen8zVhDfW3ky2avW9yifdweehlyjz+KD7sQhnNpi+jwk49bQG89oWSzhvVq8f
         SWXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XzxLC094t785DsRLF3VJxAg0mtapcZEnZpiZaHEc51I=;
        fh=jR/jxI62YKn1Mi2g3rHqtac31yZL4yzoreLl2dQcKog=;
        b=PPkFy7pqFRaPMUFy/1T1SsMVT+27GBKiRcDiFS8LagPghIWvnaOMh7LLD5R3ezz0dz
         gMc3zjTKFm6SrGpT8ay6SAsewgZ5upa3Ia0c9RdXzDDmCwF84PWvgnZUly1XVyjRH5yS
         CntTZWzR6LsqjTGcenTJ1vTjRubLq+nrN8nhp1QbOgbJDAUPJS66Wl9mDrrKVkyzBg37
         iLlJX9HrMUXNb+fWpmTOWMd5DldUlf4DpaSEyE8yRsw1aJfVW06MiERAiNq2yn4YGtds
         MCjBKIjjRu59qltfMXAt5NN6+LiJZtkcHrj+anKioVARdPFNiWjdTgKNXhHUHUrnnBtZ
         Ezww==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792104840; x=1792709640; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XzxLC094t785DsRLF3VJxAg0mtapcZEnZpiZaHEc51I=;
        b=rz1cslXngAtcLOE/yrKi96UDgMtzbmlSg1zKhVTxZLtue8LmcdSK1mH7BUBDgBrR54
         9novzNhfGa0shguh91kO+otCEsgRc73JvHfPpzOJSn0BaV5fic/RvgT2VbrX7R8RFvvI
         8Q0W3p2ayW2GwyPAMtBbREEONvjCAeYl+x4xgVsqfWTAq1GQLBFZzBT1qwqIjVXBf2MG
         jcdtzsibAxyD07zSMtWBzNbDvkEkY+OdF/qvlwDo3P/v1QvSAsrTJo1jvRtx+rojgHOR
         ODixeFkToDyRqFxkUnm7/nmFceUHakMZNZfkaTOsiEw1F+GwKdvvHwJEshJXuUcF1HS+
         eotQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792104840; x=1792709640;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XzxLC094t785DsRLF3VJxAg0mtapcZEnZpiZaHEc51I=;
        b=dwqW2CCFvcakYIn9v+juiIumD7EngcgJGLSRlNWN0d2BSOJUgtroLFDijurha2lD3E
         N3ctzjkgUgGCi9B0FJtVImCSrZfKLpB08/4GaT2jS1/FtUFlMjZPqvbQEbh7EHKfP46P
         QiV5WA5Eb+E7htb9E9MpxcnNg2F3AWPy3zTqVF/xxeVfHts5PrjTxAhjW0FqbLwOJyYU
         xGVXWl2MnfY7gvXKhyHJDVZMcIwEOsSIcGU20HQ3/hvYb5T5GY4aZxQxt4DLik0YMkWs
         GI8KbVYoO67qMWkGRxZ7Bs+h8NLJtoiIy1a/gM2/yUSyzsixNJFW9+8MSEhyqkwdW8Pq
         U0cw==
X-Forwarded-Encrypted: i=1; AKwUvByEq2kI0+Qo6ix4i0U/T2vFcnsg5mhw963XnPqNH17unsmtiwMA7t/fk9GKRRj3WEAxv7RuOzu/ZQ==@kvack.org
X-Gm-Message-State: AFq9FYKY3cr5qCDz8JY40ccPN6hw3y2QOwEGphefisJDg27lvJJH21SC
	9NwrmUeZ6a2r/4PrvwCNgNWilUXzAjSeYGsXvLRM9ZGAQIfTDwlJhZzFIvQ+03haXDSxzidAe81
	zNneaXudAwVyCVei1Y8ccwY44uOSPJss=
X-Gm-Gg: AYBFou2oIxrp7rWDqRLhR/hpF5D5dUiTtKpKbbfLV0zVHg5HKlQmze5TgpV41723T1s
	ZoxRNRJzVbeTXytsW0CpkCS9jh4b4vYXircAc0hBU/cJrFT9MKTJ5meZBW+xgFksuzBPLiaer15
	DZpv6UULI+zkPmTfi5k9Hdmg9x3K7UaUoQMrXmOjN/I7mh0JaHGdos1SbbB6jxg2EvKYLszgLfZ
	cl4i6lSieKyckwHWQOm33aShmTumfhjYUkBVMRyUm1E9oQb7DYhuOjOEVMno8E5ZIuJc6SRlCA7
	AU6pzduEiD7TPd2b+ffIlqU3jpZNICZr8vTXxKX7FzO/EkZe1xzvOkA=
X-Received: by 2002:a05:6512:4022:b0:5b8:f15d:7a59 with SMTP id
 2adb3069b0e04-5bcde362a09mr6934603e87.7.1792104839491; Thu, 15 Oct 2026
 15:53:59 -0700 (PDT)
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <20261008182814.27450-8-kanchanapsridhar2026@gmail.com> <as-izeIj5bP01bna@google.com>
 <CACpmpof++tM9MUYgqgenwEBfaaJ60VsDwptK7Ne_-b+-DKMRZg@mail.gmail.com> <CAO9r8zPpmLyMHF+yDb2ZHRmSdAHFTNvsu8PZsQ2Z-EVvF-dc3g@mail.gmail.com>
In-Reply-To: <CAO9r8zPpmLyMHF+yDb2ZHRmSdAHFTNvsu8PZsQ2Z-EVvF-dc3g@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 15 Oct 2026 15:53:47 -0700
X-Gm-Features: AclHuK8XCRmndmlU8lQlUVHlY-_F-OMKekh2ybGWDMTVBykCkJfOyvNAoky4LzQ
Message-ID: <CACpmpodjZ60-r_VWu9ui+5o2WDSJ3gWEY79dRNp5Bei4dPwsrg@mail.gmail.com>
Subject: Re: [PATCH v1 7/8] mm: zswap: Optimally place members of struct
 zswap_pool, struct zswap_entry.
To: Yosry Ahmed <yosry@kernel.org>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: bga3qbma6dfepnwrz6ecbm4d5a8goufn
X-Rspamd-Queue-Id: 7F38A16000C
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792104841-464859
X-HE-Meta: U2FsdGVkX19bX+4XwDHvcQPhTY3eFWvzuT9BvmMErvTuOgs4Q2Y6fAp3DbsyNkE4nLFdxPFD61wbhL8XZ6qGAkP0bbwIKkdysF4UknBsT0eOgxMjj9ShtBd/APOa3X40+GI5Acl7OK8yMHWHX/hWHDJAsiVRC+l2ZJ1wC5Z154jUDph/CROCHt9/7TRhjWTyMBEo2XiT0QCby/1zXJoVdfFVnazEr5aaTrMHxzbFLtc5DQlInk7hw3jyp35V4TnW25ZFQYSfAHfClDB+FUyBEsYU4JIolkezvGtlHryangSbU1fCoc6WAO5I1nWHYemRYWSN5P1RZye/BIKTZrKFwL3vq3Gus6vlffdN03uZy9T3IqhXTtGTGlUi6vLV10W9fcf1L7JJOqrzREQSHFIHkTPC+Jv/c+e9vkiRQC8iqYkX2JAgZLBv0egN+T/1HdT7xH39v81yLG4roweZdbteVmdVayIH3TN7L+bdR2RGICdE5fdGW1QJVR8cNovq5ryjjVkhuT3evE3NsdbdEI0ICMX7rsTkF0o8ZbsUNMnxEXW+P2UmG1MqdVbv6koUSMeBigHs4qNMNe96ocFAh3cmUSY4mB7aQHRB2CpaJZUbV+S4QBbEor+OZz1aB7mGIDA8LqDD8WC689SD6W3pXtF3d4umc+Ve2biNqrN+W8fp3yne65Kh6X4UZyj52O2rXlipAFAtKEcMaUcNUpgP2VKWGj1DqwVtwWvAK4LBU1RfPdnSZ1DNe83+78T1f1wT3xcMyWgdNkU83fiLvsaeAtJ2yHr1pyYlJ1Qy8RWPpIvh8ScjU3kgS5IznCKeC6YgBziP5wARN/iO+hTRJX9h699+zlwUPWeis+LjdOkwFRWEuJreL84wz6Tn3sRQbvKC/7pRNn+7cpBcJw9uUOkhQcFuQkZvqIfO9yatUkMSsLCRvvCoF0ND8FoM2aUgQKKmr6Zg2ORrMu6cP9RuY5yBafB
 lTfdZLuK
 ZviQK8VFyIMIqlWXbF76bra2R6DvBxCtxZ73FmcrHoG/OidieBfz95vAzLyuJJU+DVurmjhCuq9PLaoRJTXxU0SPHit57IQ4GBHMVTCPh/dZe8MlYFEraUtyLhjJhMDKu5rPodE4FkZODJ0p+XnGMCklJ7xh2zFx2NoQHhDKsH5wKLmxI1rR3ik0UFa1Pr9ToHwo1GCl1640RrI0ZP+8Wtdtbn3vTl+5B1CDhcgUzwjGVZihIUhtVAOydq22ieyTzJwfwl1fYhuzoOjutovl0Qkc2fWIlpPI6807WXlMvUm/PzEOc5PlES+6BlGeTz/NjCp3/ZIaSpk5YqJBJ86V3wGgIGf8+caT+pgjLbySCQa8C1Y607swVAtOqKOq/J44ESbTQxH3FT2g9vUtf2MITN9q+rNaNcH8tAnKU2cEg5/TUHoWo+02TAKqq+HsFLIuT67cVArsQAVCK19Ng16vhFsTuz5irmyJVxYl/k9CK+IiZLWF/w0tMswcwgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 3:06=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Thu, Oct 15, 2026 at 2:49=E2=80=AFPM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> > On Wed, Oct 14, 2026 at 8:43=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> =
wrote:
> > >
> > > On Thu, Oct 08, 2026 at 11:28:13AM -0700, Kanchana P. Sridhar wrote:
> > > > Place and align the members of struct zswap_pool and struct zswap_e=
ntry
> > > > such that members used together in compress/decompress hot paths ar=
e
> > > > able to share the same cacheline. Minimize holes within these struc=
ts
> > > > while doing so.
> > > >
> > > > Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
> > > > ---
> > > >  mm/zswap.c | 10 +++++-----
> > > >  1 file changed, 5 insertions(+), 5 deletions(-)
> > > >
> > > > diff --git a/mm/zswap.c b/mm/zswap.c
> > > > index 8ae67fd10522..ade84ac4076e 100644
> > > > --- a/mm/zswap.c
> > > > +++ b/mm/zswap.c
> > > > @@ -160,11 +160,11 @@ struct crypto_acomp_ctx {
> > > >  struct zswap_pool {
> > > >       struct zs_pool *zs_pool;
> > > >       struct crypto_acomp_ctx __percpu *acomp_ctx;
> > > > -     u8 compr_batch_size;
> > > >       struct percpu_ref ref;
> > > > -     struct rcu_work release_rwork;
> > > > -     struct hlist_node node;
> > > >       u8 idx;
> > > > +     u8 compr_batch_size;
> > > > +     struct hlist_node node;
> > > > +     struct rcu_work release_rwork;
> > >
> > > compr_batch_size is added by this series, why not just add it before =
idx
> > > to begin with?
> >
> > In patch 0006, where compr_batch_size is introduced, I was attempting
> > to place it in the same cacheline as the acomp_ctx. This increased the
> > size of struct zswap_pool to 248 bytes. I later optimized this in
> > patch 0007, bringing back the size to 240 with the addition of
> > compr_batch_size.
>
> This doesn't make much sense, and the size of zswap_pool is not that
> important (usually only one globally). I would drop the patch and add
> compr_batch_size directly where it needs to end up.

Sounds good. Thanks!

