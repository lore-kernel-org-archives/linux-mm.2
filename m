Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74E43606A330
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 20:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=V46RjedJ
Received: by kanga.kvack.org (Postfix)
	id 8A3926B05B6; Fri, 13 Nov 2026 15:56:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 853326B05B7; Fri, 13 Nov 2026 15:56:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 741F56B05BA; Fri, 13 Nov 2026 15:56:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D7EC26B05B6
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:56:26 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 46A6C120182
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:56:25 +0000 (UTC)
X-FDA: 85431303930.29.2CC9A3E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8E71B140002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:56:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=V46RjedJ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794603383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AXSAbZ4zAFhDA0DT3gf9mQz9cKPQmAWHCdFOgQ2qISo=;
	b=u45dL9Uy/llrUDGzh5iGzXcc0GxrBHgARSg05ZkTMHoRvpMiAo6k7IPWYrin2JyPPK6LOR
	ovndpNDwTVBDKWwHJ0QfHhKxaUHpHyvPCRDuVyydbhYOq2gEeaQx7hSobYr6P6q05+q0II
	vSg1GV355McgziXN1eeKCEMLhXVjBFs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=V46RjedJ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794603383;
	b=KLDcKx8HSthWXQrO4oG2Iko3pAFK68nxCY67uPaP0Dt/GEv6gs27qptcKrdL6Qp3IvRQkQ
	x0Q5nX0qwfi/z1Fn2mqd0tssJnJGMkdiqbDCBNBBw/aiRlsmjcCtfb/rC5yapsBcF+YbYS
	N07AYPGI7mXm8Ko23y8WWTWboAsGfrk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794603383; x=1826139383;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=AXSAbZ4zAFhDA0DT3gf9mQz9cKPQmAWHCdFOgQ2qISo=;
  b=V46RjedJ5aU9xXdMeZu8LqzFBOyNXAzRn3yYg3J+PMqg+AHXRfgQG8ye
   wfXWwT92gPbqSzUPI25G1ICbCFSfBnwDjIj9O8DreaX5cq+RG6WiCbjNn
   lAXv1zGrFLvZx07JhM8DOVcLQqXJ1h2UwD0kKmUT5FnF7tX2Iyvay8Qzd
   8hgMMG2GIqHVdk8BDawe2j/wQevr1gHFBfM/Q3K33OeR/u5VR7IDTdCWk
   5gbpBwaSIjc48Lo3gtZFpkLxHACYwevhAkoYMMcuQUyWJU/JT2A/tvVzh
   YmSi00N7+bWOzjwzKOtcxBb4vDaO7xa/UEj8MaG4OCzetAxXFg1JXhGC8
   g==;
X-CSE-ConnectionGUID: n97PIFaPTA+TVvHgGuSZjw==
X-CSE-MsgGUID: LAybBJ6FTB+AKxkP1tSnrQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11965"; a="3312230"
X-IronPort-AV: E=Sophos;i="6.27,212,1787036400"; 
   d="scan'208";a="3312230"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 12:56:22 -0800
X-CSE-ConnectionGUID: MxmC/jBhRhOduSE8W+FTjQ==
X-CSE-MsgGUID: CSNAP3JdQu+WpkyRp59/Bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,212,1787036400"; 
   d="scan'208";a="9029453"
Received: from ettammin-mobl2.ger.corp.intel.com (HELO [10.245.244.252]) ([10.245.244.252])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 12:56:18 -0800
Message-ID: <0b794f803517c27ea818a2e894761095300b4da4.camel@linux.intel.com>
Subject: Re: [PATCH] mm/hmm: skip NUMA balancing on protnone faults
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Matthew Auld
	 <matthew.auld@intel.com>, linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, Matthew
 Brost <matthew.brost@intel.com>, Mika =?ISO-8859-1?Q?Penttil=E4?=
 <mpenttil@redhat.com>,  Leon Romanovsky	 <leon@kernel.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard	 <jhubbard@nvidia.com>
Date: Fri, 13 Nov 2026 21:56:15 +0100
In-Reply-To: <9ec3e8b9-064a-47a7-8d00-566ff371b846@kernel.org>
References: <20261112-numa-v1-1-ad9cbca8f49a@intel.com>
	 <b32fb02a-68b4-4db9-83dd-254147dbf215@kernel.org>
	 <1993e931e6a4b0cda5c04e72b1a8d5fb924f950a.camel@linux.intel.com>
	 <9ec3e8b9-064a-47a7-8d00-566ff371b846@kernel.org>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-2.fc43) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8E71B140002
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: gmg8mwoqq9z55bprmrfppmmyzasqx1or
X-HE-Tag: 1794603382-880974
X-HE-Meta: U2FsdGVkX199cWiGlzC/vQAoj3agLaYIl5tjisG0lmZmQHjTusJf3kRPZqaN3eW71n1EWBHlHVJf74YsWauPrGtkrV7Gb+fz5wVdlHy2N7GW8McQSUVgRlxs4o2Nrn0p9hpLgRyKpdXLrhA3FnOUYDaAwzoYE52qx4Ymg7wiqlUPsKRwErm1ykyFkNvYMnRyBGl5k8XhQbePcjJbld2enIa8ewjEcKCsvjWt0tk7dfN7SOw6NZ2Jfe0gvdQxJHMmj7x0oTzw/JEk1qgWv+heoChjEO3W0Jm4tSLAxE9puJCSDA/stPK6pyo6Ol9yzczZV+XHv3OkqWsIFMyj8q8nZZU9nuFAMnXAj5Smeh4jmg/ITb2YA60yllv2tBxZXndAfq+bLzBm1YRQOMnuk+wzxOU7kaRd4xdhT+gFHYJf1yERqQaBbUTAhxQnkxNDygm/tEZhwM3jgUBI7ZY5xJlBsPL9S9Q7uMO39fVQDp+TLOuLQIWl2zhBHyZr6CtfhrjHxjxh8d8Y9aZfgFWKW+MK2P5ul7rz5Uli8DaAPObpuF+Dww93ElZjHsHwuxTeH1PebR0/5N4E6aPe/B4dBoTQJpsddOU+fPeHo6Jwa/jmk+0xIJz/97Bbu8PoEmWnxsmkPvIYCodynRY4J9UG4ZiTFtJC5O36FKb+WmHWutyNPl6gdtlS5iyQgNZGSi/FuojFGm9KN3x3Q7q2r/oz//zi+dd9ZbLO0CcXP6C5hyl5osqXUPGd3kWI12cuajF5xp5GWd1QKS9j3QYQop3XJrIgPeThGWwAN/+VmI3Ue/CqYCmorXHwluHL85dyIGtnwd6C/oFepnBy+l7ps8km4u5zCH1a5ZYCqoWDYYl5WFfiUz2LGskIDT+tVwhrAzyymQ8mzFdcfehO4asrqNlXpAaFfqNEOPNoDH/SnUoNDTQC6w/wLC5/YSVZRbkm9Skv+Lnsxm0RLJ+bhykt72eGTkT
 6nYqd4v4
 Zz0NrUpycC6d2j0/zBWbc2UBMh0QwABHvknQThm37v/53ed1/iYfqYu9iJ0IqQRcLRVPiguL9mVfYsGNyDtTq8Dlk1Wc+9rN0tgsI1VTEAU/zG7pey3HyiCObZj2cX9eU3KsE9uAuG3vlcId6/nwckymHOtGF79zSAMb7zdMBFdYTwMl8UqyujwTLpNLWl9+bB4cegIDx1wJ9dDs6vez4/kwFshP+Y+N+1yugUnasUc6qFZmRJ6wIVt+aGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 2026-11-13 at 21:43 +0100, David Hildenbrand (Arm) wrote:
> On 11/13/26 21:34, Thomas Hellstr=C3=B6m wrote:
> > Hi, David
> >=20
> > On Fri, 2026-11-13 at 19:27 +0100, David Hildenbrand (Arm) wrote:
> > > On 11/13/26 17:25, Matthew Auld wrote:
> > > > When automatic NUMA balancing marks a PTE or PMD as protnone
> > > > (PAGE_NONE), hmm_pte_need_fault() requests a fault to restore
> > > > access
> > > > permissions, including _PAGE_RW when write access is needed.
> > > >=20
> > > > Calling handle_mm_fault() from hmm_do_fault() currently
> > > > triggers
> > > > NUMA
> > > > balancing in do_numa_page() and do_huge_pmd_numa_page(). When
> > > > hmm_range_fault() runs from a device driver or kworker context
> > > > (such as
> > > > a GPU SVM or userptr rebind worker), folios get migrated toward
> > > > the
> > > > CPU
> > > > node executing the remote fault.
> > > >=20
> > > > Also, each folio migration invokes try_to_migrate_one() ->
> > > > mmu_notifier_invalidate_range_start(), which invalidates the
> > > > caller's mmu_interval_notifier while holding mmap_lock. That
> > > > causes
> > > > hmm_range_fault() to abort with -EBUSY after every 2 MiB PMD
> > > > and
> > > > exhaust
> > > > its retry timeout on large buffers, which has been observed
> > > > with
> > > > large
> > > > imported Xe userptr buffers.
> > > >=20
> > > > Add FAULT_FLAG_NO_NUMA and set it in hmm_do_fault() so protnone
> > > > entries
> > > > restore PTE/PMD permissions in-place without performing NUMA
> > > > balancing,
> > > > matching GUP's default !FOLL_HONOR_NUMA_FAULT behaviour.
> > >=20
> > > Ehm, that's not how it works.
> > >=20
> > > GUP will not trigger a "special" fault and will try not
> > > triggering a
> > > fault and
> > > not restore permissions.
> > >=20
> > > It will try continuing, leaving the protnone pte as it is.
> > >=20
> > > See gup_can_follow_protnone().
> > >=20
> > > For read-only access that should always work.
> > >=20
> > > For write-access we always trigger an ordinary fault and do NUMA
> > > migration etc.
> > >=20
> > >=20
> > > So FAULT_FLAG_NO_NUMA is doing something completely different and
> > > I
> > > don't agree
> > > with it.
> > >=20
> >=20
> > There are two major problems with the current behaviour.
> >=20
> > 1) The work item executing hmm_range_fault() might have no affinity
> > at
> > all to the GPU about to access the memory.
> >=20
> > 2) If migration happens, then hmm_range_fault() will stop and retry
> > leading to excessive execution time.
> >=20
> > While perhaps Matt's commit message doesn't correctly describe the
> > GUP
> > behaviour, do you have any alternative suggestion than to avoid
> > migration in this case? I think it's a reasonable idea given the
> > problems with the current code?
>=20
> Adding fault reasons that hack around NUMA hinting such that a actual
> CPU
> accessing it later will not trigger ... NUMA hinting?
>=20
> I might be missing the "reasonable" in here :P

Wouldn't the net effect be that content stays put instead of being
migrated? In both cases a later CPU access will not trigger NUMA
hinting except that the proposed change doesn't send content to an
irrelevant node?

>=20
> I recall that John (cc) kept saying "GPUs and NUMA balancing is
> inherently
> incompatible, you have to disable NUMA balancing".

Perhaps we could force hmm_range_fault() to run on the node closest to
the GPU. Then at least the migration might be beneficial.

>=20
> You could likely implement something similar to GUP, where you would
> allow for
> bypassing protnone for reading.

We could ofc look at that. Might help in some cases.

Thanks,
Thomas


>=20
> That wouldn't give you access to the writing side. There might be
> ways to sort
> out some of the writing (similar to FOLL_FORCE handling in GUP), but
> I'd rather
> not go down that path. KVM also doesn't seem to need that.

