Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7067CD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 11:56:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1ECE16B0005; Mon, 18 May 2026 07:56:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19DDF6B0088; Mon, 18 May 2026 07:56:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08D416B008C; Mon, 18 May 2026 07:56:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EEB816B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 07:56:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8F5BF120902
	for <linux-mm@kvack.org>; Mon, 18 May 2026 11:56:08 +0000 (UTC)
X-FDA: 84780387216.18.020BF42
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id C399140003
	for <linux-mm@kvack.org>; Mon, 18 May 2026 11:56:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rdqyiaYq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779105367; a=rsa-sha256;
	cv=none;
	b=2ZhlInMcd59bogUcKiPHpe4GtkUOViWXxIqWAhPkdY73QS4QR1mLdZpyjQtwSNWuIfPqgt
	+aFVOMdsi0DbKqgJ6tIw9htUOT0kOmbCRVjiVsO5LwdpnVQJ1K3hd4cKQwqDnile/1cJYQ
	+6Uuq4pArwHZ30mWRDkui8aYFPbNQQk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rdqyiaYq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779105367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0LJeLV2647C+GmwKXUyT3/UeLI1LWOfAc30rkgrn0ms=;
	b=llbiE+VPBRwZYeGdRzi1uqy20GajHd/SfL8UjIjcfNJ+uQw7e3hDy97QJ50ZUzqLOadzNl
	f9jtf70HCyNHNXPAm61UckEzqYD8ThgAsTImqUQOviwxNmO234qg9VMD4EvIkNJsPChck9
	KIukcS0Km8qCEyhoFZcDniqznisf4u0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779105363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0LJeLV2647C+GmwKXUyT3/UeLI1LWOfAc30rkgrn0ms=;
	b=rdqyiaYqPu/3PGr8wI8hiBGi8r49XAev4HhrQSjq2yn+GuqjVSomehva6Vv/1joKeJCYm2
	AxIJ3YQcKZvuKJIYrgCvb5HhkMUwLM11PF58ri2ZAi6OeIw3qVQINowz/X6q9sDGDsbjVE
	cg+Xr8pxJdU77R/0uRSV3F7ivZO1xE4=
From: Usama Arif <usama.arif@linux.dev>
To: Nico Pache <npache@redhat.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	ljs@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com
Subject: Re: [PATCH mm-unstable v17 02/14] mm/khugepaged: generalize alloc_charge_folio()
Date: Mon, 18 May 2026 04:55:51 -0700
Message-ID: <20260518115553.3513034-1-usama.arif@linux.dev>
In-Reply-To: <20260511185817.686831-3-npache@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ccbgqwsi1izuw3jpntps3e6th4wbjrcq
X-Rspam-User: 
X-Rspamd-Queue-Id: C399140003
X-Rspamd-Server: rspam07
X-HE-Tag: 1779105366-134786
X-HE-Meta: U2FsdGVkX1/Z4oYwca6QsmVSsa07ZJaZo13sI8uJitBitK2r75sBHxQkma7WoOFIzKDucxcrRTEOuGNJ5HWIMhcp2iVX6cyz4xZr/slkfu58xQzuFXO3r21hpSFeJsLfg4++ztgvdw/TE8f/Zd+1MrCZgbZahJE6G1vgBBoN9H8eRbxQoTB7xNwMSTD8CHniQSgIM24/qhI55kfYPrpmaD+OawxkKRH9qLLd4DFKMMF/m5axbt3o/D2VtIej4JDovYtAzIolEZSo8Uzx7zhSfbiziCkTC5TOh2I+t0gMDfiAOi13TncXMUOElh885h8fZyzdlyR58KLqRhmnteu2jrEjsadVqLrahkWRitweBwXSswK53ckVPKfAnOwJ2bawrl3BMt2a6SdZIoTGQwaowyWuagzs36mmXZFr8Z+LVluh3irlvPYyAw34maCjlPzxJobZU6XB4GiPU5Xn4mjHTOrT5cjwvPQO58yzkA1RLNydM/oBNPM2GtQ+ND87Aid08nQepJ3ZhDVMKHEsXj41ipo7PFfXT6vpfH19cb1TQEhnB/xRCG72RJ8p+8nvq84U8dFZGdyR+qfwgp8UZgo+txDDdV22HesFoWIDBmhohGpCvPb+moKMMCUivFMcSjPonoI54pF8N7+cHDjB1oZqVvBdG4dki0Jd5hDRxhaz6yqvPX1J+nUQnFAaDp5Zmhxk27AFg/jqQcF+5VzlWG+Ll+DlfkxzIhWliM8P6QkuAAqf2rPVTMxEF30h+4JebEZqEq/5HlLVDhKfTzQ5dcAT9aeVW8KihmiKtQxmyJsXOWfBhIflLStDYq796yZ3QlLwXWDx6Mk6CrLA3ZASPjvQ4CXNthgxIGblwxZp2WGgO08+hdz2hG6S0TwPoQlxcvF1/jKsAfjybItBMq+Wx1fdHzd8m6qpAW/eyrDBVSZx6DKx56D1DsEwowZukYkXFS3QKx3xgjL/JijuEHHNELP
 LP8aXHh7
 bfz/EVqCEQB3MgZv+BEYZuTKdY3kjK7cYP1U7tnbITRklztK8qDjFMcH2sCUyQbJwyfnIAF8LS7wXeb5wfS0fydD0+zMwWM9qopFOcnR3rhjt8/H/80BhLfKceZmVR+5cBY4JhWfvT5By23h090/jRS7Ymeth9iPSaRq99I6CDQ0mW9oZA4+cJNKZAzVwSxnuKNBrn2kI9Ru8VJ12qNIvr/CIETRDFy0ow2SC6WydBKRi7WcZYcUVRtq17lnsY1a1vqlTkzrsZzSvx5nDOy4dsiOKlw6tf4BOC9YiTmyo1/ulM2xY98zKTXuGq1LsdwO1gU5C0aQz1JV/wDJGaq+y96hy/JQD4BpT4MMOCT+7a6wXrAJKYL9rDUe+5zObziLHZ7Uxo6C9gE1K6rT47PNkRxs1xR1wqpTmxvtzXh3+aKKaDCuaHwLaeCJpefms8oSkaTGTpjiyxOCoEIU7GD1DXDlN58AFQUv6sH2O7ieb3ZIteBL+0ndzy8izhlIODjUGtoaXSSFO3KGUlUuEBMWtxunqOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 11 May 2026 12:58:02 -0600 Nico Pache <npache@redhat.com> wrote:

> From: Dev Jain <dev.jain@arm.com>
> 
> Pass order to alloc_charge_folio() and update mTHP statistics.
> 
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> Co-developed-by: Nico Pache <npache@redhat.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  Documentation/admin-guide/mm/transhuge.rst |  8 ++++++++
>  include/linux/huge_mm.h                    |  2 ++
>  mm/huge_memory.c                           |  4 ++++
>  mm/khugepaged.c                            | 17 +++++++++++------
>  4 files changed, 25 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> index 5fbc3d89bb07..c51932e6275d 100644
> --- a/Documentation/admin-guide/mm/transhuge.rst
> +++ b/Documentation/admin-guide/mm/transhuge.rst
> @@ -639,6 +639,14 @@ anon_fault_fallback_charge
>  	instead falls back to using huge pages with lower orders or
>  	small pages even though the allocation was successful.
>  
> +collapse_alloc
> +	is incremented every time a huge page is successfully allocated for a
> +	khugepaged collapse.
> +
> +collapse_alloc_failed
> +	is incremented every time a huge page allocation fails during a
> +	khugepaged collapse.
> +
>  zswpout
>  	is incremented every time a huge page is swapped out to zswap in one
>  	piece without splitting.
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 2949e5acff35..ba7ae6808544 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -128,6 +128,8 @@ enum mthp_stat_item {
>  	MTHP_STAT_ANON_FAULT_ALLOC,
>  	MTHP_STAT_ANON_FAULT_FALLBACK,
>  	MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE,
> +	MTHP_STAT_COLLAPSE_ALLOC,
> +	MTHP_STAT_COLLAPSE_ALLOC_FAILED,
>  	MTHP_STAT_ZSWPOUT,
>  	MTHP_STAT_SWPIN,
>  	MTHP_STAT_SWPIN_FALLBACK,
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index e9d499da0ac7..05f482a72a89 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -699,6 +699,8 @@ static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
>  DEFINE_MTHP_STAT_ATTR(anon_fault_alloc, MTHP_STAT_ANON_FAULT_ALLOC);
>  DEFINE_MTHP_STAT_ATTR(anon_fault_fallback, MTHP_STAT_ANON_FAULT_FALLBACK);
>  DEFINE_MTHP_STAT_ATTR(anon_fault_fallback_charge, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
> +DEFINE_MTHP_STAT_ATTR(collapse_alloc, MTHP_STAT_COLLAPSE_ALLOC);
> +DEFINE_MTHP_STAT_ATTR(collapse_alloc_failed, MTHP_STAT_COLLAPSE_ALLOC_FAILED);
>  DEFINE_MTHP_STAT_ATTR(zswpout, MTHP_STAT_ZSWPOUT);
>  DEFINE_MTHP_STAT_ATTR(swpin, MTHP_STAT_SWPIN);
>  DEFINE_MTHP_STAT_ATTR(swpin_fallback, MTHP_STAT_SWPIN_FALLBACK);
> @@ -764,6 +766,8 @@ static struct attribute *any_stats_attrs[] = {
>  #endif
>  	&split_attr.attr,
>  	&split_failed_attr.attr,
> +	&collapse_alloc_attr.attr,
> +	&collapse_alloc_failed_attr.attr,
>  	NULL,
>  };
>  
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 979885694351..f0e29d5c7b1f 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1068,21 +1068,26 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
>  }
>  
>  static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
> -		struct collapse_control *cc)
> +		struct collapse_control *cc, unsigned int order)
>  {
>  	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
>  		     GFP_TRANSHUGE);
>  	int node = collapse_find_target_node(cc);
>  	struct folio *folio;
>  
> -	folio = __folio_alloc(gfp, HPAGE_PMD_ORDER, node, &cc->alloc_nmask);
> +	folio = __folio_alloc(gfp, order, node, &cc->alloc_nmask);
>  	if (!folio) {
>  		*foliop = NULL;
> -		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
> +		if (is_pmd_order(order))
> +			count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
> +		count_mthp_stat(order, MTHP_STAT_COLLAPSE_ALLOC_FAILED);
>  		return SCAN_ALLOC_HUGE_PAGE_FAIL;
>  	}
>  
> -	count_vm_event(THP_COLLAPSE_ALLOC);
> +	if (is_pmd_order(order))
> +		count_vm_event(THP_COLLAPSE_ALLOC);
> +	count_mthp_stat(order, MTHP_STAT_COLLAPSE_ALLOC);
> +

The vmstat THP_COLLAPSE_ALLOC counter is pmd order only.
But after this we have

	count_memcg_folio_events(folio, THP_COLLAPSE_ALLOC, 1);

which is not being guarded with is_pmd_order().

I think we want this to be pmd order only as well so that
the meaning of the vmstat and cgroup counter remains the same?


>  	if (unlikely(mem_cgroup_charge(folio, mm, gfp))) {
>  		folio_put(folio);
>  		*foliop = NULL;
> @@ -1118,7 +1123,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  	 */
>  	mmap_read_unlock(mm);
>  
> -	result = alloc_charge_folio(&folio, mm, cc);
> +	result = alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
>  	if (result != SCAN_SUCCEED)
>  		goto out_nolock;
>  
> @@ -1899,7 +1904,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
>  	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
>  
> -	result = alloc_charge_folio(&new_folio, mm, cc);
> +	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
>  	if (result != SCAN_SUCCEED)
>  		goto out;
>  
> -- 
> 2.54.0
> 
> 

