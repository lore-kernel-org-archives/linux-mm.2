Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 199C8C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 22:35:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F332D6B007B; Mon, 27 Jul 2026 18:35:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE3886B0088; Mon, 27 Jul 2026 18:35:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFA696B008A; Mon, 27 Jul 2026 18:35:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B30F36B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:35:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 40F5A1C034A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 22:35:36 +0000 (UTC)
X-FDA: 85036014672.05.AFC8735
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4253A20007
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 22:35:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kUa1WMUB;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785191734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kWV04HahRy/fEroyJSCEO9dnawXg+CZuFo5RS/IDhZE=;
	b=42Y1lAUblbiWyJ5oLK3GE0vjg1dofZWDBFG+IkzTeG5vftLp6zseCXdY7Iz8IcysaDUSA6
	EfZfWpqG2xDcpSniOQBHcmnnTrL1f2PWZEKY5uu7WzIr88/HAbj1ctATMWrquHP7l3JvCg
	JPTev4vi448EoxeLHtge76tE/4oAYEQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785191734;
	b=ZGVy4Sw5Twerd9iRybE6QB6GmkcsiZs/B5gGzolT4dQipfcCmwpI8y8/qYeqZbLMNrcTjg
	mtan8xwKfao2XNJV6ofiBHqQVeCy9O8es8QuIIqtTDpj4N5C0xwRs1fDv/HFXgSPqXdYC4
	WrF5cMTBatpRt9m9/oYY5HMLt4JcuZs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kUa1WMUB;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 276D4436B6
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 22:35:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B72C1F00A3E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 22:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785191733;
	bh=kWV04HahRy/fEroyJSCEO9dnawXg+CZuFo5RS/IDhZE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=kUa1WMUBL7mTlPaqxPwIBjG9dp9War9+oR8G3vzcy7BWHcDraYUitKcVMvhiHZc9q
	 KVYNwNkkPMAUmM7wesgHBwRADA4BfryoyEV0ozZmiK24+QN61aT0Dx5VQPEBqFEpSS
	 67MuQvavjyyydouoV/f0B6y8PUmk14QlbeK667g/vjmoJebIdQV1TAPiPeEaMfFYz5
	 /uhnHHv50wvDVKySPH4Lt69aPt1goCF3/U98E0AlteTREp+fuB+JQO+5/jU9svEdxk
	 N1QI47O8C6ytSTInadk3vA0cSnPdyokzCh0Umt17iSF4lRV1LkRth1Zi9OUMl51Ae5
	 xPcQu57E7L+sg==
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c149c5722so3100131cf.0
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:35:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rr0YUXw1Dsh4IDOjbCnb7gHKdhf47JLpbiqnco9a21TBTRNqzguJfbLbhK46WWdipudPKQ2aG7D+A==@kvack.org
X-Gm-Message-State: AOJu0Yycwz5Vle+hj+HMy37F4JYcYCj9wG+aY5d9KvAQn+f7xUIrAOBZ
	xP0vnqAUV1Zwiwjr/qC1tQ6GHooIECnGygPVP6VctD0FU12A6ULfpnLUgh29BZjtoD5ldal/weF
	SJTWy3c7/dvF1Gcei3+gvrR9bpCgvuNU=
X-Received: by 2002:a05:622a:2508:b0:51c:8556:55f0 with SMTP id
 d75a77b69052e-529d4204a1cmr6100971cf.34.1785191732370; Mon, 27 Jul 2026
 15:35:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260724033435.2573323-1-ridong.chen@linux.dev>
 <20260724033435.2573323-2-ridong.chen@linux.dev> <amdC_-OvG1ZUjmot@tiehlicka>
In-Reply-To: <amdC_-OvG1ZUjmot@tiehlicka>
From: Barry Song <baohua@kernel.org>
Date: Tue, 28 Jul 2026 06:35:20 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w1AFkKOSCZYwRsZYOBxCq_7CQA43jQOiDUyLrjVUmA-w@mail.gmail.com>
X-Gm-Features: AUfX_mwtR0p0V3HPUlu2cYxiVEBNGt1vNSiWFgHZceFi82DzUI-JiOE9QjKUFCA
Message-ID: <CAGsJ_4w1AFkKOSCZYwRsZYOBxCq_7CQA43jQOiDUyLrjVUmA-w@mail.gmail.com>
Subject: Re: [PATCH -v4 1/4] mm/vmscan: fix anon-only reclaim evicting file
 pages when swappiness=max
To: Michal Hocko <mhocko@suse.com>
Cc: Ridong <ridong.chen@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Zhongkun He <hezhongkun.hzk@bytedance.com>, Muchun Song <muchun.song@linux.dev>, 
	Davidlohr Bueso <dave@stgolabs.net>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: xbbf8oh5ey4eaqyzx84majw69w3gbn43
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4253A20007
X-HE-Tag: 1785191734-534669
X-HE-Meta: U2FsdGVkX18Lzr7MWhDH8nsOu+U6rKpTEPYShpElXDeQOIMDi9GmV57KmkmgO/AB0BHjh6p6nVsc066m4dg9XjDaTldiysfRCWL2fEcs5VZ2aP6HtpB+VUS76KSQpH3f0/JSBfd7cN5ZHzHWPlKrAFH92V48ef7hnZcqBWy0I2eDZ8BBsLxQf8eLcUU36VUTOSixDfljbjOfIdK/A6jKPpaLMPFH2WrAfaq6sHJRSdPDv21kM05TV0w5RHDaS5wE2gKJG3PORLF5nbx1NqxnRTY85/T980yum/us266+DLQuSCjeFPcEbbbHW6chc/iXa4fLrZPUxd8DRH4KPhUQDHfWI+FO9z//2HeFa62PelyOPu8PZy+OaBxhlRIE/rTq9ll6JnAhkQrsVvhgaVWGAfkF1f8ybb6TfvQy4UshIudOOZxYVFwR/EmEUpGX2VmOQo374fMO68+LYSzAHJ2dGchl28NTM98C+7ERdViHJUC0SiHEzL27tFneWDelln4F8T/gaF6e9XcGsOniWcMHR3D6qBods1NGJ/RbZ/bQwKu89Sl96ppR++FLoPf4i0CtcJFFSRPWBRgznPRJjeFnRzDvidYraJttuPN+kpdAWIdm3SZUrZD+J3nCOx3NGz3mH2HOt8N+tNVy8YJR8P/4X0gtJU9gWHfhLmI6uZsHO67FnyN2/4vfr4vCimFE++Oz2kUUQkEKGujAeQ9sg2BpF5hbnv8jyEsF5jBTOtZEwTe2ymMpIzhgoAJosKJ6ddW9fGTpuYaFxIY0eyE3oeFhix50hz6Vegw5uPFwKB0p5LMhVYgR99rQ/SwPbSbae8igN7138Dfr9ge27kjlO56v198Z/neLLwt5Eonamj9ilUsq77Ix6r6CeqkHWJ5E/rM5dZwUmwNJHwpYo1P1nw2zmzOFuWLYP9mbV9XYXO6RmiNLQRljj70HOXOkojSGAveakRiUeaKKjQaYmek57A/
 IKBrtOm9
 sBmKXoCdOyT2OAy3AJzoPqEeEmQjK3ikCuBn8l6s6CCiG+SxP39swMYNEsRqmmOE0ZpMdGRB7kG3dFIy0xFH3tMXMpVS4zaZdR6Knuuyl5L4R4KvVRwGm5A4Z7uJnKGUoFb/2fwgSugVHEeJfbqFU9ceqgyingCLjZQ84zf5CfIBKr3z27A4NWIPu8c0eUxq/qvj4D+wK5rBVolnoYwswUZKzOIjbtNRVZJqnzBwnrh57V92R+bdjj4hgCYzdfImdOF5x2V2n2tFtvtFuN94vFDWBy6Ud0LHm2f6A6JN8XceBvQJcu6nj2HCrJOuscg0xPDOouO3i8XUaY+XleyLeN3Yg4Ojy/Q43ZTG2gTfSeekon+Li0xNPhWhaZEJ5r08ErO5E9rqg2oBk0VfI0BPhmGTJqHq3OE+DWusB1WLsjH//TLkVcDNPVHnRYqqNuG0BUzTR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 7:37=E2=80=AFPM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Fri 24-07-26 11:34:32, Ridong wrote:
> > From: Ridong Chen <chenridong@xiaomi.com>
> >
> > As Qi mentioned [1], when swappiness=3Dmax (SWAPPINESS_ANON_ONLY) is se=
t,
> > the reclaim logic is expected to reclaim anonymous pages exclusively.
> > However, due to the current ordering of checks in get_scan_count(),
> > file pages may still be evicted if can_reclaim_anon_pages() returns
> > false, which contradicts the semantics of SWAPPINESS_ANON_ONLY.
> >
> > Reproducer in a cgroup holding 64M of file cache, with no swap configur=
ed:
> >
> >   Before (file cache is wrongly evicted):
> >     # cat memory.stat
> >     anon 196608
> >     file 67178496
> >     pgscan_proactive 0
> >     # echo "64M swappiness=3Dmax" > memory.reclaim
> >     # cat memory.stat
> >     anon 208896
> >     file 4096                 <- page cache evicted
> >     pgsteal_proactive 16400
> >     pgscan_proactive 16400
> >
> >   After (file cache is left intact):
> >     # cat memory.stat
> >     anon 200704
> >     file 67178496
> >     pgscan_proactive 0
> >     # echo "64M swappiness=3Dmax" > memory.reclaim
> >     -bash: echo: write error: Resource temporarily unavailable
> >     # cat memory.stat
> >     anon 208896
> >     file 67178496             <- page cache untouched
> >     pgsteal_proactive 0
> >     pgscan_proactive 0
> >
> > Fix this by bailing out early when SWAPPINESS_ANON_ONLY is set and no
> > anonymous pages are reclaimable, before falling back to file reclaim.
> >
> > [1] https://lore.kernel.org/cgroups/7ddf3eee-5fe2-45f7-8614-c8936a039e0=
4@linux.dev/
> >
> > Fixes: 68a1436bde00 ("mm: add swappiness=3Dmax arg to memory.reclaim fo=
r only anon reclaim")
> > Suggested-by: Qi Zheng <qi.zheng@linux.dev>
> > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> > Reviewed-by: Muchun Song <muchun.song@linux.dev>
> > Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
> > Reviewed-by: Barry Song <baohua@kernel.org>
> > Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> > ---
> >  mm/vmscan.c | 24 +++++++++++++++++-------
> >  1 file changed, 17 insertions(+), 7 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 35c3bb15ae96..2c689682b952 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -2501,6 +2501,23 @@ static void get_scan_count(struct lruvec *lruvec=
, struct scan_control *sc,
> >       enum scan_balance scan_balance;
> >       enum lru_list lru;
> >
> > +     /*
> > +      * Proactive reclaim initiated by userspace for anonymous memory =
only.
> > +      * SWAPPINESS_ANON_ONLY is set only on the proactive reclaim path=
, so
> > +      * warn if it shows up elsewhere. When anon cannot be reclaimed (=
e.g.
> > +      * no swap), bail out instead of falling back to evicting file pa=
ges,
> > +      * which would violate the anon-only semantics.
> > +      */
> > +     if (swappiness =3D=3D SWAPPINESS_ANON_ONLY) {
> > +             WARN_ON_ONCE(!sc->proactive);
> > +             if (!can_reclaim_anon_pages(memcg, pgdat->node_id, sc)) {
> > +                     memset(nr, 0, sizeof(*nr) * NR_LRU_LISTS);
> > +                     return;
> > +             }
> > +             scan_balance =3D SCAN_ANON;
> > +             goto out;
>
> Rather than warning the code would be easier to understand
> (SWAPPINESS_ANON_ONLY implying sc->proactive is very subtle assumption
> that might change in the future) I would go with and explicit check.
>
> Looking at how the code is structured currently doesn't the following
> express the intention slightly better?
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 35c3bb15ae96..4fd38e3f1b05 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2503,6 +2503,10 @@ static void get_scan_count(struct lruvec *lruvec, =
struct scan_control *sc,
>
>         /* If we have no swap space, do not bother scanning anon folios. =
*/
>         if (!sc->may_swap || !can_reclaim_anon_pages(memcg, pgdat->node_i=
d, sc)) {
> +               if (swappiness =3D=3D SWAPPINESS_ANON_ONLY && sc->proacti=
ve) {
> +                       memset(nr, 0, sizeof(*nr) * NR_LRU_LISTS);
> +                       return;
> +               }
>                 scan_balance =3D SCAN_FILE;

The question is whether we should allow falling back to SCAN_FILE
when swappiness =3D=3D SWAPPINESS_ANON_ONLY and !sc->proactive, if 201 is
ever allowed for non-proactive reclaim in the future. I guess not,
since SWAPPINESS_ANON_ONLY literally means reclaiming anonymous
memory only?

