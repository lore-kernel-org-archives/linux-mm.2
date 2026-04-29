Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F117EFF8877
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 11:42:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2855B6B0088; Wed, 29 Apr 2026 07:42:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25CE46B008A; Wed, 29 Apr 2026 07:42:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 199E16B008C; Wed, 29 Apr 2026 07:42:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 09D026B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 07:42:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 98990140192
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:42:12 +0000 (UTC)
X-FDA: 84711404904.03.54E12A4
Received: from mail-m82106.xmail.ntesmail.com (mail-m82106.xmail.ntesmail.com [156.224.82.106])
	by imf09.hostedemail.com (Postfix) with ESMTP id B55FF140005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:42:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf09.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.106 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777462930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zKkpAaY7BGKxIMBxmKpzOHwl6zOLLv6Q3FoqlINQN9I=;
	b=KoNd8cWXi4yLzSI6lZ34TAZSbt3gp9vAckDnHK0ViiVdtqrRy3FKtR0ALIZvVkUSOv0oJN
	wYDosAqB7B8xBwIrzzc/fxBfB9pY3E1UQizRUHeL/DIITDMy/HMotNTTdDCdVBZbds5xzk
	zmiWxwTUrHxxhiyVh8dJ6HGsXbKlQPg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf09.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.106 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777462930; a=rsa-sha256;
	cv=none;
	b=p8RQVLvHmbQgkTVgcJiB6A0UCxo6TL6fKqblp0SqDPYQK/0dQMvmSrgk6MGYLKJo6w+lGP
	4mlsQTL+qf20l2AJIHVNoi7FMYHGXxNklseNXPZnNsC47Md3rA5eYU780zAvP7mWaQ6iPd
	SsVVnA8wWVB0cK40OQ/1cYVVUauUiDA=
Received: from [192.168.0.18] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 198bcccc8;
	Wed, 29 Apr 2026 19:42:05 +0800 (GMT+08:00)
Message-ID: <38340de6-c729-4b04-a42b-36cbd6585c9c@easystack.cn>
Date: Wed, 29 Apr 2026 19:42:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm/page_owner: add print_mode filter
To: Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260419155540.376847-1-zhen.ni@easystack.cn>
 <20260419155540.376847-3-zhen.ni@easystack.cn>
 <41EDDEC1-9BAB-447D-AAB0-B8B22289F19C@nvidia.com>
 <0f9e11c8-743e-45be-8fbc-ea81d7592ae3@easystack.cn>
 <CBB2A60B-7491-4D93-89B8-941832DD0478@nvidia.com>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <CBB2A60B-7491-4D93-89B8-941832DD0478@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9dd90bd68c0229kunm5e0ad9c11bc427
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaThpCVhlNSkkaTUoeGU0fSVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVCQk
	lOS1VKS0tVSkJLQlkG
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B55FF140005
X-Rspam-User: 
X-Stat-Signature: etxmridombbiw5d5siwodms36razw8cz
X-HE-Tag: 1777462929-417798
X-HE-Meta: U2FsdGVkX1+OFMJ4J4wlVRuhkbG7wr+TPEDr6xv7GL6unX3giUfjs4WUF72eOxTgrTOOTSgrOAnc8+IBshZ7eLZs1TSr7RIPbUPKS591Mp0sjIRPymOJVL85nrsIw0f51eg1UKFbHFPvk7Ya6H/JNi3vGroKECovpLLT1KHYb51NJAYF0MbVsFHgb9HrRQcTEJKFpfvOllXpZGEIja1eXmjDlK7cDF9rNG+IDA9CoVVkkCyWeD6+2s/blY79tCG1jRuisbvEFJTEzuPT9FxW+dZWhuh/vpIPg/+d1N04tgjPOgSKrPkjKs3wRQOLfF6z0VXMYxU0oC8lFDvoMIchg3iDFsBRRo3MlPMCrRIz1UyZLW88by14oUbR+2NvPT95wxOgaXuvo3xe7N625yOAMpZK9YQjbfMZBMvgxmqYOx+iQdZgV/det6Jm3AE0S/mcJfi4dfWuedbwhCJ7/fMKvrYT2QgDMx23bEeQ7dkTNluhinUycyC8YF+4UAC4eg77if4TvWjHTPifPT3A5v45io2ohGfw1iDAilDWMQtD8RXbxv7A3an6YSmH8QJMnT63CimOnGfvt7SlqXGlxuENmN035wBi0DGbBpUGIOR4PB5i57n6rLZ9m52H+sBy12+KCgQCgvcJdek3pErhhb2mb4tAa1imwDp2uoKac7awenlvr7iCJdpGdw+JDniN0NlNIpQI2eoQNXqVYUw5u8+EJJMvhPZF7fllV5Vp/IC6zy7WLTY9/b/yORzkfBOo6FmT4EA90LqMLmIhtkdurbk8EOBy6kBlnPR7IlGWKcG71RbcKM0EwYZbjo421w3g5KS6q9cW3I2344MEUDzuqFsDGmKowTMwbmBltKjzpLLA6SJy1+nVGq/ZkRoDUxFBubQc4cm3Rl3wxfSaqufp9RKfFFcjHrQxfdn+KpLCDTJMosu03Sx3TSqmTAUgKExr84Jk5skVtHCZTsZYZTK5nv0
 kV3L6h4p
 pElnUejTTf0m3bE2aKWcsH+y+tzyrqZLAdrUfh3jJV2vF6k2Tpdmb43bjnOll5D6kppMtpyv9SOfEnCv7/1hNmmzB2Y3hRhZaIcszEdkeMoe2OaTqGnYJjIsu8Qo4PyvqZ1xItDne+HwXATnfR+YaWQdCP9fGun5bu9thvLjTJkkZackRZg1EdTCITbHp009Xe9FbBrZ9J4vzryA4RVsEL6uAXfnuiJ4OaxPI6oQiXny5bUtWKDVOe4sQOFh/eL0GK5TRzsgJ93ek++w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/4/28 21:20, Zi Yan 写道:
> On 27 Apr 2026, at 23:36, zhen.ni wrote:
> 
>> 在 2026/4/27 23:43, Zi Yan 写道:
>>> On 19 Apr 2026, at 11:55, Zhen Ni wrote:
>>>
>>>> Add print_mode functionality to reduce page_owner output size by
>>>> printing only the stack handle instead of the full stack trace.
>>>>
>>>> Example output with print_mode enabled:
>>>>     Page allocated via order 0, mask 0x42800(GFP_NOWAIT|__GFP_COMP),
>>>>     pid 1, tgid 1 (systemd), ts 349667370 ns
>>>>     PFN 0xa00a2 type Unmovable Block 1280 type Unmovable
>>>>     Flags 0x33fffe0000004124(referenced|lru|active|private|node=3|zone=0|
>>>> lastcpupid=0x1ffff)
>>>>     handle: 17432583
>>>>     Charged to memcg /
>>>>
>>>> Print mode significantly reduces output size while preserving all
>>>> other page allocation information. The correspondence between handles
>>>> and stack traces can be obtained through the show_stacks_handles interface.
>>>>
>>>> Link: https://lore.kernel.org/linux-mm/20260417154638.22370-3-zhen.ni@easystack.cn/
>>>> Suggested-by: Zi Yan <ziy@nvidia.com>
>>>> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
>>>> ---
>>>>
>>>> Changes in v2:
>>>> - Renamed from 'compact mode' to 'print_mode' for better clarity
>>>> - Use enum values (0=full_stack, 1=stack_handle) instead of boolean
>>>> - Update debugfs filename from 'compact' to 'print_mode'
>>>> ---
>>>>    mm/page_owner.c | 28 +++++++++++++++++++++++++++-
>>>>    1 file changed, 27 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/mm/page_owner.c b/mm/page_owner.c
>>>> index 5884d883837e..6d87b6948cfa 100644
>>>> --- a/mm/page_owner.c
>>>> +++ b/mm/page_owner.c
>>>> @@ -590,7 +590,13 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
>>>>    			migratetype_names[pageblock_mt],
>>>>    			&page->flags);
>>>>
>>>> -	ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
>>>> +	/* Print mode: full stack or stack handle */
>>>> +	if (READ_ONCE(owner_filter.print_mode) == PAGE_OWNER_PRINT_STACK_HANDLE) {
>>>> +		ret += scnprintf(kbuf + ret, count - ret,
>>>> +				"handle: %d\n", handle);
>>>> +	} else {
>>>> +		ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
>>>> +	}
>>>>    	if (ret >= count)
>>>>    		goto err;
>>>>
>>>> @@ -985,6 +991,24 @@ static int page_owner_threshold_set(void *data, u64 val)
>>>>    DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
>>>>    			&page_owner_threshold_set, "%llu");
>>>>
>>>> +static int page_owner_print_mode_get(void *data, u64 *val)
>>>> +{
>>>> +	*val = READ_ONCE(owner_filter.print_mode);
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static int page_owner_print_mode_set(void *data, u64 val)
>>>> +{
>>>> +	if (val > PAGE_OWNER_PRINT_STACK_HANDLE)
>>>> +		return -EINVAL;
>>>> +	WRITE_ONCE(owner_filter.print_mode, val);
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +DEFINE_SIMPLE_ATTRIBUTE(page_owner_print_mode_fops,
>>>> +			&page_owner_print_mode_get,
>>>> +			&page_owner_print_mode_set, "%lld");
>>>> +
>>>>
>>>>    static int __init pageowner_init(void)
>>>>    {
>>>> @@ -998,6 +1022,8 @@ static int __init pageowner_init(void)
>>>>    	debugfs_create_file("page_owner", 0400, NULL, NULL, &page_owner_fops);
>>>>
>>>>    	filter_dir = debugfs_create_dir("page_owner_filter", NULL);
>>>> +	debugfs_create_file("print_mode", 0600, filter_dir, NULL,
>>>> +			    &page_owner_print_mode_fops);
>>>>
>>>>    	dir = debugfs_create_dir("page_owner_stacks", NULL);
>>>>    	debugfs_create_file("show_stacks", 0400, dir,
>>>> -- 
>>>> 2.20.1
>>>
>>> I think it is more user-friendly to use “full_stack” and “stack_handle”
>>> instead of 0 and 1. You can refer to [1] to sysfs_match_string() to
>>> do that. I was testing the interface, but needed to look at your code
>>> to know which print_mode I am using. ;)
>>>
>>>
>>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/tree/mm/huge_memory.c?h=mm-everything#n380
>>>
>>>
>>
>> Thanks for the suggestion!
>>
>> I considered using "full_stack" and "stack_handle" strings, but
>> I think the numeric values (0/1) are more concise and easier to type
>> for users.
> 
> I disagree. It is hard for user to know what the current print mode
> is and what available modes are. 0 or 1 is usually for boolean input.
> 
> Something like:
> [full_stack] stack_handle
> full_stack [stack_handle]
> 
> is much easier for user to read and use.
> 
The string-based interface is more user-friendly

I'll switch to using string values "full_stack" and "stack_handle"
with sysfs_match_string() in v4, implementing the show function to
  display them with [] brackets around the current selection.
>>
>> The v3 documentation will clarify the meaning:
>> - 0 (default): Print full stack traces
>> - 1: Print only stack handles
>>
>> Do you think this is sufficient, or would you still prefer using
>> string values instead?
>>
>>
>>> Best Regards,
>>> Yan, Zi
>>>
>>>
>> Best regards,
>> Zhen
> 
> 
> Best Regards,
> Yan, Zi
> 
> 
Best regards,
Zhen

