Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 189F4C88E75
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 00:42:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A58496B0088; Tue, 15 Sep 2026 20:42:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A097C6B008C; Tue, 15 Sep 2026 20:42:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91E9F6B0092; Tue, 15 Sep 2026 20:42:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 650996B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 20:42:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EC293A057B
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 00:42:40 +0000 (UTC)
X-FDA: 85217774880.08.99D086F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 33864140002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 00:42:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iwoU/MyH";
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789519359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lSFqgIB/QkG8NNxRnnvdrACKkHikqffoikxUFlVJO+0=;
	b=f70t8ei8DAD92bJhZ2H35HnL0xD9vrNBFgOvuRbmI2rUbpuS5J2inAlCH1kMNlWxGZnsif
	q8WO9Zl/+nTcGUG1BFeWWclq30AWLw8NyihpEoeHjMxn2Cvp7h3DBcQumSuHjCAUWuuUwf
	V1+ZTl5m1AeC7F8qJdwiWwJl78isI/s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iwoU/MyH";
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789519359;
	b=Jqy8F417eX0Cx4qhSCm1uAHOvGmgoCtZ6fG2vAwVSLruA+U7KOsYuixWgyd0oehAcf1hLR
	EkDzXsjVhb4H4rU/G7HsOvqgzuPnWd5mo0Kn0aLEtbR0DYbOkc0IUdgNr7s33aX1SUXW8Z
	1qNRyfGUVPpVupOCGi5lpx9WwjenfwU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2246E40B0A;
	Wed, 16 Sep 2026 00:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63ED11F000FF;
	Wed, 16 Sep 2026 00:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789519358;
	bh=lSFqgIB/QkG8NNxRnnvdrACKkHikqffoikxUFlVJO+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iwoU/MyHU5H3ffHp5R6u8BJl2K2nKRPi4E6PniVHazaizPYr0Aqt3zBS8+NI2rCRv
	 7X65gQjc+rdA63Vu9rhQiTWwVKJC/2y5wzUdcurQ5CZIsXikvkhE4hu0kWufoWww15
	 1XUqlm1jBYClQqcaGA9+g4sVOOBwsdkmxmEoHwpwOc+25kylVsfulDQR51cOw0xlue
	 xODeWztXJi4Mi5s9J/g4W42nzhg19DCGaA++Rf4rJTlNcQuWH6ztDUfTbWGOrKbNmM
	 8eoeHDXRSbJB19rBoKj9xJjXtoEtnS8XFGoPGid8mGlAwFcQnZGsIela4PIGHQiAoF
	 NN8jt0mOG4VOg==
From: SJ Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akinobu.mita@gmail.com,
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
	rientjes@google.com,
	weixugc@google.com,
	jic23@kernel.org,
	gourry@gourry.net
Subject: Re: [RFC PATCH v2 0/9] mm/damon: hardware-sampled access reports
Date: Tue, 15 Sep 2026 17:42:28 -0700
Message-ID: <20260916004230.101408-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CALa+Y17GK7TQHA5FyoMdnOFM1Y38g7P9qc-nMgP-dO4zfRj8Ug@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 33864140002
X-Stat-Signature: 3azgsdhb6pqhsrq7nkcqor9eejddi364
X-Rspam-User: 
X-HE-Tag: 1789519359-831042
X-HE-Meta: U2FsdGVkX181SoOaqOpJ16CJYFeVw3lSO9BKnyPhiQqsT2i497QIr4Cu/svzBFbFmvPI3trRj1O6/6xmEwE0948Z3kkENLWFdeKY1/ibf/RJ8MabacUiSTUHy6l7AGtcF6R9FKljkyUQUow4dBiVmGTQrc7Hu2MtmBcx9zx/TD7YfmYzlGQh7Vw6EUKYqtPqdXpqDC5Q0dvVjXTcI7qQTi7zN5Rt8VVJ8AobSZ6pjoM2iI209jkfA/YOtCVrn9zKKqwL9ljK34iKTyQL/Z/x6FmocNtoUfjvaOEtWOjRW7p3avQJOFFExBCXjRhHPNs0HrqCMMqKsvUEjpHuWGPM3Gu3xU699uNKPviaclod2074CAjCcN+BoY53VusO9XXbtmHXCy1FTZ8L1yt2aqnG0/CNKC+OE+qDQSg0aAAzTGdPwZ5emshEo7OaeZVGXFYhzDBesvmZAUYbjP7l0oww58zB9+HgV+kBbD4E6a2csHUCGcAsaP3rwe5uA5rMu+85a3+5D5Nq9otF+FHrfml64sa0S6yzNU4ccx+OVVWB27PXm6mimpIsHAfoesXGUkaKSscjEizIXj5H6XCk9oKItUHKZdtQxlJ6XmBCAhdRh574c2nt83jPlzg2C+JY+B5JJCRU85DdjxSWN7qj1OnZ1DeAmqXRxBUuTVpI2/4BTkWLd1jPNMFYckkXPsIBElaeQ5ClJh9C7YsMVsFrkv+cddon+WcwxBwXYBrNajILg8aUveu2jMwRT1bkvsexGuWzABqK+b8G/wpkU4R9sW7W5CNe6aYDIul/7XtPppB/musozXWIpCcJyooeQl/cb+bZtwSGHXWeSMPKK9qYzS0Fxn3gx4nuKGUqPBoPcBz/S1QDPXDSM5SAIaeMbQKdv/YVMueNRhvjhIy8mZU/JseZ29Aoa4kUOFxRds4hO9jFZ9EvuNEa7frts5jiZNucKCPFwDBE1XBFC6+l9FAPAH9
 fClchELc
 cawYzC6QCQodvvJy4khd7Ik+T8DENVuS9gC04dvD8x1XC4Zakz19pPl7DwtczDuFtQTBNt+AjooLNwFuVXTz1n53bsEJCDWp2lWaC3tP9njy1EaXuzft6115aGwz1jlb19QjnmHptB8FZaSFLCTRe9MnjuAEtLPFmil4mhhbPxE77uXCYuqeSgAx2PPtbrNqz4uRZqosf89zHK2anbrZJY10jJFjaljd6SZynGgLYlwsxemNf0fvFntS5URkR0HNFNUvO+RtSXCd9utDxEshjXUA2a+KlUirNB7Q3K0ytLPh3BWASU5fhsDT9Wz9QcjxPDpPw5X39rTEnAAtULk4wcaok/5x9pWdbicORODIypA9qOukPn6pTmjhneA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sep 2026 14:23:02 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> On Fri, Sep 11, 2026 at 6:38 PM SJ Park <sj@kernel.org> wrote:
> >
> > Hello Ravi,
> >
> > On Thu, 10 Sep 2026 10:16:14 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:
> >
> > > This series lets DAMON take its access information from a hardware sampler
> > > instead of from a page-table scan, and lets a scheme's score be weighted by what
> > > that sampler reported.
[...]
> > First of all, thank you very much for sharing this great series.
> >
> 
> Thanks SJ for the detailed review and the milestone 2 / phase 3 clarifications.

Glad to hear that!

[...]
> > > What running it
> > > across vendors needed on top of that direction is:
> > >
> > >   - per-CPU lockless rings between the NMI sample handler and the kdamond drain,
> >
> > I understand we need to make it lockless.  I wonder if we have to make it
> > per-CPU.  I understand it will be better in terms of performance, especially on
> > machines having many CPUs.  That said, this feels like somewhat we can discuss
> > in phase 3.  And it would deserve to have sufficient discussions and
> > performance evaluations.
> 
> The per-CPU structure is not a performance optimization we can defer -- it
> is required by the calling context.  A perf-event overflow handler runs in
> NMI context, which cannot take a mutex or any sleeping lock.
> damon_report_access() takes a mutex, so it cannot be called from there.

Thank you for clarifying, Ravi.  But, what I wanted to say is, we could update
damon_report_access() to not use mutex but atomic operations.  Does that make
sense?  FYI, damon_report_access() will also be renamed, say,
damon_report_attr().

[...]
> Understood.  I included the page-fault source in v2 because the December
> 2025 RFC [1] that introduced damon_report_access() had it as the primary
> consumer, and I wanted to carry forward that ability.  Since it is out of
> scope for milestone 2, I will drop it from v3.
> 
> Patches 1, 2, and 3 will be dropped from the v3 submission since they are
> all tied to the page fault path.

Makes sense, thank you!

> 
> >
> > >   - per-CPU events that follow CPU hotplug, armed when the kdamond starts and
> > >     disarmed and drained when it stops,
> > >   - a per-PMU owner, so two contexts cannot claim the same PMU type,
> > >   - whichever address a PMU does report carried on the report and matched
> > >     against the context's own address space, so one source serves a paddr or a
> > >     vaddr context without a backend per address space.
> >
> > These all soudns making sense to me.  Nonetheless, I think we can scope
> > milestone 2 to support only physical address and defer these things to the
> > phase 3.
> >
> 
> Got it. Will scope v3 to PA only. so included results for v3 would be based on
> AMD IBS testing.

Sounds good!

> 
> > >
> > > This is tested with PEBS on Intel and IBS on AMD, both configured as `perf_event`
> > > attributes on a probe and using the perf core's event plumbing rather than
> > > per-vendor MSR code.  A third source has already been written against the same
> > > ring: Kunwu Chan's ARM SPE backend [5], which reaches it through an AUX buffer
> > > drained in process context instead of an overflow callback, and which the
> > > roadmap [2] places in its third milestone.
> >
> > Awesome, appreciate your huge effort on this!
> >
> > >
> > > The partitioning is what lets promotion and demotion run in one context.  A
> > > sampler says which regions are hot; it says nothing about which are cold, because
> > > a sampler that reports nothing about a page cannot distinguish untouched from
> > > unsampled.
> >
> > I'm not really sure.  I think absence of samples for an address range can also
> > mean the address range is cold?  Actually the page table accessed bit based
> > monitoring also use a sort of sampling, so I don't show real distinction.
> >
> > Maybe you're right, but I think this deserves sufficient discussions and
> > testing that we could defer to the phase 3.
> >
> > > Region age is what a demotion scheme matches on, and age comes from
> > > the page-fault primitive.
> >
> > We would have age in perf event based mode, too.  Isn't it?
> >
> 
> You are right.  Region age accumulates whenever nr_accesses stays at zero
> across aggregation boundaries, and that holds whether the zero comes from a
> PTE scan or from an empty perf-event drain.
> 
> I was initially concerned that a sparse sampling PMU might not cover every
> cold region in every aggregation window, leaving silence that could be
> mistaken for cold,
> whereas page faults provide higher spatial coverage for confirming
> first-access.  Having both together was intended as a defence against that gap.
> 
> Based on your observation I retested this on hardware.  On AMD Turin
> the cold demotion scheme found and demoted the idle working set
> correctly using only the hardware-sampled IBS signal -- nr_accesses aged to zero
> for regions that genuinely had no traffic, and the scheme acted on age as
> expected.  The combined design may still be worth exploring later when
> page fault
> is considered to be reintroduced in phase 3.

Sounds good, thank you for the testing Ravi!

> 
> > > With the ring partitioned by class both are live at
> > > once: the probe supplies hotness, the primitive supplies age, and two schemes
> > > over the same regions can move memory in both directions under one kdamond.
> >
> > Unless the needs are clearly confirmed, I'd prefer having single class for
> > simplicity.
> >
> 
> With the page fault primitive out of scope there is no case for two ring
> classes.  I will prepare v3 with a single class.

Sounds good!

[...]
> > >   4. `mm/damon: add damos_node_eligible_mem_bp tracepoint` -- a per-tick
> > >      tracepoint over the node-eligible-memory quota goal evaluation, exposing
> > >      the goal's target and current values, so the loop a bandwidth-driven
> > >      controller steers is visible to a tracer.
> >
> > This seems doesn't need to wait anything.  If this turned out to be helpful,
> > please feel free to separately send patches for this.
> >
> 
> Yes. It is quite useful to track goal convergence. Will send a single patch
> targeting mm-new.

Looking forward to the patch!

[...]
> Summary of what v3 will contain (5 patches, former patches 5-9 of v2):
>   - paddr-only, single ring class, no page fault primitive
>   - per-CPU rings retained (required by NMI calling context, not an
>     optimization)
>   - perf-event overflow handler (paddr path, vaddr parts deferred to phase 3)
>   - sysfs/lifecycle surface
>   - probe-weighted score
>   - kunit tests updated for the simplified scope

Makes sense.  And regardless of my global ring idea, feel free to keep the
per-CPU rings.  As long as it is an RFC, please feel free to implement it in an
easy-to-implement way.

Please also note that I'm still working on shaping the milestone 2
deliverables.  I'm not yet in a stage that I can share how it will really look
like.  So the final version of your work might need a significant amount of
change to rebase on it.  I will also try to make it not unnecessarily delayed
more than our planned timeline.  But please bear in mind with me.

> 
> Separate send targeting mm-new:
>   - tracepoint (former patch 4)

Looking forward to it.

[...]
> [1] RFC PATCH v3 00/37: mm/damon: introduce
> per-CPUs/threads/write/read monitoring
>     https://lore.kernel.org/damon/20251208062943.68824-1-sj@kernel.org/


Thanks,
SJ

[...]

