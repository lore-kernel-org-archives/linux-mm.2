Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A942E909DC
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 16:48:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 427706B0088; Tue, 17 Feb 2026 11:48:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FF056B0089; Tue, 17 Feb 2026 11:48:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 334FB6B008A; Tue, 17 Feb 2026 11:48:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1ACAC6B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 11:48:58 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A798957C03
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:48:57 +0000 (UTC)
X-FDA: 84454533114.22.A3813EC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id D38DF1A000F
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:48:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771346936; a=rsa-sha256;
	cv=none;
	b=HDYu5ge+3yqK68G/Rni5Y5jRpfZCdFDbl8dEE4HS2xdZ31P6Fe8LnDCJ57hNizTTGaMsF5
	YjWNKiVT7DedWTlR/aOKLlCp3A0JGvQG4YCT8jdPiBmmeyZE1JgmF3kJ7qOTMKl61xztk7
	KCwy+XEQur5fIE/P5xb4yAik7yGsKkE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771346936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vZr4yoO4SgYfJQgJVvoR2/M6Z9qi/RI9xdeWmpjpuAE=;
	b=SoK97E8yAPwyU80BYt9ZjvGXgq7ev/JVvnxBvyxc2/7mEh7NvlF2ZHg/gHrabby4ovw4pi
	6LBx/WHjbVz0dsue6QIZ+hcFeVmTvfeospDWOJghvEjVMBuCOClL7VlISWnKjzBVv4njD9
	PiCvj2HU+ZWfzCDkdKKuXyK5V7QmU6w=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5F4101477;
	Tue, 17 Feb 2026 08:48:48 -0800 (PST)
Received: from arm.com (arrakis.cambridge.arm.com [10.1.197.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C339F3F62B;
	Tue, 17 Feb 2026 08:48:52 -0800 (PST)
Date: Tue, 17 Feb 2026 16:48:49 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>, Jisheng Zhang <jszhang@kernel.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, maz@kernel.org
Subject: Re: [PATCH] arm64: remove HAVE_CMPXCHG_LOCAL
Message-ID: <aZSb8VbCC471Cw1X@arm.com>
References: <20260215033944.16374-1-jszhang@kernel.org>
 <aZL46z1UZkQlF3Dd@willie-the-truck>
 <89606308-3c03-4dcf-a89d-479258b710e4@arm.com>
 <aZRyzy0SJ8uF3K2J@arm.com>
 <aZSChrCVnoWSe7h0@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZSChrCVnoWSe7h0@willie-the-truck>
X-Rspamd-Queue-Id: D38DF1A000F
X-Stat-Signature: 9qadq9t3dufap466ees5pifp4kkj5thf
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771346935-902140
X-HE-Meta: U2FsdGVkX1/JoRrrJFj0Bd/8PBVWiKNT9gPJqGqevB1MaYyc5Nhfl/5cGtbYl9RmSTVzM6GG9byY3hP6G786Y67S4qXb4QwZVIYR+otKKZhpL2MUs/2T8Cs6uVCxOFTvysSdep1UhYZ1b5ZgvOUIZexVGH9X7B77LNH3cB5eng7SzIHLH5r9g6p83ONbQAJRY5z/skBhwAmfyIM59dQ5+9bcutMEfzk9vaSEOjiB0GEladUKo5ypErCxQVYpE2+Zi77gD7VpXnp/KJy2PycjvXlqUckdwiUsUOVZVI47Hf40DcKCapR6fpsU2WMpHVjyR+6adcVlRvKkRy/whFnK8EzDco6KaKKWbaLnxpmC+wj+gksE5o8h6DGRVBjez6AiM7KS2HArWNBV8xb/SXH9JSB3lE/C6EJanDXPh/oF0I3UUg6365XDEvjnId1DcRA9FZ3tyDV3fgwJAuGpBIn+b0VrgE2PaQA3w5erXbCRMoKTRJBl8Fo+juyH8tbXDXIvBHQkCGIXLPlrWy8WkC2WhObUR3iJBtXq9x6w6hvVam0MNOazVYDIPAm0SVpoH2N56lUtAdwH+/0FUJuCkdyV1JD2LFJezUqu0AREjSMta726pWxr3m6HpMS9n3NRhMpY9C3bKn+A2evuXOMXveg2UdYBom+X2fOKYgWKbgKo6POCJ29x3zH0+L5qQhzWC/NzWVG6Ym5Mz+DjR37Pmwcpmkf468qR9O8/f3kM6A61XNy9ccLqJt0UxiWIocjmE8lZK1MfOPb5KSny9SxFIRCNSqpnC3JN39+5IiapWuNH1kMMBHbJeel8DlybxYQp6pcgHJ2uhKDfT/FFTNz2FhY0a9Jdhe1nXSUGxE2rtCfA69kVja7ro1ksUEzALlmZ2I8L9ofyKZRfmAbCVMfZCUhL2DMos3WQrtfH98P6buSUVUtiJ+kGeWLkaB29dJwnHEYQLC4qBFcb5zjl9z1olS9
 NAupzaHx
 b0AFlxPlAMThuA6GOqyBu2rIC2b7FyZTBFEBb8dtC3SFpjtONBU23ZTfvSrrBpFsJwAXHANzZH1BrSzFGEO2uaUL04ICAuSMiV2Z+hjZ5aU62sZUntUG30gat1j+bSpImhUC30UO7QA56fyYLvwF+cN5tIlbz0PZhTim0c/fCYCfMocK9LTb+QzBdZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 03:00:22PM +0000, Will Deacon wrote:
> On Tue, Feb 17, 2026 at 01:53:19PM +0000, Catalin Marinas wrote:
> > On Mon, Feb 16, 2026 at 08:59:17PM +0530, Dev Jain wrote:
> > > On 16/02/26 4:30 pm, Will Deacon wrote:
> > > > On Sun, Feb 15, 2026 at 11:39:44AM +0800, Jisheng Zhang wrote:
> > > >> It turns out the generic disable/enable irq this_cpu_cmpxchg
> > > >> implementation is faster than LL/SC or lse implementation. Remove
> > > >> HAVE_CMPXCHG_LOCAL for better performance on arm64.
> > > >>
> > > >> Tested on Quad 1.9GHZ CA55 platform:
> > > >> average mod_node_page_state() cost decreases from 167ns to 103ns
> > > >> the spawn (30 duration) benchmark in unixbench is improved
> > > >> from 147494 lps to 150561 lps, improved by 2.1%
> > > >>
> > > >> Tested on Quad 2.1GHZ CA73 platform:
> > > >> average mod_node_page_state() cost decreases from 113ns to 85ns
> > > >> the spawn (30 duration) benchmark in unixbench is improved
> > > >> from 209844 lps to 212581 lps, improved by 1.3%
[...]
> > > > That is _entirely_ dependent on the system, so this isn't the right
> > > > approach. I also don't think it's something we particularly want to
> > > > micro-optimise to accomodate systems that suck at atomics.
> > > 
> > > As I mention in the other email, the suspect is not the atomics, but
> > > preempt_disable(). On Apple M3, the regression reported in [1] resolves
> > > by removing preempt_disable/enable in _pcp_protect_return. To prove
> > > this another way, I disabled CONFIG_ARM64_HAS_LSE_ATOMICS and the
> > > regression worsened, indicating that at least on Apple M3 the
> > > atomics are faster.
> > 
> > Then why don't we replace the preempt disabling with local_irq_save()
> > in the arm64 code and still use the LSE atomics?
> 
> Even better, work on making preempt_disable() faster as it's used in many
> other places.

Yes, that would be good. It's the preempt_enable_notrace() path that
ends up calling preempt_schedule_notrace() -> __schedule() pretty much
unconditionally. Not sure what would go wrong but some simple change
like this (can be done at a higher in the preempt macros to even avoid
getting here):

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 854984967fe2..d9a5d6438303 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7119,7 +7119,7 @@ asmlinkage __visible void __sched notrace preempt_schedule_notrace(void)
 	if (likely(!preemptible()))
 		return;
 
-	do {
+	while (need_resched()) {
 		/*
 		 * Because the function tracer can trace preempt_count_sub()
 		 * and it also uses preempt_enable/disable_notrace(), if
@@ -7146,7 +7146,7 @@ asmlinkage __visible void __sched notrace preempt_schedule_notrace(void)
 
 		preempt_latency_stop(1);
 		preempt_enable_no_resched_notrace();
-	} while (need_resched());
+	}
 }
 EXPORT_SYMBOL_GPL(preempt_schedule_notrace);
 

Of course, changing the preemption model solves this by making the
macros no-ops but I assume people want to keep preemption on.

-- 
Catalin

