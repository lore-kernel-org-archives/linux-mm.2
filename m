Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0583FC5DF86
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 12:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1CD96B009D; Wed, 19 Aug 2026 08:52:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCD2C6B009E; Wed, 19 Aug 2026 08:52:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0A216B009F; Wed, 19 Aug 2026 08:52:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B0D1D6B009D
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 08:52:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 43C861A0553
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 12:52:57 +0000 (UTC)
X-FDA: 85118008794.12.23EEE6B
Received: from mta0.migadu.com (out-148.mta0.migadu.com [91.218.175.148])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3550B80011
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 12:52:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P9sCUq93;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.148 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787143975;
	b=OKLaqk0WwArNY9jm646SU07h51ksbSFbfcRWCGWFqmV5Xh8dRXdDH6w1FuO7jeW7R173oT
	CG5EYwS4blgjbXKUKoaHE6WkauVilpML67Yeri243U40i8AvN6fZC80sHhkLA/KPD0GXAt
	IAMDffAjQ1l5aHMTemTt/RIJGp3ZHhU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P9sCUq93;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.148 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787143975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ibXxGqsMhwFJD2waDa3x4ni9eIlL2DT9iipu+iSS9cU=;
	b=OsZSPB5zBP6R/Fmjb+GnduiVdzmQ+HVkMgrSKNLDtUvBjelKXDbZqiPGCSuIKP7vH8L4zJ
	Br1OtQMCSrFQpkMW46qXetVWmAFn/zGElLhgmSPS20zl+9UO2W+EyZmfzY+jpoRwi60EbP
	JK3ANkc6HdJHdOBd6k0H2qdpQTmYnBw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=HlTMRI/PpG3HyZBNnVKwW/n+Ug098qiyebY2UsdtlLA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787143973; v=1; x=1787748773;
 b=P9sCUq93pM2+Z0vqZ+IvWvOT/nc12n9VVNkqcyPR9VIPXGgv0/r/UHNo+BVmu7DcLvG3TVJl
 YHpzRjIiZ+YUfwsO4SxNfUjeuDcymAZL90Y00Hu0HJBmlhSJbG+pICDjUF+jzvkfHUxHF3ZGzd/
 DXq/OxbB64HvGFjCwCfDA8co=
X-Envelope-To: linux-mm@kvack.org
Received: from [IPV6:2a03:83e0:1126:4:9d:a05e:5bd8:c200] (2620:10d:c092:500::4:a428)
	by smtp.migadu.com with ESMTPS id acc26c9af0fdcd3d;
	Wed, 19 Aug 2026 12:52:53 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <a2dc0b6c-2225-49d5-a24f-4a54c9262f2d@linux.dev>
Date: Wed, 19 Aug 2026 13:52:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/12] mm: swap in PMD swap entries as whole THPs
 during swapoff
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org,
 ying.huang@linux.alibaba.com, baoquan.he@linux.dev, willy@infradead.org,
 youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, baohua@kernel.org,
 dev.jain@arm.com, baolin.wang@linux.alibaba.com, nico.pache@linux.dev,
 liam@infradead.org, ryan.roberts@arm.com, vbabka@kernel.org,
 linux-kernel@vger.kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com,
 yosry@kernel.org, kernel-team@meta.com, linmiaohe@huawei.com
References: <20260818131202.494754-7-usama.arif@linux.dev>
 <20260819053803.15868-1-lance.yang@linux.dev>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260819053803.15868-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3550B80011
X-Rspam-User: 
X-Stat-Signature: g17aptojrpasepr9dssaez7uh6jqw54i
X-Rspamd-Server: rspam06
X-HE-Tag: 1787143974-413649
X-HE-Meta: U2FsdGVkX18gz4wN3C8HvnbXkK8JcIU19OkVR5jwfiPqitLkejTxkILIcFVo7tNdms1OXtKmtJorqvM0bJrqV9QqorDzVmlNEBArDI1yufTg2+r3/PhMfKQ8lesQ5EQYWW/uRlbbneRsTatpLwm+29shIzoxSv0Kb/4ieDhyacTCKuP/aZmV/1b5J6T11p6heRl6cME/q5Fpr/Ajmog/ncm0ZXGrwXIJtIQigdV+DxtvlvQq/aJiaRZKJpe5vf27ycvG47qDjxe41pAKDr2ZS/P9pgepYPnoMZ3HOOSDmuplDYgHOVkYmW188AdM0anH2jiOytTwUZvkk6qq2eDVbOYa738i7qfNDXLCkRGYfDadHwPVb/5D4m7q/MuK1zJP7TevJ/KAmsBEOj+ItIhvb7CoJ3tFtxeC/wpM37pC6LL5dtC3TonwX5UPfK7fEUKEn6eHouRVP0iNENnwgYk/tQuIq9lE4Z10dNRC/nPv8pTBUnJVUE0jQGiBFiaJHK6InmNtm1JxWuQvIUxVTzsNSrbo1uuBn/qglViVsW0AYrLCbRKjG9y7V0JKrCKEpIqMULmUOIyEsVo7zT48xDUHjrtaDQQmdZBezOxIqHkkrqQs8GRElF6z4h4SnVQYRe1QpzP5+iIyMx2gQIvL+dWViqLCBzPa4N8PhBdRJDishoajunrwTUPYwVp/LWcb08t1FNhgzR3cbB/i1u7hSbaYz5dV929ePL1gxmAoLX+rJNBPuAElSZ7MGHb5pVq6Ee3GuuYqiITH1kv2+KUH4pXQ+KtFLZ07Y8AUBfPoqYUvfDjr5/Dx0uxRp3IVEgT0gEfwfGU7bMD5khPoO2kPvtGjvch+0cV+N/+e+mld2BMtcpKUtCNUqFOdr1ap8pk36WauPo0cjcTR+L0jk4gli7U9ftelxuH9mfi/vrTYQ0xJVeMQcbGNrwSyIozb+A3+PRuGsouiG73V54DHjmd5R1b
 2tk02T0T
 jO4jmrhtWOCcgHL8ecGU5729jmZ/Yg5hZjxHZe25AfbfkSaRk/uflrpF+cshyh+SItLQk2P0mwz570gkuZ/tRzHPQFbb+bz3tQLVuZ3Nh0cfIO7J3UB29e95LOyoUcPde/5qA1+LO7wcB6Ts86+PwHr2HlO1vfJhW/fyp7qzzBHN7NGza0lqV24er1tzlgzOSCdOt0yxPk4vA50HUEumB2ElZx41pu6MTSCKfdFkf8fa/fkODhGMb4c+P5k+xHDxQyFIq2OPIgUmm0c6CTrMpMDD/LXwe4sP5OzUsfB3jMtaC6GE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 19/08/2026 06:38, Lance Yang wrote:
> +Cc Miaohe
> 
> On Tue, Aug 18, 2026 at 06:09:47AM -0700, Usama Arif wrote:
> [...]
>> +#ifdef CONFIG_THP_SWAP
>> +/*
>> + * unuse_pmd - Map a locked folio at PMD granularity during swapoff.
>> + *
>> + * The caller provides a locked, swapped-in folio.  Returns 0 on success
>> + * (PMD was mapped).  Returns -EAGAIN if the swap cache folio no longer
>> + * matches the entry or the PMD changed under the lock (try_to_unuse will
>> + * rescan). Returns -EIO if the folio is not uptodate or contains a poisoned
>> + * subpage; in that case the PMD is split so unuse_pte_range() can handle
>> + * individual pages.
>> + */
>> +static int unuse_pmd(struct vm_area_struct *vma, pmd_t *pmd,
>> +		     unsigned long addr, softleaf_t entry,
>> +		     struct folio *folio)
>> +{
>> +	struct mm_struct *mm = vma->vm_mm;
>> +	struct page *page;
>> +	pmd_t new_pmd, old_pmd;
>> +	spinlock_t *ptl;
>> +	rmap_t rmap_flags = RMAP_NONE;
>> +	bool exclusive;
>> +
>> +	if (unlikely(!folio_matches_swap_entry(folio, entry)))
>> +		return -EAGAIN;
>> +
>> +	if (unlikely(!folio_test_uptodate(folio))) {
>> +		/* Let PTE fallback reread each slot independently. */
>> +		swap_cache_del_folio(folio);
>> +		__split_huge_pmd(vma, pmd, addr, false);
>> +		return -EIO;
>> +	}
>> +
>> +	if (unlikely(folio_contain_hwpoisoned_page(folio))) {
>> +		/* Let PTE fallback isolate the poisoned subpages. */
>> +		__split_huge_pmd(vma, pmd, addr, false);
>> +		return -EIO;
>> +	}
> 
> Hmm ... can this miss a poisoned tail?
> 
> memory_failure() sets PageHWPoison(p) before taking folio_lock(), but
> PG_has_hwpoisoned is only set later. Since unuse_pmd_entry() holds folio
> lock across this check, memory_failure() can be blocked on folio_lock()
> with a tail already poisoned, IIUC ...
> 
> folio_contain_hwpoisoned_page() then sees neither a poisoned head nor
> PG_has_hwpoisoned, and set_pmd_at() maps that tail through a normal PMD.
> 
> Note that unuse_pte() checks PageHWPoison(page) directly. Should we check
> each subpage here as well before installing the PMD?


Good catch!

I am going to introduce a helper like below and use it in the next
revision. Thanks!

static inline bool folio_has_hwpoisoned_subpage(struct folio *folio)
{
	unsigned long i;

	for (i = 0; i < folio_nr_pages(folio); i++)
		if (PageHWPoison(folio_page(folio, i)))
			return true;
	return false;
}

> 
>> +
>> +	page = folio_page(folio, 0);
>> +
>> +	ptl = pmd_lock(mm, pmd);
>> +	old_pmd = pmdp_get(pmd);
>> +
>> +	if (!pmd_is_swap_entry(old_pmd) ||
>> +	    softleaf_from_pmd(old_pmd).val != entry.val) {
>> +		spin_unlock(ptl);
>> +		return -EAGAIN;
>> +	}
>> +
>> +	exclusive = pmd_swp_exclusive(old_pmd);
>> +
>> +	/*
>> +	 * Some architectures may have to restore extra metadata to the folio
>> +	 * when reading from swap. This metadata may be indexed by swap entry
>> +	 * so this must be called before folio_put_swap().
>> +	 */
>> +	arch_swap_restore(folio_swap(entry, folio), folio);
>> +
>> +	add_mm_counter(mm, MM_ANONPAGES, HPAGE_PMD_NR);
>> +	add_mm_counter(mm, MM_SWAPENTS, -HPAGE_PMD_NR);
>> +
>> +	new_pmd = folio_mk_pmd(folio, vma->vm_page_prot);
>> +	new_pmd = pmd_mkold(new_pmd);
>> +	if (pmd_swp_soft_dirty(old_pmd))
>> +		new_pmd = pmd_mksoft_dirty(new_pmd);
>> +	if (pmd_swp_uffd(old_pmd))
>> +		new_pmd = pmd_mkuffd(new_pmd);
>> +	if (pmd_swp_uffd(old_pmd) && userfaultfd_rwp(vma))
>> +		new_pmd = pmd_modify(new_pmd, PAGE_NONE);
>> +
>> +	if (exclusive)
>> +		rmap_flags |= RMAP_EXCLUSIVE;
>> +
>> +	folio_get(folio);
>> +	if (!folio_test_anon(folio))
>> +		folio_add_new_anon_rmap(folio, vma, addr, rmap_flags);
>> +	else
>> +		folio_add_anon_rmap_pmd(folio, page, vma, addr, rmap_flags);
>> +
>> +	set_pmd_at(mm, addr, pmd, new_pmd);
>> +	folio_put_swap(folio, NULL);
>> +
>> +	spin_unlock(ptl);
>> +
>> +	folio_free_swap(folio);
>> +	return 0;
>> +}
> 
> [...]
> 
> Cheers, Lance


