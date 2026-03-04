Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B101E67A8A
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 07:27:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58AB16B0088; Wed,  4 Mar 2026 02:27:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 538846B0089; Wed,  4 Mar 2026 02:27:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4373E6B008A; Wed,  4 Mar 2026 02:27:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 31C866B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 02:27:45 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3E36B992C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 07:27:44 +0000 (UTC)
X-FDA: 84507550848.07.61952C1
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf14.hostedemail.com (Postfix) with ESMTP id 90B3D100007
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 07:27:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772609263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KGFM5BTJCfl+Ul1B46GbGtvY8G2G06Il5cZxkkSIjrY=;
	b=cHYe8wvhaSZdxAF0zUcMb+8PEmPZjjqtwBnRsRGM6UC/AxjJYWNhpxo36cayL3awHYQxmI
	GwVsEGrVDzkEdWwK40yqpWKa8trOwEu25xVO7PifQIk+dDHbb2BR0dkhcrOKOdBemNp6X3
	B9LKmWMT9f2kmV9/2q2ThYukNdwLtw4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772609263; a=rsa-sha256;
	cv=none;
	b=bYJ7PXJMPRmlYWqCL2S2upwjoMTRiPXYZ+DV8RLOknl1s9ldk0OL50Z8AY9qpkn/jbs92V
	Fpee/Tk31yuiemUQjWbeTNwzggA0P1Yc47groHAkReEmfTM2OMIpbpJ0n24i8ULFnvaINn
	Dz4gb+c0sLYlaAMwqdFfmYM7YYIgM4Y=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 4 Mar 2026 16:27:37 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Wed, 4 Mar 2026 16:27:37 +0900
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
Message-ID: <aafe6VXoCLlajp8b@yjaykim-PowerEdge-T330>
References: <20260126065242.1221862-1-youngjun.park@lge.com>
 <aY4bQFvpPRWgnOTM@linux.dev>
 <aY6hcPNxiolf5jj6@yjaykim-PowerEdge-T330>
 <aZjxP2sTavBRGC1l@linux.dev>
 <CACePvbU=4f4gT5kHUBq0wD7COHN+quE5g4bPQqJYgJNx_9vuhg@mail.gmail.com>
 <20260221163043.GA35350@shakeel.butt@linux.dev>
 <aZpY1FIjYLtLdu5F@yjaykim-PowerEdge-T330>
 <aaXM58EsMtbGri2B@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaXM58EsMtbGri2B@linux.dev>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 90B3D100007
X-Stat-Signature: 5qykstyxyt1eyeqi8kdzhjj8jqfcwqih
X-Rspam-User: 
X-HE-Tag: 1772609261-161345
X-HE-Meta: U2FsdGVkX19PVFXzHpEGVyydYwzzoVq1cWXtFI+2KyX7JwDYlMvFsTa/VoTEcQt4aezMRUNhwo7NJxDAfIV1zqJAeXWNiZoDg4CPmSjdCPWiKxXvYwpoaD8kXPZJly3k7nqQKamasQ3NdaZ+/8MeF99/ovhzYCe6ihsh0LwWw0IfAB9qqkrRqqA8E+N2p86Aezbmh5xtztl+xz+GiizsRB8yTpw8na+bWMitwD9utR5nfrtTIZvWDEdZdeE5iOo0D1PCYu+ttRL/JatjWVwLVe0aW+hKvFhujgiuH2W17Izx/nfL1RAJ6VNNDm5ngEINww/a44Z6DUNefLgIRhUGXOr7arKmVScVT7bLYXZogL4iexRFcUw7a5Zdy4l6biKBNXO75WXHhZ5HHC9acDoeHN6VV4xx2AwQhqWE7HdppXEwQrYHKiBbnrI2KBumUl3mEJrFS5iTR67lCAhnxi/+kvqpbV7w3VEqLJlj0evmseE/odEHizTeXaFBjBEdo2aCyXNgVM169IvhX+CTUuTSAnHlebN550TL2chzcJYAtDUdDGmi60ZfVdxy7ucYPSUH51Fqyhdp2MV9Tli3gBK5MlCvELdt96wsWCtVfYK1N+gc77quHUUGMBOvQuFBghBHD/RW2FenlKxwGxK6MVlOVq/+6OR/On2IdMM94ub91AN1KnfvRaSdWa1wtSlBoYOdr+U5lKUYcLK8LhDmyeIdxRXpC/W0en1QzltZD7JVJDA6oTzfsE/9sMd0HkVjiFfWPCH1DGw+yJ3fS3hVKo4uqoyCvGmqRafVkPZHqwsWIi68F85EgxRnAFdd9E9/5Ey0u+S4DXxQWnhRwvqpCbbCY49s52Fn8FCWBaAAA0rHbgFTquByw/Q462L6AlGaiavX+b2gCsW9oTmmOkjnXaiNoG7CNPjsTIAGVfwsTScklSh69p3xlD+6dnTzVc4crNJ2P5gCW+2rfn/aZpM87RI
 c3cq9cHq
 khy4tIH6h8EvTYeYXqmcIQz+3VJudI5j4z4XIfE5Y0UMY6Z9QQ9lfikZLkCi0USUnTpvuJFYBxoSYk2CKyzyBf2BNg0p3Uohg+If6lY/r9AZKNzPc+nQiRmFzq/fRs5FwA5iADWjUeny6qjqOqHIgnTxmtZCXPOQTxIDP2WP8NO5R2fXlPhNLKdNUSJcF9BdSxuCwFyrQPgHbdpdJ/Z8vwUwNOrMegftJy8rvVnemd8rgCX0o8i3Tuk67/q0PeCqpgZCJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 01:27:31PM -0800, Shakeel Butt wrote:
>
> Hi YoungJun,
>
> Sorry for the late response.

Hi Shakeel, No problem :)

> On Sun, Feb 22, 2026 at 10:16:04AM +0900, YoungJun Park wrote:
> [...]
>
> Let me summarize our discussion first:
>
> You have a use-case where they have systems running multiple workloads and
> have multiple swap devices. Those swap devices have different performance
> capabilities and they want to restrict/assign swap devices to the workloads. For
> example assigning a low latency SSD swap device to latency sensitive workload
> and slow disk swap to latency tolerant workload. (please correct me if
> I misunderstood something).

Thanks for the summary! Yes, that describes our use case accurately.

> The use-case seems reasonable to me but I have concerns related to adding an
> interface to memory cgroups. Mainly I am not clear how hierarchical semantics on
> such interface would look like. In addition, I think it would be too rigid and
> will be very hard to evolve for future features. To me enabling this
> functionality through BPF would give much more flexibility and will be more
> future proof.

> >
> > After reading the reply and re-think more of it.
> >
> > I have a few questions regarding the BPF-first approach you
> > suggested, if you don't mind. Some of them I am re-asking
> > because I feel they have not been clearly addressed yet.
> >
> > - We are in an embedded environment where enabling additional
> >   kernel compile options is costly. BPF is disabled by
> >   default in some of our production configurations. From a
> >   trade-off perspective, does it make sense to enable BPF
> >   just for swap device control?
>
> To me, it is reasonable to enable BPF for environment running multiple
> workloads and having multiple swap devices.

I agree with the value and flexibility of BPF, but there is still some debate
on whether it should be the mandatory prerequisite for this feature.

While I understand your point that BPF is reasonable for complex environments,
requiring BPF solely for this feature in resource-constrained embedded systems
(where it might be disabled by default) is a significant hurdle. This trade-off
is a key reason why I am advocating for the memcg interface.

> >
> > - You suggest starting with BPF and discussing a stable
> >   interface later. I am genuinely curious, are there actual
> >   precedents where a BPF prototype graduated into a stable
> >   kernel interface?
>
> After giving some thought, I think once we have BPF working, adding another
> interface for the same feature would not be an option. So, we have decide
> upfront which route to take.

Yes, effectively, if BPF is applied, it opens up the possibility to control
swap logic at various levels (process unit, cgroup unit, etc.), so it would
likely become a superset of other mechanisms.

However, despite BPF's benefits, I would like to propose proceeding with a more
restricted memcg approach, which I will detail below.

> >
> > - You raised that stable interfaces are hard to remove. Would
> >   gating it behind a CONFIG option or marking it experimental
> >   be an acceptable compromise?
> I think hiding behind CONFIG options do not really protect against the usage and
> the rule of no API breakage usually apply.

Understood. My suggestion regarding the CONFIG option was to mark it as
'experimental' to allow usage for specific cases like ours while reserving
broader API stabilization for later, but I accept your point about API breakage
rules.

> > - You already acknowledged the use-case for assigning
> >   different swap devices to different workloads. Your
> >   objection is specifically about hierarchical parent-child
> >   partitioning. If the interface enforced uniform policy
> >   within a subtree, would that be acceptable?
>
> Let's start with that or maybe comeup with concrete examples on how that would
> look like.

So, just to clarify, are you open to discussing this restricted direction?

To reiterate, this would mean enforcing a uniform policy for all children
within a memcg where the swap tier is configured.

For our use case, this is currently sufficient.

We deal with memcg's tree itself as one workload. 
This workload can use its specific swap device selectively.
This is my view.

Chris, would you be okay with proceeding in this direction as a starting point?

> Beside, give a bit more thought on potential future features e.g. demotion and
> reason about how you would incorporate those features.

Regarding demotion (assuming you refer to migration based on swap device
tiers), I don't foresee issues if we apply tiered swap devices per memcg.

In fact, the 'tier' concept was proposed specifically as an abstraction layer
to structure hierarchical swap devices. Since the current direction treats it
as a unified tier view configured by the parent memcg, features like demotion
should fit naturally.

Regarding future extensibility, I would like to add:

1. From the memcg perspective:
Applying memcg in this restricted manner minimizes complexity. While future
expansions (such as complex tier inheritance rules or handling setting
differences between parent and child) will require careful discussion, the
restricted approach avoids immediate conflicts and side effects.

2. The swap tier abstraction itself:
The introduction of swap tiers primarily enables swap device assignment.
However, this abstraction also opens the door for extended use cases such as
inter-tier migration (demotion), round-robin policies between tiers, tier-based
VMA swap, or even per-process swap controls in the future.

I believe this patch set is acceptable as it introduces this foundational
concept and applies a specific use case that does not contradict core memcg
principles.

Best regards,
Youngjun Park

