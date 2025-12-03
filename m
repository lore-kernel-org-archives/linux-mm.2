Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACC1FD1BDC7
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 18:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07D966B0007; Wed,  3 Dec 2025 13:01:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 054C96B000C; Wed,  3 Dec 2025 13:01:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAD936B0012; Wed,  3 Dec 2025 13:01:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D8C246B0007
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 13:01:38 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 68258140728
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 18:01:38 +0000 (UTC)
X-FDA: 84178927476.27.E1DC705
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5CAB740018
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 18:01:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4T9fvIIQ;
	spf=pass (imf11.hostedemail.com: domain of fvdl@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=fvdl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764784896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oQ4P8LC+51Vcj7CKWx2AULySwQLuwp7ItbWzoUGLq3c=;
	b=kSJM3ea1jHPTCXg41zZmdMxEadgkVVpN0oe5/pgrGaLY3DDAgX9Id6yz6oAYO4L5sZ6irv
	OMBL+mj7qPkI/21Nqnbnm9FtGaPccS5GpwVt5keTI1CYNo8Lt3xuTU0LKWA0tO5fnGSHy2
	HfOgUD65xFmzlie/11equIwkbOFhuRc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764784896; a=rsa-sha256;
	cv=none;
	b=AqN8dmzgOVP4ie74nVqMoKV2nXjyb6UMxD07mkxvN+TDhG0flTC+bkq3l2kNpQyPW3iT43
	sePsgXf/5OLxwqfhBJ7mkt1L3i/bycVFLGbYgu1AlUP2EA5ACKxE4LxkurGk5xwMt9h8+J
	zv1neNNwO9WN9PfJEznvW8bHWk/OtqU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4T9fvIIQ;
	spf=pass (imf11.hostedemail.com: domain of fvdl@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=fvdl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-645ed666eceso315a12.1
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 10:01:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764784895; x=1765389695; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oQ4P8LC+51Vcj7CKWx2AULySwQLuwp7ItbWzoUGLq3c=;
        b=4T9fvIIQyAbNjcXrGvLZ9gbVU0W80GWfrzKVjyG+kVMNdF6zgCTSE/a4L2/SvtVRwh
         tGTl/92iTTSVdWAAsIcSD/JfCrls8EcIYY6G9s6gueaKolSp0CgZQ6cN/G9i0JfqhPYU
         BkkzaLDy7wRRowsdr42OR3yz6iC16wh2adlXg4nuPEqG9xgE8t3j6P6hIlHVxOB8aigt
         +mKcJNnE/0cbJYTf049DTrHX/uUfzNix4Y36jMUN3Au4Sm8zcQbo/o1FQT3MJgL7sjcj
         V+ClUPcStmJwK7dHC58aEJ+F0vYIPoAp+RJZc7aY88a7yJiokut4FdIdNrRfO6vb4cjj
         cIIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764784895; x=1765389695;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oQ4P8LC+51Vcj7CKWx2AULySwQLuwp7ItbWzoUGLq3c=;
        b=YQRZVwz2IRRoe1o1AHaPGeGDNGzoEZtAD9+qTTTwPDVBCbbXYdzY+vOtDg6hwq12km
         e0e4Cyq3uO+mt9wCZNQf7aiub46URG/qB3sGrbKPwFU1EOCv+Z+FrppWUJn6iuhECQy5
         xQd9ZD+TF454HabSVSDyPyFOevv/7c0cFqvKv802va3u/em2Loj4oHughOecIzwQpx60
         ocw1CFqKFdGVqVq68ZGNXFj1O/uUZVFExgPXEbAGqkg40DOEIphKceyeH5z6Jbh/Fdm9
         69hEWZ11Tuxvnn7scUVVWq8kcVgbFp6WTrJTTf7rtoxiNPhm93hniZkce1ANNtSbwm2t
         0S8g==
X-Forwarded-Encrypted: i=1; AJvYcCUQeVbsAsxkz5nrjVCdtwU7nFA6U9H1SwMeQMCsL7FtVbK2kiCi87I/tr0FE8nOfMH8myim1U7yTA==@kvack.org
X-Gm-Message-State: AOJu0YztX3kaI7DD3oW2P1S14Q3MVfIcK6l22I/XSKVwv2b+yKji43L/
	CY7gOaAEykfQHkdChVm4RdJV0oQmk4Pz6o7AbpATi5d7AgxYeDiA3tm9sNg7EYPoRvEhBS7nJah
	6jfOpm1ZXVsSbA3fmyJY8LzalEo/4j0KeP0DyExquFzDFlaxUZ0yEC8XI
X-Gm-Gg: ASbGncuPn2lFOMGCRXQxUIUS6Ml5mjaQu1VIr5STDU/eb7TrVhh++jUmEItL2lr7ZIF
	+IruO7AUUfI8t1VwcqIEwycgrsfBOqFPncS6vGnc89OtGsq7EGPu99tJHYYQsZEkdWalx5zCbMR
	ulzTOsxbc4HxjsnLEjY87MRYKbrrer2OdDAXrMAP5Y9nmKlriUhql4E0Nay2x4ylSXjrxErGsOM
	l9XelqD2MnqCZCRWtLmzLJXJbvhZmjNYsnERLG1YxfUbAjyp1l8s27D6JT8GxA+OyuJ/s3b
X-Google-Smtp-Source: AGHT+IEq5GU7JSJAD9NSFFTRdVafRqGeePEnDnbLwoGqXLyw0X5hyqRrQVNf0XDjg2zuGyBpzHfDgCdEQ6erVOBfoCw=
X-Received: by 2002:aa7:c057:0:b0:643:6975:5381 with SMTP id
 4fb4d7f45d1cf-6479f73071bmr21488a12.15.1764784894352; Wed, 03 Dec 2025
 10:01:34 -0800 (PST)
MIME-Version: 1.0
References: <20251203063004.185182-1-gourry@gourry.net> <20251203173209.GA478168@cmpxchg.org>
 <aTB5CJ0oFfPjavGx@gourry-fedora-PF4VCD3F>
In-Reply-To: <aTB5CJ0oFfPjavGx@gourry-fedora-PF4VCD3F>
From: Frank van der Linden <fvdl@google.com>
Date: Wed, 3 Dec 2025 10:01:20 -0800
X-Gm-Features: AWmQ_bm9jnHUGZVMHvCiQBBD_zjOFaR4rqaOnzbPbdd4tEkA041SCnA3fwsyYVM
Message-ID: <CAPTztWar1KqLyUOknkf0XVnO9JOBbMxov6pHZjEm4Ou0wtSJTA@mail.gmail.com>
Subject: Re: [PATCH v4] page_alloc: allow migration of smaller hugepages
 during contig_alloc
To: Gregory Price <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, kernel-team@meta.com, 
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org, vbabka@suse.cz, 
	surenb@google.com, mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com, 
	kas@kernel.org, dave.hansen@linux.intel.com, rick.p.edgecombe@intel.com, 
	muchun.song@linux.dev, osalvador@suse.de, david@redhat.com, x86@kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Wei Yang <richard.weiyang@gmail.com>, David Rientjes <rientjes@google.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 5CAB740018
X-Stat-Signature: npzjsrt6hginom9ikj8y576u41qxu6pg
X-HE-Tag: 1764784896-36526
X-HE-Meta: U2FsdGVkX18XMrid7tkIi7o8RsoTX54cs+MIf8dllr62iH0OthtS08wvWgV5ajpNiA1/2HNzVkB5jCoLthmWocCyh54w3ZVLh1batKKoHu1GjN5PjlsY5yAhsob1EMivOsR0VS1zxFa76JbIcwTcCcvsBBnqnyo6BkHcClgryidv5B8i8z7nTviac57Fu/vB4LdtytOJDzLvxDPR6oN0raBi5h3QuOdiWZmCa9a1Xva/Oub3CKmvu2lJlU3YmbjBoQzl/N7SblJSeFVlvYbIm00c6MwPwmn+AD4AxxTfKKQaWai258QAoE/B6MueqZJBE8cWfvd26XaI8yrP6aiUu0F2Mf9wXY3DoEEY5jwCaNr73S57iRiVBNwmrfemE8pbOIiKkdUOcWKrMfUQ+ixIMb8DFBJNdRkkqXphtbmo27hGTPwYGSERXOc5edR5NxGZqCvGbLKR+vPFWo+B5k1pzmrrSD0CJtPy0j1XXNLgBXirJD5BD6Sjsd4e0JdFpP5kK7wzHOFLQdbmfEeNkfjfmUWfVGlvn9AnhlbgcL6mi6Q9ZFcwrRStpooWkmJN9s8VuQEImSc+mIG5rs6PPGyTxHj0X67Ezhwl+X3+9m8NdXqEaAHqUGGQthDXD9lQjy8LGZ3IAEyAIdgbKt1Mp7KySqkF2czetQ1i+8AcC2QbMzc0d0ee/gf4ZEL2sQaYhAVbvi81fIdbOb3QmsTDww1ZSef97DqhcOEVtGhF29Z2EJAh8Av4rozGUIlNa6m/4tdEwQB/ZxyJDYStovGnpM4to+80GZ4wlpkrkr5bUnx/DYOqLIIFhOeZ0UHyvxVJDb3P6gntmWzL9SW66nMTeIs7eit5kojxP4aflGiN59ku/KxnsZl12iTu37CB6X0Lp6BvYzY3gLNNTXqNEAkR+gUhtPO5+rKtF+Z55HaAO/kL4fFBIMmipoLxKSnktJg/gS5p8CCJRpe6NtqJZPh2X/i
 9EZLtWeP
 ydUzhq1O3ql+b6BuZaDsNyrHiH365Ync9kAviwhOQ/vyMvxREedX6cO7Qm36UaGxx+IIuL12OYbvy3Q20n12mGwVX0QZikB0z/lZNQq6bPO7NBxbJQIaq1tRs/RW4j3dtdVhXitgFxxAM9zVRnKy/3kUvrG9+LBY+IbuhYNGVRYqVvD/pAiqQbvUTu39OW8JB6DbTX9YR0mmM/n2gBKkenlyYuxFtQPQlNZNBaGPN/peIyhHuiT84kLois1ZEc5DL3xnTY4XnN8j9DUAGbXdSFV/XgaqxAs7pS1bCrol+ZyYY+jRB/MNT3uFDbfua5ZwRkashayG6uN7k/yqTmK/p3YrtGNK5MYEXYlXbNRQDvxmwkmyaIPoWnX5wSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 3, 2025 at 9:53=E2=80=AFAM Gregory Price <gourry@gourry.net> wr=
ote:
>
> On Wed, Dec 03, 2025 at 12:32:09PM -0500, Johannes Weiner wrote:
> > On Wed, Dec 03, 2025 at 01:30:04AM -0500, Gregory Price wrote:
> > > -           if (PageHuge(page))
> > > -                   return false;
> > > +           /*
> > > +            * Only consider ranges containing hugepages if those pag=
es are
> > > +            * smaller than the requested contiguous region.  e.g.:
> > > +            *     Move 2MB pages to free up a 1GB range.
> >
> > This one makes sense to me.
> >
> > > +            *     Don't move 1GB pages to free up a 2MB range.
> >
> > This one I might be missing something. We don't use cma for 2M pages,
> > so I don't see how we can end up in this path for 2M allocations.
> >
>
> I used 2MB as an example, but the other users (listed in the changelog)
> would run into these as well.  The contiguous order size seemed
> different between each of the 4 users (memtrace, tx, kfence, thp debug).
>
> > The reason I'm bringing this up is because this function overall looks
> > kind of unnecessary. Page isolation checks all of these conditions
> > already, and arbitrates huge pages on hugepage_migration_supported() -
> > which seems to be the semantics you also desire here.
> >
> > Would it make sense to just remove pfn_range_valid_contig()?
>
> This seems like a pretty clear optimization that was added at some point
> to prevent incurring the cost of starting to isolate 512MB of pages and
> then having to go undo it because it ran into a single huge page.
>
>         for_each_zone_zonelist_nodemask(zone, z, zonelist,
>                                         gfp_zone(gfp_mask), nodemask) {
>
>                 spin_lock_irqsave(&zone->lock, flags);
>                 pfn =3D ALIGN(zone->zone_start_pfn, nr_pages);
>                 while (zone_spans_last_pfn(zone, pfn, nr_pages)) {
>                         if (pfn_range_valid_contig(zone, pfn, nr_pages)) =
{
>
>                                 spin_unlock_irqrestore(&zone->lock, flags=
);
>                                 ret =3D __alloc_contig_pages(pfn, nr_page=
s,
>                                                         gfp_mask);
>                                 spin_lock_irqsave(&zone->lock, flags);
>
>                         }
>                         pfn +=3D nr_pages;
>                 }
>                 spin_unlock_irqrestore(&zone->lock, flags);
>         }
>
> and then
>
> __alloc_contig_pages
>         ret =3D start_isolate_page_range(start, end, mode);
>
> This is called without pre-checking the range for unmovable pages.
>
> Seems dangerous to remove without significant data.
>
> ~Gregory

Yeah, the function itself makes sense: "check if this is actually a
contiguous range available within this zone, so no holes and/or
reserved pages".

The PageHuge() check seems a bit out of place there, if you just
removed it altogether you'd get the same results, right? The isolation
code will deal with it. But sure, it does potentially avoid doing some
unnecessary work.

- Frank

