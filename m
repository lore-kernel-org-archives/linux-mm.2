Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C349DCCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 14:05:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C92C8E0020; Mon, 20 Oct 2025 10:05:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 279A78E0002; Mon, 20 Oct 2025 10:05:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 169648E0020; Mon, 20 Oct 2025 10:05:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 011E68E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:05:37 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9CD2BC01A5
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:05:37 +0000 (UTC)
X-FDA: 84018665514.10.D47D590
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf12.hostedemail.com (Postfix) with ESMTP id 51E1D40014
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:05:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760969135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OLQ/08zyvaqZ9JirA/gVGjx3LtWMSgx7RvOPkTXnqJk=;
	b=VAZXP7nLasvP8+7fKQVibM6CXPJJiaUL4ALko+v09AH3iv80o+DiiZtfAJqjiq7jIzJVuw
	2pa+yH/SWNq3awG8XYlWnunb8n4m3yzk6fqmhwCp4+kzOeFkjT7RKQWNWnFKtqUJsEU8xa
	8dUYM7O662Z47UmEeYtHEtjlwImbGl8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760969135; a=rsa-sha256;
	cv=none;
	b=DiXertmt8D5Xbd0bV2T8loCMIFWtAzuYUBM2cQeceiPGrMhaT+3YcPy3Pa2uQugv8RbXrT
	cHwenaA4Zq+0PsT0KhPy5gwNIE/yUSaI/C+AO66/Ne14q2WU7r5BVUHjs6aPYlRGZwTiMx
	oGmxGvd+CbLW5F4ETQc652tcw+Fm6JQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cqxvN3hyYz6L4t4;
	Mon, 20 Oct 2025 22:02:24 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 99F0E1402FC;
	Mon, 20 Oct 2025 22:05:31 +0800 (CST)
Received: from localhost (10.48.157.75) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 20 Oct
 2025 15:05:29 +0100
Date: Mon, 20 Oct 2025 15:05:26 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Gregory Price <gourry@gourry.net>
CC: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>, Wei Xu
	<weixugc@google.com>, David Rientjes <rientjes@google.com>, Matthew Wilcox
	<willy@infradead.org>, Bharata B Rao <bharata@amd.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<dave.hansen@intel.com>, <hannes@cmpxchg.org>, <mgorman@techsingularity.net>,
	<mingo@redhat.com>, <peterz@infradead.org>, <raghavendra.kt@amd.com>,
	<riel@surriel.com>, <sj@kernel.org>, <ying.huang@linux.alibaba.com>,
	<ziy@nvidia.com>, <dave@stgolabs.net>, <nifan.cxl@gmail.com>,
	<xuezhengchu@huawei.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<yiannis@zptcorp.com>, "Adam Manzanares" <a.manzanares@samsung.com>
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion
 infrastructure
Message-ID: <20251020150526.000078b6@huawei.com>
In-Reply-To: <aPJZtQS4wJ1fkJq-@gourry-fedora-PF4VCD3F>
References: <20250925160058.00002645@huawei.com>
	<aNVbC2o8WlYKjEfL@gourry-fedora-PF4VCD3F>
	<20250925162426.00007474@huawei.com>
	<aNVohF0sPNZSuTgI@gourry-fedora-PF4VCD3F>
	<20250925182308.00001be4@huawei.com>
	<aNWRuKGurAntxhxG@gourry-fedora-PF4VCD3F>
	<aNzWwz5OYLOjwjLv@gourry-fedora-PF4VCD3F>
	<CAOi6=wTsY=EWt=yQ_7QJONsJpTM_3HKp0c42FKaJ8iJ2q8-n+w@mail.gmail.com>
	<aPJPnZ01Gzi533v4@gourry-fedora-PF4VCD3F>
	<20251017153613.00004940@huawei.com>
	<aPJZtQS4wJ1fkJq-@gourry-fedora-PF4VCD3F>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.48.157.75]
X-ClientProxiedBy: lhrpeml500011.china.huawei.com (7.191.174.215) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Server: rspam01
X-Stat-Signature: gqfn9qgi3zjuwyoqhd5nbddfphkf4m3n
X-Rspam-User: 
X-Rspamd-Queue-Id: 51E1D40014
X-HE-Tag: 1760969135-2741
X-HE-Meta: U2FsdGVkX1/4YHcKsHGErOIzr33YkIwOGpwRo68WzVZY+94YqQJoDScnAxzGYeh8lNdL78k4cLlsD8ORcUQHNqmP6ey4jrYxN23LuEBwUSHd1wGK9kU59/n9m36AmGsLujGe0Etxr1mQC99YZqIgLWM2lshbv0ojAT2Aw/BxROh1rTdXCkUc+q2zpWqqgxDUjBfAAoTuD4QbwDSjE184AoUC7JAZRm8SyyoSzUqzF8hdvyzMEGiPoTx4QpVftFlqTzEx039ZOixw6sE+TkATeLpen0rMJL/j63BnZzfRRNBOXZWmQuqTEszjCIEZW7v6yUtMu0VLWXjP2nr5zeQ5YMHYDcMMmg1ab/zYncQDLakFktwRwQlqgKgVKYs16hq+Rv6qb1U2bytWFfaBcvzKyQW1ZGDs5NibhqC995EX3oZ24t5KMNvgfi7kjsmAmcUevUgG6hrBpnfIFWSxwTo10nTq1VJCqIqX56Z53osbWqm0e6ZvzXvzwoIGZrZv665mybKf5RZcsNCRsVx9Y37EAexGe9GqW7TJoM1RCGoL3XoiaPCMOIWrqY/uxomxofLEAqBb034MQ4TIhlQXqnzCNq/RkvCIfDVpveaw2lGSsVPGF6rSgDukEpCKATl1I1C7XXxNzv7567h69e+tp+8QFyJ/8ByPAhv3LTKv3W+NhDMQ7GlkX05Eo6DCLhLo6jz+5AahmShmSs3jrD0DaeSthPoqPQVlSnPpYTPevbXiAA3R0fm4nZ7oNelRX8GAlchBaP8Gu/mXU1d6PvSM2bquARaec+iq5CiJ/jMfpE5b99ToiBwUzc3A/Lfbg7cLUSTq1oU2ygVdhZAQBsCd/+qLWVdA/XbXZVTzzZeoZgMDkRvkPglUMRHogXj5T2IjLrPR8rF6cE1OLStV/Gt6SRUsYER25+fczizsbbtmoEiivxaAosREL+8KsdZJtFDHsro+TogUxBfGslhQM7+mjm3
 W3P1Ybni
 WxGTg1DOmh/qbQyEEqfevldfhRj70CV3783cgFZJWhy8DNPdBmOAUaltXc1YVjgmSMOrY9a0ScCe4jOYYctc9/T3qKrYI7qN6QK4hI5vIPWMTrNopm534y5S5HALPVl1RwQT5zmuEC6an/Q9vHbVU61bhD5z7oOqyDm0/hwA+kH7P51Gq/nmN/5T6VBSnEFIFjWtfJGemZuDcBCAWPue0P/HNHn72qGLSpYESJnFGrsnQtH4MISbb1vt6+IYdXjoe4Z8TNSHxM2AmTnmFDSnNkq0911kluA+BFkL8piKvhSaoYgasH/2qc4I3Y7C83RiVKvzv0mUT3c77tMBJfvbiuWP2nm4RK96n2ltE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Oct 2025 10:59:01 -0400
Gregory Price <gourry@gourry.net> wrote:

> On Fri, Oct 17, 2025 at 03:36:13PM +0100, Jonathan Cameron wrote:
> > On Fri, 17 Oct 2025 10:15:57 -0400
> > Gregory Price <gourry@gourry.net> wrote:  
> > > 
> > > Essentially the platform needs to allow a single device to expose
> > > multiple numa nodes based on different expected performance.  From
> > > those ranges.  Then software needs to program the HDM decoders
> > > appropriately.  
> > 
> > It's a bit 'fuzzy' to justify but maybe (for CXL) a CFWMS flag (so CEDT
> > as you mention) to say this host memory region may be backed by
> > compressed memory?
> >
> > Might be able to justify it from spec point of view by arguing that
> > compression is a QoS related characteristic. Always possible host
> > hardware will want to handle it differently before it even hits the
> > bus even if it's just a case throttling writing differently.
> >  
> 
> That's a Consortium discussion to have (and I am not of the
> consortium :P), but yeah you could do it that way.

The moment I know it's raised there I (and others involved in consortium)
can't talk about it in public. (I love standards org IP rules!)
So it's useful to have a pre discussion before that happens.  We've
done this before for other topics and it can be very productive.

> 
> More generally could have a "Not-for-general-consumption bit" instead
> of specifically a compressed bit.  Maybe both a "No-Consume" and a
> "Special Node" bit would be useful separately.
> 
> Of course then platforms need to be made to understand all these:
> 
> "No-Consume" -> force EFI_MEMORY_SP or leave it reserved
> "Special Node" -> allocate its own PXM / Provide discrete CFMWS
> 
> Naming obviously non-instructive here, may as well call them Nancy and
> Bob bits.

For compression specifically I think there is value in making it
explicitly compression because the host hardware might handle that
differently. The other bits might be worth having as well
though. SPM was all about 'you could' use it as normal memory but
someone put it there for something else. This more a case of
SPOM. Specific Purpose Only Memory - eats babies if you don't know
the extra rules for each instance of that.

> 
> > That then ends up in it's own NUMA node.  Whether we take on the
> > splitting CFMWS entries into multiple NUMA nodes depending on what
> > backing devices end up in them is something we kicked into the long
> > grass originally, but that can definitely be revisited.  That
> > doesn't matter for initial support of compressed memory though if
> > we can do it via a seperate CXL Fixed Memory Window Structure (CFMWS)
> > in CEDT.
> >  
> 
> This is the way I would initially approach it tbh - but i'm also not a
> hardware/firmware person, so i don't know exactly what bits a device
> would set to tell BIOS/EFI "Hey, give this chunk its own CFMWS", or if
> that lies solely with BIOS/EFI.

It's not a device thing wrt to nodes today (and there are good reasons
why it should not be at that granularity e.g. node explosion has costs).
The BIOS might pre setup the decoders and even lock them, but I'd expect
we'll move away from that to fully OS managed over time (to get flexibility)
- exception to that being when confidential compute is making its
usual mess of things.

Maybe the BIOS would have a look at devices and decide to enable a
compressed memory CFMWS if it finds devices that need it and not do
so otherwise, though not doing so breaks hotplug of compressed memory devices.

So my guess is either we need to fix Linux to allow splitting a fixed
memory window up into multiple NUMA nodes, or platforms have to spin
extra fixed memory windows (host side PA ranges with a NUMA node for each).

Which option depends a bit on whether we expect host hardware to either
handle compressed differently from normal ram, or at least separate it
for QoS reasons.

What fun.

J
> 
> ~Gregory


