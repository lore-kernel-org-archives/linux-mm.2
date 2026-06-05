Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45323CD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 17:47:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9883C6B0095; Fri,  5 Jun 2026 13:47:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 939BD6B0096; Fri,  5 Jun 2026 13:47:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 827CE6B0098; Fri,  5 Jun 2026 13:47:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6EA486B0095
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:47:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 033DA12022B
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:47:01 +0000 (UTC)
X-FDA: 84846589884.24.54B0DE5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6C429180005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:47:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lkio3xuU;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780681620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eogvnYwd7EDRot4mePyIFCuCOhQe1D4un50SJ/87W34=;
	b=QbVcRsfrqyhVHnIWUxn4B2ZMNp8e/KRuSRm9Z6fHnCGj9HET/RcQLWje6K3FvuLK8a6E2c
	R2E8snd8C5XyWYDB7jZ5LylBCdHVeFm6BmEMV1IfvZLrmSGPvU5eclZ3UKpTbJXrTHpQtw
	KNJzSEMRrStd3wixqJOT3UViD/6lLG8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lkio3xuU;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780681620;
	b=dyM0JpRq4F771Z19AwGskwOzVkeyD+8aFnQfxHK4t4AbfBJk1M59M6rzyrzS2JSd32bpHq
	nrigmHqEMZxX6kYR6c08Mw4dWhO/1gDlBJEdL+385r2ni+9hNMDmnlQyjvBDYmXhpfIYCz
	FrFO3eu7GunXmO1KIcdcjhfwLU4+mmc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D47E5601DD;
	Fri,  5 Jun 2026 17:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43EBB1F00893;
	Fri,  5 Jun 2026 17:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780681619;
	bh=eogvnYwd7EDRot4mePyIFCuCOhQe1D4un50SJ/87W34=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Lkio3xuUd5AU8UgtD6c6jGLmmu91MDtI3qCGmPWKBE6IYaEtIGnF9GHeQHXMlqCJ4
	 5JvPvUv0EkXz3IFmbmdVFNnQZ25aWUK2JMzsGxmBWYu8nbNku41yXG5xOv8FipfYdD
	 D9pf8Fdw7S4H2c68KzK8dYzavYASaND5XbGPAVhuzklqIhvvilD7IyvfGZZs+B/6HA
	 DZbpId7SXoZMLhYEA6v1og+j2EK3mC089lWwt7szg4fYJSBdpwH4UNaSKnioZ9/7GJ
	 Z9C8RXPS5BOQesIkLOZBUb27B/5L0roWBlWC3kf6XEBsOSgoCMUxgk7MDxmeMC4eiR
	 OMcDZbFBvVylQ==
Date: Fri, 5 Jun 2026 18:46:44 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, liam@infradead.org, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v19 10/14] mm/khugepaged: introduce
 collapse_possible_orders helper functions
Message-ID: <aiMLMMtBBsJb3-3N@lucifer>
References: <20260605161422.213817-1-npache@redhat.com>
 <20260605161422.213817-11-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260605161422.213817-11-npache@redhat.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6C429180005
X-Stat-Signature: z3afydubh6hdk34f5bs87i6gp43t4s9u
X-Rspam-User: 
X-HE-Tag: 1780681620-172666
X-HE-Meta: U2FsdGVkX1/IxSg8+s8/eioVL3G+8EW1Pdoza5JwC93Dnc9HEdOh6eQ1AN21SPNWWcAXDMyy5NPT3qOcLiJzCfKmpdDMUjMRyOb9k/QBBhiSWSDe16+Izc7xdpKRdSE/s1x96LY2B/5bMIJZAwqeSKKFqm3cdoIx2s8tnywNd9kFeR6ZU+ayhGr/nC3Q68ONP+2UtROIZqxDdjXJGs7PnyZlPyr5v147nYcqwgz8fKPHcZlRfmXKiQIQcJYHRd6vOSEO7tsSGPTErzfIvrwXSlW7n7CSnrsHkOhXseoEeFag02ILSJlNnvriopyWmmT2rKtbuhYxG09Xyoi1gifZS7v+ywmu5sQt8POHRiENY7c76fqMNg518NFXcf3o53Hxi6tBIJXywCGzrvDpSueRMLY+EZDyWJ8e1/sDOwYQOZBn4XXeWCRJlmxJScKH3b28Xj0hPZ9EYiLkY3sPEj3pITDcOlOEkQW2hgVSppGBF4VPZvYa1TNonIH2IRCdhRr3C13qnSBRQVFQaNaQCbp71zvnSRXu7rA0sxLGHXTI/TPWM3Xz5FrlzUGsAHIYM5iq36RlapIhIjwHcrbQsitEJ747qkCyaarMvjipNUuMMq6lQSya14wrxoJ3mbRWBq/M4K7dNskxF7Ay59eZso/W3j5Kfmhi3qYC8moXg03W7vqzdnwqLZTGmNa66ao3LadsPLSAfDm60j/odUqibjs0FB/c4MHsSyxW8IvvqvMb08KMy9wo3IMCODcWPkhorR42ZRrQ0mwjUZbknara/igRRlGaywTJINZhjZALypEfOolLsOWCNVXVhI64jGAQhdyZEVnrV00zX+fsVjTuEzPkvK7YdyJm+fDm0RC5Tge1rfQvWTJehGnHl+DqXJ8HVrP4xwI1bwHwu08WPVuz/e8L3yVH9yjsCFTbFFyfDCJlYtFRv5dLeAQZGA86vTUe9Epv3TvDZTuQIm1u2XQCstg
 q41MoYXA
 A6tZbwQgeqnBxxdTxYhZ7rFCP3DotikD/E8q213IpTerk26unb1NhY2uReTw4PnuUZjx3uK/v5Z6fSvFxhEO8x1ApGTg3d1L230e10mMaX69gnldHw+VKesPWaKZT0hQUw6rrZoDctEXRq6/ivZRauwXa7y9nN9nluNzSgag/FhlGQEjNRYT9+g9im3fdifrRXEaQxkb+gtL/Cz/kbqMCjJwz25Kyem0TTpryOPQ81KRS0PugxeOIhazxDotsD9KyZhzWx4oLl70jQpsPvZUUydORpRMWtrNU9rO4uvdZkWhB3oesQcvrDxBuetVoWpO86y3Je5zDhWd8zFf+N/DJy2FnjSfCi2DAiw/EcBjyYbInurs7LV9NSXhEqvAdFG7m3ITmb7eCTPDHThUPHXzgrQOHyn6OXlW7OcneW9Y8xm1SzZ1W7uSns2ZLf4naABPGFNI2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 05, 2026 at 10:14:17AM -0600, Nico Pache wrote:
> Add collapse_possible_orders() to generalize THP order eligibility. The
> function determines which THP orders are permitted based on collapse
> context (khugepaged vs madv_collapse). We also add collapse_possible()
> as a thin wrapper around collapse_possible_orders() that returns a bool
> rather than the whole bitmap.
>
> This consolidates collapse configuration logic and provides a clean
> interface for future mTHP collapse support where the orders may be
> different.
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Nico Pache <npache@redhat.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  mm/khugepaged.c | 24 +++++++++++++++++++++---
>  1 file changed, 21 insertions(+), 3 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 26c343a6fa3d..ec886a031952 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -554,12 +554,30 @@ void __khugepaged_enter(struct mm_struct *mm)
>  		wake_up_interruptible(&khugepaged_wait);
>  }
>
> +/*
> + * Check what orders are possible based on the vma and collapse type.
> + * This is used to determine if mTHP collapse is a viable option.
> + */
> +static unsigned long collapse_possible_orders(struct vm_area_struct *vma,
> +		vm_flags_t vm_flags, enum tva_type tva_flags)
> +{
> +	const unsigned long orders = BIT(HPAGE_PMD_ORDER);
> +
> +	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
> +}
> +
> +static bool collapse_possible(struct vm_area_struct *vma,
> +		vm_flags_t vm_flags, enum tva_type tva_flags)
> +{
> +	return collapse_possible_orders(vma, vm_flags, tva_flags);
> +}
> +
>  void khugepaged_enter_vma(struct vm_area_struct *vma,
>  			  vm_flags_t vm_flags)
>  {
>  	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
>  	    hugepage_pmd_enabled()) {
> -		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
> +		if (collapse_possible(vma, vm_flags, TVA_KHUGEPAGED))
>  			__khugepaged_enter(vma->vm_mm);
>  	}
>  }
> @@ -2700,7 +2718,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
>  			cc->progress++;
>  			break;
>  		}
> -		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
> +		if (!collapse_possible(vma, vma->vm_flags, TVA_KHUGEPAGED)) {
>  			cc->progress++;
>  			continue;
>  		}
> @@ -3010,7 +3028,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  	BUG_ON(vma->vm_start > start);
>  	BUG_ON(vma->vm_end < end);
>
> -	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
> +	if (!collapse_possible(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
>  		return -EINVAL;
>
>  	cc = kmalloc_obj(*cc);
> --
> 2.54.0
>

