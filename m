Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDC3C606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 18:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HtxP6fXD
Received: by kanga.kvack.org (Postfix)
	id EE2546B05B3; Sun,  1 Nov 2026 13:11:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E93736B05B8; Sun,  1 Nov 2026 13:11:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA9B86B05B9; Sun,  1 Nov 2026 13:11:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B13526B05B3
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 13:11:34 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2C48740ACF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 18:11:34 +0000 (UTC)
X-FDA: 85387342908.07.B05F083
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 54269C0008
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 18:11:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HtxP6fXD;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793556692;
	b=Jg8Ra6Ngpp4MDFu1YA5lbgYoSBjGRFU30k/7HJSiPjErH0zk7dzP4MHn80lvNM2gz7Rmci
	G7GjDMV4Hf5CUFond1xULsWY0OM0hMBpHA2FmUE7Lm0ykMMc7N/73i35tP6OeHwdukncUm
	v118JB8pab7472M3byZjsHFmwNGNDMk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HtxP6fXD;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793556692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zk/xFJUvpptQoHdHEaeuVhwsJCx4lSLvvDbqB+bW+vw=;
	b=m9jXDOZuQtxn2NZUFIaRAdyKcUR187wgHy1cuJx3XOrF0eKEg5hrdsmkZ4HNH6Vhz/9KYf
	MkqeM4e0JkhzExIlXLqyQN28C82HfZRcLvLsCCrWE+sUPTqXeFi+bhN495yK28mue6ym3r
	dQVd1pQ2YzPNSXF/rbH6PCUbOaPATEc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CC56860054;
	Sun,  1 Nov 2026 18:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04E51F000C1;
	Sun,  1 Nov 2026 18:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793556691;
	bh=Zk/xFJUvpptQoHdHEaeuVhwsJCx4lSLvvDbqB+bW+vw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HtxP6fXDfmT0rvIllJX1TjxmAptTL1keHNyLrhMec4tzYta4xCLHG7DmeCk0NIBEM
	 duYQoZDCEXKk89Du3QYSNf08uDk25WuEy+vhOOLIiTIHk87Y4ZEzkVvUBWi3MlJvbF
	 i1avA+rgj0Krl7GCfOYJtue+Hrkbl327CPRmEcJ35wGae6M/H+hpvQgc3YCn19z+ly
	 CCL/+yMTtzKawo6mK6xLYfDr+IPTO2Niqeh23lTW1jEj7VgitWX13fsIMYFTUhsGBP
	 12CVBI15ZGEeuRlQiV41Svp7z0U+4ZDTdGZPZzFbx4GCi0G0YUDvFmWS7Hdg3hYIvI
	 qA6MDmn+i6nkA==
Message-ID: <79820b33-7e74-4e12-926f-1e03987d7bda@kernel.org>
Date: Sun, 1 Nov 2026 19:11:25 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/ksm: avoid anon_vma UAF during page merging
To: Zhao Gongyi <zhaogongyi@bytedance.com>, akpm@linux-foundation.org
Cc: xu.xin@linux.dev, chengming.zhou@linux.dev, aarcange@redhat.com,
 riel@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 "Lorenzo Stoakes (Arm)" <ljs@kernel.org>
References: <20261031182256.40205-1-zhaogongyi@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261031182256.40205-1-zhaogongyi@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: whu88fdzy3ije6hj45qaf8wftub9jkfx
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 54269C0008
X-Rspam-User: 
X-HE-Tag: 1793556692-678561
X-HE-Meta: U2FsdGVkX1+FEkl4jHXOgAUhPO9BYPCzRm3Rt4aHIJIzeowo5kontHa7ark6IID8XehACMyhc6+8MwiJQFXPMzUXe5hDTZYlpZGaFxtJE/xV2RAFS9W1HGAaFjH0i+2u+qI0U1QfkxJlUq2T39X+FXtmQvu1kcsJbsW+k4WF/G0NcV0NjOXmRUj/GyTgYajAi9Y0Q+SHKIb+FYobWCh99v6eoDx7k3dug9yL4bbUj9BSWiJW4buLjxPIXMpmrsrUQELUU3IRZbqokuD40Nhw1GSrjLIAkdZC1xYgpNbEl1nsXq6jvF/cNMc/J0Tz6SNakZNn8RUdwEd4i5CPfU+rDU2Y9CjBrJ4yUB+KzeP4NoAvn99IXgbyJOd05CwHO+3yExG4Add8xZXf3JEDhcYnP07Hj5nOn0fIguIS3vjwNQ2lHQkKtTVKoZ+6UaCc7zVJswab5Kb0Uen2Qy3nh29BvB1OpNIEeE5hjlId44xLjlC0/cxyAgYCZVWD2XEeRwfYkhSjlO9dLri+u7ukCSgE6sh8nj5AImuvDlqt6MI4zE6U+3Op/WykGfB5JDHFzHE8AqjThV7Qq+Hckkw5jGKMTC2FMtpuF07X6bH8hbcC3XrW0K08CEa1N5vtJN/R1efL2/xCeKmIXP3rvWyMmKsMXSCOxDgQvtUbkj/Z/2W3Jzj14mS2VI7VqOl4KxtuNtjzlJcHz+qk2cRHIWYxCq9HdzH3vzmkmafspC2VKJrb34n63Iq4p+3rke6XVP/EI7iFwUgMLGgfeWy3W3aTb5wjWchiTbrvh4Fb5T+91FZlCLegR/Si//3E4g973fUgvHmaLybNlNzDX2O5+x6cwDzRDZR7nzRVbMyWfIvj8xAuoiqT64dTrsit8CyBzkkcXi5xAlRPlOzIrNzqqRfJ+Q8gqiKY2UuP3dAafeAByK24qcs8vcLk4oivkQynZR/0fSdda7qcLBaRiYRQ4ygx/d7
 JVoiKXTW
 ll/EevhyNwftA+nkYzQLbWHyYigFJ/X8ApM/AXGEARKLgh3Vy5OPIb71h94LIllkMV+1tJFUeW0NVsZ2BE39ejpM5+AqBa/7Evv1UT7cUcwz0RkYmH2ftU3iI7xqhNwqAfXOci3aUK7CEbLrUzBYILcdUF+vwZU5AVUOLd9kTehyOrsKfRJDmnZdGY4fTEQeZNyYUcCVse2ixBa9G8OMxZnQ5IqrmK2M62QVkmE2NGeh3gSglxO69dy4mJ0uZEM3xuN6SKbX7fOykTIfYD0h6EBf/pp7jTyYPHCRcRwS4vYbuJF3h0OyxX5JmHBrslRi4iFHW4K7sCt0nD1s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/31/26 19:22, Zhao Gongyi wrote:

Hi,

thanks for the report! CCing Lorenzo.

> KASAN reports a use-after-free in page_address_in_vma() while ksmd
> merges pages. ksmd keeps a folio reference across an mmap_lock drop,
> during which mremap() can remove its last mapping and free its
> anon_vma. page_address_in_vma() then dereferences the stale pointer
> from folio->mapping.

Do you have a link to the report or the actual KASAN report?

> 
> KSM needs only a candidate address. write_protect_page() checks that
> the PTE maps the folio, and replace_page() verifies the saved PTE
> before replacing it. Compute the candidate from the folio index and
> VMA instead of dereferencing the folio-side anon_vma. Reject KSM
> folios because their page index is not meaningful.
> 
> Fixes: 21d0d443cdc1 ("rmap: resurrect page_address_in_vma anon_vma check")
> Signed-off-by: Zhao Gongyi <zhaogongyi@bytedance.com>
> ---
> Testing:
>   Unpatched mm-new: fixed-pool KSM/mremap reproduced the KASAN UAF.
>   Patched mm-new: the same workload ran for 12 minutes without KASAN,
>   BUG or WARNING; fork/COW KSM smoke passed.
> 
>  mm/ksm.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index d6f736a..f8af5ee 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -1307,7 +1307,7 @@ static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
>  	if (WARN_ON_ONCE(folio_test_large(folio)))
>  		return err;
>  
> -	pvmw.address = page_address_in_vma(folio, folio_page(folio, 0), vma);
> +	pvmw.address = vma_anon_address(vma, folio_pgoff(folio), 1);
>  	if (pvmw.address == -EFAULT)
>  		goto out;
>  
> @@ -1408,7 +1408,7 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
>  	int err = -EFAULT;
>  	struct mmu_notifier_range range;
>  
> -	addr = page_address_in_vma(folio, page, vma);
> +	addr = vma_anon_address(vma, page_pgoff(folio, page), 1);
>  	if (addr == -EFAULT)
>  		goto out;
>  
> @@ -1515,7 +1515,7 @@ static int try_to_merge_one_page(struct vm_area_struct *vma,
>  	if (page == kpage)			/* ksm page forked */
>  		return 0;
>  
> -	if (!folio_test_anon(folio))
> +	if (!folio_test_anon(folio) || folio_test_ksm(folio))
>  		goto out;
>  
>  	/*
> base-commit: 243e8cdab64129d6207c398f8cf5fbb1962ff7e1


-- 
Cheers,

David

