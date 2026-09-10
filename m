Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B60DFC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 07:21:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BD626B0092; Thu, 10 Sep 2026 03:21:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86DA36B0093; Thu, 10 Sep 2026 03:21:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75C516B0095; Thu, 10 Sep 2026 03:21:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 486E76B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:21:19 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 292FB1A0474
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:21:17 +0000 (UTC)
X-FDA: 85197006594.14.81F77BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 51CC6180002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:21:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QJxcTEHK;
	spf=pass (imf06.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789024875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/dFIba0UKBKJ4gn1LNPP82s6h59rJBwzWCWOyhLQY4g=;
	b=sHZP1vNY3OIozL9r9bZWcCAibpKCcHIlHR6zmAGkW7dpDc2DZqLVmDeqVKtq+Ri4xcpGcv
	YNCYlrUthW3McXpbyJoXxAq13tCdsrk/nUa7Vbp0ZzaH1GG9EJid1+PV18emAHlOew2De7
	2P8UvHh/sbF8nu08ytwQm0ShMTYSEPc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QJxcTEHK;
	spf=pass (imf06.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789024875;
	b=j611hGePEuf4VnphlG5H73WSiGAqbcCEuo7rsM449h90l2CAA2MIrXRBCXi3AAYXb72wDj
	iD//K2OZSXe4OmcGF8bxq+pYbySIwetyccQtlygpv41SrTSV/VdOwfNPkipD+d+NoeKkVo
	+ewMTtv9DhZ6g6QMi2aRAOWTmQxu5Do=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9E5EF600D4
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:21:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C701F00893
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789024874;
	bh=/dFIba0UKBKJ4gn1LNPP82s6h59rJBwzWCWOyhLQY4g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QJxcTEHKFLozghTdiaMO+BwMGEDdIMoJyyY7FyJCPHK/r5++gbW0KN+cYt4OJGlim
	 5mwLFdwQLr9ttzut6GhAAMmICmQWwQL+Op1hb/bDakuJyMrgtvxRyyopjUnla691xC
	 cYod3ZkAhxML2oDkVPbBTV5azU/wYVoqia8rpd7xMbGVHkill2GNYWaV4VtukHHCps
	 bXU8w48cBTO3zTLZ6Py0ORGOhcib/d5dP9qGT/OL01xhI580ixM6eGnpzqo2HudbNG
	 TlXOLwxbOekgLOtB/kR+vcY2uPZajPdp+afsn9Hkmt1eb6FwFLWnXZG1tPa5DfktnE
	 XlKytfz8HlUSA==
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f705534so198090766b.2
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 00:21:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwxHjKP0OlTAsHeqTy2uBSC0Dl93Mkk2/skXrRW7cBL5K969I0H9UN8Z+Rmg8mLLJH0v7RARmpDtQ==@kvack.org
X-Gm-Message-State: AFuF++nY6Zo6vqf6+2WdgjpA+fU4+cs4mPiJkSGWKhgyPN9xjD+FllE3
	5gXwrKelnCIuKzJ+7a+aMWhNrGzvHrmrzCOGeYLWnvjhAH2aqp1x1cpEVDaEEz54hCyM6vEsTfY
	WiLbSQkZ7Mo3kR4PyLMuBTWsp8famZj4=
X-Received: by 2002:a17:907:398f:b0:c29:8d4:7c03 with SMTP id
 a640c23a62f3a-c2941ae802dmr260263266b.26.1789024873258; Thu, 10 Sep 2026
 00:21:13 -0700 (PDT)
MIME-Version: 1.0
References: <a8e16f7eb295e1843f8edaa1ae1c68325c54c896.1699104759.git.quic_charante@quicinc.com>
 <aphSYFTd12oia8K2@google.com> <apkhSHr3by5Bf8jW@tiehlicka>
 <CAO9r8zPCYNmJbkQEA62z75AB=ziWqGb38_E-ee_6o40Sz=zHXA@mail.gmail.com>
 <apqppFukssaAQz3w@tiehlicka> <CAO9r8zMBBhhqepbLR9buOOu7bpyLW+UTu55DjbCYrbBp56rkCw@mail.gmail.com>
 <aprxXHSh-LyqaFCW@tiehlicka> <CAO9r8zO93CMjJHLO1ZqHY0Tr2kDfvpMHfH3MLkR37vV0YROf_g@mail.gmail.com>
 <ap5nJm1mH-4nfLaY@tiehlicka> <CAO9r8zOaAGHXK6FZ0PM9sJL2zH4fQe5kh+W2TBNL90YZV2detQ@mail.gmail.com>
 <aqEMagbMGPlkuP2P@tiehlicka>
In-Reply-To: <aqEMagbMGPlkuP2P@tiehlicka>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 10 Sep 2026 00:21:01 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOzmYcovBBu_nXWJ8KPJGSDt9m6c-hxrZh_RQQGjsH8-g@mail.gmail.com>
X-Gm-Features: AcwNN1X0EJVzF0_77D2TNUNM6pwnCOqj1KrbslWUtbIqpVum1N7ZVyfgG1B1rEg
Message-ID: <CAO9r8zOzmYcovBBu_nXWJ8KPJGSDt9m6c-hxrZh_RQQGjsH8-g@mail.gmail.com>
Subject: Re: [PATCH V3 3/3] mm: page_alloc: drain pcp lists before oom kill
To: Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, mgorman@techsingularity.net, david@redhat.com, 
	vbabka@suse.cz, hannes@cmpxchg.org, quic_pkondeti@quicinc.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 51CC6180002
X-Stat-Signature: hzfnktjh7moathgkxw89xfcmr3x15uy9
X-Rspam-User: 
X-HE-Tag: 1789024875-738868
X-HE-Meta: U2FsdGVkX19SM9vUI710NPmZC7HzPWCb74raNYgwPifK41241+2NZKHKikNb3M4sZ3MTF72GdRaDPukGt+jjneqh3wXDsqVuZa4PQq0Kg9E6R/CdzjRFdRLT3611IyINIfnkr8XG2jwz0bek+B9By7xeLv2Qj82LP4TgMBbMBR2jW9QsGbMPwOLIxa4vdEH9mEH2Enwsg6Wynu3fGsVRNCMAFhmkobcBBDgUxjfsIAMcC8iqyNVsr5T/GIyKg4kZDyEJVDODZ7A3kpFlWK/94xnXBW3rCA3EceBPP2fSeONSl1xjEKI+02mPKCsSHUgrxiq2dWMLOzycji8Sui12m19EQjj8SoNmsE6GCHNiICqPgbjkBLR7I6/AZipj1napxoj75Zx31mGW3V+4GIMmvQ/i6Z07egkcZ7NmjFSbH9Q/THLD9YJtpnosRpzjXZLiwHlBrlfZ1Gcz3gXEm9vUHJIXTrbj8433pemUoiG0AqbCOzo2PPBN/Prf2zhLUdw/ga/noroHh1P4Q/uuv2cwxO8rExiIWfIIvFvwSA5PU7bqgWGF2/oXrm6VUG022SqiwwkKWkcnrrIXYObtzOGbBoa2g5TA10dcJ4uVHxNQ5t72BKyycNsZP5DuK+PhJHcIEwGBI207oKuQKw2FEj0WAERpR/9Pa+gS+zxHecFbQf8wdX3n6YuphG0ETUJe9mxazx/BnoEsEiuUtFpA/E6n7G9kulLTwqGjLVU6h/NPwDVPkhYWsApOz2QwHdUwtb+WGO3R5zW8jbLin0IWE2JYOAWhwa3mlMbOpfuycvnl1FuZ0o9RYb8+ODXLoMyv4S+56+xETHOY93y3Ghu+N05ziLLQPgWwVM47eWYod1fKprRWYxYFRE7bWHcTBBsVl8vzT1RWDsHwIjXEQ1tpJqLCw04scBNfXioWAMxqnFv22YvHE4s1f6RJd2przMdlaE2etjsv0uiChd0sgYl0l6N
 ROr4+n0C
 OdjQsTuivemF5k7daXQwUtRQlRdL9GyMR2o5flq9fLNztETzWCNjJ2TRo85GUGISL+ku37q7viSvx/pwjC9M4Lexim/OMV7ZzN0YCIl1yPW8Vngqa0DF2hcuk33XQ2PBBC6nElPW48fGEOl3up1fe44sOZbGEFOD3KgAWf40vQl85dkBrFdkAg4utkyNCB6C9WP646LHi4xBuJUVBAsnMtfOJa0fX4fwE3hG9E/JCf0JnX1PKWhOfVgRQe7SWKkULzxkx9Q3EyYjaYyfhMYuWs2aaIDmeNEB1u9WzjWe/Ax0aWfIqkbUfHUGQpTz4QCvuPPjpVe15CMKdYmSDEi31AojtmMz7Z1SGflmY+cFblZdgPCCYVNiEjjQJmb9GnCamjFxS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 9, 2026 at 12:36=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Mon 07-09-26 01:49:39, Yosry Ahmed wrote:
> > On Mon, Sep 7, 2026 at 12:26=E2=80=AFAM Michal Hocko <mhocko@suse.com> =
wrote:
> > >
> > > On Fri 04-09-26 09:35:55, Yosry Ahmed wrote:
> > > > On Fri, Sep 4, 2026 at 9:27=E2=80=AFAM Michal Hocko <mhocko@suse.co=
m> wrote:
> > > [...]
> > > > > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > > > > index 8d79f76cdd0e1..98e9079240ad5 100644
> > > > > > --- a/mm/page_alloc.c
> > > > > > +++ b/mm/page_alloc.c
> > > > > > @@ -4592,11 +4592,12 @@ __alloc_pages_direct_reclaim(gfp_t gfp_=
mask,
> > > > > > unsigned int order,
> > > > > >         psi_memstall_enter(&pflags);
> > > > > >         *did_some_progress =3D __perform_reclaim(gfp_mask, orde=
r, ac);
> > > > > >         if (unlikely(!(*did_some_progress)))
> > > > > > -               goto out;
> > > > > > +               goto drain;
> > > > > >
> > > > > >  retry:
> > > > > >         page =3D get_page_from_freelist(gfp_mask, order, alloc_=
flags, ac);
> > > > > >
> > > > > > +drain:
> > > > > >         /*
> > > > > >          * If an allocation failed after direct reclaim, it cou=
ld be because
> > > > > >          * pages are pinned on the per-cpu lists or in high all=
oc reserves.
> > > > > > @@ -4608,7 +4609,6 @@ __alloc_pages_direct_reclaim(gfp_t gfp_ma=
sk,
> > > > > > unsigned int order,
> > > > > >                 drained =3D true;
> > > > > >                 goto retry;
> > > > > >         }
> > > > > > -out:
> > > > > >         psi_memstall_leave(&pflags);
> > > > >
> > > > > Ideally if we can make the function call less hairy. Maybe we wan=
t to
> > > > > make draining part of the reclaim as the last resort when normal =
reclaim
> > > > > fails.
> > > >
> > > > Do you mean do the draining in __perform_reclaim(), or deeper into =
the
> > > > reclaim stack?
> > > >
> > > > The thing is that __alloc_pages_direct_reclaim() currently drains w=
hen
> > > > __perform_reclaim() fails to make any progress and we still cannot
> > > > allocate. The change above makes it drain if it cannot allocate aft=
er
> > > > __perform_reclaim(), regardless of progress. So if you want to move=
 it
> > > > into __perform_reclaim(), we'll have it in both places.
> > > >
> > > > Or maybe I just don't understand what you meant :)
> > >
> > > Sorry for not being clear enough. I meant to pull draining out of
> > > __alloc_pages_direct_reclaim and instead have it somewhere in the
> > > reclaim path. It is not entirely clear to me  where at the moment but=
 we
> > > do not need to have the same behavior as now. The idea behind the cod=
e
> > > is to not drain way too much. Maybe we want to drain when dropping th=
e
> > > priority down to 0.
> >
> > If we want to maintain the current behavior of only doing this for
> > direct reclaim (not kswapd, cgroup reclaim, or proactive reclaim),
> > then I was going to suggest adding it to do_try_to_free_pages().
> > However, we bail before priority reaches 0 if we are able to make
> > progress or compaction is ready.
> >
> > Also, I think in do_try_to_free_pages() we don't have enough context
> > to decide if we need to drain the pcplists. Looking at the comment in
> > __alloc_pages_direct_reclaim(), we specifically drain the pcplists if
> > the allocation fails after reclaim makes progress to make sure all
> > reclaimed pages (e.g. in other CPUs' pcplists) are made available to
> > the allocation. So I think it fits better in the allocation path, so
> > that we only drain if we cannot allocate after direct reclaim.
> >
> > I think the main issue is that we only drain today if we know direct
> > reclaim made progress, so it potentially freed some pages to pcplists.
> > However, it is possible that reclaim did not make progress but there
> > were already pages on the pcplists (e.g. freed concurrently or were
> > already there). I don't think the right place to do this is reclaim
> > path.
> >
> > I personally think either Charan's original patch (draining in
> > should_reclaim_retry()), or the diff I proposed upthread (draining in
> > __alloc_pages_direct_reclaim()) are probably the best places. Please
> > let me know if you still disagree.
>
> In that case should_reclaim_retry seems a better fitting fix.
> Thanks!

Thanks. I will rebase and resend Charan's patch.

