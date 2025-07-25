Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ABACC87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 18:41:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85E7F6B0089; Fri, 25 Jul 2025 14:41:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EE006B008A; Fri, 25 Jul 2025 14:41:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 661166B008C; Fri, 25 Jul 2025 14:41:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 57D2C6B0089
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:41:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 26E68140645
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:41:31 +0000 (UTC)
X-FDA: 83703655182.24.5842087
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	by imf05.hostedemail.com (Postfix) with ESMTP id 52A66100002
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:41:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=FYMjuWeB;
	spf=pass (imf05.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.210.48 as permitted sender) smtp.mailfrom=jeffxu@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753468889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V2Rpb7FR3nTf+1NUVClXeCPQAamkonhV1DyVh3/yazQ=;
	b=uQn8FuGttaupLVlhY+7hfUVHFqKjjR/7qBz1AxAyMJs1sNk5XamQNUFRAkdG9SxVnMFIXv
	DUYcRydJzpExSpjpnk0WGG/9gnl8ScAiG/zTPx4KS3HQg+LvMo6W7D9Nw+2uknGuOT8HeM
	LsJybu5az4hJ8idoiSRX6gvzymyhWQM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753468889; a=rsa-sha256;
	cv=none;
	b=NJe4c/JfIuL2HwnINUL3LeohQpc5p+15PSmRzVE90pZlWea9cNINg7PUmM2Ou9IOXpig+C
	QX606nJGboeRjPnfwPjnALKMb0HCeMwuguZIvplFD1jf4QVBSwRVzr3UkyDb9TzTpHhwIY
	dtU2KKSx2GFMGlcGHAVMq+WGMTM1/Hk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=FYMjuWeB;
	spf=pass (imf05.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.210.48 as permitted sender) smtp.mailfrom=jeffxu@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-73e65e9a687so149436a34.3
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1753468888; x=1754073688; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V2Rpb7FR3nTf+1NUVClXeCPQAamkonhV1DyVh3/yazQ=;
        b=FYMjuWeBqv86P04lw/RWdBl3UQyAp7pZ/1G61mGD9+XPRav6GADjAfIkdcmYBMZl/9
         sv/YP7mPQ6UxsizERaYh/6ywH/knkzeJLvX6mAgCyFJTJhAe1Dbcb6VcVwwxpcqKO8dN
         56C9lc/mKNIq1qFnSyIceImYn/u0+GJk+HL0E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753468888; x=1754073688;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V2Rpb7FR3nTf+1NUVClXeCPQAamkonhV1DyVh3/yazQ=;
        b=RTJnH65pvhpl3mDcAwF5Egx4IH7EjVrk6XP213XsLqnTLpH3ffloI1XbHisT446QDN
         WsRL7Wls9jzuF6sE+JlIrlP/5ke6/2If5iOnbNf9gXljFyFNvypd1mPt4MMSwRujmozM
         drLbvJkvAVQ++x5Fa72YB79xxkENUJAYV8g5mydheu1DM1bPfkmZOGuE1PyPHMoz2KQB
         CjqgiKNKEiB3/C3WOk4kyVqYCOLlRioMaFC1XHzlnT1z9LFZUYPitmMEz+01cJIHFinN
         wfOp+oE7GSqg3vyRSbvJWPgpOuh0gHMtfWffKpjxHOE+RWvs9gFeepXJaBeUqnZmW92S
         2Oyg==
X-Forwarded-Encrypted: i=1; AJvYcCWmtFCNMydWtCHGr5gk/8APSDNOu715m4CKkKxfce+EzwclI5RcqBtoLAFQsKaw4aOoktH7HknoxQ==@kvack.org
X-Gm-Message-State: AOJu0Yy8HoMEIOm9tBVGyISa9MahSvUJ9/43C1XhlXZOfDZ986YXsSAr
	PHLHMWeZ6RXjz8GGY+0pjxe+7KCa2d0Pgma42Dvht8AEu39ZEtbwQVfMI5OgAgXJrZDF3owmLS/
	qcOiSlWlxksgandB2kIaXeP3gu3C7WlurF2L1LmZv
X-Gm-Gg: ASbGncs/jUISzDmHCqeRDZZdq99LXsVLVXnRH7TCLGEn7a3Zu8JTtrWimpE9T98lTK5
	78bKAP112AVJjh9/f9YS0C89eMsibSgHraoUOZHYRZaaAfxt6Yx/ZG53NqRfrpv3h1GidaJoFpu
	EoPwCBkBdMeQENUNYFZkcog529IYOQaMfk7+lgWS/sPAQlo9sz2tUeWqNdZLn5HSXCwOuui9I11
	PyV7GkahEgWEl6o6prbHtIfUinZBObuvlUgRQ==
X-Google-Smtp-Source: AGHT+IEFU8NJPmbYkF/oI9KZMdUcX0Ny+72Vd74Lmwe1/0YjVojIvVz6a6+Qnd8NCCAE48yauMCrRlYLd1qXP5jE+Xw=
X-Received: by 2002:a05:6871:286:b0:2c1:5011:56e2 with SMTP id
 586e51a60fabf-3070189dd2bmr789116fac.3.1753468888290; Fri, 25 Jul 2025
 11:41:28 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1753431105.git.lorenzo.stoakes@oracle.com>
 <492a98d9189646e92c8f23f4cce41ed323fe01df.1753431105.git.lorenzo.stoakes@oracle.com>
 <CABi2SkVSjRV_zz0mhuRF3t3UJM_x=+gct1jbV=qd7eNMPBbvkQ@mail.gmail.com> <a1691645-18ce-4e7f-846a-a5b498df948d@lucifer.local>
In-Reply-To: <a1691645-18ce-4e7f-846a-a5b498df948d@lucifer.local>
From: Jeff Xu <jeffxu@chromium.org>
Date: Fri, 25 Jul 2025 11:41:15 -0700
X-Gm-Features: Ac12FXzzRYItdebvqb0dwqotR9zarn6x23i_7sZkKKOiMnKZOphccisVFs5oxdI
Message-ID: <CABi2SkVuS21VgXXB80bs20=fg6+Bqm_LfQjknZhqRMGYYv7-BA@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] mm/mseal: update madvise() logic
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 52A66100002
X-Stat-Signature: qb97sckq7m44jiupijodng7xtrmpbh6d
X-Rspam-User: 
X-HE-Tag: 1753468889-629805
X-HE-Meta: U2FsdGVkX184M2Mk8fXCeaxDXvDByWMgHIvgCSsm+tw+UbuyGM1cFmnmZGpD7sCoUS/6BbPe6+A0ZWHeq7HoKa7rTvgrOiD7EAhI4tQMYe1GcgoDlcl25CvBWjItuzDTv9KtwawX8hgpuq+bNMzNEPjgdLD5oavs6+vnS14xo4xJGk4c7lZIK5VXJQNmJ3h9upCmQVS1Wc/dqw46pNfMRM32i3YA2zHx9eiqt3akEzt/wWqUnZRxfFvUK9dl1Nl8FMnj7ad+XxiLy/wRevYGNSqyN5ymNGypR3RASEFSOniTrQgYqreRiphzcnLv4k5mqgQ7UxgXFLm+FJsZiu+O4ot5CjUazjuwbZbaN62FBBXfRUlscZJlcDwpxopxUHX4rIiVPdc11UsaBNP35qq2q0YYfuJJ/BI3EPdR9hjupc6sNjTaBuKT4o/FzA6mg06B8fHchT+ehM6t0fGgYQMU/INvyy72PEfXHQNyqUFmMI6xuPYlJKCG1ctvjHz7ifcfeGVXqm8ymayBYgLkPueSA8fWxBGshRmNo4/VGoAIGwtbhiV6RSYQ7dj7JYeL15P8R7twr/QxtpQeMs9OZ6dubhDf9ikiJG7+a++UsewXcQWiE8vX3nYvHkQFh8YPnxMHOS4sJzAGyE9Nc4sAPu5zOPGnjFgNzELC+ySkvA9BUNXfIUsGJ8gOqIV4LBmdV0XDPornKyNExX1Msie4AApiVqVRboSVwDRd5o7GjjXJpT3A9GHrH3jO3zgBf7LNX4cyvqt5MjJ4JmWzs7ZSRjhsgAsQBC+95PMY0Bmvm/Kt+0QbBXHYE1tmjFIqBJSVQtjB1dROkwhwMbYtI89FJyS6EW6LqGKDZ8h2ZlhYZOj/dR128wxWAJnWP4h4kyAoWBLUUIK2SfHfW1T7GaT21A6X5ElVyVHj+XY3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,


On Fri, Jul 25, 2025 at 10:54=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Fri, Jul 25, 2025 at 10:28:57AM -0700, Jeff Xu wrote:
>
> > > -static bool is_ro_anon(struct vm_area_struct *vma)
> > > -{
> > > -       /* check anonymous mapping. */
> > > -       if (vma->vm_file || vma->vm_flags & VM_SHARED)
> > > -               return false;
> >
> > In this patch, the check for anonymous mapping are replaced with:
> >
> >  if (!vma_is_anonymous(vma))
> >       return true;
> >
> > vma_is_anonymous()  is implemented as following:
> > static inline bool vma_is_anonymous(struct vm_area_struct *vma)
> > {
> >    return !vma->vm_ops;
> > }
> >
> > I'm curious to know if those two checks have the exact same scope.
> >
> > The original intention is only file-backed mapping can allow
> > destructive madvise while sealed. I want to make sure that we don't
> > accidentally increase the scope.
> >
> > Thanks and regards,
> > -Jeff
>
> Thanks, that's a good question.
>
> So for a function to be mmap()'d and file-backed, vm_ops _must_ be
> supplied.
>
This says that all file-backed mappings must have vm_ops set, but what
about the reverse? Are mappings with vm_ops always file-backed?

> You can see this in the fault-handler:
>
> do_pte_mising()
> -> do_fault()
> if anon -> fault anon otherwise fault file-backed
>
> So if this were not the case, you'd have file-backed mappings going into
> the the anonymous fault handler logic.
>
> This covers off MAP_PRIVATE mappings of file-backed mappings too, as this
> is handled in do_fault() by:
>
>         } else if (!(vmf->flags & FAULT_FLAG_WRITE))
>                 ret =3D do_read_fault(vmf);
>         else if (!(vma->vm_flags & VM_SHARED))
>                 ret =3D do_cow_fault(vmf);
>
> That does the CoW fault handling.
>
> So the vma_is_anonymous_check() here should have the same semantics.
>
Just to be extra careful, does the reverse hold true as well?

In anycase, if you are confident about this, please do state this
change in the commit description that vma->vm_file and VM_SHARED flag
check is replaced by vma_is_anonymous_check(), which is expected to be
a non-functional change.

Thanks and regards,
-Jeff

> Cheers, Lorenzo

