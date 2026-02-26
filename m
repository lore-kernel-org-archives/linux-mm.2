Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71D80FD8FE4
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 17:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D226C6B00CB; Thu, 26 Feb 2026 12:56:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEC2F6B00D3; Thu, 26 Feb 2026 12:56:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C18F86B0191; Thu, 26 Feb 2026 12:56:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8B006B00CB
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:56:50 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 741481601A3
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:56:50 +0000 (UTC)
X-FDA: 84487363380.03.088240A
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf29.hostedemail.com (Postfix) with ESMTP id A49BB120010
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:56:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="IbUj/59b";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772128608; a=rsa-sha256;
	cv=none;
	b=G3yW/QSHRE/mbKXvKxW+AqcxPgate6ok/1OY+wu7lZxdlLKEPgYh4WO8ydrWUEx09LHbbR
	agfKR9CHLrv0zlLG9dMMidNfRQj0JnmB3BCz4DEybeQaWXNweENTJq4GOUw/UznZsiO8Ke
	CqhsMQs1ZQOyxJkjIUr+LwWAvVzF5ic=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="IbUj/59b";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772128608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u9YpbVK1L35uP8WZppOKKGwEMIRFy1q54VTAL1bze0I=;
	b=12CgHjtRdKw6BzkW3bgMT72OUWkA0BE/c6i/WlZwsJ4zjm/XRo2kgXEz8RWTSfuxaRNRie
	G7wTvcPEuQM689Ie5M453sFXKEArdWTZOtbFtD8vnfgBLkJxqNdtkGJ5zhLqU8c6CVYyRX
	rIoYOjVlL/fFffF5DHrfEM67+R2FMRU=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-896f82e5961so16653766d6.0
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:56:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772128608; x=1772733408; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u9YpbVK1L35uP8WZppOKKGwEMIRFy1q54VTAL1bze0I=;
        b=IbUj/59bLYmR7JDvpwch1fIZi8fR/dkBPWcMMaYyXOFJanCZqenEdeRgaGzYX/16o8
         BZEYOk7oW3JQfEWbT1O5B1acE05dG0PJEStxy0k5CyjgGPC4685c6RNlzMLm71Yh5N8Q
         XLVf0DBTRo7xICT6NkLPUp0BE4xFyV2Eb5EfaxEccCq5e7jOA4J0qCtGLcMPxqLCVXG8
         KQP/b1mHRvMxhNGlImkFbsJOsHpcmwgQ9PYPai6GgdGWgkKGP7c7v5FvHNc2RFxBPIf9
         HZ2BuBtvglV6LreO+wqPXi/jq1PLb+4yT6XhXSAoDHg72RDL/R5swQHvQ9lShTg23Vo6
         cB1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772128608; x=1772733408;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=u9YpbVK1L35uP8WZppOKKGwEMIRFy1q54VTAL1bze0I=;
        b=baFkB3h9o99prZ6Y27of1RZe8m4X1l1j7vO2NELmTWdxGmT+yQoQ5jbREd4nlPMPiA
         wDjWJqjv70dOVYxB2eU2GGr2jiZHkZFX4UZgd0TlFT5RJz3vjT/F0VzJn+JkfHTtQSJ8
         rQWVOueRB+c2ah5AlM3bbnFS7m6B528AYOdmjIUnE4fFZZQLZZ+aePYMntNXAkOWVp2O
         O2U4iucqPyyzmHOMyFfWak1JWO2/eK/vsTJCs37FoUB8sMZAk6cOfGuLpMek8pffxiSz
         zuHOaQ+x0Soqm0orWtbY9jRpvy6yfCDGzrmRP7w4IrEIAjrkZSnq16UF0hMYbdE3DuuQ
         snmw==
X-Forwarded-Encrypted: i=1; AJvYcCXP83rpdF70VkFnVrdPPjhFTQfF9P3/wRyq54PWYXJKUo2VK8gNvYl9aCVZKma2I31F1BpOADGInQ==@kvack.org
X-Gm-Message-State: AOJu0YwiBvhwEdqEKEj+pOTxLq3VLl66NhM6j44f/LCXBTNAWa9FS48U
	ksnavQzqo79nQ/VKk5ItjCwVfroRzDAyW6IPe6s/7xMbnuO/2MhIG7ujDg3FIA==
X-Gm-Gg: ATEYQzzNfVSpVyCYp2QGbWpPiRB64vCc48zUv27T/dzvQ+xFxFEg/ByMCQmQIdjmNDv
	xXhr12+JLEUz7WOG6zY10vfVrUsmO701mfgViiDMZzu6DDr66rqfnDoNHnTXVhFpyK6lZKzgAu5
	9WLp8ZK6R028juuF4KU+/csnwr/mFlkN0jt77kA12XV4I2S36dLVtmBoUP4tHKXwMjVOREk9a7Y
	nxWeAAtrfujn0sBez3MOsA+61AUUsDbo4TgNye1yyZ/gEZ+C02B5DTfVSg8Ie/8leKyNPPkhrZZ
	Eb+krIHF0rzo1Fj9xKeQ5SLahaJ6+VWMt7GqrLGO4rfThJZgX5DpJmxdvmhWUL9Oh4h4deD63K9
	S0xeAIjPiN1sq9x06YLx7uaiyiKjFrwqwiIIs2tPSicFwSnrRGvc7monlh1CTck0g4H7+ytGukx
	EpWGGUP5iCWo+sZOQQtKds8w==
X-Received: by 2002:a05:6808:d50:b0:464:5aa:32cf with SMTP id 5614622812f47-4649f01f7fbmr2640192b6e.46.1772122122920;
        Thu, 26 Feb 2026 08:08:42 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:55::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-464bb35290fsm135998b6e.4.2026.02.26.08.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 08:08:42 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Gregory Price <gourry@gourry.net>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kaiyang Zhao <kaiyang2@cs.cmu.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Waiman Long <longman@redhat.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [RFC PATCH 0/6] mm/memcontrol: Make memcg limits tier-aware
Date: Thu, 26 Feb 2026 08:08:40 -0800
Message-ID: <20260226160840.1220006-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aZ_-m7vSUPrzDj4n@tiehlicka>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wq99ogctw4g8fafja8d835cqknfu6oci
X-Rspamd-Queue-Id: A49BB120010
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1772128608-723318
X-HE-Meta: U2FsdGVkX19vrJtVtlkIjSmV0HrdrlpnpxjwoZ3MVVp7MIzBhIch8i0KCs42KJh6im36kOXpIL856Pew6ZelyPsayNSYPobwlVzirlJF9IIVr63lezLCkqq4YH9dvaunf334W32KqUZQhxXW+Wty5SDJn6LJbeVQLh92eFfQ50BMuAu2KvDtGq7alFH7hW0DLZuDTMALEsZV9P6ZrPU75MeGHGhEstBvX/yM69jd7mQ+kCrdpRx6RyqDVFF83ZNP8Ek6dnl+YX/Io6+FDRmUoaJ273sSv9zdVaPNlRyNEC/11mv5NQ+FVdjRAsK0i8yC1dOd+++osnqeI/IRLCVOEpL6OweLCQg/nsrPTRvzN44JXRGkcaltsvHdV41y1MOqwvgykXy9UIAmFZNvTin4lo3v+prRuJ7DdspkYFMxpscKZIgutGDWe7U+fAKsrsFub/9Db9FumrWQU2MoeYOoraSgNhVg3n9s9++1zhYA9aIQzQmt+76n/in+yi+jIU2MDKhNfNGeOmYYf10BPvevcmGBYMXNs4lyvoib6dw1PE2TIc1dsfyXxfpvJpLUE2+Hl+7tS6jI2VukQnT6Zd4ggdULnHfCweA2CxcuntRZN0Z6tjef6zTRk9TgfoLhZcirPqJphpnyQtu9A2KBRaw4GKSc0jyLNduWirr83nG4PKolrrRyvTNsUEXAKe7ziMewd7xrn9cd2Wh1nlF7a7aJVWv/33nw06aHGGTRIZ5eE6ZWjLExOLcbMwn2TTpUTFyjgkkhQb3U3GJYC/SvRprgKL6oV0xblqAfyq30MFBokNIv6Z5sHLXVk3VX+xChrtEk0SpK3Vc/DmvVgcUJp+ICt5R71V6qyogxk9cfnfnDTylOcs3RHIKEE1BxCheC6Gejz7SGoo18tkBgRqZuhm/wKQyQYItqJyCMlDZUcRY/pZ1m/OuAzAffm5xp2mbyDbgKon/dUlx54N/RABjl7ul
 9QQGwtfN
 zgbjUXnCdZZdt7ffwYxAXm0+OLhPO3ZXZ1kyJYr/7QVDl+HN9ZK60mpFQsu5nGHJASfgnmHxnEAvYgzQObSeOhJEePLHTN2EpicMyaONy/bTZ5xablrlrOZ/vcnQLp01foqWmjCsH/blbKjJyk3sYx1O5vpgGAlziBBqg/BPC+m19mgWFxris7wHt1eCfYTsh+MX61VlRLl68lqjMLrhsFCvJJpYifH5YVki7H1nhsY5yVdndqgc+ivFPtl6JIgBt+B3uTwkXHDI+kEDuDbMyQaxEg0Ck7SVl0u8AQjzqh1QkV2iVJ+V3ujEdE7U0wkhW4am6D4L3rd/XNvluCe6DPZ07ecWED+B+1MU0bjvAQcO6QwVuInVdQCQuWExxozsrl8zn1oNYp8vAiI3HUYfrtJP0xD43hBoSdxjQOd/N0nJFeZPzTP33i2MFNHkhn7N6K9miCnSNYS2Dk4xpHT53HFmkW0qTm8Uhn1Alx3uQ14t5AWloj2V//3octzhFwXiJSGThmKuW5GZfUHr9i4e6VC2rByIGNjOEcfRJP5sQ2Dtq5wqCxZEgM3qEylhhy5YkgqAKkeD/Re/BBT4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Feb 2026 09:04:43 +0100 Michal Hocko <mhocko@suse.com> wrote:

> On Tue 24-02-26 08:13:56, Joshua Hahn wrote:
> > Hello Michal,
> > 
> > I hope that you are doing well! Thank you for taking the time to review my
> > work and leaving your thoughts.
> > 
> > I wanted to note that I hope to bring this discussion to LSFMMBPF as well,
> > to discuss what the scope of the project should be, what usecases there
> > are (as I will note below), how to make this scalable and sustainable
> > for the future, etc. I'll send out a topic proposal later today. I had
> > separated the series from the proposal because I imagined that this
> > series would go through many versions, so it would be helpful to have
> > the topic as a unified place for pre-conference discussions.
> 
> yes, this is a really good topic to bring to LSFMMBPF. I will not be
> attending this year unfortunately but I will keep watching progress on
> the this. I am really sure there will be people in the room that can
> help with the discussion.

Hello Michal, thank you for the encouraging words : -)
Yes, I am sure that the audience will have valuable ideas to share
as well. Hopefully I can catch you at another conference!

And by the way, I've sent out the proposal here [1] if you are interested!

[...snip...]

> > > This assumes that the active workingset size of all workloads doesn't
> > > fit into the top tier right?
> > 
> > Yes, for the scenario above, a workload that is violating its fair share
> > of toptier memory mostly hurts other workloads if the aggregate working
> > set size of all workloads exceeds the size of toptier memory.
> 
> I think it would be good to provide some more insight into how this is
> supposed to work exactly. If the real working set size doesn't fit into
> the top tier then I suspect we can expect quite a lot of disruption by
> constant promotions and demotions, right. I guess what you would like to
> achieve is to stop those from happening right? If that is the case then
> how exactly do you envision to configure the workload. Do you cap the
> each workload with max/high limits? Or do you want to rely on the
> low/min limits to protect workloads you care about. Or both? How does
> that play with promotion side of things.

Yes, thrashing is probably the biggest concern with the actual performance
if deployed to a real machine. I would like to add that this is
(arguably an even bigger) problem without this setup as well.

Once again on multi-tenant hosts, if we have three hot cgroups whose
workingset size consumes all of DRAM, and one cgroup whose memory is
colder than the other three cgroups, then it will constantly face
thrashing as it has to compete with the other cgroups for hotness.

So the question is whether the thrashing happens to a well-behaving
victim cgroup, or if it happens to the ones whose workingset sizes are
too big.

I also have two qualifying points to add here:
First is that the effective toptier memory limits is not visible to the
users. So when they are designing their workloads, specifically on how
big the workingset size can be, they have no idea how to tune it. So
cgroups that appear to be well-behaved and whose total footprint is
within its memory.high threshold would still see reclaim activity.
Maybe the solution is as simple as exposing the toptier memory limits
as a new sysfs file? But I'm hoping that there is a more clever way to
do this that doesn't add more sysfs entries to the cgroup interface ; -)

Second is that there are scenarios where on a relatively idle machine
with just one cgroup where memory.high, memory.max << toptier capacity,
we would still see reclaim activity. I would argue that this is not
so different from having a cgroup go into reclaim on an empty host, 
even when there is memory avaialble.

But I could also see the argument that those two scenarios are different.
What do you think?

[...snip...]

> > In the original cover letter I offered an example of VM hosting services
> > that care less about maximizing host-wide throughput, but more on ensuring
> > a bottomline performance guarantee for all workloads running on the system.
> > For the users on these services, they don't care that the host their VM is
> > running on is maximizing throughput; rather, they care that their VM meets
> > the performance guarantees that their provider promised. If there is no
> > way to know or enforce which tier of memory their workload lands on, either
> > the bottomline guarantee becomes very underestimated, or users must deal
> > with a high variance in performance.
> > 
> > Here's another example: Let's say there is a host with multiple workloads,
> > each serving queries for a database. The host would like to guarantee the
> > lowest maximum latency possible, while maximizing the total throughput
> > of the system. Once again in this situation, without tier-aware memcg
> > limits the host can maximize throughput, but can only make severely
> > underestimated promises on the bottom line.
> 
> Thanks useful examples. And it would be really great to provide an
> example of intended configuration (no specific numbers but something to
> demonstrate the intention). Because this will not be just about limits,
> right. It would require more tweaks to the system - at least numa
> balancing (promotions) to be controlled in some way AFAICS.

Definitely. Two components that make sense here would be to throttle
promotions when toptier is facing cgroup-local pressure (reaching the
limit), and to also have some background balancing between the two nodes,
maybe by kswapd. I'll be sure to include some of these along with
performance numbers in the next version. 

[...snip...]

> > Fixed mode is what we have here -- start limiting toptier usage whenever
> > a workload goes above its fair slice of toptier.
> > Opportunistic mode would allow workloads to use more toptier memory than
> > its fair share, but only be restricted when toptier is pressured.
> > 
> > What do you think about these two options? For the stated goal of this
> > series, which is to help maximize the bottom line for workloads, fair
> > share seemed to make sense. Implementing opportunistic mode changes
> > on top of this work would most likely just be another sysctl.
> 
> To me it would sounds like the distinction between max/high vs. low/min
> reclaim.

Ack. Makes sense to me.

[...snip...]

> > > You seem to be focusing only on the top tier with this interface, right?
> > > Is this really the right way to go long term? What makes you believe that
> > > we do not really hit the same issue with other tiers as well?
> > 
> > Yes, that's right. I'm not sure if this is the right way to go long-term
> > (say, past the next 5 years). My thinking was that I can stick with doing
> > this for toptier vs. non-toptier memory for now, and deal with having
> > 3+ tiers in the future, when we start to have systems with that many tiers.
> > AFAICT two-tiered systems are still ~relatively new, and I don't think
> > there are a lot of genuine usecases for enforcing mid-tier memory limits
> > as of now. Of course, I would be excited to learn about these usecases
> > and work this patchset to support them as well if anybody has them.
> 
> I guess a more fundamental question is whether this need to replicate
> all limits for tiers or whether we can get an extension that would
> control tier behavior for existing ones. In other words can we define
> which proportion of the max/high resp. low/min limits are reserved for
> each tier? Is that feasible? I do not have answer to that myself at this
> stage TBH.

In terms of feasibility, I think the easiest would be to enforce limits
based on capacity, since this would let us get by without defining
per-tier per-cgroup limits. So for a 4-tier system with capacity of 200G
and at each tier,  100G : 60G : 20G : 20G, and a cgroup with a 50G memory.high:

tier0.ratio: 100 / 200 = 0.5		tier0.toptier_high = 50G * 0.5 = 25G
tier1.ratio: 60 / 200  = 0.3		tier1.toptier_high = 50G * 0.3 = 15G
tier2.ratio: 20 / 200  = 0.1		tier2.toptier_high = 50G * 0.1 = 5G
tier3.ratio: 20 / 200  = 0.1		tier3.toptier_high = 50G * 0.1 = 5G

The alternative would be to have 4 sysctls here to set limits which...
doesn't sound too fun ; -) And I'm not entirely sure if we want limits
per-tier anyways. For most scenarios I think it should be enough to limit
how much to protect or limit toptier usage.

> [...]
> > > What is the reasoning for the switch to be runtime sysctl rather than
> > > boot-time or cgroup mount option?
> > 
> > Good point : -) I don't think cgroup mount options are a good idea,
> > since this would mean that we can have a set of cgroups self-policing
> > their toptier usage, while another cgroup allocates memory unrestricted.
> > This would punish the self-policing cgroup and we would lose the benefit
> > of having a bottomline performance guarantee.
> 
> I do not follow. cgroup mount option would apply to all cgroups. In
> sense whatever is achievable by sysctl should apply to kernel cmdline or
> mount option. The question is what is the best fit AFAICS.

Yup, you're right. I mixed it up in my head and got confused, in terms
of functionality I think kernel cmdline and mount option are same.

Actually everything except for runtime toggle makes sense, since this
requires the system to do the additioanl per-tier accounting even when
it is disabled. With kernel cmdline we can tell the system to completely
ignore the per-tier accounting and enforcement and the user faces no
effects at all (except well, the additional cacheline in struct page_coutner?)

Anyways, thank you very much for your thoughs and encouraging words.
I hope you have a great day, Michal!
Joshua

[1] https://lore.kernel.org/all/CAN+CAwNwpjRf9QhgAEhBQZD7r7sXCzLXqAKbNrPeMEq=7bX8Jg@mail.gmail.com/

