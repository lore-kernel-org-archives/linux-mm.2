Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5205ECCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 17:00:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CA598E00AE; Mon,  3 Nov 2025 12:00:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87ADE8E0057; Mon,  3 Nov 2025 12:00:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76A4A8E00AE; Mon,  3 Nov 2025 12:00:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 644B88E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 12:00:15 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2B8C657B60
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 17:00:15 +0000 (UTC)
X-FDA: 84069908790.03.1A0368F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 427C740009
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 17:00:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MbbflDRg;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762189213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ogzNUstDw033ZQfkixi6qF9BIVtZumPzhBvIChbBF14=;
	b=XC0P+JkLxT7m3NcqD3G0IwoLfNbsjukCk29QAOMO0oipsitPl9sxr/z0vTbESHO7KvJ2vo
	JqCmqMS5AcsN7NKNwleknAfZnisYd4qowZCitXWrzXw5GR/t8ce1/3kONhb09z8HTeVIky
	u8yqHPKDstkwY65g4K/2/jFhM8Th0OI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MbbflDRg;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762189213; a=rsa-sha256;
	cv=none;
	b=MKH2YXJ84Jt+jk5DlFp2YN9Y60hrjYG8qI4s3Es+ELLx3jS192YqB83vldhhF5GC60XDK4
	W2w+wKefNjzLEL0Gs9u+LjiAlUQQZ4HAufdarliuxLDS3MeulNmGw44KzFQ558KSY6bZvN
	D9GtreublG/w+009qayF/cXc+KiWg44=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F8EE4373D;
	Mon,  3 Nov 2025 17:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80385C4CEE7;
	Mon,  3 Nov 2025 17:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762189212;
	bh=zEvKfyASQ6FHSygxdwigaZ1gT1SuO69TZOAMJ+IO8IU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MbbflDRg+0BR0YL6QHTy3QksF2c/O8W207w9FOACd/Zk1zT848lDh2gt8mYj1nXGX
	 Z2Vc/yHX9GE7EgQSjmBVq6lu0us3oghlHfBw6ISuqW5wPEyHUm7cHA8zGWQkemCL7j
	 V2T/ztc28gaosH57atQLsv9GwD0s64gEkP97Uksh3AfgxufT43f3tbkKXr8ge9MMlO
	 rytBFsyMQTnTbUVwxZ+XJKQYFkDGwIXj8J+n3HLcCUt1tumrExhmZFQvBVYtHQ6i4U
	 DZouGTA2k070rcrxK+vjZ2z+tp+7YQcNLd9nG7WTTWI9JaqZbEnz6N8QWJ2tZo6yQS
	 3ueBx489Gd6Ow==
Message-ID: <a6574561-02bc-4ba6-9fb4-418dcb07cd5f@kernel.org>
Date: Mon, 3 Nov 2025 18:00:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] Revert "mm/ksm: convert break_ksm() from
 walk_page_range_vma() to folio_walk"
To: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
 David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251031174625.127417-1-pedrodemargomes@gmail.com>
 <20251031174625.127417-2-pedrodemargomes@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251031174625.127417-2-pedrodemargomes@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 427C740009
X-Stat-Signature: 1u8cj6mes1up99egdr9u9pq3mhhcmeh7
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762189213-636310
X-HE-Meta: U2FsdGVkX1/PHt9uM5Y9aiUkfZKdM2sYDFEzlC2fuCPiC+7kWtkX3sen57Hn04mQQVbU935mVu0OQwozfy3avBng1vX6MVXFh/S4j1WsX2zJYrUE8k7ZUz49aDs8GNmgpUJcubQ+Fkqm6BZiXpSQZrMADtR8x0vHDMOgPxRlxKxOfLNolxAt5wjoZhqp2zu5Bxglll/WbH9mqiIjLSDyD+QiwypQjcy8SpHMCchuS7521LaSAgvBa9sNL00L5nWeY/fL6x46o59XkpOOBuJaBsFwilH1VniceW2Q8W7lKPEEBx8TONKCGNGH2c0jBxAhDZ6Z8wXt9HiOWJYD/6OGhdsOxHzQ6ZJBH3TWhMFM+O3KBvsqohkgI17/a/hCh9ZfzoWgJ1qCbRI6s1l7OsOl8c+gkAaCrwqlvMtnig5KdYGqQqMem2Pyufuimp6/p0S74qsvKTdXU9BIFQpD/s4Dly9DIkCP9bEwvXdVIMOJM8WzMwBi6D7U+R+8Eg5sinralu1HtzVqvDC+ZWDWFOYMEigTGHDktBUAqy/CiWS+JYDFPb3v7MtAVPwRsRJ9gQ7yzZO6GFUZaN+cRuNfvxCwHU7lFybOE8Ljf/oJgLF4tl4pNdKgcOvZ/cfCb8xXY49UF/0UDCaqBMer8rz3O4rs2Q8nuXik25UTIuXIPxQKYDO5J5/1QHzVWG8cG4Kfouj9zUwVRJTcV3DjYE4+UeDjXQtfJawwNqyEb1c5o2ChIY4IBVa44zCN97jgZ2P1aYU+8IeLwKITLZ3dZUcQau1uhUQcKSTJiNaawUDfvx566U4441fo2PTpGNNm3hjfC4TtCFidE4hLchp1nDuX8KNAZH3Tl3xCiUD3opA7OVF+NnoI8d38KnSsPI7J9k1kS5knE6iRqMmO/x4FHqQbYD6mYMTEij3xOG/tg87m2cd11zUEM2jMfOJGqNuOWO0W0kvSqd9vPLzxO6YYtVTQAo/
 ZAVdwfWe
 1qkpFegiyFiusGXSYtiWPx39oEw67wsn7ZzrG1lM13qflXNEeD6oJSwDSLOc6vAZbNOaPOhyF3/cpTd9aNIeFJttQ+07qS4MbEg+ZUJq07AvFTXXuj0h89YacGf9Hwb6ozX3W6AGaFkMLDGzbLoAtheW7I54HgHDjmDx1CV5G3gnPzxzzRwK0QRGy8RRD5pBaiyTFKxp9oa0N+eZjyErnbqejZqIwoQ3tkK7A4/VNqoRCJTsrHMX+Z9hb0acOzrGz3h3T2xeqVS5R1gBycSpysyvE0tdLSywyTmcuuoN9oI9xrke96zQU3pOUTv5tp+xk1Gk7/qWaCNSVpOIWMU5qvngs8A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31.10.25 18:46, Pedro Demarchi Gomes wrote:
> This reverts commit e317a8d8b4f600fc7ec9725e26417030ee594f52 and changes
> function break_ksm_pmd_entry() to use folios.
> 
> This reverts break_ksm() to use walk_page_range_vma() instead of
> folio_walk_start().
> This will make it easier to later modify break_ksm() to perform a proper
> range walk.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
> ---
>   mm/ksm.c | 63 ++++++++++++++++++++++++++++++++++++++++++--------------
>   1 file changed, 47 insertions(+), 16 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 4f672f4f2140..922d2936e206 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -607,6 +607,47 @@ static inline bool ksm_test_exit(struct mm_struct *mm)
>   	return atomic_read(&mm->mm_users) == 0;
>   }
>   
> +static int break_ksm_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long next,
> +			struct mm_walk *walk)
> +{
> +	struct folio *folio = NULL;
> +	spinlock_t *ptl;
> +	pte_t *pte;
> +	pte_t ptent;
> +	int ret;
> +
> +	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
> +	if (!pte)
> +		return 0;
> +	ptent = ptep_get(pte);
> +	if (pte_present(ptent)) {
> +		folio = vm_normal_folio(walk->vma, addr, ptent);
> +	} else if (!pte_none(ptent)) {
> +		swp_entry_t entry = pte_to_swp_entry(ptent);
> +
> +		/*
> +		 * As KSM pages remain KSM pages until freed, no need to wait
> +		 * here for migration to end.
> +		 */
> +		if (is_migration_entry(entry))
> +			folio = pfn_swap_entry_folio(entry);
> +	}
> +	/* return 1 if the page is an normal ksm page or KSM-placed zero page */
> +	ret = (folio && folio_test_ksm(folio)) || is_ksm_zero_pte(ptent);

Staring again, we should really call is_ksm_zero_pte() only if we know 
the folio is present.

It's not super dangerous in the old code (because we would only look at 
present an migration entries), but now you are making it possible to 
call it on even more non-present ptes.

With that handled

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

