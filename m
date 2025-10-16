Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD457CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 01:07:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 237E68E008E; Wed, 15 Oct 2025 21:07:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20FA98E0008; Wed, 15 Oct 2025 21:07:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14C778E008E; Wed, 15 Oct 2025 21:07:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 043778E0008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 21:07:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B83C6138385
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:07:24 +0000 (UTC)
X-FDA: 84002189208.20.64D64DB
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf24.hostedemail.com (Postfix) with ESMTP id 60F35180008
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:07:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=b2MjVqg4;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760576842; a=rsa-sha256;
	cv=none;
	b=IwFk8XPLQEDIDu00ZdAZWV5dBG7JR6zlaCqW8PagThljYmc9vtbGZJWMcSOndwLBFmBUY0
	jfzuKmS6rJ+H3eSKl/gWIkPBM1wLTXOftDE7gsq+28V8CZ4ZHfHDekWNAE0Q1K/XnBNfYJ
	duVv5hqXLmXVUyPDPUSkrWpWTumjER8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=b2MjVqg4;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760576842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1fSdo6OTYpw8UnovCNMxTtGNTkjfRe+lg0EXGJ2/iAk=;
	b=dnxns9RA+iF3ePX0TvRowbV0tY9RRcfY7P/wI/1gmSrKTb824wPBAlyRv94Ikdxl+JHA8P
	m+Y00DEa4E8nV8TDBNFDpyladm4qxDzhP12lbnuitpAHH6mzD1eOLbvUfucWfs9QXfN7vb
	Vl5A8AdVDqrzyp4sddWWWrlxqSTGGts=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=1fSdo6OTYpw8UnovCNMxTtGNTkjfRe+lg0EXGJ2/iAk=;
	b=b2MjVqg4vScim2ZiRKaXK45p6N4swHfyYP/+OKER/4a9kjAumM52J9IhubvCnFLN2N8iibMGE
	LwCy6ZdNwRXIBB8+UPP8aF+qGrtD0ILUUvVyj0EG2BDJms2PC4htNzetgZFPBCAsmuPo07EL5vT
	vYMwlGjfOdKAZ2Or4vU5ERQ=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4cn8t00fnBz1T4G8;
	Thu, 16 Oct 2025 09:06:32 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 814DA140156;
	Thu, 16 Oct 2025 09:07:17 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 16 Oct 2025 09:07:16 +0800
Message-ID: <fb525b11-c60e-4a97-a5ed-be0792957ef6@huawei.com>
Date: Thu, 16 Oct 2025 09:07:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] mm: mprotect: avoid unnecessary struct page
 accessing if pte_protnone()
To: David Hildenbrand <david@redhat.com>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>, Zi Yan
	<ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>, Sidhartha Kumar <sidhartha.kumar@oracle.com>
References: <20251015123516.2703660-1-wangkefeng.wang@huawei.com>
 <20251015123516.2703660-3-wangkefeng.wang@huawei.com>
 <db3fedc0-6ed3-429d-b124-d1e67992d6f8@lucifer.local>
 <2c2a9527-e52b-46db-ac8b-b13f4ba6d0cb@redhat.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <2c2a9527-e52b-46db-ac8b-b13f4ba6d0cb@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: 7weg9birsenyx5ozb8byenffmw5e9u1f
X-Rspamd-Queue-Id: 60F35180008
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760576842-152530
X-HE-Meta: U2FsdGVkX18uCq4vovOiqTRtlZJbOSk1QYd3UuD5JlvbrstzE7Zs4rCSCmroWwSWyO3o85irziujhPjuYPDHOu8YU3pHFmAQbSWI/KLU+EVH0yYY72+1ZNuWeKSMXmOISZoZ3NnAeMRwtViS0qJU2/zxQ/D3T3uM1vUJ+VpU2kMPKrlTL702aCPfNQGpOlIFsGpeV1IctDcbmnJnYPdgmxWcOnovWkOOowvT7g50Bt7rkycMyZEZ1n9ZiFUwcPctL6mR95I1UNawLEQvCqLcOi7IGbwkyiJXPtfuUh9SRClxuJxE/0gmURBzBacYAC+XIeluS7P5kVLo+6Tn7SgXhAu1hVROOCM3+y2leVqaibkXDnyMFHue2+V2iBPMqnD7iKnFLVtRelACGCRnkmCsC1orc61RaK8BrpHPcAuwHIUVoJmwyS9NeVkGQlEBNfGMYBHUoLfOEP0TviN+ZfpxmwCdVA6HVIib5H1sFdHJcq20hXnx7s70r6ULtpHcPnSYQ2bgKAXJhM6jIdNN2IodStd1qo8o0t8qO9STGtlsE+3FI3SC3gX5uTrPJ+dqzItxC4mFL+1irmfT7skcrGzyaXwp6de+Q4I6Pk9nG5Wd3MrFEof5BwpYWYcoHLyE9djJA8rA3Ddd2gKC/Xl3ieNQ0r+IQe1xs3NhESNF2zlLiFd4B8y4vXGJoOH4TY8mUtjdDaNJ7uiv2SeVrjrDtAxgS3anEeKfcAp81mL4KEUVo9i0lwmicP3VFEPFYfdpIk0EWW+4lCfvRm9ReeSVz9uIVAPOHU/dHoBy6bP1aXZLp5mf324gh60jM4aoWSpVFpdKEyLfO9FpC/5NGAjDymT/vRiqAzxC8BYm50RL85K+QlVPI4T9598oXrwmhhuZEh1mqKF5tNOpZWQlFn1iXR3mVrbqoRQ1G1bVY+XDUOIZBS7b+neQWfRfGEaf2a5vRV0fT4r44vu8LCWXXbkEgc7
 +Lpqj5Gh
 IqnCdolW/p9w+b8H764ZT3xnaDiYl4Gr2Nb6H6EXNk2asFzh5jmjNp+iNbfB06mlHI4jndH514UhnU3x7WvpOVjAINw1sIx9kDgRms2VYnU3qj6Tu3q9wgE+GbbKkduF9GnwQDnWBVR3J52TlhpqGSApUwZTC6ba5MiIQnKO4zRrsbDMptmX4MCw1Is5tieN0KcHHNgWfsHCUEt6yERxqokwXc+P2eKQkgnn4vEkLfF1EcEyldGjRaFQEMg8F8/q5OKUP3h4tyFpdARmkhK0AxJvaG2niVNmf0tWaJ96KPUmJZxZSdUEBhPm6uOMpftBuI7pb8VY4JhVsvRTqD8v4mQCeYTaD3rZOtVgQx7ePU5OX9KY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/16 1:45, David Hildenbrand wrote:
> On 15.10.25 17:43, Lorenzo Stoakes wrote:
>> On Wed, Oct 15, 2025 at 08:35:15PM +0800, Kefeng Wang wrote:
>>> If the pte_protnone() is true, we could avoid unnecessary struct page
>>> accessing and reduce cache footprint when scanning page tables for prot
>>> numa, the performance test of pmbench memory accessing benchmark
>>> should be benifit, see more commit a818f5363a0e ("autonuma: reduce cache
>>> footprint when scanning page tables").
>>
>> Hm should benefit? But you've not tested it? Seems like rather than
>> guessing you should actually give data. Otherwise I don't know why we're
>> referencing a benchmark.
> 

Yes, I don't test it, just find the above commit which does same thing 
before and it shows benefit in a benchmark.

> I guess it might be harder to quantify, but theoretically it makes sense 
> to me to just skip in any case.
> 
> ... and it enables patch #3, which is nice :)
> 

My initial goal was to skip unnecessary steps for pmd folio when prot numa.

