Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49383C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 08:00:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17F1B6B0088; Mon, 29 Jun 2026 04:00:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12FB46B008A; Mon, 29 Jun 2026 04:00:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01E526B0092; Mon, 29 Jun 2026 04:00:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BADE36B0088
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:00:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 342781405D8
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:00:45 +0000 (UTC)
X-FDA: 84932203650.02.389F933
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5CAFF40018
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:00:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EXKS81pj;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782720043;
	b=zGkFL//fN8ABRoZ3AJ0Ap7npq+uBPz6cQ5TWHUH0TWmyP5ZwV7yFQDREZNR1wOHZH6Escy
	2c8NH+DlMlh11l5cidfvSrl3LC4LNCv5MlFQSgcNg+jMJvG9eOcaDeiwnqiJVSEbpVE1wV
	i4nmqErQhS1gRql5jfQPZRK3Ba1PXks=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782720043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W/LgCWWfF/NcaocAuaVXtNR665KgEcQqH4uB4RpU4cw=;
	b=jabP8tepaz7TAINNHV5U1ZZ8YcF5lECERAP2WgMRntCMqtawiwEj4p0SGb5JMHGigkR569
	70QBv9barritKSKrShWvXMHhpYYM8e8o4RHlevKDrzvYfr8A/mns0dMifmjvavnHrD2kQg
	TSdMPNiLwbovA7+n+ddCXm3GY9oz6Vs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EXKS81pj;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D805460008;
	Mon, 29 Jun 2026 08:00:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F691F000E9;
	Mon, 29 Jun 2026 08:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782720042;
	bh=W/LgCWWfF/NcaocAuaVXtNR665KgEcQqH4uB4RpU4cw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EXKS81pjhnX/T3t20HwM0r+G8lZqOaf7LUBFI4WeNo8HO7Dv9KyGrHaNmXneQ778Z
	 dREeqYHE7e/A5Q+YYwlBlEMv0GobGewa87N0nTR3ppXR/wdBGeAjiI6pjGNSvoMDN0
	 eZ6UoSXLBoe4MqtKJ4Sl/waE+QXU1BcmAB2ZLjoDSlVhukD+jGCRfVjgbQLsrg0Q7G
	 3k8082FO++Ml3PQ2eE9k8jCQ/sgc7mfHWX1HgRPZFp3B6oAdg/kxrJoZ4WXe7GELHG
	 an6aeydeJMc45Q290ZgCuvu/l80ioKCKwq5n9oHNf2QpIySP7ObpJ94ugAT9Lw7qtT
	 bvUZsyYFN24uA==
Message-ID: <fe46197a-3237-470f-869f-014057512412@kernel.org>
Date: Mon, 29 Jun 2026 10:00:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/6] mm/page_owner: use MIGRATE_REASON_NONE instead of
 -1 for last_migrate_reason
Content-Language: en-US
To: Ye Liu <ye.liu@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260626024550.25677-1-ye.liu@linux.dev>
 <20260626024550.25677-3-ye.liu@linux.dev>
 <DJJ7CCWCYI47.3VWWQE2AWP6NC@nvidia.com>
 <407fa67f-3212-4c5a-ac8c-7c5d41479cc9@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <407fa67f-3212-4c5a-ac8c-7c5d41479cc9@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3da4nixpmtgwjub89tzjaqrkmmx6zz71
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5CAFF40018
X-HE-Tag: 1782720043-152371
X-HE-Meta: U2FsdGVkX19Wdv5cu2L3kKmzkLwqChOmm57CzKBZs/88mo+vELPmyCV5YlrDDtDw0RnrTTCGNvXChVP4fJoUI0ZNPC8HbJNShfwWp5hEIb6NPB+2KVLKdmVXLTLXuuH5DptF6wzhnj65XOV3Y5ljEtN46y7YRyieRUVKBvN+kZn7iSW5Qi4+wbUCXyQkImhJO8HL/NL9lCeJReqqnyw6Iexr5zKiRZOxgjaj9J7pVOQ8a93PjEmeUh1qZ/0Al1v89AbmUkJOThcGBhXjWBMon1y0MAhy2IS2XkL+kCuOHjWhFlEQtKYQXmoIhFjRaM3Ii6SDWPrnxY4uehyqGR+CCvdIvTaYMvTG+6yjCQ+WfizofLoEWmzUnq0Y5aPnksNXQjCu2OMmbzO915GiQaDzyftF3RkANLWHN+iVHxY6UKOngYCMr/D1jSxX086xvo8OqkuRhn3BpdYqxMrObeGzueJ9CMzZGb35+ajGPscPR7w5/cYLSyAigwsZzln2SivoE7VoF9rr9beMZ6UrBJlQmHLg0afbYikvNsoROJhGOpXYkTusDIL7qfNSZvCao7Dms4PtUyupiK2YExo5+QswKhBNbwDVuW89JpyXf7pPQK68lM92MMyl4GD9eVsGnEjp6wze8EyGx9P3i3tSmkCOV6Ws5qpCmNOUdiRpSTw8xNZOkQe0p8eLZCjltn7QEZQ12BS0w+nV5TxXPxKhHamIsH8yVIi6yb4RVv4/wrgrIJkO4xoT5iC3rgTiql22V5GXSkpNdif6B7UVXO+x8ZtgXmDcT6Bvq8Duv4EL0AyvZ+aFIm8y+SeGArFmLxz6LvMlYHBBlbf6YZNFMSnvTKu3ic5oWo4Vjrnhmlo6k5QSVQsIHVDrV0Rd5pfNGkTah3dH5wbhQhOhs3egek61J266kYqvXyDZQApsrgyCr7B+mUK8STVwtPIsUtSm7yNM7CLIMzU+HiuEzkQDvYg1ryr
 g3lESAar
 d2Gntw8SbkdP/F8FWeNC/gK/9lquTJLVBDxNb0a37ecYDCGOqfSWePVRAMArsUkobm/ll/xzeW98F1dqzW74XUEnp5zcDXBXMr2x5b17cw+b7eMWuL/TOxtJVr1Mphwt9NSUY9YU9KcMA2jzfdvnWltgB5wiUX/C/tR8sjPAsSuG5gWwd3NLytwSgMaWtwwaLFl5B3kk/MWWMmrBaOKgZQgO7m2/ziwxjgFF0xrxdM3OYLUL8rTbXiRcYj7OAwTC2/QtNyOpfok+V1u9YErt/DjQp66HkBiQikG0f14b3FwIeNQre9ryzjZAth3PpfIQahURRJlMqUBHYI00=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 04:20, Ye Liu wrote:
> 
> 
> 在 2026/6/27 02:45, Zi Yan 写道:
>> On Thu Jun 25, 2026 at 10:45 PM EDT, Ye Liu wrote:
>>> The last_migrate_reason field uses -1 as a sentinel value to mean "no
>>> migration has happened".  Replace the four bare -1 occurrences with a
>>> local MIGRATE_REASON_NONE define so the intent is explicit and the
>>> magic number is eliminated.
>>>
>>> No functional change.
>>>
>>> Signed-off-by: Ye Liu <ye.liu@linux.dev>
>>> ---
>>>  mm/page_owner.c | 15 +++++++++++----
>>>  1 file changed, 11 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/mm/page_owner.c b/mm/page_owner.c
>>> index 342549891a8d..ebafa9d7ff07 100644
>>> --- a/mm/page_owner.c
>>> +++ b/mm/page_owner.c
>>> @@ -21,6 +21,13 @@
>>>   */
>>>  #define PAGE_OWNER_STACK_DEPTH (16)
>>>  
>>> +/*
>>> + * Used to indicate that a page has never been migrated, as the valid
>>> + * migrate_reason values are non-negative enum members (MR_* in
>>> + * include/linux/migrate_mode.h).
>> 
>> Why not change last_migrate_reason to enum migrate_reason and functions
>> pass migrate reasons? MR_TYPES probably can be used to indicate no
>> migration has happened if we do not want to add MR_NO_MIGRATION.

Indeed. I'd just add a proper MR_NEVER option with a comment.

>> folio_set_owner_migrate_reason(),
>> __folio_set_owner_migrate_reason(),
>> move_hugetlb_state(), and
>> __update_page_owner_handle() need to update their signatures for this.

They should ideally, but do they "need" as part of this series?
But I guess it's not a big deal.

> Thanks for the review.                                                        
>                                                                               
> Using MR_TYPES as a sentinel is problematic - it's used kernel-wide as an     
> array-size marker (migrate_reason_names[MR_TYPES]). Overloading it to also    
> mean "never migrated" conflates two unrelated semantics. It also has a        

Well it's just for tracepoint and dumping page owner. Nothing prevents us
assigning a value to MR_NEVER that's not -1 (just make MR_NEVER the first or
last option of the enum) and a give it a name e.g. "never_migrated" in
include/trace/events/migrate.h

> subtle out-of-bounds risk: if anyone ever uses the field as an array index    
> without the guard check, MR_TYPES silently points past the end of the array,  
> while -1 faults immediately.                                                  

That wouldn't be a problem either with a proper value.

> Adding MR_NONE = -1 to the enum is the right long-term fix, but that needs    
> proper enum definition changes and cascading signature updates across multiple
> headers — better done as a separate series.                                   
> The current patch is a minimal improvement: it kills the magic number and     
> makes intent explicit without touching any header.                            

Minimal fixes are sometimes necessary for actual bugs, for stable backport
etc. Nothing prevents us doing it properly here.

>> 
>>> + */
>>> +#define MIGRATE_REASON_NONE (-1)
>>> +
>>>  struct page_owner {
>>>  	unsigned short order;
>>>  	short last_migrate_reason;
>>> @@ -339,7 +346,7 @@ noinline void __set_page_owner(struct page *page, unsigned short order,
>>>  	depot_stack_handle_t handle;
>>>  
>>>  	handle = save_stack(gfp_mask);
>>> -	__update_page_owner_handle(page, handle, order, gfp_mask, -1,
>>> +	__update_page_owner_handle(page, handle, order, gfp_mask, MIGRATE_REASON_NONE,
>>>  				   ts_nsec, current->pid, current->tgid,
>>>  				   current->comm);
>>>  	inc_stack_record_count(handle, gfp_mask, 1 << order);
>>> @@ -596,7 +603,7 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
>>>  	if (ret >= count)
>>>  		goto err;
>>>  
>>> -	if (page_owner->last_migrate_reason != -1) {
>>> +	if (page_owner->last_migrate_reason != MIGRATE_REASON_NONE) {
>>>  		ret += scnprintf(kbuf + ret, count - ret,
>>>  			"Page has been migrated, last migrate reason: %s\n",
>>>  			migrate_reason_names[page_owner->last_migrate_reason]);
>>> @@ -667,7 +674,7 @@ void __dump_page_owner(const struct page *page)
>>>  		stack_depot_print(handle);
>>>  	}
>>>  
>>> -	if (page_owner->last_migrate_reason != -1)
>>> +	if (page_owner->last_migrate_reason != MIGRATE_REASON_NONE)
>>>  		pr_alert("page has been migrated, last migrate reason: %s\n",
>>>  			migrate_reason_names[page_owner->last_migrate_reason]);
>>>  	page_ext_put(page_ext);
>>> @@ -826,7 +833,7 @@ static void init_pages_in_zone(struct zone *zone)
>>>  
>>>  			/* Found early allocated page */
>>>  			__update_page_owner_handle(page, early_handle, 0, 0,
>>> -						   -1, local_clock(), current->pid,
>>> +						   MIGRATE_REASON_NONE, local_clock(), current->pid,
>>>  						   current->tgid, current->comm);
>>>  			count++;
>>>  ext_put_continue:
>> 
>> 
>> 
>> 
> 


