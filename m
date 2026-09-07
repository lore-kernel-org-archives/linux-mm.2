Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 625C1C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:58:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D6796B009D; Mon,  7 Sep 2026 04:58:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4862D6B009E; Mon,  7 Sep 2026 04:58:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34DA36B009F; Mon,  7 Sep 2026 04:58:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 04A536B009D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:58:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 925DBA4C90
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:58:46 +0000 (UTC)
X-FDA: 85186365852.16.7CAC2B4
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf16.hostedemail.com (Postfix) with ESMTP id B77A0180005
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:58:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FDOOGSxl;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of christosskarlos.kernel@gmail.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=christosskarlos.kernel@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788771524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wUqxbNGvU0QxYRTcJXMNasgjTTTwtVvm5Y4TPUV+wnE=;
	b=hzwiXJIMcFW9p6a5CWKVJLr29/JWIjBSWWZ3sbhQZrvh3xyH49X+YVQWpJ93U5D/+uuQo8
	PebxqJ//wzc4lcRsGtNYsg+IeDgo0XzhqB+lrLmTht72hf3SdlHLst53e/ZJ/o7V9AiWG7
	vzqc/rmn7yt1MgrkbfivSy/xPFBZZO8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788771524;
	b=5bBMaRrBms4Q0ZumQXqfKCZfqTpaS+BH9XbRGoF7d2A94aTXChQyztxcQzFz0NkBE/x4rj
	wB8eN2sraFhV9RIVcsY4l6ppY1Zk/Sl2JpYb6mneoA23PkSPw3mEJvjlKmtalfzIQh6VoZ
	PfE9V9kE4DDApn17HiCzl4a1tluRxR0=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FDOOGSxl;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of christosskarlos.kernel@gmail.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=christosskarlos.kernel@gmail.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-52d5bfa4bafso42453251cf.3
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 01:58:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788771524; cv=none;
        d=google.com; s=arc-20260327;
        b=RGhKKmTWNCC5YsUuU9VdWEuo2dJRBN9eobFbDd0bhHO5+W5HBxr1Ubewq/jDxJaqAm
         ZXsC6MdmfryeYmi/QwMnZf8jfeKOY7fTkrVqsJw/JTINUKzqxMhcN2MaF6Wl+Xq41S8A
         K2UpYXJ/nB0vJmucpYccrNacY5Y2dp922CbsC9NxHNnFEpVkGQrBWR3D5awZAopjKaq7
         iexa6hOp+AAQ0qNhWmbTjanTWxkUiSLK+HUFHajmJFINCWSdgzQKRBzsZZef2OaZD1XH
         hxp8H8gHkzBuogh6mKEyUUCgvRAcwm48sxNbSf9AIpr5whtMjux9eDH1HQY6PsANAdx7
         Mjhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=wUqxbNGvU0QxYRTcJXMNasgjTTTwtVvm5Y4TPUV+wnE=;
        fh=v7ficc5ld5gKWuqGKCq9le6XfaobYZ7neknuZEDBokc=;
        b=JwtM6j3MS3zSEZETLzlxQSNoCuM0O5Hf9LVYKFDjpeSXJQ2dgQlRkcn2UktewEAD+w
         diWE0KsfDLNgRbblb7dN181LIQg1TsjywDmi73gG1wNtsfsXJkgfqhCYbR5Bbri8iRi1
         2Ce8hbpohPbLAzFaQ1HYQzqhE/CIlEVB2fpBRRdu6W1ATGXqbJgcZKCUoHo2A9e6v+u3
         Dqcv9q8Kv5PepEB6D7RSWzFfuqQm9LTthxcZF1RH1sp+JJX5UXoobYbIMKCnrMjyibLN
         7XF019c966dk9bWvXuCmMWFbVG24ycX+i4fXQvjChnV6WX5mKHLtjhQbZU7SOZoMmIOC
         rCxw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788771524; x=1789376324; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wUqxbNGvU0QxYRTcJXMNasgjTTTwtVvm5Y4TPUV+wnE=;
        b=FDOOGSxlBjGYyalxMgtk0ZUVu78+jAmgGBQKQKAw8II5oy6DuykGLCYVnteXy1BYRA
         CF0gmec/6VC2bHtUJG062YcT7pA1GFZfijgnpKL/bo1RgFBqjlGq9fdYxsYrJ1mh8IoR
         gOEiROUS1dgueTTS4RVzNqHnhRXXYKTgRKOh8QT1CnV7WN24x6lfI13B+at/HlAC6sOs
         xwgBtRm7PMZIwVs+RsQb54e9AsgPpsssxevSm1i5bYb1o7bNHUedDVaGQeOsB8OJy25X
         S2LkVmurxYt8O/moRcWMy62gFOIqwIr4VsAp4AjQByv7Yj+Pp8g9CH+aZ+bse/64Npth
         WLqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788771524; x=1789376324;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=wUqxbNGvU0QxYRTcJXMNasgjTTTwtVvm5Y4TPUV+wnE=;
        b=EKo6BtBvQkT4+NXed/1BZHNEDuwLW2N+PIEH1yxXhXurcN40RRLmY0Fywd7MZC2XIh
         EYkTWWH2YSYhGO5iBc5OCVMKqhqLlaqpxVHMmrMYpYqDJuHrEI722Ecc2DWcQFxKUCVT
         SV89T2bjsAzYip/Tek9QHzOla3O79usUHAIRmtn6DuWimE8jkOBIdQhQ7tuff4APsgrk
         YIe1fzkW0Md2eLFdSxdHqILDW027uUOHbCdUuNTq24BBMGvQsl06JMGgEVCpBE7x4i2k
         WeX6A6uK7lnWfiOVEwhbK7qXaZfa7YJZL4e5nE6SVu39ryf2h62edn62DCKQkHaDdY8w
         Dfjg==
X-Forwarded-Encrypted: i=1; AKwUvByt+VnsSyOeMp0eoHFO8v5DB29cEM8y3ufK3hduOcGHdpekGEYljhMWgDXIq4hUlIqoz1HJinTNDw==@kvack.org
X-Gm-Message-State: AFuF++mba2RhNHHaOi1LSWLDHjWCKvTChqwsW5WdqM0lBUpfYiEzY5tb
	BBbjBQfMYY0kQgoK2WntBSKl0z5IndieUeC+2EbFvICAOraBwTtNlzL7WivBzsEX6f9N+Yp7kK0
	T/lpn7gsORCScgozKjnmSOESbJjjeZOM=
X-Gm-Gg: AYBFou1ZH7JsZ7HygwkYIQaqjh60UaKesspBQD618cDDuqRjueEtO52N7a3FYsqofb7
	GvnclLfWG4JzypPsymlBzNRwsD69dODldXwcIBSWe0cG4XM/wcbqJjBCcuJtKZcVC5i+oOLO6lF
	o0osfPKND20pEcB4SZqxd8SU1YDgvs9wiUiUKxWDrvRdizF3R+ciQ3myCTHuU7blxHM/9g2qv1N
	ZZLP2rESiHVPg5Yj84GD6RamV5zHrrCHZd8FzhRkJDMZ7kz3ZmrQwBGnF14mx8G2ojvVTABpH8N
	d5PTM7+o+tjAyWaTETZIkFWsOOr/MRZr1MTMIgEGJ2JB7GXiPEakab9QWBo+VEBCmRycYzKgPr2
	1jg==
X-Received: by 2002:a05:622a:286:b0:51c:1fd1:e755 with SMTP id
 d75a77b69052e-530549fd6c2mr246278761cf.36.1788771523825; Mon, 07 Sep 2026
 01:58:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260905183135.20993-1-christosskarlos.kernel@gmail.com> <60a8cf51-1493-4dbd-8779-8f007f6783a0@kernel.org>
In-Reply-To: <60a8cf51-1493-4dbd-8779-8f007f6783a0@kernel.org>
From: Christos Skarlos <christosskarlos.kernel@gmail.com>
Date: Mon, 7 Sep 2026 11:58:32 +0300
X-Gm-Features: AcwNN1XGtrJmpuoUZzpJj8itL5hFMaj_7EkEX83iAZ_8gANfOWrcmTSzc_l8LHA
Message-ID: <CAEO-viHe6hZaJzS3mjKtA8sq=tnuQOp4a_u1D56tuFx69F3N2w@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] mm: minor janitorial style cleanups
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev, 
	osalvador@suse.de, ljs@kernel.org, hannes@cmpxchg.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org, jannh@google.com, 
	pfalcato@suse.de, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, mhocko@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000431501065ae0d347"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B77A0180005
X-Stat-Signature: 4d8gxss8k1uszyj1sdcfby1fx3yfdxr4
X-Rspam-User: 
X-HE-Tag: 1788771524-930658
X-HE-Meta: U2FsdGVkX19D5ImE5kTPLWTaQWurrN8oStplJkxXfsjv49EvlYiWx2NDCcfTBphGU35SbbFA6r/f0BizrOz5EyCD+tQhigdPoGNMcIGCkMVbRBUJnR7cZ+xr1IxbWcsMes+W/SIwIf/uqWbqNjFl/O96k0pv4yBo4ah2Py6pWa1HIMUx8Eu8k6YpsF6Al9oIsHX/xyN6mRPpaiDeizaXmAtKpfraXexQ7qKEaA++KPySunopwsq0+SCEr7jf7eqPrTmFrbwDHrpAEhIg5ugZVX6m5t/821WI2Y1rItF9ewPHbnWEvEEtaBV+EHX0kZR9Jq+JlEvYAR6JCXgOpv9DAvYXb/yk4nKBj8SHHczcxuNxIXhHO+xP26WRDuFmW3qfZChcewpF3AJub1u2HOAnqwc5eIt0KUVRyT5Mcig+aW7MENTbuE2i4X6FDMPNdalzmaVG1yv2INmIRtlfV5p1CzFEP2idwQEFfoFkZ12aDupXTVo08v/RVRQVkDI9BhdzVE1z2ZBnBykpcJ8TjFnAzZ4Mf20depMukDGtyxVaLCtUlLhBVzEF8ObFnEwK1xcOTii+tKlOinwF97BOAmcfXfSc63GaHdvKAlR5tLTdo0MsB2jKhtKXMEJkpnpPo/diDAGNTWVXagF7Vc7X6ZN3d2chKe409ISg0lv1o7zWV7DjKqaU2HZFIGJakqpUT0U2680HCQj5SMv5ST8iymE+O7/+v+lMEw7+qlK23+KRRLwB97VHpo8wptymma1sz+EdzKiqeIniT/5wp2FgEmp13WtvdfiyH43wNJfDFdTqvoT0obNG7gw0igHtuWKoHsxYnzkId0nyz/c/q4nPzSBBxryMk1nFHlU97pT0IuJh2AyfaLcZLPJ1nzrkWbfhGB/xhB065+qEW2Yh6vdyQ9rFLaglo61YDzhyaaTuA5jFfK73MXRi+pNt3eem2gJRw2ToC0MN711NoxF2XeEArCm
 VGy+p1FG
 ok3SQtEfXTVhOdvpkwTPYznaPxnOi6KizINvPwiDxhTEPyHjm8cB0ms8Cznpwj29P/irDf52vohKbIXpn3fI0iTZZtntYUapCpcee6iWron2eP4QRK0XhrHnOCzYCN3Q0wwmYxeUC0+ksa3rxjeXp9TLirzsQ4cjICEgxHp+/svXuKPyEsyHeRdUv6OCyAJJKYh26o5AvYJBVh5iPv2Bq8o8bzFwI9JfgPOAReR7zq/yLxGKq655OdC6cE/hpnLOO4g72LL70ICvKv1f3+mCVy/43KxqBodKcMwQA0kk3qgDk6ywpTIgBn7ipH7xGrdSQkReQz+gXnZ1ZY84cgzQzdjxWq0B0YVRr3KTsYc7BE6u3ZdQj4RiTpIGyMSZDR/5HltMq3XtNcqa7/iYkBMemgE7KtagJz9le+2eHiXVxD4bOU6m/T1SUq2Oh8LujWcLoD+C3rBkeomtlTTsunu7bGjJeA547d+HEF/EjZeHkB/1fUxVV8UPXyzu2H3nZAjYGwLPOnoobeVnEGJzkve8VktTsVjl4pX9Ycc4GLgxZku3Bef+wsHm4U0/wj8uHlpXJNjzFRMg6YvppzON3wwqjapB4KdMyhjS8dXTB4ayBaJ2bpFLNVvm8T+HX6RXsepm72crZlW7QiYaIrXQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000431501065ae0d347
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey Vlastimil ,
Understood. Thanks for taking the time to explain the proper scope of the
checkpathc.pl. I will drop this patch and keep the tool strictly for new
code
submissions moving forward.

=CE=A3=CF=84=CE=B9=CF=82 =CE=94=CE=B5=CF=85 7 =CE=A3=CE=B5=CF=80 2026 =CF=
=83=CF=84=CE=B9=CF=82 10:44=E2=80=AF=CF=80.=CE=BC., =CE=BF/=CE=B7 Vlastimil=
 Babka (SUSE) <
vbabka@kernel.org> =CE=AD=CE=B3=CF=81=CE=B1=CF=88=CE=B5:

> On 9/5/26 20:31, Christos Skarlos wrote:
> > This patch series resolves various coding style issues flagged by
> > checkpatch.pl across mmap.c , vmscan.c and hugetlb.c.
>
> Checkpatch is meant for avoiding the issues when submitting new patches,
> not
> to be run on the existing code to generate fixes just for the checkpatch
> issues. NAK
>
> > Changes in v2:
> > - Restored filename comment at the top of mmap.c.
> > - Restore <asm/...> headers in mmap.c as they are architecture-specific=
.
> > - Remove blank lines above VMA_ITERATORS and NODEMASK_ALLOC declaration=
s.
> > - Fixed commit message typos.
> >
> >
> > Thanks for the thorough review and guidance. As a newcomer every
> > feedback and advice is really valuable to my workflow.
> >
> > (Note: Apologies for the stray huge_memory.c patch included in v1 by
> > accident; this v2 series correctly focuses strictly on mmap, vmscan, an=
d
> hugetlb.)
> >
> > No functional changes are introduced.
> >
> > Christos Skarlos (3):
> >   mm/mmap: fix various coding style warnings
> >   mm/vmscan: fix various coding style warnings and errors
> >   mm/hugetlb: fix various coding style warnings.
> >
> >  mm/hugetlb.c | 16 ++++++++++------
> >  mm/mmap.c    | 12 +++++++-----
> >  mm/vmscan.c  | 11 ++++++-----
> >  3 files changed, 23 insertions(+), 16 deletions(-)
> >
>
>

--000000000000431501065ae0d347
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hey Vlastimil ,<div>Understood. Thanks for taking the time=
 to explain the proper scope of=C2=A0<span style=3D"background-color:transp=
arent">the</span></div><div><span style=3D"background-color:transparent"><a=
 href=3D"http://checkpathc.pl">checkpathc.pl</a>. I will drop this patch an=
d keep the tool strictly for new code=C2=A0</span></div><div><span style=3D=
"background-color:transparent">submissions moving forward.=C2=A0</span></di=
v></div><br><div class=3D"gmail_quote gmail_quote_container"><div dir=3D"lt=
r" class=3D"gmail_attr">=CE=A3=CF=84=CE=B9=CF=82 =CE=94=CE=B5=CF=85 7 =CE=
=A3=CE=B5=CF=80 2026 =CF=83=CF=84=CE=B9=CF=82 10:44=E2=80=AF=CF=80.=CE=BC.,=
 =CE=BF/=CE=B7 Vlastimil Babka (SUSE) &lt;<a href=3D"mailto:vbabka@kernel.o=
rg">vbabka@kernel.org</a>&gt; =CE=AD=CE=B3=CF=81=CE=B1=CF=88=CE=B5:<br></di=
v><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;borde=
r-left:1px solid rgb(204,204,204);padding-left:1ex">On 9/5/26 20:31, Christ=
os Skarlos wrote:<br>
&gt; This patch series resolves various coding style issues flagged by <br>
&gt; <a href=3D"http://checkpatch.pl" rel=3D"noreferrer" target=3D"_blank">=
checkpatch.pl</a> across mmap.c , vmscan.c and hugetlb.c.<br>
<br>
Checkpatch is meant for avoiding the issues when submitting new patches, no=
t<br>
to be run on the existing code to generate fixes just for the checkpatch<br=
>
issues. NAK<br>
<br>
&gt; Changes in v2:<br>
&gt; - Restored filename comment at the top of mmap.c.<br>
&gt; - Restore &lt;asm/...&gt; headers in mmap.c as they are architecture-s=
pecific. <br>
&gt; - Remove blank lines above VMA_ITERATORS and NODEMASK_ALLOC declaratio=
ns.<br>
&gt; - Fixed commit message typos.<br>
&gt; <br>
&gt; <br>
&gt; Thanks for the thorough review and guidance. As a newcomer every <br>
&gt; feedback and advice is really valuable to my workflow.<br>
&gt; <br>
&gt; (Note: Apologies for the stray huge_memory.c patch included in v1 by <=
br>
&gt; accident; this v2 series correctly focuses strictly on mmap, vmscan, a=
nd hugetlb.)<br>
&gt; <br>
&gt; No functional changes are introduced.<br>
&gt; <br>
&gt; Christos Skarlos (3):<br>
&gt;=C2=A0 =C2=A0mm/mmap: fix various coding style warnings<br>
&gt;=C2=A0 =C2=A0mm/vmscan: fix various coding style warnings and errors<br=
>
&gt;=C2=A0 =C2=A0mm/hugetlb: fix various coding style warnings.<br>
&gt; <br>
&gt;=C2=A0 mm/hugetlb.c | 16 ++++++++++------<br>
&gt;=C2=A0 mm/mmap.c=C2=A0 =C2=A0 | 12 +++++++-----<br>
&gt;=C2=A0 mm/vmscan.c=C2=A0 | 11 ++++++-----<br>
&gt;=C2=A0 3 files changed, 23 insertions(+), 16 deletions(-)<br>
&gt; <br>
<br>
</blockquote></div>

--000000000000431501065ae0d347--

