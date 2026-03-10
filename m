Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 161C7FCC9DE
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 08:43:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73C156B0088; Tue, 10 Mar 2026 04:43:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E6436B0089; Tue, 10 Mar 2026 04:43:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C1806B008A; Tue, 10 Mar 2026 04:43:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4821A6B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 04:43:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EC9781A0307
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:42:59 +0000 (UTC)
X-FDA: 84529513278.25.DBE84B5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 18E8E100013
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:42:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773132178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=imAG9hn++TyZ7mG+dyG8lhbp+2EPThIXyYlMf318ZZU=;
	b=K5Ggy3jjHS1iFxaKdyG2lPV0fbeiPbmOrTOSlCCg3bBNPkXReq44+u/a3WP6EW9fVdLjFP
	rxApG73QZ2D83Sd9w7OmHyhNzETGhTRg0GAB398ZpAsKs+gElK0oT1h1xRO++LDihUGPzo
	Eh/jg4BHRK0h4xK+0hw0ZokBkuaJRCk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773132178; a=rsa-sha256;
	cv=none;
	b=2SxWPUB//e+1sfdPlMfl5azwh4Z8FhiLqwWj3znJT3K0gL2lPMOhCm9G5mGBQAN+wTd7iX
	mxEQmgGNgHXb5gcEXaoj/3qW2ayH22RkGbVRh5v/BQyBoO8TMq2YrizEmmSBEhCSXovbYw
	R3HELDNiEgBHXPzPdaDlj1Yk/Nlp3Eo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ADE53169C;
	Tue, 10 Mar 2026 01:42:50 -0700 (PDT)
Received: from [10.164.19.59] (unknown [10.164.19.59])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 25CF83F7BD;
	Tue, 10 Mar 2026 01:42:47 -0700 (PDT)
Message-ID: <71e7df79-cfe1-4f3d-b00c-8ac53f886c04@arm.com>
Date: Tue, 10 Mar 2026 14:12:45 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/9] mm/rmap: refactor lazyfree unmap commit path to
 commit_ttu_lazyfree_folio()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 david@kernel.org, hughd@google.com, chrisl@kernel.org, kasong@tencent.com,
 weixugc@google.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, pfalcato@suse.de,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, baohua@kernel.org, youngjun.park@lge.com, ziy@nvidia.com,
 kas@kernel.org, willy@infradead.org, yuzhao@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260310073013.4069309-1-dev.jain@arm.com>
 <20260310073013.4069309-4-dev.jain@arm.com>
 <3915e3bc-c390-44bc-a463-bdd687598284@lucifer.local>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <3915e3bc-c390-44bc-a463-bdd687598284@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 18E8E100013
X-Stat-Signature: 7d17mbm5eg5pnntets8866xf5ic1ndat
X-Rspam-User: 
X-HE-Tag: 1773132177-311067
X-HE-Meta: U2FsdGVkX1/upLOEF/sp8hKGJCi/sfOZJfKEFkH+25isOnbrMVtBQck1DGPObHFXsShESiZekt6g/TTmN1vBIHMlQUE3qptZ9W5e8bYR4lAZYZZ6XwW36Qca1uukhXifCEgZqhzRnmHiU03uk2ESQ7LB+bR58G05cT/G32Mypy+aKqpn4sr6FXlkMgsRnBSWyabXRgurYXrlw4OrXFFZUFe2qVC9Jx/R1eF5btePkHd7dCJlWPsCmYtM4Zu4YniqgpU0ngWUVyOA7luhLABdS/vfKQaK6DGpxL3uaNBK4HmNGoxIPoEtgEfd/3A/cu0z6Q5e6EbAHBsWysL7dWBJLfnTspqQ0dN/XsfN+DGdijLdA8KYCy9wOVU2PYzIsZF8XhPFWWi12iseu3J12GpWSw4/lG7H1CsiiLeM4Ajwg+6JeaM8vmp3cOlTDJU2MMcw+6lInOgarqJZOxeSTAYcn6eISF/0wT/A0pNI+vyI37S+ufcU5DnbQ+D6SGyVbLrPFRDET3C7NldZCdGYnu5121R1gW4rFLCVjUNnOUfw5FU272TA7W89dqP1DePt9VJ6iKF6dHsgAQ0J38h/Prszq/lDJDPXeIqrvl+LjJcIkhyx3MDETuoXRbdHX2uYLWzAkSKgTOpQaE7r/imQx+iAgeWsoh173fZpl6XLkpp3dKJOhsSqXJ2wAwScceJosPOeb7rfLBTuGTCCjDJZYTm6yvjpfU2LDsmcVVSQTgkt+ah8pscr3AJBxErDZUQ9psHX/SMOhBaImKjlOwKVROtnemmDqr7P+b40LtcSnmbwJbZkoeplpJ7ZbOhcQkYYhD0cwXNVAqhDzSYm+dUR9pa5Ch/a+xAc7oyOEJ2Qgh8vSzbE3SZOGtNY/sRiAVFL+4+MuzVusgPI6tpzD3SpZ2wNOOmKxgTkR/kjB0wejBCGYrMLKoPVtSbq9rLOGT6DKJy8umbKC4H/knCN5DZP5i/
 1sTRDddg
 lO2SUJAFhOqZ+brdoeyMFQFX2+Fp0nUXbBViQIEpHKpTBLFwrLk93pqd4HrfpWFELWqE67inZshzzke+L2bkyIM42NclRpmI8DtIorqLE/S2LPEG7ttt5eIuiij5YuyA/eEZTJtUCteKk4pdHtMjqXN49nQROZdV8FSj+GSSRuhxCKZhVwjPdMZvzkio7HhwTjFKpSKwCoLDaybOwAk3MC9eE5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/03/26 1:49 pm, Lorenzo Stoakes (Oracle) wrote:
> On Tue, Mar 10, 2026 at 01:00:07PM +0530, Dev Jain wrote:
>> Clean up the code by refactoring the post-pte-clearing path of lazyfree
>> folio unmapping, into commit_ttu_lazyfree_folio().
>>
>> No functional change is intended.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
> 
> This is a good idea, and we need more refactoring like this in the rmap code,
> but comments/nits below.
> 
>> ---
>>  mm/rmap.c | 93 ++++++++++++++++++++++++++++++++-----------------------
>>  1 file changed, 54 insertions(+), 39 deletions(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 1fa020edd954a..a61978141ee3f 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -1966,6 +1966,57 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>>  				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
>>  }
>>
>> +static inline int commit_ttu_lazyfree_folio(struct vm_area_struct *vma,
> 
> Strange name, maybe lazyfree_range()? Not sure what ttu has to do with

ttu means try_to_unmap, just like it is used in TTU_SYNC,
TTU_SPLIT_HUGE_PMD, etc. So personally I really like the name, it reads
"commit the try-to-unmap of a lazyfree folio". The "commit" comes because
the pte clearing has already happened, so now we are deciding if at all
to back-off and restore the ptes.

> anything...
> 
>> +		struct folio *folio, unsigned long address, pte_t *ptep,
>> +		pte_t pteval, long nr_pages)
> 
> That long nr_pages is really grating now...

Reading the discussion on patch 1, I'll convert this to unsigned long.

> 
>> +{
> 
> Come on Dev, it's 2026, why on earth are you returning an integer and not a
> bool?
> 
> Also it would make sense for this to return false if something breaks, otherwise
> true.

Yes I was confused on which one of the options to choose :). Since the
function does a lot more than just test some functionality (which is what
boolean functions usually do) I was feeling weird when returning bool.
But yeah alright, I'll convert this to bool.

> 
>> +	struct mm_struct *mm = vma->vm_mm;
>> +	int ref_count, map_count;
>> +
>> +	/*
>> +	 * Synchronize with gup_pte_range():
>> +	 * - clear PTE; barrier; read refcount
>> +	 * - inc refcount; barrier; read PTE
>> +	 */
>> +	smp_mb();
>> +
>> +	ref_count = folio_ref_count(folio);
>> +	map_count = folio_mapcount(folio);
>> +
>> +	/*
>> +	 * Order reads for page refcount and dirty flag
>> +	 * (see comments in __remove_mapping()).
>> +	 */
>> +	smp_rmb();
>> +
>> +	if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
>> +		/*
>> +		 * redirtied either using the page table or a previously
>> +		 * obtained GUP reference.
>> +		 */
>> +		set_ptes(mm, address, ptep, pteval, nr_pages);
>> +		folio_set_swapbacked(folio);
>> +		return 1;
>> +	}
>> +
>> +	if (ref_count != 1 + map_count) {
>> +		/*
>> +		 * Additional reference. Could be a GUP reference or any
>> +		 * speculative reference. GUP users must mark the folio
>> +		 * dirty if there was a modification. This folio cannot be
>> +		 * reclaimed right now either way, so act just like nothing
>> +		 * happened.
>> +		 * We'll come back here later and detect if the folio was
>> +		 * dirtied when the additional reference is gone.
>> +		 */
>> +		set_ptes(mm, address, ptep, pteval, nr_pages);
>> +		return 1;
>> +	}
>> +
>> +	add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
>> +	return 0;
>> +}
>> +
>>  /*
>>   * @arg: enum ttu_flags will be passed to this argument
>>   */
>> @@ -2227,46 +2278,10 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>
>>  			/* MADV_FREE page check */
>>  			if (!folio_test_swapbacked(folio)) {
>> -				int ref_count, map_count;
>> -
>> -				/*
>> -				 * Synchronize with gup_pte_range():
>> -				 * - clear PTE; barrier; read refcount
>> -				 * - inc refcount; barrier; read PTE
>> -				 */
>> -				smp_mb();
>> -
>> -				ref_count = folio_ref_count(folio);
>> -				map_count = folio_mapcount(folio);
>> -
>> -				/*
>> -				 * Order reads for page refcount and dirty flag
>> -				 * (see comments in __remove_mapping()).
>> -				 */
>> -				smp_rmb();
>> -
>> -				if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
>> -					/*
>> -					 * redirtied either using the page table or a previously
>> -					 * obtained GUP reference.
>> -					 */
>> -					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
>> -					folio_set_swapbacked(folio);
>> +				if (commit_ttu_lazyfree_folio(vma, folio, address,
>> +							      pvmw.pte, pteval,
>> +							      nr_pages))
> 
> With above corrections this would be:
> 
> 	if (!lazyfree_range(vma, folio, address, pvme.pte, pteval, nr_pages))
> 	   ...
> 
>>  					goto walk_abort;
>> -				} else if (ref_count != 1 + map_count) {
>> -					/*
>> -					 * Additional reference. Could be a GUP reference or any
>> -					 * speculative reference. GUP users must mark the folio
>> -					 * dirty if there was a modification. This folio cannot be
>> -					 * reclaimed right now either way, so act just like nothing
>> -					 * happened.
>> -					 * We'll come back here later and detect if the folio was
>> -					 * dirtied when the additional reference is gone.
>> -					 */
>> -					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
>> -					goto walk_abort;
>> -				}
>> -				add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
>>  				goto discard;
>>  			}
>>
>> --
>> 2.34.1
>>
> 
> Thanks, Lorenzo
> 


