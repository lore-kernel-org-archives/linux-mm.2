Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D014CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 08:38:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F8E36B0005; Wed, 20 May 2026 04:38:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A9486B0088; Wed, 20 May 2026 04:38:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 598316B008A; Wed, 20 May 2026 04:38:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4894A6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:38:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E20A2A0218
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:38:06 +0000 (UTC)
X-FDA: 84787145772.13.76FCBC4
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf04.hostedemail.com (Postfix) with ESMTP id DE0164000D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:38:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dDB3tj0e;
	spf=pass (imf04.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779266285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ViWe++CWOPj3aNhRWEC5ZAdALr06cNJD7hm6DpKWJFc=;
	b=F9oYj9z7FK0C7+81KwarP64dZLwspgANMZZNsFNa4EID1Cx6DNWPtFlZ+F9asDTSWmr0A8
	ivGs5+aC39uqOltNjujhkF34Nb3CBZqV7LNiGGUeiO4URqHMuoLCMNuvSC8rwc/X8D7abB
	FkOqkoR9RnxRRD0XEZwhm1sDM2deeJ8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779266285; a=rsa-sha256;
	cv=pass;
	b=Cj1N7UESYJaUYbPw98gLg+iyu5KIcxziJZwsSu2D08YZhclqtIuVuqWkUexAYiqbC9D0d9
	5B49iobiXUEXgI9/i6hmiqCim26Z7UOwqmQjnE5T5UDyUkCYggfYyPxlAyaK53BB/+r0VN
	bCI4NlJorW32lOJ4a/UZmdAghDnch1s=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dDB3tj0e;
	spf=pass (imf04.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-48909558b3aso48437885e9.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 01:38:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779266283; cv=none;
        d=google.com; s=arc-20240605;
        b=jrvCNrR1XCxhWZZ8nX4zi+XkWTso/F34os7L3OMlyGikExFQKoZVj/1AfCkARliH18
         NuJL5N8VbfY3V5tVHrpjeoPLgeK4ZtY5hd2O3Cwh3kk3FxFV/bcLldyr1hRuZLDbvU0s
         in5C+KsHaeVYkYD250VsXEAvtghMUv7m7GaML66j9lGqkWr4snM0nU6qseO5GciLICw5
         hSsDOig+s5u3PTG2pvl7KkuE8hJygx7evn3hvfDSD3FhGlAC9XqUyp/21/YKG/k7v3iK
         pUlrtXmpG7334e5YbmMT5kYb7m+qHD2XqoDcTLSe9G+Oy+tIlcmM+iBKKcVIY+MZtcqC
         06Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ViWe++CWOPj3aNhRWEC5ZAdALr06cNJD7hm6DpKWJFc=;
        fh=V4bcGwBy0szeWxIsCUPVUyOSskR0qMnRHx+7irswfHU=;
        b=R/H3PtqfmAWxzDn3h13pnt7o0EAcgsQL9nrN+EzTKy3rD1+9km6DxBD21ooIW/Huom
         ZwP0Q5t9XxxELXQ2CsGh7POUpNkOmS+Xko/8LhRK0PMiEVViNh1H3m19EHf1q8zs+SxS
         adxljxTVywZsvn/yYx4DDdYV2IkzhhF/+hWkfVtZ5ewUz+5aiS3s8Oyc0XDg7CfSGmJk
         /B3aDmtvI9NQW+R5cJjXy4Qjq6C2qkaS/faK/lqWJJpVo5IjsjcfgCJdOftuVpoLl+0+
         hMEuBzVxeLYwGZG5Ryh5rBS4Ladtd4kMz27owd58JTCvg/KyGnBkaVH2HGS+XHpAicMA
         AqOw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779266283; x=1779871083; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ViWe++CWOPj3aNhRWEC5ZAdALr06cNJD7hm6DpKWJFc=;
        b=dDB3tj0ezA62Ja1piyzA2GZOUVuKteTfOGPikN7lGe+Pud7C70PF/O3b/7XTzIQdxp
         mnWIiTLY70awUePJFCN5HVL4I6t8QMW0QLV+rhOXVWWtAwVuhSYZ/9EazBu3lu2YJhYK
         URQcOrd4O5/tplAIzJ79A0kf1xEw1Y9CuP9Pq65fdQF9K18E+Ye4d32DSVotiN9w6POR
         ohyzIX+6YmFMUkru2USsd6tdWuHA1N+bUfzlvwgnGkq7Odyx8mtoWAjfcqncDUR18Rql
         LcpaEUmW+CZfOXwLj/nUlAzlfS6isj5yUaZ5dVFVPpKEpvXTfpuGm6IuURoc71gfoV13
         L1fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779266283; x=1779871083;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ViWe++CWOPj3aNhRWEC5ZAdALr06cNJD7hm6DpKWJFc=;
        b=VRpxf5M9PRsBRbCTMWRezejYS7ciaCsjExth0rbSx0K4oAz1NO2EmybQnU2uiBmR1b
         4yj1jvwcrlNK4JJHzjGmRgAIKcdJEzS/ylDSNQkb4SmAqeix/IlWfY/d4NdIQQ+XV8J9
         n3ocDC+dLN3Y3lZzuIQ/GI18PDUmLtGwQ2Euvk361K7MfASmzJWEpSKpG6DsCZjPxlx2
         3YOPX5z66Inhyn9yChHthweNezCwBuJoRsYJItSuqFLH6Cmq6jw5yLgocx2GJJ/16Yjs
         dvuExFpp+kXexVGk8et64NY3JVfl68VEv7vn2AJmNZ09LdnKqmsrzcQ6p68eF0RPyBoQ
         TzUQ==
X-Forwarded-Encrypted: i=1; AFNElJ/Qp5Me/yoM4h93s7eVXvomR6BVS8M81Np95yVb1oae3jh+gUxxDityZhG0NY6s0K7VCR0Q2/NMFQ==@kvack.org
X-Gm-Message-State: AOJu0Yz4U2AcOJvNza8N0VzzgVAiu2MQLYe46kw1QLKzQ/tdGUoT/ZFw
	utatKNQooYQ/fQ7egIjpAqBzz6ga7lAqo+KiaCosfJ+9bMYFWyrsEYmzN9MLQRZEzCgcvNht/1V
	sxbBSItMY3m+FU/Cya9OF1D7uAQR6Ok8=
X-Gm-Gg: Acq92OHG1zga4Hvkda2fgB15nMI+eIkwcCKQ+NsQwc7Ka35uOVkWAm5XC53QZW6RJmE
	KSFbksMcx9jEAkppjgpogBdG3qkCY2tofc60a+y2AplDdIKE+CaxRLP5TEGXV/Ej54Kv2Gl/Jgw
	o7M55R9M0jpSh1/b1yHOU9jQ4AOub61nU0nRmVQcvnPYh4RVDqCU3Xo1AhoQbTQgCdgk3FKoTL/
	s5t3uGU+AkTqEwR7JtMlEnTtFvgYNpQJqwOyFnEpPIsVyR8Gp+hGckkwbAxZQOj5a7Skh6Du8/7
	UyC/mMKmfi9qlDJL8gc=
X-Received: by 2002:a05:600c:4e47:b0:48f:d835:e0ff with SMTP id
 5b1f17b1804b1-48fe63265a1mr390909085e9.17.1779266282924; Wed, 20 May 2026
 01:38:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260514094108.2016201-1-jiangwen6@xiaomi.com>
 <20260519131738.11a78ba88e1be28ba5cb26eb@linux-foundation.org> <ag1feQwK38vd9i72@milan>
In-Reply-To: <ag1feQwK38vd9i72@milan>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Wed, 20 May 2026 16:37:50 +0800
X-Gm-Features: AVHnY4KPg1o5W-e2hC-h0yT5b--ldgyP4FoAL_7iFHMCNvL14Wx2QOYJVazlrIw
Message-ID: <CAHKocdE6_F-dJ7CEReHjyQfBu8mHOzehfgnRCWQq2mM3sEM5vw@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, 
	will@kernel.org, baohua@kernel.org, Xueyuan.chen21@gmail.com, 
	dev.jain@arm.com, rppt@kernel.org, david@kernel.org, ryan.roberts@arm.com, 
	anshuman.khandual@arm.com, ajd@linux.ibm.com, linux-kernel@vger.kernel.org, 
	Wen Jiang <jiangwen6@xiaomi.com>
Content-Type: multipart/alternative; boundary="000000000000c12df006523bb6f9"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DE0164000D
X-Stat-Signature: aq8zn8jnxdcxuabrqbxypwfuc1skwseg
X-Rspam-User: 
X-HE-Tag: 1779266284-28111
X-HE-Meta: U2FsdGVkX1/JoH5NME6WR2uE7g7MOQ6y6ABHHMOgMphbRoKnqPbwi2mR0w44vRQhxEj8wkvc3OFk1PBVV3tGqslkxlB/mU0fpLb6ZM9Neau5U1Zv+qVMg6zWoFKAhVG24XYDRnZWGUklYsGA1M+YY9QEAYE5j6tdbV6ZQRwDYQeJmofHgZFMMsIIA7SIwUEjdFw9dXxeVRndf3sYg2+ESL1JOyUk+E4Lo8cFVRy8Q2yARAmDZHnED86M1d95iNUnLOtu5KbV4QzijACeKyNz/8TdPXyZRS1zwpmvLIz/lNuEk2Gec1qrImULoeYhjZNHspYL55M9lE2tXPkkCux42Cv00y8vP+I8Qx7hMwFDRFxy/oGBWi9W//EcWaGNfRgORdQLpxPhX9x1pH0wD8MNjgFnRhrUY0spftXuP7jqlwEJrVItlrrC7Vu3DrbBqNLxXAjSODo0trbT64as9neXpC9CKPWLsg3vouc3OhCTjEi8G0MJiusrPKUXj6FiEbOcBZk7BIyqJW5VJmfubhXtNll78t6DAPb99kGHGmkUBfEL3bsyq8D+3UQNRvcJ7zS9QrQLoAR6QTjfR4xmI76y/JqEATSJfiCXXl7N26Poy4lzcnOflvBUzRbVi4m++XQUWAuXxoZoqBQolQOZ1SLdkZ4zZGcJjHktCuE27ATZWc8qURoF30Uq+/EVTYmY6W8EHSBI6MSRh2ZqyqAq3MseW0v1z5WU8VqfYgMUqgIvFB9eWt4r7KlQBNIXaMKdyNpurxsi9eajP/vo5b58s/56wrDw88ccYXbX+li6nbIBhqKp3WWEFKHXmibFNUagWpDRviO8U2PchXNuv1HN/3VX47JLVjAVtKCMA8W4HC6jdhkH+rKvYa6vc3F0SSkx3XGKp/tzjxOBIymyg0Iokg86NtaCZKzhkEXmTlmrgLR5ZnZZMr7fBT1qJ5JOPfdENR21UHDxAY3zxEb3QkaEXjb
 ipVE9YtA
 vLKTGmlPEdp7xAicmOoSatbL0NRHG6HG9RFsOs+OlRjeXtFZfxMoO0YMj7CsFJ3VE1NxAyuYE2d7Obn5o+sRR3K2ZtGx4pHaa4WN9oVHa14Vo+9tKYS4+ULF0n+tSUHnowvx/yFT5pDHfLjvPFGSOjgi637jZ9Dn9r7U1wy71OIX1roBBDmptBDlw11CbBOyZxP/32FGPlNiSQsG5bUQuKxBMlue2YiDySfpAfpy767VVfOcvQYQzIqzIv4GvfjpqNmX0HrxKBKdeSj69O8c7WmnD7xnvP9YIQX6JrZbtmwbMU40cVUeH4IBGMClW+95U+I6Z9jxABOZuxkwAsxbYJ9+Bdef5tWTBhtwp6FBCmHDMrYEiowAA6RXXuCNyvoQshuTGkfaZm95Mb6bqY5ifhdAjs89+RRJQqwZqBReF9paRAa62xlHHuuCHzEcrGjjlDK577jz6MioUy4KXyYSguqyX/h9l6srhl/vwYkeRbURH/kWrca7u9mQXwr0jYE3uwzSafj3OQG6wjq034ksi2PU+1G0Fdhm8B9ZIyXn6VAt1PvcGUG8fgItJiN+ZXUo/65NIdveWkdNmk/bd5uIP88bxwAdpC1hkf3KCgsU70986+bk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000c12df006523bb6f9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks, I'll look into it.

Uladzislau Rezki <urezki@gmail.com> =E4=BA=8E2026=E5=B9=B45=E6=9C=8820=E6=
=97=A5=E5=91=A8=E4=B8=89 15:15=E5=86=99=E9=81=93=EF=BC=9A

> On Tue, May 19, 2026 at 01:17:38PM -0700, Andrew Morton wrote:
> > On Thu, 14 May 2026 17:41:01 +0800 Wen Jiang <jiangwenxiaomi@gmail.com>
> wrote:
> >
> > > This patchset accelerates ioremap, vmalloc, and vmap when the memory
> > > is physically fully or partially contiguous.
> > >
> > > ...
> > >
> > > On the RK3588 8-core ARM64 SoC, with tasks pinned to a little core an=
d
> > > the performance CPUfreq policy enabled, benchmark results:
> > >
> > > * ioremap(1 MB): 1.35=C3=97 faster (3407 ns -> 2526 ns)
> > > * vmalloc(1 MB) mapping time (excluding allocation) with
> > >   VM_ALLOW_HUGE_VMAP: 1.42=C3=97 faster (5.00 us -> 3.53us)
> > > * vmap(100MB) with order-8 pages: 8.3=C3=97 faster (1235 us -> 149 us=
)
> >
> > Nice.
> >
> > AI review found a bunch of things to ask about:
> >
> https://sashiko.dev/#/patchset/20260514094108.2016201-1-jiangwen6@xiaomi.=
com
> >
> > It doesn't appear that you'll be getting any more review on this
> > series, so please check the above questions and resend?
> >
> Actually i keep an eye on it and i have done some stability testing.
> So, just need some time. Fixing AI sounds good.
>
> --
> Uladzislau Rezki
>

--000000000000c12df006523bb6f9
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks, I&#39;ll look into it.=C2=A0</div><br><div class=
=3D"gmail_quote gmail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr=
">Uladzislau Rezki &lt;<a href=3D"mailto:urezki@gmail.com">urezki@gmail.com=
</a>&gt; =E4=BA=8E2026=E5=B9=B45=E6=9C=8820=E6=97=A5=E5=91=A8=E4=B8=89 15:1=
5=E5=86=99=E9=81=93=EF=BC=9A<br></div><blockquote class=3D"gmail_quote" sty=
le=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);paddi=
ng-left:1ex">On Tue, May 19, 2026 at 01:17:38PM -0700, Andrew Morton wrote:=
<br>
&gt; On Thu, 14 May 2026 17:41:01 +0800 Wen Jiang &lt;<a href=3D"mailto:jia=
ngwenxiaomi@gmail.com" target=3D"_blank">jiangwenxiaomi@gmail.com</a>&gt; w=
rote:<br>
&gt; <br>
&gt; &gt; This patchset accelerates ioremap, vmalloc, and vmap when the mem=
ory<br>
&gt; &gt; is physically fully or partially contiguous.<br>
&gt; &gt; <br>
&gt; &gt; ...<br>
&gt; &gt; <br>
&gt; &gt; On the RK3588 8-core ARM64 SoC, with tasks pinned to a little cor=
e and<br>
&gt; &gt; the performance CPUfreq policy enabled, benchmark results:<br>
&gt; &gt; <br>
&gt; &gt; * ioremap(1 MB): 1.35=C3=97 faster (3407 ns -&gt; 2526 ns)<br>
&gt; &gt; * vmalloc(1 MB) mapping time (excluding allocation) with<br>
&gt; &gt;=C2=A0 =C2=A0VM_ALLOW_HUGE_VMAP: 1.42=C3=97 faster (5.00 us -&gt; =
3.53us)<br>
&gt; &gt; * vmap(100MB) with order-8 pages: 8.3=C3=97 faster (1235 us -&gt;=
 149 us)<br>
&gt; <br>
&gt; Nice.<br>
&gt; <br>
&gt; AI review found a bunch of things to ask about:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0<a href=3D"https://sashiko.dev/#/patchset/20=
260514094108.2016201-1-jiangwen6@xiaomi.com" rel=3D"noreferrer" target=3D"_=
blank">https://sashiko.dev/#/patchset/20260514094108.2016201-1-jiangwen6@xi=
aomi.com</a><br>
&gt; <br>
&gt; It doesn&#39;t appear that you&#39;ll be getting any more review on th=
is<br>
&gt; series, so please check the above questions and resend?<br>
&gt; <br>
Actually i keep an eye on it and i have done some stability testing.<br>
So, just need some time. Fixing AI sounds good.<br>
<br>
--<br>
Uladzislau Rezki<br>
</blockquote></div>

--000000000000c12df006523bb6f9--

