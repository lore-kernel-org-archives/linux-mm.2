Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42508C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 14:21:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C498C8E0005; Tue,  5 Aug 2025 10:21:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C20BE8E0001; Tue,  5 Aug 2025 10:21:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5CFF8E0005; Tue,  5 Aug 2025 10:21:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A5D908E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:21:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 618651DCEB1
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:21:28 +0000 (UTC)
X-FDA: 83742916656.01.4E63370
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9C99C40014
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:21:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf04.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754403686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aqH/BUamZOAeUKaT5AdUV716S4itaV2KPkVk6PexNlk=;
	b=QhuxifN04nPZh1X5HN81R4oTXoSQSFeo/QocXkzmIeEw/W164yuX9n+jTXYJgqFpL8PHa5
	iLRrN2RJRuDyiGkHiev/hFv8goCUEwdQEBxg3ozYaW/BmWXWjd26Dzj9BDWiT7s2ftgSus
	k+sctam+kHqgU2agAIzOmXWE33oJcqc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754403686; a=rsa-sha256;
	cv=none;
	b=LqZyGPIH91sDm6Hx3tBl/2yPEEV4Twz580l/l40zWjmSeQ9Pcg+eIBKGa8rUjCaTMayGRR
	IlDshnTXl0Uinh16ZBwxP5BkJ2YWOw1R6vdOztwyKgDwqCAvJEJkLxCvMnZkqnhpe6bnq0
	DwP9dgICIT+yQMjWpaU3Yc1GhFjyJNM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf04.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4bxFpb4m4Fz14MGL;
	Tue,  5 Aug 2025 22:16:23 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 8BB8418007F;
	Tue,  5 Aug 2025 22:21:19 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 5 Aug 2025 22:21:18 +0800
Message-ID: <d59a21d4-8a7b-4194-9616-53c6ffe0cf8b@huawei.com>
Date: Tue, 5 Aug 2025 22:21:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] mm: hugetlb: convert to
 alloc_fresh_hugetlb_hvo_folio()
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Muchun Song
	<muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@redhat.com>, <linux-mm@kvack.org>
References: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
 <20250802073107.2787975-2-wangkefeng.wang@huawei.com>
 <aJEXvnrvaoUPvD2l@fedora>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <aJEXvnrvaoUPvD2l@fedora>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 9C99C40014
X-Stat-Signature: m6xuz1pptgbfkid66cdd73i48rj5f77j
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754403685-108675
X-HE-Meta: U2FsdGVkX1+seaJ91K4Vibu9ok0AUc1s2UNBjXwJgSWCXwpyM48dOcKDQlY7rKo9fN0DI+zGzMn5DSdOWl8OOg/N2epuoxKR1GlN7OFhl9TTioqSTi7lSjhs4H6VWAi0eYNVjHD7Hnmi/3Ip0UOYhohCXixRaJft9OdGUdYMUUKOBGEhgf9P1CNEqxaWljgB9deBbdayWv9ZBnD8Kb3JITCvmf5FWLSu+RY5qp+hwt9x58RpuzWUVxtbcWeVozF6gNip0O1z8QqlffbvygqAxqAtn3DbhE6wRGDVftRjxa8mlAcw+ELpAav7sJE2NoVlUdae3DsqY/1/wqwx0vms0WTpmdDe8L+ziSTeXeO8XuQsdIPmvd1DZfo/l9l2TkGSCzhNVdkkeqp1pAPuunvneX+tJWDE18FbbDztaqYCakMJ5j0ohO6Xa45zy3Myuo7RJQfZNKPrgw77hO2qHBxan58AOMm6Dq4h7hlMSP2X/l4f8QoB2tILLYFSjFoOKCmn9W+rVmSlhbDIoTo9k3aSertDgVIff+5JHyGU1WGXsUzUQZgCu+chYYnVMAf+L3RRAO2AyZqh4MSdVOxL6/LU+z2jEEd457LOh5rpjn+Peo2hknUlPvMajG3kNz2nZTA8DpriMNhsRjLffXfHllUmd4VeI0Cuj6QZgEJairZK0J6XOLSXdq2mzuulOGmNyw/y/UDsaBKNvYegNDN28YMX9UD8PmPUM9ibaAVZ6makz5M/HB+SoAfmEZMiAratOiwZ1VWaJys10FLYMzLkbFWmK/xEhMTHTks0B7GYjbWljRCw3le5nJZFZajkEARPLMPTaZXjwt29/SupFKDxhgNKbFpGmA5ZM3neTZF8uh7B+siKxWzVbeoHMwb41DjLZYzP3qYYnV5153Mn+MAPKUXaJmJNrNoDYPwhvnWQ6GldSQmFZBoEatYzS/B8BwBW3a2JyKrHwyh58Kn3Zf+qVND
 7rlfHYqv
 xMRVpWmmPZOa3Uw6g6prDVA+nVZz1p4JxCeUJ/NHcGujDqAeZ89PtZ1ZHyytE+acFHmzKwsCoATA4/uQocG5rI1aAVCBcUKchMRXv/qCrwwnjCpnJQ5iS6zUSIte/ZdL7XAFMZdT8N6N05ETpFizQvnMFSsgze03VnZYuYbGqwaIdY0VPNT7k40IAuwIj9zVuqeUTsnGOrs7HlC9rZv3A77PiK/os/34kBX2uNd6d7sTbW88bttA/G/17te+uwz7rdc4APhkD+cyW5BTPpfUeFujHJZafVC5qRnDPUFcZSnZKZ7IxZx7kXCJCXn3bK7ZosHcMdVwtJ7nfmhk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/5 4:27, Vishal Moola (Oracle) wrote:
> On Sat, Aug 02, 2025 at 03:31:01PM +0800, Kefeng Wang wrote:
>> Now alloc_fresh_hugetlb_folio() is only called by
>> alloc_migrate_hugetlb_folio(), cleanup it by converting to
>> alloc_fresh_hugetlb_hvo_folio(), also simplify the
>> alloc_and_dissolve_hugetlb_folio() and alloc_surplus_hugetlb_folio()
>> too which help us to remove prep_new_hugetlb_folio() and
>> __prep_new_hugetlb_folio().
> 
> Have you considered renaming alloc_fresh_hugetlb_hvo_folio() to
> alloc_fresh_hvo_folio() instead? The word hugetlb is already a part of
> the hvo acronym.

Maybe THP will support HVO in the future, so I think we could keep 
hugetlb word?

