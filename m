Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAC1DC5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 20:59:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B470B6B016A; Wed, 12 Aug 2026 16:59:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF7D76B0172; Wed, 12 Aug 2026 16:59:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E66A6B0173; Wed, 12 Aug 2026 16:59:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 564196B016A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 16:59:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D3ECE1A0499
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 20:59:43 +0000 (UTC)
X-FDA: 85093833846.30.AB0F850
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf04.hostedemail.com (Postfix) with ESMTP id E38DC40007
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 20:59:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fOQaGiE2;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786568381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cG6kQ9uiiQnTnSbk7yBwezCJNC8B3xUK4sacoj5tne4=;
	b=3vOuIeekMc66Y18AoA67InthTZZ1nG+sZ9/9UXvdCiJF/U9oKKPr3rZYXoyncXHP595cZH
	eZ0wXmDdbBro/E1GXnH1FtLyHYBpRrZmo9ADnIlKT5nd2U9YqZTOCLzF7KtFCPlNrAFseN
	JlhWbnvLVYM6LOIgYe4dNIzK1yurHtc=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fOQaGiE2;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786568381;
	b=rKAm/mMP3qIVeaQevY0WbJGpOoEBO60TOUaKtmww1DHPhqRYnsyI6/wsRF4ucRxOvKVDCi
	1mSAZBe8OFFignwtPA2wzckOTW6FEvUAyQK6rFiAectoAdbOsJ5K3lLYg21dKCRexOHFY7
	EsYYlR6pGI0ix3CnnRMyuxJEWYmXvi4=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-4798bea72f9so744583f8f.1
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:59:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786568380; cv=none;
        d=google.com; s=arc-20260327;
        b=eeOWKfxUyXmGKQjzKOOICtLsvr8niXo7hXumu92bNlIyP0A99o44NSjGAiePVKx9tm
         7ba3w+Wx+DIdWx+k0YOHlImsKvFsKYTVM6j1f3sRW8Fov5o9C+mgMEAB1oaWvjFLo1lH
         poX/+ppOATo/QPfpkIiVgS1kiAJLUt0EtxZr0YmCu0MkCt1aOEUNWs8E5ZwyYepmEXyL
         Kc3LLpYLdoGey2D1em+5e5ctoy22Gc60ExFE+1Y4PYDaIrS9Tt8BSDQAuX7cuQfVawLD
         YUKb8v9NDcOuz5h8fXSrWoEq9w4Tz2KRMtA2YbYMBvB2Fx2Xbu4b0KR2OeEY7kVtD6Z/
         lYKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cG6kQ9uiiQnTnSbk7yBwezCJNC8B3xUK4sacoj5tne4=;
        fh=zMrphilSGe1GLQq797OABetX/N4TTeCZKKFFFyY4MbM=;
        b=PyxTHzOnaSolH8hNJvkeWQOU/I8BsPTleDbjrJ4T7VWlxdVy33kHScEE1p/LueyG9g
         neMcYuNgh/S3hmI0KNWa4NO7grTW3jEGb9ORByzvv0nerx6inTWnthCpluvlSSSAw7K+
         Nh5R8iHgT+MFGQjN3caEWV3DW9zPMet8Ap5xCbEEa6NLdvBIzOTX4sPR1kPuv3jra9qj
         /lNW/DYmpSKi2BpQ1HPAJ+9zthlcmE40Ng76q5F8C4OmvAGLaui7Rypi9cQUpmaNA5BI
         D//nFv2bt0O3v0jcfclL4xuIhhy6PfpM+zTK7IgOvXSbVknYpDONVQ2hT+NETbBJone5
         G1Hg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786568380; x=1787173180; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cG6kQ9uiiQnTnSbk7yBwezCJNC8B3xUK4sacoj5tne4=;
        b=fOQaGiE2azirxd6PZaa6JQojlAQhEqefRGqJ1bvN2/u7np6yLsfjLWKk+XiXKQL6bC
         oZ+hO7iEgxclpgTdo3UYE+5T0Q9+qfsgh9TbS9bnls3ALf452DWdnSFuz77BdDMsdPXc
         q3C9/j2xzo4VTOdwGOrbq6zo68kZ1wcBT5bsznSZNUfdCozUsfoer1Tgn6v2+r0wUep4
         Hf79f4b7rXjsHcduKzX2eZrRjrbazG2mkSGWU96F44xcUuXMcevgNulVr3fIwMsx/h/8
         aTiENYc+mePgIkirI10+JErDNRhELqcH7Zb6Isov7+NaxomtHJuLOwGiVfSngY3ABYnc
         eqvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786568380; x=1787173180;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cG6kQ9uiiQnTnSbk7yBwezCJNC8B3xUK4sacoj5tne4=;
        b=nYTz7rwBqIWVpYKeifkWJ2FZemSepHA7tfCR64t4OkJbEWDPFEFb+2kqvwt2jrDREa
         xEDqkH2DSxEIJzZMxuefWWtyq7UgUjl3evN8VzVlW66kKffeeQwmnYEVlrI73X81Ekb6
         ZMyyIYfuuFpZjtNCSfArA72gLfK1pNdvn1gMvWOgXLA9qaUd5ldpjb4uEc5mjPSF0I8S
         PyH6v8F4KGlxfoGz3qElzzYzWGsBn8sH9dhJInokaHkCuNUlvmkDNp6HnxwHlMzzu8jw
         gAYOXGKaXDBGdHVkKRO1DXSwv2FTZT3HaWJSS7Yf+A4PtFGtn7PAYp7NSQKJV0lqg0jt
         Y5Cg==
X-Forwarded-Encrypted: i=1; AHgh+RrrnHBA2PQHEjDiPSCJ9Bo6scS4nNbJz6ZlBlSlUyP1SypUhUh4k0/sL7+vIl5r2ol/f/xDDtAc3w==@kvack.org
X-Gm-Message-State: AOJu0YwU65uacuRyTN06gT51+a+iXml5C2IrI1Aa9FWhxGnT8Uf8sBEH
	Sp7Q28KF1ASZVQV46m1ymzAbN3OJx7S057OeZ7iFJKfu6E2BaVCgZ8TIl/XS+WRH3F/TYNvjPkD
	L6fm6o+PUMLCNLuq9ocLIxNxitUzX2Do=
X-Gm-Gg: AR+sD13p5JS8NJ7RAwu+vbPtuDvkjrUmF47Pg8xgs5TQ4FDCTq4g/3fzVoC7BKm99a/
	itO42eZ6tghplc+kydW7p6hEFJNwSlgFtcpL93E2q6FJcscq14S/vivCWIY1PQFGXZ7g0KaDPZ0
	qOKGotZCr9xxH320R+JhU4S+3GhEcAcL8bZ/OIKwCsnXEjI5LeyLAjOIZzXVijS4AeSmCsjkWaq
	AlZx6NKRZylnCmeNt5FcZqe4BQ9G2eGF3ctMg27dUPkraJ5zkbIFcBBL8gkWr8sGrj6g0LbiNTm
	Qs/vIFJ6OB7TNeCfE16jAWiK3R3VQ5tQiDwZO5sxkXvJlJwDr9jRatSuyxMalDhqsShiJPq8daK
	5FbcXVDROFAK3kGqCdVGM4hmJzdiXFAFD79k=
X-Received: by 2002:a05:6000:60b:b0:47f:eb22:4d9a with SMTP id
 ffacd0b85a97d-48159fee3d5mr1167517f8f.22.1786568380185; Wed, 12 Aug 2026
 13:59:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAJnrk1bk66ZhRAS7mojSnD5RBfFS+0ChAPymE3ObRWr0C_udWg@mail.gmail.com>
 <CAO9r8zPpe6fWOSXtRUjFB8WNMroeBqvLT+2QtAU4E27AtLUXMQ@mail.gmail.com>
 <CAJnrk1YifN22mA5PFRVrh3m_ygxax6x4_8nraG2hPqCzyzBj7A@mail.gmail.com> <anpsLy_pCanocgS1@google.com>
In-Reply-To: <anpsLy_pCanocgS1@google.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 12 Aug 2026 13:59:25 -0700
X-Gm-Features: AUfX_mwFa8e6pDMfp1WdXiJ_HKLGDCz9OWII2-x-7qK48Cw8cAhcq_BvLRoXfk8
Message-ID: <CAJnrk1Yoj7fqbzurmHkbA-vegpQu3cf-_dfvKor_VxuNhPR-AA@mail.gmail.com>
Subject: Re: memcg stats flushing (WAS "Re: [PATCH] fuse: disable default bdi strictlimiting")
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E38DC40007
X-Stat-Signature: jctnijrgdorxaqy8o691phzyo8o6mpn7
X-Rspam-User: 
X-HE-Tag: 1786568381-704887
X-HE-Meta: U2FsdGVkX1/uMtLWziDuxRM64NYx0BN9xxzblwULPnRsk8ZMR0TnyrDysRObAe09oI+o+ecpPm8A0erGTO1ZviHOh3mC3qEmAZR/3CmXVqQr2GAich8AgHlbqaEtQ6GHb6z4XVoq/IwNocnsDh5TFymfSdKD8uMiR5yRumczCxId4dQkgayS5KwhVy7bO0RWne5Wd5e6nRY+VhbvwNnWxEu+SBm4XlvnXtX2iGGbxjGVSpJx33RdCw1VzPc2KMkaeENAYMl5HSfK/0doBgmbbl3Hp7OTRqyVOR05CQC7rsNQ/py54KPrSK27iCfM1B0kC0HCVcMHnZqWFp2qpnrCdyk3NS6ZTAWxlaRA7RFXEuiAI0V2+2/kHIWDmRTnPGwLkzUI2AaPbRIwaUiOgqWHhu6OEmILiDNDei0Up2TyUjBRiLUnWJSvOVAjqb8xqmeTeUbW5ZmYDkBvslCQv+QMlh8NvQ+PM1V+d3iOhwf7b4trSw8paLiqw7A1y50sSg2ObaJTm45/GCh1u3WOVmkM44UqD5+ZTXn4np7r3SkDJTEn9w/Y604xZLIVGPd1hIouqnp7049yPnxLj5rq9bIuTeIJgLYT9bJRsMZxGDzIEZrTU1TB4q+d22H6mJdJUaCKJVFW36jxA4XvFwo2/AcNzOB4Mhumxf19NaaYAfyscNhsd4mQHJnwFJ2pMRDziljnptWf51sVBUU/2opc4yqviLpC3lQfel8WpQYJ/MSv9q65bSD15ZPfSMBPS2m6FF2VudXLbThjUI9z09z+ZG/5pVZHHtlJHW35RksD9sVXx7iD7sY1Z1noke6sb5VhZH/BwAagHkydsgJzwZBbV9WGvzPL8y7IMUkEJ9ykCtOee9aJ1Pk55aJzFYrNvj4Uyp7pFuMCeYnuxssq5AM2R5dvLVu3De69o1fxCas2VWqCFxpYJMgX1HsTKVIQOCAIh9tQWTn5hZu06dh6rlHftzp
 bGRcp+4u
 uXUz++zUYGeewneY9ZxIM8S67xmWegOwTdG0yq0WmZRXs8+d8KVALLVxc1VzhU3f0BggaNGDHAmNKW5z0QGYuLphcxO3XHbX0MRh1icAH+W5VUoQ3WsDD1+XQ8z0dYORaGceR5Op8ia+ktu6XevgTJY7FZYOWkspDzm2qfexEm3Hl8z2TqJBJFVF+4cGjGIgtNrKRTAAn+BlCPn9x7O4tAhBxJai0GO/tbeT1JVw9iMHd6SqYDgJtwjQaAyElGiYG5nlYRTirLU3m+JOypGAsgjZOkPXYwg+V9ibfsoiduiPr2IlGP1afp65leM3s8gW5jGOQyTUsBw4jHfvzEhbPUxiWWCUzjzw2pO2H6jO8l3pq9ttLkwZXS/IFdkjTBfYQvrszoMoQnszlgoJLS+k4FKFtztKfo5FRI3oBocIaSZ+FpKAPDY0QMuq+1OtsDsqgJSQLmWTT1CW2nZQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 5:48=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Mon, Aug 10, 2026 at 09:49:31AM -0700, Joanne Koong wrote:
> > On Thu, Aug 6, 2026 at 2:31=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> w=
rote:
> > >
> > > On Thu, Aug 6, 2026 at 2:04=E2=80=AFPM Joanne Koong <joannelkoong@gma=
il.com> wrote:
> > > >
> > > > I'm not too familiar with memcg or vmstat so apologies if this is a
> > > > naive question, but does it make sense for memcg to just do a simil=
ar
> > > > approach to what vmstat does? As I understand it, mod_lruvec_state(=
)
> > > > updates the node counter and the memcg counter (if memcg applies),
> > > > where for updating the node counter, mod_node_state() does some
> > > > batching where it updates the global counter for that stat only onc=
e
> > > > it crosses some threshold (pcp->stat_threshold). Could memcg keep i=
ts
> > > > per-CPU counter as the accumulator but once it reaches some thresho=
ld,
> > > > it then propagates it up the parent/ancestors into a per-memcg atom=
ic
> > > > global counter? The atomic would then only have to be touched once =
per
> > > > batch than on every update, which might eliminate the overhead of t=
he
> > > > per-memcg atomic you saw previously? It seems like this would get r=
id
> > > > of needing to do any flushing altogether, as we could just read tha=
t
> > > > global counter directly.
> > >
> > > The memcg stats perform similar per-CPU counting and thresholding. Th=
e
> > > main difference from vmstat AFAICT is the cgroup hierarchy. In vmstat
> > > we have per-CPU counters and a global atomic counter for each stat.
> > > For memcg, we have the same for each cgroup, then we also have a
> > > cgroup tree. When we read the stats of a cgroup, we usually want the
> > > hierarchical stats including all of its children, so we can't just
> > > read the global counter.
> > >
> > > We use rstat, a cgroup framework that keeps track of which cgroups
> > > have updates on which CPUs, and then memcg has thresholding logic on
> > > top to only flush if the number of pending updates exceeds a
> > > threshold. Essentially, if the magnitude updates on a CPU exceeds
> > > MEMCG_CHARGE_BATCH, we add it to a global per-memcg counter. We only
> > > flush if that global per-memcg counter has > NR_CPUS *
> > > MEMCG_CHARGE_BATCH updates. So in theory I think we tolerate up to 2 =
*
> > > NR_CPUS * MEMCG_CHARGE_BATCH of stale stats (combined for all the
> > > stats).
> > >
> > > See memcg_rstat_updated() and memcg_vmstats_needs_flush() for this lo=
gic.
> > >
> > > Looking at this code again, it made me realize that we already iterat=
e
> > > the per-CPU stats_updates on every update to increment the number of
> > > pending stats on this CPU. I wonder if we can replace this with
> > > actually updating the stat on each parent, then the flush path only
> > > needs to accumulate CPU counters. Or maybe as you mention, we update
> > > the global per-memcg counter when updates on a CPU exceed a threshold=
,
> > > and forgo the rstat flushing logic completely.
> > >
> >
> > I can run some experiments and see if updating the global per-memcg
> > counter per batch and forgoing flushing could be a viable solution.
> > I can use my setup to test it for writeback, but for the zswap use
> > case, what's the best way to test if the changes are too expensive? Is
> > there a benchmark program you're running?
>
> I was running stress-ng and measuring the latency of zswap_load() and
> zswap_store() with bpftrace. But I suspect whatever works for writeback
> should work for zswap :)
>
> >
> > For updating the stat on each parent and having the flush path only
> > accumulate CPU counters, I think this means we would have to
> > unconditionally walk the ancestors + update its counters on every
> > update, as we wouldn't be able to early break if the flushable
> > threshold was already exceeded. I don't think we could replace the
> > stats_update update, as it seems like readers still need some way of
> > knowing when to flush. It seems like this could be a nontrivial
> > performance hit, but maybe it's a non-factor in reality. If you think
> > this would be useful to get benchmark numbers on, I can run some
> > experiments on this too.
>
> I think we need to experiment with how much work we can shift around
> between the update and reader sides.
>
> Right now, on the update side, we call __css_rstat_updated(), which
> iterates the parents and puts them on the per-CPU rstat tree, then we
> iterate the parents again in memcg_rstat_updated() and:
> - Check if flushing threshold is already met.
> - Update per-CPU counter for stats_updates.
> - If per-CPU update exceeds (another) threshold, we update an atomic for
>   stats_updates.
>
> The flush side checks the flushing threshold and does an rstat flush,
> which will walk the update trees on all CPUs and iterates all child
> cgroups on it. Pretty expensive when the threshold is met.
>
> I think we discussed two different options:
>
> (a) On stats updates, iterate the parents and update the per-CPU
> counters of the stat directly.
>
> In this case, we can't keep using rstat, as we would still need to add
> the cgroup and all its ancestors to the update tree anyway and the flush
> cost will remain similar. So on the flush path we'll need to iterate all
> CPUs and add the counters. We can explore if use a cpumask can help
> here, but perhaps not since we'll need to update it atomically on all
> stat updates.
>
> I imagine that if we do this we'll drop the stats_updates optimization
> to avoid adding more cost to the update side. We'll be replacing parent
> stats_updates modification with parent stat counter modification. But
> maybe it's feasible to keep both to limit the cost of flusing.
>
> This only works if the cost of iterate the CPUs on the flush side ends
> up being cheaper than the current flush. I imagine the average cost will
> be higher but the cost should be much more consistent vs the current
> flush, so the tail should be better.
>
> (b) On stats updates, iterate the parents and update the per-CPU
> counters of the stat directly AND update a global atomic if the per-CPU
> counter exceeds a threshold. I think updates may get too expensive as we
> may need to update multiple atomics, especially when updating the root
> counter as it will be contended by all cgroups.
>
> The flush side becomes an atomic read, so should be very cheap, and we
> can drop other heuristics and optimizations.
>
> ---
>
> I think ultimately we need to experiment with these approachs (and
> perhaps others) to check what actually works in practice. You'll
> probably want some benchmarks or synthetic tests with many cgroups to
> exercise the worst case scenarios.
>
> For the zswap stats, I used to run stress-ng with a bunch of workers
> (20, 50, 100, ..) in cgroups of different levels. Since all workers are
> in the same cgroups, all the parents are common and all threads end up
> competing on the same atomics, so worst case scenario. I was also
> testing in a VM that has more CPUs than stress-ng workers, to exercise
> the full extent of the concurrency and contention.
>
> This could be a lot of work, so I am not really asking you to do it, but
> just brainstorming and sharing ideas :)

Thanks for your guidance and insights on this, Yosry! Your responses
have been very helpful.

I'll do some experimentation with this and try to get a sense of what
the update costs are.

One thing I was unclear about and have been looking at is how
pervasive/important this issue is outside of the writeback case. It
looks like there are roughly 4 other categories of users that rely on
stats that can be 2s stale: zswap, cachestat(), working set, and
vmscan.

Of these, vmscan is the only one that looks troublesome. Some armchair
analysis below:

a) zswap (zswap_shrinker_count()): 2s of staleness looks fine. the
stats are only used to calculate the compression ratio and the ratio
scales a count that comes from a list_lru and *isn't* stale. The ratio
is an average over the whole pool, so it seems like that should be
fairly steady across 2s. A stale result doesn't seem too bad - afaict,
it is a heuristic of how zswap should get weighed against the other
shrinkers.

b) cachestat() syscall (filemap_cachestat()): seems preferable to just
rely on the 2s flusher worker. The results are returned back to
userspace and not used for any internal kernel decision-making, seems
ok to have one field in it (nr_recently_evicted) potentially be stale.
Seems better to err on the side of less frequent flushing anyways, as
the call path is invoked from unprivileged userspace and flushes the
root memcg.

c) workingset: looking at the original commits, the calculations are
estimates that don't require exact stats -

refaulting (workingset_test_recent()): commit 9b3016154c91 ("memcg:
sync flush only if periodic flush is delayed")
    Now the question: what are the side-effects of this change? The worst
    that can happen is the refault codepath will see 4sec old lruvec stats
    and may cause false (or missed) activations of the refaulted page which
    may under-or-overestimate the workingset size.  Though that is not very
    concerning as the kernel can already miss or do false activations.

shadow-node shrinker (count_shadow_nodes()): commit d4a5b369ad6d ("mm:
ratelimit stat flush from workingset shrinker")
    On further inspection it seems like we don't really need
    accurate stats in this function as it was already approximating the amo=
unt
    of appropriate shadow entries to keep for maintaining the refault
    information.

d) vmscan (prepare_scan_control()): for determining whether reclaim
can deactivate, there's this logic

                /*
                 * When refaults are being observed, it means a new
                 * workingset is being established. Deactivate to get
                 * rid of any stale active pages quickly.
                 */
                refaults =3D lruvec_page_state(target_lruvec,
                                WORKINGSET_ACTIVATE_ANON);
                if (refaults !=3D target_lruvec->refaults[WORKINGSET_ANON] =
||
                        inactive_is_low(target_lruvec, LRU_INACTIVE_ANON))
                        sc->may_deactivate |=3D DEACTIVATE_ANON;
                else
                        sc->may_deactivate &=3D ~DEACTIVATE_ANON;

(and same for DEACTIVATE_FILE for file-backed folios)

target_lruvec->refaults[] gets set at the end of the reclaim pass. It
stores the same lruvec_page_state() value that prepare_scan_control()
will read at the start of the next reclaim pass, which means if
reclaim passes happen more frequently than the 2s flushes (eg under
sustained/heavy memory pressure), this logic will incorrectly assume
no refaults occurred and deactivation is disabled, which afaict means
folios won't be moved from the active -> inactive list, and reclaim
will start evicting pages from the inactive list that are hot (eg more
refaults).

This is from reading the code rather than a reproducer though, so I
don't know how much this matters in practice. Unlike for the writeback
case, I don't think flushign more frequently solves the problem. It
would shrink the staleness window but not eliminate it. Maybe one
solution is to keep the deactivation state for a period of time if
refaults were observed.

If it turns out iterating the parents and updating the per-CPU
counters of the stat on updates is too expensive, perhaps it makes
sense to keep the existing rstat logic as is and have caller-side
workarounds, as only writeback and vmscan would require them.

Thanks,
Joanne

