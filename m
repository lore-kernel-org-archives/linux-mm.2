Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8954ECDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 06:58:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44B966B0093; Wed, 24 Jun 2026 02:58:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FB396B0095; Wed, 24 Jun 2026 02:58:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 338C66B0096; Wed, 24 Jun 2026 02:58:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 12B7C6B0093
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 02:58:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9ED318CCCC
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 06:58:42 +0000 (UTC)
X-FDA: 84913903284.14.6C541CD
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf23.hostedemail.com (Postfix) with ESMTP id 38041140009
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 06:58:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QtudLKBG;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782284321;
	b=lQhtFgya1rBE2hczRfpyL0ogVHueZmeTaRQyO5Qj6f5whfSw0jJhmVErPcuFhnq6rq5y4e
	Rh4ftjuIbQDdigOrmTHBY/4kWxnenMtuRQJgO5FRf+0o2y4pnBpdsyibRF1uj4mLUzwcn3
	eGO++RbNuve+V7g5MG5j1pADcCb8FS0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782284321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zGLKldePx7r1dzWhJ9pzygXxiTVGhPttEMwGKkjBnek=;
	b=AB0RDpsjC8L0DXvktoZcZ/LLD4NER7GZw6ShxwMDWxOpDKFQSJL7C6RAlvNnD7zcTCag/s
	AkSZn2AEGn3Ywe9dE3rGCcoCEJxWpFEGxcnYhWGzMezXjUiLVDLHaQQfCuRN9a5bdKDs9U
	vU3ooT10duyO3WqQHYQa1sR9exuIT+U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QtudLKBG;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <5d11c940-a8b9-40d4-9b8f-aa2a9909724c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782284317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zGLKldePx7r1dzWhJ9pzygXxiTVGhPttEMwGKkjBnek=;
	b=QtudLKBGcSAIiYOhfSuYwYXrE7BrFJxaCaxmHI66MGPiLwTzNCdy6rqPqA/Gc6gSFyI1sV
	XaRqukOxZmUafB0N7JgptoH+y3hZuWMdeEq+bCVoyV9EB8jhqIBEloxzHYQeyFIAaSQtDr
	NwzmO1eYu3cGLE7L//TwrDdw8UjY3bo=
Date: Wed, 24 Jun 2026 14:58:17 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 02/12] mm/rmap: Add try_to_unmap_hugetlb_one
To: Dev Jain <dev.jain@arm.com>, "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, chrisl@kernel.org,
 kasong@tencent.com, hughd@google.com, liam@infradead.org, riel@surriel.com,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, baolin.wang@linux.alibaba.com,
 pfalcato@suse.de, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <ee0d499c-de98-4860-bfd0-0bce0b4c1bdc@kernel.org>
 <20260618074449.24974-1-lance.yang@linux.dev>
 <d6259e43-e507-48a4-a048-93b5df2f1b62@kernel.org>
 <0fe2a584-c633-4f82-8c47-d204e3b39a57@linux.dev>
 <e64fc2f2-c4a0-434a-8d60-dcb28b99b8c6@kernel.org>
 <22613c23-612b-4de0-8731-00ad2da63eae@linux.dev>
 <dcfba95b-8cb0-4fa7-a21f-49b595eb92dd@arm.com>
 <ae987527-7ab1-4905-b7f4-8fcc3bebdd52@arm.com>
 <0368128c-664a-40aa-9b37-27768d403795@kernel.org>
 <82474473-ff96-4ee5-bbe4-3d92c2f8cefa@arm.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <82474473-ff96-4ee5-bbe4-3d92c2f8cefa@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: bua4bqtz8iscd3mza396jcxbg6k7fuc1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 38041140009
X-HE-Tag: 1782284320-417573
X-HE-Meta: U2FsdGVkX1+uGVR5KiBNo/TcIcaHxl0qcmigy/ExuA2fJBqANWFgI2T8AYI72Ujjj1xw3r1fRzQL1DjVKnbSObeNr+pOe06PgYIjPW5kHfdUL5CKVexPpfwnwf0WlQBsBpyCGTPJXIRLEbAe0ha7ua9M3CO02pOiPiKpgzfA9hrTPrCw1oj3CE484QoAg12NZkgnCSfzdxHVeL2eLlZPG1ZpVyEKQgwY2y0j8GvfGZ8XmO8IPtY0cNcwMCDIxSwu1r8FEUe4n6hx49BIWLbzrCFb2reW698+xoxpXjbgcWvNrYc3JKWlulmXrHiv/fzb6lLjtT9o/fDfO8BJIIKAECof67alB8H8W5O/q27XJjrOBCLoqhYaGn4xdBnk5HWnTzrgxfJKwSb4AAFDKEN5KlL3FfW1fFrLKKkdoZM6Vx4BRyiFldhWYgRNd8OBnREu/si0iUKGY75fUkB02D0unVOvYK1xPrae0raiEkdzyEfa9IYjjTQnku9k7+v9G95PkY5vFeSRh+GrHJXHOVR9v6wDNJuWARsmQO5TdOMRbtS8hx14NnD31uGcHMTERXuOLhanhN3DFM+vT36bMvahZxfR9pbDFja/t79Mk9X42etisAXsPoiMk1AChMha+9lKnJsy50m068vFSgAy8cXpilDZwWxLeJojE93BYytgoS1UQCI/lz1pIHnnvpMz8AWf2Vc32cIAVAkRwpV0Fl+ax/X9dxxt1M9KSXgbUlrFpHJ4spYxFwIbKLkgqwi3c2BYGhxDQ8lULBd99yuSfflMv7JTeINqtnaxFFCWM2x/YtHhqPGl5ZD2SaBLDnaa6DGnLyaV6yW55nzHaZF0lmxcbY51Sr4SZE2x0YHod9zXv5HlcwJKbpEmWIqyIskcuaRawfK1Ul1AnwS6wnwW1Jz9McV9Ef8n0w6iP/uewNgR23EJWnADiykbYJJLslJfpttteB7VJjn3Ucn3B0S3ohH
 RTvv9tV3
 gbIX5WcD4bjOo7CpKLIqbxATkRli6KkrU5uj6GRkS1Caxk4RicC7I8F/vs15ZzKzPTi2Wu4J3rsLELSmsTtpQwji2XrzXY2datcoJuHvE6Tfj5esXSS4niB/hvSwyLJmCNSqFGrSssiNXiRN+tH7Ar+zMYuUmO4nBVI8zYl/JtbiqOxYPsVJ8/F9Nq3u+q1jySdWpq7P7g8imFkLidCYTyGQvJhSkdZdcNByXB7NkQVEGpSgb8pkUAD9mov8A6LyHXqkv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/24 13:50, Dev Jain wrote:
> 
> 
> On 22/06/26 1:47 pm, David Hildenbrand (Arm) wrote:
>> On 6/22/26 10:14, Dev Jain wrote:
>>>
>>>
>>> On 22/06/26 1:43 pm, Dev Jain wrote:
>>>>
>>>>
>>>> On 18/06/26 3:31 pm, Lance Yang wrote:
>>>>>
>>>>>
>>>>>
>>>>> Yeah, looks like this was already there before the split. Should this
>>>>> be fixed separately?
>>>>
>>>> Same bug is there in try_to_migrate_one(), check_pte(), remove_migration_pte()
>>>> and prot_none_hugetlb_entry() :)
>>>>
>>>
>>> Lemme send a series for them. Main thing is identifying the fixes tag really.
>>
>> Thanks!
> 
> I am confused w.r.t backport. So currently we just have to do this:
> 
> -               /*
> -                * Handle PFN swap PTEs, such as device-exclusive ones, that
> -                * actually map pages.
> -                */
> -               pteval = ptep_get(pvmw.pte);
> +               address = pvmw.address;
> +               if (folio_test_hugetlb(folio)) {
> +                       pteval = huge_ptep_get(mm, address, pvmw.pte);
> +               } else {
> +                       /*
> +                        * Handle PFN swap PTEs, such as device-exclusive ones,
> +                        * that actually map pages.
> +                        */
> +                       pteval = ptep_get(pvmw.pte);
> +               }
> 
> 
> At commit c7ab0d2fdc84, try_to_unmap_one() was converted to use the pvmw API. The
> code was:
> 
> 	while (page_vma_mapped_walk(&pvmw)) {
> 		subpage = page - page_to_pfn(page) + pte_pfn(*pvmw.pte);
> 
> Doing a plain dereference. Before this commit, the code was:
> 
> 
> pte_t *__page_check_address(struct page *page, struct mm_struct *mm,
> 			  unsigned long address, spinlock_t **ptlp, int sync)
> {
> 	pmd_t *pmd;
> 	pte_t *pte;
> 	spinlock_t *ptl;
> 
> 	if (unlikely(PageHuge(page))) {
> 		/* when pud is not present, pte will be NULL */
> 		pte = huge_pte_offset(mm, address);
> 		if (!pte)
> 			return NULL;
> 
> 		ptl = huge_pte_lockptr(page_hstate(page), mm, pte);
> 		goto check;
> 	}
> 
> 	pmd = mm_find_pmd(mm, address);
> 	if (!pmd)
> 		return NULL;
> 
> 	pte = pte_offset_map(pmd, address);
> 	/* Make a quick check before getting the lock */
> 	if (!sync && !pte_present(*pte)) {
> 		pte_unmap(pte);
> 		return NULL;
> 	}
> 
> 	ptl = pte_lockptr(mm, pmd);
> check:
> 	spin_lock(ptl);
> 	if (pte_present(*pte) && page_to_pfn(page) == pte_pfn(*pte)) {
> 		*ptlp = ptl;
> 		return pte;
> 	}
> 	pte_unmap_unlock(pte, ptl);
> 	return NULL;
> }
> 
> 
> This does pte_pfn(*pte), a plain dereference. I am not sure how back I need
> to go for the backport and do I need to post multiple patches for different
> stable versions.

Yeah ... looks old old old, not just c7ab0d2fdc84.

Stable backport looks kinda messy though. Mainline can probably stay
as one clean series, but stable might needs separate review per tree.
Going to be a pain ...
> And, it is crazy that the bug has stayed for this long and testing didn't find this.
> Perhaps no one bothered running hugetlb-read-hwpoison on PPC or s390. And for some
> reason those tests are in a category of "destructive" in run_vmtests.sh, requiring
> a command line option - and even that option was fixed just now in 3432cbb291aa!

Sigh ...

