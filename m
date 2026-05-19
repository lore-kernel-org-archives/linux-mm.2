Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15A93CD4F54
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 23:57:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 096DA6B0005; Tue, 19 May 2026 19:57:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 047206B0088; Tue, 19 May 2026 19:57:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E51886B008A; Tue, 19 May 2026 19:57:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D1F006B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 19:57:53 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7AC31120ADE
	for <linux-mm@kvack.org>; Tue, 19 May 2026 23:57:53 +0000 (UTC)
X-FDA: 84785834826.15.137B230
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id D2B51C0003
	for <linux-mm@kvack.org>; Tue, 19 May 2026 23:57:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j+IawRDC;
	spf=pass (imf10.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779235071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dbsOAfuN8ml++VqHBD2xHu4Tk0pEHTjebmx81mRjNjQ=;
	b=xHnXcu9p7oSdBDnZm6YwcmjnExT+U8t6BeZpSZp+rAChl2tAQEhFCuKrzm+tRAyR08B4PF
	RJEZn4EcViKJPmmoJLNHoObSKs8tNBdNzaQaOX/cmCrOBMyP9Bzis0bSHO6Rb5TuYcFIsS
	2OlXUSFiq7Nw3b0dUWdV4sIGp3jJxMY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j+IawRDC;
	spf=pass (imf10.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779235071; a=rsa-sha256;
	cv=none;
	b=CFY+slUKMkEIaeZ/G+afRIah9rYRlpiou/J8t67Lr8s6m/oII6c0pq+HhXRehuCIMjeRq+
	xc9sPuWV4Ng3C2x5CpFZhd285fn9/JoY2XYvhLhIellf3/Oe1DLUNDFjIEASL9pvdq5IYW
	RDvsNlHySAfu6zZhcp/2DQI0REzrAeA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F2CB60216;
	Tue, 19 May 2026 23:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328051F00893;
	Tue, 19 May 2026 23:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779235071;
	bh=dbsOAfuN8ml++VqHBD2xHu4Tk0pEHTjebmx81mRjNjQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=j+IawRDC4po5J/sySD3Vspo/j2V6R7CsxVFwZtizeYW8pdH/UsliZI/qQZreqa8ll
	 +9cK0dwngXE+55CkwGhFbim4x6YdUttO7nM04lyrmgGpKcD3RtBQwuzb1y64Trj6fZ
	 VVWfqd7g3nHCG/zZRm/8qqKykiislzCZKL89CzHEyWbFGc0fUOcjHiohFpRNELU0AR
	 ejYF/V59JUUqr7nmzQMRIJBisCdJ9anllfnXNzmrBu2lUTqvJMepXGcCu9AdyWCc36
	 5Bjrs4QZ8Ac5swPr9Ow3Z/mDI5sHraIw+5YwUah4DOCvHh2DIw53nFgb5ThnZo5I5q
	 2RyBf6pHU8qAA==
Message-ID: <d0cea3c8-f1ce-4dfe-a116-8f36d5b4308e@kernel.org>
Date: Wed, 20 May 2026 08:57:42 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] slab: support for compiler-assisted type-based
 slab cache partitioning
To: Marco Elver <elver@google.com>, Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Bill Wendling <morbo@google.com>,
 David Hildenbrand <david@kernel.org>, David Rientjes <rientjes@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>,
 Justin Stitt <justinstitt@google.com>, KP Singh <kpsingh@kernel.org>,
 Kees Cook <kees@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Matteo Rizzo <matteorizzo@google.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, linux-hardening@vger.kernel.org,
 Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Hao Li <hao.li@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 Alexander Potapenko <glider@google.com>, Miguel Ojeda <ojeda@kernel.org>,
 linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kasan-dev@googlegroups.com, llvm@lists.linux.dev,
 GONG Ruiqi <gongruiqi1@huawei.com>
References: <20260511200136.3201646-1-elver@google.com>
 <agcsMgfKjGTasJ5n@pedro-suse>
 <CANpmjNOYd9RnJARZ7qUDifsftwWOhhakaWSu926PKA6-SepTwQ@mail.gmail.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <CANpmjNOYd9RnJARZ7qUDifsftwWOhhakaWSu926PKA6-SepTwQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D2B51C0003
X-Rspamd-Server: rspam06
X-Stat-Signature: m9uky31ux7sia1k9pnimo61b9qst1u84
X-HE-Tag: 1779235071-11120
X-HE-Meta: U2FsdGVkX1+hUGR3xf3gppMQF5LCKT7JyRxk/Z2ZIyp4RMm3LeRbKyOIxtiYFM40yJIXhsP2L29AoZSTDlJtmtbE2p2mJVCvUCBaR/6SG1a422S8dEmtTPtsL1MP0yffNE5EjH76iPOnRcoIwT8kqYS3DyB5ncG6c6hJNwy1ZyWilafW+F+tksM7szRbS5dnXYU4kDyGYC1SFfCQJOh/3KjpcR9WsDGG8J/cZ8zto6SZf13yPtYkt5WfxJn/OPdcuyN5ue/6NVqsap4GCJ0lwswB36XpNaidjv1m5orgD8jsTqfoJpF37E0aWXAbIm7wXPUuqIODpaYZkksjNgyukU1j1f/KO/BTUpcb8CSHLSZCIhydsDiBs9IKZ/hbICVovB9a/UwNZuE/r99I0p0zdeaIAL3sTz1Mj/9ZGdUt0c5++aqSxKXBoxLgYITzIdMQmU0CJk+xEOkh01eJpcLN03fRVc+WhAZ2BlotFRSAx0zvtKxh68trrJzsqbpkdcAcHpuyDEYgDAubEzD487UVemmTO5Ga2/9DH3y3ihUb67DR+HNiGTrWFYQY7Q/TdG/J41Lxpep/18qVNVKkRrnV3T7jNM/OOXhW6yMf9DFZDgFgJG1ON88NOL7KEU4GFfCiw0Fb9Gar2V0e1oNEZCEgXimCA6xb7cqhEVbfS2D58jd/1Bknjw5I7eRvAgWEdQX7ND7j2jGjSIrBOUEJDKfQccDGsdKK+33mDjsjTv1uGJClFtM/vnks4q9QcwacxxUhuie7BOA7wXMBjFvQOWd6k2+vL1bu6MIL19nYcpghQE49g6TLYn4Fou6oqGw4sOYAOSHOXfoXAoHpaI5CqgcRLwYd2rBkR95XDa11MhQ7BvkDrBkN5qX0zMi3CiVtY1DSsJxzB3vtAKOV5divXeOuxkYtZSMdDGx/ylr+IgFybkXb4VLx7Evf0oigsS88Hw2FAvazvxUlNGsiGlMSgK0
 ammI1tnV
 7cIIkjj9cuBmX9W2px7AMmKgqGhthvSG22GtEsQplCe3eiI3ja8JUz4k2W5onDlzpCyymGkGPhVArlbYDrBJv0rmJbitXpl0IbY2C26WHs3kXGwYxHPukmKS0YNcnjSy0V3v5yOhHnRbdF/UrD46vOwbK8xkRx+6BvU8nvBWT9PaY1bnGypVQhuh2F7p11ijpt04RSLIHAIt6yDAKdwi1tyrB+EOU6kOQLcCBfdOxIGYPRgHM7L+GSy0LsM2tyBWtbNdyiuS0/WaCYR0WlA/710+K4oE/imJdsSK5UNao2b4ZzMvbSf30ETmIMkpWEsX8X7JQQixhYdR3NAM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/18/26 11:08 PM, Marco Elver wrote:
> On Fri, 15 May 2026 at 16:28, Pedro Falcato <pfalcato@suse.de> wrote:
>>
>> On Mon, May 11, 2026 at 10:00:48PM +0200, Marco Elver wrote:
>>> Rework the general infrastructure around RANDOM_KMALLOC_CACHES into more
>>> flexible KMALLOC_PARTITION_CACHES, with the former being a partitioning
>>> mode of the latter.
>>>
>>> Introduce a new mode, KMALLOC_PARTITION_TYPED, which leverages a feature
>>> available in Clang 22 and later, called "allocation tokens" via
>>> __builtin_infer_alloc_token() [1]. Unlike KMALLOC_PARTITION_RANDOM
>>> (formerly RANDOM_KMALLOC_CACHES), this mode deterministically assigns a
>>> slab cache to an allocation of type T, regardless of allocation site.
>>>
>>> The builtin __builtin_infer_alloc_token(<malloc-args>, ...) instructs
>>> the compiler to infer an allocation type from arguments commonly passed
>>> to memory-allocating functions and returns a type-derived token ID. The
>>> implementation passes kmalloc-args to the builtin: the compiler performs
>>> best-effort type inference, and then recognizes common patterns such as
>>> `kmalloc(sizeof(T), ...)`, `kmalloc(sizeof(T) * n, ...)`, but also
>>> `(T *)kmalloc(...)`. Where the compiler fails to infer a type the
>>> fallback token (default: 0) is chosen.
>>>
>>> Note: kmalloc_obj(..) APIs fix the pattern how size and result type are
>>> expressed, and therefore ensures there's not much drift in which
>>> patterns the compiler needs to recognize. Specifically, kmalloc_obj()
>>> and friends expand to `(TYPE *)KMALLOC(__obj_size, GFP)`, which the
>>> compiler recognizes via the cast to TYPE*.
>>>
>>> Clang's default token ID calculation is described as [1]:
>>>
>>>     typehashpointersplit: This mode assigns a token ID based on the hash
>>>     of the allocated type's name, where the top half ID-space is reserved
>>>     for types that contain pointers and the bottom half for types that do
>>>     not contain pointers.
>>>
>>> Separating pointer-containing objects from pointerless objects and data
>>> allocations can help mitigate certain classes of memory corruption
>>> exploits [2]: attackers who gains a buffer overflow on a primitive
>>> buffer cannot use it to directly corrupt pointers or other critical
>>> metadata in an object residing in a different, isolated heap region.
>>>
>>> It is important to note that heap isolation strategies offer a
>>> best-effort approach, and do not provide a 100% security guarantee,
>>> albeit achievable at relatively low performance cost. Note that this
>>> also does not prevent cross-cache attacks: while waiting for future
>>> features like SLAB_VIRTUAL [3] to provide physical page isolation, this
>>> feature should be deployed alongside SHUFFLE_PAGE_ALLOCATOR and
>>> init_on_free=1 to mitigate cross-cache attacks and page-reuse attacks as
>>> much as possible today.
>>>
>>> With all that, my kernel (x86 defconfig) shows me a histogram of slab
>>> cache object distribution per /proc/slabinfo (after boot):
>>>
>>>    <slab cache>      <objs> <hist>
>>>    kmalloc-part-15    1465  ++++++++++++++
>>>    kmalloc-part-14    2988  +++++++++++++++++++++++++++++
>>>    kmalloc-part-13    1656  ++++++++++++++++
>>>    kmalloc-part-12    1045  ++++++++++
>>>    kmalloc-part-11    1697  ++++++++++++++++
>>>    kmalloc-part-10    1489  ++++++++++++++
>>>    kmalloc-part-09     965  +++++++++
>>>    kmalloc-part-08     710  +++++++
>>>    kmalloc-part-07     100  +
>>>    kmalloc-part-06     217  ++
>>>    kmalloc-part-05     105  +
>>>    kmalloc-part-04    4047  ++++++++++++++++++++++++++++++++++++++++
>>>    kmalloc-part-03     183  +
>>>    kmalloc-part-02     283  ++
>>>    kmalloc-part-01     316  +++
>>>    kmalloc            1422  ++++++++++++++
>>
>> Hi,
>>
>> A couple of questions (I apologise if this was asked before, I wasn't involved
>> in this thread):
>>
>> 1) What's the object behind kmalloc-part-04? I imagine it's a single type
>> getting allocated a lot?
> 
> That's from __kmemdup_nul().

__kmemdup_nul() is probably a good fit for SLAB_BUCKETS?

-- 
Cheers,
Harry / Hyeonggon


