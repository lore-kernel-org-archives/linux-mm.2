Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3806CD98F9
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:22:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B221E6B0088; Thu, 18 Jun 2026 20:22:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAC406B008A; Thu, 18 Jun 2026 20:22:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99ABE6B008C; Thu, 18 Jun 2026 20:22:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6877A6B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:22:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C67741A029A
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:22:03 +0000 (UTC)
X-FDA: 84894759726.25.2564B40
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf31.hostedemail.com (Postfix) with ESMTP id AA43C20003
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:22:01 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mM2OgRQP;
	spf=pass (imf31.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781828522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TacnOFFQBHM2kdpmFXzPsQJ6Zb/KM4XHoRnV2vJcRq4=;
	b=1EPuO+lJd/Q9zJj+CoMQMVy0lq5ADPJYkOxP/qKNLkCqRBG8u3LRiy79CtYGCrJ2lEDHRG
	iEjluHzeUiYsx8+6nIpZd6p6w1ks8S3ydSmI3Pm4n/+C3yX11K4HQdHDJLya7B2j0pY0Cl
	Dcv5C06S6CquSBPCqFnjKw57g3z+XrA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781828522;
	b=NZMfB7C3dDu4anCn/zihtzaanzEi3OS2jROmqZJ+4NZHh72p1sKpCTKA5Q9v8DX9JhBWzt
	E4qaIxEqmlRKpFrGeTF2AgIXJ3NI85HV/JeqFPSuawLZ7NdKsyNf/J3cqZu5w9pu08ymE7
	i627VZ3g6aK8ZTNQtwUcw9YbrrU7nqM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mM2OgRQP;
	spf=pass (imf31.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <b1a8a69d-ab12-4050-8468-1a05a82f290c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781828519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TacnOFFQBHM2kdpmFXzPsQJ6Zb/KM4XHoRnV2vJcRq4=;
	b=mM2OgRQPEnVh9XkWXKSvoXPWvCmRUUOLahZp5g3ZH6yZld0r05uNbFC5x6AamALhKM1IHs
	zWhFog+VXsoRiLYZevR5vwzJLWRC2aKQb0tx9aLHzX0IpzTSZ51haZoDOaHuWKFCUkRLiX
	qykyjJay5Ti5tptLQBFuCXNnsWo5luI=
Date: Fri, 19 Jun 2026 08:21:51 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 4/4] mm/percpu: Avoid IO/FS reclaim in backing
 allocations
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20260618130414.96383-1-kaitao.cheng@linux.dev>
 <20260618130414.96383-5-kaitao.cheng@linux.dev> <ajQy9EtOgJQntHOd@tiehlicka>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <ajQy9EtOgJQntHOd@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AA43C20003
X-Rspam-User: 
X-Stat-Signature: dzxxr5nb94p7u4bqzkbocohs34hrpt97
X-HE-Tag: 1781828521-266819
X-HE-Meta: U2FsdGVkX18cKlI2Xa0kT1bzRB5ZICGn1a6k4vkvM7adiAY2gnLhDgfb76Djk34W/rKPBwncGmEztaBMpYBh4f3fb+Dd2Dd8rHUkfujLB+un9n8ueLyj+SBaygQZXKlHqTdDEvDihl/+9VS+9EtLKVfflhdAqCk/1pW9c382DeuhGlIEUt872trjQi7d7g8dpEJtwLTwLxYUfeIv01wY+1TeUPAE7kaG+y8I8TSXmqIHDg09QYsU9cZZmTLBBJXEyOncxBxQu6nbAOOgfEkNJpIpOFGEHVHP0H6CuqyPJRR6ROpOvfMdjD61JAREFLd+VslNe/Tg0XMFScjiD1nj53iU3khb1VRtxtg7/40XksY28N/lx6eX0m/6xPDTc36l10YXVrlkxVZvUHtYTW9dyY25qLgiPID8LlB7YMYIyYdOutwiIvWvf0YbJ5G8VUwIdzQuHR1DBuTgCtIZrWeu40x1d+WLcZ/I7teY9M2DiHxxaFz2PaaTdSf2Ae7Cd9ZLNws6AVy14MIu3Su1Np/B5CUCLj8uUd+r8MCywFIAZiv3yQirpb1ARC6vSzGen8HIM6jGupl7RLl+wll0o8zpu+XTjDeiX3/TPM+O/B3eM4LWHDl0+ZQy0RNOOJHJoCV4MA3RMgH7pFFziqxJ45+ayi1PMZRK4zGOzPp5VVGufZCvF37wGP+FivV+xaKeSOYvhXV20DWzOXs8IpjnWDNv5ws81+Q9lBqoBSxahcAL4S1yeJVm51sJ7AhQRdNMOoG8ZATJMsfb+7TzpsStBfNBpBG7tdqgSTUWd8Hbep4Q1tzN4SGlgCUIwnuXA9itHhhVyFA9O30f+owhTG1Mw6p1eirkr++S3NqzNsiBPHy16LIrz+87c5+8q1rC95XpZ93lhfJ22deIhkqLJ6gN+rFUYadnG8cr/5TlzQ7OHWBRzZPoq5Rs4AUBMQG3HMRLn1YoOTOlCLwFveVPdjNjwq0
 bfXq4kym
 B2edd96/F4EpXEQ+sUstYXIGCWQTpBjbzHh6EsGKA4Dna1OS4guTG6rA9nR25PXzgRSRftCuf7lx7wVHDBSe3nJocZUINpfHQLoSVctOtaqCYWwA6A+3WuLc9qzBsW6+ZoCbNTiJoy4Bws2iKNwxWOnSn+cg28q8sqoKloNb5TSz4nDMz0eEjxGyl2VchnmnGCtekZujDzSN5KOs55u/ygUSZ+T3xgBJ6X3XsrRIllSrT2ivxTdgHaaO95Twn1DJdSec6xaimsD0q6rwIYWNa4OB8jpZFicLd2/twwewABSXwW4U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 2026/6/19 02:03, Michal Hocko 写道:
> On Thu 18-06-26 21:04:14, Kaitao Cheng wrote:
>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>>
>> Commit 9a5b183941b5 ("mm, percpu: do not consider sleepable
>> allocations atomic") allows sleepable GFP_NOIO and GFP_NOFS percpu
>> allocations to take pcpu_alloc_mutex.  This avoids premature allocation
>> failures, but it also makes the mutex visible to callers from constrained
>> IO/FS contexts.
>>
>> Thread A calls pcpu_alloc_noprof() with GFP_KERNEL and takes
>> pcpu_alloc_mutex. Since the internal allocation is not constrained by
>> NOFS, it may enter FS reclaim while still holding pcpu_alloc_mutex,
>> creating a dependency like: pcpu_alloc_mutex -> fs_reclaim -> FS lock
>>
>> At the same time, Thread B may already hold an FS lock and then call
>> pcpu_alloc_noprof() with GFP_NOFS. It will try to acquire
>> pcpu_alloc_mutex and block, creating the reverse dependency:
>> FS lock -> pcpu_alloc_mutex
>>
>> This can still form a potential deadlock cycle.
>>
>> Avoid the dependency by restricting percpu backing allocations to GFP_NOIO.
>> The public allocation still uses the caller's GFP context to decide whether
>> it may block, but the internal memory allocations performed while
>> pcpu_alloc_mutex is held cannot recurse into IO or FS reclaim.
>>
>> Fixes: 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations atomic")
>> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> This seems like the only viable short term fix but long term it would be
> really better to make allocations outside of the lock.
> Acked-by: Michal Hocko <mhocko@suse.com>
> 
> Minor nit
>> @@ -1749,8 +1748,17 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
>>  	size_t bits, bit_align;
>>  
>>  	gfp = current_gfp_context(gfp);
>> -	/* whitelisted flags that can be passed to the backing allocators */
>> -	pcpu_gfp = gfp & (GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
>> +	/*
>> +	 * Allowlisted flags that can be passed to the backing allocators.
>> +	 * Backing allocations under pcpu_alloc_mutex must not recurse into
>> +	 * IO/FS reclaim.  Otherwise a GFP_KERNEL caller holding the mutex can
>> +	 * block on reclaim while a GFP_NOIO/NOFS caller holding an IO/FS lock
>> +	 * waits for the same mutex.
>> +	 *
>> +	 * Do not pass __GFP_NOFAIL.  A small percpu allocation may need many
>> +	 * backing pages, making nofail reclaim too costly under NOIO/NOFS.
>> +	 */
>> +	pcpu_gfp = gfp & (GFP_NOIO | __GFP_NORETRY | __GFP_NOWARN);
> 
> GFP_NOIO, NOFS are negative masks in the sense that that are lacking
> flags so the overal intention would be more readable IMHO in the
> following form
> 	pcpu_gfp = gfp & (GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN)
> 	pcpu_gfp &= ~(__GFP_IO | __GFP_FS)

This looks a bit redundant. The newly added comment already makes the
intent clear, and the extra code seems to serve only as another hint to
readers, which is essentially the same role as the comment.

GFP_NOIO already excludes __GFP_IO and __GFP_FS, so its semantics are
clear enough. It should not be misleading, and it is also more concise.

>>  	is_atomic = !gfpflags_allow_blocking(gfp);
>>  	do_warn = !(gfp & __GFP_NOWARN);
>>  
>> -- 
>> 2.50.1 (Apple Git-155)
> 

-- 
Thanks
Kaitao Cheng


