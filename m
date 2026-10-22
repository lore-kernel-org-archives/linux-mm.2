Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B678606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 06:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EMOldWTV
Received: by kanga.kvack.org (Postfix)
	id A655E6B089C; Thu, 22 Oct 2026 02:19:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3CF06B089E; Thu, 22 Oct 2026 02:19:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 979D76B089F; Thu, 22 Oct 2026 02:19:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 72D536B089C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:19:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 12E91C075C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:19:25 +0000 (UTC)
X-FDA: 85349260290.08.43A5512
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5F51A40002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:19:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EMOldWTV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792649963;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xESupiZXdxa3YgPna/4sC2Lw6QY0qKopaBrR8WCBn2w=;
	b=tGoxfl8ybhQa5f2okcERjgcUOen3wBWyNjnpXdqywO678SvhZyuYvHCr9WlD9Rj2X2ALGB
	d5kZZ6bQlSPsUfWET3N+41bbUGMv/iK3RRZ9D9P0LyA8cUD66cFYC+5saUz25JsBjJyWKv
	4coN2/R7l7QlGI5hqO/Zx2mqpQXlcBA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EMOldWTV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792649963;
	b=KrjGPHcjafFnqIDjY5Wb+qtIZNscxoMxGiLI15UiHj6adKw2HE66V9JCZXYrSydt5dJLe9
	looGT9gLvYRuDU8o1mZt8F7A961BpevVjTCuMt3kg4uE3arfKcI1YfOj9g49LFYKiiCNS8
	GcTw7T45t8/z44pXhfYUaqYZu/Sl2ow=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A968740EFB;
	Thu, 22 Oct 2026 06:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70FD51F000C1;
	Thu, 22 Oct 2026 06:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792649962;
	bh=xESupiZXdxa3YgPna/4sC2Lw6QY0qKopaBrR8WCBn2w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EMOldWTVsKh3FdohnyWQBZYsGt0TRHuuizZhDz1azyQdmEjfsJRUJ4S72KIV2Fsrh
	 OTNpV6sKUEThiaIHLru7NR3ZJwgCzMU3sC/zgeRKDlSp1YcgVccrO2WSLQlIWWIqq8
	 aT4IdrSMIVEVrGyFLujgWQXGAWd5n/z5tfHjtWqO4ILRyxkPg6DCODyN/1OjE8eZdF
	 d07Vqm6s/Dmg66FfCMbcTjydn42N6GbnFlOV4cQKE16xFuIMsosTTNUf8oxjmZTMvZ
	 NMACKPhzwKkgTLR1Gy+sL76eoh+VbLLq2/67onqbRYIhPegA9/X5sNTInyJ9sGGN8f
	 3opuB1+qs5wow==
Message-ID: <sashiko-outbox-181081@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 07/12] mm, swap: reclaim physical slots backing
 cache-only vswap entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nhat Pham" <nphamcs@gmail.com>, akpm@linux-foundation.org
Cc: chrisl@kernel.org, kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, yosry@kernel.org, david@kernel.org, muchun.song@linux.dev, shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, riel@surriel.com, gourry@gourry.net, haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, skhan@linuxfoundation.org, rdunlap@infradead.org, kunwu.chan@linux.dev, kernel-team@meta.com, linux-mm@kvack.org
In-Reply-To: <20261021060323.553433-8-nphamcs@gmail.com>
References: <20261021060323.553433-1-nphamcs@gmail.com>
 <20261021060323.553433-8-nphamcs@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 06:19:20 +0000
X-Rspamd-Queue-Id: 5F51A40002
X-Stat-Signature: nwzt37kungapi1xwid7tsqw5zakmzjnu
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792649963-253486
X-HE-Meta: U2FsdGVkX19aflxMaTVEqYKNnGmElCByfH5+N3K0sQif4z3ffY8GMPJf2F5EgEVuDZhj8X+9J585E8kV7X/LMf0nEzPEDWItzkqmDwLt9Nd+C4pIx/oLxcp1tSCXIkjLeyfJ6dPlbFDkgSqls1Dub4amgXcrcyaA8hpbOyzxRbqavg/iL4zc81OpbA3SEqDrrmlIgwWGJaOMJLX3B826rAl1ZJUj5yaghRS1IwrEqz4u3n7hxxJlmC3FbGEad0OcGiwFFiTHWWm/cDD4uIyA6O5T6D2mNI4yJeG3/Uc3yl1oWOxKw3DMzvqYLFbs7JBAsX6GF1tmIuwIbz2QkmXGLC0r5OnOyRP7VQ9Lqj8XWulsn3ePhrPCtVXUjiOV8n5kgEVZjTedVigrRWkfxaALCO5RYoZQXoJJ0DX1nH+PUdyWfBlOEuvAd4E7K5BI6TXYGGM5jHDxWJgQ6Qe/fk/kK3KsxL0/Lc3a47BvHBZZSrx7gLy0ILu1egCw9aFEEMjx/UAbDcIhIBvGivHJzj6QnhoWeXP41EQjisMiv2eLC6IN1FCVWP0KoymGixQk0Jv1a0Ao1A1Ep2xJscBYh7TBU9uFShBms+moR462/5NU6+hToxYfWBAmEiRiq6Duui0hxny6dZSPb5NHSGUzyqtEwIVwbK0og5MY+uDGOvA6oyxItuIeH+kDDouI7qVcdb5MrtOjgFxM0I+/v/3vCGFIXaoad5SQASG12fUIdWtIe+YRPQdb3x2Z2QLoEcADGyWEKWQLzUkGF/DHuWt6Iiz8gQSuXrK0bH/nutvbOr54bVs1/QvhqV40fjXHdZvRDDQq68qA5SKf6KW/AZ9Evx7JB3eg+thOlDjiQ3oX3PnLVZH5XwZe6vkRWhbvU7Bxwkozm5VbBNTDIDGsl1Mnz5EaaUnuNCSlhZB3PxBmQruhm3a8OrQrJaz1hK3+zju1jRDr7HQdIwyeFdRqKlICgVk
 QvmomLOT
 I3G+tsVu7sPnuLKN54Js2P2u/MBWShQlQFNklFjLShXYzqaaIAjkRvASIWNigI2zH92gMN3/gBA4BBvltQLXh4NxGdmzTFRc4Ov3I6/EImJMSlNLVVHuZcC/yi/GEB6GpDSxEdG5RFO86Ixxc4ckab23IFybl9BnjQBDTpv/AuwrNyHnQKydwZDRKS4aRlkMO2mA5rWyj9cc7XfRVVOcRs9p8IbVgQ8YyUaef/ATsvflFibgBUIN6vN6WlTrNAbFHt1Eio7Q3DbWX1mSiqiaEQuJPYm9LGNvzCZ0WaV/N/buOVP2DHdrplFURC1CiT3M45GNHGb+pJ/XcQpcWhrlriJ+VggEmFZPZrho2hYclrhJEgE7tEGXiZatpjCQl2bWv2Uz9enxUBVf/JvirO9hIdZaQgZ+yrgOVlf8SPbiT1UDCyRYhAsAWrc3FWmA1CHhg7Z3Gvn52TydNhsephNgRik0iOs6rnQ7lFqY+JcGTbYmvbl7lSnS9dQs9rdKijzG52pQvRossPJN9Wk8qzctYlp4yfNEkVEDpJwedPYUKTcMftV/ynWfY4YsKa/HOm6ySihwyCGcvN7w2zGjL7gWvfTJD7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] mm, swap: try_to_reclaim_vswap_backing() overshoots physical run=
 when i > 0
- [Medium] mm, swap: folio_realloc_swap() misses SWP_RMAP_CACHE_ONLY when s=
wap_count is 0
- [Medium] mm, swap: missing vswap cache-only reclaim in cluster_scan_range=
()
--

commit e03ce92e52f674a68e33585bcd17c229fae53bf0
Author: Nhat Pham <nphamcs@gmail.com>

mm, swap: reclaim physical slots backing cache-only vswap entries

This commit introduces a SWP_RMAP_CACHE_ONLY flag on physical swap table rm=
ap
entries when a vswap slot's swap count drops to zero while its folio remains
in the swap cache. It teaches swap_reclaim_full_clusters() to reclaim those
physical backing slots via try_to_reclaim_vswap_backing().

> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index be66ac79313ce..640e38a55497e 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
[ ... ]
> @@ -877,6 +882,55 @@ static int swap_cluster_setup_bad_slot(struct swap_i=
nfo_struct *si,
>  	return ret;
>  }
> =20
> +/*
> + * Try to reclaim a Vswap-tagged physical slot backing a vswap entry.
> + * The physical cluster lock must NOT be held. Returns the backing folio=
's
> + * page count, negated if the slots could not be reclaimed, or 0 if the
> + * folio could not be shown to own @offset (i.e. there is a race).
> + */
> +static int try_to_reclaim_vswap_backing(struct swap_info_struct *si,
> +					unsigned long offset,
> +					swp_entry_t vswap_entry)
> +{
> +	swp_entry_t phys_base;
> +	struct folio *folio;
> +	unsigned int i;
> +	int ret;
> +
> +	folio =3D swap_cache_get_folio(vswap_entry);
> +	if (!folio)
> +		return 0;
> +
> +	if (!folio_trylock(folio)) {
> +		/* Unvalidated: the folio may not even own @offset. */
> +		folio_put(folio);
> +		return 0;
> +	}
> +
> +	if (!folio_matches_swap_entry(folio, vswap_entry)) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +		return 0;
> +	}
> +
> +	i =3D vswap_entry.val - folio->swap.val;
> +	phys_base =3D vswap_to_phys(folio->swap);
> +	if (!phys_base.val || swp_type(phys_base) !=3D si->type ||
> +	    swp_offset(phys_base) + i !=3D offset) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +		return 0;
> +	}
> +
> +	/* The run is ours: skip it all, whether or not the free succeeds. */
> +	ret =3D folio_nr_pages(folio);
> +	if (!folio_free_swap(folio))
> +		ret =3D -ret;
> +	folio_unlock(folio);
> +	folio_put(folio);
> +	return ret;
> +}

[Severity: Medium]
When try_to_reclaim_vswap_backing() in mm/swapfile.c is called for a large
folio at a non-zero subpage offset (where i =3D vswap_entry.val -
folio->swap.val > 0 and offset =3D=3D swp_offset(phys_base) + i), doesn't
returning folio_nr_pages(folio) cause swap_reclaim_full_clusters() to
overshoot the end of the folio's physical slot run by i slots?

This can happen when scanning a cluster in swap_reclaim_full_clusters() if:
- subpages 0..i-1 still have swap_count > 0 (so SWP_RMAP_CACHE_ONLY is not
  set on them) while subpage i had its swap_count drop to 0 via single-PTE
  swap-in or partial unmap,
- folio_trylock(folio) fails on subpages 0..i-1 and then succeeds on
  subpage i, or
- a concurrent swap_put_entries_cluster() marks the folio's subpages
  SWP_RMAP_CACHE_ONLY after the scanner has already advanced past subpages
  0..i-1.

Because swap_reclaim_full_clusters() advances offset by:

    offset +=3D abs(nr_reclaim);

returning folio_nr_pages(folio) instead of folio_nr_pages(folio) - i advanc=
es
offset to swp_offset(phys_base) + i + folio_nr_pages(folio), skipping the
first i physical slots of the following folio(s) in the cluster. Should ret
be initialized to folio_nr_pages(folio) - i instead?

> @@ -1182,6 +1237,19 @@ static void swap_reclaim_full_clusters(struct swap=
_info_struct *si, bool force)
>  					offset +=3D abs(nr_reclaim);
>  					continue;
>  				}
> +			} else if (swp_tb_is_vswap(swp_tb) &&
> +				   (swp_tb & SWP_RMAP_CACHE_ONLY)) {
> +				vswap_entry =3D swp_tb_vswap_to_swp_entry(swp_tb);
> +				spin_unlock(&ci->lock);
> +				nr_reclaim =3D try_to_reclaim_vswap_backing(si, offset,
> +									  vswap_entry);
> +				ci =3D swap_cluster_lock(si, offset);
> +				if (!ci)
> +					goto next;
> +				if (nr_reclaim) {
> +					offset +=3D abs(nr_reclaim);
> +					continue;
> +				}
>  			}
>  			offset++;
>  		}

[Severity: Medium]
While swap_reclaim_full_clusters() in mm/swapfile.c is updated here to
reclaim SWP_RMAP_CACHE_ONLY entries from full clusters, what about non-full
or fragmented clusters scanned during allocation via
folio_alloc_phys_swap() -> alloc_swap_scan_cluster()?

In mm/swapfile.c, cluster_scan_range() currently only checks for direct
folio entries with swap_count =3D=3D 0:

    if (swp_tb_is_folio(swp_tb) && !__swp_tb_get_count(swp_tb)) {
        if (swap_is_vswap(si) || !vm_swap_full())
            return false;
        *need_reclaim =3D true;
        continue;
    }
    /* Slot with zero count can only be NULL or folio */
    VM_WARN_ON(!swp_tb_get_count(swp_tb));
    return false;

And cluster_reclaim_range() stops on any entry where swp_tb_get_count(swp_t=
b)
is non-zero (which returns -EINVAL for Vswap-tagged entries):

    do {
        swp_tb =3D swap_table_get(ci, offset % SWAPFILE_CLUSTER);
        if (swp_tb_get_count(swp_tb))
            break;
        if (swp_tb_is_folio(swp_tb))
            if (__try_to_reclaim_swap(si, offset, TTRS_ANYWAY) < 0)
                break;
    } while (++offset < end);

If a physical cluster has some free slots (ci->count < SWAPFILE_CLUSTER, so
it sits on percpu_swap_cluster, global_cluster, si->nonfull_clusters[order],
or si->frag_clusters[order] rather than si->full_clusters), won't
SWP_RMAP_CACHE_ONLY slots in that cluster prevent cluster_scan_range() and
cluster_reclaim_range() from reclaiming them when vm_swap_full() is true,
causing high-order physical swap allocations to fail prematurely?

[ ... ]
> @@ -1752,6 +1820,8 @@ static void swap_put_entries_cluster(struct swap_in=
fo_struct *si,
>  			}
>  			/* count will be 0 after put, slot can be reclaimed */
>  			need_reclaim =3D true;
> +			if (swap_is_vswap(si))
> +				vswap_mark_cache_only(ci, ci_off);
>  		}
>  		/*
>  		 * A count !=3D 1 or cached slot can't be freed. Put its swap
[ ... ]
> @@ -2008,6 +2080,51 @@ int folio_alloc_swap(struct folio *folio)
>  	return order ? -E2BIG : -ENOMEM;
>  }
> =20
> +static void vswap_mark_cache_only(struct swap_cluster_info *ci,
> +				  unsigned int ci_off)
> +{
> +	struct swap_cluster_info_dynamic *ci_dyn;
> +	struct swap_cluster_info *pci;
> +	swp_entry_t phys;
> +	unsigned long vt;
> +
> +	ci_dyn =3D container_of(ci, struct swap_cluster_info_dynamic, ci);
> +	vt =3D __vtable_get(ci_dyn, ci_off);
> +
> +	if (vtable_type(vt) =3D=3D VSWAP_SWAPFILE) {
> +		phys =3D vtable_to_phys(vt);
> +		pci =3D __swap_entry_to_cluster(phys);
> +		swap_rmap_mark_cache_only(pci, swp_cluster_offset(phys));
> +	}
> +}

[Severity: Medium]
Can physical swap slots remain unmarked with SWP_RMAP_CACHE_ONLY if a vswap
slot already has swap_count =3D=3D 0 when folio_realloc_swap() in mm/swapfi=
le.c
installs its physical backing?

In folio_realloc_swap(), folio_alloc_phys_swap() ->
__swap_cluster_alloc_entries() initializes the physical swap_table entries
with swp_entry_to_swp_tb_vswap(v) (with SWP_RMAP_CACHE_ONLY clear), and then
folio_realloc_swap() writes VSWAP_SWAPFILE into virtual_table under ci->loc=
k:

    for (i =3D 0; i < nr; i++) {
        pe.val =3D phys_entry.val + i;
        __vtable_set(ci_dyn, voff + i, vtable_mk_phys(pe));
    }

However, vswap_mark_cache_only() only sets SWP_RMAP_CACHE_ONLY during
swap_put_entries_cluster() when swap_count transitions from 1 to 0 and
vtable_type(vt) is already VSWAP_SWAPFILE. A vswap slot can already have
swap_count =3D=3D 0 when folio_realloc_swap() installs VSWAP_SWAPFILE in two
cases:

1. During swap_writeout() or zswap_writeback_entry(), the folio is locked
   while virtual_table is still VSWAP_NONE or VSWAP_ZSWAP. A concurrent PTE
   zap (such as munmap() or MADV_DONTNEED calling free_swap_and_cache_nr() =
->
   swap_put_entries_direct() -> swap_put_entries_cluster()) can drop the
   vswap slot's swap_count from 1 to 0 before folio_realloc_swap() sets
   VSWAP_SWAPFILE. At that point vswap_mark_cache_only() sees
   vtable_type(vt) !=3D VSWAP_SWAPFILE, and __try_to_reclaim_swap() cannot
   lock the folio.
2. When swapping out a partially unmapped large folio (mTHP), some subpages
   may already have swap_count =3D=3D 0 while other subpages have swap_coun=
t > 0.

Since swap_count is already 0, swap_put_entries_cluster() will not run on
those slots again. Should folio_realloc_swap() check whether
__swp_tb_get_count(__swap_table_get(ci, voff + i)) =3D=3D 0 while holding
ci->lock and mark the corresponding physical rmap entry with
SWP_RMAP_CACHE_ONLY?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021060323.5534=
33-1-nphamcs@gmail.com?part=3D7

