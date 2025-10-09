Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6AB2CCD185
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 12:40:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 468E78E0091; Thu,  9 Oct 2025 08:40:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4119A8E0002; Thu,  9 Oct 2025 08:40:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 300C78E0091; Thu,  9 Oct 2025 08:40:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1CE028E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 08:40:51 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DAE98160875
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 12:40:50 +0000 (UTC)
X-FDA: 83978535060.24.7FF52C5
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf14.hostedemail.com (Postfix) with ESMTP id B137010000D
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 12:40:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=aAzNxfuy;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760013649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=71oi71RI5Ip+tb5/vUqCU8Khwnwi7PpDvomKjg1Up1U=;
	b=aOOaN4hamnCcN1AX2MdsFGBZ7uuANxSDZXszcIakg6zJGRy6r560jkHgQqPHSRj9fYHJE8
	0lSHUXs4IKuvVTQkWJxiaS7Vhfj/ovYy58RddwIp9kYUiyJ1Hi8AuXhDFQsk2Z64NagWg0
	YV38vbuACBeIzEeXt15iscARw7mQs7Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760013649; a=rsa-sha256;
	cv=none;
	b=un3Cyy91eIw9UHFsK8fMuDydgIYrDm3+DN3UbLyVxLqBjKn+itBRn5bJim4KvuLEhd4L4g
	rfXuaA2l7u5G24Iec7Chi/lIxLzBgHg9nLiUnM7GEhbt3RroNpUUuAIUzk6Q5KG16O7KtD
	3h+yxaCcwmr3NRXumimi3dB/16B+orM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=aAzNxfuy;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=71oi71RI5Ip+tb5/vUqCU8Khwnwi7PpDvomKjg1Up1U=;
	b=aAzNxfuyREnNYoOvBy5D5gknS0Ek01S+29dgeFNhOwcq46k/cdpaMqabRGY1amnePmpvs08Cu
	p067ZOWOcZ2qNTI6fh00ASx01YBLO2V6cRU3LRMpLUxbQrx+Af3TJb9UCyB+bZSuPptEKXm48Tg
	aAntvVTkFLc3b1zhDo2uqRo=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4cj8bJ0gCTzpT1Y;
	Thu,  9 Oct 2025 20:39:56 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 9AC8618006C;
	Thu,  9 Oct 2025 20:40:40 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 9 Oct 2025 20:40:39 +0800
Message-ID: <8689fc00-f0c1-41af-b8c5-aa7970a3746d@huawei.com>
Date: Thu, 9 Oct 2025 20:40:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: Re: [PATCH v2 2/8] mm: hugetlb: optimize
 replace_free_hugepage_folios()
To: David Hildenbrand <david@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, Matthew Wilcox
	<willy@infradead.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Vlastimil Babka
	<vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, <linux-mm@kvack.org>
References: <20250918132000.1951232-1-wangkefeng.wang@huawei.com>
 <20250918132000.1951232-3-wangkefeng.wang@huawei.com>
 <c925f44f-f0e8-42fa-94e6-24a02f9df28f@redhat.com>
Content-Language: en-US
In-Reply-To: <c925f44f-f0e8-42fa-94e6-24a02f9df28f@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam05
X-Stat-Signature: hbpej8fcogzpfd5qdn1auij3dhi71ejb
X-Rspam-User: 
X-Rspamd-Queue-Id: B137010000D
X-HE-Tag: 1760013647-770587
X-HE-Meta: U2FsdGVkX19yDlh3NFYNFpAKabvtqckzWWd4cl9D9qYlESmbTyZFQ0uXUz1e0gMxIrswQhCoCvtEw4gxevD+cpDUyO2XsGuY7aaYeFYHABXuw/310Vd9ruEY1iZumycsjiPEo69Jwyh9HdIUZOjvfaGG4OrVF+RerzQaYn86yfN0n3fyHN5XQoZGrVnnfb3LzgroZo/Sratauu4ZW24NSePya8/45s+BmGXw/znJC0726z5QUTjp5SQqPp1nip4+Q9HzyOhG4PzPmQdG1AXpmC69EjLVd3Gx2wprp3aHAWqDfMhWmPNOwKn8xijEOTF+Y4MsC+e99v+wAv38iSvtAbaZuYgT3r1/hHPPD62hYaZRp62x3wloNFlvetMNfhq2wF6K2acP/kaZWJ48hArsSbF3PpK1R48N942vX+PkAJ79OwML3u2DVmFq7+xER/YPhODxayz/uzUADHJbSE9Suh3nQZ8JWOZ4Q4D5XWHyjF0XoFm940JGoa/TP+CT2CzDxPlHWKsAr3sfzA3s5GyhggEWlQWm0c2IXPTL3JXHRDxZyp6ceMWQlvaA4x3hbMF3AkwJ22g8cDmvbPxbYJIq/rK/D7GfB/9kL1/2V8KyVnuGCKJY0YgdtqLRIU8bAbkyGLOM0BC1ftxsGoLPXFea2tz2S9JNZq9CuqF6yTP4z2fy1Fxxi0Z9BKR1TBuDCa7sBGvd7oVAQUjSab6H2zLbPC3r/uIVgZSdKRY4SqXa4iqN9uLgZDtsSanGDsXfq/0UjZblgUblBvVtyGlHkQj0aDn7iCZ20lcC/z81B0SXVJiyCmc0agLKPSAoUB1XjTX6Axn8f5eOfZdBPVqM3ObLZ5AWJtFngq0BOC74eP9hr9BHLVe2W/ikceKB3KAWeDMkRsgAfmZ3LUVJU0iv5IMXZb8dFtH7+xtXk8hPc0t0zPR8HPR0Q6p4SBwZBhMS9peSTvy32yKp/j0/B7jlZx6
 VcDoZ3nK
 TktnIum2hh1+3dHirjONItY2o6GoTdr9sW8EwG7ie9mGSp49qnEPc/ZsK1bh1iggX3pUJeGwdrkAtDSfoTXNVxNRUHy1I+d6ei5K7Kp5T71qPm3rTg86Uy0xpjJ3x8E1auqJlVrNkiwUVT1V5GuFWNBxNUcGvh6EAMj18fRC2I79oVqjVgkmKfp0exrGqv9Y/0BZnh24XPZyYd0KJPH7DOT5IvvYtpmGdJwGoL+G4xYr8l2xT2yg3h1XkOtTRnOamim24a4MSTIg3XGolHaO+JCA4BSMNxoc9HF+ok6Q2zQMKMMu6PtrvX1C7Ty/hm1jgrSB7cenwf1Dplx+VmQcHZ/l165j2arsMXHwXHKNdPmCa9Dwp3Wr0leWyqCcFNFAesGW6MNj1nRXhfZI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/30 17:57, David Hildenbrand wrote:
> On 18.09.25 15:19, Kefeng Wang wrote:
>> No need to replace free hugepage folios if no free hugetlb folios,
>> we don't replace gigantic folio, so use isolate_or_dissolve_huge_folio(),
>> also skip some pfn iterations for compound pages such as THP and
>> non-compound high order buddy to save time.
>>
>> A simple test on machine with 116G free memory, allocate 120 * 1G
>> HugeTLB folios(107 successfully returned),
>>
>>    time echo 120 > /sys/kernel/mm/hugepages/hugepages-1048576kB/ 
>> nr_hugepages
>>
>> Before: 0m0.602s
>> After:  0m0.429s
> 
> Also this patch feels misplaced in this series. I suggest you send that 
> out separately.
> 
> Or is there anything important that I am missing?
> 

Sure, let me do it separately.

