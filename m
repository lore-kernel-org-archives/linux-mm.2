Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ED1ECCA470
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 22:15:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 543788E0007; Tue, 30 Sep 2025 18:15:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51A148E0002; Tue, 30 Sep 2025 18:15:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 456F88E0007; Tue, 30 Sep 2025 18:15:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C8DBC8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 18:15:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6610C13BE66
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 22:15:01 +0000 (UTC)
X-FDA: 83947322802.22.A0AD781
Received: from r3-25.sinamail.sina.com.cn (r3-25.sinamail.sina.com.cn [202.108.3.25])
	by imf19.hostedemail.com (Postfix) with ESMTP id 965051A000C
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 22:14:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b="w/zrK9mj";
	spf=pass (imf19.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.25 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759270499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PeSt4auwglYPFnJc8427LVoppmueE7xaZPihXjESuXM=;
	b=UmopZaSq7fN4daWW6vzDxxuUgRko5vQ+dMwGBCFes9vZU5EUiWvE6GtzbDhmXHZLXOPyKG
	lC5CQNFvn2d32a9jP3je3o3Cb7PnNyiqlnkbgWCUHnOQa6eKAXmuHeAy0ZBpL0MazFcIpP
	O2lsdNa13TBJ+EO63Jo/8gmrEsGv/dI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759270499; a=rsa-sha256;
	cv=none;
	b=sBZ28GfbXC0aGoRYUPeFBenhcCREBI1jCp+wg3/Zd1HR/JVZ8kxeoBmr+PFkoWlgE9Apw1
	dK6F0DSQGsNZLXyZjq87hEWET/CPYSXeEQLoQ+htCIVBw6DODpw1g+i91Fcpo2XQ4tb9kb
	sVUhJQIeJx4JD+IR3qhv2yfwqEnnFkg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b="w/zrK9mj";
	spf=pass (imf19.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.25 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1759270498;
	bh=PeSt4auwglYPFnJc8427LVoppmueE7xaZPihXjESuXM=;
	h=From:Subject:Date:Message-ID;
	b=w/zrK9mjLxs8v467OJrkDqb3Y3M9M92qSgHDOPVLlW44ybqiXoJP1D3AUrLbR7xfz
	 Fppwlo4bwcyUtLjuiwxAQyEdAO4bmLMHU7HQEFBk2sZjaH3VbQOt0cQNTn3rviYqQo
	 ulFWvSwY0UpK4V0cku3gNqd9H0qXoYcFWwHvgJ1A=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.58.236])
	by sina.com (10.54.253.31) with ESMTP
	id 68DC565B00001D3D; Tue, 1 Oct 2025 06:14:54 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 2332286816301
X-SMAIL-UIID: C55BE4FAE527454F8983310896AB42A9-20251001-061454-1
From: Hillf Danton <hdanton@sina.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/4] mm/page_alloc: Perform appropriate batching in drain_pages_zone
Date: Wed,  1 Oct 2025 06:14:40 +0800
Message-ID: <20250930221441.7748-1-hdanton@sina.com>
In-Reply-To: <20250930144240.2326093-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 965051A000C
X-Stat-Signature: 63hi3expfebn6ft6r1sxcbaayzbbd9bo
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759270498-690496
X-HE-Meta: U2FsdGVkX1/4JmydjCuCKvW1OfiX4fpCLHSrtEy42QX9/z60Ov4jNnSQYEQnBjJY1oCvxvHzH1T0uggX8nUmUMf0jBQ106yAvu/VmuaEiAEgXQTWE5pxy3MuVVTlfjwHgu/E3Vhzq2KQMMx0+QjIdufbxJ/dIa/4BgW8Pi0KzDea9feCmlV6YSCbrYFdYoTYkgpjdR6+j85w6ANEo6T2g2exLyZjrRY9+Z9k2V1Zrrn6uKxgjY9dAecAHzE38gBnKwANLXj3tFWu4mO/CDTI0sSMvw69qfJYOuOTsxhO15yvItUB3W/JC7p9RLJXqERIbGpy85Nn9gTtfbvZyeop2mR2DyGrVBTvmgyOR1F+SN78l6I3L4UlxeeGlb6zM9kc/fC5ktSpjPAPNGholBVnXlHFadQNgFhRPHbtMbI/8aNRSwzXTXKBp5aBUo8xWcnPfTaV3ElWhnQc/MIRSrJEmIoGW6+vNLvblvvGsJ5ZLTCz/szk3jlrwIsIwa9yHelckvF+a8n02q0PRXIyUu8nDfvhXQZbYF7NwyANGxWW7DIoeTEchjNxc/81XWPOOnRTqZrcp3iTClI950aXza7fw/zgG3NL5Ak3vzxGlS58Ym4QrEGM6jVs5ykeu146vBBJv0ilJr0i7V3sx7bV9OK2wJYE+tG8wW5dD4Wd7fefTDeFLXGjB4XQu7TdgvXUa5qbcbf3dCwt6NwBkk8D+6l37gEuwIUcB1CagGYTJCVyyD0b/auSSg1ln3wx+Z5iH49wUq173U4PZ1g4jkHYL2twjYbisg8DZGX2tyYXts0cVAXIHjtJT1gMAXTJ8I/j2OXmCbiITmMKEQ04QxOU+SDbtXRneW+obZpW38v0wlFuUd5o1nUdYbAO6yBLDIjxTcCKlDrGAstt1Ild8YhDYSjJxMdLi1Qdy2aeArY2tlspx64QI7KgCs8WRxggVggtohxoBgLXi/42oCd/L97+6au
 2y8Jt9/A
 vSszlKBzd4Juyrr3+vag1TK4vGAuA1xL+7Tjpsa7S4XPxPeyD4JEYOkE24Mhxh0j4tC1q2M0aY1q2tKQ/eXjcjseOF6ulXqCH0vqsaLcgo3YLIpuEXKRtXAtlEmKJHK64eWlozsL/dJ4KXTF0MlGR0Hmbtz402p4PoPZ3vSxCV3XIA4CWV0oehlv/COQaVEVFOjAlF6kHsMhnMSXtPEdr/ycJn3CKKlyuyj+FjL8DMugRxQlpt2CIhOYUcis21OlREA4W3gxMYf9a+fWocHWC1qovp8+Td05RUgpfNmissxBXhdC7neTxpVNXUj3QHc2+I61gKnzKniDL2cmeSqXH3WFgCghCpx5tdwOpXnxKpWkJRrDCSmSDwtoTuK0goZswwY9yScT0PWcE6/ByHX9zogASFFs18M9/Fc2gD067GgbJMAYKSj8vFewLmsu8pR3Y+XmX6KiT9v0E5j8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Sep 2025 07:42:40 -0700 Joshua Hahn wrote:
> On Sat, 27 Sep 2025 08:46:15 +0800 Hillf Danton <hdanton@sina.com> wrote:
> > On Wed, 24 Sep 2025 13:44:06 -0700 Joshua Hahn wrote:
> > > drain_pages_zone completely drains a zone of its pcp free pages by
> > > repeatedly calling free_pcppages_bulk until pcp->count reaches 0.
> > > In this loop, it already performs batched calls to ensure that
> > > free_pcppages_bulk isn't called to free too many pages at once, and
> > > relinquishes & reacquires the lock between each call to prevent
> > > lock starvation from other processes.
> > > 
> > > However, the current batching does not prevent lock starvation. The
> > > current implementation creates batches of
> > > pcp->batch << CONFIG_PCP_BATCH_SCALE_MAX, which has been seen in
> > > Meta workloads to be up to 64 << 5 == 2048 pages.
> > > 
> > > While it is true that CONFIG_PCP_BATCH_SCALE_MAX is a config and
> > > indeed can be adjusted by the system admin to be any number from
> > > 0 to 6, it's default value of 5 is still too high to be reasonable for
> > > any system.
> > > 
> > > Instead, let's create batches of pcp->batch pages, which gives a more
> > > reasonable 64 pages per call to free_pcppages_bulk. This gives other
> > > processes a chance to grab the lock and prevents starvation. Each
> 
> Hello Hillf,
> 
> Thank you for your feedback!
> 
> > Feel free to make it clear, which lock is contended, pcp->lock or
> > zone->lock, or both, to help understand the starvation.
> 
> Sorry for the late reply. I took some time to run some more tests and
> gather numbers so that I could give an accurate representation of what
> I was seeing in these systems.
> 
> So running perf lock con -abl on my system and compiling the kernel,
> I see that the biggest lock contentions come from free_pcppages_bulk
> and __rmqueue_pcplist on the upstream kernel (ignoring lock contentions
> on lruvec, which is actually the biggest offender on these systems.
> This will hopefully be addressed some time in the future as well).
> 
> Looking deeper into where they are waiting on the lock, I found that they
> are both waiting for the zone->lock (not the pcp lock, even for

One of the hottest locks again plays its role.

> __rmqueue_pcplist). I'll add this detail into v3, so that it is more
> clear for the user. I'll also emphasize why we still need to break the
> pcp lock, since this was something that wasn't immediately obvious to me.
> 
> > If the zone lock is hot, why did numa node fail to mitigate the contension,
> > given workloads tested with high sustained memory pressure on large machines
> > in the Meta fleet (1Tb memory, 316 CPUs)?
> 
> This is a good question. On this system, I've configured the machine to only
> use 1 node/zone, so there is no ability to migrate the contention. Perhaps

Thanks, we know why the zone lock is hot - 300+ CPUs potentially contended a lock.
The single node/zone config may explain why no similar reports of large
systems (1Tb memory, 316 CPUs) emerged a couple of years back, given
NUMA machine is not anything new on the market.

> another approach to this problem would be to encourage the user to
> configure the system such that each NUMA node does not exceed N GB of memory?
> 
> But if so -- how many GB/node is too much? It seems like there would be
> some sweet spot where the overhead required to maintain many nodes
> cancels out with the benefits one would get from splitting the system into
> multiple nodes. What do you think? Personally, I think that this patchset
> (not this patch, since it will be dropped in v3) still provides value in
> the form of preventing lock monopolies in the zone lock even in a system
> where memory is spread out across more nodes.
> 
> > Can the contension be observed with tight memory pressure but not highly tight? 
> > If not, it is due to misconfigure in the user space, no?
> 
> I'm not sure I entirely follow what you mean here, but are you asking
> whether this is a userspace issue for running a workload that isn't
> properly sized for the system? Perhaps that could be the case, but I think

This is not complicated. Take another look at the system from another
POV - what is your comment if running the same workload on the same
system but with RAM cut down to 1Gb? If roughly it is fully loaded for a
dentist to serve two patients well a day, getting the professional over
loaded makes no sense I think.

In short, given the zone lock is hot in nature, soft lockup with reproducer
hints misconfig.

> that it would not be bad for the system to protect against these workloads
> which can cause the system to stall, especially since the numbers show
> that there is neutral to positive gains from this patch. But of course
> I am very biased in this opinion : -) so happy to take other opinions on
> this matter.
> 
> Thanks for your questions. I hope you have a great day!
> Joshua

