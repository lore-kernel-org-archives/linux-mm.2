Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98CA9CF857C
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:55:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 054126B00A7; Thu, 20 Nov 2025 04:55:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02B866B00AD; Thu, 20 Nov 2025 04:55:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAB3A6B00AE; Thu, 20 Nov 2025 04:55:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D724F6B00A7
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:55:43 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C6F21407D2
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:55:43 +0000 (UTC)
X-FDA: 84130528566.18.EA596B4
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf10.hostedemail.com (Postfix) with ESMTP id D318AC000A
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:55:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf10.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763632541; a=rsa-sha256;
	cv=none;
	b=nHgTMUG29CCoLSiT/4GyCnnKr+ULf7Tjr0aUDgjj/Mz4CXf1CDZiY+WVffF/8dh+kR+RPm
	/guDv4VlKnqBwyUsDWKqWpb82rvgEirMtrqLA0vjkrVLZLALPMwwBJ+McNmcjiANx/veRE
	qX850L7DIU5BzVQiakXQGMBsmvH1vHI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf10.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763632541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ppSNMX2sYVnmPCHIo78O7cdSshr72jFmHEsPFp2TSzQ=;
	b=x9uyHJ+h/rnEpV6HEnnRT316advnMoTzjoPy3rAIgz8x5JtelqgPh0byotokM3cck9zwRN
	NzPFTt6A+NYV8zSnw7uML2mNfD26bnwmyeDkGIupnPPaBuY0YKsPpT9GGIfoCUMpD5LlmW
	XuXvZP3+h1BHT+Q/1qu2uUvmAzE9AWE=
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dBtxf2YMCzHnGhN;
	Thu, 20 Nov 2025 17:55:02 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id D570214037D;
	Thu, 20 Nov 2025 17:55:36 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 20 Nov
 2025 09:55:35 +0000
Date: Thu, 20 Nov 2025 09:55:33 +0000
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
Message-ID: <20251120095533.00004b0e@huawei.com>
In-Reply-To: <20251119-charging-gallon-bea196c3a547@spud>
References: <20251117104800.2041329-1-Jonathan.Cameron@huawei.com>
	<20251117104800.2041329-4-Jonathan.Cameron@huawei.com>
	<3bf1793a-2ffd-4017-b4bf-dc63f3a2a7c8@infradead.org>
	<20251117-definite-uncounted-7cc07a377a71@spud>
	<20251118093041.00000c9e@huawei.com>
	<2241d985-0e35-41e5-93b1-1e8d4e7a84bf@infradead.org>
	<20251119094255.00000020@huawei.com>
	<20251119-charging-gallon-bea196c3a547@spud>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml500012.china.huawei.com (7.191.174.4) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D318AC000A
X-Stat-Signature: 5znsxhbrit6w45wyhfrikjsmk9ox5ui8
X-HE-Tag: 1763632540-396614
X-HE-Meta: U2FsdGVkX19kF6kqFLZv2cKpX9TeUS239x3yk2X3+bawRPg/1z5xxv0wm0TXInh5Y4wNEolGPZufJ/Sx5fsD9YbRevKEmOiLFsf3Y6HynnfEtiKMD4b94nv0vFPEUxstHkNiuhSr6SMd4BCetyySYKtaRg5IglaGrjKra0fe9OAdjzK9d2kAL+Gp0JGGSJh8Tc+o8cYIDqKVT22/DaelEIQAaLHm3Xx5BK2qzFZz88MWk0owZDXTXC3tUF7B0RWD0CMiHAJ+tq7308RuZw/BXH7AfY0/0YWHTuXK+uqwTFXeE+psAVqRcPCyCGRnYsrLE02TDictVprhN+6xZ0VGWo2TP02xpiKCagl3iuX8vbIfvkJ/bDyKtPVOdUNd1VE/rT9s4LZE4enChfOSrgGjo2qyFawqUZBOf4T2cERXBJRjx7PbRqfnPJzmRdPfzoLCyPZcawQc+oT4w8/z0bIzTcBiQDlM4F1Bk5gtvDs3fpmx04itxOeRqs0IUlwY49Qil6qxeLk9NQmWJSgjShFqzp/H/0/BGsg1bzxL7VByoHzwZrs1BpzmGLlr92Ti9x0SAyNgD1am0n23jyVfexxivj6l2ifPNW99AyjUDMM0YE1A4eJ0U4LdGbCsjZt+qg10S0APGgawH8txWVPhc74PiPg1hSlfrAbk4PqnUklK54FdC2jBChkeYkuuxqB3BcnvlaAPMPWwY/yfK8uOE3P4hfWboHpHT3oDOjhQ6bXcZbQeEE0ZzCPuBkeT3MrqLjnDkVj9daxGmGph1PmN/dEpb8FTWzg64STKwfN9tkrJ8IgQ4NK3G1e6BNj9RBRLcWQQm2HgSN0j8Qs+6xhavdEnuVGA0IibDKjiXZlsDYHjfn8zkkp+A+qqc4ctehRgI4Jzcg9HafQA4VtoQlCHBsTHGAR12zm2BLq3qNeu2rJ3zr3liADL1ERen7q4HyDh+nMPjRuhe96+u+Sk/jnKSZS
 gsPsarsZ
 UNUky2iCzxdbECDO22vnQE5sZrZ/9X9lkiM8zMYDBf1LonAwhgnKx0GldTqlZvSjSUIKVcQgpCDZgUF5jWsIX35OfBj515lR+YUmo0ZxAATchAZ1hevRcpr+qClGbAiIhXHIzuFPup/rYSaucMorVfLvr+ij5Kw6vI5THNDpWeoQLvz1j3mdXpJnpBkhLUkkDpGNKWRDVz+qQX+K3H+Y/H1zIfN+O+FHNu5XqOoVro74EeSYmwk53OqwatAdyg4UVSA1a8SXneD57rzKIAYF6/2hPSey9GImW+q79iZ7VMBOg+JVsVj55qh8HTtQ+blBqOnEHKJmkgdzBn5/BQ7GWXkdMnFBltGFMfB0xtMtCm5shgn/gC+mMUu5fgw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 19 Nov 2025 18:44:43 +0000
Conor Dooley <conor@kernel.org> wrote:

> On Wed, Nov 19, 2025 at 09:42:55AM +0000, Jonathan Cameron wrote:
> > On Tue, 18 Nov 2025 17:18:31 -0800
> > Randy Dunlap <rdunlap@infradead.org> wrote:
> >   
> > > On 11/18/25 1:30 AM, Jonathan Cameron wrote:  
> > > > On Tue, 18 Nov 2025 00:13:07 +0000
> > > > Conor Dooley <conor@kernel.org> wrote:
> > > >     
> > > >> On Mon, Nov 17, 2025 at 10:51:11AM -0800, Randy Dunlap wrote:    
> > > >>> Hi,
> > > >>>
> > > >>> On 11/17/25 2:47 AM, Jonathan Cameron wrote:      
> > > >>>> diff --git a/lib/Kconfig b/lib/Kconfig
> > > >>>> index e629449dd2a3..e11136d188ae 100644
> > > >>>> --- a/lib/Kconfig
> > > >>>> +++ b/lib/Kconfig
> > > >>>> @@ -542,6 +542,10 @@ config MEMREGION
> > > >>>>  config ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
> > > >>>>  	bool
> > > >>>>  
> > > >>>> +config GENERIC_CPU_CACHE_MAINTENANCE
> > > >>>> +	bool
> > > >>>> +	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
> > > >>>> +
> > > >>>>  config ARCH_HAS_MEMREMAP_COMPAT_ALIGN
> > > >>>>  	bool      
> > > >>>
> > > >>> Architectures and/or platforms select ARCH_HAS_*.
> > > >>>
> > > >>> With this change above, it becomes the only entry in
> > > >>> lib/Kconfig that does "select ARCH_HAS_anytning".
> > > >>>
> > > >>> so I think this is wrong, back*wards.      
> > > >>
> > > >> Maybe it is backwards, but I feel like this way is more logical. ARM64
> > > >> has memregion invalidation only because this generic approach is
> > > >> enabled, so the arch selects what it needs to get the support.    
> > > > 
> > > > Exactly this. Catalin requested this form in response to an earlier
> > > > version where arm64 Kconfig just had both selects for pretty much that
> > > > reason. This is expected to be used on a subset of architectures.
> > > > It is similar to things like GENERIC_ARCH_NUMA in this respect (though the
> > > > arch_numa_init() etc in there are called only from other arch code
> > > > so no ARCH_HAS_ symbols are associated with them).
> > > >     
> > > >> Alternatively, something like    
> > > > 
> > > > I'm fine with this solution if Randy prefers it.    
> > > 
> > > I do much prefer this alternative.
> > >   
> > > > Thanks for your help with this.    
> > > 
> > > Thanks for listening.  
> > 
> > Conor,
> > 
> > Given it is your proposed solution, I'm guessing you'll either spin a patch
> > on top or squash it into original.  If you spin a patch for this.
> > 
> > Acked-by: Jonathan Cameron <jonathan.cameron@huawei.com>  
> 
> New patch I think, since you say Catalin specifically asked for the
> current setup.

Whilst Catalin proposed the form used, the basis was about having two
entrees for effectively the same thing in arm64/Kconfig and this
still has the single entry property so should be fine.

Jonathan

> 
> > 
> > Thanks again!
> > 
> > Jonathan
> >   
> > > 
> > >   
> > > >> | diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > > >> | index 5f7f63d24931..75b2507f7eb2 100644
> > > >> | --- a/arch/arm64/Kconfig
> > > >> | +++ b/arch/arm64/Kconfig
> > > >> | @@ -21,6 +21,7 @@ config ARM64
> > > >> |  	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
> > > >> |  	select ARCH_HAS_CACHE_LINE_SIZE
> > > >> |  	select ARCH_HAS_CC_PLATFORM
> > > >> | +	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
> > > >> |  	select ARCH_HAS_CURRENT_STACK_POINTER
> > > >> |  	select ARCH_HAS_DEBUG_VIRTUAL
> > > >> |  	select ARCH_HAS_DEBUG_VM_PGTABLE
> > > >> | @@ -146,7 +147,6 @@ config ARM64
> > > >> |  	select GENERIC_ARCH_TOPOLOGY
> > > >> |  	select GENERIC_CLOCKEVENTS_BROADCAST
> > > >> |  	select GENERIC_CPU_AUTOPROBE
> > > >> | -	select GENERIC_CPU_CACHE_MAINTENANCE
> > > >> |  	select GENERIC_CPU_DEVICES
> > > >> |  	select GENERIC_CPU_VULNERABILITIES
> > > >> |  	select GENERIC_EARLY_IOREMAP
> > > >> | diff --git a/lib/Kconfig b/lib/Kconfig
> > > >> | index 09aec4a1e13f..ac223e627bc5 100644
> > > >> | --- a/lib/Kconfig
> > > >> | +++ b/lib/Kconfig
> > > >> | @@ -544,8 +544,9 @@ config ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
> > > >> |  	bool
> > > >> |  
> > > >> |  config GENERIC_CPU_CACHE_MAINTENANCE
> > > >> | -	bool
> > > >> | -	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
> > > >> | +	def_bool y
> > > >> | +	depends on ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
> > > >> | +	depends on ARM64
> > > >> |  
> > > >> |  config ARCH_HAS_MEMREMAP_COMPAT_ALIGN
> > > >> |  	bool
> > > >> implies (to me at least) that arm64 has memregion invalidation as an
> > > >> architectural feature and that the GENERIC_CPU_CACHE_MAINTENANCE option
> > > >> is a just common cross-arch code, like generic entry etc, rather than
> > > >> being the option gating the drivers that provide the feature in the
> > > >> first place.
> > > >>
> > > >> I didn't really care which way it went, and was gonna post something to
> > > >> squash and avoid another revision, but I found the resultant Kconfig
> > > >> setup to be make less sense to me than what came before. If the switched
> > > >> around version is less likely to be problematic etc, then sure, but I
> > > >> amn't convinced by switching it at a first glance.    
> > > 
> > >   
> >   
> 


