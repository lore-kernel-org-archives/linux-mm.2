Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9083ECCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 09:05:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F04AA80027; Mon, 27 Oct 2025 05:05:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDC188000A; Mon, 27 Oct 2025 05:05:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF1DC80027; Mon, 27 Oct 2025 05:05:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C998A8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 05:05:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C93748E1A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:05:34 +0000 (UTC)
X-FDA: 84043310988.24.DEB6A0F
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id C119F80013
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:05:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xrsvdXAL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761555932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5NrdA8zghIW2EEF1Iqq/Rrvu3dfufJEJ150yLue2lTE=;
	b=qLAy1WgXthdIRNI3ELnJfgz6Whr69awn2gu7hlTspsf1E+hmgflSKGrg27UAqQbBZPV6lW
	+3iUQAcL8VbbqtrDvTQVo8U2LdwXhIHss/0/vn/ZIwDoiqN16Z82mP6Pu+h9oNgUkZGtqS
	joSyjkGM7/huDtLFhXJGegGXssO4GOg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761555933; a=rsa-sha256;
	cv=none;
	b=geOwg1biQcJDjerj8HbgRn+hFD5Wo0MGcFrvphzJwAX8zn1/pmyvMYLqCAhxvPL/mVZFUy
	/p6pAyJYptGzTzwmBIagYhmMfkS9hXop9EkE6ag1lJNzfuXGiEONrKwBPM5/ZvV+PgQua1
	sb/JSFRLOVfPljP4frqsDFTPev1h5Co=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xrsvdXAL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
Message-ID: <8c44810e-e687-44e1-bbe9-2e64a72b9e2b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761555929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5NrdA8zghIW2EEF1Iqq/Rrvu3dfufJEJ150yLue2lTE=;
	b=xrsvdXAL+FTmsqE5XZlLIYk3hLO05tn4wf4XrAQxTSY2hAzpq9hOE7VfsMnMXWnNb7O7gx
	+/dCgCMymwRQkjaJEFGH/4IssLmoCNbzC35zQLwUjxp05uX8UHGNBuPTfd2YIBsM/JfR1j
	nuocz7EbvsLcqRtfehjSxRmitH+n7aQ=
Date: Mon, 27 Oct 2025 17:05:03 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v12 mm-new 04/15] khugepaged: generalize
 alloc_charge_folio()
Content-Language: en-US
To: Nico Pache <npache@redhat.com>, dev.jain@arm.com
Cc: david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
 baohua@kernel.org, linux-trace-kernel@vger.kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, linux-mm@kvack.org,
 usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
 linux-kernel@vger.kernel.org, cl@gentwo.org, jglisse@google.com,
 surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org,
 rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org,
 hughd@google.com, richard.weiyang@gmail.com, vbabka@suse.cz,
 rppt@kernel.org, jannh@google.com, pfalcato@suse.de,
 linux-doc@vger.kernel.org
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-5-npache@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251022183717.70829-5-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: C119F80013
X-Rspamd-Server: rspam02
X-Stat-Signature: 7uf83bnbx47473zhhnmy6j7wocmaqpbo
X-HE-Tag: 1761555932-272847
X-HE-Meta: U2FsdGVkX1+FQoIcQAxOfdiyyNpcw0gy3Ns7WfUwLA9JApaSoNSP47illdAjMBR/ZUhQe1WgeFoB64QtCHB8ZitSc6BK+P1ceTUlwctJuyQEbsIXSYLsVoD4TttEsC1fyqan0SB3UGHbRyibOAFFRF3oVeNqTGAacGt/YNV+g/MFjCgumI+5XqU0NBZgloxNgfWyLb6VO8HePbaGP+x/8wz9cgvPsOoyZ05L7IvKq3sm0BGl0CLiP/z8c4ByvaALzGw/OBzNXuwa6R4W6avdfuqXIWAouvVJwrIYaNGXvA+DiEpM260VPtBce59R+p9v0oEkIbZmUqgWZMi9HxumjOBWoRsY6fwblfNYGYPNO/tvkRMLTFpyNjnTIw52EZg6tykZWgXjFVRnHWrF5QRwBZp7+cObJGgS2jbuEgQ/hk5+v2Bqzf7Ok1DUp66kKQm9WOhJQvYt/l5X8MnRZZ63iSQ6OOUUX2dJAhGOADjMrXJMMZuuGLyrUfaaDCN1J3UgKFujwLjADWS3EXc6xfskgB8ZMCQrQGFvI7yMzlBuaVHOHJu7rxXRydjSZvwPmIkanUq0DZisz3Q3K0hrxp9GQYXs4F17/vUSXOg9AFszYJ3CW5gdXLmNe16OBZ3X/kx57S7HhweOwY/LPZgvNfR2oTMe0sLvDmZGe+9W78wxEPxXc9kbL8Qm8tH9obmfb0ggIaXBGgspIn2hfVI574ZBPFgpGMfW13EJfHwjCvEDMonW+e/GUZoOu/zW1AerBZzHShv6Eu27P9yPpRkwFAO7IBcERlB8uRsMhLagUIs14jm/ic2M9qRODOhzupXz4W8Y3C6cipuRrU7a8rsvaSQ9IqeL1daqOYLVIc5YJu1sivgPrdY8zdCDqUkaX3w4k+XqR4GEWbBEye3f/MCJ4JdSb6nDTbRcZreQIrTduqSDijrqAPVLFmmmil5XCfYjCmEBC91WySbJtrmoU6rd4xK
 dndc/j3z
 XhhGOuVeMjQbAgt57+LRySh+tVF7vZxpumlHrwX9WHGx45XfjbUCcXzrHLbWwuorHxrgK65yaqrjzFfNF9eQ8+7LIK8rfpG/go2qr4WUC4A2KsTWO0tkOu+XlLe9tLCNPJJFjf7V3bAFTTxv86m1zIQ7iGZBBfOTp0sgqODev/F2SNcHlF+fC6Ef209FFiUMSrIYAkGO/IWPMAyLtvnxwzjV+umaVlcXjHNdBS4lcJ/fjS4rQD6TefAccXMpK9KfPzFakB5PRfa4pkBg6aG3I7aiq3CA224ZsjkxtNaDUgAnStr7EKqLoQVq9FKizTw/eIBbx5ww9MhfXuCXDUWxygmEMCmbbAHsBOFeySgyy0/4PeyOMB9WLkLR3DV6pTplgEcDOEk8Oq8GwMI0F79SUL4J4RmNVF35EEta7Z5FSzcK6ainlMPE6bqYd15g8kh+4L6O7pnOdtDFw3HNLVdvIB9KG7McO3frieJ/brjOMHCzq+gc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/23 02:37, Nico Pache wrote:
> From: Dev Jain <dev.jain@arm.com>
> 
> Pass order to alloc_charge_folio() and update mTHP statistics.
> 
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Co-developed-by: Nico Pache <npache@redhat.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---

Cool! LGTM.

Reviewed-by: Lance Yang <lance.yang@linux.dev>

>   Documentation/admin-guide/mm/transhuge.rst |  8 ++++++++
>   include/linux/huge_mm.h                    |  2 ++
>   mm/huge_memory.c                           |  4 ++++
>   mm/khugepaged.c                            | 17 +++++++++++------
>   4 files changed, 25 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> index 1654211cc6cf..13269a0074d4 100644
> --- a/Documentation/admin-guide/mm/transhuge.rst
> +++ b/Documentation/admin-guide/mm/transhuge.rst
> @@ -634,6 +634,14 @@ anon_fault_fallback_charge
>   	instead falls back to using huge pages with lower orders or
>   	small pages even though the allocation was successful.
>   
> +collapse_alloc
> +	is incremented every time a huge page is successfully allocated for a
> +	khugepaged collapse.
> +
> +collapse_alloc_failed
> +	is incremented every time a huge page allocation fails during a
> +	khugepaged collapse.
> +
>   zswpout
>   	is incremented every time a huge page is swapped out to zswap in one
>   	piece without splitting.
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 7698b3542c4f..3d29624c4f3f 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -128,6 +128,8 @@ enum mthp_stat_item {
>   	MTHP_STAT_ANON_FAULT_ALLOC,
>   	MTHP_STAT_ANON_FAULT_FALLBACK,
>   	MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE,
> +	MTHP_STAT_COLLAPSE_ALLOC,
> +	MTHP_STAT_COLLAPSE_ALLOC_FAILED,
>   	MTHP_STAT_ZSWPOUT,
>   	MTHP_STAT_SWPIN,
>   	MTHP_STAT_SWPIN_FALLBACK,
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 370ecfd6a182..0063d1ba926e 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -620,6 +620,8 @@ static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
>   DEFINE_MTHP_STAT_ATTR(anon_fault_alloc, MTHP_STAT_ANON_FAULT_ALLOC);
>   DEFINE_MTHP_STAT_ATTR(anon_fault_fallback, MTHP_STAT_ANON_FAULT_FALLBACK);
>   DEFINE_MTHP_STAT_ATTR(anon_fault_fallback_charge, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
> +DEFINE_MTHP_STAT_ATTR(collapse_alloc, MTHP_STAT_COLLAPSE_ALLOC);
> +DEFINE_MTHP_STAT_ATTR(collapse_alloc_failed, MTHP_STAT_COLLAPSE_ALLOC_FAILED);
>   DEFINE_MTHP_STAT_ATTR(zswpout, MTHP_STAT_ZSWPOUT);
>   DEFINE_MTHP_STAT_ATTR(swpin, MTHP_STAT_SWPIN);
>   DEFINE_MTHP_STAT_ATTR(swpin_fallback, MTHP_STAT_SWPIN_FALLBACK);
> @@ -685,6 +687,8 @@ static struct attribute *any_stats_attrs[] = {
>   #endif
>   	&split_attr.attr,
>   	&split_failed_attr.attr,
> +	&collapse_alloc_attr.attr,
> +	&collapse_alloc_failed_attr.attr,
>   	NULL,
>   };
>   
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 6cf8700823f9..36ee659acfbb 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1061,21 +1061,26 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
>   }
>   
>   static int alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
> -			      struct collapse_control *cc)
> +		struct collapse_control *cc, unsigned int order)
>   {
>   	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
>   		     GFP_TRANSHUGE);
>   	int node = collapse_find_target_node(cc);
>   	struct folio *folio;
>   
> -	folio = __folio_alloc(gfp, HPAGE_PMD_ORDER, node, &cc->alloc_nmask);
> +	folio = __folio_alloc(gfp, order, node, &cc->alloc_nmask);
>   	if (!folio) {
>   		*foliop = NULL;
> -		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
> +		if (order == HPAGE_PMD_ORDER)
> +			count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
> +		count_mthp_stat(order, MTHP_STAT_COLLAPSE_ALLOC_FAILED);
>   		return SCAN_ALLOC_HUGE_PAGE_FAIL;
>   	}
>   
> -	count_vm_event(THP_COLLAPSE_ALLOC);
> +	if (order == HPAGE_PMD_ORDER)
> +		count_vm_event(THP_COLLAPSE_ALLOC);
> +	count_mthp_stat(order, MTHP_STAT_COLLAPSE_ALLOC);
> +
>   	if (unlikely(mem_cgroup_charge(folio, mm, gfp))) {
>   		folio_put(folio);
>   		*foliop = NULL;
> @@ -1112,7 +1117,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>   	 */
>   	mmap_read_unlock(mm);
>   
> -	result = alloc_charge_folio(&folio, mm, cc);
> +	result = alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
>   	if (result != SCAN_SUCCEED)
>   		goto out_nolock;
>   
> @@ -1850,7 +1855,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
>   	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
>   	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
>   
> -	result = alloc_charge_folio(&new_folio, mm, cc);
> +	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
>   	if (result != SCAN_SUCCEED)
>   		goto out;
>   


