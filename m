Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C23A7606A32C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IEjH+kwe
Received: by kanga.kvack.org (Postfix)
	id ECC686B05C6; Tue,  3 Nov 2026 03:35:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA4066B05C7; Tue,  3 Nov 2026 03:35:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB9FF6B05C8; Tue,  3 Nov 2026 03:35:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B8B4B6B05C6
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:35:45 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D5ABDC035E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:35:44 +0000 (UTC)
X-FDA: 85393149408.02.2F7BAC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0147E40005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:35:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IEjH+kwe;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793694943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xLSzO9iZJW/dawul74UtMkV0+UbbhY7vlsAzsGmNnjM=;
	b=gekmUHmFzSRXbfPxdorfrHAfIJ0CspLwNrWyyFW/oYkvb736yCzGb7UEXaJPmkG2pN3O7D
	CUFic1YHPRXcTmztOdye1eNcYpbpJqXzy8GzhXgvbsm2XhYFw9N5tgtYMbo5LWLQTK4fc2
	fWNaF+daxMeFHgveQJjhCPSMXfqI2pY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793694943;
	b=E3daPgQ6uKY7u3rv0zZHAEg9UVPm4KgvuRX7lMFTZ0TzKmrNPgpbnjW8KdBgzGhd6+10Zz
	DjS+OXMfyFYHqU82cHdNuvFFAMKIw7ZxStbXSklkPu99EknjfUVu7z1IE4mx/wLM72Uze3
	A231qoQZQXIjBBBbOy5+142wbJpelF8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IEjH+kwe;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 52760402A2;
	Tue,  3 Nov 2026 08:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B011F00919;
	Tue,  3 Nov 2026 08:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793694942;
	bh=xLSzO9iZJW/dawul74UtMkV0+UbbhY7vlsAzsGmNnjM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IEjH+kweDnrDGMvGvPfuOOsJDJfRm7la8rOgwBQPs6ZW4p+I1DS7AWtD3F9EkMAAa
	 hO8KIzaeggQQZ9rhJXPUopHBi+oH/FcU21xL88tsCOn2hTaef2b3wIhOGoxvcv4T2s
	 hxu1FmnrQfImqYACRzwXZSdMlw2y3MZ41Vbx4U/8Bcw2Brp2ziuwZxxdbFSHxVPJJ5
	 /IlRtQwHMcBihXeJ1bgeDmAGLOIN+ZLnR79gxtMJK8YU7oDb0XxEU+J+Hw0ECEU412
	 oRiuW27VbE3Jgh+AD/cXh/EMdfTVI5yxRIRxYONSRqomWEaklTiPkntzTzoKdRpzkm
	 fqRnREjbmQKnA==
Message-ID: <fa017227-448b-468f-9797-33c02854f018@kernel.org>
Date: Tue, 3 Nov 2026 09:35:35 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] mm/gup: batch contiguous same-folio PTEs into one
 refcount grab
To: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
 Yuan-Hao Hsu <aa9736195201@gmail.com>, Christoph Hellwig
 <hch@infradead.org>, linux-mm@kvack.org
References: <20261102193026.3860700-1-riel@surriel.com>
 <20261102193026.3860700-9-riel@surriel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261102193026.3860700-9-riel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: ir4cz9k1tm6mf11qbxmo55f86mhy96fy
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 0147E40005
X-Rspam-User: 
X-HE-Tag: 1793694942-605170
X-HE-Meta: U2FsdGVkX1+jUkm+aPx7vohW2/orO3FAWYsZEijWMVK9D7jUFiwM7dn+rqRX9dReyo5PKY20AeuX5Vfer2v9oLm9HE06OQxbuWGpwaxspkNI74tKaaLOwDJmwheKfRyRolcIWJAUCiDdYRjbrBlzMWdoI8TrUjudPwTSuzgSi94VPfqK9nCggQlLD0FVFLlBmUrFn4E0Jgejal9tOxhvtculMTqWhHu8UD9lRlOUgPgFCQOn4BcYRELwSD9fEEKFJZ9ORNt5hf0kZrA2nc0L9oyRYuE5rtiRDfZNINOwLzkoUu8V9v1p7qNpk3cXtn1U51/wNCLgrLntcIu+lRJkYkPttKE0ODz+F3V9r3DBTiIbkQoqn3SPYIPMCS4ykxm/QcqaU0gQvA7ZHhpzz4yoZi7zOw4CHWqq/AKg15p3wmuuuqMbD1zcAEWZ6C68SeRsbZ4dypgZ7HXdvVD/dYGTCTDj44mN0kFzdCf4Z5s0VsMR70dTPmsti9EAr5V8ypKFryXgOsQ97wFTkOnzuFycXQSRk99X7jUeYTqVWeoJXE3op2UsIDkZcyefoTPxnCTFGfZ15vnTt+hVNQU4qGO/5uz4rmVQg2wrA87c3YqEZ7K+nnYE99MFS1y+mtO3bveqmmh8SoLxG6j9hib5VALVSAk4WuRa160iVIwszsNog2NWSahRWwbVxWNRc3dqliER5LaJyqYqgtnLDyyD7R7LTmgdI2jX4UCJDcX2qk3iJuaIgYmAv2cIqmmldNJhV3dD/ZuEKo8d4Gt4fh18iM4WRFnyp/iiM/a1UmaF8fD3eR212BABGvFPs5oSb4slFIiqQtiFiYo7GR38jSkDN40KiD2AYF5VExCkOIk/Ey6pm1jXS3kgljem68w5eYhDWw8021OEzZp5l+kzbO82jAQiBW6C4to8JrQQlW6YfFZf/eIJFYPNiXwnVngJzmAMVh9BFLg8BJ3dl4reloS6KQe
 MfJTS2LF
 YgSPJbCBUqctiK92Ax/7Q72fyENQbWp40An4zlfOlyi2InDu8MNv6YY4u8zJGYjUjqaYD0qYLcjt+uCQC2jlnhcHjZ60hGS335gWIH5z61jXqmozRTML3JpNntv1pbwMPEMMTXgd43YBpb8oOKvky4B+oQCCPZO6YpzQRMwLBTRC5wjnDL/PcRyV5Zpn6+2fwUfRT/lN7NrXIM5Aq+iXWiVMEQAX/CbvLD7lkd7YWhMpng/18o9hSOyfOcztTco2HlvW2WuAcen2qyv56pyy7j17X5+/VJ7j93d44YnS4BO9amOqbGGcK03TQdCruaWqmp8QNuB169uklblFoXS3oylO2QA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/2/26 20:30, Rik van Riel wrote:
> follow_page_pte() now walks a whole page table in one call, but still
> resolves and commits each PTE on its own, so a PTE-mapped large folio
> (mTHP) pays one try_grab_folio() per subpage.
> 
> Add gup_pte_batch_len() and give gup_grab_folio_pages() a run
> length. Each run starts with a full per-PTE resolve, then
> gup_pte_batch_len() finds how many more PTEs extend it with a pte_same()
> scan rather than a re-derivation of each page, and the run is committed
> with one refcount grab. Runs stop at folio boundaries, so plain base
> pages are unaffected.
> 
> Gather the dirty bits from all the PTEs in a batch, in order to mark
> the folio dirty for FOLL_WRITE.
> 
> Same benchmark as the previous change, with before again taken at the
> base of the series:
> 
>   gup_test -L -m 256 -n 65536 -r 16 -t
>                         before      after
>   64 kB mTHP           2946 us      231 us  (12.8x)
>   4 kB base (control)  2753 us     1198 us   (2.3x)
>   2 MB THP (control)     72 us       71 us
> 
> The 4 kB column is the previous change's 2.3x, unchanged: base pages
> share no folio, so there is nothing to batch. 64 kB mTHP goes from that
> change's 2.2x to 12.8x, a further 5.9x from committing a run with one
> refcount grab instead of one per subpage.
> 
> With FOLL_TOUCH, folio_mark_accessed() runs once per run instead of
> once per page: 512 calls before and 32 after over 2 MB of 64 kB
> folios, leaving them referenced but inactive after the first call.
> That matches the huge-page and fast paths, which mark once
> per folio. (Measured by Yuan-Hao Hsu.)
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Rik van Riel <riel@surriel.com>
> ---
>  mm/gup.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 46 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 67e20b326be6e..47f204e21a3a7 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -937,6 +937,35 @@ static long gup_lookup_pte(struct vm_area_struct *vma, unsigned long address,
>  	return 0;
>  }
>  
> +/*
> + * Return how many PTEs map consecutive pages of the same folio and can be
> + * committed as one run. Always at least 1.
> + *
> + * The write-fault and unshare checks in gup_lookup_pte() are per PTE, but a
> + * writable run needs no repeat: a writable anon page is exclusive. A read-only
> + * run under FOLL_WRITE or FOLL_PIN does need the per-page check, so it stays
> + * one page at a time.

That's a clear indication that this needs more work.

I'll try to get to it soon and see how it could be done in a cleaner way, likely
it should be based on top of the gup-fast series where we will have helpers to
check for required unsharing of multiple PTEs.

-- 
Cheers,

David

