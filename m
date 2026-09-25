Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F37CAC9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 06:04:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 201DA6B008C; Fri, 25 Sep 2026 02:04:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B23B6B0092; Fri, 25 Sep 2026 02:04:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A15C6B0093; Fri, 25 Sep 2026 02:04:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CBE3C6B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 02:04:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4E829A56EB
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:04:53 +0000 (UTC)
X-FDA: 85251246066.11.C733EB3
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id 60940A0004
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:04:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=idAmto0m;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790316291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uFHv/NXcVHJN5o88N4eEkFmwnshWOqOMekRqytrwOao=;
	b=E0Z5Pw37JHWSN5nU0BKyrmE/EBiXW9IoQ++g89ZLTTLZGCuxJcyADaILeSZub+yhwsEkNG
	85Ph0CtOdvNJ6MC1xgerlSVnsjbxLlCR9Lu3lCCFuV8bREPGIhVTRyHrTDgLvhnlEygzZ4
	74pSEf4RjgXvud5jI9ff4eaZvvLaJjA=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=idAmto0m;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790316291;
	b=6uRrSr/QHuGtNvbmGKU719kvzA1wPVGiI2MXIMQVmdxCvAekp9w/SlRbFG1Hq57b0d459k
	p2pOpDrMiRc2qSeb8ZMNL848sES+6B/mmVT4BUM7TdVbK/dmYWs1NmJOLFu6jDOurRkpq5
	FKMsy9xlNgdJZmdqBtzBfEObw0/ltoA=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-52faa58bff5so177471cf.0
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 23:04:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790316290; cv=none;
        d=google.com; s=arc-20260327;
        b=bqX5vFqJH0B+hMzHHk3ME5ladJbV0cVF+FC5xSihkBaspDKMgyFDONOvuK5PbQdWtO
         bErwn4ButJIl+NXA5mICGqKdBU9ss27nNxqygAE2R4MulFByuHL055bmHaCPPx0/Wt1Q
         h2PQBpIhcRJuqhzgBj6haMMqmw5XEdI9uIy8FcfpFIGODeeTRlJaqWG4EPKDY9S6TE7n
         Cpwj97CijzgQzSx/aQW0ac238Fn54AltKnh8ETAGVImiycWSuobDHVubMubxReiJkft7
         ZBOkgg6+yOTN0eORtNik5K3walEONHzh9gCzNRgBQ+dfc2KNOmoxRX2dmHjWshNgcrGu
         bP+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uFHv/NXcVHJN5o88N4eEkFmwnshWOqOMekRqytrwOao=;
        fh=dRk4wUfeG/dg3KehpeY9E+jhppoydrmD5/J7XWlQJHM=;
        b=lSi1cMAVlI/RiItGwrJfP3lm+s0/hreiqmDcHo6w2xCjAc058ue9TtrtynEChMFMSS
         RyHbzeP/DBi1kjjojyz5derKfGczEeVBiG9FSvMvg1pFZ2vaadkA619nK1ON6iO69q8E
         CA+SXRMQTXM7k0ez+qn6WXsRhyfl1klktc85+dYvnZbLCTs9aLqvzgpnNMwcCEBuNq9k
         wiR/Sq3127jmleooi36yDiD3xWeIkrqCcQR10P9P3hW/tboM1SWCf2AmZvqoHBBt72iE
         QcdEvHNpI2SoMjpUWPaCDttbVnBVGRKRqw6q2FcLo4EzQ9e5peJo2xHUloJjhGN3ZO+s
         Y44A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790316290; x=1790921090; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uFHv/NXcVHJN5o88N4eEkFmwnshWOqOMekRqytrwOao=;
        b=idAmto0mQtc6uNNyE03axtDhZbnjFL8BSPpVL9p6ItJpcyZlsXaYXlGY5+L/UKEUYM
         3Z2U4RM9kme13K7C19UxgCD+tgYli9kSHzcybppW5IBTJvimqzuy0jwwE8XyC6n/Od6e
         UkjTTan2lQg1XrIFY08aFG9bomOJ7AAvvm911v7fUdRgTD+hZuiA44iQlzuWae74V7Xf
         NESEXB3uZxy1DEQYDsX3+chvdu6UMcNKceqjBl33uDn5hm4y/y3Sbmve1wtlBQlInqEt
         mWYqz76Oy2q+z0ZdXnyXgbRirtKNOw7IcDoD8YQ3J9QVRNy/utXWwwL7u+QRwwUVVzQf
         fsXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790316290; x=1790921090;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uFHv/NXcVHJN5o88N4eEkFmwnshWOqOMekRqytrwOao=;
        b=WMRfQ55JoyJqz5rpYXL7ccHjaf1FSCGpcJoPoAYxQlo+jyD92mGUX05ZDoDhSX/4SF
         n74CKBGyzXb+4lQZTu5SuVorx9xCmb6fnWEw3vChxknxP33seOezEWUtvBYqAN4qAPML
         gh0Bll09xnSNkSxzT8fy/M2uJX3ut/bamNLJEqqbMw6OCZ0S3/wCJdBbBw0P3H9TqwTF
         cMKgAV8p1CXt91oHS0lNOP7GxrGjyAOdKfw/aoYc2oOYkYHAixWlPYXJikRH2X7hFhOO
         1ZDHrd0iPBHWBiDd5i3ER5nxGeiwE12Hgaeio5H5N0+UY7M3Fgy8vPpL75PA6jX3iGzc
         Vh4w==
X-Forwarded-Encrypted: i=1; AKwUvBxx9nS1FMe9zqz/GATfqHQf8vqjm15QsPZxgudFOa7FV63l2TXzXe0HND04z5voxyXtvLyTIDgsNg==@kvack.org
X-Gm-Message-State: AFuF++nSOX9HFJsIi37uuriO6z3Tqgs9nYLldp7GY6f7fwk4ceK5D0Rp
	SrMGtFsLkFa1Tvz5nQ6TDZWUqVNNeCafFUSByEEoE7iAbD6AxLgTdUxfe+0WVqei5j1FFscfBQC
	ccvzwH4JwZ7cHvc+5pgn5J1NZMah8QsWo/6Gah4QG
X-Gm-Gg: AYBFou0dG/Lg+pjIbGr8OwveBJIhZ0zHJtPr4Z4qNKabSWQfDrON0uM2daIZWszcGu/
	XK2pTzguTOZoN9/jcMGvcsqswjQ209XsNsHzXbY+8OorP7TUkVdCbjW/vk4JYabT0luU1eHgFbn
	rU+mG/04NV2B9WWrbpgyR3p7s1rjREae1nn7v9Bk9aGzGObpkfXrTAwzaN8u+myfF20VN9awbaZ
	KPC49p3APQte+p45kPFqw1upjaMmBAccG5PgCR27TVo/ZV4hyIUq2KhdprjutrDQO2PHfaZSurN
	mdTgE1Dl4GppV4q4utcgZIZtm9URZ3DkIcgcD4B1zDzIMEZ54k1dBg==
X-Received: by 2002:a05:622a:d3:b0:532:c8ca:5ae9 with SMTP id
 d75a77b69052e-5330e14c38bmr7040531cf.11.1790316289698; Thu, 24 Sep 2026
 23:04:49 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1790025465.git.abhishekbapat@google.com> <057359f7-0e8f-416b-8b5e-0b60c1c936e9@linux.dev>
In-Reply-To: <057359f7-0e8f-416b-8b5e-0b60c1c936e9@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 24 Sep 2026 23:04:37 -0700
X-Gm-Features: AclHuK_lwpEJbAhWtQShe8aDhh_guZmjVwfh6KH-R_FEbCl9ftq7SLG9YWrva9A
Message-ID: <CAJuCfpGmChqsz5SMHaaTxJQLcj200USvxZ6SQ6vrAr6-M2Vg_Q@mail.gmail.com>
Subject: Re: [PATCH 0/4] alloc_tag: Introduce selective tracing for MAP
To: Hao Ge <hao.ge@linux.dev>
Cc: Abhishek Bapat <abhishekbapat@google.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 60940A0004
X-Stat-Signature: bdo9nzakaiuau7q57hw48urj66y5dmsb
X-HE-Tag: 1790316291-129880
X-HE-Meta: U2FsdGVkX19VDzucol+agF5b3TD9G/sIQGgNqvleaxbkS0nTf+HvwUht92I7Qfl3EJqYqqSK3uR79URFVI4fPQWCGr1mzAZirXtIVHaJHb6kS0+KVBl/b6dQ6pOqk1bu7KzjOXZhSxzTg/gFISpIFaWXFjAhmWUYjZRB+9EwJ53n3dbx+0gyZxdyHI03c+vR9+26JAeRjlqp+YPxyouHeJDWbCOIJWWKXheA7+Blxrb5bVeWWvtvKlk/Y40y8aLSzl62swQsFXKTTJA3pzUvif6DFjk+OMnb7laqyOuTHX40mF/AihOrCuBO7PuTOCJrSDV9be4A0Z/fdhlVgBKrpAvyD3GS5hsErx6RwMjsJ6vSWhI4LmSk1SmM5xZWmVdhBbyLF29W02ALGkfBbEwyWE5U7qW9W/gtkiIxXuGXRWVbhkOI/rXA6WFL/lb2RaYnL+ZmJ7bqN1n+USsNzhNiRzteCD2A7kXPCCOFzapu1djIsksCp7kHsDa25JMCNu7/0CVS2kEy/zpdYWtSsjA7sDw2v/MARm0upHy77MXKtOX3UK+zfTY89rYDbrsWh42Zph6cbkIHoVm02ZP8tK6/fDDJOAm2ODcweUMDX1QpUNu5bZej6xpIRI+BWUb+PIvrLrD7jxd6kytIeogDzT5YY+mDGH6VaYwOEoe+rMd5xEIcbuALjrugRU5D6o0FHDz7YWjrbSC+uzPPWmG0eMwgmgcDfRY+u4839aGxyjx17HToiidIlk0l3wFq1bn++7FmFo3LsqN+LP9RT2d5z52PnRZVNpOUXPATNtzZc80wcDHEzRt0otOuWp24Y4i66K3HFdIwItSSEhhQ1Tar8GajGrtGQSKjGUXpI+MtM403lDu/bhZIKF8axZeK4rVm1jVE2kQ+rIU+GkmlfMo0n0epsKcVgrVqAbX7zZ7Rymft3QmkHB7BgZ8L9Wj6zl/TtUdiT53db7buHr3XAhobl04
 6W/3wdA/
 asFKQWfxT4gODs1D0G7uG6Jd+fE/M1z4QrM8dJu14Nyqil3OHuCYTbAL2DkgJNgQMyTlXchiluLR72NeWMltEh0LGMxUqfUAc4DHM4gP7fcmd6I2f3iUtPqRcwiCS3680rhh+MclT53Q3IkbRhzVV/rAeU7FPL5TIA0Sd1EJqKY3Aet+E2k0SY5fF0CDqEcchgT3EdM6WCfKQweeoPWFzbO3Oy5Gd8ERJhx0GeodtSYFbYc/EDoyTpKjllbysM53CLLEUDEbRYbXj8CRvtuYM0xERPGbp8UgpPn9FgQlpkndMyqAlkVQo6LaWmpq3Ia9p34zbtGlDR2vnsVRUigTBG6OucA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 2:52=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Abhishek
>
> Thanks for your patch.
>
> On 2026/9/22 05:26, Abhishek Bapat wrote:
> > The existing memory allocation profiling (MAP) tool accurately maintain=
s
> > aggregate counters for overall memory accounting. However, relying
> > purely on aggregated counters restrics the visibility needed for
> > targeted debugging.
> >
> > This patch series integrates three new tracepoints (alloc_tag_hit,
> > alloc_tag_mem_alloced and alloc_tag_mem_freed) directly into the
> > alloc_hooks_tag fast path.
> >
> > Enabling trace events globally for all allocations introduces a severe
> > baseline overhead. To limit the performance overhead, we let the admin
> > select specific allocations to be traced.
> >
> > A new IOCTL is introduced to allow privileged users to determine which
> > allocation tags need tracing enabled. The IOCTL utilizes the
> > pre-existing filtering mechanism to specify the allocation tags to
> > enable tracing on.
> >
>
> I think this cover=E2=80=91letter could go into more detail.
> Also, the cover=E2=80=91letter doesn't include any how=E2=80=91to=E2=80=
=91use.
>
> Looking over this series, it seems you expect users to first call
> ALLOCINFO_IOC_GET_AT to obtain a tag, then pass that tag into
> ALLOCINFO_IOC_TOGGLE_TRACE.
>
> This behaviour is not reflected in the existing cover=E2=80=91letter.
> Before reading the code, I assumed I could just pass a module
> name to trace all allocations from that module. After going
> through the implementation, that turns out not to be the case.
>
> Because patch 2 enforces a full mask requirement for the filter.
>
> struct allocinfo_filter filter =3D {
>         .mask =3D ALLOCINFO_FILTER_MASK_MODNAME |
>                 ALLOCINFO_FILTER_MASK_FUNCTION |
>                 ALLOCINFO_FILTER_MASK_FILENAME |
>                 ALLOCINFO_FILTER_MASK_LINENO,
>         .fields =3D params.fields,
> };
>
> So to trace all allocations from an entire module, users have to combine
> ALLOCINFO_IOC_GET_AT, ALLOCINFO_IOC_GET_NEXT and ALLOCINFO_IOC_TOGGLE_TRA=
CE
> together.
>
> I have no strong objections if this is the intended design.
> That said, we should settle on the expected usage model up=E2=80=91front.

Hmm, I don't see why we should limit how users filter tags for
tracing. We should not enforce them to filter on all available
attributes. I think it's easy to fix by adding the filter mask to
allocinfo_toggle_traces.

>
> Having corresponding Documentation would also be quite helpful. That way =
when others
> ask how to work with this feature, we can point them to existing written =
material.
>
> https://elixir.bootlin.com/linux/v7.3-rc3/source/Documentation/mm/allocat=
ion-profiling.rst
>
> Thanks
> Best Regards
> Hao
>
> > Abhishek Bapat (4):
> >   alloc_tag: Add trace events for tracing allocations
> >   alloc_tag: Introduce IOCTLs to toggle allocation tracepoints
> >   alloc_tag: extend allocinfo_filter to support tracing queries
> >   alloc_tag: add a test for trace state toggle and filtering
> >
> >  MAINTAINERS                                   |   1 +
> >  include/linux/alloc_tag.h                     |  94 +++++++++---
> >  include/linux/codetag.h                       |   5 +-
> >  include/trace/events/alloc_tag.h              | 122 +++++++++++++++
> >  include/uapi/linux/alloc_tag.h                |  17 ++-
> >  mm/alloc_tag.c                                | 142 +++++++++++++++++-
> >  .../alloc_tag/allocinfo_ioctl_test.c          | 111 +++++++++++++-
> >  7 files changed, 462 insertions(+), 30 deletions(-)
> >  create mode 100644 include/trace/events/alloc_tag.h
> >
> >
> > base-commit: 8d61431ed2607386b427752505379536eb634ce8

