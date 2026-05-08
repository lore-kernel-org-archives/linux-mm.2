Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4FC4CD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 10:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C92196B0135; Fri,  8 May 2026 06:00:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C433F6B0136; Fri,  8 May 2026 06:00:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B80066B0137; Fri,  8 May 2026 06:00:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A3DF66B0135
	for <linux-mm@kvack.org>; Fri,  8 May 2026 06:00:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 329181A07C7
	for <linux-mm@kvack.org>; Fri,  8 May 2026 10:00:33 +0000 (UTC)
X-FDA: 84743807946.15.21CA3D1
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id 19AEE1C0011
	for <linux-mm@kvack.org>; Fri,  8 May 2026 10:00:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778234431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kbjWhfd5qh05gn1Jgx+24sTJ0hW4Weqnw39sEtJutSg=;
	b=3X4zjIQqz+KgQdmNMWmDvdQiJslvQc78IU0t9ENFIPCiY6G011T4lyw6UEhiPLUnw73V7o
	LQcJL7dhJkINLqxQqlXroY4FieUySdVo4yOQSyc3tWae8jYcgMQkHha+bUE7s7gT8DTa5F
	3qYYMOv+oSLBlLe/GcUBXu3AAvrgQAo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778234431; a=rsa-sha256;
	cv=none;
	b=orUkCznpqwpH2ASi8r5zr/+0sOV5beAf161k1f/VxuopVWIck3AsZCj+T1aCwt0qJum1Wn
	MiOmaX5KnkLwtLppYjX1gXCn6Z0FXLauwi8soq1llXQCJ5nUd0+mtRNLV3XmWLpEQIRGBu
	284w+FCM2kEhinxVmuVd1RxDPWtnf6E=
Message-ID: <441c25a9-0993-4fd9-9932-948321974c00@linux.dev>
Date: Fri, 8 May 2026 17:59:39 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/balloon: expose per-node balloon pages in node meminfo
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, virtualization@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260508015316.25722-1-hao.ge@linux.dev>
 <731d7324-4eb7-44d2-bb7d-62b6fbe11c52@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <731d7324-4eb7-44d2-bb7d-62b6fbe11c52@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: p7796z7crg54qpiy6bx3t1w44gedy4mg
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 19AEE1C0011
X-Rspam-User: 
X-HE-Tag: 1778234430-584525
X-HE-Meta: U2FsdGVkX18im/EVNWs7ykQkyLFvrW2r64ieETUr2FD1HTTqDYWKuCwNq2JU1MTkzw02xKz8+wBqtaKFFAqtuVIlRylgamT0n3EPkE555Rx12rflmZ6gHpRnVdxshNAOYy85vexxCmDo1gP759Psu3fnjf6NA4+2XIf3Fbl5TrHkzeGln2aYbId7yha+s1ir/RcnGeqP/A4hOM0qzPUV9tYcBoeGjMm/wpy0vI1PNAsxHNJib1AqnFim2zhgIdi4TFzhk9Ny4i6ytwpED4JSOJk+qnBiPIH43ELLoq13G6fz/gG6srZ2nc03/177/Hne5BDsB6AdQQKfAJeiOGN2ej5GcfRMMxSP05gb2H85hvY6WsUR3zjycLe8Q0cacI+lkJA4cTrkm7EKFIETY+zrE0bo0PomWYs4B8rOWEI62zfcfAQlA4slU2nrz48x1DDlFWr+qD4vH+UX8EtJf0+/mq3lpYvq8/1sfbAxcy3h/TFnsQGWQc+FiohjFM+YVofxqAF6KbdENHx5WSWGAxpMfKe8kRHcSk3p9mS/bOz6LYq86uQHHs47S6yGnhB2vBL1MP/l3sYWfQWSK4R5QywQsLJXoZSmr44v8jmJtGW7LcbulJcQRzFVc+BriW3bTD/DlkCslF5wrLldCuwSYN2uMmHTAIIw7tS+CXIKwFkocJfABFU9Blbr1rbIcGiJTN2G1m2jqAfSuadw56Uu3F/8tWJ7jESQ8qvurd3BRynlzmKICZn11uflAEyoOBlan5dEIXcdEnCUr2FLmG/Bofq7qf5Ma1juY25VqxdhXGGpKYxrA9Ktpqvh3P+rrVPE22mwPL4xL168DxbGVHFxrFthv8px7Fnv3bfGkYTIXhh2bpXky4zxlYtRfI934Z4zjOZoDC4rU60RU6LujbWL0bYSVEOMRFnjE6VD8rNiby/6f8uOZrfQYgl/Tg80jFBn62JIjXMVqQNdFpNT4rw/yq0
 0iju/ttf
 0sF3HylqB4q0N4lNXmBVz7DNI8Dw77w3KhU0e3KULAMhxPIlpO/kASFpmUHFLTyLmcyP9JXy13Ag6gSAcgWF4mA0k56IQqwHdrGtWn84eEVIVD8Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David


On 2026/5/8 16:23, David Hildenbrand (Arm) wrote:
> On 5/8/26 03:53, Hao Ge wrote:
>> Commit 835de37603ef ("meminfo: add a per node counter for balloon
>> drivers") added NR_BALLOON_PAGES and exposed it in /proc/meminfo.
>> However, the per-node view at /sys/devices/system/node/nodeX/meminfo
>> was not updated, even though the counter is already tracked per-node.
>>
>> Add it to node_read_meminfo() so users can see balloon usage per
>> NUMA node without having to parse the raw vmstat file.
> Using ballooning with vNUMA is rather rare. But sure, why not.

Yeah, it's indeed not common.

We came across this while analyzing a customer's 16C 32G VM with 2 vNUMA 
nodes and balloon enabled.


>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>> ---
>>   drivers/base/node.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/base/node.c b/drivers/base/node.c
>> index d7647d077b66..53f4e51d6d82 100644
>> --- a/drivers/base/node.c
>> +++ b/drivers/base/node.c
>> @@ -513,6 +513,7 @@ static ssize_t node_read_meminfo(struct device *dev,
>>   			     "Node %d Slab:           %8lu kB\n"
>>   			     "Node %d SReclaimable:   %8lu kB\n"
>>   			     "Node %d SUnreclaim:     %8lu kB\n"
>> +			     "Node %d Balloon:        %8lu kB\n"
>>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>   			     "Node %d AnonHugePages:  %8lu kB\n"
>>   			     "Node %d ShmemHugePages: %8lu kB\n"
>> @@ -543,7 +544,8 @@ static ssize_t node_read_meminfo(struct device *dev,
>>   				    node_page_state(pgdat, NR_KERNEL_MISC_RECLAIMABLE)),
>>   			     nid, K(sreclaimable + sunreclaimable),
>>   			     nid, K(sreclaimable),
>> -			     nid, K(sunreclaimable)
>> +			     nid, K(sunreclaimable),
>> +			     nid, K(node_page_state(pgdat, NR_BALLOON_PAGES))
>>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>   			     ,
>>   			     nid, K(node_page_state(pgdat, NR_ANON_THPS)),
>
> Shouldn't it be placed under "Unaccepted:", just like for /proc/meminfo?
>
Good catch, thanks. I overlooked this detail -- will fix in v2.

Thanks

Best Regards

Hao


