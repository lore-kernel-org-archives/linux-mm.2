Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 942F0CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 14:12:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB5AA8E0092; Fri, 17 Oct 2025 10:12:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8D6D8E003B; Fri, 17 Oct 2025 10:12:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCA588E0092; Fri, 17 Oct 2025 10:12:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BB5218E003B
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 10:12:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 68F231DD799
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:12:49 +0000 (UTC)
X-FDA: 84007797258.25.E95686A
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0D10DC0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:12:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=GEMttzlJ;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf22.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760710365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xdgornUmqCKXdOO6EOdxY4g8HCSxvTJY3Fh+KLAxGxU=;
	b=4rKm8MUqzxHz9HckjQK1OK+AjXUM9vWN2KNMJnjFx3uB0RiAEeD7qch2w8lyAXM0Fgdq+3
	chHhc9B6e1BNN5VpWqC6hDAxRw0WqvvNTKqA4026MzkGSXevqh76XfsDXZ3tQLaL0UYDh4
	fVvZPREaxwApiPkmgPOuTLm1rEKzL4c=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=GEMttzlJ;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf22.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760710365; a=rsa-sha256;
	cv=none;
	b=W7kmqhxo8TsI7ERutLuliLRwV2136UqdCHNL5VMkmDVQFiTh++nlTVkT1T9yxz8dSZ+6lr
	z+iEfjsJLZ5nUxkvspnRDTTuP78hKiRxKRWkUPyNmTPhKSg32DmUVnAKmTsf+SYWWTOD+c
	rDW57OUr0oewhqIi+Z9UY0ZFd6i2VDg=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=xdgornUmqCKXdOO6EOdxY4g8HCSxvTJY3Fh+KLAxGxU=;
	b=GEMttzlJ2qIe/lB7/SfIUYp41sc2zn+UNyc5ZjPakhgmbIqR1ObmfKVGKtagKtVxaokgnS/58
	C8xeCuNshtTojuOxFIzuQ0wiIDWphO3Ro/iIeZNXLB66xAx57TFsUJ8k15OgbkfKIgEg91MUtZA
	hYVUO+N0hg4+tv4pO9MBH1o=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4cp6GB1Q1Nz1cySc;
	Fri, 17 Oct 2025 22:12:18 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id C87411A016C;
	Fri, 17 Oct 2025 22:12:39 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 17 Oct 2025 22:12:38 +0800
Message-ID: <b9b84adf-c331-4aaa-8708-8453142ceb24@huawei.com>
Date: Fri, 17 Oct 2025 22:12:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] mm: mprotect: always skip dma pinned folio in
 prot_numa_skip()
To: Andrew Morton <akpm@linux-foundation.org>
CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, David Hildenbrand
	<david@redhat.com>, <linux-mm@kvack.org>, Zi Yan <ziy@nvidia.com>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
	<lance.yang@linux.dev>, <Liam.Howlett@oracle.com>, Sidhartha Kumar
	<sidhartha.kumar@oracle.com>
References: <20251015123516.2703660-1-wangkefeng.wang@huawei.com>
 <20251015123516.2703660-2-wangkefeng.wang@huawei.com>
 <47f69b78-8141-42a6-b04a-f67ba0b90ee9@lucifer.local>
 <0d26ce96-2c59-47bd-a034-d7810ce6aa5f@huawei.com>
 <20251016141051.27e9ce8b47aa242724ae97a4@linux-foundation.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <20251016141051.27e9ce8b47aa242724ae97a4@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D10DC0016
X-Rspamd-Server: rspam03
X-Stat-Signature: 5quigoainoxj17rdbg11qougpf841pwh
X-HE-Tag: 1760710364-451206
X-HE-Meta: U2FsdGVkX191DuWxCi5fTENljt83fJz8Yx6TU/lBvGSBIF799o+ZpE+BqdrhFUX8VhzLgXIR/EEmVfF1kStm2OaY3YChtopbyYlHzXfF0Ue2aRRZjooqn/vV+en3n4f1bQi+mNxdBcdhx6kmJCE0nvY81exRUfvNa2i7hvU6Y/CpWQMZ0I5Tn/XXJPRMM7elFJYCw85+sdca7g/PKyU8cizWsZSW0dX6zvK3Cti+h5wF7Dn8PtfbWHcOVV+zKo7KA2+0YS/8we6rIcRXSQTiGkjWc5W5XUd/WrUmTR9LJAB8g3317IjT4GvzONLho1lImbHPcdaIjoiHbaX8FzKSuzdM93bBX4Yi4IgcoT9cUmUA4Ol7I5X7ihGlAZe8I1p3RwtEE/gLTIw29HV+oMmDqtDXklrXW+4mslLS5gnGLHSNk3eX4X1rdV8c9cI4FQe+ox5oUM/csteUXyChtrg5tINRrC6JfzRfUZ+dDcpdnoL1O/qhYirP3Mk+JuS1V3+wc1giz5DuIWulkzignX68aQS2Zrb+Jxq2+GSX62IUfgWDuq1QvxmLYlsxtJwy3KPOmVhyDfJ83b0LbfevUxee3sa35LhOTwIlpQpkFxppwIp2CPK9Bk890efQa6CLTah0lX2aRahw0N7Kmb26F61movh7aHGOWDvkfRsNWWx8xSgALIU+yk2kgQe9+SFvkqavSj5x5fmWWqhJqeq8NY55n9aI0/52080ed8moayKNlAq6XPolCpRw+AD7Um0Q2k3urC0s/br2jbo/+nAh++IFRwUbWazZEC++IbaGM7CcPdcaFXKr+8sDpBYkNNSp/d0x4GkBX1PhCycckr6z+dymlSUOFJlqhBIjvFx2uQsBQLg4EZUmQdCy5VF515mA6BoB+nJuNSLeYAFbnOCEoyfqTPYNwVqAyEpvwJTscY1jeWtQohox4OZ7PsjOFexvDnCV/L0OPcXXM81OhJWz1nk
 +yQysXVI
 ICwwbalTA2hARnSfbWB+XZEpFjOp5ZKVBDZ6Ly0w8KIF7STM/RCRfcjHuYKOWM2ky4krZfvCxNsncJpdrWkRwxX8Tkz9Ec1mpl3N6gOK9FQv/tz6w23eM578u1M+lpv4c1i1sYjFlFqiiiI/pK6u7sHLZPzjvAZX3iXiYUlezx6578F6OLcu1TBmMFCdpWk7IZbVmUJG6dZUu5d+eI6hCthhAkN+VIgk2MlCk0UjrfF6zpyxTBJQDfetPsBYq7ZpLLkZ2WtAc4b3EdeH7936bfCOydgIhE83ZVyeB4kL+60iOt3PoMy2DzftNbGA4La8dZEyVjc3ZuwY3t0/H9Qo8t1w2LS1NZFmKdLj3/pQDyKinrh+vIwG6dvTFChS8XxPzTvJsYwEednRoX8YG7YusffQpp3HUqDJcWhYF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/17 5:10, Andrew Morton wrote:
> On Thu, 16 Oct 2025 09:00:34 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
> 
>> On 2025/10/15 23:32, Lorenzo Stoakes wrote:
>>> On Wed, Oct 15, 2025 at 08:35:14PM +0800, Kefeng Wang wrote:
>>>> If the folio(even not CoW folio) is dma pinned, it can't be
>>>> migrated, so always skip pinned folio to avoid a waste of cycles
>>>> when folios migration.
>>>
>>> NIT: 'when folios migration' -> 'when folios are migrated'.
>>>
>>> Maybe worth saying 'due to elevated reference count?'
>>>
>>
>> Hope Andrew could help to update the changelog.
>>
> 
> I changed it to this:
> 
> : If the folio (even not CoW folio) is dma pinned, it can't be migrated
> : due to the elevated reference count.  So always skip a pinned folio to
> : avoid wasting cycles when folios are migrated.
> 

Thank you Andrew, since Lorenzo/David have some comments, I think I need
send a new verison, but thank you for all the help.


