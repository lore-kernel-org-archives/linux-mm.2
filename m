Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9533FF8867
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 03:36:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5931E6B0088; Mon, 27 Apr 2026 23:36:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 543FE6B008A; Mon, 27 Apr 2026 23:36:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4596A6B008C; Mon, 27 Apr 2026 23:36:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 36A566B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 23:36:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DB01E1A03F8
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:36:37 +0000 (UTC)
X-FDA: 84706552434.16.C1CD5D5
Received: from mail-m82108.xmail.ntesmail.com (mail-m82108.xmail.ntesmail.com [156.224.82.108])
	by imf12.hostedemail.com (Postfix) with ESMTP id 548BA40008
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:36:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.108 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777347395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bIRf47FM4YMXufYG25lYKKrkjhVnziGfGs233nvXfpA=;
	b=aN8vWyGffKQt53k+wiyQSFgGKUjLVtspyB2E0n+Cpr6NOjMsn4Aq0y+wxw2+PwYooqBjL1
	bDI5mcf9d73baXA1VEP3CTqGegnw/p4dSwEhOeHuV7WygyTRcIPrGa7r0vUAjChhsXbGW/
	mTyCCU4C26ykQNCnmHdn87Lyjl+CspU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777347395; a=rsa-sha256;
	cv=none;
	b=OkXiz/fmQfZYQIl224S8yUjF9Deq99kxZTh5HiIz4Tk4Jn/T7Jg0WjSCxO8dy3g+XN2Tqa
	prq4Eg7AgLOPm7DJhf82kIXR9ztYJAgBrdhjRnvzAZNDLi6CspHGRUqS2VEC8CxIm0NpJo
	cJj21eqW8jbroOolS+n/V2N/yehEGyM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.108 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
Received: from [192.168.0.18] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 19787b531;
	Tue, 28 Apr 2026 11:36:30 +0800 (GMT+08:00)
Message-ID: <0f9e11c8-743e-45be-8fbc-ea81d7592ae3@easystack.cn>
Date: Tue, 28 Apr 2026 11:36:30 +0800
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
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <41EDDEC1-9BAB-447D-AAB0-B8B22289F19C@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9dd228ecfb0229kunm47e2a607147fff
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaH01OVk9CGEsfGRpKGEoZHlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 548BA40008
X-Stat-Signature: ety97844k59ch6bffzccip6zenk8eizx
X-Rspam-User: 
X-HE-Tag: 1777347394-434339
X-HE-Meta: U2FsdGVkX18J9Ek8wZ0Ey9KczaCVSlLyTgIM0TpBQ2IRLIp0TvzUAhMDG8B3jTf8nkX+dAJINRI+RQFfqM2GH1YfaQFleosv1qglaMQH414oWBhL3pyI297w556fp4xxggwmeu8bsS+oJ28LZ6oKDB1X9sCEIPyTAYQitEbx+rXOdg4AruccNXiddqlqoJQvpEuH6P4O/Xkk0g6/Qsq1eQQ/k1x7djvSY84o3jTQ3VYZGT3kjv9Zh8fpnZjzS5+o5BTc6HLeS3e3R7Zr9i+nuttYdzBCjZtWOsKkZaKlo633Vq3nJh34TALLcRnLKdUaK5DkseoV2EuaxI6b4/r73SQIeQRFL2eawRS7wIDSy036wFNKbadO63r8OyaMG/Qwg9F0pT519uTcY8PeQp4UT2qg9di5ii3wmWVl5V6gDdisWTK7e9TqadVFqRKmAxJ5l7r2T2/IWvf+yZpnRX4mAS2ZNtvXykVxn0ZLay0l+rMS6sGu2AtWIGSokuIzhVUpZN36EG0Ul2rvOFVdTpTNyr8LYww/qetZokrqgR5PznhDOffNZNo7lQhTt5rdvjbfNtaTp77bTGl67hVH0THMlEyU8HnRBzVL1l7oIRmtjiZGS2dXziLPqBRwGITxDG9ENmrYDwBEC7n/HI916uGAyAf1Gv478yU7Cemiro1ZBH5Xi0WwqwLmFwwJT//Uo2akLcm+O+cXj7h/M5TJKa32rlU1JC4Keg2L4Yt+lNSCRBfatw+K2Nu7Jf6HThc7Yj4zx1xw6OVYDlFI56UWYvIteMwVIjSvgH6dRg4eszMJHp/kwbUQcNGkR4Gx49NP7LyLW44HexEoUnU5wZ5hDwbkHrBFhFgv1LNNjytTZOmoG3KE+3dnjcLMlXsi35hm8HCnpj2GxjZh/LHL8z26G4R+y/KIeTsvdyaXZ6Qo8i2AZwFBclH/Hx9apGlFgHw63cGJB/ZN3Fk167pUVoJJxmR
 ycsIv1NM
 aIlCGXOEtez0Lgf5vYnovtj1GYmv2u7FuDTvYl57VrvVrprsYkzGdzqpRij3AYOvW/qyjeAW8l/JDQgkhkxyAO6XIVgQRyLUT7UWkKQoKtsBZl1bJOTBwIVOGUOkyeoJesxer+Wd/4f16afedHIe7f+rsARIVOIX1oUZsSowWwSV+ivqvVrXuaoQrk6Ou7u4xEWowKEO5pMiZMP2oUmlhNW+2FdvMHllh4qoA3yfVLHSqFxA2UjqBzN+HS80gGOMbJ+jnZcO1+75b74A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/4/27 23:43, Zi Yan 写道:
> On 19 Apr 2026, at 11:55, Zhen Ni wrote:
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
>>
>> Print mode significantly reduces output size while preserving all
>> other page allocation information. The correspondence between handles
>> and stack traces can be obtained through the show_stacks_handles interface.
>>
>> Link: https://lore.kernel.org/linux-mm/20260417154638.22370-3-zhen.ni@easystack.cn/
>> Suggested-by: Zi Yan <ziy@nvidia.com>
>> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
>> ---
>>
>> Changes in v2:
>> - Renamed from 'compact mode' to 'print_mode' for better clarity
>> - Use enum values (0=full_stack, 1=stack_handle) instead of boolean
>> - Update debugfs filename from 'compact' to 'print_mode'
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
>> +	if (READ_ONCE(owner_filter.print_mode) == PAGE_OWNER_PRINT_STACK_HANDLE) {
>> +		ret += scnprintf(kbuf + ret, count - ret,
>> +				"handle: %d\n", handle);
>> +	} else {
>> +		ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
>> +	}
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
> I think it is more user-friendly to use “full_stack” and “stack_handle”
> instead of 0 and 1. You can refer to [1] to sysfs_match_string() to
> do that. I was testing the interface, but needed to look at your code
> to know which print_mode I am using. ;)
> 
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/tree/mm/huge_memory.c?h=mm-everything#n380
> 
> 

Thanks for the suggestion!

I considered using "full_stack" and "stack_handle" strings, but
I think the numeric values (0/1) are more concise and easier to type
for users.

The v3 documentation will clarify the meaning:
- 0 (default): Print full stack traces
- 1: Print only stack handles

Do you think this is sufficient, or would you still prefer using
string values instead?


> Best Regards,
> Yan, Zi
> 
> 
Best regards,
Zhen

