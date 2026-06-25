Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4569ACDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:42:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB8106B00AD; Thu, 25 Jun 2026 07:42:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D68B16B00AE; Thu, 25 Jun 2026 07:42:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C326A6B00AF; Thu, 25 Jun 2026 07:42:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A0C46B00AD
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:42:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CF74114069F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:42:50 +0000 (UTC)
X-FDA: 84918248100.16.0A2CAAF
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id F18C740011
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:42:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dzqAtWAy;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782387769;
	b=OWe3kUjs3wCW8HBIaHg/mxl1sgVnq/sJA0a72YbAvv7s68xT9Qu9ZcbyNsiTiA4KPoMgVm
	V9iId0onmPYZzuSVEz9fFKiU1WiPgISC6Z03YUXECTUcfkzInyTiiASeRfEy95R6qHLg0N
	FvCMQGK+WHYlwYgqh39NvmU0FfVw4v8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782387769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iIWPblH51guS5xkGlOLDh1Cowk9hcXc97vRIu7QXNA8=;
	b=7rORZa9i5RWCrbxqyR95I/zc8AsN+5zXIYX9jGqtEtufRcbOb0kiHcNPFjeMWj5HYyZpn5
	rEM/wWL1ecoKPFkih6W4qWapfw+OZYN1tuW7nOg76pvtd8BrdYPWQofoNuPbab5KUhcCDp
	7/wYVRpu1rd0BWG04Qjh5nQQeTvIpN0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dzqAtWAy;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782387766;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iIWPblH51guS5xkGlOLDh1Cowk9hcXc97vRIu7QXNA8=;
	b=dzqAtWAy92LgGrBYUpeYiyI+geAzdk11MZAp61pXhyjOW+4UHgXuszSfFsuexOdLAE7LLH
	AdcRSiXLKwnKLA5WszKWa+glQK0zPNce2XBAUrvVV1C8k1S/weKOAyR7Xw2a8u8N96JA7c
	nuXUz7AQcNVD6DOeb49LJs6nv991Wec=
From: Lance Yang <lance.yang@linux.dev>
To: richard.weiyang@gmail.com,
	david@kernel.org,
	balbirs@nvidia.com
Cc: akpm@linux-foundation.org,
	ljs@kernel.org,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	ziy@nvidia.com,
	sj@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [Patch mm-hotfixes v4] mm/page_vma_mapped: fix device-private PMD handling
Date: Thu, 25 Jun 2026 19:42:35 +0800
Message-Id: <20260625114235.40611-1-lance.yang@linux.dev>
In-Reply-To: <20260624085756.6598-1-lance.yang@linux.dev>
References: <20260624085756.6598-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F18C740011
X-Rspam-User: 
X-Stat-Signature: jztbbytqdk8nzmscja5bndbtgyrqmup3
X-HE-Tag: 1782387768-29808
X-HE-Meta: U2FsdGVkX19GGFhk6ZuLqg7r6J+IMwH8kpSDJlBhnDZ7dLDfi1+6hXQEF+Sz5mJc/f/m9wK3zbDGYic77CaD/x76+Pxi9dDoya/6bDpdjlFaD4Hxqgg/dMpXAW5vHYcgSltEr34V50pLyV7RIX8WMyYaC3sDp54X2rQBVxwdqU8rx+Q0xCgcgiSNzzP1lSsgCcizHhNkRX7EY4/o2F98EkMbBdEwUJTOZl7nj+Xpl5lgFoXlPzuJKtb4dwe5jmkppd6Dz523QB3lDthlKz6mAirA0mINEZPkBvbEzoqW1NlVj3yMK4fhJ9LgTgtc/MAxu/qRlIZoe4XxPURYNrwqle1jvbXEWnSHoeBBED4Q1E3dcjPq07/4CqUPkEuWQi8SBgq8sqYqcG7tmnkzMX53PRJw/5YAbOeOHzJO3aanR9TJuXx/19dMYvfsmRTDnxhJZEXWwPxDbf+CbaLkq6mLeuxAO55oE3I9iM4txzZE0zlO98FT7bocdvSiZRUvBEdyGom5Ah/NAK8IniiuCBoKy1vHrH8huSDFVdOurJb6AT+FMfAIs5jqxzswJ1IYKuiFiw+Zl5M0E7y0gMPQVjiA2tK6XKts4KxAfvRNQALedoUxl8C2nMo0rtvFm5uG0LHodCRTO35NR8fbB+XTzL/JHb+jFgCUMs5EQvuxZLWskOfcBv4diGIAcutlyorCGmKMG5OL8wjMHR5hCos8PEFL4kDSftyptMCqKm4an6fLkKFKk/0RafmydmICDKDunFpNVb5eJjLsa7ADZz1T9eC+oufJqNvkJQGGiU3DdmNYx6aepUgFphHOWlMd1bT+Xy02RJOK9DWPhYMih0OXZjx7M0og0314toyb9VvGFKHYzNPDOpNgiRHGGm0gZt1ompn85Tkh2Hrz2JolPbd59wok0GzXF0Uvx5iYxFZ0LovEGR1cduxMo4K/MWrzjU3hfEKKIuDi5T+adGIH4kz2Nwp
 In6Shwij
 onFRtkoQVi1HhTmNfI1QPFz7dm+7XDwc4G+O91JFmxD16DH0lHrCYPga1iwut2AguOWHF2d49+/ULpk84/YeQsaXRtESNHZCOGpYULfIx7drF6DIMBOxwuyJy7NVtgu/X7MQrcdGKQvgLtLalYCyyqvZJp9idpdsaGtoIgTz4rVoipOsHKrLcbR9zdgZNVoCvUn6Sww8OIWWDrmTxKLPVAuouRD4SKFfQhY7HKpduXSqHov2RX6Uo7KGSgkZHemZy35jnKJsYaNmZZW7YIpfjJ08l72S6x7UJXM5fEj8SfGWueZmDCjZ/+G/lvFeXhWJt7ssJmge7AeXw5W9pkO+OYCroF5MGBubeUICToGXSmI2rGa4N1UYXL4XhF8YsMdqpT2ZyiZjAKB9p8LhSBbbef3ar/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Jun 24, 2026 at 04:57:56PM +0800, Lance Yang wrote:
>
[...]
>>
>>Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
>>Cc: <stable@vger.kernel.org>
>>Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>Suggested-by: David Hildenbrand <david@kernel.org>
>
>Shouldn't we add
>
>Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
>
>as well?

No need to resend. I think Andrew can add this when applying :)

>v4 mostly follows Lorenzo's comments, code bits included. Feels only fair.
>
>>Cc: David Hildenbrand <david@kernel.org>
>>Cc: Balbir Singh <balbirs@nvidia.com>
>>Cc: SeongJae Park <sj@kernel.org>
>>Cc: Zi Yan <ziy@nvidia.com>
>>Cc: Lorenzo Stoakes <ljs@kernel.org>
>>Cc: Lance Yang <lance.yang@linux.dev>
>>
>>---
>>v4:
>>  * refine subject and commit log based on Lorenzo's suggestion
>>  * put pmd device-private entry handling in its own if branch,
>>    suggested by Lorenzo
>>
>>v3:
>>  * remove cleanup part, only fix the issue for device-private entry
>>  * refine user effect description based on Lorenzo's suggestion
>>
>>v2: https://lore.kernel.org/all/20260616063436.20455-1-richard.weiyang@gmail.com/T/#u
>>  * specify the possible error case of current code and user visible effect
>>  * besides fix, cleanup the pmd entry handling based on David's suggestion
>>
>>v1: https://lore.kernel.org/linux-mm/20260508013728.21285-1-richard.weiyang@gmail.com/
>>---
>> mm/page_vma_mapped.c | 20 +++++++++++++++-----
>> 1 file changed, 15 insertions(+), 5 deletions(-)
>>
>>diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>index 2ccbabfb2cc1..17dff8aab9f9 100644
>>--- a/mm/page_vma_mapped.c
>>+++ b/mm/page_vma_mapped.c
>>@@ -269,14 +269,24 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>

Never mind my race comment below. Obviously missed folio lock there. My
bad. Don't have a caller like that. Nothing else jumped out, so:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

Cheers, Lance

>
>Hmm ... looks like there may still be a race here ...
>
>Current code picks the branch from the lockless PMD value:
>
>		pmde = pmdp_get_lockless(pvmw->pmd);
>
>		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
>			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>			pmde = *pvmw->pmd;
>			if (!pmd_present(pmde)) {
>				softleaf_t entry;
>
>				if (!thp_migration_supported() ||
>				    !(pvmw->flags & PVMW_MIGRATION))
>					return not_found(pvmw);
>				entry = softleaf_from_pmd(pmde);
>
>				if (!softleaf_is_migration(entry) ||
>				    !check_pmd(softleaf_to_pfn(entry), pvmw))
>					return not_found(pvmw);
>				return true;
>			}
>		}
>
>But after taking PTL, the PMD may already be a different non-present PMD
>type:
>
>CPU0: pmde = pmdp_get_lockless();   // sees PMD migration entry
>
>CPU1: remove_migration_ptes(src, dst /* device-private */)
>        ... via rmap_walk(dst) ...
>        page_vma_mapped_walk(&pvmw /* src, PVMW_MIGRATION */)
>          returns with PTL held for the PMD migration entry
>        remove_migration_pmd(new = dst page)
>          installs a device-private PMD
>        next page_vma_mapped_walk()
>          drops PTL via not_found()
>
>CPU0: takes PTL
>      pmde = *pvmw->pmd;            // now device-private PMD
>
>So when PVMW_MIGRATION is not set, current code can return not_found()
>before we even decode the locked PMD as a device-private entry.
>
>Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
>device-private entries") made the
>
>device-private PMD <-> PMD migration
>
>transition possible.
>
>set_pmd_migration_entry() can replace a device-private PMD with a PMD
>migration entry, and remove_migration_pmd() can restore a PMD migration
>entry back to a device-private PMD when the new folio is device-private.
>
>Maybe decode the locked softleaf entry first, before the migration-only
>checks? Something like this on top:
>
>---8<---
>diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>index 17dff8aab9f9..97babd408dba 100644
>--- a/mm/page_vma_mapped.c
>+++ b/mm/page_vma_mapped.c
>@@ -249,10 +249,18 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
> 			if (!pmd_present(pmde)) {
> 				softleaf_t entry;
>
>+				entry = softleaf_from_pmd(pmde);
>+				if (softleaf_is_device_private(entry)) {
>+					if (pvmw->flags & PVMW_MIGRATION)
>+						return not_found(pvmw);
>+					if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>+						return not_found(pvmw);
>+					return true;
>+				}
>+
> 				if (!thp_migration_supported() ||
> 				    !(pvmw->flags & PVMW_MIGRATION))
> 					return not_found(pvmw);
>-				entry = softleaf_from_pmd(pmde);
>
> 				if (!softleaf_is_migration(entry) ||
> 				    !check_pmd(softleaf_to_pfn(entry), pvmw))
>@@ -266,7 +274,10 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
> 					return not_found(pvmw);
> 				return true;
> 			}
>-			/* THP pmd was split under us: handle on pte level */
>+			/*
>+			 * THP pmd was split under us, or device-private PMD
>+			 * changed under us: handle on pte level.
>+			 */
> 			spin_unlock(pvmw->ptl);
> 			pvmw->ptl = NULL;
> 		} else if (pmd_is_device_private_entry(pmde)) {
>--
>
>Anyway, that stuff is getting kinda messy now. Feels like it really needs
>a cleanup on top before it bites us again :)
>
>Cheers, Lance
>
>> 			/* THP pmd was split under us: handle on pte level */
>> 			spin_unlock(pvmw->ptl);
>> 			pvmw->ptl = NULL;
>>-		} else if (!pmd_present(pmde)) {
>>-			const softleaf_t entry = softleaf_from_pmd(pmde);
>>+		} else if (pmd_is_device_private_entry(pmde)) {
>>+			softleaf_t entry;
>>+
>>+			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>+			pmde = *pvmw->pmd;
>>+			entry = softleaf_from_pmd(pmde);
>> 
>>-			if (softleaf_is_device_private(entry)) {
>>-				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>+			if (likely(softleaf_is_device_private(entry))) {
>>+				if (pvmw->flags & PVMW_MIGRATION)
>>+					return not_found(pvmw);
>>+				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>>+					return not_found(pvmw);
>> 				return true;
>> 			}
>>-
>>+			/* device-private pmd was split under us: handle on pte level */
>>+			spin_unlock(pvmw->ptl);
>>+			pvmw->ptl = NULL;
>>+		} else if (!pmd_present(pmde)) {
>> 			if ((pvmw->flags & PVMW_SYNC) &&
>> 			    thp_vma_suitable_order(vma, pvmw->address,
>> 						   PMD_ORDER) &&
>>-- 
>>2.34.1
>>
>>
>

