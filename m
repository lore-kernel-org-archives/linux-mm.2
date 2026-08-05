Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F82EC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 16:47:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A072C6B0088; Wed,  5 Aug 2026 12:47:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B8036B008A; Wed,  5 Aug 2026 12:47:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CE896B0092; Wed,  5 Aug 2026 12:47:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 64A1C6B0088
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:47:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E7EAB120479
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:47:19 +0000 (UTC)
X-FDA: 85067796198.02.E2D0806
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4C39518000C
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:47:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A6jBclpF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785948438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z9ff1GnKQpBmTB5WuPa0pXsrjiC6I++6LwfzPO8ewrk=;
	b=tygFfVzJ1th2reSNWef/sPNoI1NOe5VwL4MNfOy5TQ7K5NEHk64yYfHf3N0LzDYMNaP1m4
	uwcvo3hbyuZDkLmd3eSKnv4ChEcRU/lmqIxVAv7uoxqNvGeOOmUJmzTtpgAkOZDLhfLKeW
	SyvUVlmzz6TUmVohUlmPZ1W7ZIwsuYM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A6jBclpF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785948438;
	b=PcvaCyfdhK7qoQ2R1Mvc5c2h+gexStR9if81smbNlANfHNwbKubn6qfTsDp1csk56cm4p0
	qUTHvK14h8WHlnC3uU8UvM0bx5VYuKPByU/k/pxHxln0A3TtXi6gm+wXanCsSUpAYiofVf
	o0UauKOo5EaxoDJRc5FOxwPRwpVwguA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BBF0060A5A;
	Wed,  5 Aug 2026 16:47:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9CA81F000E9;
	Wed,  5 Aug 2026 16:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785948437;
	bh=z9ff1GnKQpBmTB5WuPa0pXsrjiC6I++6LwfzPO8ewrk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=A6jBclpFTshrEQq44jW377gffeq+Z+8DkSIwBYMAOq/8vcCO9il/kDqGtfkIMLNg/
	 wefmi89TXRPZofEevi45q3ITb7mk3iqNxmn8ho18+ntWlFOUVJaNQyeB8BbRX/ZB36
	 pr7z9g0CUKDlAo8//rWwno4A9OhOpXun+FpT3A92wc5HN/k8OuoiCjHOvR/SN44pFJ
	 F85XCKFRvj+zTj/iPjQUySiq24Q2OeqXv5WEdimmjfOCjyjqB+0srGJMB41Zar/iay
	 1g3U+lA1teWTb0dOJQZSX3QitV90/5WhKWISFtTk5APrhxYY7lD9iunErWUUgLgkcq
	 rkkvddjqmXVLw==
Date: Wed, 5 Aug 2026 17:47:00 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Longlong Xia <xialonglong2025@163.com>
Cc: akpm@linux-foundation.org, david@kernel.org, xu.xin16@zte.com.cn, 
	chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	xialonglong@kylinos.cn
Subject: Re: [PATCH v2] mm/ksm: validate KSM rmap items before hwpoison kill
Message-ID: <anNl1SSA3fidOrTy@lucifer>
References: <20260803151151.3472893-1-xialonglong2025@163.com>
 <20260805162937.1795310-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805162937.1795310-1-xialonglong2025@163.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4C39518000C
X-Stat-Signature: 7fiqd3qyb5kae7f8gjcrt1ac1pf8h9rk
X-Rspam-User: 
X-HE-Tag: 1785948438-850735
X-HE-Meta: U2FsdGVkX18D+M7opWR0pk5ejCFIgI+TSYVOG67OVFcsotnvoD82yX0hz/KAkKHz9yOOaXd4siz1O6UIbHGCFzuhUM7ObYyOsmq8H2Xhb/EY6ICn0UTHxfUxjgL23BzZqb/deChAyFsPLJkKE8GPvPlp2e9Ux4wytcxlDR3BT9gRmxTLjt1i+ffPj9LhYHg6Qy18zDwxLzyCG5xTz8PWYG6s5EO+IS/aynRIh/JvI2/b9hKceCfg5l3/70wRRy7MaoQpWzlkwU9yOSPEsLfwwxRyjzTG+FQ/yhIt3oOCgjbdcb93IfimFJJwkV/Hn0W+RuC6a+GvmQwpQL/KQMYdV5cLN0j0IZhdtns+EwJtegHhk7LQG7o+LMjiqWSPnxwGwy+1iD3cgnr4fJUZqXXOjRxSerP8OtRabkjf1uuR8QjzfhgAuaOUUq+lriSmOEtCzlN1cVxdCKqZlI6w+yb3Rf/EDu/+AJrkQQ9jWlkxJc7WRguESV2nIo0XjvsGeRK25Cdyx76c6aQllwc7ajU3T/SjQ959lu1EB5E1rvlW/rPnQX8MLBRGcEk1RvT/PNmlGdJpklmbId7aIzIIQbdxIatshrUNP9DQDp4oWKvhIxAfxe7lCleuzF2D/Ozv/07mMXtjMhguBhmVxgXXFzIF5TKxvsGYaWLAjqFzDTIACSTsMl/zUiEAVL3kL7aCPXm2EfjLBYQ6PwhjF2VobkdUqHrWf75kpMC4roNNmHGkBWg3tSpnH60dWzjUoGajfXehNvkOE4F/8fDswnIxRZ6P7ONoXwHlVCSYvRA0pHrT4nuVR/KUrFhrnQknxnlaL6mn/672MjodtJ1i0vdAjoRhIwG4OQ1eJKepHryGuuYBDuSlJrv7KWFl/enO7tqPzdRlQ9KdfVYZTN9qwOQYHJw9O6CWBeS504zEA1+HxOPvSNtuyBm1mTLiJG/9Qp4lO0sg63yBQVjrf32L87sJhRP
 mte0/Gx9
 fzYqdXSWFFtNtqSvmFlZUa3lzRmbBoo42lupKFmZ55IvwqyH+GkUmcOP7js25KXnaYrE3T9gU8qbmDfHW5FKoAcFmAfpwVheHD+AKs/LMgx5Rz0dkPQuA18LvpmwWtTBRKOhubOAxCIE8VOid13368PCpxlZTnXbqnB9BR5HZf5ngAFj+nvmuPni+48pGDAzNW16PnuUQ/jM+bdoKniDbKkC7y4ToHue3tYQISQSUgA024YC+DZ865dAkPnKIaHQJv+c+mW5NimBIxRcH08aU5nEUXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

:))) I did just say don't send a v2 but I guess you didn't see it.

Basics:

- Please don't respin when somebody's literally asked for feedback from somebody
  else.

- Please don't send v2 of a patch in-reply-to a v1 send it separately.

- Please don't send a v2 on the same day as a v1.

- Attach a changelog under the --- with a link to prior versions (using b4 makes
  this easy).

Anyway I guess I am forced to reply here... *grumble*.

Thanks, Lorenzo

On Thu, Aug 06, 2026 at 12:29:37AM +0800, Longlong Xia wrote:
> From: Longlong Xia <xialonglong@kylinos.cn>
>
> collect_procs_ksm() walks the stable-node rmap list and queues an
> early kill for every task whose mm appears on the anon_vma chain.
>
> That rmap item can be stale by the time memory failure handles the
> poisoned KSM page. A VMA may have been split, unmapped or remapped
> after the rmap item was recorded, so matching only vma->vm_mm can send
> SIGBUS with an address that no longer maps the poisoned page.

I'm very confused as to where memory poisoning comes into it? What exactly
made you aware of this? Do you have a bug report you've observed?

>
> Factor page_mapped_in_vma_at_address() out of page_mapped_in_vma() so
> callers that already know the virtual address can validate it directly.
> This avoids deriving the address from page_pgoff(), which is invalid
> for KSM pages. Use the address saved in the KSM rmap item to check that
> it still belongs to the VMA and that page_vma_mapped_walk() still finds
> the poisoned page before adding the task to the kill list.
>
> Fixes: 4248d0083ec5 ("mm: ksm: support hwpoison for ksm page")
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>

Honestly I have to ask - is this your own work or AI-generated? As I'm not
confident you really understand this and it's tricky stuff so if a
backportable patch is in the works I'd prefer somebody who understands it
contributes it.

> ---
>  mm/internal.h        |  2 ++
>  mm/ksm.c             | 10 +++++++---
>  mm/page_vma_mapped.c | 36 +++++++++++++++++++++++-------------
>  3 files changed, 32 insertions(+), 16 deletions(-)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index 181e79f1d6a2..4c9e601b2d95 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1424,6 +1424,8 @@ void add_to_kill_ksm(struct task_struct *tsk, const struct page *p,
>  		     unsigned long ksm_addr);
>  unsigned long page_mapped_in_vma(const struct page *page,
>  		struct vm_area_struct *vma);
> +unsigned long page_mapped_in_vma_at_address(const struct page *page,
> +		struct vm_area_struct *vma, unsigned long addr);
>
>  #else
>  static inline int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, bool must_kill)
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 7d5b76478f0b..5104e442fcb2 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -3237,13 +3237,13 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
>  	if (!stable_node)
>  		return;
>  	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
> +		const unsigned long addr = rmap_item->address & PAGE_MASK;
>  		struct anon_vma *av = rmap_item->anon_vma;
>
>  		anon_vma_lock_read(av);
>  		rcu_read_lock();
>  		for_each_process(tsk) {
>  			struct anon_vma_chain *vmac;
> -			unsigned long addr;
>  			struct task_struct *t =
>  				task_early_kill(tsk, force_early);
>  			if (!t)
> @@ -3253,9 +3253,13 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
>  			{

OK so you're literally doing an anon rmap walk here, with the anon lock held.

>  				vma = vmac->vma;
>  				if (vma->vm_mm == t->mm) {
> -					addr = rmap_item->address & PAGE_MASK;
> +					const unsigned long mapped_addr =
> +						page_mapped_in_vma_at_address(page, vma, addr);

Now you're doing another anon rmap walk? Why on earth are you doing that? And
won't this deadlock?

Why aren't you just checking the whether addr is contained in the range here?

Like:

	/* Make sure VMA wasn't split/remapped */
	if (!in_range(addr, vma->vm_start, vma_pages(vma)))
		continue;

Or something?

> +
> +					if (mapped_addr == -EFAULT)
> +						continue;
>  					add_to_kill_ksm(t, page, vma, to_kill,
> -							addr);
> +							mapped_addr);
>  				}
>  			}
>  		}
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index bac2eb5de63d..f7c5dc9248bc 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -336,6 +336,26 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>  }
>
>  #ifdef CONFIG_MEMORY_FAILURE
> +unsigned long page_mapped_in_vma_at_address(const struct page *page,
> +		struct vm_area_struct *vma, unsigned long addr)
> +{
> +	struct page_vma_mapped_walk pvmw = {
> +		.pfn = page_to_pfn(page),
> +		.nr_pages = 1,
> +		.vma = vma,
> +		.address = addr,
> +		.flags = PVMW_SYNC,
> +	};
> +
> +	if (addr < vma->vm_start || addr >= vma->vm_end)
> +		return -EFAULT;
> +	if (!page_vma_mapped_walk(&pvmw))
> +		return -EFAULT;
> +	page_vma_mapped_walk_done(&pvmw);
> +
> +	return pvmw.address;
> +}

I hate this name I hate that it's CONFIG_MEMORY_FAILURE only.

Also it sounds like a predicate but returns an address? I have no idea what this
is supposed to do? And no kdoc?...

> +
>  /**
>   * page_mapped_in_vma - check whether a page is really mapped in a VMA
>   * @page: the page to test
> @@ -350,20 +370,10 @@ unsigned long page_mapped_in_vma(const struct page *page,
>  		struct vm_area_struct *vma)
>  {
>  	const struct folio *folio = page_folio(page);
> -	struct page_vma_mapped_walk pvmw = {
> -		.pfn = page_to_pfn(page),
> -		.nr_pages = 1,
> -		.vma = vma,
> -		.flags = PVMW_SYNC,
> -	};
> +	const unsigned long addr = vma_address(vma, page_pgoff(folio, page), 1);
>
> -	pvmw.address = vma_address(vma, page_pgoff(folio, page), 1);
> -	if (pvmw.address == -EFAULT)
> -		goto out;
> -	if (!page_vma_mapped_walk(&pvmw))
> +	if (addr == -EFAULT)
>  		return -EFAULT;
> -	page_vma_mapped_walk_done(&pvmw);
> -out:
> -	return pvmw.address;
> +	return page_mapped_in_vma_at_address(page, vma, addr);

Oh yes, make the !CONFIG_MEMORY_FAILURE build break *eye roll*

>  }
>  #endif
> --
> 2.43.0
>

--
Cheers, Lorenzo

