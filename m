Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94E7ED0D145
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 17:09:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C34066B0005; Wed,  7 Jan 2026 12:09:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0B636B0088; Wed,  7 Jan 2026 12:09:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AED1D6B0092; Wed,  7 Jan 2026 12:09:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9DF466B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 12:09:02 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3910713AF13
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 17:09:02 +0000 (UTC)
X-FDA: 84305802924.20.3528A56
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9347B40013
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 17:08:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yOr4dsBY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2Vjs7QAK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yOr4dsBY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2Vjs7QAK;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767805740; a=rsa-sha256;
	cv=none;
	b=A30AnFv/e1fWmQ/JFdb/Kt+hZqkkvbz52A1mCMwzSMb89zeUaXtQBowWgcxJvjTwfuCpbR
	AWb8t1ZhqZGT/2eW2KXmR/mxqgG3/fqAo7HdUoxr6BAfi10Uey2kGxeJzdKf7f/NTYVoZJ
	/BWENPow9mSmxlHsy4sg5G+0Sjtpkpc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yOr4dsBY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2Vjs7QAK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yOr4dsBY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2Vjs7QAK;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767805740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8QD95a0wYk6luGnaJtfq/jQEMVDXv++XppQOZcRLczQ=;
	b=C+sPF+198FN3L+1DEg7vbw951fHC19pRJ+gXKm9/5ol+HL2S0BrfS1btoZucrnfxn8LIut
	Yf7czYHLElhmI7O5FYo5bbEvl6XD9XwMPzRFOqEb1Q7TUJz5tTds0u6faLrFpC2S2rD3Jx
	Rn6t9DCqfKCbSS3rNppY9/Updk4yQwM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AE8A334070;
	Wed,  7 Jan 2026 17:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767805737; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8QD95a0wYk6luGnaJtfq/jQEMVDXv++XppQOZcRLczQ=;
	b=yOr4dsBY3Mj6ddqZlcFAyjmHUnkutVjvpYhe/yfO3KwWX6wM81RvVif2llgQeTTN/LhaIZ
	CSkFnd+PQfLge8g3V7uecRF808fPIR7psh3k4JUC8Ljhq+TtVP64AEJNpZoKBGC/NjRVxi
	zXa0+hvA44bRlL6+evOP69SJKFaVHjA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767805737;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8QD95a0wYk6luGnaJtfq/jQEMVDXv++XppQOZcRLczQ=;
	b=2Vjs7QAK/XGu5nVeTnzQMI17QMocDVk3y+fvR1i143vkBdJeo+mwp4u8lzZ9/zpdGs+yfT
	xduaLzItQXt3qIDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767805737; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8QD95a0wYk6luGnaJtfq/jQEMVDXv++XppQOZcRLczQ=;
	b=yOr4dsBY3Mj6ddqZlcFAyjmHUnkutVjvpYhe/yfO3KwWX6wM81RvVif2llgQeTTN/LhaIZ
	CSkFnd+PQfLge8g3V7uecRF808fPIR7psh3k4JUC8Ljhq+TtVP64AEJNpZoKBGC/NjRVxi
	zXa0+hvA44bRlL6+evOP69SJKFaVHjA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767805737;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8QD95a0wYk6luGnaJtfq/jQEMVDXv++XppQOZcRLczQ=;
	b=2Vjs7QAK/XGu5nVeTnzQMI17QMocDVk3y+fvR1i143vkBdJeo+mwp4u8lzZ9/zpdGs+yfT
	xduaLzItQXt3qIDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 863873EA63;
	Wed,  7 Jan 2026 17:08:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RE9wICmTXmlUYwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 07 Jan 2026 17:08:57 +0000
Message-ID: <644e163d-edd9-4128-9516-0f70a25526df@suse.cz>
Date: Wed, 7 Jan 2026 18:08:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 7/8] mm/slab: save memory by allocating slabobj_ext
 array from leftover
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>, akpm@linux-foundation.org
Cc: andreyknvl@gmail.com, cl@gentwo.org, dvyukov@google.com,
 glider@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 mhocko@kernel.org, muchun.song@linux.dev, rientjes@google.com,
 roman.gushchin@linux.dev, ryabinin.a.a@gmail.com, shakeel.butt@linux.dev,
 surenb@google.com, vincenzo.frascino@arm.com, yeoreum.yun@arm.com,
 tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, hao.li@linux.dev
References: <20260105080230.13171-1-harry.yoo@oracle.com>
 <20260105080230.13171-8-harry.yoo@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260105080230.13171-8-harry.yoo@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9347B40013
X-Stat-Signature: tmbqnj1rwxcri9oknh1nkrgsdbau7xka
X-Rspam-User: 
X-HE-Tag: 1767805739-27717
X-HE-Meta: U2FsdGVkX19APllnbi2fRWqynFXw2nfZGyeB2sMgjO72Oeoa3FJFo/VSU7WzJOb1OCWdWp3iG2BsG9EbeJz795Di7RJPbM7Xr4CJ+OO60nr6lq9DeMYicos3kGPaw2Pg9UgPQB7bzJYY0DKsR3NTVQsbiiPBAfsAHcUAkG09ts5kX87PUvFIwKB1mgvSi4SQo2P4iyDEq6R54dM2L+mv1kk3ymr3k/UsaUnq0+aYAJCF61oBAR3WvRJzMFj89sSlaIjZNZlTyxVBudd2kdjHWqv+Pu9QMntYfkdStHI2XI54AdzM7bwMjbe5UZuzOk2u84r03DRZsajioTLShZM0pb5l49xfFIHi91gfkk6Q4s+RpvQoZTYFloWVcdUGpQul6pxFNSkubSKM/zt9ShNHJO+VdJMme6A6UBOCI2GFRNdaW33BUX2f3RjN2xz9GT+uE8YBny5qI+a409LojnN6eM8IAMaTt16cTuluwpcAZDTgUHHP1xAU5Ssy3Z9D5OTjd4wSkqTtV/gXGr0yEdx3CKY5vNdKOvtYU8v93oGCacqn6WBkHniBs2Q99l6B+vvRqb+V91MwSS+oqGrp17IfJZrcjNJVB7KOht8WHdACDWVORuUNxQXKgxOumff+rXJNvaco9Mog0gqKWyJcdF465IU0o9m8XzvOo2Y7FsiwwKnRFaAKhfaId/OKfv407+M9DWxzhblQLLFTkWLWZ2bMMMjb7rhhu5ZmKJHJREk370fkD20b8EQXQGdRdnPuTQci+l8aS/RDZ2+jNqG+2cbnSE+IQbGtxWkjMx7U1ZFIvQ6vWVbzSgJwQD0eplxTfYbLkmixCvoQ6sRIemhzlNvV0Lc5/sF1nYR8qVU/tM7i90qISbt0zfL4XE3diXXbsOMRq7rRJhnxk0zGLtuk4wKacyS4CxvCKEPOTsw771AUKMjfEV4XiRsiycGnaA5YNSPc7GIvF1O9Qj8RgeslH6O
 vfUkWsp0
 eSJh5MbYI8VFRASzsmNXAtMguDQ/FSkFbsl5kzhKr2tpz8FrVDGrVieX8pIqFOs4cCCP+1b+Fa42wCPXcwyNHUOfTWV0wvkt8Pgu+DwKPJgGA8+RNzjSfBzU+sH6ups5E73QNgV2fXP0GE7m/zl+3VjW+/K1WxHlH/9wQPUqjzknM+mURKmAHUua/SzAg1iP1hi8A20nr2oblLQyU9Ro8mAkOSjNwl/tQC1WWyOSLm2FdA2VePYeb5a5W5uRx+5Up3AOPRgDhQ5N6m7yQpG6d68r75qLTjqsqNjJh3FI86ofkE0nIXiz1jfMbymAJd08iMvII/EYi6RLoT88AOigMjF0f4Mw1QC29ygH7JIphoqSaiC6QlAG1bXLfpjadxuy9TisPoeY8HR/VNx61lj7hzXMxj84Auz7OSFzl9SCxTa+EUFGaySPAzkaZoJBned38QiqYq0nmyxBKITE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/5/26 09:02, Harry Yoo wrote:
> The leftover space in a slab is always smaller than s->size, and
> kmem caches for large objects that are not power-of-two sizes tend to have
> a greater amount of leftover space per slab. In some cases, the leftover
> space is larger than the size of the slabobj_ext array for the slab.
> 
> An excellent example of such a cache is ext4_inode_cache. On my system,
> the object size is 1136, with a preferred order of 3, 28 objects per slab,
> and 960 bytes of leftover space per slab.
> 
> Since the size of the slabobj_ext array is only 224 bytes (w/o mem
> profiling) or 448 bytes (w/ mem profiling) per slab, the entire array
> fits within the leftover space.
> 
> Allocate the slabobj_exts array from this unused space instead of using
> kcalloc() when it is large enough. The array is allocated from unused
> space only when creating new slabs, and it doesn't try to utilize unused
> space if alloc_slab_obj_exts() is called after slab creation because
> implementing lazy allocation involves more expensive synchronization.
> 
> The implementation and evaluation of lazy allocation from unused space
> is left as future-work. As pointed by Vlastimil Babka [1], it could be
> beneficial when a slab cache without SLAB_ACCOUNT can be created, and
> some of the allocations from the cache use __GFP_ACCOUNT. For example,
> xarray does that.
> 
> To avoid unnecessary overhead when MEMCG (with SLAB_ACCOUNT) and
> MEM_ALLOC_PROFILING are not used for the cache, allocate the slabobj_ext
> array only when either of them is enabled on slab allocation.
> 
> [ MEMCG=y, MEM_ALLOC_PROFILING=n ]
> 
> Before patch (creating ~2.64M directories on ext4):
>   Slab:            4747880 kB
>   SReclaimable:    4169652 kB
>   SUnreclaim:       578228 kB
> 
> After patch (creating ~2.64M directories on ext4):
>   Slab:            4724020 kB
>   SReclaimable:    4169188 kB
>   SUnreclaim:       554832 kB (-22.84 MiB)
> 
> Enjoy the memory savings!
> 
> Link: https://lore.kernel.org/linux-mm/48029aab-20ea-4d90-bfd1-255592b2018e@suse.cz [1]
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>

> +static inline bool obj_exts_in_slab(struct kmem_cache *s, struct slab *slab)
> +{
> +	unsigned long expected;
> +	unsigned long obj_exts;
> +
> +	obj_exts = slab_obj_exts(slab);
> +	if (!obj_exts)
> +		return false;
> +
> +	if (!obj_exts_fit_within_slab_leftover(s, slab))
> +		return false;
> +
> +	expected = (unsigned long)slab_address(slab);
> +	expected += obj_exts_offset_in_slab(s, slab);
> +	return obj_exts == expected;
> +}

Wonder if we could just check if the pointer is within the slab page's
virtual address range. And if we need to distinguish if it's slab_leftover
or unused within s->size, determine it by the stride?


