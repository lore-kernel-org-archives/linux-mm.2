Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15438C2A073
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 02:38:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E6306B00CA; Sun,  4 Jan 2026 21:38:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4940F6B00CB; Sun,  4 Jan 2026 21:38:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 320C86B00CC; Sun,  4 Jan 2026 21:38:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 089496B00CA
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 21:38:47 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 80AEF161DA0
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 02:38:46 +0000 (UTC)
X-FDA: 84296352252.02.ED11303
Received: from sgoci-sdnproxy-4.icoremail.net (sgoci-sdnproxy-4.icoremail.net [129.150.39.64])
	by imf22.hostedemail.com (Postfix) with ESMTP id 77AA2C0003
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 02:38:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of cuichao1753@phytium.com.cn designates 129.150.39.64 as permitted sender) smtp.mailfrom=cuichao1753@phytium.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767580724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BG5rGKUAJHalMajXM0Z42DHfAsMQGq1+R4Pf0E/Mo4A=;
	b=rtqunLPUBRJqgNCX0bUHbaFxNzHCg0HGg5TLrPq/8qaKLcQIlVJVbzYug5+vLHoCfdRFFs
	CEwHYOdU3ZkNwizXNYtmWru0h1rZXgTXrzK4cBDuBDav0pHoYhwcY8dLHhKj1boZcjP0Si
	40QRG3f2i31H0SpGjpiWm2udel8qs8Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of cuichao1753@phytium.com.cn designates 129.150.39.64 as permitted sender) smtp.mailfrom=cuichao1753@phytium.com.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767580724; a=rsa-sha256;
	cv=none;
	b=I9hcEuSw8RrVxdhABZ9wnLbh3GQTRbzCGWo5wjwQDwprGfMMITu637nxOlrPOwNdVllBzM
	94Vhs0ITc1gN9rlpzxfp/euaGYOUrI3D9HoRjrMd7oQgmhwcZg/YKuUdcelaHYj2yuxoE2
	p6igg6QzGNyP8JtploIaBc4m/g4gACA=
Received: from prodtpl.icoremail.net (unknown [10.12.1.20])
	by hzbj-icmmx-7 (Coremail) with SMTP id AQAAfwDn7porJFtpwjFZBQ--.1345S2;
	Mon, 05 Jan 2026 10:38:35 +0800 (CST)
Received: from [10.22.77.56] (unknown [123.150.8.50])
	by mail (Coremail) with SMTP id AQAAfwCnAO4oJFtpVQIRAA--.30651S2;
	Mon, 05 Jan 2026 10:38:32 +0800 (CST)
Message-ID: <dac83ef4-6e4d-421b-bd54-7090d2f963d9@phytium.com.cn>
Date: Mon, 5 Jan 2026 10:38:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: numa_memblks: Identify the accurate NUMA ID of CFMW
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Joanthan Cameron <Jonathan.Cameron@huawei.com>, wangyinfeng@phytium.com.cn,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251230092750.856060-1-cuichao1753@phytium.com.cn>
 <aVPtSNKRnnI88Euk@kernel.org>
From: Cui Chao <cuichao1753@phytium.com.cn>
In-Reply-To: <aVPtSNKRnnI88Euk@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAfwCnAO4oJFtpVQIRAA--.30651S2
X-CM-SenderInfo: pfxlux1drrlkut6sx5pwlxzhxfrphubq/1tbiAQAFAGlZeBoChwAHsU
X-Coremail-Antispam: 1Uk129KBjvJXoW7Ww4rKw4fWF1UGrWDCF45Wrg_yoW8Kr1UpF
	4aqFWrKFW8Jr1xGFs293WUtw1Ivana9F45WFWxCrnrZ3WFqr1DZrWSqr1ruF4ktrWfCF4F
	qF4Dt3Z0qw18uaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
	DUYxn0WfASr-VFAU7a7-sFnT9fnUUIcSsGvfJ3UbIYCTnIWIevJa73UjIFyTuYvj4RJUUU
	UUUUU
X-Rspamd-Server: rspam02
X-Stat-Signature: pyngje31nagjscgh6cfr7e4h4gt51i5o
X-Rspam-User: 
X-Rspamd-Queue-Id: 77AA2C0003
X-HE-Tag: 1767580723-363380
X-HE-Meta: U2FsdGVkX19VuF/f3ZshnjlDepY3FK2/GSR54HlSjDEuRrQEI5HR8Wp9rWwHYzCGuGD0VqgJm1amsr9DgP50VRG5xz0ToBVaYClrcV4WubB4b31KHPkqXovaYe0GD+uEhzrEnkHERvouJ/cCLxvAlKaIAUzO73YLUi+xoubFKu7FYPX4WSy6bsLIZcS4VY76Sij8IuXP2xroRVld1hT8eJeG44Qtmnswwk434WX3BX1iUajce5ctuxCoo81yhMQkfBH/FKFS74bkzZTwz1IhGVYiEe0oEKGFwHmkK/wU7yhBcHr29K9PvH1QE++hrY+NbMuEkP27YSoGOE9BJ69GugYVUxwpl+qNbYRl7vtt477ZKJkffinrYmHLDS1M3iEAYS1Kd40wK+1yWTvln6a9O5e7StLGeNUVtOMYyVLMjLQVtUQN5Rc96zEN7+B4f9K/gCZdPszlsbvAnyjNFDVFf6j9MFZeoLjmLHVmAEIQ8OmnzoEoD79PY7raSiYZiEKZS7jTwNfvCuG6AJPZcb1v/KOozQI4lc6ry7LH/GeRKB59mDMAXn8/MD6Etsf+08ZavCFvcNfhQ2WN3D0PXKfFAl5DdOh9+it+Ssb6au2U7ejNVSY2Z2Cueor8qJQk6puujF97wI2f+eefcUxzMmcajM9kg0umrwbacwnsE5UE1kah7hZRso0QsMsYVSYxZxPcy6kjkLZHFsM2MyOQb3mtVh0XmV4OLgGwZ4mbgg0Tn9paSB01/z8bC4lt3a7IdGxSY1g+Q35kkdJj9BDap9D2Z0uF10NY2k5Np+Smr0cG+9Px9e+3KiKp9ciyvE5gDTtqzq+OPP/TMoN3vP1/ABXboNxiitIhGURf8uzset5ykSspwdirn0HUv6+cWVJl2xU7SsucCrVRQw63JoFze7kNw6MPajoB4g08sk06BTfZxSvczRjC8vmL4vYazPWy6anbpGCHmruP2gSKPfIS6eX
 VveaMDZz
 gCffv2cosApYB7zgcEm/PAEuXs3K2By5amTBB+Ox9ZHjZ18dC7HigpLG8WNaO9IPrGjNU9A7NNrOU1c6RnmGBTPWMw0V5qgX0pGgzy+YY81f93ka95Ll2HSYlYA3MMaOkKCaNAJAhqKHjl4dMp57gpcdklLOtwX7RA7THUS1m1i/FTHi1kY32dVt9DbAEtLIK1jAd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Thank you for your review.

On 12/30/2025 11:18 PM, Mike Rapoport wrote:
> Hi,
>
> On Tue, Dec 30, 2025 at 05:27:50PM +0800, Cui Chao wrote:
>> In some physical memory layout designs, the address space of CFMW
>> resides between multiple segments of system memory belonging to
>> the same NUMA node. In numa_cleanup_meminfo, these multiple segments
>> of system memory are merged into a larger numa_memblk. When
>> identifying which NUMA node the CFMW belongs to, it may be incorrectly
>> assigned to the NUMA node of the merged system memory. To address this
> Can you please provide an example of such memory layout?


Example memory layout:

Physical address space:
     0x00000000 - 0x1FFFFFFF  System RAM (node0)
     0x20000000 - 0x2FFFFFFF  CXL CFMW (node2)
     0x40000000 - 0x5FFFFFFF  System RAM (node0)
     0x60000000 - 0x7FFFFFFF  System RAM (node1)

After numa_cleanup_meminfo, the two node0 segments are merged into one:
     0x00000000 - 0x5FFFFFFF  System RAM (node0)  // CFMW is inside this 
range
     0x60000000 - 0x7FFFFFFF  System RAM (node1)

So the CFMW (0x20000000-0x2FFFFFFF) will be incorrectly assigned to node0.


>> scenario, accurately identifying the correct NUMA node can be achieved
>> by checking whether the region belongs to both numa_meminfo and
>> numa_reserved_meminfo.
>>
>> Signed-off-by: Cui Chao <cuichao1753@phytium.com.cn>
>> ---
>>   mm/numa_memblks.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
>> index 5b009a9cd8b4..1ef037f0e0e0 100644
>> --- a/mm/numa_memblks.c
>> +++ b/mm/numa_memblks.c
>> @@ -573,7 +573,8 @@ int phys_to_target_node(u64 start)
>>   	 * Prefer online nodes, but if reserved memory might be
>>   	 * hot-added continue the search with reserved ranges.
>>   	 */
>> -	if (nid != NUMA_NO_NODE)
>> +	if (nid != NUMA_NO_NODE &&
>> +		meminfo_to_nid(&numa_reserved_meminfo, start) == NUMA_NO_NODE)
> I'd suggest assigning the result of meminfo_to_nid(&numa_reserved_meminfo,
> start) to a local variable and using that in if and return statements.


I will use a local variable named reserved_nid.


>>   		return nid;
>>   
>>   	return meminfo_to_nid(&numa_reserved_meminfo, start);
>> -- 
>> 2.33.0
>>
>>
-- 
Best regards,
Cui Chao.


