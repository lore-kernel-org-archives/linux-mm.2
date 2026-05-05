Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21081FF8855
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 14:53:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A87D6B0005; Tue,  5 May 2026 10:53:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 859A66B0088; Tue,  5 May 2026 10:53:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76F656B008A; Tue,  5 May 2026 10:53:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 698DD6B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 10:53:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E959E8C891
	for <linux-mm@kvack.org>; Tue,  5 May 2026 14:53:28 +0000 (UTC)
X-FDA: 84733659696.16.B09EAFB
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf04.hostedemail.com (Postfix) with ESMTP id 88BD340013
	for <linux-mm@kvack.org>; Tue,  5 May 2026 14:53:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=RM0WseBg;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf04.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777992806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A1+lR/OKTvFCcPZryGRXeFH7lwG1m9feu2H5x/EnsaU=;
	b=dch4TTilKkoiz+H2p44FPVTOnoudg4ehWra80/ZD0cYHp1Rh0eXpy158jrIVwyK0PyieJg
	EnLJdLlZUARmyRBFD08KVPUA25Nq/xjfqh7SX8l/GIAXFZNEJXt4PeKEfI9HFAeTYH/3VY
	rZKh4LaltL59lfRfJizZpNszyjxHqqU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777992806; a=rsa-sha256;
	cv=none;
	b=eh6Wx0rtb8RgqxVFMWDo3k3Id/68cfuvbyvvgO10oMxus6kyXtimIlQITL99DJ2hoHue6m
	IpTmTZns8XLdunRCBy1G91YFGwV4UM7wJOnPpPfpmEszjn9ybKK3gifsPJucSNT8ew9N0j
	T1+y9AwZ5J+H79k8wVR2DGRPXjEiHis=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=RM0WseBg;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf04.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64580ETv3452190;
	Tue, 5 May 2026 14:53:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=A1+lR/OKTvFCcPZryGRXeFH7lwG1m9
	feu2H5x/EnsaU=; b=RM0WseBgu9UkIiQaN4WcPgg3qhmGcAiPNa6qiv0mBDg28L
	Ypukc/NgVW/qrDBjYcys/hJoQsHsHdRz3TJr2pYYLFCaG+t4y7vyTP68m57daQA0
	CvdO2NGkzXpjQ/tCkgbr08VwnDjupLhkmgr8ixrlJpD+R/ZWtbaSo8jZQIC+Mi06
	xgZykelLat2TeG+LnwnAKYuT0iQWU3jHOKo7t6QmiTzdKUttyyFnyF9uEwYk/lKp
	S0OhUBrOmUT8I2z9C2DRbJpEt+ko9UecePJ2y/ZLhUkYgAkMadSqchZ4Cn0eA+Ai
	t+upDaTNiHGqEl2kgkwcIJRolByswEIVlxQ+jbKA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9xxkukh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 14:53:22 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 645EdUdk024283;
	Tue, 5 May 2026 14:53:22 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dww3h21dv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 14:53:22 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 645ErKYm15466840
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 May 2026 14:53:20 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0C7AF2004D;
	Tue,  5 May 2026 14:53:20 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CF3BD20049;
	Tue,  5 May 2026 14:53:19 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  5 May 2026 14:53:19 +0000 (GMT)
Date: Tue, 5 May 2026 16:53:18 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Minchan Kim <minchan@kernel.org>
Cc: akpm@linux-foundation.org, hca@linux.ibm.com, linux-s390@vger.kernel.org,
        david@kernel.org, mhocko@suse.com, brauner@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
        timmurray@google.com, Minchan Kim <minchan@google.com>
Subject: Re: [PATCH v1 1/3] mm: process_mrelease: expedite clean file folio
 reclaim via mmu_gather
Message-ID: <20260505145318.97692A14-agordeev@linux.ibm.com>
References: <20260421230239.172582-1-minchan@kernel.org>
 <20260421230239.172582-2-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421230239.172582-2-minchan@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDE0MCBTYWx0ZWRfX4LnKb4KClqAx
 s7gwTIqI0XT5VdrEJb+8SnMKgHNIK6JrvmeiWXtu5l9GgoKzYg3AdN38YxgTJDmyqsxBV0Vu/es
 2uA57KDdjlStBhFZjdmTbmQjeBXhNQdrWOSrjukDcWfUPonb+JXMMxecqj9wBTlOyeDteKVAwK1
 u+aWrL5J6m4FH019O6qfB2T5R9wBAQ+F0Y3uj5Ve/gSsFkZ4TIhTbShHzhnQizQKYim8HG+/Jwj
 sYHQ4PoqiKyZio7zoRxLFbcM/pjVuA7f8rwre3eljC0DOJC50aPZQ3r98BkcMZcrGp/BJAcan+W
 MjRm6GhCZLseV1HdvR6/TyVfGbhcJEUu3tzqFn0MfP4blN5siMi/Brpwgk2vMlElD41FhCxAZpC
 58qBpQLjQsBfXdH5qMZO3emo97TRVN7IKorsQ7UWmPm6wRT2wA1v0CcO76BStFK65H4AaQyUAFd
 Q3auuRyTN8fItwqeZFA==
X-Proofpoint-ORIG-GUID: r0ebNJfhGM_K7X9hABoDKOglg6C_80l4
X-Proofpoint-GUID: WdwCff8RrcoqO1D2tSSCe5-DzCkJOoXT
X-Authority-Analysis: v=2.4 cv=ctWrVV4i c=1 sm=1 tr=0 ts=69fa0463 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=PKeOjummlAqezYvE3xwA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 clxscore=1011
 suspectscore=0 impostorscore=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2605050140
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 88BD340013
X-Stat-Signature: rt9nzgj8wjx5zcyeyh5sfekfkf7gdekm
X-Rspam-User: 
X-HE-Tag: 1777992806-153330
X-HE-Meta: U2FsdGVkX18+o29ulighlSLNT46/lKeMKGtBWDyEjn51n7FAwXLGVTsFjyv0TlCzsUPF/PitAkWBGkwi1XDUPhstEi+EJezu4j8c8i9wCnsVsoN59D145JtfClrvA8e9gWP1GHcsn0s2cmBwH0vi7NbwGeCX9Q6t9Emc/RWhbmn4jidaG66bddDfzl8ys8yq8hz1V91bdE0JsaHvvK/TueonKLycHhi5IlCZTmkDEwsjTlo9gnJjGVJ9QncNTGb/PoFErwxjw7sIVpvqKyQAXCU5HdRNemk9x0+lj4tsVK1yAFADOcupBuXCl7aUQoLkQaDvMcvnjjPDXgyrTUl+0lVG82exgepDMq2+TG5VZ/9jForbwQVNnsDIyfodZK0su55si+fyu5kJnPbWq6ti5HZqTWcalM1AH3Dpn3MsuMmahZUcLfAMPo72KOB8uWZQcMw4r1qmxAAVphFNjncfiFpIjXdierijoqKyTR5m1U7G2Vpe3Icipq0O+MKAtBqKj4p2wWZ8bIlEpEF5/iDuitvm0zRuGoqE8kW3o5Hy0B7vZNxSOmRBNl3wHk1/aIezgQaT1U1owWWWFnXkuj/+Y/Q2BJftAGqrIGHt8T1wm7ngbdjF31sHhiOS7X5mDAk6IoAPEcumKzqqPwv6CcW9DDSRGC9j+T+aMtDhw8J1420DHA5xdWLDKuTrd13AWE5g42SZ0wxKSPGkAj3JIdGjvrNXcB6uOctWh7QhyBXhm3NAkwErywkPjYqnzKd5CzPbWlzjCIlzQpsPBKxeonsZon+Hr5dSIi75DTPwTJNoAdCpv/zcNpIDBfJokHEDWZ4QRxJB0sS89pPBWUI57ZgLmYdS29Kx4+yVQGYXsiyWi48mv85ZzoHy2sf8YQnip/oNaRlLzt+xsk0bPl74IJwlHfHxu0r4O4Mtrnf8vy3PpFtalBOIXwq0MisiC+wt1h48X9w9cuUG7wAhMFGQ86p
 gqXqiWH8
 W/7nHxlBexgSoLSVWwbOuBv/f1uDanHtN+r0Ft7ZUwsSeXg3FEw0UJDlW4sNAYgcRmQT72yr5bcZ2PWa/+2ML6Av9yEHE8dO9KElvCkcjCckuymnWXenQLizf/co/EQCxciKXjRS4xw47Z/N0uJC1vtBHtQRr0ZQ6O2VK8N1FPucTXkfduZjxpa6ERiOPVZ8uzsQBrNHPxN9wtXwwfv9sOHgYxIlG0QV54wQH1XRaazjNRo2zrb+1iEDnfnE3+8iYk28wVDWrBYHVTHfjHRpU2UNWYp3CUQ/YboIB0c088eG3dQUa/CirSbrUYhFrxUY6jzT3csGFWpH54xg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 04:02:37PM -0700, Minchan Kim wrote:

Hi Minchan,

> Currently, process_mrelease() unmaps pages but file-backed pages are
> not evicted and stay in the pagecache, relying on standard memory reclaim
> (kswapd or direct reclaim) to eventually free them. This delays the
> immediate recovery of system memory under Android's LMKD scenarios,
> leading to redundant background apps kills.
> 
> This patch implements an expedited eviction mechanism for clean pagecache
> folios in the mmu_gather code, similar to how swapcache folios are handled.
> It drops them from the pagecache (i.e., evicting them) if they are completely
> unmapped during reaping.
> 
> Within this single unified loop, anonymous pages are released via
> free_swap_cache(), and file-backed folios are symmetrically released via
> free_file_cache().
> 
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  arch/s390/include/asm/tlb.h |  2 +-
>  include/linux/swap.h        |  5 ++---
>  mm/mmu_gather.c             |  7 ++++---
>  mm/swap.c                   | 42 +++++++++++++++++++++++++++++++++++++
>  mm/swap_state.c             | 26 -----------------------
>  5 files changed, 49 insertions(+), 33 deletions(-)
> 
> diff --git a/arch/s390/include/asm/tlb.h b/arch/s390/include/asm/tlb.h
> index 619fd41e710e..2736dbb571a8 100644
> --- a/arch/s390/include/asm/tlb.h
> +++ b/arch/s390/include/asm/tlb.h
> @@ -62,7 +62,7 @@ static inline bool __tlb_remove_folio_pages(struct mmu_gather *tlb,
>  	VM_WARN_ON_ONCE(delay_rmap);
>  	VM_WARN_ON_ONCE(page_folio(page) != page_folio(page + nr_pages - 1));
>  
> -	free_pages_and_swap_cache(encoded_pages, ARRAY_SIZE(encoded_pages));
> +	free_pages_and_caches(tlb->mm, encoded_pages, ARRAY_SIZE(encoded_pages));
>  	return false;
>  }
>  
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 62fc7499b408..bdb784966343 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -414,7 +414,9 @@ extern int sysctl_min_unmapped_ratio;
>  extern int sysctl_min_slab_ratio;
>  #endif
>  
> +struct mm_struct;
>  void check_move_unevictable_folios(struct folio_batch *fbatch);
> +void free_pages_and_caches(struct mm_struct *mm, struct encoded_page **pages, int nr);
>  
>  extern void __meminit kswapd_run(int nid);
>  extern void __meminit kswapd_stop(int nid);
> @@ -433,7 +435,6 @@ static inline unsigned long total_swapcache_pages(void)
>  
>  void free_swap_cache(struct folio *folio);
>  void free_folio_and_swap_cache(struct folio *folio);
> -void free_pages_and_swap_cache(struct encoded_page **, int);
>  /* linux/mm/swapfile.c */
>  extern atomic_long_t nr_swap_pages;
>  extern long total_swap_pages;
> @@ -510,8 +511,6 @@ static inline void put_swap_device(struct swap_info_struct *si)
>  	do { (val)->freeswap = (val)->totalswap = 0; } while (0)
>  #define free_folio_and_swap_cache(folio) \
>  	folio_put(folio)
> -#define free_pages_and_swap_cache(pages, nr) \
> -	release_pages((pages), (nr));
>  
>  static inline void free_swap_cache(struct folio *folio)
>  {
> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> index fe5b6a031717..3c6c315d3c48 100644
> --- a/mm/mmu_gather.c
> +++ b/mm/mmu_gather.c
> @@ -100,7 +100,8 @@ void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma)
>   */
>  #define MAX_NR_FOLIOS_PER_FREE		512
>  
> -static void __tlb_batch_free_encoded_pages(struct mmu_gather_batch *batch)
> +static void __tlb_batch_free_encoded_pages(struct mm_struct *mm,
> +		struct mmu_gather_batch *batch)
>  {
>  	struct encoded_page **pages = batch->encoded_pages;
>  	unsigned int nr, nr_pages;
> @@ -135,7 +136,7 @@ static void __tlb_batch_free_encoded_pages(struct mmu_gather_batch *batch)
>  			}
>  		}
>  
> -		free_pages_and_swap_cache(pages, nr);
> +		free_pages_and_caches(mm, pages, nr);
>  		pages += nr;
>  		batch->nr -= nr;
>  
> @@ -148,7 +149,7 @@ static void tlb_batch_pages_flush(struct mmu_gather *tlb)
>  	struct mmu_gather_batch *batch;
>  
>  	for (batch = &tlb->local; batch && batch->nr; batch = batch->next)
> -		__tlb_batch_free_encoded_pages(batch);
> +		__tlb_batch_free_encoded_pages(tlb->mm, batch);
>  	tlb->active = &tlb->local;
>  }
>  
> diff --git a/mm/swap.c b/mm/swap.c
> index bb19ccbece46..e44bc8cefceb 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -1043,6 +1043,48 @@ void release_pages(release_pages_arg arg, int nr)
>  }
>  EXPORT_SYMBOL(release_pages);
>  
> +static inline void free_file_cache(struct folio *folio)
> +{
> +	if (folio_trylock(folio)) {
> +		mapping_evict_folio(folio_mapping(folio), folio);
> +		folio_unlock(folio);
> +	}
> +}
> +
> +/*
> + * Passed an array of pages, drop them all from swapcache and then release
> + * them.  They are removed from the LRU and freed if this is their last use.
> + *
> + * If @try_evict_file_folios is true, this function will proactively evict clean
> + * file-backed folios if they are no longer mapped.
> + */
> +void free_pages_and_caches(struct mm_struct *mm, struct encoded_page **pages, int nr)
> +{
> +	bool try_evict_file_folios = mm_flags_test(MMF_UNSTABLE, mm);
> +	struct folio_batch folios;
> +	unsigned int refs[PAGEVEC_SIZE];
> +
> +	folio_batch_init(&folios);
> +	for (int i = 0; i < nr; i++) {
> +		struct folio *folio = page_folio(encoded_page_ptr(pages[i]));
> +
> +		if (folio_test_anon(folio))
> +			free_swap_cache(folio);
> +		else if (unlikely(try_evict_file_folios))
> +			free_file_cache(folio);

This condition is absent in free_pages_and_swap_cache().
What would happen with non-anon and non-evict folio?

> +
> +		refs[folios.nr] = 1;
> +		if (unlikely(encoded_page_flags(pages[i]) &
> +			     ENCODED_PAGE_BIT_NR_PAGES_NEXT))
> +			refs[folios.nr] = encoded_nr_pages(pages[++i]);
> +
> +		if (folio_batch_add(&folios, folio) == 0)
> +			folios_put_refs(&folios, refs);
> +	}
> +	if (folios.nr)
> +		folios_put_refs(&folios, refs);
> +}
> +
>  /*
>   * The folios which we're about to release may be in the deferred lru-addition
>   * queues.  That would prevent them from really being freed right now.  That's
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 6d0eef7470be..7576bf36d920 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -400,32 +400,6 @@ void free_folio_and_swap_cache(struct folio *folio)
>  		folio_put(folio);
>  }
>  
> -/*
> - * Passed an array of pages, drop them all from swapcache and then release
> - * them.  They are removed from the LRU and freed if this is their last use.
> - */
> -void free_pages_and_swap_cache(struct encoded_page **pages, int nr)
> -{
> -	struct folio_batch folios;
> -	unsigned int refs[PAGEVEC_SIZE];
> -
> -	folio_batch_init(&folios);
> -	for (int i = 0; i < nr; i++) {
> -		struct folio *folio = page_folio(encoded_page_ptr(pages[i]));
> -
> -		free_swap_cache(folio);
> -		refs[folios.nr] = 1;
> -		if (unlikely(encoded_page_flags(pages[i]) &
> -			     ENCODED_PAGE_BIT_NR_PAGES_NEXT))
> -			refs[folios.nr] = encoded_nr_pages(pages[++i]);
> -
> -		if (folio_batch_add(&folios, folio) == 0)
> -			folios_put_refs(&folios, refs);
> -	}
> -	if (folios.nr)
> -		folios_put_refs(&folios, refs);
> -}
> -
>  static inline bool swap_use_vma_readahead(void)
>  {
>  	return READ_ONCE(enable_vma_readahead) && !atomic_read(&nr_rotate_swap);
> -- 
> 2.54.0.rc1.555.g9c883467ad-goog
> 
> 

