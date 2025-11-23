Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFD95CFD313
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 22:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E99146B000D; Sun, 23 Nov 2025 17:48:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4A006B000E; Sun, 23 Nov 2025 17:48:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D11C86B0010; Sun, 23 Nov 2025 17:48:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BB2236B000D
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 17:48:46 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5B46F1601C1
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 22:48:46 +0000 (UTC)
X-FDA: 84143363052.05.2356F68
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8046C4000E
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 22:48:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QjWskTHF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763938124; a=rsa-sha256;
	cv=none;
	b=cJ1092+oVbldJL5+2hmN424/cCch1dYoaG/De4W5Zvrum8woG112CdLQRbbyagyqpm7V0s
	OzNS7INKO3mTzHtku9BWTyFui4fO80OuUrmvmMErnMd3a74+pHRFoUDcq7mAiphIuwghzF
	NaEuHoMJ8wkCHIXmb0iSDfelzNE9jsY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QjWskTHF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763938124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iakfGjKrLhSGBnq6bwoC8Cy8YZZaXiVsEtQd64QVw/s=;
	b=e5dw/QI5FupRt4T72tB25OzuS8qWenpg532q0yK0KK1HwTcr30te/hpDPwKCNX4WRH/hJ/
	vWDnGtUcJJdZDkss21lpoe0/vrmpNAb0lR0qy1YYc9gpMNUNSLbl9x0W+xV4hN+V441Zjr
	sY2OaDOR8PmMewOIfjWi2SteWHY+rec=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-880570bdef8so45101896d6.3
        for <linux-mm@kvack.org>; Sun, 23 Nov 2025 14:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763938123; x=1764542923; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iakfGjKrLhSGBnq6bwoC8Cy8YZZaXiVsEtQd64QVw/s=;
        b=QjWskTHFs+gH6Siy+yxp7GX+GQBSFAz3BiI+zaHXWfCcsddtEpEi53E/GNLxi8qlFc
         /UCAFU+fr+hLTvwURWJU3qUWpg7nuJPrsFWRcqxDywWWr7CWG0zQysOL/pjNNjoFplJM
         9h5chwRx8+z1Rd0dOwk58X+R+NNVdibC1WrUq8oGmTRT3NRPN9YXEe0r7FJlJYnaHqMb
         uheuvGA1Y6cEd75ukdOK+m07Vt9PxQDigF6uQRD76qpQDOyzqvCWx7+lHlBEKyyE0fx7
         qdHaNH9knVJ8sDBke1aed0TCmSDIyv5eR5iw2cKuwCe1X1SWOfnk5pDkWzohqh07sGBD
         UJTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763938123; x=1764542923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iakfGjKrLhSGBnq6bwoC8Cy8YZZaXiVsEtQd64QVw/s=;
        b=mBOw0AyPo6k/hdu4g+ODSPElnnS0bDRLc8L8KIRbwdgtTfWeh1FKP94Z2lvgArD1vh
         A2+WKE502d3RSV8g2gmk3ya/vXzCvSudDM1F5YRYBBBvnf7/8Jl+f9tPjRq2ny336zw6
         qDB/lrLLN56SA0VYMAbICxqJJrVtUE2IYoLs7BK7kR0m52Fo8BpHWqkxR4PMjLg8229y
         xlcjI4D/m+y5798jDqu7N3IuyWOk8rFHPAQ9nAW1uiX+MkVKG/PnXeJ1F4wQpqevg0AD
         NOi263kA11vkwdJlmvuheL4P8qiv718GP0iD8DTLVM3y4GYqLW5fUzi7U31SXZLXFYds
         /lqQ==
X-Forwarded-Encrypted: i=1; AJvYcCXf9ZJKfQQS1wACUP0TFzb+wLJpp7R5e3o5xXED3mtFyQMURVwQyLHc4t4S7PBo8UoZAbzJ84dF4g==@kvack.org
X-Gm-Message-State: AOJu0YxMI6bpGyY8pinsM4VTLgEBT3vyt1eueuPZ8/4Fhk0rNy6rTEY9
	cPPzwLea50petRh3iaxglFaQccai9KySa2mABtoPzvaqSACrUuvkk99JvxwrQwk1XqQHK7om7Oa
	MjzkWayvykKsLwwNqYfbyz91wK6FspGY=
X-Gm-Gg: ASbGncs/q+H4W5baaxE+8E770fmGL3yi0tW0WL+KK0cx5dpc2IZgi/gvaJ1e+liQOxz
	qcyOOM1UlH0MUSD2p3+HIkQceh5q2sVGw9n8OCjmtbczzNhoDfVjITLi4XUfWK+yzi5va0vEWW5
	A1TpcY2oR1lLSWEtqOva5t2SsjwZlaPZQb0mShE0KVHf62WlSsewycCuRnNlL10iCpzca7dU7r+
	soGBMnnflI5NYYKjBxAPWjTnjcvnbX4jQbv1Lz8u60foLHxA49qV5cd4g2xBUX9EH/RC8Hm4F0/
	iciRiZwaFZhwKdxrDsugk9DTaw==
X-Google-Smtp-Source: AGHT+IG4SRrwvt8VK7iXsJAgu1aIKTIq0WxAy9Or+biSYd7mV5rCtZNpEK8EbUUw3a+HdLIIeETpK8Y1012q5UOuCsI=
X-Received: by 2002:ac8:590e:0:b0:4e8:b980:4792 with SMTP id
 d75a77b69052e-4ee58848723mr148553711cf.37.1763938123429; Sun, 23 Nov 2025
 14:48:43 -0800 (PST)
MIME-Version: 1.0
References: <20251123063054.3502938-1-mjguzik@gmail.com> <20251123063054.3502938-4-mjguzik@gmail.com>
 <aSNp-TDtv0ZoILJ3@redhat.com>
In-Reply-To: <aSNp-TDtv0ZoILJ3@redhat.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Sun, 23 Nov 2025 23:48:30 +0100
X-Gm-Features: AWmQ_bkH8Ww7plO69UayHU5R4y4y2lcFsgH7Rn2svcdPNF_zT4Z2sZ5AqBvlePE
Message-ID: <CAGudoHEuG5FOv4XUwKexEGzcC5QayHsJfH=b+U1LRAeHfBoOcA@mail.gmail.com>
Subject: Re: [PATCH 3/3] pid: only take pidmap_lock once on alloc
To: Oleg Nesterov <oleg@redhat.com>
Cc: brauner@kernel.org, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8046C4000E
X-Stat-Signature: uhigj6ytfogzka95foiu9nc4fakfhep9
X-HE-Tag: 1763938124-893120
X-HE-Meta: U2FsdGVkX18o4U14qR0buHy/DRYBNmtoKC159LdYG3vb6fgbFis5OnyrZ054p0zw7iJxBd5tvfZCi6f6NTHH62iUn+cbYuIVyunWg2xnVN9HmDHYx1TPLsF0gcRCoeq9PvfjTSOqEHdUyy9TIrPwLpINNxu5GlAtAtD2h/la/f9tIYCMcNrwRjXTXRBiegF+j5DSoZQaw19/m4WNT6kK1dcI4jk0YpGUQtiVWDYogc0tGcB25ouhMXeNDaApX39sLELc0XPtVBwzTzhQPr2FcuGb+r8gNRoDUuCsov4C8RmnMQlA8uq0EHh8kf73R3gD9dAoDjSukydPrQRpRhaahTyzrxnSx4ErabzddEepIXQy7NopunIEIHijDrRisiIPoFNDxXxR1Mv1e84v6SFxltlUDR7K9q9wDwGmYpnvMI6Kpc1hGmYHraMpgqm1kysRpVV09KAquyTuZKai6dulvLPH1LAc8A6MB5EY1ksLTYvlsn3c76HF84ko9sGNi7o1XYFkt+Bi0KAWJc15MJcR6jl6jRDZSVAjghBSPkNRqua+5rPGcRVywc4oy1eK3bMBzuiXrQoINatoMGUBrd9a9unP++tZarV5UFW8Wxuj+y3iWmBWDPprjJeb8oEEywG47aW6NvVF5i70ARu5Q51uEVjdq+K9KL+FZfIg5M8UYw7vgizT74D28z5PdpFJrDzJkakCkH3K9/ywgZy4M7n4PRJ+m+B+S+7SEI97rZ4bJkpBBoLGnbuQhHLddGbkeo25fUKNnmacC6SHLngxGSjrTkLGm4/yXAs0iIviQezxuriSKGI0ylx6WV2JsDz1huK6wvSK7GmAWMM2pLAkNUG4JQ2E5W0RCzs97k5rh1iQ/kJjeXfJxOxbp8gAV/5/HCwgRNQ91f7WBVBUcH6W7+e6aIsV0WHi32PQfIOUdhlMPomkXRGUMiJqA/BmGI1HPqh0Nf4fBRguumgCtCIfW2W
 x8R5swuK
 hok616NkaPy4HMkYHINmaCKpaQ8Vbih+t0UrRahlH5QzgGOtwfejqMKC4FLkbWrpK+km2H/8v4ct0ba6KtuvNAgkgCbMndWOcxhLmeMQY09e5DQ2J5Sw2zByoa66+xYtSV4PqXCcJqOC3nlpkspBgVRjGuxX/l4OJK36AdWuhlEKKH67HzZnTsvazU8XEjDWfof7ft1yu5x2+hubRzphJJJENZOPv6y26BImW/AzZN1HlbpHFooLXHmaSqBPqBMSJ7cf/CwP7AkhgniLnNOiivrXO6zwZTaIrp3GMofpHqrj3Qr5cIhFokXVdek0/EJA6UwcpvExrVEGK8GjMIjPTkfyQVU1x1YAfmR+MB7q2fNT7g/jcTrZkm28ovylDYkfKaaVJIx6H+r4PXAHL9AnzpZQHqmANvBuE5X74qdmrkfSQY/I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 23, 2025 at 9:10=E2=80=AFPM Oleg Nesterov <oleg@redhat.com> wro=
te:
>
> On 11/23, Mateusz Guzik wrote:
> >
> > This reduces contention on the lock during parallel clone/exit.
> >
> > It remains the primary bottleneck in such a case.
> >
> > While here tidy up the code.
>
> Not sure I can review... But FWIW this patch looks good to me after the
> very quick glance. I'll try to actually read it tomorrow.
>
> But please find a couple of minor "can't resist" nits below.
>
> > +     for (tmp =3D ns, i =3D ns->level; i >=3D 0; i--) {
> > +             int tid =3D set_tid[ns->level - i];
> >
> >               if (tid) {
> >                       nr =3D idr_alloc(&tmp->idr, NULL, tid,
> > @@ -235,10 +261,8 @@ struct pid *alloc_pid(struct pid_namespace *ns, pi=
d_t *set_tid,
> >                        * a partially initialized PID (see below).
> >                        */
> >                       nr =3D idr_alloc_cyclic(&tmp->idr, NULL, pid_min,
> > -                                           pid_max, GFP_ATOMIC);
> > +                                           pid_max[ns->level - i], GFP=
_ATOMIC);
> >               }
> > -             spin_unlock(&pidmap_lock);
> > -             idr_preload_end();
> >
> >               if (nr < 0) {
> >                       retval =3D (nr =3D=3D -ENOSPC) ? -EAGAIN : nr;
>
> So. With or without this patch we have
>
>         if (tid) {
>                 nr =3D idr_alloc(...);
>
>                 if (nr =3D=3D -ENOSPC)
>                         nr =3D -EEXIST;
>         } else {
>                 nr =3D idr_alloc_cyclic(...);
>         }
>
>         if (nr < 0) {
>                 retval =3D (nr =3D=3D -ENOSPC) ? -EAGAIN : nr;
>                 goto out_free;
>         }
>
> and somehow this looks annoying to me... Perhaps it makes sense to make t=
his
> code more symmetric (and imo more readable) ?
>

I agree, but I also tried to not make non-perf changes to make it
easier to review.

There is tons of clean up which can be done here, maybe I'll add some later=
.

>         if (tid) {
>                 nr =3D idr_alloc(...);
>
>                 if (nr =3D=3D -ENOSPC)
>                         nr =3D -EEXIST;
>         } else {
>                 nr =3D idr_alloc_cyclic(...);
>
>                 if (nr =3D=3D -ENOSPC)
>                         nr =3D -EAGAIN;
>         }
>
>         if (nr < 0)
>                 retval =3D nr;
>                 goto out_free;
>         }
>
> > -     idr_preload(GFP_KERNEL);
> > -     spin_lock(&pidmap_lock);
> > -     if (!(ns->pid_allocated & PIDNS_ADDING))
> > -             goto out_unlock;
> > +     if (unlikely(!(ns->pid_allocated & PIDNS_ADDING)))
> > +             goto out_free;
> >       pidfs_add_pid(pid);
> > -     for ( ; upid >=3D pid->numbers; --upid) {
> > +     for (upid =3D pid->numbers + ns->level; upid >=3D pid->numbers; -=
-upid) {
> >               /* Make the PID visible to find_pid_ns. */
> >               idr_replace(&upid->ns->idr, pid, upid->nr);
> >               upid->ns->pid_allocated++;
>
> So.. unless I am totally confused the current code has another
> idr_preload + idr_preload_end around pidfs_add_pid().
>
> AFAICS, this makes no sense, and your patch removes it. But perhaps this
> deserves a note in the changelog or even a separate patch?
>

Oh heh, that was not intentional. After I was done massaging this I
just mindlessly removed the lock acquire + preload.

It does indeed look like it serves no purpose, I'm going to submit a
separate patch to remove it.

>
> And another stupid question... I don't understand fs/pidfs.c, but it look=
s
> a bit strange to me that pidfs_add_pid() is called before the
>
>         for (...)
>                 idr_replace(...);
>
> loop. I don't see any problem, but to me it would look a bit better to do
> pidfs_add_pid(pid) when this pid is fully initialized...
>

That's a question to Christian.

