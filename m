Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08102D3CCBF
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 07:55:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 405D06B0088; Thu, 15 Jan 2026 02:55:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B3AD6B0089; Thu, 15 Jan 2026 02:55:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C04E6B008A; Thu, 15 Jan 2026 02:55:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 181D86B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 02:55:38 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BE752160227
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 07:55:37 +0000 (UTC)
X-FDA: 84333438714.05.3900D6E
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf21.hostedemail.com (Postfix) with ESMTP id 643FE1C000E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 07:55:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=1aXwVL7S;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768463736; a=rsa-sha256;
	cv=none;
	b=eyshOWzo23u3UyrktnpZX/4ugEjq8FSiCNnycEk6e4Acyk4QPgOU9/zaxYNMgcU2MvioIx
	VeUsgKF9mudMLpM17/EDs0m/ttlcQIXtk5WaZAC4Xd5hvoyQQ4tEvj3F51mGU1hEbjYGJC
	yR7h12MUoY8JW2EL39w6T6yFWc8+i08=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=1aXwVL7S;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768463736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3LCkFVnIN3e5GhO01onT+0WWHPAZo4gI38LP5FKzlZQ=;
	b=kzaCdpEspvqQo3+Xc5mFyUc/xXploLR/u6LOQtdbvpu/UYPo0FXg+ZEKhWiWBncwG+XRGx
	2TfQgJRXGQVS4uP+52WuOJ7pgFpDGdpVszWJvyXhIWXTj4+ejSpuP3sJF9lFwIu6z95KNa
	L+q3SJ48BsG6WhYfbfcxRbU5XwaBymo=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=3LCkFVnIN3e5GhO01onT+0WWHPAZo4gI38LP5FKzlZQ=;
	b=1aXwVL7S63gAymZoQFKJ1etYX4xbsWQGN/rs/tZolZWju0V3gBptFEY4UO32fvMe+Exn9Cv2k
	4ZUhiGJBHOF9ytXG/wzoVA6BpJyWZTzDxYxZWd/3Qk0aaVujl1JcPvUr910PwZjcMCOUQnCjNEx
	sK8e7k5vNsyaUGu22M5Vtuo=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dsFZN3hGtznTXb;
	Thu, 15 Jan 2026 15:52:28 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 3603A40539;
	Thu, 15 Jan 2026 15:55:28 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 15 Jan 2026 15:55:27 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 15 Jan 2026 15:55:27 +0800
Subject: Re: [PATCH] mm/page_alloc: Fix freeing of failed-split poisoned
 compound pages
To: Boudewijn van der Heide <boudewijn@delta-utec.com>, <ziy@nvidia.com>,
	Jiaqi Yan <jiaqiyan@google.com>
CC: <akpm@linux-foundation.org>, <hannes@cmpxchg.org>, <jackmanb@google.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <mhocko@suse.com>,
	<nao.horiguchi@gmail.com>, <osalvador@suse.de>, <surenb@google.com>,
	<vbabka@suse.cz>
References: <54CB622C-0BB0-4772-A939-162D63433A00@nvidia.com>
 <20260114144824.69960-1-boudewijn@delta-utec.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <be8c25f3-8540-6c28-e2f1-8034118ef04a@huawei.com>
Date: Thu, 15 Jan 2026 15:55:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260114144824.69960-1-boudewijn@delta-utec.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Stat-Signature: 3o7z6nmdr14mojzxn7twza66xbft1bi9
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 643FE1C000E
X-HE-Tag: 1768463734-208507
X-HE-Meta: U2FsdGVkX1+hdP5tAdK4youph22zoytvA/EIzwoVMLJMBx3njcQlg3GyCgfNfMyOIU/OTJi9FmiwlA4UiA7jX3pMnUc71TnocTdVKJGHxn+dWwNTjAXqA4UsG/jcN1pXpUDTa0DcHRGWgCPEZETmnRf3u96kOJS39TYr17Ldr9zRLlevDpGYZsYwD91mnr8qNrhbeE8XzW71jX6PBPQ1gJymeLmrU5nCvEQk0tEAQAO4Qya75cofE/jlNa9NyTPxX2y45rAbvhWjtr0uyhzqHlDme2UN5t7Dto4sBMldby/cANZEwcVpt6ESkMgRWehzrjJtXtw9sJyPfMBVf4fA0b9OUAs166ynFoqtBon9vlcaxkvTa9J0UpoLvmw7KU71iqQGvxu5W4CmC9oqaTd6QYuvYfBgXsHm4/+2m+750WULJrGwLbHaCjRPriqyNJDItxS4UXcK1QRXnBOtHG6IN903eGW7rnbj5xtuaRyDLlt7iX1hi9fs4tW5/glfd/eZ1g9wDOcj+bm1mgA3XUDt6tivBHskpeWE0TTT8mCHu8uiDfxyJ3eYViiNOv/ICWKDoUci32SQ3hT+4GDAwQGkdQ/KklrV91GeMiBE5pYoqvIMGRUptlOFt75aMyXOjwOaaN8z547oOMxxtv6LnXIVIM1ulcEdRxIAJobKACLWki8Fuqa3nGJFmTrzJPKEj5YwyGfl6B1nN3IzPaT4Egns4+0RqPm8IHaKffGd4Ra5gkLm1yuB/nFz3n2UzNpHTFm67BTKzj4hixf1KO9VQ1kyOJufvJy9SgG4JPy/D4wOOu/sGgd75pin7u2X/CfU18365zSa8M1WtmVO1T2ahPin0PEKAQEQcLL87n5FdsBviUn+/UZByiezRCScofmWmwzgjratPYIVmrZB/lVbEmnC3V9103PGFSfqdwMUtcLOLaRiXTWmk4MOBPTjgkGMB9tEU0Eas4D1vqIM8PdCzFf
 vxoJP5FM
 uVtwhFFrNZLI2uqojV2enz/yFCW39o0WgOJC8QS3Sx5D8UunRAzUc7zfzniqc/gdaUENZW1BHgAgRZnw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/1/14 22:48, Boudewijn van der Heide wrote:
>>> free_pages_prepare() only handles poisoned order-0 pages.
>>> In memory_failure() (hard offline), pages
>>> are poisoned before attempting to split huge pages. If the split fails,
>>> the page remains a compound (order > 0) but is already poisoned. However,
>>> Soft-offline pages are always poisoned as order-0 after migration, so
>>> they are unaffected.
>>>
>>> The '!order' check causes these poisoned compound pages to skip
>>> poison handling, leaving them in the buddy allocator.
>>>
>>> Worst case, a poisoned compound page could be reallocated,
>>> potentially leading to crashes, silent data corruption,
>>> or unwanted memory containment actions before the poison bit is detected.
>>>
>>> This patch removes the '&& !order' restriction. Cleanup functions in the
>>> poison-handling block correctly handle non-zero order pages, making
>>> this change safe.
> 
>> This is not a fix. IIUC, for >0 order free pages, memory failure uses
>> take_page_off_buddy() in a different code path.
>>
> 
> Thanks again for the quick response and clarification! 
>>From my understanding, 
> you correctly noted that take_page_off_buddy() handles already-free pages, 
> removing them from the buddy lists and setting SetPageHWPoisonTakenOff(). 
> This prevents those pages from re-entering the buddy allocator.

Thanks both.

> 
> My concern is about in-use THP-backed compound pages:
> 1. A compound page is in use. 
> 2. memory_failure() marks it poisoned (TestSetPageHWPoison).
> 3. try_to_split_thp_page() fails.
> 4. The process using the THP may be killed; 
>         the page remains compound and poisoned.
> 5. Later, when the page is finally freed, it reaches free_pages_prepare();
>         'take_page_off_buddy()' is not invoked in this path.

Yes, this is also a problematic scenario for Hugetlb HugePage. And Jiaqi works on
it now [1]. I think Jiaqi's patches might apply to THP scenario too. Add @Jiaqi to
verify this.

[1]: https://lore.kernel.org/all/20260112004923.888429-1-jiaqiyan@google.com/

Thanks.
.

