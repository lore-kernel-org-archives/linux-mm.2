Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B76AEC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 02:36:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73C296B0005; Sun, 28 Jun 2026 22:36:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C5B56B0088; Sun, 28 Jun 2026 22:36:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58D546B008A; Sun, 28 Jun 2026 22:36:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 305F86B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:36:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 93C328ED05
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:36:27 +0000 (UTC)
X-FDA: 84931386414.12.D463E46
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3DD64A0004
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:36:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M+ojBwlC;
	spf=pass (imf25.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782700586;
	b=wE2HpthfWzUiCaVMN5zNr3R0aGhLomM4ZNwG1xpNY2ZSL/Yd+QLBcUcVX3uo3m5tAfkGcD
	WwWj+f4RIfTZ2G1GfzBIzr2zwABev1LKhWN+mYumUpl7Ebul3fNH0uKZ1Xd5tV2Uk4HDoR
	qxjGQa2vdK+QPOX8gug6peVbhRn3Dok=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782700586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7cyDeEsZT9wRFLlwPp15UPH88M4bxDf8kOfDgpQPwUc=;
	b=T5lUtfe3mZkYuUl6eIv0U/QNvLKsdELaw4gs30gbDilZJPHzcaJj8A/VLEcQsHhvqAA5Lb
	L9rujphUrIUXMj/5PkJgQoLmZLdCUEcQV5XF0u9WbF8LjIndpaMprwswjRatjYV7oVeiMW
	8kYtGSEqj6jNMf0/HY4e/nOHOjk6HLA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M+ojBwlC;
	spf=pass (imf25.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <4dce3872-1d3f-41de-adcf-5b0c4b431a6d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782700583;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7cyDeEsZT9wRFLlwPp15UPH88M4bxDf8kOfDgpQPwUc=;
	b=M+ojBwlCQDdmszCTRnxWPExvxXyng6MVhj30klQQw6f3O7DkmGj+V/0tfoVtiDMbSDKklA
	9H45tLrdz51sKSumjhhjwT3yjv3TJMAp0oVJel05NgM2oE6Ct9RMU8ZURJiGOaS+GsIuLw
	YAY9doefgC6L5KftbOhm6tnj99uvgvg=
Date: Mon, 29 Jun 2026 10:36:14 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 5/6] mm/page_owner: move free_ts_nsec output to free
 section in __dump_page_owner()
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260626024550.25677-1-ye.liu@linux.dev>
 <20260626024550.25677-6-ye.liu@linux.dev>
 <DJJ7K125ZT44.1D6ZSH2JPWIES@nvidia.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <DJJ7K125ZT44.1D6ZSH2JPWIES@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: hfamf4q6mjcz7rtbjj81w5tqtorpiwou
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3DD64A0004
X-HE-Tag: 1782700585-39018
X-HE-Meta: U2FsdGVkX182hlvN+3BUJ/QVrB7enmGGZUXNk9AFhHtFhIk5vKEph0+SxsuqVvDy+fR4BWq+vSck1IBv247Xp+hLlOBzWROAePzozNBbx8elHQCk+wsPcX6vQdw8skml4GnapNJlQArbnHdxnAUijw8omf4FzPIxFXSozVKYxbUYYUwdz9w39iH0faSLLmf1D6fIVC0dkal5ezhbWH7XFUSlrPAfywekGEMpTWiLklxQtSgsJmZOzTCij/4TMDoYRLN4oKJFeIwvKENhi+pUEgJMhODxwa8u/IRd94NGfwE7KU/70RDVQP0OEQPZ/W8Z0WkCqEP63LRG52lIm9n75fFOgQc2FWSRRZShp5kD8ma1HFflLLqASeibG9ytmvPBMyFljlCeX2x/a5eC13/IID3NbDAASm2YT7LoZuwR5cgRYONtPab3lrTjG+BA12gjaJZYXHinloMyr8KQKZOXnKDiM1hpOWM5eFcRHqRfILzW+GKo1/xVQmpCQxHychsWqep6LeHO4a+zbgzsocoKedMwhVKePFpcAujiGEb+8UTIX4NctoTL4XFKWkh4XhBkRBrCvXPVpRC0icu/wUjE6B8MGCJN91PLoWmISOmGvqVzs3BADlqgzzaJuVcOsmyMtZDz3GdOcXQef/owZzsT7OSuwK3Y730yMor4epV+WPIeknARRqauQ2e6988u+A+sxkqcARqDQeH8BxB3n7R3VKl4WeOwvPTqDhCFzGB7XtKFLM+3RAeOeNnU1ApF4u5fYjsyJ5/QLT+V97zZKTrPVfLG1oz4Viheml3y3otzRmXeDzLUNoSKchNV/NmRdBrD6MqAmIj0ZH8nQtNYwdtAcPcemDNZn1G1lEZ88WFKglBujqEktw4n5dxFN5U80P4fsAijp0Id2NFO1/aZXwEApnPMSOzBytEbBSozbSWZTle99+W/t0cQ8MR0KHgoJc1VTXYzt9lxCRafvk4HOqT
 r7ZYNLU8
 +5lSMTTiB87dBkc+yAZz5nYs1vilCIkIUlfKVIC0hkwxSr5LVnvQe/JZ5Al2zHmP5SobKNLSoiy4uEGK6nAGGkh8/8uzEfxVSYLkBvOtLok6dejZrZ4Bf+NjrEEUjs97wH9P3EhCQxbmwFzjVSLVO7cL2ySd3OtrLSBPH7p6q9XJhiuy98V+zguxZRHohIF7nw9uy0/S/EXkmgqvLam8CEwdGsWqpKYFi4NqiX7n5/GChJR25cGRAd3LkB0XZpcincoiixOLDHmN8VQO3Sv5PrKxarw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/6/27 02:55, Zi Yan 写道:
> On Thu Jun 25, 2026 at 10:45 PM EDT, Ye Liu wrote:
>> The free_ts_nsec field is a free-event timestamp, but it was printed
>> in the allocation summary line alongside ts_nsec (allocation time).
>> Move it to the free section where it logically belongs, together with
>> free_pid and free_tgid.  This also makes __dump_page_owner() consistent
>> with print_page_owner(), which only prints ts_nsec in the allocation
>> summary.
>>
>> The output now groups all free-related information (pid, tgid,
>> timestamp, stack trace) in one place.
>>
>> No functional change except output formatting.
>>
>> Signed-off-by: Ye Liu <ye.liu@linux.dev>
>> ---
>>  mm/page_owner.c | 9 +++++----
>>  1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/page_owner.c b/mm/page_owner.c
>> index 958151ccb587..eaccff355cb4 100644
>> --- a/mm/page_owner.c
>> +++ b/mm/page_owner.c
>> @@ -660,10 +660,10 @@ void __dump_page_owner(const struct page *page)
>>  	else
>>  		pr_alert("page_owner tracks the page as freed\n");
>>  
>> -	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#x(%pGg), pid %d, tgid %d (%s), ts %llu, free_ts %llu\n",
>> +	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#x(%pGg), pid %d, tgid %d (%s), ts %llu\n",
> 
> Is it going to break existing programs parsing this information? This is
> under debugfs, so probably does not matter?

This is debugfs output, not a stable ABI — debugfs format can change at any time.
The field just moves position within the same function's output.
Grouping all free-related info together makes __dump_page_owner() consistent
with print_page_owner(), which already only prints ts_nsec in its allocation line.
I'm not aware of any tools that parse this field, but if there are, I'm happy to
update them as well.

> 
>>  		 page_owner->order, migratetype_names[mt], gfp_mask, &gfp_mask,
>>  		 page_owner->pid, page_owner->tgid, page_owner->comm,
>> -		 page_owner->ts_nsec, page_owner->free_ts_nsec);
>> +		 page_owner->ts_nsec);
>>  
>>  	handle = READ_ONCE(page_owner->handle);
>>  	if (!handle)
>> @@ -675,8 +675,9 @@ void __dump_page_owner(const struct page *page)
>>  	if (!handle) {
>>  		pr_alert("page_owner free stack trace missing\n");
>>  	} else {
>> -		pr_alert("page last free pid %d tgid %d stack trace:\n",
>> -			  page_owner->free_pid, page_owner->free_tgid);
>> +		pr_alert("page last free pid %d tgid %d ts %llu stack trace:\n",
>> +			  page_owner->free_pid, page_owner->free_tgid,
>> +			  page_owner->free_ts_nsec);
>>  		stack_depot_print(handle);
>>  	}
>>  
> 
> 
> 
> 

-- 
Thanks,
Ye Liu


