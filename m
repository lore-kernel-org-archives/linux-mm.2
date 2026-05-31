Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB4B3CD6E56
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 20:09:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E70076B0184; Sun, 31 May 2026 16:09:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E47006B0185; Sun, 31 May 2026 16:09:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5CE06B0186; Sun, 31 May 2026 16:09:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C48936B0184
	for <linux-mm@kvack.org>; Sun, 31 May 2026 16:09:36 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4DC4A1205BE
	for <linux-mm@kvack.org>; Sun, 31 May 2026 20:09:36 +0000 (UTC)
X-FDA: 84828805152.13.CF7690D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8D589140015
	for <linux-mm@kvack.org>; Sun, 31 May 2026 20:09:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aWkY6b7I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780258174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vUR4pQEmi7q3t9WVDIk8a0y4HrNMNklWqbetWEzKFK8=;
	b=KMho3kYwN87/3QFT5bwn98pBMpDqDdrDXbgngOuVJWbwqCwIGXYR7VHM5A1nYyk4fYAJXE
	GzxC/iMFre6mMT26khZMotilA1606e3Kxz6Xrx9nkVrcEzNwAQN08CI8ytORg6tptf7ORJ
	Uu+CdWt8wc+L2KdN+gG0ArSIW2pnpUI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aWkY6b7I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780258174; a=rsa-sha256;
	cv=none;
	b=4/btDeA+J6aD+0DDtDdv0IpQrPC4s9bw+MoKQkKLDk0Rswa5Pmy4c4CO8cijT/LnpO4Ho9
	s1oTfkg3erAB39HJ87Z5TU/1cUPZM3xFAS92aPjvGlKWAti328+WA8SkorHAmYuH5pVZyN
	ARjOdrD0TpGctCds9D2NMxcYphpFVUY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AF8BB601FE;
	Sun, 31 May 2026 20:09:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43931F00898;
	Sun, 31 May 2026 20:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780258173;
	bh=vUR4pQEmi7q3t9WVDIk8a0y4HrNMNklWqbetWEzKFK8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aWkY6b7Ia6U93/bUAEYspC8USRSgKFuQ9u425mYy6lwrDsRLwBfBAUht0SxyyfgH5
	 18xJB8jm9Vo8GDxeKNoUvJ9uNOkHP5cS/MgOs5HZpJ0OFG9KW7aycFSRWS5bRhVOVp
	 MBdxxYUnDo+z6USu2vJNkXQALN24K+Iylr8b+heT3Tb4VuyBUdtAgwDTqyEuCiWeoB
	 z77HVvdXui+ZCvBc+Bs0IwnTI+mK+TB/TRmzW9jbOrJ73MaMPxsfMNVJv7xsmIGcuU
	 GpnTkkIv7SrHMqnpg1vf0sDOPR9hnZ3Qo5cBX1eAhyAONYUrx088jV1iJGNuK7LQ8V
	 99GUW3cP87Sfw==
Message-ID: <ebe417e8-a2aa-4602-867e-57e1bdf8d523@kernel.org>
Date: Sun, 31 May 2026 22:09:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v18 08/14] mm/khugepaged: add per-order mTHP
 collapse failure statistics
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260522150009.121603-1-npache@redhat.com>
 <20260522150009.121603-9-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260522150009.121603-9-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: s8zmgwdzko6qeyjnsaqa9ojpgs3bnjmg
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8D589140015
X-Rspam-User: 
X-HE-Tag: 1780258174-724202
X-HE-Meta: U2FsdGVkX1816A622IjurZeduTsQAFV28wogMRQgZwJzge2eW+TI8A3p5ZdFxg6c7Xxg/qbXG2AydCt3kz/7L98p5be1XBrR49zPYSEqeXgJUJ6XWyqXgXPuhXo6gsvvLvK2sd9HfcL26QHJM6eQyiP0JAN4DR8MGjF3D1FX2RmdDuvpJ9u7csLFIllwem4qz3jWWttZk9ngugXozUFpwXGWoy64Je4qsNflwHfKtfKwaLyowePTHs2rDEQgQPIvDU3mBhcvdrzNpyX/L36AZv7RHC74EprqONtDLA1uEn5UsQRpYXcPkyL5F32q9P9QXrFfSvNfOsIaAd6c76mX6Ku1emNfGwXyGHPYedJD5JFicJNSAwJxle6+f3pY/has1A2GXRxLlCuuOqS3AdG4wTlGDGBV6LCfGkDEdD0Tz5nOxGcAxERaHa/FmaNdBSKktoGxGAwTYwX8FwD2MZzuy4V11OeB0jWUtZ0jvyOKJ6wP/wFRuzIzthFmbkmOnYB2HerL5He1mAD9GejvcLS5AuKOHAAncCDTn3bDlgL63Gb1zLYKP2qf74i1CtqFX1jQ9XeujpyQOjNB6tpIrGKLqQT84LLoaBPgiUAV38a0W5jWYU9L2+RZRi4vs8RWAKbZeAnwDKJxw40hLDJivIYCDWCmLg4f6TO43Gi/Be/KF8i/V+ntpUjgrJOrbkVDrrrjO1PXoMZbVcEPxCu88UWYY8G7GVURgxuKFWgxJ7eGNTmqYHE99JSBRvzp5ie+GNEZTVHJkCXjvcT1IsftZKtniBZMaL3K24JDSouvt03lQyyaH6oGKWZUeaLMv8yh080VQLXuJEVIeV3xdX/ua9c/qtV+3En0tIq0bE0JXRZ6m//POBNPpxs91Y6Q04Owq3cq+rLA4j/Enzp5VCeerNv27P2SXCxjRpKrnai+q8Ir/pdVG79WdiYExQAqUHn/7oe/2PTVPaUqPlqwehDE4G/
 C6K7yGjo
 MPVc6JhbmZy/v3Sf85bmhX2Lt7+O9vkmIEvqwJ9AUh5kRWmypI24WmUuQj19EZuz67F4iDwWcRmC5+R/M/Ic/VNyf9/oyezlc2wcEEB8GMgSuJkpaAj69creMNuWyc5277mG3VUnFJG/8SRbGq6hggjn4oKmekdrS+8y9PavoxyeJSMu3JzfEyNkh8pDWcszgpCNdMdmw72BG6GkvfMYVgVdA3OxAbtrDfH2sw79bkGz/4aio3rWK/Y929gmOtDroPoJzo+1Co8B01LQZxINsaPh7+RYtA/TO2MH0di8yE/pQQ+r3ASm7rswfh9DYoe5Jg2BPa5rXQq37aeFaJKnl7rcZ5dCLuFhuShWnGF8OM6D69TM+xOY9hMUp/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/22/26 17:00, Nico Pache wrote:
> Add three new mTHP statistics to track collapse failures for different
> orders when encountering swap PTEs, excessive none PTEs, and shared PTEs:
> 
> - collapse_exceed_swap_pte: Increment when mTHP collapse fails due to
> 	encountering a swap PTE.
> 
> - collapse_exceed_none_pte: Counts when mTHP collapse fails due to
>   	exceeding the none PTE threshold for the given order
> 
> - collapse_exceed_shared_pte: Counts when mTHP collapse fails due to
> 	encountering a shared PTE.
> 
> These statistics complement the existing THP_SCAN_EXCEED_* events by
> providing per-order granularity for mTHP collapse attempts. The stats are
> exposed via sysfs under
> `/sys/kernel/mm/transparent_hugepage/hugepages-*/stats/` for each
> supported hugepage size.
> 
> As we currently do not support collapsing mTHPs that contain a swap or
> shared entry, those statistics keep track of how often we are
> encountering failed mTHP collapses due to these restrictions.
> 
> We will add support for mTHP collapse for anonymous pages next; lets also
> track when this happens at the PMD level within the per-mTHP stats.
> 
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  Documentation/admin-guide/mm/transhuge.rst | 14 ++++++++++++++
>  include/linux/huge_mm.h                    |  3 +++
>  mm/huge_memory.c                           |  7 +++++++
>  mm/khugepaged.c                            | 21 +++++++++++++++++++--
>  4 files changed, 43 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> index c51932e6275d..80a4d0bed70b 100644
> --- a/Documentation/admin-guide/mm/transhuge.rst
> +++ b/Documentation/admin-guide/mm/transhuge.rst
> @@ -714,6 +714,20 @@ nr_anon_partially_mapped
>         an anonymous THP as "partially mapped" and count it here, even though it
>         is not actually partially mapped anymore.
>  
> +collapse_exceed_none_pte
> +       The number of collapse attempts that failed due to exceeding the
> +       max_ptes_none threshold.
> +
> +collapse_exceed_swap_pte
> +       The number of collapse attempts that failed due to exceeding the
> +       max_ptes_swap threshold. For non-PMD orders this occurs if a mTHP range
> +       contains at least one swap PTE.
> +
> +collapse_exceed_shared_pte
> +       The number of collapse attempts that failed due to exceeding the
> +       max_ptes_shared threshold. For non-PMD orders this occurs if a mTHP range
> +       contains at least one shared PTE.
> +
>  As the system ages, allocating huge pages may be expensive as the
>  system uses memory compaction to copy data around memory to free a
>  huge page for use. There are some counters in ``/proc/vmstat`` to help
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index ba7ae6808544..48496f09909b 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -144,6 +144,9 @@ enum mthp_stat_item {
>  	MTHP_STAT_SPLIT_DEFERRED,
>  	MTHP_STAT_NR_ANON,
>  	MTHP_STAT_NR_ANON_PARTIALLY_MAPPED,
> +	MTHP_STAT_COLLAPSE_EXCEED_SWAP,
> +	MTHP_STAT_COLLAPSE_EXCEED_NONE,
> +	MTHP_STAT_COLLAPSE_EXCEED_SHARED,
>  	__MTHP_STAT_COUNT
>  };
>  
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 345c54133c83..5c128cdec810 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -703,6 +703,10 @@ DEFINE_MTHP_STAT_ATTR(split_failed, MTHP_STAT_SPLIT_FAILED);
>  DEFINE_MTHP_STAT_ATTR(split_deferred, MTHP_STAT_SPLIT_DEFERRED);
>  DEFINE_MTHP_STAT_ATTR(nr_anon, MTHP_STAT_NR_ANON);
>  DEFINE_MTHP_STAT_ATTR(nr_anon_partially_mapped, MTHP_STAT_NR_ANON_PARTIALLY_MAPPED);
> +DEFINE_MTHP_STAT_ATTR(collapse_exceed_swap_pte, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
> +DEFINE_MTHP_STAT_ATTR(collapse_exceed_none_pte, MTHP_STAT_COLLAPSE_EXCEED_NONE);
> +DEFINE_MTHP_STAT_ATTR(collapse_exceed_shared_pte, MTHP_STAT_COLLAPSE_EXCEED_SHARED)

[...]

>  		/* See collapse_scan_pmd(). */
>  		if (folio_maybe_mapped_shared(folio)) {
> +			/*
> +			 * TODO: Support shared pages without leading to further
> +			 * mTHP collapses. Currently bringing in new pages via
> +			 * shared may cause a future higher order collapse on a
> +			 * rescan of the same range.
> +			 */

This comment actually belongs into an earlier patch, no?

>  			if (++shared > max_ptes_shared) {
>  				result = SCAN_EXCEED_SHARED_PTE;
> -				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
> +				if (is_pmd_order(order))
> +					count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
> +				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
>  				goto out;
>  			}
>  		}
> @@ -1138,6 +1148,7 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
>  		 * range.
>  		 */
>  		if (!is_pmd_order(order)) {
> +			count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
>  			pte_unmap(pte);
>  			mmap_read_unlock(mm);
>  			result = SCAN_EXCEED_SWAP_PTE;
> @@ -1433,6 +1444,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  			if (++none_or_zero > max_ptes_none) {
>  				result = SCAN_EXCEED_NONE_PTE;
>  				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> +				count_mthp_stat(HPAGE_PMD_ORDER,
> +						MTHP_STAT_COLLAPSE_EXCEED_NONE);
>  				goto out_unmap;
>  			}
>  			continue;
> @@ -1441,6 +1454,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  			if (++unmapped > max_ptes_swap) {
>  				result = SCAN_EXCEED_SWAP_PTE;
>  				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
> +				count_mthp_stat(HPAGE_PMD_ORDER,
> +						MTHP_STAT_COLLAPSE_EXCEED_SWAP);
>  				goto out_unmap;
>  			}
>  			/*
> @@ -1498,6 +1513,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  			if (++shared > max_ptes_shared) {
>  				result = SCAN_EXCEED_SHARED_PTE;
>  				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
> +				count_mthp_stat(HPAGE_PMD_ORDER,
> +						MTHP_STAT_COLLAPSE_EXCEED_SHARED);

Can be done as a later cleanup, but having a single function that obtains an
order and knows which stats to update would be cleaner (and a good preparation
for shmem mTHP collapse support).

Nothing jumped at me, so

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

