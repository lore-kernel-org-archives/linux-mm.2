Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBBABC61DE9
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 14:31:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2D8A6B0005; Sat, 21 Feb 2026 09:31:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B1206B0089; Sat, 21 Feb 2026 09:31:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B3206B008A; Sat, 21 Feb 2026 09:31:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 77E636B0005
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 09:31:07 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 136CE1A049E
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 14:31:07 +0000 (UTC)
X-FDA: 84468700974.20.CDDF6C1
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf24.hostedemail.com (Postfix) with ESMTP id DADEE180008
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 14:31:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771684265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X5O4rKEr//tvJdzeHDSuIU/2efIbIXXZyKY7JzkzUqo=;
	b=7XP/lFKo388iHGxxiP+a8AGeyi1MwJrSA+fRAUM5vGBNWJMWsmTm5u+3Q+DYSmfT8PVsCd
	3eZJS8oME3OdPGDuvGQ6vrh1VnJOduSrBt8k7x1bcB4qVPfQjtcQ14c97r74Uz/WB5X0z8
	y7iiU7fKJONOZUucUufd7DQpVw4T7Ys=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771684265; a=rsa-sha256;
	cv=none;
	b=jCr1B0GCTwqDLwG8rSMPO0wM8qnuRiktafKbsSgizNqozB6xriG8xmACO0qZcrw9wdc6VY
	1qnyS++UL1dfXcFxbKca/nCi9YzRKTZ7SxiWbUD9D9JIxQMquZ6FVEYchMAWNsHxj33jiR
	z32hP0i8Q/Xady8gWLkqd/Xj6+Sv1po=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 21 Feb 2026 23:30:59 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sat, 21 Feb 2026 23:30:59 +0900
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
Message-ID: <aZnBo+P3ifskts9J@yjaykim-PowerEdge-T330>
References: <20260126065242.1221862-1-youngjun.park@lge.com>
 <aY4bQFvpPRWgnOTM@linux.dev>
 <aY6hcPNxiolf5jj6@yjaykim-PowerEdge-T330>
 <aZjxP2sTavBRGC1l@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZjxP2sTavBRGC1l@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: DADEE180008
X-Rspamd-Server: rspam02
X-Stat-Signature: gdqut89ekpjmohyawujjcxna4kr4p8zf
X-HE-Tag: 1771684263-396636
X-HE-Meta: U2FsdGVkX18lfgbNN2+Meg+gTb9SBSVkFqNpYQN0krnwg+F3CVGapR1thbyIuP8lwsjvqjX/2qughYvdzlywFwndaQAF7USkU7vfBpYvpp5MOu+KvqVc8yu9fUDgR7UGHf4adnxwg6DUkwgUMWV/nbE671nZ1ZKrnMb1/bbA7hY/oPG3QbxeIqSM0OuQN+yu/6pSP1pttrfAQaYs0cmUDccbAMxkd4MtpoJU1Ck5/X7kUroDMkNGVGpSWHIFQgOs77NIfwU3FNO+o+GxblPs217l0fXkSCguhDQHEU4Rr7g9Y1MD3hxhCdTgFvWHWGxWT31i0AhGR9CN1/KA4NpBVgYyzAjvJ0AwITziQh7x/bpWF/pAMpBwblKMOh00SzpZmtWjCpP6s1nx++mCcXV9Q4wT2SG4IrdorYerFFhnfAUjZb0PKtSRBpQvotqZvBlgT77IsG8ToJsQuyWkGmxS3e+HqQiovCifL/R2nNHb226M0wEokv3x/P4FC7imVDbUKaEweKHgHh8Pgx9uKvN8s7U0abX+F9vYLP6CkjqbRleH3i9FwsqH5wtn2vZKIuTk97v9aT1nKRapK5zNcNcyaYa8boQTvZJoPoOwWy01PrqY2Icdw0lQzHvDcVGRjbA6q+qBg0oazbRc6GTBx6QY3LgDFyGDrwVJX0bnvpBXU51txcDgbxBPjhzeyYHtieBpYn2n4dDlwamMCwbPA/bx5UARxr5NMfOVOZz295XCqoQmggSQcewDC9wDGG66blBNPyoV/8O4kN0M39iQ/1/LIIQdF4EYI1QHjLE8vOrJ4CmndtYrp9e8iye85aTjtvzfRVNhZb656M9m53SuUGRx+tLlT7ZiKy5DGodZ87ZnSXwOCR3XUfgxSKwSR455UINuiHP5qda/9jeZfiGIpDsW9aklEA4to33Eq6/KmlnweFpq37HiiWWtmkPR4e1wqwj8M4Tf0jr2X1yW9ae7EWM
 LbtuRLR3
 q1B3WbBlIJfj+05grSUGoG1XdybvCEjNWjn/hPpr0MdDLuH2TsZ6EpHwJYzHK3TA6wwcp03EPn30f0AsgsohZ9F3kzDR/ZIch9ZUtiIPwhRXY+T6rtvbSfdJuI1uDNI/4LkYRkwu0mH9dyO2QY8veILq0IuJgC7rxRBRC3ZLmXiN6rYhKIfN0NDQeVmvxKIDOIU9XBNxROK3Sig6frlUtOiAhmA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 07:47:22PM -0800, Shakeel Butt wrote:
> Please don't send a new version of the series before concluding the discussion
> on the previous one.

Understood. Let's continue the discussion. :D

Chris has already provided a thorough response, but I would like to
add my perspective as well.

> Yes it provides the flexibility but that is not the main reason I am pushing for
> it. The reason I want you to first try the BPF approach without introducing any
> stable interfaces. Show how swap tiers will be used and configured in production
> environment and then we can talk if a stable interface is needed.

I understand your concern about committing to a stable interface too
early. As Chris suggested, we could reduce this concern by guarding
the interface behind a build-time config option or marking it as
experimental, which I will also touch on further below.

On that note, if BPF were to become the primary control mechanism,
I am not sure a memcg interface would still be needed at all, since
BPF already provides a high degree of freedom. However, that level
of freedom is also what concerns me -- BPF-driven swap device
assignments could subtly conflict with memcg hierarchy semantics in
ways that are hard to predict or debug. A more constrained memcg-based
approach might actually be safer in that regard.

> I am still not convinced that swap tiers need to be controlled
> hierarchically and the non-root should be able to control it.

I think this concern is closely tied to your question #3 below about
concrete use cases for partitioning devices across sub-workloads.
I hope my answer there helps clarify this.

> Yes BPF provides more power but it is controlled by admin and admin can shoot
> their foot in multiple ways.

As I mentioned above, I think guarding the feature behind a build-time
config or runtime constraints could keep the usage well-defined and
predictable, while still being useful.

> Taking a step back, can you describe your use-case a bit more and share
> requirements?

Our use case is simple at now. 
We have two swap devices with different performance
characteristics and want to assign different swap devices to different
workloads (cgroups).

For some background, when I initially proposed this, I suggested allowing
per-cgroup swap device priorities so that it could also accommodate the
broader scenarios you mentioned. However, since even our own use case
does not require reversing swap priorities within a cgroup, we pivoted
to the "swap tier" mechanism that Chris proposed.

> 1. If more than one device is assign to a workload, do you want to have
>    some kind of ordering between them for the worklod or do you want option to
>    have round robin kind of policy?

Both. If devices are in the same tier with the same priority, round robin.
If they are in the same tier with different priorities, or in different
tiers, ordering applies. The current tier structure should be able to
satisfy either preference.

> 2. What's the reason to use 'tiers' in the name? Is it similar to memory tiers
>    and you want promotion/demotion among the tiers?

This was originally Chris's idea. I think he explained the rationale
well in his reply.

> 3. If a workload has multiple swap devices assigned, can you describe the
>    scenario where such workloads need to partition/divide given devices to their
>    sub-workloads?

One possible scenario is reducing lock contention by partitioning swap
devices between parent and child cgroups.

> Let's start with these questions. Please note that I want us to not just look at
> the current use-case but brainstorm more future use-cases and then come up with
> the solution which is more future proof.

We have clear production use cases from both us and Chris, and I also
presented a deployment example in the cover letter.

I think it is hard to design concretely for future use cases at this
point. When those needs become clearer, BPF with its flexibility
would be a better fit then. I see BPF as a natural extension path
rather than a starting point.

For now, guarding the memcg & tier behind a CONFIG option would
let us move forward without committing to a stable interface, and
we can always pivot to BPF later if needed

Thanks,
YoungJun Park

