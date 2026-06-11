Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB242CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 14:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16CAC6B0088; Thu, 11 Jun 2026 10:47:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 144416B008C; Thu, 11 Jun 2026 10:47:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05B3D6B0092; Thu, 11 Jun 2026 10:47:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E82BA6B0088
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 10:47:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1081E1C3640
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:47:28 +0000 (UTC)
X-FDA: 84867910176.21.C307DF5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4FAD020014
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:47:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lnK7LTc8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781189246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/3JFb1sbaEUTIauG/U36iS6yAHjicqrq7RLpzLEMWoU=;
	b=QvU3vuGpPa1vXWTt57db8ffGm5hSwfnSh4ZS6g2/OU3CAR9/kZ62rje5ZpFlN7cgaY/rru
	0a8/3PjC8EMNh+G7OuIDxW4itsPElzk61Ec5DA/4qI2a7far1Tg8rlMYgS7CnXTqKiHPIK
	zPvB542BwivWv2BIMHUZNvUVc0b/ek4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lnK7LTc8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781189246;
	b=1mTSAHrfv2zJh5Mcf8Cjbsd4GZDL/Th3gCSj3wWq2FRCIQsptEbXXW+nzuYt+tfz5raIMJ
	nFLN8j0jSplKum00Eft4dQCUa7e3vTN0/asnzQkGTXJUwk7cDr+rLgQ6b+gEsk00BkK9Ww
	nVIt2Z+6Dmv3G1v9+w7HUkjRHFrV0ns=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B9110600AA;
	Thu, 11 Jun 2026 14:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1B01F00893;
	Thu, 11 Jun 2026 14:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781189245;
	bh=/3JFb1sbaEUTIauG/U36iS6yAHjicqrq7RLpzLEMWoU=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=lnK7LTc8Ghirv4b0x4eT1JlORRSRij4PLr2iZEhXF+tTAKU9Ntjps9dqM0W+MPXwA
	 2/sekzCrrk9rSjtOqHM7VDTKY4UdLpR+uufWwOVWb0dwokkJVkplYz6cm9eNf/kkO3
	 e13eDfcEVJasY0gFmsriC/eSR3mxNaqcUS/uN93YyhSshmKjd33kExgGwKfDOFOgvg
	 7H3HWRfRAEhUMGdA52Ycp8/lnTC2XKYBxj2Muh65nu3oSM1ElUlnYwjVXngbzA+DWY
	 8hMN8rRQHOkYDJ9ua8MqWBBmZFa6YMxMvxaBXN7zohS1W1sYp46zG2Ebbz3jw/OxES
	 eHfhzSMNuiekw==
Message-ID: <e71bfc13-c233-4f85-a6ec-76327d3c6510@kernel.org>
Date: Thu, 11 Jun 2026 16:47:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/16] mm/slab: do not init any kfence objects on
 allocation
Content-Language: en-US
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-2-7190909db118@kernel.org>
 <b6530e92-d648-4028-9e77-0df8c3ab166d@kernel.org>
 <159d1e20-5b21-4329-ac9a-f7a5cb0fd56a@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <159d1e20-5b21-4329-ac9a-f7a5cb0fd56a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4FAD020014
X-Rspam-User: 
X-Stat-Signature: wo15mrz33yjz8xxxjztw5qqiythjz9c1
X-Rspamd-Server: rspam09
X-HE-Tag: 1781189246-919605
X-HE-Meta: U2FsdGVkX18OvwR7zBWxKVD9XuvtKKp1aQpTvAQEBiF7SK+nNswiLb1lbgniAO1NP8MynkIlWeyqaVf1WSk5cCOsCr7xqze/qX+wDLMN5d/X5GJo4m1Q3wJg7PZXqag6aA6FnDUJsA0oXdJCoDmKGrruiUObkDQP2vgmOqcJFqmLBWzodJ9sXST1MOnCN1tgnH3LZ9wKFgz//KL8NxbIQtuYeFeHCDoSEmcpGokwCvaKazm9Ry21wNQJLactKtGotcwD83NCYrcFkkOt/DVE9rQHFlF3hNscdYSK4s4J2MmV94JKF5x6q7IjRq5wjWXLR/CyD5ir91BvlDCQn+ly9GjM9SmMFlRfL8+xkDlIsbLuSxK57IBFLmZ3RYt3iqnaqCGShif+859RfiH8cAGNfXMdomhW6MP/hbdGTrgpgR9B0xyCKQuF8evWbdyPt7tsKoU2F9NrJM0C9kEvERbGvqo1Qo9t68TorgiMRBO1ccs81KglUJoyudI6yyQgMNXQDIrgC2BgXrAxgihB+oUNj9JAQ1YEGCbgeT0buynTRGRq4rlpWjaKRtVnhH24L1Rn65xkuIhbVB8bS37fdzZy13Ir77B/NlR73Tyw6pN5Bfunf9E/JFxFIwaxklBQ9LXt721tUeDuiy0/8UDyhOcniOu6SFO2aDlaVrmdK/XimcGFzVkpCW1ppLqomCizYBpIfPwfVgUUQbB2AdTe4xz22HXkxt/yspEMN+BUaIYBGEgzZQzz/Q9Z7SWIb9YabJdn83PDMBCr6VrbcF6Hm2NF9TBqlaaPbDcmxffGjNefKPm9nrkO8E4y0d/tizAFRXixG+cwwkwRTAnT+g0mpv+XwT99yLxly7kOOz8LLGWhVyqLPWnnTBScLuu4FQLsM9/GsiGUepqUJ6FmDlDsfDSJ+ub7I+3v1Y1xXBxajNntWdxiLAyWUhe5rl42BWTA4OxSdNJbAL+kxbkzt3OOn6+
 LaAB0ht1
 KWuEksW59tp1b15d0ESk/4OFs4XcqscAvmMBVqe6o+sLfVlQ8847i9JDVU4vtSBvdkUiMjHGXQl6iIFlgpOfF9btdrfadVecsm8a+qw+Oct+IpxA1Hal8ezC4M0hmt4ZOIS1BCKp+VDILD6rM/ZIXfpVGuCMJ+hI2sD0sNoPjdbXUXoJ7lCiwKOzwnMnJf2AofZdhvHyqh0CHfW9cNFZAVf0ap9rLs0t6ZXIoobZooPBPyAianE+LjBNrOPxG8Fj2zk+bc4oG0GSj/b8WN3X8VBx9ltycO/j85XHvVpivNDG55TIFs7TkYD6ewVjkoUfKXldcNhi2tz5GCCe1AaxKY6rd4UmH/9G83e61kiNn0txBhH0pnzL67kUjpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/11/26 10:34, Vlastimil Babka (SUSE) wrote:
> On 6/11/26 05:19, Harry Yoo wrote:
>> 
>>> This potentially adds overhead of the is_kfence_address() check to
>>> allocation hotpath, but that one is designed to be as small as possible,
>>> and it's only evaluated if zeroing is about to happen. This means (aside
>>> from init_on_alloc hardening) only for __GFP_ZERO allocations, and the
>>> zeroing itself comes with an overhead likely larger than the added
>>> check.
>>> 
>>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>>> ---
>>>  mm/kfence/core.c |  2 +-
>>>  mm/slub.c        | 23 ++++++++---------------
>>>  2 files changed, 9 insertions(+), 16 deletions(-)
>>> 
>>> diff --git a/mm/slub.c b/mm/slub.c
>>> index e2ee8f1aaccf..8e5264d3ddbf 100644
>>> --- a/mm/slub.c
>>> +++ b/mm/slub.c
>>> @@ -4565,9 +4565,10 @@ struct kmem_cache *slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags)
>>>  
>>>  static __fastpath_inline
>>>  bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
>>> -			  gfp_t flags, size_t size, void **p, bool init,
>>> +			  gfp_t flags, size_t size, void **p,
>>>  			  unsigned int orig_size)
>>>  {
>>> +	bool init = slab_want_init_on_alloc(flags, s);
>>>  	unsigned int zero_size = s->object_size;
>>>  	bool kasan_init = init;
>>>  	size_t i;
>>> @@ -4608,7 +4609,8 @@ bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
>>>  	for (i = 0; i < size; i++) {
>>>  		p[i] = kasan_slab_alloc(s, p[i], init_flags, kasan_init);
>>>  		if (p[i] && init && (!kasan_init ||
>>> -				     !kasan_has_integrated_init()))
>>> +				     !kasan_has_integrated_init())
>>> +				 && !is_kfence_address(p[i]))
>> 
>> I hope we could make it bit more verbose and straightforward,
>> something like:
>> 
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 5d7ea72ebebd..29cf4590f9d9 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -4573,7 +4573,6 @@ bool slab_post_alloc_hook(struct kmem_cache *s,
>> gfp_t flags, size_t size,
>>  {
>>  	bool init = slab_want_init_on_alloc(flags, s);
>>  	unsigned int zero_size = s->object_size;
>> -	bool kasan_init = init;
>>  	size_t i;
>>  	gfp_t init_flags = flags & gfp_allowed_mask;
>> 
>> @@ -4591,29 +4590,37 @@ bool slab_post_alloc_hook(struct kmem_cache *s,
>> gfp_t flags, size_t size,
>>  	if (slub_debug_orig_size(s))
>>  		zero_size = ac->orig_size;
>> 
>> -	/*
>> -	 * When slab_debug is enabled, avoid memory initialization integrated
>> -	 * into KASAN and instead zero out the memory via the memset below with
>> -	 * the proper size. Otherwise, KASAN might overwrite SLUB redzones and
>> -	 * cause false-positive reports. This does not lead to a performance
>> -	 * penalty on production builds, as slab_debug is not intended to be
>> -	 * enabled there.
>> -	 */
>> -	if (__slub_debug_enabled())
>> -		kasan_init = false;
>> -
>> -	/*
>> -	 * As memory initialization might be integrated into KASAN,
>> -	 * kasan_slab_alloc and initialization memset must be
>> -	 * kept together to avoid discrepancies in behavior.
>> -	 *
>> -	 * As p[i] might get tagged, memset and kmemleak hook come after KASAN.
>> -	 */
>>  	for (i = 0; i < size; i++) {
>> -		p[i] = kasan_slab_alloc(s, p[i], init_flags, kasan_init);
>> -		if (p[i] && init && (!kasan_init ||
>> -				     !kasan_has_integrated_init())
>> -				 && !is_kfence_address(p[i]))
>> +		bool skip_init = false;
>> +
>> +		if (is_kfence_address(p[i])) {
>> +			/*
>> +			 * kfence zeroes the object instead of SLUB to avoid
>> +			 * overwriting its own redzone, and zeroing of
>> +			 * s->object_size will corrupt it.
>> +			 */
>> +			skip_init = true;
> 
> But now we perform this check even if init is false, making it more hot.
> 
>> +		} else if (__slub_debug_enabled()) {
>> +			/*
>> +			 * KASAN never zeroes memory when slab_debug is enabled
>> +			 * to avoid overwriting SLUB redzones. This does not
>> +			 * lead to a performance penalty on production builds,
>> +			 * as slab_debug is not intended to be enabled there.
>> +			 */
>> +			skip_init = false;
>> +		} else if (kasan_has_integrated_init()) {
>> +			/*
>> +			 * ARM64 can set memory tags and zero the memory using
>> +			 * a single instruction. Since HW_TAGS KASAN uses that
>> +			 * while tagging the object, a separate zeroing is
>> +			 * unnecessary unless slab_debug is enabled.
>> +			 */
> 
> (I like the new/updated comments)
> 
>> +			skip_init = true;
>> +		}>
> 
> And these two are now done in every loop iteration even though they don't
> depend on the object. Yeah it's a static key and build-time constant but still.
> 
> But maybe there's some middle ground?
> 
> Above the loop do (with your comments).

OK, not so simple, we still need the kasan_init variable too.
I've ended up with this, thoughts?

From 3a1c4398ce9f361a4e6f4d9946eab6237eea89c2 Mon Sep 17 00:00:00 2001
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 10 Jun 2026 17:40:04 +0200
Subject: [PATCH] mm/slab: do not init any kfence objects on allocation

When init (zeroing) on allocation is requested, for kmalloc() we
generally have to zero the full object size even if a smaller size is
requested, in order to provide krealloc()'s __GFP_ZERO guarantees.

When we end up allocating a kfence object, kfence perfoms the zeroing on
its own because has its own redzone beyond the requested size. Thus
slab_post_alloc_hook() has an 'init' parameter which has to be evaluated
in all callers (via slab_want_init_on_alloc()) and should be false for
kfence allocations.

For kfence allocations in slab_alloc_node() this is achieved by subtly
skipping over the slab_want_init_on_alloc() call. Other callers (i.e.
kmem_cache_alloc_bulk_noprof()) however evaluate it unconditionally even
if they do end up with a kfence allocation. This is only subtly not a
problem, as those are not kmalloc allocations and thus the "requested
size" equals s->object_size and thus it cannot interfere with kfence's
redzone. There's just a unnecessary double zeroing (in both kfence and
slab_post_alloc_hook()), but it's all very fragile and contradicts the
comment in kfence_guarded_alloc().

Remove this subtlety and simplify the code by eliminating the init
parameter from slab_post_alloc_hook() and make it call
slab_want_init_on_alloc() itself. Instead add a is_kfence_address()
check before performing the memset, which will start doing the right
thing for all callers of slab_post_alloc_hook().

This potentially adds overhead of the is_kfence_address() check to
allocation hotpath, but that one is designed to be as small as possible,
and it's only evaluated if zeroing is about to happen. This means (aside
from init_on_alloc hardening) only for __GFP_ZERO allocations, and the
zeroing itself comes with an overhead likely larger than the added
check.

While at it, refactor the handling of evaluating when KASAN does the
init instead of SLUB, with no intended functional changes. A
non-functional change is that we don't pass kasan_init as true to
kasan_slab_alloc() if kasan has no integrated init, but then the value
is ignored anyway, so it's theoretically more correct.

Thanks to Harry Yoo for the initial refactoring attempt, and for updated
comments that are used here.

Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-2-7190909db118@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/kfence/core.c |  2 +-
 mm/slub.c        | 60 ++++++++++++++++++++++--------------------------
 2 files changed, 29 insertions(+), 33 deletions(-)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 655dc5ce3240..5e0b406924e9 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -500,7 +500,7 @@ static void *kfence_guarded_alloc(struct kmem_cache *cache, size_t size, gfp_t g
 
 	/*
 	 * We check slab_want_init_on_alloc() ourselves, rather than letting
-	 * SL*B do the initialization, as otherwise we might overwrite KFENCE's
+	 * slab do the initialization, as otherwise it might overwrite KFENCE's
 	 * redzone.
 	 */
 	if (unlikely(slab_want_init_on_alloc(gfp, cache)))
diff --git a/mm/slub.c b/mm/slub.c
index e2ee8f1aaccf..d762cbe5d040 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4565,13 +4565,13 @@ struct kmem_cache *slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags)
 
 static __fastpath_inline
 bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
-			  gfp_t flags, size_t size, void **p, bool init,
+			  gfp_t flags, size_t size, void **p,
 			  unsigned int orig_size)
 {
+	bool init = slab_want_init_on_alloc(flags, s);
 	unsigned int zero_size = s->object_size;
-	bool kasan_init = init;
-	size_t i;
 	gfp_t init_flags = flags & gfp_allowed_mask;
+	bool kasan_init = false;
 
 	/*
 	 * For kmalloc object, the allocated size (object_size) can be larger
@@ -4588,28 +4588,33 @@ bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 		zero_size = orig_size;
 
 	/*
-	 * When slab_debug is enabled, avoid memory initialization integrated
-	 * into KASAN and instead zero out the memory via the memset below with
-	 * the proper size. Otherwise, KASAN might overwrite SLUB redzones and
-	 * cause false-positive reports. This does not lead to a performance
+	 * ARM64 can set memory tags and zero the memory using a single
+	 * instruction. Since HW_TAGS KASAN uses that while tagging the object,
+	 * separate zeroing is unnecessary.
+	 *
+	 * However, KASAN never zeroes memory when slab_debug is enabled to
+	 * avoid overwriting SLUB redzones. This does not lead to a performance
 	 * penalty on production builds, as slab_debug is not intended to be
 	 * enabled there.
 	 */
-	if (__slub_debug_enabled())
-		kasan_init = false;
+	if (kasan_has_integrated_init() && !__slub_debug_enabled()) {
+		kasan_init = init;
+		init = false;
+	}
 
-	/*
-	 * As memory initialization might be integrated into KASAN,
-	 * kasan_slab_alloc and initialization memset must be
-	 * kept together to avoid discrepancies in behavior.
-	 *
-	 * As p[i] might get tagged, memset and kmemleak hook come after KASAN.
-	 */
-	for (i = 0; i < size; i++) {
+	for (size_t i = 0; i < size; i++) {
 		p[i] = kasan_slab_alloc(s, p[i], init_flags, kasan_init);
-		if (p[i] && init && (!kasan_init ||
-				     !kasan_has_integrated_init()))
+
+		/*
+		 * memset and hooks come after KASAN as p[i] might get tagged
+		 *
+		 * kfence zeroes the object instead of SLUB to avoid overwriting
+		 * its own redzone starting at orig_size, which could happen
+		 * with SLUB zeroing full s->object_size
+		 */
+		if (init && p[i] && !is_kfence_address(p[i]))
 			memset(p[i], 0, zero_size);
+
 		if (gfpflags_allow_spinning(flags))
 			kmemleak_alloc_recursive(p[i], s->object_size, 1,
 						 s->flags, init_flags);
@@ -4910,7 +4915,6 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 		gfp_t gfpflags, int node, unsigned long addr, size_t orig_size)
 {
 	void *object;
-	bool init = false;
 
 	s = slab_pre_alloc_hook(s, gfpflags);
 	if (unlikely(!s))
@@ -4926,16 +4930,13 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 		object = __slab_alloc_node(s, gfpflags, node, addr, orig_size);
 
 	maybe_wipe_obj_freeptr(s, object);
-	init = slab_want_init_on_alloc(gfpflags, s);
 
 out:
 	/*
-	 * When init equals 'true', like for kzalloc() family, only
-	 * @orig_size bytes might be zeroed instead of s->object_size
 	 * In case this fails due to memcg_slab_post_alloc_hook(),
 	 * object is set to NULL
 	 */
-	slab_post_alloc_hook(s, lru, gfpflags, 1, &object, init, orig_size);
+	slab_post_alloc_hook(s, lru, gfpflags, 1, &object, orig_size);
 
 	return object;
 }
@@ -5230,7 +5231,6 @@ kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *s, gfp_t gfp,
 				   struct slab_sheaf *sheaf)
 {
 	void *ret = NULL;
-	bool init;
 
 	if (sheaf->size == 0)
 		goto out;
@@ -5240,10 +5240,8 @@ kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *s, gfp_t gfp,
 	if (likely(!ret))
 		ret = sheaf->objects[--sheaf->size];
 
-	init = slab_want_init_on_alloc(gfp, s);
-
 	/* add __GFP_NOFAIL to force successful memcg charging */
-	slab_post_alloc_hook(s, NULL, gfp | __GFP_NOFAIL, 1, &ret, init, s->object_size);
+	slab_post_alloc_hook(s, NULL, gfp | __GFP_NOFAIL, 1, &ret, s->object_size);
 out:
 	trace_kmem_cache_alloc(_RET_IP_, ret, s, gfp, NUMA_NO_NODE);
 
@@ -5423,8 +5421,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 
 success:
 	maybe_wipe_obj_freeptr(s, ret);
-	slab_post_alloc_hook(s, NULL, alloc_gfp, 1, &ret,
-			     slab_want_init_on_alloc(alloc_gfp, s), orig_size);
+	slab_post_alloc_hook(s, NULL, alloc_gfp, 1, &ret, orig_size);
 
 	ret = kasan_kmalloc(s, ret, orig_size, alloc_gfp);
 	return ret;
@@ -7339,8 +7336,7 @@ bool kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags,
 
 out:
 	/* memcg and kmem_cache debug support and memory initialization */
-	return likely(slab_post_alloc_hook(s, NULL, flags, size, p,
-			slab_want_init_on_alloc(flags, s), s->object_size));
+	return likely(slab_post_alloc_hook(s, NULL, flags, size, p, s->object_size));
 }
 EXPORT_SYMBOL(kmem_cache_alloc_bulk_noprof);
 
-- 
2.54.0



