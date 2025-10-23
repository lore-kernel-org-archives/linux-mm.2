Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40E0ECCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 16:40:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BDD38E0008; Thu, 23 Oct 2025 12:40:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 995BB8E0005; Thu, 23 Oct 2025 12:40:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AB748E0008; Thu, 23 Oct 2025 12:40:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 791DB8E0005
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:40:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 12D6D13C194
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:40:38 +0000 (UTC)
X-FDA: 84029942556.14.0E1C9FC
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf07.hostedemail.com (Postfix) with ESMTP id 71A0040010
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:40:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761237636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dS/kHyn2rSYrZDIWLh4sztc1+FksVkunul6FLLyz6VY=;
	b=GmseYoWUDCVerab1hOV+sF+hwDYKCcZAFxVTcMevPlaWUFAHPHsuX94LFm47uyCORl9rrD
	MHfT1YSezVPnQBKkdvz4Y+1qpIf9q5ixnyLjEeb7BSMlVpUNhP74LJcQe2QIoCOfVFV6cY
	CxeqItVRc+n09mIQgqbORzkUhmVM5Cc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761237636; a=rsa-sha256;
	cv=none;
	b=hnBK0izckNMIUwn4YCG7yC9tZlgxm6SMV9sUfJNEiyVHohg/RkiaBOUPgEtKPLePSjoHmA
	TbJqDOAMhm2DYZq36hcjRr1fk3n0hjL/EHbmtmc+CWoAJfyYnhtPk2zDjCBV4fyMn0SkVC
	p0v1/GyHjhkBXAOEcOR9HOy1fpYjiX8=
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cssDh5Wmgz6L57c;
	Fri, 24 Oct 2025 00:39:00 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id D77761400CB;
	Fri, 24 Oct 2025 00:40:28 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 23 Oct
 2025 17:40:27 +0100
Date: Thu, 23 Oct 2025 17:40:26 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Conor Dooley <conor@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas
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
	<luto@kernel.org>, Dave Jiang <dave.jiang@intel.com>, Arnd Bergmann
	<arnd@arndb.de>, Krzysztof Kozlowski <krzk@kernel.org>, Alexandre Belloni
	<alexandre.belloni@bootlin.com>, Linus Walleij <linus.walleij@linaro.org>,
	Drew Fustini <fustini@kernel.org>
Subject: Re: [PATCH v4 0/6] Cache coherency management subsystem
Message-ID: <20251023174026.00005b42@huawei.com>
In-Reply-To: <20251022-harsh-juggling-2d4778b0649e@spud>
References: <20251022113349.1711388-1-Jonathan.Cameron@huawei.com>
	<20251022122241.d2aa0d7864f67112aa7691bf@linux-foundation.org>
	<20251022-harsh-juggling-2d4778b0649e@spud>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 71A0040010
X-Stat-Signature: dkd5jjtfxioarr5rcioxtdjkbyeeahc7
X-Rspam-User: 
X-HE-Tag: 1761237635-22575
X-HE-Meta: U2FsdGVkX1/hc6xI8ajBKUqNpEMNq53neyxpY/Q3t1kBPXobyVTYXLntmTg2oQExWOkgyjpx1I6QKF6lV8pJqnFKhmUAfpdwiCKzEUiR6z19yEmzlgfD1wm9YggKQAXGb1CkiG3K+fuEvevx8Wcv8yhxRso8ZU8hK1sQlUMke6Tirae75/AXq/XyOvAvCEBZTRSp8xHkZvX1N7vzfhT1W1TuDR+JHCMEhkMhaC5EG+IvE/2MS0ccT83Syw59mY17/NhyX4fk0xI8ojgfxFPv7lwEFGAEMlputOVfNC58ASzZHoTjpOLpu8UrEfud9Uy2OUXcV/qsw+dJUHkHyfI8NkfMRRF616pUV5fDwBWiQv2+xijd+eDXCTeRpilUlIXdRUln0YHaNfS8UoD3XrUxo52STTDUBNaGzknj5hsy6662wt/O8C66sGm8Sz/oTxouzngwFjS4DSt3N2edMlqD6CEP4TdtfWAnO1SzGoLRWgY3TNsrdGoFmImm7GzN1aUYPK5ZeyDsxPqtlljG60bko7ETfVxuheobCxcL0lKU9Wd1pHTztvV4n24KHFch69D+AZHj18R8z44bMDeiTYqCvLNBm+k2c5sKhQ4e5RAtjhzHlQRhwFRLyix1HcoGR0cxSvI+Vi6cDtdNLBw8frGNZbK29GTw/HEI6ssH5ar3HEbb+zW+9KgyvbC85sKHhjbgPmj1cZbrIi41ayDIZxkDmRluP6wV7DnwhxHIc1cMClTnnDMlrqOxG4O1jEoJxYSvhXmxkMyqz28o2E4nTdlattj3jZG97JOB/t+wLp2hXm/c3/wgnIa2dL99sTtrMqOg7qokrqaYunsUJvxj0SGk6J+uKnDl914YKrovJRSdJH1zBYdcKn3hHJhVnJzCFIOiFPfjRfModx3da4Pb0p6pTtoN6+CcGWd6iXeh710oJs0WdJmAAmmKWAgCUax2FsL85vmflAAIw2U4f95JZ5S
 XrmMn0Nt
 iG8OeqhOJGWAY9rKaVutRBj7FRE/99S4jjo0cMQgnFmDOif0vYRQkXUavwaFa/KNDNW/1MTEegaMYfz1qf9SLczpe2E8tLDi3W1SHahHX2zqA6BuCDgGSGL4ihGSmxWYYWFVlmmFc0MqwcDhw+XzAxM1R/wBKoosyqTe1LgcDAMo/orKqH+/zk2qKRfijBZizDUOEIQk0aD1OPrTKNxGk0vmipKxtsK9P83aeLf1cP9L7EfSQF88IgG+0XqP5y2h00LxWylEUCcceCOk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Oct 2025 21:47:21 +0100
Conor Dooley <conor@kernel.org> wrote:

> On Wed, Oct 22, 2025 at 12:22:41PM -0700, Andrew Morton wrote:
> > On Wed, 22 Oct 2025 12:33:43 +0100 Jonathan Cameron <Jonathan.Cameron@huawei.com> wrote:
> >   
> > > Support system level interfaces for cache maintenance as found on some
> > > ARM64 systems. This is needed for correct functionality during various
> > > forms of memory hotplug (e.g. CXL). Typical hardware has MMIO interface
> > > found via ACPI DSDT.
> > > 
> > > Includes parameter changes to cpu_cache_invalidate_memregion() but no
> > > functional changes for architectures that already support this call.  
> > 
> > I see additions to lib/ so presumably there is an expectation that
> > other architectures might use this.
> > 
> > Please expand on this.  Any particular architectures in mind?  Any
> > words of wisdom which maintainers of those architectures might benefit
> > from?  
> 
> It seems fairly probable that we're gonna end up with riscv systems
> where drivers are being used for both this and the existing non-standard
> cache ops stuff.
> 
> > > How to merge?  When this is ready to proceed (so subject to review
> > > feedback on this version), I'm not sure what the best route into the
> > > kernel is. Conor could take the lot via his tree for drivers/cache but
> > > the generic changes perhaps suggest it might be better if Andrew
> > > handles this?  Any merge conflicts in drivers/cache will be trivial
> > > build file stuff. Or maybe even take it throug one of the affected
> > > trees such as CXL.  
> > 
> > Let's not split the series up.  Either CXL or COnor's tree is fine my
> > me.  
> 
> CXL is fine by me, greater volume there probably by orders of magnitude.
> 

On CXL discord, some reasonable doubts were expressed about justifying
this to Linus via CXL. Which is fair given tiny overlap from a 'where
the code is' point of view and also it seems I went too far in trying to
avoid people interpreting this as affecting x86 systems (see earlier
versions for how my badly scoped cover letter distracted from what this
was doing) and focus in on what was specifically being enabled rather
than the generic bit. Hence it mentions arm64 only right now and right
at the top of the cover letter.

Given it's not Arm architecture (hence just one Kconfig line in Arm
specific code) I guess alternative is back to drivers/cache and Conor which
I see goes via SoC (so +CC SoC tree maintainers).

Given there will be a v5 I'll rewrite the cover letter to make it less
specific whilst still calling out that for now the only driver happens to
be in an Arm SoC. Will leave some time for additional review first though!

Thanks,

Jonathan





