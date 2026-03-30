Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57CEAFC97F3
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 15:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B66066B0096; Mon, 30 Mar 2026 11:13:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3D5E6B0098; Mon, 30 Mar 2026 11:13:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7A4B6B0099; Mon, 30 Mar 2026 11:13:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8AB2C6B0096
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:13:35 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 444C71B8A91
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:13:35 +0000 (UTC)
X-FDA: 84603073590.25.47372BE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id A05281C0012
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:13:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JuqZdkyH;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774883613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZuI4WJhWffrbTsc6nDXsvC2yS7NlRzEAvjB7cBJ4RDQ=;
	b=KzzhO4KZarAhCjKC+wP1HQMOlmB45AxaB8f9VWZc9mjVIXmchF7j/Jtd3PIaC7n8CJgY1J
	G4ZafyVBqxBRqS5JtYqneDFEFgt5s0b/rKBdhP+lDSuj02JsLg/7ICq5zPXBNghe8+FA5h
	N8Ew4o6V6jUEfxmx1gMZVPdx5J/Q0+0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774883613; a=rsa-sha256;
	cv=none;
	b=m5ydRIQ8OML8DjXYli8ftmOi5DkL0mFOgdiddbPLOuYDlBFVAfB3C5T/bF0vdgU5ZkqOOK
	EcsWG3n/0fr0Fxk0gVwaRJfpjWkIxMyJQsXqWdIFt6AqQeHm1GYCYEGeVm+fTI8KWIykk2
	Af/GADftot3H+/0yhOwqrjHV8skEPRY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JuqZdkyH;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AC4FB433EB;
	Mon, 30 Mar 2026 15:13:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0C8C4CEF7;
	Mon, 30 Mar 2026 15:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774883612;
	bh=mqYD+Aqa8t3eBRM1m/uNj7grHUFQp6kl4HtvJswkcMc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JuqZdkyHSo4IKRBvZHfbdfpQbQYWP2lxpq5AtmkwsyO9RCwpvVVx/HBO/bRltl7qW
	 CT+dTrmR+0jUNRA/jXMxD+uzHSt+Uy5CC5ShUlkqTVhzCl/GQOCNmy/5E02ETuPCrX
	 qnqa+an/8yoEJv7s8XrjIV+AHKmhPR2bVV0L5mzrjIUvx8hnNbV8o6NRHPLSKEqs+u
	 cXWFPSO1iDHWbk6cKdsFExaH2ldI92IQAV3hjTvKQifxjCLLAucPevOSKHeKsXCkZx
	 +rUXXxVNzSnm72KrfzvsoFBmvt6MF9pXjF+zaeJeuub76PJzwrDRsUaQiq73NdjMU/
	 ZoaAfI6Q01w0Q==
Message-ID: <fc4d2479-08f1-441e-a1ba-74fa6b50262d@kernel.org>
Date: Mon, 30 Mar 2026 17:13:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [patch] mm, page_alloc: reintroduce page allocation stall warning
Content-Language: en-US
To: Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Petr Mladek <pmladek@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <30945cc3-9c4d-94bb-e7e7-dde71483800c@google.com>
 <231154f8-a3c3-229a-31a7-f91ab8ec1773@google.com>
 <acqAnhmm6q2nKkPh@tiehlicka>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <acqAnhmm6q2nKkPh@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: pp3cp3usj3ess9ds9zx6wkpn5rhp9rr1
X-Rspamd-Queue-Id: A05281C0012
X-Rspam-User: 
X-HE-Tag: 1774883613-105290
X-HE-Meta: U2FsdGVkX1/49ho9TW/mw7z3eltr8lHidWjL0nY01pVULD5rF//JBODOciOIVcwGJ1K79PodxyzwedwXIQpN7ZauxFbVGGCsDzVFMU8gWJ+RogolUI5hJtn8X45/GTRWeCYkqzrru+zDufF14+aGiNxHVw37M6k43J69fU2WfgagwCmlhOTcsK2q8CYBNne0ZAFLmXrvPj4JtuqAxySkwVWN5MggaEeoEFYaU5EmmZUCit1Whn1VkchVOUUxzeACYTaGvF9Jkwm0aD0yLeuyPcTdVqd5vGpuAiet1Z4uZwXKQ9toE8mZkpbRcPHkZrsyK/KVq79U5qiSZx2TgB12PeGjryIq7nOGGrRtCtXD9KNAq1W6T8t2zGlg9fWhKP1JfE0HVgSSH6e6iilaDW9PRPF6b1U9b7Q/6hJO2ZOFHItL78+u3nyWDdQ2COnPkjGryLSli2GvuW6j5njhP0FNP38a91IqGLqQVU0i6Yxxakc7GM9muK9IFmBzqpQSRNAabuE6+AP51NYRgavxURsmuFefn/D56Vu+xeiSyc6hGGVyr6z1nFjB9bJaIue58b3WwYl9rcCjHbt7birR+Bx35t/LRKG34zmlK7YLqv4MNQBDP9lBcdDdylk5HKujSuOSlprlAVZKfEaWND/bBR/MLQ8NtkoxUty/hgxqd0btF8YitVfXPj1PhqAlHGNowx0iFP8Q+Nc9WDK8V5kuU8dsNCUoBpLwThOMzMYAiY55p4HXvKUadNvWGZyTCHoGTfP4VB0vp3s3Qzt00OAVk8AM9m4CdsSu+6e52UTxHPLL5vemuf7cEN75LqslfEFMFJy432Ice14hGq91cQkeTZzCXhKPtmwZixLSGgUbJvri6trWMoOBLqMAemTQJv7AqQac7rbZ5bgeEOkkHb8GEF06hi/5ZAp68+2iql9gzt4SGRGJAfVsyA14yEWX1leAUkffKzFlApyceAZZNs8a6tt
 4A3/AxiY
 2Kv36
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/30/26 15:54, Michal Hocko wrote:
> On Sun 29-03-26 18:08:52, David Rientjes wrote:
>> Previously, we had warnings when a single page allocation took longer
>> than reasonably expected.  This was introduced in commit 63f53dea0c98
>> ("mm: warn about allocations which stall for too long").
>> 
>> The warning was subsequently reverted in commit 400e22499dd9 ("mm: don't
>> warn about allocations which stall for too long") but for reasons
>> unrelated to the warning itself.
> 
> I think it makes sense to summarize reasons for the revert. I would
> propose to change the above to somehting like
> "
> The warning was subsequently reverted in commit 400e22499dd9 ("mm: don't
> warn about allocations which stall for too long") because it was
> possible to generate memory pressure that would effectivelly stall
> further progress through printk execution.
> "
>  
>> @@ -4841,6 +4884,9 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>>  	if (current->flags & PF_MEMALLOC)
>>  		goto nopage;
>>  
>> +	/* If allocation has taken excessively long, warn about it */
>> +	check_alloc_stall_warn(gfp_mask, ac->nodemask, order, alloc_start_time);
>> +
>>  	/* Try direct reclaim and then allocating */
>>  	if (!compact_first) {
>>  		page = __alloc_pages_direct_reclaim(gfp_mask, order, alloc_flags,
> 
> Is there any specific reason for this placement? Compaction can take
> quite some time as well.

It seems fine to me - as longs as the slowpath is retrying for 10 seconds
and still can't obtain a page, there's a warning.

We don't catch cases when either the get_page_from_freelist() attempt,
direct compaction or direct reclaim attempt is what gets us over 10 seconds,
and at the same time it results in success. If that's a concern, we should
add another check_alloc_stall_warn() call under got_pg label (as the RFC
had) - I'm not sure it's all achievable with a single place with the call.



