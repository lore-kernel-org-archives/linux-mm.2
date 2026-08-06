Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DF7CC56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 21:31:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF2566B0099; Thu,  6 Aug 2026 17:31:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA45E6B009D; Thu,  6 Aug 2026 17:31:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D92DB6B009F; Thu,  6 Aug 2026 17:31:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F2B56B0099
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:31:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 22AAB140299
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 21:31:53 +0000 (UTC)
X-FDA: 85072142106.05.C7C69C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 39C2F40010
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 21:31:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nwxH0CNa;
	spf=pass (imf01.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786051911;
	b=P1II1wHXcwlKw0njTeQDs4vEVrWUAamzH3e9gmlyW1n0yZ4KERxTAe74J8THyphIHd5XZO
	Mgg5Vj6uvRIHv+A5aTcPaTsM5nWpBphZfs4cv05hpTJZ+i0QPMCe8bYmXDqptPQT/vbkQ2
	ZrHozAdK+i9HPPdudTlpmQw+2qmJhME=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nwxH0CNa;
	spf=pass (imf01.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786051911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f+vuZk/3TdAvubYqezg3xRVcC3uI+rukRW6k4jf53k4=;
	b=6KJgrCsfu89X3hYDk9RBAzoiS3q38Y19LZ2L6eGl04ezIt1M9HsQOcdx0xcyoHsEkjzqpz
	fpQBLeQEvk53gafv0knS1/gUumqOCi2wEPm5sNu2zOrouz1X9DnccrmXFOp+OHY8mfD1Iu
	E2yYYMuN3M/KF04aiNqRPxAynt0NCCE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C2CDF60DBB
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 21:31:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726251F0155A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 21:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786051910;
	bh=f+vuZk/3TdAvubYqezg3xRVcC3uI+rukRW6k4jf53k4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=nwxH0CNaNw7l1V5T5kZ52ToVTPaN2ZpF6OOKWUYHYYebuACQBdw3SPtibWVXCq6qO
	 Gu09JQGMZOh818Kg7KALYa5d+MK1kkHrJJQ1Py3JKNNxWXCXLxc66hmnepwMJYfqNi
	 MT7ss5N7D6giLsTm4MyVo2fbZOoxhjNywkdJwz6MWROeE7FNXb2peRwM2LVuX8HeVI
	 s+RIOrK9YAtAKQpU6V/3AxqnQNM9JWy8baKWT3dGJmn82mZ2+HCXSdtRJsUTbMnMfA
	 sOmbJS8egpUhL6L41VH9kQQFlW2HuKUXoRbJAGze95h5nRFfnvvfVzzWco8okPFsb9
	 HxEATLi8VzVuA==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c1f5208b38dso482708566b.0
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 14:31:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rp3NhgsIqCb/CGb+8WMcxhgsbzRJAYOJu4CXaHb7jBZhZfRYJ7+3eisCAa1zC1r6U+eGY5tW33Yow==@kvack.org
X-Gm-Message-State: AOJu0Yw72K5eGIXjwDYPsrxriY2d9+uJd3KuYqKwcgZ3ShyyHwEilfbJ
	iBPtKqD5i5YCxbxIQJnq01XJxMgcWp241szAJ3cybSgOIRW1xBI99xFcTbNyUEbkOOivnqHpJ3m
	1BTr5bZ+Pd4C2X0eabE0zOXLoq4IVgvU=
X-Received: by 2002:a17:907:6d28:b0:c12:713b:e199 with SMTP id
 a640c23a62f3a-c2039e1e76fmr735104966b.25.1786051909163; Thu, 06 Aug 2026
 14:31:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAJnrk1bk66ZhRAS7mojSnD5RBfFS+0ChAPymE3ObRWr0C_udWg@mail.gmail.com>
In-Reply-To: <CAJnrk1bk66ZhRAS7mojSnD5RBfFS+0ChAPymE3ObRWr0C_udWg@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 6 Aug 2026 14:31:35 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPpe6fWOSXtRUjFB8WNMroeBqvLT+2QtAU4E27AtLUXMQ@mail.gmail.com>
X-Gm-Features: AUfX_myN1Xm_dzXK3x3BbJD0tmZgm60j6bA0lBQnYhdJfnqBygrFMAFNgsnSRh4
Message-ID: <CAO9r8zPpe6fWOSXtRUjFB8WNMroeBqvLT+2QtAU4E27AtLUXMQ@mail.gmail.com>
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
X-Rspamd-Queue-Id: 39C2F40010
X-Stat-Signature: kanrt6ry6pfkiin1jxhxcguqphfc8ni9
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786051911-483501
X-HE-Meta: U2FsdGVkX1/91Bk3ltXFOnW4cpD04KMivEPwbt8tOL8uH+Dtt2RXjxx6brFspZrC+q98vpUwXx+jb3LeQoYDaAvUBm5aNCSSxy2PbU5AMqLTok9cXmCIq+LakXivZul6GjvjyhOzFBmjc0nm1pEjE9uh5kVQX9IaIP3HoABjTHubS4ZiUbhF6iiSNIiznaBOOM7JOHx1n0BnMwyRh0pEvtYSZOgo9FdAExKWbfHzm6ddI5QCU6WAMUC0xyR/dufxEw6DbUxWR5VMO1QX9FGyxA7KBbppTeTyYGjkgAAxIYHNJf38lQGJqKIr7kXLBF07Fil/JD4X+brce4WKRrvLWGFMRfE5Jnhy14O5KgE44W2TblZxsASM+eLwbN3kLiWLjLBnbUjBnv4Np8MDm4Y6WnHvoMfg39zaKM6jEnIVxIDL4+buGkpU8K4JtoaN453LbzYZaZomniJs2SetX4iTdt8VxO2U7dkOiXgRIodijCwh10XMeqPoBE2AEFg6Lft4iJLMFURhZs807rbNqvkhNzzWS164VLkCJCIIdJ/kW2NBBHv4ya06g8OqvyrJqyYTdZuXgXHDgAvZ4h4gkWyQyxjf11K+6Gbki6/PyTc7CwFm8jmujivSlOH4k5ASZ+c+M56863xrOSJYsoyZZipCLxAxaH5FsWYfrC+DukIlFod3gf+N7cf2qB97h366OISpRCb6rcy57RZstZIoRxRv6UizyHtxpupsCAVabbD2fOaAnnOMhK0PgxAsB4rbCZ6fQb1ezFX2hZq7JNnk5Ukfu6e7/IttZyLJz3oETIOH7HOs0EcyFkytR7s0yP0Wpimm/ukWYyNUAkvIH245LTBP9YVQBwd/24RWwq35doKJzAcJFfFdsFSRSMqTT9sEvxeS5VVKqcaXPJSN1dYckn/ZifrQdyMfFneTTj8iMwN1ASKvj855BMiW+srWaXm2p8Hcp6i7VpYFNahnYnurim+
 jUjSm7H3
 4rXpIRy9qX8UBMvVDZi1GUcy+WcLC0+5Nk6gkJ+Hvjw9WgVatqpaqNfEoa7lUk73THgWgrxjzUByT6jEPkhlJSjrYMVvnRNcb5iE1ESptwOnh2XKAVwZf5Fvri4cYu81vRDktDQzyXIMrRPPMP6NykODzgxRhlWgzxBKg3fzpJL8THlkTeHEQSiek9dFIJa59DC8dsHVCE/dn1tmKq9iKymX6zATApCvOoNZ86LjN4zYfu9OFxhr1gi0eI06X2QQvl+45PWMpETHhYpXLUcr7wAiOdTo5YL84g7A8oyH/pXSYyWJZlrR90TDFbgTcIelUvIye8UhaWatKoxI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 6, 2026 at 2:04=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> Hi Yosry,
>
> On Wed, Jul 22, 2026 at 1:38=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > > > > First let's see if the general solution is doable and simple othe=
rwise we can
> > > > > explore use-case specific solutions. In extreme case revert is an=
 options as
> > > > > well but I would prefer a more sophisticated ratelimiting (that J=
an suggested)
> > > > > than a revert.
> > > > >
> > > >
> > > > Sounds good. I'll keep an eye out for the work Yosry's doing on thi=
s
> > > > and look into hooking it up to writeback if/when his general soluti=
on
> > > > becomes available.
> > >
> > > I am not sure if I had in mind would generalize well. For zswap, I wa=
s
> > > just going to replace rstat with per-memcg atomic counters, and simpl=
y
> > > walk the cgroup parents in the update path, as the zswap load/store p=
ath
> > > shouldn't be too hot.
> > >
> > > However, looking at other in-kernel flushers (including
> > > mem_cgroup_wb_stats()), I see they consume other stats like
> > > NR_INACTIVE_FILE/NR_ACTIVE_FILE, which are updated in the page
> > > allocation path. I am not sure if a cgroup parent walk with atomic
> > > updates would fly there.
> > >
> > > A more problematic one is count_shadow_nodes(), which consumes slab
> > > object stats. I think we definitely cannot do atomic updates in the s=
lab
> > > allocation path. Although it seems like count_shadow_nodes() is a rou=
gh
> > > estimate and perhaps we can forgoe using the stats there.
> > >
> > > If we want a generic solution for in-kernel flushers to improve stats
> > > accuracy without killing performance, I think we need a heavier lift =
to
> > > rework rstat or move away from it completely.
> >
> > (Adding a few more people and mailing lists)
> >
> > So I experimented with a per-memcg atomics in zswap (see [1] for
> > context), and it appears to be too expensive even for updating the
> > zswap stats during reclaim / swap faults. So I think zswap will need a
> > similar approach to writeback and other in-kernel users.
>
> Thanks for running the experiment.
>
> In a previous thread [1], you mentioned your team was investigating
> some premature OOM kills that might be attributed to this same stale
> stats issue in the vmscan path. Did that turn out to be the case?
> Asking because if so, that might be something we'd hit at Meta too.

I don't think we had time to look into this closely. We have a test
that runs VMs with some memory pressure / reclaim, and we observed OOM
kills in that test after the ratelimited flush in the vmscan path.
Whether or not this translates to additional OOM kills in our prod is
currently unknown, but it's a signal that reclaim effectiveness may be
negatively affected in some cases.

> >
> > One idea is to keep per-CPU per-cgroup counters, but on the update
> > side we update all the parents' counters, instead of just updating the
> > current cgroup's counters. Flushing the stats then only needs to
> > iterate the per-CPU counters and doesn't need to walk the cgroup tree
> > at all. There is added work on the update side, but hopefully it's
> > cheap enough to update per-CPU counters, and cgroup hierarchies aren't
> > usually too deep.
>
> I'm not sure about the zswap case, but for the writeback case there
> are significantly more updates than reads. There are four stat updates
> for every folio that gets dirtied / written back, so four per page
> with 4k folios, while the read happens around every few hundred pages
> dirtied. In the scenario I was testing with memory.max set to 8 GB and
> using the default 20% dirty ratio, during freerun the stat gets read
> once every 256 to 512 pages (with flushes happening less frequently
> than reads).

Yeah I think we generally want to keep updates faster than reads,
because some of them are also in latency-sensitive paths like
networking. However, since reads are becoming too slow in some cases,
the question here is whether we can afford some extra cost on the
update side (to iterate parent per-CPU counters) to make the read path
more manageable.

> I'm not too familiar with memcg or vmstat so apologies if this is a
> naive question, but does it make sense for memcg to just do a similar
> approach to what vmstat does? As I understand it, mod_lruvec_state()
> updates the node counter and the memcg counter (if memcg applies),
> where for updating the node counter, mod_node_state() does some
> batching where it updates the global counter for that stat only once
> it crosses some threshold (pcp->stat_threshold). Could memcg keep its
> per-CPU counter as the accumulator but once it reaches some threshold,
> it then propagates it up the parent/ancestors into a per-memcg atomic
> global counter? The atomic would then only have to be touched once per
> batch than on every update, which might eliminate the overhead of the
> per-memcg atomic you saw previously? It seems like this would get rid
> of needing to do any flushing altogether, as we could just read that
> global counter directly.

The memcg stats perform similar per-CPU counting and thresholding. The
main difference from vmstat AFAICT is the cgroup hierarchy. In vmstat
we have per-CPU counters and a global atomic counter for each stat.
For memcg, we have the same for each cgroup, then we also have a
cgroup tree. When we read the stats of a cgroup, we usually want the
hierarchical stats including all of its children, so we can't just
read the global counter.

We use rstat, a cgroup framework that keeps track of which cgroups
have updates on which CPUs, and then memcg has thresholding logic on
top to only flush if the number of pending updates exceeds a
threshold. Essentially, if the magnitude updates on a CPU exceeds
MEMCG_CHARGE_BATCH, we add it to a global per-memcg counter. We only
flush if that global per-memcg counter has > NR_CPUS *
MEMCG_CHARGE_BATCH updates. So in theory I think we tolerate up to 2 *
NR_CPUS * MEMCG_CHARGE_BATCH of stale stats (combined for all the
stats).

See memcg_rstat_updated() and memcg_vmstats_needs_flush() for this logic.

Looking at this code again, it made me realize that we already iterate
the per-CPU stats_updates on every update to increment the number of
pending stats on this CPU. I wonder if we can replace this with
actually updating the stat on each parent, then the flush path only
needs to accumulate CPU counters. Or maybe as you mention, we update
the global per-memcg counter when updates on a CPU exceed a threshold,
and forgo the rstat flushing logic completely.

> > A more radical approach is to completely drop the per-CPU rstat trees.
> > So instead of walking the parents to add them to the per-CPU tree, we
> > just walk the parents and directly update the stat. The flush side
> > will then always iterate the per-CPU counters to accumulate them. With
> > this approach, the update cost roughly remains the same, but the flush
> > cost changes. Instead of walking the trees and flushing all cgroups,
> > but only doing it on CPUs/cgroups that actually have updates, we
> > always iterate and sum the per-CPU counters. The average flush cost
> > may become more expensive, but it should be more consistent and won't
> > scale with the cgroup tree size. I am not sure if this would be a net
> > win or not.
>
> I wonder if this scales for machines that have a significant number of
> cores? Onsomething like the 96-core / 192-thread machine Yunzhao
> mentioned in the zswap case, it seems like the flush now would have to
> touch multiple additional cachelines per CPU when it seems like for
> the majority of the stats, only a small fraction of those hardware
> threads would have any updates on them?

Probably not (hence I called it radical), but I think this can be
side-stepped by either keeping the tracking of CPUs that have updates
via rstat (or similar), or just propagating the per-CPU stat updates
when they reach a threshold like vmstat.

