Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 630E1E909A5
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 13:53:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 335436B0005; Tue, 17 Feb 2026 08:53:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E26F6B0089; Tue, 17 Feb 2026 08:53:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20F006B008A; Tue, 17 Feb 2026 08:53:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0C0BD6B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 08:53:29 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4BC5B14011C
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:53:28 +0000 (UTC)
X-FDA: 84454090896.15.45245D5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 330AA100015
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:53:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771336406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EPdQK8aFVRc+xMp3PHP6ybCoxuLM+Y94zWWJfZrxaZ0=;
	b=f6B6jaGq3upkiwasU7pR1K8TUKn4d1DHaAUOL5GZQe2amxldpui8u+7Pz1wUjZ76i/Xrj/
	qWKgef5j3gIuIvQ9NTlaFWi4g0k3uRkaapKXVPrMLckyAz0on14qdPbgBJBQ7ewnU/0O70
	apLfBjAgAXSxWXZL324AZbUdgcLKjbY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771336406; a=rsa-sha256;
	cv=none;
	b=Eov8tsxge7sY5r831i9PlJyR+6PpFhvwe3y0UcELJpq26je0t4ufendbCQzpwCYOcegM2k
	LXasbJN2lWJ+s0FQ4/4Iy7wlK6MPTAocVt4xFTDBzzNnfAokzxs4XQCElg5TvBxmFG2/VO
	Pz9lMsYY1QkL7wkxerl2KTYrdeK1iMI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 823D51477;
	Tue, 17 Feb 2026 05:53:18 -0800 (PST)
Received: from arm.com (arrakis.cambridge.arm.com [10.1.197.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E642F3F632;
	Tue, 17 Feb 2026 05:53:22 -0800 (PST)
Date: Tue, 17 Feb 2026 13:53:19 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Will Deacon <will@kernel.org>, Jisheng Zhang <jszhang@kernel.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, maz@kernel.org
Subject: Re: [PATCH] arm64: remove HAVE_CMPXCHG_LOCAL
Message-ID: <aZRyzy0SJ8uF3K2J@arm.com>
References: <20260215033944.16374-1-jszhang@kernel.org>
 <aZL46z1UZkQlF3Dd@willie-the-truck>
 <89606308-3c03-4dcf-a89d-479258b710e4@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89606308-3c03-4dcf-a89d-479258b710e4@arm.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 330AA100015
X-Stat-Signature: bdr1g4de96e5axz8487jnsun4px1iryr
X-Rspam-User: 
X-HE-Tag: 1771336405-698913
X-HE-Meta: U2FsdGVkX1+VOxVl6Jj/M02u9GllDyzp2MS+ds++PHPgqU2GILiXW2RLbudCAx5dEXw0Bzzb7Cl8tQerTrkjgq1mvTKiNaeLojDaCw3pC+NI8RAY1hhF+hDBR2jYZoLKhiLNdJD74J5HSlsR8zSrLDeWSpvQ6phz/j11LJ8+EQPzcc+XkhyExdPrv/TwSG5PvLlZttGlse5wdGxU5EEcbrMarWoM7T5/c5yfx2yoLCisBKI7rJ3R2kOxVrjI0u7wUnzxEbpkbMJa/0ylWlwuUNsnoAyX8hZ4OApswM6w/BhEyd2LoZKfEOXoVNrEh2HVfBkvYCkutkK+I+E6X+Psw5SMfdWHCeO6UzVxg0x/gbslS9SrqhS9SVYVdqe6FTKMLSmx6AnPIVJPGJtBTF4glAGWDLoUcotVoK4cqEzonk+kFhLA2QB86vIl44avtF1bxi3CYMdrzvF2suyTaQGFYmdVdx9XlRg1U2KEW8nAnZ/Tfaae08kAr3FM7Dl+TPd77zjDxQkwn2FlWFC0KSaJPewj2FoF1KOnsVXqCjXSMp5Hzmgm7TNrvHpfP7lDMximDiVCC5MmjPmAA8ZB5oFwCjB5Szw//7EWya4fZpczFeIWPm5kYT+Wfjaaibw6k1ZsTuzTO1mWuHfNtEpC7+Es3EsYm5ZN1hJsfIHOUbUPVAI2Hc7TdnQzHAxQIeDOJzp4mytNeo4+AOex6ytHKGpmZFi/PGwNwUObEk+0iwRv6ndx8bbBxj8Y+SFrJlBBt+J+AWHphfoe3unjGETVYerqSHH6AOwc1bkc7wVdbfccZ5qID7VoJgEFkA66DzCFyW6luZkMj7TvSP+s1XEEOPIcHlq4QCruSPuXmAB/bl3AG8leb7B3y5wu/uDnVCCObWmrFW78icp7hjXtfULKXYodErfCQK1IVtTqV28K5xCU4ZrUGYFcKrlKcLimbUAYIEQEz9Ww8KBHAgbYjAR9BCQ
 /Vut8uU0
 zBq91/A4xaC226dDlnb1CgnGKR+ut4WTQP7PrJDigT0wn1Dyb7IbG2gfTRSZofYZWsSniz2xZxtwM7CGnPDnLjHEjM4C89JkQeZE6OiZ0LLxBnQFLZLy2Ie1mmA6N3ZmVtO1AOc5XK8vMsdOjKd8C5p6VOyoiQmt8wvuh1bjSeAH7IWAaR1J+mk2lkhaFze6NnPrXwfv+V0n+pTihbhc7UJsxUQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 08:59:17PM +0530, Dev Jain wrote:
> On 16/02/26 4:30 pm, Will Deacon wrote:
> > On Sun, Feb 15, 2026 at 11:39:44AM +0800, Jisheng Zhang wrote:
> >> It turns out the generic disable/enable irq this_cpu_cmpxchg
> >> implementation is faster than LL/SC or lse implementation. Remove
> >> HAVE_CMPXCHG_LOCAL for better performance on arm64.
> >>
> >> Tested on Quad 1.9GHZ CA55 platform:
> >> average mod_node_page_state() cost decreases from 167ns to 103ns
> >> the spawn (30 duration) benchmark in unixbench is improved
> >> from 147494 lps to 150561 lps, improved by 2.1%
> >>
> >> Tested on Quad 2.1GHZ CA73 platform:
> >> average mod_node_page_state() cost decreases from 113ns to 85ns
> >> the spawn (30 duration) benchmark in unixbench is improved
> >> from 209844 lps to 212581 lps, improved by 1.3%
> >>
> >> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> >> ---
> >>  arch/arm64/Kconfig              |  1 -
> >>  arch/arm64/include/asm/percpu.h | 24 ------------------------
> >>  2 files changed, 25 deletions(-)
> > That is _entirely_ dependent on the system, so this isn't the right
> > approach. I also don't think it's something we particularly want to
> > micro-optimise to accomodate systems that suck at atomics.
> 
> Hi Will,
> 
> As I mention in the other email, the suspect is not the atomics, but
> preempt_disable(). On Apple M3, the regression reported in [1] resolves
> by removing preempt_disable/enable in _pcp_protect_return. To prove
> this another way, I disabled CONFIG_ARM64_HAS_LSE_ATOMICS and the
> regression worsened, indicating that at least on Apple M3 the
> atomics are faster.

Then why don't we replace the preempt disabling with local_irq_save()
in the arm64 code and still use the LSE atomics?

IIUC (lots of macro indirection), the generic cmpxchg is not atomic, so
another CPU is allowed to mess this up if it accesses current CPU's
variable via per_cpu_ptr().

-- 
Catalin

