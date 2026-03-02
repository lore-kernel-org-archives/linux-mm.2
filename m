Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 022F0EA4E04
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 14:50:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D8CC6B0089; Mon,  2 Mar 2026 09:50:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 286726B008A; Mon,  2 Mar 2026 09:50:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 185D46B008C; Mon,  2 Mar 2026 09:50:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06DC66B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:50:16 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ABE851393EA
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:50:15 +0000 (UTC)
X-FDA: 84501408390.06.FDD7A0A
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf03.hostedemail.com (Postfix) with ESMTP id 70A7720004
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:50:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772463014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xLXB3v+imwMj0xz3Yh7HjqeoxQjjUWV0nkCC95fZrW8=;
	b=GP+t4am/dGIfA/7CTixY3gSDElyO3ZpA85uDKVnqTjxMtMrq0nvE9ItNLGfs1S1KBWd6PC
	txGwC9LbHSabKENZVgaBqSGcfB5vnh5ebQu8tDcgdcVDHyZRoTy7klywQqbJWJz6D4RYum
	N81G9WzdFyEVUiWdelp4ru0Jf+XHLws=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772463014; a=rsa-sha256;
	cv=none;
	b=LUipUHIkNLyWIDZRJGEd5vtLGjl+LwE/Iby4HscwM3ee4g8lG6/ZwtBrMlEKYq0Hm3ZlK2
	yulcuFpFKFoOU2tHsjBisb+LhFHrHRFVa5SiSJrXInC/DQAKWsYGEl0NkGKdnAHaeOUw9w
	eFM2tqpbJL59DEaaaTDo2EMjcGvF0AU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 2 Mar 2026 23:50:09 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Mon, 2 Mar 2026 23:50:09 +0900
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
Message-ID: <aaWjofvnbt0snt8r@yjaykim-PowerEdge-T330>
References: <20260126065242.1221862-1-youngjun.park@lge.com>
 <aY4bQFvpPRWgnOTM@linux.dev>
 <aY6hcPNxiolf5jj6@yjaykim-PowerEdge-T330>
 <aZjxP2sTavBRGC1l@linux.dev>
 <aZnBo+P3ifskts9J@yjaykim-PowerEdge-T330>
 <aZvX0HZy1PDylL8A@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aZvX0HZy1PDylL8A@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 70A7720004
X-Stat-Signature: iqum9rfy4yrb1zt8mg1auqy81i4sbcfu
X-HE-Tag: 1772463012-484436
X-HE-Meta: U2FsdGVkX19UW5ZnC0vdZgus/i+D2xcL4AihgKI0ePeKwAqvnguqCdBLUHcXRmesL+taxPvS8o9KCJbRzaFbj0MSI/iA2AKVWyt7sknObzejXQhS70SaPReqWyJZzFMYBqYnSniNdPK264ZV4i/ua/U2+tDjd42SuUvAEegrfyyb/ex/X8ahBS1ibc+iEBaivfHtAJjDDZLaBp203qIlYht4Q+VVoOVesoO8/VyYwcjoCsqUcrMXde4G764DHPU+Pl/EzkJQ5MvcpT3JIrk20WXxaDIy+gwvvpiCcnOfkLC13TGfWN2ggSOmYjpaK3E3l4eExy/8si48VdAkKnn6E8SSj8++IdKvfbFx2keCZkWeeLVX1ubOTsi7M3Mtwz6gs9IPPk9GTEVlrBW/cmzgxbYrY0jxO3UYYhWuSQeHHq7wBZCNmmxCizTGYYPFaI27B8Lm2hw4XkB8q9A+b9plwEco9IJymkJ9g7zbAovFGY0lnF2L7I82+ozI9pQSMhS2E30StynkF6AxH8tQTOqe1KsO4cLfM6iEzuxF9MLk2iIr3fod2pqy4CGK4zdXVdvOPbG6WmdmAFlkoFwdI5Wxzr12Jj80cb3yXrtpozIAXaKX7mqxFtCiAHFkQdJ+yFFg2I1ouooMfBvnu2Q9wYeu6IEtyDrhMsAlH3erQnuCqbp4cPv8Dh9K3cPF+bF1yUs+7dxM33Pr7l1E0Sq+vchcwVQUQiGwE8kJj/NBemAaHrYzDKZ72ok5s1+mGrMPkhauIIk3JeVVp4wYpqLOnOr4YvUcf3zrjMUKV7Tj1qcdSWTXCHrQExy7ILA0z0r9+ANgNq9Dxxqjw0Gj9G5qlYS5vIuUPeWpkG8amVt4P7O75KT6rZQqOEvd6H1HP4otmrBUeVT3sPjgcUkxJOIoRdV1HZlpJL9xmteWTs078+1xDTpUcwCs5XxuwNS3O0NWM+D3ucOkGJYCa80P6wXpAr2
 mkSzFGI5
 Rmx0UT4O6QX/BKX5tXpw6Uxl891vTzNCYdsXhr+RrO9deGFO3qTxotgtyknPC9o4QpJ+aLd4LDCmlavt8sN3sY3+O7i31je4b8S2BaxVA+LOSArHGLxJvYizGbMl+mS1G/nL9ByfVlzisJmZ2hRFe/spU5Mxjoh6beW8zXTL40h2H5vfGa5ZXLpeMsN0HLRJwscFzNrGXphNQggtPR1MRq0PWRRiGOE6ppx555HuZGHxqeSdtZk9OhCT01Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 22, 2026 at 09:56:13PM -0800, Shakeel Butt wrote:
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
> 
> > 
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
> 
> > 
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
> 
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
> decision. Anyways I will respond to your other email (in a day or two).
> 
> Shakeel

Hi Shakeel,

Just a friendly ping on this thread :D. I understand you must be
busy, so no rush at all.

I'm quite eager to move forward on this — even if it starts
under an experimental CONFIG option, that would be perfectly
fine from our side. We'd love to iterate on it incrementally.

Best regards,
Youngjun Park

