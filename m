Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01F50D6ACF0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 12:01:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B53B6B0088; Thu, 18 Dec 2025 07:01:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 638826B0089; Thu, 18 Dec 2025 07:01:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 544E76B008A; Thu, 18 Dec 2025 07:01:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 453D36B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:01:00 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 674CB13C39B
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:00:59 +0000 (UTC)
X-FDA: 84232450638.16.20CC953
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf14.hostedemail.com (Postfix) with ESMTP id C8F7810001E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:00:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=tlnmpLI4;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766059257; a=rsa-sha256;
	cv=none;
	b=QLJKWCYIDfC+kd3nLT+OmWQ6ic/hG7uR2UcfosJmvUcLRnEzFCeMkzexLB6M3RyfNj13fB
	l4jGgPZPfqyGgVgx/7Z1olTMX4wThNT3Zl3abHibtJ8IWkH3sIleaJHuDKBGFlpdUqufqK
	6L+PvNdYC4+5UOmk1raOojuqMJOzXJY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=tlnmpLI4;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766059257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cIFPOhz7VsfpNMMAsm7Rks9dHbbKx6tYuI8Klyc/lJY=;
	b=FHkesawzY/WeBz8+TUwfk62OrLQsuoV9uMH9f4W+DIJ593DGOC+frGKKYiNdt8mBCDx8HG
	VWxVr56oTcOCkUC/GHwb7PvXK5O6ajd4o7JOeC6QdDB6giAqe8DTHxyQVg0Dw3Iyl5voRl
	aWmeT5msgquH0Bp6SWbTOleOyG1p1cw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=cIFPOhz7VsfpNMMAsm7Rks9dHbbKx6tYuI8Klyc/lJY=;
	b=tlnmpLI4wVtXl8lrVzu+XqH2t7H253r1YIuCGr+SuLZJ77ojHk2mOm+OcBuwCAm3vzVTJDGxN
	nWNbQTmBYf2VCWDD+NKCeuaR7NADoP0ey7PY5rpA3TvuDXHOowkKpNtsy82BHZrUQDbhFwpQjqy
	xUgn8wnddJL9v/ERSAfE+VA=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4dX8LK4njjz1cyPb;
	Thu, 18 Dec 2025 19:57:45 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 820271402C3;
	Thu, 18 Dec 2025 20:00:48 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Dec 2025 20:00:47 +0800
Message-ID: <1d2aa607-7dbd-4116-8b45-8b2d9cabed7c@huawei.com>
Date: Thu, 18 Dec 2025 20:00:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/6] mm: page_alloc: add
 alloc_contig_frozen_{range,pages}()
To: Zi Yan <ziy@nvidia.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>, <sidhartha.kumar@oracle.com>,
	<jane.chu@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, David Hildenbrand <david@kernel.org>
References: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
 <20251216114844.2126250-5-wangkefeng.wang@huawei.com>
 <D90F7769-F3A8-4234-A9CE-F97BC48CCACE@nvidia.com>
 <d7275c36-f5bb-4baf-8a94-b8522d4aef21@huawei.com>
 <AAFDAF36-E02D-41E0-B40A-AA5BBC084F9A@nvidia.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <AAFDAF36-E02D-41E0-B40A-AA5BBC084F9A@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Queue-Id: C8F7810001E
X-Rspamd-Server: rspam10
X-Stat-Signature: 51dtnh6c8ecwgoxeqkdphutijwkuz6u9
X-HE-Tag: 1766059255-478526
X-HE-Meta: U2FsdGVkX18wNR/0gVt3rK4/LgXRoW9+AQWIG2FekHNRckbzop03XaerzOYsZmfMXMSeTF0HGYYkpFh5X0idhjDIs0RM7+a9yS3ykSW/0PSy7qbvsXW18hxWoA5OW6nAD6lMmBzfgVwaUewL207FQwyhFTUO89jDQFhqmn816L0BmCcUyYvn4yblQP2cUJB8zvgVlMZw7lo0uqsHskZ4MkZiAFiiEiWMXer6DldwTb1IZqaSQh/0G89CdIjycQyhnWtfTdNfE/VcqXmZL8j9asFN7tbkKSi2M9m7DoQ/Ht//2XrPTuCHWVnO1gneQ64f/6+8IQZzKZJyUf2jTyYOQDhwbu0TXqV9CjP8eA6KM5ZstRPO6vDv16rgPddM91ftw5/exH/TB3rn6fI4L+9fS38lDMDP1B9RLfGahXZSmkD3MyvdMSHSkvaffHsu+3zmdzSQhWHIjbKGIhrcEtbaom53Qh2SgLIWAWoLtwRo6nqkICpSJbl1gargD2OBQaZnWkgsx7cozn9imrDo5gUiJUzOY6cwHGS4fnUhEKS4GtE5S3ZWz839spKlQELUAUYH5dlBLFS+GW/QRWCGOVEv6cZj9kWjGZYw4mjDx9uX8EBdbQksnzirJV+jVaVQdmySviJka7gjDNqNO4lBg6Px+F3oWafN+1EXtMqAZCo2kP+RkN6rMBX3/vTOYYbctqJxufq4cIqCnXfmXw5USJdSwU48fmuGoWYjj0fX2MBr4HeqzmkVRBr4ltSWYM7axJqV7/M4NsiAzTA1f00yJreAHm1DeD99tb4PgY1dNP3n4bFnoqr1laBI0eWyvXTewSgaZRZaFP7TmnTEpf9AyNdQkpuNGQZbeLmYuled48Ncl+PF8O847CKTci65ZgWnhboIpno/wxSIAGq96DxW0u6YyWExFlS3DqjzjqqJKWwhzmDHf9ZFb1hPE6RDN4yb7l6gEqYH+pJ9KunE0YTc4aM
 ufSTl5HR
 lgv5cMWhdwgdc9tUtuBcs9IH5zTG2vmAqNN9gZioB162xNmo2zl4rOj+W2S3FQhuD3gfrHRvmns7KfrckbfBDe4+uqTeeAxktsMb70k7HgLe4wk0H7t851sZHTFn4ee6XZiFnMcftZq6sW3DMENP+MRyYTjxBBTn3TyRhugoWkI/3isof59PNgVUDLfqoSH9hz67lgHPysPHcZxAsAJYzwFaZwxrx1On5MiF0VhJQ6BmYWvdb50WbpehdpPUPVZSFBXbSuXntDwetiIn7IT/Rk6AVuNo9ncjz7dVjGGk0OguC6Wkkx8cILsGKaBt8Ddy7kLhkCA5NOuM7nRqUiPcsOSW0+4j874Mp2VBpN3zeWixkuyQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/18 3:20, Zi Yan wrote:
> On 17 Dec 2025, at 2:17, Kefeng Wang wrote:
> 
>> On 2025/12/17 1:20, Zi Yan wrote:
>>> On 16 Dec 2025, at 6:48, Kefeng Wang wrote:
...
>>>>
>>>> +static void __free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages)
>>>> +{
>>>> +	for (; nr_pages--; pfn++)
>>>> +		free_frozen_pages(pfn_to_page(pfn), 0);
>>>> +}
>>>> +
>>>
>>> Is it possible to use pageblock_order to speed this up?
>>
>> It should be no different since the page order always zero, maybe I
>> didn't get your point.
> 
> Something like but take care of the cases when pfn and nr_pages are
> not aligned to pageblock_nr_pages:
> 
> for (; nr_pages -= pageblock_nr_pages; pfn += pageblock_nr_pages)
> 	free_frozen_pages(pfn_to_page(pfn), pageblock_order);
> 
> It makes fewer calls.

One of the drawbacks I though is that the pages can't be released to PCP
when the pageblock_order != PMD_ORDER, or released to different PCP
list (order-0 vs order-PMD_ORDER).

We maybe optimize it later if it's critical, but I don't want to do it 
in this patchset.

Thanks.

