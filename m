Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA954FD4F19
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 18:17:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CA576B0092; Tue, 10 Mar 2026 14:17:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 098AC6B0095; Tue, 10 Mar 2026 14:17:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE69C6B0096; Tue, 10 Mar 2026 14:17:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CBA576B0092
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:17:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 65A231A029B
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 18:17:29 +0000 (UTC)
X-FDA: 84530961018.25.1D283D9
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6F2C040016
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 18:17:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AUnIwEo8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of avagin@gmail.com designates 209.85.210.51 as permitted sender) smtp.mailfrom=avagin@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773166647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CtPhftfvGHn6SgDt2zk9OxGOsN7cHsbY3NEdWolQhsw=;
	b=fg/b2oHW8WHJ2fxz+vhoZi+bgl1xozn1PJRvw0RkVk06BjLkzX/CttSxAS4KQifVZODc/n
	W/w/ghMfEdIJXAh9OyHMj+sv+veAyzNtsd2S/J/Z5Kdo6NZ2j617VYuYX8DWpyKVedR88a
	ZEc4whK86Y7Z9zMCy/t5Oof9K84TF6Y=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773166647; a=rsa-sha256;
	cv=pass;
	b=UDS8jrSsEEeHhTrPCFaYvbqvZOCJJosK5Q1WVc7aGUvJGsmQ1oXySaZbXSMGPV1mr0HPyd
	5gKLbzjuCoEDvrDDEw4QCBhffe4UeX+4H0UaNDjWE9LXG+xHeATbRo8NygpJ3QXvidVVtP
	iuFZvMLtcA8fGQclnnKegRZmY1kPqxE=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AUnIwEo8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of avagin@gmail.com designates 209.85.210.51 as permitted sender) smtp.mailfrom=avagin@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7d748ca8708so1603292a34.0
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:17:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773166646; cv=none;
        d=google.com; s=arc-20240605;
        b=EHAZLjOtZCj/C7k2rXRrUndDg+NEUuc+/RS3h50sy9XA0L18bH8dCd1E8y3adq+h69
         Tzbm6frOoi433RqoMjIVD5Nas0GMCPofzxMXjKRRW75yUULYSvSgqUhQOAEeB9mcFoVp
         79wYy49VJ4OYpSTkV3Imc7ghZfZVqsEvWazQ4Y2ToRF9kF7S9RviP1tIqHw+haQ4JGMB
         KQTev7QJFuXlgoFOwnFb3Ha+wlSK7zjZFz6KdXlpFlcp7mL8Ib11fcDWp5zijygy4tVO
         uPEoLDBeT+t5ayAr9IwCULp9LVp5bCyBUQXFIGQWjIVIwd8mw0kU8ZzXTapwm1DA2Rc/
         h8yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CtPhftfvGHn6SgDt2zk9OxGOsN7cHsbY3NEdWolQhsw=;
        fh=iIK7bTFa1is5QOTpCzWcS2YnDl7QZlC6YXD3lkm6hZw=;
        b=O6Xj3T0v+/5AdbuClmEDy6lzV9HwB0zdOnjcZjWNZuYp2obWEQEe3pQdbO+oqKm9o+
         LsAD/WCJLKBciZ4rYPzMHGK7S8MJbl4yIs+Eb78JXGfCCYoqhjokSEqqx+1pteIHZUR9
         4ygMC0r8GPb9DT0iAnCmHJCVRBz5mLZu9YN+IrjRYb8xOQH9EPp7QXm3UFLPfbpcphFP
         NXvxxbzWU9jbeWpSKUSmkNK9YU7T4ANjidjlNI0aOwY1v/3aiCmXdXH706bdv5SjdYb6
         NevCGkAD1FbBfFuwD+DoIXXzMaSfDwZszc/1ZxDUNIUjUpoqbGyG/Zr3Qg2/it3AnHjw
         8xNw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773166646; x=1773771446; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CtPhftfvGHn6SgDt2zk9OxGOsN7cHsbY3NEdWolQhsw=;
        b=AUnIwEo8nCNrEx3Oac9sStxDnKWsqYWqycZqeRAx9pH94uikt8waDv7YJlhav5GScl
         v2Wk+ybHywUQ/Udx3QeMJAY/KIjMQBrYaOmDBIwKPlM+/fqXMVD0lb9ydrFhHS3sHgML
         TzVlJH9S8ZXevP4P8iBSfD3RAo97/aABHhHDD/NYe362oVKKvIcpKqRxJxmgB1xl/pzA
         p1olQed2XImUK7rZ9Wf1v7TAEkO049JIDHxgEE0IcHRzopVPmXBf23otETV8Ful5vYK3
         dzkWH32Jm1geiYAJPjGKPyI/QyqVPxlxxnHpnJBggs7oKZn/yKNSb5Mj88n0HyZs+hwC
         jkBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773166646; x=1773771446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CtPhftfvGHn6SgDt2zk9OxGOsN7cHsbY3NEdWolQhsw=;
        b=fc8PZLIFoEhMFRo5S6sMlpVJ9dLvH34N4229et9QL14mW/aF3GEFL9ZGIhUqALf3pj
         MlEueth9ybosLrkMJXkI6p52+dM7R6bLWZbbAvw45oH/AUWid5hhrh9WkNdqa1J2qHVO
         mLwGtLXNgGA+ERv8TaSgl83jsOyg0lVd/EpFqeBOLr4H+JNe44ta4gSad0rxGaUQSk74
         Us2M/2023P+dt5RxSYfxNRn2Vfl1LTN07MSw6YrCrz6reJrwLARqA/r2VD4bQUJdXEoA
         K8NAbkOkUfwIXuFba5oKRR1qPVU+a//KMf+R075muP6rZGhDG+2KwiZAtFAnCB7vd393
         OfqA==
X-Forwarded-Encrypted: i=1; AJvYcCVIr07t33PQgN+pxWXr8kvMEry3lrvynnMJwRafJVQ1orFx5P3vR2qmfg9B+UX+YVFQMS5udQRtiA==@kvack.org
X-Gm-Message-State: AOJu0YxRW0+nbDTe5QBg375sOCZL7OXHL8rk9T5/d3wwjEEzpNW4OgSH
	JFuaSfsbggZX2KZ/VA8qrRCd9l1V0v/hUIT0Y83sePpRbHwT3q2Qxwl1TFAc0Lk1rrgRJ3KsLuj
	GiFFP1h4L0CdlT79CvGhsAlClR0suXPM=
X-Gm-Gg: ATEYQzyacYj4ihJHnq808qkrAmyG11JGRRrQrwS37RUDY3hXMY2ooRONHBogzf9QbHB
	DvftqyVWOcwoXFs2xVi6FEOw1xMC0KQiOV25OHLuv+N4iLxHlSZtf9Xct/ZHCi4UXhKcO8yMkFc
	l7jyMuHlgF8lXLRMlyO+aJ6dm5f4e8gR/+n96i3uMDBgz+Lz2cqGjf0yc10ETBshFfA1X0bf7ST
	7GlYbTrYbDcs96a3NIOA65e+B2MToLPIQitqtTQSBRo1mu5NrJHHvV0J8v1xBnuY3Y21JQPrK8x
	7QqGiEs=
X-Received: by 2002:a05:6830:6483:b0:7d7:4b31:fc0a with SMTP id
 46e09a7af769-7d74b31fe1bmr4560643a34.6.1773166646345; Tue, 10 Mar 2026
 11:17:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260217180108.1420024-1-avagin@google.com> <CANaxB-wNJWhyM7JUKT3y0Wp73=+8XZRnSkdudxqDwEo2FaJpwQ@mail.gmail.com>
 <202602231428.CAF9D1B913@keescook>
In-Reply-To: <202602231428.CAF9D1B913@keescook>
From: Andrei Vagin <avagin@gmail.com>
Date: Tue, 10 Mar 2026 11:17:15 -0700
X-Gm-Features: AaiRm52EAeZPezNaMYxQ_phYY0Iw71nOMe7J5lxa4Vausj_LtOvbcm1YDNeZQSU
Message-ID: <CANaxB-wFW5CedtQXiGbQ=b6eyOzDwPhPXf+Tp0RK-DSqPsC=4A@mail.gmail.com>
Subject: Re: [PATCH 0/4 v4] exec: inherit HWCAPs from the parent process
To: Kees Cook <kees@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@gmail.com>, 
	Mike Rapoport <rppt@kernel.org>, Alexander Mikhalitsyn <alexander@mihalicyn.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Chen Ridong <chenridong@huawei.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Eric Biederman <ebiederm@xmission.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Koutny <mkoutny@suse.com>, 
	Andrei Vagin <avagin@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6F2C040016
X-Stat-Signature: c9cyrpo3jzu55q5zwy6rod8rpfehnk3u
X-Rspam-User: 
X-HE-Tag: 1773166647-632108
X-HE-Meta: U2FsdGVkX19mVfftdAvLoqLxGpvN8wodbXwRgIq/VdNNFKPesYU4B9izF0GsqwMOd2Fwnjh58UIOntSR04652OmU3fe41zHHHigL/clgqYcqjOpbFaHDgIo+aIWHCpWP5e4dkIw3EmNIvLeQcbHv+xRFI3fo8CDABOS4WTwZkbLwB9HeiDtbbVWwswjyxH/2QB9Wv6pc+b45GE04g3nrRjsQ8MBRpNhrPlmsojX42Zjp2Y00xJVCNV2ZypN8LhfFVRVDWIuDfQXpS7t/Oh6qG92iqM3GZSqUJm4Vuu2AWC7DpL1dL5QEwovzjcnh/66r1rxKyV6JYZ8lTJh6fIcIsIVLeDqdtwhcTLUfF/3AU3dSdDwt4IXqmwlT/fHqZ1DNIqkVe9KPvPVoyPvaUySAyKWDmqLmA48btanbYsO2XjHrHDHuS9JEIKKKJsy6MlgjZOpdJfxDkUWSphz8GEQqciZoA+oPw0u4dSybjOoWqgtzoIwQPShgULw65BXi3AMNiE2KqH4mWPubVBjMpIVaAzsVNULi/RGqZ/Y2WypQd8MjhEBVdQjN4bse8IEqYubuAroqMK+vRT502Lg7RvRuG5alu/eOuD187qS3NJL3oV10Zh5Rr03+KYgwMh69coPQyCGc7zNIYyAtCmMww/oHtsyw9Z9zcY+93pFf93olrTHBzn356Ulgnw3IgRXrNtpKlA+toX8SJaxetAXSUQaEX/HlYFcaVOuYrWP1oIJ4iC9bZOR0tN73FUsdXmmWUBIfe49D+PuJKIdFwguuCj6A3ClJsdtFHskv6uTeZ1eYdksHBcqTARsY54fAuoPfxFuS6QQIZfbZiOfI4EIl1yLDnlPkb1w3CWZkvRyYcPH7HXocOd6b87wh9MuJBNlk2YKUxozw6nBvr3KyaOX5YZED6zwdqfdOH+v9FGExgMkyKTPpA0uQQBbN7kZOZh0JvDMr0yC9OTuQgyNcobZ5/gx
 eEyOY8pe
 jQr1HRr38HtQFwIsvdcefmO9oTyP2uobuf7UcwhRvGrJlIYkX/Bfvsnd+FgCpH6OxNdAb2rzLFCMV23iF3q7SOKezuCl7SOhljpktNKRvopUyGI5Kdg/2NLuOgbN7w5mnwyXfWdUM9rxuXQ1/9XbIBKHwVuaprEHQRzZp6ueYY/MrBpLd9NqxHMPfjHfSikCNQp6pIyh5Q/B0uS25N98yOKZX9UsQx//Gn5jSEynK5rGfbf8COXSxOnSVVLsQ7XvC74Hkv1abs2Hk59+y3a32O+WjdBG5LPWb1xMxLf7Vkx6/+oiXSTjeSOPCxudyM9Ju+EKOgEzcT2iuxW9obP4EE2MnCKBWqG1ltoICe2Ne2UTjhdlHOi60PT6llUyDfiOs2d56JoHYNevqm+mrrwihTxRnGCMfYZ70o4ilUBGBLx3nR0cZ/KWsjeLFtlOlekOux8u8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 2:29=E2=80=AFPM Kees Cook <kees@kernel.org> wrote:
>
> On Mon, Feb 23, 2026 at 10:29:00AM -0800, Andrei Vagin wrote:
> > On Tue, Feb 17, 2026 at 10:01=E2=80=AFAM Andrei Vagin <avagin@google.co=
m> wrote:
> > >
> > > This patch series introduces a mechanism to inherit hardware capabili=
ties
> > > (AT_HWCAP, AT_HWCAP2, etc.) from a parent process when they have been
> > > modified via prctl.
> > >
> > > To support C/R operations (snapshots, live migration) in heterogeneou=
s
> > > clusters, we must ensure that processes utilize CPU features availabl=
e
> > > on all potential target nodes. To solve this, we need to advertise a
> > > common feature set across the cluster.
> > >
> > > Initially, a cgroup-based approach was considered, but it was decided
> > > that inheriting HWCAPs from a parent process that has set its own
> > > auxiliary vector via prctl is a simpler and more flexible solution.
> > >
> > > This implementation adds a new mm flag MMF_USER_HWCAP, which is set w=
hen the
> > > auxiliary vector is modified via prctl(PR_SET_MM_AUXV). When execve()=
 is
> > > called, if the current process has MMF_USER_HWCAP set, the HWCAP valu=
es are
> > > extracted from the current auxiliary vector and inherited by the new =
process.
> > >
> > > The first patch fixes AUXV size calculation for ELF_HWCAP3 and ELF_HW=
CAP4
> > > in binfmt_elf_fdpic and updates AT_VECTOR_SIZE_BASE.
> > >
> > > The second patch implements the core inheritance logic in execve().
> > >
> > > The third patch adds a selftest to verify that HWCAPs are correctly
> > > inherited across execve().
> > >
> > > v4: minor fixes based on feedback from the previous version.
> >
> > Kees,
> >
> > I think it is ready to be merged. Let me know if you have any other
> > comments/concerns/questions.
>
> Yeah, I think it's looking good. I'll land this in for-next/execve after
> rc2 (a week from now).

Hi Kees, just a friendly ping in case this slipped off your radar.

Thanks,
Andrei

