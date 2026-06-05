Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5841ACD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 17:19:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 803B16B009B; Fri,  5 Jun 2026 13:19:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B48D6B009D; Fri,  5 Jun 2026 13:19:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A3256B00A0; Fri,  5 Jun 2026 13:19:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 57F896B009B
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:19:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EE87A8CBDF
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:19:17 +0000 (UTC)
X-FDA: 84846519954.20.0F3687E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1B1D4140008
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:19:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oTmNJSyk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780679956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OUcW5mSbSc9PFjh1QilJt+/LGG+Ya3wus4s8DgcyGkg=;
	b=hXx5TlnVSzaJDtamy47Wok4dRDOxcMuG5CL2ImKdHcYPZJ77mhePYeDz9DkZAgdlaMeX05
	u9LjjCHRCPuLqIOwtPpKXbezyefsd4nRKmJH1P7PuJgAuqD91FLCqxQmjCsArbUKbh0srG
	p/jGh6AcOP8c4oLjhBGgErWFRXc5DNk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oTmNJSyk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780679956;
	b=ltwFODioFqKMABx9cSAcr8iCllKl9+4hs/DXInSIbV/7xkdoSxfdTpuwAGPYD+LyeOyw9d
	qBiWxZC/NmrUyX+mm76NWuEU/qO+itemaandhryJ3XPSTMeVXIxqpkcIr7Lu9OGeCi/aFi
	CphBUl4yZQnjDTeyiMu6dfSnuqySp2s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5298B601DD;
	Fri,  5 Jun 2026 17:19:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C351F00893;
	Fri,  5 Jun 2026 17:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780679955;
	bh=OUcW5mSbSc9PFjh1QilJt+/LGG+Ya3wus4s8DgcyGkg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oTmNJSykJ/e3TDxCk87JrTbsCALSdI3l5uDTAqpytiF9KZWVNjlBNbJm9HyUY+Dvl
	 hYaqxI5ooasQzCk9+EmJbzvjx76Yk6jbYlviMohas5VioecW8nerudTerJvfYv8xmK
	 JPX9XywswBiwoSGKUdka6YeinaTKlOX/WlM2J7ce6LKl1lbzbGdv9iW8liXjXDGxyP
	 7sDtjIxfY1piiHgHwL4/nJ7TQSx7hLeh9x3Brs8JT1I5t+nRQ75rCBwGXIiNdCHl3H
	 fTbQejGut/7rZJNmXCa/2aEElRBXhZ/QV006bxjji65xjW4OqOELxvCj63nuZv6EAs
	 q9rbytckx5XQg==
Message-ID: <f6834452-a244-4bb7-8982-136f00591f87@kernel.org>
Date: Fri, 5 Jun 2026 19:19:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 4/6] ksm: add pgoff into ksm_rmap_item
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org
Cc: chengming.zhou@linux.dev, hughd@google.com, wang.yaxin@zte.com.cn,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ljs@kernel.org,
 corbet@lwn.net
References: <20260530170711362Lxt422zijBMtOvPlJD-0-@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260530170711362Lxt422zijBMtOvPlJD-0-@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: m5auw34uboicxnpcufiwya5g893kst1m
X-Rspamd-Queue-Id: 1B1D4140008
X-HE-Tag: 1780679955-141445
X-HE-Meta: U2FsdGVkX1813kTCce1LilX+nhQAVI0BTlA9LJSUSMU6bfnjOo1rYMdpahePhM1zjZHGf9O63w6Y8K/9Km/4uZMG1FxOuBXSXJqVwYo2oAMuVePNfAHH/H0wqb++BtKyy8hBcn7nKxz+pik1z5plAmeSNpY2KvviBpN7sn48VuWT9jFnBjcKlP66vWjMMTK8YfHy+DERh717Epjo0hXJyFCBzGnX4zBQNLZOorcLj1ewmSutB49cA1yU9ofPYuZ+E15ruFXGr3V1i0dQM3FiEfCBjnyoWk4HRG3f6RU9njzq9hHo85sVEhSjKVPtSoxhzTK/FZiZm2n12e0rZlWQYMKRkKTllqmGVVF010Uvs801F8kaqLIk1MJf+UqcchpCvKXicsIDbktPudmBB7QSFuMC6w3OOTOBhnYgxTC6FuB50sK5rPyBF6K8NSU3HylzhHmtE+kCJEmSEm7e+D7fxQK6M3Pk/dQTZd9mPho0L3pv4Ytao4HDRuDODJ3BAga/NrYbvchQl+2BRbrxItVlXgjdo+GEl12GFFoFtYaDs2w5lBTHwn+ZGA6YTCXqmqZ1HnTa5c9mFgZRiiYJx1kqVTu1ujdQ/KST8da5iuCQa3nCmAnnKKGGoqhppXAKHLnKiMBdCkCHcSAa9rWd0Q5FqOq0x+n+TA+Rs8l1qyTCxxKwcV2WN1g6LPVSf2enxoceTNOAds13GkT9KWWXfYH20YivCGEWXpNY+qfv4bklKCBxz4eHsBRxDcFjRaOeudSEHzoQdvg9x88S/sDAo16/5Tynglkw+YvVGSXnTqts90rBPvABZgTA2mPpGgaJsBODNoIVmNYW24RWxVISaBektOicY8oJNWC6FiYlndvE0+l9tTxKCJ9TriqkL987Da+ZlIqCdKyL/Oe5cjFkygLDhrPED6dFkoPmG5I/mb4lzPyXOqvFsAap2YE5uoCSpAO0ymsU2dWwW2fMbYMhT/g
 P1/58/j+
 TmExeof1yp+smirZW8aHmXK5uwPjOi6hkyng2IagToSd4lJL3yEqxfKUVc9svxvsTTTZoQeinLQtryzGgz1LJ7ofJV2zCa4WL4/OVzakP57U8KzPHrgv3fE2VSi7V9PbqL8oMltY5LlMxA9s4+Cf6167JcO0b0/gxGaQtb6S6LOKHHxtFBiLNHOr+ewR/A4dp2FpRGLK4zy4wNBpsCOZDkB43Fb3lliz275EHiVKSNE4u7hYnLN2EqW3LVxO+Q8ijurm3j7kIrmIVB77HkCLGs6DUFluO4pitqEcvSpPuM86WkIXtG8W+HYMxyIffgjQqbDxmN9Zulc0rojp01voLjLVwg+1ciQv1hdoEOK0GIofhfYPorPvAmPbUZjliEwTnqwki
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/30/26 11:07, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>

You should wrap you patch description at 75 columns max.

(Documentation/process/submitting-patches.rst)

> 
> The reason for adding pgoff to ksm_rmap_item has been discussed in previous
> mailing list threads [1][2]. The main purpose is to allow the KSM reverse mapping
> to obtain the original page's linear page index, so that during anon_vma_tree
> travering, it can conditionally locate the VMAs and avoid scanning the entire
> address space [0, ULONG_MAX].

I suggest

"As preparation for KSM rmap optimizations, let's track the original
linear_page_index() of a de-duplicated page in its ksm_rmap_item, so we can
efficiently search for the page in an address space, avoiding scanning the
entire address space. This was previously discussed in [1, 2]."

> 
> To minimize the size impact of adding pgoff to ksm_rmap_item as much as
> possible, a trick that David suggested is to use a UNION that groups the members
> related to the unstable tree together with the newly added linear page index. The
> members that valids only when in unstable tree include oldchecksum and age information.
> However, the function should_skip_rmap_item() in the smart scanning needs slight
> modification, since this function still uses the age information even when the
> rmap_item is in a stable state (the page is not KSM), a situation that occurs
> during COW faults. After using union, the size is still 64 byte without increasing.

And here

"To avoid growing ksm_rmap_item, let's squeeze it into the existing structure by
overlying some members (oldchecksum, age, remaining_skips) that are only
relevant while on the unstable tree. The new entry will only be relevant for
entries in the stable tree.

However, as the age information is read by should_skip_rmap_item() with the
smart-scanning approach even while we have an entry in the stable tree, but the
page changes (no longer a KSM page, for example due to COW), we have to change
the handling there a bit.
"

> 
> We keep the same way to store the pgoff as rmap->anon_vma which is set when the page
> is merged and become a KsmPage at try_to_merge_with_ksm_page(), and reset at
> remove_rmap_item_from_tree() and remove_node_from_stable_tree() and reset when break_cow.
> 

I wonder if "pgoff" is the right term here. Hm. Can we simply shamelessly call
it "linear_page_index" ? (or just index? )

So maybe

"We'll calculate the linear page index in try_to_merge_with_ksm_page(), when
adding it to the stable tree, and reset the index (to reset overlayed data) when
removing an item from the stable tree -- in remove_rmap_item_from_tree(),
remove_node_from_stable_tree() and break_cow()."


That means that age information is reset whenever merging fails. We could try
merging more often. I assume that's nothing we care about in practice. If we
ever do, we can e.g., look into remembering it on the callpath somehow.

But I suspect we don't care.


> To be specially clarified, the reason for resetting pgoff at break_cow() is:

s/pgoff/the stored index/

> 
> - When a page successfully becomes a KSM page (i.e., after stable_tree_append()
>   sets STABLE_FLAG), both anon_vma and vm_pgoff are stored and remain valid.

s/vm_off/the index/

> - However, during the merging process there are several failure paths where a
>   page that was temporarily treated as a KSM page must be reverted back to an

What about:

"However, during the merging process, there are several failure paths where we
already prepared an rmap item to be added to the stable tree, but must revert
that as some part of the merge process failed. Examples include:"

>   anonymous page. Examples include:
>     * The second call to try_to_merge_with_ksm_page() fails in
>       try_to_merge_two_pages().
>     * stable_tree_insert() fails in cmp_and_merge_page().
>   In such cases, break_cow() is invoked to break the COW mapping and discard
>   the KSM state.
> 
> Currently, break_cow() already contains a put_anon_vma(rmap_item->anon_vma)
> to release the reference taken during the aborted merge. Because 'pgoff' is
> logically paired with anon_vma (both are only meaningful when the rmap_item
> is in a stable state), it must also be cleared (or reset) in break_cow() to
> avoid leaving stale pgoff values that could confuse subsequent rmap walks
> or scanning logic.
> 
> [1] https://lore.kernel.org/all/adTPQSb-qSSHviJN@lucifer/
> [2] https://lore.kernel.org/all/202604091806051535BJWZ_FTtdIm3Snk24ei_@zte.com.cn/
> 

[...]

> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> ---
>  mm/ksm.c | 41 ++++++++++++++++++++++++++++++++++-------
>  1 file changed, 34 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 7d5b76478f0b..4761ca3fa984 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -195,22 +195,28 @@ struct ksm_stable_node {
>   * @node: rb node of this rmap_item in the unstable tree
>   * @head: pointer to stable_node heading this list in the stable tree
>   * @hlist: link into hlist of rmap_items hanging off that stable_node
> - * @age: number of scan iterations since creation
> - * @remaining_skips: how many scans to skip
> + * @age: number of scan iterations since creation (unstable node)
> + * @remaining_skips: how many scans to skip (unstable node)
> + * @pgoff: pgoff into @anon_vma where the page is mapped (stable tree)

Is it then "stable node" ?

>   */
>  struct ksm_rmap_item {
>  	struct ksm_rmap_item *rmap_list;
>  	union {
> -		struct anon_vma *anon_vma;	/* when stable */
> +		struct anon_vma *anon_vma;	/* for reverse mapping, when stable */
>  #ifdef CONFIG_NUMA
>  		int nid;		/* when node of unstable tree */
>  #endif
>  	};
>  	struct mm_struct *mm;
>  	unsigned long address;		/* + low bits used for flags below */
> -	unsigned int oldchecksum;	/* when unstable */
> -	rmap_age_t age;
> -	rmap_age_t remaining_skips;
> +	union {
> +		struct {
> +			unsigned int oldchecksum;
> +			rmap_age_t age;
> +			rmap_age_t remaining_skips;
> +		};			/* when unstable */
> +		unsigned long pgoff;		/* for reverse mapping, when stable */

Again, suggesting "index" or "linear_page_index".

> +	};
>  	union {
>  		struct rb_node node;	/* when node of unstable tree */
>  		struct {		/* when listed from stable tree */
> @@ -776,6 +782,10 @@ static struct vm_area_struct *find_mergeable_vma(struct mm_struct *mm,
>  	return vma;
>  }
> 
> +/*
> + * break_cow: actively break the write-protect of the VMA. This is called when

This description is not quite correct. We unshare the KSM page (break cow ->
create an anonymous apge copy). It has nothing to do with VMA write-protection.

"actively break COW, replacing the KSM page by a fresh anonymous page."


> + * rmap_item has not yet become stable, but page has been merged.
> + */
>  static void break_cow(struct ksm_rmap_item *rmap_item)
>  {
>  	struct mm_struct *mm = rmap_item->mm;
> @@ -787,6 +797,8 @@ static void break_cow(struct ksm_rmap_item *rmap_item)
>  	 * to undo, we also need to drop a reference to the anon_vma.
>  	 */
>  	put_anon_vma(rmap_item->anon_vma);
> +	/* Reset pgoff that might overlay age-related information. (still unstable) */
> +	rmap_item->pgoff = 0;
> 
>  	mmap_read_lock(mm);
>  	vma = find_mergeable_vma(mm, addr);
> @@ -899,6 +911,8 @@ static void remove_node_from_stable_tree(struct ksm_stable_node *stable_node)
>  		VM_BUG_ON(stable_node->rmap_hlist_len <= 0);
>  		stable_node->rmap_hlist_len--;
>  		put_anon_vma(rmap_item->anon_vma);
> +		/* Reset pgoff that might overlay age-related information. */
> +		rmap_item->pgoff = 0;
>  		rmap_item->address &= PAGE_MASK;
>  		cond_resched();
>  	}
> @@ -1052,6 +1066,8 @@ static void remove_rmap_item_from_tree(struct ksm_rmap_item *rmap_item)
>  		stable_node->rmap_hlist_len--;
> 
>  		put_anon_vma(rmap_item->anon_vma);
> +		/* Reset pgoff that might overlay age-related information. */
> +		rmap_item->pgoff = 0;
>  		rmap_item->head = NULL;
>  		rmap_item->address &= PAGE_MASK;
> 
> @@ -1598,8 +1614,15 @@ static int try_to_merge_with_ksm_page(struct ksm_rmap_item *rmap_item,
>  	/* Unstable nid is in union with stable anon_vma: remove first */
>  	remove_rmap_item_from_tree(rmap_item);
> 
> -	/* Must get reference to anon_vma while still holding mmap_lock */
> +	/*
> +	 * Must get reference to anon_vma while still holding mmap_lock,

s/,/./

> +	 * We set these two members of stable node here instead of
> +	 * stable_tree_append(), maybe because we don't want to hold
> +	 * mmap_read_lock again. Here mmap_read_lock is already held to
> +	 * find_mergeable_vma before merging.

Is the "maybe" stuff really something we should put into a comment?

What about something like:

"Must can only reference the VMA while still holding the mmap lock, so
reference the anon_vma and calculate the linear page index early, before
stable_tree_append(). If anything goes wrong, break_cow() will clean it up."

> +	 */
>  	rmap_item->anon_vma = vma->anon_vma;
> +	rmap_item->pgoff = linear_page_index(vma, rmap_item->address);
>  	get_anon_vma(vma->anon_vma);
>  out:
>  	mmap_read_unlock(mm);
> @@ -2458,6 +2481,10 @@ static bool should_skip_rmap_item(struct folio *folio,
>  	if (folio_test_ksm(folio))
>  		return false;
> 
> +	/* There is no age information in stable-tree nodes. */

Maybe we can make it clearer here:

"There is no age information in stable-tree nodes. We might end up here without
a KSM page for example after COW."

> +	if (rmap_item->address & STABLE_FLAG)
> +		return false;
> +
>  	age = rmap_item->age;
>  	if (age != U8_MAX)
>  		rmap_item->age++;

I think with these things addressed, this LGTM.

-- 
Cheers,

David

