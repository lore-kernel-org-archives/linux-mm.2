Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56DDDC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 18:48:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 393876B00A6; Tue, 30 Jun 2026 14:48:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 345006B00A8; Tue, 30 Jun 2026 14:48:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20CCB6B00A9; Tue, 30 Jun 2026 14:48:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD4FC6B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:48:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5B0F81405D8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 18:48:12 +0000 (UTC)
X-FDA: 84937464024.03.6198EAC
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7645C160006
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 18:48:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rzLM0sz1;
	spf=pass (imf08.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782845290;
	b=DkrLqUAxss3qI2TQMplFfg8a7b4Czs5rx2mWoIdtJzL5u8rElwmzTFvhnUxOnveH3G8SLw
	JynT+nnoFfmbR+MhIYIrR9MUuvzhiK9cORQW65Apw2c7QFHIIg+Nzj5qnPJWSlS7uXi8oS
	3a23k14ADpRzYvXdB4RCfoNnd96QKJs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782845290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bg9t4ZemR7nRzkbildaNfWupgXCk3aBNIrUc/JLN7pE=;
	b=j3X5LNSk6TN51QYBbtFzMa20M4U3Os38RB1qn3qc9Uq8OWTP+uww/CnBrSVgM58vR4SvkL
	39nNsxTNFbNDD1l53e2nWwkWh4BKJgaeJSbVF4vRYpQege57sAuCvUmniqrZyj/v8dfujl
	cF+KFhAHK5Gl8LHY/G9KgkY2ECZugis=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rzLM0sz1;
	spf=pass (imf08.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782845281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bg9t4ZemR7nRzkbildaNfWupgXCk3aBNIrUc/JLN7pE=;
	b=rzLM0sz1aPtHrOmagCsFEHD9vJ2xo1UN2wDC7xJ8z77MqSOsgby/cZH56J1fxS3K/dmdeG
	Lpi1LZh1TsZdx2vuvrodosg4PmRNgThD5ZsAcOXASZdsq64mbgzcD0xiNT4ppvYE2qy6hB
	qGSt60+diFzQULLUvLfct4wzM1ci2XI=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 30 Jun 2026 18:47:37 +0000
Message-Id: <DJMLWCADJDBU.K0GQ1N0BLYNS@linux.dev>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, "Gregory Price"
 <gourry@gourry.net>, "Alexei Starovoitov" <ast@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, "Hao Ge" <hao.ge@linux.dev>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-rt-devel@lists.linux.dev>
Subject: Re: [PATCH v3 05/16] mm/page_alloc: unify
 __alloc_frozen_pages[_nolock]_noprof()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, "Brendan Jackman"
 <jackmanb@google.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Muchun
 Song" <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul Park"
 <byungchul@sk.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Hao Li" <hao.li@linux.dev>, "Christoph
 Lameter" <cl@gentwo.org>, "David Rientjes" <rientjes@google.com>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-5-57bef0eadbc2@google.com>
 <611bd3dc-95d4-45e0-ae5a-158c6cf1472f@kernel.org>
In-Reply-To: <611bd3dc-95d4-45e0-ae5a-158c6cf1472f@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7645C160006
X-Stat-Signature: jyi1gj9kj83wdp7fort3iqt651mzxn4b
X-HE-Tag: 1782845288-600432
X-HE-Meta: U2FsdGVkX19eJRSck5HUeNJTGc3IwM3/1lEybNhd2nsHPF06X1GiKGheW5U8uj7Q872DrMoPbULu9xoZ9or/FLb7KtgNAYJzTCTWHEibAB0KJP3F7QDCiG4CzzpRPGNIbApOFaEtvAsr7SELtJdFrM+dHS9P8/1QU1kS+Wdf2JyDTsCrVqGWNoQ7uf0L6vSkzE2+YPGcmvPQvvEVMeSAw6braKlLepBGIyNxi9f6jbsheT/elZhvPr8Nt0Na2ulJPba4cU0kTwRFGvbIv4ciVMjboXolIf81XbInLPyeLbwMCa5uJcCauTe8b0yckWVZhEfPsXwEaT4KdLxTuOXE5AZS3Zev4nhVsHVOsTgLnYxDxPncb6J5SSY9cTwoebbzsfdFwClGEcGGeKL+TKkYDxCq63Oki6ZhtI9hZmWkYGebevtunbGCRfDylLPd+R/PpgYGTs8OGmnUo7+fPDpsHRGC1RfoGObV7OGtTwubmMuTejqIBhQdjNZSwGb6eMPtkIxmY43UC74AHBtKgeNHRqfBKrG5lpzZV6oyzHTS52IIEWt1+4UQmlZ5WOuoqR9ZL6H6UOquW45YY/MAhjzHx4FFX6e+WwJQy7GqtigWuZf5CbkeiAri2vZjlqj3SeaT6DXbNP759nrJRMNk6AkMu/1oTwFPeSHxLFIVPZY1FN5HhMtJ/3pwMOGlilzffvW8dTpCjx3We2yM8sHf5IfYDmPpgNYrtCLL2G2E5q+8+asFfMfAGDmeVuVCa4uiNnEO2EELOs8TQmRW4YglQSonywbT24oHBK4c6KBJb4M/sg47T2eZxgPHpxQIi9IhoPKGZ8BcsEeN3TFs+N94U0L3aMqNlNxj4v4aw48V/mKvKeb13qw1P10YOxn36mjljV/rsuIsbOnspkdlsg/fRNwVL2CIJPYhOouAIsiYmC114nBs1b7dTHfC1Oc2+zRmWF8hUbg3PpW2Ud7vc3TCpyh
 C4QGaRVU
 mklimEpMqaiCHBl3eXXz+H75K+ZZvvHddtbOBZ5Y+3Kfz7gzTBTBdTCKNDgz4mIR/T0Z5a+Vs5OmGQkxKRHkqeIPnK2ESPGrD7YtSk4Hy3UyJOUHohBkqhfmDR+yZRv6SG7Ygk8nh2xBsyf6AaTsplt33fexQr3SawjfrelGiTBPKeufMGG1/TvkMDHQayurT8d92kD3CWhvF+8FPSP8SnG5waoPwcPmnpEP1nFxxdkbWg+Vhd+D/d+D/k2DWlBD2WDM5SUCYQrqbKNOtXaTtZEBO4Mkr+fULqZBZagrSxk9E4y0RyWHuzSf+hg+h4TfPITDCZUDuZj+81PRNiW3b68IO300fPUHbA7lOwFk9k70tS5Q3uhrZ5iDnW2H9c06xkIO+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jun 30, 2026 at 4:16 PM UTC, Vlastimil Babka (SUSE) wrote:
> On 6/29/26 15:11, Brendan Jackman wrote:
>> Currently the core allocator code is controlled by ALLOC_NOLOCK, but the
>> main entry point function is significantly different from the normal
>
> Let's mention it explicitly, alloc_frozen_pages_nolock_noprof().
>
>> __alloc_frozen_pages_nolock(), this is tiring when reading the code.
>
> You mean __alloc_frozen_pages_noprof()?
>
>>=20
>> Plumb the ALLOC_NOLOCK control one layer up in the call stack: create
>> an alloc_flags argument to __alloc_frozen_pages_nolock() (which is only
>
> Again __alloc_frozen_pages_noprof()
>
>> exposed to mm/) and then turn the nolock variant into a thin wrapper
>> that just sets that flag (as well as handling NUMA_NO_NODE, similar to
>> how some of the wrappers in gfp.h do).
>>=20
>> Rationale that this doesn't change anything:
>>=20
>> 1. Simple bits: A bunch of the nolock-specific handling is just moved to
>>    the new alloc_order_allowed(), alloc_trylock_allowed() and
>>    gfp_trylock.
>
> Should be alloc_nolock_allowed() and gfp_nolock
>
>> 2. __alloc_frozen_pages_noprof() has some extra logic that wasn't
>>    previously in the nolock variant:
>>=20
>>    a. Application of gfp_allowed_mask; this only affects early boot, and
>>       only flags that affect the slowpath get changed here.
>
> As discussed in reply to Harry, I'd mention the flags excluded by
> GFP_BOOT_MASK are not usable by _nolock() anyway.
>
>>    b. Application of current_gfp_context() - also only affects the
>>       slowpath
>>=20
>> 3. The slowpath itself: this is now just explicitly skipped under
>>    !ALLOC_TRYLOCK.
>
> ALLOC_NOLOCK.
>
>>=20
>> Ulterior motive: adding an alloc_flags arg to the allocator's
>> mm-internal entrypoint can later be used to do more allocation
>> customisation without needing to create new GFP flags.
>>=20
>> While adding this flag to a bunch of places, create ALLOC_DEFAULT to
>> avoid a mysterious literal 0 in most places.
>
>
>> alloc_frozen_pages_noprof()
>> is defined above the alloc flags so just leave that as a slightly messy
>> exception instead of trying to fully reorder mm/internal.h for that one
>> case.
>
> This no longer applies in v3?
>
>> No functional change intended.
>>=20
>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>> ---
>>  mm/hugetlb.c    |   3 +-
>>  mm/mempolicy.c  |  10 ++--
>>  mm/page_alloc.c | 178 +++++++++++++++++++++++++++++--------------------=
-------
>>  mm/page_alloc.h |   6 +-
>>  mm/slub.c       |   6 +-
>>  5 files changed, 108 insertions(+), 95 deletions(-)
>>=20
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index f7925624c4d2e..dfcfcfa4715bf 100644
>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index a3ba63c7f9199..8d409d075e3e9 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -5222,7 +5222,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, i=
nt preferred_nid,
>>  		}
>>  		nr_account++;
>> =20
>> -		prep_new_page(page, 0, gfp, 0);
>> +		prep_new_page(page, 0, gfp, ALLOC_DEFAULT);
>>  		set_page_refcounted(page);
>>  		page_array[nr_populated++] =3D page;
>>  	}
>> @@ -5271,24 +5271,98 @@ void free_pages_bulk(struct page **page_array, u=
nsigned long nr_pages)
>>  	}
>>  }
>> =20
>> -/*
>> - * This is the 'heart' of the zoned buddy allocator.
>> - */
>> -struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
>> -		int preferred_nid, nodemask_t *nodemask)
>> +static inline bool alloc_order_allowed(gfp_t gfp, unsigned int order,
>> +				       unsigned int alloc_flags)
>>  {
>> -	struct page *page;
>> -	unsigned int fastpath_alloc_flags =3D ALLOC_WMARK_LOW;
>> -	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
>> -	struct alloc_context ac =3D { };
>> +	if (alloc_flags & ALLOC_NOLOCK)
>> +		return pcp_allowed_order(order);
>> =20
>>  	/*
>>  	 * There are several places where we assume that the order value is sa=
ne
>>  	 * so bail out early if the request is out of bound.
>>  	 */
>> -	if (WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER, gfp))
>> +	return !(WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER, gfp));
>> +}
>> +
>> +static inline bool alloc_trylock_allowed(void)
>
> alloc_nolock_allowed()
>
>> +{
>> +	/*
>> +	 * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which is
>> +	 * unsafe in NMI. If spin_trylock() is called from hard IRQ the curren=
t
>> +	 * task may be waiting for one rt_spin_lock, but rt_spin_trylock() wil=
l
>> +	 * mark the task as the owner of another rt_spin_lock which will
>> +	 * confuse PI logic, so return immediately if called from hard IRQ or
>> +	 * NMI.
>> +	 *
>> +	 * Note, irqs_disabled() case is ok. This function can be called
>> +	 * from raw_spin_lock_irqsave region.
>> +	 */
>> +	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
>> +		return false;
>> +
>> +	/* On UP, spin_trylock() always succeeds even when it is locked */
>> +	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
>> +		return false;
>> +
>> +	/* Bailout, since _deferred_grow_zone() needs to take a lock */
>> +	if (deferred_pages_enabled())
>> +		return false;
>> +
>> +	return true;
>> +}
>> +
>> +/*
>> + * GFP flags to set for ALLOC_NOLOCK i.e. alloc_pages_nolock().
>> + *
>> + * Do not specify __GFP_DIRECT_RECLAIM, since direct claim is not allow=
ed.
>> + * Do not specify __GFP_KSWAPD_RECLAIM either, since wake up of kswapd
>> + * is not safe in arbitrary context.
>> + *
>> + * These two are the conditions for gfpflags_allow_spinning() being tru=
e.
>> + *
>> + * Specify __GFP_NOWARN since failing alloc_pages_nolock() is not a rea=
son
>> + * to warn. Also warn would trigger printk() which is unsafe from
>> + * various contexts. We cannot use printk_deferred_enter() to mitigate,
>> + * since the running context is unknown.
>> + *
>> + * Specify __GFP_ZERO to make sure that call to kmsan_alloc_page() belo=
w
>> + * is safe in any context. Also zeroing the page is mandatory for
>> + * BPF use cases.
>> + *
>> + * Though __GFP_NOMEMALLOC is not checked in the code path below,
>> + * specify it here to highlight that alloc_pages_nolock()
>> + * doesn't want to deplete reserves.
>> + */
>> +static const gfp_t gfp_nolock =3D __GFP_NOWARN | __GFP_ZERO | __GFP_NOM=
EMALLOC |
>> +				__GFP_COMP;
>> +
>> +/*
>> + * This is the 'heart' of the zoned buddy allocator.
>> + */
>> +struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
>> +		int preferred_nid, nodemask_t *nodemask, unsigned int alloc_flags)
>> +{
>> +	struct page *page;
>> +	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
>> +	struct alloc_context ac =3D { };
>> +	unsigned int fastpath_alloc_flags =3D alloc_flags;
>> +
>> +	/* Other flags could be supported later if needed. */
>> +	if (WARN_ON(alloc_flags & ~ALLOC_NOLOCK))
>>  		return NULL;
>> =20
>> +	if (!alloc_order_allowed(gfp, order, alloc_flags))
>> +		return NULL;
>> +
>> +	if (alloc_flags & ALLOC_NOLOCK) {
>> +		VM_WARN_ON_ONCE(gfp & ~__GFP_ACCOUNT);
>> +		if (!alloc_trylock_allowed())
>> +			return NULL;
>> +		gfp |=3D gfp_nolock;
>
> I think we could do a
> 		fastpath_alloc_flags |=3D ALLOC_WMARK_MIN;
>
> to make it explicit, even though it's a no-op (the value is 0) and
> alloc_frozen_pages_nolock_noprof() didn't do it.
>
>> +	} else {
>> +		fastpath_alloc_flags |=3D ALLOC_WMARK_LOW;
>> +	}
>> +
>>  	gfp &=3D gfp_allowed_mask;
>>  	/*
>>  	 * Apply scoped allocation constraints. This is mainly about GFP_NOFS
>> @@ -5310,9 +5384,9 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp=
, unsigned int order,
>>  	fastpath_alloc_flags |=3D alloc_flags_nofragment(zonelist_zone(ac.pref=
erred_zoneref), gfp);
>>  	fastpath_alloc_flags |=3D alloc_flags_nonblocking(gfp, order) & ALLOC_=
HIGHATOMIC;
>> =20
>> -	/* First allocation attempt */
>> +	/* First allocation attempt (or, for nolock, only attempt) */
>>  	page =3D get_page_from_freelist(alloc_gfp, order, fastpath_alloc_flags=
, &ac);
>> -	if (likely(page))
>> +	if (likely(page) || (alloc_flags & ALLOC_NOLOCK))
>>  		goto out;
>> =20
>>  	alloc_gfp =3D gfp;
>> @@ -5329,7 +5403,8 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp=
, unsigned int order,
>>  out:
>>  	if (memcg_kmem_online() && (gfp & __GFP_ACCOUNT) && page &&
>>  	    unlikely(__memcg_kmem_charge_page(page, gfp, order) !=3D 0)) {
>> -		free_frozen_pages(page, order);
>> +		__free_frozen_pages(page, order,
>> +				    alloc_flags & ALLOC_NOLOCK ? FPI_TRYLOCK : 0);
>>  		page =3D NULL;
>>  	}
>> =20
>> @@ -5345,7 +5420,8 @@ struct page *__alloc_pages_noprof(gfp_t gfp, unsig=
ned int order,
>>  {
>>  	struct page *page;
>> =20
>> -	page =3D __alloc_frozen_pages_noprof(gfp, order, preferred_nid, nodema=
sk);
>> +	page =3D __alloc_frozen_pages_noprof(gfp, order, preferred_nid, nodema=
sk,
>> +					   ALLOC_DEFAULT);
>>  	if (page)
>>  		set_page_refcounted(page);
>>  	return page;
>> @@ -7875,80 +7951,10 @@ static bool __free_unaccepted(struct page *page)
>> =20
>>  struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid,=
 unsigned int order)
>>  {
>> -	/*
>> -	 * Do not specify __GFP_DIRECT_RECLAIM, since direct claim is not allo=
wed.
>> -	 * Do not specify __GFP_KSWAPD_RECLAIM either, since wake up of kswapd
>> -	 * is not safe in arbitrary context.
>> -	 *
>> -	 * These two are the conditions for gfpflags_allow_spinning() being tr=
ue.
>> -	 *
>> -	 * Specify __GFP_NOWARN since failing alloc_pages_nolock() is not a re=
ason
>> -	 * to warn. Also warn would trigger printk() which is unsafe from
>> -	 * various contexts. We cannot use printk_deferred_enter() to mitigate=
,
>> -	 * since the running context is unknown.
>> -	 *
>> -	 * Specify __GFP_ZERO to make sure that call to kmsan_alloc_page() bel=
ow
>> -	 * is safe in any context. Also zeroing the page is mandatory for
>> -	 * BPF use cases.
>> -	 *
>> -	 * Though __GFP_NOMEMALLOC is not checked in the code path below,
>> -	 * specify it here to highlight that alloc_pages_nolock()
>> -	 * doesn't want to deplete reserves.
>> -	 */
>> -	gfp_t alloc_gfp =3D __GFP_NOWARN | __GFP_ZERO | __GFP_NOMEMALLOC | __G=
FP_COMP
>> -			| gfp_flags;
>> -	unsigned int alloc_flags =3D ALLOC_NOLOCK;
>> -	struct alloc_context ac =3D { };
>> -	struct page *page;
>> -
>> -	VM_WARN_ON_ONCE(gfp_flags & ~__GFP_ACCOUNT);
>> -	/*
>> -	 * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which is
>> -	 * unsafe in NMI. If spin_trylock() is called from hard IRQ the curren=
t
>> -	 * task may be waiting for one rt_spin_lock, but rt_spin_trylock() wil=
l
>> -	 * mark the task as the owner of another rt_spin_lock which will
>> -	 * confuse PI logic, so return immediately if called from hard IRQ or
>> -	 * NMI.
>> -	 *
>> -	 * Note, irqs_disabled() case is ok. This function can be called
>> -	 * from raw_spin_lock_irqsave region.
>> -	 */
>> -	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
>> -		return NULL;
>> -
>> -	/* On UP, spin_trylock() always succeeds even when it is locked */
>> -	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
>> -		return NULL;
>> -
>> -	if (!pcp_allowed_order(order))
>> -		return NULL;
>> -
>> -	/* Bailout, since _deferred_grow_zone() needs to take a lock */
>> -	if (deferred_pages_enabled())
>> -		return NULL;
>> -
>>  	if (nid =3D=3D NUMA_NO_NODE)
>>  		nid =3D numa_node_id();
>> =20
>> -	prepare_alloc_pages(alloc_gfp, order, nid, NULL, &ac,
>> -			    &alloc_gfp, &alloc_flags);
>> -
>> -	/*
>> -	 * Best effort allocation from percpu free list.
>> -	 * If it's empty attempt to spin_trylock zone->lock.
>> -	 */
>> -	page =3D get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac);
>> -
>> -	/* Unlike regular alloc_pages() there is no __alloc_pages_slowpath(). =
*/
>> -
>> -	if (memcg_kmem_online() && page && (gfp_flags & __GFP_ACCOUNT) &&
>> -	    unlikely(__memcg_kmem_charge_page(page, alloc_gfp, order) !=3D 0))=
 {
>> -		__free_frozen_pages(page, order, FPI_TRYLOCK);
>> -		page =3D NULL;
>> -	}
>> -	trace_mm_page_alloc(page, order, alloc_gfp, ac.migratetype);
>> -	kmsan_alloc_page(page, order, alloc_gfp);
>> -	return page;
>> +	return __alloc_frozen_pages_noprof(gfp_flags, order, nid, NULL, ALLOC_=
NOLOCK);
>>  }
>>  /**
>>   * alloc_pages_nolock - opportunistic reentrant allocation from any con=
text
>> diff --git a/mm/page_alloc.h b/mm/page_alloc.h
>> index 3250d44f96457..e16f905f859a7 100644
>> --- a/mm/page_alloc.h
>> +++ b/mm/page_alloc.h
>> @@ -11,6 +11,7 @@
>>  #include <linux/nodemask.h>
>>  #include <linux/types.h>
>> =20
>> +#define ALLOC_DEFAULT		0
>>  /* The ALLOC_WMARK bits are used as an index to zone->watermark */
>>  #define ALLOC_WMARK_MIN		WMARK_MIN
>>  #define ALLOC_WMARK_LOW		WMARK_LOW
>> @@ -219,7 +220,7 @@ extern bool free_pages_prepare(struct page *page, un=
signed int order);
>>  extern int user_min_free_kbytes;
>> =20
>>  struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,=
 int nid,
>> -		nodemask_t *nodemask);
>> +		nodemask_t *nodemask, unsigned int alloc_flags);
>>  #define __alloc_frozen_pages(...) \
>>  	alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
>>  void free_frozen_pages(struct page *page, unsigned int order);
>> @@ -230,7 +231,8 @@ struct page *alloc_frozen_pages_noprof(gfp_t, unsign=
ed int order);
>>  #else
>>  static inline struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigne=
d int order)
>>  {
>> -	return __alloc_frozen_pages_noprof(gfp, order, numa_node_id(), NULL);
>> +	return __alloc_frozen_pages_noprof(gfp, order, numa_node_id(), NULL,
>> +					   0 /* ALLOC_DEFAULT */);
>
> Can use ALLOC_DEFAULT now.

Thanks and ack to all of these.

Will mention the ALLOC_WMARK_MIN thing in the commit message too.

