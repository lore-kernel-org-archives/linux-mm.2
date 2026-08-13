Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 402F9C5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 02:21:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0D126B0192; Wed, 12 Aug 2026 22:21:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E5666B0193; Wed, 12 Aug 2026 22:21:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9218F6B0194; Wed, 12 Aug 2026 22:21:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6912D6B0192
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 22:21:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BBE4B1404C9
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 02:21:32 +0000 (UTC)
X-FDA: 85094644824.26.767137F
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf09.hostedemail.com (Postfix) with ESMTP id DBD50140008
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 02:21:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Ow35OFsM;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786587690;
	b=7/JLNyxKLwO4wq4i7XCDrw3BGgHPb1K9F6Z+fpCPKfUpv+8Do9caqXdWyKOJ4dbiDWyt6u
	DzpO3/3S7JAZ9ZvRRpM5fqTLdW+pnyzszXwsjZqebd7QO7k454aoGXJLookT7lwDFn+eoP
	a+CRILKKYqVqtzE2WDB2JyCj/6y+IH4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Ow35OFsM;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786587690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lmq76BWyH9k4izhQxstGYjoZH3LaJ0p93Xt9P+A1osw=;
	b=zU26sQyHU5il9OSs47Ej0c783Q3NTdt+dEG7uuzll0lJ2JNmVKPzdQloJV3OoUwDx8s8U7
	fYoVBzwhOSvfjmc/Do8q9Ok3M/XPmdarximabPDHS7MGO026ZuHOYOcj1a9FpMB8GdMrS6
	yJxZ7WnGMR9GXA4TsEzZBrcXQmuJVpg=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-92e55b62640so8345585a.0
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 19:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1786587690; x=1787192490; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Lmq76BWyH9k4izhQxstGYjoZH3LaJ0p93Xt9P+A1osw=;
        b=Ow35OFsMU9ONZAp6QvlNS8O+JwTzfNeP23i9RLdZbaDrBf/FmtOPL7bEp33ZqfV4/Q
         6/yg2w3AVo7V8el00SWw+s0KHDrDN41ykW+k8Sa150Dge65qxFf/GFHZE6rbsjZ0AgY1
         FevuuQzaeSMPpouewWiT6H4PR3wYtIMQpgZsL3UgP4AZD12G2SUnY+zJUcAkGicwv8of
         a5CAKQTO0w6tKeoXMFd163+zfPQLU1vFEP6q268SSJcZCbGD6gSB19Wd1JeIm7gpr2SY
         iEMaGTU8DiRVs9P9EbGEFd9tNw6o4uEPQLo/a5tXChdhPGvJkPB2WNUZEmqnOJj72p1y
         3pVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786587690; x=1787192490;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Lmq76BWyH9k4izhQxstGYjoZH3LaJ0p93Xt9P+A1osw=;
        b=RR+4NHHOnKuSJqRwR+G5n2HuFTDbJzfDMrAHe50LsvV9XdXTwzViBaIG0bg195v1Bf
         M8ghSFYcgQpFeADqTWgkhHriN3YJHE722bT5UdocjHcTuWGxmtWzqWa7ivSjWZoYARvI
         Zpm5UI9AW/GsdzLnyKj6D3USOKYuVmBzTvGzEzHeCqv8UW8pOwRwQV8Syxl3sH4ljbNb
         XiLH33ViBBaIBMSqHTKvoSwGKrU1UDkgRLHK8JsH4iMpFEfaR1Q9QgZ1N5PtbRS660iC
         QyFB271/cGmg9S69H3WbgjLIondxoR9GZIfugaPjGnmD2etFKB4chlZKmWAFgdt9Z7m6
         iRAA==
X-Forwarded-Encrypted: i=1; AHgh+RoRj8Hh9I+V2i9TwwjfmR3jbmhFUCaM7eRHuo6QKfdz+frU55DJvELPCkZ509bHo50mCmeEs+UjXg==@kvack.org
X-Gm-Message-State: AOJu0YyGZJiknQ1YAz+UMc5fjAJZ3kiMg+uh59K7eyuf4q2k4krkirUN
	tP7mGEUVU8H686rvTvyQHymjtiUruCOBcXknOXeS/8bd2Q3ZP0KsekrOEoVZGslCO/g=
X-Gm-Gg: AR+sD13Hq9GmQSPRDGkNJFK0hmS8fONxaUk8EAF+g4YIvVTU+QK90XXIGcmQFObLS9j
	Ds1e/vs5/CkC4m5FOmOCbj8l4dpYUcsSS4LxaIPSbguXz5scvUDY5Q1uYEkapXEC04AAdMp3P8Y
	2tcdywihkk4+svp70HT1z5XdQAWnWyMOF+dPbRMd9gCUS9Pj0R6I/lO5EW4+cy3/IwIAW3hZ23q
	G7cJ1pakVB/9UpsN2QdUkwU24HMUNhbUPtpPlMB6GUbz7z/tc2SvddPSRVWXfGPNTKmU08lSBYN
	rEjOnz3oFPsfYP9hrpkdqu5o7gZk9O8HgU5bZnuIG+8lJ+i0Rfuu518BiTg7WFAWS6WKZevWryP
	owUxgywA2+h0fc4P8fEoYJhHYXw4VQhW/f6wA+rQAesWsqiV9Ky6bhPPNRuXknGBVYy8LdNvO7b
	1xffaV7Q6xT/4CFitL4eM6GhSO8XkQIHJ62SM=
X-Received: by 2002:a05:620a:2059:b0:92e:e3eb:de54 with SMTP id af79cd13be357-936bf90138bmr201611585a.11.1786587689928;
        Wed, 12 Aug 2026 19:21:29 -0700 (PDT)
Received: from fedora ([2601:19e:8500:d3c0::28fe])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-936c1b1234fsm45066485a.27.2026.08.12.19.21.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 19:21:29 -0700 (PDT)
Date: Wed, 12 Aug 2026 22:21:26 -0400
From: Gregory Price <gourry@gourry.net>
To: Matthew Wilcox <willy@infradead.org>
Cc: Yongting Lin <linyongting@bytedance.com>, Jonathan.Cameron@huawei.com,
	akpm@linux-foundation.org, alok.rathore@samsung.com,
	balbirs@nvidia.com, bharata@amd.com, byungchul@sk.com,
	dave.hansen@intel.com, dave@stgolabs.net, david@kernel.org,
	donettom@linux.ibm.com, joshua.hahnjy@gmail.com,
	kinseyho@google.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, mgorman@techsingularity.net, mingo@redhat.com,
	nifan.cxl@gmail.com, peterz@infradead.org, raghavendra.kt@amd.com,
	riel@surriel.com, rientjes@google.com, shivankg@amd.com,
	sj@kernel.org, weixugc@google.com, xuezhengchu@huawei.com,
	yiannis@zptcorp.com, ying.huang@linux.alibaba.com,
	yuanchu@google.com, ziy@nvidia.com
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
Message-ID: <an0qJpFYBPL7V-CR@fedora>
References: <amjz7kIDuZH6gBx9@casper.infradead.org>
 <20260810033814.83951-1-linyongting@bytedance.com>
 <anlQp9LQw471t3YU@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anlQp9LQw471t3YU@casper.infradead.org>
X-Rspamd-Queue-Id: DBD50140008
X-Rspam-User: 
X-Stat-Signature: mckok9aq43j9ckqi6hkxcbgcg8sbw1mo
X-Rspamd-Server: rspam06
X-HE-Tag: 1786587690-374244
X-HE-Meta: U2FsdGVkX1/53Myyv87CrsBipWTw09IHgbAkkcKpQrx6m0e1J/xSOi10TSudTiC5q0MXheklG5/1oLjVovsMA6toWYbFR+wYsX9ZGvBT4oluqBmMGHw5mGVFHdTV74L3hW6hun1A3GUm0BGTLA2BYXQmowP5lQoV6UYBiTUFlWYEKdTmZxf+L5qvh5EgWn05v56oI8hQ4Li1HDQSwpaf2Rok6KjXLoCIIHXyQTvy0aS0I63ydG3DM8hG5zx86fy3JB2Hh+odU7hUZg4R0Leuu1S4VGtcIh17PFJHCoREnqVY3y+i3wy/WV2BKz5M4iZ0/ftKjs5gIZ6L3YB2R1+O1aOJXcHH/hUQJZFmZVXeEhZSkK/boqcKpEsHVIa5up4xWkG59lV6hUTjaDjMkHnF+xgnZlcAJtg6xF27FQ5CyoLJUDXY2g2rzZXTpCQyIMMxctjzBaGJ1QNrKYw3f1wZWTlZ/SqFCXHf711ZUiWyNVCVx/vGkwLYW/az/b4l33mlveJf6EfPKmAUoOvsTvaSpAND2R+ScytM5Yi24sf6Mag+OkAepmGRw2XTT/fc26xMTn2BhGunKZBfj/Hoe+6B3auIQZS9J9b7yreii18iGYAxPkltcIjgSboI2RlXxHmFsLnnSJa5bIQLofD295fHJ1bU0w/csljMijGiA+uXAcmQALwnvsJAaSwLQiznGxYJ7eNQbUjvgoRtMl10viRJD5uM9tfJY/8G9dfM3q11/d8QA/u97lLH2IbVviQVh+ZuC5x8iaq109met/24zeQMRLBj5ntH45MgQbtODiD32bARoIEkqzWRrhaKx2PfsPQ4rkWf7OzYiH2Bk2wzu3dJ1SuRmH/O8xy3MIreEfSPTgkRdFwuFbQGSw6s5sXuxgO28XjntAY6uDWb9vdht32KTwHh361kEj79K5pLM5FvM6UB250UNheMgpEndNMpPIjo93D8y5qh7lSWZ2vHLNR
 s0Y9EBUa
 IIWxReBHfV8zswB3ak7JGhBZxzGdh68QqaXnHzO6wUAS6aqu+LCoMrhxwmqj9ek4tBDcXvRgB8NZHnvQSm7piYuiSDnTSSMJ6D06WZkRG0/E0w3Mjp9DhDRlxRcEyNjsrYi185P1sXpYyIIPczgMVcjoYmrHd+zHIQAK763lYrSvcd4TteJdufH8oPcbNxUT5qoCUMyKDD5A9UWdBHZD56do2D8y2VlovPFrTqIoBbjo5Vik6ctRT/urIvim3o3oRGaAEXiomFaTyeS+2i3c78BtlUOyWGBrqv9F+urmAs50hyp75eOH03Ep8bWsgAQB2w+RdPFOphdsdW6HkMwtF30zYB10isAepJuKzIuO7t5Hbs57fpjVRPahK9DhcYn0AcCmwEWYatSX/rlolNvLNrs3LYHUxQg/JcgaPt9K5xY2QvvpsNyev617uaiD+sqC1YrCbt2SlUsGPsUs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 05:16:39AM +0100, Matthew Wilcox wrote:
> On Mon, Aug 10, 2026 at 11:38:14AM +0800, Yongting Lin wrote:
> > On Tue, Jul 28, 2026 at 07:24:46PM +0100, Matthew Wilcox wrote:
> > 
> > From our perspective, this is not merely a hypothetical use case. We
> > are actively developing and evaluating CXL tiered-memory systems, and
> > expect promoting CXL-resident pages that become hot back to DRAM to be
> > a practical requirement.
> 
> But what *is* your use case?  Truly hot data ends up in L1/L2/L3 no
> matter whether it came across the ridiculously high latency CXL link or
> from regular DRAM.  So we're talking about "warm" data that's presumably
> measured in gigabytes (since current server CPUs have about half a
> gigabyte of LLC)
> 

Speaking for myself (not Yongting Lin) - our use case is pretty straight
forward and deployed at scale today, with plans to expand on it in
future generations.

We have systems with 1TB+ of memory, with a 768GB/256GB DRAM/CXL split.

We're expecting these numbers to grow, along with density of work.

On these systems we use both scaled and stacked workloads (single and
multi-container) where we do have a decent amount of warm data landing
on CXL. In fact, we're looking to make that a more explicit scenario
to reduce per-workload variance (higher floors, lower ceilings).

See Joshua's Tiered Memcg Limits work [0]
[0] https://lore.kernel.org/all/20260807202059.2620949-1-joshua.hahnjy@gmail.com/

Right now this works when mixing workloads which largely use mapped
memory, but for workloads using unmapped pagecache, they end up
permanently demoted to CXL because NUMA Balancing can't promote page
cache (but reclaim can demote it, and the page allocator can fallback
to CXL).

PGHot at least gives us the *full* solution that NUMA balancing does not.

> I see the basis for saying "this task is low priority, it gets its memory
> allocated on CXL" and "this task is high priority, it gets its memory
> allocated on DRAM".  I don't see the use case where we're trying to figure
> out that region A of this task is sufficiently warmer than region B, and so
> we want to demote region B back to CXL and promote region A back to DRAM.
> 

We find the vast, vast majority of "low priority" work ends up pushed
out to swap / fully invalidated anyway, and not even taking up much of
any memory in the first place.  This work is not the problem - it's
usually things like system updates or monitors etc.

Actual user work wanting X-GB of memory is almost never willing to
take the latency hit of 100% CXL - and even if you did that, you
actually cause bandwidth issues for the rest of the system due to
limited bandwidth compared to local DRAM.

Something to remember: Demotion does not respect cpusets or mempolicy,
and page cache is owned by the first-toucher, so cpuset limitations
break for page cache in general.  (This is one of many reasons I've
been exploring the private nodes series).

===

For actual tangible problems: 

We've found fallback allocations landing on CXL is preferable to forcing
reclaim to run and demote to CXL before a new DRAM allocation can be
made. e.g. zone_reclaim_mode=0x0 is better than 0xf.  ZRM induced stalls
are just always worse than eating a CXL page and moving it later.

This directly results in hot memory (in fact many gbs of it) on CXL.

This is especially prevelent when workloads spinup after the top tier
is already / near full.  The tier-aware memcg stuff should help with
this, but it still requires both demotion and promotion to level out
the usage between tiers to an acceptable ratio.

I'm not looking for a system that can predict the future and maximize
performance.  At best I'd like a system that nudges placement in the
right direction over a long period for better workload consistency.

> I particularly don't see a case for trying to do it on single-page
> granularity.  There's just too much damn information to track.  Maybe at
> a 2MB or 1GB boundary, but not per page.

I largely agree with you here.  If you look at the other work my
colleagues have been doing - it's been heavily focused on making
THPs more reliable and even pushing towards 1GB THPs.  We're getting
to a point where 4kb just doesn't make sense anymore for many things.

~Gregory

