Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7331FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 07:16:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 495D06B008C; Tue, 28 Apr 2026 03:16:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46D7D6B0096; Tue, 28 Apr 2026 03:16:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AB0A6B009D; Tue, 28 Apr 2026 03:16:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 256DA6B008C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:16:01 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BDC76A0414
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:16:00 +0000 (UTC)
X-FDA: 84707105280.18.AA173DA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1352E1A0007
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:15:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J7emyAvV;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777360559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b2nIdXZGtzZPRfGZ55biL1KoKrGDTk439ANvyPc2tGY=;
	b=7vBQgK1f8WdEPdFSGUhTLhuk2brJBejsfeRRfGZFYRlg7RBww5ewl+56jDiiz5/UZnLcPX
	Ea0Vt2m4vvnlpW6ZHCpJ7n+5HRoksY+Ws2z49B/43MvHGDNmLtpVL7PXhfXj7Du3WP7BtP
	bC+sPxeAW/546QRB4iUXXZso0PdJrnM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J7emyAvV;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777360559; a=rsa-sha256;
	cv=none;
	b=l1FSoPsY+NC+XFa/xD5kSUwZHYKGB6P8rZiLyLMJDVcOG7s/uQQsuoyGtgXTawqZhUaA7L
	9qLKb+k7fy7JVp38yKW9kYKSnPcIyhspOVrqxNJiLz7jLZGsDWaXfwLX8qP2s444wkobb1
	QphzGL3lHQHG0ER36mEPP/O7/hZp/8Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6EF4660133;
	Tue, 28 Apr 2026 07:15:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B73C2BCAF;
	Tue, 28 Apr 2026 07:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777360558;
	bh=YiFruMllP7Hsn3RHqR+ow3axxP/rEMVw7OY4f6H0hUA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J7emyAvVkk5SF6YOCLb8Y6pqahYtojSzc7QFL7eGIX96o8UFPF7U8LVVpvE0x9Mk7
	 Ty0vbdH2dMMfYs2hMMMhiZn/zWghIbN4G3dIE0Jl6pW7My2PDE+h1b25J8vIHXxvGP
	 kfv7o1zD5vW7RJCpOIHOEMo49bkkt4KWfvYPK4a2u9AXIUAouI6uvxRYz1RxLIwebM
	 JUjL7+O8rG78bTKN6CjujeXTzjkKsEdbigh7zQz37K4Jcens/Wi4hegeBHcLeKudHj
	 7svjSLPqxKPID34kBHjSqsByE0hxRF2eFGqcsr+QIx6tzWdJ95jOHn8IGasqmiROzI
	 PCudJwjRJIc8g==
Date: Tue, 28 Apr 2026 09:15:48 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/49] mm: defer sparse_init() until after zone
 initialization
Message-ID: <afBepGBqlKTyOFob@kernel.org>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-12-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260405125240.2558577-12-songmuchun@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1352E1A0007
X-Stat-Signature: usyh5ms4y5qmpy5munb46mjc3j5exng9
X-HE-Tag: 1777360558-633060
X-HE-Meta: U2FsdGVkX19aRM6CiGARZLCURB9StBPHlDq/9+WuRQOx59QNtVgcN/Ca/Fe4/E98CWd7YjETc2GJXj+RFrbuU5tHReKD+agKlr6KWk7+MLMx3eGrIQthtCptF/92z1lCDX/c8yZNKLC0TA3FLvymKgVI2jALtgE2MokBpUn3seAL4jS0Q9c+7yFRe1Ptwrx38JDeogJG6aCxobkPRjtvkNDbAjr/4pJlbViCjOl727MtkCLRcT8RN3CiWWmpt9NnVsh9e7JT2tGtECHp7hrcWcM0Y6H/jWMTZfa4MrSAi5sATO0qAX2fMpXh6as57Xapu2dIJV2h9r6yCXx0IBcOjHCWq5RThYcv3sT2teysBxUsnZTbBSzN06YvyDpulAvCR1eY4MwEPJfYrLE2l1nA3seXCBZYPc+P4/AuE6+AvjPPqiDVWDmku8nTrXPUD7P0iatzQywcl1rQnOurpeA9ZJZzScKFdKTqycUwc2nDrWnJeXmxpyw2n0hcmimzPLEYdhMpJUBMxUP+eQaZXRyNuo7xO5EqNb8JZpg5JJdw6L8YQ7OJ7dA3/XQWfN8YsSdJDIQUfp+xbSNqwPKLz1OVbMA0Ghr2A8ezJZpHGhgeNF/jHDHJMFvgWg2+cbiZZ7m8+PmWbbf6MPgmV+z213oRAZRus18CYFFINZ35w9elU22HB0DpM80HVh3O0l0wIkWmbkCKtPLOcBbmx3zPK7P0esdxUvNhCjucHrrrPWf6xRY8p/a+0LIjmylYrAu4xYnMSzwW3kVRiZL2U+JtPz9t5SUkbjZxZDyvJLJQlpgxvAJZBwedPy6vUgTKfgmoa6lbcBaziSyH/MH8Q/LWWm6aBk+s1rJFH+xSIdXIvwACBEJXZ5lXs4VQql82Yl7B02tmB39jEw+AGn8x6/CIugw4NpRZGb3VKGauBk3lOErsnPwHvWNy3uiZ/vlCD9EV4UN36PA4zfE4MgxQ6YZn9+H
 qrmwVny+
 9E52+sfgRVHZTdpHLN//u8ooA0wqGGGyOtUF8O4NoSmZRHi0mvVLNx5UFShhDJ1luWOEd/eISrZCyokR+pKNkPwCraGzv8+mTN0oelBM/LL6AiWEdsVq4A7RYf5Ua7OKZcndtA1MI0YfXV2/Tx+xyfDNo4Eb8qhOfTXjKO6J4BpxtQrtP8bguZaayP7xnmWsvboJVUxvQgOZtqL9Hw0CDLmqWNuDaf/KsX5G7CHwK+c5LhveaJekEb0+b1h4pP0DjxMJt4YKXomPov/+jI5DfCP7lbIE7dEmJ37ca0UasuTi1t1sIYFvVwSlbCbfb92UcajBTbldZy4opuxmdkdAQoj1O6KuaMJ5+9Cwk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 05, 2026 at 08:52:02PM +0800, Muchun Song wrote:
> According to the comment of free_area_init(), its main goal is to
> initialise all pg_data_t and zone data. However, sparse_init() and
> memmap_init() are aimed at allocating vmemmap pages and initializing
> struct page respectively, which differs from the goal of free_area_init().
> Therefore, it is reasonable to move them out of free_area_init().
> 
> Call sparse_init() after free_area_init() to guarantee that zone data
> structures are available when sparse_init() executes. This change is a
> prerequisite for integrating vmemmap initialization steps and allows
> sparse_init() to safely access zone information if needed (e.g. HVO case).
> 
> Also, move hugetlb reservation functions (hugetlb_cma_reserve() and
> hugetlb_bootmem_alloc()) to be after free_area_init(). This allows
> hugetlb reservation to access zone information to ensure that contiguous
> pages are not allocated across zone boundaries, which simplifies the
> hugetlb code. So this is a preparation for subsequent changes.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  mm/mm_init.c | 15 ++++++++-------
>  mm/sparse.c  |  3 ---
>  2 files changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/sparse.c b/mm/sparse.c
> index c7f91dc2e5b5..5fe0a7e66775 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -406,9 +406,6 @@ void __init sparse_init(void)
>  	pnum_begin = first_present_section_nr();
>  	nid_begin = sparse_early_nid(__nr_to_section(pnum_begin));
>  
> -	/* Setup pageblock_order for HUGETLB_PAGE_SIZE_VARIABLE */
> -	set_pageblock_order();
> -

This does not seem related to this patch. Otherwise

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

>  	for_each_present_section_nr(pnum_begin + 1, pnum_end) {
>  		int nid = sparse_early_nid(__nr_to_section(pnum_end));
>  
> -- 
> 2.20.1
> 

-- 
Sincerely yours,
Mike.

