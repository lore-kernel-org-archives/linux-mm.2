Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9B0CFD8FCE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 15:52:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A570B6B00CC; Thu, 26 Feb 2026 10:52:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A05166B00CD; Thu, 26 Feb 2026 10:52:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9078E6B00CE; Thu, 26 Feb 2026 10:52:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7E3306B00CC
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:52:34 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2DE1E160250
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:52:34 +0000 (UTC)
X-FDA: 84487050228.19.2F4FF2F
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id 299278000D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:52:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qNfMfOiX;
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sh/hn2/iL46NYszCpm22ljZKRCxJTNgO56UrCgcMsY0=;
	b=e2Q19SJ5lrN+tIbD8GO4Z4GS3RXnzTU+7Z+8GVIYJTmgStXKj8ZJTJcdfo5iR3O5sMzFJL
	frhV42gWS1DwrHLqridzzEwLIVrJHmORjl+s04L4+IemXispDO6ae0EaxEenADWBhzjWHs
	Zi/N/KRuto/vF1Ro8cY9EjmRYNvdPEM=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qNfMfOiX;
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772121152; a=rsa-sha256;
	cv=pass;
	b=N6+pQobQuW1anMsrW3rzv+uCnjITifZv1/cl7CA4sVwdHDQnL7G+zumOiSEkbcS1hzJ1y4
	It4T9P1JissQ2qBbHYkrL2Vyi32xWcb9rFRyPwOqLS1vYe4PMbYkoy6cal2BAhgYhFPND3
	B066zt0u/lE6AWQFQicmg85yrH8Ipmw=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5033b64256dso662071cf.0
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:52:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772121151; cv=none;
        d=google.com; s=arc-20240605;
        b=K6CqHgGgVjyl7Psnsd8rhq5ZKsHuTCEhV+e5Py/w3rweXvMwODHEteHJ5wtZ0N7CFd
         W0nYbihTIyDLr6thaHXT8YYlg5R3NtEfV3xsVp3/pYt2nHfd3Ep0fvtW3rb6Zu+CqqrQ
         Us2qnQCg0bodB/BLOKpJzLAPDgYWRfuiMHi2zhR/CobgY0zPCGgzAlAUeo183Wrp8ewJ
         dAm4rJ+2teT8eOxXPHEa+uN69/ctQi2i/vDL7c4CZfSOnixDdXCidPKUBEMlWsp/6q4J
         Vsb1YnUCuqILhdLG9GtbtmMxuF36x9qLIKw4mOBIrURO3vCcC+l8hmXXqF9xNfizlasH
         t3wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Sh/hn2/iL46NYszCpm22ljZKRCxJTNgO56UrCgcMsY0=;
        fh=yfdh2m02QyoyxlYOkLApWop5AdkefESr3dkSLwceAzg=;
        b=ETi/hzRbGQLctaFBFoMGU9lBZ1YX2vNVayEEXK77KQY2kX9W8L7mQlzVQ290vPgEW3
         EYeTwOb6nHwOAo5SSQRmMROSxAsPksy7p+AkuSD6krl4zVv1Hfm7q5T87V1yWv1KfVzs
         lQcegZQkMklUCY/NWRKT0vR8jdFXQzXqkgFvNpqHxdvPBKeT0ZzL7k9Girfw0Y+1XNcN
         DaBBYicPTYEgHHsxN+A/zWQvw3ZjY70eU2515A8CQA1tMZqhRU5ftXqxcr+sBYbspUYT
         LpVdCO6iVVSc6brFuFsXkFrcSTHt7i9mQIP7rgrg9S1QErmbdrx0XliDztCh7aVIrsH1
         cLPw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772121151; x=1772725951; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sh/hn2/iL46NYszCpm22ljZKRCxJTNgO56UrCgcMsY0=;
        b=qNfMfOiXnhVuqoeFsPyxcuxH9Xp2pV7NzOJEQApIAv9g5CRCKVAbweb+c/hz5C+kBc
         Q8ExrlvQRKO2ONr8idxxQjPXEuNhmoA1LhKJnmv/959Y8cPw/laGMG1psTKhWvOhImWD
         3hBCelZk8/+SJv8eUzZLxxPK3sNA9P2BGHltvGuSQBs6JFyywR6WYKRFs69bxo+Q82ia
         Q94DtAehDsxkbmev7v8Yxt2ZLebP9NtuRsgwKyCOUrqpAMdoA5o6Uvn0b77wnNaZjaFf
         dQJaVHHlvgTrHiHH5k7WtrvELuuFoAP+n8pvp7LjBzxPRD3ZADH2lixHTFFasutkN2wy
         Sckg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772121151; x=1772725951;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Sh/hn2/iL46NYszCpm22ljZKRCxJTNgO56UrCgcMsY0=;
        b=BO5iraB/tvUffmK1FppADKQHEI0N05Zd6Cy2Bg57Vi4IFJctChGXJq08C1kIbkzFxU
         hu9u80YmXy/x1XL/FuOAXUPoaFLdQ1Ylp1iggRClKVg337x+7qBVCXY+dzP6VIJzeni/
         2edpRCmLbl/CAVY8Qepc5KHHncUVNutfvF+bvnUbtmBkD6uBBytCYuFHgw8NAkbENgTQ
         hI5K07VxsuKEg4xtzkwPRt5ub2/nrlkV4vLVJm+FFPqMw4XufkFHfEHS1oYq/2bc5yY2
         CqvMpGtT6oeA4foLY/1Vumkj3OmiIY1sMeXzp3c/bo2MmrTT30ZTeviw80i42i3uVuNu
         1aUA==
X-Forwarded-Encrypted: i=1; AJvYcCWmcFMQ+H1Rrr8Q0xar84GUCKRIYy3dFkZ/UnsJQi6fripN8WiHycEm9ehzX8bIzbjhovOpjf7EnA==@kvack.org
X-Gm-Message-State: AOJu0YzxVjovlwxLJhAONx62/wsGSd7enFf2f/AoYXECN8SPaNCcGGna
	lvYJdXfshGxb+vgA3Qg7qQPRtRNWG1Ggis2g8mxKVlDZLl5wtfaXb+dD+OrBW6ii8siyJc6TZUN
	4qeQzA2GSrJoQuBjpSUaClqalYL/2Jmk52giHfZGi
X-Gm-Gg: ATEYQzwAR/WIPBhoa7G9mcHSFkU74tnnNszQ3l4U6sUyROUw/UjtbTrCb1AfsPYf2OF
	RkXy0j0KqcAVI3CfLGpdjBjzWyyLp7YcqsFpkYaWwN+mX/t6A7+NUH80CiutD/4g0dEOm3iC2K1
	kjqaKil34iFmHedNSHFAol4t6z6OpkI9f0XV2juO8YWplYrQgtPK2FTgf4ihIiy/JdlLzI2lC5H
	VJRC0MorofriopG6Kq32vnLv7mAfEtE6QUdIHgf8RwJ+hVRJLlGGy06sQmPzIP9Q3xsqNEgx4Tr
	goTTxtlLv14SkmEO55+70SdLlGQC5O1CH2vmwA==
X-Received: by 2002:a05:622a:1446:b0:4ff:c0e7:be9c with SMTP id
 d75a77b69052e-5074408c122mr12450571cf.0.1772121150662; Thu, 26 Feb 2026
 07:52:30 -0800 (PST)
MIME-Version: 1.0
References: <20260225163407.2218712-1-surenb@google.com> <CAJuCfpH-+trdZ=68v0FTj_yKn6+gmE10gKjmjrTyPvO2EaXdRQ@mail.gmail.com>
 <3ab53191-5aac-4b9f-a019-303d837ec517@suse.com> <CAJuCfpEgB8bLMSXPG_K0uaOvALoC1OamKuRosv3Bb=ngiYJz6A@mail.gmail.com>
 <042fceca-f2ba-4656-87d0-89676cdd435c@kernel.org>
In-Reply-To: <042fceca-f2ba-4656-87d0-89676cdd435c@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 26 Feb 2026 07:52:19 -0800
X-Gm-Features: AaiRm500FoCy9J7LiqRs2AkALwoCGfYGLynsJG2FLqDBDweAlyLlk19ZSoiO-_M
Message-ID: <CAJuCfpG_nu+sx7BZsKqKR+iznDmoRaFtRrNYgzV+0iXeVDK4Nw@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] mm/slab: mark alloc tags empty for sheaves
 allocated with __GFP_NO_OBJ_EXT
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, harry.yoo@oracle.com, 
	00107082@163.com, cl@gentwo.org, rientjes@google.com, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 578ajnitmzez39tfjyckgokkwjs87gdo
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 299278000D
X-HE-Tag: 1772121152-376416
X-HE-Meta: U2FsdGVkX18bkYgabGJ/YP8N7PZxOIwo2i7FPuAXqZaIG/30C1cW805wgBKdFU+zdtYvjBYEEdMDTqAEIgl6Leu2cVM/z2/SSjya07pgJ/e+tCFRXB3feMljJzxX/PQg3CDSmosQizeESvF1TKyBbXIZvgvKcitKHlsgYdMBQeMEo5xhfvPADao1Z12Qiy0z4uH9e/bt+P+HRaM9yH4bHMM8MOZ1euzGGoHa29m3w1hC9e2za6npgT5h2vMsHKO1KKyjkK+R2r1xPLfW1PT0yJhnxcSnpCnNomSRlGKk5+F3YHqKjctzHcnyUAi2UItiUqUlbZf2WhSq1vRtym4RUbLAs48lUY6Z7ksNrdhxYbOMBHw1KlQ80+tmJG52DI7+HMhL9B8c2sIXbNiA8rK/2kDdeYEmm0/mY+ctcBWHIbPOeQdM8KPu63LiUSudwLtjQonk9eFlTiNpriVK/g2NKkGMr3kaICoX7EySlmT/MNfRvQiU+J4zAZJ4Ve4KntRik7nYIW5SwF8W/CHC/hsPBdQjJm32k9yn0Vwnmg+NdxzazkLVrXpj75IULpdTC/pYAQ4f80vmcokXWyZsb4a7qWkGyBLwFapbrDDywr1m0SKuhtBmk5ZORpF/m9iDQDS4ovMTkP0fq3ErdkslmPKoKhYG9O9FHdd8DhvnTsIZCiXf77ABhNkrefY351ljpE8bVEq3moTsBWfKrsA2dGcjYXUJwBr12v2i3fruYSGPr4+Xhyom+MQ1lVhJVMJfMUDgZ3hejJ5tKHIIC7kPmc7ah66WTtFOqILsOcddtjsTGgkSMB/cBufNqUlv1ZyXLZQYf+kYgdqqgEWsVgb5754J6dBUtvoVOg2WnW0gaj4RDrIOMgT061a479ITdBFe2xou43cutBaYHurKBdqX7u8rtXD+ok1p5qlDLTg1BGqH1862MUKt8x1L4iMGmduZVqlDfQ8Y6XJrvOudaVvXGzx
 ptqjUntG
 NG9zA2y43kaDD5sPLS93A+FPd0gyyNBzFgIGBxmy1sr8E2zsGaHcPx2aPlscHUGiG96Ko042ANdU3z5MMTEinsfPfIbY+88lgg4zaYDIgpJPkrvQrnUWKYdF+WY6rqEhzL2obJW794aI0CsYYqhj0xZeAJuESVYkDZ7IS4lErYhefhN4EvsZy6g/GL2QNfWxkLASJKuWirTN5eI8aerHbKVb4swp/NKLWpYBH0v8b3w6y/CsKseIgkt5tSGn1CTgGvJrrDlBpWwgaUCYsKCZVeAK73+/BSg2ytosWNvP5UbEqXB8S2qZ1vbLLBXj8h+zXRwZhkS0+JD73dElp+wu4EjfksY1o1aiAXvYSMDDc+h1rPWC+5SEXXliWPtdz9q+fNxbEFfKiuglPPpe6tD0T8+7Xazm1aG+Pn2udK3NbJkdgNQibZu7wsybtsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 1:40=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> On 2/25/26 22:28, Suren Baghdasaryan wrote:
> > On Wed, Feb 25, 2026 at 9:23=E2=80=AFPM Vlastimil Babka <vbabka@suse.co=
m> wrote:
> >>
> >> On 2/25/26 8:08 PM, Suren Baghdasaryan wrote:
> >> > On Wed, Feb 25, 2026 at 4:34=E2=80=AFPM Suren Baghdasaryan <surenb@g=
oogle.com> wrote:
> >> >>
> >> >> alloc_empty_sheaf() allocates sheaves from SLAB_KMALLOC caches usin=
g
> >> >> __GFP_NO_OBJ_EXT to avoid recursion, however it does not mark their
> >> >> allocation tags empty before freeing, which results in a warning wh=
en
> >> >> CONFIG_MEM_ALLOC_PROFILING_DEBUG is set. Fix this by marking alloca=
tion
> >> >> tags for such sheaves as empty.
> >> >>
> >> >
> >> > I think this should also have:
> >> >
> >> > Fixes: 4c0a17e28340 ("slab: prevent recursive kmalloc() in alloc_emp=
ty_sheaf()")
> >> >
> >> > and CC to stable for inclusion into 6.19.
> >> > Andrew, Vlastimil, should I post another version CC'ing stable or yo=
u
> >> > can add that line and forward to stable?
> >>
> >> I will add it. Note, they don't care about getting an actual email, bu=
t
> >> seeing the Cc: line in the mainline commit.
> >
> > Perfect! Thank you. Let me know if anything else is needed on my end.
>
> I tried to cherry-pick it to 6.19 stable and there were conflicts so I
> think it's easier to just remove the Cc stable. Instead I updated the
> changelog/trailer to contain:
>
>     The problem was technically introduced in commit 4c0a17e28340 but onl=
y
>     becomes possible to hit with commit 913ffd3a1bf5.

Ack. Thanks!

>
>     Fixes: 4c0a17e28340 ("slab: prevent recursive kmalloc() in alloc_empt=
y_sheaf()")
>     Fixes: 913ffd3a1bf5 ("slab: handle kmalloc sheaves bootstrap")
>     Reported-by: David Wang <00107082@163.com>
>     ...
>
> Added to slab/for-next-fixes, thanks!
>
> >>
> >> >> Reported-by: David Wang <00107082@163.com>
> >> >> Closes: https://lore.kernel.org/all/20260223155128.3849-1-00107082@=
163.com/
> >> >> Analyzed-by: Harry Yoo <harry.yoo@oracle.com>
> >> >> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> >> >> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> >> >> Tested-by: Harry Yoo <harry.yoo@oracle.com>
> >> >> Tested-by: David Wang <00107082@163.com>

