Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1C36ECD6FE
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 01:58:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBB0F6B0005; Wed, 11 Feb 2026 20:58:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C68296B0089; Wed, 11 Feb 2026 20:58:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B49E96B008A; Wed, 11 Feb 2026 20:58:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A64056B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 20:58:10 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 55BC01A06CA
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:58:10 +0000 (UTC)
X-FDA: 84434144340.28.33D1321
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5F9971A000B
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:58:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kfVcjTkW;
	spf=pass (imf19.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770861488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nstk6I7zPxlbkUMTdzxnnWEhckdBsy8CrqrY7iGx724=;
	b=iDK/sazDU0WtSAYFwtxL3dUmfXQwaYFe0RdAAIBxl3ZHR6D8DuyhudMOOtettA420475nV
	+tpWOJA/lc/tTv+goetthj4DLmoFxm+sBolR0neLtfS8n7V2vzeBzApUz8doJAeTgNpvGF
	Tlg5y7xGYEH3UXDdpevsdvQxQeq2mzw=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kfVcjTkW;
	spf=pass (imf19.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770861488; a=rsa-sha256;
	cv=pass;
	b=6zWOSVaYKOCBpB/us8fV+OHZr+0VN2SjXwJds9mzW+6UZptBIcDwqo8KY01/Ye2ZmLgGS4
	BINId8glKZbYMAQSLx9v1algNjF7MsPN2mBnFGmTgxtYfbLYlm/KeVqSbsC9syJd+ZgAbQ
	kWRUTjGAH/y/pzzT4ihY1WyMdrrb7a8=
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-79088484065so27050497b3.1
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 17:58:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770861487; cv=none;
        d=google.com; s=arc-20240605;
        b=hOwZjQzeIgsw5PhkQE7GQvrNweMWv0XVEo8JYFvKFxDf+OI4OEkIkSTLfAgfcEAHyi
         Pz6dNK+LWCliptEFL9LqbIAme66Mv1asjNnmzkzBG4KO0dbdclKUi3DNAcRMlpVGupPx
         YQMIR2f28k5K6Z67RJ5IJpX0+xYQQTxroMYyAHA3++XcLi29jtD0DBrUL+AKJBo3Umyi
         bCoh64J/3hwckXAwRX/+f7Z7Zfh9O9fH2lgYKAtp9lyG4P496cl2qcYeQt4AZ76Pkf9S
         ml8zRPj1ZFIj0wbshZ4CYMsmstQKyFi8j+REf4ug2sOyXeArs+16DxJvPyN2VMgtQwg0
         ivcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nstk6I7zPxlbkUMTdzxnnWEhckdBsy8CrqrY7iGx724=;
        fh=ybPBeAIZw862NhumYIVGQXQplEzG/vKOu8S/Hf/i5Pk=;
        b=i2P3RaZ6DsA/HAWwW5wO0CYjac3E3dSYsZqIZfhkdk1COX2kpcDAqSabismTPjle5l
         hR/7UJFwXr+rZtsB22kOAnxc/V/9HHnPndeYIYmH6o5cxUJP4ATNPPVx3dILagWRfqGP
         JNvzds7hnzT3grQHhXFYA2wQPajuVrquRjiNU8QGhvdG8c8cTBUZe5Ed+A4m+IY+ZHIF
         6xgT9EGKyKITKd6qxWNq5pvA7nq5MDKb5q7hJc0I9od/9slfBNgGd6UhcLKK45Jpw8cP
         ACdtWFtW9GoLOHHdFn20i5ihBAkKR2HhJIIJ9UgK6S+3Nn+FRAEN8jFuxoogwAbvTNWY
         uM3Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770861487; x=1771466287; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nstk6I7zPxlbkUMTdzxnnWEhckdBsy8CrqrY7iGx724=;
        b=kfVcjTkWfP7b6zst012pT6DSQRJ5AojqRCGBCizFug228vk/IHBaOsFZBrcLsrKQo3
         TcprcrkN26TNaWL8vtPrN/95BIVk7QPOtzFyqyWfd6bFjwKj4nXXSkmp6VToJPJc6R19
         rufZnvQATnVZPGDU62rgLlU7xmQGoNJfECF7ue63ulsQWkergLTKJI1/tuARwXmJDonP
         uhGPJObeOTysXUwKljikfIK5ovDnk5bppOmcpiYEIk6KTNX2zZBNS3em3FhRC/ISUBla
         x39oAFWPuUQrGOekDt1gG3RDtAGhh8t0yPLH8+QeoM0yk187nBf0LwQ8sbvE6PogBIm5
         lG0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770861487; x=1771466287;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nstk6I7zPxlbkUMTdzxnnWEhckdBsy8CrqrY7iGx724=;
        b=ZcD1ldf7/ArrMIgbpfB78hh8h7GaVBx7gnMlRA7QAM6F+vnPvowhWWsxm8owSKb+re
         XPwWPudxRNiwnPrXyj6Zl7ChysmCQcb5HzFlOZeLZzxAlB9thxrAUohlJeuumZRV7GjO
         99DYKrCnHgyw60amViNPp5b3pjoqT+6poI4dQRdWJFbufNVz+qhnCV/e6Z2mVN3Rfxmr
         Q43O3wQ+sNEGfpaSTqXPuzH3SzVjKb7/UdZPMaESTHCwAu6UqjqXkj0vKUhyExf5eY8/
         qbV6WhEuwukvYVBE7FX5EaV3XiKMqE3niPqSwCBMPNSyerV9VIx11aCllN1XSUdl/AA7
         HavQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgOt3kGzzA/vOTfIV5wlSFlkQIXRIIw6N/iqKzyLKRHHDOuNxxX1+iwdCyomEV367grSb/SeJFNw==@kvack.org
X-Gm-Message-State: AOJu0YyoxXCRtyo4ObkH+YyP2NvsdoYzRt492pEjt71CN8xIjmBBFqDh
	UyUc+qv1CzdbK2Re8ktw4S9sNcRhIgkDY3gJCtIFEqh+qeyZ2G3v/G2TzO5M1f0osOCRoHW2LQL
	5+Z+5liY/e8HdVzvjhjiHHCXRH3VXvBI=
X-Gm-Gg: AZuq6aLianYDNO8+Seo+OBNK+BSGxJp9imnThHo8O4EfvfSPot5wd8xpA1S64+9KZwh
	V3EEuHWa6dfmJqcC13pOJUmpR7dc22+fN6Zgp+yxxVVEBdJqfeR79Qp9gzR//9dCwdBgDvWosPy
	R6MoKef2zZCAXogg3tfBIGze/e80AQijDNxozGv58wqAuhco49raigBcttjH0LzpWI3Xxn5NQs9
	mOZGC7Bu6V52+N5EI6t3Tnz5hRrC6NzvMEhflaTEgyi5/d28gUKxsfpJIVn92pdfa+3GlqhaPxB
	hHLMnVsrCAps+f/RFBs=
X-Received: by 2002:a05:690c:e345:b0:796:45d4:9e4d with SMTP id
 00721157ae682-797931e678bmr10942657b3.56.1770861487295; Wed, 11 Feb 2026
 17:58:07 -0800 (PST)
MIME-Version: 1.0
References: <20260210043456.2137482-1-haowenchao22@gmail.com>
 <5c4d773c-e3e7-4a71-b250-91701cbdd4a2@kernel.org> <CAOptpSPuntL5dy+D7-wWcWuOgxugD+_uLzEO8e4fyGjS_ZkUWQ@mail.gmail.com>
 <201fcbb4-c43c-406c-ad54-f2c9301c12b0@kernel.org>
In-Reply-To: <201fcbb4-c43c-406c-ad54-f2c9301c12b0@kernel.org>
From: Wenchao Hao <haowenchao22@gmail.com>
Date: Thu, 12 Feb 2026 09:57:56 +0800
X-Gm-Features: AZwV_Qgg_6KvrKXpxLFS755mxD0p-Kxea6mLiY0evQvZtgi6csUIFX7MD0gtkVs
Message-ID: <CAOptpSN1_4N=e=_e6bVPWjEN2RUXG5=xJouhCaYjjqjLTCi=Rw@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: only set fault addrsss' access bit in do_anonymous_page
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: nfx9rjw59356ajjtp69qbtjknn5thg6z
X-Rspam-User: 
X-Rspamd-Queue-Id: 5F9971A000B
X-HE-Tag: 1770861488-224891
X-HE-Meta: U2FsdGVkX1/YN33uWfb+8dU+4FMBAC+jtyNsCNJh9h/KkJQHehl65umY2vwhcwaraoFNChxASMpD3Jg25Ulv4z8HVcKNiat1iM9Ir1OZ2iFVCvyuJL4VJMYizCq8XerdmlU0LkpavDdjY10UWFjunWwJ6AseFb92PkbYChuvNq5/aGljX97fUOUDLp6X9NVo4lxJ+22nZnYvHmYgkMHlRWN4lOcuguv/6lHCN28QP39S7FRnORgNgjhgj0uP8+yhWIqVea7j9Kxn6ZnEVnsK2zysmMxQQtLHDEZ6r96tR3qHegheEISKMkHPwZvKs3svUXOivvQaczmSbTGLf0PFvEEURgng11+zaOnWDfKm3dcE7c/QWKd8iSA//W6iagxI2mn0OfrqDrDHz0NTfWKdVf6vpjzgUc8BxL/5i8PVvIsALAzCPSPXPIUqSLnjy/kU4XKmGVt/VvEN7aEgVY0inKOivcZ1vHzCiaHtZx2YZ9yJIR3TVmICoByb2voCKRNN+nvX0I5kvQ9Ig8CYylQG9HLFNro5XNSwj2h4AKlBm+JH9dwU/aNUTI19VKRFk6UOC6kFZBiusTceOS8Uc63LDcb9gHlSWY88Jo/qVpvVhiO4WYdr3YdQc3WrtoH/Qp3J9ar2fKRQRCl6gJdT90WyIFWesXoiZaCd/mKvmxmoWxMnKMs4WRcCJe0rPyRFxL8h6sLF5WbKt6i/a3TI3P2fSDvyHOpFs7hre4xHBCyUOlIAWy9+HbmWgWna4tRdNHNa14c3ic7MlexINyOJIKD6FG2F9vUxkLdNAGTQtO4Ds638Rs04uQdJ/baClv2E50Q9vQhB/PqURg4F0qa/WHr3i+OE5pY7v46T3i0blWkgbzbzCZ7D6GgSm7PfZHb7bfHNjsEZGXT3E3U6SRL2ADpZwK01Y2jeikbpBalL8ZLh4Flvr0RUlnhq4wZmwiL0AlxurCjBsC6k3tVjZiiLiHr
 NmnMgAx0
 neDmUBmmYxIrsri86Da/z51Vn3iaCQuAJhiBtUWIo/UoTxXn645Tue6xzQWFOdEg/yDtepTihYLYM85egrnSzbY3hVITBsxMQ1hY4jLDSI6WC75GSjHMP6sril6MOdOzcAd+KYzezE4E+hI6A7NbcXZDc2HvS8zfAkfj9B4MkPGgG/J8HUN4iAOACHWjSs5BanQgFoWVFqsS+clevs+mTcz7UjZ6Kra6W0O24yu/aRau06oBpEgSJsZGt1BXMIyYlX2jsNuysdABQYkruQVExwkyOecVZJlZHmoLjcTr49wdi8JOmnDCMTvzvMLqfiiKDyRvBxKzlZcuz/a/2qI5pSi6qXA//HiXtEfrAXKdpMp9gI51ay8lqSJAykRfNAJ2xJIMuqZi0I6bqgKhSBOjFhNlR5YgOyQ5TjkxTydKLsJrl9YBVcy6DMvkLiccGTTvc76HtXFsJOAnQ+oSEu4yAxnCgNOJjIBBChUjimjt73s7LqUBWo5S+89sNIjy7P6zCeJnr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 5:05=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 2/11/26 01:49, Wenchao Hao wrote:
> > On Tue, Feb 10, 2026 at 5:07=E2=80=AFPM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 2/10/26 05:34, Wenchao Hao wrote:
> >>> When do_anonymous_page() creates mappings for huge pages, it currentl=
y sets
> >>> the access bit for all mapped PTEs (Page Table Entries) by default.
> >>>
> >>> This causes an issue where the Referenced field in /proc/pid/smaps ca=
nnot
> >>> distinguish whether a page was actually accessed.
> >>
> >> What is the use case that cares about that?
> >>
> >
> > We have enabled 64KB large folios on Android devices, which may introdu=
ce
> > some memory waste. I want to figure out the proportion of memory waste
> > caused by large folios. Reading the "Referenced" field from /proc/pid/s=
maps
> > is a relatively low-cost method.
>
> Right. And that imprecision is to be expected when you opt-in into
> something that manages memory in other granularity and only has a single
> a/d bit: a large folio.
>
> Sure, individual PTEs *might* have independent a/d bits, but the
> underlying thing (folio) has only a single one. And optimizations that
> build on top (pte coalescing) reuse that principle that having a single
> logical a/d bit is fine.
>
> >
> > Additionally, considering future hot/cold page identification, we aim t=
o
> > detect 64KB large folios where some pages are actually unaccessed and s=
plit
> > them into normal pages to avoid memory waste.
> >
> > However, the current large folio implementation sets the access bit for=
 all
> > page table entries (PTEs) of the large folio in the do_anonymous_page
> > function, making it hard to distinguish whether pre-allocated pages wer=
e
> > truly accessed.
>
> The deferred shrinker uses a much simpler mechanism: if the page content
> is zero, likely it was over-allocated and never used later.
>
> It's not completely lightweight (scan pages for 0 content), but is
> reliable, independent of the mapping type (PMD, cont-pte, whatever) and
> independent of any access/dirty bits, leaving performance unharmed.
>
> When you say "I want to figure out the proportion of memory waste", are
> we talking about a debug feature?
>

Thanks for your explanation. I now understand the design logic.

What I=E2=80=99m proposing is mainly for debugging. After enabling 64K larg=
e folio
on Android, we observed increased application memory footprint, especially
for anonymous pages.

Since Android app memory usage depends on runtime scenarios, we cannot
confirm if the growth is directly caused by large folio. We want to
analyze memory
usage via the `Referenced` field in `/proc/[pid]/smaps`.

However, with the current 64K anonymous large folio mapping implementation,
the `Referenced` field does not reflect actual page access activity correct=
ly.

This is why I=E2=80=99m sending this RFC patch.

> --
> Cheers,
>
> David

