Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32C6DC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 13:14:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 090166B0088; Fri, 10 Jul 2026 09:14:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 019586B008A; Fri, 10 Jul 2026 09:14:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4CA26B008C; Fri, 10 Jul 2026 09:14:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C55C06B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:14:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 59B1CC1C70
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:14:42 +0000 (UTC)
X-FDA: 84972911604.28.E0FCD27
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5C2AE4000C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:14:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LJPj6Vqb;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783689280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SXCHWNDI1VqZK5Q2Ocnu7zkZFBP+5wFlOK6Al+Tzlzs=;
	b=7MEb/klYdxUXtKaLbu5cqaPv1vjv8HYLP9rpoZvy4NP9LnhGuEt4NkPCVVlDvZL6I7QR/4
	25c1H4xk2iqeqXTQgzLatQyowKeSlLYZmltVlqKLqXBMYVd5oOPgNziMFrQqS2yAKn2ff5
	5hkAXvWF3X6OKZdWRfv0nZWclbrpGrU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LJPj6Vqb;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783689280;
	b=QJuZ0ydEJEkJnOLp4FDJvJRpAMpeo9w8m0Or67dM6ANKw08lOZR8vRHHQcSFXiPmkS4sie
	cQIDVIizICpNv3tBIsKkli4bZqzzNitI+Ul4qfDNLxhDT/cGUGFz1wJjoOyu6WVcuTyAtF
	jFf5kipME2WiBFBPOpHWieV1LbVadrQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 34869176A;
	Fri, 10 Jul 2026 06:14:35 -0700 (PDT)
Received: from [10.164.19.51] (unknown [10.164.19.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A57013F66F;
	Fri, 10 Jul 2026 06:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783689279; bh=dyNdfZwM1MyPcYXLpv3sx3GNF4QSc6vm5iBHxl3+7lg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LJPj6Vqbkc3mTMUAI93C8NbOwBloaliXm1yDvo2pCycXonU39JnmEbEGvRotUsJQs
	 v3buCtsFQPWzwqGa6zUBfB8e5rsaJp3KNo8qcyHZBphFbqSqYPaG89oDANyNyHz3ci
	 AfbaYh0DMEzBATMahNiSDoLVM90p3NKgu7nNs2/Y=
Message-ID: <c33e19f0-31d9-4f2e-a183-435520bdd05c@arm.com>
Date: Fri, 10 Jul 2026 18:44:32 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] mm/rmap: convert page -> folio for hwpoison checks
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org, muchun.song@linux.dev, osalvador@suse.de
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260710055915.638659-1-dev.jain@arm.com>
 <20260710055915.638659-2-dev.jain@arm.com>
 <87b94730-7543-487e-8f3e-c13251a00a21@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <87b94730-7543-487e-8f3e-c13251a00a21@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: sn8gsk77ygtt5bawuffdcxwytt8pt9x9
X-Rspamd-Queue-Id: 5C2AE4000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783689280-323783
X-HE-Meta: U2FsdGVkX19W9B5OUB64uweBILw0YbfhBySncqLiMzlfgHUZpaVqHQUDauNo6rJRjs9WgmJ2jmASFMdiE/ot/iJ3kreVR/Q0fra3HUcBpJGpVFYYii8CSJ1xIoEOLlTNxXa9SFSYUVv81/wTIpxq0sUCQ3yOGBr1LUuz7E4kJkKvE6DtGN3mW5yjbwS9rWHMUV3i6Gb0P3sylGY4y2DGvTN1pUqN1Ap2JCT7WgEl74VsTjOkp9jNAeaPs993vrCdDFHOTrDtFh9Mvz2jPze65b7UqJbkQ7rxozADLUUNylNPGH20Gh4MK0kfpZPPxOen/qIV4WZZETkpVxXG20U7Np15R/Hdmu5COu7QR43zvKk9Eiqmfzbjx88sB3qCPrzF3vLbvoiV9t7bpNm4RB2Ypsg+Z3GK4nxQym1+mnWzDsCX55BCNZe5ZwerzMPth8NVYgOuM82CyWUlcCN2Ra1lXYoSfkuFDSelUYbx29IOY688ud97V0UY4bQUklMGRBugzhDp2TrLmujjMjf4rvr4TnOt1z0lrFzCKkP8CD25uQ+2vxkiAoMZxVBQ6F6+fQq+jNFFq5Pqt0kg96uqY/lg8JS4iOiq4FX+fv3Oa542TodUMfhTVO9HcvxxflocssNQd8O5MDZLUc2ZIR8iKWw9cVySeZRL3//U+Ulu2Hk8LwihWE0I7h/c3+33ON8rfjuREsJ0AW4fg/qPe7PkfCw/Gem8PEpLUnmUSSd8eFPOj6kuttR0ST9bY6r7sJqSd7w2ovslatu1jwr9LKIw2tghYZtga3s6iu9ldNnC81plQ8yDBCbmmyJOVZQuL6XU8N2Pb/QEyLIEggQqKY4/VU2b3Y8UVo05Gx564tzA/XqU8Qnl+VjEAtannUvsAE6rdfYnNunjNuJZ7H678YtDV3GlYhBlPhCiYlttnUbKbnGU3ESHMghmR2Y5MyCBFMZlxfOZFxKF/ZAMDz8frtf2OKk
 pzBYYeqQ
 9UpgXi8rUNQMstrekuwS921m/bUbuXdAZWzhxcl257UMDYltc86XX1KASQpckd66EN1vhk0xoYg8gqF7LodVwoftJ2tTADOJqc7/e1D3Sae0w3Z703bC6Y3buF4+EFvpUClAVvXfXu0qWRSGVqHAy0YJAlCNbtM7D5exLpvYaQSJssdablBWcWnP+vHLxtsBOXgH0BBR8WEjkCWKo8Yc4t9cWig02wK26FHv2ElmNxq1ITX9REOs6yPp/BY8f0eQ/YpjYdV8A5HyzAQBbbHSmtKs8vPiILBa9L3OnFiIOrGYe+CGzLhG/r69iOsmc2ol9MkSA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/07/26 5:52 pm, David Hildenbrand (Arm) wrote:
> On 7/10/26 07:59, Dev Jain wrote:
>> try_to_unmap() receives hugetlb folios only from the hwpoison path.
>> hugetlb_update_hwpoison() sets the hugetlb folio's head-page
>> hwpoison bit, and page_vma_mapped_walk() reports the hugetlb mapping at
>> the head PFN, so the previous PageHWPoison(subpage) check happened to
>> work for hugetlb.
>>
>> For non-hugetlb folios, unmap_poisoned_folio() currently rejects large
>> folios before calling try_to_unmap(). Hence it is always the case that
>> if try_to_unmap_one() handles an hwpoisoned folio, then the head page is
>> marked with the poison bit.
>>
>> Therefore, convert the poisoned subpage checks to folio_test_hwpoison().
>>
>> No functional change intended, except that, while at it,
>> convert VM_BUG_* to VM_WARN_*.
>>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  mm/rmap.c | 13 +++++++++----
>>  1 file changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 9939400e77c79..dbb077f8443e3 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2122,10 +2122,11 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>  			bool anon = folio_test_anon(folio);
>>  
>>  			/*
>> -			 * The try_to_unmap() is only passed a hugetlb page
>> -			 * in the case where the hugetlb page is poisoned.
>> +			 * The try_to_unmap() is only passed a hugetlb folio
>> +			 * in the case where the hugetlb folio contains a
>> +			 * poisoned page.
>>  			 */
>> -			VM_BUG_ON_PAGE(!PageHWPoison(subpage), subpage);
>> +			VM_WARN_ON_FOLIO(!folio_test_hwpoison(folio), folio);
>>  			/*
>>  			 * huge_pmd_unshare may unmap an entire PMD page.
>>  			 * There is no way of knowing exactly which PMDs may
>> @@ -2204,7 +2205,11 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>  		/* Update high watermark before we lower rss */
>>  		update_hiwater_rss(mm);
>>  
>> -		if (PageHWPoison(subpage) && (flags & TTU_HWPOISON)) {
>> +		/*
>> +		 * With TTU_HWPOISON, we only expect small folios or hugetlb
>> +		 * folios here for now.
>> +		 */
> 
> Is this comment helpful given that you change that in patch #2, where you forget
> to update the comment? :)

Nice spot, let me update this comment in patch 2.

> 


