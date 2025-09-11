Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71415CA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 09:11:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C65888E000C; Thu, 11 Sep 2025 05:11:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3D938E0001; Thu, 11 Sep 2025 05:11:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B53468E000C; Thu, 11 Sep 2025 05:11:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A56808E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 05:11:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 54E8813AD36
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:11:54 +0000 (UTC)
X-FDA: 83876402148.11.5DD76CB
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf08.hostedemail.com (Postfix) with ESMTP id 58766160005
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:11:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757581912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1fy1h68PsycLMi07WlaHx9FIfgbSuzqadXlsbX6r/ag=;
	b=cgV/Cq+XV5h1JVvKpDfMGCtDM3NGvPGloVnK71LpwcYR0d8N9jjHLpB0pvT8Nauw0REl+G
	qZR/Efeye8Y248iii40oPnclPRuyaEIADdnptDngOfhnVQCZ8D5xslfo7rk7NYN8joDzBg
	MJ1x9bOVPj/oX0HeE7/lRZBB6Bn/C1s=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757581912; a=rsa-sha256;
	cv=none;
	b=nI5LcitMWQBO/ckQCT4BRtbTfDnzBEcoFdeRaXszwROHPNwNqB0Jgm9N5jCz8ldN8hNE6x
	r12ejY0Zdt1X8d6rKZbaSlSotZ8PGs2ZCznawVO5MCHjMEuCNgTUQiS0dsVccAQ69ix8pR
	9UhZbd+U+YZzu7xBju5CXeteG+A/aD4=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cMsHV46CRz14MXv;
	Thu, 11 Sep 2025 17:11:18 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 42954180464;
	Thu, 11 Sep 2025 17:11:32 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 11 Sep 2025 17:11:30 +0800
Message-ID: <8508e8fb-77cc-43a7-8460-456f68a552ba@huawei.com>
Date: Thu, 11 Sep 2025 17:11:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] mm: hugetlb: allocate frozen pages in
 alloc_gigantic_folio()
To: David Hildenbrand <david@redhat.com>,
	<20250910133958.301467-1-wangkefeng.wang@huawei.com>, Andrew Morton
	<akpm@linux-foundation.org>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, Matthew Wilcox
	<willy@infradead.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Vlastimil Babka
	<vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, <linux-mm@kvack.org>
References: <20250911065659.617954-1-wangkefeng.wang@huawei.com>
 <20250911065659.617954-5-wangkefeng.wang@huawei.com>
 <90e926c9-40cb-4791-8360-e3d145fe3503@redhat.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <90e926c9-40cb-4791-8360-e3d145fe3503@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 58766160005
X-Stat-Signature: tpokbydds1y6qorj6a41k9yyxrsnzdsm
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757581910-637415
X-HE-Meta: U2FsdGVkX18NmiXjC5kavB68BWGvEk9dKGe0l5lzduUlwLgqV4nVtxmumK96YH5UgQ7tFL8NaCKd7M2TSEsJyAl0S4t8Vq6AoMum5dX4yxPyvqJckQjVaGskH11wRxAAHSPmKY5a+CGRB3v0xhJM9ddjzaOxFi0CpuXWNLAEulfnnS5/zaxcRKJA6TlLPnb2Njxjndkny+7mlQmmP6ERuK10prm4X1dr4OIJbxS8FMQPdCc8WJRJmgTflAOrgmsS9nY3NAVDyea1RrVzR3q78kSNVk6JToOKyktrhdzlAyekhfs7fYCdPt3cYkSZZkciL58OL6ylhajWt9Q1gKe9oBfopIy+LVlkzBh8RQrRpAHeeDxSdORFqyZzRi8xT+SWQChDX3fqvbtI9fB0lixoss4IAr2099K5JutAVuLfiQTJ8PiDzBqBCJjqggqQz5OtEHczYgBy19Rl5I1H7uN8QtV6EbBk2G71aCvjsBbkYOngxKFjkslfCN4JODWJ2N408afGE2J+1m3CerjN2RQSmwp9Kml3HTdyaU/j2QnhS67oS8viWl3drP5HBYXGny6OP/GTPpClHePv0si26PDMzpeG/z0aOtQ2trqAwRVGZrodYgJ7UGnQheMKfZLUrZBam8cnhYmDOXJphYVO2iaQLnk3aWi+vNk9sXWNAcaIByfYx5g9vgY0Z8qq9uZmpYl35Up2M9Krjqb+jQk7BjNCpXjcCHGU2u14TyxhtHeiVinQ9tuioLE16qSKFoHCKA1OS3x1XdffMjI1gowVnKnwSE6sxkQWDycMggswUwhDC7HCXzz6KZhU0B7a63zVjakROTJT+8Hcvk5XJYlzCL4os+u/IN/TDy0OxDpQyQ93MEqLOxiATa+NEdmGaOqmcqFZOXAifqqMehH31H6u+sbtwoAz17NIfwnfOBbkk8V+RRBr7zUVawiOkMnYzEQFGAR795xaIc90cNbSVqhJgxb
 4zcuzbbf
 bxdFUhD3uKBBWf4e9JnHRAyl23q5tCP8lqmagE5nG5i9PipAE/gWups752lb0CLJlAgb6KHBeXVf7mqxxxa8kFo/BJfq/nU+M0y3rel9xnDFNfNmiRUR8sbwqcfZfVklqZOto2dy19FQgsYHNBNUUVANWkfXUpG2yd9nu7PPUxRGSg8Wdl788QSbOkCKcsFvl/8b+Z6349gn/QJwRCtbZq6cB/UVs3k+TsH33S7Zz24hDHJ6AZJLFj+bhSGC6ws1of32eBnFKTLrTYpbX1THmUIYZHlQLAd2hs56O
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/11 16:25, David Hildenbrand wrote:
> On 11.09.25 08:56, Kefeng Wang wrote:
>> The alloc_gigantic_folio() allocates a folio by alloc_contig_range()
>> with refcount increated and then freeze it, convert to allocate a frozen
>> folio directly to remove the atomic operation about folio refcount, also
>> saving atomic operation during __update_and_free_hugetlb_folio too.
>>
>> Rename some functions to make them more self-explanatory,
>>
>>    folio_alloc_gigantic            -> folio_alloc_frozen_gigantic
>>    cma_{alloc,free}_folio          -> cma_{alloc,free}_frozen_folio
>>    hugetlb_cma_{alloc,free}_folio  -> hugetlb_cma_{alloc,free} 
>> _frozen_folio
> 
> Can we just get rid of folio_alloc_frozen_gigantic?
> 

OK, we could kill it.

> Further, can we just get rid of cma_{alloc,free}_frozen_folio() as well 
> and just let hugetlb use alloc_contig_range_frozen() etc?

HugeTLB can allocate folio by alloc_contig_frozen_pages() directly, but
it could allocate from hugetlb_cma, cma_alloc_folio() need change some
cma metadata, so we need to keep it.

> 
> Long term alloc_contig_range() should just return frozen pages.
> 

Yes, Matthew mention this too, this is the reason for the new version.

Thanks

