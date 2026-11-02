Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93441606A329
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 03:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fFO/6vxR
Received: by kanga.kvack.org (Postfix)
	id 21F916B00EF; Sun,  1 Nov 2026 22:23:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F7226B05B1; Sun,  1 Nov 2026 22:23:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10DC36B05B2; Sun,  1 Nov 2026 22:23:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA1A76B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:23:38 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A4D181C0023
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:23:36 +0000 (UTC)
X-FDA: 85388734032.17.6F37544
Received: from mta0.migadu.com (out-157.mta0.migadu.com [91.218.175.157])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6FC55140006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:23:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="fFO/6vxR";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.157 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793589814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KYCLiYkyoy5vXAtRAePofeFpQCci2FZkzSuGGfS7V5A=;
	b=guPnc78kSoiVCrwxh2cavfPctJL3w4JqfCs9eFE7OaISlj3/3guMSQ+iIN748A1sg1zpf4
	9GdGzfdwfA1aZax5xFHqbirlIoL1v8pguXQld/Eji/gcBOPVjvggNfnolxrtuhAkFV0ZLE
	ogs4BHKl84UamARt9CiBeTNsqQM7NuM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="fFO/6vxR";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.157 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793589814;
	b=2HGtt2F4j1AMwdrDdq+N3Y9OZnDyEchIIA7u4ERSpl9/Pwlefkl7/Odi+EsrKD9uxjfeGu
	bpUbf7aGrMRLOq9c+ozrwmqH7zGxV+HifY8HO/9VD3Oa/sm4Svkm8IC9zbcpSsYiz7MYEH
	6aYBcjFZ0s4alWcvMKwPA5ZmOntg5GQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tfGJW2pm7rsVTNhxOb+3yy+O7wJUnX0T0SKWYoqOvjc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793589812; v=1; x=1794194612;
 b=fFO/6vxR1pLx1xMSCBNG5xG9Ja4gogQLWicfEfMeLr/3CT0kHgzRrjqTbGlZ3RLnZlLbZjwo
 MOuc3j3IMptJlSCIN2hHaSueqR9d3oHDstMSSzeXdwZbOCqPw5fxZ/L0E7nvuYOrUQZPk2dk5js
 +6XuKcsL/uHWtBfLuUTDKV2g=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 4c21ffed9278b7bd;
	Mon, 02 Nov 2026 03:23:32 +0000
X-Mizu-Trace-ID: 4c21ffed9278b7bd
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 3/3] mm/hugetlb: Fix NR_HUGETLB accounting for surplus
 folios
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261102024910.31486-4-kaitao.cheng@linux.dev>
Date: Mon, 2 Nov 2026 11:23:12 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Mani Tofigh <mt4022@columbia.edu>,
 Zi Yan <ziy@nvidia.com>,
 Mike Kravetz <mike.kravetz@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Frank van der Linden <fvdl@google.com>,
 Chris Down <chris@chrisdown.name>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
Content-Transfer-Encoding: quoted-printable
Message-Id: <320A5EDF-0511-4069-A276-599852CCD6F2@linux.dev>
References: <20261102024910.31486-1-kaitao.cheng@linux.dev>
 <20261102024910.31486-4-kaitao.cheng@linux.dev>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Queue-Id: 6FC55140006
X-Rspam-User: 
X-Stat-Signature: rwizj141o73yufaujen698bejhfod1cu
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793589814-278199
X-HE-Meta: U2FsdGVkX1/adsX6nHuU+aP8pfk0B0Y9l83n8OjKXruYpU929MjX3lleKfbbWykvkRaH4PXu0cxkSJIyRN0Ig7UiuPlTbc2henIpgPYH3KnfCsNs2tc2iQv2t4egkS4qf8LDVlDFC9M859QvjZlOnai5nwI3wnltKiZQ4B/oRRuXFJHY0E3elVd1URK2oyHgmp6oSu7zLI4APz6YEZDNln+NObjgWJV0kM2PQmU/gv769nENuT5nEPhurgJfH+0K1p5U7boKyQ1l84tlHlg3ZBQtJBxL0w8e1i6xsOCanSwTgzMp+XmutvIj9E5SYNZG6LJpORlhDGYW9bAWU4Gj63ity3zOpFxYWGRESLj9/66m0VA+Fj1HlbgCRZ8aKJN58m8JvbMBKHTaBIVQbNi90A3BwcO3rNA67KXZo+0SAmd82iGIR53LX7dS+Zp1ipEMoxk1TZ2em6VbsCteNK53fQ7+2dqbtdTAge2MzX4dulMhbFLEL2Ny32bQ7zX7dKAilmZM9boqNNTLV3FQqYfe/ERhaY7X286skwkKA45rgn1bPW60kh35vcMMraQbYDYa9ojkXPwGukxQQpYkbUSPrS0KjCXhZloFMLujxWAMpUrgPONgWjaYAZ4agzFifMx83O4OLIyUPN5uwmdlhmR7wKh3IAb5xvLNw81sPece9mpq/jMKsGIbT5PCyup9l14ZnCKwR7h/x1SIb1ZdUrwZjJMV97Xy3KFnhYIp5ticnSAVBmU+PI5Ni8wTFpk9V7JN5MZPAbcs6zciO326s5OmUEFc3bZIljgd63pqO79iW22Tu9VuVerboEIRoyf5W74YRIPs6TTNOstrB26uzBdNvaaDJI1a5u/SaE4f2oPUPAAV/dtnCR42sWqD0BjW+O8QMUx5wFU37E90uXQfJbB2AYlqEnCCcE4Zb6Qz7wTqAgHuLQpImO1AOaKvsjT74/2g4pftdz+MJokVjKLvTg2
 qwKWxSXN
 QToI6g7DX8p72JZuTuw3wDBkASrdSCVcOy/QALY+6/sXQsbFnuH780wTtVtnrdN1Pak89/BQrVt1rwMQXG5cqjFhpeal8qYi4zBvxUh+sb6XIAybDGewDlGuSFED4Ki6NbqNRCKWbm6K73PUrN3hj7EOfVqmcjtS6WJY/wyAFczZo03xPAaOjc2gI3DN4AVTc2LVJxglDiyukEVik1tcrMC46n3wx8c/9X/oLB6ICUdjPp32nEZBtN95LY2wPe6TJmFkrWiMLatvWXazlY5gkjABIT31TPefcU/Qgy9OiiXzsUuv2s0ykkyjARofAe1FPVoEcjt4MI4pUyfuXbwuh5j22oPSua+Zfl3dqxnE0PLrALDHsahuqEfK1xSyyQ9TPrSzUM0jn6ad95jRc1tzBtgbny9TkYYLYdvESlfpZVDVhqZMoCbM6O8l+ukQjkvDwvUAn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 2, 2026, at 10:49, Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
>=20
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>=20
> NR_HUGETLB is incremented in the allocation entry points, but =
decremented
> unconditionally in free_huge_folio(). Surplus folios allocated while
> gathering reservations can be freed without passing through those =
entry
> points, leaving an unmatched decrement in the per-node counter.
>=20
> This happens when reservation gathering fails or allocates more folios
> than needed, or when the overcommit recheck rejects a newly allocated
> surplus folio. These paths cause nr_hugetlb in /proc/vmstat to =
underreport
> usage.
>=20
> Move node accounting to the underlying folio state transitions. =
Increment
> NR_HUGETLB when dequeuing a free folio or allocating a fresh surplus =
or
> migration folio, and decrement it when returning the folio to the pool =
or
> removing it from active use. Balance the temporary increment when =
surplus
> folios gathered for reservations are added to the free pool.
>=20
> Separate memcg statistics from node accounting, updating them after a
> successful charge and before uncharging. This keeps node accounting
> balanced independently of whether the folio is charged to a memcg.
>=20
> Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
> Closes: =
https://sashiko.dev/#/bug/linux-860a3b8f-0b07-4cd5-a122-aa2288463bee
> Suggested-by: Muchun Song <muchun.song@linux.dev>
> Suggested-by: Oscar Salvador <osalvador@suse.de>
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> ---
> mm/hugetlb.c    | 42 +++++++++++++++++++++++++++---------------
> mm/memcontrol.c |  6 +-----
> 2 files changed, 28 insertions(+), 20 deletions(-)

I want to keep it simple for a backport fix, so your last version is =
good
to me, and this one should be a cleanup based on the top of that.

Thanks.

>=20
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 931ca3a30773..d1d7e14858d3 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1288,6 +1288,8 @@ static struct folio =
*dequeue_hugetlb_folio_node_exact(struct hstate *h,
> 		folio_clear_hugetlb_freed(folio);
> 		h->free_huge_pages--;
> 		h->free_huge_pages_node[nid]--;
> +		mod_node_page_state(folio_pgdat(folio), NR_HUGETLB,
> +				    pages_per_huge_page(h));
> 		return folio;
> 	}
>=20
> @@ -1416,6 +1418,9 @@ void remove_hugetlb_folio(struct hstate *h, =
struct folio *folio,
> 		folio_clear_hugetlb_freed(folio);
> 		h->free_huge_pages--;
> 		h->free_huge_pages_node[nid]--;
> +	} else {
> +		mod_node_page_state(folio_pgdat(folio), NR_HUGETLB,
> +				    -(long)pages_per_huge_page(h));
> 	}
> 	if (adjust_surplus) {
> 		h->surplus_huge_pages--;
> @@ -1693,6 +1698,17 @@ struct hstate *size_to_hstate(unsigned long =
size)
> 	return NULL;
> }
>=20
> +static void mod_hugetlb_memcg_state(struct folio *folio, int =
nr_pages)
> +{
> +	struct mem_cgroup *memcg;
> +
> +	guard(rcu)();
> +	memcg =3D folio_memcg(folio);
> +	if (memcg)
> +		mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, =
folio_pgdat(folio)),
> +				       NR_HUGETLB, nr_pages);
> +}
> +
> void free_huge_folio(struct folio *folio)
> {
> 	/*
> @@ -1740,7 +1756,7 @@ void free_huge_folio(struct folio *folio)
> 				     pages_per_huge_page(h), folio);
> 	hugetlb_cgroup_uncharge_folio_rsvd(hstate_index(h),
> 					  pages_per_huge_page(h), =
folio);
> -	lruvec_stat_mod_folio(folio, NR_HUGETLB, =
-pages_per_huge_page(h));
> +	mod_hugetlb_memcg_state(folio, -pages_per_huge_page(h));
> 	mem_cgroup_uncharge(folio);
> 	if (restore_reserve)
> 		h->resv_huge_pages++;
> @@ -1756,6 +1772,8 @@ void free_huge_folio(struct folio *folio)
> 		spin_unlock_irqrestore(&hugetlb_lock, flags);
> 		update_and_free_hugetlb_folio(h, folio, true);
> 	} else {
> +		mod_node_page_state(folio_pgdat(folio), NR_HUGETLB,
> +				    -(long)pages_per_huge_page(h));
> 		arch_clear_hugetlb_flags(folio);
> 		enqueue_hugetlb_folio(h, folio);
> 		spin_unlock_irqrestore(&hugetlb_lock, flags);
> @@ -2123,6 +2141,9 @@ static struct folio =
*alloc_surplus_hugetlb_folio(struct hstate *h,
> 	 */
> 	account_new_hugetlb_folio(h, folio);
>=20
> +	/* The overcommit recheck below can free this folio. */
> +	mod_node_page_state(folio_pgdat(folio), NR_HUGETLB, =
pages_per_huge_page(h));
> +
> 	/*
> 	 * We could have raced with the pool size change.
> 	 * Double check that and simply deallocate the new page
> @@ -2160,6 +2181,7 @@ static struct folio =
*alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
>=20
> 	spin_lock_irq(&hugetlb_lock);
> 	account_new_hugetlb_folio(h, folio);
> +	mod_node_page_state(folio_pgdat(folio), NR_HUGETLB, =
pages_per_huge_page(h));
> 	spin_unlock_irq(&hugetlb_lock);
>=20
> 	/* fresh huge pages are frozen */
> @@ -2218,10 +2240,6 @@ struct folio =
*alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
>=20
> 	spin_unlock_irq(&hugetlb_lock);
>=20
> -	if (folio)
> -		lruvec_stat_mod_folio(folio, NR_HUGETLB,
> -				      folio_nr_pages(folio));
> -
> 	return folio;
> }
>=20
> @@ -2249,9 +2267,6 @@ struct folio =
*alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
> 						    nmask);
> 	}
>=20
> -	if (folio)
> -		lruvec_stat_mod_folio(folio, NR_HUGETLB, =
folio_nr_pages(folio));
> -
> 	return folio;
> }
>=20
> @@ -2369,6 +2384,8 @@ static int gather_surplus_pages(struct hstate =
*h, long delta)
> 		if ((--needed) < 0)
> 			break;
> 		/* Add the page to the hugetlb allocator */
> +		mod_node_page_state(folio_pgdat(folio), NR_HUGETLB,
> +				    -(long)pages_per_huge_page(h));
> 		enqueue_hugetlb_folio(h, folio);
> 	}
> free:
> @@ -2944,13 +2961,6 @@ struct folio *hugetlb_alloc_folio(struct hstate =
*h,
>=20
> 	ret =3D mem_cgroup_charge_hugetlb(folio, mm,
> 					gfp | __GFP_RETRY_MAYFAIL);
> -	/*
> -	 * Unconditionally increment NR_HUGETLB here because if
> -	 * mem_cgroup_charge_hugetlb failed, freeing the page will
> -	 * decrement NR_HUGETLB.
> -	 */
> -	lruvec_stat_mod_folio(folio, NR_HUGETLB, nr_pages);
> -
> 	if (ret =3D=3D -ENOMEM) {
> 		folio_put(folio);
> 		/*
> @@ -2965,6 +2975,8 @@ struct folio *hugetlb_alloc_folio(struct hstate =
*h,
> 		return ERR_PTR(-ENOSPC);
> 	}
>=20
> +	mod_hugetlb_memcg_state(folio, nr_pages);
> +
> 	return folio;
>=20
>  err_uncharge_hugetlb_cgroup:
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 84f4a8fd4d16..3bfe4b108170 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5417,11 +5417,7 @@ int mem_cgroup_charge_hugetlb(struct folio =
*folio, struct mm_struct *mm,
> 	struct mem_cgroup *memcg =3D get_mem_cgroup_from_mm(mm);
> 	int ret =3D 0;
>=20
> -	/*
> -	 * Even memcg does not account for hugetlb, we still want to =
update
> -	 * system-level stats via lruvec_stat_mod_folio. Return 0, and =
skip
> -	 * charging the memcg.
> -	 */
> +	/* Skip charging unless hugetlb accounting is enabled for cgroup =
v2. */
> 	if (mem_cgroup_disabled() || !memcg_accounts_hugetlb() ||
> 		!memcg || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
> 		goto out;
> --=20
> 2.54.0 (Apple Git-157)
>=20


