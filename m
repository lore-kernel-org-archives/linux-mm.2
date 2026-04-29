Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5208EFF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 08:19:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91EF76B0088; Wed, 29 Apr 2026 04:19:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CEA66B0092; Wed, 29 Apr 2026 04:19:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BE576B0093; Wed, 29 Apr 2026 04:19:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6B0226B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:19:45 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E70BFC1BFE
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:19:44 +0000 (UTC)
X-FDA: 84710894688.08.7EB5A9E
Received: from mail-m826.xmail.ntesmail.com (mail-m826.xmail.ntesmail.com [156.224.82.6])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6414B180012
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:19:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf06.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.6 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777450783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P58hnib2ARAmd9HyylNE3y2H2/NO+KlsORgH5KahnWs=;
	b=nKCUSRuyqUZL4Yg1ypTgVUSfiXL71m1KrZZDG3DfKxZjkEosETRR7q0zu+JXat1RId7aR6
	7TW1qbmlTg2DaInGyH9NqoNQr4TiJvB76ohGwGW/5+wp8Cv+1oU+33bGUDVLab7FjuSfer
	+NIAxhPNHUhWqWXLFl7l4uxQ3rMOo1c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777450783; a=rsa-sha256;
	cv=none;
	b=lKuFoBEkF6DxkExUB4hd1EF9JWzxNSxoEIe05QXDLbYDWd7SXEWyRtMPXqQVJUs/PPZa7E
	MtiT/GXq3y6GhX3iQwX4qTJxv3NAmfNonZTZNovGXRxQM70ZcqTYo5srJb7M7+rz1ea443
	fhp6smmPkur0IH9tGcDOmUC3zwk9jB8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf06.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.6 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from [192.168.0.18] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1989574e9;
	Wed, 29 Apr 2026 16:19:30 +0800 (GMT+08:00)
Message-ID: <628b4e32-a004-421b-9c12-57892c16874e@easystack.cn>
Date: Wed, 29 Apr 2026 16:19:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] mm/page_owner: add print_mode filter
To: SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260429005739.88517-1-sj@kernel.org>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <20260429005739.88517-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9dd85260060229kunm78beb2c21ae281
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZGh0ZVhhNShhMSUkfHhpPQlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVCQk
	lOS1VKS0tVSkJLQlkG
X-Rspam-User: 
X-Rspamd-Queue-Id: 6414B180012
X-Rspamd-Server: rspam04
X-Stat-Signature: ub9cnzjpb6mri1bjganbywbhhqce79r9
X-HE-Tag: 1777450777-413307
X-HE-Meta: U2FsdGVkX18XYzmV0v5jZE6r5EG+zXfYlxjYyLq6O3M8i58UOxJ0WG99EPq+l4RZGImg1u2mKvBSxWIGWJ04ipe2lTIEV7nJl3RvGQygl4b/0lKKpr6yrO8yrCuTKT+L4WG1GDlIJBkpXe1w2cv6u2GZAH0gxE/RVtoiaNB+y6Aiw0BhJFM8D6h3+VrF+QpNcJz+7W2YYBU71Gq+pi1qDWUNFCYezE7BGIrWlenJEXnpoxaCX1n/AGP2x4iZG2P3WrM+pPFWKRDYqFSVxQotuoPE4HWurswUTdnDbR4DH5q26sPOHVIIsEukjW1cQq4mVTesafbxD6vHd9cPAZ/n9m8dr8soWstJC0Rs5fEs46z9A8fBhgpuZhV1FEsh1a6OfrMuPsj87oPjM1Yy/VwSFtaWmNvQ9TyjsG8mFbFTcD1mDTMQmd8ks+14p23AObaTupyPvEUT45Fv+SaXTp7KADsz9G3pk72bqYdFrp800aNjboTt3qhWmXzY70kScJK+mNOn2hvn7LHIsuP6qCizfsdUM4TEsLm4Tdi+YlTcVBnl8XDfWnHfPIFUwPx5WAx7znkbL8mFFrjSsEZvaHNr9YQuin14B9TuizUPvutRxnwCQ+w92nXmSTNMyyAL2qetXuSWkMxU9vpvDBNkWvbxtKYFleom2MpdodMzWuxKomp+jGkenL28duYZBztcgF1vk9pmv/18tKGayvX1wDsFL+6nEJeOf+uhffhhcKOMv5rTC24WAA4Sb4nN74uYAD7+CRaXIrGAR0EodCWJVC7vZA4zPG6mLEOO5zU5nab0s7FZ2q+98u1KHjtnxV1REviUh0Nw6fbrCnj0BS4FZUtlnOeYNKRWfFvwsrEHVPtYftrnUvYkJ8Ye4KybvqpAnIsPKLNm2i1XBT4qaadEFDOwyhZ7oqlqCBTzDrp1hRxEBiJC1cEklEfBI2vFbj+ldqXxQ/CETn2dayhAL9dl52q
 mIY2byCc
 cvH1K/fckX0cRwIduHVIblwAPuXL4Gd8o5/6JsCMuosII4L8hxx65deAcrweI5SIAQArBXCLVfSuU8QOHBWMTH6/Xw1Jx8EAOHu+nxaNfi8wE+rndqH2+1FNX+P4Pq9Xqs657GY1w9tKuQfsYmxVZ/GY6TYuNURI9TC24yAC8ma4f9qFOizCw/3wLBtGH4Ln01DC+cmCVsj1Dki3JbfiCBbxk5av2zNTOvOgocdTWftmYVP0tIuTndRq2uFtsyxs/lyIOXfj+C9LhSM+EQ1bxkKWaYsYC5VY+Y5fIRj8TH+H/pjHwM4qZwoP1jlav8Eva8k1a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/4/29 08:57, SeongJae Park 写道:
> On Tue, 28 Apr 2026 15:11:10 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:
> 
>> Add print_mode functionality to reduce page_owner output size by
>> printing only the stack handle instead of the full stack trace.
>>
>> Example output with print_mode enabled:
>>    Page allocated via order 0, mask 0x42800(GFP_NOWAIT|__GFP_COMP),
>>    pid 1, tgid 1 (systemd), ts 349667370 ns
>>    PFN 0xa00a2 type Unmovable Block 1280 type Unmovable
>>    Flags 0x33fffe0000004124(referenced|lru|active|private|node=3|zone=0|
>> lastcpupid=0x1ffff)
>>    handle: 17432583
>>    Charged to memcg /
> 
> Looks nice to me.  I have just trivial cosmetic comments below.
> 
>>
>> Print mode significantly reduces output size while preserving all
>> other page allocation information. The correspondence between handles
>> and stack traces can be obtained through the show_stacks_handles interface.
> 
> I understand the mode was introduced for the stack handle mode, but it exists
> for both full stack and stack handle mode?  The wording makes me assume the
> mode is only enabled vs disabled (boolean).  It is true that there are only two
> modes, but I feel like this commit message might better written.
> 

The commit message could be clearer.

>>
>> Link: https://lore.kernel.org/linux-mm/20260417154638.22370-3-zhen.ni@easystack.cn/
> 
> Seems this is a link to v1 of this patch.  I think adding the context or moving
> this to the changelog [1] with the brief context explanation would be nice.
> 
Good suggestion.

>> Suggested-by: Zi Yan <ziy@nvidia.com>
>> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
>> ---
>>
>> Changes in v2:
>> - Renamed from 'compact mode' to 'print_mode' for better clarity
>> - Use enum values (0=full_stack, 1=stack_handle) instead of boolean
>> - Update debugfs filename from 'compact' to 'print_mode'
>>
>> Changes in v3:
>> - No code changes
>> ---
>>   mm/page_owner.c | 28 +++++++++++++++++++++++++++-
>>   1 file changed, 27 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/page_owner.c b/mm/page_owner.c
>> index 5884d883837e..6d87b6948cfa 100644
>> --- a/mm/page_owner.c
>> +++ b/mm/page_owner.c
>> @@ -590,7 +590,13 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
>>   			migratetype_names[pageblock_mt],
>>   			&page->flags);
>>   
>> -	ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
>> +	/* Print mode: full stack or stack handle */
> 
> I think this comment should be useful if it was compact_mode.  But because now
> it is called print_mode and values have good names that self explaining what
> the mode is, I'm not sure if this comment is really needed.
> 

I'll remove the redundant comment

>> +	if (READ_ONCE(owner_filter.print_mode) == PAGE_OWNER_PRINT_STACK_HANDLE) {
>> +		ret += scnprintf(kbuf + ret, count - ret,
>> +				"handle: %d\n", handle);
>> +	} else {
>> +		ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
>> +	}
> 
> Braces are not needed [2] here?
> 
I'll remove the unnecessary braces

Thanks for the detailed review
>>   	if (ret >= count)
>>   		goto err;
>>   
>> @@ -985,6 +991,24 @@ static int page_owner_threshold_set(void *data, u64 val)
>>   DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
>>   			&page_owner_threshold_set, "%llu");
>>   
>> +static int page_owner_print_mode_get(void *data, u64 *val)
>> +{
>> +	*val = READ_ONCE(owner_filter.print_mode);
>> +	return 0;
>> +}
>> +
>> +static int page_owner_print_mode_set(void *data, u64 val)
>> +{
>> +	if (val > PAGE_OWNER_PRINT_STACK_HANDLE)
>> +		return -EINVAL;
>> +	WRITE_ONCE(owner_filter.print_mode, val);
>> +	return 0;
>> +}
>> +
>> +DEFINE_SIMPLE_ATTRIBUTE(page_owner_print_mode_fops,
>> +			&page_owner_print_mode_get,
>> +			&page_owner_print_mode_set, "%lld");
>> +
>>   
>>   static int __init pageowner_init(void)
>>   {
>> @@ -998,6 +1022,8 @@ static int __init pageowner_init(void)
>>   	debugfs_create_file("page_owner", 0400, NULL, NULL, &page_owner_fops);
>>   
>>   	filter_dir = debugfs_create_dir("page_owner_filter", NULL);
>> +	debugfs_create_file("print_mode", 0600, filter_dir, NULL,
>> +			    &page_owner_print_mode_fops);
>>   
>>   	dir = debugfs_create_dir("page_owner_stacks", NULL);
>>   	debugfs_create_file("show_stacks", 0400, dir,
>> -- 
>> 2.20.1
> 
> [1] https://docs.kernel.org/process/submitting-patches.html#commentary
> [2] https://docs.kernel.org/process/coding-style.html#placing-braces-and-spaces
> 
> 
> Thanks,
> SJ
> 
> 
Best regards,
Zhen Ni

