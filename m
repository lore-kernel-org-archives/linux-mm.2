Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCDC2CCD184
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 06:43:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C7038E0034; Fri, 17 Oct 2025 02:43:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19ED08E0002; Fri, 17 Oct 2025 02:43:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DBCE8E0034; Fri, 17 Oct 2025 02:43:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0090D8E0002
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 02:43:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79FA4B9F95
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 06:43:50 +0000 (UTC)
X-FDA: 84006665820.09.547A008
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2D2E618000E
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 06:43:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SF6trazP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760683428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=27ILP3PisFWMzeZ0qER84rVbx10h57G1tQZ/rIsZYvs=;
	b=ESBvKQCm+W9Ff+wWVZ/mBbtQsVJgo6iK8yGdm/ZoBXu/3dF/yMpD+iUneg12PLKKGcaWQ3
	IvoCY3LxXO7JmT5w1rTslenXl9PKkPahA1ufSum43iOg8RLaj/3SZh7Xz2gXC1v+RTc7Et
	YN0Vmr2SsjOdPPOJ6ZG8DGLR4c3r+7k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SF6trazP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760683428; a=rsa-sha256;
	cv=none;
	b=ArcJz87WTS57iKH3D9za4mnfBNKI0s9xUB8uVrqDSmxEv8RVch39lVF6k7Uk2X4YqZ2Dcc
	F7Ki/DMMgpNKtBj0vWOHN9vCtWCrfXMirI2d72mbkB+QwRiD6zhvmc76ugKWtYpSe8teGu
	tV2d+Rv8V2WDXpI8WvQewJD6fSXHZlA=
Message-ID: <556352a6-70dc-4709-a0d2-038e2cd4fd88@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760683425;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=27ILP3PisFWMzeZ0qER84rVbx10h57G1tQZ/rIsZYvs=;
	b=SF6trazPBL787T7iEDAxBvdVButWkO6CS5V+nuyrFgUYLqFoXBQRYYcui4o8yhzXVDAw6Q
	73trCNxynS1BqseH1RPxZQBN4Ly7rQp7FOJSdRs+TKSYB8InQ60aiRNZv0gsjG4iTOwKtA
	DPrLw/8OxW3fwKx1kn7FASkApJxUPgI=
Date: Fri, 17 Oct 2025 14:42:56 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] slab: Avoid race on slab->obj_exts in alloc_slab_obj_exts
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hao Ge <gehao@kylinos.cn>
References: <20251017045749.3060696-1-hao.ge@linux.dev>
 <aPHcqbQkPV--NCt8@hyeyoo>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <aPHcqbQkPV--NCt8@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D2E618000E
X-Rspamd-Server: rspam03
X-Stat-Signature: i13kewshhkdiizcgeisnd576kzcui8bq
X-HE-Tag: 1760683427-118490
X-HE-Meta: U2FsdGVkX1+TZ+8v7tkE/ygOy1vNCPxTWLXSiYpUrc0YFb//wJLO+kys6ByeVsseycPzODV2L1wwMTc0tfGyz+EBRpwRoDx4twWgG3fXHxy+y4opmm0SYiKrfn68Vhsn4CUsibdTsDa2Nj0Cu1zjsDBarIb8/PxXwhRGL0tZb46WnFtOSlrzMDO4FVy8Tn/dxlMRF4AinCfUYt3NyvQuEnCpS8Eb5ICkangRHhy2jHSSM5ErHlNY6TO6FBm/yfj7jPf8p3XYTMVrwTAK8ZWywC4RHUuFn3moUKEynfXAZ6dIYrRpD7musB4XqCky702nI7Z7u6O+8w6Fmuhb8FZWNZX/FBw9U15xZZYjqr3ivc3eFf3CxxsXP2N+7JrWGttDaJ+ZKNKOCs7neGJFWpBFr3ETG/nx9Ooko+bzcPwGkhZAOw1oMKVI3WH+O5AXYursHepJSkCIopcRfAgWSb8BL3dG/dMbSbU0mRR7bTjKdRsjbLx0KPmLHInkbsSC6YPc7TkKAJWy94uFKytG3ogoPSrcj/XCW/LvYwdpNh9J6y3OxOEkAaUNQGpEPYI3R4UFfbFQFaKVZW5ERw6UQYLJ2yILvHKQYDwPC19HbhvwfTKkPNmHpAjiYVXY8VZl3zu8boeCN7wXNFQ1ExlXuCs5v5IfPdIyuI5KZzA4jFCbYsz1J3MMV1SrDzffFwYQtO49N0yCMageihYXn/F13V5neaCRPkWeMNoofUEipqAtQ98zQYoszgYY/cLhU9qWEo7NjBcPb3aYFQeEQqhpRwGoj5e7aHXEsfXsZD0iEgB37ve5ZNaMmmHX38j5dBkN+GPh0HzmuCLqXQElcXW0Epm7EDZxn3ArD8xCQ457+aMf5LnKAFNmwXfa0FF9XQXWlETJQhefOBcW6aDpNUHAnhCHdsDUkYkK4HysU4uEEvVsyK5Aw1riOs/nGs1ZRKw4TFNel/lj0FzSZQ1DKdesG3y
 InxrJbLC
 z9ZIU4ptStX72JbE9V9a9nmTAt+mscS8JImNVTK1RWYde5J+buD7FPq3d7pKM7rFnYFSFGPc7/CEkYAyec4W6zfRJsFFXVb2bc6vEO28fm2dMe0PwSOqsOw5TXUGXK+06cIXM18UKxrbC74bTlhM4pF4R6ZtDltPrhhOvkzu8K16vgvtpu/RZV5BBPt5wiIo3uASNbs7FZkNOBjo3gwTfFtzY1h/R1iEaSpKgGVQYdGe+971lnhDHWfo2zWQf2ecCo505UhCKF9iPTSJL1PJl3Np0FQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry


Thank you for your quick response.


On 2025/10/17 14:05, Harry Yoo wrote:
> On Fri, Oct 17, 2025 at 12:57:49PM +0800, Hao Ge wrote:
>> From: Hao Ge <gehao@kylinos.cn>
>>
>> In the alloc_slab_obj_exts function, there is a race condition
>> between the successful allocation of slab->obj_exts and its
>> setting to OBJEXTS_ALLOC_FAIL due to allocation failure.
>>
>> When two threads are both allocating objects from the same slab,
>> they both end up entering the alloc_slab_obj_exts function because
>> the slab has no obj_exts (allocated yet).
>>
>> And One call succeeds in allocation, but the racing one overwrites
>> our obj_ext with OBJEXTS_ALLOC_FAIL. The threads that successfully
>> allocated will have prepare_slab_obj_exts_hook() return
>> slab_obj_exts(slab) + obj_to_index(s, slab, p), where slab_obj_exts(slab)
>> already sees OBJEXTS_ALLOC_FAIL and thus it returns an offset based
>> on the zero address.
>>
>> And then it will call alloc_tag_add, where the member codetag_ref *ref
>> of obj_exts will be referenced.Thus, a NULL pointer dereference occurs,
>> leading to a panic.
>>
>> In order to avoid that, for the case of allocation failure where
>> OBJEXTS_ALLOC_FAIL is assigned, we use cmpxchg to handle this assignment.
>>
>> Thanks for Vlastimil and Suren's help with debugging.
>>
>> Fixes: f7381b911640 ("slab: mark slab->obj_exts allocation failures unconditionally")
> I think we should add Cc: stable as well?
> We need an explicit Cc: stable to backport mm patches to -stable.
Oh sorry, I missed this.
>
>> Signed-off-by: Hao Ge <gehao@kylinos.cn>
>> ---
>>   mm/slub.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 2e4340c75be2..9e6361796e34 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2054,7 +2054,7 @@ static inline void mark_objexts_empty(struct slabobj_ext *obj_exts)
>>   
>>   static inline void mark_failed_objexts_alloc(struct slab *slab)
>>   {
>> -	slab->obj_exts = OBJEXTS_ALLOC_FAIL;
>> +	cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL);
>>   }
> A silly question:
>
> If mark_failed_objexts_alloc() succeeds and a concurrent
> alloc_slab_obj_exts() loses, should we retry cmpxchg() in
> alloc_slab_obj_exts()?

Great point.

We could modify it like this, perhaps?

  static inline void mark_failed_objexts_alloc(struct slab *slab)
  {
+       unsigned long old_exts = READ_ONCE(slab->obj_exts);
+       if( old_exts == 0 )
+               cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL);
  }

Do you have any better suggestions on your end?

>
>> -- 
>> 2.25.1

