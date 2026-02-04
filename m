Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33255E9537B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 11:47:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94C396B009F; Wed,  4 Feb 2026 06:47:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 923426B00A0; Wed,  4 Feb 2026 06:47:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82F7C6B00A1; Wed,  4 Feb 2026 06:47:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6FF616B009F
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:47:42 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DD2F816014A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:47:41 +0000 (UTC)
X-FDA: 84406599522.09.2196B0F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf08.hostedemail.com (Postfix) with ESMTP id 48EE316000C
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:47:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TbityOC+;
	spf=pass (imf08.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770205660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Y9C9TV7p2mQPXE8Erh0AFNnKJ3BkHV6w3UKpKNJ+Ek=;
	b=5F02UzcfEvVRkshsx1MdFmqiIG9+YZulD7CA5xubp6F4TyzR65j2XuiSUGGW+aHn0PioE5
	8RfHKdzP0jXxRWonAG4z97ayhqO+WRLzJuQyFjSWKGtaE5r+as6ew4XFwdvXYo9AOcSLBh
	SYPosRp8W4MIKw1iK5Jc8iiLwCCE1f0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TbityOC+;
	spf=pass (imf08.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770205660; a=rsa-sha256;
	cv=none;
	b=GHXT6+bfkcxZwbW1l14HTK17uZDL+IA6EfEdS21d0mBXgjgO9PKuxKCCf0FcnUVOWSxivP
	+mOHw5u6flYbW3uagdXI1NAAqPdRfX9CULqERW/EMiJYl27/hpMcZ76HYkRGnBo5VSFINm
	lb56fqqOh5ybrGRzlYleM+PwzCfWtvw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770205659; x=1801741659;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=o1SGsfKC7zfKdDVi2+WmhVppxLa0zTkZJFytPRw037o=;
  b=TbityOC+Gkyr7IEHv1YU+mi/U5WpW/+1Y/3Z15GSFFaKox3HCdOJcvx1
   I3E8gi622YvWZ8vr/SUCxDOUx7No7PdIimwXomDbiMejXIiABilROP12m
   OJad3wNs8wJ8da+B04a5P8njM74CukKliOLn9vmX7Daq+Tp+MLB4B/fbW
   YM3Sf9nf1oaUOthgH8YiNyEcARQfyc0zjWykRKNlfbX0zMkHLvSQexBD2
   D+gtunES+RA8jEEheVh0wv3dymIyRIC/u48HLQ5TB9BJZW7SHjMg6tpPb
   NSyOIbcJ/UfBTTnQsz0mIUM1GaS74PWeORjaJyne6ji43YjlHpCXev3pt
   g==;
X-CSE-ConnectionGUID: +cKJYLnKSAy6zTW7JNLQeQ==
X-CSE-MsgGUID: XEsN0NFKSc6C1zdWrdcEZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="71286161"
X-IronPort-AV: E=Sophos;i="6.21,272,1763452800"; 
   d="scan'208";a="71286161"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2026 03:47:38 -0800
X-CSE-ConnectionGUID: qwxQ1Z8ASFOay7+tkmDJpg==
X-CSE-MsgGUID: MKlMS3YCSnq+MQ2H2Rrz8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,272,1763452800"; 
   d="scan'208";a="214322885"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO [10.245.245.210]) ([10.245.245.210])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2026 03:47:34 -0800
Message-ID: <7d81f9344210986c112d4586608193765e4ca862.camel@linux.intel.com>
Subject: Re: [PATCH v3] mm: Fix a hmm_range_fault() livelock / starvation
 problem
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Alistair Popple <apopple@nvidia.com>
Cc: intel-xe@lists.freedesktop.org, Ralph Campbell <rcampbell@nvidia.com>, 
 Christoph Hellwig	 <hch@lst.de>, Jason Gunthorpe <jgg@mellanox.com>, Jason
 Gunthorpe <jgg@ziepe.ca>,  Leon Romanovsky	 <leon@kernel.org>, Andrew
 Morton <akpm@linux-foundation.org>, Matthew Brost	
 <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
	linux-mm@kvack.org, dri-devel@lists.freedesktop.org, stable@vger.kernel.org
Date: Wed, 04 Feb 2026 12:47:32 +0100
In-Reply-To: <2mts4ijet6ezaqmqgzfljiptv6dgqduzhn6sfxvmec257j4beg@tuj322lx3j5y>
References: <20260203143434.16349-1-thomas.hellstrom@linux.intel.com>
	 <2mts4ijet6ezaqmqgzfljiptv6dgqduzhn6sfxvmec257j4beg@tuj322lx3j5y>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 48EE316000C
X-Rspamd-Server: rspam07
X-Stat-Signature: jhq1mzh7e83h1htdzgui3pshxb4bbhxo
X-HE-Tag: 1770205659-492616
X-HE-Meta: U2FsdGVkX1/B9clx+lBo1FWteRp4R55O70gxXLSf/zBphxstuJ9+3vF+TOqUDYK9pLWvGNyAC7jRnO4ZR4KY7SWPjNVVfTxV5ixWDv2bMJrkHysMxOjIuYUBPbxGw7qFpkBPAy1ju8ZzL3wSEgf2SUUjbcqhx2bfp6/cFmNmBGIG2TUdaORqZcMNDld/0VtQnNMTagR7G9kCpWweltLCbLs4BxAeGYs8/uXShPK9E5qw2Aa/8Sa5obDdwwqMOt2Q7n1xBVuQdwmDZVlYvZGtkGphuWZHADmSs0aU51I1gsXFxMPbkziOjQxYbyqrZLxbC9iLznb8dW7lu4eLzUQTlMTHf+yP7cJdjOaL4QBxOnOGXXvMw2PasQfm411cru4NfiRHCgMbvN065MyyA0iUHX7Ydc0IpFOweV2MybAAzFs89wr4uVvBU+xN+SR0eJik7ctWI7xx+Bvtxv3Z7UwjUl23A4R1taoNMJ3Vg9xcP8/K8OxHmF3PI+21QAPZUvjfC/y8qRAxqgxvaUIQ9+kT0Idjcm6Ayh3CABpgT1jSkIdsY3hkXPFKXik7mtL+i26EMp9ZedNqT+BH5ATrlhfKJ3f5+fGSEMMEBEpeP474dj4m2zv9zS7sUwbI9lrm18cT1PnCM4Agopm1iPunDARTZLwE/I0+DnSpXTRp80AjyZWUNO+v2ryC35ILCX37P0IuBh1s1Yl4Wpt+tpckreDunT0px1Bm2VAFNbOkx2YFVN6l50TwzdRbXY/fwBMQsrnMvgZbVO73GlN8oJb7a8BKV1qeqiKiK2cEaw7wx/FcbT/R3W52+I6ur3cfS001NWVtEEaSgAEVRdT72t5EAAajoI3ry+qdFyaa7HZ4CJ2c0UDjz4Ru9kwwyJxJWQfW6ckj5sHqUBXu1SrZVnugM0qfigkLbOC16c0ixbcqq/FfMh0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-02-04 at 21:59 +1100, Alistair Popple wrote:
> On 2026-02-04 at 01:34 +1100, Thomas Hellstr=C3=B6m
> <thomas.hellstrom@linux.intel.com> wrote...
> > If hmm_range_fault() fails a folio_trylock() in do_swap_page,
> > trying to acquire the lock of a device-private folio for migration,
> > to ram, the function will spin until it succeeds grabbing the lock.
> >=20
> > However, if the process holding the lock is depending on a work
> > item to be completed, which is scheduled on the same CPU as the
> > spinning hmm_range_fault(), that work item might be starved and
> > we end up in a livelock / starvation situation which is never
> > resolved.
> >=20
> > This can happen, for example if the process holding the
> > device-private folio lock is stuck in
> > =C2=A0=C2=A0 migrate_device_unmap()->lru_add_drain_all()
> > The lru_add_drain_all() function requires a short work-item
> > to be run on all online cpus to complete.
> >=20
> > A prerequisite for this to happen is:
> > a) Both zone device and system memory folios are considered in
> > =C2=A0=C2=A0 migrate_device_unmap(), so that there is a reason to call
> > =C2=A0=C2=A0 lru_add_drain_all() for a system memory folio while a
> > =C2=A0=C2=A0 folio lock is held on a zone device folio.
> > b) The zone device folio has an initial mapcount > 1 which causes
> > =C2=A0=C2=A0 at least one migration PTE entry insertion to be deferred =
to
> > =C2=A0=C2=A0 try_to_migrate(), which can happen after the call to
> > =C2=A0=C2=A0 lru_add_drain_all().
> > c) No or voluntary only preemption.
> >=20
> > This all seems pretty unlikely to happen, but indeed is hit by
> > the "xe_exec_system_allocator" igt test.
> >=20
> > Resolve this by waiting for the folio to be unlocked if the
> > folio_trylock() fails in the do_swap_page() function.
> >=20
> > Future code improvements might consider moving
> > the lru_add_drain_all() call in migrate_device_unmap() to be
> > called *after* all pages have migration entries inserted.
> > That would eliminate also b) above.
> >=20
> > v2:
> > - Instead of a cond_resched() in the hmm_range_fault() function,
> > =C2=A0 eliminate the problem by waiting for the folio to be unlocked
> > =C2=A0 in do_swap_page() (Alistair Popple, Andrew Morton)
> > v3:
> > - Add a stub migration_entry_wait_on_locked() for the
> > =C2=A0 !CONFIG_MIGRATION case. (Kernel Test Robot)
> >=20
> > Suggested-by: Alistair Popple <apopple@nvidia.com>
> > Fixes: 1afaeb8293c9 ("mm/migrate: Trylock device page in
> > do_swap_page")
> > Cc: Ralph Campbell <rcampbell@nvidia.com>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Jason Gunthorpe <jgg@mellanox.com>
> > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > Cc: Leon Romanovsky <leon@kernel.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Matthew Brost <matthew.brost@intel.com>
> > Cc: John Hubbard <jhubbard@nvidia.com>
> > Cc: Alistair Popple <apopple@nvidia.com>
> > Cc: linux-mm@kvack.org
> > Cc: <dri-devel@lists.freedesktop.org>
> > Signed-off-by: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>
> > Cc: <stable@vger.kernel.org> # v6.15+
> > ---
> > =C2=A0include/linux/migrate.h | 6 ++++++
> > =C2=A0mm/memory.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 | 3 ++-
> > =C2=A02 files changed, 8 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> > index 26ca00c325d9..800ec174b601 100644
> > --- a/include/linux/migrate.h
> > +++ b/include/linux/migrate.h
> > @@ -97,6 +97,12 @@ static inline int set_movable_ops(const struct
> > movable_operations *ops, enum pag
> > =C2=A0	return -ENOSYS;
> > =C2=A0}
> > =C2=A0
> > +static inline void migration_entry_wait_on_locked(softleaf_t
> > entry, spinlock_t *ptl)
> > +	__releases(ptl)
> > +{
> > +	spin_unlock(ptl);
> > +}
> > +
> > =C2=A0#endif /* CONFIG_MIGRATION */
> > =C2=A0
> > =C2=A0#ifdef CONFIG_NUMA_BALANCING
> > diff --git a/mm/memory.c b/mm/memory.c
> > index da360a6eb8a4..ed20da5570d5 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4684,7 +4684,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> > =C2=A0				unlock_page(vmf->page);
> > =C2=A0				put_page(vmf->page);
> > =C2=A0			} else {
> > -				pte_unmap_unlock(vmf->pte, vmf-
> > >ptl);
> > +				pte_unmap(vmf->pte);
> > +				migration_entry_wait_on_locked(ent
> > ry, vmf->ptl);
>=20
> Code wise this looks fine to me, although it's confusing to see
> migration_entry_wait_on_locked() being called on a non-migration
> entry and
> ideally this would be renamed to something like
> softleaf_entry_wait_on_locked().
>=20
> Regardless though the documentation for
> migration_entry_wait_on_locked() needs
> updating to justify why calling this on device-private entries is
> valid (because
> it's also just waiting for the page to be unlocked). Along with some
> equivalent
> justification for how we know there is a reference on the device-
> private page:
>=20
> 	 * If a migration entry exists for the page the migration
> path must hold
> 	 * a valid reference to the page, and it must take the ptl
> to remove the
> 	 * migration entry. So the page is valid until the ptl is
> dropped.
> =C2=A0
> Which is basically just the page is mapped in the page table,
> therefore it must
> have a reference taken for the mapping and the mapping can't be
> removed while we
> hold the PTL.
>=20
> Thanks.
>=20
> =C2=A0- Alistair

Thanks for reviewing. Let me respin this for a v4 addressing the above.

/Thomas



>=20
> > =C2=A0			}
> > =C2=A0		} else if (softleaf_is_hwpoison(entry)) {
> > =C2=A0			ret =3D VM_FAULT_HWPOISON;
> > --=20
> > 2.52.0
> >=20

