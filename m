Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 009AACCD194
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 10:31:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E91E8E0007; Thu, 16 Oct 2025 06:31:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C0658E0003; Thu, 16 Oct 2025 06:31:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D5FC8E0007; Thu, 16 Oct 2025 06:31:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0C0F58E0003
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:31:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C7AE7119466
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 10:31:31 +0000 (UTC)
X-FDA: 84003610782.05.48D3324
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf23.hostedemail.com (Postfix) with ESMTP id EBA2914000C
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 10:31:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b="lY/NlE/b";
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf23.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760610690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UxTkzxZWRqOwIOCFQgXcutuiJic9xI7p5Uhf9tCak18=;
	b=BEdheRDyXY054/BmUMII2+R2Sw9dIeq5s+AZafc6xuMdbxk5FR3+CPHfDzUH5rzZVy9zC2
	dTXG9fYnGWCjisEWVuKDMc/xK/p+uKEHg0Pm0DXM0Vs8+Xp/4Qgz/ydUmC8L4O7sKmbIw4
	DZ1xVtnrTOqUHc7UvxaEINwuaOM4KCo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760610690; a=rsa-sha256;
	cv=none;
	b=u4KT8mecU2xyL0FafslGC2BeJKcYqXFwzBciYFpat2P9d8o45+zGO5DL9ZpB0Upm0jbfM9
	GjKOfIH47GLiUPlXuSfJucrDmezL98/SaU63GkfFKac41EtyobdEyA/fKjzDDwuEhtPFOg
	vEdkOJMGwpvnxDqrRlANWeV9k2xt9xE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b="lY/NlE/b";
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf23.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id AE95240E01AB;
	Thu, 16 Oct 2025 10:31:24 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id CjO_OZbZHhXX; Thu, 16 Oct 2025 10:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1760610680; bh=UxTkzxZWRqOwIOCFQgXcutuiJic9xI7p5Uhf9tCak18=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lY/NlE/bP8Uu488fCJhG0VgYb0R1RmofyVlWeYU0XvzJXOtwqnI+xxMcDXjl2A0Pl
	 6ELFwVzaFEpa8Hry+XC8jnIRWF3YDqcSeRawxxnaTJCQPb4jPJvQtFosFivqcrTsss
	 HdpxBZnmI6dw76swAIymhgwGB7IxO6t1OROHcIbFL3u5sgabLhNsOfTgJYzayQJR8r
	 lYyQuWIEhPQC/ZZ+7P8u4d/JAwWKYRnszVzsDdw4gK6KdB8DMN403K0WHxyvYdLagE
	 PfPidmueKn6PshP/FAV89SYV0jlguwSOYh4915QLvOyFjlaFaD4hWx0tyza+azW7Ah
	 oeYwG+7IqlCxVPwsJ4fhl7LqhALZZjrNycfQ6g6SI4ukTtFzxVT6wx5OsInC80ktRR
	 nOER+slSxz8ZYxAhUqJBivxp7sYvMiSWHedt5myWyLkwjP/58eQ1QDHGdIcAXPas6v
	 JexQQYLu9I1jME/Rldi0WojMbP6915UBKD/cV2iVxm/aj3F4A4P7JJ3eb5lmZxkDmz
	 0hWzTXQ/H4p5S0mPONWZDPpuh3q1O5ifLAwCghGaJ0BsggbS0GPDzIk4Bgojw6lm7b
	 Ok44P94ia/XsBtmEMjwOfruDT5DxMkXhRHWof1dTAMRywZPG9ThHIFUpg9DZ51ug5/
	 DmuV376y+aDKY5bmrbLXff3Y=
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 1977140E00DE;
	Thu, 16 Oct 2025 10:30:45 +0000 (UTC)
Date: Thu, 16 Oct 2025 12:30:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: Shiju Jose <shiju.jose@huawei.com>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>,
	"rafael@kernel.org" <rafael@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"rppt@kernel.org" <rppt@kernel.org>,
	"dferguson@amperecomputing.com" <dferguson@amperecomputing.com>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"tony.luck@intel.com" <tony.luck@intel.com>,
	"lenb@kernel.org" <lenb@kernel.org>,
	"Yazen.Ghannam@amd.com" <Yazen.Ghannam@amd.com>,
	"mchehab@kernel.org" <mchehab@kernel.org>,
	Linuxarm <linuxarm@huawei.com>,
	"rientjes@google.com" <rientjes@google.com>,
	"jiaqiyan@google.com" <jiaqiyan@google.com>,
	"Jon.Grimm@amd.com" <Jon.Grimm@amd.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"naoya.horiguchi@nec.com" <naoya.horiguchi@nec.com>,
	"james.morse@arm.com" <james.morse@arm.com>,
	"jthoughton@google.com" <jthoughton@google.com>,
	"somasundaram.a@hpe.com" <somasundaram.a@hpe.com>,
	"erdemaktas@google.com" <erdemaktas@google.com>,
	"pgonda@google.com" <pgonda@google.com>,
	"duenwen@google.com" <duenwen@google.com>,
	"gthelen@google.com" <gthelen@google.com>,
	"wschwartz@amperecomputing.com" <wschwartz@amperecomputing.com>,
	"wbs@os.amperecomputing.com" <wbs@os.amperecomputing.com>,
	"nifan.cxl@gmail.com" <nifan.cxl@gmail.com>,
	tanxiaofei <tanxiaofei@huawei.com>,
	"Zengtao (B)" <prime.zeng@hisilicon.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	"kangkang.shen@futurewei.com" <kangkang.shen@futurewei.com>,
	wanghuiqiang <wanghuiqiang@huawei.com>
Subject: Re: [PATCH v12 1/2] ACPI:RAS2: Add ACPI RAS2 driver
Message-ID: <20251015223242.GBaPAhCuS7YWqu-aH0@fat_crate.local>
References: <20250902173043.1796-1-shiju.jose@huawei.com>
 <20250902173043.1796-2-shiju.jose@huawei.com>
 <20250910192707.GAaMHRCxWx37XitN3t@fat_crate.local>
 <9dd5e9d8e9b04a93bd4d882ef5d8b63e@huawei.com>
 <20250912141155.GAaMQqK4vS8zHd1z4_@fat_crate.local>
 <9433067c142b45d583eb96587b929878@huawei.com>
 <20250917162253.GCaMrgXYXq2T4hFI0w@fat_crate.local>
 <20250917183608.000038c4@huawei.com>
 <20250919103950.GCaM0y9r6R6b5jfx8z@fat_crate.local>
 <6ac4ad35975142df986bfcb27d1e9b2c@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6ac4ad35975142df986bfcb27d1e9b2c@huawei.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: EBA2914000C
X-Rspamd-Server: rspam02
X-Stat-Signature: rad9qnqsojseugaz6fgc6xz1x9isuxcu
X-HE-Tag: 1760610688-821562
X-HE-Meta: U2FsdGVkX1+WNx5UPTHFQ+jlvneY+66r3kBMlgNiIMULfK6aoZJlDTdH3faBVa9pV0WH3x7Yp+CIj/HEjFd9IPVjiVr0DmuSa8iwoFD6DRcprFXG1FBkbO2RkLRXmhS34ZncjGmv+THWhizTwRt6sMIltcieAIcJJrEVO3a0ZuOLMeqdMQm9v7jjzJMYoW9ao8XXHb0t48OwglWXZGRJ/IjFC+Osc1HNoBPSDqtyWSs+X59LA5V0DhVyfj9KNUsS8YALSc+zMDrWdYNW9DuU8Dzmr6vl51LVrjTOBpKxwKRaI5n9sR2MPaQaLSF7Sh/s4yujITTESaBhPltEeXXi2DwUz8ll+O5DipAzHTRAZlMhMhp0RxAfwzeh+uPdzTSAxJXo3v1FWXO2Y+BX96VIPZUYPp5yGqvn9++foEt91WK4gewMqxLI+k5eYTe+Ve8Oc+UfnKSiXMGEO3vTaVoafv0h89uVlu7+JcPFVMzeJl761UI4W8PUWnppdjShPh7q1gekLX8nWmQlzTD8/pQ5QUXZBxVTm6NBZY6aay9dZ6LmF2DqTFOuvJSn2bQ7htaLLqOPjfEiSk7hGjK57Ed4MK0NWnobVkTUQUma6VCE2RVQM8xNdjIYl16UKLZNLTAlyjrUjXbNnjMaegNphZXgR/JuCJuEBUjE8tNnqL9HsRtfjKMw6VlhJopidflivILWhXA23avddyO/PJbgiUXlJo6dBlN9MZ9E96ZmD9B+sBH5BHGE2xghmCgMcttL3HKH4JpffQz4yX6kZUCzqo8LfdR1GtOk0dtXotvPMe6qbQMBPJbgd9I5f2Xj5OhLFjZ1Grg+FFLlTht756B2hLMw5bTGvIw67NCfKwKHMhsFpieW+LH5FkIzkn3fo4E3GoNHjPOZ0iL4ZBtiEGthXWXT6EmMz39qN0uvOmkNsTLzNlFufo+c5xAiMbRBkV+vLGCCDKG6jWMPSB/IjPflX+6
 VQudrIBV
 bYTa0SYB36IOlba8SpBA+kQrIZDvEkPAxzT0d9eAUhg21s27KtXGTJgJ7mpMcOFtu7MQMRlT1bewe2A+bZvXleQ5wwH6789iiE5cPAjLB+u85Tm0xQRGhkLJtmL4NRbJLr7W6ZQJJYFovrLQg3x3cixg24cbvDnQ3CEkU4EmryF0dm1hLaPvjEjzA6gqQC5Bm8uyUJ/k4FICRG3cDTYibqQVB/nUFiBimWUfcwtQH+Jy6c2PioUhvHGdm+iYMMfrmWijPoslq2ZVnehnWSyisxCB6Lj6QgkkbJAlktVYyP62F0POfsvdJIwh2rY+OrRQI3VlHUUfWjK+1Fhq28/sB9RMH1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 06, 2025 at 10:37:39AM +0000, Shiju Jose wrote:
> 1.Scrub rate
> 1.1. Scrub rate is common across the NUMA node domains.
> 1.2. Common min scrub rate is max of min scrub rates across nodes.
> 1.3. Common max scrub rate is min of max scrub rates across nodes.

And you need scrub rate to be per node because...?

Why can't it be a system-wide scrub rate?

If the use case appears which needs per-node scrub rate, then you design it
this way.

Or you already have a valid use case for it which dictates this design?

> 1.4. Scrub rate allowed to change only if NO demand and patrol
>    scrubbing is in progress

Right.

> 2. Demand scrubbing and Background (patrol) scrubbing
> 2.1. Background scrubbing request enables BG scrubbing
>      on all NUMA nodes.

Right.

> 2.2. For, demand scrubbing request 2 options are identified,
>      with (b) tried. Please suggest the right approach?
> a) Enable demand scrubbing on all NUMA nodes, hope for
>      the 'Requested Address Range(INPUT)' field, can use
>      address set to scrub and PAGE_SIZE(or similar) for all the
>      nodes.

Why do you need an address range? Why not start scrubbing and have it be
fire-and-forget?

> b) Enable demand scrubbing on a NUMA node for which
>      the requested address to scrub is within the PA range of
>      that node.
> 
> 2.3. Demand scrubbing is not allowed when background scrubbing
>      is in progress.
> 
> 2.4. If 2.2. (b) is chosen, should kernel allow BG
>       scrubbing on rest of the nodes, when demand scrubbing on
>       some node/s is in progress?

It seems like all scrubbing should be mutually-exclusive... or is there
a point in scrubbing in parallel...?

> 2.5 The status of the BG scrubbing exposed to the user space
>     in 'enable_background' sysfs attribute.
> 
> 2.6 The status of the demand scrubbing exposed to the
>        user space in 'addr' sysfs attribute. However when the
>        demand scrubbing is on multiple/all nodes are in progress,
>        which demand scrubbing status and address in 'addr' sysfs attribute
>        as status should be exposed to the user space?
> a) May be the status of the first detected node with demand scrubbing
>      is in progress?
> b) Does not show the status at all, just fail the request if the
>     demand scrubbing is already in progress on a node/all nodes?
> c)  Any other suggestion?

First we need a proper granularity defined and then everything will revolve
around it: should it be system-wide, per-node, does it need to have an address
range or can it be started and no need for any further user interaction and so
on and so on...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

