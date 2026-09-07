Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 172AFC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:49:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED7426B0098; Mon,  7 Sep 2026 04:49:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E87616B009D; Mon,  7 Sep 2026 04:49:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC47E6B009F; Mon,  7 Sep 2026 04:49:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE41F6B0098
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:49:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 25DC6140690
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:49:55 +0000 (UTC)
X-FDA: 85186343550.09.588B479
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2B8891C0008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:49:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cSKohq6K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788770993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kKgJ49C47SmCceaSKnyRvbwxPYyWkP7guI7246QP9D0=;
	b=VBWghuxcMnZdHZuMJ1JT5MzWYl7fiSdFdMPzKu+8JZymnjgvny0v2hKayvs5WXIMUZwpKm
	BMRnvCwm+0c1t+4ct34EgNjnd/b12s3Qwo9dh9NG1hpDN1c+GN+NmprTo7m+I0iwIKj5x5
	+22vMwxYeaLfluzK+YMsrmWn7wMKHJY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cSKohq6K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788770993;
	b=kBAR67EvULQinV1ukl3CvduCy7wIghdnhVrNenZ4AwI2DyMWj+vejEVoBt2KH5kr9wu/G4
	3aUHKMeKHWbIzCSYDICyQWPx5AC1VRtcEb3B2Z+K0eqL4syQUIa+QH2tlTRYP18/muKY7V
	Li3D4grm7mTI5rYmBiqIwFmFEWnPtoI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0DD4841881
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0CB61F00ADB
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788770991;
	bh=kKgJ49C47SmCceaSKnyRvbwxPYyWkP7guI7246QP9D0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cSKohq6KLTUqDc4/QivFhks0smK6aqb1q8vcXcCLg8XEfhBhGByoY5GDnt8rWakEw
	 HgJdReiol/vttE3r1w4pWsCtV+F56vGeaH8qEzlyu0WkNBmne2chdeutLiPEfHwsn9
	 9AcM2iG8tVFY8B1+6Qlpdu011ZxcX5X3Jl0mEsdd1ilHgF4uXjrL742fxRRuZRLYSh
	 mFxQt8rZRnhtKCl8GlosCSltqLCXirgkQRDlVyQCBR0+bPGyHdVHfqtoLbEzPkWMkE
	 pqfDJ9HaLB/aos5QCX2LCN/TcTPRujcSa7/bd+1ynBVFGS5CdKVCKAFPbAiXLUm38b
	 KzeDKpo5le4ug==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c2637dd37c1so176492266b.0
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 01:49:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByWeE1rucyo1/neamjrrXtIFL8JJsZATNQe5cF46f9ghN+nPM/acQLQGhY3F0nMzqKmOODAhiG0CQ==@kvack.org
X-Gm-Message-State: AFuF++mRwXwZIMDGeGuss0Pap5i+SGMTRFXP/CiDwEss7UDlvac+crtO
	j6kIEoedTjyh/WUmpJK7zHPFBaxwuKjBfkTKYCFpyZnvwS1bgg7iTIOgk5INzzR+BVMPxWoXeLD
	RTZALmgfFyJsqkmvZY4zysMUpzetd2aI=
X-Received: by 2002:a17:907:970b:b0:c26:1649:47a9 with SMTP id
 a640c23a62f3a-c26164956c6mr640895966b.31.1788770990740; Mon, 07 Sep 2026
 01:49:50 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1699104759.git.quic_charante@quicinc.com>
 <a8e16f7eb295e1843f8edaa1ae1c68325c54c896.1699104759.git.quic_charante@quicinc.com>
 <aphSYFTd12oia8K2@google.com> <apkhSHr3by5Bf8jW@tiehlicka>
 <CAO9r8zPCYNmJbkQEA62z75AB=ziWqGb38_E-ee_6o40Sz=zHXA@mail.gmail.com>
 <apqppFukssaAQz3w@tiehlicka> <CAO9r8zMBBhhqepbLR9buOOu7bpyLW+UTu55DjbCYrbBp56rkCw@mail.gmail.com>
 <aprxXHSh-LyqaFCW@tiehlicka> <CAO9r8zO93CMjJHLO1ZqHY0Tr2kDfvpMHfH3MLkR37vV0YROf_g@mail.gmail.com>
 <ap5nJm1mH-4nfLaY@tiehlicka>
In-Reply-To: <ap5nJm1mH-4nfLaY@tiehlicka>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 7 Sep 2026 01:49:39 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOaAGHXK6FZ0PM9sJL2zH4fQe5kh+W2TBNL90YZV2detQ@mail.gmail.com>
X-Gm-Features: AcwNN1Xa3QoSN2YWlMq10SWa69-3_5olJKFYqC41i2JxEfQV3MbKhUFRG6jO7dk
Message-ID: <CAO9r8zOaAGHXK6FZ0PM9sJL2zH4fQe5kh+W2TBNL90YZV2detQ@mail.gmail.com>
Subject: Re: [PATCH V3 3/3] mm: page_alloc: drain pcp lists before oom kill
To: Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, mgorman@techsingularity.net, david@redhat.com, 
	vbabka@suse.cz, hannes@cmpxchg.org, quic_pkondeti@quicinc.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ncf3een4iw5t5nmqhsdjycigq4n19y34
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2B8891C0008
X-Rspam-User: 
X-HE-Tag: 1788770993-421942
X-HE-Meta: U2FsdGVkX1/d2SEMQGpnrmq3PDDA3PDJ00JZVmGvP4lTckSQCsBROrzBGUDfsEpPXOLc/Bqnux2ZmqUL82nZUJtx10ssTiJZ6T+MoS2neHKuGqGiH9re+dRUHXJrWK4QuQkYSzx53JO+6LkKsNd/dqiIalmxCuKNvcf0VYB4olUTKm0BblX+oMZ2IO1ki7e4mECrctydGX0D6IFBkva55uV5AUp4l8ejE3qMcD/D1KgKeenEGq0RFhAUDrFx3/rde3Dyuod7kWdggR7v9bpm7WcpltsXlFejtTtZemp370TkWwFsowuhdy6ei4TFIJ/gYrHIEwgMZATeonw0eI2zV603FzROra26wYe3SSJEgbpSatkmkGOEFLZzmaUOXiwAlD+5IGBb16QEBCdptz7+Xn8KK620OI22qYoS3agAOpaZtNXb46ToZCL1gitDR+3hon/dfaMncKFr51+RmcxjCNEzmN23hMlJHuZmsYLroOUnlOk+BD3pbRfRl/0bFsOaogqBdx9QFHuTOciaoSDEmw591kM7FjUsA99WYcg173iX33HXWbj4dsQbBHRfVWntmLlOCxah2suVhGxPcAO1o1gfGYFPhRxkM+fxo+lL14m2+AOEUuvsFap8R1Nz+IPEod6y7U4vdTECbTcgK/Z4V0jOJick0Im5UaVcs2FbQzBX0ILvoHDANdWuSxo8t2Wfc5bpvxkIXliGFvcqyUDB232sEgCKitx8RQSHdL45brvjZgPgepCZzZ4bPXq8+ic+SiMoG+IPkYfZMLQTWLHnEp8rj7d2XPHKxlIYZFyIxCEoUxJEbpLAMqF+k1+JYV8atInxUarlEHgN58brItavoUQhyaLmGx1Ldgjy3OXE/L5mPkPv8rfXqQ56JxFjujhKDevq4VNo2jYE+YqDGqSpj8A3QnNWFXLXLfVag/3Ve53MyKY144BGAfbZGPfoKqTQWHmymNxODsgWu1ci+Nu
 JoqNTgXR
 bc85pWUqtczek4J3oubZoQ4yRlKq2TDQ2x9N8oEMuzOa3qXi8mwZao3pvKs9TQh5DHtm/Vz2sLao91TRWW7ARNX65tAU49wg6I3iSLl1LTeTnIdbaP/J8y7w4Co47jUeaAo1ULow4Odi3memzLExm1zrY0U6n3UqI/nZNWbYQDkw4HLbAq6geLdE9avmjtEiXek29D9wh1F4C1VrzEXDCQRREE6JbL9GbmTBfVjopoqHUlsPm4WH9i7yuXSc1ub7uow7vvlLOuoHhP3BvE16C+ylLiODylDayeTguO7Rg6EkU8otLUy249dU7wrZPQgjGNvo+i7oAAFXs+uWOIt+o8jhhqTp9HjAdorDrkA/zAyzH9i6wFSXqtX0TX6hWxY9h+r1mBQPzHCVXOlE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 7, 2026 at 12:26=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Fri 04-09-26 09:35:55, Yosry Ahmed wrote:
> > On Fri, Sep 4, 2026 at 9:27=E2=80=AFAM Michal Hocko <mhocko@suse.com> w=
rote:
> [...]
> > > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > > index 8d79f76cdd0e1..98e9079240ad5 100644
> > > > --- a/mm/page_alloc.c
> > > > +++ b/mm/page_alloc.c
> > > > @@ -4592,11 +4592,12 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask=
,
> > > > unsigned int order,
> > > >         psi_memstall_enter(&pflags);
> > > >         *did_some_progress =3D __perform_reclaim(gfp_mask, order, a=
c);
> > > >         if (unlikely(!(*did_some_progress)))
> > > > -               goto out;
> > > > +               goto drain;
> > > >
> > > >  retry:
> > > >         page =3D get_page_from_freelist(gfp_mask, order, alloc_flag=
s, ac);
> > > >
> > > > +drain:
> > > >         /*
> > > >          * If an allocation failed after direct reclaim, it could b=
e because
> > > >          * pages are pinned on the per-cpu lists or in high alloc r=
eserves.
> > > > @@ -4608,7 +4609,6 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask,
> > > > unsigned int order,
> > > >                 drained =3D true;
> > > >                 goto retry;
> > > >         }
> > > > -out:
> > > >         psi_memstall_leave(&pflags);
> > >
> > > Ideally if we can make the function call less hairy. Maybe we want to
> > > make draining part of the reclaim as the last resort when normal recl=
aim
> > > fails.
> >
> > Do you mean do the draining in __perform_reclaim(), or deeper into the
> > reclaim stack?
> >
> > The thing is that __alloc_pages_direct_reclaim() currently drains when
> > __perform_reclaim() fails to make any progress and we still cannot
> > allocate. The change above makes it drain if it cannot allocate after
> > __perform_reclaim(), regardless of progress. So if you want to move it
> > into __perform_reclaim(), we'll have it in both places.
> >
> > Or maybe I just don't understand what you meant :)
>
> Sorry for not being clear enough. I meant to pull draining out of
> __alloc_pages_direct_reclaim and instead have it somewhere in the
> reclaim path. It is not entirely clear to me  where at the moment but we
> do not need to have the same behavior as now. The idea behind the code
> is to not drain way too much. Maybe we want to drain when dropping the
> priority down to 0.

If we want to maintain the current behavior of only doing this for
direct reclaim (not kswapd, cgroup reclaim, or proactive reclaim),
then I was going to suggest adding it to do_try_to_free_pages().
However, we bail before priority reaches 0 if we are able to make
progress or compaction is ready.

Also, I think in do_try_to_free_pages() we don't have enough context
to decide if we need to drain the pcplists. Looking at the comment in
__alloc_pages_direct_reclaim(), we specifically drain the pcplists if
the allocation fails after reclaim makes progress to make sure all
reclaimed pages (e.g. in other CPUs' pcplists) are made available to
the allocation. So I think it fits better in the allocation path, so
that we only drain if we cannot allocate after direct reclaim.

I think the main issue is that we only drain today if we know direct
reclaim made progress, so it potentially freed some pages to pcplists.
However, it is possible that reclaim did not make progress but there
were already pages on the pcplists (e.g. freed concurrently or were
already there). I don't think the right place to do this is reclaim
path.

I personally think either Charan's original patch (draining in
should_reclaim_retry()), or the diff I proposed upthread (draining in
__alloc_pages_direct_reclaim()) are probably the best places. Please
let me know if you still disagree.

>
> --
> Michal Hocko
> SUSE Labs

