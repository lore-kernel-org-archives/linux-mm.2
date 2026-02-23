Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 982BBE98DE9
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 05:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4B716B0088; Mon, 23 Feb 2026 00:56:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF94C6B0089; Mon, 23 Feb 2026 00:56:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DAFB6B008A; Mon, 23 Feb 2026 00:56:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 897D26B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 00:56:23 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 183BC8C51D
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 05:56:23 +0000 (UTC)
X-FDA: 84474661446.05.4EE10EB
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3AAC7A000B
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 05:56:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VbgOO0Zx;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771826181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wg/reOB9lmnxb3MajMFemuA+M9KAXqPdAYgEbnkNP+g=;
	b=TQtN1hl5JXou4PFC1+CaOSXCka8Ufek0MwY3flrIVoS34OVfAvhRcxOgEHFHHAniOeCk+u
	0AK3IxS2Zb/kmm0bZD0jsQzoDdlY8X6AE/aIUPPlkv0V/Tmp9H51YqKSbVvJlY491By8ia
	VgESkV0UOBhbzyqfWBRwaOkMRHfpU/A=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VbgOO0Zx;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771826181; a=rsa-sha256;
	cv=none;
	b=vzrJfwqUZuBHgDbOo8WjdtxXcM7ACkRQYFf+qSuBUfmZ+fYR1S500AgqJmf6ZRkW36t+uu
	xjd0c0oJGpaUiHrpZDJV26+ryr1J59AIr/kR1ERC9L5uL90O767kbGLQ8Jl8P7+xVPoduC
	bbQkUYsIfa8jpnrypcm7ZDquzP3h8a4=
Date: Sun, 22 Feb 2026 21:56:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771826179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wg/reOB9lmnxb3MajMFemuA+M9KAXqPdAYgEbnkNP+g=;
	b=VbgOO0Zxqi3zFmOCdbRindOPEm/VHizRDal87YA2S6GK8GSPgqhxa3Zhj7HAOfLl2zwrHb
	bT181v2h3lllWQx52AmZPd7XEGApFYDuKUGDTaDJn4Za6JZf8XTzIi6v8LvpBfRnVOuX0m
	z9K1cpJ5p8VykxA0+7gW9LZLuif0VLU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: YoungJun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, gunho.lee@lge.com, taejoon.song@lge.com, austin.kim@lge.com
Subject: Re: [RFC PATCH v2 0/5] mm/swap, memcg: Introduce swap tiers for
 cgroup based swap control
Message-ID: <aZvX0HZy1PDylL8A@linux.dev>
References: <20260126065242.1221862-1-youngjun.park@lge.com>
 <aY4bQFvpPRWgnOTM@linux.dev>
 <aY6hcPNxiolf5jj6@yjaykim-PowerEdge-T330>
 <aZjxP2sTavBRGC1l@linux.dev>
 <aZnBo+P3ifskts9J@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZnBo+P3ifskts9J@yjaykim-PowerEdge-T330>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 3AAC7A000B
X-Rspamd-Server: rspam02
X-Stat-Signature: 35xyj4gczr974komzghkpa9uxrzde5oz
X-HE-Tag: 1771826181-551247
X-HE-Meta: U2FsdGVkX18D3/7Lp0TSbpUeLsMHQ1eNm6alxeJISqlKvPDLiyrOVtiA4FFBlXpypn/so0dfKLgjAIbj7S/3+24Gr/rOskDTeb3RH8McITyjVN4y0srcO9JacEOMEsGmIT/f4MHE7aAbtUTVg8gmT3lMCRiWI9I2LzDhrRFGiTMzlzUooNuSq8+AfVDA/tTeC/L0sTijUOyy0UGs13fm7mi0iNtINAmC+E97PypabTqJMZuvmwoNaqdUuG0PW4Z40cp4HlMu9Z7heqbPPibOkbTE0YhNtm+UL2xQ6ujKbcLeH9DB9KdIlIldJ8/AoZ5akzshG8j2Cu0o5YNEvg5N+ZMWzhOu4UriwPBbZaQnyUrEklYPqOqg4QBnOKBNg95Apt3VZr9wqEqMiRUiXX/xEbWcoAKStIu+OKvMS9iV/zSM2QV2JyKpYE1jN4ICBOsKmAxLELpDBKLKdE/dZ3Bv+xXM0tVmfqEUfqasgUzprGUtJexo1oqC439oosq0PzKGIg+HuJwHQKTBwVXVxWjDMwl3AM5EqtzhDdmhF1cAfR20DVtXhtyF9JHHNrrVsFm7ZqFlfgr9Q1kP4OegAW0tW6nQwVAxtautYQFvEThamEmmyFbVeNImi8A7/X2SmJ3QlxrC/LU+xsGMW2LvJFKuoLg2Z81dKnckBX9OJWkm/pXr1VG4LYpWyRTKp3PPTtcyyG0uK80pXyxMuowls8MS5UtTi975RiVXETAQSqN6YLVCsGfpOrDLyltKRsynma9PqGUefn4BDT/7W99DuvKiJ71b7aM8EQrKRpYkVJ68dPsoM7yvHmetJ5BIkXU4Gl/F3LbaX8PlssheVJvPGziNrwqmMCkIrsmPY1ao1AzmfoDo0ZNPUQEIskdYWk1aeDF+Gs77SsVYjUpTuvYt9LoOVS4RxBh1nP4iUcoXzn3Uigov7I0L3tUJtQM2Vty7Yyg/C0TzZhcYMoNoCSAEgXn
 Wth5ifC8
 tbpHib86z4xBFMu39YpEJPY0vXOWoJjLSxNQRGIT4870qsRRxBsXIOcDVxn+nEEcJmfTnsWJi4/ZiPiWbko0XATBEmO98uvyn+bIPeVRNqawSOI+dndjVRghls58njeIvqvh/QEZz5e7Pc163bEej5z3VUYJXG2IJnnG1PP3C9/tPMnLyKmVi0Omp+uer/HbJcjnJ/O7L9yWMbA2M/W88an7y6g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi YoungJun,

I see you have sent a separate email on BPF specific questions to which I will
respond separately, here I will respond to other questions/comments.

On Sat, Feb 21, 2026 at 11:30:59PM +0900, YoungJun Park wrote:
> On Fri, Feb 20, 2026 at 07:47:22PM -0800, Shakeel Butt wrote:
[...]
> 
> > Taking a step back, can you describe your use-case a bit more and share
> > requirements?
> 
> Our use case is simple at now. 
> We have two swap devices with different performance
> characteristics and want to assign different swap devices to different
> workloads (cgroups).

If you don't mind, can you share a bit more about the cgroup hierarchy structure
of your deployment. Do you use cgroup v1 or v2 on your production environment?

> 
> For some background, when I initially proposed this, I suggested allowing
> per-cgroup swap device priorities so that it could also accommodate the
> broader scenarios you mentioned. However, since even our own use case
> does not require reversing swap priorities within a cgroup, we pivoted
> to the "swap tier" mechanism that Chris proposed.
> 
> > 1. If more than one device is assign to a workload, do you want to have
> >    some kind of ordering between them for the worklod or do you want option to
> >    have round robin kind of policy?
> 
> Both. If devices are in the same tier with the same priority, round robin.
> If they are in the same tier with different priorities, or in different
> tiers, ordering applies. The current tier structure should be able to
> satisfy either preference.

I assume this is the same swap priorities as of today, right? You want similar
priority behavior within a tier.

> 
> > 2. What's the reason to use 'tiers' in the name? Is it similar to memory tiers
> >    and you want promotion/demotion among the tiers?
> 
> This was originally Chris's idea. I think he explained the rationale
> well in his reply.
> 
> > 3. If a workload has multiple swap devices assigned, can you describe the
> >    scenario where such workloads need to partition/divide given devices to their
> >    sub-workloads?
> 
> One possible scenario is reducing lock contention by partitioning swap
> devices between parent and child cgroups.

The lock contention is orthogonal (and distraction here).

> 
> > Let's start with these questions. Please note that I want us to not just look at
> > the current use-case but brainstorm more future use-cases and then come up with
> > the solution which is more future proof.
> 
> We have clear production use cases from both us and Chris, and I also
> presented a deployment example in the cover letter.
> 
> I think it is hard to design concretely for future use cases at this
> point. When those needs become clearer, BPF with its flexibility
> would be a better fit then. I see BPF as a natural extension path
> rather than a starting point.
> 
> For now, guarding the memcg & tier behind a CONFIG option would
> let us move forward without committing to a stable interface, and
> we can always pivot to BPF later if needed

I think your use-case is very clear. Before committing to any options, I want us
to brainstorm all options and gather pros/cons and then make an informed
decision. Anyways I will respond to your other email (in a day or two).

Shakeel

