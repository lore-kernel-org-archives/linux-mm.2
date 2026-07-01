Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2884C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 02:10:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C075C6B00A6; Tue, 30 Jun 2026 22:10:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B90C16B00A8; Tue, 30 Jun 2026 22:10:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2FC86B00A9; Tue, 30 Jun 2026 22:10:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 698C86B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:10:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CD5121401A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 02:10:14 +0000 (UTC)
X-FDA: 84938577948.16.CE43FC8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 271A61A0009
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 02:10:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JEQwEePj;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782871813;
	b=NnMSLvmunHPhn8UGC9A5/rq5Eg9san6ZoDZqxFlXz+R4NwPOGGqfrQ7ecRvMNl53pUHfbU
	E+04Wgg8mb7NnoT0fgh8WMOOmD7pKfWotJq+8WqbAADPdAIc0EuUCTD7C9tCUDcZS1aCYR
	ZfXrFQJps2B1OjhavVuFb/2Rb8N1PCU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782871813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ewUR5EKwRVK7OHg0Wq3wjxtpvGAISbTvWg9/qD2xWwg=;
	b=7FQbK56nmnIsgl4YH+0OWkaYKFhDUgQOJT4x4Waq4v3ohrKE+NxaRv/2xMPERHGspXc+0N
	R+Jl9vy81tus7lqtPjmSKLCY4NDKZVzW8Cb451sOS41yEcjl1WTrcL+n6/fvIQ9l1jWa4k
	5NrfjPlmT0Lpc75RReMc+Z4kasHph7o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JEQwEePj;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6348E6001D;
	Wed,  1 Jul 2026 02:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7105B1F00A3A;
	Wed,  1 Jul 2026 02:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782871812;
	bh=ewUR5EKwRVK7OHg0Wq3wjxtpvGAISbTvWg9/qD2xWwg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JEQwEePjCvYahCGPlAyQXMLv5Z0Jdfx8U8WnLSI0QRUCzBoM6ZTsvx0oZqyLme71K
	 uID8B7vNlARwSRu30nQbit473tWcKkj79IzZP9FfDroja40KwRgHss80Jqh3ARFKsN
	 6jAsXQFZCQsYdFFHxellyxWwtC4sL4qW01Xvlkf1M3clUuaKZP9vNaJw2eP+ZTjrKd
	 Ci4B8Nlgfia1hHf1Fv5+aYq6Cyn6OHmwqVjxYToCqnK9ez0/q2BClXts2T4Kj5Vlm4
	 h5VqBRUxA0CCPPCR7jKpG28B8AqQ8fqV+kCEKahlcFjsstTdjpIgkMMrmsXbU7SvEx
	 zUBPncHDn/b6A==
Message-ID: <3beb08a2-d1ce-478c-bd10-9434b417752d@kernel.org>
Date: Wed, 1 Jul 2026 11:10:03 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/16] mm/page_alloc: unify
 __alloc_frozen_pages[_nolock]_noprof()
To: Brendan Jackman <brendan.jackman@linux.dev>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Gregory Price <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-5-57bef0eadbc2@google.com>
 <397859cb-b127-4cc6-9c71-044afc99bf0c@kernel.org>
 <11a6d404-dc87-442a-9f2c-9cf34cae4869@kernel.org>
 <DJMJIZGFZHEQ.3IIRFIZYFGB6O@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <DJMJIZGFZHEQ.3IIRFIZYFGB6O@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 271A61A0009
X-Stat-Signature: xxh967tthzawmpftcniqueudt5webtxo
X-HE-Tag: 1782871812-107899
X-HE-Meta: U2FsdGVkX19fV5dSL+XteFBu/O4gQq9DOq1LctWwGHI6zuPw4qbC6l/r8muUmIp3/ArHfIAKqxv5jU8iqruPR6u6eRcXDgMoxYFeYgzzRbh0sPLyh0XMYyAziZmJWL5lau3LnNTod38On+DfTKv7asXw6qFMFbQm9fpE+A7BzO7/V/zQtf38ypN7YTplN5N1g1NVB3HekNvukgAIWrzq6LoIYmt1HReKhU+eb3LvEXYxjn5TAkmFIY3eSyuna/8aMeYUsgUs7Ef2xjBMD32h/LZT5ga4RBRYF2VsiP/lcSR7UOxZOyNI/ycLswkxxOwFX/JGg2aJMpXhkE65koMMY1DBNVzL4cjEDHHuGLJlac38ZfE+i2YpVTdugmMK6uJ0NgKZswbzY3muFiRFIe3A44k1NMVacDarUb4jyfYnnjIUb+IUAJWrT4kgsDFzKY8VUpCVRt9UNBgnkMXwqON1VsBfXLGA5BjoJO56kl2WovU3afF5OYgTOOF90RPBy1AmAiMk9qMnCEvlL1IoagCpnKuB9QwzReo/VKjNtYWQGXPFECfVAVkDupNanXkh4tcNw/jZJoZrrjvgYP/4HCrWl3uLpygiD3GoslqmLqrCuOLeX6N36CCbRjECwYlG97bai6MlXTVPu6Ino4z2pTtUbEsmEKv7aSxJQluRZJG+g6eKkEZyNpcyUqhgW7WRcgdSRHuEr/poVsp5WmvuFGJh+2Be9vRzTtoy7Aw3lwOznIx1HTft7Bt1c8A5cTiQyD49x+990qvtsWAeUxKGlGe0iIPxtiwoMUkaL/URIw5ArfE+A/Q6xQOgYcu7E+h+i+21dLkhNv8BQinpLKN952wb0NdSWJSev428GOZ9RQevmZrpatVFAlDj6fZtE+WdB8A25TYb9MzaJTPoNWj1U8IbOLb8E6YRUKOJm7PbGh7L5SZ9kJvo9BEpR/E+Lz80tlYJV1oMwnXUhXvwaVF9Glu
 oIFCbC4H
 oCT+uPw8ne5oEMNM5/GrWw+LTS2EwigEtl100AEKS6m2e4b/nTE8Sx1YdM7F0og7+2t4jkJl6CEPhsOg/giiWEiAtB+0Hurzkc/1nF5/EAqRc5iaKryzept2TcaVfxf4Ik8RFp55I+o7o/bakL6LMJAIiXfwzRbwHMAABc9z3RnD2VRxZ+cIyp1pbBQ0Y84ucOMyLy0G5oxE6tlutM551PVjv8iPejTNvJ9WDKEHW6eZpjwx8eg8b4KnjHt6ZW+W+kEvZGcQuwABinZHTbUQ6a5wz8egPFnjKpq1qe4KqjRDwy0y6IUMgpCdhk3iAXXoEBs5XK1OS4sPryCnKlMWvma8sgxD5lk9ubWIvovS7OMKYd86JRztvo3eCcRbx0TdwF06W0me2GDL/aXwZAiw3giO9xg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/1/26 1:56 AM, Brendan Jackman wrote:
> On Tue Jun 30, 2026 at 3:34 PM UTC, Vlastimil Babka (SUSE) wrote:
>> On 6/30/26 15:36, Harry Yoo wrote:
>>>
>>>
>>> On 6/29/26 10:11 PM, Brendan Jackman wrote:
>>>> Currently the core allocator code is controlled by ALLOC_NOLOCK, but=
 the
>>>> main entry point function is significantly different from the normal=

>>>> __alloc_frozen_pages_nolock(), this is tiring when reading the code.=

>>>>
>>>> Plumb the ALLOC_NOLOCK control one layer up in the call stack: creat=
e
>>>> an alloc_flags argument to __alloc_frozen_pages_nolock() (which is o=
nly
>>>> exposed to mm/) and then turn the nolock variant into a thin wrapper=

>>>> that just sets that flag (as well as handling NUMA_NO_NODE, similar =
to
>>>> how some of the wrappers in gfp.h do).
>>>>
>>>> Rationale that this doesn't change anything:
>>>>
>>>> 1. Simple bits: A bunch of the nolock-specific handling is just move=
d to
>>>>    the new alloc_order_allowed(), alloc_trylock_allowed() and
>>>>    gfp_trylock.
>>>
>>> Right.
>>>
>>>> 2. __alloc_frozen_pages_noprof() has some extra logic that wasn't
>>>>    previously in the nolock variant:
>>>>
>>>>    a. Application of gfp_allowed_mask; this only affects early boot,=
 and
>>>>       only flags that affect the slowpath get changed here.
>>>
>>> gfp_allowed_mask clears __GFP_RECLAIM, and that means now allocations=

>>> with GFP_KERNEL during early boot would see
>>> gfpflags_allow_spinning() =3D false.
>>
>> Is it a problem though? non-nolock allocations were affected before (t=
he
>> masking existed for those already) and will be affected now the same, =
and
>> _nolock() allocations don't pass __GFP_RECLAIM in the first place, so =
the
>> masking can't affect them?
>
> This was my thinking too.

Oh! You guys are right :) I was confused.

>>> The helper is not used in in the page allocator, but used in
>>> memcg/stackdepot/page_owner.
>>>
>>>>    b. Application of current_gfp_context() - also only affects the
>>>>       slowpath
>>>
>>> PF_MEMALLOC_PIN affects the fast path, but ALLOC_NOLOCK users
>>> won't be affected.
>>
>> And it wouldn't be wrong if they were? It only clears __GFP_MOVABLE?

Nothing wrong, but wanted to mention things that were not mentioned in
the changelog as it argues there's no functional change intended.

>>> What about alloc_flags_nofragment/nonblocking()?
>>
>> ALLOC_NOFRAGMENT due to e.g. defrag_mode could be a problem indeed, if=

>> there's no slowpath. Make ALLOC_NOLOCK override it?
>=20
> Yeah calling alloc_flags_nofragment() here is a bug in the patch,
> and Sashiko also complained:=20
>=20
> https://lore.kernel.org/all/20260629142921.9A05A1F000E9@smtp.kernel.org=
/
>=20
> Like I said in the reply to that thread I think maybe we _do_ want to
> set ALLOC_NOFRAGMENT for nolock allocations? But, that is a functional
> change, it doesn't belong in this series.

I don't think it was intentional to bypass ALLOC_NOFRAGMENT for nolock
allocations. But yeah that's a functional change.

>> nonblocking() is probably fine?
>=20
> Yeah, I believe this is fine.

Agreed.

--=20
Cheers,
Harry / Hyeonggon


