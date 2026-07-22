Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DB1BC4453A
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 09:36:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85DFA6B008A; Wed, 22 Jul 2026 05:36:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 835B16B008C; Wed, 22 Jul 2026 05:36:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74B946B0092; Wed, 22 Jul 2026 05:36:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 380086B008A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 05:36:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A25981203F8
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:36:17 +0000 (UTC)
X-FDA: 85015906794.29.60A07C5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id DA191100009
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:36:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=p+96pLlS;
	spf=pass (imf05.hostedemail.com: domain of mark.rutland@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=mark.rutland@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784712976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K3BAwkX4e0yTBdzLE/9XMWKMSFzQsojzSVvnX9l/QZo=;
	b=7JKK1mnEV5epmhrwIb9omxQKtFAoC5odrQSsra1srum/iLd7MOfHnpIVigb5hxUTM8NnKn
	P0/70Yh/Yz+Ais6TH1YS1oFADofilvjDwVDdBbR3kOzVzdeOZGDqXZkckYw9cyQq/w7xrI
	RX3ekeQZjwHJR7zxAW5ML1Bu5g5/U2o=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=p+96pLlS;
	spf=pass (imf05.hostedemail.com: domain of mark.rutland@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=mark.rutland@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784712976;
	b=G91f/RdCkQX08jusXo03KSm+dmiW+dCz9driM4hNVQcPjLq/5ujLKrfNytQvJAb26QpXuS
	kyETc2CaqTHbOJS13jDA2QGBBgdOHGw0zmvPxzgChSvz0wLwDqRYbU1GXZEt0byH7GKnjv
	P9J+rLx3HfmxYrZd2b4umP1z8fYcpZU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B22441595;
	Wed, 22 Jul 2026 02:36:10 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 60C193F86F;
	Wed, 22 Jul 2026 02:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784712974; bh=O7EJYDmByoTpsITBBymwn3nowadBexEAS2hMkYKxPgw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p+96pLlSDOM6+k2/MeXzTMznCRtWimKXzB4tZA92QDqgSOl1NjfUhJS9lG6GG2p5N
	 bi0O/7yZ1vIOSsokI2+i6rrzLGeAR0mlIrLwTZfXK87JhsURFk+oz8FzSyeN1Ge4FY
	 mHRsI05xgc+t/aDcEBztVuIkH8Y7lIyPqamtbWMk=
Date: Wed, 22 Jul 2026 10:36:06 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Yang Shi <yang@os.amperecomputing.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>, cl@gentwo.org, dennis@kernel.org,
	tj@kernel.org, urezki@gmail.com, catalin.marinas@arm.com,
	will@kernel.org, david@kernel.org, akpm@linux-foundation.org,
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
Message-ID: <amCPBrdltFSE_fEf@J2N7QTR9R3>
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
 <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com>
 <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com>
X-Rspamd-Queue-Id: DA191100009
X-Rspam-User: 
X-Stat-Signature: cm5q8djmka1nwcojwnj5ir3cq36jx8qn
X-Rspamd-Server: rspam04
X-HE-Tag: 1784712975-110245
X-HE-Meta: U2FsdGVkX18v4G4lcgc6gjR223p49hAeLaTWxKYbPB6qFE03lNpFor7W3S0Z5FPp1Yy70hxiA9DZk8Kj/CjURuGgDKw1qwZ6JBaiensb9rNTzaXLNm2hn4fr/9sxUWJO2j/Y1UkrpLDsG7X82ukp+nKm+Uw5tCTd/QWY7WREhQHySSETEVm3+6YsO0zPgu00XcrxstMEjhy/iclAj3QLQ9JpYYCLnslq+M9SgWEEcfPX6LBpHwVM6MxmvRI2Tvs97mjuxbVBbBAq0Zqo7XjXv5DQuV6BZXVckAmQvdL/VLufOoPD6tk/j6mp01VJmdYJtVZhqmyFpiCZOCA13ELU6dLbXtDJe+Q1jxVVs/3WcTGI4uPUS5tbkf3J8Jt1PeeDnbpZJ3zCa5d3X1hnko8U5R7Zo+Df61MSu0K2h/qg7XwOfBQekMCJbbZrh8aoJqdiqQGPU5mWhOd3Qk0DJviM5MNPqSviid3qc7fXyypLEj/V+yM7bsYfxOZ+1dKYygjt0+RQYRrt64q3pnXUh/NU1t+JvFN/JWR9PTgF0nCGzwLtNQf+5rJvhyyTY1lrKFeHL4jXaLRY/k2E0rpzgvvpzkYW+9HUY/TRe0YpSgCrz4Dw/Psl1jZMRkosCPCBjkHP2zsjoqzhc+KxMzyAnUeK5sbvf4uFUAqxbv/lfihBa2ceixJ03UUbCV7nKw6bdX55QzGVm+P1TKC7dDXKJRnL9L6IhY8R+doqjj6d3ZLj0l6DQ/ym92wLiRDZqQrPF7kBvy3JFv1sJuoTi8RpeF6Fjk2ABFshXtUU7VoDQMYz8BlEgKyfxfUW141LXoxh4sA/3hnWV8JOf9/czm1tT5hPb+TsHFv+1beqqfoTp3zEqMo4Kx+jch1+TANvwVx+ZmONXzVLXIGwdkJMpxyK32g5yl05ZT3IfgkJy3VT6byPEjrnYwodVi2l0bRgw4keHqXXsk6oaahdm5MjyYPmZVG
 +4Fnth3M
 1+8s3OdJFfACBDPPO0uKXaF0ymPC8OdxFL+4KK0Ok+nZu+EyX1mnZMK2hfWjTrvl3SWxuWziCopm9F1BHN4BEGFEiPKRSTvM25dasmlDdgmyO8txnPdk09FTrzBwI68M0JRUiI7pOG+1UXWZwpNw2KGNX7iLBjYH3jSvj0BsrRb5NO9GovIn9Xj/tz2Q6jBaCM9bU8RwfFvdcOBcndZzQaj33PlnollJB9p9zNpbkZGugs4NvLW7i0Xr7NqQjvByWy7d49KBszhzVxXnlV7mTk2wdfnd4qpzSOidSOdypsjy4nS66bEYURbjKqr65Gx9IVAeHmWAGzrFcFJNqcvKK7XKoXUxYF4GcZR0AmItniFKWFBudsaKLrjezDMS1lnFl4HSt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 04:20:50PM -0700, Yang Shi wrote:
> On 7/16/26 6:23 AM, Ryan Roberts wrote:
> > On 15/07/2026 19:04, Yang Shi wrote:
> > But I think that there are other issues with this concept that likely block it
> > from being accepted upstream; see below...

> > We have observed a few performance regressions recently, for which the root
> > cause is increased use of this_cpu_*. We have somebody at Arm about to start an
> > investigation into whether in-kernel rseq can solve the problem.
> 
> It is good to know someone is exploring the alternative path. But I doubt
> restart sequence can really boost the performance. It needs check whether
> preemption (or cpu migration) happens in the middle of percpu operations
> then manipulate the ip to restart the operation.

With the rseq approach, that check happens out-of-line in exception
handling code, *only* when preemption occurs, so in the fast path there
is *no code whatsoever* to check for preemption/migration, and no
branches to cause a restart.

Please note that with the approach I've prototyped, the exception
handling code doesn't even adjust the PC; we just adjust a GPR
containing the address. The forward progress guarantees (and behaviour
under contention) should be the same as a single instruction. The fixup
logic itself is trivial.

Please see my message where I outlined that approach in detail:

  https://lore.kernel.org/linux-arm-kernel/al_DpFJFcmVhxpvW@J2N7QTR9R3/

I expect that should come with a reasonable benefit, but I don't have
benchmark figures yet as I haven't finished converting the xchg and
cmpxchg implementations.

> It sounds like it just moved the cost from one place to the other
> place and it also seems hacky TBH.

The existing (high) cost is removed from the fast path. A new (low) cost
is added to the rare path where we perform an exception return into the
middle of a critical section.

I don't think this is any more hacky than percpu page tables. It's far
more contained to the relevant pieces of code (only the this_cpu_*() ops
and exception entry/return).

> It may reduce the preempt_disable/preempt_enable cost somehow for some
> less contended cases, but it may be worse for high contended cases.
> The percpu page table can work well for both.

It entirely removes the preempt_disable/preempt_enable cost.

I don't follow your concern with contention. Any contention on the
memory location is going to be independent of preemption, and if a
thread is preempted mid-operation, the impact is going to be the same
with either the adress fixup or percpu page tables -- I don't think you
avoid that.

> S390 implemented restart sequence. Heiko didn't share too much benchmark
> data, just confirmed there is no regression and I had a lengthy discussion
> with him
> (https://lore.kernel.org/lkml/20260520092243.264847-1-hca@linux.ibm.com/).

As above, for s390 Heiko didn't implement a restart sequence; he
implemented an address fixup sequence. There is no restart.

The discussion you had there seemed to focus on the s390 implementation
details (e.g. why he used an address fixup rather than a restart), and
the benefits of removing the preempt_count manipulation (which all the
approaches, including mine, do).

Am I missing some key detail?

> Improving this_cpu performance is just one of the usecase of percpu page
> table. The other potential usecase is kernel text replication I mentioned at
> LSFMM. The idea is not new, someone else has explored it, see https://lore.kernel.org/linux-arm-kernel/ZMKNYEkM7YnrDtOt@shell.armlinux.org.uk/.

That was looked at in the past, but people weren't keen given the
complexity it would lead to, which is why it never saw much traction.

> Percpu page table can make kernel support it more naturally.

Perhaps, but the only difference is that you've moving the support code
into the core kernel mm code. I think the general concerns people have
with percpu page tables still apply.

[...]

> > > Known Issues
> > > ============

> > > 3. Shared TLB machines
> > > ----------------------
> > > Some machines may share TLB between CPUs, for example, SMT machines may share
> > > TLB between the two hardware threads in one core.
> > > The per cpu page table just can't work with it. Maybe we need a new
> > > cpufeature to indicate whether per cpu page table is allowed or not. Then
> > > just enable it for not-shared-TLB machines.
> > The architectural feature you're referring to here is FEAT_TTCNP (common not
> > private). There are many CPUs out there that use this feature (not just those
> > that support SMT).
> > 
> > FEAT_TTCNP is mandatory from Armv8.2 and the presence of the feature only tells
> > you whether you can legally set the CnP bit - it doesn't actually tell you if
> > the HW does any sharing - there is no way to detect this. So making per-cpu
> > pgtables mutually exclusive with CNP is a non-starter as all CPUs from v8.2
> > onwards advertise CNP.
> > 
> > Even ignoring the CNP problem, you'll end up installing the per-cpu TLB entries
> > tagged with whatever user ASID happens to be installed at the time. Which means
> > you could end up with lots of duplicated TLB entries all differing only by ASID.
> > It's probably not the end of the world, but it seems... inefficient.
> 
> Really? I thought ASID will be ignored if nG == 0.

The nG bit only applies to leaf entries (Page or Block descriptors). All
intermediate entries (Table descriptors) are ASID tagged.

> > The only way I can see to make this work fully is to rely on FEAT_ASID2, which
> > allows specifying separate ASIDs for TTBR0 and TTBR1. Then each CPU can have
> > it's own (permanently installed) ASID for local mappings in TTBR1. That would
> > solve the CNP issue. FEAT_ASID2 is optional from v9.4 and mandatory from v9.5.
> 
> I agree it is safer to handle CNP problem by depending on FEAT_ASID2.

I think that depending on FEAT_ASID2 is a non-starter.

There is no extant hardware with FEAT_ASID2, and I don't think we want
to maintain distinct versions of hte percpu code accross architecture
versions.

Mark.

