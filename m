Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EB3FCAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 11:21:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D878B8E0008; Wed,  1 Oct 2025 07:21:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5E4C8E0002; Wed,  1 Oct 2025 07:21:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C74AF8E0008; Wed,  1 Oct 2025 07:21:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B1FB88E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 07:21:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3DDA713BFC6
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 11:21:07 +0000 (UTC)
X-FDA: 83949303774.07.D1CFD5F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 052A340004
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 11:21:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=27x6QSsL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gIzBnHXK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=27x6QSsL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gIzBnHXK;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759317665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PF0wBi19hCMZbudds09SMu1E6+Thus+lwXfrPMqv/OQ=;
	b=m+AJCSR6vUxVw49VvDu+gJN1bhk7acsyI2Z2ML43r/YjMzCUFe2Uby7HeYkAOM08IrjNf6
	L52y0mX5JmLGU8rFNFe1V5ksO/t/IlbM/zyo+Mb+fUEn4gD5o1vpQ43Xet8YIU6bJyKJFA
	u4wTtIgR9gXs9lkBeKam+iVfHAwkmJ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759317665; a=rsa-sha256;
	cv=none;
	b=Dzek/5C+DY/s9YWLslN7M01usqVV2jgzCTLp9c2Y/ssmH2/perKWqYvAHYsfIK7EwxdnOL
	E2affiXyyoSXPdWSjawPM7lYrG0kNzaHYjDhTWHfFbCLR01dOQnqtXnb2dPwpmaKWQVouj
	MUAZHyFwDa1/wD9XGGYC2D7pphC1oWA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=27x6QSsL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gIzBnHXK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=27x6QSsL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gIzBnHXK;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 30F041FB6C;
	Wed,  1 Oct 2025 11:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759317663; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PF0wBi19hCMZbudds09SMu1E6+Thus+lwXfrPMqv/OQ=;
	b=27x6QSsLnXfDgXY7pdEYSiZXKKor/atJajs4IHb9CiYvXbS8LZJh6jeOaQbyhHf70Z9x/U
	zjgMZjaizsIsEe9ybGSqit0kpkCYa+AR0LWJVR3rD51nn+pRT9YXH7CFV6QuoYDicAYhl8
	fvUeahFf8QDGGEgBVG3JSRYAvzxrg58=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759317663;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PF0wBi19hCMZbudds09SMu1E6+Thus+lwXfrPMqv/OQ=;
	b=gIzBnHXKDLn2i76VXzzgf1C9Z5lCSTfOVvUxwyauayG+U5gMiznPQijHtafE1CiYcSX5tG
	WsnNmvjEr6y6TpBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759317663; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PF0wBi19hCMZbudds09SMu1E6+Thus+lwXfrPMqv/OQ=;
	b=27x6QSsLnXfDgXY7pdEYSiZXKKor/atJajs4IHb9CiYvXbS8LZJh6jeOaQbyhHf70Z9x/U
	zjgMZjaizsIsEe9ybGSqit0kpkCYa+AR0LWJVR3rD51nn+pRT9YXH7CFV6QuoYDicAYhl8
	fvUeahFf8QDGGEgBVG3JSRYAvzxrg58=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759317663;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PF0wBi19hCMZbudds09SMu1E6+Thus+lwXfrPMqv/OQ=;
	b=gIzBnHXKDLn2i76VXzzgf1C9Z5lCSTfOVvUxwyauayG+U5gMiznPQijHtafE1CiYcSX5tG
	WsnNmvjEr6y6TpBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 218DF13A3F;
	Wed,  1 Oct 2025 11:21:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CarzB58O3WjSZwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 01 Oct 2025 11:21:03 +0000
Message-ID: <138f3057-8aab-4bfb-a541-dbf1a51a32bb@suse.cz>
Date: Wed, 1 Oct 2025 13:23:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] mm/page_alloc: Perform appropriate batching in
 drain_pages_zone
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>,
 Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Chris Mason <clm@fb.com>,
 Kiryl Shutsemau <kirill@shutemov.name>, Brendan Jackman
 <jackmanb@google.com>, Michal Hocko <mhocko@suse.com>,
 Suren Baghdasaryan <surenb@google.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com,
 Mel Gorman <mgorman@techsingularity.net>
References: <20250925184446.200563-1-joshua.hahnjy@gmail.com>
 <567be36f-d4ef-e5bc-e11c-3718272d3dfe@gentwo.org>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <567be36f-d4ef-e5bc-e11c-3718272d3dfe@gentwo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 052A340004
X-Stat-Signature: esq1ggyq91cjdoqznkhdfutiznionsut
X-Rspam-User: 
X-HE-Tag: 1759317664-343383
X-HE-Meta: U2FsdGVkX192R3sI8DY15aQa9aXbWt/qNnwOKpiQQZOTsrOM2sF5tI4CJsJRPkWpdJY/vMZLBtq68lI2UELqxO9XMQo02hldbOZlhxa9c0xESFJ6pAD6dmvNOrkBXA/+Ytki3P4ls3Hzc/u+euolXcPdHoABHooSFEljz/EMp1x6cW/rIZG26vbe3DOBz8SBnjjLAGN/WR8afxfFEtdIHTPZHMdeBb8RfHerAvI2kZgjQoIcLOg07szr+3YUfnayI/iOF2H8Kx9hcjJyiMmD2VPQLv78LxmZTySYOfA7K0HnJPNqnzLuMtJtyxDVA+WPiUBULt7SPVYbnBiyLiPR9cwUe0JmUbFzDEha1RukWrSb6slYfgATyJgz1yeqsSaCmAsaHreknBC2oEhtnKnSmDCOV1jNDWdbKmN+gyZ6tOPxeI4Ey59RRIOTBoJvc3elSx9OCa3svuFXJUlLXQGN/ZqbswBptAOZmbfwgiOqM6nut0VKYyK4BREk58BPqSPvvD47bueCANy1phoPb9w7YOmTFHPx1PB0p+6fdIEoBeYBmYeoOYKXMShvaQ0yGITLrh8V5Tj+CN2FR3Hdi5lXKafbUNH0p5jTP1LDibcmsfrbSdklS/LsP0GWBFH+JVU71qTLg9XSjNkiCQ6x0Qqw2j2MDXgBDIwN0sGSvDSCgKtXDsZmpEOv4cG+xntLU8eDetvq5d0Ln5le7vQNIvebdLgZbv7C3YYwgSQdrHGAJkuzSkUXahNrAZ95ZcqnlQwyFASMMpq249cQMaDQtKd3JZ5VezNe3hKw+Wxzl2tQU9ygMKPg/2HP3CnE8kddX9vsmzymCeTil7nrOuhyBDtYoBMyQHfxqY0pbZ05vO5EJB3zp51XL+3mTlJ5roL9Te2qGrG4x2lSEVJ8Uq3YGAmFtQcaf/xsUBTxw36Ithxe1lWlC+HTexwTuEKD4rpXQ+L8qC7CPeybYLSlbfuY+P/
 zIhkJwK4
 GiJL1uQ3MrVvvfNh0M8Ybm82Dq9KYMCDUVciv1ufGh2aPng238MfO6X2EiUAhkdGmVlsn94uvZO7807lNYSdqaAeSbwghxaM5KAoElXgarG8nsnnJ7Ho/T5vgMhOQcPF8reIq1wFlaMeyUEY7v9QMFZa1vIluxrkjOrqIe5KFih1+EuD4Czu04YfZc1ExMgOU4EE35NpT9OGfpT6514U+KE6l9YCKwLzxJpfycwZPBP30ZYHP+9moY76ciXvCF4Mqw8ccUlm+kLI69lsxNzkBLrQ1J7jBdbNya7bwzkktw7F76oPpG8Fovqu7dyShBBRXJhdcv9cnkbST3kwgBTYVgCipRDC2XpT4uSp89I1xkD2JhMj3frRwlH8o6Ub2CcWOvywVARTEiRj8dQun1SdUAxqyrw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/26/25 6:21 PM, Christoph Lameter (Ampere) wrote:
> On Thu, 25 Sep 2025, Joshua Hahn wrote:
> 
>>> So we need an explanation as to why there is such high contention on the
>>> lock first before changing the logic here.
>>>
>>> The current logic seems to be designed to prevent the lock contention you
>>> are seeing.
>>
>> This is true, but my concern was mostly with the value that is being used
>> for the batching (2048 seems too high). But as I explain below, it seems
>> like the min(2048, count) operation is a no-op anyways, since it is never
>> called with count > 1000 (at least from the benchmarks that I was running,
>> on my machine).
> 
> 
> The problem is that you likely increase zone lock contention with a
> reduced batch size.
> 
> Actually that there is a lock in the pcp structure is weird and causes
> cacheline bouncing on such hot paths. Access should be only from the cpu

The hot paths only access the lock local to them so should not cause
bouncing.

> that owns this structure. Remote cleaning (if needed) can be triggered via
> IPIs.

It used to be that way but Mel changed it to the current implementation
few years ago. IIRC one motivation was to avoid disabling irqs (that
provide exclusion with IPI handlers), hence the spin_trylock() approach
locally and spin_lock() for remote flushing.

Today we could use local_trylock() instead of spin_trylock()
theoretically. The benefit is being inline, unlike spin_trylock() (on
x86). But an IPI handler (that must succeed and can't give up if the
lock is already taken by the operation it interrupted) wouldn't work
with that - it can't give up nor "spin". So the remote flushes would
need to use queue/flush work instead and then the preempt disable +
local_trylock() would be enough (work handler can't interrupt a preempt
disabled section). I don't know if that would make the remote flushes
too expensive though or whether they only happen in such slowpaths to be
acceptable.

> This is the way it used to be and the way it was tested for high core
> counts years ago.
> 
> You seem to run 176 cores here so its similar to what we tested way back
> when. If all cores are accessing the pcp structure then you have
> significant cacheline bouncing. Removing the lock and going back to the
> IPI solution would likely remove the problem.

I doubt the problem here is about cacheline bouncing of pcp. AFAIK it's
free_frozen_page_commit() will be called under preempt_disable()
(pcpu_spin_trylock does that) and do a potentially long
free_pcppages_bulk() operation under spin_lock_irqsave(&zone->lock). So
multiple cpus with similarly long free_pcppages_bulk() will spin on the
zone lock with irqs disabled.
Breaking down the time zone lock is held to smaller batches will help
that and reduce the irqs disabled time. But there might be still long
preemption disabled times for the pcp, and that's IIRC enough to cause
rcu_sched stalls? So patch 4/4 also relinquishes the pcp lock itself
(i.e. enables preemption), which we already saw from the lkp report
isn't trivial to do. But none of this is about pcp cacheline bouncing,
AFAICS.

> The cachelines of the allocator per cpu structures are usually very hot
> and should only be touched in rare circumstances from other cpus.

It should be rare enough to not be an issue.

> Having a loop over all processors accessing all the hot percpus structurs
> is likely causing significant performance issues and therefore the issues
> that you are seeing here.
> 
> 
> 


