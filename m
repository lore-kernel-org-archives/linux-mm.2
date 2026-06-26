Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A04C0C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 13:27:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 930736B0093; Fri, 26 Jun 2026 09:27:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E2AF6B0095; Fri, 26 Jun 2026 09:27:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AA1C6B0096; Fri, 26 Jun 2026 09:27:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B6546B0093
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:27:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D325B1A0448
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 13:27:43 +0000 (UTC)
X-FDA: 84922141206.02.26EE831
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf01.hostedemail.com (Postfix) with ESMTP id D965940007
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 13:27:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pUQzZ0BV;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782480462;
	b=X5rWHS7P9a7eyGDNWl6n5G09EZDPjJ8FUXvd6pd/3FDMIqHUnLW8dakjijHbETpfK54AtY
	3W3VHxXc55v35YzkoqbAd8iP+Fn71TNJn+jIgRcEsaAN69hkescPv3hypkGHkx8cwSryzz
	PjGikPgakqxxLx8JMUlvIJuDLgGh4vM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782480462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ghpaBsrpYAmZE4oN9Cjyh87J0Oku7CAuJiHsy66tstE=;
	b=cKAjE1fKaimYaFyc0r+6uAytkuWK4po+6+R275bEfAYAC5edOWitidES6UPyCxJj9g2VFM
	okvwY414FKW3LJUlQxSPGQMTr9f+1Oi4OzK2AHloTNaJBQJ7Yp3i3Q4EKsb9PMO5Bwyars
	LVjBavCI9YFa77kR/UKcF05EOaLA78E=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pUQzZ0BV;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782480459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ghpaBsrpYAmZE4oN9Cjyh87J0Oku7CAuJiHsy66tstE=;
	b=pUQzZ0BVEETWi+puzHlvxJrbGLuKD4XEy2smCcyFMgkMjD35NOc6IVa1LkFETekQcfLBGx
	QF/4IyCRAqgPdiAyGkdLM6Q+Vcbr8gp10laRtudBjf1+hxth/8VVcgoImOQIJ6evT1ZyRB
	kU6RvGqi/4g2pNDEqdgqA/ljTyGncvw=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: richard.weiyang@gmail.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	ziy@nvidia.com,
	sj@kernel.org,
	balbirs@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	lance.yang@linux.dev
Subject: Re: [Patch mm-hotfixes v4] mm/page_vma_mapped: fix device-private PMD handling
Date: Fri, 26 Jun 2026 21:27:28 +0800
Message-Id: <20260626132728.77436-1-lance.yang@linux.dev>
In-Reply-To: <d060cadd-34f8-42da-b7f7-c8d295050436@kernel.org>
References: <d060cadd-34f8-42da-b7f7-c8d295050436@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D965940007
X-Stat-Signature: gnr7cb8suzs8a4rfr7u8xx9jdddazzpz
X-HE-Tag: 1782480461-608642
X-HE-Meta: U2FsdGVkX19A7/CuaJrM/V9W09h1n+pOexfyN3Cmr7XVQWOWHSGouvFVYWl1HZ9ufCnswEBXoxCJ75uAtRTlA7nKCXcH1N3jUiogTdNCXzUx0XGOPZ6wcEkTJHjtWdohtOtO6bUUhWvN8ldgqGT+8bR3Z7gHSRpWieDvVerkpTQthFufzSv/H3jYs/51QRdZNVGNzp1qTLDrEmfhwpBSdEgKlggSiFsgZuaMX7nNkWCfNgUd00ne5N5+EpZImrubcR4v5LbGzBmEPO9Bts+BRQmwfCYUzrLPbbVOfsK3D5odcTJXslSjrTUylfPPaUQnrI100Keja9an2RTPuZApfBUVTIhkt+M/QTX5cyUle15cxvlJhlySsTo3zG6SW+xQtb2dg+C/qIO2dkkbNdkbwVQkiYHUhOahnIZuy53uzyqHmPHLhN+QK9Y7t3FPvhsd7ONse8DRJgdNE2hJioe+JWKy5vup/D9Dfcndpr7GrYO/ltJwoftodNyag8l0/JDjI5H9O68mTyYhNb8Ofm2vKKo0WkON1JpOSl1Y2XWk7nLYBD1qIJUSWz3Lxbf/qjMlloJrNAy/KeJ/p5+/l1Bk0lE6lWzEOISplsnu/otyVVA6Q9itaOEcirO3ysfH9wx9+IhvOD8nJfUVduYgDx+mp9O7sP17k33NY7orhu0SmcNpvMpq4Esm4swpTQw5Of8fFu5Q7+QfPpkHzxGdKdEjkhaSuDFeATTZbl6gF4LyYzv0lI0+4w0beL61//A97L19MsHm58oU4gX1kGgDqosEAEWA5mrTgWSfFtQebhjWe6R/FHIXIWUVoP3KhP1I3DKkG8U3FjAElu/Lg8lg2F3adYtxFUD38aNwJ+vl+nia36EVzaxqB2Ly1fmtwnOMjGe6llUy0CIjx+Rdmv649aKv6GpcE3VMN95RYwY+uCdlcYapieQOELg8iM1nVHGdQtTaGmnlrEH16j3pGcXuusr
 IA5CkcjJ
 dJT40yYwfDYtj2NUy1Bxphek8N9G4K8sqh1QIOmIwHlNIYU64Aw6rNVgxGtmusUEItJevx41yALAn94UyY8YIzFGaX5mzCIMtV75C8UvyGTogdu6uOd24Y6DN6c9laRUBQLHzESVmVzSlWN/MiTSEnf/oUHRwCnduY0KEenNdC3bwhiwyfBwx2CN+olWbsAqyBC+dpvor30XO5aSb30ORIynyBugg6Fu/1b9V6ad01UpRJtlBdlGM4kzn3tqDyXQuGY8xxkvOPSbSbabBlvbn/pdXgPr3L+ep808NovvZiREjnQG1BI4aJI6POZnYUrl6rv0VxLQf9fhKqrPu1a5+FxrA3VfYC662Z9zOPVETQ0qHH0geVwag+VN1ffjnyLaRplXbYVXlZM6u9v8D/kmZfpWtiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Jun 26, 2026 at 12:07:56PM +0200, David Hildenbrand (Arm) wrote:
>On 6/24/26 08:53, Wei Yang wrote:
>> Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
>> device-private entries") introduced the concept of device-private
>> PMD entries, but did not correctly update the rmap walk code to
>> account for them.
>> 
>> As a result, when page_vma_mapped_walk() encounters device-private
>> PMD entries, it takes no action other than to acquire the PMD lock
>> and exit.
>> 
>> However this is highly problematic for two reasons - firstly,
>> device private entries possess a PFN so check_pmd() needs to be
>> called to ensure an overlapping PFN range.
>> 
>> Secondly, and more importantly, if PVMW_MIGRATION is set the
>> caller assumes the returned entry is a migration entry, resulting
>> in memory corruption when the caller tries to interpret the device
>> private entry as such.
>> 
>> In addition, commit 146287290023 ("mm/huge_memory: implement
>> device-private THP splitting") allowed device private PMDs to be
>> split like THP mappings, but again did not update this code path.
>> 
>> As a result, we might race a PMD split prior to acquiring the PMD
>> lock.
>> 
>> This patch addresses all of these issues by invoking check_pmd(),
>> ensuring PMVW_MIGRATION is not set and checks whether a split raced
>> us we do for PMD THP and migration entries.
>> 
>> Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Suggested-by: David Hildenbrand <david@kernel.org>
>> Cc: David Hildenbrand <david@kernel.org>
>> Cc: Balbir Singh <balbirs@nvidia.com>
>> Cc: SeongJae Park <sj@kernel.org>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Lorenzo Stoakes <ljs@kernel.org>
>> Cc: Lance Yang <lance.yang@linux.dev>
>> 
>> ---
>> v4:
>>   * refine subject and commit log based on Lorenzo's suggestion
>>   * put pmd device-private entry handling in its own if branch,
>>     suggested by Lorenzo
>> 
>> v3:
>>   * remove cleanup part, only fix the issue for device-private entry
>>   * refine user effect description based on Lorenzo's suggestion
>> 
>> v2: https://lore.kernel.org/all/20260616063436.20455-1-richard.weiyang@gmail.com/T/#u
>>   * specify the possible error case of current code and user visible effect
>>   * besides fix, cleanup the pmd entry handling based on David's suggestion
>> 
>> v1: https://lore.kernel.org/linux-mm/20260508013728.21285-1-richard.weiyang@gmail.com/
>> ---
>>  mm/page_vma_mapped.c | 20 +++++++++++++++-----
>>  1 file changed, 15 insertions(+), 5 deletions(-)
>> 
>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>> index 2ccbabfb2cc1..17dff8aab9f9 100644
>> --- a/mm/page_vma_mapped.c
>> +++ b/mm/page_vma_mapped.c
>> @@ -269,14 +269,24 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>  			/* THP pmd was split under us: handle on pte level */
>>  			spin_unlock(pvmw->ptl);
>>  			pvmw->ptl = NULL;
>> -		} else if (!pmd_present(pmde)) {
>> -			const softleaf_t entry = softleaf_from_pmd(pmde);
>> +		} else if (pmd_is_device_private_entry(pmde)) {
>> +			softleaf_t entry;
>> +
>> +			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>> +			pmde = *pvmw->pmd;
>> +			entry = softleaf_from_pmd(pmde);
>>  
>> -			if (softleaf_is_device_private(entry)) {
>> -				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>> +			if (likely(softleaf_is_device_private(entry))) {
>> +				if (pvmw->flags & PVMW_MIGRATION)
>> +					return not_found(pvmw);
>> +				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>> +					return not_found(pvmw);
>>  				return true;
>>  			}
>> -
>> +			/* device-private pmd was split under us: handle on pte level */
>> +			spin_unlock(pvmw->ptl);
>> +			pvmw->ptl = NULL;
>> +		} else if (!pmd_present(pmde)) {
>>  			if ((pvmw->flags & PVMW_SYNC) &&
>>  			    thp_vma_suitable_order(vma, pvmw->address,
>>  						   PMD_ORDER) &&
>
>This is extremely hard to review given the existing crap handling here. I'm
>really sorry, but it makes my head hurt (I'm not kidding :) ).
>
>It's completely unclear why we only have to check for a subset of the cases
>after taking the lock.
>
>Could we simply extend the existing migration pmd handling and leave the
>!pmd_present() case for pmd_none()?
>
>That leaves no question to "which transitions are actually allowed", including
>"could we accidentally assume something is a page table when really it isn't".
>
>
>So what about something like the following?
>
>The "thp_migration_supported()" is not required when checking for
>pmd_is_migration_entry(), as that defaults to "false" when not compiled in.
>
>Untested:
>
>
>>From 048ecd33673ec649e168fbbb97749a7c0e344fcd Mon Sep 17 00:00:00 2001
>From: "David Hildenbrand (Arm)" <david@kernel.org>
>Date: Fri, 26 Jun 2026 12:03:40 +0200
>Subject: [PATCH] tmp
>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---
> mm/page_vma_mapped.c | 29 +++++++++++++++++------------
> 1 file changed, 17 insertions(+), 12 deletions(-)
>
>diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>index 2ccbabfb2cc17..ed2a23a90e8dd 100644
>--- a/mm/page_vma_mapped.c
>+++ b/mm/page_vma_mapped.c
>@@ -243,21 +243,31 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
> 		 */
> 		pmde = pmdp_get_lockless(pvmw->pmd);
>
>-		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
>+		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde) ||
>+		    pmd_is_device_private_entry(pmde)) {
> 			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
> 			pmde = *pvmw->pmd;
>-			if (!pmd_present(pmde)) {
>+			if (pmd_is_migration_entry(pmde)) {
> 				softleaf_t entry;
>
>-				if (!thp_migration_supported() ||
>-				    !(pvmw->flags & PVMW_MIGRATION))
>+				if (!(pvmw->flags & PVMW_MIGRATION))
> 					return not_found(pvmw);
> 				entry = softleaf_from_pmd(pmde);
>+				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>+					return not_found(pvmw);
>+				return true;
>+			} else if (pmd_is_device_private_entry(pmde)) {
>+				softleaf_t entry;
>
>-				if (!softleaf_is_migration(entry) ||
>-				    !check_pmd(softleaf_to_pfn(entry), pvmw))
>+				if (pvmw->flags & PVMW_MIGRATION)
>+					return not_found(pvmw);
>+				entry = softleaf_from_pmd(pmde);
>+				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
> 					return not_found(pvmw);
> 				return true;
>+			} else if (!pmd_present(pmde) ){
>+				return not_found(pvmw);
> 			}
> 			if (likely(pmd_trans_huge(pmde))) {
> 				if (pvmw->flags & PVMW_MIGRATION)
>@@ -270,12 +280,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
> 			spin_unlock(pvmw->ptl);
> 			pvmw->ptl = NULL;
> 		} else if (!pmd_present(pmde)) {
>-			const softleaf_t entry = softleaf_from_pmd(pmde);
>-
>-			if (softleaf_is_device_private(entry)) {
>-				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>-				return true;
>-			}
>
> 			if ((pvmw->flags & PVMW_SYNC) &&
> 			    thp_vma_suitable_order(vma, pvmw->address,
>-- 

Might be good with this on top:

---8<---
diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index cfa1230c87bb..8b7c062bd81d 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -281,7 +281,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 					return not_found(pvmw);
 				return true;
 			}
-			/* THP pmd was split under us: handle on pte level */
+			/* THP/device-private pmd was split under us: handle on pte level */
 			spin_unlock(pvmw->ptl);
 			pvmw->ptl = NULL;
 		} else if (!pmd_present(pmde)) {
--

Looks good to me as well, thanks!

