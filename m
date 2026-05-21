Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AC2FCD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 17:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEB4C6B00A3; Thu, 21 May 2026 13:40:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC3166B00A5; Thu, 21 May 2026 13:40:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E00F46B00A6; Thu, 21 May 2026 13:40:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE3A16B00A3
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:40:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 976221C1B73
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:40:18 +0000 (UTC)
X-FDA: 84792140916.13.CAD1FC1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8B270100011
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:40:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q3GU+rDX;
	spf=pass (imf14.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779385216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RJEyad8/zSUSfFThXl+omadAtBvnvl3F5572ZCdBP0Y=;
	b=jDfWkHiyXIhjFCIWoFEuNgIEPebBVOeQnFXwoPyUvs6WGaAKHNNQ4g9381AjUTCCbPVB5K
	l/EDhP4lCVyX060G3+T/whA0EG32yc4CBX2zJTC6OvPSH2hUqgFPsCd1UKYnFNOIHKTWVQ
	L5g4iHmMB0RnBide6nFsjSSNVCBpWVQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q3GU+rDX;
	spf=pass (imf14.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779385216; a=rsa-sha256;
	cv=none;
	b=bCCoWqdpdux7W/vaHhuIcqsi+R2yqLMqDyfS84/EjsW4wVsvY2FvdRmbdBF9lXysKtQ9nQ
	N00SUgNaOXakmXWCp6nUaWv1Vp+c3sIDICnRNhTFL0TeDwG3V8Vty5y/gcB7D5FSOM8zvW
	zohwq44b1eD6TZltFiwMpQEmiDbpXoQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779385216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RJEyad8/zSUSfFThXl+omadAtBvnvl3F5572ZCdBP0Y=;
	b=Q3GU+rDXn2ofGh7+OLNbyCxaMmxEOzZUW0rxkX6Y/ls5Nux676LcuAf0zJZ9bKgiZW5cIf
	0vcGYV02KDh0U2RfENWNcc9LwKwDQgK3TBVVUwqJZL/DN4H5EyNQy+eHADEA53iaPt/Sxs
	KilqWhw8LkJRUlwaiLKgVBBS8x6os4A=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-207-bF8ejiEDPdiWvmJNxRVV2g-1; Thu,
 21 May 2026 13:40:13 -0400
X-MC-Unique: bF8ejiEDPdiWvmJNxRVV2g-1
X-Mimecast-MFC-AGG-ID: bF8ejiEDPdiWvmJNxRVV2g_1779385211
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 29255180060D;
	Thu, 21 May 2026 17:40:09 +0000 (UTC)
Received: from [10.22.80.218] (unknown [10.22.80.218])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 43AD119560AB;
	Thu, 21 May 2026 17:40:04 +0000 (UTC)
Message-ID: <f0f4841a-816a-4442-bebb-277984ee950e@redhat.com>
Date: Thu, 21 May 2026 13:40:03 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] gfp_types: Introduce a new GFP_ATOMIC_RT gfp flag
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-rt-devel@lists.linux.dev, Matthew Wilcox <willy@infradead.org>
References: <20260520204628.933654-1-longman@redhat.com>
 <ag8zX5KJUKo70TvG@lucifer>
From: Waiman Long <longman@redhat.com>
In-Reply-To: <ag8zX5KJUKo70TvG@lucifer>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: qf2j3CdD3xgk6n3Ey7CujV7A8h7rsXTmvy3xlTQjWE4_1779385211
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8B270100011
X-Stat-Signature: h4zo8yjzuwx3x3h9un9pptwzppaj556r
X-HE-Tag: 1779385216-330035
X-HE-Meta: U2FsdGVkX1/xtjrRjaxjrDYDOjdPplxKDvRVVEs+W6lUE16Zme+Q6nRpA0FpwRtYahpRbHnVHb25lF0i7L7il65lR6gTkjvFYE8MXOvWmConKRvq7WRj0gKBwx6x1zEMmhirUer4tnoioVOuE3Rw6jVHVPtP6h7DzXqm+z5wsAqelnBX4u9KxN96QNez0IpIwF4sSnJeFnETRhc8FcNA1Z1fsWluK1U+8OH0e8G/uLcEiK7jSZwWhCyn3MIfPM5KvII4KufFFFhuCffOU66wIMPBiIFDBN/LGRCTRZvRvYMJnO4AUjgkV+muhqEoc0jaP85wyrbZmlYQIx9wUqzQ2HRErnAt0gQieZWhdyB0eTDH8BaDeDOVSOBoGYwvnfx+w9B0+MD300wXtF14ca1Uiiwe/9CJvnV4qAd2XmKwm7ifo3IDnFQkVpXFOYMANCzKOGrb9+82SyisOZfZ5kfIYbeT75nfozkFWS9UG2u2qmJ1dOszo4fQa3MxVS1O4FDurJKazNh1aOHEsIbz/A41aKiT3D7RZ1GgAQ0mjlDj92xlPp/yzPhioBLN/1x2+WuJ8x5UV/NHcLQ9THUy2zLKExjsvDkGL2MYkQeeTyWfBLTPJcze9mWknisGhAiToAOUYf6xLLhZ4dQertDjtRsJoMwle8yQH9exU+uQkCg9nsZPTYTJDMiZJZ3ZQwTWYvafKeoj6sLcZl0JKZ9bIO3YvBG6iWLzWiDkA5q/v5G/YuLs03j7f/M6PZzkHy5C49dgOKgYHyHjqiuUDQQ5PKSv5QYPshj9GAQ/pp0ChobDwF/UkIMVAb1vK2Us6vYxg5g7Sh2cK4MRUAls06onXq+kJf4g4fgq0rH9OO50Q0T4DpE+bWDEQ0PoFJFQ0F7TuA4S+5lggKGlnCp456sX1EIAoLvlwchWDwTN5elJP2hrLb6qLdI17wb7Kv9qWGAbCtPBJTI96oWB9C6KE/osofa
 dIIO+bLI
 MWuWTiyqrvJFqmYKpoV6tL/Scf0tOk3IyRdYHcA8yOaWWroG6FtkiStsYYyd8DoY44DrhDNqXxyOwUK97VCDQe66Z5gq4hpzQOiZnRTSAhU1rj2eeMvhI/K/8MUOGz4Dl5AGnz55Twll3L7cdO+DeTUmTXeiDVqan+z0Riw4dpUzS7NQHjB0WCjYIfbU7X5qMqkvexDXKPfltCK5ALe2sFgL2OfKn7dUfWsrYsuXcc1hA9tDX7J9LiELlYeJXozXjbuGS5txVcgMR3WLg6ftNbrJvbF9kD/MPKHw+fYwGxVLDieXcJd0WO3GGgdjyjzVil9HYeB6iiVItrP12I1IqQhVkRiT5RxP42c3XsJfO4/iD/9RdsSJ+44V7+Iy0V7iOoRKSWqawRHpkq6c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/21/26 12:40 PM, Lorenzo Stoakes wrote:
> +cc Matthew who has fairly strong opinions on GFP flags and such :)
>
> Also, please don't send 2 patch series with 2/2 in-reply-to 1/2, use a
> cover letter + have patches reply to that :) [yes it's one of those
> subjective things that people differ on a lot but generally how we do in
> mm]
>
> On Wed, May 20, 2026 at 04:46:27PM -0400, Waiman Long wrote:
>> The GFP_ATOMIC flag is to be used in atomic context where user cannot
>> sleep and need the allocation to succeed. However, it does not support
>> contexts where preemption or interrupt is disabled under PREEMPT_RT
>> like raw_spin_lock_irqsave() or plain preempt_disable().
>>
>> With the advance of the ALLOC_TRYLOCK allocation flag in the v7.1
>> kernel, it is possible to allocate memory under such contexts by using
>> spin_trylock to acquire the spinlock in the memory allocation path. This
>> does increase the chance that the allocation can fail due to the presence
>> of concurrent memory allocation requests. So its users must be able to
>> handle such memory allocation failure gracefully.
>>
>> The ALLOC_TRYLOCK flag will only be enabled if none of the
>> ___GFP_DIRECT_RECLAIM and ___GFP_KSWAPD_RECLAIM flags are set.
>>
>> Introduce a new GFP_ATOMIC_RT gfp flag for those PREEMPT_RT
>> atomic contexts.  This new flag will fall back to GFP_ATOMIC in
>> non-PREEMPT_RT kernel. GFP_ATOMIC can continue to be used in contexts
>> where preemption and interrupt are not disabled in PREEMPT_RT kernel
>> like spin_lock_irqsave().
> This seems like the wrong place for the solution, now we have to remember
> to use a specific GFP flag but only in one specific place in some IRQ code,
> yet RT is fine with this in any other scenario?
>
> This is really confusing.
>
> Wouldn't we better off with a way of actively detecting this context
> somehow in the page allocator?

This new GFP_ATOMIC_RT flag will make memory allocation more likely to 
fail compared with GFP_ATOMIC. That is the main reason why I think a 
separate flag with documentation about this difference will make the 
users of the new gfp flag more aware of what they should check before 
they use it.

I would certainly like to have the mm memory allocation code to handle 
it automatically if it doesn't impact the failure rate.

>
> It just instinctively feels like this is the wrong level of abstraction for
> a fix here :)
With PREEMPT_RT, GFP_ATOMIC_RT just translates to __GFP_HIGH. It can be 
set explicitly in the relevant call sites. This patch is more a 
documentation step to make clear the purpose and consequence of doing that.
>
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   include/linux/gfp_types.h | 13 +++++++++++++
>>   1 file changed, 13 insertions(+)
>>
>> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
>> index cd4972a7c97c..ac30882b6cd4 100644
>> --- a/include/linux/gfp_types.h
>> +++ b/include/linux/gfp_types.h
>> @@ -316,6 +316,13 @@ enum {
>>    * preempt_disable() - see "Memory allocation" in
>>    * Documentation/core-api/real-time/differences.rst for more info.
>>    *
>> + * %GFP_ATOMIC_RT is similar to %GFP_ATOMIC with the addition that it can also
>> + * be used in context where preemption and/or interrupt is disabled under
>> + * PREEMPT_RT, but not in NMI or hardirq contexts. The allocation is more
> I'm not sure 'GFP_ATOMIC_RT' really communicates all of this information.

I am not good at naming. If you have other good suggestion, I would like 
to hear it.

Cheers,
Longman



