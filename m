Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08CF8CD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 00:32:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 392B66B0095; Wed, 20 May 2026 20:32:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31BB06B0096; Wed, 20 May 2026 20:32:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E3E86B0099; Wed, 20 May 2026 20:32:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 050CD6B0095
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:32:53 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9D45A40477
	for <linux-mm@kvack.org>; Thu, 21 May 2026 00:32:52 +0000 (UTC)
X-FDA: 84789551784.18.DC8E1C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id C242F20007
	for <linux-mm@kvack.org>; Thu, 21 May 2026 00:32:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cNuqiR0P;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779323570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QiOSJmVJEVmT+J7pn8bgsJk2U0qn8DEDzaMnP6hN0C8=;
	b=Cird2GXBHzbkRro8564oz7bFP9cSJDTMXa8r2nnrdocWPgNuiiRajTMhtN92Cxp83Q/BME
	8NXv2N45cq6U9SpazwcY2KgRsUY6v4LKaB/MhnZb2vVfUJerG/bJdMFB31ZD9vet1NIVBe
	LpQKkKx9B0qkhts1+vWelK+7DhzVnlM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cNuqiR0P;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779323570; a=rsa-sha256;
	cv=none;
	b=h3b2GDHisge2ZW9EUsu6MNqW9HAlRTFDUnh4E1ZtprcHsCKy9ZYQLO/VjKzTzJz3VuxeAc
	rM21ZO67iuDpXu4C8OBFS2CgmQux26Nr5eHLbggtEDnCW8mOUNWTqD+c5IXQaCyfP3Y4fC
	X1q0NE5JE6iInvtFF3MG/dmV005zSIo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ED73D40DF2;
	Thu, 21 May 2026 00:32:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463871F000E9;
	Thu, 21 May 2026 00:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779323569;
	bh=QiOSJmVJEVmT+J7pn8bgsJk2U0qn8DEDzaMnP6hN0C8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cNuqiR0Pti8JU+upc0tp06LDBYHjsXXAvnXUyRSUoyFtSnQgmF8gzLnZ5gea9+GzT
	 aDG8+HsppNfjIZlENxMYArDKVs4Hq0j5HZRyVJ6j8RBPhmFlaFfGjWUuc6qZUsxi9Q
	 RlgXQ6YxsFc55JO0nZj52wkJ53attyJ/KbhkkkR7IIZZ5247zUrps0BaKKqfVBIm9z
	 gKEIQs8yEAsGSBR9JjNJa4jABTmw9GmjooSjlVdgMZxyUKhIQ+wMsxFY9gGF3u1Wm8
	 ZonDP60aMMXjUL/l1tl3M65n6gdxuFeYNjVqlnNoLKTCAccdpW4jYfb6DuomoKCM5u
	 n+QkbcC4fSx/g==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	bharata@amd.com,
	Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [RFC PATCH 0/7] mm/damon: hardware-sampled access reports + AMD IBS Op example
Date: Wed, 20 May 2026 17:32:45 -0700
Message-ID: <20260521003247.84337-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CALa+Y15fsgb1SU1xBq6BHsgk9QSJr39L5CZSCahpRu7udGuwKw@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C242F20007
X-Stat-Signature: b13f1dcnn1dmngfwet8hkikwhugygpfd
X-HE-Tag: 1779323570-715636
X-HE-Meta: U2FsdGVkX1+el/W9+ku7zlCXh358fOBDEJ3tr5XFMD69HyioPXUOvO6oh8xka6TTg6Cs3Iq6D6kEGwXBZxjBQJ3zFlCx/j9in9nKoBWtRhPW+j8qgnZoVIh+bCOt/a3/3qBAvTwXUx6NQRiF9xwAboWEF9QAvqpgduZiU8PQJgWHFVDq9KxwazXwGfe7LO0WZPydQDpvtnPad200cbfPcpbZoItVYNz742AfftSFgj4LfP18ZNnw2QLYaXWkbRPfe/6+/87E/8TkMwWr5um0vthClfeIiD9bVcEK4OvGf9z4b+D/qalSvWoBDxUM2PRpqHWkRvy4LBZg426P/OpwjF/Sp5OnsNvXoS6NlUwCD6USlBt07f3NaSnis185GtGvGTC+10FwFgorkaQQ+ebaEwTJi7jpcF88aalaikMVF/IO0VRzD1SdZYFnvm0x1L8jIlvtt8hACsw0wlnfVgQlBem9mCWID9IwCCbLsrqp7Q0u7kwrrvbqurzEYuXVQbexZAY559hgWwmdnCs33n169j6HcLmZf6jcgBng1JxgiHaRJ//XYMmqlyz0YzVJYeK60YVr5Hkp+NHSHryo/eyYVsHQ6fTUQBXEMNq7BUquHo5RV64vlSTcDGNoUHI7RURE1XSPg4I8dB2OZVIrwkQSpnu0hKIG7kJTahGWX2281rHvj14K19c9YSFtwLy41JFz6PU5FmwMfzt4OCHAt5NIY/7EgiOmnhPKpxdKnZYe/mkU0z5NbdO1oZH2bYvgxQZLnwyFKUQtvB5rZm+otiSLloYvAYBx9rmOllbVZ5AEr54xYNuPZKV9mowpCZWrzcutWpJTPlpl3twFrZUGFtjZ6PJpAe+TevGD2kFoLCdQ69CrIxaZ8Lfi0YLoZvGOWHNM0CSOTyYBpCcVuq/C1zEWKA0SXULE/Y1AEbncwfrCDB/9txKLrw55Zy0S/bHA6zhiUnE7uGVVRxzpNNDSreM
 alcy3bFb
 c1iKXNg3BGIgBS5gSCsJIgL3MSeFPO8CI0fRSdlKCo6mMQMa0Cr7Iajyb7bRkHw7IQ9xlglknkPtAxBur6rdB8erApedNeieAhsCKIkg5SgAslD7FHD9hzupPZxuzllIY/srGELXxrBx+PhBGglBdj086oLI80eLNHq+2Z6ajRA9r5G6VDijNpiD3KEbZAK1hoVIKc3DInbLUZdB9ccEVYQay51on4Y5LC8BLyucuvi0VODt4sj650ADqhpF7noKIbdQ1OWfDu68DlIyD9sqVrkgbGjv6Gz1lQzkuhlyI0502AnH45AikD0CO54wci0Ry0bo7WAkf7fN4VLW+BRpLPtKmQYJlvjdNGyQb2k6P1AGswpM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 May 2026 12:01:43 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> On Mon, May 18, 2026 at 11:19 PM SeongJae Park <sj@kernel.org> wrote:
> >
> > + Akinobu
> >
> > Hello Ravi,
> >
> > On Sat, 16 May 2026 15:34:25 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:
> >
> > > Hi all,
> > >
> > > This is an RFC, not for merge.  The series exercises and validates
> > > damon_report_access() -- the consumer API SeongJae introduced in [1]
> > > -- as a substrate for ingesting access reports from hardware-sampling
> > > sources.  The series includes one worked-example backend, an AMD IBS
> > > Op module (damon_ibs.ko), that runs on Zen 3+ silicon via the
> > > existing perf event subsystem.
> >
> > Thank you for sharing this great RFC series!
> >
> > [...]
> > > Why a hardware-source primitive complements existing primitives
> > > ===============================================================
> > [...]
> > > Both primitives produce a view of hotness that converges to the
> > > true distribution over the aggregation interval.  For systems where
> > > the address space is small relative to the aggregation rate, this is
> > > the right tool.  On large heterogeneous-memory systems with goal-
> > > driven schemes asking the closed-loop tuner to converge on a target
> > > distribution, a complementary lower-latency view of accesses can
> > > tighten the loop -- reducing the time DAMON's nr_accesses takes to
> > > reflect the workload's actual access distribution, which in turn
> > > reduces ramp duration and oscillation amplitude during convergence
> > > of goal-driven schemes.
> > >
> > > A hardware-sampling primitive provides this complementary view:
> > > hardware retirement records each access at its natural event rate,
> > > with a physical address per sample, independent of TLB state and
> > > independent of the unmap/fault path.
> >
> > Yes, I fully agree.  Different multiple access check primitives have different
> > characteristics.
> >
> > [...]
> >
> > > Demonstration
> > > =============
> > [...]
> > > In both regimes, convergence to target is quick, and the workload's
> > > measured DRAM share then holds within 1.3 percentage points of
> > > target with standard deviation under 1.3 percentage points, sustained
> > > over runs of 15-30 minutes per target.
> >
> > I understand this demonstration shows your AMD IBS-based version of DAMON is
> > functioning as expected.  Thank you for sharing this!
> >
> > [...]
> > > What's in this series
> > > =====================
> > >
> > >   Patch 1.  mm/damon/core: refcount ops owner module to prevent
> > >             rmmod UAF
> > >   Patch 2.  mm/damon/paddr: export damon_pa_* ops for IBS module
> > >   Patch 3.  mm/damon/core: replace mutex-protected report buffer
> > >             with per-CPU lockless ring
> > >   Patch 4.  mm/damon/core: flat-array snapshot + bsearch in ring-
> > >             drain loop
> > >   Patch 5.  mm/damon: add sysfs binding and dispatch hookup for
> > >             paddr_ibs operations
> > >   Patch 6.  mm/damon/core: accept paddr_ibs in node_eligible_mem_bp
> > >             ops check
> > >   Patch 7.  mm/damon/damon_ibs: add AMD IBS-based access sampling
> > >             backend
> > >
> > > Patches 1, 3, and 4 are general infrastructure that benefits any
> > > consumer of damon_report_access().  Patches 2, 5, 6, and 7 are the
> > > worked-example backend (paddr_ibs ops, sysfs binding, IBS module).
> >
> > I didn't read the detailed code of each patch.  But my high level understanding
> > is as below.
> >
> > Patches 1 and 2 are needed for supporting loadable module-based DAMON operation
> > sets (access sampling backend).
> >
> > Patch 3 is needed for supporting access check primitives that can provide the
> > access information in only nmi context.  It can also speedup the access
> > reporting in general, though.
> >
> > Patch 4 makes DAMON's internal reported access information retrieval faster, so
> > will help any reporting-based DAMON operation set use case.
> >
> > Patches 5-7 are required for only the IBS-based DAMON operations set
> > (paddr_ibs).
> >
> > So I agree patch 4 is a general infrastructure improvement that benefits
> > multiple use cases.
> >
> > Patch 3 is also arguably general infrastructure improvement, as it will make
> > the reporting faster in general.
> >
> > Patch 1 is not technically coupled with paddr_ibs, and will be needed for
> > general loadable module based access check primitives.  But, should we support
> > lodable modules?  If so, why?
> >
> > Patch 2 is also not technically coupled with paddr_ibs, to my understanding, so
> > should be categorized together with patch 1?  In other words, if we agree we
> > should support lodable modules based DAMON operation sets, this should be
> > useful for not only paddr_ibs but more general cases.
> >
> > Correct me if I'm wrong.
> >
> > >
> > >
> > > Patches worth folding into damon/next
> > > =====================================
> > >
> > > Patches 1, 3, and 4 are not specific to IBS or to this RFC's
> > > backend.  Each is preparatory infrastructure that any consumer of
> > > damon_report_access() will need:
> > >
> > >   - Patch 1 (refcount ops owner) -- any modular ops set, including
> > >     out-of-tree backends, needs clean module unload to avoid UAF
> > >     on damon_unregister_ops.
> > >   - Patch 3 (per-CPU lockless ring) -- damon_report_access() cannot
> > >     be called from NMI context with the current mutex-protected
> > >     buffer.  Hardware samplers all need NMI-safe submission.
> > >   - Patch 4 (flat-array snapshot + bsearch drain) -- the linear-
> > >     scan drain is O(reports x regions) and exceeds the sample
> > >     interval at high-CPU x large-region products.  Bsearch brings
> > >     it to O(reports x log regions).
> > >
> > > If these belong directly on damon/next as preparatory patches for
> > > damon_report_access() rather than living inside an IBS-specific
> > > track, we are happy to rebase and resend them that way.
> >
> > So I'm bit unsure about patch 1.  If we don't have a plan to support lodable
> > modules based DAMON operations set, we might not need it for now.
> >
> > For patches 3 and 4, I agree those will be useful in general.  Nonetheless, I'd
> > slightly prefer to do that optimizations at the later part of the long term
> > project.
> >
> > >
> > >
> > > Relation to prior and ongoing work
> > > ==================================
> > >
> > > The IBS sampling pattern in patch 7 -- attr.config=0 to use IBS Op
> > > default config, dc_phy_addr_valid filter, NMI-safe sample submission
> > > -- is derived from concepts in Bharata B Rao's pghot RFC v5 [3].
> > > The attribution header is in mm/damon/damon_ibs.c and the patch
> > > carries a Suggested-by: trailer.
> > >
> > > Bharata's pghot v7 [4] introduces a different IBS driver targeting
> > > the new IBS Memory Profiler (IBS-MProf) facility, which Bharata
> > > describes as a facility "that will be present in future AMD
> > > processors" -- a separate IBS instance from the one this RFC's
> > > backend uses. This version of driver based out of v5 [3] is an
> > > example of how DAMON can be benefited from AMD IBS Hardware
> > > source and validates importance of IBS information indepedently.
> > > It is not meant to be merged in the current form.
> > > @Bharata if you see a path where IBS samples can be consumed
> > > by DAMON at some point, will be happy to collaborate.
> > >
> > > Akinobu Mita's perf-event-based access-check RFC [5] explores a
> > > configurable perf-event-driven access source for DAMON.  IBS has
> > > vendor-specific MSR setup beyond what perf_event_attr alone
> > > expresses (e.g. dc_phy_addr_valid filtering on the produced sample,
> > > not on the perf attr), so the IBS path here appears complementary
> > > to [5] -- operators choose based on whether their hardware sampler
> > > fits stock perf or needs additional kernel-side setup.
> >
> > So apparently there are multiple approaches to develop and use h/w-based access
> > monitoring.  Akinobu and you are trying to do that using DAMON as the frontend,
> > and already made the working prototypes.  There were more people who showed
> > interest and will to contribute to this project other than you, too.  I 100%
> > agree h/w-based access monitoring can be useful, and I of course thinking using
> > DAMON as the fronend is the right approach.  I'm all for making this
> > upstreamed.
> >
> > I was therefore spending time on thinking about in what long-term maintainable
> > shape this capability can successfully be upstreamed.  I suggested
> > damon_report_access() as the internal interface between DAMON and the h/w-based
> > access check primitives, and apparently we all (I, Ravi and Akinobu in this
> > context) agreed.  Akinobu thankfully revisioned his implementation based on
> > damon_report_access() interface.  Ravi also implemented this RFC based on the
> > interface.
> >
> > After making the consensus with Akinobu, I was taking time on the user space
> > interface.  When I was discussing with Akinobu, my idea was extending the user
> > interface for the page faults based monitoring v3 [1].  But, recently I decided
> > to make this more general, so proposed data attributes monitoring extension [2]
> > at LSFMMBPF.  The patch series for the initial change [3] is merged into mm-new
> > for more testing, today.  The cover letter of the patch series is also sharing
> > how it will be extended for h/w based access monitoring in long term.
> >
> > I of course want us to go in this direction.  I believe you already had chances
> > to take a look on the long term plan and didn't make some voice because you
> > don't strongly disagree about the plan.  If not, please make a voice.
> >
> Hi SJ,
> 
> One layering question I'd like to flag before the plan is written,
> since it affects how this RFC's substrate slots in:

To my understanding, this RFC reuses the damon_report_access() infrastructure
that shared with the per-CPUs/threds/writes/reads monitoring series [1].  My
plan at the moment is to keep using it.  So from high level view, I think the
final picture would be not really different from this RFC.

> 
>   In [3], .apply_probes is a periodic per-region classifier driven
>   from kdamond_fn after .check_accesses, in process context, that
>   applies a (folio -> bool) predicate to each region's sampling_addr
>   and accounts the results in r->probe_hits[].  damon_report_access()
>   on the other hand is a per-event delivery callback into a per-CPU
>   buffer, called from the access source (NMI for IBS / PEBS / SPE,
>   process context for page-fault-based sources).  These appear to
>   me to sit at different layers - delivery vs. classification.
> 
>   The reason I want to confirm this: NMI context for HW samplers
>   precludes the operations .apply_probes can do today (no mutex, no
>   kmalloc, no sleep, no folio lookup that touches pte_lock).  And
>   the data shape is inverted - .apply_probes asks "does region R's
>   sampling_addr have attribute A?", evaluated on the kdamond-chosen
>   address; an HW sample announces "PA Y was accessed at retirement
>   time T", arriving asynchronously and needing to find the region
>   it falls into.  If access events end up routed through
>   .apply_probes in the long-term plan, the IBS / PEBS / SPE
>   backends would each need a deferral path under it (per-CPU ring
>   for NMI-safe submission, region mapping at drain time).

It will not routed through .apply_probes, but work in a way similar to the
damon_report_access() based design.  That is, each (sampled) access event will
syncronously call damon_report_access() with the access information.  The
information is stored in DAMON's internal data structure.  The information will
contain the access destination address, the accessor CPU/thread, whether it was
reads or writes etc, if available.

Then kdamond will read the reports in the data structure once per sampling
interval and assess if each region got accessed or not since the last sampling
interval.

So my plan is not to reuse .apply_probes, but in terms of who consumes the
information, it is not very different.  Accessor will produce the information
(report), and kdamond will consume those.  But this is how
damon_report_access() based structure is working on, so my understanding is
that your RFC is also not very different.  Am I missing something, or do you
have any concern on this structure?

> 
>   Happy to be wrong here if you see a unified shape that handles
>   both - just want to surface the constraint before the plan is
>   written.
> 
> On the loadable-module question for patches 1 and 2: agreed it's a
> genuinely open architectural call, not just a paddr_ibs convenience.
> 
>   - paddr_ibs (this RFC) targets the existing IBS Op facility on
>     Zen 3+ silicon via the perf event subsystem and uses a
> vendor-specific
>     overflow-handler filter that perf_event_attr cannot express
>     (dc_phy_addr_valid in IBS_OP_DATA3).  Bharata's pghot v7
>     [pghot-v7] introduces a separate IBS driver targeting the new
> IBS-MProf
>     facility on future AMD silicon via direct MSR programming -
>     not perf at all.  These are two AMD-specific HW samplers with
>     non-overlapping silicon coverage and non-overlapping kernel
>     paths.  A distro shipping a single kernel image to a fleet
>     with mixed silicon needs runtime-selectable backends, which
>     obj=y can't do across exclusive `depends on` chains.
>   - Akinobu's perf-event RFC v3 [akinobu-v3] is a useful contrast:
>     it stays builtin because it's a generic configurable
>     perf_event_attr passthrough, no vendor-specific code in the
>     overflow handler.  The tristate case is specifically for the
>     backends that need vendor logic outside perf_event_attr
>     (IBS dc_phy_addr_valid, future ARM SPE record-format
>     handling, future Intel PEBS DLA quirks if they need
>     kernel-side filtering beyond what perf delivers).

I'm still not familiar with IBS and perf events.  Please bear in mind with me.
My understanding is that there are vendor-specific knobs for IBS that perf
event is not supporting.  So far, that makes sense.  And are you saying that
you have to write paddr_ibs as a loadable module if you want to support the
vendor-specific knobs?  If I'm understanding you correctly could you further
share why it cannot be done as a builtin module?

[1] https://lore.kernel.org/20251208062943.68824-1-sj@kernel.org


Thanks,
SJ

[...]

