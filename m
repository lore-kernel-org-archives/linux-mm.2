Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0E2260A3828
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iHQiqgNV
Received: by kanga.kvack.org (Postfix)
	id 01A4F6B05B2; Thu,  5 Nov 2026 14:34:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F32886B05B4; Thu,  5 Nov 2026 14:34:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E53166B05B5; Thu,  5 Nov 2026 14:34:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE5536B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:34:22 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 717211C4697
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:34:21 +0000 (UTC)
X-FDA: 85402066722.01.BEEA3AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id C91A714000C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:34:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iHQiqgNV;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793907259;
	b=jyqOkSSzSH0B9rEaEmBNoZNVRtg1Qvb4w1UiLMzj52o2srb0kRSq6wwcxfBXYcbVYnPfZB
	70V0doEL+V/tL7tJaJWdMZ2/JTYbVo650erTedx9g9GmHRIpRHBLOP2/y301CTk7mSJhp4
	+jDuSkVJ7vrHiOscbVXQKdh86j4g/E0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iHQiqgNV;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793907259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MDJ1ZuofLgVrpfv3I4TcFcX00mth3LkloBGTNtx3eGs=;
	b=dDo/P0qz2ryzcFZ3kO9RtpJlvcol/BFoJbb1DdfR4HONfuXa1TVpE5XvDqt7AegPZi3PVH
	ctEyAV1xia6pCpnvwhFn1Yt9h9v4xPpgb3gSRXJaaMc5HFeW8ZAuOkX8y0/QSjeqRXnVLC
	yBg5/7xKGwNCxs8LNlwviDsF3uDWcv4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B01A60148;
	Thu,  5 Nov 2026 19:34:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A051F0089E;
	Thu,  5 Nov 2026 19:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907259;
	bh=MDJ1ZuofLgVrpfv3I4TcFcX00mth3LkloBGTNtx3eGs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iHQiqgNVDF6AO/Z9+xmHNYJq09sECOJ/V1ouMhJqojtr1X2lJdIRL1IYYXP1RAJCt
	 Wu+CnpR0hPTdGkb3X1/WjYeL/32yOdGH+PAP/eOvqaAFSsJpD22pEg0uyGpaT6+gom
	 gF0bg2MI/d5sHtDIiu8RRs9aHcei0IP77Zmebbu7PK4yDcZUqq6YP6mxN3lsspiek7
	 cCK5oxm5ovZn+oyouQ4HciyjLYzwyWVRUfskUtb5rb8sGPnHSqaPbTm3z/eEl9tqsV
	 +1672ZPVSu99Q4WD3xyK+mLzz2UsWbX7T0lij2m3pPMEEB3yFttZ/T3qPisBsl47pm
	 1+a3ge+2jqcnQ==
Date: Thu, 5 Nov 2026 19:34:13 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: don't map folios that are not uptodate in
 MADV_COLLAPSE
Message-ID: <auzZF4cGOeHH5upi@gremlin>
References: <20261105-set_huge_pmd_uptodate-v1-1-a78d8a1b7117@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105-set_huge_pmd_uptodate-v1-1-a78d8a1b7117@kernel.org>
X-Stat-Signature: r6fw54uoo1knb1pw1b55aaihgtzfwpdn
X-Rspamd-Queue-Id: C91A714000C
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793907259-414692
X-HE-Meta: U2FsdGVkX18yWmpHf4NPTdbHypueTDD6kDfDKYw9sTdYMTk8LD+b+onNQg62c3iI/PPj8DZlOtC4WLfsw6AuKgwVMHqFHCCw7evXJyV5Y8rXEavj7/Xx9Be0AFPgH63s3JpMsvV1ySBKFhRpYSssdVdOqgk2tEVaXyA1OeU5Pm43zcTQabCUNuFsJcElQMxT5WNhF1j68/S97y+E7+xHHAxR3tev3rnRylQmRVwGoC8da6a2sABlKPE3aTdtymAk/4lkmyrhbSfEwMuRzQNAWsihNU1eFIHGC+hHKAd8pkr4Wf8AI/X2/92VKhnMcjiTXY1foi4B6L9Zr74nlhOXDO5Z7mg7x+bJATcVVtUUPSzDQn7LZhh9+1hR7/utlbjTCBwAZpl75LqbJ5VHxnEW42Gv5jckvDsjlaCHGh6jmPVgHcwUMUxOpUkAtoXg7mvfTtE+N6mMfrdjBBmVYLZofuIqYWzODMjmawAfyyp/zcrxTKGofHNtLzVvLl5kvcKhnrI0/VuEFbl0kq3YtBpaO4Edafd3PrhiEM2z7Vut/Ng4pyVQBa2Z7w3pYmXJ1yjQcpYqF80i+G+WK7qG9WuD2wRAufZp3ix4hZm3rrlHsg9JJvleFX1Z7AVICESPFpIuK3ZWC65JudCZ0UEF+X+WCBPLkx8yFcwqHQbDdFI6JQnQ1yi9xuKIkhidfUd7tJ+iV3Z/KaJFFHa/eB0jVW7piRMGXmwg0K5Y93Mk1XUmGS6MFHNkOqhvBbP0KkJbw4FZgovUs6ox06tuDWlKDT17Mhr8wYUPgF9iB83r/2wnXqfV+Z7H6lZs3+3kcanVbpPFf0uBToXo1ykvuIH/Uorbsnwpi+p7KA+CdhKJkcsCWq6+ujg5uPWwX8gXn+3p/SXU4UBL2RX22sgUQIJXrThLDyC+s9EpCOYaiWygSdC8H9PBi2lA8Daq4Uep7ZtMg/jwelNhPdUIBxyRSbD0qIQ
 bcrO6i6S
 5M5G2hxZFgbeEuTC1miz428HtBf4OqfoYjiYT684bSeBtJ4HRZl8QRI1JObzPGFUgvrksIObTxj5EVuUhDamQPMbKUQK4Qb6yiHk+IBPEciRXldSw9evGG5Nw//73okrCQMWzwaMNXM7VkJdsM7G4zHA3WHWFLq/a/rXH7/Vw7hm3PnJv9TMbiu55/jOwNzSOXpoWoj04kCjBQqCx4s6C3+nq31v89K7qIrlfcuxSbt4O2nbTdiS3/f1MAZrhynHPqptN2p9+fKfT62T1Np1T4pXVeEXVnluD6Hy4ovw5yxfZiktadZq4/S0/SksZ9dG6cyG9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 07:16:44PM +0100, David Hildenbrand (Arm) wrote:
> madvise(MADV_COLLAPSE) can map PMD-sized pagecache folios that are not
> uptodate. For example, shmem fallocate() can put such folios into the
> page cache.
>
> collapse_file() already refuses to proceed with folios that are not
> uptodate. Let's just do the same in try_collapse_pte_mapped_thp() and skip
> such folios, leaving handling to the page faults.
>
> Note that collapse_file() effectively clears shmem folios through
> shmem_get_folio(); let's keep this fix simple and simply let the page
> fault path deal with that.
>
> Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
> Reported-by: Chris Mason <mason@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Looks reasonable to me, there's no reason we should be dealing with non-uptodate
folios there.

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> Once reviewed, I will pick this up in a timely manner.
> ---
>  mm/khugepaged.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 8d9f05a39afb3..db135b3c44ef1 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1900,6 +1900,12 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
>  		goto drop_folio;
>  	}
>
> +	/* Leave any uninitialized folios to the page fault path. */
> +	if (!folio_test_uptodate(folio)) {
> +		result = SCAN_FAIL;
> +		goto drop_folio;
> +	}
> +
>  	result = find_pmd_or_thp_or_none(mm, haddr, &pmd);
>  	switch (result) {
>  	case SCAN_SUCCEED:
>
> ---
>
> base-commit: f44fd601f72e09e44c667b9234c9cd469856679c
>
> change-id: 20261105-set_huge_pmd_uptodate-9b9820307f30
>
> --
>
> Cheers,
>
> David
>

--
Cheers, Lorenzo

