Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D305B606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 22:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HrSF/e4j
Received: by kanga.kvack.org (Postfix)
	id 9B5206B05B2; Fri, 30 Oct 2026 18:15:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98EC36B05B3; Fri, 30 Oct 2026 18:15:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87BE36B05B5; Fri, 30 Oct 2026 18:15:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BBB46B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 18:15:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CA386807FE
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 22:15:27 +0000 (UTC)
X-FDA: 85380699894.07.859EC1F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id F39C44000E
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 22:15:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HrSF/e4j";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793398525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ae/WNpwhDO2VnWY2svGWtlkmRzAah686LwChcMW5xuY=;
	b=cFaY5ZeAxb76MGZ2YJ4M2rEbxbf2oz76QARTDXMs7qVjyNmpT+7004DryaxWszDMJQNme0
	aJ2zS2VrkDxpYD8gZaVSMi/zsbrGuORBAQOumtW1mzjNND0NXH+P9OuZ0Ro2Sq50/nNjY1
	XYY7IOfPiMV+b0Nsti9dIcL71XM96Gs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HrSF/e4j";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793398525;
	b=1ys7GfGH678ZhFkVszChxMFM7laIm/7cIYVF1vDXahF6516uzzJITxY2u+DPHc0l5AOHww
	fWNFJ2LD9N1nStJF+PNcSAq5vCk3AQTjBEvUhWfAThIB2lvFRR4mw9FkVF90MI/oPkGkVL
	vOuuHr2STonbX/TaHLMvnNmS5jf22M4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 24ED1414EB;
	Fri, 30 Oct 2026 22:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26BF1F000C1;
	Fri, 30 Oct 2026 22:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793398524;
	bh=ae/WNpwhDO2VnWY2svGWtlkmRzAah686LwChcMW5xuY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HrSF/e4jvxLJdiVvNyJjOVr3iEP3BLH4f4XAOlLGgXaIvlPhikoj4YcSfGH7ZIMVF
	 wHUCHkhC6F1spfp2lEuuTiwV0MiUnz53NpxMPVlI+ImhsdAvAAF2hYYkJsCp4hc+hH
	 byDuDl5TI3NUj/SelCEpqDact3Uutl+KgcA2wnfGPEAilnnOBODMx+JoxsiRjYDO6E
	 FH9dNeKGww6ELtUIcxcOHYY63B4XaEZw7LZIRDH95QkrBz6eEd2csTie08F49UaUO4
	 z1AJuSoyoa1fX+EBB3lU0NvvuhtJETgT4+kg8Hk1HqsdhhKjmPkCKL5MSUVaOyNA5J
	 OvrHw4iesX/tQ==
Message-ID: <04ad7001-bdd4-47e1-9a80-5b2464da1044@kernel.org>
Date: Fri, 30 Oct 2026 23:15:18 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/swapfile: drop a large unmapped swap-in folio in
 unuse_pte()
To: mt4022@columbia.edu, Andrew Morton <akpm@linux-foundation.org>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, tz2294@columbia.edu, stable@vger.kernel.org
References: <20261030-swapin-large-unmapped-v1-1-41e4ae378e6c@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261030-swapin-large-unmapped-v1-1-41e4ae378e6c@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F39C44000E
X-Spam-Status: No, score=-22.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: af7xgyjzq5h543ujcg7i1rghoezexrma
X-HE-Tag: 1793398524-223381
X-HE-Meta: U2FsdGVkX1+zDjtyLKY3je940o4Too0QC37+IeepgsF8T0O0JjEY5C2Ydc9XxLFAunj0izOOfo9z78UCwpj9L5crH1H5uZ4nzG5pNi1i+i/KL39JM05N1VvJwlDqw+vUxGd1V22oeOJ/w9guTnk7DzYEeC/KRS7YEA0INzl1JJx8rollT736inV0cyuNwQCwfpbAkyXLcuO9lMFTyEMvj6H36yU1+ToBtoux7v1VCjkKp0G0tUVo971OacC1x8o85YV8CgWvtf7qPVY3036oGvmgGKfHClfCwsZoNCx7qu00TBzNaePJssbwDyRQRaxLvw84yLd5PhNT7aeqtkUfpot/aSoRXuGfFUsKJw5+OtDTYOD0HbWCwp7as8QC771bLNFoAkESpWmFgo8JgEm3gK24aqy4rICgJRF0sR1ICsTjuiRm1kdigMlKJnPy56tyyI0YenBYC62dxnteHQYy5xcTr+AW1/zrw7+IK+gErUEWEmBrq6r0hPxqOsrJmp9f3YWfGUe/P+sfbCA7Y3IURG6HN3pxxRziZPneDNlVzXF1sWU52AMiWn6gvH9TRBW/gbnxowWBK4PU0mX2wDlGbq4/V30+kDrMMpqSH5Vp705GaD9FfbIoaxP6iSk5edCVRpIoVj+J+qHmCJenhek9ChBFqz5xLQtx/jLzyTjMHmhJJc0allwpGPIKteUj/yWYQrX2YGl7yk7X9EOyZ/NodlCjvZMfOTr+fNXeNwQuIbr3hu7x38n91O2xpCO47dXw+NgCnqff5cqsP0fk+a3ZHoG9Vd2jgOHfJkKj0w/er3PvOU2T/zfOTGXM7GieCrkyOaDu/d4OOpiwtFDzBx6KSbrAy9MTU44nuCHmxAZEbQC7wmWwI3Yntc0JHCjo9QaBBT3Lp0Qt1vOwgk92grjDoctnn2+udnTrp0hCQ1yHKo68eoK+70dYccjni4nYPiGCpOlEdBmFZhiaFlg7BqK
 tDHbp3NX
 5hZvkziLlGD7HDUulTbap5q8q8qpLCVcLl+K+mIYDWLO9SlwDJ3F337p34lUQ15RbzRf1VZ1skaKIf70iY9tnkHNxpikmGUlyjrDCqvxwqPe96W5oO32upbMxGVGiX53POrcH057Lifh6ehcvJQFt+jmXFfvC7UUbfFAoZh3SZfq4uvkcA132Edphioxd9FtL/l8Wqm+FaLWILkVBfayHVU/8bH4yK/IcXrF3jSKtb54bq3ukTlnLrZ6dhrUsTfG/cUR90+VSDnxgB1e87arDjB+kDDy/nRv6pYl8TFKUJCxsDDpwpNgkbQuQVQWGtbirRWGhV6hDLcJ/WvL7sGeqCMyt5pEjyZ2bj5yJhCpK2k4XS2pBv6F6j0Ir19sbD6BfpXA7hoCAN21Wb4A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/30/26 20:11, Mani Tofigh via B4 Relay wrote:
> From: Mani Tofigh <mt4022@columbia.edu>
> 

Thanks for the report!

> Since commit f1879e8a0c60 ("mm, swap: never bypass the swap cache even
> for SWP_SYNCHRONOUS_IO"), a fault can read a swapped-out mTHP range into
> one large folio in the swap cache.  The folio only becomes anon once
> do_swap_page() maps all of it, so if the faulting PTE changes in the
> meantime the folio stays in the swap cache while not being mapped or
> anon:
> 
>   Task A (fault)                       Task B
>   do_swap_page()
>     /* swaps in large folio F */
>                                        madvise(MADV_DONTNEED)
>                                          /* zaps the faulting PTE */
>     /* PTE changed (F not mapped) */
> 
> swapoff then maps it, which marks all of its pages as mapped and
> exclusive, and the next fault on one of the other PTEs crashes in
> do_swap_page():

Ugh.

Why is this special to large folios? I guess because a single PTE keeps the
large folio alive, right?

The problem really is that unuse_pte() open-codes whet do_swap_page() would
usually do. And it doesn't handle large folios in this scenario correctly.

What a mess.

I guess we could just teach unuse_pte() to only map a single PTE.

folio_add_new_anon_rmap() assumes the folios is fully mapped. We could add
up to twp folio_remove_rmap_ptes() calls with everything except the page we want
to map.

But reading below ...

> 
>   [    6.424485] kernel BUG at mm/memory.c:5195!
>   [    6.424503] Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
>   [    6.427654] CPU: 0 UID: 0 PID: 67 Comm: swapmthp Tainted: G        W            7.3.0-17087-gd865f2677c44 #1 PREEMPT
>   [    6.432665] RIP: 0010:do_swap_page+0x24eb/0x2fa0
>   [    6.451035] Call Trace:
>   [    6.451567]  <TASK>
>   [    6.453841]  __handle_mm_fault+0x13b5/0x3b40
>   [    6.458525]  handle_mm_fault+0x16f/0x480
>   [    6.461143]  do_user_addr_fault+0x312/0xa30
>   [    6.462044]  exc_page_fault+0x66/0xc0
>   [    6.462846]  asm_exc_page_fault+0x26/0x30
>   [    6.476708]  </TASK>
> 
> do_swap_page() already drops such a folio from the swap cache when it
> can't map all of it.  Do the same in unuse_pte() so that swapoff swaps
> the entries in again.  With the fix, nothing is reported.

We indeed have this

if (!folio_test_anon(folio) && folio_test_large(folio) &&
    nr_pages != folio_nr_pages(folio)) {
	...
}

check.

The nr_pages check makes sense as in your case below it's simply nr_pages == 1.

> 
> This bug was identified and confirmed with the help of a deterministic
> hypervisor currently under development.  The C reproducer below however
> hits it within a second.

Rings a bell :)

> 
> Fixes: f1879e8a0c60 ("mm, swap: never bypass the swap cache even for SWP_SYNCHRONOUS_IO")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
> ---
> This conflicts in context with patch 41/47 of David's v2 series [1],
> which changes the line right below in unuse_pte() for KSM folios.  I
> can rebase on top of it once it's applied if needed.

It will likely get applied on top of

	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next

Tomorrow and then quickly find its way into next. So if a resend is required,
best to send against that.

> 
> [1] https://lore.kernel.org/all/20261029-fixes_core-v2-41-a64ce7f83abb@kernel.org/
> 
> Reproducer: https://github.com/manitofigh/files/blob/main/linux-repros/swapmthp.c
> ---
>  mm/swapfile.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 189f04d8838f..b0b75ff16835 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2518,6 +2518,18 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
>  	if (!folio_matches_swap_entry(folio, entry))
>  		return 0;
>  
> +	/*
> +	 * A large folio that is not anon yet was swapped in by a page fault
> +	 * that did not map it (yet). It can only be mapped as a whole, by
> +	 * do_swap_page(). Drop it from the swap cache and swap in small
> +	 * folios instead.
> +	 */
> +	if (unlikely(folio_test_large(folio) && !folio_test_anon(folio))) {
> +		if (!WARN_ON_ONCE(folio_test_dirty(folio)))
> +			swap_cache_del_folio(folio);
> +		return 0;
> +	}

I don't enjoy the additional code duplication, including the comment.

Can you pack the existing handling in do_swap_page() into a helper, pass
nr_pages, and reuse it here?

I guess finding a good name is the main challenge ...


static bool swapcache_folio_mappable(struct folio *folio,
		unsigned int nr_pages)
{
	if (!folio_test_anon(folio) || !folio_test_large(folio) ||
	    nr_pages == folio_nr_pages(folio))
		return true;

	if (!WARN_ON_ONCE(folio_test_dirty(folio)))
		swap_cache_del_folio(folio);

	return false;
}


Just a thought.

But it does look like the right fix.

-- 
Cheers,

David

