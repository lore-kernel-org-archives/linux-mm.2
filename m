Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99019CD8C9D
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 00:19:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0845A6B0005; Mon,  8 Jun 2026 20:19:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05C1A6B0088; Mon,  8 Jun 2026 20:19:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB3A06B008A; Mon,  8 Jun 2026 20:19:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA3036B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:19:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A7C9F1C2144
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:19:33 +0000 (UTC)
X-FDA: 84858465426.12.BE04496
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9566A4000B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:19:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RnONu2+T;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780964371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ya4+fO9XzBWfdc4Ka8Bh+sYylF5sEr5adVMzLIQQnag=;
	b=A18lkaQxPWnnCUSaYH90h1dznaOJbYOw+lrddsaP+ctBcW/S7xZNmGpDhxmYHiZGVlTMaS
	LRKAvlo4c5uQ4OzW5il+O7KwYs+++fVEs2eZI9P36G46/eEHUiUgfmXlbSL3dIpwUJYOyg
	CfgX5u6T555AUVUYPE7T/TE4E+47rsw=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RnONu2+T;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780964371;
	b=MzguddNn8gP6DcVjom4IsHh6kYooVHdpWJp+RBe3+b1e0AmgjPg90OBJHv+pUboGSuy77r
	oIRLHaCLs/0YWvxItVpQWnKVxC/+x+B4XorwCT8DgbBuJpBlvmjNOlEqR1rCSnyfhpK6uX
	NidIs/JF3kN4Pji85qY8FYaBuBoHX74=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2bf2d865383so380335ad.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 17:19:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780964370; cv=none;
        d=google.com; s=arc-20240605;
        b=ShSlp4JMdRaGJ5lwK5gIGb7Fx/YmvLUteoDr4gLY2BHhoLrvUX4ZNgqAyDzZP0CEg4
         vmx0a+4ndGlG8BEMicIQTSZ5j1dvmcT7KWfT01/5rkxWB0G93DjGRhZ5xInZKsBLqyoZ
         Smyzs6o5s1c9V6B6WTdL6i0chj/npbbp5TLWO+E8DQE9k/tC10vBmaFlRW/s3dk6kWKh
         D7YGAykwrcnj4Srii7p3gPEbZncVYdwA9K7uc3zSENuSqVl9nUrt6J+PEniCGjqiS7Df
         kRtfPjWHbvT6wgb7cryMDikklbNKwTvsSo3sOrTp4L4grOjC4/X+gEw1Ts/pgfXajUvu
         IxQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ya4+fO9XzBWfdc4Ka8Bh+sYylF5sEr5adVMzLIQQnag=;
        fh=TwBgEnXQtvmy5oFtcgYMhL8Bfu+GCnFyMo5zhijG+EM=;
        b=YuH1IKwSWCN6aia2QSUrTRJaGX2jDJfa0oy4nG+m74MNkRL2CGdqzugAgFhhsyY3VH
         bD3c0q8jPXJytWlooMnxozpX6oqF7Zt+fR02LfUvYFOgok75xJI3RoucvDuAQu53QcY+
         Kc/Dcxm+ySzIe/VLkTVRFd8q64Mn6KKCyRRQTzjboS3qmXrhZHqpH6LA+1nWSAzEBW56
         LvLdnCLKDXHIYR280qcqB+mXkcBw1VKFWbIAQB9avqWgFwsTh1ix3XoPYKaDwICEu65D
         g2ZAJtuys3cmXxSOYh3PFI+3A9Z9HZolFJJQyouJBEjKvNX50qBOHotdM/K/qOypvjTh
         uGyg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780964370; x=1781569170; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ya4+fO9XzBWfdc4Ka8Bh+sYylF5sEr5adVMzLIQQnag=;
        b=RnONu2+TxLNUcRLa4/Tvm1mM82qXfS4+5MtuwWixCqqucpsoE8OTunr+iBEJe2oqAs
         c2TY0O1Mtt58Dhwp6RV7OsfHuIqmcPrWXf8N6ls8ixtImJ305Qldt2LF/3aSzkr2hZJ0
         tMOPttMbKpx0zuJErBJashj+VDmSnqKiMjf4dPGV03IRUrrsZg6lFcg1zs+odiNTU4UQ
         /LKT+6Cz/TfAsPwrp+YkYPXotpQoAu/y2QlLpW6DPAdfD39HZywOlz6OjAP5XGgb2a3j
         ju2yY713OHXll2hdWjqAkh/Fd0VFCENOWYvqaAnRmK5z/Gl5bq3zE0gl6CtvJKSMX0Fu
         g2vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780964370; x=1781569170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ya4+fO9XzBWfdc4Ka8Bh+sYylF5sEr5adVMzLIQQnag=;
        b=pDB7qKZ5L5me3Fx8NepYFWtSGUGtiYpvFX1a5pVNkXcOarBV6x3N/TUj26DpOixqn9
         NnhfzQEfcb5b0Fk8yA9N4rcI8j/PXy3r790+84pQIXePpNxBeVZ8p0Q0SX2qd1EP+Fnl
         /1+6HZtzJR2gXAWgWS6Tv9fvHoCc6zkodj+hxjyulT1EzXkAJxtqqy3bG8H1vr3Gw8wc
         xvo51lNF2HD+/JlF7rrnULng9YurQE0IzlkOoeS9+2EQaLDABenqEzbXycbatOmrbKnE
         SFp/0zIMVldtSTevmQFxTpkeTHD/cUHGW5hTIHdVT+uEnJsjg9o8avxfAiZil6JThOHX
         1/Dw==
X-Forwarded-Encrypted: i=1; AFNElJ8ecMiaPSjl9fSeoTpfdHlnenxhqwCeWEfDqumnMkmi00EgLbxqyA86fosZW0muhtEMvuhgYDytHQ==@kvack.org
X-Gm-Message-State: AOJu0YyEhhk6Gu9dtJ3QTSjlceZqpmi5UWUn1tRUK0aZ3Gk+B5afNB3u
	eo/38wNM6VcKGjRYhWsMatL1cUX9FL0RgT2Wr0ESmgix0Ze6dD8w+s/KC+doRkUFGwXwme8cl6D
	bO9wtLkb6/F/HrzuB1IPtCewDdF9WH+iKkM+ACohQ
X-Gm-Gg: Acq92OH/R/VO9k8YizT6TrP7HUraxBny/jz/QYwR0OyTBHfef+++ymggRrj4RC1CmfF
	tK5NoQANt7RMrVPNiHaWSYH7X/ZuO90FCk1VX0E3rxRUlCJPKxwrZbmkFaYZTxMiwA3cpcklAUL
	EfbEs6fZ0bZ6F1OPrKWS5C6kBKO6cQi2oYAWGhATlLiYjs9Pn7sUBkOVZipuvvqr0RR5v62YseZ
	B+8iP9i/Ay1MYEKIvvA9bxaEg1XW9ijyIj8E8oM0seVpwwVzEOaLT8sE4qUCFOvUBP+Q7XPPmSx
	JyxijllFiuzUwqa/K0Om/5S/LA1I7bRJhjWfTW5Dofu58wmB
X-Received: by 2002:a17:902:ced0:b0:2c1:ee6e:be20 with SMTP id
 d9443c01a7336-2c1ee6ec4f3mr6353845ad.30.1780964369832; Mon, 08 Jun 2026
 17:19:29 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1780701922.git.abhishekbapat@google.com>
 <0e91fdd3a88dbe5220d15c4c8ff7b8f66e86af7c.1780701922.git.abhishekbapat@google.com>
 <41a7ebb9-1113-4f13-abbf-6f55d99d62f3@linux.dev>
In-Reply-To: <41a7ebb9-1113-4f13-abbf-6f55d99d62f3@linux.dev>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Mon, 8 Jun 2026 17:19:18 -0700
X-Gm-Features: AVVi8CfX0QyYbAeRHXTJeGRPllP0GCdLx4rHVaUYJ_oHiIiT8YRFTysM4ZblUVw
Message-ID: <CAL41Mv7jOJ0rtAEDZP2DEGa5d1GfTbK=DXg8k1BL5qjFuQjNuA@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] alloc_tag: add ioctl to /proc/allocinfo
To: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9566A4000B
X-Rspam-User: 
X-Stat-Signature: raaaup1uxyq7tbe4mwwst461z8oo4aq3
X-Rspamd-Server: rspam09
X-HE-Tag: 1780964371-374647
X-HE-Meta: U2FsdGVkX18QvdiRNNJpKdO1lA6gL79ytLqmsVSQcmgEqm617TdX212ktF9/pCC2Wr1VCQ1UAuab0pDb6R07OSKtk879tw6oAb0wdFd3BHg7aazo5rO19BWSg5Gu7GX35lSVkfPmzxbPxiut0B20jhc5HSv01y7Y+gqBpgJj6yUVMG5HvtG9JhNCV/zkmWRn1/etPyNS9P+gBuk0X2UmHDfqtAeUvCsTOCix9ordV4fgCuKcYeNiKD8IUyE3QOK1wPI0MBF9YpTB4oDFv+SVu/fRPfviMKKa7Di3A6X3vmhCVYKYy5fmYbT4R/VyHT3jQ/++o06teCxo7CdoswhkhuInVFKxz5ThVSZ1gOrFxbCPCuesjRi7iTq6ynATNbaCnnnahnGlPhHxUXH2ltnE9fo+p5JJBow9VMBcWH+IsI7JpCmxAghbTIwX/HTkD7Vaa96cPbSx98RMEurJwI9OQISGHtNg59O6hqh+/4Zr3RsR0/G6fjpvElBldGrbAHTzDQMIs3PzPC8qUYy8CiEg2JREBG3l8QusfGnJTX1eLMdXhY+5W23P/prL5S8UcVRl7xKr8oRnbCoHm1vyrA0iG8p/LsaS5Mw8guUJiu3XLxKLFaPX5HgD3Gehoiqke6asOxmYM3kFXROnpEMQ8y0nLgHMyJ2Ug/Juig0Xjr8KcNVpmGeuRZSoXd4WqpxwNaTOqQiuJ+cWaPeZMHa19iK+fQTe0QoFk3P+LFByeDMU3okz4GC9pw9bfJE+s9GU186ZgRiRurBxfojeOPpfjD0KY/hWp1nv9Q2YwwEmTF9RuGRkUA1kyagGv3ZLmG79J9RAUJKw7B4dHpg19Avgt5+zLiU8VZDCaq+j9Mo0wXlfbWzXyKVt7hF0IHenH4XmrYhQCI3SeXSfaVP9vQYIFZFwmv09K0NuknlQ7zpn3MyxLSswuSpCYbuX/+nZHKmlA1XJarLYyqv5iJToqkZdwVK
 +IggJGcG
 2uc4zfK6rzph9XElAeTM8NWqeHf+aS5nkHQ2JbeY3mdle+h3su1NbXJ2MdmiB+4yYMRMHC6yFtVgjBNTXCavOUXeNcYl6eE5NsO1KMdiBeVCkFaaZSjmzwUAHYhAlcLptKJ+1+X82cW25VFfoO8zZXvDETntHr2NMIR6de/rlCbmvH7ERKesHBHelOzIlckJUD7mY/iF0lmQGMXzkClLId57Qo9+6LH1bD1/+ITXujwoDW07dEc9ThlJPBjOyHlUhz7jq0YCcMsWXFVMsnuaO0CyeSarcXOBCT9tFuS6OrXPIg/MqE+lyyfRm112VK2X5Srpkgcoo0wT7Jw4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jun 7, 2026 at 6:53=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Suren and Abhishek
>
>
> Thanks for the new version.
>
>
> On 2026/6/6 07:36, Abhishek Bapat wrote:
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
> >   Documentation/mm/allocation-profiling.rst     |   5 +
> >   .../userspace-api/ioctl/ioctl-number.rst      |   2 +
> >   MAINTAINERS                                   |   1 +
> >   include/linux/codetag.h                       |   2 +
> >   include/uapi/linux/alloc_tag.h                |  54 ++++
> >   lib/alloc_tag.c                               | 232 +++++++++++++++++=
-
> >   lib/codetag.c                                 |  18 ++
> >   7 files changed, 312 insertions(+), 2 deletions(-)
> >   create mode 100644 include/uapi/linux/alloc_tag.h
> >
> > diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/=
mm/allocation-profiling.rst
> > index 5389d241176a..c3a28467955f 100644
> > --- a/Documentation/mm/allocation-profiling.rst
> > +++ b/Documentation/mm/allocation-profiling.rst
> > @@ -46,6 +46,11 @@ sysctl:
> >   Runtime info:
> >     /proc/allocinfo
> >
> > +  Profiling data can be retrieved either by reading `/proc/allocinfo` =
directly as
> > +  text or programmatically via `ioctl()` calls defined in `<uapi/linux=
/alloc_tag.h>`.
> > +  The ioctl interface supports structured binary data extraction as we=
ll as filtering
> > +  by module name, function, file, line number, accuracy, or allocation=
 size limits.
> > +
> >   Example output::
> >
> >     root@moria-kvm:~# sort -g /proc/allocinfo|tail|numfmt --to=3Diec
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
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index a31f6f207afd..77f3fc487691 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -16711,6 +16711,7 @@ S:    Maintained
> >   F:  Documentation/mm/allocation-profiling.rst
> >   F:  include/linux/alloc_tag.h
> >   F:  include/linux/pgalloc_tag.h
> > +F:   include/uapi/linux/alloc_tag.h
> >   F:  lib/alloc_tag.c
> >
> >   MEMORY CONTROLLER DRIVERS
> > diff --git a/include/linux/codetag.h b/include/linux/codetag.h
> > index ddae7484ca45..a25a085c2df1 100644
> > --- a/include/linux/codetag.h
> > +++ b/include/linux/codetag.h
> > @@ -77,6 +77,8 @@ struct codetag_iterator {
> >   void codetag_lock_module_list(struct codetag_type *cttype);
> >   bool codetag_trylock_module_list(struct codetag_type *cttype);
> >   void codetag_unlock_module_list(struct codetag_type *cttype);
> > +unsigned long codetag_get_content_id(struct codetag_type *cttype);
> > +unsigned int codetag_get_count(struct codetag_type *cttype);
> >   struct codetag_iterator codetag_get_ct_iter(struct codetag_type *ctty=
pe);
> >   struct codetag *codetag_next_ct(struct codetag_iterator *iter);
> >
> > diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_=
tag.h
> > new file mode 100644
> > index 000000000000..901199bad514
> > --- /dev/null
> > +++ b/include/uapi/linux/alloc_tag.h
> > @@ -0,0 +1,54 @@
> > +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> > +/*
> > + *  include/linux/alloc_tag.h
>
> nit: it should be include/uapi/linux/alloc_tag.h
>
> (I guess you may have missed the comment I brought up before. It is not
> a critical problem though.)
>
Apologies, I missed that comment earlier. Included in the v4 patchset.
Thanks for bringing this up.

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
> > +/* The alignment ensures 32-bit compatible interfaces are not broken *=
/
> > +struct allocinfo_counter {
> > +     __u64 bytes;
> > +     __u64 calls;
> > +     __u8 accurate;
> > +} __attribute__((aligned(8)));
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
> > index d9be1cf5187d..a0577215eb3d 100644
> > --- a/lib/alloc_tag.c
> > +++ b/lib/alloc_tag.c
> > @@ -5,6 +5,7 @@
> >   #include <linux/gfp.h>
> >   #include <linux/kallsyms.h>
> >   #include <linux/module.h>
> > +#include <linux/mutex.h>
> >   #include <linux/page_ext.h>
> >   #include <linux/pgalloc_tag.h>
> >   #include <linux/proc_fs.h>
> > @@ -14,6 +15,7 @@
> >   #include <linux/string_choices.h>
> >   #include <linux/vmalloc.h>
> >   #include <linux/kmemleak.h>
> > +#include <uapi/linux/alloc_tag.h>
> >
> >   #define ALLOCINFO_FILE_NAME         "allocinfo"
> >   #define MODULE_ALLOC_TAG_VMAP_SIZE  (100000UL * sizeof(struct alloc_t=
ag))
> > @@ -47,6 +49,10 @@ struct allocinfo_private {
> >       struct codetag_iterator iter;
> >       struct codetag_iterator reported_iter;
> >       bool print_header;
> > +     /* ioctl uses a separate iterator not to interfere with reads */
> > +     struct codetag_iterator ioctl_iter;
> > +     bool positioned; /* seq_open_private() sets to 0 */
> > +     struct mutex ioctl_lock;
> >   };
> >
> >   static void *allocinfo_start(struct seq_file *m, loff_t *pos)
> > @@ -130,6 +136,229 @@ static const struct seq_operations allocinfo_seq_=
op =3D {
> >       .show   =3D allocinfo_show,
> >   };
> >
> > +/*
> > + * Initializes seq_file operations and allocates private state when op=
ening
> > + * the /proc/allocinfo procfs entry.
> > + */
> > +static int allocinfo_open(struct inode *inode, struct file *file)
> > +{
> > +     int ret;
> > +
> > +     ret =3D seq_open_private(file, &allocinfo_seq_op,
> > +                            sizeof(struct allocinfo_private));
> > +     if (!ret) {
> > +             struct seq_file *m =3D file->private_data;
> > +             struct allocinfo_private *priv =3D m->private;
> > +
> > +             mutex_init(&priv->ioctl_lock);
> > +     }
> > +     return ret;
> > +}
> > +
> > +/*
> > + * Cleans up the seq_file state and frees up the private state allocat=
ed in
> > + * allocinfo_open() when closing the /proc/allocinfo file descriptor.
> > + */
> > +static int allocinfo_release(struct inode *inode, struct file *file)
> > +{
> > +     return seq_release_private(inode, file);
> > +}
> > +
> > +/*
> > + * Returns a pointer to the suffix of a string so that its length fits=
 within
> > + * ALLOCINFO_STR_SIZE, preserving the trailing characters.
> > + */
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
> > +     strscpy_pad(dest, allocinfo_str(src), ALLOCINFO_STR_SIZE);
> > +}
> > +
> > +/*
> > + * Populates the UAPI allocinfo_tag_data structure with active runtime
> > + * profiling counters extracted from the given kernel codetag.
> > + */
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
> > +     allocinfo_copy_str(data->tag.function, ct->function);
> > +     allocinfo_copy_str(data->tag.filename, ct->filename);
> > +     data->tag.lineno =3D ct->lineno;
> > +     data->counter.bytes =3D counter.bytes;
> > +     data->counter.calls =3D counter.calls;
> > +     data->counter.accurate =3D !alloc_tag_is_inaccurate(tag);
> > +}
> > +
> > +/*
> > + * Retrieves the unique content ID representing the current allocation=
 tag module
> > + * layout, allowing userspace to detect if modules were loaded / unloa=
ded.
> > + */
> > +static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __u=
ser *arg)
> > +{
> > +     struct allocinfo_content_id params;
> > +
> > +     codetag_lock_module_list(alloc_tag_cttype);
> > +     params.id =3D codetag_get_content_id(alloc_tag_cttype);
> > +     codetag_unlock_module_list(alloc_tag_cttype);
> > +     if (copy_to_user(arg, &params, sizeof(params)))
> > +             return -EFAULT;
> > +
> > +     return 0;
> > +}
> > +
> > +/*
> > + * Seeks the ioctl iterator to the specified 0-indexed tag position, r=
eads its
> > + * profiling data and returns it to userspace.
> > + */
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
> > +     priv =3D m->private;
> > +     pos =3D params.pos;
> > +
> > +     mutex_lock(&priv->ioctl_lock);
> > +     codetag_lock_module_list(alloc_tag_cttype);
> > +
> > +     if (pos >=3D codetag_get_count(alloc_tag_cttype)) {
> > +             codetag_unlock_module_list(alloc_tag_cttype);
> > +             mutex_unlock(&priv->ioctl_lock);
> > +             return -ENOENT;
> > +     }
> > +
> > +     /* Find the codetag */
> > +     priv->ioctl_iter =3D codetag_get_ct_iter(alloc_tag_cttype);
> > +     ct =3D codetag_next_ct(&priv->ioctl_iter);
> > +     while (ct && pos--)
> > +             ct =3D codetag_next_ct(&priv->ioctl_iter);
> > +     if (ct) {
> > +             allocinfo_to_params(ct, &params.data);
> > +             priv->positioned =3D true;
> > +     }
> > +
> > +     codetag_unlock_module_list(alloc_tag_cttype);
> > +     mutex_unlock(&priv->ioctl_lock);
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
> > +/*
> > + * Advances the ioctl iterator to the next allocation tag in the seque=
nce and
> > + * returns its profiling data to userspace.
> > + */
> > +static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *a=
rg)
> > +{
> > +     struct allocinfo_private *priv;
> > +     struct codetag *ct;
> > +     struct allocinfo_tag_data params;
> > +     int ret =3D 0;
> > +
> > +     memset(&params, 0, sizeof(params));
> > +     priv =3D m->private;
> > +
> > +     mutex_lock(&priv->ioctl_lock);
> > +     codetag_lock_module_list(alloc_tag_cttype);
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
> > +     codetag_unlock_module_list(alloc_tag_cttype);
> > +     mutex_unlock(&priv->ioctl_lock);
> > +
> > +     if (ret =3D=3D 0) {
> > +             if (copy_to_user(arg, &params, sizeof(params)))
> > +                     return -EFAULT;
> > +     }
> > +     return ret;
> > +}
> > +
> > +/*
> > + * Entry point ioctl function for /proc/allocinfo routing requests to =
fetch the
> > + * layout content ID, seek to a specific tag, or read sequential tags.
> > + */
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
> > @@ -993,8 +1222,7 @@ static int __init alloc_tag_init(void)
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
> > index 4001a7ea6675..a9cda4c962a3 100644
> > --- a/lib/codetag.c
> > +++ b/lib/codetag.c
> > @@ -19,6 +19,8 @@ struct codetag_type {
> >       struct codetag_type_desc desc;
> >       /* generates unique sequence number for module load */
> >       unsigned long next_mod_seq;
> > +     /* bumped on every module load and unload */
> > +     unsigned long content_id;
> >   };
> >
> >   struct codetag_range {
> > @@ -50,6 +52,20 @@ void codetag_unlock_module_list(struct codetag_type =
*cttype)
> >       up_read(&cttype->mod_lock);
> >   }
> >
> > +unsigned long codetag_get_content_id(struct codetag_type *cttype)
> > +{
> > +     lockdep_assert_held(&cttype->mod_lock);
> > +
> > +     return cttype->content_id;
> > +}
> > +
> > +unsigned int codetag_get_count(struct codetag_type *cttype)
> > +{
> > +     lockdep_assert_held(&cttype->mod_lock);
> > +
> > +     return cttype->count;
> > +}
> > +
> >   struct codetag_iterator codetag_get_ct_iter(struct codetag_type *ctty=
pe)
> >   {
> >       struct codetag_iterator iter =3D {
> > @@ -204,6 +220,7 @@ static int codetag_module_init(struct codetag_type =
*cttype, struct module *mod)
> >
> >       down_write(&cttype->mod_lock);
> >       cmod->mod_seq =3D ++cttype->next_mod_seq;
> > +     ++cttype->content_id;
>
> I have a comment on the content_id bump placement.
>
> ++cttype->content_id is placed before idr_alloc and the module_load
>
> callback. If idr_alloc fails or module_load returns an error
>
> (While the chance of this occurring is very low.), the idr entry gets
>
> rolled back but content_id has already been bumped. The actual
>
> content didn't change in this case, so userspace would see a
>
> different content_id and assume the data is inconsistent when it
>
> isn't.
>
>
> Thanks
>
> Best Regards
>
> Hao

While I agree with your comment, I decided to place the counter
increment there because the chance of failure is low. Furthermore,
even if it falsely invalidates user data, the user will simply query
the content again. This placement also aligns with where the
previously used field (cttype->next_mod_seq) was incremented. Let me
know if you still think I should move it. Thanks!

>
> >       mod_id =3D idr_alloc(&cttype->mod_idr, cmod, 0, 0, GFP_KERNEL);
> >       if (mod_id >=3D 0) {
> >               if (cttype->desc.module_load) {
> > @@ -368,6 +385,7 @@ void codetag_unload_module(struct module *mod)
> >                       cttype->count -=3D range_size(cttype, &cmod->rang=
e);
> >                       idr_remove(&cttype->mod_idr, mod_id);
> >                       kfree(cmod);
> > +                     ++cttype->content_id;
> >               }
> >               up_write(&cttype->mod_lock);
> >               if (found && cttype->desc.free_section_mem)

