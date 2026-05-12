Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16F00CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 12:44:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E4076B0088; Tue, 12 May 2026 08:44:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26D416B008A; Tue, 12 May 2026 08:44:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10ED66B008C; Tue, 12 May 2026 08:44:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F140D6B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:44:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9497BC1A79
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:44:01 +0000 (UTC)
X-FDA: 84758735082.14.F9E94F9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id E271BC0002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:43:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OLtwiSVC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778589839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hnBiFGs7meSLaep9vuUpfuWY/I8YfPMXfYw+UxiybTw=;
	b=N8wM0i3jF28zUHiaf5wDnxUvW9OcGAcWR32WqPZyaQIeQHb5msrFu8e9yBVFxdm5gXUeOH
	ZJV9NFkjtL53juiEwxbq3OEFIAKtnazIE8B8elxNQ8oga9uZMOC9iAI3f++1W52MzliEDl
	D9VmsLv/eMyCdAlKlz0CsNascQ7Epjs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778589839; a=rsa-sha256;
	cv=none;
	b=uPeEkyrDt+b812e7+5PA2i+Rxf2P3PwBful4JZEiCy9qlTPKaZguZOY9jfP41nlBdrnvdd
	0eHSHbbVzv3Owx7LLs7DaFOZIrMw2LfznqXJ/YPHKYGMeA3VTTtHLtStXZTZdndAcxikG6
	A2jCkaMOaiSqL8NSo0PNhw5Hz1w4HOY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OLtwiSVC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 51C4560055;
	Tue, 12 May 2026 12:43:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78994C2BCF6;
	Tue, 12 May 2026 12:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778589839;
	bh=I5pqYbtb8YWMtcrOo1h5bGHH+X+Vvx6Hiv3RX7OtTcE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OLtwiSVCq7nWWP1cp2w5j+JfWqtuubgy8aNlU+xPV68CcKqmNxgfqCC2uUTWNZe/u
	 0bpQzQ6ITLuqlnUDD8vP0Y+ZsTfYyIMXteAWMPIL+S22EzLuajOnDkgrQngFGigcqT
	 1Xrty+V2AJCWjwIKk6rCU78k2azusczc0xTbUgYKtaUS5XBf8Uw+Mq7j96HoODA4nO
	 IaE+u7lUO13Z78XIBRHdx8ynzTamZSKP/bXUxLDVtRhjh7R2yOAsRlDEFYovZuS6R0
	 sCB8174KOKqPSycPqcgBLG43aBdwxVmZJHKkeodDiESfTg1HcRmO9FxVFuOGafQNf8
	 tDt8JQ5TE44Ng==
Message-ID: <0aab59b8-71c5-4059-8281-5dd876946528@kernel.org>
Date: Tue, 12 May 2026 14:43:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_vma_mapped: revalidate and do proper check before
 return device-private pmd
To: Balbir Singh <balbirs@nvidia.com>, Wei Yang <richard.weiyang@gmail.com>,
 akpm@linux-foundation.org, ljs@kernel.org, riel@surriel.com,
 liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 sj@kernel.org, ziy@nvidia.com
Cc: linux-mm@kvack.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 stable@vger.kernel.org
References: <20260508013728.21285-1-richard.weiyang@gmail.com>
 <5e9ee072-b927-41e0-ba98-c9fdf11eccbc@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <5e9ee072-b927-41e0-ba98-c9fdf11eccbc@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E271BC0002
X-Stat-Signature: h1oxfap7ujd1yqhdd555pumtd7wqg441
X-Rspam-User: 
X-HE-Tag: 1778589839-509575
X-HE-Meta: U2FsdGVkX1+YJH1eRrnh0mPfZumkx/ZEEMM0oQGmRxCqCWqudzJxcDtLetlO1GHMYruvJiiReSptoJXo81AxbVFaozFAGAiueUteUrFkYjw20FC+rRHzlKiESiJsRIekMXAzVANG9BaxfN7dVEb3T3WtC7vJ83Ms1TPE9gTj6fOaPnb5KO/ZLrdD5s/lX3StDKen1idX9aUm/gJ+4D+NJRV8ZKK08cT888xOX5rgHe4+axCIlIt+ydU9XPULVAkZticRc4xHk/SygBy7NuHmP76iMgSrdKa3gwnxX/Ba69Og+eQt4nQuTzWpC/oMOFaUowaivCZufWx/XheIszO666pa8VdmoWxJssJJFnEq7ZYaZJyoKQLptoKpHdcnSD4xAA5LQSLK+GZbdTHO7kWXV4tYjYe0S3I5QT65Qs/LRMx0JyBad1eXBrKED0fDoYgYrta3BR4g+ejfE9Y8kRppY6iSc91qa5bUAHN2b21qiqrLAmH3gA0HOF0ZjA22WxCppZzIKb103OqEEctUuL5cI9vKk2JhtPMNX6TzftAzHVlCyJFTino2dTcwMPCSRZdmFU1aVKEesrG0UNmsj20PhVdgUnUMhFJDjqNAx43JPN1/Hm5FuE5Ew36Mivk/SrIeYm5lG109JDI1y9zPneZLGhSmUZx3hu6xaju/usPfjSpI8nS22EdtFhfinw3YxBHOaPpT+Unxzc1Aasj3SpensiRWgJXFoWPwm2Z3MB8qkE7zxjZwUE+7IT9XhVJVcaTVnlD+1lgWIez3G2cRCvICXqREuzClc+yZRz1gAKrLXm/O7iOJFbM3VETUePbiZ2qKeg6SCbpkLzaAkk3a68HZvHkqdaC+F0SFqwCJ/UrXf3pLPSqBJuJqJw/Jm5OPJq9uHlYUW9HZa1Pt7tfKgMhwlToTvWETkwEpqxAC7M1yexNhEF+oMIL7MYgyudJYQdNQ+9O0LAvj9U2J0jr1s8d
 QfVVqeeF
 bJl4/3P7owjl0TPfZgyNcGHpV0tEm3HYLMEpDYnSz22X4lhfTaha7NQ0UHyM7SJkQsiwHJD1qTjvXqQZtNE8rj9nBjJStB7qgommPSk65nO3Uu0ubPvFvIcIURZWz7YiMHAzzpB9xC1PPV9DfX/gtycIwL6Wgg2vWtKZLNfr9pgKXV2pnXqUWfi9fCr6nA58eSjLnztsuu1A89lIl17VzNPGE1pzEi/R1DOiqZiiT6UyNN1GfES2T8bzsuUxgTKSjOwg+gM4J/LIicsRqP3EPl3r34EvqTBXhUN8sEaHEXNI5mU+/TQ3Vl+BB0/f7EcKlJgsG7qgVNxzx5cqfTmOQhbLbCK9b06ffBGOFF1paSi9CPuty4lyaCmvS4eB2vjByvc27Uul3xnlFQD1RxwKbJb3I5Mktgft8vLwj74meWMnD7Nox5FjkUDg0K84W/lAEdtnYmO6qrIY7z7v417J/pHnjBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/9/26 00:48, Balbir Singh wrote:
> On 5/8/26 11:37, Wei Yang wrote:
>> For pmd_trans_huge() and pmd_is_migration_entry(), we does following
>> before return the pmd entry:
>>
>>   * re-validate pmd entry
>>   * check PVMW_MIGRATION
>>   * check_pmd()
>>   * handle on pte level if split under us
>>
>> But for device-private pmd, we just return after pmd_lock(). This may
>> lead to inproper situation.
>>
> 
> Could you elaborate a more on the improper situation?
> 
>> This patch fixes commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration
>> support device-private entries") by following the same pattern as
>> pmd_trans_huge() and pmd_is_migration_entry().
>>
>> Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: David Hildenbrand <david@kernel.org>
>> Cc: Balbir Singh <balbirs@nvidia.com>
>> Cc: SeongJae Park <sj@kernel.org>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: <stable@vger.kernel.org>
>> ---
>>  mm/page_vma_mapped.c | 34 +++++++++++++++++++++++-----------
>>  1 file changed, 23 insertions(+), 11 deletions(-)
>>
>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>> index a4d52fdb3056..5d337ea43019 100644
>> --- a/mm/page_vma_mapped.c
>> +++ b/mm/page_vma_mapped.c
>> @@ -269,21 +269,33 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>  			spin_unlock(pvmw->ptl);
>>  			pvmw->ptl = NULL;
>>  		} else if (!pmd_present(pmde)) {
>> -			const softleaf_t entry = softleaf_from_pmd(pmde);
>> +			softleaf_t entry = softleaf_from_pmd(pmde);
>>  
>>  			if (softleaf_is_device_private(entry)) {
>>  				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>> -				return true;
>> -			}
>> -
>> -			if ((pvmw->flags & PVMW_SYNC) &&
>> -			    thp_vma_suitable_order(vma, pvmw->address,
>> -						   PMD_ORDER) &&
>> -			    (pvmw->nr_pages >= HPAGE_PMD_NR))
>> -				sync_with_folio_pmd_zap(mm, pvmw->pmd);
>> +				entry = softleaf_from_pmd(*pvmw->pmd);
>> +
>> +				if (softleaf_is_device_private(entry)) {
> 
> Do we need to check softleaf_is_device_private() twice, can't we hold the pmd
> lock and check once?

I think what we try to do here is, is to only grab the lock if we verified that there is something of interest in there.

I wonder if we should rewrite that whole thing to just do a pmd_same() check after grabbing the lock.

Something a lot cleaner like:

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index a4d52fdb3056..de6a255cc847 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -242,40 +242,28 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
                 */
                pmde = pmdp_get_lockless(pvmw->pmd);
 
-               if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
-                       pvmw->ptl = pmd_lock(mm, pvmw->pmd);
-                       pmde = *pvmw->pmd;
-                       if (!pmd_present(pmde)) {
-                               softleaf_t entry;
-
-                               if (!thp_migration_supported() ||
-                                   !(pvmw->flags & PVMW_MIGRATION))
-                                       return not_found(pvmw);
-                               entry = softleaf_from_pmd(pmde);
-
-                               if (!softleaf_is_migration(entry) ||
-                                   !check_pmd(softleaf_to_pfn(entry), pvmw))
-                                       return not_found(pvmw);
-                               return true;
-                       }
-                       if (likely(pmd_trans_huge(pmde))) {
-                               if (pvmw->flags & PVMW_MIGRATION)
-                                       return not_found(pvmw);
-                               if (!check_pmd(pmd_pfn(pmde), pvmw))
-                                       return not_found(pvmw);
-                               return true;
-                       }
-                       /* THP pmd was split under us: handle on pte level */
-                       spin_unlock(pvmw->ptl);
-                       pvmw->ptl = NULL;
-               } else if (!pmd_present(pmde)) {
-                       const softleaf_t entry = softleaf_from_pmd(pmde);
-
-                       if (softleaf_is_device_private(entry)) {
-                               pvmw->ptl = pmd_lock(mm, pvmw->pmd);
-                               return true;
-                       }
+               if (pmd_present(pmde)) {
+                       if (!pmd_leaf(pmde))
+                               goto pte_table;
+                       if (pvmw->flags & PVMW_MIGRATION)
+                               return not_found(pvmw);
+                       if (!check_pmd(pmd_pfn(pmde), pvmw))
+                               return not_found(pvmw);
+               } else if (pmd_is_migration_entry(pmde)) {
+                       softleaf_t entry = softleaf_from_pmd(pmde);
+
+                       if (!(pvmw->flags & PVMW_MIGRATION))
+                               return not_found(pvmw);
+                       if (!check_pmd(softleaf_to_pfn(entry), pvmw))
+                               return not_found(pvmw);
+               } else if (pmd_is_device_private_entry(pmde)) {
+                       softleaf_t entry = softleaf_from_pmd(pmde);
 
+                       if (pvmw->flags & PVMW_MIGRATION)
+                               return not_found(pvmw);
+                       if (!check_pmd(softleaf_to_pfn(entry), pvmw))
+                               return not_found(pvmw);
+               } else {
                        if ((pvmw->flags & PVMW_SYNC) &&
                            thp_vma_suitable_order(vma, pvmw->address,
                                                   PMD_ORDER) &&
@@ -285,6 +273,15 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
                        step_forward(pvmw, PMD_SIZE);
                        continue;
                }
+
+               /* Double-check under PTL that the PMD didn't change. */
+               pvmw->ptl = pmd_lock(mm, pvmw->pmd);
+               if (pmd_same(pmde, pmdp_get(pvmw->pmd)))
+                       return true;
+               spin_unlock(pvmw->ptl);
+               pvmw->ptl = NULL;
+               goto restart;
+pte_table:
                if (!map_pte(pvmw, &pmde, &ptl)) {
                        if (!pvmw->pte)




There is likely room to clean this up / compress it further.

I'll note that this now also adds proper check_pmd() checks to pmd_is_device_private_entry().

The not_found(pvmw) if check_pmd() fails is rather weird ... but likely this works because
THPs can really only be mapped through one PMD, and we always will look at the right spot ...

-- 
Cheers,

David

