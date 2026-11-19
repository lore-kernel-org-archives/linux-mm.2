Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF49D606A337
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 16:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=H589cwGa
Received: by kanga.kvack.org (Postfix)
	id D2A9E6B0661; Thu, 19 Nov 2026 11:44:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDB336B06B5; Thu, 19 Nov 2026 11:44:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF0E16B06B4; Thu, 19 Nov 2026 11:44:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 94D246B0661
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:44:22 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DC19940B56
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:44:21 +0000 (UTC)
X-FDA: 85452441522.15.8E987C9
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id A6268140009
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:44:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=H589cwGa;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795106660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zDXF/eCRhk1uzVkaxBfPvONixANJAFGM6Jb/fbAScSs=;
	b=Gt2IJEqwPd+d2ocmhCQzWNX3tAs5NmiquurzeLvDu5GO0Jyhc0saETO1UlCt9ixow+19ux
	LbkKUsWLpyQ+1DzO7k/Y325SfhMnZByzy9ppkG237czdZQB/OZeqHqcDRpqM7pqOus6Vk6
	Q02lRK+jOhgwlMmmQsZRmWxOarPCTjM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795106660;
	b=Ym2BD1NfzG7wHN+SkDt3MMGU06I7ggjnoNp6EfxHEHKMCxryeWlQlclSNUIk+bWA59CyN5
	DpyensNlR7GCqVShisnQYkxkuAex0w+c0bIZmEVVxTVWYf7mKGkQGKCKRPmzuwxARZ9aZm
	2f/FLiMUAX5uNKmY5n2ZNhjrv+Hvteg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=H589cwGa;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4a3e706b5dfso1611248f8f.2
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795106658; x=1795711458; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zDXF/eCRhk1uzVkaxBfPvONixANJAFGM6Jb/fbAScSs=;
        b=H589cwGaugqA9YAHhVUmzzO5NxEHkaUj/JyD12brCkRQeReHk5S7aaKzvKJsGLBd54
         644fn8hrPCnKXe8vjWIvYdL4/2hN7GFGixNx79s2Er0KaScWgxIhXtApJDgB5jf8qnr6
         3hymMyRW1hgtHwpnNuj9tiZoP4NiRbDVbWAv73n9ze+UpiOl6UsTXbw6GBUpJJZwe3zd
         r1wOYYoQ8ABoGsnz+2TCi/NVX66H3pkEKyc3wKkSoRUXqNy9+isrvWGWc6S+akbvSeAZ
         /GQP5kjCwY3eoMU1aHJL4hH6RqSu34xfzh4c5+fAh7BdfD6sJ4vCEy9AsguMRWQqaAUc
         ikCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795106658; x=1795711458;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zDXF/eCRhk1uzVkaxBfPvONixANJAFGM6Jb/fbAScSs=;
        b=i96a/jy/UR5iuvITevMOZlzSEE5cbTNX8qMsRBaQxQkzyq8rK4AWsQxBG4walowI1g
         aE9EfReLuu5PyVswydlxYC6/DP8OuVoRrCYGk9/Efv1zeBmeEYx8ymcDguC+nFyXafdZ
         ML3yJJ4MC8IVkeGyulXPlbu2hRWfeWmbEBJmgmRzp700YdR9vENDpUSYETpsM85x1gUx
         h277b2MNB6DV7TGiUAk/nOHJYKuvBx61S/D7Wg6vgZqJsidvI9dX/sVUAiLd2oYDhXiM
         OGCEhiGFb9mbCKq++49Wvs99J6qDnjq83G7lHMJpMpZQuoMx34he0WPC0n+pycLRT944
         Bd1w==
X-Forwarded-Encrypted: i=1; AL+hErFNV882bkHm/Tdmc4Cqbe5GDrGuJCgrft4TL9iV7Bc7PQ9Nl3By3IWx/2KYL62XDgMbBhZW3OXbwA==@kvack.org
X-Gm-Message-State: APuU4Z/Ii2p+UumLXjzf0ikBMDt6kRrD4xuuUwgadyMVSYlcwzVkeBpY
	NHqoWywCS1mRhP0QO+meL3XlLocCCxdZgCBPoh25IKLVKuttKIINvpJGFu7hsFTuTy4=
X-Gm-Gg: AZFdTZdmG1kR/bakQWBN2uHpzKBoWzkz0KSB9UnbGkLFPSM7PqyUHvXjfVwVbDah8iZ
	ybnmOlW5zuEdXf7MIx0CBA3XDKdYJLVBC4BsIS/uBC1njfCs0Vjwrq9nK+PLz+7prAAkOYhN6MP
	3ebSFkKFMjffyIlqS0HNVoYqC5l49WFBTfAOrfRk8mhj+WsbiBmcLc3nSIqGAxxDM0Y+iYjeHuF
	lJkU7M3ttERLwjL78T6qaXfaLK4shIERWWzXrQKgKs2iLBL0NBgbQaDSOOI3XIPXNLI6CZmDdhT
	I3L/KSV8fi01/r75Kq5r7u4lHC+jslSrep5EckgELjbaR2MyJvD7rWnKWMKElkkiVUo0TowHrGd
	NktAcFS3h9w9OzZceWY6LuYmL8lHo2vleEGTHEl85kag5sqQNNZ4pH7ZD8dlOE0J5X7Kn3oTZa9
	n7UwWvmbYU6vPfupeW4DlpuzB+sJERwT7UqRtWwUfYvLxz+j/qcVfprDiXHoPgpKzaqSJSQpG3x
	rpiSMXk/Tzu1FSSu3t3rj4L2AMZI/dN50Enpnh53WHgz+igEojYZfHHS+GkXFbtCKsDwtzr1VCQ
	6ZO+bcg6HswH40fRILIxaMDjmOXSZINj0117XA==
X-Received: by 2002:a05:6000:2087:b0:48b:db7:86a7 with SMTP id ffacd0b85a97d-4a63e223fb6mr14422264f8f.50.1795106658000;
        Thu, 19 Nov 2026 08:44:18 -0800 (PST)
Received: from localhost (109-81-24-9.rct.o2.cz. [109.81.24.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6bb98b4dsm632121f8f.53.2026.11.19.08.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 08:44:17 -0800 (PST)
Date: Thu, 19 Nov 2026 17:44:16 +0100
From: Michal Hocko <mhocko@suse.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Jann Horn <jannh@google.com>,
	Ying Huang <huang.ying.caritas@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Chris Mason <mason@kernel.org>, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH] mm/madvise: fix MADV_FREE handling for PMD-mapped THPs
Message-ID: <av8nYAco3bMhUIBI@tiehlicka>
References: <20261119-madv_free_thp-v1-1-a312919e1ee5@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119-madv_free_thp-v1-1-a312919e1ee5@kernel.org>
X-Rspamd-Queue-Id: A6268140009
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: d9q5hd7ji4d86iw1nh6eahbnpep6aa3g
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1795106659-630502
X-HE-Meta: U2FsdGVkX18LmPgw5wn71Cpq3pQ2XEB8H/OOFk7Fr8vGAQmOnMGSzUMU5elBJna+wu0PLvnRDjnBXQze/LratPV8leddWrBJ+CfNp2VtlXVzsvLN75S5eagKN1na51/O7L5kI7pH7U4JItT68/FU2X73orVuY0yRCEKqOxF5gSZWWh59LEkrJAYN2F0TJgyjp1I1w1uAcuq+y7Dmkqi8CbB+N8/88lF1WpkN3E9x9Bw8OVamXP5vlkPvShTlmM1+oqtUMtxaCnhreB5DZGbBmA7WXjothnCNtpfN3IrSrOq6/n/2eECndnXgCyT7gWU+qKFrRKEIU55fSJjQCE0gXRBt8otq/MexAzcFVuy7OeaZA0jw4xKGZkJt+ClagJrLQzi4e4VHvAUc7CZMfrBzcQRZKaR2oeRJabQJmdtb/tAv8/5lYRa/XSDNedtzJgCqE4B8PjQsWHHKqtIEpGGojTyYHVe1zMLq8a99TUyz3lR/69NUyFELDnpi8JMkZ9q5l97nWeHlifSZZeazpX5rz+bbRwcLK0MoobEyjsv0IPPNMPIV7rQR/I6XHnzctND2OWvF0OjWjFLRu+u6xq+nxxFxDkquKVgYDGHqitQT+Ir6BwwsMNHnN3X3aC1SUhczMrpsHnXT7GvN82MNz2URu7euHGHkXd0cLcAlRe/57ye3NSXZZXVSFy06+lp/diYK12WI6oefMbFCp73FHycLZJmq6kXOEJjS9Mx/a22vJl8fRd5HvRBEnliVRx8ErkFQPqihrMZC/i41Yyin7SJnns6r9gYDGWr54PTDOs69/RLaRSa1p/ZKTqOftaonePMag2HLiDXkxrJGKav04GCCgvMk2J3Wc6xF1W8/7Skf+s7tqaOKOd7NzB1w0RRjpUwTP0lBi9FRafwMj38bBPy6PeuqEUBTVQtifCZ2Q1zYdtj4FqbFpjL9HWUUTIdovX026gPSC5XWg0KYnvqp40i
 TQeMeBOQ
 XWAauu1W2mNnVxS7SNcyurWHzUH+t4P6iWeV7mhBkOO/BQMrluLFbtzZ79QRLumJ718wPKG1T0iRbSAe9cyxeCerZ5L8Jrw/gkLy06AvSyhBOjJ47luiOYnnCZapqQDGNWdALqckxtbwPox+KLswVX0j6jhJTHuEaNX3IAORYoAGAWJQ4LM4ACTSgAt0AmQMy54tQDSxIt1MMAbR4KkWokj+BlI3Q1oqdKN0MG5EW3tb1p47ngV3f109/3dh838j9Zjq96VLK0OOGcmy0/z96ior4w5ww2RvVrYoGNm7YntHMo4T0Ow7kCc4EjpGAf2U5AReHQXxj+DePuauhvfKyup0KgYLCxcWlS+ihf2r6OoH6Da5xT9Bhns/LQPsv+wdKck4YXl3z//dDEFdGACt84AgvB77MPSpGsnKm66ruRccvmUoz6Cx5zZuE2U8Z/Crp43lootxav4siuANQvzPtEs9f3+yRctCm6qpBoQbmyfRdsMJGWDY7dCHiHCe5U0vGwtAcn+q+fL8JExZ82b0Ywph/M9WLO7tuQ5pfD/TW79QCWj79Dfe3hPYlYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu 19-11-26 17:04:34, David Hildenbrand wrote:
> After MADV_FREE cleared the dirty flag of an anonymous folio, reclaim will
> later free the folio without writing it back if no mappings are dirty.
> 
> If our folio is still in the swap cache, the swap entries then point at
> swap slots that were never written, exposing stale content of the swap
> device. Bad.
> 
> madvise_free_pte_range() therefore frees the swap slots first, and skips
> the folio if that is impossible. madvise_free_huge_pmd() does not, and a
> PMD-mapped THP can be in the swap cache if try_to_unmap() failed during
> reclaim, for example due to a racing mlock().
> 
> Further, madvise_free_huge_pmd() checks whether the THP is mapped by
> other processes before taking the folio lock. Another process that still
> has swap entries for the THP can concurrently map it from the swap cache,
> and we might end up clearing the dirty flag of a shared folio.
> 
> Fix it by factoring out the folio handling of madvise_free_pte_range()
> into madvise_free_try_prepare_folio(), and using it for PMD-mapped THPs
> as well. Hopefully this prevents further bugs.
> 
> For PMD-mapped THPs, this change implies:
> 
> 1. We free the swap slots of a THP in the swap cache, and skip the THP if
>    that is impossible.
> 2. We check the mapcount under the folio lock.
> 3. We no longer lock and check THPs that are neither dirty nor in the
>    swap cache, just like for PTE-mapped folios.
> 
> For PTE-mapped folios, this means:
> 
> 4. We check the mapcount once before taking the folio lock, to not lock
>    folios that are mapped by other processes.
> 
> Only compile madvise_free_huge_pmd() with CONFIG_ADVISE_SYSCALLS to keep
> !CONFIG_ADVISE_SYSCALLS builds working.
> 
> Chris and Sashiko reported the missing swap cache handling for PMD-mapped
> THPs, the other issue was found by code inspection.
> 
> This has medium urgency.
> 
> Fixes: bd4c82c22c36 ("mm, THP, swap: delay splitting THP after swapped out")
> Cc: stable@vger.kernel.org
> Reported-by: Chris Mason <mason@kernel.org>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/sashiko-outbox-202086@kernel.org/
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
> I would queue this fairly soon on mm-core/for-next-fixes
> ---
>  mm/huge_memory.c | 19 ++++++-----------
>  mm/internal.h    |  1 +
>  mm/madvise.c     | 65 +++++++++++++++++++++++++++++---------------------------
>  3 files changed, 41 insertions(+), 44 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 79d400ea9553d..e22daf846dbe3 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2421,6 +2421,7 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_ADVISE_SYSCALLS
>  /*
>   * Return true if we do MADV_FREE successfully on entire pmd page.
>   * Otherwise, return false.
> @@ -2455,21 +2456,13 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  	if (folio_is_zone_device(folio))
>  		goto out;
>  
> -	/*
> -	 * If other processes are mapping this folio, we couldn't discard
> -	 * the folio unless they all do MADV_FREE so let's skip the folio.
> -	 */
> -	if (folio_maybe_mapped_shared(folio))
> -		goto out;
> -
> -	if (!folio_trylock(folio))
> -		goto out;
> -
>  	/*
>  	 * If user want to discard part-pages of THP, split it so MADV_FREE
>  	 * will deactivate only them.
>  	 */
>  	if (next - addr != HPAGE_PMD_SIZE) {
> +		if (folio_maybe_mapped_shared(folio) || !folio_trylock(folio))
> +			goto out;
>  		folio_get(folio);
>  		spin_unlock(ptl);
>  		split_folio(folio);
> @@ -2478,9 +2471,8 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  		goto out_unlocked;
>  	}
>  
> -	if (folio_test_dirty(folio))
> -		folio_clear_dirty(folio);
> -	folio_unlock(folio);
> +	if (!madvise_free_try_prepare_folio(folio, 1))
> +		goto out;
>  
>  	if (pmd_young(orig_pmd) || pmd_dirty(orig_pmd)) {
>  		pmdp_invalidate(vma, addr, pmd);
> @@ -2498,6 +2490,7 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  out_unlocked:
>  	return ret;
>  }
> +#endif /* CONFIG_ADVISE_SYSCALLS */
>  
>  static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
>  {
> diff --git a/mm/internal.h b/mm/internal.h
> index 85cf7becf8588..96cb55d7816b1 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -61,6 +61,7 @@ void lru_add_drain_cpu(int cpu);
>  void lru_add_drain_cpu_zone(struct zone *zone);
>  void folio_deactivate(struct folio *folio);
>  void folio_mark_lazyfree(struct folio *folio);
> +bool madvise_free_try_prepare_folio(struct folio *folio, int nr_mappings);
>  
>  /* mm/vmscan.c */
>  unsigned long zone_reclaimable_pages(struct zone *zone);
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 0214efd2a014f..ebb4ce7daf6cb 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -661,6 +661,38 @@ static long madvise_pageout(struct madvise_behavior *madv_behavior)
>  	return 0;
>  }
>  
> +bool madvise_free_try_prepare_folio(struct folio *folio, int nr_mappings)
> +{
> +	if (!folio_test_swapcache(folio) && !folio_test_dirty(folio))
> +		return true;
> +
> +	if (folio_mapcount(folio) != nr_mappings || !folio_trylock(folio))
> +		return false;
> +
> +	/*
> +	 * KSM folios can gain new mappings at any time, so we must
> +	 * not clear their dirty flag.
> +	 */
> +	if (folio_test_ksm(folio))
> +		goto unlock;
> +
> +	/*
> +	 * Check under the folio lock that the folio is exclusive: we own all
> +	 * mappings, and there are no references from swap entries.
> +	 */
> +	if (folio_mapcount(folio) != nr_mappings)
> +		goto unlock;
> +	if (folio_test_swapcache(folio) && !folio_free_swap(folio))
> +		goto unlock;
> +
> +	folio_clear_dirty(folio);
> +	folio_unlock(folio);
> +	return true;
> +unlock:
> +	folio_unlock(folio);
> +	return false;
> +}
> +
>  static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
>  				unsigned long end, struct mm_walk *walk)
>  
> @@ -753,37 +785,8 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
>  			}
>  		}
>  
> -		if (folio_test_swapcache(folio) || folio_test_dirty(folio)) {
> -			if (!folio_trylock(folio))
> -				continue;
> -			/*
> -			 * KSM folios can gain new mappings at any time, so we must
> -			 * not clear their dirty flag.
> -			 */
> -			if (folio_test_ksm(folio)) {
> -				folio_unlock(folio);
> -				continue;
> -			}
> -
> -			/*
> -			 * If we have a large folio at this point, we know it is
> -			 * fully mapped so if its mapcount is the same as its
> -			 * number of pages, it must be exclusive.
> -			 */
> -			if (folio_mapcount(folio) != folio_nr_pages(folio)) {
> -				folio_unlock(folio);
> -				continue;
> -			}
> -
> -			if (folio_test_swapcache(folio) &&
> -			    !folio_free_swap(folio)) {
> -				folio_unlock(folio);
> -				continue;
> -			}
> -
> -			folio_clear_dirty(folio);
> -			folio_unlock(folio);
> -		}
> +		if (!madvise_free_try_prepare_folio(folio, folio_nr_pages(folio)))
> +			continue;
>  
>  		if (pte_young(ptent) || pte_dirty(ptent)) {
>  			clear_young_dirty_ptes(vma, addr, pte, nr, cydp_flags);
> 
> ---
> base-commit: 5e600d79135124a4eb8e9db30ad524224c267c07
> change-id: 20261119-madv_free_thp-3c2a9887a722
> 
> Best regards,
> --  
> David Hildenbrand (Arm) <david@kernel.org>

-- 
Michal Hocko
SUSE Labs

