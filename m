Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4948FF6E6B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 21:15:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E79E76B0093; Tue, 17 Mar 2026 17:15:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2AF66B0095; Tue, 17 Mar 2026 17:15:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D409C6B0096; Tue, 17 Mar 2026 17:15:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C2FCE6B0093
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:15:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4B2EEC1969
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 21:15:37 +0000 (UTC)
X-FDA: 84556811514.30.49F13F7
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4997940007
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 21:15:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nMHrWeHl;
	spf=pass (imf12.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773782135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UQXqGLWjL0uy0RlIRCBRi9lmJm/8pBZcA477vJ2mNPg=;
	b=eohpRjcTLVzk2iu+Y67bXjkDNsswzj37uOtE6n5p/d5GKJWgs/heNunTyGR+En+AkTmw0D
	voNTdWr6VsG/YswGCd0yvbMgd/8lhdTbSHP0ZK9i+d0TvR2S6dURBeDIJ/ImZwah8xPhPS
	9lSWJIb9XrUuxt+zQuBEIyWSmTu8cgI=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nMHrWeHl;
	spf=pass (imf12.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773782135; a=rsa-sha256;
	cv=pass;
	b=tYQVTgPYrAZogZiT+NpEvXLi5usxQAGT3tE26/MOGGQWnVEq32fpIOUYiFkmU6zekqrqWo
	TfxdaGy/QjQCYMlyDiS9EkdDkPKYouVOWmmNgYV+Gq2IzqJWhGcR2LyJMiprVYw1R6t7+6
	tPXQilh7j1qWRmI7uYokn1nEmvwHm18=
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-2c0b7eda342so2919801eec.1
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:15:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773782134; cv=none;
        d=google.com; s=arc-20240605;
        b=ZfEtwT89F8pzMIbHzKcur6uC+TS83Eh2KZUDltnHEwcyq4F2BX76dwfs589xC0MkO6
         dtoDBHn6mbVqOvjinHDw4SzCDn0xh2lrH/ipx627EvIWwuOOoR3KnPZz4Aba4AojQWCD
         Ip/SWmCgdlylwyRA+/p39tPw08KzEAKBmvrg8QWVJ64dtdpt78b+AlVEcw7AFz3rjFBp
         ywbI3z/8tZd85/ZVB8fMu5pTLM3Ch2wtrWvIcy6CQrWFOS7hh9UFsD7EaXbdnnn6wOTt
         dK7JicosIuAOjnTeU89VgeEaRRE2/SlTavs0NU1NV6NQVrBnG0fLgEAl6bFI+xd1Tjzv
         mvCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=UQXqGLWjL0uy0RlIRCBRi9lmJm/8pBZcA477vJ2mNPg=;
        fh=BMixvvU8ls6KinDUZM31CxtzCtYT7ry4Fr6w1rtYNnU=;
        b=jL/otx/pKddV4HLhyrP9dDPEJUhiePlIklpVRxWr5MTEuhMveN3WibTfhxmzmcb5kw
         pL1cts9KUvo8q6lOwHc+B6l7JC0hJzugMAjB/0HffITJ59xighqcW7ZTXmJaaCjQr17H
         GMQUwJI94C97gLxbMNGiM8traqtjNLB5FSUZKZcsrAMkQ7Aw9CiCbOxD+GmooTrlsK3o
         lW7r4y8JER1TwiO7nS/67RpU2qOsLGWzoX/2XzDJ9DdjG/tm4ZVJsgC5V7lmfCmhTdTV
         Mkjjw0BDaDfgqA0gRQBUPh6AV/7NV2P7PkHy71tV+TRxcY8fanUz3WO/V2GsY3WkOyqN
         UgMg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773782134; x=1774386934; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UQXqGLWjL0uy0RlIRCBRi9lmJm/8pBZcA477vJ2mNPg=;
        b=nMHrWeHldixuJUoR8MKRfmRH1/1I8cyjYG45bbUTpooxXNWIGZ2a6AoZoJqGbePtG0
         i/5yhD1C+o/8dSjtanj6wCfC+4DT4xKDSBgIuvcP1jR1u09g9U9uPpOrT+tUNrrWw79d
         hzUGva1O4i18cE+7KpEpWirrx2IucQM2U8Mk2VmqFMnJHD9A3Zqp5kFSW4r1AnIVLY1z
         RljESKSfCcRSagBVM84wkIOMtBeLesXKA7OVAsjzJ8av6JhW45lWoeylQ1RH4dpyR2/s
         0okJT7uHWl2sHkOadB19cfHza9buTzaMB3cGn3HtU3ONLhPL8fN990vXPHNGD7D56fGu
         3cwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773782134; x=1774386934;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UQXqGLWjL0uy0RlIRCBRi9lmJm/8pBZcA477vJ2mNPg=;
        b=U8e/wPQzDHIhp4zmHB3FMCHCuYTfztRSfG8fgLTfvnckIFAewpbIJHSd20TMs2Rjg8
         Y46i44ChXjmK7Z3VQCFse6WA2RJ6K062tJ2Gara0VpZdyGHOvuFsr3nOSHclL5LD5Hpt
         5u3A8pPJsnmWWaxt5dWoFOHgfKiF8T7BL2UJs0rXBYM1oYMrbmqBqZbkGoIC3n4tbcDp
         rI7Ww0ClYpJwi3gtY7npmMhqTap/MOdRGkW8htr/lvmnwBuj0+IudJdmp1qBd+iApOvl
         j/BeeX52sJQ03Jq525cxV7jnYKH0+rPAcaHNQGGUDgW2HoHyhqhW+i+0QdJPs6RlfikV
         Dmig==
X-Forwarded-Encrypted: i=1; AJvYcCXSXsXu8LI3KVPFUDnShLcCge9agm0elu6kRNQD+jBNoGahyrkjWFLMPBb2ureAq2DCjdaNJMNJuw==@kvack.org
X-Gm-Message-State: AOJu0YyPiVE0+ufjU9oubyixWRWLbOEHKtXp7HbnI2zdIFxz3uIYMV+4
	1uC6qSS01WGYnlU5QOAjg29T3NB+dtNfXx1DeA/pP36iFgZCBwQleEs0INg6pkmIfO39y/CqMhm
	v6a3rluiDums6qzD6MSFVhmcESz0YTow=
X-Gm-Gg: ATEYQzwhqHuqsBX/CteM7j/TYiJAKnt47/VywR9JxIOlCbu8gV04tBse6Ue4u6VyxrD
	h/rkXZcuwYK3VOeWXj9foYW0YwrIZhr4ry3glx9cqoOQwXPXdUt3wSR/Fr5U5X3iYKqnZF/RZxD
	N05I73+6Z/iX4e6OR64O2p1BBeUaw2kvGZL57J6OYNMKMJ113iBKINoBarMbOTm8tM4JvNXVjnn
	rdjvUpLbGSmIJa0boql8GXBxyQcm5Ud8QwUCWKqg2MYAfbJVSqTiu4W4Zr4jVZpr6OdV2aqhHIL
	E6agjw3Ud9iD/wSv+bwYUE5FtTLBbsekUr5CPxztvRhaRoUhLY0=
X-Received: by 2002:a05:7300:ed0b:b0:2be:8749:d5b7 with SMTP id
 5a478bee46e88-2c0e501c779mr516346eec.14.1773782133898; Tue, 17 Mar 2026
 14:15:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260317014802.27591-1-kanchanapsridhar2026@gmail.com>
 <20260317124528.961ebeaac03f69e65cb767e8@linux-foundation.org> <CAO9r8zPHpfGHaz_crbSwB6hhyLpZ6+L22XjtM9WY=NvC87n9Yg@mail.gmail.com>
In-Reply-To: <CAO9r8zPHpfGHaz_crbSwB6hhyLpZ6+L22XjtM9WY=NvC87n9Yg@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Tue, 17 Mar 2026 14:15:22 -0700
X-Gm-Features: AaiRm52jFhnrR-RvNmE_Ef7jEVVg3kUxCxWVKs16SLmZu73c81jgTfsdN3j2h8E
Message-ID: <CACpmpocqzLchZfGT2WrMiZhMVDjgCSOfSRika-TvqVnKgGeceg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] zswap pool per-CPU acomp_ctx simplifications
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: multipart/alternative; boundary="0000000000000002c5064d3ed6b4"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4997940007
X-Stat-Signature: rnthe54oiim7df3wwzf8xapa3ursgq7k
X-Rspam-User: 
X-HE-Tag: 1773782135-534460
X-HE-Meta: U2FsdGVkX19pTLwg61+HqdezU0YCPkIzy16T1PZHeckHEZJRwNBYqFbCbhNoDvyc7So220hj4IYlfXwNdW4n6bpG4496RQYnuif3FDxK2LrBBTkE6mr4805ZHrtNoH/IIu2TVIQD0li7Lpq0J1cc7gaM2OuaU68pyLMis6a2higatQmhDTGJ5TM4eidKHyMkhgExgHy6pg3WDLr5wgjrD0MV+H5KtZLQUDo0isrZ572eJxIxGwmN3shOEIF2UherV48ji/RWmO5iJy8k7cvmt75cJjcp9Rr7ISnAhCr7zm524o2/ZSLb95ZKmxpdEjaDw18RQg4hD6Xtav4cBfiiOgDbIiwuWLO2jS21qqPD9rGIJhNxXnLT7Z9q7sYRJ215aH3BOXbivgWTcTRoj08EQ/r9bG1eiLqjUT3fa/XislCkiZ9Wb6CtdOgLxY4HjBE7MltRODFUevkJ80E4hJP1QIGG6ygb6/4kIo3jLg633XISocHVNnSxzWtgj7NFa6HYOSlPL202BZkzkcXSfFhmizgDA9Rhp2TPEvinnImJFtg8tRAyy2wS7YjldI4S98gn/xG1/iI0Ck8JjCW5wvCZWAzU9VS7X/3SR5XETCevtOx7qU9sAyL0eCngAKw7phL5dmActmpN9D9a/BatbXXCZXftMoZq+6PswsWUu02TalfaznUVB/r4RrvJJlejvQbbpOkPKvZT2pWI6KvLpvbkMHfeDTwc7f27TuHnHfps3CP3BZ8xdNM+wsHosoIpneKBvi14rdxHRjpGf7zy7IRcfdD28rktDViYoepyMbL1uoGwjyNnMv2WwCiUMp3zVEh+NOKUJi6bn96SjqmgjieH/JvcyBF6nvg1CmS6s+6CVHRapFiLU5i/R3HbgQV+nsFJk48YjPfB6mxPPzbBYS/3cpw91CEK3xBOyg6sB4qTdmAGEkgVwWOzQ+vVMqfFHoiyuNuxZLXICPUIWiRpXmH
 fr+4jF7n
 rTMOc8C1c9WrASW/9Nnh8l4LmF4iLMhKEH3N+EYaxEKI1gMF4uQzF+266tWBnk1OkipJ3Pat0MGMQRXp0Zh3CTFDNUdUUqggrW0cJ6qRjiU91sWwp428zth5qhYCVD19vdjhIzmDUlTy6uptc0jK+Oq+ZKWUyTN9cdkmdk39ggabo44vB47KAcdOOLwQ1GN7hAeXlc7INPivJRPAexCLqboAKvLDWIKaEUEeYP1PHEhwSzvmBcwzH62y7rL8s8sLPOlo7KFDnqWZXgbi8cX+cUwCjsBj5lpniZA5VKX7C3dP/Y2LFhISzEH83/AFCv60NHC1MNObges8UsGREs6Mbs0OLfPi61ZDP82i2eRGQI4mtlrlcq2BNmL5pgNC/ciDxdyC0IH+QkY+gKre0iBwVNvbiExo5LzqJ3hv1Tg4ioUV+in/Y5mXTyNDUazxPa96rx5alMT+/gdtzF26W0iYu2viE1FIUsRbGI/ZVg+BHGpgX/HVUuWVd9yLfVpf2ZLuFnWV/57KWBkl/bQbKemVd1uC80UmPgnHBazcIc7Eb1ksQWlltrWCqHHYhaX/Q9QtYimBeD6WdcEuWX08nxli1bLI3VUvQrz/TqlSx5Q0wCbiejJDsRCqdWQZG/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000000002c5064d3ed6b4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 17, 2026 at 12:48=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> On Tue, Mar 17, 2026 at 12:45=E2=80=AFPM Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> > On Mon, 16 Mar 2026 18:48:00 -0700 "Kanchana P. Sridhar" <
kanchanapsridhar2026@gmail.com> wrote:
> >
> > > This patchset first removes redundant checks on the acomp_ctx and its
> > > "req" member in zswap_cpu_comp_dead().
> > >
> > > Next, it persists the zswap pool's per-CPU acomp_ctx resources to
> > > last until the pool is destroyed. It then simplifies the per-CPU
> > > acomp_ctx mutex locking in zswap_compress()/zswap_decompress().
> > >
> > > Code comments added after allocation and before checking to deallocat=
e
> > > the per-CPU acomp_ctx's members, based on expected crypto API return
> > > values and zswap changes this patchset makes.
> > >
> > > Patch 2 is an independent submission of patch 23 from [1], to
> > > facilitate merging.
> >
> > Thanks.
> >
> > What happened with "mm: zswap: Consistently use IS_ERR_OR_NULL() to
> > check acomp_ctx resources"?  Still relevant?
> >
> >
https://lkml.kernel.org/r/20260314051632.17931-3-kanchanapsridhar2026@gmail=
.com
>
> We decided to drop it (and patch 1 here kinda sorta takes its place):
>
https://lore.kernel.org/all/CACpmpoeo0LhxkoA5Wx6q+9=3D2scn_az0u=3D3bar-JgBv=
TA-ZBkZg@mail.gmail.com/

Thanks for the clarification, Yosry!

Thanks Andrew, for adding the two patches in v2 to mm-new! Thanks also for
obsoleting the "mm: zswap: Consistently use IS_ERR_OR_NULL() to
check acomp_ctx resources" patch - we decided to replace this with the [v2,=
1/2]
mm: zswap: Remove redundant checks in zswap_cpu_comp_dead().
<https://patchwork.kernel.org/project/linux-mm/patch/20260317014802.27591-2=
-kanchanapsridhar2026@gmail.com/>

Best regards,
Kanchana

--0000000000000002c5064d3ed6b4
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">On Tue, Mar 17, 2026 at 12:48=E2=80=AFPM Yosry Ahmed &lt;<=
a href=3D"mailto:yosry@kernel.org">yosry@kernel.org</a>&gt; wrote:<br>&gt;<=
br>&gt; On Tue, Mar 17, 2026 at 12:45=E2=80=AFPM Andrew Morton<br>&gt; &lt;=
<a href=3D"mailto:akpm@linux-foundation.org">akpm@linux-foundation.org</a>&=
gt; wrote:<br>&gt; &gt;<br>&gt; &gt; On Mon, 16 Mar 2026 18:48:00 -0700 &qu=
ot;Kanchana P. Sridhar&quot; &lt;<a href=3D"mailto:kanchanapsridhar2026@gma=
il.com">kanchanapsridhar2026@gmail.com</a>&gt; wrote:<br>&gt; &gt;<br>&gt; =
&gt; &gt; This patchset first removes redundant checks on the acomp_ctx and=
 its<br>&gt; &gt; &gt; &quot;req&quot; member in zswap_cpu_comp_dead().<br>=
&gt; &gt; &gt;<br>&gt; &gt; &gt; Next, it persists the zswap pool&#39;s per=
-CPU acomp_ctx resources to<br>&gt; &gt; &gt; last until the pool is destro=
yed. It then simplifies the per-CPU<br>&gt; &gt; &gt; acomp_ctx mutex locki=
ng in zswap_compress()/zswap_decompress().<br>&gt; &gt; &gt;<br>&gt; &gt; &=
gt; Code comments added after allocation and before checking to deallocate<=
br>&gt; &gt; &gt; the per-CPU acomp_ctx&#39;s members, based on expected cr=
ypto API return<br>&gt; &gt; &gt; values and zswap changes this patchset ma=
kes.<br>&gt; &gt; &gt;<br>&gt; &gt; &gt; Patch 2 is an independent submissi=
on of patch 23 from [1], to<br>&gt; &gt; &gt; facilitate merging.<br>&gt; &=
gt;<br>&gt; &gt; Thanks.<br>&gt; &gt;<br>&gt; &gt; What happened with &quot=
;mm: zswap: Consistently use IS_ERR_OR_NULL() to<br>&gt; &gt; check acomp_c=
tx resources&quot;?=C2=A0 Still relevant?<br>&gt; &gt;<br>&gt; &gt; <a href=
=3D"https://lkml.kernel.org/r/20260314051632.17931-3-kanchanapsridhar2026@g=
mail.com">https://lkml.kernel.org/r/20260314051632.17931-3-kanchanapsridhar=
2026@gmail.com</a><br>&gt;<br>&gt; We decided to drop it (and patch 1 here =
kinda sorta takes its place):<br>&gt; <a href=3D"https://lore.kernel.org/al=
l/CACpmpoeo0LhxkoA5Wx6q+9=3D2scn_az0u=3D3bar-JgBvTA-ZBkZg@mail.gmail.com/">=
https://lore.kernel.org/all/CACpmpoeo0LhxkoA5Wx6q+9=3D2scn_az0u=3D3bar-JgBv=
TA-ZBkZg@mail.gmail.com/</a><br><br>Thanks for the clarification, Yosry!<br=
><br>Thanks Andrew, for adding the two patches in v2 to mm-new! Thanks also=
 for obsoleting the &quot;mm: zswap: Consistently use IS_ERR_OR_NULL() to<b=
r>check acomp_ctx resources&quot; patch - we decided to replace this with t=
he=C2=A0<a href=3D"https://patchwork.kernel.org/project/linux-mm/patch/2026=
0317014802.27591-2-kanchanapsridhar2026@gmail.com/">[v2,1/2] mm: zswap: Rem=
ove redundant checks in zswap_cpu_comp_dead().</a><div><br></div><div>Best =
regards,</div><div>Kanchana=C2=A0</div></div>

--0000000000000002c5064d3ed6b4--

