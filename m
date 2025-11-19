Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2706CF3185
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 09:43:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56BB06B0089; Wed, 19 Nov 2025 04:43:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51BCE6B00B1; Wed, 19 Nov 2025 04:43:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40ADF6B00B3; Wed, 19 Nov 2025 04:43:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B7D96B0089
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 04:43:05 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D144B13AB8D
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 09:43:04 +0000 (UTC)
X-FDA: 84126867888.30.249AC58
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf28.hostedemail.com (Postfix) with ESMTP id 22325C0003
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 09:43:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763545383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7HLkDgVFmcwFx8VVSugASBzZgIG5ksxMhvE7FbZxq2I=;
	b=p0x/g4sSQXchfj5pgmDj0zPirssvu3KJQ3qlcZSqlASYS031Q0DkIJo0RO+D8Q+v6Ih7js
	S+oarNNpu1DNCfHj920q/cDTlFV0cfhURGLUZLaE1G99PWp2td6bK/3K4k13BGdZjCz8eX
	3T7rnPQM8kLDX4XXmx7iD2+nUTZRn6A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763545383; a=rsa-sha256;
	cv=none;
	b=YAmLt2I8BC9SXFOQlOCibsSxpbr6ylOYTxMlUu6MPXfLgpswXBo12vNSWRJD1T6zUk/Xhy
	EIEu2itYlKd5cq+luQAp7uTLziYSU5kIvEu/3a2k9NvIXIwgo95mcBWw4S63Cr3NkCCVZj
	wFIHmIG6vf1gFoFoYO3W/mmD1iodteQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dBGjL4B8yzJ46jN;
	Wed, 19 Nov 2025 17:42:14 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 3D0E91401DC;
	Wed, 19 Nov 2025 17:42:58 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 19 Nov
 2025 09:42:56 +0000
Date: Wed, 19 Nov 2025 09:42:55 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Randy Dunlap <rdunlap@infradead.org>
CC: Conor Dooley <conor@kernel.org>, Catalin Marinas
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
Message-ID: <20251119094255.00000020@huawei.com>
In-Reply-To: <2241d985-0e35-41e5-93b1-1e8d4e7a84bf@infradead.org>
References: <20251117104800.2041329-1-Jonathan.Cameron@huawei.com>
	<20251117104800.2041329-4-Jonathan.Cameron@huawei.com>
	<3bf1793a-2ffd-4017-b4bf-dc63f3a2a7c8@infradead.org>
	<20251117-definite-uncounted-7cc07a377a71@spud>
	<20251118093041.00000c9e@huawei.com>
	<2241d985-0e35-41e5-93b1-1e8d4e7a84bf@infradead.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Stat-Signature: fofxm1c65c7647wizymxr6ubabpczdqb
X-Rspam-User: 
X-Rspamd-Queue-Id: 22325C0003
X-Rspamd-Server: rspam01
X-HE-Tag: 1763545381-753262
X-HE-Meta: U2FsdGVkX1+SAe+M66eXsdNtoUAKBCOfxf4nCsdCP4EcvU6Fal04MrPhMsMcJRN14N47+s1YFCVgVa4Ks6By/pS2gUlLq5m7KjvM7WOQwlyLqOxVJ3cDNGIXQBNGWAgkb9i3Cdculcqux4WRGLVJT6eODWqKaF/k7+HDOgRyX/jvCYqacgj2HtjsC0Zu4AuLfQNHvvEBhzO58VOASywfOfjmw79tmGfk63Ry+n8oIM8VnAvjo5u7k+lS/5/QJ4fHGrITQzsTzcxf5pLi7MO2RfOXnek//29sDgx530AyUX/IwTgZGSSFN+5Nf0NaYNsOdxVonx9876OO4E1i6Norton2ExYKx0YX+LwsMxj71dMOVlevbgeurrMVrDtWfGtgSSX1ndHSi+p0LMRdNf9+sS+xBL1s0CXjiB2ZpYM+qnmEeom0cr57MnznqokQ89xqxMRQsvcTNkMsjJCex9SFS/E8bI8twmp9Jiamje1EV0vhoSZ9mAy5lfevM1zWukzE9FJFy9NGpzTd3iUdDn78XXgEUxbMhe++cSoN/WWJ0YTg8cG8W0ajPXPPPX0osnjjhjvupRtywl7vq0zM4Uwx14rVXM9t2EEFEoDJWlyOW54751DmkTWY9RX9OZCjD7Kglm0L/o6PC2+3IqnazL2w2rILAxD2HGf+4Zr1LZRps0Zpb+FZR1l61XQI2LqGkFJycLHVVsQsmpzUq8ZwjQTo/YGXiQAJ4MhIcakBLoVMvWem7RqxWd9+HNGhZzlhALCX6bfyA3QWHmp1+XDSZWQ1Iqw7EU+pMxmwzwQSvhXsoveV+q6mzokKIu2GMbcOX6Qt8o109zRdLJG5il993KyGoyNQWqD+ZjrxOoDR4x0fBzGeZZvUwIw5YFbeyXAMrqCjUITQuJSNI69xxrd21laKSu43op3svif/j2gCqavcfj3hYNGJRD/ugeRhIIDHHt9prvQBwrsaM0kSbUjwrBP
 XgAF7NXu
 b0313CzMBU0HDmC2Jug40F5jvB68mGYduoMnW9WdFv3l0oZmfr5b9OENK88+1+8VCL+HlZpH9ayLEesZMmh/y+XO5UN+ofZBOG4bdO9Ec6hIe6Qo8N7t0PZPdVzuTLVjF01KckwY7NYyPXdZhsCpG0esSXC96jtJrPzPBcfdvt9OFS83tUUej26DqY8bAn+sGUuJxMAhzJM/X1Vz8l2malRqAlDeCmbZSG3RMJIljTJvCHpmd2PDrG8qrJ6TxF6who/uLQtHcje4KcdGv6KMU0B2s9mR1Ggz+cY7hHd+VW9ZvV92FMiOOB447tK3YbEKiVT4qFjmLGylQATJB2QM+LI9K4IDhkhanUgGYYosmKb5ftTY+0k754NGr7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Nov 2025 17:18:31 -0800
Randy Dunlap <rdunlap@infradead.org> wrote:

> On 11/18/25 1:30 AM, Jonathan Cameron wrote:
> > On Tue, 18 Nov 2025 00:13:07 +0000
> > Conor Dooley <conor@kernel.org> wrote:
> >   
> >> On Mon, Nov 17, 2025 at 10:51:11AM -0800, Randy Dunlap wrote:  
> >>> Hi,
> >>>
> >>> On 11/17/25 2:47 AM, Jonathan Cameron wrote:    
> >>>> diff --git a/lib/Kconfig b/lib/Kconfig
> >>>> index e629449dd2a3..e11136d188ae 100644
> >>>> --- a/lib/Kconfig
> >>>> +++ b/lib/Kconfig
> >>>> @@ -542,6 +542,10 @@ config MEMREGION
> >>>>  config ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
> >>>>  	bool
> >>>>  
> >>>> +config GENERIC_CPU_CACHE_MAINTENANCE
> >>>> +	bool
> >>>> +	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
> >>>> +
> >>>>  config ARCH_HAS_MEMREMAP_COMPAT_ALIGN
> >>>>  	bool    
> >>>
> >>> Architectures and/or platforms select ARCH_HAS_*.
> >>>
> >>> With this change above, it becomes the only entry in
> >>> lib/Kconfig that does "select ARCH_HAS_anytning".
> >>>
> >>> so I think this is wrong, back*wards.    
> >>
> >> Maybe it is backwards, but I feel like this way is more logical. ARM64
> >> has memregion invalidation only because this generic approach is
> >> enabled, so the arch selects what it needs to get the support.  
> > 
> > Exactly this. Catalin requested this form in response to an earlier
> > version where arm64 Kconfig just had both selects for pretty much that
> > reason. This is expected to be used on a subset of architectures.
> > It is similar to things like GENERIC_ARCH_NUMA in this respect (though the
> > arch_numa_init() etc in there are called only from other arch code
> > so no ARCH_HAS_ symbols are associated with them).
> >   
> >> Alternatively, something like  
> > 
> > I'm fine with this solution if Randy prefers it.  
> 
> I do much prefer this alternative.
> 
> > Thanks for your help with this.  
> 
> Thanks for listening.

Conor,

Given it is your proposed solution, I'm guessing you'll either spin a patch
on top or squash it into original.  If you spin a patch for this.

Acked-by: Jonathan Cameron <jonathan.cameron@huawei.com>

Thanks again!

Jonathan

> 
> 
> >> | diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> >> | index 5f7f63d24931..75b2507f7eb2 100644
> >> | --- a/arch/arm64/Kconfig
> >> | +++ b/arch/arm64/Kconfig
> >> | @@ -21,6 +21,7 @@ config ARM64
> >> |  	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
> >> |  	select ARCH_HAS_CACHE_LINE_SIZE
> >> |  	select ARCH_HAS_CC_PLATFORM
> >> | +	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
> >> |  	select ARCH_HAS_CURRENT_STACK_POINTER
> >> |  	select ARCH_HAS_DEBUG_VIRTUAL
> >> |  	select ARCH_HAS_DEBUG_VM_PGTABLE
> >> | @@ -146,7 +147,6 @@ config ARM64
> >> |  	select GENERIC_ARCH_TOPOLOGY
> >> |  	select GENERIC_CLOCKEVENTS_BROADCAST
> >> |  	select GENERIC_CPU_AUTOPROBE
> >> | -	select GENERIC_CPU_CACHE_MAINTENANCE
> >> |  	select GENERIC_CPU_DEVICES
> >> |  	select GENERIC_CPU_VULNERABILITIES
> >> |  	select GENERIC_EARLY_IOREMAP
> >> | diff --git a/lib/Kconfig b/lib/Kconfig
> >> | index 09aec4a1e13f..ac223e627bc5 100644
> >> | --- a/lib/Kconfig
> >> | +++ b/lib/Kconfig
> >> | @@ -544,8 +544,9 @@ config ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
> >> |  	bool
> >> |  
> >> |  config GENERIC_CPU_CACHE_MAINTENANCE
> >> | -	bool
> >> | -	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
> >> | +	def_bool y
> >> | +	depends on ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
> >> | +	depends on ARM64
> >> |  
> >> |  config ARCH_HAS_MEMREMAP_COMPAT_ALIGN
> >> |  	bool
> >> implies (to me at least) that arm64 has memregion invalidation as an
> >> architectural feature and that the GENERIC_CPU_CACHE_MAINTENANCE option
> >> is a just common cross-arch code, like generic entry etc, rather than
> >> being the option gating the drivers that provide the feature in the
> >> first place.
> >>
> >> I didn't really care which way it went, and was gonna post something to
> >> squash and avoid another revision, but I found the resultant Kconfig
> >> setup to be make less sense to me than what came before. If the switched
> >> around version is less likely to be problematic etc, then sure, but I
> >> amn't convinced by switching it at a first glance.  
> 
> 


