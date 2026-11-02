Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A6F160A383A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 12:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MMPJjA4n
Received: by kanga.kvack.org (Postfix)
	id 949DA6B00EF; Mon,  2 Nov 2026 07:49:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FB036B05B1; Mon,  2 Nov 2026 07:49:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E95A6B05B2; Mon,  2 Nov 2026 07:49:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B3026B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:49:10 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D211E40D01
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:49:09 +0000 (UTC)
X-FDA: 85390159218.17.B27DF36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0BA97140008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:49:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MMPJjA4n;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793623748;
	b=jvj4ufD2MTsZRp23qO9KjM17IVados98ZNNWe5UGLcq/aQ+dXQnGa8taBShosNXmEmNOkK
	W72cHf14BOMxhWlc++eQZw/SW6xbHupzfct2EfB0XbUZX5dV2GAzJyMbizRu+QfiW7tmNt
	Jv6P08YoRg23zIMWV48njonIPU1713Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MMPJjA4n;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793623748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yJLZmPBZv+CycFtwzr5pSIbvk5UEpxdi0CgzoRsWvzw=;
	b=xpw7hFYBD17y/8KWEGU4k4onHGUtrIIXcFyaD6sNUUOyuV4DSy69pfayrKxM3aIRECQkXB
	MZ7k1qUSqznUjI6zsGnxxX6qIvHnVbp995GK8Tr6Y73mgwzLqkJtpYQGgfYTC+zDy3lPFN
	vDIt89YgqwZ14ot8twnV+hQKsjW7xes=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0EC2D402E6;
	Mon,  2 Nov 2026 12:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C4F1F00A16;
	Mon,  2 Nov 2026 12:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793623747;
	bh=yJLZmPBZv+CycFtwzr5pSIbvk5UEpxdi0CgzoRsWvzw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MMPJjA4na183XXSB/egQ9V5ON4+8CaoBH9DPVdEWUHbIAMBb04H9NjYoh9ROfyUbn
	 3pxOf7dLjNDEHak6Ud5YERJgeEe5E9Qf6D6/drb9lpM+YqWN0nPKhpZ81h1/DSCxrM
	 kyCVvJO4dp130ffKnTQDY6VKVTmASgwZw535cMSHQltvaTEMqXeclFU1VczrKrOf8r
	 pOrZd/Ui6t37y6G/6TmpRitEfUg9mNGuxA4kTijCkQgBYqQDYhBSFfksoo7ufUVBfQ
	 65L5YXuwcPAK9CLNF2gIJx2KZmh4+OAevQcAA5Mnd1bLaKSdC158CDdWNrITIDb2Rj
	 ojzlCG5UIafdw==
Message-ID: <54e20549-ca49-4d86-90fd-9f5e483d362d@kernel.org>
Date: Mon, 2 Nov 2026 13:49:02 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/ksm: avoid unsafe anon rmap dereference in KSM merge
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Xu Xin <xu.xin@linux.dev>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Zhao Gongyi <zhaogongyi@bytedance.com>
References: <20261102-ksm-anon-rmap-fix-v1-1-68962acfb59b@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261102-ksm-anon-rmap-fix-v1-1-68962acfb59b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qin5zmfg6rqugobmge7zdhmcnxugmepm
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0BA97140008
X-Rspam-User: 
X-HE-Tag: 1793623747-91861
X-HE-Meta: U2FsdGVkX1+PBDAmKtwNijF/58rCEyGESAFcKjy0Rx5fMNG6TyXMS36mGiE7uxAX28M/wkGgIAUEqwJFXB4ydaCrsJeHJ8WdOuRp4Q1FpAQwhLQ8tkikWTEowhDQGw4498XMwib027Ivc1Upcgj5ocdVQn2jwxmYvgggiyzx7SY6ORiv4Aclq+863kz1ltQvPxojbu5756rgYi5JKOhzwSIG+h7k+cjrrIY5C70KTVyKh3zHp2UDIbdJ9b+9X/7+P69RrOrIY3QYcQrCzj81V8WOOWDh+6e5gspf5jpJ5/h/Bl7Sbz4TYmCkoWYExbOQf4uF3T5TJFZSUrxyAySKbzH8II7wXSrzC4uWdleCqak6KByOOtUL+0aiwoOhmjv1It4VeWVX/FHZYmV0hC/TlYW4n1I+AH+lbRuCdamtmic7VO84JNsjdVgqqqP0MR9z75MBPz9o6izebSElouuiY1emHFT6ZG/KFjm1OwLrx6xH8MlhAm9np0F5mZ+6v25j3p1upTjiRZ/7HQsMotaWXois49d78yu0Vli0mg02knfQBt8ZMp/VkTDnSVXwfc4apgGrlwWMqCG+ydhx5Z1vI07DXfzp74zJWvbrIDrM0H1W3xYYIdddbbLLTJAj046TB6SHtRvKGEZ8KtAQTu1URmCBvmtG7N2X+nv+JdsV/Jt6t0Z2ljrCHAdp+yQxPU/LafdelfdQ4evLWQn1pWmIp158d022LCGZx6snrQMjtnZSwuroikD+6pJQVNVdb2aMo9yOO7oprYucMx0g90kE/8ZNGQX1KjK8zodeNCcSibPLxeX9TrEnI/liGozDODb68CZC5KPTjnOYRM+xjpWxObxZfwVBw35NiVk4xOO+RC8uPvr6atXWa2nPzzpwYvODbXUU/F2w1tDwlps6KdazagsBjz36hhPHqmSK9ae+Ch9KvLRADCPnY650KYT1oS9gPE22oI497BfYqWMqPrN
 cxC4fv4L
 LUyZJSJ8JKiSfRsU7EAMMCPHN3gWK0ZSfKtXLO5Qmo8PssDs2C3XaJhSuX76WAwbjP37v80okNUE5xXRtipkaHJjmInDmNT6Vt+7mEhu1CV7+IbkK1L7cH4GGmRhnDzsiqqwq2+LaiuDFpTp3W9oRgFenEiPt4iucH8L0/xl196kW0wS1EVKWpqKiHPcUK5piktHmChtQojiHAbkmE7FFaxTYaHdOAl79I6NThwV8Bl8MwdRGx9WQDnh8FiELGw62F3j16G5vY6KxVmLFrOvUuHRcUJWFBjMRVB58sKpylvVcODpKrLrA9F8IPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/2/26 13:32, Lorenzo Stoakes (ARM) wrote:
> When KSM examines candidate VMAs in scan_get_next_rmap_item(), it
> accumulates (mm, address) pairs in ksm_rmap_item objects, assigning them
> via get_next_rmap_item(), pinning folios via a page walk in
> ksm_next_page_pmd_entry().
> 
> Throughout this operation, scan_get_next_rmap_item() holds mmap read lock,
> which it drops afterwards.
> 
> After the mmap lock is dropped the VMAs might be freed and remapped where
> the VMA belonging to the folio was previously mapped.
> 
> mremap()'s ability to change where anon folios are mapped is dealt with by
> KSM by essentially avoiding the problem - prep_move_vma() unshares KSM
> folios, and the scanning logic is tolerant of concurrent remaps, discarding
> stale ksm_rmap_item objects and allocating new ones at the new address.
> 
> This doesn't account for a new VMA being mapped over an old one where a
> folio was previously mapped, so KSM accounts for this by checking things at
> the page table level.
> 
> However, once an anon_vma's reference count reaches zero, it is freed, but
> nothing clears folio->mapping, which is where the KSM pin interacts badly
> with the current KSM implementation.
> 
> page_address_in_vma() is consistently used to look up the folio's address,
> but page_address_in_vma() explicitly states:
> 
> "It is the caller's responsibility to check the page is actually within the
> VMA."
> 
> And KSM violates this, as it cannot know this to be true. This results in
> this function performing a use-after-free:
> 
> 		struct anon_vma *anon_vma = folio_anon_vma(folio);
> 
> 		...
> 
> 		if (!vma_has_anon_rmap(vma) || !anon_vma ||
> 		    vma->anon_vma->root != anon_vma->root)
> 			return -EFAULT;
> 
> As anon_vma->root is dereferenced when anon_vma can already have been
> freed.
> 
> This is currently benign in practice, as anon_vma's are slab-allocated
> objects so this will always be within the direct mapping and arbitrary
> memory will be treated as if it were a pointer to be compared.
> 
> This either results in an -EFAULT or a spurious match, which will be
> rejected at the page table level.
> 
> However we mustn't UAF even if it's harmless, and KASAN rightly flags this.
> 
> It turns out we don't even need to use page_address_in_vma() as we already
> know the folio's address, it simply needs to be passed through.
> 
> This change therefore updates KSM to do this, sidestepping the issue
> altogether.
> 
> Explicitly check for KSM folios in try_to_merge_one_page(), which are
> already merged, and by definition never have an anon_vma.
> 
> This was previously handled implicitly by page_address_in_vma() as
> folio_anon_vma() returns NULL for those.
> 
> In many cases cmp_and_merge_page() will reject these, but it's possible for
> KSM folios to fall into the unstable tree there, so eliminate that
> possibility by checking for that early.
> 
> This maintains existing behaviour.
> 
> The bug was introduced by commit 21d0d443cdc1 ("rmap: resurrect
> page_address_in_vma anon_vma check") which first dereferenced
> folio->mapping unsafely, but commit b8c8ba73c68b ("slub: Introduce
> CONFIG_SLUB_RCU_DEBUG") made it visible with CONFIG_SLUB_RCU_DEBUG enabled.
> 
> Fixes: 21d0d443cdc1 ("rmap: resurrect page_address_in_vma anon_vma check")
> Reported-by: Zhao Gongyi <zhaogongyi@bytedance.com>
> Closes: https://lore.kernel.org/all/20261031182256.40205-1-zhaogongyi@bytedance.com/
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
> David - this seems benign in practice, so I'm not sure whether a backport
> is required here.

Ok, thanks. Is there a similar problem as with the other anon_vma->root issue
where a false positive match could be problematic?

I suspect not.

In that case I would pick this for the next merge window after a couple of days.

[...]

>  {
>  	struct folio *folio = page_folio(page);
>  	pte_t orig_pte = __pte(0);
> @@ -1515,7 +1507,7 @@ static int try_to_merge_one_page(struct vm_area_struct *vma,
>  	if (page == kpage)			/* ksm page forked */
>  		return 0;
>  
> -	if (!folio_test_anon(folio))
> +	if (!folio_test_anon(folio) || folio_test_ksm(folio))
>  		goto out;
Okay, that makes sense. We don't have to check under the folio lock as KSM
doesn't merge concurrently.

Do we want to assert in write_protect_page() that we are not getting called with
a KSM folio, similar to what we do with large folios in there?

-- 
Cheers,

David

