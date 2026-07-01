Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66E84C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 13:45:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B8D16B00A9; Wed,  1 Jul 2026 09:45:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46AA86B00AB; Wed,  1 Jul 2026 09:45:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35A8B6B00AC; Wed,  1 Jul 2026 09:45:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 07B906B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:45:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 63C17120259
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:45:09 +0000 (UTC)
X-FDA: 84940329138.15.49438A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9D8AD140007
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:45:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BuJ9TuFR;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782913507;
	b=6osXkJuWLd0VcHmwALBfLpnV8GD/FLfyYdLgPzKmHymKL31Tdf1xx2mivfu07MguUKo9hy
	0N4ZBnTzkShH1vJO0Qkc97FObq54+qWfer778dA/4CNtDDhoVpfIKYddZighWgZeeyafmp
	8m9aLn1fodDTL8b7v5+OwRWCnuq+v2E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782913507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5HIMt8vd/cSScdTbWcHyMdsr8orHlxMIASQqoZMTnhY=;
	b=SuLSshZqRchaoqYn0sYlCGUYimH0WQkyqbhWupkEXXtzmwee9nMKte8zK1cywHzzHWbOiA
	ogQvGCNQmp0HmjYosaJV9YBsf8TIRQFdWX73UpdIDnIFKPOp8Wlr/qR1+KAgwvWfvEPSo6
	6i3zqTgLJnFm7jXcH4RLE3WeA32oUdk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BuJ9TuFR;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 036F460122;
	Wed,  1 Jul 2026 13:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6847D1F000E9;
	Wed,  1 Jul 2026 13:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782913506;
	bh=5HIMt8vd/cSScdTbWcHyMdsr8orHlxMIASQqoZMTnhY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BuJ9TuFROTgJKp0cHyweUaF/pssBDFAWlmUCBn+T5GRqW96S8jUzGmJ/yOyjZcLAC
	 Z2jOmAl//qkcaIsojP7ECRoMHSIOaloSBEscEwzPyrxgWephEYnTSbQ+wDA3kVhwcY
	 3Z/BBtTPgM9GtqTUw57m3I3o57rQsHnXuzduMfQp6JtrlI58/41OPPluj9rAUDT1eN
	 f4kFuKzZ7/Gf72HajoqaadIsCCt856ZU04gUoYXr63HU022dDytHddW/5AyUxsiyW+
	 U+ma1UyPi98+BVzHTZ11mIea6gjTRZMZ5Yvltsc3Nt2+27lZKyOagxqg8R72GalXKy
	 zOwNWoNegLf+w==
Message-ID: <5efb2e20-e4fc-4e04-a771-532cb393e46a@kernel.org>
Date: Wed, 1 Jul 2026 15:45:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm: page_alloc: __GFP_FS lockdep annotation for
 direct compaction
Content-Language: en-US
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260626182215.1107966-1-hannes@cmpxchg.org>
 <20260626182215.1107966-2-hannes@cmpxchg.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260626182215.1107966-2-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: iuom9z3isoufy6r1tw6qpusznpgenax3
X-Rspamd-Queue-Id: 9D8AD140007
X-Rspamd-Server: rspam06
X-HE-Tag: 1782913507-181699
X-HE-Meta: U2FsdGVkX1/0tzKvLAtHdoQkyZWVJvH4T1+6vHwSlrL+obfdxSDokywapyyy87onnduMIsQ9KGqH6ynsSzY7EQqmLwE0GVHqWLF7IAxG/WM3epaMpAX2h3NFB2ItLnZcGWyl9o2NQdQXhXHcOzL2KrtdLBB6NH5oOhy8s6Q7zUTonlkcbn48Rx6orkQJdHsT6sN6QkeOz5XIV5Jg/VvOuExBjelq6Rmfrds8fBA3IkM9xGpIwR8TGcNHZBv1pZcV7mcPZI90k5fAHQ6tEOIKJ6EQC7ps5MqwtJlX+czQqQkR3OonNJu057GQhrX5WldDPskzE5op9i5WPx7NS9k4Tbe6X24pOFOvg5QwcyuBYk8l97T9++kz11h5qgObDL/iZGYuWPIllPDkn98F93K4sVtc1z0/p2FeSc6/QCvmtv9S5i3H1YxC3//bWQLQ+18T88Y7qEmHgfSuOmQ+I5qTAVN7Qu4bfcUh0k7q5zKorh7sQIIvqK0tNez7dZ6qCCGbdBkWF6gAnr9W5FUF+8AW3bFSYm1JeM/LMeGHD4NvDmPNENELVjYPCYQHbSA7U3uxBLuQA23tP3wF6Gh7Qfzzb027VzCpAcdin24rrpiYh13bHbP5vYEhxFGGnqEku+yKaijCh0c5K9KZ7W7xXYMXSNrXiv2uf6Xyt68WLh4neKJBAW1VoMs8AZhoc6QYAJg7BMpbz/rlO+R5JCoYNm2tdzbL9fhPfUdFPQslsShwyKu1DmISSr3Vd6Q0JEJ4rH/LpRw1uDvVfXnw4C+6tvC9+K0F1Ux3rW4M8BJX0A4I0BrVuJ/QTLc0rE6cRqGpoxOVtj3TPembe5/JY2uUqSKaoKMBi+psWvzFw7DaApIqvuW72oXcMNMVVfjC4mhBYnyZskfyp+XKkDMhBqR6wuGDahpHbp9ECgplLUhzWcDbmTUlcXwvsPBROwS9nlnZ9DSDRnkMMRI65QUpGlPEFLj
 xR0UnzVR
 kWpFA96AK4r3nOJ5pwW6M1I0RejPsPbq/10cEb+xaAVMwXA80k7GKRuhOw3AgLSWnMy860nIDCwlHg/qY5cTVQHTzIjTS+SMwKSi2f9tDcJAUKt5APUSy1AEefXLnrqZUacISFDYnb/PkbLKZcX9HKHn0RUmHsgu1W8ytLDMyunVFwUpHRbFMpJ3fHkgIw1OhlISFeV0MZSw3rccruf/r/x4356uMtl/eYP9nq/ptPqvGevVlFnb6u8bYzOBHsB9+Q1L4D3WxpUkzt4dbg6yhXmnV41wrAC4ozKb9ODt0F8rsU9vCkwwXb3QqwjZtae//CwZiZMgsdAS1ZMsNXrAy8FJdvdnnYByiMGFAhXCUeIKkspczO3CvpoxWrogXd6s7cTPw4QIvPril0qM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/26/26 20:21, Johannes Weiner wrote:
> A subsequent patch will have some order-0 allocations participate in
> compaction under defrag_mode, to stave off extfrag events.
> 
> Since this is a sprawling expansion of entry points, and compaction
> can enter filesystem paths, add lockdep annotations that catches
> __GFP_FS passing errors.
> 
> Direct reclaim has had this annotation for a while, and since reclaim
> and compaction are usually used in conjunction, this is unlikely to
> unearth old bugs. It's more about future proofing and peace of mind.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/page_alloc.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ee902a468c2f..cb422505c6ef 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4152,12 +4152,14 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
>  
>  	psi_memstall_enter(&pflags);
>  	delayacct_compact_start();
> +	fs_reclaim_acquire(gfp_mask);
>  	noreclaim_flag = memalloc_noreclaim_save();
>  
>  	*compact_result = try_to_compact_pages(gfp_mask, order, alloc_flags, ac,
>  								prio, &page);
>  
>  	memalloc_noreclaim_restore(noreclaim_flag);
> +	fs_reclaim_release(gfp_mask);
>  	psi_memstall_leave(&pflags);
>  	delayacct_compact_end();
>  


