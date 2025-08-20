Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 402E7CA0EE4
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 14:39:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB2B08E000F; Wed, 20 Aug 2025 10:39:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8B7C8E0003; Wed, 20 Aug 2025 10:39:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC7AD8E000F; Wed, 20 Aug 2025 10:39:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 99FEC8E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:39:48 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1E6ED1DD997
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 14:39:48 +0000 (UTC)
X-FDA: 83797394856.23.9397CB3
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0D02840006
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 14:39:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf04.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755700786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r81hz8befqiC+4VsYBhU9UOh03FIPUo0qPSRYBUSw2Q=;
	b=dLSn3Phgcq33q+y1QTKN1KP099Cw0Z3Xz4HXm+n2BCgUB644+FNdujPuFl8s7RkCVQ+9w5
	+2HGH5Z7orIHrvL70XssjIVahtEZTgZPs1U1dKlXqrYEXvxKiTmerpSFzXI4ORUeUaqIIX
	SoILbNzoTB3Q1FIJ+0P/s7F33YcK0Uk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf04.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755700786; a=rsa-sha256;
	cv=none;
	b=iGgnrTm1D+TrcCERJs88xPYiFey+cZw142mqs9KVvIFCC6mgEaCXk8Oq7qhHALdIld3qh9
	oAD2IGwEVd7kk8nCiwIIuIXVfOey+tjlpXLP4JuQcEtoM5DxOWLd9OlvnM7yQWV+tRRfY0
	YMYzpOom3nB4P8dOZ7oZPXO2O/Afpyo=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 20 Aug 2025 23:39:40 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Wed, 20 Aug 2025 23:39:40 +0900
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
Message-ID: <aKXeLCr9DgQ2YfCq@yjaykim-PowerEdge-T330>
References: <20250716202006.3640584-2-youngjun.park@lge.com>
 <jrkh2jy2pkoxgsxgsstpmijyhbzzyige6ubltvmvwl6fwkp3s7@kzc24pj2tcko>
 <aH+apAbBCmkMGPlO@yjaykim-PowerEdge-T330>
 <aH/baxIgrBI3Z1Hl@yjaykim-PowerEdge-T330>
 <uyxkdmnmvjipxuf7gagu2okw7afvzlclomfmc6wb6tygc3mhv6@736m7xs6gn5q>
 <CAF8kJuMo3yNKOZL9n5UkHx_O5cTZts287HOnQOu=KqQcnbrMdg@mail.gmail.com>
 <aKC+EU3I/qm6TcjG@yjaykim-PowerEdge-T330>
 <CAF8kJuNuNuxxTbtkCb3Opsjfy-or7E+0AwPDi7L-EgqoraQ3Qg@mail.gmail.com>
 <aKROKZ9+z2oGUJ7K@yjaykim-PowerEdge-T330>
 <CAF8kJuPUouN4c6V-CaG7_WQUAvRxBg02WRxsMtL56_YTdTh1Jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF8kJuPUouN4c6V-CaG7_WQUAvRxBg02WRxsMtL56_YTdTh1Jg@mail.gmail.com>
X-Stat-Signature: w1qb3yda5sz5ugs5kt7xaapb1d17suih
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D02840006
X-Rspamd-Server: rspam05
X-HE-Tag: 1755700784-421272
X-HE-Meta: U2FsdGVkX1/TVufGF5u1vmemlGXXsRkyL6/WxdU2MVQpCp8FKzZsTZ7Aqcgpcc6eNRIP7991MYag/G2yDd9KBv+XNvKO+PGEEFqhq0DNXtCPP2a6hIR517dTqVei39zISrjAmeHgUeXRKljT5QoB1USx8HYhCm/55GORRvWPOI0iXmarsYjB/ftlr0M4TWj6iojzpyeeac9axq38ca6i2TObAn1cWZp3ZcJZI7tZtWMUslTnYeuPFQU/LP/KnQBzQeQMH+6tchJzZE/XtumPZ+nM/jpq08WdzIH51gPFiZsvhUQeNDfi1xqZxdiHRjkWlrj84olVtpIHgVrzXgmltRoKHStuwC27rloVOAX82kkXcSFogXmwWO32KQXYPRW0QOl1Az024FzDYOVcLoVKZXnNX1oD5vzArYlSnQyeBSbolrX3WGC/oHcGJfCb9z99Vn5Tw/LjAYDRQOrzyKNgNXSpl3g7s76WocjJXAR7DbwONwoDocvoacbHuof7W/x2nJGlAGKo7jt2L+ixqvbPhl3uF1Ac2l4LYtXX/dJ95Wz5JTXPYzN4BSGLlgZu9pn9f/Vybqr0rc6saxhej5KFIbWuuNRw1V2SIEyUkQtOQUYBlfwCro3J9UqMNY2Xqz0RQqXnF/n37gfm9ee5//JCNwmEfVlr93NBAbgU4ovztXlilZPd1Z9lQfQ5H3KF26cDiDJAWjYDE/C/bAKgMUElTL+KlV6cjsQTGE+8O7yl402pRM+WR8N+mCrcfPTnq7cvlpqKJiQ5+ISwuwg0Gg1Mfd5LgSrRtcaCw24fZFrceqnYcEg+mFMVfFcT9ibVM86KjZxXBN/i/aQlJgCXoCyk5IVKIfQnRyT2yt6L6LFYO/JuWe1QvaA/PCBc4JbBVoMfNtfPVtBnYUEC+iFZn+yiKcArpEsb40emPLaYgSQ+ygAPbFN1QdV/tkDfwBSrAGyPnY5wVzjcRLdebCXugoz
 gRY3eNLC
 6oq+I0fk8jBjifimt4s6lJ7OvGlQs9QwT+NY4Fq0bBzskrkR+aRpVifLbCN510XP4eiWnurpWR0g8uQixNTgtO3fkQo5cKDfSoTx5NHLgbr5c7N9uJf0tdSpWPkWjTRdlot2QmADVuMEyXmSRkTjI1BiS+0aI/9FruiNdxv7MNZD2bP0yzIw2PXr0Wriwjj86xWUF4SEBtz8mz+RAITchBGslELuUq6QJRI9u497S8406xNTAnChyjujuvHom4hkJSIQD16HOwfeMMCyFq2IlYWAFt6jaZoqTK9/v
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > inclusion/exclusion semantics at the cgroup level. The reason I decided not to
> > go with it is because it lacks flexibility — it cannot express arbitrary     
> > ordering. As noted above, it is impossible to represent arbitrary orderings, 
> > which is why I chose a per-device priority strategy instead.                 
>                                                                                
> As said, arbitrary orders violate the swap entry LRU orders. You still         
> haven't given me a detailed technical reason why you need arbitrary            
> orders other than "I want a pony".

I believe the examples I provided for arbitrary ordering can be considered
a detailed technical reason.
(You responded with Option 1 and Option 2.)

> > The `swap.tier` concept also requires mapping priorities to tiers, creating  
> > per-cgroup tier objects, and so forth. That means a number of supporting     
> > structures are needed as well. While I agree it is conceptually well-defined,
> > I don’t necessarily find it simpler than the per-device priority model.      
>                                                                                
> You haven't embraced the swap.tiers ideas to the full extent. I do see         
> it can be simpler if you follow my suggestion. You are imaging a               
> version using swap file priority data struct to implement the swap             
> tiers. 

Thank you for the detailed explanation. I think I understood the core points of this concept
What I wrote was simply my interpretation — that it can be
viewed as a well-defined extension of maintaining equal priority dependency
together with inclusion/exclusion semantics. Nothing more and nothing less.

> That is not what I have in mind. The tiers can be just one             
> integer to represent the set of tiers it enrolls and the default. If           
> you follow my suggestion and the design you will have a simpler series         
> in the end.                                                                    

Through this discussion my intention is to arrive at the best solution,
and I appreciate that you pointed out areas I should reconsider. If you,
and other reviewers(If somebody gives opions of it, then it will be helpful)
generally conclude that the tier concept is the right path,
I have a clear willingness to re-propose an RFC and patches
based on your idea. In that case, since arbitrary ordering would not be
allowed, I fully agree that the main swap selection logic would become
simpler than my current implementation.
                                                                    
> The problem is that you pollute your fast tier with very cold swap              
> entry data, that is to your disadvantage, because you will need to             
> swap back more from the slower tier.                                           
>                                                                                
> e.g. you have two pages. Swap entry A will get 2 swap faults, the swap         
> entry B will get 20 swap faults in the next 2 hours. B is hotter than          
> A. Let's say you have to store them one in zswap and the other in hdd.         
> Which one should you store in faster zswap? Obvious swap entry B.              
>                                                                                
> It will cause more problems when you flush the data to the lower tier.         
> You want to flush the coldest data first. Please read about the                
> history of zswap write back and what LRU problem it encountered. The           
> most recent zswap storing the incompressible pages series in the mail          
> list precisely driven by preserving the swap entry LRU order reason.           
>                                                                                
> You really should consider the effect on swap entry LRU ordering               
> before you design the per cgroup swap priority.                                

Then I would like to ask a fundamental question about priority. Priority is
a user interface, and the user has the choice. From the beginning, when the
user sets priorities, there could be a scenario where the slower swap is
given a higher priority and the faster swap is given a lower one. That is
possible. For example, if the faster device has a short lifetime, a real
use case might be to consume the slower swap first for endurance, and only
use the faster swap when unavoidable.

In this case, logically from the LRU perspective there is no inversion of
priority order, but in practice the slower device is filled first. That
looks like degradation from a performance perspective — but it is exactly
what the user intended.

The swap tier concept appears to map priority semantics directly to service
speed, so that higher priority always means faster service. This looks like
it enforces the choice on the user(but it is opend).

Even with swap tiers, under the semantics you suggested, it is possible for
a given cgroup to use only the slower tier. From that cgroup’s view there
is no LRU inversion, but since the fast swap exists and is left unused, it
could still be seen as an "inverse" in terms of usage.

In summary, what I struggle to understand is that if the major assumption
is that swap operation must always align with service speed, then even swap
tiers can contradict it (since users may deliberately prefer the lower
tier). In that case, wouldn’t the whole concept of letting users select swap
devices by priority itself also become a problem?

> > I mentioned already on this mail: what swap tiers cannot do is arbitrary     
> > ordering. If ordering is fixed globally by tiers, some workloads that want to
> > consume slower swap devices first (and reserve faster devices as a safety    
> > backend to minimize swap failures) cannot be expressed. This kind of policy  
> > requires arbitrary ordering flexibility, which is possible with per-device   
> > priorities but not with fixed tiers.                                         
>                                                                                
> Let's say you have fast tier A and slow tier B.                                
>                                                                                
> Option 1) All swap entries go through the fast tier A first. As time           
> goes on, the colder swap entry will move to the end of the tier A LRU,         
> because there is no swap fault happening to those colder entries. If           
> you run out of space of  A, then you flush the end of the A to B. If           
> the swap fault does happen in the relative short period of time, it            
> will serve by the faster tier of A.                                            
>                                                                                
> That is a win compared to your proposal you want directly to go to B,          
> with more swap faults will be served by B compared to option 1).               
>                                                                                
> option 2) Just disable fast tier A in the beginning, only use B until          
> B is full. At some point B is full, you want to enable fast tier A.            
> Then it should move the head LRU from B into A. That way it still              
> maintains the LRU order.                                                       
>                                                                                
> option 1) seems better than 2) because it serves more swap faults from         
> faster tier A.                                                                 

Option 1 does not really align with the usage scenario I had in mind,
since it starts from the fast swap. Option 2 fits partially, but requires
controlling when to enable the fast tier once full, and handling LRU
movement — which adds complexity.

Your final suggestion of Option 1 seems consistent with your original
objection: that the system design should fundamentally aim at performance
improvement by making use of the fast swap first.

> > And vswap possible usage: if we must consider vswap (assume we can select it 
> > like an individual swap device), where should it be mapped in the tier model?
> > (see https://lore.kernel.org/linux-mm/CAMgjq7BA_2-5iCvS-vp9ZEoG=1DwHWYuVZOuH8DWH9wzdoC00g@mail.gmail.com/)
>                                                                                
> The swap tires do not depend on vswap, you don't need to worry about that now. 

I initially understood vswap could also be treated as an
identity selectable in the unified swap framework. If that were the case, I
thought it would be hard to map vswap into the tier concept. Was that my
misinterpretation?

> The per cgroup swap tiers integer bitmask is simpler than maintaining          
> a per cgroup order list. It might be the same complexity in your mind,         
> I do see swap tiers as the simpler one.                                        

I agree that from the perspective of implementing the main swap selection
logic, tiers are simpler. Since arbitrary ordering is not allowed, a large
part of the implementation complexity can indeed be reduced.

Once again, thank you for your thoughtful comments and constructive feedback.

Best Regards,
Youngjun Park 

