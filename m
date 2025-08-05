Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83C78C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 16:56:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27EC46B00AA; Tue,  5 Aug 2025 12:56:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22F3B6B00AB; Tue,  5 Aug 2025 12:56:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11F096B00AC; Tue,  5 Aug 2025 12:56:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F1BFB6B00AA
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:56:44 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A9643B6575
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:56:44 +0000 (UTC)
X-FDA: 83743307928.22.3708222
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id D8DE01C0005
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:56:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WfTKXS9U;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.180 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754413002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JURikxFj1JPMIG8k9K4ujHkActIooq9Dw9bPvRdWPoY=;
	b=Rt+IN1Y7UuorF6ygMKa1FLXRASHR+l5rEdyK/7JW6uyYv5v0hI3GsAvJFwWoitLlC6ahFd
	X0W1cEpFqTLQHXOT4YCaW683hYcTdALuXhTDTP7sB8ik9ZpAsaxl0T/n7EHmHEhkq7Y9Zu
	nOs73kgCme9Dcqt/Wir6JNka6TVuXTw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754413002; a=rsa-sha256;
	cv=none;
	b=qo8g1tOUBO4h9Si9aHEPjFIdwm1McxPvfKuHPng0dLGzriTBYqfi+eouILiosdQRC30QJR
	B1F1fRT46BMqMSKr8K5H+FQv8KtRyBXJqcwXl7ASGIdq8hWn4MM/JBuwl2DcdprclsRCxT
	yNAYl8otPX+suXJq/quglKZDoBKUC0I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WfTKXS9U;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.180 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3e3d0cba6a7so21237035ab.0
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 09:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754413002; x=1755017802; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JURikxFj1JPMIG8k9K4ujHkActIooq9Dw9bPvRdWPoY=;
        b=WfTKXS9UPOgXEiEHonvEle9s/P03iDUlPrJgMDWuGo6WKmge2pfPARuw3aK0XIc4ZE
         ZRENYHL0/XTZLVgk5XTp3XaucA6dl/85uZweF4q/p65RhA2tV7IJAgJD3oXCYUUB4bh7
         mLhCubEuKCxYsdirBml6+PXq4X+MFqDt3wYERmkiU4ZQrABjU2j20b3UAhCYEt1NMPaG
         ai1k9LJdhfTXCuLw18njahOSVxpNEhGyMA6raGuiawPvHGTQImamkxBBZoYufLdzH8DT
         e5LFvapZOBCf0E5yD07a+Skr/u8z2uQIOMQQUY5HDQay5uvgQt7WEXJIk77K8Kw+yrrs
         9b9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754413002; x=1755017802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JURikxFj1JPMIG8k9K4ujHkActIooq9Dw9bPvRdWPoY=;
        b=XCMjMuY60w/6n7QQdzTgTX8LcOkloCyN2O/P0Ei13zW8VFvMwvUH0Tg99+CocYxGMV
         bRGIJn0Ld6k5cHUp6Wtc2NdecWm1grOx5612VPR+YXCQ8spnJWi8g3xasB824/BN+GJo
         FgnK8WGyAu0byyoQTjtsm1nsZTIM6zUKylKiiSMPNEotEowvPGH/7szPRndmmds9A4aD
         +Q4TkipsClCP2O8vDu2/eGYsSVlxBEpt0Eu+PEd+fB8twMkQmwytfh36pKEhMSJ+5ESS
         sC0YIv6OJznrxoYQ2csUK/qE72GlToKdsnoIDs29knHISoXd+g5qQsibZy+NbbEI/lOM
         xCzw==
X-Forwarded-Encrypted: i=1; AJvYcCWILvWeFJ4tWEaVRKXgZMXfV1wWqct8BO+YR67NgxaVdv69f7PruIstvd0/9lFxjRYuILBwjzWCiQ==@kvack.org
X-Gm-Message-State: AOJu0Yw/gy2ONYHRDGjFzjFsn2Nza8WyX2sQzGleuBZXK8QGlkA7LTXQ
	mxYXMynJqIC4WY60x+Nf2vOVTIYrk+aUG+ewOhEsz5MscD0NkCYnbI3H/1kI2P6BEdewzN1UkE7
	lIbgKjrZsrSIk8ELAqcPprhKNfuJ/gG4=
X-Gm-Gg: ASbGncsoCWldL3+T2++heUKvK8U/cfzXVFDpRaBxXzr46vnWGFCgrfM15a7qH2UM46Q
	fbwdKFsym5jLso5MWi0VRU/Iu3VctWcDcR7JX3TVTBP0aBSD9d1XY/C3t49LVWVWXMYZOIaCDAy
	Qkar0CEXYohkSiWztyDFiILVKEG3uWwIM92WzNYWQtgnLA0VzhYGIEoMhfKfo8s7ZtpTyRkMQ0P
	u1mSXA=
X-Google-Smtp-Source: AGHT+IFKWuYJwFL/TSEMQ2ahjFJ9+k6YIyKX3uyxdbHn8KcO8+Zy6yyb03qRPbsqbjWe3FwKP26ZJ/nzd0auZK37yTY=
X-Received: by 2002:a05:6e02:3f0d:b0:3e3:fdd9:8972 with SMTP id
 e9e14a558f8ab-3e41615d9c0mr242900825ab.11.1754413001753; Tue, 05 Aug 2025
 09:56:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250805002954.1496-1-sj@kernel.org> <761a2899-6fd9-4bfe-aeaf-23bce0baa0f1@redhat.com>
In-Reply-To: <761a2899-6fd9-4bfe-aeaf-23bce0baa0f1@redhat.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 5 Aug 2025 09:56:29 -0700
X-Gm-Features: Ac12FXwKyCyXaDbbCA1d5wEx5xyJYQALLRbD4ssEiJbWg--hw6b-8mhARiZxjN4
Message-ID: <CAKEwX=MVBJ+Okfsob4Z30_5Y4P8c2DWoS1dYN4dF5dgp4+CexA@mail.gmail.com>
Subject: Re: [RFC PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page as-is
To: David Hildenbrand <david@redhat.com>
Cc: SeongJae Park <sj@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Takero Funaki <flintglass@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D8DE01C0005
X-Stat-Signature: tmxac6gnr7cafc1c9egz6aziczadaemy
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754413002-823236
X-HE-Meta: U2FsdGVkX18+ThGuMrL0K/Ln9JNFRpIUxGwWfQyNkqdX9z3w8L5NwjjoC6WmnyXU/vYDnQnfB2F0iQLjEnOc49h7e+KKh75NnbyxtpeiZiI/THAijCsFYqc2rkKjJCnOStc8cxSNCx3qSa11g2AkOfbP66uRZ4Gyf0Fhx3z2424fN9xGoFnCb+A0RRvThhFub9dwkyEpI3MkkbtPEpTCK9IxM6yzpWLAmvanMXibiddV1o9NCi+AxEUlq9HfyzRVz08yi7rHRAOF+6DXbSPRepHR1OfRvtLjLAnjkJgCbzL+fcj05SG3TNOPvgJyioXqeaY6O8IBHsUGT6y74B30pxzsjYH1kUEKg3yoXRZ1QC3myl3nrtTbjtlIHIrFd0mSR23zfX97A7bUv6lJx7/BuFjeNUUNlwUFmhx20sg30Qz8MPtsDCrKruPQBKp4+H5Ojs85coC1Qnf0NiQMpOCiHSiFcqmFLxplmLWvLwK8J8Gx/N9swO40rTVAWqHbXiF+o0E23kJbhWTiPVk8mGoWuPi7jnar3vW90pZRd33YFgO62ayf2ufMJLxKmmD38sqmwsQBAkfFaMQenT815rbYr/PNpMJs9/UD008mseTaQUbgkgk4DYAWPJ5MsZgG8dpMf+mHhyaOfEXRe75hgXndS2pOMVzFIfn3ptCHJd0MyNo6Pb/7+P+wjtz1gXxsomFVHeoyFBl90yMLLexWZcqYzor963D798kRzp838YRHpJ0pv7MaaB7McIdyiir9rWiRpRsnhGZ4CBhxsqw2yIrdCq4OH+BQ3ggwkvMOWftakJI5d4BH6D2a/1Xi1f77GhHMPvOha8IvYWNgFKeYplKJE5WoGmsaw7QA/O6uDrtFEr5bM+z21P9dPkXOwdc5LJ+w3Xwmd5TWr7z34U4NPhSql+qdYs+MVaZ5fFYb1A30kZatlK3UZPcH3KgQ0NAqJA2bcJY3MxdlEs7GLQ0kgCb
 iEFXTprE
 bPGgTbt96uYQ+AtZ5Qp9gfISGKq7LICJpsqtAyORka/Z/C81L1/nxJkNV5I4O0V2fwjNvzBcc5nevZc4bGz6U/XOH9w5/s1TH2tpyGfccOJDR07sj2UjPqB3WI1P3UXTSKdzdb7PGPV80zvGUsEXSe2G3eLSz7SdxC1T/EoP1gSfP/WZ88dVwP5N31BsZrUvalszp/C2pyq6qZpcUx7J8E++WnupcsW1Rg1TEORhZ3Q3jcg+cZQwlEoe/OXPb0ttdCGb1zttOmGrEC0QsX27PtySF4iHjCBQJmkBKl2emsKBsc3vuSjpyNQFuLNYpBYlOE7iXMV+RgPCgOCChVSrjo5ZfUmXpMpRrJS7UoiuCEw5QqDuGqOcff0qlgiFWFt2jvbHs09KpZWNZK3KYTMuhr9mxxEQJ7qftjKs6VHS3JI7aGyQcI4oLw8QheNh9A0qtTapSZ8dYfRQuD91njvRXYjzW1f3EGY9beEG3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 5, 2025 at 3:47=E2=80=AFAM David Hildenbrand <david@redhat.com>=
 wrote:
>
> On 05.08.25 02:29, SeongJae Park wrote:
> > When zswap writeback is enabled and it fails compressing a given page,
> > the page is swapped out to the backing swap device.  This behavior
> > breaks the zswap's writeback LRU order, and hence users can experience
> > unexpected latency spikes.  If the page is compressed without failure,
> > but results in a size of PAGE_SIZE, the LRU order is kept, but the
> > decompression overhead for loading the page back on the later access is
> > unnecessary.
> >
> > Keep the LRU order and optimize unnecessary decompression overheads in
> > the cases, by storing the original content in zpool as-is.
>
> Does this have any effect on the movability of the given page? IOW, does
> page migration etc. still work when we store an ordinary page of an
> shmem/anon folio here?

Good question. This depends on the backend allocator of zswap, but the
only backend allocator remaining (zsmalloc) does implement page
migration.

It's why we insisted on using zpool/zsmalloc to handle the
incompressibility case as well:

https://lore.kernel.org/all/CAKEwX=3DNC65XCkmX1YzivEJtPc+sEJ3pLHUsYhF60QJnk=
_OtpVw@mail.gmail.com/

>
> --
> Cheers,
>
> David / dhildenb
>

