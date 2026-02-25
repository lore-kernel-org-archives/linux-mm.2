Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF238EFD20B
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 09:15:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BA5F6B00D2; Wed, 25 Feb 2026 04:15:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1854E6B00D9; Wed, 25 Feb 2026 04:15:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 038716B00D2; Wed, 25 Feb 2026 04:15:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DFF526B00D2
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 04:15:35 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BF4CB1C465
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:15:34 +0000 (UTC)
X-FDA: 84482420988.15.B33B8F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1C0C0180008
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:15:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hR3UwT/h";
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772010933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VpqWqmeekBxGCdYM/oej5HZdc/pCkIl7k8yl+tXjn6I=;
	b=73Oh1+oPejZ5Re57mVWC1Qr6GG9PZuMgBMNliB1wLXwFaVUHcDP/sT4hECmfWWp5D+Ih94
	rXsiHAb8soi+MdUjLyg+BZg6T0sv8XGn+P/UdnsLWWeBhmmwaCgz92dFfjbaHv6PmN+oXo
	uJdWIBoxvK98T4rtJIXutgx1v0rPhF8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772010933; a=rsa-sha256;
	cv=none;
	b=JG6VKtm5dDpKypB2D+tDeA9NZFKAn8Ac2QohGoLed2qamYkBkStxhG0Dg7koXy3hWM7lFy
	cpdft7xqsmv64q37/c3NbzjAljJVZdhZbgD8YPoNHHum11GHvyEh5APQtDUHVGKChlzrVP
	QOG5kVMhVpWegM7z1t7owPmNkRPJoVA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hR3UwT/h";
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 356E942B3E;
	Wed, 25 Feb 2026 09:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5A6C116D0;
	Wed, 25 Feb 2026 09:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772010932;
	bh=KtvgSxQGgdMS+TNo1repNzbP0o8KdKN1yGWAXwQiQ5Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hR3UwT/hBiYY4ZmaZn1cvCK0AdO+Fmny7YaC7t4ovO/7sm8QogmBTN+r4pGwKRA70
	 gGKRDrp+ifJKzUbVdvkdiGB5gAzwFWk7lN5PrvNVN93blTJIOt67AbfGPYQeaFsD7C
	 lvKlztp6guAQS65B29fyqU8bVHavL58wxoS3c893dchwghYENwJBP674199uBwne1P
	 EsDTMjWUw7fmEYwsnyQlZlhTfrzD+x77eXAUD/6OK8CbyUgfAOarjREgfYYu+CqWxm
	 DmYVJcaIvIgvTSSKL2oJn+bMiBCo9w/oykXx+FOAibqBzX9So3c8Jx7QvHGXMSeFEJ
	 Y/yp8ywS5/bUQ==
Message-ID: <db51a324-ee8e-44fe-b7bc-6ca65a3c2a3d@kernel.org>
Date: Wed, 25 Feb 2026 10:15:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: fix folio isn't locked in
 softleaf_to_folio()
To: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, fengwei.yin@intel.com,
 baohua@kernel.org, ryan.roberts@arm.com, linux-mm@kvack.org
Cc: wangkefeng.wang@huawei.com, sunnanyong@huawei.com
References: <20260225081240.253057-1-tujinjiang@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260225081240.253057-1-tujinjiang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1C0C0180008
X-Stat-Signature: 6paxbk7c9ydt6bzi3mpsohkcosy6g3m8
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772010932-98492
X-HE-Meta: U2FsdGVkX1/nlcXp+B5RqcqVnz4yKoDO0HY/vK8hBCGHZ2JXfBqhokjjAVtKdIeeI/t8q2WQWhuAEP2IR7AXkOVOUqlVxZBjODYiipWoetXTkYf4JFiNxVi+cXtmDs54vtI0CTAArdtFoUmJw1nk3jPYqRfdrC9H1e2PctOgVaJ0Vb3YuONUWSdcIm1VWZUBSrnFMhXGS/3lVY8x8cEr3fEW1dTtq4LlHOGs41FIzvrSUf7AhhRZCyGqdAG56+P2T/rcF81QJoASombfPm1AQ+ZijqqYbkjve1hJFSmpx09U+x8Ct0tJUW9i5p5rBsE5Y7hGywbtqoowY4QH3kC1sBdz2wB1q+3S7llVOsz9QNy9ypflJhwTvdRAuwEo6AQc1G8NgP8Wcn8LMaCRrSlpXv/4YzRghMvkQq2OXC1kePTT5QXj3s9vPSA+/uu6ucVgNaxlJUxk+U27Mb8U2t8TLjhnfyEZs70fubpLdXwY3G63uRefNDeLpLGMlI46oMhP9qiYgeoILvmR2KNUz3T7a1Fdkh0g5c38bMmW7fobvrVqYNTBZIT7cjScLCPgKMDF8pFxCC+443BOFr4BRdk9LF2uMN9iFFSQFV4bGU+By5tp6CItt1pTXCOcmG1We/rRdFjyXzBy7goYrYAsQadZrab4WV2jLbYgep5EERx910P8LhtNat5tSnv7Rj7zH4kYQ86TR2C+2CR7QVOGsPaMMjmCbkVv6IbGiKTqCIASka4i83IbHGDzkuYTF8XkfWTFKiZL3lTUQE6jg62PppEwlsjKX5MaNuLsP3MGqrgwFyYvlU1TiZHEFSviB8FXyWQPPSclTZEQPQhj32RkHQeKpvjj5JwMEhMJpVKkeMxnj9P722BNB94P6ejJSRRRVuoCO+byKHZQSaskvGUrRQojO0toKAfSHQqGJ/dheHAIsjUsnC82pf3btRvl5vZvdsUMniay1obdOn1TIMQvCek
 mrwY7RK5
 w+XWmP4EvrQUoM1s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/25/26 09:12, Jinjiang Tu wrote:
> On arm64 server, we found folio that get from migration entry isn't locked
> in softleaf_to_folio(). This issue triggers when mTHP splitting and
> zap_nonpresent_ptes() races, and the root cause is lack of memory barrier
> in softleaf_to_folio(). The race is as follows:
> 
> 	CPU0                                             CPU1
> 
> deferred_split_scan()                              zap_nonpresent_ptes()
>   lock folio
>   split_folio()
>     unmap_folio()
>       change ptes to migration entries
>     __split_folio_to_order()                         softleaf_to_folio()
>       set flags(including PG_locked) for tail pages    folio = pfn_folio(softleaf_to_pfn(entry))
>       smp_wmb()                                        VM_WARN_ON_ONCE(!folio_test_locked(folio))
>       prep_compound_page() for tail pages
> 

In general, relying on a "struct page" for a migration entry is shaky,
because it can change any time from being a large folio to being a small
folio.

So we generally only check properties that would be true for either the
old (large) or the new (smaller) folio, like folio_test_ksm() or
folio_test_anon().

It's important that these properties were written for the new folio
before a migration entry user might look at the page indeed.

So it's not just about the locked state.

> In __split_folio_to_order(), smp_wmb() guarantees page flags of tail pages
> are visible before the tail page becomes non-compound. smp_wmb() should
> be paired with smp_rmb() in softleaf_to_folio(), which is missed. As a
> result, if zap_nonpresent_ptes() accesses migration entry that stores
> tail pfn, softleaf_to_folio() may see the updated compound_head of tail
> page before page->flags.
> 
> Although the code exists for long time, this issue should only exist after
> mTHP splitting is supported. For THP splitting, there is only a pmd
> migration entry 

When splitting, we first install a PTE table, no?

unmap_folio() passes TTU_SPLIT_HUGE_PMD.

and it's impossible to access migration entry that stores
> tail page pfn.
> 
> To fix it, add missing smp_rmb() if the softleaf entry is migration entry
> in softleaf_to_folio() and softleaf_to_page().
> 
> Fixes: 7dc7c5ef6463 ("mm: allow deferred splitting of arbitrary anon large folios")
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> ---
>  include/linux/leafops.h | 39 ++++++++++++++++++++++++++-------------
>  1 file changed, 26 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/leafops.h b/include/linux/leafops.h
> index a9ff94b744f2..f823f390ba6b 100644
> --- a/include/linux/leafops.h
> +++ b/include/linux/leafops.h
> @@ -371,14 +371,21 @@ static inline unsigned long softleaf_to_pfn(softleaf_t entry)
>   */
>  static inline struct page *softleaf_to_page(softleaf_t entry)
>  {
> -	struct page *page = pfn_to_page(softleaf_to_pfn(entry));
> +	struct page *page;
>  
>  	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
> -	/*
> -	 * Any use of migration entries may only occur while the
> -	 * corresponding page is locked
> -	 */
> -	VM_WARN_ON_ONCE(softleaf_is_migration(entry) && !PageLocked(page));
> +
> +	page = pfn_to_page(softleaf_to_pfn(entry));
> +	if (softleaf_is_migration(entry)) {
> +		/* See __split_folio_to_order() comment */
> +		smp_rmb();
> +
> +		/*
> +		 * Any use of migration entries may only occur while the
> +		 * corresponding page is locked
> +		 */
> +		VM_WARN_ON_ONCE(!PageLocked(page));
> +	}

Conceptually, wouldn't the smb_rmb() have to happen *after* the
page_folio(), like we have in softleaf_to_folio()?

-- 
Cheers,

David

