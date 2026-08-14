Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FA9AC5CFCF
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 02:38:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 161AE6B02DF; Thu, 13 Aug 2026 22:38:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 141D86B02E1; Thu, 13 Aug 2026 22:38:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0769F6B02E5; Thu, 13 Aug 2026 22:38:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DAFE46B02DF
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 22:38:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 53E98801CF
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:38:02 +0000 (UTC)
X-FDA: 85098315204.08.434DD18
Received: from mta0.migadu.com (out-244.mta0.migadu.com [91.218.175.244])
	by imf01.hostedemail.com (Postfix) with ESMTP id BAB3240006
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:37:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ox2Zf4ld;
	spf=pass (imf01.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.244 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786675080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=inN7P3TfsUsGRNKFOr6MP4ieyFCPAJ+egT8wRxXb8kk=;
	b=UATS+OcHs2cr5Ly8ROto9//ACyEcFKpWWGHXfgAQ0YIErF9YtZuqtsJa2sIvTDCDpmEDX8
	ST3lf4ExFsmJaRfpYqpUIKFYLmNBIyhwptbQ2wJvDAVjcysQvoEigp70Wzs8QJkj89Wrs+
	kDwKb3z4tmJDjQuWpR2F4P5oKLsgxmw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ox2Zf4ld;
	spf=pass (imf01.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.244 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786675080;
	b=4S4qUDwIHVTE4v6yHtWJClykt7m5focESg/CC+n72iywuAOc6OMQu5eGL+4iUBMFx9RK5z
	k5Q53GccH3J6erAoNMNTGLhoSAVKrrwn+9IAme2dc7cv+zNfrz/FrBm8JpzoMa7wOXEi+o
	apjQ5LFZJhnRJ8j8XnrJsvLf6dz4JDg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kI0iu1iUjPc4aD0Lcu79SEz4UUJgr3m4G2Ca9n8R5YU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786675078; v=1; x=1787279878;
 b=ox2Zf4ldjELrXnxfyFMDsK2AxhlfMPKYwI78NM7GO+NcP11fVN+eWr3FMVucqONVYCoUuSxn
 AXFKivAj+7w2paUQlVAAJimnHCFA5sMOnvlfayVck0dVGd161ay4Adi6h0VWgdP74vIy1lrCWuI
 0eV964gxwyI5Sd2Nz6FOhRjQ=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.63.123.245] (14.29.108.90)
	by smtp.migadu.com with ESMTPS id f6b06a7b15b52476;
	Fri, 14 Aug 2026 02:37:58 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <76dd9011-84e3-45ac-a9a9-a772e5a15b1c@linux.dev>
Date: Fri, 14 Aug 2026 10:37:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/4] mm/vmscan: fix swappiness=max and clean up
 per-node proactive reclaim
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Zhongkun He <hezhongkun.hzk@bytedance.com>,
 Muchun Song <muchun.song@linux.dev>, Davidlohr Bueso <dave@stgolabs.net>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20260723045718.2052070-1-ridong.chen@linux.dev>
 <20260723171842.137e45eb36b21b3b45245da0@linux-foundation.org>
 <8336e48a-ab3a-4db9-a7f9-5bb6af2b22c3@linux.dev>
 <CAGsJ_4xPw24afGLZH6Qh5rxOts37SCpmBVeB3gGntk1QQuSCow@mail.gmail.com>
 <24b9f213-96e8-4eda-a20f-8746d7c399b7@linux.dev>
 <CAGsJ_4xCi1TzV0sg=8ZFhfAq7v=k=Q6a10DNDouYOrjcJL-5=A@mail.gmail.com>
 <f42dd57c-29fe-441c-ac5d-d4f990b7f6ee@linux.dev>
 <CAGsJ_4zSEutDjM0rwfDZrzDUzJvPSFsU8Pcr2kBJiOmG81CY7w@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4zSEutDjM0rwfDZrzDUzJvPSFsU8Pcr2kBJiOmG81CY7w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BAB3240006
X-Stat-Signature: 6ywfxcydmcyru7y5tbjicdff7zhbpo34
X-Rspam-User: 
X-HE-Tag: 1786675079-706902
X-HE-Meta: U2FsdGVkX1/wr0+g/O0ZNI0MimB1GgOSjf90xRT5Ym9GVWWyAFjt3tYsF7ly8G3I3P8fB8rxPHxHjFZAtii/LXS+a5FVDagQSEPeMf+HxDIDb/xXSBkt9cbmG8iZalv+0oPkbeFWeWmRI45ENWqycE+aczkBJ76qGecC0Oiz12iLVeIycr33VblhHWz32it+5+u7cHBbXFvXtpTEykyIyQgibOsGZbs30BIRPsYoFTdYZ0RSCIv0Nqq1kr9yNAQyiPHU/LgJmx6yAoMGqoKjZJe8mOj1+vR2RKI2TP0kTTDMtpxpP6eDghXbcAHEwE2m8ORIB9NVHk3tcnv9jAjLEkUwGrCfict73YLL2hZHN8Kp/0ZewOBtDMXNq7ChEmXU9Rv3DolNxJnU2vp25fHSGhVQrvyvA0jfkj4PcEgkYx3OQ4Y3kYfa/pFhFe77vDDncZDPm20cLI1Zbj8MReyVFtSUw1o7brZt9m+cCSKtJuTTh5FkgwxNSpYln1LMzcz2PLsBJwWKFAyocab2o+E4TcttaNgMgrzIlFYd5vwOTRYANl0K7KNvk2Eh5lV9rYdxzctgiboiBWxAbAEMYl5Ou3SvKuWT10umsFDWxYWMWu0Z/52cPk4MVzsCXUEUMSBe4Hkz/lzY4FNeu8ZOeRbOV9e1JpL5oUBh6zXVpNQCr/cT6dP+6MO6wPn3smp+2AlKAdwIPsKrCLL+YNo+0VET6W5tCIsJbvDjKWWkod1z0Xt5e4lDy7tAQHfpWrtwxOzF8+r8mXnq5JdAW9ny8+xbTsA0CPO+CIh3e2jc0Lcp6GyEUigJipZiag+8MTHlX8V9WgXXuZTb56lidhtC8s8bHutuIofqsVElKwTypQMEX/UceK5Q6wByjggo0XCyGcZ+5Il+mqFhbBIgraaoL5sFVqfIbQ6uJlRSufbhoMFb7z3qEU/0eE/wPiW+YqG8MecenxaRFxy7E5Q75/pHZ6d
 CwmLzmtm
 8UZRS+0lrC7oZonSKOkMOpZ4o/YWCF/dJBljyz5Fn6mpXeh8CdlD6oifC3HNkJT5mEEXaAwKXw3BJxdJHGC0I669NAsxstKGx9Z9DxP0kzaOGAY/0dF+NsAggPFpSt88yin4XnEu1vnhqTBQO+yRtVxaJ2KYVmVH4JqAnUuSPP4bv261nC33Bp677Mm7oBJwWmBiok71GTh7pnu2+h9QTkejYGx/I1ynoMuAr3t0hpfvTkPdW7++m6oCsNMscBB/dV5oPK9wd8vPp0P/0R782bezyFt0PrXJMptv3HlIRxvkvQ012sH2JXrLK8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/14/2026 10:23 AM, Barry Song wrote:
> On Fri, Aug 14, 2026 at 10:03 AM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>>
>>
>> On 8/14/2026 6:37 AM, Barry Song wrote:
>>> On Tue, Jul 28, 2026 at 4:34 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>>>
>>>>
>>>>
>>>> On 7/24/2026 7:12 PM, Barry Song wrote:
>>>>> On Fri, Jul 24, 2026 at 10:43 AM Ridong Chen <ridong.chen@linux.dev> wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>> On 7/24/2026 8:18 AM, Andrew Morton wrote:
> [...]
>>>>
>>>> So can we add just like?
>>>>
>>>> if ((sc->proactive && node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) >
>>>> pgdat->min_slab_pages) ||
>>>>           node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages ||
>>>>           node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) > pgdat->min_slab_pages) {
>>>
>>> I feel both pgdat->min_unmapped_pages and
>>> pgdat->min_slab_pages are quite broken in mainline.
>>>
>>> For example, even when the page cache is below
>>> min_unmapped_pages, it may still be reclaimed. Similarly, slab may
>>> still be reclaimed even when it is below min_slab_pages.
>>>
>>> Also, when both the page cache and slab are below their respective
>>> thresholds, node_reclaim() may reclaim nothing even if we have
>>> plenty of anon folios available.
>>>
>>>           if (node_pagecache_reclaimable(pgdat) <= pgdat->min_unmapped_pages &&
>>>               node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) <=
>>>               pgdat->min_slab_pages)
>>>                   return 0;
>>>
>>> For example, if slab > min_slab_pages but the page cache is below
>>> min_unmapped_pages, we still reclaim file pages, even though the
>>> comment says we should not.
>>>
>>> So we are not going to introduce another broken mechanism.
>>> Maybe we should start by fixing the existing broken protection
>>> against reclaiming slab and page cache?
>>>
>> For example, Maybe we can skip shrink_slab when node_page_state_pages(pgdat,
>> NR_SLAB_RECLAIMABLE_B) <= pgdat->min_slab_pages?
>>
>> And similarly, in get_scan_count, we could avoid reclaiming file page cache if
>> node_pagecache_reclaimable(pgdat) <= pgdat->min_unmapped_pages.
> 
> Yes, probably something along the lines of what you're saying. Also,
> get_type_to_scan() in MGLRU.
> 
> It's a bit surprising that nobody has ever reported a bug related to
> this. It may have caused performance problems that we simply haven't
> realized were related to this broken protection against the
> min_unmapped_pages and min_slab_pages thresholds.
> 
> I guess this fix could improve performance as well. For example, when
> the inode and dentry caches are already extremely low, we shouldn't
> keep struggling to reclaim them and waste time there. People have
> already complained that shrink_slab() is slow and suggested having
> an asynchronous shrinker for it.
> Maybe it's related to something going wrong here.
> 
Yeah, good point. I'll give it a try and run some tests to see if it actually helps.

-- 
Best regards
Ridong


