Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CBAB606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 13:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eOInTTz3
Received: by kanga.kvack.org (Postfix)
	id 80E916B05B6; Fri,  6 Nov 2026 08:11:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E5AB6B05B7; Fri,  6 Nov 2026 08:11:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FB8C6B05B8; Fri,  6 Nov 2026 08:11:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 43F706B05B6
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:11:30 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BB8E9C0D5A
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:11:29 +0000 (UTC)
X-FDA: 85404730698.27.DC35DD1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 301FC180008
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:11:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eOInTTz3;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793970688;
	b=Al1Tilvh0w7vB7dSC/lqMlMGhpQg6jm4JqivCRMos62k3PxNtC8Bkul7O1AwBanWfoeEoI
	K1F/Zc4lDaOrewfXS5cbSUn9J1YNA2cxuB6hLf+Wng/oTsn5muUDnoHyKjtLqWTdPW0dOY
	z5RvrWcRXmL9a3tK3mOAfJHKFjlty8s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eOInTTz3;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793970688;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uj1zOkcoJlQmGVIJ4wv6hSDJ3ygl8SX6bqs5LM6sloc=;
	b=Sz/YxiuQyupkq+ypUDVUcTnkY5SKwRsD9JI7rA9tFJNFo5CK9zTzHRThpnA1xuOHRsTvJx
	i60KNdHbDaEta9t4bBUx8u87qmsy+IiDbbBrX7Z6WqZ7HuEcpGGu6kYtQ/798ENEL6PSq/
	tahVI0+Qqvb3qqWmPJoFCiRcZww4EZA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C10C6602D4;
	Fri,  6 Nov 2026 13:11:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D7D1F0089F;
	Fri,  6 Nov 2026 13:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793970687;
	bh=uj1zOkcoJlQmGVIJ4wv6hSDJ3ygl8SX6bqs5LM6sloc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eOInTTz3XZQe0cICbxewcjhb55DlllAzL+HVSsXWq+ArHfEU6aB8Krdjqupoz7CED
	 pM04G7iwnJ5Yl3PhK6gbUZ0+H+zlSojbrpByJKYg0PekkNLPHBKxyL2h418Q/J2/1K
	 5rJ9kMaZIj1UI1yu2lGihc6tWcwTIXzBYb8xy1d3OAV9nJ3FPi7N3lb/I8a6qEFTvo
	 Nefy1Jlh8Q/hR9T7ehYLmw/iTkJJWr6AJkBCNm8hSF1L2zHgzUobqV0gRHOYqUsG9p
	 QXQtXlr3CaHOcSxEeA4M+D2IBs0NerufjmfCPc7UFL7LAKV5OGstgOO+ME8RfHM/5X
	 mqLN2pqRphvNA==
Message-ID: <sashiko-outbox-201446@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/5] mm/gup: limit pagecache folio refcount when
 grabbing references
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?RGF2aWQgSGlsZGVuYnJhbmQgKEFybSk=?= <david@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>, "Jan
 Kara" <jack@suse.cz>, "Zi Yan" <ziy@nvidia.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Nico
 Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Matthew
 Brost" <matthew.brost@intel.com>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Byungchul
 Park" <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Peter Xu" <peterx@redhat.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Song Liu" <songliubraving@fb.com>, "Rik van
 Riel" <riel@surriel.com>, "Hugh Dickins" <hughd@google.com>, "Will Deacon" <will@kernel.org>, "Aneesh
 Kumar K.V" <aneesh.kumar@kernel.org>, "Nick Piggin" <npiggin@gmail.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Jason Gunthorpe" <jgg@ziepe.ca>, "Kevin
 Tian" <kevin.tian@intel.com>, =?utf-8?b?Sm9lcmcgUm9lZGVsIChBTUQp?= <joro@8bytes.org>, "Robin
 Murphy" <robin.murphy@arm.com>, "Steve Sistare" <steven.sistare@oracle.com>, "John
 Hubbard" <jhubbard@nvidia.com>
Cc: linux-mm@kvack.org
In-Reply-To: <20261105-refcount_overflow_stable-v1-5-70b9c655da3e@kernel.org>
References: <20261105-refcount_overflow_stable-v1-0-70b9c655da3e@kernel.org>
 <20261105-refcount_overflow_stable-v1-5-70b9c655da3e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 13:11:25 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 301FC180008
X-Stat-Signature: 8z8r91nehws7kxgu89iu3no6tnzzuofs
X-Rspam-User: 
X-HE-Tag: 1793970688-772564
X-HE-Meta: U2FsdGVkX18xhgtMh8+yLLEcKqn4sVdbKj9dJtmbLxRGZ7xvICkk4H8+QTgy7XoO2GeXYjmx96U5MRdx+FwYe/txBkUjVP8Tw+bZJAtcTXIYo5mMCM3TA790gglx+O0YWPID+A1V0NRSSdC5ZMdfCEN+i/gG0m6sNAQZZCvs1wXdTsKATDwIHRbnxJ0l6uzt31oLP2RQOLHqy146niufZEsfDMJNtJDlDp8uBPXPZqsdBE0/nG1hX0lGCbOHd8AOaIVAVVZyI0T8gRRZHKE4fmMlFwjeQ7WwSJVkGwmat3yKDSMwEEatmB3rA4L8PeyNWIAWEUuTbNftOLf2bphCxSbK2XamJA92LCYWXo4rIudlUIh7c64EG5UAOjsW0PnBnOZuxASZChTQla7goxh8ALT8KZPKzpkbMbJ/7mW+/oKjfp/bhMK0bon1UxfASjgPso8TiPb0diUjkYZa9beWdig2KqMcGh96krNm52rqO93BCX4gLZDf8Adrwc8x5Ifwi4IIhviDZkalAl+I9aM4nhGs18XM4Vs2kCG6CtxHWLKBLjoGMsIqVcChCayi1UKS9Efq5zHyWLW+THRpdKzvqNezT0Wqw0TVMvpgxnAhZRimDXRAUgU5H+/SxaLjhKPQOvxQZEB1QbejebyP36tbHPlxxxy/poCRY7IKQQNF6nnM6ta8IcnkvsqcVpM6o9uEdqjRJWS90tb028raoP6/y3fR19hria+RZmqTX/jfKdlIFT/Gv8WUIV8+iqE1exmSy1xZPPBmT5bCujbEOXa3ivyY+T1tIOY76Sb6fme6CmKkArDzaj3G7yQlQkubX1nwp632SY/6eTzug/RfD9QzFnPxpoq6r/QajytPKKf0BStI9ubjPHp/3CbBB+BRFxHSSuCozjFgfFNiqpQJ2r873svGC2Me4+HDH5SPlE2pZ2rHT+0T2fnDZw9Txbj4H92xjz7aiHUbqWdgnjG7oFc
 WYLLg4KJ
 ax/1ATZy7pik6UO7969DfQTNZLjg5ia+LmWEGhDFS/3DoJ3EQcj0Z1EWJeSEy8eglBwJRMNsLlj3P+Sjmf7y46hx+rSU1LJwogGvxP2UIRI0jWenQtU/L9Zj0Sc61bjSiKNBgZcpmsNhOhCwggQOEpKkmVM4AAV/flr90ZB7V+wCOeITQam15xsVtYXloeGKRZrGiXXE9UfiEnluIAFRbdjCHqZySFxGzMDqfpRclold53I2UkCxmtKHvxcfo6BVXHiLqdrvTz9uedpPFnKbqE7d2Aj5Hdf32/rmZrMIJ8/T8yb+HX4JCKcxdZVc2O+ot5M8kYOLluxnj+deJ/VZ3GIx7eCEd3ZD4jubsLTBavYQwMp7RC/WqdG7FUJD1Rrfx+tjAJf+njfHt8cfalpUeSglRSoC2xoNcMl8GDdZaO/F26bW6JW41OGAAKndCsvQIYvzv3JTgpsH3/DsF1dSHSJqiY4sDecpzv1F8GkCk6N7LkM2p2vpAC/A+ePZH6o1nXoWZliobUNjqaCAPYHBizVg3s25/MzQz+fdyyvTUbHWaXzOyJGvKtG3dm1kjn9N3FTHP+Rsw9/gLw86802dZadwX0C6T/BJ3BPkhdibY494BUs05pkvBHmSp1XSeeRmgFl/5iMOdciGnP2gHYdKxOTjAdTToYbjsdmu8TuhPaDB+9X546x0ghCKqt3vCxlSoiMjT68Shpz+hMYU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] mm/gup: try_get_folio() calls capable() with IRQs disabled in
  GUP-fast
--

commit 9290efad216cdf3b5ee1cdfafab0a5d9928a1976
Author: David Hildenbrand (Arm) <david@kernel.org>

mm/gup: limit pagecache folio refcount when grabbing references

This commit replaces the negative refcount safety checks in try_get_folio()
and try_grab_folio() with folio_ref_count_over_limit() to enforce folio
refcount limits in fast and slow GUP before acquiring references or pins.

> diff --git a/mm/gup.c b/mm/gup.c
> index 2ab42fc6834e5..db9db6b2a4662 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -77,7 +77,7 @@ static inline struct folio *try_get_folio(struct page *=
page, int refs)
> =20
>  retry:
>  	folio =3D page_folio(page);
> -	if (WARN_ON_ONCE(folio_ref_count(folio) < 0))
> +	if (unlikely(folio_ref_count_over_limit(folio)))
>  		return NULL;

[Severity: High]
Is it safe for try_get_folio() to call folio_ref_count_over_limit() in the
fast GUP path?

In mm/gup.c, gup_fast() disables hardware interrupts across the page table
walk:

mm/gup.c:gup_fast() {
	...
	local_irq_save(flags);
	nr_pinned =3D gup_fast_pgd_range(start, end, gup_flags, pages);
	local_irq_restore(flags);
	...
}

which calls into try_grab_folio_fast() -> try_get_folio() with IRQs
disabled:

mm/gup.c:try_grab_folio_fast() {
	...
	/* Raise warn if it is not called in fast GUP */
	VM_WARN_ON_ONCE(!irqs_disabled());
	...
}

Furthermore, get_user_page_fast_only() -> gup_fast() -> try_get_folio() is
invoked from hardirq and NMI contexts, such as perf_prepare_sample() ->
perf_virt_to_phys() in kernel/events/core.c.

When folio_ref_count(folio) is between FOLIO_REF_COUNT_LIMIT and
FOLIO_REF_COUNT_ADMIN_LIMIT and current is not a kernel thread,
folio_ref_count_over_limit() in include/linux/mm.h calls
capable(CAP_SYS_RESOURCE):

include/linux/mm.h:folio_ref_count_over_limit() {
	const unsigned int ref_count =3D folio_ref_count(folio);

	if (likely(ref_count < FOLIO_REF_COUNT_LIMIT))
		return false;
	if (ref_count >=3D FOLIO_REF_COUNT_ADMIN_LIMIT)
		return true;
	/* Background threads must not consume admin reserves. */
	return (current->flags & PF_KTHREAD) || !capable(CAP_SYS_RESOURCE);
}

Calling capable(CAP_SYS_RESOURCE) -> ns_capable_common() ->
security_capable() in these contexts appears to cause several issues:

1. LSM capability hooks (such as selinux_capable() and apparmor_capable())
   perform audit logging via common_lsm_audit(), which allocates memory and
   acquires spinlock_t, rwlock_t, and SLUB local_lock_t locks. On
   CONFIG_PREEMPT_RT, these are sleeping rt_mutex locks, so acquiring them
   with hardware interrupts disabled in gup_fast() will sleep in an invalid
   atomic context.

2. When get_user_page_fast_only() is called from hardirq or NMI context,
   acquiring non-IRQ/NMI-safe locks in the LSM, audit, or SLUB paths can
   self-deadlock if the interrupted context on the same CPU already holds
   one of those locks.

3. In security/apparmor/capability.c, audit_caps() accesses the per-CPU
   audit_cache using get_cpu_var(), which only disables preemption:

   security/apparmor/capability.c:audit_caps() {
	...
	ent =3D &get_cpu_var(audit_cache);
	if (ad->subj_cred =3D=3D ent->ad_subj_cred &&
	    ktime_get_ns() <=3D ent->ktime_ns_expiration[cap]) {
		...
	} else {
		put_cred(ent->ad_subj_cred);
		ent->ad_subj_cred =3D get_cred(ad->subj_cred);
		ent->ktime_ns_expiration[cap] =3D ...;
	}
	put_cpu_var(audit_cache);
	...
   }

   If an IRQ or NMI invokes get_user_page_fast_only() while the interrupted
   context is inside audit_caps() on the same CPU, both contexts can race on
   ent->ad_subj_cred and cause a double put_cred().

4. In kernel/capability.c, ns_capable_common() updates current->flags
   non-atomically:

   kernel/capability.c:ns_capable_common() {
	...
	capable =3D security_capable(current_cred(), ns, cap, opts);
	if (capable =3D=3D 0) {
		current->flags |=3D PF_SUPERPRIV;
		return true;
	}
	...
   }

   When called from hardirq or NMI context, this mutates the interrupted
   task's flags and can race with process-context updates to current->flags.

Should try_get_folio() avoid calling capable() in fast GUP (for example, by
falling back to slow GUP once the folio refcount reaches
FOLIO_REF_COUNT_LIMIT)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-refcount_o=
verflow_stable-v1-0-70b9c655da3e@kernel.org?part=3D5

