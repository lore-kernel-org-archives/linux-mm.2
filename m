Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B12DC53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 13:54:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94CE96B00A0; Mon, 27 Jul 2026 09:54:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FDAB6B00A9; Mon, 27 Jul 2026 09:54:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C8596B00AA; Mon, 27 Jul 2026 09:54:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 499576B00A0
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:54:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C74D31606ED
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:54:56 +0000 (UTC)
X-FDA: 85034702592.17.51B3851
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 04E1E160008
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:54:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NIP5nUV3;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785160495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RtGAuL9EFyUfYnUH+07v8KujAvAIXlWdvdSfgMEdxnc=;
	b=wGjh8o3waPReM8tFoYoh3ER3sQizllCESSSK2gquiD1PbH+54XZiJGtr7DzdwJOg9im4Vw
	ykBnAOdiE2AswcsOl0xroi/JWMMx7ZEqQPHBw2y3XFXlxuzIVtlJzAS5S/n93rPOa/bdTS
	D6gkUtueLTndtP2sfj6OVKi/uVwP6TA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785160495;
	b=QAAHhaVJA1BELiGznh+9ijM7dhHbUQl0pVcfRxty8JghuQKCWhmPKk2JgMfgyWTiLEWZpE
	p+OfiOy+OZd8TpmbU+6FI6HMwiuCieYMkeVnnABNS74udPcW8kEV/ufdaxF3LjuULTyTy5
	qStqrXg4027j6v7NHcMuHgwGxf3+rt4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NIP5nUV3;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 436DD400AE;
	Mon, 27 Jul 2026 13:54:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA951F000E9;
	Mon, 27 Jul 2026 13:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785160494;
	bh=RtGAuL9EFyUfYnUH+07v8KujAvAIXlWdvdSfgMEdxnc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NIP5nUV3nK3lrvj2WL/Fn9YryLQ0t/Bv28FP7mMK02yui4cJROgdxG4swizF9WVo7
	 a8om1CK0lnRaW6T612onJZaAYNoUOtpHxMOivxD2AVueBDDVW3BEnqCCjmOU9htPqh
	 CeG4j2Ur1813fe9J080QnrmR+Y3NXB5+9ixGjuDDPkHCjjyDIISqPJducWKxQVf7sq
	 u6q+98sJzCny2XYy7kdbXLB6L6TZ7OScfn3ofvwXKIFwBFvF8tK0PkZ9m8XvCQ7PP8
	 a/AbT0jl4//E5l+PXk4Sa11nqFyYIFTSehx1bEBHULuKbhUyej4HwUOgrbOkC1Elht
	 rr2OURsPb/SpA==
Message-ID: <5490f8b1-d611-4e4d-bd8b-19c0e05698a3@kernel.org>
Date: Mon, 27 Jul 2026 15:54:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 11/12] mm/gup: batch contiguous PTE-mapped large
 folios in follow_page_mask()
To: Rik van Riel <riel@surriel.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>
References: <20260724222934.1463812-1-riel@surriel.com>
 <20260724222934.1463812-12-riel@surriel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260724222934.1463812-12-riel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 04E1E160008
X-Stat-Signature: snbh5tfuw8rnedia7bch5mr66r77ngwz
X-Rspam-User: 
X-HE-Tag: 1785160494-584600
X-HE-Meta: U2FsdGVkX19qoGF8D1rYm6HuL5Cj6SOCFHF6IHo7EfXL2ebtMaYQHdyBatHjfEuMvs7UHoqG0d43utCJ2ReapmkY2C7uo9f+jgUI1Zo7lkJS1Hu4wa2U5BUJ/TezuiGxrNIW9kR5G6q/mCpZhA3Wi1jMO87APYeW5DbusuJgv9qnIFGtH9gPK5G5aNDiJXy0CMe7dxv5yrqze4KURgC1ivAWv3fpGjPSjf8HZ3aS79vrmZPwMGiZjlNoRVrYPDItVJGdKpwiK/78xQ/Mn4hdze7adQkQM2/6EX3ZsXeLkr6gE6DNuWueEgk7RIcsc3L66Mm3JO7qEmwJeub6Ee1WqHUiDUU6GAy+bJgxsFMrn3v80Zp+DjLFhBcDTGWjYSECLcU8fpf+2yyV88OjQzue3RIMjrZDBppZWltVRbxTJvLeuVzYljev9PydXZ0OqgD/fKSxCDxDDu711T/XrI+Y/v2L8Rn4JPJsZOZ96reKzFW4Qiss1yzHvoO9h/M33TbcDem0b8PndXZVoI05hbWMoFIvaVB1QaKwFThZGq8PL90SOcGxDMiS06FWXQPD2r6jXC8DOa2tJ8RYCqHbr2Po19hFwRr4wqy3AbVg6Xof4IBJdFgQmwuFFvAXD7Yqui0us8bUcnSwrL5J1OYmsUamcYMCHTPTQSyERwE7wCLpGXfPtr+OOzGpQBJifFrMDD+LxPuxVnbzE6M1Q4nsAez6/23WqBThhQk5CIzdV65VIxlT3ASVKrIUzzFMH79YG3wEs2EqYrkI4LWBOhyRMy3NJDBU4rZhZYW+SWWUmjKZqYScUUdaTEPlqrN7eP0/Xjmn/h9FSAqV1+WfO4JJ2Hyr/P+34A9Fz6PeMRoX/hsyTZhc17+NmFyHH2IO9HQ54lyi85eiFRg1tn8EjfazztAX5tDyVNDno+eI8VJ2hk76rGV6XZ30YU5w2Rp2ADzlL1ypgrxO12tjyzLaDqiF2EZ
 /6KVkGLg
 B5Iev4eOU4tNY2HmcVlsgPo6ka5FfQuKGW7rgv0yWfliXqoNh592muQL34znkVRLHl9WxYhG2K7m3hjLCZJXd+N7NbhsU/V8SD9xeIi+AebVEHm7sWY8ADIcqbJYdkdZ/qNH1WeT+nTRpwLWXBvFUcdEY6Tnsy1zgwNeXuUoeQqlFJORmUg/D9LxLyCQrKQCCwyWrG9thLx9uKdQW4evVEG9sRS3xzCjSXsli/AUU/kRZI4v9ZBtDXlGiPdepb551FuaJzGNdSxOrKdz4EDwEsApsa4Dg8YfRgmxula9o/7N7enROjaEkGoqh7CV/NAlUitSjAv4Bhn6/eQM3rxZMKLYkf4u16yepVlSPZat3IAtjLZs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/25/26 00:29, Rik van Riel wrote:
> follow_page_mask() returns one page per call for a PTE-mapped large folio,
> so __get_user_pages() re-walks the page tables for every page of an mTHP
> even though the folio maps a contiguous run. The huge PMD and PUD paths
> already return the whole mapping in one step.
> 
> Report the contiguous run for the PTE case too. follow_pte_batch() uses
> folio_pte_batch_flags() to count consecutive present PTEs that map
> consecutive pages of the same folio with a uniform write bit, bounded by
> the page table, @end, the VMA, and the folio itself.
> 
> Keep the per-PTE guarantees that follow_page_pte() makes for the head page.
> folio_pte_batch_flags() with FPB_RESPECT_WRITE stops the run at a change in
> the write bit, so the whole run matches the head.
> 
> A writable run is safe for any access: a writable anon page is exclusive,
> so gup_must_unshare() cannot fire, and FOLL_WRITE is satisfied.
> 
> A read-only run is batched only for a plain read, since FOLL_WRITE would
> need a COW fault per page and FOLL_PIN would need a per-page
> gup_must_unshare() check.
> 
> Measured with mm/gup_test.c (PIN_LONGTERM_BENCHMARK, the slow
> pin_user_pages() path) on a 256 MB MADV_HUGEPAGE anonymous region in a
> 4 CPU VM, median get time over 16 iterations. Each folio size was confirmed
> through the per-size anon_fault_alloc counters (4096 folios for 64 kB, 128
> for 2 MB):
> 
>   gup_test -L -m 256 -n 65536 -r 16 -t
>                         before      after
>   64 kB mTHP            3140 us      412 us   (7.6x)
>   2 MB THP (control)      78 us       76 us
>   4 kB base (control)   3010 us     3042 us
> 
> The PMD-mapped 2 MB THP already returns the whole mapping in one step, so
> it stays fast and unchanged. The 4 kB baseline shows the per-page walk cost
> that the 64 kB case paid before this change; only the PTE-mapped large
> folio case improves.
> 
> Assisted-by: Claude:claude-opus-4.8
> Signed-off-by: Rik van Riel <riel@surriel.com>

Why is this patch part of this patch set?

This makes perfect sense independently, no?

-- 
Cheers,

David

