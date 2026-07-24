Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F9B6C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 05:05:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F04DF6B007B; Fri, 24 Jul 2026 01:05:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDC706B0088; Fri, 24 Jul 2026 01:05:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF1E66B008A; Fri, 24 Jul 2026 01:05:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AE9F76B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:05:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 358471A027D
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 05:05:49 +0000 (UTC)
X-FDA: 85022482818.23.121A61A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 58C08140007
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 05:05:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GUmn4JfB;
	spf=pass (imf23.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784869547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JJ03iSRjfoG18YBBghpxDuIwEaUcBDpAc+uxq/WXxnw=;
	b=1N4v7+D/e+PYmiz6EZsaFH38tynL4RM/OHJHg72qJekT6BaREzC6kK000TEJB3GVkp1/pC
	qrbf383lGmvnTfbxxwqiGsGpBNQGe1j6wjw2OrDZ1fSOujBRMaPXP/f02KCc8hlloPOOdt
	n6Mnhi2jH6dSNxaIoSWBkUqyMrDBTJ4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784869547;
	b=e1rH0ve1bhf+uMObUy1PhwQqgYMVwgz3JWNJWblb+sUqQ9IQCecbbY1sI8hZ03Mk1SM0Lo
	H0rg/vn+nAnfFq8GkbRkLBEUslrS76PbAZz4zzZBWH+bfcQVyrlbqJRuvvDZBo/L+DnhgO
	Z2ksLo98u81khsKX1RhpBWIOhEQyLqY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GUmn4JfB;
	spf=pass (imf23.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E9E9B1477;
	Thu, 23 Jul 2026 22:05:40 -0700 (PDT)
Received: from [10.164.148.44] (MacBook-Pro.blr.arm.com [10.164.148.44])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DE9113F86F;
	Thu, 23 Jul 2026 22:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784869545; bh=9z1bk8upQShwtNFSq0+22MPZuPf4R/Mr2jz7W5iVWLQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GUmn4JfB0jh0NLkd/QxuENHfGYYuCh4n25zdfDVPY0Ej30DIrxWLwvOm0/eySV8Kf
	 pDQ5QEBRaNUX8aDLq4hX/UCYJciU8PSbEOmcJRk8tR/aA316X5X8xG9X66sz4fb0zF
	 KaFk4h0OpI6u8PnOeMcq20BAXqsc7d92Dw2b8cgw=
Message-ID: <cdd37c17-b2c2-4dc0-8f1c-7f4cbd2fefdc@arm.com>
Date: Fri, 24 Jul 2026 10:35:34 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] mm/rmap: convert page -> folio for hwpoison checks
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev,
 osalvador@suse.de, riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260710055915.638659-1-dev.jain@arm.com>
 <20260710055915.638659-2-dev.jain@arm.com> <amIzQmZ3eeYiVXo4@lucifer>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <amIzQmZ3eeYiVXo4@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: sgxgbsogikuyr3nomsecg9cam4x8soz3
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 58C08140007
X-HE-Tag: 1784869546-334574
X-HE-Meta: U2FsdGVkX18f/AVMphKbIfm8kCiCHleU0j+5C3yyDg2f/G055V7U4ghcfeEQgSLBq+UVZY5lrk+rrIOYRTJJIQhT49qqlMmvwqcdXmRGssjvVpXyC9fsXNw04taDGCDF00z41WC6mBbyqjEBQvACrh6xuAPVieIg6ZN/Q3utgZWFT++5yhYblG5YDSmjBAyvkX+Lhh7xXuPUhCf7UtNt4Kk8fy7UQI/o/G0ebBfvL85/8ytvwgaN5my1IkU1F8cX0PtwMU8oVCeJnFA+g+vQ6xtc7uR5fd3lBVLJTXaZwGTVDruBC4ik8jtpefrVr/VlBSWxg86CFi1TW3STAFFyUxR9cB+vYg+7CYz8qJgN4FMfMhTvcUV16vHLu3S5InndxbeiCum5wrguHrn9gHQyoGQRpwUh+qjxerFB1cu4Jm7I6pRLOiSG1NmAC6nS4bL/wzePTq2quGtrUvzfVKA7E7/l8FMoBpmo9zCapuXM7i6fniwXvF0SX4bJym8Q1vTxGpO9NbcLxaamu4zzUdZbOhsklxdzslGzeakyBYuBRxHVnUkPlbQ4QScfUnD9nIQLJqF5cRiMZTWHCXmXIu+tmhHOuJWKVRuEDJdDFPINlzJlnaTXUq6VePH10C0PCelIPs6wbzv8wWx2RLOvnLl1PjLeYAiDDd8cyqhTHuSQFgZCYqX9BKRrHv1ydQ5xNZvZAm4W8iU6XfCcWncfwQP4cHLVtablATAL0/JABD7pslU6ZENplM8pCOfUO5pNRTl1Pccbw+4uMZJZNt9BHnjMSwmddq1ffNdDAQ6QE1yLKfHqaNyYrxVGr6YTThiI9JW+5G61zPN10bfv8QyUv5Qab4p9sf9gp4dy990JMehwyNtxJEce9+Ma7CZfMH94Ijb6UXB1Tc4GHVPHUSikhDSoclHkjU2Cbclgf0+BbelUSdI+gONXnJ5k+U4oKEeQuZNHIhmx+Fw/zBEH44BJ8aB
 qvngReVz
 ssWT8VtNHylg3/9I1GOad4r5bEb+0OPq0psiS5OESSMNBLEbtDkWyhXZObfSSrxIM7x+KzyjjlKPVRQRO6Sib1qxPL1QkxtixBz8RqJzNegc3haP1o1/l4SQcuWpbS5xDMxSKS2R1QqVFF+HZr06yky31+hlVEiil9xp/QqjTPyUs1XCbpDh/41kyQJ+hphf/RHyeob6Vp+nXqhQxkD7AaAklJ74DF5sw8wCD+f/rtQ2D0yKbj8voGt/mhGs27HVDt3MZaxw41Z4vmVvYy1x3IuPZ+Ih1ZBT7fZ2QubHMz9jVrozt1AFVzEhjDKxZES5sCY5V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 23/07/26 10:45 pm, Lorenzo Stoakes (ARM) wrote:
> On Fri, Jul 10, 2026 at 05:59:10AM +0000, Dev Jain wrote:
>> try_to_unmap() receives hugetlb folios only from the hwpoison path.
> 
> Horrifying :)
> 
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
> Small nit below but generally LGTM so:
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 
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
> I think probably we can drop this? It seems implied by the code (David comment
> similarly I think? :)

I had posted a v3 here:
https://lore.kernel.org/all/20260713050050.1017741-1-dev.jain@arm.com/

In that I had fixed this comment to drop "or hugetlb folios ..." . But I would
still like to retain the "only expect small folios" comment, it adds cognitive
load when I am reading try_to_unmap_one and then have to go read hwpoison code
to figure that large folios would be split before coming here.


> 
>> +		if (folio_test_hwpoison(folio) && (flags & TTU_HWPOISON)) {
>>  			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
>>  			if (folio_test_hugetlb(folio)) {
>>  				hugetlb_count_sub(folio_nr_pages(folio), mm);
>> --
>> 2.43.0
>>
> 
> Cheers, Lorenzo


