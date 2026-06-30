Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A867FC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:56:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E6846B00EA; Tue, 30 Jun 2026 12:56:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 596EB6B00EC; Tue, 30 Jun 2026 12:56:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 486FE6B00ED; Tue, 30 Jun 2026 12:56:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B34E6B00EA
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:56:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 84583167F43
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:56:31 +0000 (UTC)
X-FDA: 84937182582.05.6D85E1D
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4405CC0002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:56:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="JLlmfsF/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782838589;
	b=co6Q18P6DfBV9S2NFLpgWahesTixR8QndcM5sVFmgKYHXjFGIrUc3Aed3Yj5u5VeEjv3C/
	ilMC8MooHj9LbUvkSej32G39iL0w74cJNulnRI7tQJs2QfRxRl57z59sl8QFTN9efRfSbR
	Gx1mHwnhoDfQoLOCqAXOLXz/pGCUfPk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782838589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uqHYqouwZFakB3/yAJGkeIhefpYHS6QsTSYK57j0e1I=;
	b=yPcrJhoqEU3GMTBOodeUFi+Z0Bkqbgoho30aJr66ZEJq3SOau51015lTw3VG3jT20mpe/x
	7duA31XJVqKT1W531LNKTVX8773kXaLrEzlr77KVrnCSGxxYVNnEXMVulRMbSdzZTzfWIZ
	+ZR0UxX+NcZTeec3IxZt5+N9OzIv82M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="JLlmfsF/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782838585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uqHYqouwZFakB3/yAJGkeIhefpYHS6QsTSYK57j0e1I=;
	b=JLlmfsF/x2Mo/N7b1BVsCr77TnV1ido8SLAzQcSgAuPuPr+zdQxni7oTzhcxDij9WivpZN
	cCajOF9WUHJxJh+yx/7t5DN4ljl7Ga8y/38TczYWWjmOqVddw3G0X9yGUH88It0Vt0ra/Q
	gmscYMCcvBjMBMK+tCeXJJe2KhbGPU4=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 30 Jun 2026 16:56:08 +0000
Message-Id: <DJMJIZGFZHEQ.3IIRFIZYFGB6O@linux.dev>
Cc: "Gregory Price" <gourry@gourry.net>, "Alexei Starovoitov"
 <ast@kernel.org>, "Matthew Wilcox" <willy@infradead.org>, "Hao Ge"
 <hao.ge@linux.dev>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-rt-devel@lists.linux.dev>
Subject: Re: [PATCH v3 05/16] mm/page_alloc: unify
 __alloc_frozen_pages[_nolock]_noprof()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, "Harry Yoo"
 <harry@kernel.org>, "Brendan Jackman" <jackmanb@google.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Muchun Song"
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
 Rostedt" <rostedt@goodmis.org>
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-5-57bef0eadbc2@google.com>
 <397859cb-b127-4cc6-9c71-044afc99bf0c@kernel.org>
 <11a6d404-dc87-442a-9f2c-9cf34cae4869@kernel.org>
In-Reply-To: <11a6d404-dc87-442a-9f2c-9cf34cae4869@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4405CC0002
X-Rspam-User: 
X-Stat-Signature: o4w5bemzebz1n94wkqb9mcir78h8s4zd
X-HE-Tag: 1782838588-940388
X-HE-Meta: U2FsdGVkX1/CKpbdS+KKoTfm2W1U9g33z61JjGIEChlUXgA8CJCu1QSz3XrWCcvXFSzgjzP2d6fsoZdz5mwaoBkHVzLqIDHAfov5N55p+W1YfAywWzIIVdgm4NZ+me6EomFIpoijSKJczvKXULSgJW9YFxuvhi+cxkqL2LXhSLikHOlV8ryodeesutQ22Qd1wLpEvvq06OL0GgBUFmOLKXBcX8JSra1Xs6y3ZuKqWxH+r/PwM3a0KxMzL4NzqelKZ3EG0KJO+F1erBQalk1MQQkknyFTVcjDi4rStu3eXCUX7DT7bg5WUR3xeFaoNUTIYQb/buT4xJ8cikdVgm6ohNWbQ69SCM1P5pQ64rxZM56Q7V6XfN/CXUvnI6ob3ib4XqqDJxd4r3gGlAdVr6lOSlLsR65B269G3A0XH5aE7z5+f9r/IaaNs/NxS2RDPRYmL5DnXQjZ7K0DLwOz7QS4SBpOT0nNWrAve3bOKi1PtyI8IvwvQG2kvSp8wqmjEPehMVyBEzYBpYDrtuDX8nvAXUkXQXJ0nyogszQAHNlY/dvpwfhuSFocMxK2Zj7J7riSTvRS0F2tozpPyX9a4SB2MbilAPxgXitVKew9XgJwF+HXyd5ipSiAXlXRTYWGmbkI6gTKvRPOX4zq52z8+VzmUq0E7AVMVukm1U9+y85T81RHmUIYro1sqMK4LPdC/53TDHaylcKlbVfc6Qjs6DTS9Y+e9dSRj7GVqSCMgAi0BbbHKYOBdeRxtzKSgy9EDHDbGTuhnUMkOg/a0/v3yKeqzSSTCdco41DlO4I/sxb2njNcVyLyczNoUWRoPFjKQKkzHYaCssDJfCMOV913CitGJWJTiqgRXYQTO+RLDYVIWbtwhKYrhAZ0V8RUINi7YnhP95+69854EtwcJeR0grrd+P7p0eKk9FiS215EohAkGohSd+gph5CLfl7XbMAubucMldwjZP/l18ZzdRnqzEF
 bjZiCLpY
 C0GyycHLpiP8BoRr7u3PZxaTjF4ztAD2BpyPxVgzmWy7zWLro22YYvdLGffl+KUfpaBU/Sk7xTXjVFCwPjow5dXS8/A736K7FUrRNUXC69n9j2NAhJyWdd+zKNPGYwy2iA7cTWWqGbo4Ns8CQVbAkOvE3Np5UfVXM2UwHDOwVh5OVeA63Cmi5r//1fM0Kfo/T8v7E6DBUJcVZ6NWKZHJZhTS3Lk81qHFYNw0czP1gz2q9D4P4sR6XzF1af9v87/6Zi//+23Lq+3mCNq6qP+HhbHuZPvA+/SNC4x0FEx/HdEAZHqCy9MqxDJArzBZwVISwWhMrGMV+q94Q2IF9VEj4MsPt+lLAaqOc5ld0DJ/sY2zITjaE6bru+JjpwwnxViJzPaRQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jun 30, 2026 at 3:34 PM UTC, Vlastimil Babka (SUSE) wrote:
> On 6/30/26 15:36, Harry Yoo wrote:
>>=20
>>=20
>> On 6/29/26 10:11 PM, Brendan Jackman wrote:
>>> Currently the core allocator code is controlled by ALLOC_NOLOCK, but th=
e
>>> main entry point function is significantly different from the normal
>>> __alloc_frozen_pages_nolock(), this is tiring when reading the code.
>>>=20
>>> Plumb the ALLOC_NOLOCK control one layer up in the call stack: create
>>> an alloc_flags argument to __alloc_frozen_pages_nolock() (which is only
>>> exposed to mm/) and then turn the nolock variant into a thin wrapper
>>> that just sets that flag (as well as handling NUMA_NO_NODE, similar to
>>> how some of the wrappers in gfp.h do).
>>>=20
>>> Rationale that this doesn't change anything:
>>>
>>> 1. Simple bits: A bunch of the nolock-specific handling is just moved t=
o
>>>    the new alloc_order_allowed(), alloc_trylock_allowed() and
>>>    gfp_trylock.
>>=20
>> Right.
>>=20
>>> 2. __alloc_frozen_pages_noprof() has some extra logic that wasn't
>>>    previously in the nolock variant:
>>>=20
>>>    a. Application of gfp_allowed_mask; this only affects early boot, an=
d
>>>       only flags that affect the slowpath get changed here.
>>=20
>> gfp_allowed_mask clears __GFP_RECLAIM, and that means now allocations
>> with GFP_KERNEL during early boot would see
>> gfpflags_allow_spinning() =3D false.
>
> Is it a problem though? non-nolock allocations were affected before (the
> masking existed for those already) and will be affected now the same, and
> _nolock() allocations don't pass __GFP_RECLAIM in the first place, so the
> masking can't affect them?

This was my thinking too.

>> The helper is not used in in the page allocator, but used in
>> memcg/stackdepot/page_owner.
>>=20
>>>    b. Application of current_gfp_context() - also only affects the
>>>       slowpath
>>=20
>> PF_MEMALLOC_PIN affects the fast path, but ALLOC_NOLOCK users
>> won't be affected.
>
> And it wouldn't be wrong if they were? It only clears __GFP_MOVABLE?
>
>> What about alloc_flags_nofragment/nonblocking()?
>
> ALLOC_NOFRAGMENT due to e.g. defrag_mode could be a problem indeed, if
> there's no slowpath. Make ALLOC_NOLOCK override it?

Yeah calling alloc_flags_nofragment() here is a bug in the patch,
and Sashiko also complained:=20

https://lore.kernel.org/all/20260629142921.9A05A1F000E9@smtp.kernel.org/

Like I said in the reply to that thread I think maybe we _do_ want to
set ALLOC_NOFRAGMENT for nolock allocations? But, that is a functional
change, it doesn't belong in this series.

> nonblocking() is probably fine?

Yeah, I believe this is fine.

