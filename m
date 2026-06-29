Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7EBCC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 02:20:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78C996B0005; Sun, 28 Jun 2026 22:20:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7648B6B0088; Sun, 28 Jun 2026 22:20:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A3186B008A; Sun, 28 Jun 2026 22:20:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 475836B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:20:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BBD6A8EDAC
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:20:47 +0000 (UTC)
X-FDA: 84931346934.15.A9C9EAA
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9C6E9180003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:20:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fPRn39Wa;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782699646;
	b=CrLlVWtHrYTBgHRDRSC7qVWc1V3toXsKayy0CA2u9/o+fkn6hLXsrb5QnNDUYxHs4AR7pn
	lLGUfSngdQembLHnxZNddNhVRTLsZ5VQYSBudeiFTl9cri3m2Iq5abmoAuQ84brv8XTJxn
	rM2EYuUGSEjz4Dw6RYTTcU0A2wxmSms=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782699646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ZMBFIIHzKp4wEGH39HgLodCOcu46BE1L/+pEUVqads=;
	b=8bux85BMXPQxVCVF6ZeN31mVs1cD2XQhEAM0bJtfi9DPY8dbU8m1GkbZqubemGiE+wOtqh
	noJ0v8z80D7v+cdYQ8vuX0nJk9WxBhLwa5xJyQdkTUrtVf+rWYEgCd9RzQCs6EzWk1ItQ3
	faaA+8iY7XTYClGt6F06J4GKx+GflEE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fPRn39Wa;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
Message-ID: <407fa67f-3212-4c5a-ac8c-7c5d41479cc9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782699643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8ZMBFIIHzKp4wEGH39HgLodCOcu46BE1L/+pEUVqads=;
	b=fPRn39Wa0GEM59aN7rtvgym8CNcEvbYf4MbBgPWlhNekwP3UtQZcfBsn2jq35lV17B8YO+
	ohzFJHKhjmLPVVKFk6qouSh54NzX3Ev2QRzLdD1OtpCpNa71KtAeJy434X2Kx/kWpVPre0
	5qud769RpwjuoLjWTx08XQF30LuXn6w=
Date: Mon, 29 Jun 2026 10:20:24 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/6] mm/page_owner: use MIGRATE_REASON_NONE instead of
 -1 for last_migrate_reason
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260626024550.25677-1-ye.liu@linux.dev>
 <20260626024550.25677-3-ye.liu@linux.dev>
 <DJJ7CCWCYI47.3VWWQE2AWP6NC@nvidia.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <DJJ7CCWCYI47.3VWWQE2AWP6NC@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9C6E9180003
X-Rspam-User: 
X-Stat-Signature: rz6oerrh7f8y7efmcm17ixziu54dw7ra
X-HE-Tag: 1782699645-214899
X-HE-Meta: U2FsdGVkX1/iEdfJULIp0ucmf/7srCd7/ZYyn3riGyvDELm22VXH1iHMaVbB0ROU13esOUsgmooG1+ZMu5qGQziWtHeL066z8iUw81XZ3Zqux7q1xABkLy5y0HS0HQmFdWuQV35bl1aWBQytXe+vBZQyOF7xaNWvLS1gCU3DjAfYIseOtqHXLssbUceQF+aNsHqAWh/z9T3N41bRDU714aI1R/9VHANOIGeGD7UjfEZj76RRrsbEhOnwQzJ7lrq8/rFZZf8o9yCw/oQmYRVCcBEGiHQcRq83p/bZa/xn7v0/7pVz0hZES8jO6RHdCnv7oFpUoLvsx+CPE/zFmwaggg75/PyIfPTdmP16fJAdRyX4Orw9KeWJD+Cji7T4hFY+EGovrLB618LNSgM+v2qxqH5JAIS5xagoxNA8ZA/z1MAQPpH54nJtycrcEBB9ZI2gfNTRDWjJjr4E0fe7k/pX9g30iMb0Mztwr53ppv/PkSdUUq/X7EqPiWFhHrN6JO1cf+Y5lxvAZFc0xjk3aGb6+pQt1p/LGxdnXjWzlmGlS+iG5RjbsQRqw3gA/10mIH74G7zkHcI+t8HWSoGMMO9J+HUKsi3U1iYsgGiA5U8Ew+58w2/1RLLFY0fCXFLnO718Z+2AeSgQwFK2sMNM064FMaryhhd41jOkicPAfWm0B5t+yVD0v+pExfW94k/71+vm7mpg+DvkeN4V4yDvy6IPwBLg6Ai4zIwFcJlImjkQ/V9A6avnNcITiUTd+hJHhxLobUzq0ep0axDpBpr5H5xdCtEqZzKs1MrSMu9hz6ZJ8kJvKhRQ0dufolhXOun2biWLdM4yjd5yPH11y7gLgRUaFaJjGzMoNVSjLOLmenbNaVH8K4hIX+jAChHjjY+l/oPpU4jkIr0M9w0SLSyPkUNqcQaFXwmNPTeZ+2D2pde+96urQygjYkxxVj0ONgJz7WD8/Utu7VB7ZDCij+XLb3B
 41R+rzAD
 KQwXMkO8xzeznzSyjvv2SO8UqP6b4wTMfov+tcfewIJg66gniGFuqq/iI5SWl9Luu8HK5ld0AqSSsrEsrv7n4OxLBEcU4yS0kWSsKqacYFT+1D3vwyqUNaYPJmJtvk/FKLxPI+ywnmX2Jry7bGMpkLgNBLu2bJX5PcqucaCtS0UA3esGk36yYy7FTBmmHQq1b4IQPt1n5yVtoD5+JO94bG31TZVw+SSIKtjzJOb9Ax+vyM3ayXDvf6i1grtyo9F4UggmuuRECaJ35ALbVtwikKV1rBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/6/27 02:45, Zi Yan 写道:
> On Thu Jun 25, 2026 at 10:45 PM EDT, Ye Liu wrote:
>> The last_migrate_reason field uses -1 as a sentinel value to mean "no
>> migration has happened".  Replace the four bare -1 occurrences with a
>> local MIGRATE_REASON_NONE define so the intent is explicit and the
>> magic number is eliminated.
>>
>> No functional change.
>>
>> Signed-off-by: Ye Liu <ye.liu@linux.dev>
>> ---
>>  mm/page_owner.c | 15 +++++++++++----
>>  1 file changed, 11 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/page_owner.c b/mm/page_owner.c
>> index 342549891a8d..ebafa9d7ff07 100644
>> --- a/mm/page_owner.c
>> +++ b/mm/page_owner.c
>> @@ -21,6 +21,13 @@
>>   */
>>  #define PAGE_OWNER_STACK_DEPTH (16)
>>  
>> +/*
>> + * Used to indicate that a page has never been migrated, as the valid
>> + * migrate_reason values are non-negative enum members (MR_* in
>> + * include/linux/migrate_mode.h).
> 
> Why not change last_migrate_reason to enum migrate_reason and functions
> pass migrate reasons? MR_TYPES probably can be used to indicate no
> migration has happened if we do not want to add MR_NO_MIGRATION.
> 
> folio_set_owner_migrate_reason(),
> __folio_set_owner_migrate_reason(),
> move_hugetlb_state(), and
> __update_page_owner_handle() need to update their signatures for this.
> 
Thanks for the review.                                                        
                                                                              
Using MR_TYPES as a sentinel is problematic - it's used kernel-wide as an     
array-size marker (migrate_reason_names[MR_TYPES]). Overloading it to also    
mean "never migrated" conflates two unrelated semantics. It also has a        
subtle out-of-bounds risk: if anyone ever uses the field as an array index    
without the guard check, MR_TYPES silently points past the end of the array,  
while -1 faults immediately.                                                  
                                                                              
Adding MR_NONE = -1 to the enum is the right long-term fix, but that needs    
proper enum definition changes and cascading signature updates across multiple
headers — better done as a separate series.                                   
The current patch is a minimal improvement: it kills the magic number and     
makes intent explicit without touching any header.                            

> 
>> + */
>> +#define MIGRATE_REASON_NONE (-1)
>> +
>>  struct page_owner {
>>  	unsigned short order;
>>  	short last_migrate_reason;
>> @@ -339,7 +346,7 @@ noinline void __set_page_owner(struct page *page, unsigned short order,
>>  	depot_stack_handle_t handle;
>>  
>>  	handle = save_stack(gfp_mask);
>> -	__update_page_owner_handle(page, handle, order, gfp_mask, -1,
>> +	__update_page_owner_handle(page, handle, order, gfp_mask, MIGRATE_REASON_NONE,
>>  				   ts_nsec, current->pid, current->tgid,
>>  				   current->comm);
>>  	inc_stack_record_count(handle, gfp_mask, 1 << order);
>> @@ -596,7 +603,7 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
>>  	if (ret >= count)
>>  		goto err;
>>  
>> -	if (page_owner->last_migrate_reason != -1) {
>> +	if (page_owner->last_migrate_reason != MIGRATE_REASON_NONE) {
>>  		ret += scnprintf(kbuf + ret, count - ret,
>>  			"Page has been migrated, last migrate reason: %s\n",
>>  			migrate_reason_names[page_owner->last_migrate_reason]);
>> @@ -667,7 +674,7 @@ void __dump_page_owner(const struct page *page)
>>  		stack_depot_print(handle);
>>  	}
>>  
>> -	if (page_owner->last_migrate_reason != -1)
>> +	if (page_owner->last_migrate_reason != MIGRATE_REASON_NONE)
>>  		pr_alert("page has been migrated, last migrate reason: %s\n",
>>  			migrate_reason_names[page_owner->last_migrate_reason]);
>>  	page_ext_put(page_ext);
>> @@ -826,7 +833,7 @@ static void init_pages_in_zone(struct zone *zone)
>>  
>>  			/* Found early allocated page */
>>  			__update_page_owner_handle(page, early_handle, 0, 0,
>> -						   -1, local_clock(), current->pid,
>> +						   MIGRATE_REASON_NONE, local_clock(), current->pid,
>>  						   current->tgid, current->comm);
>>  			count++;
>>  ext_put_continue:
> 
> 
> 
> 

-- 
Thanks,
Ye Liu


