Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFB0ECCA490
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 01:17:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C75456B0099; Sun, 18 Oct 2026 21:16:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C25F06B009D; Sun, 18 Oct 2026 21:16:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B14FE6B009F; Sun, 18 Oct 2026 21:16:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 82C4F6B0099
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:16:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ED3FC805D7
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:16:58 +0000 (UTC)
X-FDA: 85337611716.30.1EB5C7A
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1624540002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:16:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OgpU9P35;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of samarth.colleges@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=samarth.colleges@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792372617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MbuYquEC73fu46Z70aussYis/c1Xk/EjCDYarx2LiM4=;
	b=BjM3MnSXrxapKjeMKReDA/kKR4PCnSlt2178c64CCmGqcP50pvBcbF1vj7AgA5qzT6Iaak
	2lne4RnvZLVkprsuyi9C1i3gcoXPrWCWFcBfpccgxVxjG0ZJl+g4gKxTb2JSGl/xr++NVe
	DI9DbJ7uUHCoqKYyMZhqpKEUDuvMisc=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OgpU9P35;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of samarth.colleges@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=samarth.colleges@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792372617;
	b=5VFm57NC+iW/PWWUmaglaPvwzHh1NffCpHY1FPIr2PTIktqHIDa2wOkgUJ7WbtkGrAW0Ew
	qlkDRl2eP+lcjdFq3kHuX66NrFUvtzTTRbDGpiYK9qTtCK43dwhVSi2f0Zf4g6XeXJpQHV
	Tmnv3lA+7SCs1LxYg3LFPRRW8S9v0wY=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6afafc89b48so2297516a12.2
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 18:16:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792372615; cv=none;
        d=google.com; s=arc-20260327;
        b=QR7o1c+kAdWPyoE4mDxTm8ee9i1VjC7y6pevoouOH/vB40Y8dmpWjm3BnypHyeQnAF
         8mgx1JQlRX2tOR9SPbmKfpBEdkAz4vRlxKMY+Bkjm03YT7/7zuLqjj1u8U3pT+Vq9vjC
         LpkTAL4fbyxle7jpLv/wkcnXjhheInqmlETTveTjceIEI67AIalCVsNtBHwfAWFVCysP
         9J08DYh7W9WMkwT+evE1aK5OMLeHAEpon9cbwV9glEDSOCDfyEx405t5N/kNXva5XvI1
         +KEnJnM2Z54Z9ICWVXsn3Vte/+Xd+S12K7AO7YvAQ9roI0MFnQdBkxmuVMMwFrKahytp
         I3HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=MbuYquEC73fu46Z70aussYis/c1Xk/EjCDYarx2LiM4=;
        fh=9jUMN9AGz9bo/s7laz8E1evauhdxdc1bJxosJp/1b1A=;
        b=D/UWkX1e+3vOu1xx5Oe34tam7+5FuSI6WNN9yjtFYWvCzayeEWjnu1T8NMdVZ7ZdyB
         MJp0kVL4SNMx2SpeZg6JNM8+xTl8xhkE/VRLee9IAXQV6tPoOPZZLZlQem9g6fTitRwl
         ac4tvLFnw93WRY8nlGhTjcKqkppPYKwOkLZ4NF78jc6byXQ2MRVVVZSeoVceC5i2p5Yh
         BflCdUbt6X/pupXKtcAlKqJqWMD0bgQUtjvhaLimnLumnUUaxD8mFpoYWr/DZsf6s2LC
         gjoEuA31EtzsMZ23hXo44Haje+8pKEUkUTFvL/wUO8gtHVB+/9EgxzeUlw8E9SxUUmBw
         q27Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792372615; x=1792977415; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MbuYquEC73fu46Z70aussYis/c1Xk/EjCDYarx2LiM4=;
        b=OgpU9P35nPlCl4Jw4JZ6GEsVX6dxD6mEA1ku5a3AECyb30yqPuQzePR8blc9nQgrvS
         jMCPOA0NPL94O6EP/pAXbvAxFk/rmboMrk6Es8yYzhPoARFz/ZjEAZIhA8rOM7Xr+tv2
         14Y83dq3PSECBXmO0/vW+wJL8RpYjU0KJG4g4k6AgxTcEWOOPr+RJWg+iZGMQ7UBeSct
         ohmH4yLrb8wHim8cNf+G6wzHk88LXD98fHamevSpiIMVOmVB28U3ob6jv5RM6GIrSjdq
         6uLyC5OdYv7ibEgz/fdwunL8lXfbaBq7t8Hn8+20iwb3kBt4u0JreHFGPtQ7L71rO5W+
         uKbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792372615; x=1792977415;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=MbuYquEC73fu46Z70aussYis/c1Xk/EjCDYarx2LiM4=;
        b=mOO+wOW44haglQLqcMQvejtcGefzxrBqnK9VEmjiexr8Ke84fJa/gmx8/DKZ2uEXFe
         8bMHNkVqdXCNaVxlZeA06iG/COFuVmN+eXI8Nma1Ojm4eBSe952+F90BZEANUgG2LwJ8
         M2w53DxRdWTwjSwx5JmCH2S4ZwrzwhiDFB1qz0/u1RtTCKYe33tVkercSdHeeb2BR09u
         J/lr/A/GRAbwMTACI28bejUapPidx8Xpxt8H3EMVA16Z/Ao0/EZlVq+anfFTRH8cwDUF
         4YsGdwp+TQSkoFvjDfkARI8PzUKNdnyWDircAPHpXs5XQtB52X/rOgEpwKCkDrATf5TE
         /MMw==
X-Forwarded-Encrypted: i=1; AKwUvBwJ/4vDasUirQZ93dqZg55ZmXC9HtM/1XHp2rK0RGI+RDq5VTt/QTJZ9KFh97J6XbBHTcF2g0M8Nw==@kvack.org
X-Gm-Message-State: AFq9FYLBMZlUzlQFvn32gxfXRJ1p03Gd6+VgSghX6O9KAdzmQpPQrpcN
	31WmuMeXHIXI33Cd4167TrS90hXxwoOGEVWM7um6rEVoCqoCgLh0OHrGQ9hY5X7SaAnB61IiQXo
	1GSYGf1KBTzpvmhfGLJHmnEa2VGxd24A=
X-Gm-Gg: AYBFou12RXJ05Xp1+XECVrY+Pwa3YKnnEUA5nU3bh6COyHLzt6aRl595itI2xiavJ18
	T/3yy1UmZq+MDHU4aupIIL/nREOKnNX9wmN+wX+6gWbg/DQLnxGBhpV3p59wSJ2ezAIsx2rk4YY
	znKvoTW/N5QTeSX3eybtvFIpgzlH3X0lw6x6ZrYfHvGoc67D5Vupk1cJXdK4b0J60T+3S09jHCw
	aBrKVofFUeyStDaYx0vd/hQL3gJS9W5jXe96d9KogKTKwretDLioafpitGSRI+CkfaeAJjE4guv
	6KTDsW6qqSKkbtAl15clABH84/PBa/wpp6OMmkAXYDOczRpSI+8qjFS58Mm8rS3FZOqcN3JtXER
	/KhjfrCb+wPE=
X-Received: by 2002:a05:6402:5c8:b0:6aa:e263:51c with SMTP id
 4fb4d7f45d1cf-6b3a8159b56mr3313615a12.16.1792372615304; Sun, 18 Oct 2026
 18:16:55 -0700 (PDT)
MIME-Version: 1.0
References: <20261018122957.526467-1-samarth.colleges@gmail.com> <20261019010224.69153-1-lance.yang@linux.dev>
In-Reply-To: <20261019010224.69153-1-lance.yang@linux.dev>
From: Samarth Narang <samarth.colleges@gmail.com>
Date: Sun, 18 Oct 2026 21:16:44 -0400
X-Gm-Features: AclHuK9ZHhuGEHPAshewk5omXgKckqt-pQenU7TKa9MdL0JakSVGHI_1mTWY0sE
Message-ID: <CAAbz3fTArEOXC7udRQDdGz77faMnmpXdZT2q_zVZmbhapwn_3g@mail.gmail.com>
Subject: Re: [PATCH] mm/ksm: keep soft-dirty and uffd-wp when merging a page
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, xu.xin@linux.dev, 
	chengming.zhou@linux.dev, peterx@redhat.com, kas@kernel.org, rppt@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: multipart/alternative; boundary="0000000000000a5a2d065e2745c5"
X-Stat-Signature: r4tssxk8kx8b9omhm3gxnuhx4z3hcdnp
X-Rspamd-Queue-Id: 1624540002
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1792372616-839033
X-HE-Meta: U2FsdGVkX1/xnBXmxPHa2cWzvcJIh1ZOQEOdaN61XWC2DkXZjNqrfcOTzoubVFHwQriE5A79y2VgzLFhu9mqzDb6OSlBlbtu4hMPMTskq0/XhDqfo1FrmMi9NY8Roiil0PGrOuf1m8dMn094H8mq90q0AZfNxqetqJPplh+r4mAuM08A3KjVSMwfg9d29CeeHdoTK+ed+0Iq0XJio6unRyZQNu+gFS5E2TgDCqvfAg4T2iPP+T/uw3W8dxHy4pJj8ymZqu2zvSTKD6vpZl8AIr2lMoeyOasWUwrCaYpmvEkStMoKulopsD4KQ/fxm27aqa+lV2UUdjVWgN9f7tUFGH7kMB70s5szZmaU91uFz92rwaqLcGUHNUn4UExn34rGaIx6nTX/yL7P6V2AHzjqSjBFO7G2VxT6Ii/NHMNg08GoItXyPWinv4nB/xd0Ics18KlU8CRvvGHHN4Ez09qc8HusZu9rAP9b2FzXHvkbURg2r04iUx61nnmNYxqUmAUNuI0uYJPeBOaolJ9RbuXUg3Yb1jzNB5DY1cAJhizSFCHBe/Ej7ftpzZ5lyyiJnkc8Lkbh4IFq1WfO1hPcqwypIoSf8VcvNlmfM/MRKOL/tVqijYlE0O0vGHntG0bqmyW0yaVzDVlafp2JY5K2XsFPKLSN3BwgWgsOQmlBL2A2TjkMTh6OnLUYLvpFn49Q1V908uvVfDnRgFJ69SVS67KCyvy/pdxzNlX2+HIgj1SWO+rS9g5KU+skwMNPjdOtSbfPVkPu+3LQyfUqJc8WoabMbBX1hAr5dP4O6uOGem0nYBlLg8i28aOJ3wjkA5jNHEai00wAypdEKk5t/KdZt4bZqno9dpkPrLobYELpp1Qkx/tkLeCulX/mXG0nSITzoavcuJyo8TGREILULu6jjpoLcvc0c7a2V+CCUY4bbJCpbT5xbo953MCqJU4kXzpoiYCuz+GJurFdq9vyONcI5cW
 gTJTnGhY
 99QpuNqxqRM2X4567mjrT2rnm3hXatkMuhGa0Kp2+Texf6q0LG1NYDmGw6IVojQNNZER1RFxb9gBDFSaqeqiTQd5HP/rt3762U7MK4Fld6zxHMSLNM5TqXYXApzIUs6rfmxm7mb06qznleOQLyAxMdd3JsEalvTj5YTQ1Be2mNvVNNKJyq8AedSOdPg18Hywxm+vmiVIz6D183fhEb6bgqoHmnKO+glNsxO9Co7TROFHj/OyKluZwmmrxk0bSegTKSPgvpm572aGsnHQx/9oKv6kBVNqf1W/A7/iS++45ThqjtZkqqtDBLAzfCjyLPw4t10v63ZFHk5oka++bTipOZhBR6lwUdPjlafbODAteaqUH2yLQj+q2ka0g/4O+qSndEYhk8Lm4w/uJHXdYHnplcQQHEOvkYa/9qhiibbZTxlFxUpJI0+Ui8eyhtnImpsJnFA5UnvizH53QHwhpwJ47SUXFgCOQVngOBkl3wpMQDOhkYNbZsnt2WxrQvd+7uuh7emxZlZ4187gSy5WAZNaXI7OLObiHT9D8e5tWckX8qWyrdW0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000000a5a2d065e2745c5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 18, 2026 at 9:02=E2=80=AFPM Lance Yang <lance.yang@linux.dev> w=
rote:
> Shouldn't we use these two instead?
>
> Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to
userfaultfd ioctl")
> Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose
UFFDIO_REGISTER_MODE_RWP")

Thanks for reviewing, and the comments/fixes make sense. Sent out a v2
<https://lore.kernel.org/all/20261019010934.697895-1-samarth.colleges@gmail=
.com/>
 patch.

Best,
Samarth

--0000000000000a5a2d065e2745c5
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br>On Sun, Oct 18, 2026 at 9:02=E2=80=AFPM Lance Yang &lt=
;<a href=3D"mailto:lance.yang@linux.dev">lance.yang@linux.dev</a>&gt; wrote=
:<br>&gt; Shouldn&#39;t we use these two instead?<br>&gt;<br>&gt; Fixes: 63=
b2d4174c4a (&quot;userfaultfd: wp: add the writeprotect API to userfaultfd =
ioctl&quot;)<br>&gt; Fixes: 2d427bb01639 (&quot;mm/userfaultfd: add RWP fau=
lt delivery and expose UFFDIO_REGISTER_MODE_RWP&quot;)<br><br>Thanks for re=
viewing, and the comments/fixes make sense. Sent out a=C2=A0<a href=3D"http=
s://lore.kernel.org/all/20261019010934.697895-1-samarth.colleges@gmail.com/=
">v2</a>=C2=A0patch.=C2=A0<div><br></div><div>Best,</div><div>Samarth=C2=A0=
<br><div><div><br></div><div><br></div></div></div></div>

--0000000000000a5a2d065e2745c5--

