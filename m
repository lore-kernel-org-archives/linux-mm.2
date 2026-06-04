Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49051CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 07:58:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B7626B0005; Thu,  4 Jun 2026 03:58:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78E846B0088; Thu,  4 Jun 2026 03:58:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A4A66B008A; Thu,  4 Jun 2026 03:58:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C1B46B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 03:58:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C507016347F
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:58:39 +0000 (UTC)
X-FDA: 84841478358.25.E044B96
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0A81E120003
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:58:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FpaLIYtj;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780559918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cI/C7RCRmc8Hsh1eMUTfrVJyDrrbEkoM3eflEXaUTBE=;
	b=FkNZdNPu8tyQFa8G/mrpgSmJgBtg6FsRHGMrLgCW/NwDnouW6VuCp5H3l4FWytwkfQtzKt
	KlCIrTe3zZbZbN6Dvh97VPHgt5rI1EW1MqZeqwZGCG1MVotbcCz3EfIdyrNJNH0OQH5hob
	YN6GsCEMVjRIS1j9Ch/icSzO4u3AzQQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FpaLIYtj;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780559918;
	b=gXd9yvTGROdQnaOZG20KrWnmXC1EdjC/894BCJRBGZaXRUVUZ/DlVN0bv9PFsEYf2WbhrB
	I8okYfVHKfW9bds9ffWMCRzHiqE7my3JrLfkechFkCetM7v3aCzSBRJdiTaSaLKfr1k0ci
	aQtHtIQq44BPH1o1L7GHELk+zCpSnYs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EB98E41AF0;
	Thu,  4 Jun 2026 07:58:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D0A1F00893;
	Thu,  4 Jun 2026 07:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780559916;
	bh=cI/C7RCRmc8Hsh1eMUTfrVJyDrrbEkoM3eflEXaUTBE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FpaLIYtjwJ/lE1DJA8ORxe7LFYqGYDF+O8gjlNo1owKRCNg2b6VgTWAV+XMio2Xrv
	 HMRMuj5xQ4rwimdfYDCWt79HMeK+3QU6Ub16tsmehrXinULX/oli/WMK+h1olshPWp
	 jftrZ+RL8HFddxEjx8v0LgmawNo7+qPHitptILKCST7+NOp4f9DDbpGmty+YZBo4Ru
	 FIqV06x7qcjL3lsQfKYtyip+7HmXZ2McPWlz7E9LxC7Ntj2t8IRVa3edKTDvoVDdej
	 /RJDkNHt1+gC0GrjM2TG7DkIft/eOJeOLBQYJ53/dEaV7fLcQlptmbQHdS78sDQmIs
	 cr1UnsIoH0Lqw==
Message-ID: <a6cac07f-5509-4821-b0a8-dd3afb89c26e@kernel.org>
Date: Thu, 4 Jun 2026 09:58:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: preserve original size in _kmalloc_nolock_noprof
 retry path
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>, hu.shengming@zte.com.cn,
 akpm@linux-foundation.org
Cc: hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhang.run@zte.com.cn, cai.qu@zte.com.cn
References: <20260603211011530GqLSXP_rgcuQdR47IGQLL@zte.com.cn>
 <07f55792-c83f-433c-bb16-58a5824d1dd7@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <07f55792-c83f-433c-bb16-58a5824d1dd7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0A81E120003
X-Stat-Signature: 98kd3togf6rn5ttr8c1yw6q9p3sk1thj
X-Rspam-User: 
X-HE-Tag: 1780559917-276048
X-HE-Meta: U2FsdGVkX1+iXTTMj4DBqJEXK9B7z4c2QYrpDnj/SrbNa8cORhVhLlz8UwZV0EIvVMYuSDmTYAD9px+KRQhR0br3NTXrHYreFKl9wMqQM7n3yDxgQEeesLx0rwugeRX2F5ZR2EEW+rimof/Dy8wE36XUqRBC0LSsSLA9FpKT6Yxsy7vlpLkGwjySQasZY4KSUf/zy7o72HqG3fSEjIiqPqDWOp4wemwIGOXM2SimVo7BxyhY91PsrNE3uMYoEucVKlc5D0zV6TnYRw+BetuMi5okXWJMzOpKZQVdWvh9SDMGnufzLijPTn7nWxO3jcpxVdbDyVbm0+Sx0jMH2KXzsTNTnxJ6WbbGac+sLWX2PhEiqOH2Gp7c/EOAPXU0id2P1PMfktIO9w8aatA28MrKMfek5w3WqxSrUGbLRDxeQIHsI2DgFtvtRqkHdRKfBoSV/HYVAXTk/ds12GXZmRcxur1ShIrzlnGzp0E7Hy/KqN/LJX+6cUwjiAkqBlJOF8lIQPvWqAdAUeauC1vPpTfT7kpZkrItQsykT0qcD6Z5LUcv8F0iFTlmFuIqllIIgMKmC22yikfkgjNsAL4jV/F7FltZ4MeOSXZqBjhxK5ypkRXR7MLdzCluWaxwkaXmooCDdfa2KPyNTF+esKHaD14sNVU9ku8524yJ0A+PyA6NZFFXCBybgX4N4xdVhBjcFN01f4ZLsClQEYj8ZkyUB2PXLoDQMCFEcHXyHp5DYEGAqIPwubC7ScsMZs+igtJcNLN3exqxPN8EkA3czGJGABdCCxOJECbk6WmzxoYkthFxjxAPgjCML8euB2cf+6A6Ctw9a5DP/YLqfBfp85eRSM83v7Ys3kUvbzGrmGoZSC1CFS9NGmmrH1P5dx1xF6upL/v3rbGZgeST/Kny8+epKk4mUFoJCaHVujspAO9EOhtGWlj4D2PSv+3z+ru4rm+rOM3Da2j/yyxnLeLuvTeCohb
 zJVuS0rT
 si8HhoOebrzPFVjziq8A6aTClsPap5jqP6KGgXF4tCyo/Kn9oniKJJKl46eN4EU3YSFvJ5D7OCoDjJezXljZOpbs70qf+0vGGvqSs98EAI3FF+OkdCWqZ90pdyEmGIlhNVmWui/+n7YOSKU0wvpgM3TYs74K65zSpKN6bnGas0MprxXD6nXAvo3X2Ou/iID0HIRRHCGsUxjPxW1vUnoOojl61DnbCPRU4hdYwUhZrR6WUAD35twc/yteSnnEb/zMv7VXDPTwIKNmP8KqkYrD+HBPsKpSgApmWJgwb+Y76tfnE3u8rqDhPn3Pv+yGjW1hY/xSnQY+5UC67cZGz6MTCWasekP4m/ppa0C3sfvqpoC7afkPFkmJH6MNEBHVjziBiJeEsbw9SoSG4sLk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/4/26 07:46, Harry Yoo wrote:
> 
> 
> On 6/3/26 10:10 PM, hu.shengming@zte.com.cn wrote:
>> From: Shengming Hu <hu.shengming@zte.com.cn>
>> 
>> _kmalloc_nolock_noprof() retries from the next kmalloc bucket when the
>> initial allocation fails. The retry currently reuses `size` as the
>> bucket selector and overwrites it with s->object_size + 1.
>> 
>> That value is later passed as the original allocation size to
>> __slab_alloc_node(), slab_post_alloc_hook() and kasan_kmalloc(). On a
>> successful retry this makes KASAN/slub-debug observe the retry bucket
>> selector rather than the caller requested size, potentially widening the
>> valid kmalloc range and hiding overflows.
> 
> Good catch!
> 
>> Keep a separate `bucket_size` for choosing the retry cache and preserve
>> `size`.
>> 
>> Fixes: <af92793e52c3> ("slab: Introduce kmalloc_nolock() and kfree_nolock()")
>> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
>> ---
> 
> I want to note that this conflicts with Vlastimil's work-in-progress
> feature [1] where it separately stores orig_size in struct
> slab_alloc_context which naturally solves the problem.

Thanks, didn't realize it was solving this problem as a side-effect, hehe.

> [1]
> https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=b4/slab_alloc_flags
> 
> No strong opinion on whether to queue this patch and then rebase
> Vlastimil's work on top, or wait for Vlastimil's work to solve the
> problem instead...

It's better to queue fixes separately first, in case someone wants to
backport them, even though stable shouldn't be really necessary here.
This fix could still go to 7.2 but my series only to 7.3.

>>  mm/slub.c | 7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>> 
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 67abbbf68fc1..6a2b3ade3611 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -5350,6 +5350,7 @@ EXPORT_SYMBOL(__kmalloc_noprof);
>>  void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, int node)
>>  {
>>  	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_NOMEMALLOC | gfp_flags;
>> +	size_t bucket_size = size;
>>  	struct kmem_cache *s;
>>  	bool can_retry = true;
>>  	void *ret;
> 
> But in either way, I think it's more straightforward to introduce
> orig_size as a variable to keep the original size and pass it to
> __slab_alloc_node().

Agree. Because above, we wouldn't initialize bucket_size to a real bucket
size, but a <=bucket size so it's misleading.

>> @@ -5372,9 +5373,9 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
>>  		return NULL;
>> 
>>  retry:
>> -	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
>> +	if (unlikely(bucket_size > KMALLOC_MAX_CACHE_SIZE))
>>  		return NULL;
>> -	s = kmalloc_slab(size, NULL, alloc_gfp, PASS_TOKEN_PARAM(token));
>> +	s = kmalloc_slab(bucket_size, NULL, alloc_gfp, PASS_TOKEN_PARAM(token));
>> 
>>  	if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))
>>  		/*
>> @@ -5408,7 +5409,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
>>  	 */
>>  	if (!ret && can_retry) {
>>  		/* pick the next kmalloc bucket */
>> -		size = s->object_size + 1;
>> +		bucket_size = s->object_size + 1;
>>  		/*
>>  		 * Another alternative is to
>>  		 * if (memcg) alloc_gfp &= ~__GFP_ACCOUNT;
> 


