Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AED04E7BD8B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 10:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E27B66B0088; Mon, 16 Feb 2026 05:37:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E07B96B0089; Mon, 16 Feb 2026 05:37:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D51876B008A; Mon, 16 Feb 2026 05:37:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1D736B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 05:37:43 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 75734160C70
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 10:37:43 +0000 (UTC)
X-FDA: 84449968806.20.D1DC8D7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id A5E1E40006
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 10:37:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771238261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6G9OIrwikXX06ngrkACcFDSGLG73f1EAq7od/HG9C04=;
	b=VZf1XOlaVsvjgXuVDKfiteL4CpIIK5Df2B4JikALayusEmpH/qjYsNsaz0R7Qct78sVe3X
	Dd/LjMptOg99FaS1qtvs9w8CobWsOSyJT0BQ27jBQ18o/+DVzAvZ6Qy50SnoSq9cmPUczY
	8LZjzI2/psZfrdhSZ1WtpK+BXoq5xQI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771238261; a=rsa-sha256;
	cv=none;
	b=Nkgico75AJKEe547xnocCVMyZm4cy4d1SxKpCzlBm0qwjj9qhCjHZM8IKSft1SrM8LClOu
	sF6PG8DDM2+eAsAnIS8la5kqPodVerv3LCkgGEx7JKCNOiODDHd7sJ1a1yNuH0S8nI2Q6c
	wxh6G4X7XfDMPVBh1Oi6PRK2E1tV54c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 44FEA150C;
	Mon, 16 Feb 2026 02:37:34 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 03B253F73F;
	Mon, 16 Feb 2026 02:37:38 -0800 (PST)
Date: Mon, 16 Feb 2026 10:37:35 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>, Tejun Heo <tj@kernel.org>,
	lsf-pc@lists.linux-foundation.org, Linux MM <linux-mm@kvack.org>,
	"Christoph Lameter (Ampere)" <cl@gentwo.org>, dennis@kernel.org,
	urezki@gmail.com, Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>
Subject: Re: [LSF/MM/BPF TOPIC] Improve this_cpu_ops performance for ARM64
 (and potentially other architectures)
Message-ID: <aZLzbwkjQP8KDym_@arm.com>
References: <CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com>
 <aY0Q7QhGDKwKk2ie@slm.duckdns.org>
 <CAHbLzkoE0UQLZSKQJttv1_XGT-6HPKdj5o7aYnpuiXEyvbAHxA@mail.gmail.com>
 <aY4Ty6G6A3478_JS@arm.com>
 <82420c8c-d7b0-4ebf-870f-a6061fa4428f@arm.com>
 <aY4r0lL9oGE7tzJW@arm.com>
 <7de4f82a-5165-4d92-95f5-a28498ba8940@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7de4f82a-5165-4d92-95f5-a28498ba8940@arm.com>
X-Rspamd-Queue-Id: A5E1E40006
X-Stat-Signature: 5ss3j6dz64dg4iiskt5hrounqn9oaxyd
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1771238261-784261
X-HE-Meta: U2FsdGVkX198MU1CMj48cwdSuCJJvUOXKLIBLSUG3od9E7K/8XlFHkohSPXEJjLFZXEpevwn4qoVhDQtrHJHzwUu8hSP0GIuNjzB+Z6VGxXUlAZ+cfsi104II/mnLuyBfVUyZvLYVubPaK19IRfqv+8M2ElioPHS5SiK+qXD+PvTiRRCdv/3i7QNlsZQDy7e79PdfQ35P96/T3FWj9vCngbj7OVfWMHZOUw6T1/96USjsl0C+bq7z+025Vc1WOUvr8B6CUtLtEW5JBIi7kK0khb3PlvNpxoenBH1NgqgKPJNBItxM0p3p1FE8u2FsI7rwznTW6PB24E19OO1NjXw0q+ARZl9cXI+Srj5JaYMZvZvT+NiiCaxT/Hgjs0pSQEPRT8XieoX2TXnWuIuS/n1oTi7yi2U+Zrf7lANRuHDv9dho5BZZe6AMaoxTzFaNb4HXkpNzjdjp2cBJ5YtDMnJvIiSy899+jmedZb4kky5tT1Sb5B1SVA10ZI7UVskpmoeEcA9M3IXSofSZOUBdY3xQDyv7LQkz83VdravMXPe4nWZVUHHmhjrX9BfGxqGviX+6CxGddqtsVbVrcn4X+7KmW+A1UE443JtPS+tzV0jf7r/NhkgDeEklZlqxE+X29LLhER9D6V2n3DWXXZxPheUUFUduFhE4MsXK1cyvGHxoHDIq2+u8+uGmbn7Cj7xjnI1M1Wp4c9iyxTebCAE7+gTsMFlLnB6qX8RAbPjZ5eLdIV92LWCG0g7F7x5xDuiuV6EMru5wqSmhsMZNPG3GeJZ3FMscOacPl6WMp/nDwQbL1st/bdF9ErqRpzziCnKm/3U8RFaH+PBuyDH+JiWxQAW+kytX1FEQkTlgkxHYeS0iu1OQZ1/IgPEnwgHsS0impU4id5e3wdupo4ryDvQLhCeK5e3lr+pS+0uWi9j2f+8Bd7WK/MZJdcHxmn/qgiYX8VC2DL+HxKd9NSXyW3sluw
 uvqHON8a
 /SXo6Q3ThE9moYQ4bNcA+Y7Xr5tb8AiN3HC9z1nzNG2I9POCKDJrx3T5jfZnCc+xvytFGB6SIFWYuSimeiHfzVr5d1+wf+u5RkxTlTKZO2Le5P86ZK6ZXZ3FkxR8dPtO+j6SFurKlmmmos3U6vuamn+2jZ1Wr2G7lI35d1bQO4wHNZyTvzk8gauK/11ttQe9hf362VVBHK+yqUr90eOm/76G5/x1vGZE7542I8SZ8yCwyfieEzPTZdWsq3iSfGfWeoPUx4+BoI+LJfHbozgrtKJ/Kpkv9/NJmFuSPaUF1tA9v2Cw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 09:12:55PM +0000, Ryan Roberts wrote:
> On 12/02/2026 19:36, Catalin Marinas wrote:
> > On Thu, Feb 12, 2026 at 06:45:19PM +0000, Ryan Roberts wrote:
> >> On 12/02/2026 17:54, Catalin Marinas wrote:
> >>> On Wed, Feb 11, 2026 at 03:58:50PM -0800, Yang Shi wrote:
> >>>> On Wed, Feb 11, 2026 at 3:29 PM Tejun Heo <tj@kernel.org> wrote:
> >>>>> On Wed, Feb 11, 2026 at 03:14:57PM -0800, Yang Shi wrote:
> >>>>> ...
> >>>>>> Overhead
> >>>>>> ========
> >>>>>> 1. Some extra virtual memory space. But it shouldn’t be too much. I
> >>>>>> saw 960K with Fedora default kernel config. Given terabytes virtual
> >>>>>> memory space on 64 bit machine, 960K is negligible.
> >>>>>> 2. Some extra physical memory for percpu kernel page table. 4K *
> >>>>>> (nr_cpus – 1) for PGD pages, plus the page tables used by percpu local
> >>>>>> mapping area. A couple of megabytes with Fedora default kernel config
> >>>>>> on AmpereOne with 160 cores.
> >>>>>> 3. Percpu allocation and free will be slower due to extra virtual
> >>>>>> memory allocation and page table manipulation. However, percpu is
> >>>>>> allocated by chunk. One chunk typically holds a lot percpu variables.
> >>>>>> So the slowdown should be negligible. The test result below also
> >>>>>> proved it.
> >>> [...]
> >>>>> One property that this breaks is per_cpu_ptr() of a given CPU disagreeing
> >>>>> with this_cpu_ptr(). e.g. If there are users that take this_cpu_ptr() and
> >>>>> uses that outside preempt disable block (which is a bit odd but allowed),
> >>>>> the end result would be surprising. Hmm... I wonder whether it'd be
> >>>>> worthwhile to keep this_cpu_ptr() returning the global address - ie. make it
> >>>>> access global offset from local mapping and then return the computed global
> >>>>> address. This should still be pretty cheap and gets rid of surprising and
> >>>>> potentially extremely subtle corner cases.
> >>>>
> >>>> Yes, this is going to be a problem. So we don't change how
> >>>> this_cpu_ptr() works and keep it returning the global address. Because
> >>>> I noticed this may cause confusion for list APIs too. For example,
> >>>> when initializing a list embedded into a percpu variable, the ->next
> >>>> and ->prev will be initialized to global addresses by using
> >>>> per_cpu_ptr(), but if the list is accessed via this_cpu_ptr(), list
> >>>> head will be dereferenced by using local address, then list_empty()
> >>>> will complain, which compare the list head pointer and ->next pointer.
> >>>> This will cause some problems.
> >>>>
> >>>> So we just use the local address for this_cpu_add/sub/inc/dec and so
> >>>> on, which just manipulate a scalar counter.
> >>>
> >>> I wonder how much overhead is caused by calling into the scheduler on
> >>> preempt_enable(). It would be good to get some numbers for something
> >>> like the patch below (also removing the preempt disabling for
> >>> this_cpu_read() as I don't think it matters - a thread cannot
> >>> distinguish whether it was preempted between TPIDR read and variable
> >>> read or immediately after the variable read; we can't do this for writes
> >>> as other threads may notice unexpected updates).
> >>>
> >>> Another wild hack could be to read the kernel instruction at
> >>> (current_pt_regs()->pc - 4) in arch_irqentry_exit_need_resched() and
> >>> return false if it's a read from TPIDR_EL1/2, together with removing the
> >>> preempt disabling. Or some other lighter way of detecting this_cpu_*
> >>> constructs without full preemption disabling.
> >>
> >> Could a sort of kernel version of restartable sequences help? i.e. detect
> >> preemption instead of preventing it?
> > 
> > Yes, in principle that's what we'd need but it's too expensive to check,
> > especially as those accessors are inlined.
> 
> Could we use bit 63 of tpidr_el[12] to indicate "don't preempt"? a sort of
> arch-specifc preemption disable mechanism that doesn't require load/store...

As long as it doesn't nest with interrupts, in which case some refcount
would be needed.

But I need to check Yang's emails to see whether the actual TPIDR access
is problematic.

> > For the write variants with LL/SC, we can check the TPIDR_EL2 again
> > between the LDXR and STXR and bail out if it's different from the one
> > read outside the loop. An interrupt would clear the exclusive monitor
> > anyway and STXR fail. This won't work for the theoretical
> > this_cpu_read() case.
> 
> Could you clarify that last sentence? - we don't need it to work for
> this_cpu_read() because we don't need to disable preemption for that case, right?

Mostly right but there can be some theoretical scenario where a thread
expects to be the only one running on a CPU and any sequence of
modifications to a per-cpu variable to be atomic:

https://lore.kernel.org/r/aY4fQOgyx3meku3b@arm.com

-- 
Catalin

