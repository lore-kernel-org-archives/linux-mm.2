Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F569C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 17:25:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F7B16B00A1; Thu, 27 Aug 2026 13:25:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CEDF6B00A2; Thu, 27 Aug 2026 13:25:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E5106B00A3; Thu, 27 Aug 2026 13:25:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 143A66B00A1
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:25:17 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9BC9014014E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:25:11 +0000 (UTC)
X-FDA: 85147725222.14.25EA4B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id EFAF4A000E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:25:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dPenraVi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787851510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wdt982Ce9e2WW4tML2j2T0NI00NUsPFfLNhjKnr4OFo=;
	b=EdOjT+4p/O08+LL+0mLBnqmKe0miqEuSIkpiXMoD2y61HP6aJJfzFNwqwapJnqOb2XaVxo
	1pt2bZqyxWzv3mQwODsN8XiNjULWusqUKQMsjr3sCj7anynT0HQDt6OJAt5FRZtQ32rDOX
	yRNYEBB6/LYsABjraNp4AyLktYDXfWQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787851510;
	b=2GFm61bz1au+wJIvNnY3+495RfKuOYkC31z3wjU7xzUGrnpkjsIGszWZBE2AtIf9Y635ML
	PKi5gTH62afRXkCSxfcm0QxJ7O4S0ABmqkWmN3WOycLO0Rr6iGHi2Xf5tYeEoXsJcOW+d7
	8se1pEAb02ws871iE7SQGjPwpXKJPkk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dPenraVi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 248CD40A7C;
	Thu, 27 Aug 2026 17:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83331F00A3A;
	Thu, 27 Aug 2026 17:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787851509;
	bh=Wdt982Ce9e2WW4tML2j2T0NI00NUsPFfLNhjKnr4OFo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dPenraVinfjcty4s5td0FqGWCFsJkSJ65bWQuXhjRMdfS0uSF6F5PGp34m4B42Wkr
	 oCmTBl+hQaKD/H/roiP9jEYPS7YLapVB8wJXCRi9qF9eJ2iZ9cGkxsiMS6g4g/diDe
	 yf2iTSZGu+vzg00TiwKIPJdFLjRabj39FPx9Mc9vU6dpdpEdyoC3CONUMb6ONBvE2y
	 IebdRfZ9Gtlxt/+Qrsq9F01qvpU2OxB+gtLZQrP2T9QTKcvwDxMiSDp9A0cGrYRx3f
	 0H6OVSzOdivo7gzWsrdxkUFEY443EwHvyMdApVKgL/hA29VFpoo5ouKwuozWcuJQqC
	 Xd4du+WOIj5ug==
Date: Thu, 27 Aug 2026 18:25:01 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: artem.kuzin@huawei.com
Cc: catalin.marinas@arm.com, akpm@linux-foundation.org, david@kernel.org, 
	vbabka@kernel.org, cl@gentwo.org, linux@armlinux.org.uk, will@kernel.org, 
	mark.rutland@arm.com, liam@infradead.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, wangkefeng.wang@huawei.com, panov.nikita@huawei.com
Subject: Re: [RFC PATCH 00/18] mm: arm64: Add kernel replication feature
Message-ID: <apBqjq24aG_s2ZTM@gremlin>
References: <20260827161158.3618409-1-panov.nikita@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827161158.3618409-1-panov.nikita@huawei.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EFAF4A000E
X-Stat-Signature: 1cbb8uo7f91eysy3b7qdw6xgm1w3cfxh
X-Rspam-User: 
X-HE-Tag: 1787851509-991805
X-HE-Meta: U2FsdGVkX1/OZ7d4Iw2aweKsdiiXS5zWoFDLH4eWd6ZG1NgBCag3PySoY3YCxeFh0jlCS7r4luFGe+n0+1laUZiyyZvptRfeyZuwCxoZyeQ2QVelXkGFKjpEVpAvOODdN82L7AMKmc+erz7tLM40Pey5vvbKTWgrR18JW43/CjRNB17yHd/9vE2V/5hjXe4N52v/oMGMR74e/vShydqsFcA189cRlI8lQnHw5I13wbZvquFnGmvOXsXaPrde2HtoLZOoHfWo5+1JRzmFlUTJBYUwD36feEFDKJsBxY0OCK0g4QT4/KUsSHgtA5vD0IBLqxXcTA6ud90wHoiOef1hSeLa4/3TnF0BmQsWQUluO75cW7rupgULQrUWq/tR95SsHr0eQ24NGzWVwZMBtiMa7TcvgKRduiQOvolPQxfPG/VGrATkqXGfY1bbofAa/kRawxQ200eAL6aNxW/jkZV2qcHkgrMUGdREAmasUVGHoYpJyjUB9GqhkjFtWdp/755MSqUW9MaK30CIMrUqp705XYSPOfuVFYekjHOF6DhY+z6+pTRvaob9cTqGrfNMhdMX5JXwIl607wNFfmg8MD431oZNqa3RRLlUIb8RoUc7YcRwGBAG0M+sJCJw3Xwlj+ugi1car12eak6n3S6toMZtAWJCbmSkZtoWefPZd+ctu6Y8QXaD0ilxD5uYJ2ZbFeR8Pz3qHqdpssd1KbkIyfNzYfQUj1XczSBNJ7glFYP3JvE8Gyjb4i2vEJwFytvBbRwHBTAo0l7Czdz+Hi8nAZ003NC/xnPIRZAn7HD0qSGbP/xNk/AcxsRUIZSEdVh5+c6h/yf/dt0bRyNZQZ+EGGKzzjmiYh89SfyqDpSYrkA12w/LPea7wBNS2N4DGhpJ1K9AvVN6KUU2TwpU1K2WQa9ZBj9eoFjctbYUr4JRv/fhfcuYka7ku6d1CuTeVXDZCD3HTPGZuvkvqJvGq6TX+UD
 Ao9kELb0
 pPLvxtn2GVGHALwUSbgnYe6XCmjrew4j6HSeGHEJNr2nscvNgm1VNNpnZsvFT2OACbNBMFQ4/pbPWFqOAUkTv3fRD+U5EGIsoBAToDkmTv6h8uzeXb2/S09JH3qkaklqp4oO/3SV2yhNvyz/+RkVhhhULXzzzBICysbGuFK1fHW+7JxqghmiQapdsxDhGxJkZXdOCQr6k2UcsjeqgBF94D/Cn6I7UDtBISxIlHClS7PwHXMwwpVF095+Fx+Rgw4nM+q1Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Fri, Aug 28, 2026 at 12:11:40AM +0800, Nikita Panov wrote:
> Current status:
>
> There were several prior submissions with some sort of replication
> for NUMA systems, including one from our side for the x86_64 platform.
> In the last couple years, several research articles related to solving
> locality issues on NUMA machines through replication emerged as well.
>
> [1]  - arm64 kernel text replication
> [2]  - x86 NUMA-aware kernel replication
> [3]  - x86 kernel text replication
> [4]  - NUMA replication of user data
> [5]  - Mitosis: Transparently Self-Replicating Page-Tables for Large-Memory Machines
> [6]  - WASP: Workload-Aware Self-Replicating Page-Tables for NUMA Servers
> [7]  - PaCaR: Improved Buffered I/O Locality on NUMA Systems with Page Cache Replication
> [8]  - Memory page replication for Linux on X86 processors

(What happened to 9-11? :P)

> [12] - Optimize this_cpu_*() ops for non-x86 (ARM64 for this series)
>
> As of today, none of it was merged into mainline.

I mean :) maybe take that as a hint? If a number of series trying to do X get
rejected by upstream, that is maybe suggestive of barking up the wrong tree?

> However, after thorough re-evaluation, we were not able to observe
> performance improvement for the x86 platform, so we have decided to stop this
> direction and switch on arm64.

I mean, why? You should provide details here, this is quite hand-wavey. You are
also proposing core mm changes for something that seems specific to unique
hardware as far as I can tell, which is a big ask.

<snip>

> Known problems:
>
> 1. Other combinations of base page size and va size (especially with 16K pages)
>    should be adapted and verified.

Umm, yeah this is basic stuff for upstreamability :)

> 2. Replicated translation tables for the vmalloc region are not local right now.
>    Allocation performed with default memory policy, so translation tables
>    for kernel modules will not be local. However,
>    replicated text and rodata of the modules are local.
>    In general, vmalloc patch should be cleaned up.

Again, this is really more of an alpha pre-RFC I'd say.

> 3. Any modifications of kernel PGD level. These modifications
>    should be synchronized across all replicated tables.
>    Right now, for example, memory hotplug/hotunplug
>    lacks this support, vmemmap and kasan regions for
>    added memory might not be observed correctly. This could be fixed
>    by patching all places in the kernel where swapper_pg_dir
>    is modified, or by "lazy" propagation on kernel faults in the pgd-level.
>    Propagation approach will not help in the case of pgd_clear()
>    on swapper_pg_dir though.

Yeah OK this suggests to me you've got the locking and synchronisation all wrong
and it's worrying :)

In general I really oppose anything that adds additional kernel page tables or
complicates kernel page table handling.

We already have singificant complexity and bugs/races emerging from people doing
odd things with kernel page tables on assumption that it's 'safe'.

You'll need very compelling evidence to justify anything that touches such
sensitive stuff.

The code is also fiddling with PGD assignment in a way that could interact badly
with how these PGDs are synchronised. These things are very subtle, and even if
it's limited to one arch the core mm code is not.

>
> Overall, this patch set in an early PoC stage and require some improvements.
>
> Overhead:
>
> Memory overhead for the kernel itself is about 30MB per NUMA node
>   on our deployment. For kernel modules - depends on their sizes, but text
>   and ro-data are not that big.
> CPU overhead - replication performed on the boot stage. After boot
>   only "rare" operations are slowed down -
>   module loading, text patching, kernel table pgd-level modifications.

Hmm. I wonder if they're as rare as you think though? It all depends also on how
slowed down they are, how that manifests, etc.

>
> Performance evaluation:
>
> Our local testing was performed on
> Kunpeng 920, 128 CPU, 4 nodes, 100Gb for each node.

Thanks for providing details of the hardware used!

>
> Microbenchmark:
> Kernel module with a huge text section (~50MB) filled with CPU-bound
> instructions. For each NUMA node thread is spawned, each thread in a loop
> executes isntructions. Total execution time of each thread is measured.
> The insmod call bound to node 0 through numactl (less time is better).

So wait, you bound it to node 0, then rely on kernel text replication to improve
performance due to a bad hint?

That seems like you could fix the issue by binding correctly? :)

>
> node                 0        1        2        3
> Before time, s     5.567    7.598   13.294   18.905
> After  time, s     5.469    6.960    6.777    5.531
>
> Diff               ~0%      -8.5%    -49%     -70%
> In this benchmark, interconnect was not used by any other actors,
> so microbenchmark numbers might be significantly improved.

This benchmark seems entirely synthetic and it seems odd to me, prima facie, to
implement a feature to correct for incorrect NUMA binding?

Maybe I'm missing something though.

>
> Customer's evaluation:
> We were provided with the following feedback on this patch set
> directly from our customers. Unfortunately, we do not have details
> regarding how these measurements were done other than it was
> a production setup.
> Evaulation was performed on Kunpeng 920 and 920B platforms:
> CEPH distributed storage +5%
> StarRocksDB              +5%

This isn't hugely encouraging.

>
> Couple more words about patch set and technology:
>
> This patchset was merged into the innovative branch of
> the openEuler distributive 1.5 year ago (openEuler-25.03)
> and was actively tested in production environment [9], [10].
> In addition, besides the kernel part, we have published
> user space replication (for translation tables and rodata) as well,
> but it is very complex and experimental
> even compared to this patch set [11]. With replication in user
> space, we were able to achieve the following numbers in
> performance improvement:
> MySQL + sysbench      1-6%
> Spark TPC-H           4-20%
> Phoronix test-suite   0-25%

These seem very vague and wide-ranged, I'm not sure they're really saying much
at all?

>
> Discussion:
>
> The main question we'd like to discuss is the following:
> Should the kernel replication feature be merged into the Linux
> somewhere in the future? In any form, not specifically this patch set,
> but the core concept itself.

I will leave the broader topic to the NUMA experts.

>
> If the answer is yes, please share your thoughts on this patch set. What else
> should be fixed (or reimplemented and redsigned completly) in this patch
> for mainline in your opinion? We'd be glad to do it, and in that case
> I'll send an updated version in the near future.

Glancing thorugh, The patch set seems very far from being upstreamable:

	if (kernel_replication_enabled)
		pr_info("WARNING! WARNING! WARNING! Kernel replication enabled WARNING! WARNING! WARNING!\n");

For instance... this really shouts some alpha effort.

Annnd :) this:

	if (rwsem_is_locked(&mm->mmap_lock))
		locked = true;
	else
		mmap_read_lock(mm);

is just utterly, utterly broken.

rwsem_is_locked() can be raced at any time, you don't own the lock so it can
just be unlocked underneath you.

That you do that suggests to me you've not thought about locks correctly _at
all_ here.

And as I said above, locking issues around page table walking and manipulation
is very subtle and difficult to manage correctly.

Then there's stuff like this:

		/* TODO: remove last condition and do something better
		 * In the case of a folded P4D level, pgd_none and pgd_huge
		 * always return 0, so we might start to replicate empty entries.
		 * We obviously want to avoid this, so the last check is performed here.
		 */
		if (pgd_none(*orig_pgd) || pgd_val(*orig_pgd) == 0)
			goto skip;

This whole block seems confused, and it's nitty but you're using completely
incorrect comment style for the linux kernel which again doesn't fill me with
confidence that you've really thought things through or understand mm code
correctly.

Your replicate_memory() function seems to not synchronise _at all_, but you do
for some reason synchronise on dumping memory, bizarely.

You write a ton of duplicative page table code that doesn't seem to handle huge
pages at all, again doesn't seem to be performing any locking correctly at all,
and yeah the list goes on.

In general the code looks like an alpha experimental thing and a million miles
away from anything even vaguely upstreamable.

And in general for this kind of thing - the devil is in the detail.

So if you want to assert that something is viable, you need code that at
least looks _vaguely_ upstreamable and demonstates understanding of the
issues at play here, and you are not doing so.

In conclusion:

- 12 (or is it 9? :) attempts have been made at this kind of thing and all
  were rejected - this isn't an encouraging sign that the approach is
  viable.

- You've already found it has limited use, and your benchmark numbers seem
  either entirely synthetic or bordeline not statistically significant.

- The code is, as discussed, not even vaguely close to being upstreamable.

So overall it seems to me that perhaps better NUMA policy decisions could
solve your problems.

But yeah, what's presented in this series doesn't seem like a worthwhile
road to travel down to me.

--
Cheers, Lorenzo

