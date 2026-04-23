Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C628FDEE21
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 16:13:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E1946B0088; Thu, 23 Apr 2026 12:13:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B9866B008A; Thu, 23 Apr 2026 12:13:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CF1C6B008C; Thu, 23 Apr 2026 12:13:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4CC646B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:13:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ECA01120316
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:13:17 +0000 (UTC)
X-FDA: 84690315234.13.C8DC566
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 92A9FA0004
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:13:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RdSYkMAY;
	spf=pass (imf15.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776960795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BPpcyNNw5A670ehN8KSLpk7tEoT3MHJiCv2Fb9unNrI=;
	b=N6/KFCuyf8o51H4u1yeEVB/qJH1xgn741Gvn+XI7ELgNlDOObmryCNwFUDzTSrUEgShB5y
	EhDSF5UpO/qzVlXAgOp3ZLCZDVsOAn0LBZXQTdODNaoTeKPtg84TsiB3HVZxW7nIBv/qWm
	zwsDSAQTFNan2f8XAfvw+hVoczNahmo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776960795; a=rsa-sha256;
	cv=none;
	b=CTfkSyvdPuTtA91ofxWmEKYbEg9ABXDGC70c9/xVdHvss0Q/+H3qMvsp92+9sd1pG17lEB
	iukGEjRiL/jAREpGw8YW+r5phqi4lnOFk9rpgU/KtXoHcJwZlfO5chH3PMo7Q3FCb6xTaL
	nnk5cjyrR2NBelW811X4UoBTCPk8B0s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RdSYkMAY;
	spf=pass (imf15.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776960795;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BPpcyNNw5A670ehN8KSLpk7tEoT3MHJiCv2Fb9unNrI=;
	b=RdSYkMAYbPFDSChp+Imjid9pH7LtJlns2Fhp2THkHFxHG4XD2v9uBZ0EEylfx8EGMaRE/D
	cgj+7KFY/mXR7NUUhUiZpc1cdX0aUAOazdJwJMtLBMYh5CsZ8mQx2lPNo6XD419sz/xDx5
	rXboEEQDQqOjF0Jx9/4HFs6BMsSdXnY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-244-G78vBNrYMt6i_kQvV1cVfw-1; Thu, 23 Apr 2026 12:13:12 -0400
X-MC-Unique: G78vBNrYMt6i_kQvV1cVfw-1
X-Mimecast-MFC-AGG-ID: G78vBNrYMt6i_kQvV1cVfw_1776960791
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48a588ff84eso22491295e9.1
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 09:13:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776960791; x=1777565591;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BPpcyNNw5A670ehN8KSLpk7tEoT3MHJiCv2Fb9unNrI=;
        b=G0GLsL32Y6EUq6FY4B0iYvcbI4tCBj77uyz247jieeboMrMNV3fVRsUX66HSwmfO33
         IUINZ0IFN5MJ432P1Icd10l+pTOlVnXBJswcHLsAwP97nx9THynA2JmVmuPkdHCi22mh
         bWHaMMllt9BpYnz+GTj2UjcD5hTpTUVBjo10LQb98GhZcJQNfhTm3W4Ugc3J9HfgWr4j
         o9ClH9yHMvMPtfY3bNMagm3qnpPQ6wgaXTEpHdrRHj5uTUbcF0OR9fdploa7KI/r0F8U
         Ypad91pSZ52H7lX28AvNjopD/LI8WDf0ZGPIsUhhTtKOMWhxOxNvJ8Hz13FRhBx8jVDo
         7/eg==
X-Forwarded-Encrypted: i=1; AFNElJ8R8plluz0BoqfWDRebemNSZ3Gfe8taG4f7QUW73xstgESjbwC0qEZRTe2CXw7wxoqdKBHnOnLVmA==@kvack.org
X-Gm-Message-State: AOJu0Yxnyw8pqPKBVYGrqpBiWxtq+DZrA6+KgrRjjigRFcRXi7prkxYU
	Dg1sQTzypDG35d19rGry+aqG53SuJyc3WJSpHq/RVvA1PFLSqt1PpWaoj0rQFr6AZ49UYljWlAR
	b+QO36jNVXqEOBtaVVIlz4oAKaSiBPtx4iRyuyr/7zOv26jzAO5Ee
X-Gm-Gg: AeBDievI2luseYknPGoCLYueZSvRLSKAkWIAx20yqbwkAiqfnx3nPVtHeuGiwACL+Ff
	tPdZcSnAyUiKosxPJvlAd6Hhp7ZDVY5feZZW1etojO3cL99bchrWO1mOlo1pWwAUU0T5mIN6og5
	qszEO5LMML8gAWhslNr3yBYrg0PA5NisJYR3UvoPC58fJVR2HmUypwpC2GpArq4JuRAADS/pta4
	swFR5K8L4D89aOHW+OfCnkgq2DIraJgtgrSCHPoulREpjbHphhkpqz7nOpi6uH6pYSV3q8NRAiL
	kkAI0zPUO4y3TZhd21Y+Ion3VNjniMrVQMYeM652yUfb90KAmaT3q1HMnO/KqtpS8Fuv8oLZPbE
	VemIvGqPdl5bh0zbQFrZ0TxnpRWoC3nPFgkPietXq/gg46vulVEIEEw==
X-Received: by 2002:a05:600c:1da1:b0:488:f453:b976 with SMTP id 5b1f17b1804b1-488fb7844c5mr438077585e9.27.1776960790555;
        Thu, 23 Apr 2026 09:13:10 -0700 (PDT)
X-Received: by 2002:a05:600c:1da1:b0:488:f453:b976 with SMTP id 5b1f17b1804b1-488fb7844c5mr438076745e9.27.1776960789978;
        Thu, 23 Apr 2026 09:13:09 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4891cdfcd50sm122342895e9.9.2026.04.23.09.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 09:13:09 -0700 (PDT)
Date: Thu, 23 Apr 2026 12:13:03 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Hugh Dickins <hughd@google.com>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC v3 01/19] mm: thread user_addr through page allocator
 for cache-friendly zeroing
Message-ID: <20260423121222-mutt-send-email-mst@kernel.org>
References: <9dd9deabd42801f3c344326991d1431c3d8db39d.1776808210.git.mst@redhat.com>
 <aekluxNPxF8CN8fL@gourry-fedora-PF4VCD3F>
 <20260422171315-mutt-send-email-mst@kernel.org>
 <aemglPlcwFFHNj1A@gourry-fedora-PF4VCD3F>
 <c165d6af-4a35-4a41-9086-ee307640c044@kernel.org>
 <20260423074433-mutt-send-email-mst@kernel.org>
 <aeohzbmhQAoOODPm@gourry-fedora-PF4VCD3F>
 <88b0765f-7cfc-4e44-83d2-c01a1755c842@kernel.org>
 <20260423104120-mutt-send-email-mst@kernel.org>
 <1ab6e58f-d984-4bae-a343-1b0d3c973ad0@kernel.org>
MIME-Version: 1.0
In-Reply-To: <1ab6e58f-d984-4bae-a343-1b0d3c973ad0@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DsLQwDhvyC3svmagsrf400Wj8C6vGc7AAcJa0ybzGO8_1776960791
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 92A9FA0004
X-Rspamd-Server: rspam07
X-Stat-Signature: j9fjybq4dj6s4bgsy1ycqnidwihj44du
X-Rspam-User: 
X-HE-Tag: 1776960795-975133
X-HE-Meta: U2FsdGVkX18HeB4N2/kE1gz5JB56Gt4D/Lp37gSyq+CklZhMPTI2iVYkPhdxiRITo+CuHRDna7oki+Q8YjtR1r20sISUvrGOqw2xKOm5RCWT+JgunPdfG7w4vIWur+iVNxvkQWUJUMMgiWqVW+yW4r/IkLflwtqeGkH6cP+rlRqVOvPApRkh9B4aXGdXShmO4n+2QArzRjk7KWpacCizhj2NUt1ci2mLf7xvxn5HZFog/1I+J0vJZ5NcDAtPMQlO77AKE8RzIdrb7/rcbVVIOl30idhy4BRijJuTKiAcanR0StG1+N292IHPL1HbN4N4Igl80j2WSjm1Es9ARJzxI6qmntsWJU7J1iegqg+GOKka6BHHTkqPIRTgZvKEhI/Azydx0RqHMVW/Kk1qk17SxNQa7BKPDvc1HvmqNk5dy3OSXIOQjTl0wV+yIgnPPq/l4P9pLLzzedhroc4cZlK0Rr0Qkh47DN4XOklq2oDOoc3NRQlwtK4pPQh+eShy1L+PomIj85mGGGH2sx8RAK1J2Q/hA0cqI3WiaJv/ofDpsE1pJCCq5M5232PwvCHCs8NQnp0pVpjGeFS9EqXj9KIhGeTRTR33pDW0p4jRsyg3zG3S0KCuLqI9H/lSV9JWsoxT54Vgx00tb4FrHn2tnbUsM4csK3dwkj1oB9O+UXHCU2/AhnhHl2Lp273ID1X+H+rJuD2nT7xlD2tbbxekL6J/T2RitrKalsAub0QmZg6lyAS3weqIXJKT2nd/WGTYJ0Kqr90HxESsMGhNhKDVbGg7r77T+JHZMYMEfNanGj/1N133GuS09J/ynMIlS8fOKT+UNDn/aAXqqgRc37kcHCBQnLF1Vo9QZJ0SR+YDHkeTdffcjMuaLbpk4drAMRLvP5aAOhOpeY23Y2ofWCba/CGmfAV5F1S9aag2ShIvSDOo05eHQLi84X3J7huInnXrjOTUlIiTY8XtULizWs6kMN1
 YhUgEHBV
 7VFo9Ee8iJ+l53KWyZqnRpxPjwwpL5ViK5F5wuFuR75gqKA4/kun+1jlSFR1wXo1ARDSFCRLgg4BE6PjqmRxCkb4dMDrUJoPRmO1Kr/Lhs60OTdoYZ0gc4QUHFw9dNO0+4uwbGqjJPbX+NjlGlPIGtVoKHYj0tvFjBXXD5tNRV980Yrf/oNxwL2XDjnRqzabxHUc1pv1yrzf9aVg9RueAnmR4XnaLwZFvjzDjmNdnY0AUvEpYNF47OlyvzQmcI/bMvmTAZINDovtQTmJF82IiQl7w8TlNS9iGHtbyHLfvxcs56TGktKLUzlGBmCYRjR4reNQnyIYyVveGXK6/3WqWbDERrfgE+flUSqyKFdEAO5mdIDibLIonryGHPUAS0q2GV2G5WwWIt8jL9742NRAgw4ap/LA8E7WIX9cF0sEp80VAshjj4iQBKL0nwltRZUCYFQl368odMd6Qnww=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 05:54:26PM +0200, David Hildenbrand (Arm) wrote:
> On 4/23/26 16:46, Michael S. Tsirkin wrote:
> > On Thu, Apr 23, 2026 at 04:13:50PM +0200, David Hildenbrand (Arm) wrote:
> >> But really, that hugetlb code is rather messy. I'd vote for leaving hugetlb
> >> alone on a v1, and focusing on non-hugetlb first.
> > 
> > I just dislike it when things are non orthogonal.
> > People are used to: hugetlb = same perf as THP but more predictable at the cost
> > of being harder to use and using more resources.
> > Here, suddenly, we have an optimization but only for THP.
> 
> Note that we also didn't care about user_alloc_needs_zeroing() with hugetlb so far.


You mean, that it stays because of the reserved pool?

> It's not that it cannot be done with hugetlb, it's just a question about how it
> can be done more cleanly; and that requires more work to clean the hugetlb part up.
> 
> Best done separately.
> 
> -- 
> Cheers,
> 
> David


