Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 509F0FF885D
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 01:00:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7125F6B0005; Sun, 26 Apr 2026 21:00:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C5C46B0088; Sun, 26 Apr 2026 21:00:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B4146B008A; Sun, 26 Apr 2026 21:00:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4AACB6B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:00:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2747C2037
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 01:00:13 +0000 (UTC)
X-FDA: 84702529506.28.6408796
Received: from mail-dy1-f194.google.com (mail-dy1-f194.google.com [74.125.82.194])
	by imf28.hostedemail.com (Postfix) with ESMTP id BE177C0007
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 01:00:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XkmkrRBo;
	spf=pass (imf28.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.194 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777251611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EQvew2h5y7t1/a2E3iAG88nYAgpOqyYgpLhdQGfHFKc=;
	b=QGsq2bpO8sh7ByG8Vac3jZcXv8SfSqZay+uEuwfog5W8zH7Nx9QcUeYFtqgR8MpAzF+JTE
	FCLhrZ4ByD1ZDy/L4LtBdHZR+ZWfG+TrjZKwdtae2ZU8qhoJhf/kTSNalSqLs+rK33yZMc
	qYQOFdajq4lQwEiGp0owAKHmk6xWMgw=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XkmkrRBo;
	spf=pass (imf28.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.194 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777251611; a=rsa-sha256;
	cv=pass;
	b=tVMm1mo/wi3AHANzGIS/1xNzXh2RsVNuAMPYV94d1u82pJfve/mtobUk2+xGLsFS7ebuh7
	LgY87qod+Ulr0RCgujyI9K0PgtVKm8lqWU5Y116w7ggCN76sinB8E3MXeKpGJeDoCEQ/kF
	puS0cXpCdy3RaSeq566XDnFbxcJis3o=
Received: by mail-dy1-f194.google.com with SMTP id 5a478bee46e88-2b6b0500e06so14807493eec.1
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 18:00:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777251610; cv=none;
        d=google.com; s=arc-20240605;
        b=jXpoN0Va7WDY6lzayn7XD//2qIf2qp+ZliNBWUjUR+3kKTCVVorBYiWbmxczN0UUN2
         r1XcOWnHYZY8YGMQjsOKF97oMNAeeNX1pTooPW/Z74PENVn3NIv6q3s+N2ZPa7qVPyfi
         u5OM/590x0jPASa4Fz6ClYj41lmNf/11HWMTlfyc5m/L8bKOA9SGjBtcnUjiCkAXJ1jg
         U3LRyTrQ5sgf06bz8UJZfy5GNHD+ROvSxAI2u99RptfH/NdBUmIbNmSWHE967RLte07J
         KQeEua/QAXY/AbWOnAQ2VQpKdI/sglwV9jZ2JTuufKO43cN8S7s/MlZHQ1FTx0Ky8+Q3
         fLhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EQvew2h5y7t1/a2E3iAG88nYAgpOqyYgpLhdQGfHFKc=;
        fh=7clY7hWoGlKaHKYwVL3ufJVE7IkXdCTCmpZ0xFyOl3E=;
        b=iqxgGU3MOtT9GS96tVlpcJYQ02dCDDl7T+ZjnVDncrfVXeAfDjYiQwmOb+qsajbw9U
         0vEkRl46w8sSPYQE0jNaN/fGtkHSVqwHuilH6cQP60k+XA+cgN2PCRY+pAPjF7n4kCk3
         KLXJ5me+YMPdCXBf7CCRi4cSMwabQlF9QXDfvyMqULlTlRoazK9VNbWZw5lR3YJqXBhk
         LH9wrREGg4F+QBXdOG3f6XWo1oE9lvuBpNPzJ4+xco4SlL9ONbjOV7+2sMmknVXSZzaz
         wKrwNYkYjidfKKqOvWdpK8ulzYr3GnxExeqJJBI+aG5fymFJfLvWHBnrufmmEL27wzuB
         G0DA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777251610; x=1777856410; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EQvew2h5y7t1/a2E3iAG88nYAgpOqyYgpLhdQGfHFKc=;
        b=XkmkrRBoMmbpTtDJsyhwk90jqRq7ZjwdKZEQ54x90jXyWBavaLxe8cRrsIhYCJGYTR
         TJWkAhTQq+cHcqmsgb8yRfdqKjYehqmXW8IVW9NPbl2kcKB4eVU4bD3Hv35pJFHFmY/K
         EZX9ieMl49TyyPchCvMFLH4yC0yeOQFqp/YaiKdTn87AlkjARSZhZnieDBLYf1F0iDrd
         Uq/GegAZwdLqrvElSdhJwm1HnTLlCT56jsmg+A+8nWk/RW4rwVgxCVgR2dBZwDFy0rnL
         rHdltG/GT3+f2dYGHsvgI7/UvaK8kiX7ye4iPBSL7dCwfCxfGjE0HT1mJkww2MMRdO/H
         cL/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777251610; x=1777856410;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EQvew2h5y7t1/a2E3iAG88nYAgpOqyYgpLhdQGfHFKc=;
        b=sd9s8f5p9ESZbjrN7eIccas0DdDbv5tWvKnetfng9xlZgDtuxL37zOvxznuXsysaRW
         KjAieLVZqBWx3AxPmdrrmBmlJsIzR+4O2S15F9Nn1YKK17xR9pw5KC4yORpYy5lliQPU
         syXgm7cpEMrqP6YNb6PGFpo9M/3QQXNRYVcSOG3gIx0ZSytRm/Ppl5MlHPZFA+fCgLWs
         mLDW5e7tCZrM2TknWOM54hF0wsttk/B+mLdBxKjCRc8Zu9WJdqG+AGFbYq372MvZahMC
         zSlN7bVpFmjyg9/S91p1XeOhlSFpvMOVqyL06voAN+DYhNneZbc1bEqGVUeml3l/wPYX
         tJgw==
X-Forwarded-Encrypted: i=1; AFNElJ+Z6S7czPG1rvJNOmXY3/Ebie/RWBc+0M3trvhPiKcH8QsC3qAKpTFoLZBA0RRV3x+ksBRdVUH0WA==@kvack.org
X-Gm-Message-State: AOJu0YxDnpaLqtwU4SoTC9pMnXzTMh+6e+CDnp/6rjjqUt1SWnXF0GC+
	hOaC0yfVVkwest6oBB8M93XQf16Sz0E2kZA6Qd/Aeb35pYq7PzEW+wLJd5r2486gDO5VMANhL+u
	7hcs/qqkOEmzzYRxnGn8OFedNDOERFQ==
X-Gm-Gg: AeBDiesW5JJiveBNR47TZVnj/Pio4VOkNQM2n/fHmskbcSimTybL7BZF9gLhHsTkLFt
	GGF60oPCXCnDH3xDLgl/AtphK6EAy5vgeZjSMJLam9nvZ9D9Vf/MfBi3jR4orf0EpHglaz2baj8
	m0NYKcT9wltpxe4vMnZT2s/wKNqRSHfnVH09Opw2F6Ki/fcjVm5h/dpOM08LIVXnUVNZvmQTCEh
	2Tb9+xorZwKhFEoz0JHt0jArovCBWraaPa/M3pcidPYkZ33OwVYkUPHMmvgNPVcyIbNbWPPojX4
	KzbmEE7HAj5tadYIB52Bm9sSgReIHWLZ9MimgxNiuy3UrJ3i0D4=
X-Received: by 2002:a05:7300:214e:b0:2c4:dd55:ffc1 with SMTP id
 5a478bee46e88-2e464ea4fffmr21053974eec.2.1777251610424; Sun, 26 Apr 2026
 18:00:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260426213859.1835-1-ravis.opensrc@gmail.com> <20260426230322.106206-1-sj@kernel.org>
In-Reply-To: <20260426230322.106206-1-sj@kernel.org>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Sun, 26 Apr 2026 17:59:59 -0700
X-Gm-Features: AQROBzBShFgxvF3itryuUFMs9fmnj3RfnDehxrQhBcHZWpM_2mY0hlkDGF3if1Y
Message-ID: <CALa+Y16Y1rY7Pde1b-qbkn0H2_KmTCqAEkemwuW4xe1K01c2XQ@mail.gmail.com>
Subject: Re: [PATCH v9] mm/damon: add node_eligible_mem_bp goal metric
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, akpm@linux-foundation.org, corbet@lwn.net, 
	bijan311@gmail.com, ajayjoshi@micron.com, honggyu.kim@sk.com, 
	yunjeong.mun@sk.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: BE177C0007
X-Rspamd-Server: rspam06
X-Stat-Signature: kjxbgbzrohtxwhajsje1wxhqutb8tg6p
X-HE-Tag: 1777251611-169201
X-HE-Meta: U2FsdGVkX19c1TXtslSDymveFemayB1r45/xcMIinmC825DyDqo6jiEvdDMENdnbR0AaQFHYm1Py/v9ibKIifiGXTh3OgI/Rr/bGju9Uo5pJt0whb29f97Xz0thjIFBQ5LCxxkAWCU0mu4mwo9Aez2dm01nk+eSANSF8bOUW+6dC+gY35z6v+A3jNAU/Xte8kQiOhnjoj3VfpbMoENUdNaUnyLOf5/PqJ0H+gJjZiahBOz5OSnvWPPhNYZnDwsrPN/w8PAxpt5PjCtz1nujKrNeLRYjLKPguYJVNrJkMUSrImv15oV/nNdekKq12Rn5Ig1i+b7fFeHaGK6THYeukbccpPSFpow8QCTcF8DjDaKKqmxq7jvQpdnd6iyj0vtCxoHaOQktdJQSeEosieKdv4K6DiWLb06Ed8DWfpfMeZg5lzo0zxAgx7EcY9fEJwdZcm4tOykQ7tW29qBK73G+MCgwehzA4D2E/EcnLk5F/0pDRjc/7qmNkMVd3ZDHE7bYE43MIj/AYNVmi/kDwy0rXyTXlRkoA2+hlH2I8Lxnf6oSH3E8/e9OaAntE86mwoC3poVhm6Os5+iIYqj0ZRASxG/c6hfSA9BJq5p5uJjq02fAvzsX1XCbl+Kanx+FBkM9LsLjX488MjhYCXrT8cFiD8Ur4lAYoQI6yblpfrb70eaLXtIUwZe0GfPttH0HRsvp9AYAAN4XqsUwel4UcbHUpM0RDf11GMAz6nW8SNA8nMxbawwFrIdJ/D2bNL8uODZugn0QluyVBAgUgAHE803prDywKbGcknhjxXg++hM3ZdfB0AOJDHtQpYVkeqghdDW7C18PvV+/c3iojblUxea4A1WXK4LPjFRPLIlnpmhK37CzX2a+lGI7QxpRZBeThMA55I5RTHiYNINQimH0QyDbdCo4RM4KLTeS/1Yjsw4C0cxWSv/K1818mej3oJPqqS8lSFbRd9dfn9T7j2hypIbX
 uCz6IAtK
 A/tpt2yCH3yqGYC1t3Mytij89J6qu/A2miZFOsAmnI/BTEWVwIRIgdcAZ7iIJrhGtqhmFVuQ3h2oZx1hEJdWth19KtO3qGQ6ypjg569BDNkBq56B1KxZHYZutPVoDbHO1+DvCZhivlZq1L7MB1SFDuGqIcvyS0nZordKPSB76gpr6tx5WjgdlLoRiVIv4OOzws01/BM3aYzWIFFgJ73B94AZw/uINQnitoOCZCu7tjyCgOHy7J2kdHffUWZsx+6s9c3jZ+vO/V87laBQG6TcVlpny+ck4a7/qKGBaQGwfPVut73qwU9FByfB5LfF43BuR049TMtAa50h1UFZ+LUu0ZDQqk8ZvxveYJVlLLR5Kaf4ImbAsuuZh+XAD1II23SbTOA+YZicvvSbbHcv9CTPlnvn1U07B2TJH+z95dC1gCO91qSVbbFXP0GxDlJca47HUCCSVyI+7NVtjm2HLlOkFvBZBgTfD2V/v8c9GDpgt2LI/KLHSJP0ZK3194wSiQVP6BunCtbk7+cqVevmD1JqGYaHXSJwZtYSZ23ChVxpG8bo6mDc9Nme9AUEd0HTb7Rx8zTJZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 26, 2026 at 4:03=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote=
:
>
> [...]
> > Changes since v8:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > https://lore.kernel.org/linux-mm/20260426003245.2687-1-ravis.opensrc@gm=
ail.com/
> >
> > - Removed unnecessary casts in mult_frac() call to fix potential
> >   divide-by-zero on 32-bit PAE systems (Sashiko/SJ review)
> > - Kept original parameter name 'ctx' in damos_set_effective_quota()
> >   to avoid unnecessary diff (SJ review)
> [...]
> > +static unsigned long damos_get_node_eligible_mem_bp(struct damon_ctx *=
c,
> > +             struct damos *s, int nid)
> > +{
> > +     phys_addr_t total_eligible =3D 0;
> > +     phys_addr_t node_eligible;
> > +
> > +     if (c->ops.id !=3D DAMON_OPS_PADDR)
> > +             return 0;
> > +
> > +     if (nid < 0 || nid >=3D MAX_NUMNODES || !node_online(nid))
> > +             return 0;
> > +
> > +     node_eligible =3D damos_calc_eligible_bytes(c, s, nid, &total_eli=
gible);
> > +
> > +     if (!total_eligible)
> > +             return 0;
> > +
> > +     return mult_frac(node_eligible, 10000, total_eligible);
> > +}
>
> Sashiko found [1] this can cause __udivdi3 linking issue on 32bit machine=
 with
> CONFIG_PHYS_ADDR_T_64BIT.  Seems that is correct to me.  I believe below
> attaching fixup can fix it?
>
> Ravi, if my fixup looks good to you, could you please post another versio=
n
> (say, v9.1) for another Sashiko review round?
>

Makes sense SJ. will send v9.1 shortly with the fixup.

> [1] https://lore.kernel.org/20260426220409.95B26C2BCAF@smtp.kernel.org
>
>
> Thanks,
> SJ
>
> [...]
>
> =3D=3D=3D >8 =3D=3D=3D
> From 828ddfdfa3a996efc4620919a3cc77d55088c466 Mon Sep 17 00:00:00 2001
> From: SeongJae Park <sj@kernel.org>
> Date: Sun, 26 Apr 2026 15:54:48 -0700
> Subject: [PATCH] mm/damon/core: avoid __udivdi3 linking issue
>
> On 32bit machines having PHYS_ADDR_T_64BIT, mult_frac() with phys_addr_t
> will cause __udivdi3 linking issue.  Cast values to 'unsigned long'
> before calling mult_frac().  This could cause divide-by-zero if the
> denominator becomes zero by casting.  Avoid it by checking the zero case
> with the casted value.
>
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  mm/damon/core.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 0ea747d487465..aec43314fc4a9 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2921,10 +2921,11 @@ static unsigned long damos_get_node_eligible_mem_=
bp(struct damon_ctx *c,
>
>         node_eligible =3D damos_calc_eligible_bytes(c, s, nid, &total_eli=
gible);
>
> -       if (!total_eligible)
> +       if (!(unsigned long)total_eligible)
>                 return 0;
>
> -       return mult_frac(node_eligible, 10000, total_eligible);
> +       return mult_frac((unsigned long)node_eligible, 10000,
> +                       (unsigned long)total_eligible);
>  }
>  #else /* CONFIG_DAMON_PADDR */
>  static unsigned long damos_get_node_eligible_mem_bp(struct damon_ctx *c,
> --
> 2.47.3
>

