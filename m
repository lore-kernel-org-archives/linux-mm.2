Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 165C9606A330
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 20:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ikPR7pJe
Received: by kanga.kvack.org (Postfix)
	id 0CBC16B05B1; Fri, 13 Nov 2026 15:48:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A3116B05BB; Fri, 13 Nov 2026 15:48:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFC616B05BC; Fri, 13 Nov 2026 15:48:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA6186B05B1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:48:47 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 64D4C1A0137
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:48:47 +0000 (UTC)
X-FDA: 85431284694.05.DB873FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id B6EAD180002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:48:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ikPR7pJe;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794602925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HbZ+0LydDJ6rcuj2MEvM/ZyS22hRjkKslj361gDn6Wg=;
	b=xOY6NM1ONKOfy1rchfpbRWYtjCVpSI5NVuqw79DTGrXNU0FRD4IHHIknVOIXjT65FSny6a
	KOYeha6b514p34OA2pWFm7zL9CmapO9Epimo2wdBnoTqNNAuuXEpdPPPUuNlIKeNZsuBT+
	bMjIwh1YU3POFSUTfSDzjDLyOAE+6WU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794602925;
	b=0+eYbYMnYgwoisaNj8WY+wmpP0nvIDkNXz5+Sjjf3JSF7xv/AcBZ+0e5SA5ZAQYusd1d2u
	lfJWqJLKII5ohJtFOLHeTA2gK+d/RwWm17z6/rmviRpt+wxALC6SUKAVFlFu5fsxkt9xqp
	4bDGZffac8zglC9mAf2BlT4V7mPI710=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ikPR7pJe;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EA540414C3;
	Fri, 13 Nov 2026 20:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB9B1F000CF;
	Fri, 13 Nov 2026 20:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794602924;
	bh=HbZ+0LydDJ6rcuj2MEvM/ZyS22hRjkKslj361gDn6Wg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ikPR7pJevGBa7Go85rNPXEZVUfBVgf/s0MJkuGJuESAF+idbRbGTE+B84+gCxM8x8
	 vL3li2nBMSJMMM96wmdfIu9JXpkzZji86uJ5QqLuOmaO68XarXA/+S9slrp8X83qZg
	 CFfeMV4/gjVZ21nmSuMOfs8xNVk+hg/FOS/2AqePaBlWCRfe1xE7wVKI9qEu34Z7zQ
	 CZB7C8Jgj43VDP16H7xpvd3SJn4KhnLKJrAXtzvcttnAJLmvfWZSvf7ArDNdbFNDUd
	 BIcWrUDH5dwLvlwlVUmJO9pALbhe70m6DPVhTPU3z4ROHr1eeU6+L8jBP7iit8QWX4
	 k1ZuepTwYyWdw==
Date: Fri, 13 Nov 2026 20:48:34 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Carlos =?utf-8?B?TMOzcGV6?= <clopez@suse.de>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-riscv@lists.infradead.org, seanjc@google.com, 
	pbonzini@redhat.com, akpm@linux-foundation.org, david@kernel.org, peterx@redhat.com, 
	imbrenda@linux.ibm.com, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH v3 3/9] mm/huge_memory: honor MM_CP_TRY_CHANGE_WRITABLE
 in change_huge_pud()
Message-ID: <avd0Cexmmu7kCN45@gremlin>
References: <20261112142039.907090-2-clopez@suse.de>
 <20261112142039.907090-5-clopez@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261112142039.907090-5-clopez@suse.de>
X-Stat-Signature: dyjhi1dz8w1tppyjz54ftohep66y7ydd
X-Rspamd-Queue-Id: B6EAD180002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794602925-559829
X-HE-Meta: U2FsdGVkX1/Bz/S3ybipuwHYSWBRJNpthwL99TxxOt4YdqTBfN47M8ZG+EY/Nj/7MvOqba4+pmvqMmMgTjQ4znd6A0FOJVNn2aBjcK+ouXfexOFbyBkCYRoOzKR/I66raee7338JvUeK9eCTVMHuDxi/TH2l6PAJ3r/7dNgxGBN2hcVUNruVcUufiDiIH3K+BtwjSRyJRY4fvab6uH5XSqGxs3aIFAvyhG7py32NuQXRcPOvXsgqaagvwBnE4dGreaQ+xbGBddQRqvxZn6akbxpXxAw7w9L+dOEliIZyfQ3dy+VFMbo7wn5HsgM3YYk2EkXAlZO8LNChpoSfpkiHbBk1sI256kHJDWrzBEblErD9IxeG+6m6ZpNohW4fTrfmLkzI1lL2epfzcMLGkpnUt0PU7iu4yNNSpaWzAXGTGXQLYsnGQHAJrMCmTHD73myjDHkXU0p2fflKNZDHGKVvDOKLiwxemtjaocl24xGRlE8Z8A+pB5dXgxCwqpXmLeD6b/3h4GtfXCmWzzy7GqfpKYDrVEnq/v9GB35AbUtDnCDTezovJL5sKWSVlboCn6T/eB1qknxhsoSYr/Ovp3uMlh1KhkbtLTc0zrC9jjDnje/2eFLjWPq8u4MnzYW77OhNuQjiJgFyz9VirxSWfILPrjZPU2zNg/aBd6U3gXqVOJO2RhrpL9ywmxY8N4te8xPVZaZKKI8ASy1+wQ4jdkPh+Mf6eSP9+Z4WKG+KFVudYhtaKbhs6j7R/L5wiOiZeQBB9MpJffhTDNzZ9x30VMpIVDIYS8deamX3TFkJAyQ0eHMCobukIlYxiKe/ajUid50cnUoOSb5NrsQxG8IgJIH9g++9C6y14lIamovJzI8kl24Hd7ZVtfp+s+loAkNVhuUDBhPs4U8seIAXWXNYiO0morA5ZQliwxjfn0THSMQSUpx6S2VcuSgb7ke/+nE/w6+dmQqQhiazWpqKgO5QUHY
 Q59t3COq
 IL5P1Y93ILw8LmiC8tnN6Gy+UKGDEmZGEU7xGaq+ZMLO7isj6wofsd+TKlmf6EDK5TyBJJQer/Ac8lfuqNfF4D/11YSo7o1Gj4AqE0RB2fldVsdNsLXfpScLLfHd1nqG5ECIO+SvU3YBUR+Rt/AkKmmFXd2LrJPKj5lthNiLwd0hslYw9Kn90sW9ar+DYN3KVlORpm9CTtC6dqy5ysitGkNpaRpW84HSFn319nyfF8+wi/QL7VUMZYbWmNCe6tCXJEqTJ0WJkB4C+D7ho++ep7z4Rw+iqAXgJnuRAEubciwru4F5LD2iFNf7RJYAkfOrMsJcOXabf4KZvzXQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 03:20:32PM +0100, Carlos López wrote:
> change_protection() applies vma->vm_page_prot, which lacks the write bit
> for CoW and write-notified mappings. MM_CP_TRY_CHANGE_WRITABLE makes
> entries writable again if a write fault would only set the write bit.
>
> However, change_huge_pud() ignores the flag. For example, device DAX
> mappings are write-notified once soft-dirty tracking is armed through
> /proc/pid/clear_refs, and a protection change then leaves dirty PUDs
> read-only, so the next write to each of them faults.
>
> Fix this by adding can_change_pud_writable(), based on
> can_change_pmd_writable(). It omits the NUMA and uffd-wp checks, as
> change_huge_pud() bails out on those changes.
>
> Signed-off-by: Carlos López <clopez@suse.de>

Is this a real problem that actual people have had?

The why of all this is still eluding me, especially for THP PUD...

> ---
>  include/linux/pgtable.h |  5 +++++
>  mm/huge_memory.c        | 28 +++++++++++++++++++++++++++-
>  2 files changed, 32 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 780fe849ff8b..943d7e95f426 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -1866,6 +1866,11 @@ static inline int pmd_soft_dirty(pmd_t pmd)
>  	return 0;
>  }
>
> +static inline int pud_soft_dirty(pud_t pud)
> +{
> +	return 0;
> +}
> +
>  static inline pte_t pte_mksoft_dirty(pte_t pte)
>  {
>  	return pte;
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index eb913acb03b7..080b718eb7de 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2833,6 +2833,29 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  	return ret;
>  }
>
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> +static inline bool can_change_pud_writable(struct vm_area_struct *vma,
> +					   unsigned long addr, pud_t pud)
> +{
> +	struct page *page;
> +
> +	if (WARN_ON_ONCE(!(vma->vm_flags & VM_WRITE)))
> +		return false;
> +
> +	/* Do we need write faults for softdirty tracking? */
> +	if (vma_soft_dirty_enabled(vma) && !pud_soft_dirty(pud))
> +		return false;
> +
> +	if (!(vma->vm_flags & VM_SHARED)) {

This is getting annoying now, you're seemingly _knowingly_ writing deprecated
VMA flag API code on purpose.

> +		/* See can_change_pte_writable(). */
> +		page = vm_normal_page_pud(vma, addr, pud);
> +		return page && PageAnon(page) && PageAnonExclusive(page);
> +	}
> +
> +	/* See can_change_pte_writable(). */
> +	return pud_dirty(pud);
> +}
> +
>  /*
>   * Returns:
>   *
> @@ -2840,7 +2863,6 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   * - 1: if pud can be skipped
>   * - HPAGE_PUD_NR: if pud was successfully processed
>   */
> -#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>  int change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  		    pud_t *pudp, unsigned long addr, pgprot_t newprot,
>  		    unsigned long cp_flags)
> @@ -2872,6 +2894,10 @@ int change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  	 */
>  	oldpud = pudp_invalidate(vma, addr, pudp);
>  	entry = pud_modify(oldpud, newprot);
> +	/* See change_pte_range(). */
> +	if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) && !pud_write(entry) &&
> +	    can_change_pud_writable(vma, addr, entry))
> +		entry = pud_mkwrite(entry);
>  	set_pud_at(mm, addr, pudp, entry);
>  	tlb_flush_pud_range(tlb, addr, HPAGE_PUD_SIZE);
>
> --
> 2.51.0
>

--
Cheers, Lorenzo

