Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A4B7C88E70
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 13:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91FC16B0088; Mon, 14 Sep 2026 09:42:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D0706B0095; Mon, 14 Sep 2026 09:42:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E66F6B0096; Mon, 14 Sep 2026 09:42:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 523516B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:42:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D976880141
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:42:48 +0000 (UTC)
X-FDA: 85212483216.24.401D481
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0E8591C000B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:42:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SV6ZPi3Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SV6ZPi3Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789393367;
	b=iYX2xXZAVm8AK6RBTmFCWBcXjoszL+t6hPn2FIuI/BylEWQSnCbaN3FuUC4WfCS8hZHAo/
	MNm13UhUyQU/gLZHyMPcdIqJVk1vF+5nEO4u4Zk/58wM4Wsn9McqwGHM4flf6yJ6CjHgWa
	OJkitoXtOaIfoAoFCETaIS2ZsbmrIJw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789393367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3BCtIVGaFrK84rHYDsXJCu4GU+rN8YV13RCmCsAqNzU=;
	b=NDM4JAUktAy0nZUSxH04GiMcfakMjrT24XtXnuRynQR+wLpSNjc9uodmjNIWPSyzI8+Ai4
	huMVixl0B7OYEdgFpXg2PvSlP0pE11hVRvB5Adh7tOiklBEq4R5JABlrRXNsrbtJdeAIu2
	Ll0aoW1oxZWbKMSD0iN5k7RvlHX0gg0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 37F8C438C2;
	Mon, 14 Sep 2026 13:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687AC1F000FF;
	Mon, 14 Sep 2026 13:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789393366;
	bh=3BCtIVGaFrK84rHYDsXJCu4GU+rN8YV13RCmCsAqNzU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SV6ZPi3QftK0oV2Gw/ZjShiSD8DhHQfnS0q9dpTb9QiYvt8knlldRIQdeORlYRrrH
	 boZVHI4N5aKytFZV8uq7EqXnyyyfM95ebPJhxukUDkylzkw6ofLYO/juXjufbPpmYK
	 brlsiftVFH0HhMWfGUfCbVyWKFZ0Exueq8QT4VFtakdynnCMjtY9TasLlk61qOeRKt
	 O9iOCnUuHZKDOT8EbtECSIeqy3kKzr67nDf6LtjOFphMbAxMmRZ/jz4VbYk7UfVIup
	 yuHDR0oVKXLXHfNPqjJPiDmEh8e+RJagNPHMT6Qu+HKWi2xHvU8lRcBTZj4cip1h5F
	 VsHi7+XTlhBbg==
Message-ID: <7fff15cd-5136-418c-a8a4-b9fe5f30ad81@kernel.org>
Date: Mon, 14 Sep 2026 15:42:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/hugetlb: preserve mremap address delta when
 skipping page tables
To: Jaewook You <jaewook376@gmail.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johan Hovold
 <johan@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260911182408.75821-1-jaewook376@gmail.com>
 <20260914132352.472-1-jaewook376@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260914132352.472-1-jaewook376@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E8591C000B
X-Stat-Signature: tioypxfc9cxu18moa8fwgfynqjayk1kh
X-Rspamd-Server: rspam01
X-HE-Tag: 1789393366-897014
X-HE-Meta: U2FsdGVkX1924Vcu1/zqbUvl2OZRzfRi5SCJ7kMySD7L7XuljX4/Yd31goWGF7GhMtKd2mq/cF+SRurYC5480JuMJzaH17IJTpoSlAC4li4/joNKShs1FSbUogb35DKgFp1BcDKuqu1H1tkh5d+tqTxpdB9QvvqG6UNNBr8fAeQ0vyr6Qv776oQzOWQFv3J//w9DJ3g2r+BQsrvcBB49k9omCwlGFkQKl//PnGI+reAya0ZuQ4j8xc7skhrH2V7dMVHvf/MmB4nJEEzSISHsmiy7/Gp6CeWuAALG2stYAwhVSfSZJFVzC9duo15Nm2td+sK1qPgMrLWJ0LKuSxrzPWRuFHZgSV0OYvay7FvlL0t/BiHpy6x7SUhcqv6Nnd1ZcCnX6UGv+GoG5qLXT/Pc5Iz+3hygVPR8w6XFr8tR7eOrxh0Ejn7X05kpDBvZptjkfODSUKNPpnXUdedtktfoi7Su3T6fDHQ0LNQrkXXQ6DCmvDwBxD+CD2buQoOLVRViete0haKWUP0TyGnOOj1h20vokFWBUtdxiy5ernknHrHUj/zZHFN5avDmkiSx/RuVNjZByz6RexHzHz2CgfhcUW0A/8qLNMYiJlpq1ntuOWkdsN3DT0AKixJsb/XDmb+4xyOk9bUB7qt6y/+L549qRuqfTqOVcYAR+9GcHHaPm5CCE50RHIQvtQUXOzhMZDKXoQ7JLoEv6D34Gc1oTKIc29dS8a+d7sHPPQiHZ2wDF2/XTSkhVYf/pKPMdxnw9qpJUV6YQUhBzlqOMYFhnm7+jBvceZuTrqVT9a/PP6y6AkuF1tZ6KKwW9PePIozvRkLjZdaGWU8dzy4K6iW1+GsmQu2tXFJP78N0prMs57fltAmcue1eN4JWwpmzX1+KoZe/5L++EX6oQzdXeULw+XYcrCIBh2mwfXIjzhx6Np0roAcVDW7iKEvPY02I1cQyzZviZzZRgkAFyOGl5TGlM2O
 TZcxyeRw
 +bX/q65NOzfwcTPwke9+zIi8mf/nF/8LJbllWoYvHtzZzj0Ki6OZ65fV4ZFDEjNogBLWsN7sILMTKwyA5kIoehiMtZRjzBJYKtIT62zFMwuSLKoN5C0WMYJLC/jr6KTgqSDCeM8L6vgKl6OHcU/pQGXauVG35tnq4X4xlgJE6OdtbppjXCZ+TytFMwV6FQ1in+3x3GdSH3DPF81bU9uPll/E3txkzwUAjvfJu36jCXydiMjxkTXgWbmJN27aV79Trhppm8hLxcE9XGnM4+I0/mdoXbYnAyzAJON086L/GLhNbPa/xzKSo3woYKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 15:23, Jaewook You wrote:
> move_hugetlb_page_tables() optimizes mremap() by advancing to the last
> entry in the page table when the source page table does not exist, either
> initially or after unsharing a PMD table.  The common loop increment then
> steps to the first entry in the next page table.
> 
> However, the code advances both the source and destination addresses to
> the last entries in their respective page tables, which is wrong.  The
> destination address must be advanced only by the same amount as the source
> address.
> 
> If the source and destination offsets within their page tables differ, the
> destination address can be advanced too far, causing follow-up issues.  Fix
> this by advancing the destination address by the source advance distance.
> 
> With a reproducer, we were able to trigger a kernel panic on x86-64.  With
> this fix in place, we can no longer reproduce the issue.
> 
> Fixes: e95a9851787b ("hugetlb: skip to end of PT page mapping when pte not present")
> Fixes: 4ddb4d91b82f ("hugetlb: do not update address in huge_pmd_unshare")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Jaewook You <jaewook376@gmail.com>
> ---
> Changes in v3:
> - Clarify that the optimization advances to the last entry in the current
>   page table before the common loop increment steps to the next entry.
> - Rename remaining_size to offset_to_last_entry as suggested by David.
> 
> v2: https://lore.kernel.org/20260911182408.75821-1-jaewook376@gmail.com/
> 

v2 does not exist publicly ;)

This would have been better send as a v1 upstream (I mentioned this in private
but you might have missed it).

>  mm/hugetlb.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 4f6f58bf3db6c..5749f6270fb1f 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5161,18 +5161,21 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
>  	hugetlb_vma_lock_write(vma);
>  	i_mmap_lock_write(mapping);
>  	for (; old_addr < old_end; old_addr += sz, new_addr += sz) {
> +		const unsigned long offset_to_last_entry =
> +			(old_addr | last_addr_mask) - old_addr;
> +
>  		src_pte = hugetlb_walk(vma, old_addr, sz);
>  		if (!src_pte) {
> -			old_addr |= last_addr_mask;
> -			new_addr |= last_addr_mask;
> +			old_addr += offset_to_last_entry;
> +			new_addr += offset_to_last_entry;
>  			continue;
>  		}
>  		if (huge_pte_none(huge_ptep_get(mm, old_addr, src_pte)))
>  			continue;
>  
>  		if (huge_pmd_unshare(&tlb, vma, old_addr, src_pte)) {
> -			old_addr |= last_addr_mask;
> -			new_addr |= last_addr_mask;
> +			old_addr += offset_to_last_entry;
> +			new_addr += offset_to_last_entry;
>  			continue;

As Oscar expressed, he might prefer some comment about the situation. But maybe
that can be deferred to some proper cleanups here.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

