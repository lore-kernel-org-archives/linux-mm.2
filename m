Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57D89F53D81
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 18:21:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE8956B033F; Mon, 16 Mar 2026 14:21:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B92F76B0340; Mon, 16 Mar 2026 14:21:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A94CF6B0341; Mon, 16 Mar 2026 14:21:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B3E46B033F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:21:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4DD6A8B529
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:21:17 +0000 (UTC)
X-FDA: 84552743394.19.14B80B7
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5323040011
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:21:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IDMwyoaN;
	spf=pass (imf07.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773685275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UluXJgD778OosE4tXHA9Inh6lCP94NT6qiIkacIllX8=;
	b=VeK2z7ZrQHwqCumGQ3zBawMtFTsgBGzwl8vvkRW1G0DHxMPv+XqCGf4+m66umFTfw6N5YN
	OqUyb0gWurQ8cO0jvPAyshe0Hed1De5HLo8Ac9ANkM+NxcFRG2qhvcT4MVCx8H2iPBj20N
	Dd/rXAnlXcNRSe18P+u8i6QKJr0g9rk=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IDMwyoaN;
	spf=pass (imf07.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773685275; a=rsa-sha256;
	cv=pass;
	b=12IqM78fKu75q4fL2e8NGHDQD6+7TNV0whvVSoBWtrZrqCMuWkaNxi+eHd72p2Y06ofbu5
	EaN1Byg4C4DNOz4muFn+w090AlNMBFHG3Wjd/j38eu9tbo4uZ1y/F4+Ue6pu4aaEzVKBiA
	g3XzbCzEQJcnR3jawciJHAhbIFyHuqo=
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-2bdd40d3c61so4247251eec.1
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:21:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773685274; cv=none;
        d=google.com; s=arc-20240605;
        b=M84Jv2FwZaqqnpow1F2cmxQStaLWI+b3CskUh/Czi2ZZed36gVhMdLcE3ZPVAZ6E0Y
         1cO9fHic0qaSMtiN3NQho2RLER+s0fl9oEuJm62LOG00JD7s/2kaZ+Q4F3fNEsGzYszD
         45ozEyEZP3E0mwr9P8lCOQSrWbxIUWPjd130ieJ+lsmFbCJc9F5iF/hQwJ+O+NEz/xkr
         iiNgjXI+a9X2K57st6OZMQO+Stq7ubMNnkQcY5raqzDSygrzC/UmktrWA2KYj3MfKZD9
         sTFEMw6eza7k7LtN4zVX97S81nnUDCbIB7ujM4T7+OFs+AeCTyODyrurAGoOtQr7URse
         lVxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UluXJgD778OosE4tXHA9Inh6lCP94NT6qiIkacIllX8=;
        fh=khVYHXSXQcDPR32MsvbZjyXj/LCKOCp4m9XN7GTSFEM=;
        b=IIuA9jkUVDCn2YZHmwH1yvIL4KMrzdDQGOnLE7EhzeDl6kguACwhTP0ol67YCL4/EW
         GTx/nzm7BcmBCx3DXYGuXmaK16wV4tPHmjKPjQ97KzAdh2dmm70tewwHsVxUd3Wu1HB4
         THPow5xC2YUvYUtR5lI4wXK/hYGRkNg6tlYw3U42Kb7javtqsh2+EigTUo0rPdRgHwHI
         3HxfxfOYyat99qdmUyW47itX3vyQWruUSk4/KGZmYB8miQhDiMx1Dhd5SZztgcRtU1PO
         LlFRoUPZ+w5LsVd3S/fmBQfnrAH9FwKU5v6Rv4+s3eVouDqmRMyKlrRLuFhWiECdYSOw
         6GKg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773685274; x=1774290074; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UluXJgD778OosE4tXHA9Inh6lCP94NT6qiIkacIllX8=;
        b=IDMwyoaNWWhCo9GO8xAHa9rkSAa3iSIbv6nAAzH4tLKKisnxMbkda7AjZLBaUDfKbb
         B6D58Nx8umhvrNr9ruQXlFkBCVXXxN3Znd/xzMcq2F3n5e17bvLWvglc1gsUfMcvKNG7
         tbeprtBlw7RCglbNQvHOVvanrlHypLxt72rSUPZU/pOqCj9+ZlVJllA4Vhf9yWxqbtUr
         ecK1hMJNErMKB3fQb5MUYGs0qT1kGbCRv8YtDeTo1/iuFeEDAyVMi7t4wBqoTMzzo7E0
         n8ae/vARdin2mFAaZmiQiV3AVay46z0TNLip1sjtiG7fvu2XYQH2Pikg431D+y5PY1p0
         AjGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773685274; x=1774290074;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UluXJgD778OosE4tXHA9Inh6lCP94NT6qiIkacIllX8=;
        b=BaZKqmGr54EC50LHVUS4ew6Kefo/pACl7sBB5fhokRCVNQr8DznBsBeNptvcdQxzAi
         FD+yCbbHexL4/0OuaD8An40csuYuR6y2AMBVZF79T9xOnhOkzWqsV+MH5k7/JjM8vLCy
         0ZL88LmyoNG7QB+qd/Gq6c2NXsOzJfsWgczEnh7UvRcCWjpUcRRMsB4BVUq7sw6YN1fu
         v7Ky21iIVWmOqGxf3xKQlIL2iqnWXphHUxNN5dNugOMypuOiJSo6H8XSwRw+86uOUjNF
         4qogsym2De06NBp/xlYw1Y3xJbmYhJ198c0MI8J4u/IJFjHYKwRxe+PXRuS2zP0i1u6S
         Co8w==
X-Forwarded-Encrypted: i=1; AJvYcCVxnwAGEeLg6H6Bsd+l6dnMXWjZX4hM3ZRlbgrqgfeOKLxpwvY83zb18b0Ub3+br7fznzbPlXPzLQ==@kvack.org
X-Gm-Message-State: AOJu0YzeLygWUJxqqQ+We1RY2ZqkRky2NzotVM3vH/rBvKgXJXgLx07f
	0Fh49cEin+I4XDCC/pwuHoejXcoPPn+uYq6/MrF25XILdbYLXoexzKbQVxwWOUzh5YyFejran5u
	PdqL/YUdoES93F+K79Wfk9czCA37ZFqI=
X-Gm-Gg: ATEYQzy8bTVs18DltodKw3P2c1+xCiNW8QbXo5YYqzyN3d/+eq2KlXd8TLklo9Fkw3y
	wEELr0DF0lwPdrPID6GBVFcCJGeVb4RhwPssjSCNsdEUzH2wxNGciPI2g3rbeQIScoptNNgsp9z
	G6aRO8otnRj08IT4y8mQrqbLyd+LQqw9LJ0fCdgmSyOQPstqg6xLUtOfGryK2yaDVA6gTk+J3GE
	193RKBOqMakFaHrFA/QT3YCn62fjPulH6XTzaZApApshjMHN41ga+UPvjBlMLvchNrtUtUZFjDa
	P/kpZf9bQEpfi7jD13BK+y9M
X-Received: by 2002:a05:7301:578a:b0:2ba:6c66:1f0d with SMTP id
 5a478bee46e88-2bea541c7b3mr5830567eec.14.1773685274108; Mon, 16 Mar 2026
 11:21:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260314051632.17931-1-kanchanapsridhar2026@gmail.com>
 <20260314051632.17931-2-kanchanapsridhar2026@gmail.com> <abgckU4DPI0hb6LV@google.com>
In-Reply-To: <abgckU4DPI0hb6LV@google.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Mon, 16 Mar 2026 11:21:02 -0700
X-Gm-Features: AaiRm51DYGPQmhD3mJhZNDfz0ptRwBvRdj5FNQtt41EnronqM3pX_gsdAow6r48
Message-ID: <CACpmpocu3XFnvu6m7frp1MH8_9QxHd7uZXX4QSqCPNij4P0gSg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool.
To: Yosry Ahmed <yosry@kernel.org>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5323040011
X-Stat-Signature: 8ukii4js8zbjdkrkzkdabhxaw5we7t7u
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773685275-790595
X-HE-Meta: U2FsdGVkX19l4Vf9fwRtDmr7ZujNaiI7JiTvhDKc4nW4ztePlDNXCJYME0PVYIvOI0TvRK52cs2aQdLeD5SqyMke5h6+1fyEBepEz7GYE+R35uiqCUNvsoAdGDe2CpBjN53eoMJ78c1u7C7WcpYlb0TA9T22adqBmDMPqkfG+MiABdyqwXChYoS9IJXN7PAnD5/MoM8EEeKIifWKCI0qy9LBX1FMMINMlNSd0sRj2kHK6QoDGhUQmQY9i6x0n5Z/VwAwnxWTSc5Fmivuony/Wj3q6fZLjR4/F9HSCAbjwFYw6nnGietWOLe4tHd1yu0d4fTV3c8p4eEae6Bs8F8F5Hkcrb8ZmsE0bGlkMqEQzlNHshLb4XPcT4IaTjcvcUUXsJUYaBf44s4FnxFc5h3XVcQAnAAitZBhP7sUQMzmPl7P8TgEKzTK+NiO3/XsrHtomNPfRJulLGWS+OOGvtOWdM9iP1Vy+LAgHdarPRKe9y6Mai6mnOPbpoLoFTNn/Hefm8LhhZLvBL07/6Ca1cBPTWyZ91goTYgYFd/75UlMMC/MK4Ef5xgXJeaVzigpwFJD8CPTsYCe3QnFwqEBCZrjMQ1C91sRXwWYg1DyeApiXesXX7gS4hreHKuPw/uOJDR5SPvC3pkcg9iDEVgNefO79/Ot+EhR49bmPdaeoxp6DYN0DNzqRSZ176HJRKV6LwB1nl02LS5DH/wh+MTR2yFaOCcAa+3cwiGjQsbilp9SSjtl+c4bH574FrrQ6AFnWOoB0P4mmUczKpDwMS47ipO93o52YP5WAGSkoo/4+GanFYBso0c6twSltU2QmAAzoawloHRjAjB2NbVYvsXGTm01gDH4ZIeut0E98+rOrbm6AixLxRJW+QejjZtRDoJNE+Wm9dXBk62ztkLESleEdBtADaFp4HFMFmwhEJzIJ0lq4Zx69Sz3lGPpGhGZ9h58MT8B/EQpeTZ5/sT8uNKWPX0
 KEUe3wTV
 4/hySifqgMjN3v98eeanivLaqvcrcIXUNQNLfTQngZ0XDAuUlY0aL5Ye4fThQiFO9MrvcrdrYnkkDf0s+59uQIfq39cYD99cv/qG8rXvlFE4ryuTWiHIXIfRD6AISPqTo4muEUmWKkj1Qq6iJ/e+BjB4e2i+VtpLkxJYqdqBZn4Q5Jlo6ITur4xvMlKqEp+VJ0VpIaIeGp5os+q5JcpnnVz6dWXnixxSd/rWJnEe3I9/ZX9xVbMSQeqzmiihVE1iQzrCLx/aM0SJ20Ga07k/xRlPUCbNA0C7TgX7l7sS3f01LeNIb/Xr7QZuo3pQJpreOrLvIo19NtrQdd8gqjGC81CPLTdg5U39sHiUrBvPW3b8i9oBNXxwrei+7X1cBqqiB5PA1YrAUT9qxNPBZoN9DkmWujIQ1QCeF5OHZVZr94epzApK0wfvuax0ozPdqVjRcADHMewgWfxp1JnG/XBNc6qCTFo35f3bRY/N+GrnElgpnLdly+0btTM+jCX4wBPXNqrlyEE+pJPIaBlnZaBWL7bpFjKWLdWQaK8aZX8/eGVqNDZY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 8:07=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index bdd24430f6ff..26de0468e33b 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -242,6 +242,20 @@ static inline struct xarray *swap_zswap_tree(swp_e=
ntry_t swp)
> >  **********************************/
> >  static void __zswap_pool_empty(struct percpu_ref *ref);
> >
> > +static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)
>
> Nit: If you respin, please call this acomp_ctx_free(). It's more
> consistent with other naming in zswap.c

Sure.

