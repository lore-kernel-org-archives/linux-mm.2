Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E5FDCFD364
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 08:55:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A16596B0027; Tue, 25 Nov 2025 03:55:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EE146B0028; Tue, 25 Nov 2025 03:55:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92BBA6B002A; Tue, 25 Nov 2025 03:55:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 826D16B0027
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 03:55:52 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2FA114FBA7
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:55:52 +0000 (UTC)
X-FDA: 84148521744.16.7B4F233
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6BE6020009
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:55:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oK3tj+fx;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764060950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wlXkmnByaFWYRBxqCd5t4xtFgksbGDk/9vElBWHlcHs=;
	b=1ShGNaJ/lWLWDFnPUqOZ9OWvYuhyLKEb5hk+tsdunhJVXt94x9g+TT0XMCJ9i9Hj/Rul99
	LRlMfce1VMfKkQaFK/cRC2l11smHDzWPtFSa/9JeNgJUP3/I79OOgUTb//jHqENUoYUTr1
	2OzFiQkpo7wqu57/z1Xj3OD/nMGCgYk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oK3tj+fx;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764060950; a=rsa-sha256;
	cv=none;
	b=WEVbNhgLYq4eBW+SW/nFzkynUh66wUTy7lSW8AMdEJwW/XGJeu9jJL0nOgwmk9zvjPP+0g
	qqxrSRCGzPtLiSLM9wY5rsJP6opNSnrdzq+5E4Dw9CTcTV59ow6FRWFWMFOiSiKIKuUoGY
	Rv6LdR1mFrfHdEbANvs/SgsWsMOKCos=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C4DD5600C4;
	Tue, 25 Nov 2025 08:55:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C5AC4CEF1;
	Tue, 25 Nov 2025 08:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764060949;
	bh=Mwl10SHsprDsG24tXHNm9Hq0qPyZ3bvWdNtKi5Ctd6g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oK3tj+fxjuLk8QMh1pYn5HXUAGHzlk5JEnmkZ/em4volvbiWyhwmlhysPibjDXtIo
	 fE1EGevXYpHqp4hqUckvIilznbi0MkUKnwqGgXI9rN20fgMgiuoDo5CIhKd8McVyJp
	 m5gaBrbqeQ6GHHcD8NpZhQsFkcBNZtN6YwJTZZ93kKUbrCnvN4DdLztq0Q5Fs3xH8w
	 W3LPlhMF9hvdNUtxcO+ckaXe6FQR2p9uGln4d1yKyb5ZY+OMaEmoRNIcHzy2+g4c0h
	 OByjfXHvzobO8ihAY5pbRDE37ETUypDseCtH3uCa1ESQC9CbI4e1td+CHzZwdsI1AD
	 u7Oecrb12ejzA==
Message-ID: <5421c8d0-1151-48dc-8774-fd2e983735a5@kernel.org>
Date: Tue, 25 Nov 2025 09:55:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] mm/huge_memory: replace can_split_folio() with
 direct refcount calculation
To: Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Wei Yang <richard.weiyang@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251122025529.1562592-1-ziy@nvidia.com>
 <20251122025529.1562592-3-ziy@nvidia.com>
 <51675d77-9453-43cc-bfda-f21a2edfeace@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <51675d77-9453-43cc-bfda-f21a2edfeace@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6BE6020009
X-Stat-Signature: gdo3ccabpmig6gsgim1mjricfpkazob8
X-Rspam-User: 
X-HE-Tag: 1764060950-914591
X-HE-Meta: U2FsdGVkX1+zkl9nZofRXC25eivT43vCzGI9vh0Cn9dYMxUKfiizO86nk16mH9a2CLDRxiDAmgMwu+As4UGAPoszzyPZh0lDkJRDkEhvG747W9f8jEKdgA3zq85G8mQlyc6TtmR2/lZqAOSc6nqnSdPpeTGyXfUyZg6QM34keafmjm0S42JVs2Dm2CI40yEP/DQ6s3nAB+6thXU5mQCE7v/l0pBdGru1W9y0I3cakqjNVNqHN74uFFVg6hQd6Q4hOXQhWBYtYwpgk/1IR6ea/vg6Po1v9fskmciH09JMrLp4aon/zI2EKKKXNMEXvHOxSzWHm0Nnk6lwvYWAIZY0U30UV1LRv2hEATjZHrRr4xiyNh+5HcFo40Z2obE4aC5QUoY0t63untUQ9Lkb1W7TPsNTVuYkPiSaKhicxw0dyxwxgeGrP2tmWOW5JOD/QqBSoJIqDyNK18YPwfSVYseHYNUadW0AyD+9higwS9TMvXcXmnjJw0uRUyCnT7VCAC6Q3zzil3wjDVKZWEJb/pCbBcIOOnIkdPlnT4VEtbLjJmpt1t6hnVjFasOVjef75lEEkKNFE+JqCWxKx1VNO1a/235xDK7RPJC0jtXMd0u+O6VtvZjv6bcArOrR4QL0A/hk/I3D61qm1ori0oLDcfWx5jG0rAu5zCFniOMk9BLP6HzdRkeQnMl1QhWdGgBUMP/QCcl6FFWZAKiNgKZsElktbum9sQ3i3AMBVQnoBFCQIAc7Lo/nMWDH5/wIPxmf+bkXYyZn0SnOfAZcfCHJ2veq7s+P24tmcBdQ9804vklM/yYXfE9f+YdzE/LmTI/q56UuqOzdOioG/D/DDqQ7W+uc6qRs8g7yy7oYq4I5F4SegLO0EP/yzYaRicq0zSZBu1BfuPbahbFmJOeE0DCK8WL/86G2QgJJDtQB/1UqZ4VxccOQlzWlo43cNx9D1jNmnNsVhgrBOTxGDY9EgugE2pU
 ai1m10Fp
 iZocD6phgtevZIXPc/jT7yPOq9KEItT+1Ko4wVhMX8Znb/f8lbaBDjZjx2D2z6Nb0oPIG9yg+eG0jH7cdkGxSh9XsEV/Nvb10+Gu7omO6ugCv5iE6k6EIhW6U/ruCgh4zOVt1TRuMxnDLAKtz3mNLsESyangYqYCL9qRNEaiBiL+jDcwltvwAKSz2pn98v7zY77avUra0jQayuxwhUwyjLCWcYNKAJttJtRkXyMwSNzyMJanJTDKk5EfwrD8nRCfVT69t4LWtsC8wF4j2c76D9jJ11VqQuqTXpihIVzerKIz9lSXnPFKPWp8Zh1CL6/9VeBeWD4/Oi0QiVIEQfUXrES0q5lcJhrwy+pazDG5d+u5oBTx5IkI/yJpHKtMC76EGiRl2+ZSLNWs/xScyspoDJD58Nv1C0ha/lMmNUd1wrNoiEFCvDEa2/K++1nxFGn4vwFJ5heTifnQvqPQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/24/25 23:14, Balbir Singh wrote:
> On 11/22/25 13:55, Zi Yan wrote:
>> can_split_folio() is just a refcount comparison, making sure only the
>> split caller holds an extra pin. Open code it with
>> folio_expected_ref_count() != folio_ref_count() - 1. For the extra_pins
>> used by folio_ref_freeze(), add folio_cache_references() to calculate it.
>>
>> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>   include/linux/huge_mm.h |  1 -
>>   mm/huge_memory.c        | 43 ++++++++++++++++-------------------------
>>   mm/vmscan.c             |  3 ++-
>>   3 files changed, 19 insertions(+), 28 deletions(-)
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index 97686fb46e30..1ecaeccf39c9 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -369,7 +369,6 @@ enum split_type {
>>   	SPLIT_TYPE_NON_UNIFORM,
>>   };
>>   
>> -bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
>>   int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>>   		unsigned int new_order);
>>   int folio_split_unmapped(struct folio *folio, unsigned int new_order);
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index c1f1055165dd..6c821c1c0ac3 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3455,23 +3455,6 @@ static void lru_add_split_folio(struct folio *folio, struct folio *new_folio,
>>   	}
>>   }
>>   
>> -/* Racy check whether the huge page can be split */
>> -bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
>> -{
>> -	int extra_pins;
>> -
>> -	/* Additional pins from page cache */
>> -	if (folio_test_anon(folio))
>> -		extra_pins = folio_test_swapcache(folio) ?
>> -				folio_nr_pages(folio) : 0;
>> -	else
>> -		extra_pins = folio_nr_pages(folio);
>> -	if (pextra_pins)
>> -		*pextra_pins = extra_pins;
>> -	return folio_mapcount(folio) == folio_ref_count(folio) - extra_pins -
>> -					caller_pins;
>> -}
>> -
>>   static bool page_range_has_hwpoisoned(struct page *page, long nr_pages)
>>   {
>>   	for (; nr_pages; page++, nr_pages--)
>> @@ -3776,17 +3759,26 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
>>   	return 0;
>>   }
>>   
>> +/* Number of folio references from the pagecache or the swapcache. */
>> +static unsigned int folio_cache_references(const struct folio *folio)
> 
> folio_cache_ref_count?

Yes, makes sense.

> 
>> +{
>> +	if (folio_test_anon(folio) && !folio_test_swapcache(folio))
>> +		return 0;
>> +	return folio_nr_pages(folio);
>> +}
 >> +>
> Does this belong to include/linux/mm.h with the other helpers?

Not for now I think, in particular, as we require earlier 
!folio->mapping checks to give a correct answer. Most people should be 
using folio_expected_ref_count().

-- 
Cheers

David

