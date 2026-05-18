Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9BF1CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:41:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 305766B009B; Mon, 18 May 2026 19:41:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B5EA6B009E; Mon, 18 May 2026 19:41:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17E346B009F; Mon, 18 May 2026 19:41:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F0C736B009B
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:41:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BE5F91C1F94
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:15 +0000 (UTC)
X-FDA: 84782164110.27.0B95BDC
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf06.hostedemail.com (Postfix) with ESMTP id B58A8180007
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eJ1cYK73;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IHRjlbIxx8xNGO6BZ+LZbmgJGbpCAmOWcnGBXVgqzb0=;
	b=c/Ndoz0jue2ug+olsHFUjTfrRZbFfdlewpUXdOUNNgmblE3VCmLBeke/mxaRXFQl/CZnQf
	dCoQEWmiWAFYX4LwYV/6G68fSU3okAFPlRp0iDzNk+d77w+h5QKgc8rQN4lgr3izeYQ1Im
	bCePUdgXmR2tZXYE47jITnLdRUjKFgg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779147673; a=rsa-sha256;
	cv=pass;
	b=l5Sgl9DjZOfrci5k5Qv9WFGB6tDKspOjmWohXTW6AYspdQQueqRDg042fwaXoBLTbRr0i0
	BMdjaprSohxJLUWedgmOYCDkBaWlUHa/TuI25iHgCdR535cFhFJAoOjzt/XRbGOl1qhHLa
	m7Y0GFk002i8c6pztUXDQBYBNXAxaKg=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eJ1cYK73;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ba180a022dso875ad.1
        for <linux-mm@kvack.org>; Mon, 18 May 2026 16:41:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779147672; cv=none;
        d=google.com; s=arc-20240605;
        b=FvmBkd5uJ4efA+2KUX0f1hU/JQJnc/XaPZMh45Qc5tkRbiHh2+Eh6UlvPHPMzihwU6
         R4GoJRw3NCu/c+V2EoTE4p0UX5U4kMY0H/Md+g50Apg3/Q2XbYjKjRv4LHJCU5AIv6cZ
         H+XilL8YSgSpFPTQ9jw6jcol449eGc7SgaHjYRfZ+6TNBwBUObbTzs6nXSwqRgAL920n
         sObb0vjM7g3oy6Zt+CCTTOy6jhnLsYTE05MOqdLZ63/tiMCd2t/z4hLAE+PAmSNm+giF
         m2VIJpNkEhLq5E6I+XPXDlzs+M9bRtDbXPObUHt5FvfCDBcIMu8bZ4yVe8Fns40EyPXX
         IjzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IHRjlbIxx8xNGO6BZ+LZbmgJGbpCAmOWcnGBXVgqzb0=;
        fh=7gxRZVtxpFVQrU/j63TY1kIhObo4YMggZJWLA02v6jw=;
        b=a9j25J9BB4u+zJ1lhf6x38SIkkU1vyTEUclFQvWVdyOzph9Pcg6c8FX9a3PvD/I10s
         8CJVYo/XotSNXErEvFbkBRJzV8VYDnWLt/GJ4AukMYsn04HqO7VwUR0PDf+/oxMESrsP
         jxxzoOeTJgdoOV/J6u+SFwiFgM98D2ARzc4zskmD5G6geWiTwLVatwgkEVmaNP4pFpNX
         5ITM5KX9fheoe352rS/gtRv1J7Yko60bWTHkvDi9DG98ofP46KIyp/KEbo0RgREE6EDG
         nhNCisO0SvZNsXiADvwn0udTT45Qn9u/IIn6V4RdER20SR+9RThwIvBh9o/7JTPZ9AL0
         musQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779147672; x=1779752472; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IHRjlbIxx8xNGO6BZ+LZbmgJGbpCAmOWcnGBXVgqzb0=;
        b=eJ1cYK73N81o4qwUh5PXiTDsQmKbt7EmMy7TxwpC9itEVduUeQkhdke4XCWST9Z6AJ
         QcTtsOvjgaQAqiU8u/ZBQjhEKOWSFDQ3CynlBynAPHkvUWE/Gqm8btah4/M5A7q8t+6w
         Mpv8bEXcJwkj3jREv9Fndtw01AKnH7HjvcMLF9lHhoo7bPUCJjbBNfQ0ekaVt6XcNRki
         gu4HQi38SpQVg6S0Erk1KchktO9Nb91y0JeYHqxTd0l63IeVrFb+PWlWbF1O9tk8hPj+
         8KpQKr1MMx/cZIEQLCL7/HyuPS0DNEULRtdgAqa3HddZVY4Wg4tMOFUq7lDNJ6JSJDTU
         RKRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779147672; x=1779752472;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IHRjlbIxx8xNGO6BZ+LZbmgJGbpCAmOWcnGBXVgqzb0=;
        b=sMpKmObZ+WJ3HrjHScITsl8yM+8BG86frnqE5HZMylQUfmfoC0iEreB9JxhD1Rkrfu
         tbACDeLnIFYiroY8vKCLtbZP+hChCxcqT2oEYUzZMyeoy3JP4zha2GH8NrmbP2rds0VV
         drizv2Zvu5FgQatM9yQZL1vKlQURasyBtUUvdqro6EfjK4ZoN07EWIdm82JrBNpCw2nf
         xiqy4d5Gohqr8brPEr5ejYEWKPBo7HOBbRoREolQMw6Fl5uMWKwPz0yU0ohKcgiPXqBs
         cXPVCf+D5AL7Eyx/YGPBWUhCY9B/y6ZTIhJjO6eYuXIgoF5YEvYvxZgNThc4bk6Y8scw
         6VWQ==
X-Forwarded-Encrypted: i=1; AFNElJ9/wNgxX6lFSObwpUBLXiKKeXdMVJLFQAgpIYnev34ndoLkUNHLUwQt/YcB8dUI5gJYeW3zMeLPwQ==@kvack.org
X-Gm-Message-State: AOJu0YxjFaeG97kiSjlFJfGFFEx4Yd3wwRFQq76RVvAOtUY0N46a5xRj
	eD4tRAdV8eU9/XLxJY0SgPWTE5LGxeXxWiZjswqcjflmpV/5qALiq+2sk0vqFeMslP9HXBrAAXv
	bIjwZ6kI0B0XrJS9DV6NvE+I/w/ECXZ6VA3aKv8M0
X-Gm-Gg: Acq92OHK6cy2fU7IdyzG//Eh4k/383y2U6L9OY5jRDDEDN6rXWSXVXhs99D6oeRxYj3
	xiQyFGmqW/kzUTREwiG8Ajlud0ckxrjJeUqw3VgPptYHmH6+BiQKS+ozp4Q1vQ+s+YKZAQdLgeg
	HyiDWspIZ6YqxpFQCFWZ4rqVtsLkz6ew0d014zP4r2gcOP/zFyzyVvY6pAL1GkTEKs/3iLgG4Vv
	7gw258LNnwiPvB074nvLi2ZSzAm3de1K2N7b1pll9uGc83t+7WhM/sQsZhJcu9nPsKMHEFRw31e
	xXExdS6F6XZJkO9JIW6LlDvLLz2wimZ1KaoU1pptfpBpf35P
X-Received: by 2002:a17:903:37d0:b0:2b7:b03d:9dce with SMTP id
 d9443c01a7336-2bdb041671dmr4491685ad.18.1779147671779; Mon, 18 May 2026
 16:41:11 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1777936301.git.abhishekbapat@google.com>
 <d064a1a8de127c0e321f675a9966e533a0917e7e.1777936301.git.abhishekbapat@google.com>
 <2f546525-8ff6-4bbe-86ae-6f474f7cefe3@linux.dev>
In-Reply-To: <2f546525-8ff6-4bbe-86ae-6f474f7cefe3@linux.dev>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Mon, 18 May 2026 16:41:00 -0700
X-Gm-Features: AVHnY4ImPLsbds7akkX1H341x9cN6owK86NVv2eBmbeDXBcUDJajU37sLzNZjmA
Message-ID: <CAL41Mv7zCEFUAD43wBRo+rno2AK-teUUaVSdx2Pd7qDU0uNwsg@mail.gmail.com>
Subject: Re: [PATCH 1/6] alloc_tag: add ioctl to /proc/allocinfo
To: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B58A8180007
X-Stat-Signature: u3d5b3irck8a3dm1xyrab56fbecnj6q7
X-Rspam-User: 
X-HE-Tag: 1779147673-603914
X-HE-Meta: U2FsdGVkX19nFBBP/qEc2IqEz56Xp6+d0nYFjbQWfEbRHBWScEgVxh4oQp9K5/AbZH32UCzN0UWVtHlutrf3/KOiE5z03QfwDzbAktfpaQKLMplvssJviIB3l/dbq9rWVjngS+MEFAOXk25p9LWIgiIH0eUiBk9hAM6C2NGd7D6/1QMo/R/kenCh4i/H2tWtAazoCxBqR4YrlT10VTLjb/eSEEsy8/Hda7zmncNnuAsB2Htv4Gg03mRh2Rc0UVI9UeexRK4b06xgWwdnEvg9jEMhDFuu1itOrXTE1MnV+3asqDsNDHibwTuYuAkS/0Zw5s7uzYe2T3jUAiU+H1fBRdZn8jQP3+XthBcNVuWJ6dl/sNpBRq0EcunTWZbXzzPrsL8Hm9JCzmsNILZXb+1o3VfE3wPnGKpkUegUcwG9TW/ej+UUVwE1xRDXDipb7ZiKv/M8QdnuCii1Dh71q/QEmrdJ/P7Y2gT3ECgkz6MTDmbWC8Qi5fq3BPEWw338jtTO11zUdx1HGDz+lsPJGlB8dkyOLrezFmO1ji+lLUbji0hEBXMTifZ6PzaJaZoKfIpj/tgX4P+3VOGteTPh9rp8p3c49xGHIquEKsxJ0pLQ7+8QiMH8hBGy/b8HcnEAsZiHxRrlaVnUzm4OR/PK5MDscVn7ZkMXgzryTBd/1O7QRPfPtd2bt3q8azQsvMUQIyMsuepyQLGvz2fUqu/RO9UsXWCbEiRUyAFukTHoObQNECve3zi1DF7UYROHQOl1LryU4nQLN0AQEmdya+meIkkB+enjXUvsZfXme1AWV+i66ITIEkKenDm6R2k0qgoUwalK5PMi1NnHoJZAcxO8oX8SmnLGquKwxJoF7hnk6ji5Tvu43qT16cBRVvvZklG+YA7x5BJgqYZOOl8OfvgAwgiT8X3NaTKqQ7/a1aPV9quwvLSPECRHDLz+9dBdMWD3k00AIuyxu4ZW7hYYRRGc8sk
 n5zzsxFQ
 N7QJDgYCUeWvYP131VLvMw1VJXJ1m2TsISI02gU2xINodSB/pbtiKugv7AcHuvoIAORdBGfUfWqlFsvk4P77Y7FQ+mWJaKYeousd5tHOLZul0BisbaHtBQW+Z77AH3xM+CV/N1EsQQHkKsDLX5L/u5T47iNuC9H9rSTgEcp+O2Bv8WRx5F5CqnvOq+gH4VvtxeduERPFpZ3aShV1iyh5oZ8U7RSQ2YL6F8FCu1saZgVjuJvMnTLU3KhXDuCCJQT0rtM0562t91G3NZw8xE/bPohwIGGBoXLlNr6Nceb88m8GPshhhkm2Pg1SpZWfRyD6+tuKdgsCmbUz9488=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 9:38=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Suren and Abhishek
>
>
> Thanks for the patch! A couple of minor comments below.
>
>
> On 2026/5/5 07:36, Abhishek Bapat wrote:
> > From: Suren Baghdasaryan <surenb@google.com>
> >
> > Add the following ioctl commands for /proc/allocinfo file:
> >
> > ALLOCINFO_IOC_CONTENT_ID - gets content identifier which can be used
> > to check whether the file content has changed specifically due to modul=
e
> > load/unload. Every time a module is loaded / unloaded, the returned
> > value will be different. By comparing the identifier value at the
> > beginning and at the end of the content retrieval operation, users can
> > validate retrieved information for consistency.
> >
> > ALLOCINFO_IOC_GET_AT - gets the record at the specified position. This
> > is the position of a record in /proc/allocinfo.
> >
> > ALLOCINFO_IOC_GET_NEXT - gets the record next to the last retrieved
> > one. If no records were previously retrieved, returns the first
> > record.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > ---
> >   .../userspace-api/ioctl/ioctl-number.rst      |   2 +
> >   include/linux/codetag.h                       |   1 +
> >   include/uapi/linux/alloc_tag.h                |  54 ++++++
> >   lib/alloc_tag.c                               | 178 +++++++++++++++++=
-
> >   lib/codetag.c                                 |  11 ++
> >   5 files changed, 244 insertions(+), 2 deletions(-)
> >   create mode 100644 include/uapi/linux/alloc_tag.h
> >
> > diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Docum=
entation/userspace-api/ioctl/ioctl-number.rst
> > index 331223761fff..84f6808a8578 100644
> > --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> > +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> > @@ -349,6 +349,8 @@ Code  Seq#    Include File                         =
                    Comments
> >                                                                        =
  <mailto:luzmaximilian@gmail.com>
> >   0xA5  20-2F  linux/surface_aggregator/dtx.h                          =
  Microsoft Surface DTX driver
> >                                                                        =
  <mailto:luzmaximilian@gmail.com>
> > +0xA6  00-0F  uapi/linux/alloc_tag.h                                   =
 Memory allocation profiling
> > +                                                                      =
 <mailto:surenb@google.com>
> >   0xAA  00-3F  linux/uapi/linux/userfaultfd.h
> >   0xAB  00-1F  linux/nbd.h
> >   0xAC  00-1F  linux/raw.h
> > diff --git a/include/linux/codetag.h b/include/linux/codetag.h
> > index 8ea2a5f7c98a..2bcd4e7c809e 100644
> > --- a/include/linux/codetag.h
> > +++ b/include/linux/codetag.h
> > @@ -76,6 +76,7 @@ struct codetag_iterator {
> >
> >   void codetag_lock_module_list(struct codetag_type *cttype, bool lock)=
;
> >   bool codetag_trylock_module_list(struct codetag_type *cttype);
> > +unsigned long codetag_get_content_id(struct codetag_type *cttype);
> >   struct codetag_iterator codetag_get_ct_iter(struct codetag_type *ctty=
pe);
> >   struct codetag *codetag_next_ct(struct codetag_iterator *iter);
> >
> > diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_=
tag.h
> > new file mode 100644
> > index 000000000000..e9a5b55fcc7a
> > --- /dev/null
> > +++ b/include/uapi/linux/alloc_tag.h
> > @@ -0,0 +1,54 @@
> > +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> > +/*
> > + *  include/linux/alloc_tag.h
> > + */
> > +
> > +#ifndef _UAPI_ALLOC_TAG_H
> > +#define _UAPI_ALLOC_TAG_H
> > +
> > +#include <linux/types.h>
> > +
> > +#define ALLOCINFO_STR_SIZE   64
> > +
> > +struct allocinfo_content_id {
> > +     __u64 id;
> > +};
> > +
> > +struct allocinfo_tag {
> > +     /* Longer names are trimmed */
> > +     char modname[ALLOCINFO_STR_SIZE];
> > +     char function[ALLOCINFO_STR_SIZE];
> > +     char filename[ALLOCINFO_STR_SIZE];
> > +     __u64 lineno;
> > +};
> > +
> > +struct allocinfo_counter {
> > +     __u64 bytes;
> > +     __u64 calls;
> > +     __u8 accurate;
> > +     __u8 pad[7]; /* Add alignment to not break the 32-bit compatible =
interface */
> > +};
> > +
> > +struct allocinfo_tag_data {
> > +     struct allocinfo_tag tag;
> > +     struct allocinfo_counter counter;
> > +};
> > +
> > +struct allocinfo_get_at {
> > +     __u64 pos;      /* input */
> > +     struct allocinfo_tag_data data;
> > +};
> > +
> > +#define _ALLOCINFO_IOC_CONTENT_ID    0
> > +#define _ALLOCINFO_IOC_GET_AT                1
> > +#define _ALLOCINFO_IOC_GET_NEXT              2
> > +
> > +#define ALLOCINFO_IOC_BASE           0xA6
> > +#define ALLOCINFO_IOC_CONTENT_ID     _IOR(ALLOCINFO_IOC_BASE, _ALLOCIN=
FO_IOC_CONTENT_ID,     \
> > +                                          struct allocinfo_content_id)
> > +#define ALLOCINFO_IOC_GET_AT         _IOWR(ALLOCINFO_IOC_BASE, _ALLOCI=
NFO_IOC_GET_AT,        \
> > +                                           struct allocinfo_get_at)
> > +#define ALLOCINFO_IOC_GET_NEXT               _IOR(ALLOCINFO_IOC_BASE, =
_ALLOCINFO_IOC_GET_NEXT,       \
> > +                                          struct allocinfo_tag_data)
> > +
> > +#endif /* _UAPI_ALLOC_TAG_H */
> > diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> > index ed1bdcf1f8ab..5c24d2f954d4 100644
> > --- a/lib/alloc_tag.c
> > +++ b/lib/alloc_tag.c
> > @@ -14,6 +14,7 @@
> >   #include <linux/string_choices.h>
> >   #include <linux/vmalloc.h>
> >   #include <linux/kmemleak.h>
> > +#include <uapi/linux/alloc_tag.h>
> >
> >   #define ALLOCINFO_FILE_NAME         "allocinfo"
> >   #define MODULE_ALLOC_TAG_VMAP_SIZE  (100000UL * sizeof(struct alloc_t=
ag))
> > @@ -46,6 +47,9 @@ int alloc_tag_ref_offs;
> >   struct allocinfo_private {
> >       struct codetag_iterator iter;
> >       bool print_header;
> > +     /* ioctl uses a separate iterator not to interfere with reads */
> > +     struct codetag_iterator ioctl_iter;
> > +     bool positioned; /* seq_open_private() sets to 0 */
> >   };
> >
> >   static void *allocinfo_start(struct seq_file *m, loff_t *pos)
> > @@ -125,6 +129,177 @@ static const struct seq_operations allocinfo_seq_=
op =3D {
> >       .show   =3D allocinfo_show,
> >   };
> >
> > +static int allocinfo_open(struct inode *inode, struct file *file)
> > +{
> > +     return seq_open_private(file, &allocinfo_seq_op,
> > +                             sizeof(struct allocinfo_private));
> > +}
> > +
> > +static int allocinfo_release(struct inode *inode, struct file *file)
> > +{
> > +     return seq_release_private(inode, file);
> > +}
> > +
> > +static const char *allocinfo_str(const char *str)
> > +{
> > +     size_t len =3D strlen(str);
> > +
> > +     /* Keep an extra space for the trailing NULL. */
> > +     if (len >=3D ALLOCINFO_STR_SIZE)
> > +             str +=3D (len - ALLOCINFO_STR_SIZE) + 1;
> > +     return str;
> > +}
> > +
> > +/* Copy a string and trim from the beginning if it's too long */
> > +static void allocinfo_copy_str(char *dest, const char *src)
> > +{
> > +     strscpy(dest, allocinfo_str(src), ALLOCINFO_STR_SIZE);
> > +}
> > +
> > +static void allocinfo_to_params(struct codetag *ct,
> > +                             struct allocinfo_tag_data *data)
> > +{
> > +     struct alloc_tag *tag =3D ct_to_alloc_tag(ct);
> > +     struct alloc_tag_counters counter =3D alloc_tag_read(tag);
> > +
> > +     if (ct->modname)
> > +             allocinfo_copy_str(data->tag.modname, ct->modname);
> > +     else
> > +             data->tag.modname[0] =3D '\0';
>
> Minor nit about allocinfo_to_params():
>
> When modname is NULL (built-in kernel code), the current code sets it
>
> to an empty string:
>
>      if (ct->modname)
>
>          allocinfo_copy_str(data->tag.modname, ct->modname);
>
>      else
>
>          data->tag.modname[0] =3D '\0';
>
> This is of course workable in userspace by checking for an empty
>
> string, but I was wondering if it would be cleaner to use "vmlinux"
>
> as a default:
>
> else
>
>            allocinfo_copy_str(data->tag.modname, "vmlinux");
>
>
> For some context, in our memory analysis workflow we often group
>
> allocations by module to get a quick overview of where memory goes,
>
> for example:
>
> vmlinux:    2.1 GB    (kernel core)
>
> nvidia:     1.2 GB    (GPU driver)
>
> iwlwifi:    800 MB    (WiFi driver)
>
> ext4:       500 MB    (filesystem)
>
> Having a consistent identifier for kernel built-in allocations would
>
> avoid each userspace tool needing to handle the empty string as a
>
> special case. Totally fine if this is intentional though.
>
Thanks for bringing this up, I can certainly make this change.
However, the information is not currently exposed this way through
/proc/allocinfo. /proc/allocinfo does not categorize kernel non-module
allocations as vmlinux, so there will a delta between how IOCTL and
/proc/allocinfo behave. Suren, could you comment on whether this
recommendation is fine by you?

> > +     allocinfo_copy_str(data->tag.function, ct->function);
> > +     allocinfo_copy_str(data->tag.filename, ct->filename);
> > +     data->tag.lineno =3D ct->lineno;
> > +     data->counter.bytes =3D counter.bytes;
> > +     data->counter.calls =3D counter.calls;
> > +     data->counter.accurate =3D !alloc_tag_is_inaccurate(tag);
> > +}
> > +
> > +static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __u=
ser *arg)
> > +{
> > +     struct allocinfo_content_id params;
> > +
> > +     codetag_lock_module_list(alloc_tag_cttype, true);
> > +     params.id =3D codetag_get_content_id(alloc_tag_cttype);
> > +     codetag_lock_module_list(alloc_tag_cttype, false);
> > +     if (copy_to_user(arg, &params, sizeof(params)))
> > +             return -EFAULT;
> > +
> > +     return 0;
> > +}
> > +
> > +static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg=
)
> > +{
> > +     struct allocinfo_private *priv;
> > +     struct codetag *ct;
> > +     __u64 pos;
> > +     struct allocinfo_get_at params =3D {0};
> > +
> > +     if (copy_from_user(&params, arg, sizeof(params)))
> > +             return -EFAULT;
> > +
> > +     priv =3D (struct allocinfo_private *)m->private;
> > +     pos =3D params.pos;
> > +
> > +     codetag_lock_module_list(alloc_tag_cttype, true);
> > +
> > +     /* Find the codetag */
> > +     priv->ioctl_iter =3D codetag_get_ct_iter(alloc_tag_cttype);
> > +     ct =3D codetag_next_ct(&priv->ioctl_iter);
> > +     while (ct && pos--)
> > +             ct =3D codetag_next_ct(&priv->ioctl_iter);
>
> I noticed that codetag_next_ct(&priv->ioctl_iter) and
>
> priv->positioned are accessed without serialization in the ioctl
>
> path. Concurrent ioctl calls on the same fd could race on these
>
> fields. Just something I spotted while reading the code.
>
>
> Thanks
>
> Best Regards
>
> Hao
>
I believe this should be prevented by `codetag_lock_module_list`; am I
wrong in my understanding?

> > +     if (ct) {
> > +             allocinfo_to_params(ct, &params.data);
> > +             priv->positioned =3D true;
> > +     }
> > +
> > +     codetag_lock_module_list(alloc_tag_cttype, false);
> > +
> > +     if (!ct)
> > +             return -ENOENT;
> > +
> > +     if (copy_to_user(arg, &params, sizeof(params)))
> > +             return -EFAULT;
> > +
> > +     return 0;
> > +}
> > +
> > +static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *a=
rg)
> > +{
> > +     struct allocinfo_private *priv;
> > +     struct codetag *ct;
> > +     struct allocinfo_tag_data params =3D {0};
> > +     int ret =3D 0;
> > +
> > +     priv =3D (struct allocinfo_private *)m->private;
> > +
> > +     codetag_lock_module_list(alloc_tag_cttype, true);
> > +
> > +     if (!priv->positioned) {
> > +             priv->ioctl_iter =3D codetag_get_ct_iter(alloc_tag_cttype=
);
> > +             priv->positioned =3D true;
> > +     }
> > +
> > +     ct =3D codetag_next_ct(&priv->ioctl_iter);
> > +     if (ct)
> > +             allocinfo_to_params(ct, &params);
> > +
> > +     if (!ct) {
> > +             priv->positioned =3D false;
> > +             ret =3D -ENOENT;
> > +     }
> > +     codetag_lock_module_list(alloc_tag_cttype, false);
> > +
> > +     if (ret =3D=3D 0) {
> > +             if (copy_to_user(arg, &params, sizeof(params)))
> > +                     return -EFAULT;
> > +     }
> > +     return ret;
> > +}
> > +
> > +static long allocinfo_ioctl(struct file *file, unsigned int cmd,
> > +                         unsigned long __arg)
> > +{
> > +     void __user *arg =3D (void __user *)__arg;
> > +     int ret;
> > +
> > +     switch (cmd) {
> > +     case ALLOCINFO_IOC_CONTENT_ID:
> > +             ret =3D allocinfo_ioctl_get_content_id(file->private_data=
, arg);
> > +             break;
> > +     case ALLOCINFO_IOC_GET_AT:
> > +             ret =3D allocinfo_ioctl_get_at(file->private_data, arg);
> > +             break;
> > +     case ALLOCINFO_IOC_GET_NEXT:
> > +             ret =3D allocinfo_ioctl_get_next(file->private_data, arg)=
;
> > +             break;
> > +     default:
> > +             ret =3D -ENOIOCTLCMD;
> > +             break;
> > +     }
> > +
> > +     return ret;
> > +}
> > +
> > +#ifdef CONFIG_COMPAT
> > +static long allocinfo_compat_ioctl(struct file *file, unsigned int cmd=
,
> > +                                unsigned long arg)
> > +{
> > +     return allocinfo_ioctl(file, cmd, (unsigned long)compat_ptr(arg))=
;
> > +}
> > +#endif
> > +
> > +static const struct proc_ops allocinfo_proc_ops =3D {
> > +     .proc_open              =3D allocinfo_open,
> > +     .proc_read_iter         =3D seq_read_iter,
> > +     .proc_lseek             =3D seq_lseek,
> > +     .proc_release           =3D allocinfo_release,
> > +     .proc_ioctl             =3D allocinfo_ioctl,
> > +#ifdef CONFIG_COMPAT
> > +     .proc_compat_ioctl      =3D allocinfo_compat_ioctl,
> > +#endif
> > +
> > +};
> > +
> >   size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count, =
bool can_sleep)
> >   {
> >       struct codetag_iterator iter;
> > @@ -946,8 +1121,7 @@ static int __init alloc_tag_init(void)
> >               return 0;
> >       }
> >
> > -     if (!proc_create_seq_private(ALLOCINFO_FILE_NAME, 0400, NULL, &al=
locinfo_seq_op,
> > -                                  sizeof(struct allocinfo_private), NU=
LL)) {
> > +     if (!proc_create(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_proc=
_ops)) {
> >               pr_err("Failed to create %s file\n", ALLOCINFO_FILE_NAME)=
;
> >               shutdown_mem_profiling(false);
> >               return -ENOMEM;
> > diff --git a/lib/codetag.c b/lib/codetag.c
> > index 304667897ad4..93aa30991563 100644
> > --- a/lib/codetag.c
> > +++ b/lib/codetag.c
> > @@ -48,6 +48,17 @@ bool codetag_trylock_module_list(struct codetag_type=
 *cttype)
> >       return down_read_trylock(&cttype->mod_lock) !=3D 0;
> >   }
> >
> > +unsigned long codetag_get_content_id(struct codetag_type *cttype)
> > +{
> > +     lockdep_assert_held(&cttype->mod_lock);
> > +
> > +     /*
> > +      * next_mod_seq is updated on every load, so can be used to ident=
ify
> > +      * content changes.
> > +      */
> > +     return cttype->next_mod_seq;
> > +}
> > +
> >   struct codetag_iterator codetag_get_ct_iter(struct codetag_type *ctty=
pe)
> >   {
> >       struct codetag_iterator iter =3D {

Note, I will be following up with a v2 patchset with your feedback
included. Please bring up any other points you'd want to clarify so
that I can include all the changes in the v2 patchset. Thanks for
reviewing!

