Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AE53CAC5B0
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 03:08:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2788A8E000A; Fri,  3 Oct 2025 23:08:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24F328E0002; Fri,  3 Oct 2025 23:08:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18BF98E000A; Fri,  3 Oct 2025 23:08:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0894B8E0002
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 23:08:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A173C1DFF16
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 03:08:53 +0000 (UTC)
X-FDA: 83958949746.20.F8B89B9
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf10.hostedemail.com (Postfix) with ESMTP id CB9F5C000D
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 03:08:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bi1E45ly;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759547332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VH7Jum0STCRvqZ+0XX5TR3xWpnSLpgoUkMhO7MpcgEk=;
	b=W9UuF6jSxksBxU5RcQxEBAq0B7iJl12gyn5J2bCdmYaikzqke38p5FGiQz/gcFT+9ue9rQ
	32lWVJB+YJhLHq2YpTalgHvlA4Ip4dSaQc28pGEhyIV8NtWerUMp92jD/5f6btY27G44oa
	zrGEs35eQYyoQevIgUT6nMvtpi8iZOk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bi1E45ly;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759547332; a=rsa-sha256;
	cv=none;
	b=J/0F+NchNrBcXQ2i6JGGajkK87Ydg5UyboC/Z5M2BTv2abe+The3Miim84UNjFxmQpjOt/
	G0Y7Pe9is5VQg3X3ASzLWBNfoa5kSwTTNevIuQQhrsr7qDUN6OZFpuCLjOsGORR9IiOf/m
	ZsbJVgRlnSIFSvi1KJiNcrlUuOtYiRk=
Message-ID: <2ecb9ba1-8801-42b8-9575-5add856d0441@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759547330;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VH7Jum0STCRvqZ+0XX5TR3xWpnSLpgoUkMhO7MpcgEk=;
	b=bi1E45lyAmGuMPAX85dpy4bq2sam/tjVCrywn8Xl6Pg/gGO8PIxt6apUejVSKZsxuBpjiZ
	mAj0a/Kzw92YoPRyG5UjziWIYipIzm3E51orNfMiAGSHg2n5jVYNim5yfMpTdqResIZwbS
	hgHF7dRMDgQ5SWRuOwfS0yjN33kK+Ck=
Date: Sat, 4 Oct 2025 11:08:40 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new 1/2] mm/khugepaged: optimize PTE scanning with
 if-else-if-else-if chain
Content-Language: en-US
To: Dev Jain <dev.jain@arm.com>
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 lorenzo.stoakes@oracle.com, david@redhat.com, ioworker0@gmail.com,
 richard.weiyang@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 akpm@linux-foundation.org
References: <20251002073255.14867-1-lance.yang@linux.dev>
 <20251002073255.14867-2-lance.yang@linux.dev>
 <b8fc9ab7-a96f-4763-9432-8aa8c3c2a87d@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <b8fc9ab7-a96f-4763-9432-8aa8c3c2a87d@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CB9F5C000D
X-Stat-Signature: fq57tabjz8cxt6hsew5dk9zftyxqmh4d
X-HE-Tag: 1759547331-713023
X-HE-Meta: U2FsdGVkX19VFlkzKD7y1xFyf1y/LpqbZ5Dwgtk78u6WgpmKiBZBSdCW0CdwY41gv5DNXgYeJFboQEjpuNJOceZQCrvzeX4bNxa+Bqcloi6TlZA7Jg4RRDz1JJUPhLXm2ogq5YqwVVkUO/7tpolkgK9r82ECNgquqCDmt3NaakWgbTJOvKs+L0OFT5cd4eefUdkcL6tOwkvjHzW1vMipZItUKKE69HdC0SgTMkslK8/4478a9actvdKLXNPf6GzOrn7k8cAArJhC904K3DjU7aFpXaFa0Noy/0qyDSOooEwHGe7us6eB7nG36zZENvt82A6ZGxzZ3JCicebYowesKaIAPfa6EoEdplwCGhpdmXPk6bF8A0UdT/800jDS54RKiiZiwkb4OodVeHBmzT+wpy0yWYzGtnrq+sAjIva14K+7NSXlYvdOp0mUdE81hof1uWcWg3qPF+mc1k6ZpmrlORL5QMvY68GCygD/6rWxHYeTs18fVCLSPdHDXs763BgNbo5VR51ukE2fIkPKWUEe4yrogXcqaXg5706LFSJ8si6iorhpxIjXZjwIZpk/OVCHhDU3DHRGgzadySkP8I18HhJLn1h+xixQyn9FH4pO7XjaT6yp6Rau8+CWfWbENkKrkw0xmSZXh5Lb7q6lth0n6K72OWpdiiL/RKCzv3sV/TRe1rC9L2JiNWR1sBZqEVXl1KGSVrTTo8VnZkpCsYsCAeyJSSmJaXNXksRPfUVG0utCiEcNoxlOTrbPBXtA8LmyCN4B/PU/QuaylbnHidDNw7DMr5KZWs+C+bdpkH9IXsbOVobmZh/450avt0by4pITUcyQlTScGuOp28OwtKkNAMxrsLaKsWSEo1Dh1MPJ0yA1KWYInE0R40zlI/rpmO3pLNSeadSOTVlr3FkyMIHy70bv2oNKBhKkvjDzWk/4yHm+OSbWCbTAVBrgbiW4oJMPTtR+w/9rLiZ5fBH4TAY
 IeMvf7pc
 khJNsSa5wVpq39ou7m1C+S8NGQ9B3UbhqrYNvJF1wBHXc9Mog4ykOv40wveo41r60/EF15ZU2EW25o4jcZ6mLADRP2YsvlXAVImyngJXyvGY3SU1bpoXwWqin8nYh75koI59qODua92ZM65bPBYokZCk79YsIaXtQQJzE8qy2uFnOLmAvBgr5CRYssLya9aSBRA7eot5JB+yeDif6ZaNjBu5TXjIGhHTMDH1NrnzMwBLTL6Yf5+4I+lkyAJAtv/9qVBqw6rRgut/Hs3utAGwg2sxgK6ebnJCHGue4YWo1EpDp2jE7Chm7KY09HSQgcIHIfIZXnwREXGumIXepTgCnDyNm7Ql5PjNOmj9O
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/4 00:33, Dev Jain wrote:
> 
> On 02/10/25 1:02 pm, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> As pointed out by Dev, the PTE checks for disjoint conditions in the
>> scanning loops can be optimized. is_swap_pte, (pte_none && is_zero_pfn),
>> and pte_uffd_wp are mutually exclusive.
>>
>> This patch refactors the loops in both __collapse_huge_page_isolate() and
>> hpage_collapse_scan_pmd() to use a continuous if-else-if-else-if chain
>> instead of separate if blocks.
>>
>> Also, this is a preparatory step to make it easier to merge the
>> almost-duplicated scanning logic in these two functions, as suggested
>> by David.
>>
>> Suggested-by: Dev Jain <dev.jain@arm.com>
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>   mm/khugepaged.c | 12 ++++--------
>>   1 file changed, 4 insertions(+), 8 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index f4f57ba69d72..808523f92c7b 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -548,8 +548,7 @@ static int __collapse_huge_page_isolate(struct 
>> vm_area_struct *vma,
>>       for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
>>            _pte++, addr += PAGE_SIZE) {
>>           pte_t pteval = ptep_get(_pte);
>> -        if (pte_none(pteval) || (pte_present(pteval) &&
>> -                is_zero_pfn(pte_pfn(pteval)))) {
>> +        if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> 
> Should have mentioned in the description that pte_present() is not required
> here, so removing it.

Yep, got it.

> 
> Reviewed-by: Dev Jain <dev.jain@arm.com>

Cheers,
Lance

> 
>>               ++none_or_zero;
>>               if (!userfaultfd_armed(vma) &&
>>                   (!cc->is_khugepaged ||
>> @@ -560,12 +559,10 @@ static int __collapse_huge_page_isolate(struct 
>> vm_area_struct *vma,
>>                   count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>>                   goto out;
>>               }
>> -        }
>> -        if (!pte_present(pteval)) {
>> +        } else if (!pte_present(pteval)) {
>>               result = SCAN_PTE_NON_PRESENT;
>>               goto out;
>> -        }
>> -        if (pte_uffd_wp(pteval)) {
>> +        } else if (pte_uffd_wp(pteval)) {
>>               result = SCAN_PTE_UFFD_WP;
>>               goto out;
>>           }
>> @@ -1316,8 +1313,7 @@ static int hpage_collapse_scan_pmd(struct 
>> mm_struct *mm,
>>                   count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
>>                   goto out_unmap;
>>               }
>> -        }
>> -        if (pte_uffd_wp(pteval)) {
>> +        } else if (pte_uffd_wp(pteval)) {
>>               /*
>>                * Don't collapse the page if any of the small
>>                * PTEs are armed with uffd write protection.


