Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CD5CCAC5B0
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 01:58:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 856AB8E0003; Sat, 27 Sep 2025 21:58:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8072F8E0001; Sat, 27 Sep 2025 21:58:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71CE68E0003; Sat, 27 Sep 2025 21:58:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 601188E0001
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 21:58:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EF7DB14095F
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 01:58:49 +0000 (UTC)
X-FDA: 83937000378.12.EC2425F
Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2ACE6180006
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 01:58:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=h0v2eNIS;
	spf=pass (imf16.hostedemail.com: domain of jianyungao89@gmail.com designates 209.85.214.194 as permitted sender) smtp.mailfrom=jianyungao89@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759024728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A5J/rF/bT3HbL7GYNEj2zXCEt17ncS6mxLv9yaUaITM=;
	b=hYzFtI698Kued1ruOxYtl/NJxvCt1FWU9qvnKyWjKzsbJ5iPcvNJ1hrUNpoFkknVvSDkg2
	8Hz3LXGd1NVTu3Yeifxy8oAgR0lHUTnnFitGORiq12YeSrFqYra3Xkmrmc8li9YKjbbj2M
	V9leyAIywB/uBKrGwmvUHwXNSsGKrqY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759024728; a=rsa-sha256;
	cv=none;
	b=Zl6LqdfbT3YOrzoS6PSJBtYDNcwx/je0+w+/YBqlb9yzSx08ABDltdsoMGx4LMmvVVwGN5
	buOtRHoJYspIl3LVjexM0pYUByQfP2x2AywyCz/+n3zYWsp6hlCuQvCagM10jPRQgMfIbC
	rmgxzr+ufOvLiFSYvC2E+mKdQQjkrvM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=h0v2eNIS;
	spf=pass (imf16.hostedemail.com: domain of jianyungao89@gmail.com designates 209.85.214.194 as permitted sender) smtp.mailfrom=jianyungao89@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-2681660d604so32908095ad.0
        for <linux-mm@kvack.org>; Sat, 27 Sep 2025 18:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759024727; x=1759629527; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A5J/rF/bT3HbL7GYNEj2zXCEt17ncS6mxLv9yaUaITM=;
        b=h0v2eNISQmCmw41a7B5Rzn/jX0xsJEs1le8qlY9rzwkZTF1RTYnZfoKgOlQpKv7lQe
         1I48H0tW4cvQ55wxMJ6N8xOmBPqjY1cP/kVsm+jXFMkAQ36STeHkanFdK/0YEXDey8M8
         p/T8gq0+EUGnqPxDo65DpcvWhYed43q/cf+Vhq/aepH485sNJojm+C4wItpfG4Fx3OZ/
         IuuzA5vuNrYc4O7VfBnjJ+Rsk40zsVPZWC5VDO6jVuhgm3OHvA7CmCvZJ30YBQlpshvR
         fh1w9+rT12Lzej6tEN+ej7czVM0ZkdSBhCmfN0xHMnR80SLHPrISbFrRLbOb68lQSlJ4
         Cvpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759024727; x=1759629527;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A5J/rF/bT3HbL7GYNEj2zXCEt17ncS6mxLv9yaUaITM=;
        b=TrZZ+urKqCOVBUrxIbBturwyGoZq2eiCBypTYVsShctUFCxprGBnAmJA94AsHrlLJ9
         P90PvLA2Tn1/R2pWpziIuhRZ2nPY3WR8kyXQ07ZgvODVu7jmiiWej3iaAZ3QevktlapB
         Wtir1o/ujRbvjE48cDXNgy8oJQtYXlrAhXj1DwO7UGQU8yBS27Arg9OSIaoPJgRtlYTe
         DhYoazNe06atfqnVE/8hl4CUCT7IjrD75/6/Ee5D4MYQBtlH9MbVPD+K1hpn1TnMAMka
         la+JsoSpJv7wwq1cLVgYZ/Ro+paIkywBDBFSMN4mHumMMrUmhJ9ZJP+uyIy1xOl30xHa
         FmOA==
X-Gm-Message-State: AOJu0YweWnjE+Q33sg8sa2+jXXYKVWF25qkrTOaKZ1ObHcvYYTWvTFuA
	dMeDFVK6VBSHtEEBLPEvSPBhitgK4OYkdQaa2WK3bLI90FRDPBm8G3miEnUbKFWOGElN68K+4Z6
	gqB1EJkZjn02m9Img/PywS8ORQJmGQvU=
X-Gm-Gg: ASbGnctOth3GNRlXDyZvbHBssrAmcm93ss5oBQUkkYfrNLBrtRDBe7JNPW5okPUQNhI
	by+NWj1PnIWQDch/UuyCF9FRkqLocpkLAgQMxWoS3AwHAumETig83vxwssV9cWdOAqkb56RmDgY
	QaWPJd1SyUcJeysXPSr/3t3iFKPrfqBj+7aRdDXyBPhFLtBYaAVj/vY+d+ke45c+VBnuCeNHE4t
	H4fC092HEPHD49GZ/QL4EotZ6we
X-Google-Smtp-Source: AGHT+IHMr4GAhOOYgL/sXUOERr0H7GehVK7nACxXSc9vI5DWqoUYmLvmCEQseqEz11GRtA2XbKHRiIeukKwa2mTghPo=
X-Received: by 2002:a17:903:32c5:b0:269:7c21:f3f8 with SMTP id
 d9443c01a7336-27ed4a31641mr139636615ad.39.1759024726897; Sat, 27 Sep 2025
 18:58:46 -0700 (PDT)
MIME-Version: 1.0
References: <20250927064926.1496579-1-jianyungao89@gmail.com> <20250928013244.qzevjut7gbxdbyli@master>
In-Reply-To: <20250928013244.qzevjut7gbxdbyli@master>
From: Jianyun Gao <jianyungao89@gmail.com>
Date: Sun, 28 Sep 2025 09:58:35 +0800
X-Gm-Features: AS18NWCJJMqbXcZQ3ctHwvgO-5vDzc9IB8XsIIHkkMb6JC06O2fFVitblxyc84k
Message-ID: <CAHP3+4C5U7CU=q8hd6XK3zpKhhj7m1OdY7_pMpz0m-csDBpdmw@mail.gmail.com>
Subject: Re: [PATCH] mm/hugetlb: Fix some typos in hugetlb module
To: Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qux61d76e5zhmt7gpdhtxepfr6mugpph
X-Rspam-User: 
X-Rspamd-Queue-Id: 2ACE6180006
X-Rspamd-Server: rspam10
X-HE-Tag: 1759024727-45476
X-HE-Meta: U2FsdGVkX1/hifU/20uYGIf+spwVjp+L3fIBmp7FrnhsjeeCcJUJcBdm83M1wFsPzar9xaYsXMIgCKaGK1Lejt2m67F4QhE1IynM12jmMRfdUGXuu8SF5B/gVM+dfZPlZAzG4QfJNAA09w+7g5N77+KXL4y7CX5ZVndudRg1++94gb2EnkrHMuV8d++Tl4Ov25sonqsImXx1mhAVUnWBA1AGaTKRkPjPqQ3STopNd11MzWlz7ouMxphMegqSmXRSoqJLBntfsOZKO0muRkq7uFsEP1+Zmeu76QFpYvane81mgNnlL6dTu7D3YICWeiYHDeCPQ+6XjdjerT6kM8m+zftq6I7Uo1Kakn1JJibeNfEPgBGwGZw7s020lx+EWy8QMpjJ8a6mU+nX8NGy8cVNryffcO9k9HBw/pBQp2r8ooUjIqCfiVA49CpwRiw2WZlPHDjwcNFzV0zzZVWNMscz8rxHRdFSK55MtyceMzJCgjqyOCMN7y9TYXo4KiBrhH0opLNnuyoQ8joz+ujevXI8FS8Qr/zrh9US1M3XszT44qusGcLVF1sYKRgsoJG/gMwPtYnVYUT3Mrbi16DoYe9hPAE6wfS8/LV1y5pQZMfbkWZ+I4S0hgAypJ6hjW69xYKC5UH0/0/aLp8MXanXM70vppRk10hlm+hoppn4wBCGle4tZPaoYbeZ4z1/GYoLVVgsRrSQiXXD4x8Xcy7009IndjP/ONrFuzoXSyXx7vvRAzXnCjp9g2paJu4G0hdM9u/MPkWgGejb57vGy0a/79YqM2WRMt5+2UrGroHJlpp06Ev33iImAlDOEIJb9kz1R309SKru8qQ4gVGZOiBeNkp0jXB0ckI7IfHNJd4vSZ+DXBqEk/OxgcpZNcHOOqA7wSiaD5QbjEwU7TXgbwUq/vMQ9pdVzvPo5R3H7E4X/nsriNzWdQr+mmn1tzziYSaqBLRU2ezWbvX95X5M+otSyk4
 QkKXBoHI
 mFbArOxkGFq49vH81yMeynu2M7BUgOk+JgEVTegWy49Faah9HhMy9ARAIskXdbGAGhd11ZucrZ8bNKMl68/Mn2MA0hHdr6eXGQzDqPnf0Mq1sUdBcjE6TKor0vPzO/OApCsQeFsnguUT231UyK1Au6zC/HHqtUZ6oRytK1enWAEfC5VNStMwpfVkMVjBQljn9why7zfjhhV18iTn14jVK/mYxF1Qe8C6h6asRfSIm3ka9DO5zh7HUA1Faje5WT8GERrOemwAYoAxIHJ9gmhkpziCzF6RJ3x6su9YvEx32+kPjtnP6LZzfiA1NnbLtY9hNypvgrthnu8ru9xYq2Bj+OnC700ggPPlGRneRJynUL7PXP4UzNYR4ygX5KVqmUuGcPlBTtQEmzCrOF/eam7RuIh4N6Z+eNr1oOITaFcOwTRPOQzlEBsGwe3wipzGIHkoVAhIYpwbCCReN8YFF16qq6AtfyI71ixr2JvpZ+C6HdQldxksn52lw4CYBlXlwtoFZv8ncBCmxejlkXoGLyIjdJthrgSCZCNtF2tv8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Wei,
Thank you for your reviews.

On Sun, Sep 28, 2025 at 9:32=E2=80=AFAM Wei Yang <richard.weiyang@gmail.com=
> wrote:
>
> On Sat, Sep 27, 2025 at 02:49:26PM +0800, jianyun.gao wrote:
> >There are som typos in the code comments as follows:
> >
> >  differenciate =3D=3D> differentiate
> >  refernece =3D=3D> reference
> >  permissons =3D=3D> permissions
> >  indepdenent =3D=3D> independent
> >  Spliting =3D=3D> Splitting
> >
> >Just fix it.
> >
> >Signed-off-by: jianyun.gao <jianyungao89@gmail.com>
>
> The change looks good.
>
> But maybe we can merge it with the next one you sent? They both belongs t=
o mm.

It`s Okey. Thank you!

>
> --
> Wei Yang
> Help you, Help me

