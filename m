Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4E1BCA6018
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 11:29:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E94C06B00A1; Fri,  9 Oct 2026 07:29:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E45106B00A2; Fri,  9 Oct 2026 07:29:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5AEC6B00A3; Fri,  9 Oct 2026 07:29:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC86B6B00A1
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:29:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4A27D1C3736
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:29:17 +0000 (UTC)
X-FDA: 85302866754.07.5384ECF
Received: from mta0.migadu.com (out-238.mta0.migadu.com [91.218.175.238])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1ABBB1C0006
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:29:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oIAtzHD+;
	spf=pass (imf18.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.238 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791545355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3lZQEAXM5d3JKKOLgek0em0QcuT2R31gaDHkaPER77k=;
	b=1NKw1YivxcK37XdKMSGcy8ec/xYQXKlj0k+jDOGTqgSJWRgWDeMz+Nqz0C4Gw+tguU2CNx
	dJdwlH6UuU3yN6a50ExYsWvZUcmeflQCzfQHo7w8hV99QNmCZovaZNVCzDrW3aiC42hKk1
	DFCNgO2P3gZEdz/TRaRsm94qfa7eB+0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oIAtzHD+;
	spf=pass (imf18.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.238 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791545355;
	b=YTsrjw7HKq3sRLd7DyYsqrkwfi7WCsP6p5XHxNsbsjonN3Gc4StsOCVLpQzpzxFypRuCqT
	MUgpRLcXr1xjGkibbYufvyeZfSgfKcPUpMKGrPMphYb8E6uSp1iJGX9Q6OW0xtz/bBCc7T
	R0Pub71hdWDogkjSkG45+udqxMkRIcs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9x2VgaCQqq1qe9Sd3mI+ji7pCRHxHu0WOqvf+sHVC10=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791545353; v=1; x=1792150153;
 b=oIAtzHD+uyGDbZl2cSPP5H6EUsoC6yqhf1U++gKNvFIMGOyKEhJClrLnVuvCY793VrA007Y7
 5eas06fDn2HdlS0g6su4jxWsW63kqxYajDnrDpvqWf1nPUNL8H5v6V5Vf43MWNRIQPhU9aYyojF
 tf6q36X2dohhfQoMuRkM9n0E=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 13a9e522eed7582a;
	Fri, 09 Oct 2026 11:29:13 +0000
X-Mizu-Trace-ID: 13a9e522eed7582a
X-Migadu-Flow: FLOW_OUT
Message-ID: <839d13ef-8ca3-4e58-9bd0-84137f2d6866@linux.dev>
Date: Fri, 9 Oct 2026 19:30:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 0/7] alloc_tag and module codetag section fixes
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Kent Overstreet <kent.overstreet@linux.dev>,
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
 <fc4f3d08-393f-43ed-934b-e7e1ba6d0137@linux.dev>
 <CAJuCfpGAZUcQnursYh=rvp+EzckvDmXX_KveJvEuyjzzG=9mww@mail.gmail.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpGAZUcQnursYh=rvp+EzckvDmXX_KveJvEuyjzzG=9mww@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1ABBB1C0006
X-Rspam-User: 
X-Stat-Signature: pt61uxqss61ai3dnyzbbegpfa9s3hwiq
X-HE-Tag: 1791545354-126993
X-HE-Meta: U2FsdGVkX1+OT2xBY8dghsC3pVheId6zlmZhrUc7PG9i9d4NMVB24vucypq9G4oNos+atbRzjPXtikUuShY5PQmNW+Rkt9K1KZHhcfvVc9lKTT2UtDeS/hGX5pxmallq4VajjMd9LECgHwP8nSP8s38NzizuKKoyl/QrX1Nu6y0w8RteQ7uL+gyIP9jdsja7Jjxw4+puPsEIuJXKwuTwKecGpH08t+w5UMgUl6cp91bbfrvF9b4feuCU22oJqpz1UN8luAJksF8MxYD6mMYipEWFPj9Q12+ypl29ZHouU7ftExH/TVP2Pp0xroEupHtgYBbwBwT7YM0V0F1E+Nt3gwzgrBMrXsD3VujAFlwNaZ2nnDQK7Q6+PMwdHFsuZxaKeTTT3pRzVbarbo+COPQJF7je8BAUcHjOD/5AdC4e/6kVTQbn/EQ2YHXI6LoOvK0D1NNSUW3IFrOV2bodIYqSqByQR3Mgp3Lu8ovUlN1i2v0EIpYOWeovu/cDrrR5dVsR5kwePqbFK8Z/OmarFdt9QJibA3btw3pGUP0Mg/7+YWXkycYApR+NyGG0aVrDKHOKlrOFw3bE7s4UjUfYzWngRjGJQJO+lqibwOaPnGITenaHL473lwiRJeLz5lS82obfSm6if/a0JwUMYZkVfNMSE6nJGJkSCCsNvNDH067wwB/oNXpiJODyIzsKYoUvFkYsqGOGd1frf/NsrnKQW6Lr+soHmjN4W0ckhgyx5fO/MOv3BqCpEQ9MUeWKmzzzdeuk8v42LMREvECF3A7hc3WUBqodqVt7RMksWCFxP8x8T5WuSa1iFEeVGA1+N4tMjbXyTtPLyiEqgvQwL/yf/+L56QyixrLPwWsNQuChZqRS89jCcrhz2ipvIzE7zn6I3IxIGUEf/N1u2Hd5FXnAesNJJi6UQr6hIWLZSdSHFQitfvlGl/0qvwDokwUFt5Mv1k9gYWiJjx9MNH4NEF9h+nM
 iepd1zpl
 9LnC240ftHYcY82y3zfH1XYj26eibU+zthNFg4XXg2IK54GaMl4C9NID12VicoPNOpxVV6iXRwUH9JdXIkrileMJ6JKwo9CoJaGqQvtcJnXwhEChIUVx2Wu1TH5JC/h/e8yQBx0vXJUgwYjmQh5l3GjqzwHm+VM3gy2l5qeXJUKgpr1l1m5MuDTRqrsiG/awupHSKfw4sYhQ0HS+URfO93Z4BGNESK8Y1ilCwm9yrTtEwY0CVQye55xp7x6srm5FeZNU6o73pQujtpqCX3pHxmPzcWs/ZOEmECeshx23PVkfwBR0SxQyJnrZcBdYLfZm59Yowr2lY6qe8L1l+WQsbXP2Ac7zQiVAHl0Y9AvEJ1GQ7iAY+8MXw4WQ13AF31o5NcXU5lVoeh/s4HXkAfcUTdc7hn5k3seEHFkLsh/CapzjKbN6gXy1qWFSuMmh18tsHgxw6TqSnTOw5fwCRXv9495fnFV1H52iLpTKnHz/VCQHfCOw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren

On 2026/10/5 02:37, Suren Baghdasaryan wrote:
> On Wed, Sep 30, 2026 at 5:25 AM Hao Ge <hao.ge@linux.dev> wrote:
>>
>> Hi Suren and Andrew
>>
>>
>> On 2026/9/30 10:39, Suren Baghdasaryan wrote:
>>> On Tue, Sep 29, 2026 at 8:44 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>>>>
>>>> On Tue, 29 Sep 2026 16:20:07 +0800 Hao Ge <hao.ge@linux.dev> wrote:
>>>>
>>>>> With profiling toggled off, the overflow check in
>>>>> reserve_module_tags() did not run, a module could load with more
>>>>> tags than the page flags can address, and re-enabling profiling
>>>>> then silently corrupted /proc/allocinfo. On overflow the fix shuts
>>>>> profiling down, releases the reservation and returns -EAGAIN, and
>>>>> the codetag section lands as regular module data in the same load,
>>>>> so the module loads without profiling.
>>>>>
>>>>> Review of the earlier series by Sashiko turned up more problems.
>>>>>
>>>>> One is a race. layout_sections() and move_module() both asked
>>>>> codetag_needs_module_section() where a codetag section goes, and
>>>>> mem_profiling_support can change between the two calls, for instance
>>>>> when another module load overflows the tag index and shuts profiling
>>>>> down. move_module() then copied the codetag section to offset 0 of
>>>>> its regular destination and clobbered the first section placed in
>>>>> that region.
>>>>>
>>>>> v7 reworks where codetag sections are allocated, on a prototype by
>>>>> Petr Pavlu [1]. The allocation runs before layout_sections() and the
>>>>> placement is decided in one step, so nothing re-asks the question
>>>>> and the race is gone. The retry is gone too, on -EAGAIN the section
>>>>> is laid out as regular module data right in the same load.
>>>>
>>>> Thanks.
>>>>
>>>> Seven patches, all cc:stable.  Why is a backport proposed?
>>>> Documentation/process/stable-kernel-rules.rst gives guidelines - does
>>>> this series meet them?  Does Suren have thoughts?
>>
>> Thanks, I've just gone through this carefully.
>>
>>>
>>> I think vmalloc fix in patch#2 should be posted separately and clearly
>>> quialifies for backporting as if fixes issues Hao found at [1].
>>
>> Agreed. Patch #2 was added to this patch series because vm_module_tags_populate
>> suffers from the same issue. If we want to be more conservative, I'd prefer to keep
>> vm_module_tags_populate as it was in V10:
>> https://lore.kernel.org/all/20260915070001.113559-3-hao.ge@linux.dev/
> 
> I disagree with this approach. That means we are introducing an extra
> code inside vm_module_tags_populate() only to clean it up later.
> Instead please post Patch #2 separately. That posting should have your
> current patch that changes vmap_pages_xxx() to clean up on failure,
> followed by patch(es) which remove unnecessary cleanup that some
> functions currently perform by themselves. This patchset should
> definitely be tagged for stable.

You are right. Sorry for the confusion - my earlier deviation came
from not fully understanding the rules for getting patches into the
stable trees.

> Once that patchset is accepted, the rest of your current patchset
> fixing alloc_tags can be posted with correct assumption that
> vmap_pages_range() cleans up its partial mapping when it fails.
> 
> I know this sequence will take longer to upstream but I think it's the
> right way to go.

Make sense. Thanks for your continued support.

Best Regards
Hao

> 
>>
>> Then we can submit a fix for __GFP_NOFAIL retry loop in __vmalloc_area_node() as a hotfix together
>> with our new patch #2. While at it, we can also check if there are any unnecessary calls to
>> vunmap_range family functions that can be cleaned up now that patch #2 is applied.
>>
>>
>>>
>>> The rest are also bug fixes but their size is concerning. I'll review
>>> them first before advising on which ones should be backported. Some
>>> fixes address issues that happen very rarely and if a fix is too
>>> complex it might make sense to leave it be or fix it some other way
>>> with less churn. Please give me a couple of days to review them. With
>>> the upcoming LPC I'm trying to multiplex between several projects.
>>
>> Thanks, sorry for all the hassle on you folks.
>>
>> Thanks
>> Best Regards
>> Hao
>>
>>>
>>> [1] https://lore.kernel.org/all/b8005c24-ecac-45c4-840a-fd282f9693b5@linux.dev/
>>>
>>>>
>>>> Also, Sashiko has been busy again:
>>>>         https://sashiko.dev/#/patchset/20260929082014.160587-1-hao.ge@linux.dev

