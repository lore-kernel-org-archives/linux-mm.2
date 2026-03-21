Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 002381075269
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 02:40:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BF266B00A3; Fri, 20 Mar 2026 22:40:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 496F16B00A7; Fri, 20 Mar 2026 22:40:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D4A16B00A9; Fri, 20 Mar 2026 22:40:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B7046B00A3
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AC67A1403D6
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 02:40:48 +0000 (UTC)
X-FDA: 84568517376.20.25DCD4B
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf09.hostedemail.com (Postfix) with ESMTP id 34278140002
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 02:40:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=N3rDZpI8;
	spf=pass (imf09.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774060845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qf8fdm8I0b6fFs6ZCYF1HtcrxynncpLF2d8YXEp+DwY=;
	b=Gw2azTYtDlmS1U+E3CiiytqRv5l8CdaCWhekg9rOd9i2weDLAZouib/whvy3H7RVuJxWlR
	xGpOu6zgxb1c3jXAeonK6oY6tyKUGHYkfs5FOcc973mEyDf9bpFJ9U5k5x+jJ6py+SewO/
	k9D+ifm306yt/08gk8BrdHPzSREP8W0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=N3rDZpI8;
	spf=pass (imf09.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774060845; a=rsa-sha256;
	cv=none;
	b=H77A53l8MqejnYxluKr5FXg/jnQl/BQpDqLASJDEgLyvsNFQTQVVrfe+SdsmYtyhFiJNKZ
	I7qf0cza614fLQPDLfAC6Pfyw/yPCC6//KJYjf4axpASb4iRNIiSOOqCmwv7Q5W6aW5sIa
	r7f1cGoE/8dT+QX3FqUsP4WapohIXck=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Qf8fdm8I0b6fFs6ZCYF1HtcrxynncpLF2d8YXEp+DwY=;
	b=N3rDZpI82aCbf4CntuJa+74wdrz97NJCjtmKzJbR6r38tXCiTK1+p8jg1jxbd+bht9pzWgizP
	JfcpSroZcbYLyVzEN1k2oPq7zlyqwGaNaahVuA+zg85lmOzIiB2WweY2UlRVQxEzn4zFvveLn8g
	jHWgQx6OVnkfWXnwvMng+Hw=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4fd3Rg1gLjz1d03G;
	Sat, 21 Mar 2026 10:34:39 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 5E7C740565;
	Sat, 21 Mar 2026 10:40:41 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 21 Mar
 2026 10:40:40 +0800
Message-ID: <86a944b5-34bb-4f08-861b-b8d6da3db8e7@huawei.com>
Date: Sat, 21 Mar 2026 10:40:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/huge_memory: fix folio isn't locked in
 softleaf_to_folio()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
CC: <akpm@linux-foundation.org>, <david@kernel.org>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<baohua@kernel.org>, <ryan.roberts@arm.com>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
References: <20260319012541.4158561-1-tujinjiang@huawei.com>
 <63266e52-2644-4f4e-aca5-6db64052455f@lucifer.local>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <63266e52-2644-4f4e-aca5-6db64052455f@lucifer.local>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Queue-Id: 34278140002
X-Rspamd-Server: rspam08
X-Stat-Signature: qp9x577gyfzptut4wqq15okt373t6zqz
X-HE-Tag: 1774060844-295076
X-HE-Meta: U2FsdGVkX19T/s6gh57fKKeC7dzauiE+trJU1U9SJCk3WAqLo35uzDnnIusYajZ9V8xvx01LpP/NqFn0pkcyDThcPfPreXao620mPNzGGqM5awbmeZosSCkB4qEkl7XR66BxYMuUVSGRz5BWh+B9PZ8O9mJ1kNixteHXqOnVC5//GOix2saUhqR2GaF9QxhtN3mAe62U9Sh4FKaIvmRmcGt/bBWh4KdkVPCYHyBGZnz4uRO+LSKyKgHk4CdBoNn4ACzPl7rGMtAEJtV7I1K0wNu3FzPQGI7UYecf+RxjM6e2J+9XZBXYBUPihlYomgI0TtSbWSTYCfoacYk7KAp8tdhXG7o5FtdfbZVCas6bO3l/7lpE9xA6pA2I8X2uY8f1fxsYj8aes5HAjqwBzEIv9H+dbM4SFzqd68hlybsJuEYbrEhQiv2vxCr3d8wyk87ucDqs4XjTgzrp59wnuOGnPJQWMmFJRzQ9LaMGqonPhtP0vtHqiPqMtltX9TxmqZgwgmPHMQtJ8i41B2Rn+hFZTjVKduyMiAL0ZYkOqvpLEhMTd3Av63l8VnwZ8SZLFx47pg5+x87dPuPcTMVBqH1723GdInMav8nFGQi5CK7XqCkXynxy+z8r9FN7He+Aw1TjrsmIt+Vw0jHCkV/wZbjM5aobZmqk856mBuHgcKcbBzfVlq47IKgG+A/it5dpnVyBrFwstWlmIXe6gf0W+NuNckKwwhH0aKr5piB+5jXwtkCTsMZwTB762gaw5x18F1AY0NPF7oC6LTOuHDY2d3Bwf+tx4himDjZ9TDPxWcmpcN7AQKK1+Y21K8C9/LwgRDVsuMwr/3PhF4pLJ4HBQS2bZtVIW8X4B30/5nIZ9f66Qgd5NFdjq1XlN8FBM+UJumsKMUcgFAo9iTErc+gtzhbt1dfeYcBbomvNOr7nerEbGr0eKd3aul6bIRVUZtUCUux2Sopp7sVqrRfOQkHtGBa
 v8bLF8+m
 YJ1xVvL5OSe4sArIApPx47sLL3TdpkehjgqpWBLPmsMbkAwDuACCcU6W7J7ORyOFCbi+NfTzjw9zTZqAcygbh6vTYLZYrlvdzCg5f6HEGtQC9oafhQlRVaTkDwyoPldM0SKZz2RJusZbx1igrWMet9r6ppC1sPAOvfqai981MGMGBUFMCI2CCZxUgUA2E9c/voz5pG/tQ6+awabvFoXiMoYowq3zAXkzD3EJVXTcfFiMJFhXpFiiaGhVBjXubMQhjAIQLOGDXDG4EEr+gfRaT/54AO10q4yz7UPHlGnu7hT36QN7QjnZOkuB2212ARnpC6ZA7aRsaYUS/V6g3w4WYQwL+RFfxUpamMM/CFHOfWqUF9aZMa6uZjJBfqMzgbf4k4HyRDQuTXtUXn6lgSxy+VXuu0mZhsAr+KID1uOZkAZ3nBjVIw+OS4NiVKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/3/20 18:13, Lorenzo Stoakes (Oracle) 写道:
> On Thu, Mar 19, 2026 at 09:25:41AM +0800, Jinjiang Tu wrote:
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
> I absolutely could have sworn I replied to this before, but I looked and it
> seems like I didn't :) am I getting old or something? :P
>
> Anyway the logic looks good, thanks for this, but some nits on the
> naming/comments below.

Thanks, I will update it.

>
> With those addressed:
>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
>> ---
>>
>> Change in v3:
>>   * move softleaf_is_migration() check out of softleaf_migration_entry_check()
>>
>>   include/linux/leafops.h | 28 +++++++++++++++++-----------
>>   1 file changed, 17 insertions(+), 11 deletions(-)
>>
>> diff --git a/include/linux/leafops.h b/include/linux/leafops.h
>> index a9ff94b744f2..dd4130b7cb7f 100644
>> --- a/include/linux/leafops.h
>> +++ b/include/linux/leafops.h
>> @@ -363,6 +363,19 @@ static inline unsigned long softleaf_to_pfn(softleaf_t entry)
>>   	return swp_offset(entry) & SWP_PFN_MASK;
>>   }
>>
>> +static inline void softleaf_migration_entry_check(softleaf_t entry,
>> +			struct folio *folio)
> I'm not sure this is correctly named, you're doing a debug-only check here
> but the barrier is a LOT more important.
>
> Maybe softleaf_migration_sync()?
>
> The fact there's a check there is implied by the VM_WARN_ON_ONCE().
>
>> +{
>> +	/* See __split_folio_to_order() comment */
> NIT: reads better as '/* See comment in __split_folio_to_order() */'.
>
> But you're referencing a 1 line comment from __split_folio_to_order();
>
> 		/* Page flags must be visible before we make the page non-compound. */
> 		smp_wmb();
>
> Which also doesn't give sufficient context in my view.
>
> So I think overall better as:
>
> /*
>   * Ensure we do not race with split, which might alter tail pages into new
>   * folios and thus result in observing an unlocked folio.
>   * This matches the write barrier in __split_folio_to_order().
>   */
>
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
>> @@ -374,11 +387,8 @@ static inline struct page *softleaf_to_page(softleaf_t entry)
>>   	struct page *page = pfn_to_page(softleaf_to_pfn(entry));
>>
>>   	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
>> -	/*
>> -	 * Any use of migration entries may only occur while the
>> -	 * corresponding page is locked
>> -	 */
>> -	VM_WARN_ON_ONCE(softleaf_is_migration(entry) && !PageLocked(page));
>> +	if (softleaf_is_migration(entry))
>> +		softleaf_migration_entry_check(entry, page_folio(page));
>>
>>   	return page;
>>   }
>> @@ -394,12 +404,8 @@ static inline struct folio *softleaf_to_folio(softleaf_t entry)
>>   	struct folio *folio = pfn_folio(softleaf_to_pfn(entry));
>>
>>   	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
>> -	/*
>> -	 * Any use of migration entries may only occur while the
>> -	 * corresponding folio is locked.
>> -	 */
>> -	VM_WARN_ON_ONCE(softleaf_is_migration(entry) &&
>> -			!folio_test_locked(folio));
>> +	if (softleaf_is_migration(entry))
>> +		softleaf_migration_entry_check(entry, folio);
>>
>>   	return folio;
>>   }
>> --
>> 2.43.0
>>
>>
> Cheers, Lorenzo
>

