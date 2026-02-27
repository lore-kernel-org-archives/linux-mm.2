Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2110CFD9E2E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 02:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D7246B0005; Thu, 26 Feb 2026 21:43:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 698386B0088; Thu, 26 Feb 2026 21:43:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D8BE6B0089; Thu, 26 Feb 2026 21:43:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 44BCE6B0005
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:43:57 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 05A291A0477
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 02:43:57 +0000 (UTC)
X-FDA: 84488691714.03.58B1244
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf27.hostedemail.com (Postfix) with ESMTP id CFAF340004
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 02:43:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772160235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FAMAIeWbSFZ4UO1cSRazJCMaNBav9PXy9YWeYohK7SI=;
	b=G2Y8OyxCJOUe0CZmQlPTmBgMipcjec5vEHvmt7Uf8jKngTgy2iz2bHh8oDUl+RtUUIEO1N
	nMQSimS1iyhEKEWZvwqsxzdmqIGTz+hfbJPtc45dcO4LksIgTmi5AHUtqwFTiVlaUr6MHv
	9LUKRz1TkEmPexTc4IN7viKNJCqnRug=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772160235; a=rsa-sha256;
	cv=none;
	b=14yqJ9cDL/H/PNWQnhqqwm8i6qHWkjWH0KZuiINeUSKykidjTtpzGAdtvliBmoPu+osiXL
	RZw1ZXGPO6Uu7R22h0muBPNCi2V8lA61kwo+otWinx8cwd/nY6TGZBmCYDSH2JE5gxmCc0
	9+Lk11xW3VRIc0bvmd7n7S1VLTP6ilo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 27 Feb 2026 11:43:50 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Fri, 27 Feb 2026 11:43:50 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
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
Message-ID: <aaEE5kdAgcRcBheY@yjaykim-PowerEdge-T330>
References: <20260126065242.1221862-1-youngjun.park@lge.com>
 <aY4bQFvpPRWgnOTM@linux.dev>
 <aY6hcPNxiolf5jj6@yjaykim-PowerEdge-T330>
 <aZjxP2sTavBRGC1l@linux.dev>
 <aZnBo+P3ifskts9J@yjaykim-PowerEdge-T330>
 <aZvX0HZy1PDylL8A@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZvX0HZy1PDylL8A@linux.dev>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CFAF340004
X-Stat-Signature: pn98a5141kw3jsn9h7s7m9a1nae64bkk
X-Rspam-User: 
X-HE-Tag: 1772160233-6981
X-HE-Meta: U2FsdGVkX1+VQcCElYk+71D3Z6q+qtakYDqhjq6T6S/tGvo8Df/upycHbGRz9dFnhGi99bOrD5NV6zKCnjxEmdI2AViXZPSHRAbExDjhuMbz+EiEXVsyTg5k2VCO+L/9w5+0PY+2BTeTXW6le2gTbpaj6NenjoCKf8rqpoHO1s1NS7P0lJpVQB1k3d8F9+YpC1APhowvbAEi8BuEsPaCSPhLnYp7bmNYDPfnFYe/AieaU8gx61qDcMNejQfGaqLAGljNeaZRk7qijWVQpp6Qb4625QwonWyzOX2W3Lr022PyK+h4ei+qqOqAXVRoE4YrsBw2fMlNeZDhRlXenaSH9KooLXUGJihhQwAap2JkcfQO3po5kwo7GmvXMrcjxHZf8F1wKVPyeUnuC/um5trz6cgu+YCqwLkpCj4eonnUSny6BgLg5jVROYvHOlkgtdOHbxsHXgSLI1BepG62O9pDja7lPdqiGVWUP6LnEoqcViKEyakTLzeV742RDNpW+OahFOIZOHrhKlC155eBm4vnqA+fgyR0VgJQ+L8fkawIzCTFHZL5BNjcX64ZVCCe7boB/LJeHX69IEjkRzRmTpJA3pHTDJpJcFgR8K//3xfegq2azVW9Qn34xx1gbnlJGzhfDylOGC+byX54k8MMpNOFG1E6s8Y1qNK5BlqMC5qpkJqI3bGmnMNLXoAfI16Ffq5WEE2zlKKPMohGyNtNMDCbpFAHMYtSX+SMOMyO9ne3fKlnEDVAyH3K2PIrXRbi9i4/B81UeAX5p0gsDE5tAR6eyovz1c0R7EJbFG9TniiMzWlLpiBaMPRRsx3jsGwdYY10l3UnA2i0A4W5BcZspKksWF17OoJ3/pjone6/dB1CPpzNAVLrvP3/WEeIGqZ/lAPEOsZdLdaX0pNWXanWLf2q8DWUAdlLE69FutAnYgPYMEuLf3R5/U0Ut/EuE/1HkwolwrtZnF3AEg3LTw+eHPq
 1hUqLFX4
 H+0Wf2+8QvucK2P5ZWzSFVVx93L6oSYLOIbpuqKSmEqWyR+905TDP+tjth7vdcT+Cw8B3j0/Q6htftDtei84Mh5nqzbQTTLGhdMVMRQathlNgY+z2Uj/D3hwL44kn74lxmqI0WXbEL5sQa9e/zqyLK/JK2xe5+h7dTausJcLke8kStCN+8tjCQcVubcyUwi9RpGIzYig3ApMxu9E5cvb7LQl2eg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 22, 2026 at 09:56:13PM -0800, Shakeel Butt wrote:

While I await your response on the other thread, 
I thought I would answer these questions first :)

> Hi YoungJun,
> 
> I see you have sent a separate email on BPF specific questions to which I will
> respond separately, here I will respond to other questions/comments.
> 
> On Sat, Feb 21, 2026 at 11:30:59PM +0900, YoungJun Park wrote:
> > On Fri, Feb 20, 2026 at 07:47:22PM -0800, Shakeel Butt wrote:
> [...]
> > 
> > > Taking a step back, can you describe your use-case a bit more and share
> > > requirements?
> > 
> > Our use case is simple at now. 
> > We have two swap devices with different performance
> > characteristics and want to assign different swap devices to different
> > workloads (cgroups).
> 
> If you don't mind, can you share a bit more about the cgroup hierarchy structure
> of your deployment. Do you use cgroup v1 or v2 on your production environment?

We are primarily targeting Cgroup v2 at now.

> > >
> > For some background, when I initially proposed this, I suggested allowing
> > per-cgroup swap device priorities so that it could also accommodate the
> > broader scenarios you mentioned. However, since even our own use case
> > does not require reversing swap priorities within a cgroup, we pivoted
> > to the "swap tier" mechanism that Chris proposed.
> > 
> > > 1. If more than one device is assign to a workload, do you want to have
> > >    some kind of ordering between them for the worklod or do you want option to
> > >    have round robin kind of policy?
> > 
> > Both. If devices are in the same tier with the same priority, round robin.
> > If they are in the same tier with different priorities, or in different
> > tiers, ordering applies. The current tier structure should be able to
> > satisfy either preference.
> 
> I assume this is the same swap priorities as of today, right? You want similar
> priority behavior within a tier.

That is correct; the swap priority behavior remains unchanged. 

While this is slightly tangential, I see a potential use case for swap tiers to
improve the current swap device selection logic, which is currently tightly
coupled with priority.

> > > 2. What's the reason to use 'tiers' in the name? Is it similar to memory tiers
> > >    and you want promotion/demotion among the tiers?
> > 
> > This was originally Chris's idea. I think he explained the rationale
> > well in his reply.
> > 
> > > 3. If a workload has multiple swap devices assigned, can you describe the
> > >    scenario where such workloads need to partition/divide given devices to their
> > >    sub-workloads?
> > 
> > One possible scenario is reducing lock contention by partitioning swap
> > devices between parent and child cgroups.
> 
> The lock contention is orthogonal (and distraction here).

Understood. It was just a hypothetical scenario where I thought there might be
an additional benefit, but I agree we can set it aside for now.

> > 
> > > Let's start with these questions. Please note that I want us to not just look at
> > > the current use-case but brainstorm more future use-cases and then come up with
> > > the solution which is more future proof.
> > 
> > We have clear production use cases from both us and Chris, and I also
> > presented a deployment example in the cover letter.
> > 
> > I think it is hard to design concretely for future use cases at this
> > point. When those needs become clearer, BPF with its flexibility
> > would be a better fit then. I see BPF as a natural extension path
> > rather than a starting point.
> > 
> > For now, guarding the memcg & tier behind a CONFIG option would
> > let us move forward without committing to a stable interface, and
> > we can always pivot to BPF later if needed
> 
> I think your use-case is very clear. Before committing to any options, I want us
> to brainstorm all options and gather pros/cons and then make an informed

This relates to my response in the other email thread, and I think it would be
good to discuss it further there.

It seems the concern is that distributing swap devices using the memcg
hierarchy might be seen as over-engineering (overspec) since there isn't a
concrete use case for it yet. I have included a proposal to mitigate this
concern in the other thread.

> decision. Anyways I will respond to your other email (in a day or two).

Sounds good. I look forward to your explanation.

Best regards,
Youngjun Park

