Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F486EA794C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 00:12:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D74716B008A; Wed,  4 Feb 2026 19:12:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D22106B0092; Wed,  4 Feb 2026 19:12:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF6C26B0093; Wed,  4 Feb 2026 19:12:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ADA686B008A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 19:12:21 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4CC8C160374
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 00:12:21 +0000 (UTC)
X-FDA: 84408476082.10.EEC3DEF
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf26.hostedemail.com (Postfix) with ESMTP id 39833140003
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 00:12:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KWak43yB;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770250339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cbqBiMbQ49M69l8l8/udUstIypJQFYsZ0pw/N7ocq14=;
	b=cL57X9BiaWNUyS4WioTQzoNeV81SfbHsphCig7vzjHNGpcS0KN5QkIiuAWGvjbVm6CQq+c
	I7/KnTUTgPLnUke06CqkuPR3HY1urFF7MD/q7GADrJ+IRtnwdlAzp8NA/1l/uHcNH5YnYU
	y4d+0uLsvWQQyiBoB8GmsFtiaYUfFU4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770250339; a=rsa-sha256;
	cv=pass;
	b=wtsjFtAE03BZga7c+DRP1QYTupesrONR3nKD7McVeWgTpg3H9h5YX0yLvhfdiCoPvAa/sA
	Cx+7IqEct8D0+sYGxFlK0D2dMRNNr2tRc+27Bbx7fXXcVa+8nu+2I3pTD/J+1T1I2pxrag
	pw4ZALf0uVxNH61q/FMVkLd+13Hvhtg=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KWak43yB;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-432d2c7dd52so407077f8f.2
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 16:12:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770250338; cv=none;
        d=google.com; s=arc-20240605;
        b=eRkoyjpYt7kG6gtgq8Q7rOAaG4fRnJsUkFdZcJ2hPZB4yqJAgWP6meb0uFxbqgZTQE
         S5R3H/IdxfGSCW108jPWDywiDyUnHZCE/rdBtH76QMFuWhLsZqg/u7U7UPSbr3K0+YQ+
         hWe/bHJ0Td59ytyiDOYjIgqhOyWACVIsmTD7CMJhzTV9MWS7KOKAENk4jurk0uXhEelN
         Uvluhay8dGUiJXrz73TSkgrbxlr6w2icEf91xGeYO4/NimhTatd7wwN3AvhRn2Ir+7w4
         DFxg29wt7MMNVzf0yBurbXtYtUbLF3Ylgu9ZvSC+V1kbWOEb5wPd6+x0rJJouLQte+mO
         Xkww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cbqBiMbQ49M69l8l8/udUstIypJQFYsZ0pw/N7ocq14=;
        fh=xdxAv+MSbW7gsRcY02ycjVngbeZegoUKHMUvw7Hpc3Y=;
        b=IhcsmZRw/RPNe4AHmctbUcwQscZrhKEzJC8vC0wI27NFh8UMsxPMpXKiUq1FrxIAZt
         zgbC3aRT6TCtrnEAEP6FnOevmEIvcJlXAK9p5D6cupK6MjimjS8X35bc1WExrovWCBg0
         N9n+qP+DTqOUa/KLJ00d+mCRXI02sgVIFoOW65BxBbcNI9y8QOISCpKNuoNZm20H+5s8
         cMb4CXjlAPTxQXVcROg7UnQJLnHSPq9Pc+YToC+0UTuZR/KFnUyafgW1gY2EX7c9Bz0w
         sGhfMcOhppcmj1ywZi2huunIH8Lx4f9gsxyehuuzsyy7OFBtH3gie1v1BIksOLNWPh3M
         iE3w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770250338; x=1770855138; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cbqBiMbQ49M69l8l8/udUstIypJQFYsZ0pw/N7ocq14=;
        b=KWak43yBioXWsO4dwzozag/FxSxXLdJfnwxZ9h4Twng7f6CCcq5H0uv+jzG7kGJ/dr
         wdUtN4/s6Cfm9p4/ScvCpUUwN5Jyetdr3tPUQSmlIkgoY1NhtqIG+uddz+LxfD3wQjJp
         +OGm4G3F7SED/2dnxhPZzpsTiME3ASpCHsxO0VMt+0hIvr/bhAfmDnWaXEd8FAkgTBmT
         iUjU8mRha1GM7KUnYjwHVulzJ0qgRU41g9gmZpmZVF6A8X1MCoag4hE/HgUuwzS30Ttj
         L4VfmyVjYxPwlIJKY8bEq+GIJRV7L7IF3OdAOH745AV1iIJfJZU6QYI/eD5pUtMq1sWH
         9oNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770250338; x=1770855138;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cbqBiMbQ49M69l8l8/udUstIypJQFYsZ0pw/N7ocq14=;
        b=IgDdNectPFDGRuum1vmljIQbSF7+Zg8eStBecRfWisDEX9xdsE7ynHVVvrnbk65CaZ
         /PQSflmFHx0qyDB2eVCFuTgJ6P7TcBCSmMC3iXAyRIHpMdauTnEoxnJ3YTDszbfv/79Z
         WM9G8cRI74xaJc3nSGk3PKOLmaoE4iCGHIu+6mkhqOpBd8FiIrCHuEQ8aljt1f0QFOqz
         Q2jox92kXS9r2F9tTkRJJ0FUgnAPDuDuSO8DThogl3Sn9Tx3q6FKDMu83+U5jQuJ0Fg/
         VPWZp1/R+B+zWNPrS5uTm9qS7ZScnqUrhawIL8xfKphMdIucBmCo8n+L/gSdVds88lo0
         0uaw==
X-Forwarded-Encrypted: i=1; AJvYcCU/SlZUCMvpPzOePkHwRkYKEFhMl4sS0wWzf4HK0BaPXjSS+7dfTil/bx+7+TsQkEfpu00bCkkXug==@kvack.org
X-Gm-Message-State: AOJu0YwtDGRIchg1SQ0gxof1JmI2+5knNN9UCk2hp4m5K31ph0wE7xug
	O6KAFJt7bKL8r7r9rnDFL08Fgarzp2pB8D7dAf1p1aqHXXk5X9PFuuwT6BGh16LjNfH9xwMAXJ7
	PJ0xrQaup49BUMHtO+7Oeu7x9bIHbAhU=
X-Gm-Gg: AZuq6aIeEa22+4Pth/iEQBU77ICInRK+of9wHHuktvGUDDuuUrM8Vf7pkeHCnlG8gGs
	Q6bqR15sjRid06OsivlORnxhfd6SMirO/TQbvXFuMkxUnle0GOAvR7BFsgDYyNylajRzxe9SUbW
	uq2oo5sK2I+9qmmpbpakQLSvalwk24PqPUqUOyisMWlUBOLjVr8iSNmNwv8CZjcf6CDZ+R+cNxh
	tDFaTKcmqgbdtKRhHaLTVdJK1uuIJMjvqWYjLdvXRCjLqEf4a0o7lotC/L/zEcbUVi88tGCv5mH
	GkIWHzxDTZZCQcoKFpgquodzhsbQGITpw+zHOeC3C/UlRppqMm0nH692NdgZvDI+ITFfN1YmPFd
	10hkF4qQ3gJLWag==
X-Received: by 2002:a05:6000:3110:b0:435:e54c:985d with SMTP id
 ffacd0b85a97d-43618058117mr6974136f8f.44.1770250337441; Wed, 04 Feb 2026
 16:12:17 -0800 (PST)
MIME-Version: 1.0
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
 <20260127024421.494929-11-roman.gushchin@linux.dev> <aYA4pH_nIBZ-ZhLL@google.com>
 <CAADnVQL5g8imKNGbHGQ4HA8_qNT4MYwM8P3aCTFUG7uwiuTeuw@mail.gmail.com>
 <87jywuwumq.fsf@linux.dev> <aYH21HhwNvWnFB8O@tiehlicka> <CAADnVQ+uF4cTVYYOYBEDWrkLXJJkru_FaRttFskHRUpamktMJQ@mail.gmail.com>
 <aYMLJv64GOh7coMK@tiehlicka>
In-Reply-To: <aYMLJv64GOh7coMK@tiehlicka>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 4 Feb 2026 16:12:05 -0800
X-Gm-Features: AZwV_QiXQ7VARzO0Kw77iUD9Tf6J5RQ7jc_wSjITSQIkFU7PeCfR1uomK_hzU0c
Message-ID: <CAADnVQLF3Rrxo=0s5orrik4_A41N9ivbHswGnJSen-1VpbExhA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 10/17] mm: introduce bpf_task_is_oom_victim() kfunc
To: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Matt Bobrowski <mattbobrowski@google.com>, 
	bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, JP Kobryn <inwardvessel@gmail.com>, 
	LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 39833140003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: hjp49sp661hkq7nbaqpfkwwz11wpwjjo
X-HE-Tag: 1770250339-115828
X-HE-Meta: U2FsdGVkX182qgHApS78PsWtK1KGjgOA6IRXil75+bb1wPUaNlRYZgXQ+SHhQqO9BnwTW25r0MOz5sRI+f880XjjIBZJlt3J3EzK4a/OqvitH8l90Aw86b6OG41VZGGmgL9Wz8ITqUfB8Ox/RtGWkKA601okzoTKHHzxbwJoc+zEqPrKDsmN4pu3iyYQNdb73PWJ13pN9izMFdtotq/pRClaA87kz+BinsIAmbL7Lkics75tFZk2GfL236uYvCoL0GsgTLMUmfjiusncbFuLye/58RaxHpDwJVuGf81DHJwqHmEYDk2toXtw3BBdLNJWnL/S+RyxgTqmcuG8tz+K3n0NdnXITb+4bU1XNZTnCD7jYZ32WiD8D37aQNZIE27qdNsq/wpooORNj84yoRu/qJpe7Tg3a1DHiHzSuzB/O2bAerMgw2xqcBxcNTdKB6k2dIr8vnUdh38xvdiw8bukO35t1WWP9fww0AFiOnmjn6kwaeIyiQcpzsuD2xVKFyMNYmaBwYAz7tXGwZs4epP6pJDUuYfMjRnxk841jeQ4RzY8xXpAoptkRS9fmODZdE7tR00CVlZhy6U98C+MgXKD6BVW4P9kQc5tTFmkcChR8Ct+jJPPmpPdb2zhcwEZzr+QWoe8HxVuVPKApW+N39xlyuzDGmNgk9EOEp4kDJhnCFO2GzWMUmUlfr/C4nyvFduR9IileKAi7jqXD288qOUAIauzdc1nUV51QlOpx0n1K7kvP52AusbeKyOm7RMYQbq0RhOoPtnEnj7EjRZ3X7fBV+Y0CX5MRFbf4AMsxzV+FNxehJZk/0GD+wdc73wNxrM8iI9JN1cJPN8v2glJcOEPzjYK+CLayam5gF2ObrJE0Clu1OZGbInJMr0XFI3rXdVNPaXH6tVutolo7lOK8GBNImuDyB/098EOTj+4ZGkySs2UbmGVzI9Doq21stpQzEY5KuE3Nj6HYRp22Ke05yS
 CU/d5JJd
 iQa+uhzXCMxPysBSiZuz3k7QKlkJ8d9Uq+/VCZuFMuYQrXvdiEx75T/hx09jIlsfHi4BCB6s0GqVurN9eimTUXyYahAPxhDTSw+u9koK1jYFRw/IZ/dk0rzXRUJNUGsffv0u3FJX56NfoS/O9Kzjj3zeSVAxYWJxmCej8bNk8OYEcxPmsX27xtloVl7pR+sTJspYE08STPFqRKG3LPe9e4ZIrCHJt6veld7H0lQbet1ymxEIF7LnTjdVksq7hOnsvAnIKo7QNeEJFqIwoDqJzI2t1zaGhU9PYjAQUpvpPdJcLKxpQLHSMfTlBAqC8auw00WuHR6F4bhIP6s+fsyXa5k1ualfThEpVsQAMgHFQlKxKVrlf5DNVixl0ld53SHzKoMY5K8rr3b1+5ZCbOYSfbK5EaeHR+BBADq7aYNKPBV+HLSsEKhJVekF/Tk2z0ptfdby0Rbkbcx8Y2Xf8OW4FyYpCzKmNWlVuQtEsUaHsZR7T2APNMQHKJHgx64E864K6XBw+lrU/6j+60pxZIXILvuVqVg10Hshn2dI9bQ2OVRnIuma52vz7QGWH4V0zePm2BydsVHKiWwwaAAOUxXMTYLmnSJwInHfendVLOnT4AQQulx3XMLk7s2HsuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 4, 2026 at 1:02=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrote=
:
>
> On Tue 03-02-26 08:31:19, Alexei Starovoitov wrote:
> > On Tue, Feb 3, 2026 at 5:23=E2=80=AFAM Michal Hocko <mhocko@suse.com> w=
rote:
> > >
> > > On Mon 02-02-26 16:14:37, Roman Gushchin wrote:
> [...]
> > > > Michal, do you feel strongly about having a dedicated kfunc vs the
> > > > direct memory read?
> > >
> > > The reason I wanted this an explicit API is that oom states are quite
> > > internal part of the oom synchronization. And I would really like to
> > > have that completely transparent for oom policies. In other words I d=
o
> > > not want to touch all potential oom policies or break them in the wor=
st
> > > case just because we need to change this. So while a trivial interfac=
e
> > > now (and hopefully for a long time) it is really an internal thing.
> > >
> > > Do I insist? No, I do not but I would like to hear why this is a bad
> > > idea.
> >
> > It's a bad idea, since it doesn't address your goal.
> > bpf prog can access task->signal->oom_mm without kfunc just fine
> > and it will be doing so because performance matters and
> > static inline bool foo(task)
> > {
> >   return task->signal->oom_mm;
> > }
>
> OK, so my understanding was that BPF can only use exported
> functionality. If those progs can access whatever they get a pointer for
> and than traverse down the road then this is moot from a large part.

bpf could access all kernel internals from day one 10 years ago.
We made it more ergonomic over the years.

> > If anything changes and, say, oom_mm will get renamed whether
> > it was kfunc or not doesn't change much. progs will adopt to a new
> > way easily with CORE. kfuncs can also be renamed/deleted, etc.
> > You're thinking about kfuncs as a stable api. It's definitely not.
> > It's not a layer of isolation either. kfuncs are necessary only
> > for the cases where bpf prog cannot do it on its own.
>
> It is obviously not clear to me where that line is for BPF progs. Where
> is this documented?

See Documentation/bpf/kfuncs.rst
Especially "kfunc lifecycle expectations" section.

