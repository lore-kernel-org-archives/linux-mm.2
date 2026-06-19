Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D394CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 11:57:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03D8F6B008C; Fri, 19 Jun 2026 07:57:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F31366B0092; Fri, 19 Jun 2026 07:57:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1FC56B0093; Fri, 19 Jun 2026 07:57:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B698E6B008C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 07:57:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4F7E61C4D22
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 11:57:47 +0000 (UTC)
X-FDA: 84896512974.26.BA6CD31
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7D6CD180004
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 11:57:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qQUYWDF3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781870265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wftliC1LQ6z9VS1Gw5TysYxVhKRYeesey3bP0ol5Avg=;
	b=TSAusDmzuoWV68Y6gNziIDoJ/sV0Q532qRzlEdWlpwOc8ns2yjoUDXd1vnBNX4/IG4fG9b
	QEeCpQ5UV04wPkT7AZLvnA+ek9/9KfX2+IcDXarEc1IxRfYhXEalYnhNbrHQJ9wlg7hgPd
	ucjxIx0wllDm1wbDE2flOBCOMBM/Les=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781870265;
	b=I0UlcHxlwzlmVbbLOs0dTI+BGxnqb3vZfjlRRooLm+d0Yb6XfqX++sXcuO4GZ8V/YcTjts
	Tf/eI3AObEB0wNcSLee9M1a3i/c9SLCSFsY7RXkb7YeVPOr8K+EBGomTJvwB/8c3XrXbZ7
	p2wgCaM7Z/srlF8UIaL7/XudVZYzCCE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qQUYWDF3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781870263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wftliC1LQ6z9VS1Gw5TysYxVhKRYeesey3bP0ol5Avg=;
	b=qQUYWDF3+qK8Youd5mWL5OSayVDCQc7sH6PPvGQhfyxa9pcZi3OvfCDvkSPhBx6ULmXnDY
	ysHy9TRSNVAdPxtbcopzGMXib8jKqMynp2WmE46jofyPIXckB/hSRrU8biBNnlOxkXjsDK
	xQcfgnKGWSwIMYnqGWgtr42osPzhabs=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 19 Jun 2026 11:57:39 +0000
Message-Id: <DJD0AGHTWYRN.1YWG5MDH87WVO@linux.dev>
To: "Hao Ge" <hao.ge@linux.dev>, "Brendan Jackman"
 <brendan.jackman@linux.dev>, "Suren Baghdasaryan" <surenb@google.com>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: "Brendan Jackman" <jackmanb@google.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Michal Hocko" <mhocko@suse.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Muchun Song"
 <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul Park"
 <byungchul@sk.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Hao Li" <hao.li@linux.dev>, "Christoph
 Lameter" <cl@gentwo.org>, "David Rientjes" <rientjes@google.com>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Alexei Starovoitov" <ast@kernel.org>,
 "Harry Yoo (Oracle)" <harry@kernel.org>, "Gregory Price"
 <gourry@gourry.net>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-rt-devel@lists.linux.dev>
Subject: Re: [PATCH] mm/page_alloc: unify
 __alloc_frozen_pages[_nolock]_noprof()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
References: <20260617-alloc-trylock-v1-1-83fd7858832e@google.com>
 <2399b3ad-4eac-4a14-94c3-27e9f07972a1@kernel.org>
 <CAJuCfpG48TmvaiaRvnL-NXKU6nn55D3bks2DgzAc0URsZhAxqA@mail.gmail.com>
 <DJBHRVM65A11.1OL2M9MXN56H@linux.dev>
 <45fcc57a-ec8d-46d6-9c28-065d001c081f@linux.dev>
In-Reply-To: <45fcc57a-ec8d-46d6-9c28-065d001c081f@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 7D6CD180004
X-Stat-Signature: qbzwzf87gyjc3ye5x7iq8dcbp17h8rsy
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1781870265-904722
X-HE-Meta: U2FsdGVkX18Zrpx15FPcDyeM0BU1260/B4NXw5o2rUQnQYLLOG1o1ORlX+pPnAzrxINUWXDibYfjYm3OThGOC5vza7FiWU5FR76W8tkPZRSWymmKg7Kj3mn6Rs+ZSDUnZsdv/yWYZeHfWB/e7ojAnNIicyl5X779gvu+H6MOeYkfeteEM64llIwZLO7gx05sPfPAxmQnlJO/Yvte6Y9bTWhjo/CBOKS0XNkirON2JuHy8FbqummtpaWH0W/wtYWVn+YL956dAphEtVL22vR+dXR1t88dKDxFM0rM0PVScl9jvqwBr0Cz4xSmpwZ7kOL2xnmebRGn4yL2z4z75cY3HYv6maL4SxuMQzI0INp0WmG/TvSEzCx3tvycA61bGYHtQ2ZPAbdbclhtdmPdgK5dP1OcNOPx/tJ6IHR04izVksbTquHYMAgT2rz/sJuBsWftT2hBEwsnokqEzfHd1dDdxQevbX/dWExZJKG3/o5EcIwKTul5EvJc5Je9Ay9D7mcCW8J3MhjSosyqEMHFJc+cDiQF7ZfE5yAp0EoMn4nAth7kClkGBGJPGamDUIBhFCfGqaa7lrxpyPekZrGWFs+/nv6ZpZRkZaXQGg3EfyrSfIzXmZc6w1m6aBTQAYU7MpyuRUxYVs9mElfjO7TruDUd+yQgEAsGK6X6/nh55Y0MFXramUafYxW2ejaAHB59fSY6SyXFlciNEInUXirZM/F4EV8KohRaH4nPUFZeB2VYMJvlDeCZmhaXKGx9XpwPg4CEznDkUgnuk1w4bCzP3zlbrq5EMl29Bh/WtEGUlu50S4pONKcqpemTJjtTDFKdIB/PX2227yz6nMgYvif6EbUPbeRFVVm+7tUMVNlgkOYPf5wXf7Oa2635iZeTXPjG/D3shciGaAH4BWHJ+TxYx2ukFqENjKRaslCTmVbGZn5nBKiFMVpB3OzFA6/tBGPfoOR/n0ggzH6S6ahdSWHphRb
 31RXOxpx
 zi+Gkspnv82j7SZiVOtStu1lZvnRwXqt3hq/zS96mwjzqcYbj9QD5gD5lvAKWBk4bfc1Ti35OfexdwLwI0m69K4/x1rBraZoX8fCMMlCd1z5jReAOElXekm4r06rRCqVuXywm2R1AfeZLfikoaq8Wt2M8oSamoHCbKaz7vtp+IW1ImhrMbcXeRgwYpzajJolT+JbnSF8IcGHambaqH6oZAt5pS8qG0EeQ7cWvtFMyXaV+9WLi9sz8f1+R3yNnbKRBmvYYxxuAQlYgp60oAztA112k+kyxpd4IHeOjPyxHryUqpZPPkeM6p4IX3phX/QI94QKuj3xHu1AeMNEoXo7TRRgOixkhkDF2KYZ0NhokoK1H8+1WOIno38F1mEDAer0l/kbHNqG4u3WffqBGytLZdHhX3bwq8xbzTHqd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jun 18, 2026 at 2:22 AM UTC, Hao Ge wrote:
>
> On 2026/6/18 01:14, Brendan Jackman wrote:
>> On Wed Jun 17, 2026 at 4:49 PM UTC, Suren Baghdasaryan wrote:
>>> On Wed, Jun 17, 2026 at 9:39=E2=80=AFAM Vlastimil Babka (SUSE)
>>> <vbabka@kernel.org> wrote:
>>>> +Cc Alexei
>>>>
>>>> On 6/17/26 17:29, Brendan Jackman wrote:
>>>>> Currently the core allocator code is controlled by ALLOC_NOLOCK, but =
the
>>>> It's not, it's ALLOC_TRYLOCK! Thanks for proving that we need to renam=
e it
>>>> to ALLOC_NOLOCK:
>>>>
>>>> https://lore.kernel.org/all/DJ9QPTO2WXNB.10E88ZHWRDHB0@gmail.com/
>>>>
>>>> So you just won the job to do the rename :) I think it should be done =
before
>>>> this patch, so that the new usages and other _trylock names introduced=
 here
>>>> can be done as _nolock outright.
>> Ack. I'll aim to send that tomorrow once Sashiko has caught up.
>>
>>>>> main entry point function is significantly different from the normal
>>>>> __alloc_frozen_pages_nolock(), this is tiring when reading the code.
>>>>>
>>>>> Plumb the ALLOC_NOLOCK control one layer up in the call stack: create
>>>>> an alloc_flags argument to __alloc_frozen_pages_nolock() (which is on=
ly
>>>>> exposed to mm/) and then turn the nolock variant into a thin wrapper
>>>>> that just sets that flag (as well as handling NUMA_NO_NODE, similar t=
o
>>>>> how some of the wrappers in gfp.h do).
>>>>>
>>>>> Rationale that this doesn't change anything:
>>>>>
>>>>> 1. Simple bits: A bunch of the nolock-specific handling is just moved=
 to
>>>>>     the new alloc_order_allowed(), alloc_trylock_allowed() and
>>>>>     gfp_trylock.
>>>>>
>>>>> 2. __alloc_frozen_pages_noprof() has some extra logic that wasn't
>>>>>     previously in the nolock variant:
>>>>>
>>>>>     a. Application of gfp_allowed_mask; this only affects early boot,=
 and
>>>>>        only flags that affect the slowpath get changed here.
>>>>>
>>>>>     b. Application of current_gfp_context() - also only affects the
>>>>>        slowpath
>>>>>
>>>>> 3. The slowpath itself: this is now just explicitly skipped under
>>>>>     !ALLOC_TRYLOCK.
>>>> I'll have to ponder it more closely.
>>>>
>>>>> Ulterior motive: adding an alloc_flags arg to the allocator's
>>>>> mm-internal entrypoint can later be used to do more allocation
>>>>> customisation without needing to create new GFP flags.
>>>> Ack.
>>> I think this change might also help us in removing __GFP_NO_CODETAG
>> Nice, this actually looks trivial? I can probably just tack it onto the
>> v2 for this patch/series.
>>
>>> introduced in [1] and being the only user of __GFP_NO_OBJ_EXT once
>>> Vlastimil's patchset removing other __GFP_NO_OBJ_EXT users lands.
>>> CC'ing Hao as he is brainstorming ways to remove __GFP_NO_CODETAG, and
>>> this might be the answer.
>
>
> Hi Brendan, Suren,
>
> Thanks for CC'ing me, Suren. This is indeed a viable approach
>
> and I believe it brings us one step closer to removing
>
> __GFP_NO_CODETAG entirely.
>
>
> Brendan, I'd actually put together a rough local implementation
>
> earlier with mostly the same core idea as yours, and this change
>
> would indeed be minimal based on your patch.
>
> Thanks a lot for being interested in tacking this into your v2 patch seri=
es.

Oh, I just took a look and it's a bit more fiddly than I thought because
alloc_tag.c is actually in lib/ not mm/.=20

How did you tackle that, can you share your implementation? It would be
nice if we can avoid exposing alloc_flags in gfp.h.

