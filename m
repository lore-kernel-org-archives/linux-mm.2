Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48509CF34B2
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 14:09:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E5176B0092; Wed, 19 Nov 2025 09:09:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 795246B00AE; Wed, 19 Nov 2025 09:09:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 684C66B00B0; Wed, 19 Nov 2025 09:09:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 53A476B0092
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 09:09:47 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0D2B012F941
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 14:09:47 +0000 (UTC)
X-FDA: 84127540014.27.5E7070C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5A25C2000F
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 14:09:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fZyVdCtr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763561385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ncYSMy7ToK0WX3I8ngwGO/NXTV1J+DKOVRcBqeRXJKY=;
	b=KfGAfnSjRrTWsmpCU8UzRAnltP/NFTsy3/S2hdk70x3TaszxAv63TcUbY1t9ca0+9QsFCr
	dphsCKj6yPH3yGnJ1AvgPlH2OCRyl5hTq+jLhgTZRAFvyHvAhecyQcW+p2Td+RNpiYZImB
	y6i3nc47gWOnbb95tqqIQnMclNkoCqU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763561385; a=rsa-sha256;
	cv=none;
	b=D2iIfTFiU8erNZqL3PJJbYrj2dTXqB1DV0/rw6JM9xiwJ6YXypDLd7jYrKO1dwf2A//qVs
	tEoDfsw68uKSf8FSMD0wbxg2FENIVpmt5bDNZCDgyxJwXjzz2nlPo16w8ZhiUwVXfgqTtd
	qdwgbJ7bUHexxGZHJ1W93jKHsUq6gvM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fZyVdCtr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 876326016C;
	Wed, 19 Nov 2025 14:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDFAC2BCB4;
	Wed, 19 Nov 2025 14:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763561384;
	bh=UVyGG1Tv0zXtgSd/kXTDkK9fw4Aoqn/vp/kNJbgoBYg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fZyVdCtrFUa4d0MTb0Iv1ACe2kYtgAuUwvCOLufjmtLUVuM00rKFpaIpkGw3oLt9y
	 Cx8COTeKtqKQKwmPqzljVGtnu7JgnzGVvuYoebp7+fdVD1OkdnIs6Ejm8zbNFMiOxw
	 KA0AbAPibeJ7H6G4VanoBigo2B0AXUDDq6pORVkbuwtvzG2UfnRa/F7v7KHQjdCanH
	 gwpMZAPbHLPhlACrWIseejmBJjvXEN7j035IY4N/wXuohLettQpKLtmaU9VcxymUql
	 kTucd83NUQOTHJYufxS9DWPZuZTpOEYqFo3HEvZ9t2SdQq8JcHcbq6i3u75/OUSPEW
	 Aam4gDN6OztcQ==
Message-ID: <4f9df538-f918-4036-b72c-3356a4fff81e@kernel.org>
Date: Wed, 19 Nov 2025 15:09:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: fix NULL pointer deference when splitting
 shmem folio in swap cache
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org, stable@vger.kernel.org
References: <20251119012630.14701-1-richard.weiyang@gmail.com>
 <a5437eb1-0d5f-48eb-ba20-70ef9d02396b@kernel.org>
 <20251119122325.cxolq3kalokhlvop@master>
 <59b1d49f-42f5-4e7e-ae23-7d96cff5b035@kernel.org>
 <950DEF53-2447-46FA-83D4-5D119C660521@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <950DEF53-2447-46FA-83D4-5D119C660521@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qnp1nwgdi8q9rp6imc3zjgfeddgazj9j
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A25C2000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1763561385-817531
X-HE-Meta: U2FsdGVkX1/xe2qMoItLw0wmNeZ88keXafbFbnOCpd+Hlvy/T5/IrR3ocS67Lntta2DE5mB7weR/wOfNWvw8kWLhzxhokjk/kNt4lxBVLdGDRyiCQlWINaxcaffx/jW4iIS1N9SnedTQig2q9BWhEGKfhvhiOBJ8PVStCBtxJ96if2dnbbbGkMaifSYklsY5JOGgjBvNEsDWBNkioDiufnfoagUssdo+paSMrklM2burj5ylbnMUMvfz57ALzaV7D120i40JMFU5P66mJjXKeFR62FJBNuxGwXch1ZcnVcluvGXnO9Z1SmUxGkPJZE7r2LIp1SYHeUrNG8GUhnnFRClOtvfQG14OOCwrV3VyyyWen8YU6KDDjas+T73BGEPI8wxcqnOZ2GJFn94TB8cxpMw6BEE6ABBq+ctK5qzXP6gZCQkTmduqTwQsm/goK5UrAjJwmRzu7bDwtqt7B2nypjfaEcj2HCXcILj29ClNvtuzezrFbmIOeIq9TIhJL74y6vlWX2W4h4lhcbL6l+idpN32IwrEa8/9C+MVmvLRrWJdO3IoZ1tzNrBtAMho2lm2p3RcnfAjD/Avk4FPzEyFFikpkq/KcUnlP43LiWo6NPukysJB4RbkhTlCfqNMQ6y9uEOaRYj5maz2QUgXYH1gVtOO6NM+FoI9IdEWLyxUng9jyqJR6pv7I7jj6dfYuAsDq+OkINT6sYctuPBZE7H8/zYUsZY/x0SXANau69bLmsdDBKDrUUih1S2ijRGFyO8Rd0eWC7rnykauhG085OqDB86Jb48RCDbqnZxZPbI0AEXT7ZRZsAyTQrapfGJ5t84EBn93hWnvJpDLWIFS+vdhTkD/mUcZ8v5B1RFcDZ/73/ACtY1TZn6UUia0LhCB4mQiVJNf2GX2IIrz/vGMVuUXszR7cldAXiKcJwhp72d0zuNayHOrei8Q4ft77rXn7/ly5E7vUBNp/N+wmKP6qDh
 AaHsrvuf
 gXrjolAwxOwVFUVTzei2+n32ignNllcxAs9M3+FTFN6o9nhl5QJQUiZEk5+K8SqyFzvBk8fgQLepGYtct+xK8jgnInQH21LRn+PX6oUV0OqJF0NowZn1KHchwsDrPoG/tmcxctDstoKo74jnSTzduLQ3Cv78qITdppHQpI+UQVsywJ5z8OpLoeedjbrQZi2b9AjAiyzHr3QJZhiFZL93N9AtAaeJ/FkFciLNO/xMSNo6nm/bsNWEGG77HzngFL+uyaw/iz7/oXRotOh8GRB+ZVrO52fTz/U3DjHdt4fTzn9Q2TeJYxy/L7DLD9P5ShfQV0qBtEMKlFavGmIEoWKlytzYtfH6ZQuSp4Dwf4Sc0DT4X40a+shg0DYWXGn0dhgMs5XUG/EwH61U7ZIBU8/r/neGrEnxjvtDpIp0uiqFMzUgkWL6sPJS9tiCHzmbn0157DvluKHSZ8peOSb6ENYqYTgQaJaJQUIz+qpOasq96uUFIyGZa5sPJbClhV/Bh8g2KYzVY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.11.25 14:08, Zi Yan wrote:
> On 19 Nov 2025, at 7:54, David Hildenbrand (Red Hat) wrote:
> 
>>>
>>>> So I think we should try to keep truncation return -EBUSY. For the shmem
>>>> case, I think it's ok to return -EINVAL. I guess we can identify such folios
>>>> by checking for folio_test_swapcache().
>>>>
>>>
>>> Hmm... Don't get how to do this nicely.
>>>
>>> Looks we can't do it in folio_split_supported().
>>>
>>> Or change folio_split_supported() return error code directly?
>>
>>
>> On upstream, I would do something like the following (untested):
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 2f2a521e5d683..33fc3590867e2 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3524,6 +3524,9 @@ bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
>>                                  "Cannot split to order-1 folio");
>>                  if (new_order == 1)
>>                          return false;
>> +       } else if (folio_test_swapcache(folio)) {
>> +               /* TODO: support shmem folios that are in the swapcache. */
>> +               return false;
>>          } else if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>>              !mapping_large_folio_support(folio->mapping)) {
>>                  /*
>> @@ -3556,6 +3559,9 @@ bool uniform_split_supported(struct folio *folio, unsigned int new_order,
>>                                  "Cannot split to order-1 folio");
>>                  if (new_order == 1)
>>                          return false;
>> +       } else if (folio_test_swapcache(folio)) {
>> +               /* TODO: support shmem folios that are in the swapcache. */
>> +               return false;
> You are splitting the truncate case into shmem one and page cache one.
> This is only for shmem in the swap cache and ...
> 
>>          } else  if (new_order) {
>>                  if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>>                      !mapping_large_folio_support(folio->mapping)) {
>> @@ -3619,6 +3625,15 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>          if (folio != page_folio(split_at) || folio != page_folio(lock_at))
>>                  return -EINVAL;
>>   +       /*
>> +        * Folios that just got truncated cannot get split. Signal to the
>> +        * caller that there was a race.
>> +        *
>> +        * TODO: support shmem folios that are in the swapcache.
> 
> this is for page cache one. So this TODO is not needed.

I added the TODO because we'd like to detect truncation there as well I think. Hm.

> 
>> +        */
>> +       if (!is_anon && !folio->mapping && !folio_test_swapcache(folio))
>> +               return -EBUSY;
>> +

Given folio_test_swapcache() might have false positives,
I assume we'd need a

	folio_test_swapbacked() && folio_test_swapcache(folio)

To detect large large shmem folios in the swapcache in all cases here.

Something like the following would hopefully do:

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2f2a521e5d683..57aab66bedbea 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3515,6 +3515,13 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
         return ret;
  }
  
+static bool folio_test_shmem_swapcache(struct folio *folio)
+{
+       VM_WARN_ON_ONCE_FOLIO(folio_test_anon(folio), folio);
+       /* These folios do not have folio->mapping set. */
+       return folio_test_swapbacked(folio) && folio_test_swapcache(folio);
+}
+
  bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
                 bool warns)
  {
@@ -3524,6 +3531,9 @@ bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
                                 "Cannot split to order-1 folio");
                 if (new_order == 1)
                         return false;
+       } else if (folio_test_shmem_swapcache(folio)) {
+               /* TODO: support shmem folios that are in the swapcache. */
+               return false;
         } else if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
             !mapping_large_folio_support(folio->mapping)) {
                 /*
@@ -3556,6 +3566,9 @@ bool uniform_split_supported(struct folio *folio, unsigned int new_order,
                                 "Cannot split to order-1 folio");
                 if (new_order == 1)
                         return false;
+       } else if (folio_test_shmem_swapcache(folio)) {
+               /* TODO: support shmem folios that are in the swapcache. */
+               return false;
         } else  if (new_order) {
                 if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
                     !mapping_large_folio_support(folio->mapping)) {
@@ -3619,6 +3632,13 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
         if (folio != page_folio(split_at) || folio != page_folio(lock_at))
                 return -EINVAL;
  
+       /*
+        * Folios that just got truncated cannot get split. Signal to the
+        * caller that there was a race.
+        */
+       if (!is_anon && !folio->mapping && !folio_test_shmem_swapcache(folio))
+               return -EBUSY;
+
         if (new_order >= folio_order(folio))
                 return -EINVAL;
  
@@ -3659,17 +3679,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
                 gfp_t gfp;
  
                 mapping = folio->mapping;
-
-               /* Truncated ? */
-               /*
-                * TODO: add support for large shmem folio in swap cache.
-                * When shmem is in swap cache, mapping is NULL and
-                * folio_test_swapcache() is true.
-                */
-               if (!mapping) {
-                       ret = -EBUSY;
-                       goto out;
-               }
+               VM_WARN_ON_ONCE_FOLIO(!mapping, folio);
  
                 min_order = mapping_min_folio_order(folio->mapping);
                 if (new_order < min_order) {

>>>
>>>>
>>>> Probably worth mentioning that this was identified by code inspection?
>>>>
>>>
>>> Agree.
>>>
>>>>>
>>>>> Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
>>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>> Cc: <stable@vger.kernel.org>
>>>>
>>>> Hmm, what would this patch look like when based on current upstream? We'd
>>>> likely want to get that upstream asap.
>>>>
>>>
>>> This depends whether we want it on top of [1].
>>>
>>> Current upstream doesn't have it [1] and need to fix it in two places.
>>>
>>> Andrew mention prefer a fixup version in [2].
>>>
>>> [1]: lkml.kernel.org/r/20251106034155.21398-1-richard.weiyang@gmail.com
>>> [2]: lkml.kernel.org/r/20251118140658.9078de6aab719b2308996387@linux-foundation.org
>>
>> As we will want to backport this patch, likely we want to have it apply on current master.
>>
>> Bur Andrew can comment what he prefers in this case of a stable fix.
> 
> That could mess up with mm-new tree[1] based on Andrew's recent feedback.

Right, a similar fix could be had against mm-new.

-- 
Cheers

David

