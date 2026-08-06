Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EE98C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 21:04:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D8AB6B00AA; Thu,  6 Aug 2026 17:04:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 088B96B00AC; Thu,  6 Aug 2026 17:04:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E93326B00AD; Thu,  6 Aug 2026 17:04:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB1756B00AA
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:04:23 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 548671601EB
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 21:04:23 +0000 (UTC)
X-FDA: 85072072806.22.7566EB0
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf12.hostedemail.com (Postfix) with ESMTP id 662DD4000C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 21:04:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HVtBlVLd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786050261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8ilisN6b9rsvSV7tujnE8pXGbGA5qhlw1JHj7X5z5Dg=;
	b=ef1+llqvyMPXT2D6agmmilhgVUpDc/0muxWeGOigGQ+NN7yvrzkgie88iwsFHTbXyJq7Kl
	eVRV5gtrWkgRTInP/SvTFvWxR+F/ardU+NPh5EvZr3cXo1NP/K4PAsb8PhP0zFIAQcBXSq
	BRMPWTwQuqo49jtiYZfQD+Mk3sf0hXk=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HVtBlVLd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786050261;
	b=Q8D0bUPWpNznqQ4nazgyCD2rwO6qoKtW5Llwzc+scUDJ72I6C4aFmk84KZzJd2kvXVz1j6
	CVnILw9FKCLnlaYHTIh6d/lNIU/IJpByDlfkI56d2rLUH5Nq98mjxiYUenbYwArcGWPorv
	ehvcsWHAvE6d5Hx4YVE1uJb6ndPqKG4=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4953de5be0aso19886925e9.0
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 14:04:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786050260; cv=none;
        d=google.com; s=arc-20260327;
        b=QTGFdSu19Ez+iTa0PNZr9wr1CVRv0fIHwR/E4QtuNUWd0xBzkRQyIZTCDITlu7K3QO
         fFVpgGMMA2I1il+Gs5NBjpCvrri9msvvJIBwL9Sc9m6v7GdgaaR93BgvC9VjZKG+u9l/
         VsbHB/trwfB/0XAvBop/aKsbsmTseS9aMp5cwyflUxVtM3/mIwcUXFzZ9Vr7YBk1A8kX
         X768nFNaWzpBFUMuxcXbdc/TcogPl0gcuoTUTjeJqKjV4GbhfrtTDdZ8j8OqNai2QS+r
         jKbFz0wsr5wceBid+94w7QKZCmUEq6xKWWobA8zq9Z8ft/a+1Kiz9Dc12jrr76MYRn35
         Cagg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=8ilisN6b9rsvSV7tujnE8pXGbGA5qhlw1JHj7X5z5Dg=;
        fh=kJgJE/L2eBzZh8YJEBM0rYMLtTNdJAj0XB4PkCeyb7w=;
        b=DNvohrmHjD5fQCnqDwM2aLn73JmU2+Mr8wYrpnRwbIEfvoUPr6QddJpkv5A+ueVo6v
         unm2QtbxiC7TNtojRDKCDTJVxAAyOAJWv1jO+VQCjO28ehLIN0bZqpQ0c8qt9I/BbZjp
         2F7cB0fcBW/c547dfIjtL/yYKyT0AaQWTYCEzZLfhCqOcjYjRHv3qRfRK0n+Ikg6gc2J
         tYp43FZRIJXQs4yocld4hBUb/bE/bzzifTdxkeEmUzg58sSTkL20rNtJykNj1r1oAtF4
         j+yjfi//eL8sy6FPk/hEiP1DoRLshXtQ0jwFo+LNSxqw4R7CzDkBYyirqO1UcJqTL1cX
         RlAQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786050260; x=1786655060; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8ilisN6b9rsvSV7tujnE8pXGbGA5qhlw1JHj7X5z5Dg=;
        b=HVtBlVLdf/w57dVfbCTgVO8K4XFTxcpJGZUgZ456uDL/qUJOJL+nqlMwc/1kLhdXKu
         jnmoQPfKl13I0fd2G3hKPpr8Pnos2DPWW4/JcUJBh2ubmzCZw1gWLgjUlVucEtfZmVvi
         ym601LOYF5ChG27+aijcW2mZQEi/zwxB18QIlW1PyrFMBUAfAOo9PpoWW9yvlLAgv7KX
         mmxON8UOnskt70QgEM6HKCwzvDPsv4vt5XZanDbzLj62TtT1xFvlSmx46uXjWhJ/5qzS
         N9lIxiljhMLGQ2FXxCZ7obJkgt0Zi0JBIGQkmxQsCcWQlkPEpSTPUhIh+YO+qdjDD/HM
         ki4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786050260; x=1786655060;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=8ilisN6b9rsvSV7tujnE8pXGbGA5qhlw1JHj7X5z5Dg=;
        b=S4kxHCggfiwXHMr2cmH6qXFLVXyju1p6/2HWELSxNiA1FlyXdiQuTvJNoUggNHIusN
         7vYtqywXfEV/wRFFYG+SSFgeBP8LgzCdWjX3Vq9qPBXnSRkwEBFaoik8LJhEPFbhmIZe
         Cbwu4nBcA+kbhjnY3qVGcX2WrRD6FH4l69dfHeAA9vypsTQ5/8C6hZ2UUoPIqcG6kBEC
         /ETToptbWpMi2/OhlbPnw4/9W+x4QTvrFBvi9XEdElrXcYgBIH0jp0W2MfD/x1NwhGqi
         bq+7bzKI3F4iQqic3jH3NBP2dQQaMZfwNH9vzZoZi6u75WWQ711guirhW3XAGaIC+7HS
         qLyA==
X-Forwarded-Encrypted: i=1; AHgh+Rr3NXt3YWZCHojGLfIcZEa3A0l4HiflHaq44znE1fJh3EKt0FMdSEggFycBaiEhAWfAHb3UaaBEBQ==@kvack.org
X-Gm-Message-State: AOJu0YzW8LY0Od0X3sxRA5CC1ORwmMNey4TaxSD0XXAK4o9HtDsDXibu
	N0ICVZAiTAIoEja+KQzIcU/a8KEpFFVc4w5U8SeVSV8xLjhaCT//YhxN8KuJit2z2x53tobGlRq
	E0o3eoUGCkkzTbJC+GfFFLkPAEbH87fA=
X-Gm-Gg: AR+sD11HAtPY60X0Pckf3oFDzjQmJn+JsjryMRS31YGc168lo7gFohxYkuCxc/1bKXd
	uet9tMvBmUw+irBRpRCE3HnT0taHAtLbQHtYZDNTI93hsbzXcOL+YVSuZxViGM8i739e/l9tNTj
	pyIqT/S/ZY9nzmdAlNxnHpgJdXPcid647C84hE60c6f2LXSuCpOqqD0QcfOedjLu97TV6XdrCwF
	CRQgXbdH3EIQBfnNqYcLiQoIl88VxZgbjFhyaWTMuZGwcnnwG1b6TTrLMMbF31mD5LF58hGXUi6
	EJ/TIksy6WP2gx9F0Ffd2HJk6idAkRPumA5YqPxj6MXFgSHTd8lP5MveGvXhq2VrUwQxHnumPFq
	7Vw2i04wXNyOWW48nppA7ztuFa9gYkAIm9plykPlXM7DlRCE=
X-Received: by 2002:a05:600c:8b55:b0:495:3de8:33a6 with SMTP id
 5b1f17b1804b1-4994e7cdd39mr269199205e9.16.1786050259636; Thu, 06 Aug 2026
 14:04:19 -0700 (PDT)
MIME-Version: 1.0
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 6 Aug 2026 14:04:06 -0700
X-Gm-Features: AUfX_mxaCgp8oYES6RNp3g9or9e5V5Tk3wVFme00shwxNtlto6HFGbmfyuWHQps
Message-ID: <CAJnrk1bk66ZhRAS7mojSnD5RBfFS+0ChAPymE3ObRWr0C_udWg@mail.gmail.com>
Subject: memcg stats flushing (WAS "Re: [PATCH] fuse: disable default bdi strictlimiting")
To: Yosry Ahmed <yosry@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel-team@meta.com, 
	fuse-devel <fuse-devel@lists.linux.dev>, Jingbo Xu <jefflexu@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: p4rzcqby1ceoxdnmr4rpqqogetcirhxp
X-Rspamd-Queue-Id: 662DD4000C
X-HE-Tag: 1786050261-802824
X-HE-Meta: U2FsdGVkX1/UyGxdFGoQMfh+0Ry/t9STV7xVANMO6ljBqTAAuJ7r3L0RKNQkIxQEvJck8olC57AS0ddMHvZ2T16FPHvm0i+JEPX+b9YrCnSI4SPQ24SafqUP4H8ooOKlvFZVv2MoAlB1sk1uVfeGHmYefN/Y7LqzugJ7xrDJQWqctfjyUyGWGXUMOqb//mVk5hKUyCvzmvxaAGsJNSvFx/t5iDTxppTBuzXzHBhgTlS6oxRJrJzqfK+hWgtM4ETeeyzu2wv64PC/Etzp1bvTX8IGfKk6+XLbGaSO5+5I5quIb0l1OEebzx25Gw5o6juhEEw1pLEiU/akxyQNUCD1DL+zw/hR6e/Jw3k2869TiRo7d/66+iSvSvDdYscbNP2OcqFPuZEKe+dKpWxTy4+07UrXiL3imzgUpHtvonlbjDjqOf6aE1dIbonYLB/EKG8O/focuWCACK1LUNR47vIZPVtF9cUCab2wHkoJ+vcgKLV/3LriAkZgdOMPwGgxoco5E/IHG6B1D7eXc4XY88LUvlADN5uJcwmGSE1FXi86an26ERjOM7hwOEukijVR+dgrwXV8PX3C+NWkJbQ3T9LJOPXanljlxxKfPKpK89aBmlfHM9sDeCjfhBKkrmDDXge1nKWhEk7Gv3jQqFYX0yMGTUK9MQDGHsirZdnMr8AoxsjzlI2HTxD1viRbmdqHMkzAY91SSF+zeFTTab7tjI6wjPIQ0yq9LAelh/4WeRQMBuzGe9ekHVeNPkLsSyJfz3h88+ysPVL9dt77fMta2LDolquR8HtFHQlSfS7SWByBCrbqvKkQcWWWAp9/ta/3xeems9ku9Sw2T1M33nyPOPuWK1UtsNZzJBsKiCZh+Mmcf6tlFYiYl4oT1mzrVCijmG/0Iis8CCsbcgFStdoNPU0Ye+IrAdDlAlyu+NFMD75aGpuZ41Lk/gMJV7hxf3Xf8MD3voBQ+DUifumugrWW/JI
 cLKyuGfr
 JZbyFDsBBu9ANqOrhdlvEuksxvYdWgOsHz6O49SuFCJ/ngQ9+qiwt3YQkWTljW7XzB/LIObhIYi8aOpWWuuNcPRt5H2Bjr95rGaIqgmmIegFELd4SOh1pMhM+SLR27UyDGAl7sdOuZinqluOswaW99gHopsR6L6OEQrXmFN5uPf27aVXXTZBQWlJkvefqaHgFDjU/W/4WCVXUWnzNbd0dJM/pC6WQLZmFhdxPDsChkdw5+RSaDv8xEvdf5xUP6Ivshc1MjgksHv5R9KsWsVWLa+2FmtyLzu80UvpI95N/WTYJiWBrV7BmotddY9Qj2o5X4t/tL+kaAj0Pqg83jRdzX7UorN1skpu6b1LLp2xX7N/A6vB2jQzh/X3RT0PPorw0vqnY2HuF7Xb20KEtszw3F9MYH0BX4YZqpnJG/LHXjwnWW+HTeYvFTb2gC/7NXiZ3+NVy/iENwE3ikVw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yosry,

On Wed, Jul 22, 2026 at 1:38=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> > > > First let's see if the general solution is doable and simple otherw=
ise we can
> > > > explore use-case specific solutions. In extreme case revert is an o=
ptions as
> > > > well but I would prefer a more sophisticated ratelimiting (that Jan=
 suggested)
> > > > than a revert.
> > > >
> > >
> > > Sounds good. I'll keep an eye out for the work Yosry's doing on this
> > > and look into hooking it up to writeback if/when his general solution
> > > becomes available.
> >
> > I am not sure if I had in mind would generalize well. For zswap, I was
> > just going to replace rstat with per-memcg atomic counters, and simply
> > walk the cgroup parents in the update path, as the zswap load/store pat=
h
> > shouldn't be too hot.
> >
> > However, looking at other in-kernel flushers (including
> > mem_cgroup_wb_stats()), I see they consume other stats like
> > NR_INACTIVE_FILE/NR_ACTIVE_FILE, which are updated in the page
> > allocation path. I am not sure if a cgroup parent walk with atomic
> > updates would fly there.
> >
> > A more problematic one is count_shadow_nodes(), which consumes slab
> > object stats. I think we definitely cannot do atomic updates in the sla=
b
> > allocation path. Although it seems like count_shadow_nodes() is a rough
> > estimate and perhaps we can forgoe using the stats there.
> >
> > If we want a generic solution for in-kernel flushers to improve stats
> > accuracy without killing performance, I think we need a heavier lift to
> > rework rstat or move away from it completely.
>
> (Adding a few more people and mailing lists)
>
> So I experimented with a per-memcg atomics in zswap (see [1] for
> context), and it appears to be too expensive even for updating the
> zswap stats during reclaim / swap faults. So I think zswap will need a
> similar approach to writeback and other in-kernel users.

Thanks for running the experiment.

In a previous thread [1], you mentioned your team was investigating
some premature OOM kills that might be attributed to this same stale
stats issue in the vmscan path. Did that turn out to be the case?
Asking because if so, that might be something we'd hit at Meta too.

>
> One idea is to keep per-CPU per-cgroup counters, but on the update
> side we update all the parents' counters, instead of just updating the
> current cgroup's counters. Flushing the stats then only needs to
> iterate the per-CPU counters and doesn't need to walk the cgroup tree
> at all. There is added work on the update side, but hopefully it's
> cheap enough to update per-CPU counters, and cgroup hierarchies aren't
> usually too deep.

I'm not sure about the zswap case, but for the writeback case there
are significantly more updates than reads. There are four stat updates
for every folio that gets dirtied / written back, so four per page
with 4k folios, while the read happens around every few hundred pages
dirtied. In the scenario I was testing with memory.max set to 8 GB and
using the default 20% dirty ratio, during freerun the stat gets read
once every 256 to 512 pages (with flushes happening less frequently
than reads).

I'm not too familiar with memcg or vmstat so apologies if this is a
naive question, but does it make sense for memcg to just do a similar
approach to what vmstat does? As I understand it, mod_lruvec_state()
updates the node counter and the memcg counter (if memcg applies),
where for updating the node counter, mod_node_state() does some
batching where it updates the global counter for that stat only once
it crosses some threshold (pcp->stat_threshold). Could memcg keep its
per-CPU counter as the accumulator but once it reaches some threshold,
it then propagates it up the parent/ancestors into a per-memcg atomic
global counter? The atomic would then only have to be touched once per
batch than on every update, which might eliminate the overhead of the
per-memcg atomic you saw previously? It seems like this would get rid
of needing to do any flushing altogether, as we could just read that
global counter directly.

>
> A more radical approach is to completely drop the per-CPU rstat trees.
> So instead of walking the parents to add them to the per-CPU tree, we
> just walk the parents and directly update the stat. The flush side
> will then always iterate the per-CPU counters to accumulate them. With
> this approach, the update cost roughly remains the same, but the flush
> cost changes. Instead of walking the trees and flushing all cgroups,
> but only doing it on CPUs/cgroups that actually have updates, we
> always iterate and sum the per-CPU counters. The average flush cost
> may become more expensive, but it should be more consistent and won't
> scale with the cgroup tree size. I am not sure if this would be a net
> win or not.

I wonder if this scales for machines that have a significant number of
cores? Onsomething like the 96-core / 192-thread machine Yunzhao
mentioned in the zswap case, it seems like the flush now would have to
touch multiple additional cachelines per CPU when it seems like for
the majority of the stats, only a small fraction of those hardware
threads would have any updates on them?

>
> We can also choose to do the above for all the stats or only the ones
> used by in-kernel flushers, the latter would probably perform better
> but at the cost of more complexity.

I agree. For the writeback case, afaict I think we really only need to
do this for NR_FILE_DIRTY and NR_WRITEBACK, neither of which are
updated from the page allocation path.

>
> I honestly don't have any time to pursue any of these approaches, so
> this is mostly just a brain dump. But I do think we should try to more
> systematically solve the stats flushing problem as it has given us a
> lot of pain over the years.
>

Thanks for writing up your thoughts on this - I found it helpful!

Thanks,
Joanne

[1] https://lore.kernel.org/linux-mm/CAO9r8zOiwgG80EjqdZFgWQvODUe1RzecLemxc=
B7xXNm_f3XfbA@mail.gmail.com/

