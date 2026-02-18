Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE064E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 08:05:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 401E26B0088; Wed, 18 Feb 2026 03:05:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AC946B0089; Wed, 18 Feb 2026 03:05:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 283C86B008A; Wed, 18 Feb 2026 03:05:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 157376B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 03:05:31 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AA643B8F9F
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:05:30 +0000 (UTC)
X-FDA: 84456842820.29.0A7E5BF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0876F1C0013
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:05:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ifcTjY9H;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771401929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nkv/NUejxvXdMFo4/VtixNTsNo6qSR37gXrwhjWvtG0=;
	b=wNO/Pp3mcW4sbpLnnRfe4tzfNaG7hL3exj5M3qcE8WnWilhyEGQ2urtjzD/qzfVw3Xm3pO
	aenla8v/rKr9yDK+faDzJIxSUyRfGsvtVe0OuTC5HuZULsH029mkyK1qZ93Aq6T394SpdY
	QZyXsBXR47L/turlRe05a+3Y1LPadaI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ifcTjY9H;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771401929; a=rsa-sha256;
	cv=none;
	b=AQCj70vAgrbYw66orTJvXI1TEqiK2ZQi1y8p6pRMrA6oBQhqSzhWbgJ45KRwhhPGITYLh4
	R9R44WbgGZujDvzhYuCcyNhFpQ3eNrZfXZFVXm8FHq5wxhP78NKekI/0b8WtJ9o7SvFEAa
	VNdNVzkNd3hFQ0GxUaXLfVuQNugBycY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7128A600AE;
	Wed, 18 Feb 2026 08:05:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCFF2C19421;
	Wed, 18 Feb 2026 08:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771401928;
	bh=qw9gzxcNy19n9/pZuKUBlr0jWF8fKT2TdJbUSdrsj5I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ifcTjY9HX2ZaJSz7QsVRODHUNOV5bYWzzj/OLHRzEPynMGd8/dS72kINYOXhHKrDd
	 wiGJrXNVyd8i1siWYDCDLWSwUGWZZtQvmhdRIZQWYnQ72YiUYdeSS7Jx5EFGfjrMw0
	 jtKsVL3AUZ9xbEzIHVD6dUWgDLqvA3ZU4yYjPUEcjqWJytnFDJEMcRzUeiFH3eK4tO
	 Tv+1NJIXuE07xMqPu+BLELA7pbuMHx5ShdZ2zSFIhXacczreKk+qFo84QDyZ9rdgrk
	 vZxwBa+KEecNI70kqKMW8ZAOlwT2WxYqml/5ofnRBihY+zi9cOCMIV5iceZOxBeEQ6
	 r1zM8vGRr6saQ==
Message-ID: <392f45e0-0942-47c9-8833-d54833842e9e@kernel.org>
Date: Wed, 18 Feb 2026 09:05:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v7 2/5] mm: khugepaged: refine scan progress number
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20260207081613.588598-1-vernon2gm@gmail.com>
 <20260207081613.588598-3-vernon2gm@gmail.com>
 <4qdu7owpmxfh3ugsue775fxarw5g2gcggbxdf5psj75nnu7z2u@cv2uu2yocaxq>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <4qdu7owpmxfh3ugsue775fxarw5g2gcggbxdf5psj75nnu7z2u@cv2uu2yocaxq>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yw6u8jyhigk7dqcju4o8eg5um9p3ohpe
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 0876F1C0013
X-HE-Tag: 1771401928-360586
X-HE-Meta: U2FsdGVkX1/Q9/oatgwm+e5lZqO3qfTpe8PHkynAsTPM50a514lWKVpPI0nFL1QZAYIx78oZMV825KwkXpnVK3pUTorKjyh7nDIRNb1wNTMCayxWXDqSosNvsEo0DFvMKBtwqbgeSAppPEtYe07BIk51ddpXGmNAbJ+aiQMWUZ3pJB7Xb3sifpxgDA01NC0ngAY4OfDejH7pebmf94GqJMBggXlgPXS2ScUj/Y7gaJJXEH0MXOl2YjfrfiVt+fL4BzR2VTDVJlBCIbWtXWVSNFmCiWo1Yog1LbnB91WdNIGd7cDhRdx3GlIMLdG+4gDza4CY8V6DlnnO5KQ77S0XrYVXS4ZlSnRVPa/v+snbL/0TkRYXgFnMJ1VVFnmk5ffCiEUEuCAOLeT2K364Sqdy3W8WhlLPK4uFs6wLGFapl7sl4qMMd7yD1bHTvs/KKwIASBh7xcStKW57rqIOLpaOlaMcJrCc8F2jDGhDRB5vXpCzyKtvnHFWMVGszbxsm/89HwHiL+mutnInEKbE6MNpjj+XFA3xXyK567p7PM7ksnIZnKVTS0a8YmyaHUc1t/eMvaXJNE/kOvHriaZasLrdi9jZfw/JFsm4TH9UXcSwO7Hgp1SYrfS6eHGF/gSO7OZYVr+4FYKJLE8yXU3R98bSmDYK/sNnetmZ2e8Q7BN5MTJ1WSu/QlAaFSeirempLhkzL/59m/s1S7Ue/jgFeSXP9CIOfxjue9kinlBcTCXP1c3YH4eDWh5fTtj+y69+2NsuJE6zNKSr5TYSCQJJFYxuEgQ/hNkcTfUabr1NfyKLlhv2BH54BPPi8PMNI2zVWCE98ZS7B9qBU/CxBktrrEqIGyc9D7QfUVgPy2re9UpaMdzJFOYhXMALseFKYof+nsDmKdb5nCBSrTyLOMTYcuj1N9lcoLhpsw3T6Wl3fiMZjbBecKlYHdvr7jgUOKqI4lkLbw83kecyH4WivJoVOxT
 Vxho8gAE
 2Rvbg+UReQEknP+Z73/JIkx92/6zP1bgEdwi8T5Y7Gs48N7jYH21yjLHYJ1+A66EAr2CC768OyIxCB57NiwvBf0xyU8gYKNKFFVO1oHjgys3qHXG3HJw4b22f0JgCMed9DZsnd1nrhNICvVN76V6jh2tHidVeEFBt2/rDHy28dP5rC60nHiMJC6K4kjqp74Lyzgq7NoOkccI6TtPqHF3WxP/Ek83kujJf83CRKwuUzdp8xucOndls9uBGB8hI8+JvzdnM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/18/26 04:55, Vernon Yang wrote:
> On Sat, Feb 07, 2026 at 04:16:10PM +0800, Vernon Yang wrote:
>> From: Vernon Yang <yanglincheng@kylinos.cn>
>>
>> Currently, each scan always increases "progress" by HPAGE_PMD_NR,
>> even if only scanning a single PTE/PMD entry.
>>
>> - When only scanning a sigle PTE entry, let me provide a detailed
>>    example:
>>
>> static int hpage_collapse_scan_pmd()
>> {
>> 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>> 	     _pte++, addr += PAGE_SIZE) {
>> 		pte_t pteval = ptep_get(_pte);
>> 		...
>> 		if (pte_uffd_wp(pteval)) { <-- first scan hit
>> 			result = SCAN_PTE_UFFD_WP;
>> 			goto out_unmap;
>> 		}
>> 	}
>> }
>>
>> During the first scan, if pte_uffd_wp(pteval) is true, the loop exits
>> directly. In practice, only one PTE is scanned before termination.
>> Here, "progress += 1" reflects the actual number of PTEs scanned, but
>> previously "progress += HPAGE_PMD_NR" always.
>>
>> - When the memory has been collapsed to PMD, let me provide a detailed
>>    example:
>>
>> The following data is traced by bpftrace on a desktop system. After
>> the system has been left idle for 10 minutes upon booting, a lot of
>> SCAN_PMD_MAPPED or SCAN_NO_PTE_TABLE are observed during a full scan
>> by khugepaged.
>>
>>  From trace_mm_khugepaged_scan_pmd and trace_mm_khugepaged_scan_file, the
>> following statuses were observed, with frequency mentioned next to them:
>>
>> SCAN_SUCCEED          : 1
>> SCAN_EXCEED_SHARED_PTE: 2
>> SCAN_PMD_MAPPED       : 142
>> SCAN_NO_PTE_TABLE     : 178
>> total progress size   : 674 MB
>> Total time            : 419 seconds, include khugepaged_scan_sleep_millisecs
>>
>> The khugepaged_scan list save all task that support collapse into hugepage,
>> as long as the task is not destroyed, khugepaged will not remove it from
>> the khugepaged_scan list. This exist a phenomenon where task has already
>> collapsed all memory regions into hugepage, but khugepaged continues to
>> scan it, which wastes CPU time and invalid, and due to
>> khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
>> scanning a large number of invalid task, so scanning really valid task
>> is later.
>>
>> After applying this patch, when the memory is either SCAN_PMD_MAPPED or
>> SCAN_NO_PTE_TABLE, just skip it, as follow:
>>
>> SCAN_EXCEED_SHARED_PTE: 2
>> SCAN_PMD_MAPPED       : 147
>> SCAN_NO_PTE_TABLE     : 173
>> total progress size   : 45 MB
>> Total time            : 20 seconds
>>
>> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
>> ---
>>   mm/khugepaged.c | 38 ++++++++++++++++++++++++++++----------
>>   1 file changed, 28 insertions(+), 10 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 4049234e1c8b..8b68ae3bc2c5 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -68,7 +68,10 @@ enum scan_result {
>>   static struct task_struct *khugepaged_thread __read_mostly;
>>   static DEFINE_MUTEX(khugepaged_mutex);
>>
>> -/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
>> +/*
>> + * default scan 8*HPAGE_PMD_NR ptes, pmd_mapped, no_pte_table or vmas
>> + * every 10 second.
>> + */
>>   static unsigned int khugepaged_pages_to_scan __read_mostly;
>>   static unsigned int khugepaged_pages_collapsed;
>>   static unsigned int khugepaged_full_scans;
>> @@ -1240,7 +1243,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>>   }
>>
>>   static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>> -		struct vm_area_struct *vma, unsigned long start_addr, bool *mmap_locked,
>> +		struct vm_area_struct *vma, unsigned long start_addr,
>> +		bool *mmap_locked, unsigned int *cur_progress,
>>   		struct collapse_control *cc)
>>   {
>>   	pmd_t *pmd;
>> @@ -1256,19 +1260,27 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>>   	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
>>
>>   	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
>> -	if (result != SCAN_SUCCEED)
>> +	if (result != SCAN_SUCCEED) {
>> +		if (cur_progress)
>> +			*cur_progress = 1;
>>   		goto out;
>> +	}
>>
>>   	memset(cc->node_load, 0, sizeof(cc->node_load));
>>   	nodes_clear(cc->alloc_nmask);
>>   	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
>>   	if (!pte) {
>> +		if (cur_progress)
>> +			*cur_progress = 1;
>>   		result = SCAN_NO_PTE_TABLE;
>>   		goto out;
>>   	}
>>
>>   	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>>   	     _pte++, addr += PAGE_SIZE) {
>> +		if (cur_progress)
>> +			*cur_progress += 1;
>> +
>>   		pte_t pteval = ptep_get(_pte);
>>   		if (pte_none_or_zero(pteval)) {
>>   			++none_or_zero;
>> @@ -2288,8 +2300,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>   	return result;
>>   }
>>
>> -static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
>> -		struct file *file, pgoff_t start, struct collapse_control *cc)
>> +static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
>> +		unsigned long addr, struct file *file, pgoff_t start,
>> +		unsigned int *cur_progress, struct collapse_control *cc)
>>   {
>>   	struct folio *folio = NULL;
>>   	struct address_space *mapping = file->f_mapping;
>> @@ -2378,6 +2391,8 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
>>   			cond_resched_rcu();
>>   		}
>>   	}
>> +	if (cur_progress)
>> +		*cur_progress = HPAGE_PMD_NR;
> 
> Hi David,
> 
> When using Fedora Server, I found a lot of SCAN_PTE_MAPPED_HUGEPAGE.
> 
> The following data is traced by bpftrace[1] on Fedora Server. After
> the system has been left idle for 10 minutes upon booting, a lot of
> SCAN_PTE_MAPPED_HUGEPAGE are observed during a full scan by khugepaged,
> as shown below:
> 
> SCAN_SUCCEED            : 1
> SCAN_PMD_MAPPED         : 22
> SCAN_EXCEED_NONE_PTE    : 67
> SCAN_PTE_MAPPED_HUGEPAGE: 919
> 
> I simply handled SCAN_PTE_MAPPED_HUGEPAGE by "cur_progress" equal to 1,
> as follows:
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 437783cf2873..7f301bebfb11 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2405,8 +2405,12 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
>   		}
>   	}
>   	rcu_read_unlock();
> -	if (cur_progress)
> -		*cur_progress = HPAGE_PMD_NR;
> +	if (cur_progress) {
> +		if (result == SCAN_PTE_MAPPED_HUGEPAGE)
> +			*cur_progress = 1;
> +		else
> +			*cur_progress = HPAGE_PMD_NR;
> +	}

That makes sense to me.

-- 
Cheers,

David

