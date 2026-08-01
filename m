Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF422C5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 07:33:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67CFC6B007B; Sat,  1 Aug 2026 03:33:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6548A6B0088; Sat,  1 Aug 2026 03:33:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 569D56B008A; Sat,  1 Aug 2026 03:33:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2B1B86B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 03:33:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A1D7BC0260
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 07:33:57 +0000 (UTC)
X-FDA: 85051886514.29.4FA5B5E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id C0B08140004
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 07:33:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gm617/Bu";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785569635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5NfBGb4LzN0NMwlvBky1e9tRTX41H/mzVNYjI/uiqak=;
	b=UDp0WXVHU41BlouQEaw7W1wmCeLU6f9utECp9XWXYXhD1uBtoK62ecSLyQn6+jgr15HpFe
	AQWhlwn4kHmdLBJZ4DHUz5XFuKQUvNS1zCR8qJOFTRlG0xfiZwYvZtIbgtevF4bBNeIr9g
	P7SCi0ACbggX5ROqk6vM9tZ0lFZctB8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gm617/Bu";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785569635;
	b=TGz56ASZUP+imuDR1zwjtTV1n0aRS/jx2dovB6/FSAWYge4Lkezf6chA/PkiQTsJDobIkL
	oKgRCqRF93UC+3BFc1dIwqlLkZq2KzC/LyBsjvRbcXqut1JGm4iZreGGtmbwvNvKAu8pJq
	DCtfyK7GwdTccuPr3SwGwFXtuiUOvPo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0577A60A97
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 07:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA291F00ACF
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 07:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785569634;
	bh=5NfBGb4LzN0NMwlvBky1e9tRTX41H/mzVNYjI/uiqak=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=gm617/BuYiA7R+HhJfu8ELLiu3Ddyi7Px6upn24nbJSpmxkusOamZftSWfliD3b9N
	 wSUytZNrdGKsmz7XPzbjaR6EKbNt7/bbONGCCnLtJjQO8vXiDKQzz3o9CnDMA4AzEn
	 moZo//oB0mdfYjaX+2vNaPdKVg4PGFLITLqdL1DYlQ1v30km8LuOVhsvKPhY7oU6TA
	 ny62t461f5nHzHtMcfBOBMl6aXFw/8GGmcRfGi+DSW2JlqpSyJ5a6NohTtnWgad2TD
	 N8HnOLSXWA852+9Qg+JrPItpjuu97xDPdcCNDURxsG4UOth8hAPKKHD4PblciMOo8t
	 xa/dFrZ6iKBlw==
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-92f03daaa97so105623785a.2
        for <linux-mm@kvack.org>; Sat, 01 Aug 2026 00:33:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpPj1l3Jpl4ya0YRvGBnXhHUgSjaNt52TO6JNDyUqyIXNfSi5+arj8MzbwC2dfyqWPbslvaBpGz4w==@kvack.org
X-Gm-Message-State: AOJu0Yy9/LtiFAbYW2XMeAOuaMMagR4Jx4xVndkmcpovXy+qVzHDPwD2
	unlevr3qonyeO3mFpADt5rhJYgae668duiQl8/7sJL4SxsYpjhKaJISPlzGDsAvi658LtsrsXK3
	vvQHkx7tNBH/cDzcDlYi3z/0HxbxMw6g=
X-Received: by 2002:a05:620a:2417:20b0:92e:5d19:bf82 with SMTP id
 af79cd13be357-934a07b3dd6mr421186185a.17.1785569633921; Sat, 01 Aug 2026
 00:33:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260707201735.4113107-1-joannelkoong@gmail.com>
 <20260707201735.4113107-3-joannelkoong@gmail.com> <584098de-dd48-4004-8e7e-3d826e60c860@kernel.org>
 <CAJnrk1Zc1cZa5edmb6Z18nO3xfLBww-7wobxkOe2OJmWE9qzpA@mail.gmail.com>
 <7da62e60-6ce2-411b-acaf-f9f77ef34752@kernel.org> <amoWjOnPayHVQU9v@cmpxchg.org>
 <b93cde83-0ce3-4db2-8e53-29864027d655@kernel.org> <amtv0YRbSrN6iUEo@cmpxchg.org>
 <CAGsJ_4yWAUcXmVr7Oe1V42szqi2Od-0MhDBspNKURZcBnub9+Q@mail.gmail.com> <amy5ZKC2Kc7RX94Q@cmpxchg.org>
In-Reply-To: <amy5ZKC2Kc7RX94Q@cmpxchg.org>
From: Barry Song <baohua@kernel.org>
Date: Sat, 1 Aug 2026 15:33:42 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xhbEAiLFt-3N7738zJDoJ=hPRYLpP3tpU2sGOz=ORiaQ@mail.gmail.com>
X-Gm-Features: AUfX_mzI3StVQwWDWf6xvZkMTTp6MkStMq_C92PyYuXDpnieQDfLmnmlfHd6puk
Message-ID: <CAGsJ_4xhbEAiLFt-3N7738zJDoJ=hPRYLpP3tpU2sGOz=ORiaQ@mail.gmail.com>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C0B08140004
X-Rspam-User: 
X-Stat-Signature: d9cpi6tb8bur3eqyuuref9b5kuphf1zc
X-HE-Tag: 1785569635-729824
X-HE-Meta: U2FsdGVkX1+f8j47mazGmz2pGmXSNpm8TrRAxJHTxlY/px1yrGsRcMv4zBspkRTG/AwPWHX0tMDVYRN7TzN5n08T9reN2wMD8lA4Z1ww7JyuqEAW6eiu3Cmp3GoqiE3FIS24a15wcUjQZ3Fd7nebhIIqHkp46TroN4j1YzqB0Z6Wf5quWGFJCekGDOmCwiRDqJOo298yU1mtF83tMWKV+qUX4tRhejkBzSh92pgmLIXcJP9JmVSA2IhYt3YjLQWwPeZWae7wd5EtypxdDTPFEl67K+zPVCF0/w4ed89d/9N1dHly9jSq8nTECo5YKu1n3b8yjJawjsB7q8kwXfRxBLaAgFemaBwQ9Op9ClFMrQwg3FjQZfQaqL2q0K8+kMRiVpXUslfY9jr/jzHq8UrH3HgTK51Ka3j1q73hY/d2W1tQngnwVttI/jihkmgP3mzr+olNMIa2nrakLqtOxeXaBzxHUxZpJcfFkYQmpG3hwz2RAqD8UT0ROwMFu3RkaNphT1ANZoMw8r0k1GUeWJdZXKkvhDDXZ2o1KczuJj2QI+nSdeCSCtp0EDWf7OdUugpkDA9UFPSJMSBicKRbt562nxARFJvEONWgtZlrcSRb9h3vYB1qqV6Z1wECxatvT6fiDzOPQn+7Af5kBXXOmtaB0+LaCIceVbFPPR+MKzqSglloHvbIGehbzzdhwx/Dz9oLC2YhZ+SqvoB53lNv1UY0W23Zm5+eMNV/ljT/CAPCWnx8beuK1aBRvbhNN/Kpnyi0UrhEvcm/ho4uJ+UEh5NkcFIffbww6i0ZaSa4SDLDTNFiSmBEPiW6oE7oH6jiOcRcOaGF+MpoQUvg6niaYlSX3Zw8t+a0joUpUTUWdY+OCHFZ0vwARyLdPf+Q/YYYSmz79+TkIT5O/SxOMNgjEgHaTZRaSTQllk04bHCgv0xjWpvwRQ4NPABvQh90bX8iH0RtJLi7uBdoZ3UQTyroZgi
 0U6nWw2F
 whmGrtOw763kMRS/byhEFnbPn/YGzXWNTDMPpnnKst++lEZsd/mjKPGyiJSPQ2MYhAL8xDYZs+f50C+LwqPwSgCdvuc9X45dg73A3PhjppadWkqKA5imU4Av/mtAf6XI481zCEIraO1SKKwnFrh34Jvwb4FX4SEoc1kL65Wy0qztZ+8CMosfmqN8b39hBPycsPTW3bjJKK8W0CUt2wVBn+E3kwgv9L88524/JFj1G6+/QwcecGHDuB0AEb+Gn3u8aTOiZ9/Ir/L7ERR2w1UAEvNsFkJg2M1BIm4jR1TwCRBxlbKRw09P9c2gDjwCeC1dEtZawO2Zx7XdK4yaLpdFl2V9e1YDY91MS7gXlChz43no/QcsdY2pxHlCGQaZR5SEZdg0c4TWRQ0J8UU0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 11:04=E2=80=AFPM Johannes Weiner <hannes@cmpxchg.or=
g> wrote:
>
> On Fri, Jul 31, 2026 at 05:31:20AM +0800, Barry Song wrote:
> > On Thu, Jul 30, 2026 at 11:38=E2=80=AFPM Johannes Weiner <hannes@cmpxch=
g.org> wrote:
> > >
> > > On Thu, Jul 30, 2026 at 03:46:25PM +0200, David Hildenbrand (Arm) wro=
te:
> > > > On 7/29/26 17:04, Johannes Weiner wrote:
> > > > > (2) With a mix of basepages and THPs, there could indeed be a lot=
 of
> > > > >     basepages ahead of underused THPs. That means swapping before
> > > > >     getting to space that is much cheaper to reclaim.
> > > > >
> > > > >     The current setup isn't perfect in that regard, as the shrink=
er
> > > > >     runs simultaneously as the LRU. But it's making guaranteed fo=
rward
> > > > >     progress through the THPs, even as the first LRU pages are sc=
anned.
> > > >
> > > > The shrinker would obviously remain and scan the list for candidate=
s.
> > >
> > > That's slightly different from what I had pictured. But I don't think
> > > it changes my arguments much.
> > >
> > > > We might want to remember how man / if any such entries we have on
> > > > the list.
> > >
> > > Right. The question is how does the shrinker actually find them:
> > >
> > > > > (3) The anon LRU has folio lifetime, but the splitqueue is one-sh=
ot:
> > > > >     we scan each THP once, and then it's either split and dropped=
, or
> > > > >     found full and dropped. That THP never needs to be revisited.=
 The
> > > > >     queue actually empties as the workload establishes itself.
> > > > >
> > > > >     The anon LRU ~ splitqueue argument is only true around startu=
p.
> > > > >
> > > > >     If we used the anon LRU, we'd need per-page state to avoid re=
peat
> > > > >     underused checks. And we need external state to not scan the =
anon
> > > > >     LRU at all if there are no new THPs (and no swap). And if tha=
t's
> > > > >     just a counter for "new, not yet scanned THPs", a single faul=
t
> > > > >     will cause you to walk the entire anon LRU before you get to =
it.
> > > >
> > > > Remembering "not yet scanned" through a pageflag (for large folios)=
 is indeed
> > > > very easy.
> > > >
> > > > I don't quite understand the "a single fault", can you elaborate?
> > >
> > > Let's say you have a 1TB host with 800G anon populated.
> > >
> > > The oldest folios on the list might be THP. The newest ones might
> > > be. You could have a mix of basepages and THPs. The ordering
> > > constantly changes as the folios are aged, rotated, reclaimed.
> > >
> > > How can it find a handful of unscanned THPs in an ocean of folios?
> > > Even if you mark the folio state, that's hundreds of millions of
> > > entries whose state you have to check in the worst case?
> > >
> > > The lru lock is one of the most congested MM locks on large
> > > machines. *Maybe* you can do it locklessly.
> > >
> > > Maybe you can add thresholds where you don't scan if there aren't
> > > "that many" new THPs just yet. That means magic numbers and reduced
> > > predictability.
> > >
> > > Maybe you can be clever and scan from the head of the inactive list
> > > where (most) new folios start. You still need to skip over basepages
> > > that faulted after. Skip over the referenced pages that have been
> > > rotated around concurrently. That could mitigate some common cases,
> > > but not the worst case.
> > >
> > > The search pool stays enormous for the entire runtime of the
> > > workload. It never gets better, never converges. It continues to
> > > include every other irrelevant anon page, and every THP that you've
> > > previously scanned already. A single new THP fault and the search
> > > problem starts over.
> > >
> > > I just don't see how that's algorithmically sound.
> > >
> > > > > So I think reusing the anon LRU is flawed. It's fundamentally
> > > > > different needles in fundamentally different haystacks.
> > > > >
> > > > > If we can agree on that, then the lock contention problem has a
> > > > > different scope as well: it's a simple optimization issue, not a
> > > > > fundamental data structure arrangement issue.
> > > >
> > > > I don't agree yet :) But maybe I am missing something important.
> > > >
> > > > Note that the "simple optimization issue" is not so simple once you
> > > > realize what kind of a pain the batched LRU already creates us when=
 it
> > > > comes to predicting the number of expected folio references.
> > > >
> > > > It's a pain I don't want to extend to other areas.
> > >
> > > Since we already need to do it for the LRU pages anyway, isn't it a "=
+
> > > in_deferred_cache(folio) extension to existing refcount checks?
> > >
> > > I don't want to sound dismissive at all. It's a problem. However,
> > >
> > > - it seems way more tractable than the shared list,
> > > - nobody has produced hard data to show that either is justified.
> > >
> > > > > If I understand you correctly, the concern is that people will en=
able
> > > > > all manner of mTHP orders, and 99% of the anon faults, including =
all
> > > > > the order-3, order-4 pagelets, will go through the list_lru lock =
on
> > > > > fault, with no batching.
> > > >
> > > > Yes. See Barry's LRU cache change I linked as reply to Usama who is=
 looking for
> > > > example at a system that mostly just uses order-2 anon folios.
> > >
> > > I took a look, but I just see a microbenchmark. That doesn't seem
> > > enough to make a proper cost-benefit analysis on the complexity that'=
s
> > > being proposed - whether that's a shared list design, or a splitqueue
> > > cache.
> >
> > Hi Johannes,
> >
> > Sorry for being lazy and not including the necessary background in the
> > RFC cover letter.
> >
> > The background is that our goal is to enable only order-2 (16 KiB)
> > mTHPs on Android. Based on our long-term experience with large folios
> > on Android-like systems, we believe this offers the best tradeoff
> > between the benefits of mTHPs and their costs, including increased
> > memory footprint, fragmentation, compaction overhead, and internal
> > memory waste.
>
> Thanks for laying this out!
>
> Again, IMO the microbenchmark was plenty justification for using the
> LRU cache, no worries. That's a straight-forward plumbing change. I
> was just saying we should probably know more before pursuing a much
> more complex direction for the THP shrinker. So thank you!
>
> > Specifically:
> >
> > 1. We obtain most of the performance benefits of mTHPs, including, for
> > example, a 4x reduction in page faults, faster memory reclamation at a
> > larger granularity, and making it easier to allocate higher-order
> > dma-bufs. While larger mTHPs can further reduce page faults, they also
> > increase memory footprint, which is a significant concern on
> > memory-constrained Android devices.
> >
> > 2. We minimize the internal memory waste associated with mTHPs.
>
> This is kind of tangential, but I'm curious if you would have
> experimented with larger folios AND the THP shrinker?
>

Haven't tried it yet.

A key difference between Android and server workloads is that Android
typically has many applications running with frequent
foreground/background transitions. When an app moves to the
background, much of its memory may be compressed. When it returns to
the foreground, it often allocates a large amount of new memory,
creating significant memory pressure.

If we need around 200 ms to cold/warm start an app, allocating 2 MB
folios and later splitting them into smaller ones via the THP shrinker
could cause us to hit this shrinker path directly during the app launch
process. For example, we may spend the first 100 ms allocating 2 MB
folios and then the next 100 ms shrinking them back under memory
pressure. This would be quite ironic for Android :-)

Since Android app launches can demand a large amount of memory on
devices with limited RAM, keeping burst allocations small is also
important.

> In Meta, 2M thp=3Dalways without the shrinker would also not have been
> tolerable. It OOMed immediately on a large number of services. The
> shrinker *is* what allowed us to use such large folios to begin with,
> without the internal memory waste problem.

My understanding is that Meta's use case is a service that is already
running with 2 MB pages, and later additional services start and
require more memory. In that case, shrinking THPs from the existing
service to free memory for the new services makes sense to me.

>
> > 3. We can use a lightweight compaction strategy that only needs to
> > satisfy order-2 allocations, keeping the compaction overhead low.
> >
> > 4. Combined with large-block compression and decompression, 16 KiB
> > pages provide more than 80% of the CPU savings and compression-ratio
> > improvements achievable with larger folios[1].
>
> That's very interesting, thanks for filling in the details. How this
> jives with compaction and compression units is clever.
>
> > For such a system, I don't think adding these folios to the deferred
> > list provides much benefit. Since the mTHPs are relatively small, there
> > are unlikely to be many zero subpages. Even if there are, they are
> > likely to be short-lived and will quickly become non-zero again as the
> > workload continues.
>
> That's good to know as well.
>
> > But I can see the benefit in Usama's case with 2 MB mTHPs. For larger
> > folios, adding them to the deferred list could be helpful.
> >
> > [1] https://lore.kernel.org/linux-mm/20241121222521.83458-1-21cnbao@gma=
il.com/
>
> Here is an idea: the THP shrinker will not consider anything unused
> that has <=3D max_ptes_none zero pages. See thp_underused(). Joanne was
> proposing to scale this knob down relative to the folio size for mTHP
> shrinking. What if instead we kept the meaning absolute?
>
> The knob is an expression of how much waste the user is willing to
> tolerate per folio. If the folio order in question couldn't possibly
> have that much waste in the first place, we don't have to queue it?
>
> Something like this:
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2bccb0a53a0a..1670e9869bd3 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4364,6 +4364,9 @@ void deferred_split_folio(struct folio *folio, bool=
 partially_mapped)
>         if (!partially_mapped && !split_underused_thp)
>                 return;
>
> +       if (!partially_mapped && folio_nr_pages(folio) <=3D khugepaged_ma=
x_ptes_none)
> +               return;
> +
>         /*
>          * Exclude swapcache: originally to avoid a corrupt deferred spli=
t
>          * queue. Nowadays that is fully prevented by __memcg1_swapout();
>
> The setting defaults to the PMD-1, so out of the box we wouldn't queue
> any new orders. It would allow that 2MB on 64k ARM usecase, without
> jeopardizing smaller mTHP usecases like Barry's.
>
> Thoughts?

My understanding is that adding smaller folios to the deferred split
list is not the right approach. We could end up with a very large list
where we cannot distinguish partially unmapped folios from fully mapped
ones. For example, the deferred split list could contain 100 fully mapped
folios but only a single partially mapped folio.
Moreover, for smaller large folios, the number of zero subpages
is likely to be small and short-lived.

However, this is probably fine for larger large folios, since it is
unlikely to significantly increase the size of the deferred split
list. In other words, the deferred split list should remain manageable.
For the same reason, larger large folios may not benefit much from the
LRU cache either.

So if we have some mechanism to prevent users from doing things that
are not beneficial, such as adding smaller large folios to the list, it
seems reasonable to me.

As a side note (I'm not quite sure whether this is relevant to this
discussion), one thing we tried previously as an out-of-tree proof of
concept was:

for (pfn =3D start_phys_pfn; pfn < end_phys_pfn;) {
     folio =3D get_folio_from_pfn();
     if (folio_is_zero_fill(folio))
            swap_out(folio);
     pfn +=3D folio_nr_pages();
}

Then I was using my previous patch to remap it to zero-pfn if someone
reads it:
https://lore.kernel.org/linux-mm/20241212073711.82300-1-21cnbao@gmail.com/

This does not depend on any list-related logic. We can scan all PFNs
within a short time.

Thanks
Barry

