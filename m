Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE0EDCFD314
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 03:07:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 207046B0023; Sat, 22 Nov 2025 22:07:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B7CC6B0029; Sat, 22 Nov 2025 22:07:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F4AA6B002B; Sat, 22 Nov 2025 22:07:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F1B806B0023
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:07:23 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8916B4F4F9
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 03:07:23 +0000 (UTC)
X-FDA: 84140385966.17.BD5862A
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	by imf04.hostedemail.com (Postfix) with ESMTP id C956540011
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 03:07:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Bh7SMJby;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.161.49 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763867241; a=rsa-sha256;
	cv=none;
	b=kKuu7bqXtZ0K31ROtx3CdPN5ABxmSCGnzozZEpV2Uh4yukXkrsKjsfKu/cG4DXv4OAHTET
	9Cyf65JfRVxtbOE7/lm3aKh9EnSYY5t8a1WIffUM/ZdstLY6ZExaX/jmUPAwrHEkTDIUpw
	rVTEaVX+EUQl8X3qtVNzy52itlH8SVs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Bh7SMJby;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.161.49 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763867241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YzGX8P+wyykXQ7vc9SLz2LBCv9ohbHyJk+lGTSCle7M=;
	b=iWKLVqamkwn5jtjTlvBE4lMF4n3g+dL+6PGjJMMzyCxgf6UcQOqPgA/WyIuisOOS1iBxSQ
	bIT3tTkICa2jESoGmP3zK/+znzIXXEu2i/IHMzOwmdlmBA9cDfVwnrux7aH7jVA1nheoDn
	pWiRSKLOjDNQXu2lrv++2oDYSySat6I=
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-657a6028fbbso164702eaf.3
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 19:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763867241; x=1764472041; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YzGX8P+wyykXQ7vc9SLz2LBCv9ohbHyJk+lGTSCle7M=;
        b=Bh7SMJbybk0heqgT1dSCtirqwrCzKxyLgAvphST8FK9skwBTzYVho5w6UwNPynb2fR
         /G5b5PSrKjc8dUBRyZoPbcLV8vXllzHaD0nLauqHabUuoQK4MYy2pIq4VGXFp9ijA8va
         HnllJMcMhel+R7PmxHEIZ7wQw2DcpnyVbkH/I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763867241; x=1764472041;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YzGX8P+wyykXQ7vc9SLz2LBCv9ohbHyJk+lGTSCle7M=;
        b=H3gDf+W05TmyXv+JZ8D6YuXkAdcjvPLJnZ2CRnFTp+EenZ1EDfNCD3vsKfHpL/CSmW
         AcoTG5D7kHvR/oSiVQBh7km5bMNBKs1N0vuyMm4V9J2WYccBfnNlhvtav/jQazIIZQLr
         Yy6brfaXbCewy38ve5KdX7RTBDK34M6acHVPFZDXaZHF4KjGbiMGF7aXeLkSm2/iVHEw
         VHctDo9pNVpDFPOF5nJvpa2Qob1GN/rxVLx0EFY98G0SUxmTL5foF0EfeZ9G9aXsaMvq
         Dta/95EB4SLqjJDezT5IrpW1R/oPCdy45I8zBX+ctUr9a0mR0u71wSq/krNvPDaORcJJ
         S6Ag==
X-Forwarded-Encrypted: i=1; AJvYcCWPr93w+BeK8XNb2i4fDDaRa7euB7y+AX0SsslCqA4Zr22FjiJuhiDHE9+38usLvITXaPSPaD8Ayw==@kvack.org
X-Gm-Message-State: AOJu0YzQb8bjBlxMuTYvNLPwzvjR5cHd40+QLnw3bClcG6zivA9UUWlN
	tr1gRogWHeU9ls8QmTBmtW7/xpMCB32kcPM5xm+2ARsdmZu42H80+d6uVQQugZIa2273GAzB0Xq
	prmfxwmiLCXKgXlUbmNXA8t1yutQFxz7bCs27wrGe
X-Gm-Gg: ASbGnctLm1egnkp9DmqWWfoaWEmrPiHWiLNhE8K4WHmczuXUwoBxPhztIBr6GiReO1l
	aDJovS/SuD1Phek2abHfJp16XmdrCu5+61RQzcxy0kgG153cIYzhbKDiu6i9KGdvuOxLyonJN0W
	s2x5leAu+0v6ROcb9UTSatDxKXMR8b/k9iLcSNJQXhD5eCkbAD9x3/4iDdlQZFjiUnzNxkmA6/j
	XIVUrnbIqQ3CfTX+3w0N1uX+8ma+gi1hJo7jqRP4xnIHsjB1p+20LVXBQXpXKOR+aRqiV6J
X-Google-Smtp-Source: AGHT+IH62QYhk35Txtwjq8wG4yoHmmEcWYWzEQbTmojseIFIMUQkGoEz9EwWkrQ1f3vaMo197ym1x6UPl87mPLZvaek=
X-Received: by 2002:a05:6820:810c:b0:656:b1fb:a8fd with SMTP id
 006d021491bc7-65790a01bcamr2297931eaf.1.1763867240773; Sat, 22 Nov 2025
 19:07:20 -0800 (PST)
MIME-Version: 1.0
References: <ts32xzxrpxmwf3okxo4bu2ynbgnfe6mehf5h6eibp7dp3r6jp7@4f7oz6tzqwxn>
 <tencent_865DD78A73BC3C9CAFCBAEBE222B6EA5F107@qq.com> <buckmtxvdfnpgo56owip3fjqbzraws2wvtomzfkywhczckoqlt@fifgyl5fjpbt>
 <8c596737-95c1-4274-9834-1fe06558b431@linux.alibaba.com> <kvgy5ms2xlkcjuzuq7xx5lmjwx3frguosve7sqbp6wh3gpih5k@kjuwfbdd2cqz>
 <853796e3-fd44-4fc2-8fd2-5810342a6ebe@linux.alibaba.com> <ztqfbzq7fwa5znw5ur45qlbnupgepaptzjaw2izsftbtth6zca@db4ruyaulqab>
 <2c6906d1-132e-401f-830f-ae771fe836c5@linux.alibaba.com> <nx6o4gwpetxjeyfbu4xyibulvldr3xz6lyfjrar62cidy5gxum@xmx4ojyq3mbf>
 <d3c01e18-c556-4892-8283-08765c5e6cb9@linux.alibaba.com>
In-Reply-To: <d3c01e18-c556-4892-8283-08765c5e6cb9@linux.alibaba.com>
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Date: Sun, 23 Nov 2025 12:07:07 +0900
X-Gm-Features: AWmQ_blq4QB7hzrQX0d_c8FRyWq2ZibR4R0HIRRZtgGYhIyEzvf0zhw6MG5c5MQ
Message-ID: <CA+_sParXyhzdDdWscTF-cqYzTkjwRtvs68B4C+ZWX9xcSS8uRQ@mail.gmail.com>
Subject: Re: [RFC PATCHv5 0/6] zram: introduce writeback bio batching
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Yuwen Chen <ywen.chen@foxmail.com>, akpm@linux-foundation.org, 
	Brian Geffon <bgeffon@google.com>, Fengyu Lian <licayy@outlook.com>, 
	linux-block <linux-block@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, 
	Minchan Kim <minchan@kernel.org>, Richard Chang <richardycc@google.com>
Content-Type: multipart/alternative; boundary="0000000000005148ca06443a58ef"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C956540011
X-Stat-Signature: saym184cobcg9y584aq3uwn7gopijg6u
X-HE-Tag: 1763867241-771230
X-HE-Meta: U2FsdGVkX1/i15gwLuXe5ZW6EgPC+m/NXayv1aPQ1Eh1ygKZe63n3NinrFdO19okVFZyq2OyHXiXPW3VjlksPvhNK2Ir86m0+TfTjdyqGGto8kqBi7SQRuebdtzyirKRC6AWY/Ww8Jgh6N2nRsaPCpwFqJMvdcfZ36TSn6mN+fFJZgw9+WZxFh2TjQaN6vN1HHGc+enKqTdD+Gw5cV6hlGiFpHVlFSIUyNhN2FGhSkrXil6zGxhdY+Idz79VAkH2R/ywME83BBtoExu1aCo0rb1EDmW6NIxnYqNzuOHB6Ru4FicNl7qgEHwJ/4XM7o7xIhlRBWZvPviyyKzfaFcz93ExWhC4XvnGxOYTmRHkWrJWVsOaPekzd7PjjdcOqbVjXV5raZoQaEXV7im7Js2dUv5TMWZn+sEdtI29Jlya7sF7rJ9+vPoQMlLRXo35KMJt3/uWRdZyljyhy9OGqN8b8DFtC4Hxvz2gf38VBbttyOkyjnzKWrQOA4ArNWFK+1qBinW3jvAkeABPl6lp8VoVlr3NhWXd1dBQbxF2m9px5bbxs9YvfQpvUpvVCIUGONe1X2VaTGfrRFr9DScVteEs/u7Sujfsf1LYALfn/w8u+R5xcnOvtwnfBozw3cu4MVXFB5y/oHwHs6AoGvRrC/QoLXD6XV70LX1qbCaUu/139ofJkg1wpEBFxudDFX5G/iYCkPVbPItGZn3gflfOTcUo6VGCRNgtDoOvQjHj5K/A8+y++S4wZk+CA366efdxqlYS8fQZsYvx9Y4TyeMMM/a8ZBZY34DuGXi3yJs5uiY0SSoeg3h0QWeKgK3Cq6XqXFAVGn3TmuWFwU4TOu26DiU6/ENCO/FNY94YYF4n7VWZFbuYJlNobXkXUoqoEDsloQWwL8CdMX98Cnz1QQaBdsam8Z4sR7JaMWTWMREYSm3nCWZydIBouwMFZn0Siy5btp8Cx4Ul471wANw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000005148ca06443a58ef
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 23 Nov 2025, 10:23=E2=80=AFam Gao Xiang, <hsiangkao@linux.alibaba.c=
om>
wrote:

>
> I won't reply this anymore, good luck.


Cheers.

>

--0000000000005148ca06443a58ef
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div><div class=3D"gmail_quote gmail_quote_container"><di=
v dir=3D"ltr" class=3D"gmail_attr">On Sun, 23 Nov 2025, 10:23=E2=80=AFam Ga=
o Xiang, &lt;<a href=3D"mailto:hsiangkao@linux.alibaba.com">hsiangkao@linux=
.alibaba.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);paddin=
g-left:1ex"><br>
I won&#39;t reply this anymore, good luck.</blockquote></div></div><div dir=
=3D"auto"><br></div><div dir=3D"auto">Cheers.</div><div dir=3D"auto"></div>=
<div dir=3D"auto"></div><div dir=3D"auto"><div class=3D"gmail_quote gmail_q=
uote_container"><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0=
px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">
</blockquote></div></div></div>

--0000000000005148ca06443a58ef--

