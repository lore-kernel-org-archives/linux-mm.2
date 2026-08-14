Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93988C5CFCF
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 01:03:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B68066B02D0; Thu, 13 Aug 2026 21:03:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B21936B02D7; Thu, 13 Aug 2026 21:03:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E8936B02D8; Thu, 13 Aug 2026 21:03:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 715BA6B02D0
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 21:03:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D64E5802EF
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 01:03:10 +0000 (UTC)
X-FDA: 85098076140.14.275AAFE
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf22.hostedemail.com (Postfix) with ESMTP id F28CEC000E
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 01:03:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eOWMxCyT;
	spf=pass (imf22.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786669388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eKtuG6jGikRVQqJP0ZyZYZl79OB5GjG68NlKzeTaNwU=;
	b=nVFnedTL/qiNAtHNTFNlx18u680RZ5r7meZb975nvrnBB5WWXxUqO6QiUmT5nOAQHDEhd1
	FQ4GtrWab8cie6Y6vTygeLjsBwGk/BJpoZDgKzpbu7zf0VSMEVUjapBwHP555RPQpIuTTO
	oEwqJ3qjd6H2o1YNRJHt0NI09QQTJDw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786669389;
	b=ZSIze+GNQ33AmRDQqXqLjSGDH7Eg48n5CN0WCDQdpVCecvaHzYgCsqaG/eUXkCyHj4x22z
	+nvRJWqKLxnOF0ufWuEQgBX1CWvNNaikhgWChPHRqtoFUMKG+yxNSiqE3wlG69sGQ840or
	/XhiZbm4f+TAuMBCazc4vN2aOccMLyI=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eOWMxCyT;
	spf=pass (imf22.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4996c452e95so520065e9.0
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 18:03:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786669387; cv=none;
        d=google.com; s=arc-20260327;
        b=RgjAr0wup1bkO36ja4KOr9nt45thaF6jihlUqtTcyFO70s9sfvaKf14fd+Mvdt/pmk
         0v6OPclRO54a2I1E+eUAoGOhVOlwE2YnzyLDxi1PNzmm7OXryYYgeB36I0CtOVHc/Z1C
         /as8UTbXHg0bRoJQ0yFj46U4Uv2f2sOCuwnjMhAvA8Qb+QQMRu1QZOAI4ViRSEsagMsc
         ShnL06zolUdy19HkeXpur7veEfunrspg/U9h/rTd1gn8yHyKs7Q7YO8K7Q7f/AzxOSFx
         wszundQlrs5R6dBiv11t+qfEVJd42ht+DmaIZswTXOYllIdExnZtoK2e6m6BF88gdhYe
         5tvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eKtuG6jGikRVQqJP0ZyZYZl79OB5GjG68NlKzeTaNwU=;
        fh=b2CN+ZP/E8D6TdzlpeicwUyAUTqBm59NGfpo11vhwJU=;
        b=XkNW0E33kyHp+1j61nNgagui+0CqCApZ+sfGn1RdT6EJrNXuD2WTY+0dahIlaZUT9W
         FIpIljg7z4cAWaVRMjVgEXmo6tgzsOBop6A4OZCihlx6mDU+KfKWFYWBlwuekJpkJdR+
         vJl6HGfa4jI3IusHlZCcCcJ7rZWgbljTMGyyluXFRQ+7kqofweMwj6XI42wuLVQEmq2f
         uVjU8RIPFZoCmDnhGd2Lfvrp4wZo7GJcKJi3Ebvt8qN7fV6c2gQMZED41n0uOkkSnvCv
         q1uyQh3SrGHNPM5yaY8SNhdv617fkzahxK7FjYLOkqMDvl5VhpDtzFz97SCI7XPqE8dL
         /wnw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786669387; x=1787274187; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eKtuG6jGikRVQqJP0ZyZYZl79OB5GjG68NlKzeTaNwU=;
        b=eOWMxCyTcCIkS7fSWc6hTMcEHTnjpyc1MjTNVUb0hDNPWV5of+0tDdNebcBxPrYdMv
         KtSqcY6u4Q72UCggb34Dli2octH4u3Pz3JX+gG3mAACq83lJFzmj/zcVxN41HhNYpN/O
         YgrKGRa5BVYYUvqMBDWGs5wjf7exmrRFA8Q/iTu2p5az2/8Qi7Hu2UhTWFJskViaMphO
         bB8GE7asr3T983bd4Iq645yhlQOQeKMEX3wzzFLsY9tMfdsOoeoaQFKwwgkdKk+N5pwZ
         cp1ihKzoN5EOn5UHBzBl1FEXebk5W54PdDS9keV/3et4f/QqDghM14UpBetgmLg4KOpU
         3I5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786669387; x=1787274187;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eKtuG6jGikRVQqJP0ZyZYZl79OB5GjG68NlKzeTaNwU=;
        b=N8lHNHflonJhFVVMyDhLNnXbbkTc3KAmyqKPSNXVavPHz8zL4gRyRUROMH0iy/64CO
         hJEXjX+TKXz7E2At8U1mpNrOiAsYVnB+81cYYaLblDhdZ2eTJhcK9fkpUOh1sxS/SOFg
         Fiuho1CdXtnWKI9sFUX9ZLdu8KQjJo+JgyckESprgxS4LtjRnCOuAPHKRI+JeNpoNxJr
         h+ufH5UDSJpXRdxVJVbAayFPpgJrmxZy093m0i6JKs57BA6YqcxYpyWRL1fEwcv33vBw
         UL65QYR8M/pa5WboNBBdaioRacVRbyLstG6WAVXp1lP4dZrigBLsFKulpVWbLWCwBy/0
         zX0A==
X-Gm-Message-State: AOJu0YxzX1QlGwQSiDcHtQxnN3HM4uR1pnfO2r+3cpb1gMJv+BpRk3ho
	xWzznMwQNyoRH/gP9xej94GEGuih8ME0xgjnkTwsgCIM36cqhmwXNDSSmApc2htGKpvzDO9nJiC
	h26phKNsMu8II2mtX8wT/VJg9l+Z1WoA=
X-Gm-Gg: AR+sD12yuep8ceRJCvsCbz/oUqdyk6POYnV21lPevjKLA3PZeGfS7qiOfas9/LD0jJ+
	G+LJhSKpo4loy2N4UibKZcCVA9Lmd4cKqSKGL2iM3ZoYHG86/Bc1zKhp1kFbZK7MX+cbcOfM6dZ
	Lvi9ni/ClW62r+AtyMz24atQ85vtmP7Kx+M2WydrQRYHMDJhuc4PBMX4KocWNV4plhnf8ULCvWe
	LhLQampjYYXGgbvxdHnXdvTA5KdM2NBJgYzPtoopYpU0iWilJVtfkgsneiGVKDh3sDK4vDMH//M
	0nUrtnahZ2utGwABz854cyQevyOmXh9EV6G/7ANN0S5+oPpXJqs4Zzt6i+iy1wdAUkHnxVlSK0o
	vkCc4S1VpP5sKKo1ZCiAwrnhpuqOzeS8=
X-Received: by 2002:a05:600c:6206:b0:495:4126:1e55 with SMTP id
 5b1f17b1804b1-499879543c7mr12992215e9.2.1786669387186; Thu, 13 Aug 2026
 18:03:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260813075025.1406585-1-xueyuan.chen21@gmail.com> <20260813134401.a1fb632936fa3b91e454c82d@linux-foundation.org>
In-Reply-To: <20260813134401.a1fb632936fa3b91e454c82d@linux-foundation.org>
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Date: Fri, 14 Aug 2026 09:02:55 +0800
X-Gm-Features: AUfX_mylOzV5S1BtiT-kri0MP_i865uLQASBKaj342mBheeet48cW-Q-PIEvuho
Message-ID: <CA+qSx6xnAKa+Wa214tbBqXx2onA9QyUANUuzEcceEyvvsoHmng@mail.gmail.com>
Subject: Re: [PATCH v6 0/4] mm: avoid large folio splits when swap is unavailable
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	zhaonanzhe@xiaomi.com, baohua@kernel.org, hannes@cmpxchg.org, 
	ryncsn@gmail.com, youngjun.park@lge.com, baolin.wang@linux.alibaba.com, 
	hughd@google.com, chrisl@kernel.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, baoquan.he@linux.dev, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	david@kernel.org, ljs@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 5padwenz31h39tqd4ewg6emtfz7zqa3k
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F28CEC000E
X-HE-Tag: 1786669388-913382
X-HE-Meta: U2FsdGVkX1+vSrxuYSx007IIVV3bCACviaclz4RoqDNlKAGVmTxY+KUEEBHft2et/X/HWpYoCY4abVXn2jlrxE5PeFYvldumayWVTHIyveza1J+1MkPlxm7W81fmLfdzmNnJfYHKw5ZBLNOTmdj50wdfk8Qz4qEDY1Jo962hqiNnEG53HXqCtW4Kq1gYpe351n+csEBVUm7nCYDkEQpz+7BOJ3THQT7GbnhUbbo/8t7DicnKfYnY2pF3xh801wh3yIYkhUputTMvBAVdS69IvNIqIvCqTFAtTDufMGzDYOUq6bihNOTe1ZgSRe2iYsiptC/X4WWw+VYXNHv3wxLJLsaqzm7qRm/tDmVOiI+l3khfBmc2myOAU0nBRIbKqLMH/3vhlXh3X5BBN7HyUaYlFA0PzqIeEYQorY7U1zSoVq1HUIW5VBjLg/8k1g8l5P2m00xVORnhrJiAvkqf5Yc/lclLnCGtvuKorHKYAuwL34RTKsVDdKD5JhsjKPXBGvXU2Nej68UI+oMzMsf2Pf0yMynNp8O7vDyHaZR3Mgt9gSdjcT2rzklslff4M31bBnSVIdX1YVQbaRIg2meh+Qav+YnlODY91eFPTpwaWEhssVAbzTRSabsdDcfLzMFRztf7H7FHYXfAB6TD5Wiu6DihLj080SApacxZ4i0yJZMWkCBnu/PhjbK0OwCCuIkj73CQ99g//jvF79SrYyeVnkdrQM1RfKP2Do6j7dCF31HcMHHPwLp3+oA60hrjU7xT5GOwsuD6spbL3UgXY4UIX9dXIXJADGTPFgdknIDFee64L3A8s4OtKu750SrhpxnU1t7rT6/GSlA2wJUFpq/cbfyWgEtXctIztxF/knaBCo9qtcTK+GRtU1HmhN4NfhmWfZsvFmDNCkXN9d7YYTevIdUvBeMwTysdmLVrZTa8wgAQDUtTMLSyikAF+Qo76cUirjwKpDVtCQ9npx1iWjtYp5o
 s1SO/Lz5
 U4AV8QgX8CzCZiEG90hHNAmSQ/jb2NiMAuOa8C38i8JGiOu2qIZTegfgJS1CCY2Z0tP31DkYwf48RsXlFnCcMBxd6DZjHElJdIma4JQjHDzD4fJvG2UrHyPFTS4kfu9AnRJwZPO/i5tzEPCn80Pldz4O7P1IyjhAu3VVtpgIZvPIBTKI9IlOE1x+XKbHOCy43BG1x4rwkd/2+whtaZfWwmhHUjI/cRWwzN5gcfv6DSS0hUKRDcMiM5X08Itt9dshRnh64fveRoV4WUUSQYoeA/TcTXX5uNW2gXjvoedIICcQbjBtiwFVu74W9EXTdpN5jnCaApEs6hdNIV6mRsKv2bUH1fEh9judnGOObBGPKG5teDJhRGcbDZ6tFNhZgT2DLBUlUUcF7RXNUvZAl7/SXg+x7CS0D66uLdHLzkXfBj5PAtBf/HkX4I71NssG2hmcCfNoGvc5c7+hamFvGF7NgfsKHoh9RnrKO3jLIDcSQZg0DilBTy9W1LRmKV7Jm4mPTZcy/oOs0rhe3gIA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 4:44=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Thu, 13 Aug 2026 15:50:21 +0800 Xueyuan Chen <xueyuan.chen21@gmail.com=
> wrote:
>
> > This is v6 of Barry's original RFC patch, "mm: Avoiding split large
> > folios if swap has no space":
>
> Thanks.  It looks like a nice patchset and it comes well-reviewed.
>
> However it's super late in the cycle so I'd prefer to defer this until
> after 7.3-rc1.
>
> The changelogs aren't very clear on the overall benefit to our users
> (please address this), but I'm thinking "minor".  If I'm wrong then
> lets consider -stable backports and suitable Fixes: targets.
>

I'll improve the changelogs and run some tests to quantify
the impact.  If it turns out more than minor, I'll add a
Fixes: tag.

Thanks.

