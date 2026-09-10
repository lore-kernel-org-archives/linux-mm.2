Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41A2DC79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 01:16:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E768A6B008A; Wed,  9 Sep 2026 21:16:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E27526B008C; Wed,  9 Sep 2026 21:16:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D162B6B0092; Wed,  9 Sep 2026 21:16:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 955AF6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 21:16:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0E003803EA
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 01:16:45 +0000 (UTC)
X-FDA: 85196087970.23.CAA91C3
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf14.hostedemail.com (Postfix) with ESMTP id 87A7B100004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 01:16:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Iz++jSms;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789003002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OjQKRE5lrce7jhbihAkBY+s6J3FeAMm2fhRqDQAJOrY=;
	b=r83lX6XMQ2ozohbr+hqu7TPHIDe6jIjhhd+5YVhrj0WeFBAqZVTOR1G4oVQDdC3uv4TtY2
	Hv8WEP5Avmjgp0G8ohPrd3SW7ypE8ANs9Dqxpeek/FbCprLwTBi91Urdzyphr2AegYDMkH
	ngI4DrYlM1/hwagowlteRy5ZcJHb69E=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Iz++jSms;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789003002;
	b=SXnoHcCrS4n22D5twqwKDzV8UIyRn90xD9YJHrsUmzOgSRYAUXKrH2VPKt51xPR4Saf0Ng
	BYVJwNbQ2B46l1eIHGsTSYXo0B2F/OakBIlcWuJiNrl8I4iEVfqg2usRHsc1uPuCxl29Pz
	hrmwgOEINFINDLmLz+dJLl7V4x+/WKE=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=OjQKRE5lrce7jhbihAkBY+s6J3FeAMm2fhRqDQAJOrY=;
	b=Iz++jSmsreCtrwA30Smkw7gaIr6HpZRBXqKisR+semcZGTV7Uw+hZPNR9QN2M/euNWaLY38E2
	cZ2PTvK5s1cEwUvGtlMvxmLx458VE+q8x98z1gbCs3OUol0+sdGstFt51B2jg9eAK5gomxEgwAs
	PIicfn7s2batLz6OPCe1qNE=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hgKGn1NS8z12LF9;
	Thu, 10 Sep 2026 09:05:21 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 13AB04056E;
	Thu, 10 Sep 2026 09:16:33 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 kwepemk300003.china.huawei.com (7.202.195.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 10 Sep 2026 09:16:32 +0800
Message-ID: <9e511393-cc88-4fb7-aafc-cc8c1ea42a1c@huawei.com>
Date: Thu, 10 Sep 2026 09:16:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: zswap: avoid unnecessary xarray lookup in
 zswap_store()
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>, Chengming
 Zhou <chengming.zhou@linux.dev>, Kairui Song <kasong@tencent.com>, Nhat Pham
	<nphamcs@gmail.com>, Yosry Ahmed <yosryahmed@google.com>
References: <20260909123548.296955-1-wangkefeng.wang@huawei.com>
 <aqFynNC4wJnoTnjj@cmpxchg.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <aqFynNC4wJnoTnjj@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Rspam-User: 
X-Stat-Signature: wktg3he6973s3dakdigzshkkzjoewcwd
X-Rspamd-Queue-Id: 87A7B100004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789003001-96320
X-HE-Meta: U2FsdGVkX1+cxlRLt7/tUPnTwwtl15Lxw8DxrdZlfRTW5VI8GsLPRTvtcT+SCgRlgveaE39E0OuLB/UIwaY6a1V7WwgN1K0Hz8E4IzztWuUCLofL8fvWQnzQuPXXQxEpupS6LJiXH8UtgupDPwrP2ukWjN0XoLyRieVp8hj5sTuHjMfJJs5ZnZMZTL+pjk0TzWY6PWXoNFjeG6/5QrWfunZ5FEHFktBDbJ9NguwaFx+zY5hOFnhjd+ir1nYx6x83qiTPf07f/6jDf4ZcSPY29nPGGyj07lqTuEGubclOWv2rCLm8g3xIjX99TqM3MEIuA1UkWBTFaBT29OA26d6Wj525cwLYJgaSjyOjeyhmrozTSnjiaho9Sf0JET+G6U/ZMoRnVEcxL67O+jz2oANyB/qh+5800rqTvaIVD8881W0siqTlR3VNHaPqZe5qd5rXmcN1NFbxCavarrVGCCwwQ6cr/5+FRE+Y7a7+XnJ+bYkzPEK9UHQT1k1J54A6QVMFRIvM/f5BAmo04s0J+JMkHiYpF2dkDrUY+kc60gr8OpwAPWAaJG8f7K7AeYeWQS5NoxJqao0wBktbmQYBN+LA7UfnPGS6pBqqsWzxV2QQ5kXPFAVuhSkHWyb9KbeDNIolnVa6mI/siAqFVp//FbOTWHMoCfZFuLLizfmRCAqJEF81dWfqnUi4688a/jFX6zcbacr4NEZxs6PSTDAtOoGPnqH3tlWJYExAnIVVMZQ9xd+Si6y+p2q4sjmMecLi9Z3rc342xYLgSS74zNJvHrsdK/gyE/lNSmdZw48svMSJ8PClosRvIi7ojdAQo+hJzaUPi9bh5kiNs1qoD8NZODeaqRMtZD53XjLro7RE8ezu+YKtBithgAHASl2vU2Ves4myufpvzvLUyImAc3OhTJZSTEQdiv0edJY9R6ls7xt9YtJ3+g88fPl6iF8k9BC2+1dAzLPnapM1BcquB/DD9yr
 VbMFmHjz
 BMTlQTg8hzXriJdSsHNofEaCwQ4DJNsVAbScoFDcEfWd5ZHRyInwEomwFXakoc3h1KRaicN6L1zT2MDmJvlH4zeLgxKw7OFOdMOZlyhE0idV9ABWoVyGqZUkUWowkomxedoCc/VcvPKen2Wtn3VjjFxZ3ltb81HCoc0gA8hchBG4a9zvoQFPWJl7E2uMiiQH3XHIQH8Q8bodgZpvLJbBfNYrzf8tlnPip49ZwpOv85ntHkWRwykcml/2zuJqi2370EtH73QIZaCnSEmVR0gItKmA8G8Lm//3kOEki+xYaCL07j3E504yyKVaCe22mSYsOWKzB/0G13y7Fa2Xb0jAQ269lkkEWmf/Tw/ydx5r7SzghG1+LUvd/Z6HsrDx9iMAo3/EEk8dq4Fs9qrP/Eq8xhb4x+BCdhLG5ogxpTMPuw8FlRG602bmvDhFlZbJt/1WgAeoipwRvs/1aYA4tshL9/J9L25uWnU5zEFdCk5kDTYa3V7FTGQXR1NJHEDz+EMXMPypXRSkz/jStms3Kur+6bdKiZo9IWCCma7svunfbot3WeceSPQ0wFNk6ZGci3bJfzHSh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/9/2026 10:52 PM, Johannes Weiner wrote:
> On Wed, Sep 09, 2026 at 08:35:47PM +0800, Kefeng Wang wrote:
>> zswap_store() falls through to check_old and walks the swap xarray
>> even when zswap is disabled. Add a zswap_never_enabled() early return
>> matching zswap_load(), and reuse zswap_invalidate() whose xa_empty()
>> check skips empty per-area trees to avoid unnecessary xarry lockup.
>>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> Cc: Chengming Zhou <chengming.zhou@linux.dev>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Kairui Song <kasong@tencent.com>
>> Cc: Nhat Pham <nphamcs@gmail.com>
>> Cc: Yosry Ahmed <yosryahmed@google.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
> 
> These are really two separate changes. Can you please split them out?

Sure.

> 
>> ---
>>   mm/zswap.c | 16 +++++++---------
>>   1 file changed, 7 insertions(+), 9 deletions(-)
>>
>> diff --git a/mm/zswap.c b/mm/zswap.c
>> index 5d0d8bd72193..fc6c5e0db5e4 100644
>> --- a/mm/zswap.c
>> +++ b/mm/zswap.c
>> @@ -1488,6 +1488,9 @@ bool zswap_store(struct folio *folio)
>>   	VM_WARN_ON_ONCE(!folio_test_locked(folio));
>>   	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
>>   
>> +	if (zswap_never_enabled())
>> +		return false;
> 
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
> 
Thanks.

>> @@ -1545,15 +1548,10 @@ bool zswap_store(struct folio *folio)
>>   	if (!ret) {
>>   		unsigned type = swp_type(swp);
>>   		pgoff_t offset = swp_offset(swp);
>> -		struct zswap_entry *entry;
>> -		struct xarray *tree;
>> -
>> -		for (index = 0; index < nr_pages; ++index) {
>> -			tree = swap_zswap_tree(swp_entry(type, offset + index));
>> -			entry = xa_erase(tree, offset + index);
>> -			if (entry)
>> -				zswap_entry_free(entry);
>> -		}
>> +
>> +		for (index = 0; index < nr_pages; ++index)
>> +			zswap_invalidate(swp_entry(type, offset + index));
> 
> That dance through a swp_entry_t was already kind of awful. This would
> be a good opportunity to refactor things to avoid that:

It looks better, thanks for your review. will update.

> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index e6ec3295bdb0..df18fdaae703 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -228,10 +228,15 @@ static bool zswap_has_pool;
>   /* One swap address space for each 64M swap space */
>   #define ZSWAP_ADDRESS_SPACE_SHIFT 14
>   #define ZSWAP_ADDRESS_SPACE_PAGES (1 << ZSWAP_ADDRESS_SPACE_SHIFT)
> +
> +static inline struct xarray *zswap_tree(int type, pgoff_t offset)
> +{
> +	return &zswap_trees[type][offset >> ZSWAP_ADDRESS_SPACE_SHIFT];
> +}
> +
>   static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
>   {
> -	return &zswap_trees[swp_type(swp)][swp_offset(swp)
> -		>> ZSWAP_ADDRESS_SPACE_SHIFT];
> +	return zswap_tree(swp_type(swp), swp_offset(swp));
>   }
>   
>   #define zswap_pool_debug(msg, p)			\
> @@ -729,6 +734,19 @@ static void zswap_entry_free(struct zswap_entry *entry)
>   	atomic_long_dec(&zswap_stored_pages);
>   }
>   
> +static void __zswap_invalidate(int type, pgoff_t offset)
> +{
> +	struct xarray *tree = zswap_tree(type, offset);
> +	struct zswap_entry *entry;
> +
> +	if (xa_empty(tree))
> +		return;
> +
> +	entry = xa_erase(tree, offset);
> +	if (entry)
> +		zswap_entry_free(entry);
> +}
> +
>   /*********************************
>   * compressed storage functions
>   **********************************/
> @@ -1554,12 +1572,8 @@ bool zswap_store(struct folio *folio)
>   		struct zswap_entry *entry;
>   		struct xarray *tree;
>   
> -		for (index = 0; index < nr_pages; ++index) {
> -			tree = swap_zswap_tree(swp_entry(type, offset + index));
> -			entry = xa_erase(tree, offset + index);
> -			if (entry)
> -				zswap_entry_free(entry);
> -		}
> +		for (index = 0; index < nr_pages; ++index)
> +			__zswap_invalidate(type, offset + index);
>   	}
>   
>   	return ret;
> @@ -1647,16 +1661,7 @@ int zswap_load(struct folio *folio)
>   
>   void zswap_invalidate(swp_entry_t swp)
>   {
> -	pgoff_t offset = swp_offset(swp);
> -	struct xarray *tree = swap_zswap_tree(swp);
> -	struct zswap_entry *entry;
> -
> -	if (xa_empty(tree))
> -		return;
> -
> -	entry = xa_erase(tree, offset);
> -	if (entry)
> -		zswap_entry_free(entry);
> +	__zswap_invalidate(swp_type(swp), swp_offset(swp));
>   }
>   
>   int zswap_swapon(int type, unsigned long nr_pages)


