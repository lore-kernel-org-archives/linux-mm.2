Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFA5DD72373
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 10:54:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CE0C6B04AB; Fri, 23 Jan 2026 05:54:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27BF16B04AC; Fri, 23 Jan 2026 05:54:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 187216B04AD; Fri, 23 Jan 2026 05:54:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 097B86B04AB
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 05:54:22 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9C4F0861C1
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:54:21 +0000 (UTC)
X-FDA: 84362919522.07.28C735E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id DA0071C0006
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:54:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769165660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hS0S3WSxzDI8bVHZI1Xar/j+cepDQenEPx3rANfvERs=;
	b=ny19yCqlrGUKy9Lj5ilbScWKDBvJSK+yv9XB66G4kEPIKB+O525DTW9BG3nAKUBiWoIFAF
	iKhZ/AWL3XQ+TfjyXirmvxByp1Ybs4MipqQE38oL2JPTsjXBQXGySWpVMa9liteTc3d1fD
	Ot+sATUVk1Y63zusa8DVHn2s0Pru9Rc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769165660; a=rsa-sha256;
	cv=none;
	b=SJnlRgB6L0BKK/fOCFBDU1teXAzw9SnvBpP5e9sl/rwdVmc7bvLDRwa2cSpT7Mw1GdC106
	t4rkPTxnwDkqtbo+TjqJXv28cZpOhmHrAYu5Yi187y0M3GhcjLee9588Q4sPJMNCQjo0kT
	HRZ4sVmywJcXgFAn5IZAZFKt4z5mpmU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 488661476;
	Fri, 23 Jan 2026 02:54:12 -0800 (PST)
Received: from [10.164.136.38] (unknown [10.164.136.38])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8E8723F632;
	Fri, 23 Jan 2026 02:54:15 -0800 (PST)
Message-ID: <152ccbbe-d32f-4842-9ea8-5476076c5abc@arm.com>
Date: Fri, 23 Jan 2026 16:24:12 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v5 3/5] mm: add folio_test_lazyfree helper
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
References: <20260123082232.16413-1-vernon2gm@gmail.com>
 <20260123082232.16413-4-vernon2gm@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260123082232.16413-4-vernon2gm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DA0071C0006
X-Stat-Signature: enp8yoh1rq5tys79ftegkbsxicjas4sa
X-Rspam-User: 
X-HE-Tag: 1769165659-591761
X-HE-Meta: U2FsdGVkX1/i1fpY5vzw+oG1ZsjPTJoMtMWZl0mmzCQO1sDOu8eFheq+yHFaJlm3SB9V2w43iFJuRTRGJmFCecEgYau4bWYnDWu0CQqwqtM2odbWDn3gLLBEz5+RBJGM/gvsVf5PC/8IFiU66q8ZgLYSGJL8Dr6iDgTBvgo0/nbcfyiHQURJuk0jtIYYQi5w2u+vNzlf+NiT/zQjoW5TUPFVLmpqE35ULdOqXfVuSqN8grgrSpygB/vhhslxfKzHYRMp5bBfevFQtX/8jr2Ve0TJJnKRkF33RsSl5ehkGvVBc/Uk8tdgJcBBAryvRdDF+XyiOZcKvSrgrbfFmgAOIUM2u8ME9lx+bfHvadbisKajv5up24J3FPaU55I2sfwLJQcw9kEk7KJCHAzNBqmuXI7dclCKcXi/9tDAnEu2TFVPEAigtvDrT2q5/rAJ5WcNdK2sQ5ypqdR8oFxviX3LhfHEb/bRqZ4W0MPW5t5hWUQJKMPbhOmYuPmr/xSmTwHWqMoq8wf5tH2tElLMnAH2qQUkpefPEv3DyI6wkejYmSv+/ldgxOvmuo15Xa5gXbePI2sTkfMC5rwj7ianRdq9sGSb7odHpD6cZe211ph2ImFbObUEjNRFYNA6d5zcxrLnjvI0YhAsEe/5Hfd//Ju2gDncqXNF1FEHR4Q5rDuzDYM0CbyY1eACGG7WD+7JIw22bUYMm5EIUw9w/4I20EKSMccMMF8/eD85w066NU6YuHJ//z+aSPtpSHJ9lZzKKV34/Rgu+LXFSdsnwNhOEPUp+BRInnRls9iMy5laJxkjUCmvNdysAFeWQ4XbxS//d9yJgF6/vwp+JnE5jkxFi3Hth5DGWuLaDuZMl06YsIZcbhrdAtX4nhbyEZlwuslC8sL1AZswFy2/UB86CWKpuwkND3vCaCd7p8nqIV56zbJtVgpmmpNefy++PFm7nRrx08s9xCoAu7VuTpL19ABcetW
 zJXBF12t
 i84mrlhGslWdWWAjdHyKXO4tGY5LW+4D6uypOxYE6ZlIf6CdbB6qLQdLeaixl+JF3z4gACqy015dqcWhYDBNozJ9lev4rO9RYGW/4Nws5+x46YlzV+hrx7cCmbbIiiUo2j9uhVdR46waGe5XytC+U4TERVu1azefV+BWxjTYEva0qG0v6qOSQXG3rL4J/Y+80mbiwmbtSioLYDzTxuhd60+3KfwsnnQeYO1gfnbfJUYJJwxlisnf1q/Q5Y7CdzbzSaZadZA4JiROlAQUUdww4HJzmMfA/s8gLGDaq3bYOyywzKsMEoLcPdeh1hw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 23/01/26 1:52 pm, Vernon Yang wrote:
> From: Vernon Yang <yanglincheng@kylinos.cn>
>
> Add folio_test_lazyfree() function to identify lazy-free folios to improve
> code readability.
>
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>

Thanks, this is very useful.

Reviewed-by: Dev Jain <dev.jain@arm.com>

> ---
>  include/linux/page-flags.h | 5 +++++
>  mm/rmap.c                  | 2 +-
>  mm/vmscan.c                | 5 ++---
>  3 files changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index f7a0e4af0c73..415e9f2ef616 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -724,6 +724,11 @@ static __always_inline bool folio_test_anon(const struct folio *folio)
>  	return ((unsigned long)folio->mapping & FOLIO_MAPPING_ANON) != 0;
>  }
>  
> +static __always_inline bool folio_test_lazyfree(const struct folio *folio)
> +{
> +	return folio_test_anon(folio) && !folio_test_swapbacked(folio);
> +}
> +
>  static __always_inline bool PageAnonNotKsm(const struct page *page)
>  {
>  	unsigned long flags = (unsigned long)page_folio(page)->mapping;
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 088723f909e4..6b09be06c707 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2049,7 +2049,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  		}
>  
>  		if (!pvmw.pte) {
> -			if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
> +			if (folio_test_lazyfree(folio)) {
>  				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))
>  					goto walk_done;
>  				/*
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 8643c0fb9162..1f32c74ec738 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -944,8 +944,7 @@ static void folio_check_dirty_writeback(struct folio *folio,
>  	 * They could be mistakenly treated as file lru. So further anon
>  	 * test is needed.
>  	 */
> -	if (!folio_is_file_lru(folio) ||
> -	    (folio_test_anon(folio) && !folio_test_swapbacked(folio))) {
> +	if (!folio_is_file_lru(folio) || folio_test_lazyfree(folio)) {
>  		*dirty = false;
>  		*writeback = false;
>  		return;
> @@ -1489,7 +1488,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>  			}
>  		}
>  
> -		if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
> +		if (folio_test_lazyfree(folio)) {
>  			/* follow __remove_mapping for reference */
>  			if (!folio_ref_freeze(folio, 1))
>  				goto keep_locked;

