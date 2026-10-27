Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B445D606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 17:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=NidW6MgV
Received: by kanga.kvack.org (Postfix)
	id AF6CB6B085C; Tue, 27 Oct 2026 13:28:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA76B6B085D; Tue, 27 Oct 2026 13:28:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96EFE6B085E; Tue, 27 Oct 2026 13:28:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 67E486B085C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:28:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C0D94120AEC
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:28:38 +0000 (UTC)
X-FDA: 85369090716.19.AA0421D
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id BAE2920009
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:28:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=NidW6MgV;
	spf=pass (imf13.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793122116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MWyXscpgq0mKENbth6U6G8hO/Fpg0qBlfyz578FuBms=;
	b=02NPU43tW4tpd17jFDeLpVZ1Oo4oEtJrPAiN6Asell/0AVMbQdYTvx9bKzEagEPQ6gLBov
	LjUDAIAVj6Z0/+Uj5qsu5LzWVGzW0l1B4CA/i9FzpRptxTNf+xv8EzVzQ1fzujMG+ZqcEJ
	BbUV5iuLUo469kAOgREcuq2zhTycs0w=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793122116;
	b=wN3f4NvrVWiH0IsVY82I4uU9hhr8MYK2lo/1LewgmoRzYSu2wSYoFdu4L0zf5XStJmxj8U
	nVWs2UjV46N+tU73qiugGw02GpRJUbG4oPKkcQR97WTdAm07BWNcPc/KYdTiP0etjV9l7H
	OvSQIWdDx/3anJAD4ttcPIAOPoy6kwU=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=NidW6MgV;
	spf=pass (imf13.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a206f0b95bso4135e9.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:28:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793122115; cv=none;
        d=google.com; s=arc-20260327;
        b=WmYDUYHSLpduBB4slTPECoqfIr5fNEDcEnAf759LjGsoN4/dy1rUyZcGYNWGQhYSaX
         m5UpHWFXG6IrasBOI+AK+g78eT6bZvu1DBqwTxlzsTbXIugZoItGPCt9ddNnY7F1iZz7
         8y30mDbspUrhJmbs4wR7m0+wRZnaZzGk/fJxW3M34MzRMWr5oOLSW9UaiJkGZ8YGkpeC
         0C5Y0/P3kJ6o9E+oJzSHA1E4/l3mmOLVU9fuEgdEp1xchIZjAi9X3nd6h9SalMUkKYp7
         4kWssXA8HFmrVbU+mvh7KzT8TF81gbAngyN50B6dGt1qZfGjjkDmfIv9bLc4s8fbu7fh
         DKHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MWyXscpgq0mKENbth6U6G8hO/Fpg0qBlfyz578FuBms=;
        fh=kQd5WhsOnOHmy48bm2ILdrm+TRNgWL9PnNyEFRe1L4c=;
        b=ocbNlDKsO5dy6gBd7PIL7s44CGW6uIJfck+D8R1SUYWbjP3Y5Q3UrwPL4Ib10Od2kR
         8N+hhRnMgjdpt4iegq8GdQwwkAilcxHyt9OcMAIv5MEKB0fdCCWKcD6fv9TE8pRUVjH9
         wC7N20i8lqG06Vx6Uc3hEKGfu9v1Hy87KrEs8KzGx7LR8RkX4g9YpVZY2hTt8RKisaIH
         lBh2xTeu84+LhwM8tqOVk+vaGl32dghFYip8PAuS1FJmttS6CD7+PVEO7t6YkPXejLp/
         1Cnj7k9z50P6WzK6l7ZQObpqESUk8zDZXHK3jMZqIaFSDF2tpavK+aA8f00wZPhhxVNJ
         sN2A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793122115; x=1793726915; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MWyXscpgq0mKENbth6U6G8hO/Fpg0qBlfyz578FuBms=;
        b=NidW6MgVkhah50bZIkU1luVEgY0IJhwPpoYMxpZ1ZoUTkQwDpZelZThsTMaowiq96S
         t2ojsvhE0H3TtfkmMkjIBiRxOjQRNisJIIb+KHGjaaoZWyY+KSGP2JC6GFjV3BSXac4J
         eRGgqdm+t3jVKAJpNh6KzGi//MjLN5fXO/oyuLZvlTU6uPe4WZVWcZQqkzwGnhO6brPe
         /flTrkAP/OLLH7D/BszfO7QVPmC6PV+Id8oTIjUD93G+++9sbjfqVEl/awwYbqAurmzk
         qJHIxOEFmLycUhV1g1YNIT3g54GDWrJVF4mwDf9JUZYakB192efnT2pJUXrLFFii7zbh
         pbnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793122115; x=1793726915;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MWyXscpgq0mKENbth6U6G8hO/Fpg0qBlfyz578FuBms=;
        b=jUEJvB0UFBwMQOOpbp382VeevDEQ1tcplk1eit2TXWKFopfh09A4Z4IlcnTpe5DxMb
         OR/TvUp1z+0u4FfOHA+glhSdtmnU82dKLl1J5JZ5jlH6OdTSSEDFANag5SfbrNWpURXK
         GfPpkdq4H8xZRpm5Wz320JE4N3Qwp7ume0YBfNwFaiOl1r6xKYYa0MDJtBAQvSmP7N7t
         s9qUfmyjWhBpnoMHNOdUx4xb/WjS+zA8ivGcxfcXh+qhZNJpy2gDV/LHNUrf4TLMe42X
         +RoioureVQTu2eKB2iNGSwO9LxJGvMmFzY6qDwl3FKP3THRo130z7Jh3qyOhC8z/99jl
         SGRA==
X-Forwarded-Encrypted: i=1; AKwUvBzkn308JlhxxymkFyzHS9rarr7eSDbddD+Dh8x5rzexyRiu9oCbOGyGjuz2kInLqwTbwVVm+KarOA==@kvack.org
X-Gm-Message-State: AFq9FYKIu8z3P+GptPjLNui/Wpgs7bEzFGcyw5WXokx+aBXrgc4tWjAs
	s6xxEaTvtOpmeO/MrvEizGpiT1/s2K9lS0n0F/kkLl205wM11DFg8dMc/g/IakK/mxrwbHpYW/H
	UMIGYKgAue3KLR/R7Bmq1IRUg/7suNFgg2GET5BMY
X-Gm-Gg: AYBFou0Tp5bcqQdR621Kpehr3QxOwj9LhhmGxczmMs0uMtMNDABrVvGo8KRP0kPKh0V
	006pAaMLBOzbrFA7Mz2lH79diDOqFqLXrTYypEG3QN78qnJ0abgExWsh8HNminu0Miruzjt5jj4
	uo3ZTAJP37VdTJ3Mm+nFt9gOVT0IR9TfhL+G1SPRYxh8KR/FugPJO3P8rKmSjvGl5DvGRbxTNav
	TXO4j57mTiukqEYZVdY6ysvQDprhrT5gv2zlWHAscbmLeocjx/jEsQvaOLZt5BQNCh71kjAdzri
	yIdVh70N8CscqJbEKP/LFnbD8FTqA8G78uzxq9mzUO9KLDXh0AQBBJJJmJSrh0RsQtM1NJ+Mfpw
	xqHd6WHZ2prVZCEw7Zd2a4SO3cEAYiFH1G4b2AErYhgjCJhpVZVFVzQtQXlIiAr8V/6CSdnB5y9
	2xKr5Ptpq7ukyEvQ==
X-Received: by 2002:a05:600c:3049:b0:4a1:eccc:7807 with SMTP id
 5b1f17b1804b1-4a937e30731mr28445e9.8.1793122114845; Tue, 27 Oct 2026 10:28:34
 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261023222313.3979455-1-tjmercier@google.com>
 <at9U2HvyUP-iYOCt@tiehlicka> <CABdmKX1mLKEJNiecW+meJ=LB_Kb8-ieeWdZDd4T6rNR9gKuq_A@mail.gmail.com>
 <auBxqU34FQYauoQr@tiehlicka>
In-Reply-To: <auBxqU34FQYauoQr@tiehlicka>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Tue, 27 Oct 2026 10:28:22 -0700
X-Gm-Features: AclHuK-NAoFvZLQL5pNcy4EmaDv4m9SumnHLP9lwTJmOHtHQgmvKyUv42pTsi0E
Message-ID: <CABdmKX2Hua321nr9vR=Q7-Uu5N6e2JARtUe5RnC3JFu6aGRqhQ@mail.gmail.com>
Subject: Re: [PATCH] mm: memcontrol: fix NULL pointer deref in
 high_work_func() on dying memcg
To: Michal Hocko <mhocko@suse.com>
Cc: hannes@cmpxchg.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, zhengqi.arch@bytedance.com, akpm@linux-foundation.org, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BAE2920009
X-Stat-Signature: rncfk4xd3r33jcnqoqw1csukmkqmr1bj
X-Rspam-User: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793122116-509608
X-HE-Meta: U2FsdGVkX18YIhrD0rCwjIyXSmzZqf3VSoEPvpTfEvyaot3ZEPe29pU/1dPv9UaIrbcXUOfuld5vRob5B4kU0Q9DL+sLHqj2p4k3t/LVvs1dnTvtoNK711LgtplifKCyMe46dUpCH/KE+NdfFW/sI638Wa3/oamkA7UWxjorZsQfUDgNu4ilGA8ifmKKYD5wQPtoRkvse9ughE3y2FUCjgOhz9nz9J2ipHPb32uOxQftH46fbHFnAiLRiGQHzZ0unEqwDKr9VjYifJuDivkGXXxjeRgrVz8FHr0AY0t2nHa2TlVTLVvAJx4YYqUrqOAKkYIDaolh0YZUjG6i3zmZHQGRA5hYcncX3he4GKTvsbFyZaQqOq5BQYnuZ9KWsyP/74nK1CWlVpfEyMUMNua8ByfCKeQ1492ugW0iz9AhEMxH8Y9AA5sSs54t79juIsafI+mTmpka1yKwvEYV92oTRZ+xRiLhXLO9pcSX89ZU205E/cVUmYAnjlTB8o+TQh8grsBFdsTGD4lS9UyPNPdgBarLHnKJo7Grae0IVGgSNr+QUyJJeZCZblh1sYhJSCh5et/FYXzz7FNPL2jPvSdZkmZBHJKp7ZvaFeigwYKPUNCVr5Lf7wjtK49NKGhfzK/Ci6D8oFLU3/uaigpMyT/y32NU/0vRgRfUA/8wxDrEUQwZPOQ0id0ts+a7wD9CT4t8nTqedFgw3Pb8lwb18W756Cie9tvtIXaPlURbf8X6jtCjym5mAHHRGi1uRd9LHUJjX3wQzBwm2XylgCeEGF32YQK4Dqz0f8GHnLODdcqUED+Zt6XPk/f57X8Cg6JQxtVKvvcbhEvITaIdfruucUg3ntfXG7YQgrS3nI744/LL7STFwI/b0H7MY2mdiH+3khSmmykIznXoDEpM6aqnPjOJ1ziG4qE179dvCFPjpBnlf0kX23gkt2bd13esYawY00FOi7XC574yBrVxO8xOKRN
 jmubymin
 /uqf/iEHVyueaTIe8r8vM8WuQ49wHYK1tDROrTLH1T6iMflLMCN8LLe8IlvtusSWE2Y2b0w7Afb29/VRQxi+eQBZM6sPijslZQ5jBpKSVNVyxax+tidMn8WHYyj5VPVmipTMwheZ7jjp6BvHtkiNFmnzlrEHkX1ba3XUELW0W1PcsDMFP9UJt1F25qIhSZq7vDPGURh3rnRvWTB0Xr6/C6b1k8OgTJWWKcGjQA50NQkDET17fTsbaHNzWEoOdRCOXypYSD7kdff/yTEi+xBpvjv0pIt8mNFeFH416BGRgtr7yCnHJBzxqESZoCL8Ih04ZvSv9Ej5treIcAqE7FjZZKI/0f4A6eH0DjOlOlkhgu4uwgyVZiGy+KovHdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 2:41=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Mon 26-10-26 11:01:51, T.J. Mercier wrote:
> > On Mon, Oct 26, 2026 at 6:25=E2=80=AFAM Michal Hocko <mhocko@suse.com> =
wrote:
> > >
> > > On Fri 23-10-26 15:23:13, T.J. Mercier wrote:
> > > [...]
> > > > ---
> > > >  mm/memcontrol.c | 5 +++++
> > > >  1 file changed, 5 insertions(+)
> > > >
> > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > index a05d9a8baa1b..84f4a8fd4d16 100644
> > > > --- a/mm/memcontrol.c
> > > > +++ b/mm/memcontrol.c
> > > > @@ -2457,7 +2457,10 @@ static void high_work_func(struct work_struc=
t *work)
> > > >       struct mem_cgroup *memcg;
> > > >
> > > >       memcg =3D container_of(work, struct mem_cgroup, high_work);
> > > > +     if (!css_tryget_online(&memcg->css))
> > > > +             return;
> > > >       reclaim_high(memcg, MEMCG_CHARGE_BATCH, GFP_KERNEL);
> > > > +     css_put(&memcg->css);
> > > >  }
> > >
> > > OK.
> > >
> > > >  static void high_irq_work_func(struct irq_work *work)
> > > > @@ -4463,6 +4466,8 @@ static void mem_cgroup_css_offline(struct cgr=
oup_subsys_state *css)
> > > >
> > > >       page_counter_set_min(&memcg->memory, 0);
> > > >       page_counter_set_low(&memcg->memory, 0);
> > > > +     page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
> > > > +     page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
> > > >
> > > >       zswap_memcg_offline_cleanup(memcg);
> > >
> > > Should we simply disable_work_sync when the memcg is going to be
> > > released instead (mem_cgroup_css_released)? That should both prevent
> > > the run reclaim_high during the memcg shut down and and also avoid
> > > plaing with limits to work around.
> >
> > Hi Michal,
> >
> > Unfortunately that won't work for shrink_many() ->
> > !mem_cgroup_tryget() -> lru_gen_release_memcg() which can occur before
> > mem_cgroup_css_released() runs. (mem_cgroup_css_released() happens
> > through the cgroup_release_wq.)
>
> I do not follow. Could you explain why please?

Calling disable_work_sync in mem_cgroup_css_released() is too late. As
soon as the memcg refcount drops to 0, mem_cgroup_tryget() starts
failing, and lru_gen_release_memcg() can run.
mem_cgroup_css_released() runs async via css_release() ->
css_release_work_fn().

high_work_func() doesn't hold a memcg reference, so the memcg refcount
can hit 0 while high_work_func() is already running, or waiting to
run.

high_work_func()                    kswapd
reclaim_high(memcg)
 try_to_free_mem_cgroup_pages()
                                    <memcg refcount hits 0>
                                    shrink_many()
                                     mem_cgroup_tryget() fails
                                     lru_gen_release_memcg()
  shrink_lruvec()
   lru_gen_rotate_memcg()
    NULL pprev deref

... later, on cgroup_release_wq:
css_release_work_fn()
 mem_cgroup_css_released()
  disable_work_sync()   /* too late */

> > The high limit reset is also needed for targeting live ancestors above
> > the offlined child in try_charge_memcg(). Without the resets,
> > high_work is never attempted on them since it gets dropped when
> > attempted on the offlined child due to the first hunk, and
> > try_charge_memcg() breaks out of the loop.
>
> I must be missing something really obvious here because I really do not
> follow you here too. So we are offlining a memcg. We need to coordinate
> memory reclaim with the memcg tear down, right? For the high reclaim we
> can achieve this synchronization through disable_work_sync in
> mem_cgroup_css_offline.

We could call disable_work_sync() in mem_cgroup_css_offline(), but
that waits until high_work_func() is done and it could be performing
reclaim. mem_cgroup_css_offline() runs under the cgroup_mutex, and
cgroup_mutex contention is already bad enough. I don't want to add to
it. It would also block the rest of the cgroup_offline_wq.

Every other caller of try_to_free_mem_cgroup_pages() keeps the memcg
alive. high_work_func() should too.

> For a synchronous high memory reclaim we do not
> have such means but we are keeping a memcg reference which makes the
> lifetime well defined. If you reset counter you might help to bail out
> early(ier) but that shouldn't be necessary from a correctness POV as it
> doesn't provide any explicit synchronization.

The high resets are not for synchronization. They are for performing
high_work on the correct live memcg if necessary.

Even if we take the disable_work_sync() approach, we still need the
high limit resets. Any try_charge_memcg() on that offlined memcg would
break out of this loop too early at schedule_work(&memcg->high_work)
(a no-op), and potentially skip calling it on any of the parents.

do {
        bool mem_high, swap_high;
        mem_high =3D page_counter_read(&memcg->memory) >
                READ_ONCE(memcg->memory.high);
        swap_high =3D page_counter_read(&memcg->swap) >
                READ_ONCE(memcg->swap.high);

        /* Don't bother a random interrupted task */
        if (!in_task()) {
                if (mem_high) {
                        if (allow_spinning)
                                schedule_work(&memcg->high_work);
                        else
                                irq_work_queue(&memcg->high_irq_work);
                        break;
                }
                continue;
        }
...
} while ((memcg =3D parent_mem_cgroup(memcg)));


> > Shakeel's remote charging patch
> > (https://lore.kernel.org/all/20261010210957.1350874-4-shakeel.butt@linu=
x.dev/)
> > sends remote charges through high_work too, so without the resets
> > those would lose ancestor reclaim the same way. Before that patch not
> > performing the resets means reclaim_high() runs unnecesarily against
> > current's memcg (not the remote memcg above memory.high).
>
> --
> Michal Hocko
> SUSE Labs

