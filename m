Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB4EF606A32C
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 02:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nzA2GmE4
Received: by kanga.kvack.org (Postfix)
	id 1DD0D6B0AAF; Thu, 22 Oct 2026 22:32:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B4536B0AB0; Thu, 22 Oct 2026 22:32:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F1436B0AB1; Thu, 22 Oct 2026 22:32:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E11256B0AAF
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:32:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A6A46160201
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:32:12 +0000 (UTC)
X-FDA: 85352316504.21.75FED92
Received: from mta1.migadu.com (out-245.mta1.migadu.com [95.215.58.245])
	by imf15.hostedemail.com (Postfix) with ESMTP id 650F1A0002
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:32:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nzA2GmE4;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.245 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792722730;
	b=1XhrDKUun1bWUBps+guHxrbIsbk3k2mms6ypqOn47UblbacdJg8yzzktHCVjGAkKG2bC3u
	kiwnynep8M7Cd8JEtZ20gebuhwr1XG5lrY9SAfItJOtPiBNsJQEhOk3Rr+/C5L4PZM7dst
	oP7zUWhUr4rTNZLDmX+5zleh+235a3c=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nzA2GmE4;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.245 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792722730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r7c3swfnj+SAiJYhFBwLA8X/WD+blCLvWAWJF6ltOFs=;
	b=ZUH4ROWP+wfpPK30KpJ/Ouu0WgW7igJamYIqTervMPCGzaLdj9Xig5HyW29vxY5QvQe8Fk
	CEW3qiPy0LLGsGegQDstOgjQ66NQoVfYa6Fw5Ec+PKoC3e3Yno9PwcHrpEKg9iT2BtDI5c
	jxarAUr3pTMSnndxQX6xUrcr5vUFaDQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Kl4/f0wED6XjvWDZ9iOMhZfzmTjfloXcrEiM0IjOl9A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792722728; v=1; x=1793327528;
 b=nzA2GmE4Yh/G+hp15F1INaQ8plk0J9EG26KOPWZNUJzG2EKZfo00IeFbc+OMmoF+Enswn2Kr
 oCsefht8iJ372OlQ3fHcMiY5NtNuYhvhN/3Qw1RylNDFF+JzAQWqH+bhYuMPHwDMckBQRm2dPrX
 E4LJMcZddlMBGt1Wzx4Xi4vQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4ce4a1801382ae1c;
	Fri, 23 Oct 2026 02:32:08 +0000
X-Mizu-Trace-ID: 4ce4a1801382ae1c
X-Migadu-Flow: FLOW_OUT
Message-ID: <a340ec5a-c50b-4fa3-b325-52dba86f0015@linux.dev>
Date: Fri, 23 Oct 2026 10:32:05 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/12] mm: hugetlb_vmemmap: simplify shared tail page
 handling
To: Lance Yang <lance.yang@linux.dev>
Cc: osalvador@suse.de, akpm@linux-foundation.org, rppt@kernel.org,
 qi.zheng@linux.dev, jthoughton@google.com, david@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Muchun Song <songmuchun@bytedance.com>
References: <20261020115824.823278-6-songmuchun@bytedance.com>
 <20261023022027.25898-1-lance.yang@linux.dev>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261023022027.25898-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hqxok3p8ehqjb3frd1hip8s5q3c3gnis
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 650F1A0002
X-Rspam-User: 
X-HE-Tag: 1792722730-270035
X-HE-Meta: U2FsdGVkX18J5lc8Ifqf8n2wVp9BNQD9+EHrcZDMCNXA0mSBvqS+dcn4w96OQSdDBe8PI2mKC1jb1HnHXnfK1T2HQjxW1A2QOPzgyMadSrVSkFBbgPdSAnLMnreOsQR+Gj2S4MSQthMTCZjOhEmF91bwPrrjlQBZfe4rdk+NvP7/LWsMpdpZ3yXPz3lLh6w7kskl16u+cfweiZ+xbQl6OQ0P/sRTLL1bN59rHloJIQ6pPlu/qt1QnOFBA0ES3/bakxr+X5vMQI3zlkhqyEqCfmiOis29Z6BC4evjq3H7RSqBRSruNsyauCsmJ031rJyk3sfFAz3pWQWeBTE+ufsOfP95Hdf9bmFq9Suz3P4J2GbJ4fzxnU48zQ2FQji9HdLu+315M+8dXaqfcGBXqbzEkXCVODUKFXPBGyrDoYhVxIP8UwruRthnvOa03L1ye73vOH+7FVzYxfQAB5mGMdYBqHoX1Fn8PV+M+46CgjHRphr4qqK45TblLOAVrmHaXGGBgIm081dBpHtv8oEo3B+53Id8MLyCR3sZ9V42oVwRShncR2EJfEksaTmLXEAYayPYCkN1fWlKi79YgvjPwlQ+/Kb+40K6Zut96RLTPTftoJyW42N2AAYw1gqTJHPBJxskrICVj961zeUFZtE0lFUJWY7oPEvqwQRB3xHNJ7zr2e8SSebx8c3AIXv9gk44Hcv7NB4GPOnRSyLbrx9ogf7+1AUSTvKHxinKhOkhO9DtrpQFKHKsYJafUVhbp5VmBvUSKphkcLLQedIUPu/CQRT6qNRidKzGEW0mvTQLbIxkEU5JV8I0BWK1/TTIzi8PnGYkxWWWtNyIcAnFmmwN6Iqyme2vmyroV1XOna+8J0MyYMVotPAYXB0SlHZ/EvAIOnAemur6zV+U0cUz5Gkth7CmNgpkazPjc6ZzkSyzLkEi2eZzL4EG5uxuY4ojsA44MEJsvtV3pxEwpca0ajQPGHP
 Wx3PsmhM
 cET2hqUYAXigpGIuKE03FQkkJfLhnEyulKxCbHa6P6G2JbiYRz1n0rZWHbtLqXiFyq3g/ePO1BJiCgFWJSt+dNUe2mFTDbnD5CqppVKBB3JDGyo4Hl0uuN5VfLM4N4AEvdS9iQ0hFZuR0k4ei2v+WTu9NTT1xu9LgcTwa6+sMGFPWqaW/VTarTAY218cmjOHxW+tVMs4jO1WwWPD4XWBOo/VGSIXLyxJIK1LlA6mjma4RDq9QMVVDEVxubW/39B4YuiuB498j8CKbIds4JwDWvXr/6Tp/r0cxowObkhVbRKj+r8dyGc4thJpVZv30W+l6IB8AHi+aOSC+2nAHVp7fr5owmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/10/23 10:20, Lance Yang wrote:
> On Tue, Oct 20, 2026 at 07:58:19PM +0800, Muchun Song wrote:
>> The remap walker currently carries a shared tail page selected by its
>> caller, even though the optimize and restore callbacks can derive the
>> same information from the folio being processed.  This adds redundant
>> state to the walker and couples its interface to caller-side preparation.
>>
>> Derive the shared mapping state in the callbacks instead, keeping the
>> mapping policy with the PTE being processed and simplifying the remap
>> interface.
>>
>> No functional change intended.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> include/linux/vmemmap-optimization.h |  6 +-
>> mm/hugetlb_vmemmap.c                 | 89 ++++++++++++----------------
>> mm/mm_init.c                         |  6 +-
>> mm/sparse-vmemmap.c                  |  5 +-
>> 4 files changed, 49 insertions(+), 57 deletions(-)
>>
>> diff --git a/include/linux/vmemmap-optimization.h b/include/linux/vmemmap-optimization.h
>> index 065840f3c241..858311a71b0c 100644
>> --- a/include/linux/vmemmap-optimization.h
>> +++ b/include/linux/vmemmap-optimization.h
>> @@ -91,11 +91,13 @@ static inline struct page *vmemmap_shared_tail_page(unsigned int order,
>> }
>> #endif /* CONFIG_VMEMMAP_OPTIMIZATION */
>>
>> -static inline bool vmemmap_optimizable_pfn(unsigned long pfn)
>> +static inline bool vmemmap_optimizable_pfn(unsigned long pfn, unsigned int order)
>> {
>> -	const unsigned int order = pfn_to_section_compound_order(pfn);
>> 	const unsigned long nr_pages = 1UL << order;
>>
>> +	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
>> +		return false;
>> +
>> 	if (!is_power_of_2(sizeof(struct page)))
>> 		return false;
>>
>> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
>> index 18b72d553955..8fac61b7d74a 100644
>> --- a/mm/hugetlb_vmemmap.c
>> +++ b/mm/hugetlb_vmemmap.c
>> @@ -24,22 +24,18 @@
>>   * struct vmemmap_remap_walk - walk vmemmap page table
>>   *
>>   * @remap_pte:		called for each lowest-level entry (PTE).
>> - * @nr_walked:		the number of walked pte.
>> - * @vmemmap_tail:	the page to be installed as non-first in the vmemmap range
>> + * @nr_walked:		the number of PTEs successfully remapped.
>>   * @vmemmap_pages:	the list head of the vmemmap pages that can be freed
>>   *			or is mapped from.
>>   * @flags:		used to modify behavior in vmemmap page table walking
>>   *			operations.
>>   */
>> struct vmemmap_remap_walk {
>> -	void			(*remap_pte)(pte_t *pte, unsigned long addr,
>> +	int			(*remap_pte)(pte_t *pte, unsigned long addr,
>> 					     struct vmemmap_remap_walk *walk);
>> -
>> 	unsigned long		nr_walked;
>> -	struct page		*vmemmap_tail;
>> 	struct list_head	*vmemmap_pages;
>>
>> -
>> /* Skip the TLB flush while updating the vmemmap page tables. */
>> #define VMEMMAP_REMAP_NO_TLB_FLUSH	BIT(0)
>> 	unsigned long		flags;
>> @@ -140,12 +136,14 @@ static int vmemmap_pmd_entry(pmd_t *pmd, unsigned long addr,
>> static int vmemmap_pte_entry(pte_t *pte, unsigned long addr,
>> 			     unsigned long next, struct mm_walk *walk)
>> {
>> +	int ret;
>> 	struct vmemmap_remap_walk *vmemmap_walk = walk->private;
>>
>> -	vmemmap_walk->remap_pte(pte, addr, vmemmap_walk);
>> -	vmemmap_walk->nr_walked++;
>> +	ret = vmemmap_walk->remap_pte(pte, addr, vmemmap_walk);
>> +	if (!ret)
>> +		vmemmap_walk->nr_walked++;
>>
>> -	return 0;
>> +	return ret;
>> }
>>
>> static const struct mm_walk_ops vmemmap_remap_ops = {
>> @@ -213,51 +211,51 @@ static struct page *vmemmap_dup_page_from_list(const struct page *src,
>> 	return dst;
>> }
>>
>> -static void vmemmap_optimize_pte(pte_t *pte, unsigned long addr,
>> -				 struct vmemmap_remap_walk *walk)
>> +static inline struct page *folio_vmemmap_shared_tail_page(const struct folio *folio)
>> {
>> -	struct page *page = pte_page(ptep_get(pte));
>> -	pte_t entry;
>> -
>> -	/* Remapping the head page requires r/w */
>> -	if (unlikely(walk->nr_walked == 0)) {
>> -		struct page *head;
>> +	return vmemmap_shared_tail_page(folio_order(folio), folio_zone(folio));
>> +}
>>
>> -		VM_WARN_ON_ONCE(!PageHead((const struct page *)addr));
>> +static int vmemmap_optimize_pte(pte_t *pte, unsigned long addr,
>> +				struct vmemmap_remap_walk *walk)
>> +{
>> +	pte_t entry;
>> +	struct page *src = pte_page(ptep_get(pte)), *dst;
>> +	const struct page *page = (const struct page *)addr;
>> +	const struct folio *folio = page_folio(page);
>>
>> -		head = vmemmap_dup_page_from_list(page, walk->vmemmap_pages);
>> -		entry = mk_pte(head, PAGE_KERNEL);
>> +	if (likely(vmemmap_optimizable_pfn(page_to_pfn(page), folio_order(folio)))) {
>> +		dst = folio_vmemmap_shared_tail_page(folio);
>> +		if (!dst)
>> +			return -ENOMEM;
> One thing caught my eye here ... shared tail allocation can now fail after
> we've already remapped the head.

Right. Once the shared page has been allocated successfully, this
shouldn't be a common case.

>
> IIUC, nothing to worry about there, though :) since rollback keeps the
> new head mapped and flushes before clearing the optimized flag or freeing
> the old backing page.

Yes.

>
> [...]
>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>

Thanks.

