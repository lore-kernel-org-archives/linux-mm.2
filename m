Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86738CA0EF5
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 10:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 259F06B0110; Tue, 19 Aug 2025 06:13:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DD266B0112; Tue, 19 Aug 2025 06:13:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F2A16B0110; Tue, 19 Aug 2025 06:13:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EA5646B00A7
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:13:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7137ABAEDF
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:13:03 +0000 (UTC)
X-FDA: 83793093846.10.BA6BE65
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf21.hostedemail.com (Postfix) with ESMTP id A53491C0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:13:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf21.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755598381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3fRP2bet7qlmmxifYO+0+ay/5CDxOjn5iEHbNk/jdtA=;
	b=RKGeBDL/AI5F1MuBMxzTr0Ou8/LDZ301xdr2li4zCv4AaFkSgKbb0bcwjy6RMv+zhmzoqo
	UCVlPwwIlFHOZBxY7bwZ/su+9AI3a3sdbjKzi1AdaGV1zZ3B87nq/vVzdCJFkLSNupGmng
	V8pPZN1BvPYFqTw9OIKyMDjBCCSSA/o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755598381; a=rsa-sha256;
	cv=none;
	b=Tw6IjnaqQZwZGKaCEwT9lXq+M/E8HvpPxeODjRzhui3V7RFSHC5g7USYFkjXbVBp7KW0Yq
	R39aGTNgwIl1gcuwwdAavh+v9JSQFzHoiHL92YhwRpOOFt2IySVZ2ErTxsqFVj9wwuNCcK
	jZk3KwqAbN9CSSyBK+gjD7GIxI5c+Bk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf21.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 19 Aug 2025 19:12:57 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 19 Aug 2025 19:12:57 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Chris Li <chrisl@kernel.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, gunho.lee@lge.com,
	iamjoonsoo.kim@lge.com, taejoon.song@lge.com,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH 1/4] mm/swap, memcg: Introduce infrastructure for
 cgroup-based swap priority
Message-ID: <aKROKZ9+z2oGUJ7K@yjaykim-PowerEdge-T330>
References: <20250716202006.3640584-1-youngjun.park@lge.com>
 <20250716202006.3640584-2-youngjun.park@lge.com>
 <jrkh2jy2pkoxgsxgsstpmijyhbzzyige6ubltvmvwl6fwkp3s7@kzc24pj2tcko>
 <aH+apAbBCmkMGPlO@yjaykim-PowerEdge-T330>
 <aH/baxIgrBI3Z1Hl@yjaykim-PowerEdge-T330>
 <uyxkdmnmvjipxuf7gagu2okw7afvzlclomfmc6wb6tygc3mhv6@736m7xs6gn5q>
 <CAF8kJuMo3yNKOZL9n5UkHx_O5cTZts287HOnQOu=KqQcnbrMdg@mail.gmail.com>
 <aKC+EU3I/qm6TcjG@yjaykim-PowerEdge-T330>
 <CAF8kJuNuNuxxTbtkCb3Opsjfy-or7E+0AwPDi7L-EgqoraQ3Qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF8kJuNuNuxxTbtkCb3Opsjfy-or7E+0AwPDi7L-EgqoraQ3Qg@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A53491C0002
X-Stat-Signature: gcabgibi5cptgg3fnrp53m7dncaatpzw
X-HE-Tag: 1755598380-596819
X-HE-Meta: U2FsdGVkX1+HKsSDmUISnpjRsY3alnlCthsE2rQdcNXgXsO7hbnl18DIdfUOphk+rd1cMvSS0myDJOjZ9JLES7NWQDLv0oc7PUxUxHVvd2y34iXL2zMAUxSQNRTX0Mso5Kh3pccf793xzYIWFPWtovasVLRzHbw412ET6vMu7Nr+xxFnYGLpklCYXN/YBusI9S5ktehZGE3amyGsyr7qKVe6Q8wljWECQgO11wwH7eXilWT0dSuJvs6Wqks1f2wVWkS0OG6S9xjI6X2cUajdIvykLI+u7tcZcm+9bY0sN3WzKEJT7/ciAdCQ3kzBEItj//3P0a14p5XY/o2KK3a371pxQPIvaDh1Bycl71kIGtJudmHoYR/tfeO0IO2xLEV7s9rNv3cuJqTPkdW71pClge6hdp5VSp0hVprzGlncNHPeOwEyVMobPHkajLWzsuAD4+6DC6PdNRS+bcem9oiv6GqG8SxVXzeRu3+EA1ysdjQcdCoah22e0/K0oDFGkF7E0oS17bjK90UgI4SIDixT21jFobCL9N3ZxQ9ZKOOK8WFzlt6RFLGqjnE0gdv8s3U+Y0HqA5cB/JVy+y4sA3nNChxVpKLGTTcNZkGgygmz9wUthId+fZ/i5tCUdSH3FBbxj2gg1PamMEUOz6EyWM6Q3ddKTDwY4l3RhFrN8tnA6qkLgbHrxewnSy5mNow3pnbKJtoMStZEPRjb3ktDctBO5dSls9Yz8tx98FW6n7YUIEc5lqZn1/svbvGjv5+gmuTL/mhV3OuxYOVzkDMuMRBV8ed56R4v5gTucOpmHK1QzboY0nXeQYDk8exv2KPnBs1hZPZahXrp2kmnRDnONtFvj7+0p8Jh8RT8NwLk288HBOnoA4jtRIuxx4J1YPAandhxOULyVRsaOBvM4mIODMdDrs27/Z0d9ZcRvUtlmz/jE3aJRlPaYDZDEdGP1XIwOCDswMIQrzETdgaaPhTuA/0
 LjaqK6aT
 ze/tJJnEZeCixRPNQRvP+pJBAGo4USmJJiemTuEhM2xEqY+vHnsAtPs1e9dRvvBnrLjUeJMB8yGiuiPzm7c8fzlhtCDtAAxpN+/TPzsPqKPNdMmJ0QtB1UDJiEsLUEfm2Dr3M7cXs4hYXLqQ5zBWC4NDUsAhXP4GjFEXgkTkqnWrAOwqVxCrHsD27A7mXf6bSjFgwky1sFvHDH8NW1UqGe5LvHhUaQVOUmFw4caeoDzTHQodpsxX2F+o5Oi1LD/J/ph/cjTehkgRZcDwr3tvQLVrwFxJFyin31P6IQJI94Bz4YMJ+j9jpReg3+6x4Pt7/ZwBl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 16, 2025 at 12:15:43PM -0700, Chris Li wrote:

At first, Thank you for detailed and fast feedback!

> I have not questioned the approach you can achieve with your goal. The
> real question is, is this the best approach to consider to merge into

Yes, I believe this could be the best approach.
I have compared several possible approaches before making this proposal. These
are the alternatives I reviewed in the RFC:
(https://lore.kernel.org/linux-mm/20250612103743.3385842-1-youngjun.park@lge.com/)
The part I mentions are as belows

> Evaluated Alternatives
> ======================
> 1. **Per-cgroup dedicated swap devices**
>    - Previously proposed upstream [1]
>    - Challenges in managing global vs per-cgroup swap state
>    - Difficult to integrate with existing memory.limit / swap.max semantics
> 2. **Multi-backend swap device with cgroup-aware routing**
>    - Considered sort of layering violation (block device cgroup awareness)
>    - Swap devices are commonly meant to be physical block devices.
>    - Similar idea mentioned in [2]
> 3. **Per-cgroup swap device enable/disable with swap usage contorl**
>    - Expand swap.max with zswap.writeback usage
>    - Discussed in context of zswap writeback [3]
>    - Cannot express arbitrary priority orderings
>      (e.g. swap priority A-B-C on cgroup C-A-B impossible)
>    - Less flexible than per-device priority approach
> 4. **Per-namespace swap priority configuration**
>    - In short, make swap namespace for swap device priority
>    - Overly complex for our use case
>    - Cgroups are the natural scope for this mechanism

In my view, the `swap.tier` proposal aligns quite well with alternative (3) that
I reviewed. That approach keeps the global priority assignment while adding
inclusion/exclusion semantics at the cgroup level. The reason I decided not to
go with it is because it lacks flexibility — it cannot express arbitrary
ordering. As noted above, it is impossible to represent arbitrary orderings,
which is why I chose a per-device priority strategy instead.

> the main line Linux kernel. Merging into the main line kernel has a
> very high bar. How is it compared to other alternative approaches in
> terms of technical merit and complexity trade offs.

Since you seem most concerned about complexity, I have been thinking more about
this point.

1. **Conceptual complexity**  
   The idea is simply to add a swap priority list per cgroup. This is
   straightforward to understand. The more complicated part is NUMA priority
   handling — but if that turns out to be too complex, we can drop it entirely
   or adjust its semantics to reduce the complexity.

2. **Implementation complexity**  
   Could you clarify from which perspective you see implementation complexity as
   problematic? I would like to know more specifically what part worries you.

The `swap.tier` concept also requires mapping priorities to tiers, creating
per-cgroup tier objects, and so forth. That means a number of supporting
structures are needed as well. While I agree it is conceptually well-defined,
I don’t necessarily find it simpler than the per-device priority model.

> Why would I trade a cleaner less complex approach for a more complex
> approach with technical deficiency not able to address (inverting swap
> entry LRU ordering)?

Could you elaborate on what exactly you mean by “inverting swap entry LRU order”?
Do you mean that because of per-cgroup priority differences, entries on the
global swap LRU list could become inconsistent when viewed from different
cgroups? If that is the case, could you explain more concretely what problems
such inconsistencies would cause? That would help me understand the concern
better.

> Let me clarify. LPC is not required to get your series merged. Giving
> a talk in LPC usually is an honor. It does not guarantee your series
> gets merged either. It certainly helps your idea get more exposure and
> discussion. You might be able to meet some maintainers in person. For
> me, it is nice to meet the person to whom I have been communicating by
> email. I was making the suggestion because it can be a good topic for
> LPC, and just in case you might enjoy LPC. It is totally for your
> benefit. Up to your decision, please don't make it a burden. It is
> not.
>
> If after your consideration, you do want to submit a proposal in LPC,
> you need to hurry though. The deadline is closing soon.

I see, thank you for the suggestion. I also think having the chance to discuss
this at LPC would be very beneficial for me. I will not see it as a burden —
if I decide to go forward, I will let you know right away (until this week).

> From the swap file point of view, when it needs to flush some data to
> the lower tiers, it is very hard if possible for swap file to maintain
> per cgroup LRU order within a swap file.

Could you explain in more detail why the flush operation is difficult in that
case? I would like to understand what the concrete difficulty is.

> It is much easier if all the swap entries in a swap file are in the
> same LRU order tier.

This is related to the same question above — I would appreciate a more
detailed explanation because it is not yet clear to me. Why is it easy?

> The swap.tiers idea is not a compromise, it is a straight win. Can you
> describe what per cgroup per swap file can do while swap.tiers can
> not?

I mentioned already on this mail: what swap tiers cannot do is arbitrary
ordering. If ordering is fixed globally by tiers, some workloads that want to
consume slower swap devices first (and reserve faster devices as a safety
backend to minimize swap failures) cannot be expressed. This kind of policy
requires arbitrary ordering flexibility, which is possible with per-device
priorities but not with fixed tiers.

And vswap possible usage: if we must consider vswap (assume we can select it
like an individual swap device), where should it be mapped in the tier model?
(see https://lore.kernel.org/linux-mm/CAMgjq7BA_2-5iCvS-vp9ZEoG=1DwHWYuVZOuH8DWH9wzdoC00g@mail.gmail.com/) 
In my opinion, it cannot be mapped purely by service speed. 
There are indeed situations where tiering by service speed is beneficial, 
but I also believe priority-based ordering can capture the same intention 
while also covering exceptional use cases.

So, I see the per-device priority approach as more general: it can represent
tier-based usage, but also more flexible policies that tiers alone cannot cover.

> It obviously will introduce new complexity. I want to understand the
> reason to justify the additional complexity before I consider such an
> approach.

I think that any new concept adds complexity, whether it is “swap.tier” or
per-device priority. If you could clarify more precisely what kind of
complexity you are most concerned about, I would be happy to give my detailed
thoughts in that direction.

Thank you again for your prompt and thoughtful feedback :). I will continue
thinking about this further while awaiting your reply.

Best regards,
Youngjun Park

