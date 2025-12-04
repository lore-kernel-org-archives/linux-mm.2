Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B67AD1CDB2
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 00:46:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D18656B0024; Wed,  3 Dec 2025 19:46:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEF2C6B0027; Wed,  3 Dec 2025 19:46:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2BF26B0028; Wed,  3 Dec 2025 19:46:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5BBC6B0024
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 19:46:35 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F520BB60F
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 00:46:35 +0000 (UTC)
X-FDA: 84179947950.18.E167EEB
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6388880005
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 00:46:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764809193; a=rsa-sha256;
	cv=none;
	b=yuTr276yM+dEUAKBKanDC180JMBRVSzZPUhjoJ9+wkQ2avH68OdTmIfBwQPADJXkXcu+ky
	44u5Vbqy1lY9/0KS/9eCnvsjs6Xs2a4PK0C2IwZq2gShFfMojGsWOPY5gbQylNxx6csabl
	4xTCzDlO55JKWIrfM4kgI2uxjvJ0skk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764809193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eOj2tIJIgnV8eTwawuGz++SgJKddYFUsPXpSIfwlY6M=;
	b=gHf3mMpx1FEPlLUtnSjwvNFAo3SnVfh39dcFScqYnX3PvsVkYMilJlyTTqd0vRG8pGI//a
	Mq5jE1MAaeL/jRUFVaxDNq2NWM+YGZVKqSOOCbVNe2i71pZzv3tOZGV+BaVUN0Cib4DvsG
	ecb4E3S5sztRKSS7OH5w2QT9iCxWgV8=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dMG5D1HsRzKHLyn
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 08:45:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 55FD31A14E1
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 08:46:26 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP2 (Coremail) with SMTP id Syh0CgAH5k_g2TBp52sQAg--.43129S2;
	Thu, 04 Dec 2025 08:46:26 +0800 (CST)
Message-ID: <75ce1699-2c5a-4aab-acee-cca5c6a1e37c@huaweicloud.com>
Date: Thu, 4 Dec 2025 08:46:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] mm: vmscan: correct nr_requested tracing in
 scan_folios
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, mhocko@kernel.org,
 zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 lorenzo.stoakes@oracle.com, yuzhao@google.com, jaewon31.kim@samsung.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, lujialin4@huawei.com,
 chenridong@huawei.com
References: <20251203094002.1745458-1-chenridong@huaweicloud.com>
 <98cbf348-ff21-4c90-af32-b8009c34e5fd@kernel.org>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <98cbf348-ff21-4c90-af32-b8009c34e5fd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgAH5k_g2TBp52sQAg--.43129S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAF18KFyxurykJr17ZryUtrb_yoW5Gw4Upa
	yxCasrGFWfXrWfKF95Z3Z5XFW7trWjya4UJr15tFyUXr9Fq342gryUWr1Y9rWUJr48Xr10
	vasrWFn7uFyDtF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	7KsUUUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6388880005
X-Stat-Signature: 54qwhzihckprnmbxkt99pfjccbui55hs
X-Rspam-User: 
X-HE-Tag: 1764809190-401135
X-HE-Meta: U2FsdGVkX18TKkZl4U69/EaGNSy83IEFVRF6/URPy7PQySReiXzOg9vUispSSIgQc+fF3jP0ZYDU5Oj42shrWKuYJCILVLhbdEK8IpDR6rbJiRUREzC5ehaMY4phy18ByvSG+tenQWxfiecA6lCF3Zzhm/8oIO8Wdji6hjnbHwUHYsE43UhtiBieqnoPfOAepInTlgLnL7ixjmKhVI9zQ6gyxhTTWltr4lctYUamvUxnQ+WMgdVRVlitn9IDPqJflKAM3vQ/8PK1grNaUwmEXTIp3KYdhG72P+6fbd5Ol6JDp9THc6zgMHFaDCa+lFqDkNfvrUkKGvP+mSiqdx6fr/e5nTetAUUCE+MJDiW1ohBce8bA0PnAQoKkt+SJopE6bQIP1GYEP3eLA4aAIcx/Nqk+jDAKIsnXBZshB2ikzI9iOSPze0V4dU50oWXkJxfrtDXnSXjafzUfhM/wWWKnlprPGliSuPkt5MqOE2UjFER0BJvoLjqVjpAE6tENAkfVKhuQr32RU4UrdQm5MiQMdJM/IIVYje9zND04QM42RK4i+w3RFRuMhEKsmlO+Yjy2Cus9z9vaVpP8x4/qw44BS6/you+vHNC/ER8OFVHJ1QqG2dlx/idLxIMeK4cGdxZIoJuctNk64FYnEK/0SrR/dI21WIOUJDAO6fwjpm+CvnsiePmsLB10RDu/Np0vwWuesXOkG+7YqMSJLFbAJ87XqmCwRlqwMC8hVgnQ1UOi1sG2F5Q0PlldF5lfD+hkgMLmH0gPF0eFFjXVBSgnpZOznldGVa0/0i8A+xXkM5sYNtl2V/sYc9dbwfHT0LBiCb0LswLAvn7sTaCD8NS6Q2+HBPmv2XUqswHAtW0eU41ATGWsDhCfFTloBAfa5YUSPAHAuRLQVLOKPp3YUja/FKWrT58J55MCGhdspQVxavJ94rWUqAo7USZPFPXPrKQyADWZYDHAvNYoaeqr7idOcwD
 D1G7W9Zj
 wuKoOxjQM5YPqntKXrXC9Kes0jjO+JUAqKW8go3ZLF0k39sV9OIsf3S8qQvRjYE488po5UpWDxUVmQC4o6AJvqWeEBLkMFKzTnFntywoARVv6xJ7Dm48cddevsAb4h8vtLKDe1LSwi29FC3ghI3r4Y/KW/9B5E0wbJEphQCpGj3Bk8A+jys8VQId8cRPl6FGh9kh8fXs1HUBFQu3kx73PH9g7mA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/3 19:33, David Hildenbrand (Red Hat) wrote:
> On 12/3/25 10:40, Chen Ridong wrote:
>> From: Chen Ridong <chenridong@huawei.com>
>>
>> When enabling vmscan tracing, it is observed that nr_requested is always
>> 4096, which is confusing.
>>
>>          mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>>          mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>>          mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>>          mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>>          mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>>          mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>>          mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>>
>> This is because it prints MAX_LRU_BATCH, which is meaningless as it's a
>> constant. To fix this, modify it to print nr_to_scan as isolate_lru_folios
>> does.
>>
>> Fixes: 8c2214fc9a47 ("mm: multi-gen LRU: reuse some legacy trace events")
>> Signed-off-by: Chen Ridong <chenridong@huawei.com>
>> ---
>>   mm/vmscan.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index fddd168a9737..8cfafd50a7a8 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -4601,7 +4601,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>>       count_memcg_events(memcg, item, isolated);
>>       count_memcg_events(memcg, PGREFILL, sorted);
>>       __count_vm_events(PGSCAN_ANON + type, isolated);
>> -    trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, MAX_LRU_BATCH,
>> +    trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
>>                   scanned, skipped, isolated,
> 
> We do that in isolate_lru_folios().
> 
> Given that we do
> 
>     int remaining = min(nr_to_scan, MAX_LRU_BATCH);
> 
> and effectively cap it, I wonder if we would want to trace that capped valued instead of MAX_LRU_BATCH.
> 

I prefer tracing nr_to_scan, as it reflects the original target number of pages we intended to scan.
Even if nr_to_scan exceeds MAX_LRU_BATCH, we can still deduce that it was effectively capped by
examining the actual scanned, skipped, or isolated counts. However, if we trace min(nr_to_scan,
MAX_LRU_BATCH) instead, we would lose visibility into what the original nr_to_scan value was.

-- 
Best regards,
Ridong


