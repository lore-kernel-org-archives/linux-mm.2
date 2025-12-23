Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D624E6F072
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 08:50:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E21D56B0005; Tue, 23 Dec 2025 03:50:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA5796B0089; Tue, 23 Dec 2025 03:50:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB1776B008A; Tue, 23 Dec 2025 03:50:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B32396B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 03:50:34 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5AE91160538
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 08:50:34 +0000 (UTC)
X-FDA: 84250114788.10.CCEEFC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 89C7140003
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 08:50:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VPEr2aSL;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766479832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vfrLkfn8KuTjwSTBMR/lPABFifbXFDGjujEi+D5oh/0=;
	b=rtRsjinh3LglFagVlXMfd04xqNiwEfgJcf0Qr43sy5P/ms2g/+fX5jICQjzTSf8VrBFudQ
	sQfW34A3XTLAFgOBqKb0RbSVWC4Gn1rQNpwX/FXYNNQpl1UbsHIY2PBeLBn0PbbCuX9emh
	oPTJRpo2AZOoyUKDXGaRzamhlsw+dBU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VPEr2aSL;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766479832; a=rsa-sha256;
	cv=none;
	b=1Xvf/nhbGDYEHSJ9iSJRLJhDJfgnJQVoc9USu3n4GIJs/U/wUFhZp1PbII8ALwXzzzPDlV
	0dzrBvwSmRtyWOS4Tc9lEFG7GDjxWwBLKK2obIi11KQ7Srlnzj1zMXOpd5qrpdcr9CreRZ
	jUO3girBlEcv2kEWLCXew/ESu/sIVn4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 724FA43DFF;
	Tue, 23 Dec 2025 08:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4FDC113D0;
	Tue, 23 Dec 2025 08:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766479831;
	bh=D9p4aDnkMp3xBLSj20cZVuhUlzR174rG+fno549cX1E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VPEr2aSLQ0B5IvUkEwGnIN50DkddlnZkOls9Lg8LAdeR5yqixmwJjyZR3nVT8kSHZ
	 yccXBUwblTQpBXAqCsrn5N/VsNmomFTVWL4SyoqDmn+bgCnNuwvwPZjScnCf2+RNXi
	 BuPWAbDvHJPHG7PiNW0jgcDiGH3cra3+cdb3WjPChCx0sGS+7+7vmDsot5sgAKGZnd
	 zD8fLoReZj0cY1JzIll8pj9mtYSBC8bF84i/Mb7rENIKIDtw9j4pYjM0bCJOJIUPl0
	 tEw248ret7R96jK/PXGgkV6UxtNWzpze9V5cSWZboHYJalhEEEQHBKxZe2q7hkR8VO
	 pJKzn6O60YQ6A==
Message-ID: <d9e09523-2b61-4280-876e-95be787258f5@kernel.org>
Date: Tue, 23 Dec 2025 09:50:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] mm/memory-failure: fix missing ->mf_stats count in
 hugetlb poison
To: Jane Chu <jane.chu@oracle.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, stable@vger.kernel.org, muchun.song@linux.dev,
 osalvador@suse.de, linmiaohe@huawei.com, jiaqiyan@google.com,
 william.roche@oracle.com, rientjes@google.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@Oracle.com, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, willy@infradead.org
References: <20251223012113.370674-1-jane.chu@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251223012113.370674-1-jane.chu@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8aiyim4zo4xqitsnaumg4y5r8yffu1xq
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 89C7140003
X-HE-Tag: 1766479832-810753
X-HE-Meta: U2FsdGVkX19Jt/lSXpB7oKA2wMJec4+VC2ihNjdKvYR7mWTf0mBNp6Vct6DbB9y/Goxaaool8mIFYi965d+sBk/5kk5uUAHfR4hA6uxEp43vhdvxK+Lj2s4APKFEBj9ZQcf/RfgdVXu7FVimD9bZz0/LlCumjfzU4VwWT1QuHmZXxsoedBnBrStUNkVhiBygjXjMDwOphvG6mm1WKCrDAqmaSUVaE5swwvrVr9mYNebzkzcJRjPCc/SHiRq7+y8n9yNwHw2NppvRP6+3v2bLuR2eiY/KY7nf1zLrCoHNTgc7I4Jrzgm+BrbB+Xdl3um2wIlwMbcH8Y+HBcNdrtBJHkUr1hfNSb+5nBLVPNUhpPAYqAcDA8fl4ZA/ELp1OxZMn9FRHoI3hXMyf16CZwC1uat9hsGnTNkFd8QFjxQfSzHAq9RLDPc5jPlP8UhOMuRX8JFKqC+tgZAu5p++XOkRpVFG4d2Sdfq3RDsP880xG0aPBLCaEnPuZA3FyAetW9XFCTCb7r4/wClQfkRRvkdpeUuYmzUcd5V742RpJbkgmXD3j+RWa8YTuKJyQhpMTfBDaJAV2gWJyRXrxzXjzrIVQR7PSgu6pJmL/19P3zh8gbvTUolp6Uj9YPl1Zop+wLGiRFoT4GSCXpkfKlXMI4AHbfV/tIy8XZM34NFQplkELctbmhRG6lE6SJe53xt6TZ8tL4FmCgGnTDnNV7dSSUwi73EZr3kCIA/BYCEriJYhE6UogKcL2AdEuyd+XCRjKUeS/w78kvduJgWI8M5Ilh6SMucnqDx0cDcO0cz+L1ijPw8adTdR92LjYR1Td66n2yLIh3YZl/ysg1W9uIAaQGyxZ2EiN2Yu96kmCMSxBLW/5L6UhXOfloycxQ18YfmCohk+d/wBXNDRNUbfNgnOSWvpEnkV79+rFK6YHoQ42bvUvaS55dxx+swteckUPlDAVBO8sS0Imm8ffhXdJuPVcmE
 p6+Kwgap
 hmLMQZ08NHKLzMUD+YogJOg1Q87BYcIVgLcjicnoYnHFD8Kq9w9QuX0RzSXAcn3XDKAy4qXjkWS1URuHPk/D/uix9IoCu/qH0dVzTM+VJrvyqOnRrsdHsClSub9oOsZFcqM9FuzIs9SaOBluUYQ1/0vkYvD8qvGuZHf4qRsALXNEWAZUn0N3iS41X7n1596sJon5hIG0FxRdykNqPmbg5XY6yJtjYSkNL1L0SqRlx0xfAQNYkTAKvQhgi17u2GJyYo5czepl2o/dLTNS/3ahyhwf6ZP/DgRN+/4wLI0PWYf7WOkbsht/WkQDO6ohqfRQaBmVQ3bOtL+8zMRnTnUjnQNC6IuhIcSVrAp4V
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/23/25 02:21, Jane Chu wrote:
> When a newly poisoned subpage ends up in an already poisoned hugetlb
> folio, 'num_poisoned_pages' is incremented, but the per node ->mf_stats
> is not. Fix the inconsistency by designating action_result() to update
> them both.
> 
> While at it, define __get_huge_page_for_hwpoison() return values in terms
> of symbol names for better readibility. Also rename
> folio_set_hugetlb_hwpoison() to hugetlb_update_hwpoison() since the
> function does more than the conventional bit setting and the fact
> three possible return values are expected.
> 
> Fixes: 18f41fa616ee4 ("mm: memory-failure: bump memory failure stats to pglist_data")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
> v2 -> v3:
>    No change.
> v1 -> v2:
>    adapted David and Liam's comment, define __get_huge_page_for_hwpoison()
> return values in terms of symbol names instead of naked integers for better
> readibility.  #define instead of enum is used since the function has footprint
> outside MF, just try to limit the MF specifics local.
>    also renamed folio_set_hugetlb_hwpoison() to hugetlb_update_hwpoison()
> since the function does more than the conventional bit setting and the
> fact three possible return values are expected.
> 
> ---
>   mm/memory-failure.c | 56 ++++++++++++++++++++++++++-------------------
>   1 file changed, 33 insertions(+), 23 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index fbc5a01260c8..8b47e8a1b12d 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1883,12 +1883,18 @@ static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
>   	return count;
>   }
>   
> -static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
> +#define	MF_HUGETLB_ALREADY_POISONED	3  /* already poisoned */
> +#define	MF_HUGETLB_ACC_EXISTING_POISON	4  /* accessed existing poisoned page */

What happened to the idea of using an enum?


> +/*
> + * Set hugetlb folio as hwpoisoned, update folio private raw hwpoison list
> + * to keep track of the poisoned pages.
> + */
> +static int hugetlb_update_hwpoison(struct folio *folio, struct page *page)
>   {
>   	struct llist_head *head;
>   	struct raw_hwp_page *raw_hwp;
>   	struct raw_hwp_page *p;
> -	int ret = folio_test_set_hwpoison(folio) ? -EHWPOISON : 0;
> +	int ret = folio_test_set_hwpoison(folio) ? MF_HUGETLB_ALREADY_POISONED : 0;
>   
>   	/*
>   	 * Once the hwpoison hugepage has lost reliable raw error info,
> @@ -1896,20 +1902,18 @@ static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
>   	 * so skip to add additional raw error info.
>   	 */
>   	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
> -		return -EHWPOISON;
> +		return MF_HUGETLB_ALREADY_POISONED;
> +
>   	head = raw_hwp_list_head(folio);
>   	llist_for_each_entry(p, head->first, node) {
>   		if (p->page == page)
> -			return -EHWPOISON;
> +			return MF_HUGETLB_ACC_EXISTING_POISON;
>   	}
>   
>   	raw_hwp = kmalloc(sizeof(struct raw_hwp_page), GFP_ATOMIC);
>   	if (raw_hwp) {
>   		raw_hwp->page = page;
>   		llist_add(&raw_hwp->node, head);
> -		/* the first error event will be counted in action_result(). */
> -		if (ret)
> -			num_poisoned_pages_inc(page_to_pfn(page));
>   	} else {
>   		/*
>   		 * Failed to save raw error info.  We no longer trace all
> @@ -1955,32 +1959,30 @@ void folio_clear_hugetlb_hwpoison(struct folio *folio)
>   	folio_free_raw_hwp(folio, true);
>   }
>   
> +#define	MF_HUGETLB_FREED			0	/* freed hugepage */
> +#define	MF_HUGETLB_IN_USED			1	/* in-use hugepage */
> +#define	MF_NOT_HUGETLB				2	/* not a hugepage */

If you're already dealing with negative error codes, "MF_NOT_HUGETLB" nicely
translated to -EINVAL.

But I wonder if it would be cleaner to just define all values in an enum and return
that enum instead of an int from the functions.

enum md_hugetlb_status {
	MF_HUGETLB_INVALID,		/* not a hugetlb folio */
	MF_HUGETLB_BUSY,		/* busy, retry later */
	MF_HUGETLB_FREED,		/* hugetlb folio was freed */
	MF_HUGETLB_IN_USED,		/* ??? no idea what that really means */
	MF_HUGETLB_FOLIO_PRE_POISONED,	/* folio already poisoned, per-page information unclear */
	MF_HUGETLB_PAGE_PRE_POISONED,	/* exact page already poisoned */
}

-- 
Cheers

David

