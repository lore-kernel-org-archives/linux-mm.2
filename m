Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBCB5C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 15:20:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95DE26B0088; Fri,  4 Sep 2026 11:20:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90F4B6B008A; Fri,  4 Sep 2026 11:20:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FFDF6B00B0; Fri,  4 Sep 2026 11:20:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 500ED6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:20:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BD3AD120139
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:20:57 +0000 (UTC)
X-FDA: 85176442554.01.7E2BA53
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id A7EF1A000C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:20:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="n5H/6KZD";
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788535256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O362rQF00y/JKc7213VDRMRIdmSf7bkWLibT5UwQexQ=;
	b=xF3PW4aDAcIfkpi7ohMFVLc92bSERE7a9Q8LQyWp0biOprfBl+vqJCV1pGg4nAFyPLXC24
	HtCGsf30ga2dXjCEmVBd5TndOWNkBFZp6Ar6Jed7SEU2mY+Bf6cglyE63vBEEcbek34hYx
	NmxuJ+UO8X2fIPqkJbjd3O/wLi0h4lU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="n5H/6KZD";
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788535256;
	b=HXscHLnTZWcXxM1EjaOMkSX42SgXeCTfOL2Qfdg0Qc0CQzVJ/6OIFBZTcZy0OwvDW7HeqD
	PsoQM5lwZdVUCYwbpOGnaJG0YIIbKu8ZqGK9q427N2Y+Vn4BDCsuGWsQzytdOlHmWQb2S3
	JqTS195cL3OLcCvcHwEifQRBcH4Exlc=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-90e8e70fa02so13439806d6.3
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 08:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788535255; x=1789140055; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=O362rQF00y/JKc7213VDRMRIdmSf7bkWLibT5UwQexQ=;
        b=n5H/6KZD+iG1ofTp1HU+D/p6qJoI4AUMSNCv1TAr7J4lH1xbmjf/5CJdJ8I6ZFP/Ej
         DPtI32DFJ8MpDDNTWMC26FGqHrMzaIiIgoCnzcTgK73+/S+aG5ZzaWV6U7G++KKbziYF
         wFaR3qQo8Ua8mw14OawCN+C7S4WWe8iefqbue8UZcX6Tn8fpLRV2JVJlm4RN3NzLS0Oq
         i36Kp/ONe6Z0rAVWgtpjSk7XJVXL/aJH1oqdxEjsSZ516i9IVEVa/PpTJjgMgUL414HR
         Tadv5j+KrUEBFESnL0wz+OX8Ht/tGMgrG0yPYlwL2AcqKIMB8652qvF/C4OLUyXSXsqw
         MEjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788535255; x=1789140055;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O362rQF00y/JKc7213VDRMRIdmSf7bkWLibT5UwQexQ=;
        b=mAN5nudBsaCzhkMPRqHvE0C41iZxlFTcUNrlazrjbbH1lSVvVA0Dd0Y4FUeF0vl0iX
         M3M2jONiL+B9QTI4ZWtwmTyZIrzUstITKdIuu+qv7FpnisyR1f7pFlQCma/TbH0zyORP
         V7+z77YzbHM9i5Yu81rGHr1Pk0le6Z/cGZT1NJb0VpGUu71v+zHp373WCYYSL2tPA21I
         Vs/lRsrDvt1kdjncngtBxhxyrN17XwEbF7syKUwwnYHH2socvISAzKBhXDBsfSRwGM3P
         VPM8ib93INiQ9usYu2cN7aBClEh3J2LoE4VcoceZJu+f9w6wKU8I3lqKZT2BBloTBdmZ
         UAXA==
X-Forwarded-Encrypted: i=1; AKwUvBzBoEb/QI3M0cFTEw6dviHzDXJpCXaACqMyaLte4yCFlOBM8vh9JnB1LEBuJdgWF8Q9yK5xa0zeFA==@kvack.org
X-Gm-Message-State: AFuF++lOXz16AA2ot2taMKFenq1uFWRRebJugFVYGobwEtXIwNrQs3A4
	bnxbXA4dLY5+lXp+VMn1vIwbyTXBh9K7990t/tUJMvqfSqj3hIQodr5B+eeZXL094LY=
X-Gm-Gg: AYBFou0RGVxj4C7xJqcoEnkbRdTf4LAGMFAkoAY3ov5pAl6oIf+STI7G1/tUkERXbhq
	54Ia4niA1UnSg2U9aeStRsBmEpF4pOwQ3E6WQv2v845ht5qyhIOZ9nWMXZDv0PWyVmLzj3ZoX3I
	w92dcUVI9nGIgzKmvf4qi63dHU5gdSzrQLoHLQc6o110Ag4ikdxISrqjBtkiYe0oZQy58dNqAJY
	nRJknEnF4SrO7hPDut1+W2ijqSI96BkHwe6N8KDmzW28mNazddod391vNDOcM+dNwVTde1GvCke
	VF9RvrS9skxEoGBhdrNgMoauBkJQqlI+/PqkdvE4t5XKQrH4ENDanr69lP8JlVMAiOIVBE+eneB
	TMw91VXWpcqYbStftVkJZfEpUyoNHAZAFYED32/zIfna39YC0SDj8Sg5P2z5QtC6rZiWWN7aMB9
	exh5EfutI3bni0o2gO1B3VPw==
X-Received: by 2002:a05:620a:6d47:b0:939:6dfa:7528 with SMTP id af79cd13be357-939804ee530mr481834685a.52.1788535254506;
        Fri, 04 Sep 2026 08:20:54 -0700 (PDT)
Received: from localhost ([2603:7001:f100:501::2])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9397f9f0734sm239642785a.4.2026.09.04.08.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 08:20:53 -0700 (PDT)
Date: Fri, 4 Sep 2026 11:20:48 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Nimrod Oren <noren@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Hugh Dickins <hughd@google.com>, Nirmoy Das <nirmoyd@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Rik van Riel <riel@surriel.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
Message-ID: <20260904152048.GA6641@cmpxchg.org>
References: <20260901190123.3511535-1-noren@nvidia.com>
 <20260901204449.GK3004@cmpxchg.org>
 <C8541A2F-D6A9-41B0-A3FE-52339A6601F0@nvidia.com>
 <20260901220917.GM3004@cmpxchg.org>
 <69C018F5-A1C8-47AD-9567-3497AA6808EC@nvidia.com>
 <20260902160417.GN3004@cmpxchg.org>
 <DL5WUE8JD6MH.3W984LEQQMFV@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DL5WUE8JD6MH.3W984LEQQMFV@nvidia.com>
X-Stat-Signature: zyyixxugp18bzu9h4pfu8is33xiogiwd
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A7EF1A000C
X-Rspam-User: 
X-HE-Tag: 1788535255-168129
X-HE-Meta: U2FsdGVkX19FSATpEBtNz439juTW5huNJZPfVFH2XxnQmRLoHj+Ws9YFidIG8DWhf9sZjL8bO3abNYVUjgd8m8WF2yBmSrGBL3r28BkLTWnY+7x7/3BbFUTVlBL5mXk2++IBpZ2yEDlaFeF9FPLbvEoTjE2I3Rgsm8YlT3nPE1MEu0gtIokhwkMlidVRAjprbPmdDZjj1vVvjCUfzV79pgppJBLoSeio1Xz8gKbu3B4HbJ7H5v10ATGvWzyOVvZrfPy6H5ZOdTWZsCvB/Kuj19VwWtl5tjmw/F7j4eK5wZ2UEVWo5eJV/dvR4NpFqj5nBMe/NFUDkLx3xQIneONy/WAujppd0KHjefgbFC4WCDvMW+zdBL51DOwQ+29KMvA9DWv9vEUAQ6EdYzlj3wWtpdxAZfkdjRe1xQj3U7FTTh9SuXVcnEM0wYIiY2CsJeuy2Ypisdjt1Ty/J3QzuqzfwnUQrMfu2mCHqLWQ8c0W+o8/WNTEWnfD9SUElfFHoFVpnaYj6ie3Su7T6y6BZdseNfowuZh4Zil5kGEuVcVpLrYHC4oyx0zkqp3OhZTHnUGIOjxrhVg5FG9emZNquCwiQOyOSJwaVuqfDn22opIbXgyhZru24taUBSs5oi7IWGnx590qSJuce5nqOQNTbsIzbKqD6NBNoio5DNIKsUdu+Xx5bv96eOUC/e8OJIbIX9By/E1ESgBDH86KNJr5NkPNJZ3CsNKeC2OgWL+ZIp0JMA5E0yuSZBXoMtfKuxL2AstOVj/a39qgRLD5ZhNSjNEfeAdwiAwYmAbsAMO6QrzZW5caTjhtPdSWOf2NkfZfqXdbe+RtnaZsBTBkSe4TwRh9o79qwAWS/yUMFp60EKJGoaLnmoqPRlAcqQGEhSw4/39inQi/LvTyM46vS3Wf3t1baziJnmnUSRiAW6fYokqzk1tCC14DW7nzlfI3YeVOsmqCtq9TZRPXLU3OQxMd6lU
 pFmt0goa
 40bPPwWLA3NGobRU5McbU8a0YFWQmfvXH4nqaAQYjti6m/KsKW8pJDnHgD3uXa1Qtk+xTPiPKs0d9nInP43LKHbcXOseU4CRouNR5QF7upYwSTNdgBy4vgR06lLJptZ6FcBHFXfiJHzmb4RdqkhEGUoVUyKM4qeFhMSSndo02HAcvAlqs9CoUJGowqtuabDvWS9FGLEDgeSba5xfKFfIPi1hk1q3vGvfiF5hSca+3QClVumbRc00YrNNSlXT1loVRmQ9xnUEQTyecDu05ZdCs16WbZsLgOLwqMDY3An3BU11UHgKMUQS4g0rAa8r0dN1u/ti7TidkUtyZ4BTTGxmES1XhypDeZXvYvOEPyL+5uzUcr4pNkS8BDwQCdtRENHo+Y1hPUpkdNTxQfkel9sqhfKs7iyVId9Ne7U0yGW/U7dBzFu8DIHKpe38I5vID2hmVzffzVk2TCqna5nk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 02:58:54PM -0400, Zi Yan wrote:
> OK, digress to the compaction and reclaim discussion. Isn't this 512MB
> pageblock size issue also telling us 1GB THP allocation will not work at
> all? It is a proxy of 1GB super-pageblock.

Yes. I doubt this will work well with the conventional page allocator.

If you recall, when Usama floated 1G THP, one of the first questions
was how do you allocate this. Rik's gigablock patches are an
interesting push in that direction. CMA as a stop-gap measure.

Meanwhile I'm trying to also make the native pageblock defragmentation
better to make order-9 requests more reliable to allocate at runtime.

Both of these efforts are kind of complicated by this config saying
pageblock is now half a gig. It's too large for gigablocks. It's too
large for watermarking/pageblock-aware reserves (as this patch shows).

We're struggling with order-9 blocks and you're saying this should
work fine with order-13 blocks - with a 16x larger page - but with
defrag reserves that are reasonable in absolute bytes. ;)

> I need to spend some time on it to understand all the heuristics and see
> if anything can be improved.
> 
> A quick chat with Claude results in some items for me to explore:
> 
> 1. reduce pageblock conversion threshold from half of the pageblock.
> That can reduce the number of slowpath entries.

That means you have pageblocks that contain a supermajority of a
foreign type. What does the block type mean at that point?

> 2. make reclaim pageblock aware, so when an order-0 unmovable page
> allocation incurs a reclaim, the reclaim will try to get free movable
> pages from an unmovable pageblock first.
>
> 3. in addition to produce a neutral block, compaction/reclaim need to
> repair unmovable blocks by getting rid of movable pages. Proactive
> compaction should do that too.

This makes a lot of sense. I believe Rik was looking at more directed
evacuations of exactly that type. CCing him. You guys might be able to
collaborate on this.

> >> > Seems to me the excessive min_free_kbytes is just a symptom of a
> >> > deeper problem.
> >> 
> >> Yes, our anti-fragmentation mechanism does not work as we expected,
> >> so that we need an excessive min_free_kbytes to get khugepaged working.
> >> I wonder why reclaim cannot get the extra free memory instead of
> >> reserving it via min_free_kbytes. Maybe we need a watermark boost
> >> when some consecutive THP allocations are seen to achieve similar
> >> effect of boosting min_free_kbytes?
> >
> > I'm just wondering what the easiest way forward is to fix the ARM 64k
> > page problem.
> >
> > Yes, optimally, reclaim would work to satisfy compaction space by
> > itself. We've seen it fail at that before, though.
> >
> > How critical set_recommended_min_free_kbytes() is today is a question
> > that neither of us has a clear answer to. It's from 2011 and a lot has
> > changed. However, knowing Andrea, I'm willing to bet he added this
> > based on seeing a need in testing data. And I would actually expect it
> > to work better now with proactive compaction, since that has a better
> > chance of turning low-order chunks of that volume into pageblocks that
> > can be converted instead of needing a poisoning steal.
> >
> > It's a change of long-standing behavior for everybody. It has a
> > regression risk and requires careful evaluation and testing.
> 
> Not for 4KB systems with large memory, since khugepaged's
> min_free_kbytes is capped at 66MB for one-node, 88MB for two-node, and
> 44MB + N*22MB for N-node. For a GB300 host you mentioned above, it has
> 494GB memory and with pageblock size set to 2MB, it should be a nop,
> right?

For single node, normal minfree catches up with recommended at
256G. For two nodes, it catches up at 484G.

I would say that affects the majority, or at least a sizable share, of
machines out there today.

