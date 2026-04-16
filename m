Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69E67F8D776
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 19:44:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C3346B0005; Thu, 16 Apr 2026 15:44:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84E4D6B0089; Thu, 16 Apr 2026 15:44:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EE126B008A; Thu, 16 Apr 2026 15:44:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5AEBC6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:44:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F230EC2FCB
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 19:44:23 +0000 (UTC)
X-FDA: 84665445606.08.45A5DF8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1C77880004
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 19:44:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=srQ8xjnM;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776368662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pzoMFej5IKcNAQtaPsT1IERhaNVCXATvhR1hpAPDxSI=;
	b=jDeokRDQugWM4IwPs7C6Syntn/qQp5V4ltXLgq64R0zrtiHA5DF2Bi9pUlgwqfLg8ibqJn
	+PVxGSFwvqozSkbDZi/xmeLqWu/aQ+yR2YUN6aPsf4GB+6JZoQ3H1/U3aPXVc9jMLcieo3
	6rQB0QlBuns32hvV0u2JR+e6csaRvvQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=srQ8xjnM;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776368662; a=rsa-sha256;
	cv=none;
	b=tVIRY1/yvxqOB02n2ecpEoAtibyfm86UktAQT+qkK8/c7gyyfWMIeLvC1HzMKDqZ8jUSZN
	X0h5StXKm9Wj86p1wRgSwsHpG+snYO+lbI2YAjWJlQUBtX79/XdVXJ2Ub5fIFpD46W9mi3
	pTbf3grD5OpkQDmPArtF1WY0CDwRkWQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D9F4543C5E;
	Thu, 16 Apr 2026 19:44:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37693C2BCAF;
	Thu, 16 Apr 2026 19:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776368660;
	bh=qKg59kcnzqTeEd7CQvgz5TtsXwNQ7XFtrOnNy0VMoCY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=srQ8xjnMI5SNpZdbXO6SJXbCmehgQkh2pbyde5HNlB/onKRp9eeuD63KLLHIPQGSr
	 ppK0GBStIybMhEfEWTbwxjDRE+/Js92e8OmF8PBO4CyJVqu9T1Hk0/PT9vybrnsQji
	 PORhcHBKPLGg4WNV2oormglm1T6i2JAJrt3Gaq4Ts42UbYtKM7CplSgzVsQ5SjEt95
	 lz6Im6gzfU6l0pSWoUBGLMQUWMR8+AgcD303MMmfI7tbzmwL1LK85GbfyVRs0JbNc/
	 gsKg07U0qm+fK/QBHu5tmkYfqzKLeqpDK4kNtJTYJjpCRLvPyC6KeXrzyq9nkJx6WL
	 C4Y826JVqRsdw==
Message-ID: <d95ee512-73ca-4535-9fc6-a2c77eeb350e@kernel.org>
Date: Thu, 16 Apr 2026 21:44:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate_device: Cleanup up PMD Checks and warnings
To: Sunny Patel <nueralspacetech@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260414141344.29949-1-nueralspacetech@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260414141344.29949-1-nueralspacetech@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1C77880004
X-Stat-Signature: isibpkbh4mszkcuc8wwtmos4ip84adtd
X-Rspam-User: 
X-HE-Tag: 1776368661-324187
X-HE-Meta: U2FsdGVkX18vpgDalWWTWd0wWiat8XWlgdfnQN9fshFUqAGTUFT2HpVTxjfrdcpbS1zz08wSR3Zp81jvsedAK+8jenBYhtVSh+c0JQ+TrAyorVC0BcvMOCnbzZ/TXa+IVhKoT1X5CGpotWg9XSwSWfNi6vKrN770K9+i2/kviJYVvjVUbgZsNV4k4vNmqrXsr8rUI8/NhYyEf7/2Xh5KXCYpN+r/hCfgY7cVS5GLIpW/O8VUEzatSEXHa1UU4gtVN3Jwwf56Ui4vv49mFyjPcq1XVaTjf7agvYGzD67QS6eGbISFRon8oCfQ3bBv66J8AmtM7QPDyM8CUxhi9dL84K8fmJs5HLBGEv4I5JcO0GujKGQ8DkgEr2jfctvtzMjIa8lr6ZQRRxFPoG2UQUEozDG8Lxv/g6IDKg8T/EIqMtkOFmxhuYUI5U2e689ce1aMrwQ31XIatZzF/FtumbW5d92lPcXfQPl2rJ/doIc4FgBtnllbHMGb3aQtT/yWIZXvQKTE6rVhH+nq36ysfhDJtZQQQ7N5Mcf0XgnnkLys8qZEIo8EK9e//eKECJIMetk3ELaIqnqK4UkrLF+GGa+vro7i59TLtJk1HdzThQUj4BhajI9Hqt8kL7bSi5dhGJrF3w1XGNlsnE+dK1gobgS8H4u3Qff7cWfvgXsOZ5sLGy4Osvk9Jo2uHa9Y1JUh/jO0Ps+HDWzSCqyn92m1eIu6n/Mwp8GSWI7u74G4puj8c4tiTvBQXO0kl6BIUc7exf5DtvkgLGCQ5fWuneuzfm7KBCJ93LVzC3MsGFM5NclDN8R4MsWh6catP6zvHEiv9UhlY9EEvMrJqNx+yakFeYlrWNo2UiOwU2/L/fEWOluuJU0sa7Bf8xotQwD9irMmTGyREVssiGV6qlTzV3ytar6ngRA8Z+CDjTpv4syR8l3+Bklb/LJbHdlWrPAVA5aB/IjTIzFhGvPzjn2hkQ8VpKe
 7gLmWzx2
 sQ2G40df8WHGAf3RovRu0IaJbCvyCkTo+v8s428try9Zt3qARMNFw+ePZbZmthxYvbWz2JhrjQB+iEZFVruGtWShyvWE1uUbMUu1KLPg3Yd8uDIGavf8s6ywGkzOQalpOCitQ7zPIV/eqAQ6BkqXWoJ78oaNK3DCNhWZxiD7L8HfCPmA2lLt8cdklx+l/f41lLwltgEwqEkuCyUZXy7HNSGTLimB37oXjmJYzvB0iSNCk6A6MnrYs30+viYC3WNQYb6xwEhyMHdH1nMtrKs0WhlJVtDGmNXXOAYTH0k+z661r9vTGlk6DemrHsb1hx4myK7yTvutcEiz+OwzgFtAtAC9xqZIXuLl+EDb92exnhEXBLcIiaaQ8vpehsX81zTJHbeqt9jcLl8BT+Y7KpAwvdufBzf1hsGqNoxSWk/LjKyK0n9Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/14/26 16:13, Sunny Patel wrote:
> Remove the odd VM_WARN_ON_FOLIO(!folio, folio) usage and replace it
> with a simpler VM_WARN_ON_ONCE(!folio) check.
> 
> Drop the redundant VM_WARN_ON_ONCE(!pmd_none(*pmdp) &&
> !is_huge_zero_pmd(*pmdp)).
> 
> Refactor the PMD checks to use pmd_present(), making the control flow
> clearer and avoiding duplicate condition checks.
> 
> Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
> ---
>  mm/migrate_device.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 8079676c8f1f..fe1c1999aa2d 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -807,8 +807,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>  	bool flush = false;
>  	unsigned long i;
>  
> -	VM_WARN_ON_FOLIO(!folio, folio);
> -	VM_WARN_ON_ONCE(!pmd_none(*pmdp) && !is_huge_zero_pmd(*pmdp));
> +	VM_WARN_ON_ONCE(!folio);

I'd test for "page" here instead. But it doesn't matter as of today.

>  
>  	if (!thp_vma_suitable_order(vma, addr, HPAGE_PMD_ORDER))
>  		return -EINVAL;
> @@ -865,12 +864,13 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>  	if (userfaultfd_missing(vma))
>  		goto unlock_abort;
>  
> -	if (!pmd_none(*pmdp)) {
> +	if (pmd_present(*pmdp)) {
>  		if (!is_huge_zero_pmd(*pmdp))
>  			goto unlock_abort;
>  		flush = true;
> -	} else if (!pmd_none(*pmdp))
> +	} else if (!pmd_none(*pmdp)) {
>  		goto unlock_abort;
> +	}
>  
>  	add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
>  	folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);

is_huge_zero_pmd() checks pmd_present(), so we didn't have a bug before.

We could also do:

if (is_huge_zero_pmd(*pmdp)) {
	flush = true;
} else if (!pmd_none(*pmdp)) {
	goto unlock_abort;
}


But I don't particularly care

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

