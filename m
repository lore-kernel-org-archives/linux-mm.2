Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E003C61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 08:47:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69C636B008C; Mon, 31 Aug 2026 04:47:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64CE66B009D; Mon, 31 Aug 2026 04:47:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53B296B009E; Mon, 31 Aug 2026 04:47:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 303CD6B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:47:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8199B14020B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:47:18 +0000 (UTC)
X-FDA: 85160935356.23.7DF15C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id DF2DF14000F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:47:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n6rModvz;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788166036;
	b=YFo4RMAvMkhn+CR3HWCWwZrohmVqiVyOajFpoYGwkOny3yHLuWOTq6nKYN4ID+Pnsomj6l
	CqDxMHtJhuLcPGwHb+WNPDJ2iicBWdzBF56gtnHvcE20rXddMMRR9raXrOjIiVN8jUPHl1
	fJdPlsDEcE5Hua655IlIhllS7dieKwY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788166036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j2Mk0tZDWX6Jqg1UsT9JhoDtteuQwP3WlAW2gIqLEl8=;
	b=tgRfkOK7krIvftuuUsYZjdB36W7s0eWvsQe5r4zveRbv+xi4BXYeMxasxkhkGPil3VnLxs
	XhWJnXncREnC4jkezEN9weeqGJGc3/lV8BqZ7RMxUER4Jam51e8RXfAvnwxBjWegxkMq7x
	NDoZ+Z5w8hpDAx6xxzgvoIvo1v0xACI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n6rModvz;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1BEFE43E72;
	Mon, 31 Aug 2026 08:47:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C131F000E9;
	Mon, 31 Aug 2026 08:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788166036;
	bh=j2Mk0tZDWX6Jqg1UsT9JhoDtteuQwP3WlAW2gIqLEl8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=n6rModvzfMT8KL/sLyWh+3dibwD5hGqkyYm6uTnSlTJAl7ndHpZ5iFN/cT4UNk6sG
	 wdtyKWTMPdEjCD0GfAoq5YujtJnGBP1I10ojPNRxeYtUDr+rUSs2C0l/MDzt3Nrjek
	 xfDU+XZtyi7ldcCgIlvxvCmE6JCAwO4j7mU7zcRXCNGcXZ3NrPqTtQNVWgfbzrLy+g
	 BB9rHt1Tjv/ALrCnQQrr71byw/6m2pvjxj5GGzx9lp6p39NpHWglexa1Tc1j0UxjSr
	 RS+paGmo4R9TKKVOLsktBEOnphBuqcgwibnoZgH7W/Yxlm7kffQdVEFYshQDwcjkSs
	 DxQ1DI51igRnQ==
Date: Mon, 31 Aug 2026 09:47:09 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, riel@surriel.com, 
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com, 
	lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/rmap: remove stale hugetlb check in try_to_unmap_one
Message-ID: <apU_g-m8-IBY9iTm@gremlin>
References: <20260831082849.3573957-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831082849.3573957-1-dev.jain@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DF2DF14000F
X-Stat-Signature: y3k75es7tofyn7en7qcm9sjrns9jzow3
X-HE-Tag: 1788166036-395472
X-HE-Meta: U2FsdGVkX1/UBoKPnBEZf9DDErjqh+MIxgMQ3nqCzJTm60G0gix6KMmWmLt+B7CVFwtlASDCNiH9f3BsG98Vwt2CTu4vNkPAXA0LBUK9/xhxomAohLocwlLRPL25w9ptItTWEQH2DP6ZS2Zm2xxVw/dpNWrrOOh5J7dxbuysS8XQ6R4fTyhfF/P5KQAnjQoIsPmYBbtScuruRCJEM9VPwe4Qzg/6PXom/4HkMCg1HZXDy+xNk8OUCUbSA8n6E/1/7ZUAdEIjAhgs0qSnH+aIUeM/afv1hXeW4CoUl+1htzzvgwhDp3sQ4Xdu/UFH/LdHwTG5SiQbYereGnxNM4Jzhc3RVta1xY9M8vSAw1mB6doI47oaWj/PK6vXU0MkSwZiL22MDvR1HQ4e3gshNXPfQwTWn4JgWV+YW06TdR8N/eHVnYfyYwzUcNIBP/NPltO4mdBDaf1JrcTXgFTW+BfB86g0OYfjtpkhbOvQEQLCCSlGSkiu55+155bHerctEUn5R5pWoa1shigWMCsk9t8DmF81Vg9O4UrZS43H01GVp9fdGs64sVpJjAjsilUxs/A9jvfAsFNF0JuD0tCGp/KuEaDt544DsU7C4ikIChu/UUktb0/m9VnSHk5GXS12u86p/wSnQdoQPKAbKbpWZmn2E/7N1V1yWPB2FK1VhyR2zXohWfbV+c/yaCl2NEVU/s7rC9VN0i+UUqpDiGGQfI9XLlh7boCtWT3gwE42TURxJo/Ko1jtFNraEHk45Y9P8J7rAQuiv7bbp9gKFPBUlCDCtdxFW7w/vpmgYQmplTEa219rGW6jTg/8tHa1cvqeLJJnvJTN4T5yG0qF48KLJFWlbraoUMashG89Z6RW2pHBClbwEaXnPFXJvZQATp991KuHpIVHPWINYgfi9XAt6BdP9NRwrQz7lWzVtXQ+yiST1enJ29MBXZ4waVlvPxrFs32dFJGWyPw9mWmeTPyNL8R
 K706ZRj+
 lsLYGjUguakKm6rBVxFz7pCh8V/pa3HPscrE/G8BXU6w1M1OAwSQ6s8UJgbjgD2M7LSPXZH0++tmJHgo13CkRU4LEmBkVIz7+jqhyc36j3B4JQSwZjdOCpBddB8WJjnNJrY+Pzj9rpAQmhzHNfHZ+0lUVjStvQkvgMS/jfJ26XBWMieoncq8DbJ63po3dvZX+9Qn93JiXOPc/cM3p8miRq8zaEXEQBAETzd1tgLN7c8nG3JCu1pp23pKEKo6Yzods2FQ+bFDJodxGakvGjpEe17uJcAvPf6wk/oKHxM5vkK9OF86LyjDZp80NhYJxuGn7n2XAoT6rk0u32BpEEBgV5x1uxCqpXZZIt2WQxhSrgJ6cvO0QKvUAVUQ/P71KlxvZbVMVepu/Ckw53QMOvPl26+qPIo6qffuSEL2RQdhp/tdD7dU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 08:28:47AM +0000, Dev Jain wrote:
> Post commit d4ec5572825a ("mm/rmap: add try_to_unmap_poisoned_hugetlb_one")
> try_to_unmap_one() cannot be called with a hugetlb folio. Therefore remove
> the folio_test_hugetlb() check.
>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> Rebase soup - my huge_ptep_get() fixes landed after the refactoring.
>
> This patch applies on Linux 7.3-rc1.
>
>  mm/rmap.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index d1819fd699380..606c8ecf31302 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2299,11 +2299,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  		VM_BUG_ON_FOLIO(!pvmw.pte, folio);
>
>  		address = pvmw.address;
> -		if (folio_test_hugetlb(folio)) {
> -			pteval = huge_ptep_get(mm, address, pvmw.pte);
> -		} else {
> -			pteval = ptep_get(pvmw.pte);
> -		}
> +		pteval = ptep_get(pvmw.pte);
> +
>  		if (likely(pte_present(pteval))) {
>  			pfn = pte_pfn(pteval);
>  		} else {
> --
> 2.43.0
>

--
Cheers, Lorenzo

