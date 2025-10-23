Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC0E8CCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 12:31:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE9AF8E0010; Thu, 23 Oct 2025 08:31:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9A448E0002; Thu, 23 Oct 2025 08:31:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D7398E0010; Thu, 23 Oct 2025 08:31:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 83D5A8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 08:31:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1F9CB88F2A
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:31:46 +0000 (UTC)
X-FDA: 84029315412.03.6611303
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4A6D5140004
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:31:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761222704; a=rsa-sha256;
	cv=none;
	b=Vh3t55fDePCzs7BQhsKFazJ/ov7C7J7wj0Bd9SAomBeDs18lLIT6iSMYzHAc3iywRmqdBq
	ck6o2NY+EiRBR5W4shg2PTrNUo5tZ7VgdQ2T+7BD55YfauRLywI8v3Hfn8tSOf7ziZYg8C
	yXc5OB+w/bFDZNzjD++F3ZuF8jd7aNw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761222704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gmxER2wpKvZxNR6XtOG/BjQc52jijuK0vpZ63oumtJg=;
	b=h2s+UFlohTNuKgAsAQJyydyislcsJJOiuYGhAzfJCsn+yxHSxcP05QEX+8ILw+lmaYOwnT
	30T9QuGYxC3KUeuW9hDgjAQKBly5HHpBWpAgEb4GMapFhE1dApjTGQkYCQFIjYnDMfxBoj
	aDYqIxWs4kKT0+7lh1C3t4Ai06dtrBA=
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4csljb4ypmz6L4tf;
	Thu, 23 Oct 2025 20:30:11 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 3A77814010C;
	Thu, 23 Oct 2025 20:31:39 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 23 Oct
 2025 13:31:38 +0100
Date: Thu, 23 Oct 2025 13:31:36 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Conor Dooley <conor@kernel.org>, Catalin Marinas
	<catalin.marinas@arm.com>, <linux-cxl@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-arch@vger.kernel.org>,
	<linux-mm@kvack.org>, Dan Williams <dan.j.williams@intel.com>, "H . Peter
 Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
	<james.morse@arm.com>, Will Deacon <will@kernel.org>, Davidlohr Bueso
	<dave@stgolabs.net>, <linuxarm@huawei.com>, Yushan Wang
	<wangyushan12@huawei.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>, "Mark
 Rutland" <mark.rutland@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Andy Lutomirski
	<luto@kernel.org>, Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH v4 0/6] Cache coherency management subsystem
Message-ID: <20251023133136.00006cdd@huawei.com>
In-Reply-To: <20251022122241.d2aa0d7864f67112aa7691bf@linux-foundation.org>
References: <20251022113349.1711388-1-Jonathan.Cameron@huawei.com>
	<20251022122241.d2aa0d7864f67112aa7691bf@linux-foundation.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Stat-Signature: da9cwqbkydix6ks4to8jba7f85468ne5
X-Rspamd-Queue-Id: 4A6D5140004
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761222703-498101
X-HE-Meta: U2FsdGVkX192fmtTm0gLMvHhEGv5bGpqUMAEg71fBH1gVs5u6QtfLIvcMnprZ0wWr/0tzrxSsSo8KQSgzlYpqDzn6OlpqgrI/rNZE3KK4iINd5eLlILZdBjovZLq5h/FtQ/Uz8Fy3OuJTbqR2iNp2vYlL613IsAy4k885qMCsJ0JP7BOzW759p3MhRAT2TcafGU/V76cft5bBF7hKLTk6QKNsXFTzSrUrBRue2MitYxvUhhikk8bxT9ZYJ7sZr6bq7EFbx5uUJr32P62cZXQpwD02T1NjsZ5R3xRDwmo7BptQ46x5WPiU+NFdQUYeRxuMgAtVujM3307haMbkNbpcHyFhhxemUxTSkDsDPh905GnGgStynIvO4nHM+11xt9KG/548ALpSpQFv1gpG7ii3B3/MYAhFTSilTOGZSr0LN6g3WxII1NkfsSZZFvr2BGV+0gybbVbphc4nVTXM2wjI1MfnH/CQBxUacEEgKhB1kNZa1R1E1KBLaTBX/Wqc+iFhhZ4IbmXDxwxGkBqjEtMA24BA0BUBzcH+LkpWA8VdZWThrsFGh4Qghm1xyVa1vxmsKF6c58JQWa/eXDe46PJ12DzjMNws+LTnX98NEcCjxVXWIjxyMW8vjA9CLLZEXWmVHVkBQDARtQ/cEqnVa7Ahe1rlvSqk4Kb3vD2k00AXhCognkss8ek4adQmVufZ2vO2EMQLLhs93OJcA/4hh5bOehDEDr3c0XvTxZiRCChdqFmtWBrpL34xNGkfO9o/NDorXpHG0tKolbJQ2gttI8QL70lAEf9kpnMnZM4zDjGaoQgV+pJHZdeFtKCho0RrIaK8Ld8YyaL+MzLLtBgw3DHi1uPFMe0s46IBYeZtlW2M/rFn44CEEo4Z/I0nLFqVQmZVzAb3GJIA9eWhV7SutsnBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Oct 2025 12:22:41 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 22 Oct 2025 12:33:43 +0100 Jonathan Cameron <Jonathan.Cameron@huawei.com> wrote:
> 
> > Support system level interfaces for cache maintenance as found on some
> > ARM64 systems. This is needed for correct functionality during various
> > forms of memory hotplug (e.g. CXL). Typical hardware has MMIO interface
> > found via ACPI DSDT.
> > 
> > Includes parameter changes to cpu_cache_invalidate_memregion() but no
> > functional changes for architectures that already support this call.  

Hi Andrew,

> 
> I see additions to lib/ so presumably there is an expectation that
> other architectures might use this.

Absolutely. It's not ARM specific in any way. Given, in at least some
implementations, it is part of the coherency fabric and there are
examples in the past of people mixing and matching those with CPU
architectures, it's more than possible a given driver might be applicable
across different CPU architectures.

> 
> Please expand on this.  Any particular architectures in mind?  Any
> words of wisdom which maintainers of those architectures might benefit
> from?

My initial guess for a second architecture using it would be RiscV
but I don't know if anyone yet cares about the any of the use cases.

The short answer is that it depends on whether the architecture
requires 'one solution' or leaves it as a system problem where
a driver needs to be loaded to suit the particular implementation.

Longer answer follows:

There are two aspects to when people might find this useful to
consider

A) The use case.  For it to apply to an architecture you need to have
   a requirement to support the case of content of memory presented
   at a PA to change without the host explicitly writing it.  That
   can happen for various reasons.
   - Late exposure of memory - security keys for pmem for instance.
     Until those are programmed any prefetchers will fill caches
     with garbage that needs clearing out.
   - Reprogramming of address decoders beyond the edge of where the
     Host Physical Addresses define what goes on.  This is the CXL
     case where there is a translation from Host Physical Address
     to Device Physical address which can change at runtime.
   - (not yet enabled) Interhost sharing without hw coherency. Necessary
     to flush local caches because someone changed the data under the
     hood. Because this happened beyond the scope of the local host
     normal cache flushing instructions might not do the job.
     Hopefully we will have lighter weight solutions for this.
So upshot today is that it is likely to only apply to server architectures.

B) Is there an architected solution for that architecture. (i.e. is it
   in the CPU architecture spec) If there is 'one solution', then
   registering the arch callbacks directly is sufficient. This is
   true for x86 as there is a CPU instruction that performances the
   relevant operations.

Arm decided (for now) to not go down the path of architecting this
in one of their architecture specs that licensees would then have
to comply with (I'll let James / others add more on that if they want).
There were already being multiple hardware IPs out there that providing
this feature as part of the coherency fabrics.  Earlier versions of
this series mentioned an attempt to provide a firmware interface to
hide away the complexity but that also turned out to be unnecessary
as everyone with a usecase had memory mapped devices the kernel can
directly control.

So there will be multiple different implementations on ARM servers.
I doubt we'll even keep it completely consistent across different
HiSilicon CPU generations. As per the discussion with Conor, there
are multiple agents each of which registers separately and has
no knowledge of the other instances. For now the ones I know of
are homogeneous for a given server, but it made no difference to
allow for heterogeneous cases (I emulated those to check).

So for other architectures, it is a case of which path do they want to
follow?  If they don't have existing instructions defined that work
for this, and have more than one implementer, then the approach seen
here should be useful. I think RiscV doesn't have such an instruction
so I'd expect this to be useful to them.  Not sure on other server
architectures as most of them today are much less diverse than ARM / RiscV
so a "one true solution" in an architecture spec is perhaps more likely.

In the various review rounds, we've had some discussion of the requirements
implied by the current simple interface (no ordering, single operation in
flight).  So I'd not be surprised if we have to make things a little
cleverer in the long run.  The HiSilicon HHA hardware interface is very simple
so I've supported what that (and the PSCI spec with sane options - see v3)
for now.

> 
> > How to merge?  When this is ready to proceed (so subject to review
> > feedback on this version), I'm not sure what the best route into the
> > kernel is. Conor could take the lot via his tree for drivers/cache but
> > the generic changes perhaps suggest it might be better if Andrew
> > handles this?  Any merge conflicts in drivers/cache will be trivial
> > build file stuff. Or maybe even take it throug one of the affected
> > trees such as CXL.  
> 
> Let's not split the series up.  Either CXL or COnor's tree is fine my
> me.

Thanks,

Jonathan
> 
> 


