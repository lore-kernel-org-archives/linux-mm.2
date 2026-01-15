Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52CEDD41158
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 10:07:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93E3C6B008A; Thu, 15 Jan 2026 05:07:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EB3F6B0092; Thu, 15 Jan 2026 05:07:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 822286B0098; Thu, 15 Jan 2026 05:07:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 735A26B008A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 05:07:02 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AEC781602AF
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:07:01 +0000 (UTC)
X-FDA: 84333769842.19.080A654
Received: from sgoci-sdnproxy-4.icoremail.net (sgoci-sdnproxy-4.icoremail.net [129.150.39.64])
	by imf21.hostedemail.com (Postfix) with ESMTP id 12EE11C000B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:06:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of cuichao1753@phytium.com.cn designates 129.150.39.64 as permitted sender) smtp.mailfrom=cuichao1753@phytium.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768471620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NIi6WkID40hmPs+fzjfqtwVUhSv+uj6waVW368OgFTY=;
	b=dc5x43evE7m2ARiXCxOGOV2DGJu6m9TzF2A+XyhbhUKG3G/BX9u0/vIvtpji306UnLbbrc
	MAkKooRCGA8LzhHkm2EHXuif9sDaLOaZM/dd5zIcBc8BsZG6uvVkZcxJePuKS4zBrGwFRF
	pIC91may6XTUecdvKFd4v68QEVjQGsE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of cuichao1753@phytium.com.cn designates 129.150.39.64 as permitted sender) smtp.mailfrom=cuichao1753@phytium.com.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768471620; a=rsa-sha256;
	cv=none;
	b=pFV3NlUdXsrmVXzq2arKr7g0+9QrPpfYemiOvb7HogSV00RpXrdjXW5jNmF+vkdGVPZro5
	f8UQQJ0HOtQGbvh8uwMasZB3KgwMFvm8Ys3Y9rzQbUzgPLheHo0PtlbhxTXMQNL2B+QHXg
	7oXKd8js44A6Ft7Is4XpiBePLQbu2aE=
Received: from prodtpl.icoremail.net (unknown [10.12.1.20])
	by hzbj-icmmx-6 (Coremail) with SMTP id AQAAfwA3PSU4vGhpz1wiAw--.3171S2;
	Thu, 15 Jan 2026 18:06:48 +0800 (CST)
Received: from [10.22.77.56] (unknown [123.150.8.50])
	by mail (Coremail) with SMTP id AQAAfwCH3us1vGhpfdsTAA--.20387S2;
	Thu, 15 Jan 2026 18:06:46 +0800 (CST)
Message-ID: <0e1e1b5f-df0c-459d-9cba-5bde5ad56ba3@phytium.com.cn>
Date: Thu, 15 Jan 2026 18:06:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm: numa_memblks: Identify the accurate NUMA ID of
 CFMW
To: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
Cc: Wang Yinfeng <wangyinfeng@phytium.com.cn>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 Mike Rapoport <rppt@kernel.org>
References: <20260106031042.1606729-2-cuichao1753@phytium.com.cn>
 <CALzOmR2z0noh74aCAd=QVUBgdn7Q+Hbevs-cr1EtV_zXCuQ=PA@mail.gmail.com>
From: Cui Chao <cuichao1753@phytium.com.cn>
In-Reply-To: <CALzOmR2z0noh74aCAd=QVUBgdn7Q+Hbevs-cr1EtV_zXCuQ=PA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAfwCH3us1vGhpfdsTAA--.20387S2
X-CM-SenderInfo: pfxlux1drrlkut6sx5pwlxzhxfrphubq/1tbiAQAQAGln+JMEtAABsF
X-Coremail-Antispam: 1Uk129KBjvJXoWxuryfJrW8tFW5try5tr4fXwb_yoW5XF47pF
	1aqa9YgF4kJr1xGFs293WUAw1IqFsa9F45XFZrCrnxZa1Ygr15Zryaqr1F9F1ktrWrCF1F
	qF4Dt3WYvw1UZaDanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
	DUYxn0WfASr-VFAU7a7-sFnT9fnUUIcSsGvfJ3UbIYCTnIWIevJa73UjIFyTuYvj4RJUUU
	UUUUU
X-Rspamd-Queue-Id: 12EE11C000B
X-Stat-Signature: bda9hwmth4sghxut3f8szafy9skmo899
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768471616-886784
X-HE-Meta: U2FsdGVkX19m8AOx8kWITRTCNpCIZqo5mIUO3YHHHH4bmFsqoHyfHeh4Rl/q8rWSYR2KikCmFGyTQHu0WBl0rrpAIY4N5ZOnEvLjVhpFPEv7m85Pxkbn9wD/y25z31eUBTodTfLAMoi9SBf1HHDGrHcH9p6/TcRUDixEK2ZO3YUoVlSEo85ODOxUTvfa1wIfi4dUv6q2Rc/4h3YkZchxLh4/J6f6UrVfj5D9a8BaKuP0xiuKt6FKEg9yxN150wcAxQ24BPa1EeY68dHosWE3xjJtyxeL/KP1a5sXxDW+coH/2lExfMilrirwm8FqqGblyHySmAjSWV44Mx6wIOKvCD0YLYF3dVh2C4oBktHKthoc/845kFshw+7GOOUOEfn1fHsiIpzMKpoYJYm9nDOTYP4TWtc3ARc2EI7QvwdAE5y6Pw6XfuZ2GalE0Wtr01DpM3kWXR/dcNFPTaKvmjUXZcMO6QorqNqX7HHCbHKyXTO1W872DsNaTO++Eo+FjX4TYCwUusyZ7fKogH3ib7wdJ1hywQeDoq+jhmY1qKdG+Wj69S8QksTQtMUmdpSYfhyxZj5U2wUAZNZyfDfzNA5E0NrpwkvqJ91EC/Z6vHz8UJhmroqFDEw2p2I6vR6Q/snqEe80/dNX7o9otRISBV3nrWcvVFddCw99x7tY3Nid4w+ld761IuiU6pN8m7M7pWqY053+7MdQ0SNQsKBng0hjyVf1qbZUu9Msa2ult0n/ASyBo+328eLQ4icoaILvjAUoiSWmnFdPj0NRwwkQzJLmuoSe9ehsTPHUoUiDDxRYfpNjmu4e6uPhkaGotrUhNkwzaBtJYPJLCjoCPsqkCQA9lkpVpzvyypTpnRGeiY1CdkfVxs6f5GwXykzK4xs6IqyxWT+F5oWyI7E7LIv7DMBBOqe6fjjORAmmznkxu1c//dJ5cOK8lf3X2aHDCykMZk8melu+mqUgwAQSE1OJgdC
 4nbl3bkM
 SoN381ExYWxgS2r6F21y6prfrj+iiSupmmpQ9rk9BxNT+h4yI3puekk1ZzS6twkmugvg8yLPAZML1FXMB4Xd3LYFRSQ/nOnTqHR+y1QRZLFvzA4KnsRme+a1e77atRYMu2yKIQiHTsIis7l+GgoWHYJ2srStrQM8k5AZMf8lYqxyfxuxph53UT0KH19Ua0Wu5YhWCCnLtm63UJMp3/VyyeQcOVA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 1/9/2026 5:35 PM, Pratyush Brahma wrote:
> On Fri, Jan 9, 2026 at 12:44 PM Cui Chao <cuichao1753@phytium.com.cn> wrote:
>> In some physical memory layout designs, the address space of CFMW
>> resides between multiple segments of system memory belonging to
>> the same NUMA node. In numa_cleanup_meminfo, these multiple segments
>> of system memory are merged into a larger numa_memblk. When
>> identifying which NUMA node the CFMW belongs to, it may be incorrectly
>> assigned to the NUMA node of the merged system memory.
>>
>> Example memory layout:
>>
>> Physical address space:
>>      0x00000000 - 0x1FFFFFFF  System RAM (node0)
>>      0x20000000 - 0x2FFFFFFF  CXL CFMW (node2)
>>      0x40000000 - 0x5FFFFFFF  System RAM (node0)
>>      0x60000000 - 0x7FFFFFFF  System RAM (node1)
>>
>> After numa_cleanup_meminfo, the two node0 segments are merged into one:
>>      0x00000000 - 0x5FFFFFFF  System RAM (node0) // CFMW is inside the range
>>      0x60000000 - 0x7FFFFFFF  System RAM (node1)
>>
>> So the CFMW (0x20000000-0x2FFFFFFF) will be incorrectly assigned to node0.
>>
>> To address this scenario, accurately identifying the correct NUMA node
>> can be achieved by checking whether the region belongs to both
>> numa_meminfo and numa_reserved_meminfo.
>>
>> Signed-off-by: Cui Chao <cuichao1753@phytium.com.cn>
>> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>> ---
>>   mm/numa_memblks.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
>> index 5b009a9cd8b4..e91908ed8661 100644
>> --- a/mm/numa_memblks.c
>> +++ b/mm/numa_memblks.c
>> @@ -568,15 +568,16 @@ static int meminfo_to_nid(struct numa_meminfo *mi, u64 start)
>>   int phys_to_target_node(u64 start)
>>   {
>>          int nid = meminfo_to_nid(&numa_meminfo, start);
>> +       int reserved_nid = meminfo_to_nid(&numa_reserved_meminfo, start);
>>
>>          /*
>>           * Prefer online nodes, but if reserved memory might be
>>           * hot-added continue the search with reserved ranges.
> It would be good to change this comment as well. With the new logic
> you’re not just "continuing the search", you’re explicitly preferring
> reserved on overlap.
> Probably something like "Prefer numa_meminfo unless the address is
> also described by reserved ranges, in which case use the reserved
> nid."

Thanks.

I will revise the next version according to your suggestion.

>>           */
>> -       if (nid != NUMA_NO_NODE)
>> +       if (nid != NUMA_NO_NODE && reserved_nid == NUMA_NO_NODE)
>>                  return nid;
>>
>> -       return meminfo_to_nid(&numa_reserved_meminfo, start);
>> +       return reserved_nid;
>>   }
>>   EXPORT_SYMBOL_GPL(phys_to_target_node);
>>
>> --
>> 2.33.0
>>
-- 
Best regards,
Cui Chao.


