Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C549CD4F54
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 06:19:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3A7D6B008C; Tue, 19 May 2026 02:19:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EB196B0092; Tue, 19 May 2026 02:19:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 901446B0093; Tue, 19 May 2026 02:19:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7BFE96B008C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 02:19:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 25FD11A01C6
	for <linux-mm@kvack.org>; Tue, 19 May 2026 06:19:18 +0000 (UTC)
X-FDA: 84783167196.24.906CC53
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5A6C21C000A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 06:19:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZdLklr+7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779171556; a=rsa-sha256;
	cv=none;
	b=MpfcIHCaMwAmUAKeRWn4j684CHmYKxSJ6y1x99qIXATbjNypzu3nMjx2Jxch7kx8ktK+A9
	0Orha7SNFOLtISzurInaeEDIXpmcs+gePXhVhX+w6c1IGBA+0OKb8xRi/qSMkvHDER9mer
	D4ParH+LAaWTl5u3+96VoI7RtRQ57XY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZdLklr+7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779171556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=io+Qmua9GnOLb5fel8/acwfEkeWE/Ne1go+//WLefgo=;
	b=ymXg3rVFziCE57MWafhQ/gvYh1h3/mxb9muLqpqKIoYsA9xckT2k2eEq3cSogFfKJjHmOK
	3JIC3ObHHA6jbmgSeXdvXqGoJP33b+vDqhQW0aYKfCmPkNwOvCBGSoEh/XajOLrQeEtK0W
	eqxsbA4+nvKqM6IPoGmjJi5A02JVBr4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 54A0F43A5D;
	Tue, 19 May 2026 06:19:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CFCCC2BCB3;
	Tue, 19 May 2026 06:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779171555;
	bh=F9T026scRHGaX752RNU0g51fdoRwtQ0Pcs9BEJSWy2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZdLklr+7zLiqo2iVrv5PcJCs0zUOe2xhV1o+dSilRnptjvT3RM54iUiga025A9O5d
	 UXansClNWubwn4qY1NEr62/2zy5D5G2pKnNEiZ36w2miymfTLjlV8muw862pgdbzqv
	 fi50mwa9KkwKMkyzsmu/XwSGp7DBWBl9FjXgHPcv915003jFN14Sdq69yM+XuQ7HoH
	 zS+nO1AmiAKtlVbhW2wAQht9ykObjr5gWPn3szXCxdPl/+IeJoA+HWo8KLknjNxR9U
	 vWBSfLcGNNJx8vZeX85hyMeakm1aJGQBHWPtrT/J8JmCA4Y2YvLqiajQjpj3VOLeTx
	 qfsVnPfKnSHcQ==
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
Date: Mon, 18 May 2026 23:19:04 -0700
Message-ID: <20260519061905.89681-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516223439.4033-1-ravis.opensrc@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ctwj7kbdg4p3d9m4gn6nfjoo1g94gsib
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A6C21C000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1779171556-256199
X-HE-Meta: U2FsdGVkX1+Grr37THkcSgmN9qj2YN+gzIdxsraPOuoOw0VABNDG1oaRQmajovDU7Cwoi6ZFsEFOVOJEomGTo4uw/Bq0vBXh8ygaQde3fEs+QQC1kAIMFaHXxn0EdfMf7faftygyzHYsb6icQtjl7XmmOplr55w7ACBzKaciSBLhZBf+tsco4Wg5ATWslpJtk7UQVAXTDxX/ESTz1qIQsVwEFnUHkSR85Q/+L+gF3VFdpAzNLrK94f12YSkY4p1rgS4TMJECQvIIXoChHRe+BP9l3/4g0UMVhTAD1ja+54X6m2F7TzfbVsW06QxzoJNRcpeE66TR1+aKVBUMsGfvStDj7r/Q1PxjU7s2ST5XBLQzVVv1JBhD/Q+w77JOPm+BLKw3dubFnuB4cKT5DZUteV7QdJuES3Z8JbB5hkDOOwP+U/+AIae2MK1i0/68w/SNK3pxdtMhV3wvuQm6qUzsHDwIIW0WK2Hb4vp5DeJTniOd1/CktSmSqDAVPrjzixb7V7dEMYT+1UV3dTh4a1lKBWqoVY9SFzJnnZRWi8C07L/tF5TApPu+Gjn9w/6LjtkWUqCIjy/6zIi6TXorttFqCM/khN+xb6BcdH/DuoGKPkJ6gNzX2gGrTGG/Cb/mmPqG3zam8TLj6S7g5RvM+EZzBEjv0xQGNkSw159gNcwYQshc9s8iYpmF3eP5Wwc2jJu+A7GNSuZ1KqmiWVNn27Wfgrjt72mXgomHuA+y11I71y38jbL+ZRM46HrtQlBY6jKP4QpiYM5rEBWFhZ2fSIKbxn8bv5wiuKr7Dk+6smm+HBAuF/Lbtf06xaWtSIpWYh5jXzNll/iBq5RKpAAwCeYu0nnFd1akS6vHSC3WeR3cX9FPVw1UW849Iz81sU8/gLS7s9j4HGZCBqzFtj32kZ1goL1pfkTgFKE62LiUJAXqGbwSaK3coxqNdoYn6ALwn/gOYbyEOAfPSoIdBTH7Eby
 O8y25YPJ
 5raMo68ikSwPqkhMwAbG5LqwLdT5zajjF29VMiHH7Bq5EZ+0jGSHHDC0d7L6tT/hif8zwQJNI5yBJCe5Qv4Xsqi83dPFWT2R5I6JDs7UE1WKkuvNeoCKn86RpwUfjNwEZLKtQ4e5ZY1FlAiW47ue7Jyry9VvmYlNblVovM3DixEH4tUH7b7i1nMb9SaBztnGzuGvchivUvBmtrVkebJF9EcgPye/f3u3g0UYLnX9Zv6KP5aA8qu/1HUCkRhBjvlM3LVZpWCW6WUnFVR2YoOg5QUXBOhmvtN5qYJI1K7C85GUkoN/24y0XKXZdedQzmg8M+TxVzLgRQRMHDixN9+aEEDEh2ygv6x5X/htqU6gcdPfkjIjHrrUPl90XzJ7sE4Fn4whl6WGNHUZYWeCMRCc2ZdssBcneAmF424YR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ Akinobu

Hello Ravi,

On Sat, 16 May 2026 15:34:25 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> Hi all,
> 
> This is an RFC, not for merge.  The series exercises and validates
> damon_report_access() -- the consumer API SeongJae introduced in [1]
> -- as a substrate for ingesting access reports from hardware-sampling
> sources.  The series includes one worked-example backend, an AMD IBS
> Op module (damon_ibs.ko), that runs on Zen 3+ silicon via the
> existing perf event subsystem.

Thank you for sharing this great RFC series!

[...]
> Why a hardware-source primitive complements existing primitives
> ===============================================================
[...]
> Both primitives produce a view of hotness that converges to the
> true distribution over the aggregation interval.  For systems where
> the address space is small relative to the aggregation rate, this is
> the right tool.  On large heterogeneous-memory systems with goal-
> driven schemes asking the closed-loop tuner to converge on a target
> distribution, a complementary lower-latency view of accesses can
> tighten the loop -- reducing the time DAMON's nr_accesses takes to
> reflect the workload's actual access distribution, which in turn
> reduces ramp duration and oscillation amplitude during convergence
> of goal-driven schemes.
> 
> A hardware-sampling primitive provides this complementary view:
> hardware retirement records each access at its natural event rate,
> with a physical address per sample, independent of TLB state and
> independent of the unmap/fault path.

Yes, I fully agree.  Different multiple access check primitives have different
characteristics.

[...]

> Demonstration
> =============
[...]
> In both regimes, convergence to target is quick, and the workload's
> measured DRAM share then holds within 1.3 percentage points of
> target with standard deviation under 1.3 percentage points, sustained
> over runs of 15-30 minutes per target.

I understand this demonstration shows your AMD IBS-based version of DAMON is
functioning as expected.  Thank you for sharing this!

[...]
> What's in this series
> =====================
> 
>   Patch 1.  mm/damon/core: refcount ops owner module to prevent
>             rmmod UAF
>   Patch 2.  mm/damon/paddr: export damon_pa_* ops for IBS module
>   Patch 3.  mm/damon/core: replace mutex-protected report buffer
>             with per-CPU lockless ring
>   Patch 4.  mm/damon/core: flat-array snapshot + bsearch in ring-
>             drain loop
>   Patch 5.  mm/damon: add sysfs binding and dispatch hookup for
>             paddr_ibs operations
>   Patch 6.  mm/damon/core: accept paddr_ibs in node_eligible_mem_bp
>             ops check
>   Patch 7.  mm/damon/damon_ibs: add AMD IBS-based access sampling
>             backend
> 
> Patches 1, 3, and 4 are general infrastructure that benefits any
> consumer of damon_report_access().  Patches 2, 5, 6, and 7 are the
> worked-example backend (paddr_ibs ops, sysfs binding, IBS module).

I didn't read the detailed code of each patch.  But my high level understanding
is as below.

Patches 1 and 2 are needed for supporting loadable module-based DAMON operation
sets (access sampling backend).

Patch 3 is needed for supporting access check primitives that can provide the
access information in only nmi context.  It can also speedup the access
reporting in general, though.

Patch 4 makes DAMON's internal reported access information retrieval faster, so
will help any reporting-based DAMON operation set use case.

Patches 5-7 are required for only the IBS-based DAMON operations set
(paddr_ibs).

So I agree patch 4 is a general infrastructure improvement that benefits
multiple use cases.

Patch 3 is also arguably general infrastructure improvement, as it will make
the reporting faster in general.

Patch 1 is not technically coupled with paddr_ibs, and will be needed for
general loadable module based access check primitives.  But, should we support
lodable modules?  If so, why?

Patch 2 is also not technically coupled with paddr_ibs, to my understanding, so
should be categorized together with patch 1?  In other words, if we agree we
should support lodable modules based DAMON operation sets, this should be
useful for not only paddr_ibs but more general cases.

Correct me if I'm wrong.

> 
> 
> Patches worth folding into damon/next
> =====================================
> 
> Patches 1, 3, and 4 are not specific to IBS or to this RFC's
> backend.  Each is preparatory infrastructure that any consumer of
> damon_report_access() will need:
> 
>   - Patch 1 (refcount ops owner) -- any modular ops set, including
>     out-of-tree backends, needs clean module unload to avoid UAF
>     on damon_unregister_ops.
>   - Patch 3 (per-CPU lockless ring) -- damon_report_access() cannot
>     be called from NMI context with the current mutex-protected
>     buffer.  Hardware samplers all need NMI-safe submission.
>   - Patch 4 (flat-array snapshot + bsearch drain) -- the linear-
>     scan drain is O(reports x regions) and exceeds the sample
>     interval at high-CPU x large-region products.  Bsearch brings
>     it to O(reports x log regions).
> 
> If these belong directly on damon/next as preparatory patches for
> damon_report_access() rather than living inside an IBS-specific
> track, we are happy to rebase and resend them that way.

So I'm bit unsure about patch 1.  If we don't have a plan to support lodable
modules based DAMON operations set, we might not need it for now.

For patches 3 and 4, I agree those will be useful in general.  Nonetheless, I'd
slightly prefer to do that optimizations at the later part of the long term
project.

> 
> 
> Relation to prior and ongoing work
> ==================================
> 
> The IBS sampling pattern in patch 7 -- attr.config=0 to use IBS Op
> default config, dc_phy_addr_valid filter, NMI-safe sample submission
> -- is derived from concepts in Bharata B Rao's pghot RFC v5 [3].
> The attribution header is in mm/damon/damon_ibs.c and the patch
> carries a Suggested-by: trailer.
> 
> Bharata's pghot v7 [4] introduces a different IBS driver targeting
> the new IBS Memory Profiler (IBS-MProf) facility, which Bharata
> describes as a facility "that will be present in future AMD
> processors" -- a separate IBS instance from the one this RFC's
> backend uses. This version of driver based out of v5 [3] is an
> example of how DAMON can be benefited from AMD IBS Hardware
> source and validates importance of IBS information indepedently.
> It is not meant to be merged in the current form.
> @Bharata if you see a path where IBS samples can be consumed
> by DAMON at some point, will be happy to collaborate.
>  
> Akinobu Mita's perf-event-based access-check RFC [5] explores a
> configurable perf-event-driven access source for DAMON.  IBS has
> vendor-specific MSR setup beyond what perf_event_attr alone
> expresses (e.g. dc_phy_addr_valid filtering on the produced sample,
> not on the perf attr), so the IBS path here appears complementary
> to [5] -- operators choose based on whether their hardware sampler
> fits stock perf or needs additional kernel-side setup.

So apparently there are multiple approaches to develop and use h/w-based access
monitoring.  Akinobu and you are trying to do that using DAMON as the frontend,
and already made the working prototypes.  There were more people who showed
interest and will to contribute to this project other than you, too.  I 100%
agree h/w-based access monitoring can be useful, and I of course thinking using
DAMON as the fronend is the right approach.  I'm all for making this
upstreamed.

I was therefore spending time on thinking about in what long-term maintainable
shape this capability can successfully be upstreamed.  I suggested
damon_report_access() as the internal interface between DAMON and the h/w-based
access check primitives, and apparently we all (I, Ravi and Akinobu in this
context) agreed.  Akinobu thankfully revisioned his implementation based on
damon_report_access() interface.  Ravi also implemented this RFC based on the
interface.

After making the consensus with Akinobu, I was taking time on the user space
interface.  When I was discussing with Akinobu, my idea was extending the user
interface for the page faults based monitoring v3 [1].  But, recently I decided
to make this more general, so proposed data attributes monitoring extension [2]
at LSFMMBPF.  The patch series for the initial change [3] is merged into mm-new
for more testing, today.  The cover letter of the patch series is also sharing
how it will be extended for h/w based access monitoring in long term.

I of course want us to go in this direction.  I believe you already had chances
to take a look on the long term plan and didn't make some voice because you
don't strongly disagree about the plan.  If not, please make a voice.

Assuming you don't have concern on the long term plan yet, I will take time to
write down more formal and detailed plan.  It will explain the overall roadmap,
timeline and how we could collaborate.  On top of that, we could further
discuss.

> 
> 
> Specific asks
> =============
> 
> To SeongJae:
> 
>   1. Patches 1, 3, and 4 are infrastructure that benefits any consumer
>      of damon_report_access(), not just the IBS backend in this RFC.
>      Would these belong directly on damon/next as preparatory patches
>      for damon_report_access(), rather than living inside an
>      IBS-specific track?  Happy to rebase and resend them that way if
>      you'd prefer that shape.  Tested-by: tags can come along.

I'm still thinking about how we can collaborate well.  The answer for the above
question would be a part of that.  In other words, I have no good answer right
now, sorry.  Could you please give me more time to think more and share the
plan?  I will share the plan as another mail.  On the thread, we could further
discuss.  Of course, we could have DAMON beer/coffee/tea chats [4] like
additional discussions before/after/during the plan discussion.

So, long story short, we agreed this project (h/w-based data access monitoring)
should be upstreamed.  But give me little more time on thinking about how we
will do it and collaborate.  It will take some time.  Please bear in mind.
Sorry for making you wait, but I pretty sure and promise that we will
eventually make it.

[1] https://lore.kernel.org/20251208062943.68824-1-sj@kernel.org
[2] https://lwn.net/Articles/1071256/
[3] https://lore.kernel.org/20260518234119.97569-1-sj@kernel.org
[4] https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing


Thanks,
SJ

[...]

