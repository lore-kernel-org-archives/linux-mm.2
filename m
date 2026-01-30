Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53401E6BF39
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 19:56:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 519CF6B0088; Fri, 30 Jan 2026 14:56:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49CD16B0089; Fri, 30 Jan 2026 14:56:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A8ED6B008A; Fri, 30 Jan 2026 14:56:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2B80D6B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 14:56:41 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B5EF11406DB
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 19:56:40 +0000 (UTC)
X-FDA: 84389687760.17.8AC566F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf25.hostedemail.com (Postfix) with ESMTP id CD524A0006
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 19:56:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GdiWQHry;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769802998; a=rsa-sha256;
	cv=none;
	b=tBHk0pWzlhBrUob8yyCjVxRzCaX17tgfGWnk6mn4hg823MslFadurmPs8earNJRuqHNShi
	/SlG+BJM2gvCCI4zP1mFLUrN6pzX6eNJmlUCb/UD8maz4fAXd61+oPdcmf2QrfzOcMl5Jz
	e6gEorGXebKkAmRj/XzklBp2Zza54Ic=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GdiWQHry;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769802998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M44fOx6FNQYPjEqcJJZHN8cHNALOFrmA6XG3KTJNz3I=;
	b=Y7FKVPbd+hgdzC5VZ2IgyITfdUoDaLHI9nvPd3jM7GKQo6KpgfRZfPYQ90ZJfb0hnzniZX
	5t4nQBzhgGv7qvdPZ++YGjW1oIuCWzssINdpCHOm7JM8Nf08GzlFBw4yhiJY4avmdbf5ks
	MZijPv/iaOs6D7P8xNQaorzagR1eyJg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769802998; x=1801338998;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=worejeHHsq1ziRWfoviB7RGwOnlqO7vcDzzLdGwlVXo=;
  b=GdiWQHry9FEyKbkKzu1eMwy5uxGuE1fvDWjJMiVGTHgWFPfKgp0yVvUj
   jgbBigZMpPT7zYTzQvgebHaRbOCa8Bjdi1RQFVoWNxIjeQ9/UW91CYgsi
   jF/arLfia/acFY88h/LN8ZYhGTcZWbIlaEXaVZ9QDfrKI8yqgAO/SOxeh
   9pwe4Ub8xQUT6LIPORMkL3Y2PA6Tb4nhgUi5fwPVekYfCQClrpKYI0Re5
   B/tk7PdHA1sX/8tSFUfUX07KVeuk+BPoEePGS1EVIujD9SzQ0F3Wgseq/
   sI85SSi5fQ5Lua/h2DjY3W0TEo/y476gNzIbvsfpek1ILO2oT7tqcNMHs
   g==;
X-CSE-ConnectionGUID: LiYHzYruTIWXWNqXtxEdwQ==
X-CSE-MsgGUID: BsZJ123/SPyGgzg19FQybQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11687"; a="70776044"
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="70776044"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 11:56:37 -0800
X-CSE-ConnectionGUID: nM5QeG7ATpaADUZTOayMgQ==
X-CSE-MsgGUID: 9tIorAgaQku43phLFmJqtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="208735691"
Received: from rvuia-mobl.ger.corp.intel.com (HELO [10.245.244.13]) ([10.245.244.13])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 11:56:33 -0800
Message-ID: <b9dd97e7d9e62ebc33c4dfef53a9fd3f51352d3a.camel@linux.intel.com>
Subject: Re: [PATCH] mm/hmm: Fix a hmm_range_fault() livelock / starvation
 problem
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: intel-xe@lists.freedesktop.org, Ralph Campbell <rcampbell@nvidia.com>, 
 Christoph Hellwig	 <hch@lst.de>, Jason Gunthorpe <jgg@mellanox.com>, Jason
 Gunthorpe <jgg@ziepe.ca>,  Leon Romanovsky	 <leon@kernel.org>, Matthew
 Brost <matthew.brost@intel.com>, linux-mm@kvack.org, 
	stable@vger.kernel.org, dri-devel@lists.freedesktop.org
Date: Fri, 30 Jan 2026 20:56:31 +0100
In-Reply-To: <20260130100013.fb1ce1cd5bd7a440087c7b37@linux-foundation.org>
References: <20260130144529.79909-1-thomas.hellstrom@linux.intel.com>
	 <20260130100013.fb1ce1cd5bd7a440087c7b37@linux-foundation.org>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CD524A0006
X-Stat-Signature: dqytoiqsscwf11u4zxmd4p86jum95o3j
X-HE-Tag: 1769802997-497928
X-HE-Meta: U2FsdGVkX1/bA9zvQDQR2P/HIJ+G9OY7YdITT8WJ5GdpppP3CQtF4KtX5ez6Wl/HHxmkwBfr23tSEorNR6arH7AcvrdANcZ4QG8OZoQoCxPXssh7eYe1K5iCEdI/1n3fIiihyCwcfpXToqbE8tDW3wOCsLZcpuDt/0UFAXPztknfCEb6CHZxeE2anGIWGG6bjfLaXBMYT0aJO3IFp/vVI/8g4w5Zq9Edjqp85WmT2Pq6ozt67RREWtxFJShSloiIwDngHuPO1aLA4wSO7pEtc/paplXoLlNzSCpswmNiCmUZihTBqc9aWO8on9SehljhG7g5PlUCmzXXRsR/GJUv9j92ZPzcsMcLTTH7gijZ7XnNCNyhE9vpEgRFW2nEdhSFTY10uzpd8RX6oGz1oobkLIlnVCk3tdMAShu02f84U50zD+9cVazeM1pBl6CC16HuldtX7tC7ngDhY33G2OfqHlBmJ6zQTHVq1rLf52UstKBa6q+m/2KybWbp7qQaB3V8qu60Xn5i8pwx5/z+0UJjE1nYh54ODUgA407k/3avrys2lIdBzmR54Wnft/+CxM9SnGhsX9x+G4X4rMWbzI5TB3QKRdbmtY53+e6M9AchSadZdDQmeLlRaEhRPhd47rZvt3hTp15GP62C702U/iuN4R4h+PtFvBmXgCkX4TqR8y55tSvE3p52s0Q+cOCKvTPd7US4PzGik3lFvlgkJXH9ZJx5JxbSa74u/BzBBOcP/UN5s0hDbyoXcimUy2dg5t8deRTr8DgjYa0taUm+QsslTFRTpDqCZ4Q03KJEEwQl8z1PLU32B6TfEerASxCuybnWjH17MIHTgsLrJT/ei4Ht3wbdtWGgDw4phEEzBxyj0IqMtKlKlAmk9jtJQK2BHy8rG2ikASqQMfNG0DFclrIo67RQKEOrrVC01V+Q/zAC+ifDp+Ca1XdWQw9cXR0GhsrLXO9xDXOLs5qEfpXyFqp
 3eIwuoQu
 g4VVWInA0C2AlRtkptgkrAp8Vg52H12Xng+IRKBcg1h0ev0HcKmneiRvL/bjDhlLyjFheYnrvwEB/BPldWvnvSEcx9pBauvpa+9q1hmxssPEIN3eRaWoDwQBFUugvnzpj9K6z8lnRUhZgEr1+zWFiyD2h0ZQpMkghmIxHAQYjb6o7nS5+bydVCmqYKeVE67C5fMw9AtCdShgBJE4aJJt5xRGqDKDad5+u9wu79MClnqEJ15Ex3fam2tihIMUnu5wtuc1Doj1TEljFq0VmbZI/yVl0NZITj5n853huzOaUMvpN4YxiSgyc6RWRKCP/PeJ1qp44
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2026-01-30 at 10:00 -0800, Andrew Morton wrote:
> On Fri, 30 Jan 2026 15:45:29 +0100 Thomas Hellstr=C3=B6m
> <thomas.hellstrom@linux.intel.com> wrote:
>=20
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
>=20
> This is pretty bad behavior from lru_add_drain_all().
>=20
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
> > Resolve this using a cond_resched() after each iteration in
> > hmm_range_fault(). Future code improvements might consider moving
> > the lru_add_drain_all() call in migrate_device_unmap() out of the
> > folio locked region.
> >=20
> > Also, hmm_range_fault() can be a very long-running function
> > so a cond_resched() at the end of each iteration can be
> > motivated even in the absence of an -EBUSY.
> >=20
> > Fixes: d28c2c9a4877 ("mm/hmm: make full use of walk_page_range()")
>=20
> Six years ago.

Yeah, although unlikely to have been hit due to our multi-device
migration code might have been the first instance of all those
prerequisites to be fulfilled.

>=20
> > --- a/mm/hmm.c
> > +++ b/mm/hmm.c
> > @@ -674,6 +674,13 @@ int hmm_range_fault(struct hmm_range *range)
> > =C2=A0			return -EBUSY;
> > =C2=A0		ret =3D walk_page_range(mm, hmm_vma_walk.last,
> > range->end,
> > =C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &hmm_walk_ops,
> > &hmm_vma_walk);
> > +		/*
> > +		 * Conditionally reschedule to let other work
> > items get
> > +		 * a chance to unlock device-private pages whose
> > locks
> > +		 * we're spinning on.
> > +		 */
> > +		cond_resched();
> > +
> > =C2=A0		/*
> > =C2=A0		 * When -EBUSY is returned the loop restarts with
> > =C2=A0		 * hmm_vma_walk.last set to an address that has
> > not been stored
>=20
> If the process which is running hmm_range_fault() has
> SCHED_FIFO/SHCED_RR then cond_resched() doesn't work.=C2=A0 An explicit
> msleep() would be better?

Unfortunately hmm_range_fault() is typically called from a gpu
pagefault handler and it's crucial to get the gpu up and running again
as fast as possible.

Is there a way we could test for the cases where cond_resched() doesn't
work and in that case instead call sched_yield(), at least on -EBUSY
errors?

Thanks,
Thomas

