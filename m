Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08A53CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 17:01:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 622E56B0088; Wed, 24 Jun 2026 13:01:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D2336B008C; Wed, 24 Jun 2026 13:01:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E9606B0092; Wed, 24 Jun 2026 13:01:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 29FAF6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:01:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9C2BE167328
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 17:01:02 +0000 (UTC)
X-FDA: 84915421164.26.CEED2DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 89D6980015
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 17:01:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iQU7Tb2N;
	spf=pass (imf30.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782320460;
	b=EQeiAfdJKsZDDaHq16QVw7tt20AuyHKK6Ha/et1Fzuq6o+Ikhgdf1EiOPscqlQGgFLBYVJ
	yjIWMaLim57nvPp9tGr2eY0c7POfk+FA340EZmCGE2Vn9qIYoSWiIsn1oZ1f27DQXBEk5J
	CWIBnOODm4jlJB1Qpb3EWboyfsaEuko=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782320460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lVVJtxXyVjgi/BtOT1bRdEE1rJmfHlFaC1R3BjgiYrc=;
	b=gC2a7ongO8u8hjaugQ80lNA3iJVxwm4sl79IHKt2NuzSDCJ4C+vyFJ3a875VShIdZ14Fbu
	bsFqcve/wKEYQxO9HKOve9+RsvSNR4mYLCQZj9hQ4e3Tja0e2LtvXlpKMA6FxTAjeorD53
	UgkQMRxF0mPj6DPixSB+3KtwJAysp+U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iQU7Tb2N;
	spf=pass (imf30.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 132156014B
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 17:01:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07511F00A3A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 17:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782320459;
	bh=lVVJtxXyVjgi/BtOT1bRdEE1rJmfHlFaC1R3BjgiYrc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=iQU7Tb2NT1KiSInJPVW+D63hs1SqjAFIzspWwd3E+tOqJhmaHXPd6jeSJReGW4W96
	 T/lu7esPqrMiveWMr31vS4f7TDZ1i0Gxfub7o0JqvG4IJlxttc3m5KqdL0XY0DehVF
	 IWjkVWFs44mNs4FP+rDMgccSawscCiyYEucsE1SxUBBne38GlxRLHE33XylM7RMywe
	 qxOPYBSt4r18ruxN0GXqqY2bf99yzpx+gMK/x8QL4oYRAZYdWO21AoVjBE5fTUxqHe
	 PkfRS71FNXViqDFK2IH9d72OlEGfXQn2peYkjMOVINyTvnRZ4NM2dmVCsvlvon4rEQ
	 BBKv3uMlDHkCQ==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-bec3ffb95dbso196207666b.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:00:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+bEkAIu3C8wwxWGd3B3tKKz7U3Af7hI8BjOR+/PKHysOB7cqTr8wDZEbUis3cdD5eoakSpYkwJaw==@kvack.org
X-Gm-Message-State: AOJu0YylgDLXV8TjwUI9/zGNl+EChXmQ/xo9eRmeWAJ1+sNOSlN2Zj3w
	jl4rfS50aaW7DukQXyTjRJTgo1Z/zfrn86cutei3kwb9cqPHlpu0uiGOw6zhTUtNjQHV+5h0/x/
	8wTDjgi7RkwcYksyUPznqaxeTpEvLKAU=
X-Received: by 2002:a17:907:1c1c:b0:c0a:5b0e:3d60 with SMTP id
 a640c23a62f3a-c119e1c0c52mr250171166b.13.1782320458723; Wed, 24 Jun 2026
 10:00:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260618044857.69439-1-jiahao.kernel@gmail.com>
 <20260618044857.69439-3-jiahao.kernel@gmail.com> <ajnGTt8tkbAWX8Oc@google.com>
 <0916e673-861f-b472-7417-afbffbcc98ad@gmail.com>
In-Reply-To: <0916e673-861f-b472-7417-afbffbcc98ad@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 24 Jun 2026 10:00:47 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPSZLaqLXw87V3q4tZa8WD7xCympKqfLMLB+o-++GksJQ@mail.gmail.com>
X-Gm-Features: AVVi8CeBIAL_SrdM8s9oEhC5-NPGoXvgoAGhPTPfjDkpJYNf1drEvhkgW-bCgZI
Message-ID: <CAO9r8zPSZLaqLXw87V3q4tZa8WD7xCympKqfLMLB+o-++GksJQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] mm/zswap: Factor writeback loop out of shrink_worker()
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: x1ydtqypf664brp8co7ouuq8py7e88as
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 89D6980015
X-HE-Tag: 1782320460-565123
X-HE-Meta: U2FsdGVkX19UafhZTq5gx5yMTzZsv8eaWxfVKB2fRW8YmGrY5ki+PiDOPdB1pKrgVnPBJ0wGB42SjwsFFDsvtT6yx7M0jcaQiYtXaqfYkYjKZz702U/B8llCrao4tYmlXNENUidjkkYfxDcKqBul5EGQB76eZcSKpp4L5mN3mtxa+EfrwWRuaN1MaOd+kLwwrBYdhOGlUsPfPm71GgwROvGwUtCQP/pZGNG6TkB49of+M5q781hE2JiJN6AFeSHJD3BXh8bp+TxHxnrO7um/UPRkTabNNm9XUIjy8X8l2oAtN43JHgcpIgGi2bWsAJcE20DnhVQPFiSqtnJHmP7cqCiD/VRYlsRXBceYi7qTXymvt/kOmPXNi6QzyBgVgCsvH7I5p82CJd3LdxzOO5WFdarZfZIDsBPqYhu6atkS5zSwf9cNp7fRAt3g3w3OUPKI7yJvyFkbEIhFKLmyG/Iwq25lJnE/WZ92Fs0JdLIxRo3k0KHqWfp426O85bkt13GNnYPAT33OI3NKeK0TEy1OcVCW48kkMjwJOROLIGak2Yfttd2aUJ0o9MOBYFXNQRv0SvYHfXYxUnWUpRwhU6vcxqKhA6qxJsChV/H0NIiZjbWmsoqB6F/CIZ2q9kZ7PgNgTyAsKth6MKY17d6P9EbPt2C3kUfQljbN0sMyB48Ak7WmBr5OwAYnK3R9O0eCFVeuxNaXZAUDP/PKRJ357JAh9DHJ0yiru/EUMlPpEFn9fCH0eX5hkybg4W4AnF9Fi6Db0oavaGugjLhFCLnHkH33HeKILfpxMUqGDkgZwZm3dgjSxSQg4rMd9X4HwjGEWTeAN8ZM30v7A6ZI/+9wtS9n9bNGDil8xtMxFxMdDsDHcI5jv55npiQppWIj4zeIKmemYNyDA+iwV/x8XUCRSOMwOmpbpfmKaSdT2jduSOtnHi4YeOxkVP/ssD0LWlmmVa07mfW9nUKSh1/iuoFkzvk
 7LIl2T7j
 ZwptQ1aN6oyYs/WeiEhmI7FG8gsua4gOCLHt8cmQtlwOGLBhZXyZQZd3b1t3B2r8MlH1/HJ/YX9teTmXN1EFlOUtcof+DWZA51bwNWAR+8c0la66ej7NBZ3M2pGCfvxvOdyXoeKx35xc0QGqiwLI1ON21XXy4utoibks75sB7eZWLJ4PBg86sD/WdSNkPA4p0wi9OafTtxg7fXS4wmc39B7eE6Ya4jKpMRXNqWtY2Pw51ZDFjB0hormZN197MZ8Wew+tZ+g9jU+JPGX+ztUfNcIjIljfiS2txcdF4vUTqQyFuuZoXmIhvFcXR09J8Tx8WCQqNp9iwQBtl4qu91TaEdQdX9QyR88evG4WQcZEdEzLrg/AxP31170hKRuVvaZYsexVLk2MAVM/nwFmGPVdoALmVHLIkrWf5PcAC3NTiE+GoS4GCARusTt62Jg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 4:55=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.com> w=
rote:
>
>
>
> On 2026/6/23 07:36, Yosry Ahmed wrote:
> >> +/*
> >> + * Walk the memcg tree and write back zswap pages until the
> >> + * (lower_pages, upper_pages) window closes, or abort encounter
> >> + * MAX_RECLAIM_RETRIES times of the following conditions:
> >> + * - No writeback-candidate memcgs found in a memcg tree walk.
> >> + * - Shrinking a writeback-candidate memcg failed.
> >> + *
> >> + * For shrink_worker(), it passes lower=3Dthr and upper=3Dzswap_total=
_pages().
> >> + * The @upper limit is refreshed in each iteration by re-evaluating
> >> + * zswap_total_pages(), and the window closes once the total falls
> >> + * below the threshold.
> >
> > This is the wrong abstraction level, and it's obvious by the fact that
> > the function calls zswap_total_pages() again to recalcualte
> > 'upper_pages'. It gets much worse in the next patch as well.
> >
> > The lower_pages and upper_pages thing is also unnecessarily hard to
> > follow.
> >
> > The core of the reuse here is the retry logic. So maybe keep the memcg
> > iteration in the callers, and define a function that takes in one memcg
> > and reclaims one batch from it? failures and attempts can be passed int=
o
> > the function to maintain the state across scans of different memcgs,
> > like zswap_shrink_walk_arg?
> >
> > WDYT?
>
>
> Perhaps something like this?
>
> struct zswap_shrink_state {
>      int attempts;
>      int failures;
>      bool stop;
> };
>
> static bool zswap_shrink_no_candidate(struct zswap_shrink_state *s)
> {
>      if (!s->attempts && ++s->failures =3D=3D MAX_RECLAIM_RETRIES)
>          return true;
>
>      s->attempts =3D 0;
>      return false;
> }
>
> static long zswap_shrink_one(struct mem_cgroup *memcg,
>                   struct zswap_shrink_state *s)
> {
>      long shrunk;
>
>      shrunk =3D shrink_memcg(memcg, NR_ZSWAP_WB_BATCH);
>      if (shrunk =3D=3D -ENOENT)
>          return 0;
>
>      s->attempts++;
>      if (shrunk <=3D 0 && ++s->failures =3D=3D MAX_RECLAIM_RETRIES)
>          s->stop =3D true;

Do we need 'stop' or can we just return a value here to indicate that
we should stop (e.g. -EBUSY)?

>
>      return shrunk;
> }
>
> static void shrink_worker(struct work_struct *w)
> {
>      struct zswap_shrink_state s =3D {};
>      unsigned long thr;
>
>      /* Reclaim down to the accept threshold */
>      thr =3D zswap_accept_thr_pages();
>
>      while (zswap_total_pages() > thr) {
>          struct mem_cgroup *memcg;
>
>          cond_resched();
>
>          memcg =3D zswap_iter_global();
>          if (!memcg) {
>              if (zswap_shrink_no_candidate(&s))
>                  break;
>              continue;
>          }
>
>          zswap_shrink_one(memcg, &s);
>          /* Drop the extra reference taken by the iterator. */
>          mem_cgroup_put(memcg);
>          if (s.stop)
>              break;
>      }
> }
>
> We could also fold the logic of zswap_shrink_no_candidate() into
> zswap_shrink_one(), but adding a !memcg check inside zswap_shrink_one()
> feels a bit awkward.
>
> WDYT?

I think splitting the shrink/retry logic over 2 functions makes it
more difficult to follow, so yeah I think fold
zswap_shrink_no_candidate() into zswap_shrink_one(). Then the callers
only need to iterate memcgs (depending on the context) and call
zswap_shrink_one() for each of them.

