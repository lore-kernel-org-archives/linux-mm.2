Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60483CD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 02:33:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4177E6B0088; Tue,  2 Jun 2026 22:33:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C8716B008A; Tue,  2 Jun 2026 22:33:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DDEA6B008C; Tue,  2 Jun 2026 22:33:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1F8F46B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:33:16 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6CD3DC09E5
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:33:15 +0000 (UTC)
X-FDA: 84837029550.07.638A0E3
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2795A80010
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:33:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="pwX/FwLf";
	spf=pass (imf30.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780453993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vHfwDEtQrbN077pHZVQUB5kFtwZn5VuD4rouby1Sq5g=;
	b=nTD37vlTogmwuHUHJ3GdvsbB5qPZEDzOmlKilypY6dksccDrnOwjeJwm6/oqhkrVeAyC4z
	HJRBPUxi534oCniBM9mHcEeXryhbBT28u1/vIxS6UzjIfpiqVZy0Tyvwag0A3vN2IkwYd+
	wwx5X0XPau5Bbrpu3w3phbCjkL5i9RM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="pwX/FwLf";
	spf=pass (imf30.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780453993;
	b=Bx9ZZ9VEzNc7rY9Vsas7eGnbDmWiiuGUZunZ4yi847VWVEKoBbtrPWiCyKgB1qkrriJzxz
	wlAgBJxydZXKv+OZzH0dMg5Ni4YDTEa3lzjmfyl7tX8GYsB45lKQVbuKhkBNos8W4uSY+k
	IIzJBeI9P2hizQKPZ7ylSXH4ryGlPIk=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=vHfwDEtQrbN077pHZVQUB5kFtwZn5VuD4rouby1Sq5g=;
	b=pwX/FwLf0Z0XWLY+UYZMiEDu+1GHWfGUE1Huc+mqnyYOrAtgLxqd0RgdXNo+FHJh9qG5TIUMi
	E6mb5BguU2Rz9q+HAndfUbJxHJQ7mYX7Mr1xd/82ZssGY7/3eoCkwycweLyjsXKk+0TDtst8NlQ
	FmoI8h8zSR5GTRxLdxsJSI0=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4gVWkj28JwzLlXL;
	Wed,  3 Jun 2026 10:25:17 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id ABD1740575;
	Wed,  3 Jun 2026 10:33:06 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 3 Jun 2026 10:33:06 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 3 Jun 2026 10:33:05 +0800
Subject: Re: [PATCH v8 2/6] mm/memory-failure: surface unhandlable kernel
 pages as -ENOTRECOVERABLE
To: "David Hildenbrand (Arm)" <david@kernel.org>, Breno Leitao
	<leitao@debian.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <kernel-team@meta.com>, Lance Yang
	<lance.yang@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, "Masami
 Hiramatsu" <mhiramat@kernel.org>, Mathieu Desnoyers
	<mathieu.desnoyers@efficios.com>, Jonathan Corbet <corbet@lwn.net>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Liam R. Howlett" <liam@infradead.org>
References: <20260527-ecc_panic-v8-0-9ea0cfa16bb0@debian.org>
 <20260527-ecc_panic-v8-2-9ea0cfa16bb0@debian.org>
 <19f968f5-1289-f573-4406-e5c91dcd8923@huawei.com>
 <e3d023f1-ab6e-4424-b304-55f1294480c3@kernel.org>
 <33ef8821-c809-b7d1-ea77-6e8a07a6e784@huawei.com>
 <21732071-14a1-486a-951c-34de97b7c757@kernel.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <4b27467e-935f-5587-2f48-5a794c30a592@huawei.com>
Date: Wed, 3 Jun 2026 10:33:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <21732071-14a1-486a-951c-34de97b7c757@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2795A80010
X-Stat-Signature: cf768xeymr4smjyecyf363izppb7rmxb
X-Rspam-User: 
X-HE-Tag: 1780453989-193353
X-HE-Meta: U2FsdGVkX1/I77D6mJZjS3D0dQ5Gg4FJ4sg15EM96SDrn8bCL7Vjv+/AoNCiKskx3pzuYmUiYDwwpXJlOQ68Wd5oQ29cfW3X3a/dOcVE79RJzJUgDmRXbd0D/JgFSeJqr8wCHoAQV8K6SmXaa1ZgcHwaWvrQ9XLkfRZ03oxlO+o2IKMosLlf/HFgroq1YaFc9hTatKbZZTy53YB9tOj/F66LWuAlnD6DGGAcii1LcdA+dWfNfTodKqqp0+gZb1B2ea7DILwP1xK+fMorfmG+PGshr/5ZyWR3b/ELtrlnXA7ZHSwmhArIDQk52oVWO5lXz/AZs6LkTDWS9eoBtYGvZboeJzYJdVDWJcYIC8uL2zoU/n/GpwUGTDoGoomjeRvcIu9ZDddTVkgdAV/8F8eilEr6R3ZwWYADvANdSturY3IPFUm4Db01Du0OI3Up5dD2HSOBvpSCeJHcVz5E6fuoj+X1JgXp5jbXIMx01mtbfEDmkJomSI+0MJJgO51BRjLE6XBf5CwE2saQmOxkbhjOYvoKYdgEQREEShN9GxcFd53LE/QJZ45T/tK852htEhvjIQEslWqJKu0ZPb6HmWrqwk6vNMLM1+6GYJN4GwCrBGyBnqk6M66nHsKL6CJ9ro8GejJPUIADzMfCdInQwhJjylDdyXySmRX48WNy0ZauEiAs6lgrIrF1mIQ0DGApxkFJ7qycmY9CJ6r6FMoPz5B+jKgPXWZopjcqfTqAeIGPZHg99IvNzwwfyXjf16pLbKvNUvjyEzvjizsTyAwb0gcpXbHbCl5B48pGKNOEeqLhvgOP7vai/RnTk9+U0jPizb04zjuWwrhbxXM72tZr9uiEXRxwdf9AozDbjUz3O5mTSIFBrnqNNJxO3fM9fNjH26GXAGUweIKRq5th2Sj9Vp2Plz+Sw2NJC48w1c8fXIJc1CoO4rXxpFIi1Z5R3P3/TLApX25NvZHlMXEuu+jDFRH
 WJ2BfGIO
 3MiBr/81vQDLFeIg0i93wEserooFD1GpEBzXABVgC+C+mrIwwmCzq4U3TSY3aZV6zk8kaXfheTDGZFdhIhB2XFB7yYBNDOVIhcmWsv6mbMEGYqwov/WFRy+7H/wvBaSWIqeXPEgRKUtGmeU1iN9IaarLmkBdlxrI4taxPCkUe/v+SaNCJ9vGC9Tv0wD3dbstroAefG49c7trZUfMVcbFLqC5xM931lveI5JY0KV8p18MCjsEbqroPMD/bn5pZz/U9s+BURVUO61YMT8+K+r6HQQIISzDuCqHlorc/Sf3XddD9OO0S3FX2B8kseTHLi6a67EWpnxVkzSaVEkDLNer4Flw9Egnttr/1x9Vj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/6/2 17:41, David Hildenbrand (Arm) wrote:
> On 6/2/26 05:08, Miaohe Lin wrote:
>> On 2026/6/1 21:22, David Hildenbrand (Arm) wrote:
>>> On 6/1/26 14:28, Miaohe Lin wrote:
>>>>
>>>> Thanks for your patch.
>>>>
>>>>
>>>> Once shake_page finds a lightweight range-based way to shrink slab, slab pages could be freed
>>>> into buddy and above PageSlab test should be removed then. Maybe add a TODO or XXX here?
>>>>
>>>>
>>>> I'm not sure but is it safe or a common way to test PageReserved, PageSlab,
>>>> PageTable and PageLargeKmalloc without extra page refcnt?
>>>
>>> Checking typed pages in a racy fashion is fine (PageSlab, PageTable,
>>> PageLargeKmalloc).
>>
>> Got it. Thanks.
>>
>>> Checking PageReserved in a racy fashion is fine as well. TESTPAGEFLAG() will
>>> allow checking it on compound pages.
>>
>> It seems PageReserved is not intended to be set on compound pages. I see there are PF_NO_COMPOUND
>> in its definition: PAGEFLAG(Reserved, reserved, PF_NO_COMPOUND).
>>
>>>
>>> For PageLargeKmalloc, we would want to check the head page, though. The page
>>> type is only stored for the head page.
>>
>> Maybe we should check the head page for PageSlab and PageTable too? alloc_slab_page only
>> set PageSlab on the head page and __pagetable_ctor uses __folio_set_pgtable to set PageTable
>> on folio.
>>
>>>
>>> So maybe we want to lookup the compound head (if any) and perform the type
>>> checks against that?
>>
>> Maybe we should or we might miss some pages that could have been handled. And
>> if compound head is required, should we hold an extra page refcnt to guard against
>> possible folio split race?
> 
> Races are fine. We might miss some pages, but that can happen on races either way.
> 
> 
> I'd just do something like
> 
> if (PageReserved(page))
> 	return true;
> 
> head = compound_head(page);

If @head is split just after compound_head. And then @head is freed into buddy and re-allocated as slab
page while @page is still in the buddy. We would panic on this scene as @head is PageSlab. But we were
supposed to successfully handle @page. Or am I miss something?

Thanks.
.

> return PageSlab(head) || ...;
> 	
> 


