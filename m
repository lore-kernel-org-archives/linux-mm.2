Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0DBDD277CE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 03:47:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDC266B0088; Fri,  9 Jan 2026 22:47:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E928F6B0089; Fri,  9 Jan 2026 22:47:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBB916B008A; Fri,  9 Jan 2026 22:47:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C9D7D6B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 22:47:38 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 68DF3BEC57
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 03:47:38 +0000 (UTC)
X-FDA: 84314669796.06.E01E5F2
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8BCD4A0005
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 03:47:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YFBgcLar;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768016856; a=rsa-sha256;
	cv=none;
	b=TxFVzskMIGxsFcUt9Pi7QIyodvgxcnSQu3HL6Resai+sT6Soe/Sw8dtHV11jvVwjIgKftp
	FnKrcLeeZ3chPYSD+aQNxG0X0GNUv7knkzvVGKOq7K2XfCj5kgfPuTLcNpGVPRGmDhiAbM
	JL9nSVoYbtSml0DoGd18RbyNzKRfBu8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YFBgcLar;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768016856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AnhmeVyJEO3jTJeUnrIAC1snCzGO0yrfi4KApdK0DYg=;
	b=ELv5uXH2IFmD2qfQK8fWwkiByG2M5Vw8bHQZkO8KBDs0INKM71KETavkr47v1KV4F6Xs5F
	WH1qGymHQKCo8TWVUxMTZ0XpoZxumH6YzQsir2XVLJp8sTwydPdn50OqZKIMku4gyC//Fw
	6IKK4lpQF7rK8MSuOdmiTWwn2dx3rfM=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-88a37cb5afdso42799206d6.0
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 19:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768016855; x=1768621655; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AnhmeVyJEO3jTJeUnrIAC1snCzGO0yrfi4KApdK0DYg=;
        b=YFBgcLarg+YGylZ93S1HDhN9cDpB2IWiqzhKdrjxJdnXB0KApvvewV+BczwiRt2Kwk
         dSqI9rUbaPnefAdTZDT4FlUi7fqKikKzkQkPXxM7wx8bFDjF95wkBaW0VRfHRBLGbsdv
         LOIPTuvYreGs5mHSz1FoQUKkmuxt6qM8bX/5jRfrm+wwRbAJ5bey7WhCwHluFw5V6QCa
         gqQdFino7YYbmcYG3tZ/2ThkWRDFQBbJUd/rMvHc+76m4fM70j08HYI3qzX8ZhSA2c4s
         pZoFCTCMbMtafXc6Rq5zEIg77M/WW+dOFa0YEFeXc51lOCr+Plr3LSCM672ahHJxKy4K
         xkwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768016855; x=1768621655;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AnhmeVyJEO3jTJeUnrIAC1snCzGO0yrfi4KApdK0DYg=;
        b=LBLtkxgpwt6SOGUOuqfM9Q+gglJL7HfArzCYbIuWRdl/CLMZK5sLmk4RzGOmU315vl
         iNBO8bycGAgPvfUPMuZwesk1ovoYIe7i/fSzuOvMCof3gm/RVy7V3Fd7iojPC8bi3Drm
         iw4cxBYFGBEKIhGhOb8fWCThahoVbje81skAZqLRxa8G5YIL23QhsvRZNBg36A55+Jdy
         PQn7kp37eQXeYpLTgmHSgncjetsIfCaw3mtKKEX6NxixslrueBYObxllPndJ6rzy8deI
         2xKp5sweFR6F136r8Phyi2OK6URvZ9mCCDNUbr6TwsFTKQh6DodFVLrp7zsJa8VKMS/w
         jfaw==
X-Forwarded-Encrypted: i=1; AJvYcCU8gwtTkX4srijQ7zhz1Ow4nJgi1d9WEth50cGcP5Y6N9Mvm8mSHAFa6r8K1dde4rIuGsQaVPuNSw==@kvack.org
X-Gm-Message-State: AOJu0YxH42xFym6XT4HRNaFzEpTpVmeRxcBv/zjSoKdY4nyPSRXDJWAs
	/vxVgx8Sivv7XJUy0b3kr4zWUuxGNnJdeqGONKyYdHGrLhdc8Eo/32bTd5UmbQ1hbS3uiZEwLKZ
	uGPMkIEzHWvo0WZeEpumtDozxcH2xGDM=
X-Gm-Gg: AY/fxX4tHqbSE7fP58Ml96UcPDsu5nsmtBAjn9Esmq7D6perZ4+ZFYxvW9PDO3iJxdD
	Ege0rBewMACwn9tEGns4NKIl32qsz7IKk2LEtjPxL9g/5dxDeB2HjUt/xK23YGN0AJxl0Kj4WWo
	pSFSBkUkijk0KUTJGPiBva2w3E2tpK2oM5x4SvJOXXUoBZXtq6WElFalsi7Epd5Fa05OaQwne81
	15bsiUNaHA4JBlJusvRN3JJZ9gIQRyx1/wWrezW77Qq4bPdAyAcuZC+2msvNhjR7TqCRvdmppoD
	0c7AP8eM2HNL3o8aOZnCA8U=
X-Google-Smtp-Source: AGHT+IHDD1bDtbiDilddrvwoiudcMJs16uFjR+L1wKNN1BewBSLw5FdomEQhwTNOHfkVtMMdFR85t+kBvMJ8rtFh3Fs=
X-Received: by 2002:a05:6214:80f:b0:890:7f85:81d1 with SMTP id
 6a1803df08f44-8907f858293mr162757706d6.13.1768016855637; Fri, 09 Jan 2026
 19:47:35 -0800 (PST)
MIME-Version: 1.0
References: <20260108101535.50696-1-akinobu.mita@gmail.com>
 <20260108101535.50696-2-akinobu.mita@gmail.com> <20260108154738.00000e47@huawei.com>
In-Reply-To: <20260108154738.00000e47@huawei.com>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Sat, 10 Jan 2026 12:47:24 +0900
X-Gm-Features: AZwV_QhOcBPU4vb7ub0Bi4ys4AL1T23koUjpp82dgsgXLynGVT42jcEOxUlrmCM
Message-ID: <CAC5umyiwO=b91=A0zAJ=p9uryW1po9D3FoMhfidVjX3yjm=GpQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] mm: memory-tiers, numa_emu: enable to create
 memory tiers using fake numa nodes
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, akpm@linux-foundation.org, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, 
	rppt@kernel.org, surenb@google.com, bingjiao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: uqgtydan4owei9yt1i4ks476r7gbd4ye
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8BCD4A0005
X-HE-Tag: 1768016856-998370
X-HE-Meta: U2FsdGVkX18WiR9btR9Ud1Vb3Qgjqbo90pqv1xnuoBLrDETHxF1hdHakYE5RjWGCNgoUWdKU2naHGAtctFOFKflEy8YyGvgqT8Yokta2k91sq+4JMAtc1oSdBIds2PJt1icUp3qvAv2WI6xGFyALGm6yT0EhRUCtnhWEEfxWDo4UP1bSycQz6Jm5kFpQff8qDC8waRN9gf5N/HFt/8JRAQ24GfazVHcWWbMcXcgl6yl2Uc66mjO4RbhoI0B5TwkHBXvHgxM/l0FxJoQ5nnWKPxCbJxa/dq3DTkntnnaRB+iVLJ3C6Qp4w6dm4PXlJ0zXnpxY0vr0KFvgaR5FnFR8hsk7TpAw/YTX0pr4gMjYnhi56rzP+XTmjuMgXFeE1ToBhwLaqB15qVFUZFwxCZM4CBcWj8Y3UkT+OSUZoMcS6zrKNJSXwEDFX1dAAlvW7qHph9cWcsoILoJgOmdHW0HMK0Vt5t4BEJBqzUdQzfgcA5ebsvlG9PjIgnT9UufhkowKFN0s6/bjZUrerqt9Z5pDMD/cBC965SvN9Kx4oW0QVa2nBLUXgbygx9YbEeod0eNrEJY7LEWAbXiCKbtmXVLHxciOwzD0uVU1GdXp4VW9F4y1sREFA/J9rwhT4CHxARqRXNZxkkEqOCkxa9irywXipAXp6eeskp2W84vmaFHp4hBJ/wDyY/xB4+kFA2fDS7F3lXMiUMFrexGqmWQk6fEFR4mnuJLSL4zYZ9vU2XzApdQ+58mKoX+yTMuKAyBTmPDyyHJVyPDnU36u7kdLbzG1HGLGcMhnbQAauNR0pJSEMtgG1SoL7v72azqj6pfdgO8VlLA/U/vKfwQI8ytoDp14ZvvxJbQRySmau04AbfCXz3A+d/oRAxB716zgLPYgqNAzSuyJnc9okdmgsQWd/G0b7eDTGpIj4IR1b3jSLEcazldgHSJMfA5rYeOxwUjHDSKG0mPrKar+/lNgFteaP3s
 sGRECeph
 yy5uqiZiyeC4Zslx99tmtY3NrRx2sz+LsNHHpkg8BxLC03/0zb0hJ/J3MA2pIR/qxkjkzai1ZeUPeun56LfxUU6ljsAH2WAE5Ia9cc81Kl4DETmbafjcVjNRRIpfpIZAvC6wkUA1VXgcGQHTaTduG8myR1w0qM4v319fNIG0zCrtAtop7yFSto+xexx5T5GHqIh6UhPhUZhU71xRRtTqUX/jcMe9CNLxzbDfqJ0Z0l+LUdKtegf9tQ9NoFB+YmjzjWc+iEY9mSTW4tneCCATh4PkALHF6avFfnKPcnAr+ZF+JUphMleWW4WJ42NvxVyr7Cf9VeRUl6lkefyLBUxZt421laR2BlcTyZ7sVycD0GgbqKV0QVWcolYRo/b6CsFvoUeX1P2jHFVZ2kQQ+7l53BeFOcvCWp3ecENt9W8fYZmssltFJFz4mRC8aGyQgntWOLN5paZGuXckIXBuaeZhMGIbBECJzrlyRv/rJCIg/Vorco8A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2026=E5=B9=B41=E6=9C=889=E6=97=A5(=E9=87=91) 0:47 Jonathan Cameron <jonatha=
n.cameron@huawei.com>:
>
> On Thu,  8 Jan 2026 19:15:33 +0900
> Akinobu Mita <akinobu.mita@gmail.com> wrote:
>
> > This makes it possible to create memory tiers using fake numa nodes
> > generated by numa emulation.
> >
> > The "numa_emulation.adistance=3D" kernel cmdline option allows you to s=
et
> > the abstract distance for each NUMA node.
> >
> > For example, you can create two fake nodes, each in a different memory
> > tier by booting with "numa=3Dfake=3D2 numa_emulation.adistance=3D576,70=
4".
> > Here, the abstract distances of node0 and node1 are set to 576 and 706,
> > respectively.
> >
> > Each memory tier covers an abstract distance chunk size of 128. Thus,
> > nodes with abstract distances between 512 and 639 are classified into t=
he
> > same memory tier, and nodes with abstract distances between 640 and 767
> > are classified into the next slower memory tier.
> >
> > The abstract distance of fake nodes not specified in the parameter will
> > be the default DRAM abstract distance of 576.
> >
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > ---
> > v2:
> > - fix the explanation about cmdline parameter in the commit log
> A couple of comments on includes, with those resolved LGTM.
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>
> >
> >  mm/numa_emulation.c | 26 ++++++++++++++++++++++++++
> >  1 file changed, 26 insertions(+)
> >
> > diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
> > index 703c8fa05048..a4266da21344 100644
> > --- a/mm/numa_emulation.c
> > +++ b/mm/numa_emulation.c
> > @@ -6,6 +6,9 @@
> >  #include <linux/errno.h>
> >  #include <linux/topology.h>
> >  #include <linux/memblock.h>
> > +#include <linux/memory-tiers.h>
> > +#include <linux/module.h>
> > +#include <linux/node.h>
>
> I can't immediately spot why the new code needs node.h

The first version used the access_coordinate struct, but that is no longer
used, so including linux/node.h is no longer necessary.

>
> Should also include
> linux/notifier.h for the notifier_block definition.

I will fix these includes in the next version.

