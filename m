Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C94DC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 06:32:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 204F96B0088; Thu, 27 Aug 2026 02:32:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B5556B008A; Thu, 27 Aug 2026 02:32:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A4326B0095; Thu, 27 Aug 2026 02:32:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D64EE6B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:32:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 63F9F8032D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:32:00 +0000 (UTC)
X-FDA: 85146079200.24.DB931FA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7F74814000C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:31:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V13MgJRh;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787812318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KhvHvWWuIDHSeOEKC6vVyL/a6flNWVIbHNrWx7uPr7o=;
	b=SCmRHG57r31scItV8spT86pMjjlHghxG9L4Hd++aI3ZA+rHhMZFd3Tl6NHs3z408T07H6y
	mQ2zT8w+Dvz1N3CA9f1UcD8U9X2kVBiEI8iBFseUVw9XvczdVpzZjVTKF5W3ff9vcX9Wk4
	PR+BI8rZQbhxHXnaujDb0V2b3vz1iLo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V13MgJRh;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787812318;
	b=wQDFOK6xUzvldhae2by7z1oqTrn8dxhW9vsyv4XDOJkAUBbb9TQYyQvPYA0xR0SrcE4yYB
	1Lo+UyEMskXzpq0h4iXOpDECH8tNPIA/UlyS1HWf+sl2iqA+fPeeTZCPskbrhfoJAdvFE9
	s/7N2WvHl/224QS1EWM0qVCvWydfi4M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9E29F60200
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:31:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5172C1F00A3A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787812317;
	bh=KhvHvWWuIDHSeOEKC6vVyL/a6flNWVIbHNrWx7uPr7o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=V13MgJRhlCd+6uHPqN3wMchtGFMUUqf2sNoHX5OARJvodEf1hG5b3giGGtbOX4c8K
	 VOsHghD8L5DzevGd8Vusmk0Ck8yijCHI/4ZqIcgRzWqScDmJu2eqjj0mB1RCyCNtmJ
	 /g+++bkxsgxgCnZUV2mbKxYnFOR8VTBA5agkRGD8UbeTXVVBCzUoyFnDVnWEkLeIi1
	 JblFS5ty/vDtjA1WblzTgQumrZFH5Cn674qTv8cSWOkjVdM5D811oMVdjEeQ0cMbMb
	 B/sFhDavkQUU2qyeTsVHWZIf5fz0Q9rM4qfftBfxhin11eAeXW3sm6mRJ8ucpemd7J
	 BlKwGhEvbGd/A==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c25344a8c6cso113817866b.0
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 23:31:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqdsSsjZpn3VPWgX1MCXppHoTBPcQEzTzRiqEKhTPvBkf3EWsre09PkER3+Df4aXQ95/NlqTnJ0Ag==@kvack.org
X-Gm-Message-State: AFuF++lcTwx/moPP+e16USBI65mwJewZOQMOKiFCrAuvBfWs+1U3y0pD
	WmO1kBqI8DJ57Tb23oww7H74FzaP9ye1fsuTeILGs6/9uaai/MoxptfJe/qJX/W3272ggI293Xs
	4KDTNqFEx2hNfU5hPDkEYNZbgpDl1sws=
X-Received: by 2002:a17:907:7203:b0:c20:fda7:1856 with SMTP id
 a640c23a62f3a-c250bb76be9mr1236400766b.8.1787812316140; Wed, 26 Aug 2026
 23:31:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAJnrk1bk66ZhRAS7mojSnD5RBfFS+0ChAPymE3ObRWr0C_udWg@mail.gmail.com>
 <CAO9r8zPpe6fWOSXtRUjFB8WNMroeBqvLT+2QtAU4E27AtLUXMQ@mail.gmail.com>
 <CAJnrk1YifN22mA5PFRVrh3m_ygxax6x4_8nraG2hPqCzyzBj7A@mail.gmail.com>
 <anpsLy_pCanocgS1@google.com> <CAJnrk1b5asARJ_g176DsoNCvf+iFqzPbOtVveeuPxTPZDmnuKw@mail.gmail.com>
In-Reply-To: <CAJnrk1b5asARJ_g176DsoNCvf+iFqzPbOtVveeuPxTPZDmnuKw@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 26 Aug 2026 23:31:44 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOeh1fFsY5CG1C8CDCJH25eiioY-otRv6Krn1=S21PeaA@mail.gmail.com>
X-Gm-Features: AcwNN1XOHx_bZWmT2ZCq1l6ENGShSiy5Had_nYPNFH4GirLAH7Zy7R2zPmgtiUo
Message-ID: <CAO9r8zOeh1fFsY5CG1C8CDCJH25eiioY-otRv6Krn1=S21PeaA@mail.gmail.com>
Subject: Re: memcg stats flushing (WAS "Re: [PATCH] fuse: disable default bdi strictlimiting")
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel-team@meta.com, 
	fuse-devel <fuse-devel@lists.linux.dev>, Jingbo Xu <jefflexu@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: sfuh95fcnmghfzyuyugq9nfc6pi8695j
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7F74814000C
X-Rspam-User: 
X-HE-Tag: 1787812318-830146
X-HE-Meta: U2FsdGVkX1+vNua9sVuUVaX9CBSK4DiiyN0U2lc6/zQoweTFgHrQzcs+ltkelk3h8XRTrgd/gpQBWI7alpLIYEaW0d8lTYhg2qBJopdrWwH8TsFK2Dwxtx0QPOUU9YV49f4q17LvVdxV8uw4SXxHFXUwnejWjwlGjIBnKyY75Nrcx9NaZ9N4Q2p6ElbXU/hXNMigxRgXswTrNcja6ZRWDt2DGBqZCzW48o58aZftEHIMoiU7hgyU4NNrOpKDtzwe5d3re1soljFSU0wdk2/XUwf/UwFMK/69KCs7LhydjG0s1QFolIIdHez/Dc21ltZ7C5lagsk4QyZS50dm1bCKYsDXrxVMDhbfDmMbrakK/kH/hGuRdVsZWt3KbvK06uVklLmHlpLVWr9rK15gzVqywI3SEXE8fchXEG3sUBbQocXYs95Funl2bISWtHy6AOwByg8rVGuGyw1eEZzrMAupVA3MGjL9UIqZGq9p+yUsQXJbytk6hOsMC/eXtH/CQjDTnJu6wpte4KtNwW5S0iFQAeVnhoNSeScQmd+70/DZ16feApeM/rBqPjktf7hYboP6VO5mtsubEkZ41TJ5UE4r6inAXH7YECI/bkdRmzfTs1rP1GCYEVbO0W395MmJCyqePxyxBZvn7o2ik6Nh+b4tVKuM1fnB3EX860ygFKURyxEcgJqmHfEX0m2GUlsiRzo3q/8bMToOWeIBww5y14JlrkTjiAhaqxPfzofSaOqjI97eMr45LHT1O+2lYwZEhGad1BboKEUCaBSAbd6ozz+lju+/ZEnOmsK7CcSBnnTQb5nl+PcO1XXMyF/qMe/cL1ZqvTWGZeLRHKk8yKdj6BsS2X4kS1EWxNiChTR2vTPuyYG3rrOn1bgub5z8Tv6OcC32U+kgR4S/8epjyAsrnWa3JCOL3PRlq750TNyTHNEi3Skh/EpzPFZ4Ev5MKzzdXMrw0Sk73qbiRgTahg/ekFU
 BfJsrYPG
 dAXgvOXiMuwieJgwXK4Rfms3X8MwMNE1FxsrjaGE31GbuqDYDdaCnX8fReBZbl+BKzRSSrYhjLy6WiAq/UIWZsr+Lc2cKCl/VNPz/mzPLCJvC/aWzlq+QTLyuf3Fwbe8ppzoySTQOGLUuIJlCX2m4DnNtr7eIPQVppvW4GbjsqBvzqIvh86PcOJ1aqadc9Mis1fMj7AkLCTICiOOs5X0aCNcSjLyDvmaJsZ4UwBVKJUUI7U5o3fzwnPo6TSoHE6gtjN3QFXxeg+IWkSU4anIyuroyExMnYLOdnRaf6hzPDuOvGJSQtkIqseDL/M2KSW9Hitma80FEeMjrEtg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 5:29=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> On Mon, Aug 10, 2026 at 5:48=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > On Mon, Aug 10, 2026 at 09:49:31AM -0700, Joanne Koong wrote:
> > > On Thu, Aug 6, 2026 at 2:31=E2=80=AFPM Yosry Ahmed <yosry@kernel.org>=
 wrote:
> > >
> > > For updating the stat on each parent and having the flush path only
> > > accumulate CPU counters, I think this means we would have to
> > > unconditionally walk the ancestors + update its counters on every
> > > update, as we wouldn't be able to early break if the flushable
> > > threshold was already exceeded. I don't think we could replace the
> > > stats_update update, as it seems like readers still need some way of
> > > knowing when to flush. It seems like this could be a nontrivial
> > > performance hit, but maybe it's a non-factor in reality. If you think
> > > this would be useful to get benchmark numbers on, I can run some
> > > experiments on this too.
> >
> > I think we need to experiment with how much work we can shift around
> > between the update and reader sides.
> >
> > Right now, on the update side, we call __css_rstat_updated(), which
> > iterates the parents and puts them on the per-CPU rstat tree, then we
> > iterate the parents again in memcg_rstat_updated() and:
> > - Check if flushing threshold is already met.
> > - Update per-CPU counter for stats_updates.
> > - If per-CPU update exceeds (another) threshold, we update an atomic fo=
r
> >   stats_updates.
> >
> > The flush side checks the flushing threshold and does an rstat flush,
> > which will walk the update trees on all CPUs and iterates all child
> > cgroups on it. Pretty expensive when the threshold is met.
> >
> > I think we discussed two different options:
> >
> > (a) On stats updates, iterate the parents and update the per-CPU
> > counters of the stat directly.
> >
> > In this case, we can't keep using rstat, as we would still need to add
> > the cgroup and all its ancestors to the update tree anyway and the flus=
h
> > cost will remain similar. So on the flush path we'll need to iterate al=
l
> > CPUs and add the counters. We can explore if use a cpumask can help
> > here, but perhaps not since we'll need to update it atomically on all
> > stat updates.
> >
> > I imagine that if we do this we'll drop the stats_updates optimization
> > to avoid adding more cost to the update side. We'll be replacing parent
> > stats_updates modification with parent stat counter modification. But
> > maybe it's feasible to keep both to limit the cost of flusing.
> >
> > This only works if the cost of iterate the CPUs on the flush side ends
> > up being cheaper than the current flush. I imagine the average cost wil=
l
> > be higher but the cost should be much more consistent vs the current
> > flush, so the tail should be better.
> >
> > (b) On stats updates, iterate the parents and update the per-CPU
> > counters of the stat directly AND update a global atomic if the per-CPU
> > counter exceeds a threshold. I think updates may get too expensive as w=
e
> > may need to update multiple atomics, especially when updating the root
> > counter as it will be contended by all cgroups.
> >
> > The flush side becomes an atomic read, so should be very cheap, and we
> > can drop other heuristics and optimizations.
> >
> > ---
> >
> > I think ultimately we need to experiment with these approachs (and
> > perhaps others) to check what actually works in practice. You'll
> > probably want some benchmarks or synthetic tests with many cgroups to
> > exercise the worst case scenarios.
> >
>
> These are the results I'm seeing from the benchmarks. I'm comparing
> non-ratelimited rstat vs (a) vs (b). I'm comparing non-ratelimited
> rstat instead of ratelimited rstat, because ratelimited rstat relies
> on the 2s flusher and doesn't incur any additional flushing when
> called.
>
> ~On the update side~
> ns per update (measured by having a kthread pinned to each CPU and all
> threads updating the same cgroup for a 200ms window, run on 80 CPUs,
> computed as total CPU time / # updates)
> depth      rstat      (a)         (b)
>     1        22.34       32.49      60.10
>     8        22.46       47.12      140.72
>     16      22.49       70.96      206.39
>     32      22.51       139.16    305.40

There goes my dream if an rstat-free world :')

I am very surprised though that you care about hierarchies this deep.
I don't think we have anything close to even 8 at Google, and in all
my previous testing I usually test up to 4 or 5 levels. I suspect at
that level the difference might be acceptable. But aren't other
operations also really expensive at that depth? I imagine the charging
path is really slow if it has to do atomic updates for 32 parents. Is
the update path really a problem given everything else?

Given the constant cost of rstat updates, it also seems like
memcg_vmstats_needs_flush() is mostly evaluating to true and skipping
the parent walk. I wonder how much this remains true in practice, I
think Shakeel mentioned that it does help in production.

>
> (a) and (b) perform worse on higher memcg depths, whereas rstat is
> unaffected by depth level, which makes sense given that (a) and (b)
> can't break early if the flushable threshold has already been
> exceeded.
>
> ~On the flush side~
> ns per flush call (measured at leaf of memcg chain, ie best scenario
> for rstat, # CPUs on the system is 80)
>   rstat                      10165.60 ns   (min 9924)
>     (a)                       734.10 ns
>     (b)                        4.79 ns
>
> (a) is around 14x cheaper than an rstat flush, which I think is
> because the rstat flush goes through every stat, even ones that are
> not directly relevant.

I think that's only part of the story. rstat iterates all children
cgroups as well. I think reading multiple contiguous stats may
actually be really cheap since they are likely in the same cacheline.

>
> Using some napkin math, I think the breakeven point for (a) is around:
>                       updates per read
> depth 1             ~900
> depth 8             ~380
> depth 32           ~80
>
> eg for depth 1:  (10165.60 - 734.10) / (32.49 -  22.34)
>
> This is assuming one read per flush, which is what (a) and (b) would
> necessarily have to pay, whereas rstat only needs to flush when the #
> of stats updates exceeds the MEMCG_CHARGE_BATCH * nr_cpus threshold,
> so the updates per read numbers above are in reality lower.
>
> Running a fio write job and using tracepoints to count # of stat
> updates, # of reads of those stats, and how many of those reads flush,
> I'm seeing:
>                      updates/s              reads/s
> flushes/s         updates per read
> bs=3D1M            643                           119                 45
>                        5
> bs=3D4k            156,415                     123                 58
>                      1267
>
> For larger folio sizes, (a) is cheaper for writeback (since there are
> 4 update events *per folio* in the dirtying/writeback lifecycle) but
> for smaller folio sizes (eg order 0 folios), (a) is worse, as a lot
> more updates are incurred, and the performance is worse the deeper the
> memcg is nested.

Hmm interesting analysis, but I actually think a more interesting one
is the effect of the update latency in respective update paths. For
example, in the zswap_store() case you analyzed earlier, it ends up
being in the noise. I would check what the hottest update paths are
(probably networking?) and check what the update paths are, to check
if they are really sensitive to the increased update cost. It could be
the case that at least stats that are used by in-kernel flushers do
not really care about the extra update cost.

>
>
> I also ran some experiments with Jan's suggestion of scaling the flush
> threshold to the memcg's limit rather than to the number of cpus. It
> helps the overshoot we saw and slightly outperforms doing a plain
> non-ratelimited flush (100% of dirty limit vs 101% on a 1G memcg, 103%
> vs 107% on a 256M memcg) but led to ~2.4x more flushes.
>
> The initial reason we switched to the ratelimited version of the flush
> was because flushing was expensive, but I'm not sure if flushing is as
> expensive as it used to be. Testing the non-ratelimited version, the
> flushes account for about 0.9% of the system CPU the write path
> already spends, and I didn't see any throughput difference between the
> two (249-252 MB/s either way), on a 32G memcg. With the
> non-ratelimited version, it's also not a flush per read - it's still
> "ratelimited" by number of updates that have elapsed since the last
> flush (only flushing if stats_updates >=3D MEMCG_CHARGE_BATCH * nr_cpus)
> which means concurrent writers writing back at the same time will
> "share" flushes rather than triggering their own.

Yup, this is exactly what I mean. This is a good analysis for the cost
of the flush: how much it matters end-to-end. Even though the full
flush is 14x more expensive according to your numbers, it seems like
it ultimately doesn't affect performance much. I would do the same for
the update paths, see if the extra cost really matters. WDYT?

>
> In light of the above, imo it seems to make the most sense to just do
> the plain non-ratelimited flush for mem_cgroup_wb_stats() and make the
> flushing magnitude bound again, wh ich also aligns with what the
> global non-memcg domain does. The question is whether the extra flush
> cost is acceptable, but the numbers above make me think it is.

If we can eat the cost of the flush here that's great, but I think we
can't say the same for the vmscan and zswap paths (at least)? :/

>
> Thanks,
> Joanne

