Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05C6CD7976A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 12:57:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 694026B0005; Sat, 31 Jan 2026 07:57:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65B036B009E; Sat, 31 Jan 2026 07:57:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5539D6B00A0; Sat, 31 Jan 2026 07:57:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 423076B0005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 07:57:30 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CD97313BB23
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 12:57:29 +0000 (UTC)
X-FDA: 84392260218.23.B6E921F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf15.hostedemail.com (Postfix) with ESMTP id 52586A0003
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 12:57:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=i3Tkblob;
	spf=pass (imf15.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769864247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EM+NzC64CODdJXzYiv6EZvn6dj++5e2zZ12TK+NfJXA=;
	b=P5p1REaW7w+rp8Qm3brJZItl1I9j2QP+lXDu6oFZD5+KIQnEAXszZfT27GryJizBTRCQPI
	anWSxkXWi842wQ5aRrXfbB19Z6lYcmfutQKPI3pfQXd7UIMUR/P7Ik7PPjABMIJ7PJbBCu
	5MvquP1o4J+ktHDRRe1X1C+Wzy6brAs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=i3Tkblob;
	spf=pass (imf15.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769864247; a=rsa-sha256;
	cv=none;
	b=mJS+4AOY0bx/uY8tpiUgRvjgrkQQq2Svy6VU7RacP7g8HaSQMIPdqyEYI9X7x+Dv8TCXkG
	ReNem8yZzO09jKY1Z7fEoLSaw9G9p/jC2zWRNsiRyshyLsuaBqebv7/jW1FP1IM60RFP8I
	7xIMl3tveFFWvfxNzrtESyBkG0grZx0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769864247; x=1801400247;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=sxsW5wz+50vShImzs/QoY5VYxc3tyuMg2yHW1M/0i+g=;
  b=i3TkblobYofwIWkevMWu7EJvGitiocu3LXIDBXO/Rl45UPtQUxgQ/VMk
   5rCUfeuAcO1Mh+KItXm3Y4pL5IuOS62L9Dj2txod3h01Zfs3YVTO1Nshk
   bzNGcvvfqZlJYsWYJ4birHlmiAplococ3bIe+aMD4NjsHz4cEg54+3OHK
   KjspUA/drH//60QEOSzUU2frgRtg2jzOKBGfnarNeLBhqBLKGi7IRaaoy
   cS2fv8uWEH/GSExg0V1aDTepMXwwZGb3YbFtYlHpaqmmVKH/qYYMUR3K7
   CA+MHKPsCTmEJuhA6CXKcWKYMOikH93ZwaMeTqlIWhtDTn/tHEQfe4Fqd
   w==;
X-CSE-ConnectionGUID: FSoW7RY3QcybaQptScvpVg==
X-CSE-MsgGUID: pmex3dAWSQWMdNnJx+f/Lw==
X-IronPort-AV: E=McAfee;i="6800,10657,11687"; a="74957101"
X-IronPort-AV: E=Sophos;i="6.21,265,1763452800"; 
   d="scan'208";a="74957101"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2026 04:57:26 -0800
X-CSE-ConnectionGUID: FydMJpeWQu2IH0N24iDwfg==
X-CSE-MsgGUID: fZSFSQayTragXDLZituEzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,265,1763452800"; 
   d="scan'208";a="239787386"
Received: from egrumbac-mobl6.ger.corp.intel.com (HELO [10.245.244.104]) ([10.245.244.104])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2026 04:57:23 -0800
Message-ID: <2d96c9318f2a5fc594dc6b4772b6ce7017a45ad9.camel@linux.intel.com>
Subject: Re: [PATCH] mm/hmm: Fix a hmm_range_fault() livelock / starvation
 problem
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: John Hubbard <jhubbard@nvidia.com>, Andrew Morton
	 <akpm@linux-foundation.org>
Cc: intel-xe@lists.freedesktop.org, Ralph Campbell <rcampbell@nvidia.com>, 
 Christoph Hellwig	 <hch@lst.de>, Jason Gunthorpe <jgg@mellanox.com>, Jason
 Gunthorpe <jgg@ziepe.ca>,  Leon Romanovsky	 <leon@kernel.org>, Matthew
 Brost <matthew.brost@intel.com>, linux-mm@kvack.org, 
	stable@vger.kernel.org, dri-devel@lists.freedesktop.org
Date: Sat, 31 Jan 2026 13:57:21 +0100
In-Reply-To: <57fd7f99-fa21-41eb-b484-56778ded457a@nvidia.com>
References: <20260130144529.79909-1-thomas.hellstrom@linux.intel.com>
	 <20260130100013.fb1ce1cd5bd7a440087c7b37@linux-foundation.org>
	 <57fd7f99-fa21-41eb-b484-56778ded457a@nvidia.com>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
MIME-Version: 1.0
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 52586A0003
X-Stat-Signature: 8wa89haec17mwejy7ujrq6qosu4czuyk
X-Rspam-User: 
X-HE-Tag: 1769864247-811085
X-HE-Meta: U2FsdGVkX186dTgy6q3Z2OHQeLNFubKZTwWJ3Fhx7cf4O8BF/kqnK0SetMAA8tZLhe6PL/gOnZyTq/qOYrK1SUFaCnePcJ/jw/XAplz5p+BZm+Srbir2neqNCQjAO54fR5Jt0ygl+vcm5Z4iyuQLnaMOXgFmDO1dHek68amdKwuDVZFqPt8wiZQn0csjn5LTdllKILB+TtXine6INcVzY/hWdDE80dxj51FS+Glu/lD7TtbjYj2iNZIdZ4ZU1urybbTSbCEejU7C9EZoy7pEPs7+zl+fglrZbS77QCbw+J3XMEbBD4pF2cLlWKx2+zGd3JR1mDNSubc72iXIDVEvf4KRtQ+UBvfEepTrjtzp5bh2m6Kmr3KVuTqhFIgzNJsr/od0Qk5EjnK2Txjbq/TLw5sVX98POt8bdFxKWwx7WSHU7JzuZIB0z0y9RPOV8SYwNTZ4Z4KoW5TBoHFaofzVBzIuFoLoIohRQB90SgcDFh9Ev3I9ZgGGFSNdnpvZDcoNJtTnv5tRwlL1A3cq3EZExrkpTg3RRVD/oSIKx0FHDS1W0W2HGFiJ3vsu2wolBxk4GCPOIJxj7lTXA8zXqKticfN0DuEvHNFlVEW9At49bn2mnSmaqJ0FjN4I9wsFWXLyQb4TuJkeEJ92e+yanGDitOKfQYxqSN+E4nMSl3tgtrv909/PykRLhcpKwM3uufroD5hV+E91ujOyVYozL6Uf/mC6+RPEpCYTlemniNoefZRTEvYOgoSKbUJ/E6ZoWgfTd7SX7sMD84ISRouXmvpva7WyjihQtVOoIllkaNWn+G9Ctm/X6OtrP2kyQckHZeH6IqtZK+kk843SEG+p22PaWiXW/GkhJp2Y828JyFrvpAbvR30oM8aMKZ0qAi1CUfMVx+0pov7CNl1sm+2SYlhxjH8lDxlzdnDLKtMxhKPvoSsX0jFqLv0lniYCtUsnQ7CBH2Ozz9SS7W3OcCwE9p0
 NSpEBH5w
 uUGybg8KV8xvlQTdLGeFNWgzg/GmUs3PbgozXm0sCoCW4xsVYjKvdeugAkfYBFAEMHbS4ZFb/GukVqBmYSkI/Euh5JH6Ucy0EH4KmUWMm9U23xWP/kZHMT1TnROOBXQnp5XpeTqv4vkdieQfNf4FQC/0UOSL8bF76RBDgJvdBEYOBTuTRBj6QfGeoQupN4hfeywVmtM31wBs5va3BpQGCiQnCNPvo9aSQ7cbohdPGdTrIR/fe+SfWWE3i36atOePip/04qfB5GOs2/dc+7/7sKXRuzw/cYkTUxpuC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2026-01-30 at 19:01 -0800, John Hubbard wrote:
> On 1/30/26 10:00 AM, Andrew Morton wrote:
> > On Fri, 30 Jan 2026 15:45:29 +0100 Thomas Hellstr=C3=B6m
> > <thomas.hellstrom@linux.intel.com> wrote:
> ...
> > > This can happen, for example if the process holding the
> > > device-private folio lock is stuck in
> > > =C2=A0=C2=A0 migrate_device_unmap()->lru_add_drain_all()
> > > The lru_add_drain_all() function requires a short work-item
> > > to be run on all online cpus to complete.
> >=20
> > This is pretty bad behavior from lru_add_drain_all().
>=20
> Yes. And also, by code inspection, it seems like other folio_batch
> items (I was going to say pagevecs, heh) can leak in after calling
> lru_add_drain_all(), making things even worse.
>=20
> Maybe we really should be calling lru_cache_disable/enable()
> pairs for migration, even though it looks heavier weight.
>=20
> This diff would address both points, and maybe fix Matthew's issue,
> although I haven't done much real testing on it other than a quick
> run of run_vmtests.sh:

It looks like lru_cache_disable() is using synchronize_rcu_expedited(),
which whould be a huge performance killer?

From the migrate code it looks like it's calling lru_add_drain_all()
once only, because migration is still best effort, so it's accepting
failures if someone adds pages to the per-cpu lru_add structures,
rather than wanting to take the heavy performance loss of
lru_cache_disable().

The problem at hand is also solved if we move the lru_add_drain_all()
out of the page-locked region in migrate_vma_setup(), like if we hit a
system folio not on the LRU, we'd unlock all folios, call
lru_add_drain_all() and retry from start.

But the root cause, even though lru_add_drain_all() is bad-behaving, is
IMHO the trylock spin in hmm_range_fault(). This is relatively recently
introduced to avoid another livelock problem, but there were other
fixes associated with that as well, so might not be strictly necessary.

IIRC he original non-trylocking code in do_swap_page() first took a
reference to the folio, released the page-table lock and then performed
a sleeping folio lock. Problem was that if the folio was already locked
for migration, that additional folio refcount would block migration
(which might not be a big problem considering do_swap_page() might want
to migrate to system ram anyway). @Matt Brost what's your take on this?

I'm also not sure a folio refcount should block migration after the
introduction of pinned (like in pin_user_pages) pages. Rather perhaps a
folio pin-count should block migration and in that case do_swap_page()
can definitely do a sleeping folio lock and the problem is gone.

But it looks like an AR for us to try to check how bad
lru_cache_disable() really is. And perhaps compare with an
unconditional lru_add_drain_all() at migration start.

Does anybody know who would be able to tell whether a page refcount
still should block migration (like today) or whether that could
actually be relaxed to a page pincount?

Thanks,
Thomas

>=20
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 23379663b1e1..3c55a766dd33 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -570,7 +570,6 @@ static unsigned long
> migrate_device_unmap(unsigned long *src_pfns,
> =C2=A0	struct folio *fault_folio =3D fault_page ?
> =C2=A0		page_folio(fault_page) : NULL;
> =C2=A0	unsigned long i, restore =3D 0;
> -	bool allow_drain =3D true;
> =C2=A0	unsigned long unmapped =3D 0;
> =C2=A0
> =C2=A0	lru_add_drain();
> @@ -595,12 +594,6 @@ static unsigned long
> migrate_device_unmap(unsigned long *src_pfns,
> =C2=A0
> =C2=A0		/* ZONE_DEVICE folios are not on LRU */
> =C2=A0		if (!folio_is_zone_device(folio)) {
> -			if (!folio_test_lru(folio) && allow_drain) {
> -				/* Drain CPU's lru cache */
> -				lru_add_drain_all();
> -				allow_drain =3D false;
> -			}
> -
> =C2=A0			if (!folio_isolate_lru(folio)) {
> =C2=A0				src_pfns[i] &=3D ~MIGRATE_PFN_MIGRATE;
> =C2=A0				restore++;
> @@ -759,11 +752,15 @@ int migrate_vma_setup(struct migrate_vma *args)
> =C2=A0	args->cpages =3D 0;
> =C2=A0	args->npages =3D 0;
> =C2=A0
> +	lru_cache_disable();
> +
> =C2=A0	migrate_vma_collect(args);
> =C2=A0
> =C2=A0	if (args->cpages)
> =C2=A0		migrate_vma_unmap(args);
> =C2=A0
> +	lru_cache_enable();
> +
> =C2=A0	/*
> =C2=A0	 * At this point pages are locked and unmapped, and thus
> they have
> =C2=A0	 * stable content and can safely be copied to destination
> memory that
> @@ -1395,6 +1392,8 @@ int migrate_device_range(unsigned long
> *src_pfns, unsigned long start,
> =C2=A0{
> =C2=A0	unsigned long i, j, pfn;
> =C2=A0
> +	lru_cache_disable();
> +
> =C2=A0	for (pfn =3D start, i =3D 0; i < npages; pfn++, i++) {
> =C2=A0		struct page *page =3D pfn_to_page(pfn);
> =C2=A0		struct folio *folio =3D page_folio(page);
> @@ -1413,6 +1412,8 @@ int migrate_device_range(unsigned long
> *src_pfns, unsigned long start,
> =C2=A0
> =C2=A0	migrate_device_unmap(src_pfns, npages, NULL);
> =C2=A0
> +	lru_cache_enable();
> +
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0EXPORT_SYMBOL(migrate_device_range);
> @@ -1429,6 +1430,8 @@ int migrate_device_pfns(unsigned long
> *src_pfns, unsigned long npages)
> =C2=A0{
> =C2=A0	unsigned long i, j;
> =C2=A0
> +	lru_cache_disable();
> +
> =C2=A0	for (i =3D 0; i < npages; i++) {
> =C2=A0		struct page *page =3D pfn_to_page(src_pfns[i]);
> =C2=A0		struct folio *folio =3D page_folio(page);
> @@ -1446,6 +1449,8 @@ int migrate_device_pfns(unsigned long
> *src_pfns, unsigned long npages)
> =C2=A0
> =C2=A0	migrate_device_unmap(src_pfns, npages, NULL);
> =C2=A0
> +	lru_cache_enable();
> +
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0EXPORT_SYMBOL(migrate_device_pfns);
>=20
>=20
>=20
>=20
> thanks,

