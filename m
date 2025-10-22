Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFA95CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 07:41:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35DD78E0011; Wed, 22 Oct 2025 03:41:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30E288E0002; Wed, 22 Oct 2025 03:41:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D5AC8E0011; Wed, 22 Oct 2025 03:41:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0656D8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:41:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B75D95B57B
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:41:55 +0000 (UTC)
X-FDA: 84024956190.19.881E158
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 64466C0009
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:41:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=N4qfcI6r;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=X0RTACQM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K83XgDro;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+6wW0A1s;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761118913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IyMepcd4W5MPP+4gvZWdITUoUK6eWB4LJfO2TGYih3A=;
	b=moA+8gcpv//2lA9tweJiCPNm7rJB/iFnNXbhkUz1ll3Q2pw8oU8DKP4jxUHNuq894cXfOF
	28PG8+KQWnArB3lM1qmrGt3vy8JJZBirNUuymzYC9lRzLoWx4kKXOfpFa4MVAF1HqLNdOl
	YPQTHkX8xuDV0DJGgdg5CHCeGrsi7ZA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=N4qfcI6r;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=X0RTACQM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K83XgDro;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+6wW0A1s;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761118913; a=rsa-sha256;
	cv=none;
	b=SDMjM2npMC1HxX9e6GXbAdfCUaCCq7Qw7F3RdR7yXvd6kjDj452iJxLPEeuS7sWjt29QKr
	0v4kAMZeirDaZ9UE3c3RLIQczKiZkiXE0BO7muieEr6ibYqdlAabwzjn5cxaseUklHFDAf
	/JoOdgEaW3K+6FVI9uFwLkZnCRuyoq4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C0B4E1F391;
	Wed, 22 Oct 2025 07:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761118907; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IyMepcd4W5MPP+4gvZWdITUoUK6eWB4LJfO2TGYih3A=;
	b=N4qfcI6rt57CUtIaQc6nrgU0p7OzqAlREmluxXMM6nL9oA5XSUP1hDS6h3vHCBxu64jGG1
	xxdh+9l3wG7RmbnvZEvo6PtaXi6oYld9nBejctIGjxVtwxH9n2djsC8FVpQvUL5ztFc9qA
	hJ58uKabubYS7C88yJ70cnulg0k9gGk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761118907;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IyMepcd4W5MPP+4gvZWdITUoUK6eWB4LJfO2TGYih3A=;
	b=X0RTACQMH1wVYG6SLYNXbD7nYU3lhCSDd49BoZUCtxAtlmE0j/1QmVygCjUgcLKVTLlboF
	cFRYkEbJdMxoN5Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761118903; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IyMepcd4W5MPP+4gvZWdITUoUK6eWB4LJfO2TGYih3A=;
	b=K83XgDro23x0GxnfL0xB7ImodBzV6YWr1ypYTLcC2zcS8qX4RGBBTRRURTbHVj5uEbxWKf
	ver6b5ICUFcrPYqiwAro8sXhs5Iws1yFOz2ypjJ8xOkx9VrMH0kYarEFS/gaYtd1IwOuPF
	HqwYRzirDVsrly4kcckvp6M7mcFJZmA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761118903;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IyMepcd4W5MPP+4gvZWdITUoUK6eWB4LJfO2TGYih3A=;
	b=+6wW0A1s5sffs4tcTetxyvMthnyqjI2fmi17/znVHyopXAqHbtfU+qXe4M5ExETTig3n5l
	NocvmL0zZLD2paAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 99D401339F;
	Wed, 22 Oct 2025 07:41:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cMrEJLeK+Gj0HwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 22 Oct 2025 07:41:43 +0000
Message-ID: <1ed60558-cd6d-43c4-b8e2-e9492e5aac2e@suse.cz>
Date: Wed, 22 Oct 2025 09:41:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: Consider PCP pages as part of
To: jinji zhong <jinji.z.zhong@gmail.com>, joshua.hahnjy@gmail.com
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 axelrasmussen@google.com, david@redhat.com, feng.han@honor.com,
 hannes@cmpxchg.org, jackmanb@google.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, liulu.liu@honor.com, lorenzo.stoakes@oracle.com,
 mhocko@suse.com, rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com,
 weixugc@google.com, yuanchu@google.com, zhengqi.arch@bytedance.com,
 zhongjinji@honor.com, ziy@nvidia.com
References: <20251021145427.3580609-1-joshua.hahnjy@gmail.com>
 <20251021180435.11789-1-jinji.z.zhong@gmail.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251021180435.11789-1-jinji.z.zhong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: b64fyaeawez8u54nqpta1zemdbp3iaso
X-Rspamd-Queue-Id: 64466C0009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761118913-981223
X-HE-Meta: U2FsdGVkX1/jot3x5XUQQh/lohUc2ZFUlmmGjfhqq1PuolY20FAaVRmZebudLYfpM+J6kLO8SZG5ye+TyzzcyDW0qSTvOqaxdc3emfU0Z4VwkAM73nB/Wdd9iOSLD2eWMLiaJZXJZ5jYOg7+Vt+m41yxM9o0xz/vzvp1VASwZmF3MY+j9YUF3vrmt62FJmJ/xBhAg+MxbaN2Cv925/WNfqooAOGrQeT63hZFN0fH2ItU7Dl7qYA9QpV5csdNi0fMStzRaiakp/dFZJqe6RKB2p0A3gKdeMo3oNos7dGoz58NCn4y156qF/cjZILYWKMh0va1HQq7Arzjq4JB5/KsK+6rqymiVdGkfpaiEf/iLsXdoRg/ybL6KrJ8CclmhRtNfTPWfT1VSnVxnwxoyRWb9TdP+/JjG9HLVyvc79sZJQD7372y/HjuTOXo9L3ztA0U7tH8fus1WooPygLxgGQc3HgYJtR1C6dz2fXSipqXnbMWSeyjYAt9XIS7SXn0yx2jVSps3o3INUHSxD9O4/0DAdAsKo6XiQxrlUH7NOBBg19T4/Mvvkq1zwIzcfyn9K3JLyFv4yZYEaYDwPlS26sWYDptrtBIJlCBabNwKZEX22bkq0Y5SdUJvHptSffXJrhKan4oZH1oFiYq6TwuOTHlUMHmrVG+r1HB/ml4AF6FhZx34PVQA1j2SDYompFoksf9HPg4RW+AqqJ9nIHibMOSckVO4VwxjwxZ3hP6S8m4VTjfw87fXibTuBHEe8osfNjkXdutnhWyLyKdjVVEnGM4beiYIptLGGflpS7ep1Uwdk4VWieqXepNlEjIIVxFzt+DD88MiDhJAEUP2sL13UFQeHNdgyx8MOVIRN1cjZTC9vziiH8oqjQUt8bMsmVGfvamjnebg2jbEPOydb8BW8U+P/lze0BYoU8uZDXn50AO1Akf2rwAw8L6AGLzNssR4/dVZV7UP6XRIgY2wUBcDI9
 JDDM2+l9
 SAqnIgpt4HI67IDGM/N2T17r1C+P11y/aISE4MpXt9ljRKc0j/WAM9gdG/Dy5Y+ec+C1YQj9BMTdQoNvT2jRgL2T3iQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/21/25 20:04, jinji zhong wrote:
>> Zhongjinji, thank you for your patch!

Hi,

>>> When free_pages becomes critically low, the kernel prevents other tasks
>>> from entering the slow path to ensure that reclaiming tasks can
>>> successfully allocate memory.
>>> 
>>> This blocking is important to avoid memory contention with reclaiming
>>> tasks. However, in some cases it is unnecessary because the PCP list may
>>> already contain sufficient pages, as freed pages are first placed there
>>> and are not immediately visible to the buddy system.
>>
>>Based on my limiting understanding of pcp free pages, I had a concern here
>>on whether this would really provide the desired effect. That is, the pages
>>in the pcp are not available to the buddy allocator unless we drain the pcp
>>lists (and this operation is not free), I was unsure if there was a clear
>>benefit to allowing the system to go unblocked.
> 
> The purpose of this patch is to account for the memory in the pcp list
> within memalloc_reserve, which would allow more tasks to enter the slow
> path. For critical tasks, entering the slow path represents a better
> alternative than being throttled until kswapd wakes up.

Were you able to measure the benefits of the patch? What are the "critical
tasks"? Usually such task use mlockall() to avoid allocating memory during
operation. Maybe we should instead extempt some task priority classes from
being throttled?

>>If we are already at the point where we need the pcp pages to have enough
>>free pages to go over the watermark, perhaps it makes sense to just block
>>tasks for now, and enter direct reclaim? Allowing more allocations might
>>lead the system to be in a worse state than before, and will have to
>>go through direct reclaim anyways.
>>
>>Please let me know if this makes sense!
>> 
>>> By accounting PCP pages as part of pfmemalloc_reserve, we can reduce
>>> unnecessary blocking and improve system responsiveness under low-memory
>>> conditions.
>>> 
>>> Signed-off-by: zhongjinji <zhongjinji@honor.com>
>>
>>[...snip...]
>>
>>> +int zone_pcp_pages_count(struct zone *zone)
>>> +{
>>> +	struct per_cpu_pages *pcp;
>>> +	int total_pcp_pages = 0;
>>> +	int cpu;
>>> +
>>> +	for_each_online_cpu(cpu) {
>>> +		pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
>>> +		total_pcp_pages += pcp->count;
>>
>>Could this be racy? What is stopping the pcp count from decreasing while we
>>are iterating over each online cpu, over each managed zone? Under the
>>memory pressure conditions that this patch is aiming to fix, I think that
>>there is a good chance the numer we get here will be very outdated by the time
>>we try to take action based on it, and we may require the system to be
>>further stalled since we don't take action to reclaim memory.
> 
> Thank you, Joshua. Indeed, the pcp->count might be outdated by the time. 
> And kswapd will fail to allocate memory if the pages in the pcp lists are
> on other CPUs. While drain_all_pages() may be triggered by direct reclaim
> on other CPUs, some hard-to-predict scenarios might still exist.
> 
> Perhaps performing drain_all_pages() before actually calling
> throttle_direct_reclaim() would be better.

Draining makes more sense indeed. But it should be backed by data showing
improvement. As you say, draining is probably already happening via direct
reclaim.

> Like the following code.
> 
> @@ -6535,6 +6535,7 @@ static bool allow_direct_reclaim(pg_data_t *pgdat)
>  static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
>  					nodemask_t *nodemask)
>  {
> +	bool drained = false;
>  	struct zoneref *z;
>  	struct zone *zone;
>  	pg_data_t *pgdat = NULL;
> @@ -6570,6 +6571,7 @@ static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
>  	 * for remote pfmemalloc reserves and processes on different nodes
>  	 * should make reasonable progress.
>  	 */
> +retry:
>  	for_each_zone_zonelist_nodemask(zone, z, zonelist,
>  					gfp_zone(gfp_mask), nodemask) {
>  		if (zone_idx(zone) > ZONE_NORMAL)
> @@ -6586,6 +6588,12 @@ static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
>  	if (!pgdat)
>  		goto out;
>  
> +	if (!drained) {
> +		drained = true;
> +		drain_all_pages(NULL);
> +		goto retry;
> +	}
> +
>  	/* Account for the throttling */
>  	count_vm_event(PGSCAN_DIRECT_THROTTLE);
> 
>>[...snip...]
>>
>>Please feel free to let me know if I am missing something obvious. Again,
>>I am not very familiar with the pcp code, so there is a good chance that
>>you are seeing something that I am not : -)
>>
>>Thank you for the patch, I hope you have a great day!
>>Joshua
>>


