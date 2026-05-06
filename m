Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F88ECD3439
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 20:57:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F0626B0088; Wed,  6 May 2026 16:57:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A0566B008A; Wed,  6 May 2026 16:57:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6406B008C; Wed,  6 May 2026 16:57:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5BAE16B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 16:57:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 01ED412029D
	for <linux-mm@kvack.org>; Wed,  6 May 2026 20:57:25 +0000 (UTC)
X-FDA: 84738205692.08.5CA9F4F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2EB35C000C
	for <linux-mm@kvack.org>; Wed,  6 May 2026 20:57:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="LadGnhx/";
	spf=pass (imf10.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778101044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jg77D7JcbUAddrtvS23FadUxeWc5c9eW6lhlc+gKI5c=;
	b=FEx8T/pRsO3XBATtt0srANpL4XXntKxacASbZdRluE4sq0QinByU0fRLzJNkCDDGg7YGGT
	d+FYmoY1gSpMmRx/K0f/qt4hiCq/Iwhl/LSBzBCSSBb/hjWT/4pvHvmpKS/PzkSAkunbcL
	vvkxoj5vRqaEpsefZ9kWG3GLIBVuRAY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778101044; a=rsa-sha256;
	cv=none;
	b=B24Fsm8rVsHQI083jusaMKupk96yPWsUodUoxGNR4670LWgf2rQvskKOv9qFV5jt9/Q4Mu
	9yK+9oxHIIlWEke6iqWB9tDS08Bf2zCjZB9ZAEcdHLJ4SUIiRCiMhGqQmfah5iKzyvGoZz
	W/2SKzZQibi9/z6PYE3LVYogtbTzSyk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="LadGnhx/";
	spf=pass (imf10.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 715836013B
	for <linux-mm@kvack.org>; Wed,  6 May 2026 20:57:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F2CC2BCFA
	for <linux-mm@kvack.org>; Wed,  6 May 2026 20:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778101043;
	bh=pW8uXu+LHQnPU20yB7kegJlrYfjbjquYDEnrZG5nLB8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=LadGnhx/0jjrUUU5MgxKXRZSNKulBJs0Jw21I1EJu7NB9tONgUjIn6qBqcRYY9Mjj
	 3a1McRnMevwjRae5WVmMW+/PQAZ2sMa6metO+Ypyh1RvyWiqFafHpQkPXa29leQVpO
	 45aZJL3/L1Hdu0aD+m0lL2qpXVFWxNXLp7AH0wjj/dKXsZYYhqJpI1h2H3IctvINTL
	 /7uIPMR+15PkZJZDNsCZoczMSPpwi7cEjbBlA937Dy7JqDjWReNgm735C5jySP6s21
	 M/4Br+rWccGXz5zYuDosprRdM/anRG6izwD0zObi9ZNgDLzmPCdRGJLUzkeP0Tk80i
	 Pw+FFpDwzTXTA==
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-65c305f381eso86894d50.3
        for <linux-mm@kvack.org>; Wed, 06 May 2026 13:57:23 -0700 (PDT)
X-Gm-Message-State: AOJu0Yz6F9mDSOnDf6kLhneFRKP3Ji7SIdLSaIm6U6hYvkcPYTl8sOc+
	XSKSZrM5/uq+f66HJ8pPBHyihTkR7YNCbCp5y0n4FV427da2BdftZDptvww6yzfUVzDgMj+7ZBl
	WjOrKHIT2xC+2rfzHflHvvnb2E+oaKfjI+LWJXYb0Jg==
X-Received: by 2002:a53:ba85:0:b0:650:31d2:234f with SMTP id
 956f58d0204a3-65c79a050edmr4083353d50.51.1778101042371; Wed, 06 May 2026
 13:57:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com> <20260421-swap-table-p4-v3-6-2f23759a76bc@tencent.com>
In-Reply-To: <20260421-swap-table-p4-v3-6-2f23759a76bc@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 6 May 2026 22:57:11 +0200
X-Gmail-Original-Message-ID: <CACePvbXQcj+k8JbDXuGoCx6_qJaJg0RuOo5CT66-rVszJ2_7Yw@mail.gmail.com>
X-Gm-Features: AVHnY4LGClhGvn4cGG2NViAGtptr-fMX3vrnxcH1j_0UxcXuA3X80z-nqFq4XQc
Message-ID: <CACePvbXQcj+k8JbDXuGoCx6_qJaJg0RuOo5CT66-rVszJ2_7Yw@mail.gmail.com>
Subject: Re: [PATCH v3 06/12] mm/memcg, swap: tidy up cgroup v1 memsw swap helpers
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2EB35C000C
X-Rspam-User: 
X-Stat-Signature: r1dirmr69katj17s6zmfo7uag39bkf5k
X-HE-Tag: 1778101044-856126
X-HE-Meta: U2FsdGVkX1+TSK9owiGfnGrYpXNNCdaNk5/46gcTM0N5AJPvmrh7ZPNkIBYePok8icPvpL7RxPCH3BzmWWu4c95C8/qPQV4l/jqnZB9Gby1idHd7Z+dPlwXmfNSPkJRQlhvzRX9NPOX0OISAyWu4G2c7kbQlV0i818CWn14BAGwi98bpncH8MWOKton44pIaf3mrhXJesYwywwPIM4BuS8k/OWtVIW6ympj2QcpP8h+Jg84HhGY1ImBD0E/Glkf7oqNOCq+F41ZzVV8rGQiVCOTWSFN3S8kzkrUzoxpCa71WjusCSTohp5nSVloT5JWvCk0iJSWhUXwN8U4AMqU+qsyxaf2uTqP3FSdd1zaJxJ/uliqlmz/9Sw+l8FhgCC5Vhiv1t3q9cQimszFonI42Ajg3+SEIlzc8kYseSLgIEsV+fmnNZ4JuICaHVO3LCyE0Wmi2Cj0Hi70BT0rCbDQIEjsZ0FGfc3C6i6QEdpZy2LIjmuRNMslgZgiesBUGto07RbKbyUoz5wN6T0+OV4Vn4OFtr8vcGM+6rgj2pdQ4ZeY7KNf0S5X4Vt+mQsEwcsNmSxXlLmZwfhpzJ3pc73AH2zw+SI5AwIFoiQyPWhb4EWOXHRHEtL/zq4GCp/nr2SsYMtvFtW+5inFABosQbDUJh7GVqX6arN2xVev1/8epMfWO023Pwd8xFpTmoQ+zZioOkYAIuMxvR1CGNdscJSgzO2Yu/YQCwZpGZ1JHigg6K4n+/iUHoH2fgXYbRhPzYWjY/o4sBiJz0alg493Rdmgec/TalTiKqJsRH5LVOhOh9N4F3hGTp6ZAar921JKMAiNmvELSC5xPe95Z7Etm9cHx8TTbZCa1nJEjQ6uAj91R05LzNH0kr7AzbXlBukpo21BSAU5NMrVvqf/tXH5hc0VwiarsyRD1WsmdbawZuCjceDm4oEhFfvCbC/vor+P1dammLvBydtoNz7RRvK+Vj8n
 2YPu3c7G
 JRfigJ+LGG/eI2ZSNxMq2ErPcHOxbLWuQmH7ZVQDX/dGL3zGxcVXehLm0mF1oynvdc1duK31RKRssR51XdEnUrpsq5KhfUzLTYv5azNdW/cUESC7SVE1qE/bWIj+e9yS2j3XAE893QZba/YPhyFsssxoFDQbqS0KTbyrgEYECA6L32Ib/slaI5/DzGPxq5JBLGUM9UTFuMReXSI0fbo/wEuHfooGp4NpoFHccfBJG3hb5cpv2Da8lNaUJNH11y5e7SqNrz/qEHSz/k6I/tcfRJzSxlnOj9NXCVqH/XC2+gFIzykE9h2lb9JrG2gpBuYMkIsNnzG7a7PGcju/7hfZGaSuJDMbiJ5ENtBLOSFkwhjUr5yo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 8:16=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> The cgroup v1 swap helpers always operate on swap cache folios whose
> swap entry is stable: the folio is locked and in the swap cache. There
> is no need to pass the swap entry or page count as separate parameters
> when they can be derived from the folio itself.
>
> Simplify the redundant parameters and add sanity checks to document
> the required preconditions.
>
> Also rename memcg1_swapout to __memcg1_swapout to indicate it requires
> special calling context: the folio must be isolated and dying, and the
> call must be made with interrupts disabled.
>
> No functional change.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

> ---
>  include/linux/memcontrol.h |  8 ++++----
>  include/linux/swap.h       | 10 ++++------
>  mm/huge_memory.c           |  2 +-
>  mm/memcontrol-v1.c         | 33 ++++++++++++++++++++-------------
>  mm/memcontrol.c            |  9 ++++-----
>  mm/swap_state.c            |  4 ++--
>  mm/swapfile.c              |  2 +-
>  mm/vmscan.c                |  2 +-
>  8 files changed, 37 insertions(+), 33 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index dc3fa687759b..7d08128de1fd 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1899,8 +1899,8 @@ static inline void mem_cgroup_exit_user_fault(void)
>         current->in_user_fault =3D 0;
>  }
>
> -void memcg1_swapout(struct folio *folio, swp_entry_t entry);
> -void memcg1_swapin(swp_entry_t entry, unsigned int nr_pages);
> +void __memcg1_swapout(struct folio *folio);
> +void memcg1_swapin(struct folio *folio);
>
>  #else /* CONFIG_MEMCG_V1 */
>  static inline
> @@ -1929,11 +1929,11 @@ static inline void mem_cgroup_exit_user_fault(voi=
d)
>  {
>  }
>
> -static inline void memcg1_swapout(struct folio *folio, swp_entry_t entry=
)
> +static inline void __memcg1_swapout(struct folio *folio)
>  {
>  }
>
> -static inline void memcg1_swapin(swp_entry_t entry, unsigned int nr_page=
s)
> +static inline void memcg1_swapin(struct folio *folio)
>  {
>  }
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 1930f81e6be4..f2949f5844a6 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -574,13 +574,12 @@ static inline void folio_throttle_swaprate(struct f=
olio *folio, gfp_t gfp)
>  #endif
>
>  #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
> -int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)=
;
> -static inline int mem_cgroup_try_charge_swap(struct folio *folio,
> -               swp_entry_t entry)
> +int __mem_cgroup_try_charge_swap(struct folio *folio);
> +static inline int mem_cgroup_try_charge_swap(struct folio *folio)
>  {
>         if (mem_cgroup_disabled())
>                 return 0;
> -       return __mem_cgroup_try_charge_swap(folio, entry);
> +       return __mem_cgroup_try_charge_swap(folio);
>  }
>
>  extern void __mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int n=
r_pages);
> @@ -594,8 +593,7 @@ static inline void mem_cgroup_uncharge_swap(swp_entry=
_t entry, unsigned int nr_p
>  extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
>  extern bool mem_cgroup_swap_full(struct folio *folio);
>  #else
> -static inline int mem_cgroup_try_charge_swap(struct folio *folio,
> -                                            swp_entry_t entry)
> +static inline int mem_cgroup_try_charge_swap(struct folio *folio)
>  {
>         return 0;
>  }
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 970e077019b7..9630e283cf25 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4431,7 +4431,7 @@ void deferred_split_folio(struct folio *folio, bool=
 partially_mapped)
>
>         /*
>          * Exclude swapcache: originally to avoid a corrupt deferred spli=
t
> -        * queue. Nowadays that is fully prevented by memcg1_swapout();
> +        * queue. Nowadays that is fully prevented by __memcg1_swapout();
>          * but if page reclaim is already handling the same folio, it is
>          * unnecessary to handle it again in the shrinker, so excluding
>          * swapcache here may still be a useful optimization.
> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> index 433bba9dfe71..36c507d81dc5 100644
> --- a/mm/memcontrol-v1.c
> +++ b/mm/memcontrol-v1.c
> @@ -604,18 +604,23 @@ void memcg1_commit_charge(struct folio *folio, stru=
ct mem_cgroup *memcg)
>  }
>
>  /**
> - * memcg1_swapout - transfer a memsw charge to swap
> + * __memcg1_swapout - transfer a memsw charge to swap
>   * @folio: folio whose memsw charge to transfer
> - * @entry: swap entry to move the charge to
>   *
> - * Transfer the memsw charge of @folio to @entry.
> + * Transfer the memsw charge of @folio to the swap entry stored in
> + * folio->swap.
> + *
> + * Context: folio must be isolated, unmapped, locked and is just about
> + * to be freed, and caller must disable IRQs.
>   */
> -void memcg1_swapout(struct folio *folio, swp_entry_t entry)
> +void __memcg1_swapout(struct folio *folio)
>  {
>         struct mem_cgroup *memcg, *swap_memcg;
>         struct obj_cgroup *objcg;
>         unsigned int nr_entries;
>
> +       VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
> +       VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
>         VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
>         VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
>
> @@ -641,7 +646,7 @@ void memcg1_swapout(struct folio *folio, swp_entry_t =
entry)
>         swap_memcg =3D mem_cgroup_private_id_get_online(memcg, nr_entries=
);
>         mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
>
> -       swap_cgroup_record(folio, mem_cgroup_private_id(swap_memcg), entr=
y);
> +       swap_cgroup_record(folio, mem_cgroup_private_id(swap_memcg), foli=
o->swap);
>
>         folio_unqueue_deferred_split(folio);
>         folio->memcg_data =3D 0;
> @@ -671,18 +676,20 @@ void memcg1_swapout(struct folio *folio, swp_entry_=
t entry)
>         obj_cgroup_put(objcg);
>  }
>
> -/*
> +/**
>   * memcg1_swapin - uncharge swap slot
> - * @entry: the first swap entry for which the pages are charged
> - * @nr_pages: number of pages which will be uncharged
> + * @folio: folio being swapped in
>   *
> - * Call this function after successfully adding the charged page to swap=
cache.
> + * Call this function after successfully adding the charged
> + * folio to swapcache.
>   *
> - * Note: This function assumes the page for which swap slot is being unc=
harged
> - * is order 0 page.
> + * Context: The folio has to be in swap cache and locked.
>   */
> -void memcg1_swapin(swp_entry_t entry, unsigned int nr_pages)
> +void memcg1_swapin(struct folio *folio)
>  {
> +       VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
> +       VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> +
>         /*
>          * Cgroup1's unified memory+swap counter has been charged with th=
e
>          * new swapcache page, finish the transfer by uncharging the swap
> @@ -701,7 +708,7 @@ void memcg1_swapin(swp_entry_t entry, unsigned int nr=
_pages)
>                  * let's not wait for it.  The page already received a
>                  * memory+swap charge, drop the swap entry duplicate.
>                  */
> -               mem_cgroup_uncharge_swap(entry, nr_pages);
> +               mem_cgroup_uncharge_swap(folio->swap, folio_nr_pages(foli=
o));
>         }
>  }
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c3d98ab41f1f..c7df30ca5aa7 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5456,13 +5456,12 @@ int __init mem_cgroup_init(void)
>  /**
>   * __mem_cgroup_try_charge_swap - try charging swap space for a folio
>   * @folio: folio being added to swap
> - * @entry: swap entry to charge
>   *
> - * Try to charge @folio's memcg for the swap space at @entry.
> + * Try to charge @folio's memcg for the swap space at folio->swap.
>   *
>   * Returns 0 on success, -ENOMEM on failure.
>   */
> -int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
> +int __mem_cgroup_try_charge_swap(struct folio *folio)
>  {
>         unsigned int nr_pages =3D folio_nr_pages(folio);
>         struct page_counter *counter;
> @@ -5479,7 +5478,7 @@ int __mem_cgroup_try_charge_swap(struct folio *foli=
o, swp_entry_t entry)
>
>         rcu_read_lock();
>         memcg =3D obj_cgroup_memcg(objcg);
> -       if (!entry.val) {
> +       if (!folio_test_swapcache(folio)) {
>                 memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
>                 rcu_read_unlock();
>                 return 0;
> @@ -5498,7 +5497,7 @@ int __mem_cgroup_try_charge_swap(struct folio *foli=
o, swp_entry_t entry)
>         }
>         mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
>
> -       swap_cgroup_record(folio, mem_cgroup_private_id(memcg), entry);
> +       swap_cgroup_record(folio, mem_cgroup_private_id(memcg), folio->sw=
ap);
>
>         return 0;
>  }
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 6ebd062bcece..12b290d43e45 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -451,8 +451,8 @@ static struct folio *__swap_cache_alloc(struct swap_c=
luster_info *ci,
>                 return ERR_PTR(-ENOMEM);
>         }
>
> -       /* For memsw accounting, swap is uncharged when folio is added to=
 swap cache */
> -       memcg1_swapin(entry, 1 << order);
> +       /* memsw uncharges swap when folio is added to swap cache */
> +       memcg1_swapin(folio);
>         if (shadow)
>                 workingset_refault(folio, shadow);
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 2e384d1c78c3..e1ad77a69e54 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1730,7 +1730,7 @@ int folio_alloc_swap(struct folio *folio)
>         }
>
>         /* Need to call this even if allocation failed, for MEMCG_SWAP_FA=
IL. */
> -       if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap)))
> +       if (unlikely(mem_cgroup_try_charge_swap(folio)))
>                 swap_cache_del_folio(folio);
>
>         if (unlikely(!folio_test_swapcache(folio)))
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index bd1b1aa12581..63d06930d8e3 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -739,7 +739,7 @@ static int __remove_mapping(struct address_space *map=
ping, struct folio *folio,
>
>                 if (reclaimed && !mapping_exiting(mapping))
>                         shadow =3D workingset_eviction(folio, target_memc=
g);
> -               memcg1_swapout(folio, swap);
> +               __memcg1_swapout(folio);
>                 __swap_cache_del_folio(ci, folio, swap, shadow);
>                 swap_cluster_unlock_irq(ci);
>         } else {
>
> --
> 2.53.0
>
>

