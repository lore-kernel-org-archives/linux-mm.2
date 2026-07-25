Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 401BAC531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 07:36:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 019236B007B; Sat, 25 Jul 2026 03:36:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0BF26B0088; Sat, 25 Jul 2026 03:36:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFB906B008A; Sat, 25 Jul 2026 03:36:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B85C06B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 03:36:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 281B11A02A0
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 07:36:42 +0000 (UTC)
X-FDA: 85026491844.30.1E3BC4F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id AAD1D1C0007
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 07:36:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ckLpHHaM;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784965000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rsvurRf+SRJrU4+i+xHz5LLJE0NsK4ZyETzq8rpOmfs=;
	b=58XF47RMC6EAKlvtmGAKFpD8sNut8c0dDvnajW8eyRdFp147xcXUph5LWo30/VvQ54T7yD
	HWvcCEn1mdBcp7jnYTCoN85cuhm53Qp30ZMh7ogJHlo5rFmRn1T9208qnY80md4gsypzir
	c2y5Q/5tWeMY5dd2W+5dq96RrtCsDpg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ckLpHHaM;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784965000;
	b=DCfkhW7s3C4WLbo7acxcLIgZDZW7MPzd5jTHNscorWtipl4bjcKvwHplnGoLdzFihCABD/
	RUJuy5TnpVr0k4TF9UvWE3UkJ69uMeF/78TjS9LZ/K/MmdCekdEZB4f+CmOteIMrId6hDL
	Cvhxl9A4NJ6fGeQpm4cpYoc6HMQAnhA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A4CEC1476;
	Sat, 25 Jul 2026 00:36:33 -0700 (PDT)
Received: from [10.163.132.94] (unknown [10.163.132.94])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1AA093F86F;
	Sat, 25 Jul 2026 00:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784964997; bh=K2OEO3/Cy9T21D6ntfx2jKNZQK+gjkiciyn2lrnM54g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ckLpHHaMD8jK+XCMaNlElIJpFSeGhlRl4s48vP7jJebAQw2ES6g2UdVKtXmjo20Cy
	 PIneJUL/RB/aqn4A6eIyP/hbROAoeYIzvmGecNb0r331RVQkG3ExyjWxORXAZRnhNq
	 ++N3KBfpLJyBaJfb001gdB4VD+8FDQzPKWgpKuTI=
Message-ID: <8d2f756a-12a2-43bb-8849-3e71c1ce5d8f@arm.com>
Date: Sat, 25 Jul 2026 13:06:25 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/5] mm/rmap: convert page -> folio for hwpoison checks
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev,
 osalvador@suse.de, riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260713050050.1017741-1-dev.jain@arm.com>
 <20260713050050.1017741-2-dev.jain@arm.com> <amMtRejoVMX2IV2V@lucifer>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <amMtRejoVMX2IV2V@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AAD1D1C0007
X-Rspam-User: 
X-Stat-Signature: 7qio3gruj11gbqf1gg5b1rehx1gncj7h
X-HE-Tag: 1784964999-476058
X-HE-Meta: U2FsdGVkX19WcoJpjpkjJ+vAk5jPkRSG5L0jsmmgYuwsyjTcHuYugGzG4FR0AH4X4PgQ6O9vA4f8Wb9OZTIyUmpSZ/UYcremmo7gtnW2hetj00++lLtxTJ8g8OO6fnobsUKcd1eNPRN+2fct8Ke6SNnGUfANEGOfSLbxjLVE25GXHMifT0HGVtfFXv5LgN/e8ftZySwxAF4QyDe8fBs9jqb5U4fmJYZrYQ+HOVpD8BLY5WIVqfP7I66OWvZadScXSlVT8Q0JcTud+EjXmUW5v9kIIUqedVCwvt7OW8iOYqmbCTTTdxXfpKY9OtANUuXCZZ3sG5Tu9f3LeWoRzk+MYnyW9zgtZKIfEAGjZjEDhq8E7jVegVrcEvGCUAsR+RlSELJmKrlN3jy12ujU1CppnQPAi7DYaN7z/rBOK0nOcjJTd+azNslkqXSmOVwQNDVm+wd3m2W4rJQtJmUG4e7jvA193GESF0kuam54OXzJ5AIoZ7gmnUy4aYLrdgolw7aI9QoYHJOvbjtKOZInY10E+ZEDlGygxeJGTzqgiZOQJXVHNuDKjxvYIswAayR9fJYVsRjqEBDwum3JTPF/d41b5wMlqaJKUcnjJ314muxChiA/xKn6k59b1M/GzEhJvh6RYX69gX7JePRxoZ70yK6tQRuEVLhoExrLolsqnE8fEnFRsuk4DSy4hkAb29TIdNQ1yRtAYZ/a/pwb9jdzJjFC+FUMA8r1AGfrMHLHcXocJudtr4BfbxWLnJB5r2bNCCCLlXvPF3X3LzHRw2orfaOdmGksUT2OHbxcEbi+Q37VKavG08ESOJguDwwZLJUUq5oG5GbwQfsGX2jJuIbptDw2CIw3XLAS/3A1k5Egjp9+SDgYsBFz/vc6hAakOVuNaWhzd8Ew2y7S/bQarzU/b1r5JzUayI+iEoewNZGimIDLFIzGj58B6cPWTEsisuHTS78tvYmOxP5NgHThycyBBRc
 MRRiq+z2
 9JLoKmg3U2LhnHukRmnhHeUyKVLnmgJTxKjHLCq80ZvEBYEw8aWwmq2s1T+rmLBSxSsQlHEwcSsN6MzmwM8kztI9H/cC9w7p/dJqlFp8bAHA6bPUBSOu2s5GhFQLkeZhbTpOBSON5XlgW4GI/9MmVG779MQLoTFVybBKjOa1UCN/U+HlZZMNUAXPxTC42FLae8Ei9VzyYvjGccE34PPxsqKjmrGxRlaHvUh39Z6ToXj1Cu9uZAqtKETDHy+w/2cpUQy8gZpbKvZ5R2lEeXh88P5IQ7ZzT90DtKX/jA7MZm3CBosdY5IBy2Uf8DUrB6X4N02rf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 24/07/26 2:50 pm, Lorenzo Stoakes (ARM) wrote:
> On Mon, Jul 13, 2026 at 05:00:44AM +0000, Dev Jain wrote:
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
> 
> Oops reviewed v2 by mistake. This LGTM so:
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 

Thanks for your review.


>> ---
>>  mm/rmap.c | 13 +++++++++----
>>  1 file changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 26166a6b8cb9b..2b74668f356d6 100644
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
> 
> Thanks for converting this also!
> 
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
>> +		if (folio_test_hwpoison(folio) && (flags & TTU_HWPOISON)) {
> 
> As per v2 discussion, I feel this could be tightened up, maybe something like:
> 
> 		/* unmap_poisoned_folio() only refs order-0 or hugetlb folios */
> 

I can do this. But note that this series is in mm-unstable already - what should
I base the v4 on?

>>  			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
>>  			if (folio_test_hugetlb(folio)) {
>>  				hugetlb_count_sub(folio_nr_pages(folio), mm);
>> --
>> 2.43.0
>>
> 
> Cheers, Lorenzo


