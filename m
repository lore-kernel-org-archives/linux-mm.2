Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3175BC624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:15:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 495446B00B2; Wed,  2 Sep 2026 10:15:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 445956B00B4; Wed,  2 Sep 2026 10:15:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 334B76B00B6; Wed,  2 Sep 2026 10:15:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 129106B00B2
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:15:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8E1FF1401D0
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:15:20 +0000 (UTC)
X-FDA: 85169019600.10.CE7546E
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf11.hostedemail.com (Postfix) with ESMTP id A308C4000A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:15:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OKiyE9x9;
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788358518;
	b=ftGkPqN6IxKzbc7aVPpGoseuG3rHnDyZwSYx0MGPa6HrjAuFw/p0GFs3SupHAoUGH0gDZa
	tn7KCotsJeTPVK1NGSFF+RnboJILwtVnKutHPNxE+rvsGhCLKyp1LbFMbnPR3lqiAUe9Rp
	ORPYtjCo1lEhushSWYfoOuaqZMMSUII=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OKiyE9x9;
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788358518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6RznMFxVVbC4OvOdC+iBHzOZQOg0QLC2cwLiQWP2ju0=;
	b=5noY8PNPUP7Jsrw7nxP1Ut4Vw/nAc+AqYP4JyaEjFg5aDpAA/EwQ+tR12kOzkV36dEjHnM
	aVI+VeBXyoRLLi0khjJvm2YLJJJYTSYMEcN/1VKPrDEjhEuAKSwaG8+i+gNi/CzPCyec6k
	Q1ta9JPVEANNBGBapxkYJVhOpHaTjgk=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-484374f54d0so721802f8f.3
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 07:15:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788358517; cv=none;
        d=google.com; s=arc-20260327;
        b=Vah6yd9Fgpt+Pb7wsL+1i/Cv4ZJp9oieq/Etkd9bxWNqwGWJ/aR0RuoGcNW8i7j4PA
         TPurC/zGoXXpw0uASFClSWAw7mE/XwHwK+hV2iXfepatHVEKUFnebDgs7hFqbm4dCV/C
         rCSLYU7Im6TdZ1XiprMKL61mxAIXRl1mFDp25XUq8k4vSEUb4zb3AXAo0CIJIO0b5YC4
         kiNUFNvet1itHTks5tmqlMg+YYCQIvVgXL4i2ZYSdtnwMvhR+2o0z6WDF5aRthaai/6r
         avXBkHuYV0p/y7ibQY8j2bNaEDjqveZDULk4+xLdfz2J7nUV8qyrOz/IY1mLNU9vvgv1
         APIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6RznMFxVVbC4OvOdC+iBHzOZQOg0QLC2cwLiQWP2ju0=;
        fh=KewnQt8I1RGzkGmgAsxpY598ouhBlUDawARPe163as8=;
        b=JVsmCdbXrJ6dLf7GMJUYVVPols7o/ksLq+AjfYNfGXKTdleQT8j3uedG7+dgNAx4E+
         9rQ6wLhqvrqqJwE9JVAy+X4bncLJajf+tJRUra5+5ThwtxSnDl7/1s3bp2cfDtlVNTKA
         d/LdFbGMAabvnDbJlwgSQCklxXcdacItW9pvQmTUjkVeH4r10oeUhMatQnG0pzVkpymF
         1XwSew6iYopJWptf+azKKCKI+9NRrWG3IqFF6nIyYRCJ2oOYWeL4lZPKwB0lQ59QsMYE
         A+hkwJ/kCafcsUOzgqF07MzSCdD9tDZG/gzaAkdRmjhE0ubO6KcA8aGL4syHe6FRVmcF
         b42w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788358517; x=1788963317; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6RznMFxVVbC4OvOdC+iBHzOZQOg0QLC2cwLiQWP2ju0=;
        b=OKiyE9x9ifofLlJsO2DyKJckZTLRDmbgZ4bL9V/ybRCIyJ0b8pHA4eQOBfwJLO14bC
         d4iODQeC38i9RaEnaGkHtxutSx/eJ1sQweuBYf29b7H5N4Su+m9Tmk1QPR8lDGpoTB0p
         q2YqqqnC0AoPk/g798/H6iEmgjqXn6T74UMuc2m5DDHGPZ6qB9bo4rdSHBfUts74pG5l
         gybS5D8FMdn/1k1p63yJMq+UQxpUxQU7r84HO6pyBkhEfBtxEHRseQMBE9vGwMEU3pO0
         IpPaY/nj5ybjrD4eDYGp9GqSaFIiul8ZR0wrTck6zfNKIgB31mzQWEsGCCAV+vo4MMIy
         eBCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788358517; x=1788963317;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6RznMFxVVbC4OvOdC+iBHzOZQOg0QLC2cwLiQWP2ju0=;
        b=X+w5qjeLckbn5tcAUeCl0okxgpvlGtYmVst6qdWTss7F6flBd/gH5SezyVj1vuEvfT
         LeOD2aPWpdbujSsCnFM7Jn5+JgWvK744lwKYubS+KPpxxTHCsTyxRYgMtOI0gjk97RMv
         IjmB8s3YGNHkhE3p58uBL/fHI9MvCZBrjUEk28fKU8xUpDxwc5dVAMWdUhOblpz3AXu2
         VRHoVbmCMIRSIs03NyVqJtH+zDatZwsdVc8L091J/hZXKLzKoDW+E+iCGZL+c5RSNlhA
         Pf4hdu3ZFHhvyRScnXBjFLgPmGb4K7ElF8dksGRYIIybMs1ILlQJM/LJCdACgHExTMTQ
         0JTQ==
X-Gm-Message-State: AFuF++lNg+9l4S0gRCDmstCC9tHXj2Tng3w9wzGQ8FDrtIGFDrg00WFt
	QEfGtz9O5qUZgfyaAavGavIWd8O8XzieE9E91OQOjxKj4VSAj3FSkObj63FdZ58vfLtuV3PNHqF
	BsL+HefObUp5qZn9YS+KpI/+TnowbA4A=
X-Gm-Gg: AYBFou3f4kqWFrXN2ljIxjGl2QW1ihSpw3brx2aVIYI43EhwSrLuuCFpFC2W1gsiw0/
	rEms0Rtjp2S4M5jRDoqK50dB3/QtW33Ru6/exWxwY5jTJDnPZvJ/0DWNoxkvwatda4w+u0agTMi
	nHZLYenPSrKorYS2uLW1c95AcrMpPM3x+R9MtX/kei4q5f9JQy1iB2DrpFPQlBYAxXBsgD3JwD8
	dkHEldN/8dIsGfNkj64XFORGx8+m7DUV4U15l/+9wMOEacpnWHWfUBdUGWnKjPdmfYwsCvSuhNM
	s/oxf0vJuLZTqmtrAeyAmWeaqvFy2ufgaEd+pL1F8D5eHsKLUEJal5i0wVmPmJonzvdzH+F1yMt
	Dpg==
X-Received: by 2002:a05:6000:196f:b0:481:98d:b24 with SMTP id
 ffacd0b85a97d-484913b9a8dmr7353105f8f.19.1788358517128; Wed, 02 Sep 2026
 07:15:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn> <20260827094509.1016740-8-hebaoquan@kylinos.cn>
In-Reply-To: <20260827094509.1016740-8-hebaoquan@kylinos.cn>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 2 Sep 2026 10:15:06 -0400
X-Gm-Features: AcwNN1WAKxDXLmAG1e0SeJ_cyeDzb_A4NqukLANh0VTS2ERN4dof1j2brfMyzmk
Message-ID: <CAKEwX=P53GAmyPeBQ29XaHnGw5qpKkiKiBEwuhdRKdkMPT0GSg@mail.gmail.com>
Subject: Re: [PATCH 07/16] mm, swap: add xswap grow trigger on cluster allocation
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, baohua@kernel.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A308C4000A
X-Stat-Signature: z46on7is91gyx7hgaj5pj6kk9rx1pjkj
X-HE-Tag: 1788358518-532626
X-HE-Meta: U2FsdGVkX1/O/ClqfSAapixLB6qRaVz0dGmDoU8ENdeUPw1A/rITsbvX5hRce9AkN8kN6/pBfsXZwyLiyt5f/SYd3y05DwIUzFEiueAHFrbmnFva2d3ymcLJzVSt9aHu/oFajbrrrF404MlFFgm+lm5wn5nLJKq/55T+hivbSBQge4YQxwPeAXK/LvBmW8VpYDyXDu1UkdJVlByrc9UmQrpo5JGu0Tj+lzTdIdUu7w7cVluqdlRM+Wotli+GBJS2xuXyeV+FFXML4aAZfnxSLjO52ogUfsCBm3Kx6knrd0XBjvpj0r3KcrMYK/qyvdIcK8sjf1psEuZwefaX6WlrYoHvOERW2Eg/UCOJXA6d/5VJR5hv/u9TZwr3KxzCFXJXjKtWwOJBw/V3vu9lShDqqkF/NkFu59Fo5BIejwnoJpbQMA10q3ev+E6T9kouwtTK1rMG29JOYHjqTdCnGuup+SXyx3lt4nP6okdfEXzRkLJqQ6M2+VHIxOtlRq2vDmn6/5AGfSDpAXNMUvc/PHJeK+U+exIlMzVtFe1tnd6LcSASAbpZn9Vmwad1/nY1aYnO76rPOsoV/tkE2+9dTc4nOcLMyTx/wOCbfjIavoYEESt8UYtpXdcdDmbAPt/aMULFOaIfh9tbeyC/om9HYPNWsxA/emIAhx65qk/FfO0E8cofTXINl0QtPOLlIIf1Hz6jrsvFrLJdS+CcOXZmerEQxI/S+ArZgPxlBpdYq5u/y+u8qGwAt1ZRA2gAwrs2V8T9lJCKKfkuWbkupye0A5ywaCI1XcdVPhujSjOtQX9M48GEplMXJn6pwLa0JHZgRQf3sIG1cl81hpKrPGRi6uigmj4c3XP4LN1BmBTMPJINSk+jq2MopX06khPyFmtBiOR1ax7L+C5Qm4zZpJGbBzNyaS+31uW1yxw15z+OGo+VVfeQE819YH0QdzyiCeS5hpW3tRN6on2oQyU3t7K9PvM
 PjhbrUA3
 yWLb+WyTF5UeSQO8k7oLGNv0adwNS5tGi8XhcDO35tb2QJsQoIJOVF3y8l/dSpJEF6XmPUPLfwzcsA6NXEXAQGRBqGLx1fvQjQPl6C9uozAlDL6wy3YkqNM1dsq5WS3vVUNF7vJeOi5znkfcr2l0HHMT+YyGB1/uxUuJkbWDWQEkGSU74z/tkOSj6IgdOwVrmdsWAk1f5Fdvt+rQfz3GQ33Y+/QFmD7zlmkLrgODSu9iA2XiKxJelhivYjfZxLCqQxNl7Rl4YtHe0HN1XA1kgC71kbflto2pPamC7U9FpZ1gSakPxGvrUWZgPYhBFhQZroJVlXnwdPJs75tqgjEspZvDujnQt2IUercMGG24tblp1ucjyefdRUDHAYcXHfBy698G0i+PNr5Byh07zrzlxuXXiJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 5:45=E2=80=AFAM Baoquan He <hebaoquan@kylinos.cn> w=
rote:
>
> When cluster_alloc_swap_entry() fails to find a free cluster and
> the xswap device still has room to grow, expand the mapped range
> by XSWAP_GROW_CLUSTERS clusters.
>
> Since xswap is always SWP_SOLIDSTATE, no locks need to be dropped
> before calling xswap_map_clusters(), global_cluster_lock is never
> held on this path.

What about local_lock()? I believe we're still holding
percpu_swap_cluster's local lock as we invoke xswap_map_clusters()?
Would this lead to issues :/

