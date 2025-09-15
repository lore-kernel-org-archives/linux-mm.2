Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4558CA0EE8
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 00:23:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2C998E0003; Sun, 14 Sep 2025 20:23:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDD4E8E0001; Sun, 14 Sep 2025 20:23:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1A9A8E0003; Sun, 14 Sep 2025 20:23:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 991F38E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 20:23:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3798258A8F
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 00:23:52 +0000 (UTC)
X-FDA: 83889586704.09.845611F
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id 663D6A000A
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 00:23:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ST/sKE9f";
	spf=pass (imf25.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757895830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UcJP0Bb8MgL3O1dOQkWmOWNZKcXmOln3+pSRtBF0Y0c=;
	b=Bg08A11fUoMMSWqi70wmGf14L+ihr1hkasv7yxnh7dJLHP71pnwk7s03vo9nrnQpgfFs9t
	YPEwyl4IRi2/1JeTA91JcSbJBlxyA64GdjnsPI6szi7RKKtk4h9Cm0+/5sWANFx4eeKBim
	fSiYqCnDGZcbaH6nSJ9O5nVO0v7r+0c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757895830; a=rsa-sha256;
	cv=none;
	b=jX4gHDvU+mBk1hKZtOU9MmGUCbqlwoCK+J/8FURrFcJMJc0l8C+t5CT5ttaU4NIb7BaoAG
	neXzqp04j//90rNm0Aucn3dFQX+b6Vp+WRkkHaHtUseXzfmpOTL+s9+v1K86pUk//QM16f
	m4OtkND15rCeAc/WoT+u++Fky016emc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ST/sKE9f";
	spf=pass (imf25.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-80e33b9e2d3so334870285a.2
        for <linux-mm@kvack.org>; Sun, 14 Sep 2025 17:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757895829; x=1758500629; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UcJP0Bb8MgL3O1dOQkWmOWNZKcXmOln3+pSRtBF0Y0c=;
        b=ST/sKE9fwBbLMoxlYRzfe+Fxfyeyr7ykB9jvsBhwc+3ffC8XYhfP3f7kzgW+SPFq7Z
         F824zHik333k07Xs/Tq9JLZwBH4QVrkjGeFlpdUSVsUXUAqaqM5ealGMlL5Ei5F7FALI
         /JfwvTjrSoIL0ZMM1nry4qx6g2mO11JdGMonDrRrBnltqso4Mfp8j2PtH9rzTYUYFEZ8
         cCkEH1FE5wMFZR0FyFfmVe5LDukMGTbDxS/6c/GpVc185OhT0WJUc7NZPQDDj+SS6fFO
         d+OEB4f8FWKO9jIMm9P0QgkJdY7AVx2GaCouQAPDbvg0k7vna/lRyU43UkZCmKRJdcVV
         Ludw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757895829; x=1758500629;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UcJP0Bb8MgL3O1dOQkWmOWNZKcXmOln3+pSRtBF0Y0c=;
        b=ZyYLNfkUOEkY+3C9YWeYaMCKfVK1sk+FofZYwpaHpzqrUD3UhVmNapS3pIGKwJste6
         fcjyDsNGeI9c2obca05fzcuYdWyV0t+w4OHR5n0EnEzz2BHq8zkw0sBncpgMLLAya+BQ
         XWckTsn6VQuHNzjG/Sw0pR78Lq/E+9m4kVMo52+7UBGXD9xNY0p7ay6lau9vrD6eb5j9
         w4XbyHeiJqST4Tlwfr0myQrn5q2fbJuvEZl1IgmwGVTtrZJDSsMH26T0Wz9kJe/Y4Xps
         DGlQw85EFtVbNYOP7E9KbSFpa5WSL55PHIlybvV/lFcrSf1MinroV4BdFtm1Wn4Dv/wt
         H5Kw==
X-Forwarded-Encrypted: i=1; AJvYcCVwVLjDDyCmCQc5zZwJGs5ufE2EeG4JUOUa3SejGN33svqFaGGRjQ7DcNqVz+J/QwTWoU0Gy0FJrw==@kvack.org
X-Gm-Message-State: AOJu0YyHVWSMoX7MvfwPZyKSyMTlYud7OSm6o943s1ISZywCB/3NEn1G
	dvO8L/14hdRTcfsvIbSV0r0lDrTfr2pAozLRIUD902bwTTmj2zVUpZdHRiVISSb9K0cF2Rv9kz3
	IJ6rIILvKIZb0Jfkpf0NGypICeeWNdTQ=
X-Gm-Gg: ASbGncuzpINuw1e1n5X1Tp3hk+b8naYRh5MpDcxiGyEEOkWkHBJh/+pHNAT1ABTGgx4
	YXEaPznKYfU2HsWLNgjW/EaDrA2nqruwmP3HTFfReHhScxmSxUUfk0sVwPymmQ+xkX5fe6jvq3R
	yp8oROuXJBfFEtMm00/b2IH0zKnRB5UvNH6ClpxNccrdsTn6BTHBrcZ441jD/qzPJoeDCRzt21A
	QPUo9+B3NUbdcavxg6SUvZ3dLzqlz32vwo1zBgtkSLBy6CmOQ==
X-Google-Smtp-Source: AGHT+IHb3Lv0DVzAyqFGzvGiDL0zwLBpDfi/NWT16B6t9go1IhLtS1hSYFJOl04m1pIlpk5NgQNVA/AEA5bNsfk8nds=
X-Received: by 2002:a05:620a:1a02:b0:813:73d2:7dde with SMTP id
 af79cd13be357-824013d9c1dmr1266349885a.58.1757895829288; Sun, 14 Sep 2025
 17:23:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com>
 <aMdVcH7KCXBvLtFP@casper.infradead.org>
In-Reply-To: <aMdVcH7KCXBvLtFP@casper.infradead.org>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 15 Sep 2025 08:23:38 +0800
X-Gm-Features: Ac12FXzHPCq6RYifkMlZVr53pX3qADYoIVfU1q4sHaiHL4LF64p37214KvqtzBo
Message-ID: <CAGsJ_4xDRB_F-T42WnhqpmwLyiZRwLGqx9vDf_d5TFALsCRX4A@mail.gmail.com>
Subject: Re: [DISCUSSION] anon_vma root lock contention and per anon_vma lock
To: Matthew Wilcox <willy@infradead.org>
Cc: Nicolas Geoffray <ngeoffray@google.com>, Lokesh Gidra <lokeshgidra@google.com>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@surriel.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Linux-MM <linux-mm@kvack.org>, Kalesh Singh <kaleshsingh@google.com>, 
	SeongJae Park <sj@kernel.org>, Barry Song <v-songbaohua@oppo.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: akxck5rw7h13zkgi7yy84rws8agnio5f
X-Rspam-User: 
X-Rspamd-Queue-Id: 663D6A000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1757895830-210589
X-HE-Meta: U2FsdGVkX1+DBP6NEQUcGdwB5AnMVt7DrjNUKOa9taCLHwT6HNfr7muvvhC5f51ZDdbMFytWHtnERdM29t/N4WZO1bT6PNb9fowA/D0pzGH7dfFMBhlbKXb4gYO12qktR33MPepT6+SYPOvh85y8RbevXfa+3kx+gPiOnKQEb43GE9p+Hb1w/+/Ifclg4ty/h5FcJN71JyfUeSRIBe4aelt+zL/bycNtE4/6xDKIElu3aOrGdw/fFaBMFVz8v2KvOs2s1/e1hZr57c2pCnjeXkIxFpSRCe/OTQCCFsVuYOaRVEHwQLk/Hzar9FCelNhOm2Yhnd3bFEOmDpGvtxyY3hLx8RfqdFvat8fCwZDkoSgxpjzDBw3h+gU0Gitdn49Qlb4fLj7eJZlxTpq3D9LsIT19Vye3LUOTFEUQANnXpPU7XXeakc/rn1+6vw9CvlnCn855pEcOpCVQe0Ut6Oa/IaXy3KU30T28KG/cUFJag7cdofoNoztCUDvKaJjBCU00SYVAt40nZsUDn3TVIzuzeZ5nSTc1Q+qxWiocz6O35fcy8Z/bWdlh/a9FVgpH7M/ZqsVol2oAWVy9YVLm4tEfcIylArjHGOWhI7vKg5UXrQWu5bKRWcdFWrBIlEJh5dBzF9EtsBQYHsZ8fy2srqBm557ECAuWj9ox9hS/Kd5vz7pBaPE/r+iGL6ylM/ScM3uHSfShbQOEBlZM2/Dz9NlJ6rzWnloxFJM+GPQ+gJJQD5spV0ZH6lvpyI1r63SCIYhfGsxppW8GS7Eg96kxNLx2g2cstnBSVrqwXTP4pcC1XPqYPmdPNLrHcMV/4Xtn5BvkyVWqWvC73sObsEwANXqGSRgbeEkK5LJJifivpWjNoKiS47cAlrChuNceKz6Y1ln5W5PGTjpYvZQ8/kY4ahyWqXcTr5JQlGIC1MHj6k6+dd97KUuhwUzm/2MPZhu4oKCXRshJXN621V9YqKp6P2l
 chNQLfAO
 fSoZU3Mm4jpEPQSOl1+E5E3UPWElO9Z5uOf0pPRRvX4IIfem2uWJAtTVDoksY8fnEeY8vY2lfJK3NqZii5UHXPFlksvz1x6F8a7JkAW8DlVaXJiFGzw8Ju2G6xQttlWWEC5hoITsfxBXZNWap5hfC+EZQDfNXjfsF4mHZN+e/RGWwmxXopTlJsW5OzXvDJPNJMSmTvf1zn9qLV4g7wnds15PyWRujaKRslPWHNfSFNLGf46itWdrQM4s9eUloyeYXTIMcwefwCp4tCo/AyHHrAwG/Bv1gjvNT8m9sud8ep9wBoBmP9Wm9coYjlImMWsyvGXGSFbxJbEfcwcoF+BN1lk5lhmU7+33qxibAjph01HWZH94/Pm3rkeFTLEqyEDS5K1tJ/zUTkwSRsQlu7CWaic5hGVoUDWOsrADFgMKQ8OUtDIp7dwRY4wSmXVtkoNVluD8jEvewXi01ODHltbbzuCjXkA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 7:53=E2=80=AFAM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Thu, Sep 11, 2025 at 07:17:01PM +1200, Barry Song wrote:
> > In the process tree, many processes may share anon_vma->root, even if
> > they don=E2=80=99t share the anon_vma itself. This causes serious lock =
contention
> > between memory reclamation (which calls folio_referenced and try_to_unm=
ap)
> > and other processes calling fork(), exit(), mprotect(), etc.
> >
> > On Android, this issue becomes more severe since many processes are
> > descendants of zygote.
>
> I'm not nearly as familiar with anon_vma as, well, the rest of you
> are.  As I understand this situation, usually after fork(), a process
> calls exec() and the VMAs evaporate.  Android is different in that after
> the zygotecalls fork(), there is no exec() and so the VMAs stay COW.
>
> I wonder if we could fix this by adding a new syscall:
>
>         mremap(addr, size, size, MREMAP_COW_NOW);
>
> That would create a new VMA that contains the COWed pages from the
> old VMA, but crucially no longer attached to the anon_vma root of
> the zygote.  You wouldn't want to call this for every VMA, of course.
> Just the ones which are likely to be fully COWed.
>
> Maybe this isn't practical, but I thought it worth suggesting.

Thank you for the suggestion, Matthew.

Lorenzo suggested possibly unlinking the child anon_vma from the root once =
all
folios have been CoW-ed:

"Right now, even if you entirely CoW everything in a VMA, we are still
attached to parents with all the overhead. That's something I can look at.
"

My concern is that it=E2=80=99s difficult to determine whether a VMA has be=
en completely
CoW-ed, and a single shared folio would prevent the unlink.
So I=E2=80=99m not sure this approach would work.

You seem to be proposing a forced CoW as a way to safely unlink from the ro=
ot.

A side effect is the potential for sudden, heavy memory allocation,
whereas CoW lets asynchronous tasks such as kswap work concurrently.

Another issue is the extra memory use from folios that could have been
shared but aren=E2=80=99t=E2=80=94likely minor on Android, since only a sma=
ll portion
of memory is actually shared, based on our observations.

Calling mremap for each VMA might be difficult. Something applied to the
whole process could be more practical=E2=80=94similar to exec, but only
performing CoW and unlinking the anon_vma root.

On the other hand, most anon folios are not actually shared, yet
folio_referenced and try_to_unmap still take the entire root lock.
In reality, they only care about their own node=E2=80=94no need to iterate
the whole tree.

I still think optimizing from that angle could be a better entry point :-)

Thanks
Barry

