Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C3BCCD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 20:20:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CC566B0005; Thu, 11 Jun 2026 16:20:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97D456B0088; Thu, 11 Jun 2026 16:20:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86BB56B008C; Thu, 11 Jun 2026 16:20:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 743526B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:20:26 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 815971407BC
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:20:25 +0000 (UTC)
X-FDA: 84868749210.04.EDA9235
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	by imf03.hostedemail.com (Postfix) with ESMTP id 96E4620002
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:20:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Dwo3JVfB;
	spf=pass (imf03.hostedemail.com: domain of saileshnandanavanam@gmail.com designates 209.85.222.53 as permitted sender) smtp.mailfrom=saileshnandanavanam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781209223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jTgZz9d/5AySShYbNQVJQTTJ8f/ObprCMIpsP2JIlMU=;
	b=gM6GdBmWWi5Y8xh/LBrEyR3QE6iYk70Pr73PoMyEgNqjdOa5W71+2ARt2BxMSKIp/yRmU/
	yHWDk4vq3bbUDDu78hwIXIGXf1y0t0rM/LQ9hNsVRxgTKNQQvHV+SbpEo0nozOhw1mUhhM
	VIgj0YIsNqAWYABmQSt97EEFa0EeEt0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781209223;
	b=bdjscFYi0XcHAjqJjMVO2fcEswhfaM0DOKq1hovTGHotPOt3bDbDx0qTMF23fP+tnUDZLw
	MhnhnXltZi2pG5F5PQdY+MrvP2czLiBMY62JN7rbaKBCia+S6pJw1RofodCZoOupxtmw8B
	o0YPGryKLnTBkEsfQykty0Bx3504s7Y=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Dwo3JVfB;
	spf=pass (imf03.hostedemail.com: domain of saileshnandanavanam@gmail.com designates 209.85.222.53 as permitted sender) smtp.mailfrom=saileshnandanavanam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-9642106b291so5402241.3
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:20:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781209222; cv=none;
        d=google.com; s=arc-20240605;
        b=kJF0jna58YFASBQ+WmlZfeF1dh9b+6qIOBaEa0Hv4/uD5VggwLycsfmFp5tM5jh6E1
         EVJd52jQUkKi0A2r2Lp4w8btQm6WXh1dAkLh2Y5oQ2y6ynp3VrkZeBVCebQlvvun5hJ2
         zdCNFZu/3scZZHO3PjsmdX8P2VGUhQOugJGfzSW50PwfL9T3oJw931H/X6ybdnG+xrLa
         +I8lYNpYM+7M9+zKnqLzYhYvE5d99feRsQc3GsHk+cAczHB2ckVDhVjUV1tQ2zFqKZXB
         oIBGzJ6+KtNT4kXKLI/HjHSHT3HxfwmB/oD5NLf8HdyuQnnJwCuBNxYARWBiq7/6eKlU
         Q3Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=jTgZz9d/5AySShYbNQVJQTTJ8f/ObprCMIpsP2JIlMU=;
        fh=eVgcngH0xjKZ2iqctvIA8VQO/8S7gFov18t11dw+jgY=;
        b=Vh80s5/4v/gJD0oxAvw1EG8GElmKM+ueRY0wilhkbJh5ytDhtLQ2AScqTzoRCNX3Rg
         SwTn+SkEqSUOFIJ+8NEbcIUAePX3+ODoqFQqkrBGnVLU4Mf8iW3oziEMH0VftwDemo7/
         EkPvcQ25rzxDWg1TOt78F1UcR29a8sDrDpyky4LmdqZKiShqksqbyYrcUoT734+E8jaG
         j5rEA5kVs5ZgpaPtRI2IfHMp7oudwqIMG8e4TqkNySaQEOBSKgXUYBy+4LlqopqlKolT
         jI7WWxFa/Z0na4GSVSBRqmXcrjj5e3zpm/UCepUGFVoQnFfjK6oeqr2Bcac1/DBFMC41
         zI3Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781209222; x=1781814022; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jTgZz9d/5AySShYbNQVJQTTJ8f/ObprCMIpsP2JIlMU=;
        b=Dwo3JVfBAWTWlsSzAWerMqBt1msvpcJIM6kgslRU5REBma7i/UtTiyiAOPRiFW3O2h
         D8V4/podD1WJJh7Ud6nRaaJ7pOFVe636zSWgGq7UoiKc1dvHsi1tNQL7lm2Mlw/PNivQ
         7VL5NrEf1DRmJHV765KXmtSe8oMmd2/ogztQ9AV2YIDQcVjniZs0tRpPGHi6YzkBiDX0
         pxCMl4fv8N4tggjv6h35HRawaBrcv50PmaHPUcUHxP7d5AVMvZ8/Bqy2Gnc6w1WV0mGb
         jfQNF07NjjWHeEfNFCfwRM6cV5EVSMabBggJiw+2shddDzzStB2p+PB9aLmKLBKBToTl
         8rcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781209222; x=1781814022;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jTgZz9d/5AySShYbNQVJQTTJ8f/ObprCMIpsP2JIlMU=;
        b=cdvI7oFyHtm6osBHOsqeNyH1mxudgo/dUHDUA8CnwAQ0MOBuzhOeb1ui725j9CYImo
         xSD2cKPjzepUNM+mXO7hGB2ob1vuRwqlIdSvcToB8sT9PNbK1paTiPvtVtSi0qxjqK5o
         RGMyVp360CJ881YzVO1dzU+chYd9j4FgaTVJhto1F/u+dTp+KX/qKYMTRnDLH0kKFTdy
         jE0S57enSOLJmRGDQ7t+vhOhPmFrxowOCuRbk1X7C+EoH+tqY/85fbe45dTDDJM+cb4F
         uLHgaBieS1zHjzHrWJGSf1vMkA1SEs4iPj+q7IkoVcFmTMg+ZNe/0MKXP/J9C0MoaUBx
         jzgA==
X-Forwarded-Encrypted: i=1; AFNElJ+Ggl2JFQUYKE0qsluvjZoW2KzXAQWr9ou5TCchHgkcXwrZmGNfoT8m7aXDPLfZVpdJS5kiPtXAxg==@kvack.org
X-Gm-Message-State: AOJu0Yw5oEl/3/4b+ug3weMCiwWf0Zs9mZzMmkUR4NiOlsGuEjsolgJm
	Zi1Cj46DAXfpQdoqxDEAC2ldyWUz+NjC6mfJULBaHbT51oXddRGDhiIXtfWVoj/NGxG4bXru1UB
	Lgtae+eyIeTDJ1IZJFKRQ3HoNuMzPV9g=
X-Gm-Gg: Acq92OGbax/eG/GLYVhPG6rNsOUl1XA41SI6tMOly+iXumnAd5W+cENxB9tbmh8iSuF
	QXz4oSR5dMmZWR+J5Y6/y4p9A3IDkEt75V5QhM5Mb/AEpz5JF9Wuae1xWodY8nlh59mgutz45+Z
	hLWK6pFALKqfm3yTS2z6AhAVmWSUCkayu/ZN2WJcylTvuz1kseg24gEeBnEVQJq6Zntj6plQe8y
	t/8NV2mGBF/bkQfNMD0rXsBQZADTEL/h++QiB2DrM1crc5BUHb0f311tJ/yU2XmQZvhGckXx+Hx
	sruQ5eyH58zyAeG8VpLc
X-Received: by 2002:a05:6102:160a:b0:631:bcfa:39d2 with SMTP id
 ada2fe7eead31-71d5d79f815mr1061435137.6.1781209222498; Thu, 11 Jun 2026
 13:20:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAF+TLO0TOKr3nef9RnbBuZ8A-jNpV1po26t1BO6JbSqMhfABvw@mail.gmail.com>
 <20260606003627.88973-1-sj@kernel.org>
In-Reply-To: <20260606003627.88973-1-sj@kernel.org>
From: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Date: Fri, 12 Jun 2026 01:50:14 +0530
X-Gm-Features: AVVi8CfXgkt3MDA0yGcGzW10j5Rf1FJusMcuou_cvpTTN3oskE_6uf75VOmvzn4
Message-ID: <CAF+TLO3a2MBVp3-7jm3BPjuT8jhx4yzdWxuA_QPQ9YPVEj0XZw@mail.gmail.com>
Subject: Re: [PATCH v2] selftests/damon: add regression test for damos_walk()
 vs kdamond exit race
To: SeongJae Park <sj@kernel.org>
Cc: shuah@kernel.org, damon@lists.linux.dev, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000fa4edc0654001686"
X-Rspamd-Queue-Id: 96E4620002
X-Rspam-User: 
X-Stat-Signature: zeigoptmf1ohsa488j51wkbn3g8pa3be
X-Rspamd-Server: rspam08
X-HE-Tag: 1781209223-859146
X-HE-Meta: U2FsdGVkX1+36WoESTRdiShq/s2YYmdGDDmmr0GWNXzo6mU/DtWMOZ1VGlELqBLGLg6ei9bOH0fAcvkGjSIkEXndHi+6FTFct37fOenhlUByNASY0QQD45JExy3X1WxXHeObZk0zsvv/OMS38Jo5qmdvnj8mXm//ptVOn6xFz4uZ8A5w0jksdLIrglBgqtogT0AACR0EPLVDcPTu+POGTcSHQsD4ncEOBdXO67/GLC0HrnpBa6e0mphRzULL6LaykRUXcSc9ylpjTAe3jvsyuSUmD42GPVHoH4urOQPWFo2FzKnBIJnis6glHsIle4+OA9MkePRx+lEg6rpKEGDyoo8gvXDJP+rdvDhMbuTDzKZXG8rmHdeUdXTiMNx4p7QQQXfYhS8iccmps8TnomsRhn0h4VjYu5gPDPoGU5ezxl8FawAkiACAMPlQoUvs7Crt8YKt0HbyFynvDDwDLg/yVZTZX8AcbdYuyUn+8a7q3/8fRtY4bNsesoJLFa2HWNTJ7mcDgbn99nvEvV5LKe91ps2hzeFUCwqqBSL/vr1GAk67t5m/RXghZiHGBfgHQZ/lIcl8GeJcJFlvcIF4wVoCx4yXwLsYg2sT0PlrEfjsCx2UQYdvqgNWRJX9co8sejZ+JXdztVARfPwAHKaEOKJjLxhiDMuJbCxnmvU6f8t5SD9EyEYtR3OrgePgGx1ijiz6isi08/HmSqLMqwk/IFM/zPfMmlOSGQz5qqLqYozAULWaGeRXxaZl0VxtntOudjgA6OU4ltzYNQGwSC7fUhYdJAS+b1Sw3VRD+NqfGAymCpgJiTYnEsUW/CYWvFDlfDwsnYmPyOsIQiG6oZwpSSczPV5oZvo0ZPNAi6eBCaQvR4s723KoRhWl90tfD3+i6vu1qDaq1WU5xlqfRzz53z3lCvtmsbNwLGHRW2ON/SgRli0pUnxBrg1SwyfHGizvDmfsvNWYY/zkullyFf4YsVR
 ZJOptxQ/
 MK6jmtRFr+Sh6yr1qL1R8uKoRcMhtrv3HmvpI2A/b+KaVKkUUAGLGReQ7Ce+3LN+tsfzbONOXdJxy/A8fdkFN1XvpGXkW53SxdC/eRjdu8Sj1fbrWsRPG2d/XM9RosQtXPxylBhoxItPiVp7MCRsnrLTLNqNdzZv3gxG8v9gpc4XOdKmg2P7+epVMo0QPkAx0HpkkeVGg65TCPnGPaf6Xwkf3SktP271se1oG96wlaMfl3RstpiuSRwWUtx9ORQDLTgAHfZb0pGqC5clW/hL8YghIbo8B34ICMVQCXoE0OC+hkch/sN+Vz4cU+GbciPbn+j8TZox2XFeXJGZQNZ1v67ACHT+YWe320fteQcrk4mjInD/nUtLktJZuOH65biyCuWi8B16s0YJQfsDXmpUh9ak2IeW4v5u3/yktBpbC9yyjGFw/bGajFHoYMdBn0dde0rpVSq0Snxd19zbNFfoQFLe2zj60JoActIhP9vYsJGm+EWpx5awPnx4oajLkApZd5UfowiucjiuIwfpDumpQI7E2N/4QpP08P2UJIGNuWnenQUE5frBpNARWe5ZTfiHlIKaSOyGvefNsIlU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000fa4edc0654001686
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello SeongJae,

Noted on inline replies - I'll follow that format from the next response.

Following up on this thread with progress.

As discussed, I dropped the userspace selftest approach since it cannot
reliably trigger the microsecond-wide race window.

I wrote a KUnit test instead, added to mm/damon/tests/core-kunit.h:

- Creates a damon_ctx
- Sets ctx->walk_control_obsolete =3D true under walk_control_lock,
simulating the state just before kdamond_fn() exits
- Calls damos_walk() and verifies it returns -ECANCELED immediately

I built and ran this on a kernel with commit 33c3f6c2b48c ("mm/damon/core:
fix damos_walk() vs kdamond_fn() exit race") present, and the test passes
along with all other 28 existing damon KUnit tests:

  ok 29 damon_test_walk_control_obsolete
  # damon: pass:29 fail:0 skip:0 total:29

Since walk_control_obsolete is a field introduced by this fix, a kernel
with the fix reverted would not compile this test (the field would not
exist). So the usual "fails before fix, passes after fix" verification does
not apply the same way here - the test directly validates the new
field/behavior introduced by the fix.

If this approach looks reasonable, I plan to send v3 with this KUnit test
(replacing the userspace selftest from v1/v2), along with the commit
message format and other minor fixes from your earlier review.

Please let me know if you'd like any changes before I send v3.

Thanks,
Sailesh

On Sat, Jun 6, 2026 at 6:06=E2=80=AFAM SeongJae Park <sj@kernel.org> wrote:

> On Fri, 5 Jun 2026 12:44:50 +0530 Sailesh Nandanavanam <
> saileshnandanavanam@gmail.com> wrote:
>
> > Hi SeongJae,
> >
> > Apologies for the delayed response.
>
> No worry!
>
> [...]
> > I agree that a KUnit test is the right approach since it runs inside th=
e
> > kernel and can directly set walk_control_obsolete to simulate the race
> > condition reliably without timing dependencies.
> >
> > I will drop the userspace selftest approach and write a KUnit test for
> > damos_walk() functionality including walk_control_obsolete. I will veri=
fy
> > it fails on a kernel with commit 33c3f6c2b48c ("mm/damon/core: fix
> > damos_walk() vs kdamond_fn() exit race") reverted and passes with the f=
ix
> > present before sending v3.
> >
> > Regarding other feedback:
> > - Will use correct commit description format with subject in brackets
> > - Will remove the Fixes: tag
> > - Will add blank line before _damon_sysfs import
> > - Will add changelog and link previous versions
> > - Will share revision plan and wait at least one day
> >   before sending new version
>
> Sounds good.  Please consider using in-line reply [1] from the next time,
> though!
>
> >
> > Please give me some time to study mm/damon/tests/core-kunit.h and
> implement
> > this properly.
>
> No rush, take your time.
>
> [1]
> https://subspace.kernel.org/etiquette.html#do-not-top-post-when-replying
>
>
> Thanks,
> SJ
>
> [...]
>

--000000000000fa4edc0654001686
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello SeongJae,<br><br>Noted on inline replies - I&#39;ll =
follow that format from the next response.<br><br><div>Following up on this=
 thread with progress.<br><br>As discussed, I dropped the userspace selftes=
t approach since it cannot reliably trigger the microsecond-wide race windo=
w.<br><br>I wrote a KUnit test instead, added to mm/damon/tests/core-kunit.=
h:<br><br>- Creates a damon_ctx<br>- Sets ctx-&gt;walk_control_obsolete =3D=
 true under walk_control_lock, simulating the state just before kdamond_fn(=
) exits<br>- Calls damos_walk() and verifies it returns -ECANCELED immediat=
ely<br><br>I built and ran this on a kernel with commit 33c3f6c2b48c (&quot=
;mm/damon/core: fix damos_walk() vs kdamond_fn() exit race&quot;) present, =
and the test passes along with all other 28 existing damon KUnit tests:<br>=
<br>=C2=A0 ok 29 damon_test_walk_control_obsolete<br>=C2=A0 # damon: pass:2=
9 fail:0 skip:0 total:29<br><br>Since walk_control_obsolete is a field intr=
oduced by this fix, a kernel with the fix reverted would not compile this t=
est (the field would not exist). So the usual &quot;fails before fix, passe=
s after fix&quot; verification does not apply the same way here - the test =
directly validates the new field/behavior introduced by the fix.<br><br>If =
this approach looks reasonable, I plan to send v3 with this KUnit test (rep=
lacing the userspace selftest from v1/v2), along with the commit message fo=
rmat and other minor fixes from your earlier review.<br><br>Please let me k=
now if you&#39;d like any changes before I send v3.<br><br>Thanks,<br>Saile=
sh</div></div><br><div class=3D"gmail_quote gmail_quote_container"><div dir=
=3D"ltr" class=3D"gmail_attr">On Sat, Jun 6, 2026 at 6:06=E2=80=AFAM SeongJ=
ae Park &lt;<a href=3D"mailto:sj@kernel.org">sj@kernel.org</a>&gt; wrote:<b=
r></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex=
;border-left:1px solid rgb(204,204,204);padding-left:1ex">On Fri, 5 Jun 202=
6 12:44:50 +0530 Sailesh Nandanavanam &lt;<a href=3D"mailto:saileshnandanav=
anam@gmail.com" target=3D"_blank">saileshnandanavanam@gmail.com</a>&gt; wro=
te:<br>
<br>
&gt; Hi SeongJae,<br>
&gt; <br>
&gt; Apologies for the delayed response.<br>
<br>
No worry!<br>
<br>
[...]<br>
&gt; I agree that a KUnit test is the right approach since it runs inside t=
he<br>
&gt; kernel and can directly set walk_control_obsolete to simulate the race=
<br>
&gt; condition reliably without timing dependencies.<br>
&gt; <br>
&gt; I will drop the userspace selftest approach and write a KUnit test for=
<br>
&gt; damos_walk() functionality including walk_control_obsolete. I will ver=
ify<br>
&gt; it fails on a kernel with commit 33c3f6c2b48c (&quot;mm/damon/core: fi=
x<br>
&gt; damos_walk() vs kdamond_fn() exit race&quot;) reverted and passes with=
 the fix<br>
&gt; present before sending v3.<br>
&gt; <br>
&gt; Regarding other feedback:<br>
&gt; - Will use correct commit description format with subject in brackets<=
br>
&gt; - Will remove the Fixes: tag<br>
&gt; - Will add blank line before _damon_sysfs import<br>
&gt; - Will add changelog and link previous versions<br>
&gt; - Will share revision plan and wait at least one day<br>
&gt;=C2=A0 =C2=A0before sending new version<br>
<br>
Sounds good.=C2=A0 Please consider using in-line reply [1] from the next ti=
me,<br>
though!<br>
<br>
&gt; <br>
&gt; Please give me some time to study mm/damon/tests/core-kunit.h and impl=
ement<br>
&gt; this properly.<br>
<br>
No rush, take your time.<br>
<br>
[1] <a href=3D"https://subspace.kernel.org/etiquette.html#do-not-top-post-w=
hen-replying" rel=3D"noreferrer" target=3D"_blank">https://subspace.kernel.=
org/etiquette.html#do-not-top-post-when-replying</a><br>
<br>
<br>
Thanks,<br>
SJ<br>
<br>
[...]<br>
</blockquote></div>

--000000000000fa4edc0654001686--

