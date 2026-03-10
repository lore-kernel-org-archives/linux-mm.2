Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C513FCC9AD
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 02:14:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F0876B0088; Mon,  9 Mar 2026 22:14:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49ED46B0089; Mon,  9 Mar 2026 22:14:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AADE6B008A; Mon,  9 Mar 2026 22:14:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 289386B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 22:14:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B4433B7A90
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 02:14:22 +0000 (UTC)
X-FDA: 84528533964.23.9824403
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf03.hostedemail.com (Postfix) with ESMTP id EFB162000A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 02:14:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf03.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773108860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lRP8KtKLZY+7i0jerrnd1mC7A31pWUzHmzcTMpaqCfk=;
	b=d2Q7Kjs7LvT1CCgkKoFbolYdHh/ws+kJBYwL6zGjuMn1oefDwcUhWJ5DNfJysY+e5NdSSe
	8tN60kADErSpmJac50m05L22acB0zthSFMi+VcgMHk3xweYnCdRdA4tgLKVUThqOe56nZW
	fsoRM6kEKiQWscG8W1zN7hI9a1r2w8Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf03.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773108860; a=rsa-sha256;
	cv=none;
	b=ziYP3yeGju9BZ5BXwPTCoq8Znq/nrkC2a/D8pFuu2be8QFHhDQ4gJT2IRO53QbUTF5Wyfm
	KRJRdUlvvN7nHPsTCEzQLIPLpdoP2p95STQDyLzsZoI6D//Tnc5kBjjktVW6wzyIKrC35u
	OTIvSVZKTF6tPou7pZ+ri+Rp6i9lWpM=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 10 Mar 2026 11:14:16 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 10 Mar 2026 11:14:16 +0900
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
	taejoon.song@lge.com, austin.kim@lge.com, hyungjun.cho@lge.com
Subject: Re: [RFC PATCH v2 0/5] mm/swap, memcg: Introduce swap tiers for
 cgroup based swap control
Message-ID: <aa9+eK/VEealbo8i@yjaykim-PowerEdge-T330>
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EFB162000A
X-Stat-Signature: jyn3xu6ibuswuhuoyny997f9ui58jpbq
X-Rspam-User: 
X-HE-Tag: 1773108859-514934
X-HE-Meta: U2FsdGVkX18P/hlQyf9yQEv0sv+k7htGAmpYEOxLJXwHN98ORabxVZacuFAFaB1u1rbMn3xbxnN/Hdu4v0B/p0CrRctBq44wuwAcutXW9lx4MzcCjNs3kQ6AmmrJIRqVWp84m6DZHB2SxCjGOM6XbHExccY2fdOMeLQa2CDt4zD79lsnXdisl7Z7tbGzucfa/VAwcR+P0MsBQGeg6vsqTl04R1WWy6unQqrdtHBFUHGUZtB/gYdy5beWKHuz0pBfm8GJDcVl/amvNjqmaSaYjRYo9h3uPFWOnhTdIt4UAJgKCrBepeqJmIUmhqp200NtjMyB4Pq1fsJQTag7Uym0r9WW/rSwNLxmss1oDVIQ7up6l5MEHNtwOnCFAdatRV9OYCds7H2AdNsZVZ4r8so1jTdfXSFA8yHYJ7zcnpGCAWpFjLpoHcPOLnTEgllIQjndhIGGrVqD2OxklTvamSh4PLDqFkftqCU7DTSDPojHFakDAdrjX4UPUFam80An1IKOewR5Yo5UwGlD2Wd9uXpo8JWGxSiqI4Vb3uKYl+kQ+ha0dXaBf/6ylCc35V6W6VHj7ftSIN7g2KkJdiYS3QpRh04pI1Ttu6OcFoeNPsFAXJjWFxIVmGRdwDGaqgxnSj5/JSU84AiKEqyr/IpUhAcKwizpDsXSrmE4k+GyiTMOB8BVNDOzD6gSs4D5iMUXqqOSOb0ANEeoG7uHOBjab5kg29/FQW8g8h7T7mIrv3gWLRtiIOWMGJ8McjsRsoFJcaDfmo+ZEq0iVMBxMdDDj18+9uiv2OT/sQgDZjkMLkrF4jUZ6KAiNa4QIQGl7PRX+rauSBNYheENjYlUhLtF7/BOwFA5QZVpEOT+sBkdAARGWdGF0Y31a6oDCdLfviXjYqn0e2pj7FW7B795xlyssyGTizArXO8LhnWHgUXsX88WyJNW6XI1m1+mY+P6HfcL+0o0x33gHhCO4FVTJeiM6Ot
 8ygRn3p2
 Jyjkcdz+RVf+3fK1ir5of/B9MVrqk5ePXWwR4tcXSxK5PuRp182On2+urb0HDPy72ZkoLef0Hcespb/hF5ohZNVzAQh4vaNqbfDvi43+Hr3S7vUftPYM/TWqovI0bRyXVglCyPcw3U189JFiOwLDvlXaRYBCVdUojoFlJLEa/QqiSv13TrGk6qK7ar82JIp0nJ6DtryrauNcWCDgor9YlaogIw8pwNAVjTfCm
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
> 
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
> 
> The use-case seems reasonable to me but I have concerns related to adding an
> interface to memory cgroups. Mainly I am not clear how hierarchical semantics on
> such interface would look like. In addition, I think it would be too rigid and
> will be very hard to evolve for future features. To me enabling this
> functionality through BPF would give much more flexibility and will be more
> future proof.
> 
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
> 
> > 
> > - You suggest starting with BPF and discussing a stable
> >   interface later. I am genuinely curious, are there actual
> >   precedents where a BPF prototype graduated into a stable
> >   kernel interface? 
> 
> After giving some thought, I think once we have BPF working, adding another
> interface for the same feature would not be an option. So, we have decide
> upfront which route to take.
> 
> > 
> > - You raised that stable interfaces are hard to remove. Would
> >   gating it behind a CONFIG option or marking it experimental
> >   be an acceptable compromise?
> 
> I think hiding behind CONFIG options do not really protect against the usage and
> the rule of no API breakage usually apply.
> 
> > 
> > - You already acknowledged the use-case for assigning
> >   different swap devices to different workloads. Your
> >   objection is specifically about hierarchical parent-child
> >   partitioning. If the interface enforced uniform policy
> >   within a subtree, would that be acceptable?
> 
> Let's start with that or maybe comeup with concrete examples on how that would
> look like.
> 
> Beside, give a bit more thought on potential future features e.g. demotion and
> reason about how you would incorporate those features.
Hello Shakeel, Chris Li,

Just sending a gentle ping on my previous reply. :D

To quickly summarize the main points:
(I might wrongly undestand your intentaion, then correct me please :) )

* Regarding Shakeel's BPF approach, stable interface movement would be difficult,
  so we need to choose a direction. I prefer adding it to memcg for immediate
  usage, and if it proves highly effective, we can consider transitioning
  entirely to BPF later.

* Shakeel seemed somewhat positive about matching all child tiers from the
  parent if tiers are applied to a specific cgroup use case, and I would like
  to start the discussion from here. Chris, I would appreciate your thoughts
  on whether you agree with this direction of unifying all swap tiers within
  the hierarchy as a first step.

Here are some additional thoughts I had after my last reply:
(Thanks for the insight and discussion. Hyungjun Cho)

* Cgroup distribution:
  A direct use case where cgroup A distributes a portion to A' is hard to
  imagine, but the following scenario is possible:

  swap: +SSD +HDD +NET
  cgroup hierarchy:
  /
  A : +HDD +NET
  A'(app 1) +HDD, A''(app 2) +NET

  Cgroup A has two interdependent apps, and +SSD is excluded for more critical
  services. App1 (A') avoids reclaim with a large hot working set using fast
  +HDD, while App2 (A'') has a cold working set using slow/large +NET.

* Promotion / Demotion:
  Unlike memory tiers, swap tiers are directly assigned by the user, providing
  flexibility beyond just speed. Since swap priority is already a user choice,
  this design makes perfect sense.

  With this arbitrary assignment, we can support higher-to-slower tier
  allocation, similar to current memory tiers, if user properly bind the tier.
  (more flexible as I think)

  Within the same tier (meaning we define it as equal speed(tier)), we could apply round-robin or other
  distribution policies via an additional tier layer interface. The current
  equal-priority round-robin policy could also be elevated to the tier layer.

Best regards,
Youngjun Park

