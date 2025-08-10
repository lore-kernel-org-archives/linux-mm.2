Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFA67C87FCF
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 05:43:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FFC76B0092; Sun, 10 Aug 2025 01:43:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 589E76B0093; Sun, 10 Aug 2025 01:43:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 478776B0095; Sun, 10 Aug 2025 01:43:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 32B7C6B0092
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 01:43:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9F29C16044E
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 05:43:31 +0000 (UTC)
X-FDA: 83759755422.08.60FABBE
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	by imf10.hostedemail.com (Postfix) with ESMTP id C17EEC0008
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 05:43:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Cyrpk22p;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.167.175 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754804609; a=rsa-sha256;
	cv=none;
	b=O6dOfhMe6HZH+OBh3iWwWMRSaspdYZHbaLQa72LMb9NH6PO4zzbmKqk+hZX+qdK462mdOR
	MHQnoPMOjJZrDGLj5745sRB7GawyD3OsNqdmFVMjL18Yb2T3XRGSLIYEklPfcGxgQ3josC
	7UAxOIQytfkaGQTqVGBZZvxVdJjTb68=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Cyrpk22p;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.167.175 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754804609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1VF7q0WLeklegOu3HyhvX8CcabjELygMV30fjl5+vF4=;
	b=OiAMI6u5jbH1cJTWLAqxJc6JkecjNQI0QWln/gML6I7OYdNulKEFnSRcblfAVH3uRb6SUv
	LiIyyedKwSFWfRCMHcyYAHi9D2GoWx1xpdvrmPxCFpv3cRMbPcsjwuX8cGOrE/dBAFuHaD
	awMMUY+NMy9j8LO6DcQkp/Fi2w0clfE=
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-433f78705feso1189757b6e.0
        for <linux-mm@kvack.org>; Sat, 09 Aug 2025 22:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754804609; x=1755409409; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1VF7q0WLeklegOu3HyhvX8CcabjELygMV30fjl5+vF4=;
        b=Cyrpk22pUDi10vpZiDuwb8kEEBWY/G2ucZMGfuH0gpiwhNTFj0hx0s+xrBEGF68UPt
         Dtzukyw8JEuh0gMTDksG6T7qqBrgvc99488V7dZTZmyYxI6yesusot97IBOS5GAqDO45
         A/zM/BL0RRP6FOUryonetobzt1CMJFq/SISifFBR6KtAdMpUCHc2Ig/R8q91fp4djStJ
         lCnkRHioHrw5fgtx33UW1dejPKj6x4Yvb7AAH8b5pL8BzoEPq7MurwMBfwIct4pwM21C
         J9VTt6t0F7Mm1gx1WACUPZZ8OVgUL0p+bXGAMjP8XtOz4Xw5BzqQtS45SU20gfYiGoo4
         AmyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754804609; x=1755409409;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1VF7q0WLeklegOu3HyhvX8CcabjELygMV30fjl5+vF4=;
        b=sfeh1j8BccUMeCkgS3rYZaokegeltCuKzQnh8nhOYu9gLGbUQUp1zW3h9En+IuDmz0
         rrYatCBB+ZxfZ4SxdGnDk8JzfRrCsoJByH/KfkoSBJ3ikS7bgxGwijPQkLoeTaUEntAm
         PlvmQ3Zb7YB5uMnzVTNy6nERmGcoGcYMSvrbyKDwAiDomQnAUdBApwK/LqtYogXl9f0q
         iM/7d7dYThnj4WOLejy9uX5aVuzTHeObDvONsZtwXaxqephKomzJWI9HyCqjs8/vk5sQ
         9JDxFqqK8PRG29GD0gDOI7EMldpYCK0BmipO3aPtl6VTpztO6aZRi62P2RworeT9sL7s
         E3jg==
X-Forwarded-Encrypted: i=1; AJvYcCUYXvF66Lj5eDN9jSC1oj6pF70mD8rEs7Jz+qOPZsy2TO0BBaGYXczYsnpWaB29TECbpkHLRtoVWg==@kvack.org
X-Gm-Message-State: AOJu0YzaFDQUjLeh2J3UsPFP8Q79rpB8BolDdX+lcTWSQavZdX9KZ35O
	4uBaYTdog6sKLkmiQ+SPhnKsno+uYSE9mlDUPMh1NWg8SUxQ21vgYKSJHs9rPfp1X+cCS0tTNbg
	N3FCyJua1t6caKTjruCooaunZVxH9wxfP04NvL093nA==
X-Gm-Gg: ASbGnct3hXbv5oGAkHxkVehkRFdGqA2JzpvT4nRvLhcMi/+WhOL2KRON3+qAB8AK39B
	tkSIV+2e1htMg0JQMb8xZTv26HXUYqxEpNGHn/SNwGjA/6v2mgyWdcElFfLcCK/Drrpdz2A5LWu
	srjga1jVPHwtcQDXm9NDDl+8DLsCsO5dRIaQsa4O2O9S3RDdOv3DfImEpE3eGwTxGenGZ/iO4SA
	Wigc4w=
X-Google-Smtp-Source: AGHT+IHJxGMU/wk8QP5vJyCNj2dWjhPvgi4dMUxGNQQj6i6HmeNlJ8gTWRRCGf/0ap7DyAgfXV1rAyxSCplBWIqXv2A=
X-Received: by 2002:a05:6871:5b21:b0:30b:9750:3085 with SMTP id
 586e51a60fabf-30c20f8d5f8mr6278198fac.10.1754804608515; Sat, 09 Aug 2025
 22:43:28 -0700 (PDT)
MIME-Version: 1.0
References: <CABFDxMH0LDLLdJf-t2DEHCD40EJDfcq35cJM-HS5GkLX7KqsHA@mail.gmail.com>
 <20250809173559.71327-1-sj@kernel.org>
In-Reply-To: <20250809173559.71327-1-sj@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Sun, 10 Aug 2025 14:43:17 +0900
X-Gm-Features: Ac12FXwPPpoJ3Atc3Fc0faMpuO09tCnt-cxUYqEXvY3Fy45GYsSbzi1FInUggjA
Message-ID: <CABFDxMG-2+VQvWNHqCLKy4jZXBJzsWPS9DOkV-gfYovF5Xo-Jg@mail.gmail.com>
Subject: Re: [PATCH 1/2] selftests/damon: test no-op commit broke DAMON status
To: SeongJae Park <sj@kernel.org>
Cc: honggyu.kim@sk.com, damon@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C17EEC0008
X-Stat-Signature: 67hib6n5ox9y3t3zpfp4hzry4nnwgnpq
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754804609-441871
X-HE-Meta: U2FsdGVkX18d/R06P37dQRItVALTSf+I7Nfn3nUhRiMt77oMYpOclWKg5jGhQaxmZP7cPOK6GYkirsFSEWbhebi8AgG78WygOI0liBu86iF5jzjRlzvnTLTuWrqDKh3vIUQx0qRLDbZRRarx9nA8zHm8XoxeZHiU4xfUDfcfr0zmb7fz+ONVUG8X1+VmXnT3uOcEHU/pyMjparc6QO1d4r+3S3N0PlIK7EPNiqV5Cx4nz2kjaQkLMicNEpFZiUHHk8FPXuIGcMNNB+Uj864+sTopIUByq6X+WzYCvzgguDNgs4Zqxv+av3qVcLrUDlrLWruGct+rSzkwTd/9NJkjcfM9G6TyAkWekOFa4x+IaP8IbbZZHWkh96GkFrrJNReiDPi95/R+M4iCVTf2NMq/iQImVHE/0Tb8DBCvdQvB7umu7hqmb+zoNe/FsOJaNELiSoBhoXY6vOLjQCHhsLXe5QPvoa755H7b6q0hjKBgQt39P6guVu+VIAHzRC5SPcp2i6IvtlR/ngEWsGWUL3feS1j9N7SRnCDdWyM04JqH8q9sdviTKktS71+pKjTwMjxAkN5ma+mVIGWeiGV4Qwayi1BqiK+lgePRggO7Z5S90vKmLtGWee9JjVOLzF874WPXsq90I9Wl2RyeDMJ9EgMv5jj2LYOHb2bh6T1Ffi5ajGurB17n4O1p0867m0G8G9EgHhov23Za/BQYwgozT+5REsZf+qjjfyVXcTkqFEOHtNzl8ekF12F/VVGjlSa4QYxGYcgLO4rmIPLEMebFdZWm6FHeghg5yOCPyLIfFe0uPUcUdkuk74E5NJOgUHpN6woXqbrtVFup0Gz7KvYYdBEFonYWtEZ6+svgbjhDp0ecWpvEeN38py3TCULCML05nGiANM6h6tQCxu5ZB/mS4T3m2hb/WUVkzl2OdAXN83C8qmPGtpLjWTNglIVXXuYrM6PJO3MboLwsgnE9CjmD++C
 lfta6V02
 wsddgvNRCTtQRUk3cebf4h+2vxh73a76vb/zBpd9XI3HpKpLveB2V/Du/ARDuPOigLUQx6wQUpKiZ5JvpUUEMqwW35rWxtucgsAQ2kA3ZrTUgNCHHzCLg2hP+XXM/kh1UNBStBOyndxW7tx4IxIVgTZRu9zM169uj6qaPGAtGz9ckzgcrYIeKNZLhF2M7/Nkeqx5w4pXHo0V2T8OkbigEF8a6qX1hMvlBRkA7hsI9AEaF+0fD9+3pJNEEoRl9/vSUvc8tgpJx+25RmTYzqVWcmEAiKAJ5h/zae92Dp3ij60ZucXpt9ABtV7veJk9dO+apBfi62GerzhWzlJH05X/y4ihKJsdDT8K0UbAEom/Bio18Oxrfqv5cMec6OIzibSX120N7gDPZ3sEs1PsBPnl7k6Ic4mAwR/PKhCKAD2dx9rRi6sRk4iNZo4lvq5jV/ByE65Zg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae

On Sun, Aug 10, 2025 at 2:36=E2=80=AFAM SeongJae Park <sj@kernel.org> wrote=
:
>
> On Sat, 9 Aug 2025 15:39:41 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> =
wrote:
>
> > Hi SeongJae
> >
> > On Sat, Aug 9, 2025 at 7:05=E2=80=AFAM SeongJae Park <sj@kernel.org> wr=
ote:
> > >
> > > Hello Sang-Heon,
> > >
> > > On Sat,  9 Aug 2025 04:55:17 +0900 Sang-Heon Jeon <ekffu200098@gmail.=
com> wrote:
> > >
> > > > Add test to verify that DAMON status is not changed after a no-op
> > > > commit.
> > >
> > > Thank you for this patch!  I have some comments below, though.
> > >
> > > > Currently, it is failing. but after fix the bug it should be
> > > > success.
> > >
> > > To keep bisecting goes smoothly, let's introduce failing tests _after=
_ their
> > > fixes are landed.
> >
> > I see. As mentioned in another comment, I'll merge this patch set into
> > one patch. I think this comment will be resolved then.
>
> That could make the patch be unnecessarily difficult to apply on older ke=
rnels
> due to the test part.  Please keep those separated.

Oh, I misunderstand your previous comment. Now, I understand your
point. I'll separate them back and make two v3 patch(one for fix bug,
one for test) not a patch set.
Thanks for the explanation, I feel like I'm learning more and more.

> [...]
> > > > +    if rc !=3D 0:
> > > > +        return None, f'drgn fail : return code({rc})'
> > >
> > > Let's not add a space before ':', for the consistency.
> >
> > I see. I made so many mistakes like these; (I worked this very late
> > night...) I will fix them all. Thank you for checking this moment.
>
> I'm sorry to hear that you had to work on late night :'(  I hope you to h=
ave
> sufficient rests.

Never mind. just I went with that :) Thanks as always.

> [...]
> > To be honest, I didn't use kselftest framework while making these
> > patch set because I don't know how kernel developers use it.
> >
> > If you are okay, could you share how you use it?
>
> Sure.  I do below for running DAMON selftests.
>
>     $ sudo make -C tools/testing/selftests/damon run_tsets
>
> You could also run DAMON kunit tests like below.
>
>     $ ./tools/testing/kunit/kunit.py run --kunitconfig mm/damon/tests/

Thanks for sharing. I'll try it with my vm environment.

> I usually run all those together with additional tests, using DAMON tests
> suite[2].
>
> > I just build kernel
> > with custom patch, and execute output images by vm, and setup env,
> > then just execute tests(it's so raw.. i know)
>
> It's ok.  No one fits all, so different tests are needed for different ha=
cks.
> Please keep using whatever works best for you :)

You're so right. Maybe I just want to learn some tips from the experts. hah=
a

> >
> > Maybe is there a kernel build option that automatically includes tests
> > to output image? Or just a general or smarter way to execute the whole
> > test?
>
> To be honest I'm also not an expert of kselftest and kunit :)  You coule =
refer
> to the kselftest documentation[1] for more details.

Thanks for sharing!

> [...]
> > Thanks for reviewing! Have a nice weekend. I'll do this job after my
> > personal schedule finishes.
>
> No worry, take your time and fun! :)
> [...]

:)

> [1] https://docs.kernel.org/dev-tools/kselftest.html
> [2] https://github.com/damonitor/damon-tests/blob/master/corr/run.sh
>
>
> Thanks,
> SJ

Best Regards.
Sang-Heon Jeon

