Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22C17CD8C85
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 07:44:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78FA66B0092; Tue,  9 Jun 2026 03:44:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7670B6B0093; Tue,  9 Jun 2026 03:44:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67CDB6B0095; Tue,  9 Jun 2026 03:44:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 560BA6B0092
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 03:44:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 12DF71403F7
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:44:43 +0000 (UTC)
X-FDA: 84859587246.01.BABA3EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3EEC6140007
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:44:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XDopFgC1;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780991081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M2jMGukV8yyAtn/4N/ehPeGeMg24FUo6LtfBjjS6QVk=;
	b=QVogJGrEKXxIfeZjPeC1/A66rVLBLBneq/SI6IbeFEO9D/tNhsZx+LZLxVFCZUK6tDm5YH
	/+wTgofEZTObejG8iOH3+VnrntYCsfHExK3zpivHzo8uVwpFwbe+yU312rNt0P5C63o3Jo
	db9ZMLxM/fiXlfBLlcYgi4KxOsfBHJ8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780991081;
	b=Th29KUqCJpDQNn2iZXNG4TQNub7UdM9vqpXxIgKpJErPc0F3zL0UdrKcmLv86jPPfxD4ZM
	yrFqIryjSMYffDE/Vjj0//UMPF36LJV9I0MUfliKofFKn9DaAnnGd+Js842glO4zS/FIRg
	J+64GcYyNNlmiFv2Sjazvo1cTok0J4M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XDopFgC1;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8ABC543638;
	Tue,  9 Jun 2026 07:44:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8021F00893;
	Tue,  9 Jun 2026 07:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780991080;
	bh=M2jMGukV8yyAtn/4N/ehPeGeMg24FUo6LtfBjjS6QVk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XDopFgC1HfBlX5774qviVQckb2+Afen8JWH9vOCweIzsxR8dUgxIy0ZnE3zE5oOt7
	 DrBi3SnhxooN9BjVxFZTaUcc92Fk7Ul0VF++nAAnwzZQJiQFz5VVbUb7CJPrpdfdN6
	 fIZczgpMWNRzs+owIV6oig3qLEOVO5U6JbQY0d+AGGt9MTsw8K9WE+ZL1ooCWLg/kK
	 /uQlogS/9aI3bLqcZKxpNddmOqraUpa17+U6s4S6xAKnfPdm1h3ZweYAE2nbvUVgrz
	 hVGLJOsA2QSjs1PRXvw/56GoYa3w8/wuIafVI/9IpZA3x4HoYTcY+LeO6pL6kVqCyp
	 xqkynbAPM6iiw==
Message-ID: <84886648-8cbb-49db-a816-de3e0d359ed0@kernel.org>
Date: Tue, 9 Jun 2026 09:44:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 1/3] ksm: add linear_page_index into ksm_rmap_item
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org
Cc: chengming.zhou@linux.dev, hughd@google.com, wang.yaxin@zte.com.cn,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ljs@kernel.org
References: <20260609124031750t-yHeQFCJs4gAeOmsvEJx@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260609124031750t-yHeQFCJs4gAeOmsvEJx@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3EEC6140007
X-Rspam-User: 
X-Stat-Signature: uk96okmfx56fmy888ypnfjhxbscxk8m9
X-Rspamd-Server: rspam08
X-HE-Tag: 1780991081-489892
X-HE-Meta: U2FsdGVkX19Rjc72PvhpVF0+iHUC8EiROm7C0JwpDR4W5Q71K78bD/Uj+deyUJETYoC1DqZZkKJu8w9HOmzfcQg6EV8uT+EGaqhukpV2Zd54HoUJupe+3poGpM1u8lx05VjhmDNQsbxR7fQGBX6w+uJLg+8SFcaN3A64zq0BXLqB0ukFNSnT1mu0NlmWgKghSPiR4ZbD9EaDzxvea/UQUyjfvtwgBJ/Cz4qqpUw383cq5MDM/GqOEKKBvSGdeO74Hxnt1fDtokNEsUhD62Pnqwgrp0M6TFXxNHzWt23eyECHrMBfx5IfJ8qKYEYtIgkKYiuVX+kJaoUrYp+M2mKCGvHzSTdqf/wI+43pwCCUlzi1oAMAMRtyxVzQsMDrMOIan1mTXJtTfpxayYbeJHM4JH/3FVj3aUkzcgYMRZZFNiTOjPXjkc6jX8xl5BUKkUrqskKS7ipDMT/SzRkdBTg8oeD4wKGCN0ebWEkQIvXefShQJaveRJHjCBP2SZlS5EY7fHWBrhL6ws430d0Brh5BFLWvOKPR86L+DIMkS1HAFNt80NX9oCgP4M1ISE4Ml3EEv9+yjaKxdaUnaei+LJAPCROJA5PDWCy36rDluZC8Rr/Qwji0dBuVZz4HcDhXlhS9Ti0isbvsFVpAq01P1jUtRAfdNGEmNPT5r8LsOoi2HPcq95zt3HnlqRdbI46zsne2U2ieL3BSYU/gZevvwvmbbGt/vCJc8YiMV14j2+A32xd1wP4AA2LUd/5dVJdhrOCbVmz1eAO956tNibd80wh+oEUrVE5mpans/sL4x7NByr0LULx6vttTq99eB01vUIkkUli4u/BJGy9TRfco9yMtXwIgPqLsftLab6XXqtz/Vq/MiORU6EvkhXm57b9zaIv5T3xV/PQeHp3prx7DughFYjPHar6mNtb986/nL9Qtl9wmK0rW9weCKSplMkhMxt6RWzAsBR75fbYn1PV6tt3
 piIG2jVV
 WsJ86bQQ6D/mPYpjFRoCQNyCc1uUjSo+qcBX2nzL4lIB/lXs03SefVkfP43uj3ugTbnv6c0AJezelxQKyA3ghszF9TWkm7naaiUsKkFL2UdqO5Uz8l9j9QuawmgctkphK7k7EimNU2ozZdnzy4uRBCLzTvv2X9OERl8Vf10ESCOrNhGJy8jUA92KdbeSlJROgOXbydurxBy7ux9KCNK5H6VMB0GnYJb+nzhiCTDq1G5ReN6f9tHrM2tXqQu79ty37TIgPMgnuO7bnEK7ShhTRiZLFg3GV0umM0N7MniPpH4iEVk5kQ9d+hX+zI6V3VIHoYZD6ZQLgOExc1Xfw5iujwtizhEFN53fABL7nBM9hyR3HnJrtz8iSxgs162lCnCujEt+ChbIds8lT7jA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 06:40, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> As preparation for KSM rmap optimizations, let's track the original
> linear_page_index() of a de-duplicated page in its ksm_rmap_item, so we can
> efficiently search for the page in an address space, avoiding scanning the
> entire address space. This was previously discussed in [1, 2].
> 
> To avoid growing ksm_rmap_item, let's squeeze it into the existing
> structure by overlying some members (oldchecksum, age, remaining_skips)
> that are only relevant while on the unstable tree. The new entry will
> only be relevant for entries in the stable tree.
> 
> However, as the age information is read by should_skip_rmap_item() with the
> smart-scanning approach even while we have an entry in the stable tree, but
> the page changes (no longer a KSM page, for example due to COW), we have to
> change the handling there a bit.
> 
> We'll calculate the linear page index in try_to_merge_with_ksm_page(), when
> adding it to the stable tree, and reset the index (to reset overlayed data)
> when removing an item from the stable tree -- in
> remove_rmap_item_from_tree(), remove_node_from_stable_tree() and
> break_cow().
> 
> To be specially clarified, the reason for resetting the stored index at
> break_cow() is:
> 
> - When a page successfully becomes a KSM page (i.e., after
>   stable_tree_append() sets STABLE_FLAG), both anon_vma and the index are
>   stored and remain valid.
> 
> - However, during the merging process, there are several failure paths
>   where we already prepared an rmap item to be added to the stable tree,
>   but must revert that as some part of the merge process failed. Examples
>   include:
>     * The second call to try_to_merge_with_ksm_page() fails in
>       try_to_merge_two_pages().
>     * stable_tree_insert() fails in cmp_and_merge_page().
>   In such cases, break_cow() is invoked to break the COW mapping and
>   discard the KSM state.
> 
> Currently, break_cow() already contains a put_anon_vma(rmap_item->anon_vma)
> to release the reference taken during the aborted merge. Because the index
> is logically paired with anon_vma (both are only meaningful when the
> rmap_item is in a stable state), it must also be cleared (or reset) in
> break_cow() to avoid leaving stale linear_page_index values that could
> confuse subsequent rmap walks or scanning logic.
> 
> [1] https://lore.kernel.org/all/adTPQSb-qSSHviJN@lucifer/
> [2] https://lore.kernel.org/all/202604091806051535BJWZ_FTtdIm3Snk24ei_@zte.com.cn/


[...]

> +/*
> + * break_cow: actively break COW, replacing the KSM page by a fresh anonymous
> + * page. This is called when rmap_item has not yet become stable, but page
> + * has been merged.
> + */
>  static void break_cow(struct ksm_rmap_item *rmap_item)
>  {
>  	struct mm_struct *mm = rmap_item->mm;
> @@ -787,6 +798,11 @@ static void break_cow(struct ksm_rmap_item *rmap_item)
>  	 * to undo, we also need to drop a reference to the anon_vma.
>  	 */
>  	put_anon_vma(rmap_item->anon_vma);
> +	/*
> +	 * Reset linear_page_index that might overlay age-related
> +	 * information. (it's still unstable node)
> +	 */
> +	rmap_item->linear_page_index = 0;

Sashiko comments that, on 32bit, it is not overlaying age-related information.
So setting it to 0 won't clear the age.

Which is what we document with the "might".

On 32bit, it simply behaves the way it was before (no reset of age-related
information here).

We could move oldchecksum below remaining_skips to clear age-related information
consistently. Not sure whether that is really worth it.

I would even say that we can just stop supporting KSM on 32bit completely.

> 
>  	mmap_read_lock(mm);
>  	vma = find_mergeable_vma(mm, addr);
> @@ -899,6 +915,8 @@ static void remove_node_from_stable_tree(struct ksm_stable_node *stable_node)
>  		VM_BUG_ON(stable_node->rmap_hlist_len <= 0);
>  		stable_node->rmap_hlist_len--;
>  		put_anon_vma(rmap_item->anon_vma);
> +		/* Reset linear_page_index that might overlay age-related information. */
> +		rmap_item->linear_page_index = 0;
>  		rmap_item->address &= PAGE_MASK;
>  		cond_resched();
>  	}
> @@ -1052,6 +1070,8 @@ static void remove_rmap_item_from_tree(struct ksm_rmap_item *rmap_item)
>  		stable_node->rmap_hlist_len--;
> 
>  		put_anon_vma(rmap_item->anon_vma);
> +		/* Reset linear_page_index that might overlay age-related information. */
> +		rmap_item->linear_page_index = 0;
>  		rmap_item->head = NULL;
>  		rmap_item->address &= PAGE_MASK;
> 
> @@ -1598,8 +1618,16 @@ static int try_to_merge_with_ksm_page(struct ksm_rmap_item *rmap_item,
>  	/* Unstable nid is in union with stable anon_vma: remove first */
>  	remove_rmap_item_from_tree(rmap_item);
> 
> -	/* Must get reference to anon_vma while still holding mmap_lock */
> +	/*
> +	 * Must get reference to anon_vma while still holding mmap_lock.

I think this sentence should go, and instead ...

> +	 * Must can only reference the VMA while still holding the mmap

This one should become:

"We can consider the VMA only while still holding the mmap lock, so ...

> +	 * lock, so reference the anon_vma and calculate the linear page
> +	 * index early, before stable_tree_append(). If anything goes
> +	 * wrong that prevents the rmap_item from being added to the
> +	 * stable_tree, break_cow() will clean it up.
> +	 */
>  	rmap_item->anon_vma = vma->anon_vma;
> +	rmap_item->linear_page_index = linear_page_index(vma, rmap_item->address);
>  	get_anon_vma(vma->anon_vma);
>  out:
>  	mmap_read_unlock(mm);
> @@ -2458,6 +2486,13 @@ static bool should_skip_rmap_item(struct folio *folio,
>  	if (folio_test_ksm(folio))
>  		return false;

Thinking about the overlay once more, I'm trying to assess what it means when we
clear rmap_item->checksum. We'd do that now in:

(a) remove_node_from_stable_tree(): We had a stable node -> KSM page, but
something changed.

(b) remove_rmap_item_from_tree(): Same as (a)

(c) break_cow(): we have to unshare, either because insertion into the stable
    tree failed, or because we would have only a single PTE mapping the KSM
    folio after a failed merge.

For (c), I guess if we'd have to, we could remember the checksum while
processing the rmap_item.

Clearing rmap_item->checksum implies that cmp_and_merge_page() would refuse to
merge one round.

Having rmap_item->checksum cleared is just like allocating a fresh rmap_item. So
it will fix itself up during the next scan.

So my best guess is that this is alright.


Hoping for no surprises in corner cases

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

