Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD17EC88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 15:33:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8E2E6B008A; Thu, 10 Sep 2026 11:33:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6E1D6B0092; Thu, 10 Sep 2026 11:33:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA4556B0095; Thu, 10 Sep 2026 11:33:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8BC2D6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:33:54 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F371C0575
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:33:53 +0000 (UTC)
X-FDA: 85198247946.25.4DEC9C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0184920008
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:33:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KdDDbRML;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789054432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T0epqV5gbHkPz2d74NV+5dIcH3lf6pVLxkh4OQ+Eipw=;
	b=VAmhfCTKcOh18+A9ct2ezrJbWeOpcv0jmRitj+MCNhMZTZbZnMn4iDrBK1QEDDzh585+yJ
	yFd52ATYH6jJEYEyDc6TG83PD8oWO+2CuFvML3Bs6ou5EzscItyImyH5Ww0OKEoepgOhsj
	dQHOvPXrahXt/tdaBkKO/cnJYAO8nNo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789054432;
	b=lApLq9wjNyJ7jXjcNlbYCVx5IIdlSay3jh/WTgaOYwykVASDagwpe1489JHoe8ZGKq9OBy
	NtYeYRnoF5bJaztc01vKjhmV6Rjhlq3DIgn41wMheShRuPBcbbtB6bEcF7EJTEEsFdiwIo
	Vuy1DAzgV5/wHTO6NyleVrjQkKOVOO8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KdDDbRML;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 659C460204;
	Thu, 10 Sep 2026 15:33:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418FB1F0089A;
	Thu, 10 Sep 2026 15:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789054431;
	bh=T0epqV5gbHkPz2d74NV+5dIcH3lf6pVLxkh4OQ+Eipw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KdDDbRMLbED9Znx79eAKT5mp0g8Y4nWLAM1RwHJ7AmB0lBDamspPwv36II27PhxOn
	 TFLSmoTAZQjnwKCnmroedpKF5cKvou9fGm1H6UJImd43xLglNADC73mU4aDK6VQoJR
	 57VRcYAAzV70o5fcf0uQb/arAtrocMlUfsaLJ2kdz7Qst4AJQv3QY6I3pJnOFolc6M
	 Zf143W1ASLG22ydPxnmBOqspFy1T0ksAefvQ71Mr/0p81qOshGnATZ7iMX2EvAJXZG
	 JNfDrhd3rM+WplgOdTlzlVzGC0n7rSkXqV4rjKIF1L54pYkbNsMcCeLsOeG/AAU1XP
	 e+NjTLkQ3qTwA==
Date: Thu, 10 Sep 2026 16:33:45 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Avi Weiss <thnkslprpt@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mm/memory: simplify error handling in
 insert_pages()
Message-ID: <aqLN0q5MpB1kQKKC@gremlin>
References: <cover.1788022178.git.thnkslprpt@gmail.com>
 <dd3a672c858b38c7525541b19a919e120c4e5a0e.1788022178.git.thnkslprpt@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd3a672c858b38c7525541b19a919e120c4e5a0e.1788022178.git.thnkslprpt@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0184920008
X-Stat-Signature: gk3qhf816dyj736azojh5sckg5cj5xmr
X-HE-Tag: 1789054431-328266
X-HE-Meta: U2FsdGVkX1+UZYFTWtub5fLYhc39A/vXgcL5EYw1ORxMKXbqBvI9rcZOldN1/Y2fVgl+LcZ5a8WMOiwvOr4btn6DVbb78vQVbAmZYA/z2M9q4nJNeruvq/yG5qYQWx01x5mOKCW6WbzdmPORwp1pjnUPdYO5qPWKg6ev4IzzR457o7ilieXl06B1JiG3K+p4xs5ub2RAeyIIqgkEjFL24TUGHHhAhx8Tkpdb9hSa4nGVxclvuB0KiLK4lENH0xtOeGbKoI7c5sU0nB2xvxQRM/auitJo+5UquYvzfq76pEmuoKPW7mXhs/jhfzyw5AnDGMCSg9ls/4qyAOjiekoac4128jDczTsK/G2cvJYUaN7NakE72Apq4Jw20a02yWVOMHQB6SBCpLBX+YVZpQCofRBbW2bAdcBzj5KJy1q39Ay5pj0aUT8jJR3gzIvFBXkxcU7hH/ABpJzVu3yGvLMwoNbbE72LK+uYhr8IM+OBxWW8cJqoiJ3wyz0O6JEGhU6GuADrUDsSdvBECrki2TeaC+lGKtSDY2QH6UA+k0Er4uWV77pppdxuoKsBwRwLXEsNDK6ioqszomFp8IHna3RIenPr9NXkFMkdgf4rAVynQ0EKVI1W3UwtAi1bdZixVaV5ekl3+Oz39+jBsds2KWwLo62S3mG4MNvdmSjZhjsvTxjEJwQBlCUlfueOiextfon1E1l8bubjDcENKDJ3lnEFUTjXWZjmr9uWiTYp5xKAwSf+ueIa/BFz+YD50lPr7dRYwJkuyJtc798ZGBtqrX2k9lHd6MmHkQ8zDN/aCLalhzcQZl4kbYKZ7mKhQ7pBfGVOPfShNZGPIP9BDOWeI8V1IxGzmrXB2Ox1Q8oR3BX9nOWBQGmt2Nv6HaXAW/2jOw7yrYrYPbyG4Wzg0K6Gd8S4DItfiEBZLcpr4boTYLtM5fl9k+TjQm/+ci2pD92lwf1MQdjT7G86ZG6SWeBzn/+
 3abOAj9+
 eolGH4PDCLdEE/yNsBOI3ftPZOe6ayvHnrFNyEnRaDyvQTxMVkPa7EQDLkhMg7Y8uLUSVsXkEKDlc4O7teREoYXKdOBUY4pC8EVsL6CEvVchFXQ2wuekO5CnD2Ri56FL+2ZrWlNehH+f7HYn9i2SOOyHggepicr0ONY2e3eY50i++6ebtk1MVVcy1D7tTrt4ExdRbR+GL0B5GyYl2jqumLabAPOAL1uZ9l1AbXDAG+5oZQUauRHL9pQW/5K59IjF8wpdYnueeX71glBBmC58JC+xXH/zL5G/4Rino8KqaaMWkp+WKj51wabz+HhPTzIOEzdGfazBqg/t/ZFXP1R/pURbnkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 29, 2026 at 08:11:12PM +0300, Avi Weiss wrote:
> Initialize error return status to zero and then set it as needed at each
> point of failure.
>
> Assign -ENOMEM explicitly when pte_alloc() fails as the pte_alloc()
> macro returns a boolean.
>
> Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/memory.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 9cbce5c90bff..2561dc6bdde6 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2565,20 +2565,22 @@ static int insert_pages(struct vm_area_struct *vma, unsigned long addr,
>  	unsigned long curr_page_idx = 0;
>  	unsigned long remaining_pages_total = *num;
>  	unsigned long pages_to_write_in_pmd;
> -	int ret;
> +	int err = 0;
>  more:
> -	ret = -EFAULT;
>  	pmd = walk_to_pmd(mm, addr);
> -	if (!pmd)
> +	if (!pmd) {
> +		err = -EFAULT;
>  		goto out;
> +	}
>
>  	pages_to_write_in_pmd = min_t(unsigned long,
>  		remaining_pages_total, PTRS_PER_PTE - pte_index(addr));
>
>  	/* Allocate the PTE if necessary; takes PMD lock once only. */
> -	ret = -ENOMEM;
> -	if (pte_alloc(mm, pmd))
> +	if (pte_alloc(mm, pmd)) {
> +		err = -ENOMEM;
>  		goto out;
> +	}
>
>  	while (pages_to_write_in_pmd) {
>  		int pte_idx = 0;
> @@ -2586,15 +2588,14 @@ static int insert_pages(struct vm_area_struct *vma, unsigned long addr,
>
>  		start_pte = pte_offset_map_lock(mm, pmd, addr, &pte_lock);
>  		if (!start_pte) {
> -			ret = -EFAULT;
> +			err = -EFAULT;
>  			goto out;
>  		}
>  		for (pte = start_pte; pte_idx < batch_size; ++pte, ++pte_idx) {
> -			int err = insert_page_in_batch_locked(vma, pte,
> -				addr, pages[curr_page_idx], prot);
> +			err = insert_page_in_batch_locked(vma, pte, addr,
> +							  pages[curr_page_idx], prot);
>  			if (unlikely(err)) {
>  				pte_unmap_unlock(start_pte, pte_lock);
> -				ret = err;
>  				remaining_pages_total -= pte_idx;
>  				goto out;
>  			}
> @@ -2607,10 +2608,9 @@ static int insert_pages(struct vm_area_struct *vma, unsigned long addr,
>  	}
>  	if (remaining_pages_total)
>  		goto more;
> -	ret = 0;
>  out:
>  	*num = remaining_pages_total;
> -	return ret;
> +	return err;
>  }
>
>  /**
> --
> 2.43.0
>

--
Cheers, Lorenzo

