Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0561C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 01:00:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 912A86B00A3; Mon, 29 Jun 2026 21:00:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C3D46B00AE; Mon, 29 Jun 2026 21:00:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 801766B00B0; Mon, 29 Jun 2026 21:00:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4D2B36B00AE
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:00:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BC7D61202FD
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:00:02 +0000 (UTC)
X-FDA: 84934772244.06.A03258F
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf12.hostedemail.com (Postfix) with ESMTP id 55FDC40004
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:00:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w7ejOGDo;
	spf=pass (imf12.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782781201;
	b=8TIzf0qiLFQjUrtUBzTwnDJWP7Usj6lR8s9m30Dp3BXz6oxE78TFsAhMSk8QoEagOi+KgY
	1IIndMN7ewI/aec+Y8qn8TaQkEsMoBoi8iQN/oR1HrHehQiRIqjy5mxaTndqYP19rczGYp
	heyd9UAD8V3sybpP+ssvvJxGt3vl4FU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782781201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G+5yOIRk93e36AuhpitdlOf7eS3TS9OTL2poou9R2Nk=;
	b=n6/Hn70W14ILYfeS7ksWOI2cw9EF8pMZN3TADtjpYVnPi1kobZebvgh7IIbLM8NoS8oQ/u
	C8MbDddPjbEj67UdbUwagLl0k3x2v2JU56QsTA8jwb5yXNCw4QJQtp5VLAYkTaSXb+BYZN
	X0CWXEExMZV+cDD7PyCRjd7F/792LbY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w7ejOGDo;
	spf=pass (imf12.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <29d9caca-5637-49c1-978c-83550430c538@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782781198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G+5yOIRk93e36AuhpitdlOf7eS3TS9OTL2poou9R2Nk=;
	b=w7ejOGDog1rBi7CMTMbxBtiPSX1aljWTgVWoM9o7Y29SiAkzCiLmQyVUCwsCyMirgyVDvP
	vQX7Lw0vvbTwMlUYiVYXpMIh2TXB2aT79pd7hbvrY7T66I1rrJg6mFuOzc5eRe3a4MP1sl
	3cXVz0W/jhqLl3ZCCHwLRqxTAp0wREM=
Date: Tue, 30 Jun 2026 08:59:47 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/6] mm/page_owner: use MIGRATE_REASON_NONE instead of
 -1 for last_migrate_reason
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260626024550.25677-1-ye.liu@linux.dev>
 <20260626024550.25677-3-ye.liu@linux.dev>
 <DJJ7CCWCYI47.3VWWQE2AWP6NC@nvidia.com>
 <407fa67f-3212-4c5a-ac8c-7c5d41479cc9@linux.dev>
 <fe46197a-3237-470f-869f-014057512412@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <fe46197a-3237-470f-869f-014057512412@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 55FDC40004
X-Stat-Signature: 91fsc5bo91crjuobtypjm17q5a5s6mnz
X-HE-Tag: 1782781200-668981
X-HE-Meta: U2FsdGVkX1+/X/BTMyYyNHz9hw4E+zxROv3ISJLkf9i/abJ/pOkoRemnZSBBxFO0v4lip2YqQZ5gMqWvJeqa7yZmY3UAu6rvQRNc4uMRfzpar5zo8DqOS6o/7yQ5es0qxRnrt08gNbDJFbg4zQH/R0gEy5kOQEbpegYgjj3xttXHDo0aReNYo5S2xRfia0I8OyB3NH8gxrk1SRTaCSNoCp08PLugdwU1MrppuZtk4YQ+FQHEKGf5BgvvjnQAW82KfrC+m8L9XtNzGRB4RUDuH//wA1ra67tvxX6SESmNF2EM9WFqhcJxXAFlAswX8LEXcWIaW5qP2hsSmwNirgJcXKLFsyP73zN8JiH2ke4CQj7nSmmoN5VYbma80zWNJay9M9CCUj97+OaxQwfiCuVOUyFs3w41IAl+dQ/2IFspcKGGBHu58GfhKjqNqXwCL0pynkO2w5B2Q9EBWKdLLWmwawHh6/4SZ1CJc5d71/EBcTJfVCxZEjaGBT+KY4StBynhq0PA3k9JoEgrpxYal8izDQqzosSRH//Cdv1r8+KevEQ+gDSK2E8s3Oep7gXcctp48hL/FfZHPt+SnTmBAXFquwa32ZmH12gz2J5PyAvyGd/tM5Duf+OiaKE75VPMIzoJE37zmAeiL0hu+qDFfPacT/E41MYoGXJlwEzA6NczfAgPMVWteOS5OcSnm8oMmm/P56iW2o3LLIKrgBw9frH56sh/db6oEKrsnu1tiNEkUcn4/op8HzotgBmv2gmTZB6xfSh+3Lxs4q6/XmMPRWAUbFhnJZzP28WoW/8e1lkpEM4QFumEWJZYIEIfPkK98/2EktvSLM/jUtb0DxZ3BtGZ3GBxhrTGMFiQ2dpSf4kTHO3c6BaPmxpEJN9EWvfu83oEh8XHLs+ZsM3TCZkfXJMEuwWvnPSCqXFWX6yMUL/13VD0wp0052KL5PI4rvEDd1ZlQ+sA4r8Rz1zEzoYlJgn
 6MzmncAl
 AIQPfp3nKq7fSF8GCoVKUfc+ClhBJ7wr2WQCTwF85pxZHDvtdQnrOiwe3BNR3RackjhkxmbkkcePntOEsgDR0Y3np5e5pix81+Mv/u/5YNzQekSkXQSx/weiz8J6SGMfdm0Dk03aj4zwqKRCThSHcEhURvRxmwW/HbDShB6bnudlY/mAqUO7WGyCmSVKxjy6eyO76B8lR5D7z+z/6CmYIAYrk9LF8JwcMIoo+CWYh2jw4ggro0zZGJQ4bl65gbFkwNNNAtTeYz/CZ3VHTscUzsIOjeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/6/29 16:00, Vlastimil Babka (SUSE) 写道:
> On 6/29/26 04:20, Ye Liu wrote:
>>
>>
>> 在 2026/6/27 02:45, Zi Yan 写道:
>>> On Thu Jun 25, 2026 at 10:45 PM EDT, Ye Liu wrote:
>>>> The last_migrate_reason field uses -1 as a sentinel value to mean "no
>>>> migration has happened".  Replace the four bare -1 occurrences with a
>>>> local MIGRATE_REASON_NONE define so the intent is explicit and the
>>>> magic number is eliminated.
>>>>
>>>> No functional change.
>>>>
>>>> Signed-off-by: Ye Liu <ye.liu@linux.dev>
>>>> ---
>>>>  mm/page_owner.c | 15 +++++++++++----
>>>>  1 file changed, 11 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/mm/page_owner.c b/mm/page_owner.c
>>>> index 342549891a8d..ebafa9d7ff07 100644
>>>> --- a/mm/page_owner.c
>>>> +++ b/mm/page_owner.c
>>>> @@ -21,6 +21,13 @@
>>>>   */
>>>>  #define PAGE_OWNER_STACK_DEPTH (16)
>>>>  
>>>> +/*
>>>> + * Used to indicate that a page has never been migrated, as the valid
>>>> + * migrate_reason values are non-negative enum members (MR_* in
>>>> + * include/linux/migrate_mode.h).
>>>
>>> Why not change last_migrate_reason to enum migrate_reason and functions
>>> pass migrate reasons? MR_TYPES probably can be used to indicate no
>>> migration has happened if we do not want to add MR_NO_MIGRATION.
> 
> Indeed. I'd just add a proper MR_NEVER option with a comment.
> 
>>> folio_set_owner_migrate_reason(),
>>> __folio_set_owner_migrate_reason(),
>>> move_hugetlb_state(), and
>>> __update_page_owner_handle() need to update their signatures for this.
> 
> They should ideally, but do they "need" as part of this series?
> But I guess it's not a big deal.
> 
>> Thanks for the review.                                                        
>>                                                                               
>> Using MR_TYPES as a sentinel is problematic - it's used kernel-wide as an     
>> array-size marker (migrate_reason_names[MR_TYPES]). Overloading it to also    
>> mean "never migrated" conflates two unrelated semantics. It also has a        
> 
> Well it's just for tracepoint and dumping page owner. Nothing prevents us
> assigning a value to MR_NEVER that's not -1 (just make MR_NEVER the first or
> last option of the enum) and a give it a name e.g. "never_migrated" in
> include/trace/events/migrate.h
> 
>> subtle out-of-bounds risk: if anyone ever uses the field as an array index    
>> without the guard check, MR_TYPES silently points past the end of the array,  
>> while -1 faults immediately.                                                  
> 
> That wouldn't be a problem either with a proper value.
> 
>> Adding MR_NONE = -1 to the enum is the right long-term fix, but that needs    
>> proper enum definition changes and cascading signature updates across multiple
>> headers — better done as a separate series.                                   
>> The current patch is a minimal improvement: it kills the magic number and     
>> makes intent explicit without touching any header.                            
> 
> Minimal fixes are sometimes necessary for actual bugs, for stable backport
> etc. Nothing prevents us doing it properly here.
> 
Indeed, let me do it properly.  In v3 I'll split this into two patches:
                                                                       
1. Add MR_NEVER (value 10) to enum migrate_reason in migrate_mode.h,   
add the corresponding "never_migrated" string in the MIGRATE_REASON    
trace macro, and replace the four bare -1 with MR_NEVER in             
page_owner.c.  This removes the local MIGRATE_REASON_NONE define       
entirely.                                                              
2. A follow-up cleanup that converts all 'int reason' parameters in the
callchain to 'enum migrate_reason'.  The affected functions are:       
                                                                       
2.   page_owner: __folio_set_owner_migrate_reason(),                   
          folio_set_owner_migrate_reason()                             
  migrate: migrate_pages(), migrate_pages_sync(),                      
       migrate_pages_batch(), migrate_folios_move(),                   
       migrate_hugetlbs(), unmap_and_move_huge_page()                  
  hugetlb: move_hugetlb_state(), htlb_allow_alloc_fallback()           
  trace: mm_migrate_pages / mm_migrate_pages_start events              
                                                                       
2. The 'short last_migrate_reason' struct field and the                
__update_page_owner_handle() parameter are intentionally left as       
'short' since struct page_owner is per-page metadata and the size      
matters there.                                                         
                                                                       
Thanks for the review.                                                 

>>>
>>>> + */
>>>> +#define MIGRATE_REASON_NONE (-1)
>>>> +
>>>>  struct page_owner {
>>>>  	unsigned short order;
>>>>  	short last_migrate_reason;
>>>> @@ -339,7 +346,7 @@ noinline void __set_page_owner(struct page *page, unsigned short order,
>>>>  	depot_stack_handle_t handle;
>>>>  
>>>>  	handle = save_stack(gfp_mask);
>>>> -	__update_page_owner_handle(page, handle, order, gfp_mask, -1,
>>>> +	__update_page_owner_handle(page, handle, order, gfp_mask, MIGRATE_REASON_NONE,
>>>>  				   ts_nsec, current->pid, current->tgid,
>>>>  				   current->comm);
>>>>  	inc_stack_record_count(handle, gfp_mask, 1 << order);
>>>> @@ -596,7 +603,7 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
>>>>  	if (ret >= count)
>>>>  		goto err;
>>>>  
>>>> -	if (page_owner->last_migrate_reason != -1) {
>>>> +	if (page_owner->last_migrate_reason != MIGRATE_REASON_NONE) {
>>>>  		ret += scnprintf(kbuf + ret, count - ret,
>>>>  			"Page has been migrated, last migrate reason: %s\n",
>>>>  			migrate_reason_names[page_owner->last_migrate_reason]);
>>>> @@ -667,7 +674,7 @@ void __dump_page_owner(const struct page *page)
>>>>  		stack_depot_print(handle);
>>>>  	}
>>>>  
>>>> -	if (page_owner->last_migrate_reason != -1)
>>>> +	if (page_owner->last_migrate_reason != MIGRATE_REASON_NONE)
>>>>  		pr_alert("page has been migrated, last migrate reason: %s\n",
>>>>  			migrate_reason_names[page_owner->last_migrate_reason]);
>>>>  	page_ext_put(page_ext);
>>>> @@ -826,7 +833,7 @@ static void init_pages_in_zone(struct zone *zone)
>>>>  
>>>>  			/* Found early allocated page */
>>>>  			__update_page_owner_handle(page, early_handle, 0, 0,
>>>> -						   -1, local_clock(), current->pid,
>>>> +						   MIGRATE_REASON_NONE, local_clock(), current->pid,
>>>>  						   current->tgid, current->comm);
>>>>  			count++;
>>>>  ext_put_continue:
>>>
>>>
>>>
>>>
>>
> 

-- 
Thanks,
Ye Liu


