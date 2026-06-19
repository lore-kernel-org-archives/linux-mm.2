Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E487CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 12:35:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C5056B008C; Fri, 19 Jun 2026 08:35:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19C3F6B0092; Fri, 19 Jun 2026 08:35:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DCAB6B0093; Fri, 19 Jun 2026 08:35:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DEB9F6B008C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:35:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D8C581C4D5C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:35:01 +0000 (UTC)
X-FDA: 84896606802.05.1A4961F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 48ADA20010
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:35:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bkCvrc8q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781872500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LPTdqcfE3XkHm6Hlqj60cB+qa6fB0LufMaAVlDRj1Jg=;
	b=h8Wd7XkLHo3Hbqc9KeyOUPBkfRuHD6HbZVtmTKejSuwPh9DL2AfAQieTAHavFLu52IWnJv
	a9trzlNOYDs6O0+DosvfBO7ZIEuVy6yY2XrDJakFRZf7nHRkztJCDdwNRPrSQGOWtsPM6Q
	OgWgfxz5egyddmSMjZjf4dkTTTO1USo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781872500;
	b=BGK0yO2RYixbj/RxRMJFP5OvBrYNxBsTtoVHMu3amHovbFSwvNpLBIBav+5dC0FvQVi/y/
	1VdsAlh/2dhGzuaKWPylRxty2oJZi/j8Ia4Qb6rCTW1Qg3vRRtFtGZ5jB2q0Xi8bWiYDzZ
	6u0BfRwWa40nSQwyYs3JWBxB/0sX4fw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bkCvrc8q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CBC8E601E1;
	Fri, 19 Jun 2026 12:34:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78EF71F000E9;
	Fri, 19 Jun 2026 12:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781872499;
	bh=LPTdqcfE3XkHm6Hlqj60cB+qa6fB0LufMaAVlDRj1Jg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bkCvrc8q91bS7UYJUGghBnJYg0zzAF3AQB8nybB/1ygAtU2Eh7B2LLO04LAVVJTJB
	 Z2aXlMRK80r8gBnuRHY4H/rNMM2aqIjgqujVWm99e1v1IctHmpmJvSTA4EoqWtifHh
	 WPI0X+zGb7uSTEJN6yH/Rweu9UW+i+CbRg0QNblk35T0kx0JFgLNhMuHdCxzGr0oLB
	 ylmE/jz6LIzCr20pVGJcslfYiYvLJtXu3MazuL+m8pYxsdThiuetua4kLrFYmduZKw
	 WyPbLEmmMH2Oy2slPZN8IUToZ4xtrjoiXepDLzBQoqL+VxIqsoG9HNDZjP93dYBrsG
	 ZCV6s7gXeQ6cA==
Date: Fri, 19 Jun 2026 13:34:53 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Dmitry Ilvokhin <d@ilvokhin.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 2/3] mm/pagewalk: let folio_walk_start() run under the
 per-VMA lock
Message-ID: <ajU1AdbQVkk4AOKs@lucifer>
References: <20260616190300.1509639-1-riel@surriel.com>
 <20260616190300.1509639-3-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616190300.1509639-3-riel@surriel.com>
X-Rspamd-Queue-Id: 48ADA20010
X-Stat-Signature: eiey3tbnn1aj695iqrstbhuh5u5u1hyb
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1781872500-162479
X-HE-Meta: U2FsdGVkX18msx/zuhGcFrp3kRuqbrYouZTLfEDmTnm51pgPpbWPYZfNkP3pi+nZ/1Skwe+vME8N98YwK6bMan2+pBgHiqiIj8aPmMMqUmZMur/Jw+lwgwc4/66wLkZZXF/l0XAkSlIaRNTvEfRk+yqhQbLe7DWiWJ4S7FVULY1IOl8uYqx2DgMAYIL1ytvLWFP+R1DdXNvijfI8ExlCKsyIqkFOuMoPolDx45UfSSv5q+SyrSU/BTDipW+8YFIOmxUim/X1lJhOfB1AmlUsBG2d6enY1Bt2/ZnOk7ShNOdw4octbQlhj3pBL1yq7lNQjcUqYH7BGIr1MMuPzml6zF0W6HUBFdGyvcTsGuLCGXLk7oM52viRdOrXWiVK7n/MIvs105/D0VcI9v2v389Ybk62lOx3PLc89hEGY4q2iWI7PY0o/n68GB85S5J/MmZnvBvaGiRywbqeTQSapxTiQV/CZaXI8klCJ4LWwocSfspFoyq0uIHbdm4y+w2H7GNPkqWGb89Hf3TXI25Wh0LFkw7gE58OoTfDj9Xh0lvbCRMWhj9A1ODUy00/x0fBHBSDdbKTQXGjekrosSwpvKgAp3UucNPzFbEPxsoMA8gsj2Q/MeFkVOz8pr1HIn7uJn8e6qs/3LHPjPTSrPaoDbiULQVaULST8MyN4lRXL6PVW9oM8r8VW22plVCfC2uVw7MCoCn0Jifo8fCNuNQjlv7ezBYzTmC7mbVMxSjw59b2KEwSf4YUI68PeyNOZOI0nIQROyRlGMhQCJnKCW0WCdU6pEoQ7pKwjT+cpBv2T19PlS/VnR6OKpKGy6+LCmW5TjgJG9GONmPCl3Hzruernw5wz/3oRo/HJPHGJMrfENlpmjIjrfKovdqxbtPnE1B6jjozjtWNI+ckZoBSU7oKMtfTgO8G8qD9Ki1gqftpTPRZNPuEqkrQ2iMAFcgdQqRzasZK/jAmLFJ85r2jmn18tXb
 MFgRyr1v
 1NE6PddDf8zofoAl4VMBI/kQS5W7ZWhQwC2PSFz+sy6zsouxAzNlLoiwy2zMP8ke4aSTvo/0oAyyjEODB7TTdK3IgvwyvhstnmJox2cwpwuevODAVHmcFfblKKFtKzTkuJAVT/vE1NsAmT1bB2CZ6+08Njiq//ntW9ls1ePTFf+tGHcu5s/Gjiz6yxkqp1K4AuEB8CNs+urywXQg+u1hkD0msl3cblmkAe2inYtFgLPh4WepERqbeUIIa45jIHAARH56MLaPYI8aQL7yS353YtITMgVjeMo7RrQdYiu6KQeXM3VV4UsJsqUXgJGw5PvKBoyUUo+hCL6uGR87HYVc5nj7xeiwK5zLYn+2hh8D3Og420ntK8rEmJv6OO5nqyj4g0JqoOlSCGMY+8+rsLPh4u4yqiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 03:02:59PM -0400, Rik van Riel wrote:
> folio_walk_start() asserts that the mmap lock is held.  For callers that
> only need to read a single, already-present page, the mmap lock is a
> heavy and often badly contended hammer: the VMA can instead be
> stabilized with the per-VMA lock, and the page table pages that are
> walked are kept alive by RCU page-table freeing
> (CONFIG_MMU_GATHER_RCU_TABLE_FREE).

See below, I don't think this is correct?

>
> Add an FW_VMA_LOCKED flag.  When passed, folio_walk_start() asserts the
> per-VMA lock instead of the mmap lock, requires RCU-freed page tables,
> and refuses hugetlb VMAs (PMD sharing cannot be walked safely this way).

This is mostly superfluous. You can just say you added the flag to use a VMA
flag. You put in parens the key thing about hugetlb, I think you should break
that out.

> Everything else folio_walk_start() relies on -- the page table locks,
> pmdp_get_lockless() and pte_offset_map_lock() -- is already safe without

is -> are.

> the mmap lock, mirroring the per-VMA lock page fault path.

I'm not sure I understand why you have to have RCU freed page tables but then
say that you didn't need it here? Strange to reference arbitrary functions from
folio_walk_start() too.

>
> No existing caller passes FW_VMA_LOCKED, so behaviour is unchanged.
>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Rik van Riel <riel@surriel.com>
> ---
>  include/linux/pagewalk.h |  5 +++++
>  mm/pagewalk.c            | 18 ++++++++++++++++--
>  2 files changed, 21 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
> index b41d7265c01b..84dd0d68f747 100644
> --- a/include/linux/pagewalk.h
> +++ b/include/linux/pagewalk.h
> @@ -150,6 +150,11 @@ typedef int __bitwise folio_walk_flags_t;
>
>  /* Walk shared zeropages (small + huge) as well. */
>  #define FW_ZEROPAGE			((__force folio_walk_flags_t)BIT(0))
> +/*
> + * The caller holds the per-VMA lock instead of the mmap lock. Only valid with
> + * RCU-freed page tables (CONFIG_MMU_GATHER_RCU_TABLE_FREE) and not for hugetlb.
> + */

Hang on how could we be freeing higher level page tables of a VMA that's still
locked?

A VMA lock stabilises page tables for traversal, so why do you require
CONFIG_MMU_GATHER_RCU_TABLE_FREE here?

What will free the higher-level page tables?

Ref: https://origin.kernel.org/doc/html/latest/mm/process_addrs.html#page-table


> +#define FW_VMA_LOCKED			((__force folio_walk_flags_t)BIT(1))
>
>  enum folio_walk_level {
>  	FW_LEVEL_PTE,
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index 3ae2586ff45b..c85364b73e12 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -890,7 +890,9 @@ int walk_page_mapping(struct address_space *mapping, pgoff_t first_index,
>   * huge_ptep_set_*, ...). Note that the page table entry stored in @fw might
>   * not correspond to the first physical entry of a logical hugetlb entry.
>   *
> - * The mmap lock must be held in read mode.
> + * The mmap lock must be held in read mode. Alternatively, if @FW_VMA_LOCKED is
> + * passed, the VMA's per-VMA lock must be held (only supported with RCU-freed
> + * page tables, i.e. CONFIG_MMU_GATHER_RCU_TABLE_FREE, and not for hugetlb).
>   *
>   * Return: folio pointer on success, otherwise NULL.
>   */
> @@ -908,7 +910,19 @@ struct folio *folio_walk_start(struct folio_walk *fw,
>  	pgd_t *pgdp;
>  	p4d_t *p4dp;
>
> -	mmap_assert_locked(vma->vm_mm);
> +	if (flags & FW_VMA_LOCKED) {
> +		/*
> +		 * Lockless walk: the per-VMA lock keeps the VMA stable, and
> +		 * RCU-freed page tables keep the walked page table pages alive
> +		 * across the lockless upper-level walk and pte_offset_map_lock().

Err, but we take locks as normal on the walk?

> +		 * Hugetlb (PMD sharing) is not supported on this path.

I don't get the explanation above and then you just write a line that says what
your assert is doing with zero explanation here.

You should explain why hugetlb isn't supported.

> +		 */
> +		VM_WARN_ON_ONCE(!IS_ENABLED(CONFIG_MMU_GATHER_RCU_TABLE_FREE));
> +		VM_WARN_ON_ONCE(is_vm_hugetlb_page(vma));
> +		vma_assert_locked(vma);
> +	} else {
> +		mmap_assert_locked(vma->vm_mm);
> +	}
>  	vma_pgtable_walk_begin(vma);
>
>  	if (WARN_ON_ONCE(addr < vma->vm_start || addr >= vma->vm_end))
> --
> 2.53.0-Meta
>

Thanks, Lorenzo

