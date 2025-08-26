Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 784AFCA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 12:57:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF52B6B00A2; Tue, 26 Aug 2025 08:57:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCC1C6B00A3; Tue, 26 Aug 2025 08:57:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B08896B00A6; Tue, 26 Aug 2025 08:57:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9BE4E6B00A2
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:57:12 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3509F14076C
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:57:12 +0000 (UTC)
X-FDA: 83818909104.19.4024C76
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6CC7210000F
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:57:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756213030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1wSr1M1+l9cMskoODkXTYKgUMawQ7425u8rED4WrwM8=;
	b=8A5ykiZkt/jnbD+4fyaJ2677pbtI7QBnBUnXxcukJoS7Yt/9URcjMlJIWvg6dA6oqW5ARC
	iBK9mQvzMebvV3sSNxwTzprMvzgTzO4zmLiQhkvJ/oJVi7QsHN4dfT62t8w1D13oAmIQLD
	zUzN8BxrgH8bPl/R6sMiU62ev94/CK4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756213030; a=rsa-sha256;
	cv=none;
	b=1RCqUXhVX9i5Dafr+xEgOTcx9KViS0f2xHK49lpwAXI9ZVO4y+OPX+vPdgwCwU8Rqf+Wf3
	pnyZGYOahF8x2pTDejDacuTvR+a1Z7zUwnpnITe3BLOz/Ea38s79bUtASHn2DpGM6nGjpG
	GLc+5v1gn69Ae6M4H6Ckgz25GGC/fZk=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 26 Aug 2025 21:57:05 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 26 Aug 2025 21:57:05 +0900
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
Message-ID: <aK2vIdU0szcu7smP@yjaykim-PowerEdge-T330>
References: <aKC+EU3I/qm6TcjG@yjaykim-PowerEdge-T330>
 <CAF8kJuNuNuxxTbtkCb3Opsjfy-or7E+0AwPDi7L-EgqoraQ3Qg@mail.gmail.com>
 <aKROKZ9+z2oGUJ7K@yjaykim-PowerEdge-T330>
 <CAF8kJuPUouN4c6V-CaG7_WQUAvRxBg02WRxsMtL56_YTdTh1Jg@mail.gmail.com>
 <aKXeLCr9DgQ2YfCq@yjaykim-PowerEdge-T330>
 <CAF8kJuM4f2W6w29VcHY5mgXVMYmTF4yORKaFky6bCjS1xRek9Q@mail.gmail.com>
 <aKgD7nZy7U+rHt9X@yjaykim-PowerEdge-T330>
 <CAF8kJuMb5i6GuD_-XWtHPYnu-8dQ0W51_KqUk60DccqbKjNq6w@mail.gmail.com>
 <aKsAES4cXWbDG1xn@yjaykim-PowerEdge-T330>
 <CACePvbV=OuxGTqoZvgwkx9D-1CycbDv7iQdKhqH1i2e8rTq9OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbV=OuxGTqoZvgwkx9D-1CycbDv7iQdKhqH1i2e8rTq9OQ@mail.gmail.com>
X-Rspamd-Queue-Id: 6CC7210000F
X-Rspam-User: 
X-Stat-Signature: qegtsbddxszbphxghupaexpjoi14pfp5
X-Rspamd-Server: rspam09
X-HE-Tag: 1756213029-317633
X-HE-Meta: U2FsdGVkX1/AJJwVecnRjz77bRJRB0vvYCKt2g2BsMkRc8VrUo2D2alABEftJ3sxUaUN7W2xZpLBVtJLdJ3SmQbqWG6nd1wTJIGgLP48Hl0JuuRJjNBI77Ezuhby1h2PpdIu02qAulrX/3veMlitvXxZTCp+Yrj3CwRlKPbnV0ZiKLLCYp65XjbBLwA7bC1ijIVlpdlYYPeTDWboBhIWf1u7Syuzs/GqVWQYS4RSlQV3konHStfJDDNkTmunAHiU9NPOJ8hEzXl1UHUGolDJrdP68Aecs1EO/c1sRU4ZYWLQnQH9JuEZ0uR0Mq//eXyCN3o7xd6VWTOxRMlMv6Zk8Y5PVHELtNgaTlCuACYR62kqVocHi+RiVBFRcXMeMi+TL+q8EUeMRZ4TKdAg/G4TTi9e8hDo6bghC8zR6k1w/tVO1Iu1xN/d/ZesuojPKxEpq/EAHucnVLullLUPxRI1l9ijKtkQU63M2zxVreoVGjyYekQs8kS1mtpaOJsKPtK/V78kd3mMzlPl5oMbt/iB+n8TgmkZfQAPEymaRd5xKKT2wwCnl5/9+FodD7v1ltdZeiHqqlOgA15NLxcLAEkiPhQp6Dr3WKq4nwcSxjY5kmAy9PEy9+U8dnPCl6buFX/BEIc/mJhTtvH4EhKRf+EcldFTVcQ4Qrx9On85MAhZ3nLR4c8E5VhqFlz2UUR7p9CUNavAiqef/0VWR+jNfYaD9oeaAOnXdYHIVOXahwjae7nc5n28NASJcoV6RGonKnDYk4iKx8/Wqa64oJ52tL8WPLWHAO6LWQkxCorX9uqxC2lvOTm9YFnOrsS/N0fI3vxfI5Bf1m8/59gE9aQmhqa2QjPwjEheSh7YdkbykTcyJ5EY7tT5B4bdBsCXqoOBz/Cbwd5NNQz1DcTNi+Ialwb4KRlaqjutXrBfJwE+rrmZ2nCbDsg3znBZngoCqXuTc3gLEBpSCtDl94RvsQ0ECEw
 t4DT/f7/
 MXCpoO/3E46PyEE7fP1SlJK5Rgq0KRZKze5TNFLccaVE7eLhRTxmPZpm+PhZ+2oG6t2ieMZAlJMjn98CKfzhzZszWgfP7Egh/aD6Z2h4Oj5BqEyJrdi/psZKC2kg4X8cfab17Xy5vZDbt0AnfaKjVRTX4YGm0+pLOoH1pao2zbTSQV9UKoKML/WiqMBxm5bBJO/WqhJa4rKNkT7pY0+s+dXH7b5DfOtkvM55Lf9NI92N80lCd16V1q38yWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Therefore, my current thinking is:
> > * The global swap setting itself is tier 1 (if nothing is configured).
> > * If a cgroup has no setting:
> >   - Top-level cgroups follow the global swap.
> >   - Child cgroups follow their parent’s setting.
> > * If a cgroup has its own setting, that setting is applied.
> > (child cgroups can only select tiers that the parent has allowed.)
>
> That is too restrictive. The most common case is just the parent
> cgroup matters, the child uses the exact same setting as the parent.
> However, if you want the child to be different from the parent, there
> are two cases depending on your intention. Both can make sense.
> 1) The parent is more latency sensitive than the child. That way the
> child will be more (slower) tired than the parent. Using more tiers is
> slower, that is the inverted relationship. Your proposal does not
> allow this?
> 2) The parent is latency tolerant and the child is latency sensitive.
> In this case, the child will remove some swap files from the parent.
> This is also a valid case, e.g. the parent is just a wrapper daemon
> invoking the real worker as a child. The wrapper just does log
> rotation and restarting the child group with a watchdog, it does not
> need to be very latency sensitive, let say the watchdog is 1 hours.
> The child is the heavy lifter and requires fast response.
>
> I think both cases are possible, I don't see a strong reason to limit
> the flexibility when there is no additional cost. I expect the
> restriction approach having similar complexity.

In my use case, I think a restrictive inheritance model could
be sufficient. My argument was mainly based on the fact that most cgroup
resource distribution mechanisms usually follow a parent→child restrictive
pattern. Through the review, I came to the view that I should adhere to the
common behavior whenever possible.

Firstly(on RFC), I initially supported allowing parent/child inconsistency
for flexibility, so I actually agree with your view regarding flexibility.
For the examples you mentioned, I have no disagreement. I think my final
understanding is aligned with yours.

> Can you clarify what I need to reconsider? I have the very similar
> bitmask idea as you describe now.
> I am not a dictator. I just provide feedback to your usage case with
> my reasoning.
>

Oh! I think you are a good reviewer :D
Okay then, Let me explain my preference for numeric tiers in more detail.
It seems we are aligned on the implementation strategy with bitmask,
but I think our difference lies in the interface style — 'name' vs.
'numeric increase'."

1. A simple numeric interface makes the usage more straightforward.
   Instead of '+/-' semantics, directly listing the numeric range feels
   clearer and easier to use. For example:

     tier 1 (ram)
     tier 2 (ssd)
     tier 3 (hdd)
     tier 4 (network device)
     tier 5 (some device)
     tier 6 (some device2)

   cg1: echo 1-3  > memory.swap.tier (ram,ssd,hdd)
   cg1/cg2: 2-4,6  > memory.swap.tie (ssd,hdd,network device, somedevice 2, assuming non-subset is allowed)

   Tier specification can also be expressed simply as arrays of priority
   ranges, which feels easy to understand.

2. Since tiers are inherently ordered, numbering fits naturally and is
   easier for users to accept.  
   In my view, assigning a name is mainly useful to distinguish between
   otherwise 'indistinguishable' groups, but in this case, there is already
   a clear distinction given by the different priorities which simply be 
   charaterized by increasing number.

I understand your point that tier names may be more convenient for
administrators, and I see the value in that. That was why I used the word
"reconsider" — your feedback makes sense as well.

I do not have a strong preference. It would be good to align after
considering the pros and cons. I look forward to your thoughts."

> > There seem to be two possible choices:
> >
> > 1. Once a cgroup references a tier, modifying that tier should be
> >    disallowed.
>
> Even modify a tier to cover more priority range but no swap device
> falls in that additional range yet?
> I think we should make the change follow the swap on/swap off
> behavior. Once the swap device is swapped on, it can't change its tier
> until it is swapped off again. when it is swapped off, there is no
> cgroup on it. Notice the swap file belongs to which tier is not the
> same as the priority range of the tier. You can modify the range and
> reorder swap tiers as long as it is not causing swap on device jump to
> a different tier.
>
> > 2. Allow tier re-definition even if cgroups are already referencing
> >    it.
>
> You can still swap off even if cgroup is still using it.
>
> > Personally, I prefer option (1), since it avoids unexpected changes
> > for cgroups that already rely on a particular tier definition.
>
> Swap off and on already have similar problems. We can't change the
> priority when the swap device is swapon already. We can go through a
> swap off to change it.

I see your point. In practice, when tiers are already being referenced
by cgroups, swap devices may come and go within those tiers. I think
this can be considered a "natural" behavior, as swap management is
usually performed explicitly by the administrator.  

From that perspective, I expect that unintended behavior is very
unlikely to occur in real scenarios. So I am comfortable assuming this
implicit behavior when reasoning about tier modifications.  

Thanks again for the clarification. With this, the overall picture
feels much clearer. Once we reach alignment on the "named" vs. "numeric"
tier interface, I plan to move forward with the patch work.

Best Regards
Youngjun Park

