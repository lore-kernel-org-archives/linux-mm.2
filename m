Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 853A2FCD0A7
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 04:57:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B11F66B00E8; Wed, 18 Mar 2026 00:57:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC31D6B00E9; Wed, 18 Mar 2026 00:57:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D8976B00EA; Wed, 18 Mar 2026 00:57:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88A496B00E8
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 00:57:31 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 07A8C13AC45
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 04:57:31 +0000 (UTC)
X-FDA: 84557975502.19.0185402
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf09.hostedemail.com (Postfix) with ESMTP id D8BA6140013
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 04:57:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773809849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D/1RyWAy+uYvlqz6c/m4iD1cMOGeEJJ7xcNyXpNhxtI=;
	b=GsXUwyFQE3CBaa2qyi1nqcXEhi1jVb3zxf3v2i6R6Twd4K1t5n6zFAP2SapAAo+Bv+huDC
	nBT6RjUdaOcioxBFtXBPve04OBW/FGUByaVby3vJZYRfeTNtvb7r+VxjeRIepM9O+uxU4M
	M1gz0OhsGMKANjO/JNzRixnoylXsGNk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773809849; a=rsa-sha256;
	cv=none;
	b=4x/0I3bK/ul13nJAWrJd/1O6KmonUwSpvkdzDBUHYw/nMHWBzanowJJjBKlWdj9LAfh7+t
	8dYUV+GfLvKZR9LAvPQgPVfYeG5hj8fFZYvPZbmHcyU87djv+acZ9/aqymn+DuNvyt+ElT
	gw52zPdlBfnPwjBnfp7rGuGPk7lE+8U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 18 Mar 2026 13:57:24 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Wed, 18 Mar 2026 13:57:24 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Chris Li <chrisl@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, gunho.lee@lge.com,
	taejoon.song@lge.com, austin.kim@lge.com
Subject: Re: [RFC PATCH v2 0/5] mm/swap, memcg: Introduce swap tiers for
 cgroup based swap control
Message-ID: <abowtIXxfFCPrpHK@yjaykim-PowerEdge-T330>
References: <20260126065242.1221862-1-youngjun.park@lge.com>
 <aY4bQFvpPRWgnOTM@linux.dev>
 <aY6hcPNxiolf5jj6@yjaykim-PowerEdge-T330>
 <aZjxP2sTavBRGC1l@linux.dev>
 <CACePvbU=4f4gT5kHUBq0wD7COHN+quE5g4bPQqJYgJNx_9vuhg@mail.gmail.com>
 <20260221163043.GA35350@shakeel.butt@linux.dev>
 <aZpY1FIjYLtLdu5F@yjaykim-PowerEdge-T330>
 <aaXM58EsMtbGri2B@linux.dev>
 <aafe6VXoCLlajp8b@yjaykim-PowerEdge-T330>
 <abofwUe6Lz_Qap1x@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abofwUe6Lz_Qap1x@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D8BA6140013
X-Stat-Signature: 6ttxrntxpdjkkzpk16uaypome3wobjz5
X-HE-Tag: 1773809847-890713
X-HE-Meta: U2FsdGVkX1/SpaeCg/wxfLxmXhMUoW6+SqzeLY+RgaGk6856cbvmO9SBBP9r5TakWKy1j7GwHtvUPqTyrsC+uJf091+a4swWYKNY5eJY6qRMtJH2doVYqEg+4V6kwareSOGv+/oaFu08RSMn0I7EztzIpHBAqIxPaXNjz3iONkqDFfe3GXuEg/kQSc+4n5Z2N1PHnGMePZeCvfz64D5gHbtNAFwsybrkEH23WJeO3PpueP1gDSi3ZH/ZW4n/Q7FBxbIZ1JApc77vonz0pp9YiJ2Ax8bkpp2/VfjV/EWQuZvOxUw//I/w6MORt1L0vQSg5fmHZNJxGT4n+w+VgUjuWKML9S94cYJIQO9mDFi0kHUeS6MKe+TRl03QW69ChRouKscyfDA1T7u3/KD3m7XFjJJYVFb5axlCG066gVwAwR2fzvEfnvbIQXiwVjH8TLmHxXRJ3FQ8iJUG5cQKGOB8odeb3iQToYL7TxNV0ElCQt7n4zLBKnWnOi6KrHd1WmGXSp2hq8/T8umlfG4e2/pIeCbHlhVH80IStZaRfGEs/EAYXrysNpXWRqjcaHEgPHwiUAevZ2SFHmjPgwNrA5kHmODT3qS7w+22NGUebSpoARUvZf353cAVsal95jjKPCHqKroAo15flI4ES+nkVu8JPykeTXf5BPp3qXCxVrSW8unHhgNLuUR2Qjje75xScj5/WFnGZ9PvH3FqmxHWosNdcggCEdfRRKq5YYAZEugLlECcWAlJY3FPBvdd66mE7tzWYgoS9lJnDeZ/0tAKU4E3FdFmvpeCCAsF+iV82yOzrPNFSvr51uFPUg3kAO3FAz8Twa6VHcybLo8a0Dji2ePRSyQHB23J8FkPcJqss44y0CZ3rFqIm804iU5XqH4mmXVFqT06xl3+pCchOjBanEUxy/yvqAwCtCm3Qx0g9eTBo1/Oy9ndTzx+HVDLAe22wve8XEHKyaeXMjBjXih74Bf
 9SCEpImN
 rQlJDNKD6vb/utHg8rEG+hF+bB2RpHnMV+IvftuOeZqOfFtau8GI4b4Wtd72DHNCQMV9DkiR0qAnPSJmSPzVHYq2knKrkLl1tGJMcBJfpQbDNJRXVcenETM1LtkOrqpNww2oJ3RUMdV8+O3ZT/jm7nwQXX1NUUQOKuh8ovHPZVvQhR+3NgMx2KfUqXYE7znN1Dt+oIvj4J0qp3LhWufLSN6zZowqa4KFIS322cROH38QT+ZSdPJZOzzglbg3RU2ubnt4A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 08:54:11PM -0700, Shakeel Butt wrote:
> 
> Hi YoungJun, sorry for the late response.
> 
> On Wed, Mar 04, 2026 at 04:27:37PM +0900, YoungJun Park wrote:
> [...]
> > > > - You already acknowledged the use-case for assigning
> > > >   different swap devices to different workloads. Your
> > > >   objection is specifically about hierarchical parent-child
> > > >   partitioning. If the interface enforced uniform policy
> > > >   within a subtree, would that be acceptable?
> > >
> > > Let's start with that or maybe comeup with concrete examples on how that would
> > > look like.
> > 
> > So, just to clarify, are you open to discussing this restricted direction?
> 
> I am open to all options. The only thing I am looking for is we have thought
> through the pros and cons of all the options and have thought about
> extensibility of the interface.
> 
> > 
> > To reiterate, this would mean enforcing a uniform policy for all children
> > within a memcg where the swap tier is configured.
> 
> Give me an example on how this would look like.
> 
> > 
> > For our use case, this is currently sufficient.
> > 
> > We deal with memcg's tree itself as one workload. 
> > This workload can use its specific swap device selectively.
> > This is my view.
> > 
> > Chris, would you be okay with proceeding in this direction as a starting point?
> > 
> > > Beside, give a bit more thought on potential future features e.g. demotion and
> > > reason about how you would incorporate those features.
> > 
> > Regarding demotion (assuming you refer to migration based on swap device
> > tiers), I don't foresee issues if we apply tiered swap devices per memcg.
> > 
> > In fact, the 'tier' concept was proposed specifically as an abstraction layer
> > to structure hierarchical swap devices. Since the current direction treats it
> > as a unified tier view configured by the parent memcg, features like demotion
> > should fit naturally.
> > 
> > Regarding future extensibility, I would like to add:
> > 
> > 1. From the memcg perspective:
> > Applying memcg in this restricted manner minimizes complexity. While future
> > expansions (such as complex tier inheritance rules or handling setting
> > differences between parent and child) will require careful discussion, the
> > restricted approach avoids immediate conflicts and side effects.
> > 
> > 2. The swap tier abstraction itself:
> > The introduction of swap tiers primarily enables swap device assignment.
> > However, this abstraction also opens the door for extended use cases such as
> > inter-tier migration (demotion), round-robin policies between tiers, tier-based
> > VMA swap, or even per-process swap controls in the future.
> 
> These are good examples. Just show how the proposed interface will be good for
> such features. No need to implement any such feature.

Thank you for the feedback. I understand your point.
I have already replied to the other comments as well. Since this
thread has become quite cluttered with various topics, I believe
it would be better to address this in the upcoming v5 patchset.

I will decide on the implementation and design based on our
discussions (including the ones with Chris). I will also provide
an explanation of the reasoning and future extensibility in the
v5 cover letter. It would be great to continue our discussion
and make a decision in the new v5 thread.

Best regards,
Youngjun Park

