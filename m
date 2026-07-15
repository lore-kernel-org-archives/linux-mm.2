Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA33BC44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 16:13:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 817C26B0088; Wed, 15 Jul 2026 12:13:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77A716B008A; Wed, 15 Jul 2026 12:13:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66BDD6B008C; Wed, 15 Jul 2026 12:13:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 006C46B0088
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:13:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 634BA1A023C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:13:33 +0000 (UTC)
X-FDA: 84991506306.19.5742EA2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8042B140013
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:13:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=olxKOGZg;
	spf=pass (imf26.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784132011;
	b=wzSOQ9m4M1+vN2HVIVlknh53dI2d66f0XAnUIIUKHwpRWvYaFZbeYoEVV+ylgpIAU6Se0L
	1JtFLQ6rYM5tbMyuKJQWEazD9uyx29nSkYInKSArXoiVyDZOsZe07/hh8mE1fpkTvU/pmd
	6hXFq9EmP5+fd7NUREzRjZr9vVedFRg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=olxKOGZg;
	spf=pass (imf26.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784132011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lu5Q8dLhMuRIjKNUUM4Rh5PJ281PWU4rUxfHtkQFTB0=;
	b=lajNCbjmU+NBYX5fB8xI41Ksvlg7faoSOaGMcQbYCPiYcB5eaDh04FEk5Vxsjh4/gc+hPn
	tYbTS9fc9ehOQwzo/Yl08ygZ22vNz1jAcY7YeCG+bKwzczokkvHOpTgGLnqHPhMFlTibLW
	YOhiXuZHbhlFG4BZqXnJ58Bh0J5nXHg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C42960054
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:13:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DEF1F00A3E
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784132010;
	bh=lu5Q8dLhMuRIjKNUUM4Rh5PJ281PWU4rUxfHtkQFTB0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=olxKOGZgyCmb6FPVTij4JCmNrk2owXUCIAWnWPKNseikRFdnhIYMoBd3d6tJHPyFz
	 SRHG3hcV2rKsXoZGdBNVz/z2NDcQX8SCg4BSWs0zoUAGzJWVFjMcdHFMAdWuiPInZC
	 R9M2DBPGzqaYEw2HholgDD81jEc2C7O5Zg4mRwOvv0BooWlAbj6Erj/oqa6jVb9m9S
	 6AC5O0S5o5XOPfB0G1ckSckYS1uNT3LaqE/ruy2iM1Nmk/ROA7DGkC/KkBTUHtBF1U
	 gT8iRpg13v/8l0K6YTJ6rPH7eQAGqsEMm3Ka6HX2o/WR+Oyx4KAXxR/B5sb5D+jPzw
	 hRqF3dNupGZ/w==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6984169c126so10386497a12.1
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:13:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqggCn8y2AqQ7uNU70jVXwgc1XwKtRBnaoOnC+SWw//kpUGvF2jdilF321KsfMo3I7NZFvCZUzohg==@kvack.org
X-Gm-Message-State: AOJu0Yxd1XpcdDCq9EGLM2S3olXdWXzQ7ebNRAbkT99/jdLbtGJcHG8l
	6gBgxMU+Brb44ISEj1YyAnik/97VxX2mHvsjce7HFvRtlF2M9VjheizndYpxQTEv+C/P3T4h0Le
	LmS0OdO0gHGN9/1vXq8aJz8Rf//WPuso=
X-Received: by 2002:a17:907:6d04:b0:c12:8c41:3beb with SMTP id
 a640c23a62f3a-c16794a90e1mr255601966b.50.1784132009676; Wed, 15 Jul 2026
 09:13:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260714081510.16895-1-jiahao.kernel@gmail.com>
 <20260714081510.16895-2-jiahao.kernel@gmail.com> <CAO9r8zM5nzDqNcx5UoDgGexvR6jf8MmJV9SomM4AS7n-rZ2o5Q@mail.gmail.com>
 <20260714193129.f81711f516504b659d544741@linux-foundation.org> <7a1fe347-7ca6-4768-9308-420bf1251f54@gmail.com>
In-Reply-To: <7a1fe347-7ca6-4768-9308-420bf1251f54@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 15 Jul 2026 09:13:17 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMDndmoxi_XvQv3rkkhCfb+aW3=8JdE3gAv2YOKiyiFSA@mail.gmail.com>
X-Gm-Features: AUfX_mwya7L56YQEsogBNZLgTsBSd6kz9fOgJ7y2xnvr3Ptih0l9NoLzTiD9lJs
Message-ID: <CAO9r8zMDndmoxi_XvQv3rkkhCfb+aW3=8JdE3gAv2YOKiyiFSA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/zswap: Fix global shrinker when memory cgroup is disabled
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, nphamcs@gmail.com, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8042B140013
X-Stat-Signature: n4uafkxtgwwaf9kr3eg3af8ma1g1u8qx
X-HE-Tag: 1784132011-316781
X-HE-Meta: U2FsdGVkX1/U409qL2Ulolhj2EJfTneRa+b7RnxSIKMVjx/iZ9i5VnKJdA6fvCUS7g+9WoBq4znAX7ykQ5FdD404qL9oFd0eoQr3m/BcA+Ipa01wDcGuT19i6QynydBk7qaXyu1D9PH+275Nrs06mmN6QMlJOjf0UCRDmXa1A0ugxbAKsaUx/LLTbJaTvvVaJInUtSMRA9FnlKLiR+U8anNQFU+s43MazQ/0Kr9U1kA4r9v5on6kBv1a9hUVu5cKJDR5V6EgG6ffi7RavNBHBioXKaOqtl2KulITcW68/WlMu9w8fKksETlLAxNhep4P0sYfuug+RE6VY4exs+42F21v+ac10Qqy/zxcBZ89pa6JbJGR8kAReHYRcHLTtGx34VhfAAHAXoXp4X04b3tVkB/avVHgBrH0yQz/b31QGORvNLEfVMUlGRA8YovzLt5y6lrXhiWpcopJ6tV9CFRAnu5KGqU7yUidkkyJKV/euSYRkDWpITvD/U885V6MNGS7kykVShF5nRMcGiGISd2C+HB87ROfkkvc20quDd22W7fUKxSkpUVyL2d3oFsJOJgJNWYnbXTI4wgPouZua02itVGVQUzpz8AYz2rAMjm+nQTFF8MSa3XUGG1A1h+MsiDWtB9oD6Pnek6C66BfOQEU9VEoKcmjm4TPQFFR/O/kQH8NbYufXypOLIwGp1qtLlk8vA/d3ZkEx4JSaK/VDiXMM8jsvRI6wH9Cj024Bge45L1FtkCOmOksKOP2ps3EaHWiarTGMxmNbH1nyDk4B+XREghzEjNm8VQ/Ce5gbPlyspboXfzVdK3Xr1rBXN9QK7laYuqZaSHM7qZ/jr03seAW01P11OWf7DMCy6wGP+Uu2S/cIa3dDQz1+rG1ln3EbvTxA9QfQMNTBZINbKQCUaOxkujt2/KCBXnlxb0OgEjXuIg2ZHk8lBMTuNBYzOJlzXn1Vj32IRxw6ZuD9NUbItc
 BDV6OYHM
 hmz9Ht4o0065Eyteh8sJBdVkzyny4wKpX9FyE4KFLtPuZ4ZZOyZYiq7ayvhzumO/W192Yn1aBcG4TACa/PAJLGOgXSSl2zyBMJ9GQV2bZj2zcXsAc9oblCpPeGT3S/kVSSsoD2clIQNj3wG2AtyytDX561+KvN+yub7F+5iyHjD0d+IBgBP77lgLE6xrKQw6/J2C0jKlJF8xK1UwnhwMMkUgDjfgvHYMSwHq2wEkhRSaV7jYPtNYJCoHek6ED22BRJOXFl3XREomuuWX5wwRFrIqFs5NrTdQUSsTGyaPJBlJvfz3nNvlLnqLamvshc77tFcbtYAETaoDgsf/stTpVNdW2zpcds2SMBoeMV4NWxpDAXydWdI6TO1T1Wu8qfvaE/DkFeVP+NLrc4zGSjURPyPM1clQHsNzZQEs5Dg8nmaHxzWLZX6odd4pusX7nkN2iSbVYy9ykCu5uvz3YJnS/fhcank1X9WlHGP4KLAuWAwRUDYYHFzInhXwjLPLn+I7I22v2u7oLvr7VZzk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 5:31=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.com> w=
rote:
>
>
>
> On 2026/7/15 10:31, Andrew Morton wrote:
> > On Tue, 14 Jul 2026 09:52:59 -0700 Yosry Ahmed <yosry@kernel.org> wrote=
:
> >
> >>> When memory cgroup is disabled, mem_cgroup_iter() always returns NULL=
.
> >>> Therefore, the global shrinker shrink_worker() always takes the !memc=
g
> >>> branch. After MAX_RECLAIM_RETRIES empty walks, the worker simply give=
s up,
> >>> so it fails to write back anything.
> >>>
> >>> Therefore, when memory cgroup is disabled, fall through with the !mem=
cg
> >>> branch and shrink the root memcg directly.
> >>>
> >>> With memcg disabled, shrink_memcg() only returns -ENOENT when the roo=
t
> >>> LRU is empty, which means the total pages are already below thr. The
> >>> loop then safely bails out via the zswap_total_pages() <=3D thr check=
.
> >>> For any other return value from shrink_memcg(), the loop is guarantee=
d
> >>> to terminate, either after MAX_RECLAIM_RETRIES failures or once the
> >>> threshold is met.
> >>>
> >>> Fixes: a65b0e7607cc ("zswap: make shrinking memcg-aware")
> >>> Cc: stable@vger.kernel.org
> >>> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> >>> Acked-by: Nhat Pham <nphamcs@gmail.com>
> >>> Acked-by: Yosry Ahmed <yosry@kernel.org>
> >>> Reported-by: Yosry Ahmed <yosry@kernel.org>
> >>> Closes: https://lore.kernel.org/all/CAO9r8zPVzMKFbCixxD-qgtRrkFxWVrHi=
ZZeLc=3DeyTPKPVQgX4g@mail.gmail.com
> >>> Signed-off-by: Hao Jia <jiahao1@lixiang.com>
> >>
> >> Patch 2 doesn't really depend on this one, right?
> >>
> >> If that's the case I think this can (and should be) picked up
> >> separately as a hotfix. Andrew, WDYT?
> >
> > Please update the changelog to clearly describe the userspace-visible
> > effects of the bug, thanks.
>
> I am not entirely sure if my understanding is correct here, but maybe I
> should add something like this to the commit message?
>
> When cgroup_disable=3Dmemory is used (or with CONFIG_MEMCG=3Dn), the glob=
al
> shrinker fails to write back any pages. Consequently, the zswap pool
> fills up to its limit and rejects further storage, preventing memory
> pressure from being offloaded to the backing swap device.

I think you can simply write that zswap writeback when the limit is
hit is broken when memcg is disabled.

>
> > Also, AI review has flagged several possible issues, all appear to be
> > serious:
> >       https://sashiko.dev/#/patchset/20260714081510.16895-1-jiahao.kern=
el@gmail.com
>
> For AI review comments on this patch:
> I suspect this scenario might only exist in theory. For zswap LRU to be
> empty while zswap_total_pages() > thr holds true, it would require a
> prolonged state where there are always more than thr zswap entries on
> the zswap LRU whenever zswap_total_pages() > thr is evaluated, yet the
> zswap LRU happens to be empty during shrink_memcg(root_memcg).
>
> If we want to fix this, perhaps we could do something like this?
>
> Yosry, Nhat, what are your thoughts on this?

Do we need to do this? The last paragraph in your changelog explains
why this can't happen because zswap_total_pages() should be 0 in this
case. Did I miss something?

