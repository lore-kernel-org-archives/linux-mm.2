Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0F34CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 08:24:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 518C38E0009; Thu, 23 Oct 2025 04:24:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A21E8E0002; Thu, 23 Oct 2025 04:24:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 369778E0009; Thu, 23 Oct 2025 04:24:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1D01A8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 04:24:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B83B21298DD
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 08:24:41 +0000 (UTC)
X-FDA: 84028692762.28.F00DAEB
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf28.hostedemail.com (Postfix) with ESMTP id B7B7FC0009
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 08:24:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fThTnFDg;
	spf=pass (imf28.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761207880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zxjCR3n53HVShccK/xRoPJo5rB7aVfPPhCgNh53dbY8=;
	b=cYbH6rUOEj8ZKcbVttegEbqeqs2XVSfoi3f52Bg74kawZyUvyBG1Z4Y7H1aPXOHf5iVret
	0JejZT6sGmCOODUDlIPCwVsSuHf2EFjKnFOWp+irKAlwY+1KT9sRgaPsMKVd2rnAj3qE2X
	5+ZXdSDIp7IdyJpvzmXuuh20Hzce0qw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fThTnFDg;
	spf=pass (imf28.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761207880; a=rsa-sha256;
	cv=none;
	b=dAPf/niVkRF9Au2FmNm+m1mNpd4zB0Bsnex+IihL1hbRRG3D+P3u0dKkTeUpQ3g+NHyA8F
	MRJe3/2VrfDhOTsSBAaCaXGGMk59XLkoHdnDm/XxMHbLsRX/XFwt5xW65wLDoWBd4fOK7h
	dTE775hBI3qpzJnc6vuUavieLt3LYN0=
Message-ID: <cc961fad-f9bc-4c5a-a7f1-ea3842aefed3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761207877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zxjCR3n53HVShccK/xRoPJo5rB7aVfPPhCgNh53dbY8=;
	b=fThTnFDg+1ijgoPzAgbubMu5OymL/xwomkEXwN6LQgU2M/qiN/YXap8eaIsyTw5X2NUafZ
	kCxlvd73b82O3ZmEsS7eXWyV7EXGy9Fsmv90Mm2J23WJIzAYmjTJsnMwgskeLB0U7mPwEY
	4D60U5jwltBRaymwIeAk4SGBhPNC1fU=
Date: Thu, 23 Oct 2025 16:23:46 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] slab: Fix obj_ext is mistakenly considered NULL due to
 race condition
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hao Ge <gehao@kylinos.cn>
References: <20251023012117.890883-1-hao.ge@linux.dev>
 <aPmR6Fz8HxYk4rTF@hyeyoo> <b8c90552-7be6-45bb-b586-ee21f63499c8@linux.dev>
 <aPneQRY5ei-zvSGQ@hyeyoo>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <aPneQRY5ei-zvSGQ@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B7B7FC0009
X-Stat-Signature: c3ht45n8xaprnb66njkp1iy349ymo7rj
X-Rspam-User: 
X-HE-Tag: 1761207879-663589
X-HE-Meta: U2FsdGVkX1/bmJmoKtrZymjc0q4eqVZv3Yf0rskhviW3fV9hpM51N9JbpJUJ08P6tiOCpkBkn/W0PwgrKqfGEkOBipx3f/y3EDz/MJwbo+ueB5NVt67WET/5W+1ghLr0ny8/5rSM/4Qx/fHfWMU2kpfDpqbfYOxfNW+2Jtx9swpnBoIAa0CUe20cUPJzyzU9/DXc7Cg6BVQ9drLZSSdr0xNM/rR3OtfPrqjzS3iKbNHDZz2j6nmhvYl5KLcuo9pZa8rWjOGawW0fcJv+m35B1Y1I5H1E0odR13Dlk9LR8qsMOr1MG0Y4CNlzK1LjsKClrji8uV23jE7tXpkSxRKymAGrp/Zyxq58GfB/GjKr38EtzXkMjXDzlb43KJLkQnz0qRe9mTwzwPvtiB6c4wkkYJgQX0IDF/ZjU2LWWDVaFSFyU64bJKsZT+i1UC4BbsIkgVnUk/wqwQe73hR+WnVmIm5HxIBo0xckPIGktdPnNeaWXZrmbBEqJd1CIKTBqEh9mP4IV5BznRe9mGnuTV6jNQRvAl4a5dWXt6sU/DXPtnUh7Vl9Fq4hbU4DWh6gJ48gE8Qkz4QleVUnpLg2TS4me/gtmkgp+LGfQXKZguIBJLG37uduCrL/0mBtYSPnXFNzTu3BOTL5B1d3iOWgxSBsgUIvDhzC8YzgXD1jkSw16B0CuXl7TYB1r62yI8wWOYXPH5bLtZIyu95nqFj20MwS9dSYCOkW8w01LxLSx9UkbS1XieNm2+kJNWmQQ/18QKi3UUNWZ6i9OV3NsSt+ZUCjGmXK3ZOrSjzw+sWd7nV9RexcYGSlG54fZcdkNam/raP95l3rRbnieECjSiItbbkwbHEEJ3tTxnSfhEvH1mG7JJ8C9LrlKhLAfx8gzdwvu5ILMxsyeVRZD1Qpo48aetNm4dbBHwP//V7O
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry


On 2025/10/23 15:50, Harry Yoo wrote:
> On Thu, Oct 23, 2025 at 11:11:56AM +0800, Hao Ge wrote:
>> Hi Harry
>>
>>
>> On 2025/10/23 10:24, Harry Yoo wrote:
>>> On Thu, Oct 23, 2025 at 09:21:17AM +0800, Hao Ge wrote:
>>>> From: Hao Ge <gehao@kylinos.cn>
>>>>
>>>> If two competing threads enter alloc_slab_obj_exts(), and the
>>>> thread that failed to allocate the object extension vector exits
>>>> after the one that succeeded, it will mistakenly assume slab->obj_ext
>>>> is still empty due to its own allocation failure. This will then trigger
>>>> warnings enforced by CONFIG_MEM_ALLOC_PROFILING_DEBUG checks in
>>>> the subsequent free path.
>>>>
>>>> Therefore, let's add an additional check when alloc_slab_obj_exts fails.
>>>>
>>>> Signed-off-by: Hao Ge <gehao@kylinos.cn>
>>>> ---
>>>>    mm/slub.c | 9 ++++++---
>>>>    1 file changed, 6 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/mm/slub.c b/mm/slub.c
>>>> index d4403341c9df..42276f0cc920 100644
>>>> --- a/mm/slub.c
>>>> +++ b/mm/slub.c
>>>> @@ -2227,9 +2227,12 @@ prepare_slab_obj_exts_hook(struct kmem_cache *s, gfp_t flags, void *p)
>>>>    	slab = virt_to_slab(p);
>>>>    	if (!slab_obj_exts(slab) &&
>>>>    	    alloc_slab_obj_exts(slab, s, flags, false)) {
>>>> -		pr_warn_once("%s, %s: Failed to create slab extension vector!\n",
>>>> -			     __func__, s->name);
>>>> -		return NULL;
>>>> +		/* Recheck if a racing thread has successfully allocated slab->obj_exts. */
>>>> +		if (!slab_obj_exts(slab)) {
>>>> +			pr_warn_once("%s, %s: Failed to create slab extension vector!\n",
>>>> +				     __func__, s->name);
>>>> +			return NULL;
>>>> +		}
>>>>    	}
>>> Maybe this patch is a bit paranoid... since if mark_failed_objexts_alloc()
>>> win cmpxchg() and then someone else allocates the object extension vector,
>>> the warning will still be printed anyway.
> Oh, just to be clear I was talking about the other warning:
> pr_warn_once("%s, %s: Failed to create slab extension vector!", __func__, s->name);
>
>> The process that successfully allocates slab_exts will call
>> handle_failed_objexts_alloc, setting ref->ct = CODETAG_EMPTY
>> to prevent the warning from being triggered.
> But yeah I see what you mean.
>
> As you mentioned, if the process that failed to allocate the vector wins
> cmpxchg(), later process that successfully allocate the vector would
> call set_codetag_empty(), so no warning.
>
> But if the process that allocates the vector wins cmpxchg(),
> then it won't call set_codetag_empty(), so the process
> that was trying to set OBJEXTS_ALLOC_FAIL now needs to set the tag.

Yes, the case I'm encountering is exactly this one.

>
>>> But anyway, I think there is a better way to do this:
> What do you think about the diff I suggested below, though?

Sorry for the delayed response earlier; I was trying to deduce all 
possible scenarios.

It makes sense to me, and I will submit the V2 version based on this 
suggestion.

Thank you for your help.

>
>>> diff --git a/mm/slub.c b/mm/slub.c
>>> index dd4c85ea1038..d08d7580349d 100644
>>> --- a/mm/slub.c
>>> +++ b/mm/slub.c
>>> @@ -2052,9 +2052,9 @@ static inline void mark_objexts_empty(struct slabobj_ext *obj_exts)
>>>    	}
>>>    }
>>> -static inline void mark_failed_objexts_alloc(struct slab *slab)
>>> +static inline bool mark_failed_objexts_alloc(struct slab *slab)
>>>    {
>>> -	cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL);
>>> +	return cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL) == 0;
>>>    }
>>>    static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
>>> @@ -2076,7 +2076,7 @@ static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
>>>    #else /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
>>>    static inline void mark_objexts_empty(struct slabobj_ext *obj_exts) {}
>>> -static inline void mark_failed_objexts_alloc(struct slab *slab) {}
>>> +static inline bool mark_failed_objexts_alloc(struct slab *slab) { return true; }
>>>    static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
>>>    			struct slabobj_ext *vec, unsigned int objects) {}
>>> @@ -2125,7 +2125,9 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>>>    	}
>>>    	if (!vec) {
>>>    		/* Mark vectors which failed to allocate */
>>> -		mark_failed_objexts_alloc(slab);
>>> +		if (!mark_failed_objexts_alloc(slab) &&
>>> +			slab_obj_exts(slab))
>>> +			return 0;
>>>    		return -ENOMEM;
>>>    	}
>>>

