Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8C17C55167
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 21:31:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE7E16B008C; Thu, 30 Jul 2026 17:31:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B98A76B0092; Thu, 30 Jul 2026 17:31:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A89D16B0093; Thu, 30 Jul 2026 17:31:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D81E6B008C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 17:31:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1F876A13A2
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 21:31:35 +0000 (UTC)
X-FDA: 85046739750.15.BB4756F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2DC90C000C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 21:31:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cVj/wtOa";
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785447093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z29J3l4xPm9Bm9cw2FicltZjkgLZS1wXEUkuW52Slpw=;
	b=n1iXAZJE0VvZ1UFKRe7eZ8++6nHKjC6H8cuRBGVnRaC6dp7hKZsHwCkNj7tj+jmnzpS+Ek
	U7QAOEfr8MnPHbGpc4+smYw7txoKs6UDoraHs3wH87qeWAvCF49yuCFi51OV64GiEi0f8D
	+pCK083PKWwKbjoM2cHwmyIekhYYWQ4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785447093;
	b=ZRdPTqBiOcGjaDbjr8S6blVgAuGzYzaPzAGNQuvf/hlv8RK7H6XpzJfcMDA50GPrvvOvbU
	dBSUHIHJBqCzjyE410bQ6+AkaE91+9qvsNmMyJ+5jSdZzvMBQNHbwz7aYGm+/bE3922pjj
	ZhATtM6EFyfJH9ouvbfOwaV8PPoNw88=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cVj/wtOa";
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 06827436E1
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 21:31:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF471F00AC4
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 21:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785447091;
	bh=z29J3l4xPm9Bm9cw2FicltZjkgLZS1wXEUkuW52Slpw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cVj/wtOaNiDIeLPVZWskBigZdoEUfkb+Rt6nuy+7Pb04g9w5KgD0MOPXO5KTgFvv8
	 9TDfuph62DCuTAg8iE50TBlS7CSCYfZ7Ms09gACSDhYnCr6Uk/PnK9/QVDK44L3qTJ
	 5KuYcV2Vrd18ayxzY1Ij8afikRD9DwDUwvDb9fUi/Gu52sYJxUGGpwiOTycAcY93j4
	 ZO7wZGpxfk1wyELFNJwXoNjuVaqgvzMraxb0gdAdCkINd97r2jpcSVF+fKv2UxgR2p
	 WnZKjP+o2260TMs//600f6wQgJjJ32G+CvkLLBExmKpjiWPiJNEa0uW1ClBPFixVb2
	 ZYfBf4JuSbydw==
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8ff20870ac7so2442046d6.1
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:31:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqOlZbfRNIbyVHteR7K5lxJuozgdhNkCEdd1JFfI+s/WdrhAaAREjgg72Xz/6HmYpplAW1BLeD8Yw==@kvack.org
X-Gm-Message-State: AOJu0YzFbPbh7kfuvVeLgGWp5tGlJFReU6rUqZBPXthM2UjWYVs83D/s
	CupkOElMebmOikI+jrAt8jfb2NOXHE/5o5eJHRU0mAaxEOWfpH63JEVgsZDMtF1MPNSfcvrcMhl
	ugdmW9q5xCGVRzLhbsZMfEipUDptKnwk=
X-Received: by 2002:a05:6214:5088:b0:8fd:6e32:1aa4 with SMTP id
 6a1803df08f44-9083483a5a9mr47521046d6.62.1785447091190; Thu, 30 Jul 2026
 14:31:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260707201735.4113107-1-joannelkoong@gmail.com>
 <20260707201735.4113107-3-joannelkoong@gmail.com> <584098de-dd48-4004-8e7e-3d826e60c860@kernel.org>
 <CAJnrk1Zc1cZa5edmb6Z18nO3xfLBww-7wobxkOe2OJmWE9qzpA@mail.gmail.com>
 <7da62e60-6ce2-411b-acaf-f9f77ef34752@kernel.org> <amoWjOnPayHVQU9v@cmpxchg.org>
 <b93cde83-0ce3-4db2-8e53-29864027d655@kernel.org> <amtv0YRbSrN6iUEo@cmpxchg.org>
In-Reply-To: <amtv0YRbSrN6iUEo@cmpxchg.org>
From: Barry Song <baohua@kernel.org>
Date: Fri, 31 Jul 2026 05:31:20 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yWAUcXmVr7Oe1V42szqi2Od-0MhDBspNKURZcBnub9+Q@mail.gmail.com>
X-Gm-Features: AUfX_mzSqub_uH6UJY92TU4ZePeFbyNXrk2hqITcfxc-c67VWEt0IELxOcKEVzE
Message-ID: <CAGsJ_4yWAUcXmVr7Oe1V42szqi2Od-0MhDBspNKURZcBnub9+Q@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] mm/memory: add anonymous mTHP folios to deferred
 split list
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org, 
	ljs@kernel.org, usama.arif@linux.dev, alex@ghiti.fr, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	willy@infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2DC90C000C
X-Stat-Signature: wes6mbru8j5yrpouudkhqyezawgmhmdj
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785447093-290607
X-HE-Meta: U2FsdGVkX18p63H11VSOka+fjqC+s8lLmFpiGAY2qJn1C9RsCvP+zBhEnUUL32UvWldgu15rv/qoK88Oo4Eg3OEuAsil6xIVj++n+VxEtwm4BNOOGt3aE2WoiG1UUmSt7MIu7QoOlxcVSGxx6uLvZ7RQz2q9qQDzyQrm2tvGpWusBurHApdMYMU/E7b/yS2YT9/WyO320Dx/Xi+U1dcUVF/5pC5LGl2SX0AdIeQ9sZwmiDUK18eEge0N9SXTeospnfvV2PptfRw/apeMU8JUEVcM2KrrnAfaC/rMVUUpSVqay7wEzqkBijZtRxlI2OOgKegVdBget2UaPsCU+ZyeCiQUDbhBGtPxq7ILdyGl4jFlVKQ2me49fW6hUdMnGGlnMn4rs0tgReNLRf3sodPrG8ZxbK2uBObJDrlkyPVM+RMt/juMT8m3R4Ufyogsr6dHgqwiodJbVXX+1oIPKVvXk0lVBIa+lxfeezyfRcweLn8I9dSlW+p1pKbrhGm1bdqCdQXKI8qWLSIiRpkdRAiB599iipFPfEa6sxc90pJUBETOCMmznI0dF1b8M7OSdCw0kHOPHQFquI4/CG9j3O+JSVqyrE+F5fzJcScUwXRaVpJ6aizKp4RzUHH5HIaCJYY1rbVBKt/0+NHeTfkxv64vQoeySYJebf0tAumNgF1LrPUnLReMnXXknOb+Sh0+Ul24DD58nW+xTt7LsIbt1DKdPw2uVTrXv+mpY4uBT5eqvGZOZsNcFdtv4EIOFlfabCaUab8ukxyHl7K4g86Ne9tTTWsXKTJzOnKndLzVdnuCN72m3lwV8/DXWcvGklL6SaUIijX4Hd/+6CsHQF6UYLUo+DwmI+2OcoanAHI/t3KXC9ebVoJYdXxc2bhbrtttaLrhvPRatk1oonVk/wsn+DLysmzFWoY01r3ovFWaA7g1A3lZZGPY1qIu21jylBCF10BYF2UxFa7FsSsIlsTwhlF
 FF7sjfc/
 wmGXRc+tIt+7/gJZc0tfDRVzBW2ZgLxhxuerarICYabcK1n/BzVSOcB4StIKLMqbLNJmNk9qxSCXyJXsLKeh/2MxrCJjRR68Vcm2X7FFfGi+aITMMChXqujWkPzIgQQBrTrqulT5PxbKHia679nk/a7psUclUPCKBUhnaEHrZ+1aUuZ8WyxREgAmmJ77ZXnV7UGcx6d1C2Emr37WJV4RfDXvY4vJUMMhLqm4D7lpQ7KK7w2rclW5MWABhgiEjg3M2Ukhna4T3zdT6sMWAFFemH0zPViubTJ2Mn9+LY3iSp9i3+qkglfVsJ0i51ay/0urf+Wy8yAYRgHHLJ7a0V/2VWIE82iYhKrQdJFwxHImHwpjSqevMrktOjnO+wUT4mrKpV7NsQGDEx6SZBmQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 11:38=E2=80=AFPM Johannes Weiner <hannes@cmpxchg.or=
g> wrote:
>
> On Thu, Jul 30, 2026 at 03:46:25PM +0200, David Hildenbrand (Arm) wrote:
> > On 7/29/26 17:04, Johannes Weiner wrote:
> > > (2) With a mix of basepages and THPs, there could indeed be a lot of
> > >     basepages ahead of underused THPs. That means swapping before
> > >     getting to space that is much cheaper to reclaim.
> > >
> > >     The current setup isn't perfect in that regard, as the shrinker
> > >     runs simultaneously as the LRU. But it's making guaranteed forwar=
d
> > >     progress through the THPs, even as the first LRU pages are scanne=
d.
> >
> > The shrinker would obviously remain and scan the list for candidates.
>
> That's slightly different from what I had pictured. But I don't think
> it changes my arguments much.
>
> > We might want to remember how man / if any such entries we have on
> > the list.
>
> Right. The question is how does the shrinker actually find them:
>
> > > (3) The anon LRU has folio lifetime, but the splitqueue is one-shot:
> > >     we scan each THP once, and then it's either split and dropped, or
> > >     found full and dropped. That THP never needs to be revisited. The
> > >     queue actually empties as the workload establishes itself.
> > >
> > >     The anon LRU ~ splitqueue argument is only true around startup.
> > >
> > >     If we used the anon LRU, we'd need per-page state to avoid repeat
> > >     underused checks. And we need external state to not scan the anon
> > >     LRU at all if there are no new THPs (and no swap). And if that's
> > >     just a counter for "new, not yet scanned THPs", a single fault
> > >     will cause you to walk the entire anon LRU before you get to it.
> >
> > Remembering "not yet scanned" through a pageflag (for large folios) is =
indeed
> > very easy.
> >
> > I don't quite understand the "a single fault", can you elaborate?
>
> Let's say you have a 1TB host with 800G anon populated.
>
> The oldest folios on the list might be THP. The newest ones might
> be. You could have a mix of basepages and THPs. The ordering
> constantly changes as the folios are aged, rotated, reclaimed.
>
> How can it find a handful of unscanned THPs in an ocean of folios?
> Even if you mark the folio state, that's hundreds of millions of
> entries whose state you have to check in the worst case?
>
> The lru lock is one of the most congested MM locks on large
> machines. *Maybe* you can do it locklessly.
>
> Maybe you can add thresholds where you don't scan if there aren't
> "that many" new THPs just yet. That means magic numbers and reduced
> predictability.
>
> Maybe you can be clever and scan from the head of the inactive list
> where (most) new folios start. You still need to skip over basepages
> that faulted after. Skip over the referenced pages that have been
> rotated around concurrently. That could mitigate some common cases,
> but not the worst case.
>
> The search pool stays enormous for the entire runtime of the
> workload. It never gets better, never converges. It continues to
> include every other irrelevant anon page, and every THP that you've
> previously scanned already. A single new THP fault and the search
> problem starts over.
>
> I just don't see how that's algorithmically sound.
>
> > > So I think reusing the anon LRU is flawed. It's fundamentally
> > > different needles in fundamentally different haystacks.
> > >
> > > If we can agree on that, then the lock contention problem has a
> > > different scope as well: it's a simple optimization issue, not a
> > > fundamental data structure arrangement issue.
> >
> > I don't agree yet :) But maybe I am missing something important.
> >
> > Note that the "simple optimization issue" is not so simple once you
> > realize what kind of a pain the batched LRU already creates us when it
> > comes to predicting the number of expected folio references.
> >
> > It's a pain I don't want to extend to other areas.
>
> Since we already need to do it for the LRU pages anyway, isn't it a "+
> in_deferred_cache(folio) extension to existing refcount checks?
>
> I don't want to sound dismissive at all. It's a problem. However,
>
> - it seems way more tractable than the shared list,
> - nobody has produced hard data to show that either is justified.
>
> > > If I understand you correctly, the concern is that people will enable
> > > all manner of mTHP orders, and 99% of the anon faults, including all
> > > the order-3, order-4 pagelets, will go through the list_lru lock on
> > > fault, with no batching.
> >
> > Yes. See Barry's LRU cache change I linked as reply to Usama who is loo=
king for
> > example at a system that mostly just uses order-2 anon folios.
>
> I took a look, but I just see a microbenchmark. That doesn't seem
> enough to make a proper cost-benefit analysis on the complexity that's
> being proposed - whether that's a shared list design, or a splitqueue
> cache.

Hi Johannes,

Sorry for being lazy and not including the necessary background in the
RFC cover letter.

The background is that our goal is to enable only order-2 (16 KiB)
mTHPs on Android. Based on our long-term experience with large folios
on Android-like systems, we believe this offers the best tradeoff
between the benefits of mTHPs and their costs, including increased
memory footprint, fragmentation, compaction overhead, and internal
memory waste.

Specifically:

1. We obtain most of the performance benefits of mTHPs, including, for
example, a 4x reduction in page faults, faster memory reclamation at a
larger granularity, and making it easier to allocate higher-order
dma-bufs. While larger mTHPs can further reduce page faults, they also
increase memory footprint, which is a significant concern on
memory-constrained Android devices.

2. We minimize the internal memory waste associated with mTHPs.

3. We can use a lightweight compaction strategy that only needs to
satisfy order-2 allocations, keeping the compaction overhead low.

4. Combined with large-block compression and decompression, 16 KiB
pages provide more than 80% of the CPU savings and compression-ratio
improvements achievable with larger folios[1].

For such a system, I don't think adding these folios to the deferred
list provides much benefit. Since the mTHPs are relatively small, there
are unlikely to be many zero subpages. Even if there are, they are
likely to be short-lived and will quickly become non-zero again as the
workload continues.

But I can see the benefit in Usama's case with 2 MB mTHPs. For larger
folios, adding them to the deferred list could be helpful.

[1] https://lore.kernel.org/linux-mm/20241121222521.83458-1-21cnbao@gmail.c=
om/

>
> (As opposed to the patch of hooking into the existing LRU cache infra,
> which is kind of a no-brainer.)
>
> So I still think somebody who actually cares needs to show that it's a
> practical problem, propose a solution and show hard numbers to justify
> the engineering tradeoff.

Thanks
Barry

