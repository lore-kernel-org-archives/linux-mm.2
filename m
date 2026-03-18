Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D64310854DB
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 09:29:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BC816B014F; Wed, 18 Mar 2026 05:29:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46DA16B0151; Wed, 18 Mar 2026 05:29:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 382F96B0152; Wed, 18 Mar 2026 05:29:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 285456B014F
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 05:29:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B694E13B2D6
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:29:47 +0000 (UTC)
X-FDA: 84558661614.12.E493D33
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf10.hostedemail.com (Postfix) with ESMTP id 77135C000A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:29:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=NnSCuGs8;
	spf=pass (imf10.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773826185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=usbua+fVWZNE41Kwxxy719LfZpIisbyb51veGjr6KVI=;
	b=CdpxBaFTfptrsJH5vL0dowcoZQMF/hb+ozwzNG0Si4AsJ/LzZtEq0gosdpg30oFT7dqawi
	EYli6AFPOPtONkWXoj6HxQeurnuZ0SKs1ZKNE/pv5C6ieRkoJCYM+TN7dvF9aBr03pph4K
	IPDTw1Rzc26kgJUNKRsDPsW87tz8F/w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773826185; a=rsa-sha256;
	cv=none;
	b=CUaWFmyjPdDDB8XhhsnnMr+3d8tlcwTXSCW9V+Uhg6i7xzLREEL3hZ+VfLA8mdjPlEqk+I
	oce3ZE4LJxKrU0+Sq8vXq3Nj4d0Pvlw+v075GNOuyIELgQMQ2JCE6e2d2wDqPvKgie2bke
	e0UmzPccMlZm5tNP3JzOn+d4IH1xFf8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=NnSCuGs8;
	spf=pass (imf10.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=usbua+fVWZNE41Kwxxy719LfZpIisbyb51veGjr6KVI=;
	b=NnSCuGs8eIwrZePTN/26H3GYw2h4BzG8MFaIDc32uzXnx6RCNf/7BnMaHWOSqizsD6T7ol/2U
	Mpjm5eyZKypVQLAAX+2f4zs2xQhyZNjmgoGuzgoIgmZKKKgvNzwyR8bH9RWUodtJvaakvGsTjwk
	GevnT5xT85iZDAG27BbY9rk=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4fbNgL0nKWzcZy5;
	Wed, 18 Mar 2026 17:23:58 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 304742025F;
	Wed, 18 Mar 2026 17:29:37 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 18 Mar
 2026 17:29:36 +0800
Message-ID: <04888291-d7ba-4df0-8f76-c9eb15408b37@huawei.com>
Date: Wed, 18 Mar 2026 17:29:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/huge_memory: fix folio isn't locked in
 softleaf_to_folio()
To: "David Hildenbrand (Arm)" <david@kernel.org>, <akpm@linux-foundation.org>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<fengwei.yin@intel.com>, <baohua@kernel.org>, <ryan.roberts@arm.com>,
	<linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
References: <20260318012055.3593216-1-tujinjiang@huawei.com>
 <88f37900-5c8b-4606-9081-e9b72acb0941@kernel.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <88f37900-5c8b-4606-9081-e9b72acb0941@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Stat-Signature: is6c8kqqyjkhcbg4mye34rfkaieeuq9r
X-Rspamd-Queue-Id: 77135C000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1773826184-852416
X-HE-Meta: U2FsdGVkX192cjn9IieIjCDO4fWt9IBRIPSJAWGAOe5NQY57iYDtsQN02gRJ/F3zT9otqY7hioQIlJrO75xZljNH84X+p4G7XaOME4+zM49KJo2YDlNc36A3bjuOOnP5dxwZUwHQ2Ghv4QstsnnjBn+j73lRdeHPaXMbV/kc3CGG404LGgAVHnPi+g1vcsDvFnPlWIUFBSV+6poX+XTds/VyXivplFlHvK7wEjmWJrdi/siSODGrI4QwDCQIYeB0RWdM7IFvPmlwNrYxsKBbA8gKI5vg+v5ChZ8PUzOKiSA/BI3TFNdCl8Z84UMIXfyLgcKhKuXD9Im8/WCUvQvEtstL9sGbWWrntTeeo+hZn+m4PTH0FyLrlcXHY9YULq2cVPbwFAw5LphuJRkJJEFkSdAdqIN3LPIs16vF6KouwLerDQS4bya+n2C5Rs5viJzDHuWRlWAr4Y9ZNhFak33KcP24l/ZBs4sBogzYPtI7KeB2y20aS21SEdmTN/tuQq4PhSJwdaAme8rRgGMI/YKZ2+sx/M8yPJQZbOwHv5YfWhLBRTivtUfGPyr2FmcGhXB9NpGG6CSidNAVfeCjgNkaHOiTfQSwXZezZHGI5ZMcDL9zzZdNVN1PtVIW2xPf5lViMtE+S48Ek+cQMdxOJ8f92RxITwSmDYL/QpaXvRI5Qx7rmhv3ktbgLDPh+Fg4Qs7wtgukzUZh1OJ5Evho4iiUswho4vRAfKWU4AxfqL0aMG5c18kz0G0jDp4HO6oDYWOgOajOPjmOKXQ0PvouVpepu+l13Jb8kUL6n4fZYnwKTuCOIp6pzUlZWYzoL35YN3XopqADieD2sKI/PT3FiMyBYz+aEMG1ximTxhLmZf4IDQy9ycpi/uxHhHQn7L7JB1fkmDXeSug8HTDRO0bIQDtdsGYTp/qljUdjQB57tmTGQXOLoMxVQTKX3Ks4GcTV3PfMreQecKbh1GlJ+fQWZ3M
 EZjpHPML
 FZ25slJkmy9gMOqe1OqMi75It9EQWETchVb8jlEYuNnGSzbVsYIeGgvg4LbyjuHXRsnWyE6F8Iqx+NpKnW8Ky52bA+wd6ss6iG/m/yUr6IM9C38bxmvS8cfKzU2wvJMvJIebxJGNLUIpmmgTa2zN4wnQsBQqiTV9FRGUs6bidA+LpRdlTCZrV0FrckWE5R31A5CrJQZfOsF3+I+X2+rmmGoNUot45dQ2syfrD2FKZ0yoOptJn8thYV2Jft4BlYRs8qIJh8nlNxihGMN0h5o5zwefs5SdH5yROOqYb59ARJtlNZPlHZlUUgBMRuhgPV6DVUFQF5J45VbPYitRXOQP3dWYccYwIHtSxY29pTnJHayQ7NaXhMuyPXItDanipdhQ48BaKs210zaHSsugbmcVachmZU/dazH8/bgp9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/3/18 17:02, David Hildenbrand (Arm) 写道:
> On 3/18/26 02:20, Jinjiang Tu wrote:
>> On arm64 server, we found folio that get from migration entry isn't locked
>> in softleaf_to_folio(). This issue triggers when mTHP splitting and
>> zap_nonpresent_ptes() races, and the root cause is lack of memory barrier
>> in softleaf_to_folio(). The race is as follows:
>>
>> 	CPU0                                             CPU1
>>
>> deferred_split_scan()                              zap_nonpresent_ptes()
>>    lock folio
>>    split_folio()
>>      unmap_folio()
>>        change ptes to migration entries
>>      __split_folio_to_order()                         softleaf_to_folio()
>>        set flags(including PG_locked) for tail pages    folio = pfn_folio(softleaf_to_pfn(entry))
>>        smp_wmb()                                        VM_WARN_ON_ONCE(!folio_test_locked(folio))
>>        prep_compound_page() for tail pages
>>
>> In __split_folio_to_order(), smp_wmb() guarantees page flags of tail pages
>> are visible before the tail page becomes non-compound. smp_wmb() should
>> be paired with smp_rmb() in softleaf_to_folio(), which is missed. As a
>> result, if zap_nonpresent_ptes() accesses migration entry that stores
>> tail pfn, softleaf_to_folio() may see the updated compound_head of tail
>> page before page->flags.
>>
>> To fix it, add missing smp_rmb() if the softleaf entry is migration entry
>> in softleaf_to_folio() and softleaf_to_page().
>>
>> Fixes: e9b61f19858a ("thp: reintroduce split_huge_page()")
>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
>> ---
>>
>> Change since v1:
>>   * update fix tag
>>   * use helper softleaf_migration_entry_check()
>>
>>   include/linux/leafops.h | 29 ++++++++++++++++++-----------
>>   1 file changed, 18 insertions(+), 11 deletions(-)
>>
>> diff --git a/include/linux/leafops.h b/include/linux/leafops.h
>> index a9ff94b744f2..c7dbc3fb8ab6 100644
>> --- a/include/linux/leafops.h
>> +++ b/include/linux/leafops.h
>> @@ -363,6 +363,22 @@ static inline unsigned long softleaf_to_pfn(softleaf_t entry)
>>   	return swp_offset(entry) & SWP_PFN_MASK;
>>   }
>>   
>> +static inline void softleaf_migration_entry_check(softleaf_t entry,
>> +			struct folio *folio)
>> +{
>> +	if (!softleaf_is_migration(entry))
>> +		return;
>> +
>> +	/* See __split_folio_to_order() comment */
>> +	smp_rmb();
>> +
>> +	/*
>> +	 * Any use of migration entries may only occur while the
>> +	 * corresponding page is locked
>> +	 */
>> +	VM_WARN_ON_ONCE(!folio_test_locked(folio));
>> +}
>> +
>>   /**
>>    * softleaf_to_page() - Obtains struct page for PFN encoded within leaf entry.
>>    * @entry: Leaf entry, softleaf_has_pfn(@entry) must return true.
>> @@ -374,11 +390,7 @@ static inline struct page *softleaf_to_page(softleaf_t entry)
>>   	struct page *page = pfn_to_page(softleaf_to_pfn(entry));
>>   
>>   	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
>> -	/*
>> -	 * Any use of migration entries may only occur while the
>> -	 * corresponding page is locked
>> -	 */
>> -	VM_WARN_ON_ONCE(softleaf_is_migration(entry) && !PageLocked(page));
>> +	softleaf_migration_entry_check(entry, page_folio(page));
> It might be better to do
>
> if (softleaf_is_migration(entry))
> 	softleaf_migration_entry_check(entry, page_folio(page));
>
> Removing the softleaf_is_migration() check from
> softleaf_migration_entry_check(). Then, we don't do the unconditional
> page_folio() and don't call the function for non-migration-entries.

Indeed. Although the compiler may be able to optimize it, it's better to write
like above.

Thanks.

> With that LGTM.
>

