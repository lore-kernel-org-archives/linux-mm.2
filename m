Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32531CD4F47
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 15:49:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80D3E6B0092; Fri, 15 May 2026 11:48:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BE506B0093; Fri, 15 May 2026 11:48:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D47D6B0095; Fri, 15 May 2026 11:48:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E0866B0093
	for <linux-mm@kvack.org>; Fri, 15 May 2026 11:48:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 13A3112018D
	for <linux-mm@kvack.org>; Fri, 15 May 2026 15:48:59 +0000 (UTC)
X-FDA: 84770087598.24.03052AC
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf18.hostedemail.com (Postfix) with ESMTP id 43A2F1C0011
	for <linux-mm@kvack.org>; Fri, 15 May 2026 15:48:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FwYXaTUS;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778860137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DIy7cun9+UZftGc9vMcXDvz0sKCcg/Dk+6aksFvzbrA=;
	b=2uibZNSkAJJ/v5za+ZN1YAkUzOv0CfbaxJY3BaL+AiXJtemF4AW8HxpJUuA5bh1Utkne89
	/exv0jrb8rI7kg0HlvRFdsn01cAoeYBV4jHrTYrpPmROfgzRa8VH+FpoSAia2RF1vYMyGu
	Tcyim8ouhT/lLiikfjw4uV171afs7u0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FwYXaTUS;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778860137; a=rsa-sha256;
	cv=none;
	b=jnr+NKqN3no804JxWoqxrUmFv763+nz2prKm6qoj0qOnG4AgvCk2lAhRdoPQ/sM3cN4FRp
	7GBjYUBR2mSxjof7G3vQHMySa0U+LQR8GVLYs0TwDBPW4j7nlWESKvtiGWFQBmLHG3f7L/
	xY3iALDk59t3tnS9ftUuLazvgEa2kFk=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-911af978bf2so165178785a.1
        for <linux-mm@kvack.org>; Fri, 15 May 2026 08:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778860136; x=1779464936; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DIy7cun9+UZftGc9vMcXDvz0sKCcg/Dk+6aksFvzbrA=;
        b=FwYXaTUSbD7SHgPVjAf7kVgY9uvBGPVKMoaKBT7UNWnOzvZI7ZvUKw/LE6tHPlNsFP
         DXVK2nY5QAtl7zoU4I3CNpEptUtaNapUDuldfF0EOuWufEfV9vXI9DHLOXLcRDTzLeSd
         S619CcCAy4mXYjigXeOc5L/IG1X0vKiAy7imYO2Vao7bIdjg+5rbh4iSIQehQxIRaCcv
         mYxblnGu0J+McCrT107yw0UlWYVpDcuROS8ZTLXTvujlEf78k4uYybuFzDl1z3ZGepfL
         2MUg7pzNmJP/URdQOpvJwfsgSf6CeVIU65v1OxouvMgifsEzrfOS/1+Vj0Teq41sXmdi
         /ayg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778860136; x=1779464936;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DIy7cun9+UZftGc9vMcXDvz0sKCcg/Dk+6aksFvzbrA=;
        b=Ip+1y42qxGIUHIK/MEvAZqd1h/dPWoSLrAfnQTMvgkDNG1Dkf6iWXt1MkvzKGDHMr9
         ashgmiOFa4b//JJUS0GfZvW1uv4T9ThFCtgrJwHppiNb/7BoMZ71zgq9/bPoykB8jK4u
         GTMROLZyq/k4NO26/6ggwD7KM7Y3dsijw/GlO07irhEOPyWp+jrWmf61MZHEXNzLlxwB
         ZH4kvHjdJba6kAxnvfJ2Padlxlf7hGNKorWzcerEQ648Bl3Ql1XiOpromJwFhcuHKR56
         ZHGtvvubeX7eC+gMYqblpLj62RWBbgELmMzZ7+px5CnZ5sezDAKCRtrbVwgVJYIZAWIu
         83gg==
X-Gm-Message-State: AOJu0YxiKw0l9Joam7cySc4ug2a7dC0pIG10kvy+6h4hIub5axG9ZHHw
	6Uq7iPfwlbeSym1WfP4NSovZI+D461aHgEI3aZ5+X9obtEvsO1ZgSbYG+QbyhQR0GNg=
X-Gm-Gg: Acq92OGLkGk87PCP5u07v4tLod2dhUSUIzQHU2VZoANVfPWKGrj6a3grD9FF8udFA7y
	OfZFX5m3UPOfvW3hdtnYFGtc9B9j6TnqvOtCrfCqTjD54XDwkFhKhuU7QTL1WhNXtOUD5MhbVO+
	M65gjFAavkPFXLc95evQBcHl3tleBCTKZroZgZHnAMFvI+BidOqAyTBk0DeWVx+oNeg6X18dF6g
	RukAzo3sYUH/HuaqSmn4TWmJUqtQcJRvTRXEeqd84EY2ZvweY8f5Agq4pHHWWYpkeVFR4xa3dT5
	NqP+5KWMo5ejVU3QjjAFCy1UkDkHAKt4+vcN5BFCQUsZbcuvGJ16lPg9LLBgofnxIL+NyiLK2Cs
	HH9vbdTVmr5wpi4z9/IcicxJMo94vh03CGKR1ZDQ0JNTWhMzYgikD7pNYLXhR3J2Rwd50Hzc18O
	lHHKQlXyrL6vX0amgtxvR/bOYMF38uG7SheNGAvgC++4P56RuqZwetmM2VOjCHH00PKE+Y0Pnaw
	YVRb2XP3BYN
X-Received: by 2002:a05:620a:22d2:b0:911:e74a:1e73 with SMTP id af79cd13be357-911e74a1edbmr511655385a.55.1778860136276;
        Fri, 15 May 2026 08:48:56 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8c9093e6d33sm55821016d6.22.2026.05.15.08.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 08:48:55 -0700 (PDT)
Date: Fri, 15 May 2026 11:48:53 -0400
From: Gregory Price <gourry@gourry.net>
To: Brendan Jackman <jackmanb@google.com>
Cc: linux-mm@kvack.org, kernel-team@meta.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, apopple@nvidia.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	yury.norov@gmail.com, linux@rasmusvillemoes.dk, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, sj@kernel.org, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, muchun.song@linux.dev,
	xu.xin16@zte.com.cn, chengming.zhou@linux.dev, jannh@google.com,
	linmiaohe@huawei.com, nao.horiguchi@gmail.com, pfalcato@suse.de,
	rientjes@google.com, shakeel.butt@linux.dev, riel@surriel.com,
	harry.yoo@oracle.com, cl@gentwo.org, roman.gushchin@linux.dev,
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com,
	nphamcs@gmail.com, bhe@redhat.com, zhengqi.arch@bytedance.com,
	terry.bowman@amd.com, owner-linux-mm@kvack.org
Subject: Re: [RFC] __GFP_UNMAPPED and __GFP_PRIVATE follow up
Message-ID: <agdAZQ4sEdGItwc2@gourry-fedora-PF4VCD3F>
References: <agYJcRgOHho8upVv@gourry-fedora-PF4VCD3F>
 <DIJ5IBGSO0OC.1S6AARO01CD6T@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DIJ5IBGSO0OC.1S6AARO01CD6T@google.com>
X-Stat-Signature: 7azdgagmn4ys9bek8qpjtmk6aygz7nn4
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 43A2F1C0011
X-Rspam-User: 
X-HE-Tag: 1778860137-288127
X-HE-Meta: U2FsdGVkX19nT00Pt8nCDH54AjGtHs13hP+s6q4v/bVamoarlCMX6UPabT2fufZ7kMvskrhHuOQ9TVbXnl8aoH5kHPzntboPCSOljhbl6RrVBoeTzUUWG0Z73HxcjyJ4DJuJH9Plz79XumfkZAK4EjFurQsn0fFaVjVqRyJFDAhpzDPMBailxa9iS0alsWTkNYWTl4x9FPgI8OcoqHkRKkLW4/MgcaC90+uDcXKfcn/UxfoWSXjVD7FLo27LUt21et5qyLwgzP5LcgtZJhbznJkbu6lBsq3xL8Y/4+56YpMku/FmXZ4vpB8Frhkr4iUBW3qsEIG+PQ9qZO7plP5stDElO6/F9XNEAWUau9pDb2nu7OMY+TJWCd3M7jhb+V4k2v/9uxGME7VQaPqgR91QjIqjRHP+67nJBPN5R1K3XUSLSDTMt0oFUxC62zPuY985AMmVmqSZVfpWS5LGvvCswIyB7JtUzIAtOEohOz9MkW9Ixs3gLb3DzFhl+J7rSRMEbl3sABhvmYwaCNGBVdtC0dtFh0qgv+jXRVCY13cuYMSgi7o3V47iXAsSDY/ii6HBWER8B4BuxSEFyAJsZJYqcqlgxaR5ghDnXcS3xRe581EH8pPrvc5FyFnUymD8XML+AcFuxZYyu0Wcl3C2EtHbBWyDLp2a1bVXxRqF1HmeJqZuaqkBbMq/Tu+DoOpk+d2A2bcd0CMn6OEfik5ZgTOdN8mmTxp2aA394VVSijo0sgzizT6CAISvdqKTMPTnGf+cBma3DH2iZU2c6g+TnFy42hkVNA0uwQzdvtHdEt68BeweU+5amvkKi5Rlx4zsuuVBfG5rYMEku91z4+Hcbn05bkj1jjYGiEvZ1cj9ClY+cbUG0LEW30LQDxJqzCGHgc4WAXIVZCZccNJGm9w8OCTrjyZcGEcxH+mzWRclfwKF/zxciDQ/my49H0bboVw/ZohZ59XhnNT1/1i55fb9gGt
 kEP5jUtt
 DEptysrI9Vh6UMRS4iZTJNiyYc+4AT7P+kXkC/CLxVQb8DUBhLONKb1jZasnYE8Cintyq52KUiwKXOrCL7EtWJGjtx/TQUuuhX8MmrYrpIQALzQwwM04IEIt4YsBsN+qAteJHH+LGqc14HmR+m0Wo/oXMP9PaMRVAasv2mgdLg88PvjigBhKZ5VZpNIYLCfXMFPUw0GGpIRDWaW8Ukz0pKnR51O/ubjuPtJAmlHnBCWT7B6MFISMlICePSTpX3COFAiKI+KdEh8OEO1T95R7TKqcKUjfN7lHoKI3F3xBf7bmSZId4W1vNVNGXIfP4/jpqyGO9htkxEcAc+PNDg4CAi7agB4sVRLYz24ELgyzVeaksLrmKgEBvhW5x9XaR/i0fFyczT75AnBF97S7TXZ9Uvst7Q7avCmMbBN22O+xOGivLjiEFasyFmQ++c0Anlx9i+W3T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 15, 2026 at 09:43:02AM +0000, Brendan Jackman wrote:
> 
> Yeah, I have had a similar thought before. In fact, I wonder if we could
> have a pointer in there that effectively allows you to replace
> NODE_DATA? I think that would be a more general mechanism to achieve
> that `managed_node` thing?
>

Well, alloc_context already contains a nodemask.  I could see even
pulling that argument into the struct if we seriously consider exporting
alloc_context.

I'll have to think about the NODE_DATA replacement.  I don't know if
that's really feasible consider that this structure is used statically
all over the kernel for runtime node-data lookups from pages/folios.

> My original motive for that was: if we could get the allocator to stop
> [unconditionally] mutating global variables it would make it easier to
> test.
> 

Can you expand on this a bit more?
What globals are you referred to exactly?

There has been a desire on our side (Meta) to make mm/ more testable in
general (for both performance and correctness) - include page_alloc.c

But with everything so tightly coupled the best we can presently do is
runtime testing of benchmarks and workloads.

The same issue exists for things like LRU/MGLRU, where you can't really
isolate a change because you get emergent properties.

> My feeling from poking around in the code is that setting this up is
> actually quite a big job in page_alloc.c. But, I think it could be done
> in a way that leaves the code better instead of worse.
>

Yes, and being the literal bedrock for all of mm/ getting it wrong would
be catestrophic, so both a large job and high risk.

At the very least, using what exists (alloc_context) to extend to a new
interface for new users (unmapped, managed nodes, etc) while leaving what
is there until the new one becomes stable would be a good mitigation.

>
> There might be some annoying stuff like "turning these things that are
> currently function arguments into struct fields effectively causes a
> register spill and this code is hot enough for that to matter"? But that
> seems like a bridge to cross if we come to it, not something to
> premature-optimise over. (Do register spills matter in 2026 anyway?
> I think registers and the stack are kinda virtual?)
>

I'd be more worried about new stack allocations (alloc_context) and
populating it would lead to regressions than register spills, but it's
not worth thinking about untill there's data / it's testable.

(Another argument for making the core of this more testable)

>
> (Sorry this is such a vague thumbs up without really contributing
> anything but I'm just giving what I've got :D)
> 

I requested comments, i got comments :P Mission success.

~Gregory

