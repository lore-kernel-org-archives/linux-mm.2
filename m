Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 793B1C44512
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 00:08:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCD6E6B00A5; Thu, 16 Jul 2026 20:08:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA5026B00A6; Thu, 16 Jul 2026 20:08:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C94476B00A7; Thu, 16 Jul 2026 20:08:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A3536B00A5
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 20:08:40 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 093FF1C0224
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:08:40 +0000 (UTC)
X-FDA: 84996332400.01.D51D85E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 17DBCC0004
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:08:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XtxZEJ2r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784246918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uq8utKGOuKj3StoMy9xF5Px9hk95MjGuUSdIPctg7Ds=;
	b=VBs3EolQHWCArWUvNl4pLzZ2lP+LFVrs6y94GvcDvtyxuA/6nk3igO4/J7uQXuaftTdXNq
	KZiY8VVjQUD03OzIhAs2PzQspx6mVfn2cIUO2i2rMkDO8P/O5iPrZXCEJXFPS/NLBdG5XT
	NpjblPnuysyGRA16po3QwvBRJ+QNza0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XtxZEJ2r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784246918;
	b=5RhknjNegrw0DeTXTRMFxn270JXLaM3nu5OYvZeUNwcZYJLoc9ODE74+OWTUpgF3QcQQz2
	BhO2wDhhaC435Rf4MzsBuKgVwa8k9kOpXnZHzVwgbGLHJfkcm0awCbOtvZpQH1GFFogSlD
	KOMmps5fkYlsr8JAiIezF68tyegpX4Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4408743A71
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:08:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC511F00ADE
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784246917;
	bh=uq8utKGOuKj3StoMy9xF5Px9hk95MjGuUSdIPctg7Ds=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=XtxZEJ2rbkANbpw2gTBA6fUTgyuZMyjKrcgA3/t/qYtquXZbCqPS+MPXJEWbofm27
	 ZD9bMO7H8/fywdSCWuAtn4IG5NrZz06gLRcycpD61VcaioM0WXNWNqypRd+rIWmOYZ
	 ciDYPSbClvVj8dMsweoKbG6D0YJPGw2/7zdXI4B+vWm4kPyg1hL/f1Gf+zDZaAA4xw
	 iTl1xw3Nrj6t8CKGY0PgsYjB8WyATvaMVpDLNgEq+/De5ziu6gBAV9jNJzuOInwnXD
	 pPLjwBYC9RjC1U0gknhDSNo1MOsDlFeTvBYTz52vjan2zGdazi1yRKVavAUOlzkXKX
	 0QKmDvA09VAog==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-69c108fee7fso10727155a12.3
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 17:08:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rogde3AY3YkEUBU0DOVT8o2OOvlANCNhPOrFOIyw4xg1N8K5VHHz30y+fvyqWt1U+WltaK6Iy7Ohw==@kvack.org
X-Gm-Message-State: AOJu0YyQKzo8FkM7j5ixogr/7fiiJMtH3TvnaxczjRcBPDZXYlOS/cEm
	t/frMvLCT/wWlbthgFAhYkl/Zo297AWC30c+mDf5eElO9p99RLBhrOP2dt5LD2OvaQU8xheErqB
	3jQB1ZUX1eUt1WWro2cG7mjsrB4y4rlU=
X-Received: by 2002:a17:907:9613:b0:c16:2f5d:614f with SMTP id
 a640c23a62f3a-c16b48075damr5109366b.50.1784246915847; Thu, 16 Jul 2026
 17:08:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260714081510.16895-1-jiahao.kernel@gmail.com>
 <20260714081510.16895-2-jiahao.kernel@gmail.com> <CAO9r8zM5nzDqNcx5UoDgGexvR6jf8MmJV9SomM4AS7n-rZ2o5Q@mail.gmail.com>
 <20260714193129.f81711f516504b659d544741@linux-foundation.org>
 <7a1fe347-7ca6-4768-9308-420bf1251f54@gmail.com> <CAO9r8zMDndmoxi_XvQv3rkkhCfb+aW3=8JdE3gAv2YOKiyiFSA@mail.gmail.com>
 <7b35fd4e-7662-10ae-159b-303350e4e59c@gmail.com> <CAKEwX=Ob9shetuJK4y=NZods3KkT=U_3W4S_ALzxX3EDLomWEA@mail.gmail.com>
In-Reply-To: <CAKEwX=Ob9shetuJK4y=NZods3KkT=U_3W4S_ALzxX3EDLomWEA@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 16 Jul 2026 17:08:24 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMy3C=tTLsyv_WkAS8Fd_Z3uSCmX4cekPLo8KkNb9bkCA@mail.gmail.com>
X-Gm-Features: AUfX_myGgssWMZxis9Xq0G95Yc2oVqpD1w4OyvXk9Wv0dDSPaEEVeWWsaCcrVLc
Message-ID: <CAO9r8zMy3C=tTLsyv_WkAS8Fd_Z3uSCmX4cekPLo8KkNb9bkCA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/zswap: Fix global shrinker when memory cgroup is disabled
To: Nhat Pham <nphamcs@gmail.com>
Cc: Hao Jia <jiahao.kernel@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 17DBCC0004
X-Stat-Signature: cc3mu8isjds98nh3sbscr46iacgbk14j
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784246917-19882
X-HE-Meta: U2FsdGVkX19UhVaJ0RJ1i5GHRCNt/ogMxWz/yPitGdqDrTTfaP9fFnhbovZwgX8BPX2Zxeq7Qey91MwlugDd8iOjgcruXxvDJZFby5cXx/CVVYO/BQq2szF9JkqyQm9NxNq6uYIqXieSlCYX3FPxBbAPxVJWjYt7kjjUHhkvtF2b0S1+3+xk/XPz54DIyCdrncr2eXuvOQKhttx9+9xM5EIglBWxNjdWLoTHP/yzN133tqfDlYDnGL5z5G358xLSSZzhTPIdePQ8xOXwwdzVBHtP7bMVJxjBhaQoHt0brH9I4F4YBXFGWd0tz23HcLgUkx89e3zn0sk/80jGd9nwFZCklKutG+jDkE7luZTBj/Hk6kAuofkdKhtsMjGhdjSy8VwNQUKBXSHMPewMHsIe9w4BLUXYnKOAJwtS+0Ly5hGXXxOV6LhIMp3G7cdCLnhjJ+z+cI4W38guw6sTDm0IGnIfsB1a+Bttd4kBrDNq0Rkhfpuce+yMOXdT64HJtoEuyMoXdYXopEMCWLVcoDOrXENdwBqPViTC7FoptrT8+UhEn8QsLqf8SbVt4RjldQqr7D8k99A9CNk09OsOI2IsrZ6v5yCeIaXxz1CelvgnbbvYV5qZx4DSsxF1zWCZFnbaRcm2Ff6fi5cCKDnNzQw6FLLLaSaiJicUddoC3xOBe21LQEPtgHERHJMuoROZeeu6OJvgcO2U8LWbHUVb2SJY8rJtlY0ovoFuVjiuA3mh58znGvVAsaOk/lO76coyWEP+92e9QAzNsUCcj/DHKlsZWoImjlZEncxFZsb79tM+Yn/vmV8d4dKlbuSLkZetjDAVVEy39muajjgzPZ1e6h05ZZHiLxeiKWCCriRayJLT3mORrkXlFfTvWa6tfz9dYUR4u4NFe2n5d/vDLAODkeBk3P6RQXKWAt7cBswLmuXOyREKxnNBZ/wN0TNyLOdW2bwSRyU3/f6vBPxFIur4x6O
 KMTOAZzF
 oIxlmUy6zpqSccnrxnY46I/hgRWByDHI2qrtez2q9gg0zU5ZyRNcgMK4jPKUGamn5Qri6qwjQK4PvuR8CyMI+l08XRUODbXaRIJKIurSBlA7dodxDpu1jfCJIXafx22pD3NikxZdCFwxLUBBtS1mcRpK/tNBy2BehgtEx07ERT4/Id01yV3jecAWzdQVNEaQpauUGDFIO7aDCi7a/SvukE+dbGfMHSiNOUCp8hiOYZmgfLymZg3KH0fG7K/hI5LSAHFqTNXiF82og8SPLVoQNJJzLqjah61hMYJD7x52+DalCanysaX0VsBR5SoxeUWTEMqdOSX7uLBbGFGp1lzsCijVkuXk6ZHVQhrAeYy11tOcG30JnuKKTNQxs/CgXgzCD20/9ed4WMWhr26VAHwPoDQzPcegPzMsZyvLmQImaeCbVx4cTV+jn9GcTODW/W8IindX9sGfRKB0Vv3sPlf3DDzTdnohdYtnVs3Crcvc8ytvlhPVXVW1tuLOyn5KUhsdcRLppKHPoDLF0yzo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 11:19=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Wed, Jul 15, 2026 at 7:21=E2=80=AFPM Hao Jia <jiahao.kernel@gmail.com>=
 wrote:
> >
> >
> >
> > On 2026/7/16 00:13, Yosry Ahmed wrote:
> > > On Wed, Jul 15, 2026 at 5:31=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.=
com> wrote:
> > >>
> > >>
> > >>
> > >> On 2026/7/15 10:31, Andrew Morton wrote:
> > >>> On Tue, 14 Jul 2026 09:52:59 -0700 Yosry Ahmed <yosry@kernel.org> w=
rote:
> > >>>
> > >>>>> When memory cgroup is disabled, mem_cgroup_iter() always returns =
NULL.
> > >>>>> Therefore, the global shrinker shrink_worker() always takes the !=
memcg
> > >>>>> branch. After MAX_RECLAIM_RETRIES empty walks, the worker simply =
gives up,
> > >>>>> so it fails to write back anything.
> > >>>>>
> > >>>>> Therefore, when memory cgroup is disabled, fall through with the =
!memcg
> > >>>>> branch and shrink the root memcg directly.
> > >>>>>
> > >>>>> With memcg disabled, shrink_memcg() only returns -ENOENT when the=
 root
> > >>>>> LRU is empty, which means the total pages are already below thr. =
The
> > >>>>> loop then safely bails out via the zswap_total_pages() <=3D thr c=
heck.
> > >>>>> For any other return value from shrink_memcg(), the loop is guara=
nteed
> > >>>>> to terminate, either after MAX_RECLAIM_RETRIES failures or once t=
he
> > >>>>> threshold is met.
> > >>>>>
> > >>>>> Fixes: a65b0e7607cc ("zswap: make shrinking memcg-aware")
> > >>>>> Cc: stable@vger.kernel.org
> > >>>>> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > >>>>> Acked-by: Nhat Pham <nphamcs@gmail.com>
> > >>>>> Acked-by: Yosry Ahmed <yosry@kernel.org>
> > >>>>> Reported-by: Yosry Ahmed <yosry@kernel.org>
> > >>>>> Closes: https://lore.kernel.org/all/CAO9r8zPVzMKFbCixxD-qgtRrkFxW=
VrHiZZeLc=3DeyTPKPVQgX4g@mail.gmail.com
> > >>>>> Signed-off-by: Hao Jia <jiahao1@lixiang.com>
> > >>>>
> > >>>> Patch 2 doesn't really depend on this one, right?
> > >>>>
> > >>>> If that's the case I think this can (and should be) picked up
> > >>>> separately as a hotfix. Andrew, WDYT?
> > >>>
> > >>> Please update the changelog to clearly describe the userspace-visib=
le
> > >>> effects of the bug, thanks.
> > >>
> > >> I am not entirely sure if my understanding is correct here, but mayb=
e I
> > >> should add something like this to the commit message?
> > >>
> > >> When cgroup_disable=3Dmemory is used (or with CONFIG_MEMCG=3Dn), the=
 global
> > >> shrinker fails to write back any pages. Consequently, the zswap pool
> > >> fills up to its limit and rejects further storage, preventing memory
> > >> pressure from being offloaded to the backing swap device.
> > >
> > > I think you can simply write that zswap writeback when the limit is
> > > hit is broken when memcg is disabled.
> > Will do. Thanks!
> >
> > >
> > >>
> > >>> Also, AI review has flagged several possible issues, all appear to =
be
> > >>> serious:
> > >>>        https://sashiko.dev/#/patchset/20260714081510.16895-1-jiahao=
.kernel@gmail.com
> > >>
> > >> For AI review comments on this patch:
> > >> I suspect this scenario might only exist in theory. For zswap LRU to=
 be
> > >> empty while zswap_total_pages() > thr holds true, it would require a
> > >> prolonged state where there are always more than thr zswap entries o=
n
> > >> the zswap LRU whenever zswap_total_pages() > thr is evaluated, yet t=
he
> > >> zswap LRU happens to be empty during shrink_memcg(root_memcg).
> > >>
> > >> If we want to fix this, perhaps we could do something like this?
> > >>
> > >> Yosry, Nhat, what are your thoughts on this?
> > >
> > > Do we need to do this? The last paragraph in your changelog explains
> > > why this can't happen because zswap_total_pages() should be 0 in this
> > > case. Did I miss something?
> >
> > The loop would require the following sequence to repeat indefinitely:
> >
> > 1=E3=80=81zswap_total_pages() > thr evaluates to true.
> > 2=E3=80=81During shrink_memcg(root_memcg), the zswap LRU is concurrentl=
y drained
> > to empty.
> > 3=E3=80=81Before zswap_total_pages() > thr is evaluated again, the zswa=
p LRU is
> > heavily refilled such that zswap_total_pages() > thr holds true once mo=
re.
> >
> > For our case to manifest, it would require zswap_total_pages() and the
> > zswap LRU state to repeatedly hit this exact window with perfect
> > alignment over a **prolonged period**. Therefore, I suspect this
> > scenario might only exist in theory.
>
> Yeah seems very artificial indeed.
>
> If we want to be extra careful here, maybe we can put a cond_resched()
> there or replace the continue with goto resched or sth?

I think it's also possible with the current code with memcg enabled.
It's still possible that the shrinker puts usage under the acceptance
threshold and then a new zswap stores puts it back above the
threshold, and so on.

Perhaps as Nhat said, just goto resched instead of continue if we're
really worried, but I think even that is not really necessary.

I think we generally want to clean up and simplify the shrinking loop
in zswap_shrinker(), but I don't have any great ideas.

