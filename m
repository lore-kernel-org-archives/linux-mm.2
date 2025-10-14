Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5937CCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 03:45:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8D498E0078; Mon, 13 Oct 2025 23:45:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D65298E0007; Mon, 13 Oct 2025 23:45:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA1E18E0078; Mon, 13 Oct 2025 23:45:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B83E98E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 23:45:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4859A16068F
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 03:45:39 +0000 (UTC)
X-FDA: 83995330398.04.E7DCBCA
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf24.hostedemail.com (Postfix) with ESMTP id 25C38180003
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 03:45:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=oYsC01qj;
	spf=pass (imf24.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760413537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C4U3XVfzB/WE1X4x4HxDClP9tQ5V3fyAsjAvGseDpQU=;
	b=b86YyArEyZnQRxoTj4gaDuNqU81QMTOs2EdP3ntCFAESd8zte1XyNglueWN/RYqby/dc56
	Hapra/ku1nOHdGkRDTAeSnEsJZVncehznki9bvKLFzGg7FrujVQonqwjsRwrAFpzRJ3fDD
	zG0E/ZyeU5nWem6FQ1JK6KAzD+VMDdw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=oYsC01qj;
	spf=pass (imf24.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760413537; a=rsa-sha256;
	cv=none;
	b=h9sWQoL+YZ2ZMQnYjc0+nUHY1DCMjziQvJXKx7HBTsrM+sb8ZFFmDcsIll34qRU+vTIUB0
	amP6zSc4bsM6iaDya7T9qtnTC9qCxoaNHT7vX9UP907YziJ4VSQoOAjpHnhlq+RV8Jkzc9
	FjHZSPzrMYPCngD0nFIqXrGXSANl5Mo=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=C4U3XVfzB/WE1X4x4HxDClP9tQ5V3fyAsjAvGseDpQU=;
	b=oYsC01qjDj5R+wtKObyrgxC8aPU4CX2+g3q/tl+bEZI7f9k1JtSibRn9GwvhCVHkl1T0QdYiJ
	IKHR0v4M3EcYqzmvUwBEdxau9gG0RVSbrO+qWzwUm03x5dgPLhnbEQfRba7tgGfmqK9BRLYPIIp
	MB/YaOlUl6NzMaFNZtL9VOU=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4cm0Tz30tjz1K97v;
	Tue, 14 Oct 2025 11:45:11 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 4404D1A0188;
	Tue, 14 Oct 2025 11:45:30 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 14 Oct 2025 11:45:27 +0800
Message-ID: <a7274137-a125-41f2-bc19-0a87faeea4c7@huawei.com>
Date: Tue, 14 Oct 2025 11:45:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] mm: page_alloc: add __split_page()
To: David Hildenbrand <david@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>
References: <20251013133854.2466530-1-wangkefeng.wang@huawei.com>
 <20251013133854.2466530-3-wangkefeng.wang@huawei.com>
 <2e06ed6a-1674-4eff-94f2-e44ba7de9663@redhat.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <2e06ed6a-1674-4eff-94f2-e44ba7de9663@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 25C38180003
X-Stat-Signature: fsneysctqcs9ie16kezanjogs5fdfxk3
X-Rspam-User: 
X-HE-Tag: 1760413535-925496
X-HE-Meta: U2FsdGVkX1+l/JXGPjNpCmTvM7RcvMCif3NHQXizzVu3fD6G6CARHf2Hvpi0ypS+R2ghNpev+IaJ7mEZ1ss38ziJpPkSyhhMvAKog9aJx0bKJRSt3WWPG3BEBHSltv1SClJPPjToN0O/U7F3mmcE0uOg1pZOdbO1Ef/umlFe4Y7FxBbcKAKul5jtY3DXq8hhOEF5niMlIjvALAXVuCvEVJ+Mt4vRE5+Dy+8EY9O9knj/WWGahOixfXvGfGKDh+a6SrtOVmpAnKMU+D8WOnR8Uq9oYSTOxVjVerGPaRg/mRWNh970r5cgV+K6qfUiRNcNmFTxJwXKM8ksN1Rhpyr0c7MnqAG6AwbCKh0NlsqBumO9B9xVXwU48jvgm0Sqs4lPa3D5rXcryFQsZbFONPKb2yGrtZghGJQl+NyLqGxsBIrMrEi4xxHp3RXEKO1JMOgUQ+fJzO4XCgCyPvOiLP746jWt2Q24KQUN1z7cQ3SLZRTKlmoKU3j6/zXm/2IxLJCj6zl5tHb4QY8edzIdfcux5HJRHqoH12dbmk4N5XwTCtz91gCCU+6xF7t/pSW9SFkSpxTjcvLL+8Mx+hagr6EG+OKIu+UFDi0Ip6rzwzS+fZKng5MpvT6bcG3lgW+htC9dfw4KczaIYU5/JC8pJtFT3yFT8HP/OtJ2YYCM8UVx3M1AR+s2LPU9yQBA99Qc29/9jdp+HfhgCDcPi9pdvg6dKSBNgL778HZD82HoGlsRZ7d0+P9SA15HvwsmzyPXroFfw5cHOzR+nQLYG9o2S26jQDZcrS2cxAQszJHaGsw/TcahezTF25m6/VXG63ubJcPSWMcAr1xD6362WSAax/n396azx2IIHqwCQCkv4N6u6//tmr4p+O5Iuh+TpDyJUPUsTVGEbbGEav7tFCDPlyUIWPKrVt93bF98CvGADmd94asiSs7FzvkH2K9rU0HCf/w19sdK6clkZxH4CXLVtDk
 Rd7iWBmu
 cbqt0hMGwT/ahsJp0928+E15shOegh77Jum4ZU+6J/YyG43pYgcaTSha5pkOMe2HSZOLVlnbaBGvEr56h+zpzl2TXEB42s+L6Sga6dYrC7Vqmr+2TCOLTgsHo6K8hMu+Mo8Fc/pGxSrxLtVchameguz6LYnFQvKDsyLDA698GmzmWmU5cHbyqidxIOFdVV0lIv6+nLoIGM42fprz0Cnqqq3h6e+r1IE09vnWCJFHfH7qoDa07aN89IYcmjfS2jexTwIJjDbDBABkTdBWbBMgxh9L4TUpq7ZQV2vbGWVVlpaTGm26vnW6EE09ZTWuYA86kqqvItrmPUz88DxsuG3UiIgqYGk/Fxe/zrZ18cx4qPGtuV86atmGH+zXbKO5PeVjZ9n4QD47NBKDUU96X7BqcPmcl75pHEv44hDzx8VxHGPCHeDjiduWNFwUIjA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/14 3:44, David Hildenbrand wrote:
> On 13.10.25 15:38, Kefeng Wang wrote:
>> Factor out the splitting of non-compound page from make_alloc_exact()
>> and split_page() into a new helper function __split_page().
>>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   mm/page_alloc.c | 19 ++++++++++++-------
>>   1 file changed, 12 insertions(+), 7 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 949b01f293d4..646a6c2293f9 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -3042,6 +3042,15 @@ void free_unref_folios(struct folio_batch *folios)
>>       folio_batch_reinit(folios);
>>   }
>> +static void __split_page(struct page *page, unsigned int order)
>> +{
>> +    VM_BUG_ON_PAGE(PageCompound(page), page);
> 
> While at it, make that a WM_WARN_ON_ONCE(). Unfortunately there is no 
> _PAGE() variant, maybe there should be one.

OK，it's strange, we have VM_WARN_ON_FOLIO, but not _PAGE(), I will add
a new and use it.

> 
> With that
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> 


Thanks

