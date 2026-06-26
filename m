Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 114F4CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 04:06:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEE0E6B009D; Fri, 26 Jun 2026 00:06:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9EA36B009E; Fri, 26 Jun 2026 00:06:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADB9B6B009F; Fri, 26 Jun 2026 00:06:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 80EF46B009D
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:06:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ED571166A89
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:06:37 +0000 (UTC)
X-FDA: 84920727234.25.0ADEA25
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id C9F3012000A
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:06:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Fj8zaU+K;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782446796;
	b=rXr6PcUjPLBvMH+mSjowIi3s3htnoPVWCM3xHRS28UgxPIhaBKzrNZhYrCext6a75Cx9BI
	UwRYasVtvS8lHpVWWIBjUtPFHUen1+94AWbD7KqXUgN2qFo5xrdZz5LSeyi2dWT/QhdBk4
	g5dbuRO6u7g9LXnLbDJ4qmto4G55uro=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782446796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=axKKZ9zNO/3cXSlwjxIWvyuFra0shb5EegeMVyEJmU0=;
	b=eXG4GGgEnfnZffJMqnxMZlRVHfpIL+P9moNBTTeWGeNnkdCwrRmWj06FLnKMkCxXJ9gfN1
	Ytca/Me2f4KxiKMBmWH6b8zQHFEv6/R1k0g8UCscc/lUkrmVLegrpq74tFchsUc/XIw6we
	dLSd+JRyp4rlTBmuQohxT+1gwib8TFk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Fj8zaU+K;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5B59C2309;
	Thu, 25 Jun 2026 21:06:30 -0700 (PDT)
Received: from [10.164.148.34] (MacBook-Pro.blr.arm.com [10.164.148.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DFB573F905;
	Thu, 25 Jun 2026 21:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782446794; bh=rEMshQHon41Sg38Z8NXkpcWJh3M8Bi896t94h433fu4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Fj8zaU+KPHJaPRvKjc/hx7/6ra0teS9xSYnQ+26ogUvddNXmmNlv7QhKU25xMSAlN
	 Wq2zLYewpTt7pliGi/d2ekpdihLOYB0/51RInxgvGHjGx+Vzf7VubYlS9fDgcfpi4B
	 nV2D7k10xIHvTUErKhQKj/rkOvgkEaAxZJPyvZTg=
Message-ID: <117fed1e-971d-4e31-a358-7a03f3db8338@arm.com>
Date: Fri, 26 Jun 2026 09:36:21 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] mm/page_vma_mapped: use huge_ptep_get() for hugetlb
To: Lance Yang <lance.yang@linux.dev>
Cc: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org,
 ljs@kernel.org, david@kernel.org, liam@infradead.org, riel@surriel.com,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com, kas@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcampbell@nvidia.com,
 apopple@nvidia.com, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, mel@csn.ul.ie,
 nao.horiguchi@gmail.com, ak@linux.intel.com, j-nomura@ce.jp.nec.com,
 pfalcato@suse.de, dave.hansen@intel.com, tglx@kernel.org,
 jpoimboe@kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com,
 stable@vger.kernel.org
References: <20260625112955.3254283-5-dev.jain@arm.com>
 <20260626023127.60788-1-lance.yang@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260626023127.60788-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C9F3012000A
X-Stat-Signature: ooznyp7xd1z7omf6gxrjnn7d15ydspkd
X-HE-Tag: 1782446795-485209
X-HE-Meta: U2FsdGVkX19Yosgto2G+DIPEbnzznp+n5OvFLCwipOk5frEmgi/nhAVegT8eLLRLiZjy4ejKUKh4Fbqxc4TCUPSko9obpQRa1mmNsZm+OXJGxnFINHmvJRKFELyfc/hwo0OoGJ0xSathVtS+J7QFhRyEyetpN9KiBstXUMykubQ3Fe08GF/084t5ONWsAhuaQE+OA9jbvaNDQq9hpbyyEF/E9ENabUq3ToyWtReGf3O/+og1FJuMNzE81gUGFOhb1upbenj6Zq9v+GclBRpmYq4p9DwgMjmRtQ4XQ2PjFCi45D2pUPkHB0Qg4Yr8jrQxUgFNs+grblhmovb+HDXCF+h3GfSOBY1Al91cTieOK++imRaO1LmaJFnTyDrLEZMr7wMGYIqRGiFgetmKN6vunIA51GySwK+4kZ0yq2OtsHy0pSh36WFRjyWzEw0VAIWrx+OuDzrKEAfKJ07BB5eK5Ej0POFFTogJegMPAHQTtVQ6x+cpwL5fpMq2QdX0RM2d+/8KRo2oobXnuoZBaJjkOjmZDaslZeY5LptDsOmbJdVUPQMqNsVPWMp3oMsXwmWnUNzLSOzCcin7qC4tJAiubDReqZugstsdbNnLpCSvq5JLXITXcAaVC5mjHdFo9SEF5TRrotQu3Yg1Z+Y4Ku8wtgaRlQ4FBrmKwbNfsVtTnqVluQEf1Ojmuir7MpLr1pQUDFMIrpe1rMsypOG62+EN33TvyZgb5Q4CpAIaVbVv/JuREEIXCOc2M59SG4UOpTM4YcQSAtscHpChoR8fs2SSKhYCMwanfUGOPMjeVvzruiSHsJNhbED52UG+biZ1xE9xPkCLruxFbtSJFghVG6XQgkbKs98DXiby2FG8C9AacdLrLCw/vrgHeBJv/kIzmGNvEWZ7cKJxCxJQ4SwrEVHSLTU0k0DnXwAPinjSa0bxPBmTGbLxr1PN4Sb8LCek6Muc8teqZheouYzqT19drss
 DdzCse1f
 /1NZ/o8VEkpu1U98Phyk3TVQUZ4uL7DavVa5EVH10iG8/0GUMUTHQFplHhLZw5HvPBsAuDIatwhI6dTaJV93DSa50iGYbHS0b/RtNRc9ySHXNJDBFRFUKZZ6FB7ih3ISWF232lKeUCBvqkMrWXnHXaT5pu+toWRVbnuY0XtET/Adwg/7zhcdH2jGawIBgJ3eeGU6X9iupr9kpnSiKW57uBHSW0TBCUKY7JXmat2kJws3+rKeD6UaBRCqm0IzZIM5MI0c2uML6d/cig20tTNuoRof0tR+TGsJvcP0uf0D1PTNDTZGRdKDmu2oJZ6T7etQkMUs5mnNIBNrdx2rAen8rzAllaQxHR37CKsv5tdaY18A9oIVBEJOt6ezpT1uySW/DpX9gEZ7MaURKJ8lWUg1C7OOgDEepRd88QiSutiB/lgQtf3QE/eMUd8png1PgG1sTQ/PX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/06/26 8:01 am, Lance Yang wrote:
> 
> On Thu, Jun 25, 2026 at 11:29:53AM +0000, Dev Jain wrote:
>> check_pte() is the final validation step in page_vma_mapped_walk().
>> It reads pvmw->pte with ptep_get() to decide whether the entry maps
>> the PFN range being walked. For hugetlb VMAs, that pointer refers
>> to a hugetlb entry.
>>
>> On arches which provide their own huge_ptep_get() to dereference a huge
>> pte pointer, accessing via ptep_get() would cause pte_pfn(),
>> pte_present() etc to misbehave.
>>
>> It is not clear whether this has a trivially visible effect to userspace.
>>
>> Use huge_ptep_get() to dereference a huge pte pointer.
>>
>> Fixes: ace71a19cec5 ("mm: introduce page_vma_mapped_walk()")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>> mm/page_vma_mapped.c | 8 +++++++-
>> 1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>> index 2ccbabfb2cc17..18e1d341f463c 100644
>> --- a/mm/page_vma_mapped.c
>> +++ b/mm/page_vma_mapped.c
>> @@ -107,7 +107,13 @@ static bool map_pte(struct page_vma_mapped_walk *pvmw, pmd_t *pmdvalp,
>> static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
> 
> Just one ordering thing: should this patch come first?
> 
> Patches #01-#03 only reach the new huge_ptep_get() after
> page_vma_mapped_walk() succeeds. But before this patch, hugetlb sill
> goes through check_pte() (still using ptep_get()).

You are right, but do we care? This is not a series meant for adding functionality.
I just sent it as a series because they are similar fixes - the patches are to
be applied individually with no dependency.
> 
>> {
>> 	unsigned long pfn;
>> -	pte_t ptent = ptep_get(pvmw->pte);
>> +	pte_t ptent;
>> +
>> +	if (is_vm_hugetlb_page(pvmw->vma))
>> +		ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
>> +				      pvmw->pte);
>> +	else
>> +		ptent = ptep_get(pvmw->pte);
>>
>> 	if (pvmw->flags & PVMW_MIGRATION) {
>> 		const softleaf_t entry = softleaf_from_pte(ptent);
>> -- 
>> 2.43.0
>>
>>
> 


