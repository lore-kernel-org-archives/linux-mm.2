Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E96BCCCA464
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 19:47:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F40296B0092; Thu, 15 Oct 2026 15:47:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF0356B0095; Thu, 15 Oct 2026 15:47:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDF546B0096; Thu, 15 Oct 2026 15:47:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC89A6B0092
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:47:55 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2AE98C0174
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 19:47:55 +0000 (UTC)
X-FDA: 85325896110.07.AF8E0AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8ED651C000A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 19:47:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ThWtpvf6;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792093673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V9lVAl0inOJKZISTRP7bv977o2J5aqss+rBQ8yoS51c=;
	b=QbapSb4U+GKTWbjbzYH1CatgQBpGxisFbLEMyu3G7oeoGu2JhcrxTyIZBaueW0un1dmvUg
	ULFeWkLN3P0F9QVvAF+yodzUPd8DoRFZzHRAshLnp9taKQXCWYkzJqoAC/bVcbFINc84Fb
	VdQDCWdvVo4xqZCtBMW4yoNc4kI8t5s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792093673;
	b=0lXUQpqL/P1nRZ4I/yhWabXTS8t5FQAlomCJq+XFsUy9+1lR3CMqPV9CrO2+wPrejyUn2D
	yx4/2Vs/3qZQF6jkBRJclHMWyoGWu9VElK5En/mlUwcXZSUfC3NGYM83C4NQWNsNTKX3MC
	iIIEhu7clT8eMX8Ps/Q8t+BKcS2TIOw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ThWtpvf6;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 157B4602CA;
	Thu, 15 Oct 2026 19:47:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00CC1F000C4;
	Thu, 15 Oct 2026 19:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792093672;
	bh=V9lVAl0inOJKZISTRP7bv977o2J5aqss+rBQ8yoS51c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ThWtpvf6zsTR30bHJIEGafp2NXw3++Q+jHmYCqK53yM75cv5dhwRcvhB0Jcf9rGbw
	 U4DIZQU8vzu+emd6urqBH0QG5KI1aEUnl9Ol9zdAdBbZTollbVlRykDUNmhos+QAU1
	 3Zj35yoE2B5rAlJ/+JXrWAOX+/qgUbR0B5qgBTLOZ3O9kEEjQC10STGDfwe9/EmXSc
	 p16Pi8Ly4hQClJGe5OLe+CL6T94vALAS7lAL+j+99CkiV78DtHicCG7MWw/cD492/1
	 n9Uh7WftNS1kdvfUD3l2OIDjTlbJOVCD5zHGTSp3tEstj5OTUYVQMowVaracNTNkjm
	 LTWyG8haewf5w==
Date: Thu, 15 Oct 2026 20:47:45 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Adam Litke <agl@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@surriel.com>, 
	Peter Xu <peterx@redhat.com>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Josef Bacik <josef@toxicpanda.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 08/10] mm/hugetlb: tolerate UFFD_WP markers outside
 uffd-wp VMAs
Message-ID: <atEt2ULH6uQSeJH9@gremlin>
References: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
 <20261015-urgent_fixes-v1-8-42796911043b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015-urgent_fixes-v1-8-42796911043b@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8ED651C000A
X-Rspam-User: 
X-Stat-Signature: zyrzoiqtr7deq69hdup6b7toy45uownu
X-HE-Tag: 1792093673-657385
X-HE-Meta: U2FsdGVkX1/nw9oaGwoabJveAEotZjgBzw9bMrmUJtMgdFQpmuGuSWFY4jSOfsJO0Y++fZ0LDg6si5ZcbhAyImjt/d1sqhdVdc6Am/Crh99IKozTr+xucjnbAT8nEtQO9KTGGsisLG2+P6USzO4MUPfWTdn6mzmSFHwdfF+NY+Z+rrGPBWYujww3F6XKD/vvm6elLLaS+Aidr0ZLXKotunGNq/+ESmrmCi2jEqqVfroMYEd8jzRoItJiQ/KpbgXjEOGgFkLIoN5Iac1PAciIwkjL1mDjZljFLxZ5CiqTYro8zmmQGyETjzN0KRwe0gsWmhbzt8OZwvXsbVeHVNzmkKmT3t833IcaHoInka1Wk7qv9nLQYd6CxNtKCk6qFkMRebJeIIi5fRM8CmwpZd42HqZoBE47MO7xHnFed/y3bW7aoZsLICvOAYi+bx0Ucpr1lduphvm3OHcxi7N2f3hK0tTxhPHbnbO7dj0EX/xL6VmQ3yikWS+cH4cUfpcfWcfC0Tqo/hapG4WGK4fIxcijtZX4Xd6ZOXV9NMpIwnUSyltimTegjqiud/N5soJZYAk5REmkreiBSRNGVnmk3VM2ilZA8Wjgl/KHZwbk8l6Uqlqx43ur4xMKi/Mi89V/B2DFRGzQmFdcAIDsKjYRYcr2VBjB+DzcsvMEUgiNRUqpG+0xKEGLur++i7AduO662ysJLGaEIgb9yss6ENRx4YC8kESpE1RfLWVPrwXDMRKsKGWO9euItZtBvvkLch8DMg/XtG9f8M6O9bA3143FM8z2cOBpRnfyIqRSaFuOpirA8PWdwUcMV62O/S/hDzGywRh4E7m2jVu23FNXaHL/5oQHyAP5rb5k/H1p64s3ckB12Cn8ZUc4eGOAOamleK1OKz8uV38fRWInbboGupwFVM7nGhjlR3aourHtw8jkK6Z/gkk9hshV3Xi5ozf8vFtX1qEeEQQv3xXCW6dcFKWqLrY
 oppRjTix
 RENpR96zijFPjGCLVF2KNQS8CFJ8q49HpcJHbo+LboD7Y6TErLo0TwKuH/wUCpXbS19uZr33IQsZ/wl5P4cQg+w2zQhV1SdpGLi37lRKLEi7VMEGgikFDmRRuXp00e4REiEVT8wR9tPiZ+jsmtnKz/VsVj1Uv127o0dggqqBn8/v3Mtf7fjXd/XhFjRCXkMFabQL60bZybMdt5kNlbh58qaVzS4NDUBm+qXSadukKOMMU/LKHj5ntbjeUHpvK1zJVUXXm8eiS8wSX3G/2HPC/bd3dJ67nc2Pf0pByDSlgujPzxQ/0P2vFkX6jWrkUIno2GKutfp1HHWAq0uDwSA7hYdSEMMDyvi3olAkH8SdDSkOXRMw8FJuXnf+gmt6UckhSbeqS1JCg9S3G6Og=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 06:07:14PM +0200, David Hildenbrand (Arm) wrote:
> UFFD PTE bit handling is a bit like swiss cheese, in particular with
> recently added RWP mode. Having uffd-wp markers outside uffd-wp VMAs
> already confused this code in the past and resulted in uffd-pte bits
> confusing other code later.
>
> Let's play safe and just ignore these markers in hugetlb_no_page(), not
> silently propagating the uffd-wp PTE bit.
>
> Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Seems sensible so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/hugetlb.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index ba6860b9b7f4c..1548a6156206b 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5939,8 +5939,11 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
>  	/*
>  	 * If this pte was previously wr-protected, keep it wr-protected even
>  	 * if populated.
> +	 *
> +	 * TODO: fix all cases where uffd-wp markers remain in VMAs that are no
> +	 * longer registered with uffd.
>  	 */
> -	if (unlikely(pte_is_uffd_wp_marker(vmf->orig_pte)))
> +	if (unlikely(userfaultfd_wp(vma) && pte_is_uffd_wp_marker(vmf->orig_pte)))
>  		new_pte = huge_pte_mkuffd(new_pte);
>  	set_huge_pte_at(mm, vmf->address, vmf->pte, new_pte, huge_page_size(h));
>
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

