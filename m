Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C0A3E8FDD0
	for <linux-mm@archiver.kernel.org>; Sat, 27 Dec 2025 11:25:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA7246B0005; Sat, 27 Dec 2025 06:25:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D545C6B0089; Sat, 27 Dec 2025 06:25:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C609C6B008A; Sat, 27 Dec 2025 06:25:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B36EF6B0005
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 06:25:32 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 515A913AACD
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 11:25:32 +0000 (UTC)
X-FDA: 84265020504.29.CF80345
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf10.hostedemail.com (Postfix) with ESMTP id A9547C000C
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 11:25:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b5dkIrX2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766834730; a=rsa-sha256;
	cv=none;
	b=LrgQiu8R+vUozHnFl2NTmlepqqVn2yuBXiSoUTbw46xnDjAjMTHnzWSchTU4luf1ZCeVL6
	cRmvG/BgvDRacar1raK94FtpziQmxwfyoyXIYxDUhFiNMU2fBmLYbU9mhaaSyKER+z5lMr
	bPopFzS835WmbKq4nh4lycwt72ylp3s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b5dkIrX2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766834730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jU96kxHK8UBwX44kLdo1fXEX2IjFku/uBhX2drbYBY4=;
	b=mEcQWrQqEGrvkGsOpoYZbh1RNRB6Pf0EVNCaSuJOpHsSaZCb2+6yNDpYhikeb4Ka9w8WSg
	9H3Wgt/7VHylJGwHSq4C8ZH0FUbDseSJigEmyJ0QeTBru/f12iK+E4clto2uMVK+hjrvZ+
	E7v8S9GCmm83QNcHxJ73iTOtrVR+otA=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-88a347c424aso106141656d6.0
        for <linux-mm@kvack.org>; Sat, 27 Dec 2025 03:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766834730; x=1767439530; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jU96kxHK8UBwX44kLdo1fXEX2IjFku/uBhX2drbYBY4=;
        b=b5dkIrX2HmdKgl5ioIlkqLixkVXHdxABaQN8T3bqPtyaJSR9fnY6KE9/UvWFqlZ9ci
         JkkMARw1hl/mLox/sJN9mDtP25bEuyiWmEuRaRAPVIXGZ3bB8J90AVWbQUin+XeeyWTU
         8idtRv/P2mywHozJqeTHTAVny26mUd9asHXtl07Ok2P34BdYL7qe41u5SUy3EPY8fH7l
         wqjXZJCtwYruS6aabaAGjosuX9O3BRIN4EaHP5F6ZiPSEjqMc/PrHNB9AFIyBnLarmI8
         SZPJ3vxzfPF3SlGuI/cXeouHZFYdBkYgqALZXTXQRqYX4+2bfqIzhFNnpXAMLO+u+vJm
         0Q/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766834730; x=1767439530;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jU96kxHK8UBwX44kLdo1fXEX2IjFku/uBhX2drbYBY4=;
        b=pnwdwotLU8INTcogz7SQkGV02Jj5H0zYFPfqXHCL6DT0fXZ3R0hQKnz6xDfF+8k1GQ
         AfQYs2a0DHtvfcXk1MbfIi4aZYwIDGcDxCoBVAjtcO3ZTqgJN7GcFP4oR0gi6rjIVyal
         +agctNFpbbU4YDBXJbYslrH7zWSFJbJl7ZNoQhSrZ/gGRgO7VeIZupzkHN/b5Vse66vR
         +Q9/QrdQpagYBoALlRfwgCamDeS+En6Q8xZNnr5o22H7Wk4PsvgrrAkexf8UBzJ0zhn3
         X37v218QdC5IoEnVG+yEsmaaQVpEpq4JQh682aFGBT/gDWYJbJLLyvp3+VtnHaYiWARG
         I3nw==
X-Forwarded-Encrypted: i=1; AJvYcCUTE2YMhIWMKjQnMstaz/ys+9KkdcxiMSxzDogO4Fc4Nc7nAHU9dyKt6pQgeXM9YiPvMJb4VDsIyw==@kvack.org
X-Gm-Message-State: AOJu0YzAlrxgSzZz0YAz9wZVdVK3wheaT09ZjaAjZrXXyypy2VXxCWbN
	O7Furu1EYZiK9Qn4pe1lO2ZXQMiAR5S+pQpwDbLtYPvIs/+P44zuTQ1XWm9xrewEaT4j8VHSmvQ
	zxdW6GAFqZHrG+V0rhHibbEZIT6pByi8=
X-Gm-Gg: AY/fxX6kEOU3rMnQSuZL1BvweMsEFdC5pYG3oQqz12jCXrllC1s98NHHU/0ZFDAVWUr
	hKEF7vxs4SB7tplSzcCm6RIOGVT9USymI72WYgqrLiBBZj/b+rdrxQzYjm0u9/UxzIZrErXEI9k
	Lo3N6HfT14gzKirLNPyXF9rTvtyXFuqo2zNxI+tjsPcnDXGzUqq8QdZDVFxV1N1tmN5P2ABHTdM
	yxBU5vX47YKAg9N5Q6zXmoJwa8yAUNVNnugyLCX9ITFdK99f5aCqi6/mKSHXcV/PUMRfLHDPJya
	7PLN
X-Google-Smtp-Source: AGHT+IF7DHqp7ovz8RxBf5iD2/uFONnTI3+LkmbGdXdITb5Ng0lNW4tjGv1D1DagKsF5cWOlu4pfVLlnwQ4Tcoy8G9k=
X-Received: by 2002:a05:6214:8084:b0:888:626c:c06b with SMTP id
 6a1803df08f44-88d8369eb18mr352627696d6.40.1766834729551; Sat, 27 Dec 2025
 03:25:29 -0800 (PST)
MIME-Version: 1.0
References: <20251225094057.286954-1-wale.zhang.ftd@gmail.com>
 <CAGsJ_4yEAOxUmrPvca3Nzc-OB0+xXk5Y5gzszsY5TPqHCGvgcQ@mail.gmail.com>
 <CAHrEdetNrGJbogkhMKY-25fgtxupPxKKLkwFGuenV8p5EwzZVQ@mail.gmail.com>
 <CAGsJ_4wcovpuNKPTfS0STBOHrNREjP-4wam8Oe4e7_ctKsbAcA@mail.gmail.com>
 <CAHrEdeuBk_MoPj1jWdtdLODK0JOWrb2orTZ77Cbp1vZ3PM3x9g@mail.gmail.com>
 <CAGsJ_4zg_DgQnQthTqWOnwUrhm-MygVB6mOwmgK=ey2dYogb+Q@mail.gmail.com> <CAHrEdeuRtROkAN0zNdaYG_GBkSeW=-3kP3xBiQV1w51vGSc6Ew@mail.gmail.com>
In-Reply-To: <CAHrEdeuRtROkAN0zNdaYG_GBkSeW=-3kP3xBiQV1w51vGSc6Ew@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 27 Dec 2025 19:25:18 +0800
X-Gm-Features: AQt7F2o1PSCKXAPxciijstziZc_dRXLEi3BVZm7OWsGUIfq4Fn9g39EjbboPjsY
Message-ID: <CAGsJ_4xC=Fi+mHQ-e8H5f2pBYk2e54fuuqxdLmd7ZJicR2a37w@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm,swapops: Fix compile error on set_pmd_migration_entry.
To: wale zhang <wale.zhang.ftd@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, chrisl@kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: A9547C000C
X-Rspamd-Server: rspam10
X-Stat-Signature: c5wxmoo9juy6afohif1qc3ywonfykk1j
X-HE-Tag: 1766834730-863792
X-HE-Meta: U2FsdGVkX18xnNYD7kis9ttyCC2JbnsiklonL5Rj07m1LZnqbCIwX39jsTnGxGdjbioXj/kVzHpabtD9gGabH+BOiJVtKeEKdEKd4lXxDgFo+ZbCyDOZTTtXZmDhppKSvM8R9oWpiNv0mZUlpAPToN653rJ4uCE3MZ0nVuDWTx2EsT+PRX4G15D1siqVSchgwHYBTHhC8fRXeZABT+o9TEYc0LdnVqYRK2Qbi3RBXauNkIn2oFBN9XxVKK31dq4sOkJclqpKpZiXFkL6SZxHBErgiot+y3K2vrLVthG7j9zr1xuviMg3NG5ob3z/JruIH82NqnJumuAr49GtWRjRpu39/x6WJv1KH6JdxhbnJnYx71L1AUBcH+UOieiMNb1bHXa3z3MHD/Mc4jJ7sFjphdgFHZwvDFTheZ/jZrkzF9B9hpFHOC+nYoWU7mZOnF/iDunoQwPJj0K3eFjagIhLNPmY7D6Ve4EvpaPYPf+xxIBggqOi3LckQIlWh7r49oGOWs6sjmlTD8bd83X9mO/VjYciJJfK6Qu0Xrp7WfROpYoh7ZeDG7q/Fbx2WfN0QxNDVEFBLRj3TlI31bGSh7Uuhv561CjIecqg0UJ9ehFGkULw1tw2NsISKCAQ8UykHGP3b4yXOVaUV+PQr4fLwdzItt7ZTvqbsfL4pptgsu9aJhHce4p3poo+3PMqnbEiOT39Y/HyauRVgVKnP2UWrRRvGtKryImpxcf0N1uPFI1QTVR+8TIEQyiH0LCVRbQTCyaDBWxO7sc+qgfa3nY9kGWnc73You50BrNh7PPiovnaLaXT3gi+G1TNb5wO2HqVKiMT82YXaiBWtSbJc1CgQpjHXQvjZO3UxjKFa4myevfB+Va7/7pZXwn95XXXtZxfDcDtHN92CwVVDjlG8MOKrZuCuKjt0O36p0nwgixJp8KdQCWrs3eJ3jR2SAPm1EWzkWxNjjUNDY5r/768YnRQePQ
 k+JgFRmf
 L3G3LVoG7Ek+oO16MYlRQl8RL3Yqo9rqvqrzxd19+mCT381mJjilHJQbBvEGo3cv89Bc34vAWCn5b4HA+BCA/4aT80XdbFtv1M93SFrd7l7deoSeM49FdcpBdmRUenROpU6AJJdDdR/6/p83DGYs/T2bm6IuRSCux6A3Q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 27, 2025 at 5:58=E2=80=AFPM wale zhang <wale.zhang.ftd@gmail.co=
m> wrote:
>
> On Sat, Dec 27, 2025 at 4:16=E2=80=AFPM Barry Song <21cnbao@gmail.com> wr=
ote:
> >
> > On Sat, Dec 27, 2025 at 8:51=E2=80=AFPM wale zhang <wale.zhang.ftd@gmai=
l.com> wrote:
> > >
> > > On Sat, Dec 27, 2025 at 2:43=E2=80=AFAM Barry Song <21cnbao@gmail.com=
> wrote:
> > > >
> > > > On Sat, Dec 27, 2025 at 12:46=E2=80=AFAM wale zhang <wale.zhang.ftd=
@gmail.com> wrote:
> > > > >
> > > > > On Thu, Dec 25, 2025 at 6:22=E2=80=AFPM Barry Song <21cnbao@gmail=
.com> wrote:
> > > > > >
> > > > > > On Thu, Dec 25, 2025 at 10:41=E2=80=AFPM Wale Zhang <wale.zhang=
.ftd@gmail.com> wrote:
> > > > > > >
> > > > > > > ../include/linux/swapops.h: In function =E2=80=98set_pmd_migr=
ation_entry=E2=80=99:
> > > > > > > ../include/linux/swapops.h:346:1: error: no return statement =
in function returning non-void [-Werror=3Dreturn-type]
> > > > > > >   346 | }
> > > > > > >       | ^
> > > > > > > cc1: some warnings being treated as errors
> > > > > > >
> > > > > > > Signed-off-by: Wale Zhang <wale.zhang.ftd@gmail.com>
> > > > > >
> > > > > > Sorry. NAK.
> > > > > >
> > > > > > This looks odd. We already have a BUILD_BUG(), so no fix is nee=
ded.
> > > > > >
> > > > > > we should already have:
> > > > > > ././include/linux/compiler_types.h:631:45: error: call to
> > > > > > =E2=80=98__compiletime_assert_907=E2=80=99 declared with attrib=
ute error: BUILD_BUG
> > > > > > failed
> > > > > >   631 |         _compiletime_assert(condition, msg,
> > > > > > __compiletime_assert_, __COUNTER__)
> > > > > >       |                                             ^
> > > > > > ././include/linux/compiler_types.h:612:25: note: in definition =
of
> > > > > > macro =E2=80=98__compiletime_assert=E2=80=99
> > > > > >   612 |                         prefix ## suffix();
> > > > > >          \
> > > > > >       |                         ^~~~~~
> > > > > >
> > > > > > Do you actually see this being built? If so, please help identi=
fy why it
> > > > > > gets built.
> > > > >
> > > > > Hello Barry,
> > > > >
> > > > > I compile the 6.19-rc2 for arm64 with -O0, this kind of error log=
 will appear.
> > > > > In file included from /home/wale/repo/linux/master/include/linux/=
leafops.h:11,
> > > > >                  from
> > > > > /home/wale/repo/linux/master/include/linux/userfaultfd_k.h:19,
> > > > >                  from /home/wale/repo/linux/master/include/linux/=
mm_inline.h:10,
> > > > >                  from /home/wale/repo/linux/master/mm/internal.h:=
13,
> > > > >                  from /home/wale/repo/linux/master/mm/fadvise.c:2=
4:
> > > > > /home/wale/repo/linux/master/include/linux/swapops.h: In function
> > > > > =E2=80=98set_pmd_migration_entry=E2=80=99:
> > > > > /home/wale/repo/linux/master/include/linux/swapops.h:346:1: error=
: no
> > > > > return statement in function returning non-void [-Werror=3Dreturn=
-type]
> > > > >   346 | }
> > > > >       | ^
> > > > > cc1: some warnings being treated as errors
> > > > > make[4]: *** [/home/wale/repo/linux/master/scripts/Makefile.build=
:287:
> > > > > mm/fadvise.o] Error 1
> > > > > make[4]: *** Waiting for unfinished jobs....
> > > > >
> > > > > There is an example on my
> > > > > github(https://github.com/wale-ftd/linux/commits/linux-6.12/) tha=
t
> > > > > used -O0 to compile the 6.12 kernel. If you're interested, you ca=
n
> > > > > check them out.
> > > >
> > > > This is not my question. The BUILD_BUG here means this code
> > > > should never be built. If it is built, then that indicates a bug.
> > > > So my question is: under what kernel configuration would this
> > > > code actually get built?
> > >
> > > Hello Barry,
> > >
> > > I'm very sorry for misunderstanding your meaning.
> >
> > No. You still don=E2=80=99t understand my point. The BUILD_BUG means th=
is
> > code will never have a chance to be compiled under any possible
> > kernel configuration. That makes it dead code. If there is any
> > kernel .config in which it can be built, then we should fix it.
> >
> > This set_pmd_migration_entry() has no chance of ever being built.
>
> Hello Barry,
>
> set_pmd_migration_entry() is defined in include/linux/swapops.h.
> For not defining CONFIG_ARCH_ENABLE_THP_MIGRATION, line 342~346 will
> be built as long as *.c file includes swapops.h.
> There are many .c files including the header file directly or
> indirectly, such as fadvise.c, shm.c ...

As far as I understand, set_pmd_migration_entry is never
called unless CONFIG_ARCH_ENABLE_THP_MIGRATION is enabled.
If that is correct, no fix is required.

