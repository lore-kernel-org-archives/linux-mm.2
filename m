Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C95A7CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 11:13:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DE698E0002; Thu, 23 Oct 2025 07:13:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B4C08E0013; Thu, 23 Oct 2025 07:13:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A52D8E0002; Thu, 23 Oct 2025 07:13:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E82CD8E0012
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:13:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9D20E1A0AFB
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:13:50 +0000 (UTC)
X-FDA: 84029119020.22.BB64ACC
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4A63D4000F
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:13:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761218028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4BOW5hxTfLOmIVdIDox+jTV1yxmuQmFgSZvwUrdXBZ0=;
	b=7+uhSq/bAWhU1yjVAy/xoPU6g1QRpvCXsPHSUBXHOsr3V68984j6IAweRTLZp/0qU1ceGf
	1AbtCXSsza1esA6eUUdcu5k5Li6gsJBHj8xLB2FZMWxja3R7AkeFwArKWPR6fF2v0yTNOU
	s6OAARNCbVeqRi+LF08sMZTLDfHPM6w=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761218028; a=rsa-sha256;
	cv=none;
	b=kVgvxnP4C9iCOE6NZ0Ikw895+zbx2eL+502WjJebP7et5ruhzRaiIGzN+X30ONlceORlDO
	gQ1gmTWK7O2y1JlJ48r7Ry/Ue9+XmJgsdFYGGLX1V37AJDKiGM2O7k7Jrab7FUSlRZSG+q
	hMShcZ0BHcBn7i9yC049wNmGXP0GRc0=
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4csjx65rM2z6M4gf;
	Thu, 23 Oct 2025 19:10:02 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 42B8B140279;
	Thu, 23 Oct 2025 19:13:44 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 23 Oct
 2025 12:13:43 +0100
Date: Thu, 23 Oct 2025 12:13:41 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Conor Dooley <conor@kernel.org>
CC: Catalin Marinas <catalin.marinas@arm.com>, <linux-cxl@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-arch@vger.kernel.org>,
	<linux-mm@kvack.org>, Dan Williams <dan.j.williams@intel.com>, "H . Peter
 Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, <james.morse@arm.com>, Will Deacon
	<will@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
	<linuxarm@huawei.com>, Yushan Wang <wangyushan12@huawei.com>, "Lorenzo
 Pieralisi" <lpieralisi@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Dave
 Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	<x86@kernel.org>, Andy Lutomirski <luto@kernel.org>, "Dave Jiang"
	<dave.jiang@intel.com>
Subject: Re: [PATCH v4 3/6] lib: Support
 ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
Message-ID: <20251023121341.0000765c@huawei.com>
In-Reply-To: <20251022-tried-alright-752fa98ff086@spud>
References: <20251022113349.1711388-1-Jonathan.Cameron@huawei.com>
	<20251022113349.1711388-4-Jonathan.Cameron@huawei.com>
	<20251022-tried-alright-752fa98ff086@spud>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100009.china.huawei.com (7.191.174.83) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Queue-Id: 4A63D4000F
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ogau9ubec9be41ed6recof1rppc6w8rx
X-HE-Tag: 1761218028-133563
X-HE-Meta: U2FsdGVkX1+WwNwLbf1txJDjJL6QyNL8aS27AFBNO+wOLJTIDs0uQIFmlV8up+l9ddhatp1vjOKg4K3yDTVbuF3YZ0ftM30YnHsWunD/2VvkQVIcEA+Ewap27BQavqEjZhwPH0Wros6R/Erq3wXchOv3ByPUwyj5zWToI4II0UOk5+OEpqHrVQ72jj1/1ttfzqyDqDZxL7BX8POyCUSlVsNqtL6OTM4b0sroQkfLNJSIc2spLr7XFtBrHI+vtL0a+a+06u8vK1RzJZYrpCz4o95RvkJ+bT5OvyPwlLmY2bkxMklXq6KbeoctNIEwn+7/AhygdRX4IhwAs4+CMK7JioPsLdBj5uE0HIQeUbfDj5aZ0+cR2nPr3YaBZH+7G7mEnAypdfjdoIxdYM8tW9QYQIajw65c56sS47JEUN4qkLYDBqR4JvBV8XwVNvc0p/n4zrz8V4JW5pDG4RjPe6Wt4yr0oBNMzVCVTPIb6jV1Gs9vcerrh040rKLwnjx0FfXvl6NLMht8xbCyKKBOwX1GTsunU1E+SfmcaHFu659vS9tuxa1JnhbYIDZGb1UrPK53anH+He4dWRBfaSPEz4GxuQyEW12bOxxm7BA3PZJlVI3eoq/VPmBxHiguNgMyNunxLPf3ck2O1V2vf/utWIa4jYoVie0nXQ0YHL1LJDg9YXj+QlehLPy4ResyjjzGURA3ymSyPBY7DoSYGPWHvz7Q0geKGt3bx2kNbQ5LZl/kIK7930u8ZZTMzzBSp/rMsVtB2uqa0pb4mO5rwA1JkHDiwRovdZdkeUnB2ZTfOU69TMw5wI+8X0Y3iV4d9hkv/iwkwiW6ZePfZ/e144S3iugp7eoEgUyUYSdtwDVK4qTfr/09TYE6i68nZP0Hiw7tmTJYmMaC85VFH0Ore0RR37OgOja0+EsVWNYjw00l8D640PjxG8GZtShzSbEkM6n+2Lmjn/D0ZA2gx8VZ/4jIAWA
 Q2AOXVVv
 IS1rZdROwJZjQlRMUfaiBw/Y5wyXVKDHMm608RaGUoX4lByfuV8x/jaJC0pveQ3SNG3YyrWiWg8XAHBYQ2S7GbHTwG4x58dRu2pB3FNgklzF1zGL/ZMowcqWBfXldfmw7ZtpbjukdM+zbz2fDej+GGH91Ee4QbboVhBprhVajGZEPMFhtrMuw+sVvo4VdSw3iRY28pCBCkcZfkOPzc511K60olbGhZzkW28YmbOBXZ4RPhN7wtGrlD4iaGuHq1wbVHhnOM8UDio++8RbC5v9xjzlrcYv0lDMAH8AENb/poXe+IGRwIaZyB9fRI2AG1gJu3J7YHGS+C7ZswD4C1HuyErWwF+R0ew7y68nIQusK30iwpCAV18Icp/VfRBuUse+6OkGlm3+0q056ZeK1ljyeHwLEHg8fIdvu7te4k4b87eIqVrH0r0FARJHddg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Oct 2025 22:11:12 +0100
Conor Dooley <conor@kernel.org> wrote:

> On Wed, Oct 22, 2025 at 12:33:46PM +0100, Jonathan Cameron wrote:
> > From: Yicong Yang <yangyicong@hisilicon.com>
> > 
> > ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION provides the mechanism for
> > invalidating certain memory regions in a cache-incoherent manner. Currently
> > this is used by NVDIMM and CXL memory drivers in cases where it is
> > necessary to flush all data from caches by physical address range.
> > 
> > In some architectures these operations are supported by system components
> > that may become available only later in boot as they are either present
> > on a discoverable bus, or via a firmware description of an MMIO interface
> > (e.g. ACPI DSDT). Provide a framework to handle this case.
> > 
> > Architectures can opt in for this support via
> > CONFIG_GENERIC_CPU_CACHE_MAINTENANCE
> > 
> > Add a registration framework. Each driver provides an ops structure and
> > the first op is Write Back and Invalidate by PA Range. The driver may
> > over invalidate.
> > 
> > An optional completion check operation is also provided. If present
> > that should be called to ensure that the action has finished.
> > 
> > When multiple agents are present in the system each should register with
> > this framework and the core code will issue the invalidate to all of them
> > before checking for completion on each. This is done to avoid need for
> > filtering in the core code which can become complex when interleave,
> > potentially across different cache coherency hardware is going on, so it
> > is easier to tell everyone and let those who don't care do nothing.
> > 
> > Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
> > Co-developed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>  
> 
> Acked-by: Conor Dooley <conor.dooley@microchip.com>
> 
> I'm fine with this stuff. I do wonder though, have you actually
> encountered systems with the multiple "agents" or is that something
> theoretical?

Yes to multiple agents. There are a multiple instances in the HiSi platform.
The multiple heterogeneous agents case is more theoretical today.  Similar
components for other purposes are heterogeneous so I'd be surprised if it
doesn't surface at some point. Our initial internal driver for the
hisi_hha wrapped up the multiple instances in a fake front end, but it
meant we ended up with multiple levels of registration and it was just
simpler to relax assumption that they were all handled by one driver.

Jonathan



