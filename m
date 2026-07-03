Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6B4FC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 03:01:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7B906B011B; Thu,  2 Jul 2026 23:01:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B53C06B011C; Thu,  2 Jul 2026 23:01:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A68B36B0121; Thu,  2 Jul 2026 23:01:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 78E2B6B011B
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 23:01:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CFCF8A03EC
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 03:00:59 +0000 (UTC)
X-FDA: 84945963438.20.B15B84D
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf19.hostedemail.com (Postfix) with ESMTP id 177DA1A0002
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 03:00:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=jwVQfYYX;
	spf=pass (imf19.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783047658;
	b=l4bsc7OG5Tw91iY30OrOfCECpd4SbAuiaUZ1Oo+nYg+C4OmuQrDq0RIh8448boWlay8ag4
	s+anfO/SKXyPl/S88DI0XQ7iocGpCFoXInXZLmXFMBqBhjdl5Tch6oG6A7e8QteQlMdUsf
	0pgCplC153tmXJm98Yst04dTVsaThXs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783047658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4bxq2yeKxZGnAf8D3UK3N3gyeY1jHATYeTe9AmeYXsg=;
	b=heGiCLjGU0qU8bTQ3Sw8ESb7Bqo30a3bbOm8UZ6MaTLrnzBWP6EeT1KCoeGiIERHv9vkrF
	v7QzFNeu58VCPMgiAwGDfIi2N7ueFEue6iPyleXKPxUWJMqijRZImF8tz9p6ErbFMCEtQS
	VfHCZa6NsKsWwvnA2dAZimaPFpcV7c4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=jwVQfYYX;
	spf=pass (imf19.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=4bxq2yeKxZGnAf8D3UK3N3gyeY1jHATYeTe9AmeYXsg=;
	b=jwVQfYYXk4TTuhdrDvt53GPiM7wL7RYZTPRovI/DjV/PaigRmtY6FAhXhIOY6TlOvAw0u22sX
	ZVo1D/Cqynjq64QjVVQhKejgIV3qmJyc8IkD3D9hXOYKl6rqU3DdB7W4OlIweO8lnS7mWzVlSh3
	2WZEf5VwYRGfPvhBsUVgKVc=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4gryvF5L83zRhWb;
	Fri,  3 Jul 2026 10:51:37 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 31BC940561;
	Fri,  3 Jul 2026 11:00:47 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 3 Jul
 2026 11:00:46 +0800
Message-ID: <5a4fc514-107d-403c-9e22-a25660651700@huawei.com>
Date: Fri, 3 Jul 2026 11:00:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] fs: stable_page_flags(): use folio_test_*() helpers
To: "David Hildenbrand (Arm)" <david@kernel.org>, <akpm@linux-foundation.org>,
	<ziy@nvidia.com>, <luizcap@redhat.com>, <willy@infradead.org>,
	<linmiaohe@huawei.com>, <svetly.todorov@memverge.com>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
References: <20260702110614.2176986-1-tujinjiang@huawei.com>
 <61157b05-b22a-4bcf-942b-05225837b57b@kernel.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <61157b05-b22a-4bcf-942b-05225837b57b@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 177DA1A0002
X-Stat-Signature: hg6p1n6km3gxwz1wabqead7ds1j1537f
X-Rspam-User: 
X-HE-Tag: 1783047655-111008
X-HE-Meta: U2FsdGVkX19Cui02qm9wM5BxGXQ6IjYsF9koznVIucmuOXpnmjjc3iiLYrCKyHSrD7yv9riHP42GvIuF0dndORU/FlLqhhLEz5iy9NZvGiQRaMhpXvQDH9qyjleFU0MV5yPAz1G+NFZJuTj0JSNa/pk9Ule+eixqFyrPHnUTd71Y9MTL6eopsX5VjFUlQwLcB+AbZOS9p/VUJnQsAMR8HPXLZRW7HxoeFfuuEbTyA/OgJrRWjpRJgWbdp52PItw1byxyM3HBajStjfQhMxpM2FVx8X3qccdAPYz7gDv5kWGTBNMhmhWLWgjGk+q7d1Q8cHHs9KmAY5R4RM8cZgafadyqG7+TvP/duMloOFVQnoCmhOya6DPT48MM1IWGnUcjarmcTJTHocZg68qMS+hIGL6xZovGzWyKOSwn6l1+NSsfX6lmXt/gD+r32SfxPRYiywef9ZKqTysDNbZREOUPv092sb1MIYYsFbvC24fOgmaEQN1CDxFjH8kzCx727G2aZRpMiA+Y/q8BcVWi6xYnxkgE07bYJCZ2RlwCeQypQPnyb+gN03erM1oShrk4QprVinO3NDlnfgqTaJUtBk/wl4WNSEP9WnbABPfiegfgdh23ajBugeXJ+Yh9nTF/TUpa42wk9ofWMo22vHiO6W5+TAKP6WxIt54LEt7Tfxk5dtJ3GDejdPXWhy5FR7ewIGCTRx78nrkouzWB35i9TbrkoUE531XldgN4HnncS40C4BoOBcgzj6QYixSbP1KySwHQ7jr7TRPjlI0lfR/xcQPSKW89mWNARy4kUF0ZCq/UCRrYSONGy45HTDT528uy6G8XGt1PLn1roehVvbr5mb3KRRCrCEK+bf6EBsO8TtBtPAN6q715DcDDjC7GY7Pp+t6/UyQJnzVIMU4JUNDDG15F/Yp4tmgSkaEC+Xf/m9aOt+VhNEOAoXNLLHESrBngEUAESroXz091Bq4uEuYZjiH
 J4U3cPn4
 /6b/n4hop4WqZxfahIzjXJE/XemvqC+I0vApKaocrkzTCl49ArizpuPqFp154/yAeo7UdrCbrxdGcFnXlU5Px9HCAI8yk0jo++bv80Bra4fDrL62UQdLSuJwXm/UcXpJnWGfx4rlrtjq7T5++BcH0feM51dUzPKkbbEbXBg6NTtM30WieOMiPFaEVnJXDsMJGkYfAobgeBRgh60gcYwvLIYl0CbZK5HXV/kuM2JI319cvXdqM6CwYnAB3X26PKXOxdczRjqziSpu3Su0+QFlIabJvgji+g2x1tKp8e0ELaI+gsxP9sYpZ6if5KGEO/nfcrckvrbOh3nyMFjuSuIcx7bOzkpESa7a2YYE562m4vqIJC5gppRWQTVAFrJLLL1seCNWHikwqGQoEmiGoT+mtudnxn8uB6antMHQ27Cj56sjZjUqZoEgnL0KHvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/7/2 20:03, David Hildenbrand (Arm) 写道:
> On 7/2/26 13:06, Jinjiang Tu wrote:
>> This series cleans up stable_page_flags(), removing the remaining direct
>> flag manipulation and replacing with folio helpers.
>>
>> Patch 1 replaces the "1 << KPF_*" expressions with BIT_ULL() marco, to
>> avoid -Wshift-count-overflow warning for KPF_* values larger than 32.
>>
>> Patch 2 replaces direct accesses to folio->flags.f with the standard
>> folio_test_*() helper functions, which cleans up stable_page_flags() and
>> hides internal implementation details.
>>
>> This series is based on [1].
>>
>> [1] https://lore.kernel.org/all/20260629033122.774318-1-tujinjiang@huawei.com/
> You should explain the history a bit, and why we converted to the manual checks
> in the first place.
>
> Now that we take a folio+page snapshot, the values cannot change concurrently
> anymore.

Yes, I only metioned commit 476d87d6a061 ("fs: stable_page_flags(): use snapshot_page()")
in patch2. I will update to explain the history in detail.


