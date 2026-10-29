Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13294606A324
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 18:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VcsSvmzh
Received: by kanga.kvack.org (Postfix)
	id 2BF636B0634; Thu, 29 Oct 2026 14:12:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 298E46B0635; Thu, 29 Oct 2026 14:12:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AE536B0636; Thu, 29 Oct 2026 14:12:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E615B6B0634
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:12:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4BA1412048C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:12:04 +0000 (UTC)
X-FDA: 85376457768.13.66EC0C6
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf17.hostedemail.com (Postfix) with ESMTP id 57D0140006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:12:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=VcsSvmzh;
	spf=pass (imf17.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793297522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PLUjYNTvLoS6IRSrAP5hbUmJYyA56qlS0xnG+YeH+uo=;
	b=lvT7ITLyL0TzmbL5d/OKjGmPVBc6ppLf7pLDpAW+hE5QUdBzGUVO2s8yfSDhxXnJJz6Jq2
	WA7UVS2KykTASBA21JYUMcztNCBjZdX26+V/4hvbQbxL4HzsnVOWHKZBPi9KnAphhwjNkt
	8rXz0fhAza4iBy0RsyeGCIDcq7OcIRo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793297522;
	b=XbbfoaSlTJELm2gSwXYPFeY1k/6dK7qyA+27OmJyVx1UzRMRifS5T0c7es9dLaA8yrohns
	3I3SgzOat6bl6GItnRkwJaF+Js1uK+AuSdtc5mQbdx6qrmrQNuBVzKUlZ45QfR677IeR5o
	1BLyJdwaWK19a+6FQ9ACNWgmwDqHIyQ=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=VcsSvmzh;
	spf=pass (imf17.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5bcb1f1358aso1879501e87.1
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:12:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793297520; cv=none;
        d=google.com; s=arc-20260327;
        b=pevLWwPB4WDPIS4tNmogWRLktZ0yjHJcyj0MC9xFOu6/oGsJEFJklRnMPkCyjuPStt
         E+SQ73ibH+h99RXvk3LiRwkQk5DNZKdxYqAvpX63lBmLR/E+djiLCYXS7bBDLTCK0QTn
         6FqqhxkOl8jNr4qa17kf+L3sfNKFcbAXVpcuv9iIM9FeuhK4LQ2IyHVapSCz3oFtKccd
         ideMMZL4DKabxbklp3o1GEN2lkpucmSnxBOQpYdiSEa8THcsJnhFCyDRTdOYpMmHy0kr
         hKaziVL/8cBFB21dbxcFKNvyv/wL9En4qSnWfVjKg/1cutk4GNWGPwvyiUuSd90TrzlK
         ZOLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PLUjYNTvLoS6IRSrAP5hbUmJYyA56qlS0xnG+YeH+uo=;
        fh=gxb2xVut/q3KoUwntAmMDlil+Zvsl3kQhkpa8SGKkXA=;
        b=DdW+hSRTN5iGwpsaWCDnor6Sa8R8TEQX/1MzruqZF2hwU4gIq05pmwucLxpRWoEgAw
         HTlEJdV1HBQCTUyYAquDeyaKqs/r1rYRkU8vuo5juz+OuWc9uhPvcEWHODDnuw9kGPfN
         3uQxk5KM4nfXOyz0apeRV94Afw71cEEL0JTQbnTyYDeqAy3//zSpzyCrAEdrn98r7rmx
         bKgBg7GVoOsrfUZNcMtQ3jr3QHQytrsqOHAG9cQVST3iXLMVhu2YhKZiXRoUkWUBIvEg
         w9+51e0SQM3zrF1s0tac/rvqi24ZokNua/3sIrxo+erwAtLkwzdi9APJY81bgntRGMGH
         sf7w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793297520; x=1793902320; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PLUjYNTvLoS6IRSrAP5hbUmJYyA56qlS0xnG+YeH+uo=;
        b=VcsSvmzhZTP21j7b+b15c3w3CSML4GntYyWqHVK0+ZxKCwsfh/rZnki6BpH4ArUgyd
         Pm+cdoUmd+sJi1OrzDzbIKo7DgUvD0UhQGDyjXhLy/J/BMXE1sO+oca09IpOj1eS0B6b
         FJImji13CYrUf8hPbq+mw3ozHkmLvX8raobMGSpD9xjTuxzF2f2i4WBpDavWXP02mZTK
         /3xWlV23P7AreJv0TVndrTYYuD2cTHiXU65BuawEnhHOgO94BT13x7NHZAh66WwhDFky
         cqUyHkJfsyq0R8YkKUYLz85bhssYYj4tZnbTNJYPIjgNCtIG68OcYQeSnPmyK+u18cf7
         TpAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793297520; x=1793902320;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PLUjYNTvLoS6IRSrAP5hbUmJYyA56qlS0xnG+YeH+uo=;
        b=crd/ZyLJfngPst0jwK/lbdh5AIw5ARpNo434vggIxttVDaLPYLTmDwCIP3slHSISeA
         OZ5t78UxEqHk0+7Va5RufZ2EKm3O1Jk8jzD/awQbGtY0k8tmWknw6LoL6ClBBhb92eiI
         MouJ13yNXvLNcaCm3CbnDBDBPGVOj79zR4bGbKsi1zMxpcD3Gf7W9quL9uEtca9/8Avw
         x4C0TQm4H51xPO5FLFZtULbjPJRnLIVcLhkWxxNt0UbiIWJ1dbMrQPrUzLKqXTIg5xpv
         CYQJuuURZ+95I8GEKiiv2u+leHw3qCDA8pDnpUdd+MPdXYCvHkqHUsGdFx4/MsZ8TpyS
         02Mg==
X-Forwarded-Encrypted: i=1; AKwUvBza608sHvHJXjDBtCkyRi0pFAk2k/wemykdhRTHZSZslfl9fqNW/Lpbde7RGQKIhL6yoWgR7SUMEg==@kvack.org
X-Gm-Message-State: AFq9FYL1TXXMBnZ5WDm4krROjLacPw+L3JyL4jVtuq+1sjiEmMv/09Ho
	fUXuZN0DSE2IlN6SbxtDM0igavcJHRJ1ymbNTyZ3ay0fplPZShQDvCiXzKK4sNOVlKbNiS6MWC6
	sc9B5zfAvCm6/ZsUCMi0tmXBs5pQc4+U=
X-Gm-Gg: AYBFou1aUzzklpQyJU7iRUpxtiyyffn9RIEQwWiRp0Isnip/BBslQrgcJNTzdChFhtH
	u9ahHr1izHA/5X4LHHJD7eyNCsJz4lgPli0wY6CsgxbURu3tYg8kZyL7yhZi5N71eHv6u9sDbx5
	qBkpnaY3UDNumsLCVOpsS+mVslMFMmLK/zVX0T7EhgYAYZvYOcqtowCL8/SgSn1DJOiM7Hy6QIu
	sWhHOKX54DWUrA77KYWzr7Ut/RwmGh1i3aaaTd3ufIOzKeVb0GvOh28UNBJjcqO6KFObqH7HRlX
	zKTzG2qLjRraBEL1di5h14ds/S03PgmvdXCGkKbud2n5KQb3dkTxEF61g9Yf2PQjR4YmG1kkZRJ
	nRjPPy2MqNnHo35jIkOSwjjJEjuaI4GvCaifl
X-Received: by 2002:a05:6512:23a5:b0:5be:414b:9032 with SMTP id
 2adb3069b0e04-5bfcad46342mr2523158e87.31.1793297520237; Thu, 29 Oct 2026
 11:12:00 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-4-kanchanapsridhar2026@gmail.com> <sashiko-outbox-188655@kernel.org>
 <CACpmpodu3C=uYH6dmFM-xkvdJxiRDjamRKs1Q4jU6_KKjFWNqA@mail.gmail.com>
 <auLbyon-KaV5Sw5_@gondor.apana.org.au> <CACpmpofcd=ZPKhAoHJfvJU_JZshKs1GGJZf5JhjAW1PZzDq-Lw@mail.gmail.com>
 <auMCV1AFlEFuJnk7@gondor.apana.org.au>
In-Reply-To: <auMCV1AFlEFuJnk7@gondor.apana.org.au>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 29 Oct 2026 11:11:47 -0700
X-Gm-Features: AclHuK8R6xznrwfhDJPyC02DpxmXLxT-47zHrOdZ1Ogvg0ySBRqlzEwjpCqqoJ0
Message-ID: <CACpmpofnUbi7gf=eBdCH1k6ZpeiNQUdt_tRRZhvipmhwkhwRqg@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] crypto: acomp - Add trivial segmentation wrapper.
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: sashiko-reviews@lists.linux.dev, hannes@cmpxchg.org, yosry@kernel.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, 
	linux-mm@kvack.org, davem@davemloft.net, linux-crypto@vger.kernel.org, 
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 57D0140006
X-Stat-Signature: 6eregy6exeptu4gyxk6eaejtn6cnh96y
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793297522-326569
X-HE-Meta: U2FsdGVkX19C5B/zukKSaP5k2SvoBRom5RYB/yLnL/shDNnCedrM1nmk8IxZ++u0v0fvOTr4/M6uiqTKowv23FqpHeSnWPcDZ/RV6BTgviK3j/2qa2Wx9FETBvM2ZWYLwZPpdlJU99fYBg/ia8cjG30EsJRtz42AJtHAF6cPBdhu80Ha+FAspDu+9gws0a4WFh2IUpScK8y+gEFcjI4hP5CzjQoQHZYcurq4fhcp0k8MMuQcYH7o8uScqF6p6qFTTlQv/vmH4+ZQkz9zcv7qJdEpkT2ck5YJkRxEQX2QMVPT402dKgtzMAxZye8W1IYPBo62pmq7aEUjUV/Jf9YIkfhnYSfV4ua7DdKEl5ZZI0lb5o5zJPM4e8WC0F+s4sAS63JJ7UKlpn92oTrJtltNM2X6+f5QmkUnf7uHk8VH+tq5STgJrLKnqMBJcZG6tG4KfpkMKbNtzeiLkHtN6QHwWLF+KliIovrySjhMI7IlMNYcWSgNdLL5dtnvrxOn8LyTRZjJCMcbunpgN7S1OxSLXFKXpCuMz6czuVqbIEFJk+3Wl+JEHsS8rp6xzS3hgdlOEutjSUGWxKuMEAJIS9pdCBJENGd3Pe1/+6OgFULiPGsUzgzchDohwb/WbwD94RM0aoGa/2fh9q6axuJjn/0av5iaP8aOk2i3p+MTNmCqjh359K5SjUceqh4QoB9VwzyfvXooKzQOWPquD0AU88a5Y+XRMW7ph7oioChXueptNg9VAfDPNT0k/Zaw2TmzbfzkedPEZ8NeZfCt9/z9K+5APynHfmNCI01Z5WAbufkY0ZRnVR2TMP79myosmTWGJBYBxPgOfE+mGzTlT4Havze3jdGXS/MX2c8bth3BiBaF6kiQPRDIrjDJvMKA+3roLxks2g+KP5U2tvz2EW9K2t6D1IHMhJbUPkkhMzgDBLctVXPd6pxZ8rT25uFZYTCDdLxDi6TnYkH/BkGxayD4A97
 I7fwRzZp
 j+mbKzLryL9hbtAwYG+3aTnOxCPwH0+FD59c2pX/qA2dU1u+aYVMJ+MO+5nj90fEunjKzrX+njJXI/x/JUxWq1bVo1fDKaEuEXQIezQAwa8pUtfN1P/VDKTHXOJl1FsBbg9dHlWfblnrGLeRSJeZBlD2OetknIZbbtxieexSG3mlZlUVIrLTq//r5sjAIfx427IgGyVca2TRFDf6stTVXibN+6oeqtGU4IoRGLcIG7VdLrhb1fjpT5jPC1sNcGJjwFppXoLbmXhl5paJS1js/LZCIFHhJONbOJSeyMuSj15kH8kAq1X0aj615ikMjKe1xEdpIcqSv86siPfFujpEXc+tgapBt49RwCGNC4al2vrRucTjhPmvNQ6w6w8+3bDkSOgN17hmRP6Ds2s5btTMlmuQilXOBH74HvkXvNe/oyNrHyRQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 1:23=E2=80=AFAM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Wed, Oct 28, 2026 at 11:03:55PM -0700, Kanchana P. Sridhar wrote:
> >
> > I was under the impression that if acomp_req_on_stack and synchronous
> > tfm, it would go through acomp_do_req_chain(). Please correct me if I
> > am wrong, and I can modify the conditional accordingly.
>
> It's perfectly fine for a stack request to go to a sync tfm.  What
> isn't legal is for a stack request to go through an async tfm.

Ok, thanks for the explanation. I will change this as you suggested.

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

