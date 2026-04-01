Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15290D3517D
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 13:26:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 453CB6B0005; Wed,  1 Apr 2026 09:26:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 404896B0088; Wed,  1 Apr 2026 09:26:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F2FB6B0089; Wed,  1 Apr 2026 09:26:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B8B56B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:26:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8FA341408CE
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 13:25:59 +0000 (UTC)
X-FDA: 84610060038.19.24FD4CB
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7E02B4000B
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 13:25:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Cem6rrky;
	spf=pass (imf12.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775049957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1qGvVqwik+E6UaA8EtHo8Y9hkD9P8wNTkAKesdsaWMI=;
	b=yUmwun2WBGixAOzQ8SgETEoLl+s4vnrrzpcr97FhKPBe2sNSKRSfuD/Yvpu4+9lV+O2fWI
	n/yVEykHnfTFsJNMFXj0Uewc+34ewKQehnnPMxlenp35jeOtyzHe4D/GkpMmVZe2zVqBR6
	6maeMQZL1cwaNRYxa20WLxIKPHisvzc=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Cem6rrky;
	spf=pass (imf12.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775049957; a=rsa-sha256;
	cv=pass;
	b=SAkYKsmfeJxYcxxrWVMjf8CcpxqHJT9MAXe8cQTJ+sDHgrvlT1N1DiQfzHQwCsacsR+tQJ
	eSvjVz6Jv21GG3qAadepdv/Ub3IiPQabWPGFf3Rk7pX719bPJxsledwdbhIQn1K85yUZXI
	NOe2myiIIEU+zhg1WWbr1vBCYMV0Mbs=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b9b1df1a6b3so800873466b.0
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 06:25:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775049956; cv=none;
        d=google.com; s=arc-20240605;
        b=E1CYl4Oxlz8MZvkCKFldRnnWm61SkLoimmMVh6zT5ZTiXPfOFXnJts1Dzdh5PlJSeJ
         69eTBEiSrv29DAyTf+zDKlTeDiCXVDu9VDEtR6DwZvBT+Zo8aQ1Pdyl1lzIZShHm5qGx
         Zagq9GHfaqd28RlD3oKD7xwKjD0O/fZPfMGEWm8JoSYpsHytpCM/bQRBA+2v0EaGRIm9
         BJN1IEn4hwPEZY5b9FgHdcAHmqUNiuTZgqahvC+JVWOzc3UO9FmrxjfeBv+9JLaqDYw7
         Y+TQHXzONI/g2wVILowBGQGXJghIdA1NFe1PJMnl3aycVj0zl84UkP7MynkM3glvSJKY
         /rNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1qGvVqwik+E6UaA8EtHo8Y9hkD9P8wNTkAKesdsaWMI=;
        fh=8hJZB65P7q1U6Ea1/TZeWqucnesou13iyze32mTHqaM=;
        b=CRWtwOg2EhHShBIZvu2f48+bk3kVBKmiavIZDqvcNQ/RnDSnSJmfETpZhpM8wkPEwL
         fA8ehYgJy6wuyiYrGKAH7yM4AuXWBgCi9nFoZiUpk4XtWoSTBwo9hjic8X/TTA3vhYmw
         wEofEXsuYi19/UhR6UV16ooPSD4gxbDsZwoN1c4vrWB0Q7dozh61IvJQqT28QDBDI10z
         TKRUVR6OEXDzESZFd4aN68VfMP1NoBHGJNOYWH3VlKsfA1Ko5fTDry9SlsV7R/MkD8+P
         D/I48WSjAU/qP1YhVJIG9SYf19HLeuws5gxeX6VyKWecOkIt6Bp/aFNWHdXq9oEaKTjt
         yoCQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775049956; x=1775654756; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1qGvVqwik+E6UaA8EtHo8Y9hkD9P8wNTkAKesdsaWMI=;
        b=Cem6rrkyE6yvGJQcd4L5RWTAfPIrZxbiK4tuIH3edo7HF4ZZQ+topG5lsosI+q2KyT
         Hz3cZNKbvC6dqNmqto7fzHHGixxNTM1o/rj/15IomN/XyARJ3GGSKuMlnWl4oRfKYytC
         vXiWg0wZJAh7CB5UzBjjmEcuIEx11NVE4xrg1lvkXrD5hTR2dh30rdfa7qhoutC0pNdN
         KfjCmhoytlbdzNuLb92GslgSlW4trnuIgjF4vJKsT2fskaULLZ5odT+JEpeKQz7enz3P
         51iqpu0VX8rdmz/GQJKaDPLWmtiuNytl4mwP4ILtDBPKhGgrQXDldU0dy7RxlMksRIZW
         3JNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775049956; x=1775654756;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1qGvVqwik+E6UaA8EtHo8Y9hkD9P8wNTkAKesdsaWMI=;
        b=MX8I/45N4f2HGkEFBLzDVRIsS+xKK3EmMWWfAnPZDqIEwfJ1KO3STFIF7MtaI5UYMO
         vi7aOPiiS74H2SMjqZY9+ao9gQyGMYwhaz1dI8kBggucc+Od/Q2u9JkIX13ZMCVxQlGa
         pjy8MSThicpCoQ7UAydcRsikBmlrwT8qvLB7GguycKPqVP8GKqOIsU3p1I0tsVwohcXY
         Uiv3aDKCL02dKVkELpSEP0TjpH9l+GmgwM5JQRWMaMRpT+TiHYgD4HN9h/jPlXs3D5sb
         P6+/RBchbqvc+kObjdT7pv/5lmOeccFE3wWtk4XQDfbYES6fF3Kc3SfNxbHDR7usDfC7
         j/xw==
X-Forwarded-Encrypted: i=1; AJvYcCUDLMbKAc8tQEwwABtux9Bi9rXotG2l2hxsM4SeWkYbBwcIblrDVD4OOnBz1rU3WiDW5gzMV4+/7w==@kvack.org
X-Gm-Message-State: AOJu0YxeZoo+VEGX1dl3pY6wXOtm24r+dwcmSFR4Zb+XJ8m157PdeH5e
	MyVNFvY0qPwXLL+bORRJYllCKiM3fSag7BsYXOKva++DKHW4kvxx1Ketcw3HT3SIqPz30g2FqOx
	cjf49wdIsVJvZlju8eYmY4ja+KFaEPcc=
X-Gm-Gg: ATEYQzwOnBiWdH7cCEB5T0YMi8Bkh6RSxIzhXhd3NednTlmr20dULTrY5EBpUHN/ofU
	ROfE1Hq12UrAxW3F++VYzK+aWbzn2Vb53e9IJ2HRfGh2YAmemIHTcxWxpFHGh74CfQ4+rUdn1cm
	VVEKWbgR39RipPV4KM+VWBP9i+OFPEI0CB8zTh6KZxuJvETZOz5PDMKBQYWtWVJtgueQmFr0Kwg
	W8+t1m3DALzxu+JPRbZoNDDsM9/we0YgVy2YzPIGISjHlg7FU3c+Jx8acGm6FDpL8giy8+e8Zh+
	dpp+4CFFfP6CqIfMMZ2O5zjPPuOdUtMsqpGQgBtihGebqeRoKSBnx9QAo/JBWktSpN+fBXXeFMR
	tlg9RVI8=
X-Received: by 2002:a17:907:786:b0:b97:3bbe:e42b with SMTP id
 a640c23a62f3a-b9c13b0a2bfmr237863466b.28.1775049955607; Wed, 01 Apr 2026
 06:25:55 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20260327124211eucas1p10425a28f67736d2043e7e4dd77d58e72@eucas1p1.samsung.com>
 <20260327124156.24820-1-mikhail.v.gavrilov@gmail.com> <6270d4f0-85e4-496d-8db4-87ccb791ca4d@samsung.com>
 <c9ded35b-fc10-47d8-bfaa-cecb4fa91add@arm.com>
In-Reply-To: <c9ded35b-fc10-47d8-bfaa-cecb4fa91add@arm.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 1 Apr 2026 16:25:19 +0300
X-Gm-Features: AQROBzDDLArf0c-hToXUOK8do2aJGAPhYCPRDaClvBGUScWSaymi-rt5o9xqIis
Message-ID: <CAHp75VdrGk=foAzQBJNRNDZ1yfFY8p-tC_ApM8_gN4EehpmN_Q@mail.gmail.com>
Subject: Re: [PATCH v2] dma-debug: suppress cacheline overlap warning when
 arch has no DMA alignment requirement
To: Robin Murphy <robin.murphy@arm.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, 
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, linux-mm@kvack.org, 
	harry@kernel.org, vbabka@kernel.org, akpm@linux-foundation.org, 
	stern@rowland.harvard.edu, linux@roeck-us.net, hch@lst.de, 
	Jeff.kirsher@gmail.com, catalin.marinas@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: s73krx7shp9kdtfgusfbfj7tx856d5gg
X-Rspamd-Queue-Id: 7E02B4000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1775049957-57668
X-HE-Meta: U2FsdGVkX19AkCMNxPoEYjxgIImm2IdT34Ylt17adkEpzjEfuMN1//qid0AZFlOfO1moazyxaV6Z3FYFnT4cb0MChEt5ecio8C+xB7mAYE3fLNjlzuAA5vyG+Ph9P0+iXGjJvlvoMmFPeSkKrWZPTb3TNMv6vEm419AqKd5/zQyxEwxkF/7OcANXy6HSSo57LSroHdyE65HQ1GOuKixPG5XV2B0oCoaq70mpypJ7a4EcFCrO8UHfgvI7ps9TwVo0vHTMEb5M5xuqrYEPuR0txYjNocqZ96Jna1pXhVo7G4RZsR2zEn5H2ML+mPkEzeIsZVz1RxOk6PmsKQCPhGB04fd+75efJHcHky49sZLTmpqQ6k8Umc/nxff7IIkdg6qdrxeKQdRP/rIpF4pvlCcozRrDQdNWQow38SeB9qL+4Djm3aChPYRywt63mIDMmM7h01fO6YGY4Tj7aKlaRh2PrsPx5Y2gmu+SzBw6I26wrGXlpNdr1ULyJcJ3biLOegUjJNtIBJDdOCmerxOA3OaQsQGvN6WJCp2DyeGl6bT3X1jwrumFecSTeeD0b+1b9KU4ynXYx1y2QwI+rtNzJSRFvXX3kviihE+zdzKRO9EFc+Wg3jWG9XJOdTXL2l+RGfj9cLAAvorZ4J4QdnI3xpy9SwXarJJFcQDOYY5zTUJrIkbaI9aGGMqWhK9mBEb4VVwWGlKsJ+gzORc3ADTUW/7BJPQjOyjneS7upuKXaiIVlQYhooAb3xXtR2FxMKAZN22zlxy4ohJvsLgJ3mb1CDekXgrEy25X0uD1zO+YiQ9Bho0z/+EaZO5cBOcyXHk3lgXfMiO92uZnPnMxy0ioHCgmIRFquNnsxeT3Y/LF2UYtQpcIzbN6CE+a7Xg3CEZygwYRql717UqHnCId7QTGW/NfwM5/5FzbTemj/bHN0mE2h3+9L2Q1M4wZqdaNQ5Sk05N3QQ+pJMhsxSSVEtFwCa5
 obaZPUsr
 JF/F6h2V/2B+YgAMvW4Q8bLzjKouDJJ6Job1UgSNoNIycqNNXgpOzt175HC98f9ecEknlGIp+jW2AMrlecz+NrHHyN1Cl/vnqEGA/qwLhy+9gYgt+69rZmMZZVGi/rmkV73wfGUoqALgBPk/QfCNTZtJ1tGQExgw/BAb5I74O5h6fufdRroVZktwjEurkl2xt5ycM6IW193hkYchGGMcWy2q+p6qhicFUpaY+zNtA8ZisDB6eD1gOgQYqG8nNIEfi2vWqDPT+WddvUmF5bwkHtclHYuRysAiyhB0soDeg7/tNP0LEI3Ab8IhzRdDOZ9Cu0lYF2CcREH/RkMkuHgR6A+qTxJpiQFsRG/h/dL4ZvlHCwATzUY70Zn/URW1hz2F76cEqR/pbe351Abx8Jj/bXte92Dz3wOkDxqkoMFb7xR6RPzq3SaEXqL2FD5O79ChJNY5agYjJljoYfbZQCtCW716JI4JUXLFn3YMgTawRkRbYW1EB1il3RMlUMnmslrK3UbtjUHzEpZIvO6jEFAWRXfDf7RFyDHdXLKtgY8u7P3iwHhHXLiR4oFDQmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 1, 2026 at 3:11=E2=80=AFPM Robin Murphy <robin.murphy@arm.com> =
wrote:
> On 2026-03-30 8:44 am, Marek Szyprowski wrote:
> > On 27.03.2026 13:41, Mikhail Gavrilov wrote:

...

> TBH I'd be inclined to have CONFIG_DMA_DEBUG raise ARCH_DMA_MINALIGN as
> appropriate such that genuine false-positives can't happen, rather than
> effectively defeat the whole check,

I dunno if you read v1 thread, where I proposed to unroll the check
and use pr_debug_once() for the cases which we expect not to panic,
but would be good to have a track of.


--=20
With Best Regards,
Andy Shevchenko

