Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5E38106F313
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:32:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E955B6B0005; Thu, 26 Mar 2026 05:32:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E468B6B0088; Thu, 26 Mar 2026 05:32:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5C3C6B0089; Thu, 26 Mar 2026 05:32:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C26606B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:32:52 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 670E913BA7B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:32:52 +0000 (UTC)
X-FDA: 84587699784.10.C0E1990
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5FD17A0016
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:32:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bN8UNULu;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774517570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4d2w+IeZPzwZNFXrmkaVTUOd7na0i876whNwb8z2LsQ=;
	b=vfnycalHiyy/aKFJr7/wutz7+MianoTKBDo55FKVJP0IJY86jEhPMv3dEGt/raMIKqDtBr
	zvSHs4cZhydtwOon33pBtgQ489FzGc1OY0VLRQfb3PQaMKSejMq3ONWSi+5IxB9o0vVqdk
	lVOs2CrKLh90ovJGt1I6dO7QsrhTkmU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bN8UNULu;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774517570; a=rsa-sha256;
	cv=none;
	b=0nogAu+76CdzSW+cJvNg4XlCVenWqCyB9BrfuAdQw8OGqVF1bFkvAYz1dDGFPrpREAp1NB
	Y1tUB7Y+GGNvaNPm9jfF+ayfNw6d9AA0Qq93SyyZ1yVMLQxEluzgjJXehV3eeEsNtGQ+Xz
	en52dEO6IarXy9Q4dn0JIQO0CjE+BUc=
Message-ID: <b6462703-9744-409e-a770-b9a7ca5fa198@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774517568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4d2w+IeZPzwZNFXrmkaVTUOd7na0i876whNwb8z2LsQ=;
	b=bN8UNULujNhHQBCVz4SA0OwyjaGrwe0iL1C0peTLVX+hycckQpi62AVvS17PU5ZNIOl1Wp
	f1e9/3rI4CWB9wCJnkOfeTEXR+ZoEZ7am3x/Mku/X5r4FnRvVTP+rPBHMMLPOFxZMrKDgt
	+HAxna2jMQZbViYwsmwsKcKAc4DZrtw=
Date: Thu, 26 Mar 2026 17:32:05 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 4/4] mm: memcontrol: fix unexpected massive positive
 number in memcg_state_val_in_pages()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, akpm@linux-foundation.org
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, ziy@nvidia.com, harry.yoo@oracle.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 "Harry Yoo (Oracle)" <harry@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1774447069.git.zhengqi.arch@bytedance.com>
 <e19052a28a7b604c012bfdfc900fd09543976284.1774447069.git.zhengqi.arch@bytedance.com>
 <54c2b09c-84f8-4118-96a6-acc13ca2f245@lucifer.local>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <54c2b09c-84f8-4118-96a6-acc13ca2f245@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: 6m9kaok5wsef4y3opx1ykbbrb9y53a8s
X-Rspamd-Queue-Id: 5FD17A0016
X-Rspamd-Server: rspam09
X-HE-Tag: 1774517570-330928
X-HE-Meta: U2FsdGVkX1/Wm3xG4Jh6/hgJ1gWuS5TY/USKKuUw1modIlbuk62DZ3YMYb7/iNQPgC1hXiIB+DVnIXANjcYVMNeIsWqjtk05XZ8YzVx8B6EXLsamvyizmB7JD4YYrGKCRmbJjey1UEICJnVYFKyEnjbTqbNmiINN/EK7UCjI8PPNnV1m1WNVmaIUbWDdE0/OpiQmnOoWm7Q/jf9NVJOlG7MdPyUKyu4nmg0HwP2rGJ7f0JDLDaV1ZkTgIRhpwJn8Ki34HIboEEs89/Cn8Yz68Vt8ZgzBClfDsz22YAsvzjkcXyMoxr9xmlJJ9w339L8JwWzp0k4sl364JhDhyQ/jejczxvWTmrIVj7cb5l7GOxyasGLvo9ac5YgFgslJlbBHbN23qiVfYOMG4ubKlgPzDWzoL498+MJfItWGtlEriLMjMwQHcvlp6xszgGKeiB9xKwlt4attfublfQMQdL79zyELja9RtEuxrM0Zg+ILnh3uqcDIVObdT2XWz9DflzqtF2Tq+562/1psEoF/dOMXt9Wy6v50Vin0WAJvySHuO62hB/i8m5uXgRF/QfZqZ//WLdrGY59xc9iMo8H4Wst++MqIzPo6rcURqoWwXvpJpA3YR70JfV23wJ66fgGPPNNHH0S2AJBuPmaFRl2gG0R8Oe7kBmaZGAj7J3dnZP+E1qwZgPKgEM9ifCpthtY4HY8TBT52luy2nOq2SraPDViRzvtlQtpAYBvkA/e5oExC78+ZOqYB93bQHE+qXB/1qOCKTGZdBlPq1tjWrrU7PVVcU4B1iMYcrOVjthP+POwf3l1uqbFYRJN5gJ1pLWgIrsf6upqNTULQkdsx4/pfl4ZhVHpcnGkKSAYORWb1H8eGVeDlvVrE88l0SgCsUD2qXw+mmmhFJxutfS1J6jsEFDCHRv6n3zvICnEy5Znd0IG+jez8MgKVMvpiLYOASijNfrpxWJd99Xt9yDCZNbVrLKg
 9Bhuj0jF
 zjZBr9HnZZXKpeE45pn6VNqkE0Rey0yLd29Vjjy+2of0ZSCdjXV0lrBKDMZlGZwYYHhspnyR/K0h6fpWZdFFiuCfTj7/CZJTNKqSHrpnZPLmouRUHXsoAm24fHyKEAwIpwQYWFeV2yef+SLnUf2tBqQMCBHJfco8sGt1I9u3eQEQ/zbO2OmqrJ4t/hR40tiKSDesh8voNw8oViBKFDUMTvC4oOg8smV3eVtzmmaYHDp3NVA5RMruADwZxyyePeBOfh5nhQZeC38TGXnEyFMB06KdPv73e48UzGrzehQU7J9MLOOw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/26/26 5:16 PM, Lorenzo Stoakes (Oracle) wrote:
> On Wed, Mar 25, 2026 at 10:13:25PM +0800, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> In memcg_state_val_in_pages(), if the passed val is negative, the
>> expression val * unit / PAGE_SIZE could be implicitly converted to a
>> massive positive number when compared with 1UL in the max() macro.
>> This leads to returning an incorrect massive positive value.
>>
>> Fix this by using abs(val) to calculate the magnitude first, and then
>> restoring the sign of the value before returning the result. Additionally,
>> use mult_frac() to prevent potential overflow during the multiplication of
>> val and unit.
>>
>> Reported-by: Harry Yoo (Oracle) <harry@kernel.org>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> The logic is correct, but I think this needs rework for better
> understanding, and obviously this should be squashed into 2/4 as per
> Andrew.
> 
> With the below change applied:
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> 
>> ---
>>   mm/memcontrol.c | 7 +++++--
>>   1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 04076a139dbe3..0c249255ebefb 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -787,11 +787,14 @@ static int memcg_page_state_unit(int item);
>>   static long memcg_state_val_in_pages(int idx, long val)
>>   {
>>   	int unit = memcg_page_state_unit(idx);
>> +	long res;
>>
>>   	if (!val || unit == PAGE_SIZE)
>>   		return val;
>> -	else
>> -		return max(val * unit / PAGE_SIZE, 1UL);
> 
> Hm this was already fairly horrid, because we're comparing an unsigned long
> value of 1 vs. a ULONG_MAX - abs(val) so this was intended to make 0 -> 1UL
> but not what you'd mathematically think this was which was to make negative
> values (logically < 1) -> 1.
> 
> Of course before it was just broken and would promote (val * unit /
> PAGE_SIZE) to unsigned long first (thus massive number) and return that :)
> 
>> +
>> +	res = max(mult_frac(abs(val), unit, PAGE_SIZE), 1UL);
> 
> This is way too compressed into one line and retains the confusing
> behaviour.
> 
> Could we split this out and explain what we're doing (sign-extension,
> integer promotion and all of this stuff is confusing - so let's just accept
> that and spell it out):
> 
> 	/* Get the absolute value of (val * unit / PAGE_SIZE). */
> 	res = mult_frac(abs(val), unit, PAGE_SIZE);
> 	/* Round up zero values. */
> 	res = res ?: 1;
> 	/* Retain sign. */
> 	return val < 0 ? -res : res;
> 
> This is functionally identical, but a lot more readable, I think.

Make sense, I will update to v3.

If Andrew needs me to merge this patchset into "[PATCH v6 00/33] 
Eliminate Dying Memory Cgroup" [1], then I will develop and send v7.

[1]. 
https://lore.kernel.org/all/cover.1772711148.git.zhengqi.arch@bytedance.com/

Thanks,
Qi

> 
>> +
>> +	return val < 0 ? -res : res;
>>   }
>>
>>   #ifdef CONFIG_MEMCG_V1
>> --
>> 2.20.1
>>
> 
> Cheers, Lorenzo


