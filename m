Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14254CDE00A
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 07:08:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B5136B00CB; Thu, 25 Jun 2026 03:08:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08CE36B00CC; Thu, 25 Jun 2026 03:08:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBFF76B00CD; Thu, 25 Jun 2026 03:08:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C45146B00CB
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:08:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4C7AF8F3CF
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:08:14 +0000 (UTC)
X-FDA: 84917556108.09.B026AF8
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6934940002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:08:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UYFX1DGz;
	spf=pass (imf11.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782371292;
	b=hf21N1c81aQ3YlO4V7RhRcBd6uWWPzFmKRSfMZz3LQ12z+0Dll6AH7MiE94GUHyTgp2nRw
	ITjOLPxD6aLc6Yi3a4gbVZrBun2M7vJEK1j/p92NZmtPLoZuVJQtqPYShjVA3EqdOUVXKb
	Ev0kRiPYHM47JL4vOqkc8vzJL5P0e0s=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782371292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bF1Ly5UcZ86o7fFd+qb4ZHPfpIHTR5BgVQSrSfxtE44=;
	b=F4s0wiAtir1jUMRvQnHsILd4Njp+OG3Z6ZbJ/Z7Ubx5sn5D8ODC81fEVhm4ZEMzswG1jmK
	1AAieNsEPviID0bhrNl2Dx3YGkTZCq867j85UonZMoVP9Z9H6TVzcT984XMNNSJO84Ayyx
	VHtqJ2cDKPjdUenCRvH1tE17HmSD9ik=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UYFX1DGz;
	spf=pass (imf11.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-80a8ba69367so2627697b3.1
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:08:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782371291; cv=none;
        d=google.com; s=arc-20260327;
        b=RlIR86R+Zo4GXynmkTWiM2agXW0miC5psvM7ujuNaQHjShtLZNy9/CeBhUWcjVKguO
         dF0bykaEBV6jB99JT750OqpXsSeGBmHM2ZimhoSezFfq4WPIeHjv82jsJkwvZM94HjsF
         D0zi8bX4Fl6IUEqPPj9SAlYh/ywU64m/gPUuUa94DaFX+tkx/+SY/3Ys00v15Y+M2jyj
         nMXJdbY9AHSAS6KNnGhXvHXfk+KPcvE5LA+hRcFbexwpRCmDcP1vcNH7RgvLyMp83mQR
         icY2Tcj5q4tJhgeUatnZ2/a5vvKyVD7ZgbnuzVkeE58mR9S5suSCfeWR6ERfjq5gaxvb
         8HTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bF1Ly5UcZ86o7fFd+qb4ZHPfpIHTR5BgVQSrSfxtE44=;
        fh=nFE8wUEPw0IAmhH+Ov+Y4eiGRQVFvysZS93TGSFUehQ=;
        b=M6nELj0uUhty8xBbNJrlw2tRh4KeCNQsuPZqbDeFhFRmcJWoh+nxnn1geKWVeXSoTc
         BOiJyCEImln19lvDSOfXAuaGyQJhAeSNyzLu6WciZ3ohfO6pD4EZyTNdcY5JCuMvNfDi
         jrNcJVlJfkZfxx2HcmEfUlu0M98YMF2dWhWKS3cP+KEinBfkMfIBuMmML6H/6z1ZRSNz
         v+bqZv4qYzGvTt/LJLMLIa/kym6DsWvmiVEFfhQglEeTTHlDz+50+ZKldbwjzMvxnT6E
         m2Tpw5gg/sIKEkIY4V0yaLk5oqiOjCsDHEHibJK+x49VkWE3hDFslfct2+DBSmFnGCwB
         YMgw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782371291; x=1782976091; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bF1Ly5UcZ86o7fFd+qb4ZHPfpIHTR5BgVQSrSfxtE44=;
        b=UYFX1DGzBaIJIEj28CuVTCt8WNw7eYifJrwhPGiOSqtRGLkNgDiOlNV4mLtV8Mbz7F
         PoSzrdR18qYK8K//SsjvZZjF83mGIQwHURTqnMZ2U+vEkhe9iYGCvDY6Xv++hSSow2va
         /gXMr4PFZkLobFQiBpA4CBgH/8eSJz5vtO/HRFyuJlep+yuVR9yP9NgKk8wgtFNMjxlG
         asLkXlKDeziYPjdg6btzQvvSefszdnt4KwRZe3WqV2zBfqpP26BMi4skRWoOfvum7rrH
         wWyh6oXQoKDbPMeLFrB7d3aP83hjolScAjKi+uvkCrTR538HKOvJlmesHbOQI80g/rtB
         IV/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782371291; x=1782976091;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bF1Ly5UcZ86o7fFd+qb4ZHPfpIHTR5BgVQSrSfxtE44=;
        b=c4pWozA9GQPED+OWgKaTldbqP34meiyKaMwjruqPFqBN8ZooeWl6qH7vSX0KDrQ8Zg
         iDSpoxJYpRLAX9LpaL5/+UCmPqvd6ULukhzs/YNOfX0OsWcY1gVISt1eRtBiSSafPWNh
         AhcWPY6/ld1x3jbbGIg8HVKPZnqRpLTw/gutK0jbsHohk1894jeY0YjvTXAiAvFZYdH/
         FyDNh5I2y5i629RttmnJd3OZ2D83UlS0Nd0ID0dvHuaKvSEpBViI9A//nrLIVpKnN4eU
         TFdjTBeiLEx+FkEfgGjoGfPZZVYiINxvWtYjfVR1ty098sRZpNEKjNT1t0SbKJeLkjCq
         hYTw==
X-Forwarded-Encrypted: i=1; AHgh+RpCECsQL9CPgIy1P3ncm59b6l/paNkoW3833DfmkFMfE68sJmuTzb2mX0iL2cJglzxMooPQi114dQ==@kvack.org
X-Gm-Message-State: AOJu0YzUegpbBjJit9rbvr9Jp98G9m7QI5euJcVB8D9E/NPVpjwir2Qw
	bNUE3+VTYu2BzgEP61FktHW4gJ/6c8CUD8ETP0BMuKCG4ambZWV2LNM/mnMrue38c0EgdwY+i/V
	rq91u8aq9N5+hwxlujMdI5tC9XfmLX5Y=
X-Gm-Gg: AfdE7cm+FXNtmbPAL3Sv32oldmtyZXjzizl3AbXgP8MH8k1hppMtkrbwbsc5u0WSYT9
	VHWWU0MJgeAANmWER2Av7Lm5ERiVM7hvd7BmDuShGdYYRvI9drXQdOEaWmspMgbxhszKVtw7k/J
	EqZI1yxo/rBf6w7+ozSyi7aXbPqcoM5mbLfxpyEbC33BKupSg0ggB/vAZIpD1hIUO9XEEDNV3K4
	kiI5U0Uw6vu/MVTqfkUQu9pk3CtAtw6O5YxkENzNJgFaM7eYSID2BtdNWid59PHYTCFY7wzYYMJ
	Oq257XBd
X-Received: by 2002:a05:690c:4988:b0:7ba:ef98:9720 with SMTP id
 00721157ae682-80a6780ad65mr12771107b3.4.1782371291365; Thu, 25 Jun 2026
 00:08:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260616031309.3036234-1-haowenchao22@gmail.com>
 <20260616031309.3036234-3-haowenchao22@gmail.com> <CAGsJ_4zjuSnR4K5DS0A6yDaZkvBz-9ODNxr3Yo5_0O53MosiQg@mail.gmail.com>
 <CAOptpSO7rLHOCYXgp6sFjbWMD5tf_iK6B5NNrHWb_CU-tuVmpA@mail.gmail.com>
 <CAGsJ_4zmfXg_ub913S_uYeziU+mj_+Cks5iS22oTRRt2Y3LYyQ@mail.gmail.com>
 <CAKEwX=Og51dvN9PsH9dhVHTU=CQk5oRHwJTiu9mN9Bn8uLnx0Q@mail.gmail.com> <CAGsJ_4xj1SvosfZwOuki14gYPJ4VLs9qLmabYzKKtgxQR0fy+g@mail.gmail.com>
In-Reply-To: <CAGsJ_4xj1SvosfZwOuki14gYPJ4VLs9qLmabYzKKtgxQR0fy+g@mail.gmail.com>
From: Wenchao Hao <haowenchao22@gmail.com>
Date: Thu, 25 Jun 2026 15:08:00 +0800
X-Gm-Features: AVVi8CeuW1yjI4XojkBP3JsgGbQNQiSRa2bpGTR0QT_FYtZVzFP26fG2RznIF20
Message-ID: <CAOptpSO+tu2AjzkzoHTNNrhdhbPa=MUx=w4gW144RNNNuEr6HA@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] mm/zsmalloc: drop pool->lock from zs_free on
 64-bit systems
To: Barry Song <baohua@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fc71o3i9w1ezmgndxd8iwiddcusysmha
X-Rspam-User: 
X-Rspamd-Queue-Id: 6934940002
X-Rspamd-Server: rspam02
X-HE-Tag: 1782371292-769171
X-HE-Meta: U2FsdGVkX1+KBEq2HXVtTO3/4bG/slrCXvKN8mbZwOzptkLRPUugObfhaVzJZ+0WcCK4c99YeiIqO9SjT2u7LPKYH/ynMsZCDgJOXwRAO9vBBnvjtyqGDv3Fbw5YiLb4tgR2zHuPIqAgaXtbqlaZHWaFbNNQyhtR010aikIaLw19kwDfZ66cas0JjiOL7gdhgJRBg2AJSG7neoAb9wKLiLS1n7X6z2cVZhuhwBZ+XbVmalfU2Y1s5kE31hzdifzFTh/nLtXPnyo6h6vzaMtaYWh//8KEscmtrOii30S2xzogUb+RUA84cXgnY5rOlzby8YGjRhVK7E0OUYEhClBjstEjxMdGeHY5TkKKKso+TbLX8hMwMP2g8Be5084Ux7wXoWK2uWQamEy9YpVOz6zdAqOAUpj4iWZ0XcNBk3sdaIIJGWQOVwDGKnqfYzS8uaAdOHcRfgm8Acwz0gE7TwRjteIBVRB3QyNMsNt11X+nPEEs32tS4rnzZWILWUITVtNziFm1yagol07gBvBVRURAKrt58ul4eWMwyJ9BAUGxikfGASAXokkej4+IOisfIDKYmg9DC2r2QYzdmFJc9Kl4kly0AF5v2vsxurCgSAJdPTED18UP56OwU27YljR/DMt7k+TStxRbe1kKm8InkjUDDm2f7stvqQw/MF47kTJ3oMKAmbV95YBKklzYrvXKNDQdInMuZSdo9M3GhMvsppgxeia3a0+eOhJ6Jwk4TNYrTpcmZSpLKJ1L/meCyXw3O0dS+llk+vh8XY2N7qoPG0tg7JFxNxqTbaZLfdhi6HlVz5RL/6Y46m4BuYP0RDGhuKh6j/IVkA8VDQBtfpT4J/IraFIMSshgIxNOo6ewqhmlQlViJ00avUOqfuXIfIcdScCv7kNgwUsTGbXqckrlPgk4Xje7uY2xeNnyrSoQIgCwp2tVmEJoLHLKYH1Xida6bdon4RGGAjtZPHi4qKEc2E9
 F5volkQm
 DDr3+p1nSovJv6c8cztxNdVupSJuzgPEISJ/9u15lf+i4Ncj6bZReiYWKSAR0GroGDMxcusvbaaa2CN0ai+IGi/hqaM7rlGMyAFSRfvDO8jZKzEQPHmD/v2s2nOs4uUdpT/zKtCpJHHzE53DwchZLe0aBf9zf2mJoUH7l3hqVkhLGeVdkaGz8cGRZZ4yD+dikGSyE2rGPqWspu1//KO8dWc09lgJDgm0oF/WRtBV26YTg8E84K925K1Q3fflNmdnnJP/Deu4VyT0bfM0xPisrHeQIsaObEIjM/qHhl+bTFTpM/z4b61eYOheIIGSMB/BFO8eHfEJx30taZppHEp2/AQdhrZJluPZikXNcqLIn2w9rsZgtPlA3rbDf6vOCMemmeZ84w9f3W9MHuDXjRLc8GO/UNjNGGPnly9bIlnCmw9RI6RuLU8CDlSfSPBMhbpI/FqWNuMn9J3wJgGOns4qtqWh53PeJQz0C9A5I1T7Yp2qpnDGaKKzevxuXvq8UI3xD22mwCuSb4NpuYRv4rTJnljpZsOZlaRY9iIGPGyMTnIkM9fr8ZRdAHoInbONF7Pg/ISF2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 7:11=E2=80=AFAM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Thu, Jun 25, 2026 at 6:39=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wro=
te:
> [...]
> >
> > get_and_lock_obj_class()? :)
> >
> > or obj_class_get_and_lock()? - there's swap_cluster_get_and_lock() as
> > the precedent.
>
> Nice, that sounds much better to me.
>

Thanks Nhat for the suggestion, obj_class_get_and_lock() works well.
Will send v6 with this rename.

> >
> > Anyway naming is hard.
>
> Best Regards
> Barry

