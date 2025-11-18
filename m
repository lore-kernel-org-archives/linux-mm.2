Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DB44CED24B
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 09:30:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D90D26B002A; Tue, 18 Nov 2025 04:30:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D40A56B002B; Tue, 18 Nov 2025 04:30:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2F986B002C; Tue, 18 Nov 2025 04:30:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD19C6B002A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 04:30:50 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 49A5A13AFF1
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:30:50 +0000 (UTC)
X-FDA: 84123208260.03.3A495C5
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf17.hostedemail.com (Postfix) with ESMTP id 420F740008
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:30:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf17.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763458248; a=rsa-sha256;
	cv=none;
	b=4Ej6TaKPI8PEcMjxeeT44HcTld9Noz9FuKgpc7EPwOzHDwPk9yBpHuQ1CQHDYeOv8fYyXh
	XFKbQG62vq7/6JrzBFJ7LcCAnnRuknNP8zzs9X3I5VEBVh3TUUL89E4UcdC8jqEFNU5s3C
	PHUXTOActqHOtP46I08Cgku5znZ7NBc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf17.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763458248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zgBjRtUaeM1idizUdgBkeMC+v2iP9RJTGkwmFa1FYv0=;
	b=nr9hlsRxPs4+KQed4CqciFZR56RLFzluwtmvKHgxEr1es9lBx27udTpbStwTCkVEY+yoHx
	yFm+BnmAeo+by3sQgYSFwfKRwLd//ArMb4GkroqPoozl/yOPxutNiCFQJ8zpqpDhfB/l4E
	XcSe7pUkV4MFhMAjkdZuIbaKiK++ToA=
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4d9fTk1j18zJ46cb;
	Tue, 18 Nov 2025 17:30:02 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 3F92E140277;
	Tue, 18 Nov 2025 17:30:44 +0800 (CST)
Received: from localhost (10.48.158.191) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 18 Nov
 2025 09:30:42 +0000
Date: Tue, 18 Nov 2025 09:30:41 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Conor Dooley <conor@kernel.org>
CC: Randy Dunlap <rdunlap@infradead.org>, Catalin Marinas
	<catalin.marinas@arm.com>, <linux-cxl@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-arch@vger.kernel.org>,
	<linux-mm@kvack.org>, Dan Williams <dan.j.williams@intel.com>, "H . Peter
 Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, "Drew
 Fustini" <fustini@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Krzysztof Kozlowski
	<krzk@kernel.org>, <james.morse@arm.com>, Will Deacon <will@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>, <linuxarm@huawei.com>, Yushan Wang
	<wangyushan12@huawei.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>, "Mark
 Rutland" <mark.rutland@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Andy Lutomirski
	<luto@kernel.org>, Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH v6 3/7] lib: Support
 ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
Message-ID: <20251118093041.00000c9e@huawei.com>
In-Reply-To: <20251117-definite-uncounted-7cc07a377a71@spud>
References: <20251117104800.2041329-1-Jonathan.Cameron@huawei.com>
	<20251117104800.2041329-4-Jonathan.Cameron@huawei.com>
	<3bf1793a-2ffd-4017-b4bf-dc63f3a2a7c8@infradead.org>
	<20251117-definite-uncounted-7cc07a377a71@spud>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.48.158.191]
X-ClientProxiedBy: lhrpeml100009.china.huawei.com (7.191.174.83) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 420F740008
X-Stat-Signature: xxex7ecffxwntk68kjrtsooxbpmhiidj
X-Rspam-User: 
X-HE-Tag: 1763458247-874956
X-HE-Meta: U2FsdGVkX1+CByMPRb+yOAHmK8FxmwOooOe/Wtofy7Z8kTZGabT+hM5zBu1WoSBPRGlsYDwluv+beutlYX+ssHc2Pj90C5eNoVztOTuhgiCL9zC8fb64+FRDFnIRhg9xiVeUlr70K8cRPSSVbPiboKRL6hu5xCNp4/D8l4FEFSIPOxjqJidHeu+mkdP/2oTwA661AS5hI8ZHj628DNb566frWfsem9jaChGNS55hABMqn/WtXv+6W0V/kcn4HEIa2zpjkodcRW+2OFNUGMSipAXLaW5LLIET/I0O/yU/p4l9ZWULrZ7FdylN3gysdOQzWc9OMN/mMtRfBNyYOEhMjxQfXFPEJRLWHWLvkkq1ydrS4NKFFvYcYmi3ydNpgAIh539iUyCu3HBKcUZlP3BJBhf4Kvegaxms5Dt4GgZLVPPJmmbBkmc8tRBe1a7A+SQo0JtDrT9LnQnlBJSkIZXrBXZvcv7HP7k8Gotwj6YdyZkPd1NlLf9AnkbdtWoUS4uzBME3BwxG/J/7pnGpHdAV6WNI8nce68pho4lfG26nQG6FTypXUeT5Sd0xIz7fb8quf5AK2mdNHIcdiGzHLMnLNhKDJejOIgHUCWaxX+sBn+es/dVpXclzNeSyRALHD8WCIrm8H+wxuY+m/9bi1OafM/65gunC8IHIy3O8VLctYa1iGyLIz6MLnDZwrTl0c7pKMenFJ4TepYEGhXDkFdrT9tZ5zrsD0hOvJ+okBd5s/9E2k6ustJBWoYEgIjsg7kvPflNbFeSBzxjC4eyANanX6ePClAl3LFuuVsz6fifDyVX9Q7AVMnaWQwjSVdjlGvHPGriuZe2J1VXZMnzBKFsG8R+bog4T2NLtJ9j/yq17EWiUr1WMdEKX49pUGWSlWd6gkIPKaIfr4CJFqDfYdyEdacOOjnSxx8D9Dz6AB3LtJ7dXztBUZnEbYxlcgZwcB7dc2smc/DStf6UZSkYa7YK
 m1HcyAno
 O0n868bCCcQAW5dLn8Dv/U/4ncYW3HWFI4k9xhw+PJOVad8gqHOIRkZBiHtmr2IpQv67k4WAg3KFm1HLD8Y/M/B+NamyvOq8Bv1i9ZPFVVxy/cadfWoVUV8sLTna2ObCdGkbecoTYA72TK2nc7JDc2f//AFCllI63rTvoDGRYurZ2XPv3ck3TFuwM0GfP3tmLlkWbTpMrb8q2ZCipmMXY8apDJE/JPkhWzz1h8MzdzI3oPQawJ+Ow7dMVQCggDBOarC6BbBhciGq0z83SDck1Aa4IReEHWoXf4KFrIEDjepKqxFI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Nov 2025 00:13:07 +0000
Conor Dooley <conor@kernel.org> wrote:

> On Mon, Nov 17, 2025 at 10:51:11AM -0800, Randy Dunlap wrote:
> > Hi,
> > 
> > On 11/17/25 2:47 AM, Jonathan Cameron wrote:  
> > > diff --git a/lib/Kconfig b/lib/Kconfig
> > > index e629449dd2a3..e11136d188ae 100644
> > > --- a/lib/Kconfig
> > > +++ b/lib/Kconfig
> > > @@ -542,6 +542,10 @@ config MEMREGION
> > >  config ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
> > >  	bool
> > >  
> > > +config GENERIC_CPU_CACHE_MAINTENANCE
> > > +	bool
> > > +	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
> > > +
> > >  config ARCH_HAS_MEMREMAP_COMPAT_ALIGN
> > >  	bool  
> > 
> > Architectures and/or platforms select ARCH_HAS_*.
> > 
> > With this change above, it becomes the only entry in
> > lib/Kconfig that does "select ARCH_HAS_anytning".
> > 
> > so I think this is wrong, back*wards.  
> 
> Maybe it is backwards, but I feel like this way is more logical. ARM64
> has memregion invalidation only because this generic approach is
> enabled, so the arch selects what it needs to get the support.

Exactly this. Catalin requested this form in response to an earlier
version where arm64 Kconfig just had both selects for pretty much that
reason. This is expected to be used on a subset of architectures.
It is similar to things like GENERIC_ARCH_NUMA in this respect (though the
arch_numa_init() etc in there are called only from other arch code
so no ARCH_HAS_ symbols are associated with them).

> Alternatively, something like

I'm fine with this solution if Randy prefers it.

Thanks for your help with this.

Jonathan

> | diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> | index 5f7f63d24931..75b2507f7eb2 100644
> | --- a/arch/arm64/Kconfig
> | +++ b/arch/arm64/Kconfig
> | @@ -21,6 +21,7 @@ config ARM64
> |  	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
> |  	select ARCH_HAS_CACHE_LINE_SIZE
> |  	select ARCH_HAS_CC_PLATFORM
> | +	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
> |  	select ARCH_HAS_CURRENT_STACK_POINTER
> |  	select ARCH_HAS_DEBUG_VIRTUAL
> |  	select ARCH_HAS_DEBUG_VM_PGTABLE
> | @@ -146,7 +147,6 @@ config ARM64
> |  	select GENERIC_ARCH_TOPOLOGY
> |  	select GENERIC_CLOCKEVENTS_BROADCAST
> |  	select GENERIC_CPU_AUTOPROBE
> | -	select GENERIC_CPU_CACHE_MAINTENANCE
> |  	select GENERIC_CPU_DEVICES
> |  	select GENERIC_CPU_VULNERABILITIES
> |  	select GENERIC_EARLY_IOREMAP
> | diff --git a/lib/Kconfig b/lib/Kconfig
> | index 09aec4a1e13f..ac223e627bc5 100644
> | --- a/lib/Kconfig
> | +++ b/lib/Kconfig
> | @@ -544,8 +544,9 @@ config ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
> |  	bool
> |  
> |  config GENERIC_CPU_CACHE_MAINTENANCE
> | -	bool
> | -	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
> | +	def_bool y
> | +	depends on ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
> | +	depends on ARM64
> |  
> |  config ARCH_HAS_MEMREMAP_COMPAT_ALIGN
> |  	bool
> implies (to me at least) that arm64 has memregion invalidation as an
> architectural feature and that the GENERIC_CPU_CACHE_MAINTENANCE option
> is a just common cross-arch code, like generic entry etc, rather than
> being the option gating the drivers that provide the feature in the
> first place.
> 
> I didn't really care which way it went, and was gonna post something to
> squash and avoid another revision, but I found the resultant Kconfig
> setup to be make less sense to me than what came before. If the switched
> around version is less likely to be problematic etc, then sure, but I
> amn't convinced by switching it at a first glance.
> 



