Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A417FCCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 12:56:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B0E98E0041; Mon, 13 Oct 2025 08:56:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 061518E000F; Mon, 13 Oct 2025 08:56:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E92C18E0041; Mon, 13 Oct 2025 08:56:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D2C1A8E000F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:56:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 790BC139F16
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:56:18 +0000 (UTC)
X-FDA: 83993089236.12.5A21570
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf26.hostedemail.com (Postfix) with ESMTP id DB007140013
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:56:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=pGbrRJgv;
	spf=pass (imf26.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760360176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TCnlQ1PVsMzc2uQnpALLB4Ejhm3ZyIkfc4S5MrL7woY=;
	b=JJuXh/Us0uZyL1hlYXbbve6FkZGKU1ojTSurIKOMM3Mmx0togH/ruw/t+mLW2JrMcyO5ym
	NsTYfWZceyhmPRzEZi0YvUtyoXm4iTFJIQ0mTKbQPcM29t0AN0dW0g7eYl/6GPKt5PG2GA
	JInRiW0uvssdvZx3gBYPX/1FZBOyMEo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=pGbrRJgv;
	spf=pass (imf26.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760360176; a=rsa-sha256;
	cv=none;
	b=MdZnOHIcQ+N+HsBAYnnnoLrgXp/pT5ujRdRIPm0vhiwwByVLvb9rCrXMT8Y8fplGz6l4xy
	A3v1Fn11WBCjLwRGH9nAZx3wbdXX3C1Aa9L88KpCc7Fw42kBaMb4IYAwbzBzULc9CRSbMu
	F/oMpyZ7trUCFdo5ZMcE+jYsr7zbUd0=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=TCnlQ1PVsMzc2uQnpALLB4Ejhm3ZyIkfc4S5MrL7woY=;
	b=pGbrRJgv8c2fzNgdel5jxVMMesNgp4UF/Nja+jJ/vMIMwAbebB5kbGQcfwsNsXhXaH79yLT6t
	rAth/h5pqTb6t3PGgzB1r+iyWKfhSrL202Yh5vY1mHVpliIT6G7W6b44qP+/cOZFlIdLxt5EWg9
	vYOlRp2siWo1B7ugbJ4fgQw=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4clclK0pfQz12LD2;
	Mon, 13 Oct 2025 20:55:25 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 48146180064;
	Mon, 13 Oct 2025 20:56:11 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 13 Oct 2025 20:56:10 +0800
Message-ID: <876040d3-d814-49cd-9829-a36afd320a09@huawei.com>
Date: Mon, 13 Oct 2025 20:56:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/hugetlb: allow overcommitting gigantic
 hugepages
To: Oscar Salvador <osalvador@suse.de>, Usama Arif <usamaarif642@gmail.com>
CC: <muchun.song@linux.dev>, <david@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, <shakeel.butt@linux.dev>, <linux-mm@kvack.org>,
	<hannes@cmpxchg.org>, <riel@surriel.com>, <kas@kernel.org>,
	<linux-kernel@vger.kernel.org>, <kernel-team@meta.com>
References: <20251009172433.4158118-1-usamaarif642@gmail.com>
 <20251009172433.4158118-2-usamaarif642@gmail.com>
 <aOyxle8OJPMKlVWX@localhost.localdomain>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <aOyxle8OJPMKlVWX@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: 4gqf83w67d459qru6bh4zdr7zw1f8bcb
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DB007140013
X-HE-Tag: 1760360175-42690
X-HE-Meta: U2FsdGVkX1/wlKxJxiGZd7oNiYN2ar3vPB0F0NOy1MN/dy0N1TRTSqJW9n8GMyHwLeegbWNAtTENDLbUX8TsVSWD7HT4EJXajc2sTSjVshvKBWrGYaMahGy2KpJ//+QheeFss3OSgD/NK5D1y623g0x4LdjFLVV8AYAIQiWTcyFA6XYCGjNWHIzNxfZZeoFNvG7EIGUumvXD5TnHy8tnDAI/FCubdmojFXwHBkIGUsoXLiM72hivkEn6C722CbJCUDfUhsvGN+gDW6921D8XIUFUJzt96cHM3zzmFRgjlqrcHHzCGyhAeYhJZ+eVwv0RSYOJZp7XLy4eWu3cCnIp9EAjSqMs9n4A2N3+qE7LH4BH+jNODzShSh6HMUlJvGJWn1ThE4+LlEnzVBy3xrTKO38rMIDxsz6zmLpXjCU0RaOK68/RnmcD0xdg8PcXZG9iz0n5qQq+Iqk6BWPVdEU2Z67aAlm+CvFig/WAnkF8NR65BG++A64SpeSbD4gRbjj+3VpIZvjSE/3l5Civ3UPGG9Mt+3JHWYsQETGSENH6yMde52tYMg4/YMo9fqO3QMKQP3JVTg8MyqZdYCH87FUSs8idWwivJWu1Ujmsm/YZ32SFPza++aFKc++BeNwy41bRn+UsBy+jDxaV8Wjtu74hSMYPY7H3mTgegPlN49kfcke/3bnOrK6dXWPo+czJkQD4lHwHEC4OF06Ze9t+pifqKKiG4inPCkn62qDTUxP/tASAQZ22C9OsOWi5vSClLU21twhaW1q7GAl4AxiDArFRssTLs+3dJmEgOlKYA+1TfY7lw6aMhIjxlpJ5i5Jc48QzypFEmY4MB6L9NLiYj5ytLGfHPLbNxrWBZXZyOpKxDa9jv0OlF9yAKd3sFgV1qmLmou2uTluw/9evrNZXV/u94WzjVNwk+W0Ax36NP+E4cu1nEzuNM5m3i7EkeF6KiitF0jwh1JF3mRTIsht8yL+
 L0AL1naZ
 w5x2tDn3TAtd8qN8I3tw9wBvzDjGKFE6pWvACpPOi1GjU7BT8G7dGs9TjXtv0AwY/t7aslM/34xShk9UV9VQKdaUBiHSONEYnBIVgc9TdGmbrVD8kUHkKVjQCZ4K9O7xMd9O7kiW+JLR2NORy8hD4cWFYY6ERh13AJV+Qy7tkenDOPNt+IhNxl/TJufa2eSahHblsHaXpzB74Rbfthoc0EYve5Hf0/5hUFq2TyhBiF0Di6RZWGJj/HrfLIjLo10/ZZzSf2hvOxa9QIJi0jIro5RKfH31B4GxM+jAsojugOxxogArEr6GEhCcR+7Bogz6It6bEMMg/6VpiH8WvCv2y6MFkOCuqDWe9rToCyVYcpKKGyvdIJlTFVtvUb7cfKIIyddhg/nVetb/Ne/csySqa/mo/QTYEPl1lgAuoahCoe7qwugU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/13 16:00, Oscar Salvador wrote:
> On Thu, Oct 09, 2025 at 06:24:31PM +0100, Usama Arif wrote:
>> Currently, gigantic hugepages cannot use the overcommit mechanism
>> (nr_overcommit_hugepages), forcing users to permanently reserve memory via
>> nr_hugepages even when pages might not be actively used.
>>
>> The restriction was added in 2011 [1], which was before there was support
>> for reserving 1G hugepages at runtime.
>> Remove this blanket restriction on gigantic hugepage overcommit.
>> This will bring the same benefits to gigantic pages as hugepages:
>>
>> - Memory is only taken out of regular use when actually needed
>> - Unused surplus pages can be returned to the system
>> - Better memory utilization, especially with CMA backing which can
>>    significantly increase the changes of hugepage allocation
>>
>> Without this patch:
>> echo 3 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_overcommit_hugepages
>> bash: echo: write error: Invalid argument
>>
>> With this patch:
>> echo 3 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_overcommit_hugepages
>> ./mmap_hugetlb_test
>> Successfully allocated huge pages at address: 0x7f9d40000000
>>
>> cat mmap_hugetlb_test.c
>> ...
>>      unsigned long ALLOC_SIZE = 3 * (unsigned long) HUGE_PAGE_SIZE;
>>      addr = mmap(NULL,
>>                  ALLOC_SIZE, // 3GB
>>                  PROT_READ | PROT_WRITE,
>>                  MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB | MAP_HUGE_1GB,
>>                  -1,
>>                  0);
>>
>>      if (addr == MAP_FAILED) {
>>          fprintf(stderr, "mmap failed: %s\n", strerror(errno));
>>          return 1;
>>      }
>>      printf("Successfully allocated huge pages at address: %p\n", addr);
>> ...
>>
>> [1] https://git.zx2c4.com/linux-rng/commit/mm/hugetlb.c?id=adbe8726dc2a3805630d517270db17e3af86e526
>>
>> Signed-off-by: Usama Arif <usamaarif642@gmail.com>

Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>

> 
> I guess nobody bothered to do this after we added support for 1GB hugepages because
> creating those at runtime is tricky, and in my experience, almost everybody reserves
> those at boot time.
> But I do not have objections to make them behave as normal hugepages:

We do have cases to allocate 1G hugepages at runtime and we enable 
migrate 1G hugepages in alloc_migrate_hugetlb_folio() too :)

I will send a patch to enable gigantic pages migration based on this one.


> 
> Acked-by: Oscar Salvador <osalvador@suse.de>
> 
>   
> 


