Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B762C531F7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 16:40:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E6E66B008C; Thu, 23 Jul 2026 12:40:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 197CA6B0092; Thu, 23 Jul 2026 12:40:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D4D06B0093; Thu, 23 Jul 2026 12:40:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC4216B008C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 12:40:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 748F31A058F
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 16:40:15 +0000 (UTC)
X-FDA: 85020603990.26.0A51526
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8521240013
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 16:40:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k2SZFsv2;
	spf=pass (imf11.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784824813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L1WF96ciKQolZmAE+pgzHAJ9kBo1cnaH8qexS6yH2DU=;
	b=qQRkRrzkF/bAycy2IhGBenq3UcdITLNFaaWwdYtPmQ0WAuXF9gejUzEWgyQT7y2dJQr53c
	tSUS0yJ8jnbt8Qj1CymcnBq+TkSLYZfkFs8gLpO7txOMOwuVWkbpsIyEQXLEaUu6CwWmI0
	g6IVzQs+1L7xeE1YbLdRAhYkAbjrJ0k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784824813;
	b=0v1Otyjuo3IDexTBTvTqmJ0aQeVx1KHq5nHKenUN3GB8ztRH5/dkNnU+m1CTOironM1hgf
	4VuYuijo7pUF2R+XpKOGFhts92ApKGcYXN9FA2PQykskMNuErss2dNG6szpLYxIx9+LouU
	U2oVX7iOQ5M/7QOFjldp1bqLcULqrWo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k2SZFsv2;
	spf=pass (imf11.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D99B43BFB
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 16:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31DA31F00A3E
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 16:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784824812;
	bh=L1WF96ciKQolZmAE+pgzHAJ9kBo1cnaH8qexS6yH2DU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=k2SZFsv2xy+opCeeNnC+fKDLHy3UNkxpVryXRKTU1BptF7n6f10IRCtsC30NBz7Dj
	 ELGj/S3Gt44bNURmMHLCEJLfvGc7QLVP4gWjMImI4Lu2zMw9gP4LS0ASDkPRt79JrJ
	 S3SvPF1D6stcsLoticViw0CbMppmjC/oqr5BGo5j15fdjDOD/E81tvZLCAhPshSvHQ
	 Puqv9LAYyTL7RrylT7U0gOS0gvxicOzv9YP8Djy60s/H50wn2UEfGkmmVLZyW1mp6X
	 tjszSxu4zIUGtWSz4JHQSP7IGzlHM/q1xnqS939SYR53AOiDif4VBZWkvczSILImzI
	 4abnqDrBduOJA==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c1c52d920b8so124440666b.2
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:40:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpBsG+ccQxmiqxs6afZrS921D5OOPRsXA2mABN4b91qeu2oTOKywal7JysUIYpCB3doXRs8mMSLXg==@kvack.org
X-Gm-Message-State: AOJu0Yy5Wt8Y3kQ07n339yNLTuT4UBQzxvze1c7OrW3M1dGMnvV0XZE2
	/1GFLLj1deq+F9/O+seBcpC6sg3Tj7pL70WKzsuMxcSaF99ka46vAJApR3/np0La8xel/NB9IFr
	QGxPnH5BF9QInrLgDbpKF8vEn8R5AQDA=
X-Received: by 2002:a17:907:3e95:b0:c12:9b98:209e with SMTP id
 a640c23a62f3a-c1c50779e7cmr200383466b.23.1784824788367; Thu, 23 Jul 2026
 09:39:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260717085151.22822-1-jiahao.kernel@gmail.com>
 <20260717085151.22822-3-jiahao.kernel@gmail.com> <amF7_GB5Rl6OJmt4@cmpxchg.org>
 <CAO9r8zPaUPddYoLz8o+g+xkb-zdkfyB+LqaDOrkzqFSePEV-xA@mail.gmail.com> <amIdU1lFxqxTI3Gc@cmpxchg.org>
In-Reply-To: <amIdU1lFxqxTI3Gc@cmpxchg.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 23 Jul 2026 09:39:35 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPepaekOgaDaVBWyB_F05Ezvz+AJZ8M5+NGQ4BmiJNBkQ@mail.gmail.com>
X-Gm-Features: AUfX_mzK8yuJuGvUphs6dtuGvP6iNql6l9OJrVUX_BJAcI_Tz-dPlTb80kJnY38
Message-ID: <CAO9r8zPepaekOgaDaVBWyB_F05Ezvz+AJZ8M5+NGQ4BmiJNBkQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm/zswap: Support batch writeback in shrink_memcg()
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hao Jia <jiahao.kernel@gmail.com>, akpm@linux-foundation.org, tj@kernel.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rrxtctgrqorf7xp9uqr8a1tyz5kchzjw
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8521240013
X-HE-Tag: 1784824813-140507
X-HE-Meta: U2FsdGVkX1+ongTXkONQ0V1XbXLI05Uhnhfe3SOKsneRy4G0qoBQJhsSTmnktCBZJHvQzpZMwAdGDWUU4dlhOz0u8lKrG/NMBu2jkcqqQgmx6SMon3Qz0cdwqxb+52qRMLBsBAySGmtNNR7s+9jnDgsR/15jfFV5Pay0PVuzFAM2Hi0hGurJT+xfTqeWr2WyDAAWwOQ+70FwpGSZWL6jxZbZaunYXLO9W9uU/NxGq7UlE1r/l9c2X9t7N5Q+9y2IA8oyK4unf/eXp7FepG1ltcnRb/CC2f2XUhsDoDnCo6/tdZkivVDcfCDvyL6CKoHylk7sOSgWkvOUKxp2xw5yOZJAw/jEg0rpGSE+vNJNi1E0s8sdofca+FP6UUmWJFC8dxfBiQFV6mNurcIVi6kNqmSjzFcKdcqfY1sRZRv7jwVNxCQQkSJprklLc9rbc3jFP8j8osX1zD0r2+GAeKENm6GIlHqJYCpzesz4x9jw9JFlNmi0MtORwH1UwXeZMbkyeQagdPt4iSh/CdX2Sv7RkhNVWBjJ/52kWOpQJBxR9DyQODrqzAaihj7kr3QzqNryim3Zv1G+Z4unUzxOCWd1kId9O0VQxTBWM2hUPDVQcii4UMFvakCDEBwtgiJVFDT6gqPwU+yzUlXw2FSczFgYBg+vb/T8lIz5u8ZEBBOA/mY4oS/e5b+gKuYQbO0QKQtYF5shZ8rJAQKlApplD25mlHwRMjyafZ6Pbxuz1z7XKzwHOO0aD3wHoxF8GebmD+VaQpeBmHI5IsAmLoh20al/olo503cJ4WfVTs1YUqKG17e0QugQZcbt8Z/0OmCpK+Hbu2w9YhE1pNKrUjSy38PEDKJlAl316vhHvzwsp+ER0QhKUR7BmjMY1WZdarxx5sdF0CAwNFB6ic3qp+VyQDPlJMVLlhFrc8zRSEZeuhIpYl9ZoY1ajH2RLsgmvIbLMfYp5KFUUYepSHnVZ6+b+8u
 O0265VX6
 ma7IRyBEcf7eYfy7PxzhZKZr4NgHYoAsmiJiQroWtKJO0lVbzPRJp1dJjBK4XfyjsqAp1TJ/qxZfPoP1Tsy9iXXiEVnPaaN95ST8l+wSuMPk3VdfHDnTwyArOWc+i7pOIC8VXav/KCHctLzpiZPZ7MX3wOd+7nwzG2f6GcSYrHCqtD1MzOzae9LKjyjj/B4GBjv4vmGtx6p6J8L7Tl9hm/c0MpfawSIrmjBYSxUg1+XchKFTPeQ26Ra1J6BIc8IEBEv4cxltHXt/DP+LNhNZQLHyBWITfsH2mrtxwGo81lGKFFfWR5ZW+GAYXibdGIyhkDj5qSbLWYkemTpbHrU0TGJxPk34fKORVNSSDKHScf1HwOjjXOTh8HLMPn8lOKuUOPmdYhslXUoBI8tbgCA7sysQRE8qTJLYm0eRsya/iZ2ndUAi7yWm+E1rVBEOTslQMTI6C/6dB4my1379f8IomHDxIPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 6:55=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Wed, Jul 22, 2026 at 09:52:18PM -0700, Yosry Ahmed wrote:
> > On Wed, Jul 22, 2026 at 7:27=E2=80=AFPM Johannes Weiner <hannes@cmpxchg=
.org> wrote:
> > >
> > > On Fri, Jul 17, 2026 at 04:51:51PM +0800, Hao Jia wrote:
> > > > @@ -1369,7 +1402,7 @@ static void shrink_worker(struct work_struct =
*w)
> > > >                       goto resched;
> > > >               }
> > > >
> > > > -             ret =3D shrink_memcg(memcg);
> > > > +             ret =3D shrink_memcg(memcg, NR_ZSWAP_WB_BATCH);
> > > >               /* drop the extra reference */
> > > >               mem_cgroup_put(memcg);
> > > >
> > > > @@ -1493,7 +1526,7 @@ bool zswap_store(struct folio *folio)
> > > >       objcg =3D get_obj_cgroup_from_folio(folio);
> > > >       if (objcg && !obj_cgroup_may_zswap(objcg)) {
> > > >               memcg =3D get_mem_cgroup_from_objcg(objcg);
> > > > -             if (shrink_memcg(memcg)) {
> > > > +             if (shrink_memcg(memcg, 1)) {
> > >
> > > Why 64 for the global limit but only 1 for the cgroup limit? That
> > > seems arbitrary in multiple ways.
> >
> > I suggested that we keep the writeback here without batching and do
> > that change separately, mainly out of abundance of caution as
> > writeback is done synchronously here so the extra latency could be
> > problematic. I think we probably want to measure the performance
> > impact of that separately.
> >
> > That being said, this path is potentially too expensive anyway due to
> > the flush, but I would rather we do some basic measurements before
> > batching here.
> >
> > What do you think?
>
> It's not an unknown, right? We know this works for direct reclaimers,
> cgroup limit reclaim e.g., and what the latency implications are.
>
> Because of how reclaim works, we also know it'll call zswap_store() in
> batches of SWAP_CLUSTER_MAX. If we don't batch here, they're likely to
> each call shrink_memcg() once we're at the limit - while still risking
> rejections due to compressibility differences.
>
> My worry is that if we start with an inconsistency, we'll be stuck
> with it for a long time.
>
> I'd rather start with the clean, consistent version. Dial it back only
> if we have data to justfiy the complication that we can put into a
> comment and the changelog that outlines why exactly it's different.

I am fine with doing that and basically always using NR_ZSWAP_WB_BATCH
as the batch size in shrink_memcg(), but I would be more comfortable
if we did some sanity testing.

Hao, would you be able to do some smoke testing with NR_ZSWAP_WB_BATCH
used for all paths, and memory.zswap.max set in a way that induces
writeback? You can probably set memory.zswap.max to 1% of total memory
instead of the global pool limit and rerun the same test.

