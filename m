Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70F20C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 06:49:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 204C66B00A8; Wed,  1 Jul 2026 02:49:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DC9C6B00A9; Wed,  1 Jul 2026 02:49:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CD936B00AB; Wed,  1 Jul 2026 02:49:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D4F4C6B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 02:49:50 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5904A120272
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:49:50 +0000 (UTC)
X-FDA: 84939282540.28.2B09A42
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id A6269C0009
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:49:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=moCINWYE;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782888588;
	b=gBHeQ51wj9pMDBwQYskt1b8PmzQJV0n8QbYXuZdYEPOnPqO6DHFzY+SwrVKbHZHCDZhL0N
	RZBnZ7+FM9P66eELHJx8dvtDr9FP135x8BX0SMdXSqHUrGfN/6S0bvKtmgq5DgAdPB1iPW
	MF2ez2EVfoF2jAS67l2B3AVb6mdk72I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782888588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xC9+JzMyt+zCSz/xGYAIKiIKyWm5ghNFZJ8qC7j3AM4=;
	b=1ubHAlNOsia4lKDui+cFBrToGsZghPD0YGl9Z5H18VmnPBLlTVYhTAos62+CGb+WKOZ+5k
	ZZIG0IutDQM/L73hHP7JocOu93GiAaF060VRrT/7ZIuHYLLm7kknc3surDVLXvpNsv/GQV
	jzI5TWwwj75jFFhcjeQI4tWMnxquhi0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=moCINWYE;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 23D5A600AB;
	Wed,  1 Jul 2026 06:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160961F000E9;
	Wed,  1 Jul 2026 06:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782888587;
	bh=xC9+JzMyt+zCSz/xGYAIKiIKyWm5ghNFZJ8qC7j3AM4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=moCINWYEmxsAxlbQgf/gc3oGuBR9eBKA5TEfUFfw5Ib2Pl4VontESgPiolh5KFmTM
	 v5x6RWOoodpceMewT518QewsQB432UO4OXPdwYg57ARP4t5HXJ+hopoDNnzHdS/773
	 QqQIf6OjRbBQWTvG9iHg0Ad1m+nQhSEbLk7/V7vuAq1Eq+5+BTdVQ6UzWOK+MeAYLs
	 8CqkjNAe7i6EpFsYvcB+K3jSr/AUAPs/oLaG6NibspbrRhKHfQiLvCah+jWjk7khEB
	 F+23xG3feH+DQv7Xqdou50satUiZXFy0CfvkbSRfMyUUzt4ACJtAHqS/ggrRb5qilx
	 UkRFcsK6c48/Q==
Message-ID: <1fa509f8-3da7-4c01-94ad-54ea8478f718@kernel.org>
Date: Wed, 1 Jul 2026 08:49:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 9/9] mm/page_owner: use memcg_data snapshot instead of
 PageMemcgKmem() to avoid TOCTOU VM_BUG_ON
Content-Language: en-US
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260701061101.344679-1-ye.liu@linux.dev>
 <20260701061101.344679-10-ye.liu@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260701061101.344679-10-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1p3d8b6nrnnw8sqa1w1495b81pj5esm1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A6269C0009
X-HE-Tag: 1782888588-137549
X-HE-Meta: U2FsdGVkX1/VrWNeTi1Lk3llYg8NVYAn058SBVmQcpCZRe18oNeP9jAPFbpDmXiLzQlYOnT9xNuhnleqKHgcSYegca8Kzy28Fz901t7m8Mf2OnplpdJin3iJjRbQsM2M6vYbw5jspRNlhX6aSOuBW5lKTrAxw3vwIlUB1iM6h9bgw2q1m5Snema5oKNklvXMd8X7cMAONw/Wro3qR81wOvlIw1KsJaGYprUn2C210IPOkWH1/b+BaVL3dkv9/Qab8VKYKQCjF+BGFsUc1Yo+KRCtxb4CFT/urgcF71lhZqA59ht5PDq1cMm1UsqY1D8HGAmhgZPqC+qMWNwNXpGhi8RCJ52GRWKx6XoQgXbdmjQZKrNfspiXfwDl3wfsgRvXPwiez7zrYxfvxphAykwf66Vzi3vkSt1Xxs3LHANoWerOVFKkYsCds7fuOeSn0t+ypcsuMkievVyopiYYoKm29qOLY4ACUbA9mCki3BSC749gXWRXUK0g7aEzRaAfIDb3CzthzEdy0wChC83xZzxDMu3oc9fprUaOrYXSRndVJlE7EGhRWOD6KQLiwAXpORFtiD+AS8yToKhwP5CHQ1n3gi0o6hXMYIdyVBEJtgWss0lZuj765xm3himmdn5iN0hee8D9QgTKWWjMtISOl65ZK/3zjubWVtXD2751Z50gR6zIqCFttzsfhnZqqDQFl8EVhW/sn4L+eGR/+pXfd8mmWL8IuqH6x3gaQGzTBXi/bgzM2XPOxoWYNq8BXNMRjaESITF6NhniwpZG3/Z0uk7vRAFeMd/BB6MR1Xu5G6yKbqwqqOqCqXr5Ysfzr1reMiWEq0G1wQQH61P1eOguaSJY0IbV+fPKqOkyss2WU4/HTMPgshgF0yQVLP05PBccBORtb7T6s2ymo4YAfG4LklCc3a4W5iEB3f1CSSesuvWkMMaO8ym0pkR5GdlECg84GzkomJv0hMqxhvu0jxWwVBz
 c8LnyNIx
 rierQl49r7uD5SBK1sN7eBcQvzV+nWwjHUxzKnMWEfrosUuU2PxZIbiJ1sf0ozZfiWMmpii5DVQk9FZc6LKRvmjJIOne0IZcDUq+CAnxg9UPbtVKWoWbALQxqjvL1RSw+6gPMGU3q0wzCdQg9ezWNA4e31IntOLLGjdKLM0oSjIABS8/mwkOjs8IrfZFwMxKNXHbsHBogMA8MUyrEh8mh98IKIHlZxSBNwc7tkWdHESkKEcStLBXEaRFnVimFDUV9m0W4wrg5z07TKNp0gjIsNs/T1iLxrenU63+S9QzEX+/9SJIDv9ODqsy8aXgJO8sYC8kLq17UtzolNSHV49g5WlBqL+pWZba/8LSn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/1/26 08:10, Ye Liu wrote:
> print_page_owner_memcg() takes a snapshot of page->memcg_data via
> READ_ONCE at the top of the function and guards against tail pages
> and NULL memcg_data.  However, at the end it calls PageMemcgKmem(page)
> which internally calls folio_memcg_kmem() — and that function re-reads
> folio->memcg_data and page->compound_head locklessly, wrapping both
> in VM_BUG_ON assertions:
> 
>     VM_BUG_ON_PGFLAGS(PageTail(&folio->page), &folio->page);
>     VM_BUG_ON_FOLIO(folio->memcg_data & MEMCG_DATA_OBJEXTS, folio);
> 
> If the page is concurrently freed and reallocated as a THP tail page
> or a slab page between the initial guards and this final call, the
> VM_BUG_ON assertions can fire on debug builds (CONFIG_DEBUG_VM=y),
> causing a kernel panic.
> 
> Fix by reusing the memcg_data snapshot already taken at function entry
> instead of calling PageMemcgKmem(), which is semantically equivalent:
> PageMemcgKmem()->folio_memcg_kmem()->folio->memcg_data & MEMCG_DATA_KMEM.
> This avoids both the TOCTOU window and the assertions entirely.
> 
> Signed-off-by: Ye Liu <ye.liu@linux.dev>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/page_owner.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 2e3880053a34..efbf67d54ee2 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -561,7 +561,7 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
>  	cgroup_name(memcg->css.cgroup, name, sizeof(name));
>  	ret += scnprintf(kbuf + ret, count - ret,
>  			"Charged %sto %smemcg %s\n",
> -			PageMemcgKmem(page) ? "(via objcg) " : "",
> +			(memcg_data & MEMCG_DATA_KMEM) ? "(via objcg) " : "",
>  			online ? "" : "offline ",
>  			name);
>  out_unlock:


