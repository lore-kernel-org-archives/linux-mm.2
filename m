Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CACACD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 07:17:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97A0B6B0299; Mon,  1 Jun 2026 03:17:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92A196B029B; Mon,  1 Jun 2026 03:17:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8187A6B029C; Mon,  1 Jun 2026 03:17:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C8176B0299
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:17:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 105E31405E3
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:17:20 +0000 (UTC)
X-FDA: 84830487840.17.53ECA2D
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf10.hostedemail.com (Postfix) with ESMTP id 32633C0004
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:17:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Hc97jZvn;
	spf=pass (imf10.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780298238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ST2Tg32v5NWZL0Digt/7WzPOrgnDtd7aEPB8tVaCFQ=;
	b=wtE+UsqZZaQtFw8db3Y6xlicex/Brn9mn7j8DficY1jkSixBadVG4PScs1c+2sc+vVOJj8
	qIS7i+EpxW+oYX1fehFtYiE367qU9XCYCOgwqlYRm4pmxcE3JHMgZrzptptCpcaqIg1s75
	OK6ecMqHwylFTban8Hf5gvS6IOfyD1Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Hc97jZvn;
	spf=pass (imf10.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780298238; a=rsa-sha256;
	cv=none;
	b=sN1BMokiHpLgJZXcn2sUh7Yi0s0zqTHHbwo9gdNVG/UFQoGHHrzU76WuUzXhyf5B7u9Hjn
	xR/HxA6lLsePIrnfYz0dkdc6ebOt1YTv7zOTBObfMdWeSBS5GUycEIvtAYCTMoyMhMBsJG
	aWDwYkqxb9lVUBj5T/P/GlikLdbPjMY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=8ST2Tg32v5NWZL0Digt/7WzPOrgnDtd7aEPB8tVaCFQ=;
	b=Hc97jZvnUog6kvHS/SX8VtoZXhoq3IxJcSa3DvnoLPRqjnFX+cqB3OR0/dYSIi/cVnzJQbcZu
	CZugFwzI326auRogHOGW48AD5zvD4HCSYq7T+t1sC9FNA3hC3iys/yoQvOFWiLbvPFbtoPRCeK/
	8PTo1FvjAcQ+S+KoNAuPXW0=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4gTQ7Q1xsmzRhR3;
	Mon,  1 Jun 2026 15:09:22 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 9188840561;
	Mon,  1 Jun 2026 15:17:10 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 1 Jun 2026 15:17:10 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 1 Jun 2026 15:17:08 +0800
Subject: Re: [PATCH v9 02/37] mm: memory-failure: serialize
 TestSetPageHWPoison with zone->lock
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: "David Hildenbrand (Arm)" <david@kernel.org>, Jason Wang
	<jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>, Muchun Song
	<muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Andrew Morton
	<akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins
	<hughd@google.com>, Matthew Brost <matthew.brost@intel.com>, Joshua Hahn
	<joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
	<byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
	<ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>, Kairui Song
	<kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham
	<nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	<virtualization@lists.linux.dev>, <linux-mm@kvack.org>, Andrea Arcangeli
	<aarcange@redhat.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <cover.1780067977.git.mst@redhat.com>
 <2c527d20c99cdfe64a77bcf8da75f742d4c6991e.1780067977.git.mst@redhat.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <9c73bc2e-20f2-c7b0-cd8c-63ea5437f2ed@huawei.com>
Date: Mon, 1 Jun 2026 15:17:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <2c527d20c99cdfe64a77bcf8da75f742d4c6991e.1780067977.git.mst@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 32633C0004
X-Stat-Signature: qszmgytmmfqa8yifhsd7gjpffzbinyru
X-HE-Tag: 1780298235-995081
X-HE-Meta: U2FsdGVkX1+RXxY+OjNefCY+q2zPqCVBD19JstqVyNVXXbjbysNjsuPmw9ZgxmgbiqSbSwHa4/+azcgGPEsSG0JCecDOOo0/+SPkVl5ocknDb55Uno+4GHzQ5HgdHlGQC61/r85Db+wwX1vPklvr1dEx0YWH1m2r+0yWaXHAVF0R7R1dshCjuMyIcIxBXbDuaTvWEq4SvcbCiaWKL8vmbucHydZkmIvAw3mF62LQBdwXVrq72DYulpQ3iXiEAcKhpw+HWxnpC0N3N+JZGZ9f7GYrRnp9ITDAphD4oTx+xIgKFSyIKLv23b0C3VZehHcGj6w/Wpo63aApahMsXDir6PJ9h0KPSA3ReijiXcXaMQdrUY3Lho6sywYx63Rwk3StM88NU6FfDPW8LI8op6tNqZF1VqiUGhfsgp71x2+IDGjrN5uuRGzu4En6BOHgU2bo4t0T31dMgq2Arrd7LjmdvG1iYL00gKxmCkHVTCeQyDe+TE+7K+nhluiJ1mZ3gHRIYSwQ+MxIXSNGj/w0RV9JY8fiA+0Z6ciduGwlcxcXDF4C0LoG3IzxMy5U3y+KAzdJ+1IpNnpBXlCCyX7s2vBt+EJru5dmwmSEl3KPETLMt6YGrFKU1R1vSXaTgNVLnXFzc/PTKokhqXG6gikSkMmn2aA3ixzELHAWqxlJVRdbLXNbhzn2E1Z2FCMiVNimj9EimcchRChZkWpD/YUp1+cliri6rHNRr++rnzIv40mEHFTSga0KPvC9X46YFX5gTpPINv+San0/Gmn3J3bfFdu2j3wf8JFGmjrZmNRAeFPoNRvpjWHHyGlUlsnmk5aWOS8m+RCk0f7tIBUvC7o0ZcjIC0KexSotmZrhqKpETEp/pIuWDEwDTmxpU4squCNx/0nGQUUuVLMUxJGV5f9N5QQWxlWYTGU4ZeqLbLa55nxFv/Rsmp1jooJWcxIDgkZrPc7yA7pDfqFx/HvLB09p/mT
 vg6mJStP
 gOOqETN2BJdYUrAevEMtE7GcNIf/bjz0lwe2Z7NDiE5fHfZpyNwRqUI57l7jy/o8pc+HqU7SXTYKZvAzpDKtsMRIqsYJl7696Y3vg1UQdBbQKRcT2Htqk/5uD+J1OmgETueNq9w7ij150zjtCqmtQzMelkRObXgZgmESy+wS741+tQXWMnHpUB5VpHwMxW5boTmMlCe1m4aZpTZw+D45GoaHAQvCQcyWqIq6G44whaCuqdNGLboJNoYhVX+NOTyweLbifhhV+bg3v2zw1NkKwYBq84oApZBVksHfwe6CcKOVUqc813hV51g/BaosB2oxbVeqWcuw6+NMeb0J1w787rafJXsRA40qgW7YkODJtFceHf7dv6cF4uce7DpOrapYhqKjxcH8uCB0jYuQTIan6m+W5sWwyTtlK3iIE3wcLeHnDxNVKz6a2Sv90QgndXA8x3yT6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/5/29 23:22, Michael S. Tsirkin wrote:
> TestSetPageHWPoison() is called without zone->lock, so its atomic
> update to page->flags can race with non-atomic flag operations
> that run under zone->lock in the buddy allocator.
> 
> In particular, __free_pages_prepare() does:
> 
>     page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> 
> This non-atomic read-modify-write, while correctly excluding
> __PG_HWPOISON from the mask, can still lose a concurrent
> TestSetPageHWPoison if the read happens before the poison bit
> is set and the write happens after.  Follow-up patches in this
> series add similar non-atomic flag operations as well.
> 
> Fix by acquiring zone->lock around TestSetPageHWPoison and
> around ClearPageHWPoison in the retry path.  This
> serializes with all buddy flag manipulation.  The cost is
> negligible: one lock/unlock in an extremely rare path
> (hardware memory errors).
> 
> Note: SetPageHWPoison and TestClearPageHWPoison calls elsewhere
> in this file operate on pages already removed from the buddy
> allocator or on non-buddy pages (DAX, hugetlb), so they do not
> need zone->lock protection.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6
> ---
>  mm/memory-failure.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index ee42d4361309..d106f2c135c7 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -2348,6 +2348,8 @@ int memory_failure(unsigned long pfn, int flags)
>  	unsigned long page_flags;
>  	bool retry = true;
>  	int hugetlb = 0;
> +	struct zone *zone;
> +	unsigned long mf_flags;
>  
>  	if (!sysctl_memory_failure_recovery)
>  		panic("Memory failure on page %lx", pfn);
> @@ -2390,7 +2392,10 @@ int memory_failure(unsigned long pfn, int flags)
>  	if (hugetlb)
>  		goto unlock_mutex;
>  
> +	zone = page_zone(p);
> +	spin_lock_irqsave(&zone->lock, mf_flags);

Would it be better to add a comment here why zone->lock is needed?

>  	if (TestSetPageHWPoison(p)) {
> +		spin_unlock_irqrestore(&zone->lock, mf_flags);
>  		res = -EHWPOISON;
>  		if (flags & MF_ACTION_REQUIRED)
>  			res = kill_accessing_process(current, pfn, flags);
> @@ -2399,6 +2404,7 @@ int memory_failure(unsigned long pfn, int flags)
>  		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
>  		goto unlock_mutex;
>  	}
> +	spin_unlock_irqrestore(&zone->lock, mf_flags);
>  
>  	/*
>  	 * We need/can do nothing about count=0 pages.
> @@ -2420,7 +2426,9 @@ int memory_failure(unsigned long pfn, int flags)
>  			} else {
>  				/* We lost the race, try again */
>  				if (retry) {
> +					spin_lock_irqsave(&zone->lock, mf_flags);
>  					ClearPageHWPoison(p);
> +					spin_unlock_irqrestore(&zone->lock, mf_flags);

Ditto.

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

