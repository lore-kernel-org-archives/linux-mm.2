Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13F42CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 19:53:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 575386B00B1; Wed,  3 Jun 2026 15:53:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5264E6B00B3; Wed,  3 Jun 2026 15:53:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 415636B00B5; Wed,  3 Jun 2026 15:53:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2BAD06B00B1
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:53:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D474740547
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:53:36 +0000 (UTC)
X-FDA: 84839651232.28.E5AB013
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf14.hostedemail.com (Postfix) with ESMTP id D377E10000C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:53:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=t7kj6XRq;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780516414;
	b=7zR1StNwThLOmbRKBjJrz5zagfqDothnQ9YWcBRPd/5KkpC865oGDCf7VgyigQ7HOICpk6
	bgzZ6enaB1RjQGZvUBMbC7ZgElh/Mh7H8kZsChscGy5xl/1s2vAC/IFc7QbTdL/FZtjxyg
	qWQeSWUKyVIT8v19srwFjaKxCsWdHzQ=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=t7kj6XRq;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780516414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TXQvxZ2LmE81OCzVVkvyEWBN/pTRupWk2i/hhQaPOgg=;
	b=7rEsBsQQob1B+4Yo/9ud0Xr/z3AEeGRe5iaGxLUSMM5bV8p20PTz+RTAEjcuk9RQGauYsE
	Pd1Be6swDVMZGfgcKDPJ9FNLnDaZBhYBCLcGQBmbcpVbts+CUHtHYF7PwEiQejClz8sdm+
	Kami3Uyg0at+C4R/+DMIjAJ9pMpEVJs=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5177d1ff061so5951cf.1
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 12:53:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780516414; cv=none;
        d=google.com; s=arc-20240605;
        b=MOu8aAODLGOhIkqap2j+HJ+ZO9RfPrBz1BU+uvI4mlYE8AF5O/o8xmoLw4/AKkj8xD
         SUGh6bKCfm+B/V3x0Psd+Q4djYCrGi/rkJV2G30dlsiLdeBAX0CuFIdOdsELGYp+7GJq
         c7cQTqNSLD5Veu74FgveK8kol3uUGgkP8lCIy5FOVnr7xsTk/6ENdcODDsWL98J+phIr
         lGjdcrxRzcr64iroiJxZgZBi5utvKP/U2UATf4Sb7lxCqqx1eja4XyAInsPP1ZgCeoeN
         Jtne38qsJ7zb+J0QNDCd1BAckaMKV0KKK5CeLoT7Or/uwMESM4t/4cvHwMzn6TulbfTf
         JAqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TXQvxZ2LmE81OCzVVkvyEWBN/pTRupWk2i/hhQaPOgg=;
        fh=cM71QGyaGitstl/ImhgRVfHckXz1+RHBXL3NdRGrExY=;
        b=GDRBk1tUNmzFsJY9uwMziyYrLDlSyCiDEGs7W3xwZUVWeHkjHcR/mrPoOBiFn9D7jQ
         NTUX1fHi9J8H34x+VCWX9Ec4iLQ3hzjZslV9Rmsu0p27In/i3fCXKZ/naxaK61KVNAXp
         nUkJC9iG4eqpzw9ijistZ26BcDqwOFypVPFAXSyLASyCtX7SOKJzT4o6FNNFo/bcEBBK
         2H3qNpG+KFOvSxvZ3luY60Lsp+am3xK0cATwMGklb7+jMA6leMTiyoxvh4gla4mHwYBo
         W8/DL+nldYCZ5zSSxe2cthspEjbxpPXfjewHO6yaWr1SFtv+A60hptl+VX3p0O7Ja3yp
         ct2w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780516414; x=1781121214; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TXQvxZ2LmE81OCzVVkvyEWBN/pTRupWk2i/hhQaPOgg=;
        b=t7kj6XRqBLXbBVbFiXcPTbJXDswhr82sSXL/CQ8hE7eBJGi6gRLXBso9jGvzL10jwv
         Yqb9fKthL4mPzhm73+C4z9ytMZ7xzg4udxWiI5JSC0oCtORXv3fi1xeGdxAW13/fwnZZ
         b06DEZgtVtZMySj354tlSZDtKaDbmRDZWQEPVmlO5PM/mkh/fDyiId6V9Df9Z0zr+zd0
         ID2cX01SMt9+00HQNvfcFbmKhVRbzXfgJCwElkrYQavLCt+S5Dxl0/y+AQn6uZJpurRx
         iQaaWLeKteOqzznX78sxEQWhV9X0AQtZ6Ssj2nfaRgXTutkCumMj4X+zNzptM8OQD4tb
         ET4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780516414; x=1781121214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TXQvxZ2LmE81OCzVVkvyEWBN/pTRupWk2i/hhQaPOgg=;
        b=Nn5A6JIYGqjRbRAh1Hpw/S0TcNrBqdOF8EqJ7bOKhA2vYVMdxGe99Q8NXWzxbqrYlN
         eCu6kREWHsZUDHUvK9wJsvnxIO0R3KL5wo7tKFkrZx/XOrZAT2Q7eNptp53TxttU4XCP
         jq/Jfw4n5LLr9PA39fVrroliv2CERzunT1D2eP7+DfQowHTN0r6M9reyi3ZDqDksb2FV
         Bb7go0M/X0z/91m1rz6gZMBiVElLh+zPqYRpxoauo3ckGOZfMMfJzwUQtCk79fp7jA0+
         qD/nOPyfJzrUvkDjOb6HoWe7n94LPXjAP6IsQqw2pd8iqiqMQyCyXAQ0SBPATW+BlE3O
         dRmw==
X-Forwarded-Encrypted: i=1; AFNElJ9VsvQ01JHvXCU1GkIAl3xFDpmWeajgGCEZgGAGBYHpdfu864Wv1f6i8m4xEdEe6B7z4vyUHH70aA==@kvack.org
X-Gm-Message-State: AOJu0Yxdwh7bwGv+PySSQrtQOjPFYvzqS+V+SFy3Ez6W4VrVRYVgY3AB
	z1dcIf+hTQ/NX27HaT6gyqXJOErAgVj68Dg7RoVVioNUUrLneAgmXEVBAFsdKVqa78yMv/8yM//
	1jJfZQVVgZvk8ditgE8GSZwfnL8eDo0XJGILZ1W6n
X-Gm-Gg: Acq92OHaFQMKhp2oFwxGqIjMNvpgtisbQ0sAKt3qjXPtg8elMo50iw7xA68OmE/zcNQ
	RnHezDyyx8QEY5596O6q59bUOk0WLjhS5HkDwrxWL/3spLPUNoptQhPC8t9hdkvKSs2DxIo8wCO
	RRb5VzfstyvJNbRtSN7dqtTFHvEPwMNZanNF4gt87RTcI84hiAd0T8WI3EhynF0KW9o3ENzPv3s
	YlnR5RVerlvPHUpmeInZE/IUwS18rUvAB/LzUkfWNJjsC9jKOmQzvAkp1gBw1coSopXBz6iyybH
	9JZ3L5Y3QTwIIH5xXjIpWD0c1svgMgcySmOksZtNuAoH2qPt
X-Received: by 2002:ac8:5d8b:0:b0:516:4f62:85e8 with SMTP id
 d75a77b69052e-5178796f263mr587881cf.19.1780516413225; Wed, 03 Jun 2026
 12:53:33 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1779471082.git.abhishekbapat@google.com>
 <8ffa0cef49b10026f2171d41b963c39201c9bd5b.1779471082.git.abhishekbapat@google.com>
 <20260522131148.059d7589666e4a35af1430e5@linux-foundation.org>
In-Reply-To: <20260522131148.059d7589666e4a35af1430e5@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 3 Jun 2026 12:53:22 -0700
X-Gm-Features: AVHnY4J8cx2VK2pXgcXhgnS0vt6Z_FGY7b56TffQZAGDeePrvGdeOKpmxgXbiOw
Message-ID: <CAJuCfpFqEQA4EMgdF=vbbctcz8BQxVMVxojaRz25k-Mfm5mXKw@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] alloc_tag: add ioctl to /proc/allocinfo
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Abhishek Bapat <abhishekbapat@google.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Hao Ge <hao.ge@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D377E10000C
X-Stat-Signature: 67e86syai6t96swbtpnqbshm13568x9j
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780516414-630111
X-HE-Meta: U2FsdGVkX19kVH8Zh7WVcXP2jSd7c4Lbu/m7qnD61/gPPW64XhlGpB4LXU1JQU0QhAnaRN/bK99Sp/1r8CdHX8Ylc5yMy4/oZaDd0Emzcff3YjSD07RGvhvPw8qkfDTTkSor6l/6R+pRPKpMixzisae0T9/BdBsRVFI3fB2/JaRCnStKi/o9oC2hhAl0c8L8UU07lL8AKY03ck2o/EAMZ2KZaJuiE++g8DOmOajKXsT6GlM4KQSL5t0DHADWqejVTjMbLGP5SaJcmyIv4buXP1G8o4u8b7WeYvqv42oePz+fJyXJlVmrYESfOSfYhcYS4n15TfMMFILqmMlodn57WnkhnSwQ8xfcBMRFtxBxAV0X16MpGEw0XVzAQRKkF6VG2rLHUjsyXxFdihz0UcVKemoNo+pglfQhM2+eTBRsoUKm/bWZ2vDChIQnBO0pGkoTUNM0kq6G+MfaKGDgBxJ/uUsgs9neZWd+SLux0hVd1lyc89rsFo/Jfq56p8djwbVsNhObVgJs9emALVCNQamKwp/MzNRX9LOVBGoMvRKCHQzcXRaHx2W+GdOnte+OS4jP5MtmHxhNusdW47IuvTEHfB/bN0u94YrvmGIkxvI0PgEJx/1Xn6an8Df2m/JYHXzmDD24TGZBP8RpdNDYG2hHGHNo7w5Pq78Gz5nkXSc0+xWdIDu7OrYdCFaAeElLJ2NQ7bIK457+SSL4Ji2lOA8XFKnXoakX6IIcXM8REGF8jCeX2tNEukEwphElENL8eI1DUnKVI0bsVsvqv4kaEV74Tr7i3hqKRR555ydbVMR7zXapKbbqjUfk6lVq3MfRs6IJRwn6bCB+ztG0Uzn4faak4Qjwt76qt3/Q4qBOA/Bu8wmx0oXenLNAvEYHXMAIExZpBGUJKlwl6BUDW/GvaZIKoFo65GabLOElcL61NCP4YATpQs2UVRCnjk08rkci28BsaU7lGewZf4ohiI5vJRs
 OczSS2Sb
 MGxzgRGacU/GI6Q/WVdGis79crqIJc4+rcbAn6XusqI5sudRmO3pNn/YwGA61i4pvsqIGx+DYBSpvxrL7FDJtmtC47AxwLCgFPiMKr0V6Vt2MEF2lTHx2J75Xr4EbM5DvQ8Zp4rl+lQ5LRY+NgE1FRjg0oF0BOq8+dXHElApCwxOH/FVAs094ObBVBqJNaL/vCfRwKEhXIjfmjR22CXzppgwmp9rlUpOSy1Pg6uoqROFaQ71OVQWPNO5P+S8fhvQXHdi5rKbdAODeXTonglgC7fNaXfhkK8Xmhf/jv4ptj/SR8IxHmdt94eqmx3/yTdRpArpLKzf0vV7u5u6X8/6NXPFsfL9vyM0GUr9WRfQJkXqB8zk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 1:11=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Fri, 22 May 2026 17:45:33 +0000 Abhishek Bapat <abhishekbapat@google.c=
om> wrote:
>
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
>
> This seems rather fragile, and makes assumptions about compiler layout?
>
> Can't we use __attribute__((aligned)) in some fashion?

Ack. I think we can.

>
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
> > index b9ca95d1f506..3598735b6c93 100644
> > --- a/lib/alloc_tag.c
> > +++ b/lib/alloc_tag.c
> > @@ -5,6 +5,7 @@
> >  #include <linux/gfp.h>
> >  #include <linux/kallsyms.h>
> >  #include <linux/module.h>
> > +#include <linux/mutex.h>
> >  #include <linux/page_ext.h>
> >  #include <linux/pgalloc_tag.h>
> >  #include <linux/proc_fs.h>
> > @@ -14,6 +15,7 @@
> >  #include <linux/string_choices.h>
> >  #include <linux/vmalloc.h>
> >  #include <linux/kmemleak.h>
> > +#include <uapi/linux/alloc_tag.h>
> >
> >  #define ALLOCINFO_FILE_NAME          "allocinfo"
> >  #define MODULE_ALLOC_TAG_VMAP_SIZE   (100000UL * sizeof(struct alloc_t=
ag))
> > @@ -46,6 +48,10 @@ int alloc_tag_ref_offs;
> >  struct allocinfo_private {
> >       struct codetag_iterator iter;
> >       bool print_header;
> > +     /* ioctl uses a separate iterator not to interfere with reads */
> > +     struct codetag_iterator ioctl_iter;
> > +     bool positioned; /* seq_open_private() sets to 0 */
> > +     struct mutex ioctl_lock;
> >  };
> >
> >  static void *allocinfo_start(struct seq_file *m, loff_t *pos)
> > @@ -125,6 +131,190 @@ static const struct seq_operations allocinfo_seq_=
op =3D {
> >       .show   =3D allocinfo_show,
> >  };
> >
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
>
> Generally, the commenting in here is very thin.  Add some explanations
> of what the various functions do and, especially, why they do it?

Ack. Will add.

>
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
>
> See, even these two little functions are unnecessarily difficult to
> review when one doesn"t know what they are setting out to do.  One has
> to first reverse engineer their intent from the implementation, then
> check that the implementation implements that intent.

Ack.

>
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
>
> Unneeded cast.

Ack.

>
> > +     pos =3D params.pos;
> > +
> > +     mutex_lock(&priv->ioctl_lock);
> > +     codetag_lock_module_list(alloc_tag_cttype, true);
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
> > +     codetag_lock_module_list(alloc_tag_cttype, false);
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
> > +static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *a=
rg)
> > +{
> > +     struct allocinfo_private *priv;
> > +     struct codetag *ct;
> > +     struct allocinfo_tag_data params =3D {0};
> > +     int ret =3D 0;
> > +
> > +     priv =3D (struct allocinfo_private *)m->private;
>
> Ditto.

Ack.

>
> > +     mutex_lock(&priv->ioctl_lock);
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
> > +     mutex_unlock(&priv->ioctl_lock);
> > +
> > +     if (ret =3D=3D 0) {
> > +             if (copy_to_user(arg, &params, sizeof(params)))
> > +                     return -EFAULT;
> > +     }
> > +     return ret;
> > +}
> >
> > ...
> >

