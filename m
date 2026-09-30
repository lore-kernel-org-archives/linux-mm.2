Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8C71CA5FAB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 03:25:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EEBC6B0088; Tue, 29 Sep 2026 23:25:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79F046B008A; Tue, 29 Sep 2026 23:25:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68E1C6B008C; Tue, 29 Sep 2026 23:25:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E2B56B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 23:25:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A81811A0690
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 03:25:57 +0000 (UTC)
X-FDA: 85268989554.14.9B038DF
Received: from mta0.migadu.com (out-198.mta0.migadu.com [91.218.175.198])
	by imf10.hostedemail.com (Postfix) with ESMTP id 556B8C0005
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 03:25:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SLzA18dw;
	spf=pass (imf10.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.198 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790738755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jer7Hh/yc1HXvxrGzZU0nMO90/zfo7AP6lqU+z1uVbU=;
	b=AVaSB2nnePOdGDmIo5XoDhtnCkb09yLj01KBA/35gtN2/tdMFyNmP7SLdNEMDStn309B/7
	GhM2YGGUcjs+iN+KawqBmCEMSLgkyX8Vl+eX//UEFaCBkCA3Rmyw5hCqPQhAo19akbN5xI
	yH+MyZPIGGobGJlK1gztmx93mkI/vQE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SLzA18dw;
	spf=pass (imf10.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.198 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790738755;
	b=OgqC3NSr83MmezINrkD0hQ10sBnlF0Yr8YhMyaTIeKj+rb4H18rEoqoK+qFPkHVT5e0PD4
	l4f7ir0NdGZrvIsa28GwF2nIHGEDjRahlcGdyplKiuIwfEzU8NQInufEip8+j/szToaQ7Y
	aB5uPX+zwx6D3oHILxhLadoA7rnvd/E=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tmx3X4PgFtMsV+xxZ1IMDVsyAWoakSL8TqQSX2VjB/Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790738751; v=1; x=1791343551;
 b=SLzA18dwU+mCXqj02LPTrThA3PD587eWehE2DOUGWvWMKJ8mgYvOEWdkz8S7ljxvzBXE5/Ie
 QtIcEKxpZPbnbDz6UUZeZf7ttLfTnqMIWQyHlHpDyFsI1nhOZfMf7aqFr+GCOGGqq7dBH7Iw/YR
 iPY0vF3+OdIfN0ykC5jyCUec=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0e3241359faa91a0;
	Wed, 30 Sep 2026 03:25:51 +0000
X-Mizu-Trace-ID: 0e3241359faa91a0
X-Migadu-Flow: FLOW_OUT
Message-ID: <fc4f3d08-393f-43ed-934b-e7e1ba6d0137@linux.dev>
Date: Wed, 30 Sep 2026 11:26:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 0/7] alloc_tag and module codetag section fixes
To: Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
 Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 Aaron Tomlin <atomlin@atomlin.com>, Alexander Potapenko <glider@google.com>,
 Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
 kasan-dev@googlegroups.com
References: <20260929082014.160587-1-hao.ge@linux.dev>
 <20260929134401.a1a385ff4369661f879b5d2f@linux-foundation.org>
 <CAJuCfpFRW3uNUW_VrjpOfLwS1LBHqGEpqK3yBTPSpGOORY5jiQ@mail.gmail.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpFRW3uNUW_VrjpOfLwS1LBHqGEpqK3yBTPSpGOORY5jiQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 556B8C0005
X-Stat-Signature: wgra95rrqnmkndb7duc6ymbihbcs7jd6
X-HE-Tag: 1790738755-531283
X-HE-Meta: U2FsdGVkX18SlMslJJHkepY5PadbiWQGC6a2gkfZKbOV4gWs4qYivX32NEn0r+boSXfygQJMMIPC4+HRCd6gNrJfn7K1REjarXqZDSRVl5amCCLwiVi91z40QhxyyC/svJ/bML6NRFZ+Djz389IKZAvqRqSAN2bjI7vNFlhdr3+M39an4pZx7r+BKiq2uAEZwOEpR2kEYYFak58OwJzGCF+01CrabsY7Qbz9JR3r7C+mUgW0Y/MggZjahhX2QVUuaa0u+1fckzO8cHuXJBYXSPfL+5/v4fvxhgDavnSDuwbcqPvwgbyYGG4ADqt8Ip6N3P9gSSxgS/f2cuQI3I2QXpQtc56rQ2YPJsB0w9qnJEPLS5AeYtUexsPG/1Ww0u+DjymGStNdzWJAWTdoldHp1UM3VCSAS/IPCsWSCbIEeH4VOJ5taZzMFDNneHJCqAAaxGzxspPG8DXgHRFsO1QudlmoBH+K3GCRUZxerryKfO32BO801hCvzxTUn1B68KbRry6gHyQ7qT4hbq7jpPMu6l537zT8fuJ7GtDXFsZ8B2sNOTtJaQ1vNGwlN0sRv4TH2vL2mBrP4ZLRXACaI4XL9byY63zGAfdvnbqU95e3tDRHPszgEx/2jJOe/yTgw+vldqj4iex7Bcn/awAmBz0VNiqRZyGOdCzanzlAc4UeoSuKG0vwd0//1OcdorM8Abe/yV0U/oQA109xxrJlh7rBzLDHJbBV3CFgxlaGjtEVc5Ikh0+xtfXH5AOMV+bCdDJ3JJPYhpeGwXF9inOUw9jgc/nm4ksGFoFFk2TIlC5vzDE8kSCswKGgpY1fW1VCm9mDAoaIhUGy+FDgNlb77bW6pUgIRsXnryQnSvKsdSHMknjMURCuw21fAXs4ccuTH6suhLZLYrJOVg0n12IGUW2s4Nkp4fl6pMmkR7ikUAwOIFoBw1I4lAdcVe325Vs7ZTobRR2OOqup3R6OeNU+DuE
 1qs0ffqB
 p6lrkamYAGrPCKvoL3NLHCwmu3F4yuIuH0+lfJ/tncAQWFx1Bv9KPuFVny/CLUFeWYrIyDuvFKAUJSiX8VPU2Eipb3VrEp6Osd1544fRtg7B0Btzg9ujio8jM9mzgDEM7Pb0xRS34KCcxeUWulbh4VNP8zR5inQs50y8KCdbPUNf/V14nWFCP3DA0DXvzWBVwd7OKA4L7QfNko+hxKMEXcE5e/lo7Z7UVhQ2N3/SV8u2W0vUed0pEAfpRPfYiqA7K2hn7sA+QfQQakP75pQZvMJMfPjGcQF9k48ST84PO5DMuYZjq/a9doKTNHq6ZgpoWMwfWNGIxyJqLL4gu+RrGKlnFIEOL8XQuhfUcdp+BP4Fa5o0+xdx6OdxZJS49JGHjCqoI0+jXNEXoGt1Hdzw+J/jR/vpEtHPipvS1vTSZv9JMi6GJc/O2XvUapjncbYlzi+bXaZ7sA8aH5JzQiYviA8LmD2QC5Gif5hgt9cTvdgfzgiQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren and Andrew


On 2026/9/30 10:39, Suren Baghdasaryan wrote:
> On Tue, Sep 29, 2026 at 8:44 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> On Tue, 29 Sep 2026 16:20:07 +0800 Hao Ge <hao.ge@linux.dev> wrote:
>>
>>> With profiling toggled off, the overflow check in
>>> reserve_module_tags() did not run, a module could load with more
>>> tags than the page flags can address, and re-enabling profiling
>>> then silently corrupted /proc/allocinfo. On overflow the fix shuts
>>> profiling down, releases the reservation and returns -EAGAIN, and
>>> the codetag section lands as regular module data in the same load,
>>> so the module loads without profiling.
>>>
>>> Review of the earlier series by Sashiko turned up more problems.
>>>
>>> One is a race. layout_sections() and move_module() both asked
>>> codetag_needs_module_section() where a codetag section goes, and
>>> mem_profiling_support can change between the two calls, for instance
>>> when another module load overflows the tag index and shuts profiling
>>> down. move_module() then copied the codetag section to offset 0 of
>>> its regular destination and clobbered the first section placed in
>>> that region.
>>>
>>> v7 reworks where codetag sections are allocated, on a prototype by
>>> Petr Pavlu [1]. The allocation runs before layout_sections() and the
>>> placement is decided in one step, so nothing re-asks the question
>>> and the race is gone. The retry is gone too, on -EAGAIN the section
>>> is laid out as regular module data right in the same load.
>>
>> Thanks.
>>
>> Seven patches, all cc:stable.  Why is a backport proposed?
>> Documentation/process/stable-kernel-rules.rst gives guidelines - does
>> this series meet them?  Does Suren have thoughts?

Thanks, I've just gone through this carefully.

> 
> I think vmalloc fix in patch#2 should be posted separately and clearly
> quialifies for backporting as if fixes issues Hao found at [1].

Agreed. Patch #2 was added to this patch series because vm_module_tags_populate
suffers from the same issue. If we want to be more conservative, I'd prefer to keep
vm_module_tags_populate as it was in V10:
https://lore.kernel.org/all/20260915070001.113559-3-hao.ge@linux.dev/

Then we can submit a fix for __GFP_NOFAIL retry loop in __vmalloc_area_node() as a hotfix together
with our new patch #2. While at it, we can also check if there are any unnecessary calls to
vunmap_range family functions that can be cleaned up now that patch #2 is applied.


> 
> The rest are also bug fixes but their size is concerning. I'll review
> them first before advising on which ones should be backported. Some
> fixes address issues that happen very rarely and if a fix is too
> complex it might make sense to leave it be or fix it some other way
> with less churn. Please give me a couple of days to review them. With
> the upcoming LPC I'm trying to multiplex between several projects.

Thanks, sorry for all the hassle on you folks.

Thanks
Best Regards
Hao

> 
> [1] https://lore.kernel.org/all/b8005c24-ecac-45c4-840a-fd282f9693b5@linux.dev/
> 
>>
>> Also, Sashiko has been busy again:
>>         https://sashiko.dev/#/patchset/20260929082014.160587-1-hao.ge@linux.dev

